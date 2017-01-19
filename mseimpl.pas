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

// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)

unit mseimpl;

interface

{$IFDEF USE_TYPE_LIBRARY}
uses
  ComObj, ActiveX, model_TLB, Texture, Scene, StdVcl;

type
  TModelSceneEditor = class(TAutoObject, IModelScene)
  protected
    function GetShapeCount: Integer; safecall;
    function GetTextureCount: Integer; safecall;
    procedure LoadScene(const Filename: WideString); safecall;
    procedure SaveScene(const Filename: WideString); safecall;
    function GetTexture(Index: Integer): IModelTexture; safecall;
    function CreateTexture(TextureType: ModelTexture;
      const Name: WideString): IModelTexture; safecall;
    function CreateShape(ShapeType: ModelShape;
      const Name: WideString): IModelShape; safecall;
    function GetShape(Index: Integer): IModelShape; safecall;
    { Protected declarations }
  end;

  TModelSceneTexture = class(TAutoObject, IModelTexture)
  public
    constructor Create(Texture: TTexture);
  private
    FTexture: TTexture;
  protected
    function GetName: WideString; safecall;
    procedure SetName(const Name: WideString); safecall;
    procedure GetColour(out Red, Green, Blue, Filter, Transmit: double); safecall;
    procedure SetColour(Red, Green, Blue, Filter, Transmit: double); safecall;
    function GetAttributes: OleVariant; safecall;
    procedure SetAttributes(Attributes: OleVariant); safecall;
  end;

  TModelSceneShape = class(TAutoObject, IModelShape)
  public
    constructor Create(Shape: TShape);
  private
    FShape: TShape;
  protected
    function GetName: WideString; safecall;
    procedure SetName(const Name: WideString); safecall;
    function GetTexture: IModelTexture; safecall;
    procedure SetTexture(const Texture: IModelTexture); safecall;
    procedure GetTranslation(out X, Y, Z: double); safecall;
    procedure SetTranslation(X, Y, Z: double); safecall;
    procedure GetScale(out X, Y, Z: double); safecall;
    procedure SetScale(X, Y, Z: double); safecall;
    procedure GetRotation(out X, Y, Z: double); safecall;
    procedure SetRotation(X, Y, Z: double); safecall;
    function GetAttributes: OleVariant; safecall;
    procedure SetAttributes(Attributes: OleVariant); safecall;
  end;
{$ENDIF}

implementation

{$IFDEF USE_TYPE_LIBRARY}
uses ComServ, Main;

////////////////////////////////////////////////////////////////////////////////
//  ModelSceneTexture

constructor TModelSceneTexture.Create(Texture: TTexture);
begin
  FTexture := Texture;
end;

function TModelSceneTexture.GetName: WideString;
begin
  result := FTexture.Name;
end;

procedure TModelSceneTexture.SetName(const Name: WideString);
begin
  FTexture.Name := Name;
end;

procedure TModelSceneTexture.GetColour(out Red, Green, Blue, Filter, Transmit: double);
begin
  Red := FTexture.Red;
  Green := FTexture.Green;
  Blue := FTexture.Blue;
  Filter := FTexture.Filter;
  Transmit := FTexture.Transmit;
end;

procedure TModelSceneTexture.SetColour(Red, Green, Blue, Filter, Transmit: double);
begin
  FTexture.Red := Red;
  FTexture.Green := Green;
  FTexture.Blue := Blue;
  FTexture.Filter := Filter;
  FTexture.Transmit := Transmit;
end;

function TModelSceneTexture.GetAttributes: OleVariant;
begin
end;

procedure TModelSceneTexture.SetAttributes(Attributes: OleVariant);
begin
end;

////////////////////////////////////////////////////////////////////////////////
//  ModelSceneShape

constructor TModelSceneShape.Create(Shape: TShape);
begin
  FShape := Shape;
end;

function TModelSceneShape.GetName: WideString;
begin
  result := FShape.Name;
end;

procedure TModelSceneShape.SetName(const Name: WideString);
begin
  FShape.Name := Name;
end;

function TModelSceneShape.GetTexture: IModelTexture;
var
  Texture: TModelSceneTexture;

begin
  Texture := TModelSceneTexture.Create(FShape.Texture);

  result := Texture;
end;

procedure TModelSceneShape.SetTexture(const Texture: IModelTexture);
var
  name: string;
  pTexture: TTexture;

begin
  name := Texture.GetName;
  pTexture := MainForm.FindTexture(name);

  if pTexture <> nil then
    FShape.SetTexture(pTexture);
end;

procedure TModelSceneShape.GetTranslation(out X, Y, Z: double);
begin
  X := FShape.Translate.X;
  Y := FShape.Translate.Y;
  Z := FShape.Translate.Z;
end;

procedure TModelSceneShape.SetTranslation(X, Y, Z: double);
begin
  FShape.SetTranslate(MainForm.SceneData, X, Y, Z, true, true, true);
end;

procedure TModelSceneShape.GetScale(out X, Y, Z: double);
begin
  X := FShape.Scale.X;
  Y := FShape.Scale.Y;
  Z := FShape.Scale.Z;
end;

procedure TModelSceneShape.SetScale(X, Y, Z: double);
begin
  FShape.SetScale(MainForm.SceneData, X, Y, Z, true, true, true);
end;

procedure TModelSceneShape.GetRotation(out X, Y, Z: double);
begin
  X := FShape.Rotate.X;
  Y := FShape.Rotate.Y;
  Z := FShape.Rotate.Z;
end;

procedure TModelSceneShape.SetRotation(X, Y, Z: double);
begin
  FShape.SetRotate(MainForm.SceneData, x, y, z, true, true, true);
end;

function TModelSceneShape.GetAttributes: OleVariant;
begin
end;

procedure TModelSceneShape.SetAttributes(Attributes: OleVariant);
begin
end;

////////////////////////////////////////////////////////////////////////////////
//  ModelSceneEditor

function TModelSceneEditor.GetShapeCount: Integer;
begin
  result := MainForm.SceneData.Shapes.Count;
end;

function TModelSceneEditor.GetTextureCount: Integer;
begin
  result := MainForm.Textures.Count;
end;

procedure TModelSceneEditor.LoadScene(const Filename: WideString);
begin
  MainForm.SceneData.LoadFromFile(Filename);
end;

procedure TModelSceneEditor.SaveScene(const Filename: WideString);
begin
  MainForm.SceneData.SaveToFile(Filename);
end;

function TModelSceneEditor.GetTexture(Index: Integer): IModelTexture;
var
  Texture: TModelSceneTexture;

begin
  Texture := TModelSceneTexture.Create(MainForm.Textures[Index]);

  result := Texture;
end;

function TModelSceneEditor.CreateTexture(TextureType: ModelTexture;
  const Name: WideString): IModelTexture;
var
  Texture: TTexture;
  ModelSceneTexture: TModelSceneTexture;

begin
  case TextureType of
    TextureColour: Texture := TTexture.Create;
    TextureAgate,
    TextureAverage,
    TextureBozo,
    TextureBrick,
    TextureBumps,
    TextureChecker,
    TextureCrackle,
    TextureDents,
    TextureGradient,
    TextureGranite,
    TextureHexagon,
    TextureLeopard,
    TextureMandelbrot,
    TextureMarble,
    TextureOnion,
    TextureQuilted,
    TextureRadial,
    TextureRipples,
    TextureSpiral1,
    TextureSpiral2,
    TextureSpotted,
    TextureWaves,
    TextureWood,
    TextureWrinkles,
    TextureMap,
    TextureImage,
    TextureSpiral: Texture := nil
  else
    Texture := nil;
  end;

  if Texture <> nil then
  begin
    Texture.Name := Name;
    MainForm.Textures.Add(Texture);

    ModelSceneTexture := TModelSceneTexture.Create(Texture);
    result := ModelSceneTexture;
  end
  else
    result := nil;
end;

function TModelSceneEditor.CreateShape(ShapeType: ModelShape;
  const Name: WideString): IModelShape;
var
  Shape: TShape;
  ModelSceneShape: TModelSceneShape;

begin
  case ShapeType of
    ShapeCamera: Shape := TCamera.Create;
    ShapeLight,
    ShapeSpotLight,
    ShapeCylinderLight,
    ShapeAreaLight,
    ShapePlane,
    ShapeSphere,
    ShapeCube,
    ShapeSolid,
    ShapePolygon,
    ShapeHeightField,
    ShapeBicubic,
    ShapeUser,
    ShapeGroup,
    ShapeGallery,
    ShapeDisc,
    ShapeTorus,
    ShapeSuperEllipsoid,
    ShapeText,
    ShapeLathe,
    ShapeJuliaFractal,
    ShapeScripted,
    ShapeSpring: Shape := nil
  else
    Shape := nil;
  end;

  if Shape <> nil then
  begin
    Shape.Name := Name;
    MainForm.SceneData.Shapes.Add(Shape);

    ModelSceneShape := TModelSceneShape.Create(Shape);
    result := ModelSceneShape;
  end
  else
    result := nil;
end;

function TModelSceneEditor.GetShape(Index: Integer): IModelShape;
var
  ModelSceneShape: TModelSceneShape;

begin
  ModelSceneShape := TModelSceneShape.Create(MainForm.SceneData.Shapes[Index] as TShape);

  result := ModelSceneShape;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TModelSceneEditor, Class_ModelSceneEditor,
    ciSingleInstance, tmApartment);
{$ENDIF}

end.
