object RGBFTFrame: TRGBFTFrame
  Left = 0
  Top = 0
  Width = 360
  Height = 166
  TabOrder = 0
  OnClick = FrameClick
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 19
    Height = 13
    Caption = '&Red'
  end
  object Bevel1: TBevel
    Left = 280
    Top = 8
    Width = 73
    Height = 73
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 29
    Height = 13
    Caption = '&Green'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 20
    Height = 13
    Caption = '&Blue'
  end
  object Label4: TLabel
    Left = 8
    Top = 80
    Width = 24
    Height = 13
    Caption = '&Filter'
  end
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 41
    Height = 13
    Caption = '&Transmit'
  end
  object Label6: TLabel
    Left = 8
    Top = 136
    Width = 31
    Height = 13
    Caption = '&Colour'
  end
  object Shape: TShape
    Left = 288
    Top = 16
    Width = 57
    Height = 57
    Pen.Style = psClear
  end
  object Red: TEdit
    Left = 56
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Green: TEdit
    Left = 56
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object Blue: TEdit
    Left = 56
    Top = 56
    Width = 57
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object Filter: TEdit
    Left = 56
    Top = 80
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object Transmit: TEdit
    Left = 56
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object ColourList: TComboBox
    Left = 56
    Top = 136
    Width = 217
    Height = 21
    Style = csDropDownList
    TabOrder = 5
  end
end
