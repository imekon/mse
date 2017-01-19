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

unit turbframe;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TTurbulenceFrame = class(TFrame)
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Turbulence: TEdit;
    Label10: TLabel;
    Octaves: TEdit;
    Label11: TLabel;
    Lambda: TEdit;
    Label12: TLabel;
    Omega: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetTurbulence(t: double; o: integer; l, om: double);
    procedure GetTurbulence(var t: double; var o: integer; var l, om: double);
  end;

implementation

{$R *.DFM}

procedure TTurbulenceFrame.SetTurbulence(t: double; o: integer; l, om: double);
begin
  Turbulence.Text := Format('%8.6f', [t]);
  Octaves.Text := Format('%d', [o]);
  Lambda.Text := Format('%8.6f', [l]);
  Omega.Text := Format('%8.6f', [om]);
end;

procedure TTurbulenceFrame.GetTurbulence(var t: double; var o: integer; var l, om: double);
begin
  t := StrToFloat(Turbulence.Text);
  o := StrToInt(Octaves.Text);
  l := StrToFloat(Lambda.Text);
  om := StrToFloat(Omega.Text);
end;

end.
