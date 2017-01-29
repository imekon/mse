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

unit Solid;

interface

uses
  System.JSON,
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Engine, Vector, Scene;

type
  TSolidPoint = class(TObject)
  public
    x, y: double;
    Selected: boolean;
    constructor Create(xx, yy: double);
  end;

  TSolid = class(TShape)
  public
    Points: TList;
    Open: boolean;
    UseSOR: boolean;
    Sturm: boolean;
    Strength: double;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    function CanBlob: boolean;
    procedure Save(parent: TJSONArray); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure GenerateVRML(var dest: TextFile); override;
    procedure GenerateBlob(var dest: TextFile); override;
    procedure Details(context: IDrawingContext); override;
    procedure Rebuild;
    procedure CreateCone;
    procedure CreateCylinder;
    procedure CreateSolid;
  end;

  TLatheType = (ltLinear, ltQuadratic, ltCubic);

  TLathe = class(TShape)
  public
    Points: TList;
    LatheType: TLatheType;
    Sturm: boolean;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure Details(context: IDrawingContext); override;
    procedure CreateLathe;
    procedure Rebuild;
  end;

const
  ConeSolid: array [1..2] of TXY = ((x: 0; y: 1), (x: 1; y: -1));
  CylinderSolid: array [1..2] of TXY = ((x: 1; y: 1), (x: 1; y: -1));

implementation

uses
  Sphere, SolidEdit, Lathedit;

////////////////////////////////////////////////////////////////////////////////
// SOLIDPOINT

constructor TSolidPoint.Create(xx, yy: double);
begin
  x := xx;
  y := yy;
  Selected := False;
end;

////////////////////////////////////////////////////////////////////////////////
// SOLID

constructor TSolid.Create;
begin
  inherited Create;
  Features := Features + StandardBlobFeatures;
  Open := False;
  UseSOR := False;
  Strength := 1.0;
  Points := TList.Create;
end;

destructor TSolid.Destroy;
var
  i: integer;
  Pt: TSolidPoint;

begin
  for i := 0 to Points.Count - 1 do
  begin
    Pt := Points[i];
    Pt.Free;
  end;

  Points.Free;

  inherited Destroy;
end;

function TSolid.GetID: TShapeID;
begin
  result := siSolid;
end;

function TSolid.CanBlob: boolean;
var
  p1, p2: TSolidPoint;

begin
  result := False;

  // Can only blob a cylinder (two points)...
  if Points.Count = 2 then
  begin
    p1 := Points[0];
    p2 := Points[1];

    // ...and same sized ends
    if abs(p1.x - p2.x) < 0.001 then
      result := True;
  end
end;

procedure TSolid.Save(parent: TJSONArray);
var
  i, n: integer;
  point: TSolidPoint;
  obj, pointObj: TJSONObject;
  pointsArray: TJSONArray;

begin
  inherited;
  obj := TJSONObject.Create;
  obj.AddPair('open', TJSONBool.Create(Open));
  obj.AddPair('usesor', TJSONBool.Create(UseSOR));
  obj.AddPair('sturm', TJSONBool.Create(Sturm));
  obj.AddPair('strength', TJSONNumber.Create(Strength));
  n := Points.Count;
  pointsArray := TJSONArray.Create;
  for i := 0 to n - 1 do
  begin
    point := Points[i];
    pointObj := TJSONObject.Create;
    pointObj.AddPair('x', TJSONNumber.Create(point.x));
    pointObj.AddPair('y', TJSONNumber.Create(point.y));
    pointsArray.Add(pointObj);
  end;
  obj.AddPair('points', pointsArray);
  parent.Add(obj);
end;

procedure TSolid.SaveToFile(dest: TStream);
var
  i: integer;
  point: TSolidPoint;

begin
  inherited SaveToFile(dest);

  // Save open flag
  dest.WriteBuffer(Open, sizeof(Open));

  // Save SOR flag
  dest.WriteBuffer(UseSOR, sizeof(UseSOR));

  // Save Sturm flag
  dest.WriteBuffer(Sturm, sizeof(Sturm));

  // Save strength
  dest.WriteBuffer(Strength, sizeof(Strength));

  { save the number of points }
  i := Points.Count;
  dest.WriteBuffer(i, sizeof(i));

  { save each point }
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    dest.WriteBuffer(point.x, sizeof(point.x));
    dest.WriteBuffer(point.y, sizeof(point.y));
  end;
end;

procedure TSolid.LoadFromFile(source: TStream);
var
  i, count: integer;
  point: TSolidPoint;
  x, y: double;

begin
  inherited LoadFromFile(source);

  if TSceneManager.SceneManager.FileVersion > 7 then
  begin
    source.ReadBuffer(Open, sizeof(Open));
    source.ReadBuffer(UseSOR, sizeof(UseSOR));
    source.ReadBuffer(Sturm, sizeof(Sturm));
  end;

  // Read strength
  source.ReadBuffer(Strength, sizeof(Strength));

  { read the number of points }
  source.ReadBuffer(count, sizeof(count));

  { read the points }
  for i := 0 to count - 1 do
  begin
    source.ReadBuffer(x, sizeof(x));
    source.ReadBuffer(y, sizeof(y));
    point := TSolidPoint.Create(x, y);
    Points.Add(point);
  end;
  Rebuild;
end;

procedure TSolid.Generate(var dest: TextFile);
var
  multiple: boolean;
  i: integer;
  Pt1, Pt2: TSolidPoint;

begin
  if UseSOR then
  begin
    WriteLn(dest, 'sor');
    WriteLn(dest, '{');
    WriteLn(dest, Format('    %d', [Points.Count + 2]));

    // Write trailing point
    Pt1 := Points[Points.Count - 1];
    WriteLn(dest, Format('    <%6.4f, %6.4f>', [Pt1.x, Pt1.y - 0.1]));

    // Write the actual points (in reverse)
    for i := Points.Count - 1 downto 0 do
    begin
      Pt1 := Points[i];
      WriteLn(dest, Format('    <%6.4f, %6.4f>', [Pt1.x, Pt1.y]));
    end;

    // Write leading point
    Pt1 := Points[0];
    WriteLn(dest, Format('    <%6.4f, %6.4f>', [Pt1.x, Pt1.y + 0.1]));

    if Open then WriteLn(dest, '    open');
    if Sturm then WriteLn(dest, '    sturm');
    inherited Generate(dest);
    WriteLn(dest, '}');
    WriteLn(dest);
  end
  else
  begin
    multiple := Points.Count > 2;

    if multiple then
    begin
      WriteLn(dest, 'union');
      WriteLn(dest, '{');
      WriteLn(dest);
    end;

    for i := 0 to Points.Count - 2 do
    begin
      Pt1 := Points[i];
      Pt2 := Points[i + 1];

      if abs(Pt1.x - Pt2.x) < 0.001 then
      begin
        // Cylinder
        WriteLn(dest, '    cylinder');
        WriteLn(dest, '    {');

        WriteLn(dest, Format('        <0, %6.4f, 0>', [Pt1.y]));
        WriteLn(dest, Format('        <0, %6.4f, 0>', [Pt2.y]));
        WriteLn(dest, Format('        %6.4f', [Pt1.x]));
        if Open then WriteLn(dest, '        open');

        if not multiple then
          inherited Generate(dest);

        WriteLn(dest, '    }');
        WriteLn(dest);
      end
      else
      begin
        if abs(Pt1.y - Pt2.y) > 0.001 then
        begin
          // Cone (not degenerate)
          WriteLn(dest, '    cone');
          WriteLn(dest, '    {');

          WriteLn(dest, Format('        <0, %6.4f, 0>, %6.4f', [Pt1.y, Pt1.x]));
          WriteLn(dest, Format('        <0, %6.4f, 0>, %6.4f', [Pt2.y, Pt2.x]));
          if Open then WriteLn(dest, '        open');

          if not multiple then
            inherited Generate(dest);

          WriteLn(dest, '    }');
          WriteLn(dest);
        end;
      end;
    end;

    if multiple then
    begin
      inherited Generate(dest);
      WriteLn(dest, '}');
      WriteLn(dest);
    end;
  end;
end;

procedure TSolid.GenerateVRML(var dest: TextFile);
var
  i: integer;
  Pt1, Pt2: TSolidPoint;

begin
  WriteLn(dest, '  Separator');
  WriteLn(dest, '  {');
  GenerateVRMLDetails(dest);

  for i := 0 to Points.Count - 2 do
  begin
    Pt1 := Points[i];
    Pt2 := Points[i + 1];

    if abs(Pt1.x - Pt2.x) < 0.001 then
    begin
      WriteLn(dest, '    # Cylinder');
      WriteLn(dest);
      WriteLn(dest, '    Separator');
      WriteLn(dest, '    {');

      WriteLn(dest, '      Translation');
      WriteLn(dest, '      {');
      WriteLn(dest, Format('        translation 0 %6.4f 0', [(Pt2.y + Pt1.y) / 2]));
      WriteLn(dest, '      }');

      WriteLn(dest, '      Cylinder');
      WriteLn(dest, '      {');

      WriteLn(dest, Format('        height %6.4f', [abs(Pt2.y - Pt1.y)]));
      WriteLn(dest, Format('        radius %6.4f', [Pt1.x]));

      WriteLn(dest, '      }');

      WriteLn(dest, '    }');
      WriteLn(dest);
    end
    else
    begin
      if abs(Pt1.y - Pt2.y) > 0.001 then
      begin
        if abs(Pt1.x) < 0.001 then
        begin
          WriteLn(dest, '    # Cone');
          WriteLn(dest);

          WriteLn(dest, '    Separator');
          WriteLn(dest, '    {');

          WriteLn(dest, '      Translation');
          WriteLn(dest, '      {');
          WriteLn(dest, Format('        translation 0 %6.4f 0', [(Pt2.y + Pt1.y) / 2]));
          WriteLn(dest, '      }');

          WriteLn(dest, '      Cone');
          WriteLn(dest, '      {');
          WriteLn(dest, Format('        height %6.4f', [abs(Pt2.y - Pt1.y)]));
          WriteLn(dest, Format('        bottomRadius %6.4f', [Pt2.x]));
          WriteLn(dest, '      }');

          WriteLn(dest, '    }');
        end
        else if abs(Pt2.x) < 0.001 then
        begin
          WriteLn(dest, '    # Cone turned upside down');
          WriteLn(dest);

          WriteLn(dest, '    Separator');
          WriteLn(dest, '    {');

          WriteLn(dest, '      Rotation');
          WriteLn(dest, '      {');
          WriteLn(dest, Format('        rotation 1 0 0 %6.4f', [pi]));
          WriteLn(dest, '      }');
          WriteLn(dest);

          WriteLn(dest, '      Translation');
          WriteLn(dest, '      {');
          WriteLn(dest, Format('        translation 0 %6.4f 0', [-(Pt2.y + Pt1.y) / 2]));
          WriteLn(dest, '      }');

          WriteLn(dest, '      Cone');
          WriteLn(dest, '      {');
          WriteLn(dest, Format('        height %6.4f', [abs(Pt2.y - Pt1.y)]));
          WriteLn(dest, Format('        Radius %6.4f', [Pt1.x]));
          WriteLn(dest, '      }');

          WriteLn(dest, '    }');
        end
        else
        begin
          WriteLn(dest, '    # Cylinder with different radii');
          WriteLn(dest);

          GenerateVRMLTriangles(dest);
        end;
      end;
    end;
  end;

  WriteLn(dest, '  }');
end;

procedure TSolid.GenerateBlob(var dest: TextFile);
var
  Pt1, Pt2: TSolidPoint;

begin
  if CanBlob then
  begin
    Pt1 := Points[0];
    Pt2 := Points[1];

    // Cylinder
    WriteLn(dest, 'cylinder');
    WriteLn(dest, '{');
  	WriteLn(dest, Format('    <0, %6.4f, 0>,', [Pt1.y]));
		WriteLn(dest, Format('    <0, %6.4f, 0>,', [Pt2.y]));
    WriteLn(dest, Format('    %6.4f, %6.4f', [Pt1.x, Strength]));
    inherited Generate(dest);
    WriteLn(dest, '}');
  end;
end;

{$IFDEF USE_OLD_SHAPES}
procedure TSolid.Rebuild;
var
  i, j: integer;
  point1, point2: TSolidPoint;
  a, b, c: TVector;

begin
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  // Clear out any existing triangles
  ClearTriangles;

  for i := 0 to Points.Count - 2 do
  begin
    point1 := Points[i];
    point2 := Points[i + 1];

    if (point1.x < 0.001) and (point2.x > 0.001) then
    begin
      // Cone with apex at first point
      a.x := 0;
      a.y := point1.y;
      a.z := 0;

      b.y := point2.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        b.x := CosPoints[j] * point2.x;
      	b.z := SinPoints[j] * point2.x;

      	if j < SphereSection - 1 then
        begin
          c.x := CosPoints[j + 1] * point2.x;
          c.z := SinPoints[j + 1] * point2.x;
        end
        else
      	begin
      	  c.x := CosPoints[0] * point2.x;
          c.z := SinPoints[0] * point2.x;
        end;

        AddTriangle(a, c, b);
      end;
    end
    else if (point1.x > 0.001) and (point2.x < 0.001) then
    begin
      // Cone with apex at second point
      a.x := 0;
      a.y := point2.y;
      a.z := 0;

      b.y := point1.y;
      c.y := point1.y;

      for j := 0 to SphereSection - 1 do
      begin
        b.x := CosPoints[j] * point1.x;
        b.z := SinPoints[j] * point1.x;

        if j < SphereSection - 1 then
        begin
          c.x := CosPoints[j + 1] * point1.x;
          c.z := SinPoints[j + 1] * point1.x;
        end
        else
        begin
      	  c.x := CosPoints[0] * point1.x;
          c.z := SinPoints[0] * point1.x;
        end;

        AddTriangle(a, b, c);
      end;
    end
    else if (point1.x > 0.001) and (point2.x > 0.001) then
    begin
      // Cylinder
      a.y := point1.y;
      b.y := point2.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        a.x := SinPoints[j] * point1.x;
        a.z := CosPoints[j] * point1.x;

        b.x := SinPoints[j] * point2.x;
        b.z := CosPoints[j] * point2.x;

      	if j < SphereSection - 1 then
        begin
      	  c.x := SinPoints[j + 1] * point2.x;
          c.z := CosPoints[j + 1] * point2.x;
        end
        else
      	begin
          c.x := SinPoints[0] * point2.x;
      	  c.z := CosPoints[0] * point2.x;
        end;

        AddTriangle(a, b, c);
      end;

      a.y := point1.y;
      b.y := point1.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        a.x := SinPoints[j] * point1.x;
        a.z := CosPoints[j] * point1.x;

        if j < SphereSection - 1 then
        begin
          b.x := SinPoints[j + 1] * point1.x;
          b.z := CosPoints[j + 1] * point1.x;

          c.x := SinPoints[j + 1] * point2.x;
          c.z := CosPoints[j + 1] * point2.x;
        end
        else
      	begin
          b.x := SinPoints[0] * point1.x;
          b.z := CosPoints[0] * point1.x;

          c.x := SinPoints[0] * point2.x;
          c.z := CosPoints[0] * point2.x;
        end;

      	AddTriangle(a, c, b);
      end;
    end;
  end;

  a.Free;
  b.Free;
  c.Free;
end;
{$ELSE}
procedure TSolid.Rebuild;
var
  i: integer;
  point: TSolidPoint;
  pts: array of TXY;

begin
  ClearTriangles;

  SetLength(pts, Points.Count);

  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    pts[i].x := point.x;
    pts[i].y := point.y;
  end;

  CreateSolidShape(Self, 0.0, 0.0, 0.0, pts);
end;
{$ENDIF}

procedure TSolid.CreateCone;
begin
  Points.Add(TSolidPoint.Create(0, 1));
  Points.Add(TSolidPoint.Create(1, -1));
  Rebuild;
end;

procedure TSolid.CreateCylinder;
begin
  Points.Add(TSolidPoint.Create(1, 1));
  Points.Add(TSolidPoint.Create(1, -1));
  Rebuild;
end;

procedure TSolid.CreateSolid;
begin
  Points.Add(TSolidPoint.Create(0, 1));
  Points.Add(TSolidPoint.Create(1, 0));
  Points.Add(TSolidPoint.Create(0, -1));
  Rebuild;
end;

procedure TSolid.Details(context: IDrawingContext);
begin
  SolidEditor.SetSolid(Self);
end;

////////////////////////////////////////////////////////////////////////////////
//  TLathe

constructor TLathe.Create;
begin
  inherited Create;
  Points := TList.Create;

  LatheType := ltLinear;
  Sturm := False;
end;

destructor TLathe.Destroy;
var
  i: integer;
  Pt: TSolidPoint;

begin
  for i := 0 to Points.Count - 1 do
  begin
    Pt := Points[i];
    Pt.Free;
  end;

  Points.Free;

  inherited Destroy;
end;

procedure TLathe.CreateLathe;
begin
  inherited;
  Features := Features + StandardFeatures;
  Points.Add(TSolidPoint.Create(1, 0));
  Points.Add(TSolidPoint.Create(2, 0));
  Points.Add(TSolidPoint.Create(2, 2));
  Points.Add(TSolidPoint.Create(1, 2));
  Rebuild;
end;

function TLathe.GetID: TShapeID;
begin
  result := siLathe;
end;

procedure TLathe.SaveToFile(dest: TStream);
var
  i: integer;
  point: TSolidPoint;

begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(LatheType, sizeof(LatheType));
  dest.WriteBuffer(Sturm, sizeof(Sturm));

  { save the number of points }
  i := Points.Count;
  dest.WriteBuffer(i, sizeof(i));

  { save each point }
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    dest.WriteBuffer(point.x, sizeof(point.x));
    dest.WriteBuffer(point.y, sizeof(point.y));
  end;
end;

procedure TLathe.LoadFromFile(source: TStream);
var
  i, count: integer;
  point: TSolidPoint;
  x, y: double;

begin
  inherited LoadFromFile(source);

  source.ReadBuffer(LatheType, sizeof(LatheType));
  source.ReadBuffer(Sturm, sizeof(Sturm));

  { read the number of points }
  source.ReadBuffer(count, sizeof(count));

  { read the points }
  for i := 0 to count - 1 do
  begin
    source.ReadBuffer(x, sizeof(x));
    source.ReadBuffer(y, sizeof(y));
    point := TSolidPoint.Create(x, y);
    Points.Add(point);
  end;
  Rebuild;
end;

procedure TLathe.Generate(var dest: TextFile);
var
  i: integer;
  Pt: TSolidPoint;

begin
  WriteLn(dest, 'lathe');
  WriteLn(dest, '{');
  case LatheType of
    ltLinear:     WriteLn(dest, '    linear_spline');
    ltQuadratic:  WriteLn(dest, '    quadratic_spline');
    ltCubic:      WriteLn(dest, '    cubic_spline');
  end;
  WriteLn(dest, Format('    %d', [Points.Count + 1]));

  // Write the actual points
  for i := 0 to Points.Count - 1 do
  begin
    Pt := Points[i];
    WriteLn(dest, Format('    <%6.4f, %6.4f>', [Pt.x, Pt.y]));
  end;

  // Repeat first point to close the surface
  Pt := Points[0];
  WriteLn(dest, Format('    <%6.4f, %6.4f>', [Pt.x, Pt.y]));

  if Sturm then WriteLn(dest, '    sturm');
  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

{$IFDEF USE_OLD_SHAPES}
procedure TLathe.Rebuild;
var
  i: integer;
  point1, point2: TSolidPoint;
  a, b, c: TVector;

  procedure MakeConeCylinder;
  var
    j: integer;

  begin
    if (point1.x < 0.001) and (point2.x > 0.001) then
    begin
      // Cone with apex at first point
      a.x := 0;
      a.y := point1.y;
      a.z := 0;

      b.y := point2.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        b.x := CosPoints[j] * point2.x;
        b.z := SinPoints[j] * point2.x;

        if j < SphereSection - 1 then
        begin
          c.x := CosPoints[j + 1] * point2.x;
          c.z := SinPoints[j + 1] * point2.x;
        end
        else
        begin
          c.x := CosPoints[0] * point2.x;
          c.z := SinPoints[0] * point2.x;
        end;

        AddTriangle(a, c, b);
      end;
    end
    else if (point1.x > 0.001) and (point2.x < 0.001) then
    begin
      // Cone with apex at second point
      a.x := 0;
      a.y := point2.y;
      a.z := 0;

      b.y := point1.y;
      c.y := point1.y;

      for j := 0 to SphereSection - 1 do
      begin
        b.x := CosPoints[j] * point1.x;
        b.z := SinPoints[j] * point1.x;

        if j < SphereSection - 1 then
        begin
          c.x := CosPoints[j + 1] * point1.x;
          c.z := SinPoints[j + 1] * point1.x;
        end
        else
        begin
          c.x := CosPoints[0] * point1.x;
          c.z := SinPoints[0] * point1.x;
        end;

        AddTriangle(a, b, c);
      end;
    end
    else if (point1.x > 0.001) and (point2.x > 0.001) then
    begin
      // Cylinder
      a.y := point1.y;
      b.y := point2.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        a.x := SinPoints[j] * point1.x;
        a.z := CosPoints[j] * point1.x;

        b.x := SinPoints[j] * point2.x;
        b.z := CosPoints[j] * point2.x;

        if j < SphereSection - 1 then
        begin
          c.x := SinPoints[j + 1] * point2.x;
          c.z := CosPoints[j + 1] * point2.x;
        end
        else
        begin
          c.x := SinPoints[0] * point2.x;
          c.z := CosPoints[0] * point2.x;
        end;

        AddTriangle(a, b, c);
      end;

      a.y := point1.y;
      b.y := point1.y;
      c.y := point2.y;

      for j := 0 to SphereSection - 1 do
      begin
        a.x := SinPoints[j] * point1.x;
        a.z := CosPoints[j] * point1.x;

        if j < SphereSection - 1 then
        begin
          b.x := SinPoints[j + 1] * point1.x;
          b.z := CosPoints[j + 1] * point1.x;

          c.x := SinPoints[j + 1] * point2.x;
          c.z := CosPoints[j + 1] * point2.x;
        end
        else
        begin
          b.x := SinPoints[0] * point1.x;
          b.z := CosPoints[0] * point1.x;

          c.x := SinPoints[0] * point2.x;
          c.z := CosPoints[0] * point2.x;
        end;

        AddTriangle(a, c, b);
      end;
    end;
  end;

begin
  a := TVector.Create;
  b := TVector.Create;
  c := TVector.Create;

  // Clear out any existing triangles
  ClearTriangles;

  for i := 0 to Points.Count - 2 do
  begin
    point2 := Points[i];
    point1 := Points[i + 1];

    MakeConeCylinder;
  end;

  point2 := Points[Points.Count - 1];
  point1 := Points[0];

  MakeConeCylinder;

  a.Free;
  b.Free;
  c.Free;
end;
{$ELSE}
procedure TLathe.Rebuild;
var
  i: integer;
  point: TSolidPoint;
  pts: array of TXY;

begin
  ClearTriangles;

  SetLength(pts, Points.Count);

  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    pts[i].x := point.x;
    pts[i].y := point.y;
  end;

  CreateLatheShape(Self, 0.0, 0.0, 0.0, pts);
end;
{$ENDIF}

procedure TLathe.Details(context: IDrawingContext);
begin
  LatheEditor.SetLathe(Self);
end;

end.
