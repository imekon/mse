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

unit brick;

interface

uses
  System.JSON,
  Winapi.Windows, System.Classes, System.SysUtils, VCL.Graphics, VCL.Forms,
  Vector, Texture;

type
  TBrickTexture = class(TTexture)
  public
    { colour values }
    Red2, Green2, Blue2, Filter2, Transmit2: double;
    BrickSize: TVector;
    Mortar: double;

    constructor Create; override;
    function GetID: TTextureID; override;
    procedure Save(parent: TJSONArray); override;
    //procedure SaveToFile(dest: TStream); override;
    //procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure Draw(x: integer; canvas: TCanvas); override;
  end;

implementation

constructor TBrickTexture.Create;
begin
  inherited;

  { colour values }
  Red2 := 0.0;
  Green2 := 0.0;
  Blue2 := 0.0;
  Filter2 := 0.0;
  Transmit2 := 0.0;

  Mortar := 0.5;

  BrickSize := TVector.Create;

  BrickSize.X := 8;
  BrickSize.Y := 3;
  BrickSize.Z := 4.5;
end;

function TBrickTexture.GetID: TTextureID;
begin
  result := tiBrick;
end;

procedure TBrickTexture.Save(parent: TJSONArray);
var
  child: TJSONObject;

begin
  inherited;
  child := TJSONObject.Create;
  child.AddPair('red2', TJSONNumber.Create(Red2));
  child.AddPair('green2', TJSONNumber.Create(Green2));
  child.AddPair('blue2', TJSONNumber.Create(Blue2));
  child.AddPair('filter2', TJSONNumber.Create(Filter2));
  child.AddPair('transmit2', TJSONNumber.Create(Transmit2));
  parent.Add(child);
end;

{*
procedure TBrickTexture.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(Red2, sizeof(Red2));
  dest.WriteBuffer(Green2, sizeof(Green2));
  dest.WriteBuffer(Blue2, sizeof(Blue2));
  dest.WriteBuffer(Filter2, sizeof(Filter2));
  dest.WriteBuffer(Transmit2, sizeof(Transmit2));
end;
*}

{*
procedure TBrickTexture.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(Red2, sizeof(Red2));
  source.ReadBuffer(Green2, sizeof(Green2));
  source.ReadBuffer(Blue2, sizeof(Blue2));
  source.ReadBuffer(Filter2, sizeof(Filter2));
  source.ReadBuffer(Transmit2, sizeof(Transmit2));
end;
*}

procedure TBrickTexture.Generate(var dest: TextFile);
begin
  WriteLn(dest, Format('#declare %s = texture', [Name]));
  WriteLn(dest, '{');
  WriteLn(dest, '    pigment');
  WriteLn(dest, '    {');
  WriteLn(dest, '        brick');
  WriteLn(dest,
    Format('            color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f',
    [Red2, Green2, Blue2, Filter2, Transmit2]));
  WriteLn(dest,
    Format('            color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f,',
    [Red, Green, Blue, Filter, Transmit]));
  WriteLn(dest, Format('            brick_size <%6.4f, %6.4f, %6.4f>',
    [BrickSize.X, BrickSize.Y, BrickSize.Z]));
  WriteLn(dest, Format('            mortar %6.4f', [Mortar]));
  GenerateTurbulence(dest);
  WriteLn(dest, '    }');
  GenerateFinish(dest);
  GenerateNormal(dest);
  GenerateTransforms(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TBrickTexture.Draw(x: integer; canvas: TCanvas);
var
  middle: integer;

begin
  inherited Draw(x, canvas);
  middle := TextSize div 2;
  with canvas do
  begin
    Pen.Color := ConvertPaletteRGB(Red2, Green2, Blue2);
    MoveTo(x + 2, 2);
    LineTo(x + TextSize - 3, 2);
    MoveTo(x + 2, middle);
    LineTo(x + TextSize - 3, middle);
    MoveTo(x + TextSize div 3, 2);
    LineTo(x + TextSize div 3, middle);
    MoveTo(x + (TextSize * 2) div 3, middle);
    LineTo(x + (TextSize * 2) div 3, TextSize - 3);
  end;
end;

end.
