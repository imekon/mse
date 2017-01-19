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

unit Cube;

interface

uses
    Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TCube = class(TShape)
  public
    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure GenerateVRML(var dest: TextFile); override;
  end;

implementation

uses engine;

constructor TCube.Create;
begin
  inherited Create;
  Features := Features + StandardFeatures;
  CreateCube(Self, 0.0, 0.0, 0.0);
end;

function TCube.GetID: TShapeID;
begin
  result := siCube;
end;

procedure TCube.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'box');
  WriteLn(dest, '{');
  WriteLn(dest, '    <-1, -1, -1>');
  WriteLn(dest, '    <1, 1, 1>');
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TCube.GenerateVRML(var dest: TextFile);
begin
  WriteLn(dest, '  Separator');
  WriteLn(dest, '  {');
  GenerateVRMLDetails(dest);
  WriteLn(dest, '    Cube {}');
  WriteLn(dest, '  }');
end;

end.
