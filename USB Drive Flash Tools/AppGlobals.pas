unit AppGlobals;

interface

uses
  StdCtrls;


const
  APP_BETA_BUILD = -1;

  STD_BUFFER_SIZE = 1024*1024*1;  // 1 MB


resourcestring
  EXTN_IMG_NORMAL     = 'img';
  EXTN_IMG_COMPRESSED = 'gz';
  DOT_EXTN_IMG_COMPRESSED = '.gz';

  // Open/Save file filters...
  FILE_FILTER_FLT_IMAGES  = 'All image files (*.img, *.gz)|*.img;*.gz|Uncompressed image files (*.img)|*.img|Compressed image files (*.gz)|*.gz|All files|*.*';


const
  FILE_FILTER_DFLT_IDX_ALL          = 1;
  FILE_FILTER_DFLT_IDX_UNCOMPRESSED = 2;
  FILE_FILTER_DFLT_IDX_COMPRESSED   = 3;

  // Default filename to be used for compressed file stored within .gz
  // Note: This is an arbitary filename
  COMPRESSED_FILE = 'image.img';

procedure PopulateRemovableDrives(cbDrive: TComboBox);

implementation


uses
{$WARNINGS OFF}  // Useless warning about platform - don't care about it
  FileCtrl,
{$WARNINGS ON}
  Windows,
  SDUGeneral;

procedure PopulateRemovableDrives(cbDrive: TComboBox);
var
  DriveType: TDriveType;
  drive: char;
  item: string;
  volTitle: string;
  partSize: ULONGLONG;
  strSize: string;
begin
  cbDrive.Items.Clear();

  // Skip "A" and "B"; typically floppy drives
  // Note: *Uppercase* letters
  for drive:='C' to 'Z' do
    begin
    DriveType := TDriveType(GetDriveType(PChar(drive + ':\')));

    if (
        (DriveType = dtFloppy) or
        (DriveType = dtUnknown)
       ) then
      begin
      item := drive+':';

      volTitle := SDUVolumeID(drive);
      partSize := SDUGetPartitionSize(drive);
      if (partSize >= 0) then
        begin
        strSize := SDUFormatUnits(
                                  partSize,
                                  ['bytes', 'KB', 'MB', 'GB', 'TB'],
                                  1024,
                                  0
                                 );
        item := item + ' ['+strSize+']';
        end;

      if (volTitle <> '') then
        begin
        item := item+' '+volTitle;
        end;

      cbDrive.Items.Add(item);
      end;

    end;

end;


END.

