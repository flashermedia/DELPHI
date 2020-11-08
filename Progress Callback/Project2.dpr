program Project2;

uses
 // ExceptionLog,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uProgressTemplate in 'uProgressTemplate.pas' {frmProgressForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
