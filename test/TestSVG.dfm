object fmTestSVG: TfmTestSVG
  Left = 471
  Top = 159
  Width = 958
  Height = 670
  Caption = 'SVG Example'
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
    Width = 201
    Height = 643
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'panList'
    TabOrder = 0
  end
  object panEast: TPanel
    Left = 201
    Top = 0
    Width = 749
    Height = 643
    Align = alClient
    BevelOuter = bvNone
    Caption = 'panEast'
    TabOrder = 1
    object templateText: TMemo
      Left = 0
      Top = 25
      Width = 749
      Height = 230
      Align = alTop
      BevelOuter = bvNone
      BorderStyle = bsNone
      Lines.Strings = (
        'templateText')
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = templateTextChange
    end
    object panDemoHeader: TPanel
      Left = 0
      Top = 255
      Width = 749
      Height = 25
      Align = alTop
      Caption = 'SVG'
      TabOrder = 1
      object butRefresh: TButton
        Left = 3
        Top = 3
        Width = 75
        Height = 19
        Hint = 'Update SVG control with text from field above'
        Caption = 'Refresh'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = butRefreshClick
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 749
      Height = 25
      Align = alTop
      Caption = 'Template text'
      TabOrder = 2
    end
    object panDemo: TPanel
      Left = 0
      Top = 280
      Width = 749
      Height = 363
      Align = alClient
      BevelOuter = bvNone
      Caption = 'panDemo'
      TabOrder = 3
    end
  end
end
