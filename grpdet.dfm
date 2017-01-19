object GroupDetailsDialog: TGroupDetailsDialog
  Left = 210
  Top = 338
  BorderStyle = bsDialog
  Caption = 'Group details'
  ClientHeight = 279
  ClientWidth = 345
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
  object SrcLabel: TLabel
    Left = 8
    Top = 40
    Width = 145
    Height = 16
    AutoSize = False
    Caption = 'Available Objects'
  end
  object DstLabel: TLabel
    Left = 192
    Top = 40
    Width = 145
    Height = 16
    AutoSize = False
    Caption = 'Objects in Group'
  end
  object IncludeBtn: TSpeedButton
    Left = 160
    Top = 136
    Width = 24
    Height = 24
    Caption = '>'
    OnClick = IncludeBtnClick
  end
  object ExcludeBtn: TSpeedButton
    Left = 160
    Top = 168
    Width = 24
    Height = 24
    Caption = '<'
    Enabled = False
    OnClick = ExcludeBtnClick
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 29
    Height = 13
    Caption = '&Group'
  end
  object FirstBtn: TSpeedButton
    Left = 160
    Top = 104
    Width = 25
    Height = 25
    Caption = '1st'
    OnClick = FirstBtnClick
  end
  object OKBtn: TButton
    Left = 264
    Top = 248
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object SrcList: TListBox
    Left = 8
    Top = 56
    Width = 145
    Height = 185
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
  end
  object DstList: TListBox
    Left = 192
    Top = 56
    Width = 145
    Height = 185
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 2
  end
  object GroupType: TComboBox
    Left = 48
    Top = 8
    Width = 97
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      'Union'
      'Merge'
      'Intersection'
      'Difference'
      'Blob')
  end
end
