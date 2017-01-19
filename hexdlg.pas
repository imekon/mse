unit hexdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  colourdlg, StdCtrls, Buttons, ExtCtrls, ComCtrls, Texture, Menus;

type
  THexagonDialog = class(TColourDialog)
    Red2: TEdit;
    Green2: TEdit;
    Blue2: TEdit;
    Filter2: TEdit;
    Transmit2: TEdit;
    Col2Btn: TBitBtn;
    Red3: TEdit;
    Green3: TEdit;
    Blue3: TEdit;
    Filter3: TEdit;
    Transmit3: TEdit;
    Col3Btn: TBitBtn;
    procedure Col2BtnClick(Sender: TObject);
    procedure Col3BtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetColour2;
    procedure GetColour2IntoTexture(texture: TTexture);
    //procedure GetColour2;
    procedure GetColour3IntoTexture(texture: TTexture);
    procedure SetColour3;
    //procedure GetColour3;
  protected
    function GetTemporaryTexture: TTexture; override;
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses hexagon, rgbft;

{$R *.DFM}

function THexagonDialog.GetTemporaryTexture: TTexture;
begin
  result := THexagonTexture.Create;
end;

procedure THexagonDialog.SetColour2;
var
  hexagon: THexagonTexture;

begin
  hexagon := theTexture as THexagonTexture;

  Red2.Text := FloatToStrF(hexagon.Red2, ffFixed, 6, 4);
  Green2.Text := FloatToStrF(hexagon.Green2, ffFixed, 6, 4);
  Blue2.Text := FloatToStrF(hexagon.Blue2, ffFixed, 6, 4);
  Transmit2.Text := FloatToStrF(hexagon.Transmit2, ffFixed, 6, 4);
  Filter2.Text := FloatToStrF(hexagon.Filter2, ffFixed, 6, 4);
end;

procedure THexagonDialog.GetColour2IntoTexture(texture: TTexture);
var
  hexagon: THexagonTexture;

begin
  hexagon := texture as THexagonTexture;

  hexagon.Red2 := StrToFloat(Red2.Text);
  hexagon.Green2 := StrToFloat(Green2.Text);
  hexagon.Blue2 := StrToFloat(Blue2.Text);
  hexagon.Filter2 := StrToFloat(Filter2.Text);
  hexagon.Transmit2 := StrToFloat(Transmit2.Text);
end;

{procedure THexagonDialog.GetColour2;
begin
  GetColour2IntoTexture(theTexture);
end;}

procedure THexagonDialog.SetColour3;
var
  hexagon: THexagonTexture;

begin
  hexagon := theTexture as THexagonTexture;

  Red3.Text := FloatToStrF(hexagon.Red3, ffFixed, 6, 4);
  Green3.Text := FloatToStrF(hexagon.Green3, ffFixed, 6, 4);
  Blue3.Text := FloatToStrF(hexagon.Blue3, ffFixed, 6, 4);
  Transmit3.Text := FloatToStrF(hexagon.Transmit3, ffFixed, 6, 4);
  Filter3.Text := FloatToStrF(hexagon.Filter3, ffFixed, 6, 4);
end;

procedure THexagonDialog.GetColour3IntoTexture(texture: TTexture);
var
  hexagon: THexagonTexture;

begin
  hexagon := texture as THexagonTexture;

  hexagon.Red3 := StrToFloat(Red3.Text);
  hexagon.Green3 := StrToFloat(Green3.Text);
  hexagon.Blue3 := StrToFloat(Blue3.Text);
  hexagon.Filter3 := StrToFloat(Filter3.Text);
  hexagon.Transmit3 := StrToFloat(Transmit3.Text);
end;

{procedure THexagonDialog.GetColour3;
begin
  GetColour3IntoTexture(theTexture);
end;}

procedure THexagonDialog.SetTexture(ATexture: TTexture);
begin
  inherited SetTexture(ATexture);

  SetColour2;
  SetColour3;
end;

procedure THexagonDialog.GetIntoTexture(texture: TTexture);
begin
  inherited GetIntoTexture(texture);

  GetColour2IntoTexture(texture);
  GetColour3IntoTexture(texture);
end;

procedure THexagonDialog.Col2BtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;
  hexagon: THexagonTexture;

begin
  hexagon := theTexture as THexagonTexture;

  dlg := TRGBFTDlg.Create(Application);

  dlg.SetColour(hexagon.Red2,
    hexagon.Green2,
    hexagon.Blue2,
    hexagon.Filter2,
    hexagon.Transmit2);

  if dlg.ShowModal = idOK then
  begin
    dlg.GetColour(hexagon.Red2,
    hexagon.Green2,
    hexagon.Blue2,
    hexagon.Filter2,
    hexagon.Transmit2);
    SetColour2;
  end;

  dlg.Free;
end;

procedure THexagonDialog.Col3BtnClick(Sender: TObject);
var
  dlg: TRGBFTDlg;
  hexagon: THexagonTexture;

begin
  hexagon := theTexture as THexagonTexture;

  dlg := TRGBFTDlg.Create(Application);

  dlg.SetColour(hexagon.Red3,
    hexagon.Green3,
    hexagon.Blue3,
    hexagon.Filter3,
    hexagon.Transmit3);

  if dlg.ShowModal = idOK then
  begin
    dlg.GetColour(hexagon.Red3,
    hexagon.Green3,
    hexagon.Blue3,
    hexagon.Filter3,
    hexagon.Transmit3);
    SetColour3;
  end;

  dlg.Free;
end;

end.
