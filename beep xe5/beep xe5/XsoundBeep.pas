unit XsoundBeep;

interface
uses
     StdCtrls, Graphics ,Classes, SysUtils,
     forms , Windows,  Messages ,uToneGenerator,uSoundTypes;

   procedure SoundBeep;
var
  itone: TToneGenerator;

implementation
procedure SoundBeep;

begin        //(8000,11025,22050,44100);
  itone.Frequency:=strToInt('2000');
  itone.Duration:=strToInt('500');
  itone.Volume:=TVolumeLevel(100);
  itone.SampleRate:=TSampleRate(3);
  itone.Channel:=chStereo;
  itone.Generate;
  itone.Play;
end;
initialization

 itone := TToneGenerator.Create;
finalization

  itone.Free;

end.
