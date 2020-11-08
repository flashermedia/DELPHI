object fme_Location: Tfme_Location
  Left = 0
  Top = 0
  Width = 329
  Height = 167
  TabOrder = 0
  TabStop = True
  object rbDrive: TRadioButton
    Left = 8
    Top = 12
    Width = 113
    Height = 17
    Caption = 'Drive'
    TabOrder = 0
    OnClick = rbLocationTypeClick
  end
  object dcbDrive: TDriveComboBox
    Left = 28
    Top = 32
    Width = 145
    Height = 19
    TabOrder = 1
    OnChange = dcbDriveChange
  end
  object rbDevice: TRadioButton
    Left = 8
    Top = 60
    Width = 113
    Height = 17
    Caption = 'Device'
    TabOrder = 2
    OnClick = rbLocationTypeClick
  end
  object edDevice: TEdit
    Left = 28
    Top = 80
    Width = 285
    Height = 21
    TabOrder = 3
    Text = '\\.\Z:'
    OnChange = edDeviceChange
  end
  object rbFile: TRadioButton
    Left = 8
    Top = 112
    Width = 113
    Height = 17
    Caption = 'File'
    TabOrder = 4
    OnClick = rbLocationTypeClick
  end
  object SDUFilenameEdit1: TSDUFilenameEdit
    Left = 28
    Top = 132
    Width = 285
    Height = 21
    Constraints.MaxHeight = 21
    Constraints.MinHeight = 21
    TabOrder = 5
    TabStop = False
    FilterIndex = 0
    OnChange = SDUFilenameEdit1Change
    DesignSize = (
      285
      21)
  end
  object SaveDialog1: TSaveDialog
    Left = 224
    Top = 112
  end
  object OpenDialog1: TOpenDialog
    Left = 256
    Top = 112
  end
end
