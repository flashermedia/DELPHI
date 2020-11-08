object frmSecureErase: TfrmSecureErase
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Secure Erase'
  ClientHeight = 330
  ClientWidth = 408
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
    Left = 84
    Top = 216
    Width = 91
    Height = 13
    Caption = 'Overwrite method:'
  end
  object Label2: TLabel
    Left = 20
    Top = 16
    Width = 219
    Height = 13
    Caption = 'Please select the drive to be securely erased:'
  end
  object Label3: TLabel
    Left = 78
    Top = 72
    Width = 262
    Height = 26
    Caption = 
      'This will destroy all data currently stored on the drive, requir' +
      'ing it to be reformatted afterwards'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 78
    Top = 136
    Width = 271
    Height = 13
    Caption = 'This option will only overwrite unused space on the drive'
  end
  object Label5: TLabel
    Left = 84
    Top = 243
    Width = 37
    Height = 13
    Caption = 'Passes:'
  end
  object rbEntireDrive: TRadioButton
    Left = 58
    Top = 52
    Width = 181
    Height = 17
    Caption = 'Destroy entire drive'#39's contents'
    TabOrder = 1
    OnClick = SettingChanged
  end
  object rbFreeSpace: TRadioButton
    Left = 58
    Top = 116
    Width = 145
    Height = 17
    Caption = 'Overwrite free space'
    TabOrder = 2
    OnClick = SettingChanged
  end
  object cbOverwriteMethod: TComboBox
    Left = 180
    Top = 212
    Width = 144
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = SettingChanged
  end
  object pbOverwrite: TButton
    Left = 120
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Overwrite'
    Default = True
    TabOrder = 7
    OnClick = pbOverwriteClick
  end
  object pbClose: TButton
    Left = 212
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 8
    OnClick = pbCloseClick
  end
  object cbDrive: TComboBox
    Left = 248
    Top = 12
    Width = 145
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
  end
  object ckUnusedStorage: TCheckBox
    Left = 78
    Top = 152
    Width = 97
    Height = 17
    Caption = 'Unused storage'
    TabOrder = 3
  end
  object ckFileSlack: TCheckBox
    Left = 78
    Top = 172
    Width = 97
    Height = 17
    Caption = 'File slack'
    TabOrder = 4
  end
  object sePasses: TSpinEdit64
    Left = 180
    Top = 240
    Width = 121
    Height = 22
    Increment = 1
    TabOrder = 6
  end
  object Shredder1: TShredder
    IntSegmentLength = 1048576
    Left = 16
    Top = 280
  end
end
