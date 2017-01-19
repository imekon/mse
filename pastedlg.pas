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

unit pastedlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TPasteDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Name: TEdit;
    Label2: TLabel;
    XTrans: TEdit;
    YTrans: TEdit;
    ZTrans: TEdit;
    Label3: TLabel;
    XScale: TEdit;
    YScale: TEdit;
    ZScale: TEdit;
    Label4: TLabel;
    XRotate: TEdit;
    YRotate: TEdit;
    ZRotate: TEdit;
    Increment: TCheckBox;
    Label5: TLabel;
    IncXTrans: TEdit;
    IncYTrans: TEdit;
    IncZTrans: TEdit;
    Label6: TLabel;
    IncXScale: TEdit;
    IncYScale: TEdit;
    IncZScale: TEdit;
    Label7: TLabel;
    IncXRotate: TEdit;
    IncYRotate: TEdit;
    IncZRotate: TEdit;
    Label8: TLabel;
    Count: TEdit;
    CountUpDown: TUpDown;
    procedure IncrementClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CanTranslate, CanScale, CanRotate: boolean;
  end;

implementation

{$R *.DFM}

procedure TPasteDialog.IncrementClick(Sender: TObject);
begin
  if Increment.Checked then
  begin
    Count.Enabled := True;
    CountUpDown.Enabled := True;

    if CanTranslate then
    begin
      IncXTrans.Enabled := True;
      IncYTrans.Enabled := True;
      IncZTrans.Enabled := True;
    end;

    if CanScale then
    begin
      IncXScale.Enabled := True;
      IncYScale.Enabled := True;
      IncZScale.Enabled := True;
    end;

    if CanRotate then
    begin
      IncXRotate.Enabled := True;
      IncYRotate.Enabled := True;
      IncZRotate.Enabled := True;
    end;
  end
  else
  begin
    Count.Enabled := False;
    CountUpDown.Enabled := False;

    IncXTrans.Enabled := False;
    IncYTrans.Enabled := False;
    IncZTrans.Enabled := False;

    IncXScale.Enabled := False;
    IncYScale.Enabled := False;
    IncZScale.Enabled := False;

    IncXRotate.Enabled := False;
    IncYRotate.Enabled := False;
    IncZRotate.Enabled := False;
  end;
end;

procedure TPasteDialog.FormCreate(Sender: TObject);
begin
  CanTranslate := False;
  CanScale := False;
  CanRotate := False;
end;

end.
