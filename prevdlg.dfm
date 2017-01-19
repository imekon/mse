object PreviewDialog: TPreviewDialog
  Left = 787
  Top = 146
  BorderStyle = bsDialog
  Caption = 'Preview Settings'
  ClientHeight = 136
  ClientWidth = 229
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = '&Shape'
  end
  object OKBtn: TButton
    Left = 8
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelBtn: TButton
    Left = 88
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object Shape: TComboBox
    Left = 56
    Top = 8
    Width = 89
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      'Sphere'
      'Cube'
      'Cylinder')
  end
  object Floor: TCheckBox
    Left = 8
    Top = 40
    Width = 49
    Height = 17
    Caption = '&Floor'
    TabOrder = 1
  end
  object Wall: TCheckBox
    Left = 8
    Top = 72
    Width = 49
    Height = 17
    Caption = '&Wall'
    TabOrder = 3
  end
  object FloorColour: TButton
    Left = 72
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Colour...'
    TabOrder = 2
    OnClick = FloorColourClick
  end
  object WallColour: TButton
    Left = 72
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Colour...'
    TabOrder = 4
    OnClick = WallColourClick
  end
  object ColorDialog: TColorDialog
    Left = 160
    Top = 40
  end
end
