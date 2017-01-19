object GalleryDetailsDialog: TGalleryDetailsDialog
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Gallery Shape details'
  ClientHeight = 93
  ClientWidth = 230
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
    Left = 40
    Top = 16
    Width = 28
    Height = 13
    Caption = '&Name'
  end
  object OKBtn: TButton
    Left = 16
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 136
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Name: TEdit
    Left = 80
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Untitled'
  end
end
