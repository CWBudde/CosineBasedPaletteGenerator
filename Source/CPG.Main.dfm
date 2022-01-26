object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 227
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    352
    227)
  PixelsPerInch = 96
  TextHeight = 13
  object ImageSource: TImage32
    Left = 8
    Top = 8
    Width = 256
    Height = 32
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnClick = ImageSourceClick
  end
  object PaintBoxOutput: TPaintBox32
    Left = 8
    Top = 46
    Width = 256
    Height = 32
    TabOrder = 1
    OnClick = PaintBoxOutputClick
  end
  object ButtonStart: TButton
    Left = 270
    Top = 8
    Width = 75
    Height = 32
    Caption = 'Start'
    TabOrder = 2
    OnClick = ButtonStartClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 208
    Width = 352
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitLeft = 184
    ExplicitTop = 80
    ExplicitWidth = 0
  end
  object MemoSourceCode: TMemo
    Left = 8
    Top = 84
    Width = 336
    Height = 118
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'vec3 palette( in float t ) {'
      '    vec3 a = vec3(0., 0., 0.);'
      '    vec3 b = vec3(0., 0., 0.);'
      '    vec3 c = vec3(0., 0., 0.);'
      '    vec3 d = vec3(0., 0., 0.);'
      '    return a + b*cos( 6.28318*(c*t+d) );'
      '}')
    TabOrder = 4
    ExplicitHeight = 199
  end
  object DE: TNewDifferentialEvolution
    CrossOver = 0.900000000000000000
    DifferentialWeight = 0.400000000000000000
    PopulationCount = 64
    Variables = <
      item
        DisplayName = 'a.x'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'a.y'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'a.z'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'b.x'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'b.y'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'b.z'
        Minimum = -5.000000000000000000
        Maximum = 5.000000000000000000
      end
      item
        DisplayName = 'c.x'
        Maximum = 10.000000000000000000
      end
      item
        DisplayName = 'c.y'
        Maximum = 10.000000000000000000
      end
      item
        DisplayName = 'c.z'
        Maximum = 10.000000000000000000
      end
      item
        DisplayName = 'd.x'
        Maximum = 1.000000000000000000
      end
      item
        DisplayName = 'd.y'
        Maximum = 1.000000000000000000
      end
      item
        DisplayName = 'd.z'
        Maximum = 1.000000000000000000
      end>
    OnCalculateCosts = DECalculateCosts
    OnBestCostChanged = DEBestCostChanged
    OnGenerationChanged = DEGenerationChanged
    Left = 96
    Top = 32
  end
  object FileOpenDialog1: TFileOpenDialog
    DefaultExtension = '.png'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'PNG files (*.png)'
        FileMask = '*.png'
      end>
    Options = []
    Title = 'Choose a PNG file containing a gradient '
    Left = 168
    Top = 56
  end
end
