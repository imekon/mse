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

unit halodlg;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections,
  VCL.Graphics, VCL.Forms, VCL.Controls, VCL.StdCtrls, VCL.Buttons,
  VCL.ExtCtrls, VCL.ComCtrls,
  maptext, scene;

type
  THaloDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Name: TEdit;
    PageControl: TPageControl;
    Details: TTabSheet;
    Label2: TLabel;
    HaloType: TComboBox;
    Label3: TLabel;
    HaloDensity: TComboBox;
    Label4: TLabel;
    HaloMapping: TComboBox;
    Label5: TLabel;
    DustType: TComboBox;
    Label6: TLabel;
    Eccentricity: TEdit;
    Label7: TLabel;
    MaxValue: TEdit;
    Label8: TLabel;
    Exponent: TEdit;
    AntiAliasing: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    TurbulenceBtn: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Transforms: TTabSheet;
    Samples: TEdit;
    AALevel: TEdit;
    AAThreshold: TEdit;
    Jitter: TEdit;
    Frequency: TEdit;
    Phase: TEdit;
    Label15: TLabel;
    XTrans: TEdit;
    YTrans: TEdit;
    ZTrans: TEdit;
    XScale: TEdit;
    YScale: TEdit;
    ZScale: TEdit;
    XRotate: TEdit;
    YRotate: TEdit;
    ZRotate: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    ColourMap: TTabSheet;
    MapPanel: TPanel;
    EditMap: TButton;
    MapImage: TImage;

    procedure ClearMaps;
    procedure TurbulenceBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMapClick(Sender: TObject);
    procedure SetMaps(list: TList<TMapItem>);
    procedure GetMaps(list: TList<TMapItem>);
  private
    { Private declarations }
    DrawingContext: IDrawingContext;
  public
    { Public declarations }
    Turbulence: double;
    Octaves: Integer;
    Lambda: double;
    Omega: double;
    Maps: TList<TMapItem>;

    procedure SetDrawingContext(context: IDrawingContext);
  end;

var
  HaloDialog: THaloDialog;

implementation

uses turbulence, colmap;

{$R *.DFM}

procedure THaloDialog.TurbulenceBtnClick(Sender: TObject);
var
  dlg: TTurbulenceDialog;

begin
  dlg := TTurbulenceDialog.Create(Application);

  dlg.Turbulence.Text := FloatToStrF(Turbulence, ffFixed, 6, 4);
  dlg.Octaves.Text := IntToStr(Octaves);
  dlg.Lambda.Text := FloatToStrF(Lambda, ffFixed, 6, 4);
  dlg.Omega.Text := FloatToStrF(Omega, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Turbulence := StrToFloat(dlg.Turbulence.Text);
    Octaves := StrToInt(dlg.Octaves.Text);
    Lambda := StrToFloat(dlg.Lambda.Text);
    Omega := StrToFloat(dlg.Omega.Text);
  end;

  dlg.Free;
end;

procedure THaloDialog.FormCreate(Sender: TObject);
var
  bitmap: TBitmap;

begin
  DrawingContext := nil;

  Turbulence := 0;
  Octaves := 6;
  Lambda := 2;
  Omega := 0.5;
  Maps := TList<TmapItem>.Create;

  bitmap := TBitmap.Create;
  bitmap.Width := MapImage.Width;
  bitmap.Height := MapImage.Height;
  MapImage.Picture.Graphic := bitmap;
end;

procedure THaloDialog.ClearMaps;
var
  i: integer;
  map: TMapItem;

begin
  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    map.Free;
  end;
  Maps.Clear;
end;

procedure THaloDialog.FormDestroy(Sender: TObject);
begin
  ClearMaps;
  Maps.Destroy;
end;

procedure THaloDialog.EditMapClick(Sender: TObject);
var
  dlg: TColourMapDialog;

begin
  dlg := TColourMapDialog.Create(Application);

  dlg.SetDrawingContext(DrawingContext);
  dlg.SetMaps(Maps);

  if dlg.ShowModal = idOK then
  begin
    ClearMaps;
    dlg.GetMaps(Maps);
    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
  end;

  dlg.Free;
end;

procedure THaloDialog.SetDrawingContext(context: IDrawingContext);
begin
  DrawingContext := context;
end;

procedure THaloDialog.SetMaps(list: TList<TMapItem>);
var
  i: integer;
  map, newmap: TMapItem;

begin
  for i := 0 to list.Count - 1 do
  begin
    map := list[i];
    if map is TMapItem then
    begin
      newmap := TMapItem.Create;
      newmap.Copy(map);
      Maps.Add(newmap);
    end;
  end;

  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
end;

procedure THaloDialog.GetMaps(list: TList<TMapItem>);
var
  i: integer;
  map, newmap: TMapItem;

begin
  for i := 0 to Maps.Count - 1 do
  begin
    map := Maps[i];
    newmap := TMapItem.Create;
    newmap.Copy(map);
    list.Add(newmap);
  end;
end;

end.
