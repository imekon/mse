//  L E N S   F L A R E
//
unit flare;

interface

uses
  WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, Misc, Vector, Texture, Scene;

const
  LensFlareEffectTypes: array [0..18] of string =
    ('Camera', 'Camera2', 'Candle', 'Diamond', 'Headlight', 'Headlight2',
     'Rainbow', 'Rainbow2', 'SoftGlow', 'Sparkle', 'Sparkle2', 'Spotlight',
     'Spotlight2', 'Star', 'Star2', 'Sun', 'Sun2', 'Sun3', 'Undersea');

type
  TLensFlareBase = class(TShape)
  public
    Camera: TCamera;

    constructor Create; override;
    function CanTranslate: boolean; override;
    function CheckTexture: boolean; override;
    procedure GenerateVRML(var dest: TextFile); override;
    procedure GenerateSMPL(var dest: TextFile); override;
  end;

  // Chris Colefax's include files
  TLensFlare = class(TLensFlareBase)
  public
    EffectType: integer;
    EffectRed, EffectGreen, EffectBlue: double;
    SourceRed, SourceGreen, SourceBlue: double;
    EffectBrightness, EffectIntensity: double;
    EffectOnTop: boolean;

    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Details; override;
  end;

  TLensFlareAdvanced = class(TLensFlareBase)
  public
    constructor Create; override;
    function GetID: TShapeID; override;
    procedure Generate(var dest: TextFile); override;
    procedure SaveToFile(dest: TStream); override;
    procedure LoadFromFile(source: TStream); override;
    procedure Details; override;
  end;

implementation

uses
  Main, FlareDlg, FlrAdv, Light;

////////////////////////////////////////////////////////////////////////////////
//  TLensFlareBase

constructor TLensFlareBase.Create;
begin
  inherited Create;

  Camera := nil;

  CreateLight(Self, 0, 0, 0);
end;

function TLensFlareBase.CanTranslate: boolean;
begin
  result := True;
end;

function TLensFlareBase.CheckTexture: boolean;
begin
  result := true;
end;

procedure TLensFlareBase.GenerateVRML(var dest: TextFile);
begin
end;

procedure TLensFlareBase.GenerateSMPL(var dest: TextFile);
begin
end;

////////////////////////////////////////////////////////////////////////////////
//  TLensFlare (Chris Colefax includes)

constructor TLensFlare.Create;
begin
  inherited Create;

  EffectType := 15;

  EffectRed := 1.0;
  EffectGreen := 1.0;
  EffectBlue := 1.0;

  SourceRed := 1.0;
  SourceGreen := 1.0;
  SourceBlue := 1.0;

  EffectBrightness := 1.0;
  EffectIntensity := 1.0;

  EffectOnTop := true;
end;

function TLensFlare.GetID: TShapeID;
begin
  result := siLensFlare;
end;

procedure TLensFlare.Generate(var dest: TextFile);
begin
  if Assigned(Camera) then
    with Camera do
    begin
      WriteLn(dest, Format('#declare camera_location = <%6.4f, %6.4f, %6.4f>',
        [Observer.x, Observer.y, Observer.z]));
      WriteLn(dest, Format('#declare camera_look_at = <%6.4f, %6.4f, %6.4f>',
        [Observed.x, Observed.y, Observed.z]));
    end;

  WriteLn(dest, '#declare effect_type = "' + LensFlareEffectTypes[EffectType]+ '"');

  WriteLn(dest, Format('#declare effect_location = <%6.4f, %6.4f, %6.4f>',
    [Translate.x, Translate.y, Translate.z]));

  WriteLn(dest, Format('#declare effect_colour = <%6.4f, %6.4f, %6.4f>',
    [EffectRed, EffectGreen, EffectBlue]));

  WriteLn(dest, Format('#declare source_colour = <%6.4f, %6.4f, %6.4f>',
    [SourceRed, SourceGreen, SourceBlue]));

  WriteLn(dest, Format('#declare effect_scale = <%6.4f, %6.4f, %6.4f>',
    [Scale.x, Scale.y, Scale.z]));

  WriteLn(dest, Format('#declare effect_rotate = <%6.4f, %6.4f, %6.4f>',
    [Rotate.x, Rotate.y, Rotate.z]));

  WriteLn(dest, Format('#declare effect_brightness = %6.4f',
    [EffectBrightness]));

  WriteLn(dest, Format('#declare effect_intensity = %6.4f',
    [EffectIntensity]));

  if EffectOnTop then
    WriteLn(dest, '#declare effect_always_on_top = true')
  else
    WriteLn(dest, '#declare effect_always_on_top = false');

  WriteLn(dest, '#include "Lens.inc"');

  WriteLn(dest);
end;

procedure TLensFlare.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  if Assigned(Camera) then
    SaveStringToStream(Camera.Name, dest)
  else
    SaveStringToStream('<Unknown>', dest);

  dest.WriteBuffer(EffectType, sizeof(EffectType));
end;

procedure TLensFlare.LoadFromFile(source: TStream);
var
  name: string;

begin
  inherited LoadFromFile(source);

  LoadStringFromStream(name, source);

  Camera := MainForm.SceneData.FindCamera(name);

  source.ReadBuffer(EffectType, sizeof(EffectType));
end;

procedure TLensFlare.Details;
var
  i, j, index: integer;
  shape: TShape;
  dlg: TLensFlareDialog;

begin
  dlg := TLensFlareDialog.Create(Application);

  index := -1;

  with MainForm.SceneData do
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i];
      if shape is TCamera then
      begin
        j := dlg.CameraList.Items.AddObject(shape.Name, shape);
        if Assigned(Camera) and (shape.Name = Camera.Name) then
          index := j;
      end;
    end;

  if index <> -1 then dlg.CameraList.ItemIndex := index;

  dlg.EffectType.ItemIndex := EffectType;

  if dlg.ShowModal = idOK then
  begin
    with dlg.CameraList do
      if ItemIndex <> -1 then
        Camera := Items.Objects[ItemIndex] as TCamera;

    EffectType := dlg.EffectType.ItemIndex;
  end;

  dlg.Free;
end;

////////////////////////////////////////////////////////////////////////////////
//  TLensFlareAdvanced

constructor TLensFlareAdvanced.Create;
begin
  inherited Create;
end;

function TLensFlareAdvanced.GetID: TShapeID;
begin
  result := siLensFlareAdvanced;
end;

procedure TLensFlareAdvanced.Generate(var dest: TextFile);
begin
  if Assigned(Camera) then
    with Camera do
    begin
      WriteLn(dest, Format('#declare camera_location = <%6.4f, %6.4f, %6.4f>',
        [Observer.x, Observer.y, Observer.z]));
      WriteLn(dest, Format('#declare camera_look_at = <%6.4f, %6.4f, %6.4f>',
        [Observed.x, Observed.y, Observed.z]));
    end;

  WriteLn(dest, Format('#declare effect_location = <%6.4f, %6.4f, %6.4f>',
    [Translate.x, Translate.y, Translate.z]));

  WriteLn(dest, '#include "Lens.inc"');

  WriteLn(dest);
end;

procedure TLensFlareAdvanced.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);
end;

procedure TLensFlareAdvanced.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);
end;

procedure TLensFlareAdvanced.Details;
var
  i, j, index: integer;
  shape: TShape;
  dlg: TLensFlareAdvancedDialog;

begin
  dlg := TLensFlareAdvancedDialog.Create(Application);

  index := -1;

  with MainForm.SceneData do
    for i := 0 to Shapes.Count - 1 do
    begin
      shape := Shapes[i];
      if shape is TCamera then
      begin
        j := dlg.CameraList.Items.AddObject(shape.Name, shape);
        if Assigned(Camera) and (shape.Name = Camera.Name) then
          index := j;
      end;
    end;

  if index <> -1 then dlg.CameraList.ItemIndex := index;

  if dlg.ShowModal = idOK then
  begin
    with dlg.CameraList do
      if ItemIndex <> -1 then
        Camera := Items.Objects[ItemIndex] as TCamera;

  end;

  dlg.Free;
end;

end.
