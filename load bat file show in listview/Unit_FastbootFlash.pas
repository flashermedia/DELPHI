unit Unit_FastbootFlash;

interface

uses
  extctrls, windows, sysutils, classes,   Forms,
  JvRichEdit,  sCheckBox,
  JvMenus, JvNavigationPane, unitportdetect, JvSpecialProgress, Controls,
  Graphics,
  ComCtrls, StrUtils, StdCtrls,
  FileCtrl, xmldom, XMLIntf, msxmldom, XMLDoc, Variants ;
type
  TFastbootFlash = class(TObject)
  private
    // MyThread: TMyHideThread;
  public
    procedure saveConfigFasboot(LViuw: TListView; SDirFIles ,  SFIles: String;      ChkSvConfig , ChkPresioning, ChkErase,ChkFlash: TsCheckBox );
    procedure readConfigFasboot(ListViuw: TListView; SDirFIles, SFIles: String;   Cmbbox: TComboBox);
    procedure SubItemsAddfastboot(ListViuw: TListView;  partition_sectors, filename, HEXFilesSIze, FilesSIze, Stat: String);

  end;


 var
  TTFastbootFlash : TFastbootFlash;
  StrList: tStringlist;
  StrList_master : tStringlist ;
  StrList_savebat  : tStringlist ;
     flsz4: string;
  flsz3: string;
  flsz2: string;
  flsz1, dirbat: string;
implementation


function BitToStr(AValue: Int64): String;
const
  K = Int64(1024);
  M = K * K;
  G = K * M;
  T = K * G;
begin
  if AValue < K then
    result := Format('%d b', [AValue])
  else if AValue < M then
    result := Format('%f KB', [AValue / K])
  else if AValue < G then
    result := Format('%f MB', [AValue / M])
  else if AValue < T then
    result := Format('%f GB', [AValue / G])
  else
    result := Format('%f TB', [AValue / T]);
  { if AValue > 1024 then BitToStr := IntToStr(AValue div 1024) + ' KB';
    if AValue > 1048576 then BitToStr := IntToStr(AValue div 1048576) + ' MB';
    if AValue > 1073741824 then BitToStr := IntToStr(AValue div 1073741824) + ' GB';
    if AValue > 1099511627776 then BitToStr := IntToStr(AValue div 1099511627776) + ' TB'; }
end;

function Explode(const str: string; const separator: string): TStrings;
var
  n: Integer;
  p, q, S: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    S := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, S);
      if q = nil then
        q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

function Explode2(const str: string; const separator: string): TStrings;
var
  n: Integer;
  p, q, S: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    S := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, S);
      if q = nil then
        q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

function Explode3(const str: string; const separator: string): TStrings;
var
  n: Integer;
  p, q, S: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    S := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, S);
      if q = nil then
        q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

function Explode4(const str: string; const separator: string): TStrings;
var
  n: Integer;
  p, q, S: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    S := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, S);
      if q = nil then
        q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

procedure TFastbootFlash.SubItemsAddfastboot(ListViuw: TListView;   partition_sectors, filename, HEXFilesSIze, FilesSIze, Stat: String);

begin
  with ListViuw.Items.Add do
  begin
    Caption := partition_sectors;
   // Checked := True;
    SubItems.Add(filename);
    SubItems.Add(HEXFilesSIze);
    SubItems.Add(FilesSIze);
    SubItems.Add(Stat);

   //// ChkListFastboot.Checked := True;
    //CheckAllFastboot := True;
  end;
  Screen.Cursor := crDefault;
end;


procedure TFastbootFlash.readConfigFasboot(ListViuw: TListView; SDirFIles, SFIles: String;   Cmbbox: TComboBox);
var
  i, ia, ib: Integer;
  List, List3, List2: TStrings;
begin
  ListViuw.Clear;
  StrList.Clear;
  StrList_master.Clear;
  StrList_savebat.Clear;
  StrList.LoadFromFile(SFIles);

  for i := 0 to StrList.Count - 1 do
  begin
    case Cmbbox.ItemIndex of
      0:        {XIOMI}
        begin
          if (pos('erase', StrList.Strings[i]) > 0) then
          begin
            List := Explode(StrList.Strings[i], ' ');
            if List.Count = 4 then
              SubItemsAddfastboot(ListViuw, List[3], 'None', 'None',
                'None', 'erase');
          end
          else if (pos('%~dp0\images\', StrList.Strings[i]) > 0) then
          begin
            List := Explode(StrList.Strings[i], '\images\');
            List2 := Explode2(List[1], ' ');
            List3 := Explode(List[0], ' ');
         //   flsz4 := BitToStr(FileSize(DirBat + 'images\' + List2[0]));
           // flsz2 := '0x' + inttohex(FileSize(DirBat + 'images\' + List2[0]),               1) + '00';
            SubItemsAddfastboot(ListViuw, List3[List3.Count - 2], List2[0],
              flsz2, flsz4, List3[List3.Count - 3]);
          end
          else if (pos('%~dp0images\', StrList.Strings[i]) > 0) then
          begin
            List := Explode(StrList.Strings[i], '\');
            List2 := Explode2(List[1], ' ');
            List3 := Explode(List[0], ' ');

            flsz1 := StringReplace(List3[List3.Count - 1], '%~dp0', '',               [rfReplaceAll]);
          ////  flsz4 := BitToStr(FileSize(DirBat + flsz1 + '\' + List2[0]));
           // flsz2 := '0x' + inttohex(FileSize(DirBat + flsz1 + '\' + List2[0]               ), 1) + '00';
            SubItemsAddfastboot(ListViuw, List3[List3.Count - 2], List2[0],
              flsz2, flsz4, List3[List3.Count - 3]);
          end;
        end;
      1:      {ASUS}
        begin

          if (pos('%xfstkflashtool_path%', StrList.Strings[i]) > 0) then
          begin
               List := Explode(StrList.Strings[i], ' %cd%\');
               ia := List.Count -1;
               for ib := 1 to ia do begin

                 if (pos('dnx_fwr', List[ib]) > 0) or (pos('fwr', List[ib]) > 0) then
                 SubItemsAddfastboot(ListViuw, 'FW DnX', List[ib],   '-', '-',  'Flash');
                 if (pos('ifwi', List[ib]) > 0) then
                 SubItemsAddfastboot(ListViuw, 'IFWI', List[ib],   '-', '-',  'Flash');
                 if (pos('dnx_osr', List[ib]) > 0) or  (pos('osr', List[ib]) > 0) then
                 SubItemsAddfastboot(ListViuw, 'OS DnX', List[ib],   '-', '-',  'Flash');
                 if (pos('droidboot', List[ib]) > 0) or  (pos('fastboot', List[ib]) > 0) then begin
                 List2 := Explode(List[ib], ' ');
                 SubItemsAddfastboot(ListViuw, 'OS Image', List2[0],   '-', '-',  'Flash');
                 end;
                 if (pos('fuse', List[ib]) > 0) then
                 SubItemsAddfastboot(ListViuw, 'SoftFuse', List[ib],   '-', '-',  'Flash');
               end;
          end ;
          if (pos('%fastboot_path%', StrList.Strings[i]) <> 0) then  StrList_master.Append(StrList.Strings[i]);
          if (pos('%fastboot_path%', StrList.Strings[i]) > 0) then
          begin

           if (pos('erase', StrList.Strings[i]) > 0) then begin
               List := Explode(StrList.Strings[i], 'erase');
              SubItemsAddfastboot(ListViuw,'#'+ List[1],   List[1],   '-', '-',  'erase');
           end;
           if (pos('flash /tmp/', StrList.Strings[i]) > 0) then
           else
           if (pos('flash', StrList.Strings[i]) > 0) then
            if (pos('\', StrList.Strings[i]) > 0) or (pos('/', StrList.Strings[i]) > 0) then begin

              List := Explode(StrList.Strings[i], ' ');
              if (pos('\', List[3]) > 0) then begin
                List2 := Explode2(List[3], '\')  ;
                ia := List2.Count -1;
              end;
              SubItemsAddfastboot(ListViuw, List[2], List2[ia],   'BYTE', 'SIZE', List[1]);
            end;
          end;
        end;
    end;
  end;

end;

procedure TFastbootFlash.saveConfigFasboot(LViuw: TListView; SDirFIles ,  SFIles: String;
 ChkSvConfig , ChkPresioning, ChkErase,ChkFlash: TsCheckBox );
var
  i,J,  Ia, ib , ic  : Integer;  Srcdel, Srcdel2 , backup_config : string;
begin
    StrList_savebat.Clear;
    StrList_savebat. Append('set fastboot_path="%PROGRAMFILES%\Intel\Phone Flash Tool\fastboot.exe"');

 if ChkSvConfig.Checked = True then   {backup config}
    StrList_savebat.Append('%fastboot_path% oem backup_config');

 if ChkPresioning.Checked = True then begin     {partitioning}
    StrList_savebat.Append('%fastboot_path% oem start_partitioning');
    StrList_savebat.Append('%fastboot_path% flash /tmp/partition.tbl %cd%\partition.tbl');
    StrList_savebat.Append('%fastboot_path% oem partition /tmp/partition.tbl');
    StrList_savebat.Append('%fastboot_path% oem backup_config');
   if ChkErase.Checked = false then  {Erase image}   StrList_savebat.Append('%fastboot_path% oem stop_partitioning');
 end;

  For i := 0 to Lviuw.Items.Count - 1 do
  begin
    if  (Lviuw.Items[i].SubItems[3] = 'erase' ) and
     ( Lviuw.Items[I].Checked = true) then
    begin
      Srcdel := Lviuw.Items[I].SubItems[0];
      For iB := 0 to StrList_master.Count - 1 do   begin
        if ( pos(Srcdel, StrList_master.Strings[ib])> 0) and  ( pos('erase',  StrList_master.Strings[ib])> 0) then begin
          StrList_savebat.Append( StrList_master.Strings[ib]);

        end;
      end;
    end;
  end;
 if ChkPresioning.Checked = True then begin     {partitioning}
   if ChkErase.Checked = true then  {Erase image}   StrList_savebat.Append('%fastboot_path% oem stop_partitioning');
 end;
 For j := 0 to Lviuw.Items.Count - 1 do
  begin
     if  Lviuw.Items[j].SubItems[3] = 'flash' then
    if Lviuw.Items[j].Checked = true then
    begin
      Srcdel := Lviuw.Items[j].SubItems[0];
      For ic := 0 to  StrList_master.Count - 1 do   begin
        if (pos(Srcdel,  StrList_master.Strings[ic])> 0) and  ( pos('flash',  StrList_master.Strings[ic])> 0) then begin

          StrList_savebat.Append( StrList_master.Strings[ic]);

        end;
      end;
    end;
  end;
   StrList_savebat.SaveToFile(GetCurrentDir+ '\sample.bat');
end;


 initialization
 TTFastbootFlash := TFastbootFlash.Create;
StrList := tStringlist.Create;
StrList_master := tStringlist.Create;
StrList_savebat  := tStringlist.Create;

finalization
StrList.Free;
StrList_master.Free;
StrList_savebat.Free;
end.

