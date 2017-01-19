unit scndat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Texture;

const
  d2r = pi / 180.0;
  r2d = 180.0 / pi;
  ViewSize = 1000;
  ViewDivisions = 10;
  ViewRange = 20.0;

type
  ELoadShapeError = class(Exception);

  TFormat = (fmtTargaCompressed, fmtTarga, fmtPNG, fmtPPM, fmtBMP);

  TMode = (mdSelect, mdCreate, mdTranslate, mdScale, mdRotate);

  TView = (vwFront, vwBack, vwTop, vwBottom, vwLeft, vwRight, vwCamera);

  TNormalType = (ntNone, ntBumps, ntDents, ntRipples, ntWaves, ntWrinkles,
    ntBumpMap);

  TShape = class;
  TSceneData = class;

  TVector = class(TObject)
    public
      X, Y, Z: double;
      constructor Create; virtual;
      procedure Copy(original: TVector);
      procedure SaveToFile(dest: TStream);
      procedure LoadFromFile(source: TStream);
    end;

  TCoord = class(TVector)
    public
      Selected: boolean;
      Point: TPoint;
      constructor Create; virtual;
      procedure Transform(shape: TShape; var xf, yf, zf: double);
      procedure Make(scene: TSceneData; shape: TShape);
      procedure DrawPolygon(scene: TSceneData; canvas: TCanvas;
        view: TView; first: boolean);
    end;

  TTriangle = class(TObject)
    public
      Points: array [1..3] of TCoord;
      constructor Create;
      destructor Destroy;
      procedure Make(scene: TSceneData; shape: TShape);
      procedure Draw(canvas: TCanvas);
      procedure DrawPolygon(scene: TSceneData; canvas: TCanvas; view: TView);
      procedure SaveToFile(dest: TStream);
      procedure LoadFromFile(source: TStream);
    end;

  TShapeID = (siShape, siCamera, siSphere);

  TShape = class(TObject)
    public
      Name: string[32];
      Shadow: boolean;
      Display: boolean;
      Triangles: TList;                   { list of triangles }
      Parent: TShape;                     { parent instance }
      Selected, Selectable: boolean;
      Bounding: TRect;
      Texture: TTexture;                  { texture instance }
      Translate: TVector;
      Scale: TVector;
      Rotate: TVector;

      constructor Create; virtual;
      destructor Destroy; virtual;
      function GetID: TShapeID; virtual;
      function GetDescription: string;
      function CanTranslate: boolean; virtual;
      function CanScale: boolean; virtual;
      function CanRotate: boolean; virtual;
      function CanEdit: boolean; virtual;
      function Edit: boolean; virtual;
      function UsingTexture(text: TTexture): boolean; virtual;
      procedure Make(scene: TSceneData); virtual;
      procedure Draw(Scene: TSceneData; canvas: TCanvas); virtual;
      procedure SetTranslate(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
      procedure SetScale(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
      procedure SetRotate(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
      procedure AddTriangle(i, j, k: TVector);
      procedure ResetTriangleSelection;
      procedure SaveToFile(dest: TStream); virtual;
      procedure LoadFromFile(source: TStream); virtual;
      procedure Generate(var dest: TextFile); virtual;
      procedure Details; virtual;
    end;

  TShapeType = class of TShape;

  TProjectionType = (ptPerspective, ptOrthographic, ptFisheye,
    ptUltraWideAngle, ptOmnimax, ptPanoramic, ptCylinder);

  TCamera = class(TShape)
  public
    ProjectionType: TProjectionType;
    Angle: TVector;
    Observer, Observed: TVector;
    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure Make(scene: TSceneData); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    end;

  TAtmosphereType = (atNone,
    atIsotropic,
    atMIEHazy,
    atMIEMucky,
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
    procedure SaveToFile(stream: TStream);
    procedure LoadFromFile(stream: TStream);
  end;

  TSceneData = class(TDataModule)
    procedure SceneDataCreate(Sender: TObject);
  private
    { Private declarations }
    Modified: boolean;
    Mode: TMode;
    CreateWhat: TShapeType;
    View: TView;
    Current: TShape;
    CurrentCamera: TCamera;
    Grid: double;
    ScaleMult, ScaleDiv: integer;
    Dragging: boolean;
    AnchorPoint: TVector;

    AtmosphereSettings: TAtmosphereSettings;
    Fog: TFog;
  public
    { Public declarations }
    Shapes: TList;
  end;

var
  SceneData: TSceneData;

implementation

uses Main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
// VECTOR

constructor TVector.Create;
begin
  X := 0.0;
  Y := 0.0;
  Z := 0.0;
end;

procedure TVector.Copy(original: TVector);
begin
  X := original.X;
  Y := original.Y;
  Z := original.Z;
end;

procedure TVector.SaveToFile(dest: TStream);
begin
  dest.WriteBuffer(x, sizeof(x));
  dest.WriteBuffer(y, sizeof(y));
  dest.WriteBuffer(z, sizeof(z));
end;

procedure TVector.LoadFromFile(source: TStream);
begin
  source.ReadBuffer(x, sizeof(x));
  source.ReadBuffer(y, sizeof(y));
  source.ReadBuffer(z, sizeof(z));
end;

////////////////////////////////////////////////////////////////////////////////
// COORD

constructor TCoord.Create;
begin
  inherited Create;
  Selected := False;
  Point.X := 0;
  Point.Y := 0;
end;

procedure TCoord.Transform(shape: TShape; var xf, yf, zf: double);
var
  xt, yt, zt, cosx, sinx, cosy, siny, cosz, sinz: double;

begin
  X := xf;
  Y := yf;
  Z := zf;

  while shape <> nil do
    begin
    if shape.CanScale then
      begin
        xf := xf * shape.Scale.X;
        yf := yf * shape.Scale.Y;
        zf := zf * shape.Scale.Z;
      end;

    if shape.CanRotate then
      begin
      { rotate about z axis }
      cosz := cos(d2r * shape.Rotate.Z);
      sinz := sin(d2r * shape.Rotate.Z);
      xt := xf * cosz + yf * sinz;
      yt := yf * cosz - xf * sinz;
      xf := xt;
      yf := yt;

      { rotate about y axis }
      cosy := cos(d2r * shape.Rotate.Y);
      siny := sin(d2r * shape.Rotate.Y);
      xt := xf * cosy - zf * siny;
      zt := xf * siny + zf * cosy;
      xf := xt;
      zf := zt;

      { rotate about x axis }
      cosx := cos(d2r * shape.Rotate.X);
      sinx := sin(d2r * shape.Rotate.X);
      yt := yf * cosx + zf * sinx;
      zt := zf * cosx - yf * sinx;
      yf := yt;
      zf := zt;
      end;

    if shape.CanTranslate then
      begin
        xf := xf + shape.Translate.X;
        yf := yf + shape.Translate.Y;
        zf := zf + shape.Translate.Z;
      end;

    shape := shape.Parent;
    end;
end;

procedure TCoord.Make(scene: TSceneData; shape: TShape);
var
  xx, yy, zz: integer;
  xf, yf, zf: double;
  xt, yt, zt, sign, sinx, cosx, siny, cosy: double;

begin
  xf := X;
  yf := Y;
  zf := Z;

  Transform(shape, xf, yf, zf);

  if Scene.View = vwCamera then
    begin
    if Scene.CurrentCamera <> nil then
      begin
        { Calculate angles }
        with Scene.CurrentCamera do
        begin
          sinx := sin(Angle.X);
	  siny := sin(Angle.Y);
	  cosx := cos(Angle.X);
	  cosy := cos(Angle.Y);

	  { Calculate sign of observer relative to observed point }
          sign := Observed.Z - Observer.Z;

	  { Translate world so observer becomes origin }
	  xf := xf - Observer.X;
	  yf := yf - Observer.Y;
	  zf := zf - Observer.Z;
        end;

	{ Rotate about y axis }
	xt := cosy * xf - siny * zf;
	zt := siny * xf + cosy * zf;
	xf := xt;
	zf := zt;

	{ Rotate about x axis }
	yt := cosx * yf + sinx * zf;
	zt := cosx * zf - sinx * yf;
	yf := yt;
	zf := zt;

	{ Calculate perspective }
	if (zf < -2) and (sign < 0) then
	  begin
	  xt := -xf * ViewSize / zf;
	  yt := -yf * ViewSize / zf;
	  end
	else if (zf > 2) and (sign > 0) then
	  begin
	  xt := xf * ViewSize / zf;
	  yt := yf * ViewSize / zf;
          end;

	xf := xt;
	yf := yt;

	Point.X := trunc(xf);
	Point.Y := trunc(-yf);
      end
    end
  else
    begin
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
  if Point.X < shape.Bounding.Left then
    shape.Bounding.left := Point.X - 1;

  if Point.X >= shape.Bounding.right then
    shape.Bounding.right := Point.X + 1;

  if Point.Y < shape.Bounding.top then
    shape.Bounding.top := Point.Y - 1;

  if Point.Y >= shape.Bounding.bottom then
    shape.Bounding.bottom := Point.y + 1;
end;

procedure TCoord.DrawPolygon(scene: TSceneData; canvas: TCanvas;
  view: TView; first: boolean);
var
  xx, yy: integer;

begin
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

////////////////////////////////////////////////////////////////////////////////
// TRIANGLE

constructor TTriangle.Create;
begin
  Points[1] := TCoord.Create;
  Points[2] := TCoord.Create;
  Points[3] := TCoord.Create;
end;

destructor TTriangle.Destroy;
begin
  Points[1].Free;
  Points[2].Free;
  Points[3].Free;
end;

procedure TTriangle.Make(scene: TSceneData; shape: TShape);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].Make(scene, shape);
end;

procedure TTriangle.Draw(canvas: TCanvas);
begin
  with Canvas do
  begin
    MoveTo(Points[1].Point.X + ViewSize, Points[1].Point.Y + ViewSize);
    LineTo(Points[2].Point.X + ViewSize, Points[2].Point.Y + ViewSize);
    LineTo(Points[3].Point.X + ViewSize, Points[3].Point.Y + ViewSize);
    LineTo(Points[1].Point.X + ViewSize, Points[1].Point.Y + ViewSize);
  end;
end;

procedure TTriangle.DrawPolygon(scene: TSceneData; canvas: TCanvas; view: TView);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].DrawPolygon(scene, canvas, view, i = 0);

  Points[1].DrawPolygon(scene, canvas, view, False);
end;

procedure TTriangle.SaveToFile(dest: TStream);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].SaveToFile(dest);
end;

procedure TTriangle.LoadFromFile(source: TStream);
var
  i: integer;

begin
  for i := 1 to 3 do
    Points[i].LoadFromFile(source);
end;

////////////////////////////////////////////////////////////////////////////////
// SHAPE

constructor TShape.Create;
begin
  Triangles := TList.Create;
  Translate := TVector.Create;
  Scale := TVector.Create;
  Rotate := TVector.Create;
  Scale.X := 1;
  Scale.Y := 1;
  Scale.Z := 1;
  Shadow := True;
  Display := True;
  Selected := False;
  Selectable := False;
  Parent := Nil;
  Texture := Nil;
end;

destructor TShape.Destroy;
begin
  Triangles.Free;
  Translate.Free;
  Scale.Free;
  Rotate.Free;
end;

function TShape.GetID: TShapeID;
begin
  result := siShape;
end;

function TShape.GetDescription: string;
var
  t, description: string;

begin
  case GetID of
    siCamera: t := 'Camera';
    //TLight: t := 'Light';
    //TSpotLight: t := 'SpotLight';
    //TCylinderLight: t := 'CylinderLight';
    //TAreaLight: t := 'AreaLight';
    //TPlane: t := 'Plane';
    //TSphere: t := 'Sphere';
    //TCube: t := 'Cube';
    //TSolid: t := 'Solid';
    //TPolygon: t := 'Polygon';
  else
    t := 'Unknown';
  end;
  description := Name + ': ' + t;
  result := description;
end;

function TShape.CanTranslate: boolean;
begin
  result := False;
end;

function TShape.CanScale: boolean;
begin
  result := False;
end;

function TShape.CanRotate: boolean;
begin
  result := False;
end;

function TShape.CanEdit: boolean;
begin
  result := False;
end;

function TShape.Edit: boolean;
begin
  result := False;
end;

procedure TShape.Make(scene: TSceneData);
var
  i: integer;
  triangle: TTriangle;

begin
  Bounding.left := ViewSize;
  Bounding.right := -ViewSize;
  Bounding.top := ViewSize;
  Bounding.bottom := -ViewSize;
  for i := 0 to Triangles.Count - 1 do
    begin
    triangle := Triangles.Items[i];
    triangle.Make(scene, Self);
    end;
end;

procedure TShape.Draw(Scene: TSceneData; canvas: TCanvas);
var
  i: integer;
  triangle: TTriangle;

begin
  if Display then
  begin
    if texture <> nil then
      canvas.Pen.Color := texture.GetPaletteRGB
    else
      canvas.Pen.Color := clWhite;

    for i := 0 to Triangles.Count - 1 do
    begin
      triangle := Triangles.Items[i];
      triangle.Draw(canvas);
    end;

    if Selected then
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
end;

procedure TShape.SetTranslate(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Translate.X := x;
  if yb then Translate.Y := y;
  if zb then Translate.Z := z;
  Make(scene);
end;

procedure TShape.SetScale(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Scale.X := x;
  if yb then Scale.Y := y;
  if zb then Scale.Z := Z;
  Make(scene);
end;

procedure TShape.SetRotate(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then Rotate.X := x;
  if yb then Rotate.Y := y;
  if zb then Rotate.Z := z;
  Make(scene);
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

procedure TShape.SaveToFile(dest: TStream);
var
  t: Longint;
  buffer: string[32];

begin
  t := ord(GetID);
  dest.WriteBuffer(t, sizeof(t));
  dest.WriteBuffer(Name, sizeof(Name));
  dest.WriteBuffer(Shadow, sizeof(Shadow));

  if texture <> nil then
    buffer := texture.Name
  else
    buffer := 'Unknown';

  dest.WriteBuffer(buffer, sizeof(buffer));

  Translate.SaveToFile(dest);
  Scale.SaveToFile(dest);
  Rotate.SaveToFile(dest);
end;

procedure TShape.LoadFromFile(source: TStream);
var
  buffer: string[32];

begin
  source.ReadBuffer(Name, sizeof(Name));
  source.ReadBuffer(Shadow, sizeof(Shadow));

  source.ReadBuffer(buffer, sizeof(buffer));
  Texture := MainForm.FindTexture(buffer);

  Translate.LoadFromFile(source);
  Scale.LoadFromFile(source);
  Rotate.LoadFromFile(source);
end;

procedure TShape.Generate(var dest: TextFile);
begin
  if Texture <> nil then
    WriteLn(dest, '    texture { ', Texture.Name, ' }');

  if CanRotate then
    WriteLn(dest, Format('    rotate <%6.2f, %6.2f, %6.2f>',
      [-Rotate.x, -Rotate.y, -Rotate.z]));

  if CanScale then
    WriteLn(dest, Format('    scale <%6.4f, %6.4f, %6.4f>',
      [Scale.x, Scale.y, Scale.z]));

  if CanTranslate then
    WriteLn(dest, Format('    translate <%6.4f, %6.4f, %6.4f>',
      [Translate.x, Translate.y, Translate.z]));
end;

procedure TShape.Details;
begin
end;

////////////////////////////////////////////////////////////////////////////////
// CAMERA

constructor TCamera.Create;
begin
  inherited Create;
  ProjectionType := ptPerspective;
  Angle := TVector.Create;
  Observer := TVector.Create;
  Observed := TVector.Create;

  Observer.Z := -10;
end;

destructor TCamera.Destroy;
begin
  inherited Destroy;
  Angle.Free;
  Observer.Free;
  Observed.Free;
end;

function TCamera.GetID: TShapeID;
begin
  result := siCamera;
end;

function Atan2(y, x: extended): extended;
Assembler;
asm
  fld[y]
  fld[x]
  fpatan
end;

procedure TCamera.Make(scene: TSceneData);
var
  dist: double;

begin
  inherited Make(scene);

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

  Angle.x := -ATan2(Observed.y - Observer.y, dist);
  Angle.y := ATan2(Observed.x - Observer.x, dist);
  Angle.z := 0.0;
end;

procedure TCamera.SaveToFile(dest: TStream);
var
  t: Longint;

begin
  t := ord(GetID);
  dest.WriteBuffer(t, sizeof(t));
  dest.WriteBuffer(Name, sizeof(Name));
  Observer.SaveToFile(dest);
  Observed.SaveToFile(dest);
end;

procedure TCamera.LoadFromFile(source: TStream);
begin
  source.ReadBuffer(Name, sizeof(Name));
  Observer.LoadFromFile(source);
  Observed.LoadFromFile(source);
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

function TShape.UsingTexture(text: TTexture): boolean;
begin
  if text = Texture then
    result := True
  else
    result := False;
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
//  TSceneData

procedure TSceneData.SceneDataCreate(Sender: TObject);
begin
  Modified := False;
  Mode := mdSelect;
  View := vwFront;
  Current := nil;
  CurrentCamera := nil;
  ScaleMult := 1;
  ScaleDiv := 1;
  Grid := 0;
  Dragging := False;
  Shapes := TList.Create;
  AtmosphereSettings := TAtmosphereSettings.Create;
  Fog := TFog.Create;
  AnchorPoint := TVector.Create;
end;

end.
