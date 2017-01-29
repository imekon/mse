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

unit renderdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls, Dialogs;

type
  TRenderDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    FileSheet: TTabSheet;
    Label1: TLabel;
    SceneFile: TEdit;
    SceneBrowseBtn: TButton;
    Label2: TLabel;
    ImageSize: TComboBox;
    Label3: TLabel;
    OutputType: TComboBox;
    OpenDialog: TOpenDialog;
    WaitPOV: TCheckBox;
    POVExit: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SceneBrowseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TRenderDialog.FormCreate(Sender: TObject);
begin
  OutputType.ItemIndex := 4;
end;

procedure TRenderDialog.SceneBrowseBtnClick(Sender: TObject);
begin
  OpenDialog.Filename := SceneFile.Text;
  if OpenDialog.Execute then
    SceneFile.Text := OpenDialog.Filename;
end;

end.
