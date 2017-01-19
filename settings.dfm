object SettingsDialog: TSettingsDialog
  Left = 223
  Top = 240
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 120
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = '&POVray Image'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 40
    Height = 13
    Caption = '&CoolRay'
  end
  object OKBtn: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 96
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object POVray: TEdit
    Left = 88
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'povray.exe'
  end
  object BrowseBtn: TButton
    Left = 216
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = BrowseBtnClick
  end
  object CoolRay: TEdit
    Left = 88
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'coolray.exe'
  end
  object CoolRayBrowse: TButton
    Left = 216
    Top = 40
    Width = 75
    Height = 25
    Caption = 'B&rowse...'
    TabOrder = 5
    OnClick = CoolRayBrowseClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Images (*.exe)|*.exe'
    Options = [ofHideReadOnly, ofFileMustExist]
    Left = 264
    Top = 80
  end
end
