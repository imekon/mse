object DiscDialog: TDiscDialog
  Left = 244
  Top = 376
  BorderStyle = bsDialog
  Caption = 'Disc'
  ClientHeight = 74
  ClientWidth = 221
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
    Width = 33
    Height = 13
    Caption = '&Radius'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 22
    Height = 13
    Caption = '&Hole'
  end
  object OKBtn: TButton
    Left = 136
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 136
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Radius: TEdit
    Left = 56
    Top = 8
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object Hole: TEdit
    Left = 56
    Top = 40
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '0.5'
  end
end
