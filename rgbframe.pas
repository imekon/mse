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

// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)

unit rgbframe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TRGBFTFrame = class(TFrame)
    Label1: TLabel;
    Red: TEdit;
    Bevel1: TBevel;
    Label2: TLabel;
    Green: TEdit;
    Label3: TLabel;
    Blue: TEdit;
    Label4: TLabel;
    Filter: TEdit;
    Label5: TLabel;
    Transmit: TEdit;
    Label6: TLabel;
    ColourList: TComboBox;
    Shape: TShape;
    procedure TrackBarChange(Sender: TObject);
    procedure FrameClick(Sender: TObject);
  private
    { Private declarations }
    bUpdating: boolean;
  public
    { Public declarations }
    procedure SetColour(r, g, b, f, t: double);
    procedure GetColour(var r, g, b, f, t: double);
  end;

implementation

uses tracdbg;

{$R *.DFM}

procedure TRGBFTFrame.SetColour(r, g, b, f, t: double);
begin
  bUpdating := true;

  Trace('SetColour: %f %f %f %f %f', [r, g, b, f, t]);

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

  bUpdating := false;
end;

procedure TRGBFTFrame.GetColour(var r, g, b, f, t: double);
begin
  r := StrToFloat(Red.Text);
  g := StrToFloat(Green.Text);
  b := StrToFloat(Blue.Text);
  f := StrToFloat(Filter.Text);
  t := StrToFloat(Transmit.Text);
end;

procedure TRGBFTFrame.TrackBarChange(Sender: TObject);
begin
  if not bUpdating then
  begin
    //Red.Text := FloatToStrF((RedSlider.Position / 100.0), ffFixed, 6, 4);
    //Green.Text := FloatToStrF((GreenSlider.Position / 100.0), ffFixed, 6, 4);
    //Blue.Text := FloatToStrF((BlueSlider.Position / 100.0), ffFixed, 6, 4);

    //Shape.Brush.Color := RGB((RedSlider.Position * 255) div 100,
    //  (GreenSlider.Position * 255) div 100,
    //  (BlueSlider.Position * 255) div 100);
  end;
end;

procedure TRGBFTFrame.FrameClick(Sender: TObject);
begin
  bUpdating := false;
end;

end.
