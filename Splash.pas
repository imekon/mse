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

unit Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TSplashScreen = class(TForm)
    Timer: TTimer;
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure SplashPanelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreen: TSplashScreen;

implementation

{$R *.DFM}

procedure TSplashScreen.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  Close;
end;

procedure TSplashScreen.SplashPanelClick(Sender: TObject);
begin
  Timer.Enabled := false;
  Close;
end;

procedure TSplashScreen.FormCreate(Sender: TObject);
begin
  ClientWidth := Image.Width;
  ClientHeight := Image.Height;
end;

procedure TSplashScreen.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
