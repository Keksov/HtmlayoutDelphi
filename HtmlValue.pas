unit HtmlValue;

interface

uses classes, sysutils, windows
    , HtmlValueH
    , HtmlTypes
    , HtmlLayoutDomH
;

type

    {***************************************************************************
    * THtmlValue
    ***************************************************************************}
    THtmlValue = class
private
    Fhandler                    : HELEMENT;
    Fvalue                      : RHtmlValue;
    FlastError                  : HLDOM_RESULT;

private
    function    getAsString() : WideString;
    procedure   setAsString( const aValue : WideString );
    procedure   setHandler( aElement : HELEMENT );

protected
    procedure   updateElement(); virtual;
    procedure   clear();

public
    constructor Create(); overload;
    constructor Create( aValue : RHtmlValue ); overload;
    constructor Create( aElement : HELEMENT ); overload;

    destructor  Destroy(); override;


public // property
    property lastError : HLDOM_RESULT read FlastError;
    property handler : HELEMENT read Fhandler write setHandler;

    property asString : WideString read getAsString write setAsString;

    end;

implementation

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlValue.Create();
begin
    Fhandler := nil;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlValue.Create( aValue : RHtmlValue );
begin
    Fvalue   := aValue;
    Fhandler := nil;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlValue.Create( aElement : HELEMENT );
begin
    handler := aElement;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlValue.Destroy();
begin
    clear();
    inherited;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THtmlValue.clear();
begin
    HTMLayoutValueClear( @Fvalue );
end;

{*******************************************************************************
* setHandler
*******************************************************************************}
procedure THtmlValue.setHandler( aElement : HELEMENT );
begin
    if ( Fhandler <> nil ) and ( Fhandler <> aElement ) then
    begin
        clear();
    end;

    Fhandler := aElement;
    if ( Fhandler = nil ) then
        exit;

    FlastError := HTMLayoutControlGetValue( Fhandler, @Fvalue );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* updateElement
*******************************************************************************}
procedure THtmlValue.updateElement();
begin
    if ( Fhandler = nil ) then
        exit;

    FlastError := HTMLayoutControlSetValue( Fhandler, @Fvalue );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getAsString
*******************************************************************************}
function THtmlValue.getAsString() : WideString;
var
    data : LPCWSTR;
    len  : cardinal;

begin
    HTMLayoutValueStringData( @Fvalue, data, len );
    SetString( Result, data, len );
end;

{*******************************************************************************
* setAsString
*******************************************************************************}
procedure THtmlValue.setAsString( const aValue : WideString );
var
    len : cardinal;
begin
    len := Length( aValue );

    if ( len <> 0 ) then
        HTMLayoutValueFromString( @Fvalue, LPCWSTR( @aValue[1] ), len, CVT_SIMPLE )
    else
        HTMLayoutValueFromString( @Fvalue, nil, 0, CVT_SIMPLE );

    updateElement();
end;

end.
