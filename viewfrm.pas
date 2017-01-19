unit viewfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, Scene;

const
  d2r = pi / 180.0;
  r2d = 180.0 / pi;
  ViewSize = 1000;
  ViewDivisions = 10;
  ViewRange = 20.0;
  CameraSize = 5;

type
  TViewType = (vtFront, vtBack, vtTop, vtBottom, vtLeft, vtRight, vtCamera);

  TViewForm = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    ExitItem: TMenuItem;
    N1: TMenuItem;
    PrintSetupItem: TMenuItem;
    PrintItem: TMenuItem;
    N2: TMenuItem;
    SaveAsItem: TMenuItem;
    SaveItem: TMenuItem;
    N3: TMenuItem;
    CloseItem: TMenuItem;
    OpenItem: TMenuItem;
    NewItem: TMenuItem;
    EditMenu: TMenuItem;
    PasteItem: TMenuItem;
    CopyItem: TMenuItem;
    CutItem: TMenuItem;
    N6: TMenuItem;
    UndoItem: TMenuItem;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    ViewMenu: TMenuItem;
    FrontItem: TMenuItem;
    BackItem: TMenuItem;
    N4: TMenuItem;
    TopItem: TMenuItem;
    BottomItem: TMenuItem;
    N5: TMenuItem;
    LeftItem: TMenuItem;
    RightItem: TMenuItem;
    N7: TMenuItem;
    CameraItem: TMenuItem;
    N8: TMenuItem;
    FourViewsItem: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure FourViewsItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
  private
    { Private declarations }
    FView: TViewType;
    FScene: TSceneData;
  protected
    procedure SetView(AValue: TViewType);
    function GetFilename: string;
    procedure SetFilename(AValue: string);
    procedure SetCaption;
    function GetModified: boolean;
    procedure SetModified(AValue: boolean);
  public
    { Public declarations }
    procedure CenterView;
    procedure CreateScene;
    procedure LoadScene;
    procedure SetScene(scene: TSceneData; view: TViewType);
  published
    property View: TViewType read FView write SetView;
    property Filename: string read GetFilename write SetFilename;
    property Modified: boolean read GetModified write SetModified;
  end;

implementation

uses Main;

{$R *.DFM}

procedure TViewForm.CenterView;
begin
  with ScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - Width div 2;
    VertScrollBar.Position := ViewSize - Height div 2;
  end;
end;

procedure TViewForm.SetCaption;
var
  s, v: string;

begin
  s := 'View - ' + ExtractFileName(Filename);

  case FView of
    vtFront:  v := 'Front';
    vtBack:   v := 'Back';
    vtTop:    v := 'Top';
    vtBottom: v := 'Bottom';
    vtLeft:   v := 'Left';
    vtRight:  v := 'Right';
    vtCamera: v := 'Camera';
  end;

  Caption := s + ' [' + v + ']';
end;

procedure TViewForm.SetView(AValue: TViewType);
begin
  FView := AValue;
  SetCaption;
end;

procedure TViewForm.SetFilename(AValue: string);
begin
  FScene.Filename := AValue;
  SetCaption;
end;

function TViewForm.GetFilename: string;
begin
  result := FScene.Filename;
end;

function TViewForm.GetModified: boolean;
begin
  result := FScene.Modified;
end;

procedure TViewForm.SetModified(AValue: boolean);
begin
  FScene.Modified := AValue;
end;

procedure TViewForm.CreateScene;
begin
  FScene := TSceneData.Create(Application);
  FScene.AddView(Self);
end;

procedure TViewForm.LoadScene;
begin
end;

procedure TViewForm.SetScene(scene: TSceneData; view: TViewType);
begin
  FScene := scene;
  FView := view;
  SetCaption;
end;

procedure TViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TViewForm.FormShow(Sender: TObject);
begin
  CenterView;
end;

procedure TViewForm.FormCreate(Sender: TObject);
begin
  FView := vtFront;
end;

procedure TViewForm.NewItemClick(Sender: TObject);
begin
  MainForm.FileNew(Self);
end;

procedure TViewForm.ExitItemClick(Sender: TObject);
begin
  MainForm.FileExit(Self);
end;

procedure TViewForm.FourViewsItemClick(Sender: TObject);
var
  view: TViewForm;

begin
  WindowState := wsMinimized;

  view := TViewForm.Create(Application);
  view.SetScene(FScene, vtFront);

  view := TViewForm.Create(Application);
  view.SetScene(FScene, vtTop);

  view := TViewForm.Create(Application);
  view.SetScene(FScene, vtLeft);

  view := TViewForm.Create(Application);
  view.SetScene(FScene, vtCamera);

  MainForm.Tile;
end;

procedure TViewForm.FormDestroy(Sender: TObject);
begin
  FScene.RemoveView(Self);
end;

procedure TViewForm.PaintBoxPaint(Sender: TObject);
begin
  with PaintBox.Canvas do
  begin
    Pen.Color := clGray;
    
    MoveTo(0, ViewSize);
    LineTo(ViewSize * 2, ViewSize);

    MoveTo(ViewSize, 0);
    LineTo(ViewSize, ViewSize * 2);
  end;
end;

end.
