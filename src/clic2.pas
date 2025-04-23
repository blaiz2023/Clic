unit Clic2;
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
//## Name: TextBrush Collection (Cut Down Version}
//## Desciption: Collection of TextBrush Related Objects
//##
//##  OBJECTS:
//##
//## ============================================================================
//## | Name              | Base Type   | Version   | Date       | Desciption
//## |-------------------|-------------|-----------|------------|-----------------
//## | TImageManipulator | TComponent  | 1.00.005  | 22/02/2002 | Basic Image Manipulation Tool
//## | TImagePixels      | TComponent  | 1.00.003  | 22/02/2002 | Rapid read/write of an Image's pixels
//## | TSmallPalette     | TComponent  | 1.00.008  | 22/02/2002 | Mini-Color Palette
//## ============================================================================
//##
//## Number of Objects: 4
//## Version: 1.00.036
//## Date: 22/02/2002
//## Lines: 825
//## Language Enabled
//## Copyright (c) 1997-2002 Blaiz Enterprises
//##############################################################################

interface

uses
  Forms, Windows, StdCtrls, ComCtrls, ExtCtrls, ExtDlgs,
  Dialogs, Buttons, Controls, Classes, Graphics, SysUtils,
  FileCtrl, Clic5, clic11;

{Global Defines}
Type TOnProgressEvent=Procedure (X:String;Y:Integer) of Object;


{TImageManipulator}
Const
     {Error Codes}
     imecNone=0;
     imecOutOfMemory=1;
     imecCanceled=2;
Type
    TImageManipulator=Class
    Private
     iCancelled:Boolean;
     iError:Integer;
     FOnProgress:TOnProgressEvent;
     Function Rotate90(X:TBitmap):Boolean;
    Public
     Procedure DoOnProgress(X:String;Y:Integer);
     Procedure DoError;
     Procedure DoDone;
     Constructor Create;
    Published
     Function Cls(X:TBitmap;Y:Integer):Boolean;
     Function Flip(X:TBitmap):Boolean;
     Function Mirror(X:TBitmap):Boolean;
     Function Rotate(X:TBitmap;Y:Integer):Boolean;
     Property OnProgress:TOnProgressEvent Read FOnProgress Write FOnProgress;
     {Cancelled}
     Property Cancelled:Boolean Read iCancelled Write iCancelled;
     {Error}
     Property Error:Integer Read iError Write iError;
     Function ErrorMessage:String;
     Procedure ShowError;
    end;

{TImagePixels}
Type
    TImagePixels=Class(TComponent)
    Private
     iHostPixelFormat:TPixelFormat;
     iSize,iSpacer,iW,iH:Integer;
     iMem:TMemoryStream;
     Function GetHeight:Integer;
     Function GetWidth:Integer;
     Function GetPixel(X,Y:Integer):Integer;
     Procedure SetPixel(X,Y,sC:Integer);
    Public
     Constructor Create;
    Published
     {Bitmap}
     Function SetBitmap(X:TBitmap):Boolean;
     Function GetBitmap(X:TBitmap):Boolean;
     {Pixel}
     Property Pixel[X,Y:Integer]:Integer Read GetPixel Write SetPixel;
     {Width & Height}
     Property Width:Integer Read GetWidth;
     Property Height:Integer Read GetHeight;
     {Clear}
     Procedure Clear;
     {Free}
     Procedure Free;
    end;

{TSmallPalette}
Type
    TSmallPalette=Class(TComponent)
    Private
     iIgnoreChange:Boolean;
     iForeColor,iBackColor:Integer;
     iMouseDown:Boolean;
     iSwap:TSpeedButton;
     iColorDialog:TColorDialog;
     iForm:TForm;
     pForeColor:TPanel;
     pBackColor:TPanel;
     FOnChange:TNotifyEvent;
     Function GetHeight:Integer;
     Procedure SetHeight(X:Integer);
     Procedure iForm_OnResize(Sender:TObject);
     Procedure DoChanged;
     Function GetBackColor:Integer;
     Procedure SetBackColor(X:Integer);
     Function GetForeColor:Integer;
     Procedure SetForeColor(X:Integer);
     Function GetWidth:Integer;
     Procedure iPanel_Click(Sender: TObject);
     Procedure iSwap_OnClick(Sender:TObject);
     Procedure iPanel_OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
     Procedure iPanel_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     Procedure iPanel_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     Procedure SetColor(Sender:TObject);
     Procedure UpdateColors(F,B:Integer);
    Public
     Constructor Create(Owner:TWinControl);
    Published
     {Form}
     Property Form:TForm Read iForm;
     {OnChange}
     Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
     Property IgnoreChange:Boolean Read iIgnoreChange Write iIgnoreChange;
     Property Height:Integer Read GetHeight Write SetHeight;
     Property Width:Integer Read GetWidth;
     {Back/ForeColor}
     Property ForeColor:Integer Read GetForeColor Write SetForeColor;
     Property BackColor:Integer Read GetBackColor Write SetBackColor;
     Procedure SetColors(F,B:Integer);
     {Dragging}
     Property Dragging:Boolean Read iMouseDown;
     {Free}
     Procedure Free;
    end;



Var
   FImageManipulator:TImageManipulator;

Function ImageManipulator:TImageManipulator;

implementation

//#############  TImagePixels  #################################################
//## Create ##
Constructor TImagePixels.Create;
begin
{iMem}
iMem:=TMemoryStream.Create;
{Rapid Width and Height Variables}
iW:=-1;
iH:=-1;
iSpacer:=0;
iSize:=-1;
end;
//## GetWidth ##
Function TImagePixels.GetWidth:Integer;
begin
try;Result:=iW;except;end;
end;
//## GetHeight ##
Function TImagePixels.GetHeight:Integer;
begin
try;Result:=iH;except;end;
end;
//## Free ##
Procedure TImagePixels.Free;
begin
try
If (Self<>Nil) then
   begin
   iMem.Free;
   Self.Destroy;
   end;//End of IF
except;end;
end;
//## GetPixel ##
Function TImagePixels.GetPixel(X,Y:Integer):Integer;
Var
   C:Array[0..2] of Byte;
   i:Integer;
begin
try
{Error or Pixel Not Found}
Result:=0;
{Invalid Size - ie No Image}
If (iSize=-1) then exit;
//Note: X,Y Range is NOT checked for Speed Reasons.
//Convert X,Y (2D Array Index) => i (1D Array Index):
i:=iSize-((iW-X)*3+(Y*(iW*3+iSpacer))+iSpacer);
{Seek Requested Position}
iMem.Seek(i,soFromBeginning);
{Read Requested Items [0..2]}
If (iMem.Read(C,SizeOf(C))=SizeOf(C)) then
   begin
   {Return Pixel Color}
   Result:=C[2]+C[1]*256+C[0]*256*256;
   end;
except;end;
end;
//## SetPixel ##
Procedure TImagePixels.SetPixel(X,Y,sC:Integer);
Var
   C:Array[0..2] of Byte;
   i:Integer;
begin
try
{Invalid Size - ie No Image}
If (iSize=-1) then exit;
//Note: X,Y Range is NOT checked for Speed Reasons.
//Convert X,Y (2D Array Index) => i (1D Array Index):
i:=iSize-((iW-X)*3+(Y*(iW*3+iSpacer))+iSpacer);
{Seek Requested Pixel Position}
iMem.Seek(i,soFromBeginning);
{Prepare Requested Pixel Items [0..2]}
C[0]:=sC Div (256*256);
C[1]:=(sC-(C[0]*256*256)) Div 256;
C[2]:=sC-(C[0]*256*256)-(C[1]*256);
{Write Pixel}
iMem.Write(C,SizeOf(C));
except;end;
end;
//## SetBitmap ##
Function TImagePixels.SetBitmap(X:TBitmap):Boolean;
begin
try
{Error}
Result:=False;
iHostPixelFormat:=X.PixelFormat;
{Clear iMem}
iMem.Clear;
{Ensure Bitmap is at 24 bpp}
X.PixelFormat:=pf24bit;
{Fill iMem}
iMem.Position:=0;
X.SaveToStream(iMem);
//Set "Rapid" Width and Height Variables:
iW:=X.Width;
iSpacer:=iW-((iW Div 4)*4);
iH:=X.Height;
iSize:=iMem.Size;
{Successful}
Result:=True;
except;end;{Revert X back to original bpp}
try;X.PixelFormat:=iHostPixelFormat;except;end;
end;
//## GetBitmap ##
Function TImagePixels.GetBitmap(X:TBitmap):Boolean;
begin
try
{Error}
Result:=False;
{Invalid Size - ie No Image}
If (iSize=-1) then exit;
{Load iMem into Provided Bitmap}
iMem.Position:=0;
X.LoadFromStream(iMem);
{Enforce Original Host PixelFormat}
X.PixelFormat:=iHostPixelFormat;
{Successful}
Result:=True;
except;end;
end;
//## Clear ##
Procedure TImagePixels.Clear;
begin
try
{iMem}
iMem.Clear;
{Variables}
iW:=-1;
iH:=-1;
iSpacer:=0;
iSize:=-1;
except;end;
end;
//##############################################################################
//#############  TImageManipulator  ############################################
//##############################################################################
//## Create ##
Constructor TImageManipulator.Create;
begin
{iError}
iError:=imecNone;
{iCanceled}
iCancelled:=False;
end;
//## Cls ##
Function TImageManipulator.Cls(X:TBitmap;Y:Integer):Boolean;
begin
try
{Error}
Result:=False;
{Canceled}
iError:=imecCanceled;If iCancelled then exit;
iError:=imecOutOfMemory;
DoOnProgress(Translate('Clearing Image...'),0);
X.Canvas.Brush.Color:=Y;
X.Canvas.FillRect(Rect(0,0,X.Width,X.Height));
{Successful}
Result:=True;
iError:=imecNone;
DoDone;
except;DoError;end;
end;
//## ErrorMessage ##
Function TImageManipulator.ErrorMessage:String;
begin
try
Case iError Of
imecNone:Result:=gecTaskSuccessful;
imecOutOfMemory:Result:=gecOutOfMemory;
imecCanceled:Result:=gecTaskCancelled;
else
Result:=gecUnexpectedError;
end;//End of CASE
except;end;
end;
//## ShowError ##
Procedure TImageManipulator.ShowError;
begin
try;General.ShowError(ErrorMessage);except;end;
end;
//## DoOnProgress ##
Procedure TImageManipulator.DoOnProgress(X:String;Y:Integer);
begin
try
If Assigned(FOnProgress) then FOnProgress(X,Y);
except;end;
end;
//## Flip ##
Function TImageManipulator.Flip(X:TBitmap):Boolean;
Var
   sRect,dRect:TRect;
begin
try
{Error}
Result:=False;
{Canceled}
iError:=imecCanceled;If iCancelled then exit;
iError:=imecOutOfMemory;
DoOnProgress(Translate('Flipping Image...'),0);
{Flip Image}
dRect:=Rect(0,0,X.Width,X.Height);
sRect:=Rect(0,X.Height-1,X.Width,-1);
X.Canvas.CopyRect(dRect,X.Canvas,sRect);
{Successful}
Result:=True;
iError:=imecNone;
DoDone;
except;DoError;end;
end;
//## Mirror ##
Function TImageManipulator.Mirror(X:TBitmap):Boolean;
Var
   sRect,dRect:TRect;
begin
try
{Error}
Result:=False;
{Canceled}
iError:=imecCanceled;If iCancelled then exit;
iError:=imecOutOfMemory;
{Flip Image}
DoOnProgress(Translate('Mirroring Image...'),0);
dRect:=Rect(0,0,X.Width,X.Height);
sRect:=Rect(X.Width-1,0,-1,X.Height);
X.Canvas.CopyRect(dRect,X.Canvas,sRect);
{Successful}
Result:=True;
iError:=imecNone;
DoDone;
except;DoError;end;
end;
//## DoDone ##
Procedure TImageManipulator.DoDone;
begin
try;DoOnProgress(Translate('Ready'),-1);except;end;
end;
//## DoError ##
Procedure TImageManipulator.DoError;
begin
try;DoOnProgress(ErrorMessage,-1);except;end;
end;
//## Rotate90 ##
Function TImageManipulator.Rotate90(X:TBitmap):Boolean;
Label
     SkipEnd;
Var
   ImagePixelsA:TImagePixels;
   ImagePixelsB:TImagePixels;
   S,maxXs,maxYs,Xs,Ys,Xd,Yd,P:Integer;
begin
try
{Error}
Result:=False;
{Canceled}
iError:=imecCanceled;If iCancelled then exit;
iError:=imecOutOfMemory;
DoOnProgress(Translate('Rotating Image...'),0);
{Source}
ImagePixelsA:=TImagePixels.Create;
ImagePixelsA.SetBitmap(X);
{Destination}
ImagePixelsB:=TImagePixels.Create;
//Swap Width <=> Height
P:=X.Width;
X.Width:=X.Height;
X.Height:=P;
ImagePixelsB.SetBitmap(X);
{Perform Pixel Rotation}
maxXs:=ImagePixelsA.Width-1;
maxYs:=ImagePixelsA.Height-1;
S:=GetCurrentTime;
For Ys:=0 to maxYs Do
begin
 If iCancelled then
    begin
    iError:=imecCanceled;
    Goto SkipEnd;
    end;
 If ((GetCurrentTime-S)>=300) then
    begin
    try;DoOnProgress(Translate('Rotating Image'),((Ys+1)*100) Div (maxYs+1));except;end;
    S:=GetCurrentTime;
    end;//End of IF
 For Xs:=0 to maxXs Do
 begin
 Xd:=maxYs-Ys;
 Yd:=Xs;
 ImagePixelsB.Pixel[Xd,Yd]:=ImagePixelsA.Pixel[Xs,Ys];
 end;//End of INNER LOOP
end;//End of OUTER LOOP
{Return Rotated Image}
Result:=ImagePixelsB.GetBitmap(X);
SkipEnd:
Case Result of
True:begin
     iError:=imecNone;
     DoDone;
     end;
False:DoError;
end;//End of CASE
except;DoError;end;
try;ImagePixelsA.Free;except;end;
try;ImagePixelsB.Free;except;end;
end;
//## Rotate ##
Function TImageManipulator.Rotate(X:TBitmap;Y:Integer):Boolean;
Var
   sRect,dRect:TRect;
begin
try
{Error}
Result:=False;
iError:=imecOutOfMemory;
{Rotate Image:
              +/- 0,90,180,270 Degrees
              + = Right - Clockwise
              - = Left - AntiClockwise}
Case Y of
-359..-270,1..90:Result:=Rotate90(X);
-269..-180,91..180:If Flip(X) then Result:=Mirror(X);
-174..-90,181..270:If Flip(X) then If Mirror(X) then Result:=Rotate90(X);
-89..0,-360,360:;{Null 0 or 360}
else
{Null}
end;//End of CASE
{Successful}
If Result then iError:=imecNone;
except;end;
end;


//#############  TSmallPalette  ################################################
//## Create ##
Constructor TSmallPalette.Create(Owner:TWinControl);
Var
   X:String;
   R_Err:Integer;
begin
{iMouseDown}
iMouseDown:=False;
{iForm}
iForm:=TForm.Create(Owner);
iForm.Parent:=Owner;
iForm.BorderIcons:=[];
iForm.BorderStyle:=bsNone;
iForm.VertScrollBar.Visible:=False;
iForm.HorzScrollBar.Visible:=False;
iForm.Caption:='';
iForm.ClientHeight:=25;
{iColorDialog}
iColorDialog:=TColorDialog.Create(iForm);
iColorDialog.Options:=[cdFullOpen];
{pForeColor}
pForeColor:=TPanel.Create(iForm);
pForeColor.Tag:=0;
pForeColor.Parent:=iForm;
pForeColor.Caption:='';
pForeColor.Visible:=True;
pForeColor.Cursor:=crDrag;
X:=RCode+'* '+Translate('Click for color window')+RCode+'* '+Translate('Left click and drag to acquire screen color');
pForeColor.Hint:=Translate('Foreground Color')+X;
pForeColor.ShowHint:=True;
pForeColor.OnClick:=iPanel_Click;
//OnMouse
pForeColor.OnMouseMove:=iPanel_OnMouseMove;
pForeColor.OnMouseDown:=iPanel_OnMouseDown;
pForeColor.OnMouseUp:=iPanel_OnMouseUp;
{iSwap}
iSwap:=TSpeedButton.Create(iForm);
iSwap.Parent:=iForm;
iSwap.Caption:='R';
iSwap.Flat:=True;
iSwap.Font.Color:=clRed;
iSwap.Font.Style:=[FsBold];
iSwap.Visible:=True;
iSwap.Cursor:=crHandPoint;
iSwap.OnClick:=iSwap_OnClick;
iSwap.Hint:=Translate('Swap Colors');
iSwap.ShowHint:=True;
{pBackColor}
pBackColor:=TPanel.Create(iForm);
pBackColor.Tag:=1;
pBackColor.Parent:=iForm;
pBackColor.Caption:='';
pBackColor.Visible:=True;
pBackColor.Cursor:=pForeColor.Cursor;
pBackColor.Hint:='Background Color'+X;
pBackColor.ShowHint:=pForeColor.ShowHint;
pBackColor.OnDblClick:=pForeColor.OnDblClick;
pBackColor.OnClick:=pForeColor.OnClick;
//OnMouse
pBackColor.OnMouseMove:=iPanel_OnMouseMove;
pBackColor.OnMouseDown:=iPanel_OnMouseDown;
pBackColor.OnMouseUp:=iPanel_OnMouseUp;
{iForm}
iForm.OnResize:=iForm_OnResize;
iForm.OnResize(Self);
{Default Colors}
SetColors(clWhite,clBlack);
end;
//## SetHeight ##
Procedure TSmallPalette.SetHeight(X:Integer);
begin
try
If (X<0) then exit;
iForm.ClientHeight:=X;
except;end;
end;
//## GetHeight ##
Function TSmallPalette.GetHeight:Integer;
begin
try;Result:=iForm.ClientHeight;except;end;
end;
//## Free ##
Procedure TSmallPalette.Free;
begin
try
If (Self<>Nil) then
   begin
   iForm.Free;
   Self.Destroy;
   end;//End of IF
except;end;
end;
//## GetWidth ##
Function TSmallPalette.GetWidth:Integer;
begin
try;Result:=iForm.ClientWidth;except;end;
end;
//## iForm_OnResize ##
Procedure TSmallPalette.iForm_OnResize(Sender:TObject);
begin
try
{pForeColor}
pForeColor.Left:=0;
pForeColor.Top:=0;
pForeColor.Height:=iForm.ClientHeight-4;
pForeColor.Width:=pForeColor.Height;
{iSwap}
iSwap.Left:=pForeColor.Left+pForeColor.Width+2;
iSwap.Height:=(pForeColor.Height*2) Div 3;
iSwap.Width:=iSwap.Height;
iSwap.Top:=(iForm.ClientHeight-iSwap.Height) Div 2;
{pBackColor}
pBackColor.Left:=iSwap.Left+iSwap.Width+2;
pBackColor.Top:=pForeColor.Top+4;
pBackColor.Height:=pForeColor.Height;
pBackColor.Width:=pForeColor.Width;
{Set Width}
iForm.ClientWidth:=pBackColor.Left+pBackColor.Width;
except;end;
end;
//## SetForeColor ##
Procedure TSmallPalette.SetForeColor(X:Integer);
begin
try;SetColors(X,iBackColor);except;end;
end;
//## GetForeColor ##
Function TSmallPalette.GetForeColor:Integer;
begin
try;Result:=iForeColor;except;end;
end;
//## SetBackColor ##
Procedure TSmallPalette.SetBackColor(X:Integer);
begin
try;SetColors(iForeColor,X);except;end;
end;
//## GetBackColor ##
Function TSmallPalette.GetBackColor:Integer;
begin
try;Result:=iBackColor;except;end;
end;
//## DoChanged ##
Procedure TSmallPalette.DoChanged;
begin
try
If iIgnoreChange then exit;
If Assigned(OnChange) then OnChange(Self);
except;end;
end;
//## iPanel_Click ##
Procedure TSmallPalette.iPanel_Click(Sender: TObject);
begin
try
iColorDialog.Color:=(Sender as TPanel).Color;
If iColorDialog.Execute then
   begin
   (Sender as TPanel).Color:=iColorDialog.Color;
   DoChanged;
   end;//End of IF
except;end;
end;
//## iSwap_OnClick ##
Procedure TSmallPalette.iSwap_OnClick(Sender:TObject);
Var
   F,B:Integer;
begin
try
F:=iBackColor;
B:=iForeColor;
SetColors(F,B);
except;end;
end;
//## iPanel_OnMouseDown ##
Procedure TSmallPalette.iPanel_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
try
{Left Click Only}
If (Button<>mbLeft) then exit;
iMouseDown:=True;
except;end;
end;
//## iPanel_OnMouseUp ##
Procedure TSmallPalette.iPanel_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
try
iMouseDown:=False;
{Set Colors}
SetColors(pForeColor.Color,pBackColor.Color);
except;end;
end;
//## iPanel_OnMouseMove ##
Procedure TSmallPalette.iPanel_OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
try;If iMouseDown then SetColor(Sender);except;end;
end;
//## SetColor ##
Procedure TSmallPalette.SetColor(Sender:TObject);
begin
try
Case (Sender as TPanel).Tag of
0:UpdateColors(low__capcolor(0,0,true),iBackColor);
1:UpdateColors(iForeColor,low__capcolor(0,0,true));
end;//End of CASE
except;end;
end;
//## SetColors ##
Procedure TSmallPalette.SetColors(F,B:Integer);
Var
   X:Boolean;
begin
try
X:=False;
{ForeColor}
If (F<>iForeColor) then
   begin
   iForeColor:=F;
   X:=True;
   end;
{BackColor}
If (B<>iBackColor) then
   begin
   iBackColor:=B;
   X:=True;
   end;
{Determine if Changed}
If X then
   begin
   UpdateColors(iForeColor,iBackColor);
   DoChanged;
   end;
except;end;
end;
//## UpdateColors ##
Procedure TSmallPalette.UpdateColors(F,B:Integer);
begin
try
pForeColor.Color:=F;
pBackColor.Color:=B;
except;end;
end;


//## ImageManipulator ##
Function ImageManipulator:TImageManipulator;
begin
try;if (FImageManipulator=nil) then FImageManipulator:=TImageManipulator.Create;Result:=FImageManipulator;except;end;
end;


initialization
  {Start}
  FImageManipulator:=nil;

finalization
  {Finish}
  FImageManipulator.Free;

end.
