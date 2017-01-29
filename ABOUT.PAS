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

unit About;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, VCL.Graphics, VCL.Forms,
  VCL.Controls, VCL.StdCtrls, VCL.Buttons, VCL.ExtCtrls, VCL.ComCtrls;

{$INCLUDE DirectX.inc}

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Image1: TImage;
    Label5: TLabel;
    Label6: TLabel;
    EMailLabel: TLabel;
    Version: TLabel;
    DelphiImage: TImage;
    GNUMemo: TMemo;
    LinkSheet: TTabSheet;
    SFLogo: TImage;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure EMailLabelClick(Sender: TObject);
    procedure DelphiImageClick(Sender: TObject);
    procedure SFLogoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses gang, main, misc;

{$R *.DFM}

procedure TAboutBox.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dlg: TGangScreen;

begin
  if (Button = mbRight) and (ssCtrl in Shift) then
  begin
    dlg := TGangScreen.Create(Application);
    try
      dlg.ShowModal;
    finally
      dlg.Free;
    end;
  end;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
var
  dummy, size, length: DWORD;
  data: Pointer;
  date: PChar;
  s: string;
  fixed: ^VS_FIXEDFILEINFO;
  buffer: array [0..255] of char;

begin
  size := GetFileVersionInfoSize(ModelImage, dummy);
  if size > 0 then
  begin
    data := AllocMem(size);
    GetFileVersionInfo(ModelImage, 0, size, data);
    VerQueryValue(data, '\', Pointer(fixed), length);
    VerQueryValue(data, '\StringFileInfo\080904b0\BuildDate', Pointer(date), length);
    if date <> nil then
    begin
      StrLCopy(buffer, date, length);
      buffer[length] := #0;
    end;
    s := 'Version: ' + IntToStr(HIWORD(fixed^.dwProductVersionMS)) +
      '.' + IntToStr(LOWORD(fixed^.dwProductVersionMS)) +
      ' (build ' + IntToStr(LOWORD(fixed^.dwProductVersionLS)) + ') ' + buffer;
{$IFDEF USE_DIRECTX}
    s := s + ' with DirectX support';
{$ENDIF}
    Version.Caption := s;
    FreeMem(data, size);
  end;
end;

procedure TAboutBox.EMailLabelClick(Sender: TObject);
begin
  GotoURL('mailto:mse@imekon.org');
end;

procedure TAboutBox.DelphiImageClick(Sender: TObject);
begin
  GotoURL('http://www.embarcadero.com');
end;

procedure TAboutBox.SFLogoClick(Sender: TObject);
begin
  GotoURL('http://sourceforge.net/');
end;

end.

