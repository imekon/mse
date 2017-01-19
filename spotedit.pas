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

unit spotedit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  lightedit, StdCtrls;

type
  TSpotLightEditorDlg = class(TLightEditorDlg)
    GroupBox2: TGroupBox;
    Label6: TLabel;
    XPoint: TEdit;
    Label7: TLabel;
    YPoint: TEdit;
    Label8: TLabel;
    ZPoint: TEdit;
    Radius: TEdit;
    Label10: TLabel;
    Falloff: TEdit;
    Label11: TLabel;
    Tightness: TEdit;
    Label12: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
