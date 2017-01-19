object HaloDialog: THaloDialog
  Left = 224
  Top = 152
  BorderStyle = bsDialog
  Caption = 'Halo'
  ClientHeight = 359
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 28
    Height = 13
    Caption = '&Name'
  end
  object OKBtn: TButton
    Left = 8
    Top = 328
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 88
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Name: TEdit
    Left = 48
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object PageControl: TPageControl
    Left = 0
    Top = 40
    Width = 313
    Height = 281
    ActivePage = Details
    TabOrder = 1
    object Details: TTabSheet
      Caption = 'Details'
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 24
        Height = 13
        Caption = '&Type'
      end
      object Label3: TLabel
        Left = 8
        Top = 48
        Width = 35
        Height = 13
        Caption = '&Density'
      end
      object Label4: TLabel
        Left = 8
        Top = 80
        Width = 41
        Height = 13
        Caption = '&Mapping'
      end
      object Label5: TLabel
        Left = 8
        Top = 112
        Width = 22
        Height = 13
        Caption = 'D&ust'
      end
      object Label6: TLabel
        Left = 8
        Top = 144
        Width = 55
        Height = 13
        Caption = '&Eccentricity'
      end
      object Label7: TLabel
        Left = 8
        Top = 176
        Width = 50
        Height = 13
        Caption = '&Max Value'
      end
      object Label8: TLabel
        Left = 8
        Top = 208
        Width = 45
        Height = 13
        Caption = 'E&xponent'
      end
      object HaloType: TComboBox
        Left = 72
        Top = 16
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'Attenuating'
          'Emitting'
          'Glowing'
          'Dust')
      end
      object HaloDensity: TComboBox
        Left = 72
        Top = 48
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          'Constant'
          'Linear'
          'Cubic'
          'Poly')
      end
      object HaloMapping: TComboBox
        Left = 72
        Top = 80
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        Items.Strings = (
          'Planar'
          'Spherical'
          'Cylindrical'
          'Box')
      end
      object DustType: TComboBox
        Left = 72
        Top = 112
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        Items.Strings = (
          'Isotropic'
          'MIE Hazy'
          'MIE Murky'
          'Rayleigh'
          'Henyay Greenstein')
      end
      object Eccentricity: TEdit
        Left = 72
        Top = 144
        Width = 65
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object MaxValue: TEdit
        Left = 72
        Top = 176
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object Exponent: TEdit
        Left = 72
        Top = 208
        Width = 65
        Height = 21
        TabOrder = 6
        Text = '0'
      end
    end
    object AntiAliasing: TTabSheet
      Caption = 'Anti Aliasing'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 16
        Top = 16
        Width = 40
        Height = 13
        Caption = '&Samples'
      end
      object Label10: TLabel
        Left = 16
        Top = 48
        Width = 40
        Height = 13
        Caption = 'AA&Level'
      end
      object Label11: TLabel
        Left = 16
        Top = 80
        Width = 61
        Height = 13
        Caption = 'AA&Threshold'
      end
      object Label12: TLabel
        Left = 16
        Top = 112
        Width = 22
        Height = 13
        Caption = '&Jitter'
      end
      object Label13: TLabel
        Left = 16
        Top = 144
        Width = 50
        Height = 13
        Caption = '&Frequency'
      end
      object Label14: TLabel
        Left = 16
        Top = 176
        Width = 30
        Height = 13
        Caption = '&Phase'
      end
      object TurbulenceBtn: TButton
        Left = 88
        Top = 208
        Width = 75
        Height = 25
        Caption = 'T&urbulence...'
        TabOrder = 6
        OnClick = TurbulenceBtnClick
      end
      object Samples: TEdit
        Left = 96
        Top = 16
        Width = 65
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object AALevel: TEdit
        Left = 96
        Top = 48
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '0'
      end
      object AAThreshold: TEdit
        Left = 96
        Top = 80
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object Jitter: TEdit
        Left = 96
        Top = 112
        Width = 65
        Height = 21
        TabOrder = 3
        Text = '0'
      end
      object Frequency: TEdit
        Left = 96
        Top = 144
        Width = 65
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object Phase: TEdit
        Left = 96
        Top = 176
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0'
      end
    end
    object Transforms: TTabSheet
      Caption = 'Transforms'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 16
        Top = 16
        Width = 44
        Height = 13
        Caption = '&Translate'
      end
      object Label16: TLabel
        Left = 16
        Top = 48
        Width = 27
        Height = 13
        Caption = '&Scale'
      end
      object Label17: TLabel
        Left = 16
        Top = 80
        Width = 32
        Height = 13
        Caption = '&Rotate'
      end
      object XTrans: TEdit
        Left = 80
        Top = 16
        Width = 49
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object YTrans: TEdit
        Left = 136
        Top = 16
        Width = 49
        Height = 21
        TabOrder = 1
        Text = '0'
      end
      object ZTrans: TEdit
        Left = 192
        Top = 16
        Width = 49
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object XScale: TEdit
        Left = 80
        Top = 48
        Width = 49
        Height = 21
        TabOrder = 3
        Text = '0'
      end
      object YScale: TEdit
        Left = 136
        Top = 48
        Width = 49
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object ZScale: TEdit
        Left = 192
        Top = 48
        Width = 49
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object XRotate: TEdit
        Left = 80
        Top = 80
        Width = 49
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object YRotate: TEdit
        Left = 136
        Top = 80
        Width = 49
        Height = 21
        TabOrder = 7
        Text = '0'
      end
      object ZRotate: TEdit
        Left = 192
        Top = 80
        Width = 49
        Height = 21
        TabOrder = 8
        Text = '0'
      end
    end
    object ColourMap: TTabSheet
      Caption = 'Colour Map'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MapPanel: TPanel
        Left = 8
        Top = 8
        Width = 289
        Height = 73
        Color = clBlack
        TabOrder = 0
        object MapImage: TImage
          Left = 8
          Top = 8
          Width = 273
          Height = 57
        end
      end
      object EditMap: TButton
        Left = 8
        Top = 88
        Width = 75
        Height = 25
        Caption = '&Edit...'
        TabOrder = 1
        OnClick = EditMapClick
      end
    end
  end
end
