program CosinePaletteGenerator;

uses
  FastMM4,
  Vcl.Forms,
  CPG.Main in 'CPG.Main.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.