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

unit user;

interface

uses
  System.JSON,
  Winapi.Windows, System.SysUtils, System.Classes, VCL.Forms, Scene;

type
  TUserLike = (utCube, utSphere);

  TUserShape = class(TShape)
  public
    Like: TUserLike;
    User: TStringList;

    constructor Create; override;
    function GetID: TShapeid; override;
    procedure Save(parent: TJSONArray); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Generate(var dest: TextFile); override;
    procedure Details; override;
    procedure Rebuild;
  end;

implementation

uses
  Misc, Sphere, UserDlg, engine;

constructor TUserShape.Create;
begin
  inherited Create;
  Features := Features + StandardFeatures;
  Like := utCube;
  User := TStringList.Create;
end;

function TUserShape.GetID: TShapeID;
begin
  result := siUser;
end;

procedure TUserShape.Save(parent: TJSONArray);
var
  i, n: integer;
  obj: TJSONObject;
  strs: TJSONArray;

begin
  inherited;
  n := User.Count;
  strs := TJSONArray.Create;
  for i := 0 to n - 1 do
    strs.Add(User.Strings[i]);
  obj.AddPair('text', strs);
  parent.Add(obj);
end;

procedure TUserShape.SaveToFile(dest: TStream);
var
  i, n: integer;

begin
  inherited SaveToFile(dest);
  n := User.Count;
  dest.WriteBuffer(n, sizeof(n));
  for i := 0 to n - 1 do
    SaveStringToStream(User.Strings[i], dest);
end;

procedure TUserShape.LoadFromFile(source: TStream);
var
  i, n: integer;
  s: AnsiString;

begin
  inherited LoadFromFile(source);
  source.ReadBuffer(n, sizeof(n));
  for i := 0 to n - 1 do
  begin
    LoadStringFromStream(s, source);
    User.Add(s);
  end;
end;

procedure TUserShape.Generate(var dest: TextFile);
var
  i: integer;
  s: string;

begin
  for i := 0 to User.Count - 1 do
  begin
    s := UpperCase(Trim(User.Strings[i]));
    if s <> '#PROP' then
      WriteLn(dest, User.Strings[i])
    else
      inherited Generate(dest);
  end;
  WriteLn(dest);
end;

procedure TUserShape.Rebuild;
begin
  Triangles.Clear;
  case Like of
    utCube:   CreateCube(Self, 0.0, 0.0, 0.0);
    utSphere: CreateSphere(Self, 0.0, 0.0, 0.0);
  end;
end;

procedure TUserShape.Details;
var
  dlg: TUserDialog;

begin
  dlg := TUserDialog.Create(Application);

  dlg.Memo.Lines.AddStrings(User);

  if dlg.ShowModal = idOK then
  begin
    User.Clear;
    User.AddStrings(dlg.Memo.Lines);
  end;

  dlg.Free;
end;

end.
