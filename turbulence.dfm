object TurbulenceDialog: TTurbulenceDialog
  Left = 214
  Top = 419
  BorderStyle = bsDialog
  Caption = 'Turbulence'
  ClientHeight = 177
  ClientWidth = 182
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
    Width = 54
    Height = 13
    Caption = '&Turbulence'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 40
    Height = 13
    Caption = '&Octaves'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 34
    Height = 13
    Caption = 'O&mega'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 38
    Height = 13
    Caption = '&Lambda'
  end
  object OKBtn: TButton
    Left = 8
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 96
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Turbulence: TEdit
    Left = 88
    Top = 16
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Octaves: TEdit
    Left = 88
    Top = 48
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '6'
  end
  object Omega: TEdit
    Left = 88
    Top = 80
    Width = 65
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object Lambda: TEdit
    Left = 88
    Top = 112
    Width = 65
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object OctavesUpDown: TUpDown
    Left = 153
    Top = 48
    Width = 15
    Height = 21
    Associate = Octaves
    Min = 1
    Max = 10
    Position = 6
    TabOrder = 2
  end
end
