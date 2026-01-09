unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBCtrls, Grids, DBGrids, Mask, ExtCtrls, Buttons, FileCtrl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Comp.DataSet;


type
  TForm1 = class(TForm)
    Button29: TButton;
    Label4: TLabel;
    ListBoxA: TListBox;
    Label13: TLabel;
    Panel2: TPanel;
    TagFilter: TListBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Timer1: TTimer;
    Panel3: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Button28: TButton;
    ListBoxB: TListBox;
    Button30: TButton;
    StringGrid1: TStringGrid;
    Button31: TButton;
    DataSource1: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button32: TButton;
    Button33: TButton;
    PBSB: TFDConnection;
    PB: TFDQuery;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTransaction1: TFDTransaction;
    DataSource2: TDataSource;
    PBid: TIntegerField;
    PBname: TWideStringField;
    PBfirst: TWideStringField;
    PBphone: TWideStringField;
    PBprefix: TWideStringField;
    PBnotes: TWideMemoField;
    PBaddress1: TWideStringField;
    PBaddress2: TWideStringField;
    PBcity: TWideStringField;
    PBstate: TWideStringField;
    PBzip: TWideStringField;
    PBcountry: TWideStringField;
    PBemail: TWideStringField;
    Button34: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure md2(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBoxBDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormActivate(Sender: TObject);
    procedure FilterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FilterDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PBFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure PBAfterScroll(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PBBeforePost(DataSet: TDataSet);
    procedure Button32Click(Sender: TObject);
    procedure BackupDatabase;
    procedure Button33Click(Sender: TObject);
    procedure RefreshQuery;
    procedure LoadTagsFromDatabase;
    procedure SaveTagsToDatabase;
    procedure Button34Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GlobalFilter:  string;
  FirstDraw:  boolean;
  FirstDrawCount:  integer;

implementation

{$R *.DFM}

procedure TForm1.LoadTagsFromDatabase;
var
  Tags: TFDQuery;
begin
  // Load tags from the database and populate ListBoxA and ListBoxB  //TEST
  ListBoxB.Items.Clear;
  ListBoxA.Items.Clear;
  TagFilter.Items.Clear;

  // Create temporary query
  Tags := TFDQuery.Create(nil);
  try
    Tags.Connection := PBSB;

    // Load tags in display_order for ListBoxB
    Tags.SQL.Text := 'SELECT position, name, display_order FROM public.tags ORDER BY position';
    Tags.Open;

    // Populate ListBoxB (display order) and ListBoxA (position)
    Tags.First;
    while not Tags.Eof do
    begin
      ListBoxB.Items.Add(Tags.FieldByName('name').AsString);
      ListBoxA.Items.Add(IntToStr(Tags.FieldByName('display_order').AsInteger));  // Position is 0-based, store as 1-based
      Tags.Next;
    end;
    Tags.Close;

    // Load tags in position order for TagFilter
    Tags.SQL.Text := 'SELECT position, name FROM public.tags';             //display_order

    Tags.Open;

    Tags.First;
    while not Tags.Eof do
    begin
      TagFilter.Items.Add(Tags.FieldByName('name').AsString);
      Tags.Next;
    end;

  finally
    Tags.Free;
  end;

  TagFilter.Items := ListBoxB.Items;
end;

procedure TForm1.SaveTagsToDatabase;
var
  X: integer;
  Position: integer;
  Tags: TFDQuery;
begin
// Load ListboxA, ListboxB, and TagFilter with updated values from stringgrid1 after reordering in stringgrid1
for x := 0 to 49 do
   begin
   listboxB.items[x] := stringgrid1.cells[0, x+1];
   listboxA.items[x] := stringgrid1.cells[1, x+1];
   end;
TagFilter.items := ListboxB.Items;

// Save tags back to the database
Tags := TFDQuery.Create(nil);
  try
    Tags.Connection := PBSB;

    Tags.SQL.Text := 'SELECT position, name, display_order FROM public.tags ORDER BY position';
    Tags.Open;
    Tags.First;
    for x := 0 to 49 do
    begin
    Tags.Edit;
    Tags.FieldByName('name').AsString := listboxB.items[x];
    Tags.FieldByName('display_order').AsInteger := StrToInt(listboxA.items[x]);
    Tags.Post;
    Tags.Next;
    end;
  finally
    Tags.Close;
    Tags.Free;
  end;

end;

procedure TForm1.RefreshQuery;
begin
  // Helper method to refresh the query with current filters
  PB.Close;
  PB.SQL.Text :=
    'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
    'from public.phonebase ' +
    'where name like :p ' +
    'order by name';
  PB.ParamByName('p').AsString := 'A%';  // Default to 'A'
  PB.Open;

  // If Argo filter is checked, enable filtering
  if CheckBox1.Checked then
    PB.Filtered := True
  else
    PB.Filtered := False;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Ltr: string;
begin
  Ltr := TButton(Sender).Caption;

  // Disable tag filtering when clicking letter buttons
  CheckBox2.Checked := False;

  PB.Close;
  PB.SQL.Text :=
    'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
    'from public.phonebase ' +
    'where name like :p ' +
    'order by name';

  PB.ParamByName('p').AsString := Ltr + '%';
  PB.Open;

  // If Argo filter is checked, enable filtering
  if CheckBox1.Checked then
    PB.Filtered := True
  else
    PB.Filtered := False;
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
  // Show ALL records
  if CheckBox2.Checked then
  begin
    // If tag filtering is enabled, already showing all records
    // Just refresh the filter
    PB.Filtered := False;
    PB.Filtered := True;
  end
  else
  begin
    // If tag filtering is disabled, load all records
    CheckBox2.Checked := False;
    PB.Close;
    PB.SQL.Text :=
      'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
      'from public.phonebase ' +
      'order by name';
    PB.Open;

    // If Argo filter is checked, enable filtering
    if CheckBox1.Checked then
      PB.Filtered := True
    else
      PB.Filtered := False;
  end;
end;

procedure TForm1.Button28Click(Sender: TObject);
begin
  // Insert new record
  PB.Insert;
  PB.FieldByName('country').AsString := 'OXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO';
  ListboxB.Refresh;
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  L, TagOrder:  integer;
  Tag, Flag:  string;
  Column:  TColumn;
begin
  // HIGHLIGHT TAGS IN LISTBOXB
  // Note:  listboxA is the Tag Order
  if not PB.FieldByName('country').IsNull then
    Tag := PB.FieldByName('country').AsString
  else
    Tag := StringOfChar('O', 50);

  for L := 1 to 50 do
  begin
    TagOrder := strtoint(listboxA.items[L-1])-1;
    flag := copy(Tag, L, 1);
    if flag = 'X' then
      listboxB.selected[TagOrder] := true
    else
      listboxB.selected[TagOrder] := false;
  end;
  listboxB.refresh;
  listboxA.refresh;
end;

procedure TForm1.ListBoxBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sel, L, Order:  integer;
  Tag, NewTag:  string;
begin
  // Set Tag
  sel := listboxB.itemindex;

  if not PB.FieldByName('country').IsNull then
    Tag := PB.FieldByName('country').AsString
  else
    Tag := StringOfChar('O', 50);

  label4.caption := inttostr(sel+1);
  listboxB.selected[sel] := false;

  if ListBoxB.items[sel] = '-' then exit;  // No label for this tag - dont select
  Order := strtoint(ListBoxA.items[sel])-1;

  if copy(Tag, order+1, 1) = 'X' then
  begin
    Insert('O', Tag, order+1);
    Delete(tag,order+2,1);
  end
  else
  begin
    Insert('X', Tag, order+1);
    Delete(Tag,order+2,1);
  end;

  // Edit and save the record
  if PB.State = dsBrowse then
    PB.Edit;
  PB.FieldByName('country').AsString := Tag;
  PB.Post;

  Label10.caption := copy(Tag, sel+1, 1);

  DBGrid1.setfocus;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
var
  L:  integer;
  Tag, Flag:  string;
  shift:  TShiftState;
  Key:  word;
begin
  DBGrid1KeyDown(column, Key, shift);
end;

procedure TForm1.md2(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  label4.caption := inttostr(listboxB.itemindex+1);
end;

procedure TForm1.ListBoxBDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  Offset: Integer;
  Tag, Indicator:  String;
  X, Y:  integer;
begin
  if not PB.FieldByName('country').IsNull then
    Tag := PB.FieldByName('country').AsString
  else
    Tag := StringOfChar('O', 50);

  with (Control as TListBox).Canvas do
  begin
    Brush.Color := clWhite;
    Font.Color := clBlack;

    X := strtoint(listboxA.items[index]);
    Indicator := copy(Tag, X, 1);

    if (Indicator = 'X') then Font.Color := clBlue;

    FillRect(Rect);
    Offset := 2;
    Bitmap := TBitmap((Control as TListBox).Items.Objects[Index]);

    if Bitmap <> nil then
    begin
      BrushCopy(Bounds(Rect.Left + 2, Rect.Top, Bitmap.Width, Bitmap.Height),
        Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), clRed);
      Offset := Bitmap.width + 6;
    end;
    TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index])
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  x:  integer;
  button:  Tmousebutton;
  Shift:  TShiftState;
  filter:  string;
begin
  FirstDraw := true;
  FirstDrawCount := 0;
  GlobalFilter := 'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO';

  // Configure id field for auto-increment
  PBid.AutoGenerateValue := arAutoInc;
  PBid.ProviderFlags := [pfInWhere, pfInKey];  // Remove pfInUpdate

  // Connect filter event handler
  PB.OnFilterRecord := PBFilterRecord;

  // Load tag configuration from database
  LoadTagsFromDatabase;

  // SET FORM1 SIZE
  Panel2.visible := true;
  Panel3.left := 5;
  Button32.caption := 'Show Tags';
  Form1.width := 1275;

  // Clear tag filter selections
  for x := 0 to 49 do
    TagFilter.selected[x] := false;
  TagFilter.refresh;

  // Open initial query
  if not PB.Active then
  begin
    PB.SQL.Text :=
      'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
      'from public.phonebase ' +
      'where name like :p ' +
      'order by name';
    PB.ParamByName('p').AsString := 'A%';
    PB.Open;
  end;

  // If Argo filter is checked at startup, enable filtering
  if CheckBox1.Checked then
    PB.Filtered := True;

  listboxB.refresh;
  listboxA.refresh;
  TagFilter.refresh;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// Post any pending edits before closing the app
 if PB.State in [dsEdit, dsInsert] then PB.Post;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// Set path to postgreSQL driver
FDPhysPgDriverLink1.VendorLib := ExtractFilePath(Application.ExeName) + 'postgreSQL_Files\libpq.dll';
end;

procedure TForm1.FilterMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sel, L, Order:  integer;
  Tag, NewTag:  string;
begin
  // FLIP TAGFILTER SELECTED ITEMS
  sel := TagFilter.itemindex;
  Tag := GlobalFilter;
  label4.caption := inttostr(sel+1);
  TagFilter.selected[sel] := false;
  Order := strtoint(ListBoxA.items[sel]);

  if TagFilter.items[sel] = '-' then exit;  // No label for this tag - dont select

  if copy(Tag, order, 1) = 'X' then
  begin
    Insert('O', Tag, order);
    Delete(tag,order+1,1);
  end
  else
  begin
    Insert('X', Tag, order);
    Delete(Tag,order+1,1);
  end;

  GlobalFilter := Tag;
  Label10.caption := copy(Tag, sel+1, 1);

  // Debug: Show what GlobalFilter looks like
  Label13.Caption := 'GlobalFilter: ' + Copy(GlobalFilter, 1, 20) + '...';

  // Enable/disable filtering based on checkbox
  if checkbox2.checked then
  begin
    // When tag filtering is enabled, reload ALL records and apply filter
    PB.Close;
    PB.SQL.Text :=
      'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
      'from public.phonebase ' +
      'order by name';
    PB.Open;
    PB.Filtered := True;
  end
  else
  begin
    PB.Filtered := False;
    RefreshQuery;
  end;
end;

procedure TForm1.FilterDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  Offset: Integer;
  Tag, Indicator:  String;
  X, Y:  integer;
begin
  Tag := GlobalFilter;

  with (Control as TListBox).Canvas do
  begin
    Brush.Color := clWhite;
    Font.Color := clBlack;

    X := strtoint(listboxA.items[index]);
    Indicator := copy(Tag, X, 1);

    if (Indicator = 'X') then Font.Color := clBlue;

    FillRect(Rect);
    Offset := 2;
    Bitmap := TBitmap((Control as TListBox).Items.Objects[Index]);

    if Bitmap <> nil then
    begin
      BrushCopy(Bounds(Rect.Left + 2, Rect.Top, Bitmap.Width, Bitmap.Height),
        Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), clRed);
      Offset := Bitmap.width + 6;
    end;
    TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index])
  end;
end;

procedure TForm1.PBFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  tag:  string;
  Show:  boolean;
  X:  integer;
begin
  Show := false;
  accept := true;

  if not PB.FieldByName('country').IsNull then
    tag := PB.FieldByName('country').AsString
  else
    tag := StringOfChar('O', 50);

  // Debug: Show filter is being called
  Label11.Caption := 'Filter active: ' + Copy(GlobalFilter, 1, 20) + '...';

  // REJECT ALL ARGO RECORDS IF CHECKED (tag position 1 = 'X')
  // This works independently of tag filtering
  if (Length(tag) > 0) and (copy(tag, 1, 1) = 'X') and checkbox1.checked then
  begin
    accept := false;
    exit;  // Don't process further - this record is rejected
  end;

  // Check tags if filtering enabled
  if Checkbox2.checked = true then
  begin
    accept := false;
    for x := 1 to 50 do
    begin
      if (Length(tag) >= x) and (copy(tag, x, 1) = 'X') and
         (copy(GlobalFilter, x, 1) = 'X') then
      begin
        accept := true;
        break;  // Found a match, no need to check further
      end;
    end;
  end;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  // Handle both CheckBox1 (Hide Argo) and CheckBox2 (Filter by Tags)

  if CheckBox2.Checked then
  begin
    // When tag filtering is enabled, load ALL records
    PB.Close;
    PB.SQL.Text :=
      'select id, name, first, phone, prefix, address1, address2, city, state, zip, country, email, notes ' +
      'from public.phonebase ' +
      'order by name';
    PB.Open;
    PB.Filtered := True;
  end
  else if CheckBox1.Checked then
  begin
    // Tag filtering is off, but Argo filter is on
    // Need to enable filtering for Argo filter to work
    PB.Filtered := True;
  end
  else
  begin
    // Both filters are disabled, go back to letter-filtered view
    PB.Filtered := False;
    RefreshQuery;  // This will apply the current letter filter (A, B, C, etc.)
  end;
end;

procedure TForm1.Button30Click(Sender: TObject);
var
  X:  integer;
begin
  // EDIT TAGS
  // TRANSFER STRING GRID UPDATED TAGS BACK TO LISTBOXB
  for x := 0 to 49 do
  begin
    listboxB.items[x] := stringgrid1.cells[0, x+1];
    listboxA.items[x] := stringgrid1.cells[1, x+1];
  end;
  TagFilter.items := ListboxB.Items;

  // Save tags to database instead of files
  SaveTagsToDatabase;

    Panel3.left := 330;
    Panel2.visible := true;
    TButton(sender).caption := 'Hide Tags';
    Form1.width := 1905;
  exit;
end;

procedure TForm1.Button31Click(Sender: TObject);
var
  X:  integer;
begin
  // EDIT TAGS
  // POPULATE STRING GRID WITH TAGS FROM LISTBOXB
  for x := 0 to 49 do
  begin
    stringgrid1.cells[0, x+1] := listboxB.items[x];
    stringgrid1.cells[1, x+1] := listboxA.items[x];
  end;
  Form1.width := 2915;
end;

procedure TForm1.PBAfterScroll(DataSet: TDataSet);
begin
  label12.caption := 'Entries Shown: ' + inttostr(PB.RecordCount);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  temp0, temp1:  String;
  SelectedRow:  integer;
begin
  // MOVE SELECTED ROW UP ONE ROW
  SelectedRow := stringgrid1.row;
  if (SelectedRow = 1) then exit;

  // Swap Rows
  Temp0 := stringgrid1.cells[0, SelectedRow-1];
  Temp1 := stringgrid1.cells[1, SelectedRow-1];

  stringgrid1.cells[0, SelectedRow-1] := stringgrid1.cells[0, SelectedRow];
  stringgrid1.cells[1, SelectedRow-1] := stringgrid1.cells[1, SelectedRow];

  stringgrid1.cells[0, SelectedRow] := Temp0;
  stringgrid1.cells[1, SelectedRow] := Temp1;

  Stringgrid1.Row := Stringgrid1.Row - 1;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  temp0, temp1:  String;
  SelectedRow:  integer;
begin
  // MOVE SELECTED ROW DOWN ONE ROW
  SelectedRow := stringgrid1.row;
  if (SelectedRow = 50) then exit;

  // Swap Rows
  Temp0 := stringgrid1.cells[0, SelectedRow+1];
  Temp1 := stringgrid1.cells[1, SelectedRow+1];

  stringgrid1.cells[0, SelectedRow+1] := stringgrid1.cells[0, SelectedRow];
  stringgrid1.cells[1, SelectedRow+1] := stringgrid1.cells[1, SelectedRow];

  stringgrid1.cells[0, SelectedRow] := Temp0;
  stringgrid1.cells[1, SelectedRow] := Temp1;

  Stringgrid1.Row := Stringgrid1.Row + 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  x:  integer;
begin
  for x := 0 to 49 do
    TagFilter.selected[x] := false;
  TagFilter.refresh;
  timer1.enabled := false;
end;

procedure TForm1.PBBeforePost(DataSet: TDataSet);
begin
  // Validation can be added here if needed
  // Example: if PB.FieldByName('name').AsString = '' then
  //   raise Exception.Create('Name cannot be empty');
end;

procedure TForm1.Button32Click(Sender: TObject);
begin
  if TButton(sender).caption = 'Hide Tags' then
  begin
    Panel2.visible := true;
    Panel3.left := 5;
    TButton(sender).caption := 'Show Tags';
    Form1.width := 1275;
    exit;
  end;

  if Tbutton(sender).caption = 'Show Tags' then
  begin
    Panel3.left := 330;
    Panel2.visible := true;
    TButton(sender).caption := 'Hide Tags';
    Form1.width := 1905;
    exit;
  end;
end;

procedure TForm1.BackupDatabase;
var
  BackupDir, DateDir, SourceFile, DestFile: string;
  DateString: string;
  i: Integer;
  FilesToCopy: array[0..2] of string;
begin
  // Note: With Supabase/PostgreSQL, you may want to implement a different backup strategy
  // This keeps the old BDE file backup for now, but you should consider:
  // 1. Using pg_dump for PostgreSQL backups
  // 2. Relying on Supabase's built-in backup features
  // 3. Exporting data to CSV/JSON for portability

  PB.Active := false;

  BackupDir := ExtractFilePath(ParamStr(0)) + 'BackupDB\';
  DateString := FormatDateTime('yyyy-mm-dd', Now);
  DateDir := BackupDir + 'DB' + DateString + '\';

  if not DirectoryExists(BackupDir) then
    CreateDir(BackupDir);

  if not DirectoryExists(DateDir) then
    CreateDir(DateDir);

  FilesToCopy[0] := 'PhonebaseBDE.db';
  FilesToCopy[1] := 'PhonebaseBDE.MB';
  FilesToCopy[2] := 'PhonebaseBDE.PX';

  for i := 0 to High(FilesToCopy) do
  begin
    SourceFile := ExtractFilePath(ParamStr(0)) + FilesToCopy[i];
    DestFile := DateDir + ExtractFileName(FilesToCopy[i]);
    if FileExists(SourceFile) then
    begin
      if not CopyFile(PChar(SourceFile), PChar(DestFile), False) then
        ShowMessage('Failed to copy ' + FilesToCopy[i]);
    end
    else
      ShowMessage('Source file not found: ' + FilesToCopy[i]);
  end;

  PB.Active := true;

  ShowMessage('Backup completed to ' + DateDir);
end;

procedure TForm1.Button33Click(Sender: TObject);
begin
  BackupDatabase;
end;

procedure TForm1.Button34Click(Sender: TObject);
begin
    //Restore form state to "Show Tags"
    Panel3.left := 330;
    Panel2.visible := true;
    Form1.width := 1905;
end;

end.

