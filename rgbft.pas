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

unit rgbft;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ColorGrd;

type
  TRGBFTDlg = class(TForm)
    Label1: TLabel;
    Red: TEdit;
    Label2: TLabel;
    Green: TEdit;
    Label3: TLabel;
    Blue: TEdit;
    Label4: TLabel;
    Filter: TEdit;
    Label5: TLabel;
    Transmit: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Shape: TShape;
    Bevel1: TBevel;
    Label6: TLabel;
    ColourList: TComboBox;
    procedure HelpBtnClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetColour(r, g, b, f, t: double);
    procedure GetColour(var r, g, b, f, t: double);
  end;

implementation

uses Main;

{$R *.DFM}

procedure TRGBFTDlg.SetColour(r, g, b, f, t: double);
begin
  Red.Text := FloatToStrF(r, ffFixed, 6, 4);
  Green.Text := FloatToStrF(g, ffFixed, 6, 4);
  Blue.Text := FloatToStrF(b, ffFixed, 6, 4);
  Filter.Text := FloatToStrF(f, ffFixed, 6, 4);
  Transmit.Text := FloatToStrF(t, ffFixed, 6, 4);

  //RedSlider.Position := trunc(r * 100.0);
  //GreenSlider.Position := trunc(g * 100.0);
  //BlueSlider.Position := trunc(b * 100.0);
  //FilterSlider.Position := trunc(f * 100.0);
  //TransmitSlider.Position := trunc(t * 100.0);

  Shape.Brush.Color := RGB(trunc(r * 255), trunc(g * 255), trunc(b * 255));
end;

procedure TRGBFTDlg.GetColour(var r, g, b, f, t: double);
begin
  r := StrToFloat(Red.Text);
  g := StrToFloat(Green.Text);
  b := StrToFloat(Blue.Text);
  f := StrToFloat(Filter.Text);
  t := StrToFloat(Transmit.Text);
end;

procedure TRGBFTDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TRGBFTDlg.TrackBarChange(Sender: TObject);
begin
  inherited;
  //Red.Text := FloatToStrF((RedSlider.Position / 100.0), ffFixed, 6, 4);
  //Green.Text := FloatToStrF((GreenSlider.Position / 100.0), ffFixed, 6, 4);
  //Blue.Text := FloatToStrF((BlueSlider.Position / 100.0), ffFixed, 6, 4);

  //Shape.Brush.Color := RGB((RedSlider.Position * 255) div 100,
  //  (GreenSlider.Position * 255) div 100,
  //  (BlueSlider.Position * 255) div 100);
end;

end.

