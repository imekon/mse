object JuliaDialog: TJuliaDialog
  Left = 195
  Top = 259
  BorderStyle = bsDialog
  Caption = '4D Julia Fractal'
  ClientHeight = 265
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 72
    Height = 13
    Caption = '&Julia Parameter'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 48
    Height = 13
    Caption = 'Julia &Type'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 65
    Height = 13
    Caption = 'Julia &Function'
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 61
    Height = 13
    Caption = 'Max &Iteration'
  end
  object Label5: TLabel
    Left = 8
    Top = 136
    Width = 43
    Height = 13
    Caption = '&Precision'
  end
  object Label6: TLabel
    Left = 8
    Top = 168
    Width = 23
    Height = 13
    Caption = '&Slice'
  end
  object Label7: TLabel
    Left = 8
    Top = 200
    Width = 68
    Height = 13
    Caption = 'Slice &Distance'
  end
  object OKBtn: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 15
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 96
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 16
  end
  object XValue: TEdit
    Left = 96
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object YValue: TEdit
    Left = 160
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object ZValue: TEdit
    Left = 224
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object DValue: TEdit
    Left = 288
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object JuliaType: TComboBox
    Left = 96
    Top = 40
    Width = 97
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    Items.Strings = (
      'Quaternion'
      'Hypercomplex')
  end
  object JuliaFunction: TComboBox
    Left = 96
    Top = 72
    Width = 97
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    OnChange = JuliaFunctionChange
    Items.Strings = (
      'Sqr'
      'Cube'
      'Exp'
      'Reciprocal'
      'Sin'
      'Asin'
      'Sinh'
      'Asinh'
      'Cos'
      'Acos'
      'Cosh'
      'Acosh'
      'Tan'
      'Atan'
      'Tanh'
      'Atanh'
      'Log'
      'Pwr(X,Y)')
  end
  object PwrX: TEdit
    Left = 224
    Top = 72
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 6
    Text = '0'
  end
  object PwrY: TEdit
    Left = 288
    Top = 72
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 7
    Text = '0'
  end
  object MaxIteration: TEdit
    Left = 96
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object Precision: TEdit
    Left = 96
    Top = 136
    Width = 57
    Height = 21
    TabOrder = 9
    Text = '0'
  end
  object SliceX: TEdit
    Left = 96
    Top = 168
    Width = 57
    Height = 21
    TabOrder = 10
    Text = '0'
  end
  object SliceY: TEdit
    Left = 160
    Top = 168
    Width = 57
    Height = 21
    TabOrder = 11
    Text = '0'
  end
  object SliceZ: TEdit
    Left = 224
    Top = 168
    Width = 57
    Height = 21
    TabOrder = 12
    Text = '0'
  end
  object SliceD: TEdit
    Left = 288
    Top = 168
    Width = 57
    Height = 21
    TabOrder = 13
    Text = '0'
  end
  object SliceDistance: TEdit
    Left = 96
    Top = 200
    Width = 57
    Height = 21
    TabOrder = 14
    Text = '0'
  end
end
