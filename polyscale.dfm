object PolyScaleDlg: TPolyScaleDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Polygon Scaling'
  ClientHeight = 164
  ClientWidth = 229
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
    Left = 8
    Top = 8
    Width = 209
    Height = 113
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Object'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 44
    Height = 13
    Caption = 'Maximum'
  end
  object Label3: TLabel
    Left = 24
    Top = 88
    Width = 35
    Height = 13
    Caption = '&Scaling'
  end
  object OKBtn: TButton
    Left = 32
    Top = 128
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 120
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Name: TEdit
    Left = 80
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object Maximum: TEdit
    Left = 80
    Top = 56
    Width = 65
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object Scaling: TEdit
    Left = 80
    Top = 88
    Width = 65
    Height = 21
    TabOrder = 4
    Text = '1'
  end
end
