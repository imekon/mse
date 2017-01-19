unit Textdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TabNotBk, StdCtrls, Buttons, ComCtrls, JPEG, Rgbft, Grids,
  ExtCtrls, Texture, Halo, Menus;

type
  THaloDrag = class(TDragObject)
  public
    FullList: boolean;
    Index: integer;
    Halo: THalo;

    constructor Create(full: boolean; i: integer; h: THalo);
  end;

  TTextureDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    Texture: TTabSheet;
    Normal: TTabSheet;
    Finish: TTabSheet;
    Halo: TTabSheet;
    Transformations: TTabSheet;
    Label1: TLabel;
    Name: TEdit;
    Label2: TLabel;
    Diffuse: TEdit;
    Label3: TLabel;
    Brilliance: TEdit;
    Label4: TLabel;
    Crand: TEdit;
    Label5: TLabel;
    Ambient: TEdit;
    Label6: TLabel;
    Reflection: TEdit;
    Label7: TLabel;
    Phong: TEdit;
    PhongSize: TEdit;
    Label8: TLabel;
    Specular: TEdit;
    Roughness: TEdit;
    Metallic: TCheckBox;
    Label9: TLabel;
    Refraction: TEdit;
    IOR: TEdit;
    Label15: TLabel;
    Caustics: TEdit;
    Label16: TLabel;
    FadeDistance: TEdit;
    FadePower: TEdit;
    Label17: TLabel;
    Irid: TEdit;
    IridThickness: TEdit;
    IridVectorBtn: TBitBtn;
    Label18: TLabel;
    XTrans: TEdit;
    YTrans: TEdit;
    ZTrans: TEdit;
    Label19: TLabel;
    XScale: TEdit;
    YScale: TEdit;
    ZScale: TEdit;
    Label20: TLabel;
    XRotate: TEdit;
    YRotate: TEdit;
    ZRotate: TEdit;
    HaloAddBtn: TButton;
    HaloEditBtn: TButton;
    HaloDeleteBtn: TButton;
    PreviewPanel: TPanel;
    PreviewImage: TImage;
    PreviewBtn: TButton;
    nTypeLbl: TLabel;
    NormalType: TComboBox;
    nValueLbl: TLabel;
    NormalValue: TEdit;
    NormalTurbulenceBtn: TButton;
    TurbulenceBtn: TButton;
    NormalDefaults: TButton;
    FinishDefaults: TButton;
    TransformationDefaults: TButton;
    HaloList: TListBox;
    FullHaloList: TListBox;
    PhongMenu: TPopupMenu;
    PhongDullItem: TMenuItem;
    PhongPlasticItem: TMenuItem;
    PhongHighlyPolishedItem: TMenuItem;
    PhongBrowse: TSpeedButton;
    RefractionBrowse: TSpeedButton;
    RefractionMenu: TPopupMenu;
    PhongNoneItem: TMenuItem;
    N1: TMenuItem;
    RefNoneItem: TMenuItem;
    N2: TMenuItem;
    RefWaterItem: TMenuItem;
    RefGlassItem: TMenuItem;
    RefFlintGlassItem: TMenuItem;
    RefDiamondItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure IridVectorBtnClick(Sender: TObject);
    procedure NormalTurbulenceBtnClick(Sender: TObject);
    procedure TurbulenceBtnClick(Sender: TObject);
    procedure NormalDefaultsClick(Sender: TObject);
    procedure FinishDefaultsClick(Sender: TObject);
    procedure TransformationDefaultsClick(Sender: TObject);
    procedure FullHaloListClick(Sender: TObject);
    procedure HaloAddBtnClick(Sender: TObject);
    procedure HaloDeleteBtnClick(Sender: TObject);
    procedure HaloListClick(Sender: TObject);
    procedure FullHaloListStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FullHaloListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure HaloListStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure HaloListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure HaloListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FullHaloListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PhongDullItemClick(Sender: TObject);
    procedure PhongPlasticItemClick(Sender: TObject);
    procedure PhongHighlyPolishedItemClick(Sender: TObject);
    procedure PhongBrowseClick(Sender: TObject);
    procedure PhongNoneItemClick(Sender: TObject);
    procedure RefNoneItemClick(Sender: TObject);
    procedure RefWaterItemClick(Sender: TObject);
    procedure RefGlassItemClick(Sender: TObject);
    procedure RefFlintGlassItemClick(Sender: TObject);
    procedure RefDiamondItemClick(Sender: TObject);
    procedure RefractionBrowseClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetPreview;
  protected
    theTexture: TTexture;

    function GetTemporaryTexture: TTexture; virtual;
    procedure GetIntoTexture(texture: TTexture); virtual;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); virtual;
    procedure GetTexture;
  end;

implementation

uses misc, main, iriddlg, turbulence, prevdlg;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
//  THaloDrag

constructor THaloDrag.Create(full: boolean; i: integer; h: THalo);
begin
  FullList := full;
  Index := i;
  Halo := h;
end;

////////////////////////////////////////////////////////////////////////////////
//  TTextureDlg

procedure TTextureDlg.SetPreview;
var
  PreviewFile: string;

begin
  // Look for preview files
  PreviewFile := MainForm.GetTexturesDirectory + '\' + theTexture.Name + '.jpg';
  if FileExists(PreviewFile) then
    PreviewImage.Picture.LoadFromFile(PreviewFile)
  else
    PreviewPanel.Caption := 'No preview available';
end;

procedure TTextureDlg.SetTexture(ATexture: TTexture);
var
  i: integer;
  halo: THalo;

begin
  theTexture := ATexture;

  Name.Text :=        theTexture.Name;

  // Transformations
  XTrans.Text :=      FloatToStrF(theTexture.Translate.X, ffFixed, 6, 4);
  YTrans.Text :=      FloatToStrF(theTexture.Translate.Y, ffFixed, 6, 4);
  ZTrans.Text :=      FloatToStrF(theTexture.Translate.Z, ffFixed, 6, 4);
  XScale.Text :=      FloatToStrF(theTexture.Scale.X, ffFixed, 6, 4);
  YScale.Text :=      FloatToStrF(theTexture.Scale.Y, ffFixed, 6, 4);
  ZScale.Text :=      FloatToStrF(theTexture.Scale.Z, ffFixed, 6, 4);
  XRotate.Text :=      FloatToStrF(theTexture.Rotate.X, ffFixed, 6, 4);
  YRotate.Text :=      FloatToStrF(theTexture.Rotate.Y, ffFixed, 6, 4);
  ZRotate.Text :=      FloatToStrF(theTexture.Rotate.Z, ffFixed, 6, 4);

  // finish values
  Diffuse.Text :=     FloatToStrF(theTexture.Diffuse, ffFixed, 6, 4);
  Brilliance.Text :=  FloatToStrF(theTexture.Brilliance, ffFixed, 6, 4);
  Crand.Text :=       FloatToStrF(theTexture.Crand, ffFixed, 6, 4);
  Ambient.Text :=     FloatToStrF(theTexture.Ambient, ffFixed, 6, 4);
  Reflection.Text :=  FloatToStrF(theTexture.Reflection, ffFixed, 6, 4);
  Phong.Text :=       FloatToStrF(theTexture.Phong, ffFixed, 6, 4);
  PhongSize.Text :=   FloatToStrF(theTexture.PhongSize, ffFixed, 6, 4);
  Specular.Text :=    FloatToStrF(theTexture.Specular, ffFixed, 6, 4);
  Roughness.Text :=   FloatToStrF(theTexture.Roughness, ffFixed, 6, 4);

  if theTexture.Metallic then
    Metallic.State := cbChecked
  else
    Metallic.State := cbUnchecked;

  Refraction.Text :=  FloatToStrF(theTexture.Refraction, ffFixed, 6, 4);
  IOR.Text :=         FloatToStrF(theTexture.IOR, ffFixed, 6, 4);

  Caustics.Text :=    FloatToStrF(theTexture.Caustics, ffFixed, 6, 4);
  FadeDistance.Text := FloatToStrF(theTexture.FadeDistance, ffFixed, 6, 4);
  FadePower.Text :=   FloatToStrF(theTexture.FadePower, ffFixed, 6, 4);
  Irid.Text :=        FloatToStrF(theTexture.Irid, ffFixed, 6, 4);
  IridThickness.Text := FloatToStrF(theTexture.IridThickness, ffFixed, 6, 4);

  // normal values
  NormalType.ItemIndex := ord(theTexture.NormalType);
  NormalValue.Text := FloatToStrF(theTexture.NormalValue, ffFixed, 6, 4);

  // Build halo list
  for i := 0 to theTexture.Halos.Count - 1 do
  begin
    halo := theTexture.Halos[i];
    HaloList.Items.AddObject(halo.Name, halo);
  end;

  // Build full halo list
  for i := 0 to MainForm.Halos.Count - 1 do
  begin
    halo := MainForm.Halos[i];
    if theTexture.Halos.IndexOf(halo) = -1 then
      FullHaloList.Items.AddObject(halo.Name, halo);
  end;

  SetPreview;
end;

procedure TTextureDlg.FormCreate(Sender: TObject);
begin
  theTexture := nil;
  NormalType.ItemIndex := 0;
end;

function TTextureDlg.GetTemporaryTexture: TTexture;
begin
  result := TTexture.Create;
end;

procedure TTextureDlg.PreviewBtnClick(Sender: TObject);
var
  filename, command: string;
  dest: TextFile;
  dlg: TPreviewDialog;
  texture: TTexture;

begin
  texture := GetTemporaryTexture;

  GetIntoTexture(texture);

  dlg := TPreviewDialog.Create(Application);

  dlg.Shape.ItemIndex := 0;

  if dlg.ShowModal = idOK then
  begin
    if texture <> nil then
    begin
      Screen.Cursor := crHourglass;
      filename := theTexture.Name + '.pov';
      AssignFile(dest, filename);
      try
        Rewrite(dest);
        texture.Preview(dest, dlg.Shape.ItemIndex,
          dlg.Floor.Checked, dlg.Wall.Checked,
          dlg.FFloorColour, dlg.FWallColour);
      finally
        CloseFile(dest);
      end;

      command := MainForm.POVCommand +
        ' +w160 +h120 +fs +b +i' + filename + ' +o' +
        MainForm.GetTexturesDirectory() + '\' +
        texture.Name + '.bmp';

      if LowerCase(ExtractFileName(MainForm.POVCommand)) = 'pvengine.exe' then
        command := command + ' /EXIT';

      WinExecAndWait32(command, SW_HIDE);
      ConvertBitmapToJPEG(MainForm.GetTexturesDirectory() + '\' + texture.Name);
      DeleteFile(PChar(MainForm.GetTexturesDirectory() + '\' + texture.Name + '.bmp'));
      SetPreview;
      Screen.Cursor := crDefault;
    end;
  end;

  dlg.Free;

  texture.Free;
end;

procedure TTextureDlg.GetIntoTexture(texture: TTexture);
var
  i: integer;
  halo: THalo;

begin
  { name }
  texture.Name := Name.Text;

  { transforms }
  texture.Translate.X := StrToFloat(XTrans.Text);
  texture.Translate.Y := StrToFloat(YTrans.Text);
  texture.Translate.Z := StrToFloat(ZTrans.Text);
  texture.Scale.X := StrToFloat(XScale.Text);
  texture.Scale.Y := StrToFloat(YScale.Text);
  texture.Scale.Z := StrToFloat(ZScale.Text);
  texture.Rotate.X := StrToFloat(XRotate.Text);
  texture.Rotate.Y := StrToFloat(YRotate.Text);
  texture.Rotate.Z := StrToFloat(ZRotate.Text);

  { finish }
  texture.Diffuse :=     StrToFloat(Diffuse.Text);
  texture.Brilliance :=  StrToFloat(Brilliance.Text);
  texture.Crand :=       StrToFloat(Crand.Text);
  texture.Ambient :=     StrToFloat(Ambient.Text);
  texture.Reflection :=  StrToFloat(Reflection.Text);
  texture.Phong :=       StrToFloat(Phong.Text);
  texture.PhongSize :=   StrToFloat(PhongSize.Text);
  texture.Specular :=    StrToFloat(Specular.Text);
  texture.Roughness :=   StrToFloat(Roughness.Text);

  if Metallic.State = cbChecked then
     texture.Metallic := True
  else
     texture.Metallic := False;

  texture.Refraction :=  StrToFloat(Refraction.Text);
  texture.IOR :=         StrToFloat(IOR.Text);

  texture.Caustics :=    StrToFloat(Caustics.Text);
  texture.FadeDistance := StrToFloat(FadeDistance.Text);
  texture.FadePower :=   StrToFloat(FadePower.Text);
  texture.Irid :=        StrToFloat(Irid.Text);
  texture.IridThickness := StrToFloat(IridThickness.Text);

  { normal }
  texture.NormalType :=  TNormalType(NormalType.ItemIndex);
  texture.NormalValue := StrToFloat(NormalValue.Text);

  // Halos
  texture.ClearHalos;
  for i := 0 to HaloList.Items.Count - 1 do
  begin
    halo := HaloList.Items.Objects[i] as THalo;
    texture.Halos.Add(halo);
  end;
end;

procedure TTextureDlg.GetTexture;
begin
  GetIntoTexture(theTexture);
end;

procedure TTextureDlg.IridVectorBtnClick(Sender: TObject);
var
  dlg: TIridVectorDialog;

begin
  dlg := TIridVectorDialog.Create(Application);

  dlg.XValue.Text := FloatToStrF(theTexture.IridVector.X, ffFixed, 6, 4);
  dlg.YValue.Text := FloatToStrF(theTexture.IridVector.Y, ffFixed, 6, 4);
  dlg.ZValue.Text := FloatToStrF(theTexture.IridVector.Z, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    theTexture.IridVector.X := StrToFloat(dlg.XValue.Text);
    theTexture.IridVector.Y := StrToFloat(dlg.YValue.Text);
    theTexture.IridVector.Z := StrToFloat(dlg.ZValue.Text);
  end;

  dlg.Free;
end;

procedure TTextureDlg.NormalTurbulenceBtnClick(Sender: TObject);
var
  dlg: TTurbulenceDialog;

begin
  dlg := TTurbulenceDialog.Create(Application);

  dlg.Turbulence.Text := FloatToStrF(theTexture.NormalTurbulence, ffFixed, 6, 4);
  dlg.Octaves.Text := IntToStr(theTexture.NormalOctaves);
  dlg.Lambda.Text := FloatToStrF(theTexture.NormalLambda, ffFixed, 6, 4);
  dlg.Omega.Text := FloatToStrF(theTexture.NormalOmega, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    theTexture.NormalTurbulence := StrToFloat(dlg.Turbulence.Text);
    theTexture.NormalOctaves := StrToInt(dlg.Octaves.Text);
    theTexture.NormalLambda := StrToFloat(dlg.Lambda.Text);
    theTexture.NormalOmega := StrToFloat(dlg.Omega.Text);
  end;

  dlg.Free;
end;

procedure TTextureDlg.TurbulenceBtnClick(Sender: TObject);
var
  dlg: TTurbulenceDialog;

begin
  dlg := TTurbulenceDialog.Create(Application);

  dlg.Turbulence.Text := FloatToStrF(theTexture.Turbulence, ffFixed, 6, 4);
  dlg.Octaves.Text := IntToStr(theTexture.Octaves);
  dlg.Lambda.Text := FloatToStrF(theTexture.Lambda, ffFixed, 6, 4);
  dlg.Omega.Text := FloatToStrF(theTexture.Omega, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    theTexture.Turbulence := StrToFloat(dlg.Turbulence.Text);
    theTexture.Octaves := StrToInt(dlg.Octaves.Text);
    theTexture.Lambda := StrToFloat(dlg.Lambda.Text);
    theTexture.Omega := StrToFloat(dlg.Omega.Text);
  end;

  dlg.Free;
end;

procedure TTextureDlg.NormalDefaultsClick(Sender: TObject);
begin
  NormalType.ItemIndex := 0;
  NormalValue.Text := '0';
end;

procedure TTextureDlg.FinishDefaultsClick(Sender: TObject);
begin
  Diffuse.Text := '0.7';
  Brilliance.Text := '1.0';
  Crand.Text := '0.0';
  Ambient.Text := '0.1';
  Reflection.Text := '0.0';
  Phong.Text := '0.0';
  PhongSize.Text := '0.0';
  Specular.Text := '0.0';
  Roughness.Text := '0.05';
  Metallic.Checked := False;
  Refraction.Text := '0.0';
  IOR.Text := '0.0';
  Caustics.Text := '0.0';
  FadeDistance.Text := '0.0';
  FadePower.Text := '0.0';
  Irid.Text := '0.25';
  IridThickness.Text := '1.0';
end;

procedure TTextureDlg.TransformationDefaultsClick(Sender: TObject);
begin
  XTrans.Text := '0';
  YTrans.Text := '0';
  ZTrans.Text := '0';

  XScale.Text := '1';
  YScale.Text := '1';
  ZScale.Text := '1';

  XRotate.Text := '0';
  YRotate.Text := '0';
  ZRotate.Text := '0';
end;

procedure TTextureDlg.FullHaloListClick(Sender: TObject);
begin
  HaloAddBtn.Enabled := true;
  HaloEditBtn.Enabled := true;
end;

procedure TTextureDlg.HaloAddBtnClick(Sender: TObject);
var
  index: integer;
  halo: THalo;

begin
  index := FullHaloList.ItemIndex;
  if index <> -1 then
  begin
    halo := FullHaloList.Items.Objects[index] as THalo;
    FullHaloList.Items.Delete(index);
    HaloList.Items.AddObject(halo.Name, halo);
  end;
  HaloAddBtn.Enabled := false;
  HaloEditBtn.Enabled := false;
end;

procedure TTextureDlg.HaloDeleteBtnClick(Sender: TObject);
var
  index: integer;
  halo: THalo;

begin
  index := HaloList.ItemIndex;
  if index <> - 1 then
  begin
    halo := HaloList.Items.Objects[index] as THalo;
    HaloList.Items.Delete(index);
    FullHaloList.Items.AddObject(halo.Name, halo);
  end;
  HaloDeleteBtn.Enabled := false;
end;

procedure TTextureDlg.HaloListClick(Sender: TObject);
begin
  HaloDeleteBtn.Enabled := true;
end;

procedure TTextureDlg.FullHaloListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  index: integer;
  drag: THaloDrag;
  halo: THalo;

begin
  index := FullHaloList.ItemIndex;

  if index <> -1 then
  begin
    halo := FullHaloList.Items.Objects[index] as THalo;
    drag := THaloDrag.Create(true, index, halo);
    DragObject := drag;
  end;
end;

procedure TTextureDlg.FullHaloListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  drag: THaloDrag;

begin
  if IsDragObject(Source) then
  begin
    drag := Source as THaloDrag;
    Accept := not drag.FullList;
  end
  else
    Accept := false;
end;

procedure TTextureDlg.HaloListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  index: integer;
  drag: THaloDrag;
  halo: THalo;

begin
  index := HaloList.ItemIndex;

  if index <> -1 then
  begin
    halo := HaloList.Items.Objects[index] as THalo;
    drag := THaloDrag.Create(false, index, halo);
    DragObject := drag;
  end;
end;

procedure TTextureDlg.HaloListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  drag: THaloDrag;

begin
  if IsDragObject(Source) then
  begin
    drag := Source as THaloDrag;
    Accept := drag.FullList;
  end
  else
    Accept := false;
end;

procedure TTextureDlg.HaloListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  drag: THaloDrag;

begin
  if IsDragObject(Source) then
  begin
    drag := Source as THaloDrag;
    HaloList.Items.AddObject(drag.Halo.Name, drag.Halo);
    FullHaloList.Items.Delete(drag.Index);
  end;
end;

procedure TTextureDlg.FullHaloListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  drag: THaloDrag;

begin
  if IsDragObject(Source) then
  begin
    drag := Source as THaloDrag;
    FullHaloList.Items.AddObject(drag.Halo.Name, drag.Halo);
    HaloList.Items.Delete(drag.Index);
  end;
end;

procedure TTextureDlg.PhongDullItemClick(Sender: TObject);
begin
  Phong.Text := '0.7';
  PhongSize.Text := '1.0';
end;

procedure TTextureDlg.PhongPlasticItemClick(Sender: TObject);
begin
  Phong.Text := '0.7';
  PhongSize.Text := '40.0';
end;

procedure TTextureDlg.PhongHighlyPolishedItemClick(Sender: TObject);
begin
  Phong.Text := '0.7';
  PhongSize.Text := '250.0';
end;

procedure TTextureDlg.PhongBrowseClick(Sender: TObject);
var
  p, q: TPoint;

begin
  p.X := PhongBrowse.Left;
  p.Y := PhongBrowse.Top + PhongBrowse.Height;
  q := Finish.ClientToScreen(p);
  PhongMenu.Popup(q.X, q.Y);
end;


procedure TTextureDlg.PhongNoneItemClick(Sender: TObject);
begin
  Phong.Text := '0.0';
  PhongSize.Text := '0.0';
end;

procedure TTextureDlg.RefNoneItemClick(Sender: TObject);
begin
  Refraction.Text := '0.0';
  IOR.Text := '1.0';
end;

procedure TTextureDlg.RefWaterItemClick(Sender: TObject);
begin
  Refraction.Text := '1.0';
  IOR.Text := '1.33';
end;

procedure TTextureDlg.RefGlassItemClick(Sender: TObject);
begin
  Refraction.Text := '1.0';
  IOR.Text := '1.5';
end;

procedure TTextureDlg.RefFlintGlassItemClick(Sender: TObject);
begin
  Refraction.Text := '1.0';
  IOR.Text := '1.71';
end;

procedure TTextureDlg.RefDiamondItemClick(Sender: TObject);
begin
  Refraction.Text := '1.0';
  IOR.Text := '2.41';
end;

procedure TTextureDlg.RefractionBrowseClick(Sender: TObject);
var
  p, q: TPoint;

begin
  p.X := RefractionBrowse.Left;
  p.Y := RefractionBrowse.Top + RefractionBrowse.Height;
  q := Finish.ClientToScreen(p);
  RefractionMenu.Popup(q.X, q.Y);
end;

end.
