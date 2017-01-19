unit model_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 03/03/01 22:42:50 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\SAMPLES\GNU\mse\mse.tlb (1)
// IID\LCID: {D2E0BDE0-EB2F-11D2-94E7-444553540000}\0
// Helpfile:
// DepndLst:
//   (1) v2.0 stdole, (C:\WINDOWS\SYSTEM\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\SYSTEM\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
interface

{$IFDEF USE_TYPE_LIBRARY}
uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  modelMajorVersion = 0;
  modelMinorVersion = 13;

  LIBID_model: TGUID = '{D2E0BDE0-EB2F-11D2-94E7-444553540000}';

  IID_IModelScene: TGUID = '{D2E0BDE8-EB2F-11D2-94E7-444553540000}';
  CLASS_ModelSceneEditor: TGUID = '{D2E0BDE3-EB2F-11D2-94E7-444553540000}';
  IID_IModelTexture: TGUID = '{D2E0BDEA-EB2F-11D2-94E7-444553540000}';
  IID_IModelShape: TGUID = '{D2E0BDEC-EB2F-11D2-94E7-444553540000}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library
// *********************************************************************//
// Constants for enum ModelView
type
  ModelView = TOleEnum;
const
  ViewFront = $00000000;
  ViewBack = $00000001;
  ViewTop = $00000002;
  ViewBottom = $00000003;
  ViewLeft = $00000004;
  ViewRight = $00000005;
  ViewCamera = $00000006;

// Constants for enum ModelShape
type
  ModelShape = TOleEnum;
const
  ShapeCamera = $00000000;
  ShapeLight = $00000001;
  ShapeSpotLight = $00000002;
  ShapeCylinderLight = $00000003;
  ShapeAreaLight = $00000004;
  ShapePlane = $00000005;
  ShapeSphere = $00000006;
  ShapeCube = $00000007;
  ShapeSolid = $00000008;
  ShapePolygon = $00000009;
  ShapeHeightField = $0000000A;
  ShapeBicubic = $0000000B;
  ShapeUser = $0000000C;
  ShapeGroup = $0000000D;
  ShapeGallery = $0000000E;
  ShapeDisc = $0000000F;
  ShapeTorus = $00000010;
  ShapeSuperEllipsoid = $00000011;
  ShapeText = $00000012;
  ShapeLathe = $00000013;
  ShapeJuliaFractal = $00000014;
  ShapeScripted = $00000015;
  ShapeSpring = $00000017;

// Constants for enum ModelTexture
type
  ModelTexture = TOleEnum;
const
  TextureColour = $00000000;
  TextureAgate = $00000001;
  TextureAverage = $00000002;
  TextureBozo = $00000003;
  TextureBrick = $00000004;
  TextureBumps = $00000005;
  TextureChecker = $00000006;
  TextureCrackle = $00000007;
  TextureDents = $00000008;
  TextureGradient = $00000009;
  TextureGranite = $0000000A;
  TextureHexagon = $0000000B;
  TextureLeopard = $0000000C;
  TextureMandelbrot = $0000000D;
  TextureMarble = $0000000E;
  TextureOnion = $0000000F;
  TextureQuilted = $00000010;
  TextureRadial = $00000011;
  TextureRipples = $00000012;
  TextureSpiral1 = $00000013;
  TextureSpiral2 = $00000014;
  TextureSpotted = $00000015;
  TextureWaves = $00000016;
  TextureWood = $00000017;
  TextureWrinkles = $00000018;
  TextureMap = $00000019;
  TextureImage = $0000001A;
  TextureSpiral = $0000001B;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IModelScene = interface;
  IModelSceneDisp = dispinterface;
  IModelTexture = interface;
  IModelTextureDisp = dispinterface;
  IModelShape = interface;
  IModelShapeDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  ModelSceneEditor = IModelScene;


// *********************************************************************//
// Interface: IModelScene
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDE8-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelScene = interface(IDispatch)
    ['{D2E0BDE8-EB2F-11D2-94E7-444553540000}']
    function  GetTextureCount: Integer; safecall;
    function  GetShapeCount: Integer; safecall;
    procedure LoadScene(const Filename: WideString); safecall;
    procedure SaveScene(const Filename: WideString); safecall;
    function  GetTexture(Index: Integer): IModelTexture; safecall;
    function  CreateTexture(TextureType: ModelTexture; const Name: WideString): IModelTexture; safecall;
    function  GetShape(Index: Integer): IModelShape; safecall;
    function  CreateShape(ShapeType: ModelShape; const Name: WideString): IModelShape; safecall;
  end;

// *********************************************************************//
// DispIntf:  IModelSceneDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDE8-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelSceneDisp = dispinterface
    ['{D2E0BDE8-EB2F-11D2-94E7-444553540000}']
    function  GetTextureCount: Integer; dispid 1;
    function  GetShapeCount: Integer; dispid 2;
    procedure LoadScene(const Filename: WideString); dispid 3;
    procedure SaveScene(const Filename: WideString); dispid 4;
    function  GetTexture(Index: Integer): IModelTexture; dispid 5;
    function  CreateTexture(TextureType: ModelTexture; const Name: WideString): IModelTexture; dispid 6;
    function  GetShape(Index: Integer): IModelShape; dispid 7;
    function  CreateShape(ShapeType: ModelShape; const Name: WideString): IModelShape; dispid 8;
  end;

// *********************************************************************//
// Interface: IModelTexture
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDEA-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelTexture = interface(IDispatch)
    ['{D2E0BDEA-EB2F-11D2-94E7-444553540000}']
    function  GetName: WideString; safecall;
    procedure SetName(const Name: WideString); safecall;
    procedure GetColour(out Red: Double; out Green: Double; out Blue: Double; out Filter: Double;
                        out Transmit: Double); safecall;
    procedure SetColour(Red: Double; Green: Double; Blue: Double; Filter: Double; Transmit: Double); safecall;
    function  GetAttributes: OleVariant; safecall;
    procedure SetAttributes(Attributes: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IModelTextureDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDEA-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelTextureDisp = dispinterface
    ['{D2E0BDEA-EB2F-11D2-94E7-444553540000}']
    function  GetName: WideString; dispid 1;
    procedure SetName(const Name: WideString); dispid 2;
    procedure GetColour(out Red: Double; out Green: Double; out Blue: Double; out Filter: Double;
                        out Transmit: Double); dispid 3;
    procedure SetColour(Red: Double; Green: Double; Blue: Double; Filter: Double; Transmit: Double); dispid 4;
    function  GetAttributes: OleVariant; dispid 5;
    procedure SetAttributes(Attributes: OleVariant); dispid 6;
  end;

// *********************************************************************//
// Interface: IModelShape
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDEC-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelShape = interface(IDispatch)
    ['{D2E0BDEC-EB2F-11D2-94E7-444553540000}']
    function  GetName: WideString; safecall;
    procedure SetName(const Name: WideString); safecall;
    function  GetTexture: IModelTexture; safecall;
    procedure SetTexture(const Texture: IModelTexture); safecall;
    function  GetAttributes: OleVariant; safecall;
    procedure SetAttributes(Attributes: OleVariant); safecall;
    procedure GetTranslation(out X: Double; out Y: Double; out Z: Double); safecall;
    procedure SetTranslation(X: Double; Y: Double; Z: Double); safecall;
    procedure GetScale(out X: Double; out Y: Double; out Z: Double); safecall;
    procedure SetScale(X: Double; Y: Double; Z: Double); safecall;
    procedure GetRotation(out X: Double; out Y: Double; out Z: Double); safecall;
    procedure SetRotation(X: Double; Y: Double; Z: Double); safecall;
  end;

// *********************************************************************//
// DispIntf:  IModelShapeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2E0BDEC-EB2F-11D2-94E7-444553540000}
// *********************************************************************//
  IModelShapeDisp = dispinterface
    ['{D2E0BDEC-EB2F-11D2-94E7-444553540000}']
    function  GetName: WideString; dispid 1;
    procedure SetName(const Name: WideString); dispid 2;
    function  GetTexture: IModelTexture; dispid 3;
    procedure SetTexture(const Texture: IModelTexture); dispid 4;
    function  GetAttributes: OleVariant; dispid 5;
    procedure SetAttributes(Attributes: OleVariant); dispid 6;
    procedure GetTranslation(out X: Double; out Y: Double; out Z: Double); dispid 7;
    procedure SetTranslation(X: Double; Y: Double; Z: Double); dispid 8;
    procedure GetScale(out X: Double; out Y: Double; out Z: Double); dispid 9;
    procedure SetScale(X: Double; Y: Double; Z: Double); dispid 10;
    procedure GetRotation(out X: Double; out Y: Double; out Z: Double); dispid 11;
    procedure SetRotation(X: Double; Y: Double; Z: Double); dispid 12;
  end;

// *********************************************************************//
// The Class CoModelSceneEditor provides a Create and CreateRemote method to
// create instances of the default interface IModelScene exposed by
// the CoClass ModelSceneEditor. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoModelSceneEditor = class
    class function Create: IModelScene;
    class function CreateRemote(const MachineName: string): IModelScene;
  end;
{$ENDIF}

implementation

{$IFDEF USE_TYPE_LIBRARY}
uses ComObj;

class function CoModelSceneEditor.Create: IModelScene;
begin
  Result := CreateComObject(CLASS_ModelSceneEditor) as IModelScene;
end;

class function CoModelSceneEditor.CreateRemote(const MachineName: string): IModelScene;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ModelSceneEditor) as IModelScene;
end;
{$ENDIF}

end.
