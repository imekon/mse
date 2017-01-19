object ImportDlg: TImportDlg
  Left = 255
  Top = 263
  BorderStyle = bsDialog
  Caption = 'Import RAW'
  ClientHeight = 97
  ClientWidth = 313
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
    Caption = 'Object'
  end
  object OKBtn: TButton
    Left = 119
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 40
    Width = 297
    Height = 16
    TabOrder = 1
  end
  object Name: TEdit
    Left = 56
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
end
