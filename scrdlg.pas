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

unit scrdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Dialogs;

type
  TScriptedDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    ScriptFile: TEdit;
    ScriptBrowse: TSpeedButton;
    OpenDialog: TOpenDialog;
    GroupBox1: TGroupBox;
    PropertyList: TListView;
    ScriptEdit: TSpeedButton;
    Label2: TLabel;
    Value: TComboBox;
    procedure ScriptBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses misc;

{$R *.DFM}

procedure TScriptedDialog.ScriptBrowseClick(Sender: TObject);
begin
  OpenDialog.InitialDir := GetModelDirectory;
  OpenDialog.Filename := ScriptFile.Text;

  if OpenDialog.Execute then
    ScriptFile.Text := OpenDialog.Filename;
end;

end.
