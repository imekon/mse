object TextureForm: TTextureForm
  Left = 75
  Top = 103
  Caption = 'Textures'
  ClientHeight = 562
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000099
    99999900AAAAAAAAA00CCCCCCC00009999999900AAAAAAAAA00CCCCCCC000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFC0300603C0300603C0300603C0300603C0300603C0300603C030
    0603C0300603C0300603C0300603C0300603C0300603C0300603C0300603C030
    0603C0300603C0300603C0300603C0300603C0300603C0300603C0300603C030
    0603C0300603C0300603C0300603C0300603C0300603FFFFFFFFFFFFFFFF}
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 177
    Top = 22
    Height = 521
    ExplicitTop = 24
    ExplicitHeight = 532
  end
  object Splitter1: TSplitter
    Left = 721
    Top = 22
    Height = 521
    Align = alRight
    ExplicitLeft = 729
    ExplicitTop = 24
    ExplicitHeight = 532
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 543
    Width = 919
    Height = 19
    Panels = <>
  end
  object PageControl: TPageControl
    Left = 180
    Top = 22
    Width = 541
    Height = 521
    ActivePage = UserSheet
    Align = alClient
    TabOrder = 1
    ExplicitTop = 24
    ExplicitHeight = 519
    object UserSheet: TTabSheet
      Caption = 'User'
      ImageIndex = 7
      ExplicitHeight = 132
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 28
        Height = 13
        Caption = '&Name'
      end
      object Label4: TLabel
        Left = 8
        Top = 32
        Width = 37
        Height = 13
        Caption = '&Declare'
      end
      object Label5: TLabel
        Left = 8
        Top = 56
        Width = 16
        Height = 13
        Caption = '&File'
      end
      object FilenameBrowse: TSpeedButton
        Left = 184
        Top = 56
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          555555555555555555555555555555555555555FFFFFFFFFF555550000000000
          55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
          B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
          000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
          555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
          55555575FFF75555555555700007555555555557777555555555555555555555
          5555555555555555555555555555555555555555555555555555}
        NumGlyphs = 2
        OnClick = FilenameBrowseClick
      end
      object UserName: TEdit
        Left = 56
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = SetDirty
      end
      inline UserRGBFTFrame: TRGBFTFrame
        Left = 0
        Top = 88
        Width = 360
        Height = 166
        TabOrder = 1
        ExplicitTop = 88
        inherited Label1: TLabel
          Width = 20
          ExplicitWidth = 20
        end
        inherited Label3: TLabel
          Width = 21
          ExplicitWidth = 21
        end
        inherited Label4: TLabel
          Width = 22
          ExplicitWidth = 22
        end
        inherited Label5: TLabel
          Width = 40
          ExplicitWidth = 40
        end
        inherited Label6: TLabel
          Width = 30
          ExplicitWidth = 30
        end
      end
      object DeclareName: TEdit
        Left = 56
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 2
        OnChange = SetDirty
      end
      object Filename: TEdit
        Left = 56
        Top = 56
        Width = 121
        Height = 21
        TabOrder = 3
        OnChange = SetDirty
      end
    end
    object ColourSheet: TTabSheet
      Caption = 'Colour'
      ExplicitHeight = 132
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 28
        Height = 13
        Caption = '&Name'
      end
      object ColourName: TEdit
        Left = 56
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = SetDirty
      end
      inline ColourRGBFTFrame: TRGBFTFrame
        Left = 0
        Top = 40
        Width = 360
        Height = 166
        TabOrder = 1
        ExplicitTop = 40
        inherited Label1: TLabel
          Width = 20
          ExplicitWidth = 20
        end
        inherited Label3: TLabel
          Width = 21
          ExplicitWidth = 21
        end
        inherited Label4: TLabel
          Width = 22
          ExplicitWidth = 22
        end
        inherited Label5: TLabel
          Width = 40
          ExplicitWidth = 40
        end
        inherited Label6: TLabel
          Width = 30
          ExplicitWidth = 30
        end
        inherited Red: TEdit
          OnChange = SetDirty
        end
        inherited Green: TEdit
          OnChange = SetDirty
        end
        inherited Blue: TEdit
          OnChange = SetDirty
        end
        inherited Filter: TEdit
          OnChange = SetDirty
        end
        inherited Transmit: TEdit
          OnChange = SetDirty
        end
        inherited ColourList: TComboBox
          OnChange = SetDirty
        end
      end
    end
    object MapSheet: TTabSheet
      Caption = 'Map'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label32: TLabel
        Left = 8
        Top = 8
        Width = 28
        Height = 13
        Caption = '&Name'
      end
      object Label38: TLabel
        Left = 8
        Top = 376
        Width = 27
        Height = 13
        Caption = '&Value'
      end
      object MapCopyBtn: TSpeedButton
        Left = 8
        Top = 176
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330B7FFF
          FFB0333333777F3333773333330B7FFFFFB0333333777F3333773333330B7FFF
          FFB0333333777F3333773333330B7FFFFFB03FFFFF777FFFFF77000000000077
          007077777777777777770FFFFFFFF00077B07F33333337FFFF770FFFFFFFF000
          7BB07F3FF3FFF77FF7770F00F000F00090077F77377737777F770FFFFFFFF039
          99337F3FFFF3F7F777FF0F0000F0F09999937F7777373777777F0FFFFFFFF999
          99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
          99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
          93337FFFF7737777733300000033333333337777773333333333}
        NumGlyphs = 2
        OnClick = MapCopyBtnClick
      end
      object MapPasteBtn: TSpeedButton
        Left = 40
        Top = 176
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330FFFFF
          FFF03333337F3FFFF3F73333330F0000F0F03333337F777737373333330FFFFF
          FFF033FFFF7FFF33FFF77000000007F00000377777777FF777770BBBBBBBB0F0
          FF037777777777F7F3730B77777BB0F0F0337777777777F7F7330B7FFFFFB0F0
          0333777F333377F77F330B7FFFFFB0009333777F333377777FF30B7FFFFFB039
          9933777F333377F777FF0B7FFFFFB0999993777F33337777777F0B7FFFFFB999
          9999777F3333777777770B7FFFFFB0399933777FFFFF77F777F3070077007039
          99337777777777F777F30B770077B039993377FFFFFF77F777330BB7007BB999
          93337777FF777777733370000000073333333777777773333333}
        NumGlyphs = 2
        OnClick = MapPasteBtnClick
      end
      object Label50: TLabel
        Left = 216
        Top = 8
        Width = 24
        Height = 13
        Caption = '&Type'
      end
      object ValuePanel: TPanel
        Left = 8
        Top = 120
        Width = 385
        Height = 25
        TabOrder = 2
        object ValuePaintBox: TPaintBox
          Left = 8
          Top = 0
          Width = 369
          Height = 25
          DragCursor = crSizeWE
          OnDragOver = ValuePaintBoxDragOver
          OnEndDrag = ValuePaintBoxEndDrag
          OnMouseDown = ValuePaintBoxMouseDown
          OnPaint = ValuePaintBoxPaint
        end
      end
      object ButtonPanel: TPanel
        Left = 8
        Top = 144
        Width = 385
        Height = 25
        TabOrder = 3
        object ButtonPaintBox: TPaintBox
          Left = 8
          Top = 0
          Width = 369
          Height = 17
          OnMouseDown = ButtonPaintBoxMouseDown
          OnPaint = ButtonPaintBoxPaint
        end
      end
      object MapName: TEdit
        Left = 56
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = SetDirty
      end
      object MapPanel: TPanel
        Left = 8
        Top = 40
        Width = 385
        Height = 81
        Color = clBlack
        TabOrder = 1
        object MapImage: TImage
          Left = 8
          Top = 8
          Width = 369
          Height = 73
        end
      end
      object MapValue: TEdit
        Left = 56
        Top = 376
        Width = 57
        Height = 21
        TabOrder = 4
        Text = '1'
        OnChange = SetDirty
      end
      object MapAdd: TButton
        Left = 136
        Top = 176
        Width = 75
        Height = 25
        Caption = '&Add'
        TabOrder = 5
        OnClick = MapAddClick
      end
      object MapRemove: TButton
        Left = 216
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Remove'
        TabOrder = 6
        OnClick = MapRemoveClick
      end
      object MapAssign: TButton
        Left = 120
        Top = 376
        Width = 75
        Height = 25
        Caption = 'A&ssign'
        TabOrder = 7
        OnClick = MapAssignClick
      end
      object MapType: TComboBox
        Left = 248
        Top = 8
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 8
        OnChange = SetDirty
        Items.Strings = (
          'Agate'
          'Average'
          'Bozo'
          'Bumps'
          'Crackle'
          'Dents'
          'Gradient'
          'Granite'
          'Leopard'
          'Mandel'
          'Marble'
          'Onion'
          'Quilted'
          'Radial'
          'Ripples'
          'Spiral1'
          'Spiral2'
          'Spotted'
          'Waves'
          'Wood'
          'Wrinkles')
      end
      inline MapTurbulenceFrame: TTurbulenceFrame
        Left = 352
        Top = 312
        Width = 177
        Height = 148
        TabOrder = 9
        ExplicitLeft = 352
        ExplicitTop = 312
        inherited GroupBox1: TGroupBox
          inherited Label9: TLabel
            Width = 54
            ExplicitWidth = 54
          end
          inherited Label11: TLabel
            Width = 38
            ExplicitWidth = 38
          end
        end
      end
      inline MapRGBFTFrame: TRGBFTFrame
        Left = 0
        Top = 208
        Width = 360
        Height = 166
        TabOrder = 10
        ExplicitTop = 208
        inherited Label1: TLabel
          Width = 20
          ExplicitWidth = 20
        end
        inherited Label3: TLabel
          Width = 21
          ExplicitWidth = 21
        end
        inherited Label4: TLabel
          Width = 22
          ExplicitWidth = 22
        end
        inherited Label5: TLabel
          Width = 40
          ExplicitWidth = 40
        end
        inherited Label6: TLabel
          Width = 30
          ExplicitWidth = 30
        end
      end
    end
    object CheckerSheet: TTabSheet
      Caption = 'Checker'
      ExplicitHeight = 132
      object Label39: TLabel
        Left = 8
        Top = 8
        Width = 28
        Height = 13
        Caption = '&Name'
      end
      object CheckerName: TEdit
        Left = 56
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = SetDirty
      end
      inline CheckerRGBFTFrame1: TRGBFTFrame
        Left = 0
        Top = 40
        Width = 360
        Height = 166
        TabOrder = 1
        ExplicitTop = 40
        inherited Label1: TLabel
          Width = 20
          ExplicitWidth = 20
        end
        inherited Label3: TLabel
          Width = 21
          ExplicitWidth = 21
        end
        inherited Label4: TLabel
          Width = 22
          ExplicitWidth = 22
        end
        inherited Label5: TLabel
          Width = 40
          ExplicitWidth = 40
        end
        inherited Label6: TLabel
          Width = 30
          ExplicitWidth = 30
        end
      end
      inline CheckerRGBFTFrame2: TRGBFTFrame
        Left = 0
        Top = 208
        Width = 360
        Height = 166
        TabOrder = 2
        ExplicitTop = 208
        inherited Label1: TLabel
          Width = 20
          ExplicitWidth = 20
        end
        inherited Label3: TLabel
          Width = 21
          ExplicitWidth = 21
        end
        inherited Label4: TLabel
          Width = 22
          ExplicitWidth = 22
        end
        inherited Label5: TLabel
          Width = 40
          ExplicitWidth = 40
        end
        inherited Label6: TLabel
          Width = 30
          ExplicitWidth = 30
        end
      end
    end
    object NormalSheet: TTabSheet
      Caption = 'Normal'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 24
        Height = 13
        Caption = '&Type'
      end
      object Label8: TLabel
        Left = 8
        Top = 32
        Width = 27
        Height = 13
        Caption = '&Value'
      end
      object NormalType: TComboBox
        Left = 56
        Top = 8
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = SetDirty
        Items.Strings = (
          'None'
          'Agate'
          'Average'
          'Bozo'
          'Brick'
          'Bumps'
          'Checker'
          'Crackle'
          'Dents'
          'Gradient'
          'Granite'
          'Hexagon'
          'Leopard'
          'Mandel'
          'Marble'
          'Onion'
          'Quilted'
          'Radial'
          'Ripples'
          'Spiral1'
          'Spiral2'
          'Spotted'
          'Waves'
          'Wood'
          'Wrinkles')
      end
      object NormalValue: TEdit
        Left = 56
        Top = 32
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = SetDirty
      end
      inline NormalTurbulenceFrame: TTurbulenceFrame
        Left = 224
        Top = 8
        Width = 177
        Height = 148
        TabOrder = 2
        ExplicitLeft = 224
        ExplicitTop = 8
        inherited GroupBox1: TGroupBox
          inherited Label9: TLabel
            Width = 54
            ExplicitWidth = 54
          end
          inherited Label11: TLabel
            Width = 38
            ExplicitWidth = 38
          end
        end
      end
    end
    object FinishSheet: TTabSheet
      Caption = 'Finish'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label13: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = '&Diffuse'
      end
      object Label14: TLabel
        Left = 8
        Top = 32
        Width = 42
        Height = 13
        Caption = '&Brilliance'
      end
      object Label15: TLabel
        Left = 8
        Top = 56
        Width = 28
        Height = 13
        Caption = '&Crand'
      end
      object Label16: TLabel
        Left = 8
        Top = 80
        Width = 38
        Height = 13
        Caption = '&Ambient'
      end
      object Label17: TLabel
        Left = 8
        Top = 104
        Width = 48
        Height = 13
        Caption = '&Reflection'
      end
      object Label18: TLabel
        Left = 8
        Top = 128
        Width = 31
        Height = 13
        Caption = '&Phong'
      end
      object Label19: TLabel
        Left = 8
        Top = 152
        Width = 42
        Height = 13
        Caption = '&Specular'
      end
      object Label20: TLabel
        Left = 8
        Top = 200
        Width = 49
        Height = 13
        Caption = 'Re&fraction'
      end
      object Label21: TLabel
        Left = 8
        Top = 224
        Width = 40
        Height = 13
        Caption = 'Ca&ustics'
      end
      object Label22: TLabel
        Left = 8
        Top = 248
        Width = 24
        Height = 13
        Caption = '&Fade'
      end
      object Label23: TLabel
        Left = 8
        Top = 272
        Width = 55
        Height = 13
        Caption = '&Iridescence'
      end
      object FinishDiffuse: TEdit
        Left = 72
        Top = 8
        Width = 65
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = SetDirty
      end
      object FinishBrilliance: TEdit
        Left = 72
        Top = 32
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = SetDirty
      end
      object FinishCrand: TEdit
        Left = 72
        Top = 56
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = SetDirty
      end
      object FinishAmbient: TEdit
        Left = 72
        Top = 80
        Width = 65
        Height = 21
        TabOrder = 3
        Text = '0'
        OnChange = SetDirty
      end
      object FinishReflection: TEdit
        Left = 72
        Top = 104
        Width = 65
        Height = 21
        TabOrder = 4
        Text = '0'
        OnChange = SetDirty
      end
      object FinishPhong: TEdit
        Left = 72
        Top = 128
        Width = 65
        Height = 21
        TabOrder = 5
        Text = '0'
        OnChange = SetDirty
      end
      object FinishPhongSize: TEdit
        Left = 144
        Top = 128
        Width = 65
        Height = 21
        TabOrder = 6
        Text = '0'
        OnChange = SetDirty
      end
      object FinishSpecular: TEdit
        Left = 72
        Top = 152
        Width = 65
        Height = 21
        TabOrder = 7
        Text = '0'
        OnChange = SetDirty
      end
      object FinishRoughness: TEdit
        Left = 144
        Top = 152
        Width = 65
        Height = 21
        TabOrder = 8
        Text = '0'
        OnChange = SetDirty
      end
      object FinishMetallic: TCheckBox
        Left = 8
        Top = 176
        Width = 105
        Height = 17
        Alignment = taLeftJustify
        Caption = '&Metallic'
        TabOrder = 9
        OnClick = SetDirty
      end
      object FinishRefraction: TEdit
        Left = 72
        Top = 200
        Width = 65
        Height = 21
        TabOrder = 10
        Text = '0'
        OnChange = SetDirty
      end
      object FinishIOR: TEdit
        Left = 144
        Top = 200
        Width = 65
        Height = 21
        TabOrder = 11
        Text = '0'
        OnChange = SetDirty
      end
      object FinishCaustics: TEdit
        Left = 72
        Top = 224
        Width = 65
        Height = 21
        TabOrder = 12
        Text = '0'
        OnChange = SetDirty
      end
      object FinishFade: TEdit
        Left = 72
        Top = 248
        Width = 65
        Height = 21
        TabOrder = 13
        Text = '0'
        OnChange = SetDirty
      end
      object FinishFadePower: TEdit
        Left = 144
        Top = 248
        Width = 65
        Height = 21
        TabOrder = 14
        Text = '0'
        OnChange = SetDirty
      end
      object FinishIrid: TEdit
        Left = 72
        Top = 272
        Width = 65
        Height = 21
        TabOrder = 15
        Text = '0'
        OnChange = SetDirty
      end
      object FinishIridThickness: TEdit
        Left = 144
        Top = 272
        Width = 65
        Height = 21
        TabOrder = 16
        Text = '0'
        OnChange = SetDirty
      end
      inline FinishTurbulenceFrame: TTurbulenceFrame
        Left = 224
        Top = 8
        Width = 177
        Height = 148
        TabOrder = 17
        ExplicitLeft = 224
        ExplicitTop = 8
        inherited GroupBox1: TGroupBox
          inherited Label9: TLabel
            Width = 54
            ExplicitWidth = 54
          end
          inherited Label11: TLabel
            Width = 38
            ExplicitWidth = 38
          end
        end
      end
    end
    object HaloSheet: TTabSheet
      Caption = 'Halo'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TransformationSheet: TTabSheet
      Caption = 'Transformation'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object PreviewPanel: TPanel
    Left = 724
    Top = 22
    Width = 195
    Height = 521
    Align = alRight
    TabOrder = 2
    ExplicitTop = 24
    ExplicitHeight = 519
    DesignSize = (
      195
      521)
    object Label2: TLabel
      Left = 8
      Top = 192
      Width = 31
      Height = 13
      Caption = '&Shape'
    end
    object ApplyBtn: TButton
      Left = 8
      Top = 479
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '&Apply'
      Default = True
      TabOrder = 0
      OnClick = ApplyBtnClick
      ExplicitTop = 477
    end
    object ImagePreviewPanel: TPanel
      Left = 8
      Top = 8
      Width = 177
      Height = 137
      BevelOuter = bvLowered
      TabOrder = 1
      object PreviewImage: TImage
        Left = 8
        Top = 8
        Width = 160
        Height = 120
        Picture.Data = {
          07544269746D61709E090000424D9E090000000000003E00000028000000A000
          0000780000000100010000000000600900000000000000000000020000000200
          000000000000FFFFFF0000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000007C000000000000000000
          00000000000000000000FE00000000000000000000000000000000000000C300
          0000000000000000000000181878066318F63B0E018030380C30E0E380000018
          38FC066319FC7F1F0180307C1C31F0E38000001879CE0663198CE739818030E6
          1C3398E38000001859860663198CC330018030C03E3300F780000018D9860663
          18FCC33F818030FE3633F9B6C000001999860663181CC33F81FC30FE3633F9BE
          C000001999CE0673998CE73181FE30C66333199CC000001B18FC067FF8FC7F1F
          01833E7C6331F31C6000001E1878066E70783B0E018336386330E31C6000001E
          180006000000000001830000000000000000001C180006000000000001FE0000
          0030000000000018180006000000000001FC0000003000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000}
      end
    end
    object PreviewBtn: TButton
      Left = 8
      Top = 152
      Width = 75
      Height = 25
      Caption = '&Preview'
      TabOrder = 2
      OnClick = PreviewBtnClick
    end
    object Shape: TComboBox
      Left = 48
      Top = 192
      Width = 89
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'Sphere'
        'Cube'
        'Cylinder')
    end
    object Floor: TCheckBox
      Left = 8
      Top = 224
      Width = 57
      Height = 17
      Caption = '&Floor'
      TabOrder = 4
    end
    object Wall: TCheckBox
      Left = 8
      Top = 256
      Width = 57
      Height = 17
      Caption = '&Wall'
      TabOrder = 5
    end
    object Panel1: TPanel
      Left = 72
      Top = 224
      Width = 25
      Height = 25
      BevelOuter = bvLowered
      TabOrder = 6
      object FloorColour: TShape
        Left = 1
        Top = 1
        Width = 23
        Height = 23
        Align = alClient
        Brush.Color = clGreen
        Pen.Color = clNone
        OnMouseDown = FloorColourMouseDown
      end
    end
    object Panel2: TPanel
      Left = 72
      Top = 256
      Width = 25
      Height = 25
      BevelOuter = bvLowered
      TabOrder = 7
      object WallColour: TShape
        Left = 1
        Top = 1
        Width = 23
        Height = 23
        Align = alClient
        Brush.Color = clBlue
        Pen.Color = clNone
        OnMouseDown = WallColourMouseDown
      end
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 919
    Height = 22
    AutoSize = True
    Caption = 'ToolBar1'
    Images = ToolbarImageList
    Indent = 5
    TabOrder = 3
    object ToolButton1: TToolButton
      Left = 5
      Top = 0
      Action = NewAction
    end
    object ToolButton2: TToolButton
      Left = 28
      Top = 0
      Action = DeleteAction
    end
    object ToolButton3: TToolButton
      Left = 51
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 59
      Top = 0
      Caption = 'ToolButton4'
      ImageIndex = 2
    end
    object ToolButton5: TToolButton
      Left = 82
      Top = 0
      Caption = 'ToolButton5'
      ImageIndex = 3
    end
    object ToolButton6: TToolButton
      Left = 105
      Top = 0
      Caption = 'ToolButton6'
      ImageIndex = 4
    end
  end
  object TextureList: TTreeView
    Left = 0
    Top = 22
    Width = 177
    Height = 521
    Align = alLeft
    HideSelection = False
    Images = TextureImage
    Indent = 19
    ReadOnly = True
    TabOrder = 4
    OnChange = TextureListChange
    OnChanging = TextureListChanging
  end
  object MainMenu: TMainMenu
    Images = ToolbarImageList
    Left = 48
    Top = 72
    object TextureMenu: TMenuItem
      Caption = '&Texture'
      object NewItem: TMenuItem
        Action = NewAction
      end
      object DeleteItem: TMenuItem
        Action = DeleteAction
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object LoadItem: TMenuItem
        Action = LoadAction
      end
      object SaveItem: TMenuItem
        Action = SaveAction
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CloseItem: TMenuItem
        Action = CloseAction
      end
    end
    object EditMenu: TMenuItem
      Caption = '&Edit'
      object CutItem: TMenuItem
        Action = CutAction
      end
      object CopyItem: TMenuItem
        Action = CopyAction
      end
      object PasteItem: TMenuItem
        Action = PasteAction
      end
    end
    object HelpMenu: TMenuItem
      Caption = '&Help'
      object AboutItem: TMenuItem
        Caption = '&About...'
      end
    end
  end
  object TextureImage: TImageList
    Left = 88
    Top = 120
  end
  object ColorDialog: TColorDialog
    Left = 816
    Top = 362
  end
  object ToolbarImageList: TImageList
    Left = 96
    Top = 162
    Bitmap = {
      494C010105000900240010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F0000FFFF0000FFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      00007F7F7F007F7F7F0000000000000000007F7F7F0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF007F7F7F007F7F
      7F0000000000000000007F7F7F007F7F7F0000FFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF007F7F
      7F0000000000000000007F7F7F0000FFFF0000FFFF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007F7F7F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000FF00000000000000FF000000FF00
      000000000000000000000000000000000000000000007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F0000000000000000007F7F7F0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF00000000000000000000000000FF00000000000000000000000000
      0000FF0000000000000000000000000000007F7F7F007F7F7F00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F007F7F7F0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      FF000000FF00000000000000000000000000FF000000FF000000000000000000
      0000000000000000000000000000FFFFFF007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007F7F7F0000FFFF0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000000000000000FF000000
      FF000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      00000000FF0000000000000000007F7F7F00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000FF000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000FF0000000000
      000000000000FF000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000BFBF
      BF00FFFFFF0000000000FFFFFF000000000000000000000000007F7F7F000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FC00000000000000FC00000000000000
      FC00000000000000000000000000000000010000000000000003000000000000
      0007000000000000000700000000000000230000000000000001000000000000
      0000000000000000002300000000000000230000000000000023000000000000
      0007000000000000003F000000000000FFFFFFFFFFFFFC00FFFFFFFFFFE7FC00
      C003EFFDFFC7FC00C003C7FF8F8FFC00C003C3FB07000000C003E3F732000000
      C003F1E700000000C003F8CF80000000C003FC1FF9000023C007FE3FE1000001
      C00FFC1FC9000000C01FF8CFC9000023C03FE1E7C3000063C07FC3F3E30000C3
      FFFFC7FDFF010107FFFFFFFFFF0303FF00000000000000000000000000000000
      000000000000}
  end
  object ActionList: TActionList
    Images = ToolbarImageList
    Left = 56
    Top = 197
    object NewAction: TAction
      Category = 'Texture'
      Caption = '&New...'
      ImageIndex = 0
      OnExecute = NewItemClick
    end
    object DeleteAction: TAction
      Category = 'Texture'
      Caption = '&Delete'
      ImageIndex = 1
    end
    object LoadAction: TAction
      Category = 'Texture'
      Caption = '&Load...'
      OnExecute = LoadActionExecute
    end
    object SaveAction: TAction
      Category = 'Texture'
      Caption = '&Save...'
    end
    object CloseAction: TAction
      Category = 'Texture'
      Caption = '&Close'
      OnExecute = CloseItemClick
    end
    object CutAction: TAction
      Category = 'Edit'
      Caption = 'C&ut'
      ImageIndex = 2
    end
    object CopyAction: TAction
      Category = 'Edit'
      Caption = '&Copy'
      ImageIndex = 3
    end
    object PasteAction: TAction
      Category = 'Edit'
      Caption = 'PasteAction'
      ImageIndex = 4
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'inc'
    Filter = 'POVray include files|*.inc|POVray source files|*.pov'
    Left = 80
    Top = 264
  end
end
