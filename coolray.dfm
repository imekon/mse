object CoolRayDialog: TCoolRayDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Render CoolRay scene'
  ClientHeight = 137
  ClientWidth = 284
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
    Caption = '&Scene File'
  end
  object SceneFileBrowse: TSpeedButton
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
    OnClick = SceneFileBrowseClick
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 52
    Height = 13
    Caption = '&Image Size'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 61
    Height = 13
    Caption = 'Output &Type'
  end
  object OKBtn: TButton
    Left = 8
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SceneFile: TEdit
    Left = 80
    Top = 8
    Width = 169
    Height = 21
    TabOrder = 2
  end
  object ImageSize: TComboBox
    Left = 80
    Top = 40
    Width = 73
    Height = 21
    TabOrder = 3
    Text = '160x120'
    Items.Strings = (
      '160x120'
      '320x240'
      '640x480'
      '1024x768'
      '1280x1024')
  end
  object OutputType: TComboBox
    Left = 80
    Top = 72
    Width = 153
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    Items.Strings = (
      'Windows bitmap (*.bmp)'
      'JPEG (*.jpg)'
      'GIF (*.gif)'
      'PNG (*.png)'
      'Targa (*.tga)'
      'TIFF (*.tif)')
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ray'
    Filter = 'Coolray scenes (*.ray)|*.ray'
    Left = 248
    Top = 72
  end
end
