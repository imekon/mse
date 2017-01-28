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

unit PolyEdit;

interface

uses
  System.Contnrs, System.UITypes, System.Types,
  Windows, Messages, SysUtils, Math, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Tabs, StdCtrls, Menus, Clipbrd, Vector, Scene, Polygon, Buttons,
  ToolWin, ComCtrls;

const
  UnitSize = 50;

type
  TPolyEditorView = (peFront, peBack, peTop, peBottom, peLeft, peRight);

  TPolyEditorMode = (pmSelect, pmTranslate, pmScale, pmRotate, pmCreate);

  TPolyEditor = class(TForm)
    ButtonBar: TPanel;
    StatusPanel: TPanel;
    CloseBtn: TButton;
    TabSet: TTabSet;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    Exit1: TMenuItem;
    OptionsMenu: TMenuItem;
    ScalingItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    PolygonMenu: TMenuItem;
    SelectItem: TMenuItem;
    TranslateItem: TMenuItem;
    Create1: TMenuItem;
    N1: TMenuItem;
    TriangleItem: TMenuItem;
    EditMenu: TMenuItem;
    ClearAllItem: TMenuItem;
    SelectAllItem: TMenuItem;
    MeshItem: TMenuItem;
    SphereItem: TMenuItem;
    CubeItem: TMenuItem;
    ConeItem: TMenuItem;
    CylinderItem: TMenuItem;
    DiskItem: TMenuItem;
    N2: TMenuItem;
    DeleteItem: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    ScaleItem: TMenuItem;
    RotateItem: TMenuItem;
    CenterViewItem: TMenuItem;
    CoolBar: TCoolBar;
    Toolbar: TPanel;
    SelectBtn: TSpeedButton;
    TranslateBtn: TSpeedButton;
    TriangleBtn: TSpeedButton;
    MeshBtn: TSpeedButton;
    SphereBtn: TSpeedButton;
    CubeBtn: TSpeedButton;
    ConeBtn: TSpeedButton;
    CylinderBtn: TSpeedButton;
    DiscBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    CutBtn: TSpeedButton;
    CopyBtn: TSpeedButton;
    PasteBtn: TSpeedButton;
    ScaleBtn: TSpeedButton;
    RotateBtn: TSpeedButton;
    Selection: TComboBox;
    EditBar: TPanel;
    GridBtn: TSpeedButton;
    ZoomBtn: TSpeedButton;
    ApplyBtn: TBitBtn;
    Xpt: TEdit;
    YPt: TEdit;
    ZPt: TEdit;
    SmoothShaded: TCheckBox;
    N5: TMenuItem;
    Flip1: TMenuItem;
    FlipXItem: TMenuItem;
    FlipYItem: TMenuItem;
    FlipZItem: TMenuItem;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure TabSetClick(Sender: TObject);
    procedure ScalingItemClick(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectItemClick(Sender: TObject);
    procedure TranslateItemClick(Sender: TObject);
    procedure TriangleItemClick(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ClearAllItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure MeshItemClick(Sender: TObject);
    procedure SphereItemClick(Sender: TObject);
    procedure CubeItemClick(Sender: TObject);
    procedure ConeItemClick(Sender: TObject);
    procedure CylinderItemClick(Sender: TObject);
    procedure DiskItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure ScaleItemClick(Sender: TObject);
    procedure RotateItemClick(Sender: TObject);
    procedure CenterViewItemClick(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure FlipXItemClick(Sender: TObject);
    procedure FlipYItemClick(Sender: TObject);
    procedure FlipZItemClick(Sender: TObject);
  private
    { Private declarations }
    Polygon: TPolygon;
    View: TPolyEditorView;
    ScaleMult, ScaleDiv: integer;
    Grid: double;
    Mode: TPolyEditorMode;
    CreateWhat: TPolygonShapes;
    SelectRect: TRect;
    FirstDrag: boolean;
    Anchor: TVector;

    procedure CenterView;
    procedure GetPoint(triangle: TTriangle; pt: integer; var x, y: integer);
    procedure AdjustPoint(X, Y: integer;
      var point: TPoint;
      var xx, yy, zz: double;
      var xb, yb, zb: boolean);
    procedure CopyTriangles;
    procedure DeleteTriangles;
  public
    { Public declarations }
    procedure SetPolygon(APolygon: TPolygon);
  end;

var
  PolyEditor: TPolyEditor;

implementation

uses polyscale, main, misc, Sphere, Solid, discdlg, disc, meshdlg,
  grid, zoom, About, engine;

{$R *.DFM}

procedure TPolyEditor.AdjustPoint(X, Y: integer;
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
    peFront:
    begin
      xx := xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    peBack:
    begin
      xx := -xi;
      yy := yi;
      zz := 0;
      xb := True;
      yb := True;
      zb := False;
    end;

    peLeft:
    begin
      xx := 0;
      yy := yi;
      zz := xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    peRight:
    begin
      xx := 0;
      yy := yi;
      zz := -xi;
      xb := False;
      yb := True;
      zb := True;
    end;

    peTop:
    begin
      xx := xi;
      yy := 0;
      zz := yi;
      xb := True;
      yb := False;
      zb := True;
    end;

    peBottom:
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

procedure TPolyEditor.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TPolyEditor.SetPolygon(APolygon: TPolygon);
begin
  Polygon := APolygon;
  Caption := 'Polygon Editor - ' + Polygon.Name;
  SmoothShaded.Checked := Polygon.SmoothShaded;
  Show;
  CenterView;
end;

procedure TPolyEditor.GetPoint(triangle: TTriangle; pt: integer; var x, y: integer);
begin
  case View of
    peFront:
      begin
        x := trunc(triangle.Points[pt].X * UnitSize);
        y := -trunc(triangle.Points[pt].Y * UnitSize);
      end;

    peBack:
      begin
        x := -trunc(triangle.Points[pt].X * UnitSize);
        y := -trunc(triangle.Points[pt].Y * UnitSize);
      end;

    peTop:
      begin
        x := trunc(triangle.Points[pt].X * UnitSize);
        y := -trunc(triangle.Points[pt].Z * UnitSize);
      end;

    peBottom:
      begin
        x := -trunc(triangle.Points[pt].X * UnitSize);
        y := -trunc(triangle.Points[pt].Z * UnitSize);
      end;

    peLeft:
      begin
        x := trunc(triangle.Points[pt].Z * UnitSize);
        y := -trunc(triangle.Points[pt].Y * UnitSize);
      end;

    peRight:
      begin
        x := -trunc(triangle.Points[pt].Z * UnitSize);
        y := -trunc(triangle.Points[pt].Y * UnitSize);
      end;
  end;

  x := x * ScaleMult div ScaleDiv;
  y := y * ScaleMult div ScaleDiv;
end;

procedure TPolyEditor.CloseBtnClick(Sender: TObject);
begin
  Polygon.SmoothShaded := SmoothShaded.Checked;
  Polygon.Make(MainForm.SceneManager, Polygon.Triangles);
  MainForm.MainPaintBox.Refresh;
  Close;
end;

procedure TPolyEditor.FormCreate(Sender: TObject);
begin
  Polygon := nil;
  Grid := 0;
  ScaleMult := 1;
  ScaleDiv := 1;
  View := peFront;
  Mode := pmSelect;
  CreateWhat := psTriangle;
  Selection.ItemIndex := 0;
  Anchor := TVector.Create;
end;

procedure TPolyEditor.PaintBoxPaint(Sender: TObject);
var
  i, xi, yi: integer;
  triangle: TTriangle;

begin
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    Pen.Mode := pmCopy;

    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);
    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);

    for i := 0 to Self.Polygon.Triangles.Count - 1 do
    begin
      triangle := Self.Polygon.Triangles[i] as TTriangle;

      Pen.Color := clWhite;

      GetPoint(triangle, 1, xi, yi);
      MoveTo(xi + ViewSize, yi + ViewSize);

      Pen.Color := clRed;

      if triangle.Points[1].Selected then
        Rectangle(xi + ViewSize - 4, yi + ViewSize - 4,
          xi + ViewSize + 4, yi + ViewSize + 4);

      Pen.Color := clWhite;

      GetPoint(triangle, 2, xi, yi);
      LineTo(xi + ViewSize, yi + ViewSize);

      Pen.Color := clRed;

      if triangle.Points[2].Selected then
        Rectangle(xi + ViewSize - 4, yi + ViewSize - 4,
          xi + ViewSize + 4, yi + ViewSize + 4);

      Pen.Color := clWhite;

      GetPoint(triangle, 3, xi, yi);
      LineTo(xi + ViewSize, yi + ViewSize);

      Pen.Color := clRed;

      if triangle.Points[3].Selected then
        Rectangle(xi + ViewSize - 4, yi + ViewSize - 4,
          xi + ViewSize + 4, yi + ViewSize + 4);

      Pen.Color := clWhite;

      GetPoint(triangle, 1, xi, yi);
      LineTo(xi + ViewSize, yi + ViewSize);
    end;
  end;
end;

procedure TPolyEditor.TabSetClick(Sender: TObject);
begin
  case TabSet.TabIndex of
    0: View := peFront;
    1: View := peBack;
    2: View := peTop;
    3: View := peBottom;
    4: View := peLeft;
    5: View := peRight;
  end;
  PaintBox.Refresh;
end;

procedure TPolyEditor.ScalingItemClick(Sender: TObject);
var
  dlg: TPolyScaleDlg;

begin
  dlg := TPolyScaleDlg.Create(Application);
  dlg.Name.Text := Polygon.Name;
  dlg.Maximum.Text := FloatToStrF(Polygon.GetMaximum, ffFixed, 6, 4);
  if dlg.ShowModal = idOK then
  begin
    Polygon.Scaling(StrToFloat(dlg.Scaling.Text));
    PaintBox.Refresh;
  end;
  dlg.Free;
end;

procedure TPolyEditor.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;

begin
  AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
  StatusPanel.Caption := 'X: ' + FloatToStrF(xx, ffFixed, 4, 3) +
    ' Y: ' + FloatToStrF(yy, ffFixed, 4, 3) +
    ' Z: ' + FloatToStrF(zz, ffFixed, 4, 3);
end;

procedure TPolyEditor.SelectItemClick(Sender: TObject);
begin
  Mode := pmSelect;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
end;

procedure TPolyEditor.TranslateItemClick(Sender: TObject);
begin
  Mode := pmTranslate;
  TranslateItem.Checked := True;
  TranslateBtn.Down := True;
end;

procedure TPolyEditor.TriangleItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psTriangle;
  TriangleItem.Checked := True;
  TriangleBtn.Down := True;
end;

procedure TPolyEditor.PaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, width, height: integer;
  r, h: double;
  triangle: TTriangle;
  point: TPoint;
  xx, yy, zz: double;
  xb, yb, zb: boolean;
  disc: TDiscDialog;
  mesh: TMeshDialog;

begin
  case Mode of
    pmSelect:
    begin
      SelectRect.left := x;
      SelectRect.right := x;
      SelectRect.top := y;
      SelectRect.bottom := y;
      FirstDrag := False;
      PaintBox.BeginDrag(False);
    end;

    pmTranslate, pmScale, pmRotate:
    begin
      AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
      Anchor.X := xx;
      Anchor.Y := yy;
      Anchor.Z := zz;
      for i := 0 to Polygon.Triangles.Count - 1 do
      begin
        triangle := Polygon.Triangles[i] as TTriangle;
        triangle.SetAnchor;
      end;
      PaintBox.BeginDrag(False);
    end;

    pmCreate:
    begin
      AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
      case CreateWhat of
        psTriangle: CreatePolygonTriangle(Polygon, xx, yy, zz);
        psSphere: CreateSphere(Polygon, xx, yy, zz);
        psCube: CreateCube(Polygon, xx, yy, zz);
        psCone: CreateSolidShape(Polygon, xx, yy, zz, ConeSolid);
        psCylinder: CreateSolidShape(Polygon, xx, yy, zz, CylinderSolid);

        psMesh:
        begin
          mesh := TMeshDialog.Create(Application);
          if mesh.ShowModal = idOK then
          begin
            width := StrToInt(mesh.Width.Text);
            height := StrToInt(mesh.Height.Text);
            CreatePolygonSheet(Polygon, width, height, xx, yy, zz);
          end;
          mesh.Free;
        end;

        psDisc:
        begin
          disc := TDiscDialog.Create(Application);
          if disc.ShowModal = idOK then
          begin
            r := StrToFloat(disc.Radius.Text);
            h := StrToFloat(disc.Hole.Text);
            CreateDisc(Polygon, r, h, xx, yy, zz);
          end;
          disc.Free;
        end;
      end;

      Mode := pmSelect;
      SelectItem.Checked := True;
      SelectBtn.Down := True;
      PaintBox.Refresh;
    end;
  end;
end;

procedure TPolyEditor.PaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  i: integer;
  triangle: TTriangle;
  point: TPoint;
  xx, yy, zz, xd, yd, zd: double;
  xb, yb, zb: boolean;

begin
  if Source = PaintBox then
  begin
    case Mode of
      pmSelect:
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

      pmTranslate:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          for i := 0 to Polygon.Triangles.Count - 1 do
          begin
            triangle := Polygon.Triangles[i] as TTriangle;
            triangle.SetTranslate(xx - Anchor.x,
              yy - Anchor.y,
              zz - Anchor.z,
              xb, yb, zb);
          end;

          PaintBox.Refresh;
        end;

      pmScale:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          for i := 0 to Polygon.Triangles.Count - 1 do
          begin
            triangle := Polygon.Triangles[i] as TTriangle;
            triangle.SetScale(xx - Anchor.x,
              yy - Anchor.y,
              zz - Anchor.z,
              xb, yb, zb);
          end;

          PaintBox.Refresh;
        end;

      pmRotate:
        begin
          AdjustPoint(X, Y, point, xx, yy, zz, xb, yb, zb);
          for i := 0 to Polygon.Triangles.Count - 1 do
          begin
            triangle := Polygon.Triangles[i] as TTriangle;

            xd := 0;
            yd := 0;
            zd := 0;

            if xb and yb then
              zd := ArcTan2(-yy, xx);

            if xb and zb then
              yd := ArcTan2(zz, xx);

            if yb and zb then
              xd := ArcTan2(yy, zz);

            triangle.SetRotate(xd, yd, zd, xb, yb, zb);
          end;

          PaintBox.Refresh;
        end;
    end;

    Accept := True
  end
  else
    Accept := False;
end;

procedure TPolyEditor.PaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  i, xi, yi: integer;
  pt: TPoint;
  triangle: TTriangle;

begin
  case Mode of
    pmSelect:
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

        for i := 0 to Polygon.Triangles.Count - 1 do
        begin
          triangle := Polygon.Triangles[i] as TTriangle;

          GetPoint(triangle, 1, xi, yi);
          pt.x := xi + ViewSize;
          pt.y := yi + ViewSize;
          if PtInRect(SelectRect, pt) then
            case Selection.ItemIndex of
              2: triangle.Points[1].SetSelected(False);
              1: triangle.Points[1].ToggleSelected;
              0: triangle.Points[1].SetSelected(True);
            end;

          GetPoint(triangle, 2, xi, yi);
          pt.x := xi + ViewSize;
          pt.y := yi + ViewSize;
          if PtInRect(SelectRect, pt) then
            case Selection.ItemIndex of
              2: triangle.Points[2].SetSelected(False);
              1: triangle.Points[2].ToggleSelected;
              0: triangle.Points[2].SetSelected(True);
            end;

          GetPoint(triangle, 3, xi, yi);
          pt.x := xi + ViewSize;
          pt.y := yi + ViewSize;
          if PtInRect(SelectRect, pt) then
            case Selection.ItemIndex of
              2: triangle.Points[3].SetSelected(False);
              1: triangle.Points[3].ToggleSelected;
              0: triangle.Points[3].SetSelected(True);
            end;
        end;

      PaintBox.Refresh;
      end;
  end;
end;

procedure TPolyEditor.ClearAllItemClick(Sender: TObject);
var
  i: integer;
  triangle: TTriangle;

begin
  for i := 0 to Polygon.Triangles.Count - 1 do
  begin
    triangle := Polygon.Triangles[i] as TTriangle;
    triangle.SetSelected(False);
  end;
  PaintBox.Refresh;
end;

procedure TPolyEditor.SelectAllItemClick(Sender: TObject);
var
  i: integer;
  triangle: TTriangle;

begin
  for i := 0 to Polygon.Triangles.Count - 1 do
  begin
    triangle := Polygon.Triangles[i] as TTriangle;
    triangle.SetSelected(True);
  end;
  PaintBox.Refresh;
end;

procedure TPolyEditor.MeshItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psMesh;
  MeshItem.Checked := True;
  MeshBtn.Down := True;
end;

procedure TPolyEditor.SphereItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psSphere;
  SphereItem.Checked := True;
  SphereBtn.Down := True;
end;

procedure TPolyEditor.CubeItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psCube;
  CubeItem.Checked := True;
  CubeBtn.Down := True;
end;

procedure TPolyEditor.ConeItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psCone;
  ConeItem.Checked := True;
  ConeBtn.Down := True;
end;

procedure TPolyEditor.CylinderItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psCylinder;
  CylinderItem.Checked := True;
  CylinderBtn.Down := True;
end;

procedure TPolyEditor.DiskItemClick(Sender: TObject);
begin
  Mode := pmCreate;
  CreateWhat := psDisc;
  DiskItem.Checked := True;
  DiscBtn.Down := True;
end;

procedure TPolyEditor.CopyTriangles;
var
  i, n: integer;
  triangle: TTriangle;
  mem: TMemoryStream;
  handle: HGLOBAL;
  ptr: Pointer;

begin
  n := 0;

  for i := 0 to Polygon.Triangles.Count - 1 do
  begin
    triangle := Polygon.Triangles[i] as TTriangle;
    if triangle.HasAllSelected then
      inc(n);
  end;

  // Create a memory stream
  mem := TMemoryStream.Create;

  // Write the number of polygons we're about to copy to the clipboard
  mem.WriteBuffer(n, sizeof(n));

  // Copy the triangles to the memory file
  for i := 0 to Polygon.Triangles.Count - 1 do
  begin
    triangle := Polygon.Triangles[i] as TTriangle;
    if triangle.HasAllSelected then
      triangle.SaveToFile(mem);
  end;

  // Get a global handle
  handle := GlobalAlloc(ghnd, mem.Size);

  // Get the pointer
  ptr := GlobalLock(handle);

  // Copy the memory from the stream to the global block
  CopyMemory(ptr, mem.Memory, mem.Size);

  // Open the clipboard
  Clipboard.Open;

  // Move the global buffer into the clipboard
  Clipboard.SetAsHandle(MainForm.PolygonClipForm, handle);

  // Put text in as well
  Clipboard.AsText := Polygon.Name;

  // All done
  Clipboard.Close;

  // Release the memory stream
  mem.Free;
end;

procedure TPolyEditor.DeleteTriangles;
var
  deleting: boolean;
  i: integer;
  triangle: TTriangle;

begin
  deleting := True;
  while deleting do
  begin
    deleting := False;
    for i := 0 to Polygon.Triangles.Count - 1 do
    begin
      triangle := Polygon.Triangles[i] as TTriangle;
      if triangle.HasAllSelected then
      begin
        deleting := True;
        Polygon.Triangles.Remove(triangle);
        break;
      end;
    end;
  end;
  PaintBox.Refresh;
end;

procedure TPolyEditor.DeleteItemClick(Sender: TObject);
begin
  if MessageDlg('Do you wish to delete the selected triangles?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DeleteTriangles;
end;

procedure TPolyEditor.CopyItemClick(Sender: TObject);
begin
  CopyTriangles;
end;

procedure TPolyEditor.PasteItemClick(Sender: TObject);
var
  i, n: integer;
  triangle: TTriangle;
  mem: TMemoryStream;
  handle: HGLOBAL;
  size: DWORD;

begin
  if Clipboard.HasFormat(MainForm.PolygonClipForm) then
  begin
    // Open the clipboard
    Clipboard.Open;

    // Get the handle of the shape on the clipboard
    handle := Clipboard.GetAsHandle(MainForm.PolygonClipForm);

    // Get the size of the shape
    size := GlobalSize(handle);

    // Create the memory stream
    mem := TMemoryStream.Create;

    // Allocate memory in stream
    mem.SetSize(size);

    // Copy from clipboard
    CopyMemory(mem.Memory, GlobalLock(handle), size);

    // Close the clipboard
    Clipboard.Close;

    // Extract the shapes from the memory stream
    mem.ReadBuffer(n, sizeof(n));

    for i := 1 to n do
    begin
      triangle := TTriangle.Create;
      triangle.LoadFromFile(mem);
      Polygon.Triangles.Add(triangle);
    end;

    // Clear memory stream
    mem.Free;

    PaintBox.Refresh;
  end;
end;

procedure TPolyEditor.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);

  dlg.Grid.Text := FloatToStrF(Grid, ffFixed, 4, 3);

  if dlg.ShowModal = idOK then
    Grid := StrToFloat(dlg.Grid.Text);

  dlg.Free;
end;

procedure TPolyEditor.ZoomItemClick(Sender: TObject);
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

procedure TPolyEditor.CutItemClick(Sender: TObject);
begin
  CopyTriangles;
  DeleteTriangles;
end;

procedure TPolyEditor.AboutItemClick(Sender: TObject);
var
  dlg: TAboutBox;

begin
  dlg := TAboutBox.Create(Application);
  dlg.ShowModal;
  dlg.Free;
end;

procedure TPolyEditor.ScaleItemClick(Sender: TObject);
begin
  Mode := pmScale;
  ScaleItem.Checked := True;
  ScaleBtn.Down := True;
end;

procedure TPolyEditor.RotateItemClick(Sender: TObject);
begin
  Mode := pmRotate;
  RotateItem.Checked := True;
  RotateBtn.Down := True;
end;

procedure TPolyEditor.CenterViewItemClick(Sender: TObject);
begin
  CenterView;
end;

procedure TPolyEditor.SelectionChange(Sender: TObject);
begin
  SelectItemClick(Sender);
end;

procedure TPolyEditor.FlipXItemClick(Sender: TObject);
begin
  Polygon.FlipX;
  
  PaintBox.Refresh;
end;

procedure TPolyEditor.FlipYItemClick(Sender: TObject);
begin
  Polygon.FlipY;

  PaintBox.Refresh;
end;

procedure TPolyEditor.FlipZItemClick(Sender: TObject);
begin
  Polygon.FlipZ;

  PaintBox.Refresh;
end;

end.
