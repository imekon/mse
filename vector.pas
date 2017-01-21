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

unit vector;

interface

uses System.JSON, System.Classes;

type
  TVector = class(TObject)
    public
      X, Y, Z: double;
      constructor Create; virtual;
      procedure Copy(original: TVector);
      procedure Save(const name: string; parent: TJSONobject); virtual;
      procedure SaveToFile(dest: TStream); virtual;
      procedure LoadFromFile(source: TStream); virtual;
      function Magnitude: double;
      procedure Normalize;
      function Equal(xx, yy, zz: double): boolean;
      procedure Add(v: TVector);
    end;

  procedure CalculateNormal(n, v1, v2, v3: TVector);

  procedure SetVector(v: TVector; x, y, z: double);
  function Dot(q1, q2: TVector): double;
  procedure Cross(res, q1, q2: TVector);

implementation

uses misc;

////////////////////////////////////////////////////////////////////////////////
// VECTOR

constructor TVector.Create;
begin
  X := 0.0;
  Y := 0.0;
  Z := 0.0;
end;

procedure TVector.Copy(original: TVector);
begin
  X := original.X;
  Y := original.Y;
  Z := original.Z;
end;

procedure TVector.Save(const name: string; parent: TJSONobject);
var
  obj: TJSONobject;

begin
  obj := TJSONobject.Create;
  obj.AddPair('x', TJSONNumber.Create(x));
  obj.AddPair('y', TJSONNumber.Create(y));
  obj.AddPair('z', TJSONNumber.Create(z));
  parent.AddPair(name, obj);
end;

procedure TVector.SaveToFile(dest: TStream);
begin
  dest.WriteBuffer(x, sizeof(x));
  dest.WriteBuffer(y, sizeof(y));
  dest.WriteBuffer(z, sizeof(z));
end;

procedure TVector.LoadFromFile(source: TStream);
begin
  source.ReadBuffer(x, sizeof(x));
  source.ReadBuffer(y, sizeof(y));
  source.ReadBuffer(z, sizeof(z));
end;

procedure TVector.Add(v: TVector);
begin
  x := x + v.x;
  y := y + v.y;
  z := z + v.z;
end;

procedure CalculateNormal(n, v1, v2, v3: TVector);
var
  length: double;
  a, b: TVector;

begin
  a := TVector.Create;
  b := TVector.Create;

  // Form two vectors from the points
  a.x := v2.x - v1.x;
  a.y := v2.y - v1.y;
  a.z := v2.z - v1.z;

  b.x := v3.x - v1.x;
  b.y := v3.y - v1.y;
  b.z := v3.z - v1.z;

  // Calculate the cross product of the two vectors
  Cross(n, a, b);
  //n.x := a.y * b.z - a.z * b.y;
  //n.y := a.z * b.x - a.x * b.z;
  //n.z := a.x * b.y - a.y * b.x;

  // Normalize the vector
  length := sqrt(sqr(n.x) + sqr(n.y) + sqr(n.y));

  if length > 0.001 then
  begin
    n.x := n.x / length;
    n.y := n.y / length;
    n.z := n.z / length;
  end;

  a.Free;
  b.Free;
end;

function TVector.Magnitude: double;
begin
  result := sqrt(sqr(x) + sqr(y) + sqr(z));
end;

procedure TVector.Normalize;
var
  denom: double;

begin
  denom := Magnitude;
  if denom > 0.001 then
  begin
    x := x / denom;
    y := y / denom;
    z := z / denom;
  end;
end;

function TVector.Equal(xx, yy, zz: double): boolean;
begin
  if Different(x, xx) or Different(y, yy) or Different(z, zz) then
    result := false
  else
    result := true;
end;

procedure SetVector(v: TVector; x, y, z: double);
begin
  v.X := x;
  v.Y := y;
  v.Z := z;
end;

function Dot(q1, q2: TVector): double;
begin
  result := q1.x * q2.x + q1.y * q2.y + q1.z * q2.z;
end;

procedure Cross(res, q1, q2: TVector);
begin
  res.x := q1.y * q2.z - q1.z * q2.y;
  res.y := q1.z * q2.x - q1.x * q2.z;
  res.z := q1.x * q2.y - q1.y * q2.x;
end;

end.
