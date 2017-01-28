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

unit gallery;

interface

uses
  System.Contnrs, System.Types,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ImgList, System.ImageList;

type
  TGalleryDialog = class(TForm)
    CloseBtn: TButton;
    ListView: TListView;
    InsertBtn: TButton;
    CreateBtn: TButton;
    ImageList: TImageList;
    RemoveBtn: TButton;
    EditBtn: TButton;
    RenameBtn: TButton;
    procedure CreateBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure RenameBtnClick(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateGallery;
  end;

var
  GalleryDialog: TGalleryDialog;

implementation

uses main, Scene, cregal, group;

{$R *.DFM}

procedure TGalleryDialog.UpdateGallery;
var
  i: integer;
  item: TListItem;
  shape: TShape;

begin
  for i := 0 to MainForm.ObjectGallery.Count - 1 do
  begin
    item := ListView.Items.Add;
    shape := MainForm.ObjectGallery[i];
    item.Caption := shape.Name;
    item.Data := shape;
  end;
end;

procedure TGalleryDialog.CreateBtnClick(Sender: TObject);
var
  item: TListItem;
  shape: TShape;

begin
  shape := MainForm.CreateGallery;
  if shape <> nil then
  begin
    item := ListView.Items.Add;
    item.Caption := shape.Name;
    item.Data := shape;
  end;
end;

procedure TGalleryDialog.RemoveBtnClick(Sender: TObject);
var
  shape: TShape;

begin
  with ListView do
    if Selected <> nil then
    begin
      shape := TShape(Selected.Data);
      MainForm.ObjectGallery.Remove(shape);
      shape.Free;
      Selected.Delete;
    end;
end;

procedure TGalleryDialog.RenameBtnClick(Sender: TObject);
var
  shape: TShape;
  dlg: TGalleryDetailsDialog;

begin
  with ListView do
    if Selected <> nil then
    begin
      dlg := TGalleryDetailsDialog.Create(Application);
      dlg.Name.Text := Selected.Caption;
      if dlg.ShowModal = idOK then
      begin
        Selected.Caption := dlg.Name.Text;
        shape := TShape(Selected.Data);
        shape.Name := dlg.Name.Text;
      end;
      dlg.Free;
    end;
end;

procedure TGalleryDialog.InsertBtnClick(Sender: TObject);
var
  template: TGroupShape;
  gallery: TGalleryShape;

begin
  with ListView do
    if Selected <> nil then
    begin
      template := TGroupShape(Selected.Data);

      gallery := TGalleryShape.Create;
      gallery.Name := template.Name + IntToStr(MainForm.SceneManager.Shapes.Count);
      gallery.BasedOn := template;
      gallery.Build;
      with MainForm do
      begin
        SceneManager.Shapes.Add(gallery);
        gallery.Make(SceneManager, gallery.Triangles);
        SceneManager.SetModified;
        MainPaintBox.Refresh;
      end;
    end;
end;

procedure TGalleryDialog.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TGalleryDialog.ListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ListView.BeginDrag(False);
end;

procedure TGalleryDialog.ListViewEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  template: TGroupShape;
  gallery: TGalleryShape;

begin
  if Target = MainForm.MainPaintBox then
  begin
    template := TGroupShape(ListView.Selected.Data);

    gallery := TGalleryShape.Create;
    gallery.Name := template.Name + IntToStr(MainForm.SceneManager.Shapes.Count);
    gallery.BasedOn := template;
    gallery.Build;
    with MainForm do
    begin
      SceneManager.Shapes.Add(gallery);
      gallery.Make(SceneManager, gallery.Triangles);
      SceneManager.SetModified;
      MainPaintBox.Refresh;
    end;
  end;
end;

end.
