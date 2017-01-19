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

unit disc;

interface

uses
    System.UITypes,
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TDisc = class(TShape)
  public
    Radius, Hole: double;

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
  Main, Misc, Sphere, discdlg, engine;

constructor TDisc.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  Radius := 1.0;
  Hole := 0.5;
  Build;
end;

function TDisc.GetID: TShapeID;
begin
  result := siDisc;
end;

procedure TDisc.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'disc');
  WriteLn(dest, '{');
  WriteLn(dest, '    <0, 0, 0>,');
  WriteLn(dest, '    <0, 0, -1>,');
  WriteLn(dest, Format('    %6.4f,', [Radius]));
  WriteLn(dest, Format('    %6.4f', [Hole]));
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TDisc.Details;
var
  r, h: double;
  dlg: TDiscDialog;

begin
  dlg := TDiscDialog.Create(Application);

  dlg.Radius.Text := FloatToStrF(Radius, ffFixed, 6, 4);
  dlg.Hole.Text := FloatToStrF(Hole, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    r := StrToFloat(dlg.Radius.Text);
    h := StrToFloat(dlg.Hole.Text);

    if r > h then
    begin
      Radius := r;
      Hole := h;

      Build;

      MainForm.Modify(Self);
    end
    else
      MessageDlg('Radius must be larger than Hole', mtError, [mbOK], 0);
  end;

  dlg.Free;
end;

procedure TDisc.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(Radius, sizeof(Radius));
  source.ReadBuffer(Hole, sizeof(Hole));

  Build;
end;

procedure TDisc.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(Radius, sizeof(Radius));
  dest.WriteBuffer(Hole, sizeof(Hole));
end;

procedure TDisc.Build;
begin
  Triangles.Clear;
  CreateDisc(Self, Hole, Radius, 0.0, 0.0, 0.0);
end;

end.
