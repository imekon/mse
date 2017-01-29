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

unit settings;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs;

type
  TSettingsDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    POVray: TEdit;
    BrowseBtn: TButton;
    OpenDialog: TOpenDialog;
    Label2: TLabel;
    CoolRay: TEdit;
    CoolRayBrowse: TButton;
    procedure BrowseBtnClick(Sender: TObject);
    procedure CoolRayBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TSettingsDialog.BrowseBtnClick(Sender: TObject);
begin
  OpenDialog.Filename := POVray.Text;
  if OpenDialog.Execute then
    POVray.Text := OpenDialog.Filename;
end;

procedure TSettingsDialog.CoolRayBrowseClick(Sender: TObject);
begin
  OpenDialog.Filename := CoolRay.Text;
  if OpenDialog.Execute then
    CoolRay.Text := OpenDialog.Filename;
end;

end.
