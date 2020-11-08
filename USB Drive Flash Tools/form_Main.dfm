object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CAPTION AUTOMATICALLY SET'
  ClientHeight = 348
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 124
    Top = 60
    Width = 158
    Height = 13
    Caption = 'Backup a memory card/USB drive'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 124
    Top = 104
    Width = 162
    Height = 13
    Caption = 'Restore a memory card/USB drive'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 124
    Top = 148
    Width = 272
    Height = 13
    Caption = 'Securely erase the contents of a memory card/USB drive'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 124
    Top = 188
    Width = 241
    Height = 26
    Caption = 
      'Verify the capacity of a memory card to determine if it'#39's a fake' +
      ' or not'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 89
    Top = 12
    Width = 250
    Height = 13
    Caption = 'Please select which operation you wish to carry out:'
  end
  object Label6: TLabel
    Left = 124
    Top = 256
    Width = 196
    Height = 13
    Caption = 'Advanced copy (experienced users only)'
    WordWrap = True
  end
  object pbBackup: TButton
    Left = 28
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Backup...'
    TabOrder = 0
    OnClick = pbBackupClick
  end
  object pbRestore: TButton
    Left = 28
    Top = 100
    Width = 75
    Height = 25
    Caption = '&Restore...'
    TabOrder = 1
    OnClick = pbRestoreClick
  end
  object pbSecDelete: TButton
    Left = 28
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Erase...'
    TabOrder = 2
    OnClick = pbSecDeleteClick
  end
  object pbVerify: TButton
    Left = 28
    Top = 188
    Width = 75
    Height = 25
    Caption = '&Verify...'
    TabOrder = 3
    OnClick = pbVerifyClick
  end
  object pbAdvanced: TButton
    Left = 28
    Top = 252
    Width = 75
    Height = 25
    Caption = 'A&dvanced...'
    TabOrder = 5
    OnClick = pbAdvancedClick
  end
  object pnlPanel1: TPanel
    Left = 93
    Top = 228
    Width = 240
    Height = 5
    Caption = 'pnlPanel1'
    TabOrder = 4
  end
  object pbClose: TButton
    Left = 248
    Top = 308
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 6
    OnClick = pbCloseClick
  end
  object pbAbout: TButton
    Left = 336
    Top = 308
    Width = 75
    Height = 25
    Caption = '&About...'
    TabOrder = 7
    OnClick = pbAboutClick
  end
end
