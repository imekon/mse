unit hlpindex;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, UrlLabel;

type
  THelpIndexDialog = class(TForm)
    OKBtn: TButton;
    Image1: TImage;
    UrlLabel1: TUrlLabel;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
