unit form_AdvancedCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin64, frame_Location, ComCtrls, zlibex;

type
  Tfrm_AdvancedCopy = class(TForm)
    pcMain: TPageControl;
    tsSource: TTabSheet;
    Label2: TLabel;
    tsDestination: TTabSheet;
    Label6: TLabel;
    tsOptions: TTabSheet;
    Label1: TLabel;
    Label7: TLabel;
    lblLimitBytes: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    se64StartOffset: TSpinEdit64;
    ckLimitCopy: TCheckBox;
    se64MaxBytesToCopy: TSpinEdit64;
    seBlockSize: TSpinEdit64;
    lblProgress: TLabel;
    Label4: TLabel;
    pbCopy: TButton;
    pbCancel: TButton;
    fmeLocationSrc: Tfme_Location;
    fmeLocationDest: Tfme_Location;
    pbClose: TButton;
    tsCompression: TTabSheet;
    rbNoCompression: TRadioButton;
    rbDecompress: TRadioButton;
    rbCompress: TRadioButton;
    cbCompressionLevel: TComboBox;
    lblCompression: TLabel;
    procedure pbCloseClick(Sender: TObject);
    procedure pbAboutClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure ckLimitCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbCopyClick(Sender: TObject);
    procedure rbSelectCompression(Sender: TObject);
  private
    Processing: boolean;
    CancelFlag: boolean;

    procedure EnableDisableControls();

    procedure PopulateCompressionLevel();
    procedure SetCompressionLevel(Value: TZCompressionLevel);
    function  GetCompressionLevel(): TZCompressionLevel;
    
    procedure ProgressCallback(progress: int64; var cancel: boolean);

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  SDUGeneral,
  SDUDialogs,
  SDUFilenameEdit_U,
  gzipWrap,
  AppGlobals,
  About_U;

const
  SECTOR_SIZE = 512;


procedure Tfrm_AdvancedCopy.ckLimitCopyClick(Sender: TObject);
begin
  EnableDisableControls();

end;

procedure Tfrm_AdvancedCopy.FormShow(Sender: TObject);
begin
  lblProgress.Caption := 'n/a';

  pcMain.activepage := tsSource;

  pbCancel.Enabled := FALSE;

  fmeLocationSrc.SaveLocation := fetOpen;
  fmeLocationDest.SaveLocation := fetSave;

  fmeLocationSrc.Initialize();
  fmeLocationDest.Initialize();

  PopulateCompressionLevel();
  rbNoCompression.checked := TRUE;
  SetCompressionLevel(zcDefault);

  EnableDisableControls();

end;

procedure Tfrm_AdvancedCopy.pbAboutClick(Sender: TObject);
begin
  ShowAboutDialog();
end;

procedure Tfrm_AdvancedCopy.pbCancelClick(Sender: TObject);
begin
  CancelFlag := TRUE;

end;

procedure Tfrm_AdvancedCopy.pbCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure Tfrm_AdvancedCopy.pbCopyClick(Sender: TObject);
var
  allOK: boolean;
  length: int64;
  prevCursor: TCursor;
  locationSrc, locationDest: string;
  gzFilename: string;
begin
  allOK := TRUE;
  CancelFlag := FALSE;

  locationSrc:= fmeLocationSrc.GetLocation();
  locationDest:= fmeLocationDest.GetLocation();

  if allOK then
    begin
    if (locationSrc = '') then
      begin
      SDUMessageDlg(
                 'Please specify where you wish to copy data from',
                 mtError,
                 [mbOK],
                 0
                );
      allOK := FALSE;
      end;
    end;

  if allOK then
    begin
    if (locationDest = '') then
      begin
      SDUMessageDlg(
                 'Please specify where you wish to copy data to',
                 mtError,
                 [mbOK],
                 0
                );
      allOK := FALSE;
      end;
    end;

  if allOK then
    begin
    if (locationSrc = locationDest) then
      begin
      SDUMessageDlg(
                 'Source location cannot be the same as the destination',
                 mtError,
                 [mbOK],
                 0
                );
      allOK := FALSE;
      end;
    end;

  if allOK then
    begin
    allOK := (SDUMessageDlg(
                   'About to copy FROM:'+SDUCRLF+
                   SDUCRLF+
                   locationSrc+SDUCRLF+
                   SDUCRLF+
                   'TO:'+SDUCRLF+
                   SDUCRLF+
                   locationDest+SDUCRLF+
                   SDUCRLF+
                   'Do you wish to proceed?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    end;

  if allOK then
    begin
    allOK := (SDUMessageDlg(
                   'WARNING:'+SDUCRLF+
                   SDUCRLF+
                   'THIS WILL OVERWRITE:'+SDUCRLF+
                   SDUCRLF+
                   locationDest+SDUCRLF+
                   SDUCRLF+
                   'Are you sure you wish to proceed?',
                   mtWarning, [mbYes, mbNo], 0) = mrYes);
    end;

  if allOK then
    begin
    length := -1;
    if (ckLimitCopy.checked) then
      begin
      length := se64MaxBytesToCopy.Value;
      end;


    prevCursor := Screen.Cursor;
    Screen.Cursor := crAppStart;
    try
      Processing := TRUE;
      EnableDisableControls();

      if rbNoCompression.checked then
        begin
        SDUCopyFile(
             locationSrc,
             locationDest,
             se64StartOffset.value,
             length,
             seBlockSize.value,
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

        gzip_Compression(
                    locationSrc,
                    locationDest,
                    rbCompress.checked,
                    GetCompressionLevel(),
                    se64StartOffset.value,
                    gzFilename,
                    length,
                    seBlockSize.value,
                    ProgressCallback
                   );
        end;

    finally
      Processing := FALSE;
      EnableDisableControls();

      Screen.Cursor := prevCursor;
    end;

    end;

end;

procedure Tfrm_AdvancedCopy.EnableDisableControls();
begin

  SDUEnableControl(pcMain, not(Processing));
  SDUEnableControl(pbCopy, not(Processing));

  SDUEnableControl(pbCancel, Processing);
  SDUEnableControl(pbClose, not(Processing));

  if not(Processing) then
    begin
    SDUEnableControl(se64MaxBytesToCopy, ckLimitCopy.checked);
    SDUEnableControl(lblLimitBytes, ckLimitCopy.checked);
    end;

  SDUEnableControl(cbCompressionLevel, rbCompress.checked);

end;


procedure Tfrm_AdvancedCopy.ProgressCallback(progress: int64; var cancel: boolean);
begin
  lblProgress.caption := inttostr(progress);
  Application.ProcessMessages();
  cancel := CancelFlag;
end;

procedure Tfrm_AdvancedCopy.PopulateCompressionLevel();
var
  i: TZCompressionLevel;
begin
  cbCompressionLevel.Items.Clear();
  for i:=low(i) to high(i) do
    begin
    // Skip - indicate no compression via radiobutton
    if (i = zcNone) then
      begin
      continue;
      end;

    cbCompressionLevel.Items.Add(GZLibCompressionLevelTitle(i));
    end;

end;

procedure Tfrm_AdvancedCopy.SetCompressionLevel(Value: TZCompressionLevel);
begin
  cbCompressionLevel.ItemIndex := cbCompressionLevel.Items.IndexOf(GZLibCompressionLevelTitle(Value));
end;

function Tfrm_AdvancedCopy.GetCompressionLevel(): TZCompressionLevel;
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

procedure Tfrm_AdvancedCopy.rbSelectCompression(Sender: TObject);
begin
  EnableDisableControls();

end;

END.

