object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Microsoft Azure text-to-speech Delphi example'
  ClientHeight = 406
  ClientWidth = 616
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 330
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 8
  Padding.Top = 8
  Padding.Right = 8
  Padding.Bottom = 8
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object LabelMemoTitle: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 194
    Width = 600
    Height = 19
    Margins.Left = 0
    Margins.Top = 12
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Enter some text into this field:'
    ExplicitLeft = 0
    ExplicitTop = 186
    ExplicitWidth = 182
  end
  object LabelTokenTitle: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 132
    Width = 600
    Height = 19
    Margins.Left = 0
    Margins.Top = 12
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Token:'
    ExplicitLeft = 0
    ExplicitTop = 124
    ExplicitWidth = 39
  end
  object LabelKeyTitle: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 70
    Width = 600
    Height = 19
    Margins.Left = 0
    Margins.Top = 12
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Key:'
    ExplicitLeft = 0
    ExplicitTop = 62
    ExplicitWidth = 25
  end
  object LabelRegionTitle: TLabel
    Left = 8
    Top = 8
    Width = 600
    Height = 19
    Align = alTop
    Caption = 'Region:'
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 45
  end
  object MemoText: TMemo
    AlignWithMargins = True
    Left = 8
    Top = 217
    Width = 600
    Height = 146
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    Lines.Strings = (
      'Hello! '#1055#1088#1080#1074#1077#1090'!'
      
        #1055#1086#1076#1087#1080#1089#1099#1074#1072#1081#1089#1103' '#1085#1072' '#1082#1072#1085#1072#1083' '#1055#1077#1090#1088' Turbo '#1076#1083#1103' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' Turbo '#1082#1086#1085#1090#1077#1085#1090#1072'! '#1052 +
        #1103#1082#1086#1090#1082#1072'...')
    ScrollBars = ssVertical
    TabOrder = 3
    ExplicitLeft = 0
    ExplicitTop = 209
    ExplicitWidth = 500
    ExplicitHeight = 136
  end
  object EditKey: TEdit
    AlignWithMargins = True
    Left = 8
    Top = 93
    Width = 600
    Height = 27
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    PasswordChar = '*'
    TabOrder = 1
    TextHint = 
      'Ocp-Apim-Subscription-Key (may be blank if Token field is filled' +
      ')'
    ExplicitLeft = 0
    ExplicitTop = 85
    ExplicitWidth = 500
  end
  object EditToken: TEdit
    AlignWithMargins = True
    Left = 8
    Top = 155
    Width = 600
    Height = 27
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    PasswordChar = '*'
    TabOrder = 2
    TextHint = 'Authorization token (required if Key field is blank)'
    ExplicitLeft = 0
    ExplicitTop = 147
  end
  object EditRegion: TEdit
    AlignWithMargins = True
    Left = 8
    Top = 31
    Width = 600
    Height = 27
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    TabOrder = 0
    TextHint = 'Region identifier'
    ExplicitLeft = 0
    ExplicitTop = 23
    ExplicitWidth = 500
  end
  object PanelBottom: TGridPanel
    AlignWithMargins = True
    Left = 8
    Top = 373
    Width = 600
    Height = 25
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 2
        Control = PanelButtons
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 4
    ExplicitLeft = 0
    ExplicitTop = 355
    ExplicitWidth = 500
    DesignSize = (
      600
      25)
    object PanelButtons: TPanel
      Left = 222
      Top = 0
      Width = 155
      Height = 25
      Anchors = []
      BevelOuter = bvNone
      Color = clHighlight
      TabOrder = 0
      ExplicitLeft = 221
      DesignSize = (
        155
        25)
      object ButtonPlaySpeech: TButton
        Left = 0
        Top = 0
        Width = 75
        Height = 25
        Anchors = []
        Caption = '[Play]'
        TabOrder = 0
        OnClick = ButtonPlaySpeechClick
      end
      object ButtonSaveSpeech: TButton
        Left = 80
        Top = 0
        Width = 75
        Height = 25
        Anchors = []
        Caption = 'Save'
        TabOrder = 1
        OnClick = ButtonSaveSpeechClick
        ExplicitLeft = 81
      end
    end
  end
  object FileSaveDialog: TFileSaveDialog
    DefaultExtension = '.mp3'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'mp3'
        FileMask = '*.mp3'
      end>
    Options = [fdoOverWritePrompt, fdoStrictFileTypes]
    Left = 288
    Top = 248
  end
end
