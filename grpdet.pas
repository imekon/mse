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

unit grpdet;

interface

uses
  System.Types, System.UITypes, System.Contnrs,
  Windows, SysUtils, Classes, Graphics, Forms, Dialogs, Controls, StdCtrls,
  Buttons, Group;

type
  TGroupDetailsDialog = class(TForm)
    OKBtn: TButton;
    SrcList: TListBox;
    DstList: TListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    Label1: TLabel;
    GroupType: TComboBox;
    FirstBtn: TSpeedButton;
    procedure SetButtons;
    procedure FormCreate(Sender: TObject);
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure FirstBtnClick(Sender: TObject);
  private
    { Private declarations }
    Group: TGroupShape;

    procedure RemoveSelected(list: TCustomListBox);
  public
    { Public declarations }
    procedure SetObject(AGroup: TGroupShape);
  end;

implementation

uses main, scene;

{$R *.DFM}

procedure TGroupDetailsDialog.SetObject(AGroup: TGroupShape);
var
  i: integer;
  shape: TShape;

begin
  Group := AGroup;

  if Group <> nil then
  begin
    with Group do
      for i := 0 to Shapes.Count - 1 do
      begin
        shape := Shapes[i] as TShape;
        DstList.Items.AddObject(shape.Name, shape);
      end;

    case Group.GroupType of
      gtUnion:        GroupType.ItemIndex := 0;
      gtMerge:        GroupType.ItemIndex := 1;
      gtIntersection: GroupType.ItemIndex := 2;
      gtDifference:   GroupType.ItemIndex := 3;
      gtBlob:         GroupType.ItemIndex := 4;
    end;
  end;

  with TSceneManager.SceneManager do
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      if shape <> Group then
        SrcList.Items.AddObject(shape.Name, shape);
    end;

  SetButtons;
end;

procedure TGroupDetailsDialog.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;

begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
end;

procedure TGroupDetailsDialog.FormCreate(Sender: TObject);
begin
  Group := nil;
end;

procedure TGroupDetailsDialog.RemoveSelected(list: TCustomListBox);
var
  move: boolean;
  i: integer;

begin
  move := True;
  while move do
  begin
    move := False;
    for i := 0 to list.Items.Count - 1 do
      if list.Selected[i] then
      begin
        list.Items.Delete(i);
        move := True;
        break;
      end;
  end;
end;

procedure TGroupDetailsDialog.IncludeBtnClick(Sender: TObject);
var
  i: integer;
  shape: TShape;

begin
  for i := 0 to SrcList.Items.Count - 1 do
  begin
    if SrcList.Selected[i] then
    begin
      // Get the shape selected
      shape := SrcList.Items.Objects[i] as TShape;

      // Remove the shape from the main list
      TSceneManager.SceneManager.Shapes.Extract(shape);

      // Add shape to group
      Group.AddShape(shape);

      // Add to list
      DstList.Items.AddObject(SrcList.Items[i], shape);
    end;
  end;

  RemoveSelected(SrcList);

  with TSceneManager do
  begin
    SceneManager.SetModified;
    SceneManager.Make;
    MainForm.Refresh;
  end;
end;

procedure TGroupDetailsDialog.ExcludeBtnClick(Sender: TObject);
var
  i: integer;
  shape: TShape;

begin
  if (DstList.Items.Count - DstList.SelCount) > 0 then
  begin
    for i := 0 to DstList.Items.Count - 1 do
    begin
      if DstList.Selected[i] then
      begin
        // Get the shape selected
        shape := DstList.Items.Objects[i] as TShape;

        // Remove the shape from the main list
        Group.RemoveShape(shape);

        // Add shape to group
        TSceneManager.SceneManager.Shapes.Add(shape);

        // Add to list
        SrcList.Items.AddObject(DstList.Items[i], shape);
      end;
    end;

    RemoveSelected(DstList);

    with TSceneManager do
    begin
      SceneManager.SetModified;
      SceneManager.Make;
      MainForm.Refresh;
    end;
  end
  else
    MessageDlg('Group object must have at least one object', mtError,
      [mbOK], 0);
end;

procedure TGroupDetailsDialog.FirstBtnClick(Sender: TObject);
var
  shape: TShape;

begin
  if DstList.SelCount = 1 then
  begin
    shape := DstList.Items.Objects[DstList.ItemIndex] as TShape;
    DstList.Items.Exchange(0, DstList.ItemIndex);
    Group.MakeFirst(shape);
  end
  else
    MessageDlg('Only one object must be selected', mtError, [mbOK], 0);
end;

end.
