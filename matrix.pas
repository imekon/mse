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

unit matrix;

interface

type
    TMatrix = class
    private
        FMatrix: array [0..3, 0..3] of double;
    protected
        procedure RotateX(angle: double);
        procedure RotateY(angle: double);
        procedure RotateZ(angle: double);
    public
        constructor Create;
        procedure Identity;
        function Get(x, y: integer): double;
        procedure Copy(matrix: TMatrix);
        procedure Translate(x, y, z: double);
        procedure Scale(x, y, z: double);
        procedure Rotate(x, y, z: double);
        procedure Multiply(matrix1, matrix2: TMatrix);
    end;

implementation

uses
    Scene;

constructor TMatrix.Create;
begin
    Identity;
end;

procedure TMatrix.Identity;
var
    x, y: integer;

begin
    for y := 0 to 3 do
        for x := 0 to 3 do
            FMatrix[x, y] := 0.0;

    FMatrix[0, 0] := 1.0;
    FMatrix[1, 1] := 1.0;
    FMatrix[2, 2] := 1.0;
    FMatrix[3, 3] := 1.0;
end;

function TMatrix.Get(x, y: integer): double;
begin
    result := FMatrix[x, y];
end;

procedure TMatrix.Copy(matrix: TMatrix);
var
    x, y: integer;

begin
    for y := 0 to 3 do
        for x := 0 to 3 do
            FMatrix[x, y] := matrix.FMatrix[x, y];
end;

procedure TMatrix.Translate(x, y, z: double);
begin
    Identity;
    FMatrix[3, 0] := -x;
    FMatrix[3, 1] := -y;
    FMatrix[3, 2] := -z;
end;

procedure TMatrix.Scale(x, y, z: double);
begin
    Identity;
    FMatrix[0, 0] := x;
    FMatrix[1, 1] := y;
    FMatrix[2, 2] := z;
end;

procedure TMatrix.RotateX(angle: double);
begin
    Identity;
    angle := angle * R2D;
    FMatrix[1, 1] := cos(angle);
    FMatrix[2, 1] := sin(angle);
    FMatrix[1, 2] := -sin(angle);
    FMatrix[2, 2] := cos(angle);
end;

procedure TMatrix.RotateY(angle: double);
begin
    Identity;
    angle := angle * R2D;
    FMatrix[0, 0] := cos(angle);
    FMatrix[2, 0] := -sin(angle);
    FMatrix[0, 2] := sin(angle);
    FMatrix[2, 2] := cos(angle);
end;

procedure TMatrix.RotateZ(angle: double);
begin
    Identity;
    angle := angle * R2D;
    FMatrix[0, 0] := cos(angle);
    FMatrix[1, 0] := sin(angle);
    FMatrix[0, 1] := -sin(angle);
    FMatrix[1, 1] := cos(angle);
end;

procedure TMatrix.Rotate(x, y, z: double);
var
    m1, m2: TMatrix;

begin
    Identity;

    m1 := TMatrix.Create;
    m2 := TMatrix.Create;

    m1.RotateX(x);

    m2.RotateY(y);

    Multiply(m1, m2);

    m1.Copy(Self);

    m2.RotateZ(z);

    Multiply(m1, m2);

    m1.Free;
    m2.Free;
end;

procedure TMatrix.Multiply(matrix1, matrix2: TMatrix);
var
    i, x, y: integer;
    sum: double;

begin
    for y := 0 to 3 do
        for x := 0 to 3 do
        begin
            sum := 0.0;

            for i := 0 to 3 do
                sum := sum + matrix1.FMatrix[x, i] * matrix2.FMatrix[i, y];

            FMatrix[x, y] := sum;
        end;
end;

end.
