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

unit textfm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs;

type
  TTextDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Font: TEdit;
    BrowseBtn: TButton;
    Label2: TLabel;
    Text: TEdit;
    Label3: TLabel;
    Thickness: TEdit;
    Label4: TLabel;
    XOffset: TEdit;
    YOffset: TEdit;
    ZOffset: TEdit;
    OpenDialog: TOpenDialog;
    procedure BrowseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTextDialog.BrowseBtnClick(Sender: TObject);
begin
  OpenDialog.Filename := Font.Text;
  if OpenDialog.Execute then
    Font.Text := OpenDialog.Filename;
end;

end.
