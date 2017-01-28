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

// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)

unit solidedit;

interface

uses
  System.UiTypes, System.Types,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Vector, Scene, Solid, Menus;

type
  TSolidMode = (smSelect, smCreate, smMove);

  TSolidEditor = class(TForm)
    ButtonBar: TPanel;
    CloseBtn: TButton;
    EditBar: TPanel;
    ApplyBtn: TBitBtn;
    XValue: TEdit;
    YValue: TEdit;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    NewBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    StatusPanel: TPanel;
    SelectBtn: TSpeedButton;
    Label1: TLabel;
    Strength: TEdit;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    PointMenu: TMenuItem;
    SelectItem: TMenuItem;
    CreateItem: TMenuItem;
    DeleteItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    GridBtn: TSpeedButton;
    ZoomBtn: TSpeedButton;
    OptionsMenu: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    CenterViewItem: TMenuItem;
    N1: TMenuItem;
    UseSORItem: TMenuItem;
    N2: TMenuItem;
    OpenItem: TMenuItem;
    SturmItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure OnValueChange(Sender: TObject);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure NewBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure CenterViewItemClick(Sender: TObject);
    procedure OpenItemClick(Sender: TObject);
    procedure UseSORItemClick(Sender: TObject);
    procedure SturmItemClick(Sender: TObject);
  private
    { Private declarations }
    Mode: TSolidMode;
    Solid: TSolid;
    Current: TSolidPoint;
    Grid: double;
    ScaleMult, ScaleDiv: integer;

    procedure CenterView;
    procedure AdjustPoint(x, y: integer; var xx, yy: double);
    function HitTest(x, y: integer): TSolidPoint;
    procedure SetCurrent(point: TSolidPoint);
    procedure UpdateSolid;
    procedure UpdateStatus(x, y: double);
    procedure CreatePoint(x, y: double);
  public
    { Public declarations }
    procedure SetSolid(ASolid: TSolid);
  end;

var
  SolidEditor: TSolidEditor;

implementation

uses main, grid, zoom;

{$R *.DFM}

procedure TSolidEditor.SetSolid(ASolid: TSolid);
begin
  Mode := smSelect;
  Solid := ASolid;
  Current := nil;
  Caption := 'Solid Editor - ' + Solid.Name;
  Strength.Text := FloatToStrF(ASolid.Strength, ffFixed, 6, 4);
  OpenItem.Checked := Solid.Open;
  UseSORItem.Checked := Solid.UseSOR;
  SturmItem.Enabled := Solid.UseSOR;
  SturmItem.Checked := Solid.Sturm;
  Show;
  CenterView;
end;

procedure TSolidEditor.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TSolidEditor.AdjustPoint(x, y: integer; var xx, yy: double);
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

function TSolidEditor.HitTest(x, y: integer): TSolidPoint;
var
  i: integer;
  point: TSolidPoint;
  xx, yy: double;

begin
  result := nil;
  AdjustPoint(x, y, xx, yy);
  for i := 0 to Solid.Points.Count - 1 do
  begin
    point := Solid.Points[i];
    if (abs(point.x - xx) < 0.1) and (abs(point.y - yy) < 0.1) then
    begin
      result := point;
      break;
    end;
  end;
end;

procedure TSolidEditor.SetCurrent(point: TSolidPoint);
begin
  if Current <> nil then
    Current.Selected := False;

  Current := point;

  if Current <> nil then
  begin
    Current.Selected := True;

    XValue.Text := FloatToStrF(Current.X, ffFixed, 4, 3);
    YValue.Text := FloatToStrF(Current.Y, ffFixed, 4, 3);
  end;

  ApplyBtn.Enabled := False;
end;

procedure TSolidEditor.UpdateSolid;
begin
  Solid.Rebuild;
  Solid.Make(TSceneManager.SceneManager, Solid.Triangles);
  MainForm.MainPaintBox.Refresh;
  PaintBox.Refresh;
end;

procedure TSolidEditor.UpdateStatus(x, y: double);
begin
  StatusPanel.Caption := 'x: ' + FloatToStrF(x, ffFixed, 4, 3) +
    ' y: ' + FloatToStrF(y, ffFixed, 4, 3);
end;

procedure TSolidEditor.CreatePoint(x, y: double);
var
  i: integer;
  new_point, point: TSolidPoint;

begin
  new_point := TSolidPoint.Create(x, y);

  for i := 0 to Solid.Points.Count - 1 do
  begin
    point := Solid.Points[i];
    if y > point.y then
    begin
      Solid.Points.Insert(i, new_point);
      SetCurrent(new_point);
      UpdateSolid;
      break;
    end;
  end;
end;

procedure TSolidEditor.FormCreate(Sender: TObject);
begin
  Solid := nil;
  Current := nil;
  Mode := smSelect;
  Grid := 0;
  ScaleMult := 1;
  ScaleDiv := 1;
end;

procedure TSolidEditor.CloseBtnClick(Sender: TObject);
var
  i: integer;
  pt: TSolidPoint;
  checked: boolean;

begin
  checked := True;

  if Solid.UseSOR then
  begin
    for i := 0 to Solid.Points.Count - 1 do
    begin
      pt := Solid.Points[i];
      if pt.y < 0 then
      begin
        MessageDlg('For a Surface of Revolution (Use SOR), all y coordinates must be +ve',
          mtError, [mbOK], 0);

        checked := False;
        break;
      end;
    end;
  end;

  if checked then
  begin
    Solid := nil;
    Current := nil;
    Mode := smSelect;
    Close;
  end;
end;

procedure TSolidEditor.PaintBoxPaint(Sender: TObject);
var
  i, xi, yi: integer;
  point: TSolidPoint;

begin
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);

    if Solid <> nil then
    begin
      for i := 0 to Solid.Points.Count - 1 do
      begin
        point := Solid.Points[i];
//$O-
        // Optimization causes problems here - BUG IN DELPHI!!!
        // This appears to be cured in Delphi 3.0
        // (Note the {} have been removed to make sure
        xi := trunc(Point.X * 100) * ScaleMult div ScaleDiv + ViewSize;
        yi := -trunc(Point.Y * 100) * ScaleMult div ScaleDiv + ViewSize;
//$O+
        Pen.Color := clWhite;
        if i > 0 then
          LineTo(xi, yi)
        else
          MoveTo(xi, yi);

        if Point.Selected then
          Pen.Color := clRed
        else
          Pen.Color := clWhite;

        Rectangle(xi - 5, yi - 5, xi + 5, yi + 5);
      end;
    end;
  end;
end;

procedure TSolidEditor.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  xx, yy: double;

begin
  case Mode of
    smCreate:
      begin
        AdjustPoint(x, y, xx, yy);
        CreatePoint(xx, yy);
        Mode := smSelect;
        SelectItem.Checked := True;
        SelectBtn.Down := True;
      end;

    smSelect:
      begin
        SetCurrent(HitTest(x, y));
        PaintBox.Refresh;
        if Current <> nil then
        begin
          PaintBox.BeginDrag(False);
          Mode := smMove;
        end;
      end;

    {smMove:
      begin
        if Current <> nil then
          PaintBox.BeginDrag(False);
      end;}
  end;
end;

procedure TSolidEditor.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  xx, yy: double;

begin
  AdjustPoint(x, y, xx, yy);

  UpdateStatus(xx, yy);
end;

procedure TSolidEditor.SelectBtnClick(Sender: TObject);
begin
  Mode := smSelect;
end;

procedure TSolidEditor.ApplyBtnClick(Sender: TObject);
begin
  if Current <> nil then
  begin
    Current.X := StrToFloat(XValue.Text);
    Current.Y := StrToFloat(YValue.Text);
    Solid.Strength := StrToFloat(Strength.Text);
    UpdateSolid;
    ApplyBtn.Enabled := False;
  end;
end;

procedure TSolidEditor.OnValueChange(Sender: TObject);
begin
  ApplyBtn.Enabled := True;
end;

procedure TSolidEditor.PaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  xx, yy: double;

begin
  AdjustPoint(x, y, xx, yy);
  if (Source = PaintBox) and (xx > -0.001) then
  begin
    if Solid.UseSOR and (yy < -0.001) then
      Accept := False
    else
    begin
      Accept := True;
      Current.X := xx;
      Current.Y := yy;
      PaintBox.Refresh;
      UpdateStatus(xx, yy);
    end;
  end
  else
    Accept := False;
end;

procedure TSolidEditor.PaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  SetCurrent(Current);
  UpdateSolid;
  Mode := smSelect;
end;

procedure TSolidEditor.NewBtnClick(Sender: TObject);
begin
  Mode := smCreate;
end;

procedure TSolidEditor.DeleteBtnClick(Sender: TObject);
begin
  if Current <> nil then
  begin
    if Solid.Points.Count > 2 then
    begin
      Solid.Points.Remove(Current);
      Current.Free;
      Current := nil;
      UpdateSolid;
      PaintBox.Refresh;
    end
    else
      MessageDlg('There must always be at least two points in a solid', mtError,
        [mbOK], 0);
  end;
end;

procedure TSolidEditor.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);

  dlg.Grid.Text := FloatToStrF(Grid, ffFixed, 4, 3);

  if dlg.ShowModal = idOK then
    Grid := StrToFloat(dlg.Grid.Text);

  dlg.Free;
end;

procedure TSolidEditor.ZoomItemClick(Sender: TObject);
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

procedure TSolidEditor.CenterViewItemClick(Sender: TObject);
begin
  CenterView;
end;

procedure TSolidEditor.OpenItemClick(Sender: TObject);
begin
  Solid.Open := not Solid.Open;
  OpenItem.Checked := Solid.Open;
end;

procedure TSolidEditor.UseSORItemClick(Sender: TObject);
var
  i: integer;
  miny: double;
  pt: TSolidPoint;

begin
  Solid.UseSOR := not Solid.UseSOR;

  if Solid.UseSOR then
  begin
    miny := 0;

    for i := 0 to Solid.Points.Count - 1 do
    begin
      pt := Solid.Points[i];
      if pt.y < 0 then miny := pt.y;
    end;

    if miny < 0 then
    begin
      if MessageDlg('You have -ve y coordinates which are not allowed in SOR, do you wish to correct this?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        for i := 0 to Solid.Points.Count - 1 do
        begin
          pt := Solid.Points[i];
          pt.y := pt.y - miny;
        end;
        UpdateSolid;
        PaintBox.Refresh;
      end
      else
        Solid.UseSOR := False;
    end;
  end;

  Solid.Sturm := False;
  SturmItem.Checked := False;
  UseSORItem.Checked := Solid.UseSOR;
  SturmItem.Enabled := Solid.UseSOR;
end;

procedure TSolidEditor.SturmItemClick(Sender: TObject);
begin
  Solid.Sturm := not Solid.Sturm;
  SturmItem.Checked := Solid.Sturm;
end;

end.
