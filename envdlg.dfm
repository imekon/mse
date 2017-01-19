object EnvironmentDialog: TEnvironmentDialog
  Left = 253
  Top = 306
  BorderStyle = bsDialog
  Caption = 'Environment'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 30
    Height = 13
    Caption = 'Sound'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 35
    Height = 13
    Caption = 'Reverb'
  end
  object Label3: TLabel
    Left = 24
    Top = 88
    Width = 105
    Height = 13
    Caption = 'Obstruction/Occlusion'
  end
  object OKBtn: TButton
    Left = 79
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Top = 180
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Sound: TComboBox
    Left = 144
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 2
  end
  object Reverb: TComboBox
    Left = 144
    Top = 56
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object Obstruction: TComboBox
    Left = 144
    Top = 88
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 4
  end
end
