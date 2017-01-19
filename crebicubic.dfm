object CreateBicubicDialog: TCreateBicubicDialog
  Left = 218
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Create Bicubic Patch'
  ClientHeight = 157
  ClientWidth = 225
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
    Top = 96
    Width = 28
    Height = 13
    Caption = '&Width'
  end
  object Label2: TLabel
    Left = 8
    Top = 128
    Width = 31
    Height = 13
    Caption = '&Height'
  end
  object OKBtn: TButton
    Left = 144
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 144
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object PatchType: TRadioGroup
    Left = 8
    Top = 8
    Width = 129
    Height = 81
    Caption = 'Patch Type'
    ItemIndex = 0
    Items.Strings = (
      '&Flat Sheet'
      'Cylinder (&2 patches)'
      'Cylinder (&4 patches)')
    TabOrder = 0
  end
  object Width: TEdit
    Left = 48
    Top = 96
    Width = 41
    Height = 21
    TabOrder = 1
    Text = '1'
  end
  object Height: TEdit
    Left = 48
    Top = 128
    Width = 41
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object WidthUpDown: TUpDown
    Left = 89
    Top = 96
    Width = 15
    Height = 21
    Associate = Width
    Min = 1
    Position = 1
    TabOrder = 2
  end
  object HeightUpDown: TUpDown
    Left = 89
    Top = 128
    Width = 15
    Height = 21
    Associate = Height
    Min = 1
    Position = 1
    TabOrder = 4
  end
end
