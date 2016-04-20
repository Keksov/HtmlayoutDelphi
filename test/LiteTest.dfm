object HtmLiteTest: THtmLiteTest
  Left = 571
  Top = 172
  Width = 873
  Height = 462
  Caption = 'HtmLiteTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object pan660: TPanel
    Left = 10
    Top = 289
    Width = 660
    Height = 13
    Caption = '660px 1/1'
    TabOrder = 0
  end
  object pan330: TPanel
    Left = 10
    Top = 196
    Width = 330
    Height = 13
    Caption = '330px 1/2'
    TabOrder = 1
  end
  object pan495: TPanel
    Left = 10
    Top = 235
    Width = 495
    Height = 13
    Caption = '495px 3/4'
    TabOrder = 2
  end
  object pan825: TPanel
    Left = 10
    Top = 352
    Width = 825
    Height = 13
    Caption = '825px 5/4'
    TabOrder = 3
  end
  object butPrint: TButton
    Left = 393
    Top = 188
    Width = 75
    Height = 25
    Caption = 'Print'
    TabOrder = 4
    OnClick = butPrintClick
  end
  object dlgPrint: TPrintDialog
    Left = 8
    Top = 8
  end
end
