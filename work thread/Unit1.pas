unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, u_workthread, SyncObjs;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    Worker : TWorkThread;
    procedure ShowData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.ShowData;
begin
 // do whatever you need to do here...
 // show current time in memo
 Memo1.Lines.Add(FormatDateTime('HH:NN:SS', Now) + '  Prosesing');
 Worker.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // create our worker thread and start it
 Worker := TWorkThread.Create(10, ShowData);
 Worker.Resume;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 // signal our worker thread that we are done here
 Worker.ThreadEvent.SetEvent;
 // terminate and wait
 Worker.Terminate;
 Worker.WaitFor;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Worker := TWorkThread.Create(10, ShowData);
 Worker.Terminate;
end;

end.
