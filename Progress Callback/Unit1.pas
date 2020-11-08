unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    procedure ProgressCallback(InProgressOverall, InProgressCurrent: TProgressBar);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  uProgressTemplate;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowProgress(Self.ProgressCallback);
end;

procedure TForm1.ProgressCallback(InProgressOverall,
  InProgressCurrent: TProgressBar);
var
  Index: Integer;
  kIndex: Integer;
begin
  MessageDlg('Press OK to start a long task...', mtInformation, [mbOK], 0);
  // 10 steps
  InProgressOverall.Max := 100;
  // 3000 updates per step
  InProgressCurrent.Max := 400000;
  for Index := 1 to InProgressOverall.Max do begin
    for kIndex := 1 to InProgressCurrent.Max do begin
      InProgressCurrent.Position := kIndex;
      // force application to process messages
      Application.ProcessMessages;
    end; // for kIndex := 1 to InProgressCurrent.Max do begin
    InProgressOverall.Position := Index;
    // force application to process messages
    Application.ProcessMessages;
  end; // for Index := 1 to InProgressOverall.Max do begin
  MessageDlg('Task completed!', mtInformation, [mbOK], 0);
end;

end.
