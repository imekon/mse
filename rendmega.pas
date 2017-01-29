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

unit rendmega;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls, Dialogs;

type
  TRenderMegaDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControl: TPageControl;
    FileSheet: TTabSheet;
    Label1: TLabel;
    SceneFile: TEdit;
    BrowseBtn: TButton;
    Label2: TLabel;
    ImageSize: TComboBox;
    Label3: TLabel;
    RenderType: TComboBox;
    OpenDialog1: TOpenDialog;
    ShadedSheet: TTabSheet;
    Shadows: TCheckBox;
    Reflection: TCheckBox;
    Refraction: TCheckBox;
    Label4: TLabel;
    Edges: TComboBox;
    Label5: TLabel;
    Facets: TEdit;
    FacetUpDown: TUpDown;
    Label6: TLabel;
    Scanning: TComboBox;
    AntiAliasing: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RenderMegaDlg: TRenderMegaDlg;

implementation

{$R *.DFM}

end.
