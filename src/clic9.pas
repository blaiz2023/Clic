unit Clic9;
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
//## Name: TextImages
//## Desciption: TextPicture Support for ToolBars
//##
//##  OBJECTS:
//##
//## ===============================================================================================
//## | Name              | Base Type   | Version   | Date        | Desciption
//## |-------------------|-------------|-----------|-------------|----------------
//## | TByteStream       | TGraphic    | 1.00.119  | 22/02/2002  | Single Byte Read/Write Streaming IO Support
//## | TByteImage        | TGraphic    | 1.00.041  | 22/02/2002  | Single Pixel Read/Write Streaming Bitmap IO Support
//## | TTextPicture      | TGraphic    | 1.00.129  | 22/02/2002  | TEP IO Graphic Object - 8 color/3bit image
//## | asglyph           | -           | 1.00.022  | 15-NOV-2005 | Auto. glyph creation with auto. greyscale creation
//## | tep images        | -           | 1.00.033  | 15-NOV-2005 | XP colored tep images
//## ===================================================================================
//##
//## Number of Objects: 4
//## Version: 1.00.344
//## Date: 15-NOV-2005
//## Lines: 2,273
//## Language Enabled
//## Copyright (c) 1997-2005 Blaiz Enterprises
//##############################################################################

interface

Uses
  Forms, Windows, Classes, SysUtils, Graphics, clic5, clic11;

const
{TEP Images}
     tepEncrypt='T2K00K00)300jm7pPl()~'+'000000000000000000000KLLL00GgggQ00agcg600fgfg10GgQgQ00agcg600fLLf10GgQgQ00agcg600fgfg10GgQgQ00aggg600KLLL00000000000000000000000000000#';
     tepDecrypt='T2K00K00)300jm7pPl()~'+'000000000000000000000KLLL00GgggQ00aggg600fggg10GgggQ00aggg600fLLf10GgggQ00aggg600fggg10GgggQ00aggg600KLLL00000000000000000000000000000#';
     tepShred='T2K00K00)3000fOrRlV)14Sq~'+'000000000000000000000000000G1K0500G0G04004040100101G00G040H504G00P50140KL1G010LL0L05aL1000GQ50KLLfN00LLbU5000Gw10000f70000GV00000K1000#';
     tepStop='T2K00K00)3000fOrRlV)14Sq~'+'000000000000000000000000000G1K0500G0G04004040100101G00G040H504G00P50140KL1G010LL0L05aL1000GQ50KLLfN00LLbU5000Gw10000f70000GV00000K1000#';
     tepCut='T2K00K00)3000fOrWAu8~'+'00000000000000000000004G00000140000G010000KK000004100000L000000100000K100000YA0000g8800088220002YW000WWW2000W2000000000000000000000000#';
     tepCopy='T2K00K00)3000fOrPl()~'+'00000000000000KL0000GgM0000agP0000PPLL00GgQgM00aLbgP00fgPPL0GMLgg60agcLb10PLfgQ0GgQML60GLbgg1000PLP000Ggg6000GLL0000000000000000000000#';
     tepPaste='T3K00K00)300WAu80fOr)llaPl()~'+'000000000000000000000009900000099HA990008PBAHPB1008RPRRBR1008R9999R1008RRRRRR1008RRJIII1008RRJaaK2008RRJaaKK008RRJKIKI208RRJaaaa208RRJKIIY208RRJaaaa208PRJKIIY20099Haaaa200000IIII0000000000000000000000#';
     tepPasteToFit='T3K00K00)300WAu80fOr)llaPl()~'+'000000000000000000000009900000099HA990008PBAHPB1008RPRRBR1008R9999R1008RRRRRR1008RRJYKYK208RRZaaaa408RRZaaaa408RRJKIaa208RRJaaaa208RRZKIIY408RRZaaaa408PRJKIIY20099Haaaa20000WKYKY4000000000000000000000#';
     tepFlip='T2K00K00)300Kqv2OdA9~'+'000000000000000000000000000000000000K10000G050000100000G00000gcggA0Wgfgg2000100000G010000GK00000G500000L10000KL00000000000000000000000#';
     tepMirror='T2K00K00)300OdA9Kqv2~'+'00000000000000000000000K000000500000G100000KW000gA5800WgG1800e2K0200A25W00W0Q120000eA00000500000G100000K000000500000000000000000000000#';
     tepRotate90='T2K00K00)300Kqv2OdA9~'+'0000000000000000001000WgK000W2G500020L100W0KL000200W00W0008008000200200W00W000800GL1W000K508000L0e000GXg000040000000000000000000000000#';
     tepBrushProperties='T2K00K00)3000fOr)lla~'+'0000000000000000000000000K00000G600000P00000a10000G600000P00000a10000G600000P00000L10000a50000LM10000L50000000000000000000000000000000#';
     tepOpenBrush='T3P00K00)300Kqv20fOr)llaWAu8)xVb))))V7CQ~'+'000000000000000000000000000000000000000000091000G20000010110GJ0000000090GJ00Wa000091GJ00Wrbaaa00GJ000qrrrr40GJ000Wrrrrb0GJ0000qrbaaaKJ0000Wrb)))NJ00000qb)))II00000Wb)))QI000000a))IQI2000000aaaII20000000000000000000000000000000000000000000000000000000'+'#';
     tepUndo='T1K00K00)300Kqv2~'+'0000000000000000000000000F0431m2807W0y02m7400G000000000000000000000#';
     tepNew='T2K00K00)3000fOrPl()~'+'000000000000000000000GLL0000fgM000GggP000agQL000fgg600Gggg100aggQ000fgg600Gggg100aggQ000fgg600Gggg100GLL500000000000000000000000000000#';
     tepOpen='T3K00K00)300Kqv2WAu8)xVb))))V7CQ~'+'0000000000000000000000000000000000089000000001011000000008100GI00009100QSIII20000YZZZZ20000QSSSS20000YZJIIII200QSgjjjj200YJjjjjL000Qgjjjj2000IjjjjL0000GIIII20000000000000000000000000000000000000000000#';
     tepSaveAs='T3K00K00)300hjspiow)))))xkx)zrNr~'+'00000000000000000000009999990008IIIIII1008IRRRRI1008IZaaSI1008IRRRRI1008IZaaSI1008IRRRRI1008IIIIII1008IIIIII1008IjjjjL1008IjjjRL1008IjjjRL1008IjjjRL1000999999000000000000000000000000000000000000000000#';
     tepPrint='T5K00K00)300RkvaPl()uEz)kuY9GUv))ztPV)z)hjspmEx))x)bWMw)Kqv28jqVr1u)G3z)tkx)i5tlyztlpTtl~'+'000000000000000000000000000000000000000000000000011100000000000000001222110000000000000132222244000000000563322224000000000557633322488000000057999663349898800000577AA996649999B8000057997CC9BDB9BEE8000057999979F9BEEEE80000559999G7BEEEEH88000005559999'+'EEEH8E80000008FF5599EH8EEHH000000088FF5I8EEE80000000000088F9EE88000000000000008J8800000000000000000000000000000000000000000000000000000000000000000000#';
     tepAdd='T2K00K00)300jm7pPl()~'+'000000000000000000000KLLL00GgggQ00agcg600fgfg10GgQgQ00agcg600fLLf10GgQgQ00agcg600fgfg10GgQgQ00aggg600KLLL00000000000000000000000000000#';
     tepDel='T2K00K00)300jm7pPl()~'+'000000000000000000000KLLL00GgggQ00aggg600fggg10GgggQ00aggg600fLLf10GgggQ00aggg600fggg10GgggQ00aggg600KLLL00000000000000000000000000000#';
     tepOpenN='T3K00K00)300Kqv2WAu8)xVb))))V7CQ~'+'0000000000000000000000000009000000000900000000999000000099900GI00009000QSIII29000YZZZZ20000QSSSS20000YZJIIII200QSgjjjj200YJjjjjL000Qgjjjj2000IjjjjL0000GIIII20000000000000000000000000000000000000000000#';
     tepCenter='T2K00K00)300jm7pPl()~'+'000000000000000000000KLLL00GgggQ00aggg600fggg10GgQgQ00agcg600fMLg10GgQgQ00agcg600fggg10GgggQ00aggg600KLLL00000000000000000000000000000#';
     tepInfo='T2K00K00)3000fOr))))~'+'000000000LL0000bgQ100aMLf10GMLLb10PLfLb1GMLQLP0PLLLLPGMLLLL6aLLQLb1PLbMLPGMLfLL6aLLQLb1aLbML60PLfLb10PLLL600fLLQ000bgQ1000KL1000000000#';
     tepHelp='T2K00K00)3000fOr))))~'+'000000000LL0000bgQ100aMLf10GMfQb10PbgQb1GMgLQP0PbMbMPGMLLgL6aLLfMb1PLbQLPGMLfLL6aLLQLb1aLLLL60PLfLb10PLQL600fLLQ000bgQ1000KL1000000000#';
     tepUp='T2e00K00)300))))0000028W~'+'0000000000000000000000000000000000000000000500000G100000f10000GV00000fQ0000G)70000fg6000G))1000fgg100G))V000fggQ00G)))700GbgL000KzV5000Gg60000q)10000fQ0000G)70000ag10000zV0000Gg60000q)10000fQ0000G)70000ag10000zV0000Gg60000q)10000K500000L1000000000000'+'00000000000000000#';
     tepDown='T2e00K00)300))))0000028W~'+'00000000000000000000000000000K500000L10000ag10000zV0000Gg60000q)10000fQ0000G)70000ag10000zV0000Gg60000q)10000fQ0000G)70000ag10000zV0000LgM100Gr)L000fggQ00G)))700GggQ000q))7000agQ0000z)70000fQ0000G)70000GQ00000q700000K000000500000000000000000000000000'+'00000000000000000#';
     tepOptions='T2e00K00)300))))W02G028W~'+'00f60L00G)1G50Gfg1f60K)VG)1GgQ1f60q)NG)1GgQ0a64q)70z1Hfg1GgbK)V0qVTggQGggs))7q))gQg6fgs)t)H))bQagfQ5z7zV)N1P0fgQ0G7G))70G0GgQ0040q)70000fg1000G)V0000fgQ000G))700KfQg600L)t)10agQfg10z)N)V0acQGgQ0zz7q)7G6f1ag6qHV0z)14G60fg11q1G)F0KQ0Gg10r70qV0aQ00a10z7'+'00T00L00010G500GG#';
     tepColor='T3e00K00)30000mV)ztV)(xl0000))))~'+'00000000000000000000000000000000000000000000008900000000GI00000000P910000000QI20000008991000000GII20000009991000000III20000009990000000III000000WD91000000GLI2000000iL90000000gLI000000WjY0000000GjI0000000iL40000000gL2000000WjX0000000GjJ0000000iD400000'+'00gT2000000WjX0000000GjJ0000000W940000000GR20000000Wa00000000GI000000000000000000000000000000000000000000000000000000000000000000000000000000000000000#';
     tepTextWndColor='T3K00K00)3000fOr))))RlV)14Sq~'+'0000000000000000000000000000000999999990899999999189999999918IIIIIIII18IIIIIIII18I9999II918IIIIIIAB98IIIIII9998I999999998IIIIIAB918IIIIIPB918I9999RCI18IIIIPZHI18IIIARCII10999PZ99900000XC00000000910000#';
     tepWndColor='T3K00K00)3000fOr)xVb))))RlV)14Sq~'+'000000000000000000000000000000099999999089IIIIII9189999999918RRRRRRRR18RRRRRRRR18RRRRRRR918RRRRRRBC98RRRRRR9998RRRRRR9998RRRRRBC918RRRRRXC918RRRRBaDR18RRRRXiPR18RRRBaDRR10999Xi99900000fD00000000910000#';
     tepListColor='T3K00K00)3000fOr))))WAu8Kqv2RlV)14Sq~'+'000000000000000000000000000000000000000009999999908IIIIIIII18QYaaaaaK18IIIIIIII18QYaaaaK918IIIIIIAD98QYaaaK9998IIIIII9998QYaaKAD918IIIIIfD918QYaaAjEI18IIIIfrHI18IIIAjEII10999fr99900000nE00000000910000#';
     tepLinkColor='T2K00K00)3000fOrRlV)14Sq~'+'000000000000000000000000000G1K0500G0G04004040100101G00G040H504G00P50140KL1G010LL0L05aL1000GQ50KLLfN00LLbU5000Gw10000f70000GV00000K1000#';
     tepTransparent='T2K00K00)300Pl()0fOr~'+'000000000000000000000000000aPcPc90cMQfb1GfbMQf0OQfbM60bMQfb2WfbMQP0KQfbMA0cMQfb1GfbMQf0OQfbM60bMQfb2WPcPcP0000000000000000000000000000#';
     tepGreyScale='T3K00K00)300Pl()0fOrHyIJLYy)~'+'00000000000000000000000000000000000000000HHHHHHHH00QRIIaa9900PRIIaa9H00QRIIaa9900PRIIaa9H00QRIIaa9900PRIIaa9H00QRIIaa9900PRIIaa9H00QRIIaa9900PRIIaa9H00AAAAAAAA00000000000000000000000000000000000000000#';
     tepScreenCapture='T2K00K00)300HyIJ))))0fOr~'+'000000000G10000KeK000GQQA500accc6G5ffff1aMggQQ0fcggg60ffwgg10fgggQ0Ggghg10GwkxQ00agkg100aggQ000fwg1000fgQ0000LL10000000000000000000000#';

Type
    EGeneralError=Class(Exception);

{TRGBColor}
Var
   rgbBlack:TColor24;
{TRGBColorRow}
Type
    PRGBColorRow=^TRGBColorRow;
    TRGBColorRow=Array[Word] of TColor24;
{TRGBColorRows}
Type
    PRGBColorRows=^TRGBColorRows;
    TRGBColorRows=Array[Word] of PRGBColorRow;

{TRGBPalette - upto 256 colors}
Const
     rpccMax=255;
     rpccPal8:Array[0..7] of Integer=(clBlack,clRed,clYellow,clLime,clBlue,clSilver,clGray,clWhite);
     rpccBPPS:Array[0..8] of Integer=(0,2,4,8,16,32,64,128,256);{bbp:colors}

Type
    PRGBPalette=^TRGBPalette;
    TRGBPalette=Array[0..rpccMax] of TColor24;
    PIntPalette=^TIntPalette;
    TIntPalette=Array[0..rpccMax] of Integer;
Type
    PColorPalette=^TColorPalette;
    TColorPalette=Record
    Items:PRGBPalette;
    IntItems:PIntPalette;
    Count:Integer;
    end;

{General Routines}
Function IntToRGB(X:Integer):TColor24;
Function RGBColor(R,G,B:Byte):TColor24;
Function RGBEqual(Var X,Y:TColor24):Boolean;
Function RGBToInt(X:TColor24):Integer;
Function FindPaletteColor(Var X:TColorPalette;Y:Integer):Integer;
Function AddColorToPalette(Var X:TColorPalette;C:Integer):Integer;
Function FindPaletteRGB(Var X:TColorPalette;Y:TColor24):Integer;
Function AddRGBToPalette(Var X:TColorPalette;Y:TColor24):Integer;
Function BuildPalette(Var X:TBitmap;Var Pal:TColorPalette;MaxCount:Integer):Boolean;
Function ColorsAsBPP(X:Integer):Byte;

{TByteBuffer}
Const
     bbccMax=2047;
     bbccMaxSize=bbccMax+1;
Type
    TByteBuffer=Record
    Items:Array[0..bbccMax] of Byte;
    OffSet:Integer;
    Count:Integer;
    Modified:Boolean;
    end;
{TWordBuffer}
Type
    TWordBuffer=Record
    Items:Array[0..bbccMax] of Word;
    OffSet:Integer;
    Count:Integer;
    Modified:Boolean;
    end;
{TByteStream}
Const
     bssmSeekForward=0;
     bssmSeekBackward=1;
     bssmSeekMiddle=2;
     bssmSeekMax=2;
Type
    TByteStream=Class(TComponent)
    Private
     iStream:TStream;
     iBuffer:TByteBuffer;
     iSize:Integer;
     iSeekMode:Integer;
     Procedure Clear;
     Procedure SetStream(X:TStream);
     Procedure SetSeekMode(X:Integer);
    Public
     {Create}
     Constructor Create;
     {Properties}
     Property Stream:TStream Read iStream Write SetStream;
     Function Get(X:Integer;Var Y:Byte):Boolean;
     Function Put(X:Integer;Y:Byte):Boolean;
     Function Finalise:Boolean;
     Property Size:Integer Read iSize;
     Property SeekMode:Integer Read iSeekMode Write SetSeekMode;
     {Special}
     Function ReadLine(Var sS:Integer;sF:Integer;Var S,F:Integer;FindByte:Byte;Var FindP:Integer):Boolean;
     Function FindByte(X:Byte;S,F:Integer):Integer;
     Function SwapByte(X,Y:Byte;S,F:Integer):Boolean;
     Function AsciiDecimalToBinary(S,F,MaxV:Integer;Var X:TWordBuffer):Boolean;
     Function XHexToBinary(S,F,MaxV:Integer;Var X:TByteBuffer):Boolean;
     Function ByteToXHex(X:Byte;Var Y:TByteBuffer):Boolean;
     Function Str(S,F:Integer):String;
     Function ReadWordValue(Var X:TWordBuffer;Var Y:Integer):Boolean;
     Function PushStr(Var X:Integer;Y:String):Boolean;
     {Free}
     Procedure Free;
    end;

{TByteImage}
Type
    TByteImage=Class(TComponent)
    Private
     iRow:PRGBColorRow;
     iRowY:Integer;
     iImage:TBitmap;
     iX,iY,iZeroWidth,iZeroHeight,iWidth,iHeight:Integer;
     Function ReadRow(Y:Integer):Boolean;
     Procedure SetImage(X:TBitmap);
     Function GetPixels(X,Y:Integer):TColor24;
     Procedure SetPixels(X,Y:Integer;Z:TColor24);
     Function GetRow(Y:Integer):PRGBColorRow;
    Public
     {Create}
     Constructor Create;
     {Properties}
     Property Image:TBitmap Read iImage Write SetImage;
     Property Pixels[X,Y:Integer]:TColor24 Read GetPixels Write SetPixels;
     Property X:Integer Read iX Write iX;
     Property Y:Integer Read iY Write iY;
     Property ZeroWidth:Integer Read iZeroWidth;
     Property ZeroHeight:Integer Read iZeroHeight;
     Property Width:Integer Read iWidth;
     Property Height:Integer Read iHeight;
     Function MoveTo(X,Y:Integer):Boolean;
     Function PushPixel(Var X:TColor24):Boolean;
     Function PullPixel(Var X:TColor24):Boolean;
     Procedure ExpandBits(X:Byte;Var Y:TByteBuffer);
     Property Row[Y:Integer]:PRGBColorRow Read GetRow;
     {Free}
     Procedure Free;
    end;

{TTextPicture TEP}
Const
     tpccSOF=29;{Encoded Value - Start of File}
     tpccEOF=35;{End of File}
     tpccEOP=126;{End of Palette}
     tpccStartComment=123;// '{'
     tpccEndComment=125;// '}'
     tpccMaxInt=16777216;
     {Styles - Save Only}
     tpscPlain=0;{Single String}
     tpscBlocks=1;{Blocks of no more than 255 char's separated by "'+'"}
     tpscLines=2;{Lines, each terminated by RCode}
     tpscMax=2;
     {Colors}
     tpsbMinBPP=1;
     tpsbMaxBPP=6;
     tpsbDefault=tpsbMaxBPP;
     tpsbBPPAsPixels:Array[0..6] of Byte=(0,6,3,2,1,1,1);

Type
  TTextPicture=class(TGraphic)
  Private
    FOnProgress:TProgressEvent;
    iImage:TBitmap;
    iLastTimerIndex:Integer;
    iStyle:Byte;
    iBPP:Byte;
    iErrorMessage:String;
    Procedure FromRGB(X:Integer;Var Y:TByteBuffer;Z:Integer);
    Function AsByte(Var X:Byte):Boolean;
    Function AsNum(Var X:Byte):Boolean;
    Function AsInteger(Var X:TByteBuffer;Y:Integer):Integer;
    Procedure Update;
    Procedure Progress(Sender: TObject;Stage:TProgressStage;PercentDone:Byte;RedrawNow:Boolean;const R:TRect;const Msg:string);
    Procedure Progressing(PercentDone:Byte;const Msg:string);
    Function ReadHeader(X:TStream;Var rBPP:Byte;Var W,H:Integer;Var Pal:TColorPalette):Boolean;
    Function WriteHeader(X:TStream;Var Y:TBitmap;rBPP,W,H:Integer;Var Pal:TColorPalette):Boolean;
    Function AsciiReader(X:TStream;rBPP:Integer;Var Y:TBitmap;Var Pal:TColorPalette):Boolean;
    Function AsciiWriter(X:TStream;S,rBPP:Integer;Var Y:TBitmap;Var Pal:TColorPalette):Boolean;
    Function StdPalette(Var Pal:TColorPalette):Boolean;
    Procedure DoErr(X:String);
    Procedure SetStyle(X:Byte);
    Function WriteSep(X:TByteStream;Var Pos:Integer;Style:Integer;EOL:Boolean):Boolean;
    Procedure SetBPP(X:Byte);
    Function CondensePixels(Var X:TByteBuffer;bpp:Byte;Var Z:Byte):Boolean;
    Function ExpandPixels(X,bpp:Byte;Var Y:TByteBuffer;Z:Integer):Boolean;
  Protected
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var Format: Word; var Data: THandle; var APalette: HPALETTE); override;
  Public
    {Create}
    Constructor Create; override;
    {Assign}
    Procedure Assign(Source: TPersistent); override;
    {Properties}
    Procedure CopyFrom(X:TGraphic);
    Property OnProgress:TProgressEvent Read FOnProgress Write FOnProgress;
    Property Image:TBitmap Read iImage;
    Procedure FreeImage;
    Procedure Dormant;
    {Styles}
    Property Style:Byte Read iStyle Write SetStyle;
    Property BPP:Byte Read iBPP Write SetBPP;
    Function CountBPP:Byte;{Actual Realtime BPP}
    {IO}
    Procedure LoadFromStream(X:TStream);Override;
    Function LoadFromFile(X:String):Boolean;
    Function LoadFromStr(Var X:String):Boolean;
    Procedure SaveToStream(X:TStream);Override;
    Function SaveToFile(X:String):Boolean;
    Function SaveToStr(Var X:String):Boolean;
    Function Glyph(X:String):TBitmap;
    {Errors}
    Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
    Procedure ShowError;
    {Destroy}
    Destructor Destroy; override;
  end;

  //## asglyph ##
  function asglyph(x:string;dual:boolean):tbitmap;

implementation

//#################### General Routines ########################################
//## asglyph ##
function asglyph(x:string;dual:boolean):tbitmap;
var
   a:TTextPicture;
   w,h,rx,ry:integer;
   r:PRGBColorRow;
   t,c:TColor24;
begin
try
{Error}
Result:=nil;
A:=nil;
A:=TTextPicture.Create;
//process
//.get
result:=a.glyph(x);
w:=result.width;
h:=result.height;
//.greyscale version
if dual then
   begin
   result.width:=result.width*2;
   for ry:=0 to (h-1) do
   begin
   r:=result.scanline[ry];
    for rx:=0 to (w-1) do
    begin
    //.get
    c:=r[rx];
    if (ry=0) and (rx=0) then t:=c;
    //.not transparent
    if (c.r<>t.r) or (c.g<>t.g) or (c.b<>t.b) then
       begin
       //.decide
       c.r:=lumrgb(c.r,c.g,c.b);
       c.g:=c.r;
       c.b:=c.r;
       end;//end of if
    //.set
    r[rx+w]:=c;
    end;//end of loop
   end;//end of loop
   end;//end of if
except;end;
try;A.Free;except;end;
end;
//## RGBColor ##
Function RGBColor(R,G,B:Byte):TColor24;
begin
try
Result.R:=R;
Result.G:=G;
Result.B:=B;
except;end;
end;
//## RGBEqual ##
Function RGBEqual(Var X,Y:TColor24):Boolean;
begin
try;Result:=(X.R=Y.R) and (X.G=Y.G) and (X.B=Y.B);except;end;
end;
//## IntToRGB ##
Function IntToRGB(X:Integer):TColor24;
var
   tmp:tint4;
begin
try
tmp.val:=x;
Result.R:=tmp.r;
Result.G:=tmp.g;
Result.B:=tmp.b;
except;end;
end;
//## RGBToInt ##
Function RGBToInt(X:TColor24):Integer;
begin
try;Result:=RGB(X.R,X.G,X.B);except;end;
end;
//## FindPaletteColor ##
Function FindPaletteColor(Var X:TColorPalette;Y:Integer):Integer;
Var
   MaxP,P:Integer;
begin
try
{Not Found}
Result:=-1;
MaxP:=X.Count-1;
For P:=0 to MaxP Do
begin
If (Y=X.IntItems[P]) then
   begin
   Result:=P;
   break;
   end;//end of loop
end;//end of loop
except;end;
end;
//## AddColorToPalette ##
Function AddColorToPalette(Var X:TColorPalette;C:Integer):Integer;
Var
   Add:Boolean;
   P:Integer;
begin{Z=Max Palette Item ie 1-8}
try
{Error}
Result:=-1;
Case (X.Count=0) of
True:P:=-1;
False:P:=FindPaletteColor(X,C);
end;//end of case
{Add}
If (P=-1) and(X.Count<=rpccMax) then
   begin
   P:=X.Count;
   X.IntItems[P]:=C;
   X.Items[P]:=IntToRGB(C);
   X.Count:=P+1;
   end;//end of if
{Return Result}
Result:=P;
except;end;
end;
//## FindPaletteRGB ##
Function FindPaletteRGB(Var X:TColorPalette;Y:TColor24):Integer;
Var
   MaxP,P:Integer;
   Z:TColor24;
begin
try
{Not Found}
Result:=-1;
MaxP:=X.Count-1;
For P:=0 to MaxP Do
begin
Z:=X.Items[P];
If (Y.R=Z.R) and (Y.G=Z.G) and (Y.B=Z.B) then
   begin
   Result:=P;
   break;
   end;//end of loop
end;//end of loop
except;end;
end;
//## AddRGBToPalette ##
Function AddRGBToPalette(Var X:TColorPalette;Y:TColor24):Integer;
Var
   Add:Boolean;
   P:Integer;
begin{Z=Max Palette Item ie 1-8}
try
{Error}
Result:=-1;
Case (X.Count=0) of
True:P:=-1;
False:P:=FindPaletteRGB(X,Y);
end;//end of case
{Add}
If (P=-1) and (X.Count<=rpccMax) then
   begin
   P:=X.Count;
   X.IntItems[P]:=RGB(Y.R,Y.G,Y.B);
   X.Items[P]:=Y;
   X.Count:=P+1;
   end;//end of if
{Return Result}
Result:=P;
except;end;
end;
//## BuildPalette ##
Function BuildPalette(Var X:TBitmap;Var Pal:TColorPalette;MaxCount:Integer):Boolean;
Label
     SkipEnd;
Var
   C:TByteImage;
   MaxX,MaxY,rX,rY,pI,P,MaxP:Integer;
begin
try
{Error}
Result:=False;
If (X=nil) then exit;
C:=nil;
Pal.Count:=0;
If (MaxCount>(rpccMax+1)) then MaxCount:=rpccMax+1;
{Construct custom palette upto "MaxP" items}
C:=TByteImage.Create;
C.Image:=X;
MaxX:=C.ZeroWidth;
MaxY:=C.ZeroHeight;
For rY:=0 to MaxY Do
begin
 For rX:=0 to MaxX Do
 begin
 pI:=AddRGBToPalette(Pal,C.Pixels[rX,rY]);{max of 256 colors}
 If (pI=-1) or (Pal.Count>=MaxCount) then Goto SkipEnd;
 end;//end of loop
end;//end of loop
SkipEnd:
{Successful}
Result:=True;
except;end;
try;C.Free;except;end;
end;
//## ColorsAsBPP ##
Function ColorsAsBPP(X:Integer):Byte;
begin
try
Case X of
0..2:Result:=1;
3..4:Result:=2;
5..8:Result:=3;
9..16:Result:=4;
17..32:Result:=5;
33..64:Result:=6;
65..128:Result:=7;
129..256:Result:=8;
257..512:Result:=9;
513..1024:Result:=10;
1025..2048:Result:=11;
2049..4096:Result:=12;
4097..8192:Result:=13;
8193..16384:Result:=14;
16385..32768:Result:=15;
32769..65536:Result:=16;
65537..131072:Result:=17;
131073..262144:Result:=18;
262145..524288:Result:=19;
524289..1048576:Result:=20;
1048577..2097152:Result:=21;
2097153..4194304:Result:=22;
4194305..8388608:Result:=23;
8388609..16777216:Result:=24;
else
Result:=1;{1 bit default}
end;//end of case
except;end;
end;


//#################### ByteImage ###############################################
//## Create ##
Constructor TByteImage.Create;
begin
{iImage}
Image:=nil;
end;
//## GetRow ##
Function TByteImage.GetRow(Y:Integer):PRGBColorRow;
begin
try
ReadRow(Y);
Result:=iRow;
except;end;
end;
//## ExpandBits ##
Procedure TByteImage.ExpandBits(X:Byte;Var Y:TByteBuffer);
Var
   A:Byte;
begin
try
//128
A:=0;
If (X>=128) then
   begin
   A:=1;
   X:=X-128;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//64
A:=0;
If (X>=64) then
   begin
   A:=1;
   X:=X-64;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//32
A:=0;
If (X>=32) then
   begin
   A:=1;
   X:=X-32;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//16
A:=0;
If (X>=16) then
   begin
   A:=1;
   X:=X-16;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//8
A:=0;
If (X>=8) then
   begin
   A:=1;
   X:=X-8;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//4
A:=0;
If (X>=4) then
   begin
   A:=1;
   X:=X-4;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//2
A:=0;
If (X>=2) then
   begin
   A:=1;
   X:=X-2;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
//1
A:=0;
If (X>=1) then
   begin
   A:=1;
   X:=X-1;
   end;
Y.Count:=Y.Count+1;
Y.Items[Y.Count-1]:=A;
except;end;
end;
//## SetImage ##
Procedure TByteImage.SetImage(X:TBitmap);
begin
try
If (X=iImage) then exit;
{Set Image}
iImage:=X;
Case (iImage=nil) of
True:begin
    iWidth:=0;
    iHeight:=0;
    end;//end of begin
False:begin
    iWidth:=iImage.Width;
    iHeight:=iImage.Height;
    end;//end of begin
end;//end of case
{ZeroDimensions}
iZeroWidth:=iWidth-1;If (iZeroWidth<0) then iZeroWidth:=0;
iZeroHeight:=iHeight-1;If (iZeroHeight<0) then iZeroHeight:=0;
{MoveTo - twice, 2nd time resets ipX & ipY}
MoveTo(0,0);
MoveTo(0,0);
{Reset Row}
iRowY:=-1;
except;end;
end;
//## MoveTo ##
Function TByteImage.MoveTo(X,Y:Integer):Boolean;
begin
try
iX:=FrcRange(X,-1,iZeroWidth);
iY:=FrcRange(Y,0,iZeroHeight);
except;end;
end;
//## PushPixel ##
Function TByteImage.PushPixel(Var X:TColor24):Boolean;
begin
try
{Out of Range}
Result:=False;
If (iX<0) or (iX>iZeroWidth) or (iY<0) or (iY>iZeroHeight) then exit;
{Process}
Pixels[iX,iY]:=X;
{Increment to Next Position}
iX:=iX+1;
If (iX>iZeroWidth) then
   begin
   iX:=0;
   iY:=iY+1;
   end;//end of if
{Successful}
Result:=True;
except;end;
end;
//## PullPixel ##
Function TByteImage.PullPixel(Var X:TColor24):Boolean;
begin
try
{Out of Range}
Result:=False;
If (iX>iZeroWidth) or (iY>iZeroHeight) then exit;
If (iX<0) then iX:=0;
If (iY<0) then iY:=0;
{Process}
X:=Pixels[iX,iY];
{Increment to Next Position}
iX:=iX+1;
If (iX>iZeroWidth) then
   begin
   iX:=0;
   iY:=iY+1;
   end;//end of if
{Successful}
Result:=True;
except;end;
end;
//## ReadRow ##
Function TByteImage.ReadRow(Y:Integer):Boolean;
begin
try
{Error}
Result:=False;
If (iImage=nil) then exit;
{Ok}
If (iRowY=Y) then
   begin
   Result:=True;
   exit;
   end;//end of if
{Read Row}
iRow:=iImage.ScanLine[Y];
iRowY:=Y;
{Successful}
Result:=True;
except;end;
end;
//## GetPixels ##
Function TByteImage.GetPixels(X,Y:Integer):TColor24;
begin
try
{Enforce Range}
If (X<0) or (X>iZeroWidth) or (Y<0) or (Y>iZeroHeight) then exit;
{Read Row}
If (Y<>iRowY) then ReadRow(Y);
{Read Pixel}
Result:=iRow[X];
except;end;
end;
//## SetPixels ##
Procedure TByteImage.SetPixels(X,Y:Integer;Z:TColor24);
begin
try
{Enforce Range}
If (X<0) or (X>iZeroWidth) or (Y<0) or (Y>iZeroHeight) then exit;
{Read Row}
If (Y<>iRowY) then ReadRow(Y);
{Write Pixel}
iRow[X]:=Z;
except;end;
end;
//## Free ##
Procedure TByteImage.Free;
begin
try
If (Self<>nil) then
   begin
   {Self}
   Self.Destroy;
   end;//end of if
except;end;
end;


//#################### ByteStream ##############################################
//## Create ##
Constructor TByteStream.Create;
begin
{Clear}
Clear;
end;
//## Clear ##
Procedure TByteStream.Clear;
begin
try
//iStream
iStream:=nil;
//iBuffer
iBuffer.Count:=0;
iBuffer.OffSet:=-1;{need to fill}
iBuffer.Modified:=False;
//iSize
iSize:=0;
//SeekMode
SeekMode:=bssmSeekForward;
except;end;
end;
//## SetStream ##
Procedure TByteStream.SetStream(X:TStream);
begin
try
{Process}
Case (X=nil) of
True:Clear;
False:begin
    {Finalise}
    If not Finalise then exit;
    {Hook}
    //iStream
    iStream:=X;
    //iSize
    iSize:=iStream.Size;
    //iBuffer
    iBuffer.Count:=0;
    iBuffer.OffSet:=-1;{Need to fill}
    iBuffer.Modified:=False;
    end;//end of begin
end;//end of case
except;end;
end;
//## Get ##
Function TByteStream.Get(X:Integer;Var Y:Byte):Boolean;
Label
     ReDo;
Var
   pX,bX:Integer;
begin
try
{Error}
Result:=False;
bX:=(X-iBuffer.OffSet);
{Process}
ReDo:
Case (bX>=0) and (bX<iBuffer.Count) of
True:begin
    Y:=iBuffer.Items[bX];
    {Successful}
    Result:=True;
    end;//end of begin
False:begin
    //SeekMode
    Case iSeekMode of
    bssmSeekForward:pX:=X;
    bssmSeekBackward:begin
                  pX:=X-bbccMax;
                  If (pX<0) then pX:=0;
                  end;//end of begin
    bssmSeekMiddle:begin
                  pX:=X-(bbccMax Div 2);
                  If (pX<0) then pX:=0;
                  end;//end of begin
    end;//end of case
    //Seek
    If (iStream.Position<>pX) then iStream.Position:=pX;
    //iBuffer - Null
    iBuffer.OffSet:=iStream.Position;
    iBuffer.Count:=0;
    //Read
    iBuffer.Modified:=False;
    iBuffer.Count:=iStream.Read(iBuffer.Items,bbccMaxSize);
    //Get
    bX:=(X-iBuffer.OffSet);
    If (bX<iBuffer.Count) then Goto ReDo;
    end;//end of begin
end;//end of case
except;end;
end;
//## PushStr ##
Function TByteStream.PushStr(Var X:Integer;Y:String):Boolean;
Var
   P,MinP,MaxP:Integer;
begin
try
{Error}
Result:=False;
MinP:=X;
MaxP:=MinP+Length(Y)-1;
For P:=MinP to MaxP Do
begin
If Not Put(P,Ord(Y[P-MinP+1])) then exit;
X:=P+1;
end;//end of loop
{Successful}
Result:=True;
except;end;
end;
//## Put ##
Function TByteStream.Put(X:Integer;Y:Byte):Boolean;
Label
     ReDo;
Var
   MinP,P,bX:Integer;
   Junk:Byte;
begin
try
{Error}
Result:=False;
{Process}
ReDo:
bX:=(X-iBuffer.OffSet);
Case (bX>=0) and (bX<bbccMaxSize) and (iBuffer.OffSet<>-1) of
True:begin
    iBuffer.Items[bX]:=Y;
    If (bX>=iBuffer.Count) then
       begin
       iBuffer.Count:=bX+1;
       If ((iBuffer.Count+iBuffer.OffSet)>iSize) then iSize:=iBuffer.Count+iBuffer.OffSet;
       end;//end of if
    iBuffer.Modified:=True;
    {Successful}
    Result:=True;
    end;//end of begin
False:begin
    //Write
    If iBuffer.Modified and (iBuffer.Count<>0) then
       begin
       //Seek
       iStream.Position:=iBuffer.OffSet;
       //Error
       If (iBuffer.Count<>iStream.Write(iBuffer.Items,iBuffer.Count)) then
          begin
          iBuffer.Count:=0;
          iBuffer.OffSet:=0;
          iBuffer.Modified:=False;
          exit;
          end;//end of if
       end;//end of if
    //Get
    Get(X,Junk);
    Goto ReDo;
    end;//end of begin
end;//end of case
except;end;
end;
//## Finalise ##
Function TByteStream.Finalise:Boolean;
begin
try
{Error}
Result:=False;
Case ((iStream=nil) or (iBuffer.Count=0)) or (Not iBuffer.Modified) of
True:Result:=True;
False:begin
     //Write Buffer
     iStream.Position:=iBuffer.OffSet;
     Result:=(iStream.Write(iBuffer.Items,iBuffer.Count)=iBuffer.Count);
     end;//end of begin
end;//end of case
except;end;
end;
//## ReadLine ##
Function TByteStream.ReadLine(Var sS:Integer;sF:Integer;Var S,F:Integer;FindByte:Byte;Var FindP:Integer):Boolean;
Label
     SkipOne;
Var
   Val:Byte;
   MinP,MaxP,P2,P:Integer;
begin
try
{Error}
Result:=False;
FindP:=-1;{Not Found}
If (sS<0) then sS:=0;MinP:=sS;
If (sF<0) then sF:=iSize-1;MaxP:=sF;
If (MinP>MaxP) then exit;
{Line Starter}
S:=MinP;
F:=S-1;
For P:=MinP to MaxP Do
begin
{Read Value}
If Not Get(P,Val) then Break;
{FindByte}
If (FindP=-1) and (Val=FindByte) then FindP:=P;
{Line Terminator}
If (Val=10) or (Val=13) or (P=MaxP) then
   begin
   Case (Val=10) or (Val=13) of
   True:F:=P-1;
   False:F:=P;
   end;//end of case
   {Successful}
   Result:=True;
   {Past End of Line}
   Case (P=MaxP) of
   True:sS:=MaxP+1;
   False:begin
        For P2:=P to MaxP Do
        begin
        sS:=P2;
        If Not Get(P2,Val) then Break;
        If (Val<>10) and (Val<>13) then break;
        end;//end of loop
        end;//end of begin
   end;//end of case
   {Exit Loop}
   break;
   end;//end of if
end;//end of loop
except;end;
end;
//## FindByte ##
Function TByteStream.FindByte(X:Byte;S,F:Integer):Integer;
Var
   P:Integer;
   Val:Byte;
begin
try
{Not Found}
Result:=-1;
{Search}
For P:=S to F Do
begin
Case Get(P,Val) of
False:break;
True:If (Val=X) then
        begin
        Result:=P;
        break;
        end;//end of if
end;//end of case
end;//end of loop
except;end;
end;
//## SwapByte ##
Function TByteStream.SwapByte(X,Y:Byte;S,F:Integer):Boolean;
Var
   P:Integer;
   Val:Byte;
begin
try
{Not Found}
Result:=False;
{Search}
For P:=S to F Do
begin
Case Get(P,Val) of
False:break;
True:If (Val=X) and Put(P,Y) then Result:=True;
end;//end of case
end;//end of loop
except;end;
end;
//## AsciiDecimalToBinary ##
Function TByteStream.AsciiDecimalToBinary(S,F,MaxV:Integer;Var X:TWordBuffer):Boolean;
Var
   Count,P:Integer;
   TmpVal:Integer;
   Val:Byte;
   A:TWordBuffer;
begin
try{ie 255<space>0<tab>139<letter>255<etc>170<..>123(ascii decimal) => 255|0|139|255|170|123(8bit binary)}
{Error}
Result:=False;
If (MaxV>High(Word)) or (MaxV=-1) then MaxV:=High(Word);
{Defaults}
TmpVal:=0;
Count:=-1;
{Prepare}
A.Count:=0;
For P:=S to F Do
begin
If Not Get(P,Val) then break;
A.Items[P-S]:=Val;
end;//end of loop
A.Count:=F-S+1;
{Process - Append to "X" buffer}
For P:=(A.Count-1) downTo 0 Do
begin
Val:=A.Items[P];
{Increment TmpVal}
If (Val>=48) and (Val<=57) then
   begin{Digit 0-9}
   If (Count<5) then
      begin
       If (Count<0) then Count:=0;
       Case Count of
       0:TmpVal:=TmpVal+(Val-48);
       1:TmpVal:=TmpVal+((Val-48)*10);
       2:TmpVal:=TmpVal+((Val-48)*100);
       3:TmpVal:=TmpVal+((Val-48)*1000);
       4:TmpVal:=TmpVal+((Val-48)*10000);
       end;//end of case
       {Count: 0=0, 1=10, 2=100, 3=1K, 4=10K, 5+=ignored}
       Count:=Count+1;
       end;//end of if
   end;//end of if
{Add TmpVal to Buffer and Clear}
If (Count<>-1) and ((Val<48) or (Val>57) or (P=0)) then
   begin
   If (X.Count<bbccMaxSize) then
      begin
      X.Count:=X.Count+1;
      {Enforce Max Range}
      If (TmpVal>MaxV) then TmpVal:=MaxV;
      X.Items[X.Count-1]:=TmpVal;
      {Successful}
      Result:=True;
      end;//end of if
   {Reset}
   Count:=-1;
   TmpVal:=0;
   end;//end of if
end;//end of loop
except;end;
end;
//## ByteToXHex ##
Function TByteStream.ByteToXHex(X:Byte;Var Y:TByteBuffer):Boolean;
Var
   A,B:Byte;
begin
try
{Error}
Result:=False;
{Byte -> AB}
A:=X div 16;
B:=X-A*16;
//0
Y.Items[Y.Count]:=48;Y.Count:=Y.Count+1;
//x
Y.Items[Y.Count]:=120;Y.Count:=Y.Count+1;
//A
Case A of
0..9:Y.Items[Y.Count]:=A+48;
10..15:Y.Items[Y.Count]:=A+87;
end;//end of case
Y.Count:=Y.Count+1;
//B
Case B of
0..9:Y.Items[Y.Count]:=B+48;
10..15:Y.Items[Y.Count]:=B+87;
end;//end of case
Y.Count:=Y.Count+1;
{Successful}
Result:=True;
except;end;
end;
//## XHexToBinary ##
Function TByteStream.XHexToBinary(S,F,MaxV:Integer;Var X:TByteBuffer):Boolean;
Label
     SkipOne;
Var
   MinP,P:Integer;
   A,B,Val:Byte;
begin
try{ie ?x00-?xFF -> 0,255}
{Error}
Result:=False;
If (MaxV>High(Byte)) or (MaxV=-1) then MaxV:=High(Byte);
{Process - Append to "X" buffer}
MinP:=-1;
For P:=S to F Do
begin
If Not Get(P,Val) then break;
If (P<=MinP) then Goto SkipOne;
{Increment TmpVal}
If ((Val=88) or (Val=120)) and (X.Count<bbccMaxSize) then
   begin
   MinP:=P+2;
   {?xFF => ?|VAL|AB}
   If Not Get(P+1,A) then break;
   If Not Get(P+2,B) then break;
   {Convert base16 Hex to 8bit binary byte}
   //A
   Case A of
   48..57:A:=A-48;{0-9}
   97..102:A:=A-87;{10-15}
   65..70:A:=A-55;{10-15}
   else
   A:=0;
   end;//end of case
   //B
   Case B of
   48..57:B:=B-48;{0-9}
   97..102:B:=B-87;{10-15}
   65..70:B:=B-55;{10-15}
   else
   B:=0;
   end;//end of case
   X.Items[X.Count]:=B+A*16;
   X.Count:=X.Count+1;
   {Successful}
   Result:=True;
   end;//end of if
SkipOne:
end;//end of loop
except;end;
end;
//## ReadWordValue ##
Function TByteStream.ReadWordValue(Var X:TWordBuffer;Var Y:Integer):Boolean;
Var
   MaxP,P:Integer;
begin
try
{Error}
Result:=False;
If (X.Count=0) then exit;
{Read Next Value}
Y:=X.Items[X.Count-1];
{Delete Last Value}
X.Count:=X.Count-1;
{Successful}
Result:=True;
except;end;
end;
//## SetSeekMode ##
Procedure TByteStream.SetSeekMode(X:Integer);
begin
try;iSeekMode:=FrcRange(X,0,bssmSeekMax);except;end;
end;
//## Str ##
Function TByteStream.Str(S,F:Integer):String;
Var
   Count,P:Integer;
   Val:Byte;
   X:String;
begin
try
{Empty}
Result:='';
X:='';
Count:=0;
{Extract}
For P:=S to F Do
begin
Case Get(P,Val) of
False:break;
True:begin
    Count:=Count+1;
    X:=X+Chr(Val);
    If (Count>=512) then
       begin
       Result:=Result+X;
       X:='';
       end;//end of if
    end;//end of begin
end;//end of case
end;//end of loop
{Return Result}
Result:=Result+X;
except;end;
end;
//## Free ##
Procedure TByteStream.Free;
begin
try
If (Self<>nil) then
   begin
   {Finalise}
   Finalise;
   {Self}
   Self.Destroy;
   end;//end of if
except;end;
end;


//#################### TTextPicture ############################################
//## Create ##
constructor TTextPicture.Create;
begin
{iImage}
iImage:=TBitmap.Create;
Style:=tpscPlain;
BPP:=tpsbDefault;{64 colors}
{Update}
Update;
end;
//## SetBPP ##
Procedure TTextPicture.SetBPP(X:Byte);
begin
try;iBPP:=FrcRange(X,tpsbMinBPP,tpsbMaxBPP);except;end;
end;
//## SetStyle ##
Procedure TTextPicture.SetStyle(X:Byte);
begin
try;iStyle:=FrcRange(X,0,tpscMax);except;end;
end;
//## FromInteger ##
Procedure TTextPicture.FromRGB(X:Integer;Var Y:TByteBuffer;Z:Integer);
Var
   A,B,C,D,E,P:Integer;
begin{No Overflow Protection}
try{3byte -> 4byte}
{Error}
If (X>tpccMaxInt) then X:=tpccMaxInt;
A:=Z*Z*Z;
B:=Z*Z;
C:=Z;
D:=1;
P:=Y.Count;
Y.Count:=Y.Count+4;
//4
E:=X Div A;
Y.Items[P+3]:=E;
X:=X-E*A;
//3
E:=X Div B;
Y.Items[P+2]:=E;
X:=X-E*B;
//2
E:=X Div C;
Y.Items[P+1]:=E;
X:=X-E*C;
//1
E:=X Div D;
Y.Items[P]:=E;
except;end;
end;
//## AsNum ##
Function TTextPicture.AsNum(Var X:Byte):Boolean;
begin
try
{Successful}
Result:=True;
{Process}
Case X of
48..57:X:=X-48;{0-9=10 "0..9"}
65..90:X:=X-55;{10-35=26 "A..Z"}
97..122:X:=X-61;{36-61=26 "a..z"}
40..41:X:=X+22;{62-63=2 "(..)"}
else
{Error: out of range}
Result:=False;
end;//end of case
except;end;
end;
//## AsByte ##
Function TTextPicture.AsByte(Var X:Byte):Boolean;
begin
try
{Successful}
Result:=True;
{Process}
Case X of
0..9:X:=X+48;{0-9=10 "0..9"}
10..35:X:=X+55;{10-35=26 "A..Z"}
36..61:X:=X+61;{36-61=26 "a..z"}
62..63:X:=X-22;{62-63=2 "(..)"}
else
{Error: out of range}
Result:=False;
end;//end of case
except;end;
end;
//## AsInteger ##
Function TTextPicture.AsInteger(Var X:TByteBuffer;Y:Integer):Integer;
Var
   A,P:Integer;
begin{No Overflow Protection}
try
{Default}
Result:=0;
A:=0;
{Process}
For P:=0 to (X.Count-1)Do
begin
Case P of
0:A:=X.Items[P];
1:A:=X.Items[P]*Y;
2:A:=X.Items[P]*Y*Y;
3:A:=X.Items[P]*Y*Y*Y;
4:A:=X.Items[P]*Y*Y*Y*Y;
5:A:=X.Items[P]*Y*Y*Y*Y*Y;
end;//end of case
Result:=Result+A;
If (P=5) then break;
end;//end of loop
except;end;
end;
//## Draw ##
procedure TTextPicture.Draw(ACanvas: TCanvas; const Rect: TRect);
begin;ACanvas.StretchDraw(Rect,iImage);end;
//## GetEmpty ##
function TTextPicture.GetEmpty:Boolean;
begin;Result:=iImage.Empty;end;
//## GetHeight ##
function TTextPicture.GetHeight:Integer;
begin;Result:=iImage.Height;end;
//## GetWidth ##
function TTextPicture.GetWidth:Integer;
begin;Result:=iImage.Width;end;
//## SetHeight ##
procedure TTextPicture.SetHeight(Value:Integer);
begin;iImage.Height:=Value;Update;end;
//## SetWidth ##
procedure TTextPicture.SetWidth(Value:Integer);
begin;iImage.Width:=Value;Update;end;
//## LoadFromClipboardFormat ##
procedure TTextPicture.LoadFromClipboardFormat(AFormat:Word;AData:THandle;APalette:HPALETTE);
begin;iImage.LoadFromClipboardFormat(AFormat,AData,APalette);Update;end;
//## SaveToClipboardFormat ##
procedure TTextPicture.SaveToClipboardFormat(var Format: Word; var Data: THandle; var APalette: HPALETTE);
begin;iImage.SaveToClipboardFormat(Format,Data,APalette);Update;end;
//## Destroy ##
Destructor TTextPicture.Destroy;
begin
iImage.Free;
inherited Destroy;
end;
//## Update ##
Procedure TTextPicture.Update;
begin
try;iImage.PixelFormat:=pf24bit;except;end;
end;
//## Progress ##
procedure TTextPicture.Progress(Sender: TObject;Stage:TProgressStage;PercentDone:Byte;RedrawNow:Boolean;const R:TRect;const Msg:string);
begin
try
iLastTimerIndex:=GetCurrentTime;
if Assigned(FOnProgress) then FOnProgress(Sender,Stage,PercentDone,RedrawNow,R,Msg);
except;end;
end;
//## Progressing ##
procedure TTextPicture.Progressing(PercentDone:Byte;const Msg:string);
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
Procedure TTextPicture.Assign(Source: TPersistent);
Var
   A:TBitmap;
begin
If (Source is TTextPicture) then
   begin
   CopyFrom((Source as TTextPicture).Image);
   Style:=(Source as TTextPicture).Style;
   BPP:=(Source as TTextPicture).BPP;
   end
else If (Source is TGraphic) then CopyFrom(Source as TGraphic)
else iImage.Assign(Source);
{Update}
Update;
end;
//## CopyFrom ##
Procedure TTextPicture.CopyFrom(X:TGraphic);
begin
try
{Size}
iImage.Width:=X.Width;
iImage.Height:=X.Height;
{Cls}
iImage.Canvas.Brush.Color:=clWhite;
iImage.Canvas.FillRect(Rect(0,0,iImage.Width,iImage.Height));
{Paint}
iImage.Canvas.Draw(0,0,X);
except;end;
end;
//## FreeImage ##
Procedure TTextPicture.FreeImage;
begin
try;iImage.FreeImage;except;end;
end;
//## Dormant ##
Procedure TTextPicture.Dormant;
begin
try;iImage.Dormant;except;end;
end;
//## LoadFromFile ##
Function TTextPicture.LoadFromStr(Var X:String):Boolean;
Var
   iStream:TStringStream;
begin
try
{Error}
Result:=False;
iStream:=nil;
{Open Stream}
iErrorMessage:=gecOutOfMemory;
iStream:=TStringStream.Create(X);
{LoadFromStream}
LoadFromStream(iStream);
{Successful}
Result:=True;
except;end;
try;iStream.Free;except;end;
end;
//## LoadFromFile ##
Function TTextPicture.LoadFromFile(X:String):Boolean;
Var
   iStream:TStream;
begin
try
{Error}
Result:=False;
iStream:=nil;
{Open Stream}
iErrorMessage:=gecFileNotFound;
If Not FileExists(X) then exit;
iErrorMessage:=gecFileInUse;
iStream:=TFileStream.Create(X,fmOpenRead+fmShareDenyNone);
{LoadFromStream}
LoadFromStream(iStream);
{Successful}
Result:=True;
except;end;
try;iStream.Free;except;end;
end;
//## SaveToStr ##
Function TTextPicture.SaveToStr(Var X:String):Boolean;
Label
     SkipEnd;
Var
   iStream:TStringStream;
begin
try
{Error}
Result:=False;
iStream:=nil;
{Create Stream}
iErrorMessage:=gecOutOfMemory;
iStream:=TStringStream.Create(X);
iStream.Position:=iStream.Size-1;
{SaveToStream}
SaveToStream(iStream);
{Return Result}
X:=iStream.DataString;
{Successful}
Result:=True;
SkipEnd:
except;end;
try;iStream.Free;except;end;
end;
//## SaveToFile ##
Function TTextPicture.SaveToFile(X:String):Boolean;
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
try;iStream.Free;except;end;
end;
//## ReadHeader ##
Function TTextPicture.ReadHeader(X:TStream;Var rBPP:Byte;Var W,H:Integer;Var Pal:TColorPalette):Boolean;
Label
     PreSkipEnd,SkipEnd,ReDo;
Var
   A:TByteStream;
   B:TByteBuffer;
   CommentCount,Count,pCount,P,C,Pos:Integer;
   Val:Byte;
   Z:TColor24;
   EOP,EOF:Boolean;
   tmp:tint4;
begin
try
{Error}
Result:=False;
rBPP:=tpsbDefault;{64 Colors}
W:=0;
H:=0;
Pal.Count:=0;
A:=nil;
If (X=nil) then exit;
{A}
A:=TByteStream.Create;
A.Stream:=X;
{Defaults}
CommentCount:=0;
EOF:=False;
EOP:=False;
Pos:=X.Position;
B.Count:=0;
Count:=0;
pCount:=0;
{Read}
ReDo:
If Not A.Get(Pos,Val) then Goto SkipEnd;
//Start Comment
Case Val of
tpccStartComment:CommentCount:=CommentCount+1;{Start of Embedded Comment}
tpccEndComment:CommentCount:=CommentCount-1;{End of Embedded Comment}
tpccEOF:If (CommentCount=0) then EOF:=True;{End of File}
tpccEOP:If (CommentCount=0) then EOP:=True;{End of Palette and Header}
else
 If (CommentCount=0) and AsNum(Val) then
    begin
    {Process Header}
    Case Count of
    {T}
    0:If (Val=tpccSOF) then Count:=Count+1;
    {Bits/Per/Pixel 1-6}
    1:Case (Val>=tpsbMinBPP) and (Val<=tpsbMaxBPP) of
      True:begin
          rBPP:=Val;
          Pal.Count:=rpccBPPS[rBPP];{bpp:color}
          {Standard Palette}
          If Not StdPalette(Pal) then Goto SkipEnd;
          Count:=Count+1;
          end;//end of begin
      False:Goto SkipEnd;{Unsupported bbp 1-3 only}
      end;//end of case
    {Width/Height}
    2,3:begin
      If (B.Count<3) then
         begin
         B.Items[B.Count]:=Val;
         B.Count:=B.Count+1;
         If (B.Count>=3) then
            begin
            Case Count of
            2:W:=AsInteger(B,64);{Width}
            3:H:=AsInteger(B,64);{Height}
            end;//end of case
            Count:=Count+1;
            B.Count:=0;
            end;//end of loop
         end;//end of if
      end;//end of begin
    {Palette 1-x}
    4:begin
      If (B.Count<4) then
         begin
         B.Items[B.Count]:=Val;
         B.Count:=B.Count+1;
         If (B.Count>=4) then
            begin
            {Color as Integer}
            C:=AsInteger(B,64);
            {Integer => RGB}
            tmp.val:=c;
            Pal.Items[pCount].R:=tmp.r;
            Pal.Items[pCount].G:=tmp.g;
            Pal.Items[pCount].B:=tmp.b;
            pCount:=pCount+1;
            B.Count:=0;
            {Terminate Palette Processing}
            If (pCount>=Pal.Count) then Count:=Count+1;;
            end;//end of if
         end;//end of if
      end;//end of begin
    5:{null - wait for EOP or EOP}
    end;//end of case
    end;//end of if
end;//end of case
{Loop}
If (Not EOP) and (Not EOF) then
   begin
   Pos:=Pos+1;
   Goto ReDo;
   end;//end of if
PreSkipEnd:
{Successful}
Result:=EOP and (rBPP>0) and (W>0) and (H>0);
{Align Stream}
X.Position:=Pos+1;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## CountBPP ##
Function TTextPicture.CountBPP:Byte;
Var
   PalIntArray:TIntPalette;
   PalArray:TRGBPalette;
   Pal:TColorPalette;
begin
try
{Error}
Result:=tpsbMinBPP;
{Setup Palette}
Pal.Items:=@PalArray;
Pal.IntItems:=@PalIntArray;
Pal.Count:=0;{empty}
{Return Result}
If BuildPalette(iImage,Pal,rpccBPPS[tpsbMaxBPP]) then Result:=ColorsAsBPP(Pal.Count);
except;end;
end;
//## WriteHeader ##
Function TTextPicture.WriteHeader(X:TStream;Var Y:TBitmap;rBPP,W,H:Integer;Var Pal:TColorPalette):Boolean;
Label
     SkipEnd;
Var
   A:TByteStream;
   B:TByteBuffer;
   PalCount,P2,P,Pos:Integer;
   Val:Byte;
   Z:TColor24;
begin
try
{Error}
Result:=False;
A:=nil;
If (X=nil) then exit;
If (Y=nil) then exit;
{Unsupported Bits/Per/Pixel}
If (rBPP<tpsbMinBPP) or (rBPP>tpsbMaxBPP) then exit;
{A}
A:=TByteStream.Create;
A.Stream:=X;
{Defaults}
Pos:=X.Position;
B.Count:=0;
Pal.Count:=0;
{Write}
{T}
If Not A.Put(Pos,84) then Goto SkipEnd;
Pos:=Pos+1;
{Version 1}
Val:=rBPP;
If Not AsByte(Val) then Goto SkipEnd;
If Not A.Put(Pos,Val) then Goto SkipEnd;
Pos:=Pos+1;
{Width & Height}
For P2:=0 to 1 Do
begin
B.Count:=0;
Case P2 of
0:FromRGB(W,B,64);
1:FromRGB(H,B,64);
end;//end of case
If (B.Count<>4) then Goto SkipEnd;
For P:=0 to (B.Count-2) Do{Write frist 3 bytes only}
begin
If Not AsByte(B.Items[P]) then Goto SkipEnd;
If Not A.Put(Pos,B.Items[P]) then Goto SkipEnd;
Pos:=Pos+1;
end;//end of loop
end;//end of loop
{Palette}
//Custom Palette
Pal.Count:=0;{empty}
If Not BuildPalette(Y,Pal,rpccBPPS[rBPP]) then Goto SkipEnd;{2-8 colors max}
//Palette - Variable length palette (2-64)
For P:=0 to (Pal.Count-1) Do
begin
B.Count:=0;
FromRGB(Pal.IntItems[P],B,64);
If (B.Count<>4) then Goto SkipEnd;
//Write Palette Entry
For P2:=0 to (B.Count-1) Do
begin
If Not AsByte(B.Items[P2]) then Goto SkipEnd;
If Not A.Put(Pos,B.Items[P2]) then Goto SkipEnd;
Pos:=Pos+1;
end;//end of loop
end;//end of loop
//Palette Terminator EOP
If Not A.Put(Pos,tpccEOP) then Goto SkipEnd;
{Successful}
Result:=True;
{Align Stream}
X.Position:=Pos+1;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## ExpandPixels ##
Function TTextPicture.ExpandPixels(X,bpp:Byte;Var Y:TByteBuffer;Z:Integer):Boolean;
Var
   A:Byte;
begin
try
{Error}
Result:=False;
Case bpp of
4..6:begin{16/32/64 color : (0-63) }
  If (X>Z) then X:=Z;
  Y.Items[Y.Count]:=X;
  Y.Count:=Y.Count+1;
  end;//end of begin
3:begin{8 color : (0-7) + (0-7)*8 }
  Y.Count:=Y.Count+2;
  //A
  A:=X Div 8;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-1]:=A;
  X:=X-(A*8);
  //B
  A:=X;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-2]:=A;
  end;//end of begin
2:begin{4 color : (0-3) + (0-3)*4 + (0-3)*16 }
  Y.Count:=Y.Count+3;
  //A
  A:=X Div 16;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-1]:=A;
  X:=X-(A*16);
  //B
  A:=X Div 4;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-2]:=A;
  X:=X-(A*4);
  //C
  A:=X;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-3]:=A;
  end;//end of begin
1:begin{2 color : (0-1) + (0-1)*2 + (0-1)*4 + (0-1)*8 + (0-1)*16 + (0-1)*32 }
  Y.Count:=Y.Count+6;
  //A
  A:=X Div 32;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-1]:=A;
  X:=X-(A*32);
  //B
  A:=X Div 16;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-2]:=A;
  X:=X-(A*16);
  //C
  A:=X Div 8;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-3]:=A;
  X:=X-(A*8);
  //D
  A:=X Div 4;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-4]:=A;
  X:=X-(A*4);
  //E
  A:=X Div 2;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-5]:=A;
  X:=X-(A*2);
  //F
  A:=X;
  If (A>Z) then A:=Z;
  Y.Items[Y.Count-6]:=A;
  end;//end of begin
else
 exit;{Unknown bpp}
end;//end of case
{Successful}
Result:=True;
except;end;
end;
//## ReadHeader ##
Function TTextPicture.AsciiReader(X:TStream;rBPP:Integer;Var Y:TBitmap;Var Pal:TColorPalette):Boolean;
Label
     PreSkipEnd,SkipEnd,ReDo;
Var
   A:TByteStream;
   B:TByteBuffer;
   C:TByteImage;
   MaxPos,MaxX,MaxY,CommentCount,Count,MaxP,P,Pos:Integer;
   Val:Byte;
   Z:TColor24;
   EOF:Boolean;
begin
try
{Error}
Result:=False;
A:=nil;
If (X=nil) then exit;
{A}
A:=TByteStream.Create;
A.Stream:=X;
C:=TByteImage.Create;
C.Image:=Y;
{Defaults}
CommentCount:=0;
EOF:=False;
Pos:=X.Position;
Count:=0;
MaxX:=C.ZeroWidth;
MaxY:=C.ZeroHeight;
MaxP:=Pal.Count-1;
MaxPos:=X.Size;
B.Count:=0;
{Read}
ReDo:
If Not A.Get(Pos,Val) then Goto PreSkipEnd;
//Progress
Count:=Count+1;
If (Count>=10000) then
   begin
   {Progress}
   Progressing((Pos+1)*100 Div MaxPos,'Loading');
   Count:=0;
   end;//end of if
//Start Comment
Case Val of
tpccStartComment:CommentCount:=CommentCount+1;
tpccEndComment:CommentCount:=CommentCount-1;
tpccEOF:If (CommentCount=0) then EOF:=True;
else
 If (CommentCount=0) and AsNum(Val) then
    begin
    {Split into palette referenced pixels}
    B.Count:=0;
    If Not ExpandPixels(Val,rBPP,B,MaxP) then Goto PreSkipEnd;
    {Implement Pixels}
    For P:=0 to (B.Count-1) Do
    begin
    If Not C.PushPixel(Pal.Items[B.Items[P]]) then Goto PreSkipEnd;
    end;//end of loop
    end;//end of if
end;//end of case
{Loop}
If Not EOF then
   begin
   Pos:=Pos+1;
   Goto ReDo;
   end;//end of if
PreSkipEnd:
{Successful}
Result:=True;
{Align Stream}
X.Position:=Pos+1;
SkipEnd:
except;end;
try;A.Free;C.Free;except;end;
end;
//## CondensePixels ##
Function TTextPicture.CondensePixels(Var X:TByteBuffer;bpp:Byte;Var Z:Byte):Boolean;
Var
   A:Byte;
   P:Integer;
begin
try
{Error}
Result:=False;
Z:=0;
Case bpp of
4..6:begin{16/32/64 color : (0-63) }
  Z:=X.Items[X.Count-1];
  end;//end of begin
3:begin{8 color : (0-7) + (0-7)*8 }
  For P:=0 to 1 Do
  begin
  Case P of
  0:Z:=Z+X.Items[P];
  1:Z:=Z+X.Items[P]*8;
  end;//end of case
  end;//end of loop
  end;//end of begin
2:begin{4 color : (0-3) + (0-3)*4 + (0-3)*16 }
  For P:=0 to 2 Do
  begin
  Case P of
  0:Z:=Z+X.Items[P];
  1:Z:=Z+X.Items[P]*4;
  2:Z:=Z+X.Items[P]*16;
  end;//end of case
  end;//end of loop
  end;//end of begin
1:begin{2 color : (0-1) + (0-1)*2 + (0-1)*4 + (0-1)*8 + (0-1)*16 + (0-1)*32 }
  For P:=0 to 5 Do
  begin
  Case P of
  0:Z:=Z+X.Items[P];
  1:Z:=Z+X.Items[P]*2;
  2:Z:=Z+X.Items[P]*4;
  3:Z:=Z+X.Items[P]*8;
  4:Z:=Z+X.Items[P]*16;
  5:Z:=Z+X.Items[P]*32;
  end;//end of case
  end;//end of loop
  end;//end of begin
else
 exit;{Unknown bpp}
end;//end of case
{Successful}
Result:=True;
except;end;
end;
//## WriteSep ##
Function TTextPicture.WriteSep(X:TByteStream;Var Pos:Integer;Style:Integer;EOL:Boolean):Boolean;
begin
try
{Error}
Result:=False;
Case Style of
tpscBlocks:begin{"'+'"}
     If Not X.Put(Pos,39) then exit;
     Pos:=Pos+1;
     If Not X.Put(Pos,43) then exit;
     Pos:=Pos+1;
     {Return Code}
     If EOL then
        begin
        If Not X.Put(Pos,13) then exit;
        Pos:=Pos+1;
        If Not X.Put(Pos,10) then exit;
        Pos:=Pos+1;
        end;//end of if
     If Not X.Put(Pos,39) then exit;
     Pos:=Pos+1;
     end;//end of begin
tpscLines:begin{"RCode"}
     If Not X.Put(Pos,13) then exit;
     Pos:=Pos+1;
     If Not X.Put(Pos,10) then exit;
     Pos:=Pos+1;
     end;//end of begin
end;//end of case
{Successful}
Result:=True;
except;end;
end;
//## AsciiWriter ##
Function TTextPicture.AsciiWriter(X:TStream;S,rBPP:Integer;Var Y:TBitmap;Var Pal:TColorPalette):Boolean;
Label
     SkipEnd,ReDo;
Var
   A:TByteStream;
   B:TByteBuffer;
   C:TByteImage;
   Row:PRGBColorRow;
   pCount2,pCount,bMax,pMax,Count,pI,rX,rY,MaxX,MaxY,P,Pos:Integer;
   Val:Byte;
   Z:TColor24;
begin
try
{Error}
Result:=False;
A:=nil;
If (X=nil) then exit;
{Unsupported bpp}
If (rBPP<tpsbMinBPP) or (rBPP>tpsbMaxBPP) then exit;
{A}
A:=TByteStream.Create;
A.Stream:=X;
C:=TByteImage.Create;
C.Image:=Y;
{Defaults}
Pos:=X.Position;
MaxX:=C.ZeroWidth;
MaxY:=C.ZeroHeight;
{Clear B array}
bMax:=tpsbBPPAsPixels[rBPP];{bpp:#pixels}
For P:=0 to (bMax-1) Do B.Items[P]:=0;
B.Count:=0;
{Separator Setup}
Count:=0;
If Not WriteSep(A,Pos,S,False) then Goto SkipEnd;
pCount:=0;
pCount2:=1;
Case S of
tpscBlocks:pMax:=250;
tpscLines:pMax:=68;{lines never exceed 70 characters}
else
pMax:=-1;
end;//end of case
{Write}
For rY:=0 to MaxY Do
begin
Progressing((rY+1)*100 Div (MaxY+1),'Saving');
Row:=C.Row[rY];
 For rX:=0 to MaxX Do
 begin
 pI:=FindPaletteRGB(Pal,Row[rX]);
 {Use palette entry 1(0) if color not found}
 If (pI=-1) then pI:=0;
 B.Items[B.Count]:=pI;
 B.Count:=B.Count+1;
 If (B.Count>=bMax) then
    begin
    {Condense Xpixels into 1byte}
    If Not CondensePixels(B,rBPP,Val) then Goto SkipEnd;
    {Write Byte}
    If Not AsByte(Val) then
       begin
       Goto SkipEnd;
       end;//end of if
    If Not A.Put(Pos,Val) then Goto SkipEnd;
    B.Count:=0;
    Pos:=Pos+1;
    {Seperator}
    If (pMax<>-1) then
       begin
       pCount:=pCount+1;
       If (pCount>=pMax) then
          begin
          pCount2:=pCount2+1;
          pCount:=0;
          If Not WriteSep(A,Pos,S,(S=tpscBlocks) and (pCount2>=4)) then Goto SkipEnd;
          If (pCount2>=4) then pCount2:=0;
          end;//end of if
       end;//end of if
    end;///end of if
 end;//end of loop
end;//end of loop
{Write any unfinished pixels}
If (B.Count<>0) then
   begin
   {Condense Xpixels into 1byte}
   If Not CondensePixels(B,rBPP,Val) then Goto SkipEnd;
   B.Count:=0;
   {Write Byte}
   If Not AsByte(Val) then Goto SkipEnd;
   If Not A.Put(Pos,Val) then Goto SkipEnd;
   Pos:=Pos+1;
   end;//end of if
{Write EOF}
Val:=tpccEOF;
If Not A.Put(Pos,Val) then Goto SkipEnd;
Pos:=Pos+1;
{Successful}
Result:=True;
{Align Stream}
X.Position:=Pos+1;
SkipEnd:
except;end;
try;A.Free;C.Free;except;end;
end;
//## LoadFromStream ##
Procedure TTextPicture.LoadFromStream(X:TStream);
Label
     SkipEnd;
Var
   PalIntArray:TIntPalette;
   PalArray:TRGBPalette;
   Pal:TColorPalette;
   rBPP:Byte;
   W,H:Integer;
   ErrMsg:String;
begin
try
ErrMsg:=gecOutOfMemory;
Progress(Self,psStarting,0,False,Rect(0,0,Width,Height),'Loading');
{Setup Palette}
Pal.Items:=@PalArray;
Pal.IntItems:=@PalIntArray;
Pal.Count:=0;{empty}
{Update}
Update;
{Read Header}
If Not ReadHeader(X,rBPP,W,H,Pal) then
   begin
   ErrMsg:=gecUnknownFormat;
   Goto SkipEnd;
   end;//end of if
{Check Version}
If (rBPP<tpsbMinBPP) or (rBPP>tpsbMaxBPP) then
   begin
   ErrMsg:=gecUnexpectedError;
   Goto SkipEnd;
   end;//end of if
{Check W&H}
If (W<=0) or (H<=0) then
   begin
   ErrMsg:=gecUnexpectedError;
   Goto SkipEnd;
   end;//end of if
{Implement Header}
iImage.Width:=W;
iImage.Height:=H;
iImage.PixelFormat:=pf24bit;
{Clear}
iImage.Canvas.Brush.Color:=clWhite;
iImage.Canvas.FillRect(Rect(0,0,iImage.Width,iImage.Height));
{Data}
If Not AsciiReader(X,rBPP,iImage,Pal) then Goto SkipEnd;
{No Error}
ErrMsg:='';
SkipEnd:
except;end;
try;Progress(Self,psEnding,100,False,Rect(0,0,Width,Height),'Loading');except;end;
{Raise Error if any}
DoErr(ErrMsg);
end;
//## StdPalette ##
Function TTextPicture.StdPalette(Var Pal:TColorPalette):Boolean;
Var
   MaxP,P:Integer;
begin
try
{Error}
Result:=False;
MaxP:=High(rpccPal8);
{Standard 8 Color Palette}
For P:=0 to (Pal.Count-1) Do
begin
Case (P<=MaxP) of
True:Pal.IntItems[P]:=rpccPal8[P];
False:Pal.IntItems[P]:=0;{black}
end;//end of case
Pal.Items[P]:=IntToRGB(Pal.IntItems[P]);
end;//end of loop
{Successful}
Result:=True;
except;end;
end;
//## SaveToStream ##
Procedure TTextPicture.SaveToStream(X:TStream);
Label
     SkipEnd;
Var
   PalIntArray:TIntPalette;
   PalArray:TRGBPalette;
   Pal:TColorPalette;
   rStyle,rBPP:Byte;
   ErrMsg:String;
begin
try
ErrMsg:=gecOutOfMemory;
Progress(Self,psStarting,0,False,Rect(0,0,Width,Height),'Saving');
{rBPP}
rBPP:=iBPP;
rStyle:=Style;
{Update}
Update;
{Setup Palette}
Pal.Items:=@PalArray;
Pal.IntItems:=@PalIntArray;
Pal.Count:=0;{empty}
{Write Header - Version 1}
If Not WriteHeader(X,iImage,rBPP,Width,Height,Pal) then Goto SkipEnd;
{Data}
If Not AsciiWriter(X,rStyle,rBPP,iImage,Pal) then Goto SkipEnd;
{No Error}
ErrMsg:='';
SkipEnd:
except;end;
try;Progress(Self,psEnding,100,False,Rect(0,0,Width,Height),'Saving');except;end;
{Raise Error if any}
DoErr(ErrMsg);
end;
//## DoErr ##
Procedure TTextPicture.DoErr(X:String);
begin
{Raise Error if any}
If (X<>'') then
   begin
   iErrorMessage:=X;
   raise EGeneralError.Create(X);
   end;//end of if
end;
//## ShowError ##
Procedure TTextPicture.ShowError;
begin
try;General.ShowError(iErrorMessage);except;end;
end;
//## Glyph ##
Function TTextPicture.Glyph(X:String):TBitmap;
begin
try
{Image}
Result:=TBitmap.Create;
{Load}
If LoadFromStr(X) then
   begin
   Result.PixelFormat:=pf24bit;
   Result.Width:=iImage.Width;
   Result.Height:=iImage.Height;
   Result.Canvas.Draw(0,0,iImage);
   end;//end of if
except;end;
end;

initialization
  {Start}
  rgbBlack.R:=0;
  rgbBlack.G:=0;
  rgbBlack.B:=0;

finalization
  {Finish}

end.
