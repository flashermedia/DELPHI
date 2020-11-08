object frmVerifyCapacity: TfrmVerifyCapacity
  Left = 0
  Top = 0
  Caption = 'Verify Capacity'
  ClientHeight = 453
  ClientWidth = 372
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    372
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 22
    Top = 100
    Width = 179
    Height = 13
    Caption = 'Please select the &drive to be verified:'
    FocusControl = cbDrive
  end
  object Label1: TLabel
    Left = 64
    Top = 144
    Width = 251
    Height = 52
    Caption = 
      'Unchecking this checkbox will give a more accurate count of usab' +
      'le bytes available on the drive (to the nearest 512 bytes as opp' +
      'osed to 1MB), but takes longer. Most users should leave this opt' +
      'ion checked.'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 256
    Width = 43
    Height = 13
    Caption = '&Analysis:'
    FocusControl = reReport
  end
  object Label4: TLabel
    Left = 20
    Top = 8
    Width = 332
    Height = 26
    Caption = 
      'This tool will allow you to verify the *actual* capacity of a dr' +
      'ive, and will detect "fake" flash memory cards/USB drives'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 26
    Top = 44
    Width = 321
    Height = 39
    Caption = 
      'WARNING: This tool does a thorough job, and as a result will des' +
      'troy any data you have on the selected drive, requiring you to r' +
      'eformat it afterwards.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object pbClose: TButton
    Left = 282
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = pbCloseClick
  end
  object pbVerify: TButton
    Left = 149
    Top = 216
    Width = 75
    Height = 25
    Caption = '&Verify'
    Default = True
    TabOrder = 2
    OnClick = pbVerifyClick
  end
  object cbDrive: TComboBox
    Left = 206
    Top = 96
    Width = 145
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
  end
  object reReport: TRichEdit
    Left = 12
    Top = 276
    Width = 346
    Height = 132
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Lines.Strings = (
      'reReport')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object ckQuickCheck: TCheckBox
    Left = 44
    Top = 124
    Width = 121
    Height = 17
    Caption = 'Perform &quick check'
    TabOrder = 1
  end
  object pbSave: TButton
    Left = 148
    Top = 419
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Save...'
    TabOrder = 4
    OnClick = pbSaveClick
  end
  object SaveDialog1: TSaveDialog
    Left = 256
    Top = 228
  end
end
