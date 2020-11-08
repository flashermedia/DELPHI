object Form1: TForm1
  Left = 192
  Top = 124
  Caption = 'Form1'
  ClientHeight = 276
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 40
    Top = 16
    Width = 65
    Height = 13
    Caption = 'edtFrequency'
  end
  object lbl2: TLabel
    Left = 40
    Top = 56
    Width = 55
    Height = 13
    Caption = 'edtDuration'
  end
  object Button1: TButton
    Left = 312
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object btnSave: TButton
    Left = 312
    Top = 80
    Width = 75
    Height = 25
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object edtFrequency: TEdit
    Left = 32
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '1200'
  end
  object edtDuration: TEdit
    Left = 32
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '1000'
  end
  object strckbr1: TsTrackBar
    Left = 24
    Top = 112
    Width = 150
    Height = 45
    TabOrder = 4
    SkinData.SkinSection = 'TRACKBAR'
    BarOffsetV = 0
    BarOffsetH = 0
  end
  object cbbSampleRate: TComboBox
    Left = 32
    Top = 168
    Width = 145
    Height = 21
    ItemIndex = 0
    TabOrder = 5
    Text = '44100 Hz'
    Items.Strings = (
      '44100 Hz')
  end
  object rgChannel: TRadioGroup
    Left = 208
    Top = 128
    Width = 185
    Height = 105
    Caption = 'rgChannel'
    TabOrder = 6
  end
  object rb1: TRadioButton
    Left = 232
    Top = 168
    Width = 113
    Height = 17
    Caption = 'rb1'
    TabOrder = 7
  end
  object rb2: TRadioButton
    Left = 224
    Top = 208
    Width = 113
    Height = 17
    Caption = 'rb2'
    TabOrder = 8
  end
  object btn1: TButton
    Left = 64
    Top = 208
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 9
    OnClick = btn1Click
  end
  object dlgSave1: TSaveDialog
    Left = 200
    Top = 8
  end
end
