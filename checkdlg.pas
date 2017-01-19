unit checkdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  colourdlg, StdCtrls, Buttons, ExtCtrls, ComCtrls, texture, Menus;

type
  TCheckerDialog = class(TColourDialog)
    Label21: TLabel;
    Red2: TEdit;
    Label22: TLabel;
    Green2: TEdit;
    Label23: TLabel;
    Blue2: TEdit;
    Label24: TLabel;
    Filter2: TEdit;
    Label25: TLabel;
    Transmit2: TEdit;
    Col2Btn: TBitBtn;
    procedure Col2BtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetColour2;
    procedure GetColour2IntoTexture(texture: TTexture);
    procedure GetColour2;
  protected
    function GetTemporaryTexture: TTexture; override;
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses rgbft, checker;

{$R *.DFM}

function TCheckerDialog.GetTemporaryTexture: TTexture;
begin
  result := TCheckerTexture.Create;
end;

procedure TCheckerDialog.SetColour2;
var
  checker: TCheckerTexture;

begin
  checker := theTexture as TCheckerTexture;

  Red2.Text := FloatToStrF(checker.Red2, ffFixed, 6, 4);
  Green2.Text := FloatToStrF(checker.Green2, ffFixed, 6, 4);
  Blue2.Text := FloatToStrF(checker.Blue2, ffFixed, 6, 4);
  Transmit2.Text := FloatToStrF(checker.Transmit2, ffFixed, 6, 4);
  Filter2.Text := FloatToStrF(checker.Filter2, ffFixed, 6, 4);
end;

procedure TCheckerDialog.GetColour2IntoTexture(texture: TTexture);
var
  checker: TCheckerTexture;

begin
  checker := texture as TCheckerTexture;

  checker.Red2 := StrToFloat(Red2.Text);
  checker.Green2 := StrToFloat(Green2.Text);
  checker.Blue2 := StrToFloat(Blue2.Text);
  checker.Filter2 := StrToFloat(Filter2.Text);
  checker.Transmit2 := StrToFloat(Transmit2.Text);
end;

procedure TCheckerDialog.GetColour2;
begin
  GetColour2IntoTexture(theTexture);
end;

procedure TCheckerDialog.SetTexture(ATexture: TTexture);
begin
  inherited SetTexture(ATexture);

  SetColour2;
end;

procedure TCheckerDialog.GetIntoTexture(texture: TTexture);
begin
  inherited GetIntoTexture(texture);

  GetColour2IntoTexture(texture);
end;

procedure TCheckerDialog.Col2BtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;
  checker: TCheckerTexture;

begin
  checker := theTexture as TCheckerTexture;

  dlg := TRGBFTDlg.Create(Application);
  GetColour2;
  dlg.SetColour(checker.Red2,
    checker.Green2,
    checker.Blue2,
    checker.Filter2,
    checker.Transmit2);

  if dlg.ShowModal = idOK then
  begin
    dlg.GetColour(checker.Red2,
    checker.Green2,
    checker.Blue2,
    checker.Filter2,
    checker.Transmit2);
    SetColour2;
  end;

  dlg.Free;
end;

end.
