unit htmlMustache;

// Подробности в unis\Synopse\SynMustache.pdf

interface

uses Classes, SysUtils, Variants
    , toolsString
    , htmlNode
    , SynMustache
    , SynCommons
;

type

{-- TMustacheDoc --------------------------------------------------------------}

    {***************************************************************************
    * TMustacheDocView
    ***************************************************************************}
    TMustacheDocView = class( THTMLDocView )
private
    Fmustache                   : TSynMustache;
    // немного теории тут http://roman.yankovsky.me/?p=740
    Fdata                       : variant;

protected
    procedure   reset();
    function    getHtml() : string; override;

public
    constructor Create( aInitialContent : string = '' ); override;
    destructor  Destroy(); override;

    function    parse() : TSynMustache;

public // property
    property mustache : TSynMustache read Fmustache;
    property data : variant read Fdata write Fdata;
//    property html : string read render;

    end;

{-- TMustacheNode -------------------------------------------------------------}

    {***************************************************************************
    * TMustacheNode
    ***************************************************************************}
    TMustacheNode = class( THTMLTagNode )
public
    procedure   AfterConstruction(); override;
    end;

{-- TMustacheVar --------------------------------------------------------------}

    {***************************************************************************
    * TMustacheVar
    ***************************************************************************}
    TMustacheVar = class( TMustacheNode )
private
    FvarName                    : string;
    FuseHtmlEscape              : boolean;

protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; const aVarName : string; aUseHtmlEscape : boolean = true ); reintroduce;
    end;

{-- TMustacheText -------------------------------------------------------------}

    {***************************************************************************
    * TMustacheText
    ***************************************************************************}
    TMustacheText = class( TMustacheNode )
private
    Ftext                       : string;

protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; const aText : string ); reintroduce;

public // property
    property text : string read Ftext write Ftext;

    end;

{-- TMustacheSection ----------------------------------------------------------}

    {***************************************************************************
    * TMustacheSection
    ***************************************************************************}
    TMustacheSection = class( TMustacheNode )
public
    constructor Create( aDocument : THTMLDocView; const aSectionName : string; aInverted : boolean = false ); reintroduce;
    end;

    TMustacheFirst = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

    TMustacheLast = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

    TMustacheOdd = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

{-- TMustachePartial ----------------------------------------------------------}

    {***************************************************************************
    * TMustachePartial
    ***************************************************************************}
    TMustachePartial = class( TMustacheNode )
private
    Fdefinition                 : boolean;

protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; const aPartialName : string; aDefinition : boolean = false ); reintroduce;
    end;

{-- TMustacheIndex ------------------------------------------------------------}

    {***************************************************************************
    * TMustacheIndex
    ***************************************************************************}
    TMustacheIndex = class( TMustacheNode )
protected
    function    getHtml() : string; override;
    end;

{-- TMustacheDot --------------------------------------------------------------}

    {***************************************************************************
    * TMustacheDot
    ***************************************************************************}
    TMustacheDot = class( TMustacheNode )
protected
    function    getHtml() : string; override;
    end;

{-- TMustacheComment ----------------------------------------------------------}

    {***************************************************************************
    * TMustacheComment
    ***************************************************************************}
    TMustacheComment = class( TMustacheNode )
private
    Ftext                       : string;

protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; const aText : string ); reintroduce;

public // property
    property text : string read Ftext write Ftext;

    end;

implementation

{-- TMustacheNode -------------------------------------------------------------}

{*******************************************************************************
* AfterConstruction
*******************************************************************************}
procedure TMustacheNode.AfterConstruction();
begin
    inherited;

    FopenBrace  := '{{';
    FcloseBrace := '}}';
end;

{-- TMustacheVar --------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustacheVar.Create( aDocument : THTMLDocView; const aVarName : string; aUseHtmlEscape : boolean = true );
begin
    inherited Create( aDocument, '' );

    FvarName := aVarName;
    FuseHtmlEscape := aUseHtmlEscape;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheVar.getHtml() : string;
begin
    Result := FopenBrace + IfThen( FuseHtmlEscape, '', '{' ) + FvarName + FcloseBrace;
end;

{-- TMustacheText -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustacheText.Create( aDocument : THTMLDocView; const aText : string );
begin
    inherited Create( aDocument, '' );

    Ftext := aText;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheText.getHtml() : string;
begin
    Result := FopenBrace + '"' + Ftext + '"' + FcloseBrace;
end;

{-- TMustacheSection ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustacheSection.Create( aDocument : THTMLDocView; const aSectionName : string; aInverted : boolean = false );
begin
    inherited Create( aDocument, '' );

    FopenTag  := IfThen( aInverted, '^', '#' ) + aSectionName;
    FcloseTag := aSectionName;
end;

constructor TMustacheFirst.Create( aDocument : THTMLDocView; aInverted : boolean = false );
begin
    inherited Create( aDocument, '-first', aInverted );
end;

constructor TMustacheLast.Create( aDocument : THTMLDocView; aInverted : boolean = false );
begin
    inherited Create( aDocument, '-last', aInverted );
end;

constructor TMustacheOdd.Create( aDocument : THTMLDocView; aInverted : boolean = false );
begin
    inherited Create( aDocument, '-odd', aInverted );
end;

{-- TMustachePartial ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustachePartial.Create( aDocument : THTMLDocView; const aPartialName : string; aDefinition : boolean = false );
begin
    inherited Create( aDocument, '' );

    Fdefinition := aDefinition;
    FopenTag  := IfThen( aDefinition, '<', '>' ) + aPartialName;
    FcloseTag := aPartialName;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustachePartial.getHtml() : string;
begin
    if ( Fdefinition ) then
        Result := inherited getHtml()
    else
        Result := FopenBrace + Fopentag + FcloseBrace;
end;

{-- TMustacheIndex ------------------------------------------------------------}

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheIndex.getHtml() : string;
begin
    Result := FopenBrace + '-index' + FcloseBrace;
end;

{*******************************************************************************
* TMustacheDot
*******************************************************************************}
function TMustacheDot.getHtml() : string;
begin
    Result := FopenBrace + '.' + FcloseBrace;
end;

{-- TMustacheComment ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustacheComment.Create( aDocument : THTMLDocView; const aText : string );
begin
    inherited Create( aDocument, '' );

    Ftext := aText;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheComment.getHtml() : string;
begin
    Result := FopenBrace + '! ' + Ftext + FcloseBrace;
end;

{-- TMustacheDocView ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustacheDocView.Create( aInitialContent : string = '' );
begin
    inherited Create();

    Fmustache := nil;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor TMustacheDocView.Destroy();
begin
    reset();
    inherited;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure TMustacheDocView.reset();
begin
    if ( Fmustache = nil ) then
        exit;

    TSynMustache.UnParse( Fmustache.Template );
//    FreeAndNil( Fmustache );
end;

{*******************************************************************************
* parse
*******************************************************************************}
function TMustacheDocView.parse() : TSynMustache;
var
    utf8 : RawUTF8;

begin
    reset();

    utf8 := AnyAnsiToUTF8( inherited getHtml );
    Fmustache := TSynMustache.Parse( utf8 );
    Result := Fmustache;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheDocView.getHtml() : string;
begin
    if ( Fmustache = nil ) then
    begin
        parse();
    end;

    Result := Fmustache.render( Fdata );
end;


end.