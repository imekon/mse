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

program mse;

{$R 'resource.res' 'resource.rc'}

uses
  Forms,
  main in 'main.pas' {MainForm},
  ABOUT in 'ABOUT.PAS' {AboutBox},
  rgbft in 'rgbft.pas' {RGBFTDlg},
  texture in 'texture.pas',
  newscene in 'newscene.pas' {NewSceneDlg},
  Scene in 'Scene.pas' {SceneData: TDataModule},
  sphere in 'sphere.pas',
  Plane in 'Plane.pas',
  Light in 'Light.pas',
  lightedit in 'lightedit.pas' {LightEditorDlg},
  spotedit in 'spotedit.pas' {SpotLightEditorDlg},
  areaedit in 'areaedit.pas' {AreaLightEditorDlg},
  Cube in 'Cube.pas',
  grid in 'grid.pas' {GridDlg},
  zoom in 'zoom.pas' {ZoomDlg},
  Solid in 'Solid.pas',
  Polygon in 'Polygon.pas',
  shapeinfo in 'shapeinfo.pas' {ShapeInfoDlg},
  fileinfo in 'fileinfo.pas' {FileInfoDlg},
  Splash in 'Splash.pas' {SplashScreen},
  vector in 'vector.pas',
  solidedit in 'solidedit.pas' {SolidEditor},
  misc in 'misc.pas',
  scenewizdlg in 'scenewizdlg.pas' {SceneWizardDlg},
  PolyEdit in 'PolyEdit.pas' {PolyEditor},
  impdlg in 'impdlg.pas' {ImportDlg},
  polyscale in 'polyscale.pas' {PolyScaleDlg},
  user in 'user.pas',
  userdlg in 'userdlg.pas' {UserDialog},
  texttype in 'texttype.pas' {TextTypeDlg},
  brick in 'brick.pas',
  checker in 'checker.pas',
  hexagon in 'hexagon.pas',
  maptext in 'maptext.pas',
  htfld in 'htfld.pas',
  htflddlg in 'htflddlg.pas' {HeightFieldDialog},
  group in 'group.pas',
  gallery in 'gallery.pas' {GalleryDialog},
  cregal in 'cregal.pas' {GalleryDetailsDialog},
  renderdlg in 'renderdlg.pas' {RenderDialog},
  camdlg in 'camdlg.pas' {CameraDialog},
  browser in 'browser.pas' {ObjectBrowser},
  spheredlg in 'spheredlg.pas' {SphereDialog},
  Bicubic in 'Bicubic.pas',
  bicubedit in 'bicubedit.pas' {BicubicEditor},
  settings in 'settings.pas' {SettingsDialog},
  disc in 'disc.pas',
  torus in 'torus.pas',
  discdlg in 'discdlg.pas' {DiscDialog},
  torusdlg in 'torusdlg.pas' {TorusDialog},
  super in 'super.pas',
  superdlg in 'superdlg.pas' {SuperDialog},
  crebicubic in 'crebicubic.pas' {CreateBicubicDialog},
  gang in 'gang.pas' {GangScreen},
  crepoly in 'crepoly.pas' {CreatePolygonDialog},
  meshdlg in 'meshdlg.pas' {MeshDialog},
  pastedlg in 'pastedlg.pas' {PasteDialog},
  text in 'text.pas',
  textfm in 'textfm.pas' {TextDialog},
  extdlg in 'extdlg.pas' {CreateExtrusionDialog},
  nsides in 'nsides.pas' {NSidedDialog},
  iriddlg in 'iriddlg.pas' {IridVectorDialog},
  turbulence in 'turbulence.pas' {TurbulenceDialog},
  bricksize in 'bricksize.pas' {BrickSizeDialog},
  lathedit in 'lathedit.pas' {LatheEditor},
  julia in 'julia.pas',
  juliadlg in 'juliadlg.pas' {JuliaDialog},
  halo in 'halo.pas',
  halodlg in 'halodlg.pas' {HaloDialog},
  halosdlg in 'halosdlg.pas' {HalosDialog},
  rendmega in 'rendmega.pas' {RenderMegaDlg},
  grpdet in 'grpdet.pas' {GroupDetailsDialog},
  anim in 'anim.pas',
  fogdlg in 'fogdlg.pas' {FogDialog},
  prevdlg in 'prevdlg.pas' {PreviewDialog},
  rebtext in 'rebtext.pas' {RebuildTextureForm},
  findtext in 'findtext.pas' {FindTextureDialog},
  chtextnm in 'chtextnm.pas' {ChooseTextureNameDialog},
  quat in 'quat.pas',
  layers in 'layers.pas' {LayersForm},
  grpedit in 'grpedit.pas' {GroupEditor},
  spring in 'spring.pas',
  textform in 'textform.pas' {TextureForm},
  model_TLB in 'model_TLB.pas',
  mseimpl in 'mseimpl.pas' {ModelSceneEditor: CoClass},
  matrix in 'matrix.pas',
  expopt in 'expopt.pas' {ExportOptionsDialog},
  rgbframe in 'rgbframe.pas' {RGBFTFrame: TFrame},
  turbframe in 'turbframe.pas' {TurbulenceFrame: TFrame},
  tracdbg in 'tracdbg.pas',
  parser in 'parser.pas',
  scripted in 'scripted.pas',
  scrdlg in 'scrdlg.pas' {ScriptedDialog},
  scrfildlg in 'scrfildlg.pas' {ScriptFileDialog},
  coolray in 'coolray.pas' {CoolRayDialog},
  env in 'env.pas',
  engine in 'engine.pas',
  envdlg in 'envdlg.pas' {EnvironmentDialog},
  texture.manager in 'texture.manager.pas',
  JSONHelper in 'JSONHelper.pas';

{$R *.TLB}

{$R *.RES}

begin
  Application.Title := 'Model Scene Editor';
  Application.HelpFile := 'mse.hlp';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSolidEditor, SolidEditor);
  Application.CreateForm(TPolyEditor, PolyEditor);
  Application.CreateForm(TObjectBrowser, ObjectBrowser);
  Application.CreateForm(TBicubicEditor, BicubicEditor);
  Application.CreateForm(TGalleryDialog, GalleryDialog);
  Application.CreateForm(TLatheEditor, LatheEditor);
  Application.CreateForm(TFogDialog, FogDialog);
  Application.CreateForm(TRebuildTextureForm, RebuildTextureForm);
  Application.CreateForm(TChooseTextureNameDialog, ChooseTextureNameDialog);
  Application.CreateForm(TLayersForm, LayersForm);
  Application.CreateForm(TGroupEditor, GroupEditor);
  Application.CreateForm(TTextureForm, TextureForm);
  Application.CreateForm(TCoolRayDialog, CoolRayDialog);
  Application.Run;
end.
