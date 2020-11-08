unit uProgressTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TProgressCallback = procedure (InProgressOverall, InProgressCurrent: TProgressBar) of Object;

type
  TfrmProgressForm = class(TForm)
    Label1: TLabel;
    pbOverall: TProgressBar;
    Label2: TLabel;
    pbCurrent: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowProgress(InCallback: TProgressCallback);

implementation

{$R *.dfm}

procedure ShowProgress(InCallback: TProgressCallback);
var
  LWindowList: TTaskWindowList;
  LSaveFocusState: TFocusState;
  LProgressForm: TfrmProgressForm;
begin
  LProgressForm := TfrmProgressForm.Create(NIL);
  try
    LSaveFocusState := SaveFocusState;
    Screen.SaveFocusedList.Insert(0, Screen.FocusedForm);
    Application.ModalStarted;
    LWindowList := DisableTaskWindows(0);
    Screen.FocusedForm := LProgressForm;
    SendMessage(LProgressForm.Handle, CM_ACTIVATE, 0, 0);
    LProgressForm.Show;
    InCallback(LProgressForm.pbOverall, LProgressForm.pbCurrent);
    EnableTaskWindows(LWindowList);
    RestoreFocusState(LSaveFocusState);
  finally
    Application.ModalFinished;
    FreeAndNil(LProgressForm);
  end;
end;

end.
