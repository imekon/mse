object MeshDialog: TMeshDialog
  Left = 211
  Top = 333
  BorderStyle = bsDialog
  Caption = 'Mesh'
  ClientHeight = 72
  ClientWidth = 195
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
    Width = 28
    Height = 13
    Caption = '&Width'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 31
    Height = 13
    Caption = '&Height'
  end
  object OKBtn: TButton
    Left = 112
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 112
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Width: TEdit
    Left = 48
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '5'
  end
  object Height: TEdit
    Left = 48
    Top = 40
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '5'
  end
end
