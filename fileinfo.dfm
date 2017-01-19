object FileInfoDlg: TFileInfoDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'File Information'
  ClientHeight = 120
  ClientWidth = 174
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
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 161
    Height = 73
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Objects'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 41
    Height = 13
    Caption = 'Textures'
  end
  object OKBtn: TButton
    Left = 49
    Top = 88
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Objects: TEdit
    Left = 64
    Top = 16
    Width = 57
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object Textures: TEdit
    Left = 64
    Top = 48
    Width = 57
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '0'
  end
end
