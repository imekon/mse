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

unit grpedit;

interface

uses
  System.Contnrs,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, ToolWin, ComCtrls, Menus, Group;

type
  TGroupEditor = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    StatusPanel: TPanel;
    CoordsPanel: TPanel;
    CoolBar: TCoolBar;
    ToolPanel: TPanel;
    SelectBtn: TSpeedButton;
    EditPanel: TPanel;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    procedure CloseItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
  private
    { Private declarations }
    group: TGroupShape;
  public
    { Public declarations }
    procedure CenterView;
    procedure SetGroup(AGroup: TGroupShape);
  end;

var
  GroupEditor: TGroupEditor;

implementation

uses Scene, main;

{$R *.DFM}

procedure TGroupEditor.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TGroupEditor.SetGroup(AGroup: TGroupShape);
begin
  group := AGroup;
  group.Make(MainForm.SceneManager, group.GhostTriangles);
  Show;
  CenterView;
end;

procedure TGroupEditor.CloseItemClick(Sender: TObject);
begin
  Close;
end;

procedure TGroupEditor.FormCreate(Sender: TObject);
begin
  group := nil;
end;

procedure TGroupEditor.PaintBoxPaint(Sender: TObject);
var
  i: integer;
  shape: TShape;

begin
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    Pen.Mode := pmCopy;

    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);
  end;

  for i := 0 to group.Shapes.Count - 1 do
  begin
    shape := group.Shapes[i] as TShape;
    shape.Draw(MainForm.SceneManager, shape.GhostTriangles, PaintBox.Canvas, pmCopy);
  end;
end;

end.
