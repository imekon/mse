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

unit juliadlg;

interface

uses
  System.UITypes,
  Windows, SysUtils, Classes, Graphics, Forms, Dialogs, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TJuliaDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    XValue: TEdit;
    YValue: TEdit;
    ZValue: TEdit;
    DValue: TEdit;
    Label2: TLabel;
    JuliaType: TComboBox;
    Label3: TLabel;
    JuliaFunction: TComboBox;
    PwrX: TEdit;
    PwrY: TEdit;
    Label4: TLabel;
    MaxIteration: TEdit;
    Label5: TLabel;
    Precision: TEdit;
    Label6: TLabel;
    SliceX: TEdit;
    SliceY: TEdit;
    SliceZ: TEdit;
    SliceD: TEdit;
    Label7: TLabel;
    SliceDistance: TEdit;
    procedure JuliaFunctionChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses julia;

{$R *.DFM}

procedure TJuliaDialog.JuliaFunctionChange(Sender: TObject);
begin
  if JuliaFunction.ItemIndex = ord(jfPwr) then
  begin
    PwrX.Enabled := True;
    PwrY.Enabled := True;
  end
  else
  begin
    PwrX.Enabled := False;
    PwrY.Enabled := False;
  end;
end;

procedure TJuliaDialog.OKBtnClick(Sender: TObject);
begin
  if JuliaType.ItemIndex = 0 then
  begin
    if (JuliaFunction.ItemIndex = 0) or
      (JuliaFunction.ItemIndex = 1) then
      ModalResult := mrOK
    else
      MessageDlg('Quaternion only supports Sqr and Cube function', mtError,
        [mbOK], 0);
  end
  else
    ModalResult := mrOK;
end;

end.
