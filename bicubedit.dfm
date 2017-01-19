object BicubicEditor: TBicubicEditor
  Left = 191
  Top = 149
  Caption = 'Bicubic Patch'
  ClientHeight = 436
  ClientWidth = 566
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
    0000000000000000000000000000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000000
    0000000000000000000000000000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000000000000000000000000000000000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000000
    0000000000000000000000000000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000888888088888808888880888880000008
    8888808888880888888088888000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFC0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C0000003FFFFFFFFFFFFFFFF}
  Menu = MainMenu
  OldCreateOrder = True
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TPanel
    Left = 0
    Top = 398
    Width = 566
    Height = 38
    Align = alBottom
    TabOrder = 0
    object CoordPanel: TPanel
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
      Caption = 'Close'
      TabOrder = 1
      OnClick = CloseItemClick
    end
  end
  object TabSet: TTabSet
    Left = 0
    Top = 377
    Width = 566
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
    Top = 71
    Width = 566
    Height = 306
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
    Width = 566
    Height = 71
    AutoSize = True
    Bands = <
      item
        Control = ButtonBar
        ImageIndex = -1
        MinHeight = 33
        Width = 560
      end
      item
        Control = EditBar
        ImageIndex = -1
        MinHeight = 32
        Width = 560
      end>
    object ButtonBar: TPanel
      Left = 11
      Top = 0
      Width = 551
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
        Hint = 'Select'
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
      object MoveBtn: TSpeedButton
        Left = 112
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Translate'
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
        OnClick = MoveItemClick
      end
      object ScaleBtn: TSpeedButton
        Left = 136
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Scale'
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
        Hint = 'Rotate'
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
      object NewBtn: TSpeedButton
        Left = 192
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Create'
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777770000000000000777088088088088077708808808808807770000000000
          000777088B88088088077B088B880B80880777000B0000000007770B8B8B0880
          88077708808808808807BBBB000BBBB000077708808808808807770B8B8B0880
          880777000B00000000077B777B777B77777777777B7777777777}
        OnClick = CreateItemClick
      end
      object DeleteBtn: TSpeedButton
        Left = 224
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Delete'
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
      object GridBtn: TSpeedButton
        Left = 256
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Grid'
        Flat = True
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
        Left = 288
        Top = 4
        Width = 25
        Height = 25
        Hint = 'Zoom'
        Flat = True
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
      object Selection: TComboBox
        Left = 40
        Top = 6
        Width = 65
        Height = 21
        Hint = 'Selection'
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          'Set'
          'Toggle'
          'Clear')
      end
    end
    object EditBar: TPanel
      Left = 11
      Top = 35
      Width = 551
      Height = 32
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object ApplyBtn: TBitBtn
        Left = 8
        Top = 3
        Width = 25
        Height = 25
        Default = True
        Enabled = False
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
        NumGlyphs = 2
        TabOrder = 0
        OnClick = ApplyBtnClick
      end
      object PatchType: TComboBox
        Left = 40
        Top = 6
        Width = 97
        Height = 21
        Hint = 'Patch Type'
        Style = csDropDownList
        TabOrder = 1
        OnChange = OnValueChanged
        Items.Strings = (
          '0 - points'
          '1 - subpatches')
      end
      object Flatness: TEdit
        Left = 144
        Top = 6
        Width = 49
        Height = 21
        Hint = 'Flatness'
        TabOrder = 2
        Text = '0.01'
        OnChange = OnValueChanged
      end
      object USteps: TEdit
        Left = 200
        Top = 6
        Width = 25
        Height = 21
        Hint = 'U Steps'
        TabOrder = 3
        Text = '3'
        OnChange = OnValueChanged
      end
      object UStepsUpDown: TUpDown
        Left = 225
        Top = 6
        Width = 15
        Height = 21
        Associate = USteps
        Min = 1
        Max = 10
        Position = 3
        TabOrder = 4
        Thousands = False
      end
      object VSteps: TEdit
        Left = 248
        Top = 6
        Width = 25
        Height = 21
        Hint = 'V Steps'
        TabOrder = 5
        Text = '3'
        OnChange = OnValueChanged
      end
      object VStepsUpDown: TUpDown
        Left = 273
        Top = 6
        Width = 15
        Height = 21
        Associate = VSteps
        Min = 1
        Max = 10
        Position = 3
        TabOrder = 6
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 112
    object FileMenu: TMenuItem
      Caption = '&File'
      object CloseItem: TMenuItem
        Caption = '&Close'
        OnClick = CloseItemClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object ClearItem: TMenuItem
        Caption = '&Clear'
        ShortCut = 16474
        OnClick = ClearItemClick
      end
      object SelectAllItem: TMenuItem
        Caption = '&Select All'
        ShortCut = 16449
        OnClick = SelectAllItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object DeleteItem: TMenuItem
        Caption = '&Delete'
        ShortCut = 46
        OnClick = DeleteItemClick
      end
    end
    object PatchMenu: TMenuItem
      Caption = '&Patch'
      object SelectItem: TMenuItem
        Caption = '&Select'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        ShortCut = 113
        OnClick = SelectItemClick
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object MoveItem: TMenuItem
        Caption = '&Translate'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 114
        OnClick = MoveItemClick
      end
      object ScaleItem: TMenuItem
        Caption = 'S&cale'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 115
        OnClick = ScaleItemClick
      end
      object RotateItem: TMenuItem
        Caption = '&Rotate'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 116
        OnClick = RotateItemClick
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object CreateItem: TMenuItem
        Caption = '&Create'
        GroupIndex = 1
        OnClick = CreateItemClick
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
      end
    end
  end
end
