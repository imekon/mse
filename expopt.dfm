object ExportOptionsDialog: TExportOptionsDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Export Options'
  ClientHeight = 107
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 20
    Height = 13
    Caption = '&Axis'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 33
    Height = 13
    Caption = '&Scaling'
  end
  object OKBtn: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object AxisList: TComboBox
    Left = 88
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'No change'
      'Swap X and Y'
      'Swap Y and Z'
      'Swap X and Z')
  end
  object Scaling: TEdit
    Left = 88
    Top = 56
    Width = 73
    Height = 21
    TabOrder = 3
    Text = '1.0'
  end
end
