unit htmlMustache;

// More info in Synopse\SynMustache.pdf

interface

uses Classes, SysUtils, Variants
    , toolsString
    , htmlNode
    , SynMustache
    , SynCommons
;

type

{-- TMustacheDoc --------------------------------------------------------------}

    TMustacheNode = class;
    TMustacheVar = class;
    TMustacheText = class;
    TMustacheSection = class;
    TMustacheFirst = class;
    TMustacheLast = class;
    TMustacheOdd = class;
    TMustachePartialDef = class;
    TMustachePartialRef = class;
    TMustacheIndex = class;
    TMustacheDot = class;
    TMustacheComment = class;

    {***************************************************************************
    * TMustacheDocView
    ***************************************************************************}
    TMustacheDocView = class( THTMLDocView )
private
    Fmustache                   : TSynMustache;
    // немного теории тут http://roman.yankovsky.me/?p=740
    // A bit of theory here http://docwiki.embarcadero.com/Libraries/XE4/en/System.Variants.TInvokeableVariantType
    // Use SynCommons.pas TDocVariantData data type
    // - you can use _Obj() _Arr() and _Json()/_JsonFast() or
    // _JsonFmt()/_JsonFastFmt() functions to create instances of such variants
    Fdata                       : variant;

private
    procedure   setData( aData : variant );

protected
    procedure   reset();
    function    getHtml() : string; override;
    function    getTemplate() : RawUTF8;
    procedure   setTemplate( const aTemplate : RawUTF8 );

public
    constructor Create( aInitialContent : string = '' ); override;
    destructor  Destroy(); override;

    function    parse() : TSynMustache;

    // add a normal node <aTagName> which has extended Mustache API
    // e.g. doc._tag( 'div' ).addVar( 'caption' ).addSection( 'list' ).addVar( 'itemName' );
    function    _tag( const aTagName : string; aInitialContent : string = '' ) : TMustacheNode;
    // add variable {{aVarName}}, if aUseHtmlEscape = false then will be rendered as {{& aVarName}}
    // (see "7.3.2.3.1. Variables" in Synopse\SynMustache.pdf)
    function    _var( const aVarName : string; aUseHtmlEscape : boolean = true ) : TMustacheVar; overload;
    // add text for translation {{"aText}}
    // (see "7.3.2.4.4. Internationalization" in Synopse\SynMustache.pdf)
    function    _translation( const aText : string ) : TMustacheText;
    // Sections render blocks of text one or more times, depending on the value of the key in the current context.
    // Normal section: {{#aSectionName}}...{{/aSectionName}}
    // (see "7.3.2.3.2. Sections" in Synopse\SynMustache.pdf)
    // Inverted sections are usually defined after a standard section, to render some message in case no information will be written in the non-inverted section:
    // Inverted section: {{^aSectionName}}...{{/aSectionName}}
    // (see "7.3.2.3.3. Inverted Sections" in Synopse\SynMustache.pdf)
    function    _section( const aSectionName : string; aInverted : boolean = false ) : TMustacheSection;
    // Defines a block of text (pseudo-section), which will be rendered - or not rendered for inverted {{^-first}} - for the first item when iterating over lists
    // {{#-first}}...{{/-first}}
    function    _first( aInverted : boolean = false ) : TMustacheFirst;
    // Defines a block of text (pseudo-section), which will be rendered - or not rendered for inverted {{^-last}} - for the last item when iterating over lists
    // {{#-last}}...{{/-last}}
    function    _last( aInverted : boolean = false ) : TMustacheLast;
    // Defines a block of text (pseudo-section), which will be rendered - or not rendered for inverted {{^-odd}} - for the odd item number when iterating over lists:
    // it can be very usefull e.g. to display a list with alternating row colors
    // {{#-odd}}...{{/-odd}}
    function    _odd( aInverted : boolean = false ) : TMustacheOdd;
    // Defines an in-lined partial - to be called later via {{>partial}} - within the scope of the current template
    // Partial DEFinition: {{<aPartialName}}...{{/aPartialName}}
    function    _partialDef( const aPartialName : string ) : TMustachePartialDef;
    // Partial REFerence: {{>aPartialName}}
    // (see "7.3.2.3.4. Partials" in Synopse\SynMustache.pdf)
    function    _partialRef( const aPartialName : string ) : TMustachePartialRef;
    // {{-index}} This pseudo-variable returns the current item number when iterating over lists, starting counting at 1
    function    _index() : TMustacheIndex;
    // {{.}} This pseudo-variable refers to the context object itself instead of one of its members. This is particularly useful when iterating over lists.
    // (see page 8 in Synopse\SynMustache.pdf)
    function    _dot() : TMustacheDot;
    // {{! aCommentText}} The comment text will just be ignored.
    function    _comment( const aCommentText : string ) : TMustacheComment;

public // property
    property mustache : TSynMustache read Fmustache;
    property data : variant read Fdata write setData;
    property template : RawUTF8 read getTemplate write setTemplate;
    
//    property html : string read render;

    end;

{-- TMustacheNode -------------------------------------------------------------}

    {***************************************************************************
    * TMustacheNode
    ***************************************************************************}
    TMustacheNode = class( THTMLTagNode )
protected
    FlastAddedNode              : TMustacheNode;

public
    procedure   AfterConstruction(); override;

protected
class function  getNode( aDocument : THTMLDocView; const aTag : string; aInitialText : string = '' ) : TMustacheNode;

public
    function    addTag( const aTag : string; aInitialText : string = '' ) : TMustacheNode;
    function    addVar( const aVarName : string; aUseHtmlEscape : boolean = true ) : TMustacheNode;
    function    addTranslation( const aText : string ) : TMustacheNode;
    function    addSection( const aSectionName : string; aInverted : boolean = false ) : TMustacheSection;
    function    addFirst( aInverted : boolean = false ) : TMustacheFirst;
    function    addLast( aInverted : boolean = false ) : TMustacheLast;
    function    addOdd( aInverted : boolean = false ) : TMustacheOdd;
    function    addPartialDef( const aPartialName : string ) : TMustachePartialDef;
    function    addPartialRef( const aPartialName : string ) : TMustacheNode;
    function    addIndex() : TMustacheNode;
    function    addDot() : TMustacheNode;
    function    addComment( const aCommentText : string ) : TMustacheNode;

    function    setVarAsClass( const aVarName : string ) : TMustacheNode;
    function    addVarAsClass( const aVarName : string ) : TMustacheNode;
    function    setClass( const aClassName : string ) : TMustacheNode;
    function    addClass( const aClassName : string ) : TMustacheNode;
    function    setAttr( const aAttrName, aValue : string ) : TMustacheNode;
    function    setVarAsAttr( const aAttrName, aVarName : string ) : TMustacheNode;
    function    setId( const aId : string ) : TMustacheNode;
    function    setVarAsId( const aVarName : string ) : TMustacheNode;

public // property
    property lastAddedNode : TMustacheNode read FlastAddedNode;

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

{-- TMustacheFirst ------------------------------------------------------------}

    TMustacheFirst = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

{-- TMustacheLast -------------------------------------------------------------}

    TMustacheLast = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

{-- TMustacheOdd -------------------------------------------------------------}

    TMustacheOdd = class( TMustacheSection )
public
    constructor Create( aDocument : THTMLDocView; aInverted : boolean = false ); reintroduce;
    end;

{-- TMustachePartialDef -------------------------------------------------------}

    {***************************************************************************
    * TMustachePartialDef
    ***************************************************************************}
    TMustachePartialDef = class( TMustacheNode )
public
    constructor Create( aDocument : THTMLDocView; const aPartialName : string ); reintroduce;

    end;

{-- TMustachePartialRef -------------------------------------------------------}

    {***************************************************************************
    * TMustachePartialRef
    ***************************************************************************}
    TMustachePartialRef = class( TMustacheNode )
protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; const aPartialName : string ); reintroduce;
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
    constructor Create( aDocument : THTMLDocView; const aCommentText : string ); reintroduce;

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

{***************************************************************************
* getNode
***************************************************************************}
class function TMustacheNode.getNode( aDocument : THTMLDocView; const aTag : string; aInitialText : string = '' ) : TMustacheNode;
begin
    Result := TMustacheNode.Create( aDocument );
    Result.tag := aTag;
    Result.FopenBrace := '<';
    Result.FcloseBrace := '>';
    Result.innerHtml := aInitialText;
end;

{*******************************************************************************
* addTag
*******************************************************************************}
function TMustacheNode.addTag( const aTag : string; aInitialText : string = '' ) : TMustacheNode;
begin
    Result := TMustacheNode.getNode( Fdocument, aTag, aInitialText );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addVar
*******************************************************************************}
function TMustacheNode.addVar( const aVarName : string; aUseHtmlEscape : boolean = true ) : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustacheVar.Create( Fdocument, aVarName, aUseHtmlEscape );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* addTranslation
*******************************************************************************}
function TMustacheNode.addTranslation( const aText : string ) : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustacheText.Create( Fdocument, aText );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* addSection
*******************************************************************************}
function TMustacheNode.addSection( const aSectionName : string; aInverted : boolean = false ) : TMustacheSection;
begin
    Result := TMustacheSection.Create( Fdocument, aSectionName, aInverted );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addFirst
*******************************************************************************}
function TMustacheNode.addFirst( aInverted : boolean = false ) : TMustacheFirst;
begin
    Result := TMustacheFirst.Create( Fdocument, aInverted );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addLast
*******************************************************************************}
function TMustacheNode.addLast( aInverted : boolean = false ) : TMustacheLast;
begin
    Result := TMustacheLast.Create( Fdocument, aInverted );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addOdd
*******************************************************************************}
function TMustacheNode.addOdd( aInverted : boolean = false ) : TMustacheOdd;
begin
    Result := TMustacheOdd.Create( Fdocument, aInverted );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addPartialDef
*******************************************************************************}
function TMustacheNode.addPartialDef( const aPartialName : string ) : TMustachePartialDef;
begin
    Result := TMustachePartialDef.Create( Fdocument, aPartialName );
    addNode( Result );

    FlastAddedNode := Result;
end;

{*******************************************************************************
* addPartialRef
*******************************************************************************}
function TMustacheNode.addPartialRef( const aPartialName : string ) : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustachePartialRef.Create( Fdocument, aPartialName );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* addIndex
*******************************************************************************}
function TMustacheNode.addIndex() : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustacheIndex.Create( Fdocument );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* addDot
*******************************************************************************}
function TMustacheNode.addDot() : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustacheDot.Create( Fdocument );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* addComment
*******************************************************************************}
function TMustacheNode.addComment( const aCommentText : string ) : TMustacheNode;
begin
    Result := self;

    FlastAddedNode := TMustacheComment.Create( Fdocument, aCommentText );
    addNode( FlastAddedNode );
end;

{*******************************************************************************
* setVarAsClass
*******************************************************************************}
function TMustacheNode.setVarAsClass( const aVarName : string ) : TMustacheNode;
begin
    Result := setClass( '{{' + aVarName + '}}' );
end;

{*******************************************************************************
* addVarAsClass
*******************************************************************************}
function TMustacheNode.addVarAsClass( const aVarName : string ) : TMustacheNode;
begin
    Result := addClass( '{{' + aVarName + '}}' );
end;

{*******************************************************************************
* setClass
*******************************************************************************}
function TMustacheNode.setClass( const aClassName : string ) : TMustacheNode;
begin
    Result := self;
    inherited setClass( aClassName );
end;

{*******************************************************************************
* setAttr
*******************************************************************************}
function TMustacheNode.setAttr( const aAttrName, aValue : string ) : TMustacheNode;
begin
    Result := self;
    inherited setAttr( aAttrName, aValue );
end;

{*******************************************************************************
* setVarAsAttr
*******************************************************************************}
function TMustacheNode.setVarAsAttr( const aAttrName, aVarName : string ) : TMustacheNode;
begin
    Result := self;
    inherited setAttr( aAttrName, '{{' + aVarName + '}}' );
end;

{*******************************************************************************
* setId
*******************************************************************************}
function TMustacheNode.setId( const aId : string ) : TMustacheNode;
begin
    Result := self;
    id := aId;
end;

{*******************************************************************************
* setVarAsId
*******************************************************************************}
function TMustacheNode.setVarAsId( const aVarName : string ) : TMustacheNode;
begin
    Result := self;
    id := '{{' + aVarName + '}}';
end;

{*******************************************************************************
* addClass
*******************************************************************************}
function TMustacheNode.addClass( const aClassName : string ) : TMustacheNode;
begin
    Result := self;
    inherited addClass( aClassName );
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
    Result := FopenBrace + IfThen( FuseHtmlEscape, '', '& ' ) + FvarName + FcloseBrace;
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
    Result := FopenBrace + '"' + Ftext + FcloseBrace;
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

{-- TMustachePartialDef -------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustachePartialDef.Create( aDocument : THTMLDocView; const aPartialName : string );
begin
    inherited Create( aDocument, '' );

    FopenTag  := '<' + aPartialName;
    FcloseTag := aPartialName;
end;

{-- TMustachePartialRef -------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMustachePartialRef.Create( aDocument : THTMLDocView; const aPartialName : string );
begin
    inherited Create( aDocument, '' );

    FopenTag  := '>' + aPartialName;
    FcloseTag := aPartialName;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustachePartialRef.getHtml() : string;
begin
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
constructor TMustacheComment.Create( aDocument : THTMLDocView; const aCommentText : string );
begin
    inherited Create( aDocument, '' );

    Ftext := aCommentText;
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
    Fdata := _Json( '{}' );
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
* setData
*******************************************************************************}
procedure TMustacheDocView.setData( aData : variant );
begin
    //Fdata.Clear();
    Fdata := aData;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure TMustacheDocView.reset();
begin
    if ( Fmustache = nil ) then
        exit;

    TSynMustache.UnParse( Fmustache.Template );
end;

{*******************************************************************************
* getTemplate
*******************************************************************************}
function TMustacheDocView.getTemplate() : RawUTF8;
begin
    Result := AnyAnsiToUTF8( inherited getHtml() );
end;

{*******************************************************************************
* setTemplate
*******************************************************************************}
procedure TMustacheDocView.setTemplate( const aTemplate : RawUTF8 );
begin
    innerHtml := aTemplate;
end;

{*******************************************************************************
* parse
*******************************************************************************}
function TMustacheDocView.parse() : TSynMustache;
begin
    reset();

    Fmustache := TSynMustache.Parse( template );
    Result := Fmustache;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function TMustacheDocView.getHtml() : string;
begin
    assert( ( Fdata <> Unassigned ) and ( Fdata <> Null ) );
    if ( Fmustache = nil ) then
    begin
        parse();
    end;

    Result := Fmustache.render( Fdata );
end;

{*******************************************************************************
* _tag
*******************************************************************************}
function TMustacheDocView._tag( const aTagName : string; aInitialContent : string = '' ) : TMustacheNode;
begin
    Result := TMustacheNode.getNode( self, aTagName, aInitialContent );
end;

{*******************************************************************************
* _var
*******************************************************************************}
function TMustacheDocView._var( const aVarName : string; aUseHtmlEscape : boolean = true ) : TMustacheVar;
begin
    Result := TMustacheVar.Create( self, aVarName, aUseHtmlEscape );
end;

{*******************************************************************************
* _translation
*******************************************************************************}
function TMustacheDocView._translation( const aText : string ) : TMustacheText;
begin
    Result := TMustacheText.Create( self, aText );
end;

{*******************************************************************************
* _section
*******************************************************************************}
function TMustacheDocView._section( const aSectionName : string; aInverted : boolean = false ) : TMustacheSection;
begin
    Result := TMustacheSection.Create( self, aSectionName, aInverted );
end;

{*******************************************************************************
* _first
*******************************************************************************}
function TMustacheDocView._first( aInverted : boolean = false ) : TMustacheFirst;
begin
    Result := TMustacheFirst.Create( self, aInverted );
end;

{*******************************************************************************
* _last
*******************************************************************************}
function TMustacheDocView._last( aInverted : boolean = false ) : TMustacheLast;
begin
    Result := TMustacheLast.Create( self, aInverted );
end;

{*******************************************************************************
* _odd
*******************************************************************************}
function TMustacheDocView._odd( aInverted : boolean = false ) : TMustacheOdd;
begin
    Result := TMustacheOdd.Create( self, aInverted );
end;

{*******************************************************************************
* _partialDef
*******************************************************************************}
function TMustacheDocView._partialDef( const aPartialName : string ) : TMustachePartialDef;
begin
    Result := TMustachePartialDef.Create( self, aPartialName );
end;

{*******************************************************************************
* _partialRef
*******************************************************************************}
function TMustacheDocView._partialRef( const aPartialName : string ) : TMustachePartialRef;
begin
    Result := TMustachePartialRef.Create( self, aPartialName );
end;

{*******************************************************************************
* _index
*******************************************************************************}
function TMustacheDocView._index() : TMustacheIndex;
begin
    Result := TMustacheIndex.Create( self );
end;

{*******************************************************************************
* _dot
*******************************************************************************}
function TMustacheDocView._dot() : TMustacheDot;
begin
    Result := TMustacheDot.Create( self );
end;

{*******************************************************************************
* _comment
*******************************************************************************}
function TMustacheDocView._comment( const aCommentText : string ) : TMustacheComment;
begin
    Result := TMustacheComment.Create( self, aCommentText );
end;

end.