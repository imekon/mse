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

unit htfld;

interface

uses
    WinTypes, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  THeightFieldFileType = (hfGIF, hfPGM, hfPNG, hfPOT, hfPPM, hfBMP, hfTGA);

  THeightField = class(TShape)
    public
      FileType: THeightFieldFileType;
      Filename: AnsiString;
      Hierarchy, Smooth: boolean;
      WaterLevel: double;

      constructor Create; override;
      function GetID: TShapeID; override;
      procedure Generate(var dest: TextFile); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Details; override;
    end;

implementation

uses
  Misc, HtFldDlg, engine;

constructor THeightField.Create;
begin
  inherited Create;
  Features := Features + StandardFeatures;
  CreateCube(Self, 0.0, 0.0, 0.0);
  FileType := hfBMP;
  Hierarchy := False;
  Smooth := False;
  WaterLevel := 0;
end;

procedure THeightField.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  SaveStringToStream(Filename, dest);

  dest.WriteBuffer(FileType, sizeof(FileType));
  dest.WriteBuffer(Hierarchy, sizeof(Hierarchy));
  dest.WriteBuffer(Smooth, sizeof(Smooth));
  dest.WriteBuffer(WaterLevel, sizeof(WaterLevel));
end;

procedure THeightField.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  LoadStringFromStream(Filename, source);

  source.ReadBuffer(FileType, sizeof(FileType));
  source.ReadBuffer(Hierarchy, sizeof(Hierarchy));
  source.ReadBuffer(Smooth, sizeof(Smooth));
  source.ReadBuffer(WaterLevel, sizeof(WaterLevel));
end;

function THeightField.GetID: TShapeID;
begin
  result := siHeightField;
end;

procedure THeightField.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'height_field');
  WriteLn(dest, '{');

  Write(dest, '    ');
  case FileType of
    hfGIF: Write(dest, 'gif ');
    hfPGM: Write(dest, 'pgm ');
    hfPNG: Write(dest, 'png ');
    hfPOT: Write(dest, 'pot ');
    hfPPM: Write(dest, 'ppm ');
    hfBMP: Write(dest, 'sys ');
    hfTGA: Write(dest, 'tga ');
  end;
  WriteLn(dest, '"', Filename, '"');

  if Hierarchy then
    WriteLn(dest, '    hierarchy true');

  if Smooth then
    WriteLn(dest, '    smooth');

  WriteLn(dest, Format('    water_level %6.4f', [WaterLevel]));

  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure THeightField.Details;
var
  dlg: THeightFieldDialog;
  ext: string;

begin
  dlg := THeightFieldDialog.Create(Application);

  dlg.Filename.Text := Filename;
  dlg.Hierarchy.Checked := Hierarchy;
  dlg.Smooth.Checked := Smooth;
  dlg.WaterLevel.Text := FloatToStrF(WaterLevel, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    Filename := dlg.Filename.Text;
    Hierarchy := dlg.Hierarchy.Checked;
    Smooth := dlg.Smooth.Checked;
    WaterLevel := StrToFloat(dlg.WaterLevel.Text);

    ext := UpperCase(ExtractFileExt(Filename));
    if ext = '.GIF' then
      FileType := hfGIF
    else if ext = '.PGM' then
      FileType := hfPGM
    else if ext = '.PNG' then
      FileType := hfPNG
    else if ext = '.POT' then
      FileType := hfPOT
    else if ext = '.PPM' then
      FileType := hfPPM
    else if ext = '.TGA' then
      FileType := hfTGA
    else
      FileType := hfBMP;
  end;

  dlg.Free;
end;

end.
