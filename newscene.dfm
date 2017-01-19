object NewSceneDlg: TNewSceneDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'New Scene'
  ClientHeight = 167
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 209
    Height = 121
    Shape = bsFrame
  end
  object Image: TImage
    Left = 16
    Top = 16
    Width = 105
    Height = 105
  end
  object OKBtn: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox: TListBox
    Left = 128
    Top = 16
    Width = 81
    Height = 43
    IntegralHeight = True
    ItemHeight = 13
    Items.Strings = (
      'Blank Scene'
      'Simple Scene'
      'Scene Wizard')
    TabOrder = 2
    OnClick = ListBoxClick
  end
end
