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

unit misc;

interface

uses
  Windows, Classes, Graphics, JPEG, ShellAPI, Registry;

  function WinExecAndWait32(const FileName: String; Visibility : integer): cardinal;
  procedure WinExec32(const FileName: String; Visibility : integer);
  procedure SaveStringToStream(const s: AnsiString; dest: TStream);
  procedure LoadStringFromStream(var s: AnsiString; source: TStream);
  function Minimum(a, b: integer): integer;
  function Maximum(a, b: integer): integer;
  procedure DrawRectangle(canvas: TCanvas; rect: TRect);
  function Different(a, b: double): boolean;
  function NonZero(x, y, z: double): boolean;
  function NonUnity(x, y, z: double): boolean;
  procedure ConvertBitmapToJPEG(const Name: string);
  function GotoURL(const url: string): boolean;
  function GetModelDirectory: string;
  function GetTexturesDirectory: string;

implementation

uses
  Main;

procedure DrawRectangle(canvas: TCanvas; rect: TRect);
begin
  with canvas do
  begin
    MoveTo(rect.left, rect.top);
    LineTo(rect.right, rect.top);
    LineTo(rect.right, rect.bottom);
    LineTo(rect.left, rect.bottom);
    LineTo(rect.left, rect.top);
  end;
end;

function WinExecAndWait32(const FileName: String; Visibility : integer): cardinal;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;

begin
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    PChar(FileName),               { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then
    Result := $FFFFFFF             { pointer to PROCESS_INF }
  else
  begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
  end;
end;

procedure WinExec32(const FileName: String; Visibility : integer);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;

begin
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if CreateProcess(nil,
    PChar(FileName),               { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then
    WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
end;

procedure SaveStringToStream(const s: AnsiString; dest: TStream);
var
  ch: AnsiChar;
  i, n: integer;

begin
  n := Length(s);

  dest.WriteBuffer(n, sizeof(n));

  for i := 1 to n do
  begin
    ch := s[i];
    dest.WriteBuffer(ch, sizeof(ch));
  end;
end;

procedure LoadStringFromStream(var s: AnsiString; source: TStream);
var
  ch: AnsiChar;
  i, n: integer;

begin
  source.ReadBuffer(n, sizeof(n));

  s := '';

  for i := 1 to n do
  begin
    source.ReadBuffer(ch, sizeof(ch));
    s := s + ch;
  end;
end;

function Minimum(a, b: integer): integer;
begin
  if a < b then
    result := a
  else
    result := b;
end;

function Maximum(a, b: integer): integer;
begin
  if a > b then
    result := a
  else
    result := b;
end;

function Different(a, b: double): boolean;
begin
  result := (abs(a - b) > 0.001);
end;

function NonZero(x, y, z: double): boolean;
begin
  result := (abs(x) > 0.001) or (abs(y) > 0.001) or (abs(z) > 0.001);
end;

function NonUnity(x, y, z: double): boolean;
begin
  result := (abs(x - 1) > 0.001) or (abs(y - 1) > 0.001) or (abs(z - 1) > 0.001);
end;

procedure ConvertBitmapToJPEG(const Name: string);
var
  bitmap: TBitmap;
  jpg: TJPEGImage;

begin
  bitmap := TBitmap.Create;
  jpg := TJPEGImage.Create;

  try
    bitmap.LoadFromFile(Name + '.bmp');
    jpg.Assign(bitmap);
    jpg.SaveToFile(Name + '.jpg');
  finally
    bitmap.Free;
    jpg.Free;
  end;
end;

function GotoURL(const url: string): boolean;
begin
  ShellExecute(0, 'open', PChar(url), nil, nil, SW_SHOW);

  result := true;
end;

function GetModelDirectory: string;
var
  reg: TRegistry;
  buffer: array [0..MAX_PATH] of char;

begin
  result := '';

  reg := TRegistry.Create;

  reg.RootKey := HKEY_LOCAL_MACHINE;

  GetCurrentDirectory(MAX_PATH, buffer);

  if reg.OpenKey(ModelKey, false) then
  begin
    if reg.ValueExists('Path') then
      result := reg.ReadString('Path')
    else
      result := buffer;

    reg.CloseKey;
  end
  else
    result := buffer;

  reg.Free;
end;

function GetTexturesDirectory: string;
begin
  result := GetModelDirectory + '\textures';
end;

end.
