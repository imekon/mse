object PolyEditor: TPolyEditor
  Left = 123
  Top = 128
  Caption = 'Polygon Editor'
  ClientHeight = 502
  ClientWidth = 698
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
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000088888888888888888800000000000
    0000888888888888888800000000000000008888888888888888000000000000
    0000088888888888888000000000000000000888888888888880000000000000
    0000008888888888880000000000000000000088888888888800000000000000
    0000000888888888800000000000000000000008888888888000000000000000
    0000000088888888000000000000000000000000888888880000000000000000
    0000000008888880000000000000000000000000088888800000000000000000
    0000000000888800000000000000000000000000008888000000000000000000
    0000000000088000000000000000000000000000000880000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00003FFC00003FFE00
    007FFE00007FFF0000FFFF0000FFFF8001FFFF8001FFFFC003FFFFC003FFFFE0
    07FFFFE007FFFFF00FFFFFF00FFFFFF81FFFFFF81FFFFFFC3FFFFFFC3FFFFFFE
    7FFFFFFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  Menu = MainMenu
  OldCreateOrder = True
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonBar: TPanel
    Left = 0
    Top = 461
    Width = 698
    Height = 41
    Align = alBottom
    TabOrder = 0
    object StatusPanel: TPanel
      Left = 8
      Top = 8
      Width = 185
      Height = 25
      BevelOuter = bvLowered
      Caption = 'x: 0 y: 0 z: 0'
      TabOrder = 0
    end
    object CloseBtn: TButton
      Left = 200
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Close'
      TabOrder = 1
      OnClick = CloseBtnClick
    end
  end
  object TabSet: TTabSet
    Left = 0
    Top = 440
    Width = 698
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Tabs.Strings = (
      'Front'
      'Back'
      'Top'
      'Bottom'
      'Left'
      'Right')
    TabIndex = 0
    OnClick = TabSetClick
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 72
    Width = 698
    Height = 368
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clBlack
    ParentColor = False
    TabOrder = 2
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 2000
      Height = 2000
      OnDragOver = PaintBoxDragOver
      OnEndDrag = PaintBoxEndDrag
      OnMouseDown = PaintBoxMouseDown
      OnMouseMove = PaintBoxMouseMove
      OnPaint = PaintBoxPaint
    end
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 698
    Height = 72
    AutoSize = True
    Bands = <
      item
        Control = Toolbar
        ImageIndex = -1
        MinHeight = 33
        Width = 697
      end
      item
        Control = EditBar
        ImageIndex = -1
        MinHeight = 33
        Width = 697
      end>
    object Toolbar: TPanel
      Left = 11
      Top = 0
      Width = 683
      Height = 33
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object SelectBtn: TSpeedButton
        Left = 8
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Select|'
        GroupIndex = 1
        Down = True
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777700777777777777770077777777777770077777777770777007
          7777777770070077777777777000007777777777700000000777777770000000
          7777777770000007777777777000007777777777700007777777777770007777
          7777777770077777777777777077777777777777777777777777}
        OnClick = SelectItemClick
      end
      object TranslateBtn: TSpeedButton
        Left = 112
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Translate|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777707777777777777700077777777777700000777777777777000777
          7777770777000777077770000000000000770000000000000007700000000000
          0077770777000777077777777700077777777777700000777777777777000777
          7777777777707777777777777777777777777777777777777777}
        OnClick = TranslateItemClick
      end
      object TriangleBtn: TSpeedButton
        Left = 304
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Triangle|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777000000000000777708888888888077777088888888
          0777777088888888077777770888888077777777088888807777777770888807
          7777777770888807777777777708807777777777770880777777777777700777
          7777777777700777777777777777777777777777777777777777}
        OnClick = TriangleItemClick
      end
      object MeshBtn: TSpeedButton
        Left = 328
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Mesh/Sheet|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777770000000000000777088088088088077708808808808
          8077700000000000007770880880880880777088088088088077700000000000
          0077708808808808807770880880880880777000000000000077708808808808
          8077708808808808807770000000000000777777777777777777}
        OnClick = MeshItemClick
      end
      object SphereBtn: TSpeedButton
        Left = 352
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Sphere|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777770000007777777770888888077777770888888880777770888888888
          8077708888888888880770888888888888077088888888888807708888888888
          8807708888888888880777088888888880777770888888880777777708888880
          7777777770000007777777777777777777777777777777777777}
        OnClick = SphereItemClick
      end
      object CubeBtn: TSpeedButton
        Left = 376
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Cube|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777000000000077777008888888007777080888888
          8807770880888880880770008080800888077088808888088807708880888888
          8807708880888808880770888000000000077088088888088077708088888888
          0777700888888800777770000000000777777777777777777777}
        OnClick = CubeItemClick
      end
      object ConeBtn: TSpeedButton
        Left = 400
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Cone|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777700000000777777008888888800777088888888888807770888888888
          8077770888888888807777708888888807777770888888880777777708888880
          7777777708888880777777777088880777777777708888077777777777088077
          7777777777088077777777777770077777777777777777777777}
        OnClick = ConeItemClick
      end
      object CylinderBtn: TSpeedButton
        Left = 424
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Cylinder|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777700000000777777008888888800777088888888888807708888888888
          8807708888888888880770888888888888077088888888888807708888888888
          8807708888888888880770880000000088077000080808080007708080808080
          8007770008080808007777770000000077777777777777777777}
        OnClick = CylinderItemClick
      end
      object DiscBtn: TSpeedButton
        Left = 448
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Disc|'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777000000777777777088888807777777088888888
          0777770888000088807770888077770888077088077777708807708807777770
          8807708807777770880770888077770888077708880000888077777088888888
          0777777708888880777777777000000777777777777777777777}
        OnClick = DiskItemClick
      end
      object DeleteBtn: TSpeedButton
        Left = 272
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Delete|'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777777777777777777777777777777777977777777
          7797778777777777787777999777777777777888777777777777779999777777
          7977788887777777877777799977777797777788877777787777777799977779
          9777777888777788777777777999779977777777888778877777777777999997
          7777777778888877777777777779997777777777778887777777777777999997
          7777777778888877777777777999779977777777888778877777777999977779
          9777778888777788777777999977777799777888877777788777779997777777
          7797788877777777787777777777777777777777777777777777}
        NumGlyphs = 2
        OnClick = DeleteItemClick
      end
      object CutBtn: TSpeedButton
        Left = 192
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Cut|'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333FF3333333333333003333333333333377F33333333333307
          733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
          000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
          777077777777777777773CCCCC00000000003777777777777777333330030FFF
          FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
          FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
          0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
          0F03333333337FFF7F7333333333000000333333333377777733}
        NumGlyphs = 2
        OnClick = CutItemClick
      end
      object CopyBtn: TSpeedButton
        Left = 216
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Copy|'
        Flat = True
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
        OnClick = CopyItemClick
      end
      object PasteBtn: TSpeedButton
        Left = 240
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Paste|'
        Flat = True
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
        OnClick = PasteItemClick
      end
      object ScaleBtn: TSpeedButton
        Left = 136
        Top = 4
        Width = 25
        Height = 25
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777770000000000777000000008888077708888880888
          8077708888880888807770888888088880777088888808888077708888880888
          8077708888880888807770888888088880777000000008888077777708888888
          8077700708888888807777070000000000777777777777777777}
        OnClick = ScaleItemClick
      end
      object RotateBtn: TSpeedButton
        Left = 160
        Top = 4
        Width = 25
        Height = 25
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777000000777777777088888807777777088000088
          0777770880000008807770888808880088077088888888800807708888888880
          0807708888888880080770888888880088077708888800088077777088880088
          0777777708888880777777777000000777777777777777777777}
        OnClick = RotateItemClick
      end
      object Selection: TComboBox
        Left = 40
        Top = 6
        Width = 65
        Height = 21
        Hint = 'Selection|'
        Style = csDropDownList
        TabOrder = 0
        OnChange = SelectionChange
        Items.Strings = (
          'Set'
          'Toggle'
          'Clear')
      end
    end
    object EditBar: TPanel
      Left = 11
      Top = 35
      Width = 683
      Height = 33
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object GridBtn: TSpeedButton
        Left = 192
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Grid|'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777877787778777877787778777877787778777877787
          7787780888088808880777877787778777877787778777877787778777877787
          7787780888088808880777877787778777877787778777877787778777877787
          7787780888088808880777877787778777877777777777777777}
        OnClick = GridItemClick
      end
      object ZoomBtn: TSpeedButton
        Left = 224
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Zoom|'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777777777007777777777777088077777777777088
          807777770000088807777770FFFF08807777770FFFFFF007777770FFFFFFFF07
          777770FFFFFFFF07777770F8FFFFFF07777770FF8FFFFF077777770FF8FFF077
          77777770FFFF0777777777770000777777777777777777777777}
        OnClick = ZoomItemClick
      end
      object ApplyBtn: TBitBtn
        Left = 8
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Apply|'
        Default = True
        Glyph.Data = {
          BE060000424DBE06000000000000360400002800000024000000120000000100
          0800000000008802000000000000000000000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A600000000000000000000000000000000000000000000000000000000000000
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
          000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
          0303030303030303030303030303030303030303030303030303030303030303
          03030303030303030303030303030303030303030303FF030303030303030303
          03030303030303040403030303030303030303030303030303F8F8FF03030303
          03030303030303030303040202040303030303030303030303030303F80303F8
          FF030303030303030303030303040202020204030303030303030303030303F8
          03030303F8FF0303030303030303030304020202020202040303030303030303
          0303F8030303030303F8FF030303030303030304020202FA0202020204030303
          0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
          040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
          03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
          FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
          0303030303030303030303FA0202020403030303030303030303030303F8FF03
          03F8FF03030303030303030303030303FA020202040303030303030303030303
          0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
          03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
          030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
          0202040303030303030303030303030303F8FF03F8FF03030303030303030303
          03030303FA0202030303030303030303030303030303F8FFF803030303030303
          030303030303030303FA0303030303030303030303030303030303F803030303
          0303030303030303030303030303030303030303030303030303030303030303
          0303}
        ModalResult = 1
        NumGlyphs = 2
        TabOrder = 0
      end
      object Xpt: TEdit
        Left = 40
        Top = 6
        Width = 41
        Height = 21
        Hint = 'X Coord|'
        TabOrder = 1
        Text = '0'
      end
      object YPt: TEdit
        Left = 80
        Top = 6
        Width = 41
        Height = 21
        Hint = 'Y Coord'
        TabOrder = 2
        Text = '0'
      end
      object ZPt: TEdit
        Left = 120
        Top = 6
        Width = 41
        Height = 21
        Hint = 'Z Coord'
        TabOrder = 3
        Text = '0'
      end
      object SmoothShaded: TCheckBox
        Left = 280
        Top = 8
        Width = 105
        Height = 17
        Caption = '&Smooth Shaded'
        TabOrder = 4
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 10
    Top = 160
    object FileMenu: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = '&Close'
        OnClick = CloseBtnClick
      end
    end
    object EditMenu: TMenuItem
      Caption = '&Edit'
      object CutItem: TMenuItem
        Caption = 'C&ut'
        ShortCut = 16472
        OnClick = CutItemClick
      end
      object CopyItem: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = CopyItemClick
      end
      object PasteItem: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = PasteItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object ClearAllItem: TMenuItem
        Caption = 'Clear &All'
        ShortCut = 16474
        OnClick = ClearAllItemClick
      end
      object SelectAllItem: TMenuItem
        Caption = '&Select All'
        ShortCut = 16449
        OnClick = SelectAllItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object DeleteItem: TMenuItem
        Caption = '&Delete'
        ShortCut = 46
        OnClick = DeleteItemClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object ScalingItem: TMenuItem
        Caption = '&Scaling...'
        OnClick = ScalingItemClick
      end
      object Flip1: TMenuItem
        Caption = '&Flip'
        object FlipXItem: TMenuItem
          Caption = '&X'
          OnClick = FlipXItemClick
        end
        object FlipYItem: TMenuItem
          Caption = '&Y'
          OnClick = FlipYItemClick
        end
        object FlipZItem: TMenuItem
          Caption = '&Z'
          OnClick = FlipZItemClick
        end
      end
    end
    object PolygonMenu: TMenuItem
      Caption = '&Polygon'
      object Create1: TMenuItem
        Caption = '&Create'
        GroupIndex = 1
        object TriangleItem: TMenuItem
          Caption = '&Triangle'
          GroupIndex = 1
          OnClick = TriangleItemClick
        end
        object MeshItem: TMenuItem
          Caption = '&Mesh'
          GroupIndex = 1
          OnClick = MeshItemClick
        end
        object SphereItem: TMenuItem
          Caption = '&Sphere'
          GroupIndex = 1
          OnClick = SphereItemClick
        end
        object CubeItem: TMenuItem
          Caption = '&Cube'
          GroupIndex = 1
          OnClick = CubeItemClick
        end
        object ConeItem: TMenuItem
          Caption = 'C&one'
          GroupIndex = 1
          OnClick = ConeItemClick
        end
        object CylinderItem: TMenuItem
          Caption = 'C&ylinder'
          GroupIndex = 1
          OnClick = CylinderItemClick
        end
        object DiskItem: TMenuItem
          Caption = '&Disk'
          GroupIndex = 1
          OnClick = DiskItemClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object SelectItem: TMenuItem
        Caption = '&Select'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 113
        OnClick = SelectItemClick
      end
      object TranslateItem: TMenuItem
        Caption = '&Translate'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 114
        OnClick = TranslateItemClick
      end
      object ScaleItem: TMenuItem
        Caption = 'S&cale'
        GroupIndex = 1
        ShortCut = 115
        OnClick = ScaleItemClick
      end
      object RotateItem: TMenuItem
        Caption = '&Rotate'
        GroupIndex = 1
        ShortCut = 116
        OnClick = RotateItemClick
      end
    end
    object OptionsMenu: TMenuItem
      Caption = '&Options'
      object CenterViewItem: TMenuItem
        Caption = '&Center View'
        OnClick = CenterViewItemClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object GridItem: TMenuItem
        Caption = '&Grid...'
        OnClick = GridItemClick
      end
      object ZoomItem: TMenuItem
        Caption = '&Zoom...'
        OnClick = ZoomItemClick
      end
    end
    object HelpMenu: TMenuItem
      Caption = '&Help'
      object AboutItem: TMenuItem
        Caption = '&About...'
        OnClick = AboutItemClick
      end
    end
  end
end