unit spiral;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  maptxtdlg, ComCtrls, Buttons, StdCtrls, ExtCtrls, Texture, Menus;

type
  TSpiralTextDialog = class(TMapTextDialog)
    Label10: TLabel;
    Arms: TEdit;
    ArmUpDown: TUpDown;
  private
    { Private declarations }
  protected
    procedure GetIntoTexture(texture: TTexture); override;
  public
    { Public declarations }
    procedure SetTexture(ATexture: TTexture); override;
  end;

implementation

uses maptext;

procedure TSpiralTextDialog.SetTexture(ATexture: TTexture);
var
  map: TMapTexture;

begin
  inherited SetTexture(ATexture);

  map := theTexture as TMapTexture;

  // Something missing here?
end;

procedure TSpiralTextDialog.GetIntoTexture(texture: TTexture);
var
  map: TMapTexture;

begin
  inherited GetIntoTexture(texture);

  map := texture as TMapTexture;

  // More missing here?
end;

{$R *.DFM}

end.
