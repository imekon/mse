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

unit fogdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TFogDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    FogEnabled: TCheckBox;
    PageControl: TPageControl;
    FogSheet: TTabSheet;
    TransSheet: TTabSheet;
    Label1: TLabel;
    FogType: TComboBox;
    Label2: TLabel;
    Distance: TEdit;
    ColourBtn: TButton;
    TurbulenceBtn: TButton;
    Label3: TLabel;
    Offset: TEdit;
    Label4: TLabel;
    Altitude: TEdit;
    UpBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FogDialog: TFogDialog;

implementation

{$R *.DFM}

end.
