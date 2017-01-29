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

unit scripted;

interface

uses
  System.JSON,
  Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics, VCL.Forms,
  VCL.Controls, VCL.Menus,
  VCL.StdCtrls, VCL.Dialogs, VCL.Buttons, Winapi.Messages, Vector, Scene;

type
  // Properties
  TPropertyID = (spInteger, spSingle, spList);

  TScriptProperty = class
  private
    Name: AnsiString;
  public
    constructor Create; virtual;
    function GetID: TPropertyID; virtual; abstract;
    procedure LoadFromStream(stream: TStream); virtual;
    procedure Save(parent: TJSONArray);
    procedure SaveToStream(stream: TStream); virtual;
    procedure LoadValueFromStream(stream: TStream); virtual;
    procedure SaveValueToStream(stream: TStream); virtual;
  end;

  TScriptInteger = class(TScriptProperty)
  private
    Value, Min, Max: integer;
  public
    constructor Create; override;
    function GetID: TPropertyID; override;
    procedure LoadFromStream(stream: TStream); override;
    procedure SaveToStream(stream: TStream); override;
    procedure LoadValueFromStream(stream: TStream); override;
    procedure SaveValueToStream(stream: TStream); override;
  end;

  TScriptSingle = class(TScriptProperty)
  private
    Value, Min, Max: single;
  public
    constructor Create; override;
    function GetID: TPropertyID; override;
    procedure LoadFromStream(stream: TStream); override;
    procedure SaveToStream(stream: TStream); override;
    procedure LoadValueFromStream(stream: TStream); override;
    procedure SaveValueToStream(stream: TStream); override;
  end;

  TScriptList = class(TScriptProperty)
  private
    Value: integer;
    List: TStringList;
  public
    constructor Create; override;
    function GetID: TPropertyID; override;
    destructor Destroy; override;
    procedure LoadFromStream(stream: TStream); override;
    procedure SaveToStream(stream: TStream); override;
    procedure LoadValueFromStream(stream: TStream); override;
    procedure SaveValueToStream(stream: TStream); override;
  end;

  // Object
  TScripted = class(TShape)
  private
    FScriptFile: AnsiString;
    FProperties: TList;
    FLike: TShapeID;
  protected
    procedure SetLike(aLike: TShapeID);
  public
    property Like: TShapeID read FLike write SetLike;
    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure GenerateVRML(var dest: TextFile); override;
    procedure Details(context: IDrawingContext); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
  end;

implementation

uses
  misc, Light, scrdlg;

////////////////////////////////////////////////////////////////////////////////

constructor TScriptProperty.Create;
begin
end;

procedure TScriptProperty.LoadFromStream(stream: TStream);
begin
  LoadStringFromStream(name, stream);
end;

procedure TScriptProperty.Save(parent: TJSONArray);
var
  obj: TJSONObject;
  id: TPropertyID;

begin
  obj := TJSONObject.Create;
  id := GetID;
  obj.AddPair('id', TJSONNumber.Create(ord(id)));
  obj.AddPair('name', Name);
  parent.Add(obj);
end;

procedure TScriptProperty.SaveToStream(stream: TStream);
var
  id: TPropertyID;

begin
  id := GetID;

  stream.Write(id, sizeof(TPropertyID));

  SaveStringToStream(name, stream);
end;

procedure TScriptProperty.LoadValueFromStream(stream: TStream);
begin
  LoadStringFromStream(name, stream);
end;

procedure TScriptProperty.SaveValueToStream(stream: TStream);
var
  id: TPropertyID;

begin
  id := GetID;

  stream.Write(id, sizeof(TPropertyID));

  SaveStringToStream(name, stream);
end;

////////////////////////////////////////////////////////////////////////////////

constructor TScriptInteger.Create;
begin
  inherited;

  Value := 0;
  Min := 0;
  Max := 100;
end;

function TScriptInteger.GetID: TPropertyID;
begin
  result := spInteger;
end;

procedure TScriptInteger.LoadFromStream(stream: TStream);
begin
  inherited;

  stream.Read(Min, sizeof(integer));
  stream.Read(Max, sizeof(integer));
end;

procedure TScriptInteger.SaveToStream(stream: TStream);
begin
  inherited;

  stream.Write(Min, sizeof(integer));
  stream.Write(Max, sizeof(integer));
end;

procedure TScriptInteger.LoadValueFromStream(stream: TStream);
begin
  inherited;

  stream.Read(Value, sizeof(integer));
end;

procedure TScriptInteger.SaveValueToStream(stream: TStream);
begin
  inherited;

  stream.Write(Value, sizeof(integer));
end;

////////////////////////////////////////////////////////////////////////////////

constructor TScriptSingle.Create;
begin
  inherited;

  Value := 0;
  Min := 0;
  Max := 100;
end;

function TScriptSingle.GetID: TPropertyID;
begin
  result := spSingle;
end;

procedure TScriptSingle.LoadFromStream(stream: TStream);
begin
  inherited;

  stream.Read(Min, sizeof(single));
  stream.Read(Max, sizeof(single));
end;

procedure TScriptSingle.SaveToStream(stream: TStream);
begin
  inherited;

  stream.Write(Min, sizeof(single));
  stream.Write(Max, sizeof(single));
end;

procedure TScriptSingle.LoadValueFromStream(stream: TStream);
begin
  inherited;

  stream.Read(Value, sizeof(single));
end;

procedure TScriptSingle.SaveValueToStream(stream: TStream);
begin
  inherited;

  stream.Write(Value, sizeof(single));
end;

////////////////////////////////////////////////////////////////////////////////

constructor TScriptList.Create;
begin
  inherited;

  Value := 0;

  List := TStringList.Create;
end;

function TScriptList.GetID: TPropertyID;
begin
  result := spList;
end;

destructor TScriptList.Destroy;
begin
  List.Free;

  inherited;
end;

procedure TScriptList.LoadFromStream(stream: TStream);
begin
  inherited;

  List.LoadFromStream(stream);
end;

procedure TScriptList.SaveToStream(stream: TStream);
begin
  inherited;

  List.SaveToStream(stream);
end;

procedure TScriptList.LoadValueFromStream(stream: TStream);
begin
  inherited;

  SaveStringToStream(List[Value], stream);
end;

procedure TScriptList.SaveValueToStream(stream: TStream);
var
  val: AnsiString;

begin
  inherited;

  LoadStringFromStream(val, stream);

  Value := List.IndexOf(val);
end;

////////////////////////////////////////////////////////////////////////////////

constructor TScripted.Create;
begin
  inherited Create;

  Features := Features + StandardFeatures;

  FLike := siShape;
  FProperties := TList.Create;
end;

destructor TScripted.Destroy;
begin
  FProperties.Free;

  inherited;
end;

function TScripted.GetID: TShapeID;
begin
  result := siScripted;
end;

procedure TScripted.Generate(var dest: TextFile);
begin
  inherited Generate(dest);
end;

procedure TScripted.GenerateVRML(var dest: TextFile);
begin
end;

procedure TScripted.SetLike(aLike: TShapeID);
begin
  case aLike of
    siLight: CreateLight(Self, 0, 0, 0);
  end;
end;

procedure TScripted.Details(context: IDrawingContext);
var
  dlg: TScriptedDialog;

begin
  dlg := TScriptedDialog.Create(Application);

  dlg.ShowModal;

  dlg.Free;
end;

procedure TScripted.SaveToFile(dest: TStream);
var
  i, n: integer;
  prop: TScriptProperty;

begin
  SaveStringToStream(FScriptFile, dest);

  n := FProperties.Count;

  dest.Write(n, sizeof(integer));

  for i := 0 to n - 1 do
  begin
    prop := FProperties[i];
    prop.SaveValueToStream(dest);
  end;
end;

procedure TScripted.LoadFromFile(source: TStream);
var
  i, n: integer;
  id: TPropertyID;
  prop: TScriptProperty;

begin
  inherited;

  LoadStringFromStream(FScriptFile, source);

  TSceneManager.SceneManager.FindScriptFile(FScriptFile);

  source.Read(n, sizeof(n));

  for i := 1 to n do
  begin
    source.Read(id, sizeof(TScriptProperty));

    case id of
      spInteger:  prop := TScriptInteger.Create;
      spSingle:   prop := TScriptSingle.Create;
      spList:     prop := TScriptList.Create;
    else
      prop := nil;
    end;

    if prop <> nil then
      prop.LoadValueFromStream(source);
  end;
end;

end.
