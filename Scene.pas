//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 1, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//

// Author: Pete Goodwin (mse@imekon.org)

unit Scene;

interface

uses
  System.Types, System.UITypes, System.JSON, System.IOUtils, System.Contnrs,
  System.SysUtils, System.Classes, System.Math, System.Generics.Defaults,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages,
  VCL.Graphics,
  VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.ComCtrls, VCL.Clipbrd,
  Vector, Texture.Manager, Texture, Matrix;

const
  d2r = pi / 180.0;
  r2d = 180.0 / pi;
  ViewSize = 1000;
  ViewDivisions = 10;
  ViewRange = 20.0;
  CameraSize = 5;
  UndoLimit = 1000;

type
  ELoadShapeError = class(Exception);

  // POVray output format
  TFormat = (fmtTargaCompressed, fmtTarga, fmtPNG, fmtPPM, fmtBMP);

  // MSE mode
  TMode = (mdSelect, mdCreate, mdTranslate, mdScale, mdScaleUniform, mdRotate,
    mdObserver, mdObserved);

  // Current view
  TView = (vwFront, vwBack, vwTop, vwBottom, vwLeft, vwRight, vwCamera);

  // Texture normal type
  TNormalType = (ntNone, ntBumps, ntDents, ntRipples, ntWaves, ntWrinkles,
    ntBumpMap);

  // Anchor type used in translation/scaling/rotation
  TAnchorType = (anTranslate, anScale, anRotate);

  TShape = class;
  TSceneManager = class;

  // A vector object with support routines
  TCoord = class(TVector)
    public
      Selected: boolean;
      Positive: boolean;      // Used for culling of triangles
                              // All three points should match
                              // after transformation
      Point: TPoint;          // Normal views
      //PX, PY, PZ: integer;    // Multiple views
      Anchor: TVector;
      Transformed: TVector;
      Normal: TVector;
      NormalDone: boolean;

      constructor Create; override;
      destructor Destroy; override;
      procedure CopyCoord(original: TCoord);
      procedure Transform(shape: TShape; var xf, yf, zf: double);
      procedure Make(scene: TSceneManager; shape: TShape);
      procedure MakeInShape(scene: TSceneManager; shape: TShape);
      procedure DrawPolygon(scene: TSceneManager; canvas: TCanvas;
        view: TView; first: boolean);
      procedure SetSelected(select: boolean);
      procedure ToggleSelected;
      procedure SetAnchor;
      procedure SetTranslate(xx, yy, zz: double; xb, yb, zb: boolean);
      procedure SetScale(xx, yy, zz: double; xb, yb, zb: boolean);
      procedure SetRotate(xx, yy, zz: double; xb, yb, zb: boolean);
    end;

  TExportOptions = class;

  // Basic triangle
  TTriangle = class
    public
      Points: array [1..3] of TCoord;
      Cull: boolean;        // Indicate this triangle should be culled
      Center, Normal: TVector;
      Selected: boolean;
      Bounding: TRect;
      Shape: TShape;
      Distance: double;

      constructor Create;
      destructor Destroy; override;
      procedure Copy(original: TTriangle);
      procedure ResetBounding;
      procedure AdjustBounding(x, y: integer);
      procedure Make(scene: TSceneManager; shape: TShape);
      procedure MakeInShape(scene: TSceneManager; shape: TShape);
      procedure Draw(canvas: TCanvas);
      procedure DrawFilled(scene: TSceneManager; canvas: TCanvas);
      procedure DrawPolygon(scene: TSceneManager; canvas: TCanvas; view: TView);
      procedure Save(const name: string; parent: TJSONArray);
      procedure SaveToFile(dest: TStream);
      procedure LoadFromFile(source: TStream);
      function HasAllSelected: boolean;
      procedure GetNormal;
      procedure GetCenter;
      procedure SetSelected(select: boolean);
      procedure SetAnchor;
      procedure SetTranslate(xx, yy, zz: double; xb, yb, zb: boolean);
      procedure SetScale(xx, yy, zz: double; xb, yb, zb: boolean);
      procedure SetRotate(xx, yy, zz: double; xb, yb, zb: boolean);
      procedure GenerateVRML(var dest: TextFile);
      procedure GenerateUDO(var dest: TextFile);
      procedure GenerateUDOInclude(var dest: TextFile);
      procedure GenerateDirectXFile(var dest: TextFile; const Options: TExportOptions);
    end;

  // Scene layers
  TLayer = class
  public
    Name: string;
    Visible, Selectable: boolean;
    constructor Create;
    procedure Save(parent: TJSONArray);
    procedure Load(obj: TJSONObject);
  end;

  // ID's of shapes
  TShapeID = (siShape, siCamera,
    siLight, siSpotLight, siCylinderLight, siAreaLight,
    siPlane, siSphere, siCube, siSolid, siPolygon, siHeightField,
    siBicubicShape, siUser, siGroup, siGallery, siDisc, siTorus,
    siSuperEllipsoid, siText, siLathe, siJuliaFractal, siReserved1,
    siReserved2, siSpring, siScripted, siEnvironment, siLastShapeID);

  // Solid type used in creation: cone and cylinder don't actually exist
  // as they are specific forms of solid
  TSolidType = (stSolid, stCone, stCylinder);

  // Types of groups
  TGroupType = (gtUnion, gtIntersection, gtDifference, gtBlob, gtMerge,
    gtGallery);

  TExtendedPoint = class
  private
    line: boolean;
    point: TPoint;
  public
    constructor Create(ALine: boolean; x, y: integer);
    procedure Draw(canvas: TCanvas);
  end;

  // Features: fixed attributes of shapes
  TShapeFeature = (sfCanTranslate, sfCanScale, sfCanRotate,
    sfCanEdit, sfCanBlob, sfCanGenerate,
    sfHasObserver, sfHasObserved);

  // Flags: user specified attributes of shapes
  TShapeFlag = (sfShadow, sfDisplay, sfHollow);

  // States: system defined attributes of shapes
  TShapeState = (ssSelected, ssSelectable);

  TShapeFeatures = set of TShapeFeature;
  TShapeFlags = set of TShapeFlag;
  TShapeStates = set of TShapeState;

  //////////////////////////////////////////////////////////////////////////////
  //  TShape
  //////////////////////////////////////////////////////////////////////////////

  TShape = class
    public
      Name: AnsiString;
      Features: TShapeFeatures;           { Fixed features }
      Flags: TShapeFlags;                 { Streamable states }
      States: TShapeStates;               { Non-streamable states }
      Triangles: TObjectList;             { list of triangles }
      GhostTriangles: TObjectList;        { alternate list of triangles }
      Parent: TShape;                     { parent instance }
      Bounding: TRect;
      Texture: TTexture;                  { texture instance }
      Layer: TLayer;                      { layer instance }
      Anchor: TVector;
      Translate: TVector;
      Scale: TVector;
      Rotate: TVector;

      // Animation list
      Animation: TObjectList;

      constructor Create; virtual;
      destructor Destroy; override;
      procedure ClearTriangles;
      function GetID: TShapeID; virtual;
      function GetDescription: string;
      function Edit: boolean; virtual;
      function GetTriangleCount: integer; virtual;
      function CheckTexture: boolean; virtual;
      procedure Info; virtual;
      function UsingTexture(text: TTexture): boolean; virtual;
      procedure Make(scene: TSceneManager; theTriangles: TList); virtual;
      procedure MakeInShape(scene: TSceneManager; shape: TShape; theTriangles: TList);
      function IsVisible(canvas: TCanvas): boolean; virtual;
      procedure DrawTexture(Scene: TSceneManager; canvas: TCanvas); virtual;
      procedure DrawSelected(Scene: TSceneManager; canvas: TCanvas); virtual;
      procedure Draw(Scene: TSceneManager; theTriangles: TList; canvas: TCanvas; Mode: TPenMode); virtual;
      procedure SetTexture(ATexture: TTexture); virtual;
      procedure SetAnchor(AnchorType: TAnchorType);
      procedure SetTranslate(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetTranslateAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetScale(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetScaleAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetUniformScaleAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetRotate(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
      procedure SetObserver(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean); virtual;
      procedure SetObserved(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean); virtual;
      function GetObserver: TVector; virtual;
      function GetObserved: TVector; virtual;
      procedure AddTriangle(i, j, k: TVector);
      procedure ResetTriangleSelection;
      procedure Save(parent: TJSONArray); virtual;
      procedure SaveToFile(dest: TStream); virtual;
      procedure Load(obj: TJSONObject); virtual;
      procedure LoadFromFile(source: TStream); virtual;
      procedure GenerateDetails(var dest: TextFile); virtual;
      procedure Generate(var dest: TextFile); virtual;
      procedure GenerateCoolRay(var dest: TextFile); virtual;
      procedure GenerateCoolRayDetails(var dest: TextFile); virtual;
      procedure GenerateCoolRayTexture(var dest: TextFile); virtual;
      procedure GenerateVRML(var dest: TextFile); virtual;
      procedure GenerateVRML2(var dest: TextFile); virtual;
      procedure GenerateVRMLDetails(var dest: TextFile); virtual;
      procedure GenerateVRMLTriangles(var dest: TextFile);
      procedure GenerateUDO(var dest: TextFile); virtual;
      procedure GenerateUDOInclude(var dest: TextFile); virtual;
      procedure GenerateDirectXFile(var dest: TextFile; const Options: TExportOptions); virtual;
      procedure GenerateBlob(var dest: TextFile); virtual;
      function CreateQuery: boolean; virtual;
      procedure Details; virtual;
      procedure Copy(original: TShape); virtual;
      function BuildTree(tree: TTreeView; node: TTreeNode): TTreeNode; virtual;
      procedure GetNormal;
      function FindTopParent: TShape;
      procedure TransformationMatrix(matrix: TMatrix);
    end;

  TShapeType = class of TShape;

  TProjectionType = (ptPerspective, ptOrthographic, ptFisheye,
    ptUltraWideAngle, ptOmnimax, ptPanoramic, ptCylinder);

  TCamera = class(TShape)
  public
    ProjectionType: TProjectionType;
    Angle: TVector;
    Observer, Observed: TCoord;
    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    function CheckTexture: boolean; override;
    procedure SetObserver(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean); override;
    procedure SetObserved(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean); override;
    function GetObserver: TVector; override;
    function GetObserved: TVector; override;
    procedure Draw(Scene: TSceneManager; theTriangles: TList; canvas: TCanvas; Mode: TPenMode); override;
    procedure Make(scene: TSceneManager; theTriangles: TList); override;
    procedure Save(parent: TJSONArray); override;
    procedure SaveToFile(dest: TStream); override;
    procedure Load(obj: TJSONObject); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure GenerateVRML(var dest: TextFile); override;
    procedure GenerateCoolRay(var dest: TextFile); override;
    procedure Details; override;
    procedure CalculateAngle;
  end;

  TAtmosphereType = (atNone,
    atIsotropic,
    atMIEHazy,
    atMIEMurky,
    atRayleigh,
    atHenyeyGreenstein);

  TAtmosphereSettings = class
  public
    AtmosphereType: TAtmosphereType;
    Distance: double;
    Scattering: double;
    Eccentricity: double;
    Samples: integer;
    Jitter: integer;
    Threshold: double;
    Level: double;
    Red, Green, Blue: double;

    constructor Create;
    procedure Save(parent: TJSONArray);
    procedure SaveToFile(stream: TStream);
    procedure LoadFromFile(stream: TStream);
  end;

  TFogType = (ftNormal, ftGround);

  TFog = class
  public
    FogType: TFogType;
    Distance: double;
    Red, Green, Blue: double;
    Turbulence: double;
    TurbulenceDepth: double;
    Omega: double;
    Lambda: double;
    Octaves: integer;
    Offset: double;
    Alt: double;

    constructor Create;
    procedure Save(parent: TJSONArray);
    procedure SaveToFile(stream: TStream);
    procedure LoadFromFile(stream: TStream);
  end;

  TTransform = class
  public
    Name: String;
    Translate: TVector;
    Scale: TVector;
    Rotate: TVector;

    constructor Create;
    destructor Destroy; override;
  end;

  TUndoType = (utCreateShape, utDeleteShape, utApplyTexture, utTransformShape,
    utTranslateShape, utScaleShape, utRotateShape, utObserverShape,
    utObservedShape);

  TUndo = class
  public
    UndoType: TUndoType;
    Shape: TShape;
    Previous, Details: Pointer;

    constructor Create(AType: TUndoType; AShape: TShape; APrev, ADetail: Pointer);
  end;

  TExportOptionsAxis = (eoaNone, eoaSwapXY, eoaSwapYZ, eoaSwapXZ);

  TExportOptions = class
  public
    Axis: TExportOptionsAxis;
    Scaling: double;

    constructor Create;
  end;

  // File
  TScriptFile = class
  private
    FName: AnsiString;
    FDescription: AnsiString;
    FProperties: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(const name: string);
    procedure Save(parent: TJSONArray); overload;
    procedure Save(const name: string); overload;
    procedure Edit;
  end;

  TTriangleComparer = class(TInterfacedObject, IComparer<TTriangle>)
  public
    function Compare(const t1, t2: TTriangle): Integer;
  end;


  //////////////////////////////////////////////////////////////////////////////
  //  TSceneManager
  //////////////////////////////////////////////////////////////////////////////

  TSceneManager = class
  private
    { Private declarations }
    Modified: boolean;
    HiddenLineRemoval: boolean;
    LightShading: boolean;
    Outline: boolean;
    Mode: TMode;
    UniformScaling: boolean;
    CreateWhat: TShapeType;
    CreateWhatSolid: TSolidType;
    CreateWhatScripted: TShapeID;
    View: TView;
    Current: TShape;
    CurrentCamera: TCamera;
    CurrentLayer: TLayer;
    Grid: double;
    ScaleMult, ScaleDiv: integer;
    AnchorPoint: TVector;

    AtmosphereSettings: TAtmosphereSettings;
    Fog: TFog;

    // Undo item for dragging
    UndoDrag: TUndo;

    ZBuffer: TList<TTriangle>;
    UndoIndex: integer;
    UndoBuffer: TList<TUndo>;

    ScriptFiles: TList<TScriptFile>;       // Cache of script files

    procedure AdjustPoint(X, Y: integer;
      var point: TPoint;
      var xx, yy, zz: double;
      var xb, yb, zb: boolean);
    procedure Anchor;
    procedure CalculateSetRotation(xx, yy, zz: double);
    function UsingTexture(texture: TTexture): boolean;
    procedure CalculateZBuffer(list: TList<TTriangle>);
  public
    { Public declarations }
    class var SceneManager: TSceneManager;
    FileVersion: integer;
    Shapes: TObjectList<TShape>;
    Layers: TObjectList<TLayer>;
    CreateExtrusion: boolean;
    AnimationPosition: Cardinal;

    constructor Create;
    destructor Destroy; override;

    function CreateShape(AType: TShapeType; const Name: string; x, y, z: double): TShape;

    function IsModified: boolean;
    function CountSelected: integer;
    function HasMultipleSelected: boolean;
    procedure SetModified;
    procedure Empty;
    procedure Make;
    procedure Draw(canvas: TCanvas);
    procedure Print(canvas: TCanvas);
    procedure SetMode(AMode: TMode);
    function GetMode: TMode;
    procedure SetUniformScaling(scaling: boolean);
    function GetUniformScaling: boolean;
    procedure SetCreateWhat(AType: TShapeType);
    procedure SetCreateSolid(AType: TSolidType);
    procedure SetCreateScripted(AType: TShapeID);
    function GetCreateWhat: TShapeType;
    procedure SetView(AView: TView);
    function GetView: TView;
    procedure SetCurrent(shape: TShape);
    procedure SetMultiple(shape: TShape);
    function GetCurrent: TShape;
    procedure SetCamera(camera: TCamera);
    function GetCamera: TCamera;
    procedure SetGrid(value: double);
    function GetGrid: double;
    procedure SetScale(mult, divisor: integer);
    procedure GetScale(var mult, divisor: integer);
    procedure SetCurrentLayer(layer: TLayer);
    function GetCurrentLayer: TLayer;
    procedure ScaleUp;
    procedure ScaleDown;

    function AddUndo(AType: TUndoType; AShape: TShape; APrev, ADetail: Pointer): TUndo;
    function CanUndo: boolean;
    function CanRedo: boolean;
    function Undo: boolean;

    procedure MouseDown(Shift: TShiftState; X, Y: integer);
    procedure MouseMove(X, Y: integer);
    function DragOver(X, Y: integer): boolean;
    procedure EndDrag;

    procedure Save(const filename: string);
    procedure SaveToFile(const Name: string);
    function LoadShape(obj: TJSONObject): TShape; overload;
    function LoadShape(source: TStream): TShape; overload;
    procedure Load(obj: TJSONObject);
    procedure LoadFromFile(const Name: string);
    procedure GenerateV30(const Name: string);
    procedure GenerateCoolRay(const Name: string);
    procedure GenerateVRML(const Name: string);
    procedure GenerateVRML2(const Name: string);
    procedure GenerateUDO(const Name: string);
    procedure GenerateDirectX(const Name: string; const Options: TExportOptions);
    procedure ImportRAW(const Name: string);

    procedure SetTexture(ATexture: TTexture);
    procedure DeleteShape(shape: TShape);
    procedure DeleteSelected;
    function Delete: boolean;
    function CutSelected: boolean;
    procedure CopySelected;
    procedure Paste(multiple: boolean);

    procedure CreateGroup(AType: TGroupType);
    procedure CreateBlob;
    function CreateGallery: TShape;
    procedure SelectAll;
    procedure Clear;
    function GetHiddenLineRemoval: boolean;
    function ToggleHiddenLineRemoval: boolean;
    function GetLightShading: boolean;
    function ToggleLightShading: boolean;
    function GetOutline: boolean;
    function ToggleOutline: boolean;
    function FindCamera(const name: string): TCamera;
    function FindLayer(const name: string): TLayer;

    function CheckShapeTexture: boolean;

    function FindScriptFile(const name: string): TScriptFile;

    procedure NextFrame;

    class function CreateShapeFromID(ID: TShapeID): TShape;
    class procedure Initialise;
    class procedure Shutdown;
  end;

const
  BasicFeatures = [sfCanTranslate, sfCanScale, sfCanRotate];
  StandardFeatures = BasicFeatures + [sfCanGenerate];
  StandardBlobFeatures = StandardFeatures + [sfCanBlob];

  ShapeImages: array [siShape..siLastShapeID] of integer =
    (0, 1, 2, 2, 2,
     2, 3, 4, 5, 6,
     7, 8, 9, 10, 11,
     12, 13, 14, 15, 16,
     0, 0, 0, 0, 0, 0, 0, 0);

  ShapeDescriptions: array [siShape..siLastShapeID] of string =
    ('Shape', 'Camera', 'Light', 'SpotLight', 'CylinderLight', 'AreaLight',
     'Plane', 'Sphere', 'Cube', 'Solid', 'Polygon', 'HeightField',
     'BicubicShape', 'User', 'Group', 'Gallery', 'Disc', 'Torus',
     'SuperEllipsoid', 'Text', 'Lathe', 'JuliaFractal', 'Reserved1',
     'Reserved2', 'Spring', 'Scripted', 'Environment', 'LastShape');

procedure RotatePointX(xf, yf, zf: double; var xt, yt, zt: double; angle: double);
procedure RotatePointY(xf, yf, zf: double; var xt, yt, zt: double; angle: double);
procedure RotatePointZ(xf, yf, zf: double; var xt, yt, zt: double; angle: double);

implementation

uses Main, Solid, Polygon, Light, Plane, Sphere, Cube, shapeinfo, impdlg,
  user, misc, htfld, group, cregal, camdlg, Bicubic, Disc, Torus, super,
  text, pastedlg, julia, printers, spring, scripted, scrfildlg, env;

////////////////////////////////////////////////////////////////////////////////
// COORD

constructor TCoord.Create;
begin
  inherited Create;
  Selected := False;
  Positive := False;
  Point.X := 0;
  Point.Y := 0;
  //PX := 0;
  //PY := 0;
  //PZ := 0;
  Anchor := TVector.Create;
  Transformed := TVector.Create;
  Normal := TVector.Create;
  NormalDone := False;
end;

destructor TCoord.Destroy;
begin
  Anchor.Free;
  Transformed.Free;
  Normal.Free;
  inherited Destroy;
end;

procedure TCoord.CopyCoord(original: TCoord);
begin
  x := original.x;
  y := original.y;
  z := original.z;

  Transformed.x := original.Transformed.x;
  Transformed.y := original.Transformed.y;
  Transformed.z := original.Transformed.z;
end;

procedure RotatePointX(xf, yf, zf: double; var xt, yt, zt: double; angle: double);
var
  cosx, sinx: double;

begin
  cosx := cos(angle);
  sinx := sin(angle);

  yt := yf * cosx + zf * sinx;
  zt := zf * cosx - yf * sinx;
end;

procedure RotatePointY(xf, yf, zf: double; var xt, yt, zt: double; angle: double);
var
  cosy, siny: double;

begin
  cosy := cos(angle);
  siny := sin(angle);

  xt := xf * cosy - zf * siny;
  zt := xf * siny + zf * cosy;
end;

procedure RotatePointZ(xf, yf, zf: double; var xt, yt, zt: double; angle: double);
var
  cosz, sinz: double;

begin
  cosz := cos(angle);
  sinz := sin(angle);

  xt := xf * cosz + yf * sinz;
  yt := yf * cosz - xf * sinz;
end;

procedure TCoord.Transform(shape: TShape; var xf, yf, zf: double);
var
  xt, yt, zt: double;

begin
  X := xf;
  Y := yf;
  Z := zf;

  while shape <> nil do
  begin
    if sfCanScale in shape.Features then
    begin
      xf := xf * shape.Scale.X;
      yf := yf * shape.Scale.Y;
      zf := zf * shape.Scale.Z;
    end;

    if sfCanRotate in shape.Features then
    begin
      { rotate about z axis }
      RotatePointZ(xf, yf, zf, xt, yt, zt, d2r * shape.Rotate.Z);

      {cosz := cos(d2r * shape.Rotate.Z);
      sinz := sin(d2r * shape.Rotate.Z);
      xt := xf * cosz + yf * sinz;
      yt := yf * cosz - xf * sinz;}
      xf := xt;
      yf := yt;

      { rotate about y axis }
      RotatePointY(xf, yf, zf, xt, yt, zt, d2r * shape.Rotate.Y);

      {cosy := cos(d2r * shape.Rotate.Y);
      siny := sin(d2r * shape.Rotate.Y);
      xt := xf * cosy - zf * siny;
      zt := xf * siny + zf * cosy;}
      xf := xt;
      zf := zt;

      { rotate about x axis }
      RotatePointX(xf, yf, zf, xt, yt, zt, d2r * shape.Rotate.X);

      {cosx := cos(d2r * shape.Rotate.X);
      sinx := sin(d2r * shape.Rotate.X);
      yt := yf * cosx + zf * sinx;
      zt := zf * cosx - yf * sinx;}
      yf := yt;
      zf := zt;
    end;

    if sfCanTranslate in shape.Features then
    begin
        xf := xf + shape.Translate.X;
        yf := yf + shape.Translate.Y;
        zf := zf + shape.Translate.Z;
    end;

    shape := shape.Parent;
  end;
end;

procedure TCoord.Make(scene: TSceneManager; shape: TShape);
var
  xx, yy, zz: integer;
  xf, yf, zf: double;
  xt, yt, zt, sign: double;

begin
  xf := X;
  yf := Y;
  zf := Z;

  Positive := false;      // Assume -ve for now

  Transform(shape, xf, yf, zf);

  if Scene.View = vwCamera then
  begin
    if Scene.CurrentCamera <> nil then
    begin
        { Calculate angles }
        with Scene.CurrentCamera do
        begin
          {sinx := sin(Angle.X);
          siny := sin(Angle.Y);
          cosx := cos(Angle.X);
          cosy := cos(Angle.Y);}

      	  { Calculate sign of observer relative to observed point }
          sign := Observed.Z - Observer.Z;

          { Translate world so observer becomes origin }
          xf := xf - Observer.X;
          yf := yf - Observer.Y;
          zf := zf - Observer.Z;
        end;

        { Rotate about y axis }
        RotatePointY(xf, yf, zf, xt, yt, zt, Scene.CurrentCamera.Angle.Y);

        {xt := cosy * xf - siny * zf;
        zt := siny * xf + cosy * zf;}
        xf := xt;
        zf := zt;

        { Rotate about x axis }
        RotatePointX(xf, yf, zf, xt, yt, zt, Scene.CurrentCamera.Angle.X);

        {yt := cosx * yf + sinx * zf;
        zt := cosx * zf - sinx * yf;}
        yf := yt;
        zf := zt;

        Transformed.x := xf;
        Transformed.y := yf;
        Transformed.z := zf;

        { Calculate perspective }
        if (zf < -2) and (sign < 0) then
        begin
          Positive := false;  // -ve Z difference
          xt := -xf * ViewSize / zf;
          yt := yf * ViewSize / zf;
        end
        else if (zf > 2) and (sign > 0) then
        begin
          Positive := true;   // +ve Z difference
          xt := xf * ViewSize / zf;
          yt := yf * ViewSize / zf;
        end;

        xf := xt / 2;
        yf := yt / 2;

        Point.X := trunc(xf);
        Point.Y := trunc(-yf);
    end
  end
  else
  begin
  Transformed.x := xf;
  Transformed.y := yf;
  Transformed.z := zf;

  xx := trunc((xf * ViewSize) / ViewRange);
  yy := trunc((yf * ViewSize) / ViewRange);
  zz := trunc((zf * ViewSize) / ViewRange);

  case scene.View of
    vwFront:
      begin
        Point.x := xx;
        Point.y := -yy;
      end;

    vwBack:
      begin
        Point.x := -xx;
        Point.y := -yy;
      end;

    vwTop:
      begin
        Point.x := xx;
        Point.y := -zz;
      end;

    vwBottom:
      begin
        Point.x := xx;
        Point.y := zz;
      end;

    vwLeft:
      begin
        Point.x := -zz;
        Point.y := -yy;
      end;

    vwRight:
      begin
        Point.x := zz;
        Point.y := -yy;
      end;
    end;

    if scene.ScaleMult <> scene.ScaleDiv then
    begin
      Point.x := (Point.x * scene.ScaleMult) div scene.ScaleDiv;
      Point.y := (Point.y * scene.ScaleMult) div scene.ScaleDiv;
    end;
  end;

  { adjust bounding box }
  while shape.Parent <> nil do
    shape := shape.Parent;

  if Point.X < shape.Bounding.Left then
    shape.Bounding.left := Point.X - 1;

  if Point.X >= shape.Bounding.right then
    shape.Bounding.right := Point.X + 1;

  if Point.Y < shape.Bounding.top then
    shape.Bounding.top := Point.Y - 1;

  if Point.Y >= shape.Bounding.bottom then
    shape.Bounding.bottom := Point.y + 1;
end;

procedure TCoord.MakeInShape(scene: TSceneManager; shape: TShape);
begin
end;

procedure TCoord.DrawPolygon(scene: TSceneManager; canvas: TCanvas;
  view: TView; first: boolean);
var
  xx, yy: integer;

begin
  xx := 0;
  yy := 0;

  case scene.View of
    vwFront:
      begin
      xx := trunc((x * ViewSize) / ViewRange);
      yy := trunc(-(y * ViewSize) / ViewRange);
      end;

    vwBack:
      begin
      xx := trunc(-(x * ViewSize) / ViewRange);
      yy := trunc(-(y * ViewSize) / ViewRange);
      end;

    vwTop:
      begin
      xx := trunc((x * ViewSize) / ViewRange);
      yy := trunc(-(z * ViewSize) / ViewRange);
      end;

    vwBottom:
      begin
      xx := trunc((x * ViewSize) / ViewRange);
      yy := trunc((z * ViewSize) / ViewRange);
      end;

    vwLeft:
      begin
      xx := trunc(-(z * ViewSize) / ViewRange);
      yy := trunc(-(y * ViewSize) / ViewRange);
      end;

    vwRight:
      begin
      xx := trunc((z * ViewSize) / ViewRange);
      yy := trunc(-(y * ViewSize) / ViewRange);
      end;
    end;

    if first then
      Canvas.MoveTo(xx + ViewSize, yy + ViewSize)
    else
      Canvas.LineTo(xx + ViewSize, yy + ViewSize);

    with canvas do
      if Selected then
        begin
        Pen.Color := clRed;
        Rectangle(xx - 3 + ViewSize, yy - 3 + ViewSize, xx + 3 + ViewSize, yy + 3 + ViewSize);
        end;
end;

procedure TCoord.SetSelected(select: boolean);
begin
  Selected := select;
end;

procedure TCoord.ToggleSelected;
begin
  Selected := not Selected;
end;

procedure TCoord.SetAnchor;
begin
  Anchor.X := x;
  Anchor.Y := y;
  Anchor.Z := z;
end;

procedure TCoord.SetTranslate(xx, yy, zz: double; xb, yb, zb: boolean);
begin
  if Selected then
  begin
    if xb then X := Anchor.X + xx;
    if yb then Y := Anchor.Y + yy;
    if zb then Z := Anchor.Z + zz;
  end;
end;

procedure TCoord.SetScale(xx, yy, zz: double; xb, yb, zb: boolean);
begin
  if Selected then
  begin
    if xb then X := Anchor.X * abs(xx + 1);
    if yb then Y := Anchor.Y * abs(yy + 1);
    if zb then Z := Anchor.Z * abs(zz + 1);
  end;
end;

procedure TCoord.SetRotate(xx, yy, zz: double; xb, yb, zb: boolean);
begin
  if Selected then
  begin
    if xb and yb then
    begin
      RotatePointZ(Anchor.x,
        Anchor.y,
        Anchor.z,
        x,
        y,
        z,
        zz);
    end;

    if xb and zb then
    begin
      RotatePointY(Anchor.x,
        Anchor.y,
        Anchor.z,
        x,
        y,
        z,
        yy);
    end;

    if yb and zb then
    begin
      RotatePointX(Anchor.x,
        Anchor.y,
        Anchor.z,
        x,
        y,
        z,
        xx);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TRIANGLE

constructor TTriangle.Create;
begin
  Points[1] := TCoord.Create;
  Points[2] := TCoord.Create;
  Points[3] := TCoord.Create;
  Center := TVector.Create;
  Normal := TVector.Create;
  Selected := False;
  Shape := nil;
end;

destructor TTriangle.Destroy;
begin
  Points[1].Free;
  Points[2].Free;
  Points[3].Free;
  Center.Free;
  Normal.Free;

  inherited;
end;

procedure TTriangle.Copy(original: TTriangle);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].Copy(original.Points[i])
end;

procedure TTriangle.ResetBounding;
begin
  Bounding.left := ViewSize;
  Bounding.right := -ViewSize;
  Bounding.top := ViewSize;
  Bounding.bottom := -ViewSize;
end;

procedure TTriangle.AdjustBounding(x, y: integer);
begin
  if Bounding.left > x then
    Bounding.left := x;

  if Bounding.right < x then
    Bounding.right := x;

  if Bounding.top > y then
    Bounding.top := y;

  if Bounding.bottom < y then
    Bounding.bottom := y;
end;

procedure TTriangle.Make(scene: TSceneManager; shape: TShape);
var
  i: integer;

begin
  // Assume we're not going to be culled
  cull := false;

  // Make the coord
  for i := 1 to 3 do
    Points[i].Make(scene, shape);

  // If view is perspective...
  if scene.View = vwCamera then
  begin
    // Unless all the Z signs of each point match...
    if (Points[1].Positive = Points[2].Positive) and
      (Points[1].Positive = Points[3].Positive) then
      cull := false
    else
      cull := true; // ...then cull it!
  end;
end;

procedure TTriangle.MakeInShape(scene: TSceneManager; shape: TShape);
begin
end;

procedure TTriangle.Draw(canvas: TCanvas);
begin
  if not cull then
    with Canvas do
    begin
      MoveTo(Points[1].Point.X + ViewSize, Points[1].Point.Y + ViewSize);
      LineTo(Points[2].Point.X + ViewSize, Points[2].Point.Y + ViewSize);
      LineTo(Points[3].Point.X + ViewSize, Points[3].Point.Y + ViewSize);
      LineTo(Points[1].Point.X + ViewSize, Points[1].Point.Y + ViewSize);
    end;
end;

procedure TTriangle.DrawFilled(scene: TSceneManager; canvas: TCanvas);
var
  i: integer;
  texture: TTexture;
  pts: array [1..3] of TPoint;
  r, g, b, n: double;

begin
  canvas.Pen.Color := clBlack;

  if scene.Outline then
    canvas.Pen.Style := psSolid
  else
    canvas.Pen.Style := psClear;

  if Shape <> nil then
  begin
    texture := Shape.Texture;
    if texture <> nil then
    begin
      if scene.LightShading then
      begin
        n := abs(Normal.Z);

        if n > 1 then n := 1;

        r := texture.Red * n;
        g := texture.Green * n;
        b := texture.Blue * n;

        canvas.Brush.Color := PALETTERGB(trunc(r * 255), trunc(g * 255), trunc(b * 255));
      end
      else
        canvas.Brush.Color := texture.GetPaletteRGB;
    end
    else
      canvas.Brush.Color := clWhite;
  end
  else
    canvas.Brush.Color := clWhite;

  for i := 1 to 3 do
  begin
    pts[i].x := Points[i].Point.X + ViewSize;
    pts[i].y := Points[i].Point.Y + ViewSize;
  end;

  canvas.Polygon(pts);
end;

procedure TTriangle.DrawPolygon(scene: TSceneManager; canvas: TCanvas; view: TView);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].DrawPolygon(scene, canvas, view, i = 0);

  Points[1].DrawPolygon(scene, canvas, view, False);
end;

procedure TTriangle.Save(const name: string; parent: TJSONArray);
var
  i: integer;
  child: TJSONObject;

begin
  for i := 1 to 3 do
  begin
    child := TJSONObject.Create;
    Points[i].Save(name + IntToStr(i + 1), child);
    parent.Add(child);
  end;
end;

procedure TTriangle.SaveToFile(dest: TStream);
var
  i: integer;

begin
{*
  for i := 1 to 3 do
    Points[i].SaveToFile(dest);
*}
end;

procedure TTriangle.LoadFromFile(source: TStream);
var
  i: integer;

begin
{*
  for i := 1 to 3 do
    Points[i].LoadFromFile(source);
*}
end;

function TTriangle.HasAllSelected: boolean;
var
  i: integer;

begin
  result := True;
  for i := 1 to 3 do
    if not Points[i].Selected then result := False;
end;

procedure TTriangle.GetCenter;
begin
  // Center is the 'average' of all three points
  Center.x := (Points[1].Transformed.x +
    Points[2].Transformed.x +
    Points[3].Transformed.x) / 3;

  Center.y := (Points[1].Transformed.y +
    Points[2].Transformed.y +
    Points[3].Transformed.y) / 3;

  Center.z := (Points[1].Transformed.z +
    Points[2].Transformed.z +
    Points[3].Transformed.z) / 3;
end;

procedure TTriangle.GetNormal;
begin
  CalculateNormal(Normal,
    Points[1].Transformed,
    Points[2].Transformed,
    Points[3].Transformed);
end;

procedure TTriangle.SetSelected(select: boolean);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SetSelected(select);
end;

procedure TTriangle.SetAnchor;
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SetAnchor;
end;

procedure TTriangle.SetTranslate(xx, yy, zz: double; xb, yb, zb: boolean);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SetTranslate(xx, yy, zz, xb, yb, zb);
end;

procedure TTriangle.SetScale(xx, yy, zz: double; xb, yb, zb: boolean);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SetScale(xx, yy, zz, xb, yb, zb);
end;

procedure TTriangle.SetRotate(xx, yy, zz: double; xb, yb, zb: boolean);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SetRotate(xx, yy, zz, xb, yb, zb);
end;

procedure TTriangle.GenerateVRML(var dest: TextFile);
var
  i: integer;

begin
  Write(dest, '        ');
  for i := 1 to 3 do
  begin
    Write(dest, Format('%6.4f %6.4f %6.4f', [Points[i].x, Points[i].y, Points[i].z]));
    if i < 3 then Write(dest, ', ');
  end;
end;

procedure TTriangle.GenerateUDO(var dest: TextFile);
var
  i: integer;

begin
  for i := 1 to 3 do
    WriteLn(dest, Format('%6.6f %6.6f %6.6f', [Points[i].x, Points[i].z, Points[i].y]));
end;

procedure TTriangle.GenerateUDOInclude(var dest: TextFile);
var
  i: integer;

begin
  Write(dest, '  triangle { ');
  for i := 1 to 3 do
  begin
    Write(dest, Format('<%6.4f, %6.4f, %6.4f>', [Points[i].x, Points[i].y, Points[i].z]));
    if i < 3 then Write(dest, ', ');
  end;
  WriteLn(dest, ' }');
end;

procedure TTriangle.GenerateDirectXFile(var dest: TextFile; const Options: TExportOptions);
var
  i: integer;

begin
  for i := 1 to 3 do
  begin
    Write(dest, Format(' %6.4f;%6.4f;%6.4f;',
      [Points[i].x * Options.Scaling,
       Points[i].z * Options.Scaling,
       Points[i].y * Options.Scaling]));
    if i < 3 then
        WriteLn(dest, ',');
  end;
end;

{*
procedure TTriangle.GenerateDirectXForm(D3DRM: IDirect3DRM; MeshBuilder: IDirect3DRMMeshBuilder);
var
  i: integer;
  Face: IDirect3DRMFace;

begin
  MeshBuilder.CreateFace(Face);

  for i := 1 to 3 do
    Face.AddVertex(Points[i].x, Points[i].y, Points[i].z);
end;
*}

////////////////////////////////////////////////////////////////////////////////
// LAYER

constructor TLayer.Create;
begin
  Visible := True;
  Selectable := True;
end;

procedure TLayer.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  obj := TJSONObject.Create;
  obj.AddPair('name', Name);
  obj.AddPair('visible', TJSONBool.Create(Visible));
  obj.AddPair('selectable', TJSONBool.Create(Selectable));
  parent.Add(obj);
end;

procedure TLayer.Load(obj: TJSONObject);
begin
  Name := obj.GetValue('name').Value;
  Visible := obj.GetValue('visible').GetValue<boolean>;
  Selectable := obj.GetValue('selectable').GetValue<boolean>;
end;

////////////////////////////////////////////////////////////////////////////////
// EXTENDED POINT

constructor TExtendedPoint.Create(ALine: boolean; x, y: integer);
begin
  line := ALine;
  point.x := x;
  point.y := y;
end;

procedure TExtendedPoint.Draw(canvas: TCanvas);
begin
  if line then
    canvas.LineTo(point.x + ViewSize, point.y + ViewSize)
  else
    canvas.MoveTo(point.x + ViewSize, point.y + ViewSize);
end;

////////////////////////////////////////////////////////////////////////////////
// SHAPE

constructor TShape.Create;
begin
  Triangles := TObjectList.Create;
  GhostTriangles := TObjectList.Create;
  Anchor := TVector.Create;
  Translate := TVector.Create;
  Scale := TVector.Create;
  Rotate := TVector.Create;
  Scale.X := 1;
  Scale.Y := 1;
  Scale.Z := 1;

  Features := [];
  Flags := [sfShadow, sfDisplay, sfHollow];

  Parent := Nil;
  Texture := Nil;
  Layer := Nil;
  Animation := TObjectList.Create;
end;

destructor TShape.Destroy;
begin
  ClearTriangles;
  Triangles.Free;
  GhostTriangles.Free;
  Anchor.Free;
  Translate.Free;
  Scale.Free;
  Rotate.Free;
  Animation.Free;
  inherited;
end;

procedure TShape.ClearTriangles;
begin
  Triangles.Clear;
end;

function TShape.GetID: TShapeID;
begin
  result := siShape;
end;

function TShape.GetDescription: string;
begin
  result := ShapeDescriptions[GetID];
end;

function TShape.Edit: boolean;
begin
  result := False;
end;

function TShape.CheckTexture: boolean;
begin
  if Texture <> nil then
    result := true
  else
    result := false;
end;

function TShape.GetTriangleCount: integer;
begin
  result := Triangles.Count;
end;

procedure TShape.Info;
var
  dlg: TShapeInfoDlg;

begin
  dlg := TShapeInfoDlg.Create(Application);

  dlg.Name.Text := Name;

  dlg.ShapeType.Text := GetDescription;

  if Texture <> nil then
    dlg.Texture.Text := Texture.Name
  else
    dlg.Texture.Text := '<None>';

  if Layer <> nil then
    dlg.Layer.Text := Layer.Name
  else
    dlg.Layer.Text := '<Default>';

  dlg.Triangles.Text := IntToStr(GetTriangleCount);

  dlg.ShowModal;
  dlg.Free;
end;

procedure TShape.Make(scene: TSceneManager; theTriangles: TList);
var
  i: integer;
  triangle: TTriangle;

begin
  // Set empty bounding box
  if Parent = nil then
  begin
    Bounding.left := ViewSize;
    Bounding.right := -ViewSize;
    Bounding.top := ViewSize;
    Bounding.bottom := -ViewSize;
  end;

  // Walk our list of triangles
  for i := 0 to theTriangles.Count - 1 do
  begin
    triangle := theTriangles.Items[i];
    triangle.Make(scene, Self);
  end;
end;

procedure TShape.MakeInShape(scene: TSceneManager; shape: TShape; theTriangles: TList);
var
  i: integer;
  triangle: TTriangle;

begin
  // Set empty bounding box in shape
  if Parent = nil then
  with shape.Bounding do
  begin
    left := ViewSize;
    right := -ViewSize;
    top := ViewSize;
    bottom := -ViewSize;
  end;

  // Walk our list of triangles
  for i := 0 to theTriangles.Count - 1 do
  begin
    triangle := theTriangles.Items[i];
    triangle.MakeInShape(scene, shape);
  end;
end;

function TShape.IsVisible(canvas: TCanvas): boolean;
var
  intersection, adjusted: TRect;
  p: TShape;

begin
  p := FindTopParent;

  // Convert bounding coordinates to view coordinates
  if p <> nil then
  begin
    adjusted.Left := p.Bounding.Left + ViewSize;
    adjusted.Right := p.Bounding.Right + ViewSize;
    adjusted.Top := p.Bounding.Top + ViewSize;
    adjusted.Bottom := p.Bounding.Bottom + ViewSize;
  end
  else
  begin
    adjusted.Left := Bounding.Left + ViewSize;
    adjusted.Right := Bounding.Right + ViewSize;
    adjusted.Top := Bounding.Top + ViewSize;
    adjusted.Bottom := Bounding.Bottom + ViewSize;
  end;

  // Only visible if bounding box visible
  result := IntersectRect(intersection, adjusted, canvas.ClipRect);
end;

procedure TShape.DrawTexture(Scene: TSceneManager; canvas: TCanvas);
begin
  if texture <> nil then
    canvas.Pen.Color := texture.GetPaletteRGB
  else
    canvas.Pen.Color := clWhite;
end;

procedure TShape.DrawSelected(Scene: TSceneManager; canvas: TCanvas);
begin
  if (Parent = nil) and (ssSelected in States) then
  begin
    with canvas do
    begin
      Pen.Color := clRed;
      MoveTo(Bounding.Left + ViewSize, Bounding.Top + ViewSize);
      LineTo(Bounding.Right + ViewSize, Bounding.Top + ViewSize);
      LineTo(Bounding.Right + ViewSize, Bounding.Bottom + ViewSize);
      LineTo(Bounding.Left + ViewSize, Bounding.Bottom + ViewSize);
      LineTo(Bounding.Left + ViewSize, Bounding.Top + ViewSize);
    end;
  end;
end;

procedure TShape.Draw(Scene: TSceneManager; theTriangles: TList;
  canvas: TCanvas; Mode: TPenMode);
var
  i: integer;
  triangle: TTriangle;

begin
  if (sfDisplay in Flags) and IsVisible(canvas) then
  begin
    Canvas.Pen.Mode := Mode;

    DrawTexture(Scene, canvas);

    for i := 0 to theTriangles.Count - 1 do
    begin
      triangle := theTriangles.Items[i];
      {if Scene.GetHiddenLineRemoval then
      begin
        if triangle.Normal.Z < 0 then
          triangle.Draw(canvas);
      end
      else}
        triangle.Draw(canvas);
    end;

    DrawSelected(Scene, canvas);
  end;
end;

procedure TShape.SetTexture(ATexture: TTexture);
begin
  Texture := ATexture;
end;

procedure TShape.SetAnchor(AnchorType: TAnchorType);
begin
  case AnchorType of
    anTranslate:  Anchor.Copy(Translate);
    anScale:      Anchor.Copy(Scale);
    anRotate:     Anchor.Copy(Rotate);
  end;
end;

procedure TShape.SetTranslate(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Translate.X := x;
  if yb then Translate.Y := y;
  if zb then Translate.Z := z;
  Make(scene, Triangles);
end;

procedure TShape.SetTranslateAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Translate.X := Anchor.x + x;
  if yb then Translate.Y := Anchor.y + y;
  if zb then Translate.Z := Anchor.z + z;
  Make(scene, Triangles);
end;

procedure TShape.SetScale(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Scale.X := x;
  if yb then Scale.Y := y;
  if zb then Scale.Z := Z;
  Make(scene, Triangles);
end;

procedure TShape.SetScaleAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Scale.X := abs(Anchor.x + x);
  if yb then Scale.Y := abs(Anchor.y + y);
  if zb then Scale.Z := abs(Anchor.Z + Z);
  Make(scene, Triangles);
end;

procedure TShape.SetUniformScaleAnchor(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  case scene.View of
    vwFront, vwBack, vwTop, vwBottom:
      if xb then
      begin
        Scale.X := abs(Anchor.x + x);
        Scale.Y := Scale.X;
        Scale.Z := Scale.X;
      end;

    vwLeft, vwRight:
      if zb then
      begin
        Scale.Z := abs(Anchor.Z + Z);
        Scale.X := Scale.Z;
        Scale.Y := Scale.Z;
      end;
  end;

  Make(scene, Triangles);
end;

procedure TShape.SetRotate(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Rotate.X := x;
  if yb then Rotate.Y := y;
  if zb then Rotate.Z := z;
  Make(scene, Triangles);
end;

procedure TShape.SetObserver(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
end;

procedure TShape.SetObserved(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
end;

function TShape.GetObserver: TVector;
begin
  result := nil;
end;

function TShape.GetObserved: TVector;
begin
  result := nil;
end;

procedure TShape.AddTriangle(i, j, k: TVector);
var
  triangle: TTriangle;

  procedure Copy(dest: TCoord; source: TVector);
  begin
    dest.X := source.X;
    dest.Y := source.Y;
    dest.Z := source.Z;
  end;

begin
  triangle := TTriangle.Create;

  Copy(triangle.Points[1], i);
  Copy(triangle.Points[2], j);
  Copy(triangle.Points[3], k);

  Triangles.Add(triangle);
end;

procedure TShape.ResetTriangleSelection;
begin
end;

procedure TShape.Save(parent: TJSONArray);
var
  t: TShapeID;
  obj: TJSONObject;

begin
  obj := TJSONObject.Create;
  t := GetID;
  obj.AddPair('type', TJSONNumber.Create(ord(t)));
  obj.AddPair('name', Name);
  obj.AddPair('flags', TJSONNumber.Create(Byte(Flags)));
  if assigned(texture) then
    obj.AddPair('texture', texture.Name)
  else
    obj.AddPair('texture', 'unknown');
  if assigned(layer) then
    obj.AddPair('layer', layer.Name)
  else
    obj.AddPair('layer', 'Foreground');

  Translate.Save('translate', obj);
  Scale.Save('scale', obj);
  Rotate.Save('rotate', obj);

  parent.Add(obj);
end;

procedure TShape.SaveToFile(dest: TStream);
var
  t: TShapeID;
  buffer: string;

begin
  // Save Object ID
  t := GetID;
  dest.WriteBuffer(t, sizeof(t));

  // Save Object name
  SaveStringToStream(Name, dest);

  // Save flags
  dest.WriteBuffer(Flags, sizeof(Flags));

  // Save texture
  if texture <> nil then
    buffer := texture.Name
  else
    buffer := 'Unknown';

  SaveStringToStream(buffer, dest);

  // Save layer
  if layer <> nil then
    buffer := Layer.Name
  else
    buffer := 'Foreground';

  SaveStringToStream(buffer, dest);

  // Save properties
  //Translate.SaveToFile(dest);
  //Scale.SaveToFile(dest);
  //Rotate.SaveToFile(dest);
end;

procedure TShape.Load(obj: TJSONObject);
var
  b: byte;
  s: string;

begin
  Name := obj.GetValue('name').Value;
  b := StrToInt(obj.GetValue('flags').Value);
  Flags := TShapeFlags(b);
  s := obj.GetValue('texture').Value;
  Texture := TTextureManager.TextureManager.FindTexture(s);
  s := obj.GetValue('layer').Value;
  Layer := TSceneManager.SceneManager.FindLayer(s);
end;

procedure TShape.LoadFromFile(source: TStream);
var
  flag: boolean;
  dummy, buffer: AnsiString;

begin
  // Load name
  LoadStringFromStream(Name, source);

  // Load shadow flag
  if TSceneManager.SceneManager.FileVersion < 15 then
  begin
    source.ReadBuffer(flag, sizeof(flag));
    if flag then
      Flags := Flags + [sfShadow]
    else
      Flags := Flags - [sfShadow];

    // Load Hollow flag
    if TSceneManager.SceneManager.FileVersion > 7 then
    begin
      source.ReadBuffer(flag, sizeof(flag));

      if flag then
        Flags := Flags + [sfHollow]
      else
        Flags := Flags - [sfHollow];
    end;
  end
  else
    source.ReadBuffer(Flags, sizeof(Flags));

  // Load texture
  LoadStringFromStream(buffer, source);
  Texture := TTextureManager.TextureManager.FindTexture(buffer);

  // Load layer
  if TSceneManager.SceneManager.FileVersion > 10 then
  begin
    LoadStringFromStream(buffer, source);
    Layer := TSceneManager.SceneManager.FindLayer(buffer);
  end;

  // Load properties
  //Translate.LoadFromFile(source);
  //Scale.LoadFromFile(source);
  //Rotate.LoadFromFile(source);

  // Load SMPL details
  if (TSceneManager.SceneManager.FileVersion > 8) and (TSceneManager.SceneManager.FileVersion < 14) then
    LoadStringFromStream(dummy, source);
end;

procedure TShape.GenerateDetails(var dest: TextFile);
begin
  if sfCanGenerate in Features then
  begin
    if Texture <> nil then
      WriteLn(dest, '    texture { ', Texture.Name, ' }');

    // Note order of output:
    //  Scaling
    //  Rotation
    //  Translation
    if (sfCanScale in Features) and NonUnity(Scale.X, Scale.Y, Scale.Z) then
      WriteLn(dest, Format('    scale <%6.4f, %6.4f, %6.4f>',
        [Scale.x, Scale.y, Scale.z]));

    if sfCanRotate in Features then
    begin
      if Different(Rotate.z, 0) then WriteLn(dest, Format('    rotate <0, 0, %6.2f>', [-Rotate.z]));
      if Different(Rotate.y, 0) then WriteLn(dest, Format('    rotate <0, %6.2f, 0>', [-Rotate.y]));
      if Different(Rotate.x, 0) then WriteLn(dest, Format('    rotate <%6.2f, 0, 0>', [-Rotate.x]));
    end;

    if (sfCanTranslate in Features) and NonZero(Translate.x, Translate.y, Translate.z) then
      WriteLn(dest, Format('    translate <%6.4f, %6.4f, %6.4f>',
        [Translate.x, Translate.y, Translate.z]));

    if not (sfShadow in Flags) then
      WriteLn(dest, '    no_shadow');

    if sfHollow in Flags then
      WriteLn(dest, '    hollow');
  end;
end;

procedure TShape.GenerateCoolRayDetails(var dest: TextFile);
begin
  if (sfCanGenerate in Features) and (sfCanTranslate in Features) and NonZero(Translate.x, Translate.y, Translate.z) then
    WriteLn(dest, Format('      location := <%6.4f, %6.4f, %6.4f>;',
      [Translate.x, Translate.y, Translate.z]));
end;

procedure TShape.GenerateCoolRayTexture(var dest: TextFile);
begin
  if (sfCanGenerate in Features) and (Texture <> nil) then
  begin
    WriteLn(dest, '      SimpleTexture');
    WriteLn(dest, '      {');
    WriteLn(dest, '        SolidColorPigment');
    WriteLn(dest, '        {');
    WriteLn(dest, Format('          color := rgb <%6.4f, %6.4f, %6.4f>;',
      [Texture.Red, Texture.Green, Texture.Blue]));
    WriteLn(dest, '        }');
    WriteLn(dest, '      }');
  end;
end;

procedure TShape.GenerateVRMLDetails(var dest: TextFile);
begin
  if (sfCanGenerate in Features) then
  begin
    if Texture <> nil then
      Texture.GenerateVRML(dest);

    WriteLn(dest, '    Transform');
    WriteLn(dest, '    {');

    // Note order of output:
    //  Scaling
    //  Rotation
    //  Translation
    if (sfCanScale in Features) and NonUnity(Scale.X, Scale.Y, Scale.Z) then
      WriteLn(dest, Format('      scaleFactor %6.4f %6.4f %6.4f',
        [Scale.x, Scale.y, Scale.z]));

    if sfCanRotate in Features then
    begin
      if Different(Rotate.z, 0) then
        WriteLn(dest, Format('      rotation 0 0 1 %6.4f', [-Rotate.z * d2r]));

      if Different(Rotate.y, 0) then
        WriteLn(dest, Format('      rotation 0 1 0 %6.4f', [Rotate.y * d2r]));

      if Different(Rotate.x, 0) then
        WriteLn(dest, Format('      rotation 1 0 0 %6.4f', [Rotate.x * d2r]));
    end;

    if (sfCanTranslate in Features) and NonZero(Translate.x, Translate.y, Translate.z) then
      WriteLn(dest, Format('      translation %6.4f %6.4f %6.4f',
        [Translate.x, Translate.y, -Translate.z]));

    WriteLn(dest, '    }');
  end;
end;

procedure TShape.Generate(var dest: TextFile);
begin
  GenerateDetails(dest);
end;

procedure TShape.GenerateCoolRay(var dest: TextFile);
begin
  GenerateCoolRayDetails(dest);
  GenerateCoolRayTexture(dest);
end;

procedure TShape.GenerateVRML(var dest: TextFile);
begin
  if (sfCanGenerate in Features) then
  begin
    WriteLn(dest, '  Separator');
    WriteLn(dest, '  {');
    GenerateVRMLDetails(dest);
    GenerateVRMLTriangles(dest);
    WriteLn(dest, '  }');
  end;
end;

procedure TShape.GenerateVRML2(var dest: TextFile);
begin
  // The default for any shape is V1.0 format
  GenerateVRML(dest);
end;

procedure TShape.GenerateVRMLTriangles(var dest: TextFile);
var
  i: integer;
  triangle: TTriangle;

begin
  if (sfCanGenerate in Features) then
  begin
    WriteLn(dest, '    Coordinate3');
    WriteLn(dest, '    {');
    WriteLn(dest, '      point');
    WriteLn(dest, '      [');
    for i := 0 to Triangles.Count - 1 do
    begin
      triangle := Triangles[i] as TTriangle;
      triangle.GenerateVRML(dest);
      if i < Triangles.Count - 1 then
        WriteLn(dest, ',')
      else
        WriteLn(dest);
    end;
    WriteLn(dest, '      ]');
    WriteLn(dest, '    }');
    WriteLn(dest);
    WriteLn(dest, '    IndexedFaceSet');
    WriteLn(dest, '    {');
    WriteLn(dest, '      coordIndex');
    WriteLn(dest, '      [');
    for i := 0 to Triangles.Count - 1 do
    begin
      Write(dest, Format('        %d, %d, %d, -1', [i * 3, i * 3 + 1, i * 3 + 2]));
      if i < Triangles.Count - 1 then
        WriteLn(dest, ',')
      else
        WriteLn(dest);
    end;
    WriteLn(dest, '      ]');
    WriteLn(dest, '    }');
  end;
end;

procedure TShape.GenerateBlob(var dest: TextFile);
begin
  // Call the generate 'cos we aint a blob anyway!
  Generate(dest);
end;

procedure TShape.GenerateUDO(var dest: TextFile);
var
  i, x: integer;
  triangle: TTriangle;

begin
  if (sfCanGenerate in Features) then
  begin
    WriteLn(dest, '[', Name, ':Vertices]');
    WriteLn(dest, 3 * Triangles.Count);

    for i := 0 to Triangles.Count - 1 do
    begin
      triangle := Triangles[i] as TTriangle;
      triangle.GenerateUDO(dest);
    end;

    WriteLn(dest);
    WriteLn(dest, '[', Name, ':Edges]');
    WriteLn(dest, 3 * Triangles.Count);

    for i := 0 to Triangles.Count - 1 do
    begin
      x := i * 3;
      WriteLn(dest, x, ' ', x + 1);
      WriteLn(dest, x + 1, ' ', x + 2);
      WriteLn(dest, x + 2, ' ', x);
    end;

    WriteLn(dest);
    WriteLn(dest, '[', Name, ':Transforms]');
    WriteLn(dest, 'Scale ', Scale.X:6:4, ' ', Scale.Y:6:4, ' ', Scale.Z:6:4);
    WriteLn(dest, 'Rot ', Rotate.X:6:4, ' ', Rotate.Y:6:4, ' ', Rotate.Z:6:4);
    WriteLn(dest, 'Trans ', Translate.X:6:4, ' ', Translate.Y:6:4, ' ', Translate.Z:6:4);
    WriteLn(dest);
  end;
end;

procedure TShape.GenerateUDOInclude(var dest: TextFile);
var
  i: integer;
  triangle: TTriangle;

begin
  if (sfCanGenerate in Features) then
  begin
    WriteLn(dest, '#declare ', Name, ' = object');
    WriteLn(dest, '{');
    for i := 0 to Triangles.Count - 1 do
    begin
      triangle := Triangles[i] as TTriangle;
      triangle.GenerateUDOInclude(dest);
    end;
    WriteLn(dest, '}');
    WriteLn(dest);
  end;
end;

procedure TShape.GenerateDirectXFile(var dest: TextFile; const Options: TExportOptions);
var
    i, x, y: integer;
    value: double;
    triangle: TTriangle;
    matrix: TMatrix;

begin
  if (sfCanGenerate in Features) then
  begin
    // The frame
    matrix := TMatrix.Create;
    TransformationMatrix(matrix);

    WriteLn(dest, 'Frame ', Name, 'Frame {');
    WriteLn(dest, 'FrameTransformMatrix {');

    for y := 0 to 3 do
        for x := 0 to 3 do
        begin
            value := matrix.Get(x, y);
            Write(dest, value:6:4);
            if (y = 3) and (x = 3) then
                WriteLn(dest, ';;')
            else if x = 3 then
                WriteLn(dest, ',')
            else
                Write(dest, ',');
        end;

    WriteLn(dest, '}');
    WriteLn(dest, '{', Name, '}');
    WriteLn(dest, '}');
    WriteLn(dest);

    matrix.Free;

    // The mesh
    WriteLn(dest, 'Mesh ', Name, ' {');

    WriteLn(dest, ' ', 3 * Triangles.Count, ';');
    for i := 0 to Triangles.Count - 1 do
    begin
        triangle := Triangles[i] as TTriangle;
        triangle.GenerateDirectXFile(dest, Options);
        if i < Triangles.Count - 1 then
            WriteLn(dest, ',')
        else
            WriteLn(dest, ';');
    end;
    WriteLn(dest);

    WriteLn(dest, ' ', Triangles.Count, ';');
    for i := 0 to Triangles.Count - 1 do
    begin
        case Options.Axis of
        eoaNone:    Write(dest, Format('  3;%d,%d,%d;', [3 * i + 2, 3 * i + 1, 3 * i]));
        eoaSwapXY:  Write(dest, Format('  3;%d,%d,%d;', [3 * i + 1, 3 * i + 2, 3 * i]));
        eoaSwapYZ:  Write(dest, Format('  3;%d,%d,%d;', [3 * i + 2, 3 * i, 3 * i + 1]));
        eoaSwapXZ:  Write(dest, Format('  3;%d,%d,%d;', [3 * i, 3 * i + 1, 3 * i + 2]));
        end;

        if i < Triangles.Count - 1 then
            WriteLn(dest, ',')
        else
            WriteLn(dest, ';');
    end;
    WriteLn(dest, '}');

    WriteLn(dest);
  end;
end;

{*
procedure TShape.GenerateDirectXDetails(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
var
  i: integer;
  triangle: TTriangle;
  MeshBuilder: IDirect3DRMMeshBuilder;

begin
  if (sfCanGenerate in Features) then
  begin
    D3DRM.CreateMeshBuilder(MeshBuilder);

    for i := 0 to Triangles.Count - 1 do
    begin
      triangle := Triangles[i] as TTriangle;

      triangle.GenerateDirectXForm(D3DRM, MeshBuilder);
    end;

    if Texture <> nil then
      MeshBuilder.SetColorRGB(Texture.Red, Texture.Green, Texture.Blue);

    MeshFrame.AddVisual(MeshBuilder);
  end;
end;
*}

{*
procedure TShape.GenerateDirectXTransforms(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
begin
  if (sfCanGenerate in Features) then
  begin
    if (sfCanScale in Features) then MeshFrame.AddScale(D3DRMCOMBINE_AFTER, Scale.X, Scale.Y, Scale.Z);

    if sfCanRotate in Features then
    begin
      MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 1, 0, 0, -Rotate.X * d2r);
      MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 0, 1, 0, -Rotate.Y * d2r);
      MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 0, 0, 1, -Rotate.Z * d2r);
    end;

    if sfCanTranslate in Features then MeshFrame.AddTranslation(D3DRMCOMBINE_AFTER, Translate.X, Translate.Y, Translate.Z);
  end;
end;
*}

{*
procedure TShape.GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
begin
  GenerateDirectXDetails(D3DRM, MeshFrame);

  GenerateDirectXTransforms(D3DRM, MeshFrame);
end;
*}

procedure TShape.Details;
begin
end;

function TShape.CreateQuery: boolean;
begin
  result := True;
end;

function TShape.UsingTexture(text: TTexture): boolean;
begin
  if text = Texture then
    result := True
  else
    result := False;
end;

procedure TShape.Copy(original: TShape);
begin
  Name := original.Name;
  Flags := original.Flags;
  Texture := original.Texture;

  Translate.Copy(original.Translate);
  Scale.Copy(original.Scale);
  Rotate.Copy(original.Rotate);
end;

function TShape.BuildTree(tree: TTreeView; node: TTreeNode): TTreeNode;
var
  child: TTreeNode;

begin
  if node = nil then
    child := tree.Items.Add(nil, Name)
  else
    child := tree.Items.AddChild(node, Name);

  child.Data := Self;

  child.ImageIndex := ShapeImages[GetID];
  child.SelectedIndex := ShapeImages[GetID];

  result := child;
end;

procedure TShape.GetNormal;
var
  i: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    triangle.GetNormal;
  end;
end;

function TShape.FindTopParent: TShape;
var
  p: TShape;

begin
  p := Parent;
  if p <> nil then
  begin
    while p.parent <> nil do
      p := p.parent;
    result := p;
  end
  else
    result := nil;
end;

procedure TShape.TransformationMatrix(matrix: TMatrix);
var
    m1, m2: TMatrix;

begin
    m1 := TMatrix.Create;
    m2 := TMatrix.Create;

    if sfCanScale in Features then m1.Scale(Scale.x, Scale.y, Scale.z);
    if sfCanRotate in Features then m2.Rotate(Rotate.x, Rotate.y, Rotate.z);

    matrix.Multiply(m1, m2);

    if sfCanTranslate in Features then
    begin
        m1.Copy(matrix);
        m2.Translate(Translate.x, Translate.y, Translate.z);
        matrix.Multiply(m1, m2);
    end;

    m1.Free;
    m2.Free;
end;

////////////////////////////////////////////////////////////////////////////////
// CAMERA

constructor TCamera.Create;
begin
  inherited Create;

  Features := Features + [sfHasObserver, sfHasObserved, sfCanGenerate];

  ProjectionType := ptPerspective;
  Angle := TVector.Create;
  Observer := TCoord.Create;
  Observed := TCoord.Create;

  Observer.Z := -10;
end;

destructor TCamera.Destroy;
begin
  Angle.Free;
  Observer.Free;
  Observed.Free;
  inherited Destroy;
end;

function TCamera.GetID: TShapeID;
begin
  result := siCamera;
end;

function TCamera.CheckTexture: boolean;
begin
  result := true;
end;

function TCamera.GetObserver: TVector;
begin
  result := Observer;
end;

function TCamera.GetObserved: TVector;
begin
  result := Observed;
end;

procedure TCamera.SetObserver(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Observer.x := x;
  if yb then Observer.y := y;
  if zb then Observer.z := z;
  Make(scene, Triangles);
end;

procedure TCamera.SetObserved(scene: TSceneManager; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Observed.x := x;
  if yb then Observed.y := y;
  if zb then Observed.z := z;
  Make(scene, Triangles);
end;

procedure TCamera.Draw(Scene: TSceneManager; theTriangles: TList; canvas: TCanvas; Mode: TPenMode);
begin
  if Scene.GetView <> vwCamera then
  begin
    with canvas do
    begin
      Pen.Mode := Mode;
      Pen.Color := clWhite;

      // Draw a line connecting the camera and the point
      MoveTo(Observer.Point.X + ViewSize, Observer.Point.Y + ViewSize);
      LineTo(Observed.Point.X + ViewSize, Observed.Point.Y + ViewSize);

      // Draw a rectangle at the observer
      Rectangle(Observer.Point.X + ViewSize - CameraSize,
        Observer.Point.Y + ViewSize - CameraSize,
        Observer.Point.X + ViewSize + CameraSize,
        Observer.Point.Y + ViewSize + CameraSize);

      // Draw a cross at the observed
      MoveTo(Observed.Point.X + ViewSize - CameraSize, Observed.Point.Y + ViewSize - CameraSize);
      LineTo(Observed.Point.X + ViewSize + CameraSize, Observed.Point.Y + ViewSize + CameraSize);
      MoveTo(Observed.Point.X + ViewSize + CameraSize, Observed.Point.Y + ViewSize - CameraSize);
      LineTo(Observed.Point.X + ViewSize - CameraSize, Observed.Point.Y + ViewSize + CameraSize);

      Bounding.left := Minimum(Observer.Point.X - CameraSize, Observed.Point.X - CameraSize);
      Bounding.right := Maximum(Observer.Point.X + CameraSize, Observed.Point.X + CameraSize);
      Bounding.top := Minimum(Observer.Point.Y - CameraSize, Observed.Point.Y - CameraSize);
      Bounding.bottom := Maximum(Observer.Point.Y + CameraSize, Observed.Point.Y + CameraSize);
    end;

    DrawSelected(Scene, canvas);
  end;
end;

procedure TCamera.CalculateAngle;
var
  dist: double;

begin
  { Figure out angle }
  dist := Observed.Z - Observer.Z;

  { Make sure we don't try to divide by zero! }
  if (dist > -0.001) and (dist < 0.001) then
  begin
    if dist < 0.001 then
      dist := 0.001
    else
      dist := -0.001;
  end;

  Angle.x := -ArcTan2(Observed.y - Observer.y, dist);
  Angle.y := ArcTan2(Observed.x - Observer.x, dist);
  Angle.z := 0.0;
end;

procedure TCamera.Make(scene: TSceneManager; theTriangles: TList);
begin
  inherited Make(scene, theTriangles);

  CalculateAngle;

  if scene.GetView <> vwCamera then
  begin
    Observer.Make(scene, Self);
    Observed.Make(scene, Self);
  end;
end;

procedure TCamera.Save(parent: TJSONArray);
var
  t: TShapeID;
  obj: TJSONObject;

begin
  obj := TJSONObject.Create;
  t := GetID;
  obj.AddPair('type', TJSONNumber.Create(ord(t)));
  obj.AddPair('name', Name);
  Observer.Save('observer', obj);
  Observed.Save('observed', obj);
  parent.Add(obj);
end;

procedure TCamera.SaveToFile(dest: TStream);
var
  t: TShapeID;

begin
  // Save type
  t := GetID;
  dest.WriteBuffer(t, sizeof(t));

  // Save name
  SaveStringToStream(Name, dest);

  // Save properties
  //Observer.SaveToFile(dest);
  //Observed.SaveToFile(dest);
end;

procedure TCamera.Load(obj: TJSONObject);
begin
  Name := obj.GetValue('name').Value;
end;

procedure TCamera.LoadFromFile(source: TStream);
begin
  // Load name
  LoadStringFromStream(Name, source);

  // Load properties
  //Observer.LoadFromFile(source);
  //Observed.LoadFromFile(source);
end;

procedure TCamera.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'camera');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    location <%6.4f, %6.4f, %6.4f>',
    [Observer.x, Observer.y, Observer.z]));
  WriteLn(dest, Format('    look_at <%6.4f, %6.4f, %6.4f>',
    [Observed.x, Observed.y, Observed.z]));
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TCamera.GenerateCoolRay(var dest: TextFile);
begin
  WriteLn(dest, '  PerspectiveCamera');
  WriteLn(dest, '  {');
  WriteLn(dest, Format('    location := <%6.4f, %6.4f, %6.4f>;',
    [Observer.x, Observer.y, Observer.z]));
  WriteLn(dest, Format('    look_at := <%6.4f, %6.4f, %6.4f>;',
    [Observed.x, Observed.y, Observed.z]));
  WriteLn(dest, '  }');
end;

{$DEFINE VRML_CAMERA}

procedure TCamera.GenerateVRML(var dest: TextFile);
{$IFDEF VRML_CAMERA}
var
  n: TVector;
  amp: double;
{$ENDIF}

begin
{$IFDEF VRML_CAMERA}
  n := TVector.Create;

  // Figure out the vector between the observer and observed
  n.x := Observer.x - Observed.x;
  n.y := Observer.y - Observed.y;
  n.z := Observer.z - Observed.z;

  n.Normalize;

  if n.Equal(0, 0, 1) then
  begin
    n.x := 0;
    n.y := 1;
    n.z := 0;
    amp := 1.0;
  end
  else
    amp := sqrt(n.x * n.x + n.y * n.y + n.z * n.z);

  WriteLn(dest, '  Separator');
  WriteLn(dest, '  {');

  WriteLn(dest, '    PerspectiveCamera');
  WriteLn(dest, '    {');
  WriteLn(dest, Format('    position %6.4f %6.4f %6.4f',
    [Observer.x, Observer.y, Observer.z]));

  // Point the camera along the +Z axis
  WriteLn(dest, Format('    orientation %6.4f %6.4f %6.4f %6.4f',
    [n.x, n.y, n.z, amp]));

  WriteLn(dest, '    }');
  WriteLn(dest, '  }');
  WriteLn(dest);

  n.Free;
{$ENDIF}
end;

procedure TCamera.Details;
var
  dlg: TCameraDialog;

begin
  dlg := TCameraDialog.Create(Application);

  dlg.XObserver.Text := FloatToStrF(Observer.x, ffFixed, 6, 4);
  dlg.YObserver.Text := FloatToStrF(Observer.y, ffFixed, 6, 4);
  dlg.ZObserver.Text := FloatToStrF(Observer.z, ffFixed, 6, 4);

  dlg.XObserved.Text := FloatToStrF(Observed.x, ffFixed, 6, 4);
  dlg.YObserved.Text := FloatToStrF(Observed.y, ffFixed, 6, 4);
  dlg.ZObserved.Text := FloatToStrF(Observed.z, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Observer.x := StrToFloat(dlg.XObserver.Text);
    Observer.y := StrToFloat(dlg.YObserver.Text);
    Observer.z := StrToFloat(dlg.ZObserver.Text);

    Observed.x := StrToFloat(dlg.XObserved.Text);
    Observed.y := StrToFloat(dlg.YObserved.Text);
    Observed.z := StrToFloat(dlg.ZObserved.Text);

    Make(TSceneManager.SceneManager, Triangles);

    if TSceneManager.SceneManager.GetView = vwCamera then
      TSceneManager.SceneManager.Make;

    MainForm.MainPaintBox.Refresh;
  end;

  dlg.Free;
end;

////////////////////////////////////////////////////////////////////////////////
// TAtmosphereSettings

constructor TAtmosphereSettings.Create;
begin
  AtmosphereType := atNone;
  Distance := 0;
  Scattering := 0;
  Eccentricity := 0;
  Samples := 0;
  Jitter := 0;
  Threshold := 0;
  Level := 0;
  Red := 0;
  Green := 0;
  Blue := 0;
end;

procedure TAtmosphereSettings.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  obj := TJSONObject.Create;
  obj.AddPair('atmospheretype', TJSONNumber.Create(ord(AtmosphereType)));
  obj.AddPair('distance', TJSONNumber.Create(Distance));
  obj.AddPair('scattering', TJSONNumber.Create(Scattering));
  obj.AddPair('eccentricity', TJSONNumber.Create(Eccentricity));
  obj.AddPair('samples', TJSONNumber.Create(Samples));
  obj.AddPair('jitter', TJSONNumber.Create(Jitter));
  obj.AddPair('threshold', TJSONNumber.Create(Threshold));
  obj.AddPair('level', TJSONNumber.Create(Level));
  obj.AddPair('red', TJSONNumber.Create(Red));
  obj.AddPair('green', TJSONNumber.Create(Green));
  obj.AddPair('blue', TJSONNumber.Create(Blue));
  parent.Add(obj);
end;

procedure TAtmosphereSettings.SaveToFile(stream: TStream);
begin
  stream.WriteBuffer(AtmosphereType, sizeof(AtmosphereType));
  stream.WriteBuffer(Distance, sizeof(Distance));
  stream.WriteBuffer(Scattering, sizeof(Scattering));
  stream.WriteBuffer(Eccentricity, sizeof(Eccentricity));
  stream.WriteBuffer(Samples, sizeof(Samples));
  stream.WriteBuffer(Jitter, sizeof(Jitter));
  stream.WriteBuffer(Threshold, sizeof(Threshold));
  stream.WriteBuffer(Level, sizeof(Level));
  stream.WriteBuffer(Red, sizeof(Red));
  stream.WriteBuffer(Green, sizeof(Green));
  stream.WriteBuffer(Blue, sizeof(Blue));
end;

procedure TAtmosphereSettings.LoadFromFile(stream: TStream);
begin
  stream.ReadBuffer(AtmosphereType, sizeof(AtmosphereType));
  stream.ReadBuffer(Distance, sizeof(Distance));
  stream.ReadBuffer(Scattering, sizeof(Scattering));
  stream.ReadBuffer(Eccentricity, sizeof(Eccentricity));
  stream.ReadBuffer(Samples, sizeof(Samples));
  stream.ReadBuffer(Jitter, sizeof(Jitter));
  stream.ReadBuffer(Threshold, sizeof(Threshold));
  stream.ReadBuffer(Level, sizeof(Level));
  stream.ReadBuffer(Red, sizeof(Red));
  stream.ReadBuffer(Green, sizeof(Green));
  stream.ReadBuffer(Blue, sizeof(Blue));
end;

////////////////////////////////////////////////////////////////////////////////
// TFog

constructor TFog.Create;
begin
  FogType := ftNormal;
  Distance := 0;
  Red := 0;
  Green := 0;
  Blue := 0;
  Turbulence := 0;
  TurbulenceDepth := 0;
  Omega := 0;
  Lambda := 0;
  Octaves := 0;
  Offset := 0;
  Alt := 0;
end;

procedure TFog.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  obj := TJSONObject.Create;
  obj.AddPair('fogtype', TJSONNumber.Create(ord(FogType)));
  obj.AddPair('distance', TJSONNumber.Create(Distance));
  obj.AddPair('red', TJSONNumber.Create(Red));
  obj.AddPair('green', TJSONNumber.Create(Green));
  obj.AddPair('blue', TJSONNumber.Create(Blue));
  obj.AddPair('turbulence', TJSONNumber.Create(Turbulence));
  obj.AddPair('turbulencedepth', TJSONNumber.Create(TurbulenceDepth));
  obj.AddPair('omega', TJSONNumber.Create(Omega));
  obj.AddPair('lambda', TJSONNumber.Create(Lambda));
  obj.AddPair('octaves', TJSONNumber.Create(Octaves));
  obj.AddPair('offset', TJSONNumber.Create(Offset));
  obj.AddPair('alt', TJSONNumber.Create(Alt));
  parent.Add(obj);
end;

procedure TFog.SaveToFile(stream: TStream);
begin
  stream.WriteBuffer(FogType, sizeof(FogType));
  stream.WriteBuffer(Distance, sizeof(Distance));
  stream.WriteBuffer(Red, sizeof(Red));
  stream.WriteBuffer(Green, sizeof(Green));
  stream.WriteBuffer(Blue, sizeof(Blue));
  stream.WriteBuffer(Turbulence, sizeof(Turbulence));
  stream.WriteBuffer(TurbulenceDepth, sizeof(TurbulenceDepth));
  stream.WriteBuffer(Omega, sizeof(Omega));
  stream.WriteBuffer(Lambda, sizeof(Lambda));
  stream.WriteBuffer(Octaves, sizeof(Octaves));
  stream.WriteBuffer(Offset, sizeof(Offset));
  stream.WriteBuffer(Alt, sizeof(Alt));
end;

procedure TFog.LoadFromFile(stream: TStream);
begin
  stream.ReadBuffer(FogType, sizeof(FogType));
  stream.ReadBuffer(Distance, sizeof(Distance));
  stream.ReadBuffer(Red, sizeof(Red));
  stream.ReadBuffer(Green, sizeof(Green));
  stream.ReadBuffer(Blue, sizeof(Blue));
  stream.ReadBuffer(Turbulence, sizeof(Turbulence));
  stream.ReadBuffer(TurbulenceDepth, sizeof(TurbulenceDepth));
  stream.ReadBuffer(Omega, sizeof(Omega));
  stream.ReadBuffer(Lambda, sizeof(Lambda));
  stream.ReadBuffer(Octaves, sizeof(Octaves));
  stream.ReadBuffer(Offset, sizeof(Offset));
  stream.ReadBuffer(Alt, sizeof(Alt));
end;

////////////////////////////////////////////////////////////////////////////////
//  TTransform

constructor TTransform.Create;
begin
  Translate := TVector.Create;
  Scale := TVector.Create;
  Rotate := TVector.Create;
end;

destructor TTransform.Destroy;
begin
  Translate.Free;
  Scale.Free;
  Rotate.Free;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
//  TUndo

constructor TUndo.Create(AType: TUndoType; AShape: TShape; APrev, ADetail: Pointer);
begin
  UndoType := AType;
  Shape := AShape;
  Previous := APrev;
  Details := ADetail;
end;

////////////////////////////////////////////////////////////////////////////////
//  TExportOptions

constructor TExportOptions.Create;
begin
  Axis := eoaNone;
  Scaling := 1.0;
end;

////////////////////////////////////////////////////////////////////////////////
//  TScriptFile

constructor TScriptFile.Create;
begin
  FProperties := TList.Create;
end;

destructor TScriptFile.Destroy;
begin
  FProperties.Free;

  inherited;
end;

procedure TScriptFile.Load(const name: string);
var
  i, n: integer;
  id: TPropertyID;
  prop: TScriptProperty;
  stream: TFileStream;

begin
  FName := name;

  stream := TFileStream.Create(name, fmOpenRead);

  if stream <> nil then
  begin
    LoadStringFromStream(FDescription, stream);

    stream.Read(n, sizeof(integer));

    for i := 1 to n do
    begin
      stream.Read(id, sizeof(TPropertyID));

      case id of
        spInteger:  prop := TScriptInteger.Create;
        spSingle:   prop := TScriptSingle.Create;
        spList:     prop := TScriptList.Create;
      else
        prop := nil;
      end;

      if prop <> nil then
        prop.LoadFromStream(stream);
    end;

    stream.Free;
  end;
end;

procedure TScriptFile.Save(parent: TJSONArray);
var
  i, n: integer;
  obj: TJSONObject;
  propsArray: TJSONArray;
  prop: TScriptProperty;

begin
  obj := TJSONObject.Create;
  obj.AddPair('description', FDescription);
  n := FProperties.Count;
  propsArray := TJSONArray.Create;
  for i := 0 to n - 1 do
  begin
    prop := FProperties[i];
    prop.Save(propsArray);
  end;
  obj.AddPair('properties', propsArray);
  parent.Add(obj);
end;

procedure TScriptFile.Save(const name: string);
var
  root: TJSONObject;
  props: TJSONArray;
  text: string;

begin
  root := TJSONObject.Create;
  props := TJSONArray.Create;
  Save(props);
  root.AddPair('properties', props);
  text := root.ToJSON;
  root.Free;
  TFile.WriteAllText(name, text);
end;

procedure TScriptFile.Edit;
var
  dlg: TScriptFileDialog;

begin
  dlg := TScriptFileDialog.Create(Application);

  dlg.ShowModal;

  dlg.Free;
end;

////////////////////////////////////////////////////////////////////////////////
//  TSceneData

constructor TSceneManager.Create;
var
  layer: TLayer;

begin
  Modified := False;
  HiddenLineRemoval := False;
  LightShading := False;
  Outline := True;
  Mode := mdSelect;
  UniformScaling := true;
  View := vwFront;
  Current := nil;
  CurrentCamera := nil;
  ScaleMult := 1;
  ScaleDiv := 1;
  Grid := 0;

  ZBuffer := TList<TTriangle>.Create;
  ZBuffer.Capacity := 1000;

  UndoIndex := -1;
  UndoBuffer := TList<Tundo>.Create;
  UndoBuffer.Capacity := UndoLimit;
  UndoDrag := nil;

  ScriptFiles := TList<TScriptFile>.Create;

  Shapes := TObjectList<TShape>.Create;
  Layers := TObjectList<TLayer>.Create;
  AtmosphereSettings := TAtmosphereSettings.Create;
  Fog := TFog.Create;
  AnchorPoint := TVector.Create;
  FileVersion := ModelVersion;
  CreateExtrusion := False;

  layer := TLayer.Create;
  layer.Name := 'Foreground';
  Layers.Add(layer);
  CurrentLayer := layer;

  layer := TLayer.Create;
  layer.Name := 'Background';
  Layers.Add(layer);
end;

function TSceneManager.CreateShape(AType: TShapeType; const Name: string; x, y, z: double): TShape;
var
  shape: TShape;
  camera: TCamera;

begin
  shape := AType.Create;
  shape.Name := Name;

  shape.CreateQuery;

  if shape is TCamera then
  begin
    camera := shape as TCamera;

    camera.Observer.x := x;
    camera.Observer.y := y;
    camera.Observer.z := z - 10;

    camera.Observed.x := x;
    camera.Observed.y := y;
    camera.Observed.z := z;
  end
  else
  begin
    shape.Translate.X := X;
    shape.Translate.Y := Y;
    shape.Translate.Z := Z;
  end;

  AddUndo(utCreateShape, shape, nil, nil);

  result := shape;
end;

function TSceneManager.IsModified: boolean;
begin
  result := Modified;
end;

function TSceneManager.CountSelected: integer;
var
  i, n: integer;
  shape: TShape;

begin
  n := 0;

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if ssSelected in shape.States then inc(n);
  end;

  result := n;
end;

function TSceneManager.HasMultipleSelected: boolean;
begin
  result := CountSelected > 1;
end;

procedure TSceneManager.SetModified;
begin
  Modified := True;
end;

procedure TSceneManager.Empty;
var
  layer: TLayer;
  
begin
  Current := nil;
  CurrentCamera := nil;

  Shapes.Clear;
  Layers.Clear;

  ZBuffer.Clear;

  if View = vwCamera then
    View := vwFront;

  layer := TLayer.Create;
  layer.Name := 'Foreground';
  Layers.Add(layer);

  layer := TLayer.Create;
  layer.Name := 'Background';
  Layers.Add(layer);

  Modified := False;
end;

function TSceneManager.UsingTexture(texture: TTexture): boolean;
var
  i: integer;
  shape: TShape;

begin
  result := False;
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if shape.UsingTexture(texture) then
    begin
      result := True;
      break;
    end;
  end;
end;

procedure TSceneManager.Make;
var
  i: integer;
  shape: TShape;

begin
  Screen.Cursor := crHourglass;
  try
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Make(Self, shape.Triangles);
    end;

    if HiddenLineRemoval then
      CalculateZBuffer(ZBuffer);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSceneManager.Draw(canvas: TCanvas);
var
  i: integer;
  shape: TShape;
  triangle: TTriangle;

begin
  if HiddenLineRemoval and (View = vwCamera) then
  begin
    for i := ZBuffer.Count - 1 downto 0 do
    begin
      triangle := ZBuffer[i] as TTriangle;
      triangle.DrawFilled(Self, canvas);
    end
  end
  else
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Draw(Self, shape.Triangles, canvas, pmCopy);
    end;
end;

procedure TSceneManager.Print(canvas: TCanvas);
var
  i: integer;
  shape: TShape;
  triangle: TTriangle;

begin
  if HiddenLineRemoval and (View = vwCamera) then
  begin
    for i := ZBuffer.Count - 1 downto 0 do
    begin
      triangle := ZBuffer[i] as TTriangle;
      triangle.DrawFilled(Self, canvas);
    end
  end
  else
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Draw(Self, Shape.Triangles, canvas, pmCopy);
    end;
end;

procedure TSceneManager.SetView(AView: TView);
begin
  View := AView;
  Make;
end;

class procedure TSceneManager.Shutdown;
begin
  SceneManager.Free;
  SceneManager := nil;
end;

procedure TSceneManager.SetCurrent(shape: TShape);
begin
  if Current <> nil then
    Current.States := Current.States - [ssSelected];

  Current := shape;

  if Current <> nil then
    Current.States := Current.States + [ssSelected];
end;

procedure TSceneManager.SetMultiple(shape: TShape);
begin
  Current := shape;

  if Current <> nil then
    Current.States := Current.States + [ssSelected];
end;

procedure TSceneManager.SetCamera(camera: TCamera);
begin
  CurrentCamera := camera;
end;

function TSceneManager.GetCamera: TCamera;
begin
  result := CurrentCamera;
end;

procedure TSceneManager.SetMode(AMode: TMode);
begin
  Mode := AMode;

{$IFDEF USE_SPECIAL_CURSOR}
  case Mode of
    mdSelect:     MainForm.MainPaintBox.Cursor := crDefault;
    mdCreate:     MainForm.MainPaintBox.Cursor := crDefault;
    mdTranslate:  MainForm.MainPaintBox.Cursor := crTranslate;
    mdScale:      MainForm.MainPaintBox.Cursor := crScale;
    mdScaleUniform: MainForm.MainPaintBox.Cursor := crScale;
    mdRotate:     MainForm.MainPaintBox.Cursor := crRotate;
    mdObserver:   MainForm.MainPaintBox.Cursor := crDefault;
    mdObserved:   MainForm.MainPaintBox.Cursor := crDefault;
  end;
{$ENDIF}
end;

function TSceneManager.GetMode: TMode;
begin
  result := Mode;
end;

function TSceneManager.GetView: TView;
begin
  result := View;
end;

procedure TSceneManager.AdjustPoint(X, Y: integer;
  var point: TPoint;
  var xx, yy, zz: double;
  var xb, yb, zb: boolean);
var
  xi, yi: double;

begin
  point.x := X - ViewSize;
  point.y := Y - ViewSize;

  xi := point.x * ViewRange / ViewSize;
  yi := -point.y * ViewRange / ViewSize;

  // adjust for zoom
  if ScaleMult <> ScaleDiv then
  begin
    xi := (xi * ScaleDiv) / ScaleMult;
    yi := (yi * ScaleDiv) / ScaleMult;
  end;

  // adjust for grid
  if grid > 0.001 then
  begin
    xi := trunc(xi / grid) * grid;
    yi := trunc(yi / grid) * grid;
  end;

  // figure out for view
  case View of
    vwFront, vwCamera:
    begin
      xx := xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    vwBack:
    begin
      xx := -xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    vwLeft:
    begin
      xx := 0;
      yy := yi;
      zz := -xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    vwRight:
    begin
      xx := 0;
      yy := yi;
      zz := xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    vwTop:
    begin
      xx := xi;
      yy := 0;
      zz := yi;
      xb := True;
      yb := False;
      zb := True;
    end;

    vwBottom:
    begin
      xx := xi;
      yy := 0;
      zz := -yi;
      xb := True;
      yb := False;
      zb := True;
    end;
  end;
end;

procedure TSceneManager.Anchor;
begin
  if current <> nil then
    AnchorPoint.Copy(current.Translate);
end;

// A bit of a hack to get a description before a shape is created!
function GetShapeDescription(what: TShapeType): string;
var
  s: string;

begin
  s := what.ClassName;
  s := Copy(s, 2, Length(s) - 1);
  result := s;
end;

procedure TSceneManager.MouseDown(Shift: TShiftState; X, Y: integer);
var
  i: integer;
  SomethingSelected: boolean;
  Point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;
  Shape: TShape;
  Solid: TSolid;
  Lathe: TLathe;
  UserDefined: TUserShape;
  Scripted: TScripted;
  previous, details: TVector;

begin
  AdjustPoint(X, Y, Point, xx, yy, zz, xb, yb, zb);

  case Mode of
    mdSelect:
    begin
      if View <> vwCamera then
      begin
        SomethingSelected := False;

        // check every shape to see if it's a possible selection
        for i := 0 to Shapes.Count - 1 do
        begin
          shape := Shapes.Items[i] as TShape;
          if PtInRect(shape.Bounding, Point) then
          begin
            if not (ssSelected in shape.States) then
            begin
              SomethingSelected := True;
              if ssCtrl in Shift then
                SetMultiple(shape)
              else
                SetCurrent(shape);
            end;
          end;
        end;

        if not SomethingSelected then
          SetCurrent(nil);
      end;
    end;

    mdTranslate:
    begin
      if (View <> vwCamera) and (Current <> nil) then
      begin
        if sfCanTranslate in Current.Features then
        begin
          AnchorPoint.x := xx;
          AnchorPoint.y := yy;
          AnchorPoint.z := zz;

          Current.SetAnchor(anTranslate);
          MainForm.MainPaintBox.BeginDrag(False);

          previous := TVector.Create;
          details := TVector.Create;

          previous.Copy(Current.Translate);
          details.Copy(Current.Translate);

          UndoDrag := AddUndo(utTranslateShape, Current, previous, details);
        end;
      end;
    end;

    mdScale, mdScaleUniform:
    begin
      if (View <> vwCamera) and (Current <> nil) then
      begin
        if sfCanScale in Current.Features then
        begin
          AnchorPoint.x := xx;
          AnchorPoint.y := yy;
          AnchorPoint.z := zz;

          Current.SetAnchor(anScale);
          MainForm.MainPaintBox.BeginDrag(False);

          previous := TVector.Create;
          details := TVector.Create;

          previous.Copy(Current.Scale);
          details.Copy(Current.Scale);

          UndoDrag := AddUndo(utScaleShape, Current, previous, details);
        end;
      end;
    end;

    mdRotate:
    begin
      if (View <> vwCamera) and (Current <> nil) then
      begin
        if sfCanRotate in Current.Features then
        begin
          Anchor;
          MainForm.MainPaintBox.BeginDrag(False);

          previous := TVector.Create;
          details := TVector.Create;

          previous.Copy(Current.Rotate);
          details.Copy(Current.Rotate);

          UndoDrag := AddUndo(utRotateShape, Current, previous, details);
        end;
      end;
    end;

    mdObserver:
    begin
      if Current <> nil then
      begin
        if (View = vwCamera) and (Current is TCamera) then
          MainForm.MainPaintBox.BeginDrag(False)
        else
          if sfHasObserver in Current.Features then
          begin
            Anchor;
            MainForm.MainPaintBox.BeginDrag(False);
            previous := TVector.Create;
            details := TVector.Create;

            previous.Copy(Current.GetObserver);
            details.Copy(Current.GetObserver);

            UndoDrag := AddUndo(utObserverShape, Current, previous, details);
          end;
      end;
    end;

    mdObserved:
    begin
      if Current <> nil then
      begin
        if (View = vwCamera) and (Current is TCamera) then
          MainForm.MainPaintBox.BeginDrag(False)
        else
          if sfHasObserved in Current.Features then
          begin
            Anchor;
            MainForm.MainPaintBox.BeginDrag(False);
            previous := TVector.Create;
            details := TVector.Create;

            previous.Copy(Current.GetObserved);
            details.Copy(Current.GetObserved);

            UndoDrag := AddUndo(utObservedShape, Current, previous, details);
          end;
      end;
    end;

    mdCreate:
    begin
      Shape := CreateShape(CreateWhat,
        GetShapeDescription(CreateWhat) + IntToStr(Shapes.Count + 1), xx, yy, zz);

      if CreateWhat = TCamera then
        SetCamera(Shape as TCamera);

      if CreateWhat = TSolid then
      begin
        Solid := Shape as TSolid;
        case CreateWhatSolid of
          stCone: Solid.CreateCone;
          stCylinder: Solid.CreateCylinder;
          stSolid: Solid.CreateSolid;
        end;
      end;

      if CreateWhat = TLathe then
      begin
        Lathe := Shape as TLathe;
        Lathe.CreateLathe;
      end;

      if CreateWhat = TUserShape then
      begin
        UserDefined := Shape as TUserShape;
        UserDefined.Rebuild;
      end;

      if CreateWhat = TScripted then
      begin
        Scripted := Shape as TScripted;
        Scripted.Like := CreateWhatScripted;
      end;

      Shapes.Add(Shape);
      Shape.Make(Self, Shape.Triangles);
      SetCurrent(Shape);
      MainForm.SetSelect;
      Mode := mdSelect;
      SetModified;
    end;
  end;
end;

procedure TSceneManager.CalculateSetRotation(xx, yy, zz: double);
var
  x, y, z: double;

begin
  if current <> nil then
  begin
    x := xx - AnchorPoint.x;
    y := yy - AnchorPoint.y;
    z := zz - AnchorPoint.z;

    case View of
      vwFront, vwBack:
      begin
        if (x > -0.001) and (x < 0.001) then x := 0.001;
        Current.Rotate.z := ArcTan2(y, -x) * r2d;
      end;

      vwTop, vwBottom:
      begin
        if (y > -0.001) and (y < 0.001) then x := 0.001;
        Current.Rotate.y := ArcTan2(z, x) * r2d;
      end;

      vwLeft, vwRight:
      begin
        if (z > -0.001) and (z < 0.001) then z := 0.001;
        Current.Rotate.x := ArcTan2(y, z) * r2d;
      end;
    end;

    Current.Make(Self, Current.Triangles);
    // PaintBox.Invalidate;
  end;
end;

procedure TSceneManager.MouseMove(X, Y: integer);
var
  Point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;

begin
  AdjustPoint(X, Y, Point, xx, yy, zz, xb, yb, zb);

  MainForm.StatusBar.Panels[0].Text := FloatToStrF(xx, ffFixed, 3, 2) + ' ' +
    FloatToStrF(yy, ffFixed, 3, 2) + ' ' + FloatToStrF(zz, ffFixed, 3, 2);
end;

function TSceneManager.DragOver(x, y: integer): boolean;
var
  Point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;

begin
  result := False;

  AdjustPoint(X, Y, Point, xx, yy, zz, xb, yb, zb);

  // do the drag thing
  if Current <> nil then
  begin
    SetModified;
    if View = vwCamera then
    begin
      case Mode of
        mdObserver: Current.SetObserver(Self, xx, yy, 0, True, True, False);
        mdObserved: Current.SetObserved(Self, xx, yy, 0, True, True, False);
      end;
      Make;
    end
    else
      case Mode of
        mdTranslate:
          Current.SetTranslateAnchor(Self, xx - AnchorPoint.x, yy - AnchorPoint.y, zz - AnchorPoint.z, xb, yb, zb);

        mdScale:
          Current.SetScaleAnchor(Self,
            xx - AnchorPoint.x,
            yy - AnchorPoint.y,
            zz - AnchorPoint.z,
            xb, yb, zb);

        mdScaleUniform:
          Current.SetUniformScaleAnchor(Self,
            xx - AnchorPoint.x,
            yy - AnchorPoint.y,
            zz - AnchorPoint.z,
            xb, yb, zb);

        mdRotate:
          CalculateSetRotation(xx, yy, zz);

        mdObserver:
          Current.SetObserver(Self, xx, yy, zz, xb, yb, zb);

        mdObserved:
          Current.SetObserved(Self, xx, yy, zz, xb, yb, zb);
      end;
    result := True;
  end;
end;

procedure TSceneManager.EndDrag;
var
  vector: TVector;

begin
  if UndoDrag <> nil then
  begin
    vector := UndoDrag.Details;

    if (vector <> nil) and (Current <> nil) then
      case Mode of
        mdTranslate:  vector.Copy(Current.Translate);
        mdScale, mdScaleUniform: vector.Copy(Current.Scale);
        mdRotate:     vector.Copy(Current.Rotate);
        mdObserver:   vector.Copy(Current.GetObserver);
        mdObserved:   vector.Copy(Current.GetObserved);
      end;
  end;

  UndoDrag := nil;
end;

function TSceneManager.GetCurrent: TShape;
begin
  result := Current;
end;

procedure TSceneManager.SetTexture(ATexture: TTexture);
var
  i: integer;
  shape: TShape;

begin
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if ssSelected in shape.States then
    begin
      AddUndo(utApplyTexture, shape, shape.Texture, ATexture);
      shape.SetTexture(ATexture);
    end;
  end;
  SetModified;
end;

procedure TSceneManager.SetCreateWhat(AType: TShapeType);
begin
  Mode := mdCreate;
  CreateWhat := AType;
end;

function TSceneManager.GetCreateWhat: TShapeType;
begin
  result := CreateWhat;
end;

procedure TSceneManager.SetGrid(value: double);
begin
  Grid := value;
end;

function TSceneManager.GetGrid: double;
begin
  result := Grid;
end;

procedure TSceneManager.SetScale(mult, divisor: integer);
begin
  ScaleMult := mult;
  ScaleDiv := divisor;
end;

procedure TSceneManager.GetScale(var mult, divisor: integer);
begin
  mult := ScaleMult;
  divisor := ScaleDiv;
end;

procedure TSceneManager.ScaleUp;
begin
  inc(ScaleMult);
end;

procedure TSceneManager.ScaleDown;
begin
  inc(ScaleDiv);
end;

procedure TSceneManager.SetCreateSolid(AType: TSolidType);
begin
  Mode := mdCreate;
  CreateWhat := TSolid;
  CreateWhatSolid := AType;
end;

procedure TSceneManager.SetCreateScripted(AType: TShapeID);
begin
  Mode := mdCreate;
  CreateWhat := TScripted;
  CreateWhatScripted := AType;
end;

procedure TSceneManager.Save(const filename: string);
var
  i, n: integer;
  text: string;
  root: TJSONObject;
  shapesArray, layersArray: TJSONArray;
  layer: TLayer;
  shape: TShape;

begin
  Screen.Cursor := crHourglass;
  try
    root := TJSONObject.Create;
    root.AddPair('version', TJSONNumber.Create(ModelVersion));
    layersArray := TJSONArray.Create;
    n := Layers.Count;
    for i := 0 to n - 1 do
    begin
      layer := Layers[i] as TLayer;
      layer.Save(layersArray);
    end;
    root.AddPair('layers', layersArray);
    shapesArray := TJSONArray.Create;
    n := Shapes.Count;
    for i := 0 to n - 1 do
    begin
      Shape := Shapes[i] as TShape;
      Shape.Save(shapesArray);
    end;
    root.AddPair('shapes', shapesArray);
    text := root.ToJSON;
    root.Free;
    TFile.WriteAllText(filename, text);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSceneManager.SaveToFile(const Name: string);
var
  i, n: integer;
  Shape: TShape;
  Layer: TLayer;
  dest: TFileStream;
  buffer: array [0..4] of char;

begin
  Screen.Cursor := crHourglass;
  dest := TFileStream.Create(Name, fmCreate or fmOpenWrite);
  try
    buffer := 'MODL';
    dest.WriteBuffer(buffer, 4);

    FileVersion := ModelVersion;
    dest.WriteBuffer(FileVersion, sizeof(FileVersion));

    n := Layers.Count;
    dest.WriteBuffer(n, sizeof(n));

    {*for i := 0 to n - 1 do
    begin
      layer := Layers[i] as TLayer;
      layer.SaveToFile(dest);
    end;*}

    n := Shapes.Count;
    dest.WriteBuffer(n, sizeof(n));

    for i := 0 to n - 1 do
    begin
      Shape := Shapes[i] as TShape;
      Shape.SaveToFile(dest);
    end;

    Modified := False;
  finally
    dest.Free;
    Screen.Cursor := crDefault;
  end;
end;

function TSceneManager.LoadShape(obj: TJSONObject): TShape;
var
  ID: TShapeID;
  Shape: TShape;
  s: string;

begin
  result := nil;
  s := obj.GetValue('id').Value;
  ID := TShapeID(StrToInt(s));
  shape := CreateShapeFromID(ID);
  if shape <> nil then
  begin
    shape.Load(obj);
    result := shape;
  end;
end;

function TSceneManager.LoadShape(source: TStream): TShape;
var
  ID: TShapeID;
  Shape: TShape;

begin
  result := nil;
  source.ReadBuffer(ID, sizeof(ID));
  shape := CreateShapeFromID(ID);
  if shape <> nil then
  begin
    shape.LoadFromFile(source);
    Shapes.Add(shape);
    result := shape;
  end;
end;

procedure TSceneManager.Load(obj: TJSONObject);
var
  i, n: integer;
  shape: TShape;
  shapesArray: TJSONArray;
  child: TJSONObject;

begin
  Screen.Cursor := crHourglass;
  try
    Empty;
    shapesArray := obj.GetValue('shapes') as TJSONArray;
    n := shapesArray.Count;
    for i := 0 to n - 1 do
    begin
      child := shapesArray.Items[i] as TJSONObject;
      shape := LoadShape(child);
      if shape is TCamera then
        SetCamera(shape as TCamera);
      Shapes.Add(shape);
    end;

    Make;

    Modified := false;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TSceneManager.LoadFromFile(const Name: string);
var
  i, n: integer;
  shape: TShape;
  layer: TLayer;
  source: TFileStream;
  buffer: array [0..4] of char;

begin
  Screen.Cursor := crHourglass;
  source := TFileStream.Create(Name, fmOpenRead);

  try
    Empty;

    // Read the MODL string
    source.ReadBuffer(buffer, 4);
    buffer[4] := chr(0);

    if buffer = 'MODL' then
      // Read the version number
      source.ReadBuffer(FileVersion, sizeof(FileVersion))
    else
    begin
      FileVersion := 7;
      source.Position := 0;
    end;

    // Read layers
    {*if FileVersion > 10 then
    begin
      source.ReadBuffer(n, sizeof(n));
      for i := 1 to n do
      begin
        layer := TLayer.Create;
        layer.LoadFromFile(source);
        Layers.Add(layer);
      end;
    end;*}

    // Read objects
    source.ReadBuffer(n, sizeof(n));
    for i := 1 to n do
    begin
      shape := LoadShape(source);
      if shape is TCamera then
        SetCamera(shape as TCamera);
    end;

    Make;

    Modified := False;
  finally
    source.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TSceneManager.GenerateV30(const Name: string);
var
  OldDecSep: char;
  i: integer;
  dest: TextFile;
  texture: TTexture;
  shape: TShape;

begin
  // Make sure we use '.' for decimal separator
  OldDecSep := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';

  AssignFile(dest, Name);
  try
    Rewrite(dest);
    WriteLn(dest, '// Generated by Model Scene Editor');
    WriteLn(dest, '// (c) 1996, 1999, 2017 Pete Goodwin');
    WriteLn(dest);

    WriteLn(dest, '// Textures...');
    WriteLn(dest);

    for i := 0 to TTextureManager.TextureManager.Textures.Count - 1 do
    begin
      texture := TTextureManager.TextureManager.Textures[i];
      if UsingTexture(texture) then
        texture.Generate(dest);
    end;

    WriteLn(dest, '// Shapes...');
    WriteLn(dest);

    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Generate(dest);
    end;
  finally
    CloseFile(dest);

    // Restore decimal separator
    FormatSettings.DecimalSeparator := OldDecSep;
  end;
end;

procedure TSceneManager.GenerateCoolRay(const Name: string);
var
  OldDecSep: char;
  i, index: integer;
  dest: TextFile;
  s: string;
  shape: TShape;

begin
  // Make sure we use '.' for decimal separator
  OldDecSep := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';

  AssignFile(dest, Name);
  try
    Rewrite(dest);

    s := ExtractFileName(Name);
    index := Pos('.', s);

    if index > 0 then
      s := Copy(s, 1, index - 1);

    WriteLn(dest, 'scene ', s, ';');
    WriteLn(dest);
    WriteLn(dest, 'Scene');
    WriteLn(dest, '{');

    // Make sure camera is output first
    if CurrentCamera <> nil then
      CurrentCamera.GenerateCoolRay(dest);

    WriteLn(dest, '  World');
    WriteLn(dest, '  {');
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;

      if not (shape is TCamera) then
        shape.GenerateCoolRay(dest);
    end;
    WriteLn(dest, '  }');
    WriteLn(dest, '}');
  finally
    CloseFile(dest);

    // Restore decimal separator
    FormatSettings.DecimalSeparator := OldDecSep;
  end;
end;

procedure TSceneManager.GenerateVRML(const Name: string);
var
  OldDecSep: char;
  i: integer;
  dest: TextFile;
  shape: TShape;

begin
  // Make sure we use '.' for decimal separator
  OldDecSep := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';

  AssignFile(dest, Name);
  try
    Rewrite(dest);
    WriteLn(dest, '#VRML V1.0 ascii');
    WriteLn(dest);
    WriteLn(dest, '# Generated by Model Scene Editor');
    WriteLn(dest, '# (c) 1996, 1997 Pete Goodwin');
    WriteLn(dest);

    WriteLn(dest, 'Separator');
    WriteLn(dest, '{');

    // Make sure camera is output first
    if CurrentCamera <> nil then
      CurrentCamera.GenerateVRML(dest);

    // Output all shapes (except cameras)
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if not (shape is TCamera) then
        shape.GenerateVRML(dest);
    end;

    WriteLn(dest, '}');
  finally
    CloseFile(dest);

    // Restore decimal separator
    FormatSettings.DecimalSeparator := OldDecSep;
  end;
end;

procedure TSceneManager.GenerateVRML2(const Name: string);
var
  OldDecSep: char;
  i: integer;
  dest: TextFile;
  shape: TShape;

begin
  // Make sure we use '.' for decimal separator
  OldDecSep := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';

  AssignFile(dest, Name);
  try
    Rewrite(dest);
    WriteLn(dest, '#VRML V2.0 utf8');
    WriteLn(dest);
    WriteLn(dest, '# Generated by Model Scene Editor');
    WriteLn(dest, '# (c) 1996, 1997 Pete Goodwin');
    WriteLn(dest);

    WriteLn(dest, 'Separator');
    WriteLn(dest, '{');

    // Make sure camera is output first
    if CurrentCamera <> nil then
      CurrentCamera.GenerateVRML2(dest);

    // Output all shapes (except cameras)
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if not (shape is TCamera) then
        shape.GenerateVRML2(dest);
    end;

    WriteLn(dest, '}');
  finally
    CloseFile(dest);

    // Restore decimal separator
    FormatSettings.DecimalSeparator := OldDecSep;
  end;
end;

procedure TSceneManager.GenerateUDO(const Name: string);
var
  i: integer;
  dest: TextFile;
  shape: TShape;
  incFile: string;

begin
  incFile := ExtractFileName(Name);
  i := Pos('.', incFile);
  incFile := Copy(incFile, 1, i - 1) + '.inc';

  AssignFile(dest, Name);
  try
    Rewrite(dest);

    WriteLn(dest, 'Version 1');
    WriteLn(dest, 'IncludeFile ''', incFile, '''');
    WriteLn(dest);

    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if not (shape is TCamera) then
        shape.GenerateUDO(dest);
    end;

    CloseFile(dest);

    AssignFile(dest, incFile);
    Rewrite(dest);

    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if not (shape is TCamera) then
        shape.GenerateUDOInclude(dest);
    end;
  finally
    CloseFile(dest);
  end;
end;

procedure TSceneManager.GenerateDirectX(const Name: string; const Options: TExportOptions);
{const
    TOKEN_NAME = 1;
    TOKEN_STRING = 2;
    TOKEN_INTEGER = 3;
    TOKEN_GUID = 5;
    TOKEN_INTEGER_LIST = 6;
    TOKEN_REALNUM_LIST = 7;

    TOKEN_OBRACE = 10;
    TOKEN_CBRACE = 11;
    TOKEN_OPAREN = 12;
    TOKEN_CPAREN = 13;
    TOKEN_OBRACKET = 14;
    TOKEN_CBRACKET = 15;
    TOKEN_OANGLE = 16;
    TOKEN_CANGLE = 17;
    TOKEN_DOT = 18;
    TOKEN_COMMA = 19;
    TOKEN_SEMICOLON = 20;
    TOKEN_TEMPLATE = 31;
    TOKEN_WORD = 40;
    TOKEN_DWORD = 41;
    TOKEN_FLOAT = 42;
    TOKEN_DOUBLE = 43;
    TOKEN_CHAR = 44;
    TOKEN_UCHAR = 45;
    TOKEN_SWORD = 46;
    TOKEN_SDWORD = 47;
    TOKEN_VOID = 48;
    TOKEN_LPSTR = 49;
    TOKEN_UNICODE = 50;
    TOKEN_CSTRING = 51;
    TOKEN_ARRAY = 52;}

var
    i: integer;
    dest: TextFile;
    shape: TShape;

begin
    AssignFile(dest, Name);
    try
        Rewrite(dest);

        // The header
        WriteLn(dest, 'xof 0302txt 0064');

        // Various bits required
        WriteLn(dest, 'template Matrix4x4 {');
        WriteLn(dest, ' <F6F23F45-7686-11cf-8F52-0040333594A3>');
        WriteLn(dest, ' array FLOAT matrix[16];');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template Header {');
        WriteLn(dest, ' <3D82AB43-62DA-11cf-AB39-0020AF71E433>');
        WriteLn(dest, ' WORD major;');
        WriteLn(dest, ' WORD minor;');
        WriteLn(dest, ' DWORD flags;');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template Vector {');
        WriteLn(dest, ' <3D82AB5E-62DA-11cf-AB39-0020AF71E433>');
        WriteLn(dest, ' FLOAT x;');
        WriteLn(dest, ' FLOAT y;');
        WriteLn(dest, ' FLOAT z;');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template MeshFace {');
        WriteLn(dest, ' <3D82AB5F-62DA-11cf-AB39-0020AF71E433>');
        WriteLn(dest, ' DWORD nFaceVertexIndices;');
        WriteLn(dest, ' array DWORD faceVertexIndices[nFaceVertexIndices];');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template Mesh {');
        WriteLn(dest, ' <3D82AB44-62DA-11cf-AB39-0020AF71E433>');
        WriteLn(dest, ' DWORD nVertices;');
        WriteLn(dest, ' array Vector vertices[nVertices];');
        WriteLn(dest, ' DWORD nFaces;');
        WriteLn(dest, ' array MeshFace faces[nFaces];');
        WriteLn(dest, ' [...]');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template FrameTransformMatrix {');
        WriteLn(dest, ' <F6F23F41-7686-11cf-8F52-0040333594A3>');
        WriteLn(dest, ' Matrix4x4 frameMatrix;');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'template Frame {');
        WriteLn(dest, ' <3D82AB46-62DA-11cf-AB39-0020AF71E433>');
        WriteLn(dest, ' [...]');
        WriteLn(dest, '}');
        WriteLn(dest);

        WriteLn(dest, 'Header {');
        WriteLn(dest, ' 1;');
        WriteLn(dest, ' 0;');
        WriteLn(dest, ' 1;');
        WriteLn(dest, '}');
        WriteLn(dest);

        for i := 0 to Shapes.Count - 1 do
        begin
            Shape := Shapes[i] as TShape;
            Shape.GenerateDirectXFile(dest, Options);
        end;
    finally
        CloseFile(dest);
    end;
end;

procedure TSceneManager.DeleteShape(shape: TShape);
begin
  SetModified;
  Shapes.Extract(shape);
  AddUndo(utDeleteShape, shape, nil, nil);
end;

procedure TSceneManager.DeleteSelected;
var
  i: integer;
  shape: TShape;

begin
  shape := nil;
  while CountSelected > 0 do
  begin
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if ssSelected in shape.States then break;
    end;

    if shape <> nil then DeleteShape(shape);
  end;
end;

function TSceneManager.Delete: boolean;
begin
  result := False;
  if CountSelected > 0 then
  begin
    if MessageDlg('Delete selected', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteSelected;
      Make;
      Current := nil;
      result := True;
    end;
  end;
end;

function TSceneManager.CutSelected: boolean;
begin
  result := False;
  if Current <> nil then
  begin
    CopySelected;
    DeleteSelected;
    Make;
    Current := nil;
    result := True;
  end;
end;

procedure TSceneManager.CopySelected;
var
  i, n: integer;
  shape: TShape;
  mem: TMemoryStream;
  handle: HGLOBAL;
  ptr: Pointer;

begin
  n := CountSelected;
  if n > 0 then
  begin
    // Create a memory stream
    mem := TMemoryStream.Create;

    // Write number of objects being copied to clipboard
    mem.WriteBuffer(n, sizeof(n));

    // Save the selected item(s) to the clipboard
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if (ssSelected in shape.States) then shape.SaveToFile(mem);
    end;

    // Get a global handle
    handle := GlobalAlloc(ghnd, mem.Size);

    // Get the pointer
    ptr := GlobalLock(handle);

    // Copy the memory from the stream to the global block
    CopyMemory(ptr, mem.Memory, mem.Size);

    // Open the clipboard
    Clipboard.Open;

    // Move the global buffer into the clipboard
    Clipboard.SetAsHandle(MainForm.ClipForm, handle);

    // Put text in as well
    Clipboard.AsText := Current.Name;

    // All done
    Clipboard.Close;

    // Release the memory stream
    mem.Free;
  end;
end;

procedure TSceneManager.Paste(multiple: boolean);
var
  i, n, j, count: integer;
  shape, shape2: TShape;
  mem: TMemoryStream;
  handle: HGLOBAL;
  size: DWORD;
  dlg: TPasteDialog;

begin
  if Clipboard.HasFormat(MainForm.ClipForm) then
  begin
    // Open the clipboard
    Clipboard.Open;

    // Get the handle of the shape on the clipboard
    handle := Clipboard.GetAsHandle(MainForm.ClipForm);

    // Get the size of the shape
    size := GlobalSize(handle);

    // Create the memory stream
    mem := TMemoryStream.Create;

    // Allocate memory in stream
    mem.SetSize(size);

    // Copy from clipboard
    CopyMemory(mem.Memory, GlobalLock(handle), size);

    // Close the clipboard
    Clipboard.Close;

    // Extract the shapes from the memory stream
    mem.ReadBuffer(n, sizeof(n));

    for i := 1 to n do
    begin
      // Load the shape
      shape := LoadShape(mem);

      // Adjust the name
      shape.Name := shape.Name + '_' + IntToStr(i);

      if multiple then
      begin
        dlg := TPasteDialog.Create(Application);

        dlg.Name.Text := shape.Name;

        dlg.CanTranslate := sfCanTranslate in shape.Features;
        dlg.CanScale := sfCanScale in shape.Features;
        dlg.CanRotate := sfCanRotate in shape.Features;

        dlg.XTrans.Text := FloatToStrF(shape.Translate.X, ffFixed, 6, 4);
        dlg.YTrans.Text := FloatToStrF(shape.Translate.Y, ffFixed, 6, 4);
        dlg.ZTrans.Text := FloatToStrF(shape.Translate.Z, ffFixed, 6, 4);

        dlg.XScale.Text := FloatToStrF(shape.Scale.X, ffFixed, 6, 4);
        dlg.YScale.Text := FloatToStrF(shape.Scale.Y, ffFixed, 6, 4);
        dlg.ZScale.Text := FloatToStrF(shape.Scale.Z, ffFixed, 6, 4);

        dlg.XRotate.Text := FloatToStrF(shape.Rotate.X, ffFixed, 6, 4);
        dlg.YRotate.Text := FloatToStrF(shape.Rotate.Y, ffFixed, 6, 4);
        dlg.ZRotate.Text := FloatToStrF(shape.Rotate.Z, ffFixed, 6, 4);

        if dlg.ShowModal = idOK then
        begin
          shape.Name := dlg.Name.Text;

          shape.Translate.X := StrToFloat(dlg.XTrans.Text);
          shape.Translate.Y := StrToFloat(dlg.YTrans.Text);
          shape.Translate.Z := StrToFloat(dlg.ZTrans.Text);

          shape.Scale.X := StrToFloat(dlg.XScale.Text);
          shape.Scale.Y := StrToFloat(dlg.YScale.Text);
          shape.Scale.Z := StrToFloat(dlg.ZScale.Text);

          shape.Rotate.X := StrToFloat(dlg.XRotate.Text);
          shape.Rotate.Y := StrToFloat(dlg.YRotate.Text);
          shape.Rotate.Z := StrToFloat(dlg.ZRotate.Text);

          if dlg.Increment.Checked then
          begin
            count := StrToInt(dlg.Count.Text);
            for j := 1 to count do
            begin
              shape2 := CreateShapeFromID(shape.GetID);
              shape2.Copy(shape);

              shape2.Name := shape.Name + '_' + IntToStr(j);

              shape2.Translate.X := shape2.Translate.X + StrToFloat(dlg.IncXTrans.Text) * j;
              shape2.Translate.Y := shape2.Translate.Y + StrToFloat(dlg.IncYTrans.Text) * j;
              shape2.Translate.Z := shape2.Translate.Z + StrToFloat(dlg.IncZTrans.Text) * j;

              shape2.Scale.X := shape2.Scale.X + StrToFloat(dlg.IncXScale.Text) * j;
              shape2.Scale.Y := shape2.Scale.Y + StrToFloat(dlg.IncYScale.Text) * j;
              shape2.Scale.Z := shape2.Scale.Z + StrToFloat(dlg.IncZScale.Text) * j;

              shape2.Rotate.X := shape2.Rotate.X + StrToFloat(dlg.IncXRotate.Text) * j;
              shape2.Rotate.Y := shape2.Rotate.Y + StrToFloat(dlg.IncYRotate.Text) * j;
              shape2.Rotate.Z := shape2.Rotate.Z + StrToFloat(dlg.IncZRotate.Text) * j;

              Shapes.Add(shape2);
            end;
          end;
        end;

        dlg.Free;
      end
      else
      begin
        shape.Translate.X := shape.Translate.X + 1;
        SetCurrent(shape);
        MainForm.SetCurrent;
      end;
    end;

    SetModified;

    // Remake the scene
    Make;

    // Clear memory stream
    mem.Free;
  end;
end;

procedure TSceneManager.ImportRAW(const Name: string);
var
  i, size: integer;
  source: TextFile;
  buffer, item, text: string;
  maximum: double;
  a, b, c: TVector;
  polygon: TPolygon;
  progress: TImportDlg;

begin
  maximum := 0;
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;
  polygon := nil;
  progress := TImportDlg.Create(Application);
  AssignFile(source, name);
  Reset(source);
  try
    progress.Show;
    progress.Refresh;
    size := FileSize(source);
    while not eof(source) do
    begin
      readln(source, buffer);
      progress.ProgressBar.Position := FilePos(source) * 100 div size;
      MainForm.Refresh;
      i := Pos(' ', buffer);
      if i > 0 then
      begin
        item := Copy(buffer, 0, i - 1);
        a.x := StrToFloat(item);
        text := Trim(Copy(buffer, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        a.y := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        a.z := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        b.x := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        b.y := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        b.z := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        c.x := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        i := Pos(' ', text);
        item := Copy(text, 0, i - 1);
        c.y := StrToFloat(item);
        text := Trim(Copy(text, i + 1, 255));

        c.z := StrToFloat(text);

        if polygon = nil then
        begin
          polygon := TPolygon.Create;
          polygon.Name := 'Polygon' + IntToStr(Shapes.Count + 1);
          progress.Name.Text := polygon.Name;
          progress.Name.Refresh;
          Shapes.Add(polygon);
        end;

        polygon.AddTriangle(a, b, c);
      end
      else
      begin
        if polygon <> nil then
        begin
          if polygon.GetMaximum > maximum then
            maximum := polygon.GetMaximum;
        end;

        polygon := TPolygon.Create;
        polygon.Name := buffer;
        progress.Name.Text := buffer;
        progress.Name.Refresh;
        Shapes.Add(polygon);
      end;

    end;
    SetModified;
  finally
    CloseFile(source);
    Make;
    MainForm.MainPaintBox.Refresh;
    progress.Free;
    a.Free;
    b.Free;
    c.Free;
  end;
end;

class procedure TSceneManager.Initialise;
begin
  SceneManager := TSceneManager.Create;
end;

procedure TSceneManager.CreateGroup(AType: TGroupType);
var
  i: integer;
  shape: TShape;
  group: TGroupShape;

begin
  if HasMultipleSelected then
  begin
    group := TGroupShape.Create;
    group.Name := 'Group' + IntToStr(Shapes.Count);
    group.GroupType := AType;

    while CountSelected > 0 do
      for i := 0 to Shapes.Count - 1 do
      begin
        shape := Shapes[i] as TShape;
        if (ssSelected in shape.States) then
        begin
          Shapes.Extract(shape);
          group.AddShape(shape);
          break;
        end;
      end;

    Shapes.Add(group);

    SetCurrent(group);
    MainForm.SetCurrent;

    SetModified;
    Current := nil;
    Make;
  end;
end;

procedure TSceneManager.CreateBlob;
var
  i: integer;
  shape: TShape;
  blob: TGroupShape;

begin
  if HasMultipleSelected then
  begin
    blob := TGroupShape.Create;
    blob.Name := 'Blob' + IntToStr(Shapes.Count);
    blob.GroupType := gtBlob;

    while CountSelected > 0 do
      for i := 0 to Shapes.Count - 1 do
      begin
        shape := Shapes[i] as TShape;
        if (ssSelected in shape.States) and (sfCanBlob in shape.Features) then
        begin
          Shapes.Extract(shape);
          blob.AddShape(shape);
          break;
        end
        else
          shape.States := shape.States - [ssSelected];
      end;

    Shapes.Add(blob);

    SetModified;
    Current := nil;
    Make;
  end;
end;

function TSceneManager.CreateGallery: TShape;
var
  i: integer;
  shape: TShape;
  group: TGroupShape;
  dlg: TGalleryDetailsDialog;

begin
  result := nil;

  if CountSelected > 0 then
  begin
    dlg := TGalleryDetailsDialog.Create(Application);

    if dlg.ShowModal = idOK then
    begin
      group := TGroupShape.Create;
      group.Name := dlg.Name.Text;
      group.GroupType := gtGallery;

      while CountSelected > 0 do
        for i := 0 to Shapes.Count - 1 do
        begin
          shape := Shapes[i] as TShape;
          if (ssSelected in shape.States) then
          begin
            Shapes.Extract(shape);
            group.AddShape(shape);
            break;
          end;
        end;

      SetModified;
      Current := nil;
      Make;

      result := group;
    end;
    dlg.Free;
  end
end;

procedure TSceneManager.SelectAll;
var
  i: integer;
  shape: TShape;

begin
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.States := shape.States + [ssSelected];
  end;
end;

procedure TSceneManager.Clear;
var
  i: integer;
  shape: TShape;

begin
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.States := shape.States - [ssSelected];
  end;
end;

function TSceneManager.GetHiddenLineRemoval: boolean;
begin
  result := HiddenLineRemoval;
end;

function TSceneManager.ToggleHiddenLineRemoval: boolean;
begin
  HiddenLineRemoval := not HiddenLineRemoval;
  Make;
  result := HiddenLineRemoval;
end;

function TSceneManager.GetLightShading: boolean;
begin
  result := LightShading;
end;

function TSceneManager.ToggleLightShading: boolean;
begin
  LightShading := not LightShading;
  Make;
  result := LightShading;
end;

function TSceneManager.ToggleOutline: boolean;
begin
  Outline := not Outline;
  Make;
  result := Outline;
end;

function TSceneManager.GetOutline: boolean;
begin
  result := Outline;
end;

procedure TSceneManager.CalculateZBuffer(list: TList<TTriangle>);
var
  i, j: integer;
  shape: TShape;
  triangle: TTriangle;

begin
  list.Clear;

  // Copy all the shapes triangles to a list so we can sort them
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;

    for j := 0 to shape.Triangles.Count - 1 do
    begin
      triangle := shape.Triangles[j] as TTriangle;
      triangle.Shape := shape;
      triangle.GetCenter;

      if CurrentCamera <> nil then
        triangle.Distance := sqrt(sqr(triangle.Center.X - CurrentCamera.Observer.X) +
          sqr(triangle.Center.Y - CurrentCamera.Observer.Y) +
          sqr(triangle.Center.Z - CurrentCamera.Observer.Z));

      if LightShading then
        triangle.GetNormal;

      list.Add(triangle);
    end;
  end;

  list.Sort(TTriangleComparer.Create);
end;

function TSceneManager.CanUndo: boolean;
begin
  if UndoBuffer.Count > 0 then
  begin
    if (UndoIndex = -1) or (UndoIndex > 0) then
      result := True
    else
      result := false;
  end
  else
    result := False;
end;

function TSceneManager.CanRedo: boolean;
begin
  result := UndoIndex <> -1;
end;

function TSceneManager.Undo: boolean;
var
  index: integer;
  undo: TUndo;
  transform: TTransform;
  vector: TVector;

begin
  result := False;

  if UndoIndex = -1 then
    UndoIndex := UndoBuffer.Count - 1
  else
  begin
    dec(UndoIndex);
    if UndoIndex < 0 then UndoIndex := 0;
  end;

  if UndoIndex > UndoBuffer.Count - 1 then
    UndoIndex := UndoBuffer.Count - 1;

  undo := UndoBuffer[UndoIndex] as TUndo;

  case undo.UndoType of
    utCreateShape:
    begin
      // Undoing a create is to remove it
      index := Shapes.IndexOf(undo.Shape);
      if index <> -1 then
      begin
        Shapes.Delete(index);
        Make;
        result := True;
      end;
    end;

    utDeleteShape:
    begin
      // Undoing a delete it to create it again
      Shapes.Add(undo.Shape);
      Make;
      result := True;
    end;

    utApplyTexture:
    begin
      // Unapply a texture means reverting to one stored in undo buffer
      undo.shape.Texture := undo.Previous;
      result := True;
    end;

    utTransformShape:
    begin
      // Undo transformations to a shape
      transform := undo.Previous;
      with undo.shape do
      begin
        Name := transform.Name;
        Translate.Copy(transform.Translate);
        Scale.Copy(transform.Scale);
        Rotate.Copy(transform.Rotate);
      end;
      Make;
      result := True;
    end;

    utTranslateShape:
    begin
      vector := undo.Previous;
      undo.Shape.Translate.Copy(vector);
      Make;
      result := True;
    end;

    utScaleShape:
    begin
      vector := undo.Previous;
      undo.Shape.Scale.Copy(vector);
      Make;
      result := True;
    end;

    utRotateShape:
    begin
      vector := undo.Previous;
      undo.Shape.Rotate.Copy(vector);
      Make;
      result := True;
    end;

    utObserverShape:
    begin
      vector := undo.Previous;
      undo.Shape.SetObserver(Self, vector.x, vector.y, vector.z, True, True, True);
      result := True;
    end;

    utObservedShape:
    begin
      vector := undo.Previous;
      undo.Shape.SetObserved(Self, vector.x, vector.y, vector.z, True, True, True);
      result := True;
    end;
  end;
end;

function TSceneManager.AddUndo(AType: TUndoType; AShape: TShape; APrev, ADetail: Pointer): TUndo;
var
  undo: TUndo;

begin
  undo := TUndo.Create(AType, AShape, APrev, ADetail);

  if UndoBuffer.Count = UndoLimit then
    UndoBuffer.Delete(0);

  UndoBuffer.Add(undo);
  UndoIndex := -1;

  result := undo;
end;

function TSceneManager.FindCamera(const name: string): TCamera;
var
  i: integer;
  shape: TShape;

begin
  result := nil;

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if (shape is TCamera) and (shape.Name = name) then
    begin
      result := shape as TCamera;
      break;
    end;
  end;
end;

function TSceneManager.FindLayer(const name: string): TLayer;
var
  i: integer;
  layer: TLayer;

begin
  result := nil;

  for i := 0 to Layers.Count - 1 do
  begin
    layer := Layers[i] as TLayer;
    if layer.Name = name then
    begin
      result := layer;
      break;
    end;
  end;
end;

function TSceneManager.GetUniformScaling: boolean;
begin
  result := UniformScaling;
end;

procedure TSceneManager.SetUniformScaling(scaling: boolean);
begin
  UniformScaling := scaling;
end;

function TSceneManager.CheckShapeTexture: boolean;
var
  i: integer;
  shape: TShape;

begin
  result := true;

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if not shape.CheckTexture then
    begin
      result := false;
      break;
    end;
  end;
end;

procedure TSceneManager.SetCurrentLayer(layer: TLayer);
begin
  CurrentLayer := layer;
end;

function TSceneManager.GetCurrentLayer: TLayer;
begin
  result := CurrentLayer;
end;

destructor TSceneManager.Destroy;
begin
  AnchorPoint.Free;
  AtmosphereSettings.Free;
  Fog.Free;
  Shapes.Free;
  Layers.Free;
  UndoBuffer.Free;
  ZBuffer.Free;
  ScriptFiles.Free;

  inherited;
end;

function TSceneManager.FindScriptFile(const name: string): TScriptFile;
var
  i: integer;

  script: TScriptFile;

begin
  result := nil;

  for i := 0 to ScriptFiles.Count - 1 do
  begin
    script := ScriptFiles[i];
    if script.FName = name then
    begin
      result := script;
      break;
    end;
  end;

  if (result = nil) and FileExists(name) then
  begin
    script := TScriptFile.Create;
    script.Load(name);
    ScriptFiles.Add(script);
    result := script;
  end;
end;

procedure TSceneManager.NextFrame;
begin
  inc(AnimationPosition);

  if AnimationPosition > 100 then
    AnimationPosition := 0;
end;

////////////////////////////////////////////////////////////////////////////////
//

class function TSceneManager.CreateShapeFromID(ID: TShapeID): TShape;
begin
  case ID of
    siCamera:         result := TCamera.Create;
    siLight:          result := TLight.Create;
    siSpotLight:      result := TSpotLight.Create;
    siCylinderLight:  result := TCylinderLight.Create;
    siAreaLight:      result := TAreaLight.Create;
    siPlane:          result := TPlane.Create;
    siSphere:         result := TSphere.Create;
    siCube:           result := TCube.Create;
    siSolid:          result := TSolid.Create;
    siLathe:          result := TLathe.Create;
    siPolygon:        result := TPolygon.Create;
    siGroup:          result := TGroupShape.Create;
    siDisc:           result := TDisc.Create;
    siTorus:          result := TTorus.Create;
    siSuperEllipsoid: result := TSuperEllipsoid.Create;
    siHeightField:    result := THeightField.Create;
    siBicubicShape:   result := TBicubicShape.Create;
    siText:           result := TText.Create;
    siJuliaFractal:   result := TJuliaFractal.Create;
    siScripted:       result := TScripted.Create;
    siSpring:         result := TSpring.Create;
    siEnvironment:    result := TEnvironment.Create;
    siUser:
    begin
      result := TUserShape.Create;
      (result as TUserShape).Rebuild;
    end;
  else
    raise ELoadShapeError.Create('Invalid shape id [' + IntToStr(ord(ID)) + '] encountered');
  end;
end;

{ TTriangleComparer }

function TTriangleComparer.Compare(const t1, t2: TTriangle): Integer;
begin
  {if abs(t1.Center.z - t2.Center.z) < 0.001 then
    result := 0
  else if t1.Center.z < t2.Center.z then
    result := -1
  else
    result := 1;}
  if abs(t1.Distance - t2.Distance) < 0.001 then
    result := 0
  else if t1.Distance < t2.Distance then
    result := -1
  else
    result := 1;
end;

end.
