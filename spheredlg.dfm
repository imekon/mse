object SphereDialog: TSphereDialog
  Left = 230
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Sphere Details'
  ClientHeight = 110
  ClientWidth = 196
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
    Top = 48
    Width = 40
    Height = 13
    Caption = '&Strength'
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 13
    Caption = '&Radius'
  end
  object OKBtn: TButton
    Left = 24
    Top = 80
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 112
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Strength: TEdit
    Left = 72
    Top = 48
    Width = 113
    Height = 21
    TabOrder = 1
    Text = '1.0'
  end
  object Radius: TEdit
    Left = 72
    Top = 16
    Width = 113
    Height = 21
    TabOrder = 0
    Text = '1.0'
  end
end
