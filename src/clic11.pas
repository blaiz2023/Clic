unit clic11;
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

{$define jpeg}//enable this option for jpeg related operations, e.g. Jpeg image support for "twordcore" - 02jun2020
//{$define nojpeg}//only one jpeg mode at any one time
{$define w32}//Windows 32bit

interface

uses
  Jpeg,//optional - ensure "jpeg" above is enaged as well
  Windows, Forms, Controls, SysUtils, Classes, ShellApi, ShlObj, Graphics,
  Clipbrd, messages, math, stdctrls{tmemo}, extctrls{tpanel}, filectrl{tdrivetype},
  {startup link "tmisc.csl"}
  ActiveX, ComObj, registry,
  clic12;

//##############################################################################
//## Description: Low level support procs                                     ##
//## Purpose:     Retro-fit vintage programs with modern code                 ##
//## Date:        14jul2020, 04jul2020, 09jun2020, 07mar2020                  ##
//## Version:     1.00.472                                                    ##
//## Copyright (c) 1997-2020 Blaiz Enterprises                                ##
//##############################################################################

const
   {MAXPOINTER/MAXPIXEL}
   maxpointer     =(maxint div sizeof(pointer))-1;
   maxpixel       =maxint div 50;//safe even for large color sets such as "tcolor96" - 29apr2020
   maxrow         =(high(word)*10);//safe range (0..655,360) - 11OCT2008
   maxword        =high(word);
     //.int
     minint=low(integer);
     minintS4=#0#0#0#128;//08may2015
     maxintS4=#255#255#255#127;//08mat2015
     //.cur
     mincur=-922337203685477.5807;//note: 0.5808 exceeds range
     maxcur=922337203685477.5807;
     //.comp3
     maxcmp32=4294967294.0;//actual max is 4294967295, but ".0" rounds it up, hence the "..294.0" - 16dec2016
     //.comp 64bit - whole number range - 24jan2016
     max64= 999999999999999999.0;//18 whole digits - 1 million terabytes
     min64=-999999999999999999.0;//18 whole digits - 1 million terabytes
     //.other
     UDPpacketlimit=65507;//wikipedia.org 21DEC2007
     UDPdatalimit=UDPpacketlimit-8;//8 bytes for UDP header - size is header inclusive
     //Standard Safe Return Code
     rcode=#13#10;
     //G.E.C. General Error Codes v1.00.028, 22-JUN-2005
     gecFailedtoencrypt        ='Failed to encrypt';//20jun2016
     gecFileInUse              ='File in use / access denied';//translate('File in use / access denied')
     gecNotFound               ='Not found';//translate('Not found')
     gecBadFileName            ='Bad file name';//translate('Bad file name')
     gecFileNotFound           ='File not found';//translate('File not found')
     gecUnknownFormat          ='Unknown format';//translate('Unknown format')
     gecTaskCancelled          ='Task cancelled';//translate('Task cancelled')
     gecPathNotFound           ='Path not found';//translate('Path not found')
     gecOutOfMemory            ='Out of memory';//translate('Out of memory')
     gecIndexOutOfRange        ='Index out of range';//translate('Index out of range')
     gecUnexpectedError        ='Unexpected error';//translate('Unexpected error')
     gecDataCorrupt            ='Data corrupt';//translate('Data corrupt')
     gecUnsupportedFormat      ='Unsupported format';//translate('Unsupported format')
     gecAccessDenied           ='Access Denied';{04/11/2002}//translate('Access Denied')
     gecOutOfDiskSpace         ='Out of disk space';//translate('Out of disk space')
     gecAProgramExistsWithThatName='A program exists with that name';//translate('A program exists with that name')
     gecUseAnother             ='Use another';//translate('Use another')
     gecSendToFailed           ='Send to failed';//translate('Send to failed')
     gecCapacityReached        ='Capacity reached';//translate('Capacity reached')
     gecNoFilesFound           ='No files found';//translate('No files found')
     gecUnsupportedEncoding    ='Unsupported encoding';//translate('Unsupported encoding')
     gecUnsupportedDecoding    ='Unsupported decoding';//translate('Unsupported decoding')
     gecEmpty                  ='Empty';//translate('Empty')
     gecLocked                 ='Locked';//translate('Locked')
     gecTaskFailed             ='Task failed';//translate('Task failed')
     gecTaskSuccessful         ='Task successful';//translate('Task successful')
     //New 16/08/2002
     gecVirusWarning           ='Virus Warning - Tampering detected';//translate('Virus Warning - Tampering detected')
     gecTaskTimedOut           ='Task Timed Out';//translate('Task Timed Out')
     gecIncorrectUnlockInformation='Incorrect Unlock Information';//Translate('Incorrect Unlock Information');
     gecOk                     ='OK';//translate('OK');
     gecReadOnly               ='Read Only';//translate('Read Only');
     gecRepeat                 ='Repeat';//translte('Repeat');
     gecBusy                   ='Busy';//translate('Busy');
     gecReady                  ='Ready';//translate('Ready');
     gecWorking                ='Working';//translate('Working');
     gecSearching              ='Searching';//translate('Searching');
     gecNoFurtherMatchesFound  ='No further matches found';//translate('No further matches found');
     gecAccessGranted          ='Access Granted';//Translate('Access Granted') - [bait]
     gecFailed                 ='Failed';//Translate('Failed') - [bait]
     gecDeleted                ='Deleted';//Translate('Deleted') - [bait]
     gecSkipped                ='Skipped';//Translate('Skipped') - [bait]
     gecEXTnotAllowed          ='Extension not allowed';//Translate('Extension not allowed') - [bait]
     gecSaved                  ='Saved';//Translate('Saved')
     gecNoContent              ='No content';//Translate('No content present') - [bait]
     gecSyntaxError            ='Invalid syntax';//translate('Invalid syntax') - [bait]
     gecUnterminatedLine       ='Unterminated line';//translate('Unterminated line') - [bait]
     gecUnterminatedString     ='Unterminated string';//translate('Unterminated string') - [bait]
     gecUndefinedObject        ='Undefined Object';//translate('Undefined Object') - [bait]
     gecPrivilegesModified     ='Privileges Modified';//Translate('Privileges Modified') - [bait]
     gecConnectionFailed       ='Connection Failed';//translate('Connection Failed');
     gecTimedOut               ='Timed Out';//translate('Timed Out');
     //new 03DEC2009
     gecNoPrinter              ='No Printer';
     gecBadName                ='Bad Name';//11APR2010

     //MessageBox
     mbCustom=$0;
     mbError=$10;
     mbInformation=$40;
     mbWarning=$30;
     mbrYes=6;
     mbrNo=7;

     //modes
     glseEncrypt=0;
     glseDecrypt=1;
     glseTextEncrypt=2;
     glseTextDecrypt=3;
     //other
     glseEDK='2-13-09afdklJ*[q-02490-9123poasdr90q34[9q2u3-[9234[9u0w3689yq28901iojIOJHPIae;riqu58pq5uq9531asdo';
     //compression.header
     tiocmCompressed='C!1';//compressed
     tiocmRaw='C!0';//raw

     //base64 - references
     base64:array[0..64] of char=('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/','=');
     base64r:array[0..255] of char='qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqnqqqodefghijklmqqqpqqq0123456789:;<=>?@ABCDEFGHIqqqqqqJKLMNOPQRSTUVWXYZ[\]^_`abcqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq'+'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq';

    //program control related
    pcSymSafe        ='-';//used to replace unsafe filename characters

{zip}
    zlib_Version = '1.0.4';
{tio}
    tio1MB=1024000;
    tio1GB=1024000000;
    tio2Gb=2048000000;
    tioNiceArchiveSizeMB=650;

type
   pwordcore=^twordcore;
   tmask8=class;
   //.color
   pcolor8       =^tcolor8;      tcolor8 =byte;
   pcolor16      =^tcolor16;     tcolor16=word;
   pcolor24      =^tcolor24;     tcolor24=packed record b:byte;g:byte;r:byte;end;//shoulde be packed for safety - 27SEP2011
   pcolor32      =^tcolor32;     tcolor32=packed record b:byte;g:byte;r:byte;a:byte;end;
   pcolor96      =^tcolor96;     tcolor96=packed record v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11:byte;end;
   //.row
   pcolorrow8    =^tcolorrow8;   tcolorrow8 =array[0..maxpixel] of tcolor8;
   pcolorrow16   =^tcolorrow16;  tcolorrow16=array[0..maxpixel] of tcolor16;
   pcolorrow24   =^tcolorrow24;  tcolorrow24=array[0..maxpixel] of tcolor24;
   pcolorrow32   =^tcolorrow32;  tcolorrow32=array[0..maxpixel] of tcolor32;
   pcolorrow96   =^tcolorrow96;  tcolorrow96=array[0..maxpixel] of tcolor96;
   //.rows
   pcolorrows8   =^tcolorrows8 ; tcolorrows8 =array[0..maxrow] of pcolorrow8;
   pcolorrows16  =^tcolorrows16; tcolorrows16=array[0..maxrow] of pcolorrow16;
   pcolorrows24  =^tcolorrows24; tcolorrows24=array[0..maxrow] of pcolorrow24;
   pcolorrows32  =^tcolorrows32; tcolorrows32=array[0..maxrow] of pcolorrow32;
   pcolorrows96  =^tcolorrows96; tcolorrows96=array[0..maxrow] of pcolorrow96;

    //general purposes library structure for storing and using files in RAM - 07mar2020
    pliblist=^tliblist;
    tliblist=record
      //files
      nref:array[0..1999] of longint;
      name:array[0..1999] of string;
      data:array[0..1999] of string;
      count:longint;
      //info
      des:string;//description for the library, can be "nil"
      info:string;//information, such as value, settings etc
      end;

    tiocompressstyle=set of (iocsCompress,iocsDecompress,iocsHeader);
    tiostyle=(iosNone,iosToC,iosFromC,iosToBMP,iosFromBMP,iosToTXT,iosFromTXT,iosToFILE,iosFromFILE,iosToNV,iosFromNV,iosToMTXT,iosFromMTXT,iosToB64,iosFromB64);
    pobject=^tobject;
    pip = ^tip;
    tip = record
    case integer of
    0:(ip:integer);
    1:(p:array [0..3] of byte);
    2:(c:array [0..3] of char);
    end;
    tpointer=^pointer;//05jun2019
//    tcolor8=byte;
    prow8=^trow8;trow8=array[0..maxpixel] of tcolor8;//maxpixel 02OCT2008
    prows8=^trows8;trows8=array[0..maxrow] of prow8;
    pwbcolor=^twbcolor;twbcolor=packed record w:word;b:byte;end;//shoulde be packed for safety - 15OCT2011
    pwbcolorrow=^twbcolorrow;twbcolorrow=array[0..maxpixel] of twbcolor;//15OCT2011
    //Warning: "trgbcolorrows" causes "stack-over-flow error", use dynamic arrays instead
    pBITBOOLEAN=^tBITBOOLEAN;tBITBOOLEAN=set of 0..7;
    pdlBITBOOLEAN=^tdlBITBOOLEAN;tdlBITBOOLEAN=array[0..((maxint div sizeof(tBITBOOLEAN))-1)] of tBITBOOLEAN;
    pdlBOOLEAN=^tdlBOOLEAN;tdlBOOLEAN=array[0..((maxint div sizeof(boolean))-1)] of boolean;
    pdlCHAR=^tdlCHAR;tdlCHAR=array[0..((maxint div sizeof(char))-1)] of char;
    pdlBYTE=^tdlBYTE;tdlBYTE=array[0..((maxint div sizeof(byte))-1)] of byte;
    pdlBYTE1=^tdlBYTE1;tdlBYTE1=array[1..maxint] of byte;//rapid "string" based 1..maxint byte referencing of Delphi strings upto 50-100% faster than copying strings char-by-char - 16nov2016
    pdlPOWERREF8=^tdlPOWERREF8;tdlPOWERREF8=array[0..255] of array[0..255] of array[0..255] of byte;//16.7mb, to be used in conjuction with "tdynamicbyte.core" - 16MAR2010
    pdlBYTES=^tdlBYTES;tdlBYTES=array[0..((maxint div sizeof(pointer))-1)] of pdlBYTE;
    pdlWORD=^tdlWORD;tdlWORD=array[0..((maxint div sizeof(word))-1)] of word;
    pdllongint    =^tdllongint;   tdllongint=array[0..((maxint div sizeof(longint))-1)] of longint;
    pdlSMINT=^tdlSMINT;tdlSMINT=array[0..((maxint div sizeof(smallint))-1)] of smallint;
    pdlINTEGER=^tdlINTEGER;tdlINTEGER=array[0..((maxint div sizeof(integer))-1)] of integer;
    pdlRGB=^tdlRGB;tdlRGB=array[0..((maxint div sizeof(tcolor24))-1)] of tcolor24;
    pdlPOINT  =^tdlPOINT;  tdlPOINT  =array[0..((maxint div sizeof(tpoint))-1)] of tpoint;
    pdlIP=^tdlIP;tdlIP=array[0..((maxint div sizeof(tip))-1)] of tip;
    pdlRECT=^tdlRECT;tdlRECT=array[0..((maxint div sizeof(trect))-1)] of trect;
    pdlNOTIFYEVENT=^tdlNOTIFYEVENT;tdlNOTIFYEVENT=array[0..((maxint div sizeof(tnotifyevent))-1)] of tnotifyevent;
    tmsgproc=function (hWnd:hwnd;msg:uint;wparam:wparam;lparam:lparam):lresult of object;
    pdlMSGPROC=^tdlMSGPROC;tdlMSGPROC=array[0..((maxint div sizeof(tmsgproc))-1)] of tmsgproc;
    pBIINTEGER=^tBIINTEGER;tBIINTEGER=array[0..1] of integer;
    pdlBIINTEGER=^tdlBIINTEGER;tdlBIINTEGER=array[0..((maxint div sizeof(tBIINTEGER))-1)] of tBIINTEGER;
    pdlCURRENCY=^tdlCURRENCY;tdlCURRENCY=array[0..((maxint div sizeof(currency))-1)] of currency;
    pdlCOMP=^tdlCOMP;tdlCOMP=array[0..((maxint div sizeof(comp))-1)] of comp;//20OCT2012
    pdlDOUBLE=^tdlDOUBLE;tdlDOUBLE=array[0..((maxint div sizeof(double))-1)] of double;
    pdlDATETIME=^tdlDATETIME;tdlDATETIME=array[0..((maxint div sizeof(tdatetime))-1)] of tdatetime;
    pdlFILETIME=^tdlFILETIME;tdlFILETIME=array[0..((maxint div sizeof(tfiletime))-1)] of tfiletime;
    pdlPOINTER=^tdlPOINTER;tdlPOINTER=array[0..((maxint div sizeof(pointer))-1)] of pointer;
    pdlOBJECT=^tdlOBJECT;tdlOBJECT=array[0..((maxint div sizeof(pobject))-1)] of tobject;
    pdlSTRING=^tdlSTRING;tdlSTRING=array[0..((maxint div sizeof(pstring))-1)] of pstring;
    //.midi support - 26JAN2011
    pmidiblock=^tmidiblock;
    tmidiblock=packed record
      style:byte;//see "msNote, msPan, msVol, ...etc"
      note:byte;//0..127
      vol:byte;//0..127
      ms:currency;
      end;

   //.array mapper
   plistptr=^tlistptr;
   tlistptr=record
     count:longint;
     bytes:pdlbyte;
     end;

    pdlMIDIBLOCK=^tdlMIDIBLOCK;tdlMIDIBLOCK=array[0..((maxint div sizeof(tmidiblock))-1)] of tmidiblock;
    tdynamiclistevent=procedure(sender:tobject;index:integer) of object;
    tdynamiclistswapevent=procedure(sender:tobject;x,y:integer) of object;
    tbit8=record//24JUN2009
    case integer of
    0:(bits:tBITBOOLEAN);
    1:(val:byte);
    2:(c:char);
    3:(s:shortint);
    end;

    pbyt1=^tbyt1;
    tbyt1=record
    case integer of
    0:(val:byte);
    1:(c:char);
    2:(b:byte);
    3:(s:shortint);
    4:(bits:set of 0..7);//22JAN2011
    5:(bol:boolean);//08feb2016
    end;
    pbytechar=^tbytechar;//22JAN2011
    tbytechar=tbyt1;

    PWrd2 = ^TWrd2;
    TWrd2 = record//Note: Storage Order: e.g. 1025 = "1.4" where 1=twrd2.bytes[0] and 4=twrd2.bytes[1] - 14sep2017
    case Integer of
      0:(val:word);
      1:(si:smallint);
      2:(chars:array [0..1] of char);
      3:(bytes:array [0..1] of byte);
      4:(bits:set of 0..15);//22JAN2011
    end;

    PInt4 = ^TInt4;
    TInt4 = record
    case Integer of
      0:(R,G,B,T:byte);
      1:(val:longint);
      2:(chars:array [0..3] of char);
      3:(bytes:array [0..3] of byte);
      4:(wrds:array [0..1] of word);
      5:(bols:array [0..3] of bytebool);//18JUL2009
      6:(sint:array[0..1] of smallint);//13MAR2010
      7:(short:array[0..3] of shortint);//-128..127 - 07OCT2010
      8:(bits:set of 0..31);//22JAN2011
    end;

   pcmp8=^tcmp8;
   tcmp8=record
    case longint of
    0:(val:comp);
    1:(cur:currency);
    2:(dbl:double);
    3:(bytes:array[0..7] of byte);
    4:(wrds:array[0..3] of word);
    5:(ints:array[0..1] of longint);
    6:(bits:set of 0..63);
    7:(datetime:tdatetime);
    end;

    PCur8 = ^TCur8;
    TCur8 = record
    case Integer of
      0:(dbl:double);
      1:(val:currency);
      3:(chars:array[0..7] of char);
      4:(bytes:array[0..7] of byte);
      5:(wrds:array[0..3] of word);
      6:(ints:array[0..1] of integer);
      7:(bits:set of 0..63);//22JAN2011
      8:(filetime:tfiletime);//28oct2018
      9:(datetime:tdatetime);//28oct2018
    end;

    PComp8 = ^TComp8;//20OCT2012
    TComp8 = record
    case Integer of
      0:(dbl:double);
      1:(val:comp);
      2:(cur:currency);
      3:(chars:array[0..7] of char);
      4:(bytes:array[0..7] of byte);
      5:(wrds:array[0..3] of word);
      6:(ints:array[0..1] of integer);
      7:(bits:set of 0..63);
      8:(filetime:tfiletime);//03feb2016
      9:(datetime:tdatetime);//05feb2016
    end;

    pext10 = ^text10;
    text10 = record
    case integer of
      0:(val:extended);
      1:(chars:array[0..9] of char);
      2:(bytes:array[0..9] of byte);
      3:(wrds:array[0..4] of word);
      4:(bits:set of 0..79);//22JAN2011
    end;

   //.bitmap animation helper record
   panimationinformation=^tanimationinformation;
   tanimationinformation=record
    format:string;//uppercase EXT (e.g. JPG, BMP, SAN etc)
    subformat:string;//same style as format, used for dual format streams "ATEP: 1)animation header + 2)image"
    info:string;//UNICODE WARNING --- optional custom information data block packed at end of image data - 22APR2012
    filename:string;
    map16:string;//UNICODE WARNING --- 26MAY2009 - used in "CAN or Compact Animation" to map all original cells to compacted imagestrip
    transparent:boolean;
    flip:boolean;
    mirror:boolean;
    delay:longint;
    itemindex:longint;
    count:longint;//0..X (0=1cell, 1=2cells, etc)
    bpp:byte;
    binary:boolean;
    //cursor - 20JAN2012
    hotspotX:longint;//-1=not set=default
    hotspotY:longint;//-1=not set=default
    hotspotMANUAL:boolean;//use this hotspot instead of automatic hotspot - 03jan2019
    //32bit capable formats
    owrite32bpp:boolean;//default=false, for write modes within "ccs.todata()" where 32bit is used as the default save BPP - 22JAN2012
    //final
    readB64:boolean;//true=image was b64 encoded
    readB128:boolean;//true=image was b128 encoded
    writeB64:boolean;//true=encode image using b64
    writeB128:boolean;//true=encode image using b128 - 09feb2015
    //internal
    iosplit:longint;//position in IO stream that animation sep. (#0 or "#" occurs)
    cellwidth:longint;
    cellheight:longint;
    end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//55555555555555555555555
//##############################################################################
//## Name:         Wordcore
//## Descrioption: View and edit plain text (txt), enhanced text (bwd) and
//##               advanced text (bwp) documents. Features wordwrap, image
//##               support (tea, tem, teh, bmp, jpg), large document
//##               capacity and built-in data only mode, document format
//##               conversion etc and built-in optional toolbar.
//## Date:         14jul2020, 08jun2020, 05jun2020, 02jun2020
//## Version:      1.00.2400
//## Author:       Blaiz Enterprises (c) 1997-2020 All rights reserved
//## Notes:
//##  Now supports Claude colors via "$claude.text1-5" and "$claude.header1-5"
//##  font names - 14jul2020
//##############################################################################

{tbarcore}
   tbarcore=record///05dec2019
     //init
     initstate     :string;//is set to "done" once this structure has be setup for the first time - 21aug2019
     //buttons
     bcap          :array[0..199] of string;
     bsep          :array[0..199] of boolean;
     benabled      :array[0..199] of boolean;
     bmark         :array[0..199] of boolean;
     bimg24        :array[0..199] of string;//low overhead, raw 24bit pixel data of image for fast drawing on screen
     bimgw         :array[0..199] of longint;
     bimgh         :array[0..199] of longint;
     bimgt         :array[0..199] of boolean;//true=transparent(top-left pixel)
     bint          :array[0..199] of longint;//value (integer 32bit) of clicked button (0=reserved for system=no value)
     bstr          :array[0..199] of string;//value (string) of clicked button - optional
     bleft         :array[0..199] of longint;
     bright        :array[0..199] of longint;
     bcount        :longint;
     //text + background colors
     hicol         :longint;//highlight color - used "clnone" to disable - optional
     txcol         :longint;//text color - always used
     txswap        :boolean;//default=false=off, true=on=draw button images normally but swap black pixels (0,0,0) with text color "txcol"
     bkcol         :longint;//background color - always used
     bkcol2        :longint;//use "clnone" to disable - optional
     bkcol3        :longint;//use "clnone" to disable - optional
     fname         :string;//font name
     fsize         :longint;//font size
     fref          :string;//font reference
     lgfdata       :string;//font data
     //system
//xxxxxxxxxxxxxxxxxxxxx//888888888888888888
     style         :string;//i=display button images, c=display button captions, a=automatic height
     width         :longint;
     height        :longint;
     downindex     :longint;
     focusindex    :longint;//-1=not button has focus
     clickindex    :longint;//-1=disabled, 0..N=mouse has been clicked
     kstack        :string;//keyboard stack
     mstack        :string;//mouse stack
     syncref       :string;
     timer100      :currency;
     timerslow     :currency;
     timerbusy     :boolean;
     mustpaint     :boolean;
     paintlock     :boolean;
     down          :boolean;
     right         :boolean;
     wasdown       :boolean;
     wasright      :boolean;
     shift         :boolean;
     shortcuts     :boolean;
     feather       :longint;
     //.buffer support -> used for screen painting
     buffer32      :string;//raw32 format
     bufferrows32  :pcolorrows32;
     buffermem     :string;
     bufferw       :longint;
     bufferh       :longint;
     bufferref     :string;
     end;

{twordcore}
   twordcharinfo=record
     c       :char;
     cs      :char;
     wid     :word;//primary array index (txtname/imgdata etc)
     txtid   :word;//secondary array index (lgfdata/lgfnref)
     width   :longint;
     height  :longint;
     height1 :longint;
     end;
   twordcore=record
     //init
     initstate     :string;//is set to "done" once this structure has be setup for the first time - 21aug2019
     dataonly      :boolean;//defaults=false=fonts load for GUI, true=font don't load and thus no GUI support (but faster for pure data conversion)
     //font list -> linear graphic font
     lgfdata       :array[0..999] of string;//rapid access linear graphic font - 21aug2019
     lgfnref       :array[0..999] of string;//simple lookup name for style|size|fontname -> used to autocreate lgfDATA when required - 25sep2019
     //text list
     txtname       :array[0..999] of string;//font name
     txtsize       :array[0..999] of longint;//font size
     txtbold       :array[0..999] of boolean;//font style
     txtitalic     :array[0..999] of boolean;
     txtunderline  :array[0..999] of boolean;
     txtstrikeout  :array[0..999] of boolean;
     txtcolor      :array[0..999] of longint;
     txtbk         :array[0..999] of longint;
     txtborder     :array[0..999] of longint;
     txtalign      :array[0..999] of byte;//0=left, 1=centre, 2=right
     txtid         :array[0..999] of word;//pointer to "lgfdata"
     //image list
     imgdata       :array[0..999] of string;//original image data stream (JPG, TEH, TEM, BMP etc)
     imgraw24      :array[0..999] of string;//raw 24bit image data (no header, in-order, continous stream of BGR pixels)
     imgw          :array[0..999] of longint;
     imgh          :array[0..999] of longint;
     //data streams
     data          :string;//single byte text stream
     data2         :string;//as above, forms a 16bit (word) list id in range 0..999 for above
     data3         :string;//2nd part of list1's 16bit list id
     //support streams -> list every item's x,y,w,h information (in 32bit blocks) and line information - 21aug2019
     linex         :pdlINTEGER;
     liney         :pdlINTEGER;
     lineh         :pdlINTEGER;
     lineh1        :pdlINTEGER;
     linep         :pdlINTEGER;//item pos at start of this line
     //.hard and fast limit of each core, exceeding these limits will cause memory corruption/system failure - 22aug2019
     linesize      :longint;
     listsize      :longint;
     //.stream cores
     corelinex     :string;
     coreliney     :string;
     corelineh     :string;
     corelineh1    :string;
     corelinep     :string;
     //current support
     cfontname     :string;
     cfontsize     :longint;
     cbold         :boolean;
     citalic       :boolean;
     cunderline    :boolean;
     cstrikeout    :boolean;
     ccolor        :longint;
     cbk           :longint;
     cborder       :longint;
     calign        :byte;//0=left, 1=centre, 2=right
     //paint + management
     cursorpos     :longint;
     cursorpos2    :longint;
     pagewidth     :longint;//0=wrap to area
     pageheight    :longint;//maxint=continuous
     pagecolor     :longint;//color of page background -> default=white=rgb(255,255,255)
     pageselcolor  :longint;//selection color -> uses built-in light blue by default
     viewwidth     :longint;//control view width
     viewheight    :longint;//control view height
     viewcolor     :longint;//color of unused area -> default=rgb(152,152,152)
     vpos          :longint;//control vertical scrollbar position
     vhostsync     :boolean;//true=host must read "vpos/vmax" and sync with host scrollbar
     vcheck        :longint;//internal use only
     hpos          :longint;//control horizontal scrollbar position
     hhostsync     :boolean;//true=host must read "hpos/hmax" and sync with host scrollbar
     pagecount     :longint;//number of pages (always 1 or more)
     totalheight   :longint;//height of all items within the confines of pagewidth & pageheight
     linecount     :longint;
     line          :longint;
     col           :longint;
     wrapcount     :longint;//indicates HOW FAR the wrap system as progressed (complete when wrapcount>=length(x.data))
     dataid        :longint;
     mustpaint     :boolean;
     paintlock     :boolean;
     modified      :boolean;
     timer100      :currency;//used to internally throttle the "timer" event to a steady 100ms internval cycle MAX
     timerslow     :currency;
     idleref       :currency;
     timerbusy     :boolean;
     wrapstack     :string;//stack of wordwrap ranges to process (from(4b)+to(4b)=64bit)
     kstack        :string;//stack of keyboard inputs
     mstack        :string;//stack of mouse inputs
     briefstatus   :string;
     shortcuts     :boolean;
     styleshortcuts:boolean;
     flashcursor   :boolean;//internally managed
     drawcursor    :boolean;//internally managed
     cursoronscrn  :boolean;//*
     linecursorx   :longint;//internal use only -> used to remember cursor's original X coordinate when scrolling up/down using keyboard keys - 31aug2019
     havefocus     :boolean;//set by host
     showcursor    :boolean;//set by host
     readonly      :boolean;//set by host
     shift         :boolean;//set internally -> true=shift key is down
     wasdown       :boolean;//mouse support - internal
     wasright      :boolean;//mouse support - internal
     feather       :longint;//0=sharp edges to text, 1=light feather, 2=heavy feather
     activecursor  :tcursor;
     //.buffer support -> used for screen painting
     buffer        :tbitmap;
     bufferrows    :pcolorrows32;
     buffermem     :string;
     bufferref     :string;
     syncref       :string;
     //consts
     c_smallwrap   :longint;//set once by "init"
     c_bigwrap     :longint;//set once by "init"
     c_pagewrap    :longint;//use to wrap an entire screen of characters -> best guess -> not actual requirement, but a large number to cover even 8k displays
     c_idlepause   :longint;//time to take before cursor can flash again, default=500ms
     //.paragraph alignments
     c_alignleft   :byte;
     c_aligncentre :byte;
     c_alignright  :byte;
     c_alignmax    :byte;
     //special - delayed events/vars
     cursorstyle             :char;//"t" = text cursor, "l" = link cursor
     cursor_keyboard_moveto  :longint;
     timer_chklinecursorx    :boolean;
     //special options
     bar           :tbarcore;//optional toolbar
     barh          :longint;//current height of toolbar (can be zero when toolbar not in use)
     barshow       :boolean;
     barfocused    :boolean;
     //other
     landscape     :boolean;//default=false
     wrapstyle     :longint;//0=no wrap, 1=to window, 2=to page (default)
     //reference
     bwd_color     :longint;
     bwd_color2    :longint;
     bwd_bk        :longint;
     //claude support - optional color overrides for Claude - 14jul2020
     useclaudecolors  :boolean;//default=false=off
     claude_text1     :longint;
     claude_text2     :longint;
     claude_text3     :longint;
     claude_text4     :longint;
     claude_text5     :longint;
     claude_header1   :longint;
     claude_header2   :longint;
     claude_header3   :longint;
     claude_header4   :longint;
     claude_header5   :longint;
     end;

//[3]#################### ZIP/HELP Support #####################################
  TAlloc = function (AppData: Pointer; Items, Size: Integer): Pointer;
  TFree = procedure (AppData, Block: Pointer);

  // Internal structure.  Ignore.
  TZStreamRec = packed record
    next_in: PChar;       // next input byte
    avail_in: Integer;    // number of bytes available at next_in
    total_in: Integer;    // total nb of input bytes read so far

    next_out: PChar;      // next output byte should be put here
    avail_out: Integer;   // remaining free space at next_out
    total_out: Integer;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: Pointer;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: Integer;   //  best guess about the data type: ascii or binary
    adler: Integer;       // adler32 value of the uncompressed data
    reserved: Integer;    // reserved for future use
  end;

//tstr8 - 8bit binary string -> replacement for Delphi 10's lack of 8bit native string - 29apr2020
//xxxxxxxxxxxxxxxxxxxxxxx//88888888888888888888888
   tstr8=class(tobject)
   private
    idata:pointer;
    idatalen,icount:longint;//datalen=size of allocated memory | count=size of memory in use by user
    ichars :pdlchar;
    ibytes :pdlbyte;
    iints4 :pdllongint;
    irows8 :pcolorrows8;
    irows15:pcolorrows16;
    irows16:pcolorrows16;
    irows24:pcolorrows24;
    irows32:pcolorrows32;
    function getbytes(x:longint):byte;
    procedure setbytes(x:longint;xval:byte);
    function getbytes1(x:longint):byte;//1-based
    procedure setbytes1(x:longint;xval:byte);
    function getchars(x:longint):char;
    procedure setchars(x:longint;xval:char);
    //get + set support --------------------------------------------------------
    function getcmp8(xpos:longint):comp;
    function getcur8(xpos:longint):currency;
    function getint4(xpos:longint):longint;
    function getwrd2(xpos:longint):word;
    function getbyt1(xpos:longint):byte;
    function getchr1(xpos:longint):char;
    function getstr(xpos,xlen:longint):string;//0-based
    function getstr1(xpos,xlen:longint):string;//1-based
    function gettext:string;
    procedure settext(x:string);
    function gettextarray:string;
    procedure setcmp8(xpos:longint;xval:comp);
    procedure setcur8(xpos:longint;xval:currency);
    procedure setint4(xpos:longint;xval:longint);
    procedure setwrd2(xpos:longint;xval:word);
    procedure setbyt1(xpos:longint;xval:byte);
    procedure setchr1(xpos:longint;xval:char);
    procedure setstr(xpos:longint;xlen:longint;xval:string);//0-based
    procedure setstr1(xpos:longint;xlen:longint;xval:string);//1-based
    //replace support ----------------------------------------------------------
    procedure setreplace(x:tobject);
    procedure setreplacecmp8(x:comp);
    procedure setreplacecur8(x:currency);
    procedure setreplaceint4(x:longint);
    procedure setreplacewrd2(x:word);
    procedure setreplacebyt1(x:byte);
    procedure setreplacechr1(x:char);
    procedure setreplacestr(x:string);
   public
    //create
    constructor create(xlen:longint); virtual;
    destructor destroy; override;
    function xresize(x:longint;xsetcount:boolean):boolean;
    //information
    property core:pointer read idata;//read-only
    property len:longint read icount;
    property count:longint read icount;
    property chars[x:longint]:char read getchars write setchars;
    property bytes[x:longint]:byte read getbytes write setbytes;//0-based
    property bytes1[x:longint]:byte read getbytes1 write setbytes1;//1-based
    function scanline(xfrom:longint):pointer;
    //.rapid access -> no range checking
    property pbytes :pdlbyte      read ibytes;
    property pints4 :pdllongint   read iints4;
    property prows8 :pcolorrows8  read irows8;
    property prows16:pcolorrows16 read irows16;
    property prows24:pcolorrows24 read irows24;
    property prows32:pcolorrows32 read irows32;
    //workers
    function clear:boolean;
    function setlen(x:longint):boolean;
    function minlen(x:longint):boolean;
    function fill(xfrom,xto:longint;xval:byte):boolean;
    function del(xfrom,xto:longint):boolean;
    //.object support
    function add(x:tobject):boolean;
    function add2(x:tobject;xfrom,xto:longint):boolean;
    function add3(x:tobject;xfrom,xlen:longint):boolean;
    function ins(x:tobject;xpos:longint):boolean;
    function ins2(x:tobject;xpos,xfrom,xto:longint):boolean;
    //.array support
    function aadd(x:array of byte):boolean;
    function aadd2(x:array of byte;xfrom,xto:longint):boolean;
    function ains(x:array of byte;xpos:longint):boolean;
    function ains2(x:array of byte;xpos,xfrom,xto:longint):boolean;
    //.string support
    function sadd(x:string):boolean;
    function sadd2(x:string;xfrom,xto:longint):boolean;
    function sadd3(x:string;xfrom,xlen:longint):boolean;
    function sins(x:string;xpos:longint):boolean;
    function sins2(x:string;xpos,xfrom,xto:longint):boolean;
    //.push support -> insert data at position "pos" and inc pos to new position
    function pushcmp8(var xpos:longint;xval:comp):boolean;
    function pushcur8(var xpos:longint;xval:currency):boolean;
    function pushint4(var xpos:longint;xval:longint):boolean;
    function pushwrd2(var xpos:longint;xval:word):boolean;
    function pushbyt1(var xpos:longint;xval:byte):boolean;
    function pushchr1(var xpos:longint;xval:char):boolean;//WARNING: Unicode conversion possible -> use only 0-127 chars????
    function pushstr(var xpos:longint;xval:string):boolean;
    //.add support -> always append to end of data
    function addcmp8(xval:comp):boolean;
    function addcur8(xval:currency):boolean;
    function addint4(xval:longint):boolean;
    function addwrd2(xval:word):boolean;
    function addbyt1(xval:byte):boolean;
    function addchr1(xval:char):boolean;
    function addstr(xval:string):boolean;
    //.get/set support
    property cmp8[xpos:longint]:comp read getcmp8 write setcmp8;
    property cur8[xpos:longint]:currency read getcur8 write setcur8;
    property int4[xpos:longint]:longint read getint4 write setint4;
    property wrd2[xpos:longint]:word read getwrd2 write setwrd2;
    property byt1[xpos:longint]:byte read getbyt1 write setbyt1;
    property chr1[xpos:longint]:char read getchr1 write setchr1;
    property str[xpos:longint;xlen:longint]:string read getstr write setstr;//0-based
    property str1[xpos:longint;xlen:longint]:string read getstr1 write setstr1;//1-based
    function setarray(xpos:longint;xval:array of byte):boolean;
    property text:string read gettext write settext;//use carefully -> D10 uses unicode
    property textarray:string read gettextarray;
    //.replace support
    property replace:tobject write setreplace;
    property replacecmp8:comp write setreplacecmp8;
    property replacecur8:currency write setreplacecur8;
    property replaceint4:longint write setreplaceint4;
    property replacewrd2:word write setreplacewrd2;
    property replacebyt1:byte write setreplacebyt1;
    property replacechr1:char write setreplacechr1;
    property replacestr:string write setreplacestr;
    //.logic support
    function empty:boolean;
    function notempty:boolean;
    function same(x:tstr8):boolean;
    function same2(xfrom:longint;x:tstr8):boolean;
    function asame(x:array of byte):boolean;
    function asame2(xfrom:longint;x:array of byte):boolean;
   end;

//tmask8 - rapid 8bit graphic mask for tracking onscreen window areas (square and rounded) - 05may2020
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//mmmmmmmmmmmmmmmmmmmmmmmmmmm
   tmaskrgb96 =packed array[0..11] of byte;
   pmaskrow96 =^tmaskrow96;tmaskrow96=packed array[0..((maxint div sizeof(tmaskrgb96))-1)] of tmaskrgb96;
   pmaskrows96=^tmaskrows96;tmaskrows96=array[0..maxrow] of pmaskrow96;
   tmask8=class(tobject)
   private
    icore:tstr8;
    irows:tstr8;
    ilastdy,icount,iblocksize,irowsize,iwidth,iheight:longint;
    irows96:pmaskrows96;
    irows8:pcolorrows8;
    ibytes:pdlbyte;
   public
    //create
    constructor create(w,h:longint); virtual;
    destructor destroy; override;
    //information
    property width:longint read iwidth;
    property height:longint read iheight;
    property rowsize:longint read irowsize;
    property bytes:pdlbyte read ibytes;
    property rows:pmaskrows96 read irows96;
    property prows8:pcolorrows8 read irows8;
    property core:tstr8 read icore;//read-only
    //workers
    function resize(w,h:longint):boolean;
    //mask writers -> boundary is checked
    function cls(xval:byte):boolean;
    function fill(xarea:trect;xval:byte;xround:boolean):boolean;
    function fill2(xarea:trect;xval:byte;xround:boolean):boolean;//29apr2020
    //mask readers -> boundary is NOT checked -> out of range values will cause memory errors - 29apr2020
    procedure mrow(dy:longint);
    function mval(dx:longint):byte;
    function mval2(dx,dy:longint):byte;
   end;

{tbmp}
   tbmp=class(tobject)
   private
    icore:tbitmap;
    irows:tstr8;
    ibits,iwidth,iheight:longint;
    iunlocking,ilocked,isharp:boolean;
    irows8 :pcolorrows8;
    irows15:pcolorrows16;
    irows16:pcolorrows16;
    irows24:pcolorrows24;
    irows32:pcolorrows32;
    ilockptr:pointer;
    {$ifdef w32}
    isharphfont:hfont;//Win32 only
    {$endif}
    procedure setbits(x:longint);
    procedure setwidth(x:longint);
    procedure setheight(x:longint);
    procedure setsharp(x:boolean);
    function getcanvas:tcanvas;
    procedure xinfo;
   public
    //animation support
    ai:tanimationinformation;
    dtransparent:boolean;
    omovie:boolean;//default=false, true=fromdata will create the "movie" if not already created
    oaddress:string;//used for "AAS" to load from a specific folder - 30NOV2010
    ocleanmask32bpp:boolean;//default=false, true=reads only the upper levels of the 8bit mask of a 32bit icon/cursor to eliminate poor mask quality - ccs.fromicon32() etc - 26JAN2012
    rhavemovie:boolean;//default=false, true=object has a movie as it's animation
    //create
    constructor create; virtual;
    destructor destroy; override;
    //information
    property core:tbitmap read icore;
    function cansetparams:boolean;
    function setparams(dbits,dw,dh:longint):boolean;
    property width:longint read iwidth write setwidth;
    property height:longint read iheight write setheight;
    property bits:longint read ibits write setbits;
    //rows -> can only use rows when locked, e.g. "canrows=true" - 21may2020
    function canrows:boolean;
    property rows:tstr8 read irows;//read-only
    property prows8 :pcolorrows8  read irows8;
    property prows15:pcolorrows16 read irows15;
    property prows16:pcolorrows16 read irows16;
    property prows24:pcolorrows24 read irows24;
    property prows32:pcolorrows32 read irows32;
    //lock -> required to map rows under Android via FireMonkey
    property locked:boolean read ilocked;
    function lock:boolean;
    function unlock:boolean;
    //sharp -> can't do this once we're locked
    function cansharp:boolean;
    property sharp:boolean read isharp write setsharp;
    //canvas
    function cancanvas:boolean;
    property canvas:tcanvas read getcanvas;
    //assign
    function canassign:boolean;
    function assign(x:tobject):boolean;
   end;

{tstreamstr}
  tstreamstr=class(tstream)//tstringstream replacement
  private
   iposition:integer;
   iptr:pstring;//pointer to outside string - zero memory duplication
  protected
   procedure setsize(newsize:longint); override;
  public
   //create
   constructor create(_ptr:pstring); virtual;
   destructor destroy; override;
   //workers
   function read(var x;xlen:longint):longint; override;
   function write(const x;xlen:longint):longint; override;
   function seek(offset:longint;origin:word):longint; override;
   function readstring(count:longint):string;
   procedure writestring(const x:string);
  end;

{tbaseform}
//xxxxxxxxxxxxxxxxxxxx//bbbbbbbbbbbbbbbbbbbbbbb
   tbaseform=class(tform)
   private
    iwheelv:single;
   public
    wheelv:longint;
    onwheel:tnotifyevent;
    constructor create(aowner:tcomponent); override;
    procedure wmerasebkgnd(var message:twmerasebkgnd); message wm_erasebkgnd;
    procedure wmmousewheel(var Message:tmessage); message wm_mousewheel;
   end;

{thelpviewer}
//xxxxxxxxxxxxxxxxxxxxxxxxx//hhhhhhhhhhhhhhhhhhhhh
   thelpviewer=class(tobject)
   private
    iform:tbaseform;
    itimer:ttimer;
    iv:tscrollbar;
    icore:twordcore;
    itimerVH:currency;
    imousedown,imouseright,ishift,ialt,ictrl,ispecial,itimerbusy,ibuildingcontrol:boolean;
    procedure _ontimer(sender:tobject);
    procedure _onresize(sender:tobject);
    procedure _onpaint(sender:tobject);
    procedure _onpos(sender:tobject);
    procedure _onwheel(sender:tobject);
    procedure _onkeydown(sender:tobject;var key:word;shift:tshiftstate);
    procedure _onkeypress(sender:tobject;var key:char);
    procedure _onkeyup(sender:tobject;var key:word;shift:tshiftstate);
    procedure _onmousedown(sender:tobject;button:tmousebutton;shift:tshiftState;x,y:integer);
    procedure _onmouseup(sender:tobject;button:tmousebutton;shift:tshiftState;x,y:integer);
    procedure _onmousemove(sender:tobject;shift:tshiftstate;x,y:integer);
    procedure xinit__bar;
   public
    //create
    constructor create; virtual;
    destructor destroy; override;
    //workers
    procedure show;
    procedure center;
    procedure setsize(dw,dh:longint);
    procedure setbounds(dx,dy,dw,dh:longint);
   end;

var
   //64bit system timer
   ms64init:boolean=false;
   ms64LAST:currency=0;
   ms64OFFSET:currency=0;
   syskeyboardtime:currency=0;
   //.0 or 1 based string handling
   stroffset:longint=1;//Win32
   //system libraries
   syslib_int:tliblist;//internal library -> static lib packed inside program
   syslib_ext:tliblist;//external library -> dynamic lib packed at end of program EXE
   //system debugger
   program_fastenhancements:boolean=true;//xxxxxxxxxxxxxxxxfalse;//xxxxxxxxxxxxxxxx
   programactivedebugger:boolean=false;
   programtesting:boolean=false;
   programhelpviewer:thelpviewer=nil;
   //.help color support
   sys_help_text2    :longint=clnone;
   sys_help_header2  :longint=clnone;
   sys_help_bgcolor  :longint=clnone;

//-- System Support ------------------------------------------------------------
//version support
function low__verretro:longint;
function low__verstr(xver:longint):string;//100360 => 1.00.360 - 03jul2020
function low__strver(xver:string):longint;//1.00.360 => 100360 - 03jul2020
procedure low__vercheck(xver,xminver:longint;xname:string);//03jul2020
//hack checkers
function hack_dangerous_filepath_deny_mask(x:string):boolean;
function hack_dangerous_filepath_allow_mask(x:string):boolean;
function hack_dangerous_filepath(x:string;xstrict_no_mask:boolean):boolean;
//general
procedure sleepsafe(ms:longint);//safe version of "sleep()"
function ms64:currency;//64bit millisecond system timer, 01-SEP-2006
function ms64str:string;
function ms32:currency;//32bit millisecond system timer (reference only)
function ms32str:string;//06NOV2010
function mn32:integer;//32bit minute system timer (0..MAXINT ~ 4,000 years), 27-SEP-2006
procedure siHalt;//safe system shutdown
function createstringlist:tstringlist;//sd enabled - 14JAN2011
function appdata:string;//out of date
function crfolder(x:string):boolean;//create folder 25SEP2007
function crfolderex(x:string;create:boolean):boolean;//create folder - 09NOV2010
function findfolderb(x:integer):string;//28MAR2010
function findfolder(x:integer;var y:string):boolean;//17-JAN-2007
function windrive:string;//14DEC2010
function winroot:string;//11DEC2010
function winsystem:string;//11DEC2010
function wintemp:string;//11DEC2010
function wincommontemp:string;//27NOV2010
function wintempBE:string;//05DEC2010
function windesktop:string;//17MAY2013
function winstartup:string;
function winprograms:string;//start button > programs > - 11NOV2010
procedure showbasic(xmsg:string);
function askmessage(const Msg: string):Boolean;
function workarea:trect;
procedure low__centerform(x:tcustomform);
procedure low__showhelp(dw,dh:longint);
function specialkey(key:word):boolean;
function safekey(x:word):byte;
function low__keyboardidle:currency;
procedure low__resetkeyboardidle;
//.memory manager links
procedure low__newpstring(var z:pstring);//29NOV2011
procedure low__despstring(var z:pstring);//29NOV2011
function low__getmem(var p:pointer;size:longint):boolean;//29apr2020
function low__reallocmem(var p:pointer;oldsize,newsize:longint):boolean;//29apr2020
function low__freemem(var x:pointer):boolean;//29apr2020
procedure low__getmemCLEAR(var p:pointer;size:integer);//29NOV2011
procedure low__reallocmemCLEAR(var p:pointer;oldsize,newsize:integer);//29NOV2011
//.animation information handlers
procedure low__aiclear(var x:tanimationinformation);
procedure low__aicopy(var s,d:tanimationinformation);
//.platform support -> compatible with new platform v4 storage folders
procedure low__plat_startofprogram(exesize:longint);
procedure low__plat_close;//01jun2020
function low__plat(xcmd,xprgname:string;xrunaction:boolean):string;
function low__platroot:string;
function low__platfolder(xname:string):string;//re-routes all start button etc traffic to portable folder "Blaiz Enterprises" - 07mar2020
function low__platsettings:string;//program settings filename -> e.g. "<plat folder>\clic.ini"
function low__platonce:string;//program once filename -> e.g. "<plat folder>\clic.one"
function low__platactive:string;//program once filename -> e.g. "<plat folder>\clic.act"
//.other
procedure runLOW(fDOC,fPARMS:string);//stress tested on Win98/WinXP - 27NOV2011, 06JAN2011
procedure freeobj(x:pobject);//05DEC2011, 14JAN2011, 15OCT2004
procedure showerror60(e:string);
procedure low__showerror(sender:tobject;e:string);//01jan2020
function asfolder(x:string):string;//enforces trailing "\"
function asfolderNIL(x:string):string;//enforces trailing "\" AND permits NIL - 10mar2014
//.zero checkers - integrated debugging - 29jul2016
function nozero(xdebugID,x:longint):longint;
function nozero_byt(xdebugID:longint;x:byte):byte;
function nozero_dbl(xdebugID:longint;x:double):double;
function nozero_ext(xdebugID:longint;x:extended):extended;
function nozero_cur(xdebugID:longint;x:currency):currency;
function nozero_sig(xdebugID:longint;x:single):single;
function nozero_rel(xdebugID:longint;x:real):real;
function nozero_cmp(xdebugID:longint;x:comp):comp;
//ecap
Function StdEncrypt(X:String;EKey:String;Mode1:Integer):String;
Function ECapK:String;
Function ECap(X:String;E:Boolean):String;
Function ECapBin(X:String;E,bin:Boolean):String;
//cdstr
//.encrypt
function lestr(x:string):string;//lite-encoder
function cestr(x:string):string;//critical-encoder - 09nov2019
function cestr_bin(x:string):string;//critical-encoder
function cestr_rkey(x:string;xbin:boolean):string;//critical-encoder - 12nov2019
//.decrypt
function ldstr(x:string):string;//lite-decoder
function cdstr(x:string):string;//critical-decoder - 09nov2019
function __cdstr2(x:string):string;//critical-decoder BUT doesn't shutdown! - 08mar2018
function __cdstr(x:string;xshow:boolean):string;//critical-decoder BUT doesn't shutdown! - 09nov2019, 08mar2018
function __cdstr2_bin(x:string):string;//critical-decoder BUT doesn't shutdown! - 08mar2018
function __cdstr_bin(x:string;xshow,xclose:boolean):string;//critical-decoder BUT doesn't shutdown! - 09nov2019, 08mar2018
function cdstr_rkey(x:string;xbin,xshow,xclose:boolean):string;//critical-decoder - 12nov2019
//.data mixers
procedure xysort(xstyle,xdata:string;var x:string);
function xsaferef(x:longint):string;
function xsaferef2(x:longint):string;
function xmakekey(binkey:string;var pkey:string):boolean;
function xreadkey(x:string;var rawkey,pkey:string):boolean;

//-- IO Etc --------------------------------------------------------------------
//.exe storage
function exe_marker:string;//07mmay2015
function exe_data(xfilenameORdataORnil:string;xfrom:longint;var xdatastream:string):boolean;//03mar2018

//.liblist
procedure low__libclear(var x:tliblist);
function low__libbytes(var x:tliblist):longint;
function low__libfromdata(var x:tliblist;var xdata,e:string):boolean;
function low__libfromdatab(var x:tliblist;xdata:string):boolean;
function low__libtodata(var x:tliblist;var xdata,e:string;xcompress,xdelphiB128:boolean):boolean;
function low__libtodatab(var x:tliblist;xcompress,xdelphiB128:boolean):string;
function low__libfind(var x:tliblist;xname:string;var xindex:longint):boolean;
function low__libhave(var x:tliblist;xname:string):boolean;
function low__libdata(var x:tliblist;xname:string):string;
function low__libsetdata(var x:tliblist;xname,xdata:string):boolean;
function low__libaddfiles(var x:tliblist;xpathmask:string;var e:string):boolean;
//.push
function pushb(var _dataLEN:integer;var _data:string;_add:string):boolean;
function push(var _dataLEN:integer;var _data,_add:string):boolean;
function pushbx(var _dataLEN:integer;_bufferSTEP:integer;var _data:string;_add:string):boolean;
function pushx(var _dataLEN:integer;_bufferSTEP:integer;var _data,_add:string):boolean;//faster still - 16nov2016
function __fast_pushx(var _dataLEN:integer;_bufferSTEP:integer;var _data,_add:string):boolean;//faster still - 16nov2016
function pushlimit(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data,_add:string):boolean;//Date: 15-AUG-2005
function pushlimitb(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data:string;_add:string):boolean;//Date: 15-AUG-2005
//.base64 encoding/decoding
function low__compress(var x,e:string):boolean;
function low__compress2(var x,e:string;_style:tiocompressstyle):boolean;
function low__decompress(var x,e:string):boolean;
function low__tob64(var s,d:string;linelength:longint;var e:string):boolean;//to base64
function low__tob64b(s:string;linelength:longint):string;
function low__fromb64(var s,d:string;var e:string):boolean;//from base64
function low__fromb64b(s:string):string;
function low__toc64b(s:string;linelength:integer;_delphi:boolean):string;//to compressed base64 - 28APR2011
function low__fromc64b(s:string):string;//28APR2011
//.base128 encoding/decoding
function low__nextline2(var xdata,xlineout:string;xdatalen:longint;var xpos:longint):boolean;//17oct2018
function low__nextline(var xdata,xlineout:string;var xpos:longint):boolean;
function low__toblock(x:string;perline:integer):string;
function low__tob128(var s,d:string;prestr,poststr:string;linelength:integer;var e:string):boolean;//09feb2015
function low__tob128b(s:string;prestr,poststr:string;linelength:integer):string;//09feb2015
function low__toc128b(s:string;linelength:integer;xdelphi,xincludeheader:boolean):string;//to compressed base128 - 09feb2015
function low__fromb128(var s,d,e:string):boolean;//09feb2015
function low__fromb128b(s:string):string;
function low__fromc128b(s:string):string;//09feb2015
//.fast and basic support for "tdynamic.vars.found/value/int/setvalue" - 09may2019
function low__varsfound2(var x:string;xeol,xfind:string):boolean;
function low__varsfound(var x:string;xfind:string):boolean;
function low__varsvalue2(var x,xvalue:string;xeol,xfind:string):boolean;
function low__varsvalue(var x:string;xfind:string):string;
function low__varsint2(var x:string;var xvalue:longint;xeol,xfind:string):boolean;
function low__varsint(var x:string;xfind:string):longint;
procedure low__varssetvalue2(var x:string;xeol,xfind,xnewvalue:string);//fast - 09may2019
procedure low__varssetvalue(var x:string;xfind,xnewvalue:string);
//.file procs
function low__dates__filedatetime(x:tfiletime):tdatetime;
function low__dates__fileage(x:thandle):tdatetime;
function low__fileexists(x:string):boolean;//19may2019
function low__drives:string;//CHAR list of drives - 09nov2019, 16dec2016
function low__fromfilec(x:string;var y,e:string;_trycount:integer):boolean;
function low__fromfiled(x:string):string;
function low__fromfile(x:string;var y,e:string):boolean;
function low__fromfileb(x:string;var y,e:string;var _filesize,_from:integer;_size:integer;var _date:tdatetime):boolean;//20-OCT-2006
function low__tofile(x:string;var y,e:string):boolean;//fast and basic low-level
function low__tofileb(x,y:string;var e:string):boolean;//fast and basic low-level
function low__tofilec(x:string;var y,e:string;_trycount:integer):boolean;
function low__tofilec2(x,y:string;var e:string;_trycount:integer):boolean;
function low__tofileappend(x:string;var y,e:string):boolean;//07may2019
function low__tofileinto(x:string;xfrom:longint;var y,e:string):boolean;//fast and basic low-level
function low__remfile(x:string):boolean;
function low__remfilems(x:string;timeout:integer):boolean;//05FEB2011
function remifext(x,ext:string):boolean;//deletes files that end with ".ext" - 03MAY2008
//.other
procedure createlink(df,sf,dswitches,iconfilename:string);//24apr2025, 10apr2019, 14NOV2010
function litefiles(xmask:string;xfull:boolean):string;

//-- Range Support -------------------------------------------------------------
function frcmin(x,min:integer):integer;//14-SEP-2004
function frcmin64(x,min:comp):comp;//24jan2016
Function FrcCurMin(X,Min:currency):currency;//date: 02-APR-2004
function frcmax(x,max:integer):integer;//14-SEP-2004
function frcmax64(x,max:comp):comp;//24jan2016
function restrict64(x:comp):comp;//24jan2016
function restrict32(x:comp):longint;//24jan2016
Function FrcCurMax(X,Max:currency):currency;//date: 02-APR-2004
function frcrange(x,min,max:integer):integer;//13-SEP-2004
function frcrange2(var x:longint;xmin,xmax:longint):boolean;//29apr2020
function frcrange64(x,min,max:comp):comp;//24jan2016
function frcrangeex(x,min,max,defvalue:integer):integer;//14-JAN-2007
function frccurrange(x,min,max:currency):currency;//date: 02-APR-2004
function frcextmin(x,min:extended):extended;//07NOV20210
function frcextrange(x,min,max:extended):extended;//06JUN2007
function low__posn(x:longint):longint;
function low__thousands64(x:comp):string;//handles full 64bit whole number range of min64..max64 - 24jan2016
function low__udv(v,dv:string):string;//use default value
function xintrgb(x:integer):tcolor24;
procedure swapint(var x,y:longint);
function low__rgbtohex(xrgb:longint):string;//ultra-fast int->hex color converter - 15aug2019
function low__hextorgb(x:string;xdef:longint):longint;
function low__insint(x:integer;y:boolean):longint;
function low__setstring(new:string;var value:string):boolean;
function low__case(x:string;xuppercase:boolean):string;
function low__remcharb(x:string;c:char):string;//26apr2019
function low__remchar(var x:string;c:char):boolean;//26apr2019
function low__year(xmin:longint):longint;//04jul2020
function low__yearstr(xmin:longint):string;
function low__insstr(x:string;y:boolean):string;
function low__randomstr(xlen:longint):string;//19dec2019
function low__aorb(a,b:longint;xuseb:boolean):longint;
function low__aorbstr(a,b:string;xuseb:boolean):string;
function low__crc32seedable(var x:string;xseed:longint):longint;//14jan2018
function low__crc32nonzero(x:string):longint;
Function From16Bit(X:Integer;si:boolean):String;{DATE: 13-DEC-2003}
Function To16Bit(X:String;si:boolean):Integer;{DATE: 13-DEC-2003}
function to32bit(x:string):integer;//29AUG2007
function from32bit(x:integer):string;//29AUG2007
function from8bit2(x:byte):string;//05mar2018
function to8bit2(x:string):byte;//09nov2019, 05mar2018
function to32bit8(x:string):longint;//09nov2019, 03mar2018
function from32bit8(x:longint):string;//03mar2018
function from24bit6(x:longint):string;//03mar2018
function from24rgb6(r,g,b:byte):string;//03mar2018
function To64Bit(x:string):currency;//updated: 02-APRIL-2004
function From64Bit(x:currency):string;//updated: 02-APRIL-2004
function from80bit(x:text10):string;//24feb2016
function to80bit(x:string):text10;//24feb2016
function fromext80(v:extended):string;//17aug2018
function toext80(v:string):extended;//17aug2018
function tocomp64(x:string):comp;//full 64bit support - 22jan2016
procedure tocomp642(x:string;var y:tcomp8);//full 64bit support - 21feb2016
function fromcomp64(x:comp):string;//full 64bit support - 22jan2016
function fromcomp642(var x:tcomp8):string;//full 64bit support - 21feb2016

//-- Image and Array Support ---------------------------------------------------
//.canvas support
function misset_brushcolor(x:tobject;xval:longint):boolean;
function misset_brushclear(x:tobject;xval:boolean):boolean;
function misset_fontcolor(x:tobject;xval:longint):boolean;
function misset_fontname(x:tobject;xval:string):boolean;
function misset_fontsize(x:tobject;xval:longint):boolean;
function misset_fontheight(x:tobject;xval:longint):boolean;
function misset_fontstyle(x:tobject;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;
function misset_textextent(x:tobject;xval:string):tpoint;
function misset_textwidth(x:tobject;xval:string):longint;
function misset_textheight(x:tobject;xval:string):longint;
function mis_textrect(x:tobject;xarea:trect;dx,dy:longint;xval:string):boolean;
function low__maplist(const x:array of byte):tlistptr;
function low__mapstr8(x:tstr8):tlistptr;
function misbmp(dbits,dw,dh:longint):tbmp;
function misrect(x,y,x2,y2:longint):trect;
function misb(s:tobject):longint;//bits 0..N
function misw(s:tobject):longint;
function mish(s:tobject):longint;
function mishasai(s:tobject):boolean;
function mismustlock(s:tobject):boolean;
function mislock(s:tobject):boolean;
function misunlock(s:tobject):boolean;
function misinfo(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misinfo82432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
function misok824(s:tobject;var sbits,sw,sh:longint):boolean;
function misok82432(s:tobject;var sbits,sw,sh:longint):boolean;
function misok2432(s:tobject;var sbits,sw,sh:longint):boolean;
function misscan(s:tobject;sy:longint;pr:pointer):boolean;
function misscan824(s:tobject;sy:longint;pr8,pr24:pointer):boolean;
function missize(s:tobject;dw,dh:longint):boolean;
function mispixel(s:tobject;sx,sy:longint):longint;
function low__newbmp24:tbitmap;
function low__compareint(x,xval:longint):boolean;
function low__findimgformat(var x,format:string;var xbase64:boolean):boolean;
function low__toimgdata(s:tbitmap;dformat:string;var ddata,e:string):boolean;//02jun2020
function low__bmptoraw24(s:tbitmap;var ddata:string;var dbits,dw,dh:longint):boolean;
function low__bmptoraw32(s:tbitmap;var ddata:string;var dbits,dw,dh:longint):boolean;
procedure low__clsoutside3(canvas:tcanvas;ccw,cch,dx,dy,imageW,imageH,color:integer);//cls unused areas of a GUI control - 08aug2017
function low__rawdraw2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;d:tbitmap;dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
function low__rawdrawr2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;ddr24:pcolorrows24;ddr32:pcolorrows32;dw,dh,dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
function low__rawdraww2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;var draw:string;dbits,dw,dh,dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
function low__rawrows2432(var simg:string;sbits,sw,sh:longint;var srows24:pcolorrows24;var srows32:pcolorrows32;var srowsmem:string):boolean;
function low__rawrows32(var simg:string;sbits,sw,sh:longint;var srows32:pcolorrows32;var srowsmem:string):boolean;
function low__rawrows24(var simg:string;sbits,sw,sh:longint;var srows24:pcolorrows24;var srowsmem:string):boolean;
function low__rawcls2432(acolor,acolor2:longint;var sraw:string;sw,sh,sbits:longint;scliparea:trect):boolean;
function low__imgtoraw(xtargetbits:longint;var simg,ddata:string;var dbits,dw,dh:longint):boolean;
function low__fromimgdata2(a:tbitmap;xdata:array of byte;var e:string):boolean;//02jun2020
function low__fromimgdata(a:tbitmap;var xformat,xdata,e:string):boolean;//02jun2020
function low__imgtoraw24(var simg,ddata:string;var dbits,dw,dh:longint):boolean;
function low__imgtoraw32(var simg,ddata:string;var dbits,dw,dh:longint):boolean;
function low__totem(x:tobject;xencode:boolean;var xout:string):boolean;
function low__fromtem(x:tobject;xin:string):boolean;
function low__toteh(x:tobject;xencode:boolean;var xout:string):boolean;
function low__fromteh(x:tobject;xin:string):boolean;
function low__teamake(x:tobject;xout:tstr8;var e:string):boolean;
function low__teainfo(var adata:tlistptr;var aw,ah:longint):boolean;
function low__teatobmp(xtea:tlistptr;d:tbitmap;var xw,xh:longint):boolean;//23may2020

//-- Color support -------------------------------------------------------------
function low__rgb(r,g,b:byte):longint;
function low__rgba(r,g,b,a:byte):longint;
function low__greyscale3(x:longint):longint;
function low__focus3(x:longint):longint;
function low__cap2432(xpos,ypos,dw,dh:longint;d:tbitmap):boolean;//low version - 07mar2020, 30may2019, 21jan2015, 17-JAN-2007
function low__cap2432b(d:tbitmap):boolean;
function low__capcolor(xpos,ypos:longint;xfromcursor:boolean):longint;

//-- String Handers ------------------------------------------------------------
function bn(x:boolean):char;//08SEP2010
function nb(x:string):Boolean;
function SwapStrs(Var X:String;A,B:String):boolean;
function fromnullstr(a:pointer;asize:integer):string;
function low__nullstr(x:integer;y:char):string;
function safefilename(x:string;allowpath:boolean):string;//08mar2016
function issafefilename(x:string):boolean;//10APR2010
function remlastext(x:string):string;//remove last extension
function readfileext(x:string;fu:boolean):string;{Date: 24-DEC-2004, Superceeds "ExtractFileExt"}
function scandownto(x:string;y,stopA,stopB:char;var a,b:string):boolean;
//.error free handling of str-num conversion
function strtofloatex(x:string):extended;//triggers less errors (x=nil now covered)
function floattostrex2(x:extended):string;//19DEC2007
function floattostrex(x:extended;dig:byte):string;//07NOV20210
function strflt(x:string):extended;//19aug2018, 27-JAN-2007, v1.00.020
function xremcharb(x:string;c:char):string;//26apr2019
function xremchar(var x:string;c:char):boolean;//26apr2019
function strint_filtered(x:string):longint;//removes "comma,space" automatically
function strint_filtered64(x:string):comp;//removes "comma,space" automatically
function strint(const x:string):longint;//date: 25mar2016 v1.00.50 / 10DEC2009, v1.00.045
function extstr(x:extended):string;//17sep2018
function strext(x:string):extended;//17sep2018
function curstr(x:currency):string;//27nov2017
function strcur(const x:string):currency;//v1.00.070 - 07NOV2010
function curstrex(x:currency;sep:string):string;//01aug2017, 07SEP2007
function curcomma(x:currency):string;{same as "Thousands" but for "double"}
function strdec(a:string;y:byte;z:boolean):string;
function curdec(x:currency;y:byte;z:boolean):string;
function strint64(const x:string):comp;//v1.00.033 - 28jan2017
function intstr64(x:comp):string;//30jan2017
function int32(x:comp):longint;//25jun2017
function int32RANGE(x,xmin,xmax:comp):longint;
procedure safeinc(var x:integer);//16jun2014
function cround(x:extended):currency;//19DEC2007

//-- low level support for "tbarcore" ------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//88888888888888888888888
function low__barcore__inited(var x:tbarcore):boolean;
function low__barcore__add(var x:tbarcore;xcaption,ximage,xclickstr:string;xclickint:longint;xenabled:boolean):boolean;
function low__barcore__addsep(var x:tbarcore):boolean;
function low__barcore__mark(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
function low__barcore__enabled(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
function low__barcore__focused(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
function low__barcore__clicked(var x:tbarcore;var xclickstr:string;var xclickint:longint):boolean;
procedure low__barcore__keyboard(var x:tbarcore;xctrl,xalt,xshift,xkeyX:boolean;xkey:byte);
procedure low__barcore__mouse(var x:tbarcore;xmousex,xmousey:longint;xmousedown,xmouseright:boolean);
procedure low__barcore__mouselite(var x:tbarcore;xmousex,xmousey:longint);
procedure low__barcore__draw(var x:tbarcore;var xfc:string);
function low__wordcore__txtcolor(var x:twordcore;xwid:longint):longint;//14jul2020
function low__barcore__paint2432(var x:tbarcore;ax,ay,aw,ah:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32):boolean;
function low__barcore__paintcanvas32(var x:tbarcore;xcanvas:tcanvas;xclientwidth,xclientheight:longint):boolean;
function low__barcore(var x:tbarcore;xcmd,xval:string):boolean;
function low__barcore2(var x:tbarcore;xcmd,xval:string):longint;
function low__barcore3(var x:tbarcore;xcmd,xval:string;var xoutval,e:string):boolean;

//-- low level support for "twordcore" -----------------------------------------
//Version: 1.00.1800 - 29feb2020
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//555555555555555555
function low__findimage(ximgname:string;var xoutdata:string):boolean;
function low__findimageb(ximgname:string):string;
function low__wordcore__inited(var x:twordcore):boolean;
procedure low__wordcore__bar(var x:twordcore;xcmd,xval:string;var xoutval:string);//optional toolbar support
procedure low__wordcore__lgfFILL(var x:twordcore;lgfINDEX:longint);
function low__wordcore__style(x:char):char;
procedure low__wordcore__filtertext(var x:string);
function low__wordcore__charinfo(var x:twordcore;xpos:longint;var xout:twordcharinfo):boolean;
function low__wordcore__paint2432(var x:twordcore;ax,ay,aw,ah:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;acanvas:tcanvas):boolean;
function low__wordcore__paintcanvas32(var x:twordcore;xcanvas:tcanvas;xclientwidth,xclientheight:longint):boolean;
procedure low__wordcore__keyboard(var x:twordcore;xctrl,xalt,xshift,xkeyX:boolean;xkey:byte);
procedure low__wordcore__mouse(var x:twordcore;xmousex,xmousey:longint;xmousedown,xmouseright:boolean);
function low__wordcore(var x:twordcore;xcmd,xval:string):boolean;//return result: true/false
function low__wordcore2(var x:twordcore;xcmd,xval:string):longint;//return result: longint
function low__wordcore3(var x:twordcore;xcmd,xval:string;var xoutval,e:string):boolean;//return result: true=OK, false=error, result stored in "xoutval" - 25aug2019

//-- low level "LGF" font support ----------------------------------------------
//.font support -> LGF "linear graphic font" - 18apr2020, 08apr2020
function low__toLGF2(xfontname:string;xfontsize:longint;xbold:boolean;var xdata,e:string):boolean;
function low__toLGF2b(xfontname:string;xfontsize:longint;xbold:boolean):string;
function low__toLGF(xfontname:string;xfontsize:longint;xbold:boolean;xdata:tstr8;var e:string):boolean;
function low__fromLGF_height(var xdata:string):longint;
function low__fromLGF_height1(var xdata:string):longint;
function low__fromLGF_charw(var xdata:string;xindex:longint):longint;
function low__fromLGF_textwidth(var xdata:string;xtext:string):longint;
function low__fromLGF_drawchar2432(x:string;xindex,ax,ay,aw,ah,dcolor:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;xmask:tmask8;xmaskval:longint;var xfc:string;xfeather:longint;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;//23jan2020
function low__fromLGF_drawtext2432(x,xtext:string;ax,ay,aw,ah,dcolor:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;xmask:tmask8;xmaskval:longint;var xfc:string;xfeather:longint;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;

function newstr8(xlen:longint):tstr8;
function newstr82(xtext:string):tstr8;
function newstr83(xdata:tstr8):tstr8;
function newstr84(xdata:array of byte):tstr8;//09jun2020

implementation

uses
   clic1;{programnameHARD}

const
  Z_NO_FLUSH      = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH    = 2;
  Z_FULL_FLUSH    = 3;
  Z_FINISH        = 4;
  Z_OK            = 0;
  Z_STREAM_END    = 1;
  Z_NEED_DICT     = 2;
  Z_ERRNO         = (-1);
  Z_STREAM_ERROR  = (-2);
  Z_DATA_ERROR    = (-3);
  Z_MEM_ERROR     = (-4);
  Z_BUF_ERROR     = (-5);
  Z_VERSION_ERROR = (-6);
  Z_NO_COMPRESSION       =   0;
  Z_BEST_SPEED           =   1;
  Z_BEST_COMPRESSION     =   9;
  Z_DEFAULT_COMPRESSION  = (-1);
  Z_FILTERED            = 1;
  Z_HUFFMAN_ONLY        = 2;
  Z_DEFAULT_STRATEGY    = 0;
  Z_BINARY   = 0;
  Z_ASCII    = 1;
  Z_UNKNOWN  = 2;
  Z_DEFLATED = 8;

{$L deflate.obj}
{$L inflate.obj}
{$L inftrees.obj}
{$L trees.obj}
{$L adler32.obj}
{$L infblock.obj}
{$L infcodes.obj}
{$L infutil.obj}
{$L inffast.obj}

procedure _tr_init; external;
procedure _tr_tally; external;
procedure _tr_flush_block; external;
procedure _tr_align; external;
procedure _tr_stored_block; external;
procedure adler32; external;

procedure inflate_blocks_new; external;
procedure inflate_blocks; external;
procedure inflate_blocks_reset; external;
procedure inflate_blocks_free; external;
procedure inflate_set_dictionary; external;
procedure inflate_trees_bits; external;
procedure inflate_trees_dynamic; external;
procedure inflate_trees_fixed; external;
procedure inflate_trees_free; external;
procedure inflate_codes_new; external;
procedure inflate_codes; external;
procedure inflate_codes_free; external;
procedure _inflate_mask; external;
procedure inflate_flush; external;
procedure inflate_fast; external;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;

// deflate compresses data
function deflateInit_(var strm: TZStreamRec; level: Integer; version: PChar;
  recsize: Integer): Integer; external;
function deflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function deflateEnd(var strm: TZStreamRec): Integer; external;

// inflate decompresses data
function inflateInit_(var strm: TZStreamRec; version: PChar;
  recsize: Integer): Integer; external;
function inflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function inflateEnd(var strm: TZStreamRec): Integer; external;
function inflateReset(var strm: TZStreamRec): Integer; external;

function zlibAllocMem(AppData: Pointer; Items, Size: Integer): Pointer;
begin
  GetMem(Result, Items*Size);
end;

procedure zlibFreeMem(AppData, Block: Pointer);
begin
  FreeMem(Block);
end;

//-- Version Support -----------------------------------------------------------
//## low__verretro ##
function low__verretro:longint;
begin
try;result:=100472;except;end;
end;
//## low__verstr ##
function low__verstr(xver:longint):string;//100360 => 1.00.360 - 03jul2020
begin
try
result:=inttostr(xver);
if (copy(result,2,1)='0') then result:=copy(result,1,1)+'.'+copy(result,2,length(result));
if (copy(result,4,1)='0') and (length(result)>4) then result:=copy(result,1,4)+'.'+copy(result,5,length(result));
except;end;
end;
//## low__strver ##
function low__strver(xver:string):longint;//1.00.360 => 100360 - 03jul2020
begin
try;low__remchar(xver,'.');result:=strint(xver);except;end;
end;
//## low__vercheck ##
procedure low__vercheck(xver,xminver:longint;xname:string);//03jul2020
begin
try
if (xver<xminver) then
   begin
   low__showerror(nil,programname+' requires v'+low__verstr(xminver)+' of "'+xname+'" atleast.  Present v'+low__verstr(xver));
   sihalt;
   end;
except;end;
end;

//-- System Support ------------------------------------------------------------
//## hack_dangerous_filepath_allow_mask ##
function hack_dangerous_filepath_allow_mask(x:string):boolean;
begin
try;result:=hack_dangerous_filepath(x,false);except;end;
end;
//## hack_dangerous_filepath_deny_mask ##
function hack_dangerous_filepath_deny_mask(x:string):boolean;
begin
try;result:=hack_dangerous_filepath(x,true);except;end;
end;
//## hack_dangerous_filepath ##
function hack_dangerous_filepath(x:string;xstrict_no_mask:boolean):boolean;
var
   p:longint;
begin
try
//defaults
result:=false;
//get
if (x<>'') then for p:=1 to length(x) do
   begin
   //check 1 - "..\" + "../"
   if (x[p]='.') and ((copy(x,p,3)='..\') or (copy(x,p,3)='../')) then
      begin
      result:=true;
      break;
      end
   //check 2 - (..\) "..%5C" + "..%5c" AND (../) "..%2F" + "..%2f"
   else if (x[p]='.') and ((copy(x,p,5)='..%5C') or (copy(x,p,5)='..%5c') or (copy(x,p,5)='..%2F') or (copy(x,p,5)='..%2f')) then
      begin
      result:=true;
      break;
      end
   //check 3 - ":" other than "(a-z/@):(\/)" e.g. "C:\" is ok, but "C::" is not - 02sep2016
   else if (p>=3) and (x[p]=':') then
      begin
      result:=true;
      break;
      end
   //check 4 - none of these characters are allowed, ever - 02sep2016
   else if (x[p]='?') or (x[p]='<') or (x[p]='>') or (x[p]='|') then
      begin
      result:=true;
      break;
      end
   //optional check 5 - disallow file masking "*"
   else if xstrict_no_mask and (x[p]='*') then
      begin
      result:=true;
      break;
      end;
   end;//p
//inc
//if result then
//   begin
//   sd_monitor__hack_pathfile.msg:=x;
//   sd_monitor(sd_monitor__hack_pathfile);
//   end;
except;end;
end;
//## sleepsafe ##
procedure sleepsafe(ms:longint);//safe version of "sleep()"
begin//Note: Enforce range of 1..60,000 ms
try
//range
if (ms<1) then ms:=1
else if (ms>60000) then ms:=60000;
//set
sleep(ms);
except;end;
end;
//## ms64 ##
function ms64:currency;//64bit millisecond system timer, 01-SEP-2006
var//64bit system timer, replaces "gettickcount" with range of 49.7 days,
   //now with new range of 29,247 years.
   //Note: must be called atleast once every 49.7 days, or it will loose track so
   //      system timer should call this routine regularly.
   i4:tint4;
   tmp:currency;
begin
try
//defaults
result:=0;
//process
//.get
i4.val:=gettickcount;
//INTEGER -> CURRENCY (0..4billion)
//#1
result:=i4.bytes[0];
//#2
tmp:=i4.bytes[1];
result:=result+(tmp*256);
//#3
tmp:=i4.bytes[2];
result:=result+(tmp*256*256);
//#4
tmp:=i4.bytes[3];
result:=result+(tmp*256*256*256);
//#5
if (not ms64init) then
   begin
   if programtesting then
      begin
      ms64OFFSET:=maxint;
      ms64OFFSET:=ms64OFFSET*4;
      end
   else ms64OFFSET:=0;
   ms64LAST:=result;
   ms64init:=true;
   end;//end of if
//# thread safe - allow a large difference margin (10 minutes) so close calling
//# threads won't corrupt (increment falsely) the offset var.
if ((result+600000)<ms64LAST) then ms64OFFSET:=ms64OFFSET+ms64LAST;
//lastv
ms64LAST:=result;
//#6
result:=result+ms64OFFSET;
except;end;
end;
//## ms64str ##
function ms64str:string;//06NOV2010
begin
try;result:=floattostr(ms64);except;end;
end;
//## ms32 ##
function ms32:currency;//32bit millisecond system timer (0..4-billion)
var//To be used only as reference, no-longer as core.
   i4:tint4;
   tmp:currency;
begin
try
//defaults
result:=0;
//process
//.get
i4.val:=gettickcount;

//INTEGER -> CURRENCY (0..4billion)
//#1
result:=i4.bytes[0];
//#2
tmp:=i4.bytes[1];
result:=result+(tmp*256);
//#3
tmp:=i4.bytes[2];
result:=result+(tmp*256*256);
//#4
tmp:=i4.bytes[3];
result:=result+(tmp*256*256*256);
except;end;
end;
//## mn32 ##
function mn32:integer;//32bit minute system timer (0..MAXINT ~ 4,000 years), 27-SEP-2006
begin//Range:
try
//defaults
result:=0;
//get
result:=round(ms64/60000);
except;end;
end;
//## ms32str ##
function ms32str:string;//06NOV2010
begin
try;result:=floattostr(ms32);except;end;
end;
//## siHalt ##
procedure siHalt;//safe system shutdown
begin
try
halt;
except;end;
end;
//## createstringlist ##
function createstringlist:tstringlist;//sd enabled - 14JAN2011
begin
try
result:=nil;
result:=tstringlist.create;
//sds_inc(sds_Stringlist,true);
except;end;
end;
//## crfolder ##
function crfolder(x:string):boolean;//create folder 25SEP2007
begin
try;result:=crfolderex(x,true);except;end;
end;
//## crfolderex ##
function crfolderex(x:string;create:boolean):boolean;//create folder - 09NOV2010
begin
try
//defaults
result:=false;
//range
if (x='') then exit;
x:=asfolder(x);
//get
if directoryexists(x) then result:=true
else if create then//09NOV2010
   begin
   forcedirectories(x);
   result:=directoryexists(x);
   end;//end of if
except;end;
end;
//## findfolderb ##
function findfolderb(x:integer):string;//28MAR2010
begin
try;findfolder(x,result);except;end;
end;
//## findfolder ##
function findfolder(x:integer;var y:string):boolean;//17-JAN-2007
var
   i:IMalloc;
   a:pitemidlist;
   b:pchar;
   tmpfolder:string;
begin
try
//defaults
result:=false;
y:='';
a:=nil;
//process
if (SHGetMalloc(i)=NOERROR) then
   begin
   if (shgetspecialfolderlocation(0,x,a)=0) then
      begin
      //.size
      b:=pchar(low__nullstr(max_path,#0));
      //.get
      if shgetpathfromidlist(a,b) then
         begin
         y:=asfolder(string(b));
         result:=(length(y)>=3);
         end;//end of if
      end;//end of if
   end;//end of if
except;end;
try;if (a<>nil) then i.free(a);except;end;
try
//-- Linux and robust Windows Support --
//Note: return a path regardless whether we are Windows or Linux, and wether it's supported
//      or not.
if not result then
   begin
   //fallback to "c:\windows\temp\blaiz enterprises\"
   tmpfolder:=wintempbe;
   if (tmpfolder='') then tmpfolder:='C:\WINDOWS\TEMP\';
   y:='';
   //get
   case x of
   CSIDL_DESKTOP:                y:=tmpfolder;
   CSIDL_COMMON_DESKTOPDIRECTORY:y:=tmpfolder;
   CSIDL_FAVORITES:              y:=tmpfolder;
   CSIDL_STARTMENU:              y:=tmpfolder;
   CSIDL_COMMON_STARTMENU:       y:=tmpfolder;
   CSIDL_PROGRAMS:               y:=tmpfolder;
   CSIDL_COMMON_PROGRAMS:        y:=tmpfolder;
   CSIDL_STARTUP:                y:=tmpfolder;
   CSIDL_COMMON_STARTUP:         y:=tmpfolder;
   CSIDL_RECENT:                 y:=tmpfolder;
   CSIDL_FONTS:                  y:=tmpfolder;
   CSIDL_APPDATA:                y:=tmpfolder;
   end;//end of case
   //set
   result:=(length(y)>=3);
   end;//end of if
except;end;
end;
//## appdata ##
function appdata:string;//out of date
begin
try;findfolder(CSIDL_APPDATA,result);except;end;
end;
//## windrive ##
function windrive:string;//14DEC2010
begin
try;result:=copy(winroot,1,3);except;end;
end;
//## winroot ##
function winroot:string;//11DEC2010
var
  a:pchar;
begin
try
//process
//.size
a:=pchar(low__nullstr(max_path,#0));
//.get
getwindowsdirectorya(a,MAX_PATH);
result:=asfolder(string(a));
except;end;
try;if (length(result)<3) then result:='C:\WINDOWS\';except;end;
end;
//## winsystem ##
function winsystem:string;//11DEC2010
var
  a:pchar;
begin
try
//process
//.size
a:=pchar(low__nullstr(max_path,#0));
//.get
getsystemdirectorya(a,MAX_PATH);
result:=asfolder(string(a));
except;end;
try;if (length(result)<3) then result:=winroot+'SYSTEM32\';except;end;
end;
//## wintemp ##
function wintemp:string;//11DEC2010
var
  a:pchar;
begin
try
//defaults
result:='';
//size
a:=pchar(low__nullstr(max_path,#0));
//get
gettemppatha(max_path,a);
//set
result:=asfolder(string(a));
except;end;
try
//range
if (length(result)<3) then result:='C:\WINDOWS\TEMP\';//11DEC2010
if not directoryexists(result) then forcedirectories(result);
except;end;
end;
//## wincommontemp ##
function wincommontemp:string;//27NOV2010
var
   a:array[0..1023] of char;
   s,d:string;
begin
try
//defaults
result:='C:\WINDOWS\TEMP\';
//get
s:='%windir%';
expandenvironmentstrings(pchar(s),a,sizeof(a));
d:=fromnullstr(@a,sizeof(a));
if (comparetext(s,d)<>0) then result:=asfolder(d)+'TEMP\';
//set
result:=asfolder(result);
//create folder
crfolderex(result,true);
//check
if not directoryexists(result) then result:=wintemp;//fallback to "wintemp"
except;end;
end;
//## wintempBE ##
function wintempBE:string;//05DEC2010
var
   tmp:string;
begin
try
//defaults
result:=wintemp;//fallback
tmp:=result+'Blaiz Enterprises\';//desired
//get
if crfolderex(tmp,true) then result:=tmp;
except;end;
end;
//## windesktop ##
function windesktop:string;//17MAY2013
begin
try;findfolder(csidl_desktop,result);except;end;
end;
//## winstartup ##
function winstartup:string;
begin
try;findfolder(CSIDL_STARTUP,result);except;end;
end;
//## winprograms ##
function winprograms:string;//start button > programs > - 11NOV2010
begin
try;findfolder(CSIDL_PROGRAMS,result);except;end;
end;
//## showbasic ##
procedure showbasic(xmsg:string);
begin
try;messagebox(application.handle,pchar(xmsg),'Information',mbInformation+MB_OK);except;end;
end;
//## askmessage ##
function askmessage(const Msg: string):Boolean;
begin
try;Result:=(mbrYes=MessageBox(application.handle,pchar(Msg),pchar('Warning'),mbWarning+MB_YESNO));except;end;
end;
//## workarea ##
function workarea:trect;
begin
try
//defaults
result:=rect(0,0,0,0);
//process
systemparametersinfo(SPI_GETWORKAREA,0,@result,0);
except;end;
end;
//## low__centerform ##
procedure low__centerform(x:tcustomform);
var
   a:trect;
   dx,dy:longint;
begin
try
a:=workarea;
dx:=a.left+((a.right-a.left)-x.width) div 2;
dy:=a.top+((a.bottom-a.top)-x.height) div 2;
x.setbounds(dx,dy,x.width,x.height);
except;end;
end;
//## low__showhelp ##
procedure low__showhelp(dw,dh:longint);
var
   dx,dy:longint;
begin
try
//create
if (programhelpviewer=nil) then
   begin
   //range
   if (dw<=0) then dw:=700;
   if (dh<=0) then dh:=700;
   //get
   programhelpviewer:=thelpviewer.create;
   programhelpviewer.setsize(dw,dh);
   end;
//show
programhelpviewer.center;
programhelpviewer.show;
except;end;
end;
//## specialkey ##
function specialkey(key:word):boolean;
begin
try
result:=(key=vk_left) or (key=vk_up) or (key=vk_right) or (key=vk_down) or
(key=vk_home) or (key=vk_end) or (key=vk_prior) or (key=vk_next) or
(key=vk_escape) or (key=vk_return) or (key=vk_tab) or (key=vk_back) or (key=vk_delete) or
((key>=VK_F1) and (key<=VK_F24));
except;end;
end;
//## safekey ##
function safekey(x:word):byte;
begin
try
if (x>255) then x:=255;
result:=x;
except;end;
end;
//## low__keyboardidle ##
function low__keyboardidle:currency;
begin
try;result:=frccurmin(ms64-syskeyboardtime,0);except;end;
//try;result:=pg.keyboardidle;except;end;
end;
//## low__resetkeyboardidle ##
procedure low__resetkeyboardidle;
begin
try;syskeyboardtime:=ms64;except;end;
//try;pg.resetkeyboardidle;except;end;
end;
//## low__newpstring
procedure low__newpstring(var z:pstring);//29NOV2011
begin
system.new(z);
end;
//## low__despstring ##
procedure low__despstring(var z:pstring);//29NOV2011
begin
system.dispose(z);
end;
//## low__getmem ##
function low__getmem(var p:pointer;size:longint):boolean;//29apr2020
begin
result:=true;system.getmem(p,size);
end;
//## low__reallocmem ##
function low__reallocmem(var p:pointer;oldsize,newsize:longint):boolean;//29apr2020
begin
result:=true;system.reallocmem(p,newsize);
end;
//## low__freemem ##
function low__freemem(var x:pointer):boolean;//29apr2020
begin
result:=true;system.freemem(x);
end;
//## low__getmemCLEAR ##
procedure low__getmemCLEAR(var p:pointer;size:integer);//29NOV2011
begin
system.getmem(p,size);fillchar(p^,size,0);
end;
//## low__reallocmemCLEAR ##
procedure low__reallocmemCLEAR(var p:pointer;oldsize,newsize:integer);//29NOV2011
var
   a:pdlbyte;
   i:longint;
begin
//get
system.reallocmem(p,newsize);
//clear
if (newsize>oldsize) then
   begin
   a:=p;
   for i:=frcmin(oldsize,0) to (newsize-1) do a[i]:=0;
   end;
end;
//## low__aiclear ##
procedure low__aiclear(var x:tanimationinformation);
begin
try
with x do
begin
binary:=true;
format:='';
subformat:='';
info:='';//22APR2012
filename:='';
map16:='';//26MAY2009
transparent:=false;
flip:=false;
mirror:=false;
delay:=0;
itemindex:=0;
count:=1;
bpp:=24;
//cursor - 20JAN2012
hotspotX:=0;
hotspotY:=0;
hotspotMANUAL:=false;//use system generated AUTOMATIC hotspot - 03jan2019
//special
owrite32bpp:=false;//22JAN2012
//final
readb64:=false;
readb128:=false;
writeb64:=false;
writeb128:=false;
//internal
iosplit:=0;//none
cellwidth:=0;
cellheight:=0;
end;//end of with
except;end;
end;
//## low__aicopy ##
procedure low__aicopy(var s,d:tanimationinformation);
begin
try
d.format:=s.format;
d.subformat:=s.subformat;
d.filename:=s.filename;
d.map16:=s.map16;
d.transparent:=s.transparent;
d.flip:=s.flip;
d.mirror:=s.mirror;
d.delay:=s.delay;
d.itemindex:=s.itemindex;
d.count:=s.count;
d.bpp:=s.bpp;
d.owrite32bpp:=s.owrite32bpp;
d.binary:=s.binary;
d.readB64:=s.readB64;
d.readB128:=s.readB128;
d.readB128:=s.readB128;
d.writeB64:=s.writeB64;
d.writeB128:=s.writeB128;
d.iosplit:=s.iosplit;
d.cellwidth:=s.cellwidth;
d.cellheight:=s.cellheight;
//.special - 10jul2019
d.hotspotMANUAL:=s.hotspotMANUAL;
d.hotspotX:=s.hotspotX;
d.hotspotY:=s.hotspotY;
except;end;
end;
//## low__plat ##
function low__plat(xcmd,xprgname:string;xrunaction:boolean):string;
const
   platfoldername='Blaiz Enterprises';
   //Website now "http://www.BlaizEnterprises.com" with double encryption of ecap and cestr - 08nov2019, 24oct2019
   //Decode using: "cdstr -> ecap" from BlaizTools
   xportal     ='CNAAaAAAmOpGcJMLAHmOHKCcADCaENDpBICPBIHOnKIOLIMOCNEIhEEFDGLMJdcecLKBHHDFEGMOGEPJLDJHfDLJjCNGMHBDpDNCGIEBANDIJCkHEAInEKElPNKeEBKMOCiFlBoPeLFKjGaINdPBKEgOAeCADLGABKNEHLJBFAFHIFoBJJDNCeIefIEHCHmMNgPp';//http://www.BlaizEnterprises.com - 05jun2020
   xvintage    ='https://www.blaizenterprises.com';//was: 'FDAAAAaABEPGiKJPaiOOFICeAIAGcJBeAKDCFMNkNBCMOfIGKAEMONCCJHLAEJOFNhpAeBIPoMgOFIlbIjjPBLdKHFLIACENGGKFGAJHbIlCNpbCkAFDIGGlglFAkMdCPDeNGDJKNJOOKNaGIOIOPfHHPkJFIIkjFIOdBecNkoIEgLiJjnfLLLFIPGhKiNLOJLCPDFGOIJmKCe'+'pJObMDAOPDJHNHLKffJCGGpiLAEMfGPANJHlhDiEAPCPOCJLOCJFGlkCPLEOaCcBEAhnOCBAElfAcIAOJCJHAPMDaoKBNCGGCHPnKhfHMLEFBEBAMCCnHodfDCICIJHGhaFhEJBIgGNKPP';//http://vintage.BlaizEnterprises.com - 05jun2020
   xfacebook   ='FHAaaAAAnDaBCBNCEFHDADFLiajpGIHaaPBmnCeBbJDnmEOcNeDPPmOMIHDJBLLHILHCFelnHIBhioHoeMLOAPnGcfBODGClLcKiodBeCdCIPgLFLOHmnggKLLCIGmEPmcJIFBbPCLLOKCehiAECKmmFDnimgANPAaHlEHfKOnAFeAHkPEPMbPCJpPFaPdELFAEloiLoIgHEgBd'+'jDCdCjCNhKjlIDAIeDNeMONNJLkajBCEPMDNFPlJHJNLOHLOLmPmbKlpIKcHNECboIHHDbDMeHHCKFiiABFhLJHDhKAMGjKFLPOkDcnICLNBMiDFKNGICiGEACOhhoMEMPMOifCHFCKGpFCAkEgCmdHGFOhPp';
   xtwitter    ='DhAaAAAaMfFBKcIHPMdaLIhMhIHOFMMJpHEeOIDlADNCGFLkCLJKLODCEaIcMIjplNKMPBbNANIEDjNIOMICNJCFOAODKLGmFJIHBEJAPFFCFnCjpjGIhEcoDLjKNFAHFDPKLPCJmoKCJadnFefEINohdhFOHLFnHLHMLMEBhnCIDoGHDcGDebdO'+'ELJobkdoKBEAIKOBgeicdAEIHbaEEFjmKlGNgLlmLPNOPglbMaPP';
   xbyBEcom    ='EcaAAAAaABJEKBJMLhlCbPEgKNPMDHnHENKODJCiAFHJGCKFGKHhoDPPeIBbINHpEdJNNIcABNfhLdMFcNMEOkBCCPMILmHAJPACOmECEcGPKNNAIMGGJCKGPLLjEJJPhIAEGCGHDNICOKPLCAjCKGMEClKNOLEgJDCFJnAJIIKhACOIOJeLOJdN'+'NKDJKNOGNMOAPIIDKbFEDPegPCGomKBMBCMFnNHBMPPLpGLEIHBNNFpOIdBPBKLKKCjCMGDLGjPOkPcBHoGJFOGKMCNBOfPP';//by BlaizEnterprises.com
var
   xprgnameORG,str1,v,xval:string;
   p:longint;
   //## xvisit ##
   function xvisit(xval:string):string;
   begin
   result:=xval;
   if xrunaction and (result<>'') then runlow(result,'');
   end;
begin
try
//defaults
result:='';
//init
xcmd:=lowercase(xcmd);
xval:='';
xprgnameORG:=xprgname;
if (xprgname='') then xprgname:=programnameHARD;
//.split
if (xcmd<>'') then
   begin
   for p:=1 to length(xcmd) do if (xcmd[p]='.') then
      begin
      xval:=copy(xcmd,p+1,length(xcmd));
      xcmd:=copy(xcmd,1,p-1);
      break;
      end;//p
   end;

//get
//.folder
if      (xcmd='folder') then
   begin
   result:=asfolder(asfolder(extractfilepath(application.exename))+platfoldername);//this folder and up we own
   //filter
   if (xprgname<>'') then
      begin
      xprgname:=safefilename(xprgname,true);
      result:=asfolder(result+xprgname);
      end;
   //get
   if xrunaction and (not directoryexists(result)) then forcedirectories(result);
   end
else if (xcmd='root') then result:=asfolder(extractfilepath(application.exename))
else if (xcmd='showroot') then
   begin
   result:=asfolder(extractfilepath(application.exename));
   runlow(result,'');
   end
else if (xcmd='showhelp') then low__showhelp(700,600)
//.visit
else if (xcmd='splash') then result:=cdstr(xportal)//leave the "ecap()" encryption in place -> splash screen expects the url to be encrypted with ecap - 07mar2020
else if (xcmd='portal') then result:=xvisit(ecap(cdstr(xportal),false))
else if (xcmd='program') then result:=xvisit(ecap(cdstr(xportal),false)+low__insstr('/'+safefilename(xprgname,false)+'.html',xprgname<>''))
else if (xcmd='vintage') or (xcmd='backcat') then result:=xvisit(xvintage+low__insstr('/'+safefilename(xprgnameORG,false)+'.html',xprgnameORG<>''))
else if (xcmd='facebook') then result:=xvisit(ecap(cdstr(xfacebook),false))
else if (xcmd='twitter') then result:=xvisit(ecap(cdstr(xtwitter),false))
//.start menu
else if (xcmd='startmenu') then
   begin
   result:=winprograms+xprgname+#32+ecap(cdstr(xbyBEcom),false)+'.lnk';//unique link name on startmenu - 10apr2019, 30mar2019, 02FEB2011
   //.create
   if      (xval='') or (xval='create') then
      begin
      if xrunaction then createlink(result,application.exename,'','');
      end
   //.del
   else if (xval='del') then
      begin
      if xrunaction then low__remfile(result);
      end
   //.exists
   else if (xval='exists') then result:=bn(low__fileexists(result))
   //.toggle
   else if (xval='toggle') then
      begin
      case low__fileexists(result) of
      true:low__plat(xcmd+'.del',xprgname,xrunaction);//delete existing
      false:low__plat(xcmd,xprgname,xrunaction);//create new
      end;//case
      end
   //.error
   else low__showerror(nil,'Unknown directive "'+xcmd+'.'+xval+'" [006]');
   end
//.desktop
else if (xcmd='desktop') then
   begin
   result:=windesktop+xprgname+#32+ecap(cdstr(xbyBEcom),false)+'.lnk';//unique link name on startmenu - 10apr2019, 30mar2019, 02FEB2011
   //.create
   if      (xval='') or (xval='create') then
      begin
      if xrunaction then createlink(result,application.exename,'','');
      end
   //.del
   else if (xval='del') then
      begin
      if xrunaction then low__remfile(result);
      end
   //.exists
   else if (xval='exists') then result:=bn(low__fileexists(result))
   //.toggle
   else if (xval='toggle') then
      begin
      case low__fileexists(result) of
      true:low__plat(xcmd+'.del',xprgname,xrunaction);//delete existing
      false:low__plat(xcmd,xprgname,xrunaction);//create new
      end;//case
      end
   //.error
   else low__showerror(nil,'Unknown directive "'+xcmd+'.'+xval+'" [006]');
   end
else low__showerror(nil,'Unknown directive "'+xcmd+'" [007]');
except;end;
end;
//## low__platroot ##
function low__platroot:string;
begin
try;result:=low__plat('root','',true);except;end;
end;
//## low__platfolder ##
function low__platfolder(xname:string):string;
begin
try;result:=low__plat('folder',xname,true);except;end;
end;
//## low__platsettings ##
function low__platsettings:string;
begin
try;result:=low__platfolder('settings')+remlastext(extractfilename(application.exename))+'.ini';except;end;
end;
//## low__platonce ##
function low__platonce:string;
begin
try;result:=low__platfolder('settings')+remlastext(extractfilename(application.exename))+'.one';except;end;
end;
//## low__plat_close ##
procedure low__plat_close;//01jun2020
begin
try
if (programhelpviewer<>nil) then freeobj(@programhelpviewer);


except;end;
end;
//## low__plat_startofprogram ##
procedure low__plat_startofprogram(exesize:longint);
var
   str1,e:string;
begin
try
//range
if (exesize<0) then exesize:=0;

//init system vars
low__libclear(syslib_int);
low__libclear(syslib_ext);
syskeyboardtime:=ms64;

//load system libraries
//.int
str1:=xsyslib_intdata;
low__libfromdatab(syslib_int,str1);

//.ext
exe_data(application.exename,frcmin(exesize-5000,0),str1);
low__libfromdatab(syslib_ext,str1);

//setup program for first time
if not low__fileexists(low__platonce) then
   begin
   //.mark as done
   low__tofileb(low__platonce,'done',e);
   //.create start button link
   //was: low__plat('startmenu','',true);
   end;
except;end;
end;
//## low__platactive ##
function low__platactive:string;
begin
try;result:=low__platfolder('settings')+remlastext(extractfilename(application.exename))+'.act';except;end;
end;
//## low__visit2 ##
function low__visit2(xname,xname2:string;xrunvalue:boolean):string;
const
   //website now "http://www.blaizenterprises.com" with double encryption of ecap and cestr - 08nov2019, 24oct2019
   //Encode using: "cdstr -> ecap" from BlaizTools
   xportal     ='FAaaAAAADJaeoIeHDEMjglLKCOiJAFLFNegGnCLnbJDkEJGhKDLHfHJPnpMEgMdncogEmIAhepNmDOEEOHFfMEMBEDKhDJnNFAMaOLAOCnKCOOlNCCBgbIBAKkDmedHdlPLcMBEhNOALEBHBGLJpHFJihBPaGFnkpMhhLBFDJOJfAiOMeHABHaPKkgPmHjhPhFkIIOFDBGplLDEAIJJ'+'oGHmONAPLOKNNGHckHooDaDOOpCPAIOFMKcPlGPBKlnOKnEmJOaMBpAGfcgiICKLGNlgnJLPgLhcGKBpMJEBCHcPKbJibpHNIfDAflaOCNGMaaPGBjDAmPHgmKPPp';
   xbackcat    ='EHAAAAAaDakJFCKHFENHMcgFCMMLABODILLPFnhPmLJGGKKEPJMMlJDDFMMCAAHdOgnKoEAoBOInMPOJflJIEPOeHaIaFfFFjLMmdjLPODChEDKjhPHjiCgPACOMKCBKOkOAJBcIJFGclEaFCAjjGHBAFMCMIPBnJCemNgAjAHKnBMINakIGfHHfgPFaKLCDMLAffMJpPmPGndnpOLpD'+'MDJBBnLLOFDJoDKKnCNKIIBBDCkaLbPGJnDdCIeINlOMiNbhDMJJGCIeNKLonCPlNGMBLNnpNPMINcagLjFCINpP';
   xfacebook   ='FHAaaAAAnDaBCBNCEFHDADFLiajpGIHaaPBmnCeBbJDnmEOcNeDPPmOMIHDJBLLHILHCFelnHIBhioHoeMLOAPnGcfBODGClLcKiodBeCdCIPgLFLOHmnggKLLCIGmEPmcJIFBbPCLLOKCehiAECKmmFDnimgANPAaHlEHfKOnAFeAHkPEPMbPCJpPFaPdELFAEloiLoIgHEgBd'+'jDCdCjCNhKjlIDAIeDNeMONNJLkajBCEPMDNFPlJHJNLOHLOLmPmbKlpIKcHNECboIHHDbDMeHHCKFiiABFhLJHDhKAMGjKFLPOkDcnICLNBMiDFKNGICiGEACOhhoMEMPMOifCHFCKGpFCAkEgCmdHGFOhPp';
   xtwitter    ='DhAaAAAaMfFBKcIHPMdaLIhMhIHOFMMJpHEeOIDlADNCGFLkCLJKLODCEaIcMIjplNKMPBbNANIEDjNIOMICNJCFOAODKLGmFJIHBEJAPFFCFnCjpjGIhEcoDLjKNFAHFDPKLPCJmoKCJadnFefEINohdhFOHLFnHLHMLMEBhnCIDoGHDcGDebdO'+'ELJobkdoKBEAIKOBgeicdAEIHbaEEFjmKlGNgLlmLPNOPglbMaPP';
var
   p:longint;
begin
try
//init
result:='';
xname:=lowercase(xname);
//hack filter
if (xname2<>'') then
   begin
   for p:=1 to length(xname2) do if (xname2[p]='/') or (xname2[p]='\') or (xname2[p]='.') or (xname2[p]='%') then xname2[p]:='-';
   end;
//get
if      (xname='splash')     then result:=cdstr(xportal)//leave the "ecap()" encryption in place -> splash screen expects the url to be encrypted with ecap - 07mar2020
else if (xname='portal')     then result:=ecap(cdstr(xportal),false)
else if (xname='program')    then result:=ecap(cdstr(xportal),false)+low__insstr('/'+xname2+'.html',xname2<>'')
else if (xname='backcat')    then result:=ecap(cdstr(xbackcat),false)+low__insstr('/'+xname2+'.html',xname2<>'')
else if (xname='facebook')   then result:=ecap(cdstr(xfacebook),false)
else if (xname='twitter')    then result:=ecap(cdstr(xtwitter),false)
else
   begin
   low__showerror(nil,'Unknown directive [d005]');
   sihalt;
   end;
//set
if xrunvalue and (result<>'') then runlow(result,'');
except;end;
end;
//## low__visit ##
procedure low__visit(xname,xname2:string);
begin
try;low__visit2(xname,xname2,true);except;end;
end;
//## runLOW ##
procedure runLOW(fDOC,fPARMS:string);//stress tested on Win98/WinXP - 27NOV2011, 06JAN2011
begin
try;shellexecute(longint(0),nil,PChar(fDoc),PChar(fPARMS),nil,1);except;end;
end;
//## freeobj ##
procedure freeobj(x:pobject);//05DEC2011, 14JAN2011, 15OCT2004
begin
try
//check
if (x=nil) or (x^=nil) then exit;
//hide
if (x^ is twincontrol) then
   begin
   with (x^ as twincontrol) do
   begin
   visible:=false;
   parent:=nil;
   end;//with
   end;
//get
x^.free;
x^:=nil;
except;end;
end;
//## showerror60 ##
procedure showerror60(e:string);
begin
try;low__showerror(nil,e);except;end;
end;
//## low__showerror ##
procedure low__showerror(sender:tobject;e:string);//01jan2020
begin
try
//case sysbooted of
//true:misc.poperror2(nil,e);
//false:messagebox(application.handle,e,'Error!',mbError+MB_OK);
//end;
messagebox(application.handle,pchar(e),'Error!',mbError+MB_OK);
except;end;
end;
//## asfolder ##
function asfolder(x:string):string;//enforces trailing "\"
begin
try;if (copy(x,length(x),1)<>'\') then result:=x+'\' else result:=x;except;end;
end;
//## asfolderNIL ##
function asfolderNIL(x:string):string;//enforces trailing "\" AND permits NIL - 10mar2014
begin
try;if (x='') then result:='' else result:=asfolder(x);except;end;
end;
//## nozero ##
function nozero(xdebugID,x:longint):longint;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (int) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_byt ##
function nozero_byt(xdebugID:longint;x:byte):byte;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (byte) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_dbl ##
function nozero_dbl(xdebugID:longint;x:double):double;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (double) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_ext ##
function nozero_ext(xdebugID:longint;x:extended):extended;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (extended) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_cur ##
function nozero_cur(xdebugID:longint;x:currency):currency;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (currency) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_sig ##
function nozero_sig(xdebugID:longint;x:single):single;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (single) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_rel ##
function nozero_rel(xdebugID:longint;x:real):real;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (real) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## nozero_cmp ##
function nozero_cmp(xdebugID:longint;x:comp):comp;
begin
try
//defaults
result:=1;//fail safe value
//check
if (xdebugID<1000000) then low__showerror(nil,'Invalid no zero location value '+inttostr(xdebugID));//value MUST BE 1 million or above - this is strictly a made-up threshold to make it standout from code and code values - 26jul2016
//get
if (x=0) then
   begin
   //in program debug
   if programactivedebugger then low__showerror(nil,'No zero (comp) error at location '+inttostr(xdebugID));
   //other
   exit;
   end
else result:=x;//acceptable value (non-zero)
except;end;
end;
//## StdEncrypt ##
Function StdEncrypt(X:String;EKey:String;Mode1:Integer):String;
Var
   Lt,El,E,p2,p:integer;
begin
try
Lt:=Length(X);
El:=Length(EKey);
E:=0;
case Mode1 of
0:begin
//Encrypt the String:
For P:=1 to Lt do
begin
E:=E+1;
If (E>El) then E:=1;
p2:=Ord(EKey[E])+Ord(X[p]);
if (p2>255) then p2:=p2-256;
X[p]:=chr(p2);
end;//end of loop
end;//end of begin
1:begin
//Decrypt the String:
for p:=1 to Lt do
begin
E:=E+1;
If (E>El) then E:=1;
p2:=Ord(X[p])-Ord(EKey[E]);
if (p2<0) then p2:=p2+256;
X[p]:=chr(p2);
end;//end of loop
end;//end of begin
2:begin
//Encrypt PlainText to PlainText String (13-255):
For P:=1 to Lt do
begin
E:=E+1;
If (E>El) then E:=1;
p2:=Ord(EKey[E])+Ord(X[p]);
if (p2>255) then p2:=p2-242;
X[p]:=chr(p2);
end;//end of loop
end;//end of begin
3:begin
//Decrypt the String:
for p:=1 to Lt do
begin
E:=E+1;
If (E>El) then E:=1;
p2:=Ord(X[p])-Ord(EKey[E]);
if (p2<14) then p2:=p2+242;
X[p]:=chr(p2);
end;//end of loop
end;//end of begin
end;
Result:=X;
except;end;
end;
//## ECapK ##
Function ECapK:String;
Const
     map='asdfklj4imzxhmewro982489alkt9[1239-12,as[023aeoi43q[9';
Var
   MaxP,P:Integer;
   X:String;
begin{Generate Random Key}
try
{Prepare}
MaxP:=10+Random(41);{10-50}
X:=Copy(map,1,MaxP);
{Process}
For P:=1 to MaxP Do X[P]:=map[1+random(50)];
{Return Result}
Result:=X;
except;end;
end;
//## ECap ##
Function ECap(X:String;E:Boolean):String;
begin
try;result:=ECapBin(x,e,false);except;end;
end;
//## ECapBin ##
Function ECapBin(X:String;E,bin:Boolean):String;
Var
   kLen:Integer;
   Z,K:String;
   ee,dd:byte;
begin{Encrypt/Decrypt Caption - Valid input range 14-255}
try
{Default}
Result:='';
{Ignore}
If (X='') then exit;
{ascii/binary}
case bin of
true:begin
     ee:=glseEncrypt;
     dd:=glseDecrypt;
     end;//end of begin
false:begin
     ee:=glseTextEncrypt;
     dd:=glseTextDecrypt;
     end;//end of begin
end;//end of case
{Process}
Case E of
True:begin{Encrypt}
    {Gen. Key}
    K:=ECapK;
    kLen:=Length(K);
    {Encrypt}
    Z:=StdEncrypt(X,K,ee);
    {Header - kLlength(1),Key(10-50),eData(0..X)}
    Z:=Chr(14+kLen)+StdEncrypt(K,glseEDK,dd)+Z;
    {Filter}
    if not bin then SwapStrs(Z,#39,#39+#39);
    {Return Result}
    Result:=Z;
    end;//end of begin
False:begin{Decrypt}
     {Filter}
     if not bin then SwapStrs(X,#39+#39,#39);
     {kLength}
     kLen:=Ord(X[1])-14;
     {Prepare}
     K:=Copy(X,2,kLen);
     Z:=Copy(X,kLen+2,Length(X));
     {Decrypt}
     K:=StdEncrypt(K,glseEDK,ee);
     Z:=StdEncrypt(Z,K,dd);
     {Return Result}
     Result:=Z;
     end;//end of begin
end;//end of case
except;end;
end;
//## lestr ##
function lestr(x:string):string;//lite-encoder
var
   p:longint;
begin
try
result:='';
xysort(#4,'kljasd()*3aeasff',x);
for p:=1 to length(x) do result:=result+from8bit2(byte(x[p]));
for p:=1 to length(result) do if (result[p]>='A') and (result[p]<='Z') and (random(3)=2) then result[p]:=char(byte(result[p])+32);
except;end;
end;
//## ldstr ##
function ldstr(x:string):string;//lite-decoder
var
   p:longint;
begin
try
result:='';
x:=uppercase(x);
for p:=1 to (length(x) div 2) do result:=result+char(to8bit2(copy(x,(p*2)-1,2)));
xysort(#4,'kljasd()*3aeasff',result);
except;end;
end;
//## cestr ##
function cestr(x:string):string;//critical-encoder
var//Note: Now super fast for large daata-blocks 1MB+ - 09nov2019
   v32,v,xlen,dp,p:longint;
   v1,v2:string;
   a1,a2:byte;
   bol1:boolean;
begin
try
//defaults
result:='';
//check
if (x='') then exit;
//get
xlen:=length(x);
v32:=low__crc32seedable(x,8234723);
//.v1 - 09nov2019
setlength(v1,xlen);
for p:=1 to xlen do v1[p]:=char(random(255));
//.v2
setlength(v2,xlen);
for p:=1 to xlen do
begin
v:=ord(x[p])-ord(v1[p]);
if (v<0) then inc(v,256);
v2[p]:=char(byte(v));
end;//p
//.sort
xysort(#1,'345987af',v1);
xysort(#0,'9823NBjkASDFlkj',v1);
xysort(#3,'09435a9dg',v2);
xysort(#5,'##adsfoiu)(_)1',v2);
//was: for p:=1 to xlen do pushb(int1,result,low__aorbstr(from8bit2(byte(v1[p]))+from8bit2(byte(v2[p])),from8bit2(byte(v2[p]))+from8bit2(byte(v1[p])),isodd(p)));
setlength(result,xlen*4);
dp:=1;
for p:=1 to xlen do
begin
//.isodd
case (p<>((p div 2)*2)) of
true:begin
   a1:=byte(v2[p]);
   a2:=byte(v1[p]);
   end;
false:begin
   a1:=byte(v1[p]);
   a2:=byte(v2[p]);
   end;
end;
//.a1
result[dp+0]:=char(65+(a1 div 16));
result[dp+1]:=char(65+a1-((a1 div 16)*16));
//.a2
result[dp+2]:=char(65+(a2 div 16));
result[dp+3]:=char(65+a2-((a2 div 16)*16));
//.inc
inc(dp,4);
end;//p

//.finalise
result:=from32bit8(xlen)+result+from32bit8(v32);
//.az-AZ -> randomly swap chars from uppercase to lowercase (has no affect on data) - 09nov2019
for p:=1 to length(result) do if (random(5)=2) and (result[p]>='A') and (result[p]<='Z') then result[p]:=char(byte(result[p])+32);
except;end;
end;
//## cestr_bin ##
function cestr_bin(x:string):string;//critical-encoder
var//Note: Now super fast for large daata-blocks 1MB+ - 12nov2019
   v32,v,xlen,dp,p:longint;
   v1,v2:string;
   a1,a2:byte;
   bol1:boolean;
begin
try
//defaults
result:='';
//check
if (x='') then exit;
//get
xlen:=length(x);
v32:=low__crc32seedable(x,8234723);
//.v1 - 09nov2019
setlength(v1,xlen);
for p:=1 to xlen do v1[p]:=char(random(255));
//.v2
setlength(v2,xlen);
for p:=1 to xlen do
begin
v:=ord(x[p])-ord(v1[p]);
if (v<0) then inc(v,256);
v2[p]:=char(byte(v));
end;//p
//.sort
xysort(#1,'345987af',v1);
xysort(#0,'9823NBjkASDFlkj',v1);
xysort(#3,'09435a9dg',v2);
xysort(#5,'##adsfoiu)(_)1',v2);
//was: for p:=1 to xlen do pushb(int1,result,low__aorbstr(from8bit2(byte(v1[p]))+from8bit2(byte(v2[p])),from8bit2(byte(v2[p]))+from8bit2(byte(v1[p])),isodd(p)));
setlength(result,xlen*2);
dp:=1;
for p:=1 to xlen do
begin
//.isodd
case (p<>((p div 2)*2)) of
true:begin
   result[dp+0]:=v2[p];
   result[dp+1]:=v1[p];
   end;
false:begin
   result[dp+0]:=v1[p];
   result[dp+1]:=v2[p];
   end;
end;
//.inc
inc(dp,2);
end;//p

//.finalise
result:=from32bit(xlen)+result+from32bit(v32);
except;end;
end;
//## cestr_rkey ##
function cestr_rkey(x:string;xbin:boolean):string;//critical-encoder - 12nov2019
var
   k:string;
   p:longint;
begin
try
//defaults
result:='';
//key + encode with key
setlength(k,10+random(40));
for p:=1 to length(k) do k[p]:=char(random(255));
xysort(#103,k,x);//encode
//data
x:=from32bit(length(k))+k+x;
//get
case xbin of
true:result:=cestr_bin(x);
false:result:=cestr(x);
end;
except;end;
end;
//## cdstr ##
function cdstr(x:string):string;//critical-decoder - 09nov2019
var
   dlen,vlen,a1,a2,a3,sp,int1,v32,v,xlen,p:longint;
   v1,v2:string;
begin
try
//defaults
result:='';
//.error check #1
if (length(x)<16) then
   begin
   low__showerror(nil,ldstr('gpgBHEGbgMcaEFhCHcGpHCDKcafaHCgpGhhcgBGNCAGJHDCAGjGOgDEgGbHagMGFhEGFcMcaGEGngNGcGHgFGEcaGpHCcAgIGBHdcAgBgogfgfgBHEcaHChAGFGNGEgFhEhHgjCAgico'));
   sihalt;
   end;
//init
x:=uppercase(x);
dlen:=to32bit8(copy(x,1,8));
v32:=to32bit8(copy(x,length(x)-7,8));
delete(x,1,8);
delete(x,length(x)-7,8);
xlen:=length(x);
//.error check #2
if (dlen<=0) then
   begin
   low__showerror(nil,ldstr('gpgBHEGbgMcaEFhCHcGpHCDKcafaHCgpGhhcgBGNCAGJHDCAGjGOgDEgGbHagMGFhEGFcMcaGEGngNGcGHgFGEcaGpHCcAgIGBHdcAgBgogfgfgBHEcaHChAGFGNGEgFhEhHgjCAgico'));
   sihalt;
   end;
//get
vlen:=xlen div 4;
setlength(v1,vlen);
setlength(v2,vlen);
sp:=1;
for p:=1 to vlen do
begin
//.isodd
case (p<>((p div 2)*2)) of
true:begin
   //.v1
   a1:=byte(x[sp+2])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+3])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v1[p]:=char((a1*16)+a2);
   //.v2
   a1:=byte(x[sp+0])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+1])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v2[p]:=char((a1*16)+a2);
   end;
false:begin
   //.v1
   a1:=byte(x[sp+0])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+1])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v1[p]:=char((a1*16)+a2);
   //.v2
   a1:=byte(x[sp+2])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+3])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v2[p]:=char((a1*16)+a2);
   end;
end;//case
//.inc
inc(sp,4);
if ((sp+3)>xlen) then break;
end;//p

//.sort
xysort(#0,'9823NBjkASDFlkj',v1);//fixed incorrect v1/v2 assignment order - 09nov2019
xysort(#1,'345987af',v1);
xysort(#5,'##adsfoiu)(_)1',v2);
xysort(#3,'09435a9dg',v2);

//.result
setlength(result,vlen);
for p:=1 to vlen do
begin
v:=ord(v2[p])+ord(v1[p]);
if (v>255) then dec(v,256);
result[p]:=char(byte(v));
end;//p

//.v32 check
int1:=low__crc32seedable(result,8234723);
//.error check #3
if (int1<>v32) then
   begin
   low__showerror(nil,ldstr('gpgbHEgBGmCAEFHCHCGPHCdKcAfaHCGPgHhCGbgnCagJhDCaGjgOGDEGgBHAgMGFhEGfCMCAGEGnGNGCGhGFGecaGPhCCAgIgbhDCAGBgOGFGFgBHECAhChAgFGnGEgFHeHhgJCAGICo'));
   sihalt;
   end;
//.error check #4
if (result='') then
   begin
   low__showerror(nil,ldstr('GPgbhEGBGMCAEFhCHCGphcDKCAfaHcgPGHhCGBgNcAGJHDcAGjgoGdEGGBHaGmGfHEGfCMcaGegNGNgcGhGFGecAgPhCCAGIGbHdCAGBGOGFGFgbHEcaHCHagfGNGeGFhEHHgjCaGICO'));
   sihalt;
   end;
except;end;
end;
//## __cdstr2 ##
function __cdstr2(x:string):string;//critical-decoder BUT doesn't shutdown! - 08mar2018
begin
try;result:=__cdstr(x,false);except;end;
end;
//## __cdstr ##
function __cdstr(x:string;xshow:boolean):string;//critical-decoder BUT doesn't shutdown! - 09nov2019, 08mar2018
var
   dlen,vlen,a1,a2,a3,sp,int1,v32,v,xlen,p:longint;
   v1,v2:string;
begin
try
//defaults
result:='';
//.error check #1
if (length(x)<16) then
   begin
   if xshow then low__showerror(nil,'Decode error #1');
   exit;
   end;
//init
x:=uppercase(x);
dlen:=to32bit8(copy(x,1,8));
v32:=to32bit8(copy(x,length(x)-7,8));
delete(x,1,8);
delete(x,length(x)-7,8);
xlen:=length(x);
//.error check #2
if (dlen<=0) then
   begin
   if xshow then low__showerror(nil,'Decode error #2');
   exit;
   end;
//get
vlen:=xlen div 4;
setlength(v1,vlen);
setlength(v2,vlen);
sp:=1;
for p:=1 to vlen do
begin
//.isodd
case (p<>((p div 2)*2)) of
true:begin
   //.v1
   a1:=byte(x[sp+2])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+3])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v1[p]:=char((a1*16)+a2);
   //.v2
   a1:=byte(x[sp+0])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+1])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v2[p]:=char((a1*16)+a2);
   end;
false:begin
   //.v1
   a1:=byte(x[sp+0])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+1])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v1[p]:=char((a1*16)+a2);
   //.v2
   a1:=byte(x[sp+2])-65;if (a1<0) then a1:=0 else if (a1>15) then a1:=15;
   a2:=byte(x[sp+3])-65;if (a2<0) then a2:=0 else if (a2>15) then a2:=15;
   v2[p]:=char((a1*16)+a2);
   end;
end;//case
//.inc
inc(sp,4);
if ((sp+3)>xlen) then break;
end;//p

//.sort
xysort(#0,'9823NBjkASDFlkj',v1);//fixed incorrect v1/v2 assignment order - 09nov2019
xysort(#1,'345987af',v1);
xysort(#5,'##adsfoiu)(_)1',v2);
xysort(#3,'09435a9dg',v2);

//.result
setlength(result,vlen);
for p:=1 to vlen do
begin
v:=ord(v2[p])+ord(v1[p]);
if (v>255) then dec(v,256);
result[p]:=char(byte(v));
end;//p

//.v32 check
int1:=low__crc32seedable(result,8234723);
//.error check #3
if (int1<>v32) then
   begin
   if xshow then low__showerror(nil,'Decode error #3');
   exit;
   end;
//.error check #4
if (result='') then
   begin
   if xshow then low__showerror(nil,'Decode error #4');
   exit;
   end;
except;end;
end;
//## __cdstr2_bin ##
function __cdstr2_bin(x:string):string;//critical-decoder BUT doesn't shutdown! - 08mar2018
begin
try;result:=__cdstr_bin(x,false,false);except;end;
end;
//## __cdstr_bin ##
function __cdstr_bin(x:string;xshow,xclose:boolean):string;//critical-decoder BUT doesn't shutdown! - 09nov2019, 08mar2018
var
   dlen,vlen,a1,a2,a3,sp,int1,v32,v,xlen,p:longint;
   v1,v2:string;
begin
try
//defaults
result:='';
//.error check #1
if (length(x)<8) then
   begin
   if xclose then
      begin
      low__showerror(nil,ldstr('gpgBHEGbgMcaEFhCHcGpHCDKcafaHCgpGhhcgBGNCAGJHDCAGjGOgDEgGbHagMGFhEGFcMcaGEGngNGcGHgFGEcaGpHCcAgIGBHdcAgBgogfgfgBHEcaHChAGFGNGEgFhEhHgjCAgico'));
      sihalt;
      end;
   if xshow then low__showerror(nil,'Decode error #1');
   exit;
   end;
//init
dlen:=to32bit(copy(x,1,4));
v32:=to32bit(copy(x,length(x)-3,4));
delete(x,1,4);
delete(x,length(x)-3,4);
xlen:=length(x);
//.error check #2
if (dlen<=0) then
   begin
   if xclose then
      begin
      low__showerror(nil,ldstr('gpgBHEGbgMcaEFhCHcGpHCDKcafaHCgpGhhcgBGNCAGJHDCAGjGOgDEgGbHagMGFhEGFcMcaGEGngNGcGHgFGEcaGpHCcAgIGBHdcAgBgogfgfgBHEcaHChAGFGNGEgFhEhHgjCAgico'));
      sihalt;
      end;
   if xshow then low__showerror(nil,'Decode error #2');
   exit;
   end;
//get
vlen:=xlen div 2;
setlength(v1,vlen);
setlength(v2,vlen);
sp:=1;
for p:=1 to vlen do
begin
//.isodd
case (p<>((p div 2)*2)) of
true:begin
   v2[p]:=x[sp+0];
   v1[p]:=x[sp+1];
   end;
false:begin
   v1[p]:=x[sp+0];
   v2[p]:=x[sp+1];
   end;
end;//case
//.inc
inc(sp,2);
if ((sp+1)>xlen) then break;
end;//p

//.sort
xysort(#0,'9823NBjkASDFlkj',v1);//fixed incorrect v1/v2 assignment order - 09nov2019
xysort(#1,'345987af',v1);
xysort(#5,'##adsfoiu)(_)1',v2);
xysort(#3,'09435a9dg',v2);

//.result
setlength(result,vlen);
for p:=1 to vlen do
begin
v:=ord(v2[p])+ord(v1[p]);
if (v>255) then dec(v,256);
result[p]:=char(byte(v));
end;//p

//.v32 check
int1:=low__crc32seedable(result,8234723);
//.error check #3
if (int1<>v32) then
   begin
   if xclose then
      begin
      low__showerror(nil,ldstr('gpgbHEgBGmCAEFHCHCGPHCdKcAfaHCGPgHhCGbgnCagJhDCaGjgOGDEGgBHAgMGFhEGfCMCAGEGnGNGCGhGFGecaGPhCCAgIgbhDCAGBgOGFGFgBHECAhChAgFGnGEgFHeHhgJCAGICo'));
      sihalt;
      end;
   if xshow then low__showerror(nil,'Decode error #3');
   exit;
   end;
//.error check #4
if (result='') then
   begin
   if xclose then
      begin
      low__showerror(nil,ldstr('GPgbhEGBGMCAEFhCHCGphcDKCAfaHcgPGHhCGBgNcAGJHDcAGjgoGdEGGBHaGmGfHEGfCMcaGegNGNgcGhGFGecAgPhCCAGIGbHdCAGBGOGFGFgbHEcaHCHagfGNGeGFhEHHgjCaGICO'));
      sihalt;
      end;
   if xshow then low__showerror(nil,'Decode error #4');
   exit;
   end;
except;end;
end;
//## cdstr_rkey ##
function cdstr_rkey(x:string;xbin,xshow,xclose:boolean):string;//critical-decoder - 12nov2019
label
   skipend;
var
   k:string;
   klen:longint;
begin
try
//defaults
result:='';
//get
case xbin of
true: if xclose then x:=__cdstr_bin(x,false,true) else x:=__cdstr_bin(x,xshow,false);
false:if xclose then x:=cdstr(x)                  else x:=__cdstr(x,xshow);
end;
//key + decode with key
if (length(x)<4) then goto skipend;
klen:=to32bit(copy(x,1,4));
delete(x,1,4);
if (klen<=0) then goto skipend;
k:=copy(x,1,klen);
delete(x,1,klen);
xysort(#203,k,x);//decode
//return result
result:=x;
skipend:
except;end;
end;
//## xysort ##
procedure xysort(xstyle,xdata:string;var x:string);
label//Note: xdata=is actually the encryption key
   redo2,redo;
var
   int1,s,v,i2,i,p2,p,xdatalen,xreflen,xlen:longint;
   c:char;
   xref:string;
begin
try
//init
xlen:=length(x);
//.xstyle
if (xstyle='') then xstyle:=#1;
//.xdata -> encryption key
if (xdata='') then xdata:=copy(#9#251#34#22#10#29#175#174#103#28#62#91#61#01#78,3,99);
xdatalen:=length(xdata);
//loop
redo2:
//xref
s:=ord(xstyle[1]);
case s of
0,100,200:xref:=#2#1#4#7#3#12#8#6#9#23#11#12#18#4#27#18#24#42#17#22#31;
1,101,201:xref:=#9#3#2#1#5#13#22#10#8#8#3#2#17#40;
2,102,202:xref:=#11#8#5#2#4#3#2#7#22#1#18#33#12#14#55;
3,103,203:xref:=#3#3#4#5#16#7#3#1#3#6#5#8#17#9#11#24#23#14#15#17;
4,104,204:xref:=#27#9#99#12#2#2#3#1#3#3#55#13#47#117#213#101#98#19#10#6;
5,105,205:xref:=#3#4#5#120#77#13#33#7#5#10#9#4#3#37#50#21#79#100;
else xref:=#8#2#5#7#1#5#2#9#5#18#44#29#13#14#37#22#1#4#2#6#7#2#11;
end;
xreflen:=length(xref);
delete(xstyle,1,1);

//.decrypt
if (s>=200) then
   begin
   //get
   p2:=1;
   for p:=1 to xlen do
   begin
   int1:=ord(x[p])-ord(xdata[p2]);
   if (int1<0) then int1:=int1+256;
   x[p]:=char(int1);
   inc(p2);
   if (p2>xdatalen) then p2:=1;
   end;//p
   end;//s
//.clear
p:=1;
i:=1;
i2:=1;
redo:
//.swap width
if (i>xreflen) then
   begin
   case i2 of
   0,1:i:=2;
   2:i:=4;
   3:i:=7;
   4:i:=3;
   5:i:=9;
   6:i:=13;
   else i:=3;
   end;
   inc(i2);
   if (i2>=7) then i2:=0;
   if (i>xreflen) then i:=1;
   end;
v:=ord(xref[i]);
inc(i);
p2:=p+v;
//.do swap
if (p2<=xlen) then
   begin
   c:=x[p];
   x[p]:=x[p2];
   x[p2]:=c;
   p:=p2;
   end;
//inc
inc(p);
if (p<=xlen) then goto redo;

//.encrypt
if (s>=100) and (s<200) then
   begin
   //get
   p2:=1;
   for p:=1 to xlen do
   begin
   int1:=ord(x[p])+ord(xdata[p2]);
   if (int1>=256) then int1:=int1-256;
   x[p]:=char(int1);
   inc(p2);
   if (p2>xdatalen) then p2:=1;
   end;//p
   end;//s

//xstyle inc
if (xstyle<>'') then goto redo2;
except;end;
end;
//## xsaferef ##
function xsaferef(x:longint):string;
begin
try
case x of
0:result:=#120#155#41#239#133#77#164#119#248#133#91#234#155#184#224#103#19#40#133#139#90#18#194#185#18#202#31#167#53#17#71#53#52#68#131#194#159#73#186#135#188#82#161#158#202#198#214#211#210#3;
1:result:=#2#84#44#188#52#218#55#41#33#253#216#72#1#169#195#231#16#245#170#64#21#224#189#70#105#159#63#14#76#134#244#215#155#195#191#165#50#105#183#118#123#124#120#127#5#20#147#6#40#175;
2:result:=#68#171#252#84#229#80#67#28#196#235#237#71#65#231#118#242#109#234#51#5#151#35#70#4#92#117#237#206#67#34#59#122#1#202#144#210#211#229#83#40#156#1#191#130#177#121#203#93#131#110;
3:result:=#124#116#142#39#49#89#60#43#165#213#167#193#204#69#104#162#191#115#214#253#81#185#121#50#23#71#116#210#230#226#66#212#43#157#8#249#125#39#72#232#110#204#201#113#114#96#242#249#80#113;
4:result:=#246#20#136#173#132#166#157#73#236#67#42#200#221#135#45#143#36#156#1#247#33#55#219#247#230#191#216#130#19#92#219#44#234#42#217#193#89#203#83#223#177#27#10#183#129#180#70#122#180#141;
5:result:=#36#64#220#230#213#66#109#62#188#199#41#25#207#36#35#193#184#153#7#81#137#8#140#174#16#185#73#78#13#178#68#213#230#82#7#9#153#56#5#133#242#171#141#68#109#2#191#227#44#188;
6:result:=#20#45#230#97#125#88#215#65#69#8#237#176#12#253#218#105#156#243#182#12#131#47#96#19#139#179#201#143#150#29#208#150#118#149#101#46#181#115#18#33#124#92#40#18#251#20#36#161#15#66;
7:result:=#18#148#246#219#2#66#97#5#206#188#49#124#213#117#155#9#84#87#155#98#133#145#229#137#207#150#184#169#126#251#70#210#228#73#158#46#228#227#67#149#57#154#205#150#0#141#98#71#84#103;
8:result:=#203#136#9#48#112#143#201#36#152#213#55#95#154#199#184#73#240#203#44#6#87#138#154#96#93#131#166#244#32#85#93#143#19#80#137#251#252#53#211#193#168#50#47#146#219#135#113#86#149#96;
9:result:=#15#28#184#202#88#105#132#222#181#168#156#122#185#163#115#38#10#89#95#2#123#157#166#219#220#69#74#188#64#213#105#154#216#250#119#1#171#52#158#199#173#134#19#67#6#26#38#122#156#16;
10:result:=#98#70#38#8#8#117#74#7#156#86#175#209#124#47#230#220#149#157#162#99#184#227#160#81#52#129#54#14#147#194#107#77#193#17#9#117#242#37#22#78#253#133#154#247#20#210#173#97#10#211;
11:result:=#29#188#148#89#56#177#36#72#144#66#90#120#179#160#47#56#49#126#68#148#112#114#11#194#50#153#167#65#179#137#192#155#209#45#166#213#175#50#123#240#174#23#78#24#197#254#79#86#124#223;
12:result:=#138#241#32#178#214#198#250#172#228#58#147#187#152#175#73#192#25#136#214#66#69#24#127#150#117#35#7#191#187#200#159#123#9#238#127#47#230#143#204#202#172#127#251#194#101#143#224#172#202#37;
13:result:=#17#52#2#156#69#106#10#29#238#160#1#175#32#84#184#193#122#236#53#97#211#49#18#216#175#203#235#127#202#69#75#228#86#65#166#165#150#228#122#144#12#191#161#241#92#148#68#36#149#213;
14:result:=#49#194#145#194#94#17#133#106#233#133#12#8#225#129#51#129#153#152#93#246#106#9#253#161#16#55#128#136#12#84#227#182#187#124#216#5#15#246#104#147#13#110#124#144#135#61#198#246#184#36;
15:result:=#215#58#175#25#121#48#184#239#145#159#35#20#17#65#42#157#210#33#211#93#87#161#248#201#203#164#232#218#196#131#82#56#151#233#85#84#72#182#245#74#102#112#80#169#91#10#72#121#250#227;
16:result:=#145#28#101#83#68#233#121#40#105#162#118#238#44#9#133#229#153#84#71#228#26#62#170#178#16#222#146#139#84#165#35#193#97#13#185#202#122#230#220#40#29#96#181#228#125#16#216#177#238#181;
17:result:=#102#206#105#131#221#67#146#1#31#33#253#252#111#205#142#16#141#142#26#156#29#209#205#99#243#242#242#8#34#117#252#26#171#237#30#152#83#35#185#226#247#13#109#157#86#194#154#7#49#136;
18:result:=#150#169#56#120#249#129#52#141#171#241#67#250#156#38#46#30#100#190#49#118#31#218#173#116#61#234#166#253#58#217#7#6#87#114#0#146#210#17#15#12#60#19#114#180#220#131#29#158#94#250;
19:result:=#116#134#13#193#96#96#121#137#126#130#85#115#133#186#183#29#26#187#61#238#175#168#172#242#57#180#2#220#182#20#32#24#234#191#130#245#197#189#165#102#84#243#9#194#56#187#5#150#254#177;
20:result:=#211#122#212#131#121#95#119#179#128#229#82#135#178#161#57#178#53#89#41#94#182#173#238#158#165#185#189#132#132#141#251#87#227#151#212#160#146#103#93#12#4#82#86#100#20#234#213#21#138#82;
21:result:=#103#247#24#210#107#109#175#81#200#241#108#117#51#179#110#174#149#228#91#95#115#189#107#218#66#123#53#8#13#190#159#202#241#35#167#141#57#243#223#130#32#70#231#134#153#240#42#171#148#29;
22:result:=#172#224#147#110#200#61#164#0#250#210#252#171#68#48#207#92#182#213#30#103#35#77#159#41#21#186#248#94#127#254#223#247#210#200#234#99#98#57#35#139#61#232#154#253#249#117#153#5#11#235;
23:result:=#49#161#154#180#52#163#8#211#237#110#140#155#28#9#141#54#252#137#179#148#119#25#202#172#171#249#249#15#126#100#224#81#223#32#152#191#225#36#200#82#233#184#35#248#129#198#17#141#159#112;
24:result:=#106#25#109#9#100#65#203#8#48#248#63#160#227#205#233#4#168#120#191#125#80#128#50#245#199#21#218#142#5#120#253#76#105#146#229#32#190#146#107#180#59#175#50#201#55#106#99#20#132#237;
25:result:=#247#228#143#104#224#7#181#110#137#156#133#226#148#243#199#209#213#134#130#76#204#177#111#53#65#206#113#117#180#185#31#53#202#244#104#216#226#236#217#10#128#22#35#252#56#226#206#173#70#199;
26:result:=#78#225#7#210#210#16#232#134#155#131#154#3#156#98#136#172#178#103#249#206#212#110#71#2#225#59#13#58#254#251#83#213#177#134#7#17#35#73#61#168#53#104#37#160#84#146#153#108#56#105;
27:result:=#185#248#253#168#249#75#58#86#142#187#10#156#47#2#50#53#138#137#206#112#226#211#47#65#184#233#211#226#121#252#185#250#141#215#93#73#73#192#23#75#138#209#213#111#30#8#73#170#38#123;
28:result:=#249#149#20#137#238#106#14#214#218#120#181#134#233#252#178#254#177#98#119#22#217#89#35#133#126#88#120#1#100#104#64#78#123#81#157#45#80#134#49#6#95#120#241#151#111#17#56#38#107#141;
29:result:=#93#225#85#6#207#136#81#66#172#110#227#180#20#135#223#186#226#9#160#125#129#184#136#15#228#35#229#159#6#38#177#228#102#160#210#25#90#45#208#25#57#53#28#152#177#214#101#113#216#74;
30:result:=#162#120#180#212#180#106#88#126#219#210#212#0#92#11#147#177#14#159#224#107#180#205#179#156#87#224#251#11#1#150#9#2#138#229#211#228#114#189#45#100#211#156#49#212#249#34#119#86#54#233;
31:result:=#213#223#229#85#197#81#210#31#170#25#89#208#146#37#4#121#57#21#136#64#84#243#70#174#124#234#203#209#58#182#240#139#0#200#133#168#44#99#191#169#72#27#202#74#38#142#45#41#149#57;
32:result:=#236#44#213#173#157#128#236#173#200#72#151#222#84#94#121#12#227#197#183#70#65#153#54#75#100#176#9#248#151#46#238#196#206#192#203#120#57#77#139#172#151#51#223#188#238#126#175#47#136#171;
33:result:=#76#211#114#204#164#13#233#53#23#8#73#9#155#210#140#66#101#158#107#22#53#153#152#198#245#37#190#75#102#95#45#97#227#70#96#227#157#226#210#142#188#62#188#122#73#32#188#245#229#206;
34:result:=#124#156#155#75#220#188#82#204#57#107#178#107#193#237#138#64#11#68#251#119#74#246#251#7#224#137#246#16#39#39#162#26#166#105#68#188#41#79#2#82#70#196#0#199#104#96#97#195#104#24;
35:result:=#109#149#49#44#106#175#21#128#250#166#199#38#9#247#25#199#136#13#246#62#162#49#65#133#12#138#119#199#157#58#97#77#119#48#26#111#50#103#50#238#251#141#207#68#149#66#247#199#149#125;
36:result:=#116#207#105#207#249#30#232#114#121#58#135#111#210#147#111#89#77#135#18#69#129#166#246#20#163#216#219#55#88#59#108#118#131#200#30#115#182#65#253#219#45#208#124#147#141#98#130#76#197#189;
37:result:=#90#66#191#188#60#43#219#64#131#120#71#186#226#129#185#120#28#72#45#233#4#204#133#167#236#59#87#241#174#99#51#224#241#59#33#142#111#104#69#214#70#12#193#161#162#78#95#171#83#93;
38:result:=#137#83#11#236#168#223#93#94#232#63#199#33#248#67#82#240#74#183#138#5#223#2#242#93#189#15#39#174#115#184#72#165#110#253#117#134#240#158#103#89#239#14#117#42#47#185#137#9#86#28;
39:result:=#216#223#225#39#109#58#31#230#196#153#166#119#18#247#236#173#246#137#236#13#183#236#12#224#51#70#161#157#56#13#210#225#249#121#177#178#171#212#195#207#157#42#95#66#92#17#142#108#157#139;
40:result:=#96#88#15#60#211#4#79#98#206#206#150#105#192#115#227#247#236#18#184#194#121#55#173#158#182#249#103#141#79#133#196#193#64#177#66#206#207#130#237#143#234#174#108#112#152#128#221#38#101#184;
41:result:=#179#254#3#74#192#89#122#2#8#243#159#137#32#10#184#76#58#147#125#47#6#3#222#34#24#86#66#248#131#111#29#30#207#230#24#253#121#226#44#67#163#168#99#77#181#226#39#99#242#215;
42:result:=#77#159#99#20#68#148#139#53#29#22#199#231#79#189#82#61#100#9#75#227#1#42#56#247#241#232#223#112#31#50#126#82#164#44#165#64#107#242#77#10#250#80#235#68#102#21#152#41#133#230;
43:result:=#129#44#227#164#85#18#24#185#77#121#102#250#2#25#219#242#63#41#88#175#118#180#34#102#138#221#4#167#15#51#15#215#56#173#112#41#30#8#22#94#0#107#247#1#180#170#66#214#119#145;
44:result:=#193#192#180#252#75#92#143#179#252#252#57#74#136#221#97#127#249#173#74#210#159#189#78#84#3#143#227#228#22#122#106#99#20#159#74#137#166#118#58#101#90#159#174#192#109#194#193#220#132#174;
45:result:=#39#77#220#253#226#232#231#241#241#13#142#73#7#171#110#74#13#232#212#65#32#59#86#30#25#77#43#15#243#36#203#44#146#54#106#141#187#128#64#121#81#203#211#112#17#154#164#68#102#140;
46:result:=#236#137#40#28#100#12#57#9#39#21#99#215#59#170#1#49#87#28#43#24#212#123#141#44#3#224#31#132#62#145#84#200#120#98#144#152#39#0#223#115#181#229#83#158#244#49#123#196#40#157;
47:result:=#215#77#164#80#65#159#45#81#156#226#118#188#105#214#117#34#231#223#119#149#244#109#37#91#215#67#207#77#156#93#212#75#187#100#225#86#30#249#88#57#201#82#61#212#202#213#85#100#20#201;
48:result:=#99#106#114#61#177#14#217#181#84#13#148#73#202#160#38#70#242#235#232#115#124#215#185#147#54#106#51#195#0#6#76#205#42#35#104#142#144#96#24#6#192#6#39#188#231#95#183#125#116#120;
49:result:=#122#168#134#46#83#138#185#147#238#136#205#42#29#12#64#102#248#110#230#115#35#109#5#79#172#205#130#138#104#58#50#100#191#152#89#1#81#64#209#234#223#236#141#55#103#68#79#221#91#80;
50:result:=#209#48#97#70#200#132#16#119#96#108#129#80#49#28#185#167#199#217#68#226#63#142#125#156#129#215#95#221#51#57#217#8#95#66#10#14#100#198#210#154#191#143#161#55#165#17#124#159#156#7;
51:result:=#143#192#116#32#208#43#96#250#140#225#251#44#211#209#146#23#45#103#229#184#7#248#79#197#186#11#251#183#50#171#147#154#105#80#154#196#120#11#82#209#203#252#239#109#187#75#98#228#169#27;
52:result:=#15#131#84#58#52#35#21#138#210#137#22#91#94#103#221#42#140#40#164#152#246#211#78#130#133#182#24#119#185#160#54#18#85#209#247#232#5#0#72#27#251#3#122#163#162#9#204#10#216#119;
53:result:=#27#14#96#186#151#102#107#200#133#186#120#8#91#91#225#212#193#117#207#248#68#194#126#165#194#220#248#220#231#208#196#99#56#142#20#133#127#68#128#101#176#224#113#152#118#41#146#64#20#51;
54:result:=#19#238#75#46#147#245#105#195#238#4#184#132#71#36#230#30#12#118#51#89#218#83#93#24#108#150#186#211#248#76#232#88#195#5#243#172#171#124#249#119#5#99#152#76#12#113#170#166#182#21;
55:result:=#50#134#193#94#98#240#35#10#43#212#91#179#201#0#73#164#40#49#105#199#22#124#175#165#183#118#113#139#153#245#246#42#82#82#178#85#170#99#69#189#161#203#178#183#215#42#128#122#37#85;
56:result:=#161#103#114#186#89#55#26#114#140#50#92#188#33#196#186#228#93#11#52#201#117#65#204#121#171#28#199#185#185#119#127#84#96#240#215#127#95#73#149#212#37#173#50#143#1#55#231#14#167#86;
57:result:=#19#224#76#232#44#198#169#40#222#118#183#206#28#12#227#252#34#121#17#210#214#87#181#197#234#231#211#25#169#63#168#19#110#203#82#202#23#189#193#168#250#10#179#248#53#3#158#40#67#190;
58:result:=#180#140#92#213#110#201#238#35#75#67#38#140#174#30#127#17#10#194#180#140#187#236#140#6#88#178#89#94#55#21#64#197#131#242#122#82#51#139#53#131#142#213#211#177#57#93#150#153#226#112;
59:result:=#4#134#24#200#148#219#199#253#107#235#136#103#49#108#169#73#87#239#154#96#78#44#55#49#127#11#251#180#21#180#71#55#213#34#6#148#173#226#148#29#161#25#160#199#68#240#73#147#238#247;
60:result:=#240#35#90#40#83#253#74#154#225#17#115#21#143#63#207#249#108#45#3#86#199#153#134#251#193#227#184#249#119#155#17#214#54#48#16#100#100#38#168#6#5#97#59#207#13#115#106#205#228#240;
61:result:=#83#86#221#63#247#75#100#108#226#141#60#239#96#30#29#107#184#176#97#214#97#151#184#152#11#95#1#131#243#126#188#196#243#228#196#32#39#98#49#23#46#24#149#223#83#130#14#58#50#195;
62:result:=#179#131#145#60#126#171#151#162#163#225#140#20#244#17#203#234#226#142#156#65#7#155#21#107#116#131#55#219#35#134#238#54#58#226#170#134#17#152#166#218#32#199#43#184#68#192#86#50#14#36;
63:result:=#50#140#248#183#42#186#189#177#43#39#46#189#243#133#71#238#111#171#93#92#18#174#148#47#151#186#19#67#164#105#148#189#21#138#78#44#17#158#74#10#32#133#176#209#219#19#159#229#248#133;
64:result:=#130#250#201#40#21#215#112#142#127#142#89#37#54#123#200#39#128#189#130#18#231#236#224#60#227#57#211#35#126#74#179#145#212#122#208#182#167#70#38#200#92#25#172#220#38#193#34#242#62#54;
65:result:=#76#118#87#127#6#177#178#237#158#223#145#227#96#241#222#229#62#43#72#192#254#38#45#223#107#234#12#57#77#32#106#97#79#144#77#172#0#117#187#110#144#86#249#187#18#107#91#77#59#187;
66:result:=#230#83#19#131#44#97#243#141#5#204#199#136#28#17#127#135#115#33#18#54#84#187#149#120#79#33#49#104#60#194#8#3#100#204#81#228#72#163#59#233#161#175#100#166#157#26#229#230#103#77;
67:result:=#83#201#131#91#41#25#155#165#123#247#164#93#247#0#153#193#121#112#33#45#200#7#228#84#72#154#108#85#159#160#184#104#175#40#4#89#95#243#92#32#1#200#238#56#112#20#80#136#34#112;
68:result:=#13#10#184#206#71#115#238#39#60#159#221#8#236#106#230#110#71#65#219#164#131#171#37#51#166#114#236#5#73#62#179#85#23#201#185#17#180#11#39#181#243#217#228#213#126#17#138#220#110#38;
69:result:=#218#173#119#166#160#48#140#46#251#253#54#191#107#175#249#129#17#129#141#89#17#80#172#233#13#38#216#222#3#216#82#158#40#115#18#177#127#92#148#147#65#140#190#178#91#55#42#200#149#182;
70:result:=#165#227#37#167#182#182#196#119#93#25#140#234#127#195#39#63#161#181#35#250#232#204#115#163#125#125#105#199#203#187#179#44#69#115#45#14#147#48#139#176#98#200#53#192#52#52#203#62#232#219;
71:result:=#62#240#228#9#92#152#2#76#77#93#184#249#106#65#41#20#71#125#250#68#246#24#48#186#223#41#100#17#162#130#28#147#218#200#25#123#219#38#207#15#149#29#125#167#79#57#127#23#228#144;
72:result:=#213#233#174#91#3#129#69#25#183#1#198#0#231#142#85#174#74#91#227#106#93#119#163#77#93#108#136#59#238#15#206#134#68#26#113#137#13#113#240#170#137#46#235#144#104#194#92#117#113#225;
73:result:=#124#231#21#253#171#87#77#116#210#82#141#213#29#68#151#208#14#23#115#165#64#26#233#69#87#240#48#107#244#147#187#80#191#131#87#221#183#203#246#112#125#109#231#136#63#80#87#15#107#220;
74:result:=#79#249#104#199#155#122#225#195#69#7#120#33#136#231#220#137#119#23#165#91#183#146#108#95#254#133#246#214#62#217#128#22#172#17#112#56#23#128#250#140#34#87#146#220#108#240#22#166#186#109;
75:result:=#38#222#161#148#24#224#69#115#90#167#57#59#91#100#141#79#50#20#135#148#163#180#180#100#67#39#48#181#194#237#94#102#190#79#121#177#139#140#164#57#212#54#109#63#28#202#230#222#95#41;
76:result:=#205#115#114#138#95#119#222#8#208#133#77#213#143#79#200#203#184#169#102#224#119#5#36#154#47#246#248#177#161#173#121#102#123#94#143#63#247#30#14#39#127#178#53#55#114#56#113#151#142#192;
77:result:=#221#66#143#69#90#144#11#119#56#228#154#107#216#226#216#28#186#230#199#45#205#210#159#148#12#81#30#241#185#26#218#191#185#246#48#175#222#118#189#217#57#149#163#143#168#212#225#245#69#123;
78:result:=#142#184#109#252#201#134#122#197#157#22#120#219#52#240#84#43#17#60#106#82#59#58#108#87#129#83#231#154#70#186#20#217#124#29#144#60#203#229#58#154#239#0#85#141#227#37#157#236#94#39;
79:result:=#13#202#169#186#85#35#236#178#106#180#104#187#161#195#58#247#50#200#164#24#27#59#8#206#205#1#231#176#27#47#184#241#40#43#98#127#141#84#147#112#214#199#97#207#252#221#222#43#156#128;
80:result:=#138#130#253#117#205#101#53#45#240#107#227#202#52#96#113#99#246#178#193#171#22#18#168#155#251#79#197#177#250#222#112#229#228#144#219#123#27#107#174#45#101#176#162#122#89#122#244#7#39#127;
81:result:=#178#77#10#223#48#30#184#26#51#172#142#123#162#31#80#177#189#226#191#76#52#62#94#97#152#220#34#142#16#78#234#24#54#193#247#232#143#95#201#145#14#31#17#177#122#243#158#87#195#166;
82:result:=#125#57#147#196#169#223#152#117#1#42#116#21#107#177#51#243#93#252#190#148#24#154#181#63#109#113#149#211#211#249#33#36#14#35#109#71#200#22#12#170#216#36#41#218#10#132#168#53#170#178;
83:result:=#136#22#62#160#27#37#254#243#226#207#39#20#27#30#27#194#55#111#241#110#236#201#2#148#137#194#86#204#166#57#70#99#141#96#139#144#195#207#154#177#168#157#7#36#13#186#67#147#59#12;
84:result:=#14#218#204#0#73#215#66#148#25#205#81#25#135#45#63#21#5#219#202#31#132#105#125#150#19#173#103#132#25#212#149#17#186#204#205#97#236#140#86#188#76#202#226#80#188#239#230#247#97#122;
85:result:=#220#216#120#30#78#185#32#56#170#105#38#138#56#148#73#61#168#228#162#154#28#75#29#13#166#191#39#81#158#242#12#228#60#165#162#22#91#167#54#77#111#186#227#123#232#208#191#169#169#102;
86:result:=#146#39#61#241#240#224#253#169#251#187#86#17#37#26#189#19#166#218#57#166#147#125#95#48#192#51#64#37#216#16#175#163#88#160#185#11#91#152#94#184#98#93#208#131#128#154#204#145#153#61;
87:result:=#207#159#167#90#57#227#33#2#171#20#0#244#47#66#4#183#226#143#41#136#79#247#122#37#165#159#164#110#103#120#6#77#92#33#22#123#209#83#91#249#109#68#87#96#48#198#25#95#94#34;
88:result:=#88#10#111#215#82#202#64#222#205#29#30#254#234#98#110#92#185#123#13#96#187#242#153#128#181#221#77#158#144#208#40#4#26#121#110#45#240#198#224#219#235#181#23#66#184#24#234#39#157#249;
89:result:=#232#82#127#137#26#182#164#126#184#23#214#136#140#30#215#55#17#46#79#87#152#89#161#202#12#69#86#74#9#251#2#153#113#210#218#28#172#250#95#213#51#101#202#71#48#252#41#170#49#121;
90:result:=#89#125#81#58#71#114#75#235#30#30#86#247#92#2#202#240#244#205#224#131#218#251#23#158#192#17#8#205#222#58#186#14#241#253#196#136#231#69#182#0#220#248#178#219#85#220#44#29#231#135;
91:result:=#31#170#185#139#80#191#129#47#94#102#250#83#174#80#236#99#130#112#68#98#195#46#214#132#83#15#201#217#223#47#195#243#157#239#87#165#92#167#73#45#209#62#178#104#33#8#19#249#237#67;
92:result:=#206#107#124#8#191#176#190#153#200#171#69#96#140#130#108#244#192#238#81#24#199#219#84#112#114#236#61#98#34#212#63#116#174#133#127#2#195#174#210#43#152#9#205#79#55#102#106#129#183#141;
93:result:=#213#186#33#79#45#188#215#90#61#237#203#199#128#158#193#92#252#118#128#245#190#20#176#173#2#253#175#150#78#127#176#47#38#25#236#223#246#135#182#46#115#161#179#109#145#124#148#29#187#162;
94:result:=#7#64#8#74#190#88#123#210#213#208#161#253#215#3#18#162#55#43#158#215#20#232#68#210#116#35#38#239#109#120#22#166#221#140#134#103#162#203#233#152#123#146#193#47#8#188#252#170#129#17;
95:result:=#102#89#43#15#41#64#153#9#196#252#66#166#247#136#0#29#102#169#112#206#16#124#105#31#222#107#211#148#223#104#190#181#229#93#106#42#173#8#165#7#201#205#191#96#229#49#217#120#40#242;
96:result:=#114#45#195#17#88#127#254#43#130#71#70#246#86#130#7#212#116#198#115#174#12#196#100#173#68#226#243#110#79#104#160#199#35#181#240#77#249#125#251#15#11#20#78#86#38#34#8#89#32#118;
97:result:=#48#30#56#175#150#13#228#241#204#239#181#251#246#83#52#58#150#138#238#170#130#216#28#190#174#105#125#134#123#38#120#205#171#160#133#249#57#130#103#209#173#77#213#134#168#97#138#146#198#135;
98:result:=#208#88#20#110#23#142#172#245#32#227#71#28#186#102#193#231#69#153#247#196#72#78#104#252#240#157#133#102#62#153#168#101#40#158#6#220#19#81#38#169#70#178#165#188#90#219#101#7#188#70;
99:result:=#80#177#183#179#99#95#181#27#177#117#155#46#118#171#118#89#130#81#214#86#136#17#155#175#38#49#254#208#154#119#37#126#150#73#153#212#151#178#76#30#165#74#36#52#128#68#45#40#133#30;
100:result:=#226#113#218#161#65#217#169#68#128#232#121#20#171#132#242#177#131#7#148#30#78#10#46#65#139#144#40#124#179#110#224#186#102#249#177#177#202#119#103#103#239#205#48#29#113#92#95#50#194#37;
101:result:=#122#169#201#131#107#92#187#48#229#8#101#83#58#193#73#204#59#124#65#17#232#172#142#43#253#56#139#208#171#55#86#140#254#67#64#118#209#65#207#1#66#251#144#193#11#241#35#73#54#33;
102:result:=#30#113#13#204#211#180#57#107#2#110#123#83#241#31#109#187#168#16#41#58#24#246#221#211#122#106#159#46#66#83#246#163#84#169#6#34#106#28#74#37#211#134#70#57#252#67#162#200#109#196;
103:result:=#141#53#27#8#107#107#87#191#27#124#168#83#101#233#70#15#91#173#48#29#173#53#239#47#87#194#147#226#17#3#107#73#112#194#143#47#176#7#85#249#113#8#11#53#252#191#204#57#229#19;
104:result:=#55#115#244#206#61#66#204#235#132#107#189#231#244#152#149#25#99#108#137#77#144#20#107#32#211#105#205#212#52#5#211#153#199#223#195#138#148#91#155#214#84#206#67#217#208#240#22#19#182#193;
105:result:=#228#70#30#206#168#54#32#226#123#187#59#146#168#45#90#39#211#100#193#222#138#198#58#132#206#28#57#212#93#44#221#54#196#97#4#170#152#225#193#26#61#234#23#71#58#93#159#20#240#189;
106:result:=#134#238#52#37#33#132#34#216#218#11#43#136#98#212#65#113#61#241#128#221#62#11#224#191#112#201#178#94#121#113#253#89#153#119#10#126#169#78#148#29#217#158#149#235#254#173#131#171#186#175;
107:result:=#122#9#207#54#195#120#98#9#144#7#253#17#237#97#161#37#76#131#39#226#14#217#202#220#4#192#165#209#203#170#93#177#116#101#99#157#219#55#124#51#165#211#120#199#202#95#60#106#21#9;
108:result:=#160#200#14#228#183#89#50#21#123#89#108#108#252#141#46#26#153#203#175#5#196#190#25#227#102#111#176#69#251#122#78#8#210#9#165#247#32#232#49#154#214#95#203#83#101#153#62#113#201#202;
109:result:=#92#203#177#98#101#250#123#226#208#103#100#80#183#155#43#51#122#174#244#167#101#165#71#3#101#38#84#240#14#218#252#44#143#91#47#27#88#130#158#6#111#125#239#169#227#7#207#88#198#139;
110:result:=#156#242#135#50#138#101#199#15#126#116#217#232#240#2#143#102#158#42#20#131#232#187#230#163#10#7#60#173#150#14#87#242#240#110#163#220#151#175#149#154#138#197#179#82#22#229#51#132#210#19;
111:result:=#15#175#169#236#161#90#21#174#249#24#12#110#143#46#63#0#25#230#149#12#134#188#18#77#129#240#147#243#229#49#21#158#20#89#100#135#35#133#102#169#45#242#111#24#100#107#76#208#156#54;
112:result:=#225#169#101#203#165#55#250#196#65#201#167#202#33#217#65#121#205#124#253#109#69#197#184#15#180#45#96#187#75#81#56#85#12#186#15#128#199#113#175#238#174#142#12#149#39#21#9#170#210#191;
113:result:=#219#190#240#147#85#98#130#82#160#19#231#51#70#113#217#119#120#249#239#176#254#183#28#231#60#184#201#227#50#45#143#75#122#137#152#106#141#4#53#178#214#75#63#109#119#92#67#25#168#186;
114:result:=#137#108#31#137#127#2#242#62#35#31#213#228#88#28#169#65#99#97#191#49#219#251#73#34#228#57#208#139#117#224#184#168#242#223#25#242#130#142#127#22#189#226#98#90#179#51#79#191#104#88;
115:result:=#33#74#58#95#210#56#221#22#170#24#207#16#216#13#127#9#202#165#131#191#199#20#155#144#155#182#91#148#98#63#181#238#183#212#200#148#222#19#164#197#176#193#232#237#75#152#118#173#228#122;
116:result:=#146#77#65#237#46#204#151#204#62#73#240#97#76#138#94#121#178#211#113#27#38#80#227#231#134#196#102#90#18#84#236#105#118#117#249#64#96#127#190#14#127#95#28#42#34#86#197#4#214#218;
117:result:=#31#159#198#253#151#145#167#229#150#203#130#72#61#147#167#245#143#137#139#212#209#146#116#230#25#1#30#62#113#102#200#237#19#207#90#94#117#105#124#161#89#196#234#153#1#59#85#20#56#46;
118:result:=#130#61#225#23#168#244#47#179#31#244#183#180#208#208#9#192#44#68#121#186#104#81#66#131#97#26#60#197#95#150#185#115#134#109#85#250#218#163#187#112#245#238#195#39#234#206#85#109#249#197;
119:result:=#242#120#5#77#246#171#241#99#193#191#92#202#112#134#82#94#229#65#253#14#48#204#104#101#149#27#197#180#219#177#245#61#135#57#31#246#52#66#155#207#61#213#149#127#77#116#16#76#163#145;
120:result:=#55#87#17#192#45#87#1#17#196#213#23#79#197#73#47#53#182#175#199#178#80#126#42#220#9#10#210#50#97#182#239#56#225#161#247#168#243#132#172#173#1#7#21#235#132#203#53#75#0#222;
121:result:=#147#201#248#84#218#201#104#64#26#150#89#99#129#37#140#25#143#68#92#115#19#186#68#162#119#15#191#236#59#251#101#239#144#186#110#246#115#184#24#128#205#93#127#90#97#235#249#231#155#184;
122:result:=#251#109#133#35#15#134#116#40#121#21#54#110#129#81#199#28#130#210#238#231#51#169#46#36#209#231#239#196#33#64#238#140#92#128#37#248#149#21#213#134#39#243#108#107#37#118#89#230#245#24;
123:result:=#26#185#133#31#15#111#190#156#221#137#44#87#114#173#248#124#235#111#189#52#248#96#180#123#123#96#86#214#118#121#128#184#149#180#146#201#216#166#43#77#50#187#120#102#36#107#69#247#162#225;
124:result:=#37#77#207#206#126#226#83#96#76#235#104#151#206#109#215#131#143#21#134#20#111#17#71#126#154#169#20#121#164#76#233#201#25#78#223#206#87#163#57#31#116#53#135#101#125#177#41#245#101#240;
125:result:=#168#230#86#70#202#152#88#98#102#241#112#151#53#202#159#170#68#66#132#124#196#248#110#53#68#110#33#195#167#253#177#209#98#51#33#140#192#119#172#212#85#79#245#185#203#167#110#86#169#236;
126:result:=#193#112#225#232#16#116#33#160#64#167#69#178#197#174#107#239#131#199#125#42#197#75#45#114#117#89#199#74#241#203#82#122#59#197#208#146#96#125#180#78#87#37#196#78#168#5#17#247#165#33;
127:result:=#172#100#6#17#79#159#38#223#26#190#74#10#20#117#148#6#39#59#157#221#169#45#210#199#194#47#18#211#50#11#35#5#76#125#4#121#47#127#47#122#133#54#73#146#89#80#226#1#204#203;
128:result:=#55#42#190#87#24#222#169#217#113#159#66#203#13#36#174#113#138#214#87#29#174#27#161#4#120#107#30#96#177#200#252#210#210#247#199#76#125#125#188#242#230#111#73#193#230#113#121#223#152#132;
129:result:=#99#232#180#118#216#162#18#30#246#222#252#179#73#130#72#227#171#236#78#124#17#70#73#208#227#87#168#40#168#13#96#221#4#184#71#6#107#174#7#184#7#232#56#92#150#174#163#138#99#128;
130:result:=#201#117#143#193#33#209#65#221#191#193#136#223#72#68#254#194#95#8#109#231#248#204#10#127#73#160#27#210#39#145#254#176#34#200#244#121#172#7#37#134#10#1#189#228#235#29#45#163#233#125;
131:result:=#195#51#66#113#77#135#138#162#100#12#70#158#162#139#126#153#211#162#220#137#230#105#220#232#60#74#24#207#122#92#199#44#44#153#235#64#177#203#201#202#83#28#169#92#130#131#250#207#145#153;
132:result:=#87#243#116#128#0#194#80#229#209#203#231#81#206#156#53#71#181#87#174#247#72#193#28#104#45#122#234#110#166#23#102#218#118#102#75#173#176#27#150#46#77#128#139#73#198#29#65#142#21#87;
133:result:=#77#157#189#119#70#250#226#170#59#134#131#221#96#12#72#133#128#177#156#193#3#63#245#99#140#113#110#191#137#225#48#103#43#49#82#29#174#130#15#165#228#107#137#88#96#240#140#121#187#52;
134:result:=#233#203#219#215#106#236#41#90#117#88#23#219#227#49#122#14#166#41#133#78#41#37#112#29#162#126#28#118#185#236#56#193#49#145#185#93#126#154#177#247#129#130#203#56#189#226#1#111#202#86;
135:result:=#78#86#222#232#119#4#175#11#29#169#249#18#198#199#124#174#140#214#55#236#138#161#43#153#88#215#3#47#24#119#69#163#226#51#17#179#168#232#130#124#192#190#42#153#202#154#76#5#150#238;
136:result:=#206#105#45#21#1#191#70#190#170#74#174#43#16#84#111#35#211#76#199#249#226#25#56#11#219#190#60#113#149#183#109#246#181#152#38#113#130#218#240#24#96#238#70#116#153#235#115#8#111#125;
137:result:=#170#202#139#229#136#11#85#59#166#103#192#48#251#224#141#8#22#59#38#148#133#45#132#91#243#31#196#56#195#102#96#22#61#80#43#174#138#91#143#80#42#123#168#27#128#70#44#71#178#90;
138:result:=#83#89#9#113#41#82#97#220#229#69#136#105#87#233#125#228#102#4#237#191#57#193#122#144#158#103#140#98#157#236#195#28#104#91#82#120#22#24#205#67#200#102#63#221#58#207#126#70#209#56;
139:result:=#49#32#177#214#223#111#101#75#8#20#31#144#39#47#182#144#13#250#200#119#11#203#170#50#181#54#32#161#103#152#250#100#170#132#17#92#53#192#54#62#44#223#36#208#204#168#130#177#184#214;
140:result:=#110#190#125#211#61#131#18#134#86#63#114#95#95#97#132#30#31#161#234#22#187#252#135#236#83#77#185#1#5#59#168#11#236#190#31#154#166#120#204#138#92#139#239#135#115#208#187#62#90#122;
141:result:=#5#225#24#136#251#7#134#171#7#20#107#113#3#188#217#206#127#72#130#114#177#159#231#109#64#93#156#22#33#92#243#63#27#122#221#36#192#158#204#147#224#34#214#87#196#53#129#200#190#227;
142:result:=#220#26#224#198#225#207#220#148#55#87#90#18#209#204#89#28#22#88#96#197#105#180#137#206#92#182#187#224#227#9#147#91#57#88#207#165#102#162#78#66#146#129#224#31#141#129#126#229#60#243;
143:result:=#183#54#209#188#85#35#5#30#140#80#179#115#71#127#141#91#69#134#197#214#53#224#240#66#2#102#116#67#223#218#65#4#249#75#176#99#171#139#206#221#173#56#90#109#183#6#67#150#94#86;
144:result:=#132#101#68#78#137#15#221#237#136#119#101#225#135#223#174#3#228#96#11#215#169#13#107#114#240#223#87#136#56#192#139#167#91#71#64#205#135#30#108#224#127#12#136#198#231#30#173#3#130#112;
145:result:=#4#59#122#131#227#249#73#58#44#131#191#210#145#175#55#125#7#4#10#106#116#142#193#112#92#56#175#156#40#146#205#84#59#79#27#222#12#240#229#109#206#89#159#13#135#73#57#10#132#252;
146:result:=#36#181#149#103#109#152#130#201#157#122#157#156#66#209#105#16#88#129#169#154#253#239#110#77#17#239#218#239#180#242#189#37#220#128#63#5#85#251#51#242#229#29#230#177#142#178#91#221#243#143;
147:result:=#88#97#125#187#203#137#194#68#76#199#50#69#200#80#47#21#182#32#253#151#59#14#49#44#44#5#149#193#241#124#161#243#136#208#5#79#61#28#214#18#237#148#111#14#208#180#11#124#23#151;
148:result:=#160#234#248#91#155#149#236#110#109#209#34#20#12#91#123#154#230#171#172#244#226#169#43#193#92#98#20#234#83#136#76#111#43#249#97#253#180#136#251#105#96#182#244#48#206#55#75#145#43#86;
149:result:=#152#233#241#157#189#91#30#86#228#241#221#202#24#204#64#76#251#251#129#121#127#22#237#74#134#194#124#189#224#176#141#91#17#180#129#194#182#20#12#8#171#45#119#154#16#251#51#237#228#66;
150:result:=#120#34#240#56#200#104#9#31#153#231#252#19#125#70#189#240#131#52#123#65#180#147#226#96#221#21#157#106#16#111#202#158#134#125#31#56#213#242#191#253#158#114#51#249#30#43#214#34#94#81;
151:result:=#195#221#214#30#24#184#196#25#252#171#147#227#242#196#12#203#44#32#50#205#5#122#248#223#233#202#72#157#44#171#235#187#155#133#103#204#239#193#210#73#65#117#47#227#53#75#221#147#142#160;
152:result:=#42#227#68#21#10#117#92#13#134#186#29#214#122#90#99#123#143#204#31#111#163#14#78#163#8#140#251#174#66#155#17#13#65#32#254#178#38#60#154#110#24#29#161#209#203#87#208#164#171#74;
153:result:=#114#23#198#146#221#52#247#123#72#77#246#240#209#93#47#117#202#155#151#2#135#190#241#233#67#173#23#33#233#139#77#123#199#115#189#197#126#74#140#213#173#107#42#227#66#45#219#214#79#123;
154:result:=#154#87#217#243#185#196#31#94#5#106#12#93#55#148#19#162#1#92#143#44#8#67#84#46#130#9#42#188#104#62#73#98#97#147#31#38#205#216#230#190#180#41#231#234#98#209#89#39#250#203;
155:result:=#71#69#95#240#247#163#22#56#163#239#39#169#138#196#15#206#180#145#59#210#224#139#182#152#129#171#251#113#182#229#11#82#175#35#60#141#231#183#113#142#28#77#156#24#247#122#190#230#205#150;
156:result:=#198#229#231#101#19#54#49#184#101#183#89#42#132#236#164#121#251#77#8#64#148#109#86#1#133#143#137#192#123#125#115#187#231#200#103#210#67#197#163#207#50#234#133#162#174#96#216#31#176#231;
157:result:=#208#243#244#119#105#218#207#24#76#56#72#246#127#167#201#178#99#59#53#76#216#82#42#85#143#96#195#51#208#14#32#153#77#109#120#149#189#78#158#192#97#226#26#126#161#41#76#100#113#236;
158:result:=#74#22#38#69#75#71#228#218#242#177#230#101#195#35#30#43#124#244#20#116#71#151#253#42#215#1#94#47#4#30#185#25#89#175#50#84#198#18#3#234#96#234#70#103#200#199#118#146#209#6;
159:result:=#125#7#84#180#106#218#97#47#11#207#55#167#251#211#172#236#249#203#254#14#124#207#34#179#242#123#16#79#31#232#186#125#96#103#133#46#3#36#134#126#212#66#224#72#137#25#2#227#205#156;
160:result:=#141#149#248#43#67#160#192#44#49#5#114#90#240#82#118#152#205#35#57#155#12#41#184#227#178#207#72#194#139#237#82#95#64#8#51#3#195#16#89#40#116#186#97#245#158#193#207#65#82#179;
161:result:=#146#55#171#44#140#54#15#144#176#148#238#171#128#75#21#199#248#194#149#32#58#65#214#195#112#174#102#77#204#175#110#5#166#85#18#73#246#221#13#95#210#50#71#253#163#62#67#60#47#55;
162:result:=#160#179#180#112#12#246#181#92#90#183#37#208#176#64#35#181#223#6#115#161#121#150#78#38#34#12#92#186#50#208#202#147#191#116#237#205#119#177#221#184#4#11#226#58#218#144#200#124#171#172;
163:result:=#79#112#210#20#91#220#128#63#158#230#126#242#214#110#193#202#222#153#52#210#41#101#94#147#100#35#228#42#108#49#253#72#176#90#78#58#193#166#218#71#179#139#248#23#115#192#106#232#86#54;
164:result:=#15#190#106#227#217#223#92#102#248#63#245#191#83#172#141#147#208#237#224#186#25#22#55#22#165#179#209#232#112#192#243#43#137#93#10#154#90#198#207#133#117#10#99#122#28#109#177#117#248#154;
165:result:=#168#49#153#226#25#153#189#68#58#169#127#10#46#33#217#28#5#215#57#95#26#162#236#198#197#19#191#229#187#124#20#46#160#7#48#39#158#202#174#70#7#41#53#64#77#232#232#231#232#199;
166:result:=#64#7#233#134#37#182#65#163#149#50#32#73#39#25#226#30#33#160#96#3#23#62#166#241#38#163#111#115#85#55#219#126#177#92#64#155#26#32#14#167#234#53#37#160#232#82#28#59#39#84;
167:result:=#74#65#203#178#156#240#215#54#133#217#111#2#147#243#64#70#116#242#250#74#121#254#1#146#229#107#196#84#142#8#113#134#155#39#215#46#126#121#199#192#86#84#62#194#93#3#21#235#49#63;
168:result:=#40#130#229#238#13#180#83#181#218#28#16#17#159#194#234#248#116#63#248#66#98#205#121#66#121#121#25#106#203#186#115#216#57#26#197#30#56#200#47#176#0#44#10#199#201#214#30#161#21#122;
169:result:=#201#100#13#173#92#40#144#171#58#206#115#97#143#187#248#102#163#154#159#192#18#177#185#137#122#130#121#213#115#173#92#117#195#94#29#115#65#169#163#96#199#180#146#213#42#134#102#191#28#210;
170:result:=#83#82#102#48#68#191#244#120#172#22#121#80#36#203#205#19#222#245#61#148#137#35#94#138#31#79#62#126#179#130#222#156#90#245#108#201#142#219#156#199#213#49#23#95#119#28#226#199#144#209;
171:result:=#57#213#202#5#46#156#133#76#26#138#71#17#177#47#172#232#54#63#62#112#45#114#217#7#130#82#153#10#18#39#102#102#242#128#165#153#250#32#166#139#95#53#186#207#109#39#55#46#172#116;
172:result:=#169#146#243#93#20#184#72#73#251#60#126#63#133#213#251#202#12#247#28#44#213#18#6#175#222#40#254#132#218#138#137#115#219#220#209#80#82#173#73#5#73#92#93#130#11#9#184#16#162#188;
173:result:=#125#186#219#40#87#205#180#133#103#170#109#135#92#103#149#108#62#249#214#144#185#234#94#28#250#198#5#170#99#207#195#8#159#172#243#90#240#7#115#90#186#99#183#114#138#162#73#227#66#235;
174:result:=#87#79#34#6#74#43#182#70#119#42#9#171#124#125#148#194#206#121#198#118#134#27#34#218#118#92#72#152#31#106#124#154#254#27#95#2#82#67#2#160#88#187#139#105#142#70#7#166#145#153;
175:result:=#30#219#138#64#218#159#92#27#163#225#242#167#29#94#105#109#159#50#238#30#99#213#146#86#159#245#111#13#48#226#209#19#146#155#82#72#53#167#12#72#122#60#83#202#234#118#170#253#105#139;
176:result:=#204#122#119#78#7#181#205#94#73#1#224#230#157#131#16#189#230#178#149#74#32#65#128#136#133#134#64#2#73#204#148#168#204#28#235#209#134#88#117#214#248#215#125#4#116#201#219#236#128#5;
177:result:=#118#67#38#39#61#201#128#15#10#8#61#28#77#197#3#201#132#145#217#131#198#180#17#201#253#116#74#11#137#121#141#199#99#180#157#223#12#42#238#31#202#112#246#113#20#197#184#78#22#29;
178:result:=#186#61#198#115#213#144#236#80#135#175#5#86#178#137#253#32#252#21#28#246#49#245#152#9#87#152#188#46#106#120#141#107#217#81#79#176#66#110#106#153#8#100#141#28#196#216#249#112#171#52;
179:result:=#112#158#90#83#28#130#179#158#111#41#199#27#232#215#217#79#13#49#3#38#44#50#28#25#178#7#206#76#33#239#9#110#224#183#50#126#147#115#215#215#169#131#182#13#59#31#80#138#130#217;
180:result:=#121#0#119#224#135#3#93#244#16#124#80#79#101#184#24#250#53#65#209#83#1#216#59#174#78#42#171#100#202#26#4#181#188#198#41#82#130#154#198#107#249#6#120#163#5#204#150#68#146#233;
181:result:=#60#128#224#125#72#193#220#81#116#45#197#218#187#243#148#204#177#20#185#155#125#144#52#138#157#100#33#41#174#148#44#74#203#60#158#226#73#117#225#100#227#100#182#107#166#230#127#228#20#153;
182:result:=#76#7#99#50#152#174#216#109#231#15#136#16#156#183#15#170#211#109#10#39#18#75#94#87#3#46#149#6#174#102#232#60#206#33#175#189#55#28#87#0#121#130#31#1#45#13#40#214#141#193;
183:result:=#171#217#85#240#89#185#7#76#47#235#8#46#91#52#73#114#235#72#80#125#89#191#234#78#65#210#221#166#204#171#79#202#162#50#201#68#96#160#17#176#234#86#38#155#44#162#55#198#246#137;
184:result:=#91#134#53#179#69#254#146#23#99#104#69#252#15#183#182#122#191#56#18#134#99#11#24#40#84#147#173#138#138#48#3#220#4#234#82#74#134#230#138#129#36#183#114#125#54#249#4#160#186#194;
185:result:=#33#73#55#206#214#105#149#124#201#210#165#2#150#65#40#99#46#83#159#27#117#234#59#126#195#199#162#73#251#53#116#224#85#44#182#50#28#67#159#67#249#70#96#212#139#92#217#173#88#1;
186:result:=#116#117#112#81#122#42#63#88#167#158#98#111#215#143#136#212#0#50#178#5#219#88#79#148#9#132#17#116#96#138#119#237#222#146#113#211#99#172#127#145#11#57#78#40#8#210#169#76#39#141;
187:result:=#55#34#104#174#110#81#93#51#167#116#54#189#68#21#172#212#61#183#46#125#178#183#6#156#46#220#87#177#187#3#51#199#26#48#21#190#141#243#145#68#40#237#10#18#137#214#157#97#113#102;
188:result:=#198#148#153#243#70#141#193#175#79#54#213#200#31#40#162#234#105#133#122#213#79#96#186#20#189#83#42#247#103#33#123#108#204#113#139#84#239#23#28#102#172#112#35#213#217#186#231#47#157#128;
189:result:=#146#56#178#115#223#190#105#83#27#159#179#194#160#121#147#21#112#200#151#136#166#107#96#115#224#195#70#79#217#2#160#181#203#61#74#174#103#104#85#230#99#90#31#182#246#99#34#6#198#40;
190:result:=#72#114#30#202#141#84#99#144#60#120#55#137#19#172#172#235#26#133#122#50#2#229#34#26#58#50#105#34#53#77#161#42#127#172#145#55#142#49#17#158#133#141#151#15#74#113#82#49#156#177;
191:result:=#144#222#34#46#133#48#138#48#184#210#60#122#165#109#47#82#103#6#238#38#101#179#226#170#98#3#80#147#107#217#186#48#122#214#154#160#212#87#137#108#118#182#89#158#13#113#188#192#85#50;
192:result:=#111#87#237#250#7#175#213#246#227#38#60#155#215#63#88#37#135#34#104#169#164#105#12#49#102#79#164#156#4#154#105#87#4#234#78#2#152#62#4#162#116#195#156#11#196#100#162#122#55#155;
193:result:=#171#169#59#108#179#203#236#166#207#56#82#197#4#184#214#13#61#186#50#191#208#223#41#133#247#165#203#105#34#41#44#250#32#57#163#127#124#51#45#67#132#113#105#110#216#60#67#236#133#124;
194:result:=#100#94#245#173#218#13#79#200#168#88#245#43#28#47#92#162#39#110#74#56#28#71#75#88#127#1#239#106#217#188#6#0#176#11#2#46#23#126#53#185#139#131#144#25#242#47#6#144#2#204;
195:result:=#211#206#95#87#66#227#63#49#166#113#96#178#177#100#142#119#85#169#32#128#209#157#23#127#183#53#206#242#220#20#102#237#165#17#83#158#28#235#197#245#173#35#205#11#143#44#105#29#37#137;
196:result:=#234#64#225#129#101#35#134#98#2#119#176#160#120#236#30#58#8#202#30#46#166#136#7#245#80#4#185#60#160#53#122#92#34#109#180#83#1#139#106#41#19#189#101#15#81#167#112#171#64#14;
197:result:=#34#76#229#103#13#2#71#224#95#223#135#192#51#213#34#59#45#230#234#26#38#179#189#202#244#155#254#189#164#234#115#29#149#202#254#86#108#7#72#232#196#197#100#130#2#204#251#99#196#242;
198:result:=#151#114#207#209#238#168#108#230#129#148#149#159#206#52#123#19#223#90#36#100#27#102#62#254#114#3#105#58#119#32#133#19#237#125#209#248#201#98#235#243#206#88#242#150#48#15#104#115#234#190;
199:result:=#136#34#188#169#56#3#224#140#196#63#12#49#17#197#74#103#234#63#165#10#167#44#206#243#64#192#44#239#134#27#245#18#67#231#93#3#49#170#210#47#65#28#232#219#154#111#125#160#46#96;
200:result:=#13#180#233#91#96#26#211#51#9#158#148#32#74#38#79#5#98#204#187#52#95#189#222#57#238#231#232#87#203#221#0#188#189#122#15#176#83#63#217#38#196#99#227#124#167#18#253#106#99#95;
201:result:=#127#67#145#207#117#33#178#161#89#167#235#23#28#88#170#121#136#194#108#157#81#245#13#12#89#13#62#48#242#173#45#26#54#220#104#193#171#130#127#214#218#112#11#137#144#218#249#209#216#135;
202:result:=#102#50#14#37#69#235#111#146#181#31#39#9#193#97#175#107#215#178#0#47#82#221#241#163#200#180#190#142#7#169#155#91#236#191#182#86#134#216#53#177#39#192#229#90#83#154#206#189#197#133;
203:result:=#196#31#220#142#181#26#57#93#95#101#96#40#124#0#160#201#199#82#155#43#74#245#33#59#208#35#76#50#137#6#13#225#29#107#132#67#210#141#228#141#122#240#200#123#60#152#24#155#143#7;
204:result:=#4#194#230#201#165#249#219#136#73#149#234#217#126#51#4#85#98#220#136#158#199#143#110#106#54#211#174#173#220#65#49#133#242#0#210#128#42#171#79#84#25#57#18#51#220#169#71#60#69#191;
205:result:=#170#207#82#243#239#172#210#103#190#43#105#141#164#1#81#201#109#78#154#66#198#244#194#146#50#112#221#56#134#169#173#210#161#136#103#145#3#56#253#109#104#98#49#21#181#210#185#137#167#76;
206:result:=#83#243#52#123#125#29#145#85#45#150#56#71#209#131#104#20#95#126#2#48#75#37#188#6#152#48#3#119#123#46#7#120#38#59#217#158#181#88#139#6#105#64#165#227#154#192#143#160#8#24;
207:result:=#156#92#126#205#223#46#247#254#254#144#154#41#166#178#91#214#81#182#12#199#142#14#39#115#235#114#166#254#58#67#159#253#212#40#149#172#11#88#157#96#242#225#207#112#51#193#170#200#135#194;
208:result:=#86#240#29#90#236#53#251#9#70#53#33#240#218#22#1#163#188#10#139#100#201#251#248#84#132#125#238#78#67#88#187#99#155#95#206#63#53#76#155#226#128#223#143#135#225#136#202#131#87#53;
209:result:=#192#150#177#58#1#245#217#78#175#229#199#16#130#222#25#161#77#112#111#68#100#95#13#0#101#195#80#192#48#30#251#124#33#150#126#72#206#244#162#102#223#248#77#189#196#31#63#76#89#10;
210:result:=#253#109#195#254#92#25#23#74#55#111#133#111#116#55#53#113#77#24#247#167#103#201#124#220#94#115#189#177#178#243#196#137#58#217#250#106#141#50#171#161#26#138#111#23#193#187#153#150#48#95;
211:result:=#232#134#98#3#24#202#248#136#254#199#76#53#117#208#108#97#30#108#118#215#190#54#240#72#232#89#19#105#253#217#42#150#225#46#132#33#214#223#143#151#108#56#25#174#104#39#212#159#24#241;
212:result:=#161#25#129#85#40#39#64#29#209#159#41#117#54#251#244#95#112#180#117#31#7#126#62#123#88#4#170#54#167#244#165#16#76#140#182#52#159#230#23#238#151#196#243#3#65#144#9#254#126#211;
213:result:=#63#107#187#95#0#175#127#218#95#11#10#131#88#251#104#71#181#231#171#139#100#254#50#64#73#132#43#27#218#22#184#26#23#142#121#161#147#151#55#222#189#26#24#51#149#17#154#230#107#110;
214:result:=#20#94#115#31#165#127#43#94#200#35#248#208#224#162#115#54#130#239#45#150#91#190#17#56#225#175#149#204#61#138#88#164#21#234#224#200#40#244#174#87#229#247#199#127#105#18#93#243#142#55;
215:result:=#83#184#253#45#182#159#104#104#103#211#93#214#142#78#94#2#159#23#35#19#251#156#60#169#124#151#122#141#114#60#198#171#228#171#98#225#35#238#163#144#235#234#189#243#182#19#21#184#246#201;
216:result:=#54#85#80#189#127#14#37#177#238#190#228#104#201#194#16#190#1#151#219#40#127#31#214#254#209#140#13#125#207#102#127#68#52#54#252#175#83#190#158#138#86#211#122#181#168#54#90#233#135#14;
217:result:=#125#176#218#209#179#29#197#209#96#253#156#168#41#142#35#57#102#202#82#25#157#2#244#126#140#69#233#7#155#198#213#6#180#84#135#37#222#119#117#119#22#230#248#95#53#84#62#225#5#202;
218:result:=#7#63#168#30#194#244#10#29#136#116#0#145#0#72#69#65#77#94#137#102#114#180#36#111#219#174#59#228#242#184#102#207#244#22#28#7#105#240#116#37#240#8#9#45#80#159#7#8#231#133;
219:result:=#185#100#4#71#24#178#171#0#36#53#228#75#42#94#143#71#39#9#74#176#225#44#6#137#138#31#66#218#227#159#6#100#72#15#33#109#16#176#68#254#47#219#233#43#7#94#65#63#204#149;
220:result:=#120#245#250#225#31#10#171#145#133#204#217#99#74#138#225#42#121#234#193#76#246#155#237#20#14#236#196#29#102#49#227#64#187#6#254#219#4#217#233#81#0#76#253#16#76#76#9#156#110#9;
221:result:=#115#76#134#12#72#191#142#41#63#73#80#18#24#195#143#172#189#148#244#144#22#208#202#52#116#200#151#193#19#111#21#147#3#91#44#199#118#96#221#125#105#246#68#154#232#250#34#55#159#103;
222:result:=#162#8#83#37#49#100#122#19#169#196#40#210#54#217#221#10#147#138#9#30#162#137#70#160#122#72#170#230#89#118#157#150#51#95#26#8#179#190#93#217#246#245#71#25#81#175#9#203#220#86;
223:result:=#223#197#184#243#239#32#33#93#130#173#203#193#68#71#65#247#55#215#8#42#128#106#230#183#64#185#150#110#28#245#155#110#51#198#45#100#146#182#88#222#109#150#197#241#182#130#218#121#203#150;
224:result:=#22#146#90#120#211#51#184#78#235#240#67#197#216#92#141#52#68#136#111#9#54#149#59#14#69#102#170#54#130#206#74#231#250#230#118#24#12#82#43#149#234#150#62#89#15#235#203#197#115#17;
225:result:=#218#30#194#17#141#166#254#254#105#50#45#36#125#24#7#26#115#197#211#196#227#115#224#68#96#179#49#45#33#215#100#179#61#98#251#160#219#19#90#36#209#45#70#237#127#20#189#34#4#94;
226:result:=#98#254#4#236#207#98#146#188#160#116#20#105#247#40#21#167#209#90#115#45#114#189#84#190#170#225#192#108#217#249#238#36#226#55#129#46#110#219#80#63#54#92#126#30#63#44#241#32#43#24;
227:result:=#113#240#24#59#247#102#172#250#7#88#70#162#15#189#115#106#38#133#36#33#168#234#62#190#142#62#128#128#121#101#223#119#202#127#205#141#86#130#19#119#106#176#36#29#83#53#39#86#141#101;
228:result:=#15#38#63#82#121#188#198#181#55#234#99#114#188#216#70#30#203#43#156#91#23#217#86#242#199#112#190#248#6#127#43#100#2#99#77#236#27#188#254#20#18#51#125#168#132#99#126#53#252#14;
229:result:=#141#23#104#231#139#65#185#168#104#218#11#45#67#62#130#211#158#22#202#100#95#140#243#38#168#203#234#254#227#80#2#179#125#197#39#172#31#98#183#211#121#17#36#106#238#208#200#247#145#13;
230:result:=#165#161#102#247#241#150#216#4#152#90#185#34#45#31#88#86#233#119#119#189#176#5#51#54#54#7#28#30#194#211#27#244#60#165#231#207#87#87#24#221#43#229#23#126#134#213#154#158#187#216;
231:result:=#83#99#202#84#230#72#23#151#139#78#19#238#194#213#145#226#10#54#163#66#129#73#53#215#230#93#202#224#87#89#26#168#193#3#93#218#251#169#145#113#210#171#14#85#164#152#29#19#70#237;
232:result:=#136#53#72#154#57#41#231#219#103#207#50#34#246#1#39#243#245#184#236#32#102#176#91#164#189#152#112#15#204#51#106#94#236#15#175#137#178#151#175#59#130#178#103#122#184#64#60#47#84#17;
233:result:=#72#214#71#54#99#203#224#201#105#234#254#131#154#147#234#182#16#50#13#164#163#223#240#33#194#199#57#10#12#82#110#10#177#91#218#164#250#215#230#131#104#195#137#134#76#61#209#21#215#22;
234:result:=#169#149#0#83#64#52#167#82#198#66#248#159#106#207#223#159#189#98#8#164#246#223#216#21#178#8#73#175#35#21#135#25#221#115#211#64#175#138#12#73#36#22#181#251#167#144#157#249#126#156;
235:result:=#67#47#234#128#186#61#56#17#175#224#150#170#178#130#242#13#2#121#51#70#120#188#133#241#76#241#180#126#200#37#159#65#58#155#79#136#161#128#73#244#243#110#23#199#3#254#38#241#67#242;
236:result:=#113#12#11#161#150#137#23#174#87#209#85#63#152#5#79#47#101#158#180#6#137#70#217#151#193#103#54#158#168#121#33#196#197#7#118#209#116#211#199#5#134#196#74#201#212#94#182#86#36#240;
237:result:=#176#216#18#222#126#63#233#134#27#213#158#188#252#44#65#227#0#10#178#9#98#104#113#151#193#171#179#137#122#158#53#46#229#230#110#217#77#237#23#37#152#124#33#152#8#138#165#214#129#235;
238:result:=#85#169#62#244#118#139#234#47#134#134#119#187#243#139#55#5#158#152#10#206#2#72#166#207#63#173#75#99#108#147#104#252#216#119#10#102#43#231#8#2#150#23#95#131#116#191#29#234#23#190;
239:result:=#203#177#154#248#81#111#247#99#160#96#191#85#183#164#41#121#195#32#88#248#113#55#29#195#183#239#123#6#163#49#192#54#250#11#3#69#186#95#64#226#184#77#128#217#4#50#168#248#192#39;
240:result:=#249#13#144#67#74#215#216#34#130#33#105#89#245#42#87#241#145#61#23#7#3#24#22#28#64#99#120#214#47#133#169#37#65#117#228#3#65#99#240#90#182#82#162#198#135#12#243#34#209#245;
241:result:=#175#52#28#181#17#223#73#182#209#165#5#240#122#103#146#139#0#178#25#56#1#1#249#98#24#190#185#142#53#251#129#135#224#23#93#49#211#210#148#31#98#153#233#82#130#224#133#169#138#243;
242:result:=#219#239#221#159#225#157#37#109#68#172#214#130#147#17#27#66#138#194#94#81#211#105#15#143#14#4#104#38#231#46#63#207#138#227#50#229#184#212#185#226#83#160#229#92#47#177#228#175#94#105;
243:result:=#132#219#105#232#83#73#24#163#35#113#185#123#235#173#22#54#122#165#122#90#89#18#135#236#197#215#173#142#212#186#132#230#235#23#109#114#60#107#35#20#253#159#48#249#115#93#103#199#9#214;
244:result:=#218#7#27#208#244#84#45#226#157#208#153#35#158#190#17#203#170#97#107#126#188#124#155#51#179#20#204#17#88#64#2#146#62#54#172#219#35#223#38#17#194#166#242#15#66#60#67#230#161#145;
245:result:=#23#240#230#70#238#82#224#57#4#93#184#13#94#25#189#200#77#209#14#219#14#154#19#63#182#4#247#107#166#121#133#102#9#19#23#33#64#198#135#218#54#62#75#92#236#203#40#33#207#53;
246:result:=#39#217#151#92#185#208#204#239#61#31#49#182#62#197#158#26#57#254#44#252#172#113#151#18#198#34#78#50#253#41#157#111#80#172#201#211#20#146#50#35#130#235#174#248#103#26#202#32#168#21;
247:result:=#163#7#137#119#109#153#215#21#247#246#117#76#176#200#227#110#254#38#181#195#248#81#45#44#190#187#80#79#18#34#58#223#233#155#137#108#20#251#27#176#51#232#120#122#154#115#172#121#228#27;
248:result:=#101#164#68#146#151#251#211#161#251#217#142#1#50#29#151#20#78#209#249#194#38#53#29#249#163#38#125#128#233#112#126#30#29#121#77#98#12#62#54#108#35#174#238#130#75#206#154#109#172#48;
249:result:=#162#220#126#165#167#66#74#73#19#230#82#55#34#62#11#139#97#163#206#150#2#8#49#71#116#78#179#59#49#73#171#18#162#156#159#201#150#250#111#95#166#132#11#244#120#48#147#40#224#151;
250:result:=#19#112#36#126#69#161#244#242#13#237#239#238#137#6#167#183#248#44#133#132#206#103#23#21#178#23#130#75#75#159#65#231#2#248#98#2#51#65#218#225#110#180#192#70#182#158#110#72#236#30;
251:result:=#224#95#212#230#216#63#88#79#144#139#253#72#12#160#184#32#82#230#129#42#35#111#96#162#221#222#213#115#202#205#210#176#232#52#163#227#243#135#127#143#73#143#168#121#219#50#73#156#97#165;
252:result:=#109#230#95#213#226#13#217#232#193#32#162#40#246#189#180#204#17#235#4#90#33#19#168#156#128#144#99#112#183#231#203#219#230#134#182#49#102#142#150#58#134#67#241#160#150#222#44#24#165#15;
253:result:=#57#7#168#83#250#153#233#238#102#147#252#63#167#73#143#153#226#131#209#7#79#77#100#126#199#221#229#116#14#41#159#223#86#191#245#19#226#18#128#249#190#56#8#163#218#210#191#54#48#177;
254:result:=#127#151#141#63#207#122#69#240#11#161#233#54#240#119#180#157#94#86#88#54#19#25#88#94#183#219#34#130#131#247#129#133#60#167#51#209#113#224#162#75#35#78#39#153#63#114#63#154#169#101;
else result:=#163#217#163#187#52#105#225#112#11#130#154#250#77#170#76#223#116#107#38#98#43#194#58#37#252#211#227#237#118#149#19#203#101#115#105#80#103#35#80#173#249#38#119#225#156#180#99#49#217#21;
end;
except;end;
end;
//## xsaferef2 ##
function xsaferef2(x:longint):string;
begin
try
case x of
0:result:=#9#5#6#7#10#2#0#3#0#4#0#7#10#7#8#8#5#0#10#2#0#3#9#4#10#2#1#8#10#7#10#9#3#1#8#6#0#2#4#6#9#4#3#10#3#1#0#2#4#5#1#7#5#4#4#7#9#4#2#0#0#10#4#0#7#9#2#3#5#2#5#0#10#1#2#2#7#3#1#8#2#7#7#8#9#9#1#1#1#6#8#7#3#7#9#7#10#7#0#8;
1:result:=#6#10#0#5#0#4#0#8#3#8#10#5#4#9#1#8#4#0#2#3#5#5#1#0#8#4#4#1#1#9#6#9#1#8#10#7#5#1#10#6#8#10#4#5#1#8#3#6#1#0#9#2#3#2#10#10#10#3#8#10#3#7#8#5#9#1#4#9#0#2#0#8#10#0#6#2#9#8#5#5#10#10#4#10#1#6#2#6#6#7#3#8#7#6#6#3#2#2#6#9;
2:result:=#10#9#4#2#8#2#5#1#10#7#2#5#5#6#5#10#5#10#3#8#5#4#0#8#2#9#8#3#5#10#8#5#10#1#8#0#8#1#8#2#6#1#6#5#0#6#8#5#1#3#1#6#1#5#7#9#2#0#2#0#7#1#6#1#5#3#9#10#4#9#6#4#4#10#0#6#7#4#0#7#3#0#8#8#9#3#4#5#7#9#3#3#4#6#6#9#4#5#5#0;
3:result:=#7#6#8#9#7#1#3#6#4#4#3#0#10#3#10#3#5#5#3#3#9#10#9#7#2#7#7#5#9#5#0#8#7#10#10#0#9#4#6#3#9#8#7#1#4#9#5#7#0#2#8#10#9#10#10#8#6#7#6#5#10#3#10#3#9#10#2#6#3#0#6#7#3#4#3#10#5#9#0#0#8#8#2#4#10#8#0#0#3#8#6#0#10#8#7#10#9#9#3#1;
4:result:=#5#10#1#4#1#1#7#4#6#1#10#7#3#8#4#9#3#4#1#0#4#10#7#1#8#3#3#8#7#2#7#10#0#6#7#2#1#6#2#10#8#1#8#6#5#4#8#7#0#7#6#1#4#10#4#3#9#9#10#10#5#1#4#0#2#0#10#8#1#2#7#7#2#8#8#0#4#10#6#4#6#8#0#9#6#5#1#9#0#10#6#5#8#7#2#0#6#7#0#6;
5:result:=#6#4#9#7#0#7#0#9#3#1#6#9#0#8#6#5#1#10#6#9#9#6#1#6#3#6#5#4#8#10#7#4#8#1#8#5#7#10#9#2#10#9#1#10#8#9#7#3#9#6#4#10#3#6#3#10#0#7#1#0#1#4#6#7#6#3#3#4#0#3#10#0#2#6#3#0#10#5#3#6#5#5#6#6#7#1#9#8#4#3#9#10#3#7#2#10#9#10#9#6;
6:result:=#6#0#3#2#2#9#9#3#0#10#7#5#4#8#1#10#2#0#2#7#7#10#9#3#9#3#2#5#2#4#8#5#4#1#7#6#3#8#0#4#2#6#4#2#8#10#3#9#2#7#10#8#9#6#0#8#3#1#7#9#9#1#6#8#10#9#6#0#4#7#10#1#9#1#5#10#6#8#4#8#9#2#3#6#0#4#0#8#2#10#2#3#10#5#9#5#2#4#8#1;
7:result:=#2#0#2#5#3#1#6#6#5#6#8#9#6#0#6#2#4#0#0#2#3#6#5#1#3#6#4#5#10#3#5#9#0#0#10#7#10#2#3#3#10#8#2#3#4#4#9#9#7#3#9#1#2#2#0#7#6#1#1#3#10#8#0#7#5#9#2#1#2#1#0#0#2#2#4#5#0#0#1#7#7#5#10#9#4#7#3#10#10#1#2#2#10#5#7#4#1#1#5#4;
8:result:=#3#9#2#7#4#10#3#9#5#2#2#9#6#1#5#8#7#2#5#3#8#10#9#0#10#10#5#4#1#10#10#3#9#2#10#1#1#6#8#5#3#8#0#3#8#0#1#6#6#0#10#8#10#0#3#6#7#9#5#5#7#4#4#9#2#3#7#2#0#9#1#1#7#2#2#1#9#5#3#1#10#5#6#3#10#7#2#0#2#10#5#8#4#3#4#3#8#0#0#7;
9:result:=#4#10#7#2#3#6#3#2#9#10#1#4#3#9#6#0#4#9#0#6#1#2#3#0#10#5#10#10#10#8#3#4#2#3#8#9#1#5#8#7#9#3#2#8#5#6#5#10#4#4#7#10#7#2#6#4#6#3#9#6#4#6#0#9#4#8#1#9#0#1#10#0#5#8#9#7#3#2#5#10#10#2#10#6#5#3#8#5#6#2#6#9#4#9#1#9#6#3#5#10;
10:result:=#0#2#1#5#3#9#1#9#3#4#9#8#8#6#0#6#7#2#4#4#6#3#0#10#6#0#0#10#0#7#7#3#10#2#3#5#4#4#5#0#3#9#5#4#4#1#0#10#0#5#9#4#4#8#10#10#5#5#3#8#10#3#7#10#10#0#7#0#0#6#3#4#1#1#4#6#1#9#4#0#9#9#1#7#3#2#6#4#6#9#3#7#1#6#7#4#7#1#1#6;
11:result:=#7#10#3#2#7#3#2#10#9#9#5#4#7#0#6#6#5#5#10#9#4#7#4#1#4#7#10#2#5#6#3#10#2#2#1#0#5#2#0#3#5#10#10#8#9#0#0#10#9#10#6#2#5#8#5#7#0#6#0#3#0#0#0#5#6#6#10#4#6#9#0#2#5#9#6#0#2#8#5#0#1#1#8#5#6#9#10#6#4#2#5#6#7#9#10#0#2#6#6#3;
12:result:=#8#2#1#4#3#0#2#4#10#2#7#8#7#9#4#10#1#8#3#1#2#2#10#5#2#7#3#8#6#10#3#9#10#6#3#2#10#9#10#10#9#5#2#2#10#4#9#0#9#5#9#8#4#0#3#1#9#0#7#5#7#10#4#2#9#0#1#2#3#4#10#6#2#9#8#0#6#3#5#4#2#0#0#5#4#0#6#6#6#10#2#2#5#10#5#1#5#0#5#9;
13:result:=#0#8#6#8#0#5#7#5#7#5#10#9#0#5#5#6#4#4#10#2#5#9#1#7#5#8#10#0#7#10#8#7#4#8#3#7#5#9#3#0#5#1#8#5#10#0#8#2#5#0#7#5#7#9#4#8#2#6#9#0#4#1#6#9#7#10#7#2#4#1#10#8#6#9#9#5#5#10#2#4#4#9#1#3#3#8#0#1#8#8#8#2#6#2#0#7#8#10#4#10;
14:result:=#3#1#7#2#6#4#1#5#5#5#1#2#8#4#10#4#5#9#7#8#1#2#10#9#1#8#7#6#2#9#5#2#0#2#6#2#8#0#9#0#6#1#8#7#9#1#8#2#4#10#2#10#10#9#5#4#0#5#4#7#7#10#9#10#10#1#5#2#3#3#0#10#6#4#0#6#8#5#5#8#0#5#2#6#8#3#8#7#2#3#2#1#3#1#8#0#10#5#1#0;
15:result:=#10#0#3#5#1#8#0#0#4#4#1#0#9#6#1#0#6#3#1#6#9#9#0#1#0#2#4#7#6#3#3#10#4#4#0#7#0#9#4#7#2#10#8#3#8#8#2#0#8#9#4#2#8#1#9#7#7#9#3#1#7#3#6#8#10#9#10#2#0#5#2#5#8#9#7#10#2#2#0#9#8#4#0#10#0#2#0#8#6#4#0#1#8#6#4#7#8#4#8#7;
16:result:=#10#5#8#1#0#8#2#9#3#7#5#1#2#8#1#3#8#1#3#5#3#2#4#2#10#10#1#3#8#0#7#0#5#6#8#3#0#1#0#7#3#5#8#0#4#10#5#10#10#1#1#7#7#3#1#7#5#9#10#8#7#3#5#2#6#9#5#7#5#1#8#7#5#7#7#1#4#5#6#10#7#4#10#3#5#6#3#4#5#2#0#7#8#1#7#6#0#3#4#9;
17:result:=#8#9#2#10#1#6#2#5#10#10#5#3#0#2#8#1#5#10#1#10#6#6#4#10#5#5#4#8#7#0#4#5#0#4#4#1#4#3#0#6#9#5#8#5#1#0#10#0#10#9#8#8#8#0#0#2#6#10#4#3#3#2#10#10#4#2#4#7#9#5#8#3#1#5#9#0#1#3#3#7#9#9#8#9#6#3#8#2#0#3#0#1#10#2#8#9#5#2#6#9;
18:result:=#5#5#9#1#3#7#6#6#1#7#10#9#3#10#7#10#0#5#1#4#10#8#4#3#3#2#8#6#9#5#1#4#0#10#7#9#9#1#8#2#2#7#6#0#7#4#1#5#9#7#9#7#1#7#2#3#5#9#7#5#8#5#8#9#4#3#7#9#7#1#6#0#7#1#0#1#6#1#0#6#0#1#4#2#0#9#8#5#3#4#3#9#2#2#0#5#4#5#9#8;
19:result:=#0#4#10#4#7#7#6#4#1#7#5#1#3#10#1#9#10#5#0#6#8#6#9#1#1#5#9#3#10#1#4#10#4#1#3#9#3#3#1#5#2#8#5#7#7#6#2#6#1#10#6#5#8#0#1#4#10#0#1#9#9#3#2#10#3#5#10#2#9#10#7#9#6#7#3#5#10#3#10#3#1#0#8#5#2#5#0#9#0#5#0#5#3#7#2#10#9#2#6#5;
20:result:=#6#6#7#10#8#7#5#6#2#8#4#10#8#9#4#7#3#8#2#8#5#2#6#4#9#5#0#6#2#3#9#8#8#3#1#1#8#8#5#4#1#4#3#0#2#8#10#8#9#8#4#1#2#3#4#3#8#7#3#7#9#2#7#4#5#4#3#6#9#9#10#6#0#10#7#8#9#7#8#3#10#4#8#0#8#10#10#6#8#6#7#9#7#6#8#0#2#1#10#8;
21:result:=#6#6#9#0#5#10#1#3#3#6#5#4#6#9#0#5#6#8#8#6#0#3#5#0#5#3#8#5#1#7#10#9#6#5#1#5#8#4#3#9#4#10#6#1#10#0#3#4#10#7#8#10#4#4#10#6#8#9#4#7#7#6#10#0#2#9#9#6#7#0#7#5#4#4#2#8#10#4#8#8#6#1#9#4#10#0#4#3#10#8#5#9#10#3#8#4#4#0#4#4;
22:result:=#5#10#7#3#8#1#1#10#7#0#4#3#3#4#1#2#6#9#8#6#9#0#3#3#5#4#5#1#0#9#10#9#9#10#6#3#1#6#7#3#3#4#3#0#5#7#8#3#7#3#2#0#7#1#9#8#6#6#10#1#7#2#3#5#2#5#5#4#6#3#9#9#10#10#1#6#5#10#1#4#9#2#5#10#8#5#6#10#6#5#1#6#8#9#10#6#3#3#6#7;
23:result:=#1#5#3#8#7#2#8#7#1#1#9#10#5#1#3#9#6#2#9#9#9#0#3#2#3#1#8#1#6#1#7#8#5#4#3#4#7#7#6#0#3#8#4#9#5#0#4#0#1#5#5#7#10#0#5#1#2#4#8#9#7#10#7#8#4#10#10#3#1#1#3#3#5#4#6#1#1#6#2#10#6#1#10#10#0#5#8#0#2#9#0#2#0#4#3#2#8#10#6#1;
24:result:=#1#2#2#0#10#4#5#2#2#10#3#6#3#9#4#1#8#4#7#9#8#5#9#2#7#9#1#1#0#10#6#10#10#9#7#8#8#8#0#2#3#10#10#4#10#1#6#0#5#10#2#3#9#0#5#7#8#10#9#8#7#6#7#10#8#10#8#10#8#5#4#1#2#10#3#4#6#5#1#9#8#3#9#0#6#1#5#1#3#3#7#3#5#9#6#5#9#5#7#1;
25:result:=#5#5#0#6#4#10#4#9#3#10#9#6#10#7#2#9#7#2#7#7#8#8#10#9#8#1#2#0#3#6#1#6#3#2#4#8#7#4#4#6#6#6#6#9#6#5#6#2#6#7#7#4#0#9#9#2#6#0#4#5#5#2#3#8#4#2#1#8#6#5#1#10#3#2#8#1#1#2#4#9#5#6#6#9#6#9#5#9#9#7#7#8#7#7#6#9#5#9#10#4;
26:result:=#0#8#2#6#3#6#2#3#2#3#7#2#6#8#3#3#3#4#9#2#2#3#0#0#0#4#9#2#4#0#8#9#5#6#6#7#10#1#6#5#3#3#7#8#4#1#2#9#9#9#8#7#0#7#1#8#0#6#5#0#4#9#7#5#0#7#5#10#8#2#3#8#0#10#0#10#7#2#7#1#0#0#10#7#6#8#4#4#10#9#0#4#8#0#9#10#0#7#6#4;
27:result:=#5#10#1#7#10#0#0#2#7#5#2#6#5#3#0#4#7#9#8#9#0#6#6#5#4#1#6#10#7#3#1#7#4#4#7#9#6#2#0#9#4#2#4#5#2#9#6#3#1#6#8#1#7#4#5#4#0#6#5#6#4#3#4#6#6#3#1#1#6#6#10#1#8#4#0#5#8#2#0#3#3#9#9#3#2#1#8#0#0#7#10#8#3#8#4#8#9#4#3#6;
28:result:=#6#0#0#3#3#0#1#2#1#7#7#10#6#2#9#10#1#5#5#5#9#4#9#2#10#4#2#0#9#10#7#4#2#6#0#7#5#8#7#9#0#8#7#0#8#1#2#5#7#2#2#6#3#8#1#2#3#6#8#7#10#6#4#0#1#4#10#2#5#2#9#4#4#1#2#10#9#5#3#10#3#4#1#3#2#4#7#10#2#1#7#6#4#0#2#3#10#8#2#2;
29:result:=#0#9#1#6#10#4#1#3#1#8#8#0#5#9#5#5#1#9#9#10#6#5#9#10#10#6#6#9#4#9#7#6#10#8#0#6#9#3#4#6#2#5#2#2#7#9#1#8#4#7#9#9#0#8#8#6#5#9#4#9#2#1#6#4#6#1#0#5#6#8#8#3#8#6#7#9#3#4#2#0#0#10#1#7#10#5#9#6#2#6#4#7#0#0#5#7#2#8#10#1;
30:result:=#5#5#10#6#10#3#9#5#9#9#3#10#9#8#3#4#8#10#4#6#5#10#0#6#6#0#5#2#8#4#9#10#0#8#3#1#2#4#3#0#7#5#3#0#5#10#1#5#7#9#8#7#3#5#0#3#7#8#10#0#10#5#6#1#6#3#5#0#0#7#9#4#5#7#7#0#4#2#4#3#5#7#0#3#4#1#2#9#1#10#7#9#2#5#5#4#9#7#7#6;
31:result:=#3#4#4#10#7#9#0#5#5#1#3#7#4#1#2#5#1#0#6#2#5#2#8#4#10#6#9#5#9#6#0#10#1#1#0#0#9#7#6#9#9#0#9#4#1#9#2#7#0#6#3#6#9#6#9#6#1#8#2#6#5#8#9#4#0#9#9#3#5#8#8#6#1#1#3#8#8#10#9#8#9#7#7#6#8#9#10#9#6#9#1#7#10#3#0#9#7#8#4#7;
32:result:=#2#7#6#1#6#4#3#10#3#0#9#0#8#5#10#9#2#1#3#1#8#6#3#5#0#9#5#6#9#5#9#0#6#3#2#9#6#7#3#7#9#3#8#3#10#5#10#3#10#3#8#8#0#5#8#3#0#9#0#4#10#10#2#8#2#6#5#10#0#7#0#3#2#7#0#9#0#6#0#0#9#7#3#4#6#9#5#3#8#10#2#5#3#2#10#2#7#3#4#9;
33:result:=#7#8#3#2#8#6#0#4#10#7#3#3#8#4#7#5#2#8#7#3#4#7#6#6#8#0#1#1#6#5#4#8#10#5#2#2#3#9#0#10#7#5#6#7#7#9#6#6#6#4#6#7#10#0#8#7#2#2#6#2#7#4#4#8#2#9#9#10#1#1#2#2#8#7#2#8#4#4#5#10#10#4#9#7#6#7#10#5#0#9#9#7#6#1#7#0#3#9#6#6;
34:result:=#2#5#5#2#7#4#1#6#9#5#0#0#6#5#9#1#3#7#5#0#7#7#9#8#10#9#8#6#2#3#7#2#7#8#10#5#5#1#0#2#0#7#2#1#3#1#5#8#4#9#4#7#10#4#4#9#4#10#8#6#4#9#8#6#7#0#3#0#3#7#1#9#9#5#7#4#10#6#6#8#9#5#7#5#10#4#10#7#8#10#0#0#1#10#7#10#4#4#4#1;
35:result:=#6#0#5#2#2#8#1#2#9#1#2#2#10#5#3#9#0#0#3#0#8#1#5#7#6#10#1#6#9#2#6#8#1#8#6#9#2#2#10#8#3#5#5#9#7#4#0#5#7#2#1#1#0#1#3#7#5#9#0#1#5#4#6#2#8#7#6#8#8#7#7#10#2#7#7#10#5#3#6#8#9#1#9#1#4#7#0#6#6#8#8#3#2#7#7#2#8#7#5#1;
36:result:=#10#1#4#0#4#1#4#8#3#7#5#5#7#2#3#5#6#5#8#5#2#4#3#1#5#2#0#0#7#3#7#1#7#6#7#10#3#4#0#0#6#9#3#9#5#4#0#0#4#2#8#10#6#3#3#6#4#8#0#4#3#3#2#5#0#0#1#8#3#8#5#3#3#7#3#4#0#9#2#5#7#10#8#7#4#10#2#4#2#6#6#4#8#7#0#8#2#9#0#4;
37:result:=#3#2#6#9#0#5#7#4#1#0#8#0#2#5#0#5#6#7#7#8#1#7#7#7#1#0#5#0#1#0#0#6#2#9#2#5#8#1#7#2#10#8#1#10#9#9#0#8#5#5#6#9#6#5#1#1#1#9#6#3#10#0#1#4#6#2#7#0#0#3#3#1#1#2#5#7#4#2#8#3#2#3#10#2#6#0#7#3#6#4#1#1#7#3#7#5#8#0#2#6;
38:result:=#8#10#4#3#2#9#5#10#7#9#6#6#9#10#8#4#8#1#9#2#6#10#3#9#6#2#4#6#10#8#2#3#7#9#9#10#2#5#6#7#8#10#1#10#1#9#4#5#2#9#3#2#5#3#1#2#7#4#5#5#8#5#3#10#8#3#4#2#5#2#10#0#3#8#5#9#6#6#1#5#5#1#3#2#0#5#3#4#2#4#6#8#1#4#1#10#7#0#5#1;
39:result:=#5#5#0#1#3#9#3#8#4#2#6#7#6#2#2#5#10#8#0#4#3#0#6#0#2#3#7#4#5#7#8#8#10#2#3#7#8#7#3#0#7#10#4#5#2#1#1#7#5#0#2#6#1#1#8#9#4#10#8#2#9#10#5#0#10#4#8#3#6#8#10#8#2#7#5#9#6#4#2#1#0#1#4#5#10#4#10#9#5#10#7#10#9#6#10#0#9#5#0#10;
40:result:=#7#9#7#4#6#10#6#4#2#1#4#5#4#6#8#10#9#10#1#3#1#7#7#9#2#8#3#4#1#3#2#7#0#7#8#0#0#5#0#5#3#1#5#9#5#0#0#10#2#7#10#8#10#2#0#8#0#2#7#2#8#10#3#9#7#0#6#8#8#6#9#2#6#5#3#8#5#4#9#7#2#7#3#6#1#8#5#5#0#1#9#1#8#9#8#0#6#8#10#9;
41:result:=#6#4#6#2#2#1#4#3#9#1#1#4#0#3#3#0#6#0#7#4#5#6#7#0#6#8#9#9#8#10#1#2#2#0#7#1#9#5#3#9#5#10#8#8#1#7#9#4#2#9#4#5#10#9#0#5#9#8#4#3#3#6#8#9#10#3#9#0#8#7#5#5#3#7#0#5#6#2#9#10#4#7#7#6#8#1#4#3#4#3#8#6#1#7#9#8#10#10#8#8;
42:result:=#8#1#1#5#7#8#10#8#9#2#10#9#5#10#6#1#8#10#2#9#5#0#0#10#5#7#9#9#2#4#5#0#0#0#5#7#1#9#3#5#3#3#8#2#6#7#4#2#0#6#10#10#5#1#10#10#3#7#4#10#4#0#0#10#3#2#8#4#4#10#3#3#1#0#7#2#5#10#6#10#5#8#10#10#1#10#10#3#8#1#9#10#10#1#8#6#0#9#8#4;
43:result:=#7#3#9#7#8#10#3#9#8#6#6#7#3#9#2#4#4#2#0#0#10#4#8#6#1#5#8#7#8#0#4#9#3#7#6#5#5#9#8#0#9#3#1#8#5#8#10#6#5#0#9#3#10#0#0#6#9#0#9#6#1#1#4#4#9#9#9#6#9#6#3#9#8#6#0#3#1#1#0#2#10#7#7#3#10#8#1#6#10#5#4#3#7#1#6#2#2#3#3#3;
44:result:=#1#0#8#1#5#7#3#10#2#10#3#2#6#10#5#8#2#0#7#2#10#2#4#8#10#8#2#7#6#6#5#1#9#1#4#8#6#8#0#10#1#9#5#1#3#9#8#4#7#8#9#1#1#5#7#3#7#2#10#10#3#7#7#5#3#9#9#5#6#9#4#6#7#1#3#0#6#8#8#1#8#8#2#8#5#7#3#3#4#2#10#5#2#8#6#2#0#4#10#1;
45:result:=#6#7#9#6#2#7#1#3#8#5#5#1#6#9#7#7#9#5#5#6#9#2#5#1#0#6#7#5#5#0#1#3#5#9#9#4#8#9#5#9#9#9#2#9#3#1#6#3#9#9#5#8#6#2#7#3#1#0#10#4#1#9#2#9#2#10#1#4#7#6#6#10#10#3#2#8#3#6#6#1#9#4#0#1#4#6#5#9#0#4#1#4#5#4#2#3#0#2#5#3;
46:result:=#9#5#6#6#2#5#2#7#7#4#9#3#9#6#5#7#9#5#9#10#3#2#7#1#0#10#9#2#3#7#9#9#9#8#7#8#5#6#7#6#9#8#8#2#9#6#8#2#9#6#4#3#0#4#4#4#3#1#9#1#10#4#3#3#5#10#8#4#6#7#7#6#10#0#3#1#5#6#8#1#9#1#10#3#6#3#0#3#10#5#7#6#9#0#1#8#4#5#7#5;
47:result:=#7#6#9#2#4#6#7#3#1#5#6#4#10#0#10#4#3#4#9#10#3#7#0#9#6#3#7#9#6#3#1#8#2#3#6#0#5#8#5#8#10#0#2#0#6#7#10#8#2#7#9#10#1#4#10#5#3#6#4#1#4#7#10#2#8#0#9#7#5#2#10#9#10#10#2#6#7#0#1#9#3#3#4#8#10#6#10#9#2#1#10#6#0#8#4#3#4#6#3#3;
48:result:=#8#5#3#4#8#5#9#1#10#7#9#7#9#9#8#4#4#1#10#0#1#10#2#1#10#1#1#2#3#9#2#0#8#4#5#5#9#0#10#7#3#7#1#8#5#2#9#8#0#10#2#5#6#0#0#2#2#10#3#1#0#1#4#3#8#5#8#1#6#6#1#9#4#10#0#10#1#8#0#2#6#0#4#3#0#1#5#2#5#0#1#0#2#1#4#8#2#9#7#3;
49:result:=#9#0#2#0#3#6#4#6#10#9#6#1#6#7#5#6#6#8#9#0#8#7#9#2#9#7#6#0#6#2#1#8#5#1#4#2#7#6#1#5#2#4#0#3#9#0#1#6#1#4#5#2#7#9#2#6#4#1#6#3#1#8#8#5#10#4#9#2#5#4#8#10#7#6#10#4#10#3#10#3#4#1#9#2#3#10#3#2#3#2#10#8#4#4#1#1#6#3#8#4;
50:result:=#5#1#10#6#2#0#3#7#6#0#2#8#8#2#5#1#5#2#8#9#3#7#8#8#9#4#5#5#5#0#7#0#8#2#1#7#0#6#9#3#5#5#6#9#5#3#3#5#1#1#2#7#7#10#8#0#0#10#5#2#5#7#2#9#0#10#6#7#7#4#8#7#5#4#1#6#5#2#2#0#0#1#3#2#6#6#4#2#2#4#10#10#2#0#10#5#5#2#7#9;
51:result:=#8#0#1#7#1#1#1#8#5#6#2#8#4#9#4#5#7#5#7#5#1#1#2#4#9#8#10#1#8#1#5#7#4#2#5#10#4#6#4#2#10#6#5#6#10#7#10#1#10#0#2#0#2#6#1#0#8#5#2#10#0#9#10#0#8#2#1#8#10#4#2#8#2#5#4#0#8#8#10#0#3#6#4#3#10#3#7#3#8#6#8#3#1#8#1#4#4#6#9#3;
52:result:=#5#4#0#1#3#4#5#5#7#4#7#5#4#3#2#9#9#0#6#9#5#1#0#9#3#10#7#7#1#0#3#0#0#6#10#10#0#0#3#8#10#10#0#6#9#2#1#7#7#3#6#9#3#1#4#5#1#1#4#2#10#8#6#7#2#9#1#10#10#1#7#7#3#10#0#4#5#0#4#6#9#0#10#9#6#6#4#1#1#5#8#8#3#3#4#2#0#4#5#6;
53:result:=#3#2#4#5#1#8#3#9#6#7#10#0#10#1#5#0#1#0#9#1#10#9#4#6#6#5#4#6#2#3#0#6#2#6#6#4#0#2#6#1#6#2#3#4#8#3#2#8#7#0#6#8#9#7#6#4#8#3#5#2#8#9#3#3#6#4#4#1#5#8#5#10#3#4#6#3#8#8#7#2#8#9#7#9#8#9#6#3#0#4#4#6#4#2#3#2#0#7#1#1;
54:result:=#2#5#4#3#7#10#7#7#6#6#7#6#7#7#0#0#10#0#5#10#6#4#6#3#1#9#3#7#10#2#3#8#6#9#6#9#10#2#9#5#10#10#4#0#4#6#2#7#3#3#4#3#2#6#1#4#9#3#0#2#4#7#6#7#6#0#4#6#7#6#2#0#6#0#6#6#7#1#5#6#2#3#1#10#9#4#4#10#6#0#5#10#4#6#6#7#4#9#10#0;
55:result:=#7#0#7#8#0#2#1#2#1#2#5#6#5#5#7#9#6#5#0#2#1#8#1#2#7#1#2#0#0#7#2#1#0#8#3#4#2#10#7#1#0#2#9#1#6#5#7#5#9#1#7#8#5#0#10#3#5#4#6#7#9#3#1#3#0#3#4#7#6#6#9#0#5#3#4#2#4#10#8#5#5#6#0#3#7#7#1#3#3#6#8#3#8#2#4#3#3#4#4#9;
56:result:=#1#9#10#10#3#9#3#7#3#9#3#5#4#9#2#8#7#6#4#3#10#3#0#4#2#6#9#5#7#4#6#0#5#3#6#8#2#6#5#1#4#8#8#0#9#8#2#3#6#7#6#4#1#1#0#1#2#10#10#7#3#7#0#9#4#7#7#1#4#3#3#7#10#9#4#4#2#10#4#1#3#10#4#7#5#7#1#2#2#7#2#9#6#0#1#9#7#9#6#10;
57:result:=#2#8#2#3#1#10#3#3#5#1#0#10#9#5#5#1#2#0#2#1#1#3#10#10#1#9#1#0#1#5#1#9#5#3#7#6#2#2#7#9#6#2#8#4#5#5#0#6#4#5#0#2#5#4#4#9#9#4#10#4#6#8#4#5#9#2#4#9#4#8#4#7#9#9#0#4#0#2#8#10#9#8#7#4#4#10#8#2#0#6#0#2#9#7#1#5#9#5#3#1;
58:result:=#1#0#2#9#9#6#10#1#8#10#6#1#1#8#3#2#2#3#0#0#0#6#4#1#9#2#0#5#6#2#2#2#4#0#10#7#4#7#1#10#8#0#10#9#6#10#1#0#1#8#2#9#7#9#0#7#4#8#5#9#0#0#4#5#9#4#2#3#6#2#10#4#0#1#6#10#4#9#7#10#7#9#10#5#9#2#1#9#3#4#3#2#0#5#10#1#6#5#5#0;
59:result:=#9#2#4#2#9#6#7#1#2#7#4#7#10#10#1#4#9#8#8#7#5#5#6#10#0#0#4#10#0#10#1#7#8#7#0#4#2#2#8#9#10#5#2#6#5#9#1#4#1#10#8#6#10#6#8#3#3#10#2#5#4#3#5#7#2#8#2#0#5#6#8#10#9#1#8#10#4#10#6#7#6#7#3#10#5#1#8#9#9#2#0#10#3#4#7#7#4#4#7#5;
60:result:=#7#6#0#9#0#4#1#5#3#3#9#1#2#10#5#6#2#8#9#8#5#8#8#4#9#9#8#10#9#6#1#4#0#0#4#1#6#9#5#9#4#5#1#8#3#2#8#4#10#10#7#2#9#3#3#4#7#7#9#0#0#6#7#5#9#10#8#2#1#8#0#3#3#7#7#3#5#3#6#5#7#7#3#4#3#4#8#4#10#7#6#3#1#1#1#8#3#2#9#6;
61:result:=#1#5#2#7#2#5#4#10#6#2#6#1#4#6#3#6#8#3#4#4#4#0#9#0#3#3#10#3#7#1#5#5#9#10#6#9#8#3#3#1#7#6#5#9#1#6#4#8#2#4#6#1#2#8#2#5#10#4#3#6#1#7#10#4#3#0#10#10#2#0#2#8#1#10#5#5#9#8#9#0#3#6#8#0#0#1#1#10#10#0#9#2#10#3#9#5#2#4#10#2;
62:result:=#3#2#9#5#7#6#2#9#8#0#3#4#4#8#7#4#2#1#1#5#3#3#10#9#6#2#4#0#0#7#7#3#2#7#9#1#1#8#2#1#7#6#9#9#7#6#0#0#3#5#5#5#2#5#7#6#1#10#10#1#2#1#3#8#7#3#7#0#8#3#7#7#8#7#7#2#0#7#10#5#7#2#4#7#4#3#8#5#1#9#4#1#8#0#0#8#0#1#7#0;
63:result:=#10#2#2#0#1#5#9#3#1#2#3#1#2#1#10#4#5#7#4#0#7#6#10#9#4#2#2#1#10#10#2#3#3#10#2#10#10#5#3#1#6#5#5#9#10#6#0#4#8#9#5#9#4#9#3#5#9#7#4#6#9#1#4#8#0#2#7#3#1#0#8#3#4#5#8#4#10#5#6#10#4#7#9#8#5#2#5#1#4#0#4#2#4#7#3#4#1#1#3#3;
64:result:=#10#8#2#7#8#10#7#1#3#2#3#6#1#10#4#7#3#7#9#5#2#7#9#2#1#0#9#10#2#0#4#3#5#0#0#8#3#6#8#1#0#9#10#4#9#10#2#8#4#0#2#7#2#1#9#1#7#3#10#4#1#6#10#9#10#8#9#3#6#9#10#2#4#1#10#0#7#4#8#6#0#2#8#4#10#3#5#4#6#2#2#4#7#9#3#7#5#6#9#10;
65:result:=#10#1#1#10#2#1#8#5#10#3#2#7#8#3#1#6#9#3#0#1#6#10#4#8#4#2#10#9#3#4#6#0#3#5#3#4#0#7#7#2#5#8#3#8#0#4#3#10#2#10#8#1#1#3#10#1#8#4#6#4#6#0#10#2#6#10#8#5#6#2#10#0#1#6#4#0#2#8#6#1#9#9#2#10#1#8#3#2#6#4#8#8#6#5#4#8#4#3#8#9;
66:result:=#4#6#7#4#1#5#7#6#9#6#8#10#6#4#2#7#10#4#7#5#9#6#7#5#5#10#4#3#0#0#9#10#3#3#9#1#10#10#9#9#4#3#10#9#9#10#4#4#6#5#3#7#2#6#10#4#7#4#2#0#6#8#7#5#8#6#3#5#4#5#2#5#5#2#9#6#10#6#8#6#5#5#3#1#0#5#1#4#2#1#3#3#10#8#10#5#9#0#9#2;
67:result:=#4#0#8#3#5#0#1#6#9#2#4#6#6#9#6#3#3#6#2#8#6#5#6#3#8#0#6#2#10#10#1#5#2#8#1#4#10#1#3#4#3#8#6#4#4#1#0#7#2#6#0#8#10#8#2#3#5#5#7#8#0#0#7#10#5#3#7#10#6#4#1#3#10#7#7#9#10#10#4#7#1#4#8#1#7#5#9#5#3#0#4#1#7#10#0#6#0#7#2#5;
68:result:=#9#4#5#9#10#4#1#3#7#10#3#3#7#4#5#6#1#1#6#9#1#2#0#6#9#4#4#1#8#10#3#5#3#0#0#3#5#2#6#9#7#0#2#2#0#2#8#0#7#4#10#6#7#4#1#6#0#1#0#4#2#8#1#9#7#1#6#10#4#2#10#4#5#9#7#4#2#9#10#8#5#9#6#7#4#9#2#10#5#3#1#9#8#10#6#8#5#8#5#1;
69:result:=#2#3#0#5#1#7#9#1#8#7#9#2#2#4#9#0#5#7#1#4#6#6#6#5#5#9#1#3#4#0#3#10#5#2#10#2#3#1#1#4#4#2#0#10#0#8#4#7#1#8#7#2#5#3#4#6#5#10#9#0#1#10#2#5#1#5#10#8#10#7#4#5#2#4#8#8#5#10#0#5#9#8#10#5#8#2#2#0#0#0#5#6#2#8#6#0#2#6#4#6;
70:result:=#7#1#9#1#5#7#8#7#10#9#3#2#4#4#1#9#6#0#9#10#9#4#5#8#4#8#2#6#3#8#7#0#8#0#1#7#8#5#6#9#10#8#10#7#0#10#5#10#6#6#9#1#10#7#9#8#5#4#4#0#10#10#6#3#7#6#1#8#8#10#2#8#8#6#1#6#7#7#6#8#9#6#6#8#5#5#3#7#0#0#8#5#2#0#7#1#7#2#5#5;
71:result:=#7#2#6#0#10#8#5#7#3#6#9#2#0#1#5#5#9#2#2#1#8#2#3#9#1#9#1#8#5#3#8#6#8#10#10#5#0#6#9#7#5#5#1#9#4#1#8#2#9#3#4#8#6#6#4#10#4#9#8#7#1#7#4#9#7#0#4#1#6#3#6#10#6#2#3#10#6#9#6#7#5#7#5#4#1#8#8#6#7#3#10#5#4#7#7#0#4#8#5#1;
72:result:=#10#5#5#3#8#3#4#6#9#2#10#7#0#3#8#1#3#5#8#6#10#7#0#9#6#2#9#10#9#7#8#0#8#7#7#0#9#10#5#2#9#8#7#8#9#10#2#2#7#8#9#7#5#7#3#0#3#10#10#0#6#8#10#4#5#6#7#8#6#5#10#3#9#6#7#8#10#2#1#2#3#3#10#5#0#4#6#0#9#10#0#2#3#2#8#1#9#8#3#9;
73:result:=#2#10#2#0#7#4#7#0#3#4#9#9#9#2#6#8#0#3#5#5#0#10#0#7#9#7#3#2#3#0#0#6#2#10#9#0#5#3#1#3#1#10#1#9#1#6#3#10#10#1#0#9#0#1#6#3#5#10#7#10#5#4#3#3#3#4#6#9#2#1#6#10#1#7#4#5#1#5#3#8#8#0#1#1#7#5#5#2#7#3#1#7#0#7#5#4#4#8#2#7;
74:result:=#0#4#3#5#2#7#7#10#7#2#1#6#4#2#1#1#4#3#3#1#1#3#0#1#6#9#8#10#8#2#9#4#8#0#8#2#3#6#9#8#6#0#7#9#4#7#2#4#9#8#4#2#9#9#0#2#8#0#2#2#9#0#6#6#9#6#10#7#0#10#2#7#9#4#3#10#3#3#10#0#5#4#2#0#1#0#8#9#1#6#10#2#6#2#7#6#1#2#10#10;
75:result:=#9#1#7#6#4#7#7#4#1#6#9#10#2#3#9#5#5#6#0#4#5#5#7#2#9#5#6#4#9#6#6#6#7#4#0#5#0#6#9#3#10#1#7#9#2#3#6#3#7#3#8#2#5#2#5#1#0#6#9#6#10#10#8#4#9#7#5#9#9#5#3#0#2#2#4#10#6#8#3#2#9#3#2#1#9#2#7#10#6#9#2#7#9#3#3#9#7#10#10#1;
76:result:=#8#2#10#9#6#0#10#2#6#4#10#7#4#1#4#9#2#9#0#6#6#7#6#8#5#10#6#10#10#8#1#1#7#7#0#9#2#3#5#5#2#10#3#5#7#8#0#6#5#9#10#0#9#2#8#7#3#10#2#9#7#9#0#6#7#5#1#1#0#1#4#1#10#3#0#1#8#2#3#6#3#7#10#1#10#3#0#10#1#10#6#4#10#3#7#8#8#7#4#8;
77:result:=#8#9#1#1#6#2#9#1#7#1#1#2#4#2#9#6#3#8#6#7#5#1#9#9#4#5#4#10#9#3#2#9#0#1#2#5#8#8#0#8#9#3#1#3#7#1#3#2#1#2#9#9#4#2#3#9#8#3#5#8#2#4#4#4#1#0#4#6#3#9#0#8#10#9#5#6#9#4#9#7#2#1#5#1#4#6#0#5#0#7#6#8#7#2#1#2#0#9#5#8;
78:result:=#9#9#1#1#10#3#0#3#8#10#7#8#3#7#10#9#3#0#8#4#7#0#2#1#5#10#1#2#5#4#7#9#4#6#4#5#9#5#3#6#2#8#5#10#9#0#3#10#8#2#6#7#1#2#4#8#7#9#2#4#1#5#10#6#4#8#9#9#3#6#3#1#1#0#0#8#0#0#4#2#9#1#0#7#2#2#8#1#3#4#9#3#4#6#6#2#10#5#5#8;
79:result:=#10#10#10#5#2#9#8#10#9#6#3#0#1#4#8#5#1#4#8#9#5#0#9#9#2#2#1#8#6#3#0#10#7#5#5#5#6#6#4#8#0#1#4#7#5#2#4#4#2#5#2#5#4#3#4#8#7#7#1#0#5#5#3#10#10#4#1#5#10#6#0#7#1#0#10#9#7#5#1#3#0#7#9#1#2#10#10#5#2#9#2#4#0#0#8#5#1#0#4#6;
80:result:=#3#1#0#1#3#7#6#2#9#5#4#5#6#1#10#10#1#6#5#9#3#8#4#1#6#2#10#10#1#2#8#3#5#10#5#5#7#10#0#9#4#3#4#8#10#7#3#3#2#0#4#4#1#1#5#10#6#1#1#0#9#0#0#5#6#4#6#9#0#9#10#9#7#4#0#3#7#3#6#7#7#1#4#5#7#4#8#5#3#3#8#9#7#10#0#10#4#3#10#7;
81:result:=#10#1#3#9#2#9#4#8#3#4#8#9#9#10#5#7#6#1#4#10#3#10#10#1#1#8#9#8#10#4#8#0#7#2#4#2#2#4#4#3#9#7#10#9#10#3#4#4#3#4#9#3#8#7#6#10#2#6#4#4#3#3#4#1#5#6#2#10#4#3#6#5#7#0#3#9#1#5#8#10#1#3#8#2#4#9#8#9#9#9#2#2#4#1#8#10#0#4#3#9;
82:result:=#9#5#7#3#1#10#1#2#7#7#1#8#10#7#7#1#4#5#2#9#5#2#4#1#2#8#10#7#1#6#1#4#4#3#2#2#10#0#0#5#9#10#10#0#7#1#6#0#6#10#8#4#9#10#10#9#10#3#8#2#1#2#3#8#2#8#6#2#3#3#6#5#10#9#5#0#7#4#3#7#10#2#9#3#8#3#2#8#4#8#1#7#1#8#7#8#10#4#1#6;
83:result:=#3#1#6#1#4#7#0#10#4#6#0#6#5#0#1#0#4#1#2#0#9#5#4#8#0#9#1#10#0#5#0#3#7#1#9#8#4#10#6#9#8#0#1#10#3#5#10#4#2#4#9#2#3#7#6#5#7#9#9#8#1#8#3#5#2#2#7#7#3#2#3#10#8#8#9#6#3#5#5#7#10#6#3#0#9#7#6#6#4#9#0#0#6#5#0#0#9#8#9#4;
84:result:=#6#2#9#2#9#5#8#1#7#3#0#5#5#4#8#6#6#0#2#9#5#9#10#6#1#6#10#1#1#5#1#9#4#7#3#6#4#10#7#9#3#9#6#0#1#9#8#9#7#1#3#0#9#8#2#7#2#5#9#3#6#3#7#0#3#3#10#1#6#6#2#7#5#8#1#0#3#4#6#3#2#7#2#8#3#1#4#4#5#3#5#8#0#4#4#0#7#0#7#7;
85:result:=#3#8#5#5#0#0#5#5#10#8#3#5#5#3#9#7#4#6#3#7#5#6#3#0#8#6#8#4#9#9#7#0#1#6#6#5#4#4#4#0#10#9#3#0#6#7#1#5#4#2#9#10#10#7#8#1#1#8#9#6#3#8#5#2#6#0#7#9#4#0#5#5#6#2#0#0#6#8#8#5#4#4#1#3#3#3#1#5#8#1#6#6#6#10#2#8#8#10#1#4;
86:result:=#4#9#2#3#5#4#1#7#9#5#7#4#0#9#3#8#4#8#7#0#7#3#3#3#10#5#0#4#7#10#7#6#3#1#0#6#5#6#3#2#6#7#0#5#1#6#8#10#8#0#4#1#1#3#1#10#1#9#9#10#10#5#8#8#6#0#2#4#7#10#5#3#0#6#6#3#9#2#0#1#3#8#4#6#5#4#8#0#4#2#9#10#2#9#2#6#2#10#0#8;
87:result:=#4#3#6#7#4#2#5#0#4#0#6#3#4#9#5#8#5#1#5#1#4#0#4#10#6#1#1#10#5#1#4#8#3#6#10#3#10#8#2#1#7#4#3#2#10#1#5#2#3#5#3#0#6#9#6#6#1#3#5#10#6#2#4#2#3#1#8#4#10#7#7#7#2#4#1#2#6#9#0#3#0#6#10#9#6#4#6#1#7#1#6#8#8#6#10#2#5#6#6#4;
88:result:=#8#3#0#0#6#0#0#6#2#8#6#6#3#1#6#8#9#1#2#2#7#1#7#10#2#0#6#4#3#1#9#9#7#0#0#3#9#0#3#0#4#2#8#1#9#0#2#3#0#9#6#1#5#9#3#1#4#0#1#9#5#9#5#5#1#4#7#7#0#10#1#1#0#4#9#5#9#4#3#0#7#4#1#3#2#5#2#3#3#7#0#0#9#5#1#3#2#0#4#0;
89:result:=#8#2#1#0#9#9#10#7#6#10#1#8#5#7#9#9#6#1#2#4#5#5#7#10#9#0#0#6#6#7#1#6#6#1#8#8#8#6#3#0#7#5#5#6#10#7#9#2#4#8#0#9#0#8#5#0#8#8#2#7#4#10#9#2#7#8#9#10#3#4#9#7#10#3#8#8#8#5#9#5#9#10#10#10#5#1#6#1#5#4#0#2#1#10#5#9#0#10#4#9;
90:result:=#8#6#5#8#6#9#2#8#6#2#10#9#1#5#0#7#10#0#0#6#10#8#9#0#2#3#8#4#5#5#2#6#5#0#0#1#10#0#6#2#1#0#6#5#2#6#8#6#1#3#9#1#4#2#3#0#1#3#2#7#6#9#7#10#8#2#2#1#7#1#2#10#10#3#7#3#7#5#6#1#0#6#10#0#5#4#0#5#1#9#7#5#6#5#0#3#2#2#5#4;
91:result:=#9#6#1#1#9#3#2#4#10#4#1#3#3#8#0#0#10#2#1#9#9#1#1#5#6#7#7#9#10#5#3#0#5#2#0#10#5#6#0#7#3#0#1#9#1#7#8#3#10#0#3#7#7#4#3#5#3#4#3#5#7#4#1#9#1#4#3#9#7#6#1#1#7#1#6#2#2#5#8#3#8#3#9#8#1#10#0#0#6#5#6#7#4#7#1#8#6#5#8#7;
92:result:=#0#10#8#6#9#3#5#7#7#10#3#1#0#0#10#3#7#2#9#8#5#7#5#7#0#7#5#3#7#4#1#0#5#4#8#10#2#9#0#10#3#5#10#3#7#5#2#3#10#7#2#3#4#6#9#6#8#2#1#5#8#2#7#3#7#7#4#9#1#10#6#8#2#1#7#8#7#3#10#4#3#9#5#0#1#4#0#10#1#10#10#8#4#6#1#5#4#6#2#2;
93:result:=#6#8#7#2#2#4#7#10#6#3#1#0#4#4#1#5#3#4#2#2#6#10#10#10#3#2#1#2#6#0#1#5#4#10#9#4#6#4#10#7#1#9#2#2#8#10#0#0#4#6#9#4#9#8#6#4#7#3#8#2#9#0#6#6#0#2#9#0#0#8#5#2#0#3#7#10#1#4#4#0#5#9#5#4#0#7#6#0#6#4#10#3#3#7#2#9#10#2#7#3;
94:result:=#8#10#9#5#7#9#2#3#9#5#0#9#8#8#10#5#1#6#4#9#9#2#0#7#6#1#1#10#2#1#3#5#8#6#10#6#5#4#4#0#7#2#0#8#8#9#1#0#3#9#3#8#2#10#1#5#7#7#10#3#6#2#10#3#2#3#1#2#2#8#4#5#2#7#8#9#10#6#9#9#5#4#7#9#8#0#10#3#3#4#6#4#8#4#9#2#10#0#10#5;
95:result:=#9#8#10#8#1#9#1#5#8#9#3#6#10#9#7#7#0#3#10#9#7#10#3#8#1#5#6#5#3#4#8#0#6#6#6#8#0#10#4#8#0#9#10#5#5#3#1#3#5#10#10#10#4#6#9#5#9#2#6#10#2#5#8#9#0#7#2#8#7#2#2#6#7#3#10#6#6#5#2#2#2#2#8#9#6#0#2#1#9#0#9#1#10#1#1#3#0#0#8#2;
96:result:=#7#0#6#2#2#9#1#5#0#6#6#5#2#1#7#9#1#8#0#9#8#1#0#6#5#7#8#6#6#9#5#10#8#8#10#5#10#0#10#7#3#7#0#4#1#7#5#3#10#6#10#9#1#8#4#0#2#0#7#9#0#6#3#7#7#10#1#4#10#0#5#3#2#0#1#10#5#2#9#1#1#1#4#4#0#9#9#4#0#6#6#1#10#1#0#4#1#1#3#9;
97:result:=#0#0#6#1#3#7#3#4#4#7#10#2#6#4#0#4#5#1#9#10#4#4#2#6#2#7#9#6#9#9#1#8#10#10#4#7#5#3#1#4#1#1#7#6#4#2#8#1#4#3#8#9#3#2#1#10#10#8#7#7#8#10#5#8#10#6#1#1#2#0#6#4#0#9#5#6#5#8#1#6#1#8#3#10#1#3#9#6#6#0#0#2#4#2#8#8#2#6#4#4;
98:result:=#4#7#0#10#0#8#6#9#0#10#10#7#10#8#1#8#9#2#7#10#7#10#2#2#8#5#9#3#7#3#5#1#6#5#6#2#1#9#7#0#10#10#3#4#0#5#0#5#0#6#8#3#3#8#0#8#7#8#9#2#0#1#3#7#9#5#10#8#6#6#1#1#5#1#0#6#0#8#2#0#8#2#5#2#5#4#10#0#8#1#2#1#7#10#6#1#6#0#1#6;
99:result:=#10#6#0#2#5#8#9#0#6#4#6#1#4#7#6#6#9#0#1#7#1#5#10#4#8#9#2#0#10#3#8#3#1#1#1#7#3#1#4#8#1#10#7#0#1#0#2#10#10#1#3#3#4#2#4#7#4#6#5#0#4#10#6#8#3#3#7#0#10#10#3#2#6#8#7#8#4#0#1#2#10#4#9#8#7#6#3#5#3#7#6#1#1#1#0#3#7#1#8#0;
100:result:=#5#6#8#3#0#3#4#0#3#10#10#9#10#1#9#3#7#9#8#2#10#5#9#2#5#6#4#10#10#5#10#8#2#8#3#7#10#4#4#4#6#6#3#5#5#6#10#1#4#5#2#2#5#3#9#8#9#9#1#10#0#8#4#2#2#1#9#8#8#0#6#10#2#4#7#6#4#8#6#7#8#10#6#8#2#1#2#2#7#9#3#10#0#8#1#9#7#5#9#3;
101:result:=#8#10#10#6#9#3#5#9#8#7#6#9#7#10#1#3#7#10#9#3#2#0#0#3#5#4#6#2#9#9#0#8#7#8#6#8#6#0#10#4#8#8#7#5#1#10#6#10#6#4#7#8#10#7#3#6#0#0#0#0#9#10#3#6#4#7#9#8#2#6#1#9#1#9#10#7#0#9#0#10#3#0#8#10#1#3#9#0#7#4#3#2#0#10#5#1#4#0#1#6;
102:result:=#8#8#3#4#6#0#5#7#5#4#9#4#9#3#3#10#5#2#5#0#6#6#8#1#6#10#2#9#8#9#10#9#10#9#2#6#3#7#8#2#4#5#9#4#0#3#9#6#1#4#9#7#3#9#6#0#7#0#9#1#5#10#0#0#0#8#7#3#7#6#9#8#9#1#4#0#7#1#8#1#9#1#5#5#5#9#5#5#7#6#2#1#5#1#1#0#7#0#6#1;
103:result:=#3#9#7#5#9#3#0#3#10#6#7#10#9#5#8#5#3#7#9#4#10#10#1#1#2#8#4#8#1#6#3#9#2#10#6#4#4#2#8#2#2#4#6#9#8#0#0#9#0#6#7#6#7#4#3#2#0#3#9#6#2#1#6#10#4#5#8#9#7#0#0#6#2#0#2#4#0#0#3#5#1#2#7#3#2#5#4#7#9#9#8#8#0#8#6#2#3#6#9#4;
104:result:=#7#1#6#3#9#10#8#9#2#0#10#8#4#6#0#0#10#10#8#6#6#5#5#1#5#4#8#9#8#7#3#8#5#7#7#2#4#1#4#2#9#5#7#3#0#0#9#2#2#2#0#9#8#10#7#3#10#4#1#6#8#6#1#10#3#2#10#0#1#8#5#1#5#3#6#4#4#1#7#8#4#1#2#6#9#0#10#6#0#5#10#6#4#1#0#0#2#3#1#6;
105:result:=#1#6#6#1#7#9#2#7#0#10#7#7#8#4#7#8#10#1#1#10#2#5#10#6#2#9#1#4#3#5#9#5#0#2#3#1#1#3#3#2#9#8#7#0#9#0#3#1#9#6#1#0#3#2#0#5#1#5#6#6#8#5#7#3#5#1#5#0#2#3#5#7#10#1#3#4#1#0#2#8#3#6#1#2#6#5#0#10#10#0#8#5#9#0#9#8#6#8#10#3;
106:result:=#8#9#0#9#9#0#7#4#9#3#0#3#8#10#3#8#0#6#5#10#0#8#0#9#7#10#9#2#6#1#8#2#2#0#3#4#2#8#6#7#6#10#7#5#3#7#1#3#0#2#10#10#1#6#1#10#4#1#6#3#2#3#2#5#4#10#5#1#9#10#4#4#8#3#7#2#9#3#1#5#4#10#8#7#9#3#7#2#4#7#5#4#0#10#6#10#9#8#9#4;
107:result:=#2#5#2#7#9#6#7#0#3#3#9#4#7#6#3#7#3#4#8#1#8#4#1#10#4#8#4#8#4#9#1#1#6#7#8#0#3#1#8#5#10#10#2#0#7#8#7#6#0#5#1#5#9#8#7#3#5#1#3#10#6#3#4#6#8#1#3#0#8#3#6#3#2#4#1#10#10#7#0#8#5#7#2#2#9#7#5#7#1#5#0#3#2#10#3#3#8#8#0#6;
108:result:=#7#9#0#10#10#5#7#5#4#10#2#9#6#2#1#7#1#7#7#3#10#8#5#2#9#9#6#8#9#8#4#6#7#1#4#10#10#1#0#7#6#10#2#1#6#8#5#0#9#0#3#6#4#0#8#9#6#0#8#3#6#8#7#4#1#9#5#7#10#9#8#3#4#5#8#0#9#4#8#0#5#3#0#5#7#10#0#9#8#8#3#2#8#7#9#4#8#8#3#5;
109:result:=#0#0#1#7#4#0#4#7#0#3#9#4#3#9#1#2#7#1#6#0#5#1#5#10#5#8#5#3#1#8#4#8#4#0#10#10#8#8#8#7#1#3#4#1#6#4#8#8#1#0#9#4#2#6#6#6#0#5#8#9#8#8#6#8#8#9#10#0#8#0#1#9#3#2#6#5#9#7#9#3#5#10#6#10#1#5#7#4#0#9#5#2#4#7#3#9#10#4#1#4;
110:result:=#7#2#0#8#1#5#5#8#3#4#8#6#10#8#5#3#8#3#9#4#4#0#1#5#7#5#10#1#1#5#5#3#0#0#4#1#3#6#5#6#5#4#9#8#7#6#3#10#1#6#9#0#2#6#9#2#1#5#9#8#6#6#2#8#10#8#6#5#9#7#9#9#8#6#3#6#3#0#3#8#9#10#7#9#9#4#3#1#5#9#3#9#1#2#8#3#9#4#4#4;
111:result:=#1#9#3#4#5#10#5#9#5#8#6#5#1#1#8#4#0#6#0#10#5#8#1#5#4#5#5#3#1#5#8#3#6#9#5#7#1#7#1#5#4#0#3#7#6#10#9#2#8#8#0#8#8#7#7#7#10#5#2#9#3#10#4#8#0#6#5#10#2#9#5#1#1#2#1#5#2#1#3#5#0#8#10#10#0#1#4#3#10#2#6#8#4#6#0#9#6#4#10#8;
112:result:=#1#8#10#5#6#2#6#7#9#9#5#8#5#9#0#10#0#5#5#4#2#1#5#3#3#5#2#4#6#8#2#1#4#7#7#1#3#10#4#10#6#10#7#3#8#4#3#3#5#4#2#8#8#10#1#9#1#6#2#2#7#7#5#10#6#10#9#9#7#1#4#4#1#6#0#5#10#4#5#1#2#6#4#3#8#0#6#2#6#3#6#10#8#4#3#6#1#1#4#0;
113:result:=#8#2#7#1#8#10#5#4#1#10#6#2#0#9#2#7#8#5#2#9#8#5#5#4#9#6#0#2#6#8#2#2#6#8#3#7#1#3#0#3#0#6#7#0#6#10#2#8#7#5#6#1#6#8#9#1#4#0#7#8#6#5#10#9#8#8#7#6#5#9#4#2#3#0#2#0#9#8#4#0#2#7#1#0#2#2#9#0#2#0#7#9#5#10#5#4#7#2#2#8;
114:result:=#6#3#3#5#0#6#4#10#5#4#2#3#0#9#8#2#4#5#4#2#0#1#4#7#1#10#1#2#6#1#5#1#8#8#3#8#6#7#10#6#4#9#2#1#5#5#4#0#5#0#1#6#2#3#7#3#9#3#6#6#3#0#2#1#7#2#10#4#6#1#4#1#5#4#6#0#6#10#10#6#2#6#8#4#2#7#0#4#5#0#10#9#8#5#2#9#8#10#6#1;
115:result:=#8#0#8#8#6#0#10#5#3#4#8#7#9#6#10#2#7#9#6#4#6#2#6#1#3#9#6#3#8#9#4#0#3#10#8#0#6#3#1#0#1#8#10#8#4#1#10#2#7#8#2#3#8#9#4#6#3#1#4#0#1#8#6#7#6#6#8#8#4#5#5#10#5#10#2#1#10#8#3#10#4#6#3#1#7#0#7#5#7#5#10#3#5#5#1#2#2#1#9#7;
116:result:=#10#0#7#7#6#6#10#5#6#6#2#5#5#9#9#1#1#2#0#8#2#6#7#2#5#10#0#0#2#10#7#0#1#5#8#5#2#0#0#7#6#4#7#3#7#4#7#9#6#6#6#6#5#1#1#3#8#4#1#2#7#10#4#1#9#6#3#7#2#7#3#9#9#6#8#3#0#5#1#8#10#6#6#9#9#7#0#1#9#7#0#1#0#1#1#3#2#9#1#4;
117:result:=#0#8#9#0#8#10#4#10#10#7#2#10#9#8#0#5#4#3#2#8#7#2#4#6#1#0#2#5#1#1#5#9#8#0#7#9#3#0#4#0#10#7#5#3#0#6#0#5#10#3#7#10#6#1#8#10#9#4#0#6#6#3#0#2#5#4#3#10#9#10#4#9#10#8#3#2#2#8#1#6#0#6#5#3#5#9#3#0#4#2#4#7#6#3#8#5#10#4#0#2;
118:result:=#4#2#10#2#10#4#6#1#3#0#4#7#2#10#0#10#0#7#6#0#3#0#8#0#1#1#2#8#6#6#5#6#4#2#7#2#5#5#10#8#10#1#2#5#5#10#6#9#0#3#5#7#4#6#3#2#4#9#0#10#8#2#4#6#9#6#8#6#2#1#4#10#0#10#3#7#8#0#9#6#0#1#3#0#7#10#8#0#2#7#7#0#4#3#7#4#2#8#5#4;
119:result:=#10#9#10#8#3#5#8#0#9#5#4#6#0#0#9#7#5#4#6#4#10#9#5#9#5#8#2#10#5#7#0#2#10#5#0#6#6#7#3#10#0#4#1#8#6#6#10#7#4#9#9#4#4#7#7#3#5#5#3#9#3#10#4#1#7#1#9#8#9#8#8#2#7#7#10#9#7#7#3#5#1#3#1#4#9#5#5#1#8#10#2#5#6#5#5#6#9#4#0#1;
120:result:=#9#10#4#2#7#0#10#4#9#1#6#1#10#1#9#0#4#9#8#1#4#6#3#9#0#2#1#4#4#9#0#6#5#3#1#5#8#1#5#5#3#1#4#10#1#0#10#10#1#3#7#10#3#6#1#8#6#3#0#1#7#9#10#1#7#4#9#5#4#3#10#10#5#4#10#8#4#1#0#1#2#5#7#2#0#1#6#6#10#6#9#4#1#9#4#1#2#6#2#5;
121:result:=#10#9#8#4#6#4#6#0#5#8#5#8#9#1#9#7#1#0#3#5#2#4#10#6#6#5#8#1#2#3#0#9#4#8#7#10#1#0#5#3#8#7#0#2#2#0#4#8#8#0#4#3#10#10#8#5#10#10#10#9#5#1#6#10#6#10#6#6#3#9#8#10#5#8#3#0#5#10#2#0#7#8#10#7#3#6#5#2#8#7#7#1#1#9#6#10#0#1#2#0;
122:result:=#8#1#3#6#4#5#5#10#9#0#3#10#8#5#3#8#10#6#4#4#4#6#0#0#10#1#1#0#1#9#9#7#7#3#0#3#6#6#4#10#7#1#1#10#4#4#9#6#0#8#4#2#9#5#0#1#10#8#6#4#9#4#8#4#8#8#7#7#1#0#4#2#0#4#7#3#9#7#1#7#3#2#6#0#1#1#2#7#2#6#9#0#2#1#1#2#0#4#9#8;
123:result:=#6#1#8#2#2#0#2#5#0#0#9#6#10#0#7#1#7#0#7#6#8#8#1#1#9#0#7#4#5#6#0#10#7#5#0#4#6#3#5#7#9#2#9#2#7#5#3#7#1#4#2#7#6#1#1#7#0#9#9#1#0#4#7#3#5#3#8#6#4#5#5#1#8#9#0#5#7#9#3#8#4#6#3#1#7#10#8#5#0#4#7#4#7#3#0#1#2#8#9#8;
124:result:=#10#1#6#0#0#1#7#8#8#6#10#8#6#4#1#2#3#4#5#6#7#2#10#7#6#6#4#3#6#7#0#2#6#7#9#5#8#3#10#3#1#0#8#3#2#10#3#7#3#8#0#9#7#5#9#3#5#10#8#0#2#8#7#1#6#6#4#7#8#4#2#10#7#8#10#9#0#5#3#0#10#4#7#1#6#4#5#2#7#7#1#2#3#6#5#3#4#7#9#5;
125:result:=#7#1#1#2#6#3#8#0#9#9#0#3#3#8#10#0#6#1#3#1#0#7#4#9#2#7#3#5#3#6#2#1#8#3#3#6#7#6#1#10#0#0#2#7#4#3#9#4#6#3#8#5#8#4#2#7#6#10#2#6#8#0#0#3#2#4#5#8#3#0#1#4#10#5#1#5#6#7#8#10#5#7#5#3#9#0#4#9#1#9#2#10#1#1#10#1#10#7#8#8;
126:result:=#4#8#6#3#6#9#8#3#9#6#4#1#7#8#4#3#5#0#3#9#2#10#6#9#9#7#3#4#5#2#2#7#2#6#2#3#8#2#6#10#4#7#9#8#5#8#2#1#7#8#5#8#1#1#7#10#3#8#6#9#4#1#0#9#6#5#5#3#9#10#9#2#5#10#8#2#0#10#1#10#8#9#2#10#7#8#2#0#0#5#9#3#8#1#7#10#0#6#2#9;
127:result:=#5#8#5#3#2#1#10#0#0#1#4#7#6#9#7#3#7#4#6#2#5#1#4#5#6#10#6#5#4#0#5#7#4#6#10#8#10#3#8#6#1#2#2#9#6#5#10#4#3#10#10#7#0#9#10#0#6#9#5#8#0#0#9#3#8#10#4#0#8#6#10#4#7#8#1#8#7#5#1#9#2#8#10#9#3#0#8#6#1#3#1#7#0#10#3#3#10#3#6#9;
128:result:=#0#0#6#8#7#3#9#6#4#9#0#0#0#4#10#3#7#2#3#7#7#4#6#7#7#0#0#2#4#9#9#3#0#9#1#10#2#0#0#9#6#3#4#6#8#9#9#9#9#8#6#10#1#10#8#2#1#0#0#5#2#9#4#5#10#5#5#2#8#1#7#1#8#0#10#8#8#2#5#7#2#3#9#7#2#10#1#4#7#1#0#4#5#10#10#8#2#1#9#8;
129:result:=#9#4#8#5#0#10#1#2#5#2#10#9#4#6#9#5#6#8#9#8#4#3#9#5#7#2#7#9#0#3#10#9#6#8#5#7#8#4#5#10#8#8#2#9#10#3#7#8#5#10#5#9#9#0#2#10#4#10#7#4#8#6#9#5#10#8#2#3#10#4#4#6#7#10#9#4#5#2#8#7#10#8#7#8#0#2#5#1#7#7#5#5#8#6#10#8#6#8#4#7;
130:result:=#2#6#10#0#6#4#1#3#6#3#0#7#10#2#3#4#5#5#1#1#6#5#6#4#4#10#0#7#0#1#7#6#7#0#3#9#0#1#7#6#9#6#9#10#10#3#2#1#3#1#5#3#9#8#6#3#0#5#4#2#5#8#8#7#8#4#6#9#10#1#1#5#0#0#7#8#4#7#5#4#0#9#8#6#0#10#3#10#0#0#7#4#0#7#6#4#7#1#5#4;
131:result:=#4#2#6#5#6#9#9#1#4#10#4#0#8#10#1#3#2#1#8#1#10#5#8#10#3#7#2#8#9#0#10#2#10#0#8#3#4#1#6#2#10#6#2#7#0#4#4#1#7#6#8#10#0#10#1#9#0#1#7#4#7#6#5#8#0#9#1#7#10#3#8#2#7#7#5#7#1#8#5#4#10#10#9#4#9#3#5#8#3#6#4#10#5#9#9#6#8#3#6#8;
132:result:=#1#7#7#10#9#4#9#1#6#10#2#8#9#1#2#0#8#10#1#5#4#1#9#5#7#4#5#10#2#2#10#9#5#7#10#5#10#6#0#9#7#8#2#4#6#3#4#5#4#10#5#7#10#10#7#9#7#5#6#4#10#7#4#3#9#9#5#7#8#9#0#1#9#4#0#9#3#3#10#6#0#7#6#0#7#9#4#6#9#8#5#0#6#2#0#9#10#9#8#5;
133:result:=#0#9#9#3#5#7#1#1#7#10#9#2#3#5#9#1#10#5#1#10#9#8#3#4#2#9#4#4#6#3#6#7#3#10#7#1#2#10#8#9#7#4#9#9#7#10#8#5#9#4#7#0#10#2#1#4#0#6#8#0#4#0#0#10#9#3#10#1#2#2#2#10#3#4#0#7#7#5#8#7#2#0#4#3#7#8#8#5#7#10#10#10#3#8#9#2#6#10#10#8;
134:result:=#3#10#6#8#0#8#6#5#10#9#1#0#10#5#5#3#5#5#0#6#9#8#6#7#1#6#9#0#5#7#5#9#8#4#8#2#7#8#0#0#10#7#9#1#1#9#4#0#10#10#7#0#6#2#7#10#6#3#4#1#0#2#2#0#2#2#8#5#10#10#6#4#4#8#2#2#3#9#8#3#5#5#3#7#2#9#1#7#6#0#3#10#5#0#1#9#0#6#3#6;
135:result:=#1#3#1#9#7#10#10#7#1#3#2#6#9#10#2#6#3#3#3#9#10#1#7#2#10#5#1#3#0#5#1#5#7#10#1#8#6#2#1#7#5#6#7#0#3#6#0#6#9#10#5#9#6#5#0#2#4#9#6#2#4#4#7#0#4#6#8#9#8#6#2#5#10#0#1#7#7#5#8#8#9#1#2#2#3#8#3#6#3#10#7#0#1#1#5#2#3#9#10#10;
136:result:=#7#1#0#4#6#9#8#9#4#2#8#9#7#6#9#5#1#0#8#7#2#7#9#10#5#5#9#7#5#2#10#1#1#10#9#4#5#0#8#0#2#9#9#7#0#6#5#8#10#10#1#9#1#6#9#9#4#5#0#5#8#1#9#7#8#5#3#7#5#3#6#2#5#1#1#10#8#5#8#0#6#0#4#3#0#3#3#3#0#0#1#1#7#4#5#10#2#10#4#1;
137:result:=#0#4#10#1#1#4#4#6#1#1#10#7#1#9#2#5#7#0#1#8#6#3#2#4#4#2#2#7#3#8#7#9#6#7#3#0#5#4#3#9#6#5#10#1#5#1#4#4#4#9#3#1#2#3#1#10#2#2#10#8#7#3#8#8#1#6#7#1#7#6#4#9#8#2#3#2#6#7#1#4#5#10#1#1#10#5#7#3#9#2#4#2#1#4#0#8#5#0#10#2;
138:result:=#9#1#3#8#8#9#3#8#5#3#1#5#10#9#8#1#1#9#5#0#10#3#8#4#3#5#0#7#4#2#4#9#1#5#3#3#7#8#9#0#2#10#3#9#4#2#8#3#9#1#3#8#9#1#10#7#1#3#7#3#1#8#1#2#10#9#8#9#1#1#2#2#8#6#3#4#5#7#7#4#6#5#4#7#9#4#7#8#2#8#4#5#10#2#7#2#2#0#7#0;
139:result:=#9#8#8#10#2#4#8#2#5#3#2#0#1#8#3#5#6#4#0#7#5#6#0#8#6#2#5#4#6#4#3#10#9#8#1#9#5#5#0#1#3#3#2#4#1#3#0#3#10#5#8#3#7#9#6#10#9#9#3#3#9#8#4#2#5#6#8#10#9#1#7#1#10#5#9#5#6#0#0#7#3#6#6#0#7#6#8#6#2#3#10#8#7#7#10#8#3#10#8#4;
140:result:=#3#6#6#10#8#8#0#8#0#6#0#6#9#9#5#4#3#9#3#3#8#4#4#6#0#2#6#3#2#9#8#5#10#3#2#5#3#7#3#7#5#10#1#6#6#7#2#0#5#9#8#5#6#0#8#2#5#0#9#6#2#8#1#9#9#9#4#5#6#5#9#2#6#9#1#5#3#10#2#10#0#9#7#8#3#6#3#9#1#3#4#1#8#3#8#1#2#6#2#5;
141:result:=#5#7#5#1#3#6#7#7#3#8#5#0#9#3#3#5#6#7#4#1#6#9#6#7#4#7#4#3#2#3#2#4#7#1#8#10#2#10#3#1#1#6#8#8#9#4#0#0#6#4#6#9#9#0#7#7#0#1#2#7#0#8#4#6#5#8#5#7#6#4#7#10#5#2#4#7#10#9#9#7#3#9#5#0#7#9#9#8#10#4#1#4#8#6#1#8#1#4#9#3;
142:result:=#9#9#0#0#5#8#3#3#1#2#9#9#7#10#0#9#0#9#2#2#5#5#8#1#7#7#0#3#6#5#9#3#3#0#6#4#5#8#1#8#3#0#10#7#1#3#1#8#8#2#7#6#3#9#1#7#9#0#3#9#5#4#9#10#6#0#6#8#0#8#0#0#5#1#1#4#1#6#9#2#9#5#0#2#5#0#1#10#8#8#4#7#3#5#1#1#8#6#0#3;
143:result:=#10#1#0#5#7#3#8#1#7#0#4#3#1#10#1#4#2#2#2#1#5#9#3#2#3#7#4#7#6#10#10#5#3#1#6#7#8#5#7#10#7#0#2#8#6#6#5#4#9#7#6#7#3#5#2#9#5#8#2#8#3#1#0#3#5#6#9#3#9#6#3#0#8#4#9#10#2#8#8#6#4#0#8#0#5#0#9#7#7#6#5#6#5#4#1#2#3#5#7#3;
144:result:=#0#8#0#2#3#2#9#2#10#4#3#9#7#3#3#1#3#7#3#1#2#7#2#10#6#0#7#1#5#4#5#9#2#10#0#6#5#10#1#3#8#2#3#6#0#9#2#8#2#10#0#2#6#2#6#1#2#5#3#4#2#10#4#2#6#6#8#10#2#2#6#10#8#4#2#8#0#4#1#3#4#3#9#2#7#5#7#5#6#1#4#9#0#3#2#10#2#8#8#2;
145:result:=#2#4#2#2#9#5#9#5#6#9#4#1#2#3#0#2#5#5#0#9#7#5#1#8#5#8#1#8#1#10#5#2#0#7#4#2#2#10#3#7#7#5#9#8#0#7#2#1#5#0#1#9#6#2#9#9#8#1#3#8#5#5#4#8#7#10#4#6#7#7#4#4#6#10#1#10#3#0#3#0#1#9#7#7#2#0#4#2#10#5#3#10#5#0#5#5#3#0#7#8;
146:result:=#6#1#0#3#1#3#5#9#2#2#10#10#4#4#4#4#9#5#9#6#5#1#5#7#1#0#0#1#6#7#0#9#7#4#7#6#0#9#8#6#4#2#8#6#4#10#5#6#4#8#1#0#3#8#9#6#6#4#10#2#0#3#0#6#5#0#9#7#6#1#5#5#1#9#0#0#6#6#9#9#1#5#8#0#4#5#8#4#2#6#2#5#0#2#9#4#8#2#1#7;
147:result:=#0#0#9#3#9#3#3#10#4#5#8#1#0#9#5#6#0#7#7#0#0#7#5#4#6#6#3#7#9#10#8#0#2#0#5#8#1#6#6#0#1#3#7#2#4#8#9#1#8#0#3#8#3#4#7#4#6#4#8#2#8#3#10#7#10#6#0#10#2#10#1#2#7#7#0#8#2#6#2#6#4#5#2#9#2#8#10#0#4#4#6#7#9#5#9#10#5#8#3#0;
148:result:=#8#7#10#0#8#1#7#9#9#3#9#2#0#5#5#10#0#0#2#6#6#2#1#3#0#9#3#7#4#8#3#5#2#0#10#1#8#9#1#4#2#6#10#10#1#8#9#8#0#1#4#5#1#4#1#1#9#6#3#0#4#1#1#9#1#6#8#0#1#0#6#0#9#4#6#10#2#1#10#3#5#3#1#10#0#0#3#9#1#3#7#10#4#8#10#0#10#7#3#3;
149:result:=#8#7#0#1#7#6#8#9#2#1#7#8#6#10#1#3#9#4#6#10#4#4#10#4#7#1#2#0#3#1#9#5#4#4#7#7#2#3#3#0#3#3#7#6#8#4#8#8#0#3#0#5#6#5#8#2#9#6#4#0#7#4#3#9#7#9#10#4#3#6#0#9#9#7#4#2#3#1#7#4#8#6#8#4#3#2#5#3#8#1#2#6#7#3#6#0#9#6#3#8;
150:result:=#7#9#4#5#6#6#9#5#4#7#10#5#10#9#2#1#6#4#5#3#4#10#4#3#9#7#1#1#0#7#5#8#3#0#1#5#5#7#6#5#6#6#10#10#3#5#8#9#10#7#0#2#1#7#1#0#9#5#0#6#10#3#1#4#6#9#6#8#8#9#10#3#1#6#6#9#3#8#1#6#3#2#2#4#6#1#0#8#3#6#5#6#4#3#3#0#8#4#0#8;
151:result:=#9#6#7#4#5#4#10#1#2#8#10#10#4#7#0#9#6#6#9#9#9#1#0#3#6#6#0#1#4#5#7#4#5#4#5#4#10#0#8#8#0#3#2#3#3#4#3#9#2#6#5#6#1#1#9#10#8#6#6#4#4#5#6#10#8#2#6#0#10#3#0#6#6#1#9#7#5#3#10#2#0#0#9#8#8#10#4#7#8#7#2#7#7#3#9#1#0#4#6#4;
152:result:=#10#1#1#5#3#10#1#9#2#8#5#3#5#0#3#3#5#9#5#4#3#1#5#2#0#4#2#3#7#6#1#7#4#8#8#2#5#0#3#2#0#10#7#7#8#2#8#0#0#1#3#2#8#10#0#1#4#9#6#1#6#7#3#2#7#2#1#6#3#6#10#10#1#3#9#6#9#4#1#5#0#2#5#1#4#1#6#1#7#4#4#7#8#9#9#8#3#9#9#1;
153:result:=#6#7#5#9#2#2#4#6#4#8#5#10#2#8#0#10#2#3#1#6#8#2#5#7#8#10#1#0#9#9#10#7#8#1#8#7#3#3#5#9#10#9#10#1#4#3#4#6#8#10#6#9#7#1#0#10#10#7#2#0#7#8#6#7#4#8#6#5#2#10#4#9#6#6#0#0#4#6#3#10#8#6#3#7#2#5#4#2#4#5#8#1#4#10#6#7#6#0#0#3;
154:result:=#2#2#10#5#6#10#1#6#8#2#0#8#3#2#7#6#6#3#10#4#1#8#0#7#5#10#1#3#1#3#3#9#10#4#2#3#4#6#9#1#5#2#0#8#6#0#10#0#4#1#7#8#5#6#0#2#6#5#6#10#8#8#6#5#6#7#10#1#10#2#0#1#4#3#3#6#2#9#9#8#1#0#6#2#4#1#3#8#2#1#0#0#9#4#4#2#0#8#9#3;
155:result:=#1#1#6#3#1#7#2#9#9#2#2#6#4#7#7#2#6#10#1#2#9#9#7#9#7#1#3#10#4#9#5#7#3#8#4#5#7#3#5#3#9#8#10#10#5#6#5#4#3#10#4#10#3#3#2#9#1#5#0#0#7#8#3#4#2#10#0#10#9#3#3#3#2#8#10#8#2#3#10#10#0#4#6#2#10#6#8#2#10#1#4#7#0#10#7#2#5#7#4#8;
156:result:=#5#0#2#5#10#5#5#10#9#5#4#7#5#8#9#9#6#7#7#2#7#2#5#9#3#3#10#2#5#7#2#6#6#7#0#2#5#8#9#9#3#0#4#6#8#1#0#7#9#7#10#10#5#0#4#1#9#4#1#0#3#5#0#0#10#7#0#10#4#5#6#9#10#7#3#3#10#5#5#7#3#7#8#6#5#5#3#8#5#4#3#9#9#4#8#0#5#4#1#10;
157:result:=#7#3#2#8#5#4#4#9#8#4#3#2#7#0#9#3#4#5#9#8#6#10#5#10#10#9#10#8#1#6#1#7#3#8#5#2#5#0#7#8#10#10#3#6#7#0#0#10#8#6#5#8#1#5#4#5#8#6#0#5#10#7#8#2#0#0#4#4#7#10#1#10#5#0#8#7#0#1#0#7#10#2#9#3#3#7#8#8#7#7#9#8#8#5#8#10#2#3#9#4;
158:result:=#5#0#8#7#9#4#7#1#4#7#4#3#0#8#10#4#3#1#1#7#6#7#0#2#6#8#3#10#2#5#0#10#9#8#4#0#5#9#7#2#5#4#4#9#8#3#7#10#3#8#1#6#2#2#8#8#5#3#2#3#8#5#3#5#3#1#6#0#3#5#0#0#2#10#8#0#10#8#0#3#4#2#0#2#0#6#9#7#4#0#5#2#9#8#0#0#8#9#0#7;
159:result:=#5#10#8#2#1#9#3#8#9#10#6#9#0#8#1#8#5#10#9#2#4#0#5#6#9#10#9#4#6#2#1#0#4#10#3#4#2#1#5#7#6#5#5#5#1#10#6#10#3#2#9#10#5#4#1#5#1#1#6#2#9#9#3#9#7#8#10#4#1#6#1#7#1#8#4#8#2#3#5#10#6#5#7#5#8#3#6#8#7#5#9#7#0#2#7#1#3#8#6#4;
160:result:=#9#0#3#2#1#1#10#10#2#7#8#3#6#1#7#9#3#9#3#4#3#0#10#7#1#3#5#4#4#8#5#7#0#8#5#0#0#6#0#2#9#5#1#0#9#9#9#2#2#6#6#1#6#3#9#9#7#6#8#9#4#1#0#7#6#7#8#6#0#1#7#3#10#9#5#8#3#8#0#9#5#7#5#9#9#1#10#5#8#2#3#9#1#1#8#0#4#0#4#5;
161:result:=#2#4#8#5#2#5#3#2#0#2#6#4#3#9#0#3#3#7#5#7#10#8#1#4#4#6#2#9#3#2#2#2#1#0#9#0#6#6#2#10#4#10#3#6#9#4#3#1#7#4#3#2#3#7#8#7#7#8#4#0#3#4#1#2#4#5#0#8#8#9#6#8#10#0#10#3#2#2#9#10#7#3#10#5#4#7#9#8#4#10#0#10#2#0#8#8#3#10#1#2;
162:result:=#9#9#6#10#7#8#7#8#7#9#6#5#8#2#3#6#3#2#9#7#2#1#4#2#10#8#10#2#9#4#6#7#3#3#5#3#8#10#4#4#3#1#9#1#0#9#4#5#7#3#2#4#4#2#5#4#5#10#0#10#9#9#3#0#5#0#3#0#6#6#8#6#3#9#4#6#5#9#3#6#8#5#1#10#0#9#10#5#9#5#7#1#10#10#3#10#9#10#1#8;
163:result:=#9#10#9#2#10#2#4#2#7#6#4#3#0#9#8#1#10#7#10#6#9#10#10#10#3#2#6#8#7#8#7#7#5#9#5#2#4#10#3#4#2#2#10#5#9#3#2#9#8#8#4#0#6#2#2#6#1#1#4#6#6#8#8#3#9#3#2#9#10#3#0#7#3#9#7#9#8#1#3#8#8#7#9#3#0#1#4#1#2#8#1#2#8#10#9#7#3#6#0#4;
164:result:=#9#5#8#1#10#3#1#7#10#1#10#8#1#1#5#2#2#8#8#6#3#3#3#0#0#5#8#2#7#3#7#5#4#7#4#2#9#2#2#1#3#8#9#5#8#2#0#6#2#1#9#10#8#4#7#2#5#7#6#10#10#7#6#10#9#3#9#1#6#1#10#0#9#1#6#8#3#2#1#7#0#2#8#3#7#10#9#8#10#9#9#2#4#9#8#6#5#8#6#0;
165:result:=#5#5#5#7#5#9#7#9#1#1#7#7#7#4#9#5#0#3#10#0#6#2#7#8#7#5#10#9#8#4#5#0#5#4#10#4#5#0#5#7#6#8#5#3#4#10#10#3#5#9#10#5#3#7#1#0#5#7#3#9#9#0#8#2#6#9#8#0#5#7#3#5#4#7#9#1#0#1#1#6#6#9#1#1#3#4#2#8#0#7#9#5#2#1#1#8#2#7#6#1;
166:result:=#10#10#4#10#5#6#10#2#10#5#1#2#5#1#8#5#4#4#7#0#6#1#1#3#2#5#6#5#9#6#0#10#6#9#7#3#1#5#3#8#2#5#9#8#1#7#4#10#10#10#5#5#8#0#4#4#2#10#5#5#6#0#10#6#7#9#1#2#9#9#3#10#9#8#7#0#4#0#8#8#7#3#1#4#5#6#6#10#7#3#7#6#2#4#2#7#2#1#6#6;
167:result:=#5#3#9#4#2#10#3#6#7#8#6#7#1#0#2#1#10#6#1#5#10#6#3#7#6#7#0#7#5#3#9#1#9#9#4#10#2#8#10#10#3#1#8#1#10#4#0#8#5#9#1#5#4#9#0#5#9#0#6#6#3#6#5#7#5#0#4#5#3#1#1#9#4#3#3#3#7#0#1#9#8#7#5#8#6#2#9#9#5#1#2#2#2#9#0#8#8#4#5#2;
168:result:=#6#9#7#6#8#1#5#2#2#5#6#1#9#8#6#4#0#8#0#5#2#7#6#1#10#6#9#3#6#0#3#6#2#0#0#7#9#6#8#4#9#6#4#1#9#10#4#7#0#10#4#0#9#0#3#6#0#6#3#6#1#2#10#10#6#7#8#5#2#2#4#2#6#9#8#5#2#5#8#9#2#0#1#1#9#7#2#3#4#6#6#4#7#7#1#2#8#10#0#4;
169:result:=#8#4#2#6#10#5#4#8#8#0#0#7#0#4#7#3#6#5#1#1#4#6#6#0#8#5#4#4#1#0#4#7#5#5#9#3#8#0#2#4#5#6#1#10#1#7#0#2#9#5#2#2#1#4#5#2#5#10#8#7#0#2#7#7#1#6#3#7#6#9#7#7#7#2#7#7#9#4#5#2#6#6#8#8#0#4#1#10#9#7#9#3#6#0#0#5#9#7#6#0;
170:result:=#3#8#6#3#10#7#10#0#10#2#9#8#2#2#1#2#1#2#1#0#3#7#1#0#3#7#3#3#0#4#9#0#6#1#1#2#9#8#10#7#9#9#0#3#2#9#7#3#9#5#1#5#6#3#5#6#4#10#4#2#6#4#5#3#4#10#9#1#8#8#1#0#2#2#7#0#5#8#2#10#4#2#9#8#7#2#6#10#2#3#9#3#1#2#10#10#2#9#9#10;
171:result:=#8#2#8#0#7#1#7#4#10#0#6#0#0#0#5#9#7#3#7#3#2#4#4#7#2#9#8#0#1#0#3#0#7#0#6#8#8#6#2#7#3#6#5#1#1#0#5#1#1#0#8#1#7#1#3#2#1#6#9#1#7#0#1#5#2#4#1#5#2#7#10#9#8#2#2#5#0#0#10#6#9#9#2#9#0#3#2#9#8#3#0#7#0#3#3#4#6#9#6#5;
172:result:=#7#5#0#3#5#3#9#0#0#4#0#5#8#9#3#5#7#8#1#5#10#7#3#6#8#7#7#9#1#3#6#6#7#3#9#0#5#4#8#4#6#0#8#6#2#3#9#10#0#7#4#10#2#2#9#6#10#6#8#9#6#0#6#7#0#4#3#0#4#7#5#10#9#5#10#1#7#8#3#5#6#10#8#0#9#4#10#3#3#1#2#3#9#5#7#7#4#0#5#5;
173:result:=#6#2#8#8#5#8#3#9#0#3#9#5#8#8#5#4#10#4#2#8#9#9#5#3#1#5#4#10#6#9#1#2#3#10#1#5#7#5#6#10#4#0#2#6#0#5#1#9#3#3#0#9#3#1#10#4#10#3#2#9#1#2#2#2#6#4#7#8#0#10#3#9#0#7#8#5#10#4#6#10#6#10#3#2#9#5#8#8#9#4#0#3#10#9#1#3#10#3#4#6;
174:result:=#8#10#9#7#6#1#5#4#9#8#2#4#1#0#9#10#2#4#1#9#0#6#4#10#7#3#7#3#1#9#5#9#6#10#6#10#10#6#0#5#4#2#8#7#10#1#7#1#7#8#0#8#6#2#6#10#2#5#0#0#3#4#4#2#8#8#7#6#2#8#9#1#1#1#3#2#1#6#10#4#8#1#4#8#2#6#5#6#2#1#8#2#4#10#4#10#10#1#3#0;
175:result:=#8#5#8#0#5#3#5#6#2#5#10#1#9#6#0#8#6#6#6#3#7#1#9#6#4#2#3#9#4#10#5#2#4#0#5#0#1#4#1#2#8#10#1#4#7#8#7#2#8#4#1#10#2#6#6#7#7#10#8#9#10#1#10#3#0#10#1#1#7#1#5#3#8#8#1#10#5#9#9#8#0#6#10#2#9#5#9#1#7#7#7#1#8#9#7#0#8#1#6#5;
176:result:=#6#5#3#4#3#7#6#4#1#9#0#8#1#8#3#3#3#0#6#4#5#8#2#9#8#0#2#9#1#9#5#8#6#2#7#6#1#0#4#8#9#10#6#9#8#3#4#5#5#5#5#2#10#3#4#8#2#0#1#2#9#6#9#4#2#6#0#1#7#4#6#0#5#2#8#2#1#5#0#3#3#1#3#8#7#3#6#5#10#9#9#4#0#3#5#4#2#5#3#2;
177:result:=#1#7#3#9#4#2#7#4#6#2#4#4#7#2#5#6#0#6#3#0#2#2#9#9#8#2#10#8#2#1#6#0#7#0#8#3#4#0#5#6#8#6#7#7#5#4#7#0#1#8#1#4#0#1#2#7#7#9#1#8#9#9#8#7#10#1#4#7#9#5#0#1#7#0#4#4#7#1#0#4#0#4#9#2#7#5#0#3#6#0#10#9#9#9#6#0#7#7#9#4;
178:result:=#7#7#0#0#4#4#9#7#2#0#9#10#4#7#2#7#1#5#5#8#5#10#7#7#10#8#7#1#10#2#8#0#3#7#4#8#3#7#0#1#0#9#1#10#5#9#4#10#7#1#5#4#8#2#2#1#8#9#9#0#0#10#0#7#6#8#6#1#3#5#4#5#1#3#2#4#8#8#5#6#2#10#6#0#10#6#3#2#1#8#1#6#8#10#6#0#10#1#2#5;
179:result:=#3#4#3#6#5#3#6#6#1#3#9#0#4#9#7#10#0#3#2#3#8#1#3#6#7#3#6#8#3#2#5#7#5#7#6#7#1#7#3#5#2#0#9#4#10#6#3#0#0#9#10#9#5#8#3#9#1#7#2#0#2#2#8#8#4#7#6#0#0#6#9#2#7#4#1#6#5#3#9#3#3#0#10#6#0#3#5#2#4#7#0#7#6#0#2#6#9#0#6#2;
180:result:=#4#10#0#7#7#7#4#1#10#9#8#5#7#1#4#3#1#8#6#2#3#9#6#4#10#9#10#1#9#0#3#9#1#1#1#9#4#10#6#1#8#6#2#8#10#6#2#1#8#0#8#7#6#4#4#6#3#7#8#1#7#10#1#0#3#2#7#7#6#1#6#6#0#5#5#6#3#1#9#3#6#2#7#1#6#4#5#1#1#10#6#5#10#6#1#9#0#6#7#9;
181:result:=#8#0#7#0#2#0#4#0#2#10#4#4#6#3#1#1#6#8#7#9#6#7#1#8#5#10#0#6#5#6#4#2#3#2#0#0#5#4#10#6#4#6#8#1#6#6#5#3#5#2#1#2#0#7#0#10#4#5#1#9#8#9#9#6#4#1#2#4#2#1#0#1#10#9#2#3#4#3#5#10#1#4#1#2#7#0#8#4#0#9#5#4#10#8#0#7#8#9#7#10;
182:result:=#7#7#3#0#10#8#8#0#0#8#2#7#0#8#0#9#1#6#7#9#1#2#6#1#3#0#6#0#2#7#2#1#4#9#3#2#10#10#2#7#3#5#3#8#3#4#4#6#4#8#1#9#4#8#8#2#9#4#3#3#0#3#7#1#4#10#6#8#9#0#9#8#2#9#4#6#2#4#10#7#1#5#3#10#1#3#9#1#8#7#7#0#4#6#10#8#4#0#4#7;
183:result:=#6#2#7#0#7#6#0#3#3#7#4#1#5#3#2#5#8#10#5#3#4#7#5#9#2#0#3#6#6#7#1#10#5#10#2#2#6#2#7#3#4#0#7#5#0#3#9#0#9#10#8#6#10#3#7#0#3#0#10#8#5#1#10#2#1#0#8#7#10#5#6#8#7#9#0#2#1#2#0#8#6#0#6#9#5#7#8#1#0#8#3#4#3#0#8#7#5#6#2#6;
184:result:=#8#3#0#9#2#7#6#3#2#3#6#3#0#1#3#4#4#9#8#5#8#3#10#1#8#7#6#9#5#9#0#4#1#6#10#5#0#6#8#6#6#4#0#5#8#8#1#5#9#0#10#5#3#5#6#3#0#10#3#7#6#9#5#0#9#2#6#9#6#6#1#5#0#10#10#0#5#5#8#8#2#5#10#2#5#10#0#9#10#4#6#7#5#5#4#4#2#2#5#0;
185:result:=#4#7#2#2#7#10#7#7#2#3#5#0#8#5#9#1#10#4#2#8#6#0#10#8#0#2#1#5#0#8#8#9#5#4#9#6#2#0#6#9#3#6#5#2#8#6#2#2#9#10#4#4#7#5#10#2#3#8#8#8#6#1#9#2#0#3#1#1#1#3#9#5#3#10#3#6#6#1#7#8#3#10#8#10#7#10#0#10#10#3#1#7#8#5#4#0#5#8#10#3;
186:result:=#10#5#7#8#0#4#3#5#5#8#7#8#1#4#7#3#2#2#5#1#5#2#6#0#8#2#7#2#3#10#6#10#0#0#8#4#5#2#5#5#10#1#7#4#10#0#7#0#7#6#4#5#0#1#0#8#8#9#3#4#10#9#4#8#3#7#2#8#1#1#3#4#2#0#9#5#1#6#5#4#9#0#9#3#7#1#3#0#8#8#1#3#2#3#10#1#10#10#7#3;
187:result:=#5#0#0#2#8#1#6#0#7#5#10#5#10#1#8#1#0#7#5#2#10#7#7#7#9#10#9#2#9#10#9#3#6#2#6#2#10#4#7#0#6#0#10#10#10#9#0#0#9#4#8#8#5#2#6#1#5#2#9#8#3#3#2#1#4#4#4#8#2#9#2#2#5#5#7#1#2#10#4#5#1#3#5#6#6#2#0#2#3#5#9#2#3#2#2#10#5#4#6#4;
188:result:=#10#4#10#5#9#8#4#1#5#7#4#7#2#10#0#5#4#4#6#5#4#9#0#10#1#4#2#2#5#7#1#1#7#3#8#6#8#7#4#9#3#9#7#9#6#9#1#8#1#7#0#5#7#4#6#7#7#3#3#7#3#7#2#8#8#7#0#2#2#9#2#7#6#9#5#10#2#0#3#8#0#0#9#6#6#8#7#1#4#8#8#9#1#4#1#6#8#8#6#0;
189:result:=#10#8#6#10#6#8#2#3#0#10#9#0#3#7#7#1#5#6#0#5#2#5#4#6#6#1#4#0#2#0#5#7#4#6#2#5#4#10#1#8#5#3#3#3#2#6#6#6#6#4#0#10#6#5#2#0#2#4#6#8#5#9#3#7#9#6#2#9#3#8#1#5#2#10#3#6#1#0#0#2#8#4#7#1#5#4#10#10#2#2#4#7#2#7#10#6#3#6#5#5;
190:result:=#5#8#2#3#0#4#8#1#1#3#0#2#5#8#8#4#3#5#2#6#9#8#7#6#10#2#8#10#6#5#4#4#3#3#3#3#2#1#5#2#7#9#7#10#4#5#4#10#1#6#6#5#5#7#7#10#2#0#5#1#2#8#3#2#9#3#1#1#1#3#8#5#1#0#7#4#6#1#7#6#5#2#6#9#0#8#2#0#6#9#1#5#5#9#7#5#5#1#3#8;
191:result:=#4#1#5#8#6#5#2#7#10#5#0#9#2#2#4#1#6#4#10#6#7#7#3#5#4#1#1#3#3#9#5#9#1#3#5#10#7#8#6#0#2#9#9#0#1#3#4#3#5#1#0#4#0#2#9#3#10#6#5#4#10#1#9#2#4#9#9#4#5#5#6#3#10#5#8#10#0#5#6#9#3#7#3#6#3#6#0#2#6#1#7#4#4#1#9#3#8#0#7#3;
192:result:=#7#6#6#6#2#5#6#3#6#6#0#7#10#5#1#4#1#8#5#4#9#5#9#6#2#6#8#1#10#5#2#4#4#8#1#7#1#8#1#4#10#9#6#1#5#10#9#2#1#9#3#1#8#3#1#9#5#8#5#9#10#1#10#5#1#0#1#6#5#0#5#3#7#1#1#0#4#0#0#8#1#2#10#4#2#9#9#9#9#8#2#4#1#3#5#6#4#4#0#1;
193:result:=#9#10#9#9#9#0#2#6#2#9#1#9#6#10#2#2#10#5#6#9#5#10#6#9#0#6#4#9#6#9#7#10#4#8#4#4#1#5#4#6#0#0#2#5#3#6#3#7#4#2#10#0#10#4#6#0#4#10#9#8#1#7#2#10#3#8#8#0#6#1#3#1#0#4#10#1#0#5#10#8#7#10#8#1#5#9#8#10#3#8#5#10#5#10#2#8#3#10#5#8;
194:result:=#0#1#1#9#5#0#6#1#5#2#0#4#9#2#8#6#7#6#6#4#1#4#8#1#2#1#6#0#0#2#2#1#6#3#2#9#4#7#2#2#4#3#0#4#6#8#2#5#8#2#7#2#5#0#6#3#8#6#7#4#10#3#10#3#9#10#6#6#5#0#3#1#5#6#7#6#5#10#2#8#4#2#1#0#3#8#8#10#7#8#2#3#1#7#6#3#2#0#3#0;
195:result:=#2#2#2#1#6#7#2#8#7#9#1#0#8#7#4#8#6#3#6#2#4#2#4#4#4#8#4#8#2#0#3#8#0#9#7#3#5#5#1#7#2#5#5#5#8#0#4#8#9#5#0#10#7#5#7#10#5#7#6#1#2#1#4#5#8#8#4#4#10#10#5#0#10#8#8#2#5#4#2#10#9#5#6#9#9#5#10#6#8#4#8#4#10#9#3#7#4#0#4#9;
196:result:=#9#0#6#4#4#4#9#8#9#5#8#7#3#0#5#0#7#8#6#5#6#10#3#4#7#6#5#0#3#2#6#7#10#8#2#4#10#9#6#5#10#6#8#7#6#10#8#7#7#4#2#1#7#8#10#7#1#10#5#8#1#0#3#10#2#4#4#6#7#4#0#6#7#6#10#0#1#4#8#3#4#2#10#6#10#5#8#3#8#6#7#7#6#7#7#10#5#0#9#4;
197:result:=#4#3#3#9#4#10#8#7#6#0#8#6#7#2#2#3#8#5#5#1#3#3#3#9#9#7#4#3#6#0#2#3#7#5#9#7#9#6#8#5#0#7#4#2#10#5#10#3#5#8#5#10#0#7#5#10#4#8#10#5#4#9#0#8#0#9#1#4#4#1#2#2#9#7#3#4#10#3#3#8#0#4#10#9#10#9#4#10#8#0#2#7#0#10#10#1#6#10#7#8;
198:result:=#10#8#5#8#3#3#4#4#3#10#10#8#3#2#2#10#2#6#8#4#10#0#10#8#2#8#10#7#2#2#1#4#9#3#5#7#5#8#5#6#9#5#10#3#8#8#10#10#10#1#5#2#0#5#3#1#10#10#6#7#6#1#6#7#10#10#4#10#2#10#10#7#1#7#8#4#8#7#10#2#4#3#3#9#6#6#3#3#3#2#7#4#2#7#0#6#7#7#0#10;
199:result:=#10#6#7#6#10#8#1#0#3#0#9#8#4#6#8#2#2#6#5#0#1#4#6#9#3#9#5#8#0#0#3#4#3#4#4#3#0#3#2#1#4#0#8#6#6#0#5#6#10#4#1#2#4#3#10#3#9#4#4#8#3#10#8#8#0#7#4#1#1#1#8#4#6#8#8#1#9#3#7#8#0#1#10#10#3#9#7#8#5#0#2#5#6#1#0#7#3#9#5#6;
200:result:=#0#9#7#8#2#8#2#6#6#4#7#9#10#1#5#7#7#0#3#3#10#1#4#10#3#8#6#4#6#8#4#3#5#2#2#9#5#9#5#9#8#2#6#8#5#2#0#8#7#0#6#10#2#10#9#7#4#8#8#5#5#7#2#1#4#2#3#5#2#4#0#6#9#0#6#4#8#4#1#1#4#10#9#5#6#6#3#7#3#3#8#2#9#10#8#3#4#8#1#4;
201:result:=#1#6#7#1#0#8#5#5#10#1#3#6#8#10#6#9#9#0#8#1#3#5#9#1#0#5#6#10#4#9#1#10#8#7#1#5#7#10#3#10#7#2#6#2#10#6#8#0#4#0#5#5#7#9#0#0#4#4#8#7#4#7#2#10#2#4#5#4#8#7#6#4#8#5#7#6#1#0#10#6#8#1#8#2#5#4#1#7#6#1#1#1#0#3#9#8#5#6#8#3;
202:result:=#0#5#10#8#4#6#10#0#2#9#8#4#10#7#10#2#4#10#10#8#7#7#0#2#2#1#7#10#3#8#2#3#4#6#0#4#9#1#3#5#6#6#3#2#9#0#6#4#5#6#3#8#10#10#6#1#0#4#8#9#2#4#3#3#6#10#0#1#8#2#4#7#3#10#3#6#1#2#5#0#3#3#8#5#9#4#3#10#2#6#7#0#5#8#6#9#6#9#5#4;
203:result:=#1#1#5#0#5#6#7#1#1#1#5#4#10#6#7#2#2#0#8#4#8#2#3#6#1#9#6#1#0#2#4#8#0#6#5#7#3#2#7#5#1#5#6#3#0#2#6#8#0#9#7#1#5#9#9#10#10#6#2#1#1#7#9#6#10#7#9#3#1#9#0#1#10#9#8#2#8#9#7#2#7#2#9#0#6#1#1#3#6#6#4#5#4#3#9#5#5#8#9#7;
204:result:=#10#4#10#4#4#6#6#5#7#8#0#2#7#0#5#3#8#9#0#9#2#5#3#6#1#8#2#6#8#5#3#8#1#9#9#9#9#10#2#1#1#6#9#10#10#4#4#1#2#8#2#8#0#7#1#5#10#4#7#4#9#9#6#7#9#4#7#10#6#9#3#7#7#6#10#9#6#6#1#1#9#8#3#1#10#2#2#10#0#0#9#0#3#3#10#9#5#0#8#8;
205:result:=#6#3#6#5#5#8#1#10#9#6#10#0#8#9#8#10#6#4#1#4#1#0#3#10#9#5#10#9#1#2#7#8#6#10#9#8#4#5#2#8#6#3#6#8#9#1#0#3#2#8#5#0#4#4#5#0#7#3#0#5#2#2#6#0#2#3#0#2#6#10#8#1#5#2#5#4#3#6#1#0#1#2#2#8#7#9#6#7#9#1#3#7#0#4#9#10#7#7#4#3;
206:result:=#8#6#3#4#9#1#9#3#1#5#7#2#1#2#0#1#2#5#9#8#0#7#4#7#10#3#5#5#0#3#0#2#3#8#1#5#1#10#2#1#4#2#2#6#0#1#2#5#7#0#4#5#0#10#6#9#1#5#6#9#1#1#5#8#9#1#6#6#10#3#1#5#2#0#0#0#3#0#9#7#4#8#1#8#0#1#8#8#1#7#9#10#6#0#2#7#9#1#9#4;
207:result:=#4#7#6#4#7#4#8#3#1#0#4#4#3#6#10#7#2#10#6#3#2#5#3#10#8#7#10#1#10#7#10#1#6#3#1#10#0#9#3#0#4#9#2#2#6#1#6#8#3#4#2#4#8#9#3#6#7#6#5#1#6#2#9#4#0#6#1#5#2#10#0#0#0#2#2#0#0#2#8#3#1#7#7#3#2#6#8#10#4#10#8#4#6#10#5#3#6#0#6#7;
208:result:=#6#4#7#10#4#6#10#8#2#7#10#9#10#6#2#3#10#6#8#9#4#0#10#3#3#6#4#3#2#9#10#2#1#10#5#2#10#3#4#8#8#6#6#3#0#9#2#2#5#0#10#0#2#8#2#10#6#2#3#5#3#4#5#0#2#4#9#4#6#5#6#4#1#9#10#1#2#10#4#7#2#10#3#3#10#10#0#2#9#8#8#2#3#3#1#4#10#7#8#1;
209:result:=#2#0#9#5#3#7#3#4#3#4#1#9#6#6#1#4#7#2#9#5#0#6#1#4#0#7#3#5#6#9#6#7#4#8#4#7#7#2#8#2#6#2#5#9#0#1#3#10#10#1#3#0#5#8#7#4#8#9#1#1#3#9#10#5#5#4#9#3#0#8#3#7#5#5#3#0#1#0#9#7#4#8#3#8#2#8#7#10#7#4#4#9#5#10#10#0#6#3#8#2;
210:result:=#10#6#8#9#9#0#8#2#5#8#4#10#1#4#9#3#7#8#0#4#4#5#6#8#3#3#0#5#6#8#9#4#4#3#9#6#6#6#10#1#4#7#10#5#3#9#9#10#8#4#9#4#10#4#8#1#0#1#2#0#1#10#1#0#8#2#4#0#10#6#5#9#6#5#6#7#6#0#6#8#10#1#0#0#4#7#5#1#0#10#6#1#7#7#5#3#1#1#9#9;
211:result:=#6#4#6#5#5#9#2#10#7#5#5#4#4#7#2#0#2#5#2#5#6#2#0#7#3#9#3#1#10#4#7#0#3#1#2#7#8#5#9#8#7#6#1#4#4#6#0#5#1#0#10#10#0#3#3#10#0#10#9#10#3#1#2#1#0#10#10#9#0#2#0#4#8#7#10#8#1#10#0#8#10#0#3#6#8#0#1#10#5#4#6#10#7#8#7#2#3#3#0#0;
212:result:=#8#10#7#1#8#8#10#4#1#1#7#10#10#5#5#5#0#10#1#7#2#5#0#2#0#6#1#8#6#2#1#2#8#6#10#3#4#9#10#9#5#6#3#4#7#7#5#1#3#9#7#1#5#3#1#3#1#2#7#5#8#10#9#6#5#3#6#10#9#5#0#3#7#10#0#0#9#1#7#0#10#6#2#3#3#7#6#6#0#0#1#10#0#9#2#7#7#2#7#4;
213:result:=#4#5#4#8#9#5#10#1#6#10#5#1#4#1#10#10#3#5#5#0#2#9#3#9#7#0#1#1#0#6#6#7#9#0#5#9#6#3#0#5#10#3#6#3#0#4#0#0#1#1#1#5#9#1#9#5#5#5#8#8#1#6#2#9#10#6#8#10#0#8#3#4#7#10#5#9#4#6#5#2#1#0#7#4#6#10#4#5#3#10#4#7#8#6#7#10#0#10#8#0;
214:result:=#9#0#3#5#5#8#2#1#8#8#3#3#3#5#7#8#5#10#4#0#4#0#6#2#6#1#8#9#5#1#4#10#2#8#9#10#5#0#7#8#8#2#1#10#5#5#7#7#4#3#1#9#2#2#7#7#4#7#4#7#1#8#5#0#7#0#4#3#0#3#1#7#9#2#10#9#2#10#4#5#4#7#9#10#4#9#6#9#9#9#10#0#7#5#1#6#6#9#4#7;
215:result:=#8#6#7#9#5#1#10#7#0#5#8#6#1#6#8#9#1#8#10#7#8#4#2#10#7#7#5#4#5#5#2#5#4#1#10#4#2#6#0#8#10#7#8#9#9#10#9#5#4#1#10#0#10#10#4#0#5#4#10#0#8#10#0#8#3#4#3#9#5#10#3#8#9#9#6#1#3#1#10#4#10#6#6#4#2#5#1#2#10#8#0#9#0#9#10#9#8#5#6#9;
216:result:=#0#10#2#1#4#2#6#6#7#3#0#4#6#8#3#2#2#9#3#10#0#6#2#7#6#1#0#7#5#6#6#2#3#3#8#2#0#9#0#4#9#1#6#8#2#10#3#0#10#10#2#1#1#6#4#3#1#7#0#5#4#2#3#0#10#7#1#4#0#5#7#3#10#9#3#3#2#7#4#10#1#0#8#1#7#2#4#0#0#8#9#0#7#3#8#4#5#1#0#0;
217:result:=#2#9#1#9#9#3#7#4#1#6#10#10#7#1#9#7#8#9#3#0#0#1#1#7#9#0#5#10#6#4#6#4#5#4#3#2#9#9#0#6#10#10#0#3#4#6#3#0#2#6#3#1#5#2#4#10#6#0#5#2#8#6#3#7#1#5#2#2#8#5#6#1#8#2#5#6#3#6#8#9#7#5#7#7#2#1#1#10#10#1#8#1#9#9#10#0#5#3#10#5;
218:result:=#9#8#6#5#8#1#7#5#2#5#7#5#6#3#10#9#5#5#7#4#2#6#6#6#3#3#9#7#6#9#9#3#1#8#10#9#9#9#5#9#0#10#7#2#10#8#7#8#2#3#2#2#9#10#1#0#0#2#6#6#3#8#3#8#8#3#8#8#8#10#6#9#8#3#10#5#8#3#6#8#9#5#9#10#7#0#0#10#5#10#2#9#0#9#10#4#8#6#7#0;
219:result:=#9#0#4#9#2#3#9#4#8#2#5#3#1#3#8#6#8#0#7#8#6#9#1#4#2#5#3#8#6#6#4#1#4#2#8#3#6#6#3#3#4#7#7#4#6#6#7#3#5#5#1#6#9#4#2#3#9#1#5#9#10#6#7#10#1#0#2#10#6#0#7#3#9#6#0#7#1#10#4#1#4#3#10#4#2#2#7#4#8#7#2#6#5#7#10#8#1#3#10#7;
220:result:=#4#3#4#6#0#7#0#6#1#4#8#4#3#6#4#5#3#10#0#5#7#1#9#4#0#5#5#4#6#10#10#6#10#5#6#1#8#7#0#3#6#6#2#7#5#10#5#3#9#2#3#3#10#4#5#5#0#2#7#1#0#5#6#1#3#6#8#10#6#10#8#5#10#7#2#3#1#0#8#6#8#10#9#9#7#0#7#9#5#6#7#5#2#8#0#7#6#6#8#1;
221:result:=#8#9#8#9#2#5#1#10#0#2#4#1#9#0#5#6#8#4#9#1#10#9#5#8#1#7#1#1#7#8#6#6#3#5#0#5#9#5#3#6#1#10#2#0#8#3#3#3#10#8#7#6#3#1#0#5#2#7#1#3#8#3#0#1#0#6#5#4#10#5#8#10#6#10#8#8#5#9#10#6#7#3#1#2#2#7#2#6#9#6#2#5#9#6#1#7#5#1#4#1;
222:result:=#10#0#6#10#9#4#0#6#9#8#2#10#0#10#0#9#7#8#7#7#1#4#10#9#1#10#0#10#1#7#10#0#10#4#7#0#6#9#10#3#7#3#6#0#2#3#7#8#1#9#1#8#10#6#9#0#8#9#7#8#10#5#7#3#5#0#9#2#8#0#9#9#9#8#7#1#8#0#1#3#8#4#10#0#7#8#8#9#8#10#2#8#9#10#0#5#7#4#9#9;
223:result:=#8#1#8#2#2#3#6#9#2#6#9#2#2#10#7#6#0#0#4#1#3#9#2#7#5#0#9#1#0#3#1#7#0#6#3#9#9#6#9#5#9#1#4#0#4#0#5#5#10#8#9#0#7#2#6#0#2#7#9#3#8#0#3#0#4#1#0#1#5#10#5#4#9#8#5#10#1#7#7#7#6#7#2#0#9#9#8#4#3#7#1#10#5#8#7#8#9#0#7#9;
224:result:=#1#10#6#8#9#3#9#0#4#3#1#3#2#8#9#7#2#7#2#3#7#4#9#6#3#10#6#9#8#6#10#10#8#4#9#10#4#6#4#10#10#10#0#10#7#4#1#7#10#6#4#2#10#4#2#4#9#8#1#1#6#7#1#5#4#10#4#1#10#0#4#10#9#5#0#9#10#3#7#10#2#6#6#6#6#9#6#4#3#0#3#5#3#3#10#8#10#4#7#5;
225:result:=#6#1#10#0#9#2#10#6#1#4#0#8#3#10#7#8#9#7#7#3#4#10#1#7#10#10#1#4#5#8#6#10#1#10#5#2#1#8#4#1#9#2#4#5#5#6#1#0#9#10#0#4#3#4#4#6#10#4#8#0#10#9#2#8#2#6#5#8#4#8#10#10#9#3#3#8#0#10#5#8#1#1#7#9#8#0#9#7#10#8#7#7#4#8#3#8#2#10#7#9;
226:result:=#9#0#10#10#1#6#3#2#2#4#9#0#4#10#4#3#0#7#0#9#8#3#3#3#9#7#9#0#4#6#8#5#3#4#8#6#10#6#4#9#4#2#7#1#10#6#4#3#8#0#5#5#7#10#8#5#5#7#3#5#5#1#8#1#10#9#5#7#9#8#1#0#8#0#9#2#7#3#10#1#3#4#7#5#1#7#8#7#3#2#3#9#4#10#8#0#6#1#3#4;
227:result:=#7#3#10#0#8#3#7#3#6#0#4#4#4#4#7#10#8#10#7#5#4#6#2#1#5#1#9#3#5#7#1#7#6#3#7#4#9#8#6#6#2#8#3#10#3#6#9#7#6#4#5#0#10#2#6#10#10#7#6#6#4#2#9#6#9#6#0#0#1#0#8#9#9#0#5#10#10#7#1#9#8#1#9#4#0#6#2#0#9#4#3#2#9#4#2#9#1#0#1#9;
228:result:=#2#1#6#1#7#3#6#4#6#3#5#1#9#5#2#10#8#4#7#2#9#0#9#3#5#1#10#5#3#0#10#1#5#8#10#4#6#0#6#10#1#5#9#5#7#3#3#2#3#2#7#10#6#10#8#7#7#2#4#1#5#0#9#2#2#9#9#4#2#2#7#1#8#0#9#5#1#5#9#10#10#9#2#9#3#6#1#8#3#7#1#7#2#1#0#8#0#7#0#0;
229:result:=#0#10#1#10#6#1#2#2#7#5#10#1#8#2#0#6#0#0#10#9#9#4#5#8#10#6#3#6#2#1#4#0#1#10#2#1#8#5#3#10#8#10#6#0#0#0#9#5#5#1#4#9#0#8#6#1#9#0#1#8#3#5#3#1#5#9#5#4#4#8#7#7#2#10#1#9#9#4#1#0#5#9#10#2#5#7#6#3#0#3#6#3#8#0#6#10#10#1#7#8;
230:result:=#9#7#6#8#2#8#9#2#6#4#5#7#2#8#10#5#10#7#4#10#10#8#2#9#1#1#4#1#8#1#5#2#0#10#1#0#1#1#4#0#5#1#1#7#9#2#1#5#10#10#10#4#4#0#6#10#9#1#2#2#4#9#10#4#3#6#5#6#5#1#3#0#8#8#4#4#2#7#2#0#4#10#0#4#4#9#6#5#6#8#10#9#7#4#2#6#9#5#5#2;
231:result:=#2#10#6#7#8#8#2#1#10#0#1#5#9#1#3#1#2#8#9#4#7#3#0#4#6#4#3#9#0#9#2#1#4#3#10#1#7#4#10#0#6#4#10#0#2#3#3#2#3#0#7#10#8#7#0#3#5#5#8#8#8#6#2#9#7#2#7#0#10#0#1#2#2#5#8#5#1#8#5#8#6#9#9#6#5#6#1#10#9#0#1#10#8#0#1#5#6#0#9#2;
232:result:=#8#4#9#9#8#9#10#4#4#7#2#3#1#2#1#0#4#8#9#8#6#4#9#5#9#3#7#6#0#4#0#7#7#0#6#0#10#10#0#9#8#5#6#9#1#9#6#0#1#1#0#10#6#7#10#1#8#0#0#0#3#2#5#7#9#6#0#8#3#10#6#10#2#3#9#8#4#6#1#6#2#7#10#9#6#7#2#5#5#4#7#3#10#8#2#4#8#9#6#10;
233:result:=#10#0#4#3#3#0#10#10#7#7#1#1#4#5#3#5#8#2#8#8#5#2#8#2#7#9#6#7#9#7#8#6#0#1#2#2#1#9#9#9#0#6#8#10#2#7#1#2#5#9#8#10#0#7#3#2#4#3#10#2#4#10#6#6#3#9#3#7#3#6#2#3#0#3#9#9#4#5#9#0#4#10#7#7#7#8#4#0#6#5#0#0#10#7#4#7#2#8#7#6;
234:result:=#10#9#8#4#2#10#7#6#7#1#3#0#3#8#9#2#5#0#9#8#7#10#4#3#9#0#0#7#0#3#7#3#7#6#1#10#7#1#2#2#7#1#7#1#8#3#0#7#1#6#5#3#4#7#0#5#7#1#8#4#0#8#8#10#6#4#7#1#4#7#4#0#1#8#8#5#7#5#0#9#8#10#10#7#0#9#8#2#8#2#10#4#9#0#6#4#4#6#9#6;
235:result:=#10#7#3#6#8#7#4#9#3#0#7#2#1#4#7#6#8#3#10#4#7#5#6#5#1#1#9#3#3#8#8#2#0#8#1#4#3#4#10#1#2#5#0#9#3#9#1#10#3#8#7#9#9#5#1#1#3#6#4#8#10#4#7#8#7#8#2#5#6#7#4#2#10#1#3#7#0#6#8#2#4#5#5#10#10#7#2#10#4#1#3#10#7#4#6#1#2#9#10#9;
236:result:=#4#2#8#8#8#2#9#2#6#7#7#6#4#1#9#0#4#5#1#4#4#10#7#4#0#3#3#7#10#5#1#8#4#10#7#7#7#8#1#8#7#5#0#2#5#7#7#9#8#7#1#10#0#3#8#5#3#1#8#3#10#6#4#8#5#7#1#4#5#6#8#3#5#3#8#1#5#2#5#1#6#9#3#0#5#2#1#3#4#5#6#4#0#2#9#6#5#4#4#9;
237:result:=#8#4#6#6#8#9#9#6#3#5#5#0#5#9#10#0#2#5#4#7#4#8#4#8#6#10#3#0#2#3#3#4#9#8#4#8#10#2#10#3#1#2#8#7#0#6#7#2#0#9#0#0#2#8#6#7#3#5#2#2#6#5#10#7#9#10#2#2#8#5#9#6#4#8#6#6#10#9#6#10#7#8#2#6#0#8#6#7#10#0#6#4#4#1#9#2#6#0#4#5;
238:result:=#4#10#0#0#10#6#2#4#7#9#2#3#7#6#7#1#9#9#6#10#6#0#2#2#6#6#9#4#7#1#0#2#9#7#0#9#7#7#5#0#0#5#3#6#2#3#8#5#9#5#9#2#8#3#5#2#0#2#4#7#5#0#8#6#4#2#0#5#10#1#8#4#6#1#2#8#4#1#6#7#9#9#3#5#10#0#3#4#6#5#1#3#2#4#2#4#10#8#4#1;
239:result:=#1#6#1#9#10#9#5#1#10#8#7#10#4#7#10#2#2#6#5#9#3#10#0#8#9#6#10#3#8#1#3#1#2#9#4#8#10#1#3#6#5#9#7#8#3#3#5#4#7#8#2#10#0#2#8#1#10#0#10#7#8#5#6#5#2#1#8#10#2#3#10#1#3#9#0#8#9#4#8#5#8#8#3#1#9#0#1#8#0#9#3#4#4#10#2#6#3#0#4#2;
240:result:=#6#9#2#8#5#1#9#9#1#7#3#2#1#9#6#1#6#1#2#8#2#10#1#3#7#9#0#3#3#3#9#6#6#3#5#4#9#7#0#10#4#10#7#1#10#10#0#9#4#4#10#3#7#1#7#7#9#3#8#9#10#1#4#4#1#5#1#8#0#6#7#6#8#9#1#8#2#1#7#5#2#7#2#4#10#0#5#7#10#10#9#1#4#0#10#1#10#9#3#7;
241:result:=#4#5#0#10#6#7#0#5#7#7#9#3#0#1#4#0#7#0#1#2#5#10#9#1#0#10#1#4#9#5#3#0#1#1#6#9#9#0#5#10#10#6#8#9#10#7#5#3#1#5#2#7#4#2#0#7#5#10#0#1#6#0#10#4#0#9#9#1#1#4#6#3#1#7#2#10#10#7#5#1#4#5#9#4#2#10#8#9#8#5#6#4#10#6#4#5#10#10#5#10;
242:result:=#3#5#2#0#5#5#6#4#2#2#1#3#1#10#8#3#10#3#1#2#10#5#3#5#9#0#1#9#2#5#4#4#10#0#3#3#7#9#10#5#8#6#5#8#0#5#3#9#1#7#1#7#6#10#2#10#1#7#0#2#1#4#5#2#1#10#5#6#5#7#10#5#8#4#8#2#4#10#8#6#8#2#8#9#3#6#1#5#6#6#7#10#6#5#9#8#4#10#5#8;
243:result:=#0#3#10#9#2#10#8#5#3#5#5#5#4#7#8#6#2#10#5#10#2#1#5#6#3#3#8#3#8#2#7#3#6#7#10#5#4#9#8#3#8#5#0#2#2#1#8#3#5#4#3#4#8#5#8#6#9#2#8#6#10#6#5#0#10#7#5#3#3#8#2#2#3#0#2#3#8#6#5#8#6#2#3#2#2#2#10#2#5#5#1#1#9#5#3#2#9#8#10#4;
244:result:=#3#4#2#9#3#10#8#9#0#5#4#2#4#3#7#9#5#9#10#9#2#1#7#3#3#8#1#7#6#5#1#2#4#5#9#8#10#10#9#8#9#7#9#6#10#8#5#1#5#9#0#9#9#1#2#10#3#10#2#6#6#1#6#3#10#10#0#5#3#7#4#6#2#9#0#9#6#0#4#9#3#10#10#4#10#0#8#8#5#3#4#6#4#9#5#4#0#8#9#6;
245:result:=#9#4#9#4#9#2#2#9#8#8#6#2#8#9#6#7#10#6#2#1#1#4#6#9#2#4#7#5#9#9#9#3#2#4#6#4#10#3#3#5#4#3#0#5#10#4#6#9#9#10#0#0#9#6#5#10#0#9#7#7#9#5#8#1#6#8#1#2#1#7#4#4#7#9#1#2#8#5#7#0#5#6#5#4#8#7#7#9#6#4#5#5#1#7#0#3#0#2#1#0;
246:result:=#6#0#2#6#9#3#0#0#3#0#1#3#6#2#1#5#8#0#8#0#4#10#9#4#10#8#4#2#1#6#5#1#0#9#5#5#7#8#8#1#6#1#5#5#4#10#6#6#9#9#2#5#7#3#2#2#7#1#8#10#6#2#2#1#9#3#9#10#10#5#6#3#7#10#10#8#3#4#7#6#10#5#1#6#6#9#6#10#7#1#6#9#7#7#4#6#6#10#8#5;
247:result:=#9#4#6#2#6#7#8#10#0#0#3#10#3#3#9#1#7#2#5#7#1#2#9#10#3#0#3#7#7#10#7#8#10#5#7#2#5#6#9#10#4#2#6#1#6#9#5#4#9#5#5#10#5#1#8#4#5#2#3#2#8#1#8#1#9#1#0#0#4#10#3#4#9#1#7#10#1#7#10#2#2#9#3#3#0#3#10#1#8#2#0#9#2#9#2#3#6#1#8#8;
248:result:=#5#3#7#3#5#8#1#1#7#5#0#7#1#1#7#5#1#7#4#2#4#6#0#10#9#0#2#4#2#5#6#4#8#2#0#3#5#10#2#1#8#8#7#5#1#1#7#6#3#9#5#7#6#9#2#3#0#2#6#1#5#6#6#3#6#1#8#0#5#3#8#10#10#8#3#8#0#1#3#8#8#9#2#3#3#3#5#8#5#5#2#5#0#1#10#2#10#9#4#2;
249:result:=#10#3#4#5#8#9#6#0#2#9#0#4#0#7#5#0#0#1#0#6#7#4#9#0#9#2#1#7#0#1#4#3#3#3#1#1#0#4#10#2#9#2#10#1#6#2#1#6#3#3#0#0#4#4#0#8#4#1#3#9#1#8#0#10#6#5#0#2#1#1#7#10#9#6#10#9#8#8#0#8#2#6#10#9#0#2#4#0#0#7#4#7#3#6#3#6#5#8#3#5;
250:result:=#10#5#0#0#0#4#3#4#1#4#6#3#9#7#1#5#7#2#3#10#8#8#10#7#10#7#6#6#8#9#2#7#10#4#0#9#6#8#2#1#0#4#6#9#8#10#5#2#5#5#10#6#6#8#10#5#1#1#5#5#6#5#4#1#10#3#7#3#0#9#4#5#1#1#0#1#6#8#7#9#6#5#6#10#9#5#3#7#2#0#1#6#2#1#4#7#5#3#10#5;
251:result:=#1#3#1#0#9#1#6#5#6#1#7#2#4#4#4#1#3#8#4#4#5#6#1#1#5#10#10#1#6#2#5#3#9#0#4#6#7#8#1#7#6#0#6#4#9#10#1#0#7#1#3#8#1#1#1#4#0#1#0#10#6#2#0#9#5#2#9#2#3#7#0#0#5#4#6#5#4#5#9#6#3#0#8#1#5#0#6#7#2#6#6#3#5#1#0#9#6#5#9#1;
252:result:=#1#6#10#1#9#6#1#3#1#8#1#6#4#6#0#1#10#8#1#0#3#1#10#9#9#3#1#2#10#9#2#9#8#1#0#2#10#2#6#2#5#3#8#10#9#1#1#6#8#8#7#6#2#2#4#2#8#9#4#6#7#4#5#10#9#3#8#7#9#4#9#3#5#1#2#2#5#2#7#4#3#9#9#4#6#4#3#7#6#3#3#0#1#8#10#2#10#8#0#8;
253:result:=#4#3#5#5#8#9#9#5#6#10#10#9#10#5#3#6#0#10#4#1#6#8#9#9#8#8#3#9#7#8#1#9#2#9#5#3#3#7#0#0#6#6#9#3#0#6#4#0#7#8#4#2#1#0#0#0#6#8#1#10#8#1#7#0#7#7#10#9#8#3#10#9#2#7#9#4#10#10#7#7#6#10#2#2#5#3#8#10#7#2#5#0#8#1#7#5#10#5#1#3;
254:result:=#1#2#7#2#7#3#3#9#2#5#1#4#4#1#9#3#1#6#8#3#5#10#2#9#3#9#7#4#10#6#3#0#1#1#2#9#0#7#10#8#1#3#1#0#9#9#5#1#2#2#9#5#6#3#6#1#2#8#5#7#2#2#0#7#8#7#5#0#10#5#2#3#1#3#5#4#2#6#5#1#3#4#5#0#0#7#8#10#0#1#3#4#3#4#10#0#8#10#2#5;
else result:=#2#6#2#10#8#8#5#1#4#4#2#5#8#6#2#3#10#0#4#7#7#5#8#6#4#1#8#0#2#6#10#4#9#4#8#3#5#10#5#0#4#6#4#1#0#0#2#9#8#5#8#7#7#2#10#0#4#0#4#0#9#8#4#2#3#3#1#0#8#1#7#8#7#8#6#5#4#5#10#7#2#6#8#7#9#0#1#8#1#6#10#3#9#3#9#0#1#4#5#4;
end;
except;end;
end;
//## xmakekey ##
function xmakekey(binkey:string;var pkey:string):boolean;
var
   a:tint4;
   xref,k1,k2:string;
   p,v1,v2,v3,v:longint;
begin
try
//defaults
result:=false;
pkey:='';
//filter
if (binkey='') then exit;
//encode
v3:=random(255);
xref:=xsaferef(v3);
for p:=1 to frcmax(length(binkey),length(xref)) do
begin
v1:=byte(binkey[p])+byte(xref[p]);
if (v1>255) then dec(v1,256);
binkey[p]:=char(byte(v1));
end;//p
//xysort.encode
k1:=k1+k2+from8bit2(v3);
xysort(#103,'3489723adsgfasdf',k1);
xysort(#104,'985sfdgklj',k1);
xysort(#102,'A0fSl3',k1);
xysort(#101,'wiuy#adf',k1);
//get
k1:='';
k2:='';
for p:=1 to length(binkey) do
begin
v1:=random(255);
v2:=byte(binkey[p])+v1;
if (v2>255) then dec(v2,256);
k1:=k1+from8bit2(byte(v1));
k2:=k2+from8bit2(byte(v2));
end;//p
//xysort.scramle only
k1:=k1+k2+from8bit2(v3);
xysort(#6,'3489723adsgfasdf',k1);
xysort(#3,'985sfdgklj',k1);
xysort(#1,'A0fSl3',k1);
xysort(#0,'wiuy#adf',k1);
//shift.up
v3:=random(255);
xref:=xsaferef2(v3);
for p:=1 to frcmax(length(k1),length(xref)) do k1[p]:=char(byte(k1[p])+byte(xref[p]));
k1:=k1+from8bit2(v3);
//set
pkey:='[[EA:'+k1+':EA]]';
//successful
result:=true;
except;end;
end;
//## xreadkey ##
function xreadkey(x:string;var rawkey,pkey:string):boolean;
label
   skipend,redo;
var
   a:tint4;
   z,str2,str1,xref,k1,k2:string;
   sp,p,p2,v1,v2,v3,v:longint;
begin
try
//defaults
result:=false;
rawkey:='';
pkey:='';
//filter
if (x='') then exit;
//find
sp:=0;//off
str2:='';
x:=lowercase(x)+#32;
for p:=1 to length(x) do
begin
if (x[p]='[') and (copy(x,p,5)='[[ea:') then sp:=p
else if (x[p]=']') and (p>=5) and (copy(x,p-4,5)=':ea]]') and (sp>=1) then
   begin
   //get
   z:=copy(x,sp+5,p-sp-9);
   //filter
   if (z<>'') then
      begin
      str1:='';
      for p2:=1 to length(z) do if ((z[p2]>='a') and (z[p2]<='z')) or ((z[p2]>='0') and (z[p2]<='9')) then str1:=str1+z[p2];
      z:=str1;
      end;
   //set
   if (z<>'') then
      begin
      str2:=uppercase(z);
      break;
      end;
   end;
end;//p
//check
if (str2='') then goto skipend;
rawkey:='[[EA:'+str2+':EA]]';//used for "save/loadsettings" - 06mar2018
//shift.down
v3:=to8bit2(copy(str2,length(str2)-1,2));
str2:=copy(str2,1,length(str2)-2);
xref:=xsaferef2(v3);
for p:=1 to frcmax(length(str2),length(xref)) do str2[p]:=char(byte(str2[p])-byte(xref[p]));
//xysort.unscramle only
xysort(#0,'wiuy#adf',str2);
xysort(#1,'A0fSl3',str2);
xysort(#3,'985sfdgklj',str2);
xysort(#6,'3489723adsgfasdf',str2);
//.v3
v3:=to8bit2(copy(str2,length(str2)-1,2));
str2:=copy(str2,1,length(str2)-2);
//get
v:=length(str2) div 2;
k1:=copy(str2,1,v);
k2:=copy(str2,v+1,length(str2));
redo:
v1:=to8bit2(copy(k1,1,2));delete(k1,1,2);
v2:=to8bit2(copy(k2,1,2));delete(k2,1,2);
v1:=v2-v1;
if (v1<0) then inc(v1,256);
pkey:=pkey+char(v1);
//.loop
if (k1<>'') and (k2<>'') then goto redo;
//xysort.decode
xysort(#201,'wiuy#adf',str2);
xysort(#202,'A0fSl3',str2);
xysort(#204,'985sfdgklj',str2);
xysort(#203,'3489723adsgfasdf',str2);
//decode
xref:=xsaferef(v3);
for p:=1 to frcmax(length(pkey),length(xref)) do
begin
v1:=byte(pkey[p])-byte(xref[p]);
if (v1<0) then inc(v1,256);
pkey[p]:=char(byte(v1));
end;//p
//successful
result:=(pkey<>'');
skipend:
except;end;
end;

//-- IO Etc --------------------------------------------------------------------
//## exe_marker ##
function exe_marker:string;//07mmay2015
var
   z:string;
begin
try
//defaults
result:='';
z:='';
//set - dynamically create the header, so that no complete trace is formed in the final EXE data stream, we can then search for this header without fear of it being repeated in the code by mistake! - 18MAY2010
result:=result+'[packed';
result:=result+'-marker]';
result:=result+'[id--';
//.id
z:=z+'1398435432908435908';
z:='__12435897'+z;
z:=z+'0-9132487211239084%%__';
z:=z+'~12@__Z';
//finalise
result:=result+z+'--]';
except;end;
end;
//## exe_data ##
function exe_data(xfilenameORdataORnil:string;xfrom:longint;var xdatastream:string):boolean;//03mar2018
label
   skipend;
var
   p,hlen,_filesize:longint;
   _date:tdatetime;
   h,z,e:string;
   s:char;
begin
try
//defaults
result:=false;
xdatastream:='';
xfrom:=frcmin(xfrom,0);
//smart load
if (xfilenameORdataORnil='') then
   begin
   if not low__fromfileb(application.exename,z,e,_filesize,xfrom,maxint,_date) then goto skipend;
   xfrom:=0;
   end
else if (copy(xfilenameORdataORnil,2,2)=':\') then
   begin
   if not low__fromfileb(xfilenameORdataORnil,z,e,_filesize,xfrom,maxint,_date) then goto skipend;
   xfrom:=0;
   end
else z:=xfilenameORdataORnil;
//init
h:=exe_marker;
hlen:=length(h);
//check
if (h='') or (z='') then goto skipend;
//get - find "packed marker"
s:=h[1];
for p:=xfrom to length(z) do if (s=z[p]) and (copy(z,p,hlen)=h) then
   begin
   xdatastream:=copy(z,p+hlen,length(z));
   result:=true;
   break;
   end;//p
skipend:
except;end;
end;
//## low__libclear ##
procedure low__libclear(var x:tliblist);
var
   p:longint;
begin
try
x.info:='';
x.des:='';
x.count:=0;
for p:=0 to high(x.nref) do
begin
x.nref[p]:=0;
x.name[p]:='';
x.data[p]:='';
end;//p
except;end;
end;
//## low__libbytes ##
function low__libbytes(var x:tliblist):longint;
var
   p:longint;
begin
try
result:=0;
if (x.count>=1) then
   begin
   for p:=0 to high(x.nref) do inc(result,length(x.data[p]));
   end;
except;end;
end;
//## low__libfromdata ##
function low__libfromdata(var x:tliblist;var xdata,e:string):boolean;
label
   skipend,redo;
var
   p,xlen,xpos:longint;
   xkey,xnam,xval:string;
   //## xpull0 ##
   function xpull0(var n,v:string;xdecode:boolean):boolean;
   var
      a:tint4;
      p:longint;
      e,str1:string;
   begin
   //defaults
   result:=false;
   n:='';
   v:='';
   //get
   if ((xpos+3)<=xlen) then
      begin
      //chunk size -> "name+#0+data"
      a.chars[0]:=xdata[xpos+0];
      a.chars[1]:=xdata[xpos+1];
      a.chars[2]:=xdata[xpos+2];
      a.chars[3]:=xdata[xpos+3];
      inc(xpos,4);
      //chunk
      if (a.val>=2) then
         begin
         v:=copy(xdata,xpos,a.val);
         //decode
         if xdecode and (v<>'') then v:=stdencrypt(v,xkey,0);//decode
         //split
         if (v<>'') then
            begin
            //decompress
            str1:=copy(v,length(v),1);
            delete(v,length(v),1);//trim away trailing compression tag
            if (str1='y') then low__decompress(v,e);
            //split
            if (v<>'') then
               begin
               for p:=1 to length(v) do if (v[p]=#0) then
                  begin
                  n:=copy(v,1,p-1);
                  delete(v,1,p);
                  break;
                  end;//p
               end;
            end;//v
         end;//a.val
      //inc
      if (a.val>=1) then inc(xpos,a.val);
      //successful
      result:=true;
      end;
   end;
   //## xpull ##
   function xpull(var n,v:string):boolean;
   begin
   result:=xpull0(n,v,true);
   end;
begin
try
//defaults
result:=false;
e:=gecTaskfailed;
//init
xlen:=length(xdata);
low__libclear(x);
xkey:='';
//check
if (xlen=0) then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;
//decode
//.b128
if (comparetext(copy(xdata,1,5),'b128:')=0) then
   begin
   delete(xdata,1,5);
   xdata:=low__fromb128b(xdata);
   xlen:=length(xdata);
   if (xdata='') then
      begin
      e:=gecDatacorrupt;
      goto skipend;
      end;
   end
//.b64
else if (comparetext(copy(xdata,1,4),'b64:')=0) then
   begin
   delete(xdata,1,4);
   xdata:=low__fromb64b(xdata);
   xlen:=length(xdata);
   if (xdata='') then
      begin
      e:=gecDatacorrupt;
      goto skipend;
      end;
   end;
//get
e:=gecOutofmemory;
xpos:=1;
//.header -> never encoded
if (not xpull0(xnam,xval,false)) or (xnam<>'hdr') or (xval<>'lib1') then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;
//.encryption key -> special decoder
if xpull0(xnam,xval,false) and (xnam='lim') then xkey:=cdstr_rkey(xval,true,false,false);//raise no errors - 07mar2020
if (xkey='') then
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;
//.description
if xpull(xnam,xval) and (xnam='des') then x.des:=xval
else
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;
//.info
if xpull(xnam,xval) and (xnam='info') then x.info:=xval
else
   begin
   e:=gecUnknownformat;
   goto skipend;
   end;
//.files
redo:
if xpull(xnam,xval) then
   begin
   //set -> enforce upper limit - 07mar2020
   if (xnam<>'') and (x.count<=high(x.nref)) then
      begin
      p:=x.count;
      x.nref[p]:=low__crc32nonzero(lowercase(xnam));
      x.name[p]:=xnam;
      x.data[p]:=xval;
      //inc
      inc(x.count);
      end;
   //loop
   if (xpos<=xlen) and (x.count<=high(x.nref)) then goto redo;
   end;
//successful
result:=true;
skipend:
except;end;
end;
//## low__libfromdatab ##
function low__libfromdatab(var x:tliblist;xdata:string):boolean;
var
   e:string;
begin
try;result:=low__libfromdata(x,xdata,e);except;end;
end;
//## low__libtodata ##
function low__libtodata(var x:tliblist;var xdata,e:string;xcompress,xdelphiB128:boolean):boolean;
var
   xdatalen,p:longint;
   xkey,str1:string;
   //## xadd0 ##
   procedure xadd0(n:string;var v:string;xencode:boolean);
   var
      a:tint4;
      e,str2,str1:string;
   begin
   str1:=n+#0+v;
   if xcompress then
      begin
      str2:=str1;
      low__compress(str2,e);
      case (length(str2)<=round(length(str1)*0.95)) of
      true:str1:=str2+'y';//compressed
      false:str1:=str1+'n';//not compressed
      end;//case
      end
   else str1:=str1+'n';//not compressed
   if xencode then str1:=stdencrypt(str1,xkey,1);//encode
   a.val:=length(str1);
   pushb(xdatalen,xdata,a.chars[0]+a.chars[1]+a.chars[2]+a.chars[3]+str1);
   end;
   //## xadd ##
   procedure xadd(n:string;var v:string);
   begin
   xadd0(n,v,true);
   end;
begin
try
//defaults
result:=false;
e:=gecTaskfailed;
xdata:='';
xdatalen:=0;
xkey:=low__randomstr(350+random(200));//random key + randomish length - 07mar2020
//get
//.header
str1:='lib1';
xadd0('hdr',str1,false);//never encode header
//.encryption key
str1:=cestr_rkey(xkey,true);
xadd0('lim',str1,false);
//.des + info
xadd('des',x.des);
xadd('info',x.info);
//files
if (x.count>=1) then
   begin
   for p:=0 to (x.count-1) do if (x.name[p]<>'') then xadd(x.name[p],x.data[p]);
   end;
//.finalise
pushb(xdatalen,xdata,'');
//.xdelphiB128
if xdelphiB128 then xdata:=low__toblock('B128:'+low__tob128b(xdata,'','',0),250);
//successful
result:=true;
except;end;
try;if not result then xdata:='';except;end;
end;
//## low__libtodatab ##
function low__libtodatab(var x:tliblist;xcompress,xdelphiB128:boolean):string;
var
   e:string;
begin
try;low__libtodata(x,result,e,xcompress,xdelphiB128);except;end;
end;
//## low__libfind ##
function low__libfind(var x:tliblist;xname:string;var xindex:longint):boolean;
var
   p,nref:longint;
begin
try
//defaults
result:=false;
xindex:=0;
//check
if (xname='') or (x.count<=0) then exit;
//init
nref:=low__crc32nonzero(lowercase(xname));
//find
for p:=0 to (x.count-1) do if (nref=x.nref[p]) and (comparetext(xname,x.name[p])=0) then
   begin
   result:=true;
   xindex:=p;
   break;
   end;//p
except;end;
end;
//## low__libhave ##
function low__libhave(var x:tliblist;xname:string):boolean;
var
   int1:longint;
begin
try
result:=false;
if (x.count>=1) and (xname<>'') then result:=low__libfind(x,xname,int1);
except;end;
end;
//## low__libdata ##
function low__libdata(var x:tliblist;xname:string):string;
var
   int1:longint;
begin
try
result:='';
if (x.count>=1) and (xname<>'') and low__libfind(x,xname,int1) then result:=x.data[int1];
except;end;
end;
//## low__libsetdata ##
function low__libsetdata(var x:tliblist;xname,xdata:string):boolean;
var
   i:longint;
   xnew:boolean;
begin
try
//defaults
result:=false;
//check
if (xname='') then exit;
//find slot -> overwrite existing name OR use new slot
xnew:=false;
if not low__libfind(x,xname,i) then
   begin
   xnew:=true;
   i:=x.count;
   end;
//store
if (i<=high(x.nref)) then
   begin
   //get
   x.nref[i]:=low__crc32nonzero(lowercase(xname));
   x.name[i]:=xname;
   x.data[i]:=xdata;
   //inc
   if xnew then inc(x.count);
   //successful
   result:=true;
   end;
except;end;
end;
//## low__libaddfiles ##
function low__libaddfiles(var x:tliblist;xpathmask:string;var e:string):boolean;
label
   skipend;
var
   a:tstringlist;
   p:longint;
   xfolder,str1:string;
begin
try
//defaults
result:=false;
e:=gecTaskfailed;
a:=nil;
xfolder:='';
//check
if (xpathmask='') then exit;
//init
for p:=length(xpathmask) downto 1 do if (xpathmask[p]='\') then
   begin
   xfolder:=copy(xpathmask,1,p);
   break;
   end;
if (xfolder='') then
   begin
   e:=gecPathnotfound;
   exit;
   end;
//get
a:=createstringlist;
a.text:=litefiles(xpathmask,false);
if (a.count>=1) then
   begin
   for p:=0 to (a.count-1) do
   begin
   if (a.strings[p]<>'') then
      begin
      //data
      if not low__fromfile(xfolder+a.strings[p],str1,e) then goto skipend;
      //set
      if not low__libsetdata(x,a.strings[p],str1) then
         begin
         e:=gecTaskfailed;
         goto skipend;
         end;
      end;//n
   end;//p
   end;
//successful
result:=true;
skipend:
except;end;
try;freeobj(@a);except;end;
end;
//## compress ##
function low__compress(var x,e:string):boolean;
begin
try;result:=low__compress2(x,e,[iocsCompress]);except;end;
end;
//## decompress ##
function low__decompress(var x,e:string):boolean;
begin
try;result:=low__compress2(x,e,[iocsDecompress]);except;end;
end;
//## low__compress2 ##
function low__compress2(var x,e:string;_style:tiocompressstyle):boolean;
label
     skipend;
const
   a:array[boolean] of tiostyle =(iosFromC,iosToC);
var
  strm:TZStreamRec;
  tmp,p:pointer;
  v2,v,incBY,ip,xLEN,tmpLEN:integer;
  c:boolean;
  _hdr:string;
begin
try
//error
result:=false;
e:=gecOutOfMemory;
//prepare
tmp:=nil;
c:=(iocsCompress in _style);
v:=0;
v2:=0;
p:=nil;
xLEN:=length(x);
//.read header - decompression
_hdr:='';
if (not c) and (iocsHeader in _style) and (xLEN>=3) then
   begin
   //.get
   _hdr:=copy(x,1,3);
   //.read
   if (_hdr=tiocmRAW) then
      begin
      delete(x,1,3);//remove header
      result:=true;
      goto skipend;
      end
   else if (_hdr=tiocmCompressed) then
      begin
      delete(x,1,3);//remove header
      xLEN:=length(x);
      end
   else
       begin
       e:=gecUnknownFormat;
       goto skipend;
       end;//end of if
   end;//end of if
//.other
//was: _init(xLEN,0,0,a[c]);
fillchar(strm,sizeof(strm),0);
strm.zalloc:=zlibAllocMem;
strm.zfree:=zlibFreeMem;
if c then
   begin//compress
   tmpLEN:=((xLEN+(xLEN div 10)+12)+255) and not 255;
   incBY:=256;
   end
   else
   begin//decompress
   incBY:=(xLEN+255) and not 255;
   tmpLEN:=incBY;
   end;//end of if
getmem(tmp,tmpLEN);
//process
strm.next_in:=pchar(x);
strm.avail_in:=length(x);
strm.next_out:=tmp;
strm.avail_out:=incBY;
//.init
if c then v:=deflateInit_(strm,Z_BEST_SPEED,zlib_version,sizeof(strm)) else v:=inflateInit_(strm,zlib_version,sizeof(strm));
if (v<0) then goto skipend;
try
//.work
while true do
begin
//.get
if c then v:=deflate(strm,z_FINISH) else v:=inflate(strm,z_FINISH);
if (v=Z_STREAM_END) or (v<0) then break;
//.set
if (strm.avail_out=0) then
   begin
   //.inc
   p:=tmp;
   inc(tmpLEN,incBY);
   reallocmem(tmp,tmpLEN);
   strm.next_out:=pchar(integer(tmp)+(integer(strm.next_out)-integer(p)));
   strm.avail_out:=incBY;
   //.event
   //was: if general.pause then eventSTRM(strm);
   //.check
   //was: if icancelled then break;
   end;//end of if
end;//end of with
finally
//.finalise
//was:eventSTRM(strm);
if c then v2:=deflateEnd(strm) else v2:=inflateEnd(strm);
end;
if (v<0) or (v2<0) then goto skipend;
//.get
reallocmem(tmp,strm.total_out);
tmpLEN:=strm.total_out;
//.prepare header - compression
if c and (iocsHeader in _style) then
   begin
   if (tmpLEN<xLEN) then _hdr:=tiocmCompressed else _hdr:=tiocmRAW;
   end;//end of if
//.fill data
if (_hdr<>tiocmRAW) then
   begin
   x:='';
   setstring(x,pchar(tmp),tmpLEN);
   end;//end of if
//.write header
if c and (_hdr<>'') then insert(_hdr,x,1);
//successful
result:=true;
skipend:
except;end;
try
if not result then x:='';
//was: aem(e);
freemem(tmp);
except;end;
end;
//## pushb ##
function pushb(var _dataLEN:integer;var _data:string;_add:string):boolean;
begin
try;result:=pushx(_dataLEN,tio1Mb,_data,_add);except;end;
end;
//## push ##
function push(var _dataLEN:integer;var _data,_add:string):boolean;
begin
try;result:=pushx(_dataLEN,tio1Mb,_data,_add);except;end;
end;
//## pushbx ##
function pushbx(var _dataLEN:integer;_bufferSTEP:integer;var _data:string;_add:string):boolean;
begin
try;result:=pushx(_dataLEN,_bufferSTEP,_data,_add);except;end;
end;
//## pushx ##
function pushx(var _dataLEN:integer;_bufferSTEP:integer;var _data,_add:string):boolean;
var//high capacity, rapid string assembler
   //note: _dataLEN must initially be set by host
   p,s,_addLEN:integer;
begin
try
//error
result:=false;
//fast override - 17nov2016
if program_fastenhancements then
   begin
   result:=__fast_pushx(_dataLEN,_bufferSTEP,_data,_add);
   exit;
   end;
//prepare
_addLEN:=length(_add);
//process
//.finalise
if (_addLEN=0) then
   begin
   delete(_data,_dataLEN+1,length(_data));
   result:=true;
   exit;
   end;//end of if
//.size
if ((_dataLEN+_addLEN)>length(_data)) then
   begin
   s:=_addLEN;
   if (s<_bufferSTEP) then s:=_bufferSTEP;
   setlength(_data,_dataLEN+s);
   end;//end of if
//.set (work down to fisrt, 15% faster @ 200Mhz)
for p:=_addLEN downto 1 do _data[_dataLEN+p]:=_add[p];
//.inc
_dataLEN:=_dataLEN+_addLEN;
//successful
result:=true;
except;end;
end;
//## __fast_pushx ##
function __fast_pushx(var _dataLEN:integer;_bufferSTEP:integer;var _data,_add:string):boolean;//faster still - 16nov2016
var//high capacity, rapid string assembler
   //note: _dataLEN must initially be set by host
   p,s,_addLEN:integer;
   dref,aref:pdlbyte1;
begin
try
//defaults
result:=false;
//init
_addLEN:=length(_add);
//finalise
if (_addLEN=0) then
   begin
   delete(_data,_dataLEN+1,length(_data));
   result:=true;
   exit;
   end;//end of if
//resize
if ((_dataLEN+_addLEN)>length(_data)) then
   begin
   s:=_addLEN;
   if (s<_bufferSTEP) then s:=_bufferSTEP;
   setlength(_data,_dataLEN+s);
   end;//end of if
//add
//.optimisation #1: work from last to first byte => 15% faster on 200Mhz pentium (still applies to new machines) - 16nov2016
//.optimisation #2: copy via pdlbyte structure => 65% faster - 16nov2016
_data[1]:=_data[1];//force a unique memory handle by setting 1st char
dref:=pdlbyte1(pchar(_data));
_add[1]:=_add[1];//and again force a unique memory handle by setting 1st char
aref:=pdlbyte1(pchar(_add));
for p:=_addLEN downto 1 do dref[_dataLEN+p]:=aref[p];
//inc
_dataLEN:=_dataLEN+_addLEN;
//successful
result:=true;
except;end;
end;
//## pushlimit ##
function pushlimit(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data,_add:string):boolean;
var//high capacity, rapid string assembler
   //note: _dataLEN must initially be set by host
   p,s,_addLEN:integer;
begin
try
//error
result:=false;
//prepare
_addLEN:=length(_add);
//process
//.finalise
if (_addLEN=0) then
   begin
   //.range
   if (_dataLEN>_limit) then _dataLEN:=_limit;
   //.set
   delete(_data,_dataLEN+1,length(_data));
   result:=true;
   exit;
   end;//end of if
//.limit - Note: "limit<=-1" = unlimited (no limit)
if (_limit>=0) and ((_dataLEN+_addLEN)>_limit) then
   begin
   _addLEN:=_limit-_dataLEN;
   if (_addLEN<=0) then
      begin
      result:=true;
      exit;
      end;//end of if
   end;//end of if
//.size
if ((_dataLEN+_addLEN)>length(_data)) then
   begin
   s:=_addLEN;
   if (s<_bufferSTEP) then s:=_bufferSTEP;
   setlength(_data,_dataLEN+s);
   end;//end of if
//.set (work down to fisrt, 15% faster @ 200Mhz)
for p:=_addLEN downto 1 do _data[_dataLEN+p]:=_add[p];
//.inc
_dataLEN:=_dataLEN+_addLEN;
//successful
result:=true;
except;end;
end;
//## pushlimitb ##
function pushlimitb(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data:string;_add:string):boolean;
begin
try;result:=pushlimit(_dataLEN,_bufferSTEP,_limit,_data,_add);except;end;
end;
//## low__tob64 ##
function low__tob64(var s,d:string;linelength:longint;var e:string):boolean;//to base64
label//Speed: 2,997Kb in 3320ms (~0.902Mb/sec) @ 200Mhz
   skipend;
var
   a,b:tint4;
   tmpi,ll,slen,dlen,p,i:longint;
   tmp:string;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
//init
d:='';
dlen:=0;
slen:=length(s);
ll:=0;
p:=1;
if (linelength<0) then linelength:=0;
//check
if (slen=0) then
   begin
   result:=true;
   exit;
   end;
//get
tmpi:=0;
setlength(tmp,4096+6);
repeat
//.get
a.val:=0;
a.bytes[2]:=byte(s[p]);
if ((p+1)<=slen) then a.bytes[1]:=byte(s[p+1]) else a.bytes[1]:=0;
if ((p+0)<=slen) then a.bytes[0]:=byte(s[p+2]) else a.bytes[0]:=0;
//.soup (3 -> 4)
b.bytes[0]:=(a.val div 262144);
dec(a.val,b.bytes[0]*262144);
b.bytes[1]:=(a.val div 4096);
dec(a.val,b.bytes[1]*4096);
if ((p+1)<=slen) then
   begin
   b.bytes[2]:=a.val div 64;
   dec(a.val,b.bytes[2]*64);
   end
else b.bytes[2]:=64;
if ((p+2)<=slen) then b.bytes[3]:=a.val else b.bytes[3]:=64;
//.encode
for i:=0 to 3 do b.chars[i]:=base64[b.bytes[i]];
//.tmp
inc(tmpi,4);
tmp[tmpi-3]:=b.chars[0];
tmp[tmpi-2]:=b.chars[1];
tmp[tmpi-1]:=b.chars[2];
tmp[tmpi]:=b.chars[3];
if (tmpi>=4096) then//allows for previous line code of 2 char's (-6 for safty)
   begin
   //.100Kb buffer
   pushbx(dlen,102400,d,copy(tmp,1,tmpi));
   tmpi:=0;
   end;//if
//.line
if (linelength<>0) then
   begin
   inc(ll,4);
   if (ll>=linelength) then
      begin
      inc(tmpi,2);
      tmp[tmpi-1]:=#13;
      tmp[tmpi]:=#10;
      ll:=0;
      end;//if
   end;//if
//.inc
inc(p,3);
until (p>slen);
//.finalise
if (tmpi>=1) then pushb(dlen,d,copy(tmp,1,tmpi));
pushb(dLEN,d,'');
//successful
result:=true;
skipend:
except;end;
try;if not result then d:='';except;end;
end;
//## low__tob64b ##
function low__tob64b(s:string;linelength:longint):string;
var
   e:string;
begin
try;low__tob64(s,result,linelength,e);except;end;
end;
//## low__fromb64 ##
function low__fromb64(var s,d:string;var e:string):boolean;//from base64
label//Speed: 4,101Kb in 3150ms (~1.301Mb/sec) @ 200Mhz
   skipend;
var
   b,a:tint4;
   tmpi,slen,dlen,c,p,i:longint;
   v:byte;
   tmp:string;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
d:='';
dlen:=0;
slen:=length(s);
p:=1;
//check
if (slen=0) then
   begin
   result:=true;
   exit;
   end;
//init
tmpi:=0;
setlength(tmp,300);
//get
repeat
a.val:=0;
c:=0;
repeat
//.store
v:=byte(base64r[byte(s[p])])-48;
if (v>=0) and (v<=63) then
   begin
   //.set
   case c of
   0:inc(a.val,v*262144);
   1:inc(a.val,v*4096);
   2:inc(a.val,v*64);
   3:begin
     inc(a.val,v);
     inc(c);
     inc(p);
     break;
     end;//begin
   end;//case
   //.inc
   inc(c,1);
   end
else if (v=64) then
   begin
   p:=slen;
   break;//=
   end;//if
//.inc
inc(p);
until (p>slen);
//.split (4 -> 3)
b.bytes[0]:=a.val div 65536;
dec(a.val,b.bytes[0]*65536);
b.bytes[1]:=a.val div 256;
dec(a.val,b.bytes[1]*256);
b.bytes[2]:=a.val;
//.set
case c of
4:begin
  inc(tmpi,3);
  tmp[tmpi-2]:=b.chars[0];
  tmp[tmpi-1]:=b.chars[1];
  tmp[tmpi]:=b.chars[2];
  end;//begin
3:begin//finishing #1
  inc(tmpi,2);
  tmp[tmpi-1]:=b.chars[0];
  tmp[tmpi]:=b.chars[1];
  end;//begin
1..2:begin//finishing #2
  inc(tmpi,1);
  tmp[tmpi]:=b.chars[0];
  end;//begin
end;//end of case
//.tmp
if (tmpi>=300) then//always 300 exactly until last when "finishing #1/#2 or exact"
   begin
   pushb(dlen,d,tmp);
   tmpi:=0;
   end;//if
until (p>=slen);
//.finalise
if (tmpi>=1) then pushb(dlen,d,copy(tmp,1,tmpi));
pushb(dlen,d,'');
//successful
result:=true;
skipend:
except;end;
try;if not result then d:='';except;end;
end;
//## low__fromb64b ##
function low__fromb64b(s:string):string;
var
   e:string;
begin
try;low__fromb64(s,result,e);except;end;
end;
//## low__toc64b ##
function low__toc64b(s:string;linelength:integer;_delphi:boolean):string;//to compressed base64 - 28APR2011
var
   e:string;
begin
try
//defaults
result:='';
//check
if (s='') then exit;
//get
low__compress(s,e);//raw
s:=low__tob64b(s,linelength);
if _delphi then s:=low__toblock(s,250);
//set
result:=s;
s:='';
except;end;
end;
//## low__fromc64b ##
function low__fromc64b(s:string):string;//28APR2011
var
   e:string;
begin
try
//defaults
result:='';
//check
if (s='') then exit;
//get
s:=low__fromb64b(s);
if (s<>'') then low__decompress(s,e);//raw
//set
result:=s;
s:='';
except;end;
end;
//## low__nextline2 ##
function low__nextline2(var xdata,xlineout:string;xdatalen:longint;var xpos:longint):boolean;//17oct2018
var//Super fast line reader.  Supports #13 / #10 / #13#10 / #10#13,
   //with support for last line detection WITHOUT a trailing #10/#13 or combination thereof.
   int1,p:longint;
begin
try
//defaults
result:=false;
xlineout:='';
//init
if (xpos<1) then xpos:=1;
//get
if (xdatalen>=1) and (xpos<=xdatalen) then for p:=xpos to xdatalen do if (xdata[p]=#10) or (xdata[p]=#13) or (p=xdatalen) then
   begin
   //get
   result:=true;//detect even blank lines
   if (p>xpos) then
      begin
      if (p=xdatalen) and (xdata[p]<>#10) and (xdata[p]<>#13) then int1:=1 else int1:=0;//adjust for last line terminated by #10/#13 or without either - 18oct2018
      xlineout:=copy(xdata,xpos,p-xpos+int1);
      end;
   //inc
   if (p<xdatalen) and (xdata[p]=#13) and (xdata[p+1]=#10) then xpos:=p+2//2 byte return code
   else if (p<xdatalen) and (xdata[p]=#10) and (xdata[p+1]=#13) then xpos:=p+2//2 byte return code
   else xpos:=p+1;//1 byte return code
   //quit
   break;
   end;
except;end;
end;
//## low__nextline ##
function low__nextline(var xdata,xlineout:string;var xpos:longint):boolean;
begin
try;result:=low__nextline2(xdata,xlineout,length(xdata),xpos);except;end;
end;
//## low__toblock ##
function low__toblock(x:string;perline:integer):string;
label
   redo;
var
   len,p:integer;
   tmp,buffer:string;
begin
try
//defaults
result:='';
p:=1;
tmp:='';
buffer:='';
//check
perline:=frcmin(perline,2);
//process
while low__nextline(x,tmp,p) do
begin
//.push
buffer:=buffer+tmp;
//.pull
redo:
if (length(buffer)>=perline) then
   begin
   pushb(len,result,''''+copy(buffer,1,perline)+'''+'+rcode);
   delete(buffer,1,perline);
   goto redo;
   end;//end of if
end;//end of loop
//.finish
if (length(buffer)>=1) then pushb(len,result,''''+buffer+'''+'+rcode);
//.finalise
pushb(len,result,'');
//.terminator
for p:=length(result) downto (length(result)-10) do if (result[p]='+') then
   begin
   result[p]:=';';
   break;
   end;//end of if
except;end;
end;
//## low__tob128 ##
function low__tob128(var s,d:string;prestr,poststr:string;linelength:integer;var e:string):boolean;//09feb2015
var
   lc,vi,p,slen,dlen,maxp:integer;
   v1,v2,v3,v4,v5,v6,v7,v8:byte;
   prestrOK,poststrOK:boolean;
   //## inc7 ##
   procedure inc7(var v:byte);
   begin
   case v of
   0..11:inc(v,48);//0..11 -> [0]48..[;]59 = 12c
   12..40:inc(v,51);//12..40 -> [?]63..[[]91 = 29c
   41..70:inc(v,52);//41..70 -> []]93..[z]122 = 30c
   71..128:inc(v,121);//71..128 -> [A']192..[u']249 = 58c for a total of 129c (0-127 = 7bit encoding + 128=stop bit/09feb2015)
   else v:=255;//error - should NEVER occur - 09feb2015
   end;
   end;
   //## c7to8 ##
   procedure c7to8;
   begin
   //init
   v8:=0;
   //get
   //1
   if (v1<>(v1 div 2)*2) then inc(v8,1);//2^0=1
   v1:=v1 shr 1;
   //2
   if (v2<>(v2 div 2)*2) then inc(v8,2);//2^1=2
   v2:=v2 shr 1;
   //3
   if (v3<>(v3 div 2)*2) then inc(v8,4);//2^2=4
   v3:=v3 shr 1;
   //4
   if (v4<>(v4 div 2)*2) then inc(v8,8);//2^3=8
   v4:=v4 shr 1;
   //5
   if (v5<>(v5 div 2)*2) then inc(v8,16);//2^4=16
   v5:=v5 shr 1;
   //6
   if (v6<>(v6 div 2)*2) then inc(v8,32);//2^5=32
   v6:=v6 shr 1;
   //7
   if (v7<>(v7 div 2)*2) then inc(v8,64);//2^6=64
   v7:=v7 shr 1;
   //set - shift vals from "0-127=128" to "127-255=129(128 chars + 1 stop char)"
   if ((vi+0)<=slen) then inc7(v1) else v1:=249;
   if ((vi+1)<=slen) then inc7(v2) else v2:=249;
   if ((vi+2)<=slen) then inc7(v3) else v3:=249;
   if ((vi+3)<=slen) then inc7(v4) else v4:=249;
   if ((vi+4)<=slen) then inc7(v5) else v5:=249;
   if ((vi+5)<=slen) then inc7(v6) else v6:=249;
   if ((vi+6)<=slen) then inc7(v7) else v7:=249;
   inc7(v8);
   end;
begin
try
//defaults
result:=false;
e:=gecoutofmemory;
//check
if (s='') then exit;
//init
if (linelength<=0) then linelength:=0 else linelength:=frcmin((linelength div 8)*8,8);//nearest 8 chars
slen:=length(s);
d:='';
dlen:=0;
maxp:=slen div 7;//bounds checked and good
if ((maxp*7)=slen) then dec(maxp);
prestrOK:=(prestr<>'');
poststrOK:=(poststr<>'');
//get
lc:=0;
for p:=0 to maxp do
begin
//.fill
vi:=1+(p*7);
if ((vi+0)<=slen) then v1:=byte(s[vi+0]) else v1:=0;
if ((vi+1)<=slen) then v2:=byte(s[vi+1]) else v2:=0;
if ((vi+2)<=slen) then v3:=byte(s[vi+2]) else v3:=0;
if ((vi+3)<=slen) then v4:=byte(s[vi+3]) else v4:=0;
if ((vi+4)<=slen) then v5:=byte(s[vi+4]) else v5:=0;
if ((vi+5)<=slen) then v6:=byte(s[vi+5]) else v6:=0;
if ((vi+6)<=slen) then v7:=byte(s[vi+6]) else v7:=0;
v8:=0;
//.encode
c7to8;
//.store
if prestrOK and (lc=0) and (linelength>=1) then pushb(dlen,d,prestr);
pushb(dlen,d,char(v1)+char(v2)+char(v3)+char(v4)+char(v5)+char(v6)+char(v7)+char(v8));
inc(lc,8);
//.linelength
if (linelength>=1) and (lc>=linelength) then
   begin
   pushb(dlen,d,poststr+rcode);
   lc:=0;
   end;
end;//p
//.finalise
pushb(dlen,d,'');
//successful
result:=true;
except;end;
end;
//## low__tob128b ##
function low__tob128b(s:string;prestr,poststr:string;linelength:integer):string;//09feb2015
var
   e:string;
begin
try;low__tob128(s,result,prestr,poststr,linelength,e);except;end;
end;
//## low__toc128b ##
function low__toc128b(s:string;linelength:integer;xdelphi,xincludeheader:boolean):string;//to compressed base128 - 09feb2015
var
   e:string;
begin
try
//defaults
result:='';
//check
if (s='') then exit;
//get
low__compress(s,e);//raw
s:=low__tob128b(s,'','',linelength);
if xincludeheader then s:='C128:'+s;//08feb2020
if xdelphi then s:=low__toblock(s,250);
//set
result:=s;
s:='';
except;end;
end;
//## low__fromb128 ##
function low__fromb128(var s,d,e:string):boolean;//09feb2015
var
   vc,p,slen,dlen:integer;
   v,v1,v2,v3,v4,v5,v6,v7,v8,vSTOP:byte;
   //## dec7 ##
   function dec7(var v:byte):boolean;
   begin
   //defaults
   result:=false;
   //get
   case v of
   48..59:begin
      dec(v,48);//0..11 -> [0]48..[;]59 = 12c
      result:=true;
      end;
   63..91:begin
      dec(v,51);//12..40 -> [?]63..[[]91 = 29c
      result:=true;
      end;
   93..122:begin
      dec(v,52);//41..70 -> []]93..[z]122 = 30c
      result:=true;
      end;
   192..248:begin
      dec(v,121);//71..127 -> [A']192..[u']249 = 58c for a total of 129c (0-127 = 7bit encoding+ 128=stop bit/09feb2015)
      result:=true;
      end;
   249:begin
      v:=0;
      result:=true;
      end;
   end;//case
   end;
   //## c8to7 ##
   procedure c8to7;
   begin
   //7
   v7:=v7 shl 1;
   if (v8>=64) then
      begin
      inc(v7,1);
      dec(v8,64);
      end;
   //6
   v6:=v6 shl 1;
   if (v8>=32) then
      begin
      inc(v6,1);
      dec(v8,32);
      end;
   //5
   v5:=v5 shl 1;
   if (v8>=16) then
      begin
      inc(v5,1);
      dec(v8,16);
      end;
   //4
   v4:=v4 shl 1;
   if (v8>=8) then
      begin
      inc(v4,1);
      dec(v8,8);
      end;
   //3
   v3:=v3 shl 1;
   if (v8>=4) then
      begin
      inc(v3,1);
      dec(v8,4);
      end;
   //2
   v2:=v2 shl 1;
   if (v8>=2) then
      begin
      inc(v2,1);
      dec(v8,2);
      end;
   //1
   v1:=v1 shl 1;
   if (v8>=1) then
      begin
      inc(v1,1);
      dec(v8,1);
      end;
   end;
begin
try
//defaults
result:=false;
e:=gecoutofmemory;
//check
if (s='') then
   begin
   s:=gecUnknownformat;
   exit;
   end;
//init
slen:=length(s);
d:='';
dlen:=0;
//get
vc:=0;
vSTOP:=255;//not set
for p:=1 to slen do
begin
v:=byte(s[p]);
//.stop bit
if (v=249) and (vSTOP=255) then vSTOP:=vc;
//.char
if dec7(v) then
   begin
   //decide
   case vc of
   0:v1:=v;
   1:v2:=v;
   2:v3:=v;
   3:v4:=v;
   4:v5:=v;
   5:v6:=v;
   6:v7:=v;
   7:begin
      //get
      v8:=v;
      c8to7;//decode
      //set
      case vSTOP of
      0:;//nil
      1:pushb(dlen,d,char(v1));
      2:pushb(dlen,d,char(v1)+char(v2));
      3:pushb(dlen,d,char(v1)+char(v2)+char(v3));
      4:pushb(dlen,d,char(v1)+char(v2)+char(v3)+char(v4));
      5:pushb(dlen,d,char(v1)+char(v2)+char(v3)+char(v4)+char(v5));
      6:pushb(dlen,d,char(v1)+char(v2)+char(v3)+char(v4)+char(v5)+char(v6));
      else pushb(dlen,d,char(v1)+char(v2)+char(v3)+char(v4)+char(v5)+char(v6)+char(v7));//store 7 chars from 8
      end;
      //reset
      vc:=-1;//will reset to "0"
      end;
   end;//case
   //inc
   inc(vc);
   end;
end;//p
//.finalise
pushb(dlen,d,'');
//successful
result:=true;
except;end;
end;
//## low__fromb128b ##
function low__fromb128b(s:string):string;
var
   e:string;
begin
try;low__fromb128(s,result,e);except;end;
end;
//## low__fromc128b ##
function low__fromc128b(s:string):string;//09feb2015
var
   e:string;
begin
try
//defaults
result:='';
//check
if (s='') then exit;
//get
s:=low__fromb128b(s);
if (s<>'') then low__decompress(s,e);
//set
result:=s;
s:='';
except;end;
end;
//## low__varsfound2 ##
function low__varsfound2(var x:string;xeol,xfind:string):boolean;
var
   xfindlen,xlen,p:longint;
   xeolchar,xfind1,xfind2:char;
begin
try
//defaults
result:=false;
//check
if (xfind='') or (x='') then exit;
//init
xfind:=xfind+': ';
xfindlen:=length(xfind);
xlen:=length(x);
xfind1:=uppercase(xfind[1])[1];
xfind2:=lowercase(xfind[1])[1];
if (xeol<>'') then xeolchar:=xeol[1] else xeolchar:=#10;
//find1
if (not result) and (comparetext(copy(x,1,xfindlen),xfind)=0) then result:=true;
//find2
if (not result) then for p:=1 to (xlen-2) do if ((x[p]=#10) or (x[p]=#13) or (x[p]=xeolchar)) and ((x[p+1]=xfind1) or (x[p+1]=xfind2)) and (comparetext(copy(x,p+1,xfindlen),xfind)=0) then
   begin
   result:=true;
   break;
   end;//p
except;end;
end;
//## low__varsfound ##
function low__varsfound(var x:string;xfind:string):boolean;
begin
try;result:=low__varsfound2(x,'',xfind);except;end;
end;
//## low__varsvalue2 ##
function low__varsvalue2(var x,xvalue:string;xeol,xfind:string):boolean;
var
   p2,xfindlen,xlen,p:longint;
   xeolchar,xfind1,xfind2:char;
   //## xfindvalue ##
   procedure xfindvalue(xfrom:longint);
   var
      i:longint;
   begin
   for i:=xfrom to xlen do if (x[i]=#10) or (x[i]=#13) or (x[i]=xeolchar) then
      begin
      xvalue:=copy(x,xfrom+xfindlen,i-xfindlen-xfrom);
      break;
      end;
   end;
begin
try
//defaults
result:=false;
xvalue:='';
//check
if (xfind='') or (x='') then exit;
//init
xfind:=xfind+': ';
xfindlen:=length(xfind);
xlen:=length(x);
xfind1:=uppercase(xfind[1])[1];
xfind2:=lowercase(xfind[1])[1];
if (xeol<>'') then xeolchar:=xeol[1] else xeolchar:=#10;
//find1
if (not result) and (comparetext(copy(x,1,xfindlen),xfind)=0) then
   begin
   xfindvalue(1);
   result:=true;
   end;
//find2
if (not result) then for p:=1 to (xlen-2) do if ((x[p]=#10) or (x[p]=#13) or (x[p]=xeolchar)) and ((x[p+1]=xfind1) or (x[p+1]=xfind2)) and (comparetext(copy(x,p+1,xfindlen),xfind)=0) then
   begin
   xfindvalue(p+1);
   result:=true;
   break;
   end;//p
except;end;
end;
//## low__varsvalue ##
function low__varsvalue(var x:string;xfind:string):string;
begin
try;low__varsvalue2(x,result,'',xfind);except;end;
end;
//## low__varsint2 ##
function low__varsint2(var x:string;var xvalue:longint;xeol,xfind:string):boolean;
var
   str1:string;
begin
try
xvalue:=0;
result:=low__varsvalue2(x,str1,xeol,xfind);
if result then xvalue:=strint(str1);
except;end;
end;
//## low__varsint ##
function low__varsint(var x:string;xfind:string):longint;
var
   str1:string;
begin
try
result:=0;
if low__varsvalue2(x,str1,'',xfind) then result:=strint(str1);
except;end;
end;
//## low__varssetvalue2 ##
procedure low__varssetvalue2(var x:string;xeol,xfind,xnewvalue:string);//fast - 09may2019
var
   p2,xfindlen,xlen,p:longint;
   xeolchar,xfind1,xfind2:char;
   xdone:boolean;
   //## xwritevalue ##
   procedure xwritevalue(xfrom:longint);
   var
      i:longint;
   begin
   for i:=xfrom to xlen do if (x[i]=#10) or (x[i]=#13) or (x[i]=xeolchar) then
      begin
      x:=copy(x,1,xfrom-1)+xfind+xnewvalue+copy(x,i,xlen);
      xdone:=true;
      break;
      end;
   end;
begin
try
//defaults
xdone:=false;
//check
if (xfind='') then exit;
//init
xfind:=xfind+': ';
xfindlen:=length(xfind);
xlen:=length(x);
xfind1:=uppercase(xfind[1])[1];
xfind2:=lowercase(xfind[1])[1];
if (xeol<>'') then xeolchar:=xeol[1] else xeolchar:=#10;
//append
if (xlen<=0) then
   begin
   x:=x+xfind+xnewvalue+xeolchar;
   exit;
   end;
//find
for p:=1 to (xlen-2) do
begin
if ((x[p]=#10) or (x[p]=#13) or (x[p]=xeolchar) ) and ((x[p+1]=xfind1) or (x[p+1]=xfind2)) and (comparetext(copy(x,p+1,xfindlen),xfind)=0) then
   begin
   xwritevalue(p+1);
   break;
   end
else if (p=1) and (comparetext(copy(x,p,xfindlen),xfind)=0) then
   begin
   xwritevalue(p);
   break;
   end;
end;//p
//append
if not xdone then x:=x+xfind+xnewvalue+xeolchar;
except;end;
end;
//## low__varssetvalue ##
procedure low__varssetvalue(var x:string;xfind,xnewvalue:string);
begin
try;low__varssetvalue2(x,'',xfind,xnewvalue);except;end;
end;
//## low__drives ##
function low__drives:string;//CHAR list of drives - 09nov2019, 16dec2016
var
   drivelist:set of 0..25;
   dc:char;
   p:longint;
begin
try
result:='';
integer(drivelist):=getlogicaldrives;
for p:=0 to 25 do if (p in drivelist) then result:=result+char(p+ord('A'));//A..Z
except;end;
end;
//## low__fromfilec ##
function low__fromfilec(x:string;var y,e:string;_trycount:integer):boolean;
label
     redo;
var
   c:integer;
begin
try
//defaults
result:=false;
e:=gecOutofmemory;
y:='';
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//init
c:=1;
if (_trycount<=-1) then _trycount:=5;//default of 5 retrys
//get
redo:
result:=low__fromfile(x,y,e);
//retry
if (not result) and (e=gecFileInUse) and (c<=_trycount) then
    begin
    //inc
    c:=c+1;
    //random pause & loop
    sleepsafe(50+random(150));
    goto redo;
    end;//end of if
except;end;
end;
//## low__fromfiled ##
function low__fromfiled(x:string):string;
var
   fsize,pos:integer;
   fdate:tdatetime;
   e:string;
begin
try;pos:=0;low__fromfileb(x,result,e,fsize,pos,-1,fdate);except;end;
end;
//## low__fromfile ##
function low__fromfile(x:string;var y,e:string):boolean;
var
   fsize,pos:integer;
   fdate:tdatetime;
begin
try;pos:=0;result:=low__fromfileb(x,y,e,fsize,pos,-1,fdate);except;end;
end;
//## low__fromfileb ##
function low__fromfileb(x:string;var y,e:string;var _filesize,_from:integer;_size:integer;var _date:tdatetime):boolean;//20-OCT-2006
label//Speed: ~5.9Mb/s = 137% faster, 03-OCT-2004
     skipend;
const
   aMAX=32767;
var
   a:array[0..aMAX] of byte;
   i,p,ac:integer;
   b:tfilestream;
begin
try
//error
result:=false;
e:=gecOutOfMemory;
b:=nil;
y:='';
_filesize:=0;
_date:=now;
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//get
//.check
e:=gecFileNotFound;
if not low__fileexists(x) then goto skipend;
//.open
e:=gecFileInUse;
b:=tfilestream.create(x,fmOpenRead+fmShareDenyNone);
//was: if (b<>nil) then sds_inc(sds_Filestream,true);//stats - fixed 29apr2019
_date:=low__dates__fileage(b.handle);//date
_filesize:=b.size;
//._from
if (_from<0) then _from:=0
else if (_from>=b.size) then
   begin
   result:=true;
   goto skipend;
   end;//end of if
b.position:=_from;
//.size
if (_size=0) then//0=read NO data
   begin
   result:=true;
   goto skipend;
   end
else if (_size<0) then _size:=b.size//-X..-1=read ALL data
else if (_size>b.size) then _size:=b.size;//1..X=read SPECIFIED data
e:=gecOutOfMemory;
setlength(y,_size);
i:=0;
//.write
while TRUE do
begin
//.get
ac:=b.read(a,aMAX+1);
//.check
if (ac=0) then break;
//.fill
for p:=0 to frcmax(ac-1,_size-i-1) do
begin
i:=i+1;
y[i]:=chr(a[p]);
end;//end of loop
//.quit
if (i>=_size) then break;
end;//end of loop
//successful
inc(_from,i);
if (b.size=_size) and (_from=0) then result:=(i=_size)
else
   begin
   if (i<>_size) then setlength(y,i);
   result:=(i>=1);
   end;//end of if
skipend:
except;end;
try
if not result then y:='';
freeobj(@b);
except;end;
end;
//## low__dates__filedatetime ##
function low__dates__filedatetime(x:tfiletime):tdatetime;
var
   a:integer;
   c:tfiletime;
begin
try
//defaults
result:=now;
//process
filetimetolocalfiletime(x,c);
if filetimetodosdatetime(c,longrec(a).hi,longrec(a).lo) then result:=filedatetodatetime(a)
else result:=now;
except;end;
end;
//## low__dates__fileage ##
function low__dates__fileage(x:thandle):tdatetime;
var
   a:tbyhandlefileinformation;
begin
try;if (x=0) or (not getfileinformationbyhandle(x,a)) then result:=now else result:=low__dates__filedatetime(a.ftLastWriteTime);except;end;
end;
//## low__fileexists ##
function low__fileexists(x:string):boolean;//19may2019
begin//Use advanced "soft check" with "mf.*" ONLY if "mf" is already running, else fallback down to basic checker - 19may2019
try
result:=false;           //** Always use the simple, local version "mf.fileexists()", as all calling proc's will assume this proc does NOT understand Name Network filenames of "@:\..." - 19may2019
//was: if (fmf<>nil) then result:=mf.fileexists(x) else result:=fileexists(x);
result:=fileexists(x);
except;end;
end;
//## low__makefolder ##
function low__makefolder(x:string):boolean;//19may2019
begin//Use advanced "soft check" with "mf.*" ONLY if "mf" is already running, else fallback down to basic checker - 13aug2019
try
result:=false;           //** Always use the simple, local version "mf.fileexists()", as all calling proc's will assume this proc does NOT understand Name Network filenames of "@:\..." - 19may2019
//check
if (x='') then exit else x:=asfolder(x);
//hack check
if hack_dangerous_filepath_deny_mask(x) then exit;
//get
//if (fmf<>nil) then result:=mf.makefolder(x)
//else
//   begin
   if directoryexists(x) then result:=true
   else
      begin
      forcedirectories(x);
      result:=directoryexists(x);
      end;
//   end;
except;end;
end;
//## low__tofilec2 ##
function low__tofilec2(x,y:string;var e:string;_trycount:integer):boolean;
begin
try;result:=low__tofilec(x,y,e,_trycount);except;end;
end;
//## low__tofilec ##
function low__tofilec(x:string;var y,e:string;_trycount:integer):boolean;
label
     redo;
var
   c:integer;
begin
try
//defaults
result:=false;
e:=gecOutofmemory;
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//prepare
c:=1;
if (_trycount<=-1) then _trycount:=5;//default of 5 retrys
//process
redo:
result:=low__tofile(x,y,e);
//retry
if (not result) and (e=gecFileInUse) and (c<=_trycount) then
    begin
    //inc
    c:=c+1;
    //random pause & loop
    sleepsafe(50+random(150));
    goto redo;
    end;//end of if
except;end;
end;
//## low__tofileb ##
function low__tofileb(x,y:string;var e:string):boolean;//fast and basic low-level
begin
try;result:=low__tofile(x,y,e);except;end;
end;
//## low__tofile ##
function low__tofile(x:string;var y,e:string):boolean;//fast and basic low-level
label
     skipend;
const
   aMAX=32767;
var
   a:array[0..aMAX] of byte;
   yLEN,p,ap:integer;
   b:tfilestream;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
b:=nil;
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//init
yLEN:=length(y);
//get
//.delete
e:=gecFileInUse;
if not low__remfile(x) then goto skipend;
//.folder
if not low__makefolder(extractfilepath(x)) then goto skipend;//13aug2019
//.open
e:=gecFileInUse;
b:=tfilestream.create(x,fmCreate);
//was: if (b<>nil) then sds_inc(sds_Filestream,true);//stats - fixed 29apr2019
//.size
e:=gecOutOfDiskSpace;
b.size:=yLen;
b.position:=0;
p:=1;
ap:=0;
//.write
for p:=1 to yLEN do
begin
//.fill
a[ap]:=byte(y[p]);
//.store
if (ap>=aMAX) or (p=yLEN) then
   begin
   if ((ap+1)<>b.write(a,(ap+1))) then goto skipend;
   ap:=-1;
   end;//end of if
//.inc
inc(ap);
end;//loop
//successful
result:=true;
skipend:
except;end;
try
freeobj(@b);
if not result then low__remfile(x);
except;end;
end;
//## low__tofileappend ##
function low__tofileappend(x:string;var y,e:string):boolean;//07may2019
label
   skipend;
const
   aMAX=32767;
var
   a:array[0..aMAX] of byte;
   bi,yLEN,p,ap:longint;
   b:tfilestream;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
b:=nil;
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//.folder
if not low__makefolder(extractfilepath(x)) then goto skipend;//13aug2019
//init
yLEN:=length(y);
case low__fileexists(x) of
true:b:=tfilestream.create(x,fmOpenWrite+fmShareDenyWrite);
false:b:=tfilestream.create(x,fmCreate);
end;
//was: if (b<>nil) then sds_inc(sds_Filestream,true);//stats - fixed 29apr2019
//get
e:=gecOutOfDiskSpace;
b.position:=b.size;//continue at end of file
p:=1;
ap:=0;
//.write
for p:=1 to yLEN do
begin
//.fill
a[ap]:=byte(y[p]);
//.store
if (ap>=aMAX) or (p=yLEN) then
   begin
   if ((ap+1)<>b.write(a,(ap+1))) then goto skipend;
   ap:=-1;
   end;//end of if
//.inc
inc(ap);
end;//loop
//successful
result:=true;
skipend:
except;end;
try;freeobj(@b);except;end;
end;
//## low__tofileinto ##
function low__tofileinto(x:string;xfrom:longint;var y,e:string):boolean;//fast and basic low-level
label//Note: xfrom is zero based, e.g. 0..(file.size-1)
   skipend;
const
   aMAX=32767;
var
   a:array[0..aMAX] of byte;
   bi,yLEN,p,ap:longint;
   b:tfilestream;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
b:=nil;
//check
if (x='') or (x[1]='@') then
   begin
   e:=gecBadfilename;
   exit;
   end;
//hack check
if hack_dangerous_filepath_deny_mask(x) then
   begin
   e:=gecTaskfailed;
   exit;
   end;
//.folder
if not low__makefolder(extractfilepath(x)) then goto skipend;//13aug2019
//init
yLEN:=length(y);
case low__fileexists(x) of
true:b:=tfilestream.create(x,fmOpenWrite+fmShareDenyWrite);
false:b:=tfilestream.create(x,fmCreate);
end;
//was: if (b<>nil) then sds_inc(sds_Filestream,true);//stats - fixed 29apr2019
//get
e:=gecOutOfDiskSpace;
b.position:=frcmin(xfrom,0);//acts the same way as "mf.nn_tofileinto__keepopen()" - 19may2019
p:=1;
ap:=0;
//.write
for p:=1 to yLEN do
begin
//.fill
a[ap]:=byte(y[p]);
//.store
if (ap>=aMAX) or (p=yLEN) then
   begin
   if ((ap+1)<>b.write(a,(ap+1))) then goto skipend;
   ap:=-1;
   end;//end of if
//.inc
inc(ap);
end;//loop
//successful
result:=true;
skipend:
except;end;
try;freeobj(@b);except;end;
end;
//## driveletterENCODE ##
function driveletterENCODE(filename:string):string;//14APR2011
var// "C:\...\" => exact static filename
   // "c:\...\" => relative dynamic filename (on same disk as EXE and thus will adapt) - 14APR2011
   dA,dU,dL:string;
begin
try
//defaults
result:=filename;
//set - filename MUST be made to conform with relative rules
if (length(result)>=2) and (result[2]=':') and (result[1]<>'/') and (result[1]<>'\') then
   begin
   //init
   dA:=uppercase(copy(application.exename+'*',1,1));//pad with "*" incase app.exename is empty for some reason - 14APR2011
   dU:=uppercase(result[1]);
   dL:=lowercase(result[1]);
   //filter
   if (dU>='A') and (dU<='Z') then
      begin
      //decide
      case (dA[1]<>dU[1]) of
      true:result:=dU+copy(result,2,length(result));//upper case drive letter => filename is STATIC and not relative and must be UPPER CASE to be left as is
      false:result:=dL+copy(result,2,length(result));//lower case drive letter => filename is RELATIVE and on same drive as EXE (relative/portable)
      end;//end of case
      end;//end of if
   end;
except;end;
end;
//## driveletterDECODE ##
function driveletterDECODE(filename:string):string;//14APR2011
var// "C:\...\" => STATIC, exact static filename
   // "c:\...\" => RELATIVE, dynamic filename (on same disk as EXE and thus will adapt) - 14APR2011
   dA,dU,dV:string;
begin
try
//defaults
result:=filename;
//set - filename MUST be made to conform with relative rules
if (length(result)>=2) and (result[2]=':') and (result[1]<>'/') and (result[1]<>'\') then
   begin
   //init
   dA:=uppercase(copy(application.exename+'*',1,1));//pad with "*" incase app.exename is empty for some reason - 14APR2011
   dU:=uppercase(result[1]);
   dV:=result[1];//upper or lower case, we detect the difference and act on it
   //filter
   if (dU>='A') and (dU<='Z') then
      begin
      //make relative
      if (dV<>dU) then result:=dA+copy(result,2,length(result));//lower case drive letter => RELATIVE
      end;//end of if
   end;
except;end;
end;
//## low__remfile ##
function low__remfile(x:string):boolean;
begin
try
//defaults
result:=false;
//hack check
if hack_dangerous_filepath_deny_mask(x) then exit;
//ok
result:=true;
if not low__fileexists(x) then exit;
//error
result:=false;
try;filesetattr(x,0);except;end;
try;deletefile(pchar(x));except;end;
//return result
result:=not low__fileexists(x);
except;end;
end;
//## low__remfilems ##
function low__remfilems(x:string;timeout:integer):boolean;//05FEB2011
var
   waitms:currency;
begin
try
//defaults
result:=false;
//get
waitms:=ms64+frcmin(timeout,0);
//set
repeat
if low__remfile(x) then break else sleepsafe(100+random(50));//pause
until (ms64>=waitms);
except;end;
end;
//## remifext ##
function remifext(x,ext:string):boolean;//deletes files that end with ".ext" - 03MAY2008
var
   xe:string;
   p:integer;
begin
try
//defaults
result:=false;
xe:='';
//check
if (x='') or (ext='') then exit;
if (ext[1]='.') then delete(ext,1,1);
//get
for p:=length(x) downto 1 do if (x[p]='.') then
   begin
   xe:=copy(x,p+1,length(x));
   break;
   end;//end of if
//set
if (comparetext(xe,ext)=0) then result:=low__remfile(x);
except;end;
end;
//## createlink ##
procedure createlink(df,sf,dswitches,iconfilename:string);//24apr2025, 10apr2019, 14NOV2010
var//Note: df=> filename to save link as, sf=filename we are linking to
   //ShlObj, ActiveX, ComObj
  iobject:iunknown;
  islink:ishelllink;
  ipfile:ipersistfile;
begin
try
//defaults
iobject:=nil;
//init
iobject:=createcomobject(CLSID_ShellLink);
islink:=iobject as ishelllink;
ipfile:=iobject as ipersistfile;
//clean
low__remfile(df);
//link
with iSLink do
begin
setarguments(pchar(dswitches));
setpath(pchar(sf));
setworkingdirectory(pchar(extractfilepath(sf)));
if (iconfilename<>'') then seticonlocation(pchar(iconfilename),0);//14NOV2010
end;//end of begin
//.link.save
ipfile.save(pwchar(widestring(df)),false);
except;end;
end;
//## litefiles ##
function litefiles(xmask:string;xfull:boolean):string;
var//files only
   xlistlen,p,i:integer;
   xsearchrec:tsearchrec;
   xfolder:string;
   xfindopen:boolean;
begin
try
//defaults
result:='';
xlistlen:=0;
xfolder:='';
xfindopen:=false;
fillchar(xsearchrec,sizeof(xsearchrec),#0);//03apr2019
//hack check
if hack_dangerous_filepath_allow_mask(xmask) then exit;
//get
if xfull then xfolder:=asfolder(extractfilepath(xmask));
i:=findfirst(xmask,faReadOnly or faHidden or faSysFile or faArchive,xsearchrec);xfindopen:=(i=0);
while (i=0) do
begin
if xfull then pushb(xlistlen,result,xfolder+xsearchrec.name+rcode) else pushb(xlistlen,result,xsearchrec.name+rcode);
i:=findnext(xsearchrec);//inc
end;
except;end;
//finalise
try;if (xlistlen>=1) then pushb(xlistlen,result,'');except;end;
//free memory - fixed 19OCT2010
try;if xfindopen then findclose(xsearchrec);except;end;
end;

//-- Range Support -------------------------------------------------------------
//## frcmin ##
function frcmin(x,min:integer):integer;//14-SEP-2004
begin
try;if (x<min) then x:=min;result:=x;except;end;
end;
//## frcmin64 ##
function frcmin64(x,min:comp):comp;//24jan2016
begin
try;if (x<min) then x:=min;result:=x;except;end;
end;
//## FrcCurMin ##
Function FrcCurMin(X,Min:currency):currency;
begin
try
Result:=X;
If (X<Min) then X:=Min;
Result:=X;
except;end;
end;
//## smallest ##
function smallest(a,b:integer):integer;
begin
try
result:=a;
if (result>b) then result:=b;
except;end;
end;
//## safedate ##
function safedate(x:tdatetime):tdatetime;
begin
try
result:=x;
if (result<-693593) then result:=-693593
else if (result>9000000) then result:=9000000;
except;end;
end;
//## decodedate2 ##
procedure decodedate2(x:tdatetime;var y,m,d:word);//safe range
begin
try;decodedate(safedate(x),y,m,d);except;end;
end;
//## decodetime2 ##
procedure decodetime2(x:tdatetime;var h,min,s,ms:word);//safe range
begin
try;decodetime(safedate(x),h,min,s,ms);except;end;
end;
//## largest ##
function largest(a,b:integer):integer;
begin
try
result:=a;
if (result<b) then result:=b;
except;end;
end;
//## largestrect ##
function largestrect(a,b:trect):trect;//12nov2017
begin
try
result:=a;
if (b.left<result.left) then result.left:=b.left;
if (b.top<result.top) then result.top:=b.top;
if (b.right>result.right) then result.right:=b.right;
if (b.bottom>result.bottom) then result.bottom:=b.bottom;
except;end;
end;
//## smallest64 ##
function smallest64(a,b:comp):comp;
begin
try
result:=a;
if (result>b) then result:=b;
except;end;
end;
//## largest64 ##
function largest64(a,b:comp):comp;
begin
try
result:=a;
if (result<b) then result:=b;
except;end;
end;
//## largestCUR ##
function largestCUR(a,b:currency):currency;//20jan2016
begin
try
result:=a;
if (result<b) then result:=b;
except;end;
end;
//## csmallestex ##
function csmallestex(a:array of currency):currency;//22JAN2008
var
   p:integer;
begin
try
//defaults
result:=maxcur;
//scan
for p:=low(a) to high(a) do if (a[p]<result) then result:=a[p];
except;end;
end;
//## clargestex ##
function clargestex(a:array of currency):currency;//22JAN2008
var
   p:integer;
begin
try
//defaults
result:=mincur;
//scan
for p:=low(a) to high(a) do if (a[p]>result) then result:=a[p];
except;end;
end;
//## frcmax ##
function frcmax(x,max:integer):integer;//14-SEP-2004
begin
try;if (x>max) then x:=max;result:=x;except;end;
end;
//## frcmax64 ##
function frcmax64(x,max:comp):comp;//24jan2016
begin
try;if (x>max) then x:=max;result:=x;except;end;
end;
//## restrict64 ##
function restrict64(x:comp):comp;//24jan2016
begin
try
//range
if (x>max64) then x:=max64
else if (x<min64) then x:=min64;
//set
result:=x;
except;end;
end;
//## restrict32 ##
function restrict32(x:comp):longint;//limit32 - 24jan2016
begin
try
//range
if (x>maxint) then x:=maxint
else if (x<minint) then x:=minint;
//set
result:=round(x);
except;end;
end;
//## FrcCurMax ##
Function FrcCurMax(X,Max:currency):currency;
begin
try
Result:=X;
If (X>Max) then X:=Max;
Result:=X;
except;end;
end;
//## frcrange ##
function frcrange(x,min,max:integer):integer;//13-SEP-2004
begin
try
//filter
if (x<min) then x:=min
else if (x>max) then x:=max;
//return result
result:=x;
except;end;
end;
//## frcrange2 ##
function frcrange2(var x:longint;xmin,xmax:longint):boolean;//29apr2020
begin
try;result:=true;if (x<xmin) then x:=xmin else if (x>xmax) then x:=xmax;except;end;
end;
//## frcrange64 ##
function frcrange64(x,min,max:comp):comp;//24jan2016
begin
try
//filter
if (x<min) then x:=min
else if (x>max) then x:=max;
//return result
result:=x;
except;end;
end;
//## frcrangeex ##
function frcrangeex(x,min,max,defvalue:integer):integer;//14-JAN-2007
begin
try
//defvalue
if (x=0) then x:=defvalue;
//set
result:=frcrange(x,min,max);
except;end;
end;
//## frccurrange ##
function frccurrange(x,min,max:currency):currency;//date: 02-APR-2004
begin
try
result:=x;
if (x<min) then x:=min;
if (x>max) then x:=max;
result:=x;
except;end;
end;
//## frcextmin ##
function frcextmin(x,min:extended):extended;//07NOV20210
begin
try
result:=x;
if (result<min) then result:=min;
except;end;
end;
//## frcextrange ##
function frcextrange(x,min,max:extended):extended;//06JUN2007
begin
try
result:=x;
if (x<min) then x:=min;
if (x>max) then x:=max;
result:=x;
except;end;
end;
//## low__posn ##
function low__posn(x:longint):longint;
begin
try
result:=x;
if (result<0) then result:=-result;
except;end;
end;
//## low__thousands64 ##
function low__thousands64(x:comp):string;//handles full 64bit whole number range of min64..max64 - 24jan2016
const
   sep=',';
var
   i,maxp,p:integer;
   z2,z,y:string;
begin
try
//defaults
result:='0';
//range
x:=restrict64(x);
//get
z2:='';
if (x<0) then
   begin
   x:=-x;
   z2:='-';
   end;//end of if
y:=floattostrex2(x);
z:='';
maxp:=length(y);
i:=0;
for p:=maxp downto 1 do
begin
i:=i+1;
if (i>=3) and (p<>1) then
   begin
   z:=sep+copy(y,p,3)+z;
   i:=0;
   end;//end of if
end;//end of loop
if (i<>0) then z:=copy(y,1,i)+z;
//return result
result:=z2+z;
except;end;
end;
//## low__udv ##
function low__udv(v,dv:string):string;//use default value
begin
try;result:=v;if (result='') then result:=dv;except;end;
end;
//## xintrgb ##
function xintrgb(x:integer):TColor24;
var
   a:tint4;
begin
try
//get
a.val:=x;
//set
result.r:=a.r;
result.g:=a.g;
result.b:=a.b;
except;end;
end;
//## swapint ##
procedure swapint(var x,y:longint);
var
   z:longint;
begin
try
z:=x;
x:=y;
y:=z;
except;end;
end;
//## low__rgbtohex ##
function low__rgbtohex(xrgb:longint):string;//ultra-fast int->hex color converter - 15aug2019
var
   a:tint4;
   v,v2:longint;
begin
try
//defaults
result:='#000000';
//get
a.val:=xrgb;
//.23
v :=a.bytes[0] div 16;
v2:=a.bytes[0]-(v*16);
if (v <=9) then result[2]:=char(48+v ) else result[2]:=char(55+v );
if (v2<=9) then result[3]:=char(48+v2) else result[3]:=char(55+v2);
//.45
v :=a.bytes[1] div 16;
v2:=a.bytes[1]-(v*16);
if (v <=9) then result[4]:=char(48+v ) else result[4]:=char(55+v );
if (v2<=9) then result[5]:=char(48+v2) else result[5]:=char(55+v2);
//.67
v :=a.bytes[2] div 16;
v2:=a.bytes[2]-(v*16);
if (v <=9) then result[6]:=char(48+v ) else result[6]:=char(55+v );
if (v2<=9) then result[7]:=char(48+v2) else result[7]:=char(55+v2);
except;end;
end;
//## low__hextorgb ##
function low__hextorgb(x:string;xdef:longint):longint;
label
   skipend;
var
   r,g,b:longint;
   //## xval ##
   function xval(x:char):longint;
   var
      v:byte;
   begin
   v:=ord(x);
   case v of
   48..57: result:=v-48;
   65..70: result:=v-55;
   97..102:result:=v-87;
   else    result:=0;
   end;//case
   end;
begin
try
//defaults
result:=xdef;
//check
if (x='') then exit;
//init
x:=lowercase(x);
r:=0;
g:=0;
b:=0;
//get
if (x='red') then
   begin
   r:=255;
   g:=0;
   b:=0;
   end
else if (x='green') then
   begin
   r:=0;
   g:=255;
   b:=0;
   end
else if (x='blue') then
   begin
   r:=0;
   g:=0;
   b:=255;
   end
else if (x='black') then
   begin
   r:=0;
   g:=0;
   b:=0;
   end
else if (x='white') then
   begin
   r:=255;
   g:=255;
   b:=255;
   end
else if (x='none') then
   begin
   result:=clnone;
   goto skipend;
   end
else if (x[1]='#') and (length(x)>=4) and (length(x)<7) then
   begin
   r:=xval(x[2])*17;
   g:=xval(x[3])*17;
   b:=xval(x[4])*17;
   end
else if (x[1]='#') and (length(x)>=7) then
   begin
   r:=(xval(x[2])*16)+xval(x[3]);
   g:=(xval(x[4])*16)+xval(x[5]);
   b:=(xval(x[6])*16)+xval(x[7]);
   end
else goto skipend;
//set
result:=rgb(r,g,b);
skipend:
except;end;
end;
//## insint ##
function low__insint(x:integer;y:boolean):longint;
begin
try;if y then result:=x else result:=0;except;end;
end;
//## low__setstring ##
function low__setstring(new:string;var value:string):boolean;
begin
try
//defaults
result:=false;
//process
if (new<>value) then
   begin
   value:=new;
   result:=true;
   end;//end of if
except;end;
end;
//## low__case ##
function low__case(x:string;xuppercase:boolean):string;
begin
try;if xuppercase then result:=uppercase(x) else result:=lowercase(x);except;end;
end;
//## low__remcharb ##
function low__remcharb(x:string;c:char):string;//26apr2019
begin
try;result:=x;low__remchar(result,c);except;end;
end;
//## low__remchar ##
function low__remchar(var x:string;c:char):boolean;//26apr2019
var
   xlen,i,p:integer;
begin
try
//defaults
result:=false;
xlen:=length(x);
i:=0;
//get
if (xlen>=1) then
   begin
   for p:=0 to (xlen-1) do
   begin
   if (x[p+stroffset]=c) then inc(i)
   else if (i<>0) then x[p-i+stroffset]:=x[p+stroffset];
   end;//p
   end;
//shrink
if (i<>0) then setlength(x,xlen-i);
except;end;
end;
//## low__year ##
function low__year(xmin:longint):longint;
var
   y,m,d:word;
begin
try
result:=xmin;
decodedate(now,y,m,d);
if (y>xmin) then result:=y;
except;end;
end;
//## low__yearstr ##
function low__yearstr(xmin:longint):string;
begin
try;result:=inttostr(low__year(xmin));except;end;
end;
//## low__insstr ##
function low__insstr(x:string;y:boolean):string;
begin
try;if y then result:=x else result:='';except;end;
end;
//## low__randomstr ##
function low__randomstr(xlen:longint):string;//19dec2019
var
   p:longint;
begin
try
//defaults
result:='';
if (xlen<1) then exit;
//get
setlength(result,xlen);
for p:=1 to xlen do result[p]:=char(random(256));
except;end;
end;
//## aorb ##
function low__aorb(a,b:longint;xuseb:boolean):longint;
begin
try;if xuseb then result:=b else result:=a;except;end;
end;
//## low__aorbstr ##
function low__aorbstr(a,b:string;xuseb:boolean):string;
begin
try;if xuseb then result:=b else result:=a;except;end;
end;
//## crc32seedable ##
function low__crc32seedable(var x:string;xseed:longint):longint;//14jan2018
var
   xref:array[0..255] of longint;
   k,n,c:longint;
begin
try
//defaults
result:=0;//only zero if "z=''" else non-zero, always
//check
if (x='') then exit;
if (xseed=0) then xseed:=$edb88320;//industry standard seed value
//init
for n:=0 to 255 do
begin
c:=n;
for k:=0 to 7 do if boolean(c and 1) then c:=xseed xor (c shr 1) else c:=c shr 1;
xref[n]:=c;
end;//n
//get
for n:=1 to length(x) do
begin
c:=result xor $ffffffff;
c:=xref[(c xor byte(x[n])) and $ff] xor (c shr 8);
result:=c xor $ffffffff;
end;//n
except;end;
end;
//## low__crc32nonzero ##
function low__crc32nonzero(x:string):longint;
begin
try
//defaults
result:=0;//only zero if "z=''" else non-zero, always
//get
if (x<>'') then
   begin
   result:=low__crc32seedable(x,0);
   if (result=0) then result:=1;
   end;
except;end;
end;
//## To16Bit ##
Function To16Bit(X:String;si:boolean):Integer;
Var
   A:TWrd2;
begin
try
Result:=0;
If (Length(X)<2) then exit;
a.chars[0]:=x[1];
a.chars[1]:=x[2];
case si of
false:result:=a.val;
true:result:=a.si;
end;//end of case
except;end;
end;
//## From16Bit ##
Function From16Bit(X:Integer;si:boolean):String;
Var
   A:TWrd2;
begin
try
case si of
false:a.val:=x;
true:a.si:=x;
end;//end of case
result:=a.chars[0]+a.chars[1];
except;end;
end;
//## to32bit ##
function to32bit(x:string):integer;//29AUG2007
var
   a:tint4;
   p:integer;
begin
try
//defaults
result:=0;
if (length(x)<4) then exit;
//get
a.chars[0]:=x[1];
a.chars[1]:=x[2];
a.chars[2]:=x[3];
a.chars[3]:=x[4];
//set
result:=a.val;
except;end;
end;
//## from32bit ##
function from32bit(x:integer):string;//29AUG2007
var
   a:tint4;
begin
try
//defaults
a.val:=x;
result:='####';
//set
result[1]:=a.chars[0];
result[2]:=a.chars[1];
result[3]:=a.chars[2];
result[4]:=a.chars[3];
except;end;
end;
//## from8bit2 ##
function from8bit2(x:byte):string;//05mar2018
begin
try
//defaults
result:=#0#0;//2 bytes
//get
result[1]:=char(65+(x div 16));
result[2]:=char(65+x-((x div 16)*16));
except;end;
end;
//## to8bit2 ##
function to8bit2(x:string):byte;//09nov2019, 05mar2018
var
   v1,v2:longint;
begin
try
//defaults
result:=0;
if (length(x)<2) then exit;
//get
v1:=byte(x[1])-65;if (v1<0) then v1:=0 else if (v1>15) then v1:=15;//restricted upper limits - 09nov2019
v2:=byte(x[2])-65;if (v2<0) then v2:=0 else if (v2>15) then v2:=15;
result:=byte((v1*16)+v2);
except;end;
end;
//## to32bit8 ##
function to32bit8(x:string):longint;//09nov2019, 03mar2018
var
   a:tint4;
   v1,v2:longint;
begin
try
//defaults
result:=0;
if (length(x)<8) then exit;
//r
v1:=byte(x[1])-65;if (v1<0) then v1:=0 else if (v1>15) then v1:=15;//restricted upper limits - 09nov2019
v2:=byte(x[2])-65;if (v2<0) then v2:=0 else if (v2>15) then v2:=15;
a.bytes[0]:=byte((v1*16)+v2);
//g
v1:=byte(x[3])-65;if (v1<0) then v1:=0 else if (v1>15) then v1:=15;
v2:=byte(x[4])-65;if (v2<0) then v2:=0 else if (v2>15) then v2:=15;
a.bytes[1]:=byte((v1*16)+v2);
//b
v1:=byte(x[5])-65;if (v1<0) then v1:=0 else if (v1>15) then v1:=15;
v2:=byte(x[6])-65;if (v2<0) then v2:=0 else if (v2>15) then v2:=15;
a.bytes[2]:=byte((v1*16)+v2);
//t
v1:=byte(x[7])-65;if (v1<0) then v1:=0 else if (v1>15) then v1:=15;
v2:=byte(x[8])-65;if (v2<0) then v2:=0 else if (v2>15) then v2:=15;
a.bytes[3]:=byte((v1*16)+v2);
//get
result:=a.val;
except;end;
end;
//## from32bit8 ##
function from32bit8(x:longint):string;//03mar2018
var
   a:tint4;
begin
try
//defaults
result:=#0#0#0#0#0#0#0#0;//8 bytes
a.val:=x;
//r
result[1]:=char(65+(a.r div 16));
result[2]:=char(65+a.r-((a.r div 16)*16));
//g
result[3]:=char(65+(a.g div 16));
result[4]:=char(65+a.g-((a.g div 16)*16));
//b
result[5]:=char(65+(a.b div 16));
result[6]:=char(65+a.b-((a.b div 16)*16));
//t
result[7]:=char(65+(a.t div 16));
result[8]:=char(65+a.t-((a.t div 16)*16));
except;end;
end;
//## from24bit6 ##
function from24bit6(x:longint):string;//03mar2018
var
   a:tint4;
begin
try
//defaults
result:=#0#0#0#0#0#0;//6 bytes
a.val:=x;
//r
result[1]:=char(65+(a.r div 16));
result[2]:=char(65+a.r-((a.r div 16)*16));
//g
result[3]:=char(65+(a.g div 16));
result[4]:=char(65+a.g-((a.g div 16)*16));
//b
result[5]:=char(65+(a.b div 16));
result[6]:=char(65+a.b-((a.b div 16)*16));
except;end;
end;
//## from24rgb6 ##
function from24rgb6(r,g,b:byte):string;//03mar2018
begin
try
//defaults
result:=#0#0#0#0#0#0;//6 bytes
//r
result[1]:=char(65+(r div 16));
result[2]:=char(65+r-((r div 16)*16));
//g
result[3]:=char(65+(g div 16));
result[4]:=char(65+g-((g div 16)*16));
//b
result[5]:=char(65+(b div 16));
result[6]:=char(65+b-((b div 16)*16));
except;end;
end;
//## To64Bit ##
function To64Bit(x:string):currency;//updated: 02-APRIL-2004
Var
   a:TCur8;
   p:integer;
begin
try
{default}
result:=0;
{check}
If (length(x)<8) then exit;
{process}
for p:=1 to 8 do A.chars[p-1]:=x[p];
{return result}
result:=a.val;
except;end;
end;
//## From64Bit ##
function From64Bit(x:currency):string;//updated: 02-APRIL-2004
Var
   a:TCur8;
   p:integer;
begin
try
{prepare}
a.val:=X;
result:='########';
{process}
for p:=1 to 8 do result[p]:=a.chars[p-1];
except;end;
end;
//## from80bit ##
function from80bit(x:text10):string;//24feb2016
begin
try;result:=x.chars[0]+x.chars[1]+x.chars[2]+x.chars[3]+x.chars[4]+x.chars[5]+x.chars[6]+x.chars[7]+x.chars[8]+x.chars[9];except;end;
end;
//## to80bit ##
function to80bit(x:string):text10;//24feb2016
begin
try
//range
if (length(x)<10) then x:=#0#0#0#0#0#0#0#0#0#0;
//get
result.chars[0]:=x[1];
result.chars[1]:=x[2];
result.chars[2]:=x[3];
result.chars[3]:=x[4];
result.chars[4]:=x[5];
result.chars[5]:=x[6];
result.chars[6]:=x[7];
result.chars[7]:=x[8];
result.chars[8]:=x[9];
result.chars[9]:=x[10];
except;end;
end;
//## fromext80 ##
function fromext80(v:extended):string;
var
   x:text10;
begin
try
x.val:=v;
result:=x.chars[0]+x.chars[1]+x.chars[2]+x.chars[3]+x.chars[4]+x.chars[5]+x.chars[6]+x.chars[7]+x.chars[8]+x.chars[9];
except;end;
end;
//## toext80 ##
function toext80(v:string):extended;
var
   x:text10;
begin
try
//range
if (length(v)<10) then v:=#0#0#0#0#0#0#0#0#0#0;
//get
x.chars[0]:=v[1];
x.chars[1]:=v[2];
x.chars[2]:=v[3];
x.chars[3]:=v[4];
x.chars[4]:=v[5];
x.chars[5]:=v[6];
x.chars[6]:=v[7];
x.chars[7]:=v[8];
x.chars[8]:=v[9];
x.chars[9]:=v[10];
result:=x.val;
except;end;
end;
//## tocomp64 ##
function tocomp64(x:string):comp;//full 64bit support - 22jan2016
var
   a:tcomp8;
begin
try
//get
result:=0;
if (length(x)<8) then exit;
//set
a.chars[0]:=x[1];
a.chars[1]:=x[2];
a.chars[2]:=x[3];
a.chars[3]:=x[4];
a.chars[4]:=x[5];
a.chars[5]:=x[6];
a.chars[6]:=x[7];
a.chars[7]:=x[8];
result:=a.val;
except;end;
end;
//## tocomp642 ##
procedure tocomp642(x:string;var y:tcomp8);//full 64bit support - 21feb2016
begin
try
//range
if (length(x)<8) then x:=#0#0#0#0#0#0#0#0;
//get
y.chars[0]:=x[1];
y.chars[1]:=x[2];
y.chars[2]:=x[3];
y.chars[3]:=x[4];
y.chars[4]:=x[5];
y.chars[5]:=x[6];
y.chars[6]:=x[7];
y.chars[7]:=x[8];
except;end;
end;
//## fromcomp64 ##
function fromcomp64(x:comp):string;//full 64bit support - 22jan2016
var
   a:tcomp8;
begin
try
//get
result:=#0#0#0#0#0#0#0#0;
a.val:=x;
//set
result[1]:=a.chars[0];
result[2]:=a.chars[1];
result[3]:=a.chars[2];
result[4]:=a.chars[3];
result[5]:=a.chars[4];
result[6]:=a.chars[5];
result[7]:=a.chars[6];
result[8]:=a.chars[7];
except;end;
end;
//## fromcomp642 ##
function fromcomp642(var x:tcomp8):string;//full 64bit support - 21feb2016
begin//Guaranteed no loss of data by referencing "tcomp8" directly
try
//get
result:=#0#0#0#0#0#0#0#0;
//set
result[1]:=x.chars[0];
result[2]:=x.chars[1];
result[3]:=x.chars[2];
result[4]:=x.chars[3];
result[5]:=x.chars[4];
result[6]:=x.chars[5];
result[7]:=x.chars[6];
result[8]:=x.chars[7];
except;end;
end;

//-- Image and Array Support ---------------------------------------------------
//## low__maplist ##
function low__maplist(const x:array of byte):tlistptr;
begin
try
//defaults
result.count:=0;
result.bytes:=nil;
//get
if (low(x)=0) then
   begin
   result.count:=high(x)+1;
   result.bytes:=@x;
   end;
except;end;
end;
//## low__mapstr8 ##
function low__mapstr8(x:tstr8):tlistptr;
begin
try
//defaults
result.count:=0;
result.bytes:=nil;
//get
if (x<>nil) then
   begin
   result.count:=x.count;
   result.bytes:=x.pbytes;
   end;
except;end;
end;
//## misbmp ##
function misbmp(dbits,dw,dh:longint):tbmp;
begin//Note: Flow now goes -> ask for bits -> get what we can get -> must check what bits we actually got under Android etc - 03may2020
try
result:=nil;
dw:=frcmin(dw,1);
dh:=frcmin(dh,1);
result:=tbmp.create;
result.setparams(dbits,dw,dh);
except;end;
end;
//## misset_brushcolor ##
function misset_brushcolor(x:tobject;xval:longint):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   (x as tbmp).canvas.brush.color:=xval;
{$endif}
{$ifdef a32}
   (x as tbmp).canvas.fill.color:=xval;
{$endif}
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   (x as tbitmap).canvas.brush.color:=xval;
{$endif}
{$ifdef a32}
   (x as tbitmap).canvas.fill.color:=xval;
{$endif}
   result:=true;
   end;
except;end;
end;
//## misset_brushclear ##
function misset_brushclear(x:tobject;xval:boolean):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   case xval of
   true:(x as tbmp).canvas.brush.style:=bsclear;
   false:(x as tbmp).canvas.brush.style:=bssolid;
   end;//case
{$endif}
{$ifdef a32}
   case xval of
   true:(x as tbmp).canvas.fill.kind:=tbrushkind.none;
   false:(x as tbmp).canvas.fill.kind:=tbrushkind.solid;
   end;//case
{$endif}
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   case xval of
   true:(x as tbitmap).canvas.brush.style:=bsclear;
   false:(x as tbitmap).canvas.brush.style:=bssolid;
   end;//case
{$endif}
{$ifdef a32}
   case xval of
   true:(x as tbitmap).canvas.fill.kind:=tbrushkind.none;
   false:(x as tbitmap).canvas.fill.kind:=tbrushkind.solid;
   end;//case
{$endif}
   result:=true;
   end;
except;end;
end;
//## misset_fontcolor ##
function misset_fontcolor(x:tobject;xval:longint):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas and (not (x as tbmp).sharp) then
   begin
{$ifdef w32}
   (x as tbmp).canvas.font.color:=xval;
{$endif}
//xxxxxxxxxxxxxxxxxxx//???????????????????//D10: Nno support for this yet!!!!
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   (x as tbitmap).canvas.font.color:=xval;
{$endif}
//xxxxxxxxxxxxxxxxxxx//???????????????????//D10: Nno support for this yet!!!!
   result:=true;
   end;
except;end;
end;
//## misset_fontname ##
function misset_fontname(x:tobject;xval:string):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas and (not (x as tbmp).sharp) then
   begin
{$ifdef w32}
   (x as tbmp).canvas.font.name:=xval;
{$endif}
{$ifdef a32}
   (x as tbmp).canvas.font.family:=xval;
{$endif}
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   (x as tbitmap).canvas.font.name:=xval;
{$endif}
{$ifdef a32}
   (x as tbitmap).canvas.font.family:=xval;
{$endif}
   result:=true;
   end;
except;end;
end;
//## misset_fontsize ##
function misset_fontsize(x:tobject;xval:longint):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//range
xval:=frcmin(xval,5);
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas and (not (x as tbmp).sharp) then
   begin
   (x as tbmp).canvas.font.size:=xval;
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
   (x as tbitmap).canvas.font.size:=xval;
   result:=true;
   end;
except;end;
end;
//## misset_fontheight ##
function misset_fontheight(x:tobject;xval:longint):boolean;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas and (not (x as tbmp).sharp) then
   begin
{$ifdef w32}
   (x as tbmp).canvas.font.height:=xval;
{$endif}
{$ifdef a32}
   (x as tbmp).canvas.font.size:=-xval;
{$endif}
//xxxxxxxxxxxxx//?????????????????//D10: Not sure if this works
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   (x as tbitmap).canvas.font.height:=xval;
{$endif}
{$ifdef a32}
   (x as tbitmap).canvas.font.size:=-xval;
{$endif}
//xxxxxxxxxxxxx//?????????????????//D10: Not sure if this works
   result:=true;
   end;
except;end;
end;
//## misset_fontstyle ##
function misset_fontstyle(x:tobject;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;
var
   a:tfontstyles;
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
a:=[];
{$ifdef w32}
if xbold       then a:=a+[fsbold];
if xitalic     then a:=a+[fsitalic];
if xunderline  then a:=a+[fsunderline];
if xstrikeout  then a:=a+[fsstrikeout];
{$endif}
{$ifdef a32}
if xbold       then a:=a+[tfontstyle.fsbold];
if xitalic     then a:=a+[tfontstyle.fsitalic];
if xunderline  then a:=a+[tfontstyle.fsunderline];
if xstrikeout  then a:=a+[tfontstyle.fsstrikeout];
{$endif}

//set
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas and (not (x as tbmp).sharp) then
   begin
   (x as tbmp).canvas.font.style:=a;
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
   (x as tbitmap).canvas.font.style:=a;
   result:=true;
   end;
except;end;
end;
//## misset_textextent ##
function misset_textextent(x:tobject;xval:string):tpoint;
{$ifdef w32}
var
   a:tsize;
{$endif}
begin
try
//defaults
result.x:=0;
result.y:=0;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   a:=(x as tbmp).canvas.textextent(xval);
   result.x:=a.cx;
   result.y:=a.cy;
{$endif}
{$ifdef a32}
   result.x:=round((x as tbmp).canvas.textwidth(xval));
   result.y:=round((x as tbmp).canvas.textheight(xval));
{$endif}
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   a:=(x as tbitmap).canvas.textextent(xval);
   result.x:=a.cx;
   result.y:=a.cy;
{$endif}
{$ifdef a32}
   result.x:=round((x as tbitmap).canvas.textwidth(xval));
   result.y:=round((x as tbitmap).canvas.textheight(xval));
{$endif}
   end;
except;end;
end;
//## misset_textwidth ##
function misset_textwidth(x:tobject;xval:string):longint;
begin
try
//defaults
result:=0;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   result:=(x as tbmp).canvas.textwidth(xval);
{$endif}
{$ifdef a32}
   result:=round((x as tbmp).canvas.textwidth(xval));
{$endif}
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   result:=(x as tbitmap).canvas.textwidth(xval);
{$endif}
{$ifdef a32}
   result:=round((x as tbitmap).canvas.textwidth(xval));
{$endif}
   end;
except;end;
end;
//## misset_textheight ##
function misset_textheight(x:tobject;xval:string):longint;
begin
try
//defaults
result:=0;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   result:=(x as tbmp).canvas.textheight(xval);
{$endif}
{$ifdef a32}
   result:=round((x as tbmp).canvas.textheight(xval));
{$endif}
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   result:=(x as tbitmap).canvas.textheight(xval);
{$endif}
{$ifdef a32}
   result:=round((x as tbitmap).canvas.textheight(xval));
{$endif}
   end;
except;end;
end;
//## mis_textrect ##
function mis_textrect(x:tobject;xarea:trect;dx,dy:longint;xval:string):boolean;
{$ifdef a32}
var
   da,ta:trectf;
   dc:talphacolor;
{$endif}
begin
try
//defaults
result:=false;
//check
if (x=nil) then exit;
//get
//.bmp
if (x is tbmp) and (x as tbmp).cancanvas then
   begin
{$ifdef w32}
   (x as tbmp).canvas.textrect(xarea,dx,dy,xval);
{$endif}
{$ifdef a32}
   da.left:=xarea.left;
   da.right:=xarea.right;
   da.top:=xarea.top;
   da.bottom:=xarea.bottom;
   //cls
   (x as tbmp).canvas.clearrect(da,dc);
   //text
   ta.left:=dx;
   if (ta.left<xarea.left) then ta.left:=xarea.left;
   ta.right:=xarea.right;
   ta.top:=dy;
   if (ta.top<xarea.top) then ta.top:=xarea.top;
   ta.bottom:=xarea.bottom;
   (x as tbmp).canvas.filltext(ta,xval,false,255,[],ttextalign.leading);
{$endif}
   result:=true;
   end
//.bitmap
else if (x is tbitmap) then
   begin
{$ifdef w32}
   (x as tbitmap).canvas.textrect(xarea,dx,dy,xval);
{$endif}
{$ifdef a32}
   da.left:=xarea.left;
   da.right:=xarea.right;
   da.top:=xarea.top;
   da.bottom:=xarea.bottom;
   //cls
   (x as tbitmap).canvas.clearrect(da,dc);
   //text
   ta.left:=dx;
   if (ta.left<xarea.left) then ta.left:=xarea.left;
   ta.right:=xarea.right;
   ta.top:=dy;
   if (ta.top<xarea.top) then ta.top:=xarea.top;
   ta.bottom:=xarea.bottom;
   (x as tbitmap).canvas.filltext(ta,xval,false,255,[],ttextalign.leading);
{$endif}
   result:=true;
   end;
except;end;
end;
//## misrect ##
function misrect(x,y,x2,y2:longint):trect;
begin
try
result.left:=x;
result.top:=y;
result.right:=x2;
result.bottom:=y2;
except;end;
end;
//## misb ##
function misb(s:tobject):longint;//bits 0..N
begin
try
//defaults
result:=0;
//get
if (s=nil) then exit
//.bmp
else if (s is tbmp) then result:=(s as tbmp).bits
//.image
//else if (s is tbasicimage) then result:=(s as tbasicimage).bits
//.bitmap
else if (s is tbitmap) then
   begin
   if      (s as tbitmap).monochrome             then result:=1//26may2019
   else if ((s as tbitmap).pixelformat=pf1bit)   then result:=1
   else if ((s as tbitmap).pixelformat=pf4bit)   then result:=4
   else if ((s as tbitmap).pixelformat=pf8bit)   then result:=8
   else if ((s as tbitmap).pixelformat=pf15bit)  then result:=15
   else if ((s as tbitmap).pixelformat=pf16bit)  then result:=16
   else if ((s as tbitmap).pixelformat=pf24bit)  then result:=24
   else if ((s as tbitmap).pixelformat=pf32bit)  then result:=32;
   end;
except;end;
end;
//## misw ##
function misw(s:tobject):longint;
begin
try
result:=0;
if (s=nil)                 then exit
else if (s is tbmp)        then result:=(s as tbmp).width
else if (s is tbitmap)     then result:=(s as tbitmap).width;
except;end;
end;
//## mish ##
function mish(s:tobject):longint;
begin
try
result:=0;
if (s=nil)                 then exit
else if (s is tbmp)        then result:=(s as tbmp).height
else if (s is tbitmap)     then result:=(s as tbitmap).height;
except;end;
end;
//## mishasai ##
function mishasai(s:tobject):boolean;
begin
try
result:=false;
if (s=nil)                 then exit
else if (s is tbmp)        then result:=true
else if (s is tbitmap)     then result:=false;
except;end;
end;
//## mismustlock ##
function mismustlock(s:tobject):boolean;
begin
try
result:=false;
if      (s=nil)      then exit
else if (s is tbmp)  then result:=not (s as tbmp).locked;
except;end;
end;
//## mislock ##
function mislock(s:tobject):boolean;
begin
try
result:=false;
if      (s=nil)      then exit
else if (s is tbmp)  then
   begin
   if not (s as tbmp).locked then
      begin
      (s as tbmp).lock;
      result:=(s as tbmp).locked;
      end;
   end;
except;end;
end;
//## misunlock ##
function misunlock(s:tobject):boolean;
begin
try
result:=false;
if      (s=nil)      then exit
else if (s is tbmp)  then
   begin
   if (s as tbmp).locked then
      begin
      (s as tbmp).unlock;
      result:=not (s as tbmp).locked;
      end;
   end;
except;end;
end;
//## misinfo ##
function misinfo(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
try
result:=false;
sbits:=0;
sw:=0;
sh:=0;
shasai:=false;
if (s=nil) then exit;
sbits:=misb(s);
sw:=misw(s);
sh:=mish(s);
shasai:=mishasai(s);
result:=(sw>=1) and (sh>=1) and (sbits>=1);
except;end;
end;
//## misinfo82432 ##
function misinfo82432(s:tobject;var sbits,sw,sh:longint;var shasai:boolean):boolean;
begin
try;result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24) or (sbits=32));except;end;
end;
//## misok824 ##
function misok824(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
try;result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24));except;end;
end;
//## misok82432 ##
function misok82432(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
try;result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=8) or (sbits=24) or (sbits=32));except;end;
end;
//## misok2432 ##
function misok2432(s:tobject;var sbits,sw,sh:longint):boolean;
var
   shasai:boolean;
begin
try;result:=misinfo(s,sbits,sw,sh,shasai) and ((sbits=24) or (sbits=32));except;end;
end;
//## misscan ##
function misscan(s:tobject;sy:longint;pr:pointer):boolean;
var
   sw,sh:longint;
begin
try
//defaults
result:=false;
if (pr=nil) then exit else tpointer(pr^):=nil;//reply is "nil" by default
//init
sw:=misw(s);
sh:=mish(s);
if (sw<=0) or (sh<=0) then exit;
//range
if (sy<0) then sy:=0 else if (sy>=sh) then sy:=sh-1;
//get
if (s is tbmp) then
   begin
   if (s as tbmp).canrows then tpointer(pr^):=tpointer((s as tbmp).prows24[sy]);
   end
else if (s is tbitmap) then tpointer(pr^):=(s as tbitmap).scanline[sy];
//set
result:=(tpointer(pr^)<>nil);
except;end;
end;
//## misscan824 ##
function misscan824(s:tobject;sy:longint;pr8,pr24:pointer):boolean;
var
   sbits:longint;
begin
try
result:=false;
if (pr8<>nil) and (pr24<>nil) then
   begin
   sbits:=misb(s);
   result:=((sbits=8) or (sbits=24)) and misscan(s,sy,@pr24^);
   tpointer(pr8^):=tpointer(pr24^);
   end;
except;end;
end;
//## missize ##
function missize(s:tobject;dw,dh:longint):boolean;
label
   skipend;
begin
try
//defaults
result:=false;
//check
if (s=nil) then exit;
//range
dw:=frcmin(dw,1);
dh:=frcmin(dh,1);
//.bmp
if (s is tbmp) then
   begin
   if (dw<>(s as tbmp).width) or (dh<>(s as tbmp).height) then
      begin
      //check
      if not (s as tbmp).cansetparams then goto skipend;
      //shrink
      (s as tbmp).setparams((s as tbmp).bits,1,1);
      //enlarge
      result:=(s as tbmp).setparams((s as tbmp).bits,dw,dh);
      end
   else result:=true;
   end
//.bitmap
else if (s is tbitmap) then
   begin
   if (dw<>(s as tbitmap).width) or (dh<>(s as tbitmap).height) then
      begin
      //shrink
      (s as tbitmap).height:=1;
      (s as tbitmap).width:=1;
      //enlarge
      (s as tbitmap).width:=dw;
      (s as tbitmap).height:=dh;
      end;
   //successful
   result:=true;
   end;
skipend:
except;end;
end;
//## mispixel ##
function mispixel(s:tobject;sx,sy:longint):longint;
var
   sr32:pcolorrow32;
   sr24:pcolorrow24;
   sr8 :pcolorrow8;
   sbits,sw,sh:longint;
   c32:tcolor32;
   c24:tcolor24;
   c8 :tcolor8;
begin
try
result:=clnone;
if misok82432(s,sbits,sw,sh) and (sx>=0) and (sx<sw) and (sy>=0) and (sy<sh) and misscan(s,sy,@sr8) then
   begin
   tpointer(sr24):=tpointer(sr8);
   tpointer(sr32):=tpointer(sr8);
   //.32
   if      (sbits=32) then
      begin
      c32:=sr32[sx];
      result:=low__rgb(c32.r,c32.g,c32.b);
      end
   //.24
   else if (sbits=24) then
      begin
      c24:=sr24[sx];
      result:=low__rgb(c24.r,c24.g,c24.b);
      end
   //.8
   else if (sbits=8) then
      begin
      c8:=sr8[sx];
      result:=low__rgb(c8,c8,c8);
      end;
   end;
except;end;
end;
//## low__newbmp24 ##
function low__newbmp24:tbitmap;
begin
try
result:=nil;
result:=tbitmap.create;
result.pixelformat:=pf24bit;
result.width:=1;
result.height:=1;
except;end;
end;
//## low__compareint ##
function low__compareint(x,xval:longint):boolean;
begin
try
result:=(x=xval);
if not result then
   begin
   if (x>=97) and (x<=122)       then dec(x,32);//a-z -> A-Z
   if (xval>=97) and (xval<=122) then dec(xval,32);//a-z -> A-Z
   result:=(x=xval);
   end;
except;end;
end;
//## low__findimgformat ##
function low__findimgformat(var x,format:string;var xbase64:boolean):boolean;
label
   redo;
var
   xraw,zu:string;
   xonce:boolean;
begin
try
//defaults
result:=false;
xbase64:=false;
xonce:=true;
xraw:=copy(x,1,300);//take a copy
redo:
zu:=uppercase(xraw);
//get
if (copy(zu,1,2)='BM') then format:='BMP'
else if (copy(zu,1,5)='TEA1#') then format:='TEA'
else if (copy(zu,1,5)='TEM1#') or (copy(zu,2,5)='TEM1#') or (copy(zu,3,5)='TEM1#') then format:='TEM'
else if (copy(zu,1,5)='TEH1#') or (copy(zu,2,5)='TEH1#') or (copy(zu,3,5)='TEH1#') then format:='TEH'
else if (copy(zu,1,4)='B64:') then
   begin
   if xonce then
      begin
      xonce:=false;
      xbase64:=true;
      xraw:=low__fromb64b(copy(xraw,5,length(xraw)));//skip over "b64:" header
      goto redo;
      end;
   end
else if (copy(zu,7,4)='JFIF') then format:='JPG'
else if (copy(zu,1,3)=#255#216#255) then format:='JPG';//for ALL jpegs FF,D8,FF = first 3 reliably identical bytes
//successful
result:=(format<>'');
except;end;
end;
//## low__toimgdata ##
function low__toimgdata(s:tbitmap;dformat:string;var ddata,e:string):boolean;//02jun2020
label//xformat: BMP, JPG, JIF, JPEG, TEM, TEH, TEA, RAW24, RAW32
   skipend;
var
   a:tbitmap;
   m:tstreamstr;
{$ifdef jpeg}
   j:tjpegimage;
{$endif}
{$ifdef nojpeg}
   j:tobject;
{$endif}
   s8:tstr8;
   int1,int2,int3:longint;
   bol2:boolean;
   //## ainit ##
   procedure ainit;
   begin
   if (a=nil) then
      begin
      a:=tbitmap.create;
      a.assign(s);
      a.pixelformat:=pf24bit;
      end;
   end;
   //## minit ##
   procedure minit;
   begin
   if (m=nil) then m:=tstreamstr.create(@ddata);
   end;
   //## jinit ##
   procedure jinit;
   begin
{$ifdef jpeg}
   if (j=nil) then j:=tjpegimage.create;
{$endif}
   end;
begin
try
//defaults
result:=false;
e:='Task failed';
a:=nil;
m:=nil;
{$ifdef jpeg}
j:=nil;
{$endif}
s8:=nil;
dformat:=uppercase(dformat);
ddata:='';
//check
if (s=nil) or (s.width<1) or (s.height<1) then goto skipend;
//get
if (dformat='BMP') then
   begin
   ainit;
   minit;
   a.savetostream(m);
   end
else if (dformat='JPG') or (dformat='JIF') then
   begin
{$ifdef jpeg}
   e:='Out of memory';
   jinit;
   j.assign(s);
   minit;
   j.savetostream(m);
{$endif}
{$ifdef nojpeg}
   e:='Image format not supported: '+dformat;
   goto skipend;
{$endif}
   end
else if (dformat='JPEG') then//automatically create best size jpeg with good quality
   begin
   //init
{$ifdef jpeg}
   e:='Out of memory';
   jinit;
   j.assign(s);
   int2:=100;//start at 100% and step down till there is no error -> Dephi's JPEG is prone to fail at high-quality and large image sizes -> e.g. ~1200x800 @ 100% failes - 06aug2019
   //get
   minit;
   while true do
   begin
   bol2:=false;
   try;j.compressionquality:=int2;j.savetostream(m);bol2:=true;except;end;
   if bol2 then break;
   dec(int2,5);
   if (int2<=10) then break;
   end;//while
   //.error
   if not bol2 then goto skipend;
{$endif}
{$ifdef nojpeg}
   e:='Image format not supported: '+dformat;
   goto skipend;
{$endif}
   end
else if (dformat='TEM') then
   begin
   ainit;
   if not low__totem(a,false,ddata) then goto skipend;
   end
else if (dformat='TEH') then
   begin
   ainit;
   if not low__toteh(a,false,ddata) then goto skipend;
   end
else if (dformat='TEA') then
   begin
   ainit;
   s8:=newstr8(0);
   if not low__teamake(a,s8,e) then goto skipend;
   ddata:=s8.text;
   end
else if (dformat='RAW24') then
   begin
   ainit;
   if not low__bmptoraw24(a,ddata,int1,int2,int3) then goto skipend;
   end
else if (dformat='RAW32') then
   begin
   ainit;
   if not low__bmptoraw32(a,ddata,int1,int2,int3) then goto skipend;
   end
else
   begin
   e:='Unsupported format';
   goto skipend;
   end;
//successful
result:=true;
skipend:
except;end;
try
if not result then ddata:='';//reset
freeobj(@a);
freeobj(@s8);
{$ifdef jpeg}
freeobj(@j);
{$endif}
freeobj(@m);//do last
except;end;
end;
//## low__fromimgdata2 ##
function low__fromimgdata2(a:tbitmap;xdata:array of byte;var e:string):boolean;//02jun2020
var
   b:tstr8;
   str1,xformat:string;
begin
try
//defaults
result:=false;
b:=nil;
e:=gecTaskfailed;
//get
b:=newstr84(xdata);
str1:=b.text;
freeobj(@b);
//set
result:=low__fromimgdata(a,xformat,str1,e);
except;end;
try;freeobj(@b);except;end;
end;
//## low__fromimgdata ##
function low__fromimgdata(a:tbitmap;var xformat,xdata,e:string):boolean;//02jun2020
label//xformat: BMP, JPG, JIF, JPEG, TEM, TEH, TEA - 02jun2020
   skipend;
var
   m:tstreamstr;
{$ifdef jpeg}
   j:tjpegimage;
{$endif}
{$ifdef nojpeg}
   j:tobject;
{$endif}
   s:tstr8;
   int1,int2:longint;
   xbase64:boolean;
   //## a24 ##
   procedure a24;
   begin
   a.pixelformat:=pf24bit;
   end;
   //## minit ##
   procedure minit;
   begin
   if (m=nil) then m:=tstreamstr.create(@xdata);
   m.position:=0;
   end;
   //## jinit ##
   procedure jinit;
   begin
{$ifdef jpeg}
   if (j=nil) then j:=tjpegimage.create;
{$endif}
   end;
begin
try
//defaults
result:=false;
e:='Task failed';
m:=nil;
{$ifdef jpeg}
j:=nil;
{$endif}
s:=nil;
xformat:='';
//check
if (a=nil) then goto skipend;
//init
if not low__findimgformat(xdata,xformat,xbase64) then
   begin
   e:='Unknown format';
   goto skipend;
   end;
//.a
a.width:=1;
a.height:=1;
a24;
//decode
if xbase64 then
   begin
   delete(xdata,1,4);//remove the "b64:" header
   xdata:=low__fromb64b(xdata);
   end;
//get
if (xformat='BMP') then
   begin
   minit;
   a.loadfromstream(m);
   end
else if (xformat='JPG') then
   begin
{$ifdef jpeg}
   minit;
   jinit;
   j.loadfromstream(m);
   a.assign(j);
{$endif}
{$ifdef nojpeg}
   e:='Image format not supported: '+xformat;
   goto skipend;
{$endif}
   end
else if (xformat='TEM') then
   begin
   if not low__fromtem(a,xdata) then goto skipend;
   end
else if (xformat='TEH') then
   begin
   if not low__fromteh(a,xdata) then goto skipend;
   end
else if (xformat='TEA') then
   begin
   s:=newstr82(xdata);
   if not low__teatobmp(low__mapstr8(s),a,int1,int2) then goto skipend;
   end
else
   begin
   e:='Unknown format';
   goto skipend;
   end;
//.force 24bit bitmap
e:='Out of memory';
a24;
//successful
result:=true;
skipend:
except;end;
try
freeobj(@s);
{$ifdef jpeg}
freeobj(@j);
{$endif}
freeobj(@m);//do last
except;end;
end;
//## low__bmptoraw24 ##
function low__bmptoraw24(s:tbitmap;var ddata:string;var dbits,dw,dh:longint):boolean;
var
   sbits,sx,sy:longint;
   sr24,dr24:pcolorrow24;
   sr32:pcolorrow32;
   c24:TColor24;
   c32:tcolor32;
begin
try
//defaults
result:=false;
ddata:='';
dw:=0;
dh:=0;
dbits:=24;
//check
if (s=nil) then exit;
dw:=s.width;
dh:=s.height;
if (dw<0) or (dh<0) then exit;
//init
//.bits
if (s.pixelformat=pf24bit) then sbits:=24
else if (s.pixelformat=pf32bit) then sbits:=32
else exit;
//.data
setlength(ddata,dw*dh*3);
//get
for sy:=0 to (dh-1) do
begin
//.24 -> 24
if      (sbits=24) then
   begin
   sr24:=s.scanline[sy];
   dr24:=pointer(longint(ddata)+(sy*dw*3));
   for sx:=0 to (dw-1) do
   begin
   c24:=sr24[sx];
   dr24[sx]:=c24;
   end;//ax
   end
//.32 -> 24
else if (sbits=32) then
   begin
   sr32:=s.scanline[sy];
   dr24:=pointer(longint(ddata)+(sy*dw*3));
   for sx:=0 to (dw-1) do
   begin
   c32:=sr32[sx];
   c24.r:=c32.r;
   c24.g:=c32.g;
   c24.b:=c32.b;
   dr24[sx]:=c24;
   end;//ax
   end;
end;//sy
//successful
result:=true;
except;end;
try;if not result then ddata:='';except;end;
end;
//## low__bmptoraw32 ##
function low__bmptoraw32(s:tbitmap;var ddata:string;var dbits,dw,dh:longint):boolean;
var
   sbits,sx,sy:longint;
   sr24:pcolorrow24;
   sr32,dr32:pcolorrow32;
   c24:tcolor24;
   c32:tcolor32;
begin
try
//defaults
result:=false;
ddata:='';
dw:=0;
dh:=0;
dbits:=32;
//check
if (s=nil) then exit;
dw:=s.width;
dh:=s.height;
if (dw<0) or (dh<0) then exit;
//init
//.bits
if (s.pixelformat=pf24bit) then sbits:=24
else if (s.pixelformat=pf32bit) then sbits:=32
else exit;
//.data
setlength(ddata,dw*dh*4);
//get
for sy:=0 to (s.height-1) do
begin
//.24 -> 32
if      (sbits=24) then
   begin
   sr24:=s.scanline[sy];
   dr32:=pointer(longint(ddata)+(sy*dw*4));
   for sx:=0 to (s.width-1) do
   begin
   c24:=sr24[sx];
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   c32.a:=255;//fully solid
   dr32[sx]:=c32;
   end;//ax
   end
//.32 -> 32
else if (sbits=32) then
   begin
   sr32:=s.scanline[sy];
   dr32:=pointer(longint(ddata)+(sy*dw*4));
   for sx:=0 to (s.width-1) do
   begin
   c32:=sr32[sx];
   dr32[sx]:=c32;
   end;//ax
   end;
end;//sy
//successful
result:=true;
except;end;
try;if not result then ddata:='';except;end;
end;
//## low__clsoutside3 ##
procedure low__clsoutside3(canvas:tcanvas;ccw,cch,dx,dy,imageW,imageH,color:integer);//cls unused areas of a GUI control - 08aug2017
begin//Note: ccw=control.clientwidth, cch=control.clientheight
try
//check
if (canvas=nil) then exit;
//set
//.cls remaining areas
if (color<>clnone) then canvas.brush.color:=color;//19JUN2010
//..left
if (dx>=1) then canvas.fillrect(rect(0,0,dx,cch));
//..right
if ((dx+imageW)<ccw) then canvas.fillrect(rect(dx+imageW,0,ccw,cch));
//..top
if (dy>=1) then canvas.fillrect(rect(0,0,ccw,dy));
//..bottom
if ((dy+imageH)<cch) then canvas.fillrect(rect(0,dy+imageH,ccw,cch));
except;end;
end;
//## low__rawdraw2432 ##
function low__rawdraw2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;d:tbitmap;dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
label
   skipend;
const
   fv=30;
var
   v,dbits,ddx,ddy,dw,dh,sx,sy:longint;
   dr24,sr24:pcolorrow24;
   dr32,sr32:pcolorrow32;
   c24,cswapblack:tcolor24;
   c32:tcolor32;
   //.transparency
   tr,tg,tb:byte;
   dswap,tok:boolean;
   //## g24 ##
   procedure g24;
   begin
   if (c24.g>c24.r) then c24.r:=c24.g;
   if (c24.b>c24.r) then c24.r:=c24.b;
   if (c24.r<100) then c24.r:=100;
   c24.g:=c24.r;
   c24.b:=c24.r;
   end;
   //## g32 ##
   procedure g32;
   begin
   if (c32.g>c32.r) then c32.r:=c32.g;
   if (c32.b>c32.r) then c32.r:=c32.b;
   if (c32.r<100) then c32.r:=100;
   c32.g:=c32.r;
   c32.b:=c32.r;
   end;
   //## f24 ##
   procedure f24;
   begin
   //.r
   v:=c24.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.r:=byte(v);
   //.g
   v:=c24.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.g:=byte(v);
   //.b
   v:=c24.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.b:=byte(v);
   end;
   //## f32 ##
   procedure f32;
   begin
   //.r
   v:=c32.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.r:=byte(v);
   //.g
   v:=c32.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.g:=byte(v);
   //.b
   v:=c32.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.b:=byte(v);
   end;
begin
try
//defaults
result:=false;
//check
if (sw<1) or (sh<1) or ((sbits<>24) and (sbits<>32)) or (length(sraw)<(sw*sh*(sbits div 8))) then exit;
if (d=nil) or (d.width<1) or (d.height<1) or ((d.pixelformat<>pf24bit) and (d.pixelformat<>pf32bit)) then exit;
//init
//.d
if      (d.pixelformat=pf24bit) then dbits:=24
else if (d.pixelformat=pf32bit) then dbits:=32
else exit;
dw:=d.width;
dh:=d.height;
//.dclip
dclip.left:=frcrange(dclip.left,0,dw-1);
dclip.right:=frcrange(dclip.right,dclip.left,dw-1);
dclip.top:=frcrange(dclip.top,0,dh-1);
dclip.bottom:=frcrange(dclip.bottom,dclip.top,dh-1);
//.check -> dx/dy out of range -> do nothing
if (dx>dclip.right) or ((dx+sw)<dclip.left) or (dy>dclip.bottom) or ((dy+sh)<dclip.top) then
   begin
   result:=true;
   goto skipend;
   end;
//.tok
tok:=stransparent;
if tok then
   begin
   case sbits of
   24:begin
      sr24:=pointer(longint(sraw));
      tr:=sr24[0].r;
      tg:=sr24[0].g;
      tb:=sr24[0].b;
      end;
   32:begin
      sr32:=pointer(longint(sraw));
      tr:=sr32[0].r;
      tg:=sr32[0].g;
      tb:=sr32[0].b;
      end;
   end;//case
   end;
//.dswapblack
dswap:=(dswapblack<>clnone);
if dswap then cswapblack:=xintrgb(dswapblack);

//.s24 -> d24
if (sbits=24) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr24:=d.scanline[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s24 -> d32
else if (sbits=24) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr32:=d.scanline[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            c32.r:=c24.r;
            c32.g:=c24.g;
            c32.b:=c24.b;
            c32.a:=255;//fully solid
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d24
else if (sbits=32) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr24:=d.scanline[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            c24.r:=c32.r;
            c24.g:=c32.g;
            c24.b:=c32.b;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d32
else if (sbits=32) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr32:=d.scanline[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end;
//successful
result:=true;
skipend:
except;end;
end;
//## low__rawdrawr2432 ##
function low__rawdrawr2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;ddr24:pcolorrows24;ddr32:pcolorrows32;dw,dh,dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
label
   skipend;
const
   fv=30;
var
   dbits,v,ddx,ddy,sx,sy:longint;
   dr24,sr24:pcolorrow24;
   dr32,sr32:pcolorrow32;
   c24,cswapblack:tcolor24;
   c32:tcolor32;
   //.transparency
   tr,tg,tb:byte;
   dswap,tok:boolean;
   //## g24 ##
   procedure g24;
   begin
   if (c24.g>c24.r) then c24.r:=c24.g;
   if (c24.b>c24.r) then c24.r:=c24.b;
   if (c24.r<100) then c24.r:=100;
   c24.g:=c24.r;
   c24.b:=c24.r;
   end;
   //## g32 ##
   procedure g32;
   begin
   if (c32.g>c32.r) then c32.r:=c32.g;
   if (c32.b>c32.r) then c32.r:=c32.b;
   if (c32.r<100) then c32.r:=100;
   c32.g:=c32.r;
   c32.b:=c32.r;
   end;
   //## f24 ##
   procedure f24;
   begin
   //.r
   v:=c24.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.r:=byte(v);
   //.g
   v:=c24.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.g:=byte(v);
   //.b
   v:=c24.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.b:=byte(v);
   end;
   //## f32 ##
   procedure f32;
   begin
   //.r
   v:=c32.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.r:=byte(v);
   //.g
   v:=c32.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.g:=byte(v);
   //.b
   v:=c32.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.b:=byte(v);
   end;
begin
try
//defaults
result:=false;
//check
//.s
if (sw<1) or (sh<1) or ((sbits<>24) and (sbits<>32)) or (length(sraw)<(sw*sh*(sbits div 8))) then exit;
//.d
if (ddr24<>nil) then dbits:=24
else if (ddr32<>nil) then dbits:=32
else exit;
if (dw<1) or (dh<1) then exit;
//init
//.dclip
dclip.left:=frcrange(dclip.left,0,dw-1);
dclip.right:=frcrange(dclip.right,dclip.left,dw-1);
dclip.top:=frcrange(dclip.top,0,dh-1);
dclip.bottom:=frcrange(dclip.bottom,dclip.top,dh-1);
//.check -> dx/dy out of range -> do nothing
if (dx>dclip.right) or ((dx+sw)<dclip.left) or (dy>dclip.bottom) or ((dy+sh)<dclip.top) then
   begin
   result:=true;
   goto skipend;
   end;
//.tok
tok:=stransparent;
if tok then
   begin
   case sbits of
   24:begin
      sr24:=pointer(longint(sraw));
      tr:=sr24[0].r;
      tg:=sr24[0].g;
      tb:=sr24[0].b;
      end;
   32:begin
      sr32:=pointer(longint(sraw));
      tr:=sr32[0].r;
      tg:=sr32[0].g;
      tb:=sr32[0].b;
      end;
   end;//case
   end;
//.dswapblack
dswap:=(dswapblack<>clnone);
if dswap then cswapblack:=xintrgb(dswapblack);

//.s24 -> d24
if (sbits=24) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr24:=ddr24[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s24 -> d32
else if (sbits=24) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr32:=ddr32[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            c32.r:=c24.r;
            c32.g:=c24.g;
            c32.b:=c24.b;
            c32.a:=255;//fully solid
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d24
else if (sbits=32) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr24:=ddr24[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            c24.r:=c32.r;
            c24.g:=c32.g;
            c24.b:=c32.b;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d32
else if (sbits=32) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr32:=ddr32[ddy];
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end;
//successful
result:=true;
skipend:
except;end;
end;
//## low__rawdraww2432 ##
function low__rawdraww2432(var sraw:string;sbits,sw,sh:longint;stransparent:boolean;var draw:string;dbits,dw,dh,dx,dy,dswapblack:longint;dclip:trect;xgreyscale,xfocus:boolean):boolean;
label
   skipend;
const
   fv=30;
var
   v,ddx,ddy,sx,sy:longint;
   dr24,sr24:pcolorrow24;
   dr32,sr32:pcolorrow32;
   c24,cswapblack:tcolor24;
   c32:tcolor32;
   //.transparency
   tr,tg,tb:byte;
   dswap,tok:boolean;
   //## g24 ##
   procedure g24;
   begin
   if (c24.g>c24.r) then c24.r:=c24.g;
   if (c24.b>c24.r) then c24.r:=c24.b;
   if (c24.r<100) then c24.r:=100;
   c24.g:=c24.r;
   c24.b:=c24.r;
   end;
   //## g32 ##
   procedure g32;
   begin
   if (c32.g>c32.r) then c32.r:=c32.g;
   if (c32.b>c32.r) then c32.r:=c32.b;
   if (c32.r<100) then c32.r:=100;
   c32.g:=c32.r;
   c32.b:=c32.r;
   end;
   //## f24 ##
   procedure f24;
   begin
   //.r
   v:=c24.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.r:=byte(v);
   //.g
   v:=c24.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.g:=byte(v);
   //.b
   v:=c24.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c24.b:=byte(v);
   end;
   //## f32 ##
   procedure f32;
   begin
   //.r
   v:=c32.r+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.r:=byte(v);
   //.g
   v:=c32.g+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.g:=byte(v);
   //.b
   v:=c32.b+fv;
   if (v<100) then v:=100;
   if (v>255) then v:=255;
   c32.b:=byte(v);
   end;
begin
try
//defaults
result:=false;
//check
if (sw<1) or (sh<1) or ((sbits<>24) and (sbits<>32)) or (length(sraw)<(sw*sh*(sbits div 8))) then exit;
if (dw<1) or (dh<1) or ((dbits<>24) and (dbits<>32)) or (length(draw)<(dw*dh*(dbits div 8))) then exit;
//init
//.dclip
dclip.left:=frcrange(dclip.left,0,dw-1);
dclip.right:=frcrange(dclip.right,dclip.left,dw-1);
dclip.top:=frcrange(dclip.top,0,dh-1);
dclip.bottom:=frcrange(dclip.bottom,dclip.top,dh-1);
//.check -> dx/dy out of range -> do nothing
if (dx>dclip.right) or ((dx+sw)<dclip.left) or (dy>dclip.bottom) or ((dy+sh)<dclip.top) then
   begin
   result:=true;
   goto skipend;
   end;
//.tok
tok:=stransparent;
if tok then
   begin
   case sbits of
   24:begin
      sr24:=pointer(longint(sraw));
      tr:=sr24[0].r;
      tg:=sr24[0].g;
      tb:=sr24[0].b;
      end;
   32:begin
      sr32:=pointer(longint(sraw));
      tr:=sr32[0].r;
      tg:=sr32[0].g;
      tb:=sr32[0].b;
      end;
   end;//case
   end;
//.dswapblack
dswap:=(dswapblack<>clnone);
if dswap then cswapblack:=xintrgb(dswapblack);

//.s24 -> d24
if (sbits=24) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr24:=pointer(longint(draw)+(ddy*dw*3));
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s24 -> d32
else if (sbits=24) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr24:=pointer(longint(sraw)+(sy*sw*3));
      dr32:=pointer(longint(draw)+(ddy*dw*4));
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c24:=sr24[sx];
         if (not tok) or (tr<>c24.r) or (tg<>c24.g) or (tb<>c24.b) then
            begin
            if dswap and (c24.r=0) and (c24.g=0) and (c24.b=0) then c24:=cswapblack;
            c32.r:=c24.r;
            c32.g:=c24.g;
            c32.b:=c24.b;
            c32.a:=255;//fully solid
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d24
else if (sbits=32) and (dbits=24) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr24:=pointer(longint(draw)+(ddy*dw*3));
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            c24.r:=c32.r;
            c24.g:=c32.g;
            c24.b:=c32.b;
            if xfocus then f24;
            if xgreyscale then g24;
            dr24[ddx]:=c24;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end
//.s32 -> d32
else if (sbits=32) and (dbits=32) then
   begin
   for sy:=0 to (sh-1) do
   begin
   ddy:=dy+sy;
   if (ddy>=dclip.top) and (ddy<=dclip.bottom) then
      begin
      sr32:=pointer(longint(sraw)+(sy*sw*4));
      dr32:=pointer(longint(draw)+(ddy*dw*4));
      for sx:=0 to (sw-1) do
      begin
      ddx:=dx+sx;
      if (ddx>=dclip.left) and (ddx<=dclip.right) then
         begin
         c32:=sr32[sx];
         if (not tok) or (tr<>c32.r) or (tg<>c32.g) or (tb<>c32.b) then
            begin
            if dswap and (c32.r=0) and (c32.g=0) and (c32.b=0) then
               begin
               c32.r:=cswapblack.r;
               c32.g:=cswapblack.g;
               c32.b:=cswapblack.b;
               end;
            if xfocus then f32;
            if xgreyscale then g32;
            dr32[ddx]:=c32;
            end;
         end;//ddx
      end;//sx
      end;//ddy
   end;//sy
   end;
//successful
result:=true;
skipend:
except;end;
end;
//## low__rawrows2432 ##
function low__rawrows2432(var simg:string;sbits,sw,sh:longint;var srows24:pcolorrows24;var srows32:pcolorrows32;var srowsmem:string):boolean;
var
   sy:longint;
begin
try
//defaults
result:=false;
srowsmem:='';
//check
if (sw<1) or (sh<1) or ((sbits<>24) and (sbits<>32)) or (length(simg)<(sw*sh*(sbits div 8))) then exit;
//get
setlength(srowsmem,sh*sizeof(tpointer));
srows24:=pointer(longint(srowsmem));
srows32:=pointer(longint(srowsmem));
if (sbits=24) then
   begin
   for sy:=0 to (sh-1) do srows24[sy]:=pointer(longint(simg)+(sy*sw*3));
   end
else if (sbits=32) then
   begin
   for sy:=0 to (sh-1) do srows32[sy]:=pointer(longint(simg)+(sy*sw*4));
   end;
//successful
result:=true;
except;end;
end;
//## low__rawrows32 ##
function low__rawrows32(var simg:string;sbits,sw,sh:longint;var srows32:pcolorrows32;var srowsmem:string):boolean;
var
   srows24:pcolorrows24;
begin
try;result:=low__rawrows2432(simg,sbits,sw,sh,srows24,srows32,srowsmem);except;end;
end;
//## low__rawrows24 ##
function low__rawrows24(var simg:string;sbits,sw,sh:longint;var srows24:pcolorrows24;var srowsmem:string):boolean;
var
   srows32:pcolorrows32;
begin
try;result:=low__rawrows2432(simg,sbits,sw,sh,srows24,srows32,srowsmem);except;end;
end;
//## low__rawcls2432 ##
function low__rawcls2432(acolor,acolor2:longint;var sraw:string;sw,sh,sbits:longint;scliparea:trect):boolean;
label
   skipend;
var
   sx,sy:longint;
   c24:tcolor24;
   c32:tcolor32;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   c,c2:tint4;
   xpert:extended;
begin
try
//defaults
result:=false;
//check
if (sw<1) or (sh<1) or ((sbits<>24) and (sbits<>32)) or (length(sraw)<(sw*sh*(sbits div 8))) then exit;
if (acolor=clnone) or (acolor2=clnone) then
   begin
   result:=true;
   exit;
   end;
//init
scliparea.left:=frcrange(scliparea.left,0,sw-1);
scliparea.right:=frcrange(scliparea.right,scliparea.left,sw-1);
scliparea.top:=frcrange(scliparea.top,0,sh-1);
scliparea.bottom:=frcrange(scliparea.bottom,scliparea.top,sh-1);
c.val:=acolor;
c2.val:=acolor2;
//get
for sy:=scliparea.top to scliparea.bottom do
begin
if (sy=scliparea.top) or (acolor<>acolor2) then
   begin
   if (acolor=acolor2) then
      begin
      c24.r:=c.r;
      c24.g:=c.g;
      c24.b:=c.b;
      end
   else
      begin
      xpert:=(sy-scliparea.top+1)/(scliparea.bottom-scliparea.top+1);
      c24.r:=round( (c.r*(1-xpert))+(c2.r*xpert) );
      c24.g:=round( (c.g*(1-xpert))+(c2.g*xpert) );
      c24.b:=round( (c.b*(1-xpert))+(c2.b*xpert) );
      end;
   c32.r:=c24.r;
   c32.g:=c24.g;
   c32.b:=c24.b;
   c32.a:=255;//fully solid
   end;
//.draw
if      (sbits=24) then
   begin
   sr24:=pointer(longint(sraw)+(sy*sw*3));
   for sx:=scliparea.left to scliparea.right do sr24[sx]:=c24;
   end
else if (sbits=32) then
   begin
   sr32:=pointer(longint(sraw)+(sy*sw*4));
   for sx:=scliparea.left to scliparea.right do sr32[sx]:=c32;
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
end;
//## low__imgtoraw ##
function low__imgtoraw(xtargetbits:longint;var simg,ddata:string;var dbits,dw,dh:longint):boolean;
label
   skipend;
var
   a:tbitmap;
   xformat,e:string;
   xbase64:boolean;
   //## acreate ##
   procedure acreate;
   begin
   try
   if (a=nil) then a:=tbitmap.create;
   a.pixelformat:=pf24bit;
   a.width:=1;
   a.height:=1;
   except;end;
   end;
   //## dnil ##
   procedure dnil;
   begin
   try
   ddata:='';
   dw:=0;
   dh:=0;
   dbits:=32;
   except;end;
   end;
begin
try
//defaults
result:=false;
a:=nil;
dnil;
//get
if low__findimgformat(simg,xformat,xbase64) then
   begin
   acreate;
   if not low__fromimgdata(a,xformat,simg,e) then goto skipend;
   end
else goto skipend;//unknown format
//set
case xtargetbits of
32:if not low__bmptoraw32(a,ddata,dbits,dw,dh) then goto skipend;
else
   begin
   if not low__bmptoraw24(a,ddata,dbits,dw,dh) then goto skipend;
   end;
end;//case
//successful
result:=true;
skipend:
except;end;
try
if not result then dnil;
freeobj(@a);
except;end;
end;
//## low__imgtoraw24 ##
function low__imgtoraw24(var simg,ddata:string;var dbits,dw,dh:longint):boolean;
begin
try;result:=low__imgtoraw(24,simg,ddata,dbits,dw,dh);except;end;
end;
//## low__imgtoraw32 ##
function low__imgtoraw32(var simg,ddata:string;var dbits,dw,dh:longint):boolean;
begin
try;result:=low__imgtoraw(32,simg,ddata,dbits,dw,dh);except;end;
end;
//## low__totem ##
function low__totem(x:tobject;xencode:boolean;var xout:string):boolean;
label//Compressed mono text picture -> smart compression mode:
     //Short compression range (1-26 pixels): 1byte [A-Z,a-z]
     //Long compression range (1-1352 pixels): 3bytes [#] [A-Z,a-z] [A-Z,a-z]
   skipend;
var
   xref:string;
   lv:boolean;
   lc,xw,xh,xbits,pc,xlen,xaddcount,sx,sy:longint;
   r24:pcolorrow24;
   r8:pdlbyte;
   xc:tcolor24;
   //## xadd ##
   procedure xadd(x:string);
   begin
   if xencode and (xlen=0) then pushb(xlen,xout,#39);
   if (x<>'') then pushb(xlen,xout,x);
   inc(xaddcount,length(x));
   if xencode and ((xaddcount>=240) or (x='')) then
      begin
      inc(pc);
      if (x='') then pushb(xlen,xout,#39+';') else pushb(xlen,xout,#39+'+'+low__insstr(rcode,pc>=3)+#39);
      if (pc>=3) then pc:=0;
      xaddcount:=0;
      end;
   end;
   //## writeblock ##
   procedure writeblock;
   var//Note: $=off, #=on
      v,v1,v2:longint;
   begin
   v:=lc-1;//0..3843 = 3844 values
   if (v>=26) then//26..3843
      begin
      v2:=v div 62;//0..61
      v1:=v-(v2*62);//0..61
      if lv then xadd('#'+xref[1+v1]+xref[1+v2]) else xadd('$'+xref[1+v1]+xref[1+v2]);
      end
   else//0..25
      begin
      if lv then xadd(char(65+v)) else xadd(char(97+v));//AZ=on, az=off, count=1..26
      end;
   end;
   //## xaddv ##
   procedure xaddv(v:boolean);
   begin
   if (lc=0) then lv:=v;//set once
   if (lv<>v) then
      begin
      if (lc>=1) then writeblock;
      lv:=v;
      lc:=1;
      end
   else
      begin
      inc(lc);
      if (lc>=3844) then
         begin
         writeblock;
         lc:=0;//reset
         end;
      end;
   end;
begin
try
//defaults
result:=false;
xout:='';
//check
if not misok824(x,xbits,xw,xh) then exit;//required - 24/8 bits
//init
xref:='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';//62 values
xlen:=0;
xaddcount:=0;
pc:=0;
lv:=false;
lc:=0;
//header
xadd('TEM1#'+from32bit8(xw)+from32bit8(xh));//21 bytes
//pixels
for sy:=0 to (xh-1) do
begin
if not misscan824(x,sy,@r8,@r24) then goto skipend;
if (xbits=24) then
   begin
   for sx:=0 to (xw-1) do
   begin
   xc:=r24[sx];
   if (xc.g>xc.r) then xc.r:=xc.g;
   if (xc.b>xc.r) then xc.r:=xc.b;
   xaddv(xc.r>=127);
   end;//sx
   end
else if (xbits=8) then
   begin
   for sx:=0 to (xw-1) do xaddv(r8[sx]>=127);
   end;
end;//sy
//.finalise
if (lc>=1) then writeblock;
if xencode then xadd('');
pushb(xlen,xout,'');
//successful
result:=true;
skipend:
except;end;
try;if not result then xout:='';except;end;
end;
//## low__fromtem ##
function low__fromtem(x:tobject;xin:string):boolean;
label
   redo,skipend;
var
   lv:boolean;
   vi,v2,v,lc,int1,int2,p2,p,xbits,xlen,sx,sy,xw,xh:longint;
   r24:pcolorrow24;
   r8:pdlbyte;
   xon,xoff:tcolor24;
   //## xval ##
   function xchar(x:byte):longint;
   begin
   case x of
   48..57:result:=x-48;//0..9 = 09 = 10v
   65..90:result:=x-55;//10..35 = AZ = 26v
   97..122:result:=x-61;//36..61 = az = 26v
   else result:=-1;//error -> skip over this pixel
   end;//case
   end;
begin
try
//defaults
result:=false;
xlen:=length(xin);
//check
if not misok824(x,xbits,int1,int2) then exit;//required - 24/8 bits
//filter -> A..Z,a..z,#..$,0..9 chars only - 14jul2019
int1:=0;
for p:=1 to xlen do
begin
case byte(xin[p]) of
65..90,97..122,35..36,48..57:begin//A..Z,a..z,#..$,0..9
   inc(int1);
   if (int1<p) then xin[int1]:=xin[p];
   end;
end;
end;//p
if (int1<p) then setlength(xin,int1);
//find header
int1:=0;//not found
if (xlen<20) then goto skipend;
int1:=1;
for p:=1 to frcmax(xlen,100) do if ((xin[p]='T') or (xin[p]='t')) and (comparetext(copy(xin,p,5),'TEM1#')=0) then
   begin
   int1:=p;
   break;
   end;
if (int1<=0) then goto skipend;
//init
xon.r:=255;
xon.g:=255;
xon.b:=255;
xoff.r:=0;
xoff.g:=0;
xoff.b:=0;
xw:=to32bit8(copy(xin,int1+5,8));
xh:=to32bit8(copy(xin,int1+5+8,8));
if (xw<1) or (xh<1) then goto skipend;
//get
missize(x,xw,xh);
sx:=0;
sy:=0;
if not misscan824(x,sy,@r8,@r24) then goto skipend;
p:=int1+5+8+8;
if (p>xlen) then goto skipend;
vi:=0;

redo:
v:=ord(xin[p]);
case vi of
0:begin
   case v of
   35..36:begin//switch to 3byte decompression mode
      lv:=(v=35);//#=on, $=off
      vi:=1;
      lc:=0;
      end;
   65..90:begin//AZ => on - 1byte decompression
      lv:=true;
      lc:=v-64;
      end;
   97..122:begin//az => off - 1byte decompression
      lv:=false;
      lc:=v-96;
      end;
   else
      begin//invalid -> skip over
      lv:=false;
      lc:=0;
      end;
   end;//case
   end;//begin
1:begin
   v2:=xchar(v);
   if (v2>=0) then vi:=2;
   end;
2:begin
   v:=xchar(v);
   if (v>=0) then
      begin
      lc:=v2+(v*62)+1;//non-zero -> one-based
      vi:=0;//reset
      end;
   end;
end;//case

if (lc>=1) then for p2:=1 to lc do
   begin
   if (xbits=24) then
      begin
      if lv then r24[sx]:=xon else r24[sx]:=xoff;
      end
   else if (xbits=8) then
      begin
      if lv then r8[sx]:=xon.r else r8[sx]:=xoff.r;
      end;
   inc(sx);
   if (sx>=xw) then
      begin
      inc(sy);
      if (sy<xh) then misscan824(x,sy,@r8,@r24) else break;
      sx:=0;
      end;
   end;//lc

//.loop
inc(p,1);
if (p<=xlen) and (sy<xh) then goto redo;

//successful
result:=true;
skipend:
except;end;
end;
//## low__toteh ##
function low__toteh(x:tobject;xencode:boolean;var xout:string):boolean;
label//Compressed near-color text picture
   skipend;
var
   xref:string;
   l:tint4;
   xw,xh,xbits,pc,xlen,xaddcount,sx,sy:longint;
   r24:pcolorrow24;
   r8:pdlbyte;
   xc:tcolor24;
   //## xmakeblock ##
   function xmakeblock:string;
   var
      v,x:longint;
   begin
   try
   //defaults
   result:='AAA';//3bytes
   //init                                                      //0-57 = 58 values
   v:=(l.r div 16) + ((l.g div 16)*16) + ((l.b div 16)*256) + ((l.t-1)*4096);
   //3
   x:=v div 3844;
   result[3]:=xref[1+x];
   dec(v,x*3844);
   //2
   x:=v div 62;
   result[2]:=xref[1+x];
   dec(v,x*62);
   //1
   result[1]:=xref[1+v];
   except;end;
   end;
   //## xadd ##
   procedure xadd(x:string);
   begin
   if xencode and (xlen=0) then pushb(xlen,xout,#39);
   if (x<>'') then pushb(xlen,xout,x);
   inc(xaddcount,length(x));
   if xencode and ((xaddcount>=240) or (x='')) then
      begin
      inc(pc);
      if (x='') then pushb(xlen,xout,#39+';') else pushb(xlen,xout,#39+'+'+low__insstr(rcode,pc>=3)+#39);
      if (pc>=3) then pc:=0;
      xaddcount:=0;
      end;
   end;
   //## xaddrgb ##
   procedure xaddrgb(r,g,b:byte);
   begin
   if (l.r<>r) or (l.g<>g) or (l.b<>b) then
      begin
      if (l.t>=1) then xadd(xmakeblock);
      l.r:=r;
      l.g:=g;
      l.b:=b;
      l.t:=1;
      end
   else
      begin
      inc(l.t);
      if (l.t>=58) then
         begin
         xadd(xmakeblock);
         l.t:=0;//reset
         end;
      end;
   end;
begin
try
//defaults
result:=false;
xout:='';
//check
if not misok824(x,xbits,xw,xh) then exit;//required - 24/8 bits
//init
xref:='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
xlen:=0;
xaddcount:=0;
pc:=0;
l.val:=0;
//header
xadd('TEH1#'+from32bit8(xw)+from32bit8(xh));//21 bytes
//pixels
for sy:=0 to (xh-1) do
begin
if not misscan824(x,sy,@r8,@r24) then goto skipend;
if (xbits=24) then
   begin
   for sx:=0 to (xw-1) do xaddrgb(r24[sx].r,r24[sx].g,r24[sx].b);
   end
else if (xbits=8) then
   begin
   for sx:=0 to (xw-1) do xaddrgb(r8[sx],r8[sx],r8[sx]);
   end;
end;//xy
//.finalise
if (l.t>=1) then xadd(xmakeblock);
if xencode then xadd('');
pushb(xlen,xout,'');
//successful
result:=true;
skipend:
except;end;
try;if not result then xout:='';except;end;
end;
//## low__fromteh ##
function low__fromteh(x:tobject;xin:string):boolean;
label
   redo,skipend;
var
   dr,dg,db,dc,vi,v,v1,v2,v3,int1,int2,p2,p,xbits,xlen,sx,sy,xw,xh:longint;
   r24:pcolorrow24;
   r8:pdlbyte;
   //## xval ##
   function xchar(x:byte):longint;
   begin
   case x of
   48..57:result:=x-48;//0..9 = 09 = 10v
   65..90:result:=x-55;//10..35 = AZ = 26v
   97..122:result:=x-61;//36..61 = az = 26v
   else result:=-1;//error -> skip over this pixel
   end;//case
   end;
begin
try
//defaults
result:=false;
xlen:=length(xin);
//check
if not misok824(x,xbits,int1,int2) then exit;//required - 24/8 bits
//filter -> A..Z,a..z,#,0..9 chars only - 03mar2018
int1:=0;
for p:=1 to xlen do
begin
case byte(xin[p]) of
65..90,97..122,35,48..57:begin//A..Z,a..z,#,0..9
   inc(int1);
   if (int1<p) then xin[int1]:=xin[p];
   end;
end;
end;//p
if (int1<p) then setlength(xin,int1);
//find header
int1:=0;//not found
if (xlen<20) then goto skipend;
int1:=1;
for p:=1 to frcmax(xlen,100) do if ((xin[p]='T') or (xin[p]='t')) and (comparetext(copy(xin,p,5),'TEH1#')=0) then
   begin
   int1:=p;
   break;
   end;
if (int1<=0) then goto skipend;
//init
xw:=to32bit8(copy(xin,int1+5,8));
xh:=to32bit8(copy(xin,int1+5+8,8));
if (xw<1) or (xh<1) then goto skipend;
//get
missize(x,xw,xh);
sx:=0;
sy:=0;
if not misscan824(x,sy,@r8,@r24) then goto skipend;
p:=int1+5+8+8;
if (p>xlen) then goto skipend;//14jul2019

vi:=0;
redo:
case vi of
0:begin
   v1:=xchar(ord(xin[p]));
   if (v1>=0) then inc(vi);
   end;
1:begin
   v2:=xchar(ord(xin[p]));
   if (v2>=0) then inc(vi);
   end;
2:begin
   v3:=xchar(ord(xin[p]));
   if (v3>=0) then
      begin
      //init
      v:=v1+(v2*62)+(v3*3844);
      //.dc
      dc:=v div 4096;
      dec(v,dc*4096);
      inc(dc);//convert from zero-based to one-based (0..57 => 1..58)
      //.db
      db:=v div 256;
      dec(v,db*256);
      //.dg
      dg:=v div 16;
      dec(v,dg*16);
      //.dr
      dr:=v;
      //get
      if (dc>=1) then
         begin
         for p2:=1 to dc do
         begin
         if (xbits=24) then
            begin
            r24[sx].r:=byte(dr*17);
            r24[sx].g:=byte(dg*17);
            r24[sx].b:=byte(db*17);
            end
         else if (xbits=8) then
            begin
            if (dg>dr) then dr:=dg;
            if (db>dr) then dr:=db;
            r8[sx]:=byte(dr*17);
            end;
         inc(sx);
         if (sx>=xw) then
            begin
            inc(sy);
            if (sy<xh) then misscan824(x,sy,@r8,@r24) else break;
            sx:=0;
            end;
         end;//p2
         end;//dc
      //reset
      vi:=0;
      end;
   end;
end;//case

//.loop
inc(p);
if (p<=xlen) and (sy<xh) then goto redo;

//successful
result:=true;
skipend:
except;end;
end;
//## low__teamake ##
function low__teamake(x:tobject;xout:tstr8;var e:string):boolean;
label
   skipend;
var
   l:tint4;
   xw,xh,xbits,pc,xlen,xaddcount,sx,sy:longint;
   prows24:pcolorrows24;
   prows32:pcolorrows32;
   sr24:pcolorrow24;
   sr32:pcolorrow32;
   sc24:tcolor24;
   sc32:tcolor32;
   //## xadd24 ##
   procedure xadd24;
   begin
   if (l.r<>sc24.r) or (l.g<>sc24.g) or (l.b<>sc24.b) then
      begin
      if (l.t>=1) then xout.addint4(l.val);
      l.r:=sc24.r;
      l.g:=sc24.g;
      l.b:=sc24.b;
      l.t:=1;
      end
   else
      begin
      inc(l.t);
      if (l.t>=250) then
         begin
         xout.addint4(l.val);
         l.t:=0;//reset
         end;
      end;
   end;
begin
try
//defaults
result:=false;
e:=gecTaskfailed;
if (xout=nil) or (x=nil) then goto skipend;
if not misok2432(x,xbits,xw,xh) then goto skipend;
//init
xout.clear;
xlen:=0;
xaddcount:=0;
pc:=0;
l.val:=0;
//head
xout.addbyt1(84);//T
xout.addbyt1(69);//E
xout.addbyt1(65);//A
xout.addbyt1(49);//1
xout.addbyt1(35);//#
xout.addint4(xw);
xout.addint4(xh);//13 bytes
//pixels
e:=gecOutofmemory;
for sy:=0 to (xh-1) do
begin
if (xbits=24) then
   begin
   if not misscan(x,sy,@sr24^) then goto skipend;
   for sx:=0 to (xw-1) do
   begin
   sc24:=sr24[sx];
   xadd24;
   end;//sx
   end
else if (xbits=32) then
   begin
   if not misscan(x,sy,@sr32^) then goto skipend;
   for sx:=0 to (xw-1) do
   begin
   sc32:=sr32[sx];
   sc24.r:=sc32.r;
   sc24.g:=sc32.g;
   sc24.b:=sc32.b;
   xadd24;
   end;//sx
   end;
end;//xy
//.finalise
if (l.t>=1) then xout.addint4(l.val);
if (xout.len<>xout.count) then xout.setlen(xout.count);
//successful
result:=true;
skipend:
except;end;
try;if (not result) and (xout<>nil) then xout.clear;except;end;
end;
//## low__teainfo ##
function low__teainfo(var adata:tlistptr;var aw,ah:longint):boolean;
label
   skipend;
var
   v:tint4;
begin
try
//defaults
result:=false;
aw:=0;
ah:=0;
//check
if (adata.count<13) or (adata.bytes=nil) then goto skipend;
//get
//.header
if not low__compareint(adata.bytes[0],84) then goto skipend;//T
if not low__compareint(adata.bytes[1],69) then goto skipend;//E
if not low__compareint(adata.bytes[2],65) then goto skipend;//A
if not low__compareint(adata.bytes[3],49) then goto skipend;//1
if not low__compareint(adata.bytes[4],35) then goto skipend;//#
//.w
v.bytes[0]:=adata.bytes[5];
v.bytes[1]:=adata.bytes[6];
v.bytes[2]:=adata.bytes[7];
v.bytes[3]:=adata.bytes[8];
aw:=v.val;
if (aw<=0) then goto skipend;
//.h
v.bytes[0]:=adata.bytes[9];
v.bytes[1]:=adata.bytes[10];
v.bytes[2]:=adata.bytes[11];
v.bytes[3]:=adata.bytes[12];
ah:=v.val;
if (ah<=0) then goto skipend;
//successful
result:=true;
skipend:
except;end;
end;
//## low__teatobmp ##
function low__teatobmp(xtea:tlistptr;d:tbitmap;var xw,xh:longint):boolean;//23may2020
label//Supports "d" in 8/24/32 bits
   redo;
var
   a:tint4;
   p,dd,dbits,dx,dy,dw,dh:longint;
   dhasai:boolean;
   dr8 :pcolorrow8;
   dr24:pcolorrow24;
   dr32:pcolorrow32;
   dc24:tcolor24;
   dc32:tcolor32;
   //## dscan ##
   procedure dscan;
   begin
   case dbits of
   8: dr8 :=d.scanline[dy];
   24:dr24:=d.scanline[dy];
   32:dr32:=d.scanline[dy];
   end;
   end;
begin
try
//defaults
result:=false;
xw:=0;
xh:=0;
//check
if (not low__teainfo(xtea,xw,xh)) or (not misinfo82432(d,dbits,dw,dh,dhasai)) then exit;
//init
missize(d,xw,xh);
dw:=misw(d);
dh:=mish(d);
//get
dd:=13;//start of data
dx:=0;
dy:=0;
dscan;

redo:
if ((dd+3)<xtea.count) then
   begin
   a.bytes[0]:=xtea.bytes[dd+0];
   a.bytes[1]:=xtea.bytes[dd+1];
   a.bytes[2]:=xtea.bytes[dd+2];
   a.bytes[3]:=xtea.bytes[dd+3];
   //.get pixels
   if (a.t>=1) then
      begin
      for p:=1 to a.t do
      begin
      case dbits of
      8:begin
         if (a.g>a.r) then a.r:=a.g;
         if (a.b>a.r) then a.r:=a.b;
         dr8[dx]:=a.r;
         end;
      24:begin
         dc24.r:=a.r;
         dc24.g:=a.g;
         dc24.b:=a.b;
         dr24[dx]:=dc24;
         end;
      32:begin
         dc32.r:=a.r;
         dc32.g:=a.g;
         dc32.b:=a.b;
         dc32.a:=255;
         dr32[dx]:=dc32;
         end;
      end;//case
      //.inc
      inc(dx);
      if (dx>=xw) then
         begin
         dx:=0;
         inc(dy);
         if (dy>=xh) then break;
         dscan;
         end;
      end;//p
      end;//a.a
   //.loop
   inc(dd,4);
   if ((dd+3)<xtea.count) then goto redo;
   end;
//successful
result:=true;
except;end;
end;

//-- Color Support -------------------------------------------------------------
//## low__rgb ##
function low__rgb(r,g,b:byte):longint;
var
   x:tint4;
begin
try
x.r:=r;
x.g:=g;
x.b:=b;
x.t:=0;
result:=x.val;
except;end;
end;
//## low__rgba ##
function low__rgba(r,g,b,a:byte):longint;
var
   x:tint4;
begin
try
x.r:=r;
x.g:=g;
x.b:=b;
x.t:=a;
result:=x.val;
except;end;
end;
//## low__greyscale3 ##
function low__greyscale3(x:longint):longint;
var
   a:tint4;
begin
result:=0;
a.val:=x;
if (a.g>a.r) then a.r:=a.g;
if (a.b>a.r) then a.r:=a.b;
a.g:=a.r;
a.b:=a.r;
result:=a.val;
end;
//## low__focus3 ##
function low__focus3(x:longint):longint;
const
   fv=30;
var
   a:tint4;
   v:longint;
begin
//defaults
result:=0;
a.val:=x;
//.r
v:=a.r+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
a.r:=byte(v);
//.g
v:=a.g+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
a.g:=byte(v);
//.b
v:=a.b+fv;
if (v<100) then v:=100;
if (v>255) then v:=255;
a.b:=byte(v);
//set
result:=a.val;
end;
//## low__cap2432 ##
function low__cap2432(xpos,ypos,dw,dh:longint;d:tbitmap):boolean;//low version - 07mar2020, 30may2019, 21jan2015, 17-JAN-2007
var//Stabilised and verified at 21jan2015
   c:tcanvas;
   h:hwnd;
   dc:hdc;
   sw,sh:longint;
begin
try
//defaults
result:=false;
c:=nil;
h:=0;
//range
if (d=nil) then exit;
//init
if (d.pixelformat<>pf24bit) and (d.pixelformat<>pf32bit) then d.pixelformat:=pf24bit;
sw:=frcmin(screen.width,1);
sh:=frcmin(screen.height,1);
//.size
if (dw<1) then dw:=sw;
if (dh<1) then dh:=sh;
dw:=frcrange(dw,1,sw);
dh:=frcrange(dh,1,sh);
if (d.width<>dw) or (d.height<>dh) then
   begin
   d.width:=1;
   d.height:=1;
   d.width:=dw;
   d.height:=dh;
   end;
//.pos
xpos:=frcrange(xpos,0,frcmin(sw-dw,0));
ypos:=frcrange(ypos,0,frcmin(sh-dh,0));
//init
h:=getdesktopwindow;
dc:=getwindowdc(h);
//get
c:=tcanvas.create;
c.handle:=dc;
//.screen -> d
d.canvas.copyrect(rect(0,0,dw,dh),c,rect(xpos,ypos,xpos+dw,ypos+dh));
//clear
c.handle:=0;
releasedc(h,dc);
//successful
result:=true;
except;end;
try;if (c<>nil) then c.free;except;end;
end;
//## low__cap2432b ##
function low__cap2432b(d:tbitmap):boolean;
begin
try;result:=low__cap2432(0,0,0,0,d);except;end;
end;
//## low__capcolor ##
function low__capcolor(xpos,ypos:longint;xfromcursor:boolean):longint;
var
   a:tbitmap;
   b:tpoint;
   ar24:pcolorrow24;
   c:tint4;
begin
try
//defaults
result:=0;
a:=nil;
//init
if xfromcursor then
   begin
   getcursorpos(b);
   xpos:=b.x;
   ypos:=b.y;
   end;
//get
a:=tbitmap.create;
a.pixelformat:=pf24bit;
if low__cap2432(xpos,ypos,1,1,a) then
   begin
   ar24:=a.scanline[0];
   c.val:=0;
   c.r:=ar24[0].r;
   c.g:=ar24[0].g;
   c.b:=ar24[0].b;
   result:=c.val;
   end;
except;end;
try;freeobj(@a);except;end;
end;

//-- String Handlers -----------------------------------------------------------
//## bn ##
function bn(x:boolean):char;//08SEP2010
begin
try;if x then result:='1' else result:='0';except;end;
end;
//## nb ##
function nb(x:string):Boolean;
begin
try;result:=(x='1');except;end;
end;
//## SwapStrs ##
function SwapStrs(Var X:String;A,B:String):boolean;
label
     ReDo;
var
   lenB,lenA,MaxP,P:Integer;
begin
try{Extremely Fast Praser/StrSwaper - 5KBx6 times = 1-7ms => 46 times faster than SwapStrs => 325ms}
//no
result:=false;
//prepare
MaxP:=Length(X);
lenA:=Length(A);
lenB:=Length(B);
P:=0;
//process
ReDo:
P:=P+1;
If (P>MaxP) then exit;
If (X[P]=A[1]) then If (Copy(X,P,lenA)=A) then
   begin
   X:=Copy(X,1,P-1)+B+Copy(X,P+LenA,MaxP);
   P:=P+LenB-1;
   MaxP:=MaxP-LenA+LenB;
   //yes
   result:=true;
   end;//End of LOOP
Goto ReDo;
except;end;
end;
//## fromnullstr ##
function fromnullstr(a:pointer;asize:integer):string;
var
   p:integer;
   b:pdlBYTE;
begin
try
//prepare
setlength(result,asize);
b:=a;
//process
for p:=0 to (asize-1) do
    begin
    result[p+1]:=chr(b[p]);
    if (b[p]=0) then
       begin
       setlength(result,p);
       break;
       end;//end of if
    end;//end of loop
except;end;
end;
//## low__nullstr ##
function low__nullstr(x:integer;y:char):string;
var//speed: 8-9Mb/sec, tested at 9Mb=1,000ms @ 200Mhz
   p:integer;
begin
try;setlength(result,x);for p:=length(result) downto 1 do result[p]:=y;except;end;
end;
//## safefilename ##
function safefilename(x:string;allowpath:boolean):string;//08mar2016
var
   minp,p:integer;
   c:char;
   //## isbinary ##
   function isbinary(x:char):boolean;
   begin
   try
   case byte(x) of//31MAR2010
   32..255:result:=false;
   else result:=true;
   end;
   except;end;
   end;
begin
try
//defaults
result:=x;
if (x='') then exit;
//process
if allowpath then
   begin
   //.get
   if (copy(x,1,2)='\\') then minp:=3 else minp:=1;
   //.set
   for p:=minp to length(result) do
   begin
   c:=result[p];
   if (c='/') then result[p]:='\'
   else if isbinary(c) or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') then result[p]:=pcSymSafe;
   end;//end of loop
   end
else
   begin
   //.set
   for p:=1 to length(result) do
   begin
   c:=result[p];
   if isbinary(c) or (c='\') or (c='/') or (c=':') or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') then result[p]:=pcSymSafe;
   end;//end of loop
   end;//end of if
except;end;
end;
//## issafefilename ##
function issafefilename(x:string):boolean;//10APR2010
var
   minp,p:integer;
   c:char;
   //## isbinary ##
   function isbinary(x:char):boolean;
   begin
   try
   case byte(x) of//31MAR2010
   32..255:result:=false;
   else result:=true;
   end;
   except;end;
   end;
begin
try
//defaults
result:=true;
//set
for p:=1 to length(x) do
begin
c:=x[p];
if isbinary(c) or (c='*') or (c='?') or (c='"') or (c='<') or (c='>') or (c='|') then
   begin
   result:=false;
   break;
   end;
end;
except;end;
end;
//## remlastext ##
function remlastext(x:string):string;//remove last extension
var
   p:longint;
begin
try
for p:=length(x) downto 1 do if (x[p]='.') then
   begin
   x:=copy(x,1,p-1);
   break;
   end;//p
except;end;
try;result:=x;except;end;
end;
//## readfileext ##
function readfileext(x:string;fu:boolean):string;{Date: 24-DEC-2004, Superceeds "ExtractFileExt"}
var
   a,b:string;
begin
try
if scandownto(x,'.','/','\',a,result) then
   begin
   if scandownto(result,'?',#0,#0,a,b) then result:=a;
   if fu then result:=uppercase(result);
   end else result:='';
except;end;
end;
//## scandownto ##
function scandownto(x:string;y,stopA,stopB:char;var a,b:string):boolean;
var
   maxp,p:integer;
   _stopA,_stopB:boolean;
begin
try
//defaults
result:=false;
a:='';
b:='';
_stopA:=(stopA<>#0);
_stopB:=(stopB<>#0);
//prepare
maxp:=length(x);
//process
for p:=maxp downto 1 do
    if (_stopA and (x[p]=stopA)) then break
    else if (_stopB and (x[p]=stopB)) then break
    else if (x[p]=y) then
         begin
         a:=copy(x,1,p-1);
         b:=copy(x,p+1,maxp);
         result:=true;
         break;
         end;//end of if
except;end;
end;
//## floattostrex2 ##
function floattostrex2(x:extended):string;//19DEC2007
begin
try;result:=floattostrex(x,18);except;end;
end;
//## floattostrex ##
function floattostrex(x:extended;dig:byte):string;//07NOV20210
var//0=integer part only, 1-18=include partial content if present
   p:integer;
   a,b,c:string;
begin
try
//defaults
result:='0';
//get
a:=floattostrf(x,ffFixed,18,18);
b:='';
c:='';
for p:=1 to length(a) do if (a[p]='.') then
   begin
   if (dig>=1) then b:=copy(a,p+1,dig);
   a:=copy(a,1,p-1);
   break;
   end;//end of if
//scan
if (b<>'') then for p:=length(b) downto 1 do if (b[p]<>'0') then
   begin
   c:=copy(b,1,p);//strip off excess zeros - 07NOV2010
   break;
   end;//end of if
//set
result:=a+low__insstr('.'+c,c<>'');
except;end;
end;
//## strtofloatex ##
function strtofloatex(x:string):extended;//triggers less errors (x=nil now covered)
begin
try
//defaults
result:=0;
//get
if (x<>'') then result:=strtofloat(x);
except;end;
end;
//## strflt ##
function strflt(x:string):extended;//19aug2018, 27-JAN-2007, v1.00.020
var
   maxp,p:integer;
   b:string;
   xneg:boolean;
begin
try
//default
result:=0;
//xneg
xneg:=false;
if (x<>'') then for p:=1 to length(x) do
   begin
   if (x[p]='-') then
      begin
      xneg:=true;
      delete(x,p,1);
      break;
      end
   else if (x[p]='.') then break;
   end;//p
//init
b:='';
maxp:=length(x);
//split
for p:=1 to maxp do if (x[p]='.') then
    begin
    b:=copy(x,p+1,maxp);
    x:=copy(x,1,p-1);
    break;
    end;//end of if
//return result
//.whole
result:=strcur(x);
//.fraction
if (b<>'') then result:=result+(strcur(b)/nozero_ext(1200000,power(10,length(b))) );
//.xneg
if xneg then result:=-result;
except;end;
end;
//## xremcharb ##
function xremcharb(x:string;c:char):string;//26apr2019
begin
try;result:=x;xremchar(result,c);except;end;
end;
//## xremchar ##
function xremchar(var x:string;c:char):boolean;//26apr2019
var
   i,maxp,p:integer;
begin
try
//defaults
result:=false;
maxp:=length(x);
i:=0;
//get
if (maxp>=1) then for p:=1 to maxp do
   begin
   if (x[p]=c) then inc(i)
   else if (i<>0) then x[p-i]:=x[p];
   end;//p
//shrink
if (i<>0) then setlength(x,maxp-i);
except;end;
end;
//## strint_filtered ##
function strint_filtered(x:string):longint;//removes "comma,space" automatically
begin
try
xremchar(x,',');
xremchar(x,#32);
result:=strint(x);
except;end;
end;
//## strint_filtered64 ##
function strint_filtered64(x:string):comp;//removes "comma,space" automatically
begin
try
xremchar(x,',');
xremchar(x,#32);
result:=strint64(x);
except;end;
end;
//## strint ##
function strint(const x:string):longint;//date: 25mar2016 v1.00.50 / 10DEC2009, v1.00.045
var //Similar speed to "strtoint" - no erros are produced though
    //Fixed "integer out of range" error, for data sets that fall outside of range
   n,xlen,z,y:integer;
   tmp:currency;
begin
try
{default}
result:=0;
tmp:=0;
if (x='') then exit;
{prepare}
xlen:=length(x);
n:=1;
{process}
z:=1;
while TRUE do
begin
y:=byte(x[z]);
if (y=45) then n:=-1
else
    begin
    if (y<48) or (y>57) then break;
    tmp:=tmp*10+y-48;
    end;
z:=z+1;
if (z>xlen) then break;
//.range limit => prevent error "EInvalidOP - Invalid floating point operation" - 25mar2016
if (tmp>maxint) then
   begin
   tmp:=maxint;
   break;
   end;
end;//end of while
//n
tmp:=frccurrange(tmp*n,minint,maxint);
result:=round(tmp);
except;end;
end;
//## extstr ##
function extstr(x:extended):string;//17sep2018
begin
try;result:=floattostrex2(x);except;end;
end;
//## strext ##
function strext(x:string):extended;//17sep2018
begin
try;result:=strflt(x);except;end;
end;
//## curstr ##
function curstr(x:currency):string;//27nov2017
begin
try;result:=floattostrex2(x);except;end;
end;
//## strcur ##
function strcur(const x:string):currency;//v1.00.070 - 07NOV2010
label
   skipone;
var //similar speed to "strtoint" - no errors are produced though
   n,xlen,z,y:integer;
   dotdiv:currency;
   dotok:boolean;
begin
try
//default
result:=0;
if (x='') then exit;
//prepare
xlen:=length(x);
n:=1;
dotok:=false;
dotdiv:=10;
//process
z:=1;
while TRUE do
begin
y:=byte(x[z]);
if (y=45) then n:=-1
else
    begin
    //decide
    if (not dotok) and (y=46) then
       begin
       dotok:=true;//decimal point - 07NOV2010
       goto skipone;
       end
    else if (y<48) or (y>57) then break;
    //set - 07NOV2010
    case dotok of
    false:result:=result*10+y-48;
    true:begin//5 digit max - (x/100,000)
       if (dotdiv<>0) then result:=result+((y-48)/nozero_cur(1200001,dotdiv));
       dotdiv:=dotdiv*10;
       if (dotdiv>=1000000) then break;
       end;
    end;//end of case
    end;
skipone:
z:=z+1;
if (z>xlen) then break;
end;//end of while
//n
result:=result*n;
except;end;
end;
//## curstrex ##
function curstrex(x:currency;sep:string):string;//01aug2017, 07SEP2007
var
   i,maxp,p:longint;
   decbit,z2,Z,Y:String;
begin
try
//defaults
result:='0';
decbit:='';
//init
z2:='';
if (x<0) then
   begin
   x:=-x;
   z2:='-';
   end;//end of if
//.dec point fix - 01aug2017
y:=floattostrex2(x);
if (y<>'') then for p:=1 to length(y) do if (y[p]='.') then
   begin
   decbit:=copy(y,p,length(y));
   y:=copy(y,1,p-1);
   break;
   end;
//get
z:='';
maxp:=length(y);
i:=0;
for p:=maxp downto 1 do
begin
i:=i+1;
if (i>=3) and (p<>1) then
   begin
   z:=sep+copy(y,p,3)+z;
   i:=0;
   end;//end of if
end;//end of loop
if (i<>0) then z:=copy(y,1,i)+z;
//return result
result:=z2+z+decbit;
except;end;
end;
//## curcomma ##
function curcomma(x:currency):string;{same as "Thousands" but for "double"}
begin
try;result:=curstrex(x,',');except;end;
end;
//## strdec ##
function strdec(a:string;y:byte;z:boolean):string;
var
   b:string;
   aLen,p:integer;
begin
try
{enforce range}
//y
if (y<0) then y:=0
else if (y>10) then y:=10;
{prepare}
aLen:=length(a);
b:='';
{process}
//get
for p:=1 to aLen do if (a[p]='.') then
    begin
    b:=copy(a,p+1,aLen);
    a:=copy(a,1,p-1);
    break;
    end;//end of if
//z - thousands
if z then a:=curcomma(strtofloatex(a));
{return result}
if (y<=0) then result:=a else result:=a+'.'+copy(b+'0000000000',1,y);
except;end;
end;
//## curdec ##
function curdec(x:currency;y:byte;z:boolean):string;
begin
try;result:=strdec(floattostrex2(x),y,z);except;end;
end;
//## strint64 ##
function strint64(const x:string):comp;//v1.00.033 - 28jan2017
var
   n,digcount,xlen,z,y:longint;
begin
try
//defaults
result:=0;
if (x='') then exit;
//init
xlen:=length(x);
digcount:=0;//comp 64bit allows for 18 digit WHOLE numbers (- and +) - 28jan2017
n:=1;
//get
z:=1;
while true do
begin
y:=byte(x[z]);
if (y=45) then n:=-n
else
    begin
    if (y<48) or (y>57) then break;
    result:=result*10+(y-48);
    inc(digcount);
    end;
z:=z+1;
//.range limit to 18 digits => prevent error "EInvalidOP - Invalid floating point operation" - 27jan2017
if (z>xlen) or (digcount>=18) then break;
end;//end of while
//sign
result:=n*result;
except;end;
end;
//## intstr64 ##
function intstr64(x:comp):string;//30jan2017
var
   p:integer;
begin
try
//defaults
result:='0';
//get
result:=floattostrf(x,ffFixed,18,18);
for p:=1 to length(result) do if (result[p]='.') then
   begin
   result:=copy(result,1,p-1);
   break;
   end;
except;end;
end;
//## int32 ##
function int32(x:comp):longint;
begin//Note: Clip a 64bit integer to a 32bit integer range
try
if (x>maxint) then x:=maxint
else if (x<minint) then x:=minint;
result:=round(x);
except;end;
end;
//## int32RANGE ##
function int32RANGE(x,xmin,xmax:comp):longint;
begin//Note: Clip a 64bit integer to a 32bit integer range
try
//range
if (x<xmin) then x:=xmin
else if (x>xmax) then x:=xmax;
//32bit range
if (x>maxint) then x:=maxint
else if (x<minint) then x:=minint;
//get
result:=round(x);
except;end;
end;
//## safeinc ##
procedure safeinc(var x:integer);//16jun2014
begin
try;if (x<maxint) then inc(x);except;end;
end;
//## cround ##
function cround(x:extended):currency;//19DEC2007
begin//Note: extended maintains high-level "x/y" values, which if were transfered
try  //within currency would be slightly rounded causing distortion/errors
//defaults
result:=0;
//set
result:=strtocurr(floattostrex(x,0));//remove partial content
except;end;
end;

//## twordcore #################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx//wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
//-- low level support for "tbarcore" - 05dec2019 ------------------------------//8888888888888888888888
//## low__barcore__inited ##
function low__barcore__inited(var x:tbarcore):boolean;
begin
try;result:=(x.initstate='inited');except;end;
end;
//## low__barcore__mark ##
function low__barcore__mark(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
var
   p:longint;
begin
try
//defaults;
result:=false;
//check
if not low__barcore__inited(x) then exit;
if (xclickint=0) and (xclickstr='') then exit;
if (x.bcount<=0) then exit;
//find first
for p:=0 to (x.bcount-1) do if ((xclickint=0) or (xclickint=x.bint[p])) and ((xclickstr='') or (comparetext(xclickstr,x.bstr[p])=0)) then
   begin
   if xsetval then
      begin
      if (x.bmark[p]<>xval) then
         begin
         x.bmark[p]:=xval;
         x.mustpaint:=true;
         end;
      end;
   result:=x.bmark[p];
   break;
   end;
except;end;
end;
//## low__barcore__enabled ##
function low__barcore__enabled(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
var
   p:longint;
begin
try
//defaults;
result:=false;
//check
if not low__barcore__inited(x) then exit;
if (xclickint=0) and (xclickstr='') then exit;
if (x.bcount<=0) then exit;
//find first
for p:=0 to (x.bcount-1) do if ((xclickint=0) or (xclickint=x.bint[p])) and ((xclickstr='') or (comparetext(xclickstr,x.bstr[p])=0)) then
   begin
   if xsetval then
      begin
      if (x.benabled[p]<>xval) then
         begin
         x.benabled[p]:=xval;
         x.mustpaint:=true;
         end;
      end;
   result:=x.benabled[p];
   break;
   end;
except;end;
end;
//## low__barcore__focused ##
function low__barcore__focused(var x:tbarcore;xclickstr:string;xclickint:longint;xsetval,xval:boolean):boolean;
var
   p:longint;
begin
try
//defaults;
result:=false;
//check
if not low__barcore__inited(x) then exit;
if (xclickint=0) and (xclickstr='') then exit;
if (x.bcount<=0) then exit;
//find first
for p:=0 to (x.bcount-1) do if ((xclickint=0) or (xclickint=x.bint[p])) and ((xclickstr='') or (comparetext(xclickstr,x.bstr[p])=0)) then
   begin
   if xsetval then
      begin
      case xval of
      true:begin
         if (x.focusindex<>p) then
            begin
            x.focusindex:=p;
            x.mustpaint:=true;
            end;
         end;
      false:begin
         if (x.focusindex=p) then
            begin
            x.focusindex:=-1;
            x.mustpaint:=true;
            end;
         end;
      end;//case
      end;//set
   result:=(x.focusindex=p);
   break;
   end;
except;end;
end;
//## low__barcore__clicked ##
function low__barcore__clicked(var x:tbarcore;var xclickstr:string;var xclickint:longint):boolean;
var
   i:longint;
begin
try
//defaults
result:=false;
//check
if not low__barcore__inited(x) then exit;
//get
i:=x.clickindex;
if (x.bcount>=1) and (i>=0) and (i<x.bcount) and (i<=high(x.bcap)) and x.benabled[i] then
   begin
   if (x.bint[i]<>0) or (x.bstr[i]<>'') then
      begin
      result:=true;
      xclickstr:=x.bstr[i];
      xclickint:=x.bint[i];
      end;
   end;
//reset
x.clickindex:=-1;
except;end;
end;
//## low__barcore__add ##
function low__barcore__add(var x:tbarcore;xcaption,ximage,xclickstr:string;xclickint:longint;xenabled:boolean):boolean;
var
   int1,p:longint;
begin
try
//defaults
result:=false;
//check
if not low__barcore__inited(x) then exit;//structure not init'ed
if (x.bcount<0) then exit;//out of range -> should never happen
if (x.bcount>high(x.bcap)) then exit;//at capacity
//get
p:=x.bcount;
x.bcap[p]:=xcaption;
x.bsep[p]:=false;
x.benabled[p]:=xenabled;
x.bstr[p]:=xclickstr;
x.bint[p]:=xclickint;
low__imgtoraw24(ximage,x.bimg24[p],int1,x.bimgw[p],x.bimgh[p]);//allow to fail
inc(x.bcount);
x.mustpaint:=true;
//successful
result:=true;
except;end;
end;
//## low__barcore__addsep ##
function low__barcore__addsep(var x:tbarcore):boolean;
var
   int1,p:longint;
begin
try
//defaults
result:=false;
//check
if not low__barcore__inited(x) then exit;//structure not init'ed
if (x.bcount<0) then exit;//out of range -> should never happen
if (x.bcount>high(x.bcap)) then exit;//at capacity
//get
p:=x.bcount;
x.bcap[p]:='';
x.bsep[p]:=true;
x.benabled[p]:=false;
x.bmark[p]:=false;
x.bstr[p]:='';
x.bint[p]:=0;
x.bimg24[p]:='';
inc(x.bcount);
x.mustpaint:=true;
//successful
result:=true;
except;end;
end;
//## low__barcore__keyboard ##
procedure low__barcore__keyboard(var x:tbarcore;xctrl,xalt,xshift,xkeyX:boolean;xkey:byte);
begin
try;low__barcore(x,'kstack',char(low__insint(1,xctrl))+char(low__insint(1,xalt))+char(low__insint(1,xshift))+char(low__insint(1,xkeyX))+char(xkey));except;end;
end;
//## low__barcore__mouse ##
procedure low__barcore__mouse(var x:tbarcore;xmousex,xmousey:longint;xmousedown,xmouseright:boolean);
begin
try;low__barcore(x,'mstack',from32bit(xmousex)+from32bit(xmousey)+char(low__insint(1,xmousedown))+char(low__insint(1,xmouseright)));except;end;
end;
//## low__barcore__mouselite ##
procedure low__barcore__mouselite(var x:tbarcore;xmousex,xmousey:longint);
begin
try;low__barcore(x,'xy>click',from32bit(xmousex)+from32bit(xmousey));except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//888888888888888888888888
//## low__barcore__draw ##
procedure low__barcore__draw(var x:tbarcore;var xfc:string);
label
   skipend;
const
   mv=2;//mark shift value
var
   xstyle,str1,e:string;
   xfeather,ov,sx,xtxfoccol,xtxdiscol,xmaxh,xtxcol,tw,th,iw,ih,xswapblack,dx,dy,ddy,xbits,xw,xh,xlen,int1,int2,int3,p:longint;
   xdown,xautoheight,xmark,xfocus,xenabled,ximages,xcaptions,bol1:boolean;
   pr24:pcolorrows24;
   dr32:pcolorrow32;
   c24:tcolor24;
   c32:tcolor32;
begin
try
//defaults
xfc:='';//feather core -> used when "x.feather=true"
//check
if not low__barcore__inited(x) then exit;

//init
xbits:=32;
xtxcol:=x.txcol;
xtxdiscol:=low__greyscale3(x.txcol);
xtxfoccol:=low__focus3(x.txcol);
xfeather:=x.feather;
xstyle:=x.style;
if x.txswap then xswapblack:=xtxcol else xswapblack:=clnone;
//.style
ximages:=false;
xcaptions:=false;
xautoheight:=false;
if (xstyle<>'') then
   begin
   for p:=1 to length(xstyle) do
   begin
   if      (xstyle[p]='i') or (xstyle[p]='I') then ximages:=true
   else if (xstyle[p]='c') or (xstyle[p]='C') then xcaptions:=true
   else if (xstyle[p]='a') or (xstyle[p]='A') then xautoheight:=true;
   end;//p
   end;
if (not ximages) and (not xcaptions) then
   begin
   ximages:=true;
   xcaptions:=true;
   end;

//font
str1:=inttostr(x.fsize)+'|'+lowercase(x.fname);
if (str1<>x.fref) then
   begin
   x.fref:=str1;
   low__toLGF2(x.fname,x.fsize,false,x.lgfdata,e);
   //low__toLGF(x.fname,x.fsize,false,x.lgfdata,e);
   end;

//xmaxh
xmaxh:=0;
//.all images
if ximages then
   begin
   for p:=0 to (x.bcount-1) do if (x.bimg24[p]<>'') and (x.bimgh[p]>xmaxh) then xmaxh:=x.bimgh[p];
   end;
//.first caption
if xcaptions then
   begin
   for p:=0 to (x.bcount-1) do
   begin
   if (x.bcap[p]<>'') then
      begin
      if (low__fromLGF_height(x.lgfdata)>xmaxh) then xmaxh:=low__fromLGF_height(x.lgfdata);
      break;
      end;
   end;//p
   end;

//size
if xautoheight then x.height:=frcmin(xmaxh+(2*mv),1);
xw:=frcmin(x.width,1);
xh:=frcmin(x.height,1);
xlen:=xw*xh*(xbits div 8);
if (x.bufferw<>xw) or (x.bufferh<>xh) or (length(x.buffer32)<xlen) then
   begin
   x.bufferw:=xw;
   x.bufferh:=xh;
   if (length(x.buffer32)<xlen) then setlength(x.buffer32,xlen);
   if not low__rawrows32(x.buffer32,32,xw,xh,x.bufferrows32,x.buffermem) then goto skipend;
   end;

//background
int1:=x.bkcol;
int2:=int1;
int3:=int1;
if (x.bkcol2<>clnone) then int2:=x.bkcol2;
if (x.bkcol3<>clnone) then int3:=x.bkcol3;
low__rawcls2432(int1,int2,x.buffer32,xw,xh,xbits,rect(0,0,xw-1,xh div 2));
low__rawcls2432(int2,int3,x.buffer32,xw,xh,xbits,rect(0,xh div 2,xw-1,xh-1));

//.ddy - baseline for all images/captions to horizontally align by
ddy:=(xh-xmaxh) div 2;

//draw buttons
dx:=0;
dy:=0;
for p:=0 to (x.bcount-1) do
begin
bol1:=false;
xfocus:=(x.focusindex=p);
xmark:=x.bmark[p];
xenabled:=x.benabled[p];
xdown:=xfocus and xenabled and x.down;//mouse down
sx:=dx;
if xmark or xdown then ov:=mv else ov:=0;
//.sep
if x.bsep[p] then
   begin
   inc(dx,7);
   low__rawcls2432(0,0,x.buffer32,xw,xh,xbits,rect(dx,2,dx,xh-3));
   inc(dx,7);
   end;
//.image
if ximages and (x.bimg24[p]<>'') then
   begin
   //small leading space
   inc(dx,5);
   //init
   iw:=x.bimgw[p];
   ih:=x.bimgh[p];
   //get
   low__rawdraww2432(x.bimg24[p],24,iw,ih,true,x.buffer32,xbits,xw,xh,dx+ov,ddy+ov,xswapblack,rect(0,0,xw-1,xh-1),not xenabled,false);
   inc(dx,iw);
   bol1:=true;
   end;
//.caption
if xcaptions and (x.bcap[p]<>'') then
   begin
   //small leading space
   if bol1 then inc(dx,frcmin(2,mv)) else inc(dx,5);
   //init
   tw:=0;
   th:=0;
   if (x.bcap[p]<>'') then
      begin
      tw:=low__fromLGF_textwidth(x.lgfdata,x.bcap[p]);
      th:=low__fromLGF_height(x.lgfdata);
      end;
   //get
   pr24:=nil;
   low__fromLGF_drawtext2432(x.lgfdata,x.bcap[p],dx+ov,ddy+ov,xw,xh,low__aorb(xtxdiscol,xtxcol,xenabled),rect(0,0,maxint,maxint),pr24,x.bufferrows32,nil,0,xfc,xfeather,false,false,false,false);
   inc(dx,tw);
   bol1:=true;
   end;
//.button space
if bol1 then
   begin
   inc(dx,5);
   x.bleft[p]  :=sx;
   x.bright[p] :=dx;
   end;
//.focus
if xenabled and xfocus then
   begin
   low__rawdraww2432(x.buffer32,xbits,xw,xh,false,x.buffer32,xbits,xw,xh,0,0,clnone,rect(sx,0,dx,xh-1),false,true);
   end;
//.mark
if xenabled and xmark then
   begin
   low__rawdraww2432(x.buffer32,xbits,xw,xh,false,x.buffer32,xbits,xw,xh,0,0,clnone,rect(sx,0,dx,mv),false,true);
   low__rawdraww2432(x.buffer32,xbits,xw,xh,false,x.buffer32,xbits,xw,xh,0,0,clnone,rect(sx,frcmin(xh-mv-1,0),dx,xh-1),false,true);
   end;
end;//p

//successful
skipend:
except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//8888888888888888888888888888
//## low__barcore__paint2432 ##
function low__barcore__paint2432(var x:tbarcore;ax,ay,aw,ah:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32):boolean;
label
   skipend;
var
   sw,sh:longint;
begin
try
//defaults
result:=false;
//check
if not low__barcore__inited(x) then exit;
if ((ar24=nil) and (ar32=nil)) or (aw<1) or (ah<1) then exit;
//init
sw:=x.width;
sh:=x.height;
if (sw<1) or (sh<1) then goto skipend;
acliparea.left:=frcrange(acliparea.left,0,aw-1);
acliparea.right:=frcrange(acliparea.right,acliparea.left,aw-1);
acliparea.top:=frcrange(acliparea.top,0,ah-1);
acliparea.bottom:=frcrange(acliparea.bottom,acliparea.top,ah-1);
//get
result:=low__rawdrawr2432(x.buffer32,32,sw,sh,false,ar24,ar32,aw,ah,ax,ay,clnone,acliparea,false,false);
skipend:
except;end;
end;
//## low__barcore__paintcanvas32 ##
function low__barcore__paintcanvas32(var x:tbarcore;xcanvas:tcanvas;xclientwidth,xclientheight:longint):boolean;
label
   skippaint;
var
   a:tbitmap;
   dw,dh:longint;
begin
try
//defaults
result:=false;
a:=nil;
//check
if not low__barcore__inited(x) then exit;
if (xcanvas=nil) then exit;
//range
xclientwidth:=frcmin(xclientwidth,1);
xclientheight:=frcmin(xclientheight,1);
//init
dw:=frcmin(frcmax(x.width,xclientwidth),0);
dh:=frcmin(frcmax(x.height,xclientheight),0);
if (dw<1) or (dh<1) then goto skippaint;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx//888888888888888888888888888
//init
a:=tbitmap.create;
a.pixelformat:=pf32bit;
a.width:=dw;
a.height:=dh;
//paint
low__rawdraw2432(x.buffer32,32,x.width,x.height,false,a,0,0,clnone,rect(0,0,a.width-1,a.height-1),false,false);
xcanvas.draw(0,0,a);

skippaint:
//cls unused areas
low__clsoutside3(xcanvas,xclientwidth,xclientheight,0,0,dw,dh,x.bkcol);
//successful
result:=true;
except;end;
try;freeobj(@a);except;end;
end;
//## low__barcore ##
function low__barcore(var x:tbarcore;xcmd,xval:string):boolean;
var
   xoutval,e:string;
begin
try;result:=false;low__barcore3(x,xcmd,xval,xoutval,e);result:=(xoutval<>'') and (xoutval<>'0');except;end;
end;
//## low__barcore2 ##
function low__barcore2(var x:tbarcore;xcmd,xval:string):longint;
var
   xoutval,e:string;
begin
try;result:=0;low__barcore3(x,xcmd,xval,xoutval,e);result:=strint(xoutval);except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//88888888888888888888888888888888
//## low__barcore3 ##
function low__barcore3(var x:tbarcore;xcmd,xval:string;var xoutval,e:string):boolean;
label
   skipdone,skipend;
var
   p,dx,dy,int1,int2,int3:longint;
   n,v,str1,str2,str3,str4,str5,str6:string;
   xctrl,xalt,xshift,xkeyx,xmusttimerunbusy,bol1,bol2,bol3:boolean;
   c:char;
   //## xstackpull ##
   function xstackpull(var xstack,xval:string):boolean;
   var//supports variable size entry lengths
      xlen:longint;
   begin
   try
   //defaults
   result:=false;
   xval:='';
   //get
   if (length(xstack)>=4) then
      begin
      xlen:=frcmin(to32bit(copy(xstack,1,4)),0);
      if (xlen>=1) then xval:=copy(xstack,5,xlen);
      delete(xstack,1,4+xlen);
      result:=true;
      end;
   except;end;
   end;
   //## xsetbol ##
   function xsetbol(var dval:boolean):boolean;
   var
      bol1:boolean;
   begin
   try
   result:=false;
   if (xval<>'') then
      begin
      bol1:=(strint(xval)<>0);
      if (bol1<>dval) then
         begin
         dval:=bol1;
         x.mustpaint:=true;
         result:=true;
         end;
      end;
   except;end;
   end;
   //## xsetint32 ##
   function xsetint32(var dval:longint;xmin,xmax:longint;xenforcerange:boolean):boolean;
   var
      int1:longint;
   begin
   try
   result:=false;
   if (xval<>'') then
      begin
      int1:=strint(xval);
      if xenforcerange then int1:=frcrange(int1,xmin,xmax);
      if (int1<>dval) then
         begin
         dval:=int1;
         x.mustpaint:=true;
         result:=true;
         end;
      end;
   except;end;
   end;
   //## xclearbuttons ##
   procedure xclearbuttons;
   var
      p:longint;
   begin
   try
   x.downindex         :=-1;
   x.focusindex        :=-1;//not butotn has focus
   x.bcount            :=0;
   for p:=0 to high(x.bcap) do
   begin
   x.bcap[p]           :='';
   x.bsep[p]           :=false;
   x.benabled[p]       :=false;
   x.bmark[p]          :=false;
   x.bimg24[p]         :='';
   x.bimgw[p]          :=0;
   x.bimgh[p]          :=0;
   x.bimgt[p]          :=false;
   x.bint[p]           :=0;
   x.bstr[p]           :='';
   x.bleft[p]          :=0;
   x.bright[p]         :=0;
   end;//p
   except;end;
   end;
begin
try
//defaults
result:=false;
xcmd:=lowercase(xcmd);
xoutval:='';
xmusttimerunbusy:=false;
e:=gecTaskfailed;
//init

//check + init
if (xcmd='timer') then//special host driven call -> used by this proc to check keep params and act accordingly - 22aug2019
   begin
   //check
   if x.timerbusy or (x.initstate<>'inited') then goto skipend;
   //init
   xmusttimerunbusy:=true;//remember to turn busy signal back off down below
   x.timerbusy:=true;

   //mstack --------------------------------------------------------------------
   while xstackpull(x.mstack,str1) do
   begin
   if (length(str1)>=10) then
      begin
      //init
      dx:=to32bit(copy(str1,1,4));//1..4
      dy:=to32bit(copy(str1,5,4));//5..8
      bol1:=(str1[9]=#1);//down
      bol2:=(str1[10]=#1);//right click
      x.down:=bol1;
      x.right:=bol2;
      //get
      if (not bol2) then
         begin
         low__barcore2(x,'xy>focus',from32bit(dx)+from32bit(dy));
         if (not bol1) and x.wasdown then low__barcore2(x,'xy>click',from32bit(dx)+from32bit(dy));
         end;
      //set
      x.wasdown:=bol1;
      x.wasright:=bol2;
      end;//if
   end;//while

   //kstack --------------------------------------------------------------------
   while xstackpull(x.kstack,str1) do
   begin
   if (length(str1)>=5) then
      begin
      //init
      xctrl:=(str1[1]=#1);
      xalt:=(str1[2]=#1);
      xshift:=(str1[3]=#1);
      xkeyx:=(str1[4]=#1);;
      c:=str1[5];
      str1:='';
      //.retain these key states - 31aug2019
      x.shift:=xshift;
      //get
      //.shortcut
      if xctrl and xkeyx and ((c>='A') and (c<='Z')) then
         begin
         //not supported
         end
      //.special key
      else if xkeyx then
         begin
{//xxxxxxxxxxxxxxxxxxx
         case ord(c) of
         vk_return:   low__wordcore(x,'ins',#10);
         vk_tab:      low__wordcore(x,'ins',#9);
         vk_left:     low__wordcore(x,'move','left');
         vk_right:    low__wordcore(x,'move','right');
         vk_up:       low__wordcore(x,'move','up');
         vk_down:     low__wordcore(x,'move','down');
         vk_prior:    low__wordcore(x,'move','pageup');
         vk_next:     low__wordcore(x,'move','pagedown');
         vk_home:     low__wordcore(x,'move','home');
         vk_end:      low__wordcore(x,'move','end');
         end;//case
{}//xxxxxxxxxxxxxxxxxxxxxxx
         end
      //.standard character
      else if not xkeyx then
         begin
         //xxxxxxxxxxxxxxxxx low__wordcore(x,'ins',c);
         end;
      end;//if
   end;//while

   //sync + paint --------------------------------------------------------------
   if (ms64>=x.timer100) then
      begin
      str1:=bn(x.down)+bn(x.wasdown)+bn(x.right)+bn(x.wasright)+'|'+inttostr(x.width)+'|'+inttostr(x.height)+'|'+inttostr(x.bkcol)+'|'+inttostr(x.bkcol2)+'|'+inttostr(x.bkcol3)+'|'+inttostr(x.txcol)+'|'+inttostr(x.hicol)+'|'+bn(x.txswap)+'|'+x.style+'|'+inttostr(x.fsize)+#7+x.fname+#7;
      if (x.syncref<>str1) then
         begin
         x.syncref:=str1;
         x.mustpaint:=true;
         end;
      //reset
      x.timer100:=ms64+100;
      end;

   //done
   goto skipdone;
   end
else if (xcmd='getinited') then
   begin
   if (x.initstate='inited') then xoutval:='1' else xoutval:='0';
   goto skipdone;
   end
else if (x.initstate='initing') then
   begin
   e:='Init busy';
   exit;
   end
else if (x.initstate<>'inited') then
   begin
   if (xcmd='init') then
      begin
      //init
      x.initstate:='initing';
      //.buffer support -> used for screen painting
      x.buffer32             :='';
      x.bufferrows32         :=nil;
      x.buffermem            :='';
      x.bufferw              :=0;
      x.bufferh              :=0;
      x.bufferref            :='';
      //system
      x.syncref              :='';
      x.timer100:=ms64;
      x.timerslow:=ms64;
      x.timerbusy:=false;
      x.syncref:='';
      x.kstack:='';
      x.mstack:='';
      x.shortcuts:=true;
      x.shift:=false;
      x.down:=false;
      x.right:=false;
      x.wasdown:=false;
      x.wasright:=false;
      x.feather:=1;//light feather - 02jun2020
      //clear buttons
      xclearbuttons;
      x.clickindex        :=-1;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx//88888888888888888888888
      //paint
      x.hicol             :=rgb(255,255,255);//white - highlight color
      x.txcol             :=rgb(0,0,0);//black - text color
      x.txswap            :=false;
      x.bkcol             :=rgb(190,190,190);//dark-gray - background shade colors
      x.bkcol2            :=rgb(240,240,240);//light-gray
      x.bkcol3            :=rgb(190,190,190);//dark-gray
      x.width             :=200;
      x.height            :=28;
      x.fname             :='arial';
      x.fsize             :=10;
      x.fref              :='';
      x.lgfdata           :='';
      x.style             :='ica';//images + captions + autoheight
      x.mustpaint         :=true;
      x.paintlock         :=false;
      //finalise
      x.initstate:='inited';
      //successful
      result:=true;
      goto skipend;
      end
   else
      begin
      e:='Must init';
      goto skipend;
      end;
   end;

//-- information ---------------------------------------------------------------
if (xcmd='init') then
   begin
   //nil
   end
//.paint
else if (xcmd='canpaint') then
   begin
   xoutval:='1';
   end
else if (xcmd='mustpaint') then
   begin
   //set
   if (xval<>'') then x.mustpaint:=(strint(xval)<>0);
   //get
   if x.mustpaint then xoutval:='1';
   end
else if (xcmd='paintlock') then
   begin
   if (xval<>'') then
      begin
      bol1:=(strint(xval)<>0);
      if bol1 and x.paintlock then xoutval:='0'//already painting
      else
         begin
         x.paintlock:=bol1;
         xoutval:='1';
         end;
      end;
   end
//.keyboard support
else if (xcmd='kstack') then
   begin
   if (xval<>'') then x.kstack:=x.kstack+from32bit(length(xval))+xval;
   end
//.mouse support
else if (xcmd='mstack') then
   begin
   if (xval<>'') then x.mstack:=x.mstack+from32bit(length(xval))+xval;
   end
//xxxxxxxxxxxxxxxx//888888888888888888
else if (xcmd='width') then
   begin
   xsetint32(x.width,1,maxint,true);//set
   xoutval:=inttostr(x.width);
   end
else if (xcmd='height') then
   begin
   xsetint32(x.height,1,maxint,true);//set
   xoutval:=inttostr(x.height);
   end
else if (xcmd='bkcol') then
   begin
   xsetint32(x.bkcol,0,0,false);//set
   xoutval:=inttostr(x.bkcol);
   end
else if (xcmd='bkcol2') then
   begin
   xsetint32(x.bkcol2,0,0,false);//set
   xoutval:=inttostr(x.bkcol2);
   end
else if (xcmd='bkcol3') then
   begin
   xsetint32(x.bkcol3,0,0,false);//set
   xoutval:=inttostr(x.bkcol3);
   end
else if (xcmd='txcol') then
   begin
   xsetint32(x.txcol,0,0,false);//set
   xoutval:=inttostr(x.txcol);
   end
else if (xcmd='hicol') then
   begin
   xsetint32(x.hicol,0,0,false);//set
   xoutval:=inttostr(x.hicol);
   end
else if (xcmd='txswap') then
   begin
   xsetbol(x.txswap);//set
   xoutval:=bn(x.txswap);
   end
else if (xcmd='feather') then
   begin
   xsetint32(x.feather,0,2,true);//0=off, 1=light, 2=heavy
   xoutval:=inttostr(x.feather);
   end
else if (xcmd='style') then
   begin
   if (xval<>'') then
      begin
      //get
      bol1:=false;
      bol2:=false;
      bol3:=false;
      for p:=1 to length(xval) do
      begin
      if      (xval[p]='i') or (xval[p]='I') then bol1:=true//display button images
      else if (xval[p]='c') or (xval[p]='C') then bol2:=true//display button captions
      else if (xval[p]='a') or (xval[p]='A') then bol2:=true;//automatic height
      end;//p
      //set
      str1:='';
      if bol1 then str1:=str1+'i';
      if bol2 then str1:=str1+'c';
      if bol3 then str1:=str1+'a';
      if (x.style<>str1) then
         begin
         x.style:=str1;
         x.mustpaint:=true;
         end;
      end;
   xoutval:=x.style;
   end
else if (xcmd='xy>focus') or (xcmd='xy>click') then
   begin
   //init
   int3:=-1;
   //get
   if (x.bcount>=1) and (xval<>'') then
      begin
      //int
      int1:=to32bit(copy(xval,1,4));//dx
      int2:=to32bit(copy(xval,5,4));//dy
      //get
      for p:=0 to (x.bcount-1) do if x.benabled[p] and (int1>=x.bleft[p]) and (int1<=x.bright[p]) and (int2>=0) and (int2<x.height) then
         begin
         int3:=p;
         break;
         end;
      end;
   //.focus
   if (x.focusindex<>int3) then
      begin
      x.focusindex:=int3;
      x.mustpaint:=true;
      end;
   //.down
   if (not x.wasdown) then x.downindex:=int3;
   //.click
   if (xcmd='xy>click') and (not x.wasright) then
      begin
      if (x.focusindex<>x.downindex) then int3:=-1;
      x.clickindex:=int3;
      end;
   end
//-- actions -------------------------------------------------------------------
else if (xcmd='free') then
   begin
   x.initstate:='';//disable control
   xclearbuttons;
   x.buffer32:='';
   x.lgfdata:='';
   end
else if (xcmd='clear') then
   begin
   xclearbuttons;
   x.mustpaint     :=true;
   end
else
   begin
   showerror60('Barcore: Unknown command "'+xcmd+'"');
   goto skipend;
   end;
//successful
skipdone:
result:=true;
skipend:
except;end;
try
if xmusttimerunbusy then x.timerbusy:=false;
except;end;
end;

//-- low level support for "twordcore" - 21aug2019 -----------------------------//55555555555555555
//## low__findimage ##
function low__findimage(ximgname:string;var xoutdata:string):boolean;
var
   n:string;
begin
try
//defaults
result:=false;
xoutdata:='';
//init
n:=lowercase(ximgname);
//get
if      (n='bold20.teh')          then xoutdata:='TEH1#BFAAAAAABEAAAAAAnZPeeApa9iiBlW8iiBlW8882ZK5CC3hS7882dO6882hS7882dO6882hS7882ZK5CC3hS7iiBlW8iiBlW8mmChS7882dO6CC3dO6882hS7882dO6882hS7882dO6882dO6CC3dO6mmChS7mmChS7eeAH5o'
else if (n='italic20.teh')        then xoutdata:='TEH1#BFAAAAAABEAAAAAAzlSSS7DzF441PBJ441L7I441PBJ441PBJ441PBJ441PBJ441L7I882L7I441PBJ441PBJ441PBJ441PBJ441L7I441PBJ441DzFSS7THr'
else if (n='underline20.teh')     then xoutdata:='TEH1#BFAAAAAABEAAAAAAnZP441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441hS7441lW8441lW8441dO6441pa9882VG4882teAWW81nCOO6F2XmmC9xl'
else if (n='strikeout20.teh')     then xoutdata:='TEH1#BFAAAAAABEAAAAAA3qTKK51nCWW8xiB441VG4882pa9441hS7441lW8441hS7441lW8441TFK882L7IOO6DzFOO6L7ICC3TFK441dO6uuEdO6441lW8441lW8441hS7441lW8882VG4882teAWW85rDKK5L9p'
else if (n='highlight20.teh')     then xoutdata:='TEH1#BFAAAAAABEAAAAAAjVOuuEVG4441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC34411nC441RC34411nC441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441RC3441J41'+'WW8J41441RC3441J41WW8J41441RC3441J41WW8J41441VG4uuE5tk'
else if (n='open20.teh')          then xoutdata:='TEH1#APAAAAAABEAAAAAAfTuTA2teAL20N82L20F00L201nCP61F00cI2hS7TA2UA0Hf0341Hf0sY6RC3UA0341Hf0341Hf0341Hf0341Hf0341UA0RC3UA0Hf0341Hf0341Hf0341Hf0341Hf0UA0RC3UA0341Hf0341Hf08pAHf0341Hf0UA0by8YE1341Hf0UA0by8UA0F00UA0Hf0UA0by8UA0J41YE1by8UA0RC34l9'+'vjyZK5'
else if (n='home20.teh')          then xoutdata:='TEH1#APAAAAAABEAAAAAACQcY51Fv0s30D00800KW7c50KB0800U10qq0D00800GS6c50bR0OF1800c50D00800CO5U10EW0yN0OF1KB0800D008008K4U10si0ca0Or0iF0KB0ca0KB0C41Fv00C2U100n0Sv10n0Gn0si0yN0ca0KB0800c50qq0s30U10si00n0Sv10n0Gn0ke0TN0oi1KB0800Y51yN0UW04r17a0zV0'+'TN0yN0jd4800c92800c50800c50G82800KC3s30U10Gn0Sv1Gn0ke0Dn1sm2ca0800QQ0s30U10Or0fz0z32G829j0sm2800QQ0s30c50Or0j320n0800H41KB0bR0ke0TN0800QQ0s30U10Or0fz0Sv1C41D00bR0vz0TN0vz0800QQ0s30U10Or0j32vz0800H41OF1TN0KB0800QQ0s30c50Or0j32Or0800H41TN0KB0'+'KB0KB0800QQ0s30c50U10g91U10aS7QQ0kxU'
else if (n='copy20.teh')          then xoutdata:='TEH1#APAAAAAABEAAAAAA9xl4A5lW8ot0xF4sx1hS7ot0xF4ot0l31ot0dO6ot0l31sx1l31CI7N82ot01K5ot0xF4sx1J41ot0l314A5xF4ot0l31ot0F00ot01K5ot0l31sx1l314A5l314A59S7sx11K5ot0l314A5l31sx1l314A59S7sx11K5ot0l314A5l31ot0F008E69S7ot0ZK5ot0l314A5l31ot0ZK5ot09S7'+'ot0dO6CI7ByV'//05jun2020
else if (n='more20.teh')          then xoutdata:='TEH1#BCAAAAAABEAAAAAAtghr76pa93K9hS7FWCVG4r76sx1n35VG4r76sx1r76N82vB7sx1vB7J41vB7sx1vB7J41br1WcCbr1J41br1WcCbr1J41vB7sx1vB7J41vB7sx1vB7N82r76sx1r76VG4n35sx1n35ZK5FWChS7zF8teAr76tgh'
else if (n='less20.teh')          then xoutdata:='TEH1#BCAAAAAABEAAAAAAtghr76pa93K9hS7FWCVG4JaDVG4NeEN82VmGJ41VmGJ41br1WcCbr1J41br1WcCbr1J41VmGJ41VmGN82NeEVG4FWCZK5FWChS7zF8teAr76tgh'
else if (n='bw20.teh')            then xoutdata:='TEH1#BCAAAAAABEAAAAAAtghNO6pa9Za9hS7hiB000VG4hiB441VG4deACC3N82deAKK5J41Za9OO6J41VW8SS7J41RS7WW8J41NO6aa9J41JK5eeAN82BC3eeAVG4341eeAZK5iiBhS7SS7teAKK5tgh'
else
   begin
   //image not found
   end;
//set
result:=(xoutdata<>'');
except;end;
end;
//## low__findimageb ##
function low__findimageb(ximgname:string):string;
begin
try;low__findimage(ximgname,result);except;end;
end;
//## low__wordcore__inited ##
function low__wordcore__inited(var x:twordcore):boolean;
begin
try;result:=(x.initstate='inited');except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx//5555555555555555555555555555//66666666666666666666
//## low__wordcore__bar ##
procedure low__wordcore__bar(var x:twordcore;xcmd,xval:string;var xoutval:string);//optional toolbar support
label
   skipend;
var
   str1,xfc:string;
   xpos,aw,ah,xbarh,dx,dy,int1:longint;
   ar24:pcolorrows24;
   ar32:pcolorrows32;
   acliparea:trect;
   bol1,bol2:boolean;
   //## xpull32 ##
   function xpull32:longint;
   begin
   try
   if (xpos<1) then xpos:=1;
   if ((xpos+3)<=length(xval)) then result:=to32bit(copy(xval,xpos,4)) else result:=0;
   inc(xpos,4);
   except;end;
   end;
   //## xupdatebuttons ##
   procedure xupdatebuttons;
   begin
   try
   //check
   if not x.barshow then exit;
   //get
   low__barcore__mark(x.bar,'bold',0,true,x.cbold);
   low__barcore__mark(x.bar,'italic',0,true,x.citalic);
   low__barcore__mark(x.bar,'underline',0,true,x.cunderline);
   low__barcore__mark(x.bar,'strikeout',0,true,x.cstrikeout);
//04jun2020
   low__barcore__mark(x.bar,'align.left',0,true,x.calign=x.c_alignleft);
   low__barcore__mark(x.bar,'align.center',0,true,x.calign=x.c_aligncentre);
   low__barcore__mark(x.bar,'align.right',0,true,x.calign=x.c_alignright);
//
   except;end;
   end;
begin
try
//init
xcmd:=lowercase(xcmd);
xoutval:='';
//get
if (xcmd='bar.init') then
   begin
   //init
   low__barcore(x.bar,'init','');//show images + captions + autoheight -> by default
   low__barcore(x.bar,'clear','');//incase proc is called more than once - 06dec2019
//02jun2020
   low__barcore__add(x.bar,'Copy','','copy',0,true);
   low__barcore__add(x.bar,'Copy All','','copyall',0,true);
   low__barcore__add(x.bar,'Paste','','paste',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'-','','pt-',0,true);
   low__barcore__add(x.bar,'+','','pt+',0,true);
//04jun2020
   low__barcore__add(x.bar,'L','','align.left',0,true);
   low__barcore__add(x.bar,'C','','align.center',0,true);
   low__barcore__add(x.bar,'R','','align.right',0,true);
//
   low__barcore__add(x.bar,'N','','normal',0,true);
   low__barcore__add(x.bar,'',low__findimageb('bold20.teh'),'bold',0,true);
   low__barcore__add(x.bar,'',low__findimageb('italic20.teh'),'italic',0,true);
   low__barcore__add(x.bar,'',low__findimageb('underline20.teh'),'underline',0,true);
   low__barcore__add(x.bar,'',low__findimageb('strikeout20.teh'),'strikeout',0,true);
   low__barcore__add(x.bar,'',low__findimageb('highlight20.teh'),'highlight',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'File',low__findimageb('home20.teh'),'file',100,true);
   low__barcore__add(x.bar,'Open',low__findimageb('open20.teh'),'open',101,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'W0','','w0',0,true);
   low__barcore__add(x.bar,'W1','','w1',0,true);
   low__barcore__add(x.bar,'W2','','w2',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'Arial','','arial',0,true);
   low__barcore__add(x.bar,'Courier','','courier new',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'black','','black',0,true);
   low__barcore__add(x.bar,'red','','red',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__add(x.bar,'bk-black','','bblack',0,true);
   low__barcore__add(x.bar,'bk-red','','bred',0,true);
   low__barcore__add(x.bar,'bk-none','','bnone',0,true);
   low__barcore__addsep(x.bar);
   low__barcore__addsep(x.bar);
//
   end
else if (xcmd='bar.updatebuttons') then xupdatebuttons
else if (xcmd='bar.draw') then low__barcore__draw(x.bar,xfc)
else if (xcmd='bar.drawcalc') then
   begin
   int1:=0;
   x.bar.width:=strint(xval);//expects "aw" -> host control pagewidth -> toolbar paints entire width of page
   if x.barshow then
      begin
      low__barcore__draw(x.bar,xfc);
      int1:=x.bar.height;
      end;
   x.barh:=int1;//barh
   end
else if (xcmd='bar.mouse') then
   begin
   //init
   dx:=to32bit(copy(xval,1,4));
   dy:=to32bit(copy(xval,5,4));
   bol1:=(copy(xval,9,1)='1');
   bol2:=(copy(xval,10,1)='1');
   //get
   int1:=dx;
   if (x.pagewidth<x.viewwidth) then dec(dx,(x.viewwidth-x.pagewidth) div 2) else inc(dx,low__wordcore2(x,'hpos2',''));
   low__barcore__mouse(x.bar,dx,dy,bol1,bol2);
   end
else if (xcmd='bar.paint') then
   begin
   //protect - detect non-32bit pointers and prevent bad corruption
   if (sizeof(tpointer)<>4) then goto skipend;
   //init
   xpos:=1;
   xbarh            :=xpull32;
   ar24             :=pointer(xpull32);
   ar32             :=pointer(xpull32);
   aw               :=xpull32;
   ah               :=xpull32;
   acliparea.left   :=xpull32;
   acliparea.top    :=xpull32;
   acliparea.right  :=xpull32;
   acliparea.bottom :=xpull32;
   //get
   low__rawdrawr2432(x.bar.buffer32,32,x.bar.width,xbarh,false,ar24,ar32,aw,ah,0,0,clnone,acliparea,false,false);
   end
else if (xcmd='bar.timer') then
   begin
   //.timer event
   low__barcore(x.bar,'timer','');
   //.button clicks
   if low__barcore__clicked(x.bar,str1,int1) then
      begin
      str1:=lowercase(str1);
//04jun2020
      if      (str1='all.arial') then low__wordcore(x,'all','arial')
      else if (str1='all.courier') then low__wordcore(x,'all','courier')
      else if (str1='all.-') then low__wordcore(x,'all','-')
      else if (str1='all.+') then low__wordcore(x,'all','+')
//
      else if (str1='bold') then
         begin
         x.cbold:=not x.cbold;
         low__wordcore(x,'cwritesel',str1);
         end
      else if (str1='italic') then
         begin
         x.citalic:=not x.citalic;
         low__wordcore(x,'cwritesel',str1);
         end
      else if (str1='underline') then
         begin
         x.cunderline:=not x.cunderline;
         low__wordcore(x,'cwritesel',str1);
         end
      else if (str1='strikeout') then
         begin
         x.cstrikeout:=not x.cstrikeout;
         low__wordcore(x,'cwritesel',str1);
         end
//02jun2020
      else if (str1='normal') then
         begin
         x.cbold:=false;
         x.citalic:=false;
         x.cunderline:=false;
         x.cstrikeout:=false;
         x.ccolor:=0;
         x.cbk:=clnone;
         x.cborder:=clnone;
         low__wordcore(x,'cwritesel','color+bk+style');//02jun2020
         end
      else if (str1='highlight') then
         begin
         swapint(x.ccolor,x.cbk);
         low__wordcore(x,'cwritesel','color+bk');//include both font.color and background.color
         end
//
//04jun2020
      else if (str1='align.left') then
         begin
         x.calign:=x.c_alignleft;
         low__wordcore(x,'cwritealign','');
         end
      else if (str1='align.center') then
         begin
         x.calign:=x.c_aligncentre;
         low__wordcore(x,'cwritealign','');
         end
      else if (str1='align.right') then
         begin
         x.calign:=x.c_alignright;
         low__wordcore(x,'cwritealign','');
         end
//
      else if (str1='pt-') then
         begin
         x.cfontsize:=frcmin(x.cfontsize-1,6);
         low__wordcore(x,'cwritesel','size');
         end
      else if (str1='pt+') then
         begin
         x.cfontsize:=frcmax(x.cfontsize+1,72);
         low__wordcore(x,'cwritesel','size');
         end
      else if (str1='w0') then x.wrapstyle:=0
      else if (str1='w1') then x.wrapstyle:=1
      else if (str1='w2') then x.wrapstyle:=2
      else if (str1='black') then
         begin
         x.ccolor:=0;
         low__wordcore(x,'cwritesel','color');
         end
      else if (str1='red') then
         begin
         x.ccolor:=255;
         low__wordcore(x,'cwritesel','color');
         end
      else if (str1='bblack') then
         begin
         x.cbk:=0;
         low__wordcore(x,'cwritesel','bk');
         end
      else if (str1='bred') then
         begin
         x.cbk:=255;
         low__wordcore(x,'cwritesel','bk');
         end
      else if (str1='bnone') then
         begin
         x.cbk:=clnone;
         low__wordcore(x,'cwritesel','bk');
         end
      else if (str1='arial') then
         begin
         x.cfontname:='arial';
         low__wordcore(x,'cwritesel','name');
         end
      else if (str1='courier new') then
         begin
         x.cfontname:='courier new';
         low__wordcore(x,'cwritesel','name');
         end
      else if (str1='copy') then low__wordcore(x,'copy','')
      else if (str1='copy.txt') then low__wordcore(x,'copy','txt')//05jun2020
      else if (str1='copy.txtwin') then low__wordcore(x,'copy','txtwin')//Windows text - 14jul2020
      else if (str1='copyall') then low__wordcore(x,'copyall','')
      else if (str1='paste') then low__wordcore(x,'paste','')
      else if (str1='useclaudecolors') then low__wordcore(x,str1,bn(not x.useclaudecolors))//05jun2020
      else
         begin
         showbasic('Unknown toolbar click command "'+str1+'"');
         //nil
         end;
      //updatebuttons
      xupdatebuttons;
      end;
   //.toolbar paint
   if low__barcore(x.bar,'canpaint','')  and low__barcore(x.bar,'mustpaint','') then
      begin
      low__barcore(x.bar,'mustpaint','0');
      x.mustpaint:=true;
      end;
   end
else
   begin
   showbasic('Unknown twordcore command "'+xcmd+'"');
   goto skipend;
   end;
skipend:
except;end;
end;
//## low__wordcore__lgfFILL ##
procedure low__wordcore__lgfFILL(var x:twordcore;lgfINDEX:longint);
var
   xlen,xsize,p:longint;
   xbold,xitalic,xunderline,xstrikeout:boolean;
   str1,xfontname:string;
begin
try
if (lgfINDEX>=0) and (lgfINDEX<=high(x.lgfdata)) and (x.initstate='inited') and (x.lgfdata[lgfINDEX]='') then
   begin
   //init
   xbold:=false;
   xitalic:=false;
   xunderline:=false;
   xstrikeout:=false;
   xsize:=12;
   xfontname:='arial';
   //split
   str1:=x.lgfnref[lgfINDEX];
   xlen:=length(str1);
   if (xlen>=6) then
      begin
      xbold       :=(str1[1]<>'0');
      xitalic     :=(str1[2]<>'0');
      xunderline  :=(str1[3]<>'0');
      xstrikeout  :=(str1[4]<>'0');
      //.size
      for p:=6 to xlen do if (str1[p]='|') then
         begin
         xsize:=frcmin(strint(copy(str1,6,p-6)),1);
         xfontname:=copy(str1,p+1,xlen);
         break;
         end;//p
      end;
   //get
   x.lgfdata[lgfINDEX]:=low__toLGF2b(xfontname,xsize,xbold);
   end;
except;end;
end;
//## low__wordcore__style ##
function low__wordcore__style(x:char):char;
begin
try
case ord(x) of
9,10,32..255:result:='t';//text
0:result:='i';//image
else result:='n';//nil -> unknown
end;
except;end;
end;
//## low__wordcore__filtertext ##
procedure low__wordcore__filtertext(var x:string);
var
   xlen,dlen,p:longint;
   v:byte;
begin
try
//init
xlen:=length(x);
if (xlen<=0) then exit;
dlen:=0;
//get
for p:=1 to xlen do
begin
v:=ord(x[p]);
if (v=9) or (v=10) or (v>=32) then
   begin
   inc(dlen);
   if (dlen<xlen) then x[dlen]:=x[p];
   end;
end;//p
//trim
if (dlen<xlen) then setlength(x,dlen);
except;end;
end;
//## low__wordcore__charinfo ##
function low__wordcore__charinfo(var x:twordcore;xpos:longint;var xout:twordcharinfo):boolean;
var
   wrd2:twrd2;
   //## xstyle ##
   function xstyle(x:char):char;
   begin
   case ord(x) of
   9,10,32..255:result:='t';//text
   0:result:='i';//image
   else result:='n';//nil -> unknown
   end;//case
   end;
   //## xsafe ##
   function xsafe(xindex:longint):longint;
   begin
   result:=xindex;
   if (result<0) then result:=0 else if (result>high(x.txtname)) then result:=high(x.txtname);
   end;
begin
try
//defaults
result:=false;
//init
if (xpos>=1) and (xpos<=length(x.data)) then
   begin
   //init
   xout.c             :=x.data[xpos];
   xout.cs            :=xstyle(xout.c);
   wrd2.chars[0]      :=x.data2[xpos];
   wrd2.chars[1]      :=x.data3[xpos];
   xout.wid           :=xsafe(wrd2.val);
   //get
   //.text character
   if (xout.cs='t') then
      begin
      //.text font id
      xout.txtid    :=xsafe(x.txtid[xout.wid]);
      //.lgfFILL
      if (not x.dataonly) and (x.lgfdata[xout.txtid]='') then low__wordcore__lgfFILL(x,xout.txtid);
      //.height
      xout.height   :=low__fromLGF_height (x.lgfdata[xout.txtid]);
      xout.height1  :=low__fromLGF_height1(x.lgfdata[xout.txtid]);
      //.width
      if      (xout.c=#9)  then xout.width:=5*low__fromLGF_charw(x.lgfdata[xout.txtid],32)
      else if (xout.c=#10) then xout.width:=0//return code -> no width
      else                      xout.width:=low__fromLGF_charw(x.lgfdata[xout.txtid],ord(xout.c));
      end
   //.image
   else if (xout.cs='i') then
      begin
      //.width & height
      xout.width    :=x.imgw[xout.wid]; if (xout.width<1) then xout.width:=1;
      xout.height   :=x.imgh[xout.wid]; if (xout.height<1) then xout.height:=1;
      xout.height1  :=xout.height;
      end
   //.nil
   else
      begin
      //.width & height
      xout.width    :=0;
      xout.height   :=0;
      xout.height1  :=0;
      end;
   //successful
   result:=true;
   end;//if
except;end;
end;
//## low__wordcore__txtcolor ##
function low__wordcore__txtcolor(var x:twordcore;xwid:longint):longint;//14jul2020
var
   n:string;
begin
try
//defaults
result:=0;//black
//get
if (xwid>=0) and (xwid<=high(x.txtname)) then
   begin
   //.actual user specified color
   result:=x.txtcolor[xwid];

   //Special Note: Claude colors only override user colors if text color is
   //              set to BLACK "0" and "useclaudecolors=true" and font name
   //              is a "$claude.*" based font name - 14jul2020
   if x.useclaudecolors and (result=0) and (copy(x.txtname[xwid],1,1)='$') then
      begin
      //init
      n:=x.txtname[xwid];
      //get
      //.text
      if      (n='$claude.text1') then result:=x.claude_text1
      else if (n='$claude.text2') then result:=x.claude_text2
      else if (n='$claude.text3') then result:=x.claude_text3
      else if (n='$claude.text4') then result:=x.claude_text4
      else if (n='$claude.text5') then result:=x.claude_text5
      //.header
      else if (n='$claude.header1') then result:=x.claude_header1
      else if (n='$claude.header2') then result:=x.claude_header2
      else if (n='$claude.header3') then result:=x.claude_header3
      else if (n='$claude.header4') then result:=x.claude_header4
      else if (n='$claude.header5') then result:=x.claude_header5;
      end;
   end;
except;end;
end;
//## low__wordcore__paint2432 ##
function low__wordcore__paint2432(var x:twordcore;ax,ay,aw,ah:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;acanvas:tcanvas):boolean;
label//Note: acanvas is optional -> for debug purposes only - 29aug2019
   redo,skipdone,skipend;
var
   xchar,xcur:twordcharinfo;
   xbarh,xselstart,xselcount,sel1,sel2,int1,lx,ly,lh,lh1,xpos,xcount,lpos,lp,lc,xlen,p,dx,dy,sx,sy,sw,sh:longint;
   xfc,xfc2:string;
   c24:tcolor24;
   c32:tcolor32;
   xselcol,int4:tint4;
   xcursoronscrn:boolean;
   //## xdrawhighlight ##
   procedure xdrawhighlight(xcolor:longint);
   var
      ymin,ymax,xmin,xmax,dx,dy:longint;
      r24:pcolorrow24;
      r32:pcolorrow32;
      int4:tint4;
   begin
   //check
   if (xcolor=clnone) then exit;
   //init
   //.y-range
   ymin:=ly;
   ymax:=ly+lh-1;
   if (ymin>acliparea.bottom) or (ymax<acliparea.top) then exit;
   ymin:=frcrange(ymin,acliparea.top,acliparea.bottom);
   ymax:=frcrange(ymax,acliparea.top,acliparea.bottom);
   //.x-range
   xmin:=sx;
   xmax:=sx+xchar.width-1;
   if (xmin>acliparea.right) or (xmax<acliparea.left) then exit;
   xmin:=frcrange(xmin,acliparea.left,acliparea.right);
   xmax:=frcrange(xmax,acliparea.left,acliparea.right);
   //.int4
   int4.val:=xcolor;
   //24
   if (ar24<>nil) then
      begin
      for dy:=ymin to ymax do
      begin
      r24:=ar24[dy];
      for dx:=xmin to xmax do
      begin
      c24:=r24[dx];
      c24.r:=int4.r;
      c24.g:=int4.g;
      c24.b:=int4.b;
      r24[dx]:=c24;
      end;//dx
      end;//dy
      end
   //32
   else if (ar32<>nil) then
      begin
      for dy:=ymin to ymax do
      begin
      r32:=ar32[dy];
      for dx:=xmin to xmax do
      begin
      c32:=r32[dx];
      c32.r:=int4.r;
      c32.g:=int4.g;
      c32.b:=int4.b;
      r32[dx]:=c32;
      end;//dx
      end;//dy
      end;
   end;
   //## xdrawsel ##
   procedure xdrawsel;
   var
      ymin,ymax,xmin,xmax,dx,dy:longint;
      r24:pcolorrow24;
      r32:pcolorrow32;
   begin
   //init
   //.y-range
   ymin:=ly;
   ymax:=ly+lh-1;
   if (ymin>acliparea.bottom) or (ymax<acliparea.top) then exit;
   ymin:=frcrange(ymin,acliparea.top,acliparea.bottom);
   ymax:=frcrange(ymax,acliparea.top,acliparea.bottom);
   //.x-range
   xmin:=sx;
   xmax:=sx+xchar.width-1;
   if (xmin>acliparea.right) or (xmax<acliparea.left) then exit;
   xmin:=frcrange(xmin,acliparea.left,acliparea.right);
   xmax:=frcrange(xmax,acliparea.left,acliparea.right);
   //24
   if (ar24<>nil) then
      begin
      for dy:=ymin to ymax do
      begin
      r24:=ar24[dy];
      for dx:=xmin to xmax do
      begin
      c24:=r24[dx];
      c24.r:=(c24.r+xselcol.r) div 2;
      c24.g:=(c24.g+xselcol.g) div 2;
      c24.b:=(c24.b+xselcol.b) div 2;
      r24[dx]:=c24;
      end;//dx
      end;//dy
      end
   //32
   else if (ar32<>nil) then
      begin
      for dy:=ymin to ymax do
      begin
      r32:=ar32[dy];
      for dx:=xmin to xmax do
      begin
      c32:=r32[dx];
      c32.r:=(c32.r+xselcol.r) div 2;
      c32.g:=(c32.g+xselcol.g) div 2;
      c32.b:=(c32.b+xselcol.b) div 2;
      r32[dx]:=c32;
      end;//dx
      end;//dy
      end;
   end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//555555555555555555555555
   //## xdrawbmp ##
   procedure xdrawraw24(var x24:string;xw,xh:longint);
   var
      yoff,sbits,ssx,ssy,dx,dy:longint;
      s24,r24:pcolorrow24;
      s32,r32:pcolorrow32;
   begin
   try
   //check
   if (x24='') or (xw<1) or (xh<1) or (length(x24)<(xw*xh*3)) then exit;
   //init
   sbits:=24;
   //.yoff
   yoff:=frcmin(lh1-xh,0);

   //24 + 24
   if (ar24<>nil) and (sbits=24) then
      begin
      for ssy:=0 to (xh-1) do
      begin
      dy:=ly+yoff+ssy;
      if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
         begin
         r24:=ar24[dy];
         s24:=pointer(longint(x24)+(ssy*xw*3));
         for ssx:=0 to (xw-1) do
         begin
         dx:=sx+ssx;
         if (dx>=acliparea.left) and (dx<=acliparea.right) then
            begin
            c24:=s24[ssx];
            r24[dx]:=c24;
            end;//dy
         end;//ssx
         end;//dy
      end;//ssy
      end
   //24 + 32
   else if (ar24<>nil) and (sbits=32) then
      begin
      for ssy:=0 to (xh-1) do
      begin
      dy:=ly+yoff+ssy;
      if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
         begin
         r24:=ar24[dy];
         s32:=pointer(longint(x24)+(ssy*xw*4));
         for ssx:=0 to (xw-1) do
         begin
         dx:=sx+ssx;
         if (dx>=acliparea.left) and (dx<=acliparea.right) then
            begin
            c32:=s32[ssx];
            c24.r:=c32.r;
            c24.g:=c32.g;
            c24.b:=c32.b;
            r24[dx]:=c24;
            end;//dy
         end;//ssx
         end;//dy
      end;//ssy
      end
   //32 + 32
   else if (ar32<>nil) and (sbits=32) then
      begin
      for ssy:=0 to (xh-1) do
      begin
      dy:=ly+yoff+ssy;
      if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
         begin
         r32:=ar32[dy];
         s32:=pointer(longint(x24)+(ssy*xw*4));
         for ssx:=0 to (xw-1) do
         begin
         dx:=sx+ssx;
         if (dx>=acliparea.left) and (dx<=acliparea.right) then
            begin
            c32:=s32[ssx];
            r32[dx]:=c32;
            end;//dy
         end;//ssx
         end;//dy
      end;//ssy
      end
   //32 + 24
   else if (ar32<>nil) and (sbits=24) then
      begin
      for ssy:=0 to (xh-1) do
      begin
      dy:=ly+yoff+ssy;
      if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
         begin
         r32:=ar32[dy];
         s24:=pointer(longint(x24)+(ssy*xw*3));
         for ssx:=0 to (xw-1) do
         begin
         dx:=sx+ssx;
         if (dx>=acliparea.left) and (dx<=acliparea.right) then
            begin
            c24:=s24[ssx];
            c32.r:=c24.r;
            c32.g:=c24.g;
            c32.b:=c24.b;
            c32.a:=255;//fully visible
            r32[dx]:=c32;
            end;//dy
         end;//ssx
         end;//dy
      end;//ssy
      end;//if

//xxxxxxxxxxxxxxxxxxxxxx x.
   except;end;
   end;
begin
try
//defaults
result:=false;
xcursoronscrn:=false;
xfc:='';//feather core -> used when "x.feather=true"
//check
if not low__wordcore__inited(x) then exit;
if ((ar24=nil) and (ar32=nil)) or (aw<1) or (ah<1) then exit;

//xxxxxxxxxxxxxxxxxxxxxxxxxx//55555555555555555555
//init
//.toolbar
low__wordcore(x,'bar.drawcalc',inttostr(aw));//feed in current paint width "aw" and proc syncs "x.bar.height" with "x.barh" for rapid accss throughout control
xbarh:=x.barh;
if (xbarh<>0) then dec(ay,xbarh);
//.continue
xselcol.val:=x.pageselcolor;
xselstart:=low__wordcore2(x,'selstart','');
xselcount:=low__wordcore2(x,'selcount','');
if (xselcount>=1) then
   begin
   sel1:=xselstart;
   sel2:=sel1+xselcount-1;
   end
else
   begin
   sel1:=-1;
   sel2:=-1;
   end;
acliparea.left:=frcrange(acliparea.left,0,aw-1);
acliparea.right:=frcrange(acliparea.right,acliparea.left,aw-1);
acliparea.top:=frcrange(acliparea.top,0,ah-1);
acliparea.bottom:=frcrange(acliparea.bottom,acliparea.top,ah-1);
xpos:=0;//not set
xlen:=length(x.data);
if (xlen<1) then goto skipdone;

//find start line (top of client area)
lpos:=low__wordcore2(x,'y>line',inttostr(ay));
if (lpos<0) or (lpos>=x.linecount) or (lpos>=x.linesize) then goto skipdone;

//-- Paint By Lines ------------------------------------------------------------
//Note: Painting by lines requires 14x less RAM to map characters with
//      little to no extra lag time - Aug2019
//------------------------------------------------------------------------------
redo:

//get
xpos:=low__wordcore2(x,'line>pos',inttostr(lpos));//convert line number (0..N) into a text position "xpos", e.g. character at location -> "x.data[xpos]"
if (xpos<=0) or (xpos>xlen) then goto skipdone;
xcount:=low__wordcore2(x,'line>itemcount',inttostr(lpos));//return number of characters in the line
if (xcount<=0) then goto skipdone;

//.line info
lx:=x.linex[lpos]-ax;//need to fill this in later..xxxxxxxxxxxxxxxxxxxxxxxxx
ly:=x.liney[lpos]-ay;
lh:=x.lineh[lpos];
lh1:=x.lineh1[lpos];
//draw each line using their series of in-order "chars"
sx:=lx;
for p:=xpos to (xpos+xcount-1) do
begin
//.check
if (p<0) or (p>xlen) then goto skipdone;
//.wrap more
if (p>x.wrapcount) then
   begin
   //can't paint -> wrap is not upto date
   low__wordcore(x,'wrapto',inttostr(p+x.c_pagewrap));
   //trigger a repaint
   x.mustpaint:=true;
   goto skipdone;
   end;
//.get char
if not low__wordcore__charinfo(x,p,xchar) then goto skipdone;
sy:=ly+lh1-xchar.height1;

//.draw char
if (xchar.cs='t') then
   begin
   if (xchar.c<>#10) then
      begin
      //draw highlight
      if (x.txtbk[xchar.wid]<>clnone) then xdrawhighlight(x.txtbk[xchar.wid]);
      //draw sel
      if (p>=sel1) and (p<=sel2) then xdrawsel;
      //draw character
      if (xchar.c<>#9) then
         begin
         //.lgfFILL
         if (not x.dataonly) and (x.lgfdata[xchar.txtid]='') then low__wordcore__lgfFILL(x,xchar.txtid);
         //.draw
         low__fromLGF_drawchar2432(x.lgfdata[xchar.txtid],ord(xchar.c),sx,sy,aw,ah,low__wordcore__txtcolor(x,xchar.wid),acliparea,ar24,ar32,nil,0,xfc,x.feather,false,x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid]);
         end;
      end;
   end
else if (xchar.cs='i') then
  begin
  //draw image
  if (x.imgraw24[xchar.wid]<>'') then xdrawraw24(x.imgraw24[xchar.wid],x.imgw[xchar.wid],x.imgh[xchar.wid]);
  //draw sel (ontop of image)
  if (p>=sel1) and (p<=sel2) then xdrawsel;
  end;

//.draw cursor
if (p=x.cursorpos) then
   begin
   xcursoronscrn:=true;
   if x.drawcursor and x.havefocus then
      begin
      for dx:=(sx-1) to sx do
      begin
      if (dx>=acliparea.left) and (dx<=acliparea.right) then
         begin
         //init
         if low__wordcore__charinfo(x,frcmin(p-1,1),xcur) then
            begin
            int1:=ly+lh1-xcur.height1;
            int4.val:=low__wordcore__txtcolor(x,xcur.wid);
            //get
            if (ar24<>nil) then
               begin
               for dy:=int1 to (int1+xcur.height-1) do if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
                  begin
                  ar24[dy][dx].r:=int4.r;
                  ar24[dy][dx].g:=int4.g;
                  ar24[dy][dx].b:=int4.b;
                  end;//dy
               end
            else if (ar32<>nil) then
               begin
               for dy:=int1 to (int1+xcur.height-1) do if (dy>=acliparea.top) and (dy<=acliparea.bottom) then
                  begin
                  ar32[dy][dx].r:=int4.r;
                  ar32[dy][dx].g:=int4.g;
                  ar32[dy][dx].b:=int4.b;
                  ar32[dy][dx].a:=255;//fully solid
                  end;//dy
               end;
            end;//dx
         end;//xcur=OK
      end;//dx
      end;//drawcursor
   end;//cursor
//.inc
inc(sx,xchar.width);
end;//p
//.next line
inc(lpos);
if (ly<ah) and (lpos<x.linecount) and (lpos<x.linesize) then goto redo;
//.sync
x.cursoronscrn:=xcursoronscrn;

//.draw toolbar -> note this proc requires tpointer to be 32bits (4 bytes) - 07dec2019
if (xbarh>=1) and (sizeof(tpointer)=4) then low__wordcore(x,'bar.paint',from32bit(xbarh)+from32bit(longint(pointer(ar24)))+from32bit(longint(pointer(ar32)))+from32bit(aw)+from32bit(ah)+from32bit(acliparea.left)+from32bit(acliparea.top)+from32bit(acliparea.right)+from32bit(acliparea.bottom));

//successful
skipdone:
result:=true;
skipend:
except;end;
end;
//## low__wordcore__paint32 ##
function low__wordcore__paintcanvas32(var x:twordcore;xcanvas:tcanvas;xclientwidth,xclientheight:longint):boolean;
var
   hpos,vpos,bw,bh,dx,dy:longint;
   int4:tint4;
   c32:tcolor32;
   r32:pcolorrow32;
   sa:trect;
begin
try
//defaults
result:=false;
//check
if not low__wordcore__inited(x) then exit;
if (xcanvas=nil) then exit;

//range
xclientwidth:=frcmin(xclientwidth,1);
xclientheight:=frcmin(xclientheight,1);

//init
if (x.buffer=nil) then
   begin
   x.buffer:=tbitmap.create;
   x.buffer.pixelformat:=pf32bit;
   end;

//size + sync check - fixed 26aug2019
bw:=frcmin(x.pagewidth,1);
bh:=frcmin(x.viewheight,1);//height
if low__setstring(inttostr(bw)+'|'+inttostr(bh),x.bufferref) then
   begin
   x.buffer.width:=bw;
   x.buffer.height:=bh;
   setlength(x.buffermem,bh*sizeof(tpointer));
   x.bufferrows:=pointer(longint(x.buffermem));
   for dy:=0 to (x.buffer.height-1) do x.bufferrows[dy]:=x.buffer.scanline[dy];
   end;

//fast cls
int4.val:=x.pagecolor;
c32.r:=int4.r;
c32.g:=int4.g;
c32.b:=int4.b;
c32.a:=255;//fully solid
for dy:=0 to (bh-1) do
begin
r32:=x.bufferrows[dy];
for dx:=0 to (bw-1) do r32[dx]:=c32;
end;//dy

//draw text on buffer
vpos:=low__wordcore2(x,'vpos','');
if (vpos>=0) and (vpos<x.linecount) and (vpos<x.linesize) then dy:=x.liney[vpos] else dy:=0;
sa:=rect(0,0,bw-1,bh-1);
low__wordcore__paint2432(x,0,dy,bw,bh,sa,nil,x.bufferrows,xcanvas);

//paint buffer
hpos:=low__wordcore2(x,'hpos','');
dx:=frcmin((x.viewwidth-x.pagewidth) div 2,0)-hpos;
dy:=0;
xcanvas.draw(dx,0,x.buffer);

//cls unused areas
low__clsoutside3(xcanvas,xclientwidth,xclientheight,dx,dy,bw,bh,x.viewcolor);

//successful
result:=true;
except;end;
end;
//## low__wordcore__keyboard ##
procedure low__wordcore__keyboard(var x:twordcore;xctrl,xalt,xshift,xkeyX:boolean;xkey:byte);
begin
try;low__wordcore(x,'kstack',char(low__insint(1,xctrl))+char(low__insint(1,xalt))+char(low__insint(1,xshift))+char(low__insint(1,xkeyX))+char(xkey));except;end;
end;
//## low__wordcore__mouse ##
procedure low__wordcore__mouse(var x:twordcore;xmousex,xmousey:longint;xmousedown,xmouseright:boolean);
begin
try;low__wordcore(x,'mstack',from32bit(xmousex)+from32bit(xmousey)+char(low__insint(1,xmousedown))+char(low__insint(1,xmouseright)));except;end;
end;
//## low__wordcore ##
function low__wordcore(var x:twordcore;xcmd,xval:string):boolean;
var
   xoutval,e:string;
begin
try;result:=false;low__wordcore3(x,xcmd,xval,xoutval,e);result:=(xoutval<>'') and (xoutval<>'0');except;end;
end;
//## low__wordcore2 ##
function low__wordcore2(var x:twordcore;xcmd,xval:string):longint;
var
   xoutval,e:string;
begin
try;result:=0;low__wordcore3(x,xcmd,xval,xoutval,e);result:=strint(xoutval);except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//5555555555555555555555
//## low__wordcore3 ##
function low__wordcore3(var x:twordcore;xcmd,xval:string;var xoutval,e:string):boolean;
label
   skipdone,skipend;
var
   xid,v1,v2,xnewcursorpos,xsize,xmin,xmax,xfontsize,xcolor,xcolor2,xbk,xborder,xlen,dlen,xline,xline2,xcursor_keyboard_moveto,xoldcursorpos,dx,dy,i,int1,int2,int3,int4,int5,p,p2,imax:longint;
   wrd2:twrd2;
   n,v,str1,str2,str3,str4,str5,str6:string;
   ximgdata,xfontname:string;
   xfull,xonce,xonce2,xchklinecursorx,xctrl,xalt,xshift,xkeyx,xmustpaint,xmusttimerunbusy,bol1,bol2,bol3:boolean;
   xbold,xitalic,xunderline,xstrikeout,xswap,xusecolor2:boolean;
   xalign:byte;
   c,cs:char;
   c32:tcolor32;
   r32:pcolorrow32;
   xchar:twordcharinfo;
   xint4,xint4b:tint4;
   xlist:pdlinteger;
   xlisti:pdlinteger;
   xlist2:array[0..999] of string;
//04jun2020
   //## xlinebefore ##
   function xlinebefore(xpos:longint):longint;
   begin
   result:=low__wordcore2(x,'pos>line-1>pos',inttostr(xpos));
   end;
//
   //## xwrapadd ##
   procedure xwrapadd(xpos,xpos2:longint);
   begin
   try;x.wrapstack:=x.wrapstack+from32bit(frcmin(xpos,0))+from32bit(frcmin(xpos2,0));except;end;
   end;
   //## xchanged ##
   procedure xchanged;
   begin
   try
   x.modified:=true;
   if (x.dataid<maxint) then inc(x.dataid) else x.dataid:=1;
   x.mustpaint:=true;
   except;end;
   end;
   //## xmakefont2 ##
   function xmakefont2(xoverride:boolean;xLGFdata,xfontname:string;xfontsize,xcolor,xbk,xborder:longint;xbold,xitalic,xunderline,xstrikeout:boolean;xalign:byte):longint;
   label
      skipend;
   var
      xref:string;
      xnew,i,p:longint;
   begin
   try
   //defaults
   result:=0;
   xnew:=-1;
   //init
   if not xoverride then
      begin
      xLGFdata:='';
      xfontname:=low__udv(x.cfontname,'arial');
      xfontsize:=frcrange(x.cfontsize,4,300);
      xbold:=x.cbold;
      xitalic:=x.citalic;
      xunderline:=x.cunderline;
      xstrikeout:=x.cstrikeout;
      xcolor:=x.ccolor;
      xbk:=x.cbk;
      //.filter
      xborder:=x.cborder;
      xalign:=x.calign;
      end;
   //range
   xfontname:=low__udv(xfontname,'arial');
   xfontsize:=frcrange(xfontsize,4,300);
   //.color check
//02jun2020
   if (xcolor=clnone) then xcolor:=rgb(255,255,255);//was: xcolor=0, but when "color=0 and bk=clnone" then we ended up with black on black
//
   //find existing
   for p:=0 to high(x.txtname) do if (x.txtname[p]<>'') and (xcolor=x.txtcolor[p]) and (xbk=x.txtbk[p]) and (xborder=x.txtborder[p]) and (xfontsize=x.txtsize[p]) and (xbold=x.txtbold[p]) and (xitalic=x.txtitalic[p]) and (xunderline=x.txtunderline[p]) and (xstrikeout=x.txtstrikeout[p]) and (xalign=x.txtalign[p]) and (comparetext(xfontname,x.txtname[p])=0) then
      begin
      result:=p;
      goto skipend;
      end;//p
   //find free
   if (xnew<0) then for p:=0 to high(x.txtname) do if (x.txtname[p]='') then
      begin
      xnew:=p;
      break;
      end;//p
   //emergency limit -> we need to find items that are nolonger being pointed to and reuse them before just parking it here at the uppermost limit - 21aug2019
   if (xnew<0) then xnew:=high(x.txtname);
   //get
   result:=xnew;
   x.txtname[result]:=xfontname;
   x.txtsize[result]:=xfontsize;
   x.txtbold[result]:=xbold;
   x.txtitalic[result]:=xitalic;
   x.txtunderline[result]:=xunderline;
   x.txtstrikeout[result]:=xstrikeout;
   x.txtcolor[result]:=xcolor;
   x.txtbk[result]:=xbk;
   x.txtborder[result]:=xborder;
   x.txtalign[result]:=xalign;//21sep2019
   x.txtid[result]:=0;//point to default for safety
   xref:=bn(xbold)+bn(xitalic)+bn(xunderline)+bn(xstrikeout)+'|'+inttostr(xfontsize)+'|'+xfontname;
   //.find existing lgf
   i:=-1;
   if (i<0) then for p:=0 to high(x.lgfnref) do if (x.lgfnref[p]<>'') and (comparetext(xref,x.lgfnref[p])=0) then
      begin
      i:=p;
      break;
      end;//p
   //.create new lgf
   if (i<0) then for p:=0 to high(x.lgfnref) do if (x.lgfnref[p]='') then
      begin
      if (xLGFdata<>'') then x.lgfdata[p]:=xLGFdata
      else if (not x.dataonly) then x.lgfdata[p]:=low__toLGF2b(xfontname,xfontsize,xbold)
      else x.lgfdata[p]:='';
      x.lgfnref[p]:=xref;
      i:=p;
      break;
      end;//p
   //.set id
   if (i>=0) then x.txtid[result]:=i;
   //changed
   xchanged;
   skipend:
   except;end;
   end;
   //## xmakefont ##
   function xmakefont:longint;
   begin
   try;result:=xmakefont2(false,'','arial',12,0,clnone,clnone,false,false,false,false,0);except;end;
   end;
   //## xupdatebuttons ##
   procedure xupdatebuttons;
   begin
   low__wordcore(x,'bar.updatebuttons','');
   end;
   //## xappend ##
   function xappend(var xoutlen:longint;var xout:string;n:string;var v:string):boolean;
   begin//n='' -> finalise output buffer "xout"
   try
   if (n='') then result:=pushb(xoutlen,xout,'')
   else
      begin
      //filter -> n is fixed at 4 characters
      n:=copy(n+'    ',1,4);
      //get
      result:=pushb(xoutlen,xout,n+from32bit(length(v))) and ((v='') or push(xoutlen,xout,v));
      end;
   except;end;
   end;
   //## xappendb ##
   function xappendb(var xoutlen:longint;var xout:string;n,v:string):boolean;
   begin
   try;result:=xappend(xoutlen,xout,n,v);except;end;
   end;
   //## xpull ##
   function xpull(var xoutpos:longint;var xout:string;var n,v:string):boolean;
   var
      xpos,int1:longint;
   begin//n='' -> finalise output buffer "xout"
   try
   //defaults
   result:=false;
   n:='';
   v:='';
   xpos:=xoutpos;
   //range
   if (xpos<1) then xpos:=1
   else if ((xpos+7)>length(xout)) then exit;
   //get
   n:=copy(xout,xpos,4);
   int1:=frcmin(to32bit(copy(xout,xpos+4,4)),0);
   //inc -> still incs even on error
   xoutpos:=xpos+8+int1;
   //set
   if (int1>=1) then v:=copy(xout,xpos+8,int1);
   //successful
   result:=true;
   except;end;
   end;
   //## xsafeline ##
   function xsafeline(var xindex:longint):boolean;
   var
      xmax:longint;
   begin
   try
   //defaults
   result:=false;
   //init
   xmax:=frcmax(x.linecount-1,x.linesize-1);
   if (xmax<0) then xmax:=0;
   //get
   result:=(xindex>=0) and (xindex<=xmax);
   if (xindex<0) then xindex:=0 else if (xindex>xmax) then xindex:=xmax;
   except;end;
   end;
   //## xlinecursorx ##
   procedure xlinecursorx(xpos:longint);
   var
      xmin,p,dx,xline:longint;
      xchar:twordcharinfo;
   begin
   try
   //range
   xpos:=frcrange(xpos,1,length(x.data));
   //init
   xline:=low__wordcore2(x,'pos>line',inttostr(xpos));
   //get
   if xsafeline(xline) then
      begin
      //get
      dx:=x.linex[xline];
      xmin:=x.linep[xline];
      for p:=xmin to length(x.data) do
      begin
      if not low__wordcore__charinfo(x,p,xchar) then break;
      if (p>=xpos) then break;
      inc(dx,xchar.width);
      end;//p
      //set
      x.linecursorx:=dx;
      end;//if
   except;end;
   end;
   //## xnoidle ##
   procedure xnoidle;
   begin
   x.idleref:=ms64+x.c_idlepause;
   end;
   //## xmincheck ##
   procedure xmincheck;
   var
      i:longint;
   begin
   try
   if (x.data='') or (x.data[length(x.data)]<>#10)then
      begin
      i:=length(x.data);
      x.data:=x.data+#10;
      if (i>=1) then//carry on font/style index from last character
         begin
         x.data2:=x.data2+x.data2[i];
         x.data3:=x.data3+x.data3[i];
         end
      else
         begin//completely empty -> font/style from default "index=0"
         x.data2:=x.data2+#0;
         x.data3:=x.data3+#0;
         end;
      x.wrapstack:=x.wrapstack+from32bit(i)+from32bit(i);//same as "xwrapadd('start',i,i);"
      xchanged;
      end;
   except;end;
   end;
//04jun2020
   //## cread ##
   procedure cread;
   var
      xpos:longint;
      xchar:twordcharinfo;
   begin
   try
   //check
   xpos:=frcmin(x.cursorpos-1,0);
   if not low__wordcore__charinfo(x,xpos,xchar) then exit;
   //get
   x.cfontname    :=x.txtname[xchar.wid];
   x.cfontsize    :=x.txtsize[xchar.wid];
   x.cbold        :=x.txtbold[xchar.wid];
   x.citalic      :=x.txtitalic[xchar.wid];
   x.cunderline   :=x.txtunderline[xchar.wid];
   x.cstrikeout   :=x.txtstrikeout[xchar.wid];
   x.ccolor       :=x.txtcolor[xchar.wid];
   x.cbk          :=x.txtbk[xchar.wid];
   x.cborder      :=x.txtborder[xchar.wid];
   x.calign       :=low__wordcore2(x,'findalign',inttostr(xpos));
   except;end;
   end;
//
//04jun2020
   //## cwritealign ##
   procedure cwritealign;
   var
      p,xlastwid,xselstart,xselcount,xminp,xmaxp:longint;
      wrd2:twrd2;
      xalignok,xmustchange,xtxt,ximg:boolean;
   begin
   try
   //init
   xmustchange:=false;
   xselstart:=low__wordcore2(x,'selstart','');
   xselcount:=low__wordcore2(x,'selcount','');
   if (xselcount>=1) then
      begin
      xminp:=xselstart;
      xmaxp:=low__wordcore2(x,'pos>rc',inttostr(xselstart+xselcount-1));
      end
   else
      begin
      xminp:=frcmin(x.cursorpos,1);
      xmaxp:=low__wordcore2(x,'pos>rc',inttostr(xminp));
      end;
   //range
   xminp:=frcrange(xminp,1,length(x.data));
   xmaxp:=frcrange(xmaxp,1,length(x.data));
   //check
   if (xmaxp<xminp) then exit;
   //get
   for p:=xminp to xmaxp do
   begin
   if not low__wordcore__charinfo(x,p,xchar) then break;
   if (xchar.cs='t') and (xchar.c=#10) then
      begin
      wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.calign);
      if (xchar.wid<>wrd2.val) then
         begin
         x.data2[p]:=wrd2.chars[0];
         x.data3[p]:=wrd2.chars[1];
         xmustchange:=true;
         end;
      end;
   end;//p
   except;end;
   try
   if xmustchange then
      begin
      xwrapadd(xlinebefore(xminp),xmaxp+x.c_bigwrap);//need to wrap ATLEAST current page, else flicker may occur due to multiple paint attempts - 07dec2019
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   except;end;
   end;
//
   //## cwritesel ##
   procedure cwritesel(xstyle:string);
   var
      p,xlastwid,xselstart,xselcount:longint;
      wrd2:twrd2;
      xmustchange,xtxt,ximg:boolean;
   begin
   try
   //init
   xmustchange:=false;
   xselstart:=low__wordcore2(x,'selstart','');
   xselcount:=low__wordcore2(x,'selcount','');
   xstyle:=lowercase(xstyle);
   //check
   if (xselcount<=0) then exit;
   //get
   xlastwid:=-1;//not set
   wrd2.val:=maxword;//not set
//04jun2020
   for p:=xselstart to (xselstart+xselcount-1) do
   begin
   if not low__wordcore__charinfo(x,p,xchar) then break;
   xtxt:=(xchar.cs='t');
   ximg:=(xchar.cs='i');
   if (xtxt or ximg) then
      begin
      //get
      if (xchar.wid<>xlastwid) then
         begin
         //store current "wid"
         xlastwid:=xchar.wid;
         wrd2.val:=xchar.wid;
         //merge new font+style
         if xtxt then
            begin
            if      (xstyle='name')       then wrd2.val:=xmakefont2(true,'',x.cfontname,x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='size')       then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.cfontsize,x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='bold')       then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.cbold,x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='italic')     then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.citalic,x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='underline')  then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.cunderline,x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='strikeout')  then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.cstrikeout,x.txtalign[xchar.wid])
            else if (xstyle='color')      then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.ccolor,x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='bk')         then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.cbk,x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='color+bk')   then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.ccolor,x.cbk,x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='color+bk+style') then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.ccolor,x.cbk,x.cborder,x.cbold,x.citalic,x.cunderline,x.cstrikeout,x.txtalign[xchar.wid])
            else if (xstyle='border')     then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.cborder,x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else break;//unknown style -> quit
            end;
         end;
      //set
      if (xchar.wid<>wrd2.val) then
         begin
         x.data2[p]:=wrd2.chars[0];
         x.data3[p]:=wrd2.chars[1];
         xmustchange:=true;
         end;
      end;
   end;//p
//
   except;end;
   try
   if xmustchange then
      begin
      xwrapadd(xlinebefore(xselstart),xselstart+x.c_bigwrap);//need to wrap ATLEAST current page, else flicker may occur due to multiple paint attempts - 07dec2019
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   except;end;
   end;
   //## cwriteall ##
   procedure cwriteall(xstyle:string);//05jun2020
   var
      p,xlastwid,xselstart,xselcount:longint;
      wrd2:twrd2;
      xmustchange,xtxt,ximg:boolean;
   begin
   try
   //init
   xmustchange:=false;
   xstyle:=lowercase(xstyle);
   //check
   if (xselcount<=0) then exit;
   //get
   xlastwid:=-1;//not set
   wrd2.val:=maxword;//not set
//04jun2020
   for p:=1 to length(x.data) do
   begin
   if not low__wordcore__charinfo(x,p,xchar) then break;
   xtxt:=(xchar.cs='t');
   ximg:=(xchar.cs='i');
   //.text only
   if xtxt then//08jun2020
      begin
      //get
      if (xchar.wid<>xlastwid) then
         begin
         //store current "wid"
         xlastwid:=xchar.wid;
         wrd2.val:=xchar.wid;
         //merge new font+style
         if xtxt then
            begin
            if      (xstyle='arial')      then wrd2.val:=xmakefont2(true,'','arial',x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='courier')    then wrd2.val:=xmakefont2(true,'','courier new',x.txtsize[xchar.wid],x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='-')          then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],frcmin(x.txtsize[xchar.wid]-1,6),x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else if (xstyle='+')          then wrd2.val:=xmakefont2(true,'',x.txtname[xchar.wid],frcmax(x.txtsize[xchar.wid]+1,48),x.txtcolor[xchar.wid],x.txtbk[xchar.wid],x.txtborder[xchar.wid],x.txtbold[xchar.wid],x.txtitalic[xchar.wid],x.txtunderline[xchar.wid],x.txtstrikeout[xchar.wid],x.txtalign[xchar.wid])
            else break;//unknown style -> quit
            end;
         end;
      //set
      if (xchar.wid<>wrd2.val) then
         begin
         x.data2[p]:=wrd2.chars[0];
         x.data3[p]:=wrd2.chars[1];
         xmustchange:=true;
         end;
      end;
   end;//p
//
   except;end;
   try
   if xmustchange then
      begin
      low__wordcore(x,'wrapall','');
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   except;end;
   end;
   //## xsetcursorpos2 ##
   procedure xsetcursorpos2(xpos:longint;xshift:boolean);
   var
      int1:longint;
   begin
   try
   xpos:=frcrange(xpos,1,length(x.data));
   if (x.cursorpos<>xpos) or (x.cursorpos2<>xpos) then
      begin
      x.cursorpos:=xpos;
      if not xshift then x.cursorpos2:=xpos;
      int1:=xpos+x.c_pagewrap;
      if (int1>x.wrapcount) then x.wrapstack:=x.wrapstack+from32bit(x.wrapcount)+from32bit(int1);//same as "xwrapadd('auto',*,xpos+page);"
      inc(x.vcheck);
      x.mustpaint:=true;
      end;
   cread;
   except;end;
   end;
   //## xsetcursorpos ##
   procedure xsetcursorpos(xpos:longint);
   begin
   try;xsetcursorpos2(xpos,false);except;end;
   end;
   //## xatleast ##
   procedure xatleast(xstyle:string;xnewsize:longint);
   var
      p,olen,nlen:longint;
   begin
   try
   //range
   xnewsize:=frcmin(xnewsize,1);
   nlen:=xnewsize*4;
   //line
   if (xstyle='line') then
      begin
      olen:=length(x.coreliney);
      if (nlen<>olen) then
         begin
         if (nlen<olen) then x.linesize:=xnewsize;//shrink -> update right now
         setlength(x.corelinex,nlen);
         setlength(x.coreliney,nlen);
         setlength(x.corelineh,nlen);
         setlength(x.corelineh1,nlen);
         setlength(x.corelinep,nlen);
         if (nlen>=olen) then x.linesize:=xnewsize;//enlarge -> update now -> streams at size
         x.linex:=pointer(longint(x.corelinex));
         x.liney:=pointer(longint(x.coreliney));
         x.lineh:=pointer(longint(x.corelineh));
         x.lineh1:=pointer(longint(x.corelineh1));
         x.linep:=pointer(longint(x.corelinep));
         //cls new data
         if (nlen>olen) then
            begin
            for p:=(olen+1) to nlen do x.corelinex[p]:=#0;
            for p:=(olen+1) to nlen do x.coreliney[p]:=#0;
            for p:=(olen+1) to nlen do x.corelineh[p]:=#0;
            for p:=(olen+1) to nlen do x.corelineh1[p]:=#0;
            for p:=(olen+1) to nlen do x.corelinep[p]:=#0;
            end;
         end;
      end//line
   else
      begin
      showerror60('Wordcore: Unknown atleast style "'+xstyle+'"');
      end;
   except;end;
   end;
   //## xstackpull ##
   function xstackpull(var xstack,xval:string):boolean;
   var//supports variable size entry lengths 
      xlen:longint;
   begin
   try
   //defaults
   result:=false;
   xval:='';
   //get
   if (length(xstack)>=4) then
      begin
      xlen:=frcmin(to32bit(copy(xstack,1,4)),0);
      if (xlen>=1) then xval:=copy(xstack,5,xlen);
      delete(xstack,1,4+xlen);
      result:=true;
      end;
   except;end;
   end;
   //## xwrappull ##
   function xwrappull(var xpos,xpos2:longint):boolean;
   begin
   try
   //defaults
   result:=false;
   xpos:=-1;
   xpos2:=-1;
   //get
   if (length(x.wrapstack)>=8) then
      begin
      xpos :=to32bit(copy(x.wrapstack,1,4));
      xpos2:=to32bit(copy(x.wrapstack,5,4));
      delete(x.wrapstack,1,8);
      result:=true;
      end;
   except;end;
   end;
//04jun2020
   //## xwrapnow ##
   procedure xwrapnow(xmin,xmax,xlinecount:longint);
//xxxxxxxxxxxxxxxxxxxxxxxxxxxx Needs to break the wrap on a SPACE or TAB if following word/characters exceed page width - 02aug2019
   label
      redo;
   var
      a:twordcharinfo;
      xdif,odx,olh1,olh2,lp,int1,sh2,p,ddx,dx,pw,ph,lc,lh1,lh2,lx,ly,xlen:longint;
      lac:char;
      //## xmustbreak ##
      function xmustbreak(var xdif:longint):boolean;
      var
         a:twordcharinfo;
         ddx,i:longint;
      begin
      //defaults
      result:=false;
      xdif:=0;
      //check
//xxxxxxxxxxxxxx      if (p>=xmax) then exit;
      //get
      ddx:=dx;
//was:      for i:=(p+1) to xmax do
      for i:=p to xmax do
      begin
      low__wordcore__charinfo(x,i,a);
      if (a.c=#10) or (a.c=#9) or (a.c=#32) then break
      else if ((ddx+a.width)>=pw) then//and (a.c<>#10) then
         begin
         result:=true;
         break;
         end;
      inc(ddx,a.width);
      end;//p
      xdif:=ddx-dx;
      end;
      //## xalign_lx ##
      function xalign_lx(xfrompos:longint):longint;
      var
         xalign:longint;
      begin
      //defaults
      result:=0;
      //get
      xalign:=low__wordcore2(x,'findalign',inttostr(xfrompos));
      if      (xalign=x.c_aligncentre) then result:=((pw-lx) div 2)
      else if (xalign=x.c_alignright)  then result:=pw-lx;
      //filter
      result:=frcmin(result,0);
      end;
   begin
   try
   //defaults
   xmincheck;
   xlen:=length(x.data);
   //check
   if (xlen<1) then exit;
   //range
   xmin:=frcrange(xmin,1,xlen);
   xmax:=frcrange(xmax,xmin,xlen);
   //init
   pw:=frcmin(x.pagewidth,1);
   ph:=frcmin(x.pageheight,1);
   dx:=0;
   lc:=0;
   lh1:=0;
   lh2:=0;
   lx:=0;
   ly:=0;
   //start at the nearest "completed" line - 25aug2019
   if (xmin>=2) then
      begin
      //init
      int1:=xmin;
      xmin:=1;
      //find -> Important Note: NEVER include the very last line -> it always ends with a #10 -> this can cause return codes to be detected when none are present - 23aug2019
      if (x.linecount>=2) and (x.linesize>=1) then for p:=0 to frcmax(x.linecount-2,x.linesize-1) do
         begin
         if (x.linep[p]<=int1) then
            begin
            //treat as beginning of new line -> set all vars accorddingly - 23aug2019
            lc:=p;
            xmin:=x.linep[p];//1st item on the line
            ly:=x.liney[p];//required
            lx:=0;//not required yet -> alignment not finalised yet -> done last
            dx:=0;
            end
         else break;
         end;//p
      end;
   //get
   if (lc>=x.linesize) then xatleast('line',lc+1000);
   lp:=xmin;
   lac:=#0;
   p:=xmin;
   //for p:=xmin to xmax do
   //begin
redo:
   //init
   low__wordcore__charinfo(x,p,a);
   sh2:=a.height-a.height1;
   if (sh2<0) then sh2:=0;
   //.store line   [never break on #10] [line must have 1+ chars]
   xdif:=0;
   bol1:=((dx+a.width)>=pw) and (p>lp) and (a.c<>#10) and (a.c<>#32);//deny auto-wrap on #10 and #32
   if (not bol1) and (p>lp) and ((lac=#9) or (lac=#32)) and xmustbreak(xdif) then bol1:=true;//break line on a tab(9) or space(32) if remaining text exceeds pagewidth

   if bol1 then
      begin
      //init
      lx:=frcmin(dx-a.width,0);//xxxxxxxxxxxxxxxxxxxfrcmin(dx-xdif,0);
      x.linex[lc]:=xalign_lx(p);//need to workout alignment inorder to set "lx"
      x.liney[lc]:=ly;//top of line
      x.lineh[lc]:=lh1+lh2;//overheight of line
      x.lineh1[lc]:=lh1;//distance from top of line to the base line of line
      x.linep[lc]:=lp;//first item in line
      //inc
      lp:=p;
//yyyyy//was:      if bol1 then lp:=p else lp:=p+1;
      inc(lc);
      if (lc>=x.linesize) then xatleast('line',lc+1000);
      //reset
      inc(ly,lh1+lh2);
      lx:=0;
      lh1:=0;
      lh2:=0;
      dx:=0;
      xdif:=0;
      end;
   //.item
   inc(dx,a.width);
   //.lh1 + lh2
   if (a.height1>lh1) then lh1:=a.height1;
   if (sh2>lh2) then lh2:=sh2;

   //.store line   [never break on #10] [line must have 1+ chars]
   if (not bol1) and ((a.c=#10) or (p=xmax)) then
      begin
      //init
      lx:=frcmin(dx-xdif,0);
      x.linex[lc]:=xalign_lx(p);//need to workout alignment inorder to set "lx"
      x.liney[lc]:=ly;//top of line
      x.lineh[lc]:=lh1+lh2;//overheight of line
      x.lineh1[lc]:=lh1;//distance from top of line to the base line of line
      x.linep[lc]:=lp;//first item in line
      //inc
      lp:=p+1;
      inc(lc);
      if (lc>=x.linesize) then xatleast('line',lc+1000);
      //reset
      inc(ly,lh1+lh2);
      lx:=0;
      lh1:=0;
      lh2:=0;
      dx:=0;
      xdif:=0;
      end;
   //.store progress
   lac:=a.c;
   x.wrapcount:=p;
   x.linecount:=lc;
   x.totalheight:=ly;
   //inc
   inc(p);
   if (p<=xlen) and ( (p<=xmax) or ((xlinecount>=1) and (x.linecount<xlinecount)) ) then goto redo;
   //30aug2019
   x.vhostsync:=true;
   except;end;
   end;
//
   //## xsafe ##
   function xsafe(xindex:longint):longint;
   begin
   result:=xindex;
   if (result<0) then result:=0 else if (result>high(x.txtname)) then result:=high(x.txtname);
   end;
   //## xstyle ##
   function xstyle(x:char):char;
   begin
   case ord(x) of
   9,10,32..255:result:='t';//text
   0:result:='i';//image
   else result:='n';//nil -> unknown
   end;//case
   end;
   //## xsel1 ##
   function xsel1:longint;
   begin
   result:=x.cursorpos;if (x.cursorpos2<result) then result:=x.cursorpos2;
   end;
   //## xsel2 ##
   function xsel2:longint;
   begin
   result:=x.cursorpos2;if (x.cursorpos>result) then result:=x.cursorpos;
   end;
   //## xselstart ##
   function xselstart:longint;
   begin
   result:=frcrange(xsel1,1,length(x.data));
   end;
   //## xselcount ##
   function xselcount:longint;
   begin
   result:=frcrange(xsel2-xsel1,0,length(x.data));
   end;
   //## xdelsel2 ##
   procedure xdelsel2(xmoveto:boolean);
   var
      int1,int2:longint;
   begin
   try
   //init
   int1:=xselstart;
   int2:=xselcount;
   //check
   if (int2<1) then exit;
   //get
   delete(x.data ,int1,int2);
   delete(x.data2,int1,int2);
   delete(x.data3,int1,int2);
   xmincheck;
   xsetcursorpos(int1);
   xwrapadd(xlinebefore(int1),int1+x.c_pagewrap);//04jun2020
   if xmoveto then x.cursor_keyboard_moveto:=int1;
   x.timer_chklinecursorx:=true;
   xchanged;
   except;end;
   end;
   //## xdelsel ##
   procedure xdelsel;
   begin
   try;xdelsel2(true);except;end;
   end;
   //## xmakeimage2 ##
   function xmakeimage2(var ximgdata:string):longint;
   label
      skipend;
   var
      xformat,e:string;
      dw,dh,xnew,p:longint;
      a:tbitmap;
   begin
   try
   //defaults
   result:=0;
   xnew:=-1;
   a:=nil;
   //find existing
   for p:=0 to high(x.txtname) do if (x.imgdata[p]<>'') and (ximgdata=x.imgdata[p]) then
      begin
      result:=p;
      goto skipend;
      end;//p
   //find free
   if (xnew<0) then for p:=0 to high(x.txtname) do if (x.imgdata[p]='') then
      begin
      xnew:=p;
      break;
      end;//p
   //emergency limit -> we need to find items that are nolonger being pointed to and reuse them before just parking it here at the uppermost limit - 21aug2019
   if (xnew<0) then xnew:=high(x.txtname);
   //get
   result:=xnew;
   x.imgdata[result]:=ximgdata;//#1 - store
   x.imgw[result]:=1;
   x.imgh[result]:=1;
   //.convert to raw24
   dw:=1;
   dh:=1;
   a:=tbitmap.create;
   a.width:=1;
   a.height:=1;
   a.pixelformat:=pf24bit;
   if (not low__fromimgdata(a,xformat,ximgdata,e)) or (not low__bmptoraw24(a,x.imgraw24[result],int1,dw,dh)) then
      begin
      dw:=1;
      dh:=1;
      x.imgraw24[result]:='';
      end;
   //sync width & height
   x.imgw[result]:=frcmin(dw,1);
   x.imgh[result]:=frcmin(dh,1);
   x.imgdata[result]:=ximgdata;//#2 - restore at this point AS "low__fromimgdata" automatically decodes data if "b64:" which accounts for 33% smaller streams - 02jun2020
   //changed
   xchanged;
   skipend:
   except;end;
   try;freeobj(@a);except;end;
   end;
   //## xpaste ##
   procedure xpaste;
   label
      skipend;
   var
      a:tbitmap;
      str1,xformat,e:string;
      xbase64:boolean;
   begin
   try
   //defaults
   a:=nil;
   //.image
   if clipboard.hasformat(cf_bitmap) then
      begin
      a:=tbitmap.create;
      a.assign(clipboard);
      low__toimgdata(a,'jif',str1,e);//bmp -> jif
      low__wordcore(x,'insimg',str1);
      goto skipend;
      end;
   //.text
   if clipboard.hasformat(cf_text) then
      begin
      str1:=clipboard.astext;
      case low__findimgformat(str1,xformat,xbase64) of
      true:low__wordcore(x,'insimg',str1);//text is an image
      false:low__wordcore(x,'ioins',str1);//text is text
      end;
      goto skipend;
      end;
   skipend:
   except;end;
   try;freeobj(@a);except;end;
   end;
begin
try
//defaults
result:=false;
xcmd:=lowercase(xcmd);
xoutval:='';
xmusttimerunbusy:=false;
e:=gecTaskfailed;
//init
imax:=high(x.lgfdata);

//check + init
if (xcmd='timer') then//special host driven call -> used by this proc to check keep params and act accordingly - 22aug2019
   begin
   //check
   if x.timerbusy or (x.initstate<>'inited') then goto skipend;
   //init
   xmusttimerunbusy:=true;//remember to turn busy signal back off down below
   x.timerbusy:=true;
   xoldcursorpos:=x.cursorpos;
   xmustpaint:=false;

   //mstack --------------------------------------------------------------------
   while xstackpull(x.mstack,str1) do
   begin
   if (length(str1)>=10) then
      begin
      //init
      xnoidle;
      dx:=to32bit(copy(str1,1,4));//1..4
      dy:=to32bit(copy(str1,5,4));//5..8
      bol1:=(str1[9]=#1);//down
      bol2:=(str1[10]=#1);//right click
      bol3:=x.barfocused;//was barfocused
      if (not x.wasdown) then x.barfocused:=x.barshow and (dy<x.barh);//do once on down click of mouse - 07dec2019
      //.sync cursor
      if x.barfocused then x.cursorstyle:='l'//link cursor
      else x.cursorstyle:='t';//text cursor
      //get
      //.bar
      if x.barshow and (x.barfocused or bol3) then
         begin
         low__wordcore(x,'bar.mouse',from32bit(dx)+from32bit(dy)+bn(bol1)+bn(bol2));
         end;
      //.text box
      if bol1 and (not bol2) and (not x.barfocused) then
         begin
         xsetcursorpos2(low__wordcore2(x,'xy>pos',inttostr(dx)+#32+inttostr(dy)),x.wasdown);
         end;//if
      //set
      x.wasdown:=bol1;
      x.wasright:=bol2;
      end;//if
   end;//while

   //kstack --------------------------------------------------------------------
   while xstackpull(x.kstack,str1) do
   begin
   if (length(str1)>=5) then
      begin
      //init
      xnoidle;
      xctrl:=(str1[1]=#1);
      xalt:=(str1[2]=#1);
      xshift:=(str1[3]=#1);
      xkeyx:=(str1[4]=#1);;
      c:=str1[5];
      str1:='';
      //.retain these key states - 31aug2019
      x.shift:=xshift;
      //get
      //.shortcut
      if xctrl and xkeyx and ((c>='A') and (c<='Z')) then
         begin
         if x.shortcuts or x.styleshortcuts then
            begin
            str1:='Unable';
            //-- edit shortcuts --
            if x.shortcuts and (c='P') and low__wordcore(x,'canpaste','') then
               begin
               low__wordcore(x,'paste','');
               str1:='Paste';
               end
            else if x.shortcuts and (c='T') and low__wordcore(x,'cancut','') then
               begin
               low__wordcore(x,'cut','');
               str1:='Cut';
               end
            else if x.shortcuts and (c='C') and low__wordcore(x,'cancopy','') then
               begin
               low__wordcore(x,'copy','');
               str1:='Copy';
               end
            else if x.shortcuts and (c='U') and low__wordcore(x,'canundo','') then
               begin
               low__wordcore(x,'undo','');
               str1:='Undo';
               end
            else if x.shortcuts and (c='R') and low__wordcore(x,'canredo','') then
               begin
               low__wordcore(x,'redo','');
               str1:='Redo';
               end
            else if x.shortcuts and (c='S') and low__wordcore(x,'cansave','') then
               begin
               low__wordcore(x,'save','');
               str1:='Save';
               end
            //-- style shortcuts --
            else if x.styleshortcuts and (c='N') and low__wordcore(x,'canstyle','') then
               begin
               low__wordcore(x,'style','N');
               str1:='Normal';
               end
            else if x.styleshortcuts and (c='B') and low__wordcore(x,'canstyle','') then
               begin
               low__wordcore(x,'style','B');
               str1:='Bold';
               end
            else if x.styleshortcuts and (c='I') and low__wordcore(x,'canstyle','') then
               begin
               low__wordcore(x,'style','I');
               str1:='Italic';
               end
            else if x.styleshortcuts and (c='U') and low__wordcore(x,'canstyle','') then
               begin
               low__wordcore(x,'style','U');
               str1:='Underline';
               end
            else if x.styleshortcuts and (c='K') and low__wordcore(x,'canstyle','') then
               begin
               low__wordcore(x,'style','K');
               str1:='Strikeout';
               end
            //-- unknown shortcut --
            else str1:='';
            //brief status
            if (x.briefstatus<>'') then x.briefstatus:=str1;
            end;//c
         end
      //.special key
      else if xkeyx then
         begin
         case ord(c) of
         vk_return:   if not x.readonly then low__wordcore(x,'ins',#10);
         vk_tab:      if not x.readonly then low__wordcore(x,'ins',#9);
         vk_delete:   if not x.readonly then low__wordcore(x,'delr','');
         vk_back:     if not x.readonly then low__wordcore(x,'dell','');
         vk_left:     low__wordcore(x,'move','left');
         vk_right:    low__wordcore(x,'move','right');
         vk_up:       low__wordcore(x,'move','up');
         vk_down:     low__wordcore(x,'move','down');
         vk_prior:    low__wordcore(x,'move','pageup');
         vk_next:     low__wordcore(x,'move','pagedown');
         vk_home:     low__wordcore(x,'move','home');
         vk_end:      low__wordcore(x,'move','end');
         {
         vk_f2:if canfind then find(true);//find up - 16aug2014
         vk_f3:if canfind then find(false);//find down - 16aug2014
         vk_f7:if (odic<>nil) then odic.spellstatus:=3;//find next spelling error - 19aug2014
         {}//xxxxxxxxxx
         end;//case
         end
      //.standard character
      else if (not xkeyx) and (not x.readonly) then low__wordcore(x,'ins',c);
      end;//if
   end;//while

   xcursor_keyboard_moveto:=x.cursor_keyboard_moveto;       x.cursor_keyboard_moveto:=0;//take value and set to zero (off)
   xchklinecursorx:=x.timer_chklinecursorx;                 x.timer_chklinecursorx:=false;

   //wrap list -----------------------------------------------------------------
   //init
   bol1:=false;
   int1:=maxint;
   int2:=minint;
   //.special "timer_setcursorpos" -> need to wrap to this point inorder to paint the screen AND set the cursor for real - 30aug2019
   if (xcursor_keyboard_moveto>=1) then xsetcursorpos2(xcursor_keyboard_moveto,x.shift);//auto adds wrap request if required

   //get
   while xwrappull(int3,int4) do
   begin
   if (int3>=0) and (int4>=0) then
      begin
      //extend range
      if (int3<int1) then int1:=int3;
      if (int4>int2) then int2:=int4;
      bol1:=true;
      end;
   end;//whilte
   //set
   if bol1 then
      begin
      //.reposition realtime wrap
      if (int1=int2) then x.wrapcount:=frcrange(int1,0,length(x.data))
      //.rewrap selected area
      else xwrapnow(int1,int2,x.vpos+1);
      //update
      xmustpaint:=true;
      end;

   //realtime wrap -------------------------------------------------------------
   if (ms64>=x.timer100) then
      begin
      int1:=x.wrapcount;
      if (x.data<>'') and (int1<length(x.data)) then
         begin
         //init
         if      (low__keyboardidle<=2000) then int2:=1000
         else if (low__keyboardidle<=5000) then int2:=x.c_smallwrap
         else int2:=x.c_bigwrap;
         //get
         xwrapnow(int1,int1+int2,x.vpos+1);
         if (int1<>x.wrapcount) then xmustpaint:=true;
         end;

      //sync
      str1:=inttostr(low__wordcore2(x,'viewwidth',''))  +'|'+
            inttostr(low__wordcore2(x,'viewheight','')) +'|'+
            inttostr(low__wordcore2(x,'pagewidth',''))  +'|'+
            inttostr(low__wordcore2(x,'pageheight','')) +'|'+
            inttostr(x.feather)+'|'+//02jun2020, 21sep2019
            '';
      if (x.syncref<>str1) then
         begin
         x.syncref:=str1;
         x.mustpaint:=true;
         end;

      //reset
      x.timer100:=ms64+100;
      end;

   //vhostsync -----------------------------------------------------------------
   if (xcursor_keyboard_moveto>=1) or (x.vcheck>=1) then
      begin
      x.vcheck:=frcmin(x.vcheck-1,0);
      int1:=low__wordcore2(x,'pos>line',inttostr(x.cursorpos));
      if xsafeline(int1) then
         begin
         bol1:=true;
         bol2:=true;
         //.check 1 -> scroll up to cursor
         int3:=low__wordcore2(x,'paintline1','');
         bol2:=xsafeline(int3);
         if bol1 and bol2 and (x.liney[int1]<x.liney[int3]) then
            begin
            bol1:=false;
            x.vpos:=int1;
            x.vhostsync:=true;
            end;
         //.check 2 -> scroll down to cursor
         int3:=low__wordcore2(x,'paintline2','');
         xsafeline(int3);
         if bol1 and (x.liney[int1]>x.liney[int3]) then
            begin
            //init
            bol1:=false;
            int3:=int1;
            //get
            if (int3>0) then
               begin
               for p:=int3 downto 0 do
               begin
               if ((x.liney[int3]+x.lineh[int3]-x.liney[p])<=x.viewheight) then int1:=p else break;
               end;//p
               end;
            //set
            x.vpos:=int1;
            x.vhostsync:=true;
            end;
         //.check 3 -> fallback check (when 1 above fails) -> scroll to x.cursorpos
         if bol1 and (not bol2) then
            begin
            x.vpos:=int1;
            x.vhostsync:=true;
           end;
         end;
      end;

   //linecursorx update --------------------------------------------------------
   if xchklinecursorx then
      begin
      xlinecursorx(x.cursorpos);
      end;

   //flash cursor
   if (ms64>=x.timerslow) then
      begin
      x.flashcursor:=not x.flashcursor;
      //update buttons
      xupdatebuttons;
      //reset
      x.timerslow:=ms64+500;
      end;
   //.draw cursor -> detect change and trigger paint -> 29aug2019
   bol1:=x.showcursor and x.havefocus and (x.flashcursor or (x.idleref>=ms64));
   if (bol1<>x.drawcursor) then
      begin
      x.drawcursor:=bol1;
      if x.cursoronscrn then xmustpaint:=true;
      end;

   //.toolbar - optional - 07dec2019
   if x.barshow then
      begin
      low__wordcore(x,'bar.timer','');
      end;

   //set
   if xmustpaint then x.mustpaint:=true;
   //done
   goto skipdone;
   end
//.toolbar init -> allow this during init of wordcore - 07dec2019
else if (xcmd='bar.init') then low__wordcore__bar(x,xcmd,xval,xoutval)
//.init support
else if (xcmd='getinited') then
   begin
   if (x.initstate='inited') then xoutval:='1' else xoutval:='0';
   goto skipdone;
   end
else if (x.initstate='initing') then
   begin
   e:='Init busy';
   exit;
   end
else if (x.initstate<>'inited') then
   begin
   if (xcmd='init') or (xcmd='init.dataonly') then//wordcore
      begin
      //init
      x.initstate:='initing';
      int1:=rgb(255,255,255);
      //special delayed events/vars
      x.cursor_keyboard_moveto  :=0;
      x.timer_chklinecursorx    :=false;
      //constant values
      x.c_bigwrap     :=300*1000;//300K item blocks
      x.c_smallwrap   :=10000;//10K item blocks
      x.c_pagewrap    :=10000;//for entire page (best guess), may not be adequate for large screens - 26aug2019
      x.c_idlepause   :=500;//500ms
      //.paragraph alignments
      x.c_alignleft   :=0;
      x.c_aligncentre :=1;
      x.c_alignright  :=2;
      x.c_alignmax    :=2;
      //other
      x.landscape     :=false;
      x.wrapstyle     :=2;//wrap to page
      //system
      x.dataonly      :=(xcmd='init.dataonly');//07dec2019
      x.timer100:=ms64;
      x.timerslow:=ms64;
      x.idleref:=ms64+x.c_idlepause;
      x.timerbusy:=false;
      x.wrapstack:='';
      x.kstack:='';
      x.mstack:='';
      x.briefstatus:='';
      x.shortcuts:=true;
      x.styleshortcuts:=true;
      x.flashcursor:=false;
      x.drawcursor:=true;
      x.cursoronscrn:=false;
      x.linecursorx:=0;
      x.havefocus:=true;
      x.showcursor:=true;
      x.readonly:=false;
      x.shift:=false;
      x.wasdown:=false;
      x.wasright:=false;
      x.feather:=0;//off
      //.buffer support -> used for screen painting
      x.buffer               :=nil;//when in use, it should be 32bit - 29aug2019
      x.bufferrows           :=nil;
      x.buffermem            :='';
      x.bufferref            :='';
      x.vpos                 :=0;
      x.vhostsync            :=false;
      x.vcheck               :=0;
      x.hpos                 :=0;
      x.hhostsync            :=false;
      x.syncref              :='';
      //get
      try
      for p:=0 to imax do
      begin
      //font list
      x.lgfdata[p]:='';
      x.lgfnref[p]:='';
      //text list
      x.txtname[p]:='';
      x.txtsize[p]:=0;
      x.txtbold[p]:=false;
      x.txtitalic[p]:=false;
      x.txtunderline[p]:=false;
      x.txtstrikeout[p]:=false;
      x.txtcolor[p]:=0;
      x.txtbk[p]:=int1;
      x.txtborder[p]:=clnone;//off
      x.txtalign[p]:=x.c_alignleft;
      x.txtid[p]:=0;//set to default
      //image list
      x.imgdata[p]:='';
      x.imgraw24[p]:='';
      x.imgw[p]:=1;
      x.imgh[p]:=1;
      end;//p
      //data streams
      x.data:=#10;
      x.data2:=#0;
      x.data3:=#0;
      //support streams
      x.linesize:=0;
      x.listsize:=0;
      x.corelinex:='';
      x.coreliney:='';
      x.corelineh:='';
      x.corelineh1:='';
      x.corelinep:='';
      //.size -> ready for use
      xatleast('line',1000);
      except;end;
      //current
      x.cfontname     :='arial';
      x.cfontsize     :=12;
      x.cbold         :=false;
      x.citalic       :=false;
      x.cunderline    :=false;
      x.cstrikeout    :=false;
      x.ccolor        :=0;
      x.cbk           :=clnone;
      x.cborder       :=clnone;
      x.calign        :=x.c_alignleft;
      //paint
      x.cursorpos     :=1;
      x.cursorpos2    :=1;
      x.pagewidth     :=800;
      x.pageheight    :=maxint;//continuous
      x.pagecolor     :=rgb(255,255,255);
      x.pageselcolor  :=rgb(136,195,255);
      x.viewwidth     :=800;
      x.viewheight    :=600;
      x.viewcolor     :=rgb(152,152,152);
      x.pagecount     :=1;
      x.totalheight   :=0;
      x.linecount     :=0;
      x.line          :=0;
      x.col           :=0;
      x.wrapcount     :=0;
      x.dataid        :=0;
      x.modified      :=false;
      x.mustpaint     :=true;
      x.paintlock     :=false;
      x.cursorstyle   :='t';//text cursor
      //.reference
      x.bwd_color     :=clnone;
      x.bwd_color2    :=clnone;
      x.bwd_bk        :=clnone;
      //.claude support - optional - 14jul2020
      x.useclaudecolors :=false;
      x.claude_text1    :=0;
      x.claude_text2    :=0;
      x.claude_text3    :=0;
      x.claude_text4    :=0;
      x.claude_text5    :=0;
      x.claude_header1  :=0;
      x.claude_header2  :=0;
      x.claude_header3  :=0;
      x.claude_header4  :=0;
      x.claude_header5  :=0;
      //.optional toolbar setup
      x.barshow       :=not x.dataonly;
      x.barfocused    :=false;
      x.barh          :=0;
      //init optional toolbar
      if not x.dataonly then low__wordcore(x,'bar.init','');//don't init toolbar when in dataonly mode
      //finalise
      x.initstate:='inited';
      //successful
      result:=true;
      goto skipend;
      end
   else
      begin
      e:='Must init';
      goto skipend;
      end;
   end;

//-- information ---------------------------------------------------------------
if (xcmd='init') or (xcmd='init.dataonly') then
   begin
   //nil
   end
//.optional toolbar support #2
else if (copy(xcmd,1,4)='bar.') then low__wordcore__bar(x,xcmd,xval,xoutval)//07dec2019
else if (xcmd='cwritesel') then cwritesel(xval)
//04jun2020
else if (xcmd='cwritealign') then cwritealign
//
//.paint
else if (xcmd='canpaint') then
   begin
   if (x.wrapstack='') then xoutval:='1';
   end
else if (xcmd='mustpaint') then
   begin
   //set
   if (xval<>'') then x.mustpaint:=(strint(xval)<>0);
   //get
   if x.mustpaint then xoutval:='1';
   end
else if (xcmd='paintlock') then
   begin
   if (xval<>'') then
      begin
      bol1:=(strint(xval)<>0);
      if bol1 and x.paintlock then xoutval:='0'//already painting
      else
         begin
         x.paintlock:=bol1;
         xoutval:='1';
         end;
      end;
   end
else if (xcmd='havefocus') then
   begin
   //set
   if (xval<>'') then
      begin
      bol1:=x.havefocus;
      x.havefocus:=(strint(xval)<>0);
      if (bol1<>x.havefocus) then x.mustpaint:=true;
      end;
   //get
   if x.havefocus then xoutval:='1';
   end
else if (xcmd='showcursor') then
   begin
   //set
   if (xval<>'') then
      begin
      bol1:=x.showcursor;
      x.showcursor:=(strint(xval)<>0);
      if (bol1<>x.showcursor) then x.mustpaint:=true;
      end;
   //get
   if x.showcursor then xoutval:='1';
   end
//.keyboard support
else if (xcmd='kstack') then
   begin
   if (xval<>'') then x.kstack:=x.kstack+from32bit(length(xval))+xval;
   end
//.mouse support
else if (xcmd='mstack') then
   begin
   if (xval<>'') then x.mstack:=x.mstack+from32bit(length(xval))+xval;
   end
else if (xcmd='briefstatus') then
   begin
   xoutval:=x.briefstatus;
   x.briefstatus:='';
   end
//.wrap
else if (xcmd='wrap') then xwrapadd(0,0)//restart wrap
else if (xcmd='wrapto') then
   begin
   int1:=strint(xval);
   if (int1>x.wrapcount) then xwrapadd(x.wrapcount,int1)//auto wrap
   end
else if (xcmd='wrapall') then xwrapadd(0,length(x.data))
//.font style
//04jun2020
else if (xcmd='findalign') then//find alignment value based on input position "1..length(x.data)"
   begin
   xoutval:='0';//0=left, 1=centre, 2=right
   if (x.data<>'') and (xval<>'') then
      begin
      int1:=low__wordcore2(x,'pos>rc',xval);//find nearest return code "#10"
      if low__wordcore__charinfo(x,int1,xchar) and (xchar.cs='t') and (xchar.c=#10) then xoutval:=inttostr(x.txtalign[xchar.wid]);
      end;
   end
//
//.other
else if (xcmd='selstart') then xoutval:=inttostr(xselstart)
else if (xcmd='selcount') then xoutval:=inttostr(xselcount)
else if (xcmd='cursorpos') then
   begin
   //set
   if (xval<>'') then
      begin
      xsetcursorpos(strint(xval));
      xchanged;
      end;
   //get
   xoutval:=inttostr(x.cursorpos);
   end
else if (xcmd='cursorpos2') then
   begin
   //set
   if (xval<>'') then
      begin
      x.cursorpos2:=frcrange(strint(xval),1,length(x.data));
      int1:=x.cursorpos2+x.c_pagewrap;
      if (int1>x.wrapcount) then xwrapadd(x.wrapcount,int1);
      xchanged;
      end;
   //get
   xoutval:=inttostr(x.cursorpos2);
   end
else if (xcmd='pagewidth') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.pagewidth;
      x.pagewidth:=frcmin(strint(xval),1);
      if (i<>x.pagewidth) then
         begin
         xwrapadd(0,x.cursorpos+x.c_pagewrap);
         x.hhostsync:=true;
         x.vhostsync:=true;
         xchanged;
         end;
      end;
   //get
   xoutval:=inttostr(x.pagewidth);
   end
else if (xcmd='pageheight') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.pageheight;
      x.pageheight:=frcmin(strint(xval),1);
      if (i<>x.pageheight) then
         begin
         x.vhostsync:=true;
         xchanged;
         end;
      end;
   //get
   xoutval:=inttostr(x.pageheight);
   end
else if (xcmd='useclaudecolors') then//14jul2020
   begin
   //set
   if (xval<>'') then
      begin
      bol1:=x.useclaudecolors;
      x.useclaudecolors:=nb(xval);
      if (bol1<>x.useclaudecolors) then xchanged;
      end;
   //get
   xoutval:=bn(x.useclaudecolors);
   end
else if (xcmd='pagecolor') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.pagecolor;
      x.pagecolor:=strint(xval);
      if (i<>x.pagecolor) then xchanged;
      end;
   //get
   xoutval:=inttostr(x.pagecolor);
   end
else if (xcmd='pageselcolor') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.pageselcolor;
      x.pageselcolor:=strint(xval);
      if (i<>x.pageselcolor) then xchanged;
      end;
   //get
   xoutval:=inttostr(x.pageselcolor);
   end
//.host viewing area
else if (xcmd='viewwidth') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.viewwidth;
      x.viewwidth:=frcmin(strint(xval),1);
      if (i<>x.viewwidth) then
         begin
         x.hhostsync:=true;
         x.vhostsync:=true;
         x.mustpaint:=true;
         end;
      end;
   //get
   xoutval:=inttostr(x.viewwidth);
   end
else if (xcmd='viewheight') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.viewheight;
      x.viewheight:=frcmin(strint(xval),1);
      if (i<>x.viewheight) then
         begin
         x.vhostsync:=true;
         x.mustpaint:=true;
         end;
      end;
   //get
   xoutval:=inttostr(x.viewheight);
   end
else if (xcmd='viewcolor') then
   begin
   //set
   if (xval<>'') then
      begin
      i:=x.viewcolor;
      x.viewcolor:=strint(xval);
      if (i<>x.viewcolor) then xchanged;
      end;
   //get
   xoutval:=inttostr(x.viewcolor);
   end
//.host v/h scrollbar ranges
else if (xcmd='vmax') then xoutval:=inttostr(frcmin(x.linecount-1,0))
else if (xcmd='vpos') then
   begin
   int1:=frcmin(x.linecount-1,0);
   //set
   if (xval<>'') then
      begin
      int2:=frcrange(strint(xval),0,int1);
      if (x.vpos<>int2) then
         begin
         x.vpos:=int2;
         x.mustpaint:=true;
         end;
      end;
   //get
   xoutval:=inttostr(frcrange(x.vpos,0,int1));
   end
else if (xcmd='vhostsync') then//tells host it must re-sync vertical scrollbar
   begin
   if (xval<>'') then x.vhostsync:=(strint(xval)<>0);//set
   if x.vhostsync then xoutval:='1';//get
   end
else if (xcmd='hmax') then xoutval:=inttostr(frcmin(x.pagewidth-x.viewwidth,0))
else if (xcmd='hpos') then
   begin
   int1:=frcmin(x.pagewidth-x.viewwidth,0);
   //set
   if (xval<>'') then
      begin
      int2:=frcrange(strint(xval),0,int1);
      if (x.hpos<>int2) then
         begin
         x.hpos:=int2;
         x.mustpaint:=true;
         end;
      end;
   //get
   xoutval:=inttostr(frcrange(x.hpos,0,int1));
   end
else if (xcmd='hpos2') then//only return hpos value if showing the horizontal scrollbar
   begin
   int1:=frcmin(x.pagewidth-x.viewwidth,0);
   if (int1>=1) then xoutval:=inttostr(frcrange(x.hpos,0,int1));
   end
else if (xcmd='hshow') then
   begin
   if (frcmin(x.pagewidth-x.viewwidth,0)>=1) then xoutval:='1';
   end
else if (xcmd='hhostsync') then//tells host it must re-sync horizontal scrollbar
   begin
   if (xval<>'') then x.hhostsync:=(strint(xval)<>0);//set
   if x.hhostsync then xoutval:='1';//get
   end
//.other
else if (xcmd='totalheight') then xoutval:=inttostr(x.totalheight)
else if (xcmd='dataid') then
   begin
   //set
   if (xval<>'') then x.dataid:=frcmin(strint(xval),0);
   //get
   xoutval:=inttostr(x.dataid);
   end
else if (xcmd='modified') then
   begin
   if (xval<>'') then x.modified:=(xval<>'0');
   xoutval:=bn(x.modified);
   end
else if (xcmd='feather') then
   begin
   if (xval<>'') then x.feather:=frcrange(strint(xval),0,2);
   xoutval:=inttostr(x.feather);
   end
else if (xcmd='linecount') then xoutval:=inttostr(x.linecount)
else if (xcmd='line') then xoutval:=inttostr(x.line)
else if (xcmd='col') then xoutval:=inttostr(x.col)
else if (xcmd='bytes') then xoutval:=inttostr(frcmin( (length(x.data)-1)*3 ,0))//just text data -> images and fonts MAY NOT be in use, but MAY BE present in the cache system - 24aug2019

//-- actions -------------------------------------------------------------------
else if (xcmd='free') then
   begin
   x.initstate:='';//disable control
   x.data:=#10;
   x.data2:=#0;
   x.data3:=#0;
   for p:=0 to imax do
   begin
   x.lgfdata[p]:='';
   x.lgfnref[p]:='';
   x.txtname[p]:='';
   x.imgdata[p]:='';
   x.imgraw24[p]:='';
   end;//p
   freeobj(@x.buffer);
   x.buffermem:='';
   end
else if (xcmd='clear') then
   begin
   x.data:=#10;
   x.data2:=#0;
   x.data3:=#0;
   for p:=0 to imax do
   begin
   x.lgfdata[p]:='';
   x.lgfnref[p]:='';
   x.txtname[p]:='';
   x.imgdata[p]:='';
   x.imgraw24[p]:='';
   end;//p
   //current
   x.cfontname     :='arial';
   x.cfontsize     :=12;
   x.cbold         :=false;
   x.citalic       :=false;
   x.cunderline    :=false;
   x.cstrikeout    :=false;
   x.ccolor        :=0;
   x.cbk           :=clnone;
   x.cborder       :=clnone;
   x.calign        :=0;
   //finalise
   x.cursorpos     :=1;
   x.cursorpos2    :=1;
   x.linecount     :=0;
   x.line          :=0;
   x.col           :=0;
   x.dataid        :=0;
   x.modified      :=false;
   x.wrapcount     :=0;
   x.wrapstack     :='';
   x.mustpaint     :=true;
   //.reference
   x.bwd_color     :=clnone;
   x.bwd_color2    :=clnone;
   x.bwd_bk        :=clnone;
   end
else if (xcmd='mincheck') then xmincheck
else if (xcmd='ins') then
   begin
//   if (random(4)=1) then x.cbk:=clnone else x.cbk:=rgb(200+random(55),100+random(155),200+random(55));//xxxxxxxxxxxxx
//   if (length(xval)>=100) then x.cfontsize:=14 else x.cfontsize:=10+random(62);

   xnoidle;
   //filter text -> remove any characters in the system range
   low__wordcore__filtertext(xval);
   //delete existing selection
   if (xselcount>=1) then xdelsel2(xval='');//don't set "*_moveto" when inserting one or more characters - 02sep2019

   //insert text
   if (xval<>'') then
      begin
      //init
      str1:=xval;
      str2:=xval;
      str3:=xval;
      xval:='';
      wrd2.val:=xmakefont;//once only
      for p:=1 to length(str1) do
      begin
      c:=str1[p];
      if (xstyle(c)<>'t') then c:='?';
      str1[p]:=c;
      str2[p]:=wrd2.chars[0];
      str3[p]:=wrd2.chars[1];
      end;//p
      //get
      xmincheck;
      int1:=length(x.data);
      int2:=x.cursorpos;
      insert(str1,x.data ,int2);
      insert(str2,x.data2,int2);
      insert(str3,x.data3,int2);
      xsetcursorpos(int2+length(str1));
      xwrapadd(xlinebefore(int2),int2+length(str1)+x.c_pagewrap);
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   end
else if (xcmd='insimg') then
   begin
   xnoidle;
   //delete existing selection
   if (xselcount>=1) then xdelsel2(xval='');//don't set "*_moveto" when inserting one or more characters - 02sep2019

   //insert image
   if (xval<>'') then
      begin
      //init
      str1:=#0;
      wrd2.val:=xmakeimage2(xval);
      str2:=wrd2.chars[0];
      str3:=wrd2.chars[1];
      xval:='';
      //get
      xmincheck;
      int1:=length(x.data);
      int2:=x.cursorpos;
      insert(str1,x.data ,int2);
      insert(str2,x.data2,int2);
      insert(str3,x.data3,int2);
      xsetcursorpos(int2+length(str1));
      xwrapadd(xlinebefore(int2),int2+length(str1)+x.c_pagewrap);
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   end
//04jun2020
else if (xcmd='all') then cwriteall(xval)
else if (xcmd='selectall') then
   begin
   low__wordcore(x,'cursorpos',inttostr(1));
   low__wordcore(x,'cursorpos2',inttostr(length(x.data)));
   end
else if (xcmd='copy') then//handles bitmap+text image+text - 14jul2020, 05jun2020
   begin
   if (xval<>'txt') and (xval<>'txtwin') and (xval<>'bwd') and (xval<>'bwp') then xval:='bwp';
   if not low__wordcore3(x,'ioget',xval+'# sel',str1,e) then goto skipend;
   clipboard.astext:=str1;
   end
else if (xcmd='copyall') then//handles bitmap+text image+text - 14jul2020, 05jun2020
   begin
   if (xval<>'txt') and (xval<>'txtwin') and (xval<>'bwd') and (xval<>'bwp') then xval:='bwp';
   if not low__wordcore3(x,'ioget',xval+'# all',str1,e) then goto skipend;
   clipboard.astext:=str1;
   end
//
else if (xcmd='paste') then//handles bitmap+text image+text
   begin
   xpaste;
   end
else if (xcmd='dell') then
   begin
   xnoidle;
   if (xselcount>=1) then xdelsel
   else if (x.cursorpos>=2) then
      begin
      int1:=x.cursorpos-1;
      delete(x.data,int1,1);
      delete(x.data2,int1,1);
      delete(x.data3,int1,1);
      xmincheck;
      xsetcursorpos(int1);
      xwrapadd(xlinebefore(int1),int1+x.c_pagewrap);//04jun2020
      x.cursor_keyboard_moveto:=int1;
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   end
else if (xcmd='delr') then
   begin
   xnoidle;
   if (xselcount>=1) then xdelsel
   else
      begin
      delete(x.data,x.cursorpos,1);
      delete(x.data2,x.cursorpos,1);
      delete(x.data3,x.cursorpos,1);
      xmincheck;
      xsetcursorpos(x.cursorpos);
      xwrapadd(xlinebefore(x.cursorpos),x.cursorpos+x.c_pagewrap);//04jun2020
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   end
//.move - cursor
else if (xcmd='move') then
   begin
   //left
   if (comparetext(xval,'left')=0) then
      begin
      x.cursor_keyboard_moveto:=frcrange(x.cursorpos-1,1,length(x.data));
      x.timer_chklinecursorx:=true;
      end
   //right
   else if (comparetext(xval,'right')=0) then
      begin
      x.cursor_keyboard_moveto:=frcrange(x.cursorpos+1,1,length(x.data));
      x.timer_chklinecursorx:=true;
      end
   //up
   else if (comparetext(xval,'up')=0) then
      begin
      xline:=low__wordcore2(x,'pos>line',inttostr(x.cursorpos))-1;
      if (xline<0) then
         begin
         x.cursor_keyboard_moveto:=1;
         x.timer_chklinecursorx:=true;
         end
      else if xsafeline(xline) then
         begin
         int1:=x.linep[xline];
         int2:=int1;
         int3:=low__wordcore2(x,'line>pos',inttostr(xline+1))-1;
         if (int3>=int2) then
            begin
            dx:=x.linex[xline];
            for p:=int2 to int3 do
            begin
            if not low__wordcore__charinfo(x,p,xchar) then break;
            if (dx<=x.linecursorx) then int1:=p;
            inc(dx,xchar.width);
            end;//p
            end;//if
         x.cursor_keyboard_moveto:=frcrange(int1,1,length(x.data));
         end;
      end
   //down
   else if (comparetext(xval,'down')=0) then
      begin
      xline:=low__wordcore2(x,'pos>line',inttostr(x.cursorpos))+1;
      if xsafeline(xline) then
         begin
         int1:=x.linep[xline];
         int2:=int1;
         int3:=low__wordcore2(x,'line>pos',inttostr(xline+1))-1;
         if (int3>=int2) then
            begin
            dx:=x.linex[xline];
            for p:=int2 to int3 do
            begin
            if not low__wordcore__charinfo(x,p,xchar) then break;
            if (dx<=x.linecursorx) then int1:=p;
            inc(dx,xchar.width);
            end;//p
            end;//if
         x.cursor_keyboard_moveto:=frcrange(int1,1,length(x.data));
         end;
      end
   //pageup
   else if (comparetext(xval,'pageup')=0) then
      begin
      //scan up X lines
      xline:=low__wordcore2(x,'pos>line',inttostr(x.cursorpos));
      int3:=xline;
      if xsafeline(xline) then
         begin
         int1:=xline;
         int2:=xline;
         while true do
         begin
         dec(int2);
         if not xsafeline(int2) then break;
         if ((x.liney[int1]-x.liney[int2])<=x.viewheight) then xline:=int2 else break;
         end;//while
         //at least one line overlapping (if we can spare it)
         if (xline<=(int3-1)) and (xline>0) then inc(xline);
         end;
      //get
      if (xline<0) then
         begin
         x.cursor_keyboard_moveto:=1;
         x.timer_chklinecursorx:=true;
         end
      else if xsafeline(xline) then
         begin
         int1:=x.linep[xline];
         int2:=int1;
         int3:=low__wordcore2(x,'line>pos',inttostr(xline+1))-1;
         if (int3>=int2) then
            begin
            dx:=x.linex[xline];
            for p:=int2 to int3 do
            begin
            if not low__wordcore__charinfo(x,p,xchar) then break;
            if (dx<=x.linecursorx) then int1:=p;
            inc(dx,xchar.width);
            end;//p
            end;//if
         x.cursor_keyboard_moveto:=frcrange(int1,1,length(x.data));
         end;
      end
   //pagedown
   else if (comparetext(xval,'pagedown')=0) then
      begin
      //scan up X lines
      xline:=low__wordcore2(x,'pos>line',inttostr(x.cursorpos));
      int3:=xline;
      if xsafeline(xline) then
         begin
         int1:=xline;
         int2:=xline;
         while true do
         begin
         inc(int2);
         if not xsafeline(int2) then break;
         if ((x.liney[int2]-x.liney[int1])<=x.viewheight) then xline:=int2 else break;
         end;//while
         //at least one line overlapping (if we can spare it)
         if (xline>=(int3+1)) and (xline<(x.linecount-1)) then dec(xline);
         end;
      //get
      if xsafeline(xline) then
         begin
         int1:=x.linep[xline];
         int2:=int1;
         int3:=low__wordcore2(x,'line>pos',inttostr(xline+1))-1;
         if (int3>=int2) then
            begin
            dx:=x.linex[xline];
            for p:=int2 to int3 do
            begin
            if not low__wordcore__charinfo(x,p,xchar) then break;
            if (dx<=x.linecursorx) then int1:=p;
            inc(dx,xchar.width);
            end;//p
            end;//if
         x.cursor_keyboard_moveto:=frcrange(int1,1,length(x.data));
         end;
      end
   //home
   else if (comparetext(xval,'home')=0) then x.cursor_keyboard_moveto:=1
   //end
   else if (comparetext(xval,'end')=0) then x.cursor_keyboard_moveto:=length(x.data)
   //error
   else
      begin
      showerror60('Wordcore: Unknown move directive "'+xval+'"');
      end;
   end
//.find previous line start "xpos"
//04jun2020
else if (xcmd='pos>line-1>pos') then//expects input of xpos=1..x.data.len
   begin
   xoutval:='1';
   if (xval<>'') then
      begin
      int1:=frcmin(low__wordcore2(x,'pos>line',xval)-1,0);
      xoutval:=inttostr(frcrange(low__wordcore2(x,'line>pos',inttostr(int1)),1,length(x.data)));
      end;
   end
//
//.find earliest line by "xpos"
else if (xcmd='pos>line') then//expects input of xpos=1..x.data.len
   begin
   //init
   xoutval:='0';//closest match
   int1:=frcrange(strint(xval),1,length(x.data));
   int1:=frcmin(frcmax(int1,x.wrapcount),1);
   int2:=0;
   //find line by text.xpos
   if (x.wrapcount>=1) and (x.linecount>=1) then
      begin
      for p:=0 to frcmax(x.linecount-1,x.linesize-1) do
      begin
      if (x.linep[p]=int1) then
         begin
         int2:=p;
         break;
         end
      else if (x.linep[p]>int1) then break
      else int2:=p;
      end;//p
      end;//if
   //return result
   xoutval:=inttostr(int2);
   end
//.find earliest line by "y" coordinate position
else if (xcmd='y>line') then//expects input of y=0..(x.totalheight-1)
   begin
   //init
   xoutval:='-1';//not found
   int1:=strint(xval);
   //find line by y.coordinate
   if (x.linecount>=1) then for p:=0 to frcmax(x.linecount-1,x.linesize-1) do if ((x.liney[p]+x.lineh[p])>=int1) then
      begin
      xoutval:=inttostr(p);
      break;
      end;//p
   end
//.find pos at start of line
else if (xcmd='line>pos') then//expects input of lineindex=0..(x.linecount-1)
   begin
   xoutval:='0';//not found
   int1:=strint(xval);
   if (int1>=0) then
      begin
      if (int1<x.linecount) and (int1<x.linesize) then xoutval:=inttostr(x.linep[int1])
      else if (x.wrapcount>=length(x.data)) then xoutval:=inttostr(length(x.data))//last line
      else if (x.linecount>=1) and (x.linecount<=x.linesize) then xoutval:=inttostr(x.linep[x.linecount-1]);//return the furtherest line pos we can - 31aug2019
      end;
   end
//.find number of items in line
else if (xcmd='line>itemcount') then//expects input of lineindex=0..(x.linecount-1)
   begin
   xoutval:='0';//none
   int1:=strint(xval);
   if (int1>=0) and (int1<x.linecount) and (int1<x.linesize) then
      begin
      int2:=x.linep[int1];
      if ((int1+1)<x.linecount) and ((int1+1)<x.linesize) then int2:=x.linep[int1+1]-int2 else int2:=length(x.data)-int2+1;
      if (int2<0) then int2:=0;//enforce min. range
      xoutval:=inttostr(int2);
      end;
   end
//.find position in data stream from x,y coordinates (relative to current vpos/hpos)
else if (xcmd='xy>pos') then
   begin
   //init
   xoutval:='0';//not found
   bol1:=false;
   for p:=1 to length(xval) do if (xval[p]=#32) then
      begin
      dx:=strint(copy(xval,1,p-1));
      dy:=strint(copy(xval,p+1,length(xval)))-x.barh;//coordinate correction - 06dec2019
      bol1:=true;
      break;
      end;
   //find y.coordinate
   if bol1 and (x.linecount>=1) then
      begin
      int1:=low__wordcore2(x,'vpos','');
      if (int1>=0) and (int1<x.linecount) and (int1<x.linesize) then
         begin
         inc(dy,x.liney[int1]);//make dy relative
         //find best line
         int4:=int1;
         for p:=frcmin(int1-100,0) to frcmax(x.linecount-1,x.linesize-1) do if (dy>=x.liney[p]) then int4:=p else break;
         //get
         if (int4>=0) then
            begin
            p:=int4;
            //make dx relative
            if (x.pagewidth<x.viewwidth) then dec(dx,(x.viewwidth-x.pagewidth) div 2) else inc(dx,low__wordcore2(x,'hpos2',''));
            int2:=x.linex[p];
            int3:=x.linep[p];
            for p2:=x.linep[p] to (x.linep[p]+low__wordcore2(x,'line>itemcount',inttostr(p))-1) do
            begin
            if not low__wordcore__charinfo(x,p2,xchar) then break;
            if (dx>=(int2-2)) then int3:=p2 else break;
            inc(int2,xchar.width);
            end;//p2
            xoutval:=inttostr(int3);
            end;//p
         end;//int1
      end;//if
   end
//04jun2020
else if (xcmd='pos>rc') then//find end of line #10
   begin
   xoutval:='1';
   if (x.data<>'') and (xval<>'') then for p:=frcrange(strint(xval),1,length(x.data)) to length(x.data) do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') and (xchar.c=#10) then
      begin
      xoutval:=inttostr(p);
      break;
      end;//p
   end
//
//.find position in data stream from x,y coordinates (relative to current vpos/hpos)
else if (xcmd='paintline1') then
   begin
   xoutval:='0';
   if (x.vpos>=0) and (x.vpos<x.linecount) and (x.vpos<x.linesize) then xoutval:=inttostr(x.vpos);
   end
else if (xcmd='paintline2') then
   begin
   xoutval:='0';
   int2:=0;
   int1:=x.vpos;
   if (int1>=0) and (int1<x.linecount) and (int1<x.linesize) then
      begin
      for p:=int1 to frcmax(x.linecount-1,x.linesize-1) do
      begin
      if ((x.liney[p]+x.lineh[p]-x.liney[int1])<=x.viewheight) then int2:=p;
      end;//p
      end;//if
   xoutval:=inttostr(int2);
   end
//-- io streams ----------------------------------------------------------------
else if (xcmd='ioget') or (xcmd='ioget2') then//accepts "ioget,txt,txtwin/bwd/bwd#/bwp/bwp#,sel/all/<from><space><to>"
   begin
   //defaults
   e:=gecOutofmemory;
   //init
   xoutval:='';
   xmincheck;
   xlen:=length(x.data);
   dlen:=0;
   xmin:=1;
   xmax:=xlen;
   //.split multiple params
   int1:=1;
   int2:=0;
//02jun2020
   str1:=xval+#32;
//
   if (str1<>'') then for p:=1 to length(str1) do
      begin
      if (str1[p]=#32) then
         begin
         str2:=copy(str1,int1,p-int1);
         case int2 of
         0:xval:=str2;
         1:begin
            xmin:=frcrange(strint(str2),1,xlen);
            if (comparetext(str2,'sel')=0) then
               begin
               xmin:=xselstart;
               xmax:=xmin+frcmin(xselcount-1,0);//always 1 char or more
               break;
               end
            else if (comparetext(str2,'all')=0) then
               begin
               xmin:=1;
               xmax:=xlen;
               break;
               end;
            end;
         2:begin
            xmax:=frcrange(strint(str2),xmin,xlen);
            break;
            end;
         end;//case
         inc(int2);
         int1:=p+1;
         end;//if
      end;//p
   xsize:=xmax-xmin+1;

   //plain text "txt"
   if (comparetext(xval,'txt')=0) or (comparetext(xval,'txt#')=0) then//05jun2020
      begin
      //init
      setlength(xoutval,xsize);//pre-size for max speed
      //get
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') then
         begin
         inc(dlen);
         xoutval[dlen]:=xchar.c;
         end;//p
      //.finalise
      if (dlen<xsize) then setlength(xoutval,dlen);
      end
   //plain text "txtwin" -> Windows text (#13#10) - 14jul2020
   else if (comparetext(xval,'txtwin')=0) or (comparetext(xval,'txtwin#')=0) then//14jul2020
      begin
      //init
      setlength(xoutval,xsize);//pre-size for max speed
      //get
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') then
         begin
         //check size
         if ((dlen+2)>xsize) then
            begin
            inc(xsize,100000);//inc by 100K blocks -> for return codes only really - 14jul2020
            setlength(xoutval,xsize);//pre-size for max speed
            end;
         if (xchar.c=#10) then
            begin
            inc(dlen);
            xoutval[dlen]:=#13;
            end;
         inc(dlen);
         xoutval[dlen]:=xchar.c;
         end;//p
      //.finalise
      if (dlen<xsize) then setlength(xoutval,dlen);
      end
   //blaizwriter "bwd"
   else if (comparetext(xval,'bwd')=0) or (comparetext(xval,'bwd#')=0) then
      begin
      //init
      xonce:=true;
      xonce2:=true;
      setlength(str1,xsize);//pre-size for max speed
      setlength(str2,xsize);
      xfontname:='courier new';
      xfontsize:=12;
      xcolor:=0;//black
      xcolor2:=255;//red

      //.color info
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') then
         begin
         //font information - once only
         if xonce then
            begin
            xonce:=false;
            xfontname :=x.txtname[xchar.wid];
            xfontsize :=x.txtsize[xchar.wid];
            xcolor    :=x.txtcolor[xchar.wid];
            end;
         //.search for 2nd color -> if one is used
         if xonce2 and (xcolor<>x.txtcolor[xchar.wid]) then
            begin
            xonce2:=false;
            xcolor2   :=x.txtcolor[xchar.wid];
            break;//done
            end;
         if xonce2 and (xcolor<>x.txtbk[xchar.wid]) and (x.txtbk[xchar.wid]<>clnone) and (x.txtbk[xchar.wid]<>x.pagecolor) then
            begin
            xonce2:=false;
            xcolor2   :=x.txtbk[xchar.wid];
            break;//done
            end;
         end;//p

      //get
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') then
         begin
         inc(dlen);
         //text stream
         str1[dlen]:=xchar.c;
         //style stream
         int1:=0;
         if x.txtbold[xchar.wid] then inc(int1);//bold
         if x.txtitalic[xchar.wid] then inc(int1,2);//italic
         if x.txtunderline[xchar.wid] then inc(int1,4);//underline
         if x.txtstrikeout[xchar.wid] then inc(int1,8);//strikeout
         if (x.txtbk[xchar.wid]<>clnone) and (x.txtbk[xchar.wid]<>x.pagecolor) then inc(int1,16);//swap (highlight background)
         if (x.txtcolor[xchar.wid]<>xcolor) then inc(int1,32);//color2 (use color2, e.g. red)
         str2[dlen]:=char(int1);
         end;//p
      //.finalise
      if (dlen<xsize) then
         begin
         setlength(str1,dlen);
         setlength(str2,dlen);
         end;

      //set
      int1:=0;

      //.header
      if not xappendb(int1,xoutval,'BWD1','') then goto skipend;

      //.info -> include only the settings we can comfortably provide - BW will fill in the rest as needed - 04sep2019
      str3:=
       'landscape: 0'+rcode+
       'systemscheme: 0'+rcode+
       'wrapstyle: '+inttostr(low__aorb(1,2,x.pagewidth<>x.viewwidth))+rcode+//1=wrap to window, 2=wrap to page
       'fontname: '+xfontname+rcode+
       'fontsize: '+inttostr(xfontsize)+rcode+
       'fontcolor: '+inttostr(xcolor)+rcode+
       'fontcolor2: '+inttostr(xcolor2)+rcode+
       'fontstyle: 0'+rcode+
       'bgcolor: '+inttostr(x.pagecolor)+rcode;
      if not xappendb(int1,xoutval,'info',str3) then goto skipend;

      //.font - reserved for future use
      if not xappendb(int1,xoutval,'font','') then goto skipend;

      //.text
      if not xappend(int1,xoutval,'text',str1) then goto skipend;
      str1:='';//reduce ram

      //.styl
      if not xappend(int1,xoutval,'styl',str2) then goto skipend;
      str2:='';//reduce ram

      //.finalise
      if not xappendb(int1,xoutval,'','') then goto skipend;

      //.base64 for clipboard transport
      if (comparetext(xval,'bwd#')=0) then xoutval:='BWD#'+low__tob64b(xoutval,1000);//1,000c lines
      end
   //blaiz wordprocessor "bwp"
   else if (comparetext(xval,'bwp')=0) or (comparetext(xval,'bwp#')=0) then
      begin
      //init
      xoutval:='';
      int1:=0;
      //get

      //.header
      if not xappendb(int1,xoutval,'BWP1','') then goto skipend;

      //.info -> include only the settings we can comfortably provide - BW will fill in the reset as needed - 04sep2019
      str3:=
       'landscape: '+bn(x.landscape)+rcode+
       'systemscheme: 0'+rcode+
       'wrapstyle: '+inttostr(x.wrapstyle)+rcode+//xxxxxxxxxxxxxxx inttostr(low__aorb(1,2,x.pagewidth<>x.viewwidth))+rcode+//1=wrap to window, 2=wrap to page
       'bgcolor: '+inttostr(x.pagecolor)+rcode;
      if not xappendb(int1,xoutval,'info',str3) then goto skipend;

      //.data
      dlen:=0;
      setlength(str1,3*xsize);//pre-size for max speed
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) then
         begin
         inc(dlen,3);
         str1[dlen-2]:=x.data[p];
         str1[dlen-1]:=x.data2[p];
         str1[dlen-0]:=x.data3[p];
         end;
      if (dlen<length(str1)) then setlength(str1,dlen);//finalise
      if not xappend(int1,xoutval,'data',str1) then goto skipend;
      str1:='';//reduce ram

      //.list ------------------------------------------------------------------
      if not xappendb(int1,xoutval,'list','') then goto skipend;
      //init
      dlen:=0;
      str1:='';
      setlength(str2,imax+1); for p:=1 to (imax+1) do str2[p]:=#0;//track used "txt" items
      setlength(str3,imax+1); for p:=1 to (imax+1) do str3[p]:=#0;//track used "lgf" items - optional
      setlength(str4,imax+1); for p:=1 to (imax+1) do str4[p]:=#0;//track used "img" items

      //Include all used LGF fonts - optional (must use "ioget2")
      if (xcmd='ioget2') then
         begin
         for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) and (xchar.cs='t') then str3[1+xchar.txtid]:=#1;//mark as used
         //.f0..f999 -> store all "lgf" font snapshots that have been referred to -> optional -> allows viewing of document on platforms even without the original fonts (system independent viewing) - 04sep2019
         for p:=1 to length(str3) do if (str3[p]=#1) then
         begin
         if not xappendb(int1,xoutval,'begi','f'+inttostr(p-1)) then goto skipend;//begin
         //if not xappendb(int1,xoutval,'_fdn',x.lgfnref[p-1]) then goto skipend;//font name/size/style fast reference
         if (x.lgfdata[p-1]='') then low__wordcore__lgfFILL(x,p-1);//.lgfFILL -> fill regardless of dataonly mode
         if not xappendb(int1,xoutval,'_fds',x.lgfdata[p-1]) then goto skipend;//lgf datastream
         if not xappendb(int1,xoutval,'end!','') then goto skipend;//end
         end;//p
         end;//if

      //text & images
      for p:=xmin to xmax do if low__wordcore__charinfo(x,p,xchar) then
         begin
         //.t0..t999
         if (xchar.cs='t') and (str2[1+xchar.wid]=#0) then
            begin
            //mark as done
            str2[1+xchar.wid]:=#1;
            //init
            //.xint4
            xint4.val:=0;
            if x.txtbold[xchar.wid]      then xint4.chars[0]:=#1;
            if x.txtitalic[xchar.wid]    then xint4.chars[1]:=#1;
            if x.txtunderline[xchar.wid] then xint4.chars[2]:=#1;
            if x.txtstrikeout[xchar.wid] then xint4.chars[3]:=#1;
            //.xint4b
            xint4b.val:=0;
            xint4b.bytes[0]:=frcrange(x.txtalign[xchar.wid],0,x.c_alignmax);
            //get
            if not xappendb(int1,xoutval,'begi','t'+inttostr(xchar.wid)) then goto skipend;//begin
            if not xappendb(int1,xoutval,'_tid',from32bit(x.txtid[xchar.wid])) then goto skipend;//lgf index -> txtid
            if not xappendb(int1,xoutval,'_brc',from32bit(x.txtborder[xchar.wid])) then goto skipend;//border color
            if not xappendb(int1,xoutval,'_bkc',from32bit(x.txtbk[xchar.wid])) then goto skipend;//font background color
            if not xappendb(int1,xoutval,'_fcl',from32bit(x.txtcolor[xchar.wid])) then goto skipend;//font color
            if not xappendb(int1,xoutval,'_fsz',from32bit(x.txtsize[xchar.wid])) then goto skipend;//font size
            if not xappendb(int1,xoutval,'_fsy',from32bit(xint4.val)) then goto skipend;//font style
            if not xappendb(int1,xoutval,'_fs2',from32bit(xint4b.val)) then goto skipend;//font style2 (align)
            if not xappendb(int1,xoutval,'_fnm',x.txtname[xchar.wid]) then goto skipend;//font name
            if not xappendb(int1,xoutval,'end!','') then goto skipend;//end
            end
         //.i0..i999
         else if (xchar.cs='i') and (str4[1+xchar.wid]=#0) then
            begin
            //mark as done
            str4[1+xchar.wid]:=#1;
            //get
            if not xappendb(int1,xoutval,'begi','i'+inttostr(xchar.wid)) then goto skipend;//begin
//            if not xappendb(int1,xoutval,'_iid',from32bit(-1)) then goto skipend;//-1=directly points to image, 0..N=points to a copy of image (not in use yet)
//            if not xappendb(int1,xoutval,'_imw',from32bit(x.imgwidth[xchar.wid])) then goto skipend;//image width
//            if not xappendb(int1,xoutval,'_imh',from32bit(x.imgheight[xchar.wid])) then goto skipend;//image height
            if not  xappend(int1,xoutval,'_imd',x.imgdata[xchar.wid]) then goto skipend;//imdata datastream
            if not xappendb(int1,xoutval,'end!','') then goto skipend;//end
            end;//if
         end;//p
      if not xappendb(int1,xoutval,'lise','') then goto skipend;//list end

      //.finalise
      if not xappendb(int1,xoutval,'','') then goto skipend;

      //.base64 for clipboard transport
      if (comparetext(xval,'bwp#')=0) then xoutval:='BWP#'+low__tob64b(xoutval,1000);//1,000c lines
      end
   else
      begin
      showerror60('Wordcore: Unknown ioget directive "'+xval+'"');
      goto skipend;
      end;
   end

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//5555555555555555555555555555555555555
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxx twordcore xxxxxxxxxxxxxxxxxx
else if (xcmd='ioset') or (xcmd='ioins') then
   begin//Note: ioset=replace current content with new one, ioins=insert at cursorpos (deletes current selection)
   //defaults
   e:=gecOutofmemory;
   //init
   xmincheck;
   str1:='';
   str2:='';
   str3:='';
   xlen:=length(x.data);
   xfull:=(xcmd='ioset');
   if (xcmd='ioset') then low__wordcore(x,'clear','')
   else if (xcmd='ioins') then
      begin
      //delete existing selection
      if (xselcount>=1) then xdelsel2(xval='');//don't set "*_moveto" when inserting one or more characters - 02sep2019
      end;
   xnewcursorpos:=x.cursorpos;

   //get -----------------------------------------------------------------------
   //blaizwriter "bwd"
   if (xval<>'') and ( (comparetext(copy(xval,1,4),'bwd1')=0) or (comparetext(copy(xval,1,4),'bwd#')=0) ) then
      begin
      //init
      e:=gecUnknownformat;

      //decode from base64
      if (comparetext(copy(xval,1,4),'bwd#')=0) then
         begin
         delete(xval,1,4);
         xval:=low__fromb64b(xval);
         if (xval='') then goto skipend;
         end;
      int2:=1;

      //get
      //.header
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'BWD1')<>0) then goto skipend;
      v:='';

      //.info
      if (not xpull(int2,xval,n,str4)) or (comparetext(n,'info')<>0) then goto skipend;
      xfontname:=low__udv(low__varsvalue(str4,'fontname'),'arial');
      xfontsize:=frcrange(strint(low__udv(low__varsvalue(str4,'fontsize'),'12')),4,300);
      xcolor:=strint(low__udv(low__varsvalue(str4,'fontcolor'),'0'));//black
      xcolor2:=strint(low__udv(low__varsvalue(str4,'fontcolor2'),'255'));//red
      xbk:=strint(low__udv(low__varsvalue(str4,'bgcolor'),inttostr(rgb(255,255,255))));//white
      if xfull then x.pagecolor:=xbk;
      //..store reference info
      x.bwd_color:=xcolor;
      x.bwd_color2:=xcolor2;
      x.bwd_bk:=xbk;

      //.font
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'font')<>0) then goto skipend;
      v:='';

      //.text
      if (not xpull(int2,xval,n,str1)) or (comparetext(n,'text')<>0) then goto skipend;
      //.style
      if (not xpull(int2,xval,n,str4)) or (comparetext(n,'styl')<>0) then goto skipend;

      //filter out reserved chars
      if (str1<>'') then
         begin
         int4:=length(str1);
         int5:=length(str4);
         dlen:=0;
         for p:=1 to int4 do
         begin
         v1:=ord(str1[p]);
         if (v1=9) or (v1=10) or (v1>=32) then
            begin
            inc(dlen);
            if (dlen<int4) then str1[dlen]:=str1[p];
            if (dlen<int5) then str4[dlen]:=str4[p];
            end;
         end;//p
         //trim
         if (dlen<int4) then setlength(str1,dlen);//text
         if (dlen<int5) then setlength(str4,dlen);//style
         end;
      //init
      if (str1<>'') then
         begin
         setlength(str6,(imax+1)*sizeof(longint));
         xlist:=pointer(longint(str6));
         for p:=0 to imax do xlist[p]:=-1;//not set - track all font-style combinations -> allows us to quickly check if we need to create a new font
         int4:=length(str4);
         xval:='';//reduce ram
         setlength(str2,length(str1));
         setlength(str3,length(str1));
         //convert style stream
         for p:=1 to length(str1) do
         begin
         //.read the BWD1 style
         if (p<=int4) then i:=ord(str4[p]) else i:=0;
         //.make font
         if (xlist[i]=-1) then
            begin
            //read style
            int1:=i;
            xbold:=false;
            xitalic:=false;
            xunderline:=false;
            xstrikeout:=false;
            xswap:=false;
            xusecolor2:=false;
            //get
            if (int1>=128) then dec(int1,128);
            if (int1>=64) then dec(int1,64);
            if (int1>=32) then
               begin
               xusecolor2:=true;
               dec(int1,32);
               end;
            if (int1>=16) then
               begin
               xswap:=true;
               dec(int1,16);
               end;
            if (int1>=8) then
               begin
               xstrikeout:=true;
               dec(int1,8);
               end;
            if (int1>=4) then
               begin
               xunderline:=true;
               dec(int1,4);
               end;
            if (int1>=2) then
               begin
               xitalic:=true;
               dec(int1,2);
               end;
            if (int1>=1) then
               begin
               xbold:=true;
               dec(int1,1);
               end;
            //create font
            if xusecolor2 and xswap then
               begin
               v1:=xbk;
               v2:=xcolor2;
               end
            else if xswap then
               begin
               v1:=xbk;
               v2:=xcolor;
               end
            else if xusecolor2 then
               begin
               v1:=xcolor2;
               v2:=clnone;
               end
            else
               begin
               v1:=xcolor;
               v2:=clnone;
               end;
            xlist[i]:=xmakefont2(true,'',xfontname,xfontsize,v1,v2,clnone,xbold,xitalic,xunderline,xstrikeout,0);
            end;//i

         //.apply font
         wrd2.val:=xlist[i];//id that points to text-font
         str2[p]:=wrd2.chars[0];
         str3[p]:=wrd2.chars[1];
         end;//p
         end;//str1
      end
   //blaiz wordprocessor "bwp"
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//55555555555555555555555555
   else if (xval<>'') and ( (comparetext(copy(xval,1,4),'bwp1')=0) or (comparetext(copy(xval,1,4),'bwp#')=0) ) then
      begin
      //init
      e:=gecUnknownformat;

      //decode from base64
      if (comparetext(copy(xval,1,4),'bwp#')=0) then
         begin
         delete(xval,1,4);
         xval:=low__fromb64b(xval);
         if (xval='') then goto skipend;
         end;
      int2:=1;
      setlength(str6,(imax+1)*sizeof(longint));
      xlist:=pointer(longint(str6));
      for p:=0 to imax do xlist[p]:=p;//1-to-1 mapping to start with -> used to merge inbound items with current items (when ioins etc) -> e.g. image99 "i99" might map to "i303", therefore all inbound x.wid[]'s "part1&2" must be changed from i99 to i303 to reflect the changes - 05sep2019

      //get
      //.header
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'BWP1')<>0) then goto skipend;
      v:='';

      //.info -> include only the settings we can comfortably provide - BW will fill in the reset as needed - 04sep2019
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'info')<>0) then goto skipend;
      if xfull then
         begin
         x.landscape:=(strint(low__varsvalue(v,'landscape'))<>0);
         x.wrapstyle:=frcrange(strint(low__udv(low__varsvalue(v,'wrapstyle'),'2')),0,2);
         x.pagecolor:=strint(low__udv(low__varsvalue(v,'bgcolor'),inttostr(rgb(255,255,255))));//white
         end;

      //.data
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'data')<>0) then goto skipend;
      int1:=length(v) div 3;
      if (int1>=1) then
         begin
         //init
         setlength(str1,int1);
         setlength(str2,int1);
         setlength(str3,int1);
         //get
         for p:=1 to int1 do
         begin
         int3:=(p*3)-2;
         str1[p]:=v[int3+0];//text
         //.wid's "part1&2" may need to be remapped further down
         str2[p]:=v[int3+1];//id.part1
         str3[p]:=v[int3+2];//id.part2
         end;//p
         end;//if

      //.list ------------------------------------------------------------------
      //Special Note: any stored LGF fonts will be first in the list
      //init
      if (not xpull(int2,xval,n,v)) or (comparetext(n,'list')<>0) then goto skipend;
      setlength(str6,(imax+1)*sizeof(longint));
      setlength(str5,(imax+1)*sizeof(longint));
      xlist:=pointer(longint(str6));
      xlisti:=pointer(longint(str5));
      for p:=0 to imax do
      begin
      xlist[p]:=p;//use to "remap" incoming resources to target slots in resource cache
      xlisti[p]:=p;
      xlist2[p]:='';//use to temp-store any included LGF fonts
      end;
      //get
      str4:='';
      int4:=0;
      while true do
      begin
      if not xpull(int2,xval,n,v) then break;//don't raise error -> attempt to continue
      //.begin
      if (n='lise') then break//list end
      else if (n='begi') then
         begin
         str4:=copy(v,1,1);//"t"(text) or "i"(image) or "f"(LGF font - optional)
         int4:=xsafe(strint(copy(v,2,length(v))));
         //.text defaults
         xid:=0;
         xborder:=clnone;
         xbk:=clnone;
         xcolor:=0;
         xfontsize:=12;
         xfontname:='arial';
         xbold:=false;
         xitalic:=false;
         xunderline:=false;
         xstrikeout:=false;
         xalign:=x.c_alignleft;//left
         //.image defaults
         ximgdata:='';
         end
      //.font values
      else if (n='_fds') then xlist2[int4]:=v//these are done first before any text, so they can be temp-stored in "xlist2" for access with text values
      //.text values
      else if (n='_tid') then xid:=xsafe(to32bit(copy(v,1,4)))
      else if (n='_brc') then xborder:=to32bit(copy(v,1,4))
      else if (n='_bkc') then xbk:=to32bit(copy(v,1,4))
      else if (n='_fcl') then xcolor:=to32bit(copy(v,1,4))
      else if (n='_fsz') then xfontsize:=frcrange(to32bit(copy(v,1,4)),4,300)
      else if (n='_fsy') then
         begin
         xint4.val  :=to32bit(copy(v,1,4));
         xbold      :=(xint4.chars[0]<>#0);
         xitalic    :=(xint4.chars[1]<>#0);
         xunderline :=(xint4.chars[2]<>#0);
         xstrikeout :=(xint4.chars[3]<>#0);
         end
      else if (n='_fs2') then
         begin
         xint4.val  :=to32bit(copy(v,1,4));
         xalign     :=frcrange(xint4.bytes[0],0,x.c_alignmax);
         end
      else if (n='_fnm') then xfontname:=low__udv(v,'arial')
      //.image values
      else if (n='_imd') then ximgdata:=v
      //.finalise
      else if (n='end!') then
         begin
         if (str4='t') then
            begin
            xlist[int4]:=xmakefont2(true,xlist2[xid],xfontname,xfontsize,xcolor,xbk,xborder,xbold,xitalic,xunderline,xstrikeout,xalign);
            end
         else if (str4='i') then
            begin
            xlisti[int4]:=xmakeimage2(ximgdata);
            ximgdata:='';//reduce ram
            end;
         end;
      end;//loop

      //Remap All Inbound Resource IDS to their new values ---------------------
      //Special Note: Both (t)ext and (i)mages can use the same id range (0..999)
      //              but they don't overlap with their values, as each text/image
      //              has it's own dedicated stack of values.
      if (str1<>'') then for p:=1 to length(str1) do
         begin
         str4:=xstyle(str1[p]);
         wrd2.chars[0]:=str2[p];
         wrd2.chars[1]:=str3[p];
         wrd2.val:=xsafe(wrd2.val);
         if (str4='t') then
            begin
            //.id has been remapped -> write new id
            if (wrd2.val<>xlist[wrd2.val]) then
               begin
               wrd2.val:=xlist[wrd2.val];
               str2[p]:=wrd2.chars[0];
               str3[p]:=wrd2.chars[1];
               end;
            end
         else if (str4='i') then
            begin
            //.id has been remapped -> write new id
            if (wrd2.val<>xlisti[wrd2.val]) then
               begin
               wrd2.val:=xlisti[wrd2.val];
               str2[p]:=wrd2.chars[0];
               str3[p]:=wrd2.chars[1];
               end;
            end;
         end;
      end
   //assume data is plain text "txt"
   else if (xval<>'') then
      begin
      //init
      str1:=xval;
      xval:='';
      low__wordcore__filtertext(str1);
      int1:=length(str1);
      if (int1>=1) then
         begin
         //init
         wrd2.val:=xmakefont;
         setlength(str2,int1);
         setlength(str3,int1);
         //get
         for p:=1 to int1 do
         begin
         str2[p]:=wrd2.chars[0];
         str3[p]:=wrd2.chars[1];
         end;//p
         end;//int1
      end;

   //set -> insert the 3 streams and update ---------------------------------
   if (str1<>'') then
      begin
      xmincheck;
      int1:=length(x.data);
      int2:=x.cursorpos;
      insert(str1,x.data ,int2);
      insert(str2,x.data2,int2);
      insert(str3,x.data3,int2);
      xmincheck;
      //.trim trailing second #10 -> prevents continuous appending of a single #10 each time "ioset" is called - 29feb2020
      if (xcmd='ioset') and (length(x.data)>=2) and (copy(x.data,length(x.data)-1,2)=(#10#10)) then
         begin
         int3:=length(x.data);
         delete(x.data,int3,1);
         delete(x.data2,int3,1);
         delete(x.data3,int3,1);
         end;
      //.sync
      if (xcmd<>'ioset') then xsetcursorpos(int2+length(str1));
      xwrapadd(xlinebefore(int2),int2+length(str1)+x.c_pagewrap);
      x.timer_chklinecursorx:=true;
      xchanged;
      end;
   end
else
   begin
   showerror60('Wordcore: Unknown command "'+xcmd+'"');
   goto skipend;
   end;
//successful
skipdone:
result:=true;
skipend:
except;end;
try
if xmusttimerunbusy then x.timerbusy:=false;
except;end;
end;

//## LGF font support ##########################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//fffffffffffffffffffffffffffff
//-- low level support for special image formats -------------------------------
//## low__toLGF2 ##
function low__toLGF2(xfontname:string;xfontsize:longint;xbold:boolean;var xdata,e:string):boolean;
var
   s:tstr8;
begin
try
result:=false;
xdata:='';
s:=newstr8(0);
if low__toLGF(xfontname,xfontsize,xbold,s,e) then
   begin
   e:=gecOutofmemory;
   xdata:=s.text;
   result:=true;
   end;
except;end;
try;freeobj(@s);except;end;
end;
//## low__toLGF2b ##
function low__toLGF2b(xfontname:string;xfontsize:longint;xbold:boolean):string;
var
   e:string;
begin
try;low__toLGF2(xfontname,xfontsize,xbold,result,e);except;end;
end;
//## low__toLGF ##
function low__toLGF(xfontname:string;xfontsize:longint;xbold:boolean;xdata:tstr8;var e:string):boolean;
label//LGF - linear Graphic Font (all chars as a horizontal image strip)
     //Optimisations: "Courier New/300pt" took: 4,000ms -> now 1,000ms (4x faster)
   detect16,detect32,skipunderline,skipdone,skipend;
const
   xmaxsize  =65532;//nearest block of 6px (12b)
   xblackok  =25;//25 or less
type
   tcolor96=packed record v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11:byte;end;//12b => 6px for 15/16bit image - 19apr2020
   pcolorrow96=^tcolorrow96;tcolorrow96=array[0..(maxint div 48)] of tcolor96;
   pcolorrows96=^tcolorrows96;tcolorrows96=array[0..maxrow] of pcolorrow96;
var
   a:tbmp;
   dbuffer:tstr8;
   dlen:longint;
   wrd2:twrd2;
   int4:tint4;
   //scan support
   xleft,xright,dw3,dw6,i,tw,sx,sy,p,xlen,xpad,int1,int2,dbufferlen,xcount:longint;//-1=not set, 0..127=>1..128 | any value over 127 indicates non-transparent pixel
   awcount3,awcount6,abits,aw,ah:longint;
   ac96:tcolor96;
   xwh:tpoint;
   xmaxw,xmaxh,xmaxh1:longint;
   xrows8:pcolorrows8;
   xrows24:pcolorrows24;
   xrows32:pcolorrows32;
   xrowsmem:string;
   ar32:pcolorrow32;
   ar96:pcolorrow96;
   dx,dy:longint;
   xlocked,xcounton,bol2,bol1,dyok:boolean;
   xws:array[0..255] of longint;
   //## xround3 ##
   function xround3(x:longint):longint;//32bit = 3 pixel blocks
   begin
   result:=x;
   if (((result div 3)*3)<>x) then result:=((x div 3)+1)*3;//round up to nearest 3 pixels
   end;
   //## xround6 ##
   function xround6(x:longint):longint;//16bit = 6 pixel blocks
   begin
   result:=x;
   if (((result div 6)*6)<>x) then result:=((x div 6)+1)*6;//round up to nearest 6 pixels
   end;
   //## xfirstset ##
   function xfirstset(bol2:boolean):boolean;
   begin
   result:=true;
   xcounton:=bol2;
   inc(dlen);
   if xcounton then dbuffer.pbytes[dlen-1]:=1 else dbuffer.pbytes[dlen-1]:=0;//start solid "#1" or transparent "#0"
   end;
begin
try
//defaults
result:=false;
e:=gecTaskfailed;
xlocked:=false;
a:=nil;
dbuffer:=nil;
xlen:=0;
//check
if (xdata=nil) then exit else xdata.clear;

//xxxxxxxxxxxxxxxxxxxxxx//???????????????//D10: No working support for text capture yet
{$ifdef a32}
result:=true;
xdata.aadd(sysfont__arial_8);
exit;//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//??????????????????????????
{$endif}


//range
if (xfontname='') then xfontname:='arial';
if (xfontsize>=0) then xfontsize:=frcmin(xfontsize,4);//allow a negative range which specifies fontsize via height in pixels - 11apr2020

//init
aw:=1;
ah:=1;
a:=misbmp(16,1,1);//ask for 16, but may get 32
abits:=misb(a);
misset_brushcolor(a,low__rgb(255,255,255));//Special Note: "a.canvas.brush.style=bsclear" produces unreliable and scrambled results - DO NOT USE - 17apr2020
misset_fontcolor(a,0);//black font color
misset_fontname(a,xfontname);
if (xfontsize>=0) then misset_fontsize(a,xfontsize) else misset_fontheight(a,-xfontsize);
misset_fontstyle(a,xbold,false,false,false);
//init
xmaxw:=1;
xmaxh:=1;
xmaxh1:=1;//use A-D (no drop parts like "Q" has)
//get
for p:=0 to 255 do
begin
xwh:=misset_textextent(a,char(p));
if (xwh.x<1) then xwh.x:=1 else if (xwh.x>xmaxsize) then xwh.x:=xmaxsize;//1..65532
if (xwh.y<1) then xwh.y:=1 else if (xwh.y>xmaxsize) then xwh.y:=xmaxsize;//1..65532
if (xwh.x>xmaxw) then xmaxw:=xwh.x;
if (xwh.y>xmaxh) then xmaxh:=xwh.y;
xws[p]:=xwh.x;
end;//p

//-- Scan font characters ------------------------------------------------------
//size
xpad     :=frcrange(round(xmaxw*0.1),2,20);//widen capture area to allow for left/right boundary overlap detection - 20apr2020
case abits of
16:begin
   aw       :=frcrange(xround6(xmaxw+(2*xpad)),1,xmaxsize);
   awcount6 :=aw div 6;
   end;
32:begin
   aw       :=frcrange(xround3(xmaxw+(2*xpad)),1,xmaxsize);
   awcount3 :=aw div 3;
   end;
end;//case
ah       :=frcrange(xmaxh,1,xmaxsize);
missize(a,aw,ah);
a.sharp:=true;//don't change dimensions of "a" from this point on - 16apr2020
//.size databuffer
dbuffer:=newstr8(aw*ah);
dbufferlen:=dbuffer.len;
//cache 16bit rows
if not a.lock then goto skipend;
xrows24:=a.prows24;
//header -> now supports dual data streams: normal and bold for a total of 512 combined stored characters - 17apr2020
xlen:=1544;
xdata.setlen(xlen);
xdata.pbytes[0]:=71;//G - header (0..3)
xdata.pbytes[1]:=70;//F
xdata.pbytes[2]:=35;//#
xdata.pbytes[3]:=51;//3 - version 3.0
//.store height in header (4..5) -> overal height
wrd2.val:=xmaxh;
xdata.pbytes[4]:=wrd2.bytes[0];
xdata.pbytes[5]:=wrd2.bytes[1];
//.store height1 in header (6..7) -> distance from top to baseline
wrd2.val:=xmaxh1;//write actual/final value later
xdata.pbytes[6]:=wrd2.bytes[0];
xdata.pbytes[7]:=wrd2.bytes[1];
//decide
case abits of
16:goto detect16;
32:goto detect32;
else goto skipend;
end;

//detect16 -> all characters (rapid run-length compression) --------------------
detect16:
for p:=0 to 255 do
begin
//.cls entire area of "a" + draw char indented by "xpad" from left to allow boundary overlap scanning - 20apr2020
mis_textrect(a,misrect(0,0,aw,ah),xpad,0,char(p));
tw:=xws[p];
//.detect left + right boundaries ----------------------------------------------
xleft:=xpad;
xright:=xleft+tw-1;
dw6:=frcrange((xpad div 6)+1,0,awcount6);//scan upto the start of the char or slightly inside
for sy:=0 to (xmaxh-1) do
begin
tpointer(ar96):=tpointer(@xrows24[sy]^);

//.detect left boundary
sx:=-1;
for dx:=0 to (dw6-1) do
begin
ac96:=ar96[dx];//6 pixels at once
//.v0
inc(sx);
if (sx<xleft) and (ac96.v0<=xblackok) then xleft:=sx;
//.v2
inc(sx);
if (sx<xleft) and (ac96.v2<=xblackok) then xleft:=sx;
//.v4
inc(sx);
if (sx<xleft) and (ac96.v4<=xblackok) then xleft:=sx;
//.v6
inc(sx);
if (sx<xleft) and (ac96.v6<=xblackok) then xleft:=sx;
//.v8
inc(sx);
if (sx<xleft) and (ac96.v8<=xblackok) then xleft:=sx;
//.v10
inc(sx);
if (sx<xleft) and (ac96.v10<=xblackok) then xleft:=sx;
end;//dx

//.detect right boundary
sx:=aw;
for dx:=(awcount6-1) downto (awcount6-1-dw6) do
begin
ac96:=ar96[dx];//6 pixels at once
//.v10
dec(sx);
if (ac96.v10<=xblackok) and (sx>=xright) then xright:=sx;
//.v8
dec(sx);
if (ac96.v8<=xblackok) and (sx>=xright) then xright:=sx;
//.v6
dec(sx);
if (ac96.v6<=xblackok) and (sx>=xright) then xright:=sx;
//.v4
dec(sx);
if (ac96.v4<=xblackok) and (sx>=xright) then xright:=sx;
//.v2
dec(sx);
if (ac96.v2<=xblackok) and (sx>=xright) then xright:=sx;
//.v0
dec(sx);
if (ac96.v0<=xblackok) and (sx>=xright) then xright:=sx;
end;//dx
end;//dy

//.init for capture
tw:=frcmin((xright-xleft+1),tw);//actual width used -> never go below reported width
xright:=xleft+tw-1;
wrd2.val:=tw;
int4.val:=xlen;
i:=8+(p*6);
xdata.pbytes[i+0]:=wrd2.bytes[0];//character width
xdata.pbytes[i+1]:=wrd2.bytes[1];
xdata.pbytes[i+2]:=int4.bytes[0];//character data start position
xdata.pbytes[i+3]:=int4.bytes[1];
xdata.pbytes[i+4]:=int4.bytes[2];
xdata.pbytes[i+5]:=int4.bytes[3];
//.write pixel sets to datastream -> 16bit -> 1bit converter -> RLE compressor
xcount:=0;
xcounton:=false;
dlen:=0;
int1:=xleft+tw;
dw6:=int1 div 6;
if ((dw6*6)<int1) then inc(dw6);
dw6:=frcrange(dw6,0,awcount6);

for sy:=0 to (xmaxh-1) do
begin
tpointer(ar96):=tpointer(@xrows24[sy]^);
bol1:=false;

//.enlarge
if ((dlen+(aw*4))>=dbufferlen) then//over-estimated size of buffer should this row need excessive space - worse case and then some - 20apr2020
   begin
   dbuffer.minlen(dbufferlen+(aw*ah));
   dbufferlen:=dbuffer.len;
   end;

//.first
if (sy=0) then
   begin
   sx:=-1;
   for dx:=0 to (dw6-1) do
   begin
   ac96:=ar96[dx];//6 pixels at once
   //.v0
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v0<=xblackok) then break;
   //.v2
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v2<=xblackok) then break;
   //.v4
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v4<=xblackok) then break;
   //.v6
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v6<=xblackok) then break;
   //.v8
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v8<=xblackok) then break;
   //.v10
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v10<=xblackok) then break;
   end;//dx
   end;//first

sx:=-1;
for dx:=0 to (dw6-1) do
begin
ac96:=ar96[dx];//6 pixels at once

//.v0
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v0<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v2
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v2<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v4
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v4<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v6
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v6<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v8
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v8<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v10
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v10<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;
end;//dx

//.xmaxh1 -> only for chars "A,B,C and D"
if (p>=65) and (p<=68) and bol1 and (sy>=xmaxh1) then xmaxh1:=sy+1;
end;//sy

//.finish character
if (xcount>=1) then
   begin
   //.3byte datablock => 128..8,388,608
   if (xcount>128) then
      begin
      //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
      dec(xcount);
      //b1 -> (0-127) + (128/mark as 3byte data block)
      int1:=xcount div 65536;
      inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
      dec(xcount,int1*65536);
      //b2
      int1:=xcount div 256;
      inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
      dec(xcount,int1*256);
      //b3
      inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
      end
   //.1byte datablock => 1..128 (0..127)
   else
      begin
      inc(dlen);
      dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
      end;
   end;

//.finalise character -> updates "xlen" ready for next character to be tracked and stored - 21aug2019
if (dlen>=1) then
   begin
   xdata.add2(dbuffer,0,dlen-1);
   xlen:=xdata.count;
   end;
end;//p
//.done
goto skipdone;


//detect32 -> all characters (rapid run-length compression) --------------------
detect32:
for p:=0 to 255 do
begin
//.cls entire area of "a" + draw char indented by "xpad" from left to allow boundary overlap scanning - 20apr2020
mis_textrect(a,misrect(0,0,aw,ah),xpad,0,char(p));
tw:=xws[p];
//.detect left + right boundaries ----------------------------------------------
xleft:=xpad;
xright:=xleft+tw-1;
dw3:=frcrange((xpad div 3)+1,0,awcount3);//scan upto the start of the char or slightly inside
for sy:=0 to (xmaxh-1) do
begin
tpointer(ar96):=tpointer(@xrows24[sy]^);

//.detect left boundary
sx:=-1;
for dx:=0 to (dw3-1) do
begin
ac96:=ar96[dx];//3 pixels at once
//.v1
inc(sx);
if (sx<xleft) and (ac96.v1<=xblackok) then xleft:=sx;
//.v5
inc(sx);
if (sx<xleft) and (ac96.v5<=xblackok) then xleft:=sx;
//.v9
inc(sx);
if (sx<xleft) and (ac96.v9<=xblackok) then xleft:=sx;
end;//dx

//.detect right boundary
sx:=aw;
for dx:=(awcount3-1) downto (awcount3-1-dw3) do
begin
ac96:=ar96[dx];//3 pixels at once
//.v9
dec(sx);
if (ac96.v9<=xblackok) and (sx>=xright) then xright:=sx;
//.v5
dec(sx);
if (ac96.v5<=xblackok) and (sx>=xright) then xright:=sx;
//.v1
dec(sx);
if (ac96.v1<=xblackok) and (sx>=xright) then xright:=sx;
end;//dx
end;//dy

//.init for capture
tw:=frcmin((xright-xleft+1),tw);//actual width used -> never go below reported width
xright:=xleft+tw-1;
wrd2.val:=tw;
int4.val:=xlen;
i:=8+(p*6);
xdata.pbytes[i+0]:=wrd2.bytes[0];//character width
xdata.pbytes[i+1]:=wrd2.bytes[1];
xdata.pbytes[i+2]:=int4.bytes[0];//character data start position
xdata.pbytes[i+3]:=int4.bytes[1];
xdata.pbytes[i+4]:=int4.bytes[2];
xdata.pbytes[i+5]:=int4.bytes[3];
//.write pixel sets to datastream -> 16bit -> 1bit converter -> RLE compressor
xcount:=0;
xcounton:=false;
dlen:=0;
int1:=xleft+tw;
dw3:=int1 div 3;
if ((dw3*3)<int1) then inc(dw3);
dw3:=frcrange(dw3,0,awcount3);

for sy:=0 to (xmaxh-1) do
begin
tpointer(ar96):=tpointer(@xrows24[sy]^);
bol1:=false;

//.enlarge
if ((dlen+(aw*4))>=dbufferlen) then//over-estimated size of buffer should this row need excessive space - worse case and then some - 20apr2020
   begin
   dbuffer.minlen(dbufferlen+(aw*ah));
   dbufferlen:=dbuffer.len;
   end;

//.first
if (sy=0) then
   begin
   sx:=-1;
   for dx:=0 to (dw3-1) do
   begin
   ac96:=ar96[dx];//3 pixels at once
   //.v1
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v1<=xblackok) then break;
   //.v5
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v5<=xblackok) then break;
   //.v9
   inc(sx);
   if (sx>=xleft) and xfirstset(ac96.v9<=xblackok) then break;
   end;//dx
   end;//first

sx:=-1;
for dx:=0 to (dw3-1) do
begin
ac96:=ar96[dx];//3 pixels at once

//.v1
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v1<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v5
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v5<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;

//.v9
inc(sx);
if (sx>=xleft) and (sx<=xright) then
   begin
   bol2:=(ac96.v9<=xblackok);
   if bol2 then bol1:=true;
   //.store the difference
   if (bol2<>xcounton) then
      begin
      //.3byte datablock => 128..8,388,608
      if (xcount>128) then
         begin
         //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
         dec(xcount);
         //b1 -> (0-127) + (128/mark as 3byte data block)
         int1:=xcount div 65536;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
         dec(xcount,int1*65536);
         //b2
         int1:=xcount div 256;
         inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
         dec(xcount,int1*256);
         //b3
         inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
         end
      //.1byte datablock => 1..128 (0..127)
      else
         begin
         inc(dlen);
         dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
         end;
      //reset
      xcount:=1;
      xcounton:=bol2;
      end
   else inc(xcount);
   end;
end;//dx

//.xmaxh1 -> only for chars "A,B,C and D"
if (p>=65) and (p<=68) and bol1 and (sy>=xmaxh1) then xmaxh1:=sy+1;
end;//sy

//.finish character
if (xcount>=1) then
   begin
   //.3byte datablock => 128..8,388,608
   if (xcount>128) then
      begin
      //one based to zero based -> (129..8,388,608) -> (128..8,388,607)
      dec(xcount);
      //b1 -> (0-127) + (128/mark as 3byte data block)
      int1:=xcount div 65536;
      inc(dlen);dbuffer.pbytes[dlen-1]:=int1+128;
      dec(xcount,int1*65536);
      //b2
      int1:=xcount div 256;
      inc(dlen);dbuffer.pbytes[dlen-1]:=int1;
      dec(xcount,int1*256);
      //b3
      inc(dlen);dbuffer.pbytes[dlen-1]:=xcount;
      end
   //.1byte datablock => 1..128 (0..127)
   else
      begin
      inc(dlen);
      dbuffer.pbytes[dlen-1]:=xcount-1;//1..128 => 0..127 (mark as single byte datablock)
      end;
   end;

//.finalise character -> updates "xlen" ready for next character to be tracked and stored - 21aug2019
if (dlen>=1) then
   begin
   xdata.add2(dbuffer,0,dlen-1);
   xlen:=xdata.count;
   end;
end;//p
//.done
goto skipdone;


//finalise ---------------------------------------------------------------------
skipdone:
//.store height1 in header (7..8) -> distance from top to baseline
wrd2.val:=frcmin(xmaxh1,0);
xdata.pbytes[6]:=wrd2.bytes[0];
xdata.pbytes[7]:=wrd2.bytes[1];

//.finalise
xdata.aadd([0,0,0]);//include 3 trailing padding bytes -> helps to simplify and speed up decoder
xdata.setlen(xdata.count);

//successful
result:=true;
skipend:
except;end;
try;freeobj(@a);except;end;
end;
//## low__fromLGF_height ##
function low__fromLGF_height(var xdata:string):longint;
var
   wrd2:twrd2;
begin
try
result:=0;
if (length(xdata)>=1544) then
   begin
   wrd2.chars[0]:=xdata[5];
   wrd2.chars[1]:=xdata[6];
   result:=wrd2.val;
   end;
except;end;
end;
//## low__fromLGF_height1 ##
function low__fromLGF_height1(var xdata:string):longint;
var
   wrd2:twrd2;
begin
try
result:=0;
if (length(xdata)>=1544) then
   begin
   wrd2.chars[0]:=xdata[7];
   wrd2.chars[1]:=xdata[8];
   result:=wrd2.val;
   end;
except;end;
end;
//## low__fromLGF_charw ##
function low__fromLGF_charw(var xdata:string;xindex:longint):longint;
var
   wrd2:twrd2;
   int4:tint4;
   i:longint;
begin
try
result:=0;
if (length(xdata)>=1544) then
   begin
   //range
   if (xindex<0) then xindex:=0 else if (xindex>255) then xindex:=255;
   //get
   i:=9+(xindex*6);
   wrd2.chars[0]:=xdata[i+0];//character width
   wrd2.chars[1]:=xdata[i+1];
   result:=wrd2.val;
   end;
except;end;
end;
//## low__fromLGF_textwidth ##
function low__fromLGF_textwidth(var xdata:string;xtext:string):longint;
var
   p:longint;
begin
try
//defaults
result:=0;
//check
if (xdata='') or (xtext='') then exit;
//get
for p:=1 to length(xtext) do inc(result,low__fromLGF_charw(xdata,ord(xtext[p])));
except;end;
end;
//## low__fromLGF_drawchar2432 ##
function low__fromLGF_drawchar2432(x:string;xindex,ax,ay,aw,ah,dcolor:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;xmask:tmask8;xmaskval:longint;var xfc:string;xfeather:longint;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;//23jan2020
label//Note: xfeather: minint..0=off, 1=mild(LR only), 2=strong(LR+TB)
   drawmasked24,drawmasked32,draw24,draw32,skipdone,skipend;
var//Ultra-rapid, real-time, linear graphic font character drawing system
   //Speed Test1: 5500 characters on a 1250w x 750h screen using "Arial 12/feather=off" in 30-60ms on an Intel Atom 1.44GHz CPU - 21aug2019
   //Speed Test2: 5500 characters on a 1250w x 750h screen using "Arial 12/feather=1" in 156-172ms (50-30ms faster feather) on an Intel Atom 1.44GHz CPU - 17apr2020
   //afc = feather cache (used to draw realtime feather) - 21sep2019
   mr8:pcolorrows8;
   wrd2:twrd2;
   int4:tint4;
   dc24:tcolor24;
   dc32:tcolor32;
   p,i,xcount,c,r,g,b,fi1,fi2,fi,int1,int2,xlen,xpos,xstop,sx,sy,dx,dy,dx2,tw,th,th1:longint;
   xbold1,xbold2,ybold1,ybold2,xunderline1,xunderline2,xstrikeout1,xstrikeout2:longint;
   bol1,xcounton,dunderline,dstrikeout:boolean;
begin
try
//defaults
result:=false;
//check
xlen:=length(x);
if ((ar24=nil) and (ar32=nil)) or (xlen<1544) then exit;
//range
if (xindex<0) then xindex:=0 else if (xindex>255) then xindex:=255;
//check mask
if (xmaskval>=0) then
   begin
   if (xmask=nil) or ((xmask.width<aw) or (xmask.height<ah)) then xmaskval:=-1;//off
   if (xmaskval>=0) then mr8:=xmask.prows8;
   end;
//init
//.th
wrd2.bytes[0]:=byte(x[5]);//a.pbytes[4];
wrd2.bytes[1]:=byte(x[6]);//a.pbytes[5];
th:=wrd2.val;
//.th1
wrd2.bytes[0]:=byte(x[7]);//a.pbytes[6];
wrd2.bytes[1]:=byte(x[8]);//a.pbytes[7];
th1:=wrd2.val;
//.tw
i:=8+(xindex*6);
wrd2.bytes[0]:=byte(x[i+1]);//a.pbytes[i+0];//character width (2/6)
wrd2.bytes[1]:=byte(x[i+2]);//a.pbytes[i+1];
tw:=wrd2.val;
//.xpos
int4.bytes[0]:=byte(x[i+3]);//a.pbytes[i+2];//character data start position (4/6)
int4.bytes[1]:=byte(x[i+4]);//a.pbytes[i+3];
int4.bytes[2]:=byte(x[i+5]);//a.pbytes[i+4];
int4.bytes[3]:=byte(x[i+6]);//a.pbytes[i+5];
xpos:=int4.val+1;
//check
if (tw<1) or (th<1) or (xpos<1) then goto skipend;
//range
if (acliparea.left<0) then acliparea.left:=0 else if (acliparea.left>=aw) then acliparea.left:=aw-1;
if (acliparea.right<0) then acliparea.right:=0 else if (acliparea.right>=aw) then acliparea.right:=aw-1;
if (acliparea.top<0) then acliparea.top:=0 else if (acliparea.top>=ah) then acliparea.top:=ah-1;
if (acliparea.bottom<0) then acliparea.bottom:=0 else if (acliparea.bottom>=ah) then acliparea.bottom:=ah-1;
//init
//.feather cache
int1:=tw*th;
if (xfeather>=1) then
   begin
   if (int1>length(xfc)) then setlength(xfc,2*int1);//over-allow -> faster for next char that requires more data
   end;
//.effects
if xunderline then//17apr2020
   begin
   xunderline1:=ay+frcmax(th1+1,th-1);
   xunderline2:=ay+frcmax(th1+frcmin(trunc(th*0.06),1),th-1);
   end;
if xstrikeout then//17apr2020
   begin
   int1:=round(th1*0.3);
   xstrikeout1:=ay+frcmin(th1-int1-trunc(th*0.04),0);
   xstrikeout2:=ay+frcmin(th1-int1,0);
   end;
if xbold then//18apr2020
   begin
   xbold1:=frcrange(trunc(th*0.03),0,10);
   xbold2:=frcrange(trunc(th*0.03),1,10);
   ybold1:=frcrange(trunc(th*0.03),0,10);
   ybold2:=frcrange(trunc(th*0.03),0,10);
   //.must clear feather cache for bold -> since overlapping pixels are wiped out from normal feather tracking - 18apr2020
   if (xfeather>=1) and (xfc<>'') then for p:=length(xfc) downto 1 do xfc[p]:=#0;
   end;
//get
int4.val:=dcolor;
if      (ar32<>nil) then
   begin
   if (xmaskval>=0) then goto drawmasked32 else goto draw32;
   end
else if (ar24<>nil) then
   begin
   if (xmaskval>=0) then goto drawmasked24 else goto draw24;
   end
else goto skipend;

//-- draw32 --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ddddddddddddddddddddddddddddddddddddd
draw32:
dc32.r:=int4.r;
dc32.g:=int4.g;
dc32.b:=int4.b;
dc32.a:=255;
//.start style
xcount:=0;
xcounton:=false;
if (xpos<=xlen) then
   begin
//   xcounton:=(a.pbytes[xpos-1]=0);//invert to start with
   xcounton:=(x[xpos-0]=#0);//invert to start with
   inc(xpos);
   end;

for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
dunderline:=xunderline and (dy>=xunderline1) and (dy<=xunderline2);
dstrikeout:=xstrikeout and (dy>=xstrikeout1) and (dy<=xstrikeout2);

for sx:=0 to (tw-1) do
begin
//.get
dec(xcount);
if (xcount<=0) and ((xpos+2)<=xlen) then
   begin
   xcounton:=not xcounton;//invert mode ->>  trans->solid or solid->trans
//   int1:=a.pbytes[xpos-1];
   int1:=byte(x[xpos-0]);
   //.1byte datablock
   if (int1<128) then
      begin
      xcount:=int1+1;//0..127 -> 1..128
      inc(xpos);
      end
   //.3byte datablock
   else if (int1>=128) then
      begin
      //b1 -> (0-127) + (128/mark as 3byte data block)
      dec(int1,128);//remove marker value of "128"
      int1:=int1*65536;
      //b2
//      inc(int1,a.pbytes[xpos+0]*256);
      inc(int1,byte(x[xpos+1])*256);
      //b3
//      inc(int1,a.pbytes[xpos+1]);
      inc(int1,byte(x[xpos+2]));
      //get
      xcount:=int1+1;//0..N -> 1..(N+1)
      inc(xpos,3);
      end;
   end;

//.set
bol1:=false;
if (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   if xcounton then
      begin
      ar32[dy][dx]:=dc32;
      bol1:=true;
      if xbold then
         begin
         //x
         if (xbold2>=1) then for int2:=-xbold1 to xbold2 do if ((dx+int2)>=acliparea.left) and ((dx+int2)<=acliparea.right) then
            begin
            ar32[dy][dx+int2]:=dc32;
            if (xfeather>=1) and ((sx+int2)>=0) and ((sx+int2)<tw) then xfc[fi+sx+1+int2]:=#1;//**
            end;
         //y
         if (ybold2>=1) then for int2:=-ybold2 to ybold1 do if ((dy+int2)>=acliparea.top) and ((dy+int2)<=acliparea.bottom) then
            begin
            case xitalic of
            true:if ((sy+int2)<th1) then dx2:=sx+ax+round((th1-(sy+int2))*0.20) else dx2:=sx+ax-round(((sy+int2)-th1)*0.20);
            false:dx2:=sx+ax;
            end;
            ar32[dy+int2][dx2]:=dc32;
            if (xfeather>=1) and ((sy+int2)>=0) and ((sy+int2)<th) then xfc[((sy+int2)*tw)+sx+1]:=#1;//**
            end;
         end;
      end
   else if dunderline then
      begin
      ar32[dy][dx]:=dc32;
      bol1:=true;
      end
   else if dstrikeout then
      begin
      ar32[dy][dx]:=dc32;
      bol1:=true;
      end;
   end;
//.feather
if (xfeather>=1) then
   begin
   if bol1             then xfc[fi+sx+1]:=#1
   else if (not xbold) then xfc[fi+sx+1]:=#0;
   end;
//.inc
inc(dx);
end;//sx
end;//sy

//-- feather32 -----------------------------------------------------------------
if (xfeather<1) then goto skipdone;
int1:=tw*th;
for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
fi1:=fi-tw;
fi2:=fi+tw;
for sx:=0 to (tw-1) do
begin
if (xfc[fi+sx+1]=#0) and (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   //init
   bol1:=false;
   //x-1,y+0
   if (not bol1) and (sx>=1) and (xfc[fi+sx]=#1) then bol1:=true;
   //x+1,y+0
   if (not bol1) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then bol1:=true;
   //x+0,y-1
   if (not bol1) and (xfeather>=2) and (sy>=1) and (xfc[fi1+sx+1]=#1) then bol1:=true;
   //x+0,y+1
   if (not bol1) and (xfeather>=2) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then bol1:=true;
   //get
   if bol1 then
      begin
      //init
      c:=12;//light feather - 21sep2019
      r:=ar32[dy][dx].r*c;
      g:=ar32[dy][dx].g*c;
      b:=ar32[dy][dx].b*c;
      //x-1,y+0
      if ((dx-1)>=0) and (sx>=1) and (xfc[fi+sx]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy][dx-1].r);
         inc(g,ar32[dy][dx-1].g);
         inc(b,ar32[dy][dx-1].b);
         end;
      //x+1,y+0
      if ((dx+1)<aw) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy][dx+1].r);
         inc(g,ar32[dy][dx+1].g);
         inc(b,ar32[dy][dx+1].b);
         end;
      //x+0,y-1
      if ((dy-1)>=0) and (sy>=1) and (xfc[fi1+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy-1][dx].r);
         inc(g,ar32[dy-1][dx].g);
         inc(b,ar32[dy-1][dx].b);
         end;
      //x+0,y+1
      if ((dy+1)<ah) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy+1][dx].r);
         inc(g,ar32[dy+1][dx].g);
         inc(b,ar32[dy+1][dx].b);
         end;
      //set
      r:=r div c;
      g:=g div c;
      b:=b div c;
      ar32[dy][dx].r:=r;
      ar32[dy][dx].g:=g;
      ar32[dy][dx].b:=b;
      ar32[dy][dx].a:=255;
      end;//bol1
   end;//xfc
//.inc
inc(dx);
end;//sx
end;//sy
goto skipdone;

//-- drawmasked32 --------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ddddddddddddddddddddddddddddddddddddd
drawmasked32:
dc32.r:=int4.r;
dc32.g:=int4.g;
dc32.b:=int4.b;
dc32.a:=255;
//.start style
xcount:=0;
xcounton:=false;
if (xpos<=xlen) then
   begin
//   xcounton:=(a.pbytes[xpos-1]=0);//invert to start with
   xcounton:=(x[xpos-0]=#0);//invert to start with
   inc(xpos);
   end;

for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
dunderline:=xunderline and (dy>=xunderline1) and (dy<=xunderline2);
dstrikeout:=xstrikeout and (dy>=xstrikeout1) and (dy<=xstrikeout2);

for sx:=0 to (tw-1) do
begin
//.get
dec(xcount);
if (xcount<=0) and ((xpos+2)<=xlen) then
   begin
   xcounton:=not xcounton;//invert mode ->>  trans->solid or solid->trans
//   int1:=a.pbytes[xpos-1];
   int1:=byte(x[xpos-0]);
   //.1byte datablock
   if (int1<128) then
      begin
      xcount:=int1+1;//0..127 -> 1..128
      inc(xpos);
      end
   //.3byte datablock
   else if (int1>=128) then
      begin
      //b1 -> (0-127) + (128/mark as 3byte data block)
      dec(int1,128);//remove marker value of "128"
      int1:=int1*65536;
      //b2
//      inc(int1,a.pbytes[xpos+0]*256);
      inc(int1,byte(x[xpos+1])*256);
      //b3
//      inc(int1,a.pbytes[xpos+1]);
      inc(int1,byte(x[xpos+2]));
      //get
      xcount:=int1+1;//0..N -> 1..(N+1)
      inc(xpos,3);
      end;
   end;

//.set
bol1:=false;
if (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   if xcounton then
      begin
      if (mr8[dy][dx]=xmaskval) then ar32[dy][dx]:=dc32;
      bol1:=true;
      if xbold then
         begin
         //x
         if (xbold2>=1) then for int2:=-xbold1 to xbold2 do if ((dx+int2)>=acliparea.left) and ((dx+int2)<=acliparea.right) then
            begin
            if (mr8[dy][dx+int2]=xmaskval) then ar32[dy][dx+int2]:=dc32;
            if (xfeather>=1) and ((sx+int2)>=0) and ((sx+int2)<tw) then xfc[fi+sx+1+int2-0]:=#1;
            end;
         //y
         if (ybold2>=1) then for int2:=-ybold2 to ybold1 do if ((dy+int2)>=acliparea.top) and ((dy+int2)<=acliparea.bottom) then
            begin
            case xitalic of
            true:if ((sy+int2)<th1) then dx2:=sx+ax+round((th1-(sy+int2))*0.20) else dx2:=sx+ax-round(((sy+int2)-th1)*0.20);
            false:dx2:=sx+ax;
            end;
            if (mr8[dy+int2][dx2]=xmaskval) then ar32[dy+int2][dx2]:=dc32;
            if (xfeather>=1) and ((sy+int2)>=0) and ((sy+int2)<th) then xfc[((sy+int2)*tw)+sx+1]:=#1;
            end;
         end;
      end
   else if dunderline then
      begin
      if (mr8[dy][dx]=xmaskval) then ar32[dy][dx]:=dc32;
      bol1:=true;
      end
   else if dstrikeout then
      begin
      if (mr8[dy][dx]=xmaskval) then ar32[dy][dx]:=dc32;
      bol1:=true;
      end;
   end;
//.feather
if (xfeather>=1) then
   begin
   if bol1             then xfc[fi+sx+1]:=#1
   else if (not xbold) then xfc[fi+sx+1]:=#0;
   end;
//.inc
inc(dx);
end;//sx
end;//sy

//-- feather32 -----------------------------------------------------------------
if (xfeather<1) then goto skipdone;
int1:=tw*th;
for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
fi1:=fi-tw;
fi2:=fi+tw;
for sx:=0 to (tw-1) do
begin
if (xfc[fi+sx+1]=#0) and (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) and (mr8[dy][dx]=xmaskval) then//20may2020
   begin
   //init
   bol1:=false;
   //x-1,y+0
   if (not bol1) and (sx>=1) and (xfc[fi+sx]=#1) then bol1:=true;
   //x+1,y+0
   if (not bol1) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then bol1:=true;
   //x+0,y-1
   if (not bol1) and (xfeather>=2) and (sy>=1) and (xfc[fi1+sx+1]=#1) then bol1:=true;
   //x+0,y+1
   if (not bol1) and (xfeather>=2) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then bol1:=true;
   //get
   if bol1 then
      begin
      //init
      c:=12;//light feather - 21sep2019
      r:=ar32[dy][dx].r*c;
      g:=ar32[dy][dx].g*c;
      b:=ar32[dy][dx].b*c;
      //x-1,y+0
      if ((dx-1)>=0) and (sx>=1) and (xfc[fi+sx]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy][dx-1].r);
         inc(g,ar32[dy][dx-1].g);
         inc(b,ar32[dy][dx-1].b);
         end;
      //x+1,y+0
      if ((dx+1)<aw) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy][dx+1].r);
         inc(g,ar32[dy][dx+1].g);
         inc(b,ar32[dy][dx+1].b);
         end;
      //x+0,y-1
      if ((dy-1)>=0) and (sy>=1) and (xfc[fi1+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy-1][dx].r);
         inc(g,ar32[dy-1][dx].g);
         inc(b,ar32[dy-1][dx].b);
         end;
      //x+0,y+1
      if ((dy+1)<ah) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar32[dy+1][dx].r);
         inc(g,ar32[dy+1][dx].g);
         inc(b,ar32[dy+1][dx].b);
         end;
      //set
      r:=r div c;
      g:=g div c;
      b:=b div c;
      ar32[dy][dx].r:=r;
      ar32[dy][dx].g:=g;
      ar32[dy][dx].b:=b;
      ar32[dy][dx].a:=255;
      end;//bol1
   end;//xfc
//.inc
inc(dx);
end;//sx
end;//sy
goto skipdone;


//-- draw24 --------------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ddddddddddddddddddddddddddddddddddddd
draw24:
dc24.r:=int4.r;
dc24.g:=int4.g;
dc24.b:=int4.b;
//.start style
xcount:=0;
xcounton:=false;
if (xpos<=xlen) then
   begin
//   xcounton:=(a.pbytes[xpos-1]=0);//invert to start with
   xcounton:=(x[xpos]=#0);//invert to start with
   inc(xpos);
   end;

for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
dunderline:=xunderline and (dy>=xunderline1) and (dy<=xunderline2);
dstrikeout:=xstrikeout and (dy>=xstrikeout1) and (dy<=xstrikeout2);

for sx:=0 to (tw-1) do
begin
//.get
dec(xcount);
if (xcount<=0) and ((xpos+2)<=xlen) then
   begin
   xcounton:=not xcounton;//invert mode ->>  trans->solid or solid->trans
//   int1:=a.pbytes[xpos-1];
   int1:=byte(x[xpos]);
   //.1byte datablock
   if (int1<128) then
      begin
      xcount:=int1+1;//0..127 -> 1..128
      inc(xpos);
      end
   //.3byte datablock
   else if (int1>=128) then
      begin
      //b1 -> (0-127) + (128/mark as 3byte data block)
      dec(int1,128);//remove marker value of "128"
      int1:=int1*65536;
      //b2
//      inc(int1,a.pbytes[xpos+0]*256);
      inc(int1,byte(x[xpos+1])*256);
      //b3
//      inc(int1,a.pbytes[xpos+1]);
      inc(int1,byte(x[xpos+2]));
      //get
      xcount:=int1+1;//0..N -> 1..(N+1)
      inc(xpos,3);
      end;
   end;

//.set
bol1:=false;
if (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   if xcounton then
      begin
      ar24[dy][dx]:=dc24;
      bol1:=true;
      if xbold then
         begin
         //x
         if (xbold2>=1) then for int2:=-xbold1 to xbold2 do if ((dx+int2)>=acliparea.left) and ((dx+int2)<=acliparea.right) then
            begin
            ar24[dy][dx+int2]:=dc24;
            if (xfeather>=1) and ((sx+int2)>=0) and ((sx+int2)<tw) then xfc[fi+sx+1+int2]:=#1;
            end;
         //y
         if (ybold2>=1) then for int2:=-ybold2 to ybold1 do if ((dy+int2)>=acliparea.top) and ((dy+int2)<=acliparea.bottom) then
            begin
            case xitalic of
            true:if ((sy+int2)<th1) then dx2:=sx+ax+round((th1-(sy+int2))*0.20) else dx2:=sx+ax-round(((sy+int2)-th1)*0.20);
            false:dx2:=sx+ax;
            end;
            ar24[dy+int2][dx2]:=dc24;
            if (xfeather>=1) and ((sy+int2)>=0) and ((sy+int2)<th) then xfc[((sy+int2)*tw)+sx+1]:=#1;
            end;
         end;
      end
   else if dunderline then
      begin
      ar24[dy][dx]:=dc24;
      bol1:=true;
      end
   else if dstrikeout then
      begin
      ar24[dy][dx]:=dc24;
      bol1:=true;
      end;
   end;
//.feather
if (xfeather>=1) then
   begin
   if bol1             then xfc[fi+sx+1]:=#1
   else if (not xbold) then xfc[fi+sx+1]:=#0;
   end;
//.inc
inc(dx);
end;//sx
end;//sy

//-- feather24 -----------------------------------------------------------------
if (xfeather<1) then goto skipdone;
int1:=tw*th;
for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
fi1:=fi-tw;
fi2:=fi+tw;
for sx:=0 to (tw-1) do
begin
if (x[fi+sx+1]=#0) and (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   //init
   bol1:=false;
   //x-1,y+0
   if (not bol1) and (sx>=1) and (xfc[fi+sx]=#1) then bol1:=true;
   //x+1,y+0
   if (not bol1) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then bol1:=true;
   //x+0,y-1
   if (not bol1) and (xfeather>=2) and (sy>=1) and (xfc[fi1+sx+1]=#1) then bol1:=true;
   //x+0,y+1
   if (not bol1) and (xfeather>=2) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then bol1:=true;
   //get
   if bol1 then
      begin
      //init
      c:=12;//light feather - 21sep2019
      r:=ar24[dy][dx].r*c;
      g:=ar24[dy][dx].g*c;
      b:=ar24[dy][dx].b*c;
      //x-1,y+0
      if ((dx-1)>=0) and (sx>=1) and (xfc[fi+sx]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy][dx-1].r);
         inc(g,ar24[dy][dx-1].g);
         inc(b,ar24[dy][dx-1].b);
         end;
      //x+1,y+0
      if ((dx+1)<aw) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy][dx+1].r);
         inc(g,ar24[dy][dx+1].g);
         inc(b,ar24[dy][dx+1].b);
         end;
      //x+0,y-1
      if ((dy-1)>=0) and (sy>=1) and (xfc[fi1+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy-1][dx].r);
         inc(g,ar24[dy-1][dx].g);
         inc(b,ar24[dy-1][dx].b);
         end;
      //x+0,y+1
      if ((dy+1)<ah) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy+1][dx].r);
         inc(g,ar24[dy+1][dx].g);
         inc(b,ar24[dy+1][dx].b);
         end;
      //set
      r:=r div c;
      g:=g div c;
      b:=b div c;
      ar24[dy][dx].r:=r;
      ar24[dy][dx].g:=g;
      ar24[dy][dx].b:=b;
      end;//bol1
   end;//xfc
//.inc
inc(dx);
end;//sx
end;//sy
goto skipdone;

//-- drawmasked24 --------------------------------------------------------------
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ddddddddddddddddddddddddddddddddddddd
drawmasked24:
dc24.r:=int4.r;
dc24.g:=int4.g;
dc24.b:=int4.b;
//.start style
xcount:=0;
xcounton:=false;
if (xpos<=xlen) then
   begin
//   xcounton:=(a.pbytes[xpos-1]=0);//invert to start with
   xcounton:=(x[xpos]=#0);//invert to start with
   inc(xpos);
   end;

for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
dunderline:=xunderline and (dy>=xunderline1) and (dy<=xunderline2);
dstrikeout:=xstrikeout and (dy>=xstrikeout1) and (dy<=xstrikeout2);

for sx:=0 to (tw-1) do
begin
//.get
dec(xcount);
if (xcount<=0) and ((xpos+2)<=xlen) then
   begin
   xcounton:=not xcounton;//invert mode ->>  trans->solid or solid->trans
//   int1:=a.pbytes[xpos-1];
   int1:=byte(x[xpos]);
   //.1byte datablock
   if (int1<128) then
      begin
      xcount:=int1+1;//0..127 -> 1..128
      inc(xpos);
      end
   //.3byte datablock
   else if (int1>=128) then
      begin
      //b1 -> (0-127) + (128/mark as 3byte data block)
      dec(int1,128);//remove marker value of "128"
      int1:=int1*65536;
      //b2
//      inc(int1,a.pbytes[xpos+0]*256);
      inc(int1,byte(x[xpos+1])*256);
      //b3
//      inc(int1,a.pbytes[xpos+1]);
      inc(int1,byte(x[xpos+2]));
      //get
      xcount:=int1+1;//0..N -> 1..(N+1)
      inc(xpos,3);
      end;
   end;

//.set
bol1:=false;
if (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) then
   begin
   if xcounton then
      begin
      if (mr8[dy][dx]=xmaskval) then ar24[dy][dx]:=dc24;
      bol1:=true;
      if xbold then
         begin
         //x
         if (xbold2>=1) then for int2:=-xbold1 to xbold2 do if ((dx+int2)>=acliparea.left) and ((dx+int2)<=acliparea.right) then
            begin
            if (mr8[dy][dx+int2]=xmaskval) then ar24[dy][dx+int2]:=dc24;
            if (xfeather>=1) and ((sx+int2)>=0) and ((sx+int2)<tw) then xfc[fi+sx+1+int2]:=#1;
            end;
         //y
         if (ybold2>=1) then for int2:=-ybold2 to ybold1 do if ((dy+int2)>=acliparea.top) and ((dy+int2)<=acliparea.bottom) then
            begin
            case xitalic of
            true:if ((sy+int2)<th1) then dx2:=sx+ax+round((th1-(sy+int2))*0.20) else dx2:=sx+ax-round(((sy+int2)-th1)*0.20);
            false:dx2:=sx+ax;
            end;
            if (mr8[dy+int2][dx2]=xmaskval) then ar24[dy+int2][dx2]:=dc24;
            if (xfeather>=1) and ((sy+int2)>=0) and ((sy+int2)<th) then xfc[((sy+int2)*tw)+sx+1]:=#1;
            end;
         end;
      end
   else if dunderline then
      begin
      if (mr8[dy][dx]=xmaskval) then ar24[dy][dx]:=dc24;
      bol1:=true;
      end
   else if dstrikeout then
      begin
      if (mr8[dy][dx]=xmaskval) then ar24[dy][dx]:=dc24;
      bol1:=true;
      end;
   end;
//.feather
if (xfeather>=1) then
   begin
   if bol1             then xfc[fi+sx+1]:=#1
   else if (not xbold) then xfc[fi+sx+1]:=#0;
   end;
//.inc
inc(dx);
end;//sx
end;//sy

//-- feather24 -----------------------------------------------------------------
if (xfeather<1) then goto skipdone;
int1:=tw*th;
for sy:=0 to (th-1) do
begin
dy:=ay+sy;
case xitalic of
true:if (sy<th1) then dx:=ax+round((th1-sy)*0.20) else dx:=ax-round((sy-th1)*0.20);
false:dx:=ax;
end;
fi:=sy*tw;
fi1:=fi-tw;
fi2:=fi+tw;
for sx:=0 to (tw-1) do
begin
if (xfc[fi+sx+1]=#0) and (dx>=acliparea.left) and (dx<=acliparea.right) and (dy>=acliparea.top) and (dy<=acliparea.bottom) and (mr8[dy][dx]=xmaskval) then
   begin
   //init
   bol1:=false;
   //x-1,y+0
   if (not bol1) and (sx>=1) and (xfc[fi+sx]=#1) then bol1:=true;
   //x+1,y+0
   if (not bol1) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then bol1:=true;
   //x+0,y-1
   if (not bol1) and (xfeather>=2) and (sy>=1) and (xfc[fi1+sx+1]=#1) then bol1:=true;
   //x+0,y+1
   if (not bol1) and (xfeather>=2) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then bol1:=true;
   //get
   if bol1 then
      begin
      //init
      c:=12;//light feather - 21sep2019
      r:=ar24[dy][dx].r*c;
      g:=ar24[dy][dx].g*c;
      b:=ar24[dy][dx].b*c;
      //x-1,y+0
      if ((dx-1)>=0) and (sx>=1) and (xfc[fi+sx]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy][dx-1].r);
         inc(g,ar24[dy][dx-1].g);
         inc(b,ar24[dy][dx-1].b);
         end;
      //x+1,y+0
      if ((dx+1)<aw) and (sx<(tw-1)) and (xfc[fi+sx+2]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy][dx+1].r);
         inc(g,ar24[dy][dx+1].g);
         inc(b,ar24[dy][dx+1].b);
         end;
      //x+0,y-1
      if ((dy-1)>=0) and (sy>=1) and (xfc[fi1+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy-1][dx].r);
         inc(g,ar24[dy-1][dx].g);
         inc(b,ar24[dy-1][dx].b);
         end;
      //x+0,y+1
      if ((dy+1)<ah) and (sy<(th-1)) and (xfc[fi2+sx+1]=#1) then
         begin
         inc(c);
         inc(r,ar24[dy+1][dx].r);
         inc(g,ar24[dy+1][dx].g);
         inc(b,ar24[dy+1][dx].b);
         end;
      //set
      r:=r div c;
      g:=g div c;
      b:=b div c;
      ar24[dy][dx].r:=r;
      ar24[dy][dx].g:=g;
      ar24[dy][dx].b:=b;
      end;//bol1
   end;//xfc
//.inc
inc(dx);
end;//sx
end;//sy
goto skipdone;


//successful
skipdone:
result:=true;
skipend:
except;end;
end;
//## low__fromLGF_drawtext2432 ##
function low__fromLGF_drawtext2432(x,xtext:string;ax,ay,aw,ah,dcolor:longint;acliparea:trect;ar24:pcolorrows24;ar32:pcolorrows32;xmask:tmask8;xmaskval:longint;var xfc:string;xfeather:longint;xbold,xitalic,xunderline,xstrikeout:boolean):boolean;
label
   skipend;
var
   int1,cw,p:longint;
begin
try
result:=false;
if (x<>'') then
   begin
   if (xtext<>'') then
      begin
      for p:=1 to length(xtext) do
      begin
      int1:=byte(xtext[p]);
      cw:=low__fromLGF_charw(x,int1);
      if not low__fromLGF_drawchar2432(x,int1,ax,ay,aw,ah,dcolor,acliparea,ar24,ar32,xmask,xmaskval,xfc,xfeather,xbold,xitalic,xunderline,xstrikeout) then goto skipend;
      inc(ax,cw);
      end;//p
      end;
   //successful
   result:=true;
   end;
skipend:
except;end;
end;

//## tbmp ######################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//ppppppppppppppppppppppppppp
//## create ##
constructor tbmp.create;
begin
inherited create;
//options
low__aiClear(ai);
dtransparent:=true;
omovie:=false;
oaddress:='';
ocleanmask32bpp:=false;
rhavemovie:=false;
//vars
ilockptr:=nil;
ibits:=0;
iwidth:=0;
iheight:=0;
ilocked:=false;
iunlocking:=false;
isharp:=false;
{$ifdef w32}
isharphfont:=0;
{$endif}
icore:=tbitmap.create;
irows:=newstr8(0);
irows8 :=nil;
irows15:=nil;
irows16:=nil;
irows24:=nil;
irows32:=nil;
//defaults
setparams(32,1,1);
end;
//## destroy ##
destructor tbmp.destroy;
begin
try
//release
unlock;
sharp:=false;
//vars
irows8 :=nil;
irows15:=nil;
irows16:=nil;
irows24:=nil;
irows32:=nil;
freeobj(@icore);
freeobj(@irows);
//self
inherited destroy;
except;end;
end;
//## setbits ##
procedure tbmp.setbits(x:longint);
begin
try;setparams(x,iwidth,iheight);except;end;
end;
//## setwidth ##
procedure tbmp.setwidth(x:longint);
begin
try;setparams(ibits,x,iheight);except;end;
end;
//## setheight ##
procedure tbmp.setheight(x:longint);
begin
try;setparams(ibits,iwidth,x);except;end;
end;
//## cansetparams ##
function tbmp.cansetparams:boolean;
begin
try;result:=(not ilocked) and (not isharp);except;end;
end;
//## setparams ##
function tbmp.setparams(dbits,dw,dh:longint):boolean;
begin
try
//defaults
result:=false;
//check
if not cansetparams then exit;
//range
if (dbits<>8) and (dbits<>15) and (dbits<>16) and (dbits<>24) and (dbits<>32) then dbits:=32;
dw:=frcmin(dw,1);
dh:=frcmin(dh,1);
//get
if (dbits<>ibits) or (dw<>iwidth) or (dh<>iheight) then
   begin
   //bits
   {$ifdef w32}
   if (dbits<>ibits) then
      begin
      case dbits of
      15:icore.pixelformat:=pf15bit;
      16:icore.pixelformat:=pf16bit;
      24:icore.pixelformat:=pf24bit;
      32:icore.pixelformat:=pf32bit;
      else icore.pixelformat:=pf32bit;//fallback position -> default for Android
      end;//case
      end;
   {$endif}
   //width
   if (icore.width<>dw) then icore.width:=dw;
   //height
   if (icore.height<>dh) then icore.height:=dh;
   //sync
   xinfo;
   //successful
   result:=true;
   end
else result:=true;
except;end;
end;
//## xinfo ##
procedure tbmp.xinfo;
begin
try
ibits:=misb(icore);
iwidth:=misw(icore);
iheight:=mish(icore);
except;end;
end;
//## cancanvas ##
function tbmp.cancanvas:boolean;
begin
try;result:=true;except;end;
end;
//## getcanvas ##
function tbmp.getcanvas:tcanvas;
begin
try;result:=icore.canvas;except;end;
end;
//## canassign ##
function tbmp.canassign:boolean;
begin
try;result:=(not ilocked) and (not isharp);except;end;
end;
//## assign ##
function tbmp.assign(x:tobject):boolean;
begin
try
//defaults
result:=false;
//check
if not canassign then exit;
//get
if (x is tbitmap) then
   begin
   icore.assign(x as tbitmap);
   xinfo;
   end;
except;end;
end;
//## canrows ##
function tbmp.canrows:boolean;
begin
try;result:=ilocked;except;end;
end;
//## lock ##
function tbmp.lock:boolean;
label
   skipend;
var
{$ifdef a32}
   a:tbitmapdata;
{$endif}
   dy:longint;
begin
try
//defaults
result:=false;
//check
if ilocked then exit else ilocked:=true;
//init
irows.setlen(iheight*sizeof(tpointer));
irows8 :=irows.core;
irows15:=irows.core;
irows16:=irows.core;
irows24:=irows.core;
irows32:=irows.core;

//get rows ---------------------------------------------------------------------

{$ifdef w32}
ilockptr:=nil;//not used for Win32
case ibits of
8 :for dy:=0 to (iheight-1) do irows8[dy] :=icore.scanline[dy];
15:for dy:=0 to (iheight-1) do irows15[dy]:=icore.scanline[dy];
16:for dy:=0 to (iheight-1) do irows16[dy]:=icore.scanline[dy];
24:for dy:=0 to (iheight-1) do irows24[dy]:=icore.scanline[dy];
32:for dy:=0 to (iheight-1) do irows32[dy]:=icore.scanline[dy];
end;
{$endif}

{$ifdef a32}
//lock
if not icore.map(tmapaccess.write,a) then
   begin
   ilocked:=false;//cancel lock
   goto skipend;
   end;
//info
ilockptr:=@a;//retain this object
case ibits of
8 :for dy:=0 to (iheight-1) do irows8[dy] :=a.getscanline(dy);
15:for dy:=0 to (iheight-1) do irows15[dy]:=a.getscanline(dy);
16:for dy:=0 to (iheight-1) do irows16[dy]:=a.getscanline(dy);
24:for dy:=0 to (iheight-1) do irows24[dy]:=a.getscanline(dy);
32:for dy:=0 to (iheight-1) do irows32[dy]:=a.getscanline(dy);
end;
{$endif}

//successful
result:=true;
skipend:
except;end;
end;
//## unlock ##
function tbmp.unlock:boolean;
begin
try
//defaults
result:=false;
//check
if iunlocking or (not ilocked) then exit else iunlocking:=true;

{$ifdef a32}
if (ilockptr<>nil) then
   begin
   icore.unmap(tbitmapdata(ilockptr^));
   ilockptr:=nil;
   end;
{$endif}

//successful
result:=true;
except;end;
try
iunlocking:=false;
ilocked:=false;
except;end;
end;
//## cansharp ##
function tbmp.cansharp:boolean;
begin
try;result:=(not ilocked);except;end;
end;
//## setsharp ##
procedure tbmp.setsharp(x:boolean);
label
   dosharp,donormal,done;
{$ifdef w32}
var
   xlf:tlogfont;
   v,xf1,xf2:hfont;
{$endif}
begin
try
//check
if (not cansharp) or (x=isharp) then exit;
//get
isharp:=x;
if x then goto dosharp else goto donormal;

//sharp ------------------------------------------------------------------------
dosharp:
{$ifdef w32}
//Note: Any change in width and/or eight will cause font to be reset
getobject(icore.canvas.font.handle,sizeof(xlf),@xlf);
xlf.lfQuality:=NONANTIALIASED_QUALITY;//was: DEFAULT_QUALITY;
xf1:=createfontindirect(xlf);
xf2:=selectobject(icore.canvas.handle,xf1);
isharphfont:=xf1;
{$endif}

{$ifdef a32}
//xxxxxxxxxxxxxxxxxxx//??????????????????//D10: No support yet
{$endif}

goto done;


//normal -----------------------------------------------------------------------
donormal:
{$ifdef w32}
//reinstate previous font -> keep Delphi happy - 04apr2020
if (isharphfont<>0) then
   begin
   v:=selectobject(icore.canvas.handle,isharphfont);
   deleteobject(v);
   isharphfont:=0;
   end;
{$endif}

{$ifdef a32}
//xxxxxxxxxxxxxxxxxxx//??????????????????//D10: No support yet
{$endif}

goto done;

//done -------------------------------------------------------------------------
done:
except;end;
end;

//## tstreamstr ################################################################
//## create ##
constructor tstreamstr.create(_ptr:pstring);
begin
//self
inherited create;
//sd
//set
iptr:=_ptr;
iposition:=0;
end;
//## destroy ##
destructor tstreamstr.destroy;
begin
try
//self
inherited destroy;
//sd
except;end;
end;
//## read ##
function tstreamstr.read(var x;xlen:longint):longint;
begin
try
//set
if (iptr=nil) then result:=0
else
   begin
   result:=length(iptr^)-iposition;
   if (result>xlen) then result:=xlen;
   move(pchar(@iptr^[iposition+1])^,x,result);
   inc(iposition,result);
   end;//end of if
except;end;
end;
//## write ##
function tstreamstr.write(const x;xlen:longint):longint;
begin
try
//set
if (iptr=nil) then result:=0
else
  begin
  result:=xlen;
  setlength(iptr^,(iposition+result));
  move(x,pchar(@iptr^[iposition+1])^,result);
  inc(iposition,result);
  end;//end of if
except;end;
end;
//## seek ##
function tstreamstr.seek(offset:longint;origin:word):longint;
begin
try
//check
if (iptr=nil) then
   begin
   iposition:=0;
   result:=0;
   exit;
   end;//end of if
//set
case Origin of
soFromBeginning:iposition:=offset;
soFromCurrent:iposition:=iposition+offset;
soFromEnd:iposition:=length(iptr^)-offset;
end;//end of case
//range
iposition:=frcrange(iposition,0,length(iptr^));
//return result
result:=iposition;
except;end;
end;
//## readstring ##
function tstreamstr.readstring(count:longint):string;
var
  len:integer;
begin
try
//defaults
result:='';
//check
if (iptr=nil) then exit;
//process
len:=length(iptr^)-iposition;
if (len>count) then len:=count;
setstring(result,pchar(@iptr^[iposition+1]),len);
inc(iposition,len);
except;end;
end;
//## writestring ##
procedure tstreamstr.writestring(const x:string);
begin
try;write(pchar(x)^,length(x));except;end;
end;
//## setsize ##
procedure tstreamstr.setsize(newsize:longint);
begin
try
//check
if (iptr=nil) then exit;
//set
setlength(iptr^,newsize);
if (iposition>newsize) then iposition:=newsize;
except;end;
end;

//## tstr8 #####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//888888888888888888888888888888
//## newstr8 ##
function newstr8(xlen:longint):tstr8;
begin
result:=nil;
result:=tstr8.create(xlen);
end;
//## newstr82 ##
function newstr82(xtext:string):tstr8;
begin
result:=nil;
result:=tstr8.create(0);
result.replacestr:=xtext;
end;
//## newstr83 ##
function newstr83(xdata:tstr8):tstr8;
begin
result:=nil;
result:=tstr8.create(0);
result.replace:=xdata;
end;
//## newstr84 ##
function newstr84(xdata:array of byte):tstr8;//09jun2020
begin
result:=nil;
result:=tstr8.create(0);
result.aadd(xdata);
end;
//## create ##
constructor tstr8.create(xlen:longint);
begin
inherited create;
idata:=nil;
idatalen:=0;
icount:=0;
ibytes :=idata;
ichars :=idata;
iints4 :=idata;
irows8 :=idata;
irows15:=idata;
irows16:=idata;
irows24:=idata;
irows32:=idata;
xresize(xlen,true);
end;
//## destroy ##
destructor tstr8.destroy;
begin
try
low__freemem(idata);
inherited destroy;
except;end;
end;
//## empty ##
function tstr8.empty:boolean;
begin
try;result:=(icount<=0);except;end;
end;
//## notempty ##
function tstr8.notempty:boolean;
begin
try;result:=(icount>=1);except;end;
end;
//## same ##
function tstr8.same(x:tstr8):boolean;
begin
try;result:=same2(0,x);except;end;
end;
//## same2 ##
function tstr8.same2(xfrom:longint;x:tstr8):boolean;
label
   skipend;
var
   i,p:longint;
begin
try
result:=false;
if (x<>nil) then
   begin
   //init
   if (xfrom<0) then xfrom:=0;
   //get
   for p:=0 to (x.count-1) do
   begin
   i:=xfrom+p;
   if (i>=icount) or (ibytes[i]<>x.pbytes[p]) then goto skipend;
   end;//p
   //successful
   result:=true;
   end;
skipend:
except;end;
end;
//## asame ##
function tstr8.asame(x:array of byte):boolean;
begin
try;result:=asame2(0,x);except;end;
end;
//## asame2 ##
function tstr8.asame2(xfrom:longint;x:array of byte):boolean;
label
   skipend;
var
   i,xmin,xmax,p:longint;
begin
try
result:=false;
if (xfrom<0) then xfrom:=0;
xmin:=low(x);
xmax:=high(x);
for p:=xmin to xmax do
begin
i:=xfrom+(p-xmin);
if (i>=icount) or (ibytes[i]<>x[p]) then goto skipend;
end;//p
//successful
result:=true;
skipend:
except;end;
end;
//## xresize ##
function tstr8.xresize(x:longint;xsetcount:boolean):boolean;
var
   xnew,xold:longint;
begin
try
//defaults
result:=true;
//init
xnew:=frcrange(x,0,maxint);
xold:=frcrange(idatalen,0,maxint);
//get
if (xnew<>xold) then
   begin
   low__reallocmem(idata,xold,xnew);
   idatalen:=xnew;
   ibytes:=idata;
   ichars:=idata;
   iints4 :=idata;
   irows8 :=idata;
   irows15:=idata;
   irows16:=idata;
   irows24:=idata;
   irows32:=idata;
   end;
//sync
if xsetcount then icount:=xnew else icount:=frcrange(icount,0,xnew);
except;end;
end;
//## clear ##
function tstr8.clear:boolean;
begin
try;result:=true;setlen(0);except;end;
end;
//## setlen ##
function tstr8.setlen(x:longint):boolean;
begin
try;result:=true;xresize(x,true);except;end;
end;
//## minlen ##
function tstr8.minlen(x:longint):boolean;//atleast this length
var
   int1:longint;
begin
try
result:=true;
x:=frcrange(x,0,maxint);
if (x>idatalen) then
   begin
   case largest(idatalen,x) of
   0..100      :int1:=100;//100b
   101..1000   :int1:=1000;//1K
   1001..100000:int1:=100000;//100K
   else         int1:=1000000;//1M
   end;//case
   xresize(x+int1,false);//requested len + some more for extra speed - 29apr2020
   end;
except;end;
end;
//## fill ##
function tstr8.fill(xfrom,xto:longint;xval:byte):boolean;
var
   p:longint;
begin
try
result:=true;
if (xfrom<=xto) and (icount>=1) and frcrange2(xfrom,0,icount-1) and frcrange2(xto,xfrom,icount-1) then
   begin
   for p:=xfrom to xto do ibytes[p]:=xval;
   end;
except;end;
end;
//## del ##
function tstr8.del(xfrom,xto:longint):boolean;
var
   p,int1:longint;
begin
try
//defaults
result:=true;
//check
if (icount<=0) or (xfrom>xto) or (xto<0) or (xfrom>=icount) then exit;
//get
if frcrange2(xfrom,0,icount-1) and frcrange2(xto,xfrom,icount-1) then
   begin
   //shift down
   int1:=xto+1;
   if (int1<icount) then for p:=int1 to (icount-1) do ibytes[xfrom+p-int1]:=ibytes[p];
   //resize
   xresize(icount-(xto-xfrom+1),true);
   end;
except;end;
end;
//object support ---------------------------------------------------------------
//## add ##
function tstr8.add(x:tobject):boolean;
begin
try;result:=true;ins2(x,icount,0,maxint);except;end;
end;
//## add2 ##
function tstr8.add2(x:tobject;xfrom,xto:longint):boolean;
begin
try;result:=true;ins2(x,icount,xfrom,xto);except;end;
end;
//## add3 ##
function tstr8.add3(x:tobject;xfrom,xlen:longint):boolean;
begin
try;result:=true;if (xlen>=1) then ins2(x,icount,xfrom,xfrom+xlen-1);except;end;
end;
//## ins ##
function tstr8.ins(x:tobject;xpos:longint):boolean;
begin
try;result:=true;ins2(x,xpos,0,maxint);except;end;
end;
//## ins2 ##
function tstr8.ins2(x:tobject;xpos,xfrom,xto:longint):boolean;
label
   skipend;
var
   dcount,p,int1:longint;
begin
try
//check
result:=true;
if (x=nil) then exit;
//init
xpos:=frcrange(xpos,0,icount);//allow to write past end
//get
if (x is tstr8) then
   begin
   //check
   int1:=(x as tstr8).count;
   if (int1<=0) or (xfrom>xto) or (xto<0) or (xfrom>=int1) then goto skipend;
   //init
   xfrom:=frcrange(xfrom,0,int1-1);
   xto:=frcrange(xto,xfrom,int1-1);
   dcount:=icount+(xto-xfrom+1);
   minlen(dcount);
   //shift up
   if (xpos<icount) then
      begin
      int1:=xto-xfrom+1;
      for p:=(dcount-1) downto (xpos+int1) do ibytes[p]:=ibytes[p-int1];
      end;
   //copy + size
   for p:=xfrom to xto do ibytes[xpos+p-xfrom]:=(x as tstr8).pbytes[p];
   icount:=dcount;
   end;
skipend:
except;end;
end;
//array support ----------------------------------------------------------------
//## aadd ##
function tstr8.aadd(x:array of byte):boolean;
begin
try;result:=true;ains2(x,icount,0,maxint);except;end;
end;
//## aadd2 ##
function tstr8.aadd2(x:array of byte;xfrom,xto:longint):boolean;
begin
try;result:=true;ains2(x,icount,xfrom,xto);except;end;
end;
//## ains ##
function tstr8.ains(x:array of byte;xpos:longint):boolean;
begin
try;result:=true;ains2(x,xpos,0,maxint);except;end;
end;
//## ains2 ##
function tstr8.ains2(x:array of byte;xpos,xfrom,xto:longint):boolean;
var
   dcount,p,int1:longint;
begin
try
//defaults
result:=false;
//check
if (xto<xfrom) then exit;
//range
xfrom:=frcrange(xfrom,low(x),high(x));
xto  :=frcrange(xto  ,low(x),high(x));
if (xto<xfrom) then exit;
//init
xpos:=frcrange(xpos,0,icount);//allow to write past end
dcount:=icount+(xto-xfrom+1);
minlen(dcount);
//shift up
if (xpos<icount) then
   begin
   int1:=xto-xfrom+1;
   for p:=(dcount-1) downto (xpos+int1) do ibytes[p]:=ibytes[p-int1];
   end;
//copy + size
for p:=xfrom to xto do ibytes[xpos+p-xfrom]:=x[p];
icount:=dcount;
//successful
result:=true;
except;end;
end;
//string support ---------------------------------------------------------------
//## sadd ##
function tstr8.sadd(x:string):boolean;
begin
try;result:=true;sins2(x,icount,0,maxint);except;end;
end;
//## sadd2 ##
function tstr8.sadd2(x:string;xfrom,xto:longint):boolean;
begin
try;result:=true;sins2(x,icount,xfrom,xto);except;end;
end;
//## sadd3 ##
function tstr8.sadd3(x:string;xfrom,xlen:longint):boolean;
begin
try;result:=true;if (xlen>=1) then sins2(x,icount,xfrom,xfrom+xlen-1);except;end;
end;
//## sins ##
function tstr8.sins(x:string;xpos:longint):boolean;
begin
try;result:=true;sins2(x,xpos,0,maxint);except;end;
end;
//## sins2 ##
function tstr8.sins2(x:string;xpos,xfrom,xto:longint):boolean;
var//Always zero based for "xfrom" and "xto"
   xlen,dcount,p,int1:longint;
begin
try
//defaults
result:=false;
//check
if (xto<xfrom) then exit;
xlen:=length(x);
if (xlen<=0) then
   begin
   result:=true;
   exit;
   end;
//range
xfrom:=frcrange(xfrom,0,xlen-1);
xto  :=frcrange(xto  ,0,xlen-1);
if (xto<xfrom) then exit;
//init
xpos:=frcrange(xpos,0,icount);//allow to write past end
dcount:=icount+(xto-xfrom+1);
minlen(dcount);
//shift up
if (xpos<icount) then
   begin
   int1:=xto-xfrom+1;
   for p:=(dcount-1) downto (xpos+int1) do ibytes[p]:=ibytes[p-int1];
   end;
//copy + size
for p:=xfrom to xto do ibytes[xpos+p-xfrom]:=byte(x[p+stroffset]);//force 8bit conversion from unicode to 8bit binary - 02may2020
icount:=dcount;
//successful
result:=true;
except;end;
end;
//push support -----------------------------------------------------------------
//## pushcmp8 ##
function tstr8.pushcmp8(var xpos:longint;xval:comp):boolean;
begin
result:=ains(tcmp8(xval).bytes,xpos);
if result then inc(xpos,8);
end;
//## pushcur8 ##
function tstr8.pushcur8(var xpos:longint;xval:currency):boolean;
begin
result:=ains(tcur8(xval).bytes,xpos);
if result then inc(xpos,8);
end;
//## pushint4 ##
function tstr8.pushint4(var xpos:longint;xval:longint):boolean;
begin
result:=ains(tint4(xval).bytes,xpos);
if result then inc(xpos,4);
end;
//## pushwrd2 ##
function tstr8.pushwrd2(var xpos:longint;xval:word):boolean;
begin
result:=ains(pwrd2(xval).bytes,xpos);
if result then inc(xpos,2);
end;
//## pushbyt1 ##
function tstr8.pushbyt1(var xpos:longint;xval:byte):boolean;
begin
result:=ains([xval],xpos);
if result then inc(xpos,1);
end;
//## pushchr1 ##
function tstr8.pushchr1(var xpos:longint;xval:char):boolean;
begin
result:=ains([byte(xval)],xpos);
if result then inc(xpos,1);
end;
//## pushstr ##
function tstr8.pushstr(var xpos:longint;xval:string):boolean;
begin
result:=sins(xval,xpos);
if result then inc(xpos,length(xval));
end;
//add support ------------------------------------------------------------------
//## addcmp8 ##
function tstr8.addcmp8(xval:comp):boolean;
begin
result:=aadd(tcmp8(xval).bytes);
end;
//## addcur8 ##
function tstr8.addcur8(xval:currency):boolean;
begin
result:=aadd(tcur8(xval).bytes);
end;
//## addint4 ##
function tstr8.addint4(xval:longint):boolean;
begin
result:=aadd(tint4(xval).bytes);
end;
//## addwrd2 ##
function tstr8.addwrd2(xval:word):boolean;
begin
result:=aadd(pwrd2(xval).bytes);
end;
//## addbyt1 ##
function tstr8.addbyt1(xval:byte):boolean;
begin
result:=aadd([xval]);
end;
//## addchr1 ##
function tstr8.addchr1(xval:char):boolean;
begin
result:=aadd([byte(xval)]);
end;
//## addstr ##
function tstr8.addstr(xval:string):boolean;
begin
result:=sadd(xval);
end;
//get support ------------------------------------------------------------------
//## getcmp8 ##
function tstr8.getcmp8(xpos:longint):comp;
var
   a:tcmp8;
begin
if (xpos>=0) and ((xpos+7)<icount) then
   begin
   a.bytes[0]:=ibytes[xpos+0];
   a.bytes[1]:=ibytes[xpos+1];
   a.bytes[2]:=ibytes[xpos+2];
   a.bytes[3]:=ibytes[xpos+3];
   a.bytes[4]:=ibytes[xpos+4];
   a.bytes[5]:=ibytes[xpos+5];
   a.bytes[6]:=ibytes[xpos+6];
   a.bytes[7]:=ibytes[xpos+7];
   result:=a.val;
   end
else result:=0;
end;
//## getcur8 ##
function tstr8.getcur8(xpos:longint):currency;
var
   a:tcur8;
begin
if (xpos>=0) and ((xpos+7)<icount) then
   begin
   a.bytes[0]:=ibytes[xpos+0];
   a.bytes[1]:=ibytes[xpos+1];
   a.bytes[2]:=ibytes[xpos+2];
   a.bytes[3]:=ibytes[xpos+3];
   a.bytes[4]:=ibytes[xpos+4];
   a.bytes[5]:=ibytes[xpos+5];
   a.bytes[6]:=ibytes[xpos+6];
   a.bytes[7]:=ibytes[xpos+7];
   result:=a.val;
   end
else result:=0;
end;
//## getint4 ##
function tstr8.getint4(xpos:longint):longint;
var
   a:tint4;
begin
if (xpos>=0) and ((xpos+3)<icount) then
   begin
   a.bytes[0]:=ibytes[xpos+0];
   a.bytes[1]:=ibytes[xpos+1];
   a.bytes[2]:=ibytes[xpos+2];
   a.bytes[3]:=ibytes[xpos+3];
   result:=a.val;
   end
else result:=0;
end;
//## getwrd2 ##
function tstr8.getwrd2(xpos:longint):word;
var
   a:twrd2;
begin
if (xpos>=0) and ((xpos+1)<icount) then
   begin
   a.bytes[0]:=ibytes[xpos+0];
   a.bytes[1]:=ibytes[xpos+1];
   result:=a.val;
   end
else result:=0;
end;
//## getbyt1 ##
function tstr8.getbyt1(xpos:longint):byte;
begin
if (xpos>=0) and (xpos<icount) then result:=ibytes[xpos]
else result:=0;
end;
//## getchr1 ##
function tstr8.getchr1(xpos:longint):char;
begin
if (xpos>=0) and (xpos<icount) then result:=char(ibytes[xpos])
else result:=#0;
end;
//## getstr ##
function tstr8.getstr(xpos,xlen:longint):string;
var
   p:longint;
begin
if (xlen>=1) and (xpos>=0) and ((xpos+xlen-1)<icount) then
   begin
   setlength(result,xlen);
   for p:=xpos to (xpos+xlen-1) do result[p-xpos+stroffset]:=char(ibytes[p]);
   end
else result:='';
end;
//## getstr1 ##
function tstr8.getstr1(xpos,xlen:longint):string;
begin
result:=getstr(xpos-1,xlen);
end;
//## gettext ##
function tstr8.gettext:string;
var
   p:longint;
begin
if (icount>=1) then
   begin
   setlength(result,icount);
   for p:=0 to (icount-1) do result[p+stroffset]:=ichars[p];
   end
else result:='';
end;
//## settext ##
procedure tstr8.settext(x:string);
var
   xlen,p:longint;
begin
try
xlen:=length(x);
setlen(xlen);
if (xlen>=1) then
   begin
   for p:=1 to xlen do ibytes[p-1]:=byte(x[p-1+stroffset]);//force 8bit conversion
   end;
except;end;
end;
//## gettextarray ##
function tstr8.gettextarray:string;
label
   skipend;
var
   a,aline:tstr8;
   xmax,p:longint;
begin
try
//defaults
result:='';
a:=nil;
aline:=nil;
//check
if (icount<=0) then goto skipend;
//init
a:=newstr8(0);
aline:=newstr8(0);
xmax:=icount-1;
//get
for p:=0 to xmax do
begin
aline.sadd(inttostr(ibytes[p])+low__insstr(',',p<xmax));
if (aline.count>=1010) then
   begin
   aline.sadd(rcode);
   a.add(aline);
   aline.clear;
   end;
end;//p
//.finalise
if (aline.count>=1) then
   begin
   a.add(aline);
   aline.clear;
   end;
//set
result:='x:array[0..'+inttostr(icount-1)+'] of byte=('+rcode+a.text+');';
skipend:
except;end;
try
freeobj(@a);
freeobj(@aline);
except;end;
end;
//set support ------------------------------------------------------------------
//## setcmp8 ##
procedure tstr8.setcmp8(xpos:longint;xval:comp);
var
   a:tcmp8;
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+8) then exit;
a.val:=xval;
ibytes[xpos+0]:=a.bytes[0];
ibytes[xpos+1]:=a.bytes[1];
ibytes[xpos+2]:=a.bytes[2];
ibytes[xpos+3]:=a.bytes[3];
ibytes[xpos+4]:=a.bytes[4];
ibytes[xpos+5]:=a.bytes[5];
ibytes[xpos+6]:=a.bytes[6];
ibytes[xpos+7]:=a.bytes[7];
icount:=frcmin(icount,xpos+8);//10may2020
end;
//## setcur8 ##
procedure tstr8.setcur8(xpos:longint;xval:currency);
var
   a:tcur8;
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+8) then exit;
a.val:=xval;
ibytes[xpos+0]:=a.bytes[0];
ibytes[xpos+1]:=a.bytes[1];
ibytes[xpos+2]:=a.bytes[2];
ibytes[xpos+3]:=a.bytes[3];
ibytes[xpos+4]:=a.bytes[4];
ibytes[xpos+5]:=a.bytes[5];
ibytes[xpos+6]:=a.bytes[6];
ibytes[xpos+7]:=a.bytes[7];
icount:=frcmin(icount,xpos+8);//10may2020
end;
//## setint4 ##
procedure tstr8.setint4(xpos:longint;xval:longint);
var
   a:tint4;
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+4) then exit;
a.val:=xval;
ibytes[xpos+0]:=a.bytes[0];
ibytes[xpos+1]:=a.bytes[1];
ibytes[xpos+2]:=a.bytes[2];
ibytes[xpos+3]:=a.bytes[3];
icount:=frcmin(icount,xpos+4);//10may2020
end;
//## setwrd2 ##
procedure tstr8.setwrd2(xpos:longint;xval:word);
var
   a:twrd2;
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+2) then exit;
a.val:=xval;
ibytes[xpos+0]:=a.bytes[0];
ibytes[xpos+1]:=a.bytes[1];
icount:=frcmin(icount,xpos+2);//10may2020
end;
//## setbyt1 ##
procedure tstr8.setbyt1(xpos:longint;xval:byte);
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+1) then exit;
ibytes[xpos]:=xval;
icount:=frcmin(icount,xpos+1);//10may2020
end;
//## setchr1 ##
procedure tstr8.setchr1(xpos:longint;xval:char);
begin
if (xpos<0) then xpos:=0;
if not minlen(xpos+1) then exit;
ibytes[xpos]:=byte(xval);
icount:=frcmin(icount,xpos+1);//10may2020
end;
//## setstr ##
procedure tstr8.setstr(xpos:longint;xlen:longint;xval:string);
var
   xminlen,p:longint;
begin
if (xpos<0) then xpos:=0;
if (xlen<=0) or (xval='') then exit;
xlen:=frcmax(xlen,length(xval));
xminlen:=xpos+xlen;
minlen(xminlen);
for p:=xpos to (xpos+xlen-1) do ibytes[p]:=ord(xval[p+stroffset]);
icount:=frcmin(icount,xminlen);//10may2020
end;
//## setstr1 ##
procedure tstr8.setstr1(xpos:longint;xlen:longint;xval:string);
begin
setstr(xpos-1,xlen,xval);
end;
//## setarray ##
function tstr8.setarray(xpos:longint;xval:array of byte):boolean;
var
   xminlen,xmin,xmax,p:longint;
begin
if (xpos<0) then xpos:=0;
xmin:=low(xval);
xmax:=high(xval);
xminlen:=xpos+(xmax-xmin+1);
minlen(xminlen);
for p:=xmin to xmax do ibytes[xpos+(p-xmin)]:=xval[p];
icount:=frcmin(icount,xminlen);//10may2020
end;
//## scanline ##
function tstr8.scanline(xfrom:longint):pointer;
begin
//defaults
result:=nil;
if (icount<=0) then exit;
//get
if (xfrom<0) then xfrom:=0 else if (xfrom>=icount) then xfrom:=icount-1;
result:=tpointer(@ibytes[xfrom]);
end;
//## getbytes ##
function tstr8.getbytes(x:longint):byte;//0-based
begin
if (x>=0) and (x<icount) then result:=ibytes[x] else result:=0;
end;
//## setbytes ##
procedure tstr8.setbytes(x:longint;xval:byte);
begin
if (x>=0) and (x<icount) then ibytes[x]:=xval;
end;
//## getbytes1 ##
function tstr8.getbytes1(x:longint):byte;//1-based
begin
if (x>=1) and (x<=icount) then result:=ibytes[x-1] else result:=0;
end;
//## setbytes1 ##
procedure tstr8.setbytes1(x:longint;xval:byte);
begin
if (x>=1) and (x<=icount) then ibytes[x-1]:=xval;
end;
//## getchars ##
function tstr8.getchars(x:longint):char;//D10 uses unicode here
begin
if (x>=0) and (x<icount) then result:=ichars[x] else result:=#0;
end;
//## setchars ##
procedure tstr8.setchars(x:longint;xval:char);//D10 uses unicode here
begin
if (x>=0) and (x<icount) then ichars[x]:=xval;
end;

//replace support --------------------------------------------------------------
//## setreplace ##
procedure tstr8.setreplace(x:tobject);
begin
try;clear;add(x);except;end;
end;
//## setreplacecmp8 ##
procedure tstr8.setreplacecmp8(x:comp);
begin
try;clear;setcmp8(0,x);except;end;
end;
//## setreplacecur8 ##
procedure tstr8.setreplacecur8(x:currency);
begin
try;clear;setcur8(0,x);except;end;
end;
//## setreplaceint4 ##
procedure tstr8.setreplaceint4(x:longint);
begin
try;clear;setint4(0,x);except;end;
end;
//## setreplacewrd2 ##
procedure tstr8.setreplacewrd2(x:word);
begin
try;clear;setwrd2(0,x);except;end;
end;
//## setreplacebyt1 ##
procedure tstr8.setreplacebyt1(x:byte);
begin
try;clear;setbyt1(0,x);except;end;
end;
//## setreplacechr1 ##
procedure tstr8.setreplacechr1(x:char);
begin
try;clear;setchr1(0,x);except;end;
end;
//## setreplacestr ##
procedure tstr8.setreplacestr(x:string);
begin
try;clear;setstr(0,length(x),x);except;end;
end;

//## tmask8 ####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//mmmmmmmmmmmmmmmmmmmmmmmmmmm
//## newmask8 ##
function newmask8(w,h:longint):tmask8;
begin
result:=nil;
result:=tmask8.create(w,h);
end;
//## create ##
constructor tmask8.create(w,h:longint);
begin
inherited create;
iwidth:=0;
iheight:=0;
icount:=0;
iblocksize:=sizeof(tmaskrgb96);
irowsize:=0;
icore:=newstr8(0);
irows:=newstr8(0);
resize(w,h);
end;
//## destroy ##
destructor tmask8.destroy;
begin
try
freeobj(@icore);
freeobj(@irows);
inherited destroy;
except;end;
end;
//## resize ##
function tmask8.resize(w,h:longint):boolean;
var
   p,dy,xcount,xrowsize:longint;
begin
try
//defaults
result:=false;
//init
w:=frcmin(w,1);
h:=frcmin(h,1);
xrowsize:=(w div iblocksize)*iblocksize;//round up to nearest block of 12b
if (xrowsize<>w) then inc(xrowsize,iblocksize);
xcount:=(h*xrowsize);
//get
if (xcount<>icore.len) then
   begin
   irowsize:=xrowsize;
   iwidth:=w;
   iheight:=h;
   icore.setlen(xcount);
   ibytes:=icore.core;
   icount:=xcount;
   //rows
   p:=0;
   irows.setlen(h*sizeof(pointer));
   irows96:=irows.core;
   irows8:=irows.core;
   for dy:=0 to (h-1) do
   begin
   irows96[dy]:=icore.scanline(p);
   inc(p,irowsize);
   end;//dy
   //successful
   result:=true;
   end
else result:=true;
except;end;
end;
//## cls ##
function tmask8.cls(xval:byte):boolean;
var
   sr96:pmaskrow96;
   dc96:tmaskrgb96;
   p,dx,dy,dw96:longint;
begin
try
//check
if (iwidth<1) or (iheight<1) then exit;
//init
for p:=0 to high(dc96) do dc96[p]:=xval;
//get
dw96:=irowsize div sizeof(dc96);
p:=0;
for dy:=0 to (iheight-1) do
begin
sr96:=rows[dy];
for dx:=0 to (dw96-1) do sr96[dx]:=dc96;
end;//dy
except;end;
end;
//## fill ##
function tmask8.fill(xarea:trect;xval:byte;xround:boolean):boolean;//29apr2020
var//Speed: 3,300ms -> 1,280ms -> 1,141ms -> 1,080ms
   sr96:pmaskrow96;
   dc96:tmaskrgb96;
   amin,xcorner,dxstart,dx96,xleft96,xright96,p,i,dx1,dx2,dx,dy,dw,dh,dw96:longint;
   bol1:boolean;
//xxxxxxxxxxxxxxxxxxxxxxx this needs to be replaced with "low__cornersolid()" for a consisten system wide approach - 16may2020
   //## xcorneroffset_solid ##
   procedure xcorneroffset_solid;
   begin
   //.int1 -> set offset to draw slightly rounded corners - 09apr2020
   xcorner:=0;
   case amin of
   3..10:if (dy=xarea.top) or (dy=xarea.bottom)           then xcorner:=1;//1px curved corner
   11..maxint:begin//multi-pixel curved corner
      if      (dy=xarea.top)     or (dy=xarea.bottom)     then xcorner:=3
      else if (dy=(xarea.top+1)) or (dy=(xarea.bottom-1)) then xcorner:=2
      else if (dy=(xarea.top+2)) or (dy=(xarea.bottom-2)) then xcorner:=1
      else if (dy=(xarea.top+3)) or (dy=(xarea.bottom-3)) then xcorner:=1
      else if (dy=(xarea.top+4)) or (dy=(xarea.bottom-4)) then xcorner:=1;
      end;
   end;//case
   end;
begin
try
//defaults
result:=true;

//check
if (iwidth<1) or (iheight<1) or (xarea.right<xarea.left) or (xarea.bottom<xarea.top) or (xarea.right<0) or (xarea.left>=iwidth) or (xarea.bottom<0) or (xarea.top>=iheight) then exit;

//init
xcorner:=0;
amin:=smallest(xarea.bottom-xarea.top+1,xarea.right-xarea.left+1);
dw:=iwidth;
dh:=iheight;
dw96:=irowsize div sizeof(dc96);
//.left
xleft96:=xarea.left div iblocksize;
if ((xleft96*iblocksize)>xarea.left) then dec(xleft96);
xleft96:=frcrange(xleft96,0,frcmin(dw96-1,0));
//.right
xright96:=xarea.right div iblocksize;
if ((xright96*iblocksize)<xarea.right) then inc(xright96);
xright96:=frcrange(xright96,xleft96,frcmin(dw96-1,0));
dxstart:=xleft96*iblocksize;

//get
for dy:=0 to (dh-1) do
begin
sr96:=rows[dy];
if (dy>=xarea.top) and (dy<=xarea.bottom) then
   begin
   //.xcorner -> set offset to draw slightly rounded corners - 09apr2020
   if xround then xcorneroffset_solid;
   dx1:=xarea.left+xcorner;
   dx2:=xarea.right-xcorner;

   //.dx
   dx:=dxstart;
   for dx96:=xleft96 to xright96 do
   begin
   bol1:=false;
   dc96:=sr96[dx96];

   //.0
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[0]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.1
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[1]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.2
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[2]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.3
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[3]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.4
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[4]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.5
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[5]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.6
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[6]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.7
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[7]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.8
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[8]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.9
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[9]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.10
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[10]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.11
   if (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[11]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //set
   if bol1 then sr96[dx96]:=dc96;
   end;//dx96
   end;
end;//dy
except;end;
end;
//xxxxxxxxxxxxxxxxxxxxxxxxxxx//mmmmmmmmmmmmmmmmmmmm
//## fill2 ##
function tmask8.fill2(xarea:trect;xval:byte;xround:boolean):boolean;//29apr2020
var//Speed: 3,300ms -> 1,280ms -> 1,141ms -> 1,080ms -> 700ms -> 672ms (5x faster) -> 500ms
   //Usage: Use in top-down window order -> draw topmost window, then next, then next, and last the bottommost window - 17may2020
   sr96:pmaskrow96;
   dc96:tmaskrgb96;
   amin,xcorner,dxstart,dx96,xleft96,xright96,p,i,dx1,dx2,dx,dy,dw,dh,dw96:longint;
   bol1:boolean;
//xxxxxxxxxxxxxxxxxxxxxxx this needs to be replaced with "low__cornersolid()" for a consisten system wide approach - 16may2020
   //## xcorneroffset_solid ##
   procedure xcorneroffset_solid;
   begin
   //.int1 -> set offset to draw slightly rounded corners - 09apr2020
   xcorner:=0;
   case amin of
   3..10:if (dy=xarea.top) or (dy=xarea.bottom)           then xcorner:=1;//1px curved corner
   11..maxint:begin//multi-pixel curved corner
      if      (dy=xarea.top)     or (dy=xarea.bottom)     then xcorner:=3
      else if (dy=(xarea.top+1)) or (dy=(xarea.bottom-1)) then xcorner:=2
      else if (dy=(xarea.top+2)) or (dy=(xarea.bottom-2)) then xcorner:=1
      else if (dy=(xarea.top+3)) or (dy=(xarea.bottom-3)) then xcorner:=1
      else if (dy=(xarea.top+4)) or (dy=(xarea.bottom-4)) then xcorner:=1;
      end;
   end;//case
   end;
begin
try
//defaults
result:=true;

//check
if (iwidth<1) or (iheight<1) or (xarea.right<xarea.left) or (xarea.bottom<xarea.top) or (xarea.right<0) or (xarea.left>=iwidth) or (xarea.bottom<0) or (xarea.top>=iheight) then exit;

//init
xcorner:=0;
amin:=smallest(xarea.bottom-xarea.top+1,xarea.right-xarea.left+1);
dw:=iwidth;
dh:=iheight;
dw96:=irowsize div sizeof(dc96);
//.left
xleft96:=xarea.left div iblocksize;
if ((xleft96*iblocksize)>xarea.left) then dec(xleft96);
xleft96:=frcrange(xleft96,0,frcmin(dw96-1,0));
//.right
xright96:=xarea.right div iblocksize;
if ((xright96*iblocksize)<xarea.right) then inc(xright96);
xright96:=frcrange(xright96,xleft96,frcmin(dw96-1,0));
dxstart:=xleft96*iblocksize;

//get
for dy:=0 to (dh-1) do
begin
sr96:=rows[dy];
if (dy>=xarea.top) and (dy<=xarea.bottom) then
   begin
   //.xcorner -> set offset to draw slightly rounded corners - 09apr2020
   if xround then xcorneroffset_solid;
   dx1:=xarea.left+xcorner;
   dx2:=xarea.right-xcorner;

   //.dx
   dx:=dxstart;
   for dx96:=xleft96 to xright96 do
   begin
   bol1:=false;
   dc96:=sr96[dx96];

   //.0
   if (dc96[0]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[0]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.1
   if (dc96[1]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[1]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.2
   if (dc96[2]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[2]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.3
   if (dc96[3]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[3]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.4
   if (dc96[4]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[4]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.5
   if (dc96[5]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[5]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.6
   if (dc96[6]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[6]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.7
   if (dc96[7]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[7]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.8
   if (dc96[8]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[8]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.9
   if (dc96[9]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[9]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.10
   if (dc96[10]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[10]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //.11
   if (dc96[11]=0) and (dx>=dx1) and (dx<=dx2) then
      begin
      dc96[11]:=xval;
      bol1:=true;
      end;//dx
   inc(dx);
   //set
   if bol1 then sr96[dx96]:=dc96;
   end;//dx96
   end;
end;//dy
except;end;
end;
//## mrow ##
procedure tmask8.mrow(dy:longint);
begin//speed: 4,094ms -> 3,400ms -> 2,100ms -> 2,000ms
ilastdy:=dy*irowsize;
end;
//## mval ##
function tmask8.mval(dx:longint):byte;
begin//speed: 4,094ms -> 3,400ms -> 2,100ms -> 2,000ms -> 1350ms
result:=ibytes[ilastdy+dx];
end;
//## mval2 ##
function tmask8.mval2(dx,dy:longint):byte;
begin//speed: 4,094ms -> 3,400ms -> 2,100ms -> 2,000ms
result:=ibytes[(dy*irowsize)+dx];
end;

//## tbaseform #################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//bbbbbbbbbbbbbbbbbbbbbbbbb
//## create ##
constructor tbaseform.create(aowner:tcomponent);
begin
createnew(aowner);
iwheelv:=0;
wheelv:=0;
onwheel:=nil;
end;
//## wmerasebkgnd ##
procedure tbaseform.wmerasebkgnd(var message:twmerasebkgnd);
begin
try
if not isiconic(Handle) then message.result:=1
else
   begin
   message.msg:=wm_iconerasebkgnd;
   defaulthandler(message);
   end;//end of if
except;end;
end;
//## wmmousewheel ##
procedure tbaseform.wmmousewheel(var Message:tmessage);
var//Tested and correct on XP HOME on 05-FEB-2006
   a:tint4;
   b:smallint;
   tmp:longint;
begin
try
//handled
message.result:=0;
//get
a.val:=message.wparam;
b:=smallint(a.wrds[1]);
iwheelv:=iwheelv+(b/120);
tmp:=round(iwheelv);
iwheelv:=iwheelv-tmp;//reset
//set
wheelv:=tmp;
if (tmp<>0) and assigned(onwheel) then onwheel(self);
except;end;
end;

//## thelpviewer ###############################################################
//xxxxxxxxxxxxxxxxxxxxxxxx//hhhhhhhhhhhhhhhh
//## create ##
constructor thelpviewer.create;
var
   a:tstr8;
begin
inherited create;
a:=nil;
//vars
ibuildingcontrol:=true;
itimerbusy:=false;
itimerVH:=ms64;
ishift:=false;
ialt:=false;
ictrl:=false;
ispecial:=false;
imousedown:=false;
imouseright:=false;
//.form
iform:=tbaseform.create(nil);
with iform do
begin
caption:=programname+#32+'Help';
vertscrollbar.visible:=false;
horzscrollbar.visible:=false;
borderstyle:=bsSizeable;
bordericons:=[biSystemmenu];
keypreview:=true;
autoscroll:=false;
end;
//.v
iv:=tscrollbar.create(iform);
iv.parent:=iform;
iv.kind:=sbVertical;
iv.visible:=true;
//.core
low__wordcore(icore,'init','');
//..claude colors
if (sys_help_text2<>clnone) or (sys_help_header2<>clnone) then
   begin
   icore.useclaudecolors:=true;
   icore.claude_text1:=sys_help_text2;
   icore.claude_text2:=sys_help_text2;
   icore.claude_header1:=sys_help_header2;
   icore.claude_header2:=sys_help_header2;
   end;
//..other colors
icore.pagecolor:=rgb(255,255,255);
if (sys_help_bgcolor<>clnone) then icore.pagecolor:=sys_help_bgcolor;
icore.viewcolor:=icore.pagecolor;
icore.feather:=1;
icore.barshow:=true;
icore.showcursor:=false;
icore.readonly:=true;//read-only
{}//yyy
try
a:=newstr8(0);
a.aadd(syshelp);
low__wordcore(icore,'ioset',a.text);
freeobj(@a);
except;end;
low__wordcore(icore,'cursorpos','0');
xinit__bar;
//.timer
itimer:=ttimer.create(iform);
itimer.enabled:=false;
itimer.interval:=30;
itimer.ontimer:=_ontimer;
//events
iform.onwheel     :=_onwheel;
iform.onkeydown   :=_onkeydown;
iform.onkeyup     :=_onkeyup;
iform.onkeypress  :=_onkeypress;
iform.onmousedown :=_onmousedown;
iform.onmouseup   :=_onmouseup;
iform.onmousemove :=_onmousemove;
iform.onresize    :=_onresize;
iform.onpaint     :=_onpaint;
iv.onchange       :=_onpos;

//defaults
ibuildingcontrol:=false;
itimer.enabled:=true;
//free
freeobj(@a);
end;
//## destroy ##
destructor thelpviewer.destroy;
begin
try
ibuildingcontrol:=true;
itimer.enabled:=false;
iform.hide;
freeobj(@iform);
inherited destroy;
except;end;
end;
//## xinit__bar ##
procedure thelpviewer.xinit__bar;
begin
try
low__barcore(icore.bar,'init','');//show images + captions + autoheight -> by default
low__barcore(icore.bar,'clear','');//incase proc is called more than once - 06dec2019
//.buttons
low__barcore__add(icore.bar,'Copy Text',low__findimageb('copy20.teh'),'copy.txtwin',0,true);
low__barcore__add(icore.bar,'Smaller',low__findimageb('less20.teh'),'all.-',0,true);
low__barcore__add(icore.bar,'Larger',low__findimageb('more20.teh'),'all.+',0,true);
//.now supports "Claude colors" as a toolbar option
case icore.useclaudecolors of
true:begin
   //Note: When using Claude colors we can't change the font name as this is what identifies the color as a Claude color - 14jul2020
   low__barcore__add(icore.bar,'B/W',low__findimageb('bw20.teh'),'useclaudecolors',0,true);//toggles the value
   end;
false:begin
   low__barcore__add(icore.bar,'Arial','','all.arial',0,true);
   low__barcore__add(icore.bar,'Courier','','all.courier',0,true);
   end;
end;
//xxxxxlow__barcore__add(icore.bar,'SelAll','','selectall',0,true);
except;end;
end;
//## _onwheel ##
procedure thelpviewer._onwheel(sender:tobject);
begin
try;iv.position:=iv.position-iform.wheelv;except;end;
end;
//## _onkeydown ##
procedure thelpviewer._onkeydown(sender:tobject;var key:word;shift:tshiftstate);
begin
try
//init
low__resetkeyboardidle;
ishift:=(ssShift in shift);
ialt:=(ssAlt in shift);
ictrl:=(ssCtrl in shift);
ispecial:=specialkey(key);
//special key
if ispecial then low__wordcore__keyboard(icore,ictrl,ialt,ishift,ispecial,safekey(key));
//disable scrollbar keyboard support
key:=0;
except;end;
end;
//## _onkeypress ##
procedure thelpviewer._onkeypress(sender:tobject;var key:char);
begin
try
//init
low__resetkeyboardidle;
//add character
if not ispecial then low__wordcore__keyboard(icore,ictrl,ialt,ishift,ispecial,ord(key));
except;end;
end;
//## _onkeyup ##
procedure thelpviewer._onkeyup(sender:tobject;var key:word;shift:tshiftstate);
begin
try
//init
low__resetkeyboardidle;
//sync
ishift:=(ssShift in shift);
ialt:=(ssAlt in shift);
ictrl:=(ssCtrl in shift);
ispecial:=false;
except;end;
end;
//## _onmousedown ##
procedure thelpviewer._onmousedown(sender:tobject;button:tmousebutton;shift:tshiftState;x,y:integer);
begin
try
imousedown:=true;
imouseright:=(button<>mbLeft) and (button<>mbMiddle);
low__wordcore__mouse(icore,x,y,imousedown,imouseright);
except;end;
end;
//## _onmouseup ##
procedure thelpviewer._onmouseup(sender:tobject;button:tmousebutton;shift:tshiftState;x,y:integer);
begin
try
imouseright:=(button<>mbLeft) and (button<>mbMiddle);
low__wordcore__mouse(icore,x,y,false,imouseright);
imousedown:=false;
except;end;
end;
//## _onmousemove ##
procedure thelpviewer._onmousemove(sender:tobject;shift:tshiftstate;x,y:integer);
begin
try
low__wordcore__mouse(icore,x,y,imousedown,imouseright);
except;end;
end;
//## _onpos ##
procedure thelpviewer._onpos(sender:tobject);
begin
try;low__wordcore(icore,'vpos',inttostr(iv.position));except;end;
end;
//## _onpaint ##
procedure thelpviewer._onpaint(sender:tobject);
begin
try
if ibuildingcontrol or (not low__wordcore(icore,'paintlock','1')) then
   begin
   low__wordcore(icore,'mustpaint','1');//retry later
   exit;
   end;
//paint
low__wordcore__paintcanvas32(icore,iform.canvas,iv.left-1,iform.clientheight);
except;end;
try;low__wordcore(icore,'paintlock','0');except;end;//unlock paint
end;
//## _onresize ##
procedure thelpviewer._onresize(sender:tobject);
var
   vw:longint;
begin
try
vw:=iv.width;
iv.setbounds(iform.clientwidth-vw,0,vw,iform.clientheight);

except;end;
end;
//## _ontimer ##
procedure thelpviewer._ontimer(sender:tobject);
var
   int1,int2:longint;
begin
try
if itimerbusy then exit else itimerbusy:=true;
//sync ontop
if (application.mainform<>nil) then
   begin
   //Note: ONTOP only works for the main form, any subforms will destroy it's
   //      proper function - 08jun2020
   //was:   if (application.mainform.formstyle<>iform.formstyle) then iform.formstyle:=application.mainform.formstyle;
   end;

//timer event - high speed
low__wordcore(icore,'timer','');

//v+h scrollbars
if (ms64>=itimerVH) then //xxxxxxxxxxxxxxxxxxxxor low__wordcore(icore,'mustpaint','') then//information required immediately if we are PAINTING - 05aug2014
   begin
   //.view width/height
   low__wordcore(icore,'pagewidth',inttostr(iv.left-(2*10)));
   low__wordcore(icore,'viewwidth',inttostr(iv.left));
   //was: if scrollbar2.visible then int1:=scrollbar2.Top else int1:=clientheight;
   int1:=iform.clientheight;
   low__wordcore(icore,'viewheight',inttostr(int1));
   //.havefocus
   //was: low__wordcore(icore,'havefocus',bn(focused or scrollbar1.focused or scrollbar2.focused));
   low__wordcore(icore,'havefocus',bn(iform.focused or iv.focused));
   //.v
   if low__wordcore(icore,'vhostsync','') then
      begin
      low__wordcore(icore,'vhostsync','0');
      int1:=low__wordcore2(icore,'vpos','');
      int2:=low__wordcore2(icore,'vmax','');
      iv.setparams(int1,0,int2);
      end;
   //.h
   if low__wordcore(icore,'hhostsync','') then
      begin
      low__wordcore(icore,'hhostsync','0');
      int1:=low__wordcore2(icore,'hpos','');
      int2:=low__wordcore2(icore,'hmax','');
      //was: scrollbar2.setparams(int1,0,int2);
      //scrollbar2.visible:=low__wordcore(icore,'hshow','');
      end;
   //.line + column status
//   ilncount:=low__wordcore2(icore,'linecount','');
//   iln:=low__wordcore2(icore,'line','');
//   icol:=low__wordcore2(icore,'col','');
   //reset
   itimerVH:=ms64+200;
   end;

//paint event
if low__wordcore(icore,'canpaint','')  and low__wordcore(icore,'mustpaint','') then
   begin
   low__wordcore(icore,'mustpaint','0');
   iform.repaint;
   end;

//debug
{
caption:=
inttostr(ilncount)+'_'+inttostr(iln)+'_'+inttostr(icol)+'<<'+ms64str+'>>'+
 bn(icore.showcursor)+bn(icore.havefocus)+bn(icore.flashcursor)+bn(icore.idleref>=ms64)+
 '>'+floattostr(iwheelv);
{}//xxxxxxxxxxxxx

except;end;
//unlock
try;itimerbusy:=false;except;end;
end;
//## show ##
procedure thelpviewer.show;
begin
try;iform.show;except;end;
end;
//## center ##
procedure thelpviewer.center;
begin
try;low__centerform(iform);except;end;
end;
//## setsize ##
procedure thelpviewer.setsize(dw,dh:longint);
begin
try;setbounds(iform.left,iform.top,dw,dh);except;end;
end;
//## setbounds ##
procedure thelpviewer.setbounds(dx,dy,dw,dh:longint);
begin
try;iform.setbounds(dx,dy,dw,dh);except;end;
end;

end.
