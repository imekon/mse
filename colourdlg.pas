unit colourdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  textdlg, ComCtrls, StdCtrls, Buttons, Grids, ExtCtrls, Texture, Menus;

type
  TColourDialog = class(TTextureDlg)
    Label10: TLabel;
    Red: TEdit;
    Label11: TLabel;
    Green: TEdit;
    Label12: TLabel;
    Blue: TEdit;
    Label13: TLabel;
    Filter: TEdit;
    Label14: TLabel;
    Transmit: TEdit;
    Col1Btn: TBitBtn;
    procedure Col1BtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetColour;
    procedure GetColourIntoTexture(texture: TTexture);
    procedure GetColour;
  protected
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses rgbft;

{$R *.DFM}

procedure TColourDialog.SetColour;
begin
  { colour values }
  Red.Text := FloatToStrF(theTexture.Red, ffFixed, 6, 4);
  Green.Text := FloatToStrF(theTexture.Green, ffFixed, 6, 4);
  Blue.Text := FloatToStrF(theTexture.Blue, ffFixed, 6, 4);
  Filter.Text := FloatToStrF(theTexture.Filter, ffFixed, 6, 4);
  Transmit.Text := FloatToStrF(theTexture.Transmit, ffFixed, 6, 4);
end;

procedure TColourDialog.GetColourIntoTexture(texture: TTexture);
begin
  { colour }
  texture.Red := StrToFloat(Red.Text);
  texture.Green := StrToFloat(Green.Text);
  texture.Blue := StrToFloat(Blue.Text);
  texture.Filter := StrToFloat(Filter.Text);
  texture.Transmit := StrToFloat(Transmit.Text);
end;

procedure TColourDialog.GetColour;
begin
  GetColourIntoTexture(theTexture);
end;

procedure TColourDialog.SetTexture(ATexture: TTexture);
begin
  inherited SetTexture(ATexture);

  SetColour;
end;

procedure TColourDialog.GetIntoTexture(texture: TTexture);
begin
  inherited GetIntoTexture(texture);

  GetColourIntoTexture(texture);
end;

procedure TColourDialog.Col1BtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;

begin
  inherited;

  dlg := TRGBFTDlg.Create(Application);
  GetColour;
  dlg.SetColour(theTexture.Red,
    theTexture.Green,
    theTexture.Blue,
    theTexture.Filter,
    theTexture.Transmit);

  if dlg.ShowModal = idOK then
  begin
    dlg.GetColour(theTexture.Red,
    theTexture.Green,
    theTexture.Blue,
    theTexture.Filter,
    theTexture.Transmit);
    SetColour;
  end;

  dlg.Free;
end;

end.
