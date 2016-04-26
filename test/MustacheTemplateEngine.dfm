object fmMustache: TfmMustache
  Left = 217
  Top = 155
  Width = 958
  Height = 598
  Caption = 'Mustache Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object panList: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 571
    Align = alClient
    BevelOuter = bvNone
    Caption = 'panList'
    TabOrder = 0
  end
  object panEast: TPanel
    Left = 393
    Top = 0
    Width = 557
    Height = 571
    Align = alRight
    BevelOuter = bvNone
    Caption = 'panEast'
    TabOrder = 1
    object templateText: TMemo
      Left = 0
      Top = 25
      Width = 557
      Height = 248
      Align = alTop
      BevelOuter = bvNone
      BorderStyle = bsNone
      Lines.Strings = (
        'templateText')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object panMemoHeader: TPanel
      Left = 0
      Top = 273
      Width = 557
      Height = 25
      Align = alTop
      Caption = 'Html text'
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 557
      Height = 25
      Align = alTop
      Caption = 'Template text'
      TabOrder = 2
    end
    object htmlText: TMemo
      Left = 0
      Top = 298
      Width = 557
      Height = 273
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      Lines.Strings = (
        'htmlText')
      ScrollBars = ssBoth
      TabOrder = 3
    end
  end
end
