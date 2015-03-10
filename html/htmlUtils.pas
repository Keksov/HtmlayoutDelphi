unit htmlUtils;

interface

uses classes, sysutils, Contnrs
    ;

type

{-- TStyleDeclaration ---------------------------------------------------------}

    {***************************************************************************
    * TStyleDeclaration
    ***************************************************************************}
    TStyleDeclaration = class
protected
    Fproperty                   : string;
    Fvalue                      : string;

private
    function    getText() : string;

public
    constructor Create( const aProperty : string );

public //property
    property text : string read getText;
    property prop : string read Fproperty write Fproperty;
    property value : string read Fvalue write Fvalue;

    end;

{-- TStyleList ----------------------------------------------------------------}

    {***************************************************************************
    * TStyleList
    ***************************************************************************}
    TStyleList = class( TObjectList )
private
    function    getText() : string;
    function    getProperty( const aProperty : string ) : string;
    procedure   setProperty( const aProperty, aValue : string );
    function    getDeclarationByIndex( aIndex : integer ) : TStyleDeclaration;

protected
    function    getDeclaration( const aProperty : string ) : TStyleDeclaration;
    function    internalGetText() : string; virtual;

public
    constructor Create();
//    destructor  Destroy(); override;

protected
    property declarations[ aIndex : integer ] : TStyleDeclaration read getDeclarationByIndex;

public //property
    property props[ const aProperty : string ] : string read getProperty write setProperty; default;
    property text : string read getText;

    end;

{-- TAttrDeclaration ----------------------------------------------------------}

    {***************************************************************************
    * TAttrDeclaration
    ***************************************************************************}
    TAttrDeclaration = class
protected
    Fattr                       : string;
    Fvalue                      : string;

private
    function    getText() : string;

public
    constructor Create( const aProperty : string );

public //property
    property text : string read getText;
    property attr : string read Fattr write Fattr;
    property value : string read Fvalue write Fvalue;

    end;

{-- TAttrList -----------------------------------------------------------------}

    {***************************************************************************
    * TAttrList
    ***************************************************************************}
    TAttrList = class( TObjectList )
private
    function    getText() : string;
    function    getAttr( const aAttr : string ) : string;
    procedure   setAttr( const aAttr, aValue : string );
    function    getAttrByIndex( aIndex : integer ) : TAttrDeclaration;

protected
    function    getAttrDeclaration( const aAttr : string ) : TAttrDeclaration;

public
    constructor Create();

    procedure   remove( const aAttr : string );
    function    hasAttr( const aAttr : string ) : boolean;
//    destructor  Destroy(); override;

protected
    property attrsByIndex[ aIndex : integer ] : TAttrDeclaration read getAttrByIndex;

public //property
    property attrs[ const aAttr : string ] : string read getAttr write setAttr; default;
    property text : string read getText;

    end;

EParseLimitMode = ( lmRestOfString, lmTokens );

function  Implode( aList : TStringList; const aDelimiter : string ) : string;
// lmRestOfString - behaves similar to PHP explode - s := 'token0:token1:token2:token3'; Explode( s, 1, lmRestOfString ) -> [ 'token0', 'token1:token2:token3' ]
// lmTokens - s := 'token0:token1:token2:token3'; Explode( s, 1, lmTokens ) -> [ 'token0' ], Explode( s, 2, lmTokens ) -> [ 'token0', 'token1' ]
function  Explode( const aDelimiter, aString : string; aLimit : integer = 0; aLimitMode : EParseLimitMode = lmRestOfString ) : TStringList;

// http://synapse.ararat.cz/doc/help/synautil.html#FetchEx
function  FetchEx( var aString : string; const aDelimiter, aQuotation : string ) : string;
// see Explode
procedure ParseParametersEx( aString, aDelimiter : string; const aParameters : TStrings; aLimit : integer = 0; aLimitMode : EParseLimitMode = lmRestOfString );

function  EscapeDoubleQuote( const aValue : string ) : string;
function  IfThen( aCondition : boolean; const aTrueExpr, aFalseExpr : string ) : string; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : string; aFalseExpr : integer ) : integer; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : integer; aFalseExpr : integer ) : integer; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : integer ) : double; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : double ) : double; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : int64; aFalseExpr : int64 ) : int64; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : boolean; aFalseExpr : boolean ) : boolean; overload;


function  tagOpen( const aTag, aId, aClass, aStyle, aAttrs : string ) : string;
function  tagClose( const aTag : string ) : string;
function  tag( const aTag, aId, aClass, aStyle, aAttrs, aText : string ) : string; overload;
function  tag( const aTag, aId, aClass, aStyle, aText : string ) : string; overload;
function  tag( const aTag, aId, aText : string ) : string; overload;
function  tag( const aTag, aText : string ) : string; overload;

function  nl2br( const aString : string ) : string;
function  nobr( const aText : string ) : string;
function  b( const aText : string ) : string;
function  dv( const aText : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
function  span( const aText : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
function  tr( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
function  td( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;

implementation

{***************************************************************************
* s_style
***************************************************************************}
function s_style( const aCSS : string ) : string;
begin
    Result := IfThen( aCSS <> '', ' style="' + EscapeDoubleQuote( aCSS ) + '"', '' );
end;

{***************************************************************************
* s_class
***************************************************************************}
function s_class( const aClass : string ) : string;
begin
    Result := IfThen( aClass <> '', ' class="' + EscapeDoubleQuote( aClass ) + '"', '' );
end;

{***************************************************************************
* id
***************************************************************************}
function s_id( const aId : string ) : string;
begin
    Result := IfThen( aId <> '', ' id="' + EscapeDoubleQuote( aId ) + '"', '' );
end;

{*******************************************************************************
* tagOpen
*******************************************************************************}
function tagOpen( const aTag, aId, aClass, aStyle, aAttrs : string ) : string;
begin
    Result := '<' + aTag + s_id( aId ) + s_class( aClass ) + s_style( aStyle ) + aAttrs + '>';
end;

{*******************************************************************************
* tagClose
*******************************************************************************}
function tagClose( const aTag : string ) : string;
begin
    Result := '</' + aTag + '>';
end;

{*******************************************************************************
* tag
*******************************************************************************}
function tag( const aTag, aId, aClass, aStyle, aAttrs, aText : string ) : string;
begin
    Result := tagOpen( aTag, aId, aClass, aStyle, aAttrs ) + aText + tagClose( aTag );
end;

{*******************************************************************************
* tag
*******************************************************************************}
function tag( const aTag, aId, aClass, aStyle, aText : string ) : string;
begin
    Result := tag( aTag, aId, aClass, aStyle, '', aText );
end;

{*******************************************************************************
* tag
*******************************************************************************}
function tag( const aTag, aId, aText : string ) : string;
begin
    Result := tag( aTag, aId, '', '', '', aText );
end;

{*******************************************************************************
* tag
*******************************************************************************}
function tag( const aTag, aText : string ) : string;
begin
    Result := tag( aTag, '', '', '', '', aText );
end;

{***************************************************************************
* nobr
***************************************************************************}
function nobr( const aText : string ) : string;
begin
    Result := tag( 'nobr', aText );
end;

{***************************************************************************
* b
***************************************************************************}
function b( const aText : string ) : string;
begin
    Result := tag( 'b', aText );
end;

{***************************************************************************
* dv
***************************************************************************}
function dv( const aText : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
begin
    Result := tag( 'div', aId, aClass, aStyle, aAttrs, aText );
end;

{***************************************************************************
* span
***************************************************************************}
function span( const aText : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
begin
    Result := tag( 'span', aId, aClass, aStyle, aAttrs, aText );
end;

{***************************************************************************
* tr
***************************************************************************}
function tr( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
begin
    Result := tagOpen( 'tr', aId, aClass, aStyle, aAttrs );
    Result := Result + aInnerHTML;
    Result := Result + tagClose( 'tr' );
end;

{***************************************************************************
* td
***************************************************************************}
function td( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
begin
    Result := tagOpen( 'td', aId, aClass, aStyle, aAttrs );
    Result := Result + aInnerHTML;
    Result := Result + tagClose( 'td' );
end;

{*******************************************************************************
* nl2br
*******************************************************************************}
function nl2br( const aString : string ) : string;
var
    //DZ: практика показывает, что для больших строк использование буфера типа этого помогает предотвратить необъяснимые падения по причине ошибок обращения к памяти
    buf : TStringStream;

    {***************************************************************************
    * replace
    ***************************************************************************}
    procedure replace();
    var
        i   : integer;
        flR : boolean;
        flN : boolean;
        ch  : char;

    begin
        flR := false;
        //flN := false;

        Result := '';
        for i := 1 to Length( aString ) do
        begin
            ch := aString[i];
            flN := ( ch = #10 ); // \n = 10 0xA, \r = 13 0xD

            if ( flN and flR ) then
                continue; // \n встретился сразу после \r

            flR := ( not flN ) and ( ch = #13 );
            if ( flR or flN ) then
            begin // встретился \r или одиночный \n
                buf.WriteString( '<br/>' );
                continue;
            end;

            buf.WriteString( aString[i] );
        end;
    end;

begin
    try
        buf := TStringStream.Create( '' );
        replace();
    finally
        Result := buf.DataString;
        FreeAndNil( buf );
    end;
end;


{******************************************************************************
* FetchEx http://synapse.ararat.cz/doc/help/synautil.html#FetchEx
******************************************************************************}
function FetchEx( var aString : string; const aDelimiter, aQuotation : string ) : string;
var
    n : integer;
    b : boolean;

begin
    Result := '';
    b := false;
    n := 1;

    while ( n <= Length( aString ) ) do
    begin
        if ( b ) then
        begin
            b := ( Pos( aQuotation, aString ) <> 1 );

            Result := Result + aString[1];
            Delete( aString, 1, 1 );
        end
        else
        begin
            if Pos( aDelimiter, aString ) = 1 then
            begin
                Delete( aString, 1, Length( aDelimiter ) );
                break;
            end;

            b := ( Pos( aQuotation, aString ) = 1 );
            Result := Result + aString[1];
            Delete( aString, 1, 1 );
        end;
    end;
end;

{******************************************************************************
* ParseParametersEx
******************************************************************************}
procedure ParseParametersEx( aString, aDelimiter : string; const aParameters : TStrings; aLimit : integer = 0; aLimitMode : EParseLimitMode = lmRestOfString );
var
    s : string;
    i : integer;
begin
    i := 0;
    aParameters.Clear();

    while ( aString <> '' ) do
    begin
        s := Trim( FetchEx( aString, aDelimiter, '"' ) );
        aParameters.Add(s);

        inc(i);
        if ( i = aLimit ) then
        begin
            if ( aLimitMode = lmRestOfString ) then
            begin
                aParameters.Add( aString );
            end;

            break;
        end;
    end;
end;

{*******************************************************************************
* Explode
*******************************************************************************}
function Explode( const aDelimiter, aString : string; aLimit : integer = 0; aLimitMode : EParseLimitMode = lmRestOfString ) : TStringList;
begin
    Result := TStringList.Create();
    ParseParametersEx( aString, aDelimiter, Result, aLimit );
end;

{*******************************************************************************
* Implode
*******************************************************************************}
function Implode( aList : TStringList; const aDelimiter : string ) : string;
var
    i : integer;

begin
    assert( aList <> nil );

    Result := '';
    if ( aList.Count < 1 ) then
        exit;

    Result := aList[0];
    for i := 1 to aList.Count - 1 do
    begin
        Result := Result + aDelimiter + aList[i];
    end;
end;

{*******************************************************************************
* EscapeDoubleQuote
*******************************************************************************}
function EscapeDoubleQuote( const aValue : string ) : string;
begin
    Result := StringReplace( aValue, '"', '\"', [ rfReplaceAll ] );
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr, aFalseExpr : string ) : string;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : string; aFalseExpr : integer ) : integer;
begin
    if ( aCondition ) then
        Result := StrToInt( aTrueExpr )
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : integer; aFalseExpr : integer ) : integer;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : integer ) : double;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : double ) : double;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : int64; aFalseExpr : int64 ) : int64;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{*******************************************************************************
* IfThen
*******************************************************************************}
function IfThen( aCondition : boolean; const aTrueExpr : boolean; aFalseExpr : boolean ) : boolean;
begin
    if ( aCondition ) then
        Result := aTrueExpr
    else
        Result := aFalseExpr;
end;

{-- TStyleDeclaration ---------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TStyleDeclaration.Create( const aProperty : string );
begin
    Fproperty := aProperty;
end;

{*******************************************************************************
* getText
*******************************************************************************}
function TStyleDeclaration.getText() : string;
begin
    Result := Fproperty + ':' + Fvalue + ';';
end;

{-- TStyleList ---------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TStyleList.Create();
begin
    inherited Create( true );
end;

{*******************************************************************************
* getText
*******************************************************************************}
function TStyleList.getText() : string;
begin
    Result := internalGetText();
end;

{*******************************************************************************
* getText
*******************************************************************************}
function TStyleList.internalGetText() : string;
var
    i : integer;
begin
    Result := '';
    for i := 0 to Count - 1 do
    begin
        Result := Result + declarations[i].text;
    end;
end;

{*******************************************************************************
* getProperty
*******************************************************************************}
function TStyleList.getProperty( const aProperty : string ) : string;
var
    d : TStyleDeclaration;

begin
    Result := '';
    d := getDeclaration( aProperty );
    if ( d = nil ) then
        exit;

    Result := d.value;
end;

{*******************************************************************************
* setProperty
*******************************************************************************}
procedure TStyleList.setProperty( const aProperty, aValue : string );
var
    d : TStyleDeclaration;

begin
    d := getDeclaration( aProperty );
    if ( d = nil ) then
    begin
        d := TStyleDeclaration.Create( aProperty );
        add( d );
    end;

    d.value := aValue;
end;

{*******************************************************************************
* getDeclarationByIndex
*******************************************************************************}
function TStyleList.getDeclarationByIndex( aIndex : integer ) : TStyleDeclaration;
begin
    Result := TStyleDeclaration( getItem( aIndex ) );
end;

{*******************************************************************************
* getDeclaration
*******************************************************************************}
function TStyleList.getDeclaration( const aProperty : string ) : TStyleDeclaration;
var
    i : integer;
    d : TStyleDeclaration;

begin
    Result := nil;
    for i := 0 to Count - 1 do
    begin
        d := declarations[i];
        if ( d.prop <> aProperty ) then
            continue;

        Result := d;
        break;
    end;
end;

{-- TAttrDeclaration ---------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TAttrDeclaration.Create( const aProperty : string );
begin
    Fattr := aProperty;
end;

{*******************************************************************************
* getText
*******************************************************************************}
function TAttrDeclaration.getText() : string;
begin
    Result := Fattr;
    if ( Fvalue = '' ) then
        exit;

    Result := Result + '="' + EscapeDoubleQuote( Fvalue ) + '"';
end;

{-- TAttrList ---------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TAttrList.Create();
begin
    inherited Create( true );
end;

{*******************************************************************************
* getText
*******************************************************************************}
function TAttrList.getText() : string;
var
    i : integer;
begin
    Result := '';
    for i := 0 to Count - 1 do
    begin
        Result := Result + ' ' + attrsByIndex[i].text;
    end;
end;

{*******************************************************************************
* getAttr
*******************************************************************************}
function TAttrList.getAttr( const aAttr : string ) : string;
var
    d : TAttrDeclaration;

begin
    Result := '';
    d := getAttrDeclaration( aAttr );
    if ( d = nil ) then
        exit;

    Result := d.value;
end;

{*******************************************************************************
* setAttr
*******************************************************************************}
procedure TAttrList.setAttr( const aAttr, aValue : string );
var
    d : TAttrDeclaration;

begin
    d := getAttrDeclaration( aAttr );
    if ( d = nil ) then
    begin
        d := TAttrDeclaration.Create( aAttr );
        add( d );
    end;

    d.value := aValue;
end;

{*******************************************************************************
* getAttrByIndex
*******************************************************************************}
function TAttrList.getAttrByIndex( aIndex : integer ) : TAttrDeclaration;
begin
    Result := TAttrDeclaration( getItem( aIndex ) );
end;

{*******************************************************************************
* getAttr
*******************************************************************************}
function TAttrList.getAttrDeclaration( const aAttr : string ) : TAttrDeclaration;
var
    i : integer;
    d : TAttrDeclaration;

begin
    Result := nil;
    for i := 0 to Count - 1 do
    begin
        d := attrsByIndex[i];
        if ( d.attr <> aAttr ) then
            continue;

        Result := d;
        break;
    end;
end;

{*******************************************************************************
* remove
*******************************************************************************}
procedure TAttrList.remove( const aAttr : string );
var
    d : TAttrDeclaration;

begin
    d := getAttrDeclaration( aAttr );
    if ( d = nil ) then
        exit;

    inherited remove( d );
end;

{*******************************************************************************
* hasAttr
*******************************************************************************}
function TAttrList.hasAttr( const aAttr : string ) : boolean;
begin
    Result := ( getAttrDeclaration( aAttr ) <> nil );
end;

end.
