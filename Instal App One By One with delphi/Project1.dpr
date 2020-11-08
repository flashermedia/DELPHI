program Project1;

uses
  Forms,
  ReadProgram in 'ReadProgram.pas' {ReadProgramX};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TReadProgramX, ReadProgramX);
  Application.Run;
end.
