object RGBFTDlg: TRGBFTDlg
  Left = 604
  Top = 396
  BorderStyle = bsDialog
  Caption = 'Colour Editor'
  ClientHeight = 231
  ClientWidth = 365
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
  object Bevel1: TBevel
    Left = 280
    Top = 8
    Width = 73
    Height = 73
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 20
    Height = 13
    Caption = '&Red'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 29
    Height = 13
    Caption = '&Green'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 21
    Height = 13
    Caption = '&Blue'
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 22
    Height = 13
    Caption = '&Filter'
  end
  object Label5: TLabel
    Left = 8
    Top = 136
    Width = 40
    Height = 13
    Caption = '&Transmit'
  end
  object Shape: TShape
    Left = 288
    Top = 16
    Width = 57
    Height = 57
    Pen.Style = psClear
  end
  object Label6: TLabel
    Left = 8
    Top = 168
    Width = 30
    Height = 13
    Caption = '&Colour'
  end
  object Red: TEdit
    Left = 56
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Green: TEdit
    Left = 56
    Top = 40
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object Blue: TEdit
    Left = 56
    Top = 72
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object Filter: TEdit
    Left = 56
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object Transmit: TEdit
    Left = 56
    Top = 136
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object OKBtn: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 96
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object ColourList: TComboBox
    Left = 56
    Top = 168
    Width = 217
    Height = 21
    Style = csDropDownList
    TabOrder = 7
  end
end
