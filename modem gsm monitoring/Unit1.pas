unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, XPMan, ComCtrls, ComObj, ActiveX, unitportdetect,
  ExtCtrls, StrUtils;

type
  TForm1 = class(TForm)
    ComPort1: TComPort;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    ComboBox1: TComboBox;
    XPManifest1: TXPManifest;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    RichEdit1: TRichEdit;
    Edit7: TEdit;
    Label9: TLabel;
    Timer1: TTimer;
    ComboBox2: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    function DetectAndTestDevice: string;
    procedure sendCommand(cmd: string);
    procedure setGlobalCommand;
    { Public declarations }
  end;

var
  Form1: TForm1;
  DevicePort, DeviceName: string;
  list: TStrings;
const
    LF = #10 ;
    CR = #13 ;
    CRLF: PChar = CR + LF ;
    COM_COUNT = 256;

implementation

{$R *.dfm}

function HexToInt(HexNum: string): LongInt;
begin
  Result:=StrToInt('$' + HexNum) ;
end;

function BytesToFriendlyString(Value : DWord) : string;
const
  OneKB = 1024;
  OneMB = OneKB * 1024;
  OneGB = OneMB * 1024;
begin
  if Value < OneKB then
    Result := FormatFloat('#,##0.00 B',Value)
  else
    if Value < OneMB then
      Result := FormatFloat('#,##0.00 KB', Value / OneKB)
    else
      if Value < OneGB then
        Result := FormatFloat('#,##0.00 MB', Value / OneMB)
end; (*BytesToFriendlyString*)

function Explode(const str: string; const separator: string): TStrings;
var
  n: integer;
  p, q, s: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    s := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, s);
      if q = nil then q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

function TForm1.DetectAndTestDevice: string;
var
  comPorts: array[0..COM_COUNT - 1] of TDetectedPort;
  i: integer;
  sOK: string;
  sLOK: TStringList;
begin
  sLOK:= TStringList.Create;
  getCOMPorts(comPorts);
  ComboBox2.Items.Clear;
  for i := 0 to COM_COUNT - 1 do
  begin
    with comPorts[i] do begin
      // set port enumeration
      if friendlyName <> '' then begin
        ComboBox2.Items.Add('COM' + IntToStr(i + 1));
        if Pos('PC UI', friendlyName) <> 0 then begin
          DevicePort := 'COM' + IntToStr(i + 1);
          DeviceName := friendlyName;
        end
        else if Pos('NMEA Device',friendlyName) <> 0 then begin
          DevicePort := 'COM' + IntToStr(i + 1);
          DeviceName := friendlyName;
        end
        else if Pos('Secondary Port Modem',friendlyName) <> 0 then begin
          DevicePort := 'COM' + IntToStr(i + 1);
          DeviceName := friendlyName;
        end
        else if Pos('AT Command Port',friendlyName) <> 0 then begin
          DevicePort := 'COM' + IntToStr(i + 1);
          DeviceName := friendlyName;
        end;

      end;
    end;
  end;
  ComboBox2.ItemIndex := 0;

  if ComPort1.Connected then
    ComPort1.Close;
  ComPort1.BaudRate                 := br115200;
  ComPort1.DataBits                 := dbSeven;
  ComPort1.StopBits                 := sbOneStopBit;
  ComPort1.Parity.Bits              := prEven;
  ComPort1.FlowControl.ControlDTR   := dtrEnable;
  ComPort1.FlowControl.ControlRTS   := rtsEnable;
  ComPort1.Port := DevicePort;
  ComPort1.Open;

  StatusBar1.Panels.Items[0].Text := 'Mendeteksi Port Modem...';
  if ComPort1.Connected then
    Timer1.Enabled := True;
end;

procedure TForm1.sendCommand(cmd: string);
begin
  if ComPort1.Connected then
    ComPort1.WriteStr(cmd + CRLF);
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
  ComPort1.Port := ComboBox2.Items.Strings[ComboBox2.ItemIndex];
  if ComPort1.Connected then
    ComPort1.Close;
  ComPort1.Open;
  Timer1.Enabled := True;
end;

procedure TForm1.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    sendCommand(Edit7.Text);
  end;
end;

procedure TForm1.ComPort1RxChar(Sender: TObject; Count: Integer);
var
  c, Buffer: string;
begin
  if ComPort1.Connected then begin
    ComPort1.ReadStr(Buffer, Count);
     // bagian ini untuk menentukan RSSI
     if Pos('RSSI:', Buffer) > 0 then begin
        c := copy(Buffer, pos('RSSI:', Buffer) + 5, length(Buffer));
        Edit2.Text := '-' + IntToStr(StrToInt(Trim(c)) + 53) + 'dbm';
        ProgressBar1.Position := StrToInt(Trim(c)) + 53;
     end;
     if Pos('CSQ:', Buffer) > 0 then begin
        c := copy(Buffer, pos('CSQ:', Buffer) + 4, length(Buffer));
        list:= Explode(c,',');
        c:=list[0];
        Edit2.Text := '-' + IntToStr(StrToInt(Trim(c)) + 53) + 'dbm';
        ProgressBar1.Position := StrToInt(Trim(c)) + 53;
     end;

     // bagian ini untuk menentukan APN
     if Pos('CGDCONT: 1', Buffer) > 0 then begin
        c := copy(Buffer, pos('CGDCONT: 1', Buffer), length(Buffer));
        list:= Explode(c,',');
        Edit6.Text := StringReplace(list[2],'"','',[rfReplaceAll]);
     end;

     // bagian ini untuk menentukan QOS (Quality of Service)
     if Pos('CGEQNEG: ', Buffer) > 0 then begin
        c := copy(Buffer, pos('CGEQNEG: ', Buffer), length(Buffer));
        list:= Explode(c,',');
        Edit4.Text := list[2];
        Edit5.Text := list[3];
     end;

     // bagian ini untuk menentukan Nama Operator
     if Pos('+COPS:', Buffer) > 0 then begin
        c := copy(Buffer, pos('+COPS:', Buffer) + 7, length(Buffer));
        list:= Explode(c,',');
        Edit1.Text := list[2];
     end;

     // bagian ini untuk menentukan RAT (jenis jaringan)
     if Pos('^SYSINFO:', Buffer) > 0 then begin
        c := copy(Buffer, pos('^SYSINFO:', Buffer) + 9, length(Buffer));
        list:= Explode(c,',');
        c:= list[3];
        list.Text := StringReplace('Unknown|GSM|GPRS|EDGE|3G|HSDPA|HSUPA|HSD+UPA||TD_SCDMA|HSPA+','|',CRLF,[rfReplaceAll]);
        Edit3.Text := list[StrToInt(c)];
     end;
     if Pos('MODE:', Buffer) > 0 then begin
        c := copy(Buffer, pos('MODE:', Buffer) + 6, 8);
        list:= Explode(c,',');
        c:= list[1];
        list.Text := StringReplace('Unknown|GSM|GPRS|EDGE|3G|HSDPA|HSUPA|HSD+UPA||TD_SCDMA|HSPA+','|',CRLF,[rfReplaceAll]);
        Edit3.Text := list[StrToInt(Trim(c))];
     end;

    // data transfer
    if Pos('DSFLOWRPT:',Buffer) <> 0 then begin
      c := copy(Buffer, pos('DSFLOWRPT:', Buffer) + 11, length(Buffer));
      list:= Explode(c,',');
      Edit8.Text := BytesToFriendlyString(HexToInt(Trim(list[1])));
      Edit9.Text := BytesToFriendlyString(HexToInt(Trim(list[2])));
      Edit10.Text := BytesToFriendlyString(HexToInt(Trim(list[3])));
      Edit11.Text := BytesToFriendlyString(HexToInt(Trim(list[4])));
    end;


    RichEdit1.Lines.Text := Buffer;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if ComPort1.Connected then
    ComPort1.Close;
  ComPort1.Open;
  if ComPort1.Connected then begin
    setGlobalCommand;
    StatusBar1.Panels.Items[0].Text := 'Device Connected to ' + DeviceName;
    Timer1.Enabled := False;
  end;
end;

procedure TForm1.setGlobalCommand;
begin
  //if ComPort1.Connected then begin
    sendCommand('AT+COPS=0,0');
    Sleep(100);
    sendCommand('AT+CSQ');
    Sleep(10);
    sendCommand('AT^SYSINFO');
    Sleep(10);
    sendCommand('AT^SYSCFG?');
    Sleep(10);
    sendCommand('AT+CGDCONT?');
    Sleep(10);
    sendCommand('AT+COPS?');
    Sleep(10);
    sendCommand('AT+CGEQNEG');
    Sleep(10);
  //end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ComPort1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    DetectAndTestDevice;
end;

procedure TForm1.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    sendCommand('AT+CGDCONT=1,"IP","'+Edit6.Text+'","0.0.0.0",0,0');
end;

end.
