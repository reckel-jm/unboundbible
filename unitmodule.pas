unit UnitModule;

  {$ifdef linux}
    {$define zeos}
  {$endif}

interface

uses
  Classes, SysUtils, Dialogs, Graphics, ClipBrd, LazUtf8, DB, SQLdb,
  {$ifdef zeos} ZConnection, ZDataset, ZDbcSqLite, {$else} SQLite3conn, {$endif}
  UnitData, UmLib, UnitLib;

type
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
    fileType     : string;
    {-}
    FirstVerse   : TVerse;
    RightToLeft  : boolean;
    fontName     : TFontName;
    fontSize     : integer;
    {-}
    connected    : boolean;
    loaded       : boolean;
    strong       : boolean;
    footnotes    : boolean;
    interlinear  : boolean;
    embtitles    : boolean;
  public
    constructor Create(FilePath: string; new: boolean = false);
    procedure CreateDatabase;
    procedure OpenDatabase;
    function EncodeID(id: integer): integer;
    function DecodeID(id: integer): integer;
    function TableExists(table: string): boolean;
    procedure InsertDetails;
    procedure InsertRows(Content : TContentArray);
    destructor Destroy; override;
  end;

implementation

uses UnitSQLiteEx;

constructor TModule.Create(FilePath: string; new: boolean = false);
var
  ext : string;
begin
  inherited Create;

  {$ifdef zeos}
    Connection := TZConnection.Create(nil);
    Query := TZReadOnlyQuery.Create(nil);
    Connection.Database := FilePath;
    Connection.Protocol := 'sqlite-3';
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

  self.FilePath := FilePath;
  self.FileName := ExtractFileName(FilePath);

  name         := '';
  abbreviation := '';
  copyright    := '';
  language     := 'en';
  filetype     := '';
  connected    := false;
  loaded       := false;
  RightToLeft  := false;
  strong       := false;
  footnotes    := false;
  interlinear  := false;
  embtitles    := false;
  format       := unbound;

  ext := ExtractFileExt(FilePath);
  if  (ext = '.mybible') or (ext = '.bbli') then format := mysword;

  if new then CreateDatabase else OpenDatabase;
  //output(FilePath);
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

destructor TModule.Destroy;
begin
  Query.Free;
  {$ifndef zeos} Transaction.Free; {$endif}
  Connection.Free;
  inherited Destroy;
end;

procedure TModule.CreateDatabase;
begin
  if FileExists(Connection.DatabaseName) then DeleteFile(Connection.DatabaseName);
  if FileExists(Connection.DatabaseName) then Exit;

  try
    {$ifdef zeos}
      Connection.Connect;
    {$else}
      Connection.Open;
      Transaction.Active := True;
    {$endif}
    try
      Connection.ExecuteDirect('CREATE TABLE "Bible"'+
          '("Book" INT, "Chapter" INT, "Verse" INT, "Scripture" TEXT);');
      Connection.ExecuteDirect('CREATE TABLE "Details"'+
          '("Title" TEXT,"Abbreviation" TEXT,"Information" TEXT,"Language" TEXT);');

      Transaction.Commit;
    except
      // unable to create database
    end;
  except
    //
  end;
 end;

procedure TModule.OpenDatabase;
var
  key, value : string;
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

    if not Connection.Connected then Exit;
    SQLite3CreateFunctions(dbhandle);
 // Connection.ExecuteDirect('PRAGMA case_sensitive_like = 1');
    if TableExists('info') then format := mybible;
  except
    output('connection failed ' + self.fileName);
    Exit;
  end;

  if format in [unbound, mysword] then
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
        try interlinear  := Query.FieldByName('Interlinear' ).AsBoolean; except end;

        connected := true;
      except
        //
      end;
    finally
      Query.Close;
    end;

  if format = mybible then
    try
      try
        Query.SQL.Text := 'SELECT * FROM info';
        Query.Open;

        while not Query.Eof do
          begin
            try key   := Query.FieldByName('name' ).AsString; except end;
            try value := Query.FieldByName('value').AsString; except end;

            if key = 'description'   then name        := value;
            if key = 'detailed_info' then info        := value;
            if key = 'language'      then language    := value;
            if key = 'is_strong'     then strong      := ToBoolean(value);
            if key = 'is_footnotes'  then footnotes   := ToBoolean(value);
            if key = 'interlinear'   then interlinear := ToBoolean(value);

            Query.Next;
          end;

        connected := true;
      except
        //
      end;
    finally
      Query.Close;
    end;

  if connected then
    begin
      if name = '' then name := fileName;
      RightToLeft := IsRightToLeft(language);
      info := RemoveTags(info);
    end;
end;

procedure TModule.InsertDetails;
begin
  try
    try
      Query.SQL.Text := 'INSERT INTO Details VALUES (:t,:a,:i,:l);';
      Query.ParamByName('t').AsString := name;
      Query.ParamByName('a').AsString := abbreviation;
      Query.ParamByName('i').AsString := info;
      Query.ParamByName('l').AsString := language;
      Query.ExecSQL;
      Transaction.Commit;
    except
      //
    end;
  finally
    Query.Close;
  end;
end;

procedure TModule.InsertRows(Content : TContentArray);
var
  line : TContent;
begin
  try
    try
      for line in Content do
        begin
          Query.SQL.Text := 'INSERT INTO Bible VALUES (:b,:c,:v,:s);';
          Query.ParamByName('b').AsInteger := line.verse.book;
          Query.ParamByName('c').AsInteger := line.verse.chapter;
          Query.ParamByName('v').AsInteger := line.verse.number;
          Query.ParamByName('s').AsString  := line.text;
          Query.ExecSQL;
        end;

      Transaction.Commit;
    except
      //
    end;
  finally
    Query.Close;
  end;
end;

end.

