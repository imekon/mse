//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 1, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//

// Author: Pete Goodwin (mse@imekon.org)

unit main;

interface

uses
  System.UITypes, System.Contnrs, System.IOUtils, System.JSON,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, VCL.Graphics,
  VCL.Forms, VCL.Controls, VCL.Menus,
  VCL.Dialogs, VCL.StdCtrls, VCL.Buttons, VCL.ExtCtrls, VCL.ComCtrls, System.Win.Registry, Texture, Halo, VCL.Tabs,
  Scene, VCL.ToolWin, VCL.ImgList, VCL.ActnList, System.ImageList, System.Actions;

{$INCLUDE DirectX.inc}

{$IFNDEF USE_DIRECTX}
resourcestring
  DirectXUnavailable = 'DirectX is not available in this version of Model Scene Editor';
{$ENDIF}

const
  // 14 - removed SMPL support
  // 15 - switch to sets for various flags
  ModelVersion  = 15;

  crTranslate   = 1;
  crScale       = 2;
  crRotate      = 3;

  ModelKey      = 'SOFTWARE\GNU\Model Scene Editor\Setup';

  ModelImage    = 'mse.exe';

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    OpenItem: TMenuItem;
    SaveAsItem: TMenuItem;
    ExitItem: TMenuItem;
    ExitSeparator: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    StatusBar: TStatusBar;
    TexturePanel: TPanel;
    TextScrollBox: TScrollBox;
    TextPaintBox: TPaintBox;
    MainScrollBox: TScrollBox;
    ShapePanel: TPanel;
    MainPaintBox: TPaintBox;
    EditMenu: TMenuItem;
    PasteItem: TMenuItem;
    CopyItem: TMenuItem;
    CutItem: TMenuItem;
    CameraBtn: TSpeedButton;
    DeleteItem: TMenuItem;
    NewItem: TMenuItem;
    ObjectMenu: TMenuItem;
    CreateItem: TMenuItem;
    N3: TMenuItem;
    SelectItem: TMenuItem;
    TranslateItem: TMenuItem;
    ScaleItem: TMenuItem;
    RotateItem: TMenuItem;
    CameraItem: TMenuItem;
    N5: TMenuItem;
    PlaneItem: TMenuItem;
    PlaneBtn: TSpeedButton;
    ViewTabs: TTabSet;
    SphereBtn: TSpeedButton;
    ConeBtn: TSpeedButton;
    LightBtn: TSpeedButton;
    LightPopup: TPopupMenu;
    PointPopup: TMenuItem;
    SpotPopup: TMenuItem;
    AreaPopup: TMenuItem;
    CylinderBtn: TSpeedButton;
    SolidBtn: TSpeedButton;
    LightItem: TMenuItem;
    PointItem: TMenuItem;
    SpotItem: TMenuItem;
    AreaItem: TMenuItem;
    SphereItem: TMenuItem;
    ConeItem: TMenuItem;
    CylinderItem: TMenuItem;
    SolidItem: TMenuItem;
    CubeBtn: TSpeedButton;
    CubeItem: TMenuItem;
    N6: TMenuItem;
    OptionsMenu: TMenuItem;
    GridItem: TMenuItem;
    ZoomItem: TMenuItem;
    PolygonBtn: TSpeedButton;
    N7: TMenuItem;
    PolygonItem: TMenuItem;
    ImportItem: TMenuItem;
    ExportItem: TMenuItem;
    N8: TMenuItem;
    SelectBtn: TSpeedButton;
    TranslateBtn: TSpeedButton;
    ScaleBtn: TSpeedButton;
    RotateBtn: TSpeedButton;
    N4: TMenuItem;
    SettingsItem: TMenuItem;
    RenderItem: TMenuItem;
    UserDefinedBtn: TSpeedButton;
    UserDefinedItem: TMenuItem;
    N9: TMenuItem;
    LoadTexturesItem: TMenuItem;
    SaveTexturesItem: TMenuItem;
    HelpIndexItem: TMenuItem;
    HeightFieldItem: TMenuItem;
    N10: TMenuItem;
    UnionItem: TMenuItem;
    IntersectionItem: TMenuItem;
    DifferenceItem: TMenuItem;
    N11: TMenuItem;
    GalleryItem: TMenuItem;
    BlobItem: TMenuItem;
    SelectAllItem: TMenuItem;
    ClearItem: TMenuItem;
    N2: TMenuItem;
    BrowserItem: TMenuItem;
    N13: TMenuItem;
    BicubicPatchItem: TMenuItem;
    N14: TMenuItem;
    HeightFieldBtn: TSpeedButton;
    BicubicPatchBtn: TSpeedButton;
    ObserverItem: TMenuItem;
    ObservedItem: TMenuItem;
    N15: TMenuItem;
    ObserverBtn: TSpeedButton;
    ObservedBtn: TSpeedButton;
    DiscItem: TMenuItem;
    TorusItem: TMenuItem;
    DiscBtn: TSpeedButton;
    TorusBtn: TSpeedButton;
    SaveItem: TMenuItem;
    CenterItem: TMenuItem;
    HiddenLineRemovalItem: TMenuItem;
    SuperBtn: TSpeedButton;
    SuperEllipsoidItem: TMenuItem;
    PasteMultipleItem: TMenuItem;
    MergeItem: TMenuItem;
    GroupItem: TMenuItem;
    N17: TMenuItem;
    CylinderPopup: TMenuItem;
    CylinderLightItem: TMenuItem;
    TextBtn: TSpeedButton;
    TextItem: TMenuItem;
    ExtrusionItem: TMenuItem;
    N18: TMenuItem;
    ExtrusionBtn: TSpeedButton;
    LatheBtn: TSpeedButton;
    LatheItem: TMenuItem;
    JuliaFractalItem: TMenuItem;
    HollowItem: TMenuItem;
    N20: TMenuItem;
    ShadowItem: TMenuItem;
    HalosItem: TMenuItem;
    LightShadingItem: TMenuItem;
    N22: TMenuItem;
    OutlineItem: TMenuItem;
    UndoItem: TMenuItem;
    N23: TMenuItem;
    RedoItem: TMenuItem;
    RenderMenu: TMenuItem;
    MegahedronRenderItem: TMenuItem;
    DetailsItem: TMenuItem;
    AnimationItem: TMenuItem;
    AtmosphericMenu: TMenuItem;
    FogItem: TMenuItem;
    N16: TMenuItem;
    LensFlareItem: TMenuItem;
    N24: TMenuItem;
    LensFlare1: TMenuItem;
    LensFlare2: TMenuItem;
    LayersItem: TMenuItem;
    LayerItem: TMenuItem;
    PrintItem: TMenuItem;
    PrintSetupItem: TMenuItem;
    N1: TMenuItem;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    CoolBar: TCoolBar;
    EditPanel: TPanel;
    ObjectEditBtn: TSpeedButton;
    InfoBtn: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Name: TEdit;
    XTrans: TEdit;
    YTrans: TEdit;
    ZTrans: TEdit;
    XScale: TEdit;
    YScale: TEdit;
    ZScale: TEdit;
    XRotate: TEdit;
    YRotate: TEdit;
    ZRotate: TEdit;
    ApplyBtn: TBitBtn;
    SkySphereItem: TMenuItem;
    RainbowItem: TMenuItem;
    SpringBtn: TSpeedButton;
    SpringItem: TMenuItem;
    UniformScalingBtn: TSpeedButton;
    UniformScalingItem: TMenuItem;
    TexturesItem: TMenuItem;
    N12: TMenuItem;
    ActionList: TActionList;
    NewAction: TAction;
    OpenAction: TAction;
    SaveAction: TAction;
    SaveAsAction: TAction;
    LoadTextureAction: TAction;
    SaveTextureAction: TAction;
    ImportAction: TAction;
    ExportAction: TAction;
    RenderPOVrayAction: TAction;
    RenderCoolRayAction: TAction;
    PrintAction: TAction;
    PrintSetupAction: TAction;
    ExitAction: TAction;
    ImageList: TImageList;
    CutAction: TAction;
    CopyAction: TAction;
    PasteAction: TAction;
    PasteMultipleAction: TAction;
    UndoAction: TAction;
    RedoAction: TAction;
    DeleteAction: TAction;
    SelectAllAction: TAction;
    ClearAction: TAction;
    TexturesAction: TAction;
    HalosAction: TAction;
    DirectXAction: TAction;
    RenderDirectXItem: TMenuItem;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    GridAction: TAction;
    ZoomAction: TAction;
    InfoAction: TAction;
    ZoomUpAction: TAction;
    ZoomDownAction: TAction;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    EnvBtn: TSpeedButton;
    EnvItem: TMenuItem;
    MainPanel: TPanel;
    ViewPanel: TPanel;
    ViewSplitter: TSplitter;
    FrameBar: TTrackBar;
    FramePanel: TPanel;
    FrameNum: TEdit;
    AnimStop: TSpeedButton;
    AnimPlay: TSpeedButton;
    AnimateBtn: TSpeedButton;
    BarPanel: TPanel;
    PaintBar: TPaintBox;
    AnimationTimer: TTimer;
    StopAction: TAction;
    PlayAction: TAction;
    procedure ShowHint(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure OpenItemClick(Sender: TObject);
    procedure SaveAsItemClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TextPaintBoxPaint(Sender: TObject);
    procedure TextPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LightBtnClick(Sender: TObject);
    procedure NewItemClick(Sender: TObject);
    procedure MainPaintBoxPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ViewTabsClick(Sender: TObject);
    procedure ViewTabsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ApplyEnable(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectItemClick(Sender: TObject);
    procedure TranslateItemClick(Sender: TObject);
    procedure ScaleItemClick(Sender: TObject);
    procedure RotateItemClick(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure TranslateBtnClick(Sender: TObject);
    procedure ScaleBtnClick(Sender: TObject);
    procedure RotateBtnClick(Sender: TObject);
    procedure CameraItemClick(Sender: TObject);
    procedure PointItemClick(Sender: TObject);
    procedure SpotItemClick(Sender: TObject);
    procedure AreaItemClick(Sender: TObject);
    procedure PlaneItemClick(Sender: TObject);
    procedure SphereItemClick(Sender: TObject);
    procedure CubeItemClick(Sender: TObject);
    procedure GridItemClick(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure ConeItemClick(Sender: TObject);
    procedure CylinderItemClick(Sender: TObject);
    procedure SolidItemClick(Sender: TObject);
    procedure PolygonItemClick(Sender: TObject);
    procedure ObjectEditBtnClick(Sender: TObject);
    procedure InfoBtnClick(Sender: TObject);
    procedure FileInfoBtnClick(Sender: TObject);
    procedure ExportItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure RenderItemClick(Sender: TObject);
    procedure MainPaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ImportItemClick(Sender: TObject);
    procedure UserDefinedItemClick(Sender: TObject);
    procedure LoadTexturesItemClick(Sender: TObject);
    procedure SaveTexturesItemClick(Sender: TObject);
    procedure HelpIndexItemClick(Sender: TObject);
    procedure HeightFieldItemClick(Sender: TObject);
    procedure UnionItemClick(Sender: TObject);
    procedure IntersectionItemClick(Sender: TObject);
    procedure DifferenceItemClick(Sender: TObject);
    procedure GalleryItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure ClearItemClick(Sender: TObject);
    procedure MainPaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BrowserItemClick(Sender: TObject);
    procedure BlobItemClick(Sender: TObject);
    procedure BicubicPatchItemClick(Sender: TObject);
    procedure ObserverItemClick(Sender: TObject);
    procedure ObservedItemClick(Sender: TObject);
    procedure SettingsItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DiscItemClick(Sender: TObject);
    procedure TorusItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure CenterItemClick(Sender: TObject);
    procedure HiddenLineRemovalItemClick(Sender: TObject);
    procedure SuperEllipsoidItemClick(Sender: TObject);
    procedure PasteMultipleItemClick(Sender: TObject);
    procedure MergeItemClick(Sender: TObject);
    procedure CylinderLightItemClick(Sender: TObject);
    procedure TextItemClick(Sender: TObject);
    procedure ExtrusionItemClick(Sender: TObject);
    procedure LatheItemClick(Sender: TObject);
    procedure JuliaFractalItemClick(Sender: TObject);
    procedure ObjectMenuClick(Sender: TObject);
    procedure HollowItemClick(Sender: TObject);
    procedure ShadowItemClick(Sender: TObject);
    procedure HalosItemClick(Sender: TObject);
    procedure LightShadingItemClick(Sender: TObject);
    procedure OutlineItemClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure UndoItemClick(Sender: TObject);
    procedure FogItemClick(Sender: TObject);
    procedure ScaleUpBtnClick(Sender: TObject);
    procedure ScaleDownBtnClick(Sender: TObject);
    procedure LensFlareItemClick(Sender: TObject);
    procedure LayersItemClick(Sender: TObject);
    procedure PrintItemClick(Sender: TObject);
    procedure PrintSetupItemClick(Sender: TObject);
    procedure SpringItemClick(Sender: TObject);
    procedure UniformScalingBtnClick(Sender: TObject);
    procedure TexturesItemClick(Sender: TObject);
    procedure DirectXActionExecute(Sender: TObject);
    procedure MRUFileListMRUItemClick(Sender: TObject;
      AFilename: TFileName);
    procedure RenderCoolRayActionExecute(Sender: TObject);
    procedure EnvBtnClick(Sender: TObject);
    procedure FrameBarChange(Sender: TObject);
    procedure PaintBarPaint(Sender: TObject);
    procedure AnimationTimerTimer(Sender: TObject);
    procedure StopActionExecute(Sender: TObject);
    procedure PlayActionExecute(Sender: TObject);
  private
    { Private declarations }
    CurrentTexture: TTexture;
    NewSceneFile: boolean;
    Filename: string;
    ModifiedTextures: boolean;

    function TextureHitTest(X: integer): TTexture;
    function QueryModified: boolean;

    procedure BlankScene;
    procedure SimpleScene;
    procedure SceneWizard;

    procedure LoadHalos(const Name: string);
    procedure SaveHalos(const Name: string);
    procedure LoadTexture(source: TStream);
    procedure LoadTextures(const Name: string);
    procedure SaveTextures(const Name: string);
    procedure ImportMap(const Name: string);
    procedure ImportUDO(const name: string);
    procedure SetCaption(const Name: string);
  public
    { Public declarations }
    ModifiedHalos: boolean;
    Palette: HPALETTE;
    ClipForm, PolygonClipForm, ColourClipForm: UINT;
    POVCommand, POVimageSize, CoolRayCommand: string;
    POVexit: boolean;
    TextureVersion: integer;
    Halos: TList;
    Textures: TList;
    ObjectGallery: TList;
    SceneData: TSceneData;

    procedure CenterView;
    procedure SetCurrent;
    procedure SetSelect;
    procedure SetTexture(texture: TTexture);
    function FindTexture(const Name: string): TTexture;
    function FindHalo(const Name: string): THalo;
    procedure BuildTextureList(list: TComboBox);
    function CreateGallery: TShape;
    procedure Modify(shape: TShape);
    function GetPOVrayCommandString(const OutputFile: string; Width, Height, OutputType: integer; Wait: boolean): string;
  end;

var
  MainForm: TMainForm;

implementation

uses About, newscene, Plane, Sphere, Light, Cube, grid, zoom, Solid,
  Polygon, fileinfo, misc, scenewizdlg, user, checker, brick, hexagon,
  maptext, htfld, gallery, renderdlg, browser, Bicubic, Disc,
  Torus, settings, super, text, julia, halosdlg, rendmega,
  fogdlg, findtext, layers, printers, spring, textform, expopt,
  tracdbg, dxfrm, scripted, Splash, coolray, env;

{$R *.DFM}

procedure TMainForm.SetCaption(const Name: string);
begin
  Caption := ExtractFileName(Name) + ' - Model Scene Editor';
end;

function TMainForm.FindTexture(const Name: string): TTexture;
var
  i: integer;
  texture: TTexture;

begin
  result := nil;
  for i := 0 to Textures.Count - 1 do
  begin
    texture := Textures[i];
    if Texture.Name = name then
    begin
      result := texture;
      Break;
    end;
  end;
end;

function TMainForm.FindHalo(const Name: string): THalo;
var
  i: integer;
  halo: THalo;

begin
  result := nil;
  for i := 0 to Halos.Count - 1 do
  begin
    halo := Halos[i];
    if halo.Name = Name then
    begin
      result := halo;
      break;
    end;
  end;
end;

procedure TMainForm.ImportMap(const Name: string);
var
  i: integer;
  map: TextFile;
  line, value, r, g, b: string;
  maptext: TMapTexture;
  mapitem: TMapItem;

begin
  Screen.Cursor := crHourglass;
  AssignFile(map, Name);
  try
    maptext := TMapTexture.Create;

    maptext.Name := ExtractFileName(Name);
    maptext.MapType := tiBozo;

    i := Pos('.', maptext.Name);
    if i > 0 then
      maptext.Name := Copy(maptext.Name, 1, i - 1);

    Reset(map);
    while not eof(map) do
    begin
      ReadLn(map, line);

      // Locate '[' if there is one
      i := Pos('[', line);

      if i > 0 then
      begin
        // Get the value
        line := Copy(line, i + 1, 255);
        i := Pos(' ', line);
        value := Copy(line, 1, i - 1);

        // Get the red value
        i := Pos('<', line);
        line := Copy(line, i + 1, 255);
        i := Pos(',', line);
        r := Copy(line, 1, i - 1);

        // Get the green value
        line := Copy(line, i + 1, 255);
        i := Pos(',', line);
        g := Copy(line, 1, i - 1);

        // Get the blue value
        line := Copy(line, i + 1, 255);
        i := Pos('>', line);
        b := Copy(line, 1, i - 1);

        mapitem := TMapItem.Create;

        mapitem.Value := StrToFloat(value);
        mapitem.Red := StrToFloat(r);
        mapitem.Green := StrToFloat(g);
        mapitem.Blue := StrToFloat(b);

        maptext.Maps.Add(mapitem);
      end;
    end;
    Textures.Add(maptext);
    TextPaintBox.Width := Textures.Count * TextSize;
    TextPaintBox.Refresh;
  finally
    CloseFile(map);
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.ImportUDO(const name: string);
begin
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text := Application.Hint;
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.OpenItemClick(Sender: TObject);
begin
  OpenDialog.DefaultExt := 'msf';
  OpenDialog.Filter := 'Scene (*.msf)|*.msf';
  if OpenDialog.Execute then
  begin
    NewSceneFile := False;
    Filename := OpenDialog.Filename;
    SceneData.LoadFromFile(Filename);
    MainPaintBox.Refresh;
    SetCaption(Filename);
    //MRUFileList.AddItem(Filename);
  end;
end;

procedure TMainForm.SaveAsItemClick(Sender: TObject);
begin
  SaveDialog.Filename := Filename;
  SaveDialog.DefaultExt := 'msf';
  SaveDialog.Filter := 'Scene (*.msf)|*.msf';
  if SaveDialog.Execute then
  begin
    Filename := SaveDialog.Filename;
    SceneData.Save(Filename);
    SetCaption(Filename);
    //MRUFileList.AddItem(Filename);
  end;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
var
  dlg: TAboutBox;

begin
  dlg := TAboutBox.Create(Application);
  dlg.ShowModal;
  dlg.Free;
end;

procedure DisplaySplashScreen;
begin
  SplashScreen := TSplashScreen.Create(Application);
  SplashScreen.Show;
  SplashScreen.Refresh;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  x: integer;
  texture: TTexture;
  source: TextFile;
  par, name: string;
  r, g, b: double;
  reg: TRegistry;

begin
  if ParamCount = 0 then
    DisplaySplashScreen
  else
  begin
    par := ParamStr(1);

    if (par[1] <> '/') and (par[1] <> '-') then
      DisplaySplashScreen;
  end;

  Application.OnHint := ShowHint;

  ClipForm := RegisterClipboardFormat('Model Scene Editor');
  PolygonClipForm := RegisterClipboardFormat('Model Polygon');
  ColourClipForm := RegisterClipboardFormat('Model Colour');

  NewSceneFile := True;
  Filename := 'Untitled';

  Palette := CreateHalftonePalette(Canvas.Handle);

  CurrentTexture := nil;

  reg := TRegistry.Create;

  reg.RootKey := HKEY_LOCAL_MACHINE;

  //////////////////////////////////////////////////////////////////////////////
  // Get location of POVray engine
  // V3.1 key
  if reg.OpenKey('SOFTWARE\POV-Ray\CurrentVersion\Windows', false) then
  begin
    POVCommand := reg.ReadString('Home') + '\bin\pvengine.exe';

    reg.CloseKey;
  end
  else
  begin
    // Try V3.0 key
    if reg.OpenKey('SOFTWARE\POV-Ray\Windows', false) then
    begin
      POVCommand := reg.ReadString('Home') + '\bin\pvengine.exe';
      reg.CloseKey;
    end;
  end;

  //////////////////////////////////////////////////////////////////////////////

  reg.RootKey := HKEY_LOCAL_MACHINE;

  if reg.OpenKey(ModelKey, false) then
  begin
    if reg.ValueExists('ImageSize') then
      POVimageSize := Reg.ReadString('ImageSize')
    else
      POVimageSize := '160x120';

    if reg.ValueExists('ImageExit') then
      POVexit := Reg.ReadBool('ImageExit')
    else
      POVexit := true;

    if reg.ValueExists('CoolRayPath') then
      CoolRayCommand := Reg.ReadString('CoolRayPath');

    reg.CloseKey;
  end;

  reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(ModelKey, false) then
  begin
    // Main Window position
    if reg.ValueExists('MainWindowLeft') then
      x := Reg.ReadInteger('MainWindowLeft')
    else
      x := -1;

    if x <> -1 then
    begin
      Left := x;
      Top := Reg.ReadInteger('MainWindowTop');
      Width := Reg.ReadInteger('MainWindowWidth');
      Height := Reg.ReadInteger('MainWindowHeight');
    end;

    reg.CloseKey;
  end;

  reg.Free;

  TextureVersion := ModelVersion;
  Halos := TList.Create;
  Textures := TList.Create;
  ModifiedHalos := false;
  ModifiedTextures := False;

  ObjectGallery := TList.Create;

  SceneData := TSceneData.Create;

  // Load halos (if they exist)
  if FileExists('Halos.mhf') then
    LoadHalos('Halos.mhf');

  // Load textures
  //
  //  Try textures.mtf first,
  //  then try textures.mlb,
  //  if not, then give up!
  name := GetModelDirectory + '\Textures.mtf';

  if FileExists(name) then
    LoadTextures(name)
  else
  begin
    name := GetModelDirectory + '\Textures.mlb';

    if FileExists(name) then
    begin
      AssignFile(source, name);
      try
        Screen.Cursor := crHourglass;
        Reset(source);
        while not eof(source) do
        begin
          readln(source, name);
          readln(source, r, g, b);

          texture := TTexture.Create;

          texture.Name := name;
          texture.Red := r;
          texture.Green := g;
          texture.Blue := b;

          Textures.Add(texture);
        end;
        CloseFile(source);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;

  TextPaintBox.Width := Textures.Count * TextSize;

  // Load file parameter (if there is one)
  if ParamCount > 0 then
  begin
    NewSceneFile := False;
    Filename := ParamStr(1);

    // Make sure it's not a command
    if (Filename[1] <> '/') and (Filename[1] <> '-') then
    begin
      SceneData.LoadFromFile(ParamStr(1));
      SetCaption(Filename);
    end;
  end;

  // Load cursors
{$IFDEF USE_SPECIAL_CURSOR}
  Screen.Cursors[crTranslate] := LoadCursor(HInstance, 'Translate');
  Screen.Cursors[crScale] := LoadCursor(HInstance, 'Scale');
  Screen.Cursors[crRotate] := LoadCursor(HInstance, 'Rotate');
{$ENDIF}

  CenterView;
end;

procedure TMainForm.TextPaintBoxPaint(Sender: TObject);
var
  i: integer;
  oldPal: HPALETTE;
  texture: TTexture;
  rect, rect2: TRect;

begin
  with TextPaintBox.Canvas do
  begin
    oldPal := SelectPalette(Handle, Palette, False);
    RealizePalette(Handle);
  end;

  for i := 0 to Textures.Count - 1 do
  begin
    rect.left := i * TextSize;
    rect.right := (i + 1) * TextSize;
    rect.top := 0;
    rect.bottom := TextSize;

    if IntersectRect(rect2, rect, TextPaintBox.Canvas.ClipRect) then
    begin
      texture := Textures[i];
      texture.Draw(i * TextSize, TextPaintBox.Canvas);
    end;
  end;

  SelectPalette(TextPaintBox.Canvas.Handle, oldPal, False);
end;

function TMainForm.TextureHitTest(X: integer): TTexture;
var
  i: integer;

begin
  i := X div TextSize;
  if (i >= 0) and (i < Textures.Count) then
    result := Textures[i]
  else
    result := nil;
end;

procedure TMainForm.TextPaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  texture: TTexture;

begin
  texture := TextureHitTest(X);
  if texture <> nil then
    TextPaintBox.Hint := '|Texture: ' + texture.Name;
end;

procedure TMainForm.SetTexture(texture: TTexture);
begin
  if CurrentTexture <> nil then
    CurrentTexture.Selected := False;

  if texture <> nil then
  begin
    texture.Selected := True;
    CurrentTexture := texture;
  end
  else
    CurrentTexture := nil;

  TextPaintBox.Refresh;
end;

procedure TMainForm.TextPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  texture: TTexture;

begin
  texture := TextureHitTest(X);
  SetTexture(texture);

  SceneData.SetTexture(texture);
  MainPaintBox.Refresh;
end;

procedure TMainForm.LightBtnClick(Sender: TObject);
var
  p, q: TPoint;

begin
  p.X := LightBtn.Left;
  p.Y := LightBtn.Top + LightBtn.Height;
  q := ShapePanel.ClientToScreen(p);
  LightPopup.Popup(q.X, q.Y);
end;

function TMainForm.QueryModified: boolean;
begin
  result := False;
  if ModifiedHalos or ModifiedTextures or SceneData.IsModified then
  begin
    case MessageDlg('Do you wish to save your changes first?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
      begin
        if SceneData.IsModified then
        begin
          if NewSceneFile then
          begin
            SaveDialog.Filename := Filename;
            SaveDialog.DefaultExt := 'msf';
            SaveDialog.Filter := 'Scene (*.msf)|*.msf';
            if SaveDialog.Execute then
            begin
              Filename := SaveDialog.Filename;
              SceneData.SaveToFile(Filename);
            end;
          end
          else
          begin
            SceneData.SaveToFile(Filename);
          end;
        end;

        if ModifiedHalos then
          SaveHalos('halos.mhf');

        if ModifiedTextures then
          SaveTextures('textures.mtf');

        result := True;
      end;
      mrNo: result := True;
      mrCancel: result := False;
    end;
  end
  else
    result := True;
end;

procedure TMainForm.BlankScene;
begin
end;

procedure TMainForm.SimpleScene;
var
  shape: TShape;

begin
  with SceneData do
  begin
    shape := CreateShape(TCamera, 'Camera', 0, 0, 0);
    Shapes.Add(shape);
    SetCamera(shape as TCamera);

    shape := CreateShape(TLight, 'Light', 2, 3, -2);
    Shapes.Add(shape);

    shape := CreateShape(TPlane, 'Floor', 0, -1, 0);
    shape.Rotate.X := 90;
    Shapes.Add(shape);
    shape.Texture := FindTexture('Green');

    shape := CreateShape(TSphere, 'Ball', 0, 1.2, 0);
    Shapes.Add(shape);
    shape.Texture := FindTexture('Blue');

    SetModified;

    Make;
  end;

  MainPaintBox.Refresh;
end;

procedure TMainForm.BuildTextureList(list: TComboBox);
var
  i: integer;
  texture: TTexture;

begin
  for i := 0 to Textures.Count - 1 do
  begin
    texture := Textures[i];
    list.Items.AddObject(texture.Name, texture);
  end;
  list.ItemIndex := 0;
end;

procedure TMainForm.SceneWizard;
var
  x: integer;
  dlg: TSceneWizardDlg;
  shape: TShape;
  camera: TCamera;
  solid: TSolid;
  what: TShapeType;

begin
  dlg := TSceneWizardDlg.Create(Application);

  if dlg.ShowModal = idOK then
  begin
    // Floor
    if dlg.FloorCheck.Checked then
    begin
      shape := SceneData.CreateShape(TPlane, 'Floor', 0, -1, 0);
      shape.Rotate.X := 90;
      SceneData.Shapes.Add(shape);
      shape.Texture :=
        dlg.TextureList.Items.Objects[dlg.TextureList.ItemIndex] as TTexture;
    end;

    // Camera
    shape := SceneData.CreateShape(TCamera, 'Camera', 0, 0, 0);
    camera := shape as TCamera;
    case dlg.CameraList.ItemIndex of
      CameraLeft:   camera.Observer.X := -5;
      CameraRight:  camera.Observer.X := 5;
    end;
    SceneData.Shapes.Add(camera);
    SceneData.SetCamera(camera);

    // Light
    case dlg.LightList.ItemIndex of
      LightLeft:  x := -2;
      LightMid:   x := 0;
      LightRight: x := 2;
    else
      x := 0;
    end;
    shape := SceneData.CreateShape(TLight, 'Light', x, 3, -2);
    SceneData.Shapes.Add(shape);

    // Object
    case dlg.ObjectList.ItemIndex of
      ObjectSphere:               what := TSphere;
      ObjectCone, ObjectCylinder: what := TSolid;
      ObjectCube:                 what := TCube;
    else
      what := nil
    end;
    shape := SceneData.CreateShape(what, 'Object', 0, 1.2, 0);
    shape.Texture :=
      dlg.ObjTextList.Items.Objects[dlg.ObjTextList.ItemIndex] as TTexture;
    case dlg.ObjectList.ItemIndex of
      ObjectCone:
      begin
        solid := shape as TSolid;
        solid.CreateCone;
      end;

      ObjectCylinder:
      begin
        solid := shape as TSolid;
        solid.CreateCylinder;
      end;
    end;
    SceneData.Shapes.Add(shape);

    // Finish up
    SceneData.SetModified;
    SceneData.Make;
    MainPaintBox.Refresh;
  end;

  dlg.Free;
end;

procedure TMainForm.NewItemClick(Sender: TObject);
var
  dlg: TNewSceneDlg;

begin
  if QueryModified then
  begin
    dlg := TNewSceneDlg.Create(Application);
    if dlg.ShowModal = idOK then
    begin
      SceneData.Empty;
      case dlg.ListBox.ItemIndex of
        0: BlankScene;
        1: SimpleScene;
        2: SceneWizard;
      end;
      MainPaintBox.Refresh;
      NewSceneFile := True;
      Filename := 'Untitled';
      SetCaption('Untitled');
    end;
    dlg.Free;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  oldPal: HPALETTE;
  view: TView;

begin
  with MainPaintBox do
  begin
    view := SceneData.GetView;

    oldPal := SelectPalette(Canvas.Handle, Palette, False);
    RealizePalette(Canvas.Handle);

    if view <> vwCamera then
      with Canvas do
      begin
        Pen.Color := clGray;
        MoveTo(0, ViewSize);
        LineTo(ViewSize * 2, ViewSize);
        MoveTo(ViewSize, 0);
        LineTo(ViewSize, ViewSize * 2);
      end;

    SceneData.Draw(Canvas);

    SelectPalette(Canvas.Handle, oldPal, False);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := QueryModified;
end;

procedure TMainForm.ViewTabsClick(Sender: TObject);
begin
  SceneData.GetView;

  case ViewTabs.TabIndex of
    0: SceneData.SetView(vwFront);
    1: SceneData.SetView(vwBack);
    2: SceneData.SetView(vwTop);
    3: SceneData.SetView(vwBottom);
    4: SceneData.SetView(vwLeft);
    5: SceneData.SetView(vwRight);
    6: SceneData.SetView(vwCamera);
  end;

  SceneData.Make;
  MainPaintBox.Refresh;
end;

procedure TMainForm.ViewTabsChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if (NewTab = 6) and (SceneData.GetCamera = nil) then
  begin
    MessageDlg('You need to create or select a camera first', mtError, [mbok], 0);
    AllowChange := False;
  end;
end;

procedure TMainForm.CenterView;
begin
  with MainScrollBox do
  begin
    HorzScrollBar.Position := ViewSize - ClientWidth div 2;
    VertScrollBar.Position := ViewSize - ClientHeight div 2;
  end;
end;

procedure TMainForm.SetCurrent;
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;

  if shape <> nil then
  begin
    Name.Enabled := True;
    Name.Text := Shape.Name;

    if sfCanTranslate in shape.Features then
    begin
      XTrans.Enabled := True;
      YTrans.Enabled := True;
      ZTrans.Enabled := True;

      XTrans.Text := FloatToStrF(shape.Translate.X, ffFixed, 6, 4);
      YTrans.Text := FloatToStrF(shape.Translate.Y, ffFixed, 6, 4);
      ZTrans.Text := FloatToStrF(shape.Translate.Z, ffFixed, 6, 4);
    end
    else
    begin
      XTrans.Enabled := False;
      YTrans.Enabled := False;
      ZTrans.Enabled := False;

      XTrans.Text := '0';
      YTrans.Text := '0';
      ZTrans.Text := '0';
    end;

    if sfCanScale in shape.Features then
    begin
      XScale.Enabled := True;
      YScale.Enabled := True;
      ZScale.Enabled := True;

      XScale.Text := FloatToStrF(shape.Scale.X, ffFixed, 6, 4);
      YScale.Text := FloatToStrF(shape.Scale.Y, ffFixed, 6, 4);
      ZScale.Text := FloatToStrF(shape.Scale.Z, ffFixed, 6, 4);
    end
    else
    begin
      XScale.Enabled := False;
      YScale.Enabled := False;
      ZScale.Enabled := False;

      XScale.Text := '1';
      YScale.Text := '1';
      ZScale.Text := '1';
    end;

    if sfCanRotate in shape.Features then
    begin
      XRotate.Enabled := True;
      YRotate.Enabled := True;
      ZRotate.Enabled := True;

      XRotate.Text := FloatToStrF(shape.Rotate.X, ffFixed, 6, 4);
      YRotate.Text := FloatToStrF(shape.Rotate.Y, ffFixed, 6, 4);
      ZRotate.Text := FloatToStrF(shape.Rotate.Z, ffFixed, 6, 4);
    end
    else
    begin
      XRotate.Enabled := False;
      YRotate.Enabled := False;
      ZRotate.Enabled := False;

      XRotate.Text := '0';
      YRotate.Text := '0';
      ZRotate.Text := '0';
    end;

    SetTexture(shape.Texture);
  end
  else
  begin
    Name.Enabled := False;

    XTrans.Enabled := False;
    YTrans.Enabled := False;
    ZTrans.Enabled := False;

    XTrans.Text := '0';
    YTrans.Text := '0';
    ZTrans.Text := '0';

    XScale.Enabled := False;
    YScale.Enabled := False;
    ZScale.Enabled := False;

    XScale.Text := '1';
    YScale.Text := '1';
    ZScale.Text := '1';

    XRotate.Enabled := False;
    YRotate.Enabled := False;
    ZRotate.Enabled := False;

    XRotate.Text := '0';
    YRotate.Text := '0';
    ZRotate.Text := '0';

    SetTexture(nil);
  end;

  ApplyBtn.Enabled := False;
end;

procedure TMainForm.SetSelect;
begin
  SetCurrent;
  SelectItem.Checked := True;
  SelectBtn.Down := True;
end;

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SceneData.MouseDown(Shift, X, Y);
  SetCurrent;
  MainPaintBox.Refresh;
end;

procedure TMainForm.ApplyEnable(Sender: TObject);
begin
  ApplyBtn.Enabled := True;
end;

procedure TMainForm.ApplyBtnClick(Sender: TObject);
var
  shape: TShape;
  previous, details: TTransform;

begin
  shape := SceneData.GetCurrent;
  if shape <> nil then
  begin
    previous := TTransform.Create;
    details := TTransform.Create;

    previous.Name := Shape.Name;
    previous.Translate.Copy(shape.Translate);
    previous.Scale.Copy(shape.Scale);
    previous.Rotate.Copy(shape.Rotate);

    SceneData.AddUndo(utTransformShape, shape, previous, details);

    shape.Name := Name.Text;

    if sfCanTranslate in shape.Features then
    begin
      shape.Translate.X := StrToFloat(XTrans.Text);
      shape.Translate.Y := StrToFloat(YTrans.Text);
      shape.Translate.Z := StrToFloat(ZTrans.Text);
    end;

    if sfCanScale in shape.Features then
    begin
      shape.Scale.X := StrToFloat(XScale.Text);
      shape.Scale.Y := StrToFloat(YScale.Text);
      shape.Scale.Z := StrToFloat(ZScale.Text);
    end;

    if sfCanRotate in shape.Features then
    begin
      shape.Rotate.X := StrToFloat(XRotate.Text);
      shape.Rotate.Y := StrToFloat(YRotate.Text);
      shape.Rotate.Z := StrToFloat(ZRotate.Text);
    end;

    details.Name := Shape.Name;
    details.Translate.Copy(shape.Translate);
    details.Scale.Copy(shape.Scale);
    details.Rotate.Copy(shape.Rotate);

    SceneData.SetModified;

    SceneData.Make;
    MainPaintBox.Refresh;
  end;

  ApplyBtn.Enabled := False;
end;

procedure TMainForm.MainPaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SceneData.MouseMove(X, Y);
end;

procedure TMainForm.SelectItemClick(Sender: TObject);
begin
  SceneData.SetMode(mdSelect);
  SelectItem.Checked := True;
  SelectBtn.Down := True;
end;

procedure TMainForm.TranslateItemClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdTranslate);
    TranslateItem.Checked := True;
    TranslateBtn.Down := True;
  end;
end;

procedure TMainForm.ScaleItemClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdScale);
    ScaleItem.Checked := True;
    ScaleBtn.Down := True;
  end;
end;

procedure TMainForm.RotateItemClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdRotate);
    RotateItem.Checked := True;
    RotateBtn.Down := True;
  end;
end;

procedure TMainForm.SelectBtnClick(Sender: TObject);
begin
  SceneData.SetMode(mdSelect);
  SelectItem.Checked := True;
end;

procedure TMainForm.TranslateBtnClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdTranslate);
    TranslateItem.Checked := True;
  end;
end;

procedure TMainForm.ScaleBtnClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdScale);
    ScaleItem.Checked := True;
  end;
end;

procedure TMainForm.RotateBtnClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdRotate);
    RotateItem.Checked := True;
  end;
end;

procedure TMainForm.CameraItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TCamera);
  CameraBtn.Down := True;
  CameraItem.Checked := True;
end;

procedure TMainForm.PointItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TLight);
  LightBtn.Down := True;
  PointItem.Checked := True;
end;

procedure TMainForm.SpotItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TSpotLight);
  LightBtn.Down := True;
  SpotItem.Checked := True;
end;

procedure TMainForm.AreaItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TAreaLight);
  LightBtn.Down := True;
  AreaItem.Checked := True;
end;

procedure TMainForm.PlaneItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TPlane);
  PlaneItem.Checked := True;
  PlaneBtn.Down := True;
end;

procedure TMainForm.SphereItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TSphere);
  SphereItem.Checked := True;
  SphereBtn.Down := True;
end;

procedure TMainForm.CubeItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TCube);
  CubeItem.Checked := True;
  CubeBtn.Down := True;
end;

procedure TMainForm.GridItemClick(Sender: TObject);
var
  dlg: TGridDlg;

begin
  dlg := TGridDlg.Create(Application);

  dlg.Grid.Text := FloatToStrF(SceneData.GetGrid, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
    SceneData.SetGrid(StrToFloat(dlg.Grid.Text));

  dlg.Free;
end;

procedure TMainForm.ZoomItemClick(Sender: TObject);
var
  m, d: integer;
  dlg: TZoomDlg;

begin
  SceneData.GetScale(m, d);

  dlg := TZoomDlg.Create(Application);

  dlg.Multiplier.Text := IntToStr(m);
  dlg.Divisor.Text := IntToStr(d);

  if dlg.ShowModal = idOK then
  begin
    SceneData.SetScale(StrToInt(dlg.Multiplier.Text), StrToInt(dlg.Divisor.Text));
    SceneData.Make;
    MainPaintBox.Refresh;
  end;

  dlg.Free;
end;

procedure TMainForm.ConeItemClick(Sender: TObject);
begin
  SceneData.SetCreateSolid(stCone);
  ConeItem.Checked := True;
  ConeBtn.Down := True;
end;

procedure TMainForm.CylinderItemClick(Sender: TObject);
begin
  SceneData.SetCreateSolid(stCylinder);
  CylinderItem.Checked := True;
  CylinderBtn.Down := True;
end;

procedure TMainForm.SolidItemClick(Sender: TObject);
begin
  SceneData.SetCreateSolid(stSolid);
  SolidItem.Checked := True;
  SolidBtn.Down := True;
end;

procedure TMainForm.PolygonItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TPolygon);
  SceneData.CreateExtrusion := False;
  PolygonItem.Checked := True;
  PolygonBtn.Down := True;
end;

procedure TMainForm.ObjectEditBtnClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;
  if shape <> nil then
    shape.Details;
end;

procedure TMainForm.InfoBtnClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;
  if shape <> nil then
    shape.Info;
end;

procedure TMainForm.FileInfoBtnClick(Sender: TObject);
var
  dlg: TFileInfoDlg;

begin
  dlg := TFileInfoDlg.Create(Application);

  dlg.Objects.Text := IntToStr(SceneData.Shapes.Count);
  dlg.Textures.Text := IntToStr(Textures.Count);

  dlg.ShowModal;
  dlg.Free;
end;

procedure TMainForm.ExportItemClick(Sender: TObject);
var
  i: integer;
  s: string;
  options: TExportOptions;
  dlg: TExportOptionsDialog;

begin
  options := TExportOptions.Create;

  dlg := TExportOptionsDialog.Create(Application);

  dlg.AxisList.ItemIndex := ord(options.Axis);
  dlg.Scaling.Text := Format('%6.4f', [options.Scaling]);

  if dlg.ShowModal = IDOK then
  begin
    options.Axis := TExportOptionsAxis(dlg.AxisList.ItemIndex);
    options.Scaling := StrToFloat(dlg.Scaling.Text);

    s := ExtractFileName(Filename);
    i := Pos('.', s);
    if i > 0 then
      s := Copy(s, 1, i - 1);
    SaveDialog.Filename := s { + '.pov'};
    SaveDialog.DefaultExt := 'pov';
    SaveDialog.Filter :=
      'POVray V3.1 (*.pov)|*.pov|CoolRay (*.ray)|*.ray|VRML V1.0 (*.wrl)|*.wrl|VRML V2.0 (*.wrl)|*.wrl|UDO (*.udo)|*.udo|Direct X (*.x)|*.x';
    SaveDialog.FilterIndex := 1;
    if SaveDialog.Execute then
    begin
      Screen.Cursor := crHourglass;
      try
        case SaveDialog.FilterIndex of
          1: SceneData.GenerateV30(SaveDialog.Filename);
          2: SceneData.GenerateCoolRay(SaveDialog.Filename);
          3: SceneData.GenerateVRML(SaveDialog.Filename);
          4: SceneData.GenerateVRML2(SaveDialog.Filename);
          5: SceneData.GenerateUDO(SaveDialog.Filename);
          6: SceneData.GenerateDirectX(SaveDialog.Filename, options);
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;

  dlg.Free;
  options.Free;
end;

procedure TMainForm.DeleteItemClick(Sender: TObject);
begin
  if SceneData.Delete then
    MainPaintBox.Refresh;
end;

procedure TMainForm.CutItemClick(Sender: TObject);
begin
  if SceneData.CutSelected then
    MainPaintBox.Refresh;
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
  SceneData.CopySelected;
end;

procedure TMainForm.PasteItemClick(Sender: TObject);
begin
  SceneData.Paste(False);
  MainPaintBox.Refresh;
end;

function TMainForm.GetPOVrayCommandString(const OutputFile: string; Width, Height, OutputType: integer; Wait: boolean): string;
var
  i: integer;
  cmd, ext, ftype, name: string;

begin
  name := ExtractFileName(OutputFile);

  i := Pos('.', name);
  if i > 0 then
    name := Copy(name, 1, i - 1);

  case OutputType of
    0:
    begin
      ext := '.tga';
      ftype := '+fc';
    end;

    1:
    begin
      ext := '.png';
      ftype := '+fn';
    end;

    2:
    begin
      ext := '.ppm';
      ftype := '+fp';
    end;

    3:
    begin
      ext := '.bmp';
      ftype := '+fs';
    end;

    4:
    begin
      ext := '.tga';
      ftype := '+ft';
    end;
  end;

  cmd := POVCommand + ' -i' + name + '.pov -o' + name + ext +
    ' -L' + GetModelDirectory + '\Plugins' +
    ' -w' + IntToStr(Width) + ' -h' + IntToStr(Height) + ' ' + ftype + ' +v +b16';

  // If we're running PVENGINE, add the /EXIT switch to close it down
  if (LowerCase(ExtractFileName(POVCommand)) = 'pvengine.exe') and not Wait then
    cmd := cmd + ' /EXIT';

  result := cmd;
end;

procedure TMainForm.RenderItemClick(Sender: TObject);
var
  i: integer;
  dlg: TRenderDialog;
  w, h, name, command: string;

begin
  if not SceneData.CheckShapeTexture then
  begin
    if MessageDlg('Not all your objects have textures. Do you still wish to continue?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;
  end;

  dlg := TRenderDialog.Create(Application);

  name := ExtractFileName(Filename);
  i := Pos('.', name);
  if i > 0 then
    name := Copy(name, 1, i - 1);
  dlg.SceneFile.Text := name + '.pov';
  dlg.ImageSize.Text := POVimageSize;
  dlg.POVExit.Checked := POVexit;

  if dlg.ShowModal = idOK then
  begin
    Screen.Cursor := crHourglass;
    try
      name := dlg.SceneFile.Text;

      // Generate the scene
      SceneData.GenerateV30(name);

      i := Pos('x', dlg.ImageSize.Text);
      w := Copy(dlg.ImageSize.Text, 1, i - 1);
      h := Copy(dlg.ImageSize.Text, i + 1, 32);

      POVimageSize := dlg.ImageSize.Text;
      POVexit := dlg.POVExit.Checked;

      command := GetPOVrayCommandString(name, StrToInt(w), StrToInt(h), dlg.OutputType.ItemIndex, not POVExit);

      Trace('POVray command: ' + command, []);

      if dlg.WaitPOV.Checked then
        WinExecAndWait32(command, SW_SHOW)
      else
        WinExec32(command, SW_SHOW);
    finally
      Screen.Cursor := crDefault;
    end;
  end;

  dlg.Free;
end;

procedure TMainForm.MainPaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
{var
  current: TShape;}

begin
  if Source = MainPaintBox then
  begin
    Accept := True;
    { current := } SceneData.GetCurrent;

    { current.Draw(SceneData, MainPaintBox.Canvas, pmXor); }
    if SceneData.DragOver(x, y) then
      { current.Draw(SceneData, MainPaintBox.Canvas, pmXor); }
      MainPaintBox.Refresh;
  end
  else if Source = GalleryDialog.ListView then
    Accept := True
  else
    Accept := False;
end;

procedure TMainForm.ImportItemClick(Sender: TObject);
var
  ext: string;

begin
  OpenDialog.Filename := '';
  OpenDialog.DefaultExt := 'raw';
  OpenDialog.Filter := 'RAW files (*.raw)|*.raw|Map files (*.map)|*.map|Model Script files (*.msc)|*.msc|User Defined Objects (*.udo)|*.udo';
  if OpenDialog.Execute then
  begin
    ext := UpperCase(ExtractFileExt(OpenDialog.Filename));
    if ext = '.RAW' then
      SceneData.ImportRAW(OpenDialog.Filename)
    else if ext = '.MAP' then
      ImportMap(OpenDialog.Filename)
    else if ext = '.UDO' then
      ImportUDO(OpenDialog.Filename);
  end;
end;

procedure TMainForm.UserDefinedItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TUserShape);
  UserDefinedItem.Checked := True;
  UserDefinedBtn.Down := True;
end;

procedure TMainForm.LoadHalos(const Name: string);
var
  i, n: integer;
  source: TFileStream;
  halo: THalo;

begin
  Halos.Clear;
  source := TFileStream.Create(Name, fmOpenRead);
  try
    source.ReadBuffer(n, sizeof(n));

    for i := 1 to n do
    begin
      halo := THalo.Create;
      halo.LoadFromFile(source);
      Halos.Add(halo);
    end;
  finally
    source.Free;
    ModifiedHalos := false;
  end;
end;

procedure TMainForm.SaveHalos(const Name: string);
var
  i, n: integer;
  dest: TFileStream;
  halo: THalo;

begin
  if Halos.Count > 0 then
  begin
    dest := TFileStream.Create(Name, fmOpenWrite or fmCreate);
    try
      n := Halos.Count;
      dest.WriteBuffer(n, sizeof(n));

      for i := 0 to n - 1 do
      begin
        halo := Halos[i];
        halo.SaveToFile(dest);
      end;
    finally
      dest.Free;
      ModifiedHalos := false;
    end;
  end;
end;

procedure TMainForm.LoadTexture(source: TStream);
var
  ID: TTextureID;
  texture: TTexture;

begin
  source.ReadBuffer(ID, sizeof(ID));

  case ID of
    tiColor:    texture := TTexture.Create;
    tiBrick:    texture := TBrickTexture.Create;
    tiChecker:  texture := TCheckerTexture.Create;
    tiHexagon:  texture := THexagonTexture.Create;
    tiMap:      texture := TMapTexture.Create;
    tiSpiral:   texture := TSpiralTexture.Create;
    tiImage:    texture := TImageTexture.Create;
  else
    texture := nil;
  end;

  if texture <> nil then
  begin
    texture.LoadFromFile(source);
    Textures.Add(texture);
  end;
end;

procedure TMainForm.LoadTextures(const Name: string);
var
  i, n: integer;
  source: TFileStream;
  buffer: array [0..4] of AnsiChar;

begin
  Textures.Clear;
  source := TFileStream.Create(Name, fmOpenRead);
  try
    source.ReadBuffer(buffer, 4);
    buffer[4] := chr(0);

    if buffer = 'MODL' then
      source.ReadBuffer(TextureVersion, sizeof(TextureVersion))
    else
    begin
      TextureVersion := 7;
      source.Position := 0;
    end;

    source.ReadBuffer(n, sizeof(n));
    for i := 0 to n - 1 do
      LoadTexture(source);

  finally
    source.Free;
    ModifiedTextures := False;
  end;
end;

procedure TMainForm.SaveTextures(const Name: string);
var
  i, n: integer;
  texture: TTexture;
  root: TJSONObject;
  scene: TJSONArray;
  text: string;

begin
  root := TJSONObject.Create;
  scene := TJSONArray.Create;
  n := Textures.Count;
  for i := 0 to n - 1 do
  begin
    texture := Textures[i];
    texture.Save(scene);
  end;
  root.AddPair('textures', scene);
  text := root.ToJSON;
  TFile.WriteAllText(name, text);

  ModifiedTextures := False;
end;

procedure TMainForm.LoadTexturesItemClick(Sender: TObject);
begin
  OpenDialog.Filename := 'textures.mtf';
  OpenDialog.DefaultExt := 'mtf';
  OpenDialog.Filter := 'Texture files (*.mtf)|*.mtf';
  if OpenDialog.Execute then
  begin
    LoadTextures(OpenDialog.Filename);
    TextPaintBox.Refresh;
  end;
end;

procedure TMainForm.SaveTexturesItemClick(Sender: TObject);
begin
  SaveDialog.Filename := 'textures.mtf';
  SaveDialog.DefaultExt := 'mtf';
  SaveDialog.Filter := 'Texture files (*.mtf)|*.mtf';
  if SaveDialog.Execute then
    SaveTextures(SaveDialog.Filename);
end;

procedure TMainForm.HelpIndexItemClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.HeightFieldItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(THeightField);
end;

procedure TMainForm.UnionItemClick(Sender: TObject);
begin
  SceneData.CreateGroup(gtUnion);
  MainPaintBox.Refresh;
end;

procedure TMainForm.IntersectionItemClick(Sender: TObject);
begin
  SceneData.CreateGroup(gtIntersection);
  MainPaintBox.Refresh;
end;

procedure TMainForm.DifferenceItemClick(Sender: TObject);
begin
  SceneData.CreateGroup(gtDifference);
  MainPaintBox.Refresh;
end;

procedure TMainForm.GalleryItemClick(Sender: TObject);
begin
  GalleryDialog.Update;
  GalleryDialog.Show;
end;

function TMainForm.CreateGallery: TShape;
var
  shape: TShape;

begin
  shape := SceneData.CreateGallery;

  if shape <> nil then
  begin
    ObjectGallery.Add(shape);
    MainPaintBox.Refresh;
  end;

  result := shape;
end;

procedure TMainForm.SelectAllItemClick(Sender: TObject);
begin
  SceneData.SelectAll;
  MainPaintBox.Refresh;
end;

procedure TMainForm.ClearItemClick(Sender: TObject);
begin
  SceneData.Clear;
  MainPaintBox.Refresh;
end;

procedure TMainForm.MainPaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if Sender = MainPaintBox then
  begin
    { MainPaintBox.Refresh; }
    SceneData.EndDrag;
    SetCurrent;
  end;
end;

procedure TMainForm.BrowserItemClick(Sender: TObject);
begin
  ObjectBrowser.DisplayObjects;
  ObjectBrowser.Show;
end;

procedure TMainForm.BlobItemClick(Sender: TObject);
begin
  SceneData.CreateBlob;
  MainPaintBox.Refresh;
end;

procedure TMainForm.BicubicPatchItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TBicubicShape);
  BicubicPatchItem.Checked := True;
  BicubicPatchBtn.Down := True;
end;

procedure TMainForm.ObserverItemClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;
  if (shape <> nil) and (sfHasObserver in shape.Features) then
  begin
    SceneData.SetMode(mdObserver);
    ObserverItem.Checked := True;
    ObserverBtn.Down := True;
  end;
end;

procedure TMainForm.ObservedItemClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;
  if (shape <> nil) and (sfHasObserved in shape.Features) then
  begin
    SceneData.SetMode(mdObserved);
    ObservedItem.Checked := True;
    ObservedBtn.Down := True;
  end;
end;

procedure TMainForm.SettingsItemClick(Sender: TObject);
var
  dlg: TSettingsDialog;

begin
  dlg := TSettingsDialog.Create(Application);

  dlg.POVray.text := POVCommand;
  dlg.CoolRay.text := CoolRayCommand;

  if dlg.ShowModal = idOK then
  begin
    POVCommand := dlg.POVray.text;
    CoolRayCommand := dlg.CoolRay.Text;
  end;

  dlg.Free;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  reg: TRegistry;

begin
  reg := TRegistry.Create;

  reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(ModelKey, true) then
  begin
    Reg.WriteInteger('MainWindowLeft', Left);
    Reg.WriteInteger('MainWindowTop', Top);
    Reg.WriteInteger('MainWindowWidth', Width);
    Reg.WriteInteger('MainWindowHeight', Height);

    reg.CloseKey;
  end;

  reg.RootKey := HKEY_LOCAL_MACHINE;

  if reg.OpenKey(ModelKey, true) then
  begin
    Reg.WriteString('POVrayImage', POVCommand);
    Reg.WriteString('ImageSize', POVimageSize);
    if Length(CoolRayCommand) > 0 then
      Reg.WriteString('CoolRayPath', CoolRayCommand);
    Reg.WriteBool('ImageExit', POVexit);

    reg.CloseKey;
  end;

  Reg.Free;
end;

procedure TMainForm.DiscItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TDisc);
  DiscItem.Checked := True;
  DiscBtn.Down := True;
end;

procedure TMainForm.TorusItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TTorus);
  TorusItem.Checked := True;
  TorusBtn.Down := True;
end;

procedure TMainForm.SaveItemClick(Sender: TObject);
begin
  if NewSceneFile then
    SaveAsItemClick(Sender)
  else
  begin
    SceneData.SaveToFile(Filename);
    //MRUFileList.AddItem(Filename);
  end;
end;

procedure TMainForm.Modify(shape: TShape);
begin
  shape.Make(SceneData, shape.Triangles);
  SceneData.SetModified;
  MainPaintBox.Refresh;
end;

procedure TMainForm.CenterItemClick(Sender: TObject);
begin
  CenterView;
end;

procedure TMainForm.HiddenLineRemovalItemClick(Sender: TObject);
var
  hidden: boolean;

begin
  hidden := SceneData.ToggleHiddenLineRemoval;
  HiddenLineRemovalItem.Checked := hidden;

  if hidden then
  begin
    LightShadingItem.Enabled := True;
    LightShadingItem.Checked := SceneData.GetLightShading;

    OutlineItem.Enabled := True;
    OutlineItem.Checked := SceneData.GetOutline;
  end
  else
  begin
    LightShadingItem.Enabled := False;
    LightShadingItem.Checked := False;

    OutlineItem.Enabled := False;
    OutlineItem.Checked := False;
  end;

  MainPaintBox.Refresh;
end;

procedure TMainForm.SuperEllipsoidItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TSuperEllipsoid);
  SuperEllipsoidItem.Checked := True;
  SuperBtn.Down := True;
end;

procedure TMainForm.PasteMultipleItemClick(Sender: TObject);
begin
  SceneData.Paste(True);
  MainPaintBox.Refresh;
end;

procedure TMainForm.MergeItemClick(Sender: TObject);
begin
  SceneData.CreateGroup(gtMerge);
  MainPaintBox.Refresh;
end;

procedure TMainForm.CylinderLightItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TCylinderLight);
  LightBtn.Down := True;
  CylinderLightItem.Checked := True;
end;

procedure TMainForm.TextItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TText);
  TextItem.Checked := True;
  TextBtn.Down := True;
end;

procedure TMainForm.ExtrusionItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TPolygon);
  SceneData.CreateExtrusion := True;
  ExtrusionItem.Checked := True;
  ExtrusionBtn.Down := True;
end;

procedure TMainForm.LatheItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TLathe);
  LatheItem.Checked := True;
  LatheBtn.Down := True;
end;

procedure TMainForm.JuliaFractalItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TJuliaFractal);
  JuliaFractalItem.Checked := True;
end;

procedure TMainForm.ObjectMenuClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;

  if shape <> nil then
  begin
    UniformScalingItem.Checked := SceneData.GetUniformScaling;
    ShadowItem.Checked := sfShadow in shape.Flags;
    HollowItem.Checked := sfHollow in shape.Flags;
  end
  else
  begin
    UniformScalingItem.Checked := false;
    ShadowItem.Checked := False;
    HollowItem.Checked := False;
  end;
end;

procedure TMainForm.HollowItemClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;

  if shape <> nil then
  begin
    if sfHollow in shape.Flags then
      shape.Flags := shape.Flags - [sfHollow]
    else
      shape.Flags := shape.Flags + [sfHollow];

    SceneData.SetModified;
  end;
end;

procedure TMainForm.ShadowItemClick(Sender: TObject);
var
  shape: TShape;

begin
  shape := SceneData.GetCurrent;

  if shape <> nil then
  begin
    if sfShadow in shape.Flags then
      shape.Flags := shape.Flags - [sfShadow]
    else
      shape.Flags := shape.Flags + [sfShadow];

    SceneData.SetModified;
  end;
end;

procedure TMainForm.HalosItemClick(Sender: TObject);
var
  dlg: THalosDialog;

begin
  dlg := THalosDialog.Create(Application);

  dlg.ShowModal;

  dlg.Free;
end;

procedure TMainForm.LightShadingItemClick(Sender: TObject);
begin
  LightShadingItem.Checked := SceneData.ToggleLightShading;
  MainPaintBox.Refresh;
end;

procedure TMainForm.OutlineItemClick(Sender: TObject);
begin
  OutlineItem.Checked := SceneData.ToggleOutline;
  MainPaintBox.Refresh;
end;

procedure TMainForm.EditMenuClick(Sender: TObject);
begin
  UndoItem.Enabled := SceneData.CanUndo;
  RedoItem.Enabled := SceneData.CanRedo;
end;

procedure TMainForm.UndoItemClick(Sender: TObject);
begin
  if SceneData.Undo then
    MainPaintBox.Refresh;
end;

procedure TMainForm.FogItemClick(Sender: TObject);
var
  dlg: TFogDialog;

begin
  dlg := TFogDialog.Create(Application);
  dlg.ShowModal;
  dlg.Free;
end;

procedure TMainForm.ScaleUpBtnClick(Sender: TObject);
begin
  SceneData.ScaleUp;
  SceneData.Make;
  MainPaintBox.Refresh;
end;

procedure TMainForm.ScaleDownBtnClick(Sender: TObject);
begin
  SceneData.ScaleDown;
  SceneData.Make;
  MainPaintBox.Refresh;
end;

procedure TMainForm.LensFlareItemClick(Sender: TObject);
begin
  SceneData.SetCreateScripted(siLight);
  LightBtn.Down := True;
  LensFlareItem.Checked := True;
end;

procedure TMainForm.LayersItemClick(Sender: TObject);
begin
  LayersForm.Show;
end;

procedure TMainForm.PrintItemClick(Sender: TObject);
var
  mode: integer;

begin
  mode := 0;
  if PrintDialog.Execute then
    with Printer do
    begin
      Screen.Cursor := crHourglass;
      try
        Title := 'Model Scene Editor';
        BeginDoc;
        mode := SetMapMode(Canvas.Handle, MM_ISOTROPIC);
        SetWindowExtEx(Canvas.Handle, 2000, 2000, nil);
        SetViewportExtEx(Canvas.Handle, PageWidth, PageHeight, nil);
        SceneData.Print(Canvas)
      finally
        SetMapMode(Canvas.Handle, mode);
        EndDoc;
        Screen.Cursor := crDefault;
      end;
    end;
end;

procedure TMainForm.PrintSetupItemClick(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TMainForm.SpringItemClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TSpring);
  SpringBtn.Down := True;
  SpringItem.Checked := True;
end;

procedure TMainForm.UniformScalingBtnClick(Sender: TObject);
begin
  if SceneData.GetCurrent <> nil then
  begin
    SceneData.SetMode(mdScaleUniform);
    UniformScalingItem.Checked := True;
    UniformScalingBtn.Down := True;
  end;
end;

procedure TMainForm.TexturesItemClick(Sender: TObject);
begin
  TextureForm.Show;
end;

procedure TMainForm.DirectXActionExecute(Sender: TObject);
begin
{$IFDEF USE_DIRECTX}
  Screen.Cursor := crHourGlass;
  if DirectXForm <> nil then
    DirectXForm.Show
  else
  begin
    DirectXForm := TDirectXForm.Create(Application);
    DirectXForm.Show;
  end;
  Screen.Cursor := crDefault;
{$ELSE}
  MessageDlg(DirectXUnavailable, mtWarning, [mbOK], 0);
{$ENDIF}
end;

procedure TMainForm.MRUFileListMRUItemClick(Sender: TObject;
  AFilename: TFileName);
begin
  NewSceneFile := False;
  Filename := AFilename;
  SceneData.LoadFromFile(Filename);
  MainPaintBox.Refresh;
  SetCaption(Filename);
end;

procedure TMainForm.RenderCoolRayActionExecute(Sender: TObject);
var
  dlg: TCoolRayDialog;
  command: string;

begin
  dlg := TCoolRayDialog.Create(Application);

  dlg.OutputType.ItemIndex := 0;

  if dlg.ShowModal = IDOK then
  begin
    SceneData.GenerateCoolRay(dlg.SceneFile.Text);

    command := CoolRayCommand + ' ' + dlg.SceneFile.Text + ' output.jpg';

    WinExec32(command, SW_SHOW);
  end;

  dlg.Free;
end;

procedure TMainForm.EnvBtnClick(Sender: TObject);
begin
  SceneData.SetCreateWhat(TEnvironment);
  EnvBtn.Down := True;
  EnvItem.Checked := True;
end;

procedure TMainForm.FrameBarChange(Sender: TObject);
begin
  FrameNum.Text := IntToStr(FrameBar.Position);
end;

procedure TMainForm.PaintBarPaint(Sender: TObject);
const
  BarIndent = 9;

var
  i, w, x: integer;

begin
  // The width in which to draw tick marks and key frames
  w := PaintBar.Width - 2 * BarIndent - 2;

  // Draw some tick marks
  for i := 0 to 10 do
  begin
    x := i * w div 10 + BarIndent;

    with PaintBar.Canvas do
    begin
      MoveTo(x, 0);
      LineTo(x, PaintBar.Height);
    end;
  end;
end;

procedure TMainForm.AnimationTimerTimer(Sender: TObject);
begin
  SceneData.NextFrame;

  FrameBar.Position := SceneData.AnimationPosition;
end;

procedure TMainForm.StopActionExecute(Sender: TObject);
begin
  AnimationTimer.Enabled := false;
end;

procedure TMainForm.PlayActionExecute(Sender: TObject);
begin
  AnimationTimer.Enabled := true;
end;

end.

