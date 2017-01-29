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

unit super;

interface

uses
  System.JSON,
    Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics, VCL.Forms,
    VCL.Controls, VCL.Menus,
    VCL.StdCtrls, VCL.Dialogs, VCL.Buttons, Winapi.Messages, Vector, Scene, Cube;

type
  TSuperEllipsoid = class(TCube)
    public
      R, N: double;

      constructor Create; override;
      function GetID: TShapeID; override;
      procedure Generate(var dest: TextFile); override;
      procedure Details(context: IDrawingContext); override;
      procedure Save(parent: TJSONArray); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
    end;

implementation

uses
  superdlg;

constructor TSuperEllipsoid.Create;
begin
  inherited Create;
  R := 0.25;
  N := 0.25;
end;

function TSuperEllipsoid.GetID: TShapeID;
begin
  result := siSuperEllipsoid;
end;

procedure TSuperEllipsoid.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'superellipsoid');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    <%6.4f, %6.4f>', [R, N]));
  GenerateDetails(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TSuperEllipsoid.Details(context: IDrawingContext);
var
  dlg: TSuperDialog;

begin
  dlg := TSuperDialog.Create(Application);

  dlg.RValue.Text := FloatToStrF(R, ffFixed, 6, 4);
  dlg.NValue.Text := FloatToStrF(N, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    R := StrToFloat(dlg.RValue.Text);
    N := StrToFloat(dlg.NValue.Text);
  end;

  dlg.Free;
end;

procedure TSuperEllipsoid.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  inherited;
  obj := TJSONObject.Create;
  obj.AddPair('r', TJSONNumber.Create(R));
  obj.AddPair('n', TJSONNumber.Create(N));
  parent.Add(obj);
end;

procedure TSuperEllipsoid.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(R, sizeof(R));
  dest.WriteBuffer(N, sizeof(N));
end;

procedure TSuperEllipsoid.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(R, sizeof(R));
  source.ReadBuffer(N, sizeof(N));
end;

end.
