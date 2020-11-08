unit form_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  form_BackupRestore;

type
  TfrmMain = class(TForm)
    pbBackup: TButton;
    pbRestore: TButton;
    pbSecDelete: TButton;
    pbVerify: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pbAdvanced: TButton;
    Label6: TLabel;
    pnlPanel1: TPanel;
    pbClose: TButton;
    pbAbout: TButton;
    procedure pbVerifyClick(Sender: TObject);
    procedure pbSecDeleteClick(Sender: TObject);
    procedure pbRestoreClick(Sender: TObject);
    procedure pbBackupClick(Sender: TObject);
    procedure pbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbAdvancedClick(Sender: TObject);
    procedure pbAboutClick(Sender: TObject);
  private
    procedure DoBackupRestore(backupRestore: TBackupRestoreDlgType);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  About_U,
  form_AdvancedCopy, form_SecureErase, form_VerifyCapacity;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  self.caption := Application.Title;

  pnlPanel1.Caption := '';
  pnlPanel1.BevelInner := bvLowered;
  pnlPanel1.BevelOuter := bvNone;
end;

procedure TfrmMain.pbAboutClick(Sender: TObject);
begin
  ShowAboutDialog();
end;

procedure TfrmMain.pbAdvancedClick(Sender: TObject);
var
  dlg: Tfrm_AdvancedCopy;
begin
  dlg:= Tfrm_AdvancedCopy.Create(nil);
  try
    dlg.ShowModal();
  finally
    dlg.Free();
  end;

end;

procedure TfrmMain.pbBackupClick(Sender: TObject);
begin
  DoBackupRestore(opBackup);
end;

procedure TfrmMain.pbRestoreClick(Sender: TObject);
begin
  DoBackupRestore(opRestore);
end;

procedure TfrmMain.pbSecDeleteClick(Sender: TObject);
var
  dlg: TfrmSecureErase;
begin
  dlg:= TfrmSecureErase.Create(nil);
  try
    dlg.ShowModal();
  finally
    dlg.Free();
  end;

end;

procedure TfrmMain.pbVerifyClick(Sender: TObject);
var
  dlg: TfrmVerifyCapacity;
begin
  dlg:= TfrmVerifyCapacity.Create(nil);
  try
    dlg.ShowModal();
  finally
    dlg.Free();
  end;

end;

procedure TfrmMain.DoBackupRestore(backupRestore: TBackupRestoreDlgType);
var
  dlg: TfrmBackupRestore;
begin
  dlg:= TfrmBackupRestore.Create(nil);
  try
    dlg.DlgType := backupRestore;
    dlg.ShowModal();
  finally
    dlg.Free();
  end;

end;


procedure TfrmMain.pbCloseClick(Sender: TObject);
begin
  Close();
end;

END.

