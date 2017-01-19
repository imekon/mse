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

unit halo;

interface

uses
  Windows, SysUtils, Classes, Forms, Vector, Scene;

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
    ColourMaps: TList;

    constructor Create;
    destructor Destroy; override;
    procedure ClearMaps;
    procedure SaveToFile(dest: TStream);
    procedure LoadFromFile(source: TStream);
    procedure Generate(var dest: TextFile);
    function Edit: boolean;
    procedure CreateSimple;
    procedure Copy(original: THalo);
  end;

implementation

uses Misc, MapText, HaloDlg;

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

  ColourMaps := TList.Create;
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

procedure THalo.SaveToFile(dest: TStream);
var
  i, n: integer;
  map: TMapItem;

begin
  SaveStringToStream(Name, dest);

  dest.WriteBuffer(HaloType, sizeof(HaloType));
  dest.WriteBuffer(HaloDensity, sizeof(HaloDensity));
  dest.WriteBuffer(HaloMapping, sizeof(HaloMapping));
  dest.WriteBuffer(DustType, sizeof(DustType));
  dest.WriteBuffer(Eccentricity, sizeof(Eccentricity));
  dest.WriteBuffer(MaxValue, sizeof(MaxValue));
  dest.WriteBuffer(Exponent, sizeof(Exponent));
  dest.WriteBuffer(Samples, sizeof(Samples));
  dest.WriteBuffer(AALevel, sizeof(AALevel));
  dest.WriteBuffer(AAThreshold, sizeof(AAThreshold));
  dest.WriteBuffer(Jitter, sizeof(Jitter));
  dest.WriteBuffer(Turbulence, sizeof(Turbulence));
  dest.WriteBuffer(Octaves, sizeof(Octaves));
  dest.WriteBuffer(Omega, sizeof(Omega));
  dest.WriteBuffer(Lambda, sizeof(Lambda));
  dest.WriteBuffer(Frequency, sizeof(Frequency));
  dest.WriteBuffer(Phase, sizeof(Phase));

  Translate.SaveToFile(dest);
  Scale.SaveToFile(dest);
  Rotate.SaveToFile(dest);

  n := ColourMaps.Count;

  dest.WriteBuffer(n, sizeof(n));

  for i := 0 to n - 1 do
  begin
    map := ColourMaps[i];
    if Assigned(map) then map.SaveToFile(dest);
  end;
end;

procedure THalo.LoadFromFile(source: TStream);
var
  i, n: integer;
  map: TMapItem;

begin
  LoadStringFromStream(Name, source);

  source.ReadBuffer(HaloType, sizeof(HaloType));
  source.ReadBuffer(HaloDensity, sizeof(HaloDensity));
  source.ReadBuffer(HaloMapping, sizeof(HaloMapping));
  source.ReadBuffer(DustType, sizeof(DustType));
  source.ReadBuffer(Eccentricity, sizeof(Eccentricity));
  source.ReadBuffer(MaxValue, sizeof(MaxValue));
  source.ReadBuffer(Exponent, sizeof(Exponent));
  source.ReadBuffer(Samples, sizeof(Samples));
  source.ReadBuffer(AALevel, sizeof(AALevel));
  source.ReadBuffer(AAThreshold, sizeof(AAThreshold));
  source.ReadBuffer(Jitter, sizeof(Jitter));
  source.ReadBuffer(Turbulence, sizeof(Turbulence));
  source.ReadBuffer(Octaves, sizeof(Octaves));
  source.ReadBuffer(Omega, sizeof(Omega));
  source.ReadBuffer(Lambda, sizeof(Lambda));
  source.ReadBuffer(Frequency, sizeof(Frequency));
  source.ReadBuffer(Phase, sizeof(Phase));

  Translate.LoadFromFile(source);
  Scale.LoadFromFile(source);
  Rotate.LoadFromFile(source);

  source.ReadBuffer(n, sizeof(n));

  for i := 1 to n do
  begin
    map := TMapItem.Create;
    map.LoadFromFile(source);
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

end.
