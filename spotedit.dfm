inherited SpotLightEditorDlg: TSpotLightEditorDlg
  Left = 422
  Top = 253
  ClientHeight = 329
  ClientWidth = 341
  ExplicitWidth = 347
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel [3]
    Left = 192
    Top = 176
    Width = 33
    Height = 13
    Caption = 'Fall &Off'
  end
  object Label11: TLabel [4]
    Left = 192
    Top = 208
    Width = 46
    Height = 13
    Caption = '&Tightness'
  end
  object Label12: TLabel [5]
    Left = 192
    Top = 144
    Width = 33
    Height = 13
    Caption = 'R&adius'
  end
  inherited OKBtn: TButton
    TabOrder = 10
  end
  inherited CancelBtn: TButton
    TabOrder = 11
  end
  inherited LooksLike: TComboBox
    Items.Strings = (
      'Spotlight'
      'Sphere'
      'Cube'
      'Cone'
      'Cylinder')
  end
  object GroupBox2: TGroupBox [13]
    Left = 200
    Top = 8
    Width = 129
    Height = 121
    Caption = 'Point At'
    TabOrder = 6
    object Label6: TLabel
      Left = 16
      Top = 24
      Width = 7
      Height = 13
      Caption = '&X'
    end
    object Label7: TLabel
      Left = 16
      Top = 56
      Width = 7
      Height = 13
      Caption = '&Y'
    end
    object Label8: TLabel
      Left = 16
      Top = 88
      Width = 7
      Height = 13
      Caption = '&Z'
    end
    object XPoint: TEdit
      Left = 48
      Top = 24
      Width = 65
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object YPoint: TEdit
      Left = 48
      Top = 56
      Width = 65
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object ZPoint: TEdit
      Left = 48
      Top = 88
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object Radius: TEdit [14]
    Left = 248
    Top = 144
    Width = 65
    Height = 21
    TabOrder = 7
    Text = '0'
  end
  object Falloff: TEdit [15]
    Left = 248
    Top = 176
    Width = 65
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object Tightness: TEdit [16]
    Left = 248
    Top = 208
    Width = 65
    Height = 21
    TabOrder = 9
    Text = '0'
  end
end
