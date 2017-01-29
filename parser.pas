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

unit parser;

interface

uses
  SysUtils;

type
  TParseFile = class
  private
    FFile: TextFile;
    FLine: string;

    function GetLine: boolean;
    procedure EatComments;
  public
    constructor Create(const name: string);
    destructor Destroy; override;
    function Eof: boolean;
    procedure Parse(const sep: string; var symbol: string); overload;
    procedure Parse(const sep: string; var value: integer); overload;
    procedure Parse(const sep: string; var value: double); overload;
  end;

implementation

uses tracdbg;

constructor TParseFile.Create(const name: string);
begin
  AssignFile(FFile, name);
  Reset(FFile);
end;

destructor TParseFile.Destroy;
begin
  CloseFile(FFile);

  inherited;
end;

function TParseFile.Eof: boolean;
begin
  EatComments;

  result := System.Eof(FFile);
end;

function TParseFile.GetLine: boolean;
begin
  if not System.Eof(FFile) then
  begin
    if Length(FLine) = 0 then
    begin
      ReadLn(FFile, FLine);
      FLine := Trim(FLine);
    end;

    result := true;
  end
  else
    result := false;
end;

procedure TParseFile.EatComments;
begin
  if GetLine then
    while (Length(FLine) > 0) and (FLine[1] = ';') do
    begin
      FLine := '';
      GetLine;
    end;
end;

procedure TParseFile.Parse(const sep: string; var symbol: string);
var
  i: integer;

begin
  EatComments;

  i := Pos(sep, FLine);

  if i > 0 then
  begin
    symbol := Copy(FLine, 1, i - 1);
    FLine := Trim(Copy(FLine, i + 1, 255));
  end
  else
  begin
    symbol := FLine;
    FLine := '';
  end;

  Trace('Symbol: %s', [symbol]);
end;

procedure TParseFile.Parse(const sep: string; var value: integer);
var
  symbol: string;

begin
  Parse(sep, symbol);

  value := StrToInt(symbol);
end;

procedure TParseFile.Parse(const sep: string; var value: double);
var
  symbol: string;

begin
  Parse(sep, symbol);

  value := StrToFloat(symbol);
end;

end.
