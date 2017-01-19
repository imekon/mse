object BrickSizeDialog: TBrickSizeDialog
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Brick Size'
  ClientHeight = 81
  ClientWidth = 273
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
    Left = 16
    Top = 16
    Width = 47
    Height = 13
    Caption = '&Brick Size'
  end
  object OKBtn: TButton
    Left = 16
    Top = 48
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 104
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object XValue: TEdit
    Left = 80
    Top = 16
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object YValue: TEdit
    Left = 144
    Top = 16
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ZValue: TEdit
    Left = 208
    Top = 16
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
end
