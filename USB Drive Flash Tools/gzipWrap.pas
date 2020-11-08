unit gzipWrap;

interface

uses
  SDUGeneral,
  zlibex, zlibexgz;

function gzip_Compression(
              source: string;
              destination: string;
              compressNotDecompress: boolean;
              compressionLevel: TZCompressionLevel = zcNone;
              startOffset: int64 = 0;  // Only valid when compressing
              compressedFilename: string = 'compressed.dat';  // Only valid when compressing
              length: int64 = -1;
              blocksize: int64 = 4096;
              callback: TCopyProgressCallback = nil
             ): boolean;

function GZLibCompressionLevelTitle(compressionLevel: TZCompressionLevel): string;

implementation

uses
  Windows, Classes, sysutils;


resourcestring
  ZCCOMPRESSLVL_NONE    = 'None';
  ZCCOMPRESSLVL_FASTEST = 'Fastest';
  ZCCOMPRESSLVL_DEFAULT = 'Default';
  ZCCOMPRESSLVL_MAX     = 'Max';
  ZCCOMPRESSLVL_LEVEL1  = 'Level1';
  ZCCOMPRESSLVL_LEVEL2  = 'Level2';
  ZCCOMPRESSLVL_LEVEL3  = 'Level3';
  ZCCOMPRESSLVL_LEVEL4  = 'Level4';
  ZCCOMPRESSLVL_LEVEL5  = 'Level5';
  ZCCOMPRESSLVL_LEVEL6  = 'Level6';
  ZCCOMPRESSLVL_LEVEL7  = 'Level7';
  ZCCOMPRESSLVL_LEVEL8  = 'Level8';
  ZCCOMPRESSLVL_LEVEL9  = 'Level9';

const
  GZLibCompressionLevelTitlePtr: array [TZCompressionLevel] of Pointer = (
                                  @ZCCOMPRESSLVL_NONE,
                                  @ZCCOMPRESSLVL_FASTEST,
                                  @ZCCOMPRESSLVL_DEFAULT,
                                  @ZCCOMPRESSLVL_MAX,
                                  @ZCCOMPRESSLVL_LEVEL1,
                                  @ZCCOMPRESSLVL_LEVEL2,
                                  @ZCCOMPRESSLVL_LEVEL3,
                                  @ZCCOMPRESSLVL_LEVEL4,
                                  @ZCCOMPRESSLVL_LEVEL5,
                                  @ZCCOMPRESSLVL_LEVEL6,
                                  @ZCCOMPRESSLVL_LEVEL7,
                                  @ZCCOMPRESSLVL_LEVEL8,
                                  @ZCCOMPRESSLVL_LEVEL9
                                 );

function GZLibCompressionLevelTitle(compressionLevel: TZCompressionLevel): string;
begin
  Result := LoadResString(GZLibCompressionLevelTitlePtr[compressionLevel]);
end;


// ----------------------------------------------------------------------------
// compressNotDecompress - Set to TRUE to compress, FALSE to decompress
// compressionLevel - Only used if compressNotDecompress is TRUE
// length - Set to -1 to copy until failure
function gzip_Compression(
              source: string;
              destination: string;
              compressNotDecompress: boolean;
              compressionLevel: TZCompressionLevel = zcNone;
              startOffset: int64 = 0;  // Only valid when compressing
              compressedFilename: string = 'compressed.dat';  // Only valid when compressing
              length: int64 = -1;
              blocksize: int64 = 4096;
              callback: TCopyProgressCallback = nil
             ): boolean;
var
  allOK: boolean;
  numberOfBytesRead, numberOfBytesWritten: DWORD;
  finished: boolean;
  copyCancelFlag: boolean;
  totalBytesCopied: int64;
  stmFileInput: TFileStream;
  stmFileOutput: TFileStream;
  stmInput: TStream;
  stmOutput: TStream;
  stmCompress: TGZCompressionStream;
  stmDecompress: TGZDecompressionStream;
  buffer: PChar;
begin
//  CompFileStream := TFileStream.Create(source, fmOpenRead);// OR fmShareDenyWrite);
//  FileStream := TFileStream.Create(destination, fmCreate);

  allOK := TRUE;
  copyCancelFlag := FALSE;

  stmCompress := nil;
  stmDecompress := nil;

  try
    stmFileInput := TFileStream.Create(source, fmOpenRead);
  except
    stmFileInput := nil;
  end;
  if (stmFileInput = nil) then
    begin
    raise EExceptionBadSrc.Create('Can''t open source');
    end;

  try
    try
      try
        // Try to create new...
        stmFileOutput := TFileStream.Create(destination, fmCreate);
      except
        // Fallback to trying to open existing for write...
        stmFileOutput := TFileStream.Create(destination, fmOpenWrite);
      end;
    except
      stmFileOutput := nil;
    end;
    if (stmFileOutput = nil) then
      begin
      raise EExceptionBadDest.Create('Can''t open destination');
      end;

    try
      if compressNotDecompress then
        begin
        stmCompress:= TGZCompressionStream.Create(stmFileOutput, compressionLevel);
//        stmCompress:= TGZCompressionStream.Create(stmFileOutput, 'myfile.txt', '', Now());

        stmInput:= stmFileInput;
        stmOutput:= stmCompress;

        if (length < 0) then
          begin
          length := stmFileInput.Size;
          end;

        stmInput.Position := startOffset;
        end
      else
        begin
        stmDecompress:= TGZDecompressionStream.Create(stmFileInput);
        stmInput:= stmDecompress;
        stmOutput:= stmFileOutput;

//        length := stmDecompress.Size;
//        length := 0;
//        stmDecompress.Position := 0;
        blocksize := 4096;  // Decompressing requires a blocksize of 4096?!
        end;

      totalBytesCopied := 0;
      if assigned(callback) then
        begin
        callback(totalBytesCopied, copyCancelFlag);
        end;


      buffer := AllocMem(blocksize);
      try
        finished := FALSE;
        while not(finished) do
          begin
          if compressNotDecompress then
            begin
            numberOfBytesRead := stmInput.Read(buffer^, blocksize);
            end
          else
            begin
            numberOfBytesRead := stmDecompress.Read(buffer^, blocksize);
            end;

          // If we read was successful, and we read some bytes, we haven't
          // finished yet... 
          finished := (numberOfBytesRead <= 0);

          if (numberOfBytesRead>0) then
            begin
            // If we've got a limit to the number of bytes we should copy...
            if (length >= 0) then
              begin
              if ((totalBytesCopied+numberOfBytesRead) > length) then
                begin
                numberOfBytesRead := length - totalBytesCopied;
                end;
              end;

            numberOfBytesWritten := stmOutput.Write(buffer^, numberOfBytesRead);

            if (numberOfBytesRead <> numberOfBytesWritten) then
              begin
              raise EExceptionWriteError.Create('Unable to write data to output');
              end;

            totalBytesCopied := totalBytesCopied + numberOfBytesWritten;
            if assigned(callback) then
              begin
              callback(totalBytesCopied, copyCancelFlag);
              end;

            if (
                (length >= 0) and
                (totalBytesCopied >= length)
               ) then
              begin
              finished := TRUE;
              end;

            // Check for user cancel
            if copyCancelFlag then
              begin
              raise EExceptionUserCancel.Create('User cancelled operation.');
              end;

            end;
          end;
          
      finally
        FreeMem(buffer);
      end;

    finally
      if (
          compressNotDecompress and
          (stmCompress <> nil)
         ) then
        begin
        stmCompress.Free();
        end;
      stmFileOutput.Free();
    end;

  finally
    if (
        not(compressNotDecompress) and
        (stmDecompress <> nil)
       ) then
      begin
      stmDecompress.Free();
      end;
    stmFileInput.Free();
  end;


  Result := allOK;
end;

END.

