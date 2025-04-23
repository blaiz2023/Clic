unit Clic1;
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2025 Blaiz Enterprises ( http://www.blaizenterprises.com )
//##
//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//## is furnished to do so, subject to the following conditions:
//##
//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//##
//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OfF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================

//##############################################################################
//## All units (clic1-clic10) were updated 13-NOV-2005 for XP
//## (a) Limited Account compatibility and
//## (b) Multi-user access
//## Copyright (c) 2005 Blaiz Enterprises
//## Date: 24apr2025, 14jul2020, 13nov2005
//##############################################################################
//## Last Modified: 14jul2020 @ 7:33pm (new help, new help viewer, updated retro lib)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, FileCtrl, Buttons, IniFiles,
  ExtDlgs, Clipbrd, ComCtrls, Clic6, Clic3, Clic4, Clic5,
  ShellApi, Clic9, clic11, clic12;

const
  programnameHARD='Clic';//translate('Clic')
  programname=programnameHARD;
  programlanguagesupport=false;
var
  programcheck:string='#';//for internal checking only!
  programshowsplash:boolean=true;
const
  programversion='2.00.255';
//was:  programcategory='Image Tools';
  webname='clic';

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    About2: TMenuItem;
    wwwblaiznet1: TMenuItem;
    File1: TMenuItem;
    Exit1: TMenuItem;
    OnlineHelp1: TMenuItem;
    Options1: TMenuItem;
    Greyscale1: TMenuItem;
    Transparent1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N2: TMenuItem;
    Bevel1: TBevel;
    SavetoStartButton1: TMenuItem;
    N3: TMenuItem;
    Defaulttransparentpixel1: TMenuItem;
    StatusBar1: TStatusBar;
    ClicHomepage1: TMenuItem;
    Edit1: TMenuItem;
    Paste1: TMenuItem;
    Clear1: TMenuItem;
    PastetoFit1: TMenuItem;
    Panel2: TPanel;
    Bevel2: TBevel;
    Copy1: TMenuItem;
    Mirror1: TMenuItem;
    Flip1: TMenuItem;
    New1: TMenuItem;
    NewInstance1: TMenuItem;
    Undo1: TMenuItem;
    OnTop1: TMenuItem;
    Size1: TMenuItem;
    N16x161: TMenuItem;
    N32x321: TMenuItem;
    N24x241: TMenuItem;
    N48x481: TMenuItem;
    N64x641: TMenuItem;
    N72x721: TMenuItem;
    N96x961: TMenuItem;
    RotateRight1: TMenuItem;
    N902: TMenuItem;
    N1802: TMenuItem;
    N2702: TMenuItem;
    RotateLeft1: TMenuItem;
    N903: TMenuItem;
    N1803: TMenuItem;
    N2703: TMenuItem;
    Invert1: TMenuItem;
    N5: TMenuItem;
    N4: TMenuItem;
    StartButtonlink1: TMenuItem;
    Desktoplink1: TMenuItem;
    ShowSplashscreenonstartup1: TMenuItem;
    ShowFolder1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure wwwblaiznet1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Options1Click(Sender: TObject);
    procedure Transparent1Click(Sender: TObject);
    procedure Greyscale1Click(Sender: TObject);
    Procedure ExitSystem;
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    Procedure UpdateCaption;
    procedure About2Click(Sender: TObject);
    Procedure LoadSystemSettings;
    Procedure SaveSystemSettings;
    Function INIFileName:String;
    Procedure SaveIcon(Var X:TOpenInfo;NewPath:String);
    procedure SavetoStartButton1Click(Sender: TObject);
    procedure Defaulttransparentpixel1Click(Sender: TObject);
    procedure ClicHomepage1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure PastetoFit1Click(Sender: TObject);
    Procedure UpdateButtons;
    procedure Copy1Click(Sender: TObject);
    Function GetOnTop:Boolean;
    Procedure SetOnTop(X:Boolean);
    procedure Mirror1Click(Sender: TObject);
    procedure Flip1Click(Sender: TObject);
    Procedure SetStatus(X:String);
    Function GetBusy:Boolean;
    Procedure SetBusy(X:Boolean);
    Procedure Rotate(X:Integer);
    Procedure Buttons_OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure Buttons_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure Buttons_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure Buttons_OnClick(Sender: TObject);
    Procedure SetTransparent(X:Boolean);
    Function GetTransparent:Boolean;
    Procedure SetGreyScale(X:Boolean);
    Function GetGreyScale:Boolean;
    procedure NewInstance1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure OnTop1Click(Sender: TObject);
    procedure N16x161Click(Sender: TObject);
    procedure N24x241Click(Sender: TObject);
    procedure N32x321Click(Sender: TObject);
    procedure N48x481Click(Sender: TObject);
    procedure N64x641Click(Sender: TObject);
    procedure N72x721Click(Sender: TObject);
    procedure N96x961Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N902Click(Sender: TObject);
    procedure N1802Click(Sender: TObject);
    procedure N2702Click(Sender: TObject);
    procedure N903Click(Sender: TObject);
    procedure N1803Click(Sender: TObject);
    procedure N2703Click(Sender: TObject);
    procedure Invert1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StartButtonlink1Click(Sender: TObject);
    procedure Desktoplink1Click(Sender: TObject);
    procedure OnlineHelp1Click(Sender: TObject);
    procedure ShowSplashscreenonstartup1Click(Sender: TObject);
    procedure ShowFolder1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
   iLastX,iLastY:Integer;
   iAllowCapture:Boolean;
   iMouseDown:Boolean;
   iSaveIcon:TOpenInfo;
   iErrorMessage:String;
   iCompactSplash:TCompactSplash;
   Procedure OnStatus(Sender:TObject);
   Procedure OnChange(Sender:TObject);
   Function GetSize:Integer;
   Procedure SetSize(X:Integer);
   Procedure ShowError;
   Procedure UpdateStatus;
  public
   Property OnTop:Boolean Read GetOnTop Write SetOnTop;
   Property Busy:Boolean Read GetBusy Write SetBusy;
   Property Status:String Write SetStatus;
   Property Transparent:Boolean Read GetTransparent Write SetTransparent;
   Property GreyScale:Boolean Read GetGreyScale Write SetGreyScale;
   Property Size:Integer Read GetSize Write SetSize;
   //.accept files support
   procedure acceptfiles(var msg:tmessage); message WM_DROPFILES;//drag&drop files - 24APR2011, 07DEC2009
  end;

Const
     hSpace=5;
     ViewerSize=400;//308;
     {Button Codes}
     clbcNull=0;
     clbcSaveAs=1;
     clbcUndo=2;
     clbcCopy=3;
     clbcPaste=4;
     clbcPasteToFit=5;
     clbcTransparent=6;
     clbcGreyScale=7;
     clbcMirror=8;
     clbcFlip=9;
     clbcRotate90=10;
     clbcScreenCapture=11;
     clbcMax=clbcScreenCapture;

Var
  Form1: TForm1;
  ClicA:TClic;
  Sps:Array[1..clbcMax] of TSpeedButton;

implementation
{$R *.DFM}

//## acceptfiles ##
procedure TForm1.acceptfiles(var msg:tmessage);//drag&drop files - 24APR2011, 07DEC2009
const//Important Note: Drag&Drop does not work when program is run from within Delphi on Win7 - 24APR2011
  flimit=255;
var
  p,count:integer;
  f:array [0..flimit] of char;
  z,e,fstr:string;
begin
try
//init
fillchar(f,sizeof(f),#0);//23APR2011
//find out how many files we're accepting
count:=dragqueryfile(msg.WParam,$FFFFFFFF,f,flimit);
//query Windows one at a time for the file name
try
for p:=0 to (count-1) do
begin
dragqueryfile(msg.WParam,p,f,flimit);
//.filename
fstr:=fromnullstr(@f,sizeof(f));
//.load file
if (not directoryexists(fstr)) and fileexists(fstr) and low__fromfile(fstr,z,e) then
   begin
   if not clica.pastein(z) then clica.showerror;
   end;
break;//1st item only
end;//p
except;end;
//let Windows know that you're done
dragfinish(msg.WParam);
except;end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
try
If Not Visible then exit;
If Busy then exit;
Timer1.Enabled:=False;
UpdateButtons;
except;end;
try;Timer1.Enabled:=True;except;end;
end;

procedure TForm1.wwwblaiznet1Click(Sender: TObject);
begin
try;low__plat('portal','',true);except;end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   a:tbitmap;
   e,x:string;
   xw,xh,p:longint;
begin
try
//defaults
a:=nil;
//system help colors - 14jul2020
sys_help_text2    :=low__rgb(120,153,187);
sys_help_header2  :=low__rgb(27,47,199);
sys_help_bgcolor  :=low__rgb(255,255,255);

//scanner
//was: scan.scan(422763,710144);

iLastX:=-1;
iLastY:=-1;
iAllowCapture:=False;
iMouseDown:=False;
//SaveDocument
iSaveIcon.Options:=[ofHideReadOnly,ofPathMustExist,ofOverWritePrompt];
iSaveIcon.Filter:=Translate('Icon')+' (*.ico)|*.ico';
iSaveIcon.FilterIndex:=1;
iSaveIcon.FileName:=bvfolder(bvfCursors);
iSaveIcon.DefaultEXT:='ICO';
{Form1}
Caption:=ProgramName;
Application.Title:=ProgramName;

//version check
low__vercheck(low__verretro,100472,'retro');

//continue
BorderIcons:=[biSystemMenu,biMinimize,biMaximize];
BorderStyle:=bsSizeable;
VertScrollBar.Visible:=False;
HorzScrollBar.Visible:=False;
{iCompactSplash}
iCompactSplash:=TCompactSplash.Create;
iCompactSplash.Name:=ECap(ProgramName,True);
iCompactSplash.Font.Color:=clBlack;
iCompactSplash.Font.Size:=8;
iCompactSplash.Font.Style:=[fsBold];
iCompactSplash.X:=5;
iCompactSplash.Y:=2;
iCompactSplash.NewVersion:=True;
iCompactSplash.LicensedTo:=ECap('('+Translate(ECap('()?úñ÷ôò÷ÄÆìá#Çµþû=ê0ô÷:íì¡Þž—RˆžØ«¡ÔÉ',False))+')',True);
iCompactSplash.Version:=ECap(Programversion,True);

//start program with plat - 07mar2020
low__plat_startofprogram(450000);//skip over most of EXE so we don't have to load it - 07mar2020

//.load splash image and slpash - 01jun2020
a:=low__newbmp24;
if not low__fromimgdata2(a,syssplash,e) then
   begin
   low__showerror(nil,translate('Task failed'));
   try;iCompactSplash.Free;except;end;
   Halt;
   end;
iCompactSplash.Image.Picture.Bitmap.assign(a);
freeobj(@a);

{ToolBar}
For P:=Low(Sps) to High(Sps) Do
begin
Sps[P]:=TSpeedButton.Create(Panel2);
Sps[P].Parent:=Panel2;
{Events}
Sps[P].OnMouseDown:=Buttons_OnMouseDown;
Sps[P].OnMouseMove:=Buttons_OnMouseMove;
Sps[P].OnMouseUp:=Buttons_OnMouseUp;
Sps[P].OnClick:=Buttons_OnClick;
{Width & Height}
Sps[P].Width:=25;
Sps[P].Height:=25;
{Top}
Sps[P].Top:=0;
{Left}
Case (P<>Low(Sps)) of
True:Sps[P].Left:=Sps[P-1].Left+Sps[P-1].Width;
False:Sps[P].Left:=Sps[P].Top+2;
end;//End of CASE
{Left - Dividers}
Case P of
clbcUndo,clbcTransparent,clbcMirror,clbcScreenCapture:Sps[P].Left:=Sps[P].Left+7;
end;
{Cursors}
Case P of
clbcScreenCapture:Sps[P].Cursor:=crDrag;
else
Sps[P].Cursor:=crHandPoint;
end;//end of case
{Mouse Modes}
Case P of
clbcTransparent:begin
    Sps[P].GroupIndex:=1;
    Sps[P].AllowAllUp:=True;
    end;//end of begin
clbcGreyScale:begin
    Sps[P].GroupIndex:=2;
    Sps[P].AllowAllUp:=True;
    end;//end of begin
end;//end of case
{Style}
Sps[P].Flat:=True;
{Hint}
X:='';
Case P of
clbcSaveAs:X:=Translate('Save As...');
clbcUndo:X:=Translate('Undo');
clbcCopy:X:=Translate('Copy');
clbcPaste:X:=Translate('Paste');
clbcPasteToFit:X:=Translate('Paste to Fit');
clbcTransparent:X:=Translate('Transparency On/Off');
clbcGreyScale:X:=Translate('Greyscale On/Off');
clbcMirror:X:=Translate('Mirror');
clbcFlip:X:=Translate('Flip');
clbcRotate90:X:=Translate('Rotate')+' 90';
clbcScreenCapture:X:=Translate('Screen Capture')+RCode+'* '+Translate('Click and drag for screen capture')+RCode+'  ('+Translate('press space bar for ultra fine')+')';
end;//End of CASE
Sps[P].Tag:=P;
Sps[P].Hint:=X;
Sps[P].ShowHint:=(Sps[P].Hint<>'');
{Images}
Case P of
clbcSaveAs:X:=tepSaveAs;
clbcUndo:X:=tepUndo;
clbcCopy:X:=tepCopy;
clbcPaste:X:=tepPaste;
clbcPasteToFit:X:=tepPasteToFit;
clbcTransparent:X:=tepTransparent;
clbcGreyScale:X:=tepGreyScale;
clbcMirror:X:=tepMirror;
clbcFlip:X:=tepFlip;
clbcRotate90:X:=tepRotate90;
clbcScreenCapture:X:=tepScreenCapture;
else
X:='';
end;//end of case
If (X<>'') then Sps[P].Glyph:=AsGlyph(X,true);
end;//end of loop
Panel2.Height:=Sps[1].Height;
Panel2.Width:=Sps[High(Sps)].Left+Sps[High(Sps)].Width;
{StatusBar1}
StatusBar1.Enabled:=True;
StatusBar1.Panels[0].Width:=65;
StatusBar1.Panels[1].Width:=80;
StatusBar1.SimplePanel:=False;
StatusBar1.SizeGrip:=True;
{ClientHeight}
ClientHeight:=StatusBar1.Height+ViewerSize-22;
ClientWidth:=ViewerSize+113+20;
{AppHint}
Application.HintPause:=1000;
Application.HintShortPause:=250;
{ClicA}
ClicA:=TClic.Create;
ClicA.Form.Parent:=Form1;
ClicA.Form.Align:=alClient;
ClicA.Form.Visible:=True;
ClicA.OnStatus:=OnStatus;
ClicA.OnChange:=OnChange;
{TranslateMenu}
TranslateMenu(MainMenu1.Items);
{LoadSystemSettings}
LoadSystemSettings;
if programshowsplash then iCompactSplash.Splash;

{New}
ClicA.New;
{Form1}
General.CenterControl(Form1);
Repaint;
{Start Button}
//no longer required - 07mar2020 - Paths.CopyTo(Application.EXEName,bvfolder(bvfImageTools)+ProgramName+'.EXE');
{Defaults}
Timer1.Interval:=500;
Busy:=False;
{Hide Splash}
iCompactSplash.Hide(1);

//accept files init
dragacceptfiles(handle,true);
except;end;
try;freeobj(@a);except;end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try;ExitSystem;except;end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
try;ExitSystem;except;end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
try;ExitSystem;except;end;
end;

procedure TForm1.Options1Click(Sender: TObject);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
Transparent1.Checked:=A.Icon.Transparent;
Greyscale1.Checked:=A.GreyScale;
except;end;
end;

procedure TForm1.Transparent1Click(Sender: TObject);
begin
try;Transparent:=Not Transparent;except;end;
end;

procedure TForm1.Greyscale1Click(Sender: TObject);
begin
try;GreyScale:=Not GreyScale;except;end;
end;
//## ExitSystem ##
Procedure TForm1.ExitSystem;
begin
try
{Hide}
Hide;
{SaveSystemSettings}
SaveSystemSettings;
{ClicA}
ClicA.Free;
low__plat_close;
{iCompactSplash}
iCompactSplash.Free;
{Halt}
Halt;
except;end;
end;
procedure TForm1.Save1Click(Sender: TObject);
begin
try
Status:='Saving...';
Busy:=True;
If Not ClicA.Save then ClicA.ShowError;
UpdateCaption;
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
try;SaveIcon(iSaveIcon,'');except;end;
end;

procedure TForm1.File1Click(Sender: TObject);
begin
try
Save1.Enabled:=ClicA.CanSave;
StartButtonlink1.checked:=nb(low__plat('startmenu.exists','',false));
Desktoplink1.checked:=nb(low__plat('desktop.exists','',false));
ShowSplashscreenonstartup1.checked:=programshowsplash;
except;end;
end;
//## UpdateCaption ##
Procedure TForm1.UpdateCaption;
Var
   X:String;
begin
try
X:=ClicA.Name+' - '+ProgramName;
If Not ClicA.Saved then X:='*'+X;
If (Caption<>X) then Caption:=X;
except;end;
end;

procedure TForm1.About2Click(Sender: TObject);
begin
try;iCompactSplash.About;except;end;
end;
//## INIFileName ##
Function TForm1.INIFileName:String;
begin
try;Result:=low__platsettings;except;end;
end;
//## SaveSystemSettings ##
Procedure TForm1.SaveSystemSettings;
Var
   BrushFile:String;
   IniFileA:TIniFile;
   A:TClicStyle;
begin
try
A:=ClicA.Style;
{Save Program Settings}
IniFileA:=TIniFile.Create(INIFileName);
{Settings}
IniFileA.WriteString('Settings', 'TransX', IntToStr(A.Icon.TransparentX));
IniFileA.WriteString('Settings', 'TransY', IntToStr(A.Icon.TransparentY));
IniFileA.WriteString('Settings', 'Transparent', General.BN(A.Icon.Transparent));
IniFileA.WriteString('Settings', 'Greyscale', General.BN(A.Greyscale));
IniFileA.WriteString('Settings', 'Size', IntToStr(A.Icon.Width));
IniFileA.WriteString('Settings', 'OnTop', General.BN(OnTop));
IniFileA.WriteString('Settings', 'ShowSplash', General.BN(programshowsplash));
except;end;
try;IniFileA.Free;except;end;
end;
//## LoadSystemSettings ##
Procedure TForm1.LoadSystemSettings;
Label
     SkipEnd;
Var
   BrushFile:String;
   IniFile:String;
   IniFileA:TIniFile;
   B:TStringList;
   X:String;
   Open:Boolean;
   C:TClicStyle;
begin
try
//OLD -> NEW
//.ini
//was: oldtonew(winroot+'Blaiz Enterprises\Settings\'+ProgramName+'.INI',inifilename,true);
//PROCESS
Open:=False;
C:=ClicA.Style;
{Load Program Settings}
IniFile:=INIFileName;
If Not FileExists(IniFile) then Goto SkipEnd;
{Read Settings}
Open:=True;
IniFileA:=TIniFile.Create(IniFile);
B:=TStringList.Create;
{Settings}
IniFileA.ReadSectionValues('Settings', B);
X:=B.Values['Size'];C.Icon.Width:=General.Val(X);C.Icon.Height:=C.Icon.Width;
X:=B.Values['TransX'];C.Icon.TransparentX:=General.Val(X);
X:=B.Values['TransY'];C.Icon.TransparentY:=General.Val(X);
X:=B.Values['Transparent'];C.Icon.Transparent:=General.NB(X);//fixed 13-NOV-2005
X:=B.Values['Greyscale'];C.Greyscale:=General.NB(X);
X:=B.Values['OnTop'];OnTop:=General.NB(X);
X:=low__udv(B.Values['ShowSplash'],'1');programshowsplash:=General.NB(X);//01jun2020
ClicA.Style:=C;
SkipEnd:
except;end;
try
If Open then
   begin
   IniFileA.Free;
   B.Free;
   end;//end of if
except;end;
end;

procedure TForm1.SavetoStartButton1Click(Sender: TObject);
begin
try;SaveIcon(iSaveIcon,bvfolder(bvfCursors));except;end;
end;

procedure TForm1.Defaulttransparentpixel1Click(Sender: TObject);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
A.Icon.TransparentX:=0;
A.Icon.TransparentY:=0;
A.Icon.Transparent:=True;
ClicA.Style:=A;
except;end;
end;

procedure TForm1.ClicHomepage1Click(Sender: TObject);
begin
try;low__plat('vintage','clic',true);except;end;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
try
Status:=Translate('Pasting...');
Busy:=True;
If Not ClicA.Paste then ClicA.ShowError;
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
try
Paste1.Enabled:=ClicA.CanPaste;
PasteToFit1.Enabled:=Paste1.Enabled;
OnTop1.Checked:=OnTop;
except;end;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
try
Status:=Translate('Clearing...');
Busy:=True;
If not ClicA.Clear then ClicA.ShowError;
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.PastetoFit1Click(Sender: TObject);
begin
try
Status:=Translate('Pasting to Fit...');
Busy:=True;
if not ClicA.PasteAll then ClicA.ShowError;
except;end;
try;Busy:=False;except;end;
end;
//## UpdateButtons ##
Procedure TForm1.UpdateButtons;
begin
try
Sps[clbcPaste].Enabled:=ClicA.CanPaste and (Not Busy);
Sps[clbcPasteToFit].Enabled:=Sps[clbcPaste].Enabled;
except;end;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
try
Status:=Translate('Copying...');
Busy:=True;
If Not ClicA.Copy then ClicA.ShowError;
except;end;
try;Busy:=False;except;end;
end;
//## SetOnTop ##
Procedure TForm1.SetOnTop(X:Boolean);
begin
try
Case X of
True:FormStyle:=fsStayOnTop;
False:FormStyle:=fsNormal;
end;//end of case
except;end;
end;
//## GetOnTop ##
Function TForm1.GetOnTop:Boolean;
begin
try;Result:=(FormStyle=fsStayOnTop);except;end;
end;

procedure TForm1.Mirror1Click(Sender: TObject);
begin
try;Busy:=True;If Not ClicA.FlipMirror(True) then ClicA.ShowError;except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.Flip1Click(Sender: TObject);
begin
try;Busy:=True;If Not ClicA.FlipMirror(False) then ClicA.ShowError;except;end;
try;Busy:=False;except;end;
end;
//## Rotate ##
Procedure TForm1.Rotate(X:Integer);
begin
try;Busy:=True;If Not ClicA.RotateBy(X) then ClicA.ShowError;except;end;
try;Busy:=False;except;end;
end;
//## SaveIcon ##
Procedure TForm1.SaveIcon(Var X:TOpenInfo;NewPath:String);
Var
   FileName:String;
begin
try
//savedialog
If Not OpenHandler.Execute(X,TSaveDialog,NewPath,FileName) then exit;
X.FileName:=FileName;
//save
Status:=Translate('Saving...');
Busy:=True;
If Not ClicA.SaveToFile(FileName) then ClicA.ShowError;
except;end;
try
UpdateCaption;
Busy:=False;
except;end;
end;
//## GetBusy ##
Function TForm1.GetBusy:Boolean;
begin
try;Result:=Not File1.Enabled;except;end;
end;
//## SetBusy ##
Procedure TForm1.SetBusy(X:Boolean);
Var
   P:Integer;
begin
try
Case X of
True:Screen.Cursor:=crAppStart;
False:Screen.Cursor:=crDefault;
end;//end of case
{Menus}
File1.Enabled:=Not X;
Edit1.Enabled:=File1.Enabled;
Size1.Enabled:=File1.Enabled;
Options1.Enabled:=File1.Enabled;
Help1.Enabled:=File1.Enabled;
{Buttons}
For P:=Low(Sps) to High(Sps) Do
begin
Case P of
clbcPaste:Updatebuttons;
clbcPasteToFit:{null};
else
Sps[P].Enabled:=File1.Enabled;
end;//end of case
end;//end of loop
{Default Status}
Case X of
True:Status:=Translate('Working...');
False:begin
    Status:='';
    UpdateCaption;
    end;//end of begin
end;//end of case
{Update System}
Application.ProcessMessages;
except;end;
end;
//## SetStatus ##
Procedure TForm1.SetStatus(X:String);
begin
try
{Status}
If (X='') then X:=Translate('Ready');
If (StatusBar1.Panels[2].Text<>X) then StatusBar1.Panels[2].Text:=X;
{UpdateStatus}
UpdateStatus;
except;end;
end;
//## UpdateStatus ##
Procedure TForm1.UpdateStatus;
Var
   A:TClicStyle;
   X:String;
begin
try
A:=ClicA.Style;
{Dimensions}
X:=IntToStr(A.Icon.Width)+'w x '+IntToStr(A.Icon.Height)+'h';
If (StatusBar1.Panels[0].Text<>X) then StatusBar1.Panels[0].Text:=X;
{FineCap}
Case iMouseDown of
True:begin
    Case ClicA.FineCap of
    True:X:=Translate('Fine');
    False:X:=Translate('Normal');
    end;//end of case
    end;//end of begin
False:X:='';
end;//end of case
If (StatusBar1.Panels[1].Text<>X) then StatusBar1.Panels[1].Text:=X;
{Update System}
Application.ProcessMessages;
except;end;
end;
//## Buttons_OnClick ##
Procedure TForm1.Buttons_OnClick(Sender: TObject);
Var
   Com:Integer;
begin
try
Com:=clbcNull;
If (Sender is TSpeedButton) then Com:=(Sender as TSpeedButton).Tag;
Case Com of
clbcSaveAs:SaveAs1Click(Self);
clbcUndo:Undo1Click(Self);
clbcCopy:Copy1Click(Self);
clbcPaste:Paste1Click(Self);
clbcPasteToFit:PastetoFit1Click(Self);
clbcTransparent:Transparent:=Not Transparent;
clbcGreyScale:GreyScale:=Not GreyScale;
clbcMirror:Mirror1Click(Self);
clbcFlip:Flip1Click(Self);
clbcRotate90:N902Click(Self);
clbcScreenCapture:{null};
else
{clbcNull}
end;//end of case
except;end;
end;
//## GetGreyScale ##
Function TForm1.GetGreyScale:Boolean;
begin
try;Result:=ClicA.Style.GreyScale;except;end;
end;
//## SetGreyScale ##
Procedure TForm1.SetGreyScale(X:Boolean);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
A.GreyScale:=X;
ClicA.Style:=A;
except;end;
end;

procedure TForm1.NewInstance1Click(Sender: TObject);
begin
try
Status:=Translate('Working...');
Busy:=True;
Run(Application.EXEName,'');
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
try
Status:=Translate('Working...');
Busy:=True;
ClicA.New;
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
try
Status:=Translate('Undoing...');
Busy:=True;
If Not ClicA.Undo then ClicA.ShowError;
except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.OnTop1Click(Sender: TObject);
begin
try;OnTop:=Not OnTop;except;end;
end;

procedure TForm1.N16x161Click(Sender: TObject);
begin
try;Size:=16;except;end;
end;

procedure TForm1.N24x241Click(Sender: TObject);
begin
try;Size:=24;except;end;
end;

procedure TForm1.N32x321Click(Sender: TObject);
begin
try;Size:=32;except;end;
end;

procedure TForm1.N48x481Click(Sender: TObject);
begin
try;Size:=48;except;end;
end;

procedure TForm1.N64x641Click(Sender: TObject);
begin
try;Size:=64;except;end;
end;

procedure TForm1.N72x721Click(Sender: TObject);
begin
try;Size:=72;except;end;
end;

procedure TForm1.N96x961Click(Sender: TObject);
begin
try;Size:=96;except;end;
end;
//## SetSize ##
Procedure TForm1.SetSize(X:Integer);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
A.Icon.Width:=X;
A.Icon.Height:=X;
ClicA.Style:=A;
except;end;
end;
//## GetSize ##
Function TForm1.GetSize:Integer;
begin
try;Result:=ClicA.Style.Icon.Width;except;end;
end;

procedure TForm1.Size1Click(Sender: TObject);
Var
   X:Integer;
begin
try
X:=Size;
N16x161.Checked:=(X=16);
N24x241.Checked:=(X=24);
N32x321.Checked:=(X=32);
N48x481.Checked:=(X=48);
N64x641.Checked:=(X=64);
N72x721.Checked:=(X=72);
N96x961.Checked:=(X=96);
except;end;
end;
//## OnStatus ##
Procedure TForm1.OnStatus(Sender:TObject);
begin
try
Status:=ClicA.Status;
except;end;
end;
//## Buttons_OnMouseDown ##
Procedure TForm1.Buttons_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
try
{clbcScreenCapture}
If (Sender=Sps[clbcScreenCapture]) then
   begin
   ClicA.FineCap:=(Button=mbRight);
   {UpdateStatus}
   UpdateStatus;
   If iMouseDown then exit;
   iLastX:=-1;
   iLastY:=-1;
   iAllowCapture:=False;
   iMouseDown:=True;
   Screen.Cursor:=crDrag;
   end;//end of if
except;end;
end;
//## Buttons_OnMouseUp ##
Procedure TForm1.Buttons_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
try
{Ignore}
If Not iMouseDown then exit;
{clbcScreenCapture}
If (Sender=Sps[clbcScreenCapture]) then
   begin
   iMouseDown:=False;
   iAllowCapture:=False;
   Screen.Cursor:=crDefault;
   Status:='';
   ClicA.Capture(True,ClicA.FineCap);
   end;//end of if
except;end;
end;
//## Buttons_OnMouseMove ##
Procedure TForm1.Buttons_OnMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
begin
try
{Prevent Sprial Feedback - caused by "ClicA.Capture.Form.Create/Destroy"}
If (iLastX=X) and (iLastY=Y) then exit;
iLastX:=X;
iLastY:=Y;
If iMouseDown then If (Sender=Sps[clbcScreenCapture]) then
   begin
   If Not iAllowCapture then If (X<0) or (Y<0) or (X>Sps[clbcScreenCapture].Width) or (Y>Sps[clbcScreenCapture].Height) then
      begin
      iAllowCapture:=True;
      {Update Undo}
      ClicA.UpdateUndo;
      end;//end of if
   If iAllowCapture then
      begin
      ClicA.Capture(False,ClicA.FineCap);
      {Status}
      Status:=Translate('Working...');
      end;//end of if
   end;
except;end;
end;

procedure TForm1.FormResize(Sender: TObject);
Var
   W,H:Integer;
begin
try
{Enforce Minimum Form Dimensions}
W:=Width;
If (W<372) then W:=372;
H:=Height;
If (H<318) then H:=318;
SetBounds(Left,Top,W,H);
except;end;
end;
//## GetTransparent ##
Function TForm1.GetTransparent:Boolean;
begin
try;Result:=ClicA.Style.Icon.Transparent;except;end;
end;
//## SetTransparent ##
Procedure TForm1.SetTransparent(X:Boolean);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
A.Icon.Transparent:=X;
ClicA.Style:=A;
except;end;
end;
//## OnChange ##
procedure TForm1.OnChange(Sender:TObject);
Var
   A:TClicStyle;
begin
try
A:=ClicA.Style;
If (Sps[clbcGreyScale].Down<>A.GreyScale) then Sps[clbcGreyScale].Down:=A.GreyScale;
If (Sps[clbcTransparent].Down<>A.Icon.Transparent) then Sps[clbcTransparent].Down:=A.Icon.Transparent;
{UpdateCaption}
UpdateCaption;
except;end;
end;
//## ShowError ##
Procedure TForm1.ShowError;
begin
try;General.ShowError(iErrorMessage);except;end;
end;

procedure TForm1.N902Click(Sender: TObject);
begin
try;Rotate(90);except;end;
end;

procedure TForm1.N1802Click(Sender: TObject);
begin
try;Rotate(180);except;end;
end;

procedure TForm1.N2702Click(Sender: TObject);
begin
try;Rotate(270);except;end;
end;

procedure TForm1.N903Click(Sender: TObject);
begin
try;Rotate(-90);except;end;
end;

procedure TForm1.N1803Click(Sender: TObject);
begin
try;Rotate(-180);except;end;
end;

procedure TForm1.N2703Click(Sender: TObject);
begin
try;Rotate(-270);except;end;
end;

procedure TForm1.Invert1Click(Sender: TObject);
begin
try;Busy:=True;If Not ClicA.Inverse then ClicA.ShowError;except;end;
try;Busy:=False;except;end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
try
If Not iMouseDown then exit;
Case Key of
32:ClicA.FineCap:=Not ClicA.FineCap;
end;//end of case
{UpdateStatus}
UpdateStatus;
except;end;
end;

procedure TForm1.StartButtonlink1Click(Sender: TObject);
begin
try;low__plat('startmenu.toggle','',true);except;end;
end;

procedure TForm1.Desktoplink1Click(Sender: TObject);
begin
try;low__plat('desktop.toggle','',true);except;end;
end;

procedure TForm1.OnlineHelp1Click(Sender: TObject);
begin
try;low__plat('showhelp','',false);except;end;
end;

procedure TForm1.ShowSplashscreenonstartup1Click(Sender: TObject);
begin
try;programshowsplash:=not programshowsplash;except;end;
end;

procedure TForm1.ShowFolder1Click(Sender: TObject);
begin
try;low__plat('showroot','',false);except;end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
try
//accept files close
dragacceptfiles(handle,false);
except;end;
end;

end.
