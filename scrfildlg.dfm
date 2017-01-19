object ScriptFileDialog: TScriptFileDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Script File'
  ClientHeight = 377
  ClientWidth = 346
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    Caption = '&Properties'
  end
  object Label2: TLabel
    Left = 8
    Top = 184
    Width = 29
    Height = 13
    Caption = '&Scene'
  end
  object OKBtn: TButton
    Left = 264
    Top = 312
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 264
    Top = 344
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PropertyList: TListView
    Left = 8
    Top = 24
    Width = 250
    Height = 150
    Columns = <
      item
        Caption = 'Name'
        Width = 140
      end
      item
        Caption = 'Min'
      end
      item
        Caption = 'Max'
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
  object SceneMemo: TMemo
    Left = 8
    Top = 200
    Width = 249
    Height = 169
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object AddBtn: TButton
    Left = 264
    Top = 24
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 4
  end
  object RemoveBtn: TButton
    Left = 264
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Remove'
    TabOrder = 5
  end
end
