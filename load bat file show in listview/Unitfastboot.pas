unit Unitfastboot;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, scStyledForm, Unit_FastbootFlash,
  sCheckBox;

type
  TForm1 = class(TForm)
    Button1: TButton;
    lv4: TListView;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    blurrr: TscStyledForm;
    Button2: TButton;
    Edit1: TEdit;
    chk_FlashImage: TsCheckBox;
    chkEraseImage: TsCheckBox;
    chk_partitioning: TsCheckBox;
    chk_backupasus: TsCheckBox;
    rb_DebrickSocIntel: TRadioButton;
    rb_FlashFastboot: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lv4Click(Sender: TObject);
    procedure chk_FlashImageClick(Sender: TObject);
    procedure chkEraseImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;
   ListViuw: TListView;

   DirFiles,FileNamebat : string;

implementation

{$R *.dfm}


procedure TForm1.Button2Click(Sender: TObject);   //  scStyledForm1.ShowClientInActiveEffect;
begin

  TTFastbootFlash.saveConfigFasboot(lv4   {listviuw}, DirFiles {string} ,  FileNamebat {string},
  chk_backupasus {Chckbox}, chk_partitioning{Chckbox}, chkEraseImage{Chckbox},chk_FlashImage {Chckbox});
end;

procedure TForm1.lv4Click(Sender: TObject);
var
  i: Integer;
begin

end;


procedure TForm1.chk_FlashImageClick(Sender: TObject);
var
 i : Integer;
begin
   For i := 0 to lv4.Items.Count -1 do begin
     if chk_FlashImage.Checked = True then begin
      if  Lv4.Items[i].SubItems[3] = 'flash' then
      begin
         Lv4.Items[i].Checked := True;
      end;
     end else begin
      if  Lv4.Items[i].SubItems[3] = 'flash' then
      begin
         Lv4.Items[i].Checked := FALSE;
      end;
     end;
   end;
end;

procedure TForm1.chkEraseImageClick(Sender: TObject);
var
 i : Integer;
begin
   For i := 0 to lv4.Items.Count -1 do begin
     if chkEraseImage.Checked = True then begin
      if  Lv4.Items[i].SubItems[3] = 'erase' then
      begin
         Lv4.Items[i].Checked := True;
      end;
     end else begin
      if  Lv4.Items[i].SubItems[3] = 'erase' then
      begin
         Lv4.Items[i].Checked := FALSE;
      end;
     end;
   end;
end;



procedure TForm1.Button1Click(Sender: TObject);
begin

     blurrr.ShowClientInActiveEffect;
   if OpenDialog1.Execute  then begin
     DirFiles :=  ExtractFilePath(opendialog1.FileName);
     FileNamebat :=   opendialog1.FileName;
     lv4.Clear;
     TTFastbootFlash.readConfigFasboot(lv4,  DirFiles,  opendialog1.FileName,   ComboBox1);

   end;
   Sleep(200);
    blurrr.hideClientInActiveEffect;
end;

end.


