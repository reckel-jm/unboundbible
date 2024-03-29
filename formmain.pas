unit FormMain;

interface

uses
  Classes, Fgl, SysUtils, LazFileUtils, LazUTF8, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, IniFiles, LCLIntf, LCLType,
  LCLProc, ActnList, ClipBrd, StdActns, Buttons, PrintersDlgs,
  RichMemo, UnboundMemo, UnitUtils, UnitLib;

type
  TStatuses = TFPGMap<integer, string>;

  { TMainForm }

  TMainForm = class(TForm)
    ToolEdit: TEdit;
    IdleTimer: TIdleTimer;
    Panel1: TPanel;
    MainMenu: TMainMenu;
    PopupMenu: TPopupMenu;
    PopupTabs: TPopupMenu;
    PrintDialog: TPrintDialog;
    FontDialog: TFontDialog;
    FontDialogNotes: TFontDialog;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ComboBox: TComboBox;
    FileOpen1: TFileOpen;
    EditCut1: TEditCut;

    MemoBible: TUnboundMemo;
    MemoCommentary: TUnboundMemo;
    MemoCompare: TUnboundMemo;
    MemoDictionary: TUnboundMemo;
    MemoHistory: TUnboundMemo;
    MemoNotes: TUnboundMemo;
    MemoReference: TUnboundMemo;
    MemoSearch: TUnboundMemo;

    ActionAbout: THelpAction;
    ActionBold: TAction;
    ActionBullets: TAction;
    ActionCenter: TAction;
    ActionCleanHistory: TAction;
    ActionCommentaries: TAction;
    ActionCompare: TAction;
    ActionCopyAs: TAction;
    ActionCopyVerses: TAction;
    ActionDecrease: TAction;
    ActionDictionaries: TAction;
    ActionEditCopy: TAction;
    ActionEditCut: TAction;
    ActionEditDel: TAction;
    ActionEditFont: TAction;
    ActionEditPaste: TAction;
    ActionEditSelAll: TEditSelectAll;
    ActionEditUndo: TAction;
    ActionExit: TAction;
    ActionFileNew: TAction;
    ActionFileOpen: TAction;
    ActionFilePrint: TAction;
    ActionFileSave: TAction;
    ActionFileSaveAs: TAction;
    ActionFont: TAction;
    ActionHistory: TAction;
    ActionHistoryLeft: TAction;
    ActionHistoryRight: TAction;
    ActionIncrease: TAction;
    ActionInterlinear: TAction;
    ActionItalic: TAction;
    ActionLeft: TAction;
    ActionLink: TAction;
    ActionList: TActionList;
    ActionLookup: TAction;
    ActionModules: TAction;
    ActionOptions: TAction;
    ActionReference: TAction;
    ActionRight: TAction;
    ActionSearch: TAction;
    ActionSearchfor: TAction;
    ActionUnderline: TAction;

    ChapterBox: TListBox;
    BookBox: TListBox;
    Ruler: TPanel;
    PanelLeft: TPanel;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    Images: TImageList;

    PageControl: TPageControl;
    TabSheetReference: TTabSheet;
    TabSheetBible: TTabSheet;
    TabSheetSearch: TTabSheet;
    TabSheetCompare: TTabSheet;
    TabSheetCommentary: TTabSheet;
    TabSheetDictionary: TTabSheet;
    TabSheetHistory: TTabSheet;
    TabSheetNotes: TTabSheet;

    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;

    miBibleFolder: TMenuItem;
    miClear: TMenuItem;
    miCommentaries: TMenuItem;
    miCompare: TMenuItem;
    miCopy: TMenuItem;
    miCopyAs: TMenuItem;
    miCut: TMenuItem;
    miDictionaries: TMenuItem;
    miDonate: TMenuItem;
    miDownload: TMenuItem;
    miEdit: TMenuItem;
    miExit: TMenuItem;
    miHelp: TMenuItem;
    miHelpAbout: TMenuItem;
    miHistory: TMenuItem;
    miHome: TMenuItem;
    miInterlinear: TMenuItem;
    miIssue: TMenuItem;
    miModules: TMenuItem;
    miNoteNew: TMenuItem;
    miNoteOpen: TMenuItem;
    miNoteSave: TMenuItem;
    miNoteSaveAs: TMenuItem;
    miNotes: TMenuItem;
    miOptions: TMenuItem;
    miPaste: TMenuItem;
    miPrint: TMenuItem;
    miRecent: TMenuItem;
    miRrefx: TMenuItem;
    miSearch: TMenuItem;
    miSelectAll: TMenuItem;
    miTools: TMenuItem;
    miUndo: TMenuItem;
    miVerses: TMenuItem;

    MenuItem2: TMenuItem;
    pmClose: TMenuItem;
    pmCopy: TMenuItem;
    pmCopyAs: TMenuItem;
    pmCut: TMenuItem;
    pmCleanHistory: TMenuItem;
    pmLookup: TMenuItem;
    pmPaste: TMenuItem;
    pmSearchfor: TMenuItem;
    pmSeparator2: TMenuItem;
    pmSeparatorH: TMenuItem;
    pmSeparator: TMenuItem;
    pmVerses: TMenuItem;

    StandardToolBar: TToolBar;
    ToolButtonBold: TToolButton;
    ToolButtonBullets: TToolButton;
    ToolButtonCenter: TToolButton;
    ToolButtonCommentary: TToolButton;
    ToolButtonCopy: TToolButton;
    ToolButtonCut: TToolButton;
    ToolButtonDictionary: TToolButton;
    ToolButtonFont: TToolButton;
    ToolButtonHistory: TToolButton;
    ToolButtonItalic: TToolButton;
    ToolButtonLeft: TToolButton;
    ToolButtonLink: TToolButton;
    ToolButtonNew: TToolButton;
    ToolButtonOpen: TToolButton;
    ToolButtonPaste: TToolButton;
    ToolButtonPrint: TToolButton;
    ToolButtonReference: TToolButton;
    ToolButtonRight: TToolButton;
    ToolButtonSave: TToolButton;
    ToolButtonSearch: TToolButton;
    ToolButtonShelf: TToolButton;
    ToolButtonUnderline: TToolButton;
    ToolButtonUndo: TToolButton;
    ToolButtonVerses: TToolButton;
    ToolPanel: TPanel;
    ToolSeparator1: TToolButton;
    ToolSeparator2: TToolButton;
    ToolSeparator3: TToolButton;
    ToolSeparator4: TToolButton;
    ToolSeparator5: TToolButton;
    ToolSeparator6: TToolButton;

    procedure CmdCleanHistory(Sender: TObject);
    procedure CmdHistory(Sender: TObject);
    procedure CmdReference(Sender: TObject);
    procedure CmdCommentaries(Sender: TObject);
    procedure CmdDictionaries(Sender: TObject);
    procedure CmdAbout(Sender: TObject);
    procedure CmdCompare(Sender: TObject);
    procedure CmdCopyAs(Sender: TObject);
    procedure CmdCopyVerses(Sender: TObject);
    procedure CmdEdit(Sender: TObject);
    procedure CmdExit(Sender: TObject);
    procedure CmdFileNew(Sender: TObject);
    procedure CmdFileOpen(Sender: TObject);
    procedure CmdFilePrint(Sender: TObject);
    procedure CmdFileSave(Sender: TObject);
    procedure CmdFileSaveAs(Sender: TObject);
    procedure CmdInterline(Sender: TObject);
    procedure CmdOptions(Sender: TObject);
    procedure CmdSearch(Sender: TObject);
    procedure CmdSearchFor(Sender: TObject);
    procedure CmdLookup(Sender: TObject);
    procedure CmdStyle(Sender: TObject);
    procedure CmdStyle2(Sender: TObject);
    procedure CmdModules(Sender: TObject);

    procedure ComboBoxChange(Sender: TObject);
    procedure ComboBoxDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure MemoBibleParagraphChange(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StandardToolBarPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure IdleTimerTimer(Sender: TObject);
    procedure BookBoxClick(Sender: TObject);
    procedure ChapterBoxClick(Sender: TObject);
    procedure MemoMouseLeave(Sender: TObject);
    procedure MemoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure MemoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MemoSelectionChange(Sender: TObject);
    procedure miBibleFolderClick(Sender: TObject);
    procedure miDownloadClick(Sender: TObject);
    procedure miHomeClick(Sender: TObject);
    procedure miIssueClick(Sender: TObject);
    procedure miDonateClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure PageControlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pmCloseClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ToolButtonDonateClick(Sender: TObject);
    procedure ToolButtonSearchClick(Sender: TObject);
  private
    NoteFileName: string;
    RecentList: TStringArray;
    Statuses: TStatuses;
    IdleMessage : string;
    showed : boolean;
    function UnboundMemo: TUnboundMemo;
    function CheckFileSave: boolean;
    procedure LoadComboBox;
    procedure EnableActions;
    procedure FirstAppearance;
    procedure UpDownButtons;
    procedure SelectBook(title: string; scroll: boolean);
    procedure ShowCurrVerse(select: boolean);
    procedure ShowCurrBible;
    procedure LoadChapter;
    procedure LoadSearch(s: string);
    procedure LoadCompare;
    procedure LoadReference;
    procedure LoadCommentary;
    procedure LoadDictionary(s: string);
    procedure LoadHistory;
    procedure LoadStrong(s: string);
    procedure LoadFootnote(s: string);
    procedure MakeBookList;
    procedure MakeChapterList;
    procedure OnRecentClick(Sender: TObject);
    procedure PerformFileOpen(const FileName: string);
    procedure ReadConfig;
    procedure RebuildRecentList;
    procedure MakeRecentMenu;
    procedure HideCursor;
    procedure SaveConfig;
    procedure SelectPage(page: integer);
    procedure UpdateCaption(s: string);
    procedure RefreshStatus;
    procedure UpdateStatus(s: string);
    procedure UpdateActionImage;
    procedure VersesToClipboard;
    procedure ShowPopup;
    procedure Localize;
  public
    procedure AssignFont;
    procedure LocalizeApplication;
  end;

var
  MainForm: TMainForm;

implementation

uses
  {$ifdef windows} UmParseWin, {$endif}
  FormAbout, FormNotify, FormSearch, FormOptions, FormCopy, FormShelf,
  UnitTools, UnitLocal, UnitModule, UnitBible, UnitCommentary, UnitDictionary;

const
  apBible        = 0; // active page
  apSearch       = 1;
  apCompare      = 2;
  apReferences   = 3;
  apCommentaries = 4;
  apDictionaries = 5;
  apHistory      = 6;
  apNotes        = 7;

{$R *.lfm}

//=================================================================================================
//                                     Create Main Form
//=================================================================================================

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Localization := TLocalization.Create;
  Statuses := TStatuses.Create;

  Caption := ApplicationName + ' ' + ApplicationVersion;
  RecentList := [];
  showed := False;

  SaveDialog.InitialDir := DocumentsPath;
  NoteFileName := Untitled;

  ReadConfig;
  AssignFont;
  MakeRecentMenu;

  NoteFileName := Untitled;
  MemoNotes.Lines.Clear;
  MemoNotes.Font.Size := Font.Size;
  IdleMessage := '';

  ShowCurrBible;

  {$ifdef windows}
    TabSheetSearch    .TabVisible := False;
    TabSheetReference .TabVisible := False;
    TabSheetCommentary.TabVisible := False;
    TabSheetDictionary.TabVisible := False;
    TabSheetHistory   .TabVisible := False;
    IdleTimer.Interval := 50;
  {$endif}

  {$ifdef linux}
    StandardToolBar.ParentColor := True;
    ToolPanel.Color := clForm;
    ActionFilePrint.Visible := False;
    ActionEditUndo.Visible := False;
    ActionBullets.Visible := False;
    ToolSeparator6.Visible := False;
  {$endif}

  {$ifndef darwin} UpdateActionImage; {$endif}
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveConfig;
  Statuses.Free;
  Localization.Free;
end;

procedure TMainForm.FirstAppearance;
begin
  LocalizeApplication;
  {$ifdef linux}
    TabSheetSearch    .TabVisible := False;
    TabSheetReference .TabVisible := False;
    TabSheetCommentary.TabVisible := False;
    TabSheetDictionary.TabVisible := False;
    TabSheetHistory   .TabVisible := False;
    ShowCurrVerse(CurrVerse.number > 1);
  {$endif}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not showed then FirstAppearance;
  showed := True;
  {$ifdef windows} IdleMessage := 'HideCursor'; {$endif}
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  {$ifdef linux}
    MemoBible     .Clear;
    MemoCommentary.Clear;
    MemoCompare   .Clear;
    MemoDictionary.Clear;
    MemoHistory   .Clear;
    MemoNotes     .Clear;
    MemoReference .Clear;
    MemoSearch    .Clear;
  {$endif}
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  try
    CanClose := CheckFileSave;
  except
    CanClose := False;
  end;
end;

procedure TMainForm.StandardToolBarPaint(Sender: TObject);
begin
  ToolPanel.Width := StandardToolBar.Width - ToolButtonRight.Width - ToolButtonSearch.Width
                   - {$ifdef linux} ToolButtonRight.Left {$else} ToolButtonBullets.Left {$endif};
  ToolEdit.Left := StandardToolBar.Width - ToolButtonSearch.Width - ToolEdit.Width - 4;
  ToolEdit.Visible := ToolPanel.Width > ToolEdit.Width;
end;

procedure TMainForm.MemoMouseLeave(Sender: TObject);
var
  Point : TPoint;
begin
  if NotifyForm.Visible then
    begin
      Point := UnboundMemo.ScreenToClient(Mouse.CursorPos);
      if (Point.x <= 0) or (Point.x >= UnboundMemo.Width  - 30) or
         (Point.y <= 0) or (Point.y >= UnboundMemo.Height - 30) then NotifyForm.Close;
    end;
end;

procedure TMainForm.AssignFont;
begin
  MemoBible.Font.Assign(Font);
  MemoCommentary.Font.Assign(Font);
  MemoCompare.Font.Assign(Font);
  MemoDictionary.Font.Assign(Font);
  MemoHistory.Font.Assign(Font);
  MemoReference.Font.Assign(Font);
  MemoSearch.Font.Assign(Font);
end;

procedure TMainForm.Localize;
begin
  miBibleFolder.Caption := T('Bible Folder');
  miClear.Caption := T('Delete');
  miCommentaries.Caption := T('Commentaries');
  miCompare.Caption := T('Compare');
  miCopy.Caption := T('Copy');
  miCopyAs.Caption := T('Copy As…');
  miCut.Caption := T('Cut');
  miDictionaries.Caption := T('Dictionaries');
  miDonate.Caption := T('Donate');
  miDownload.Caption := T('Modules Downloads');
  miEdit.Caption := T('Edit');
  miExit.Caption := T('Exit');
  miHelp.Caption := T('Help');
  miHelpAbout.Caption := T('About');
  miHistory.Caption := T('History');
  miHome.Caption := T('Home Page');
  miInterlinear.Caption := T('Interlinear') + ' (biblehub.com)';
  miIssue.Caption := T('Report an Issue');
  miModules.Caption := T('Modules');
  miNoteNew.Caption := T('New');
  miNoteOpen.Caption := T('Open…');
  miNoteSave.Caption := T('Save');
  miNoteSaveAs.Caption := T('Save As…');
  miNotes.Caption := T('Notes');
  miOptions.Caption := T('Options');
  miPaste.Caption := T('Paste');
  miPrint.Caption := T('Print');
  miRecent.Caption := T('Open Recent');
  miRrefx.Caption := T('Cross-References');
  miSearch.Caption := T('Search');
  miSelectAll.Caption := T('Select All');
  miTools.Caption := T('Tools');
  miUndo.Caption := T('Undo');
  miVerses.Caption := T('Copy Verses');

  pmCleanHistory.Caption := T('Clean History');
  pmClose.Caption := T('Close');
  pmCopy.Caption := T('Copy');
  pmCopyAs.Caption := T('Copy As…');
  pmCut.Caption := T('Cut');
  pmPaste.Caption := T('Paste');
  pmVerses.Caption := T('Copy Verses');

  TabSheetBible.Caption := T('Bible');
  TabSheetCommentary.Caption := T('Commentaries');
  TabSheetCompare.Caption := T('Compare');
  TabSheetDictionary.Caption := T('Dictionaries');
  TabSheetHistory.Caption := T('History');
  TabSheetNotes.Caption := T('Notes');
  TabSheetReference.Caption := T('Cross-References');
  TabSheetSearch.Caption := T('Search');

  ToolButtonBold.Hint := T('Bold');
  ToolButtonBullets.Hint := T('Bullets');
  ToolButtonCenter.Hint := T('Center');
  ToolButtonCommentary.Hint := T('Commentaries');
  ToolButtonCopy.Hint := T('Copy');
  ToolButtonCut.Hint := T('Cut');
  ToolButtonDictionary.Hint := T('Dictionaries');
  ToolButtonFont.Hint := T('Font');
  ToolButtonHistory.Hint := T('History');
  ToolButtonItalic.Hint := T('Italic');
  ToolButtonLeft.Hint := T('Align Left');
  ToolButtonLink.Hint := T('Hyperlink');
  ToolButtonNew.Hint := T('New');
  ToolButtonOpen.Hint := T('Open');
  ToolButtonPaste.Hint := T('Paste');
  ToolButtonPrint.Hint := T('Print');
  ToolButtonReference.Hint := T('Cross-References');
  ToolButtonRight.Hint := T('Align Right');
  ToolButtonSave.Hint := T('Save');
  ToolButtonSearch.Hint := T('Search Options');
  ToolButtonShelf.Hint := T('Modules');
  ToolButtonUnderline.Hint := T('Underline');
  ToolButtonUndo.Hint := T('Undo');
  ToolButtonVerses.Hint := T('Copy Verses');
end;

procedure TMainForm.LocalizeApplication;
begin
  MainForm    .Localize;
  AboutBox    .Localize;
  CopyForm    .Localize;
  OptionsForm .Localize;
  SearchForm  .Localize;
  ShelfForm   .Localize;
  ShelfForm   .Localize;
end;

//-------------------------------------------------------------------------------------------------
//                                       Actions
//-------------------------------------------------------------------------------------------------

procedure TMainForm.CmdAbout(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.CmdStyle(Sender: TObject);
var
  fp: TFontParams;
begin
  fp := MemoNotes.SelAttributes;
  MemoNotes.SaveSelection;
  if MemoNotes.SelLength = 0 then MemoNotes.SelectWord;

  if Sender = ActionBold then
    if fsBold in fp.Style then fp.Style := fp.Style - [fsBold]
                          else fp.Style := fp.Style + [fsBold];

  if Sender = ActionItalic then
    if fsItalic in fp.Style then fp.Style := fp.Style - [fsItalic]
                            else fp.Style := fp.Style + [fsItalic];

  if Sender = ActionUnderline then
    if fsUnderline in fp.Style then fp.Style := fp.Style - [fsUnderline]
                               else fp.Style := fp.Style + [fsUnderline];

  if Sender = ActionLink then
    if fp.Color = clNavy then fp.Color := clBlack
                         else fp.Color := clNavy;

//if Sender = ActionSuper then
//  if fp.vScriptPos = vpSuperscript then fp.vScriptPos := vpNormal
//                                   else fp.vScriptPos := vpSuperscript;

  if Sender = ActionIncrease then fp.Size += 1;
  if Sender = ActionDecrease then fp.Size -= 1;

  if Sender = ActionFont then
    begin
      FontDialogNotes.Font.Name  := fp.Name;
      FontDialogNotes.Font.Size  := fp.Size;
      FontDialogNotes.Font.Style := fp.Style;
      FontDialogNotes.Font.Color := fp.Color;

      if FontDialogNotes.Execute then
        begin
          fp.Name  := FontDialogNotes.Font.Name;
          fp.Size  := FontDialogNotes.Font.Size;
          fp.Style := FontDialogNotes.Font.Style;
          fp.Color := FontDialogNotes.Font.Color;
        end;
    end;

  MemoNotes.SetTextAttributes(MemoNotes.SelStart, MemoNotes.SelLength, fp);
  MemoNotes.RestoreSelection; // unselect word
  MemoNotes.Repaint;
end;

procedure TMainForm.CmdStyle2(Sender: TObject);
{$ifdef windows} var pn : TParaNumbering; {$endif}
begin
  with MemoNotes do
    begin
      if Sender = ActionLeft    then SetParaAlignment(SelStart, SelLength, paLeft   );
      if Sender = ActionCenter  then SetParaAlignment(SelStart, SelLength, paCenter );
      if Sender = ActionRight   then SetParaAlignment(SelStart, SelLength, paRight  );

      {$ifdef windows}
      if Sender = ActionBullets then
        begin
          pn := SelParaNumbering;
          if pn.Style = pnNone then pn.Style := pnBullet else pn.Style := pnNone;
          SetParaNumbering(SelStart, SelLength, pn);
        end;
      {$endif}
    end;

  MemoNotes.Repaint;
end;

procedure TMainForm.ComboBoxChange(Sender: TObject);
begin
  if Tools.SetCurrBible(ComboBox.Items[ComboBox.ItemIndex]) then ShowCurrBible;
end;

procedure TMainForm.ComboBoxDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
begin
  ComboBox.canvas.fillrect(ARect);
  Canvas.TextOut(ARect.Left + 5, ARect.Top, ComboBox.Items[Index]);
  Canvas.TextOut(ARect.Left + 220, ARect.Top, '[ru]');
end;

procedure TMainForm.CmdCompare(Sender: TObject);
begin
  LoadCompare;
end;

procedure TMainForm.CmdInterline(Sender: TObject);
var path : string;
begin
  path := BibleHubURL(CurrVerse.book, CurrVerse.chapter, CurrVerse.number);
  if path <> '' then OpenURL(path);
end;

procedure TMainForm.CmdEdit(Sender: TObject);
begin
  if Sender = ActionEditCopy   then UnboundMemo.CopyToClipboard;
  if Sender = ActionEditPaste  then UnboundMemo.PasteFromClipboard;
  if Sender = ActionEditDel    then UnboundMemo.ClearSelection;
  if Sender = ActionEditUndo   then UnboundMemo.Undo;
  if Sender = ActionEditSelAll then UnboundMemo.SelectAll;

  if Sender = ActionEditCut then
    begin
      UnboundMemo.CopyToClipboard;
      UnboundMemo.ClearSelection;
    end;

  EnableActions;
end;

procedure TMainForm.CmdCopyAs(Sender: TObject);
begin
  // saving selection because of strange bug in the gtk2's richmemo
  {$ifdef linux} MemoBible.SaveSelection; {$endif}
  CopyForm.Memo.Font.Assign(Font);
  CopyForm.ShowModal;
  {$ifdef linux} MemoBible.RestoreSelection; {$endif}
end;

procedure TMainForm.CmdCopyVerses(Sender: TObject);
begin
  {$ifdef unix} MemoBible.SaveSelection; {$endif}
  VersesToClipboard;
  {$ifdef unix} MemoBible.RestoreSelection; {$endif}
end;

procedure TMainForm.CmdSearch(Sender: TObject);
begin
  ToolEdit.SetFocus;
end;

procedure TMainForm.CmdSearchFor(Sender: TObject);
begin
  ToolEdit.Text := Trim(UnboundMemo.SelText);
  LoadSearch(ToolEdit.Text);
end;

procedure TMainForm.CmdReference(Sender: TObject);
begin
  LoadReference;
end;

procedure TMainForm.CmdHistory(Sender: TObject);
begin
  LoadHistory;
end;

procedure TMainForm.CmdCleanHistory(Sender: TObject);
begin
  Tools.CleanHistory;
  MemoHistory.Clear;
end;

procedure TMainForm.CmdCommentaries(Sender: TObject);
var
  Response : integer;
begin
  if Tools.Commentaries.FootnotesOnly then
    begin
      Response := QuestionDlg(T('Commentaries'),
        T('You don''t have any commentary modules.'), mtCustom,
          [mrYes, T('Download'), mrNo, T('Cancel')], '');
      if Response = idYes then OpenURL(DownloadsURL);
      Exit;
    end;

  LoadCommentary;
end;

procedure TMainForm.CmdLookup(Sender: TObject);
begin
  ToolEdit.Text := Trim(UnboundMemo.SelText);
  CmdDictionaries(Sender);
end;

procedure TMainForm.CmdDictionaries(Sender: TObject);
begin
  if Tools.Dictionaries.EmbeddedOnly then
    begin
      if QuestionDlg(T('Dictionaries'),
        T('You don''t have any dictionary modules.'), mtCustom,
          [mrYes, T('Download'), mrNo, T('Cancel')], '') = idYes then
            OpenURL(DownloadsURL);
      Exit;
    end;

  LoadDictionary(ToolEdit.Text);
end;

procedure TMainForm.CmdFileNew(Sender: TObject);
begin
  SelectPage(apNotes);
  if not CheckFileSave then Exit;
  NoteFileName := Untitled;
  MemoNotes.Lines.Clear;
  MemoNotes.Modified := False;
  UpdateCaption(NoteFileName);
end;

procedure TMainForm.CmdFileOpen(Sender: TObject);
begin
  if not CheckFileSave then Exit;
  if OpenDialog.Execute then
    begin
      PerformFileOpen(OpenDialog.FileName);
      MemoNotes.ReadOnly := ofReadOnly in OpenDialog.Options;
    end;
end;

procedure TMainForm.CmdFileSave(Sender: TObject);
begin
  SelectPage(apNotes);
  if not MemoNotes.Modified then Exit;
  if NoteFileName = Untitled then
    CmdFileSaveAs(Sender)
  else
    begin
      MemoNotes.SaveToFile(NoteFileName);
      MemoNotes.Modified := False;
    end;
end;

procedure TMainForm.CmdFileSaveAs(Sender: TObject);
begin
  SelectPage(apNotes);
  if NoteFileName = Untitled then SaveDialog.InitialDir := DocumentsPath
                             else SaveDialog.InitialDir := ExtractFilePath(NoteFileName);

  if not SaveDialog.Execute then Exit;

  if not SaveDialog.FileName.Contains('.rtf') then
    SaveDialog.FileName := SaveDialog.FileName + '.rtf';

  if FileExists(SaveDialog.FileName) then
    if QuestionDlg(' ' + T('Confirmation'),
      Format(T('OK to overwrite %s?'), [SaveDialog.FileName]), mtWarning,
        [mrYes, T('Yes'), mrNo, T('No'), 'IsDefault'], 0) <> idYes then Exit;

  MemoNotes.SaveToFile(SaveDialog.FileName);
  NoteFileName := SaveDialog.FileName;

  RebuildRecentList;

  MemoNotes.Modified := False;
  UpdateCaption(ExtractOnlyName(NoteFileName));
end;

procedure TMainForm.CmdFilePrint(Sender: TObject);
var
  Params : TPrintParams;
begin
  InitPrintParams(Params{%H-});
  if PrintDialog.Execute then UnboundMemo.Print(Params);
end;

procedure TMainForm.CmdModules(Sender: TObject);
begin
  if ShelfForm.ShowModal = mrOk then ShowCurrBible else LoadComboBox;
  if PageControl.ActivePageIndex = apCompare then LoadCompare;
end;

procedure TMainForm.CmdExit(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------------------------------
//                                         Events
//-------------------------------------------------------------------------------------------------

procedure TMainForm.BookBoxClick(Sender: TObject);
var
  Book : TBook;
  name : string;
begin
  if BookBox.Count = 0 then Exit;
  name := BookBox.Items[BookBox.ItemIndex];

  Book := CurrBible.BookByName(name);
  if not Assigned(Book) then Exit;

  CurrVerse.Init;
  CurrVerse.Book := Book.Number;

  MakeChapterList;
  LoadChapter;
end;

procedure TMainForm.ChapterBoxClick(Sender: TObject);
begin
  CurrVerse.Chapter := ChapterBox.ItemIndex + 1;
  CurrVerse.Number := 1;
  CurrVerse.Count := 1;
  LoadChapter;
end;

procedure TMainForm.MemoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  Memo : TUnboundMemo;
  Verse : TVerse;
  s : string;
begin
  Memo := Sender as TUnboundMemo;

  if Button = mbRight then ShowPopup;
  if Button <> mbLeft then Exit;

  if Memo = MemoBible then Tools.AddHistory;

  if Memo.hyperlink.isEmpty then Exit;

  if Memo.Foreground = fgLink then
    begin
      if Memo = MemoHistory then
        begin
          s := Tools.FilenameFromHistory(Round((Memo.Breaks/2)));
          if Tools.SetCurrBible(s) then ShowCurrBible;
        end;

      Verse := CurrBible.SrtToVerse(Memo.hyperlink);

      if CurrBible.GoodLink(Verse) then
        begin
          CurrVerse := Verse;
          ShowCurrVerse(True);
          Tools.AddHistory;
        end
      else
        if Tools.SetCurrBible(Memo.hyperlink)then ShowCurrBible;
    end;

  if Memo = MemoBible then
    if Memo.Foreground = fgFootnote then LoadFootnote(Memo.hyperlink);

  if Memo <> MemoNotes then
    if Memo.Foreground = fgStrong then LoadStrong(Memo.hyperlink);
end;

procedure TMainForm.MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_APPS) or ((Key = VK_F10) and (Shift = [ssShift])) then ShowPopup;
end;

procedure TMainForm.MemoSelectionChange(Sender: TObject);
begin
  EnableActions;
  if Sender = MemoNotes then UpDownButtons;
end;

procedure TMainForm.MemoBibleParagraphChange(Sender: TObject);
begin
  CurrVerse.Number := MemoBible.ParagraphStart;
  CurrVerse.Count  := MemoBible.ParagraphCount;
end;

procedure TMainForm.MemoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True; // disable system popup menu
end;

procedure TMainForm.ToolEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Verse: TVerse;
begin
  if Key = VK_RETURN then
    begin
      Verse := CurrBible.SrtToVerse(trim(ToolEdit.Text));
      if CurrBible.GoodLink(Verse) then
        begin
          CurrVerse := Verse;
          ShowCurrVerse(True)
        end
    else if PageControl.ActivePageIndex = apDictionaries then LoadDictionary(ToolEdit.Text)
      else LoadSearch(ToolEdit.Text);
    end;

end;

//-------------------------------------------------------------------------------------------------

procedure TMainForm.LoadComboBox;
var
  Item : string;
begin
  ComboBox.Items.Clear;
  for Item in Tools.Get_FavoriteBiles do
    begin
      ComboBox.Items.Add(Item);
      if Item = CurrBible.name then ComboBox.ItemIndex := ComboBox.Items.Count - 1;
    end;
end;

procedure TMainForm.UpdateCaption(s: string);
begin
  Caption := ApplicationName + ' ' + ApplicationVersion + ' - ' + s;
end;

procedure TMainForm.RefreshStatus;
begin
  try
    StatusBar.SimpleText := ' ' + Statuses.KeyData[PageControl.ActivePageIndex];
  except
    StatusBar.SimpleText := '';
  end;
end;

procedure TMainForm.UpdateStatus(s: string);
begin
  Statuses.AddOrSetData(PageControl.ActivePageIndex, s);
  RefreshStatus;
end;

procedure TMainForm.ShowPopup;
var
  CursorPos: TPoint;
begin
  GetCursorPos(CursorPos);
  PopupMenu.Popup(CursorPos.X, CursorPos.Y);
end;

procedure TMainForm.SelectBook(title: string; scroll: boolean);
var
  item : string;
begin
  for item in BookBox.Items do
    if item = title then
      begin
        BookBox.ItemIndex := BookBox.Items.IndexOf(item);
        if scroll then BookBox.TopIndex := BookBox.ItemIndex;
      end;
end;

procedure TMainForm.ShowCurrVerse(select: boolean);
var
  Book : TBook;
begin
  Book := CurrBible.BookByNum(CurrVerse.Book);
  if not Assigned(Book) then Exit;

  MakeChapterList;
  LoadChapter;

  SelectBook(Book.title, TModule.IsNewTestament(CurrVerse.book));
  ChapterBox.ItemIndex := CurrVerse.Chapter - 1;

  if select then MemoBible.SelectParagraph(CurrVerse.Number);
  Repaint;
end;

procedure TMainForm.ShowCurrBible;
var
  select : boolean;
begin
  LoadComboBox;
  MakeBookList;
  select := CurrVerse.number > 1;
  {$ifdef linux}
    IdleMessage := 'ShowCurrVerse(' + ToStr(select) + ')';
  {$else}
    ShowCurrVerse(select);
  {$endif}
  UpdateStatus(CurrBible.Info);
end;

function TMainForm.CheckFileSave: boolean;
var
  Response : integer;
begin
  Result := True;
  if not MemoNotes.Modified then Exit;
  SelectPage(apNotes);

  Response := QuestionDlg(' ' + T('Confirmation'), T('Save changes?'),
      mtConfirmation, [mrYes, T('Yes'), mrNo, T('No'), mrCancel, T('Cancel'), 'IsDefault'], 0);

  // remake!!
  case Response of
    idYes:
      begin
        CmdFileSave(self);
        Result := not MemoNotes.Modified;
      end;
    idNo: {nothing};
    idCancel: Result := False;
  end;
end;

procedure TMainForm.OnRecentClick(Sender: TObject);
begin
  if CheckFileSave then PerformFileOpen(RecentList[(Sender as TMenuItem).tag]);
end;

procedure TMainForm.MakeRecentMenu;
var
  MenuItem : TMenuItem;
  item : string;
begin
  miRecent.Enabled := not RecentList.IsEmpty;
  miRecent.Clear;

  for item in RecentList.Reverse do
    begin
      MenuItem := NewItem(ExtractOnlyName(item), 0, False, True, OnRecentClick, 0, '');
      MenuItem.Tag := RecentList.IndexOf(item);
      miRecent.Add(MenuItem);
    end;
end;

function TMainForm.UnboundMemo: TUnboundMemo;
begin
  case PageControl.ActivePageIndex of
    apBible        : Result := MemoBible;
    apCommentaries : Result := MemoCommentary;
    apCompare      : Result := MemoCompare;
    apDictionaries : Result := MemoDictionary;
    apHistory      : Result := MemoHistory;
    apNotes        : Result := MemoNotes;
    apReferences   : Result := MemoReference;
    apSearch       : Result := MemoSearch;
  else
    Result := nil;
  end;
end;

procedure TMainForm.EnableActions;
var
  B, L, H, M, S : boolean;
begin
  B := PageControl.ActivePageIndex = apBible;
  L := PageControl.ActivePageIndex = apNotes;
  H := PageControl.ActivePageIndex = apHistory;
  S := UnboundMemo.SelLength > iif(B,1,0);
  M := UnboundMemo.SelText.Contains(LineBreak); // multiline

  ActionSearchfor.Visible  := S and not M;
  ActionLookup.Visible     := S and not M;
  ActionCopyAs.Enabled     := B;
  ActionCopyVerses.Enabled := B;

  ActionEditCopy.Enabled   := S;
  ActionEditCut.Enabled    := L and S;
  ActionEditDel.Enabled    := L and S;
  ActionEditPaste.Enabled  := L and UnboundMemo.CanPaste;
  ActionEditUndo.Enabled   := L and UnboundMemo.CanUndo;

  ToolButtonNew.Enabled    := L;
  ToolButtonOpen.Enabled   := L;
  ToolButtonPrint.Enabled  := L;
  ToolButtonSave.Enabled   := L;

  ActionFont.Enabled       := L;
  ActionBold.Enabled       := L;
  ActionItalic.Enabled     := L;
  ActionUnderline.Enabled  := L;
  ActionLink.Enabled       := L;
  ActionLeft.Enabled       := L;
  ActionCenter.Enabled     := L;
  ActionRight.Enabled      := L;
  ActionBullets.Enabled    := L;

  ActionInterlinear.Enabled := B and not S and not M;
  ToolButtonSearch.Enabled  := PageControl.ActivePageIndex <> apDictionaries;

  ActionCleanHistory.Enabled := H and not Tools.EmptyHistory;
  pmSeparatorH.Visible       := H;
  pmCleanHistory.Visible     := H;

  UpdateActionImage;
end;

procedure TMainForm.UpDownButtons;
var
  fp : TFontParams;
begin
  if PageControl.ActivePageIndex <> apNotes then Exit;

  with MemoNotes do
    begin
      fp := SelAttributes;

      ToolButtonBold.Down := fsBold in fp.Style;
      ToolButtonItalic.Down := fsItalic in fp.Style;
      ToolButtonUnderline.Down := fsUnderline in fp.Style;
      ToolButtonLink.Down := clNavy = fp.Color;

      case SelParaAlignment of
        paLeft: ToolButtonLeft.Down := True;
        paRight: ToolButtonRight.Down := True;
        paCenter: ToolButtonCenter.Down := True;
      end;

      {$ifdef windows} ToolButtonBullets.Down := SelParaNumbering.Style = pnBullet; {$endif}
    end;
end;

procedure TMainForm.UpdateActionImage;
var
  Action : TContainedAction;
begin
  for Action in ActionList do
    if Action.Tag > 0 then
      if TAction(Action).Enabled
        then TAction(Action).ImageIndex := Action.Tag
        else TAction(Action).ImageIndex := Action.Tag + 1;
end;

procedure TMainForm.RebuildRecentList;
var
  item : string;
begin
  for item in RecentList do
    if item = NoteFileName then
      RecentList.Delete(RecentList.IndexOf(item));

  RecentList.Add(NoteFileName);
  if RecentList.Count > RecentMax then RecentList.Delete(0);
  MakeRecentMenu;
end;

procedure TMainForm.PerformFileOpen(const FileName: string);
begin
  if not FileExists(FileName) then Exit;
  MemoNotes.LoadFromFile(FileName);
  NoteFileName := FileName;
  RebuildRecentList;
  SelectPage(apNotes);
  MemoNotes.SetFocus;
  MemoNotes.Modified := False;
  UpdateCaption(ExtractOnlyName(NoteFileName));
end;

procedure TMainForm.SelectPage(page: integer);
begin
  if page = PageControl.ActivePageIndex then Exit;
  {$ifdef linux} PageControl.ActivePageIndex := 0; {$endif}
  PageControl.ActivePageIndex := page;
  PageControl.ActivePage.TabVisible := true;
  EnableActions;
  RefreshStatus;
  Refresh;
end;

procedure TMainForm.miBibleFolderClick(Sender: TObject);
begin
  if not IsPortable then CreateDataDirectory;
  OpenFolder(DataPath);
end;

procedure TMainForm.miHomeClick(Sender: TObject);
begin
  OpenURL(HomeURL);
end;

procedure TMainForm.miDonateClick(Sender: TObject);
begin
  OpenURL(DonateURL);
//DonateVisited := True;
end;

procedure TMainForm.miDownloadClick(Sender: TObject);
begin
  OpenURL(DownloadsURL);
end;

procedure TMainForm.miIssueClick(Sender: TObject);
begin
  OpenURL(IssueURL);
end;

procedure TMainForm.CmdOptions(Sender: TObject);
begin
  OptionsForm.Show;
end;

procedure TMainForm.IdleTimerTimer(Sender: TObject);
begin
  {$ifdef windows}
  if IdleMessage = 'HideCursor' then HideCursor;
  {$endif}
  {$ifdef linux}
  if IdleMessage = 'ShowCurrVerse(True)'  then ShowCurrVerse(True);
  if IdleMessage = 'ShowCurrVerse(False)' then ShowCurrVerse(False);
  {$endif}
  IdleMessage := '';
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
  EnableActions;
  UpDownButtons;
  RefreshStatus;
  UnboundMemo.Repaint;

  case PageControl.ActivePageIndex of
    apCompare      : CmdCompare(Sender);
    apReferences   : CmdReference(Sender);
    apCommentaries : CmdCommentaries(Sender);
    apDictionaries : CmdDictionaries(Sender);
    apHistory      : CmdHistory(Sender);
    apNotes        : UnboundMemo.SetFocus;
  end;

  {$ifdef windows} IdleMessage := 'HideCursor'; {$endif}
end;

procedure TMainForm.PopupMenuPopup(Sender: TObject);
var
  s : string;
begin
  pmSeparator.Visible := ActionLookup.Visible;

  if not ActionLookup.Visible then Exit;
  s := DoubleQuoted( Trim(UnboundMemo.SelText) );

  pmSearchfor.Caption := StringReplace( T('Search for %'),'%',s,[]);
  pmLookup   .Caption := StringReplace( T('Look Up %')   ,'%',s,[]);
end;

procedure TMainForm.PageControlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    if PageControl.ActivePageIndex = PageControl.IndexOfPageAt(X,Y) then
      if not (PageControl.ActivePageIndex in [apBible, apCompare, apNotes]) then
        PopupTabs.PopUp;
end;

procedure TMainForm.pmCloseClick(Sender: TObject);
begin
  PageControl.ActivePage.TabVisible := False;
end;

procedure TMainForm.ToolButtonDonateClick(Sender: TObject);
begin
  OpenURL(DonateURL);
end;

procedure TMainForm.ToolButtonSearchClick(Sender: TObject);
var
  Pos : TPoint;
begin
  Pos.x := Width - (SearchForm.Width div 2);
  Pos.y := PageControl.Top + 2;
  Pos := ClientToScreen(Pos);
  if SearchForm.ShowAtPos(Pos) = mrOk then LoadSearch(ToolEdit.Text);
end;

//-----------------------------------------------------------------------------------------

procedure TMainForm.MakeBookList;
var
  l : boolean;
begin
  l := BookBox.ItemIndex < 0;
  BookBox.BiDiMode := bdLeftToRight;
  if CurrBible.RightToLeft then BookBox.BiDiMode := bdRightToLeft;
  BookBox.Items.AddStrings(CurrBible.GetTitles, True);
  if l and (BookBox.Count > 0) then BookBox.ItemIndex := 0;
end;

procedure TMainForm.MakeChapterList;
var
  n, i: integer;
begin
  ChapterBox.Items.BeginUpdate;
  ChapterBox.Items.Clear;

  n := CurrBible.ChaptersCount(CurrVerse.book);
  for i := 1 to n do ChapterBox.Items.Add(ToStr(i));

  ChapterBox.ItemIndex := 0;
  ChapterBox.Items.EndUpdate;
end;

//----------------------------------------------------------------------------------------
//                                       Loads
//----------------------------------------------------------------------------------------

procedure TMainForm.LoadChapter;
begin
  MemoBible.LoadText(Tools.Get_Chapter, true);
  SelectPage(apBible);
end;

procedure TMainForm.LoadSearch(s: string);
var
  text : string;
  count : integer;
const
  max = {$ifdef windows}5000{$else}2000{$endif};
begin
  s := Trim(s);
  if Utf8Length(s) < 2 then Exit;

  Cursor := crHourGlass;
  text := Tools.Get_Search(s, count);

  if count = 0 then
    text := T('You search for % produced no results.').Replace('%',DoubleQuoted(s));

  if count > max then text := T('This search returned too many results.') + ' ' +
                              T('Please narrow your search.');

  MemoSearch.LoadText(text);
  Cursor := crArrow;
  SelectPage(apSearch);
  UpdateStatus(ToStr(count) + ' ' + T('verses found'));
end;

procedure TMainForm.LoadCompare;
var text : string;
begin
  text := CurrBible.VerseToStr(CurrVerse) + '<br> ';
  text += Tools.Get_Compare;
  MemoCompare.LoadText(text);
  SelectPage(apCompare);
end;

procedure TMainForm.LoadReference;
var
  text, data: string;
  info : string = '';
begin
  text := CurrBible.VerseToStr(CurrVerse) + '<br><br>';
  data := Tools.Get_Reference(info);
  if data.isEmpty then text += T('Сross-references not found.') else text += data;
  MemoReference.LoadText(text);
  SelectPage(apReferences);
  UpdateStatus(info);
end;

procedure TMainForm.LoadCommentary;
var
  text, data : string;
begin
  text := CurrBible.VerseToStr(CurrVerse) + '<br><br>';
  data := Tools.Get_Commentary;
  text += data;

  if data.isEmpty then text += T('Commentaries not found.') + '<br><br>';

  MemoCommentary.LoadHtml(text);
  SelectPage(apCommentaries);
end;

procedure TMainForm.LoadDictionary(s: string);
var
  text : string = '';
  data : string;
begin
  s := Trim(s);
  data := Tools.Get_Dictionary(s);
  text += data;

  if data.IsEmpty and not s.IsEmpty then
    text += T('You search for % produced no results.').Replace('%',DoubleQuoted(s));

  if s.isEmpty then text := T('Please enter your query in the search bar.');
  text += '<br><br>';

  MemoDictionary.LoadHtml(text);
  SelectPage(apDictionaries);
end;

procedure TMainForm.LoadHistory;
var
  text : string;
begin
  text := Tools.Get_History;
  MemoHistory.LoadText(text);
  SelectPage(apHistory);
end;

procedure TMainForm.LoadStrong(s: string);
var text : string;
begin
  text := Tools.Get_Strong(s);
  if text.isEmpty then Exit;
  NotifyForm.Title.Caption := T('Strong''s Dictionary');
  NotifyForm.Compact := True;
  NotifyForm.Memo.LoadHtml(text);
  NotifyForm.ShowAtPos(Mouse.CursorPos);
  Self.SetFocus;
end;

procedure TMainForm.LoadFootnote(s: string);
var text : string;
begin
  text := Tools.Get_Footnote(s);
  if text.isEmpty then Exit;
  NotifyForm.Title.Caption := T('Footnote');
  NotifyForm.Compact := False;
  NotifyForm.Memo.LoadHtml(text);
  NotifyForm.ShowAtPos(Mouse.CursorPos);
  Self.SetFocus;
end;

{$ifdef windows}
procedure TMainForm.VersesToClipboard;
var
  s, t : string;
begin
  s := Tools.Get_Verses;
  if CopyOptions.cvPlain then CopyForm.RemoveFormat(s);
  t := s.Replace('<br>', LineBreak);
  RichTextToClipboard(ParseWin(s,Font), RemoveTags(t));
end;
{$endif}

{$ifdef unix}
procedure TMainForm.VersesToClipboard;
var
  MemoPreview : TUnboundMemo;
begin
  MemoPreview := TUnboundMemo.Create(self);
  MemoPreview.Parent := MainForm;
  MemoPreview.Font.Assign(Font);
  MemoPreview.LoadText(Tools.Get_Verses);
  MemoPreview.SelectAll;
  MemoPreview.CopyToClipboard;
  MemoPreview.Visible := false;
  MemoPreview.FreeOnRelease;
end;
{$endif}

procedure TMainForm.HideCursor;
begin
  if PageControl.ActivePageIndex <> apNotes then UnboundMemo.HideCursor;
end;

//-------------------------------------------------------------------------------------------------

procedure TMainForm.SaveConfig;
var
  IniFile : TIniFile;
  item : string;
begin
  IniFile := TIniFile.Create(ConfigFile);

  if WindowState = wsNormal then
  begin
    IniFile.WriteInteger('Window', 'Left',   Left);
    IniFile.WriteInteger('Window', 'Top',    Top);
    IniFile.WriteInteger('Window', 'Width',  Width);
    IniFile.WriteInteger('Window', 'Height', Height);
  end;

  if WindowState = wsMaximized then IniFile.WriteString('Window', 'State', 'Maximized')
                               else IniFile.WriteString('Window', 'State', 'Normal');

  IniFile.WriteInteger('Window', 'Splitter', PanelLeft.Width);
  IniFile.WriteString ('Application', 'Interface', Localization.id);
  IniFile.WriteString ('Application', 'FontName', Font.Name);
  IniFile.WriteInteger('Application', 'FontSize', Font.Size);
  IniFile.WriteBool('Copy', 'Abbreviate', CopyOptions.cvAbbreviate);
  IniFile.WriteBool('Copy', 'Enumerated', CopyOptions.cvEnumerated);
  IniFile.WriteBool('Copy', 'Guillemets', CopyOptions.cvGuillemets);
  IniFile.WriteBool('Copy', 'Parentheses', CopyOptions.cvParentheses);
  IniFile.WriteBool('Copy', 'End', CopyOptions.cvEnd);
  IniFile.WriteBool('Copy', 'Break', CopyOptions.cvBreak);
  IniFile.WriteBool('Copy', 'Plain', CopyOptions.cvPlain);
  IniFile.WriteInteger('Recent', 'Count', RecentList.Count);

  for item in RecentList do
    IniFile.WriteString('Recent', 'File_' + RecentList.IndexOf(item).ToString, item);

  IniFile.Free;
end;

procedure TMainForm.ReadConfig;
var
  IniFile : TIniFile;
  i, Count : integer;
begin
  IniFile := TIniFile.Create(ConfigFile);

  Height := IniFile.ReadInteger('Window', 'Height', Screen.Height - 220);
  Width := IniFile.ReadInteger('Window', 'Width', Screen.Width - 450);
  Left := IniFile.ReadInteger('Window', 'Left', 200);
  Top := IniFile.ReadInteger('Window', 'Top', 80);

  PanelLeft.Width := IniFile.ReadInteger('Window', 'Splitter', 270);
  Localization.id := IniFile.ReadString('Application', 'Interface', Localization.DefaultID);
  Font.Name := IniFile.ReadString ('Application', 'FontName', Font.Name);
  Font.Size := IniFile.ReadInteger('Application', 'FontSize', Font.Size);
  CopyOptions.cvAbbreviate := IniFile.ReadBool('Copy', 'Abbreviate', False);
  CopyOptions.cvEnumerated := IniFile.ReadBool('Copy', 'Enumerated', False);
  CopyOptions.cvGuillemets := IniFile.ReadBool('Copy', 'Guillemets', False);
  CopyOptions.cvParentheses := IniFile.ReadBool('Copy', 'Parentheses', False);
  CopyOptions.cvEnd := IniFile.ReadBool('Copy', 'End', False);
  CopyOptions.cvBreak := IniFile.ReadBool('Copy', 'Break', False);
  CopyOptions.cvPlain := IniFile.ReadBool('Copy', 'Plain', False);

  Count := IniFile.ReadInteger('Recent', 'Count', RecentList.Count);
  for i := 0 to Count - 1 do
    RecentList.Add(IniFile.ReadString('Recent', 'File_' + ToStr(i), ''));

  IniFile.Free;
end;

end.

