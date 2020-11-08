unit UsbDetection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unit2, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
  FUsb : TUsbClass;
     procedure UsbIN(ASender : TObject; const ADevType,ADriverName,
                     AFriendlyName : string);
     procedure UsbOUT(ASender : TObject; const ADevType,ADriverName,
                      AFriendlyName : string);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
// begin
  FUsb := TUsbClass.Create;
   FUsb.OnUsbInsertion := UsbIN;
  FUsb.OnUsbRemoval := UsbOUT;
// end;
end;
 procedure TForm1.UsbIN(ASender : TObject; const ADevType,ADriverName,
                        AFriendlyName : string);
 begin
 memo1.Color := clred;
   if pos (';', ADevType ) <> 0 then begin
     label1.Caption  := 'Connect: '+ copy(ADevType, pos(';', ADevType)+ 1,
                          pos(';', ADevType)+1);
 {  showmessage(USB Inserted - Device Type =  + ADevType + #13#10 +
               Driver Name =  + ADriverName + #13+#10 +
               Friendly Name =  + AFriendlyName);  }
 end; end;


 procedure TForm1.UsbOUT(ASender : TObject; const ADevType,ADriverName,
                         AFriendlyName : string);
 begin
 memo1.Color := clyellow;
    if pos (';', ADevType ) <> 0 then begin
     label1.Caption  := 'DisConnect: '+ copy(ADevType, pos(';', ADevType)+ 1,
                          pos(';', ADevType)+1);
 {  showmessage(USB Removed - Device Type =  + ADevType + #13#10 +
               Driver Name =  + ADriverName + #13+#10 +
               Friendly Name =  + AFriendlyName);    }
 end; end;
end.
