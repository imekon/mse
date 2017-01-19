object CameraDialog: TCameraDialog
  Left = 705
  Top = 128
  BorderStyle = bsDialog
  Caption = 'Camera'
  ClientHeight = 95
  ClientWidth = 231
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
    Width = 43
    Height = 13
    Caption = 'Observe&r'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 46
    Height = 13
    Caption = 'Observe&d'
  end
  object OKBtn: TButton
    Left = 8
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object CancelBtn: TButton
    Left = 152
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object XObserver: TEdit
    Left = 64
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object YObserver: TEdit
    Left = 120
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ZObserver: TEdit
    Left = 176
    Top = 8
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object XObserved: TEdit
    Left = 64
    Top = 32
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object YObserved: TEdit
    Left = 120
    Top = 32
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object ZObserved: TEdit
    Left = 176
    Top = 32
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '0'
  end
end
