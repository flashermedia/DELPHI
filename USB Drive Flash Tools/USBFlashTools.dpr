program USBFlashTools;



uses
  Forms,
  form_AdvancedCopy in 'form_AdvancedCopy.pas' {frm_AdvancedCopy},
  frame_Location in 'frame_Location.pas' {fme_Location: TFrame},
  About_U in 'About_U.pas' {About_F},
  AppGlobals in 'AppGlobals.pas',
  form_Main in 'form_Main.pas' {frmMain},
  form_BackupRestore in 'form_BackupRestore.pas' {frmBackupRestore},
  form_SecureErase in 'form_SecureErase.pas' {frmSecureErase},
  form_VerifyCapacity in 'form_VerifyCapacity.pas' {frmVerifyCapacity},
  gzipWrap in 'gzipWrap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'USB Flash Tools';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
