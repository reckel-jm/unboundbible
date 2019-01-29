unit UnitLib;

{$define debugmode}
{$ifdef unix} {$undef RussianEdition} {$endif}

interface

uses
  {$ifdef windows} Windows, Windirs, {$endif}
  {$ifdef debugmode and linux} LazLogger, {$endif}
  SysUtils, StrUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  { FileUtil depreciated } LazFileUtils, LazUtf8, LCLProc,
  ExtCtrls, ClipBrd, Process;

type
  TStringArray  = array of string;
  TIntegerArray = array of integer;

  TRange = record
    from : integer;
    till : integer;
  end;

const
  AppName = 'Unbound Bible';
  TitleDirectory = 'titles';
  LangDirectory = 'localization';
  VersionInfo = '3.0';

// string's functions

function IsNumeral(c: char): boolean;
function IsLetter(c: char): boolean;
function Prefix(ps, st: string): boolean;
function Suffix(ps, st: string): boolean;
function OneUpCase(st: string): string;
function DoubleQuotedStr(s: string): string;
function ToInt(s: string): integer;
function ToBoolean(s: string): boolean;
function ToStr(value: longint): string;
function CleanString(s: string): string;
function StringPos(subst: string; s: string): TIntegerArray;
procedure Replace(var s: string; const oldPattern, newPattern: String);
procedure DelDoubleSpace(var s: string);
procedure CutStr(var s: string; StartSt, EndSt: string);
function ListToArray(const List: TStringList): TStringArray;
function ListToString(const List: TStringArray): string;
function StringToList(ch: Char; s: string): TStringArray;
function XmlToList(s: string): TStringArray;
procedure RemoveTags(var s: string);

// сlipboard's function

{$ifdef windows} procedure StringToClipboard(Source: string); {$endif}

// file's functions

function ExtractOnlyName(s: string): string;
function DataPath: string;
function SharePath: string;
function DocumentsPath: string;
function ConfigFile: string;
function TempFileName: string;
function GetFileList(const Path, Mask: string) : TStringArray;
function GetDatabaseList: TStringArray;
procedure CreateDataDirectory;
procedure OpenFolder(path: string);
{$ifdef darwin} procedure PrintFile(FileName : string); {$endif}

// language functions

function GetDefaultLanguage: string;
function GetRightToLeft(language: string): boolean;
function Orthodox(language: string): boolean;

// system's functions

function WidthInPixels(s: string): integer;
procedure Output(s: string); overload;
procedure Output(n: integer); overload;

var
  DefaultFont: TFont;

const
  Slash = DirectorySeparator;

implementation

{$ifdef windows} uses RichMemoEx; {$endif} // Utf8ToRTF()

// string's functions

function IsNumeral(c: char): boolean;
begin
  Result := c in ['0'..'9'];
end;

function IsLetter(c: char): boolean;
begin
  Result := ord(c) > 64;  // A-65
end;

function Prefix(ps, st: string): boolean;
begin
  Result := Pos(ps, st) = 1;
end;

function Suffix(ps, st: string): boolean;
begin
  Result := Pos(ps, st) = Length(st) - Length(ps) + 1;
end;

function OneUpCase(st: string): string;
var
  st_up : string;
begin
  st_up := UpperCase(st);
  st[1] := st_up[1];
  Result := st;
end;

function DoubleQuotedStr(s: string): string;
begin
  Result := '"' + s + '"';
end;

function ToInt(s: string): integer;
var v, r : integer;
begin
  Val(s, v, r);
  if r=0 then Result := v else Result := 0;
end;

function ToBoolean(s: string): boolean;
var v : boolean;
begin
  Result := false;
  if TryStrToBool(s,v) then Result := v;
end;

function ToStr(value: longint): string;
begin
 System.Str(value, Result);
end;

function CleanString(s: string): string;
var i: integer;
begin
  for i:=1 to Length(s) do
    if not IsLetter(s[i]) and not IsNumeral(s[i]) then s[i] := ' ';
  Result := s;
end;

function StringPos(subst: string; s: string): TIntegerArray;
var
  i,k,n : integer;
begin
  SetLength(Result,Length(s));

  k := 0;
  n := Pos(subst,s);

  while n > 0 do
    begin
      Result[k] := n;
      Inc(k);
      for i:=n to n+Length(subst)-1 do s[i] := ' ';
      n := Pos(subst,s);
    end;

  SetLength(Result,k);
end;

procedure Replace(var s: string; const oldPattern, newPattern: string);
begin
  s := StringReplace(s, oldPattern, newPattern, [rfReplaceAll]);
end;

procedure DelDoubleSpace(var s: string);
begin
  s := DelSpace1(s);
end;

procedure CutStr(var s: string; StartSt, EndSt: string);
var
  x1,x2,len : integer;
begin
  while Pos(StartSt, s) > 0 do
    begin
      x1 := Pos(StartSt,s);
      x2 := Pos(  EndSt,s);
      if x2 < x1 then Exit;
      len := x2-x1+Length(EndSt);
      Delete(s, x1, len);
    end;
end;

function ListToArray(const List: TStringList): TStringArray;
var i : integer;
begin
  SetLength(Result, List.Count);
  for i:=0 to List.Count-1 do
    Result[i] := List[i];
end;

function ListToString(const List: TStringArray): string;
var s : string;
begin
  Result := '';
  for s in List do Result += s;
end;

function StringToList(ch: Char; s: string): TStringArray;
var
  Point : array of integer;
  i, len : integer;
  index : integer = 0;
  n : integer = 0;
begin
  SetLength(Result,Length(s)+2);
  SetLength(Point ,Length(s)+2);
  Point[0] := 0;

  for i:=1 to Length(s) do
    if s[i] = ch then
      begin
        Inc(n);
        Point[n] := i;
      end;

  Point[n+1] := Length(s)+1;

  for i:=0 to n do
    begin
      len := Point[i+1]-Point[i]-1;
      if len > 0 then
        begin
          Result[index] := Copy(s, Point[i]+1, len);
          Inc(index);
        end;
    end;

  SetLength(Result,index);
end;

function XmlToList(s: string): TStringArray;
var
  temp : string = '';
  i : integer = 0;
  c : char;
begin
  SetLength(Result,Length(s)+1);

  for c in s do
    begin
      if c = '<' then
        begin
          Result[i] := temp;
          inc(i);
          temp := '';
        end;

      temp := temp + c;

      if c = '>' then
        begin
          Result[i] := temp;
          inc(i);
          temp := '';
        end;
    end;

  if temp <> '' then
    begin
      Result[i] := temp;
      inc(i);
    end;

  SetLength(Result,i);
end;

procedure RemoveTags(var s: string);
var
  r : string = '';
  l : boolean = true;
  i : integer;
begin
  for i:=1 to Length(s) do
    begin
      if s[i]='<' then l := False;
      if s[i]='<' then r += ' ';
      if l then r += s[i];
      if s[i]='>' then l := True;
    end;
  s := Trim(DelSpace1(r));
end;

// сlipboard's function

{$ifdef windows}
procedure StreamToClipboard(Stream: TMemoryStream);
var
  Clipboard : TClipBoard;
     CF_RTF : Word;
begin
  Clipboard := TClipboard.Create ;
  CF_RTF := RegisterClipboardFormat('Rich Text Format');
  Clipboard.AddFormat(CF_RTF,Stream);
  Clipboard.Free ;
end;

procedure StringToClipboard(Source: string);
var
  Stream : TMemoryStream;
begin
  Source := Utf8ToRTF(Source) + LineEnding;
  Stream := TMemoryStream.Create;
  Stream.Seek(0,soFromBeginning);
  Stream.WriteBuffer(Pointer(Source)^, Length(Source));
  StreamToClipboard(Stream);
  Stream.Free;
end;
{$endif}

// file's functions

function ExtractOnlyName(s: string): string;
begin
  Result := ExtractFileName(ChangeFileExt(s,''));
end;

function DataPath: string;
begin
  Result := GetUserDir + AppName;
end;

function SharePath: string;
begin
  Result := Application.Location;
  {$ifdef linux}
    if Prefix('/usr',Result) then Result := '/usr/share/' + Application.Title + '/';
  {$endif}
end;

function DocumentsPath: string;
begin
  {$ifdef windows} Result := GetWindowsSpecialDir(CSIDL_PERSONAL); {$endif}
  {$ifdef unix} Result := GetUserDir + 'Documents'; {$endif}
end;

function ConfigFile: string;
begin
  Result := GetAppConfigDir(False) + 'config.ini';
end;

function TempFileName: string; // for printing
begin
  Result := GetTempDir + 'temp.rtf';
end;

function GetFileList(const Path, Mask: string): TStringArray;
var
  List : TStringList;
  SearchRec : TSearchRec;
  Res : integer;
  s : string;
begin
  List := TStringList.Create;
  Res  := SysUtils.FindFirst(Path + slash + Mask, faAnyFile, SearchRec);

  while Res=0 do
    begin
      s := Path + slash + SearchRec.Name;
      if (SearchRec.Attr and faDirectory) = 0 then List.Add(s);
      Res := FindNext(SearchRec);
    end;

  SysUtils.FindClose(SearchRec);
  Result := ListToArray(List);
  List.Free;
end;

function GetDatabaseList: TStringArray;
const
  ext : array [1..5] of string = ('.unbound','.bblx','.bbli','.mybible','.SQLite3');
var
  List : TStringArray;
  s, item : string;
  index : integer = 0;
begin
  List := GetFileList(DataPath, '*.*');
  SetLength(Result, Length(List));

  for item in List do
    for s in ext do
      if Suffix(s, item) then
        begin
          Result[index] := item;
          index += 1;
        end;

  SetLength(Result, index);
end;

procedure CreateDataDirectory;
begin
  if not DirectoryExists(DataPath) then ForceDirectories(DataPath);
end;

procedure OpenFolder(path : string);
begin
 with TProcess.Create(nil) do
  try
    {$ifdef windows} Executable := 'explorer'; {$endif}
    {$ifdef darwin } Executable := 'open ';    {$endif}
    {$ifdef linux  } Executable := 'xdg-open'; {$endif}
    Parameters.Add(path);
    Options := [poUsePipes];
    try
      Execute;
    except
      on EProcess do ShowMessage('Oops! Looks like it can''t be opened.');
    end;
  finally
    Free;
  end;
end;

{$ifdef darwin}
procedure PrintFile(filename : string);
begin
  with TProcess.Create(nil) do
  try
    CommandLine {%H-}:='lp "' + filename + '"';
    Options := [poUsePipes]; // poWaitOnExit
    try
      Execute;
    except
      on EProcess do ShowMessage('Oops! Looks like it can''t be printed.');
    end;
  finally
    Free;
  end;
end;
{$endif}

// language functions

function GetDefaultLanguage: string;
begin
  Result := 'english';

  {$ifdef windows}
  case Lo(GetUserDefaultLangID) of
    LANG_RUSSIAN   : Result := 'russian';
    LANG_SPANISH   : Result := 'spanish';
    LANG_ITALIAN   : Result := 'italian';
    LANG_FINNISH   : Result := 'finnish';
//  LANG_POLISH    : Result := 'polish';
//  LANG_FRENCH    : Result := 'french';
//  LANG_GERMAN    : Result := 'german';
    LANG_UKRAINIAN : Result := 'ukrainian';
  end;
  {$endif}

  {$ifdef unix}
    {$ifdef RussianEdition} Result := 'russian'; {$endif}
  {$endif}
end;

function GetRightToLeft(language: string): boolean;
begin
   Result := false;
   if Prefix('he' ,language) or
      Prefix('ara',language) or
      Prefix('fa' ,language) then Result := true;
end;

function Orthodox(language: string): boolean;
begin
   Result := false;
   if Prefix('ru'  ,language) or
      Prefix('uk'  ,language) or
      Prefix('bulg',language) then Result := true;
end;

// system's functions

function WidthInPixels(s: string): integer;
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Canvas.Font := DefaultFont;
    Result := Bitmap.Canvas.TextWidth(s);
  finally
    Bitmap.Free;
  end;
end;

procedure Output(s: string);
begin
  {$ifdef debugmode}
    {$ifdef windows} OutputDebugString(PChar(s)); {$endif}
    {$ifdef linux} DebugLn(s); {$endif}
  {$endif}
end;

procedure Output(n: integer);
begin
  Output(ToStr(n));
end;

initialization
  DefaultFont := TFont.Create;
  DefaultFont.Name := {$ifdef windows} 'Tahoma' {$else} 'default' {$endif};
  DefaultFont.Size := 12;

finalization
  DefaultFont.Free;

end.

