object PasteDialog: TPasteDialog
  Left = 245
  Top = 233
  BorderStyle = bsDialog
  Caption = 'Paste'
  ClientHeight = 264
  ClientWidth = 255
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
    Width = 28
    Height = 13
    Caption = '&Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 44
    Height = 13
    Caption = '&Translate'
  end
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 27
    Height = 13
    Caption = '&Scale'
  end
  object Label4: TLabel
    Left = 8
    Top = 88
    Width = 32
    Height = 13
    Caption = '&Rotate'
  end
  object Label5: TLabel
    Left = 8
    Top = 152
    Width = 44
    Height = 13
    Caption = 'Translate'
  end
  object Label6: TLabel
    Left = 8
    Top = 176
    Width = 27
    Height = 13
    Caption = 'Scale'
  end
  object Label7: TLabel
    Left = 8
    Top = 200
    Width = 32
    Height = 13
    Caption = 'Rotate'
  end
  object Label8: TLabel
    Left = 88
    Top = 120
    Width = 28
    Height = 13
    Caption = '&Count'
  end
  object OKBtn: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 22
  end
  object CancelBtn: TButton
    Left = 88
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 23
  end
  object Name: TEdit
    Left = 64
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object XTrans: TEdit
    Left = 64
    Top = 40
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object YTrans: TEdit
    Left = 128
    Top = 40
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object ZTrans: TEdit
    Left = 192
    Top = 40
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object XScale: TEdit
    Left = 64
    Top = 64
    Width = 57
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object YScale: TEdit
    Left = 128
    Top = 64
    Width = 57
    Height = 21
    TabOrder = 5
    Text = '1'
  end
  object ZScale: TEdit
    Left = 192
    Top = 64
    Width = 57
    Height = 21
    TabOrder = 6
    Text = '1'
  end
  object XRotate: TEdit
    Left = 64
    Top = 88
    Width = 57
    Height = 21
    TabOrder = 7
    Text = '0'
  end
  object YRotate: TEdit
    Left = 128
    Top = 88
    Width = 57
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object ZRotate: TEdit
    Left = 192
    Top = 88
    Width = 57
    Height = 21
    TabOrder = 9
    Text = '0'
  end
  object Increment: TCheckBox
    Left = 8
    Top = 120
    Width = 73
    Height = 17
    Caption = '&Increment'
    TabOrder = 10
    OnClick = IncrementClick
  end
  object IncXTrans: TEdit
    Left = 64
    Top = 152
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 13
    Text = '0'
  end
  object IncYTrans: TEdit
    Left = 128
    Top = 152
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 14
    Text = '0'
  end
  object IncZTrans: TEdit
    Left = 190
    Top = 152
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 15
    Text = '0'
  end
  object IncXScale: TEdit
    Left = 64
    Top = 176
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 16
    Text = '0'
  end
  object IncYScale: TEdit
    Left = 128
    Top = 176
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 17
    Text = '0'
  end
  object IncZScale: TEdit
    Left = 190
    Top = 176
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 18
    Text = '0'
  end
  object IncXRotate: TEdit
    Left = 64
    Top = 200
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 19
    Text = '0'
  end
  object IncYRotate: TEdit
    Left = 128
    Top = 200
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 20
    Text = '0'
  end
  object IncZRotate: TEdit
    Left = 190
    Top = 200
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 21
    Text = '0'
  end
  object Count: TEdit
    Left = 128
    Top = 120
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 11
    Text = '1'
  end
  object CountUpDown: TUpDown
    Left = 185
    Top = 120
    Width = 15
    Height = 21
    Associate = Count
    Enabled = False
    Min = 1
    Position = 1
    TabOrder = 12
  end
end
