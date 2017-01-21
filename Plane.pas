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

unit Plane;

interface

uses
    Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics, VCL.Forms,
    VCL.Controls, VCL.Menus,
    VCL.StdCtrls, VCL.Dialogs, VCL.Buttons, Winapi.Messages, Vector, Scene;

type
  TPlane = class(TShape)
  public
    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
  end;

implementation

uses engine;

constructor TPlane.Create;
begin
  inherited Create;

  Features := Features + [sfCanTranslate, sfCanRotate, sfCanGenerate];

  CreatePlane(Self, 0.0, 0.0, 0.0, 100.0);
end;

function TPlane.GetID: TShapeID;
begin
  result := siPlane;
end;

procedure TPlane.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'plane');
  WriteLn(dest, '{');
  WriteLn(dest, '    -z, 0');
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

{*
procedure TPlane.GenerateDirectXForm(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
var
  MeshBuilder: IDirect3DRMMeshBuilder;
  Face: IDirect3DRMFace;

begin
  D3DRM.CreateMeshBuilder(MeshBuilder);

  MeshBuilder.CreateFace(Face);

  Face.AddVertex(-100, 100, 0);
  Face.AddVertex(100, 100, 0);
  Face.AddVertex(100, -100, 0);
  Face.AddVertex(-100, -100, 0);

  if Texture <> nil then
    MeshBuilder.SetColorRGB(Texture.Red, Texture.Green, Texture.Blue);

  if sfCanRotate in Features then
  begin
    MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 1, 0, 0, -Rotate.X * d2r);
    MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 0, 1, 0, -Rotate.Y * d2r);
    MeshFrame.AddRotation(D3DRMCOMBINE_AFTER, 0, 0, 1, -Rotate.Z * d2r);
  end;

  if sfCanTranslate in Features then MeshFrame.AddTranslation(D3DRMCOMBINE_AFTER, Translate.X, Translate.Y, Translate.Z);

  MeshFrame.AddVisual(MeshBuilder);
end;
*}

end.
