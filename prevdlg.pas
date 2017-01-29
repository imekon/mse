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

unit prevdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs;

type
  TPreviewDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Shape: TComboBox;
    Floor: TCheckBox;
    Wall: TCheckBox;
    FloorColour: TButton;
    WallColour: TButton;
    ColorDialog: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure FloorColourClick(Sender: TObject);
    procedure WallColourClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FFloorColour: TColor;
    FWallColour: TColor;
  end;

implementation

{$R *.DFM}

procedure TPreviewDialog.FormCreate(Sender: TObject);
begin
  FFloorColour := clGreen;
  FWallColour := clBlue;
end;

procedure TPreviewDialog.FloorColourClick(Sender: TObject);
begin
  ColorDialog.Color := FFloorColour;
  if ColorDialog.Execute then
    FFloorColour := ColorDialog.Color;
end;

procedure TPreviewDialog.WallColourClick(Sender: TObject);
begin
  ColorDialog.Color := FWallColour;
  if ColorDialog.Execute then
    FWallColour := ColorDialog.Color;
end;

end.
