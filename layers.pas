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

unit layers;

interface

uses
  System.Contnrs,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, StdCtrls, ExtCtrls;

type
  TLayersForm = class(TForm)
    ListView: TListView;
    PopupMenu: TPopupMenu;
    AddItem: TMenuItem;
    DeleteItem: TMenuItem;
    N1: TMenuItem;
    VisibleItem: TMenuItem;
    SelectableItem: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    CurrentLayer: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure CurrentLayerChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LayersForm: TLayersForm;

implementation

uses Scene, main;

{$R *.DFM}

procedure TLayersForm.FormShow(Sender: TObject);
var
  i: integer;
  layer: TLayer;
  item: TListItem;

begin
  // Clear down the lists
  CurrentLayer.Items.Clear;
  ListView.Items.Clear;

  with MainForm.SceneManager do
  begin
    for i := 0 to Layers.Count - 1 do
    begin
      layer := Layers[i] as TLayer;

      // Add layer to combo
      CurrentLayer.Items.AddObject(layer.Name, layer);

      // Add layer to list view
      item := ListView.Items.Add;
      item.Caption := layer.Name;
      item.Data := layer;

      if layer.Visible then
        item.SubItems.Add('Yes')
      else
        item.SubItems.Add('No');

      if layer.Selectable then
        item.SubItems.Add('Yes')
      else
        item.SubItems.Add('No');
    end;
    CurrentLayer.ItemIndex := CurrentLayer.Items.IndexOf(GetCurrentLayer.Name);
  end;
end;

procedure TLayersForm.CurrentLayerChange(Sender: TObject);
var
  layer: TLayer;

begin
  if CurrentLayer.ItemIndex <> -1 then
  begin
    layer := CurrentLayer.Items.Objects[CurrentLayer.ItemIndex] as TLayer;

    MainForm.SceneManager.SetCurrentLayer(layer);
  end;
end;

end.
