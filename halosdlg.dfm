object HalosDialog: THalosDialog
  Left = 213
  Top = 489
  BorderStyle = bsDialog
  Caption = 'Halos'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 200
    Top = 136
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 185
    Height = 153
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnDblClick = EditBtnClick
  end
  object AddBtn: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Add...'
    TabOrder = 2
    OnClick = AddBtnClick
  end
  object EditBtn: TButton
    Left = 200
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Edit...'
    TabOrder = 3
    OnClick = EditBtnClick
  end
  object DeleteBtn: TButton
    Left = 200
    Top = 72
    Width = 75
    Height = 25
    Caption = '&Delete'
    TabOrder = 4
    OnClick = DeleteBtnClick
  end
end
