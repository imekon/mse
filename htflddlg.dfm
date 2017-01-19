object HeightFieldDialog: THeightFieldDialog
  Left = 17
  Top = 288
  BorderStyle = bsDialog
  Caption = 'Height Field'
  ClientHeight = 134
  ClientWidth = 313
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
    Width = 42
    Height = 13
    Caption = '&Filename'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 58
    Height = 13
    Caption = '&Water Level'
  end
  object OKBtn: TButton
    Left = 232
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 232
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Filename: TEdit
    Left = 80
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object BrowseBtn: TButton
    Left = 232
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Browse...'
    TabOrder = 3
    OnClick = BrowseBtnClick
  end
  object Hierarchy: TCheckBox
    Left = 80
    Top = 40
    Width = 97
    Height = 17
    Caption = '&Hierarchy'
    TabOrder = 4
  end
  object Smooth: TCheckBox
    Left = 80
    Top = 72
    Width = 97
    Height = 17
    Caption = '&Smooth'
    TabOrder = 5
  end
  object WaterLevel: TEdit
    Left = 80
    Top = 104
    Width = 73
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 
      'GIF|*.gif|PGM|*.pgm|PNG|*.png|POT|*.pot|PPM|*.ppm|Bitmaps|*.bmp|' +
      'Targa|*.tga'
    Options = [ofHideReadOnly, ofFileMustExist]
    Left = 232
    Top = 40
  end
end
