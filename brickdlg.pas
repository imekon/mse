unit brickdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  colourdlg, Buttons, StdCtrls, ExtCtrls, ComCtrls, texture, Menus;

type
  TBrickDialog = class(TColourDialog)
    Red2: TEdit;
    Green2: TEdit;
    Blue2: TEdit;
    Filter2: TEdit;
    Transmit2: TEdit;
    Label22: TLabel;
    Mortar: TEdit;
    BrickSize: TBitBtn;
    Col2Btn: TBitBtn;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    procedure Col2BtnClick(Sender: TObject);
    procedure BrickSizeClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetColour2;
    procedure GetColour2;
    procedure GetColour2IntoTexture(texture: TTexture);
  protected
    function GetTemporaryTexture: TTexture; override;
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses rgbft, brick, bricksize;

{$R *.DFM}

function TBrickDialog.GetTemporaryTexture: TTexture;
begin
  result := TBrickTexture.Create;
end;

procedure TBrickDialog.SetColour2;
var
  brick: TBrickTexture;

begin
  brick := theTexture as TBrickTexture;

  Red2.Text := FloatToStrF(brick.Red2, ffFixed, 6, 4);
  Green2.Text := FloatToStrF(brick.Green2, ffFixed, 6, 4);
  Blue2.Text := FloatToStrF(brick.Blue2, ffFixed, 6, 4);
  Transmit2.Text := FloatToStrF(brick.Transmit2, ffFixed, 6, 4);
  Filter2.Text := FloatToStrF(brick.Filter2, ffFixed, 6, 4);
  Mortar.Text := FloatToStrF(brick.Mortar, ffFixed, 6, 4);
end;

procedure TBrickDialog.GetColour2IntoTexture(texture: TTexture);
var
  brick: TBrickTexture;

begin
  brick := texture as TBrickTexture;

  brick.Red2 := StrToFloat(Red2.Text);
  brick.Green2 := StrToFloat(Green2.Text);
  brick.Blue2 := StrToFloat(Blue2.Text);
  brick.Filter2 := StrToFloat(Filter2.Text);
  brick.Transmit2 := StrToFloat(Transmit2.Text);
  brick.Mortar := StrToFloat(Mortar.Text);
end;

procedure TBrickDialog.GetColour2;
begin
  GetColour2IntoTexture(theTexture);
end;

procedure TBrickDialog.SetTexture(ATexture: TTexture);
begin
  inherited SetTexture(ATexture);

  SetColour2;
end;

procedure TBrickDialog.GetIntoTexture(texture: TTexture);
begin
  inherited GetIntoTexture(texture);

  GetColour2IntoTexture(texture);
end;

procedure TBrickDialog.Col2BtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;
  brick: TBrickTexture;

begin
  inherited;

  brick := theTexture as TBrickTexture;

  dlg := TRGBFTDlg.Create(Application);
  GetColour2;
  dlg.SetColour(brick.Red2,
    brick.Green2,
    brick.Blue2,
    brick.Filter2,
    brick.Transmit2);

  if dlg.ShowModal = idOK then
  begin
    dlg.GetColour(brick.Red2,
    brick.Green2,
    brick.Blue2,
    brick.Filter2,
    brick.Transmit2);
    SetColour2;
  end;

  dlg.Free;
end;

procedure TBrickDialog.BrickSizeClick(Sender: TObject);
var
  dlg: TBrickSizeDialog;
  brick: TBrickTexture;

begin
  inherited;

  brick := theTexture as TBrickTexture;

  dlg := TBrickSizeDialog.Create(Application);

  dlg.XValue.Text := FloatToStrF(brick.BrickSize.X, ffFixed, 6, 4);
  dlg.YValue.Text := FloatToStrF(brick.BrickSize.Y, ffFixed, 6, 4);
  dlg.ZValue.Text := FloatToStrF(brick.BrickSize.Z, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    brick.BrickSize.X := StrToFloat(dlg.XValue.Text);
    brick.BrickSize.Y := StrToFloat(dlg.YValue.Text);
    brick.BrickSize.Z := StrToFloat(dlg.ZValue.Text);
  end;

  dlg.Free;
end;

end.
