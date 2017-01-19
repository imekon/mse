object ChooseTextureNameDialog: TChooseTextureNameDialog
  Left = 583
  Top = 507
  BorderStyle = bsDialog
  Caption = 'Choose'
  ClientHeight = 151
  ClientWidth = 234
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
    Width = 201
    Height = 26
    Caption = 
      'The name of the texture you have chosen already exists; please c' +
      'hoose another'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 75
    Height = 13
    Caption = 'Existing Texture'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 65
    Height = 13
    Caption = 'Choose name'
  end
  object OKBtn: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 152
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Existing: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 0
  end
  object Choose: TEdit
    Left = 104
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 1
  end
end
