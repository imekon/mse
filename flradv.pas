unit flradv;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TLensFlareAdvancedDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    CameraList: TComboBox;
    Label2: TLabel;
    FlareType: TComboBox;
    PageControl: TPageControl;
    SourceSheet: TTabSheet;
    Label3: TLabel;
    SourceSize: TEdit;
    GlowSheet: TTabSheet;
    RingSheet: TTabSheet;
    BigGlowSheet: TTabSheet;
    Label4: TLabel;
    GlowSize: TEdit;
    Label5: TLabel;
    RingSize: TEdit;
    Label6: TLabel;
    RingWidth: TEdit;
    Label7: TLabel;
    SourceRed: TEdit;
    SourceGreen: TEdit;
    SourceBlue: TEdit;
    Label8: TLabel;
    GlowRed: TEdit;
    GlowGreen: TEdit;
    GlowBlue: TEdit;
    Label9: TLabel;
    RingRed: TEdit;
    RingGreen: TEdit;
    RingBlue: TEdit;
    Label10: TLabel;
    SourceBrightness: TEdit;
    Label11: TLabel;
    GlowBrightness: TEdit;
    Label12: TLabel;
    SourceTrans: TEdit;
    Label13: TLabel;
    GlowTrans: TEdit;
    Label14: TLabel;
    RingTrans: TEdit;
    Label15: TLabel;
    SourceFade: TEdit;
    Label16: TLabel;
    BigGlowSize: TEdit;
    Label17: TLabel;
    BigGlowRed: TEdit;
    BigGlowGreen: TEdit;
    BigGlowBlie: TEdit;
    Label18: TLabel;
    BigGlowTrans: TEdit;
    StreakASheet: TTabSheet;
    StreakBSheet: TTabSheet;
    Label19: TLabel;
    StreakASize: TEdit;
    Label20: TLabel;
    StreakARed: TEdit;
    StreakAGreen: TEdit;
    StreakABlue: TEdit;
    Label21: TLabel;
    StreakACRed: TEdit;
    StreakACGreen: TEdit;
    StreakACBlue: TEdit;
    Label22: TLabel;
    StreakATrans: TEdit;
    Label23: TLabel;
    StreakAScaleX: TEdit;
    StreakAScaleY: TEdit;
    Label24: TLabel;
    StreakARot: TEdit;
    StreakARotate: TCheckBox;
    SparkleSheet: TTabSheet;
    SpotSheet: TTabSheet;
    MiscSheet: TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LensFlareAdvancedDialog: TLensFlareAdvancedDialog;

implementation

{$R *.DFM}

end.
