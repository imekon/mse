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

unit JSONHelper;

interface

uses
  System.SysUtils, System.JSON;

type
  TJSONHelper = class helper for TJSONObject
    procedure AddPair(const name: string; value: integer); overload;
    procedure AddPair(const name: string; value: single); overload;

    function GetInteger(const name: string): integer;
    function GetSingle(const name: string): single;
    function GetDouble(const name: string): double;
  end;

implementation

{ TJSONHelper }

procedure TJSONHelper.AddPair(const name: string; value: integer);
begin
  Self.AddPair(name, IntToStr(value));
end;

procedure TJSONHelper.AddPair(const name: string; value: single);
begin
  Self.AddPair(name, FloatToStr(value));
end;

function TJSONHelper.GetDouble(const name: string): double;
begin
  result := StrToFloat(Self.GetValue(name).Value);
end;

function TJSONHelper.GetInteger(const name: string): integer;
begin
  result := StrToInt(Self.GetValue(name).Value);
end;

function TJSONHelper.GetSingle(const name: string): single;
begin
  result := StrToFloat(Self.GetValue(name).Value);
end;

end.
