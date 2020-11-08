unit ReadProgram;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi,Registry;

type
  TReadProgramX = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Panel2: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  WIn32or64 : Boolean;
  procedure DetectFileInstaler;
  procedure WriteRegistry;
  end;

var
  ReadProgramX: TReadProgramX;
    win32, win64, win3264, AppPath : String;
implementation
function IsWindows64: Boolean;
type
  TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64       : BOOL;
begin
  // 1) assume that we are not running under Windows 64 bit
  Result := False;

  // 2) Load kernel32.dll library
  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then Exit; // Loading kernel32.dll was failed, just return

  try

    // 3) Load windows api IsWow64Process
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');
    if not Assigned(vIsWow64Process) then Exit; // Loading IsWow64Process was failed, just return

    // 4) Execute IsWow64Process against our own process
    vIsWow64 := False;
    if (vIsWow64Process(GetCurrentProcess, vIsWow64)) then
      Result := vIsWow64;   // use the returned value

  finally
    FreeLibrary(vKernel32Handle);  // unload the library
  end;
end;
{$R *.dfm}
procedure RunShellInstaler(const AppDir , prog : string; index : integer);
var
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
  Handle: HWnd;
  AppProgX : String;
begin
     if DirectoryExists(AppDir) then begin
       if FileExists(AppDir + prog) then begin
          AppProgX := Prog;
          FillChar(StartupInfo, SizeOf(StartupInfo), 0);
          with StartupInfo do  begin
               cb := SizeOf(TStartupInfo);
               wShowWindow := SW_HIDE;
          end;
            if CreateProcess(nil, PChar('CMD.exe /C' + trim(prog)),nil, nil, true, CREATE_NO_WINDOW,
                   nil,  PChar(AppDir) , StartupInfo, ProcessInformation) then
           begin
           while WaitForSingleObject(ProcessInformation.hProcess, 10) > 0 do begin
               Application.ProcessMessages;
            //  if MainForm.AktifMsg = index then  MessageToTray('Start '+AppProgX);
            //  MainForm.FormTray();
           end;
               CloseHandle(ProcessInformation.hProcess);
               CloseHandle(ProcessInformation.hThread);
             //  MainForm.AktifMsg := 0;  MessageToTray('Close '+AppProgX);
           if  index = 1 then  ReadProgramX.DetectFileInstaler;;
           end  else begin
           end;
       end  else begin
       ShellExecute(Handle, 'OPEN',PChar('explorer.exe'),
                  PChar('/OPEN, "'+ AppDir +'"'), nil,SW_NORMAL);

       end;
    end  else begin
      if CreateDir( AppDir ) then
      ShellExecute(Handle, 'OPEN',PChar('explorer.exe'),
                  PChar('/OPEN, "'+ AppDir +'"'), nil,SW_NORMAL);

    end;
end;


procedure TReadProgramX.FormCreate(Sender: TObject);
begin
   AppPath := ExtractFilePath(Application.ExeName);
   win32 := 'C:\Program Files\';
   Win64 := 'C:\Program Files (x86)\';
    if DirectoryExists(win32) or DirectoryExists(win64) then begin
       if IsWindows64 = true then
          win3264 := Win64
       else
          win3264 := Win32;
    end;

end;


procedure TReadProgramX.Button1Click(Sender: TObject);
begin
    DetectFileInstaler;
end;
procedure TReadProgramX.DetectFileInstaler;
begin
    if (DirectoryExists(win3264+ 'Bitvise SSH Client\')) and
       (FileExists(win3264+ 'Bitvise SSH Client\BvSsh.exe')) then begin
           Panel1.Color := ClRed;
           if (DirectoryExists(win3264+ 'Proxifier\')) and
              (FileExists(win3264+ 'Proxifier\Proxifier.exe')) then begin
               {run Program start}
                ReadProgramX.WriteRegistry;
           end else begin
               RunShellInstaler(AppPath+'Files\' , 'ProxifierSetup.exe', 1);
               Label2.Caption := (win3264)+ #13#10'Instaling ProxifierSetup.exe';
           end;
    end else begin
        Label1.Caption := (win3264)+ #13#10'Instaling BvSshClient4.63.exe';
        RunShellInstaler(AppPath+'Files\' , 'BvSshClient4.63.exe', 1);

    end;

end;
procedure TReadProgramX.WriteRegistry;
Var
   Reg : Tregistry  ;
   regKey : DWORD;
   Key : String;
begin
  Reg := TRegistry.Create;
try
     reg.RootKey := HKEY_CURRENT_USER;
     Key := 'Software\Initex\Proxifier\License';
     if Reg.OpenKey(key, true)  then Begin
           Reg.WriteString('Owner','MFC NetWork') ;
           Reg.WriteString('Key','T3ZWQ-P2738-3FJWS-YE7HT-6NA3K') ;

           Reg.CloseKey;
           ShowMessage('Sukses')
     end;
   Finally
       Reg.Free;
   end;
end;
procedure TReadProgramX.Button2Click(Sender: TObject);
Var
   Reg : Tregistry  ;
   regKey : DWORD;
   Key : String;
begin
  Reg := TRegistry.Create;
try
     reg.RootKey := HKEY_CURRENT_USER;
     Key := 'Software\Initex\Proxifier\License';
     if Reg.OpenKeyReadOnly(Key) then Begin
        if Reg.ValueExists('Owner') then begin
           label1.Caption := Reg.ReadString('Owner') ;
        end;
     if Reg.ValueExists('Key') then begin
        label2.Caption := Reg.ReadString('Key')
     end;
        Reg.CloseKey;
     end;
   Finally
       Reg.Free;
   end;
end;

procedure TReadProgramX.Button3Click(Sender: TObject);
Var
   Reg : Tregistry  ;
   regKey : DWORD;
   Key : String;
begin
  Reg := TRegistry.Create;
try
     reg.RootKey := HKEY_CURRENT_USER;
     Key := 'Software\Initex\Proxifier\License';
     if Reg.OpenKey(key, true)  then Begin
           Reg.WriteString('Owner','MFC NetWork') ;
           Reg.WriteString('Key','T3ZWQ-P2738-3FJWS-YE7HT-6NA3K') ;

           Reg.CloseKey;
           ShowMessage('Sukses')
     end;
   Finally
       Reg.Free;
   end;
end;

end.
