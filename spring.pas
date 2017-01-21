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

unit spring;

interface

uses
  Vector, Texture, Scene;

type
  TSpring = class(TShape)
  public
    Angle, Height, Rise, Radius: double;
    constructor Create; override;
    function GetID: TShapeID; override;
  end;

  procedure CreateSpring(shape: TShape; Angle, Height, Rise, Radius: double);

implementation

constructor TSpring.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  Angle := 0.0;
  Height := 10.0;
  Rise := 1.0;
  Radius := 0.3;
  CreateSpring(Self, Angle, Height, Rise, Radius);
end;

function TSpring.GetID: TShapeID;
begin
  result := siSpring;
end;

////////////////////////////////////////////////////////////////////////////////

procedure CreateSpring(shape: TShape; Angle, Height, Rise, Radius: double);
begin
end;

end.
