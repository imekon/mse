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

unit hexagon;

interface

uses
  System.JSON,
  Winapi.Windows, System.Classes, System.SysUtils, VCL.Graphics, VCL.Forms,
  Vector, Texture;

type
  THexagonTexture = class(TTexture)
  public
    { colour values }
    Red2, Green2, Blue2, Filter2, Transmit2,
      Red3, Green3, Blue3, Filter3, Transmit3: double;

    constructor Create; override;
    function GetID: TTextureID; override;
    procedure Save(parent: TJSONArray); override;
    //procedure SaveToFile(dest: TStream); override;
    //procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
  end;

implementation

constructor THexagonTexture.Create;
begin
  inherited;

  { colour values }
  Red2 := 0.0;
  Green2 := 0.0;
  Blue2 := 0.0;
  Filter2 := 0.0;
  Transmit2 := 0.0;

  Red3 := 0.0;
  Green3 := 0.0;
  Blue3 := 0.0;
  Filter3 := 0.0;
  Transmit3 := 0.0;
end;

function THexagonTexture.GetID: TTextureID;
begin
  result := tiHexagon;
end;

procedure THexagonTexture.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  inherited;
  obj := TJSONObject.Create;
  obj.AddPair('red2', TJSONNumber.Create(Red2));
  obj.AddPair('green2', TJSONNumber.Create(Green2));
  obj.AddPair('blue2', TJSONNumber.Create(Blue2));
  obj.AddPair('filter2', TJSONNumber.Create(Filter2));
  obj.AddPair('transmit2', TJSONNumber.Create(Transmit2));
  obj.AddPair('red3', TJSONNumber.Create(Red3));
  obj.AddPair('green3', TJSONNumber.Create(Green3));
  obj.AddPair('blue3', TJSONNumber.Create(Blue3));
  obj.AddPair('filter3', TJSONNumber.Create(Filter3));
  obj.AddPair('transmit3', TJSONNumber.Create(Transmit3));
  parent.Add(obj);
end;

{*
procedure THexagonTexture.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(Red2, sizeof(Red2));
  dest.WriteBuffer(Green2, sizeof(Green2));
  dest.WriteBuffer(Blue2, sizeof(Blue2));
  dest.WriteBuffer(Filter2, sizeof(Filter2));
  dest.WriteBuffer(Transmit2, sizeof(Transmit2));

  dest.WriteBuffer(Red3, sizeof(Red3));
  dest.WriteBuffer(Green3, sizeof(Green3));
  dest.WriteBuffer(Blue3, sizeof(Blue3));
  dest.WriteBuffer(Filter3, sizeof(Filter3));
  dest.WriteBuffer(Transmit3, sizeof(Transmit3));
end;
*}

{*
procedure THexagonTexture.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(Red2, sizeof(Red2));
  source.ReadBuffer(Green2, sizeof(Green2));
  source.ReadBuffer(Blue2, sizeof(Blue2));
  source.ReadBuffer(Filter2, sizeof(Filter2));
  source.ReadBuffer(Transmit2, sizeof(Transmit2));

  source.ReadBuffer(Red3, sizeof(Red3));
  source.ReadBuffer(Green3, sizeof(Green3));
  source.ReadBuffer(Blue3, sizeof(Blue3));
  source.ReadBuffer(Filter3, sizeof(Filter3));
  source.ReadBuffer(Transmit3, sizeof(Transmit3));
end;
*}

procedure THexagonTexture.Generate(var dest: TextFile);
begin
  WriteLn(dest, Format('#declare %s = texture', [Name]));
  WriteLn(dest, '{');
  WriteLn(dest, '    pigment');
  WriteLn(dest, '    {');
  WriteLn(dest, '        hexagon');
  WriteLn(dest,
    Format('            color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f,',
    [Red, Green, Blue, Filter, Transmit]));
  WriteLn(dest,
    Format('            color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f,',
    [Red2, Green2, Blue2, Filter2, Transmit2]));
  WriteLn(dest,
    Format('            color red %6.4f green %6.4f blue %6.4f filter %6.4f transmit %6.4f',
    [Red3, Green3, Blue3, Filter3, Transmit3]));
  GenerateTurbulence(dest);
  WriteLn(dest, '    }');
  GenerateFinish(dest);
  GenerateNormal(dest);
  GenerateTransforms(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

end.
