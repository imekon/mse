object TextDialog: TTextDialog
  Left = 222
  Top = 419
  BorderStyle = bsDialog
  Caption = 'Text'
  ClientHeight = 166
  ClientWidth = 279
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
    Width = 21
    Height = 13
    Caption = '&Font'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 21
    Height = 13
    Caption = '&Text'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 49
    Height = 13
    Caption = 'T&hickness'
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 28
    Height = 13
    Caption = '&Offset'
  end
  object OKBtn: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object CancelBtn: TButton
    Left = 88
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object Font: TEdit
    Left = 40
    Top = 8
    Width = 153
    Height = 21
    TabOrder = 0
  end
  object BrowseBtn: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = BrowseBtnClick
  end
  object Text: TEdit
    Left = 40
    Top = 40
    Width = 233
    Height = 21
    TabOrder = 2
  end
  object Thickness: TEdit
    Left = 64
    Top = 72
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object XOffset: TEdit
    Left = 64
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object YOffset: TEdit
    Left = 128
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 5
    Text = '1'
  end
  object ZOffset: TEdit
    Left = 192
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 6
    Text = '1'
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ttf'
    Filter = 'True Type Fonts (*.ttf)|*.ttf'
    Options = [ofHideReadOnly, ofFileMustExist]
    Left = 248
    Top = 72
  end
end
