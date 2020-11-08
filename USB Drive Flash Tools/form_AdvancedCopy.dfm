object frm_AdvancedCopy: Tfrm_AdvancedCopy
  Left = 332
  Top = 259
  ActiveControl = fmeLocationSrc
  BorderStyle = bsDialog
  Caption = 'Advanced Copy'
  ClientHeight = 342
  ClientWidth = 371
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
  object lblProgress: TLabel
    Left = 186
    Top = 284
    Width = 52
    Height = 13
    Caption = 'lblProgress'
  end
  object Label4: TLabel
    Left = 134
    Top = 284
    Width = 46
    Height = 13
    Caption = 'Progress:'
  end
  object pcMain: TPageControl
    Left = 8
    Top = 8
    Width = 353
    Height = 225
    ActivePage = tsSource
    TabOrder = 0
    object tsSource: TTabSheet
      Caption = 'Source'
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 245
        Height = 13
        Caption = 'Please specify where you which to copy data from:'
      end
      inline fmeLocationSrc: Tfme_Location
        Left = 8
        Top = 24
        Width = 329
        Height = 167
        TabOrder = 0
        TabStop = True
      end
    end
    object tsDestination: TTabSheet
      Caption = 'Destination'
      ImageIndex = 1
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 233
        Height = 13
        Caption = 'Please specify where you which to copy data to:'
      end
      inline fmeLocationDest: Tfme_Location
        Left = 8
        Top = 24
        Width = 329
        Height = 167
        TabOrder = 0
        TabStop = True
      end
    end
    object tsOptions: TTabSheet
      Caption = 'Options'
      ImageIndex = 2
      object Label1: TLabel
        Left = 310
        Top = 80
        Width = 27
        Height = 13
        Caption = 'bytes'
      end
      object Label7: TLabel
        Left = 16
        Top = 80
        Width = 160
        Height = 13
        Caption = 'Start copying source from &offset:'
        FocusControl = se64StartOffset
      end
      object lblLimitBytes: TLabel
        Left = 164
        Top = 40
        Width = 27
        Height = 13
        Caption = 'bytes'
      end
      object Label3: TLabel
        Left = 16
        Top = 112
        Width = 55
        Height = 13
        Caption = '&Buffer size:'
        FocusControl = seBlockSize
      end
      object Label5: TLabel
        Left = 310
        Top = 112
        Width = 27
        Height = 13
        Caption = 'bytes'
      end
      object se64StartOffset: TSpinEdit64
        Left = 182
        Top = 76
        Width = 121
        Height = 22
        Increment = 1
        TabOrder = 2
      end
      object ckLimitCopy: TCheckBox
        Left = 16
        Top = 12
        Width = 121
        Height = 17
        Caption = '&Limit bytes to copy'
        TabOrder = 0
        OnClick = ckLimitCopyClick
      end
      object se64MaxBytesToCopy: TSpinEdit64
        Left = 36
        Top = 36
        Width = 121
        Height = 22
        Increment = 1
        TabOrder = 1
      end
      object seBlockSize: TSpinEdit64
        Left = 182
        Top = 108
        Width = 121
        Height = 22
        Increment = 1
        TabOrder = 3
        Value = 16384
      end
    end
    object tsCompression: TTabSheet
      Caption = 'Compression'
      ImageIndex = 3
      object lblCompression: TLabel
        Left = 50
        Top = 70
        Width = 65
        Height = 13
        Caption = 'Com&pression:'
        FocusControl = cbCompressionLevel
      end
      object rbNoCompression: TRadioButton
        Left = 30
        Top = 25
        Width = 291
        Height = 17
        Caption = '&No compression'
        TabOrder = 0
        OnClick = rbSelectCompression
      end
      object rbDecompress: TRadioButton
        Left = 30
        Top = 95
        Width = 291
        Height = 17
        Caption = '&Decompress source before writing to destination'
        TabOrder = 3
        OnClick = rbSelectCompression
      end
      object rbCompress: TRadioButton
        Left = 30
        Top = 45
        Width = 291
        Height = 17
        Caption = 'Co&mpress source before writing to destination'
        TabOrder = 1
        OnClick = rbSelectCompression
      end
      object cbCompressionLevel: TComboBox
        Left = 120
        Top = 65
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 2
      end
    end
  end
  object pbCopy: TButton
    Left = 104
    Top = 248
    Width = 75
    Height = 25
    Caption = '&Copy'
    TabOrder = 1
    OnClick = pbCopyClick
  end
  object pbCancel: TButton
    Left = 192
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = pbCancelClick
  end
  object pbClose: TButton
    Left = 285
    Top = 308
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = pbCloseClick
  end
end
