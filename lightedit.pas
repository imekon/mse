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

unit lightedit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLightEditorDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Red: TEdit;
    Label2: TLabel;
    Green: TEdit;
    Label3: TLabel;
    Blue: TEdit;
    Label4: TLabel;
    FadeDistance: TEdit;
    Label5: TLabel;
    FadePower: TEdit;
    AtmosphericAttenuation: TCheckBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label9: TLabel;
    LooksLike: TComboBox;
    Shadowless: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TLightEditorDlg.FormCreate(Sender: TObject);
begin
  LooksLike.ItemIndex := 0;
end;

end.
