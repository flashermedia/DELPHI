unit frame_Location;

interface

uses
{$WARNINGS OFF}  // Useless warning about platform - don't care about it
  FileCtrl,
{$WARNINGS ON}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SDUFrames, SDUFilenameEdit_U;

type
  Tfme_Location = class(TFrame)
    rbDrive: TRadioButton;
    dcbDrive: TDriveComboBox;
    rbDevice: TRadioButton;
    edDevice: TEdit;
    rbFile: TRadioButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SDUFilenameEdit1: TSDUFilenameEdit;
    procedure rbLocationTypeClick(Sender: TObject);
    procedure dcbDriveChange(Sender: TObject);
    procedure edDeviceChange(Sender: TObject);
    procedure SDUFilenameEdit1Change(Sender: TObject);
  private
    function  GetSaveLocation(): TSDUFilenamEditType;
    procedure SetSaveLocation(typ: TSDUFilenamEditType);
  public
    procedure Initialize();
    function  GetLocation(): string;
    procedure EnableDisableControls();
  published
    property SaveLocation: TSDUFilenamEditType read GetSaveLocation write SetSaveLocation;
  end;

implementation

{$R *.dfm}

uses
  SDUGeneral,
  AppGlobals;

function Tfme_Location.GetLocation(): string;
var
  retVal: string;
begin
  retVal:= '';

  if (rbDrive.checked) then
    begin
    retVal := '\\.\'+dcbDrive.Drive+':';
    end
  else if (rbDevice.checked) then
    begin
    retVal := edDevice.Text;
    end
  else if (rbFile.checked) then
    begin
    retVal := SDUFilenameEdit1.Filename;
    end;

  Result := retVal;
end;

procedure Tfme_Location.rbLocationTypeClick(Sender: TObject);
begin
  EnableDisableControls();

end;

procedure Tfme_Location.dcbDriveChange(Sender: TObject);
begin
  rbDrive.Checked := TRUE;
end;

procedure Tfme_Location.edDeviceChange(Sender: TObject);
begin
  rbDevice.Checked := TRUE;
end;

procedure Tfme_Location.SDUFilenameEdit1Change(Sender: TObject);
begin
  rbFile.Checked := TRUE;
end;

procedure Tfme_Location.EnableDisableControls();
begin
  SDUFilenameEdit1.Filter := FILE_FILTER_FLT_IMAGES;
  SDUFilenameEdit1.DefaultExt := EXTN_IMG_NORMAL;

  SDUEnableControl(dcbDrive, rbDrive.checked);
  SDUEnableControl(edDevice, rbDevice.checked);
  SDUEnableControl(SDUFilenameEdit1, rbFile.checked);

end;

function Tfme_Location.GetSaveLocation(): TSDUFilenamEditType;
begin
  Result := SDUFilenameEdit1.FilenameEditType;
end;

procedure Tfme_Location.SetSaveLocation(typ: TSDUFilenamEditType);
begin
  SDUFilenameEdit1.FilenameEditType := typ;
end;

procedure Tfme_Location.Initialize();
begin
  // Unselect a drive...
  dcbDrive.ItemIndex := -1;

  // Unselect source/destination
  rbDrive.checked := FALSE;
  rbDevice.checked := FALSE;
  rbFile.checked := FALSE;

  EnableDisableControls();
end;


END.

