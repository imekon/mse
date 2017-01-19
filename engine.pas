// Shape Engine

// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// These functions can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)

unit engine;

interface

uses
  scene;

type
  TXY = record
    x, y: double
  end;

const
  ConeSolid: array [1..2] of TXY = ((x: 0; y: 1), (x: 1; y: -1));
  CylinderSolid: array [1..2] of TXY = ((x: 1; y: 1), (x: 1; y: -1));

procedure CreateSolidShape(Shape: TShape; x, y, z: double; Points: array of TXY);
procedure CreateLatheShape(shape: TShape; X, Y, Z: double; Points: array of TXY);
procedure CreateSphere(shape: TShape; x, y, z: double);
procedure CreateDisc(shape: TShape; Hole, Radius, x, y, z: double);
procedure CreateTorus(shape: TShape; Major, Minor, x, y, z: double);
procedure CreateCube(shape: TShape; x, y, z: double);
procedure CreatePlane(shape: TShape; x, y, z, size: double);

implementation

uses vector, misc;

const
  {$IFDEF MSWINDOWS}
  SphereSection = 24;
  {$ENDIF}

  {$IFDEF LINUX}
  SphereSection = 12;
  {$ENDIF}

var
  SinPoints: array [0..SphereSection - 1] of double;
  CosPoints: array [0..SphereSection - 1] of double;

////////////////////////////////////////////////////////////////////////////////
// SphereCreatePoints
// ------------------
// A Sphere point generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// CreateSolidShape
// ----------------
// A Solid of Revolution/Swept Object generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

procedure CreateSolidShape(Shape: TShape; X, Y, Z: double; Points: array of TXY);
var
  i, j: integer;
  a, b, c: TVector;
  xx1, yy1, xx2, yy2: double;

begin
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  try
    for i := Low(Points) to High(Points) - 1 do
    begin
      xx1 := Points[i].x;
      yy1 := Points[i].y;

      xx2 := Points[i + 1].x;
      yy2 := Points[i + 1].y;

      if (xx1 < 0.001) and (xx2 > 0.001) then
      begin
        // Cone with apex at first point
        SetVector(a, x, yy1 + y, z);

        for j := 0 to SphereSection - 1 do
        begin
          SetVector(b, CosPoints[j] * xx2 + x, yy2 + y, SinPoints[j] * xx2 + z);

          if j < SphereSection - 1 then
            SetVector(c, CosPoints[j + 1] * xx2 + x, yy2 + y, SinPoints[j + 1] * xx2 + z)
          else
            SetVector(c, CosPoints[0] * xx2 + x, yy2 + y, SinPoints[0] * xx2 + z);

          Shape.AddTriangle(a, c, b);
        end;
      end
      else if (xx1 > 0.001) and (xx2 < 0.001) then
      begin
        // Cone with apex at second point
        SetVector(a, x, yy2 + y, z);

        for j := 0 to SphereSection - 1 do
        begin
          SetVector(b, CosPoints[j] * xx1 + x, yy1 + y, SinPoints[j] * xx1 + z);

          if j < SphereSection - 1 then
            SetVector(c, CosPoints[j + 1] * xx1 + x, yy1 + y, SinPoints[j + 1] * xx1 + z)
          else
            SetVector(c, CosPoints[0] * xx1 + x, yy1 + y, SinPoints[0] * xx1 + z);

          Shape.AddTriangle(a, b, c);
        end;
      end
      else if (xx1 > 0.001) and (xx2 > 0.001) then
      begin
        // Cylinder
        for j := 0 to SphereSection - 1 do
        begin
          SetVector(a, SinPoints[j] * xx1 + x, yy1 + y, CosPoints[j] * xx1 + z);
          SetVector(b, SinPoints[j] * xx2 + x, yy2 + y, CosPoints[j] * xx2 + z);

          if j < SphereSection - 1 then
            SetVector(c, SinPoints[j + 1] * xx2 + x, yy2 + y, CosPoints[j + 1] * xx2 + z)
          else
            SetVector(c, SinPoints[0] * xx2 + x, yy2 + y, CosPoints[0] * xx2 + z);

          Shape.AddTriangle(a, b, c);
        end;

        for j := 0 to SphereSection - 1 do
        begin
          SetVector(a, SinPoints[j] * xx1 + x, yy1 + y, CosPoints[j] * xx1 + z);

          if j < SphereSection - 1 then
          begin
            SetVector(b, SinPoints[j + 1] * xx1 + x, yy1 + y, CosPoints[j + 1] * xx1 + z);
            SetVector(c, SinPoints[j + 1] * xx2 + x, yy2 + y, CosPoints[j + 1] * xx2 + z);
          end
          else
          begin
            SetVector(b, SinPoints[0] * xx1 + x, yy1 + y, CosPoints[0] * xx1 + z);
            SetVector(c, SinPoints[0] * xx2 + x, yy2 + y, CosPoints[0] * xx2 + z);
          end;

          Shape.AddTriangle(a, c, b);
        end;
      end;
    end;
  finally
    a.Free;
    b.Free;
    c.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// CreateLatheShape
// ----------------
// A Lathe Object generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

procedure CreateLatheShape(shape: TShape; X, Y, Z: double; Points: array of TXY);
var
  i: integer;
  inner: array [1..2] of TXY;

begin
  for i := Low(Points) to High(Points) - 1 do
  begin
    inner[1] := Points[i];
    inner[2] := Points[i + 1];

    CreateSolidShape(shape, X, Y, Z, inner);
  end;

  inner[1] := Points[High(Points)];
  inner[2] := Points[Low(Points)];

  CreateSolidShape(shape, X, Y, Z, inner);
end;

procedure SphereCreatePoints;
var
  i: integer;

begin
  for i := 0 to SphereSection - 1 do
  begin
    SinPoints[i] := sin(i * 360.0 * d2r / SphereSection);
    CosPoints[i] := cos(i * 360.0 * d2r / SphereSection);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// CreateSphere
// ------------
// A Sphere generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

procedure CreateSphere(shape: TShape; x, y, z: double);
var
  i: integer;
  points: array [0..SphereSection - 1] of TXY;

begin
  for i := 0 to SphereSection - 1 do
  begin
    points[i].X := SinPoints[i];
    points[i].Y := CosPoints[i];
  end;

  CreateSolidShape(shape, 0, 0, 0, points);
end;

////////////////////////////////////////////////////////////////////////////////
// CreateDisc
// ----------
// A Disc generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

procedure CreateDisc(shape: TShape; Hole, Radius, x, y, z: double);
var
  i: integer;
  a, b, c: TVector;

begin
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  try
    for i := 0 to SphereSection - 1 do
    begin
      SetVector(a, Hole * CosPoints[i] + x, Hole * SinPoints[i] + y, z);
      SetVector(b, Radius * CosPoints[i] + x, Radius * SinPoints[i] + y, z);

      if i < SphereSection - 1 then
        SetVector(c, Radius * CosPoints[i + 1] + x, Radius * SinPoints[i + 1] + y, z)
      else
        SetVector(c, Radius * CosPoints[0] + x, Radius * SinPoints[0] + y, z);

      shape.AddTriangle(a, b, c);

      SetVector(a, Hole * CosPoints[i] + x, Hole * SinPoints[i] + y, z);

      if i < SphereSection - 1 then
      begin
        SetVector(b, Radius * CosPoints[i + 1] + x, Radius * SinPoints[i + 1] + y, z);
        SetVector(c, Hole * CosPoints[i + 1] + x, Hole * SinPoints[i + 1] + y, z);
      end
      else
      begin
        SetVector(b, Radius * CosPoints[0] + x, Radius * SinPoints[0] + y, z);
        SetVector(c, Hole * CosPoints[0] + x, Hole * SinPoints[0] + y, z);
      end;

      shape.AddTriangle(a, b, c);
    end;
  finally
    a.Free;
    b.Free;
    c.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// CreateTorus
// -----------
// A Torus generator function for Delphi.
// Copyright 2000, Pete Goodwin.  All Rights Reserved.
// This function can be freely used and distributed in commercial and
// private environments, provided this notice is not modified in any way.
////////////////////////////////////////////////////////////////////////////////

procedure CreateTorus(shape: TShape; Major, Minor, x, y, z: double);
var
  i: integer;
  Points: array [0..SphereSection - 1] of TXY;

begin
  // Fill the points with the details
  for i := 0 to SphereSection - 1 do
  begin
    Points[SphereSection - 1 - i].x := CosPoints[i] * Minor + Major;
    Points[SphereSection - 1 - i].y := SinPoints[i] * Minor;
  end;

  CreateLatheShape(shape, X, Y, Z, Points);
end;

procedure CreateCube(shape: TShape; x, y, z: double);
var
  v, a, b, c: TVector;

begin
  v := TVector.Create;
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  { Front face }
  v.z := z + 1;

  v.x := x - 1; v.y := y + 1;
  a.Copy(v);

  v.y := y - 1;
  b.Copy(v);

  v.x := x + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.x := x - 1; v.y := y + 1;
  a.Copy(v);

  v.x := x + 1; v.y := y - 1;
  b.Copy(v);

  v.y := y + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  { Back face }
  v.z := z - 1;

  v.x := x - 1; v.y := y + 1;
  a.Copy(v);

  v.y := y - 1;
  b.Copy(v);

  v.x := x + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.x := x - 1; v.y := y + 1;
  a.Copy(v);

  v.x := x + 1; v.y := y - 1;
  b.Copy(v);

  v.y := y + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Left face }
  v.x := x - 1;

  v.z := z - 1; v.y := y + 1;
  a.Copy(v);

  v.y := y - 1;
  b.Copy(v);

  v.z := z + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.z := z - 1; v.y := y + 1;
  a.Copy(v);

  v.z := z + 1; v.y := y - 1;
  b.Copy(v);

  v.y := y + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  { Right face }
  v.x := x + 1;

  v.z := z - 1; v.y := y + 1;
  a.Copy(v);

  v.y := y - 1;
  b.Copy(v);

  v.z := z + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.z := z - 1; v.y := y + 1;
  a.Copy(v);

  v.z := z + 1; v.y := y - 1;
  b.Copy(v);

  v.y := y + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Top face }
  v.y := y + 1;

  v.x := x - 1; v.z := z + 1;
  a.Copy(v);

  v.z := z - 1;
  b.Copy(v);

  v.x := x + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  v.x := x - 1; v.z := z + 1;
  a.Copy(v);

  v.x := x + 1; v.z := z - 1;
  b.Copy(v);

  v.z := z + 1;
  c.Copy(v);

  shape.AddTriangle(a, c, b);

  { Bottom face }
  v.y := y - 1;

  v.x := x - 1; v.z := z + 1;
  a.Copy(v);

  v.z := z - 1;
  b.Copy(v);

  v.x := x + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.x := x - 1; v.z := z + 1;
  a.Copy(v);

  v.x := x + 1; v.z := z - 1;
  b.Copy(v);

  v.z := z + 1;
  c.Copy(v);

  shape.AddTriangle(a, b, c);

  v.Free;
  a.Free;
  b.Free;
  c.Free;
end;

procedure CreatePlane(shape: TShape; x, y, z, size: double);
const
  sides = 30;

var
  i, j: integer;
  xx, yy: double;

  procedure CreateRect(x0, y0, x1, y1, z: double);
  var
    a, b, c, d: TVector;

  begin
      a := TVector.Create;
      b := TVector.Create;
      c := TVector.Create;
      d := TVector.Create;

      try
        SetVector(a, x0, y0, z);
        SetVector(b, x0, y1, z);
        SetVector(c, x1, y1, z);
        SetVector(d, x1, y0, z);

        shape.AddTriangle(a, b, c);
        shape.AddTriangle(a, c, d);
      finally
        a.Free;
        b.Free;
        c.Free;
        d.Free;
      end;
  end;

begin
  for j := 0 to sides - 1 do
    for i := 0 to sides - 1 do
    begin
      xx := -size + i * 2 * size / sides;
      yy := -size + j * 2 * size / sides;

      CreateRect(xx, yy, xx + 2 * size / sides, yy + 2 * size / sides, z);
    end;
end;

initialization
  SphereCreatePoints;

end.
