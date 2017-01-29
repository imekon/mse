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
