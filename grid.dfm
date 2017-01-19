object GridDlg: TGridDlg
  Left = 352
  Top = 277
  HelpContext = 65
  BorderStyle = bsDialog
  Caption = 'Grid'
  ClientHeight = 71
  ClientWidth = 259
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
    Left = 40
    Top = 8
    Width = 33
    Height = 13
    Caption = '&Setting'
  end
  object OKBtn: TButton
    Left = 176
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 176
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Grid: TEdit
    Left = 88
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Grid01: TButton
    Left = 8
    Top = 40
    Width = 33
    Height = 25
    Caption = '0.&1'
    TabOrder = 1
    OnClick = Grid01Click
  end
  object Grid025: TButton
    Left = 48
    Top = 40
    Width = 33
    Height = 25
    Caption = '0.&25'
    TabOrder = 2
    OnClick = Grid025Click
  end
  object Grid05: TButton
    Left = 88
    Top = 40
    Width = 33
    Height = 25
    Caption = '0.&5'
    TabOrder = 3
    OnClick = Grid05Click
  end
  object NoneBtn: TButton
    Left = 128
    Top = 40
    Width = 41
    Height = 25
    Caption = '&None'
    TabOrder = 4
    OnClick = NoneBtnClick
  end
end
