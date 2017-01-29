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

unit lathedit;

interface

uses
  System.Types, System.UITypes,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Menus, Solid;

type
  TLatheMode = (lmSelect, lmTranslate, lmCreate);

  TLatheEditor = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    PointsMenu: TMenuItem;
    SelectItem: TMenuItem;
    CreateItem: TMenuItem;
    DeleteItem: TMenuItem;
    Options1: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    N1: TMenuItem;
    SturmItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    StatusPanel: TPanel;
    CoordsPanel: TPanel;
    CloseBtn: TButton;
    ToolBar: TPanel;
    SelectBtn: TSpeedButton;
    CreateBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    LatheType: TComboBox;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    GridBtn: TSpeedButton;
    ZoomBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure CreateItemClick(Sender: TObject);
    procedure SelectItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure SturmItemClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
  private
    { Private declarations }
    Mode: TLatheMode;
    Lathe: TLathe;
    Current: TSolidPoint;
    Grid: double;
    ScaleMult, ScaleDiv: integer;

  public
    { Public declarations }
    procedure SetLathe(ALathe: TLathe);
    procedure CenterView;
    procedure AdjustPoint(x, y: integer; var xx, yy: double);
    procedure GetPoint(point: TSolidPoint; var xi, yi: integer);
  end;

var
  LatheEditor: TLatheEditor;

implementation

uses Scene, main, grid, zoom;

{$R *.DFM}

procedure TLatheEditor.SetLathe(ALathe: TLathe);
begin
  Lathe := ALathe;
  LatheType.ItemIndex := ord(Lathe.LatheType);
  SturmItem.Checked := Lathe.Sturm;
  Current := nil;
  Mode := lmSelect;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
  Show;
  CenterView;
end;

procedure TLatheEditor.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - (ClientHeight * 5) div 6;
  end;
end;

procedure TLatheEditor.AdjustPoint(x, y: integer; var xx, yy: double);
begin
  xx := (x - ViewSize) * ScaleDiv / (100 * ScaleMult);
  yy := (ViewSize - y) * ScaleDiv / (100 * ScaleMult);

  // adjust for grid
  if Grid > 0.001 then
  begin
    xx := trunc(xx / grid) * grid;
    yy := trunc(yy / grid) * grid;
  end;
end;

procedure TLatheEditor.GetPoint(point: TSolidPoint; var xi, yi: integer);
begin
  xi := trunc(Point.X * 100) * ScaleMult div ScaleDiv + ViewSize;
  yi := -trunc(Point.Y * 100) * ScaleMult div ScaleDiv + ViewSize;
end;

procedure TLatheEditor.FormCreate(Sender: TObject);
begin
  Mode := lmSelect;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
  Lathe := nil;
  Current := nil;
  LatheType.ItemIndex := 0;
  Grid := 0;
  ScaleMult := 1;
  ScaleDiv := 1;
end;

procedure TLatheEditor.PaintBoxPaint(Sender: TObject);
var
  i, xi, yi: integer;
  pt: TSolidPoint;

begin
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    Pen.Mode := pmCopy;

    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);

    with Lathe do
    begin
      for i := 0 to Points.Count - 1 do
      begin
        pt := Points[i];
        GetPoint(pt, xi, yi);

        Pen.Color := clWhite;
        if i > 0 then
          LineTo(xi, yi)
        else
          MoveTo(xi, yi);

        if pt.Selected then
          Pen.Color := clRed;

        Rectangle(xi - 4, yi - 4, xi + 4, yi + 4);
      end;
      Pen.Color := clWhite;
      pt := Points[0];
      GetPoint(pt, xi, yi);
      LineTo(xi, yi);
    end;
  end;
end;

procedure TLatheEditor.CloseBtnClick(Sender: TObject);
begin
  Lathe.LatheType := TLatheType(LatheType.ItemIndex);
  Lathe.Sturm := SturmItem.Checked;
  Lathe := nil;
  Close;
end;

procedure TLatheEditor.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  xx, yy: double;

begin
  AdjustPoint(x, y, xx, yy);

  CoordsPanel.Caption := Format('x: %6.4f y: %6.4f', [xx, yy]);
end;

procedure TLatheEditor.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, index, xi, yi: integer;
  xx, yy, d, min: double;
  pt, newpt: TSolidPoint;

begin
  case Mode of
    lmSelect:
    begin
      Current := nil;
      with Lathe do
        for i := 0 to Points.Count - 1 do
        begin
          pt := Points[i];
          GetPoint(pt, xi, yi);
          if (abs(x - xi) < 4) and (abs(y - yi) < 4) then
          begin
            pt.Selected := True;
            Current := pt;
          end
          else
            pt.Selected := False;
        end;
      PaintBox.Refresh;
      if Current <> nil then
      begin
        PaintBox.BeginDrag(False);
        Mode := lmTranslate;
      end;
    end;

    lmCreate:
    begin
      AdjustPoint(x, y, xx, yy);
      newpt := TSolidPoint.Create(xx, yy);
      newpt.Selected := True;
      Current := newpt;

      // Ensure none are selected
      // and locate point closest to new one
      min := 1e9;
      index := -1;
      for i := 0 to Lathe.Points.Count - 1 do
      begin
        pt := Lathe.Points[i];
        pt.Selected := False;
        d := sqrt(sqr(xx - pt.x) + sqr(yy - pt.y));
        if index <> -1 then
        begin
          if d < min then
          begin
            index := i;
            min := d;
          end
        end
        else
        begin
          index := i;
          min := d;
        end;
      end;

      Lathe.Points.Insert(index, newpt);

      PaintBox.Refresh;
      Lathe.Rebuild;
      MainForm.Modify(Lathe);
      Mode := lmSelect;
      SelectItem.Checked := True;
      SelectBtn.Down := True;
    end;
  end;
end;

procedure TLatheEditor.PaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  xx, yy: double;

begin
  AdjustPoint(x, y, xx, yy);
  if (Current <> nil) and (xx > -0.001) and (yy > -0.001) then
  begin
    Current.x := xx;
    Current.y := yy;
    PaintBox.Refresh;
    Accept := True;
  end
  else
    Accept := False;
end;

procedure TLatheEditor.PaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  Mode := lmSelect;
  Lathe.Rebuild;
  MainForm.Modify(Lathe);
end;

procedure TLatheEditor.CreateItemClick(Sender: TObject);
begin
  Mode := lmCreate;
  CreateItem.Checked := True;
  CreateBtn.Down := True;
end;

procedure TLatheEditor.SelectItemClick(Sender: TObject);
begin
  Mode := lmSelect;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
end;

procedure TLatheEditor.DeleteItemClick(Sender: TObject);
begin
  if Current <> nil then
  begin
    if Lathe.Points.Count > 3 then
    begin
      Lathe.Points.Remove(Current);
      Current.Free;
      Current := nil;
      PaintBox.Refresh;
      Lathe.Rebuild;
      MainForm.Modify(Lathe);
    end
    else
      MessageDlg('There must be at least three points in a lathe', mtError, [mbOK], 0);
  end;
end;

procedure TLatheEditor.SturmItemClick(Sender: TObject);
begin
  Lathe.Sturm := not Lathe.Sturm;
  SturmItem.Checked := Lathe.Sturm;
end;

procedure TLatheEditor.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);
  dlg.Grid.Text := FloatToStrF(Grid, ffFixed, 6, 4);
  if dlg.ShowModal = idOK then
    Grid := StrToFloat(dlg.Grid.Text);
  dlg.Free;
end;

procedure TLatheEditor.ZoomItemClick(Sender: TObject);
var
  dlg: TZoomDlg;

begin
  dlg := TZoomDlg.Create(Application);

  dlg.Multiplier.Text := IntToStr(ScaleMult);
  dlg.Divisor.Text := IntToStr(ScaleDiv);

  if dlg.ShowModal = idOK then
  begin
    ScaleMult := StrToInt(dlg.Multiplier.Text);
    ScaleDiv := StrToInt(dlg.Divisor.Text);
    PaintBox.Refresh;
  end;

  dlg.Free;
end;

end.
