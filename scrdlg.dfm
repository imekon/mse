object ScriptedDialog: TScriptedDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Scripted'
  ClientHeight = 320
  ClientWidth = 317
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Script file:'
  end
  object ScriptBrowse: TSpeedButton
    Left = 256
    Top = 8
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
    OnClick = ScriptBrowseClick
  end
  object ScriptEdit: TSpeedButton
    Left = 280
    Top = 8
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
      00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
      F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
      0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
      FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
      FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
      0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
      00333377737FFFFF773333303300000003333337337777777333}
    NumGlyphs = 2
  end
  object OKBtn: TButton
    Left = 8
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ScriptFile: TEdit
    Left = 72
    Top = 8
    Width = 177
    Height = 21
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 40
    Width = 305
    Height = 241
    Caption = 'Properties'
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 208
      Width = 26
      Height = 13
      Caption = '&Value'
    end
    object PropertyList: TListView
      Left = 8
      Top = 16
      Width = 289
      Height = 185
      Columns = <
        item
          Caption = 'Property'
          Width = 140
        end
        item
          Caption = 'Value'
          Width = 140
        end>
      TabOrder = 0
      ViewStyle = vsReport
    end
    object Value: TComboBox
      Left = 48
      Top = 208
      Width = 249
      Height = 21
      TabOrder = 1
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'scr'
    Filter = 'Script files (*.scr)|*.scr'
    Left = 272
    Top = 288
  end
end
