unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sGroupBox, sEdit, sMemo, sLabel, sButton, DosCommand,
  INIFiles, sSkinProvider, sSkinManager, ExtCtrls, sPanel, Menus, sCheckBox,Shellapi;

type
  TForm1 = class(TForm)
    sSkinProvider1: TsSkinProvider;
    sSkinManager1: TsSkinManager;
    frpanel1: TsPanel;
    sGroupBox1: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    edt1: TsEdit;
    edt2: TsEdit;
    akpanel1: TsPanel;
    sGroupBox2: TsGroupBox;
    log: TsMemo;
    PopupMenu1: TPopupMenu;
    C1: TMenuItem;
    sCheckBox1: TsCheckBox;
    sPanel3: TsPanel;
    btn2: TsButton;
    btn1: TsButton;
    sButton1: TsButton;
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure sCheckBox1Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R 'RequestAdmin.RES' 'RequestAdmin.RC'}

procedure TForm1.btn1Click(Sender: TObject);
var
  dos : TDosCommand;
  FNS : string;
begin
  log.Clear;
  if edt1.GetTextLen < 1 then
  begin
    Application.MessageBox('SSID Tidak Boleh Kosong!', 'Error', MB_OK or MB_ICONERROR);
  end
  else if edt2.GetTextLen < 8 then
  begin
    Application.MessageBox('Password minimal 8 karakter.', 'Error', MB_OK or MB_ICONERROR);
  end
  else
  begin
    dos := TDosCommand.Create(nil);
    FNS := 'netsh wlan set hostednetwork mode=allow ssid='+edt1.Text+' key='+edt2.Text+'';
    dos.CommandLine := FNS;
    dos.OutputLines := log.Lines;
    dos.Execute;
    beep;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  save : TINIFile;
begin
  save := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'cfg.ini');
  save.WriteString('FNS AdHoc WiFi', 'SSID', edt1.Text);
  save.WriteString('FNS AdHoc WiFi', 'Pass', edt2.Text);
  save.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  save : TINIFile;
begin
  save := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'cfg.ini');
  edt1.Text := save.ReadString('FNS AdHoc WiFi', 'SSID', '');
  edt2.Text := save.ReadString('FNS AdHoc WiFi', 'Pass', '');
  save.Free;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  dos : TDosCommand;
  fornesia : string;
begin
  if btn2.Caption = 'START' then
  begin
    log.Clear;
    dos := TDosCommand.Create(nil);
    fornesia := 'netsh wlan start hostednetwork';
    dos.CommandLine := fornesia;
    dos.OutputLines := log.Lines;
    dos.Execute;
    btn2.Caption := 'STOP';
    beep;
  end
  else if btn2.Caption = 'STOP' then
  begin
    log.Clear;
    dos := TDosCommand.Create(nil);
    fornesia := 'netsh wlan stop hostednetwork';
    dos.CommandLine := fornesia;
    dos.OutputLines := log.Lines;
    dos.Execute;
    btn2.Caption := 'START';
    beep;
  end;
end;

procedure TForm1.C1Click(Sender: TObject);
begin
log.Clear;
end;

procedure TForm1.sCheckBox1Click(Sender: TObject);
begin
if sCheckBox1.Checked= True then begin
edt2.PasswordChar:=#0;
end
else
if sCheckBox1.Checked= false then begin
 edt2.PasswordChar:='*';
end;
end;

procedure TForm1.sButton1Click(Sender: TObject);
begin
ShellExecute (0, 'Open', 'http://www.fornesia.com', '', '', SW_SHOWNORMAL);
end;

end.
