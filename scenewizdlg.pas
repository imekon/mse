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

unit scenewizdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

const
  CameraLeft = 0;
  CameraMid = 1;
  CameraRight = 2;

  LightLeft = 0;
  LightMid = 1;
  LightRight = 2;

  ObjectSphere = 0;
  ObjectCone = 1;
  ObjectCylinder = 2;
  ObjectCube = 3;

type
  TSceneWizardDlg = class(TForm)
    Panel: TPanel;
    Image: TImage;
    NextBtn: TButton;
    CancelBtn: TButton;
    PageControl: TPageControl;
    StartSheet: TTabSheet;
    Label1: TLabel;
    FloorSheet: TTabSheet;
    FloorCheck: TCheckBox;
    Label2: TLabel;
    TextureList: TComboBox;
    Label3: TLabel;
    CameraSheet: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    CameraList: TComboBox;
    LightSheet: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    LightList: TComboBox;
    ObjectSheet: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    ObjectList: TComboBox;
    Label10: TLabel;
    ObjTextList: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FloorCheckClick(Sender: TObject);
  private
    { Private declarations }
    PageIndex: integer;
  public
    { Public declarations }
  end;

var
  SceneWizardDlg: TSceneWizardDlg;

implementation

uses main;

{$R *.DFM}

procedure TSceneWizardDlg.FormCreate(Sender: TObject);
begin
  PageIndex := 0;
  MainForm.BuildTextureList(TextureList);
  MainForm.BuildTextureList(ObjTextList);
  FloorCheck.Checked := True;
  CameraList.ItemIndex := CameraMid;
  LightList.ItemIndex := LightRight;
  ObjectList.ItemIndex := ObjectSphere;
end;

procedure TSceneWizardDlg.NextBtnClick(Sender: TObject);
begin
  case PageIndex of
    0:
    begin
      PageControl.ActivePage := FloorSheet;
      Inc(PageIndex);
    end;

    1:
    begin
      PageControl.ActivePage := CameraSheet;
      Inc(PageIndex);
    end;

    2:
    begin
      PageControl.ActivePage := LightSheet;
      Inc(PageIndex);
    end;

    3:
    begin
      PageControl.ActivePage := ObjectSheet;
      NextBtn.Caption := 'Finish';
      Inc(PageIndex);
    end;

    4: ModalResult := mrOK;
  end;
end;

procedure TSceneWizardDlg.FloorCheckClick(Sender: TObject);
begin
  TextureList.Enabled := FloorCheck.Checked;
end;

end.
