object frmBackupRestore: TfrmBackupRestore
  Left = 346
  Top = 305
  BorderStyle = bsDialog
  Caption = 'FORM CAPTION AUTOMATICALLY SET'
  ClientHeight = 196
  ClientWidth = 307
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
  object pnlDrive: TPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 56
    Align = alTop
    Caption = 'pnlDrive'
    TabOrder = 0
    object lblDrive: TLabel
      Left = 9
      Top = 9
      Width = 189
      Height = 13
      Caption = 'CAPTION SET AUTOMATICALLY: DRIVE'
    end
    object cbDrive: TComboBox
      Left = 9
      Top = 29
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
    end
  end
  object pnlFile: TPanel
    Left = 0
    Top = 56
    Width = 307
    Height = 90
    Align = alTop
    Caption = 'pnlFile'
    TabOrder = 1
    object lblFile: TLabel
      Left = 9
      Top = 9
      Width = 208
      Height = 13
      Caption = 'CAPTION SET AUTOMATICALLY: FILENAME'
    end
    object lblCompression: TLabel
      Left = 10
      Top = 65
      Width = 65
      Height = 13
      Caption = '&Compression:'
      FocusControl = cbCompressionLevel
    end
    object SDUFilenameEdit1: TSDUFilenameEdit
      Left = 9
      Top = 29
      Width = 285
      Height = 21
      Constraints.MaxHeight = 21
      Constraints.MinHeight = 21
      TabOrder = 0
      TabStop = False
      FilterIndex = 0
      OnChange = SDUFilenameEdit1Change
      DesignSize = (
        285
        21)
    end
    object ckDecompress: TCheckBox
      Left = 225
      Top = 60
      Width = 97
      Height = 17
      Caption = '&Decompress'
      TabOrder = 2
      OnClick = ckDecompressClick
    end
    object cbCompressionLevel: TComboBox
      Left = 80
      Top = 60
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cbCompressionLevelChange
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 148
    Width = 307
    Height = 48
    Align = alBottom
    Caption = 'pnlButtons'
    TabOrder = 2
    object pbCancel: TButton
      Left = 160
      Top = 13
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = pbCancelClick
    end
    object pbGo: TButton
      Left = 72
      Top = 13
      Width = 75
      Height = 25
      Caption = 'AUTOSET CAPTION'
      Default = True
      TabOrder = 0
      OnClick = pbGoClick
    end
  end
end
