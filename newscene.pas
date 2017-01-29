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

unit newscene;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TNewSceneDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Image: TImage;
    ListBox: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Blank, Simple, Wizard: TBitmap;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNewSceneDlg.FormCreate(Sender: TObject);
begin
  ListBox.ItemIndex := 0;

  Blank := TBitmap.Create;
  Blank.LoadFromResourceID(HInstance, 1000);

  Simple := TBitmap.Create;
  Simple.LoadFromResourceID(HInstance, 1001);

  Wizard := TBitmap.Create;
  Wizard.LoadFromResourceID(HInstance, 1002);

  Image.Picture.Bitmap := Blank;
end;

procedure TNewSceneDlg.ListBoxClick(Sender: TObject);
begin
  case ListBox.ItemIndex of
    0: Image.Picture.Bitmap := Blank;
    1: Image.Picture.Bitmap := Simple;
    2: Image.Picture.Bitmap := Wizard;
  end;
end;

procedure TNewSceneDlg.FormDestroy(Sender: TObject);
begin
  Blank.Free;
  Simple.Free;
  Wizard.Free;
end;

end.
