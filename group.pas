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

////////////////////////////////////////////////////////////////////////////////
//  The Group shape
//
//  The group shape is a collection shape, containing other shapes.
//
//  The gallery shape points to a notional group shape in the gallery list
//  and copies the contents to itself (I know, not very efficient, but I need
//  a triangle list somewhere that is unique for each 'instance').

unit group;

interface

uses
  System.Types, System.JSON,
  Winapi.Windows, System.SysUtils, System.Classes, VCL.Graphics, VCL.Forms,
  VCL.Controls, VCL.Menus,
  VCL.StdCtrls, VCL.ComCtrls, VCL.Dialogs, VCL.Buttons, Winapi.Messages,
  Vector, Texture, Scene,
  System.Contnrs;

type
  TGroupShape = class(TShape)
  public
    GroupType: TGroupType;
    Shapes: TObjectList;

    constructor Create; override;
    destructor Destroy; override;
    function GetID: TShapeID; override;
    procedure Make(scene: TSceneManager; theTriangles: TList); override;
    procedure Draw(Scene: TSceneManager; theTriangles: TList; canvas: TCanvas; Mode: TPenMode); override;
    procedure Generate(var dest: TextFile); override;
    procedure AddShape(shape: TShape);
    procedure RemoveShape(shape: TShape);
    procedure Save(parent: TJSONArray); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure SetTexture(ATexture: TTexture); override;
    function GetTriangleCount: integer; override;
    function UsingTexture(text: TTexture): boolean; override;
    procedure Clear;
    procedure Copy(original: TShape); override;
    function BuildTree(tree: TTreeView; node: TTreeNode): TTreeNode; override;
    procedure Details; override;
    procedure MakeFirst(shape: TShape);
  end;

  TGalleryShape = class(TGroupShape)
  public
    BasedOn: TShape;

    constructor Create; override;
    function GetID: TShapeID; override;
    procedure CopyShapes;
    procedure Build;
  end;

implementation

uses
  main, grpedit;

////////////////////////////////////////////////////////////////////////////////
//  TGroupShape

constructor TGroupShape.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  GroupType := gtUnion;
  Shapes := TObjectList.Create;
end;

destructor TGroupShape.Destroy;
begin
  Shapes.Free;

  inherited;
end;

function TGroupShape.GetID: TShapeID;
begin
  result := siGroup;
end;

procedure TGroupShape.Generate(var dest: TextFile);
var
  i: integer;
  shape: TShape;

begin
  case GroupType of
    gtUnion:          WriteLn(dest, 'union');
    gtMerge:          WriteLn(dest, 'merge');
    gtIntersection:   WriteLn(dest, 'intersection');
    gtDifference:     WriteLn(dest, 'difference');
    gtBlob:           WriteLn(dest, 'blob');
  end;

  WriteLn(dest, '{');

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if GroupType = gtBlob then
      shape.GenerateBlob(dest)
    else
      shape.Generate(dest);
  end;

  inherited Generate(dest);

  WriteLn(dest, '}');
  WriteLn(dest);
end;

{*
procedure TGroupShape.GenerateDirectXDetails(D3DRM: IDirect3DRM; MeshFrame: IDirect3DRMFrame);
var
  i: integer;
  shape: TShape;
  ChildFrame: IDirect3DRMFrame;

begin
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;

    D3DRM.CreateFrame(MeshFrame, ChildFrame);

    with shape do
    begin
      GenerateDirectXDetails(D3DRM, ChildFrame);

      GenerateDirectXTransforms(D3DRM, ChildFrame);
    end;
  end;
end;
*}

procedure TGroupShape.Make(scene: TSceneManager; theTriangles: TList);
var
  i: integer;
  shape: TShape;

begin
  inherited Make(scene, theTriangles);

  if theTriangles = Triangles then
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Make(scene, shape.Triangles);
    end
  else
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.Make(scene, shape.GhostTriangles);
    end;
end;

procedure TGroupShape.Clear;
begin
  Shapes.Clear;
end;

procedure TGroupShape.AddShape(shape: TShape);
begin
  shape.Parent := Self;
  shape.States := shape.States - [ssSelected];

  Shapes.Add(shape);

  Make(MainForm.SceneManager, Triangles);
end;

procedure TGroupShape.RemoveShape(shape: TShape);
begin
  shape.Parent := nil;

  Shapes.Extract(shape);

  Make(MainForm.SceneManager, Triangles);
end;

procedure TGroupShape.Save(parent: TJSONArray);
var
  i, n: integer;
  shape: TShape;
  obj: TJSONObject;
  children: TJSONArray;

begin
  inherited;
  obj := TJSONObject.Create;
  children := TJSONArray.Create;
  n := Shapes.Count;
  for i := 0 to n - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.Save(children);
  end;
  obj.AddPair('shapes', children);
  parent.Add(obj);
end;

procedure TGroupShape.SaveToFile(dest: TStream);
var
  i, n: integer;
  shape: TShape;

begin
  inherited SaveToFile(dest);

  n := Shapes.Count;
  dest.WriteBuffer(n, sizeof(n));

  for i := 0 to n - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.SaveToFile(dest);
  end;
end;

procedure TGroupShape.LoadFromFile(source: TStream);
var
  i, n: integer;
  ID: TShapeID;
  Shape: TShape;

begin
  inherited LoadFromFile(source);

  source.ReadBuffer(n, sizeof(n));

  for i := 1 to n do
  begin
    source.ReadBuffer(ID, sizeof(ID));
    shape := TSceneManager.CreateShapeFromID(ID);
    assert(shape <> nil);
    if shape <> nil then
    begin
      shape.LoadFromFile(source);
      shape.Parent := Self;
      Shapes.Add(shape);
    end;
  end;
end;

procedure TGroupShape.Draw(Scene: TSceneManager; theTriangles: TList; canvas: TCanvas; Mode: TPenMode);
var
  i: integer;
  shape: TShape;

begin
  if sfDisplay in Flags then
  begin
    canvas.Pen.Mode := Mode;

    if theTriangles = Triangles then
      for i := 0 to Shapes.Count - 1 do
      begin
        shape := Shapes[i] as TShape;
        shape.Draw(Scene, shape.Triangles, canvas, Mode);
      end
    else
      for i := 0 to Shapes.Count - 1 do
      begin
        shape := Shapes[i] as TShape;
        shape.Draw(Scene, shape.GhostTriangles, canvas, Mode);
      end;

    DrawSelected(Scene, canvas);
  end;
end;

procedure TGroupShape.SetTexture(ATexture: TTexture);
var
  i: integer;
  shape: TShape;

begin
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.SetTexture(ATexture);
  end;
end;

function TGroupShape.GetTriangleCount: integer;
var
  i, n: integer;
  shape: TShape;

begin
  n := 0;

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    n := n + shape.GetTriangleCount;
  end;

  result := n;
end;

function TGroupShape.UsingTexture(text: TTexture): boolean;
var
  i: integer;
  shape: TShape;

begin
  result := False;
  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    if shape.UsingTexture(text) then
    begin
      result := True;
      break;
    end;
  end;
end;

procedure TGroupShape.Copy(original: TShape);
var
  i: integer;
  shape, shape2: TShape;
  group: TGroupShape;

begin
  inherited Copy(original);

  group := original as TGroupShape;

  for i := 0 to group.Shapes.Count - 1 do
  begin
    shape := group.Shapes[i] as TShape;
    shape2 := TSceneManager.CreateShapeFromID(shape.GetID);
    shape2.Copy(shape);
    AddShape(shape2);
  end;
end;

function TGroupShape.BuildTree(tree: TTreeView; node: TTreeNode): TTreeNode;
var
  child: TTreeNode;
  i: integer;
  shape: TShape;

begin
  child := inherited BuildTree(tree, node);

  for i := 0 to Shapes.Count - 1 do
  begin
    shape := Shapes[i] as TShape;
    shape.BuildTree(tree, child);
  end;

  result := child;
end;

{$IFDEF GROUP_DIALOG_EDITOR}
procedure TGroupShape.Details;
var
  dlg: TGroupDetailsDialog;

begin
  dlg := TGroupDetailsDialog.Create(Application);

  dlg.SetObject(Self);

  dlg.ShowModal;

  MainForm.Modify(Self);

  dlg.Free;
end;
{$ENDIF}

procedure TGroupShape.Details;
begin
  GroupEditor.SetGroup(Self);
end;

procedure TGroupShape.MakeFirst(shape: TShape);
var
  i: integer;

begin
  i := Shapes.IndexOf(shape);
  if i <> -1 then
    Shapes.Exchange(0, i);
end;

////////////////////////////////////////////////////////////////////////////////
//  TGalleryShape

constructor TGalleryShape.Create;
begin
  inherited;

  GroupType := gtGallery;

  BasedOn := nil;
end;

function TGalleryShape.GetID: TShapeID;
begin
  result := siGallery;
end;

procedure TGalleryShape.CopyShapes;
var
  i: integer;
  shape, shape2: TShape;
  group: TGroupShape;

begin
  group := BasedOn as TGroupShape;

  for i := 0 to group.Shapes.Count - 1 do
  begin
    shape := group.Shapes[i] as TShape;
    shape2 := TSceneManager.CreateShapeFromID(shape.GetID);
    shape2.Copy(shape);
    AddShape(shape2);
  end;
end;

procedure TGalleryShape.Build;
begin
  Clear;
  CopyShapes;
end;

end.
