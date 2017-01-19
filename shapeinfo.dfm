object ShapeInfoDlg: TShapeInfoDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Object Information'
  ClientHeight = 214
  ClientWidth = 201
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
    Width = 185
    Height = 169
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 16
    Top = 80
    Width = 36
    Height = 13
    Caption = 'Texture'
  end
  object Label3: TLabel
    Left = 16
    Top = 144
    Width = 43
    Height = 13
    Caption = 'Triangles'
  end
  object Label4: TLabel
    Left = 16
    Top = 48
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label5: TLabel
    Left = 16
    Top = 112
    Width = 26
    Height = 13
    Caption = 'Layer'
  end
  object OKBtn: TButton
    Left = 63
    Top = 184
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Name: TEdit
    Left = 64
    Top = 16
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Texture: TEdit
    Left = 64
    Top = 80
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Triangles: TEdit
    Left = 64
    Top = 144
    Width = 57
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object ShapeType: TEdit
    Left = 64
    Top = 48
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object Layer: TEdit
    Left = 64
    Top = 112
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
end
