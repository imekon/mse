object GroupEditor: TGroupEditor
  Left = 313
  Top = 219
  Caption = 'Group Editor'
  ClientHeight = 421
  ClientWidth = 680
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
  PixelsPerInch = 96
  TextHeight = 13
  object StatusPanel: TPanel
    Left = 0
    Top = 380
    Width = 680
    Height = 41
    Align = alBottom
    TabOrder = 0
    object CoordsPanel: TPanel
      Left = 8
      Top = 8
      Width = 185
      Height = 25
      BevelOuter = bvLowered
      Caption = 'x: 0 y: 0 z: 0'
      TabOrder = 0
    end
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 680
    Height = 56
    AutoSize = True
    Bands = <
      item
        Control = ToolPanel
        ImageIndex = -1
        Width = 674
      end
      item
        Control = EditPanel
        ImageIndex = -1
        Width = 674
      end>
    object ToolPanel: TPanel
      Left = 11
      Top = 0
      Width = 665
      Height = 25
      BevelOuter = bvNone
      TabOrder = 0
      object SelectBtn: TSpeedButton
        Left = 0
        Top = 0
        Width = 25
        Height = 25
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
      end
    end
    object EditPanel: TPanel
      Left = 11
      Top = 27
      Width = 665
      Height = 25
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 56
    Width = 680
    Height = 324
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
      OnPaint = PaintBoxPaint
    end
  end
  object MainMenu: TMainMenu
    Left = 88
    Top = 80
    object FileMenu: TMenuItem
      Caption = '&File'
      object CloseItem: TMenuItem
        Caption = '&Close'
        OnClick = CloseItemClick
      end
    end
  end
end
