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

unit crepoly;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TCreatePolygonDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Polygon: TRadioGroup;
    WidthLabel: TLabel;
    Width: TEdit;
    HeightLabel: TLabel;
    Height: TEdit;
    procedure PolygonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCreatePolygonDialog.PolygonClick(Sender: TObject);
begin
  case Polygon.ItemIndex of
    1:
    begin
      Width.Enabled := True;
      Height.Enabled := True;
      WidthLabel.Caption := '&Width';
      HeightLabel.Caption := '&Height';
      Width.Text := '1';
      Height.Text := '1';
    end;

    6:
    begin
      Width.Enabled := True;
      Height.Enabled := True;
      WidthLabel.Caption := '&Radius';
      HeightLabel.Caption := '&Hole';
      Width.Text := '1';
      Height.Text := '0.5';
    end

    else
    begin
      WidthLabel.Caption := '&Width';
      HeightLabel.Caption := '&Height';
      Width.Enabled := False;
      Height.Enabled := False;
      Width.Text := '1';
      Height.Text := '1';
    end;
  end;
end;

end.
