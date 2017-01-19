object NSidedDialog: TNSidedDialog
  Left = 223
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Choose number of sides'
  ClientHeight = 114
  ClientWidth = 219
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
    Top = 16
    Width = 26
    Height = 13
    Caption = '&Sides'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 33
    Height = 13
    Caption = '&Radius'
  end
  object OKBtn: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Sides: TEdit
    Left = 56
    Top = 16
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '3'
  end
  object SidesUpDown: TUpDown
    Left = 113
    Top = 16
    Width = 15
    Height = 21
    Associate = Sides
    Min = 3
    Position = 3
    TabOrder = 1
  end
  object Radius: TEdit
    Left = 56
    Top = 48
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '1'
  end
end
