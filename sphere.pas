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

unit Sphere;

interface

uses
    System.Contnrs,
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TSphere = class(TShape)
  public
    Radius, Strength: double;

    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure GenerateBlob(var dest: TextFile); override;
    procedure GenerateVRML(var dest: TextFile); override;
    procedure GenerateCoolRay(var dest: TextFile); override;
    procedure Details(context: IDrawingContext); override;
    procedure LoadFromFile(source: TStream); override;
    procedure SaveToFile(dest: TStream); override;
    procedure Build;
  end;

implementation

uses Solid, spheredlg, engine;

constructor TSphere.Create;
begin
  inherited Create;
  Features := Features + StandardBlobFeatures;
  Radius := 1.0;
  Strength := 1.0;
  CreateSphere(Self, 0.0, 0.0, 0.0);
end;

function TSphere.GetID: TShapeID;
begin
  result := siSphere;
end;

procedure TSphere.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'sphere');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    <0, 0, 0> %6.4f', [Radius]));
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TSphere.GenerateVRML(var dest: TextFile);
begin
  WriteLn(dest, '  Separator');
  WriteLn(dest, '  {');
  GenerateVRMLDetails(dest);
  WriteLn(dest, '    Sphere {}');
  WriteLn(dest, '  }');
end;

procedure TSphere.GenerateCoolRay(var dest: TextFile);
begin
  WriteLn(dest, '    Sphere');
  WriteLn(dest, '    {');
  WriteLn(dest, Format('      center := <%6.4f, %6.4f, %6.4f>;',
    [Translate.x, Translate.y, Translate.z]));
  WriteLn(dest, Format('      radius := %6.4f;', [Radius]));
  GenerateCoolRayTexture(dest);
  WriteLn(dest, '    }');
end;

procedure TSphere.GenerateBlob(var dest: TextFile);
begin
  WriteLn(dest, 'sphere');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    <0, 0, 0> %6.4f, %6.4f', [Radius, Strength]));
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TSphere.Build;
var
  i, j: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;

    for j := 1 to 3 do
    begin
      triangle.Points[j].X := triangle.Points[j].X * Radius;
      triangle.Points[j].Y := triangle.Points[j].Y * Radius;
      triangle.Points[j].Z := triangle.Points[j].Z * Radius;
    end;
  end;
end;

procedure TSphere.Details(context: IDrawingContext);
var
  dlg: TSphereDialog;

begin
  dlg := TSphereDialog.Create(Application);

  dlg.Radius.Text := FloatToStrF(Radius, ffFixed, 6, 4);
  dlg.Strength.Text := FloatToStrF(Strength, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Radius := StrToFloat(dlg.Radius.Text);
    Strength := StrToFloat(dlg.Strength.Text);

    Build;

    context.Modify(Self);
  end;

  dlg.Free;
end;

procedure TSphere.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(Radius, sizeof(Radius));
  source.ReadBuffer(Strength, sizeof(Strength));

  Build;
end;

procedure TSphere.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(Radius, sizeof(Radius));
  dest.WriteBuffer(Strength, sizeof(Strength));
end;

end.
