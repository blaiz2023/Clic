unit Clic3;
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
//## Name: TClic
//## Type: TComponent
//## Description: Clipboard to Icon Conversion Component
//## Version: 1.00.223
//## Date: 27/10/2002
//## Lines: 1309
//## Language Enabled
//## Blaiz Enterprises (c) 1997-2002
//##############################################################################

interface

uses
  Forms, Windows, SysUtils, Classes, Graphics, Clipbrd, Dialogs,
  Controls, StdCtrls, ExtCtrls, Clic2, Clic5, Clic8, Clic9, Clic10, clic11;

{TClicStyle}
Type
    TClicStyle=Record
    Icon:TIconStyle;
    GreyScale:Boolean;
    end;

{TClic}
Type
    TClic=Class
    Private
     iFineCap:Boolean;
     iForm:TForm;
     iPaintBusy:Boolean;
     iCurInt:Boolean;
     iCurX,iCurY,iLastMX,iLastMY,iLastX,iLastY:Integer;
     iStyle:TClicStyle;
     iToggleColor:Boolean;
     iLViewerLabel:TLabel;
     iLViewer:TForm;
     iSViewerLabel:TLabel;
     iSViewer:TForm;
     iDetailsLabel:TLabel;
     iDetails:TStaticText;
     iColorBox:TPanel;
     iViewerImage:TBitmap;
     iCapturing:Boolean;
     iSaved:Boolean;
     iA,iB:TImagePixels;
     iBitmap:TBitmap;
     iSize:Integer;
     iCanSave:Boolean;
     iFileName:String;
     iColorIcon:TColorIcon;
     {Undo}
     iUndoImage:TBitmap;
     iUndoStyle:TClicStyle;
     iErrorMessage:String;
     iTransBusy,iMouseDown,iPaintChoke:Boolean;
     iTimer:TTimer;
     iStatusTextTimeIndex:Integer;
     iStatus:String;
     FOnStatus,FOnChange:TNotifyEvent;
     Function _SaveToFile(X:String):Boolean;
     Function SettingsFileName:String;
     Function GetColors:Integer;
     Function GetImage:TBitmap;
     Procedure GreyShade(Var X:TColor24);
     Procedure _OnResize(Sender:TObject);
     Procedure UpdateDetails;
     Procedure _OnPaint(Sender:TObject);
     Procedure Repaint;
     Function ZoomIndex:Integer;
     Procedure iForm_OnTimer(Sender: TObject);
     Procedure DoBorder;
     procedure iForm_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     procedure iForm_OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
     procedure iForm_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     Procedure DoTrans(X,Y:Integer);
     Function TransparentCoor(X,Y:Integer):Boolean;
     Function TransText(Var X,Y:Integer):Boolean;
     Procedure SetStatus(X:String);
     Procedure ScaleXY(Sender:TObject;Var X,Y:Integer);
     Procedure _SetStyle(Var X:TClicStyle);
     Procedure SetStyle(X:TClicStyle);
     Function GetStyle:TClicStyle;
     Procedure UpdateImage;
     Procedure DoOnChange;
     Procedure CopyFrom(X:TGraphic;Y:TClicStyle;Sizeable:Boolean);
     Procedure StyleRepaint;
     Procedure SetFineCap(X:Boolean);
    Public
     {Create}
     Constructor Create;
     {Form}
     Property Form:TForm Read iForm;
     {Save}
     Property CanSave:Boolean Read iCanSave;
     Property Saved:Boolean Read iSaved;
     Function Save:Boolean;
     Function SaveToFile(X:String):Boolean;
     Function SaveToStream(X:TStream):Boolean;
     Property FileName:String Read iFileName;
     Function Name:String;
     {Edit}
     Function Undo:Boolean;
     Function UpdateUndo:Boolean;
     Procedure New;
     Function Capture(Finish,Fine:Boolean):Boolean;
     Property FineCap:Boolean Read iFineCap Write SetFineCap;
     Function CanPaste:Boolean;
     Function Paste:Boolean;
     Function PasteAll:Boolean;
     function pastein(xdata:string):boolean;//05jun2020
     Function Copy:Boolean;
     Function Clear:Boolean;
     Function FlipMirror(Z:Boolean):Boolean;
     Function RotateBy(X:Integer):Boolean;
     Function Inverse:Boolean;
     {Properties}
     Property Style:TClicStyle Read GetStyle Write SetStyle;
     Function Assign(Sender:TObject;Sizeable:Boolean):Boolean;
     Property Icon:TColorIcon Read iColorIcon;
     Property Image:TBitmap Read iBitmap;{Internal Use Only}
     Property Colors:Integer Read GetColors;
     Property Size:Integer Read iSize;
     Property Status:String Read iStatus Write SetStatus;
     Property Capturing:Boolean Read iCapturing;
     {Events}
     Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
     Property OnStatus:TNotifyEvent Read FOnStatus Write FOnStatus;
     {Error}
     Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
     Procedure ShowError;
     {Free}
     Procedure Disassociate;
     Procedure Free;
    end;

implementation

//## Create ##
Constructor TClic.Create;
Var
   A:TClicStyle;
begin
iFineCap:=False;
iCurInt:=True;
iLastMX:=0;
iLastMY:=0;
{iToggleColor}
iPaintBusy:=False;
iStatus:='';
iToggleColor:=False;
iPaintChoke:=False;
iCapturing:=False;
iMouseDown:=False;
iTransBusy:=False;
{iForm}
iForm:=TForm.Create(nil);
iForm.Parent:=nil;
iForm.Caption:='';
iForm.BorderIcons:=[];
iForm.BorderStyle:=bsNone;
iForm.VertScrollBar.Visible:=False;
iForm.HorzScrollBar.Visible:=False;
iForm.ClientWidth:=300;
iForm.ClientHeight:=300;
{iLViewerLabel}
iLViewerLabel:=TLabel.Create(iForm);
iLViewerLabel.Parent:=iForm;
iLViewerLabel.Caption:=Translate('Enlarged View');
iLViewerLabel.Transparent:=True;
iLViewerLabel.Visible:=True;
{iLViewer}
iLViewer:=TForm.Create(iForm);
iLViewer.Parent:=iForm;
iLViewer.Caption:='';
iLViewer.BorderIcons:=[];
iLViewer.BorderStyle:=bsNone;
iLViewer.VertScrollBar.Visible:=False;
iLViewer.HorzScrollBar.Visible:=False;
iLViewer.Cursor:=crCross;
iLViewer.Visible:=True;
{iSViewerLabel}
iSViewerLabel:=TLabel.Create(iForm);
iSViewerLabel.Parent:=iForm;
iSViewerLabel.Caption:=Translate('Actual Size');
iSViewerLabel.Transparent:=True;
iSViewerLabel.Visible:=True;
{iSViewer}
iSViewer:=TForm.Create(iForm);
iSViewer.Parent:=iForm;
iSViewer.Caption:='';
iSViewer.BorderIcons:=[];
iSViewer.BorderStyle:=bsNone;
iSViewer.VertScrollBar.Visible:=False;
iSViewer.HorzScrollBar.Visible:=False;
iSViewer.Cursor:=iLViewer.Cursor;
iSViewer.Visible:=True;
{iDetailsLabel}
iDetailsLabel:=TLabel.Create(iForm);
iDetailsLabel.Parent:=iForm;
iDetailsLabel.Caption:=Translate('Icon Details');
iDetailsLabel.Transparent:=True;
iDetailsLabel.Visible:=True;
{iDetails}
iDetails:=TStaticText.Create(iForm);
iDetails.Parent:=iForm;
iDetails.BorderStyle:=sbsSunken;
iDetails.Alignment:=taLeftJustify;
iDetails.AutoSize:=False;
iDetails.Width:=200;//made wider - 07mar2020, was: 150
iDetails.Visible:=True;
{iColorBox}
iColorBox:=TPanel.Create(iForm);
iColorBox.Parent:=iDetails;
iColorBox.BevelInner:=bvNone;
iColorBox.BevelOuter:=bvLowered;
iColorBox.BorderStyle:=bsNone;
iColorBox.Width:=60;
iColorBox.Height:=12;
iColorBox.Visible:=False;
{iViewerImage}
iViewerImage:=TBitmap.Create;
iViewerImage.PixelFormat:=pf24bit;
{iTimer}
iTimer:=TTimer.Create(iForm);
iTimer.Interval:=100;
iTimer.Enabled:=True;
{iColorIcon}
iColorIcon:=TColorIcon.Create;
{iA & iB}
iA:=TImagePixels.Create;
iB:=TImagePixels.Create;
{iBitmap}
iBitmap:=TBitmap.Create;
iBitmap.PixelFormat:=pf24bit;
{iUndoImage}
iUndoImage:=TBitmap.Create;
iUndoImage.PixelFormat:=pf24bit;
{Events}
//iForm
iForm.OnResize:=_OnResize;
//iLViewer
iLViewer.OnPaint:=_OnPaint;
iLViewer.OnMouseDown:=iForm_OnMouseDown;
iLViewer.OnMouseMove:=iForm_OnMouseMove;
iLViewer.OnMouseUp:=iForm_OnMouseUp;
//iSViewer
iSViewer.OnPaint:=_OnPaint;
iSViewer.OnMouseDown:=iForm_OnMouseDown;
iSViewer.OnMouseMove:=iForm_OnMouseMove;
iSViewer.OnMouseUp:=iForm_OnMouseUp;
{iStatusTextTimeIndex}
iStatusTextTimeIndex:=GetCurrentTime;
{iTimer}
iTimer.OnTimer:=iForm_OnTimer;
{Defaults}
A:=Style;
A.Icon.Width:=32;
A.Icon.Height:=32;
A.Icon.Transparent:=False;
A.Icon.TransparentX:=0;
A.Icon.TransparentY:=0;
A.GreyScale:=False;
iSize:=0;
{New}
New;
Style:=A;
{iErrorMessage}
iErrorMessage:='';
end;
//## UpdateImage ##
Procedure TClic.UpdateImage;
Var
   Row:PRGBColorRow;
   rX,rY,MaxX,MaxY:Integer;
   Z:TColor24;
begin
try
iColorIcon.Assign(iBitmap);
If iStyle.GreyScale then
   begin
   MaxX:=iStyle.Icon.Width-1;
   MaxY:=iStyle.Icon.Height-1;
   For rY:=0 to MaxY Do
   begin
   Row:=iColorIcon.Image.Scanline[rY];
    For rX:=0 to MaxX Do
    begin
    Z:=Row[rX];
    GreyShade(Z);
    Row[rX]:=Z;
    end;//end of loop
   end;//end of loop
   end;//end of if
{BPP}
iStyle.Icon.BPP:=iColorIcon.CountBPP;
{Colors - Update Transparent Color}
iColorIcon.Style:=iStyle.Icon;
iStyle.Icon.TransparentColor:=iColorIcon.Style.TransparentColor;
except;end;
end;
//## UpdateDetails ##
Procedure TClic.UpdateDetails;
Var
   A:TMemoryStream;
   Ct,TransXY,X,Y:String;
   C,rX,rY:Integer;
   T:Boolean;
begin
try
{A}
A:=nil;
A:=TMemoryStream.Create;
{iColorIcon}
SaveToStream(A);
Case iCapturing of
False:begin
     C:=iColorIcon.Colors;
     iStyle.Icon.Colors:=C;
     Ct:=IntToStr(C);
     end;//end of begin
True:begin
     C:=0;
     Ct:='-';
     end;//end of case
end;//end of case
{Details}
TransXY:=IntToStr(iStyle.Icon.TransparentX)+','+IntToStr(iStyle.Icon.TransparentY);
X:='';
If (C<=1) then Y:='' else Y:='s';
X:=X+Translate('Color')+Y+':'+#9+#9+Ct+RCode;
X:=X+Translate('Bits')+':'+#9+#9+inttostr(iStyle.Icon.BPP)+RCode;
X:=X+Translate('Bytes')+':'+#9+#9+inttostr(Size)+RCode;
If iStyle.GreyScale then Y:=Translate('Yes') else Y:=Translate('No');
X:=X+Translate('Greyscale')+':'+#9+Y+RCode;
T:=iStyle.Icon.Transparent;
Case T of
True:Y:=Translate('Yes');
False:Y:=Translate('No');
end;
X:=X+Translate('Transparent')+':'+#9+Y+RCode;
If Not T then Y:='-' else Y:=TransXY;
X:=X+'.. '+Translate('pixel')+#9+#9+Y+RCode;
If Not T then Y:='-' else Y:=IntToStr(iStyle.Icon.TransparentColor.R)+','+IntToStr(iStyle.Icon.TransparentColor.G)+','+IntToStr(iStyle.Icon.TransparentColor.B);
X:=X+'.. '+Translate('color')+#9+#9+Y+RCode+RCode;
{iColorBox}
iColorBox.Color:=RGBtoInt(iStyle.Icon.TransparentColor);
X:=X+Translate('Dimensions')+':'+#9+inttostr(iStyle.Icon.Width)+'w x '+inttostr(iStyle.Icon.Height)+'h'+RCode;
{Transparent Message}
If iStyle.Icon.Transparent then
   begin
   X:=X+RCode+Translate('Current transparency calculated by pixel')+' '+TransXY+'.'+RCode+Translate('Transparent pixels flash white and silver')+'.';
   end;//end of if
{iDetails}
iDetails.Caption:=X;
{iColorBox}
If (iColorBox.Visible<>T) then iColorBox.Visible:=T;
iColorBox.Refresh;
except;end;
try;If (A<>nil) then A.Free;except;end;
end;
//## DoOnChange ##
Procedure TClic.DoOnChange;
begin
try;If Assigned(FOnChange) then FOnChange(Self);except;end;
end;
//## GetStyle ##
Function TClic.GetStyle:TClicStyle;
begin
try;Result:=iStyle;except;end;
end;
//## SetStyle ##
Procedure TClic.SetStyle(X:TClicStyle);
begin
try
iPaintBusy:=True;
{UpdateUndo}
UpdateUndo;
{_SetStyle}
_SetStyle(X);
{StyleRepaint}
StyleRepaint;
except;end;
try;iPaintBusy:=False;except;end;
end;
//## StyleRepaint ##
Procedure TClic.StyleRepaint;
begin
try
{UpdateImage}
UpdateImage;
{UpdateDetails}
UpdateDetails;
{Resize}
_OnResize(Self);
{Repaint}
Repaint;
{iSaved}
iSaved:=False;
{DoOnChange}
DoOnChange;
except;end;
end;
//## _SetStyle ##
Procedure TClic._SetStyle(Var X:TClicStyle);
Var
   Y:Integer;
   Z:TIconStyle;
begin
try
{Dimensions}
Y:=FrcRange(X.Icon.Width,0,ihMaxSize);
Case Y of
16,24,32,48,64,72,96:{null};
else
 Y:=32;
end;//end of case
Z:=X.Icon;
Z.Width:=Y;
Z.Height:=Y;
{Reset Color Count}
If (iStyle.GreyScale<>X.GreyScale) or (Z.Width<>iStyle.Icon.Width) or (Z.Height<>iStyle.Icon.Height) then Z.Colors:=0;
iStyle.Icon:=Z;
{GreyScale}
iStyle.GreyScale:=X.GreyScale;
{iBitmap}
iBitmap.Width:=Z.Width;
iBitmap.Height:=Z.Height;
except;end;
end;
//## Repaint ##
Procedure TClic.Repaint;
Var
   RowA,RowB:PRGBColorRow;
   A:TBitmap;
   rX,rY,MaxX,MaxY,P,MaxP,aC,bC,Z,dW,dH:Integer;
   X:TForm;
   C,Tc:TColor24;
begin
try
If iPaintBusy then exit;
X:=iLViewer;
{A}
A:=iViewerImage;
A.Width:=iStyle.Icon.Width+2;
A.Height:=iStyle.Icon.Height+2;
{White/Grey Background}
Case iToggleColor of
True:begin
     aC:=clWhite;
     bC:=clSilver;
     end;//end of begin
False:begin
     bC:=clWhite;
     aC:=clSilver;
     end;//end of begin
end;//end of case
//A
A.Canvas.Pen.Color:=aC;
MaxP:=(A.Width+2) Div 2;
For P:=1 to MaxP Do
begin
A.Canvas.MoveTo(P*2,0);
A.Canvas.LineTo(P*2,A.Height);
end;//end of loop
{B}
A.Canvas.Pen.Color:=bC;
For P:=1 to MaxP Do
begin
A.Canvas.MoveTo(P*2-1,0);
A.Canvas.LineTo(P*2-1,A.Height);
end;//end of loop
{DoBorder}
DoBorder;
{Icon}
MaxX:=iStyle.Icon.Width-1;
MaxY:=iStyle.Icon.Height-1;
Tc:=iStyle.Icon.TransparentColor;
For rY:=0 to MaxY Do
begin
RowA:=iColorIcon.Image.Scanline[rY];
RowB:=A.Scanline[1+rY];
 For rX:=0 to MaxX Do
 begin
 Case iStyle.Icon.Transparent of
 False:RowB[1+rX]:=RowA[rX];
 True:begin
     C:=RowA[rX];
     If Not RGBEqual(C,Tc) then RowB[1+rX]:=C;
     end;//end of begin
 end;//end of case
 end;//end of loop
end;//end of loop
{Form}
Case (X=iLViewer) of
True:Z:=ZoomIndex;
False:Z:=1;
end;//end of case
dW:=Z*A.Width;
dH:=Z*A.Height;
{Cls - Form}
X.Canvas.Brush.Color:=X.Color;
X.Canvas.FillRect(Rect(dW,0,X.ClientWidth,X.ClientHeight));
X.Canvas.FillRect(Rect(0,dH,dW,X.ClientHeight));
{Paint}
X.Canvas.StretchDraw(Rect(0,0,dW,dH),A);
{Small}
X:=iSViewer;
dW:=A.Width;
dH:=A.Height;
{Cls - Form}
X.Canvas.Brush.Color:=X.Color;
X.Canvas.FillRect(Rect(dW,0,X.ClientWidth,X.ClientHeight));
X.Canvas.FillRect(Rect(0,dH,dW,X.ClientHeight));
{Paint}
X.Canvas.Draw(0,0,A);
except;end;
end;
//## DoBorder ##
Procedure TClic.DoBorder;
begin
try
iViewerImage.Canvas.Brush.Color:=clRed;
iViewerImage.Canvas.FrameRect(Rect(0,0,iViewerImage.Width,iViewerImage.Height));
except;end;
end;
//## ZoomIndex ##
Function TClic.ZoomIndex:Integer;
Var
   A,B:Integer;
begin
try
A:=iLViewer.ClientWidth Div (iStyle.Icon.Width+2);
B:=iLViewer.ClientHeight Div (iStyle.Icon.Height+2);
If (B<A) then A:=B;
If (A<1) then A:=1;
{Return Result}
Result:=A;
except;end;
end;
//## _OnPaint ##
Procedure TClic._OnPaint(Sender:TObject);
Var
   A:TBitmap;
   Z,dW,dH:Integer;
begin
try
If (Sender=iLViewer) then
   begin
   A:=iViewerImage;
   Z:=ZoomIndex;
   dW:=Z*A.Width;
   dH:=Z*A.Height;
   iLViewer.Canvas.StretchDraw(Rect(0,0,dW,dH),A);
   end
else If (Sender=iSViewer) then
   begin
   A:=iViewerImage;
   dW:=A.Width;
   dH:=A.Height;
   iSViewer.Canvas.StretchDraw(Rect(0,0,dW,dH),A);
   end;//end of if
except;end;
end;
//## _OnResize ##
Procedure TClic._OnResize(Sender:TObject);
Const
     hSpace=5;
Var
   th,X,Y,W,H:longint;
   a:tbitmap;
begin
try
//defaults
a:=nil;
{iLViewerLabel}
X:=hSpace;
Y:=hSpace;
W:=iLViewerLabel.Width;
H:=iLViewerLabel.Height;
iLViewerLabel.SetBounds(X,Y,W,H);
{iSViewerLabel}
X:=iForm.ClientWidth-iDetails.Width-hSpace;
Y:=iLViewerLabel.Top;
W:=iSViewerLabel.Width;
H:=iSViewerLabel.Height;
iSViewerLabel.SetBounds(X,Y,W,H);
{iLViewer}
X:=iLViewerLabel.Left;
Y:=iLViewerLabel.Top+iLViewerLabel.Height+2;
H:=iForm.ClientHeight-Y-hSpace;
W:=iSViewerLabel.Left-hSpace-X;
iLViewer.SetBounds(X,Y,W,H);
iLViewerLabel.Caption:=Translate('Enlarged View ')+inttostr(ZoomIndex*100)+'%';
{iSViewer}
X:=iSViewerLabel.Left;
Y:=iSViewerLabel.Top+iSViewerLabel.Height+2;
H:=iStyle.Icon.Height+2;
W:=iStyle.Icon.Width+2;
iSViewer.SetBounds(X,Y,W,H);
{iDetailsLabel}
X:=iSViewerLabel.Left;
Y:=iSViewer.Top+iSViewer.Height+hSpace;
W:=iDetailsLabel.Width;
H:=iDetailsLabel.Height;
iDetailsLabel.SetBounds(X,Y,W,H);
{iDetails}
X:=iDetailsLabel.Left;
Y:=iDetailsLabel.Top+iDetailsLabel.Height+2;
W:=iDetails.Width;
H:=iForm.ClientHeight-Y-hSpace;
iDetails.SetBounds(X,Y,W,H);
{iColorBox}
a:=tbitmap.create;
a.width:=1;
a.height:=1;
a.pixelformat:=pf24bit;
a.canvas.font.assign(idetails.font);
th:=a.canvas.textheight('afklj23q#$5kjaaaa#W');
//was: iColorBox.SetBounds(81,91,iColorBox.Width,iColorBox.Height);
iColorBox.SetBounds(5,7*th,iColorBox.Width,iColorBox.Height);
except;end;
try;freeobj(@a);except;end;
end;
//## GetImage ##
Function TClic.GetImage:TBitmap;
begin
try;Result:=iColorIcon.Image;except;end;
end;
//## GetColors ##
Function TClic.GetColors:Integer;
begin
try;Result:=iColorIcon.Colors;except;end;
end;
//## Undo ##
Function TClic.Undo:Boolean;
Var
   A:TBitmap;
   Astyle:TClicStyle;
   Bstyle:TIconStyle;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
iPaintBusy:=True;
A:=nil;
iSaved:=False;
//#1
A:=TBitmap.Create;
A.PixelFormat:=pf24bit;
A.Width:=iBitmap.Width;
A.Height:=iBitmap.Height;
A.Canvas.Draw(0,0,iBitmap);
Astyle:=iStyle;
//#2
iStyle:=iUndoStyle;
Assign(iUndoImage,True);
iPaintBusy:=False;
//#3
iUndoImage.Width:=A.Width;
iUndoImage.Height:=A.Height;
iUndoImage.Canvas.Draw(0,0,A);
iUndoStyle:=Astyle;
{Successful}
Result:=True;
except;end;
try;If (A<>nil) then A.Free;except;end;
try;iPaintBusy:=False;except;end;
end;
//## UpdateUndo ##
Function TClic.UpdateUndo:Boolean;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
{Undo}
iUndoImage.Width:=iBitmap.Width;
iUndoImage.Height:=iBitmap.Height;
iUndoImage.Canvas.Draw(0,0,iBitmap);
iUndoStyle:=iStyle;
{Successful}
Result:=True;
except;end;
end;
//## New ##
Procedure TClic.New;
begin
try
Clear;
iFileName:='Untitled.ico';
iCanSave:=False;
iSaved:=True;
except;end;
end;
//## SaveToStream ##
Function TClic.SaveToStream(X:TStream):Boolean;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
{BPP}
iColorIcon.BPP:=iStyle.Icon.BPP;
{SaveToStream}
iColorIcon.SaveToStream(X);
{Successful}
Result:=True;
iSize:=X.Size;
except;end;
try;iErrorMessage:=iColorIcon.ErrorMessage;except;end;
end;
//## GreyShade ##
Procedure TClic.GreyShade(Var X:TColor24);
Var
   C:Byte;
begin
try
C:=X.R;
If (X.G>C) then C:=X.G;
If (X.B>C) then C:=X.B;
{Return Result}
X:=RGBColor(C,C,C);
except;end;
end;
//## Free ##
Procedure TClic.Free;
begin
try
If (Self<>Nil) then
   begin
   {Disassociate}
   Disassociate;
   {iColorIcon}
   iColorIcon.Free;
   {iBitmap}
   iBitmap.Free;
   {iUndoImage}
   iUndoImage.Free;
   {iA&iB}
   iA.Free;
   iB.Free;
   {iViewerImage}
   iViewerImage.Free;
   {Self}
   Self.Destroy;
   end;//end of if
except;end;
end;
//## Save ##
Function TClic.Save:Boolean;
begin
try
Result:=True;
If Not CanSave then exit;
Result:=SaveToFile(iFileName);
except;end;
end;
//## SaveToFile ##
Function TClic.SaveToFile(X:String):Boolean;
begin
try
{Error}
Result:=False;
{SaveToFile}
If _SaveToFile(X) then
   begin
   {Successful}
   Result:=True;
   {Other}
   iCanSave:=True;
   iFileName:=X;
   iSaved:=True;
   end;//end of if
except;end;
end;
//## _SaveToFile ##
Function TClic._SaveToFile(X:String):Boolean;
Label
     SkipEnd;
Var
   A:TMemoryStream;
begin
try
{Error}
Result:=False;
A:=TMemoryStream.Create;
If Not SaveToStream(A) then Goto SkipEnd;
{RemoveFile}
iErrorMessage:=gecFileInUse;
If Not Paths.RemFile(X) then Goto SkipEnd;
{Save}
iErrorMessage:=gecOutOfDiskSpace;
A.SaveToFile(X);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## Name ##
Function TClic.Name:String;
begin
try;Result:=ExtractFileName(iFileName);except;end;
end;
//## CopyFrom ##
Procedure TClic.CopyFrom(X:TGraphic;Y:TClicStyle;Sizeable:Boolean);
Var
   OldT:Boolean;
   A:TClicStyle;
begin
try
If (X=nil) then exit;
{Remember Transparent}
OldT:=X.Transparent;
X.Transparent:=False;
{Style}
A:=Style;
A.Icon.Colors:=0;
If Sizeable then
   begin
   A.Icon.Width:=X.Width;
   A.Icon.Height:=X.Height;
   end;//end of if
_SetStyle(A);
{Cls}
iBitmap.Canvas.Brush.Color:=clWhite;
iBitmap.Canvas.FillRect(Rect(0,0,iBitmap.Width,iBitmap.Height));
{Paint}
iBitmap.Canvas.Draw(0,0,X);
except;end;
try
X.Transparent:=OldT;
{StyleRepaint}
StyleRepaint;
except;end;
end;
//## Assign ##
Function TClic.Assign(Sender:TObject;Sizeable:Boolean):Boolean;
Var
   A:TBitmap;
   E:String;
begin
try
{No}
Result:=False;
E:=gecUnsupportedFormat;
A:=nil;
{Clic}
If (Sender is TClic) then CopyFrom((Sender as TClic).Image,(Sender as TClic).Style,True)
{Clipboard}
else If (Sender is TClipboard) then
   begin
   E:=gecTaskFailed;
   If ((Sender as TClipboard).HasFormat(CF_Bitmap)) or ((Sender as TClipboard).HasFormat(CF_PICTURE)) or ((Sender as TClipboard).HasFormat(CF_METAFILEPICT)) then
      begin
      A:=TBitmap.Create;
      A.Assign((Sender as TClipboard));
      CopyFrom(A,Style,Sizeable);
      Result:=True;
      end;//end of if
   end
{TGraphic}
else If (Sender is TGraphic) then
   begin
   CopyFrom(Sender as TGraphic,Style,Sizeable);
   Result:=True;
   end;//end of if
except;iErrorMessage:=E;end;
try;If (A<>nil) then A.Free;except;end;
end;
//## ShowError ##
Procedure TClic.ShowError;
begin
try;MessageDlg(iErrorMessage,MtError,[MbOk],0);except;end;
end;
//## CanPaste ##
Function TClic.CanPaste:Boolean;
begin
try;Result:=Clipboard.HasFormat(CF_BITMAP) or Clipboard.HasFormat(CF_METAFILEPICT) or Clipboard.HasFormat(CF_PICTURE);except;end;
end;
//## Paste ##
Function TClic.Paste:Boolean;
begin
try
iErrorMessage:=gecOutOfMemory;
{UpdateUndo}
UpdateUndo;
{Assign}
Result:=Assign(Clipboard,False);
except;end;
end;
//## PasteAll ##
Function TClic.PasteAll:Boolean;
Var
   B,A:TBitmap;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
A:=nil;
B:=nil;
A:=low__newbmp24;
B:=low__newbmp24;
A.Assign(Clipboard);
B.Width:=iStyle.Icon.Width;
B.Height:=iStyle.Icon.Height;
B.Canvas.StretchDraw(Rect(0,0,B.Width,B.Height),A);
{UpdateUndo}
UpdateUndo;
{Assign}
Result:=Assign(B,False);
except;end;
try
freeobj(@a);
freeobj(@b);
except;end;
end;
//## pastein ##
function tclic.pastein(xdata:string):boolean;
label
   skipend;
var
   B,A:TBitmap;
   xformat:string;
   xbase64:boolean;
begin
try
//defaults
result:=false;
ierrormessage:=gecUnknownformat;
a:=nil;
b:=nil;
//check
if (xdata='') then exit;
if not low__findimgformat(xdata,xformat,xbase64) then goto skipend;
//get
a:=low__newbmp24;
b:=low__newbmp24;
if not low__fromimgdata(a,xformat,xdata,ierrormessage) then goto skipend;
B.Width:=iStyle.Icon.Width;
B.Height:=iStyle.Icon.Height;
B.Canvas.StretchDraw(Rect(0,0,B.Width,B.Height),A);
{UpdateUndo}
UpdateUndo;
{Assign}
Result:=Assign(B,False);
skipend:
except;end;
try
freeobj(@a);
freeobj(@b);
except;end;
end;
//## Clear ##
Function TClic.Clear:Boolean;
Var
   A:TBitmap;
begin
try
{Error}
iErrorMessage:=gecOutOfMemory;
A:=nil;
Result:=False;
A:=TBitmap.Create;
A.Width:=iStyle.Icon.Width;
A.Height:=A.Width;
{UpdateUndo}
UpdateUndo;
{Clear}
Result:=Assign(A,False);
except;end;
try;If (A<>nil) then A.Free;except;end;
end;
{//was:
//## Capture ##
Function TClic.Capture(Finish,Fine:Boolean):Boolean;
Var
   XY:TPoint;
   A:TBitmap;
   oX,oY,X,Y:Integer;
   Z:TForm;
begin
try
//Error
Result:=True;
Z:=nil;
A:=nil;
If Finish then
   begin
   UpdateDetails;
   iCurInt:=True;
   exit;
   end;//end of if
If iCapturing then exit;
iCapturing:=True;
Result:=False;
iCapturing:=True;
oX:=iStyle.Icon.Width Div 2;
oY:=iStyle.Icon.Height Div 2;
//Z
Z:=TForm.Create(nil);
Z.Parent:=nil;
Z.Visible:=False;
Z.BorderStyle:=bsNone;
Z.SetBounds(0,0,Screen.Width,Screen.Height);
A:=TBitmap.Create;
A.PixelFormat:=pf24bit;
A.Width:=iStyle.Icon.Width;
A.Height:=iStyle.Icon.Height;
GetCursorPos(XY);
//iCurInt
If Fine then
   begin
   If iCurInt then
      begin
      iCurX:=XY.X;
      iCurY:=XY.Y;
      iCurInt:=False;
      end;//end of if
   XY.X:=iCurX+((XY.X-iCurX) Div 5);
   XY.Y:=iCurY+((XY.Y-iCurY) Div 5);
   end;//end of if
X:=FrcRange(XY.X-oX,0,Z.Width-A.Width);
Y:=FrcRange(XY.Y-oY,0,Z.Height-A.Height);
//Paint Current Screen Section
Z.Canvas.FillRect(Rect(0,0,Z.Width,Z.Height));
A.Canvas.CopyRect(Rect(0,0,A.Width,A.Height),Z.Canvas,Rect(X,Y,X+A.Width,Y+A.Height));
//Return Result
Result:=Assign(A,False);
except;end;
try
Z.Free;
A.Free;
iCapturing:=False;
except;end;
end;
{}
//## Capture ##
function TClic.capture(Finish,Fine:Boolean):Boolean;
var
   a:tbitmap;
   b:tpoint;
   dw,dh:longint;
begin
try
//defaults
result:=true;
a:=nil;
if finish then
   begin
   updatedetails;
   icurint:=true;
   exit;
   end;
//check
if icapturing then exit else icapturing:=true;
result:=false;
dw:=istyle.icon.width;
dh:=istyle.icon.height;
//get
getcursorpos(b);
a:=tbitmap.create;
a.pixelformat:=pf24bit;
//icurint
if fine then
   begin
   if icurint then
      begin
      icurx:=b.x;
      icury:=b.y;
      icurint:=false;
      end;//end of if
   b.x:=icurx+((b.x-icurx) div 5);
   b.y:=icury+((b.y-icury) div 5);
   end;//end of if
if low__cap2432(b.x-(dw div 2),b.y-(dh div 2),dw,dh,a) then result:=assign(a,false);
except;end;
try
freeobj(@a);
icapturing:=false;
except;end;
end;
//## Copy ##
Function TClic.Copy:Boolean;
Label
     SkipEnd;{Dual Copy MSClipboard[Bitmap]/FileClipboard[Icon]}
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
Clipboard.Assign(iColorIcon.Image);
{FileClipboard Copy}
If Not _SaveToFile(ClipFile('ICO')) then Goto SkipEnd;
{Successful}
iErrorMessage:='';
Result:=True;
SkipEnd:
except;end;
end;
//## Inverse ##
Function TClic.Inverse:Boolean;
Label
     SkipEnd;
Var
   X:TManipulationInfo;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
iPaintBusy:=True;
{Update Undo}
UpdateUndo;
{Process}
iErrorMessage:=gecUnexpectedError;
{Prepare}
iBitmap.PixelFormat:=pf24bit;
X.Image:=iBitmap;
X.Rect:=ImageRect(iBitmap);
X.NonZeroRect:=True;
{Rotate}
If Not Invert(X) then
   begin
   iErrorMessage:=X.ErrMsg;
   exit;
   end;//end of if
{Successful}
Result:=True;
SkipEnd:
except;end;
try;StyleRepaint;iPaintBusy:=False;except;end;
end;
//## Mirror ##
Function TClic.FlipMirror(Z:Boolean):Boolean;
Label
     SkipEnd;
Var
   A:TClicStyle;
   X:TManipulationInfo;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
iPaintBusy:=True;
{Update Undo}
UpdateUndo;
{Process}
iErrorMessage:=gecUnexpectedError;
X.Image:=iBitmap;
X.Rect:=ImageRect(iBitmap);
X.NonZeroRect:=True;
{Flip or Mirror}
Case Z of
False:If not Flip(X) then
         begin
         iErrorMessage:=X.ErrMsg;
         exit;
         end;//end of if
True:If not Mirror(X) then
         begin
         iErrorMessage:=X.ErrMsg;
         exit;
         end;//end of if
end;//end of case
{Style}
A:=iStyle;
Case Z of
False:A.Icon.TransparentY:=(A.Icon.Height-1)-A.Icon.TransparentY;
True:A.Icon.TransparentX:=(A.Icon.Width-1)-A.Icon.TransparentX;
end;//end of case
_SetStyle(A);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;StyleRepaint;iPaintBusy:=False;except;end;
end;
//## RotateBy ##
Function TClic.RotateBy(X:Integer):Boolean;
Label
     SkipEnd;
Var
   A:TClicStyle;
   C,rX,rY,W,H:Integer;
   D:TManipulationInfo;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
iPaintBusy:=True;
{Update Undo}
UpdateUndo;
{Process}
iErrorMessage:=gecUnexpectedError;
{Prepare}
iBitmap.PixelFormat:=pf24bit;
D.Image:=iBitmap;
D.Rect:=ImageRect(iBitmap);
D.NonZeroRect:=True;
{Rotate}
If Not Rotate(D,X) then
   begin
   iErrorMessage:=D.ErrMsg;
   exit;
   end;//end of if
{Style}
A:=iStyle;
rX:=A.Icon.TransparentX;
rY:=A.Icon.TransparentY;
W:=A.Icon.Width-1;
H:=A.Icon.Height-1;
Case X of
-270,90:begin
   C:=rX;
   rX:=W-rY;
   rY:=C;
   end;//end of begin
-180,180:begin
   rX:=W-rX;
   rY:=H-rY;
   end;//end of begin
-90,270:begin
   rX:=W-rX;
   rY:=H-rY;
   C:=rX;
   rX:=W-rY;
   rY:=C;
   end;//end of begin
end;//end of case
A.Icon.TransparentX:=rX;
A.Icon.TransparentY:=rY;
_SetStyle(A);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;StyleRepaint;iPaintBusy:=False;except;end;
end;
//## SettingsFileName ##
Function TClic.SettingsFileName:String;
begin
try;Result:=bvfolder(bvfSettings)+'tclic.ini';except;end;
end;
//## iForm_OnTimer ##
Procedure TClic.iForm_OnTimer(Sender: TObject);
begin
try
If (Not iForm.Visible) then exit;
iTimer.Enabled:=False;
iPaintChoke:=Not iPaintChoke;
{Turn Status Text Off}
If ((GetCurrentTime-iStatusTextTimeIndex)>=2500) then
   begin
   Status:='';
   iStatusTextTimeIndex:=GetCurrentTime;
   end;//end of if
{Update System}
If iPaintChoke then
   begin
   iToggleColor:=Not iToggleColor;
   Repaint;
   end;//end of if
except;end;
try;iTimer.Enabled:=True;except;end;
end;
//## DoTrans ##
Procedure TClic.DoTrans(X,Y:Integer);
Label
     SkipEnd;
Var
   S,W,H:Integer;
begin
try
If iTransBusy then exit;
iTransBusy:=True;
If Not TransparentCoor(X,Y) then Goto SkipEnd;
If (iStyle.Icon.TransparentX=X) and (iStyle.Icon.TransparentY=Y) then Goto SkipEnd;
{UpdateUndo Once Only}
If (iLastX<>-1) and (iLastY<>-1) then If (iLastX<>X) or (iLastY<>Y) or iStyle.Icon.Transparent then
   begin
   {UpdateUndo}
   UpdateUndo;
   {Prevent Other Instances}
   iLastX:=-1;
   iLastY:=-1;
   end;//end of if
{Style}
iStyle.Icon.TransparentX:=X;
iStyle.Icon.TransparentY:=Y;
iStyle.Icon.Transparent:=True;
{_SetStyle}
_SetStyle(iStyle);
{StyleRepaint}
StyleRepaint;
SkipEnd:
{TransText}
TransText(X,Y);
except;end;
try;iTransBusy:=False;except;end;
end;
//## iForm_OnMouseDown ##
procedure TClic.iForm_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
   A:TPoint;
begin
try
Screen.Cursor:=crCross;
iLastX:=iStyle.Icon.TransparentX;
iLastY:=iStyle.Icon.TransparentY;
iMouseDown:=True;
ScaleXY(Sender,X,Y);
DoTrans(X,Y);
except;end;
end;
//## iForm_OnMouseMove ##
procedure TClic.iForm_OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
try
ScaleXY(Sender,X,Y);
Case iMouseDown of
True:DoTrans(X,Y);
False:TransText(X,Y);
end;//end of case
except;end;
end;
//## iForm_OnMouseUp ##
procedure TClic.iForm_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
try
iMouseDown:=False;
Screen.Cursor:=crDefault;
except;end;
end;
//## ScaleXY ##
Procedure TClic.ScaleXY(Sender:TObject;Var X,Y:Integer);
Var
   S:Integer;
begin
try
Case (Sender=iSViewer) of
True:S:=1;
False:S:=ZoomIndex;
end;//end of case
X:=(X Div S)-1;
Y:=(Y Div S)-1;
except;end;
end;
//## TransparentCoor ##
Function TClic.TransparentCoor(X,Y:Integer):Boolean;
begin
try;Result:=(X>=0) and (X<=(iStyle.Icon.Width-1)) and (Y>=0) and (Y<=(iStyle.Icon.Height-1));except;end;
end;
//## TransText ##
Function TClic.TransText(Var X,Y:Integer):Boolean;
Var
   Z:String;
begin
try
Result:=TransparentCoor(X,Y);
Case Result of
True:begin
     Case iMouseDown of
     False:Z:=Translate('Click image for pixel ')+IntToStr(X)+','+IntToStr(Y)+' '+Translate('orientated transparency')+'.';
     True:Z:=Translate('Pixel ')+IntToStr(X)+','+IntToStr(Y)+' '+Translate('orientated transparency')+' '+Translate('active')+'.';
     end;//end of case
     end;//end of begin
False:begin
     Z:='';
     end;//end of begin
end;//end of case
{Change StatusBar Text}
If (Status<>Z) then
   begin
   Status:=Z;
   iStatusTextTimeIndex:=GetCurrentTime;
   end;//end of if
except;end;
end;
//## SetStatus ##
Procedure TClic.SetStatus(X:String);
begin
try
If (X=iStatus) then exit;
iStatus:=X;
{FOnStatus}
If Assigned(FOnStatus) then FOnStatus(Self);
except;end;
end;
//## SetFineCap ##
Procedure TClic.SetFineCap(X:Boolean);
begin
try
{Ignore}
If (FineCap=X) then exit;
{Set}
iFineCap:=X;
iCurInt:=True;
except;end;
end;
//## Disassociate ##
Procedure TClic.Disassociate;
begin
try
iForm.Visible:=False;
iForm.Parent:=nil;
except;end;
end;

end.
