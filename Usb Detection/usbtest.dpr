program usbtest;

uses
  Forms,
  UsbDetection in 'UsbDetection.pas' {Form1},
  UsbDetect2 in 'UsbDetect2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
