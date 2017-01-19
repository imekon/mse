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

unit quat;

interface

uses
  Classes, vector;

type
  TQuaternion = class(TVector)
  public
    RealPart: double;

    constructor Create; override;
    procedure BuildRotate(axis: TVector; cos_angle: double);
  end;

  procedure QuaternionMultiply(res, q1, q2: TQuaternion);

implementation

uses
  Math;

constructor TQuaternion.Create;
var
  a: TVector;

begin
  inherited Create;

  a := TVector.Create;

  a.x := 0;
  a.y := 1;
  a.z := 0;

  BuildRotate(a, 0);

  a.Free;
end;

procedure TQuaternion.BuildRotate(axis: TVector; cos_angle: double);
var
  sin_half_angle, cos_half_angle, angle: double;

begin
  if cos_angle > 1.0 then cos_angle := 1.0;
  if cos_angle < -1.0 then cos_angle := -1.0;
  angle := arccos(cos_angle);
  sin_half_angle := sin(angle / 2.0);
  cos_half_angle := cos(angle / 2.0);
  x := axis.x * sin_half_angle;
  y := axis.y * sin_half_angle;
  z := axis.z * sin_half_angle;
  RealPart := cos_half_angle;
end;

procedure QuaternionMultiply(res, q1, q2: TQuaternion);
var
  v: TVector;

begin
  v := TVector.Create;

  res.RealPart := q1.RealPart * q2.RealPart - Dot(q1, q2);
  
  Cross(res, q1, q2);

  v.x := q1.x * q2.RealPart;
  v.y := q1.y * q2.RealPart;
  v.z := q1.z * q2.RealPart;

  res.Add(v);

  v.x := q2.x * q1.RealPart;
  v.y := q2.y * q1.RealPart;
  v.z := q2.z * q1.RealPart;

  res.Add(v);

  v.Free;
end;

end.
