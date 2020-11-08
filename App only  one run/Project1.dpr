program Project1;

uses
  Forms,
  windows,
  dialogs,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  CreateMutex(nil , true , 'Object Mutex');
  if GetLastError = 0  then begin
//  if GetLastError = ERROR_ALREADY_EXIST then begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
    end else begin
        ShowMessage('Aplikasi sudah di buka');
  end;
end.
