unit CopyWrap;

interface

type
  TCopyWrap = class
  public
    procedure Copy();
  end;

implementation

uses
  Controls,
  Forms,
  SDUGeneral;


procedure TCopyWrap.Copy();
var
  prevCursor: TCursor;
begin
    prevCursor := Screen.Cursor;
    Screen.Cursor := crAppStart;
    try
      Processing := TRUE;
      EnableDisableControls();

      SDUCopyFile(
                  locationSrc,
                  locationDest,
                  0,
                  -1,  // Do all of it
                  STD_BUFFER_SIZE,
                  nil
                 );

    finally
      Processing := FALSE;
      EnableDisableControls();

      Screen.Cursor := prevCursor;
    end;

end;


END.

