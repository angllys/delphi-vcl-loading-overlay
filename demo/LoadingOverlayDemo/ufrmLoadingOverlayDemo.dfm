object frmLoadingOverlayDemo: TfrmLoadingOverlayDemo
  Left = 0
  Top = 0
  Caption = 'Delphi VCL Loading Overlay Demo'
  ClientHeight = 520
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 840
    Height = 520
    Align = alClient
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 0
    object pnTopo: TPanel
      Left = 0
      Top = 0
      Width = 840
      Height = 96
      Align = alTop
      BevelOuter = bvNone
      Color = 15132390
      ParentBackground = False
      TabOrder = 0
      object lblTitulo: TLabel
        Left = 24
        Top = 18
        Width = 274
        Height = 30
        Caption = 'Delphi VCL Loading Overlay'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3158064
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSubTitulo: TLabel
        Left = 24
        Top = 52
        Width = 408
        Height = 17
        Caption = 
          'Demo pr'#225'tico com tr'#234's cen'#225'rios: processo s'#237'ncrono, TTask e TThre' +
          'ad.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5723991
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnBotoes: TPanel
      Left = 0
      Top = 96
      Width = 840
      Height = 72
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object btnProcessoSync: TButton
        Left = 24
        Top = 18
        Width = 180
        Height = 34
        Caption = 'Processo s'#237'ncrono'
        TabOrder = 0
        OnClick = btnProcessoSyncClick
      end
      object btnProcessoTTask: TButton
        Left = 224
        Top = 18
        Width = 180
        Height = 34
        Caption = 'Processo com TTask'
        TabOrder = 1
        OnClick = btnProcessoTTaskClick
      end
      object btnProcessoTThread: TButton
        Left = 424
        Top = 18
        Width = 180
        Height = 34
        Caption = 'Processo com TThread'
        TabOrder = 2
        OnClick = btnProcessoTThreadClick
      end
    end
    object pnStatus: TPanel
      Left = 0
      Top = 480
      Width = 840
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      Color = 15132390
      ParentBackground = False
      TabOrder = 2
      object lblStatus: TLabel
        Left = 24
        Top = 11
        Width = 38
        Height = 15
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3158064
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnConteudo: TPanel
      Left = 0
      Top = 168
      Width = 840
      Height = 312
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      DesignSize = (
        840
        312)
      object mmLog: TMemo
        Left = 24
        Top = 24
        Width = 792
        Height = 264
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3158064
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        Lines.Strings = (
          'Log de execu'#231#227'o...')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
end
