unit uToneGenerator;

interface
uses classes,uSoundTypes;


type
  TBasicToneGenerator=class(TPersistent)
  private
    FStream:TMemoryStream;
    FDuration: integer;
    FSampleRate: TSampleRate;
    FVolume: TVolumeLevel;
    FChannel: TSoundChannel;
    procedure SetDuration(const Value: integer);
    procedure SetSampleRate(const Value: TSampleRate);
    procedure SetVolume(const Value: TVolumeLevel);
    procedure SetChannel(const Value: TSoundChannel);
  protected

  public
    constructor Create;virtual;
    destructor Destroy;override;
    procedure Generate;virtual;
    procedure Play;
    procedure PlaySync;
    procedure SaveToStream(Stream:TStream);
    procedure SaveToFile(const filename:string);
    procedure LoadFromStream(Stream:TStream);
    procedure LoadFromFile(const filename:string);
  published
    property SampleRate:TSampleRate read FSampleRate write SetSampleRate;
    property Duration:integer read FDuration write SetDuration;
    property Volume:TVolumeLevel read FVolume write SetVolume;
    property Channel:TSoundChannel read FChannel write SetChannel;
    property ToneStream:TMemoryStream read FStream;
  end;

  TToneGenerator=class(TBasicToneGenerator)
  private
    FFrequency: integer;
    procedure SetFrequency(const Value: integer);
  public
    constructor Create;override;
    procedure Generate;override;
  published
    property Frequency:integer read FFrequency write SetFrequency;
  end;

  TWhiteNoiseGenerator=class(TBasicToneGenerator)
  private
  public
    procedure Generate;override;
  published
  end;


{======================================
Menghasilkan tone dan menyimpannya ke stream
=======================================}
procedure GenerateToneToStream(Stream:TStream;
                     const Frequency{Hz},
                     Duration{mSec}: Integer;
                    const Volume: TVolumeLevel;
                    const nChannel:TSoundChannel;
                    const Sample_Rate:TSampleRate=sr44_1KHz);

{======================================
Menghasilkan noise dan menyimpannya ke stream
=======================================}
procedure GenerateNoiseToStream(Stream:TStream;
                    const Duration{mSec}: Integer;
                    const Volume: TVolumeLevel;
                    const nChannel:TSoundChannel;
                    const Sample_Rate:TSampleRate=sr44_1KHz);

implementation
uses Winapi.Windows,system.sysutils,winapi.MMSystem;



procedure GenerateToneToStream(Stream:TStream;
                     const Frequency{Hz},
                     Duration{mSec}: Integer;
                    const Volume: TVolumeLevel;
                    const nChannel:TSoundChannel;
                    const Sample_Rate:TSampleRate=sr44_1KHz);
var
  WaveFormatEx: TWaveFormatEx;
  i, sizeByte,TempInt, DataCount, RiffCount: integer;
  SoundValue: byte;
  // w=omega ( 2 * pi * frequency)
  //w_per_samplerate=w/samplerate
  w,w_per_samplerate: double;
  SampleRate:integer;
const
  RiffId: AnsiString = 'RIFF';
  WaveId: AnsiString = 'WAVE';
  FmtId: AnsiString = 'fmt ';
  DataId: AnsiString = 'data';
begin
  SampleRate:=GetSampleRate(Sample_Rate);
  if Frequency > (0.6 * SampleRate) then
    raise Exception.Create(Format('Sample rate %d terlalu sedikit untuk memainkan tone %dHz',
                                  [SampleRate, Frequency])
                           );

  with WaveFormatEx do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := GetNumChannels(nChannel);
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  {hitung panjang data sound dan panjang stream WAV yang harus dihasilkan}
  DataCount := (Duration * SampleRate) div 1000; // sound data
  TempInt := SizeOf(TWaveFormatEx);
  RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
               TempInt + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
  {tulis wave header}
  Stream.WriteBuffer(RiffId[1], 4); // 'RIFF'
  Stream.WriteBuffer(RiffCount, SizeOf(DWORD)); // file data size
  Stream.WriteBuffer(WaveId[1], Length(WaveId)); // 'WAVE'
  Stream.WriteBuffer(FmtId[1], Length(FmtId)); // 'fmt '
  Stream.WriteBuffer(TempInt, SizeOf(DWORD)); // TWaveFormat data size
  Stream.WriteBuffer(WaveFormatEx, TempInt); // WaveFormatEx record
  Stream.WriteBuffer(DataId[1], Length(DataId)); // 'data'
  Stream.WriteBuffer(DataCount, SizeOf(DWORD)); // sound data size
  sizeByte:=Sizeof(Byte);
  {hitung dan simpan tone signal ke stream}
  w := 2 * Pi * Frequency; // omega
  w_per_samplerate:=w/SampleRate;
  for i := 0 to DataCount - 1 do
  begin
    SoundValue := 127 + trunc(Volume * sin(i * w_per_SampleRate)); // wt = w * i / SampleRate
    Stream.WriteBuffer(SoundValue, SizeByte);
  end;
end;

{ TBasicToneGenerator }

constructor TBasicToneGenerator.Create;
begin
  FStream:=nil;
  FDuration:=1000;
  FSampleRate:=sr22_05KHz;
  FVolume:=127;
  FChannel:=chMono;
end;

destructor TBasicToneGenerator.Destroy;
begin
  FStream.Free;
  inherited;
end;

procedure TBasicToneGenerator.Generate;
begin
  if FStream=nil then
    FStream:=TMemoryStream.Create;
  FStream.Clear;
end;

procedure TBasicToneGenerator.LoadFromFile(const filename: string);
var afile:TFileStream;
begin
  afile:=TFileStream.Create(filename,fmOpenRead);
  try
    LoadFromStream(afile);
  finally
    afile.Free;
  end;
end;

procedure TBasicToneGenerator.LoadFromStream(Stream: TStream);
begin
  if FStream=nil then
    FStream:=TMemoryStream.Create;
  FStream.Clear;
  FStream.CopyFrom(Stream,0);
end;

procedure TBasicToneGenerator.Play;
begin
  if FStream.Size<>0 then
    PlaySound(FStream.Memory,0, SND_MEMORY or SND_ASYNC);
end;

procedure TBasicToneGenerator.PlaySync;
begin
  if FStream.Size<>0 then
    PlaySound(FStream.Memory,0, SND_MEMORY or SND_SYNC);
end;

procedure TBasicToneGenerator.SaveToFile(const filename: string);
var afile:TFileStream;
begin
  afile:=TFileStream.Create(filename,fmCreate);
  try
    SaveToStream(afile);
  finally
    afile.Free;
  end;
end;

procedure TBasicToneGenerator.SaveToStream(Stream: TStream);
begin
  Stream.Seek(0,soFromBeginning);
  Stream.CopyFrom(FStream,0);
end;


procedure TBasicToneGenerator.SetChannel(const Value: TSoundChannel);
begin
  FChannel := Value;
end;

procedure TBasicToneGenerator.SetDuration(const Value: integer);
begin
  FDuration := Value;
end;


procedure TBasicToneGenerator.SetSampleRate(const Value: TSampleRate);
begin
  FSampleRate := Value;
end;

procedure TBasicToneGenerator.SetVolume(const Value: TVolumeLevel);
begin
  FVolume := Value;
end;

{TToneGenerator}

constructor TToneGenerator.Create;
begin
  inherited Create;
  FFrequency:=1000;
end;

procedure TToneGenerator.Generate;
begin
  inherited;
  GenerateToneToStream(FStream,
                       FFrequency,
                       FDuration,
                       FVolume,
                       FChannel,
                       FSampleRate);
end;

procedure TToneGenerator.SetFrequency(const Value: integer);
begin
  FFrequency := Value;
end;

function random_negative(const value:double):double;
begin
  if random>0.5 then
    result:=-value
  else
    result:=value;
end;

procedure GenerateNoiseToStream(Stream:TStream;
                     const Duration{mSec}: Integer;
                    const Volume: TVolumeLevel;
                    const nChannel:TSoundChannel;
                    const Sample_Rate:TSampleRate=sr44_1KHz);
var
  WaveFormatEx: TWaveFormatEx;
  i, sizeByte,TempInt, DataCount, RiffCount: integer;
  SoundValue: byte;
  SampleRate:integer;
const
  RiffId: AnsiString = 'RIFF';
  WaveId: AnsiString = 'WAVE';
  FmtId: AnsiString = 'fmt ';
  DataId: AnsiString = 'data';
begin
  SampleRate:=GetSampleRate(Sample_Rate);

  with WaveFormatEx do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := GetNumChannels(nChannel);
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  {hitung panjang data sound dan panjang stream WAV yang harus dihasilkan}
  DataCount := (Duration * SampleRate) div 1000; // sound data
  TempInt := SizeOf(TWaveFormatEx);
  RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
               TempInt + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
  {tulis wave header}
  Stream.WriteBuffer(RiffId[1], 4); // 'RIFF'
  Stream.WriteBuffer(RiffCount, SizeOf(DWORD)); // file data size
  Stream.WriteBuffer(WaveId[1], Length(WaveId)); // 'WAVE'
  Stream.WriteBuffer(FmtId[1], Length(FmtId)); // 'fmt '
  Stream.WriteBuffer(TempInt, SizeOf(DWORD)); // TWaveFormat data size
  Stream.WriteBuffer(WaveFormatEx, TempInt); // WaveFormatEx record
  Stream.WriteBuffer(DataId[1], Length(DataId)); // 'data'
  Stream.WriteBuffer(DataCount, SizeOf(DWORD)); // sound data size
  sizeByte:=Sizeof(Byte);

  {hitung dan simpan tone signal ke stream}
  for i := 0 to DataCount - 1 do
  begin
    SoundValue := 127 + trunc(Volume * random_negative(random));
    Stream.WriteBuffer(SoundValue, SizeByte);
  end;
end;

{ TWhiteNoiseGenerator }

procedure TWhiteNoiseGenerator.Generate;
begin
  inherited;
  GenerateNoiseToStream(FStream,
                        FDuration,
                        FVolume,
                        FChannel,
                        FSampleRate);
end;


initialization
randomize;
end.

