unit About_U;
// Description: About Dialog
// By Sarah Dean
// Email: sdean12@sdean12.org
// WWW:   http://www.FreeOTFE.org/
//
// -----------------------------------------------------------------------------
//


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  SDUStdCtrls, ComCtrls;

type
  TAbout_F = class(TForm)
    pbOK: TButton;
    imIcon: TImage;
    lblAppID: TLabel;
    lblTitle: TLabel;
    lblBeta: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SDUURLLabel1: TSDUURLLabel;
    reBlub: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

procedure ShowAboutDialog();

implementation

{$R *.DFM}

uses
  ShellApi,  // Needed for ShellExecute
  SDUGeneral,
  AppGlobals;

procedure ShowAboutDialog();
var
  dlg: TAbout_F;
begin
  dlg:= TAbout_F.Create(nil);
  try
    dlg.ShowModal();
  finally
    dlg.Free();
  end;
end;

procedure TAbout_F.FormShow(Sender: TObject);
var
  majorVersion   : integer;
  minorVersion   : integer;
  revisionVersion: integer;
  buildVersion   : integer;
begin
  SDUGetVersionInfo('', majorVersion, minorVersion, revisionVersion, buildVersion);
  lblAppID.caption := 'v'+SDUGetVersionInfoString('');
  if APP_BETA_BUILD>-1 then
    begin
    lblAppID.caption := lblAppID.caption + ' BETA '+inttostr(APP_BETA_BUILD);
    end;

  lblBeta.visible := (APP_BETA_BUILD>-1);


  Panel1.caption := '';
  Panel2.caption := '';

end;

procedure TAbout_F.FormCreate(Sender: TObject);
begin
  self.Caption := 'About '+Application.Title;
  lblTitle.caption := Application.Title;
  imIcon.picture.graphic := Application.Icon;

  reBlub.Plaintext := TRUE;
  reBlub.readonly := TRUE;
  reBlub.scrollbars := ssNone;
  reBlub.Color := self.Color;
  reBlub.BorderStyle := bsNone;
  reBlub.Enabled := FALSE;

  reBlub.Lines.Text := 'USB Flash Tools is a straightforward application that is intended for use with '+
                       'flash cards/USB drives, allowing them to be backed up/restored with ease.';

end;

END.


