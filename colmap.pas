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

unit colmap;

interface

uses
  System.UITypes,
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections,
  VCL.Graphics, VCL.Forms,
  VCL.Dialogs, VCL.Controls, VCL.StdCtrls, VCL.Buttons, VCL.ExtCtrls,
  VCL.Clipbrd,
  maptext;

type
  TColourBlock = class
  public
    Red, Green, Blue, Filter, Transmit: double;
    constructor Create;
    procedure LoadFromStream(stream: TStream);
    procedure SaveToStream(stream: TStream);
  end;

  TColourMapDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    MapPanel: TPanel;
    ValuePanel: TPanel;
    ButtonPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Red: TEdit;
    Green: TEdit;
    Blue: TEdit;
    Filter: TEdit;
    Transmit: TEdit;
    Value: TEdit;
    ApplyBtn: TBitBtn;
    AddBtn: TButton;
    RemoveBtn: TButton;
    ValuePaintBox: TPaintBox;
    ButtonPaintBox: TPaintBox;
    MapImage: TImage;
    ColourBtn: TSpeedButton;
    CopyBtn: TSpeedButton;
    PasteBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ValuePaintBoxPaint(Sender: TObject);
    procedure ButtonPaintBoxPaint(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ValueChanged(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ButtonPaintBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ValuePaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ValuePaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ValuePaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure SliderChange(Sender: TObject);
    procedure ColourBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
  private
    { Private declarations }
    HoldApply: boolean;
    Maps: TList<TMapItem>;
    Selected: integer;

    procedure SetScrollBars;
    procedure SetCurrent(index: integer);
  public
    { Public declarations }
    procedure SetMaps(list: TList<TMapItem>);
    procedure GetMaps(list: TList<TMapItem>);
  end;

procedure DrawMap(width, height: integer; canvas: TCanvas; list: TList<TmapItem>);

implementation

uses rgbft, main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////

constructor TColourBlock.Create;
begin
  Red := 1.0;
  Green := 1.0;
  Blue := 1.0;
  Filter := 0.0;
  Transmit := 0.0;
end;

procedure TColourBlock.LoadFromStream(stream: TStream);
begin
  stream.ReadBuffer(Red, sizeof(double));
  stream.ReadBuffer(Green, sizeof(double));
  stream.ReadBuffer(Blue, sizeof(double));
  stream.ReadBuffer(Filter, sizeof(double));
  stream.ReadBuffer(Transmit, sizeof(double));
end;

procedure TColourBlock.SaveToStream(stream: TStream);
begin
  stream.WriteBuffer(Red, sizeof(double));
  stream.WriteBuffer(Green, sizeof(double));
  stream.WriteBuffer(Blue, sizeof(double));
  stream.WriteBuffer(Filter, sizeof(double));
  stream.WriteBuffer(Transmit, sizeof(double));
end;

////////////////////////////////////////////////////////////////////////////////

procedure TColourMapDialog.FormCreate(Sender: TObject);
var
  bitmap: TBitmap;

begin
  HoldApply := False;
  Selected := 0;

  Maps := TList<TMapItem>.Create;

  bitmap := TBitmap.Create;
  bitmap.Width := MapImage.Width;
  bitmap.Height := MapImage.Height;
  MapImage.Picture.Graphic := bitmap;
end;

procedure TColourMapDialog.FormDestroy(Sender: TObject);
begin
  Maps.Destroy;
end;

procedure TColourMapDialog.ValuePaintBoxPaint(Sender: TObject);
var
  i, w, h1, h2, x1, x2: integer;
  map: TMapItem;

begin
  if Maps.Count > 1 then
  begin
    w := ValuePaintBox.Width div Maps.Count;
    h1 := ValuePaintBox.Height div 3;
    h2 := h1 * 2;
    for i := 0 to Maps.Count - 1 do
    begin
      map := Maps[i];

      with ValuePaintBox.Canvas do
      begin
        if i = Selected then
          Pen.Color := clRed
        else
          Pen.Color := clBlack;

        x1 := i * w + w div 2;
        MoveTo(x1, h2);
        LineTo(x1, h1 * 3);

        x2 := trunc((ValuePaintBox.Width - 1) * map.Value);
        MoveTo(x2, 0);
        LineTo(x2, h1);

        MoveTo(x1, h2);
        LineTo(x2, h1);
      end;
    end;
  end;
end;

procedure TColourMapDialog.ButtonPaintBoxPaint(Sender: TObject);
var
  i, w: integer;
  map: TMapItem;

begin
  if Maps.Count > 1 then
  begin
    w := ButtonPaintBox.Width div Maps.Count;
    for i := 0 to Maps.Count - 1 do
    begin
      map := Maps[i];
      with ButtonPaintBox.Canvas do
      begin
        if i = Selected then
          Pen.Color := clRed
        else
          Pen.Color := clBlack;

        Brush.Color := RGB(trunc(map.Red * 255),
          trunc(map.Green * 255),
          trunc(map.Blue * 255));
        
        Rectangle(i * w, 0, i * w + w, ButtonPaintBox.Height);
      end;
    end;
  end;
end;

procedure TColourMapDialog.SetMaps(list: TList<TMapItem>);
var
  i: integer;
  map, mapcopy: TMapItem;

begin
  for i := 0 to list.Count - 1 do
  begin
    map := list[i];
    mapcopy := TMapItem.Create;
    mapcopy.Copy(map);
    Maps.Add(mapcopy);
  end;

  if Maps.Count > 1 then
    SetCurrent(0);

  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
end;

procedure TColourMapDialog.GetMaps(list: TList<TMapItem>);
var
  i: integer;
  map, mapcopy: TMapItem;

begin
  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    mapcopy := TMapItem.Create;
    mapcopy.Copy(map);
    list.Add(mapcopy);
  end;
end;

procedure TColourMapDialog.SetScrollBars;
var
  map: TMapItem;

begin
  map := Maps[Selected];

  //RedSlider.Position := trunc(map.Red * 100);
  //GreenSlider.Position := trunc(map.Green * 100);
  //BlueSlider.Position := trunc(map.Blue * 100);
  //TransmitSlider.Position := trunc(map.Transmit * 100);
  //FilterSlider.Position := trunc(map.Filter * 100);
end;

procedure TColourMapDialog.SetCurrent(index: integer);
var
  map: TMapItem;

begin
  Selected := index;

  map := Maps[index];

  HoldApply := True;

  Red.Text := FloatToStrF(map.Red, ffFixed, 6, 4);
  Green.Text := FloatToStrF(map.Green, ffFixed, 6, 4);
  Blue.Text := FloatToStrF(map.Blue, ffFixed, 6, 4);
  Transmit.Text := FloatToStrF(map.Transmit, ffFixed, 6, 4);
  Filter.Text := FloatToStrF(map.Filter, ffFixed, 6, 4);
  Value.Text := FloatToStrF(map.Value, ffFixed, 6, 4);

  HoldApply := False;

  SetScrollBars;
end;

procedure TColourMapDialog.AddBtnClick(Sender: TObject);
var
  map, map1, map2: TMapItem;

begin
  if Selected < Maps.Count - 1 then
  begin
    map1 := Maps[Selected];
    map2 := Maps[Selected + 1];

    map := TMapItem.Create;
    map.SetRGBV(map1.Red + (map2.Red - map1.Red) / 2,
      map1.Green + (map2.Green - map1.Green) / 2,
      map1.Blue + (map2.Blue - map1.Blue) / 2,
      map1.Value + (map2.Value - map1.Value) / 2);

    Maps.Insert(Selected + 1, map);

    SetCurrent(Selected + 1);
  end
  else
  begin
    map1 := Maps[Selected];

    map := TMapItem.Create;
    map.SetRGBV(map1.Red, map1.Green, map1.Blue, map1.Value + (1 - map1.Value) / 2);

    Maps.Add(map);

    SetCurrent(Maps.Count - 1);
  end;

  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
  ValuePaintBox.Refresh;
  ButtonPaintBox.Refresh;
end;

procedure TColourMapDialog.RemoveBtnClick(Sender: TObject);
begin
  if Maps.Count > 2 then
  begin
    Maps.Delete(Selected);

    if Selected > Maps.Count - 1 then
      Selected := Maps.Count - 1;

    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
    ValuePaintBox.Refresh;
    ButtonPaintBox.Refresh;
  end
  else
    MessageDlg('There should be at least two entries in a map', mtError,
      [mbOK], 0);
end;

procedure TColourMapDialog.ValueChanged(Sender: TObject);
begin
  if not HoldApply then ApplyBtn.Enabled := True;
end;

procedure TColourMapDialog.ApplyBtnClick(Sender: TObject);
var
  map: TMapItem;
  
begin
  map := Maps[Selected];

  map.Red := StrToFloat(Red.Text);
  map.Green := StrToFloat(Green.Text);
  map.Blue := StrToFloat(Blue.Text);
  map.Transmit := StrToFloat(Transmit.Text);
  map.Filter := StrToFloat(Filter.Text);
  map.Value := StrToFloat(Value.Text);

  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
  ValuePaintBox.Refresh;
  ButtonPaintBox.Refresh;

  SetScrollBars;

  ApplyBtn.Enabled := False;
end;

procedure TColourMapDialog.ButtonPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, w: integer;

begin
  w := ButtonPaintBox.Width div Maps.Count;

  for i := 0 to Maps.Count - 1 do
  begin
    if (x > i * w) and (x < i * w + w) then
    begin
      SetCurrent(i);
      break;
    end;
  end;

  ButtonPaintBox.Refresh;
  ValuePaintBox.Refresh;
end;

procedure TColourMapDialog.ValuePaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, xm: integer;
  map: TMapItem;

begin
  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    xm := trunc(map.Value * ValuePaintBox.Width);
    if abs(x - xm) < 5 then
    begin
      SetCurrent(i);
      ValuePaintBox.BeginDrag(False);
      ValuePaintBox.Refresh;
      ButtonPaintBox.Refresh;
      break;
    end;
  end;
end;

procedure TColourMapDialog.ValuePaintBoxDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  map: TMapItem;
  
begin
  HoldApply := True;

  map := Maps[Selected];

  map.Value := x / ValuePaintBox.Width;
  Value.Text := FloatToStrF(map.Value, ffFixed, 6, 4);

  ValuePaintBox.Refresh;

  HoldApply := False;

  Accept := True;
end;

procedure TColourMapDialog.ValuePaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
end;

////////////////////////////////////////////////////////////////////////////////

procedure DrawMap(width, height: integer; canvas: TCanvas; list: TList<TmapItem>);
var
  flat: boolean;
  i, j, x1, x2, n: integer;
  map, map2: TMapItem;
  r, g, b, ri, gi, bi, r1, r2, g1, g2, b1, b2: integer;
  rect: TRect;

begin
  if list.Count > 1 then
  begin
    // Examine the start and end maps
    map := list[0];
    if map.Value > 0.001 then
    begin
      r := trunc(map.Red * 255);
      g := trunc(map.Green * 255);
      b := trunc(map.Blue * 255);

      canvas.Brush.Color := RGB(r, g, b);

      x1 := trunc(map.Value * width);

      rect.left := 0;
      rect.top := 0;
      rect.right := x1;
      rect.bottom := height;

      canvas.FillRect(rect);
    end;

    map := list[list.Count - 1];
    if map.Value < 0.999 then
    begin
      r := trunc(map.Red * 255);
      g := trunc(map.Green * 255);
      b := trunc(map.Blue * 255);

      canvas.Brush.Color := RGB(r, g, b);

      x1 := trunc(map.Value * width);

      rect.left := x1;
      rect.top := 0;
      rect.right := width;
      rect.bottom := height;

      canvas.FillRect(rect);
    end;

    // Draw the intermediate steps
    for i := 0 to list.Count - 2 do
    begin
      map := list[i];
      map2 := list[i + 1];

      x1 := trunc(width * map.Value);
      x2 := trunc(width * map2.Value);

      r1 := trunc(map.Red * 255);
      g1 := trunc(map.Green * 255);
      b1 := trunc(map.Blue * 255);

      r2 := trunc(map2.Red * 255);
      g2 := trunc(map2.Green * 255);
      b2 := trunc(map2.Blue * 255);

      if (r1 = r2) and (g1 = g2) and (b1 = b2) then
        flat := True
      else
        flat := False;

      if x2 > x1 then
        with canvas do
          if flat then
          begin
            Brush.Color := RGB(r1, g1, b1);

            rect.left := x1;
            rect.top := 0;
            rect.right := x2;
            rect.bottom := height;

            FillRect(rect);
          end
          else
          begin
            n := (x2 - x1) div 2;

            ri := (r2 - r1) div n;
            gi := (g2 - g1) div n;
            bi := (b2 - b1) div n;

            for j := 0 to n - 1 do
            begin
              r := r1 + ri * j;
              g := g1 + gi * j;
              b := b1 + bi * j;

              Brush.Color := RGB(r, g, b);

              Rect.left := x1 + j * 2;
              Rect.right := x1 + j * 2 + 3;
              Rect.top := 0;
              Rect.bottom := height;

              FillRect(rect);
            end;
          end;
    end;
  end;
end;

procedure TColourMapDialog.SliderChange(Sender: TObject);
var
  redraw: boolean;
  map: TMapItem;

begin
  redraw := false;

  map := Maps[Selected];

  HoldApply := True;

  {*
  if Sender = RedSlider then
  begin
    map.Red := RedSlider.Position / 100;
    Red.Text := FloatToStrF(map.Red, ffFixed, 6, 4);
    redraw := True;
  end
  else if Sender = GreenSlider then
  begin
    map.Green := GreenSlider.Position / 100;
    Green.Text := FloatToStrF(map.Green, ffFixed, 6, 4);
    redraw := True;
  end
  else if Sender = BlueSlider then
  begin
    map.Blue := BlueSlider.Position / 100;
    Blue.Text := FloatToStrF(map.Blue, ffFixed, 6, 4);
    redraw := True;
  end
  else if Sender = FilterSlider then
  begin
    map.Filter := FilterSlider.Position / 100;
    Filter.Text := FloatToStrF(map.Filter, ffFixed, 6, 4);
  end
  else if Sender = TransmitSlider then
  begin
    map.Transmit := TransmitSlider.Position / 100;
    Transmit.Text := FloatToStrF(map.Transmit, ffFixed, 6, 4);
  end;
  *}

  HoldApply := False;

  if redraw then
  begin
    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
    ButtonPaintBox.Refresh;
  end;
end;

procedure TColourMapDialog.ColourBtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;
  map: TMapItem;

begin
  dlg := TRGBFTDlg.Create(Application);

  map := Maps[Selected];

  with map do
    dlg.SetColour(Red, Green, Blue, Filter, Transmit);

  if dlg.ShowModal = IDOK then
  begin
    with map do
      dlg.GetColour(Red, Green, Blue, Filter, Transmit);

    Red.Text := FloatToStrF(map.Red, ffFixed, 6, 4);
    Green.Text := FloatToStrF(map.Green, ffFixed, 6, 4);
    Blue.Text := FloatToStrF(map.Blue, ffFixed, 6, 4);
    Filter.Text := FloatToStrF(map.Filter, ffFixed, 6, 4);
    Transmit.Text := FloatToStrF(map.Transmit, ffFixed, 6, 4);

    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
    ButtonPaintBox.Refresh;
    SetScrollBars;
  end;

  dlg.Free;
end;

procedure TColourMapDialog.CopyBtnClick(Sender: TObject);
var
  map: TMapItem;
  col: TColourBlock;
  mem: TMemoryStream;
  handle: HGLOBAL;
  ptr: Pointer;

begin
  map := Maps[Selected];

  mem := TMemoryStream.Create;
  col := TColourBlock.Create;

  col.Red := map.Red;
  col.Green := map.Green;
  col.Blue := map.Blue;
  col.Filter := map.Filter;
  col.Transmit := map.Transmit;

  col.SaveToStream(mem);

  // Get a global handle
  handle := GlobalAlloc(ghnd, mem.Size);

  // Get the pointer
  ptr := GlobalLock(handle);

  // Copy the memory from the stream to the global block
  CopyMemory(ptr, mem.Memory, mem.Size);

  // Open the clipboard
  Clipboard.Open;

  // Move the global buffer into the clipboard
  Clipboard.SetAsHandle(MainForm.ColourClipForm, handle);

  // Put text in as well
  Clipboard.AsText := 'Map';

  // All done
  Clipboard.Close;

  col.Free;
  mem.Free;
end;

procedure TColourMapDialog.PasteBtnClick(Sender: TObject);
var
  map: TMapItem;
  col: TColourBlock;
  mem: TMemoryStream;
  handle: HGLOBAL;
  size: DWORD;

begin
  if Clipboard.HasFormat(MainForm.ColourClipForm) then
  begin
    // Open the clipboard
    Clipboard.Open;

    // Get the handle of the shape on the clipboard
    handle := Clipboard.GetAsHandle(MainForm.ColourClipForm);

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

    map := Maps[Selected];

    col := TColourBlock.Create;

    col.LoadFromStream(mem);

    map.Red := col.Red;
    map.Green := col.Green;
    map.Blue := col.Blue;
    map.Filter := col.Filter;
    map.Transmit := col.Transmit;

    SetScrollBars;

    col.Free;
    mem.Free;

    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
    ButtonPaintBox.Refresh;
  end;
end;

end.
