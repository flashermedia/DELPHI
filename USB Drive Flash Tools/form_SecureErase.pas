unit form_SecureErase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Shredder, Spin64;

type
  TfrmSecureErase = class(TForm)
    rbEntireDrive: TRadioButton;
    rbFreeSpace: TRadioButton;
    cbOverwriteMethod: TComboBox;
    Label1: TLabel;
    pbOverwrite: TButton;
    pbClose: TButton;
    cbDrive: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ckUnusedStorage: TCheckBox;
    ckFileSlack: TCheckBox;
    Shredder1: TShredder;
    Label5: TLabel;
    sePasses: TSpinEdit64;
    procedure SettingChanged(Sender: TObject);
    procedure pbOverwriteClick(Sender: TObject);
    procedure pbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SetOverwriteMethod(useMethod: TShredMethod);
    function  GetOverwriteMethod(): TShredMethod;
    procedure EnableDisableControls();
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  AppGlobals,
  SDUGeneral,
  SDUDialogs;

procedure TfrmSecureErase.FormShow(Sender: TObject);
var
  sm: TShredMethod;
begin
  PopulateRemovableDrives(cbDrive);

  ckUnusedStorage.checked := TRUE;
  ckFileSlack.checked := TRUE;

  cbOverwriteMethod.Items.Clear();
  for sm := low(TShredMethodTitle) to high(TShredMethodTitle) do
    begin
    cbOverwriteMethod.Items.Add(ShredMethodTitle(sm));
    end;

  SetOVerwriteMethod(smPseudoRandom);

  sePasses.Value := 1;
  sePasses.MinValue := 1;
  sePasses.MaxValue := 9999;

  EnableDisableControls();
end;

procedure TfrmSecureErase.pbCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmSecureErase.SetOverwriteMethod(useMethod: TShredMethod);
var
  i: integer;
begin
  for i := 0 to (cbOverwriteMethod.items.Count - 1) do
    begin
    if (cbOverwriteMethod.items[i] = ShredMethodTitle(useMethod)) then
      begin
      cbOverwriteMethod.itemindex := i;
      break;
      end;
    end;

end;

function TfrmSecureErase.GetOverwriteMethod(): TShredMethod;
var
  sm: TShredMethod;
  retval: TShredMethod;
begin
  retval := smPseudorandom;

  for sm := low(TShredMethodTitle) to high(TShredMethodTitle) do
    begin
    if (cbOverwriteMethod.items[cbOverwriteMethod.itemindex] = ShredMethodTitle(sm)) then
      begin
      retval := sm;
      break;
      end;
    end;

  Result := retval;
end;

procedure TfrmSecureErase.pbOverwriteClick(Sender: TObject);
var
  allOK: boolean;
  driveItem: string;
  drive: char;
  driveDevice: string;
  overwriteFailure: boolean;
  userCancel: boolean;
  overwriteResult: TShredResult;
  failAdvice: string;
begin
  allOK := TRUE;
  overwriteFailure:= FALSE;
  userCancel := FALSE;
  drive := '@';  // Get rid of compiler warning

  // Check user's input...
  if allOK then
    begin
    if (cbDrive.ItemIndex < 0) then
      begin
      SDUMessageDlg(
                    'Please select which drive you wish to overwrite.',
                    mtError,
                    [mbOK],
                    0
                   );
      allOK := FALSE;
      end;
    end;

  // Check user's input...
  if allOK then
    begin
    if (
        not(rbEntireDrive.checked) and
        not(rbFreeSpace.checked)
       ) then
      begin
      SDUMessageDlg(
                    'Please specify whether you wish to destroy the entire contents of the drive selected, or just it''s unused storage.',
                    mtError,
                    [mbOK],
                    0
                   );
      allOK := FALSE;
      end;
    end;

  // Check user's input...
  if allOK then
    begin
    if (
        rbFreeSpace.checked and
        not(ckUnusedStorage.checked) and
        not(ckFileSlack.checked)
       ) then
      begin
      SDUMessageDlg(
                    'Please select which unused areas of the drive you would like to overwrite from the checkboxes shown',
                    mtError,
                    [mbOK],
                    0
                   );
      allOK := FALSE;
      end;
    end;

  // Check user's input...
  if allOK then
    begin
    if (sePasses.Value <= 0) then
      begin
      SDUMessageDlg(
                    'Please specify a number of passes greater than zero.',
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
    driveDevice := '\\.\'+drive+':';
    end;

  // Check user's input...
  if allOK then
    begin
    if rbEntireDrive.checked then
      begin
      allOK := (SDUMessageDlg(
                              'WARNING:'+SDUCRLF+
                              SDUCRLF+
                              'The option you have selected will DESTROY all data on the drive '+drive+':'+SDUCRLF+
                              SDUCRLF+
                              'Are you sure you wish to proceed?',
                              mtWarning,
                              [mbYes, mbNo],
                              0
                             ) = mrYes);
      end;
    end;

  if allOK then
    begin
    Shredder1.IntMethod := GetOverwriteMethod();
    Shredder1.IntPasses := sePasses.Value;

    if rbEntireDrive.checked then
      begin
      allOK := Shredder1.DestroyDevice(driveDevice, FALSE, FALSE);
      end
    else
      begin
      if allOK then
        begin
        if ckUnusedStorage.checked then
          begin
          overwriteResult := Shredder1.OverwriteDriveFreeSpace(drive, FALSE);
          if (overwriteResult = srError) then
            begin
            overwriteFailure := TRUE;
            allOK := FALSE;
            end
          else if (overwriteResult = srUserCancel) then
            begin
            userCancel := TRUE;
            allOK := FALSE;
            end;

          end;
        end;

      if allOK then
        begin
        if ckFileSlack.checked then
          begin
          overwriteResult := Shredder1.OverwriteAllFileSlacks(drive, FALSE);
          if (overwriteResult = srError) then
            begin
            overwriteFailure := TRUE;
            allOK := FALSE;
            end
          else if (overwriteResult = srUserCancel) then
            begin
            userCancel := TRUE;
            allOK := FALSE;
            end;
          end;
        end;
      end;
    end;


  if allOK then
    begin
    SDUMessageDlg('Overwrite complete.', mtInformation, [mbOK], 0);
    end
  else
    begin
    if userCancel then
      begin
      SDUMessageDlg('Operation canceled.', mtInformation, [mbOK], 0);
      end
    else if overwriteFailure then
      begin
      if rbEntireDrive.checked then
        begin
        failAdvice := 'Please ensure that no files are open on this drive, or applications using it';
        end
      else
        begin
        failAdvice := 'Please ensure this drive is formatted.';
        end;

      SDUMessageDlg(
                    'Unable to complete overwrite.'+SDUCRLF+
                    SDUCRLF+
                    failAdvice,
                    mtWarning,
                    [mbOK],
                    0
                   );
      end;

    end;


end;


procedure TfrmSecureErase.SettingChanged(Sender: TObject);
begin
  EnableDisableControls();
end;

procedure TfrmSecureErase.EnableDisableControls();
var
  userEnterPasses: boolean;
begin
  SDUEnableControl(ckUnusedStorage, rbFreeSpace.checked);
  SDUEnableControl(ckFileSlack, rbFreeSpace.checked);

  userEnterPasses := (TShredMethodPasses[GetOverwriteMethod()] <= 0);

  SDUEnableControl(sePasses, userEnterPasses);
  if not(userEnterPasses) then
    begin
    sePasses.Value := TShredMethodPasses[GetOverwriteMethod()];
    end;

end;

END.

