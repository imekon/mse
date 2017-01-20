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

unit torus;

interface

uses
  System.UITypes,
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TTorus = class(TShape)
  public
    Major, Minor: double;
    Sturm: boolean;

    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure Details; override;
    procedure LoadFromFile(source: TStream); override;
    procedure SaveToFile(dest: TStream); override;
    procedure Build;
  end;

implementation

uses
  Main, Engine, Solid, TorusDlg;

constructor TTorus.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  Major := 1.0;
  Minor := 0.5;
  Build;
end;

function TTorus.GetID: TShapeID;
begin
  result := siTorus;
end;

procedure TTorus.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'torus');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    %6.4f,', [Major]));
  WriteLn(dest, Format('    %6.4f', [Minor]));
  if Sturm then
    WriteLn(dest, '    sturm');
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TTorus.Details;
var
  dlg: TTorusDialog;
  m1, m2: double;

begin
  dlg := TTorusDialog.Create(Application);

  dlg.Major.Text := FloatToStrF(Major, ffFixed, 6, 4);
  dlg.Minor.Text := FloatToStrF(Minor, ffFixed, 6, 4);
  dlg.Sturm.Checked := Sturm;

  if dlg.ShowModal = idOK then
  begin
    m1 := StrToFloat(dlg.Major.Text);
    m2 := StrToFloat(dlg.Minor.Text);
    if m1 > m2 then
    begin
      Major := m1;
      Minor := m2;
      Sturm := dlg.Sturm.Checked;

      Build;

      MainForm.Modify(Self);
    end
    else
      MessageDlg('Major must be greater than Minor', mtError, [mbOK], 0);
  end;

  dlg.Free;
end;

procedure TTorus.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(Major, sizeof(Major));
  source.ReadBuffer(Minor, sizeof(Minor));
  source.ReadBuffer(Sturm, sizeof(Sturm));

  Build;
end;

procedure TTorus.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(Major, sizeof(Major));
  dest.WriteBuffer(Minor, sizeof(Minor));
  dest.WriteBuffer(Sturm, sizeof(Sturm));
end;

procedure TTorus.Build;
begin
  Triangles.Clear;

  CreateTorus(Self, Major, Minor, 0.0, 0.0, 0.0);
end;

end.
