unit u_workthread;

interface

uses
  SysUtils,
  SyncObjs,
  Classes;

type
  TWorkProc = procedure of object;

  TWorkThread = class(TThread)
  private
    { Private declarations }
    Counter   : Integer;
    FTimeout  : Integer;
    FEventProc: TWorkProc;
    procedure DoWork;
  protected
    procedure Execute; override;
  public
    ThreadEvent : TEvent;
    constructor Create(TimeoutSeconds : Integer; EventProc: TWorkProc ); // timeout in seconds
    destructor Destroy; override;
  end;

implementation

procedure TWorkThread.DoWork;
begin
 // put your GUI blocking code in here. Make sure you never call GUI elements from this procedure
 //DoSomeLongCalculation();
end;

procedure TWorkThread.Execute;
begin
 Counter := 0;
 while not Terminated do
  begin
   if ThreadEvent.WaitFor(FTimeout) = wrTimeout then begin
     DoWork;
     // now inform our main Thread that we have data
     Synchronize(FEventProc);
    end
   else
    // ThreadEvent has been signaled, exit our loop
    Break;
  end;
end;

constructor TWorkThread.Create(TimeoutSeconds : Integer; EventProc: TWorkProc);
begin
 ThreadEvent := TEvent.Create(nil, True, False, '');
 // Convert to milliseconds
 FTimeout := TimeoutSeconds * 1000;
 FEventProc:= EventProc;
 // call inherited constructor with CreateSuspended as True
 inherited Create(True);
end;

destructor TWorkThread.Destroy;
begin
 ThreadEvent.Free;
 inherited;
end;


end.
 