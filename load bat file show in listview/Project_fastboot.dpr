program Project_fastboot;

uses
  Vcl.Forms,
  Unitfastboot in 'Unitfastboot.pas' {Form1},
  Unit_FastbootFlash in 'Unit_FastbootFlash.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
