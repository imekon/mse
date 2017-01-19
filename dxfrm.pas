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

// Author: Pete Goodwin (pgoodwin@blueyonder.co.uk)

unit dxfrm;

interface

{$INCLUDE DirectX.inc}

{$IFDEF USE_DIRECTX}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DirectX, Menus, ActnList, AppEvnts, ComCtrls, ExtCtrls;

type
  TDirectXForm = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    CloseItem: TMenuItem;
    RenderMenu: TMenuItem;
    FlatItem: TMenuItem;
    GouraudItem: TMenuItem;
    WireframeItem: TMenuItem;
    N1: TMenuItem;
    LightingItem: TMenuItem;
    N2: TMenuItem;
    PointItem: TMenuItem;
    SolidItem: TMenuItem;
    N3: TMenuItem;
    AntialiasingItem: TMenuItem;
    DitheringItem: TMenuItem;
    ActionList: TActionList;
    CloseAction: TAction;
    FlatAction: TAction;
    GouraudAction: TAction;
    LightingAction: TAction;
    PointAction: TAction;
    WireframeAction: TAction;
    SolidAction: TAction;
    DitheringAction: TAction;
    AntiAliasingAction: TAction;
    PhongAction: TAction;
    PhongItem: TMenuItem;
    ViewMenu: TMenuItem;
    Statistics1: TMenuItem;
    StatisticsAction: TAction;
    ApplicationEvents: TApplicationEvents;
    StatusBar: TStatusBar;
    Tick: TTimer;
    procedure FormHide(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure FlatItemClick(Sender: TObject);
    procedure WireframeItemClick(Sender: TObject);
    procedure GouraudItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LightingItemClick(Sender: TObject);
    procedure PointItemClick(Sender: TObject);
    procedure SolidItemClick(Sender: TObject);
    procedure FlatActionUpdate(Sender: TObject);
    procedure GouraudActionUpdate(Sender: TObject);
    procedure LightingActionUpdate(Sender: TObject);
    procedure PointActionUpdate(Sender: TObject);
    procedure WireframeActionUpdate(Sender: TObject);
    procedure SolidActionUpdate(Sender: TObject);
    procedure PhongActionExecute(Sender: TObject);
    procedure PhongActionUpdate(Sender: TObject);
    procedure AntiAliasingActionExecute(Sender: TObject);
    procedure AntiAliasingActionUpdate(Sender: TObject);
    procedure DitheringActionExecute(Sender: TObject);
    procedure DitheringActionUpdate(Sender: TObject);
    procedure StatisticsActionExecute(Sender: TObject);
    procedure StatisticsActionUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormShow(Sender: TObject);
    procedure TickTimer(Sender: TObject);
  private
    { Private declarations }
    bEnabled, bStats: boolean;
    dwTime, dwElapsed, Shade, Light, Fill: DWORD;

    D3DRM: IDirect3DRM;
    Clipper: IDirectDrawClipper;
    Device: IDirect3DRMDevice;
    SceneCamera, Scene: IDirect3DRMFrame;
    Viewport: IDirect3DRMViewport;
    AmbientLight: IDirect3DRMLight;

    function GetRenderState(stateType: TD3DRenderStateType): Cardinal;
    procedure SetRenderState(stateType: TD3DRenderStateType; state: Cardinal);

    function GetGuid: TGUID;
    procedure CreateDevice;
    procedure CreateScene;
    procedure ShowScene;
  protected
    procedure WMActivate(var msg: TMessage); message WM_ACTIVATE;
    procedure WMPaint(var msg: TMessage); message WM_PAINT;
    procedure WMEraseBkgnd(var msg: TMessage); message WM_ERASEBKGND;
  public
    { Public declarations }
  end;

var
  DirectXForm: TDirectXForm;
{$ENDIF}

implementation

uses Scene, main;

{$R *.DFM}

{$IFDEF USE_DIRECTX}
function D3DCOLOR_2_COLORREF(d3dclr: TD3DCOLOR): TColor;
var
  red, green, blue: TD3DVALUE;

begin
  red := 255 * D3DRMColorGetRed(d3dclr);
  green := 255 * D3DRMColorGetGreen(d3dclr);
  blue := 255 * D3DRMColorGetBlue(d3dclr);

  result := RGB(trunc(red), trunc(green), trunc(blue));
end;

function TDirectXForm.GetRenderState(stateType: TD3DRenderStateType): Cardinal;
var
  state: Cardinal;
  device3drm2: IDirect3DRMDevice2;
  device2: IDirect3DDevice2;

begin
  state := 0;

  device3drm2 := Device as IDirect3DRMDevice2;

  if SUCCEEDED(device3drm2.GetDirect3DDevice2(device2)) then
  begin
    if device2 <> nil then
    begin
      device2.GetRenderState(D3DRENDERSTATE_ANTIALIAS, state);

      device2 := nil;
    end;
  end;

  device3drm2 := nil;

  result := state;
end;

procedure TDirectXForm.SetRenderState(stateType: TD3DRenderStateType; state: Cardinal);
var
  device3drm2: IDirect3DRMDevice2;
  device2: IDirect3DDevice2;

begin
  device3drm2 := Device as IDirect3DRMDevice2;

  if SUCCEEDED(device3drm2.GetDirect3DDevice2(device2)) then
  begin
    if device2 <> nil then
    begin
      device2.SetRenderState(D3DRENDERSTATE_ANTIALIAS, state);

      device2 := nil;
    end;
  end;

  device3drm2 := nil;
end;

function TDirectXForm.GetGuid: TGUID;
const
  zero_guid: TGUID = '{00000000-0000-0000-C000-000000000000}';

var
  guid: TGUID;
  searchdata: TD3DFINDDEVICESEARCH;
  resultdata: TD3DFINDDEVICERESULT;
  ddraw: IDirectDraw;
  d3d: IDirect3D;

begin
  guid := zero_guid;

  ZeroMemory(@searchdata, sizeof(TD3DFINDDEVICESEARCH));

  with searchdata do
  begin
   dwSize := sizeof(D3DFINDDEVICESEARCH);
   dwFlags := D3DFDS_COLORMODEL;
   dcmColorModel := D3DCOLOR_MONO;
  end;

  ZeroMemory(@resultdata, sizeof(D3DFINDDEVICERESULT));

  resultdata.dwSize := sizeof(TD3DFINDDEVICERESULT);

  if FAILED(DirectDrawCreate(nil, ddraw, nil)) then
  begin
    exit;
  end;

  d3d := ddraw as IDirect3D;

  if SUCCEEDED(d3d.FindDevice(searchdata, resultdata)) then
  begin
    guid := resultdata.guid;
  end;

  d3d := nil;
  ddraw := nil;

  result := guid;
end;

procedure TDirectXForm.CreateDevice;
var
  bpp: integer;

begin
  if FAILED(DirectDrawCreateClipper(0, clipper, nil)) then
  begin
    exit;
  end;

  if FAILED(Clipper.SetHWnd(0, Handle)) then
  begin
    exit;
  end;

  if FAILED(D3DRM.CreateDeviceFromClipper(clipper, GetGUID, ClientWidth, ClientHeight, device)) then
  begin
    exit;
  end;

  device.SetQuality(D3DRMRENDER_GOURAUD);

  bpp := GetDeviceCaps(Canvas.Handle, BITSPIXEL);

  case bpp of
  8:
    begin
      Device.SetDither(FALSE);
    end;

  16:
    begin
      Device.SetShades(32);
      d3drm.SetDefaultTextureColors(64);
      d3drm.SetDefaultTextureShades(32);
      device.SetDither(FALSE);
    end;

  24, 32:
    begin
      device.SetShades(256);
      d3drm.SetDefaultTextureColors(64);
      d3drm.SetDefaultTextureShades(256);
      device.SetDither(FALSE);
    end;
  end;

  if FAILED(d3drm.CreateFrame(nil, scene)) then
  begin
    exit;
  end;

  CreateScene;
end;

procedure TDirectXForm.CreateScene;
begin
  // Set scene background
  scene.SetSceneBackgroundRGB(0.2, 0.2, 0.2);

  // Create an ambient light source
  D3DRM.CreateLightRGB(D3DRMLIGHT_AMBIENT, 0.1, 0.1, 0.1, AmbientLight);
  Scene.AddLight(AmbientLight);

  // Camera
  d3drm.CreateFrame(scene, SceneCamera);
  SceneCamera.SetPosition(scene, 0, 0, -30);
  d3drm.CreateViewport(device, SceneCamera, 0, 0, device.GetWidth, device.GetHeight, viewport);

  Device.SetQuality(Shade + Light + Fill);

  bEnabled := true;
end;

procedure TDirectXForm.ShowScene;
var
  i, n: integer;
  shape: TShape;
  camera: TCamera;
  MeshFrame, LookAtFrame, child: IDirect3DRMFrame;
  children: IDirect3DRMFrameArray;
  light: IDirect3DRMLight;
  lights: IDirect3DRMLightArray;

begin
  // Remove any existing children (except camera)
  if SUCCEEDED(Scene.GetChildren(children)) then
  begin
    n := children.GetSize;

    for i := 0 to n - 1 do
    begin
      if SUCCEEDED(children.GetElement(i, child)) then
      begin
        if child <> SceneCamera then
          Scene.DeleteChild(child);

        child := nil;
      end;
    end;

    children := nil;
  end;

  // Remove any existing lights (except the ambient)
  if SUCCEEDED(Scene.GetLights(lights)) then
  begin
    n := lights.GetSize;

    for i := 0 to n - 1 do
    begin
      if SUCCEEDED(lights.GetElement(i, light)) then
      begin
        if light <> AmbientLight then
          Scene.DeleteLight(light);

        light := nil;
      end;
    end;

    lights := nil;
  end;

  // Add children from Model scene to DirectX scene frame
  with MainForm.SceneData do
  begin
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i] as TShape;

      if shape.GetID <> siCamera then
      begin
        D3DRM.CreateFrame(Scene, MeshFrame);

        shape.GenerateDirectXForm(D3DRM, MeshFrame);
      end;
    end;

    // Use Model's camera to set DirectX camera details
    camera := GetCamera;

    if camera <> nil then
      with camera do
      begin
        SceneCamera.SetPosition(Scene, Observer.X, Observer.Y, Observer.Z);

        D3DRM.CreateFrame(Scene, LookAtFrame);

        LookAtFrame.SetPosition(Scene, Observed.X, Observed.Y, Observed.Z);

        SceneCamera.LookAt(LookAtFrame, nil, D3DRMCONSTRAIN_Z);
      end;
  end;
end;

procedure TDirectXForm.FormHide(Sender: TObject);
begin
  bEnabled := false;
end;

procedure TDirectXForm.CloseItemClick(Sender: TObject);
begin
  Hide;
end;

procedure TDirectXForm.FlatItemClick(Sender: TObject);
begin
  Shade := D3DRMSHADE_FLAT;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.WireframeItemClick(Sender: TObject);
begin
  Fill := D3DRMFILL_WIREFRAME;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.GouraudItemClick(Sender: TObject);
begin
  Shade := D3DRMSHADE_GOURAUD;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.WMActivate(var msg: TMessage);
var
  windev: IDirect3DRMWinDevice;

begin
  if device <> nil then
  begin
    windev := Device as IDirect3DRMWinDevice;

    windev.HandleActivate(msg.WParam);

    windev := nil;
  end;
end;

procedure TDirectXForm.WMPaint(var msg: TMessage);
var
  windev: IDirect3DRMWinDevice;
  ps: TPaintStruct;
  rect: TRect;

begin
  if GetUpdateRect(Handle, rect, false) = false then
    exit;

  if device <> nil then
  begin
    BeginPaint(Handle, ps);

    windev := Device as IDirect3DRMWinDevice;

    windev.HandlePaint(ps.hdc);

    windev := nil;

    EndPaint(Handle, ps);
  end;

  inherited;
end;

procedure TDirectXForm.WMEraseBkgnd(var msg: TMessage);
var
  bgcolor: TColor;
  scenecolor: TD3DCOLOR;
  rect: TRect;

begin
  if scene <> nil then
  begin
    scenecolor := scene.GetSceneBackground;

    bgcolor := D3DCOLOR_2_COLORREF(scenecolor);
  end
  else
    bgcolor := clBlack;

  SetRect(rect, 0, 0, ClientWidth, ClientHeight);

  Canvas.Brush.Color := bgcolor;

  Canvas.FillRect(rect);

  msg.Result := 1;
end;

procedure TDirectXForm.FormCreate(Sender: TObject);
begin
  bStats := false;
  bEnabled := false;
  dwTime := GetCurrentTime;
  dwElapsed := 0;

  Shade := D3DRMSHADE_GOURAUD;
  Light := D3DRMLIGHT_ON;
  Fill := D3DRMFILL_SOLID;

  if SUCCEEDED(Direct3DRMCreate(D3DRM)) then
    CreateDevice;
end;

procedure TDirectXForm.LightingItemClick(Sender: TObject);
begin
  if Light = D3DRMLIGHT_ON then
    Light := D3DRMLIGHT_OFF
  else
    Light := D3DRMLIGHT_ON;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.PointItemClick(Sender: TObject);
begin
  Fill := D3DRMFILL_POINTS;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.SolidItemClick(Sender: TObject);
begin
  Fill := D3DRMFILL_SOLID;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.FlatActionUpdate(Sender: TObject);
begin
  FlatAction.Checked := Shade = D3DRMSHADE_FLAT;
end;

procedure TDirectXForm.GouraudActionUpdate(Sender: TObject);
begin
  GouraudAction.Checked := Shade = D3DRMSHADE_GOURAUD;
end;

procedure TDirectXForm.LightingActionUpdate(Sender: TObject);
begin
  LightingAction.Checked := Light = D3DRMLIGHT_ON;
end;

procedure TDirectXForm.PointActionUpdate(Sender: TObject);
begin
  PointAction.Checked := Fill = D3DRMFILL_POINTS;
end;

procedure TDirectXForm.WireframeActionUpdate(Sender: TObject);
begin
  WireframeAction.Checked := Fill = D3DRMFILL_WIREFRAME;
end;

procedure TDirectXForm.SolidActionUpdate(Sender: TObject);
begin
  SolidAction.Checked := Fill = D3DRMFILL_SOLID;
end;

procedure TDirectXForm.PhongActionExecute(Sender: TObject);
begin
  Shade := D3DRMSHADE_PHONG;

  Device.SetQuality(Shade + Light + Fill);
end;

procedure TDirectXForm.PhongActionUpdate(Sender: TObject);
begin
  PhongAction.Checked := Shade = D3DRMSHADE_PHONG;
end;

procedure TDirectXForm.AntiAliasingActionExecute(Sender: TObject);
var
  state: Cardinal;

begin
  state := GetRenderState(D3DRENDERSTATE_ANTIALIAS);

    if state <> 0 then
      state := 0
    else
      state := $ffffffff;

  SetRenderState(D3DRENDERSTATE_ANTIALIAS, state);
end;

procedure TDirectXForm.AntiAliasingActionUpdate(Sender: TObject);
var
  state: Cardinal;

begin
  state := GetRenderState(D3DRENDERSTATE_ANTIALIAS);

  AntiAliasingAction.Checked := state <> 0;
end;

procedure TDirectXForm.DitheringActionExecute(Sender: TObject);
var
  state: Cardinal;

begin
  state := GetRenderState(D3DRENDERSTATE_DITHERENABLE);

  if state <> 0 then
    state := 0
  else
    state := $ffffffff;

  SetRenderState(D3DRENDERSTATE_DITHERENABLE, state);
end;

procedure TDirectXForm.DitheringActionUpdate(Sender: TObject);
var
  state: Cardinal;

begin
  state := GetRenderState(D3DRENDERSTATE_DITHERENABLE);

  DitheringAction.Checked := state <> 0;
end;

procedure TDirectXForm.StatisticsActionExecute(Sender: TObject);
begin
  bStats := not bStats;

  Tick.Enabled := bStats;
end;

procedure TDirectXForm.StatisticsActionUpdate(Sender: TObject);
begin
  StatisticsAction.Checked := bStats;
end;

procedure TDirectXForm.FormDestroy(Sender: TObject);
begin
  Viewport := nil;
  SceneCamera := nil;
  Scene := nil;
  Device := nil;
  Clipper := nil;
  D3DRM := nil;
end;

procedure TDirectXForm.FormResize(Sender: TObject);
var
  width, height, view_width, view_height, old_shades: integer;
  old_dither: boolean;
  old_quality: TD3DRMRENDERQUALITY;

begin
  if device = nil then exit;

  width := ClientWidth;
  height := ClientHeight;

  if (width <> 0) and (height <> 0) then
  begin
    view_width := viewport.GetWidth;
    view_height := viewport.GetHeight;

    if (view_width = width) and (view_height = height) then
      exit;

    old_dither := device.GetDither;
    old_quality := device.GetQuality;
    old_shades := device.GetShades();

    viewport := nil;
    device := nil;

    d3drm.CreateDeviceFromClipper(clipper, GetGUID, width, height, device);

    device.SetDither(old_dither);
    device.SetQuality(old_quality);
    device.SetShades(old_shades);

    width := device.GetWidth;
    height := device.GetHeight;

    d3drm.CreateViewport(device, SceneCamera, 0, 0, width, height, viewport);
  end;
end;

procedure TDirectXForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
var
  dwNow: DWORD;

begin
  dwNow := GetCurrentTime;
  dwElapsed := dwNow - dwTime;

  D3DRM.Tick(1.0);

  Done := not bEnabled;

  dwTime := dwNow;
end;

procedure TDirectXForm.FormShow(Sender: TObject);
begin
  ShowScene;

  bEnabled := true;
end;

procedure TDirectXForm.TickTimer(Sender: TObject);
begin
  StatusBar.SimpleText := 'FPS: ' + IntToStr(1000 div dwElapsed);
end;

initialization
  DirectXForm := nil;
{$ENDIF}

end.
