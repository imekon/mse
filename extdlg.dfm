object CreateExtrusionDialog: TCreateExtrusionDialog
  Left = 253
  Top = 156
  Caption = 'Create Extrusion'
  ClientHeight = 414
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poDefault
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 479
    Height = 33
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object TriangleBtn: TSpeedButton
      Left = 256
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Triangle'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF000000000000FFFF0FFFFFFFFFF0FFFFF0FFFFFFFF
        0FFFFFF0FFFFFFFF0FFFFFFF0FFFFFF0FFFFFFFF0FFFFFF0FFFFFFFFF0FFFF0F
        FFFFFFFFF0FFFF0FFFFFFFFFFF0FF0FFFFFFFFFFFF0FF0FFFFFFFFFFFFF00FFF
        FFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = TriangleBtnClick
    end
    object SquareBtn: TSpeedButton
      Left = 280
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Square'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF000000000000FFFF0FFFFFFFFFF0FFFF0FFFFFFFFF
        F0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFF
        F0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0FFFFFFFFF
        F0FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = SquareBtnClick
    end
    object SelectBtn: TSpeedButton
      Left = 8
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Select'
      GroupIndex = 1
      Down = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777700777777777777770077777777777770077777777770777007
        7777777770070077777777777000007777777777700000000777777770000000
        7777777770000007777777777000007777777777700007777777777770007777
        7777777770077777777777777077777777777777777777777777}
      OnClick = SelectBtnClick
    end
    object TranslateBtn: TSpeedButton
      Left = 112
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Translate'
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777707777777777777700077777777777700000777777777777000777
        7777770777000777077770000000000000770000000000000007700000000000
        0077770777000777077777777700077777777777700000777777777777000777
        7777777777707777777777777777777777777777777777777777}
      OnClick = TranslateBtnClick
    end
    object ScaleBtn: TSpeedButton
      Left = 136
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Scale'
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000000000777000000008888077708888880888
        8077708888880888807770888888088880777088888808888077708888880888
        8077708888880888807770888888088880777000000008888077777708888888
        8077700708888888807777070000000000777777777777777777}
    end
    object RotateBtn: TSpeedButton
      Left = 160
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Rotate'
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777777000000777777777088888807777777088000088
        0777770880000008807770888808880088077088888888800807708888888880
        0807708888888880080770888888880088077708888800088077777088880088
        0777777708888880777777777000000777777777777777777777}
    end
    object NewPtBtn: TSpeedButton
      Left = 192
      Top = 4
      Width = 25
      Height = 25
      Hint = 'New point'
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777770777777
        7777777777077777777777777707777777777777F7707F7777F777777F707F77
        7F77777777F70F77F777777777770777777777777777999777777777FFF79997
        FFF777777777999777777777777077777777777777077F77F777777770777F77
        7F77777707777F7777F777707777777777777707777777777777}
      OnClick = NewPtBtnClick
    end
    object DeletePtBtn: TSpeedButton
      Left = 224
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Delete point'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777770777777
        7777777777077777777777777707777777777777777077777777777779907777
        9977777779990779997777777799979997777777777999997777777777779997
        7777777777799999777777777799979997777777799977799977777779977777
        9977777707777777777777707777777777777707777777777777}
      OnClick = DeletePtBtnClick
    end
    object GridBtn: TSpeedButton
      Left = 344
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Grid'
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
      Left = 376
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Zoom'
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
    object NSidedBtn: TSpeedButton
      Left = 312
      Top = 4
      Width = 25
      Height = 25
      Hint = 'n Sided'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0FFFFFF0FFFFFFF0FFFFFFFF
        0FFFFFF0FF0FFF0F0FFFFF0FFF0FFF0FF0FFFF0FFF0FFF0FF0FFFF0FFF00FF0F
        F0FFFFF0FF0F00FF0FFFFFFF0FFFFFF0FFFFFFFFF0FFFF0FFFFFFFFFFF0FF0FF
        FFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = NSidedItemClick
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
  object ScrollBox: TScrollBox
    Left = 0
    Top = 66
    Width = 479
    Height = 310
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clBlack
    ParentColor = False
    TabOrder = 1
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 2000
      Height = 2000
      OnDragOver = PaintBoxDragOver
      OnEndDrag = PaintBoxEndDrag
      OnMouseDown = PaintBoxMouseDown
      OnPaint = PaintBoxPaint
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 376
    Width = 479
    Height = 38
    Align = alBottom
    TabOrder = 2
    object OKBtn: TButton
      Left = 8
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 88
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object EditBar: TPanel
    Left = 0
    Top = 33
    Width = 479
    Height = 33
    Align = alTop
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 13
      Caption = '&Steps'
    end
    object Label2: TLabel
      Left = 120
      Top = 8
      Width = 29
      Height = 13
      Caption = '&Depth'
    end
    object Steps: TEdit
      Left = 48
      Top = 6
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '2'
    end
    object StepsUpDown: TUpDown
      Left = 89
      Top = 6
      Width = 15
      Height = 21
      Associate = Steps
      Min = 2
      Position = 2
      TabOrder = 1
    end
    object Depth: TEdit
      Left = 160
      Top = 6
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '1'
    end
  end
  object MainMenu: TMainMenu
    Left = 10
    Top = 75
    object FileMenu: TMenuItem
      Caption = '&File'
      object LoadItem: TMenuItem
        Caption = '&Load...'
        OnClick = LoadItemClick
      end
      object SaveItem: TMenuItem
        Caption = '&Save...'
        OnClick = SaveItemClick
      end
      object CloseItem: TMenuItem
        Caption = '&Close'
        OnClick = CloseItemClick
      end
    end
    object EditMenu: TMenuItem
      Caption = '&Edit'
      object SelectAllItem: TMenuItem
        Caption = '&Select All'
        ShortCut = 16449
        OnClick = SelectAllItemClick
      end
      object ClearAllItem: TMenuItem
        Caption = '&Clear All'
        ShortCut = 16474
        OnClick = ClearAllItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object DeleteItem: TMenuItem
        Caption = '&Delete'
        ShortCut = 46
        OnClick = DeletePtBtnClick
      end
    end
    object ShapeMenu: TMenuItem
      Caption = '&Shape'
      object SelectItem: TMenuItem
        Caption = '&Select'
        OnClick = SelectBtnClick
      end
      object TranslateItem: TMenuItem
        Caption = '&Translate'
        OnClick = TranslateBtnClick
      end
      object ScaleItem: TMenuItem
        Caption = 'S&cale'
      end
      object RotateItem: TMenuItem
        Caption = '&Rotate'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object CreatePointItem: TMenuItem
        Caption = 'Create &Point'
        ShortCut = 45
        OnClick = NewPtBtnClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object TriangleItem: TMenuItem
        Caption = '&Triangle'
        OnClick = TriangleBtnClick
      end
      object SquareItem: TMenuItem
        Caption = 'S&quare'
        OnClick = SquareBtnClick
      end
      object NSidedItem: TMenuItem
        Caption = '&n Sided'
        OnClick = NSidedItemClick
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      object CenterViewItem: TMenuItem
        Caption = '&Center View'
        OnClick = CenterViewItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object GridItem: TMenuItem
        Caption = '&Grid'
        OnClick = GridItemClick
      end
      object ZoomItem: TMenuItem
        Caption = '&Zoom'
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
  object OpenDialog: TOpenDialog
    DefaultExt = 'msh'
    Filter = 'Model Shapes (*.msh)|*.msh|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoReadOnlyReturn]
    Left = 42
    Top = 75
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'msh'
    Filter = 'Model Shapes (*.msh)|*.msh|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoReadOnlyReturn]
    Left = 74
    Top = 75
  end
end
