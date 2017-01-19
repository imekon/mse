object FogDialog: TFogDialog
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Fog'
  ClientHeight = 337
  ClientWidth = 313
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
  object OKBtn: TButton
    Left = 8
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 304
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object FogEnabled: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = '&Enabled'
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 0
    Top = 32
    Width = 313
    Height = 265
    ActivePage = FogSheet
    TabOrder = 3
    object FogSheet: TTabSheet
      Caption = '&Fog'
      object Label1: TLabel
        Left = 16
        Top = 8
        Width = 24
        Height = 13
        Caption = '&Type'
      end
      object Label2: TLabel
        Left = 16
        Top = 40
        Width = 42
        Height = 13
        Caption = '&Distance'
      end
      object Label3: TLabel
        Left = 16
        Top = 136
        Width = 28
        Height = 13
        Caption = '&Offset'
      end
      object Label4: TLabel
        Left = 16
        Top = 168
        Width = 35
        Height = 13
        Caption = '&Altitude'
      end
      object FogType: TComboBox
        Left = 96
        Top = 8
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'Constant'
          'Ground')
      end
      object Distance: TEdit
        Left = 96
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'Distance'
      end
      object ColourBtn: TButton
        Left = 96
        Top = 72
        Width = 75
        Height = 25
        Caption = '&Colour...'
        TabOrder = 2
      end
      object TurbulenceBtn: TButton
        Left = 96
        Top = 104
        Width = 75
        Height = 25
        Caption = '&Turbulence...'
        TabOrder = 3
      end
      object Offset: TEdit
        Left = 96
        Top = 136
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'Offset'
      end
      object Altitude: TEdit
        Left = 96
        Top = 168
        Width = 121
        Height = 21
        TabOrder = 5
        Text = 'Altitude'
      end
      object UpBtn: TButton
        Left = 96
        Top = 200
        Width = 75
        Height = 25
        Caption = '&Up...'
        TabOrder = 6
      end
    end
    object TransSheet: TTabSheet
      Caption = '&Transformation'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
end
