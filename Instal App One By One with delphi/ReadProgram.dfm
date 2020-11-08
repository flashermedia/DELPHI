object ReadProgramX: TReadProgramX
  Left = 658
  Top = 197
  Width = 340
  Height = 219
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'ReadProgramX'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 144
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 16
    Top = 168
    Width = 3
    Height = 13
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 161
    Height = 137
    Caption = 'Panel1'
    TabOrder = 0
    object Button2: TButton
      Left = 16
      Top = 15
      Width = 129
      Height = 42
      Caption = 'Read'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 80
      Width = 129
      Height = 41
      Caption = 'Write'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 160
    Top = 0
    Width = 161
    Height = 137
    Caption = 'Panel2'
    TabOrder = 1
    object Button1: TButton
      Left = 18
      Top = 13
      Width = 125
      Height = 107
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
