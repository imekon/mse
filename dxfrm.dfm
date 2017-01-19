object DirectXForm: TDirectXForm
  Left = 197
  Top = 110
  Width = 696
  Height = 480
  Caption = 'DirectX Preview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    000001000200101010000000000028010000260000002020100000000000E802
    00004E0100002800000010000000200000000100040000000000800000000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000006440000000004444000000000044
    4404044440000004830443BB40400048BB304BBB8440444BBB304BBBB000663B
    BBB3BBBB304464448BBBBB3000446004443BB044044444400BBB3B344040040B
    BBB7BBBB3440048BBBB48BBBB804044BBB744BBBB4000004BB4008B344000004
    0840448404000000004464400000FE0F0000E00F0000C0030000C00100008000
    0000000000000000000000000000000000000000000080000000800000008000
    0000E0010000E8030000FC1F0000280000002000000040000000010004000000
    0000000200000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000044
    0400000000000000000000000444040040400000000000000000040444044000
    4000000000000000044044444044404444440000000000004444444400440044
    44444400000000004004448330044444B344444000000000404448B3B0044443
    BBBB44400400000044448BBB3300444BBBBB8440040000004448BBBB3300440B
    BBBBB84404000044448BBBBB3300443BBBBBBB304040044444BBBBBBB33044BB
    BBBBBBB04000000043BBBBBBB33043BBBBBBBB3B0044004443BBBBBBBB330BBB
    BBBB3330044400044443BBBBBBBB0B3BBB33300044440044444448BBBBBBBBBB
    333000004444044004044448BBBBBB3B30000004444400400004444443BBBBB0
    4444400444440040444444440BBBBBB844444400444004444440000BBB3BB3BB
    B34444404440444440000BBBB73BB3BBBBB3444004400444400BBBBBBBB74BBB
    BBBBB344044004444BBBBBBBBBB847BBBBBBBBBB0044004448BBBBBBBB7448BB
    BBBBBBB80044004444BBBBBBBB8444BBBBBBBB7400400044448BBBBBB744448B
    BBBBBB84404000444443BBBBB744440BBBBB37440040000004440BBB74400008
    BB33844400000000040444BB74404000B3884400440000000444444884404444
    8844404440000000044004444400444444004440000000000000040044044444
    44440000000000000000000044466640066400000000FFFFC3FFFFF881FFFFA0
    00FFF90000FFF000003FF000001FF0000003F0000003F0000003C00000010000
    000100000000C0000000E0000000C000000080000000C0000000C00000018000
    0001000000018000000180000000C0000000C0000001C0000001C0000001F800
    0003F8000003F8000007F980001FFFB000FFFFF000FF}
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 415
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu: TMainMenu
    Left = 40
    Top = 24
    object FileMenu: TMenuItem
      Caption = '&File'
      object CloseItem: TMenuItem
        Action = CloseAction
      end
    end
    object RenderMenu: TMenuItem
      Caption = '&Render'
      object FlatItem: TMenuItem
        Action = FlatAction
      end
      object GouraudItem: TMenuItem
        Action = GouraudAction
      end
      object PhongItem: TMenuItem
        Action = PhongAction
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object LightingItem: TMenuItem
        Action = LightingAction
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object PointItem: TMenuItem
        Action = PointAction
      end
      object WireframeItem: TMenuItem
        Action = WireframeAction
      end
      object SolidItem: TMenuItem
        Action = SolidAction
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object DitheringItem: TMenuItem
        Action = DitheringAction
      end
      object AntialiasingItem: TMenuItem
        Action = AntiAliasingAction
      end
    end
    object ViewMenu: TMenuItem
      Caption = '&View'
      object Statistics1: TMenuItem
        Action = StatisticsAction
      end
    end
  end
  object ActionList: TActionList
    Left = 376
    Top = 56
    object CloseAction: TAction
      Category = 'File'
      Caption = '&Close'
      OnExecute = CloseItemClick
    end
    object FlatAction: TAction
      Category = 'Render'
      Caption = '&Flat'
      OnExecute = FlatItemClick
      OnUpdate = FlatActionUpdate
    end
    object GouraudAction: TAction
      Category = 'Render'
      Caption = '&Gouraud'
      OnExecute = GouraudItemClick
      OnUpdate = GouraudActionUpdate
    end
    object LightingAction: TAction
      Category = 'Render'
      Caption = '&Lighting'
      OnExecute = LightingItemClick
      OnUpdate = LightingActionUpdate
    end
    object PointAction: TAction
      Category = 'Render'
      Caption = '&Point'
      OnExecute = PointItemClick
      OnUpdate = PointActionUpdate
    end
    object WireframeAction: TAction
      Category = 'Render'
      Caption = '&Wireframe'
      OnExecute = WireframeItemClick
      OnUpdate = WireframeActionUpdate
    end
    object SolidAction: TAction
      Category = 'Render'
      Caption = '&Solid'
      OnExecute = SolidItemClick
      OnUpdate = SolidActionUpdate
    end
    object DitheringAction: TAction
      Category = 'Render'
      Caption = '&Dithering'
      OnExecute = DitheringActionExecute
      OnUpdate = DitheringActionUpdate
    end
    object AntiAliasingAction: TAction
      Category = 'Render'
      Caption = '&Anti-Aliasing'
      OnExecute = AntiAliasingActionExecute
      OnUpdate = AntiAliasingActionUpdate
    end
    object PhongAction: TAction
      Category = 'Render'
      Caption = '&Phong'
      OnExecute = PhongActionExecute
      OnUpdate = PhongActionUpdate
    end
    object StatisticsAction: TAction
      Category = 'View'
      Caption = '&Statistics'
      OnExecute = StatisticsActionExecute
      OnUpdate = StatisticsActionUpdate
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 184
    Top = 32
  end
  object Tick: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TickTimer
    Left = 88
    Top = 136
  end
end
