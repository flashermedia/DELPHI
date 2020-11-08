unit uSoundTypes;

interface

type

  TVolumeLevel = 0..127;
  TSampleRate=(sr8KHz,sr11_025KHz,sr22_05KHz,sr44_1KHz);
  TSoundChannel=(chMono,chStereo);
  TBitsPerSample=(bps8Bit,bps16Bit,bps32Bit);

function GetSampleRate(SampleRate:TSampleRate):integer;
function GetEnumSampleRate(SampleRate:integer):TSampleRate;

function GetNumChannels(ch:TSoundChannel):word;
function GetSoundChannels(nChannel:word):TSoundChannel;

function GetBitsPerSample(bits:TBitsPerSample):word;
function GetEnumBitsPerSample(bits:word):TBitsPerSample;

implementation


const SampleRates:array[sr8KHz..sr44_1KHz] of integer=
       (8000,11025,22050,44100);

     Channels:array[chMono..chStereo] of word=
     (1,2);
     BitsPerSample:array[bps8Bit..bps32Bit] of word=
     (8,16,32);

function GetSampleRate(SampleRate:TSampleRate):integer;
begin
  result:=SampleRates[SampleRate];
end;

function GetEnumSampleRate(SampleRate:integer):TSampleRate;
begin
  result:=sr8KHz;
  case sampleRate of
    8000:result:=sr8KHz;
    11025:result:=sr11_025KHz;
    22050:result:=sr22_05KHz;
    44100:result:=sr44_1KHz;
  end;
end;

function GetNumChannels(ch:TSoundChannel):word;
begin
  result:=Channels[ch];
end;

function GetSoundChannels(nChannel:word):TSoundChannel;
begin
  result:=chMono;
  case nChannel of
    1:result:=chMono;
    2:result:=chStereo;
  end;
end;

function GetBitsPerSample(bits:TBitsPerSample):word;
begin
  result:=BitsPerSample[bits];
end;

function GetEnumBitsPerSample(bits:word):TBitsPerSample;
begin
  result:=bps8Bit;
  case bits of
    8:result:=bps8Bit;
    16:result:=bps16Bit;
    32:result:=bps32Bit;
  end;
end;

end.
