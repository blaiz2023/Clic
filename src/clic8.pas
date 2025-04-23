unit Clic8;
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
//## Name: TColorIcon
//## Type: TComponent
//## Description: Clipboard to Icon Conversion Component
//## Version: 1.00.167
//## Date: 22/02/2002
//## Language Enabled
//## Blaiz Enterprises (c) 1997-2002
//##############################################################################

interface

uses
  Forms, Windows, SysUtils, Classes, Graphics, Clipbrd, Dialogs,
  Clic5, Clic9, clic11;
  
{TIconHeader}
Const
     ihInfoSize=22;
     ihInfoDataSize=40;
     ihSize=ihInfoSize+ihInfoDataSize;
     ihMax=ihSize-1;
     ihMinSize=1;{Width/Height}
     ihMaxSize=127;{MaxDimension}
     ihMaxColor=ihMaxSize*ihMaxSize;
Type TIconHeader=Array[0..ihMax] of Byte;
Type TIcon257Colors=Array[0..256] of Integer;{Small Colors Array, just enough to distinguish 1,4,8 or 24bits}
Type TIconColors=Array[0..ihMaxColor] of Integer;{Full Color Counter}

{TIconStyle}
Type
    TIconStyle=Record
    {Dimensions}
    Width:Integer;
    Height:Integer;
    {Transparency}
    Transparent:Boolean;
    TransparentX:Integer;
    TransparentY:Integer;
    TransparentColor:TColor24;
    {Colors}
    Colors:Integer;
    {BPP}
    BPP:Byte;
    end;
{TImageInfo}
Type
    TImageInfo=Record
    BPP:Byte;
    WIDTH:Integer;
    HEIGHT:Integer;
    ZeroWidth:Integer;
    ZeroHeight:Integer;
    WIDTHbytes:Integer;
    BMPbytes:Integer;
    MONObytes:Integer;
    PALbytes:Integer;
    {Icon Related}
    DATAbytes:Integer;
    IMAGESbytes:Integer;
    {Other}
    TransColor:TColor24;
    end;

{TColorIcon}
Type
  TColorIcon=class(TGraphic)
  Private
   iStyle:TIconStyle;
   FOnProgress:TProgressEvent;
   iImage:TBitmap;
   iLastTimerIndex:Integer;
   iErrorMessage:String;
   FOnChange:TNotifyEvent;
   Function FillImageInfo(Var X:TImageInfo):Boolean;
   Procedure Progress(Sender: TObject;Stage:TProgressStage;PercentDone:Byte;RedrawNow:Boolean;const R:TRect;const Msg:string);
   Procedure Progressing(PercentDone:Byte;const Msg:string);
   Procedure DoErr(X:String);
   Function ValidSize(X:Integer):Boolean;
   Function ValidBPP(rBPP:Integer):Boolean;
   Function WriteHeader(X:TStream;Var Y:TImageInfo;Var E:String):Boolean;
   Function WritePalette(X:TStream;Var Y:TColorPalette;Var E:String):Boolean;
   Function WriteBMP(X:TStream;Var Y:TBitmap;Var Z:TColorPalette;Var Info:TImageInfo;Var E:String):Boolean;
   Function _BuildPalette(Var X:TBitmap;Var Pal:TColorPalette;Var Info:TImageInfo;Var E:String):Boolean;
   Function WidthBytes(rBPP,W:Integer):Integer;
   Function OffSet4(X:Integer):Integer;
   Function RoundRow(Var X:TByteStream;Var Pos:Integer;Y:Integer):Boolean;
   Function _CountColors(Var X:Array of Integer):Integer;
   Procedure DoOnChange;
   Procedure UpdateTransparentColor(Var X:TIconStyle);
   Procedure SafeStyle(Var X:TIconStyle);
   Procedure _SetStyle(Var X:TIconStyle);
   Procedure SetStyle(X:TIconStyle);
   Function GetBPP:Byte;
   Procedure SetBPP(X:Byte);
   Function GetTransparent:Boolean;
   Procedure SetTransparent(X:Boolean);
   Procedure SetColors(X:Integer);
   Function GetColors:Integer;
   Procedure ResetColors;
   Procedure CopyFrom(X:TGraphic;Y:TIconStyle);
  Protected
   Procedure Draw(ACanvas:TCanvas;const sRect:TRect); override;
   Function GetEmpty: Boolean; override;
   Function GetHeight: Integer; override;
   Function GetWidth: Integer; override;
   Procedure SetHeight(X:Integer); override;
   Procedure SetWidth(X:Integer); override;
   Procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
   Procedure SaveToClipboardFormat(var Format: Word; var Data: THandle; var APalette: HPALETTE); override;
  Public
   {Create}
   Constructor Create; override;
   {Assign}
   Procedure Assign(Source: TPersistent); override;
   {Events}
   Property OnProgress:TProgressEvent Read FOnProgress Write FOnProgress;
   Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
   {Properties}
   Property Style:TIconStyle Read iStyle Write SetStyle;
   Property Colors:Integer Read GetColors Write SetColors;
   Function CountColors:Integer;
   Property BPP:Byte Read GetBPP WRite SetBPP;
   Function CountBPP:Byte;
   Property Transparent:Boolean Read GetTransparent Write SetTransparent;
   Property Image:TBitmap Read iImage;
   Procedure FreeImage;
   Procedure Dormant;
   {IO}
   Procedure SaveToStream(X:TStream);Override;
   Function SaveToFile(X:String):Boolean;
   {Errors}
   Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
   Procedure ShowError;
   {Destroy}
   Destructor Destroy; override;
  end;

implementation

//## Create ##
Constructor TColorIcon.Create;
begin
{iBitmap}
iImage:=TBitmap.Create;
iImage.PixelFormat:=pf24bit;
{Defaults}
iStyle.Width:=32;
iStyle.Height:=32;
iStyle.Transparent:=False;
iStyle.TransparentX:=0;
iStyle.TransparentY:=0;
iStyle.BPP:=24;
ResetColors;
{Style}
Style:=iStyle;
end;
//## SafeStyle ##
Procedure TColorIcon.SafeStyle(Var X:TIconStyle);
begin
try
{Dimensions}
X.Width:=FrcRange(X.Width,0,ihMaxSize);
X.Height:=FrcRange(X.Height,0,ihMaxSize);
{TransparentX/Y}
X.TransparentX:=FrcRange(X.TransparentX,0,X.Width-1);
X.TransparentY:=FrcRange(X.TransparentY,0,X.Height-1);
{Colors}
X.Colors:=FrcRange(X.Colors,0,ihMaxColor+1);
{BPP}
Case X.BPP of
1,4,8:;
else
X.BPP:=24;
end;//end of case
except;end;
end;
//## SetStyle ##
Procedure TColorIcon.SetStyle(X:TIconStyle);
begin
try
_SetStyle(X);
{DoOnChange}
DoOnChange;
except;end;
end;
//## _SetStyle ##
Procedure TColorIcon._SetStyle(Var X:TIconStyle);
begin
try
{SafeStyle}
SafeStyle(X);
iStyle:=X;
{iImage}
iImage.Width:=iStyle.Width;
iImage.Height:=iStyle.Height;
{Transparent Color - Read Only}
UpdateTransparentColor(iStyle);
except;end;
end;
//## UpdateTransparentColor ##
Procedure TColorIcon.UpdateTransparentColor(Var X:TIconStyle);
Var
   Row:PRGBColorRow;
begin
try
{Transparent Color}
Case X.Transparent and (X.Width>0) and (X.Height>0) and (X.TransparentX<X.Width) and (X.TransparentY<X.Height) of
True:begin
    Row:=iImage.Scanline[X.TransparentY];
    X.TransparentColor:=Row[X.TransparentX];
    end;//end of if
False:X.TransparentColor:=rgbBlack;
end;//end of case
{Update iImage}
iImage.TransparentColor:=RGBToInt(X.TransparentColor);
except;end;
end;
//## DoOnChange ##
Procedure TColorIcon.DoOnChange;
begin
try;If Assigned(FOnChange) then FOnChange(Self);except;end;
end;
//## GetBPP ##
Function TColorIcon.GetBPP:Byte;
begin
try;Result:=iStyle.BPP;except;end;
end;
//## SetBPP ##
Procedure TColorIcon.SetBPP(X:Byte);
Var
   Y:TIconStyle;
begin
try
If (iStyle.BPP=X) then exit;
Y:=iStyle;
Y.BPP:=X;
Style:=Y;
except;end;
end;
//## GetTransparent ##
Function TColorIcon.GetTransparent:Boolean;
begin
try;Result:=iStyle.Transparent;except;end;
end;
//## SetTransparent ##
Procedure TColorIcon.SetTransparent(X:Boolean);
Var
   Y:TIconStyle;
begin
try
If (iStyle.Transparent=X) then exit;
Y:=iStyle;
Y.Transparent:=X;
Style:=Y;
except;end;
end;
//## CountColors ##
Function TColorIcon.CountColors:Integer;
Var
   A:TIconColors;
begin
try;Result:=_CountColors(A);except;end;
end;
//## GetColors ##
Function TColorIcon.GetColors:Integer;
begin
try
If (iStyle.Colors=0) then iStyle.Colors:=CountColors;
Result:=iStyle.Colors;
except;end;
end;
//## SetColors ##
Procedure TColorIcon.SetColors(X:Integer);
Var
   Y:TIconStyle;
begin
try
If (iStyle.Colors=X) then exit;
Y:=iStyle;
Y.Colors:=X;
Style:=Y;
except;end;
end;
//## CountBPP ##
Function TColorIcon.CountBPP:Byte;
Var
   A:TIcon257Colors;
   Count:Integer;
   P:Byte;
begin
try
{Default}
Result:=24;
{Count Colors: 0-256=>1,4,8 and 24bits}
Count:=_CountColors(A);
{BPP}
Case Count of
0..2:P:=1;
3..16:P:=4;
17..256:P:=8;
else
P:=24;
end;//end of case
Result:=P;
except;end;
end;
//## _CountColors ##
Function TColorIcon._CountColors(Var X:Array of Integer):Integer;
Label
     SkipOk, SkipOne;
Var
   Row:PRGBColorRow;
   MaxC,MaxP,P,Count,Lc,C,rX,rY,MaxX,MaxY:Integer;
   Z:TColor24;
   Ok:Boolean;
begin
try
{Error}
Result:=0;
{Clear}
Count:=0;
MaxC:=High(X);
For P:=0 to MaxC Do X[P]:=0;
{Count Colors}
MaxX:=Width-1;
MaxY:=Height-1;
Lc:=-1;
For rY:=0 to MaxY Do
begin
Row:=iImage.Scanline[rY];
If (Count>MaxC) then break;
 For rX:=0 to MaxX Do
 begin
 Z:=Row[rX];
 C:=RGBToInt(Z);
 If (Lc=C) then Goto SkipOne;
 Case (Count=0) of
 True:begin
     X[Count]:=C;
     Count:=Count+1;
     If (Count>MaxC) then Goto SkipOk;
     end;//end of begin
 False:begin
     MaxP:=Count-1;
     Ok:=True;
     For P:=0 to MaxP Do
     begin
     If (X[P]=C) then
        begin
        Ok:=False;
        Break;
        end;//end of if
     end;//end of loop
     If Ok then
        begin
        X[Count]:=C;
        Count:=Count+1;
        If (Count>MaxC) then Goto SkipOk;
        end;//end of if
     end;//end of begin
 end;//end of case
 SkipOne:
 Lc:=C;
 end;//end of loop
end;//end of loop
SkipOk:
Result:=Count;
except;end;
end;
//## ValidSize ##
Function TColorIcon.ValidSize(X:Integer):Boolean;
begin
try;Result:=(X>=ihMinSize) and (X<=ihMaxSize);except;end;
end;
//## ValidBPP ##
Function TColorIcon.ValidBPP(rBPP:Integer):Boolean;
begin
try
{Error}
Result:=False;
Case rBPP of
1,4,8,24:Result:=True;
end;//end of case
except;end;
end;
//## Draw ##
procedure TColorIcon.Draw(ACanvas:TCanvas;const sRect:TRect);
Var
   RowA,RowB:PRGBColorRow;
   A:TBitmap;
   rX,rY,MinX,MinY,MaxX,MaxY:Integer;
   Tc,Z:TColor24;
begin
try
A:=nil;
{ACanvas => A}
A:=TBitmap.Create;
A.Width:=Width;
A.Height:=Height;
A.PixelFormat:=pf24bit;
A.Canvas.CopyRect(Rect(0,0,A.Width,A.Height),ACanvas,Rect(sRect.Left,sRect.Top,sRect.Left+A.Width,sRect.Top+A.Height));
{A+iImage}
MaxX:=A.Width-1;
MaxY:=A.Height-1;
Tc:=iStyle.TransparentColor;
For rY:=0 to MaxY Do
begin
RowA:=iImage.Scanline[rY];
RowB:=A.Scanline[rY];
 For rX:=0 to MaxX Do
 begin
 Case iStyle.Transparent of
 False:RowB[rX]:=RowA[rX];
 True:begin
     Z:=RowA[rX];
     If Not RGBEqual(Z,Tc) then RowB[rX]:=Z;
     end;//end of begin
 end;//end of case
 end;//end of loop
end;//end of loop
{A=>ACanvas}
ACanvas.Draw(sRect.Left,sRect.Top,A);
{ACanvas => A}
A:=TBitmap.Create;
A.Width:=iStyle.Width;
A.Height:=iStyle.Height;
A.PixelFormat:=pf24bit;
A.Canvas.CopyRect(Rect(0,0,A.Width,A.Height),ACanvas,Rect(sRect.Left,sRect.Top,sRect.Left+A.Width,sRect.Top+A.Height));
{A+iImage}
MaxX:=A.Width-1;
MaxY:=A.Height-1;
Tc:=iStyle.TransparentColor;
For rY:=0 to MaxY Do
begin
RowA:=iImage.Scanline[rY];
RowB:=A.Scanline[rY];
 For rX:=0 to MaxX Do
 begin
 Case iStyle.Transparent of
 False:RowB[rX]:=RowA[rX];
 True:begin
     Z:=RowA[rX];
     If Not RGBEqual(Z,Tc) then RowB[rX]:=Z;
     end;//end of begin
 end;//end of case
 end;//end of loop
end;//end of loop
{A=>ACanvas}
ACanvas.Draw(sRect.Left,sRect.Top,A);
except;end;
try;If (A<>nil) then A.Free;except;end;
end;
//## GetEmpty ##
Function TColorIcon.GetEmpty:Boolean;
begin
try;Result:=iImage.Empty;except;end;
end;
//## GetHeight ##
Function TColorIcon.GetHeight:Integer;
begin
try;Result:=iStyle.Height;except;end;
end;
//## GetWidth ##
Function TColorIcon.GetWidth:Integer;
begin
try;Result:=iStyle.Width;except;end;
end;
//## SetHeight ##
Procedure TColorIcon.SetHeight(X:Integer);
Var
   Y:TIconStyle;
begin
try
If (iStyle.Height=X) then exit;
Y:=iStyle;
Y.Height:=X;
Style:=Y;
except;end;
end;
//## SetWidth ##
Procedure TColorIcon.SetWidth(X:Integer);
Var
   Y:TIconStyle;
begin
try
If (iStyle.Width=X) then exit;
Y:=iStyle;
Y.Width:=X;
Style:=Y;
except;end;
end;
//## LoadFromClipboardFormat ##
procedure TColorIcon.LoadFromClipboardFormat(AFormat:Word;AData:THandle;APalette:HPALETTE);
begin
iImage.LoadFromClipboardFormat(AFormat,AData,APalette);
ResetColors;
Style:=Style;
end;
//## SaveToClipboardFormat ##
procedure TColorIcon.SaveToClipboardFormat(var Format: Word; var Data: THandle; var APalette: HPALETTE);
begin
iImage.SaveToClipboardFormat(Format,Data,APalette);
Style:=Style;
end;
//## Progress ##
procedure TColorIcon.Progress(Sender: TObject;Stage:TProgressStage;PercentDone:Byte;RedrawNow:Boolean;const R:TRect;const Msg:string);
begin
try
iLastTimerIndex:=GetCurrentTime;
if Assigned(FOnProgress) then FOnProgress(Sender,Stage,PercentDone,RedrawNow,R,Msg);
except;end;
end;
//## Progressing ##
procedure TColorIcon.Progressing(PercentDone:Byte;const Msg:string);
begin
try
if Not Assigned(FOnProgress) then exit;
If ((GetCurrentTime-iLastTimerIndex)>=250) then
   begin
   Progress(Self,psRunning,PercentDone,False,Rect(0,0,Width,Height),Msg);
   iLastTimerIndex:=GetCurrentTime;
   end;//end of if
except;end;
end;
//## Assign ##
Procedure TColorIcon.Assign(Source: TPersistent);
begin
try
If (Source is TColorIcon) then CopyFrom((Source as TColorIcon).Image,(Source as TColorIcon).Style)
else If (Source is TGraphic) then CopyFrom(Source as TGraphic,iStyle);
except;end;
end;
//## CopyFrom ##
Procedure TColorIcon.CopyFrom(X:TGraphic;Y:TIconStyle);
Var
   OldT:Boolean;
begin
try
If (X=nil) then exit;
{Remember Transparent}
OldT:=X.Transparent;
X.Transparent:=False;
{Style}
If (X.Width<>Y.Width) or (X.Height<>Y.Height) then
   begin
   Y.Width:=X.Width;
   Y.Height:=X.Height;
   end;//end of if
_SetStyle(Y);
{Cls}
iImage.Canvas.Brush.Color:=clWhite;
iImage.Canvas.FillRect(Rect(0,0,iImage.Width,iImage.Height));
{Paint}
iImage.Canvas.Draw(0,0,X);
except;end;
try
X.Transparent:=OldT;
{DoOnChange}
DoOnChange;
except;end;
end;
//## DoErr ##
Procedure TColorIcon.DoErr(X:String);
begin
{Raise Error if any}
If (X<>'') then
   begin
   iErrorMessage:=X;
   raise EGeneralError.Create(X);
   end;//end of if
end;
//## FreeImage ##
Procedure TColorIcon.FreeImage;
begin
try;iImage.FreeImage;except;end;
end;
//## Dormant ##
Procedure TColorIcon.Dormant;
begin
try;iImage.Dormant;except;end;
end;
//## WidthBytes ##
Function TColorIcon.WidthBytes(rBPP,W:Integer):Integer;
Var
   X:Integer;
begin
try
{Error}
Result:=-1;
{Process}
Case rBPP of
1:begin
  X:=(W Div 8);
  If (X<>(X Div 4)*4) then X:=((X Div 4)*4)+4;
  end;//end of begin
4:begin
  X:=(W Div 2);
  If (X<>(X Div 4)*4) then X:=((X Div 4)*4)+4;
  end;//end of begin
8:begin
  X:=W;
  If (X<>(X Div 4)*4) then X:=((X Div 4)*4)+4;
  end;//end of begin
24:begin
  X:=W*3;
  If (X<>(X Div 4)*4) then X:=((X Div 4)*4)+4;
  end;//end of begin
end;//end of case
{Successful}
Result:=X;
except;end;
end;
//## FillImageInfo ##
Function TColorIcon.FillImageInfo(Var X:TImageInfo):Boolean;
begin
try
{Error}
Result:=False;
{Process}
X.WIDTHbytes:=WidthBytes(X.BPP,X.WIDTH);
X.BMPbytes:=X.WIDTHbytes*X.HEIGHT;
X.MONObytes:=WidthBytes(1,X.WIDTH)*X.HEIGHT;
Case X.BPP of
1:X.PALbytes:=2*4;
4:X.PALbytes:=16*4;
8:X.PALbytes:=256*4;
else
{24}
X.PALbytes:=0;
end;//end of case
{Icon Related}
X.DATAbytes:=X.PALbytes+X.BMPbytes+X.MONObytes+ihInfoDataSize;
X.IMAGESbytes:=X.BMPbytes+X.MONObytes;
{Other}
X.TransColor:=iStyle.TransparentColor;
{Successful}
Result:=True;
except;end;
end;
//## WriteHeader ##
Function TColorIcon.WriteHeader(X:TStream;Var Y:TImageInfo;Var E:String):Boolean;
Var
   A:TIconHeader;
   S:TPoint;
   Z,L,P:Integer;
   s1,s2:Byte;
begin
try
{Error}
Result:=False;
E:=gecUnexpectedError;
If (X=nil) then exit;
E:=gecOutOfMemory;
{Check Dimensions}
If (Not ValidSize(Y.Width)) or (Not ValidSize(Y.Height)) then
   begin
   E:=gecUnexpectedError;
   exit;
   end;//end of if
{Check BPP}
If Not ValidBPP(Y.BPP) then
   begin
   E:=gecUnexpectedError;
   exit;
   end;//end of if
{Clear}
For P:=0 to ihMax Do A[P]:=0;
{Common Data}
A[2]:=1;
A[4]:=1;
A[6]:=Byte(Y.Width);
A[7]:=Byte(Y.Height);
A[18]:=Byte(ihInfoSize);{22}
A[22]:=Byte(ihInfoDataSize);{40}
A[26]:=Byte(Y.Width);{1xWidth}
A[30]:=Byte(2*Y.Height);{2xHeight}
A[34]:=1;
{Individual Data}
//Size {InfoData(40)+Palette+BMP+Mono}
L:=Y.DATAbytes;
s1:=L Div 256;
s2:=L-(s1*256);
A[14]:=s2;
A[15]:=s1;
//Colors
Case Y.BPP of
1:Z:=2;
4:Z:=16;
else
Z:=0;
end;//end of case
A[8]:=Byte(Z);
//BPP
A[36]:=Byte(Y.BPP);
//Size2 {BMP+Mono}
L:=Y.IMAGESbytes;
s1:=L Div 256;
s2:=L-(s1*256);
A[42]:=s2;
A[43]:=s1;
{Write to Stream}
If (X.Write(A,SizeOf(A))<>SizeOf(A)) then exit;
{Successful}
Result:=True;
except;end;
end;
//## WritePalette ##
Function TColorIcon.WritePalette(X:TStream;Var Y:TColorPalette;Var E:String):Boolean;
Label
     SkipEnd;
Var
   A:TByteStream;
   Pos,MaxP,P:Integer;
begin
try
{Error}
Result:=False;
A:=nil;
E:=gecUnexpectedError;
If (X=nil) then exit;
E:=gecOutOfMemory;
{A}
A:=TByteStream.Create;
A.Stream:=X;
Pos:=X.Position;
{Y => X}
MaxP:=Y.Count-1;
For P:=0 to MaxP Do
begin{B,G,R,0}
If Not A.Put(Pos,Y.Items[P].B) then Goto SkipEnd;
Pos:=Pos+1;
If Not A.Put(Pos,Y.Items[P].G) then Goto SkipEnd;
Pos:=Pos+1;
If Not A.Put(Pos,Y.Items[P].R) then Goto SkipEnd;
Pos:=Pos+1;
If Not A.Put(Pos,0) then Goto SkipEnd;
Pos:=Pos+1;
end;//end of loop
{Successful}
Result:=True;
SkipEnd:
except;end;
try;If (A<>nil) then A.Free;except;end;
end;
//## OffSet4 ##
Function TColorIcon.OffSet4(X:Integer):Integer;
Var
   Y:Integer;
begin
try
Y:=(X Div 4)*4;
Case (X=Y) of
True:Result:=Y;
False:Result:=Y+4;
end;//end of case
except;end;
end;
//## RoundRow ##
Function TColorIcon.RoundRow(Var X:TByteStream;Var Pos:Integer;Y:Integer):Boolean;
Var
   P,MinP,MaxP:Integer;
begin
try
{Ok}
Result:=True;
{Round to nearest 4th byte}
MinP:=Y;
MaxP:=OffSet4(MinP);
If (MinP=MaxP) then exit;
{Error}
Result:=False;
{Pad}
For P:=(MinP+1) to MaxP Do
begin
If Not X.Put(Pos,0) then exit;
Pos:=Pos+1;
end;//end of loop
{Successful}
Result:=True;
except;end;
end;
//## WriteBMP ##
Function TColorIcon.WriteBMP(X:TStream;Var Y:TBitmap;Var Z:TColorPalette;Var Info:TImageInfo;Var E:String):Boolean;
Label
     SkipEnd;
Var
   A:TByteStream;
   Row:PRGBColorRow;
   MaxP,Pos,rX,rY,MaxX,MaxY,P,P2,I,D:Integer;
   C,TransC:TColor24;
begin
try
{Error}
Result:=False;
A:=nil;
{Stream}
E:=gecUnexpectedError;
If (X=nil) then exit;
{Image}
E:=gecUnexpectedError;
If (Y=nil) then exit;
{Continue}
E:=gecOutOfMemory;
{A}
A:=TByteStream.Create;
A.Stream:=X;
Pos:=X.Position;
{Transparent Info}
If iStyle.Transparent then TransC:=Info.TransColor;
{Y => X}
MaxX:=Info.ZeroWidth;
MaxY:=Info.ZeroHeight;
{Process}
For rY:=MaxY downTo 0 Do
begin
Row:=Y.ScanLine[rY];
 Case Info.BPP of
 0:begin{1 bit/Mono Transparency}
    D:=0;
    P2:=-1;
    For rX:=0 to MaxX Do
    begin
    C:=Row[rX];
    P2:=P2+1;
    Case Transparent of
    False:I:=0;
    True:If RGBEqual(C,TransC) then I:=1 else I:=0;
    end;//end of if
    Case P2 of
    7:D:=D+I;
    6:D:=D+I*2;
    5:D:=D+I*4;
    4:D:=D+I*8;
    3:D:=D+I*16;
    2:D:=D+I*32;
    1:D:=D+I*64;
    0:D:=D+I*128;
    end;//end of case
    If (rX=MaxX) then P2:=7;
    If (P2>=7) then
       begin
       If Not A.Put(Pos,Byte(D)) then Goto SkipEnd;
       Pos:=Pos+1;
       P2:=-1;
       D:=0;
       end;//end of if
    end;//end of loop
    {RoundRow}
    If Not RoundRow(A,Pos,Info.Width Div 8) then Goto SkipEnd;
    end;//end of begin
 1:begin{1 bit}
    D:=0;
    P2:=-1;
    For rX:=0 to MaxX Do
    begin
    C:=Row[rX];
    P2:=P2+1;
    Case Transparent and RGBEqual(C,TransC) of
    False:I:=FindPaletteRGB(Z,C);
    True:I:=0;{Transparent Color always Palette pos 0}
    end;//end of if
    If (I=-1) then I:=0;
    Case P2 of
    7:D:=D+I;
    6:D:=D+I*2;
    5:D:=D+I*4;
    4:D:=D+I*8;
    3:D:=D+I*16;
    2:D:=D+I*32;
    1:D:=D+I*64;
    0:D:=D+I*128;
    end;//end of case
    If (P2>=7) or (rX=MaxX) then
       begin
       If Not A.Put(Pos,Byte(D)) then Goto SkipEnd;
       Pos:=Pos+1;
       P2:=-1;
       D:=0;
       end;//end of if
    end;//end of loop
    {RoundRow}
    If Not RoundRow(A,Pos,Info.Width Div 8) then Goto SkipEnd;
    end;//end of begin
 4:begin{4 bit}
    D:=0;
    P2:=-1;
    For rX:=0 to MaxX Do
    begin
    P2:=P2+1;
    C:=Row[rX];
    Case Transparent and RGBEqual(C,TransC) of
    False:I:=FindPaletteRGB(Z,C);
    True:I:=0;{Transparent Color always Palette pos 0}
    end;//end of if
    If (I=-1) then I:=0;
    Case P2 of
    1:D:=D+I;
    0:D:=D+I*16;
    end;//end of case
    If (P2>=1) or (rX=MaxX) then
       begin
       If Not A.Put(Pos,D) then Goto SkipEnd;
       Pos:=Pos+1;
       P2:=-1;
       D:=0;
       end;//end of if
    end;//end of loop
    {RoundRow}
    If Not RoundRow(A,Pos,Info.Width Div 2) then Goto SkipEnd;
    end;//end of begin
 8:begin{8 bit}
    For rX:=0 to MaxX Do
    begin
    C:=Row[rX];
    Case Transparent and RGBEqual(C,TransC) of
    False:I:=FindPaletteRGB(Z,C);
    True:I:=0;{Transparent Color always Palette pos 0}
    end;//end of if
    If (I=-1) then I:=0;
    If Not A.Put(Pos,I) then Goto SkipEnd;
    Pos:=Pos+1;
    end;//end of loop
    {RoundRow}
    If Not RoundRow(A,Pos,Info.Width) then Goto SkipEnd;
    end;//end of begin
 24:begin{24 bit}
    For rX:=0 to MaxX Do
    begin
    C:=Row[rX];
    If Transparent and RGBEqual(C,TransC) then C:=rgbBlack;
    If Not A.Put(Pos,C.B) then Goto SkipEnd;
    Pos:=Pos+1;
    If Not A.Put(Pos,C.G) then Goto SkipEnd;
    Pos:=Pos+1;
    If Not A.Put(Pos,C.R) then Goto SkipEnd;
    Pos:=Pos+1;
    end;//end of loop
    {RoundRow}
    If Not RoundRow(A,Pos,Info.Width*3) then Goto SkipEnd;
    end;//end of begin
 else
  E:=gecUnexpectedError;
  Goto SkipEnd;
 end;//end of case
end;//end of loop
{Successful}
Result:=True;
SkipEnd:
except;end;
try;If (A<>nil) then A.Free;except;end;
end;
//## _BuildPalette ##
Function TColorIcon._BuildPalette(Var X:TBitmap;Var Pal:TColorPalette;Var Info:TImageInfo;Var E:String):Boolean;
Label
     SkipEnd;
Var
   Row:PRGBColorRow;
   MaxCount,pI,rX,rY,MaxX,MaxY:Integer;
   Z:TColor24;
begin
try
Result:=False;
E:=gecOutOfMemory;
{Check Dimensions}
If (Info.Width<1) or (Info.Height<1) then
   begin
   E:=gecUnexpectedError;
   exit;
   end;//end of if
{MaxCount}
Case Info.BPP of
1:MaxCount:=2;
4:MaxCount:=16;
8:MaxCount:=256;
else
 E:=gecUnexpectedError;
 exit;
end;//end of case
{Clear Palette}
Pal.Count:=0;
{PaletteEntry 0 reserved for TransparentMode}
If Transparent then
   begin
   Pal.Items[0]:=rgbBlack;
   Pal.Count:=1;
   end;//end of if
{Create the Palette from Image}
MaxY:=X.Height-1;
MaxX:=X.Width-1;
For rY:=0 to MaxY Do
begin
Row:=X.Scanline[rY];
 For rX:=0 to MaxX Do
 begin
 Z:=Row[rX];
 Case (Transparent and RGBEqual(Z,Info.TransColor)) of
 True:pI:=0;
 False:pI:=AddRGBToPalette(Pal,Row[rX]);{max of 256 colors}
 end;//end of case
 If (pI=-1) or (Pal.Count>=MaxCount) then Goto SkipEnd;
 end;//end of loop
end;//end of loop
SkipEnd:
{Enlarge Palette to MaxColors Specification}
MaxX:=MaxCount-1;
For rX:=Pal.Count to MaxX Do Pal.Items[rX]:=rgbBlack;
Pal.Count:=MaxX+1;
{Successful}
Result:=True;
except;end;
end;
//## SaveToStream ##
Procedure TColorIcon.SaveToStream(X:TStream);
Label
     SkipEnd;
Var
   ErrMsg:String;
   PalIntArray:TIntPalette;
   PalArray:TRGBPalette;
   Pal:TColorPalette;
   ImageInfo:TImageInfo;
begin
try
ErrMsg:=gecOutOfMemory;
Progress(Self,psStarting,0,False,Rect(0,0,Width,Height),'Saving');
{Palette}
Pal.Items:=@PalArray;
Pal.IntItems:=@PalIntArray;
Pal.Count:=0;{empty}
{Write Header}
ImageInfo.BPP:=BPP;
ImageInfo.Width:=Width;
ImageInfo.Height:=Height;
ImageInfo.ZeroWidth:=ImageInfo.Width-1;
ImageInfo.ZeroHeight:=ImageInfo.Height-1;
If Not FillImageInfo(ImageInfo) then
   begin
   ErrMsg:=gecUnexpectedError;
   Goto SkipEnd;
   end;//end of if
{Write Header}
If Not WriteHeader(X,ImageInfo,ErrMsg) then Goto SkipEnd;
{Palette}
If (BPP>=1) and (BPP<=8) then
   begin
   {Build}
   If Not _BuildPalette(iImage,Pal,ImageInfo,ErrMsg) then Goto SkipEnd;
   {Write}
   If Not WritePalette(X,Pal,ErrMsg) then Goto SkipEnd;
   end;//end of if
{BMP}
If Not WriteBMP(X,iImage,Pal,ImageInfo,ErrMsg) then Goto SkipEnd;
{Mono}
ImageInfo.BPP:=0;
If Not WriteBMP(X,iImage,Pal,ImageInfo,ErrMsg) then Goto SkipEnd;
{No Error}
ErrMsg:='';
SkipEnd:
except;end;
try;Progress(Self,psEnding,100,False,Rect(0,0,Width,Height),'Saving');except;end;
{Raise Error if any}
DoErr(ErrMsg);
end;
//## SaveToFile ##
Function TColorIcon.SaveToFile(X:String):Boolean;
Label
     SkipEnd;
Var
   iStream:TStream;
begin
try
{Error}
Result:=False;
iStream:=nil;
{Remove File}
iErrorMessage:=gecFileInUse;
If Not Paths.RemFile(X) then Goto SkipEnd;
{Create Stream}
iErrorMessage:=gecBadFileName;
iStream:=TFileStream.Create(X,fmCreate);
{SaveToStream}
SaveToStream(iStream);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;If (iStream<>nil) then iStream.Free;except;end;
end;
//## ResetColors ##
Procedure TColorIcon.ResetColors;
begin
try;iStyle.Colors:=0;except;end;
end;
//## ShowError ##
Procedure TColorIcon.ShowError;
begin
try;General.ShowError(iErrorMessage);except;end;
end;
//## Destroy ##
Destructor TColorIcon.Destroy;
begin
iImage.Free;
inherited Destroy;
end;

{
//## Update ##
Procedure TColorIcon.Update;
begin
try
{DoOnChange}
{DoOnChange;
except;end;
end;
}
//## SetTransparentColor ##
{Procedure TColorIcon.SetTransparentColor(X:TRGBColor);
Label
     SkipEnd;
Var
   Row:PRGBColorRow;
   rX,rY,MaxX,MaxY:Integer;
   Z:TRGBColor;
begin
try
MaxX:=iImage.Width-1;
MaxY:=iImage.Height-1;
For rY:=0 to MaxY Do
begin
Row:=iImage.Scanline[rY];
 For rX:=0 to MaxX Do
 begin
 Z:=Row[rX];
 If RGBEqual(X,Z) then
    begin
    TransparentXY:=Point(rX,rY);
    Goto SkipEnd;
    end;//end of if
 end;//end of loop
end;//end of loop
SkipEnd:
{Update}
{Update;
except;end;
end;
{}

end.
