unit Clic5;
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
//## Name: CORE
//## Desciption: Root application support code for low-high application construction
//##
//##  OBJECTS:
//##
//## =========================================================================================
//## | Name              | Base Type   | Version   | Date        | Desciption
//## |-- GENERAL --------|-------------|-----------|-------------|----------------------------
//## | TScan             | <none>      | 1.00.033  | 07-MAR-2004 | File CheckCode Generator/Checker
//## | TZFile            | <none>      | 1.00.023  | 17-MAR-2004 | Command Line Argument Supliment
//## | TPaths            | <none>      | 1.00.087  | 09-MAR-2004 | Path Management
//## | TGeneral          | <none>      | 1.00.092  | 17-MAR-2004 | General Low Level Routines
//## | TLI               | TComponent  | 1.00.001  | 07-MAR-2004 | TLanguage item
//## | TLanguage         | TComponent  | 1.00.070  | 17-MAR-2004 | [mem fix] Language Support
//## | Error Conts       | <n/a>       | 1.00.007  | 22-FEB-2002 | Standard Error Messages
//## | Image Printer     | <n/a>       | 1.00.011  |        2002 | Image Printer Launcher Routines
//## | ECap              | <n/a>       | 1.00.021  | 12-NOV-2002 | Random String Encrypter - Valid Input/Output range 14-255 ASCII
//## |-- MAIN -----------|-------------|-----------|-------------|----------------------------
//## | Main              | <n/a>       | 1.00.083  | 18-MAR-2004 | Vital Support Unit for Small Applications
//## | TLiteLanguage     | <none>      | 1.00.041  | 17-MAR-2004 | [mem fix] Language Support (Version 2.0)
//## | TMsgList          | <none>      | 1.00.029  | 17-MAR-2004 | Message Handler System
//## | TLiteForm         | <none>      | 1.00.166  | 17-MAR-2004 | Compact "TForm" Version
//## | TApp              | <none>      | 1.00.039  | 17-MAR-2004 | Compact "TApplication" Version
//## |-- ZIP/HELP -------|-------------|-----------|-------------|----------------------------
//## | (deleted)TBoxItem          | TComponent  | 1.00.004  | 07-MAR-2004 | TZipBox data item
//## | (deleted)TZipBox           | <none>      | 1.00.141  | 17-MAR-2004 | Multi-File Packer & Compressor
//## | TZipHandler       | <none>      | 1.00.035  | 07-MAR-2004 | Enhanced Zip/Unzip Support
//## | Delphi ZLIB       | <n/a>       |        -  |           - |
//## |-- ADDITIONAL -----|-------------|-----------|-------------|----------------------------
//## | TStrBin           | <none>      | 1.00.066  | 07-MAR-2004 | Str-IO System: Structured IO Reader/Writer (supports Zip,Ke and plain modes v1/v2}
//## | TBinaryFile       | <none>      | 1.00.033  | 07-MAR-2004 | Simplified file data management
//## | TController       | <none>      | 1.00.046  | 17-MAR-2004 | Automatically arranges/sizes visual controls
//## | TMisc             | <none>      | 1.00.023  | 07-MAR-2004 | Misc. additional general support
//## | TFindDlg          | <none>      | 1.00.050  | 08-MAR-2004 | Universal Find Dialog with history list and status information
//## | TInputDlg         | <none>      | 1.00.012  | 08-MAR-2004 | Universal Text Input Dialog (instead of "InputQuery"}
//## | Blaiz Enterprises Virtual Folders - v1.00.112, 15-NOV-2005
//## =========================================================================================
//##
//## Number of Items: 23
//## Version: 1.00.1240 (was 1.00.1132) (+24 self)
//## Date: 15-NOV-2005
//## Lines: 11,087
//## Verification: 1.00.022, 18-MAR-2004
//## Language Enabled {Dual Support, default is "TLiteLanguage"}
//## Copyright (c) 1997-2004 Blaiz Enterprises
//##############################################################################
//## General.AppRunning - Checked and Updated

interface

Uses
  Windows, Forms, Menus, Controls, SysUtils, Classes, ShellApi,
  ShlObj, Graphics, Clipbrd, messages, stdctrls, extctrls,
  comctrls, clic11;

//[1]##################### GENERAL #############################################

 function MessageBox(hWnd :Integer;lpText:String;lpCaption:String;wType:Integer):Integer;stdcall;external 'USER32.DLL' name 'MessageBoxA';

const
     {Standard Safe Return Code}
     RCode=#13+#10;
     {Standard Error Messages}
     gecFileInUse='File in use';
     gecNotFound='Not found';
     gecBadFileName='Bad filename';
     gecFileNotFound='File not found';
     gecUnknownFormat='Unknown format';
     gecTaskCancelled='Task cancelled';
     gecPathNotFound='Path not found';
     gecOutOfMemory='Out of memory';
     gecIndexOutOfRange='Index out of range';
     gecFailedToCopy='Failed to copy';
     gecFailedToCut='Failed to cut';
     gecFailedToPaste='Failed to paste';
     gecFailedToUndo='Failed to undo';
     gecUnexpectedError='Unexpected error';
     gecDataCorrupt='Data corrupt';
     gecUnsupportedFormat='Unsupported format';
     gecAccessDenied='Access Denied';{04/11/2002}
     gecOutOfDiskSpace='Out of disk space';
     gecAProgramExistsWithThatName='A program exists with that name';
     gecUseAnother='Use another';
     gecSendToFailed='Send to failed';
     gecCapacityReached='Capacity reached';
     gecNoFilesFound='No files found';
     gecUnsupportedEncoding='Unsupported encoding';
     gecUnsupportedDecoding='Unsupported decoding';
     gecEmpty='Empty';
     gecLocked='Locked';
     gecTaskFailed='Task failed';
     gecTaskSuccessful='Task successful';
     //New 16/08/2002
     gecVirusWarning='Virus Warning - Tampering detected';
     gecTaskTimedOut='Task Timed Out';
     gecSystemBusyTryAgainLater='System busy - try again later';
     gecIncorrectUnlockInformation='Incorrect Unlock Information';//Translate('Incorrect Unlock Information');
     gecOk='OK';//translate('OK');
     gecReadOnly='Read Only';//translate('Read Only');
     gecBusy='Busy';//translate('Busy');
     gecReady='Ready';//translate('Ready');
     gecWorking='Working';//translate('Working');
     gecSearching='Searching';//translate('Searching');


//-- Blaiz Enterprises - Virtual Folders ---------------------------------------
//
//Important Note:
//Program categories are no longer required as programs now run in portable
//mode only as of 07mar2020.
//
   //.main
   bvfFiles                  ='files\';
   //.categories
   bvfClipboard              ='clipboard\';
   bvfLogs                   ='logs\';
   bvfHelp                   ='help\';
   bvfActive                 ='locks\';//not for user
   bvfSettings               ='settings\';//not for user
   bvfLicenses               ='licenses\';//not for user
   bvfSnippet                ='snippet\';//not for user
   bvfTemp                   ='temp\';//not for user
   bvfCommOLD                ='comm\';//not for user
   bvfSchemesOLD             ='schemes\';//old v2 (EATS)
   bvfLanguage               ='languages\';
   //.files
   bvfAnimations             ='animations\';
   bvfCursors                ='cursors\';
   bvfDocuments              ='documents\';
   bvfFrames                 ='frames\';
   bvfMusic                  ='music\';
   bvfPictures               ='pictures\';
   bvfShades                 ='shades\';
   bvfSchemes                ='schemes\';//new schemes v3 (DSD)
   bvfTextBrushs             ='textbrushes\';
   bvfMiscellaneous          ='misc\';//general content
   bvfCards                  ='card\';//ArtCards, PhotoCards and EBooks

{TZFile}
     //modes
     zfmcNil=0;
     zfmcDestroyFile=1;
     zfmcMax=1;
     //HDR
     zfhcHDR='ZFILE';{5 chars}
     //Keys
     zfkc1=')(87q435[9aet''2390780Q45,OIU9[q45,''ouew780350-[8p[lcxvmneriutyopjkyuTIj4''opu&*%32^JE(]a50-ewr87pi7^&(5135 oi''uer90[twq34~!907135[m o[y,oiu[04,hj843oaier89[36jh89[6se87[0q54j,h59p[w56';

{TGeneral}
     //modes
     glseEncrypt=0;
     glseDecrypt=1;
     glseTextEncrypt=2;
     glseTextDecrypt=3;
     //other
     glseEDK='2-13-09afdklJ*[q-02490-9123poasdr90q34[9q2u3-[9234[9u0w3689yq28901iojIOJHPIae;riqu58pq5uq9531asdo';
     //TGeneralSortSet
     glssRef=0;{create ref}
     glssRefUC=1;{create ref using uppercase}
     glssDup=2;{allow duplicates}
     glssNull=3;{allow null}

{TLanguageItems}
     //core
     lgicMaxIndex=3999;

{TFrameInfo}
     //core
     frmcMaxWidth=255;{date: 01-NOV-2003}

{Windows - API's}
     MIIM_STATE = 1;
     MIIM_ID = 2;
     MIIM_SUBMENU = 4;
     MIIM_CHECKMARKS = 8;
     MIIM_TYPE = $10;
     MIIM_DATA = $20;

     //PeekMessage() Options
     PM_NOREMOVE = 0;
     PM_REMOVE = 1;
     PM_NOYIELD = 2;

     //Cursor identifiers
     crDefault     = 0;
     crNone        = -1;
     crArrow       = -2;
     crCross       = -3;
     crIBeam       = -4;
     crSize        = -5;
     crSizeNESW    = -6;
     crSizeNS      = -7;
     crSizeNWSE    = -8;
     crSizeWE      = -9;
     crUpArrow     = -10;
     crHourGlass   = -11;
     crDrag        = -12;
     crNoDrop      = -13;
     crHSplit      = -14;
     crVSplit      = -15;
     crMultiDrag   = -16;
     crSQLWait     = -17;
     crNo          = -18;
     crAppStart    = -19;
     crHelp        = -20;
     crHandPoint   = -21;

     //File open modes
     fmOpenRead       = $0000;
     fmOpenWrite      = $0001;
     fmOpenReadWrite  = $0002;
     fmShareCompat    = $0000;
     fmShareExclusive = $0010;
     fmShareDenyWrite = $0020;
     fmShareDenyRead  = $0030;
     fmShareDenyNone  = $0040;

     //File attribute constants
     faReadOnly  = $00000001;
     faHidden    = $00000002;
     faSysFile   = $00000004;
     faVolumeID  = $00000008;
     faDirectory = $00000010;
     faArchive   = $00000020;
     faAnyFile   = $0000003F;

     //Menu flags for AddCheckEnableMenuItem()
     MF_INSERT = 0;
     MF_CHANGE = $80;
     MF_APPEND = $100;
     MF_DELETE = $200;
     MF_REMOVE = $1000;
     MF_BYCOMMAND = 0;
     MF_BYPOSITION = $400;
     MF_SEPARATOR = $800;
     MF_ENABLED = 0;
     MF_GRAYED = 1;
     MF_DISABLED = 2;
     MF_UNCHECKED = 0;
     MF_CHECKED = 8;
     MF_USECHECKBITMAPS = $200;
     MF_STRING = 0;
     MF_BITMAP = 4;
     MF_OWNERDRAW = $100;
     MF_POPUP = $10;
     MF_MENUBARBREAK = $20;
     MF_MENUBREAK = $40;
     MF_UNHILITE = 0;
     MF_HILITE = $80;
     MF_DEFAULT = $1000;
     MF_SYSMENU = $2000;
     MF_HELP = $4000;
     MF_RIGHTJUSTIFY = $4000;
     MF_MOUSESELECT = $8000;
     MF_END = $80;          { Obsolete -- only used by old RES files }
     MFT_STRING = MF_STRING;
     MFT_BITMAP = MF_BITMAP;
     MFT_MENUBARBREAK = MF_MENUBARBREAK;
     MFT_MENUBREAK = MF_MENUBREAK;
     MFT_OWNERDRAW = MF_OWNERDRAW;
     MFT_RADIOCHECK = $200;
     MFT_SEPARATOR = MF_SEPARATOR;
     MFT_RIGHTORDER = $2000;
     MFT_RIGHTJUSTIFY = MF_RIGHTJUSTIFY;

     //Menu flags for AddCheckEnableMenuItem()
     MFS_GRAYED = 3;
     MFS_DISABLED = MFS_GRAYED;
     MFS_CHECKED = MF_CHECKED;
     MFS_HILITE = MF_HILITE;
     MFS_ENABLED = MF_ENABLED;
     MFS_UNCHECKED = MF_UNCHECKED;
     MFS_UNHILITE = MF_UNHILITE;
     MFS_DEFAULT = MF_DEFAULT;

     //PopupMenu Alignment
     TPM_LEFTBUTTON = 0;
     TPM_RIGHTBUTTON = 2;
     TPM_LEFTALIGN = 0;
     TPM_CENTERALIGN = 4;
     TPM_RIGHTALIGN = 8;

     //Ternary raster operations
     SRCCOPY     = $00CC0020;     { dest = source                 }
     SRCPAINT    = $00EE0086;     { dest = source OR dest          }
     SRCAND     = $008800C6;     { dest = source AND dest          }
     SRCINVERT   = $00660046;     { dest = source XOR dest          }
     SRCERASE    = $00440328;     { dest = source AND (NOT dest )    }
     NOTSRCCOPY  = $00330008;     { dest = (NOT source)            }
     NOTSRCERASE = $001100A6;     { dest = (NOT src) AND (NOT dest)  }
     MERGECOPY   = $00C000CA;     { dest = (source AND pattern)     }
     MERGEPAINT  = $00BB0226;     { dest = (NOT source) OR dest     }
     PATCOPY     = $00F00021;     { dest = pattern                }
     PATPAINT    = $00FB0A09;     { dest = DPSnoo                 }
     PATINVERT   = $005A0049;     { dest = pattern XOR dest         }
     DSTINVERT   = $00550009;     { dest = (NOT dest)              }
     BLACKNESS   = $00000042;     { dest = BLACK                  }
     WHITENESS   = $00FF0062;     { dest = WHITE                  }

     //StretchBlt() modes
     BLACKONWHITE = 1;
     WHITEONBLACK = 2;
     COLORONCOLOR = 3;
     HALFTONE = 4;
     MAXSTRETCHBLTMODE = 4;

     //System Menu Command Values
     SC_SIZE = 61440;
     SC_MOVE = 61456;
     SC_MINIMIZE = 61472;
     SC_MAXIMIZE = 61488;
     SC_NEXTWINDOW = 61504;
     SC_PREVWINDOW = 61520;
     SC_CLOSE = 61536;
     SC_VSCROLL = 61552;
     SC_HSCROLL = 61568;
     SC_MOUSEMENU = 61584;
     SC_KEYMENU = 61696;
     SC_ARRANGE = 61712;
     SC_RESTORE = 61728;
     SC_TASKLIST = 61744;
     SC_SCREENSAVE = 61760;
     SC_HOTKEY = 61776;
     SC_DEFAULT = 61792;
     SC_MONITORPOWER = 61808;
     SC_CONTEXTHELP = 61824;
     SC_SEPARATOR = 61455;

     //Window Messages
     WM_NULL           = $0000;
     WM_CREATE          = $0001;
     WM_DESTROY         = $0002;
     WM_MOVE           = $0003;
     WM_SIZE           = $0005;
     WM_ACTIVATE        = $0006;
     WM_SETFOCUS        = $0007;
     WM_KILLFOCUS       = $0008;
     WM_ENABLE          = $000A;
     WM_SETREDRAW       = $000B;
     WM_SETTEXT         = $000C;
     WM_GETTEXT         = $000D;
     WM_GETTEXTLENGTH    = $000E;
     WM_PAINT          = $000F;
     WM_CLOSE          = $0010;
     WM_QUERYENDSESSION  = $0011;
     WM_QUIT           = $0012;
     WM_QUERYOPEN       = $0013;
     WM_ERASEBKGND      = $0014;
     WM_SYSCOLORCHANGE   = $0015;
     WM_ENDSESSION      = $0016;
     WM_SYSTEMERROR     = $0017;
     WM_SHOWWINDOW      = $0018;
     WM_CTLCOLOR        = $0019;
     WM_WININICHANGE     = $001A;
     WM_SETTINGCHANGE = WM_WININICHANGE;
     WM_DEVMODECHANGE    = $001B;
     WM_ACTIVATEAPP     = $001C;
     WM_FONTCHANGE      = $001D;
     WM_TIMECHANGE      = $001E;
     WM_CANCELMODE      = $001F;
     WM_SETCURSOR       = $0020;
     WM_MOUSEACTIVATE    = $0021;
     WM_CHILDACTIVATE    = $0022;
     WM_QUEUESYNC       = $0023;
     WM_GETMINMAXINFO    = $0024;
     WM_PAINTICON       = $0026;
     WM_ICONERASEBKGND   = $0027;
     WM_NEXTDLGCTL      = $0028;
     WM_SPOOLERSTATUS    = $002A;
     WM_DRAWITEM        = $002B;
     WM_MEASUREITEM     = $002C;
     WM_DELETEITEM      = $002D;
     WM_VKEYTOITEM      = $002E;
     WM_CHARTOITEM      = $002F;
     WM_SETFONT         = $0030;
     WM_GETFONT         = $0031;
     WM_SETHOTKEY       = $0032;
     WM_GETHOTKEY       = $0033;
     WM_QUERYDRAGICON    = $0037;
     WM_COMPAREITEM     = $0039;
     WM_COMPACTING      = $0041;
     WM_COMMNOTIFY      = $0044;    { obsolete in Win32}
     WM_WINDOWPOSCHANGING = $0046;
     WM_WINDOWPOSCHANGED = $0047;
     WM_POWER          = $0048;
     WM_COPYDATA        = $004A;
     WM_CANCELJOURNAL    = $004B;
     WM_NOTIFY          = $004E;
     WM_INPUTLANGCHANGEREQUEST = $0050;
     WM_INPUTLANGCHANGE  = $0051;
     WM_TCARD          = $0052;
     WM_HELP           = $0053;
     WM_USERCHANGED     = $0054;
     WM_NOTIFYFORMAT     = $0055;
     WM_CONTEXTMENU     = $007B;
     WM_STYLECHANGING    = $007C;
     WM_STYLECHANGED     = $007D;
     WM_DISPLAYCHANGE    = $007E;
     WM_GETICON         = $007F;
     WM_SETICON         = $0080;
     WM_NCCREATE        = $0081;
     WM_NCDESTROY       = $0082;
     WM_NCCALCSIZE      = $0083;
     WM_NCHITTEST       = $0084;
     WM_NCPAINT         = $0085;
     WM_NCACTIVATE      = $0086;
     WM_GETDLGCODE      = $0087;
     WM_NCMOUSEMOVE     = $00A0;
     WM_NCLBUTTONDOWN    = $00A1;
     WM_NCLBUTTONUP     = $00A2;
     WM_NCLBUTTONDBLCLK  = $00A3;
     WM_NCRBUTTONDOWN    = $00A4;
     WM_NCRBUTTONUP     = $00A5;
     WM_NCRBUTTONDBLCLK  = $00A6;
     WM_NCMBUTTONDOWN    = $00A7;
     WM_NCMBUTTONUP     = $00A8;
     WM_NCMBUTTONDBLCLK  = $00A9;
     WM_KEYFIRST        = $0100;
     WM_KEYDOWN         = $0100;
     WM_KEYUP          = $0101;
     WM_CHAR           = $0102;
     WM_DEADCHAR        = $0103;
     WM_SYSKEYDOWN      = $0104;
     WM_SYSKEYUP        = $0105;
     WM_SYSCHAR         = $0106;
     WM_SYSDEADCHAR     = $0107;
     WM_KEYLAST         = $0108;
     WM_INITDIALOG      = $0110;
     WM_COMMAND         = $0111;
     WM_SYSCOMMAND      = $0112;
     WM_TIMER          = $0113;
     WM_HSCROLL         = $0114;
     WM_VSCROLL         = $0115;
     WM_INITMENU        = $0116;
     WM_INITMENUPOPUP    = $0117;
     WM_MENUSELECT      = $011F;
     WM_MENUCHAR        = $0120;
     WM_ENTERIDLE       = $0121;
     WM_CTLCOLORMSGBOX   = $0132;
     WM_CTLCOLOREDIT     = $0133;
     WM_CTLCOLORLISTBOX  = $0134;
     WM_CTLCOLORBTN     = $0135;
     WM_CTLCOLORDLG     = $0136;
     WM_CTLCOLORSCROLLBAR= $0137;
     WM_CTLCOLORSTATIC   = $0138;
     WM_MOUSEFIRST      = $0200;
     WM_MOUSEMOVE       = $0200;
     WM_LBUTTONDOWN     = $0201;
     WM_LBUTTONUP       = $0202;
     WM_LBUTTONDBLCLK    = $0203;
     WM_RBUTTONDOWN     = $0204;
     WM_RBUTTONUP       = $0205;
     WM_RBUTTONDBLCLK    = $0206;
     WM_MBUTTONDOWN     = $0207;
     WM_MBUTTONUP       = $0208;
     WM_MBUTTONDBLCLK    = $0209;
     WM_MOUSEWHEEL      = $020A;
     WM_MOUSELAST       = $020A;
     WM_PARENTNOTIFY     = $0210;
     WM_ENTERMENULOOP    = $0211;
     WM_EXITMENULOOP     = $0212;
     WM_NEXTMENU        = $0213;
     WM_SIZING          = 532;
     WM_CAPTURECHANGED   = 533;
     WM_MOVING          = 534;
     WM_POWERBROADCAST   = 536;
     WM_DEVICECHANGE     = 537;
     WM_IME_STARTCOMPOSITION       = $010D;
     WM_IME_ENDCOMPOSITION         = $010E;
     WM_IME_COMPOSITION           = $010F;
     WM_IME_KEYLAST               = $010F;
     WM_IME_SETCONTEXT            = $0281;
     WM_IME_NOTIFY               = $0282;
     WM_IME_CONTROL               = $0283;
     WM_IME_COMPOSITIONFULL        = $0284;
     WM_IME_SELECT               = $0285;
     WM_IME_CHAR                 = $0286;
     WM_IME_KEYDOWN               = $0290;
     WM_IME_KEYUP                = $0291;
     WM_MDICREATE       = $0220;
     WM_MDIDESTROY      = $0221;
     WM_MDIACTIVATE     = $0222;
     WM_MDIRESTORE      = $0223;
     WM_MDINEXT         = $0224;
     WM_MDIMAXIMIZE     = $0225;
     WM_MDITILE         = $0226;
     WM_MDICASCADE      = $0227;
     WM_MDIICONARRANGE   = $0228;
     WM_MDIGETACTIVE     = $0229;
     WM_MDISETMENU      = $0230;
     WM_ENTERSIZEMOVE    = $0231;
     WM_EXITSIZEMOVE     = $0232;
     WM_DROPFILES       = $0233;
     WM_MDIREFRESHMENU   = $0234;
     WM_MOUSEHOVER      = $02A1;
     WM_MOUSELEAVE      = $02A3;
     WM_CUT            = $0300;
     WM_COPY           = $0301;
     WM_PASTE          = $0302;
     WM_CLEAR          = $0303;
     WM_UNDO           = $0304;
     WM_RENDERFORMAT     = $0305;
     WM_RENDERALLFORMATS = $0306;
     WM_DESTROYCLIPBOARD = $0307;
     WM_DRAWCLIPBOARD    = $0308;
     WM_PAINTCLIPBOARD   = $0309;
     WM_VSCROLLCLIPBOARD = $030A;
     WM_SIZECLIPBOARD    = $030B;
     WM_ASKCBFORMATNAME  = $030C;
     WM_CHANGECBCHAIN    = $030D;
     WM_HSCROLLCLIPBOARD = $030E;
     WM_QUERYNEWPALETTE  = $030F;
     WM_PALETTEISCHANGING= $0310;
     WM_PALETTECHANGED   = $0311;
     WM_HOTKEY          = $0312;
     WM_PRINT          = 791;
     WM_PRINTCLIENT     = 792;

     //Window Styles
     WS_DEFAULT = -1;{custom, internal use only}
     WS_OVERLAPPED = 0;
     WS_POPUP = $80000000;
     WS_CHILD = $40000000;
     WS_MINIMIZE = $20000000;
     WS_VISIBLE = $10000000;
     WS_DISABLED = $8000000;
     WS_CLIPSIBLINGS = $4000000;
     WS_CLIPCHILDREN = $2000000;
     WS_MAXIMIZE = $1000000;
     WS_CAPTION = $C00000;     { WS_BORDER or WS_DLGFRAME  }
     WS_BORDER = $800000;
     WS_DLGFRAME = $400000;
     WS_VSCROLL = $200000;
     WS_HSCROLL = $100000;
     WS_SYSMENU = $80000;
     WS_THICKFRAME = $40000;
     WS_GROUP = $20000;
     WS_TABSTOP = $10000;
     WS_MINIMIZEBOX = $20000;
     WS_MAXIMIZEBOX = $10000;
     WS_TILED = WS_OVERLAPPED;
     WS_ICONIC = WS_MINIMIZE;
     WS_SIZEBOX = WS_THICKFRAME;

     //Common Window Styles
     WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or
     WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
     WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
     WS_POPUPWINDOW = (WS_POPUP or WS_BORDER or WS_SYSMENU);
     WS_CHILDWINDOW = (WS_CHILD);

     //Extended Window Styles
     WS_EX_DEFAULT = -1;{custom, internal use only}
     WS_EX_DLGMODALFRAME = 1;
     WS_EX_NOPARENTNOTIFY = 4;
     WS_EX_TOPMOST = 8;
     WS_EX_ACCEPTFILES = $10;
     WS_EX_TRANSPARENT = $20;
     WS_EX_MDICHILD = $40;
     WS_EX_TOOLWINDOW = $80;
     WS_EX_WINDOWEDGE = $100;
     WS_EX_CLIENTEDGE = $200;
     WS_EX_CONTEXTHELP = $400;
     WS_EX_RIGHT = $1000;
     WS_EX_LEFT = 0;
     WS_EX_RTLREADING = $2000;
     WS_EX_LTRREADING = 0;
     WS_EX_LEFTSCROLLBAR = $4000;
     WS_EX_RIGHTSCROLLBAR = 0;
     WS_EX_CONTROLPARENT = $10000;
     WS_EX_STATICEDGE = $20000;
     WS_EX_APPWINDOW = $40000;
     WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE);
     WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE or WS_EX_TOOLWINDOW or WS_EX_TOPMOST);

     //ShowWindow() Commands
     SW_HIDE = 0;
     SW_SHOWNORMAL = 1;
     SW_NORMAL = 1;
     SW_SHOWMINIMIZED = 2;
     SW_SHOWMAXIMIZED = 3;
     SW_MAXIMIZE = 3;
     SW_SHOWNOACTIVATE = 4;
     SW_SHOW = 5;
     SW_MINIMIZE = 6;
     SW_SHOWMINNOACTIVE = 7;
     SW_SHOWNA = 8;
     SW_RESTORE = 9;
     SW_SHOWDEFAULT = 10;
     SW_MAX = 10;

     //GetSystemMetrics() codes
     SM_CXSCREEN = 0;
     SM_CYSCREEN = 1;
     SM_CXVSCROLL = 2;
     SM_CYHSCROLL = 3;
     SM_CYCAPTION = 4;
     SM_CXBORDER = 5;
     SM_CYBORDER = 6;
     SM_CXDLGFRAME = 7;
     SM_CYDLGFRAME = 8;
     SM_CYVTHUMB = 9;
     SM_CXHTHUMB = 10;
     SM_CXICON = 11;
     SM_CYICON = 12;
     SM_CXCURSOR = 13;
     SM_CYCURSOR = 14;
     SM_CYMENU = 15;
     SM_CXFULLSCREEN = $10;
     SM_CYFULLSCREEN = 17;
     SM_CYKANJIWINDOW = 18;
     SM_MOUSEPRESENT = 19;
     SM_CYVSCROLL = 20;
     SM_CXHSCROLL = 21;
     SM_DEBUG = 22;
     SM_SWAPBUTTON = 23;
     SM_RESERVED1 = 24;
     SM_RESERVED2 = 25;
     SM_RESERVED3 = 26;
     SM_RESERVED4 = 27;
     SM_CXMIN = 28;
     SM_CYMIN = 29;
     SM_CXSIZE = 30;
     SM_CYSIZE = 31;
     SM_CXFRAME = $20;
     SM_CYFRAME = 33;
     SM_CXMINTRACK = 34;
     SM_CYMINTRACK = 35;
     SM_CXDOUBLECLK = 36;
     SM_CYDOUBLECLK = 37;
     SM_CXICONSPACING = 38;
     SM_CYICONSPACING = 39;
     SM_MENUDROPALIGNMENT = 40;
     SM_PENWINDOWS = 41;
     SM_DBCSENABLED = 42;
     SM_CMOUSEBUTTONS = 43;
     SM_CXFIXEDFRAME = SM_CXDLGFRAME; { win40 name change }
     SM_CYFIXEDFRAME = SM_CYDLGFRAME; { win40 name change }
     SM_CXSIZEFRAME = SM_CXFRAME;     { win40 name change }
     SM_CYSIZEFRAME = SM_CYFRAME;     { win40 name change }
     SM_SECURE = 44;
     SM_CXEDGE = 45;
     SM_CYEDGE = 46;
     SM_CXMINSPACING = 47;
     SM_CYMINSPACING = 48;
     SM_CXSMICON = 49;
     SM_CYSMICON = 50;
     SM_CYSMCAPTION = 51;
     SM_CXSMSIZE = 52;
     SM_CYSMSIZE = 53;
     SM_CXMENUSIZE = 54;
     SM_CYMENUSIZE = 55;
     SM_ARRANGE = 56;
     SM_CXMINIMIZED = 57;
     SM_CYMINIMIZED = 58;
     SM_CXMAXTRACK = 59;
     SM_CYMAXTRACK = 60;
     SM_CXMAXIMIZED = 61;
     SM_CYMAXIMIZED = 62;
     SM_NETWORK = 63;
     SM_CLEANBOOT = 67;
     SM_CXDRAG = 68;
     SM_CYDRAG = 69;
     SM_SHOWSOUNDS = 70;
     SM_CXMENUCHECK = 71;     { Use instead of GetMenuCheckMarkDimensions()! }
     SM_CYMENUCHECK = 72;
     SM_SLOWMACHINE = 73;
     SM_MIDEASTENABLED = 74;
     SM_MOUSEWHEELPRESENT = 75;
     SM_CMETRICS = 76;

     //Standard Icon IDs
     IDI_APPLICATION = MakeIntResource(32512);
     IDI_HAND = MakeIntResource(32513);
     IDI_QUESTION = MakeIntResource(32514);
     IDI_EXCLAMATION = MakeIntResource(32515);
     IDI_ASTERISK = MakeIntResource(32516);
     IDI_WINLOGO = MakeIntResource(32517);
     IDI_WARNING = IDI_EXCLAMATION;
     IDI_ERROR = IDI_HAND;
     IDI_INFORMATION = IDI_ASTERISK;

     //Standard Cursor IDs
     IDC_ARROW = MakeIntResource(32512);
     IDC_IBEAM = MakeIntResource(32513);
     IDC_WAIT = MakeIntResource(32514);
     IDC_CROSS = MakeIntResource(32515);
     IDC_UPARROW = MakeIntResource(32516);
     IDC_SIZE = MakeIntResource(32640);
     IDC_ICON = MakeIntResource(32641);
     IDC_SIZENWSE = MakeIntResource(32642);
     IDC_SIZENESW = MakeIntResource(32643);
     IDC_SIZEWE = MakeIntResource(32644);
     IDC_SIZENS = MakeIntResource(32645);
     IDC_SIZEALL = MakeIntResource(32646);
     IDC_NO = MakeIntResource(32648);
     IDC_APPSTARTING = MakeIntResource(32650);
     IDC_HELP = MakeIntResource(32651);

     //Stock Logical Objects
     WHITE_BRUSH = 0;
     LTGRAY_BRUSH = 1;
     GRAY_BRUSH = 2;
     DKGRAY_BRUSH = 3;
     BLACK_BRUSH = 4;
     NULL_BRUSH = 5;
     HOLLOW_BRUSH = NULL_BRUSH;
     WHITE_PEN = 6;
     BLACK_PEN = 7;
     NULL_PEN = 8;
     OEM_FIXED_FONT = 10;
     ANSI_FIXED_FONT = 11;
     ANSI_VAR_FONT = 12;
     SYSTEM_FONT = 13;
     DEVICE_DEFAULT_FONT = 14;
     DEFAULT_PALETTE = 15;
     SYSTEM_FIXED_FONT = $10;
     DEFAULT_GUI_FONT = 17;
     STOCK_LAST = 17;
     CLR_INVALID = $FFFFFFFF;

     //Brush Styles
     BS_SOLID              = 0;
     BS_NULL               = 1;
     BS_HOLLOW             = BS_NULL;
     BS_HATCHED            = 2;
     BS_PATTERN            = 3;
     BS_INDEXED            = 4;
     BS_DIBPATTERN          = 5;
     BS_DIBPATTERNPT        = 6;
     BS_PATTERN8X8          = 7;
     BS_DIBPATTERN8X8       = 8;
     BS_MONOPATTERN         = 9;

     //Hatch Styles
     HS_HORIZONTAL = 0;      { ----- }
     HS_VERTICAL   = 1;      { ||||| }
     HS_FDIAGONAL  = 2;      { ///// }
     HS_BDIAGONAL  = 3;      { \\\\\ }
     HS_CROSS     = 4;      { +++++ }
     HS_DIAGCROSS  = 5;      { xxxxx }

     //Pen Styles
     PS_SOLID      = 0;
     PS_DASH       = 1;     { ------- }
     PS_DOT        = 2;     { ....... }
     PS_DASHDOT     = 3;     { _._._._ }
     PS_DASHDOTDOT  = 4;     { _.._.._ }
     PS_NULL = 5;
     PS_INSIDEFRAME = 6;
     PS_USERSTYLE = 7;
     PS_ALTERNATE = 8;
     PS_STYLE_MASK = 15;
     PS_ENDCAP_ROUND = 0;
     PS_ENDCAP_SQUARE = $100;
     PS_ENDCAP_FLAT = $200;
     PS_ENDCAP_MASK = 3840;
     PS_JOIN_ROUND = 0;
     PS_JOIN_BEVEL = $1000;
     PS_JOIN_MITER = $2000;
     PS_JOIN_MASK = 61440;
     PS_COSMETIC = 0;
     PS_GEOMETRIC = $10000;
     PS_TYPE_MASK = $F0000;
     AD_COUNTERCLOCKWISE = 1;
     AD_CLOCKWISE = 2;

     //Window field offsets for GetWindowLong()
     GWL_WNDPROC = -4;
     GWL_HINSTANCE = -6;
     GWL_HWNDPARENT = -8;
     GWL_STYLE = -16;
     GWL_EXSTYLE = -20;
     GWL_USERDATA = -21;
     GWL_ID = -12;

     //Controls
     CN_BASE            = $BC00;

     //MessageBox
     mbCustom=$0;
     mbError=$10;
     mbInformation=$40;
     mbWarning=$30;
     mbrYes=6;
     mbrNo=7;

     //MessageBox() Flags
     MB_OK = $00000000;
     MB_OKCANCEL = $00000001;
     MB_ABORTRETRYIGNORE = $00000002;
     MB_YESNOCANCEL = $00000003;
     MB_YESNO = $00000004;
     MB_RETRYCANCEL = $00000005;

     //registry entries for special paths are kept in:
     CSIDL_DESKTOP                    = $0000;
     CSIDL_PROGRAMS                   = $0002;
     CSIDL_CONTROLS                   = $0003;
     CSIDL_PRINTERS                   = $0004;
     CSIDL_PERSONAL                   = $0005;
     CSIDL_FAVORITES                  = $0006;
     CSIDL_STARTUP                    = $0007;
     CSIDL_RECENT                    = $0008;
     CSIDL_SENDTO                    = $0009;
     CSIDL_BITBUCKET                  = $000a;
     CSIDL_STARTMENU                  = $000b;
     CSIDL_DESKTOPDIRECTORY            = $0010;
     CSIDL_DRIVES                    = $0011;
     CSIDL_NETWORK                    = $0012;
     CSIDL_NETHOOD                    = $0013;
     CSIDL_FONTS                     = $0014;
     CSIDL_TEMPLATES                  = $0015;
     CSIDL_COMMON_STARTMENU            = $0016;
     CSIDL_COMMON_PROGRAMS             = $0017;
     CSIDL_COMMON_STARTUP              = $0018;
     CSIDL_COMMON_DESKTOPDIRECTORY      = $0019;
     CSIDL_APPDATA                    = $001a;
     CSIDL_PRINTHOOD                  = $001b;

 {TLiteLanguage}//Note: Save/Debug removed for size
     llicMaxIndex=4999;
     llicLV2='LLF2.0';{Version 2.0}

{TMsgLst}
     mglMaxItem=999;

{TLiteForm}
     lfmDown=0;
     lfmMove=1;
     lfmUp=2;

type
{TZFile}
    TZFile=Class
    Private
     iAutoNameCount:Integer;
     iErrorMessage:String;
     iMode:Integer;
     iFileName:String;
     iName:String;
     Procedure SetMode(X:Integer);
     Function DoMode:Boolean;
     Procedure SetData(X:String);
     Function GetData:String;
     Procedure _AutoName;
     {IO}
     Function Load(X:String;Var Y:String):Boolean;
     Function Save(X:String;Var Y:String):Boolean;
     Function LoadFromFile(X:String;Var Y:String):Boolean;
     Function SaveToFile(X:String;Var Y:String):Boolean;
     {Time}
     Function TFileTimeToDouble(X:TFileTime):Double;
     Function DoubleToTDateTime(X:Double):TDateTime;
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {Other}
     Property Mode:Integer Read iMode Write SetMode;
     Property Data:String Read GetData Write SetData;
     Property Name:String Read iName Write iName;
     Procedure Clean;
     {Errors}
     Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
     Procedure ShowError;
    end;

{TPaths}
    TPaths=class
    Private
     iRndCount:Integer;
     MAX_COMPUTERNAME_STR:String;
     Function GetCmpName:String;
     Function GetUsrName:String;
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {Drive Handlers}
     Function DrvSerial(X:Char):Integer;
     {File Handlers}
     Function MkFile(X:String;Y:Integer):Boolean;
     Function RemFile(X:string):Boolean;{Remove File}
     function rsf(x:string;var os:longint;ns:longint;testOnly:boolean;var e:string):boolean;{resize file}
     Function RemLastExt(X:String):String;{Remove Last Extension}
     Function CopyTo(Source,Dest:String):Boolean;
     Function TmpFile(Ext:String):String;{C:\Windows\Temp\[Random ID].EXT}
     {Other}
     Function RndID:String;
     Property CmpName:String Read GetCmpName;
     Property UsrName:String Read GetUsrName;
    end;

{TGeneral}
    TGeneralSortSet=set of 0..3;

    TGeneral=Class
    Private
     IDName:String;
     iApp:TFileStream;
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {routines}
     //null
     procedure FromNull(var x:string);{removes trailing null's - i.e. null terminated string -> string}
     function nullstr(size:integer;character:char):string;
     //sort
     function SortByRef(var x:array of string;var xRef:array of integer;xCount:integer;y:TGeneralSortSet):integer;
     function ParseStr(var x:string;xSep:char;var z:array of string;zMaxCount:integer):integer;
     //files
     procedure fapne(x:string;var p,n,e:string);{filename as path/name/extension}
     procedure fane(x:string;var n,e:string);{filename as name/extension}
     function files(sPath:String;AsFullFileNames:Boolean):String;
     function filesize(X:String):Integer;
     //ref
     function IntRef32(const x:string):integer;{1..32}
     function DblRef256(const x:string):double;{1..256}
     ///inc
     Procedure incInt(var x:integer);
     Procedure incDbl(var x:double);
     Procedure incxInt(var x:integer;by:integer);
     Procedure incxDbl(var x:double;by:double);
     //compare
     Function StrsMatch(Mask,Name:String):Boolean;
     //boolean
     Function NB(X:String):Boolean;
     Function BN(X:Boolean):String;
     {StdEncrypt:now supports plaintext in "14..255", plaintext out "14..255" on modes2&3}
     Function StdEncrypt(X:String;EKey:String;Mode1:Integer):String;{date: 22-FEB-2004}
     //colors
     Function ColShade(X,P:Integer):Integer;
     Function ColSplice(X,C1,C2:Integer):Integer;
     Function ColDark(X:Integer):Integer;
     Function ColBright(X:Integer):Integer;
     //control position
     Procedure MveControl(X,Y,W,H:Integer;Z:TWinControl);
     Procedure CenterControl(X:TWinControl);
     Procedure CenterBounds(A:TWinControl;W,H:Integer);
     //swap
     procedure SwapChars(var x:string;a,b:char);
     Procedure SwapStrs(Var X:String;A,B:String);
     //numbers
     Function Val(X:String):Integer;
     Function Thousands(X:Integer):String;{fixed "minus problem" on 4-FEB-2004}
     function DblComma(x:double):string;{same as "Thousands" but for "double"}
     function DblDec(x:double;y:byte;z:boolean):string;
     {Error}
     Procedure ShowError(X:String);
     Procedure StartFailure;
     {App}
     Function AppRunning(sIDName:String):Boolean;
     Procedure AppFree;
    end;

    TMisc=class
    public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {other}
     //passwords
     function cpw(t:string;var x:string):boolean;{change password}
     //menus
     function CopyMenu(o:tcomponent;x:tmenuitem):tmenuitem;
     procedure DupMenuState(x,y:tmenuitem);
     procedure DupMenuStates(x,y:tmenuitem);
     procedure DupMenu(x,y:tmenuitem);
     //url
     function EnforceService(X:String):String;
     function IsWebService(X:String):Boolean;
     //TRichText
     function MaxLen(x:trichedit;y:integer):boolean;
    end;

{TLanguage}
    PLanguageItems=^TLanguageItems;
    TLanguageItems=Record
      items:Array[0..lgicMaxIndex] of Array[0..2] of String;{0English/1Dutch/2UpperCase English}
      count:Integer;
      end;//end of record

    TLI=class(tcomponent)
    Private
     iX:String;
     iY:String;
    Published
     Property X:String Read iX Write iX;
     Property Y:String Read iY Write iY;
    end;

    TLanguage=class(tcomponent)
    Private
     iCaption:String;
     iTEP:String;
     iDetails:String;
     iErrorMessage:String;
     iItems:TLanguageItems;
     ipItems:PLanguageItems;
     iKeyA,iKeyB,iKeyC,iKeyD:String;
     iDebug:Boolean;
     iHistory:TStringList;{Temporary - used for debug}
     Procedure SetItems(X:String);
     Function GetItems:String;
     Procedure SetpKeyB(X:String);
     Procedure SetpKeyA(X:String);
     Function GetpKeyB:String;
     Function GetpKeyA:String;
     Function TranslateLine(Var X:String):Boolean;
     Procedure SwapFirstChar(Var X,Y,Z:String;Replace:Boolean);
     Procedure SetDebug(X:Boolean);
     Procedure SetpDetails(X:String);
     Function GetpDetails:String;
    Public
     {create}
     constructor create(Open:Boolean);
     destructor destroy;
     procedure free;
     {Properties}
     Property Caption:String Read iCaption Write iCaption;
     Property TEP:String Read iTEP Write iTEP;
     Property KeyA:String Read iKeyA Write iKeyA;
     Property KeyB:String Read iKeyB Write iKeyB;
     Property Details:String Read iDetails Write iDetails;
     Property Items:PLanguageItems Read ipItems;
     {Debug}
     Property Debug:Boolean Read iDebug Write SetDebug;
     Property History:TStringList Read iHistory;
     {Find/Add}
     Function Find(X:String):Integer;
     Function Add(X,Y:String):Integer;
     Procedure Clear;
     {Translate}
     Function Translate(X:String;Var Y:Boolean):String;
     {IO}
     Function FileName:String;
     Function Load:Boolean;
     Function LoadFromFile(X:String;Xpos:Integer):Boolean;
     Function LoadFromStream(X:TStream):Boolean;
     Function Save:Boolean;
     Function SaveToFile(X:String):Boolean;
     Function SaveToStream(X:TStream):Boolean;
     {Error}
     Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
     Procedure ShowError;
    Published
     Property pC:String Read iCaption Write iCaption;
     Property pP:String Read iTEP Write iTEP;
     Property pA:String Read GetpKeyA Write SetpKeyA;
     Property pB:String Read GetpKeyB Write SetpKeyB;
     {Below items rely on keys A&B above}
     Property pD:String Read GetpDetails Write SetpDetails;
     Property pI:String Read GetItems Write SetItems;
    end;

{TFrameInfo}
    TFrameInfo=record
      color:integer;
      width:integer;
      style:string;
      comment:string;
      end;//end of record
{//xxx
type
  PPoint = ^TPoint;
  TPoint = record
    x: Longint;
    y: Longint;
  end;
{}
  LongRec = packed record
    Lo, Hi: Word;
  end;

{ Cursor type }
  TCursor = -32768..32767;

{  PRect = ^TRect;
  TRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Integer);
      1: (TopLeft, BottomRight: TPoint);
    end;
{}//xxxxxxxx
  PWrd2 = ^TWrd2;
  TWrd2 = record
    case Integer of
      0:(val:word);
      1:(si:smallint);
      2:(chars:array [0..1] of char);
      3:(bytes:array [0..1] of byte);
    end;

  PInt4 = ^TInt4;
  TInt4 = record
    case Integer of
      0:(R,G,B,T:Byte);
      1:(val:integer);
      2:(chars:array [0..3] of char);
      3:(bytes:array [0..3] of byte);
      4:(wrds:array [0..1] of word);
    end;

  PDbl8 = ^TDbl8;
  TDbl8 = record
    case Integer of
      1:(val:Double);
      3:(chars:array[0..7] of char);
      4:(bytes:array[0..7] of byte);
      5:(wrds:array[0..3] of word);
      6:(ints:array[0..1] of integer);
    end;

  PSHItemID = ^TSHItemID;
  TSHItemID = packed record           { mkid }
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;

{ TItemIDList -- List if item IDs (combined with 0-terminator) }

  PItemIDList = ^TItemIDList;
  TItemIDList = packed record         { idl }
     mkid: TSHItemID;
   end;

  WCHAR = WideChar;
  PWChar = PWideChar;
  LPSTR = PAnsiChar;
  LPCSTR = PAnsiChar;
  LPWSTR = PWideChar;
  LPCWSTR = PWideChar;
  DWORD = Integer;
  BOOL = LongBool;
  PBOOL = ^BOOL;
  PByte = ^Byte;
  PINT = ^Integer;
  PSingle = ^Single;
  PWORD = ^Word;
//xxxxx  PDWORD = ^DWORD;
  LPDWORD = PDWORD;
  UCHAR = Byte;
  PUCHAR = ^Byte;
  SHORT = Smallint;
  UINT = Integer;
  PUINT = ^UINT;
  ULONG = Longint;
  PULONG = ^ULONG;
  PLongint = ^Longint;
  PInteger = ^Integer;
  PSmallInt = ^Smallint;
  PDouble = ^Double;
  LCID = DWORD;
  LANGID = Word;
  THandle = Integer;
  PHandle = ^THandle;
  HWND = Integer;
  HHOOK = Integer;
  ATOM = Word;
  TAtom = Word;
  HGLOBAL = THandle;
  HLOCAL = THandle;
  FARPROC = Pointer;
  TFarProc = Pointer;
  PROC_22 = Pointer;
  HGDIOBJ = Integer;
  HACCEL = Integer;
  HBITMAP = Integer;
  HBRUSH = Integer;
  HCOLORSPACE = Integer;
  HDC = Integer;
  HGLRC = Integer;
  HDESK = Integer;
  HENHMETAFILE = Integer;
  HFONT = Integer;
  HICON = Integer;
  HMENU = Integer;
  HMETAFILE = Integer;
  HINST = Integer;
  HMODULE = HINST;              { HMODULEs can be used in place of HINSTs }
  HPALETTE = Integer;
  HPEN = Integer;
  HRGN = Integer;
  HRSRC = Integer;
  HSTR = Integer;
  HTASK = Integer;
  HWINSTA = Integer;
  HKL = Integer;
  HFILE = Integer;
  HCURSOR = HICON;              { HICONs & HCURSORs are polymorphic }
  COLORREF = DWORD;
  TColorRef = Longint;
  WPARAM = Longint;
  LPARAM = Longint;
  LRESULT = Longint;
  MakeIntResource = PAnsiChar;

  PMenuItemInfo = ^TMenuItemInfo;
  TMenuItemInfo = packed record
    cbSize: UINT;
    fMask: UINT;
    fType: UINT;             { used if MIIM_TYPE}
    fState: UINT;            { used if MIIM_STATE}
    wID: UINT;               { used if MIIM_ID}
    hSubMenu: HMENU;         { used if MIIM_SUBMENU}
    hbmpChecked: HBITMAP;    { used if MIIM_CHECKMARKS}
    hbmpUnchecked: HBITMAP;  { used if MIIM_CHECKMARKS}
    dwItemData: DWORD;       { used if MIIM_DATA}
    dwTypeData: PAnsiChar;      { used if MIIM_TYPE}
    cch: UINT;               { used if MIIM_TYPE}
  end;

  TMsgConv=Record
   case Integer of
   0: (
        WParam:Word;
        LParam:Longint);
   1: (
        WParamLo: SmallInt;//Date: 14-NOV-2003
        WParamHi: SmallInt;
        LParamLo: SmallInt;
        LParamHi: SmallInt);
    end;//end of case

  TWMMenuSelect = record
    Msg: Cardinal;
    IDItem: Word;
    MenuFlag: Word; { MF_BITMAP, MF_CHECKED, MF_DISABLED, MF_GRAYED,
                      MF_MOUSESELECT, MF_OWNERDRAW, MF_POPUP, MF_SEPARATOR,
                      MF_SYSMENU }
    Menu: HMENU;
    Result: Longint;
    end;

{
  PMessage = ^TMessage;
  TMessage = record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;
{}

{Message structure}

  {MultiByte Character Set (MBCS) byte type}
  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

  {TMsg}
{//yyyyyyyyy
  PMsg = ^TMsg;
  TMsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
    end;
{}
  TFNWndProc = TFarProc;

  {TWndClass}
  TWndClass = packed record
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
    end;

  PWndClassEx = ^TWndClassEx;
  TWndClassEx = packed record
    cbSize: UINT;
    style: UINT;
    lpfnWndProc: TFNWndProc;
    cbClsExtra: Integer;
    cbWndExtra: Integer;
    hInstance: HINST;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: PAnsiChar;
    lpszClassName: PAnsiChar;
    hIconSm: HICON;
  end;

{ Generic window message record }
  PPaintStruct = ^TPaintStruct;
  TPaintStruct = packed record
    hdc: HDC;
    fErase: BOOL;
    rcPaint: TRect;
    fRestore: BOOL;
    fIncUpdate: BOOL;
    rgbReserved: array[0..31] of Byte;
    end;

  TPopupAlignment = (paLeft, paRight, paCenter);

    TMessageEvent=procedure (var Msg:TMsg; var Handled:Boolean) of object;
    TIdleEvent=procedure (Sender:TObject; var Done:Boolean) of object;
    TNotifyEvent = procedure(Sender: TObject) of object;
    PWndProc=^TWndProc;
    TWndProc=Procedure(Window:HWND;Message,wParam,lParam:Longint) of Object;

    PWindowProc=^TWindowProc;
    TWindowProc=Function(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT of Object;stdcall;

    TWndMethod = procedure(var Message: TMessage) of object;
    PWindowPlacement = ^TWindowPlacement;
    TWindowPlacement = packed record
       length: UINT;
       flags: UINT;
       showCmd: UINT;
       ptMinPosition: TPoint;
       ptMaxPosition: TPoint;
       rcNormalPosition: TRect;
       end;//end of record

{TLiteLanguage}//Note: Save/Debug removed for size
    PLiteLanguageItems=^TLiteLanguageItems;
    TLiteLanguageItems=Record
      items:Array[0..llicMaxIndex] of Array[0..2] of String;{0English/1Dutch/2UpperCase English}
      count:Integer;
      end;//end of record

    TLiteLanguage=class
    Private
     iCaption:String;
     iTEP:String;
     iDetails:String;
     iItems:TLiteLanguageItems;
     ipItems:PLiteLanguageItems;
     iKeyA,iKeyB,iKeyC,iKeyD:String;
     iExtraInfo1:String;
     iExtraInfo2:String;
     iErrorMessage:String;
     Procedure SetData(X:String);
     Function TranslateLine(Var X:String):Boolean;
     Procedure SwapFirstChar(Var X,Y,Z:String;Replace:Boolean);
    Public
     {create}
     constructor create(Open:Boolean);
     destructor destroy;
     procedure free;
     {Properties}
     Property Caption:String Read iCaption Write iCaption;
     Property TEP:String Read iTEP Write iTEP;
     Property ExtraInfo1:String Read iExtraInfo1 Write iExtraInfo1;
     Property ExtraInfo2:String Read iExtraInfo2 Write iExtraInfo2;
     Property KeyA:String Read iKeyA Write iKeyA;
     Property KeyB:String Read iKeyB Write iKeyB;
     Property Details:String Read iDetails Write iDetails;
     Property Items:PLiteLanguageItems Read ipItems;
     {Find/Add}
     Function Find(X:String):Integer;
     Function Add(X,Y:String):Integer;
     Procedure Clear;
     {Translate}
     Function Translate(X:String;Var Y:Boolean):String;
     {IO}
     Function _SetData(X:String):Boolean;
     Property Data:String Write SetData;
     Function FileName:String;
     Function Load:Boolean;
     Function LoadFromFile(X:String;Xpos:Integer):Boolean;
     {Error}
     Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
     Procedure ShowError;
    end;

{TScan}
    TScanInfo=Record
      FileName:String;
      ScanTo:Integer;{Count in bytes of file}
      CC:Integer;{check code}
      end;//end of record

    TScan=Class
    Private
     iErrorMessage:String;
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {Other}
     Procedure Scan(X,Y:Integer);
     Function ScanFile(Var X:TScanInfo):Boolean;
     Function CCMatch(X,Y:Integer):Boolean;
     {Error}
     Property ErrorMessage:String Read iErrorMessage Write iErrorMessage;
     Procedure ShowError;
    end;

{TMsgList}
    TMsgListItem=Record
      handle:Hwnd;
      proc:TWindowProc;
      end;//end of record

    PMsgListItems=^TMsgListItems;
    TMsgListItems=Record
      items:Array[0..mglMaxItem] of TMsgListItem;
      count:Integer;
      end;//end of record

    TMsgList=Class
    Private
     iItems:TMsgListItems;
     ipItems:PMsgListItems;
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {Other}
     Procedure Clear;
     Function Find(X:Hwnd):Integer;
     Function Add(X:Hwnd;Y:TWindowProc):Integer;
     Procedure Del(X:Hwnd);
     Property Items:PMsgListItems Read ipItems;
     Function WindowProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall;
    end;

{TLiteForm}
    TCloseAction=(caNone, caHide, caFree, caMinimize);
    TCloseEvent=Procedure(Sender:TObject;var Action:TCloseAction) of Object;
    TCloseQueryEvent=Procedure(Sender:TObject;var CanClose:Boolean) of Object;
//xxx    TShiftState=set of (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
//xxx    TMouseButton=(mbLeft,mbRight,mbMiddle);
    PMouseInfo=^TMouseInfo;
    TMouseInfo=Record
     Down:Boolean;
     Button:TMouseButton;
     Shift:TShiftState;
     X:Integer;
     Y:Integer;
     lX:Integer;
     lY:Integer;
     end;//end of record
{    TMouseEvent=Procedure(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer) of Object;
    TMouseMoveEvent=Procedure(Sender:TObject;Shift:TShiftState;X,Y:Integer) of Object;
{}//xxxxxxxxx

    TLiteForm=class
    Private
     iTag:Integer;
     iCursor:HCursor;
     iPaintDC:HDC;
     iHandle:HWND;
     iVisible:Boolean;
     iMouseInfo:TMouseInfo;
     ipMouseInfo:PMouseInfo;
     FOnWndProc:TWindowProc;
     FOnPaint:TNotifyEvent;
     FOnClose:TNotifyEvent;
     FOnCloseQuery:TCloseQueryEvent;
     FOnResize:TNotifyEvent;
     FOnMouseDown:TMouseEvent;
     FOnMouseMove:TMouseMoveEvent;
     FOnMouseUp:TMouseEvent;
     FOnEndSession:TNotifyEvent;
     FOnHalt:TNotifyEvent;
     Procedure SetVisible(X:Boolean);
     Procedure SetCaption(X:String);
     Function GetCaption:String;
     Function GetLeft:Integer;
     Procedure SetLeft(X:Integer);
     Function GetTop:Integer;
     Procedure SetTop(X:Integer);
     Function GetWidth:Integer;
     Procedure SetWidth(X:Integer);
     Function GetHeight:Integer;
     Procedure SetHeight(X:Integer);
     Function GetClientWidth:Integer;
     Procedure SetClientWidth(X:Integer);
     Function GetClientHeight:Integer;
     Procedure SetClientHeight(X:Integer);
     Procedure msgXY(X:Longint;Var rX,rY:Integer);
     Procedure DoMouse(X:Integer);
     Procedure SetMouseCapture(X:Boolean);
     Function GetMouseCapture:Boolean;
     Property MouseCapture:Boolean Read GetMouseCapture Write SetMouseCapture;
     Function WndProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall;
     Function _GetClientRect:TRect;
     Procedure _SetClientRect(X:TRect);
     Procedure _SetCursor(X:HCursor);
    Public
     {create}
     constructor create(dwStyle,dwExStyle:DWORD;pHandle:HWND); virtual;
     destructor destroy; virtual;
     procedure free;
     {Other}
     //Handles
     Property Handle:HWND Read iHandle;
     Function Perform(Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;
     Property Cursor:HCursor Read iCursor Write _SetCursor;
     Property Tag:Integer Read iTag Write iTag;
     //Paint
     Procedure PaintTo(dRect:TRect;sDC:HDC;sRect:TRect;Rop:DWORD);
     //Visibility
     Procedure Show;
     Procedure Hide;
     Property Visible:Boolean Read iVisible Write SetVisible;
     //Text
     Property Caption:String Read GetCaption Write SetCaption;
     //Dimensions
     Procedure SetBounds(X,Y,W,H:Integer);
     Function GetBounds:TRect;
     Property Left:Integer Read GetLeft Write SetLeft;
     Property Top:Integer Read GetTop Write SetTop;
     Property Width:Integer Read GetWidth Write SetWidth;
     Property Height:Integer Read GetHeight Write SetHeight;
     Property ClientRect:TRect Read _GetClientRect Write _SetClientRect;
     Property ClientWidth:Integer Read GetClientWidth Write SetClientWidth;
     Property ClientHeight:Integer Read GetClientHeight Write SetClientHeight;
     //Other
     Property MouseInfo:PMouseInfo Read ipMouseInfo;
     //Events
     Property OnWndProc:TWindowProc Read FOnWndProc Write FOnWndProc;
     Property OnResize:TNotifyEvent Read FOnResize Write FOnResize;
     Property OnPaint:TNotifyEvent Read FOnPaint Write FOnPaint;
     Property OnCloseQuery:TCloseQueryEvent Read FOnCloseQuery Write FOnCloseQuery;
     Property OnMouseDown:TMouseEvent Read FOnMouseDown Write FOnMouseDown;
     Property OnMouseMove:TMouseMoveEvent Read FOnMouseMove Write FOnMouseMove;
     Property OnMouseUp:TMouseEvent Read FOnMouseUp Write FOnMouseUp;
     Property OnClose:TNotifyEvent Read FOnClose Write FOnClose;{Main System Menu "Close"}
     Property OnEndSession:TNotifyEvent Read FOnEndSession Write FOnEndSession;{Windows Shutdown}
     Property OnHalt:TNotifyEvent Read FOnHalt Write FOnHalt;{Close or Windows Shutdown}
    end;

{TApp}
    TApp=class
    Private
     iExeName:String;
     iRunning:Boolean;
     iTerminated:Boolean;
     iHandle:HWND;
     iMainForm:Pointer;
     FOnMessage:TMessageEvent;
     FOnIdle:TIdleEvent;
     FOnClose:TNotifyEvent;
     Function IsKeyMsg(var Msg:TMsg):Boolean;
     Procedure Idle;
     Procedure Close(Sender:TObject);
    Public
     {create}
     constructor create;
     destructor destroy;
     procedure free;
     {Other}
     Property Running:Boolean Read iRunning;
     Property Terminated:Boolean Read iTerminated;
     Procedure Terminate;
     Property Handle:HWND Read iHandle;
     Property MainForm:Pointer Read iMainForm Write iMainForm;
     Procedure ProcessMessages;
     Function ProcessMessage:Boolean;
     Procedure HandleMessage;
     Procedure Run;
     Property EXEName:String Read iExeName;
     {Events}
     Property OnMessage:TMessageEvent Read FOnMessage Write FOnMessage;
     Property OnIdle:TIdleEvent Read FOnIdle Write FOnIdle;
     Property OnClose:TNotifyEvent Read FOnClose Write FOnClose;
    end;

    PObject=^TObject;

const
   user32='user32.dll';
   gdi32='gdi32.dll';
   kernel32='kernel32.dll';
   shell32='shell32.dll';

function PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
function TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
function DispatchMessage(const lpMsg: TMsg): Longint; stdcall;
function WaitMessage: BOOL; stdcall;
Function AskMessage(const Msg: string):Boolean;
procedure ShowMessage(const Msg: string);
Procedure ShowErr(X:String);
function ExtractFileName(const FileName: string): string;
Function ReadFileExt(x:string;fu:boolean):string;{Date: 25-NOV-2003, Superceeds "ExtractFileExt"}
function CreateWindow(lpClassName:PChar;lpWindowName:PChar;dwStyle:DWORD;X,Y,nWidth,nHeight:Integer;hWndParent:HWND;hMenu:HMENU;hInstance:HINST;lpParam:Pointer):HWND;
function CreateWindowEx(dwExStyle:DWORD;lpClassName:PChar;lpWindowName:PChar;dwStyle:DWORD;X,Y,nWidth,nHeight:Integer;hWndParent:HWND;hMenu:HMENU;hInstance:HINST;lpParam:Pointer):HWND; stdcall;
function GetSystemMetrics(nIndex:Integer): Integer; stdcall;
Function BN(X:Boolean):String;
Function NB(X:String):Boolean;
function bv(x:boolean):byte;//boolean to value, date: 18-MAR-2004
function vb(x:byte):boolean;//value to boolean, date: 18-MAR-2004
Function IntToStr(X:Integer):String;
Function StrToInt(X:String):Integer;
function ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall;
function RegisterClassEx(const WndClass: TWndClassEx): ATOM; stdcall;
function RegisterClass(const lpWndClass: TWndClass): ATOM; stdcall;
//function UnregisterClass(lpClassName: PChar; hInstance: HINST): BOOL; stdcall;
function GetClassInfo(hInstance: HINST; lpClassName: PChar;var lpWndClass: TWndClass): BOOL; stdcall;
function GetClassInfoEx(Instance: HINST; Classname: PChar; var WndClass: TWndClassEx): BOOL; stdcall;
function DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
function LoadIcon(hInstance: HINST; lpIconName: PChar): HICON; stdcall;
function LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR; stdcall;
function LoadCursorFromFile(lpFileName: PAnsiChar): HCURSOR; stdcall;
function SetSystemCursor(hcur: HICON; id: DWORD): BOOL; stdcall;
function GetStockObject(Index: Integer): HGDIOBJ; stdcall;
function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint; stdcall;
function LoadResource(hModule: HINST; hResInfo: HRSRC): HGLOBAL; stdcall;
function SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall;
function ReplyMessage(lResult: LRESULT): BOOL; stdcall;
procedure PostQuitMessage(nExitCode: Integer); stdcall;
function GetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall;
function SetWindowPlacement(hWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall;
function GetClientRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
function GetWindowRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
function AdjustWindowRect(var lpRect: TRect; dwStyle: DWORD; bMenu: BOOL): BOOL; stdcall;
function GetDC(hWnd: HWND): HDC; stdcall;
function GetWindowDC(hWnd: HWND): HDC; stdcall;
function ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall;
function StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC; XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD): BOOL; stdcall;
Function ScreenWidth:Integer;
Function ScreenHeight:Integer;
Function Rect(X,Y,W,H:Integer):TRect;
function TextOut(DC: HDC; X, Y: Integer; Str: PChar; Count: Integer): BOOL; stdcall;
function ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PRect; Str: PChar; Count: Longint; Dx: PInteger): BOOL; stdcall;
function Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall;
function DestroyWindow(hWnd: HWND): BOOL; stdcall;
function GetCapture: HWND; stdcall;
function SetCapture(hWnd: HWND): HWND; stdcall;
function ReleaseCapture: BOOL; stdcall;
Procedure SetCaptureHwnd(X:Hwnd);
function BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall;
function EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall;
function CreatePopupMenu: HMENU; stdcall;
function AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL; stdcall;
function GetSubMenu(hMenu: HMENU; nPos: Integer): HMENU; stdcall;
function GetMenuItemID(hMenu: HMENU; nPos: Integer): UINT; stdcall;
function GetMenuItemCount(hMenu: HMENU): Integer; stdcall;
function InsertMenuItem(p1: HMENU; p2: UINT; p3: BOOL; const p4: TMenuItemInfo): BOOL; stdcall;
function CheckMenuItem(hMenu: HMENU; uIDCheckItem, uCheck: UINT): DWORD; stdcall;
function EnableMenuItem(hMenu: HMENU; uIDEnableItem, uEnable: UINT): BOOL; stdcall;
function DestroyMenu(hMenu: HMENU): BOOL; stdcall;
function GetSystemMenu(hWnd: HWND; bRevert: BOOL): HMENU; stdcall;
Function WindowProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall
Function SysHMENU(Handle:Hwnd):HMENU;
Procedure PopMenu(Handle:HWND;X:HMENU;dX,dY:Integer);
Function GetCursorPos(var lpPoint: TPoint): BOOL; stdcall;
Function WriteStrValb(Var X:string;Val:String):Boolean;{Date: 24-NOV-2003}
Function WriteStrVal(Var X,Val:String):Boolean;
Function ReadStrVal(Var Pos:Integer;Var X,Val:String):Boolean;
Function ReadStrBool(Var Pos:Integer;Var X:string;Var Val:boolean):Boolean;{Date: 24-NOV-2003}
Function ReadStrInt(Var Pos:Integer;Var X:string;Var Val:integer):Boolean;{Date: 24-NOV-2003}
Function ReadStrShrtInt(Var Pos:Integer;Var X:string;Var Val:ShortInt):Boolean;{Date: 25-NOV-2003}
Function ReadStrDbl(Var Pos:Integer;Var X:string;Var Val:double):Boolean;{Date: 24-NOV-2003}
Function ReadSTDHeader(Var X,Hdr,Body:String):Boolean;
Procedure Draw3DFrame(X:TFrameInfo;Img:TBitmap);
Function StdEncrypt(X:String;EKey:String;Mode1:Integer):String;
Function ColBright(X:Integer):Integer;
Function InvColor(X:Integer;GreyCorrection:Boolean):Integer;
Function StripService(X:String;Full:Boolean):String;
Function CopyTo(Source,Dest:String;Var E:String):Boolean;
Function ImagePrinterEXE:String;
Procedure fireevent(x:tnotifyevent;y:tobject);{date: 11-JAN-2004 v1.00.001}
procedure swapInt(var x,y:LongInt);
function NewForm(p:twincontrol):tform;{date: 19-MAR-2004}
function decText(x:boolean;y,n:string):string;{Decision Text}
Function StrLen(Str: PChar): Cardinal; assembler;
Function UpperCase(X:String):String;
Function LowerCase(X:String):String;
Function ColSplice(X,C1,C2:Integer):Integer;
Function FileSize(X:String):Integer;
Function FileAge(const FileName:string):Integer;
Function FileExists(const FileName:string):Boolean;
Function RemFile(X:string):Boolean;
//other
Function From16Bit(X:Integer;si:boolean):String;{DATE: 13-DEC-2003}
Function To16Bit(X:String;si:boolean):Integer;{DATE: 13-DEC-2003}
function To32Bit(x:string):integer;{date: 16-FEB-2004}
function From32Bit(x:integer):string;{date: 16-FEB-2004}
Function To64Bit(x:string):double;
Function From64Bit(x:double):string;
function TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x, y, nReserved: Integer; hWnd: HWND; prcRect: PRect): BOOL; stdcall;
function SetFileAttributes(lpFileName: PChar; dwFileAttributes: DWORD): BOOL; stdcall;
function DeleteFile(lpFileName: PChar): BOOL; stdcall;
function SetCursor(hCursor: HICON): HCURSOR; stdcall;
function GetTempPath(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
function CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall;
function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer; var ppidl: PItemIDList): HResult; stdcall;
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall;
Function DirectoryExists(const Name: string): Boolean;
Function ExtractFilePath(X:String):String;
Procedure ForceDirectories(Dir: string);
Function TmpFile(Ext:String):String;
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall;
function GetTickCount: DWORD; stdcall;
function UpdateWindow(hWnd: HWND): BOOL; stdcall;
procedure Sleep(dwMilliseconds: DWORD); stdcall;
//eeeeeeeee



{TProgressSet}
Const
     prstAdding=1;
     prstExtracting=2;
     prstSaving=3;
     prstLoading=4;
     prstDeleting=5;
Type
    TProgressSet=Record
    Progress:Integer;
    Index:Integer;
    Style:Integer;
    end;//end of record



type
{TBinaryFile}
  TBinaryFileBuffer=array[0..32766] of byte;

  TBinaryFile=class
  private
   iNullStr:string;
   iLockCount:integer;
   iLocked,iNew,iOpen,iCanWrite:boolean;
   iFileName:string;
   iFileStream:TFileStream;
   iErrorMessage:string;
   function _CanWriteTo(x:string):boolean;
   procedure _Open(x:string);
   procedure SetFileName(x:string);
   function GetPosition:integer;
   procedure SetPosition(x:integer);
  public
   {create}
   constructor create(x:string);
   destructor destroy;
   procedure free;
   property ErrorMessage:string read iErrorMessage write iErrorMessage;
   {other}
   //indicators
   property New:boolean read iNew;
   property Open:boolean read iOpen;
   property CanWrite:boolean read iCanWrite;
   property FileName:string read iFileName write SetFileName;
   property FileStream:TFileStream read iFileStream;
   //io
   function WriteStr(x:integer;var y:string):boolean;
   function ReadStr(x:integer;yc:integer;var y:string):boolean;{3.1Mb/sec/yc=32,000 on CPU:200Mhz}
   function Wipe(x,yc:integer):boolean;
   property position:integer read GetPosition write SetPosition;
   {lock}
   property Locked:boolean read iLocked;
   procedure Lock;
   procedure Unlock;
  end;

{TController}
  TController=class
  public
   {create}
   constructor create;
   destructor destroy;
   procedure free;
   {other}
   //controls
   function isha(x:tcontrol):boolean;{is control height adjustable}
   function cg(x:twincontrol):integer;{control gap}
   function gci(x:twincontrol):integer;{generate control id}
   procedure asch(x:twincontrol);{auto. size control height}
   procedure aacs(sender:twincontrol;children:boolean;sp:byte;ah:boolean);{auto. arrange controls}
   procedure scs(sender:twincontrol;children:boolean;c:integer);{set control color}
   //factory
   function _TTabSheet(x:twincontrol;y:string):TTabSheet;
   function _TLabel(x:twincontrol;y,h:string;link:boolean;e:tnotifyevent):TLabel;
   function _TCheckBox(x:twincontrol;y,h:string;e:tnotifyevent):TCheckBox;
   function _TButton(x:twincontrol;y,h:string;f:tnotifyevent):TButton;
   function _TComboBox(x:twincontrol;y,h:string;fixed:Boolean;e:tnotifyevent):TComboBox;
   function _TEdit(x:twincontrol;h:string;c,e,t:tnotifyevent):TEdit;
   function _TMemo(x:twincontrol;h:string;c,e,t:tnotifyevent):TMemo;
   function _THR(x:twincontrol;t:String;f:boolean;c:integer;h:byte):TPanel;
   function _TListBox(x:twincontrol;ht:String;c:integer;h:byte;ode:TDrawItemEvent):TListBox;
//   function _TListBx(x:twincontrol;ht:String;c:integer;h:byte;ode:TDrawItemEvent):TListBx;
//   function _TBar(x:twincontrol;ht:String;v:boolean;oc:TNotifyEvent):TBar;
   function _TPanel(x:twincontrol;t,ht:string;f:boolean;c:integer;h:byte):TPanel;
   function _TGroupBox(x:twincontrol;t,ht:String;c:integer;h:byte):TGroupBox;
   function _TTimer(x:tcomponent;I:Integer;E:Boolean;F:TNotifyEvent):TTimer;
  end;

{TFindDlg}
  PStrings=^TStrings;
  TFindDlg=class
  private
   iform:tform;
   istatus,ilabel:tlabel;
   imwwo,imc:tcheckbox;
   ifn,icl:tbutton;
   itxt:tcombobox;
   ihistory:PStrings;
   iModified:boolean;
   FOnStatus,FOnChange,FOnFind,FOnClose:TNotifyEvent;
   procedure _OnClick(sender:tobject);
   function GetStyle:TSearchTypes;
   procedure SetStyle(x:TSearchTypes);
   function GetOptions:TSearchTypes;
   procedure SetOptions(x:TSearchTypes);
   function GetFindText:string;
   procedure SetFindText(x:string);
   function GetTitle:string;
   procedure SetTitle(x:string);
   function GetStatus:string;
   procedure SetStatus(x:string);
   procedure historyAdd;
   procedure DoOnChange;
   procedure _OnKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
  public
   {create}
   constructor create; virtual;
   destructor destroy; virtual;
   procedure free;
   {other}
   //execute
   procedure execute;
   //find
   procedure find;
   property findtext:string read GetFindText write SetFindText;
   property options:TSearchTypes read GetOptions write SetOptions;
   property style:TSearchTypes read GetStyle write SetStyle;
   //close
   procedure close;
   //history
   property history:PStrings read ihistory;
   //other
   procedure update;
   procedure finished;
   property title:string read GetTitle write SetTitle;
   property status:string read GetStatus write SetStatus;
   {events}
   property OnClose:TNotifyEvent read FOnClose write FOnClose;
   property OnFind:TNotifyEvent read FOnFind write FOnFind;
   property OnStatus:TNotifyEvent read FOnStatus write FOnStatus;
   property OnChange:TNotifyEvent read FOnChange write FOnChange;
  end;

{TInputDlg}
  TInputDlg=class
  private
   iform:tform;
   ilabel:tlabel;
   iok,icl:tbutton;
   itxt:tedit;
   function GetText:string;
   procedure SetText(x:string);
   function GetTitle:string;
   procedure SetTitle(x:string);
   function GetTextLabel:string;
   procedure SetTextLabel(x:string);
   procedure _OnKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
  public
   {create}
   constructor create; virtual;
   destructor destroy; virtual;
   procedure free;
   {other}
   function execute:boolean;
   property text:string read GetText write SetText;
   property title:string read GetTitle write SetTitle;
   property textlabel:string read GetTextLabel write SetTextLabel;
  end;
function InputQry(t,l:string;var x:string):boolean;

var
   FScan:TScan=nil;
   FZFile:TZFile=nil;
   FPaths:TPaths=nil;
   FGeneral:TGeneral=nil;
   FMisc:TMisc=nil;
   FLanguage:TLanguage=nil;
   FLiteLanguage:TLiteLanguage=nil;
   FApp:TApp=nil;
   FMsgList:TMsgList=nil;
   FCaptureHwnd:Hwnd=0;
   FTmpInfo:TLiteForm=nil;
   FController:TController=nil;

  UtilWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TPUtilWindow');

   {LeadBytes}
   LeadBytes: set of Char = [];
   {HCursors}
   hcrArrow:HCursor;
   hcrBeam:HCursor;
   hcrWait:HCursor;
   hcrCross:HCursor;
   hcrAppStart:HCursor;

//## Language Support ##
Function Translate(X:String):String;
Procedure TranslateMenu(X:TMenuItem);
Function LiteLanguage:TLiteLanguage;
Function TranslateParts(X:String):String;{Date: 10-NOV-2003 Version: 1.00.002}
//xxxFunction TranslateAssign(FromOld:Boolean;Var ErrMsg:String):Boolean;
Function Scan:TScan;
Function ZFile:TZFile;
Function Paths:TPaths;
Function General:TGeneral;
Function Misc:TMisc;
Function Language:TLanguage;
Function App:TApp;
Function MsgList:TMsgList;
Function TmpInfo:TLiteForm;
function Controller:TController;
function aar:TController;
Procedure DelWindowProc(X:HWND);
Function AddWindowProc(X:HWND;Y:TWindowProc):Integer;
//## Image Printer ##
Function CanRunImagePrinter:Boolean;
Function ImagePrinterTempFile:String;
Function RunImagePrinter(X:TBitmap;DocTitle:String;Var E:String):Boolean;
//## ECap ##
Function ECapK:String;
Function ECap(X:String;E:Boolean):String;
Function ECapBin(X:String;E,bin:Boolean):String;
//## other ##
procedure ShowError(x:string);
Procedure evmi(x:tmenuitem;y:boolean);{enable visible menu item. DATE: 04-NOV-2003}


//## Blaiz Enterprises Virtual Folders - 13-NOV-2005 ##
const
    //base64 - references
    base64:array[0..64] of char=('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/','=');
    base64r:array[0..255] of char='qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqnqqqodefghijklmqqqpqqq0123456789:;<=>?@ABCDEFGHIqqqqqqJKLMNOPQRSTUVWXYZ[\]^_`abcqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq'+'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq';
    tio1MB=1024000;
type
  POpenFilenameA = ^TOpenFilenameA;
  POpenFilename = POpenFilenameA;
  tagOFNA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
  end;

  TOpenFilenameA = tagOFNA;
  TOpenFilename = TOpenFilenameA;

//system
procedure showinfo(x:string);
procedure freeObj(x:pobject);
//push
Function pushOLD(var d,dtmp:string;x:string):boolean;{Date Added: 25-NOV-2003}
Function xpushOLD(var d,dtmp:string;x:string;b:integer):boolean;{date: 16-FEB-2004}
function pushb(var _dataLEN:integer;var _data:string;_add:string):boolean;
function push(var _dataLEN:integer;var _data,_add:string):boolean;
function pushbx(var _dataLEN:integer;_bufferSTEP:integer;var _data:string;_add:string):boolean;
function pushx(var _dataLEN:integer;_bufferSTEP:integer;var _data,_add:string):boolean;
function pushlimit(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data,_add:string):boolean;//Date: 15-AUG-2005
function pushlimitb(var _dataLEN:integer;_bufferSTEP,_limit:integer;var _data:string;_add:string):boolean;//Date: 15-AUG-2005
//base64
function fromb64(var s,d:string;var e:string):boolean;//from base64
function fromb64b(s:string):string;
//numbers
function lumrgb(r,g,b:integer):integer;
function frcmax(x,max:integer):integer;//14-SEP-2004
function frcmin(x,min:integer):integer;//14-SEP-2004
function frcrange(x,min,max:integer):integer;//13-SEP-2004
//text
function nextline(var _pos:integer;var _data,_line:string):boolean;
function readline(var _pos,_start,_length:integer;var _data:string):boolean;
function aorbstr(a,b:string;_useb:boolean):string;
procedure swapchars(var x:string;a,b:char);
function swapcharsb(x:string;a,b:char):string;
//file
function run(X,Y:String):boolean;
function toFILE(x:string;var y,e:string):boolean;
function fromFILE(x:string;var y,e:string):boolean;
function fromFILEb(x:string;var y,e:string;var _filesize,_from:integer;_size:integer):boolean;
function getsnippet(name:string):string;
procedure setsnippet(name:string;value:string);
procedure oldtonew(old,new:string;delold:boolean);//copy old file to new location
function GetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall; external 'comdlg32.dll'  name 'GetOpenFileNameA';
function GetSaveFileName(var OpenFile: TOpenFilename): Bool; stdcall; external 'comdlg32.dll'  name 'GetSaveFileNameA';
function opendlg(defext,filters,idir:string;var filterindex:integer;var filename:string):boolean;
function savedlg(defext,filters,idir:string;var filterindex:integer;var filename:string):boolean;
function opendlgb(handle:thandle;defext,filters,idir,title:string;var filterindex:integer;var filename:string;isopen:boolean):boolean;
procedure deleteall;//run once on shutdown - deletes all temp files
//help
function linkise(x:string):string;
function htmlise(x:string):string;
//midi
procedure testmidi;
procedure delmidi;
//folders
function winroot:string;
function wintemp:string;
function winstartup:string;
function asfolder(x:string):string;//enforces trailing "\"
function findfolder(x:integer;var y:string):boolean;
function mixedfolder(x:integer;y:string):string;
function mixedfolderb(x:integer;y:string;var z:string;create:boolean):boolean;
function bvfolder(bvfname:string):string;
function bvfolderb(bvfname:string;create:boolean):string;//Blaiz Enterprises virtual folder 12-NOV-2005
function clipfile(ext:string):string;

implementation

uses clic1;//programnameHARD

//## showinfo ##
procedure showinfo(x:string);
begin
try;MessageBox(application.handle,x,Translate('Information'),$40+MB_OK);except;end;
end;
//## freeObj ##
procedure freeObj(x:pobject);
begin
try
//check
if (x=nil) or (x^=nil) then exit;
//hide
if (x^ is twincontrol) then
   with (x^ as twincontrol) do
   begin
   visible:=false;
   parent:=nil;
   end;//end of with
//process
x^.free;
x^:=nil;
except;end;
end;
//## pushOLD ##
Function pushOLD(var d,dtmp:string;x:string):boolean;{Date Added: 25-NOV-2003}
begin{x=inbound, d=outbound, dtmp=tmp buffer for speed}
try;result:=xpushOLD(d,dtmp,x,1000);except;end;
end;
//## xpushOLD ##
Function xpushOLD(var d,dtmp:string;x:string;b:integer):boolean;{date: 16-FEB-2004}
begin{x=inbound, d=outbound, dtmp=tmp buffer for speed}
try
{error}
result:=false;
{append}
dtmp:=dtmp+x;
{check}
if (length(dtmp)>=b) or (x='') then
   begin
   d:=d+dtmp;
   dtmp:='';
   end;//end of if
{successful}
result:=true;
except;end;
end;
//## pushb ##
function pushb(var _dataLEN:integer;var _data:string;_add:string):boolean;
begin
try;result:=pushbx(_dataLEN,tio1Mb,_data,_add);except;end;
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
//## fromb64 ##
function fromb64(var s,d:string;var e:string):boolean;//from base64
label//Speed: 4,101Kb in 3150ms (~1.301Mb/sec) @ 200Mhz
   skipend;
var
   b,a:tint4;
   tmpi,sLEN,dLEN,c,p,i:integer;
   v:byte;
   tmp:string;
begin
try
//defaults
result:=false;
e:=gecOutOfMemory;
d:='';
sLEN:=length(s);
dLEN:=0;
p:=1;
//check
if (sLEN=0) then exit;
//process
//.tmp
tmpi:=0;
setlength(tmp,300);
repeat
//.get
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
     end;//end of begin
   end;//end of case
   //.inc
   inc(c,1);
   end
else if (v=64) then
   begin
   p:=sLEN;
   break;{=}
   end;//end of if
//.inc
inc(p);
until (p>sLEN);
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
  end;//end of begin
3:begin//finishing #1
  inc(tmpi,2);
  tmp[tmpi-1]:=b.chars[0];
  tmp[tmpi]:=b.chars[1];
  end;//end of begin
1..2:begin//finishing #2
  inc(tmpi,1);
  tmp[tmpi]:=b.chars[0];
  end;//end of begin
end;//end of case
//.tmp
if (tmpi>=300) then//always 300 exactly until last when "finishing #1/#2 or exact"
   begin
   pushb(dLEN,d,tmp);
   tmpi:=0;
   end;//end of if
until (p>=sLEN);
//.finalise
if (tmpi>=1) then pushb(dLEN,d,copy(tmp,1,tmpi));
pushb(dLEN,d,'');
//successful
result:=true;
skipend:
except;end;
try
if not result then d:='';
except;end;
end;
//## fromb64b ##
function fromb64b(s:string):string;
var
   e:string;
begin
try;fromb64(s,result,e);except;end;
end;
//## lumrgb ##
function lumrgb(r,g,b:integer):integer;
begin
try
result:=round(0.257*r+0.504*g+0.098*b)+16;
if (result<0) then result:=0 else if (result>255) then result:=255;
except;end;
end;
//## frcmax ##
function frcmax(x,max:integer):integer;//14-SEP-2004
begin
try;if (x>max) then x:=max;result:=x;except;end;
end;
//## frcmin ##
function frcmin(x,min:integer):integer;//14-SEP-2004
begin
try;if (x<min) then x:=min;result:=x;except;end;
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
//## nextline ##
function nextline(var _pos:integer;var _data,_line:string):boolean;
var
   _start,_length:integer;
begin
try
//defaults
result:=false;
_line:='';
//process
if readline(_pos,_start,_length,_data) then
   begin
   _line:=copy(_data,_start,_length);
   result:=true;
   end;//end of if
except;end;
end;
//## readline ##
function readline(var _pos,_start,_length:integer;var _data:string):boolean;
var//Supports: Unix return codes "#10" and Windows/DOS return codes "#13+#10"
   lv,v:byte;
   p,LEN:integer;
begin
try
//defaults
result:=false;
if (_pos<1) then exit;
LEN:=length(_data);
if (len=0) then exit;
_start:=_pos;
_length:=0;
lv:=0;
//process
//.loop
for p:=_pos to LEN do
begin
//.get
v:=ord(_data[p]);
//.set
if ((v=10) or (p=LEN)) then
   begin
   //.length
   _length:=p-_start;
   if (lv=13) then _length:=_length-1
   else if (p=LEN) and (v<>10) then _length:=_length+1;
   //.pos
   _pos:=p+1;
   //.successful
   result:=true;
   break;
   end;//end of if
//.lv
lv:=v;
end;//end of loop
except;end;
end;
//## aorbstr ##
function aorbstr(a,b:string;_useb:boolean):string;
begin
try;if _useb then result:=b else result:=a;except;end;
end;
//## swapchars ##
procedure swapchars(var x:string;a,b:char);
var
   p:integer;
begin
try;for p:=1 to length(x) do if (x[p]=a) then x[p]:=b;except;end;
end;
//## swapcharsb ##
function swapcharsb(x:string;a,b:char):string;
begin
try;result:=x;swapchars(result,a,b);except;end;
end;
//## linkise ##
function linkise(x:string):string;
const
   http='http://';
   https='https://';
   ftp='ftp://';
   httpLEN=length(http);
   httpsLEN=length(https);
   ftpLEN=length(ftp);
var
   o,sp,p,xlen:integer;
   tmp2,tmp:string;
begin
try
//defaults
result:=x;
xlen:=length(x);
p:=1;
sp:=0;
//process
repeat
//.scan
if (sp=0) and
(
(0=comparetext(copy(x,p,httpLEN),http)) or
(0=comparetext(copy(x,p,httpsLEN),https)) or
(0=comparetext(copy(x,p,ftpLEN),ftp))
) then sp:=p
else if (sp>=1) and ((p=xlen) or (x[p]=#32) or (x[p]=#10) or (x[p]=#13)) then
   begin
   if (p=xlen) and ((x[p]<>#32) and (x[p]<>#10) and (x[p]<>#13)) then o:=1 else o:=0;
   tmp:=copy(x,sp,p-sp+o);
   tmp2:='<a href="'+tmp+'">'+tmp+'</a>';
   x:=copy(x,1,sp-1)+tmp2+copy(x,p+o,xlen);
   xlen:=length(x);
   inc(p,length(tmp2));
   end;//end of if
//.inc
inc(p);
until (p>xlen);
//return result
result:=x;
except;end;
end;
//## htmlise ##
function htmlise(x:string):string;
const
   minblank=2;//2 blank lines before starting a new topic
var
   len,headLEN,topicLEN,bc,p,headCOUNT:integer;
   title,n,head,topic,tmp:string;
   headOK:boolean;
begin
try
//defaults
result:='';
title:='Untitled';
p:=1;
bc:=minblank;
headOK:=false;
head:='';
topic:='';
len:=0;
headLEN:=0;
topicLEN:=0;
headCOUNT:=0;
//.title
while nextline(p,x,tmp) do if (tmp<>'') then
   begin
   title:=tmp;
   break;
   end;//end of if
//.topics
while nextline(p,x,tmp) do
begin
//.clean - remove any html code and replace with html safe code
general.swapstrs(tmp,'<','&lt;');
general.swapstrs(tmp,'>','&gt;');
//.bc
if (tmp='') then inc(bc) else bc:=0;
//.reset
if headOK and (bc>=minblank) then
   begin
   //.finish topic
   pushb(topicLEN,topic,'</p>'+rcode+rcode);
   //.clear
   headOK:=false;
   end;//end of if
//.start topic
if (not headOK) and (bc=0) then
   begin
   //.inc
   inc(headCOUNT);
   n:=inttostr(headCOUNT)+'. ';
   //.head
   headOK:=true;
   pushb(headLEN,head,n+'<a href="#'+inttostr(headCOUNT)+'">'+tmp+'</a><br>'+rcode);
   //.topic - header
   pushb(topicLEN,topic,
   '<b>'+n+'<a name="'+inttostr(headcount)+'">'+tmp+'</a></b>'+rcode+
   '<p>'+rcode);
   end
//.fill topic
else if headOK and (bc<minblank) then
   begin
   pushb(topicLEN,topic,linkise(tmp)+'<br>'+rcode);
   end;//end of if
end;//end of loop
//.finish topic
if headOK then pushb(topicLEN,topic,'</p>'+rcode+rcode);
//.finalise
pushb(headLEN,head,'');
pushb(topicLEN,topic,'');
//.build page
pushb(len,result,
'<html>'+rcode+
'<head>'+rcode+
' <title>'+title+'</title>'+rcode+
' <meta name="generator" content="htmlise - Blaiz Enterprises">'+rcode+
'</head>'+rcode+rcode+
'<body bgcolor=white text=black link=blue alink=red>'+rcode+rcode);
//..main header
pushb(len,result,'<h1>'+title+'</h1>'+rcode+rcode);
//..index
pushb(len,result,
'<table border=0 width=100%>'+rcode+
'<td align=left valign=top width=35%>'+rcode+rcode+
'<b>'+translate('Topics')+'</b><br>'+rcode+
head+
rcode+'</td>'+rcode);
//..content
pushb(len,result,
'<td align=left valign=top width=65%>'+rcode+rcode+
topic+
'</td>'+rcode+
'</table>'+rcode+rcode);
//..finish
pushb(len,result,
'</body>'+rcode+
'</html>'+rcode);
//.finalise
pushb(len,result,'');
except;end;
end;
//## run ##
function run(X,Y:String):boolean;
Var{runs [Email mailto:abc@xyz.com ''] [Web http://www.xyz.com/?abc ''] [Doc c:\1.bmp ''] [Prog/Doc c:\MSPaint.EXE "c:\3.bmp"]}
   H:THandle;
begin
try
{Error}
Result:=False;
H:=ShellExecute(0,nil,PChar(X),PChar(Y),PChar(ExtractFilePath(X)),1);
{Successful}
Result:=True;
except;end;
end;
//## toFILE ##
function toFILE(x:string;var y,e:string):boolean;
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
//error
result:=false;
e:=gecOutOfMemory;
//prepare
b:=nil;
yLEN:=length(y);
//process
//.delete
e:=gecFileInUse;
if not paths.remFile(x) then goto skipend;
//.open
e:=gecFileInUse;
b:=tfilestream.create(x,fmCreate);
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
ap:=ap+1;
end;//end of loop
//successful
result:=true;
skipend:
except;end;
try
b.free;
if not result then paths.remfile(x);
except;end;
end;
//## fromFILE ##
function fromFILE(x:string;var y,e:string):boolean;
var
   fsize,pos:integer;
begin
try;pos:=0;result:=fromFILEb(x,y,e,fsize,pos,-1);except;end;
end;
//## fromFILEb ##
function fromFILEb(x:string;var y,e:string;var _filesize,_from:integer;_size:integer):boolean;
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
//prepare
_filesize:=0;
b:=nil;
y:='';
//process
//.check
e:=gecFileNotFound;
if not fileexists(x) then goto skipend;
//.open
e:=gecFileInUse;
b:=tfilestream.create(x,fmOpenRead+fmShareDenyNone);
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
if (_size<=0) then _size:=b.size
else if (_size>b.size) then _size:=b.size;
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
if (b.size=_size) then result:=(i=_size)
else
   begin
   if (i<>_size) then setlength(y,i);
   result:=(i>=1);
   end;//end of if
skipend:
except;end;
try
if not result then y:='';
b.free;
except;end;
end;
//## getsnippet ##
function getsnippet(name:string):string;
var
   e:string;
begin
try;fromfile(bvfolder(bvfSnippet)+programname+'-'+name+'.snippet',result,e);except;end;
end;
//## setsnippet ##
procedure setsnippet(name:string;value:string);
var
   e:string;
begin
try;tofile(bvfolder(bvfSnippet)+programname+'-'+name+'.snippet',value,e);except;end;
end;
//## oldtonew ##
procedure oldtonew(old,new:string;delold:boolean);//copy old file to new location
var
   tmp,e:string;
begin
try
//check
if (old='') or (new='') then exit;
if (0=comparetext(old,new)) then exit;
//process
//.decide
if fileexists(old) and (not fileexists(new)) and fromfile(old,tmp,e) then
   begin
   //.new + delete old
   if tofile(new,tmp,e) and delold then paths.remfile(old);
   end;//end of if
except;end;
end;
//## opendlg ##
function opendlg(defext,filters,idir:string;var filterindex:integer;var filename:string):boolean;
begin
try;result:=opendlgb(application.mainform.handle,defext,filters,idir,translate('Open'),filterindex,filename,true);except;end;
end;
//## savedlg ##
function savedlg(defext,filters,idir:string;var filterindex:integer;var filename:string):boolean;
begin
try;result:=opendlgb(application.mainform.handle,defext,filters,idir,translate('Save As'),filterindex,filename,false);except;end;
end;
//## opendlg ##
function opendlgb(handle:thandle;defext,filters,idir,title:string;var filterindex:integer;var filename:string;isopen:boolean):boolean;
const//date: 26-JUL-2005
   OFN_READONLY = $00000001;
   OFN_OVERWRITEPROMPT = $00000002;
   OFN_HIDEREADONLY = $00000004;
   OFN_NOCHANGEDIR = $00000008;
   OFN_SHOWHELP = $00000010;
   OFN_ENABLEHOOK = $00000020;
   OFN_ENABLETEMPLATE = $00000040;
   OFN_ENABLETEMPLATEHANDLE = $00000080;
   OFN_NOVALIDATE = $00000100;
   OFN_ALLOWMULTISELECT = $00000200;
   OFN_EXTENSIONDIFFERENT = $00000400;
   OFN_PATHMUSTEXIST = $00000800;
   OFN_FILEMUSTEXIST = $00001000;
   OFN_CREATEPROMPT = $00002000;
   OFN_SHAREAWARE = $00004000;
   OFN_NOREADONLYRETURN = $00008000;
   OFN_NOTESTFILECREATE = $00010000;
   OFN_NONETWORKBUTTON = $00020000;
   OFN_NOLONGNAMES = $00040000;
   OFN_EXPLORER = $00080000;
   OFN_NODEREFERENCELINKS = $00100000;
   OFN_LONGNAMES = $00200000;
var
   a:topenfilename;
   szFile:array[0..MAX_PATH] of Char;
begin
try
//defaults
result:=false;
//dir
if (idir='') then idir:=extractfilepath(filename);
//prepare
fillchar(a,sizeof(topenfilename),0);
with a do
begin
//.core
hInstance:=SysInit.HInstance;
hWndOwner:=handle;
lStructSize:=sizeof(topenfilename);
case isopen of
true:flags:=OFN_HIDEREADONLY or OFN_LONGNAMES or OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
false:flags:=OFN_HIDEREADONLY or OFN_LONGNAMES or OFN_PATHMUSTEXIST or OFN_OVERWRITEPROMPT;
end;//end of if
//.other
lpstrFile:=szFile;
nMaxFile:=sizeof(szFile);
if (title<>'') then lpstrTitle:=PChar(Title);
if (idir<>'') then lpstrInitialDir:=PChar(iDir);
if not isopen then StrPCopy(lpstrFile,extractfilename(FileName)) else StrPCopy(lpstrFile,'');
lpstrFilter:=PChar(swapcharsb(Filters,'|',#0)+#0#0);
nFilterIndex:=word(filterindex);
if (DefExt<>'') then lpstrDefExt:=PChar(DefExt);
end;//end of with
//process
case isopen of
true:if GetOpenFileName(a) then
        begin
        result:=true;
        filename:=strpas(szFile);
        filterindex:=a.nfilterindex;
        end;//end of if
false:if GetSaveFileName(a) then
        begin
        result:=true;
        filename:=strpas(szFile);
        filterindex:=a.nfilterindex;
        end;//end of if
end;//end of case
except;end;
end;
//## testmidi ##
procedure testmidi;
label
   skipend;
var
   e,d,f:string;
begin
try
//defaults
e:=gecOutOfMemory;
//process
//.filename
f:=bvfolder(bvfTemp)+'Test-Midi.mid';
//.data
d:=fromb64b('TVRoZAAAAAYAAQACAHhNVHJrAAAAGQD/WAQEAhgIAP9ZAgAAAP9RAwtxsAD/LwBNVHJrAAAALgD/IQEAAMAOALAHfwCwCj8AkE9keE8AAFZkeFYAAFNkeFMAAE9kg2BPAAD/LwA=');
//.write
if not tofile(f,d,e) then goto skipend;
//.run
run(f,'');
//successful
e:='';
skipend:
except;end;
try;if (e<>'') then general.showerror(e);except;end;
end;
//## delmidi ##
procedure delmidi;
begin
try;paths.remfile(bvfolder(bvfTemp)+'Test-Midi.mid');except;end;
end;
//## deleteall ##
procedure deleteall;
begin//run once on shutdown of program
try
//was: delhelp
delmidi;
except;end;
end;
//## winroot ##
function winroot:string;
var
  a:pchar;
begin
try
//process
//.size
a:=pchar(general.nullstr(max_path,#0));
//.get
getwindowsdirectorya(a,MAX_PATH);
result:=asfolder(string(a));
except;end;
end;
//## wintemp ##
function wintemp:string;
var
  a:pchar;
begin
try
//defaults
result:='';
//process
//.size
a:=pchar(general.nullstr(max_path,#0));
//.get
gettemppatha(max_path,a);
//.set
result:=asfolder(string(a));
//.range
if not directoryexists(result) then forcedirectories(result);
except;end;
end;
//## winstartup ##
function winstartup:string;
begin
try;findfolder(CSIDL_STARTUP,result);except;end;
end;
//## asfolder ##
function asfolder(x:string):string;//enforces trailing "\"
begin
try;if (copy(x,length(x),1)<>'\') then result:=x+'\' else result:=x;except;end;
end;
//## findfolder ##
function findfolder(x:integer;var y:string):boolean;
var
   a:pitemidlist;
   b:pchar;
begin
try
//defaults
result:=false;
y:='';
//process
if (shgetspecialfolderlocation(0,x,a)=0) then
   begin
   //.size
   b:=pchar(general.nullstr(max_path,#0));
   //.get
   if shgetpathfromidlist(a,b) then
      begin
      y:=asfolder(string(b));
      result:=(length(y)>=2);
      end;//end of if
   end;//end of if
except;end;
end;
//## mixedfolder ##
function mixedfolder(x:integer;y:string):string;
begin
try;mixedfolderb(x,y,result,true);except;end;
end;
//## mixedfolderb ##
function mixedfolderb(x:integer;y:string;var z:string;create:boolean):boolean;
var
   tmp:string;
begin
try
//defaults
result:=false;
z:='';
//process
if findfolder(x,tmp) then
   begin
   //.sub-path
   if (y<>'') then tmp:=tmp+asfolder(y);
   //.create
   if create and (not directoryexists(tmp)) then forcedirectories(tmp);
   //.successful
   result:=(length(tmp)>=2);
   if result then z:=tmp;
   end;//end of if
except;end;
end;
//## bvfolder ##
function bvfolder(bvfname:string):string;
begin
try;result:=bvfolderb(bvfname,true);except;end;
end;
//## bvfolderb ##
function bvfolderb(bvfname:string;create:boolean):string;//Blaiz Enterprises virtual folders 12-NOV-2005
begin
//was: try;mixedfolderb(csidl_programs,bvfBlaizEnterprises+bvfname,result,create);except;end;
try;result:=low__platfolder(bvfname);except;end;
end;
//## extfolder ##
function extfolder(ext:string;var folder:string;create:boolean):boolean;//extension to folder
var
   z:string;
   other:boolean;
begin
try
//defaults
result:=false;
other:=false;
folder:='';
//setup
ext:=uppercase(ext);
z:='';
//process
if (ext='SAN') or (ext='EAN') or (ext='AAN') then z:=bvfAnimations
else if (ext='ICO') or (ext='CUR') or (ext='ANI') then z:=bvfCursors
else if (ext='MSG') or (ext='TXT') or (ext='RTF') or (ext='DOC') then z:=bvfDocuments
else if (ext='FRM') or (ext='FRS') then z:=bvfFrames
else if (ext='MID') or (ext='RMI') or (ext='MIDI') or (ext='WAV') or (ext='SND') or (ext='MP3') or (ext='MP2') or (ext='WMA') then z:=bvfMusic
else if (ext='BMP') or (ext='JPG') or (ext='GIF') or (ext='TEP') or (ext='OMI') or (ext='XBM') then z:=bvfPictures
else if (ext='SHD') then z:=bvfShades
else if (ext='SCHEME') then z:=bvfSchemes//v3 (DSD+)
else if (ext='SCH') then z:=bvfSchemesOLD//v2 (EATS only)
else if (ext='TBH') then z:=bvfTextBrushs
else if (ext='EXE') or (ext='ZIP') then z:=bvfMiscellaneous
else if (ext='EAT') then
   begin
   other:=true;
   mixedfolderb(CSIDL_DESKTOP,'EAT Files',folder,create);
   end;//end of if
//virtual folder
if (not other) and (z<>'') then folder:=bvfolderb(z,create);
//successful
result:=(length(folder)>=2);
except;end;
end;
//## clipfile ##
function clipfile(ext:string):string;
begin
try;result:=bvfolder(bvfClipboard)+'clipboard-object-'+ext+'.'+ext;except;end;
end;

//######################## General Routines ####################################
//## DirectoryExists ##
Function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
try
Code:=GetFileAttributes(PChar(Name));
Result:=(Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
except;end;
end;
//## ForceDirectories ##
Procedure ForceDirectories(Dir: string);
begin
try
If (Length(Dir)=0) then exit;
If (Dir<>'') and (Copy(Dir,Length(Dir),1)='\') then Dir:=Copy(Dir,1,Length(Dir)-1);
If (Length(Dir)<3) or DirectoryExists(Dir) or (ExtractFilePath(Dir)=Dir) then exit; // avoid 'xyz:\' problem.
ForceDirectories(ExtractFilePath(Dir));
CreateDirectory(PChar(Dir), nil);
except;end;
end;
//## evmi ##
Procedure evmi(x:tmenuitem;y:boolean);{enable visible menu item. DATE: 04-NOV-2003}
var
   ok:boolean;
begin
try
{prepare}
ok:=false;
if not y then ok:=true;
{visible}
if (x.visible<>y) then
   begin
   x.visible:=y;
   ok:=true;
   end;//end of if
{enabled}
if ok and (x.enabled<>y) then x.enabled:=y;
except;end;
end;

//############################# TZFile #########################################
//## create ##
constructor TZFile.create;
begin
{Defaults}
iMode:=zfmcDestroyFile;{default}
{iAutoName}
Randomize;
iAutoNameCount:=0;
_AutoName;
end;
//## destroy ##
destructor TZFile.destroy;
begin
try
{clean}
clean;
{clean up}
if (FZFile=Self) then FZFile:=nil;
except;end;
end;
//## free ##
procedure TZFile.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## TFileTimeToDouble ##
Function TZFile.TFileTimeToDouble(X:TFileTime):Double;
Var
   a1,a2:Word;
   a3:Double;
begin
try
{Error}
Result:=0;
FileTimeToDosDateTime(X,a1,a2);
a3:=a2;
a3:=a3*High(Word);
{Return Result}
Result:=a3+a1;
except;end;
end;
//## DoubleToDateString ##
Function TZFile.DoubleToTDateTime(X:Double):TDateTime;
Var
   a1,a2:Word;
   a3,a4:Double;
   D:TFileTime;
   B:TSystemTime;
begin
try
Result:=0;
a3:=X;
a1:=0;
a2:=0;
a2:=Round(a3 / High(Word));
a4:=-a2;
a4:=a4*High(Word);
a4:=a4+a3;
a1:=Round(a4);
{Convert Time}
DosDateTimeToFileTime(a1,a2,D);
FileTimeToLocalFileTime(D,D);
FileTimeToSystemTime(D,B);
{Return Result}
Result:=SystemTimeToDateTime(B);
except;end;
end;
//## Clean ##
Procedure TZFile.Clean;
Var
   iSearchRec:TSearchRec;
   iCount,iAttr,P:Integer;
   iOpen:Boolean;
   iMask,iPath:String;
   iNow,B,A:TDateTime;
begin
try
{Ignore}
iPath:=bvfolder(bvfTemp);
If Not DirectoryExists(iPath) then exit;
{Prepare}
iCount:=0;
iMask:=iPath+'*.ZMP';
iAttr:=0+faReadOnly+faHidden+faSysFile+faArchive;
iNow:=Now;
{Search}
P:=FindFirst(iMask,iAttr,iSearchRec);
while P=0 do
begin
{Set}
A:=DoubleToTDateTime(TFileTimeToDouble(iSearchRec.FindData.ftLastWriteTime));
B:=iNow-A;
If (B<0) then B:=-B;
{Clean}
If (B>=0.00578) then
   begin
   Paths.RemFile(iPath+iSearchRec.Name);
   {Clean First 10}
   iCount:=iCount+1;
   If (iCount>=4) then break;
   end;//end of if
{Next}
P:=FindNext(iSearchRec);
end;
except;end;
{Free Memory}
try;FindClose(iSearchRec);except;end;
end;
//## _AutoName ##
Procedure TZFile._AutoName;
begin{Short but random!}
try
{iName}
iName:=IntToStr(Random(High(Word)))+'-'+IntToStr(Random(High(Word)))+'-'+IntToStr(iAutoNameCount);
{iAutoNameCount}
iAutoNameCount:=iAutoNameCount+1;
If (iAutoNameCount>=High(Integer)) then iAutoNameCount:=0;
except;end;
end;
//## SetData ##
Procedure TZFile.SetData(X:String);
begin
try
{New Name}
_AutoName;
{Save}
Save(iName,X);
except;end;
end;
//## GetData ##
Function TZFile.GetData:String;
begin
try;Load(iName,Result);except;end;
end;
//## SetMode ##
Procedure TZFile.SetMode(X:Integer);
begin
try
{Enforce Range}
X:=FrcRange(X,0,zfmcMax);
{Ignore}
If (X=iMode) then exit;
{Set}
iMode:=X;
except;end;
end;
//## DoMode ##
Function TZFile.DoMode:Boolean;
Label
     SkipEnd;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecUnexpectedError;
Case iMode of
zfmcNil:{nil};
zfmcDestroyFile:If FileExists(iFileName) and (Not Paths.RemFile(iFileName)) then
                   begin
                   iErrorMessage:=gecFileInUse;
                   Goto SkipEnd;
                   end;//end of if
end;//end of case
{Successful}
Result:=True;
SkipEnd:
except;end;
end;
//## Load ##
Function TZFile.Load(X:String;Var Y:String):Boolean;
Label
     SkipEnd;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecUnexpectedError;
Y:='';
{Always in "Blaiz Enterprises\TEMP\*.zmp')}
X:=ExtractFileName(X);
{Enforce}
X:=bvfolder(bvfTemp)+X+'.ZMP';
{SaveToFile}
If Not LoadFromFile(X,Y) then Goto SkipEnd;
{Successful}
Result:=True;
SkipEnd:
except;end
end;
//## Save ##
Function TZFile.Save(X:String;Var Y:String):Boolean;
Label
     SkipEnd;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecUnexpectedError;
{Always in "Blaiz Enterprises\TEMP\*.zmp')}
X:=ExtractFileName(X);
{Enforce}
X:=bvfolder(bvfTemp)+X+'.ZMP';
{SaveToFile}
If Not SaveToFile(X,Y) then Goto SkipEnd;
{Successful}
Result:=True;
SkipEnd:
except;end
end;
//## LoadFromFile ##
Function TZFile.LoadFromFile(X:String;Var Y:String):Boolean;
Label
     SkipEnd;
Var
   A:TMemoryStream;
   B:TStringStream;
   M,Z:String;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecFileNotFound;
Y:='';
If Not FileExists(X) then exit;
{Prepare}
iErrorMessage:=gecOutOfMemory;
A:=nil;
B:=nil;
A:=TMemoryStream.Create;
{Open}
iErrorMessage:=gecFileInUse;
A.LoadFromFile(X);
iErrorMessage:=gecOutOfMemory;
{Read}
B:=TStringStream.Create('');
B.CopyFrom(A,0);
A.Free;
A:=nil;
{Check}
Z:=B.DataString;
iErrorMessage:=gecUnknownFormat;
If (Copy(Z,1,Length(zfhcHDR))<>zfhcHDR) then Goto SkipEnd;
{Set Mode}
iFileName:=X;
Mode:=General.Val(Copy(Z,Length(zfhcHDR)+1,1));
DoMode;{Ignore Errors}
{Set+Decrypt}
Y:=General.StdEncrypt(Copy(Z,Length(zfhcHDR)+2,Length(Z)),zfkc1,1);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;A.Free;B.Free;except;end;
end;
//## SaveToFile ##
Function TZFile.SaveToFile(X:String;Var Y:String):Boolean;
Label
     SkipEnd;
Var
   A:TMemoryStream;
   B:TStringStream;
begin
try
{Error}
Result:=False;
{Prepare}
iErrorMessage:=gecOutOfMemory;
A:=nil;
B:=nil;
B:=TStringStream.Create(zfhcHDR+IntToStr(Mode)+General.StdEncrypt(Y,zfkc1,0));
A:=TMemoryStream.Create;
A.CopyFrom(B,0);
{RemFile}
iErrorMessage:=gecFileInUse;
If Not Paths.RemFile(X) then Goto SkipEnd;
{Save}
iErrorMessage:=gecOutOfDiskSpace;
A.SaveToFile(X);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;A.Free;B.Free;except;end;
end;
//## ShowError ##
Procedure TZFile.ShowError;
begin
try;General.ShowError(iErrorMessage);except;end;
end;

//############################# TPaths #########################################
//## Create ##
Constructor TPaths.Create;
begin
{Defaults}
Randomize;
iRndCount:=Random(High(Word));
{MAX_COMPUTERNAME_STR - MUST be atleast MAX_COMPUTERNAME_LENGTH in length}
While (Length(MAX_COMPUTERNAME_STR)<MAX_COMPUTERNAME_LENGTH) Do MAX_COMPUTERNAME_STR:=Copy(MAX_COMPUTERNAME_STR+'############################################',1,MAX_COMPUTERNAME_LENGTH);
end;
//## destroy ##
destructor TPaths.destroy;
begin
try
{clean up}
if (FPaths=Self) then FPaths:=nil;
except;end;
end;
//## free ##
procedure TPaths.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## RemFile ##
Function TPaths.RemFile(X:string):Boolean;
begin
try
{Ok}
Result:=True;
If Not FileExists(X) then exit;
{Error}
Result:=False;
try;FileSetAttr(X,0);except;end;
try;DeleteFile(PChar(X));except;end;
{Return Result}
Result:=Not FileExists(X);
except;end;
end;
//## rsf ##
function TPaths.rsf(x:string;var os:longint;ns:longint;testOnly:boolean;var e:string):boolean;{resize file}
var
   a:tfilestream;
begin
try
{error}
result:=false;
a:=nil;
os:=-1;//original size
{check}
//1
e:=gecUnexpectedError;
if (ns<0) then exit;
//2
e:=gecFileNotFound;
if not fileexists(x) then exit;
{process}
e:=gecFileInUse;
a:=tfilestream.create(x,fmOpenReadWrite+fmShareDenyNone);
os:=a.size;
e:=gecOutOfDiskSpace;
try
{size}
a.size:=ns;
{revert}
if testOnly then a.size:=os;
{successful}
result:=true;
except;
{revert - only on error}
a.size:=os;
end;
except;end;
try;a.free;except;end;
end;
//## RemLastExt ##
Function TPaths.RemLastExt(X:String):String;
Var
   P:integer;
begin
try
For P:=Length(X) DownTo 1 Do
begin
If (X[P]='.') then
   begin
   X:=Copy(X,1,P-1);
   Break;
   end;//end of if
end;
except;end;
try;Result:=X;except;end;
end;
//## CopyTo ##
Function TPaths.CopyTo(Source,Dest:String):Boolean;
Var
   DPath:String;
begin
try
{Error}
Result:=False;
If Not FileExists(Source) then exit;
{Enforce Path}
DPath:=ExtractFilePath(Dest);
If Not DirectoryExists(DPath) then ForceDirectories(DPath);
{Remove File}
RemFile(Dest);
{Copy}
Result:=CopyFile(PChar(Source),PChar(Dest),False);
except;end;
end;
//## DrvSerial ##
Function TPaths.DrvSerial(X:Char):Integer;
Var
  NotUsed,VolFlags,SerialNo:Integer;
  SerialNo_Address:PDWord;
  Drive:String;
begin
try
{Error}
Result:=0;
Drive:=X+':\';
If Not DirectoryExists(Drive) then exit;
VolFlags:=0;NotUsed:=0;SerialNo:=0;SerialNo_Address:=@SerialNo;
GetVolumeInformation(PChar(Drive),Nil,0,SerialNo_Address,NotUsed,VolFlags,Nil,0);
{Return Result}
result:=SerialNo;
except;end;
end;
//## RndID ##
Function TPaths.RndID:String;
begin{Char's used are [-|0..9|=] [MaxLen => 5*11+4 = 59 bytes]}
try
{Error}
Result:='';
{iRndCount}
iRndCount:=iRndCount+1;
If (iRndCount>=High(Integer)) then iRndCount:=0;
{Return Result}
Result:=IntToStr(DrvSerial('C'))+'='+IntToStr(GetCurrentTime)+'='+IntToStr(DiskFree(3))+'='+IntToStr(Random(High(Integer)))+'='+IntToStr(iRndCount);
except;end;
end;
//## TmpFile ##
Function TPaths.TmpFile(Ext:String):String;
begin
try;result:=wintemp+RndID+'.'+Ext;except;end;
end;
//## GetCmpName ##
Function TPaths.GetCmpName:String;
Var
  A:PChar;
  Count:Integer;
begin
try
{Error}
Result:='';
A:=PChar(MAX_COMPUTERNAME_STR);
Count:=MAX_COMPUTERNAME_LENGTH+1;{15+1}
{Return Result}
If GetComputerName(A,Count) then Result:=Copy(A,1,Count);
except;end;
end;
//## GetUsrName ##
Function TPaths.GetUsrName:String;
Var
  A:PChar;
  Count:Integer;
begin
try
{Error}
Result:='';
A:=PChar(MAX_COMPUTERNAME_STR);
Count:=MAX_COMPUTERNAME_LENGTH+1;{15+1}
{Return Result}
If GetUserName(A,Count) then Result:=Copy(A,1,Count);
except;end;
end;
//## MkFile ##
Function TPaths.MkFile(X:String;Y:Integer):Boolean;
Var
   A:TFileStream;
begin{Sizes existing/new file to Y, if Y>FileSize}
try
{Ignore}
Result:=True;
If (Y<0) then exit;
{Error}
Result:=False;
A:=nil;
{Size File}
Case FileExists(X) of
True:begin
    A:=TFileStream.Create(X,fmOpenWrite+fmShareDenyNone);
    If (Y>A.Size) then A.Size:=Y;
    end;//end of begin
False:begin
    A:=TFileStream.Create(X,fmCreate);
    A.Size:=Y;
    end;//end of begin
end;//end of case
{Successful}
Result:=True;
except;end;
try;A.Free;except;end;
end;

//############## TGeneral ######################################################
//## Create ##
Constructor TGeneral.Create;
begin
{iApp}
iApp:=nil;
end;
//## destroy ##
destructor TGeneral.destroy;
begin
try
{AppFree}
AppFree;
{clean up}
if (FGeneral=self) then FGeneral:=nil;
except;end;
end;
//## free ##
procedure TGeneral.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## FromNull ##
procedure TGeneral.FromNull(var x:string);{removes trailing null's - i.e. null terminated string -> string}
var
   p:integer;
begin
try
{process}
for p:=1 to length(x) do if (x[p]=#0) then
    begin
    x:=copy(x,1,p-1);
    break;
    end;//end of if
except;end;
end;
//## nullstr ##
function tgeneral.nullstr(size:integer;character:char):string;
var
   p:integer;
begin
try
//defaults
result:='';
//check
if (size<=0) then exit;
//process
//.size
setlength(result,size);
//.fill
for p:=1 to length(result) do result[p]:=character;
except;end;
end;
//## fapne ##
procedure TGeneral.fapne(x:string;var p,n,e:string);{filename as path/name/extension}
begin
try
{process}
p:=extractfilepath(x);
n:=extractfilename(x);
fane(extractfilename(x),n,e);
except;end;
end;
//## fane ##
procedure TGeneral.fane(x:string;var n,e:string);{filename as name/extension}
var
   maxp,p:integer;
begin
try
{defaults}
n:=x;
e:='';
{process}
maxp:=length(x);
for p:=maxp downto 1 do if (x[p]='.') then
    begin
    n:=copy(x,1,p-1);
    e:=copy(x,p+1,maxp);
    break;
    end;//end of if
except;end;
end;
//## IntRef32 ##
function TGeneral.IntRef32(const x:string):integer;{1..32}
const
     maxLen=32;
var
   d,c,p,xLen:integer;
begin
try
{default}
result:=0;
{prepare}
xLen:=length(x);
if (xLen=0) then exit
else if (xLen>maxLen) then xLen:=maxLen;{keep within integer range}
{Process}
c:=0;
for p:=1 to xLen do
begin
c:=c+1;
//2-stage - prevent math error
d:=c*c*c*c;
d:=d*byte(x[p]);
//inc
result:=result+d;
end;//end of loop
except;end;
end;
//## DblRef256 ##
function TGeneral.DblRef256(const x:string):double;{1..256}
var
   d,c:double;
   p,xLen:integer;
begin
try
{default}
result:=0;
{prepare}
xLen:=length(x);
if (xLen=0) then exit;
if (xLen>256) then xLen:=256;
{Process}
c:=0;
for p:=1 to xLen do
begin
c:=c+1;
//2-stage - prevent math error
d:=c*c*c*c;
d:=d*byte(x[p]);
//inc
result:=result+d;
end;//end of loop
except;end;
end;
//## incInt ##
Procedure TGeneral.incInt(var x:integer);
begin
try;incxInt(x,1);except;end;
end;
//## incDbl ##
Procedure TGeneral.incDbl(var x:double);
begin
try;incxDbl(x,1);except;end;
end;
//## incxInt ##
Procedure TGeneral.incxInt(var x:integer;by:integer);
begin
try;x:=x+by;except;end;
end;
//## incxDbl ##
Procedure TGeneral.incxDbl(var x:double;by:double);
begin
try;x:=x+by;except;end;
end;
//## StrsMatch ##
Function TGeneral.StrsMatch(Mask,Name:String):Boolean;
Label
     SkipOne, SkipEnd;
Var
   A:TStringList;
   MaxP,Np,NMax,N,LenN,LenX,P:Integer;
   X:String;
   Roam,Ok:Boolean;
begin
try
{No Match}
Result:=False;
{Setup}
Name:=UpperCase(Name)+' ';
Mask:=UpperCase(Mask)+' ';
{Mask}
A:=TStringList.Create;
SwapStrs(Mask,'*',RCode+'*'+RCode);
SwapStrs(Mask,'?',RCode+'?'+RCode);
A.Text:=Mask;
{Remove Blank Lines}
For P:=(A.Count-1) downTo 0 Do If (A.Strings[P]='') then A.Delete(P);
LenN:=Length(Name);
Np:=1;
MaxP:=A.Count-1;
Roam:=False;
For P:=0 to MaxP Do
begin
X:=A.Strings[P];
LenX:=Length(X);
If (X='*') then
   begin
   If (P=MaxP) then break;
   Roam:=True;
   Goto SkipOne;
   end;//end of if
If (X='?') then
   begin
   Np:=Np+1;
   Goto SkipOne;
   end;//end of if
 If (Np>LenN) then Goto SkipEnd;
 Ok:=False;
 If Roam then NMax:=LenN else NMax:=Np;
 For N:=Np to NMax Do
 begin
 If (Copy(Name,N,LenX)=X) then
    begin
    Np:=N+LenX;
    Ok:=True;
    break;
    end;//end of if
 end;//end of loop
 If (P=MaxP) and (Np<=LenN) then Goto SkipEnd;
 If Not Ok then Goto SkipEnd;
 If Ok then Roam:=False;
SkipOne:
end;//end of loop
{Successful}
Result:=True;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## Thousands ##
Function TGeneral.Thousands(X:Integer):String;{fixed "minus problem" on 4-FEB-2004}
Var
   I,MaxP,P:Integer;
   z2,Z,Y:String;
begin
try
{Error}
Result:='0';
z2:='';
if (x<0) then
   begin
   x:=-x;
   z2:='-';
   end;//end of if
Y:=IntToStr(X);
Z:='';
MaxP:=Length(Y);
I:=0;
For P:=MaxP DownTo 1 Do
begin
I:=I+1;
If (I>=3) and (P<>1) then
   begin
   Z:=','+Copy(Y,P,3)+Z;
   I:=0;
   end;//end of if
end;//end of loop
If (I<>0) then Z:=Copy(Y,1,I)+Z;
{Return Result}
Result:=z2+Z;
except;end;
end;
//## DblComma ##
function TGeneral.DblComma(x:double):string;{same as "Thousands" but for "double"}
Var
   I,MaxP,P:Integer;
   z2,Z,Y:String;
begin
try
{rrror}
result:='0';
z2:='';
if (x<0) then
   begin
   x:=-x;
   z2:='-';
   end;//end of if
y:=FloatToStr(x);
Z:='';
maxp:=length(y);
i:=0;
for p:=maxp downto 1 do
begin
i:=i+1;
if (i>=3) and (p<>1) then
   begin
   z:=','+copy(y,p,3)+z;
   i:=0;
   end;//end of if
end;//end of loop
if (i<>0) then z:=copy(y,1,i)+z;
{Return Result}
result:=z2+z;
except;end;
end;
//## DblDec ##
function TGeneral.DblDec(x:double;y:byte;z:boolean):string;
var
   a,b:string;
   aLen,p:integer;
begin
try
{enforce range}
//y
if (y<0) then y:=0
else if (y>10) then y:=10;
{prepare}
a:=floattostr(x);
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
if z then a:=DblComma(StrToFloat(a));
{return result}
if (y=0) then result:=a else result:=a+'.'+copy(b+'0000000000',1,y);
except;end;
end;
//## SortByRef ##
function TGeneral.SortByRef(var x:array of string;var xRef:array of integer;xCount:integer;y:TGeneralSortSet):integer;
label
     skipend,redo;
var
   ztmpRef,tmpv,minp,maxp,minV,maxV,cp,p:integer;
   a,ztmp:string;
begin
try
{error}
result:=0;
{prepare}
maxp:=high(x);
if (xCount>=1) then maxp:=frcmax(xCount-1,maxp);
if (glssRef in y) or (glssRefUC in y) then
   begin
   for p:=0 to maxp do
   begin
   case (glssRefUC in y) of
   true:a:=uppercase(x[p]);
   false:a:=x[p];
   end;//end of case
   xRef[p]:=IntRef32(a);
   end;//end of loop
   end;//end of if
{process}
//value range
minp:=0;
minV:=high(integer);
maxV:=0;
for p:=0 to maxp do
begin
if (xRef[p]<minV) then minV:=xRef[p];
if (xRef[p]>maxV) then maxV:=xRef[p];
end;//end of loop
//search for next highest value
Redo:
cp:=minp;
tmpv:=maxV;
for p:=minp to maxp do if (xRef[p]>=minV) and (xRef[p]<tmpv) then
    begin
    tmpv:=xRef[p];
    cp:=p;
    end;//end of if
minV:=xRef[cp];
//set
ztmpRef:=xRef[minp];
ztmp:=x[minp];
x[minp]:=x[cp];x[cp]:=ztmp;
xRef[minp]:=xRef[cp];xRef[cp]:=ztmpRef;
//set.check
if (glssDup in y) or (result=0) or ((result>0) and (minV>xRef[result-1])) then
   begin
   if (glssNull in y) or (minV<>0) then
      begin
      x[result]:=x[minp];
      xRef[result]:=xRef[minp];
      incInt(result);
      end;//end of if
   end;//end of if
minp:=minp+1;
{get next highest value}
if (minp<=maxp) then goto redo;
SkipEnd:
except;end;
end;
//## ParseStr ##
function TGeneral.ParseStr(var x:string;xSep:char;var z:array of string;zMaxCount:integer):integer;
var
   zMax,xLen,dp,lp,p:integer;
begin
try
{defaults}
result:=0;
{prepare}
zMax:=high(z)+1;
if (zMaxCount>0) and (zMaxCount<=zMax) then zMax:=zMaxCount;
xLen:=length(x);
dp:=0;
lp:=1;
{process}
for p:=1 to xLen do if (x[p]=xSep) or (p=xLen) then
    begin
    if (p=xLen) and (x[p]<>xSep) then dp:=1;
    z[result]:=copy(x,lp,p-lp+dp);
    result:=result+1;
    {enforce limit - internal/user}
    if (result>=zMax) then break;
    {lp}
    lp:=p+1;
    end;//end of if
except;end;
end;
//## SwapChars ##
procedure TGeneral.SwapChars(var x:string;a,b:char);
var
   p:integer;
begin
try;for p:=1 to length(x) do if (x[p]=a) then x[p]:=b;except;end;
end;
//## SwapStrs ##
Procedure TGeneral.SwapStrs(Var X:String;A,B:String);
Label
     ReDo;
Var
   lenB,lenA,MaxP,P:Integer;
begin
try{Extremely Fast Praser/StrSwaper - 5KBx6 times = 1-7ms => 46 times faster than SwapStrs => 325ms}
MaxP:=Length(X);
lenA:=Length(A);
lenB:=Length(B);
P:=0;
ReDo:
P:=P+1;
If (P>MaxP) then exit;
If (X[P]=A[1]) then If (Copy(X,P,lenA)=A) then
   begin
   X:=Copy(X,1,P-1)+B+Copy(X,P+LenA,MaxP);
   P:=P+LenB-1;
   MaxP:=MaxP-LenA+LenB;
   end;//End of LOOP
Goto ReDo;
except;end;
end;
//## MveControl ##
Procedure TGeneral.MveControl(X,Y,W,H:Integer;Z:TWinControl);
Const
     SafeW=32;
begin
try
If (Z=nil) then exit;
X:=FrcRange(X,SafeW-W,Screen.Width-SafeW);
Y:=FrcRange(Y,SafeW-H,Screen.Height-SafeW);
Z.SetBounds(X,Y,W,H);
except;end;
end;
//## NB ##
Function TGeneral.NB(X:String):Boolean;
begin
try;Result:=(X='1');except;end;
end;
//## BN ##
Function TGeneral.BN(X:Boolean):String;
begin
try;If X then Result:='1' else Result:='0';except;end;
end;
//## StdEncrypt ##
Function TGeneral.StdEncrypt(X:String;EKey:String;Mode1:Integer):String;{date: 22-FEB-2004}
Var
   Lt,El,E,p2,p:integer;
begin
try
{default: fail safe key} 
if (EKey='') then EKey:='198dlkjq34';
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
//## Val ##
Function TGeneral.Val(X:String):Integer;
begin
try
Result:=0;
Result:=Round(StrToFloat(X));
except;end;
end;
//## FileSize ##
Function TGeneral.FileSize(X:String):Integer;
Var
   A:TFileStream;
   AOpen:Boolean;
begin
try
{Error}
Result:=-1;
AOpen:=False;
A:=TFileStream.Create(X,fmOpenRead+fmShareDenyNone);
AOpen:=True;
{Return FileSize}
Result:=A.Size;
except;end;
try;If AOpen then A.Free;except;end;
end;
//## ColShade ##
Function TGeneral.ColShade(X,P:Integer):Integer;
var
   a:tint4;
begin
try
a.val:=x;
Result:=RGB(a.r*P Div 100,a.b*P Div 100,a.g*P Div 100);
except;end;
end;
//## ColSplice ##
Function TGeneral.ColSplice(X,C1,C2:Integer):Integer;
var
   a,b:tint4;
   P1,P2:Integer;
begin
try
{Error}
Result:=0;
{P1 & P2}
P1:=(X*100) Div 100;
P2:=100-P1;
{Color}
a.val:=c1;
b.val:=c2;
a.R:=(a.R*P1+b.R*P2) Div 100;
a.G:=(a.G*P1+b.G*P2) Div 100;
a.B:=(a.B*P1+b.B*P2) Div 100;
{Return Result}
Result:=a.val;
except;end;
end;
//## ColBright ##
Function TGeneral.ColBright(X:Integer):Integer;
var
   a:tint4;
begin
try
{Default}
result:=0;
a.val:=x;
If (a.R>Result) then Result:=a.R;
If (a.G>Result) then Result:=a.G;
If (a.B>Result) then Result:=a.B;
except;end;
end;
//## ColDark ##
Function TGeneral.ColDark(X:Integer):Integer;
var
   a:tint4;
begin
try
{Default}
Result:=255;
a.val:=x;
If (a.R<Result) then Result:=a.R;
If (a.G<Result) then Result:=a.G;
If (a.B<Result) then Result:=a.B;
except;end;
end;
//## Files ##
Function TGeneral.Files(sPath:String;AsFullFileNames:Boolean):String;
Var
 I:Integer;
 SearchRec:TSearchRec;
 A:TStringList;
 rPath:String;
begin
try
Result:='';
If AsFullFileNames then rPath:=ExtractFilePath(sPath);
A:=TStringList.Create;
I := FindFirst(sPath, 0, SearchRec);
while I = 0 do
begin
Case AsFullFileNames of
True:A.Add(rPath+SearchRec.Name);//As Full Path & FileNames
False:A.Add(SearchRec.Name);//As Just FileNames
end;//End of CASE
I:=FindNext(SearchRec);
end;
Result:=A.Text;
{Free Memory}
FindClose(SearchRec);
except;end;
try;A.Free;except;end;
end;
//## CenterControl ##
Procedure TGeneral.CenterControl(X:TWinControl);
begin
try;If (X<>nil) then X.SetBounds((Screen.Width-X.Width) Div 2,(Screen.Height-X.Height) Div 2,X.Width,X.Height);except;end;
end;
//## CenterBounds ##
Procedure TGeneral.CenterBounds(A:TWinControl;W,H:Integer);
begin
try
If (A=nil) then exit;
A.SetBounds((Screen.Width-W) Div 2,(Screen.Height-H) Div 2,W,H);
except;end;
end;
//## StartFailure ##
Procedure TGeneral.StartFailure;
begin
try;ShowError('Out of memory');Halt;except;end;
end;
//## ShowError ##
Procedure TGeneral.ShowError(X:String);
begin
try;MessageBox(Application.Handle,Translate(X),Translate('Error'),$10);except;end;
end;
//## AppRunning ##
Function TGeneral.AppRunning(sIDName:String):Boolean;
Var
   T1:Byte;
   X:Integer;
   Y:String;
begin
try
{Already Running}
Result:=True;
IDName:=sIDName;
If (IDName='') then IDName:=Paths.RemLastExt(ExtractFileName(Application.EXEName));
Y:=bvfolder(bvfActive)+Paths.RemLastExt(IDName);
{Attempt to Open File}
iApp:=TFileStream.Create(Y,fmCreate);
iApp.Seek(0,soFromBeginning);
T1:=0;X:=1;
iApp.Write(T1,X);
iApp.Free;
iApp:=nil;
{Not Already Running}
iApp:=TFileStream.Create(Y,fmOpenReadWrite+fmShareExclusive);
Result:=False;
except;end;
end;
//## AppFree ##
Procedure TGeneral.AppFree;
begin
try
If (iApp=nil) then exit;
iApp.Free;
iApp:=nil;
{Remove Active File}
Paths.RemFile(bvfolder(bvfActive)+Paths.RemLastExt(IDName));
except;end;
end;

//####################### TMisc ################################################
//## create ##
constructor TMisc.create;
begin
{nil}
end;
//## destroy ##
destructor TMisc.destroy;
begin
try
{clean up}
if (FMisc=Self) then FMisc:=nil;
except;end;
end;
//## free ##
procedure TMisc.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## cpw ##
function TMisc.cpw(t:string;var x:string):boolean;{change password}
label
     skipend;
var
   z1,z2:string;
begin
try
{no}
result:=false;
{prepare}
z1:='';
z2:='';
if (t='') then t:=translate('Password');
{process}
//1
if not InputQry(t,Translate('Enter password'),z1) then
   begin
   result:=true;
   Goto SkipEnd;
   end;//end of if
//2
if not InputQry(t,Translate('Confirm password'),z2) then
   begin
   result:=true;
   Goto SkipEnd;
   end;//end of if
//check z1=z2
if (z1<>z2) then
   begin
   general.showerror(gecTaskCancelled);
   Goto SkipEnd;
   end;//end of if
{successful}
x:=z1;
result:=true;
SkipEnd:
except;end;
end;
//## CopyMenu ##
function TMisc.CopyMenu(o:tcomponent;x:tmenuitem):tmenuitem;
begin
try
result:=tmenuitem.create(o);
with result do
begin
//core
tag:=x.tag;
caption:=x.caption;
shortcut:=x.shortcut;
break:=x.break;
groupindex:=x.groupindex;
OnClick:=x.OnClick;
//states
DupMenuState(result,x);
end;//end of with
except;end;
end;
//## DupMenuState ##
procedure TMisc.DupMenuState(x,y:tmenuitem);
begin
try
{check}
if (x=nil) or (y=nil) then exit;
{set}
with x do
begin
hint:=y.hint;
radioItem:=y.radioItem;
checked:=y.checked;
enabled:=y.enabled;
visible:=y.visible;
end;//end of with
except;end;
end;
//## DupMenuStates ##
procedure TMisc.DupMenuStates(x,y:tmenuitem);
var
   p:integer;
begin
try
{check}
if (x=nil) or (y=nil) then exit;
{process}
//add
for p:=0 to (y.count-1) do
begin
if (p>=x.count) then break;
DupMenuState(x.items[p],y.items[p]);
end;//end of loop
except;end;
end;
//## DupMenu ##
procedure TMisc.DupMenu(x,y:tmenuitem);
var
   z:tmenuitem;
   p:integer;
begin
try
{check}
if (x=nil) or (y=nil) or (y.count=0) then exit;
{process}
//add
for p:=0 to (y.count-1) do
begin
z:=CopyMenu(x,y.items[p]);
x.add(z);
end;//end of loop
except;end;
end;
//## EnforceService ##
Function TMisc.EnforceService(X:String):String;
begin
try
{Process}
Case IsWebService(X) of
True:Result:='http://'+StripService(X,False);
False:Result:='mailto:'+StripService(X,False);
end;//end of case
except;end;
end;
//## IsWebService ##
Function TMisc.IsWebService(X:String):Boolean;
Var
   cP,P,MaxP:Integer;
begin
try
{Default}
Result:=True;
{Prepare}
X:=StripService(X,False);
MaxP:=Length(X);
//Web
For P:=1 to MaxP Do If (X[P]='/') or (X[P]='\') then exit;
//Email
cP:=0;
For P:=1 to MaxP Do If (X[P]='@') then cP:=cP+1;
If (cP=1) then
   begin
   Result:=False;
   exit;
   end;//end of if
except;end;
end;
//## MaxLen ##
function TMisc.MaxLen(x:trichedit;y:integer):boolean;
var
   a:tstringstream;
begin
try
{error}
result:=false;
{check}
if (x=nil) then exit;
{prepare}
a:=nil;
{process}
//enforce range
if (y<=0) then y:=409600*3;{1.2288Mb}
//get
a:=tstringstream.create(general.nullstr(y,'A'));
a.position:=0;
//set
x.lines.clear;
x.lines.loadfromstream(a);
{successful}
result:=true;
except;end;
try
if (x<>nil) then x.lines.clear;
a.free;
except;end;
end;

//####################### TLanguage ############################################
//## Create ##
Constructor TLanguage.Create(Open:Boolean);
begin
{iHistory}
iHistory:=nil;
iHistory:=TStringList.create;
{ipItems}
ipItems:=@iItems;
{Scambler Keys for KeyA & KeyB}
iKeyC:='!#498af;JJasoae4K*B qx'' *&^124;qe]9q87HGU35';
iKeyD:=')_9sa=-23alasr0aw-0aw9509q381h6kIQW98AOR90uu90q85]qiami]-ae5kqi0988C3590[8[098[M[OPAS';
{Clear}
Clear;
{Load}
If Open then Load;
end;
//## destroy ##
destructor TLanguage.destroy;
begin
try
{iHistory}
iHistory.free;
iHistory:=nil;
{clean up}
if (FLanguage=Self) then FLanguage:=nil;
except;end;
end;
//## free ##
procedure TLanguage.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## SetDebug ##
Procedure TLanguage.SetDebug(X:Boolean);
begin
try
If (iDebug=X) then exit;
iDebug:=X;
If iDebug then
   begin
   General.ShowError('Translator in debug mode');
   {iHistory}
   iHistory.Clear;
   end;//end of if
except;end;
end;
//## Find ##
Function TLanguage.Find(X:String):Integer;
Var{X: Plain text only}
   P,MaxP:Integer;
begin
try
{Error}
Result:=-1;
If (X='') then exit;
X:=UpperCase(X);
{Search}
MaxP:=iItems.Count-1;
For P:=0 to MaxP Do
begin
If (X[1]=iItems.Items[P][2][1]) and (X=iItems.Items[P][2]) then
   begin
   Result:=P;
   break;
   end;//end of if
end;//end of loop
except;end;
end;
//## Add ##
Function TLanguage.Add(X,Y:String):Integer;
Label{X,Y: Plain text only}
     SkipEnd;
Var
   P:Integer;
   New:Boolean;
begin
try
{Error}
Result:=-1;
iErrorMessage:=gecUnexpectedError;
New:=False;
{Empty}
If (X='') or (Y='') then
   begin
   iErrorMessage:=gecEmpty;
   Goto SkipEnd;
   end;//end of if
{Find}
P:=Find(X);
If (P=-1) then
   begin
   {Add Item}
   P:=iItems.Count;
   If (P>lgicMaxIndex) then
      begin
      iErrorMessage:=gecCapacityReached;
      Goto SkipEnd;
      end;//end of if
   {New}
   New:=True;
   end;//end of if
{Add/Edit Item}
iItems.Items[P][1]:=Y;
If New then
   begin
   iItems.Items[P][0]:=X;
   iItems.Items[P][2]:=UpperCase(X);
   iItems.Count:=P+1;
   end;//end of if
{Return Result}
Result:=P;
SkipEnd:
except;end;
end;
//## Clear ##
Procedure TLanguage.Clear;
begin
try
iCaption:='English';
iTEP:='';
iDetails:='';
iItems.Count:=0;
iKeyA:='&^*134AFdk#a9LasmLKJnad;;aASer kaleIoa.,A.a0-9)(q9872@';
iKeyB:='(*&12=+"az//a20-a==-q3ax;l aAaljAEOalkjmaoaE#masfpa';
except;end;
end;
//## GetItems ##
Function TLanguage.GetItems:String;
Var
   A:TLI;
   B:TMemoryStream;
   C:TStringStream;
   P,MaxP:Integer;
begin
try
{Prepare}
A:=nil;
B:=nil;
C:=nil;
A:=TLI.Create(nil);
B:=TMemoryStream.Create;
{Items -> Stream}
MaxP:=iItems.Count-1;
For P:=0 to MaxP Do
begin
A.X:=General.StdEncrypt(iItems.Items[P][0],iKeyA,0);
A.Y:=General.StdEncrypt(iItems.Items[P][1],iKeyB,0);
B.WriteComponent(A);
end;//end of loop
{Stream -> String}
C:=TStringStream.Create('');
C.CopyFrom(B,0);
B.Clear;
{Return Result}
Result:=C.DataString;
except;end;
try;A.Free;B.Free;C.Free;except;end;
end;
//## SetItems ##
Procedure TLanguage.SetItems(X:String);
Label
     ReDo;
Var
   A:TLI;
   B:TMemoryStream;
   C:TStringStream;
begin
try
A:=nil;
B:=nil;
C:=nil;
{String -> StringStream}
C:=TStringStream.Create(X);
{StringStream -> Stream}
B:=TMemoryStream.Create;
B.CopyFrom(C,0);
C.Position:=0;{Clear}
B.Position:=0;
{Read Items}
A:=TLI.Create(nil);
iItems.Count:=0;
{Process Items}
ReDo:
{Read A}
B.ReadComponent(A);
{Assign}
//English
iItems.Items[iItems.Count][0]:=General.StdEncrypt(A.X,iKeyA,1);
//Dutch
iItems.Items[iItems.Count][1]:=General.StdEncrypt(A.Y,iKeyB,1);
//UpperCase English
iItems.Items[iItems.Count][2]:=UpperCase(iItems.Items[iItems.Count][0]);
iItems.Count:=iItems.Count+1;
If (iItems.Count<=lgicMaxIndex) then Goto ReDo;
except;end;
try;A.Free;B.Free;C.Free;except;end;
end;
//## GetpKeyA ##
Function TLanguage.GetpKeyA:String;
begin
try;Result:=General.StdEncrypt(iKeyA,iKeyC,1);except;end;
end;
//## GetpKeyB ##
Function TLanguage.GetpKeyB:String;
begin
try;Result:=General.StdEncrypt(iKeyB,iKeyD,1);except;end;
end;
//## GetpDetails ##
Function TLanguage.GetpDetails:String;
begin
try;Result:=General.StdEncrypt(iDetails,iKeyA,1);except;end;
end;
//## SetpKeyA ##
Procedure TLanguage.SetpKeyA(X:String);
begin
try;iKeyA:=General.StdEncrypt(X,iKeyC,0);except;end;
end;
//## SetpKeyB ##
Procedure TLanguage.SetpKeyB(X:String);
begin
try;iKeyB:=General.StdEncrypt(X,iKeyD,0);except;end;
end;
//## SetpDetails ##
Procedure TLanguage.SetpDetails(X:String);
begin
try;iDetails:=General.StdEncrypt(X,iKeyA,0);except;end;
end;
//## LoadFromStream ##
Function TLanguage.LoadFromStream(X:TStream):Boolean;
Label
     SkipEnd;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecUnsupportedFormat;
{Clear}
Clear;
{Load}
X.ReadComponent(Self);
{Successful}
Result:=True;
except;end;
{Default to English on error}
try;If Not Result then Clear;except;end;
end;
//## SaveToStream ##
Function TLanguage.SaveToStream(X:TStream):Boolean;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
{Write}
X.WriteComponent(Self);
{Successful}
Result:=True;
except;end;
end;
//## LoadFromFile ##
Function TLanguage.LoadFromFile(X:String;Xpos:Integer):Boolean;
Label
     SkipEnd;
Var
   iStream:TStream;
begin
try
{Error}
Result:=False;
iStream:=nil;
If (Xpos<0) then Xpos:=0;
{Open Stream}
iErrorMessage:=gecFileNotFound;
If Not FileExists(X) then exit;
iErrorMessage:=gecFileInUse;
iStream:=TFileStream.Create(X,fmOpenRead+fmShareDenyNone);
iStream.Position:=Xpos;
{LoadFromStream}
If Not LoadFromStream(iStream) then Goto SkipEnd;
{Successful}
Result:=True;
SkipEnd:
except;end;
try;iStream.Free;except;end;
end;
//## SaveToFile ##
Function TLanguage.SaveToFile(X:String):Boolean;
Label
     SkipEnd;
Var
   A:TMemoryStream;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecOutOfMemory;
A:=nil;
A:=TMemoryStream.Create;
{SaveToStream}
If Not SaveToStream(A) then Goto SkipEnd;
{Remove File}
iErrorMessage:=gecFileInUse;
If Not Paths.RemFile(X) then Goto SkipEnd;
{SaveToFile}
iErrorMessage:=gecOutOfDiskSpace;
A.SaveToFile(X);
{Successful}
Result:=True;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## FileName ##
Function TLanguage.FileName:String;
begin
try;Result:=bvfolder(bvfLanguage)+'language.llf';except;end;
end;
//## Load ##
Function TLanguage.Load:Boolean;
Label
     SkipEnd;
Var
   P:Integer;
   X:String;
begin
try
//check
if not programlanguagesupport then
   begin
   clear;
   result:=true;
   exit;
   end;
{Error}
Result:=False;
X:=FileName;
If Not FileExists(X) then
   begin
   {Clear}
   Clear;
   {Ok}
   Result:=True;
   Goto SkipEnd;
   end;//end of if
{Load File}
For P:=1 to 10 Do
begin
{LoadFromFile}
If LoadFromFile(X,0) then
   begin
   Result:=True;
   break;
   end;//end of if
{Process Error}
If (iErrorMessage<>gecFileInUse) then break;
{File in use, try again shortly}
Sleep(20);
end;//end of loop
SkipEnd:
except;end;
end;
//## Save ##
Function TLanguage.Save:Boolean;
Var
   P:Integer;
   X:String;
begin
try
{Error}
Result:=False;
X:=FileName;
For P:=1 to 10 Do
begin
{SaveToFile}
If SaveToFile(X) then
   begin
   Result:=True;
   break;
   end;//end of if
{Process Error}
If (iErrorMessage<>gecFileInUse) then break;
{File in use, try again shortly}
Sleep(20);
end;//end of loop
except;end;
end;
//## TranslateLine ##
Function TLanguage.TranslateLine(Var X:String):Boolean;
Label
     SkipEnd;
Var
   P:Integer;
begin
try
{Not Found}
Result:=False;
{Search}
P:=Find(X);
{Debug}
If iDebug then
   begin
   Case (P=-1) of
   False:iHistory.Add(X);
   True:iHistory.Add('*'+X);{Not Found}
   end;//end of case
   end;//end of if
{Not Found}
If (P=-1) then Goto SkipEnd;
{Succesful}
X:=iItems.Items[P][1];
Result:=True;
SkipEnd:
except;end;
end;
//## SwapFirstChar ##
Procedure TLanguage.SwapFirstChar(Var X,Y,Z:String;Replace:Boolean);
Var
   P,MaxP:Integer;
   uY,lY:String;
begin
try
MaxP:=Length(X);
If (X='') or (Y='') then exit;
uY:=UpperCase(Y[1]);
lY:=LowerCase(Y[1]);
{Scan}
For P:=1 to MaxP Do
begin
If (X[P]=lY) or (X[P]=uY) then
   begin
   Y:=Copy(X,P+1,1);
   Case Replace of
   True:X:=Copy(X,1,P-1)+Z+Copy(X,P+1,MaxP);
   False:X:=Copy(X,1,P-1)+Z+Copy(X,P,MaxP);
   end;//end of case
   break;
   end;//end of if
end;//end of loop
except;end;
end;
//## Translate ##
Function TLanguage.Translate(X:String;Var Y:Boolean):String;
Var
   P,P2,MaxP,MaxP2:Integer;
   sX,rX,Z:String;
   A:TStringList;
begin
try
{Default}
Result:=X;
Y:=True;
A:=nil;
A:=TStringList.Create;
{X -> Lines}
A.Text:=X;
{Process All Lines}
Result:='';
MaxP2:=A.Count-1;
For P2:=0 to MaxP2 Do
begin
X:=A.Strings[P2];
Z:='';
{Strip Trailing "., "}
 MaxP:=Length(X);
 For P:=MaxP downTo 1 Do
 begin
 If (X[P]<>'.') and (X[P]<>',') and (X[P]<>' ') then
    begin
    Z:=Copy(X,P+1,MaxP);
    X:=Copy(X,1,P);
    break;
    end;//end of if
 end;//end of loop
{Strip First "&"}
 sX:='&';
 rX:='';
 SwapFirstChar(X,sX,rX,True);
{Translate Line}
If Not TranslateLine(X) then Y:=False;
{Re-insert "&" to same letter "F"}
 If (sX<>'&') then
    begin
    rX:='&';
    SwapFirstChar(X,sX,rX,False);
    end;//end of if
{Add to Result}
Result:=Result+X+Z;
If (P2<MaxP2) then Result:=Result+RCode;
end;//end of loop
except;end;
try;a.free;except;end;
end;
//## ShowError ##
Procedure TLanguage.ShowError;
begin
try;General.ShowError(iErrorMessage);except;end;
end;

//################# ECap #######################################################
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
    Z:=General.StdEncrypt(X,K,ee);
    {Header - kLlength(1),Key(10-50),eData(0..X)}
    Z:=Chr(14+kLen)+General.StdEncrypt(K,glseEDK,dd)+Z;
    {Filter}
    if not bin then General.SwapStrs(Z,#39,#39+#39);
    {Return Result}
    Result:=Z;
    end;//end of begin
False:begin{Decrypt}
     {Filter}
     if not bin then General.SwapStrs(X,#39+#39,#39);
     {kLength}
     kLen:=Ord(X[1])-14;
     {Prepare}
     K:=Copy(X,2,kLen);
     Z:=Copy(X,kLen+2,Length(X));
     {Decrypt}
     K:=General.StdEncrypt(K,glseEDK,ee);
     Z:=General.StdEncrypt(Z,K,dd);
     {Return Result}
     Result:=Z;
     end;//end of begin
end;//end of case
except;end;
end;

//################# Image Printer ##############################################
//## ImagePrinterEXE ##
Function ImagePrinterEXE:String;
begin
try;Result:=low__platroot+'Image Printer.EXE';except;end;
end;
//## CanRunImagePrinter ##
Function CanRunImagePrinter:Boolean;
begin
try;Result:=FileExists(ImagePrinterEXE);except;end;
end;
//## ImagePrinterTempFile ##
Function ImagePrinterTempFile:String;
begin
try;Result:=bvfolder(bvfTemp)+'imageprinter.bmp';except;end;
end;
//## ImagePrinterCleanUp ##
Procedure ImagePrinterCleanUp;
begin
try;Paths.RemFile(ImagePrinterTempFile);except;end;
end;
//## RunImagePrinter ##
Function RunImagePrinter(X:TBitmap;DocTitle:String;Var E:String):Boolean;
Var
   Z:String;
begin
try
//Error
Result:=False;
E:=gecFileNotFound;
If Not CanRunImagePrinter then exit;
E:=gecUnknownFormat;
If (X=nil) then exit;
E:=gecFileInUse;
Z:=ImagePrinterTempFile;
If Not Paths.RemFile(Z) then exit;
E:=gecOutOfDiskSpace;
X.SaveToFile(Z);
//Run ImagePrinter
Run(ImagePrinterEXE,'"'+Z+'" "'+DocTitle+'"');
//Successful
Result:=True;
except;end;
end;


//## Scan ##
Function Scan:TScan;
begin
try;if (FScan=nil) then FScan:=TScan.Create;Result:=FScan;except;end;
end;
//## ZFile ##
Function ZFile:TZFile;
begin
try;if (FZFile=nil) then FZFile:=TZFile.Create;Result:=FZFile;except;end;
end;
//## Paths ##
Function Paths:TPaths;
begin
try;if (FPaths=nil) then FPaths:=TPaths.Create;Result:=FPaths;except;end;
end;
//## General ##
Function General:TGeneral;
begin
try;if (FGeneral=nil) then FGeneral:=TGeneral.Create;Result:=FGeneral;except;end;
end;
//## Misc ##
Function Misc:TMisc;
begin
try;if (FMisc=nil) then FMisc:=TMisc.create;Result:=FMisc;except;end;
end;
//## Language ##
Function Language:TLanguage;
begin
try;if (FLanguage=nil) then FLanguage:=TLanguage.Create(True);Result:=FLanguage;except;end;
end;
//## TranslateMenu ##
Procedure TranslateMenu(X:TMenuItem);
Var
   P,MaxP:Integer;
begin
try
{Ignore}
If (X=nil) then exit;
{Caption}
If (X.Caption<>'-') then X.Caption:=Translate(X.Caption);
{SubItems}
MaxP:=X.Count-1;
For P:=0 to MaxP Do TranslateMenu(X.Items[P]);
except;end;
end;

//################## Main - Ligthweight System #################################
function PeekMessage; external user32 name 'PeekMessageA';
function SendMessage; external user32 name 'SendMessageA';
function TranslateMessage; external user32 name 'TranslateMessage';
function DispatchMessage; external user32 name 'DispatchMessageA';
function WaitMessage; external user32 name 'WaitMessage';
function CreateWindowEx; external user32 name 'CreateWindowExA';
function GetSystemMetrics; external user32 name 'GetSystemMetrics';
function ShowWindow; external user32 name 'ShowWindow';
function RegisterClassEx; external user32 name 'RegisterClassExA';
function RegisterClass; external user32 name 'RegisterClassA';
function GetClassInfo; external user32 name 'GetClassInfoA';
function GetClassInfoEx; external user32 name 'GetClassInfoExA';
function SetWindowLong; external user32 name 'SetWindowLongA';
function DefWindowProc; external user32 name 'DefWindowProcA';
function LoadIcon; external user32 name 'LoadIconA';
function LoadCursor; external user32 name 'LoadCursorA';
function LoadCursorFromFile; external user32 name 'LoadCursorFromFileA';
function SetSystemCursor; external user32 name 'SetSystemCursor';
function GetStockObject; external gdi32 name 'GetStockObject';
function LoadResource; external kernel32 name 'LoadResource';
function SetWindowPos; external user32 name 'SetWindowPos';
function ReplyMessage; external user32 name 'ReplyMessage';
procedure PostQuitMessage; external user32 name 'PostQuitMessage';
function GetWindowPlacement; external user32 name 'GetWindowPlacement';
function SetWindowPlacement; external user32 name 'SetWindowPlacement';
function GetClientRect; external user32 name 'GetClientRect';
function GetWindowRect; external user32 name 'GetWindowRect';
function AdjustWindowRect; external user32 name 'AdjustWindowRect';
function GetDC; external user32 name 'GetDC';
function GetWindowDC; external user32 name 'GetWindowDC';
function ReleaseDC; external user32 name 'ReleaseDC';
function StretchBlt; external gdi32 name 'StretchBlt';
function TextOut; external gdi32 name 'TextOutA';
function ExtTextOut; external gdi32 name 'ExtTextOutA';
function Rectangle; external gdi32 name 'Rectangle';
function DestroyWindow; external user32 name 'DestroyWindow';
function GetCapture; external user32 name 'GetCapture';
function SetCapture; external user32 name 'SetCapture';
function ReleaseCapture; external user32 name 'ReleaseCapture';
function BeginPaint; external user32 name 'BeginPaint';
function EndPaint; external user32 name 'EndPaint';
function CreatePopupMenu; external user32 name 'CreatePopupMenu';
function AppendMenu; external user32 name 'AppendMenuA';
function GetSubMenu; external user32 name 'GetSubMenu';
function GetMenuItemID; external user32 name 'GetMenuItemID';
function GetMenuItemCount; external user32 name 'GetMenuItemCount';
function CheckMenuItem; external user32 name 'CheckMenuItem';
function EnableMenuItem; external user32 name 'EnableMenuItem';
function InsertMenuItem; external user32 name 'InsertMenuItemA';
function DestroyMenu; external user32 name 'DestroyMenu';
function TrackPopupMenu; external user32 name 'TrackPopupMenu';
function GetSystemMenu; external user32 name 'GetSystemMenu';
function GetCursorPos; external user32 name 'GetCursorPos';
function SetFileAttributes; external kernel32 name 'SetFileAttributesA';
function DeleteFile; external kernel32 name 'DeleteFileA';
function SetCursor; external user32 name 'SetCursor';
function GetTempPath; external kernel32 name 'GetTempPathA';
function CreateDirectory; external kernel32 name 'CreateDirectoryA';
function SHGetSpecialFolderLocation; external shell32 name 'SHGetSpecialFolderLocation';
function SHGetPathFromIDList; external shell32 name 'SHGetPathFromIDListA';
function ShellExecute; external shell32 name 'ShellExecuteA';
function GetTickCount; external kernel32 name 'GetTickCount';
function UpdateWindow; external user32 name 'UpdateWindow';
procedure Sleep; external kernel32 name 'Sleep';

//## ReadSTDHeader ##
Function ReadSTDHeader(Var X,Hdr,Body:String):Boolean;
Var
   MaxP,P:Integer;
begin
try
{Error}
Result:=False;
{Search}
For P:=1 to MaxP Do If (X[P]=#0) then
    begin
    Hdr:=Copy(X,1,P-1);
    Body:=Copy(X,P+1,MaxP);
    {Successful}
    Result:=True;
    break;
    end;//end of if
except;end;
end;
//## Draw3DFrame ##
Procedure Draw3DFrame(X:TFrameInfo;Img:TBitmap);
Label
     SkipOne;
Var{X-multi lined inputs: Width%,Color1,Color2
    Width%: "d"(default=100%), "r"(remaining percentage), "0..100"(real percentage)
    Color1: "d"(use col), "-X..0..+X"(real color), "sXX"(shade of col)
    Color2: "d"(use col), "-X..0..+X"(real color), "sXX"(shade of col)
}
   dXpos,Zadj,Zpos,Zlen,C,MaxP,P,P1,MaxP2,P2,dX,dY,dW,dH:Integer;
   pWrem,pW,dC1,dC2:Integer;
   A:Array[0..2] of String;
   B:TStringList;
   Z:String;
begin
try
{Ignore}
If (X.Width<=0) or (Img=nil) or (X.Style='') then exit;
{Prepare}
B:=nil;
B:=TStringList.Create;
B.Text:=X.Style;
MaxP:=B.Count-1;
pWrem:=100;
pW:=0;
If (X.Color<0) then X.Color:=0;
dC1:=X.Color;
dC2:=X.Color;
dXpos:=0;
{## Process ##}
For P:=0 to MaxP Do
begin
{Defaults}
For P2:=0 to High(A) Do A[P2]:='';
{Parse Input}
Z:=B.Strings[P];
If (Z='') or (Copy(Z,1,2)='//') then Goto SkipOne;
Zlen:=Length(Z);
Zpos:=1;
Zadj:=0;
C:=0;
For P2:=1 to Zlen Do
begin
If (Z[P2]=',') or (P2=Zlen) then
   begin
   If (P2=Zlen) then Zadj:=1;
   A[C]:=Copy(Z,Zpos,P2-Zpos+Zadj);
   If (A[C]='') then A[C]:='d';{default}
   Zpos:=P2+1;
   If (C>High(A)) then break;
   C:=C+1;
   end;//end of if
end;//end of loop
{Read}
//Width%
If (A[0]='d') then pW:=100
else If A[0]='r' then pW:=pWrem
else pW:=FrcRange(StrToInt(A[0]),0,100);
//Color1
If (A[1]='d') then dC1:=X.Color
else If Copy(A[1],1,1)='s' then dC1:=ColSplice(StrToInt(Copy(A[1],2,Length(A[1]))),X.Color,clBlack)
else dC1:=StrToInt(A[1]);
//Color2
If (A[2]='d') then dC2:=X.Color
else If Copy(A[2],1,1)='s' then dC2:=ColSplice(StrToInt(Copy(A[2],2,Length(A[2]))),X.Color,clBlack)
else dC2:=StrToInt(A[2]);
{Draw}
MaxP2:=FrcRange((pW*X.Width) Div 100,0,x.width);
For P2:=0 to MaxP2 Do
begin
If (MaxP2=0) then P1:=0 else P1:=(P2*100) Div MaxP2;
dX:=dXpos+P2;dY:=dX;dW:=Img.Width-dX;dH:=Img.Height-dX;
{Enforce maxWidth}
If (dX>=X.Width) then break;
Img.Canvas.Brush.Color:=ColSplice(P1,dC2,dC1);
Img.Canvas.FrameRect(Rect(dX,dY,dW,dH));
end;//end of loop
dXpos:=dX+1;
pWrem:=FrcMin(pWrem-pW,0);
If (pWrem<=0) then break;
SkipOne:
end;//end of loop
except;end;
try;B.Free;except;end;
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
//## ColBright ##
Function ColBright(X:Integer):Integer;
Var
   A:TInt4;
begin
try
Result:=0;
{Process}
A.val:=X;
If (A.R>Result) then Result:=A.R;
If (A.G>Result) then Result:=A.G;
If (A.B>Result) then Result:=A.B;
except;end;
end;
//## InvColor ##
Function InvColor(X:Integer;GreyCorrection:Boolean):Integer;
Var
   Cinv:TInt4;
   Ok:Boolean;
begin
try
{Prepare}
Cinv.val:=X;
Ok:=False;
{Process}
Case GreyCorrection of
False:Ok:=True;
True:Case ColBright(Cinv.val) of
     100..156:Cinv.val:=clWhite
     else
      Ok:=True;
     end;//end of case
end;//end of case
{Invert}
If Ok then
   begin
   Cinv.R:=(255-Cinv.R);
   Cinv.G:=(255-Cinv.G);
   Cinv.B:=(255-Cinv.B);
   end;//end of if
{Return Result}
Result:=Cinv.val;
except;end;
end;
//## StripService ##
Function StripService(X:String;Full:Boolean):String;
Label
     ReDo;
Var
   Y:String;
   MaxP,P:Integer;
begin
try
{Default}
Result:=X;
{Process}
ReDo:
Y:=LowerCase(Copy(X,1,7));
If (Y='mailto:') or (Y='http://') then
   begin
   X:=Copy(X,8,Length(X));
   If (X<>'') then Goto ReDo;
   end;//end of if
{Full}
If Full then
   begin
   MaxP:=Length(X);
   For P:=1 to MaxP Do If (X[P]='?') then
       begin
       X:=Copy(X,1,P-1);
       break;
       end;//end of if
   end;//end of if
{Return Result}
Result:=X;
except;end;
end;
//## CopyTo ##
Function CopyTo(Source,Dest:String;Var E:String):Boolean;
Var
   DPath:String;
begin
try
{Error}
Result:=False;
E:=gecFileNotFound;
If Not FileExists(Source) then exit;
{Enforce Path}
DPath:=ExtractFilePath(Dest);
If Not DirectoryExists(DPath) then ForceDirectories(DPath);
{Remove File}
E:=gecFileInUse;
If Not RemFile(Dest) then exit;
{Copy}
E:=gecOutOfDiskSpace;
Result:=CopyFile(PChar(Source),PChar(Dest),False);
except;end;
end;
//## fireevent ##
Procedure fireevent(x:tnotifyevent;y:tobject);
begin
try;if assigned(x) then x(y);except;end;
end;
//## swapInt ##
procedure swapInt(var x,y:LongInt);
var
   z:integer;
begin
try
z:=x;
x:=y;
y:=z;
except;end;
end;
//## NewForm ##
function NewForm(p:twincontrol):tform;
begin
try
{default}
result:=nil;
{process}
result:=tform.create(p);
with result do
begin
parent:=p;
bordericons:=[];
borderstyle:=bsNone;
vertscrollbar.visible:=false;
horzscrollbar.visible:=false;
caption:='';
hint:='';
showHint:=false;
end;//end of with
except;end;
end;
//## decText ##
function decText(x:boolean;y,n:string):string;{Decision Text}
begin
try;if x then result:=y else result:=n;except;end;
end;
//## StrLen ##
Function StrLen(Str: PChar): Cardinal; assembler;
asm
MOV     EDX,EDI
MOV     EDI,EAX
MOV     ECX,0FFFFFFFFH
XOR     AL,AL
REPNE   SCASB
MOV     EAX,0FFFFFFFEH
SUB     EAX,ECX
MOV     EDI,EDX
end;
//## UpperCase ##
Function UpperCase(X:String):String;
Var
  A:Char;
  MaxP,P:Integer;
begin
try
MaxP:=Length(X);
For P:=1 to MaxP Do
begin
A:=X[P];
if (A>='a') and (A<='z') then X[P]:=Chr(Ord(A)-32);
end;//end of loop
{Return Result}
Result:=X;
except;end;
end;
//## LowerCase ##
Function LowerCase(X:String):String;
Var
  A:Char;
  MaxP,P:Integer;
begin
try
MaxP:=Length(X);
For P:=1 to MaxP Do
begin
A:=X[P];
if (A>='A') and (A<='Z') then X[P]:=Chr(Ord(A)+32);
end;//end of loop
{Return Result}
Result:=X;
except;end;
end;
//## ExtractFilePath ##
Function ExtractFilePath(X:String):String;
Var
   MaxP,P:Integer;
begin
try
{Default}
Result:='';
{Prepare}
MaxP:=Length(X);
For P:=MaxP downTo 1 Do If (X[P]='\') or (X[P]=':') then
    begin
    Result:=Copy(X,1,P);
    break;
    end;//end of if
except;end;
end;
//## TmpFile ##
Function TmpFile(Ext:String):String;
Var
   sPath:String;
begin
try
{Error}
Result:='';
{Inc}
If (TmpInfo.Tag<High(Integer)) then TmpInfo.Tag:=TmpInfo.Tag+1 else FTmpInfo.Tag:=0;
{Ensure TmpPath Exists}
sPath:=bvfolder(bvfTemp);
{Combine Path+RandomName}
Result:=sPath+IntToStr(TmpInfo.Handle)+'-'+IntToStr(TmpInfo.Tag)+'.'+Ext;
except;end;
end;
//## ColSplice ##
Function ColSplice(X,C1,C2:Integer):Integer;
Var
   A1,A2:TInt4;
   P1,P2:Integer;
begin
try
{Error}
Result:=0;
If (X>100) then
   begin
   Result:=ColSplice(FrcRange(X-100,0,100),clWhite,C1);
   exit;
   end;//end of if
{P1 & P2}
P1:=(X*100) Div 100;
P2:=FrcRange(100-P1,0,100);
{Color}
A1.val:=C1;
A2.val:=C2;
A1.R:=FrcRange((A1.R*P1+A2.R*P2) Div 100,0,255);
A1.G:=FrcRange((A1.G*P1+A2.G*P2) Div 100,0,255);
A1.B:=FrcRange((A1.B*P1+A2.B*P2) Div 100,0,255);
A1.T:=0;
{Return Result}
Result:=A1.val;
except;end;
end;
//## FileSize ##
Function FileSize(X:String):Integer;
Var
   A:TFileStream;
   AOpen:Boolean;
begin
try
{Error}
Result:=-1;
A:=nil;
A:=TFileStream.Create(X,fmOpenRead+fmShareDenyNone);
{Return Result}
Result:=A.Size;
except;end;
try;A.Free;except;end;
end;
//## FileAge ##
Function FileAge(const FileName:string):Integer;
Var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
try
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
except;end;
end;
//## FileExists ##
Function FileExists(const FileName:string):Boolean;
begin
try;Result:=FileAge(FileName)<>-1;except;end;
end;
//## RemFile ##
Function RemFile(X:string):Boolean;
begin
try
{Ok}
Result:=True;
If Not FileExists(X) then exit;
{Error}
Result:=False;
try;SetFileAttributes(PChar(X),0);except;end;
try;DeleteFile(PChar(X));except;end;
{Return Result}
Result:=Not FileExists(X);
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
//## To32Bit ##
function To32Bit(x:string):integer;{date: 16-FEB-2004}
Var
   a:TInt4;
   p:integer;
begin
try
{defaults}
result:=0;
{check}
if (length(x)<4) then exit;
{process}
for p:=1 to 4 do a.chars[p-1]:=x[p];
{return result}
result:=a.val;
except;end;
end;
//## From32Bit ##
function From32Bit(x:integer):string;{date: 16-FEB-2004}
Var
   a:TInt4;
   p:integer;
begin
try
{prepare}
a.val:=X;
result:='####';
{process}
for p:=1 to 4 do result[p]:=a.chars[p-1];
except;end;
end;
//## To64Bit ##
Function To64Bit(x:string):double;
Var
   a:TDbl8;
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
Function From64Bit(x:double):string;
Var
   a:TDbl8;
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
//## WriteStrValb ##
Function WriteStrValb(Var X:string;Val:String):Boolean;
begin
try;result:=WriteStrVal(x,val);except;end;
end;
//## WriteStrVal ##
Function WriteStrVal(Var X,Val:String):Boolean;
begin
try
{Error}
Result:=False;
{Process}
X:=X+From32Bit(Length(Val))+Val;
{Successful}
Result:=True;
except;end;
end;
//## ReadStrVal ##
Function ReadStrVal(Var Pos:Integer;Var X,Val:String):Boolean;
Var
   Len:Integer;
begin
try
{Error}
Result:=False;
{Prepare}
Len:=To32Bit(Copy(X,Pos,4));
If (Len<0) then exit;
{Process}
Val:=Copy(X,Pos+4,Len);
{Increment Pos}
Pos:=Pos+4+Len;
{Successful}
Result:=(Length(Val)=Len);
except;end;
end;
//## ReadStrBool ##
Function ReadStrBool(Var Pos:Integer;Var X:string;Var Val:boolean):Boolean;
var
   v:string;
begin
try
result:=ReadStrVal(pos,x,v);
val:=nb(v);
except;end;
end;
//## ReadStrShrtInt ##
Function ReadStrShrtInt(Var Pos:Integer;Var X:string;Var Val:ShortInt):Boolean;
var
   v:string;
begin
try
val:=0;
result:=ReadStrVal(pos,x,v);
if (v<>'') then val:=smallint(v[1]);
except;end;
end;
//## ReadStrInt ##
Function ReadStrInt(Var Pos:Integer;Var X:string;Var Val:integer):Boolean;
var
   v:string;
begin
try
result:=ReadStrVal(pos,x,v);
val:=To32bit(v);
except;end;
end;
//## ReadStrDbl ##
Function ReadStrDbl(Var Pos:Integer;Var X:string;Var Val:double):Boolean;
var
   v:string;
begin
try
result:=ReadStrVal(pos,x,v);
val:=To64bit(v);
except;end;
end;
//## SetCaptureHwnd ##
Procedure SetCaptureHwnd(X:Hwnd);
begin
try
ReleaseCapture;
FCaptureHwnd:=0;
If (X<>0) then
   begin
   SetCapture(X);
   FCaptureHwnd:=X;
   end;//end of if
except;end;
end;
//## ScreenWidth ##
Function ScreenWidth:Integer;
begin
try;Result:=GetSystemMetrics(SM_CXSCREEN);except;end;
end;
//## ScreenHeight ##
Function ScreenHeight:Integer;
begin
try;Result:=GetSystemMetrics(SM_CYSCREEN);except;end;
end;
//## Rect ##
Function Rect(X,Y,W,H:Integer):TRect;
begin
try
Result.Left:=X;
Result.Top:=Y;
Result.Right:=W;
Result.Bottom:=H;
except;end;
end;
//## AskMessage ##
Function AskMessage(const Msg: string):Boolean;
begin
try;Result:=(mbrYes=MessageBox(App.Handle,Msg,Translate('Warning'),mbWarning+MB_YESNO));except;end;
end;
//## ShowMessage ##
procedure ShowMessage(const Msg: string);
begin
try;MessageBox(App.Handle,Msg,ExtractFileName(App.EXEName),mbInformation);except;end;
end;
//## ShowErr ##
Procedure ShowErr(X:String);
begin
try;MessageBox(App.Handle,Translate(X),Translate('Error'),$10);except;end;
end;
//## StrScan ##
function StrScan(Str: PChar; Chr: Char): PChar; assembler;
asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI,Str
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        POP     EDI
        MOV     AL,Chr
        REPNE   SCASB
        MOV     EAX,0
        JNE     @@1
        MOV     EAX,EDI
        DEC     EAX
@@1:    POP     EDI
end;
//## ByteTypeTest ##
function ByteTypeTest(P: PChar; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
  if (Index = 0) then
  begin
    if P[Index] in LeadBytes then Result := mbLeadByte;
  end
  else
  begin
    if (P[Index-1] in LeadBytes) and (ByteTypeTest(P, Index-1) = mbLeadByte) then
      Result := mbTrailByte
    else if P[Index] in LeadBytes then
      Result := mbLeadByte;
  end;
end;
//## ByteType ##
function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
//  if SysLocale.FarEast then
//xxxxxx    Result := ByteTypeTest(PChar(S), Index-1);
end;
//## LastDelimiter ##
function LastDelimiter(const Delimiters, S: string): Integer;
Var
  P:PChar;
begin
try
Result:=Length(S);
P:=PChar(Delimiters);
while (Result>0) do
begin
if (S[Result]<>#0) and (StrScan(P,S[Result])<>nil) then
   if (ByteType(S,Result)=mbTrailByte) then Dec(Result) else exit;
Dec(Result);
end;//end of loop
except;end;
end;
//## ExtractFileName ##
function ExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
try
I:=LastDelimiter('\:',FileName);
Result:=Copy(FileName,I+1,MaxInt);
except;end;
end;
//## ReadFileExt ##
Function ReadFileExt(x:string;fu:boolean):string;
var
   maxp,p:integer;
begin
try
{default}
result:=x;
{prepare}
maxp:=length(x);
{process}
for p:=maxp downTo 1 do if (x[p]='.') then
    begin
    result:=copy(x,p+1,maxp);
    break;
    end;//end of if
{fu - force uppercase}
if fu then result:=uppercase(result);
except;end;
end;
//## CreateWindow ##
function CreateWindow(lpClassName:PChar;lpWindowName:PChar;dwStyle:DWORD;X,Y,nWidth,nHeight:Integer;hWndParent:HWND;hMenu:HMENU;hInstance:HINST;lpParam:Pointer):HWND;
begin
try;Result:=CreateWindowEx(0,lpClassName,lpWindowName,dwStyle,X,Y,nWidth,nHeight,hWndParent,hMenu,hInstance,lpParam);except;end;
end;
//## BN ##
Function BN(X:Boolean):String;
begin
try
Case X of
True:Result:='1';
False:Result:='0';
end;//end of case
except;end;
end;
//## bv ##
function bv(x:boolean):byte;//boolean to value
begin
try
case x of
true:result:=1;
false:result:=0;
end;//end of case
except;end;
end;
//## vb ##
function vb(x:byte):boolean;//value to boolean
begin
try;result:=(x=1);except;end;
end;
//## NB ##
Function NB(X:String):Boolean;
begin
try;Result:=(X='1');except;end;
end;
//## StrToInt ##
Function StrToInt(X:String):Integer;
Var
   Ok43:Boolean;
   Z,pValue,pSign,P,MinP,MaxP:Integer;
begin
try
{Default}
Result:=0;
If (X='') then exit;
{Prepare}
pSign:=1;
pValue:=0;
MaxP:=Length(X);
Ok43:=False;
//MinP
For P:=1 to MaxP Do
begin
Z:=Ord(X[P]);
Case Z of
48..57,43,45:begin{0..9,-,+}
    MinP:=P;
    If (Z<>43) or Ok43 then break;
    Ok43:=(Z=43);
    end;//end of begin
else
 exit;
end;//end of case
end;//end of loop
If (MinP<1) then MinP:=1;
//Sign
If (X[MinP]='-') then
   begin
   pSign:=-1;
   MinP:=MinP+1;
   If (MinP>MaxP) then exit;
   end;//end of if
{Process}
For P:=MinP to MaxP Do
begin
Z:=Ord(X[P]);
//0..9
If (Z<48) or (Z>57) then break;
//pValue
pValue:=pValue*10+(Z-48);
end;//end of if
{Return Result}
Result:=pSign*pValue;
except;end;
end;
//## IntToStr ##
Function IntToStr(X:Integer):String;
Label
     ReDo;
Var
   Z,xBy,MaxP,P:Integer;
   iNonZero:Boolean;
begin
try
{Default}
Result:='';
iNonZero:=False;
xBy:=9;{2.1 billion}
{Always >=0}
If (X<0) then
   begin
   X:=-X;
   Result:='-';
   end;//end of if
ReDo:
{X^Y}
Z:=1;
For P:=1 to xBy Do Z:=Z*10;
{Check}
If ((X>=Z) or iNonZero) or ((X=0) and (iNonZero or (xBy=1))) then
   begin
   If ((X div Z)>0) then iNonZero:=True;
   Result:=Result+Chr(48+(X div Z));
   X:=X-Z*(X div Z);
   If (X<=0) then X:=0;
   end;//end of if
{Inc}
If (xBy>=1) then
   begin
   xBy:=xBy-1;
   Goto ReDo;
   end;//end of if
except;end;
end;
//## SysHMENU ##
Function SysHMENU(Handle:Hwnd):HMENU;
begin
try;Result:=GetSystemMenu(Handle,False);except;end;
end;
//## PopMenu ##
Procedure PopMenu(Handle:HWND;X:HMENU;dX,dY:Integer);
Const
     Flags:Array[TPopupAlignment] of Word=(TPM_LEFTALIGN,TPM_RIGHTALIGN,TPM_CENTERALIGN);
Var
   FAlignment:TPopupAlignment;
begin
try
{UpdateMenu}
//xxxxxxxUpdateMenu;
{Popup}
//xxxxxxxxxSysHMenu
FAlignment:=paLeft;
TrackPopupMenu(X,Flags[FAlignment] or TPM_RIGHTBUTTON,dX,dY,0,Handle,nil);
{Close .. OS Bug fix..............//xxxxxxxxxxxxxx//aaaaaaaa}

except;end;
end;

//####################### TLiteLanguage ########################################
//## Create ##
Constructor TLiteLanguage.Create(Open:Boolean);
begin
{ipItems}
ipItems:=@iItems;
{Scambler Keys for KeyA & KeyB}
iKeyC:='!#498af;JJasoae4K*B qx'' *&^124;qe]9q87HGU35';
iKeyD:=')_9sa=-23alasr0aw-0aw9509q381h6kIQW98AOR90uu90q85]qiami]-ae5kqi0988C3590[8[098[M[OPAS';
{Clear}
Clear;
{Load}
If Open then Load;
end;
//## destroy ##
destructor TLiteLanguage.destroy;
begin
try
{clean up}
if (FLiteLanguage=Self) then FLiteLanguage:=nil;
except;end;
end;
//## free ##
procedure TLiteLanguage.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## FileName ##
Function TLiteLanguage.FileName:String;
begin
try;Result:=bvfolder(bvfLanguage)+'language.ll2';except;end;
end;
//## Find ##
Function TLiteLanguage.Find(X:String):Integer;
Var{X: Plain text only}
   P,MaxP:Integer;
begin
try
{Error}
Result:=-1;
If (X='') then exit;
X:=UpperCase(X);
{Search}
MaxP:=iItems.Count-1;
For P:=0 to MaxP Do
begin
If (X[1]=iItems.Items[P][2][1]) and (X=iItems.Items[P][2]) then
   begin
   Result:=P;
   break;
   end;//end of if
end;//end of loop
except;end;
end;
//## Add ##
Function TLiteLanguage.Add(X,Y:String):Integer;
Label{X,Y: Plain text only}
     SkipEnd;
Var
   P:Integer;
   New:Boolean;
begin
try
{Error}
Result:=-1;
iErrorMessage:=gecUnexpectedError;
New:=False;
{Empty}
If (X='') or (Y='') then
   begin
   iErrorMessage:=gecEmpty;
   Goto SkipEnd;
   end;//end of if
{Find}
P:=Find(X);
If (P=-1) then
   begin
   {Add Item}
   P:=iItems.Count;
   If (P>llicMaxIndex) then
      begin
      iErrorMessage:=gecCapacityReached;
      Goto SkipEnd;
      end;//end of if
   {New}
   New:=True;
   end;//end of if
{Add/Edit Item}
iItems.Items[P][1]:=Y;
If New then
   begin
   iItems.Items[P][0]:=X;
   iItems.Items[P][2]:=UpperCase(X);
   iItems.Count:=P+1;
   end;//end of if
{Return Result}
Result:=P;
SkipEnd:
except;end;
end;
//## Clear ##
Procedure TLiteLanguage.Clear;
begin
try
iCaption:='English';
iTEP:='';
iDetails:='';
iItems.Count:=0;
iKeyA:='&^*134AFdk#a9LasmLKJnad;;aASer kaleIoa.,A.a0-9)(q9872@';
iKeyB:='(*&12=+"az//a20-a==-q3ax;l aAaljAEOalkjmaoaE#masfpa';
except;end;
end;
//## Translate ##
Function TLiteLanguage.Translate(X:String;Var Y:Boolean):String;
Var
   P,P2,MaxP,MaxP2:Integer;
   sX,rX,Z:String;
   A:TStringList;
begin
try
{Default}
Result:=X;
Y:=True;
A:=nil;
A:=TStringList.Create;
{X -> Lines}
A.Text:=X;
{Process All Lines}
Result:='';
MaxP2:=A.Count-1;
For P2:=0 to MaxP2 Do
begin
X:=A.Strings[P2];
Z:='';
{Strip Trailing "., "}
 MaxP:=Length(X);
 For P:=MaxP downTo 1 Do
 begin
 If (X[P]<>'.') and (X[P]<>',') and (X[P]<>' ') then
    begin
    Z:=Copy(X,P+1,MaxP);
    X:=Copy(X,1,P);
    break;
    end;//end of if
 end;//end of loop
{Strip First "&"}
 sX:='&';
 rX:='';
 SwapFirstChar(X,sX,rX,True);
{Translate Line}
If Not TranslateLine(X) then Y:=False;
{Re-insert "&" to same letter "F"}
 If (sX<>'&') then
    begin
    rX:='&';
    SwapFirstChar(X,sX,rX,False);
    end;//end of if
{Add to Result}
Result:=Result+X+Z;
If (P2<MaxP2) then Result:=Result+RCode;
end;//end of loop
except;end;
try;a.free;except;end;
end;
//## TranslateLine ##
Function TLiteLanguage.TranslateLine(Var X:String):Boolean;
Label
     SkipEnd;
Var
   P:Integer;
begin
try
{Not Found}
Result:=False;
{Search}
P:=Find(X);
{Not Found}
If (P=-1) then Goto SkipEnd;
{Succesful}
X:=iItems.Items[P][1];
Result:=True;
SkipEnd:
except;end;
end;
//## SwapFirstChar ##
Procedure TLiteLanguage.SwapFirstChar(Var X,Y,Z:String;Replace:Boolean);
Var
   P,MaxP:Integer;
   uY,lY:String;
begin
try
MaxP:=Length(X);
If (X='') or (Y='') then exit;
uY:=UpperCase(Y[1]);
lY:=LowerCase(Y[1]);
{Scan}
For P:=1 to MaxP Do
begin
If (X[P]=lY) or (X[P]=uY) then
   begin
   Y:=Copy(X,P+1,1);
   Case Replace of
   True:X:=Copy(X,1,P-1)+Z+Copy(X,P+1,MaxP);
   False:X:=Copy(X,1,P-1)+Z+Copy(X,P,MaxP);
   end;//end of case
   break;
   end;//end of if
end;//end of loop
except;end;
end;
//## SetData ##
Procedure TLiteLanguage.SetData(X:String);
begin
try;_SetData(X);except;end;
end;
//## _SetData ##
Function TLiteLanguage._SetData(X:String):Boolean;
Label
     SkipEnd;
Var
   Pos,P,MaxP:Integer;
   A,B,Y:String;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecUnknownFormat;
{Header}
MaxP:=FrcRange(Length(X),0,20);
Y:='';
For P:=1 to MaxP Do If (X[P]=#0) then
    begin
    Y:=Copy(X,1,P-1);
    X:=Copy(X,P+1,Length(X));
    break;
    end;//end of if
If (Y<>llicLV2) then exit;
{Prepare}
Clear;
Pos:=1;
{Info}
//KeyA
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iKeyA:=StdEncrypt(Y,iKeyC,0);
//KeyB
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iKeyB:=StdEncrypt(Y,iKeyD,0);
//Count
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
MaxP:=To32Bit(StdEncrypt(Y,iKeyA,0))-1;
If (MaxP<0) or (MaxP>llicMaxIndex) then Goto SkipEnd;
//Caption
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iCaption:=StdEncrypt(Y,iKeyA,0);
//Details
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iDetails:=StdEncrypt(Y,iKeyA,0);
//TEP
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iTEP:=StdEncrypt(Y,iKeyA,0);
//ExtraInfo1
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iExtraInfo1:=StdEncrypt(Y,iKeyA,0);
//ExtraInfo2
If Not ReadStrVal(Pos,X,Y) then Goto SkipEnd;
iExtraInfo2:=StdEncrypt(Y,iKeyA,0);
{Items}
For P:=0 to MaxP Do
begin
//Decrypt
If Not ReadStrVal(Pos,X,A) then Goto SkipEnd;
If Not ReadStrVal(Pos,X,B) then Goto SkipEnd;
A:=StdEncrypt(A,iKeyA,1);
B:=StdEncrypt(B,iKeyB,1);
//Add
If (Add(A,B)=-1) then Goto SkipEnd;
end;//end of loop
{Successful}
Result:=True;
SkipEnd:
except;end;
try;If Not Result then Clear;except;end;
end;
//## LoadFromFile ##
Function TLiteLanguage.LoadFromFile(X:String;Xpos:Integer):Boolean;
Label
     SkipEnd;
Var
   Z:String;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecFileNotFound;
If Not FileExists(X) then Goto SkipEnd;
{Process}
//Read
Z:='';
if not fromfile(X,Z,iErrorMessage) then Goto SkipEnd;
//Data (Xpos is zero based}
If (Xpos<0) then Xpos:=0;
Z:=Copy(Z,Xpos+1,Length(Z));
If Not _SetData(Z) then Goto SkipEnd;
{Successful}
Result:=True;
SkipEnd:
except;end;
end;
//## Load ##
Function TLiteLanguage.Load:Boolean;
Label
     SkipEnd;
Var
   P:Integer;
   X:String;
begin
try
//check
if not programlanguagesupport then
   begin
   clear;
   result:=true;
   exit;
   end;
{Error}
Result:=False;
X:=FileName;
If Not FileExists(X) then
   begin
   {Clear}
   Clear;
   {Ok}
   Result:=True;
   Goto SkipEnd;
   end;//end of if
{Load File}
For P:=1 to 10 Do
begin
{LoadFromFile}
If LoadFromFile(X,0) then
   begin
   Result:=True;
   break;
   end;//end of if
{Process Error}
If (iErrorMessage<>gecFileInUse) then break;
{File in use, try again shortly}
Sleep(20);
end;//end of loop
SkipEnd:
except;end;
end;
//## ShowError ##
Procedure TLiteLanguage.ShowError;
begin
try;ShowErr(iErrorMessage);except;end;
end;

//############################# TScan ##########################################
//## Create ##
Constructor TScan.Create;
begin
{nil}
end;
//## destroy ##
destructor TScan.destroy;
begin
try
{clean up}
if (FScan=Self) then FScan:=nil;
except;end;
end;
//## free ##
procedure TScan.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## CCMatch ##
Function TScan.CCMatch(X,Y:Integer):Boolean;
begin
try;Result:=((X-100)<=Y) and ((X+100)>=Y);except;end;
end;
//## Scan ##
Procedure TScan.Scan(X,Y:Integer);
Var
   A:TScanInfo;
   Debug:Boolean;
begin
try
A.FileName:=App.EXEName;
A.ScanTo:=Y;
Debug:=(X<=0) or (Y<=0);
{ScanFile}
Case Debug of
False:If (Not ScanFile(A)) or (Not CCMatch(A.CC,X)) then
         begin
         If Not CCMatch(A.CC,X) then iErrorMessage:=gecVirusWarning;
         {Scan Failed}
         ShowError;
         Halt;
         end;//end of if
True:begin
    Case ScanFile(A) of
    True:begin
        ShowErr(gecVirusWarning+RCode+inttostr(A.CC)+','+inttostr(A.ScanTo));
        //xxxx
        Clipboard.AsText:=inttostr(A.CC)+','+inttostr(A.ScanTo);
        end;//end of begin
    False:ShowError;
    end;//end of case
    Halt;
    end;//end of begin
end;//end of case
except;end;
end;
//## ScanFile ##
Function TScan.ScanFile(Var X:TScanInfo):Boolean;
Label
     ReDo,SkipOne,SkipEnd;
Const
     By=200;
Var
   A:TFileStream;
   B:Array[0..999] of Byte;
   V,CC,Count,MaxP,P3,P2,P:Integer;
begin
try
{Error}
Result:=False;
iErrorMessage:=gecFileNotFound;
A:=nil;
If Not FileExists(X.FileName) then Goto SkipEnd;
{Prepare}
iErrorMessage:=gecFileInUse;
A:=TFileStream.Create(X.FileName,fmOpenRead+fmShareDenyNone);
If (X.ScanTo<=0) then X.ScanTo:=A.Size;
CC:=39;
Count:=0;
P3:=-By;
{Process}
ReDo:
Count:=A.Read(B,SizeOf(B));
//Scan
MaxP:=(Count Div By)-1;
For P:=0 to MaxP Do
begin
P2:=By*P;
P3:=P3+By;
If ((P3+P2)>(X.ScanTo-1)) then Goto SkipOne;
V:=B[P2];
CC:=CC+V;
Case ((V Div 2)*2=V) of
True:begin{even}
   Case V of
   0..30:CC:=CC+3;
   60..100:CC:=CC+35;
   end;//end of case
   end;//end of begin
False:begin{odd}
   Case V of
   0..5:CC:=CC+71;
   9:CC:=CC+1;
   10:CC:=CC+14;
   14:CC:=CC+47;
   33:CC:=CC+97;
   end;//end of case
   end;//end of begin
end;//end of case
end;//end of loop
If (Count>=1) then Goto ReDo;
SkipOne:
{Return Result}
X.CC:=CC;
Result:=True;
SkipEnd:
except;end;
try;A.Free;except;end;
end;
//## ShowError ##
Procedure TScan.ShowError;
begin
try;ShowErr(iErrorMessage);except;end;
end;

//####################### TMsgList #############################################
//## AddWindowProc ##
Function AddWindowProc(X:HWND;Y:TWindowProc):Integer;
begin
try;Result:=MsgList.Add(X,Y);except;end;
end;
//## DelWindowProc ##
Procedure DelWindowProc(X:HWND);
begin
try;MsgList.Del(X);except;end;
end;
//## WindowProc ##
Function WindowProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall
begin
try;Result:=MsgList.WindowProc(hwnd,msg,wParam,lParam);except;end;
end;
//## Create ##
Constructor TMsgList.Create;
begin
{ipItems}
ipItems:=@iItems;
{Clear}
Clear;
end;
//## destroy ##
destructor TMsgList.destroy;
begin
try
{clean up}
if (FMsgList=self) then FMsgList:=nil;
except;end;
end;
//## free ##
procedure TMsgList.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## WindowProc ##
Function TMsgList.WindowProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall
Var
   P:Integer;
begin
try
P:=Find(hWnd);
{Process}
Case (P=-1) or (@iItems.Items[P].Proc=nil) of
True:Result:=DefWindowProc(hwnd,msg,wParam,lParam);{Default}
False:Result:=iItems.Items[P].Proc(hwnd,msg,wParam,lParam);{Custom}
end;//end of case
except;end;
end;
//## Clear ##
Procedure TMsgList.Clear;
Var
   P,MaxP:Integer;
begin
try
MaxP:=Items.Count-1;
{Reset}
For P:=0 to MaxP Do iItems.Items[P].Proc:=nil;
{Clear}
iItems.Count:=0;
except;end;
end;
//## Find ##
Function TMsgList.Find(X:Hwnd):Integer;
Var
   P,MaxP:Integer;
begin
try
{Not Found}
Result:=-1;
MaxP:=iItems.Count-1;
{Search}
For P:=0 to MaxP Do If (iItems.Items[P].Handle=X) then
    begin
    Result:=P;
    break;
    end;//end of if
except;end;
end;
//## Add ##
Procedure TMsgList.Del(X:Hwnd);
Label
     SkipEnd;
Var
   iP,MaxP,P:Integer;
begin
try
{Check}
iP:=Find(X);
If (iP=-1) then Goto SkipEnd;
{Shift}
MaxP:=iItems.Count-2;
For P:=iP to MaxP Do iItems.Items[P]:=iItems.Items[P+1];
{Shrink}
iItems.Count:=iItems.Count-1;
SkipEnd:
except;end;
end;
//## Add ##
Function TMsgList.Add(X:Hwnd;Y:TWindowProc):Integer;
Label
     SkipEnd;
Var
   NewOk:Boolean;
   P:Integer;
begin
try
{Error}
Result:=-1;
{Check}
NewOk:=False;
P:=Find(X);
{New}
If (P=-1) then
   begin
   NewOk:=True;
   P:=iItems.Count;
   If (P>mglMaxItem) then Goto SkipEnd;
   end;//end of if
{Add/Edit}
iItems.Items[P].Handle:=X;
iItems.Items[P].Proc:=Y;
If NewOk then iItems.Count:=P+1;
SkipEnd:
{Return Result}
Result:=P;
except;end;
end;

//################ TLiteForm #######################################################
//## Create ##
Constructor TLiteForm.Create(dwStyle,dwExStyle:DWORD;pHandle:HWND);
Var
   P:Integer;
   A:TWndClassEx;
   hA:Atom;
   B:TWindowProc;
   C:TRect;
begin
{iHandle}
iHandle:=0;
{Defaults}
With iMouseInfo Do
begin
 Down:=False;
 Button:=mbLeft;
 Shift:=[];
 X:=0;
 Y:=0;
 lX:=0;
 lY:=0;
end;//end of with
{Default Styles}
If (dwStyle=-1) then dwStyle:=WS_POPUP or WS_SYSMENU or WS_GROUP;
If (dwExStyle=-1) then dwExStyle:=0;
{Other}
ipMouseInfo:=@iMouseInfo;
iTag:=0;
iVisible:=False;
{Prepare}
A.cbSize:=SizeOf(TWndClassEx);
A.style:=0;
A.lpfnWndProc:=@WindowProc;{Standard}
A.cbClsExtra:=0;
A.cbWndExtra:=0;
A.hInstance:=hInstance;
A.hIcon:=LoadIcon(HInstance,'mainicon');
A.hCursor:=hcrArrow;
A.hbrBackground:=GetStockObject(GRAY_BRUSH);;
A.lpszMenuName:=nil;
A.lpszClassName:='TLiteForm';
A.hIconSm:=LoadIcon(HInstance,'mainicon');
{iCursor}
iCursor:=A.hCursor;
{Regisitor TWndClassEx}
hA:=RegisterClassEx(A);
{Borderless Frame with Taskbar Icon/Menu/Minimizable/Restorable}
iHandle:=CreateWindowEx(dwExStyle,'TLiteForm','Form1',dwStyle,0,0,100,100,pHandle,0,hInstance,nil);
{WindowProc - Add to Global TMsgList}
AddWindowProc(Handle,WndProc);
{Size}
SetBounds(ScreenWidth Div 4,ScreenHeight Div 4,ScreenWidth Div 2,ScreenHeight Div 2);
end;
//## destroy ##
destructor TLiteForm.destroy;
var
   h:HWND;
begin
try
{prepare}
h:=iHandle;
iHandle:=0;
{process}
if (h<>0) then DestroyWindow(h);
except;end;
end;
//## free ##
procedure TLiteForm.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## _SetCursor ##
Procedure TLiteForm._SetCursor(X:HCursor);
begin
try
iCursor:=X;
SetCursor(X);
except;end;
end;
//## SetMouseCapture ##
Procedure TLiteForm.SetMouseCapture(X:Boolean);
begin
try
if (MouseCapture<>X) then
   begin
   Case X of
   True:SetCaptureHwnd(iHandle);
   False:SetCaptureHwnd(0);
   end;//end of case
   end;//end of if
except;end;
end;
//## GetMouseCapture ##
Function TLiteForm.GetMouseCapture:Boolean;
begin
try;Result:=(FCaptureHwnd=iHandle);except;end;
end;
//## SetBounds ##
Procedure TLiteForm.SetBounds(X,Y,W,H:Integer);
begin
try;SetWindowPos(Handle,0,X,Y,W,H,0);except;end;
end;
//## GetBounds ##
Function TLiteForm.GetBounds:TRect;
begin
try;GetWindowRect(Handle,Result);except;end;
end;
//## _GetClientRect ##
Function TLiteForm._GetClientRect:TRect;
begin
try;GetClientRect(Handle,Result);except;end;
end;
//## _SetClientRect ##
Procedure TLiteForm._SetClientRect(X:TRect);
Var
   A:TRect;
begin
try
If (X.Right<>ClientWidth) or (X.Bottom<>ClientHeight)then
   begin
   A:=GetBounds;
   A.Right:=X.Right+(Width-ClientWidth);
   A.Bottom:=X.Bottom+(Height-ClientHeight);
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetClientWidth ##
Function TLiteForm.GetClientWidth:Integer;
begin
try;Result:=ClientRect.Right;except;end;
end;
//## SetClientWidth ##
Procedure TLiteForm.SetClientWidth(X:Integer);
Var
   A:TRect;
begin
try
If (X<>ClientWidth) then
   begin
   A:=GetBounds;
   A.Right:=X+(Width-ClientWidth);
   A.Bottom:=Height;
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetClientHeight ##
Function TLiteForm.GetClientHeight:Integer;
begin
try;Result:=ClientRect.Bottom;except;end;
end;
//## SetClientHeight ##
Procedure TLiteForm.SetClientHeight(X:Integer);
Var
   A:TRect;
begin
try
If (X<>ClientHeight) then
   begin
   A:=GetBounds;
   A.Right:=Width;
   A.Bottom:=X+(Height-ClientHeight);
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetLeft ##
Function TLiteForm.GetLeft:Integer;
begin
try;Result:=GetBounds.Left;except;end;
end;
//## SetLeft ##
Procedure TLiteForm.SetLeft(X:Integer);
Var
   A:TRect;
begin
try
If (X<>Left) then
   begin
   A:=GetBounds;
   A.Left:=X;
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetTop ##
Function TLiteForm.GetTop:Integer;
begin
try;Result:=GetBounds.Top;except;end;
end;
//## SetTop ##
Procedure TLiteForm.SetTop(X:Integer);
Var
   A:TRect;
begin
try
If (X<>Top) then
   begin
   A:=GetBounds;
   A.Top:=X;
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetWidth ##
Function TLiteForm.GetWidth:Integer;
begin
try;Result:=GetBounds.Right-GetBounds.Left;except;end;
end;
//## SetWidth ##
Procedure TLiteForm.SetWidth(X:Integer);
Var
   A:TRect;
begin
try
If (X<>Width) then
   begin
   A:=GetBounds;
   A.Right:=X;
   A.Bottom:=Height;
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## GetHeight ##
Function TLiteForm.GetHeight:Integer;
begin
try;Result:=GetBounds.Bottom-GetBounds.Top;except;end;
end;
//## SetHeight ##
Procedure TLiteForm.SetHeight(X:Integer);
Var
   A:TRect;
begin
try
If (X<>Height) then
   begin
   A:=GetBounds;
   A.Right:=Width;
   A.Bottom:=X;
   SetBounds(A.Left,A.Top,A.Right,A.Bottom);
   end;//end of if
except;end;
end;
//## DoMouse ##
Procedure TLiteForm.DoMouse(X:Integer);
begin
try
Case X of
lfmDown:If Assigned(FOnMouseDown) then FOnMouseDown(Self,iMouseInfo.Button,iMouseInfo.Shift,iMouseInfo.X,iMouseInfo.Y);
lfmMove:If Assigned(FOnMouseMove) then FOnMouseMove(Self,iMouseInfo.Shift,iMouseInfo.X,iMouseInfo.Y);
lfmUp:If Assigned(FOnMouseUp) then FOnMouseUp(Self,iMouseInfo.Button,iMouseInfo.Shift,iMouseInfo.X,iMouseInfo.Y);
end;//end of case
except;end;
end;
//## WndProc ##
Function TLiteForm.WndProc(hWnd:HWND;Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall;
Var
   A:TCloseAction;
   B:Boolean;
   C:TMsgConv;
   PS:TPaintStruct;
   tmpDC:HDC;
begin
try
{Default Reply}
Result:=0;
If Assigned(FOnWndProc) then
   begin
   Result:=FOnWndProc(hWnd,Msg,wParam,lParam);
   If (Result<>0) then exit;
   end;//end of if
{Process}
Case Msg of
WM_SETCURSOR:begin
    SetCursor(iCursor);
    exit;
    end;//end of begin
WM_COMMAND:begin
    Perform(WM_SYSCOMMAND,wParam,lParam);
    exit;
    end;//end of begin
WM_SYSCOMMAND:;
//Mouse
WM_LBUTTONDOWN,WM_MBUTTONDOWN,WM_RBUTTONDOWN:begin
     If iMouseInfo.Down then exit;
     iMouseInfo.Down:=True;
     MouseCapture:=True;
     msgXY(lParam,iMouseInfo.X,iMouseInfo.Y);
     Case Msg of
     WM_LBUTTONDOWN:iMouseInfo.Button:=mbLeft;
     WM_MBUTTONDOWN:iMouseInfo.Button:=mbMiddle;
     WM_RBUTTONDOWN:iMouseInfo.Button:=mbRight;
     end;//end of case
     DoMouse(lfmDown);
     iMouseInfo.lX:=iMouseInfo.X;
     iMouseInfo.lY:=iMouseInfo.Y;
     end;//end of begin
WM_MOUSEMOVE:begin
     msgXY(lParam,iMouseInfo.X,iMouseInfo.Y);
     DoMouse(lfmMove);
     end;//end of if
WM_LBUTTONUP,WM_MBUTTONUP,WM_RBUTTONUP:begin
     If Not iMouseInfo.Down then exit;
     msgXY(lParam,iMouseInfo.X,iMouseInfo.Y);
     DoMouse(lfmUp);
     iMouseInfo.lX:=iMouseInfo.X;
     iMouseInfo.lY:=iMouseInfo.Y;
     MouseCapture:=False;
     iMouseInfo.Down:=False;
     end;//end of begin
//Size
WM_SIZING:;
WM_SIZE:If Assigned(FOnResize) then FOnResize(Self);
//Paint
WM_PAINT:begin
     {Prepare}
     tmpDC:=BeginPaint(Handle,PS);
     {Process}
     iPaintDC:=tmpDC;
     If Assigned(FOnPaint) then FOnPaint(Self);
     {Finish}
     EndPaint(Handle,PS);
     If (iPaintDC=tmpDC) then iPaintDC:=0;
     end;//end of begin
//Close/Destroy
WM_QUERYENDSESSION:begin
   B:=True;
   If Assigned(FOnCloseQuery) then FOnCloseQuery(Self,B);
   Result:=Integer(B);
   exit;
   end;//end of if
WM_EndSession:begin
   If Assigned(FOnEndSession) then FOnEndSession(Self);
   If Assigned(FOnHalt) then FOnHalt(Self);
   exit;
   end;//end of begin
WM_CLOSE:begin
   If Assigned(FOnClose) then FOnClose(Self);
   If Assigned(FOnHalt) then FOnHalt(Self);
   exit;
   end;//end of begin
WM_DESTROY:;
end;//end of case
{Windows Handler}
Result:=DefWindowProc(hWnd,Msg,wParam,lParam);
except;end;
end;
//## msgXY ##
Procedure TLiteForm.msgXY(X:Longint;Var rX,rY:Integer);
Var
   A:TMsgConv;
begin
try
A.lParam:=X;
rX:=A.lParamLo;
rY:=A.lParamHi;
except;end;
end;
//## Show ##
Procedure TLiteForm.Show;
begin
try;Visible:=True;except;end;
end;
//## Hide ##
Procedure TLiteForm.Hide;
begin
try;Visible:=False;except;end;
end;
//## SetVisible ##
Procedure TLiteForm.SetVisible(X:Boolean);
begin
try
{Check}
If (X=Visible) then exit;
{Set}
Case X of
True:ShowWindow(Handle,SW_SHOWNORMAL);
False:ShowWindow(Handle,SW_HIDE);
end;//end of case
iVisible:=X;
except;end;
end;
//## Perform ##
Function TLiteForm.Perform(Msg:UINT;wParam:WPARAM;lParam:LPARAM):LRESULT;
begin
try;Result:=WndProc(iHandle,Msg,wParam,lParam);except;end;
end;
//## SetCaption ##
Procedure TLiteForm.SetCaption(X:String);
begin
try
{Check}
If (X=Caption) then exit;
{Set}
Perform(WM_SETTEXT,0,LongInt(PChar(X)));
except;end;
end;
//## GetCaption ##
Function TLiteForm.GetCaption:String;
Var
  A:PChar;
  Len:Integer;
begin
try
Len:=Perform(WM_GETTEXTLENGTH,0,0);
SetString(Result,PChar(nil),Len);
if (Len<>0) then Perform(WM_GETTEXT,Len+1,LongInt(Result));
except;end;
end;
//## PaintTo ##
Procedure TLiteForm.PaintTo(dRect:TRect;sDC:HDC;sRect:TRect;Rop:DWORD);
Var
   tmpDC:HDC;
   NewDC:Boolean;
begin
try
{Prepare}
tmpDC:=iPaintDC;
NewDC:=False;
If (tmpDC=0) then
   begin
   tmpDC:=GetDC(Handle);
   NewDC:=True;
   end;//end of if
{Process}
StretchBlt(tmpDC,dRect.Left,dRect.Top,dRect.Right,dRect.Bottom,sDC,sRect.Left,sRect.Top,sRect.Right,sRect.Bottom,Rop);
except;end;
try;If NewDC then ReleaseDC(Handle,tmpDC);except;end;
end;

//################## TApp ######################################################
//## create ##
constructor TApp.create;
begin
iTerminated:=False;
iRunning:=False;
iHandle:=0;
iMainForm:=nil;
iExeName:=ParamStr(0);
end;
//## destroy ##
destructor TApp.destroy;
begin
try
{other}
iRunning:=false;
iTerminated:=true;
{OnClose}
if Assigned(FOnClose) then FOnClose(Self) else Close(Self);
{PostQuitMessage}
PostQuitMessage(0);
{clean up}
if (FApp=Self) then FApp:=nil;
except;end;
end;
//## free ##
procedure TApp.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## Run ##
Procedure TApp.Run;
begin
try
{Ignore}
If iRunning then exit;
{Run}
iRunning:=True;
{Update}
App.ProcessMessages;
{App Message Loop}
Repeat HandleMessage until Terminated;
{Free}
Free;
except;end;
end;
//## Terminate ##
Procedure TApp.Terminate;
begin
try;If Not iTerminated then iTerminated:=True;except;end;
end;
//## ProcessMessages ##
Procedure TApp.ProcessMessages;
begin
try;while ProcessMessage do {loop};except;end;
end;
//## ProcessMessage ##
Function TApp.ProcessMessage:Boolean;
Var
  Handled:Boolean;
  Msg:TMsg;
begin
try
Result:=False;
if PeekMessage(Msg,0,0,0,PM_REMOVE) then
   begin
   Result:=True;
   Case (Msg.Message<>WM_QUIT) of
   True:begin
       Handled:=False;
       If Assigned(FOnMessage) then FOnMessage(Msg,Handled);
      ///xxxxxif not IsHintMsg(Msg) and not Handled and not IsMDIMsg(Msg) and
       If (not IsKeyMsg(Msg)) then
          begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
          end;//end of if
       end;//end of begin
   False:iTerminated:=True;
   end;//end of case
   end;//end of if
except;end;
end;
//## HandleMessage ##
Procedure TApp.HandleMessage;
begin
try;if not ProcessMessage then Idle;except;end;
end;
//## Idle ##
Procedure TApp.Idle;
Var
  Done:Boolean;
begin
try
Done:=True;
{OnIdle}
if Assigned(FOnIdle) then FOnIdle(Self, Done);
{Wait}
if Done then WaitMessage;
except;end;
end;
//## IsKeyMsg ##
Function TApp.IsKeyMsg(var Msg:TMsg):Boolean;
Var
   WND:HWND;
begin
try
Result:=False;
with Msg do
if (Message>=WM_KEYFIRST) and (Message<=WM_KEYLAST) and (GetCapture=0) then
   begin
   Wnd:=HWnd;
   {MainForm}
   //xxxxif (MainForm<>nil) then Wnd:=MainForm;//xxx (Wnd=MainForm.ClientHandle) then Wnd:=MainForm.Handle;
   {Send Message}
   if (SendMessage(Wnd,CN_BASE+Message,WParam,LParam)<>0) then Result:=True;
   end;//end of if
except;end;
end;
//## Close ##
Procedure TApp.Close(Sender:TObject);
begin{Place App Close Code Here}
try
{nil}
except;end;
end;


//## LiteLanguage ##
Function LiteLanguage:TLiteLanguage;
begin
try;if (FLiteLanguage=nil) then FLiteLanguage:=TLiteLanguage.Create(True);Result:=FLiteLanguage;except;end;
end;
//## Translate ##
Function Translate(X:String):String;
Var
   Y:Boolean;{Found Y=True}
begin
try
//xxxxResult:=Language.Translate(X,Y);{old}
Result:=LiteLanguage.Translate(X,Y);{new}
except;end;
end;
//## TranslateParts ##
Function TranslateParts(x:string):String;
label
     redo,skipone;
var
   a:tstringlist;
   op,s,zlen,p2,p:integer;
   sc:char;{search character = first character per line}
   z:string;
   Y:Boolean;{Found Y=True}
begin
try
{prepare}
a:=nil;
a:=tstringlist.create;
a.text:=x;
{process}
for p:=0 to (a.count-1) do
begin
//get
z:=a.strings[p];
zlen:=length(z);
//check
if (zLen<2) then
   begin
   z:='';
   goto skipone;
   end;//end of if
//sc
sc:=z[1];
z:=copy(z,2,zLen);
zLen:=zLen-1;
//scan
redo:
s:=-1;
for p2:=1 to zLen do
begin
//start
case s of
-1:if (z[p2]=sc) then s:=p2;
else
if ((z[p2]=sc) or (p2=zlen)) then
   begin
   z:=copy(z,1,s-1)+Translate(copy(z,s+1,p2-s-1))+copy(z,p2+1,zLen);
   goto redo;
   end;//end of if
end;//end of case
end;//end of loop
//set
a.strings[p]:=z;
skipone:
end;//end of loop
{return result}
result:=a.text;
except;end;
end;

{
//## TranslateAssign ##
Function TranslateAssign(FromOld:Boolean;Var ErrMsg:String):Boolean;
Label
     SkipEnd;
Var
   MaxP,P:Integer;
   A:TLiteLanguage;
   B:TLanguage;
begin//Interconnects TLanguage<->TLiteLanguage
try
//Error
Result:=False;
ErrMsg:=gecOutOfMemory;
//Prepare
A:=LiteLanguage;
B:=Language;
//Process
Case FromOld of
True:begin
    //Info
    A.Clear;
    A.Caption:=B.Caption;
    A.TEP:=B.TEP;
    A.ExtraInfo1:='';
    A.ExtraInfo2:='';
    A.KeyA:=B.KeyA;
    A.KeyB:=B.KeyB;
    A.Details:=B.Details;
    //Items
    MaxP:=B.Items.Count-1;
    For P:=0 to MaxP Do If (-1=A.Add(B.Items.Items[P][0],B.Items.Items[P][1])) then
        begin
        ErrMsg:=A.ErrorMessage;
        A.Clear;
        Goto SkipEnd;
        end;//end of if
    end;//end of begin
False:begin
    //Info
    B.Clear;
    B.Caption:=A.Caption;
    B.TEP:=A.TEP;
    B.KeyA:=A.KeyA;
    B.KeyB:=A.KeyB;
    B.Details:=A.Details;
    //Items
    MaxP:=A.Items.Count-1;
    For P:=0 to MaxP Do If (-1=B.Add(A.Items.Items[P][0],A.Items.Items[P][1])) then
        begin
        Case (B.ErrorMessage=gecCapacityReached) of
        True:break;//At Limit - No Error
        False:begin//Other Error
            ErrMsg:=B.ErrorMessage;
            B.Clear;
            Goto SkipEnd;
            end;//end of begin
        end;//end of case
        end;//end of if
    end;//end of begin
end;//end of case
//Successful
Result:=True;
SkipEnd:
except;end;
end;
{}
//## App ##
Function App:TApp;
begin
try;if (FApp=nil) then FApp:=TApp.Create;Result:=FApp;except;end;
end;
//## MsgList ##
Function MsgList:TMsgList;
begin
try
if (FMsgList=nil) then FMsgList:=TMsgList.create;
result:=FMsgList;
except;end;
end;
//## TmpInfo ##
Function TmpInfo:TLiteForm;
begin
try
if (FTmpInfo=nil) then FTmpInfo:=TLiteForm.Create(WS_DEFAULT,WS_EX_DEFAULT,0);
result:=FTmpInfo;
except;end;
end;


//################### TBinaryFile ##############################################
//## create ##
constructor TBinaryFile.create(x:string);
var
   a:TBinaryFileBuffer;
begin
{prepare}
iFileStream:=nil;
iLockCount:=0;
iLocked:=false;
//iNullStr - for Read System
iNullStr:=general.NullStr(SizeOf(a),#0);
{process}
_Open(x);
end;
//## destroy ##
destructor TBinaryFile.destroy;
begin
try
{other}
iCanWrite:=false;
iOpen:=false;
{iFileStream}
iFileStream.free;
iFileStream:=nil;
except;end;
end;
//## free ##
procedure TBinaryFile.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## Lock ##
procedure TBinaryFile.Lock;
begin
try
general.incxInt(iLockCount,1);
iLocked:=(iLockCount<>0);
except;end;
end;
//## Unlock ##
procedure TBinaryFile.Unlock;
begin
try
general.incxInt(iLockCount,-1);
iLocked:=(iLockCount<>0);
except;end;
end;
//## SetFileName ##
procedure TBinaryFile.SetFileName(x:string);
begin
try
{check}
if (uppercase(x)=uppercase(filename)) then exit;
{set}
_Open(x);
except;end;
end;
//## _Open ##
procedure TBinaryFile._Open(x:string);
var
   xOk,_CanWrite,_Open,_New:boolean;
   oldf,f:TFileStream;
begin
try
{lock}
lock;
{prepare}
_CanWrite:=false;
_Open:=false;
_New:=false;
xOk:=FileExists(x);
f:=nil;
{process}
try///.Create-ReadWrite
case xOk of
true:begin
    f:=TFileStream.create(x,fmOpenReadWrite+fmShareDenyWrite);
    _Open:=true;
    end;//end of begin
false:begin
    f:=TFileStream.create(x,fmCreate);
    _Open:=true;
    _New:=true;
    end;//end of begin
end;//end of case
except;
try//.ReadOnly
if xOk then
   begin
   f:=TFileStream.create(x,fmOpenRead+fmShareDenyNone);
   _Open:=true;
   end;//end of if
except;end;
end;
{CanWrite}
_CanWrite:=_CanWriteTo(x);
except;end;
try
{set}
//iFileStream
oldf:=iFileStream;
iFileStream:=f;
oldf.free;
//Indicators
iFileName:=x;
iCanWrite:=_CanWrite;
iNew:=_New;
iOpen:=_Open;
Unlock;
except;end;
end;
//## _CanWriteTo ##
function TBinaryFile._CanWriteTo(x:string):boolean;
var
   a:tstringlist;
   z:string;
begin
try
{no}
result:=false;
if (x='') then exit;
{prepare}
a:=nil;
z:=extractFilePath(x)+'~~TMP~~.TMP';
{process}
a:=tstringlist.create;
a.text:='1';
a.savetofile(z);
{yes}
result:=true;
except;end;
try
a.free;
if (z<>'') then paths.remFile(z);
except;end;
end;
//## WriteStr ##
function TBinaryFile.WriteStr(x:integer;var y:string):boolean;
label
     SkipEnd;
var
   a:TBinaryFileBuffer;
   ap,yLen,p,aSize,yPos:integer;
begin
try
{error}
result:=false;
{check}
iErrorMessage:=gecReadOnly;
if not CanWrite then exit;
{prepare}
iErrorMessage:=gecOutOfDiskSpace;
aSize:=SizeOf(a);
yLen:=length(y);
yPos:=1;
{process}
//seek
if (x>=0) then position:=x;
//write
for p:=1 to yLen do
begin
//fill
ap:=p-yPos+1;
a[ap-1]:=byte(y[p]);
//store
if ((ap)>=aSize) or (p=yLen) then
   begin
   yPos:=p+1;
   if (ap<>iFileStream.write(a,ap)) then goto SkipEnd;
   end;//end of if
end;//end of loop
{Successful}
result:=true;
SkipEnd:
except;end;
end;
//## ReadStr ##
function TBinaryFile.ReadStr(x:integer;yc:integer;var y:string):boolean;{3.1Mb/sec/yc=32,000 on CPU:200Mhz}
var
   a:TBinaryFileBuffer;
   i,ap,p,aSize:integer;
   z:string;
begin
try
{error}
result:=false;
{check}
iErrorMessage:=gecEmpty;
y:='';
if not Open then exit;
{prepare}
iErrorMessage:=gecOutOfDiskSpace;
aSize:=SizeOf(a);
if (yc<=0) then
   begin
   result:=true;
   exit;
   end;
{process}
//seek
if (x>=0) then position:=x;
//write
for p:=1 to yc do
begin
//get
ap:=frcmax(yc,aSize);
yc:=yc-ap;
ap:=iFileStream.read(a,ap);
if (ap=0) then break;
//set
if (ap>=1) then
   begin
   z:=copy(iNullStr,1,ap);
   for i:=1 to ap do z[i]:=chr(a[i-1]);
   y:=y+z;
   z:='';
   end;//end of if
//check
if (yc<1) then break;
end;//end of loop
{Successful}
result:=true;
except;end;
end;
//## Wipe ##
function TBinaryFile.Wipe(x,yc:integer):boolean;
var
   z:string;
   c:integer;
begin
try
{error}
result:=false;
iErrorMessage:=gecOutOfMemory;
{check}
if (yc<1) then
   begin
   result:=true;
   exit;
   end;//end of if
{prepare}
z:=copy(iNullStr,1,yc);
c:=0;
if (x>=0) then position:=x;
{process}
while TRUE do
begin
//set
if not WriteStr(-1,z) then exit;
//fill
yc:=yc-length(z);
if (yc<1) then break
else if (yc<length(z)) then z:=copy(z,1,yc);
end;//end of while
{successful}
result:=true;
except;end;
end;
//## GetPosition ##
function TBinaryFile.GetPosition:integer;
begin
try
case open of
false:result:=0;
true:result:=iFileStream.position;
end;//end of case
except;end;
end;
//## SetPosition ##
procedure TBinaryFile.SetPosition(x:integer);
begin
try
//check
if not open then exit;
//seek
if (x>=0) and (iFileStream.position<>x) then iFileStream.position:=x;
except;end;
end;

//################ TController #################################################
//## create ##
constructor TController.create;
begin
{nil}
end;
//## destroy ##
destructor TController.destroy;
begin
try
{clean up}
if (FController=self) then FController:=nil;
except;end;
end;
//## free ##
procedure TController.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## isha ##
function TController.isha(x:tcontrol):boolean;{is control height adjustable}
begin
try;result:=(x is tcustommemo) or (x is tcustomlistbox) or (x is tcustomcontrol);except;end;
end;
//## gci ##
function TController.gci(x:twincontrol):integer;{generate control id}
begin
try;result:=x.controlcount-1;except;end;
end;
//## cg ##
function TController.cg(x:twincontrol):integer;{control gap}
begin
try
case (x is TCustomPanel) of
true:result:=1;
false:result:=0;
end;//end of case
except;end;
end;
//## asch ##
procedure TController.asch(x:twincontrol);
var
   p:integer;
begin
try
{check}
if (x=nil) then exit;
{prepare}
p:=x.ControlCount-1;
if (p<0) then exit;
{process}
x.height:=x.controls[p].top+x.controls[p].height+2*cg(x);
except;end;
end;
//## aacs ##
procedure TController.aacs(sender:twincontrol;children:boolean;sp:byte;ah:boolean);{auto. arrange controls}
Var
   cL,P3,P2,P,MaxP,cW,cH,rX,rY,rW,rH:Integer;
   X:TControl;
begin
try
cW:=Sender.ClientWidth;
cH:=Sender.ClientHeight;
{special cases}
//TTabSheet - Sync all TTabSheets to "Active" TTasbSheet
if (sender is TTabSheet) and ((sender as TTabSheet).PageControl.ActivePage<>nil) then
   begin
   cW:=(sender as TTabSheet).PageControl.ActivePage.ClientWidth;
   cH:=(sender as TTabSheet).PageControl.ActivePage.ClientHeight;
   end;//end of if
MaxP:=Sender.ControlCount-1;
rX:=sp;
rY:=cg(sender);
rW:=cW-2*rX;
cL:=0;
For P:=0 to MaxP do For P2:=0 to MaxP do
begin
If (Sender.Controls[P2].Tag=P) then
   begin
   If (Sender.Controls[P2] is TLabel) or (Sender.Controls[P2] is TButton) then
      begin
      cL:=cL+1;
      If (cL>=2) then rY:=rY+sp;
      end;//end of if
   {Default Height}
   rH:=Sender.Controls[P2].Height;
   {AutoHeight}
   if (p=maxP) and (not ah) and isha(Sender.Controls[P2]) then rH:=FrcMin(cH-rY-sp,10);
   {Size}
   Sender.Controls[P2].SetBounds(rX,rY,rW,rH);
   rY:=rY+rH;
   {Child Controls}
   if children and (Sender.Controls[P2] is TWinControl) then aacs(Sender.Controls[P2] as TWinControl,children,sp,false);
   {quit}
   break;
   end;//end of of
end;//end of loop
{Auto Height}
if ah then Sender.ClientHeight:=rY+cg(sender);
except;end;
end;
//## _TTabSheet ##
function TController._TTabSheet(x:twincontrol;y:string):TTabSheet;
begin
try
result:=TTabSheet.create(x);
result.parent:=x;
result.PageControl:=x as TPageControl;
result.tag:=gci(x);
if (y<>'') then y:='('+inttostr(Result.PageControl.ControlCount)+') '+y;
result.caption:=y;
result.visible:=true;
except;end;
end;
//## _TLabel ##
function TController._TLabel(x:twincontrol;y,h:string;link:boolean;e:tnotifyevent):TLabel;
begin
try
Result:=TLabel.Create(X);
Result.Parent:=X;
Result.Caption:=Y;
Result.Tag:=gci(x);
Result.Hint:=H;
If Link then
   begin
   Result.Cursor:=crHandPoint;
   Result.Font.Color:=clBlue;
   Result.OnClick:=e;
   end;//end of if
Result.Visible:=True;
except;end;
end;
//## _TCheckBox ##
function TController._TCheckBox(x:twincontrol;y,h:string;e:tnotifyevent):TCheckBox;
begin
try
Result:=TCheckBox.Create(X);
Result.Parent:=X;
Result.Caption:=Y;
Result.Tag:=gci(x);
Result.Hint:=h;
Result.ShowHint:=(h<>'');
Result.OnClick:=e;
Result.Visible:=True;
except;end;
end;
//## _TButton ##
function TController._TButton(x:twincontrol;y,h:string;f:tnotifyevent):TButton;
begin
try
Result:=TButton.Create(X);
Result.Parent:=X;
Result.Caption:=Y;
Result.Tag:=gci(x);
Result.Hint:=H;
Result.ShowHint:=(H<>'');
Result.OnClick:=F;
Result.Visible:=True;
except;end;
end;
//## _TComboBox ##
function TController._TComboBox(x:twincontrol;y,h:string;fixed:Boolean;e:tnotifyevent):TComboBox;
begin
try
Result:=TComboBox.Create(X);
Result.Parent:=X;
if (y<>'') then Result.Items.Text:=Y;
Result.Text:='';
Result.Tag:=gci(x);
Result.Hint:=h;
Result.ShowHint:=(h<>'');
case fixed of
true:result.style:=csDropDownList;
false:result.style:=csDropDown;
end;//end of case
Result.OnChange:=e;
Result.Visible:=True;
except;end;
end;
//## _TEdit ##
Function TController._TEdit(x:twincontrol;h:string;c,e,t:tnotifyevent):TEdit;
begin
try
Result:=TEdit.Create(X);
Result.Parent:=X;
Result.Text:='';
Result.CTL3D:=False;
Result.Tag:=gci(x);
Result.Hint:=H;
Result.ShowHint:=(H<>'');
Result.OnChange:=C;
Result.OnEnter:=E;
Result.OnExit:=T;
Result.Visible:=True;
except;end;
end;
//## _TMemo ##
Function TController._TMemo(x:twincontrol;h:string;c,e,t:tnotifyevent):TMemo;
begin
try
Result:=TMemo.Create(X);
Result.Parent:=X;
Result.Text:='';
Result.CTL3D:=False;
Result.ScrollBars:=ssBoth;
Result.Height:=100;
Result.WordWrap:=false;
Result.Tag:=gci(x);
Result.Hint:=H;
Result.ShowHint:=(H<>'');
Result.OnChange:=C;
Result.OnEnter:=E;
Result.OnExit:=T;
Result.Visible:=True;
except;end;
end;
//## _THR ##
function TController._THR(x:twincontrol;t:String;f:boolean;c:integer;h:byte):TPanel;
begin
try
Result:=TPanel.Create(X);
Result.Parent:=X;
Result.Caption:=T;
Result.CTL3D:=False;
Result.Tag:=gci(x);
Result.Hint:='';
Result.Height:=H;
if not f then
   begin
   Result.BorderStyle:=bsNone;
   Result.BevelInner:=bvNone;
   Result.BevelOuter:=bvNone;
   end;//end of if
if (c>=0) then Result.Color:=C;
Result.Visible:=True;
except;end;
end;
//## _TListBox ##
function TController._TListBox(x:twincontrol;ht:String;c:integer;h:byte;ode:TDrawItemEvent):TListBox;
begin
try
Result:=TListBox.Create(X);
Result.Parent:=X;
Result.Tag:=gci(x);
case (@ode=nil) of
true:Result.style:=lbStandard;
false:begin
     Result.style:=lbOwnerDrawFixed;
     Result.OnDrawItem:=ode;
     end;//end of begin
end;//end of case
Result.Hint:=ht;
Result.ShowHint:=(ht<>'');
Result.Height:=h;
if (c>=0) then Result.Color:=C;
Result.Visible:=True;
except;end;
end;
//## _TListBx ##
{function TController._TListBx(x:twincontrol;ht:String;c:integer;h:byte;ode:TDrawItemEvent):TListBx;
begin
try
Result:=TListBx.Create(X);
Result.Parent:=X;
Result.Tag:=gci(x);
case (@ode=nil) of
true:Result.style:=lbStandard;
false:begin
     Result.style:=lbOwnerDrawFixed;
     Result.OnDrawItem:=ode;
     end;//end of begin
end;//end of case
Result.Hint:=ht;
Result.ShowHint:=(ht<>'');
Result.Height:=h;
if (c>=0) then Result.color.value:=C;
Result.Visible:=True;
except;end;
end;
//## _TBar ##
function TController._TBar(x:twincontrol;ht:String;v:boolean;oc:TNotifyEvent):TBar;
begin
try
Result:=nil;
Result:=TBar.Create(x);
Result.Parent:=x;
Result.Tag:=gci(x);
Result.OnChange:=oc;
Result.Hint:=ht;
Result.ShowHint:=(ht<>'');
Result.Vertical:=v;
Result.Visible:=True;
except;end;
end;
{}//
//## _TPanel ##
function TController._TPanel(x:twincontrol;t,ht:string;f:boolean;c:integer;h:byte):TPanel;
begin
try
Result:=TPanel.Create(X);
Result.Parent:=X;
Result.Caption:=T;
Result.Tag:=gci(x);
Result.Hint:=ht;
Result.ShowHint:=(ht<>'');
Result.Height:=h;
if not f then
   begin
   Result.BorderStyle:=bsNone;
   Result.BevelInner:=bvNone;
   Result.BevelOuter:=bvNone;
   end;//end of if
if (c>=0) then Result.Color:=C;
Result.Visible:=True;
except;end;
end;
//## _TGroupBox ##
function TController._TGroupBox(x:twincontrol;t,ht:String;c:integer;h:byte):TGroupBox;
begin
try
Result:=TGroupBox.Create(X);
Result.Parent:=X;
Result.Caption:=T;
Result.Tag:=gci(x);
Result.Hint:=ht;
Result.ShowHint:=(ht<>'');
Result.Height:=h;
if (c>=0) then Result.Color:=C;
Result.Visible:=True;
except;end;
end;
//## _TTimer ##
function TController._TTimer(x:tcomponent;I:Integer;E:Boolean;F:TNotifyEvent):TTimer;
begin
try
Result:=TTimer.create(x);
Result.Interval:=I;
Result.OnTimer:=F;
Result.Enabled:=E;
except;end;
end;
//## scs ##
Procedure TController.scs(sender:twincontrol;children:boolean;c:integer);{set control color}
Var
   P2,P,MaxP:Integer;
   X:TControl;
begin
try
MaxP:=Sender.ControlCount-1;
For P:=0 to MaxP do For P2:=0 to MaxP do
begin
If (Sender.Controls[P2].Tag=P) then
   begin
   x:=Sender.Controls[P2];
//   if (x is TLabel) then (x as TLabel).Color:=c
   if (x is TPanel) then (x as TPanel).Color:=c
   else if (x is TForm) then (x as TForm).Color:=c
   else if (x is TEdit) then (x as TEdit).Color:=c
   else if (x is TMemo) then (x as TMemo).Color:=c
   else if (x is TComboBox) then (x as TComboBox).Color:=c
   else if (x is TCheckBox) then (x as TCheckBox).Color:=c
   else if (x is TListBox) then (x as TListBox).Color:=c
   else if (x is TScrollBox) then (x as TScrollBox).Color:=c;
//   else if (x is TBar) then (x as TBar).Color:=c;
   {Child Controls}
   if children and (x is TWinControl) then scs(x as TWinControl,children,c);
   {quit}
   break;
   end;//end of of
end;//end of loop
except;end;
end;

//####################### TFindDlg #############################################
//## create ##
constructor TFindDlg.create;
const
     sp=8;
var
   h,w,y,x:integer;
begin
try
{iModified}
iModified:=false;
{iform}
iform:=tform.create(nil);
iform.parent:=nil;
iform.vertscrollbar.visible:=false;
iform.horzscrollbar.visible:=false;
iform.formstyle:=fsStayOnTop;
iform.width:=360+30;
iform.height:=126;
iform.bordericons:=[biSystemMenu];
iform.borderstyle:=bsDialog;
iform.caption:=translate('Find');
{ilabel}
ilabel:=tlabel.create(iform);
ilabel.parent:=iform;
ilabel.transparent:=true;
ilabel.caption:=translate('Fi&nd what')+':';
ilabel.left:=5;
ilabel.top:=5;
ilabel.visible:=true;
{istatus}
istatus:=tlabel.create(iform);
istatus.parent:=iform;
istatus.transparent:=true;
istatus.caption:='';
istatus.visible:=true;
{itxt}
itxt:=tcombobox.create(iform);
itxt.parent:=iform;
itxt.ctl3d:=false;
itxt.style:=csDropDown;
itxt.setbounds(ilabel.left,ilabel.top+ilabel.height+2,iform.clientwidth-130-2*sp,itxt.height);
itxt.visible:=true;
ihistory:=@itxt.items;
{ifn}
ifn:=tbutton.create(iform);
ifn.parent:=iform;
ifn.caption:=translate('&Find Next');
ifn.width:=iform.clientwidth-(itxt.left+itxt.width)-2*sp;
ifn.left:=iform.clientwidth-ifn.width-sp;
ifn.top:=itxt.top-(ifn.height-itxt.height);
ifn.default:=true;
ifn.visible:=true;
{icl}
icl:=tbutton.create(iform);
icl.parent:=iform;
icl.caption:=translate('Cancel');
icl.left:=ifn.left;
icl.width:=ifn.width;
icl.height:=ifn.height;
icl.top:=ifn.top+ifn.height+6;
icl.visible:=true;
{imwwo}
imwwo:=tcheckbox.create(iform);
imwwo.parent:=iform;
imwwo.caption:=translate('Match &whole word only');
imwwo.left:=ilabel.left;
imwwo.top:=itxt.top+itxt.height+sp;
imwwo.width:=ifn.left-imwwo.left-sp;
imwwo.visible:=true;
{mc}
imc:=tcheckbox.create(iform);
imc.parent:=iform;
imc.caption:=translate('Match &case');
imc.left:=ilabel.left;
imc.top:=imwwo.top+imwwo.height+(sp div 2);
imc.width:=imwwo.width;
imc.visible:=true;
{istatus}
istatus.left:=ilabel.left;
istatus.top:=imc.top+imc.height+2;
istatus.caption:='[ searching chapter 33 ]';
{events}
//ilabel
ilabel.focusControl:=itxt;
//buttons
ifn.OnClick:=_OnClick;
icl.OnClick:=_OnClick;
//list
itxt.OnChange:=_OnClick;
itxt.OnClick:=_OnClick;
//iform
iform.OnKeyDown:=_OnKeyDown;
iform.keypreview:=true;
{position}
general.centercontrol(iform);
iform.top:=iform.top-iform.height;{above center point}
{defaults}
status:=' ';
status:='';
except;end;
end;
//## destroy ##
destructor TFindDlg.destroy;
begin
try
{iform}
iform.visible:=false;
iform.parent:=nil;
iform.free;
iform:=nil;
except;end;
end;
//## free ##
procedure TFindDlg.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## _OnKeyDown ##
procedure TFindDlg._OnKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
try;if (key=27) then _OnClick(icl);except;end;
end;
//## GetTitle ##
function TFindDlg.GetTitle:string;
begin
try;result:=iform.caption;except;end;
end;
//## SetTitle ##
procedure TFindDlg.SetTitle(x:string);
begin
try
{check}
if (x=title) then exit;
{set}
iform.caption:=x;
{DoOnChange}
DoOnChange;
except;end;
end;
//## GetStatus ##
function TFindDlg.GetStatus:string;
begin
try;result:=istatus.caption;except;end;
end;
//## SetStatus ##
procedure TFindDlg.SetStatus(x:string);
var
   h:integer;
begin
try
{check}
if (x=status) then exit;
{set}
istatus.caption:=x;
{update}
case (x='') of
true:h:=istatus.top+5;
false:h:=istatus.top+istatus.height+2;
end;//end of case
if (iform.clientheight<>h) then iform.clientheight:=h;
{update}
istatus.repaint;
{FOnStatus}
if assigned(FOnStatus) then FOnStatus(self);
{DoOnChange}
DoOnChange;
except;end;
end;
//## GetOptions ##
function TFindDlg.GetOptions:TSearchTypes;
begin
try
result:=[];
if imwwo.visible then result:=result+[stWholeWord];
if imc.visible then result:=result+[stMatchCase];
except;end;
end;
//## SetOptions ##
procedure TFindDlg.SetOptions(x:TSearchTypes);
begin
try
{check}
if (x=options) then exit;
{set}
imwwo.visible:=(stWholeWord in x);
imc.visible:=(stMatchCase in x);
style:=style;
{DoOnChange}
DoOnChange;
except;end;
end;
//## GetStyle ##
function TFindDlg.GetStyle:TSearchTypes;
begin
try
result:=[];
if imwwo.visible and imwwo.checked then result:=result+[stWholeWord];
if imc.visible and imc.checked then result:=result+[stMatchCase];
except;end;
end;
//## SetStyle ##
procedure TFindDlg.SetStyle(x:TSearchTypes);
begin
try
{check}
if (x=style) then exit;
{set}
imwwo.checked:=imwwo.visible and (stWholeWord in x);
imc.checked:=imc.visible and (stMatchCase in x);
{DoOnChange}
DoOnChange;
except;end;
end;
//## execute ##
procedure TFindDlg.execute;
begin
try
update;
iform.show;
except;end;
end;
//## close ##
procedure TFindDlg.close;
begin
try
iform.hide;
if assigned(FOnClose) then FOnClose(self);
except;end;
end;
//## update ##
procedure TFindDlg.update;
begin
try;ifn.enabled:=(itxt.text<>'') and assigned(FOnFind);except;end;
end;
//## _OnClick ##
procedure TFindDlg._OnClick(sender:tobject);
begin
try
if (sender=icl) then close
else if (sender=ifn) then
     begin
     historyAdd;
     find;
     end
else if (sender=itxt) then
     begin
     update;
     DoOnChange;
     end;//end of if
except;end;
end;
//## find ##
procedure TFindDlg.find;
begin
try;if assigned(FOnFind) then FOnFind(self);except;end;
end;
//## GetFindText ##
function TFindDlg.GetFindText:string;
begin
try;result:=itxt.text;except;end;
end;
//## SetFindText ##
procedure TFindDlg.SetFindText(x:string);
begin
try
{ignore}
if (x=findText) then exit;
{set}
itxt.text:=x;
{DoOnChange}
DoOnChange;
except;end;
end;
//## DoOnChange ##
procedure TFindDlg.DoOnChange;
begin
try
iModified:=true;
if assigned(FOnChange) then FOnChange(self);
except;end;
end;
//## finished ##
procedure TFindDlg.finished;
begin
try;MessageBox(iform.handle,Translate('No further matches found'),iform.caption,mbWarning);except;end;
end;
//## historyAdd ##
procedure TFindDlg.historyAdd;
var
   p,maxp:integer;
   x:string;
   ok:boolean;
begin
try
{check}
if (not iModified) or (itxt.items.count>=32000) then exit;
{prepare}
iModified:=false;
ok:=true;
x:=findtext;
{process}
//scan
for p:=0 to (itxt.items.count-1) do if (x=itxt.items[p]) then
    begin
    ok:=false;
    break;
    end;//end of if
//add
if ok then itxt.items.add(x);
except;end;
end;

//#################### TInputDlg ###############################################
//## InputQry ##
function InputQry(t,l:string;var x:string):boolean;
var
   a:TInputDlg;
begin
try
{no}
result:=false;
{prepare}
a:=nil;
a:=TInputDlg.create;
a.title:=t;
a.textlabel:=l;
a.text:=x;
{process}
result:=a.execute;
{return result}
if result then x:=a.text;
except;end;
try;a.free;except;end;
end;

//## create ##
constructor TInputDlg.create;
const
     sp=8;
var
   h,w,y,x:integer;
begin
try
{iform}
iform:=tform.create(nil);
iform.parent:=nil;
iform.vertscrollbar.visible:=false;
iform.horzscrollbar.visible:=false;
iform.formstyle:=fsStayOnTop;
iform.width:=360+30;
iform.height:=126;
iform.bordericons:=[biSystemMenu];
iform.borderstyle:=bsDialog;
iform.caption:=translate('Text');
{ilabel}
ilabel:=tlabel.create(iform);
ilabel.parent:=iform;
ilabel.transparent:=true;
ilabel.caption:=translate('Text')+':';
ilabel.left:=5;
ilabel.top:=5;
ilabel.visible:=true;
{itxt}
itxt:=tedit.create(iform);
itxt.parent:=iform;
itxt.ctl3d:=false;
itxt.setbounds(ilabel.left,ilabel.top+ilabel.height+2,iform.clientwidth-130-2*sp,itxt.height);
itxt.visible:=true;
{iok}
iok:=tbutton.create(iform);
iok.parent:=iform;
iok.caption:=translate('&OK');
iok.width:=iform.clientwidth-(itxt.left+itxt.width)-2*sp;
iok.left:=iform.clientwidth-iok.width-sp;
iok.top:=itxt.top-(iok.height-itxt.height);
iok.default:=true;
iok.visible:=true;
iok.modalResult:=mrOk;
{icl}
icl:=tbutton.create(iform);
icl.parent:=iform;
icl.caption:=translate('Cancel');
icl.left:=iok.left;
icl.width:=iok.width;
icl.height:=iok.height;
icl.top:=iok.top+iok.height+6;
icl.visible:=true;
icl.modalResult:=mrCancel;
{clientheight}
iform.clientheight:=icl.top+icl.height+sp;
{events}
//iform
iform.OnKeyDown:=_OnKeyDown;
iform.keypreview:=true;
{position}
general.centercontrol(iform);
except;end;
end;
//## destroy ##
destructor TInputDlg.destroy;
begin
try
{iform}
iform.visible:=false;
iform.parent:=nil;
iform.free;
iform:=nil;
except;end;
end;
//## free ##
procedure TInputDlg.free;
begin
try;if (self<>nil) then destroy;except;end;
end;
//## _OnKeyDown ##
procedure TInputDlg._OnKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
try;if (key=27) then iform.modalresult:=mrCancel;except;end;
end;
//## GetTitle ##
function TInputDlg.GetTitle:string;
begin
try;result:=iform.caption;except;end;
end;
//## SetTitle ##
procedure TInputDlg.SetTitle(x:string);
begin
try;iform.caption:=x;except;end;
end;
//## GetTextLabel ##
function TInputDlg.GetTextLabel:string;
begin
try;result:=ilabel.caption;except;end;
end;
//## SetTextLabel ##
procedure TInputDlg.SetTextLabel(x:string);
begin
try;ilabel.caption:=x;except;end;
end;
//## execute ##
function TInputDlg.execute:boolean;
begin
try
{process}
iform.showmodal;
{return result}
result:=(iform.modalresult=mrok);
except;end;
end;
//## GetText ##
function TInputDlg.GetText:string;
begin
try;result:=itxt.text;except;end;
end;
//## SetText ##
procedure TInputDlg.SetText(x:string);
begin
try;itxt.text:=x;except;end;
end;


//## ShowError ##
procedure ShowError(x:string);
begin
try;General.ShowError(x);except;end;
end;
//## Controller ##
Function Controller:TController;
begin
try
if (FController=nil) then FController:=TController.Create;
Result:=FController;
except;end;
end;
//## aar - Auto. Aranger ##
Function aar:TController;
begin
try;result:=controller;except;end;
end;


initialization
  {Start}
  Randomize;{ECap}
  //Debug
  //Language.Debug:=True;
  //Cursors
  hcrArrow:=LoadCursor(0,IDC_ARROW);
  hcrBeam:=LoadCursor(0,IDC_IBEAM);
  hcrWait:=LoadCursor(0,IDC_WAIT);
  hcrCross:=LoadCursor(0,IDC_CROSS);
  hcrAppStart:=LoadCursor(0,IDC_APPSTARTING);

finalization
  {Finish}
  freeObj(@FScan);
  //ZFile - clean (refer to global function "ZFile")
  ZFile.clean;
  freeObj(@FZFile);
  //Other
  freeObj(@FPaths);
  freeObj(@FGeneral);
  freeObj(@FMisc);
  freeObj(@FLanguage);
  //ImagePrinter CleanUp
  ImagePrinterCleanUp;
  //MAIN
  freeObj(@FLiteLanguage);
  freeObj(@FScan);
  freeObj(@FApp);
  //ZIP/HELP
  freeObj(@FController);
  //TEMP
  freeObj(@FTmpInfo);
  freeObj(@FMsgList);{last}
  //delete
  deleteall;

end.
