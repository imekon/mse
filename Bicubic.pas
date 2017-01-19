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

unit Bicubic;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TControlPoint = class(TVector)
  public
    Selected: boolean;
    Anchor: TVector;

    constructor Create; override;
    destructor Destroy; override;
  end;

  TBicubicPatch = class
  public
    Controls: array [0..3, 0..3] of TControlPoint;

    constructor Create;
    destructor Destroy; override;
    procedure SaveToFile(dest: TStream);
    procedure LoadFromFile(source: TStream);
    procedure Generate(var dest: TextFile; PatchType: integer;
      Flatness: double; USteps, VSteps: integer);
    procedure SetSelectedXY(x, y: integer; select: boolean);
    procedure SetSelected(select: boolean);
    procedure ToggleSelected(x, y: integer);
    function HasAllSelected: boolean;
    procedure SetAnchor;
    procedure SetTranslate(xd, yd, zd: double; xb, yb, zb: boolean);
    procedure SetScale(xd, yd, zd: double; xb, yb, zb: boolean);
    procedure SetRotate(xd, yd, zd: double; xb, yb, zb: boolean);
  end;

  TBicubicShape = class(TShape)
  public
    PatchType: integer;
    Flatness: double;
    USteps, VSteps: integer;

    Patches: TList;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    function CreateQuery: boolean; override;
    procedure Details; override;
    procedure Build;
  end;

procedure CreateBicubicSheet(patch: TBicubicPatch; x, y, z: double);
procedure CreateBicubicCylinderHalf(patch: TBicubicPatch; a, x, y, z: double);

implementation

uses bicubedit, crebicubic;

////////////////////////////////////////////////////////////////////////////////
//  TBicubicPoint

constructor TControlPoint.Create;
begin
  inherited;
  Selected := False;
  Anchor := TVector.Create;
end;

destructor TControlPoint.Destroy;
begin
  Anchor.Free;

  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
//  TBicubicPatch

constructor TBicubicPatch.Create;
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      Controls[x, y] := TControlPoint.Create;
end;

destructor TBicubicPatch.Destroy;
var
  x, y: integer;
  v: TControlPoint;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
    begin
      v := Controls[x, y];
      v.Free;
    end;

  inherited;
end;

function TBicubicPatch.HasAllSelected: boolean;
var
  x, y: integer;
  v: TControlPoint;

begin
  result := True;
  for y := 0 to 3 do
    for x:= 0 to 3 do
    begin
      v := Controls[x, y];
      if not v.Selected then
        result := False;
    end;
end;

procedure TBicubicPatch.LoadFromFile(source: TStream);
var
  x, y: integer;
  v: TControlPoint;

begin
  for y := 0 to 3 do
    for x:= 0 to 3 do
    begin
      v := Controls[x, y];
      v.LoadFromFile(source);
    end;
end;

procedure TBicubicPatch.SaveToFile(dest: TStream);
var
  x, y: integer;
  v: TControlPoint;

begin
  for y := 0 to 3 do
    for x:= 0 to 3 do
    begin
      v := Controls[x, y];
      v.SaveToFile(dest);
    end;
end;

procedure TBicubicPatch.Generate(var dest: TextFile; PatchType: integer;
      Flatness: double; USteps, VSteps: integer);
var
  x, y: integer;
  v: TControlPoint;

begin
  WriteLn(dest, '    bicubic_patch');
  WriteLn(dest, '    {');
  WriteLn(dest, Format('        type %d', [PatchType]));
  WriteLn(dest, Format('        flatness %6.4f', [Flatness]));
  WriteLn(dest, Format('        u_steps %d v_steps %d', [USteps, VSteps]));
  for y := 0 to 3 do
    for x := 0 to 3 do
    begin
      v := Controls[x, y];
      Write(dest, Format('        <%6.4f, %6.4f, %6.4f>', [v.x, v.y, v.z]));
      if (x < 3) or (y < 3) then
        WriteLn(dest, ',')
      else
        WriteLn(dest);
    end;
  WriteLn(dest, '    }');
  WriteLn(dest);
end;

procedure TBicubicPatch.SetSelectedXY(x, y: integer; select: boolean);
begin
  Controls[x, y].Selected := select;
end;

procedure TBicubicPatch.SetSelected(select: boolean);
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      SetSelectedXY(x, y, select);
end;

procedure TBicubicPatch.ToggleSelected(x, y: integer);
begin
  Controls[x, y].Selected := not Controls[x, y].Selected;
end;

procedure TBicubicPatch.SetAnchor;
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
    begin
      Controls[x, y].Anchor.X := Controls[x, y].X;
      Controls[x, y].Anchor.Y := Controls[x, y].Y;
      Controls[x, y].Anchor.Z := Controls[x, y].Z;
    end;
end;

procedure TBicubicPatch.SetTranslate(xd, yd, zd: double; xb, yb, zb: boolean);
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      if Controls[x, y].Selected then
      begin
        if xb then
          Controls[x, y].x := Controls[x, y].Anchor.X + xd;

        if yb then
          Controls[x, y].y := Controls[x, y].Anchor.Y + yd;

        if zb then
          Controls[x, y].z := Controls[x, y].Anchor.Z + zd;
      end;
end;

procedure TBicubicPatch.SetScale(xd, yd, zd: double; xb, yb, zb: boolean);
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      if Controls[x, y].Selected then
      begin
        if xb then
          Controls[x, y].x := Controls[x, y].Anchor.x * abs(xd + 1);

        if yb then
          Controls[x, y].y := Controls[x, y].Anchor.y * abs(yd + 1);

        if zb then
          Controls[x, y].z := Controls[x, y].Anchor.z * abs(zd + 1);
      end;
end;

procedure TBicubicPatch.SetRotate(xd, yd, zd: double; xb, yb, zb: boolean);
var
  x, y: integer;

begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      if Controls[x, y].Selected then
      begin
        if xb and yb then
        begin
          RotatePointZ(Controls[x, y].Anchor.x,
            Controls[x, y].Anchor.y,
            Controls[x, y].Anchor.z,
            Controls[x, y].x,
            Controls[x, y].y,
            Controls[x, y].z,
            zd);

          {Controls[x, y].x := Controls[x, y].Anchor.x * cos(zd);
          Controls[x, y].y := Controls[x, y].Anchor.y * sin(zd);}
        end;

        if xb and zb then
        begin
          RotatePointY(Controls[x, y].Anchor.x,
            Controls[x, y].Anchor.y,
            Controls[x, y].Anchor.z,
            Controls[x, y].x,
            Controls[x, y].y,
            Controls[x, y].z,
            yd);

          {Controls[x, y].x := Controls[x, y].Anchor.x * cos(yd);
          Controls[x, y].z := Controls[x, y].Anchor.z * sin(yd);}
        end;

        if yb and zb then
        begin
          RotatePointX(Controls[x, y].Anchor.x,
            Controls[x, y].Anchor.y,
            Controls[x, y].Anchor.z,
            Controls[x, y].x,
            Controls[x, y].y,
            Controls[x, y].z,
            xd);

          {Controls[x, y].y := Controls[x, y].Anchor.y * cos(xd);
          Controls[x, y].z := Controls[x, y].Anchor.z * sin(xd);}
        end;
      end;
end;

////////////////////////////////////////////////////////////////////////////////
//  TBicubicShape

constructor TBicubicShape.Create;
begin
  inherited Create;

  Features := Features + StandardFeatures;

  Flatness := 0;
  PatchType := 1;
  USteps := 5;
  VSteps := 5;

  Patches := TList.Create;
end;

destructor TBicubicShape.Destroy;
var
  i: integer;
  patch: TBicubicPatch;

begin
  for i := 0 to Patches.Count - 1 do
  begin
    patch := Patches[i];
    patch.Free;
  end;

  Patches.Free;

  inherited Destroy;
end;

function TBicubicShape.CreateQuery: boolean;
var
  x, y, w, h: integer;
  xx, yy: double;
  dlg: TCreateBicubicDialog;
  patch: TBicubicPatch;

begin
  result := false;
  dlg := TCreateBicubicDialog.Create(Application);

  if dlg.ShowModal = idOK then
  begin
    w := StrToInt(dlg.Width.Text);
    h := StrToInt(dlg.Height.Text);
    case dlg.PatchType.ItemIndex of
      0:
      begin
        xx := -w;
        yy := -h;
        for y := 0 to h - 1 do
          for x := 0 to w - 1 do
          begin
            patch := TBicubicPatch.Create;
            CreateBicubicSheet(patch, xx + 2 * x + 1, yy + 2 * y + 1, 0);
            Patches.Add(patch);
          end;
      end;

      1:
      begin
        yy := -h;
        for y := 0 to h - 1 do
        begin
          patch := TBicubicPatch.Create;
          CreateBicubicCylinderHalf(patch, -1, 0, yy + 2 * y + 1, 0);
          Patches.Add(patch);

          patch := TBicubicPatch.Create;
          CreateBicubicCylinderHalf(patch, 1, 0, yy + 2 * y + 1, 0);
          Patches.Add(patch);
        end;
      end;
    end;
    result := true
  end
  else
  begin
    patch := TBicubicPatch.Create;
    CreateBicubicSheet(patch, 0, 0, 0);
    Patches.Add(patch);
  end;

  dlg.Free;
  Build;
end;

function TBicubicShape.GetID: TShapeID;
begin
  result := siBicubicShape;
end;

procedure TBicubicShape.Build;
var
  i, x, y: integer;
  triangle: TTriangle;
  patch: TBicubicPatch;
  p1, p2, p3, p4: TControlPoint;

begin
  Triangles.Clear;

  for i := 0 to Patches.Count - 1 do
  begin
    patch := Patches[i];

    for y := 0 to 2 do
      for x := 0 to 2 do
      begin
        p1 := patch.Controls[x, y];
        p2 := patch.Controls[x + 1, y];
        p3 := patch.Controls[x + 1, y + 1];
        p4 := patch.Controls[x, y + 1];

        triangle := TTriangle.Create;

        triangle.Points[1].x := p1.x;
        triangle.Points[1].y := p1.y;
        triangle.Points[1].z := p1.z;

        triangle.Points[2].x := p2.x;
        triangle.Points[2].y := p2.y;
        triangle.Points[2].z := p2.z;

        triangle.Points[3].x := p3.x;
        triangle.Points[3].y := p3.y;
        triangle.Points[3].z := p3.z;

        Triangles.Add(triangle);

        triangle := TTriangle.Create;

        triangle.Points[1].x := p1.x;
        triangle.Points[1].y := p1.y;
        triangle.Points[1].z := p1.z;

        triangle.Points[2].x := p3.x;
        triangle.Points[2].y := p3.y;
        triangle.Points[2].z := p3.z;

        triangle.Points[3].x := p4.x;
        triangle.Points[3].y := p4.y;
        triangle.Points[3].z := p4.z;

        Triangles.Add(triangle);
      end;
  end;
end;

procedure TBicubicShape.SaveToFile(dest: TStream);
var
  i, n: integer;
  patch: TBicubicPatch;

begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(PatchType, sizeof(PatchType));
  dest.WriteBuffer(Flatness, sizeof(Flatness));
  dest.WriteBuffer(USteps, sizeof(USteps));
  dest.WriteBuffer(VSteps, sizeof(VSteps));

  n := Patches.Count;

  dest.WriteBuffer(n, sizeof(n));

  for i := 0 to n - 1 do
  begin
    patch := Patches[i];
    patch.SaveToFile(dest);
  end;
end;

procedure TBicubicShape.LoadFromFile(source: TStream);
var
  i, n: integer;
  patch: TBicubicPatch;

begin
  inherited LoadFromFile(source);

  source.ReadBuffer(PatchType, sizeof(PatchType));
  source.ReadBuffer(Flatness, sizeof(Flatness));
  source.ReadBuffer(USteps, sizeof(USteps));
  source.ReadBuffer(VSteps, sizeof(VSteps));

  source.ReadBuffer(n, sizeof(n));

  for i := 1 to n do
  begin
    patch := TBicubicPatch.Create;
    patch.LoadFromFile(source);
    Patches.Add(patch);
  end;

  Build;
end;

procedure TBicubicShape.Generate(var dest: TextFile);
var
  i: integer;
  patch: TBicubicPatch;

begin
  WriteLn(dest, 'union');
  WriteLn(dest, '{');

  for i := 0 to Patches.Count - 1 do
  begin
    patch := Patches[i];
    patch.Generate(dest, PatchType, Flatness, USteps, VSteps);
  end;

  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TBicubicShape.Details;
begin
  BicubicEditor.SetBicubic(Self);
end;

////////////////////////////////////////////////////////////////////////////////
//

const
  BicubicVector: array [0..3] of double = (-1, -0.3333, 0.3333, 1);
  BicubicWidth: array [0..3] of double = (0, 0.6666, 0.6666, 0);
  BicubicDepth: array [0..3] of double = (1, 0.6666, -0.6666, -1);

procedure CreateBicubicSheet(patch: TBicubicPatch; x, y, z: double);

var
  xi, yi: integer;

begin
  for yi := 0 to 3 do
    for xi := 0 to 3 do
    begin
      patch.Controls[xi, yi].x := BicubicVector[xi] + x;
      patch.Controls[xi, yi].y := BicubicVector[yi] + y;
      patch.Controls[xi, yi].z := z;
    end;
end;

procedure CreateBicubicCylinderHalf(patch: TBicubicPatch; a, x, y, z: double);
var
  xi, yi: integer;

begin
  for yi := 0 to 3 do
    for xi := 0 to 3 do
    begin
      patch.Controls[xi, yi].x := a * BicubicWidth[xi] + x;
      patch.Controls[xi, yi].y := BicubicVector[yi] + y;
      patch.Controls[xi, yi].z := BicubicDepth[xi] + z;
    end;
end;

end.
