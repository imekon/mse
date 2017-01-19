object RenderDialog: TRenderDialog
  Left = 190
  Top = 493
  BorderStyle = bsDialog
  Caption = 'Render POVray'
  ClientHeight = 208
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
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 8
    Top = 176
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 88
    Top = 176
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 313
    Height = 169
    ActivePage = FileSheet
    Align = alTop
    TabOrder = 2
    object FileSheet: TTabSheet
      Caption = 'File'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 50
        Height = 13
        Caption = '&Scene File'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 50
        Height = 13
        Caption = '&Image size'
      end
      object Label3: TLabel
        Left = 8
        Top = 80
        Width = 59
        Height = 13
        Caption = 'Output &Type'
      end
      object SceneFile: TEdit
        Left = 80
        Top = 16
        Width = 129
        Height = 21
        TabOrder = 0
      end
      object SceneBrowseBtn: TButton
        Left = 216
        Top = 16
        Width = 75
        Height = 25
        Caption = '&Browse...'
        TabOrder = 1
        OnClick = SceneBrowseBtnClick
      end
      object ImageSize: TComboBox
        Left = 80
        Top = 48
        Width = 73
        Height = 21
        TabOrder = 2
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
        Top = 80
        Width = 153
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        Items.Strings = (
          'Compressed Targa (*.tga)'
          'PNG (*.png)'
          'PPM (*.ppm)'
          'System (*.bmp)'
          'Targa (*.tga)')
      end
      object WaitPOV: TCheckBox
        Left = 8
        Top = 112
        Width = 97
        Height = 17
        Caption = '&Wait for POVray'
        TabOrder = 4
      end
      object POVExit: TCheckBox
        Left = 144
        Top = 112
        Width = 105
        Height = 17
        Caption = '&Exit after running'
        TabOrder = 5
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'pov'
    Filter = 'POVray scene files (*.pov)|*.pov'
    Left = 268
    Top = 72
  end
end
