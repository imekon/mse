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

unit Polygon;

interface

uses
  System.Contnrs, System.JSON,
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Scene;

type
  TPolygonShapes = (psTriangle, psMesh, psSphere, psCube, psCone, psCylinder,
    psDisc);

  TXYPoint = class
  public
    X, Y, XA, YA: double;
    Selected: boolean;

    constructor Create;
    procedure SetAnchor;
    procedure SetTranslate(AX, AY: double);
  end;

  TReferent = class
  public
    Triangle: TTriangle;
    Point: 1..3;

    constructor Create;
  end;

  TPolygon = class(TShape)
    public
      SmoothShaded: boolean;

      constructor Create; override;
      function GetID: TShapeid; override;
      procedure Save(parent: TJSONArray); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Generate(var dest: TextFile); override;
      function CreateQuery: boolean; override;
      procedure Details(context: IDrawingContext); override;
      function GetMaximum: double;
      procedure Scaling(scale: double);
      procedure CalculateNormals;
      procedure FlipX;
      procedure FlipY;
      procedure FlipZ;
    end;

procedure CreatePolygonTriangle(shape: TShape; x, y, z: double);
procedure CreatePolygonSheet(shape: TShape; w, h: integer; x, y, z: double);
procedure CreatePolygonShape(shape: TShape; list: TList; z: double; reverse: boolean);
procedure CreatePolygonExtrusion(shape: TShape; list: TList; steps: integer; depth: double);

implementation

uses Sphere, Solid, Disc, CrePoly, PolyEdit, ExtDlg, engine;

////////////////////////////////////////////////////////////////////////////////
//  TXYPoint

constructor TXYPoint.Create;
begin
  X := 0;
  Y := 0;
  XA := 0;
  YA := 0;
  Selected := False;
end;

procedure TXYPoint.SetAnchor;
begin
  XA := X;
  YA := Y;
end;

procedure TXYPoint.SetTranslate(AX, AY: double);
begin
  if Selected then
  begin
    x := XA + AX;
    y := YA + AY;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  TReferent

constructor TReferent.Create;
begin
  Triangle := nil;
  Point := 1;
end;

////////////////////////////////////////////////////////////////////////////////
//  TPolygon

constructor TPolygon.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  SmoothShaded := False;
end;

function TPolygon.GetID: TShapeID;
begin
  result := siPolygon;
end;

procedure TPolygon.Save(parent: TJSONArray);
var
  i, n: integer;
  triangle: TTriangle;
  trianglesArray: TJSONArray;
  obj: TJSONObject;

begin
  inherited;
  obj := TJSONObject.Create;
  trianglesArray := TJSONArray.Create;
  n := Triangles.Count;
  for i := 0 to n - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    triangle.Save('triangle', trianglesArray);
  end;
  obj.AddPair('smoothshaded', TJSONBool.Create(SmoothShaded));
  obj.AddPair('triangles', trianglesArray);
  parent.Add(obj);
end;

procedure TPolygon.SaveToFile(dest: TStream);
var
  i: integer;
  triangle: TTriangle;

begin
  inherited SaveToFile(dest);

  // Save number of polygons
  i := Triangles.Count;
  dest.WriteBuffer(i, sizeof(i));

  // Save the polygons
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    triangle.SaveToFile(dest);
  end;

  dest.WriteBuffer(SmoothShaded, sizeof(SmoothShaded));
end;

procedure TPolygon.LoadFromFile(source: TStream);
var
  i, count: integer;
  triangle: TTriangle;

begin
  inherited LoadFromFile(source);

  // Read the number of polygons
  source.ReadBuffer(count, sizeof(count));

  // Read the triangles
  for i := 0 to count - 1 do
  begin
    triangle := TTriangle.Create;
    triangle.LoadFromFile(source);
    Triangles.Add(triangle);
  end;

  if TSceneManager.SceneManager.FileVersion > 7 then
    source.ReadBuffer(SmoothShaded, sizeof(SmoothShaded));
end;

procedure TPolygon.Generate(var dest: TextFile);
var
  i, j: integer;
  triangle: TTriangle;

begin
  if SmoothShaded then CalculateNormals;

  WriteLn(dest, 'mesh');
  WriteLn(dest, '{');

  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;

    if SmoothShaded then
    begin
      WriteLn(dest, '    smooth_triangle');
      WriteLn(dest, '    {');

      for j := 1 to 3 do
        with triangle do
        begin
          Write(dest,
            Format('        <%6.4f, %6.4f, %6.4f>, <%6.4f, %6.4f, %6.4f>',
              [Points[j].x, Points[j].y, Points[j].z,
               Points[j].Normal.x, Points[j].Normal.y, Points[j].Normal.z]));
               
          if j < 3 then
            WriteLn(dest, ',')
          else
            WriteLn(dest);
        end;

      WriteLn(dest, '    }');
    end
    else
    begin
      WriteLn(dest, '    triangle');
      WriteLn(dest, '    {');

      with triangle do
      begin
        WriteLn(dest, Format('        <%6.4f, %6.4f, %6.4f>, <%6.4f, %6.4f, %6.4f>, <%6.4f, %6.4f, %6.4f>',
          [Points[1].x, Points[1].y, Points[1].z,
           Points[2].x, Points[2].y, Points[2].z,
           Points[3].x, Points[3].y, Points[3].z]));
      end;

      WriteLn(dest, '    }');
    end;
  end;

  inherited Generate(dest);
  WriteLn(dest, '}');
end;

procedure TPolygon.Details(context: IDrawingContext);
begin
  PolyEditor.SetPolygon(Self);
end;

function TPolygon.CreateQuery: boolean;
var
  w, h: double;
  ext: TCreateExtrusionDialog;
  dlg: TCreatePolygonDialog;

begin
  result := False;

  if TSceneManager.SceneManager.CreateExtrusion then
  begin
    ext := TCreateExtrusionDialog.Create(Application);

    if ext.ShowModal = idOK then
      CreatePolygonExtrusion(Self, ext.Points, StrToInt(ext.Steps.Text), StrToFloat(ext.Depth.Text));

    ext.Free;
  end
  else
  begin
    dlg := TCreatePolygonDialog.Create(Application);

    if dlg.ShowModal = idOK then
    begin
      w := StrToFloat(dlg.Width.Text);
      h := StrToFloat(dlg.Height.Text);

      case dlg.Polygon.ItemIndex of
        0: CreatePolygonTriangle(Self, 0.0, 0.0, 0.0);
        1: CreatePolygonSheet(Self, trunc(w), trunc(h), 0.0, 0.0, 0.0);
        2: CreateSphere(Self, 0.0, 0.0, 0.0);
        3: CreateCube(Self, 0.0, 0.0, 0.0);
        4: CreateSolidShape(Self, 0.0, 0.0, 0.0, ConeSolid);
        5: CreateSolidShape(Self, 0.0, 0.0, 0.0, CylinderSolid);
        6: CreateDisc(Self, h, w, 0.0, 0.0, 0.0);
      end;

      result := True;
    end;

    dlg.Free;
  end;
end;

function TPolygon.GetMaximum: double;
var
  i, j: integer;
  triangle: TTriangle;

begin
  result := 0;
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    for j := 1 to 3 do
    begin
      if triangle.Points[j].x > result then result := triangle.Points[j].x;
      if triangle.Points[j].y > result then result := triangle.Points[j].y;
      if triangle.Points[j].z > result then result := triangle.Points[j].z;
    end;
  end;
end;

procedure TPolygon.Scaling(scale: double);
var
  i, j: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    for j := 1 to 3 do
    begin
      triangle.Points[j].x := triangle.Points[j].x * scale;
      triangle.Points[j].y := triangle.Points[j].y * scale;
      triangle.Points[j].z := triangle.Points[j].z * scale;
    end;
  end;
end;

procedure TPolygon.FlipX;
var
  i, j: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    for j := 1 to 3 do
    begin
      triangle.Points[j].x := -triangle.Points[j].x;
    end;
  end;
end;

procedure TPolygon.FlipY;
var
  i, j: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    for j := 1 to 3 do
    begin
      triangle.Points[j].y := -triangle.Points[j].y;
    end;
  end;
end;

procedure TPolygon.FlipZ;
var
  i, j: integer;
  triangle: TTriangle;

begin
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;
    for j := 1 to 3 do
    begin
      triangle.Points[j].z := -triangle.Points[j].z;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure CreatePolygonTriangle(shape: TShape; x, y, z: double);
var
  triangle: TTriangle;

begin
  triangle := TTriangle.Create;

  triangle.Points[1].x := x;
  triangle.Points[1].y := y + 1;
  triangle.Points[1].z := z;

  triangle.Points[2].x := x + 1;
  triangle.Points[2].y := y - 1;
  triangle.Points[2].z := z;

  triangle.Points[3].x := x - 1;
  triangle.Points[3].y := y - 1;
  triangle.Points[3].z := z;

  shape.Triangles.Add(triangle);
end;

procedure CreatePolygonSheet(shape: TShape; w, h: integer; x, y, z: double);
var
  xi, yi: integer;
  xx, yy: double;
  triangle: TTriangle;

begin
  xx := -w / 2;
  yy := -h / 2;
  for yi := 0 to h - 1 do
    for xi := 0 to w - 1 do
    begin
      triangle := TTriangle.Create;

      triangle.Points[1].x := xx + xi + x;
      triangle.Points[1].y := yy + yi + y;
      triangle.Points[1].z := z;

      triangle.Points[2].x := xx + xi + x;
      triangle.Points[2].y := yy + yi + y + 1;
      triangle.Points[2].z := z;

      triangle.Points[3].x := xx + xi + x + 1;
      triangle.Points[3].y := yy + yi + y + 1;
      triangle.Points[3].z := z;

      shape.Triangles.Add(triangle);

      triangle := TTriangle.Create;

      triangle.Points[1].x := xx + xi + x;
      triangle.Points[1].y := yy + yi + y;
      triangle.Points[1].z := z;

      triangle.Points[2].x := xx + xi + x + 1;
      triangle.Points[2].y := yy + yi + y + 1;
      triangle.Points[2].z := z;

      triangle.Points[3].x := xx + xi + x + 1;
      triangle.Points[3].y := yy + yi + y;
      triangle.Points[3].z := z;

      shape.Triangles.Add(triangle);
    end;
end;

procedure TPolygon.CalculateNormals;
var
  i, j, u, v: integer;
  x, y, z, x2, y2, z2, xn, yn, zn: double;
  triangle, triangle2: TTriangle;
  references: TList;
  ref: TReferent;

begin
  references := TList.Create;

  // Walk the list of triangles
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;

    // Calculate the normal of the triangle
    triangle.GetNormal;

    // Clear the 'normal done' flag at each point,
    // and copy triangle normal to each point
    for j := 1 to 3 do
    begin
      triangle.Points[j].NormalDone := False;
      triangle.Points[j].Normal.Copy(triangle.Normal);
    end;
  end;

  // For each and every point in the polygon...
  for i := 0 to Triangles.Count - 1 do
  begin
    triangle := Triangles[i] as TTriangle;

    for j := 1 to 3 do
    begin
      x := triangle.Points[j].x;
      y := triangle.Points[j].y;
      z := triangle.Points[j].z;

      // Clean out references array
      while References.Count > 0 do
      begin
        ref := References[0];
        References.Delete(0);
        ref.Free;
      end;

      References.Clear;

      // Create the first reference - the base point
      ref := TReferent.Create;
      ref.Triangle := triangle;
      ref.Point := j;
      References.Add(ref);

      // Walk every other triangle
      for u := 0 to Triangles.Count - 1 do
      begin
        triangle2 := Triangles[u] as TTriangle;

        if triangle2 <> triangle then
          for v := 1 to 3 do
          begin
            x2 := triangle2.Points[v].x;
            y2 := triangle2.Points[v].y;
            z2 := triangle2.Points[v].z;

            // If points are very close, connect them...
            if (abs(x - x2) < 0.001) and
              (abs(y - y2) < 0.001) and
              (abs(z - z2) < 0.001) then
            begin
              ref := TReferent.Create;
              ref.Triangle := triangle2;
              ref.Point := v;
              References.Add(ref);
            end;
          end;
      end;

      // More than one here - if so adjust normals
      if References.Count > 1 then
      begin
        xn := 0;
        yn := 0;
        zn := 0;

        for u := 0 to References.Count - 1 do
        begin
          ref := References[u];
          xn := xn + ref.Triangle.Normal.x;
          yn := yn + ref.Triangle.Normal.y;
          zn := zn + ref.Triangle.Normal.z;
        end;

        xn := xn / References.Count;
        yn := yn / References.Count;
        zn := zn / References.Count;

        for u := 0 to References.Count - 1 do
        begin
          ref := References[u];
          ref.Triangle.Points[ref.Point].Normal.x := xn;
          ref.Triangle.Points[ref.Point].Normal.y := yn;
          ref.Triangle.Points[ref.Point].Normal.z := zn;
        end;
      end;
    end;
  end;

  References.Free;
end;

procedure CreatePolygonShape(shape: TShape; list: TList; z: double; reverse: boolean);
var
  i, j, index: integer;
  point, point2, point3: TXYPoint;
  triangle: TTriangle;

begin
  case list.Count of
    3:
    begin
      triangle := TTriangle.Create;
      for i := 1 to 3 do
      begin
        case i of
          1: index := 0;
          2: index := 1;
          3: index := 2;
        else
          index := 0;
        end;
        point := list[index];
        triangle.Points[i].x := point.x;
        triangle.Points[i].y := point.y;
        triangle.Points[i].z := z;
      end;
      shape.Triangles.Add(triangle);
    end;

    4:
    begin
      triangle := TTriangle.Create;
      for i := 1 to 3 do
      begin
        case i of
          1: index := 0;
          2: index := 1;
          3: index := 2;
        else
          index := 0;
        end;
        point := list[index];
        triangle.Points[i].x := point.x;
        triangle.Points[i].y := point.y;
        triangle.Points[i].z := z;
      end;
      shape.Triangles.Add(triangle);

      triangle := TTriangle.Create;
      for i := 1 to 3 do
      begin
        case i of
          1: index := 0;
          2: index := 2;
          3: index := 3;
        end;
        point := list[index];
        triangle.Points[i].x := point.x;
        triangle.Points[i].y := point.y;
        triangle.Points[i].z := z;
      end;
      shape.Triangles.Add(triangle);
    end;

  else
    begin
      i := 0;
      j := list.Count - 1;
      while abs(j - i) > 1 do
      begin
        inc(i);

        point := list[i - 1];
        point2 := list[i];
        point3 := list[j];

        triangle := TTriangle.Create;

        triangle.Points[1].x := point.x;
        triangle.Points[1].y := point.y;
        triangle.Points[1].z := z;

        triangle.Points[2].x := point3.x;
        triangle.Points[2].y := point3.y;
        triangle.Points[2].z := z;

        triangle.Points[3].x := point2.x;
        triangle.Points[3].y := point2.y;
        triangle.Points[3].z := z;

        shape.Triangles.Add(triangle);

        dec(j);

        point := list[i];
        point2 := list[j + 1];
        point3 := list[j];

        triangle := TTriangle.Create;

        triangle.Points[1].x := point.x;
        triangle.Points[1].y := point.y;
        triangle.Points[1].z := z;

        triangle.Points[2].x := point2.x;
        triangle.Points[2].y := point2.y;
        triangle.Points[2].z := z;

        triangle.Points[3].x := point3.x;
        triangle.Points[3].y := point3.y;
        triangle.Points[3].z := z;

        shape.Triangles.Add(triangle);
      end;
    end;
  end;
end;

procedure CreatePolygonExtrusion(shape: TShape; list: TList; steps: integer; depth: double);
var
  i, j: integer;
  z0, z1, zinc: double;
  point, point2: TXYPoint;
  triangle: TTriangle;

begin
  // Create the top surface
  CreatePolygonShape(shape, list, 0, False);

  // Walk the steps
  zinc := depth / (steps - 1);

  for j := 1 to steps - 1 do
  begin
    z0 := zinc * (j - 1);
    z1 := zinc * j;

    // Create the side
    for i := 0 to list.Count - 1 do
    begin
      point := list[i];

      if i < list.Count - 1 then
        point2 := list[i + 1]
      else
        point2 := list[0];

      triangle := TTriangle.Create;

      triangle.Points[1].x := point.x;
      triangle.Points[1].y := point.y;
      triangle.Points[1].z := z0;

      triangle.Points[2].x := point2.x;
      triangle.Points[2].y := point2.y;
      triangle.Points[2].z := z1;

      triangle.Points[3].x := point2.x;
      triangle.Points[3].y := point2.y;
      triangle.Points[3].z := z0;

      shape.Triangles.Add(triangle);

      triangle := TTriangle.Create;

      triangle.Points[1].x := point.x;
      triangle.Points[1].y := point.y;
      triangle.Points[1].z := z0;

      triangle.Points[2].x := point.x;
      triangle.Points[2].y := point.y;
      triangle.Points[2].z := z1;

      triangle.Points[3].x := point2.x;
      triangle.Points[3].y := point2.y;
      triangle.Points[3].z := z1;

      shape.Triangles.Add(triangle);
    end;

  end;

  // Create the bottom surface
  CreatePolygonShape(shape, list, depth, True);
end;

end.
