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

unit maptext;

interface

uses
  Windows, Classes, SysUtils, Graphics, Forms, Vector, Texture;

const
  MapTextSize = 30;

type
  TMapItem = class
  public
    Red, Green, Blue, Filter, Transmit, Value: double;
    constructor Create;
    //procedure SaveToFile(dest: TStream);
    procedure LoadFromFile(source: TStream);
    procedure Draw(x: integer; canvas: TCanvas; selected: boolean);
    procedure Copy(original: TMapItem);
    procedure SetRGBV(r, g, b, v: double);
    procedure SetRGBFTV(r, g, b, f, t, v: double);
    procedure Generate(var dest: TextFile);
  end;

  TMapTexture = class(TTexture)
  public
    MapType: TTextureID;
    Maps: TList;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TTextureID; override;
    //procedure SaveToFile(dest: TStream); override;
    //procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure Draw(x: integer; canvas: TCanvas); override;
    procedure CreateSimple;
    function IsMapTexture: boolean; override;
  end;

  TSpiralTexture = class(TMapTexture)
  public
    Arms: integer;

    constructor Create; override;
    function GetID: TTextureID; override;
    //procedure SaveToFile(dest: TStream); override;
    //procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TMapItem

constructor TMapItem.Create;
begin
  Red := 0;
  Green := 0;
  Blue := 0;
  Filter := 0;
  Transmit := 0;
  Filter := 0;
end;

{*
procedure TMapItem.SaveToFile(dest: TStream);
begin
  dest.WriteBuffer(Red, sizeof(Red));
  dest.WriteBuffer(Green, sizeof(Green));
  dest.WriteBuffer(Blue, sizeof(Blue));
  dest.WriteBuffer(Filter, sizeof(Filter));
  dest.WriteBuffer(Transmit, sizeof(Transmit));
  dest.WriteBuffer(Value, sizeof(Value));
end;
*}

procedure TMapItem.LoadFromFile(source: TStream);
begin
  source.ReadBuffer(Red, sizeof(Red));
  source.ReadBuffer(Green, sizeof(Green));
  source.ReadBuffer(Blue, sizeof(Blue));
  source.ReadBuffer(Filter, sizeof(Filter));
  source.ReadBuffer(Transmit, sizeof(Transmit));
  source.ReadBuffer(Value, sizeof(Value));
end;

procedure TMapItem.Draw(x: integer; canvas: TCanvas; selected: boolean);
begin
  with canvas do
  begin
    Brush.Color := PALETTERGB(trunc(Red * 255.0), trunc(Green * 255.0), trunc(Blue * 255.0));
    if selected then
      Pen.Color := clWhite
    else
      Pen.Color := clBlack;

    Rectangle(x, 0, x + MapTextSize, MapTextSize);
  end;
end;

procedure TMapItem.Copy(original: TMapItem);
begin
  if Assigned(original) then
  begin
    Red := original.Red;
    Green := original.Green;
    Blue := original.Blue;
    Filter := original.Filter;
    Transmit := original.Transmit;
    Value := original.Value;
  end;
end;

procedure TMapItem.SetRGBV(r, g, b, v: double);
begin
  Red := r;
  Green := g;
  Blue := b;
  Value := v;
end;

procedure TMapItem.SetRGBFTV(r, g, b, f, t, v: double);
begin
  Red := r;
  Green := g;
  Blue := b;
  Filter := f;
  Transmit := t;
  Value := v;
end;

procedure TMapItem.Generate(var dest: TextFile);
begin
  WriteLn(dest, Format('            [%6.4f rgbft <%6.4f, %6.4f, %6.4f, %6.4f, %6.4f>]',
    [Value, Red, Green, Blue, Filter, Transmit]));
end;

////////////////////////////////////////////////////////////////////////////////
// TMapTexture

constructor TMapTexture.Create;
begin
  inherited;

  Red := 1;
  Green := 1;
  Blue := 1;

  MapType := tiMap;
  Maps := TList.Create;
end;

destructor TMapTexture.Destroy;
begin
  Maps.Destroy;
  inherited;
end;

function TMapTexture.GetID: TTextureID;
begin
  result := tiMap;
end;

{*
procedure TMapTexture.SaveToFile(dest: TStream);
var
  i, n: integer;
  map: TMapItem;

begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(MapType, sizeof(MapType));

  n := Maps.Count;
  dest.WriteBuffer(n, sizeof(n));

  for i := 0 to n - 1 do
  begin
    map := Maps[i];
    map.SaveToFile(dest);
  end;
end;
*}

{*
procedure TMapTexture.LoadFromFile(source: TStream);
var
  i, n: integer;
  map: TMapItem;

begin
  inherited LoadFromFile(source);

  source.ReadBuffer(MapType, sizeof(MapType));

  source.ReadBuffer(n, sizeof(n));

  for i := 1 to n do
  begin
    map := TMapItem.Create;
    map.LoadFromFile(source);
    Maps.Add(map);
  end;
end;
*}

procedure TMapTexture.Generate(var dest: TextFile);
var
  i: integer;
  map: TMapItem;

begin
  WriteLn(dest, Format('#declare %s = texture', [Name]));
  WriteLn(dest, '{');
  WriteLn(dest, '    pigment');
  WriteLn(dest, '    {');
  WriteLn(dest, '        ', TextureNames[MapType]);
  WriteLn(dest, '        color_map');
  WriteLn(dest, '        {');

  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    map.Generate(dest);
  end;

  WriteLn(dest, '        }');
  GenerateTurbulence(dest);
  WriteLn(dest, '    }');
  GenerateFinish(dest);
  GenerateNormal(dest);
  GenerateTransforms(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TMapTexture.Draw(x: integer; canvas: TCanvas);
var
  bitmap: TBitmap;

begin
  bitmap := TBitmap.Create;

  bitmap.LoadFromResourceID(HInstance, 1003);

  DrawSelected(x, canvas);

  canvas.Draw(x + 2, 2, bitmap);

  bitmap.Free;
end;

procedure TMapTexture.CreateSimple;
var
  map: TMapItem;

begin
  map := TMapItem.Create;
  Maps.Add(map);

  map := TMapItem.Create;
  map.SetRGBFTV(1, 1, 1, 0, 0, 1);
  Maps.Add(map);
end;

function TMapTexture.IsMapTexture: boolean;
begin
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
//  TSpiralTexture

constructor TSpiralTexture.Create;
begin
  inherited;

  Arms := 3;
end;

function TSpiralTexture.GetID: TTextureID;
begin
  result := tiSpiral;
end;

{*
procedure TSpiralTexture.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);
  dest.WriteBuffer(Arms, sizeof(Arms));
end;
*}

{*
procedure TSpiralTexture.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);
  source.ReadBuffer(Arms, sizeof(Arms));
end;
*}

procedure TSpiralTexture.Generate(var dest: TextFile);
var
  i: integer;
  map: TMapItem;

begin
  WriteLn(dest, Format('#declare %s = texture', [Name]));
  WriteLn(dest, '{');
  WriteLn(dest, '    pigment');
  WriteLn(dest, '    {');
  WriteLn(dest, Format('        %s %d', [TextureNames[MapType], Arms]));
  WriteLn(dest, '        color_map');
  WriteLn(dest, '        {');

  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    map.Generate(dest);
  end;

  WriteLn(dest, '        }');
  GenerateTurbulence(dest);
  WriteLn(dest, '    }');
  GenerateFinish(dest);
  GenerateNormal(dest);
  GenerateTransforms(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

end.
