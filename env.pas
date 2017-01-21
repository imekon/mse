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

unit env;

interface

uses
  VCL.Forms, Scene;

type
  TEnvironment = class(TShape)
  public
    Sound, Environment, Obstruction: string;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure Details; override;
  end;

implementation

uses engine, envdlg;

constructor TEnvironment.Create;
begin
  inherited Create;
  Features := Features + BasicFeatures;
  CreateCube(Self, 0.0, 0.0, 0.0);
end;

destructor TEnvironment.Destroy;
begin
  inherited Destroy;
end;

function TEnvironment.GetID: TShapeID;
begin
  result := siEnvironment;
end;

procedure TEnvironment.Details;
var
  dlg: TEnvironmentDialog;

begin
  dlg := TEnvironmentDialog.Create(Application);

  dlg.ShowModal;

  dlg.Free;
end;

end.
