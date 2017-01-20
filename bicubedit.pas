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

unit bicubedit;

interface

uses
  System.UITypes, System.Types,
  Windows, Messages, SysUtils, Math, Classes, Graphics, Controls, Forms, Dialogs,
  Tabs, StdCtrls, Buttons, ExtCtrls, Menus, Vector, Scene, Bicubic, ComCtrls,
  ToolWin;

const
  UnitSize = 50;

type
  TBicubicEditorView = (beFront, beBack, beTop, beBottom, beLeft, beRight);

  TBicubicEditorMode = (bmSelect, bmTranslate, bmScale, bmRotate, bmCreate);

  TBicubicEditor = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    StatusBar: TPanel;
    CoordPanel: TPanel;
    CloseBtn: TButton;
    TabSet: TTabSet;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    PatchMenu: TMenuItem;
    SelectItem: TMenuItem;
    MoveItem: TMenuItem;
    Edit1: TMenuItem;
    ClearItem: TMenuItem;
    SelectAllItem: TMenuItem;
    ScaleItem: TMenuItem;
    RotateItem: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    CreateItem: TMenuItem;
    DeleteItem: TMenuItem;
    N3: TMenuItem;
    OptionsMenu: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    CenterViewItem: TMenuItem;
    N4: TMenuItem;
    CoolBar: TCoolBar;
    ButtonBar: TPanel;
    SelectBtn: TSpeedButton;
    MoveBtn: TSpeedButton;
    ScaleBtn: TSpeedButton;
    RotateBtn: TSpeedButton;
    NewBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    GridBtn: TSpeedButton;
    ZoomBtn: TSpeedButton;
    Selection: TComboBox;
    EditBar: TPanel;
    ApplyBtn: TBitBtn;
    PatchType: TComboBox;
    Flatness: TEdit;
    USteps: TEdit;
    UStepsUpDown: TUpDown;
    VSteps: TEdit;
    VStepsUpDown: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure TabSetClick(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnValueChanged(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectItemClick(Sender: TObject);
    procedure MoveItemClick(Sender: TObject);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ClearItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure ScaleItemClick(Sender: TObject);
    procedure RotateItemClick(Sender: TObject);
    procedure CreateItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure CenterViewItemClick(Sender: TObject);
  private
    { Private declarations }
    BicubicShape: TBicubicShape;
    View: TBicubicEditorView;
    Mode: TBicubicEditorMode;
    FirstDrag: boolean;
    SelectRect: TRect;
    Anchor: TVector;
    ScaleMult, ScaleDiv: integer;
    Grid: double;

    procedure CenterView;
    procedure GetPoint(patch: TBicubicPatch; u, v: integer;
      var x, y: integer; var selected: boolean);
    procedure AdjustPoint(X, Y: integer;
      var point: TPoint;
      var xx, yy, zz: double;
      var xb, yb, zb: boolean);

  public
    { Public declarations }
    procedure SetBicubic(ABicubic: TBicubicShape);
  end;

var
  BicubicEditor: TBicubicEditor;

implementation

uses main, misc, grid, zoom;

{$R *.DFM}

procedure TBicubicEditor.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TBicubicEditor.SetBicubic(ABicubic: TBicubicShape);
begin
  BicubicShape := ABicubic;

  Caption := 'Bicubic Patch - ' + BicubicShape.Name;
  PatchType.ItemIndex := BicubicShape.PatchType;
  Flatness.Text := FloatToStrF(BicubicShape.Flatness, ffFixed, 6, 4);
  USteps.Text := IntToStr(BicubicShape.USteps);
  VSteps.Text := IntToStr(BicubicShape.VSteps);

  Show;
  CenterView;
end;

procedure TBicubicEditor.AdjustPoint(X, Y: integer;
  var point: TPoint;
  var xx, yy, zz: double;
  var xb, yb, zb: boolean);
var
  xi, yi: double;

begin
  point.x := X - ViewSize;
  point.y := Y - ViewSize;

  // May have to use 20.0 instead of ViewRange - it's corrupted!
  xi := point.x * 20.0 / ViewSize;
  yi := -point.y * 20.0 / ViewSize;

  // adjust for zoom
  if ScaleMult <> ScaleDiv then
  begin
    xi := (xi * ScaleDiv) / ScaleMult;
    yi := (yi * ScaleDiv) / ScaleMult;
  end;

  // adjust for grid
  if Grid > 0.001 then
  begin
    xi := trunc(xi / grid) * grid;
    yi := trunc(yi / grid) * grid;
  end;

  // figure out for view
  case View of
    beFront:
    begin
      xx := xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    beBack:
    begin
      xx := -xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    beLeft:
    begin
      xx := 0;
      yy := yi;
      zz := -xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    beRight:
    begin
      xx := 0;
      yy := yi;
      zz := xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    beTop:
    begin
      xx := xi;
      yy := 0;
      zz := yi;
      xb := True;
      yb := False;
      zb := True;
    end;

    beBottom:
    begin
      xx := xi;
      yy := 0;
      zz := -yi;
      xb := True;
      yb := False;
      zb := True;
    end;
  end;
end;

procedure TBicubicEditor.GetPoint(patch: TBicubicPatch; u, v: integer;
  var x, y: integer; var selected: boolean);
begin
  selected := patch.Controls[u, v].Selected;
  case View of
    beFront:
      begin
        x := trunc(patch.Controls[u, v].x * UnitSize);
        y := -trunc(patch.Controls[u, v].y * UnitSize);
      end;

    beBack:
      begin
        x := -trunc(patch.Controls[u, v].x * UnitSize);
        y := -trunc(patch.Controls[u, v].y * UnitSize);
      end;

    beTop:
      begin
        x := trunc(patch.Controls[u, v].x * UnitSize);
        y := -trunc(patch.Controls[u, v].z * UnitSize);
      end;

    beBottom:
      begin
        x := trunc(patch.Controls[u, v].x * UnitSize);
        y := trunc(patch.Controls[u, v].z * UnitSize);
      end;

    beLeft:
      begin
        x := -trunc(patch.Controls[u, v].z * UnitSize);
        y := -trunc(patch.Controls[u, v].y * UnitSize);
      end;

    beRight:
      begin
        x := trunc(patch.Controls[u, v].z * UnitSize);
        y := -trunc(patch.Controls[u, v].y * UnitSize);
      end;
  end;

  x := x * ScaleMult div ScaleDiv;
  y := y * ScaleMult div ScaleDiv;
end;

procedure TBicubicEditor.FormCreate(Sender: TObject);
begin
  BicubicShape := nil;
  View := beFront;
  Mode := bmSelect;
  Anchor := TVector.Create;
  Selection.ItemIndex := 0;
  ScaleMult := 1;
  ScaleDiv := 1;
  Grid := 0;
end;

procedure TBicubicEditor.CloseItemClick(Sender: TObject);
begin
  BicubicShape.Build;
  MainForm.Modify(BicubicShape);
  Close;
end;

procedure TBicubicEditor.PaintBoxPaint(Sender: TObject);
var
  selected: boolean;
  i, u, v, x, y: integer;
  patch: TBicubicPatch;

begin
  with PaintBox.Canvas do
  begin
    Pen.Mode := pmCopy;
    Pen.Color := clGray;

    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);

    for i := 0 to BicubicShape.Patches.Count - 1 do
    begin
      patch := BicubicShape.Patches[i];

      Pen.Color := clWhite;

      for v := 0 to 3 do
        for u := 0 to 3 do
        begin
          GetPoint(patch, u, v, x, y, selected);
          if u > 0 then
            LineTo(x + ViewSize, y + ViewSize)
          else
            MoveTo(x + ViewSize, y + ViewSize);
        end;

      for u := 0 to 3 do
        for v := 0 to 3 do
        begin
          GetPoint(patch, u, v, x, y, selected);
          if v > 0 then
            LineTo(x + ViewSize, y + ViewSize)
          else
            MoveTo(x + ViewSize, y + ViewSize);
        end;

      for u := 0 to 3 do
        for v := 0 to 3 do
        begin
          GetPoint(patch, u, v, x, y, selected);

          if selected then
            Pen.Color := clRed
          else
            Pen.Color := clWhite;

          Rectangle(x + ViewSize - 3, y + ViewSize - 3,
            x + ViewSize + 3, y + ViewSize + 3);
        end;
    end;
  end;
end;

procedure TBicubicEditor.TabSetClick(Sender: TObject);
begin
  case TabSet.TabIndex of
    0: View := beFront;
    1: View := beBack;
    2: View := beTop;
    3: View := beBottom;
    4: View := beLeft;
    5: View := beRight;
  end;
  PaintBox.Refresh;
end;

procedure TBicubicEditor.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;
  patch: TBicubicPatch;

begin
  case Mode of
    bmSelect:
    begin
      SelectRect.left := x;
      SelectRect.right := x;
      SelectRect.top := y;
      SelectRect.bottom := y;
      PaintBox.BeginDrag(False);
    end;

    bmTranslate, bmScale, bmRotate:
    begin
      AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);

      Anchor.x := xx;
      Anchor.y := yy;
      Anchor.z := zz;

      with BicubicShape do
        for i := 0 to Patches.Count - 1 do
        begin
          patch := Patches[i];
          patch.SetAnchor;
        end;
      PaintBox.BeginDrag(False);
    end;

    bmCreate:
    begin
      AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
      patch := TBicubicPatch.Create;
      CreateBicubicSheet(patch, xx, yy, zz);
      BicubicShape.Patches.Add(patch);
      Mode := bmSelect;
      SelectItem.Checked := True;
      SelectBtn.Down := True;
      PaintBox.Refresh;
    end;
  end;

  FirstDrag := False;
end;

procedure TBicubicEditor.OnValueChanged(Sender: TObject);
begin
  ApplyBtn.Enabled := True;
end;

procedure TBicubicEditor.ApplyBtnClick(Sender: TObject);
begin
  ApplyBtn.Enabled := False;
end;

procedure TBicubicEditor.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;

begin
  AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
  CoordPanel.Caption := 'x: ' + FloatToStrF(xx, ffFixed, 4, 3) +
    ' y: ' + FloatToStrF(yy, ffFixed, 4, 3) +
    ' z: ' + FloatToStrF(zz, ffFixed, 4, 3);
end;

procedure TBicubicEditor.SelectItemClick(Sender: TObject);
begin
  Mode := bmSelect;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
end;

procedure TBicubicEditor.MoveItemClick(Sender: TObject);
begin
  Mode := bmTranslate;
  MoveItem.Checked := True;
  MoveBtn.Down := True;
end;

procedure TBicubicEditor.PaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  i: integer;
  point: TPoint;
  xx, yy, zz, xd, yd, zd: double;
  xb, yb, zb: boolean;
  patch: TBicubicPatch;

begin
  if Source = PaintBox then
  begin
    case Mode of
      bmSelect:
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

      bmTranslate:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          with BicubicShape do
          begin
            for i := 0 to Patches.Count - 1 do
            begin
              patch := Patches[i];
              patch.SetTranslate(xx - Anchor.x, yy - Anchor.y, zz - Anchor.z, xb, yb, zb);
            end;
          end;
          PaintBox.Refresh;
        end;

      bmScale:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          with BicubicShape do
          begin
            for i := 0 to Patches.Count - 1 do
            begin
              patch := Patches[i];
              patch.SetScale(xx - Anchor.x, yy - Anchor.y, zz - Anchor.z, xb, yb, zb);
            end;
          end;
          PaintBox.Refresh;
        end;

      bmRotate:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          with BicubicShape do
          begin
            for i := 0 to Patches.Count - 1 do
            begin
              patch := Patches[i];

              xd := 0;
              yd := 0;
              zd := 0;

              if xb and yb then
                zd := ArcTan2(-yy { - Anchor.y}, xx { - Anchor.x});

              if xb and zb then
                yd := ArcTan2(zz { - Anchor.y}, xx { - Anchor.x});

              if yb and zb then
                xd := ArcTan2(yy { - Anchor.y}, zz { - Anchor.z});
                
              patch.SetRotate(xd, yd, zd, xb, yb, zb);
            end;
          end;
          PaintBox.Refresh;
        end;
    end;

    Accept := True;
  end
  else
    Accept := False;
end;

procedure TBicubicEditor.PaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  selected: boolean;
  i, u, v, xi, yi: integer;
  patch: TBicubicPatch;
  point: TPoint;

begin
  case Mode of
    bmSelect:
      begin
        with PaintBox.Canvas do
        begin
          // Make the selection rectangle disappear
          Pen.Mode := pmXor;
          Pen.Color := clRed;
          SelectRect.right := x;
          SelectRect.bottom := y;
          DrawRectangle(PaintBox.Canvas, SelectRect);

          // Find out which points are inside selection rectangle
          with BicubicShape do
            for i := 0 to Patches.Count - 1 do
            begin
              patch := Patches[i];
              for v := 0 to 3 do
                for u := 0 to 3 do
                begin
                  selected := ssSelected in States;
                  GetPoint(patch, u, v, xi, yi, selected);
                  if selected then
                    States := States + [ssSelected]
                  else
                    States := States - [ssSelected];

                  point.x := xi + ViewSize;
                  point.y := yi + ViewSize;

                  if PtInRect(SelectRect, point) then
                    case Selection.ItemIndex of
                      2: patch.SetSelectedXY(u, v, False);
                      1: patch.ToggleSelected(u, v);
                      0: patch.SetSelectedXY(u, v, True);
                    end;
                end;
            end;
        end;
        PaintBox.Refresh;
      end;
  end;
end;

procedure TBicubicEditor.ClearItemClick(Sender: TObject);
var
  i: integer;
  patch: TBicubicPatch;

begin
  with BicubicShape do
    for i := 0 to BicubicShape.Patches.Count - 1 do
    begin
      patch := BicubicShape.Patches[i];
      patch.SetSelected(False);
    end;

  PaintBox.Refresh;
end;

procedure TBicubicEditor.SelectAllItemClick(Sender: TObject);
var
  i: integer;
  patch: TBicubicPatch;

begin
  with BicubicShape do
    for i := 0 to BicubicShape.Patches.Count - 1 do
    begin
      patch := BicubicShape.Patches[i];
      patch.SetSelected(True);
    end;

  PaintBox.Refresh;
end;

procedure TBicubicEditor.ScaleItemClick(Sender: TObject);
begin
  Mode := bmScale;
  ScaleItem.Checked := True;
  ScaleBtn.Down := True;
end;

procedure TBicubicEditor.RotateItemClick(Sender: TObject);
begin
  Mode := bmRotate;
  RotateItem.Checked := True;
  RotateBtn.Down := True;
end;

procedure TBicubicEditor.CreateItemClick(Sender: TObject);
begin
  Mode := bmCreate;
  CreateItem.Checked := True;
  NewBtn.Down := True;
end;

procedure TBicubicEditor.DeleteItemClick(Sender: TObject);
var
  i: integer;
  deleting: boolean;
  patch: TBicubicPatch;

begin
  if BicubicShape.Patches.Count > 1 then
  begin
    if MessageDlg('Are you sure you want to delete selected patch?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      deleting := True;
      while deleting do
      begin
        deleting := False;
        for i := 0 to BicubicShape.Patches.Count - 1 do
        begin
          patch := BicubicShape.Patches[i];
          if patch.HasAllSelected then
          begin
            BicubicShape.Patches.Remove(patch);
            patch.Free;
            deleting := True;
            break;
          end;
        end;
      end;
      PaintBox.Refresh;
    end;
  end
  else
    MessageDlg('You cannot delete last patch', mtError, [mbOK], 0);
end;

procedure TBicubicEditor.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);

  dlg.Grid.Text := FloatToStrF(Grid, ffFixed, 4, 3);

  if dlg.ShowModal = idOK then
    Grid := StrToFloat(dlg.Grid.Text);

  dlg.Free;
end;

procedure TBicubicEditor.ZoomItemClick(Sender: TObject);
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

procedure TBicubicEditor.CenterViewItemClick(Sender: TObject);
begin
  CenterView;
end;



end.
