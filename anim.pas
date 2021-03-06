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

unit anim;

interface

uses
  Classes, Vector, Scene;

type
  TAnimation = class
  public
    Translate, Scale, Rotate: TVector;
    KeyFrame: integer;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

////////////////////////////////////////////////////////////////////////////////
//  TAnimPoint

constructor TAnimation.Create;
begin
  Translate := TVector.Create;
  Scale := TVector.Create;
  Rotate := TVector.Create;
  KeyFrame := 1;
end;

destructor TAnimation.Destroy;
begin
  Translate.Free;
  Scale.Free;
  Rotate.Free;

  inherited;
end;

end.
