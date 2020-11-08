object frmProgressForm: TfrmProgressForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'this is a progress template form'
  ClientHeight = 250
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 17
    Width = 79
    Height = 13
    Caption = 'Overall progress'
  end
  object Label2: TLabel
    Left = 17
    Top = 128
    Width = 82
    Height = 13
    Caption = 'Current progress'
  end
  object pbOverall: TProgressBar
    Left = 17
    Top = 50
    Width = 520
    Height = 40
    TabOrder = 0
  end
  object pbCurrent: TProgressBar
    Left = 17
    Top = 161
    Width = 520
    Height = 40
    TabOrder = 1
  end
end
