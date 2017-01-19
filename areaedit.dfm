inherited AreaLightEditorDlg: TAreaLightEditorDlg
  Left = 435
  Top = 134
  ClientHeight = 327
  ClientWidth = 338
  ExplicitWidth = 344
  ExplicitHeight = 356
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel [2]
    Left = 200
    Top = 32
    Width = 42
    Height = 13
    Caption = '&Adaptive'
  end
  object Label7: TLabel [3]
    Left = 200
    Top = 96
    Width = 28
    Height = 13
    Caption = '&Width'
  end
  object Label8: TLabel [4]
    Left = 200
    Top = 128
    Width = 31
    Height = 13
    Caption = '&Height'
  end
  inherited OKBtn: TButton
    TabOrder = 10
  end
  inherited CancelBtn: TButton
    TabOrder = 11
  end
  object Adaptive: TEdit [12]
    Left = 264
    Top = 32
    Width = 65
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object Jitter: TCheckBox [13]
    Left = 200
    Top = 64
    Width = 97
    Height = 17
    Caption = '&Jitter'
    TabOrder = 7
  end
  object Width: TEdit [14]
    Left = 264
    Top = 96
    Width = 65
    Height = 21
    TabOrder = 8
    Text = '5'
  end
  object Height: TEdit [15]
    Left = 264
    Top = 128
    Width = 65
    Height = 21
    TabOrder = 9
    Text = '5'
  end
  inherited LooksLike: TComboBox
    Items.Strings = (
      'Area'
      'Sphere'
      'Cube'
      'Cone'
      'Cylinder')
  end
end
