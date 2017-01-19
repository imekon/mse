object TorusDialog: TTorusDialog
  Left = 97
  Top = 346
  BorderStyle = bsDialog
  Caption = 'Torus'
  ClientHeight = 95
  ClientWidth = 211
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
    Width = 26
    Height = 13
    Caption = 'M&ajor'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 26
    Height = 13
    Caption = 'M&inor'
  end
  object OKBtn: TButton
    Left = 128
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 128
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Major: TEdit
    Left = 48
    Top = 8
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object Minor: TEdit
    Left = 48
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '0.25'
  end
  object Sturm: TCheckBox
    Left = 48
    Top = 72
    Width = 57
    Height = 17
    Caption = '&Sturm'
    TabOrder = 2
  end
end
