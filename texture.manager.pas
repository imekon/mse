unit texture.manager;

interface

uses
  System.Classes, System.IOUtils, System.JSON, System.SysUtils,
  System.Generics.Collections, misc, Texture;

type
  TTextureManager = class
  private
    _textures: TList<TTexture>;
    modified: boolean;
  public
    class var TextureManager: TTextureManager;
    constructor Create;
    destructor Destroy; override;

    function LoadBasicTextures(const filename: string): boolean;
    function LoadTextures(const filename: string): boolean;
    function ImportTextures(const filename: string): boolean;
    procedure SaveTextures(const filename: string);

    function FindTexture(const Name: string): TTexture;

    class procedure Initialise;
    class procedure Shutdown;

    property IsModified: boolean read modified;
    property Textures: TList<TTexture> read _textures;
  end;

implementation

constructor TTextureManager.Create;
begin
  _textures := TList<TTexture>.Create;
end;

destructor TTextureManager.Destroy;
var
  texture: TTexture;

begin
  for texture in _textures do
    texture.Free;

  _textures.Free;
  inherited;
end;

function TTextureManager.FindTexture(const Name: string): TTexture;
var
  i: integer;
  texture: TTexture;

begin
  result := nil;
  for i := 0 to TTextureManager.TextureManager.Textures.Count - 1 do
  begin
    texture := TTextureManager.TextureManager.Textures[i];
    if Texture.Name = name then
    begin
      result := texture;
      Break;
    end;
  end;
end;

function TTextureManager.ImportTextures(const filename: string): boolean;
var
  input: TextFile;
  texture: TTexture;
  line, name, r, g, b: string;
  red, green, blue: single;
  parameters: TStringList;

begin
  Textures.Clear;
  AssignFile(input, FileName);
  try
    Reset(input);
    parameters := TStringList.Create;
    while not(eof(input)) do
    begin
      ReadLn(input, line);
      Split(' ', line, parameters);
      name := parameters[0];
      r := parameters[1];
      g := parameters[2];
      b := parameters[3];
      red := StrToFloat(r);
      green := StrToFloat(g);
      blue := StrToFloat(b);
      texture := TTexture.Create;
      texture.Name := name;
      texture.Red := red;
      texture.Green := green;
      texture.Blue := blue;
      Textures.Add(texture);
    end;
    parameters.Free;
    result := true;
  finally
    CloseFile(input);
  end;
end;

class procedure TTextureManager.Initialise;
begin
  TextureManager := TTextureManager.Create;
end;

function TTextureManager.LoadBasicTextures(const filename: string): boolean;
var
  source: TextFile;
  name: string;
  r, g, b: single;
  texture: TTexture;

begin
  if FileExists(filename) then
    begin
      AssignFile(source, filename);
      try
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
      finally
        CloseFile(source);
      end;
    end;
end;

function TTextureManager.LoadTextures(const filename: string): boolean;
var
  i, n: integer;
  data, t: string;
  textureType: TTextureId;
  texture: TTexture;
  root: TJSONObject;
  texturesArray: TJSONArray;
  textureObj: TJSONObject;

begin
  _textures.Clear;
  data := TFile.ReadAllText(filename);
  root := TJSONObject.ParseJSONValue(data, true) as TJSONObject;
  texturesArray := root.Get('textures').JsonValue as TJSONArray;
  n := texturesArray.Count;
  for i := 0 to n - 1 do
  begin
    textureObj := texturesArray.Items[i] as TJSONObject;
    t := textureObj.GetValue('type').Value;
    textureType := TTextureId(StrToInt(t));
    case textureType of
      tiTexture: ;
      tiColor: texture := TTexture.Create;
      tiAgate: ;
      tiAverage: ;
      tiBozo: ;
      tiBrick: ;
      tiBumps: ;
      tiChecker: ;
      tiCrackle: ;
      tiDents: ;
      tiGradient: ;
      tiGranite: ;
      tiHexagon: ;
      tiLeopard: ;
      tiMandel: ;
      tiMarble: ;
      tiOnion: ;
      tiQuilted: ;
      tiRadial: ;
      tiRipples: ;
      tiSpiral1: ;
      tiSpiral2: ;
      tiSpotted: ;
      tiWaves: ;
      tiWood: ;
      tiWrinkles: ;
      tiMap: ;
      tiImage: ;
      tiSpiral: ;
      tiUser: ;
      tiLastTexture: ;
    end;

    texture.Load(textureObj);
    _textures.Add(texture);
  end;

  modified := False;
end;

procedure TTextureManager.SaveTextures(const filename: string);
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
  TFile.WriteAllText(filename, text);

  Modified := False;
end;

class procedure TTextureManager.Shutdown;
begin
  TextureManager.Free;
  TextureManager := nil;
end;

end.
