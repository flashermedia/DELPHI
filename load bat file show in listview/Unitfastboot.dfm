object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 343
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  StyleElements = [seFont, seClient]
  DesignSize = (
    654
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 548
    Top = 171
    Width = 90
    Height = 78
    Caption = 'open'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object lv4: TListView
    Left = 8
    Top = 35
    Width = 522
    Height = 300
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = '     Partition'
        MaxWidth = 125
        MinWidth = 125
      end
      item
        AutoSize = True
        Caption = 'File Image'
        MaxWidth = 125
        MinWidth = 125
      end
      item
        Caption = 'Byte'
        MaxWidth = 90
        MinWidth = 90
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'Size            '
        MaxWidth = 90
        MinWidth = 90
        Width = 90
      end
      item
        AutoSize = True
        Caption = 'Command'
        MaxWidth = 100
        MinWidth = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnClick = lv4Click
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 105
    Height = 21
    ItemIndex = 1
    TabOrder = 2
    Text = 'ASUS'
    Items.Strings = (
      'XIOMI'
      'ASUS'
      'ALL')
  end
  object ComboBox2: TComboBox
    Left = 895
    Top = 407
    Width = 99
    Height = 21
    TabOrder = 3
    Text = 'ComboBox1'
  end
  object Button2: TButton
    Left = 548
    Top = 255
    Width = 90
    Height = 74
    Caption = 'back restore'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 1024
    Top = 424
    Width = 161
    Height = 21
    TabOrder = 5
  end
  object chk_FlashImage: TsCheckBox
    Left = 548
    Top = 144
    Width = 78
    Height = 20
    Caption = 'Flash Image'
    TabOrder = 6
    OnClick = chk_FlashImageClick
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object chkEraseImage: TsCheckBox
    Left = 548
    Top = 123
    Width = 80
    Height = 20
    Caption = 'Erase Image'
    TabOrder = 7
    OnClick = chkEraseImageClick
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object chk_partitioning: TsCheckBox
    Left = 548
    Top = 101
    Width = 74
    Height = 20
    Caption = 'partitioning'
    TabOrder = 8
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object chk_backupasus: TsCheckBox
    Left = 548
    Top = 80
    Width = 83
    Height = 20
    Caption = 'Bacup Config'
    TabOrder = 9
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object rb_DebrickSocIntel: TRadioButton
    Left = 536
    Top = 35
    Width = 113
    Height = 17
    Caption = 'Debrick Soc Intel'
    TabOrder = 10
  end
  object rb_FlashFastboot: TRadioButton
    Left = 536
    Top = 58
    Width = 113
    Height = 17
    Caption = 'Fastboot Flashing'
    TabOrder = 11
  end
  object OpenDialog1: TOpenDialog
    Filter = #39'BAT ( bat )|*.bat|All Types ( *.*)|*.*'#39';'
    Left = 496
    Top = 5
  end
  object blurrr: TscStyledForm
    DWMClientShadow = False
    DWMClientShadowHitTest = False
    DropDownForm = False
    DropDownAnimation = False
    DropDownBorderColor = clBtnShadow
    StylesMenuSorted = False
    ShowStylesMenu = False
    StylesMenuCaption = 'Styles'
    ClientWidth = 0
    ClientHeight = 0
    ShowHints = True
    Buttons = <
      item
        AllowAllUp = False
        Down = False
        Enabled = True
        GroupIndex = 0
        Visible = True
        Caption = 'SSSSSSSSSSSSSSSSS'
        SplitButton = False
        Style = scncToolButton
        Width = 0
        Height = 0
        MarginLeft = 0
        MarginTop = 2
        MarginRight = 0
        MarginBottom = 2
        Position = scbpLeft
        Spacing = 5
        Margin = -1
        ContentMargin = 0
        CustomDropDown = False
      end
      item
        AllowAllUp = False
        Down = False
        Enabled = True
        GroupIndex = 0
        Visible = True
        Caption = 'DDDDDDDDDDDDDDD'
        SplitButton = False
        Style = scncToolButton
        Width = 0
        Height = 0
        MarginLeft = 0
        MarginTop = 2
        MarginRight = 0
        MarginBottom = 2
        Position = scbpLeft
        Spacing = 5
        Margin = -1
        ContentMargin = 0
        CustomDropDown = False
      end>
    ButtonFont.Charset = DEFAULT_CHARSET
    ButtonFont.Color = clWindowText
    ButtonFont.Height = -11
    ButtonFont.Name = 'Tahoma'
    ButtonFont.Style = []
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = [fsBold]
    CaptionAlignment = taLeftJustify
    InActiveClientColor = clWindow
    InActiveClientColorAlpha = 100
    InActiveClientBlurAmount = 5
    Tabs = <>
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clWindowText
    TabFont.Height = -11
    TabFont.Name = 'Tahoma'
    TabFont.Style = []
    ShowButtons = True
    ShowTabs = True
    TabIndex = 0
    TabsPosition = sctpLeft
    ShowInactiveTab = True
    CaptionWallpaperIndex = -1
    CaptionWallpaperInActiveIndex = -1
    CaptionWallpaperLeftMargin = 1
    CaptionWallpaperTopMargin = 1
    CaptionWallpaperRightMargin = 1
    CaptionWallpaperBottomMargin = 1
    Left = 120
    Top = 160
  end
end
