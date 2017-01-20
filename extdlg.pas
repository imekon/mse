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

unit extdlg;

interface

uses
  System.UITypes, System.Types,
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs, Controls, StdCtrls,
  Buttons, ExtCtrls, Main, Polygon, Menus, ComCtrls;

type
  TExtrusionMode = (emSelect, emTranslate, emScale, emRotate, emCreate);

  TCreateExtrusionDialog = class(TForm)
    ToolBar: TPanel;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    TriangleBtn: TSpeedButton;
    SquareBtn: TSpeedButton;
    SelectBtn: TSpeedButton;
    TranslateBtn: TSpeedButton;
    ScaleBtn: TSpeedButton;
    RotateBtn: TSpeedButton;
    NewPtBtn: TSpeedButton;
    DeletePtBtn: TSpeedButton;
    Selection: TComboBox;
    ButtonPanel: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    LoadItem: TMenuItem;
    SaveItem: TMenuItem;
    CloseItem: TMenuItem;
    EditMenu: TMenuItem;
    SelectAllItem: TMenuItem;
    ClearAllItem: TMenuItem;
    N1: TMenuItem;
    DeleteItem: TMenuItem;
    ShapeMenu: TMenuItem;
    SelectItem: TMenuItem;
    TranslateItem: TMenuItem;
    ScaleItem: TMenuItem;
    RotateItem: TMenuItem;
    CreatePointItem: TMenuItem;
    TriangleItem: TMenuItem;
    SquareItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Options1: TMenuItem;
    CenterViewItem: TMenuItem;
    N2: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    GridBtn: TSpeedButton;
    ZoomBtn: TSpeedButton;
    EditBar: TPanel;
    Label1: TLabel;
    Steps: TEdit;
    StepsUpDown: TUpDown;
    Label2: TLabel;
    Depth: TEdit;
    N3: TMenuItem;
    N4: TMenuItem;
    NSidedItem: TMenuItem;
    NSidedBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TranslateBtnClick(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure TriangleBtnClick(Sender: TObject);
    procedure SquareBtnClick(Sender: TObject);
    procedure DeletePtBtnClick(Sender: TObject);
    procedure NewPtBtnClick(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure LoadItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure ClearAllItemClick(Sender: TObject);
    procedure CenterViewItemClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure NSidedItemClick(Sender: TObject);
  private
    { Private declarations }
    Mode: TExtrusionMode;
    FirstDrag: boolean;
    SelectRect: TRect;
    Anchor: TXYPoint;
    Grid: double;
    ScaleMult, ScaleDiv: integer;

    procedure CenterView;
    //procedure WMCenterView(var msg: TMessage); message WM_CENTERVIEW;
    procedure GetPoint(point: TXYPoint; var xi, yi: integer);
    procedure AdjustPoint(x, y: integer; var xx, yy: double);
    procedure ClearPoints;
    procedure MakeTriangle;
  public
    { Public declarations }
    Points: TList;
  end;

implementation

{$R *.DFM}

uses Scene, misc, grid, zoom, nsides;

procedure TCreateExtrusionDialog.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TCreateExtrusionDialog.FormCreate(Sender: TObject);
begin
  Mode := emSelect;

  Anchor := TXYPoint.Create;
  Points := TList.Create;

  Selection.ItemIndex := 0;

  Grid := 0;

  ScaleMult := 1;
  ScaleDiv := 1;

  MakeTriangle;

  CenterView;
  //PostMessage(Handle, WM_CENTERVIEW, 0, 0);
end;

//procedure TCreateExtrusionDialog.WMCenterView(var msg: TMessage);
//begin
//  CenterView;
//end;

procedure TCreateExtrusionDialog.GetPoint(point: TXYPoint; var xi, yi: integer);
begin
  xi := trunc(point.x * ScaleMult * 50 / ScaleDiv) + ViewSize;
  yi := -trunc(point.y * ScaleMult* 50 / ScaleDiv) + ViewSize;
end;

procedure TCreateExtrusionDialog.AdjustPoint(x, y: integer; var xx, yy: double);
begin
  xx := (x - ViewSize) * ScaleDiv / (50 * ScaleMult);
  yy := -(y - ViewSize) * ScaleDiv / (50 * ScaleMult);

  // adjust for grid
  if Grid > 0.001 then
  begin
    xx := trunc(xx / grid) * grid;
    yy := trunc(yy / grid) * grid;
  end;
end;

procedure TCreateExtrusionDialog.ClearPoints;
var
  i: integer;
  point: TXYPoint;

begin
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    point.Free;
  end;

  Points.Clear;
end;

procedure TCreateExtrusionDialog.MakeTriangle;
var
  point: TXYPoint;

begin
  ClearPoints;

  point := TXYPoint.Create;
  point.X := 0;
  point.Y := 1;
  Points.Add(point);

  point := TXYPoint.Create;
  point.X := -1;
  point.Y := -1;
  Points.Add(point);

  point := TXYPoint.Create;
  point.X := 1;
  point.Y := -1;
  Points.Add(point);
end;

procedure TCreateExtrusionDialog.PaintBoxPaint(Sender: TObject);
var
  i, x0, y0, xi, yi: integer;
  point: TXYPoint;

begin
  x0 := 0;
  y0 := 0;
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    Pen.Mode := pmCopy;

    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);

    for i := 0 to Points.Count - 1 do
    begin
      point := Points[i];
      GetPoint(point, xi, yi);

      Pen.Color := clWhite;

      if i > 0 then
        LineTo(xi, yi)
      else
      begin
        x0 := xi;
        y0 := yi;
        MoveTo(xi, yi);
      end;

      if point.Selected then
        Pen.Color := clRed
      else
        Pen.Color := clWhite;
        
      Rectangle(xi - 4, yi - 4, xi + 4, yi + 4);
    end;

    Pen.Color := clWhite;
    LineTo(x0, y0);
  end;
end;

procedure TCreateExtrusionDialog.FormDestroy(Sender: TObject);
begin
  ClearPoints;

  Points.Free;
end;

procedure TCreateExtrusionDialog.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, current: integer;
  point: TXYPoint;
  xx, yy, d, min: double;

begin
  case Mode of
    emSelect:
    begin
      SelectRect.left := x;
      SelectRect.right := x;
      SelectRect.top := y;
      SelectRect.bottom := y;
      FirstDrag := False;
      PaintBox.BeginDrag(False);
    end;

    emTranslate, emScale, emRotate:
    begin
      AdjustPoint(x, y, xx, yy);
      Anchor.x := xx;
      Anchor.y := yy;
      for i := 0 to Points.Count - 1 do
      begin
        point := Points[i];
        point.SetAnchor;
      end;
      PaintBox.BeginDrag(False);
    end;

    emCreate:
    begin
      AdjustPoint(x, y, xx, yy);
      current := -1;
      min := 1e9;

      for i := 0 to Points.Count - 1 do
      begin
        point := Points[i];
        d := sqrt(sqr(xx - point.x) + sqr(yy - point.y));
        if current <> -1 then
        begin
          if d < min then
          begin
            current := i;
            min := d;
          end
        end
        else
        begin
          current := i;
          min := d;
        end;
      end;

      if current <> -1 then
      begin
        point := TXYPoint.Create;
        point.x := xx;
        point.y := yy;
        Points.Insert(current, point);
        Mode := emSelect;
        SelectBtn.Down := True;
        PaintBox.Refresh;
      end;
    end;
  end;
end;

procedure TCreateExtrusionDialog.PaintBoxDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  i: integer;
  point: TXYPoint;
  xx, yy: double;

begin
  if Source = PaintBox then
    case Mode of
      emSelect:
        with PaintBox.Canvas do
        begin
          // Make the selection rectangle drag around (rubber banding)
          Pen.Mode := pmXor;
          Pen.Color := clRed;
          if FirstDrag then DrawRectangle(PaintBox.Canvas, SelectRect);
          SelectRect.right := x;
          SelectRect.bottom := y;
          DrawRectangle(PaintBox.Canvas, SelectRect);
          FirstDrag := True;
        end;

      emTranslate:
        begin
          AdjustPoint(x, y, xx, yy);
          for i := 0 to Points.Count - 1 do
          begin
            point := Points[i];
            point.SetTranslate(xx - Anchor.x, yy - Anchor.y);
          end;
          PaintBox.Refresh;
        end;
    end;
end;

procedure TCreateExtrusionDialog.PaintBoxEndDrag(Sender, Target: TObject;
  X, Y: Integer);
var
  i, xi, yi: integer;
  pt: TPoint;
  point: TXYPoint;

begin
  case Mode of
    emSelect:
    begin
      with PaintBox.Canvas do
      begin
        // Make the selection rectangle disappear
        Pen.Mode := pmXor;
        Pen.Color := clRed;
        SelectRect.right := x;
        SelectRect.bottom := y;
        DrawRectangle(PaintBox.Canvas, SelectRect);
      end;

      for i := 0 to Points.Count - 1 do
      begin
        point := Points[i];
        GetPoint(point, xi, yi);
        pt.x := xi;
        pt.y := yi;
        if PtInRect(SelectRect, pt) then
          case Selection.ItemIndex of
            0: point.Selected := True;
            1: point.Selected := not point.Selected;
            2: point.Selected := False;
          end;
      end;

      PaintBox.Refresh;
    end;
  end;
end;

procedure TCreateExtrusionDialog.TranslateBtnClick(Sender: TObject);
begin
  Mode := emTranslate;
  TranslateBtn.Down := True;
end;

procedure TCreateExtrusionDialog.SelectBtnClick(Sender: TObject);
begin
  Mode := emSelect;
  SelectBtn.Down := True;
end;

procedure TCreateExtrusionDialog.TriangleBtnClick(Sender: TObject);
begin
  MakeTriangle;
  PaintBox.Refresh;
end;

procedure TCreateExtrusionDialog.SquareBtnClick(Sender: TObject);
var
  point: TXYPoint;

begin
  ClearPoints;

  point := TXYPoint.Create;
  point.X := 1;
  point.Y := 1;
  Points.Add(point);

  point := TXYPoint.Create;
  point.X := -1;
  point.Y := 1;
  Points.Add(point);

  point := TXYPoint.Create;
  point.X := -1;
  point.Y := -1;
  Points.Add(point);

  point := TXYPoint.Create;
  point.X := 1;
  point.Y := -1;
  Points.Add(point);

  PaintBox.Refresh;
end;

procedure TCreateExtrusionDialog.DeletePtBtnClick(Sender: TObject);
var
  deleting: boolean;
  i, n: integer;
  point: TXYPoint;

begin
  n := 0;
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    if point.Selected then inc(n);
  end;

  if Points.Count - n > 2 then
  begin
    deleting := True;
    while deleting do
    begin
      deleting := False;
      for i := 0 to Points.Count - 1 do
      begin
        point := Points[i];
        if point.Selected then
        begin
          Points.Remove(point);
          point.Free;
          deleting := True;
          break;
        end;
      end;
    end;
    PaintBox.Refresh;
  end
  else
    MessageDlg('There must be at least three points to extrude', mtError, [mbOK] , 0);
end;

procedure TCreateExtrusionDialog.NewPtBtnClick(Sender: TObject);
begin
  Mode := emCreate;
  NewPtBtn.Down := True;
end;

procedure TCreateExtrusionDialog.CloseItemClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCreateExtrusionDialog.LoadItemClick(Sender: TObject);
var
  x, y: double;
  source: TextFile;
  point: TXYPoint;

begin
  if OpenDialog.Execute then
  begin
    Screen.Cursor := crHourglass;
    AssignFile(source, OpenDialog.FileName);
    ClearPoints;
    try
      Reset(source);
      Points.Clear;
      while not eof(source) do
      begin
        ReadLn(source, x, y);

        point := TXYPoint.Create;
        point.x := x;
        point.y := y;
        Points.Add(point);
      end;
    finally
      CloseFile(source);
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TCreateExtrusionDialog.SaveItemClick(Sender: TObject);
var
  i: integer;
  dest: TextFile;
  point: TXYPoint;

begin
  if SaveDialog.Execute then
  begin
    Screen.Cursor := crHourglass;
    AssignFile(dest, SaveDialog.Filename);
    try
      Rewrite(dest);
      for i := 0 to Points.Count - 1 do
      begin
        point := Points[i];
        WriteLn(dest, point.x, point.y);
      end;
    finally
      CloseFile(dest);
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TCreateExtrusionDialog.SelectAllItemClick(Sender: TObject);
var
  i: integer;
  point: TXYPoint;

begin
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    point.Selected := True;
  end;
  PaintBox.Refresh;
end;

procedure TCreateExtrusionDialog.ClearAllItemClick(Sender: TObject);
var
  i: integer;
  point: TXYPoint;

begin
  for i := 0 to Points.Count - 1 do
  begin
    point := Points[i];
    point.Selected := False;
  end;
  PaintBox.Refresh;
end;

procedure TCreateExtrusionDialog.CenterViewItemClick(Sender: TObject);
begin
  CenterView;
end;

procedure TCreateExtrusionDialog.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);

  dlg.Grid.Text := FloatToStrF(Grid, ffFixed, 4, 3);

  if dlg.ShowModal = idOk then
    Grid := StrToFloat(dlg.Grid.Text);

  dlg.Free;
end;

procedure TCreateExtrusionDialog.ZoomItemClick(Sender: TObject);
var
  dlg: TZoomDlg;

begin
  dlg := TZoomDlg.Create(Application);

  dlg.Multiplier.Text := IntToStr(ScaleMult);
  dlg.Divisor.Text := IntToStr(ScaleDiv);

  if dlg.ShowModal = idOk then
  begin
    ScaleMult := StrToInt(dlg.Multiplier.Text);
    ScaleDiv := StrToInt(dlg.Divisor.Text);
    PaintBox.Refresh;
  end;

  dlg.Free;
end;

procedure TCreateExtrusionDialog.NSidedItemClick(Sender: TObject);
var
  i, n: integer;
  point: TXYPoint;
  x, y, angle, radius: double;
  dlg: TNSidedDialog;

begin
  dlg := TNSidedDialog.Create(Application);

  if dlg.ShowModal = idOK then
  begin
    n := StrToInt(dlg.Sides.Text);
    angle := 360 / n;
    radius := StrToFloat(dlg.Radius.Text);
    ClearPoints;
    for i := 0 to n - 1 do
    begin
      x := radius * sin(angle * i * d2r);
      y := radius * cos(angle * i * d2r);
      point := TXYPoint.Create;
      point.x := x;
      point.y := y;
      Points.Add(point);
    end;
    PaintBox.Refresh;
  end;

  dlg.Free;
end;

end.
