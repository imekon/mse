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

unit browser;

interface

uses
  System.Contnrs,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, ImgList, System.ImageList;

type
  TObjectBrowser = class(TForm)
    TreeView: TTreeView;
    ButtonPanel: TPanel;
    ImageList: TImageList;
    SetCameraBtn: TSpeedButton;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure CloseBtnClick(Sender: TObject);
    procedure SetCameraBtnClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DisplayObjects;
  end;

var
  ObjectBrowser: TObjectBrowser;

implementation

uses main, Scene;

{$R *.DFM}

procedure TObjectBrowser.DisplayObjects;
var
  i: integer;
  shape: TShape;

begin
  TreeView.Items.Clear;
  with MainForm.SceneManager do
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;
      shape.BuildTree(TreeView, nil);
    end;
end;

procedure TObjectBrowser.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  shape: TShape;

begin
  with TreeView do
    if Selected <> nil then
    begin
      shape := TShape(Selected.Data);
      SetCameraBtn.Enabled := shape is TCamera;
    end
    else
    begin
      SetCameraBtn.Enabled := False;
    end;
end;

procedure TObjectBrowser.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TObjectBrowser.SetCameraBtnClick(Sender: TObject);
var
  camera: TCamera;

begin
  with TreeView do
    if Selected <> nil then
    begin
      camera := TCamera(Selected.Data);
      if camera is TCamera then
      begin
        MainForm.SceneManager.SetCamera(camera);
        if MainForm.SceneManager.GetView = vwCamera then
          MainForm.SceneManager.Make;
      end;
    end;
end;

procedure TObjectBrowser.TreeViewClick(Sender: TObject);
var
  shape: TShape;

begin
  with TreeView do
    if Selected <> nil then
    begin
      shape := TShape(Selected.Data);
      MainForm.SceneManager.SetCurrent(shape);
      MainForm.SceneManager.Make;
      MainForm.MainPaintBox.Refresh;
    end;
end;

end.
