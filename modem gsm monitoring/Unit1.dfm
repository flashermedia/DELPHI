object Form1: TForm1
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'USB Modem Suite (UMS Minimalist) Tutorial'
  ClientHeight = 287
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 185
    Height = 257
    AutoSize = False
    Caption = 
      'Tutorial dan Source Code membuat aplikasi PC Suite untuk modem U' +
      'SB seperti MDMA. Didesain dan ditest hanya untuk modem HUAWEI. '#13 +
      #10#13#10'Fitur2 sederhana berdasarkan data AT Command :'#13#10'1. QOS (Quali' +
      'ty of Service)'#13#10'2. Data Transfered'#13#10'3. Nama Operator'#13#10'4. Sinyal ' +
      '(RSSI)'#13#10'5. Type Jaringan (RAT)'#13#10'6. APN'#13#10'7. Kodok Loncat'#13#10#13#10'Untuk' +
      ' pengembangan lainnya, mangga diuwik2 olangan...:D'#13#10#13#10'By Davidlo' +
      'rem'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 208
    Top = 32
    Width = 23
    Height = 13
    Caption = 'RSSI'
  end
  object Label3: TLabel
    Left = 208
    Top = 96
    Width = 20
    Height = 13
    Caption = 'RAT'
  end
  object Label4: TLabel
    Left = 208
    Top = 120
    Width = 38
    Height = 13
    Caption = 'QOS Up'
  end
  object Label5: TLabel
    Left = 208
    Top = 144
    Width = 52
    Height = 13
    Caption = 'QOS Down'
  end
  object Label6: TLabel
    Left = 208
    Top = 168
    Width = 20
    Height = 13
    Caption = 'APN'
  end
  object Label7: TLabel
    Left = 208
    Top = 192
    Width = 64
    Height = 13
    Caption = 'Kodok Loncat'
  end
  object Label8: TLabel
    Left = 208
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Operator'
  end
  object Label9: TLabel
    Left = 416
    Top = 8
    Width = 108
    Height = 13
    Caption = 'AT Command Testing :'
  end
  object Label10: TLabel
    Left = 416
    Top = 192
    Width = 113
    Height = 13
    Caption = 'Data Transfer Monitor :'
  end
  object Label11: TLabel
    Left = 417
    Top = 212
    Width = 22
    Height = 13
    Caption = 'Sent'
  end
  object Label12: TLabel
    Left = 417
    Top = 236
    Width = 44
    Height = 13
    Caption = 'Received'
  end
  object Label13: TLabel
    Left = 561
    Top = 212
    Width = 24
    Height = 13
    Caption = 'Total'
  end
  object Label14: TLabel
    Left = 561
    Top = 236
    Width = 24
    Height = 13
    Caption = 'Total'
  end
  object Edit1: TEdit
    Left = 288
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 288
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 288
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 288
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit4'
  end
  object Edit5: TEdit
    Left = 288
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Edit5'
  end
  object Edit6: TEdit
    Left = 288
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'Edit6'
    OnKeyPress = Edit6KeyPress
  end
  object ComboBox1: TComboBox
    Left = 288
    Top = 192
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = 'ComboBox1'
  end
  object ProgressBar1: TProgressBar
    Left = 208
    Top = 56
    Width = 201
    Height = 17
    Min = 53
    Max = 103
    Position = 53
    TabOrder = 7
  end
  object Button1: TButton
    Left = 208
    Top = 232
    Width = 65
    Height = 25
    Caption = 'Close Port'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 232
    Width = 65
    Height = 25
    Caption = 'Connect to'
    TabOrder = 9
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 268
    Width = 697
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object RichEdit1: TRichEdit
    Left = 416
    Top = 48
    Width = 273
    Height = 137
    Lines.Strings = (
      'RichEdit1')
    ScrollBars = ssVertical
    TabOrder = 11
    WordWrap = False
  end
  object Edit7: TEdit
    Left = 416
    Top = 24
    Width = 273
    Height = 21
    TabOrder = 12
    Text = 'ATI'
    OnKeyPress = Edit7KeyPress
  end
  object ComboBox2: TComboBox
    Left = 352
    Top = 232
    Width = 57
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    Text = 'ComboBox2'
  end
  object Edit8: TEdit
    Left = 472
    Top = 208
    Width = 81
    Height = 21
    TabOrder = 14
    Text = 'Edit8'
  end
  object Edit9: TEdit
    Left = 472
    Top = 232
    Width = 81
    Height = 21
    TabOrder = 15
    Text = 'Edit9'
  end
  object Edit10: TEdit
    Left = 608
    Top = 208
    Width = 81
    Height = 21
    TabOrder = 16
    Text = 'Edit10'
  end
  object Edit11: TEdit
    Left = 608
    Top = 232
    Width = 81
    Height = 21
    TabOrder = 17
    Text = 'Edit11'
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    OnRxChar = ComPort1RxChar
    Left = 112
    Top = 240
  end
  object XPManifest1: TXPManifest
    Left = 80
    Top = 240
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 152
    Top = 240
  end
end
