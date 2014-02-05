unit HtmlTypes;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi
*)

interface

uses Windows;

type
    // It's really a pointer - HELEMENT = Pointer. Class is used here for detection of logical errors during compilation.
    HELEMENT = class end;
    PHELEMENT = ^HELEMENT;

    LPCBYTE = PCHAR;
    INT_PTR = integer;

implementation

end.