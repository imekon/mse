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

unit Light;

interface

uses
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Misc, Vector, Texture, Scene,
    LightEdit, SpotEdit, AreaEdit, DirectX;

type
  TLooksLike = (llLight, llSphere, llCube, llCone, llCylinder);

  TLight = class(TShape)
    public
      Red, Green, Blue: double;
      FadeDistance: double;
      FadePower: double;
      AtmosphericAttenuation: boolean;
      LooksLike: TLooksLike;
      Shadowless: boolean;

      constructor Create; override;
      function GetID: TShapeID; override;
      function CanScale: boolean;
      function CanRotate: boolean;
      procedure Generate(var dest: TextFile); override;
      procedure GenerateVRML(var dest: TextFile); override;
      procedure GenerateCoolRay(var dest: TextFile); override;
      procedure GenerateLight(var dest: TextFile); virtual;
      procedure GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame); override;
      function CheckTexture: boolean; override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Details; override;
      procedure DetailsLight(dlg: TLightEditorDlg; save: boolean);
      procedure Build;
    end;

  TSpotLight = class(TLight)
    public
      PointAt: TCoord;
      Radius, Falloff, Tightness: double;

      constructor Create; override;
      destructor Destroy; override;
      function GetID: TShapeID; override;
      procedure Draw(Scene: TSceneData; theTriangles: TList; canvas: TCanvas; Mode: TPenMode); override;
      procedure Make(scene: TSceneData; theTriangles: TList); override;
      function GetObserved: TVector; override;
      procedure SetObserved(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean); override;
      procedure GenerateLight(var dest: TextFile); override;
      procedure GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Details; override;
    end;

  TCylinderLight = class(TSpotLight)
    public
      function GetID: TShapeID; override;
      procedure GenerateLight(var dest: TextFile); override;
    end;

  TAreaLight = class(TLight)
    public
      Adaptive, Width, Height: integer;
      Jitter: boolean;

      constructor Create; override;
      function GetID: TShapeID; override;
      procedure GenerateLight(var dest: TextFile); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Details; override;
    end;

  procedure CreateLight(shape: TShape; x, y, z: double);

implementation

uses Main, Plane, Sphere, Solid, engine;

////////////////////////////////////////////////////////////////////////////////
// TLight

constructor TLight.Create;
begin
  inherited Create;

  Features := Features + StandardFeatures;

  CreateLight(Self, 0, 0, 0);
  Red := 1;
  Green := 1;
  Blue := 1;
  FadeDistance := 0;
  FadePower := 0;
  AtmosphericAttenuation := False;
  LooksLike := llLight;
  Shadowless := False;
end;

function TLight.GetID: TShapeID;
begin
  result := siLight;
end;

function TLight.CanScale: boolean;
begin
  result := LooksLike <> llLight;
end;

function TLight.CanRotate: boolean;
begin
  result := LooksLike <> llLight;
end;

function TLight.CheckTexture: boolean;
begin
  result := true;
end;

procedure TLight.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'light_source');
  WriteLn(dest, '{');
  WriteLn(dest,
    Format('    <%6.4f, %6.4f, %6.4f> color red %6.4f green %6.4f blue %6.4f',
    [Translate.x, Translate.y, Translate.z, Red, Green, Blue]));

  if Shadowless then
    WriteLn(dest, '    shadowless');

  GenerateLight(dest);

  if Texture <> nil then
    case LooksLike of
      llCube:     WriteLn(dest, Format('    looks_like { box { <-1, -1, -1> <1, 1, 1> texture { %s } } }', [Texture.Name]));
      llSphere:   WriteLn(dest, Format('    looks_like { sphere {<0, 0, 0> 1 texture { %s } } }', [Texture.Name]));
      llCone:     WriteLn(dest, Format('    looks_like { cone {<0, 1, 0>, 0 <0, -1, 0>, 1 texture { %s } } }', [Texture.Name]));
      llCylinder: WriteLn(dest, Format('    looks_like { cylinder {<0, 1, 0> <0, -1, 0> 1 texture { %s } } }', [Texture.Name]));
    end
  else
    case LooksLike of
      llCube:     WriteLn(dest, '    looks_like { box { <-1, -1, -1> <1, 1, 1> } }');
      llSphere:   WriteLn(dest, '    looks_like { sphere {<0, 0, 0> 1 } }');
      llCone:     WriteLn(dest, '    looks_like { cone {<0, 1, 0>, 0 <0, -1, 0>, 1 } }');
      llCylinder: WriteLn(dest, '    looks_like { cylinder {<0, 1, 0> <0, -1, 0> 1 } }');
    end;

  if FadeDistance > 0 then
  begin
    WriteLn(dest, Format('    fade_distance %6.4f', [FadeDistance]));
    WriteLn(dest, Format('    fade_power %6.4f', [FadePower]));
  end;

  if AtmosphericAttenuation then
    WriteLn(dest, '    atmospheric_attenuation TRUE');

  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TLight.GenerateVRML(var dest: TextFile);
begin
  WriteLn(dest, '  PointLight');
  WriteLn(dest, '  {');
  WriteLn(dest, Format('    color %6.4f %6.4f %6.4f',
    [Red, Green, Blue]));
  WriteLn(dest, Format('    location %6.4f %6.4f %6.4f',
    [Translate.X, Translate.Y, Translate.Z]));
  WriteLn(dest, '  }');
  WriteLn(dest);
end;

procedure TLight.GenerateLight(var dest: TextFile);
begin
end;

procedure TLight.GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
var
  Light: IDirect3DRMLight;

begin
  D3DRM.CreateLightRGB(D3DRMLIGHT_POINT, Red, Green, Blue, Light);

  MeshFrame.AddLight(Light);

  MeshFrame.AddTranslation(D3DRMCOMBINE_AFTER, Translate.X, Translate.Y, Translate.Z);
end;

procedure TLight.GenerateCoolRay(var dest: TextFile);
begin
  WriteLn(dest, '    PointLight');
  WriteLn(dest, '    {');
  GenerateCoolRayDetails(dest);
  WriteLn(dest, '    }');
end;

procedure TLight.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);
  dest.WriteBuffer(Red, sizeof(Red));
  dest.WriteBuffer(Green, sizeof(Green));
  dest.WriteBuffer(Blue, sizeof(Blue));
  dest.WriteBuffer(FadeDistance, sizeof(FadeDistance));
  dest.WriteBuffer(FadePower, sizeof(FadePower));
  dest.WriteBuffer(AtmosphericAttenuation, sizeof(AtmosphericAttenuation));
  dest.WriteBuffer(LooksLike, sizeof(LooksLike));
  dest.WriteBuffer(Shadowless, sizeof(Shadowless));
end;

procedure TLight.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);
  source.ReadBuffer(Red, sizeof(Red));
  source.ReadBuffer(Green, sizeof(Green));
  source.ReadBuffer(Blue, sizeof(Blue));
  source.ReadBuffer(FadeDistance, sizeof(FadeDistance));
  source.ReadBuffer(FadePower, sizeof(FadePower));
  source.ReadBuffer(AtmosphericAttenuation, sizeof(AtmosphericAttenuation));
  if MainForm.SceneData.FileVersion > 7 then
  begin
    source.ReadBuffer(LooksLike, sizeof(LooksLike));
    source.ReadBuffer(Shadowless, sizeof(Shadowless));
  end;
  Build;
end;

procedure TLight.DetailsLight(dlg: TLightEditorDlg; save: boolean);
begin
  if save then
  begin
    Red := StrToFloat(dlg.Red.Text);
    Green := StrToFloat(dlg.Green.Text);
    Blue := StrToFloat(dlg.Blue.Text);
    FadeDistance := StrToFloat(dlg.FadeDistance.Text);
    FadePower := StrToFloat(dlg.FadePower.Text);
    AtmosphericAttenuation := dlg.AtmosphericAttenuation.Checked;
    LooksLike := TLooksLike(dlg.LooksLike.ItemIndex);
    Shadowless := dlg.Shadowless.Checked;
  end
  else
  begin
    dlg.Red.Text := FloatToStrF(Red, ffFixed, 6, 4);
    dlg.Green.Text := FloatToStrF(Green, ffFixed, 6, 4);
    dlg.Blue.Text := FloatToStrF(Blue, ffFixed, 6, 4);
    dlg.FadeDistance.Text := FloatToStrF(FadeDistance, ffFixed, 6, 4);
    dlg.FadePower.Text := FloatToStrF(FadePower, ffFixed, 6, 4);
    dlg.AtmosphericAttenuation.Checked := AtmosphericAttenuation;
    dlg.LooksLike.ItemIndex := ord(LooksLike);
    dlg.Shadowless.Checked := Shadowless;
  end;
end;

procedure TLight.Details;
var
  dlg: TLightEditorDlg;

begin
  dlg := TLightEditorDlg.Create(Application);

  DetailsLight(dlg, False);

  if dlg.ShowModal = idOK then
  begin
    DetailsLight(dlg, True);
    Build;
    MainForm.Modify(Self);
  end;

  dlg.Free;
end;

procedure TLight.Build;
begin
  Triangles.Clear;

  case LooksLike of
    llLight:    CreateLight(Self, 0.0, 0.0, 0.0);
    llCube:     CreateCube(Self, 0.0, 0.0, 0.0);
    llSphere:   CreateSphere(Self, 0.0, 0.0, 0.0);
    llCone:     CreateSolidShape(Self, 0.0, 0.0, 0.0, ConeSolid);
    llCylinder: CreateSolidShape(Self, 0.0, 0.0, 0.0, CylinderSolid);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TSpotLight

constructor TSpotLight.Create;
begin
  inherited Create;
  Features := Features + [sfHasObserved];

  PointAt := TCoord.Create;
  Radius := 15;
  Falloff := 30;
  Tightness := 10;
end;

destructor TSpotLight.Destroy;
begin
  PointAt.Free;
  inherited Destroy;
end;

function TSpotLight.GetID: TShapeID;
begin
  result := siSpotLight;
end;

function TSpotLight.GetObserved: TVector;
begin
  result := PointAt;
end;

procedure TSpotLight.SetObserved(scene: TSceneData; x, y, z: double; xb, yb, zb: boolean);
begin
  if xb then PointAt.X := x - Translate.x;
  if yb then PointAt.Y := y - Translate.y;
  if zb then PointAt.Z := z - Translate.z;
  Make(scene, Triangles);
end;

procedure TSpotLight.Draw(Scene: TSceneData; theTriangles: TList; canvas: TCanvas; Mode: TPenMode);
begin
  canvas.Pen.Mode := Mode;

  with canvas do
  begin
    // Draw a cross at the observed
    MoveTo(PointAt.Point.X + ViewSize - CameraSize, PointAt.Point.Y + ViewSize - CameraSize);
    LineTo(PointAt.Point.X + ViewSize + CameraSize, PointAt.Point.Y + ViewSize + CameraSize);
    MoveTo(PointAt.Point.X + ViewSize + CameraSize, PointAt.Point.Y + ViewSize - CameraSize);
    LineTo(PointAt.Point.X + ViewSize - CameraSize, PointAt.Point.Y + ViewSize + CameraSize);

    Bounding.left := Minimum(Bounding.left, PointAt.Point.X - CameraSize);
    Bounding.right := Maximum(Bounding.right + CameraSize, PointAt.Point.X + CameraSize);
    Bounding.top := Minimum(Bounding.top - CameraSize, PointAt.Point.Y - CameraSize);
    Bounding.bottom := Maximum(Bounding.bottom + CameraSize, PointAt.Point.Y + CameraSize);
  end;

  inherited Draw(Scene, theTriangles, canvas, Mode);
end;

procedure TSpotLight.Make(scene: TSceneData; theTriangles: TList);
begin
  inherited Make(scene, theTriangles);

  PointAt.Make(scene, Self);
end;

procedure TSpotLight.GenerateLight(var dest: TextFile);
begin
  WriteLn(dest, '    spotlight');
  WriteLn(dest, Format('    point_at <%6.4f, %6.4f, %6.4f>', [PointAt.X, PointAt.Y, PointAt.Z]));
  WriteLn(dest, Format('    radius %6.4f', [Radius]));
  WriteLn(dest, Format('    falloff %6.4f', [Falloff]));
  WriteLn(dest, Format('    tightness %6.4f', [Tightness]));
end;

procedure TSpotLight.GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
var
  Light: IDirect3DRMLight;

begin
  D3DRM.CreateLightRGB(D3DRMLIGHT_SPOT, Red, Green, Blue, Light);

  MeshFrame.AddLight(Light);

  MeshFrame.AddTranslation(D3DRMCOMBINE_AFTER, Translate.X, Translate.Y, Translate.Z);
end;

procedure TSpotLight.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);
  PointAt.SaveToFile(dest);
  dest.WriteBuffer(Radius, sizeof(Radius));
  dest.WriteBuffer(Falloff, sizeof(Falloff));
  dest.WriteBuffer(Tightness, sizeof(Tightness));
end;

procedure TSpotLight.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);
  PointAt.LoadFromFile(source);
  source.ReadBuffer(Radius, sizeof(Radius));
  source.ReadBuffer(Falloff, sizeof(Falloff));
  source.ReadBuffer(Tightness, sizeof(Tightness));
end;

procedure TSpotLight.Details;
var
  dlg: TSpotLightEditorDlg;

begin
  dlg := TSpotLightEditorDlg.Create(Application);

  DetailsLight(dlg, False);

  dlg.XPoint.Text := FloatToStrF(PointAt.X, ffFixed, 6, 4);
  dlg.YPoint.Text := FloatToStrF(PointAt.Y, ffFixed, 6, 4);
  dlg.ZPoint.Text := FloatToStrF(PointAt.Z, ffFixed, 6, 4);

  dlg.Radius.Text := FloatToStrF(Radius, ffFixed, 4, 2);
  dlg.Falloff.Text := FloatToStrF(Falloff, ffFixed, 4, 2);
  dlg.Tightness.Text := FloatToStrF(Tightness, ffFixed, 4, 2);

  if dlg.ShowModal = idOK then
  begin
    DetailsLight(dlg, True);

    PointAt.X := StrToFloat(dlg.XPoint.Text);
    PointAt.Y := StrToFloat(dlg.YPoint.Text);
    PointAt.Z := StrToFloat(dlg.ZPoint.Text);

    Radius := StrToFloat(dlg.Radius.Text);
    Falloff := StrToFloat(dlg.Falloff.Text);
    Tightness := StrToFloat(dlg.Tightness.Text);
  end;

  dlg.Free;
end;

////////////////////////////////////////////////////////////////////////////////
// TCylinderLight

function TCylinderLight.GetID: TShapeID;
begin
  result := siCylinderLight;
end;

procedure TCylinderLight.GenerateLight(var dest: TextFile);
begin
  WriteLn(dest, '    cylinder');
  WriteLn(dest, Format('    point_at <%6.4f, %6.4f, %6.4f>', [PointAt.X, PointAt.Y, PointAt.Z]));
  WriteLn(dest, Format('    radius %6.4f', [Radius]));
  WriteLn(dest, Format('    falloff %6.4f', [Falloff]));
  WriteLn(dest, Format('    tightness %6.4f', [Tightness]));
end;

////////////////////////////////////////////////////////////////////////////////
// TAreaLight

constructor TAreaLight.Create;
begin
  inherited Create;
  Triangles.Clear;
  CreatePlane(Self, 0.0, 0.0, 0.0, 1.0);
  Adaptive := 1;
  Jitter := True;
  Width := 5;
  Height := 5;
end;

function TAreaLight.GetID: TShapeID;
begin
  result := siAreaLight;
end;

procedure TAreaLight.GenerateLight(var dest: TextFile);
begin
  WriteLn(dest, Format('    area_light <1, 0, 0>, <0, 1, 0>, %d, %d', [Width, Height]));
  WriteLn(dest, Format('    adaptive %d', [Adaptive]));
  if Jitter then
    WriteLn(dest, '    jitter');
end;

procedure TAreaLight.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);
  dest.WriteBuffer(Adaptive, sizeof(Adaptive));
  dest.WriteBuffer(Jitter, sizeof(Jitter));
end;

procedure TAreaLight.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);
  source.ReadBuffer(Adaptive, sizeof(Adaptive));
  source.ReadBuffer(Jitter, sizeof(Jitter));
end;

procedure TAreaLight.Details;
var
  dlg: TAreaLightEditorDlg;

begin
  dlg := TAreaLightEditorDlg.Create(Application);

  DetailsLight(dlg, False);

  dlg.Adaptive.Text := IntToStr(Adaptive);
  dlg.Jitter.Checked := Jitter;
  dlg.Width.Text := IntToStr(Width);
  dlg.Height.Text := IntToStr(Height);

  if dlg.ShowModal = idOK then
  begin
    DetailsLight(dlg, True);

    Adaptive := StrToInt(dlg.Adaptive.Text);
    Jitter := dlg.Jitter.Checked;
    Width := StrToInt(dlg.Width.Text);
    Height := StrToInt(dlg.Height.Text);
  end;

  dlg.Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure CreateLight(shape: TShape; x, y, z: double);
var
  a, b, c: TVector;

begin
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  a.x := x;
  a.y := y + 0.1;
  a.z := z;

  b.x := x - 0.1;
  b.y := y - 0.1;
  b.z := z;

  c.x := x + 0.1;
  c.y := y - 0.1;
  c.z := z;

  shape.AddTriangle(a, b, c);

  a.Free;
  b.Free;
  c.Free;
end;

end.
