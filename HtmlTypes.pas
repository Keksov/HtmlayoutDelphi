unit HtmlTypes;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows;

type
    // It's really a pointer - HELEMENT = Pointer. Class is used here for detection of logical errors during compilation.
    HELEMENT = class end;
    PHELEMENT = ^HELEMENT;

    LPCBYTE = PCHAR;
    INT_PTR = ^integer;

    LPVOID = Pointer;
    PLPVOID = ^LPVOID;
    LPINT = ^integer;
    LPBOOL = PBOOL;
    LPNMHDR = PNMHDR;
    UINT_PTR = ^cardinal;
    LPUINT = UINT_PTR;
    
    PRECT = ^TRECT;
implementation

end.