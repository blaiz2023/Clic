unit Clic6;
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
//## Name: TOpenHandler
//## Description: Multi-Open/Save Dialog Handler for low-memory consumption (uses XP/Win98 enhanced dialogs)
//## Version: 1.00.052
//## Date: 13-NOV-2005
//## Lines: 183
//## Blaiz Enterprises (c) 1997-2005
//##############################################################################

interface

uses
  Forms, Classes, Dialogs, ExtDlgs, SysUtils, FileCtrl, Clic5;

{TOpenInfo}
Type
    TOpenInfo=Record
    DefaultEXT:String;
    Options:TOpenOptions;
    Filter:String;
    FilterIndex:Integer;
    FileName:String;
    end;//end of record
{TOpenHandler}
Type
    topenhandler=class(tobject)
    Private
     iForm:TForm;
     iOpenDialog:TOpenDialog;
     iSaveDialog:TSaveDialog;
     iOpenPictureDialog:TOpenPictureDialog;
     iSavePictureDialog:TSavePictureDialog;
    Public
     {Create}
     Constructor Create;
     {SafePath}
     Function SafePath(X:String):String;
     Function Execute(Var X:TOpenInfo;Style:TClass;NewPath:String;Var FileName:String):Boolean;
     {Free}
     Procedure Free;
    end;

Var
   FOpenHandler:TOpenHandler=nil;

Function OpenHandler:TOpenHandler;

implementation

//## Create ##
Constructor TOpenHandler.Create;
begin
{iForm}
iForm:=TForm.Create(nil);
iForm.Visible:=False;
{Dialogs}
iOpenDialog:=nil;
iSaveDialog:=nil;
iOpenPictureDialog:=nil;
iSavePictureDialog:=nil;
end;
//## Free ##
Procedure TOpenHandler.Free;
begin
try
If (Self<>nil) then
   begin
   {iForm}
   iForm.Free;
   {Self}
   Self.Destroy;
   {CleanUp}
   If (FOpenHandler=Self) then FOpenHandler:=nil;
   end;//end of if
except;end;
end;
//## SafePath ##
Function TOpenHandler.SafePath(X:String):String;
begin
try
Case DirectoryExists(X) of
False:Result:=bvfolder('');
True:Result:=X;
end;//end of case
except;end;
end;
//## Execute ##
Function TOpenHandler.Execute(Var X:TOpenInfo;Style:TClass;NewPath:String;Var FileName:String):Boolean;
Var
   Name,Path:String;
   AsOpen:Boolean;
   AsImage:Boolean;
   FatalErr:Boolean;
begin
try
{No}
Result:=False;
FileName:='';
{FatalErr}
FatalErr:=False;
{Style}
AsOpen:=(Style=TOpenPictureDialog) or (Style=TOpenDialog);
AsImage:=(Style=TOpenPictureDialog) or (Style=TSavePictureDialog);
{Name/Path}
If AsOpen then Name:='' else Name:=ExtractFileName(X.FileName);
If (NewPath<>'') then Path:=SafePath(NewPath) else Path:=SafePath(ExtractFilePath(X.FileName));
{Process}
Case AsOpen of
True:begin
     Case AsImage of
     True:begin
          If (iOpenPictureDialog=nil) then iOpenPictureDialog:=TOpenPictureDialog.Create(iForm);
          iOpenPictureDialog.DefaultEXT:=X.DefaultEXT;
          iOpenPictureDialog.Options:=X.Options;
          iOpenPictureDialog.Filter:=X.Filter;
          iOpenPictureDialog.FilterIndex:=X.FilterIndex;
          iOpenPictureDialog.InitialDir:=Path;
          iOpenPictureDialog.FileName:=Name;
          Result:=iOpenPictureDialog.Execute;
          FileName:=iOpenPictureDialog.FileName;
          {Must Remember's}
          X.FilterIndex:=iOpenPictureDialog.FilterIndex;
          end;//end of begin
     false:if opendlg(X.DefaultEXT,X.Filter,Path,X.FilterIndex,name) then
             begin
             filename:=name;
             result:=true;
             end;//end of if
     end;//end of case
     end;//end of begin
False:begin
     Case AsImage of
     True:begin
          If (iSavePictureDialog=nil) then iSavePictureDialog:=TSavePictureDialog.Create(iForm);
          iSavePictureDialog.DefaultEXT:=X.DefaultEXT;
          iSavePictureDialog.Options:=X.Options;
          iSavePictureDialog.Filter:=X.Filter;
          iSavePictureDialog.FilterIndex:=X.FilterIndex;
          iSavePictureDialog.InitialDir:=Path;
          iSavePictureDialog.FileName:=Name;
          Result:=iSavePictureDialog.Execute;
          FileName:=iSavePictureDialog.FileName;
          {Must Remember's}
          X.FilterIndex:=iSavePictureDialog.FilterIndex;
          end;//end of begin
     false:if savedlg(X.DefaultEXT,X.Filter,Path,X.FilterIndex,name) then
             begin
             filename:=name;
             result:=true;
             end;//end of if
     end;//end of case
     end;//end of begin
end;//end of case
except;FatalErr:=True;end;
try
{System Retries with more basic Dialog Box if ExtDlgs fails}
If FatalErr then
   begin
   If (Style=TOpenPictureDialog) then Result:=Execute(X,TOpenDialog,NewPath,FileName)
   else If (Style=TSavePictureDialog) then Result:=Execute(X,TSaveDialog,NewPath,FileName);
   end;//end of if
except;end;
end;


//## OpenHandler ##
Function OpenHandler:TOpenHandler;
begin
try;if (FOpenHandler=nil) then FOpenHandler:=TOpenHandler.Create;Result:=FOpenHandler;except;end;
end;


initialization
  //Start

finalization
  //Finish
  freeobj(@fopenhandler);

end.
