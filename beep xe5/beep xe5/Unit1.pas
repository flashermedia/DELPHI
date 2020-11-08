unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls ,ComCtrls,uSoundTypes,uToneGenerator, sTrackBar,
  ExtCtrls ;
  type
  TVolumeLevel = 0..127;
type
  TForm1 = class(TForm)
    Button1: TButton;
    btnSave: TButton;
    edtFrequency: TEdit;
    edtDuration: TEdit;
    strckbr1: TsTrackBar;
    cbbSampleRate: TComboBox;
    rgChannel: TRadioGroup;
    rb1: TRadioButton;
    rb2: TRadioButton;
    dlgSave1: TSaveDialog;
    lbl1: TLabel;
    lbl2: TLabel;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    tone:TToneGenerator;
    { Private declarations }
  public
  //  constructor Create(AOwner:TComponent);override;
  //  destructor destroy;override;
    { Public declarations }
    procedure MakeSound(Frequency{Hz}, Duration{mSec}: Integer; Volume: TVolumeLevel);
  end;


var
  Form1: TForm1;

implementation
 uses winapi.MMSystem;

{$R *.dfm}
procedure TForm1.MakeSound(Frequency{Hz}, Duration{mSec}: Integer; Volume: TVolumeLevel);
  {writes tone to memory and plays it}
var
  WaveFormatEx: TWaveFormatEx;
  MS: TMemoryStream;
  i, TempInt, DataCount, RiffCount: integer;
  SoundValue: byte;
  w: double; // omega ( 2 * pi * frequency)
const
  Mono: Word = $0001;
  SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100
  RiffId: AnsiString = 'RIFF';
  WaveId: AnsiString = 'WAVE';
  FmtId: AnsiString = 'fmt ';
  DataId: AnsiString = 'data';
begin
  if Frequency > (0.6 * SampleRate) then
  begin
    ShowMessage(Format('Sample rate of %d is too Low to play a tone of %dHz',
      [SampleRate, Frequency]));
    Exit;
  end;
  with WaveFormatEx do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Mono;
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  MS := TMemoryStream.Create;
  with MS do
  begin
    {Calculate length of sound data and of file data}
    DataCount := (Duration * SampleRate) div 1000; // sound data
    RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
      SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
    {write out the wave header}
    Write(RiffId[1], 4); // 'RIFF'
    Write(RiffCount, SizeOf(DWORD)); // file data size
    Write(WaveId[1], Length(WaveId)); // 'WAVE'
    Write(FmtId[1], Length(FmtId)); // 'fmt '
    TempInt := SizeOf(TWaveFormatEx);
    Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
    Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
    Write(DataId[1], Length(DataId)); // 'data'
    Write(DataCount, SizeOf(DWORD)); // sound data size
    {calculate and write out the tone signal} // now the data values
    w := 2 * Pi * Frequency; // omega
    for i := 0 to DataCount - 1 do
    begin
      SoundValue := 127 + trunc(Volume * sin(i * w / SampleRate)); // wt = w * i / SampleRate
      Write(SoundValue, SizeOf(Byte));
    end;
    {now play the sound}
    Sleep(100);
    sndPlaySound(MS.Memory, SND_MEMORY or SND_SYNC);
    MS.Free;
  end;
end;
procedure TForm1.btn1Click(Sender: TObject);
begin
  MakeSound(1200, 1000, 100);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  tone.Frequency:=strToInt(edtFrequency.Text);
  tone.Duration:=strToInt(edtDuration.Text);
  tone.Volume:=TVolumeLevel(strckbr1.Position);
  tone.SampleRate:=TSampleRate(cbbSampleRate.ItemIndex);
  if rgChannel.ItemIndex=0 then
    tone.Channel:=chMono
  else
    tone.Channel:=chStereo;

  tone.Generate;
  tone.Play;
  btnSave.Enabled:=true;
end;


procedure TForm1.btnSaveClick(Sender: TObject);
begin
if dlgSave1.Execute then
    tone.SaveToFile(dlgSave1.Filename);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 tone.Free;
  inherited;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  inherited;
  tone:=TToneGenerator.Create;
  btnSave.Enabled:=false;
end;

end.
