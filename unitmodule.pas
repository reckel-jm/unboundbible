unit UnitModule;

  {$ifdef linux}
    {$define zeos}
  {$endif}

interface

uses
  Classes, SysUtils, Dialogs, Graphics, ClipBrd, LazUtf8, IniFiles, DB, SQLdb,
  {$ifdef zeos} ZConnection, ZDataset, ZDbcSqLite, {$else} SQLite3conn, {$endif}
  UnitLib;

type
  TFileFormat = (unbound, mysword, mybible);

  TModule = class
    {$ifdef zeos}
      Connection : TZConnection;
      Query : TZReadOnlyQuery;
    {$else}
      Connection : TSQLite3Connection;
      Transaction : TSQLTransaction;
      Query : TSQLQuery;
    {$endif}
    filePath     : string;
    fileName     : string;
    format       : TFileFormat;
    {-}
    name         : string;
    abbreviation : string;
    copyright    : string;
    info         : string;
    language     : string;
    numbering    : string;
    fileType     : string;
    modified     : string;
    {-}
    RightToLeft  : boolean;
    fontName     : TFontName;
    fontSize     : integer;
    {-}
    connected    : boolean;
    loaded       : boolean;
    strong       : boolean;
    embedded     : boolean;
    footnotes    : boolean;
    interlinear  : boolean;
    default_     : boolean;
    accented     : boolean;
    encryption   : boolean;
    favorite     : boolean;
  private
    class function unbound2mybible(id: integer): integer;
    class function mybible2unbound(id: integer): integer;
    function OpenConnection: boolean;
    procedure OpenUnboundDatabase;
    procedure OpenMybibleDatabase;
    procedure OpenDatabase;
  public
    constructor Create(FilePath: string; new: boolean = false);
    destructor Destroy; override;
    procedure CommitTransaction;
    class function IsNewTestament(n: integer): boolean;
    function EncodeID(id: integer): integer;
    function DecodeID(id: integer): integer;
    function TableExists(table: string): boolean;
    function Delete: boolean;
    procedure SavePrivate(const IniFile: TIniFile);
    procedure ReadPrivate(const IniFile: TIniFile);
  end;

implementation

uses UnitSQLiteEx;

const
  MaxBooks = 88;

var
  myBibleArray : array [1..MaxBooks] of integer = (
    010,020,030,040,050,060,070,080,090,100,110,120,130,140,150,160,190,220,230,240,
    250,260,290,300,310,330,340,350,360,370,380,390,400,410,420,430,440,450,460,470,
    480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,
    680,690,700,710,720,730,000,000,000,000,000,000,000,000,000,000,165,468,170,180,
    462,464,466,467,270,280,315,320
    );

constructor TModule.Create(FilePath: string; new: boolean = false);
var
  ext : string;
begin
  inherited Create;

  self.FilePath := FilePath;
  self.FileName := ExtractFileName(FilePath);

  name         := '';
  abbreviation := '';
  copyright    := '';
  language     := 'en';
  numbering    := 'en';
  filetype     := '';
  modified     := '';
  connected    := false;
  loaded       := false;
  RightToLeft  := false;
  strong       := false;
  embedded     := false;
  footnotes    := false;
  interlinear  := false;
  default_     := false;
  accented     := false;
  encryption   := false;
  favorite     := false;
  format       := unbound;

  ext := ExtractFileExt(FilePath);
  if (ext = '.mybible') or (ext = '.bbli') then format := mysword;
  if (ext = '.SQLite3') then format := mybible;

  {$ifdef zeos}
    Connection := TZConnection.Create(nil);
    Query := TZReadOnlyQuery.Create(nil);
    Connection.Database := FilePath;
    Connection.Protocol := 'sqlite';
    Connection.AutoCommit := False;
    Query.Connection := Connection;
  {$else}
    Connection := TSQLite3Connection.Create(nil);
    Connection.CharSet := 'UTF8';
    Connection.DatabaseName := FilePath;
    Transaction := TSQLTransaction.Create(Connection);
    Connection.Transaction := Transaction;
    Query := TSQLQuery.Create(nil);
    Query.DataBase := Connection;
  {$endif}

  if not OpenConnection then Exit;
  if not new then OpenDatabase;
  if encryption then connected := false;
end;

function TModule.OpenConnection: boolean;
var
  dbhandle : Pointer;
begin
  try
    {$ifdef zeos}
      Connection.Connect;
      dbhandle := (Connection.DbcConnection as TZSQLiteConnection).GetConnectionHandle();
    {$else}
      Connection.Open;
      Transaction.Active := True;
      dbhandle := Connection.Handle;
    {$endif}
    if not Connection.Connected then Exit(false);
    SQLite3CreateFunctions(dbhandle);
 // Connection.ExecuteDirect('PRAGMA case_sensitive_like = 1');
  except
    output('connection failed ' + FilePath);
    Exit(false);
  end;
  Exit(true);
end;

procedure TModule.CommitTransaction;
begin
  {$ifdef zeos} Connection.Commit; {$else} Transaction.Commit; {$endif}
end;

class function TModule.IsNewTestament(n: integer): boolean;
begin
  Result := n in [40..76];
end;

class function TModule.unbound2mybible(id: integer): integer;
begin
  Result := id;
  if id in [1..Length(myBibleArray)] then Result := myBibleArray[id];
end;

class function TModule.mybible2unbound(id: integer): integer;
var i : integer;
begin
  Result := id;
  if id = 0 then Exit;
  for i:=1 to Length(myBibleArray) do
    if id = myBibleArray[i] then Exit(i);
end;

function TModule.EncodeID(id: integer): integer;
begin
  Result := id;
  if format = mybible then Result := unbound2mybible(id);
end;

function TModule.DecodeID(id: integer): integer;
begin
  Result := id;
  if format = mybible then Result := mybible2unbound(id);
end;

function TModule.TableExists(table: string): boolean;
var
  TableNames : TStringList;
begin
  TableNames := TStringList.Create;
  try Connection.GetTableNames({$ifdef zeos}'',{$endif}TableNames) except end;
  Result := TableNames.IndexOf(table) >= 0;
  TableNames.Free;
end;

function TModule.Delete: boolean;
begin
  {$ifdef zeos} Connection.Disconnect; {$else} Connection.Close; {$endif}
  Result := DeleteFile(filePath);
  if not Result then OpenConnection;
end;

destructor TModule.Destroy;
begin
  Query.Free;
  {$ifndef zeos} Transaction.Free; {$endif}
  Connection.Free;
  inherited Destroy;
end;

procedure TModule.OpenUnboundDatabase;
begin
  try
    try
      Query.SQL.Text := 'SELECT * FROM Details';
      Query.Open;

      try info         := Query.FieldByName('Information' ).AsString;  except end;
      try info         := Query.FieldByName('Description' ).AsString;  except end;
      try name         := Query.FieldByName('Title'       ).AsString;  except name := info; end;
      try abbreviation := Query.FieldByName('Abbreviation').AsString;  except end;
      try copyright    := Query.FieldByName('Copyright'   ).AsString;  except end;
      try language     := Query.FieldByName('Language'    ).AsString;  except end;
      try strong       := Query.FieldByName('Strong'      ).AsBoolean; except end;
      try embedded     := Query.FieldByName('Embedded'    ).AsBoolean; except end;
      try interlinear  := Query.FieldByName('Interlinear' ).AsBoolean; except end;
      try encryption   := Query.FieldByName('Encryption'  ).AsBoolean; except end;
      try default_     := Query.FieldByName('Default'     ).AsBoolean; except end;

      connected := true;
    except
      //
    end;
  finally
    Query.Close;
  end;
end;

procedure TModule.OpenMybibleDatabase;
var
  key, value : string;
begin
  try
    try
      Query.SQL.Text := 'SELECT * FROM info';
      Query.Open;

      while not Query.Eof do
        begin
          try key   := Query.FieldByName('name' ).AsString; except end;
          try value := Query.FieldByName('value').AsString; except end;

          if key = 'description'       then name        := value;
          if key = 'detailed_info'     then info        := value;
          if key = 'language'          then language    := value;
          if key = 'russian_numbering' then numbering   := value;
          if key = 'strong_numbers'    then strong      := ToBoolean(value);
          if key = 'is_strong'         then strong      := ToBoolean(value);
          if key = 'is_footnotes'      then footnotes   := ToBoolean(value);
          if key = 'interlinear'       then interlinear := ToBoolean(value);

          Query.Next;
        end;

      if ToBoolean(numbering) then numbering := 'ru';
      connected := true;
    except
      //
    end;
  finally
    Query.Close;
  end;
end;

procedure TModule.OpenDatabase;
begin
  if format in [unbound, mysword] then OpenUnboundDatabase;
  if format = mybible then OpenMybibleDatabase;
  if not connected then Exit;
  if name.isEmpty then name := fileName;
  RightToLeft := IsRightToLeft(language);
  info := RemoveTags(info);
  accented := language = 'ru';
end;

procedure TModule.SavePrivate(const IniFile : TIniFile);
begin
  IniFile.WriteBool(FileName, 'Favorite', favorite);
end;

procedure TModule.ReadPrivate(const IniFile : TIniFile);
begin
  favorite := IniFile.ReadBool(FileName, 'Favorite', True);
end;

end.

