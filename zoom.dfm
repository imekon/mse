object ZoomDlg: TZoomDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Zoom'
  ClientHeight = 72
  ClientWidth = 248
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
    Width = 33
    Height = 13
    Caption = '&Setting'
  end
  object Label2: TLabel
    Left = 104
    Top = 8
    Width = 3
    Height = 13
    Caption = ':'
  end
  object OKBtn: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 168
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Multiplier: TEdit
    Left = 48
    Top = 8
    Width = 33
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object MultiplierUpDown: TUpDown
    Left = 81
    Top = 8
    Width = 15
    Height = 21
    Associate = Multiplier
    Min = 1
    Position = 1
    TabOrder = 1
  end
  object Divisor: TEdit
    Left = 112
    Top = 8
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object DivisorUpDown: TUpDown
    Left = 145
    Top = 8
    Width = 15
    Height = 21
    Associate = Divisor
    Min = 1
    Position = 1
    TabOrder = 3
  end
  object ResetBtn: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Reset'
    TabOrder = 4
    OnClick = ResetBtnClick
  end
end
