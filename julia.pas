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

unit julia;

interface

uses
  System.JSON,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
    StdCtrls, Dialogs, Buttons, Messages, Vector, Scene;

type
  TJuliaType = (jtQuaternion, jtHypercomplex);

  TJuliaFunction = (jfSqr, jfCube, jfExp, jfReciprocal, jfSin, jfAsin,
      jfSinh, jfAsinh, jfCos, jfAcos, jfCosh, jfAcosh, jfTan, jfAtan,
      jfTanh, jfAtanh, jfLog, jfPwr);

  TJuliaFractal = class(TShape)
    public
      x, y, z, d: double;
      JuliaType: TJuliaType;
      JuliaFunction: TJuliaFunction;
      PwrX, PwrY: double;
      MaxIteration: integer;
      Precision: integer;
      SliceX, SliceY, SliceZ, SliceD, SliceDistance: double;

      constructor Create; override;
      function GetID: TShapeID; override;
      procedure Generate(var dest: TextFile); override;
      procedure Save(parent: TJSONArray); override;
      procedure SaveToFile(dest: TStream); override;
      procedure LoadFromFile(source: TStream); override;
      procedure Details(context: IDrawingContext); override;
    end;

implementation

uses
  JuliaDlg, engine;

constructor TJuliaFractal.Create;
begin
  inherited;
  Features := Features + StandardFeatures;
  x := 1;
  y := 0;
  z := 0;
  d := 0;
  JuliaType := jtQuaternion;
  JuliaFunction := jfSqr;
  PwrX := 0;
  PwrY := 0;
  MaxIteration := 20;
  Precision := 20;
  SliceX := 0;
  SliceY := 0;
  SliceZ := 0;
  SliceD := 1;
  SliceDistance := 0;

  CreateCube(Self, 0.0, 0.0, 0.0);
end;

function TJuliaFractal.GetID: TShapeID;
begin
  result := siJuliaFractal;
end;

procedure TJuliaFractal.Generate(var dest: TextFile);
begin
  WriteLn(dest, 'julia_fractal');
  WriteLn(dest, '{');
  WriteLn(dest, Format('    <%6.4f, %6.4f, %6.4f, %6.4f>',
    [x, y, z, d]));

  case JuliaType of
    jtQuaternion: WriteLn(dest, '    quaternion');
    jtHypercomplex: WriteLn(dest, '    hypercomplex');
  end;

  case JuliaFunction of
    jfSqr:        WriteLn(dest, '    sqr');
    jfCube:       WriteLn(dest, '    cube');
    jfExp:        WriteLn(dest, '    exp');
    jfReciprocal: WriteLn(dest, '    reciprocal');
    jfSin:        WriteLn(dest, '    sin');
    jfAsin:       WriteLn(dest, '    asin');
    jfSinh:       WriteLn(dest, '    sinh');
    jfAsinh:      WriteLn(dest, '    asinh');
    jfCos:        WriteLn(dest, '    cos');
    jfAcos:       WriteLn(dest, '    acos');
    jfCosh:       WriteLn(dest, '    cosh');  // The Vorlons are everywhere!
    jfAcosh:      WriteLn(dest, '    acosh');
    jfTan:        WriteLn(dest, '    tan');
    jfAtan:       WriteLn(dest, '    atan');
    jfTanh:       WriteLn(dest, '    tanh');
    jfAtanh:      WriteLn(dest, '    atanh');
    jflog:        WriteLn(dest, '    log');
    jfPwr:        WriteLn(dest, Format('    pwr(%6.4f, %6.4f)', [PwrX, PwrY]));
  end;

  WriteLn(dest, Format('    max_iteration %d', [MaxIteration]));
  WriteLn(dest, Format('    precision %d', [Precision]));
  WriteLn(dest, Format('    slice <%6.4f, %6.4f, %6.4f, %6.4f>, %6.4f',
    [SliceX, SliceY, SliceZ, SliceD, SliceDistance])); 

  inherited Generate(dest);
  WriteLn(dest, '}');
  WriteLn(dest);
end;

procedure TJuliaFractal.Save(parent: TJSONArray);
var
  obj: TJSONObject;

begin
  inherited;
  obj := TJSONObject.Create;
  obj.AddPair('x', TJSONNumber.Create(x));
  obj.AddPair('y', TJSONNumber.Create(y));
  obj.AddPair('z', TJSONNumber.Create(z));
  obj.AddPair('d', TJSONNumber.Create(d));
  obj.AddPair('juliatype', TJSONNumber.Create(ord(JuliaType)));
  obj.AddPair('juliafunction', TJSONNumber.Create(ord(JuliaFunction)));
  obj.AddPair('pwrx', TJSONNumber.Create(PwrX));
  obj.AddPair('pwry', TJSONNumber.Create(PwrY));
  obj.AddPair('maxiteration', TJSONNumber.Create(MaxIteration));
  obj.AddPair('precision', TJSONNumber.Create(Precision));
  obj.AddPair('slicex', TJSONNumber.Create(SliceX));
  obj.AddPair('slicey', TJSONNumber.Create(SliceY));
  obj.AddPair('slicez', TJSONNumber.Create(SliceZ));
  obj.AddPair('sliced', TJSONNumber.Create(SliceD));
  obj.AddPair('slicedistance', TJSONNumber.Create(SliceDistance));
  parent.Add(obj);
end;

procedure TJuliaFractal.SaveToFile(dest: TStream);
begin
  inherited SaveToFile(dest);

  dest.WriteBuffer(x, sizeof(x));
  dest.WriteBuffer(y, sizeof(y));
  dest.WriteBuffer(z, sizeof(z));
  dest.WriteBuffer(d, sizeof(d));
  dest.WriteBuffer(JuliaType, sizeof(JuliaType));
  dest.WriteBuffer(JuliaFunction, sizeof(JuliaFunction));
  dest.WriteBuffer(PwrX, sizeof(PwrX));
  dest.WriteBuffer(PwrY, sizeof(PwrY));
  dest.WriteBuffer(MaxIteration, sizeof(MaxIteration));
  dest.WriteBuffer(Precision, sizeof(Precision));
  dest.WriteBuffer(SliceX, sizeof(SliceX));
  dest.WriteBuffer(SliceY, sizeof(SliceY));
  dest.WriteBuffer(SliceZ, sizeof(SliceZ));
  dest.WriteBuffer(SliceD, sizeof(SliceD));
  dest.WriteBuffer(SliceDistance, sizeof(SliceDistance));
end;

procedure TJuliaFractal.LoadFromFile(source: TStream);
begin
  inherited LoadFromFile(source);

  source.ReadBuffer(x, sizeof(x));
  source.ReadBuffer(y, sizeof(y));
  source.ReadBuffer(z, sizeof(z));
  source.ReadBuffer(d, sizeof(d));
  source.ReadBuffer(JuliaType, sizeof(JuliaType));
  source.ReadBuffer(JuliaFunction, sizeof(JuliaFunction));
  source.ReadBuffer(PwrX, sizeof(PwrX));
  source.ReadBuffer(PwrY, sizeof(PwrY));
  source.ReadBuffer(MaxIteration, sizeof(MaxIteration));
  source.ReadBuffer(Precision, sizeof(Precision));
  source.ReadBuffer(SliceX, sizeof(SliceX));
  source.ReadBuffer(SliceY, sizeof(SliceY));
  source.ReadBuffer(SliceZ, sizeof(SliceZ));
  source.ReadBuffer(SliceD, sizeof(SliceD));
  source.ReadBuffer(SliceDistance, sizeof(SliceDistance));
end;

procedure TJuliaFractal.Details(context: IDrawingContext);
var
  dlg: TJuliaDialog;

begin
  dlg := TJuliaDialog.Create(Application);

  dlg.XValue.Text := FloatToStrF(X, ffFixed, 6, 4);
  dlg.YValue.Text := FloatToStrF(Y, ffFixed, 6, 4);
  dlg.ZValue.Text := FloatToStrF(Z, ffFixed, 6, 4);
  dlg.DValue.Text := FloatToStrF(D, ffFixed, 6, 4);

  dlg.JuliaType.ItemIndex := ord(JuliaType);

  dlg.JuliaFunction.ItemIndex := ord(JuliaFunction);

  dlg.PwrX.Text := FloatToStrF(PwrX, ffFixed, 6, 4);
  dlg.PwrY.Text := FloatToStrF(PwrY, ffFixed, 6, 4);

  dlg.MaxIteration.Text := IntToStr(MaxIteration);
  dlg.Precision.Text := IntToStr(Precision);

  dlg.SliceX.Text := FloatToStrF(SliceX, ffFixed, 6, 4);
  dlg.SliceY.Text := FloatToStrF(SliceY, ffFixed, 6, 4);
  dlg.SliceZ.Text := FloatToStrF(SliceZ, ffFixed, 6, 4);
  dlg.SliceD.Text := FloatToStrF(SliceD, ffFixed, 6, 4);
  dlg.SliceDistance.Text := FloatToStrF(SliceDistance, ffFixed, 6, 4);

  if dlg.ShowModal = idOK then
  begin
    X := StrToFloat(dlg.XValue.Text);
    Y := StrToFloat(dlg.YValue.Text);
    Z := StrToFloat(dlg.ZValue.Text);
    D := StrToFloat(dlg.DValue.Text);

    JuliaType := TJuliaType(dlg.JuliaType.ItemIndex);
    JuliaFunction := TJuliaFunction(dlg.JuliaFunction.ItemIndex);

    PwrX := StrToFloat(dlg.PwrX.Text);
    PwrY := StrToFloat(dlg.PwrY.Text);

    MaxIteration := StrToInt(dlg.MaxIteration.Text);
    Precision := StrToInt(dlg.Precision.Text);

    SliceX := StrToFloat(dlg.SliceX.Text);
    SliceY := StrToFloat(dlg.SliceY.Text);
    SliceZ := StrToFloat(dlg.SliceZ.Text);
    SliceD := StrToFloat(dlg.SliceD.Text);
    SliceDistance := StrToFloat(dlg.SliceDistance.Text);
  end;

  dlg.Free;
end;

end.
