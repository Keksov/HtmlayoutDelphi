unit HtmlCommon;

interface

uses Windows;

// HTMLayout API documentation http://www.terrainformatica.com/htmlayout/doxydoc/index.html

type

    HELEMENT = class end; // It's really a pointer - HELEMENT = Pointer. Class is used here for detection of logical errors during compilation.
    PHELEMENT = ^HELEMENT;

implementation
end.