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

unit textform;

interface

uses
  System.UITypes, System.Generics.Collections, Scene,
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.ComCtrls, VCL.ExtCtrls, VCL.Buttons, VCL.ToolWin, VCL.Menus,
  Texture.Manager, Texture, VCL.StdCtrls, VCL.ImgList, VCL.Clipbrd,
  rgbframe, turbframe, VCL.ActnList, System.Actions, System.ImageList;

type
  TColourMapBlock = class
  public
    Red, Green, Blue, Filter, Transmit: double;
    constructor Create;
    procedure LoadFromStream(stream: TStream);
    procedure SaveToStream(stream: TStream);
  end;

  TTextureForm = class(TForm)
    MainMenu: TMainMenu;
    TextureMenu: TMenuItem;
    LoadItem: TMenuItem;
    SaveItem: TMenuItem;
    N1: TMenuItem;
    CloseItem: TMenuItem;
    EditMenu: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    HelpMenu: TMenuItem;
    AboutItem: TMenuItem;
    StatusBar: TStatusBar;
    NewItem: TMenuItem;
    N2: TMenuItem;
    DeleteItem: TMenuItem;
    PageControl: TPageControl;
    PreviewPanel: TPanel;
    TextureImage: TImageList;
    ColourSheet: TTabSheet;
    NormalSheet: TTabSheet;
    FinishSheet: TTabSheet;
    HaloSheet: TTabSheet;
    TransformationSheet: TTabSheet;
    Label1: TLabel;
    ColourName: TEdit;
    Label7: TLabel;
    NormalType: TComboBox;
    Label8: TLabel;
    NormalValue: TEdit;
    MapSheet: TTabSheet;
    ApplyBtn: TButton;
    Label13: TLabel;
    FinishDiffuse: TEdit;
    Label14: TLabel;
    FinishBrilliance: TEdit;
    Label15: TLabel;
    FinishCrand: TEdit;
    Label16: TLabel;
    FinishAmbient: TEdit;
    Label17: TLabel;
    FinishReflection: TEdit;
    Label18: TLabel;
    FinishPhong: TEdit;
    FinishPhongSize: TEdit;
    Label19: TLabel;
    FinishSpecular: TEdit;
    FinishRoughness: TEdit;
    FinishMetallic: TCheckBox;
    Label20: TLabel;
    FinishRefraction: TEdit;
    FinishIOR: TEdit;
    Label21: TLabel;
    FinishCaustics: TEdit;
    Label22: TLabel;
    FinishFade: TEdit;
    FinishFadePower: TEdit;
    Label23: TLabel;
    FinishIrid: TEdit;
    FinishIridThickness: TEdit;
    Label32: TLabel;
    MapName: TEdit;
    MapPanel: TPanel;
    MapImage: TImage;
    ValuePanel: TPanel;
    ValuePaintBox: TPaintBox;
    ButtonPanel: TPanel;
    ButtonPaintBox: TPaintBox;
    Label38: TLabel;
    MapValue: TEdit;
    MapAdd: TButton;
    MapRemove: TButton;
    MapAssign: TButton;
    CheckerSheet: TTabSheet;
    Label39: TLabel;
    CheckerName: TEdit;
    MapCopyBtn: TSpeedButton;
    MapPasteBtn: TSpeedButton;
    Label50: TLabel;
    MapType: TComboBox;
    ColourRGBFTFrame: TRGBFTFrame;
    CheckerRGBFTFrame1: TRGBFTFrame;
    CheckerRGBFTFrame2: TRGBFTFrame;
    MapTurbulenceFrame: TTurbulenceFrame;
    NormalTurbulenceFrame: TTurbulenceFrame;
    FinishTurbulenceFrame: TTurbulenceFrame;
    ImagePreviewPanel: TPanel;
    PreviewImage: TImage;
    MapRGBFTFrame: TRGBFTFrame;
    PreviewBtn: TButton;
    Label2: TLabel;
    Shape: TComboBox;
    Floor: TCheckBox;
    Wall: TCheckBox;
    Panel1: TPanel;
    FloorColour: TShape;
    ColorDialog: TColorDialog;
    Panel2: TPanel;
    WallColour: TShape;
    ToolBar1: TToolBar;
    ToolbarImageList: TImageList;
    ActionList: TActionList;
    NewAction: TAction;
    DeleteAction: TAction;
    LoadAction: TAction;
    SaveAction: TAction;
    CloseAction: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    CutAction: TAction;
    CopyAction: TAction;
    PasteAction: TAction;
    TextureList: TTreeView;
    Splitter2: TSplitter;
    Splitter1: TSplitter;
    UserSheet: TTabSheet;
    Label3: TLabel;
    UserName: TEdit;
    UserRGBFTFrame: TRGBFTFrame;
    Label4: TLabel;
    DeclareName: TEdit;
    Label5: TLabel;
    Filename: TEdit;
    FilenameBrowse: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure CloseItemClick(Sender: TObject);
    procedure NewItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetDirty(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ValuePaintBoxPaint(Sender: TObject);
    procedure ButtonPaintBoxPaint(Sender: TObject);
    procedure ValuePaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ValuePaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ValuePaintBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ButtonPaintBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MapCopyBtnClick(Sender: TObject);
    procedure MapPasteBtnClick(Sender: TObject);
    procedure MapAddClick(Sender: TObject);
    procedure MapRemoveClick(Sender: TObject);
    procedure MapAssignClick(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure FloorColourMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WallColourMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TextureListChange(Sender: TObject; Node: TTreeNode);
    procedure TextureListChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FilenameBrowseClick(Sender: TObject);
    procedure LoadActionExecute(Sender: TObject);
  private
    { Private declarations }
    Dirty: boolean;
    CurrentTexture: TTexture;
    HoldMapApply: boolean;
    SelectedMap: integer;
    NoPreview: TBitmap;
    TextureFolder: TIcon;

    function CreateTexture(ATexture: TTextureType): TTexture;
    function CreateMapTexture(AType: TTextureID): TTexture;
    function CreateSpiralTexture(AType: TTextureID): TTexture;
    procedure CreateTextureFromID(id: TTextureID);
    procedure SetCurrentMap(index: integer);
    function FindCategory(const cat: string): TTreeNode;
    function AddTexture(texture: TTexture): TTreeNode;
    procedure BuildList;
    procedure SetUserSheet;
    procedure SetColourSheet;
    procedure SetCheckerSheet;
    procedure SetMapSheet;
    procedure SetNormalSheet;
    procedure SetFinishSheet;
    procedure GetUserSheet;
    procedure GetColourSheet;
    procedure GetCheckerSheet;
    procedure GetMapSheet;
    procedure GetNormalSheet;
    procedure GetFinishSheet;
  public
    { Public declarations }
  end;

var
  TextureForm: TTextureForm;

implementation

uses main, texttype, chtextnm, brick, checker, hexagon, maptext, rgbft,
  misc, parser;

{$R *.DFM}

procedure DrawColour(width, height: integer; canvas: TCanvas; r, g, b: double);
var
  rect: TRect;

begin
  rect.Left := 0;
  rect.Right := width;
  rect.Top := 0;
  rect.Bottom := height;

  canvas.Brush.Color := RGB(trunc(r * 255.0), trunc(g * 255.0), trunc(b * 255.0));
  canvas.FillRect(rect);
end;

procedure DrawColourMap(width, height: integer; canvas: TCanvas; list: TList<TMapItem>);
var
  flat: boolean;
  i, j, x1, x2, n: integer;
  map, map2: TMapItem;
  r, g, b, ri, gi, bi, r1, r2, g1, g2, b1, b2: integer;
  rect: TRect;

begin
  if list.Count > 1 then
  begin
    // Examine the start and end maps
    map := list[0];
    if map.Value > 0.001 then
    begin
      r := trunc(map.Red * 255);
      g := trunc(map.Green * 255);
      b := trunc(map.Blue * 255);

      canvas.Brush.Color := RGB(r, g, b);

      x1 := trunc(map.Value * width);

      rect.left := 0;
      rect.top := 0;
      rect.right := x1;
      rect.bottom := height;

      canvas.FillRect(rect);
    end;

    map := list[list.Count - 1];
    if map.Value < 0.999 then
    begin
      r := trunc(map.Red * 255);
      g := trunc(map.Green * 255);
      b := trunc(map.Blue * 255);

      canvas.Brush.Color := RGB(r, g, b);

      x1 := trunc(map.Value * width);

      rect.left := x1;
      rect.top := 0;
      rect.right := width;
      rect.bottom := height;

      canvas.FillRect(rect);
    end;

    // Draw the intermediate steps
    for i := 0 to list.Count - 2 do
    begin
      map := list[i];
      map2 := list[i + 1];

      x1 := trunc(width * map.Value);
      x2 := trunc(width * map2.Value);

      r1 := trunc(map.Red * 255);
      g1 := trunc(map.Green * 255);
      b1 := trunc(map.Blue * 255);

      r2 := trunc(map2.Red * 255);
      g2 := trunc(map2.Green * 255);
      b2 := trunc(map2.Blue * 255);

      if (r1 = r2) and (g1 = g2) and (b1 = b2) then
        flat := True
      else
        flat := False;

      if x2 > x1 then
        with canvas do
          if flat then
          begin
            Brush.Color := RGB(r1, g1, b1);

            rect.left := x1;
            rect.top := 0;
            rect.right := x2;
            rect.bottom := height;

            FillRect(rect);
          end
          else
          begin
            n := (x2 - x1) div 2;

            ri := (r2 - r1) div n;
            gi := (g2 - g1) div n;
            bi := (b2 - b1) div n;

            for j := 0 to n - 1 do
            begin
              r := r1 + ri * j;
              g := g1 + gi * j;
              b := b1 + bi * j;

              Brush.Color := RGB(r, g, b);

              Rect.left := x1 + j * 2;
              Rect.right := x1 + j * 2 + 3;
              Rect.top := 0;
              Rect.bottom := height;

              FillRect(rect);
            end;
          end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

constructor TColourMapBlock.Create;
begin
  Red := 1.0;
  Green := 1.0;
  Blue := 1.0;
  Filter := 0.0;
  Transmit := 0.0;
end;

procedure TColourMapBlock.LoadFromStream(stream: TStream);
begin
  stream.ReadBuffer(Red, sizeof(double));
  stream.ReadBuffer(Green, sizeof(double));
  stream.ReadBuffer(Blue, sizeof(double));
  stream.ReadBuffer(Filter, sizeof(double));
  stream.ReadBuffer(Transmit, sizeof(double));
end;

procedure TColourMapBlock.SaveToStream(stream: TStream);
begin
  stream.WriteBuffer(Red, sizeof(double));
  stream.WriteBuffer(Green, sizeof(double));
  stream.WriteBuffer(Blue, sizeof(double));
  stream.WriteBuffer(Filter, sizeof(double));
  stream.WriteBuffer(Transmit, sizeof(double));
end;

////////////////////////////////////////////////////////////////////////////////

function TTextureForm.CreateTexture(ATexture: TTextureType): TTexture;
var
  texture: TTexture;

begin
  texture := ATexture.Create;
  texture.Name := 'Texture' + IntToStr(TTextureManager.TextureManager.Textures.Count);
  result := texture
end;

function TTextureForm.CreateMapTexture(AType: TTextureID): TTexture;
var
  map: TMapTexture;

begin
  map := TMapTexture.Create;

  map.MapType := AType;
  map.Name := 'Map' + IntToStr(TTextureManager.TextureManager.Textures.Count);
  map.CreateSimple;

  result := map
end;

function TTextureForm.CreateSpiralTexture(AType: TTextureID): TTexture;
var
  map: TSpiralTexture;

begin
  map := TSpiralTexture.Create;

  map.MapType := AType;
  map.Name := 'Spiral' + IntToStr(TTextureManager.TextureManager.Textures.Count);
  map.CreateSimple;

  result := map
end;

procedure TTextureForm.CreateTextureFromID(id: TTextureID);
var
  i: integer;
  texture: TTexture;
  node: TTreeNode;
  dlg: TChooseTextureNameDialog;

begin
  case id of
    tiColor:              texture := CreateTexture(TTexture);
    tiBrick:              texture := CreateTexture(TBrickTexture);
    tiChecker:            texture := CreateTexture(TCheckerTexture);
    tiHexagon:            texture := CreateTexture(THexagonTexture);
    tiAgate, tiAverage, tiBumps, tiBozo,
    tiCrackle, tiDents, tiGradient,
    tiGranite, tiLeopard, tiMandel,
    tiMarble, tiOnion, tiQuilted,
    tiRadial, tiRipples, tiSpotted, tiWaves,
    tiWood, tiWrinkles:   texture := CreateMapTexture(id);
    tiSpiral1, tiSpiral2: texture := CreateSpiralTexture(id);
    tiImage:              texture := CreateTexture(TImageTexture);
    tiUser:               texture := CreateTexture(TUserTexture);
  else
    texture := nil;
  end;

  if texture <> nil then
  begin
    while TTextureManager.TextureManager.FindTexture(texture.Name) <> nil do
    begin
      dlg := TChooseTextureNameDialog.Create(Application);

      dlg.Existing.Text := texture.Name;

      i := dlg.ShowModal;

      if i = idOK then
        texture.Name := dlg.Choose.Text;

      dlg.Free;

      if i = idCancel then
      begin
        texture.Free;
        texture := nil;
        break;
      end;
    end;

    if texture <> nil then
    begin
      TTextureManager.TextureManager.Textures.Add(texture);
      MainForm.TextPaintBox.Width := TTextureManager.TextureManager.Textures.Count * TextSize;
      MainForm.TextPaintBox.Refresh;

      node := AddTexture(texture);
      TextureList.Selected := node;
    end;
  end;
end;

procedure TTextureForm.SetCurrentMap(index: integer);
var
  MapTexture: TMapTexture;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    SelectedMap := index;

    map := MapTexture.Maps[index];

    HoldMapApply := True;

    MapRGBFTFrame.SetColour(map.Red, map.Green, map.Blue, map.Transmit, map.Filter);

    MapValue.Text := FloatToStrF(map.Value, ffFixed, 6, 4);

    HoldMapApply := False;
  end;
end;

function TTextureForm.FindCategory(const cat: string): TTreeNode;
var
  node: TTreeNode;

begin
  node := TextureList.Items.GetFirstNode;

  while node <> nil do
  begin
    if node.Text = cat then break;

    node := node.GetNextSibling;
  end;

  result := node;
end;

function TTextureForm.AddTexture(texture: TTexture): TTreeNode;
var
  index: integer;
  bitmap: TBitmap;
  category, node: TTreeNode;

begin
  bitmap := TBitmap.Create;

  with bitmap do
  begin
    Width := 16;
    Height := 16;
    Canvas.Brush.Color := texture.GetColour;
    Canvas.Ellipse(0, 0, 15, 15);
  end;

  index := TextureImage.Add(bitmap, nil);

  bitmap.Free;

  category := FindCategory(texture.Category);

  if category = nil then
    category := TextureList.Items.Add(nil, texture.Category);

  node := TextureList.Items.AddChild(category, texture.Name);
  node.Data := texture;
  node.ImageIndex := index;
  node.SelectedIndex := index;

  result := node;
end;

procedure TTextureForm.BuildList;
var
  i: integer;
  texture: TTexture;

begin
  // Clear out the list
  TextureList.Items.BeginUpdate;

  TextureList.Items.Clear;
  TextureImage.Clear;

  TextureImage.AddIcon(TextureFolder);

  // Walk the list of textures
  for i := 0 to TTextureManager.TextureManager.Textures.Count - 1 do
  begin
    texture := TTextureManager.TextureManager.Textures[i];
    AddTexture(texture);
  end;

  TextureList.Items.EndUpdate;
end;

procedure TTextureForm.SetUserSheet;
var
  user: TUserTexture;

begin
  PageControl.ActivePage := UserSheet;

  UserName.Text := CurrentTexture.Name;

  user := CurrentTexture as TUserTexture;

  UserRGBFTFrame.SetColour(CurrentTexture.Red,
    CurrentTexture.Green,
    CurrentTexture.Blue,
    CurrentTexture.Filter,
    CurrentTexture.Transmit);

  DeclareName.Text := user.Declare;
  Filename.Text := user.Filename;
end;

procedure TTextureForm.SetColourSheet;
begin
  PageControl.ActivePage := ColourSheet;

  ColourName.Text := CurrentTexture.Name;

  ColourRGBFTFrame.SetColour(CurrentTexture.Red,
    CurrentTexture.Green,
    CurrentTexture.Blue,
    CurrentTexture.Filter,
    CurrentTexture.Transmit);
end;

procedure TTextureForm.SetCheckerSheet;
var
  checker: TCheckerTexture;

begin
  PageControl.ActivePage := CheckerSheet;

  CheckerName.Text := CurrentTexture.Name;

  checker := CurrentTexture as TCheckerTexture;

  with checker do
  begin
    CheckerRGBFTFrame1.SetColour(Red, Green, Blue, Filter, Transmit);
    CheckerRGBFTFrame2.SetColour(Red2, Green2, Blue2, Filter2, Transmit2);
  end;
end;

procedure TTextureForm.SetMapSheet;
var
  MapTexture: TMapTexture;

begin
  // Switch to the map sheet
  PageControl.ActivePage := MapSheet;

  // Set the name (generic)
  MapName.Text := CurrentTexture.Name;

  // Set the map type
  MapType.Text := TextureNames[CurrentTexture.GetID];

  // Get the texture as a map texture
  MapTexture := CurrentTexture as TMapTexture;

  // Draw the map
  DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);

  // Refresh the map windows
  ValuePaintBox.Refresh;
  ButtonPaintBox.Refresh;
end;

procedure TTextureForm.SetNormalSheet;
begin
  NormalType.ItemIndex := ord(CurrentTexture.NormalType);
  NormalValue.Text := Format('%8.6f', [CurrentTexture.NormalValue]);

  with CurrentTexture do
    NormalTurbulenceFrame.SetTurbulence(NormalTurbulence, NormalOctaves, NormalLambda, NormalOmega);
end;

procedure TTextureForm.SetFinishSheet;
begin
  FinishDiffuse.Text       := Format('%8.6f', [CurrentTexture.Diffuse]);
  FinishBrilliance.Text    := Format('%8.6f', [CurrentTexture.Brilliance]);
  FinishCrand.Text         := Format('%8.6f', [CurrentTexture.Crand]);
  FinishAmbient.Text       := Format('%8.6f', [CurrentTexture.Ambient]);
  FinishReflection.Text    := Format('%8.6f', [CurrentTexture.Reflection]);
  FinishPhong.Text         := Format('%8.6f', [CurrentTexture.Phong]);
  FinishPhongSize.Text     := Format('%8.6f', [CurrentTexture.PhongSize]);
  FinishSpecular.Text      := Format('%8.6f', [CurrentTexture.Specular]);
  FinishRoughness.Text     := Format('%8.6f', [CurrentTexture.Roughness]);
  FinishMetallic.Checked   := CurrentTexture.Metallic;
  FinishRefraction.Text    := Format('%8.6f', [CurrentTexture.Refraction]);
  FinishIOR.Text           := Format('%8.6f', [CurrentTexture.IOR]);
  FinishCaustics.Text      := Format('%8.6f', [CurrentTexture.Caustics]);
  FinishFade.Text          := Format('%8.6f', [CurrentTexture.FadeDistance]);
  FinishFadePower.Text     := Format('%8.6f', [CurrentTexture.FadePower]);
  FinishIrid.Text          := Format('%8.6f', [CurrentTexture.Irid]);
  FinishIridThickness.Text := Format('%8.6f', [CurrentTexture.IridThickness]);

  with CurrentTexture do
    FinishTurbulenceFrame.SetTurbulence(Turbulence, Octaves, Lambda, Omega);
end;

procedure TTextureForm.GetUserSheet;
var
  user: TUserTexture;

begin
  CurrentTexture.Name := UserName.Text;

  user := CurrentTexture as TUserTexture;

  UserRGBFTFrame.GetColour(CurrentTexture.Red,
    CurrentTexture.Green,
    CurrentTexture.Blue,
    CurrentTexture.Filter,
    CurrentTexture.Transmit);

  user.Declare := DeclareName.Text;
  user.Filename := Filename.Text;
end;

procedure TTextureForm.GetColourSheet;
begin
  CurrentTexture.Name := ColourName.Text;

  ColourRGBFTFrame.GetColour(CurrentTexture.Red,
    CurrentTexture.Green,
    CurrentTexture.Blue,
    CurrentTexture.Filter,
    CurrentTexture.Transmit);
end;

procedure TTextureForm.GetCheckerSheet;
var
  checker: TCheckerTexture;

begin
  CurrentTexture.Name := CheckerName.Text;

  checker := CurrentTexture as TCheckerTexture;

  with checker do
  begin
    CheckerRGBFTFrame1.GetColour(Red, Green, Blue, Filter, Transmit);
    CheckerRGBFTFrame2.GetColour(Red2, Green2, Blue2, Filter2, Transmit2);
  end;
end;

procedure TTextureForm.GetMapSheet;
begin
  CurrentTexture.Name := MapName.Text;
end;

procedure TTextureForm.GetNormalSheet;
begin
  CurrentTexture.NormalType := TNormalType(NormalType.ItemIndex);
  CurrentTexture.NormalValue := StrToFloat(NormalValue.Text);

  with CurrentTexture do
    NormalTurbulenceFrame.GetTurbulence(NormalTurbulence, NormalOctaves, NormalLambda, NormalOmega);
end;

procedure TTextureForm.GetFinishSheet;
begin
  CurrentTexture.Diffuse := StrToFloat(FinishDiffuse.Text);
  CurrentTexture.Brilliance := StrToFloat(FinishBrilliance.Text);
  CurrentTexture.Crand := StrToFloat(FinishCrand.Text);
  CurrentTexture.Ambient := StrToFloat(FinishAmbient.Text);
  CurrentTexture.Reflection := StrToFloat(FinishReflection.Text);
  CurrentTexture.Phong := StrToFloat(FinishPhong.Text);
  CurrentTexture.PhongSize := StrToFloat(FinishPhongSize.Text);
  CurrentTexture.Specular := StrToFloat(FinishSpecular.Text);
  CurrentTexture.Roughness := StrToFloat(FinishRoughness.Text);
  CurrentTexture.Metallic := FinishMetallic.Checked;
  CurrentTexture.Refraction := StrToFloat(FinishRefraction.Text);
  CurrentTexture.IOR := StrToFloat(FinishIOR.Text);
  CurrentTexture.Caustics := StrToFloat(FinishCaustics.Text);
  CurrentTexture.FadeDistance := StrToFloat(FinishFade.Text);
  CurrentTexture.FadePower := StrToFloat(FinishFadePower.Text);
  CurrentTexture.Irid := StrToFloat(FinishIrid.Text);
  CurrentTexture.IridThickness := StrToFloat(FinishIridThickness.Text);

  with CurrentTexture do
    FinishTurbulenceFrame.GetTurbulence(Turbulence, Octaves, Lambda, Omega);
end;

procedure TTextureForm.CloseItemClick(Sender: TObject);
begin
  Hide;
end;

procedure TTextureForm.NewItemClick(Sender: TObject);
var
  dlg: TTextTypeDlg;
  id: TTextureID;
  name: string;

begin
  dlg := TTextTypeDlg.Create(Application);

  if dlg.ShowModal = idOK then
  begin
    name := LowerCase(dlg.TypeList.Items[dlg.TypeList.ItemIndex]);
    for id := tiTexture to tiLastTexture do
      if TextureNames[id] = name then
      begin
        CreateTextureFromID(id);
        break;
      end;
  end;

  dlg.Free;
end;

procedure TTextureForm.FormShow(Sender: TObject);
begin
  CurrentTexture := nil;
  BuildList;
end;

procedure TTextureForm.FormCreate(Sender: TObject);
begin
  Dirty := false;
  ApplyBtn.Enabled := false;
  CurrentTexture := nil;
  SelectedMap := 0;
  NoPreview := TBitmap.Create;
  // TODO: need proper RESOURCE.RC and associated files
  //NoPreview.LoadFromResourceID(HInstance, 1004);
  TextureFolder := TIcon.Create;
  TextureFolder.Handle := LoadIcon(HInstance, MAKEINTRESOURCE(1005));
  Shape.ItemIndex := 0;
end;

procedure TTextureForm.SetDirty(Sender: TObject);
begin
  Dirty := true;
  ApplyBtn.Enabled := true;
end;

procedure TTextureForm.ApplyBtnClick(Sender: TObject);
begin
  if CurrentTexture <> nil then
  begin
    case CurrentTexture.GetID of
      tiUser:     GetUserSheet;
      tiColor:    GetColourSheet;
      tiChecker:  GetCheckerSheet;
    else
      if CurrentTexture.IsMapTexture then
        GetMapSheet;
    end;

    GetNormalSheet;
    GetFinishSheet;

    TSceneManager.SceneManager.SetModified;
  end;

  Dirty := false;
  ApplyBtn.Enabled := false;
end;

procedure TTextureForm.ValuePaintBoxPaint(Sender: TObject);
var
  MapTexture: TMapTexture;
  i, w, h1, h2, x1, x2: integer;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;
    if MapTexture.Maps.Count > 1 then
    begin
      w := ValuePaintBox.Width div MapTexture.Maps.Count;
      h1 := ValuePaintBox.Height div 3;
      h2 := h1 * 2;
      for i := 0 to MapTexture.Maps.Count - 1 do
      begin
        map := MapTexture.Maps[i];

        with ValuePaintBox.Canvas do
        begin
          if i = SelectedMap then
            Pen.Color := clRed
          else
            Pen.Color := clBlack;

          x1 := i * w + w div 2;
          MoveTo(x1, h2);
          LineTo(x1, h1 * 3);

          x2 := trunc((ValuePaintBox.Width - 1) * map.Value);
          MoveTo(x2, 0);
          LineTo(x2, h1);

          MoveTo(x1, h2);
          LineTo(x2, h1);
        end;
      end;
    end;
  end;
end;

procedure TTextureForm.ButtonPaintBoxPaint(Sender: TObject);
var
  MapTexture: TMapTexture;
  i, w: integer;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;
    if MapTexture.Maps.Count > 1 then
    begin
      w := ButtonPaintBox.Width div MapTexture.Maps.Count;
      for i := 0 to MapTexture.Maps.Count - 1 do
      begin
        map := MapTexture.Maps[i];
        with ButtonPaintBox.Canvas do
        begin
          if i = SelectedMap then
            Pen.Color := clRed
          else
            Pen.Color := clBlack;

          Brush.Color := RGB(trunc(map.Red * 255),
            trunc(map.Green * 255),
            trunc(map.Blue * 255));

          Rectangle(i * w, 0, i * w + w, ButtonPaintBox.Height);
        end;
      end;
    end;
  end;
end;

procedure TTextureForm.ValuePaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapTexture: TMapTexture;
  i, xm: integer;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;
    for i := 0 to MapTexture.Maps.Count - 1 do
    begin
      map := MapTexture.Maps[i];
      xm := trunc(map.Value * ValuePaintBox.Width);
      if abs(x - xm) < 5 then
      begin
        SetCurrentMap(i);
        ValuePaintBox.BeginDrag(False);
        ValuePaintBox.Refresh;
        ButtonPaintBox.Refresh;
        break;
      end;
    end;
  end;
end;

procedure TTextureForm.ValuePaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  MapTexture: TMapTexture;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    HoldMapApply := True;

    map := MapTexture.Maps[SelectedMap];

    map.Value := x / ValuePaintBox.Width;
    MapValue.Text := FloatToStrF(map.Value, ffFixed, 6, 4);

    ValuePaintBox.Refresh;

    HoldMapApply := False;

    Accept := True;
  end;
end;

procedure TTextureForm.ValuePaintBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  MapTexture: TMapTexture;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);
  end;
end;

procedure TTextureForm.ButtonPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapTexture: TMapTexture;
  i, w: integer;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    w := ButtonPaintBox.Width div MapTexture.Maps.Count;

    for i := 0 to MapTexture.Maps.Count - 1 do
    begin
      if (x > i * w) and (x < i * w + w) then
      begin
        SetCurrentMap(i);
        break;
      end;
    end;

    ButtonPaintBox.Refresh;
    ValuePaintBox.Refresh;
  end;
end;

procedure TTextureForm.MapCopyBtnClick(Sender: TObject);
var
  MapTexture: TMapTexture;
  map: TMapItem;
  col: TColourMapBlock;
  mem: TMemoryStream;
  handle: HGLOBAL;
  ptr: Pointer;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    map := MapTexture.Maps[SelectedMap];

    mem := TMemoryStream.Create;
    col := TColourMapBlock.Create;

    col.Red := map.Red;
    col.Green := map.Green;
    col.Blue := map.Blue;
    col.Filter := map.Filter;
    col.Transmit := map.Transmit;

    col.SaveToStream(mem);

    // Get a global handle
    handle := GlobalAlloc(ghnd, mem.Size);

    // Get the pointer
    ptr := GlobalLock(handle);

    // Copy the memory from the stream to the global block
    CopyMemory(ptr, mem.Memory, mem.Size);

    // Open the clipboard
    Clipboard.Open;

    // Move the global buffer into the clipboard
    Clipboard.SetAsHandle(MainForm.ColourClipForm, handle);

    // Put text in as well
    Clipboard.AsText := 'Map';

    // All done
    Clipboard.Close;

    col.Free;
    mem.Free;
  end;
end;

procedure TTextureForm.MapPasteBtnClick(Sender: TObject);
var
  MapTexture: TMapTexture;
  map: TMapItem;
  col: TColourMapBlock;
  mem: TMemoryStream;
  handle: HGLOBAL;
  size: DWORD;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    if Clipboard.HasFormat(MainForm.ColourClipForm) then
    begin
      // Open the clipboard
      Clipboard.Open;

      // Get the handle of the shape on the clipboard
      handle := Clipboard.GetAsHandle(MainForm.ColourClipForm);

      // Get the size of the shape
      size := GlobalSize(handle);

      // Create the memory stream
      mem := TMemoryStream.Create;

      // Allocate memory in stream
      mem.SetSize(size);

      // Copy from clipboard
      CopyMemory(mem.Memory, GlobalLock(handle), size);

      // Close the clipboard
      Clipboard.Close;

      map := MapTexture.Maps[SelectedMap];

      col := TColourMapBlock.Create;

      col.LoadFromStream(mem);

      map.Red := col.Red;
      map.Green := col.Green;
      map.Blue := col.Blue;
      map.Filter := col.Filter;
      map.Transmit := col.Transmit;

      col.Free;
      mem.Free;

      DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);
      ButtonPaintBox.Refresh;
    end;
  end;
end;

procedure TTextureForm.MapAddClick(Sender: TObject);
var
  MapTexture: TMapTexture;
  map, map1, map2: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    if SelectedMap < MapTexture.Maps.Count - 1 then
    begin
      map1 := MapTexture.Maps[SelectedMap];
      map2 := MapTexture.Maps[SelectedMap + 1];

      map := TMapItem.Create;
      map.SetRGBV(map1.Red + (map2.Red - map1.Red) / 2,
        map1.Green + (map2.Green - map1.Green) / 2,
        map1.Blue + (map2.Blue - map1.Blue) / 2,
        map1.Value + (map2.Value - map1.Value) / 2);

      MapTexture.Maps.Insert(SelectedMap + 1, map);

      SetCurrentMap(SelectedMap + 1);
    end
    else
    begin
      map1 := MapTexture.Maps[SelectedMap];

      map := TMapItem.Create;
      map.SetRGBV(map1.Red, map1.Green, map1.Blue, map1.Value + (1 - map1.Value) / 2);

      MapTexture.Maps.Add(map);

      SetCurrentMap(MapTexture.Maps.Count - 1);
    end;

    DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);

    ValuePaintBox.Refresh;
    ButtonPaintBox.Refresh;
  end;
end;

procedure TTextureForm.MapRemoveClick(Sender: TObject);
var
  MapTexture: TMapTexture;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    if MapTexture.Maps.Count > 2 then
    begin
      MapTexture.Maps.Delete(SelectedMap);

      if SelectedMap > MapTexture.Maps.Count - 1 then
        SelectedMap := MapTexture.Maps.Count - 1;

      DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);

      ValuePaintBox.Refresh;
      ButtonPaintBox.Refresh;
    end
    else
      MessageDlg('There should be at least two entries in a map', mtError,
        [mbOK], 0);
  end;
end;

procedure TTextureForm.MapAssignClick(Sender: TObject);
var
  MapTexture: TMapTexture;
  map: TMapItem;

begin
  if CurrentTexture is TMapTexture then
  begin
    MapTexture := CurrentTexture as TMapTexture;

    map := MapTexture.Maps[SelectedMap];

    MapRGBFTFrame.GetColour(map.Red, map.Green, map.Blue, map.Transmit, map.Filter);

    DrawColourMap(MapImage.Width, MapImage.Height, MapImage.Canvas, MapTexture.Maps);

    ValuePaintBox.Refresh;
    ButtonPaintBox.Refresh;
  end;
end;

procedure TTextureForm.PreviewBtnClick(Sender: TObject);
var
  dest: TextFile;
  command: string;

begin
  if CurrentTexture <> nil then
  begin
    AssignFile(dest, 'preview.pov');
    Rewrite(dest);
    CurrentTexture.Preview(dest, Shape.ItemIndex, Floor.Checked, Wall.Checked, FloorColour.Brush.Color, WallColour.Brush.Color);
    CloseFile(dest);

    command := MainForm.POVCommand +
      ' +w160 +h120 +fs +b +ipreview.pov +o' +
      GetTexturesDirectory() + '\' +
      CurrentTexture.Name + '.bmp';

    if LowerCase(ExtractFileName(MainForm.POVCommand)) = 'pvengine.exe' then
      command := command + ' /EXIT';

    WinExecAndWait32(command, SW_HIDE);
    ConvertBitmapToJPEG(GetTexturesDirectory() + '\' + CurrentTexture.Name);
    DeleteFile(PChar(GetTexturesDirectory() + '\' + CurrentTexture.Name + '.bmp'));
    PreviewImage.Picture.LoadFromFile(GetTexturesDirectory() + '\' + CurrentTexture.Name + '.jpg');
  end;
end;

procedure TTextureForm.FloorColourMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog.Color := FloorColour.Brush.Color;
  if ColorDialog.Execute then
    FloorColour.Brush.Color := ColorDialog.Color;
end;

procedure TTextureForm.WallColourMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog.Color := WallColour.Brush.Color;
  if ColorDialog.Execute then
    WallColour.Brush.Color := ColorDialog.Color;
end;

procedure TTextureForm.TextureListChange(Sender: TObject; Node: TTreeNode);
var
  name: string;

begin
  if Node <> nil then
  begin
    CurrentTexture := Node.Data;
    if CurrentTexture <> nil then
    begin
      // Which of the specific sheets to display
      UserSheet.TabVisible := (CurrentTexture.GetID = tiUser);
      ColourSheet.TabVisible := (CurrentTexture.GetID = tiColor);
      CheckerSheet.TabVisible := (CurrentTexture.GetID = tiChecker);
      MapSheet.TabVisible := CurrentTexture.IsMapTexture;

      // The specific sheets
      case CurrentTexture.GetID of
        tiUser: SetUserSheet;
        tiColor: SetColourSheet;
        tiChecker: SetCheckerSheet;
      else
        if CurrentTexture.IsMapTexture then
          SetMapSheet;
      end;

      // The common sheets
      SetNormalSheet;
      SetFinishSheet;

      // The image preview
      name := GetTexturesDirectory + '\' + CurrentTexture.Name + '.jpg';

      if FileExists(name) then
        PreviewImage.Picture.LoadFromFile(name)
      else
        PreviewImage.Picture.Bitmap.Assign(NoPreview);

      Dirty := false;
      ApplyBtn.Enabled := false;
    end;
  end;
end;

procedure TTextureForm.TextureListChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := not Dirty;
end;

procedure TTextureForm.FilenameBrowseClick(Sender: TObject);
begin
  OpenDialog.Filename := Filename.Text;
  if OpenDialog.Execute then
    Filename.Text := OpenDialog.Filename;
end;

procedure TTextureForm.LoadActionExecute(Sender: TObject);
var
  source: TParseFile;
  user: TUserTexture;
  category, name, declare, filename: string;
  red, green, blue: double;

begin
  OpenDialog.Filter := 'Descriptions|*.des';

  if OpenDialog.Execute then
  begin
    source := TParseFile.Create(OpenDialog.Filename);
    try
      while not source.Eof do
      begin
        source.Parse(' ', category);
        source.Parse(' ', name);
        source.Parse(' ', red);
        source.Parse(' ', green);
        source.Parse(' ', blue);
        source.Parse(' ', declare);
        source.Parse(' ', filename);

        user := TUserTexture.Create;

        user.Category := category;
        user.Name := name;
        user.Red := red;
        user.Green := green;
        user.Blue := blue;
        user.Declare := declare;
        user.Filename := filename;

        if Length(user.Name) > 0 then
        begin
          TTextureManager.TextureManager.Textures.Add(user);

          AddTexture(user);
        end
        else
          user.Free;
      end;
      MainForm.TextPaintBox.Width := TTextureManager.TextureManager.Textures.Count * TextSize;
      MainForm.TextPaintBox.Refresh;
    finally
      source.Free;
    end;
  end;
end;

end.
