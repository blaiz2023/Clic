unit Clic4;
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
//## Name: TCompactSplash
//## Type: TComponent
//## Description: Compact, Professional, Splash/About Screen
//## Version: 1.00.087
//## Date: 24apr2025, 01jun2020, 12/11/2002
//## Lines: 351
//## Copyright (c) 1997-2025 Blaiz Enterprises
//##############################################################################

interface

uses
  Windows, Forms, Classes, Graphics, Controls, SysUtils,
  StdCtrls, ExtCtrls, clic5, clic11;

{TCompactSplash}
Const
     {Label Codes}
     cpscName=0;
     cpscVer=1;
     cpscLic=2;
     cpscCopy=3;
     cpscWeb=4;
     {Show Modes}
     cpscSplash=0;
     cpscAbout=1;
     cpscShowMax=1;

Type
    TCompactSplash=Class(TComponent)
    Private
     FOnShow:TNotifyEvent;
     iX,iY:Integer;
     iShowName:Boolean;
     iLicensedTo,iCopyright,iName,iVersion,iWeb:String;
     iForm:TForm;
     iImage:TImage;
     iLabels:Array[0..4] of TLabel;
     iTitles:Array[0..4] of TLabel;
     iFont:TFont;
     ishowing,iNewVersion:Boolean;
     Procedure ShowForm(X:Integer);
     Procedure OnClick(Sender:TObject);
     Procedure iForm_OnKey(Sender: TObject; var Key: Word; Shift: TShiftState);
     Procedure DoOnShow;
    Public
     {Create}
     Constructor Create;
     {Form}
     Property Form:TForm Read iForm;
     {Properties}
     Property NewVersion:Boolean Read iNewVersion Write iNewVersion;
     Property ShowName:Boolean Read iShowName Write iShowName;
     Property LicensedTo:String Read iLicensedTo Write iLicensedTo;
     Property Version:String Read iVersion Write iVersion;
     Property Name:String Read iName Write iName;
     Property Copyright:String Read iCopyright Write iCopyright;
     Property Web:String Read iWeb Write iWeb;
     Property Font:TFont Read iFont Write iFont;
     Property X:Integer Read iX Write iX;
     Property Y:Integer Read iY Write iY;
     Property Image:TImage Read iImage;
     Function Year(Min:Integer):Integer;
     {Events}
     Property OnShow:TNotifyEvent Read FOnShow Write FOnShow;
     {Splash}
     Procedure Splash;
     Procedure About;
     procedure hide(xsec:longint);//01jun2020
     {Free}
     Procedure Disassociate;
     Procedure Free;
    end;

implementation

//## Create ##
Constructor TCompactSplash.Create;
Var
   P:Integer;
   be:String;
begin
iNewVersion:=False;
{iShowName}
iShowName:=False;
ishowing:=false;
{be}
be:='8ø7Aó459þ¿Á³ê*C®<?77,<<0B;E´îûîÀ´ëJð<''ëî/X¦Þ•Êß’²¡§‘Öäßà Îâ‰‹…';
{Variables}
iName:='';
iLicensedTo:=ECap('('+Translate(ECap('(7Kú1ùó:ÄÇñë7â>ïôñò=K"GA·ç­„€šÖ˜æ¬ÏÉ',False))+')',True);{Translate('Not Licensed')}
iVersion:='!/>ôóø:6¾ÿ¹êÚ1òóýõñ¶Ùž¢¢áÝ';{Translate('Unknown')}
iCopyright:=ECap(Translate(ECap('2B40:ñ14ÉÅú¹¿"7Éí?B/÷ì64ìAôï¶¶Âñåì5ð·ÐÑæžÊÔ ­',False))+ECap('ìñ3ø<4ìÅ¿ÆLÕ„j¢ja',False)+IntToStr(Year(2002))+ECap(be,False)+Translate(ECap('%B@ú89+ë¿Áâî#7Äº=õ9@íöJµÙ¥‹¸Ä™Ú§¦{ºÒÔ’«à˜Ï',False)),True);
//Translate('Copyright')+' © 1997-'+IntToStr(Year(2002))+' Blaiz Enterprises   '+Translate('All Rights Reserved');
iWeb:=low__plat('splash','',false);

{iForm}
iForm:=TForm.Create(Nil);
iForm.VertScrollBar.Visible:=False;
iForm.HorzScrollBar.Visible:=False;
iForm.BorderStyle:=bsSingle;
iForm.BorderIcons:=[biSystemMenu];
iForm.Tag:=cpscSplash;
{iFont}
iFont:=TFont.Create;
iFont.Name:='Arial';
iFont.Size:=7;
iFont.Style:=[fsBold];
iFont.Color:=clWhite;
iX:=7;
iY:=iX;
{iImage}
iImage:=TImage.Create(iForm);
iImage.Parent:=iForm;
iImage.Left:=0;
iImage.Top:=0;
iImage.Transparent:=False;
iImage.Stretch:=False;
iImage.AutoSize:=True;
iImage.Visible:=True;
{iLabels & Titles}
For P:=Low(iLabels) to High(iLabels) Do
begin
//iLabels
iLabels[P]:=TLabel.Create(iForm);
iLabels[P].Parent:=iForm;
iLabels[P].Transparent:=True;
iLabels[P].AutoSize:=True;
iLabels[P].Alignment:=taLeftJustify;
iLabels[P].Caption:='';
iLabels[P].Visible:=True;
iLabels[P].Tag:=P;
iLabels[P].OnClick:=OnClick;
//iTitles
iTitles[P]:=TLabel.Create(iForm);
iTitles[P].Parent:=iLabels[P].Parent;
iTitles[P].Transparent:=iLabels[P].Transparent;
iTitles[P].AutoSize:=iLabels[P].AutoSize;
iTitles[P].Alignment:=iLabels[P].Alignment;
iTitles[P].Caption:=iLabels[P].Caption;
iTitles[P].Visible:=iLabels[P].Visible;
iTitles[P].Tag:=iLabels[P].Tag;
iTitles[P].OnClick:=iLabels[P].OnClick;
end;//end of loop
end;
//## Year ##
Function TCompactSplash.Year(Min:Integer):Integer;
Var
   Yr,Mn,Dy:Word;
begin
try
DecodeDate(Now,Yr,Mn,Dy);
If (Yr<Min) then Yr:=Min;
{Return Result}
Result:=Yr;
except;end;
end;
//## DoOnShow ##
Procedure TCompactSplash.DoOnShow;
begin
try;If Assigned(FOnShow) then FOnShow(Self);except;end;
end;
//## OnClick ##
Procedure TCompactSplash.OnClick(Sender:TObject);
begin
try
If (Sender=iLabels[cpscWeb]) then
   begin
   {Busy}
   If (iLabels[cpscWeb].Font.Color<>iFont.Color) then exit;
   {Run Link}
   Screen.Cursor:=crAppStart;
   iLabels[cpscWeb].Font.Color:=clRed;
   Application.ProcessMessages;
   Run(iLabels[cpscWeb].Caption,'');
   end;//end of if
except;end;
try
Screen.Cursor:=crDefault;
iLabels[cpscWeb].Font.Color:=iFont.Color;
except;end;
end;
//## Splash ##
Procedure TCompactSplash.Splash;
begin
try;ShowForm(cpscSplash);except;end;
end;
//## About ##
Procedure TCompactSplash.About;
begin
try;ShowForm(cpscAbout);except;end;
end;
//## ShowForm ##
Procedure TCompactSplash.ShowForm(X:Integer);
Var
   rX,rY,P,H,W:Integer;
begin
try
If Not iNewVersion then General.ShowError(ECap('5ùø<9÷6:ÅçïöáÉ³<H9÷0úòòF/(´ðùúæ+<µ84øŒ£ÙÍ¥Î“a{×ÔÍÔ¢¡ ‰æÚ­‰™¤åÐÒžÒÖáÑÊ',False));
{DoOnShow}
DoOnShow;
{Show Mode}
ishowing:=true;
iForm.Tag:=FrcRange(X,0,cpscShowMax);
{Image}
W:=iImage.Picture.Width;
H:=iImage.Picture.Height;
{Size Form}
Case X of
cpscSplash:begin
    iForm.BorderIcons:=[];
    iForm.BorderStyle:=bsNone;
    iForm.OnKeyDown:=nil;
    end;//end of begin
cpscAbout:begin
    iForm.Caption:=Translate(ECap(';3<;7BG6ÃÂ·ó"üò¹ù1ô8íõ4ñ;EøãÞÃêÆô?öµ÷ð6î:ï3÷¦ËÛßã—',False))+ECap(iName,False);//Translate('About ')
    iForm.BorderIcons:=[biSystemMenu];
    iForm.BorderStyle:=bsSingle;
    iForm.OnKeyDown:=iForm_OnKey;
    end;//end of begin
end;//end of case
iForm.ClientWidth:=W;
iForm.ClientHeight:=H;
{Titles}
Case iShowName of
True:iTitles[cpscName].Caption:=ECap(iName,False);
False:iTitles[cpscName].Caption:='';
end;//end of case
iTitles[cpscLic].Caption:='License: ';//was: Translate(ECap('ôñô@8?íÅô¿î!€•–ØÓâ™˜ˆÌ§',False))+': ';//Translate('Licensed To')
iTitles[cpscVer].Caption:=Translate(ECap('=òþùøõCòìÀÆÀ¾Ù;²÷<íòí?ýíú/8¶õîÇéå<²ðòËAôùæ@<Êíˆžª¬™â§',False))+': ';//Translate('Version')
iTitles[cpscCopy].Caption:='Copyright: ';//was: ECap(iCopyRight,False);
iTitles[cpscWeb].Caption:='Web: ';//was: Translate(ECap('3ìý:(7ö?ÂùùÀ¿Iò¹ýõðïíúù?06<í¼Âööæ1õû5u¦ßÀÖ¢Ý¥',False))+': ';//Translate('Internet')
{Labels}
iLabels[cpscName].Caption:=' ';
iLabels[cpscLic].Caption:='MIT';//was: ECap(iLicensedTo,False);
iLabels[cpscVer].Caption:=ECap(iVersion,False);
iLabels[cpscCopy].Caption:=low__yearstr(2025)+' Blaiz Enterprises';
iLabels[cpscWeb].Caption:='https://www.blaizenterprises.com';//was: ECap(iWeb,False);
For P:=Low(iLabels) to High(iLabels) Do
begin
iLabels[P].Visible:=(iLabels[P].Caption<>'') and (iTitles[P].Caption<>'');
iLabels[P].Font.Assign(iFont);
iTitles[P].Font.Assign(iFont);
iTitles[P].Visible:=iLabels[P].Visible;
If (P=cpscWeb) then
   begin
   iLabels[P].Font.Style:=iLabels[P].Font.Style+[fsUnderline];
   iLabels[P].Cursor:=crHandPoint;
   end;//end of if
end;//end of loop
{Position Labels}
rX:=iX;
rY:=iForm.ClientHeight-iY;
For P:=High(iLabels) downTo Low(iLabels) Do
begin
If iLabels[P].Visible then
   begin
   //rY
   rY:=rY-iLabels[P].Height;
   //Title
   iTitles[P].Left:=rX;
   iTitles[P].Top:=rY;
   //Label
   iLabels[P].Left:=iTitles[P].Left+iTitles[P].Width;
   iLabels[P].Top:=iTitles[P].Top;
   end;//end of if
end;//end of loop
{Center Form}
General.CenterControl(iForm);
{PrePaint}
iForm.Canvas.Draw(0,0,iImage.Picture.Graphic);
{Show}
Case iForm.Tag of
cpscSplash:iForm.Show;
cpscAbout:iForm.ShowModal;
end;//end of case
{Update System}
Application.ProcessMessages;
except;end;
end;
//## hide ##
procedure TCompactSplash.hide(xsec:longint);//01jun2020
   //## xpause ##
   procedure xpause;
   label
      redo;
   var
      p:longint;
   begin
   //pause
   p:=getcurrenttime;
   Xsec:=FrcRange(Xsec,0,10)*1000;
   If (Xsec<>0) then
      begin
      ReDo:
      Application.ProcessMessages;
      Sleep(50);
      If ((GetCurrentTime-P)<=Xsec) then Goto ReDo;
      end;
   end;
begin
try
//check
if ishowing then ishowing:=false else exit;
//pause
xpause;
//hide
case iForm.Tag of
cpscSplash:iForm.Hide;
cpscAbout:iForm.ModalResult:=mrCancel;
end;//case
except;end;
end;
//## iForm_OnKey ##
Procedure TCompactSplash.iForm_OnKey(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
try;If (Key=27) then Hide(0);except;end;
end;
//## Disassociate ##
Procedure TCompactSplash.Disassociate;
begin
try
{iForm}
iForm.Parent:=nil;
{PopupMenu}
iForm.PopupMenu:=nil;
{FOnShow}
FOnShow:=nil;
except;end;
end;
//## Free ##
Procedure TCompactSplash.Free;
begin
try
If (Self<>nil) then
   begin
   {Disassociate}
   Disassociate;
   {iForm}
   iForm.Free;
   {iFont}
   iFont.Free;
   {Self}
   Self.Destroy;
   end;//end of if
except;end;
end;

end.
