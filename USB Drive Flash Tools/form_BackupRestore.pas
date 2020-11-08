unit form_BackupRestore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  SDUProgressDlg, SDUFrames, SDUFilenameEdit_U,
  zlibex, zlibexgz, gzipWrap;

type
  TBackupRestoreDlgType = (opBackup, opRestore);

  TfrmBackupRestore = class(TForm)
    pnlDrive: TPanel;
    pnlFile: TPanel;
    lblFile: TLabel;
    cbDrive: TComboBox;
    lblDrive: TLabel;
    SDUFilenameEdit1: TSDUFilenameEdit;
    pnlButtons: TPanel;
    pbCancel: TButton;
    pbGo: TButton;
    ckDecompress: TCheckBox;
    cbCompressionLevel: TComboBox;
    lblCompression: TLabel;
    procedure pbGoClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbCompressionLevelChange(Sender: TObject);
    procedure ckDecompressClick(Sender: TObject);
    procedure SDUFilenameEdit1Change(Sender: TObject);
  private
    FDlgType: TBackupRestoreDlgType;
    Processing: boolean;
    ProgressDlg: TSDUProgressDialog;

    procedure PopulateCompressionLevel();
    procedure SetCompressionLevel(Value: TZCompressionLevel);
    function  GetCompressionLevel(): TZCompressionLevel;

    procedure SetupDefaultFileExtnAndFilter();

    procedure EnableDisableControls();
  public
    property DlgType: TBackupRestoreDlgType read FDlgType write FDlgType;

    procedure ProgressCallback(progress: int64; var cancel: boolean);

  end;


implementation

{$R *.dfm}

uses
  SDUGeneral,
  SDUDialogs,
{$WARNINGS OFF}  // Useless warning about platform - don't care about it
  FileCtrl,
{$WARNINGS ON}
  AppGlobals;

procedure TfrmBackupRestore.FormShow(Sender: TObject);
begin
  Processing := FALSE;

  SDUClearPanel(pnlDrive);
  SDUClearPanel(pnlFile);
  SDUClearPanel(pnlButtons);

  pnlDrive.Align := alNone;
  pnlFile.Align  := alNone;

  if (DlgType = opBackup) then
    begin
    self.Caption := 'Backup';
    pbGo.Caption := 'Backup';

    lblDrive.Caption := 'Please select the drive to be backed up:';
    lblFile.Caption := 'Please specify where the backup is to be stored:';

    pnlDrive.Align := alTop;
    pnlFile.Align  := alClient;
    cbDrive.SetFocus();

    // Hide unused controls...
    ckDecompress.visible := FALSE;
    end
  else
    begin
    self.Caption := 'Restore';
    pbGo.Caption := 'Restore';

    lblFile.Caption := 'Please specify the location of the backup to be restored:';
    lblDrive.Caption := 'Please select the drive to be restored:';

    pnlFile.Align  := alTop;
    pnlDrive.Align := alClient;
    SDUFilenameEdit1.SetFocus();

    // Yes, this is right - use cbCompressionLevel.top
    ckDecompress.left := SDUFilenameEdit1.left;
    ckDecompress.top := cbCompressionLevel.top;
    // Hide unused controls...
    lblCompression.visible := FALSE;
    cbCompressionLevel.visible := FALSE;
    end;

  PopulateRemovableDrives(cbDrive);

  PopulateCompressionLevel();
  SetCompressionLevel(zcNone);

  SDUFilenameEdit1.Filter := FILE_FILTER_FLT_IMAGES;
  SetupDefaultFileExtnAndFilter();
  if (DlgType = opBackup) then
    begin
    SDUFilenameEdit1.FilenameEditType := fetSave;
    end
  else
    begin
    SDUFilenameEdit1.FilenameEditType := fetOpen;
    end;

end;

procedure TfrmBackupRestore.pbCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBackupRestore.pbGoClick(Sender: TObject);
var
  allOK: boolean;
  locationSrc: string;
  locationDest: string;
  errMsg: string;
  size: ULONGLONG;
  driveItem: string;
  drive: char;
  driveDevice: string;
  prevCursor: TCursor;
  confirmMsg: string;
  opType: string;
  gzFilename: string;
begin
  allOK := TRUE;

  size := 0;

  if (cbDrive.ItemIndex < 0) then
    begin
    if (DlgType = opBackup) then
      begin
      errMsg := 'Please specify which drive is to be backed up.';
      end
    else
      begin
      errMsg := 'Please specify drive to restore.';
      end;

    SDUMessageDlg(errMsg, mtError, [mbOK], 0);

    allOK := FALSE;
    end;

  if (SDUFilenameEdit1.Filename = '') then
    begin
    if (DlgType = opBackup) then
      begin
      errMsg := 'Please specify where to store the backup.';
      end
    else
      begin
      errMsg := 'Please specify which backup to restore.';
      end;

    SDUMessageDlg(errMsg, mtError, [mbOK], 0);

    allOK := FALSE;
    end;

  if allOK then
    begin
    driveItem := cbDrive.Items[cbDrive.Itemindex];
    drive := driveItem[1];
    driveDevice := '\\.\'+drive+':';

    if (DlgType = opBackup) then
      begin
      locationSrc:= driveDevice;
      locationDest:= SDUFilenameEdit1.Filename;

      size := SDUGetPartitionSize(drive);

      confirmMsg:= 'Are you sure you wish to backup drive '+drive+': to:'+SDUCRLF+
                   SDUCRLF+
                   locationDest;
      end
    else
      begin
      locationSrc:= SDUFilenameEdit1.Filename;
      locationDest:= driveDevice;

      size := SDUGetFileSize(locationSrc);

      confirmMsg:= 'Are you sure you wish to restore '+SDUCRLF+
                   SDUCRLF+
                   locationSrc+SDUCRLF+
                   SDUCRLF+
                   'to drive '+drive+':?';
      end;

    end;

  if allOK then
    begin
    allOK := (SDUMessageDlg(confirmMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    end;

  if allOK then
    begin
    prevCursor := Screen.Cursor;
    Screen.Cursor := crAppStart;
    ProgressDlg := TSDUProgressDialog.Create(self);
    try
      Processing := TRUE;
      EnableDisableControls();

      ProgressDlg.i64Min := 0;
      ProgressDlg.i64Max := size;
      ProgressDlg.i64Position := 0;

      ProgressDlg.ShowTimeRemaining := TRUE;

      ProgressDlg.Show();

      if (GetCompressionLevel() = zcNone) then
        begin
        allOK := SDUCopyFile(
                    locationSrc,
                    locationDest,
                    0,
                    size, // -1,  // Do all of it
                    STD_BUFFER_SIZE,
                    ProgressCallback
                   );
        end
      else
        begin
        gzFilename := ExtractFilename(locationDest);
        if (gzFilename = '') then
          begin
          gzFilename := COMPRESSED_FILE;
          end;

        allOK := gzip_Compression(
                    locationSrc,
                    locationDest,
                    (DlgType = opBackup),
                    GetCompressionLevel(),
                    0,
                    COMPRESSED_FILE,
                    size, // -1,  // Do all of it
                    STD_BUFFER_SIZE,
                    ProgressCallback
                   );
        end;

      if allOK then
        begin
        if (DlgType = opBackup) then
          begin
          opType := 'Backup';
          end
        else
          begin
          opType := 'Restore';
          end;

        SDUMessageDlg(
                      opType+' completed successfully.',
                      mtInformation,
                      [mbOK],
                      0
                     );
                     
        ModalResult := mrOK;
        end;

    finally
      Processing := FALSE;
      EnableDisableControls();

      ProgressDlg.Free();

      Screen.Cursor := prevCursor;
    end;

    end;

end;

procedure TfrmBackupRestore.EnableDisableControls();
begin
  SDUEnableControl(cbDrive, not(Processing));
  SDUEnableControl(SDUFilenameEdit1, not(Processing));
  SDUEnableControl(pbGo, not(Processing));
  SDUEnableControl(pbCancel, not(Processing));

  SetupDefaultFileExtnAndFilter();

end;

procedure TfrmBackupRestore.ProgressCallback(progress: int64; var cancel: boolean);
begin
  ProgressDlg.i64Position := progress;
  Application.ProcessMessages();
  cancel := ProgressDlg.Cancel;
end;

procedure TfrmBackupRestore.PopulateCompressionLevel();
var
  i: TZCompressionLevel;
begin
  cbCompressionLevel.Items.Clear();
  for i:=low(i) to high(i) do
    begin
    cbCompressionLevel.Items.Add(GZLibCompressionLevelTitle(i));
    end;

end;

procedure TfrmBackupRestore.SetCompressionLevel(Value: TZCompressionLevel);
begin
  cbCompressionLevel.ItemIndex := cbCompressionLevel.Items.IndexOf(GZLibCompressionLevelTitle(Value));
  ckDecompress.checked := (Value <> zcNone);
end;

function TfrmBackupRestore.GetCompressionLevel(): TZCompressionLevel;
var
  i: TZCompressionLevel;
  retval: TZCompressionLevel;
begin
  // Default...
  retval := zcNone;

  for i:=low(i) to high(i) do
    begin
    if (cbCompressionLevel.Items[cbCompressionLevel.ItemIndex] = GZLibCompressionLevelTitle(i)) then
      begin
      retval := i;
      break;
      end;
    end;

  Result := retval;
end;

procedure TfrmBackupRestore.cbCompressionLevelChange(Sender: TObject);
begin
  if cbCompressionLevel.visible then
    begin
    if (SDUFilenameEdit1.Filename <> '') then
      begin
      if (GetCompressionLevel() = zcNone) then
        begin
        // Not compressed - remove any ".Z" extension
        if (ExtractFileExt(SDUFilenameEdit1.Filename) = DOT_EXTN_IMG_COMPRESSED) then
          begin
          SDUFilenameEdit1.Filename := ChangeFileExt(SDUFilenameEdit1.Filename, '');
          end;
        end
      else
        begin
        // Compressed - add ".Z" extension if not already present
        if (ExtractFileExt(SDUFilenameEdit1.Filename) <> DOT_EXTN_IMG_COMPRESSED) then
          begin
          SDUFilenameEdit1.Filename := SDUFilenameEdit1.Filename + DOT_EXTN_IMG_COMPRESSED;
          end;
        end;
      end;

    ckDecompress.checked := (GetCompressionLevel() <> zcNone);
    
    SetupDefaultFileExtnAndFilter();
    end;

end;

procedure TfrmBackupRestore.ckDecompressClick(Sender: TObject);
begin
  if ckDecompress.visible then
    begin
    // Set the combobox, so that GetCompressionLevel(...) can be used to
    // determine if decompression is needed or not
    if ckDecompress.Checked then
      begin
      SetCompressionLevel(zcDefault);
      end
    else
      begin
      SetCompressionLevel(zcNone);
      end;
    end;

end;

procedure TfrmBackupRestore.SDUFilenameEdit1Change(Sender: TObject);
begin
  if (
      (ExtractFileExt(SDUFilenameEdit1.Filename) = DOT_EXTN_IMG_COMPRESSED) and
      (GetCompressionLevel() = zcNone)
     ) then
    begin
    SetCompressionLevel(zcDefault);
    end
  else if (
      (ExtractFileExt(SDUFilenameEdit1.Filename) <> DOT_EXTN_IMG_COMPRESSED) and
      (GetCompressionLevel() <> zcNone)
     ) then
    begin
    SetCompressionLevel(zcNone);
    end;

end;

procedure TfrmBackupRestore.SetupDefaultFileExtnAndFilter();
begin
  if (GetCompressionLevel() = zcNone) then
    begin
    SDUFilenameEdit1.DefaultExt := EXTN_IMG_NORMAL;
    end
  else
    begin
    SDUFilenameEdit1.DefaultExt := EXTN_IMG_COMPRESSED;
    end;

  if (DlgType = opBackup) then
    begin
    if (GetCompressionLevel() = zcNone) then
      begin
      SDUFilenameEdit1.FilterIndex := FILE_FILTER_DFLT_IDX_UNCOMPRESSED;
      end
    else
      begin
      SDUFilenameEdit1.FilterIndex := FILE_FILTER_DFLT_IDX_COMPRESSED;
      end;

    end
  else
    begin
    SDUFilenameEdit1.FilterIndex := FILE_FILTER_DFLT_IDX_ALL;
    end;

end;


END.

