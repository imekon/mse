object LightEditorDlg: TLightEditorDlg
  Left = 220
  Top = 128
  BorderStyle = bsDialog
  Caption = 'Light Editor'
  ClientHeight = 328
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 24
    Top = 176
    Width = 69
    Height = 13
    Caption = 'Fade &Distance'
  end
  object Label5: TLabel
    Left = 24
    Top = 208
    Width = 57
    Height = 13
    Caption = 'Fade &Power'
  end
  object Label9: TLabel
    Left = 24
    Top = 144
    Width = 52
    Height = 13
    Caption = '&Looks Like'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 121
    Caption = 'Colour'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 20
      Height = 13
      Caption = '&Red'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 29
      Height = 13
      Caption = '&Green'
    end
    object Label3: TLabel
      Left = 16
      Top = 88
      Width = 21
      Height = 13
      Caption = '&Blue'
    end
    object Red: TEdit
      Left = 56
      Top = 24
      Width = 65
      Height = 21
      TabOrder = 0
      Text = '1'
    end
    object Green: TEdit
      Left = 56
      Top = 56
      Width = 65
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object Blue: TEdit
      Left = 56
      Top = 88
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '1'
    end
  end
  object FadeDistance: TEdit
    Left = 104
    Top = 176
    Width = 65
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object FadePower: TEdit
    Left = 104
    Top = 208
    Width = 65
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object AtmosphericAttenuation: TCheckBox
    Left = 24
    Top = 240
    Width = 145
    Height = 17
    Caption = '&Atmospheric Attenuation'
    TabOrder = 4
  end
  object OKBtn: TButton
    Left = 8
    Top = 296
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object CancelBtn: TButton
    Left = 96
    Top = 296
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object LooksLike: TComboBox
    Left = 88
    Top = 144
    Width = 81
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    Items.Strings = (
      'Point'
      'Sphere'
      'Cube'
      'Cone'
      'Cylinder')
  end
  object Shadowless: TCheckBox
    Left = 24
    Top = 264
    Width = 97
    Height = 17
    Caption = '&Shadowless'
    TabOrder = 5
  end
end
