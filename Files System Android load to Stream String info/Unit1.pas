unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, JvExStdCtrls, JvRichEdit;

type
  TForm1 = class(TForm)
    btn1: TBitBtn;
    dlgOpen1: TOpenDialog;
    lbl1: TLabel;
    chk1: TCheckBox;
    edt1: TJvRichEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FolderDir : String  ;
implementation

{$R *.dfm}
function StreamPos(Stream: TStream; Offset: int64; const Buffer; Length: int64;
CaseSensitive: boolean = TRUE): int64;
function _Compare(const s1, s2: string;
Index1, Index2, Len: integer): boolean;
var
     i : integer;
    begin
       i := 0;
     repeat
      result := s1[Index1 +i] = s2[Index2 +i];
       Inc(i);
      until (i >= Len) or not result;
    end;

var
  target, buf : string;
  buflen, red, n : integer;

begin
  result := -1;

  if Offset < 0 then
  Offset := 0;

  if (Length > 0) and (Length <= Stream.Size -Offset) then begin
    SetLength(target, Length);
    MoveMemory(@target[1], @Buffer, Length);

    if not CaseSensitive then
    target := AnsiLowerCase(target);
    if Length -1 > $7FFF then begin
    if Length -1 > $FFFF then
      buflen := Length +1
    else
      buflen := $FFFF;
    end else
    buflen := $7FFF;
    SetLength(buf, buflen);
    Stream.Position := Offset;
    red := Stream.Read(buf[1], buflen);
    while (red > Length -1) and (result < 0) do begin
      if red < buflen then
      SetLength(buf, red);
      if not CaseSensitive then
      buf := AnsiLowerCase(buf);
      n := Pos(target, buf);
      if n > 0 then begin
        result := Stream.Position -red +n -1;
      end else begin
        if red > Length then begin
          n := red -Length;
          repeat
           Inc(n);
           until (n > red) or
          ( (buf[n] = target[1]) and (buf[red] = target[red -n +1]) and
          _Compare(buf, target, n, 1, red -n +1 ));
         if (n <= red) and (buf[n] = target[1]) then
          Stream.Seek( -(red -n +1), soFromCurrent);
        end;
      end;  
      red := Stream.Read(buf[1], buflen);
    end;
  end;
end;


procedure TForm1.btn1Click(Sender: TObject);
var
fs : TFileStream;
fsX : TStream;
SS: TStringStream;
offset : int64;
s : string;
begin
 // fsx
 if dlgOpen1.Execute then begin
    lbl4.Caption := 'File Name: '+ ExtractFileName( dlgOpen1.FileName );
   // lbl5.Caption := 'File Name: '+ ExtractFileName( dlgOpen1.FileName );
    //.Caption := 'File Name: '+ ExtractFileName( dlgOpen1.FileName );
   edt1.Clear;
   s := '';
    fs := TFileStream.Create(dlgOpen1.FileName , fmOpenRead or fmShareDenyNone);
  try
    s := 'buildinfo.sh';
    offset := StreamPos(fs, 0, s[1], Length(s));
   // offset := StreamPos(fs, 0, s[1], Length(s), false);
    if offset > -1 then begin
      fs.Seek(offset +Length(s), soFromBeginning);
     if chk1.Checked then   SetLength(s, 15000) else   SetLength(s, fs.size);
      fs.Read( s[1], Length(s) );

    end;
    finally
      fs.Free;
    end;
    with TStringList.Create do
    try
     Add(s);
     SaveToFile(FolderDir+ 'buildinfo.txt');
      edt1.Lines.Add(s);
    finally
      Free;
    end;
  end;
  s := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

     edt1.Clear;
     FolderDir := ExtractFileDir(Application.ExeName)+ '\';
    // lbl1.Caption := FolderDir;
end;



end.
