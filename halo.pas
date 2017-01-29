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

unit halo;

interface

uses
  Winapi.Windows,
  System.IOUtils, System.SysUtils, System.Classes, System.Generics.Collections,
  System.JSON,
  VCL.Forms,
  JSONHelper, Vector, MapText, Scene;

type
  THaloType = (htAttenuating, htEmitting, htGlowing, htDust);
  THaloDensity = (hdConstant, hdLinear, hdCubic, hdPoly);
  THaloMapping = (hmPlanar, hmSpherical, hmCylindrical, hmBox);

  THalo = class
  public
    Name: AnsiString;
    HaloType: THaloType;
    HaloDensity: THaloDensity;
    HaloMapping: THaloMapping;
    DustType: TAtmosphereType;
    Eccentricity: double;
    MaxValue: double;
    Exponent: double;
    Samples: integer;
    AALevel: double;
    AAThreshold: double;
    Jitter: double;
    Turbulence: double;
    Octaves: integer;
    Omega: double;
    Lambda: double;
    Frequency: integer;
    Phase: double;
    Translate, Scale, Rotate: TVector;
    ColourMaps: TObjectList<TMapItem>;

    constructor Create;
    destructor Destroy; override;
    procedure ClearMaps;
    procedure Save(parent: TJSONArray);
    procedure Load(obj: TJSONObject);
    procedure Generate(var dest: TextFile);
    function Edit: boolean;
    procedure CreateSimple;
    procedure Copy(original: THalo);
  end;

  THaloManager = class
  public
    Halos: TObjectList<THalo>;
    class var HaloManager: THaloManager;
    constructor Create;
    destructor Destroy; override;
    function FindHalo(const Name: string): THalo;
    procedure LoadHalos(const filename: string);
    procedure SaveHalos(const filename: string);

    class procedure Initialise;
    class procedure Shutdown;
  end;

implementation

uses Misc, HaloDlg;

constructor THalo.Create;
begin
  HaloType := htAttenuating;
  HaloDensity := hdConstant;
  HaloMapping := hmPlanar;
  DustType := atIsotropic;
  Eccentricity := 1;
  MaxValue := 1;
  Exponent := 1;
  Samples := 10;
  AAThreshold := 0.3;
  AALevel := 3;
  Jitter := 0;
  Turbulence := 0;
  Octaves := 6;
  Lambda := 2;
  Omega := 0.5;
  Frequency := 0;
  Phase := 0;

  Translate := TVector.Create;
  Scale := TVector.Create;
  Scale.X := 1;
  Scale.Y := 1;
  Scale.Z := 1;
  Rotate := TVector.Create;

  ColourMaps := TObjectList<TMapItem>.Create;
end;

destructor THalo.Destroy;
begin
  ClearMaps;

  Translate.Free;
  Scale.Free;
  Rotate.Free;
  ColourMaps.Destroy;

  inherited;
end;

procedure THalo.ClearMaps;
var
  i: integer;
  map: TMapItem;

begin
  for i := 0 to ColourMaps.Count - 1 do
  begin
    map := TMapItem(ColourMaps[i]) as TMapItem;
    if Assigned(map) then map.Free;
  end;

  ColourMaps.Clear;
end;

procedure THalo.Save(parent: TJSONArray);
var
  obj: TJSONObject;
  map: TMapItem;
  colourMapsArray: TJSONArray;

begin
  obj := TJSONObject.Create;
  obj.AddPair('name', Name);
  obj.AddPair('halotype', byte(ord(HaloType)));
  obj.AddPair('halodensity', byte(ord(HaloDensity)));
  obj.AddPair('halomapping', byte(ord(HaloMapping)));
  obj.AddPair('dusttype', byte(ord(DustType)));
  obj.AddPair('eccentricity', Eccentricity);
  obj.AddPair('maxvalue', MaxValue);
  obj.AddPair('exponent', Exponent);
  obj.AddPair('samples', Samples);
  obj.AddPair('aalevel', AALevel);
  obj.AddPair('aathreshold', AAThreshold);
  obj.AddPair('jitter', Jitter);
  obj.AddPair('turbelence', Turbulence);
  obj.AddPair('octaves', Octaves);
  obj.AddPair('omega', Omega);
  obj.AddPair('lambda', Lambda);
  obj.AddPair('frequency', Frequency);
  obj.AddPair('phase', Phase);
  colourMapsArray := TJSONArray.Create;
  for map in ColourMaps do
    map.Save(colourMapsArray);
  obj.AddPair('colourmaps', colourMapsArray);
  parent.Add(obj);
end;

procedure THalo.Load(obj: TJSONObject);
var
  i, n: integer;
  map: TMapItem;
  mapArray: TJSONArray;
  mapObj: TJSONObject;

begin
  Name := obj.GetValue('name').Value;
  HaloType := THaloType(obj.GetInteger('halotype'));
  HaloDensity := THaloDensity(obj.GetInteger('halodensity'));
  HaloMapping := THaloMapping(obj.GetInteger('halomapping'));
  DustType := TAtmosphereType(obj.GetInteger('dusttype'));
  Eccentricity := obj.GetDouble('eccentricity');
  MaxValue := obj.GetDouble('maxvalue');
  Exponent := obj.GetDouble('exponent');
  Samples := obj.GetInteger('samples');
  AALevel := obj.GetDouble('aalevel');
  AAThreshold := obj.GetDouble('aathreshold');
  Jitter := obj.GetDouble('jitter');
  Turbulence := obj.GetDouble('turbulence');
  Octaves := obj.GetInteger('octaves');
  Omega := obj.GetDouble('omega');
  Lambda := obj.GetDouble('lambda');
  Frequency := obj.GetInteger('frequency');
  Phase := obj.GetDouble('phase');
  mapArray := obj.GetValue('colourmaps') as TJSONArray;
  n := mapArray.Count;
  for i := 0 to n - 1 do
  begin
    mapObj := mapArray.Items[i] as TJSONObject;
    map := TMapItem.Create;
    map.Load(mapObj);
    ColourMaps.Add(map);
  end;
end;

function THalo.Edit: boolean;
var
  dlg: THaloDialog;

begin
  dlg := THaloDialog.Create(Application);

  dlg.Name.Text := Name;

  dlg.HaloType.ItemIndex := ord(HaloType);
  dlg.HaloDensity.ItemIndex := ord(HaloDensity);
  dlg.HaloMapping.ItemIndex := ord(HaloMapping);
  dlg.DustType.ItemIndex := ord(DustType) - 1;

  dlg.Eccentricity.Text := FloatToStrF(Eccentricity, ffFixed, 6, 4);
  dlg.MaxValue.Text := FloatToStrF(MaxValue, ffFixed, 6, 4);
  dlg.Exponent.Text := FloatToStrF(Exponent, ffFixed, 6, 4);

  dlg.Samples.Text := IntToStr(Samples);
  dlg.AALevel.Text := FloatToStrF(AALevel, ffFixed, 6, 4);
  dlg.AAThreshold.Text := FloatToStrF(AAThreshold, ffFixed, 6, 4);
  dlg.Jitter.Text := FloatToStrF(Jitter, ffFixed, 6, 4);
  dlg.Frequency.Text := IntToStr(Frequency);
  dlg.Phase.Text := FloatToStrF(Phase, ffFixed, 6, 4);

  dlg.XTrans.Text := FloatToStrF(Translate.X, ffFixed, 6, 4);
  dlg.YTrans.Text := FloatToStrF(Translate.Y, ffFixed, 6, 4);
  dlg.ZTrans.Text := FloatToStrF(Translate.Z, ffFixed, 6, 4);

  dlg.XScale.Text := FloatToStrF(Scale.X, ffFixed, 6, 4);
  dlg.YScale.Text := FloatToStrF(Scale.Y, ffFixed, 6, 4);
  dlg.ZScale.Text := FloatToStrF(Scale.Z, ffFixed, 6, 4);

  dlg.XRotate.Text := FloatToStrF(Rotate.X, ffFixed, 6, 4);
  dlg.YRotate.Text := FloatToStrF(Rotate.Y, ffFixed, 6, 4);
  dlg.ZRotate.Text := FloatToStrF(Rotate.Z, ffFixed, 6, 4);

  dlg.Turbulence := Turbulence;
  dlg.Octaves := Octaves;
  dlg.Lambda := Lambda;
  dlg.Omega := Omega;

  dlg.SetMaps(ColourMaps);

  if dlg.ShowModal = idOK then
  begin
    Name := dlg.Name.Text;

    HaloType := THaloType(dlg.HaloType.ItemIndex);
    HaloDensity := THaloDensity(dlg.HaloDensity.ItemIndex);
    HaloMapping := THaloMapping(dlg.HaloMapping.ItemIndex);
    DustType := TAtmosphereType(dlg.DustType.ItemIndex + 1);

    Eccentricity := StrToFloat(dlg.Eccentricity.Text);
    MaxValue := StrToFloat(dlg.MaxValue.Text);
    Exponent := StrToFloat(dlg.Exponent.Text);

    Samples := StrToInt(dlg.Samples.Text);
    AALevel := StrToFloat(dlg.AALevel.Text);
    AAThreshold := StrToFloat(dlg.AAThreshold.Text);
    Jitter := StrToFloat(dlg.Jitter.Text);
    Frequency := StrToInt(dlg.Frequency.Text);
    Phase := StrToFloat(dlg.Phase.Text);

    Translate.X := StrToFloat(dlg.XTrans.Text);
    Translate.Y := StrToFloat(dlg.YTrans.Text);
    Translate.Z := StrToFloat(dlg.ZTrans.Text);

    Scale.X := StrToFloat(dlg.XScale.Text);
    Scale.Y := StrToFloat(dlg.YScale.Text);
    Scale.Z := StrToFloat(dlg.ZScale.Text);

    Rotate.X := StrToFloat(dlg.XRotate.Text);
    Rotate.Y := StrToFloat(dlg.YRotate.Text);
    Rotate.Z := StrToFloat(dlg.ZRotate.Text);

    Turbulence := dlg.Turbulence;
    Octaves := dlg.Octaves;
    Lambda := dlg.Lambda;
    Omega := dlg.Omega;

    ClearMaps;

    dlg.GetMaps(ColourMaps);

    result := True;
  end
  else
    result := False;

  dlg.Free;
end;

procedure THalo.CreateSimple;
var
  map: TMapItem;

begin
  map := TMapItem.Create;
  ColourMaps.Add(map);

  map := TMapItem.Create;
  map.SetRGBFTV(1, 1, 1, 0, 0, 1);
  ColourMaps.Add(map);
end;

procedure THalo.Copy(original: THalo);
var
  i: integer;
  map, newmap: TMapItem;

begin
  Name := original.Name;
  HaloType := original.HaloType;
  HaloDensity := original.HaloDensity;
  HaloMapping := original.HaloMapping;
  DustType := original.DustType;
  Eccentricity := original.Eccentricity;
  MaxValue := original.MaxValue;
  Exponent := original.Exponent;
  Samples := original.Samples;
  AAThreshold := original.AAThreshold;
  AALevel := original.AALevel;
  Jitter := original.Jitter;
  Turbulence := original.Turbulence;
  Octaves := original.Octaves;
  Lambda := original.Lambda;
  Omega := original.Omega;
  Frequency := original.Frequency;
  Phase := original.Phase;

  Translate.X := original.Translate.X;
  Translate.Y := original.Translate.Y;
  Translate.Z := original.Translate.Z;

  Scale.X := original.Scale.X;
  Scale.Y := original.Scale.Y;
  Scale.Z := original.Scale.Z;

  Rotate.X := original.Rotate.X;
  Rotate.Y := original.Rotate.Y;
  Rotate.Z := original.Rotate.Z;

  for i := 0 to original.ColourMaps.Count - 1 do
  begin
    map := original.ColourMaps[i];
    newmap := TMapItem.Create;
    newmap.Copy(map);
    ColourMaps.Add(newmap);
  end;
end;

procedure THalo.Generate(var dest: TextFile);
var
  i: integer;
  map: TMapItem;

begin
  WriteLn(dest, '    halo');
  WriteLn(dest, '    {');

  case HaloType of
    htAttenuating:  WriteLn(dest, '        attenuating');
    htEmitting:     WriteLn(dest, '        emitting');
    htGlowing:      WriteLn(dest, '        glowing');
    htDust:         WriteLn(dest, '        dust');
  end;

  case HaloDensity of
    hdConstant:     WriteLn(dest, '        constant');
    hdLinear:       WriteLn(dest, '        linear');
    hdCubic:        WriteLn(dest, '        cubic');
    hdPoly:         WriteLn(dest, '        poly');
  end;

  case HaloMapping of
    hmPlanar:       WriteLn(dest, '        planar_mapping');
    hmSpherical:    WriteLn(dest, '        spherical_mapping');
    hmCylindrical:  WriteLn(dest, '        cylindrical_mapping');
    hmBox:          WriteLn(dest, '        box_mapping');
  end;

  case DustType of
    atNone: ;
    atIsotropic:    WriteLn(dest, '        dust_type 1');
    atMIEHazy:      WriteLn(dest, '        dust_type 2');
    atMIEMurky:     WriteLn(dest, '        dust_type 3');
    atRayleigh:     WriteLn(dest, '        dust_type 4');
    atHenyeyGreenstein: WriteLn(dest, '        dust_type 5');
  end;

  WriteLn(dest, Format('        eccentricity %6.4f', [Eccentricity]));
  WriteLn(dest, Format('        max_value %6.4f', [MaxValue]));
  WriteLn(dest, Format('        exponent %6.4f', [Exponent]));
  WriteLn(dest, Format('        samples %d', [Samples]));
  WriteLn(dest, Format('        aa_level %6.4f', [AALevel]));
  WriteLn(dest, Format('        aa_threshold %6.4f', [AAThreshold]));
  WriteLn(dest, Format('        jitter %6.4f', [Jitter]));
  WriteLn(dest, Format('        turbulence %6.4f', [Turbulence]));
  WriteLn(dest, Format('        octaves %d', [Octaves]));
  WriteLn(dest, Format('        omega %6.4f', [Omega]));
  WriteLn(dest, Format('        lambda %6.4f', [Lambda]));
  WriteLn(dest, Format('        frequency %d', [Frequency]));
  WriteLn(dest, Format('        phase %6.4f', [Phase]));

  WriteLn(dest, Format('        scale <%6.4f, %6.4f, %6.4f>',
    [Scale.X, Scale.Y, Scale.Z]));

  WriteLn(dest, Format('        rotate <%6.4f, %6.4f, %6.4f>',
    [Rotate.X, Rotate.Y, Rotate.Z]));

  WriteLn(dest, Format('        translate <%6.4f, %6.4f, %6.4f>',
    [Translate.X, Translate.Y, Translate.Z]));

  WriteLn(dest, '        color_map');
  WriteLn(dest, '        {');

  for i := 0 to ColourMaps.Count - 1 do
  begin
    map := ColourMaps[i];
    map.Generate(dest);
  end;

  WriteLn(dest, '        }');

  WriteLn(dest, '    }');
end;

{ THaloManager }

constructor THaloManager.Create;
begin
  Halos := TObjectList<THalo>.Create;
end;

destructor THaloManager.Destroy;
begin
  Halos.Free;
  inherited;
end;

function THaloManager.FindHalo(const Name: string): THalo;
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

class procedure THaloManager.Initialise;
begin
  HaloManager := THaloManager.Create;
end;

procedure THaloManager.LoadHalos(const filename: string);
var
  i, n: integer;
  data: string;
  halo: THalo;
  root: TJSONObject;
  halosArray: TJSONArray;
  haloObj: TJSONObject;

begin
  data := TFile.ReadAllText(filename);
  root := TJSONObject.ParseJSONValue(data, true) as TJSONObject;
  halosArray := root.Get('halos').JsonValue as TJSONArray;
  Halos.Clear;
  n := halosArray.Count;
  for i := 0 to n - 1 do
  begin
    haloObj := halosArray.Items[i] as TJSONObject;
    halo := THalo.Create;
    halo.Load(haloObj);
    Halos.Add(halo);
  end;
end;

procedure THaloManager.SaveHalos(const filename: string);
var
  i, n: integer;
  text: string;
  halo: THalo;
  root: TJSONObject;
  scene: TJSONArray;

begin
  root := TJSONObject.Create;
  scene := TJSONArray.Create;
  n := Halos.Count;
  for i := 0 to n - 1 do
  begin
    halo := Halos[i];
    halo.Save(scene);
  end;
  text := root.ToJSON;
  TFile.WriteAllText(filename, text);
end;

class procedure THaloManager.Shutdown;
begin
  HaloManager.Free;
  HaloManager := nil;
end;

end.
