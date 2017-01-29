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

unit halosdlg;

interface

uses
  System.UITypes,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, halo, scene;

type
  THalosDialog = class(TForm)
    OKBtn: TButton;
    ListBox: TListBox;
    AddBtn: TButton;
    EditBtn: TButton;
    DeleteBtn: TButton;
    procedure EditBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    DrawingContext: IDrawingContext;
  public
    { Public declarations }
    procedure SetDrawingContext(context: IDrawingContext);
  end;

implementation

{$R *.DFM}

procedure THalosDialog.EditBtnClick(Sender: TObject);
var
  halo: THalo;

begin
  if ListBox.ItemIndex <> -1 then
  begin
    halo := ListBox.Items.Objects[ListBox.ItemIndex] as THalo;
    if Assigned(halo) then
    begin
      if halo.Edit(DrawingContext) then
        THaloManager.HaloManager.IsModified := true;
    end;
  end;
end;

procedure THalosDialog.AddBtnClick(Sender: TObject);
var
  halo: THalo;

begin
  halo := THalo.Create;

  halo.Name := 'Halo' + IntToStr(ListBox.Items.Count + 1);
  halo.CreateSimple;

  if halo.Edit(DrawingContext) then
  begin
    ListBox.Items.AddObject(halo.Name, halo);
    THaloManager.HaloManager.IsModified := true;
  end
  else
    halo.Free;
end;

procedure THalosDialog.DeleteBtnClick(Sender: TObject);
var
  halo: THalo;

begin
  if ListBox.ItemIndex <> -1 then
    if MessageDlg('Are you sure you want to delete this halo?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      halo := ListBox.Items.Objects[ListBox.ItemIndex] as THalo;
      if Assigned(halo) then
      begin
        ListBox.Items.Delete(ListBox.ItemIndex);
        THaloManager.HaloManager.IsModified := true;
        halo.Free;
      end;
    end;
end;

procedure THalosDialog.FormCreate(Sender: TObject);
var
  i: integer;
  halo, newhalo: THalo;

begin
  DrawingContext := nil;

  for i := 0 to THaloManager.HaloManager.Halos.Count - 1 do
  begin
    halo := THaloManager.HaloManager.Halos[i];
    newhalo := THalo.Create;
    newhalo.Copy(halo);
    ListBox.Items.AddObject(halo.Name, newhalo);
  end;
end;

procedure THalosDialog.OKBtnClick(Sender: TObject);
var
  i: integer;
  halo: THalo;

begin
  // Clear out stored halos
  for i := 0 to THaloManager.HaloManager.Halos.Count - 1 do
  begin
    halo := THaloManager.HaloManager.Halos[i];
    halo.Free;
  end;

  THaloManager.HaloManager.Halos.Clear;

  for i := 0 to ListBox.Items.Count - 1 do
  begin
    halo := ListBox.Items.Objects[i] as THalo;
    THaloManager.HaloManager.Halos.Add(halo);
  end;
end;

procedure THalosDialog.SetDrawingContext(context: IDrawingContext);
begin
  DrawingContext := context;
end;

end.
