unit htmlStyle;

interface

uses classes, sysutils
    , htmlNodeInterface
    , htmlUtils
;

type

{-- THTMLStyleElement ---------------------------------------------------------}

    (***************************************************************************
    * THTMLStyleElement
    * consider CSS expression: .myclass { color: red; border:1px solid black; }
    * here .myclass is element and border:1px solid black; is declarations
    ***************************************************************************)
    THTMLStyleElement = class( TStyleList, IHTMLNode )
protected
    Felement                    : string;

private
    procedure   internalSetText( const aCSSDeclarations : string );

protected
    function    getHtml() : string; virtual;
    procedure   setHtml( const aValue : string ); virtual;

    function    QueryInterface( const IID : TGUID; out Obj ) : HResult; stdcall;
    function    _AddRef() : integer; stdcall;
    function    _Release() : integer; stdcall;
    function    getISelf() : IHTMLNode;
    function    getSelf() : TObject;

public
    constructor Create( const aElement : string ); overload;
    constructor Create( const aElement, aCSSDeclarations : string ); overload;

public // property
    property element : string read Felement write Felement;
    property declarations : string read internalGetText write internalSetText;
    property html : string read getHtml;

    end;


implementation

{-- THTMLStyleElement ---------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLStyleElement.Create( const aElement : string );
begin
    inherited Create();
    Felement := aElement;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLStyleElement.Create( const aElement, aCSSDeclarations : string );
begin
    Create( aElement );
    declarations := aCSSDeclarations;
end;

{*******************************************************************************
* QueryInterface
*******************************************************************************}
function THTMLStyleElement.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
    if GetInterface( IID, Obj ) then
        Result := 0
    else
        Result := E_NOINTERFACE;
end;

{*******************************************************************************
* _AddRef
*******************************************************************************}
function THTMLStyleElement._AddRef() : integer;
begin
    Result := 1;
end;

{*******************************************************************************
* _Release
*******************************************************************************}
function THTMLStyleElement._Release() : integer;
begin
    Result := 1;
end;

{*******************************************************************************
* IHTMLNode
*******************************************************************************}
function THTMLStyleElement.getISelf() : IHTMLNode;
begin
    Result := IHTMLNode( self );
end;

{*******************************************************************************
* getSelf
*******************************************************************************}
function THTMLStyleElement.getSelf() : TObject;
begin
    Result := self;
end;

{*******************************************************************************
* internalSetText
*******************************************************************************}
procedure THTMLStyleElement.internalSetText( const aCSSDeclarations : string );
var
    declarations : TStringList;
    declaration  : TStringList;
    i : integer;

begin
    try
        declarations := Explode( ';', aCSSDeclarations );
        for i := 0 to declarations.Count - 1 do
        begin
            declaration := Explode( ':', declarations[i], 1, lmRestOfString );
            if ( declaration.Count > 0 ) then
            begin
                props[ declaration[0] ] := IfThen( declaration.Count > 1, declaration[1], '' );
            end;

            FreeAndNil( declaration );
        end;

    finally
        FreeAndNil( declarations );
    end;
end;

{*******************************************************************************
* internalGetText
*******************************************************************************}
(*function THTMLStyleElement.internalGetText() : string;
begin
    Result := Felement + '{' + inherited internalGetText() + '}';
end;*)

{***************************************************************************
* getHtml
***************************************************************************}
function THTMLStyleElement.getHtml() : string;
begin
    Result := Felement + '{' + inherited internalGetText() + '}';
end;

{*******************************************************************************
* setHtml
*******************************************************************************}
procedure THTMLStyleElement.setHtml( const aValue : string );
begin
    assert( false, 'Implement me' );
end;


end.
