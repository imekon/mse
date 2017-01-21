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

unit text;

interface

uses
  System.JSON,
    Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics, VCL.Forms,
    VCL.Controls, VCL.Menus,
    VCL.StdCtrls, VCL.Dialogs, VCL.Buttons, Winapi.Messages, Vector, Scene;

type
  TText = class(TShape)
    public
      Text: AnsiString;
      Font: AnsiString;
      Thickness: double;
      Offset: TVector;

      constructor Create; override;
      destructor Destroy; override;
      function GetID: TShapeID; override;
      procedure Save(parent: TJSONArray); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Generate(var dest: TextFile); override;
      function CreateQuery: boolean; override;
      procedure Details; override;
      procedure Build;
    end;

procedure CreateTextShape(shape: TShape; width, height, depth, x, y, z: double);

implementation

uses Misc, Cube, Textfm;

constructor TText.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  Thickness := 1;
  Offset := TVector.Create;
end;

destructor TText.Destroy;
begin
  Offset.Free;

  inherited;
end;

function TText.GetID: TShapeID;
begin
  result := siText;
end;

procedure TText.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  inherited;
  obj := TJSONObject.Create;
  obj.AddPair('font', Font);
  obj.AddPair('text', Text);
  obj.AddPair('thickness', TJSONNumber.Create(Thickness));
  parent.Add(obj);
end;

procedure TText.SaveToFile(dest: TStream);
begin
  inherited;

  SaveStringToStream(Font, dest);
  SaveStringToStream(Text, dest);
  dest.WriteBuffer(Thickness, sizeof(Thickness));
  Offset.SaveToFile(dest);
end;

procedure TText.LoadFromFile(source: TStream);
begin
  inherited;

  LoadStringFromStream(Font, source);
  LoadStringFromStream(Text, source);
  source.ReadBuffer(Thickness, sizeof(Thickness));
  Offset.LoadFromFile(source);

  Build;
end;

procedure TText.Build;
var
  x, y, z, width, height: double;

begin
  width := Length(Text) * 0.5;
  height := 0.75;
  x := width / 2;
  y := -height / 2;
  z := 0;
  CreateTextShape(Self, width, height, Thickness, x, y, z);
end;

procedure TText.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'text');
  WriteLn(dest, '{');
  WriteLn(dest, '    ttf "', Font, '",');
  WriteLn(dest, '    "', Text, '",');
  WriteLn(dest, Format('    %6.4f, <%6.4f, %6.4f, %6.4f>',
    [Thickness, Offset.x, Offset.y, Offset.z]));
  inherited;
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TText.Details;
var
  dlg: TTextDialog;

begin
  dlg := TTextDialog.Create(Application);

  dlg.Font.Text := Font;
  dlg.Text.Text := Text;
  dlg.Thickness.Text := FloatToStrF(Thickness, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Font := dlg.Font.Text;
    Text := dlg.Text.Text;
    Thickness := StrToFloat(dlg.Thickness.Text);

    Build;
  end;

  dlg.Free;
end;

function TText.CreateQuery: boolean;
var
  dlg: TTextDialog;

begin
  result := False;

  dlg := TTextDialog.Create(Application);

  dlg.Font.Text := Font;
  dlg.Text.Text := Text;
  dlg.Thickness.Text := FloatToStrF(Thickness, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Font := dlg.Font.Text;
    Text := dlg.Text.Text;
    Thickness := StrToFloat(dlg.Thickness.Text);

    Build;

    result := True;
  end;

  dlg.Free;
end;

procedure CreateTextShape(shape: TShape; width, height, depth, x, y, z: double);
var
  w2, h2, d2: double;
  v, a, b, c: TVector;

begin
  w2 := width / 2;
  h2 := height / 2;
  d2 := depth / 2;

  v := TVector.Create;
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  { Front face }
  v.z := z + d2;

  v.x := x - w2; v.y := y + h2;
  a.Copy(v);

  v.y := y - h2;
  b.Copy(v);

  v.x := x + w2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.x := x - w2; v.y := y + h2;
  a.Copy(v);

  v.x := x + w2; v.y := y - h2;
  b.Copy(v);

  v.y := y + h2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  { Back face }
  v.z := z - d2;

  v.x := x - w2; v.y := y + h2;
  a.Copy(v);

  v.y := y - h2;
  b.Copy(v);

  v.x := x + w2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.x := x - w2; v.y := y + h2;
  a.Copy(v);

  v.x := x + w2; v.y := y - h2;
  b.Copy(v);

  v.y := y + h2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Left face }
  v.x := x - w2;

  v.z := z - d2; v.y := y + h2;
  a.Copy(v);

  v.y := y - h2;
  b.Copy(v);

  v.z := z + d2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.z := z - d2; v.y := y + h2;
  a.Copy(v);

  v.z := z + d2; v.y := y - h2;
  b.Copy(v);

  v.y := y + h2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  { Right face }
  v.x := x + w2;

  v.z := z - d2; v.y := y + h2;
  a.Copy(v);

  v.y := y - h2;
  b.Copy(v);

  v.z := z + d2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.z := z - d2; v.y := y + h2;
  a.Copy(v);

  v.z := z + d2; v.y := y - h2;
  b.Copy(v);

  v.y := y + h2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Top face }
  v.y := y + h2;

  v.x := x - w2; v.z := z + d2;
  a.Copy(v);

  v.z := z - d2;
  b.Copy(v);

  v.x := x + w2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.x := x - w2; v.z := z + d2;
  a.Copy(v);

  v.x := x + w2; v.z := z - d2;
  b.Copy(v);

  v.z := z + d2;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Bottom face }
  v.y := y - h2;

  v.x := x - w2; v.z := z + d2;
  a.Copy(v);

  v.z := z - d2;
  b.Copy(v);

  v.x := x + w2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.x := x - w2; v.z := z + d2;
  a.Copy(v);

  v.x := x + w2; v.z := z - d2;
  b.Copy(v);

  v.z := z + d2;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.Free;
  a.Free;
  b.Free;
  c.Free;
end;

end.
