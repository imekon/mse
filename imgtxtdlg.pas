unit imgtxtdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  textdlg, Buttons, StdCtrls, ExtCtrls, ComCtrls, Texture, Menus;

type
  TImageTextureDialog = class(TTextureDlg)
    Label10: TLabel;
    Image: TEdit;
    BrowseBtn: TButton;
    Label11: TLabel;
    MapType: TComboBox;
    procedure BrowseBtnClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetTemporaryTexture: TTexture; override;
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

{$R *.DFM}

function TImageTextureDialog.GetTemporaryTexture: TTexture;
begin
  result := TImageTexture.Create;
end;

procedure TImageTextureDialog.SetTexture(ATexture: TTexture);
var
  img: TImageTexture;

begin
  inherited SetTexture(ATexture);

  img := theTexture as TImageTexture;

  Image.Text := img.Filename;
  MapType.ItemIndex := img.MapType;
end;

procedure TImageTextureDialog.GetIntoTexture(texture: TTexture);
var
  img: TImageTexture;

begin
  inherited;

  img := texture as TImageTexture;

  img.Filename := Image.Text;
  img.MapType := MapType.ItemIndex;
end;

procedure TImageTextureDialog.BrowseBtnClick(Sender: TObject);
begin
  inherited;

  OpenDialog.Filename := Image.Text;

  if OpenDialog.Execute then
    Image.Text := OpenDialog.Filename;
end;

end.
