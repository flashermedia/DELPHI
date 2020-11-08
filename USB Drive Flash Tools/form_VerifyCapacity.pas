unit form_VerifyCapacity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

const
  RETAIL_1_KB = 1000;
  RETAIL_1_MB = (RETAIL_1_KB * 1000);
  RETAIL_1_GB = (RETAIL_1_MB * 1000);
  
  SIZE_1_KB = 1024;
  SIZE_1_MB = (SIZE_1_KB * 1024);
  SIZE_1_GB = (SIZE_1_MB * 1024);


type
  TVerifyBlock = array of byte;

  TfrmVerifyCapacity = class(TForm)
    pbClose: TButton;
    pbVerify: TButton;
    Label2: TLabel;
    cbDrive: TComboBox;
    reReport: TRichEdit;
    ckQuickCheck: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    pbSave: TButton;
    SaveDialog1: TSaveDialog;
    Label4: TLabel;
    Label5: TLabel;
    procedure pbSaveClick(Sender: TObject);
    procedure pbVerifyClick(Sender: TObject);
    procedure pbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function TimerStart(): TDateTime;
    function TimerStop(startTime: TDateTime): string;

    procedure Verify(drive: char);
    function ReadWriteBulkData(
                              driveDevice: string; 
                              opWriting: boolean; 
                              blockSize: integer;  
                              expectedSize: int64
                            ): int64;
    
    procedure GetVerifyDataBlock(blockNumber: integer; var outputBlock: TVerifyBlock);

    function HumanSize(bytes: int64): string;
    function RetailSize(capacity: int64): string;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  AppGlobals,
  SDUGeneral,
  SDUDialogs,
  SDUProgressDlg;

procedure TfrmVerifyCapacity.FormShow(Sender: TObject);
begin
  PopulateRemovableDrives(cbDrive);
  ckQuickCheck.checked := TRUE;

  SDUEnableControl(pbSave, FALSE);

  reReport.lines.clear();
  reReport.ReadOnly := TRUE;
  reReport.PlainText := TRUE;
end;

procedure TfrmVerifyCapacity.pbCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmVerifyCapacity.pbSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
    reReport.Lines.SaveToFile(SaveDialog1.Filename);
    end;
    
end;

procedure TfrmVerifyCapacity.pbVerifyClick(Sender: TObject);
var
  allOK: boolean;
  driveItem: string;
  drive: char;
begin
  allOK := TRUE;

  // Get rid of compiler warnings
  driveItem := '';
  drive := #0;

  // Check user's input...
  if allOK then
    begin
    if (cbDrive.ItemIndex < 0) then
      begin
      SDUMessageDlg(
                    'Please select which drive you wish to verify.',
                    mtError,
                    [mbOK],
                    0
                   );
      allOK := FALSE;
      end;
    end;

  if allOK then
    begin
    driveItem := cbDrive.Items[cbDrive.Itemindex];
    drive := driveItem[1];
    end;

  if allOK then
    begin
    allOK := (SDUMessageDlg(
                      'Verifying a drive''s capacity involves overwriting ALL data on it, and requiring it to be reformatted afterwards.'+SDUCRLF+
                      SDUCRLF+
                      'Do you wish to verify the capacity of drive '+drive+':?',
                      mtWarning,
                      [mbYes, mbNo],
                      0
                     ) = mrYes);
    end;


  if allOK then
    begin
    Verify(drive);
    end;

end;

function TfrmVerifyCapacity.HumanSize(bytes: int64): string;
begin
  Result := SDUFormatUnits(
                            bytes,
                            // Note: We don't include "GB" or "TB"; this
                            //       function rounds to nearest unit, and a 2GB
                            //       card with slightly less than that will
                            //       appear as 1GB if we include the "GB" units
                            ['bytes', 'KB', 'MB'],
                            1024,
                            0
                           );

end;

// Returns the number of bytes written to the partition
procedure TfrmVerifyCapacity.Verify(drive: char);
var
  expectedSize: int64;
  bytesWritten: int64;
  bytesRead: int64;
  driveDevice: string;
  possibleFake: boolean;
  opTime: TDateTime;
  totalTime: TDateTime;
  userCancel: boolean;
  failure: boolean;
  blockSize: integer;
  accurate: boolean;
  tmpStr: string;
  gotPartInfo: boolean;
  partInfo: TSDUPartitionInfo;
  gotDiskGeometry: boolean;
  diskGeometry: TSDUDiskGeometry;
  diskGeoCalc: int64;
begin
  driveDevice := '\\.\'+drive+':';
  possibleFake := FALSE;
  accurate := FALSE;

  // Get rid of compiler warning
  bytesRead := 0;

  totalTime := TimerStart();

  reReport.lines.Add('Verifying capacity of drive: '+drive+':');

  // Get the disk geometry...
  // (Not needed, but what the hell?)
  reReport.lines.Add('Determining disk geometry...');
  gotDiskGeometry := SDUGetDiskGeometry(drive, diskGeometry);
  if not(gotDiskGeometry) then
    begin
    // Not like we care exactly, but...
    reReport.lines.Add('+++ UNABLE TO DETERMINE DISK''S CAPACITY');
    end
  else
    begin
    reReport.lines.Add('Drive reports:');
    reReport.lines.Add('  Cylinders          : '+inttostr(diskGeometry.Cylinders.QuadPart));
    reReport.lines.Add('  Media type         : 0x'+inttohex(diskGeometry.MediaType, 2)+' ('+TSDUMediaTypeTitle[TSDUMediaType(diskGeometry.MediaType)]+')');
    reReport.lines.Add('  Tracks per cylinder: '+inttostr(diskGeometry.TracksPerCylinder));
    reReport.lines.Add('  Sectors per track  : '+inttostr(diskGeometry.SectorsPerTrack));
    reReport.lines.Add('  Bytes per sector   : '+inttostr(diskGeometry.BytesPerSector));

    diskGeoCalc := diskGeometry.Cylinders.QuadPart *
                   int64(diskGeometry.TracksPerCylinder) *
                   int64(diskGeometry.SectorsPerTrack) *
                   int64(diskGeometry.BytesPerSector);
    reReport.lines.Add('  Total bytes (cylinders * tracks * sectors * bps): '+inttostr(diskGeoCalc)+' ('+HumanSize(diskGeoCalc)+')');
    end;

  reReport.lines.Add('Determining partition information...');
  gotPartInfo := SDUGetPartitionInfo(drive, partInfo);
  expectedSize := partInfo.PartitionLength;
  if not(gotPartInfo) then
    begin
    reReport.lines.Add('+++ UNABLE TO DETERMINE PARTITION''S CAPACITY');
    expectedSize := 0;
    end
  else
    begin
    reReport.lines.Add('Drive reports:');
    reReport.lines.Add('  Starting offset     : '+SDUIntToStr(partInfo.StartingOffset));
    reReport.lines.Add('  Partition length    : '+SDUIntToStr(partInfo.PartitionLength)+' ('+HumanSize(partInfo.PartitionLength)+')');
    reReport.lines.Add('  Hidden sectors      : '+SDUIntToStr(partInfo.HiddenSectors));
    reReport.lines.Add('  Partition number    : '+SDUIntToStr(partInfo.PartitionNumber));
    reReport.lines.Add('  Partition type      : 0x'+inttohex(partInfo.PartitionType, 2));
    tmpStr := 'Inactive';
    if partInfo.BootIndicator then
      begin
      tmpStr := 'Active';
      end;
    reReport.lines.Add('  Boot indicator      : '+tmpStr);
    tmpStr := 'FALSE';
    if partInfo.RecognizedPartition then
      begin
      tmpStr := 'TRUE';
      end;
    reReport.lines.Add('  Recognized partition: '+tmpStr);
    tmpStr := 'FALSE';
    if partInfo.RewritePartition then
      begin
      tmpStr := 'TRUE';
      end;
    reReport.lines.Add('  Rewrite partition   : '+tmpStr);
    end;

    
  reReport.lines.Add('Verifying reported capacity...');
  reReport.lines.Add('Stage 1: Writing data...');
  opTime := TimerStart();
  blockSize := 512;
  if ckQuickCheck.checked then
    begin
    blockSize := SIZE_1_MB;
    end;

  bytesWritten := ReadWriteBulkData(driveDevice, TRUE, blockSize, expectedSize);
  userCancel := (bytesWritten = -2);
  failure := (bytesWritten <= 0);
  if (
      not(userCancel) and
      failure
     ) then
    begin
    reReport.lines.Add('+++ Unable to write data');
    end;
  if (bytesWritten >= 0) then
    begin
    reReport.lines.Add('Max bytes writable: '+inttostr(bytesWritten)+' ('+HumanSize(bytesWritten)+')');
    end;
  reReport.lines.Add('Time taken for stage 1: '+TimerStop(opTime));

  if (
      not(userCancel) and
      not(failure)
     ) then
    begin     
    reReport.lines.Add('Stage 2: Reading and verifying data...');
    opTime := TimerStart();
    bytesRead := ReadWriteBulkData(driveDevice, FALSE, blockSize, expectedSize);
    userCancel := (bytesWritten = -2);
    failure := (bytesWritten < 0);
    if (
        not(userCancel) and
        failure 
       ) then
      begin
      reReport.lines.Add('+++ Unable to read data');
      end;
    if (bytesRead >= 0) then
      begin
      reReport.lines.Add('Verified max bytes writable: '+inttostr(bytesRead)+' ('+HumanSize(bytesRead)+')');
      end;
    reReport.lines.Add('Time taken for stage 2: '+TimerStop(opTime));
    end;
         
  if (
      not(userCancel) and
      not(failure)
     ) then
    begin
    // Check read/write bytecounts...
    if (bytesWritten = bytesRead) then
      begin
      reReport.lines.Add('All data written could be read back correctly');
      end
    else if (bytesWritten > bytesRead) then
      begin
      // Bit dodgy... The device allowed us to write more data than we could
      // read back.
      // If it's within a 1MB boundry we'll let it slip...
      if (abs(bytesWritten - bytesRead) <= (blockSize * 2)) then
        begin
        reReport.lines.Add('Able to write more data to the drive than we could successfully read back. This sounds a bit dodgy, though it''s not unheard of with some flash cards, and is less than twice the blocksize we''re using to test ('+inttostr(blockSize)+' bytes), so we''ll let it slip here...')
        end
      else
        begin
        // No - it's far enough out for it to be something else
        reReport.lines.Add('+++ POSSIBLE FAKE: Unable to read all data written to drive');
        possibleFake := TRUE;
        end;
      end
    else if (bytesWritten < bytesRead) then
      begin
      reReport.lines.Add('+++ POSSIBLE FAKE: Able to read more data than could be written?!');
      possibleFake := TRUE;
      end;

    if (bytesWritten = bytesRead) then
      begin
      if (bytesRead = expectedSize) then
        begin
        accurate := TRUE;
        reReport.lines.Add('Drive appears to be an authentic: '+HumanSize(expectedSize)+' drive');
        end
        // If the difference is less than a reasonable amount...
      else
        begin
        if not(gotPartInfo) then
          begin
          // Can't say anything about what was expected...
          end
        else if (abs(expectedSize - bytesRead) <= (SIZE_1_MB * 2)) then
          begin
          reReport.lines.Add('Drive can read/write slightly less than it reports, but within reasonable boundaries for a '+HumanSize(expectedSize)+' drive');
          end
        else
          begin
          reReport.lines.Add('+++ POSSIBLE FAKE: Drive reports itself as a '+HumanSize(expectedSize)+' drive, but is actually only a '+HumanSize(bytesRead)+' drive');
          possibleFake := TRUE;
          end;
        end;
      end;

    reReport.lines.Add('');
    reReport.lines.Add('Note: The *actual* capacity of the drive shown above may well be less than was claimed when it was sold to you as (e.g. a 64MB drive may be reported here as only having 61MB of storage.');
    reReport.lines.Add('This is "normal", and can be caused by several things:');
    reReport.lines.Add('1) Manufacturers pretending that there are 1,000,000 bytes to the MB instead of 1,048,576. This is pretty "normal" in the industry and done to make products sound better than they actually are');
    reReport.lines.Add('2) Slight errors of a few KB in the testing process due to only checking the partition area of the drive selected. The MBR (incl partition table) would probably add another 16K or so');
    if ckQuickCheck.checked then
      begin
      reReport.lines.Add('3) Opting to perform a quick check, as opposed to using this utility''s more thorough option. This can introduce an error of up to 1MB');
      end;

    // Summary...
    reReport.lines.Add('');
    reReport.lines.Add('');
    reReport.lines.Add('Summary');
    reReport.lines.Add('=======');
    reReport.lines.Add('');
    if possibleFake then
      begin
      reReport.lines.Add('THIS DRIVE IS MISREPORTING IT''S CAPACITY AND IS PROBABLY A FAKE CARD/USB DRIVE');
      end
    else
      begin
      if accurate then
        begin
        reReport.lines.Add('The capacity this drive reports itself as having is reasonably correct.');
        end
      else
        begin
        reReport.lines.Add('The capacity this drive reports itself as having is accurate.');
        end;
        
      end;
    reReport.lines.Add('');
    reReport.lines.Add('This device SHOULD have been sold to you as a '+RetailSize(bytesRead)+' device.');
      
    reReport.lines.Add('');
    reReport.lines.Add('Total time taken: '+TimerStop(totalTime));

    reReport.lines.Add('');
    reReport.lines.Add('');
    end;

  if userCancel then
    begin
    reReport.lines.Add('');
    reReport.lines.Add('Operation cancelled by user');
    SDUMessageDlg(
                  'Operation cancelled.',
                  mtInformation,
                  [mbOK],
                  0
                 );
    end
  else if failure then
    begin
    reReport.lines.Add('');
    reReport.lines.Add('Operation failed to complete');
    SDUMessageDlg(
                  'Operation failed to complete. '+SDUCRLF+
                  SDUCRLF+
                  'Please see analysis report for full results.',
                  mtInformation,
                  [mbOK],
                  0
                 );
    end
  else
    begin
    SDUMessageDlg(
                  'Operation complete. '+SDUCRLF+
                  SDUCRLF+
                  'Please see analysis report for full results.',
                  mtInformation,
                  [mbOK],
                  0
                 );
    end;
  
  SDUEnableControl(pbSave, TRUE);

end;


// Returns: -1 on error
//          -2 on user cancel
//          0 or +ve - the number of bytes which could be written to the volume
function TfrmVerifyCapacity.ReadWriteBulkData(
  driveDevice: string; 
  opWriting: boolean; 
  blockSize: integer;  
  expectedSize: int64
): int64;
var
  fileHandle : THandle;
  writeBytes: TVerifyBlock;
  readBytes: TVerifyBlock;
  bytesTransferred: DWORD;
  progressDlg: TSDUProgressDialog;
  zero: DWORD;
  retVal: int64;
  bytesToTransfer: DWORD;
  blockNumber: integer;
  finished: boolean;
  i: Integer;
begin
  retVal := 0;

  zero := 0;  // (Obviously!)

  SetLength(writeBytes, blockSize);
  SetLength(readBytes, blockSize);

  progressDlg:= TSDUProgressDialog.create(nil);
  try
    progressDlg.Show();

    fileHandle := CreateFile(PChar(driveDevice),
                             GENERIC_READ or GENERIC_WRITE,
                             0,
                             nil,
                             OPEN_EXISTING,
                             FILE_ATTRIBUTE_NORMAL or FILE_FLAG_WRITE_THROUGH,
                             0);
    if (fileHandle = INVALID_HANDLE_VALUE) then
      begin
      retVal := -1;
      end
    else
      begin
      try
        progressDlg.i64Min := 0;
        progressDlg.i64Max := expectedSize;
        progressDlg.i64Position := 0;
        if opWriting then
          begin
          progressDlg.Caption := 'Stage 1/2: Writing';
          end
        else
          begin
          progressDlg.Caption := 'Stage 2/2: Reading and verifying';
          end;
        progressDlg.ShowTimeRemaining := TRUE;

        blockNumber := 0;

        // Reset the file ptr
        SetFilePointer(fileHandle, 0, @zero, FILE_BEGIN);

        finished := FALSE;
        while (
               not(finished) and
               (retVal >= 0)
              ) do
          begin
          // Update progress bar...
          progressDlg.i64Position := retVal;

          // Has user cancelled?
          Application.ProcessMessages();
          if progressDlg.Cancel then
            begin
            retVal := -2;
            break;
            end;

          // Fill a block with random garbage
          GetVerifyDataBlock(blockNumber, writeBytes);

          bytesToTransfer := blockSize;
          bytesTransferred := 0;

          if opWriting then
            begin
            finished := not(WriteFile(
                                      fileHandle,
                                      writeBytes[0],
                                      bytesToTransfer,
                                      bytesTransferred,
                                      nil
                                     ));
            end
          else
            begin
            // Read in the block...
            finished := not(ReadFile(
                                     fileHandle,
                                     readBytes[0],
                                     bytesToTransfer,
                                     bytesTransferred,
                                     nil
                                    ));

            // If block read in OK, check it...
            if not(finished) then
              begin
              // (Checking...)
              for i := 0 to (bytesToTransfer - 1) do
                begin
                if (writeBytes[i] <> readBytes[i]) then
                  begin
                  // If there was a problem, update retval to reflect the
                  // last correct value read in
                  retVal := retval + int64(i);
                  break;
                  end;
                end;

              end;

            end;

          finished := finished or
                      (bytesTransferred <> bytesToTransfer);

          // Note: Cast to int64 to ensure no problems
          retval := retval + int64(bytesTransferred);
          inc(blockNumber);
          end;

          // Ensure that the buffer is flushed to disk (even through disk caching
          // software) [from Borland FAQ]
                FlushFileBuffers(fileHandle);

        finally
          FlushFileBuffers(fileHandle);
          CloseHandle(fileHandle);
        end;

      end;  // ELSE PART - if (fileHandle = INVALID_HANDLE_VALUE) then

  finally
    progressDlg.Free();
  end;

  Result := retVal;

end;


procedure TfrmVerifyCapacity.GetVerifyDataBlock(blockNumber: integer; var outputBlock: TVerifyBlock);
var
  i: integer;
  strBlock: string;
begin
  // Fill block with data
  for i:=low(outputBlock) to high(outputBlock) do
    begin
    outputBlock[i] := (i mod 256);
    end;

  // "Brand" the block with the decimal and hex representations of the block
  // number
  strBlock := Format('%d=%x#', [blockNumber, blockNumber]);
  for i:=low(outputBlock) to high(outputBlock) do
    begin
    outputBlock[i] := outputBlock[i] XOR 
                      ord(strBlock[ ((i mod length(strBlock)) + 1) ]);
    end;

end;

function TfrmVerifyCapacity.TimerStart(): TDateTime;
begin
  Result := now;
end;

function TfrmVerifyCapacity.TimerStop(startTime: TDateTime): string;
begin
  Result := TimeToStr(startTime - now);
end;


// Identify retail size of drive
function TfrmVerifyCapacity.RetailSize(capacity: int64): string;
const
  RETAIL_1_MB = 1000 * 1000;
var
  retval: string;
begin

  // We tack on 2MB to capacity in order to compensate for quick check
  // accuracy
  capacity := capacity + (int64(2) * SIZE_1_MB);
  
  // Minimum amounts for a device to be regarded as...
  if (capacity >= (int64(5) * RETAIL_1_GB)) then
    begin
    retval := '>4 GB';
    end
  else if (capacity >= (int64(4) * RETAIL_1_GB)) then
    begin
    retval := '4 GB';
    end
  else if (capacity >= (int64(2) * RETAIL_1_GB)) then
    begin
    retval := '2 GB';
    end
  else if (capacity >= (int64(1) * RETAIL_1_GB)) then
    begin
    retval := '1 GB';
    end
  else if (capacity >= (int64(512) * RETAIL_1_MB)) then
    begin
    retval := '512 MB';
    end
  else if (capacity >= (int64(256) * RETAIL_1_MB)) then
    begin
    retval := '256 MB';
    end
  else if (capacity >= (int64(128) * RETAIL_1_MB)) then
    begin
    retval := '128 MB';
    end
  else if (capacity >= (int64(64) * RETAIL_1_MB)) then
    begin
    retval := '64 MB';
    end
  else if (capacity >= (int64(32) * RETAIL_1_MB)) then
    begin
    retval := '32 MB';
    end
  else if (capacity >= (int64(16) * RETAIL_1_MB)) then
    begin
    retval := '16 MB';
    end
  else
    begin
    retval := '<16 MB';
    end;
    
  Result := retval;
end;

END.

