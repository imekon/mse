object CreatePolygonDialog: TCreatePolygonDialog
  Left = 213
  Top = 377
  BorderStyle = bsDialog
  Caption = 'Create Polygon'
  ClientHeight = 209
  ClientWidth = 178
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
  object WidthLabel: TLabel
    Left = 8
    Top = 120
    Width = 28
    Height = 13
    Caption = '&Width'
  end
  object HeightLabel: TLabel
    Left = 8
    Top = 144
    Width = 31
    Height = 13
    Caption = '&Height'
  end
  object OKBtn: TButton
    Left = 8
    Top = 176
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 176
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Polygon: TRadioGroup
    Left = 8
    Top = 8
    Width = 161
    Height = 105
    Caption = 'Polygon'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '&Triangle'
      'S&heet'
      '&Sphere'
      '&Cube'
      'Co&ne'
      'C&ylinder'
      '&Disc')
    TabOrder = 2
    OnClick = PolygonClick
  end
  object Width: TEdit
    Left = 48
    Top = 120
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = '1'
  end
  object Height: TEdit
    Left = 48
    Top = 144
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '1'
  end
end
