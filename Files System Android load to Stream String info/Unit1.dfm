object Form1: TForm1
  Left = 331
  Top = 145
  Width = 562
  Height = 501
  Caption = 'PANCI MABUR'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    546
    463)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 417
    Width = 111
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '.....................................'
  end
  object lbl2: TLabel
    Left = 6
    Top = 8
    Width = 272
    Height = 35
    Caption = 'ROM Android info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -33
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 410
    Top = 399
    Width = 125
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'DANKDANK BOCHOR'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 379
    Top = 8
    Width = 149
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '.....................................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 379
    Top = 23
    Width = 149
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '.....................................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl6: TLabel
    Left = 380
    Top = 37
    Width = 149
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '.....................................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btn1: TBitBtn
    Left = 463
    Top = 425
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'open files'
    TabOrder = 0
    OnClick = btn1Click
  end
  object chk1: TCheckBox
    Left = 8
    Top = 390
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = '.................................'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object edt1: TJvRichEdit
    Left = 8
    Top = 51
    Width = 528
    Height = 334
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object dlgOpen1: TOpenDialog
    Filter = 'Image System Files|*.Img; *.Bin|All Files|*.*'
    Left = 512
    Top = 8
  end
end
