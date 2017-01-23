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

unit Texture;

interface

uses
  System.JSON, System.TypInfo,
    System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
    Vcl.Controls, Vcl.Menus,
    Vcl.StdCtrls, Vcl.Dialogs, Vcl.Buttons,
    Winapi.Windows, Winapi.Messages,
    Vector;

const
  TextSize = 20;                    // Texture rectangle size

type
  TTextureID = (tiTexture, tiColor, tiAgate, tiAverage, tiBozo, tiBrick,
    tiBumps, tiChecker, tiCrackle, tiDents, tiGradient, tiGranite,
    tiHexagon, tiLeopard, tiMandel, tiMarble, tiOnion, tiQuilted,
    tiRadial, tiRipples, tiSpiral1, tiSpiral2, tiSpotted, tiWaves,
    tiWood, tiWrinkles, tiMap, tiImage, tiSpiral, tiUser, tiLastTexture);

  TNormalType = (nNone, nAgate, nAverage, nBozo, nBrick, nBumps, nChecker,
    nCrackle, nDents, nGradient, nGranite, nHexagon, nLeopard, nMandel,
    nMarble, nOnion, nQuilted, nRadial, nRipples,
    nSpiral1, nSpiral2, nSpotted, nWaves, nWood, nWrinkles, nLastNormal);

const
  TextureNames: array [tiTexture..tiLastTexture] of string = ('texture', 'colour',
    'agate', 'average', 'bozo', 'brick', 'bumps', 'checker', 'crackle', 'dents',
    'gradient', 'granite', 'hexagon', 'leopard', 'mandel', 'marble', 'onion',
    'quilted', 'radial', 'ripples', 'spiral1', 'spiral2', 'spotted', 'waves',
    'wood', 'wrinkles', 'map', 'image', 'Spiral', 'user', 'last');

  NormalNames: array [nNone..nLastNormal] of string = ('none', 'agate',
    'average', 'bozo', 'brick', 'bumps', 'checker', 'crackle', 'dents',
    'gradient', 'granite', 'hexagon', 'leopard', 'mandel', 'marble',
    'onion', 'quilted', 'radial', 'ripples', 'spiral1',
    'spiral2', 'spotted', 'waves', 'wood', 'wrinkles', 'last');

type
  TTexture = class(TObject)
  public
    { name of texture }
    Category, Name: string;
    Selected: boolean;

    { transformations }
    Translate, Scale, Rotate: TVector;

    { colour values }
    Red, Green, Blue, Filter, Transmit: double;

    { finish values }
    Diffuse, Brilliance, Crand, Ambient, Reflection,
    Phong, PhongSize, Specular, Roughness,
    Refraction, IOR: double;
    Metallic: boolean;
    Caustics: double;
    FadeDistance, FadePower: double;
    Irid, IridThickness: double;
    IridVector: TVector;

    Turbulence: double;
    Octaves: integer;
    Lambda: double;
    Omega: double;

    { normal values }
    NormalType: TNormalType;
    NormalValue: double;
    NormalTurbulence: double;
    NormalOctaves: integer;
    NormalLambda: double;
    NormalOmega: double;

    { Halo list }
    Halos: TList;

    constructor Create; virtual;
    destructor Destroy; override;
    function GetID: TTextureID; virtual;
    procedure Save(parent: TJSONArray); virtual;
    function GetColour: TColor; virtual;
    function GetPaletteRGB: Longint; virtual;
    function ConvertPaletteRGB(r, g, b: double): longint; virtual;
    function IsMapTexture: boolean; virtual;
    procedure DrawSelected(x: integer; canvas: TCanvas);
    procedure Draw(x: integer; canvas: TCanvas); virtual;
    procedure Generate(var dest: TextFile); virtual;
    procedure GenerateVRML(var dest: TextFile); virtual;
    procedure GenerateSMPL(var dest: TextFile); virtual;
    procedure GenerateTransforms(var dest: TextFile);
    procedure GenerateTurbulence(var dest: TextFile);
    procedure GenerateFinish(var dest: TextFile);
    procedure GenerateNormal(var dest: TextFile);
    procedure GenerateHalos(var dest: TextFile);
    procedure Preview(var dest: TextFile; shape: integer;
      dofloor, dowall: boolean;
      floor, wall: TColor); virtual;
    procedure ClearHalos;
    end;

  TTextureType = class of TTexture;

  TImageTexture = class(TTexture)
  public
    Filename: AnsiString;
    MapType: integer;
    constructor Create; override;
    function GetID: TTextureID; override;
    procedure Save(parent: TJSONArray); override;
    //procedure LoadFromFile(source: TStream); override;
  end;

  TUserTexture = class(TTexture)
  public
    Declare, Filename: AnsiString;
    constructor Create; override;
    function GetID: TTextureID; override;
    procedure Save(parent: TJSONArray); override;
    //procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
  end;

implementation

uses
  Main, Misc, Halo;

////////////////////////////////////////////////////////////////////////////////
//  TTexture

constructor TTexture.Create;
begin
  Category := 'My Textures';

  Translate := TVector.Create;
  Scale := TVector.Create;
  Rotate := TVector.Create;

  Scale.X := 1;
  Scale.Y := 1;
  Scale.Z := 1;

  { colour values }
  Red := 0.0;
  Green := 0.0;
  Blue := 0.0;
  Filter := 0.0;
  Transmit := 0.0;

  Selected := False;

  { finish values }
  Diffuse := 0.7;
  Brilliance := 1.0;
  Crand := 0.0;
  Ambient := 0.1;
  Reflection := 0.0;
  Phong := 0.0;
  PhongSize := 0.0;
  Specular := 0.0;
  Roughness := 0.05;
  Metallic := False;
  Refraction := 0.0;
  IOR := 0.0;
  Caustics := 0.0;
  FadeDistance := 0.0;
  FadePower := 0.0;
  Irid := 0.25;
  IridThickness := 1.0;
  IridVector := TVector.Create;
  IridVector.Y := 1;

  Turbulence := 0;
  Octaves := 6;
  Lambda := 2;
  Omega := 0.5;

  { normal values }
  NormalType := nNone;
  NormalValue := 0;
  NormalTurbulence := 0;
  NormalOctaves := 6;
  NormalLambda := 2;
  NormalOmega := 0.5;

  { Halo list }
  Halos := TList.Create;
end;

destructor TTexture.Destroy;
begin
  Halos.Free;
  Translate.Free;
  Scale.Free;
  Rotate.Free;

  inherited;
end;

function TTexture.GetID: TTextureID;
begin
  result := tiColor;
end;

function TTexture.GetColour: TColor;
var
  r, g, b: integer;

begin
  r := trunc(Red * 255.0);
  g := trunc(Green * 255.0);
  b := trunc(Blue * 255.0);
  result := Rgb(r, g, b);
end;

function TTexture.ConvertPaletteRGB(r, g, b: double): longint;
var
  ri, gi, bi: integer;

begin
  ri := trunc(r * 255.0);
  gi := trunc(g * 255.0);
  bi := trunc(b * 255.0);
  result := PALETTERGB(ri, gi, bi);
end;

function TTexture.GetPaletteRGB: Longint;
begin
  result := ConvertPaletteRGB(Red, Green, Blue);
end;

function TTexture.IsMapTexture: boolean;
begin
  result := false;
end;

procedure TTexture.DrawSelected(x: integer; canvas: TCanvas);
var
  rect: TRect;

begin
  rect.top := 0;
  rect.bottom := TextSize - 1;
  rect.left := x;
  rect.right := x + TextSize - 1;
  with canvas do
  begin
    if Selected then
    begin
      Pen.Color := clHighlight;
      Rectangle(x, 0, x + TextSize - 1, TextSize - 1);
      Rectangle(x + 1, 1, x + TextSize - 2, TextSize - 2);
    end
  end;
end;

procedure TTexture.Draw(x: integer; canvas: TCanvas);
var
  rect: TRect;

begin
  DrawSelected(x, canvas);
  rect.top := 2;
  rect.bottom := TextSize - 3;
  rect.left := x + 2;
  rect.right := x + TextSize - 3;
  with canvas do
  begin
    Brush.Color := GetPaletteRGB;
    FillRect(rect);
  end;
end;

procedure TTexture.Save(parent: TJSONArray);
var
  child, haloObj: TJSONObject;
  halosArray: TJSONArray;
  i, n: integer;
  t: TTextureID;
  halo: THalo;

begin
  child := TJSONObject.Create;
  t := GetID;
  child.AddPair('type', TJSONNumber.Create(ord(t)));
  child.AddPair('category', Category);
  child.AddPair('name', Name);
  Translate.Save('translate', child);
  Scale.Save('scale', child);
  Rotate.Save('rotate', child);
  child.AddPair('red', TJSONNumber.Create(Red));
  child.AddPair('green', TJSONNumber.Create(Green));
  child.AddPair('blue', TJSONNumber.Create(Blue));
  child.AddPair('filter', TJSONNumber.Create(Filter));
  child.AddPair('transmit', TJSONNumber.Create(Transmit));
  child.AddPair('diffuse', TJSONNumber.Create(Diffuse));
  child.AddPair('brilliance', TJSONNumber.Create(Brilliance));
  child.AddPair('crand', TJSONNumber.Create(Crand));
  child.AddPair('ambient', TJSONNumber.Create(Ambient));
  child.AddPair('reflection', TJSONNumber.Create(Reflection));
  child.AddPair('phong', TJSONNumber.Create(Phong));
  child.AddPair('phongsize', TJSONNumber.Create(PhongSize));
  child.AddPair('specular', TJSONNumber.Create(Specular));
  child.AddPair('roughness', TJSONNumber.Create(Roughness));
  child.AddPair('refraction', TJSONNumber.Create(Refraction));
  child.AddPair('ior', TJSONNumber.Create(IOR));
  child.AddPair('metallic', TJSONBool.Create(Metallic));
  child.AddPair('caustics', TJSONNumber.Create(Caustics));
  child.AddPair('fadedistance', TJSONNumber.Create(FadeDistance));
  child.AddPair('fadepower', TJSONNumber.Create(FadePower));
  child.AddPair('irid', TJSONNumber.Create(Irid));
  child.AddPair('iridthickness', TJSONNumber.Create(IridThickness));
  IridVector.Save('iridvector', child);
  child.AddPair('turbulence', TJSONNumber.Create(Turbulence));
  child.AddPair('octaves', TJSONNumber.Create(Octaves));
  child.AddPair('lambda', TJSONNumber.Create(Lambda));
  child.AddPair('omega', TJSONNumber.Create(Omega));
  child.AddPair('normaltype', TJSONNumber.Create(ord(NormalType)));
  child.AddPair('normalvalue', TJSONNumber.Create(NormalValue));
  child.AddPair('normalturbulence', TJSONNumber.Create(NormalTurbulence));
  child.AddPair('normaloctaves', TJSONNumber.Create(NormalOctaves));
  child.AddPair('normallambda', TJSONNumber.Create(NormalLambda));
  child.AddPair('normalomega', TJSONNumber.Create(NormalOmega));

  halosArray := TJSONArray.Create;
  n := Halos.Count;
  for i := 0 to n - 1 do
  begin
    halo := Halos[i];
    haloObj := TJSONObject.Create;
    haloObj.AddPair('halo', halo.Name);
    halosArray.Add(haloObj);
  end;

  child.AddPair('halos', halosArray);

  parent.Add(child);
end;

{*
procedure TTexture.LoadFromFile(source: TStream);
var
  i, n: integer;
  s: AnsiString;
  halo: THalo;

begin
  if MainForm.TextureVersion > 12 then
    LoadStringFromStream(Category, source);

  LoadStringFromStream(Name, source);

  if MainForm.TextureVersion > 7 then
  begin
    Translate.LoadFromFile(source);
    Scale.LoadFromFile(source);
    Rotate.LoadFromFile(source);
  end;
  source.ReadBuffer(Red, sizeof(Red));
  source.ReadBuffer(Green, sizeof(Green));
  source.ReadBuffer(Blue, sizeof(Blue));
  source.ReadBuffer(Filter, sizeof(Filter));
  source.ReadBuffer(Transmit, sizeof(Transmit));
  source.ReadBuffer(Diffuse, sizeof(Diffuse));
  source.ReadBuffer(Brilliance, sizeof(Brilliance));
  source.ReadBuffer(Crand, sizeof(Crand));
  source.ReadBuffer(Ambient, sizeof(Ambient));
  source.ReadBuffer(Reflection, sizeof(Reflection));
  source.ReadBuffer(Phong, sizeof(Phong));
  source.ReadBuffer(PhongSize, sizeof(PhongSize));
  source.ReadBuffer(Specular, sizeof(Specular));
  source.ReadBuffer(Roughness, sizeof(Roughness));
  source.ReadBuffer(Refraction, sizeof(Refraction));
  source.ReadBuffer(IOR, sizeof(IOR));
  source.ReadBuffer(Metallic, sizeof(Metallic));
  if MainForm.TextureVersion > 7 then
  begin
    source.ReadBuffer(Caustics, sizeof(Caustics));
    source.ReadBuffer(FadeDistance, sizeof(FadeDistance));
    source.ReadBuffer(FadePower, sizeof(FadePower));
    source.ReadBuffer(Irid, sizeof(Irid));
    source.ReadBuffer(IridThickness, sizeof(IridThickness));
    IridVector.LoadFromFile(source);
    source.ReadBuffer(Turbulence, sizeof(Turbulence));
    source.ReadBuffer(Octaves, sizeof(Octaves));
    source.ReadBuffer(Lambda, sizeof(Lambda));
    source.ReadBuffer(Omega, sizeof(Omega));

    source.ReadBuffer(NormalType, sizeof(NormalType));
    source.ReadBuffer(NormalValue, sizeof(NormalValue));
    source.ReadBuffer(NormalTurbulence, sizeof(NormalTurbulence));
    source.ReadBuffer(NormalOctaves, sizeof(NormalOctaves));
    source.ReadBuffer(NormalLambda, sizeof(NormalLambda));
    source.ReadBuffer(NormalOmega, sizeof(NormalOmega));
  end;

  if MainForm.TextureVersion > 11 then
  begin
    source.ReadBuffer(n, sizeof(n));

    for i := 0 to n - 1 do
    begin
      LoadStringFromStream(s, source);
      halo := MainForm.FindHalo(s);
      if Assigned(halo) then
        Halos.Add(halo);
    end;
  end;
end;
*}

procedure TTexture.GenerateTransforms(var dest: TextFile);
begin
  if NonUnity(Scale.X, Scale.Y, Scale.Z) then WriteLn(dest, Format('    scale <%6.4f, %6.4f, %6.4f>',
    [Scale.X, Scale.Y, Scale.Z]));
  if NonZero(Rotate.X, Rotate.Y, Rotate.Z) then WriteLn(dest, Format('    rotate <%6.4f, %6.4f, %6.4f>',
    [Rotate.X, Rotate.Y, Rotate.Z]));
  if NonZero(Translate.X, Translate.Y, Translate.Z) then WriteLn(dest, Format('    translate <%6.4f, %6.4f, %6.4f>',
    [Translate.X, Translate.Y, Translate.Z]));
end;

procedure TTexture.GenerateTurbulence(var dest: TextFile);
begin
  if Different(Turbulence, 0) then
  begin
    WriteLn(dest, Format('        turbulence %6.4f', [Turbulence]));
    WriteLn(dest, Format('        octaves %d', [Octaves]));
    WriteLn(dest, Format('        lambda %6.4f', [Lambda]));
    WriteLn(dest, Format('        omega %6.4f', [Omega]));
  end;
end;

procedure TTexture.GenerateFinish(var dest: TextFile);
begin
  WriteLn(dest, '    finish');
  WriteLn(dest, '    {');
  WriteLn(dest, Format('        diffuse %6.4f', [Diffuse]));

  if Different(Brilliance, 1) then
    WriteLn(dest, Format('        brilliance %6.4f', [Brilliance]));

  if Different(CRand, 0) then
    WriteLn(dest, Format('        crand %6.4f', [Crand]));

  WriteLn(dest, Format('        ambient %6.4f', [Ambient]));

  if Different(Reflection, 0) then
    WriteLn(dest, Format('        reflection %6.4f', [Reflection]));

  if Different(Phong, 0) then
    WriteLn(dest, Format('        phong %6.4f phong_size %6.4f', [Phong, PhongSize]));

  if Different(Specular, 0) then
    WriteLn(dest, Format('        specular %6.4f roughness %6.4f', [Specular, Roughness]));

  if Metallic then
    WriteLn(dest, '        metallic');

  if Different(Refraction, 0) then
    WriteLn(dest, Format('        refraction %6.4f ior %6.4f', [Refraction, IOR]));

  if Different(Caustics, 0) then
    WriteLn(dest, Format('        caustics %6.4f', [Caustics]));

  if Different(FadeDistance, 0) then
    WriteLn(dest, Format('        fade_distance %6.4f', [FadeDistance]));

  if Different(FadePower, 0) then
    WriteLn(dest, Format('        fade_power %6.4f', [FadePower]));

  if Different(Irid, 0.25) then
    WriteLn(dest,
      Format('        irid { %6.4f thickness %6.4f turbulence <%6.4f, %6.4f, %6.4f> }',
        [Irid, IridThickness, IridVector.X, IridVector.Y, IridVector.Z]));

  WriteLn(dest, '    }');
end;

procedure TTexture.GenerateNormal(var dest: TextFile);
begin
  if NormalType <> nNone then
  begin
    WriteLn(dest, '    normal');
    WriteLn(dest, '    {');
    WriteLn(dest, Format('        %s %6.4f',
      [NormalNames[NormalType], NormalValue]));

    if Different(NormalTurbulence, 0) then
    begin
      WriteLn(dest, Format('        turbulence %6.4f', [NormalTurbulence]));
      WriteLn(dest, Format('        octaves %d', [NormalOctaves]));
      WriteLn(dest, Format('        lambda %6.4f', [NormalLambda]));
      WriteLn(dest, Format('        omega %6.4f', [NormalOmega]));
    end;

    WriteLn(dest, '    }');
  end;
end;

procedure TTexture.GenerateHalos(var dest: TextFile);
var
  i: integer;
  halo: THalo;

begin
  for i := 0 to Halos.Count - 1 do
  begin
    halo := Halos[i];
    halo.Generate(dest);
  end;
end;

procedure TTexture.Generate(var dest: TextFile);
begin
  WriteLn(dest, Format('#declare %s = texture', [Name]));
  WriteLn(dest, '{');
  WriteLn(dest, '    pigment');
  WriteLn(dest, '    {');
  WriteLn(dest,
    Format('        color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f',
    [Red, Green, Blue, Filter, Transmit]));
  GenerateTurbulence(dest);
  WriteLn(dest, '    }');
  GenerateHalos(dest);
  GenerateFinish(dest);
  GenerateNormal(dest);
  GenerateTransforms(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TTexture.GenerateVRML(var dest: TextFile);
begin
  WriteLn(dest, Format('    # Texture %s', [Name]));
  WriteLn(dest, '    Material');
  WriteLn(dest, '    {');

  WriteLn(dest, Format('      diffuseColor %6.4f %6.4f %6.4f',
    [Red * Diffuse, Green * Diffuse, Blue * Diffuse]));

  if Different(Phong, 0) then
    WriteLn(dest, Format('      shininess %6.4f', [Phong]));

  if Different(Transmit, 0) then
    WriteLn(dest, Format('      transparency %6.4f', [Transmit]));

  WriteLn(dest, '    }');
end;

procedure TTexture.GenerateSMPL(var dest: TextFile);
begin
  WriteLn(dest, Format('const vector Model%s = %6.4f %6.4f %6.4f;',
    [Name, Red, Green, Blue]));
end;

procedure TTexture.Preview(var dest: TextFile;
  shape: integer;
  dofloor, dowall: boolean;
  floor, wall: TColor);
var
  red, green, blue: double;

begin
  Generate(dest);
  WriteLn(dest);
  WriteLn(dest, 'camera');
  WriteLn(dest, '{');
  WriteLn(dest, '    location <0, 0, -3>');
  WriteLn(dest, '    look_at <0, 0, 0>');
  WriteLn(dest, '}');
  WriteLn(dest);

  if dofloor then
  begin
    red := GetRValue(floor) / 255.0;
    green := GetGValue(floor) / 255.0;
    blue := GetBValue(floor) / 255.0;

    WriteLn(dest, 'plane');
    WriteLn(dest, '{');
    WriteLn(dest, '  <0, 1, 0>, -2');
    WriteLn(dest, Format('  texture { pigment { color red %6.4f green %6.4f blue %6.4f } }', [red, green, blue]));
    WriteLn(dest, '}');
    WriteLn(dest);
  end;

  if dowall then
  begin
    red := GetRValue(wall) / 255.0;
    green := GetGValue(wall) / 255.0;
    blue := GetBValue(wall) / 255.0;

    WriteLn(dest, 'plane');
    WriteLn(dest, '{');
    WriteLn(dest, '  <0, 0, -1>, -2');
    WriteLn(dest, Format('  texture { pigment { color red %6.4f green %6.4f blue %6.4f } }', [red, green, blue]));
    WriteLn(dest, '}');
    WriteLn(dest);
  end;

  case shape of
    0:
    begin
      WriteLn(dest, 'sphere');
      WriteLn(dest, '{');
      WriteLn(dest, '    <0, 0, 0> 1');
      WriteLn(dest, '    texture { ' + Name + ' }');
      WriteLn(dest, '}');
    end;

    1:
    begin
      WriteLn(dest, 'box');
      WriteLn(dest, '{');
      WriteLn(dest, '  <-1, -1, -1>, <1, 1, 1>');
      WriteLn(dest, '    texture { ' + Name + ' }');
      WriteLn(dest, '}');
    end;

    2:
    begin
      WriteLn(dest, 'cylinder');
      WriteLn(dest, '{');
      WriteLn(dest, '  <0, -1, 0>, <0, 1, 0>, 1');
      WriteLn(dest, '    texture { ' + Name + ' }');
      WriteLn(dest, '}');
    end;
  end;

  WriteLn(dest);
  WriteLn(dest, 'light_source');
  WriteLn(dest, '{');
  WriteLn(dest, '    <1.5, 1.5, -3> color red 1 green 1 blue 1');
  WriteLn(dest, '}');
end;

procedure TTexture.ClearHalos;
begin
  Halos.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
//  TImageTexture

constructor TImageTexture.Create;
begin
  inherited;
  MapType := 0;
end;

function TImageTexture.GetID: TTextureID;
begin
  result := tiImage;
end;

procedure TImageTexture.Save(parent: TJSONArray);
var
  child: TJSONObject;

begin
  inherited;

  child := TJSONObject.Create;
  child.AddPair('maptype', TJSONNumber.Create(ord(MapType)));
  child.AddPair('filename', Filename);
  parent.Add(child);
end;

{*
procedure TImageTexture.LoadFromFile(source: TStream);
begin
  inherited;

  LoadStringFromStream(Filename, source);
  source.ReadBuffer(MapType, sizeof(MapType));
end;
*}

////////////////////////////////////////////////////////////////////////////////
//  TUserTexture

constructor TUserTexture.Create;
begin
  inherited;

end;

function TUserTexture.GetID: TTextureID;
begin
  result := tiUser;
end;

procedure TUserTexture.Save(parent: TJSONArray);
var
  child: TJSONObject;

begin
  inherited;

  child := TJSONObject.Create;
  child.AddPair('declare', Declare);
  child.AddPair('filename', Filename);
  parent.Add(child);
end;

{*
procedure TUserTexture.LoadFromFile(source: TStream);
begin
  inherited;

  LoadStringFromStream(Declare, source);
  LoadStringFromStream(Filename, source);
end;
*}

procedure TUserTexture.Generate(var dest: TextFile);
begin
  WriteLn(dest, '#include "' + Filename + '"');
  WriteLn(dest);
  WriteLn(dest, '#declare ' + Name + ' texture ' + Declare);
  WriteLn(dest);
end;

end.
