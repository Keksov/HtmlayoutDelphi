unit htmlNodeInterface;

interface

uses Classes, SysUtils
;

type

{-- IHTMLNode -----------------------------------------------------------------}

    {***************************************************************************
    * IHTMLNode
    ***************************************************************************}
    IHTMLNode = interface
    function    getISelf() : IHTMLNode;
    function    getSelf() : TObject;

    function    getHtml() : string;
    procedure   clear();
    
    end;

implementation

end.
