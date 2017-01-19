object RenderMegaDlg: TRenderMegaDlg
  Left = 237
  Top = 311
  BorderStyle = bsDialog
  Caption = 'Render Megahedron'
  ClientHeight = 244
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
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 88
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 313
    Height = 201
    ActivePage = FileSheet
    Align = alTop
    TabOrder = 0
    object FileSheet: TTabSheet
      Caption = 'File'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 50
        Height = 13
        Caption = '&Scene File'
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 50
        Height = 13
        Caption = '&Image size'
      end
      object Label3: TLabel
        Left = 8
        Top = 72
        Width = 35
        Height = 13
        Caption = '&Render'
      end
      object Label4: TLabel
        Left = 8
        Top = 104
        Width = 30
        Height = 13
        Caption = '&Edges'
      end
      object Label5: TLabel
        Left = 8
        Top = 136
        Width = 32
        Height = 13
        Caption = '&Facets'
      end
      object SceneFile: TEdit
        Left = 72
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object BrowseBtn: TButton
        Left = 200
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Browse...'
        TabOrder = 1
      end
      object ImageSize: TComboBox
        Left = 72
        Top = 40
        Width = 73
        Height = 21
        TabOrder = 2
        Text = '320x240'
        Items.Strings = (
          '160x120'
          '320x240'
          '640x480'
          '1024x768'
          '1280x1024')
      end
      object RenderType: TComboBox
        Left = 72
        Top = 72
        Width = 121
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        Items.Strings = (
          'Point Plot'
          'Wireframe'
          'Hidden Line'
          'Shaded')
      end
      object Edges: TComboBox
        Left = 72
        Top = 104
        Width = 89
        Height = 21
        Style = csDropDownList
        TabOrder = 4
        Items.Strings = (
          'Silhouette'
          'Outline'
          'All')
      end
      object Facets: TEdit
        Left = 72
        Top = 136
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object FacetUpDown: TUpDown
        Left = 137
        Top = 136
        Width = 12
        Height = 21
        Associate = Facets
        TabOrder = 6
      end
    end
    object ShadedSheet: TTabSheet
      Caption = 'Shaded'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 16
        Top = 8
        Width = 45
        Height = 13
        Caption = 'S&canning'
      end
      object Shadows: TCheckBox
        Left = 16
        Top = 64
        Width = 97
        Height = 17
        Caption = '&Shadows'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object Reflection: TCheckBox
        Left = 16
        Top = 88
        Width = 97
        Height = 17
        Caption = '&Reflection'
        TabOrder = 3
      end
      object Refraction: TCheckBox
        Left = 16
        Top = 112
        Width = 97
        Height = 17
        Caption = 'R&efraction'
        TabOrder = 4
      end
      object Scanning: TComboBox
        Left = 72
        Top = 8
        Width = 89
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'Linear'
          'Ordered'
          'Random')
      end
      object AntiAliasing: TCheckBox
        Left = 16
        Top = 40
        Width = 81
        Height = 17
        Caption = '&AntiAliasing'
        TabOrder = 1
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'smpl'
    Filter = 'Megahedron (*.smpl)|*.smpl'
    Left = 276
    Top = 208
  end
end
