unit coolray;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TCoolRayDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    SceneFile: TEdit;
    SceneFileBrowse: TSpeedButton;
    Label2: TLabel;
    ImageSize: TComboBox;
    Label3: TLabel;
    OutputType: TComboBox;
    OpenDialog: TOpenDialog;
    procedure SceneFileBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CoolRayDialog: TCoolRayDialog;

implementation

{$R *.DFM}

procedure TCoolRayDialog.SceneFileBrowseClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    SceneFile.Text := OpenDialog.Filename;
end;

end.
