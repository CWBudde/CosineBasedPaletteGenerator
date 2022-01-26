unit CPG.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, GR32_Image, OPDE_DifferentialEvolution;

type
  TVec3 = record
  private
    FX, FY, FZ: Single;
  public
    constructor Create(X, Y, Z: Single);

    property X: Single read FX;
    property Y: Single read FY;
    property Z: Single read FZ;
  end;

  TForm4 = class(TForm)
    ImageSource: TImage32;
    PaintBoxOutput: TPaintBox32;
    ButtonStart: TButton;
    DE: TNewDifferentialEvolution;
    StatusBar1: TStatusBar;
    FileOpenDialog1: TFileOpenDialog;
    MemoSourceCode: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    function DECalculateCosts(Sender: TObject; Data: PDoubleArray;
      Count: Integer): Double;
    procedure PaintBoxOutputClick(Sender: TObject);
    procedure DEBestCostChanged(Sender: TObject; BestCost: Double);
    procedure ImageSourceClick(Sender: TObject);
    procedure DEGenerationChanged(Sender: TObject; Generation: Integer);
  private
    procedure PaintOutput;
    procedure ShowSourceCode;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses
  GR32, GR32_PNG, GR32_PortableNetworkGraphic;

function CalculateCosPalette(t: Double; Parameter: PDoubleArray): TVec3; overload;
begin
  Result := TVec3.Create(
    Parameter[0] + Parameter[3] * cos(Parameter[6] * t + Parameter[9]),
    Parameter[1] + Parameter[4] * cos(Parameter[7] * t + Parameter[10]),
    Parameter[2] + Parameter[5] * cos(Parameter[8] * t + Parameter[11])
  );
end;


{ TVec3 }

constructor TVec3.Create(X, Y, Z: Single);
begin
  FX := X;
  FY := Y;
  FZ := Z;
end;

procedure TForm4.DEBestCostChanged(Sender: TObject; BestCost: Double);
begin
  PaintOutput;
  ShowSourceCode;
  StatusBar1.Panels[1].Text := FloatToStr(BestCost);
end;

function TForm4.DECalculateCosts(Sender: TObject; Data: PDoubleArray;
  Count: Integer): Double;
var
  Source: PColor32Entry;
  x: Integer;
  Color: TVec3;
const
  CByteScale = 1 / 255;
begin
  Source := PColor32Entry(ImageSource.Bitmap.PixelPtr[0, 0]);
  Result := 0;
  for x := 0 to 255 do
  begin
    Color := CalculateCosPalette(x * CByteScale, Data);
    Result := Result +
      sqr(Source.R - 255 * Color.x) +
      sqr(Source.G - 255 * Color.y) +
      sqr(Source.B - 255 * Color.z);
    Inc(Source);
  end;
end;

procedure TForm4.DEGenerationChanged(Sender: TObject; Generation: Integer);
begin
  if Generation mod 100 = 0 then
    StatusBar1.Panels[0].Text := IntToStr(Generation);
end;

function F2S(const Value: Extended; const Format: String = '0.###'): String;
var
  CurrentFormatSettings: TFormatSettings;
begin
  GetLocaleFormatSettings(GetThreadLocale, CurrentFormatSettings);
  CurrentFormatSettings.DecimalSeparator := '.';
  Result := FormatFloat(Format, Value, CurrentFormatSettings);
end;

procedure TForm4.ShowSourceCode;
var
  Best: TDEPopulationData;
begin
  Best := DE.BestPopulation;
  MemoSourceCode.Clear;
  MemoSourceCode.Lines.Add('vec3 palette( in float t ) {');
  MemoSourceCode.Lines.Add('  vec3 a = vec3(' + F2S(Best.Data[0]) + ', ' + F2S(Best.Data[1]) + ', ' + F2S(Best.Data[2]) + ');');
  MemoSourceCode.Lines.Add('  vec3 b = vec3(' + F2S(Best.Data[3]) + ', ' + F2S(Best.Data[4]) + ', ' + F2S(Best.Data[5]) + ');');
  MemoSourceCode.Lines.Add('  vec3 c = vec3(' + F2S(Best.Data[6]) + ', ' + F2S(Best.Data[7]) + ', ' + F2S(Best.Data[8]) + ');');
  MemoSourceCode.Lines.Add('  vec3 d = vec3(' + F2S(Best.Data[9]) + ', ' + F2S(Best.Data[10]) + ', ' + F2S(Best.Data[11]) + ');');
  MemoSourceCode.Lines.Add('  return a + b*cos( c*t+d );');
  MemoSourceCode.Lines.Add('}');
end;


procedure TForm4.ButtonStartClick(Sender: TObject);
begin
  if DE.IsRunning then
  begin
    DE.Stop;
    ButtonStart.Caption := '&Start';
  end
  else
  begin
    DE.Start;
    ButtonStart.Caption := '&Stop';
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  LoadBitmap32FromPNG(ImageSource.Bitmap, 'Gold-Single-Gradient.png');
end;

procedure TForm4.ImageSourceClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(Self) do
  try
    DefaultExtension := '.png';
    with FileTypes.Add do begin
      DisplayName := 'PNG files (*.png)';
      FileMask := '*.png';
    end;
    Title := 'Choose a PNG file containing a gradient ';

    if Execute then
    begin
      LoadBitmap32FromPNG(ImageSource.Bitmap, FileName);
      DE.Reset;
    end;
  except
    Free;
  end;
end;

procedure TForm4.PaintOutput;
var
  Target: PColor32Entry;
  Color: TVec3;
  x, y: Integer;
const
  CByteScale = 1 / 255;
begin
  for x := 0 to 255 do
  begin
    Color := CalculateCosPalette(x * CByteScale, DE.BestPopulation.DataPointer);
    for y := 0 to 31 do
    begin
      Target := PColor32Entry(PaintBoxOutput.Buffer.PixelPtr[x, y]);
      Target.R := Round(255 * Color.X);
      Target.G := Round(255 * Color.Y);
      Target.B := Round(255 * Color.Z);
    end;
  end;
  PaintBoxOutput.Invalidate;
end;


procedure TForm4.PaintBoxOutputClick(Sender: TObject);
begin
  PaintOutput;
end;

end.
