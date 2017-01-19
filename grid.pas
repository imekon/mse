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

unit grid;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TGridDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Grid: TEdit;
    Grid01: TButton;
    Grid025: TButton;
    Grid05: TButton;
    NoneBtn: TButton;
    procedure Grid01Click(Sender: TObject);
    procedure Grid025Click(Sender: TObject);
    procedure Grid05Click(Sender: TObject);
    procedure NoneBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TGridDlg.Grid01Click(Sender: TObject);
begin
  Grid.Text := '0.1';
end;

procedure TGridDlg.Grid025Click(Sender: TObject);
begin
  Grid.Text := '0.25';
end;

procedure TGridDlg.Grid05Click(Sender: TObject);
begin
  Grid.Text := '0.5';
end;

procedure TGridDlg.NoneBtnClick(Sender: TObject);
begin
  Grid.Text := '0';
end;

end.
