object IridVectorDialog: TIridVectorDialog
  Left = 227
  Top = 554
  BorderStyle = bsDialog
  Caption = 'Iridescence Vector'
  ClientHeight = 73
  ClientWidth = 216
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
    Width = 31
    Height = 13
    Caption = '&Vector'
  end
  object OKBtn: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 96
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object XValue: TEdit
    Left = 48
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object YValue: TEdit
    Left = 104
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ZValue: TEdit
    Left = 160
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '0'
  end
end
