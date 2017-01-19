object TextTypeDlg: TTextTypeDlg
  Left = 204
  Top = 173
  BorderStyle = bsDialog
  Caption = 'Create Texture Type'
  ClientHeight = 255
  ClientWidth = 200
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
  object OKBtn: TButton
    Left = 120
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 120
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object TypeList: TListBox
    Left = 8
    Top = 8
    Width = 97
    Height = 238
    IntegralHeight = True
    ItemHeight = 13
    Items.Strings = (
      'Colour'
      'Agate'
      'Average'
      'Bozo'
      'Brick'
      'Bumps'
      'Checker'
      'Crackle'
      'Dents'
      'Gradient'
      'Granite'
      'Hexagon'
      'Image'
      'Leopard'
      'Mandel'
      'Marble'
      'Onion'
      'Quilted'
      'Radial'
      'Ripples'
      'Spiral1'
      'Spiral2'
      'Spotted'
      'Waves'
      'Wood'
      'Wrinkles'
      'User')
    TabOrder = 2
  end
end
