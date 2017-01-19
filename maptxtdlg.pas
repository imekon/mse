{ 21/09/00 10:55:19 AM (GMT) > [Goodwin on BIGPC] checked out / }
unit maptxtdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, ComCtrls, Texture, MapText, Menus, Textdlg;

type
  TMapTextDialog = class(TTextureDlg)
    Label22: TLabel;
    TypeLabel: TLabel;
    MapPanel: TPanel;
    EditMapBtn: TButton;
    MapImage: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMapBtnClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetTemporaryTexture: TTexture; override;
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    Maps: TList;
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses rgbft, colmap;

{$R *.DFM}

procedure TMapTextDialog.SetTexture(ATexture: TTexture);
var
  i: integer;
  map: TMapTexture;
  mapitem2, mapitem: TMapItem;

begin
  inherited SetTexture(ATexture);

  map := theTexture as TMapTexture;

  for i := 0 to map.Maps.Count - 1 do
  begin
    mapitem := map.Maps[i];
    mapitem2 := TMapItem.Create;
    mapitem2.Copy(mapitem);
    Maps.Add(mapitem2);
  end;

  TypeLabel.Caption := TextureNames[map.mapType];

  DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
end;

function TMapTextDialog.GetTemporaryTexture: TTexture;
begin
  result := TMapTexture.Create;
end;

procedure TMapTextDialog.GetIntoTexture(texture: TTexture);
var
  i: integer;
  map: TMapTexture;
  mapitem2, mapitem: TMapItem;

begin
  inherited GetIntoTexture(texture);

  map := texture as TMapTexture;

  for i := 0 to map.Maps.Count - 1 do
  begin
    mapitem := map.Maps[i];
    mapitem.Free;
  end;

  map.Maps.Clear;

  for i := 0 to Maps.Count - 1 do
  begin
    mapitem := Maps[i];
    mapitem2 := TMapItem.Create;
    mapitem2.Copy(mapitem);
    map.Maps.Add(mapitem2);
  end;
end;

procedure TMapTextDialog.FormCreate(Sender: TObject);
var
  bitmap: TBitmap;

begin
  inherited;

  Maps := TList.Create;

  bitmap := TBitmap.Create;
  bitmap.Width := MapImage.Width;
  bitmap.Height := MapImage.Height;

  MapImage.Picture.Graphic := bitmap;
end;

procedure TMapTextDialog.FormDestroy(Sender: TObject);
begin
  inherited;

  Maps.Free;
end;

procedure TMapTextDialog.EditMapBtnClick(Sender: TObject);
var
  dlg: TColourMapDialog;

begin
  inherited;

  dlg := TColourMapDialog.Create(Application);

  dlg.SetMaps(Maps);

  if dlg.ShowModal = idOK then
  begin
    Maps.Clear;
    dlg.GetMaps(Maps);
    DrawMap(MapImage.Width, MapImage.Height, MapImage.Canvas, Maps);
  end;

  dlg.Free;
end;

end.
