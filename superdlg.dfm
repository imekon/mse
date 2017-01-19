object SuperDialog: TSuperDialog
  Left = 256
  Top = 277
  BorderStyle = bsDialog
  Caption = 'Super Ellipsoid'
  ClientHeight = 72
  ClientWidth = 204
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
    Width = 8
    Height = 13
    Caption = '&R'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 8
    Height = 13
    Caption = '&N'
  end
  object OKBtn: TButton
    Left = 120
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 120
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object RValue: TEdit
    Left = 32
    Top = 8
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '0.5'
  end
  object NValue: TEdit
    Left = 32
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '0.5'
  end
end
