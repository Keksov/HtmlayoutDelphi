unit htmlTable;

interface

uses classes, sysutils
    , htmlNode
;

type
    THTMLTableViewTD = class;
    THTMLTableViewTR = class;

    THTMLTableViewTDClass = class of THTMLTableViewTD;
    THTMLTableViewTRClass = class of THTMLTableViewTR;

{-- THTMLTableViewTD ----------------------------------------------------------}

    {***************************************************************************
    * THTMLTableViewTD
    ***************************************************************************}
    THTMLTableViewTD = class( THTMLTagNode )
public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;
    destructor  Destroy(); override;
    
    end;

{-- THTMLTableViewTR ----------------------------------------------------------}

    {***************************************************************************
    * THTMLTableViewTR
    ***************************************************************************}
    THTMLTableViewTR = class( THTMLTagNode )
protected
    FtdClass                    : THTMLTableViewTDClass;

public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' );  override;
    destructor  Destroy(); override;

    procedure   addText( aValues : array of string ); overload; override;
    procedure   addTD( const aText : string; aCls : string = '' );
    
    end;

{-- THTMLTableView ------------------------------------------------------------}

    {***************************************************************************
    * THTMLTableView
    ***************************************************************************}
    THTMLTableView = class( THTMLTagNode )
protected
    FtrClass                    : THTMLTableViewTRClass;

public
    //function    tab( const aInnerHtml : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
//    function    tr( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string; overload;
    procedure   tr( aValues : array of string ); overload;
//    function    td( const aInnerHTML : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;

public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;
//    destructor  Destroy(); override;

public //property
    end;

implementation

{-- THTMLTableViewTD ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLTableViewTD.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    tag := 'td';
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLTableViewTD.Destroy();
begin
    inherited;
end;

{-- THTMLTableViewTR ----------------------------------------------------------}

{*******************************************************************************
* THTMLTableViewTR
*******************************************************************************}
constructor THTMLTableViewTR.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    tag := 'tr';
    FtdClass := THTMLTableViewTD;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLTableViewTR.Destroy();
begin
    inherited;
end;

{*******************************************************************************
* addText
*******************************************************************************}
procedure THTMLTableViewTR.addText( aValues : array of string );
var
   i  : integer;
   td : THTMLTableViewTD;

begin
    td := FtdClass.Create( Fdocument );
    for i := Low( aValues ) to High( aValues ) do
    begin
        td.innerHtml := aValues[i];
        addHtml( td );
    end;
    FreeAndNil( td );
end;

{*******************************************************************************
* addTD
*******************************************************************************}
procedure THTMLTableViewTR.addTD( const aText : string; aCls : string = '' );
var
    td : THTMLTableViewTD;
begin
    td := FtdClass.Create( Fdocument );
    td.innerHtml := aText;
    td.addClass( aCls );
    
    addHtml( td );
    FreeAndNil( td );
end;

{-- THTMLTableView ------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLTableView.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;

    tag := 'table';
    FtrClass := THTMLTableViewTR;
end;

{*******************************************************************************
* tab
*******************************************************************************}
{function THTMLTableView.tab( const aInnerHtml : string; aId : string = ''; aClass : string = ''; aStyle : string = ''; aAttrs : string = '' ) : string;
begin
    Result := td( '<table ' + aAttrs + '>' + aInnerHtml + '</table>' );
end;}

{*******************************************************************************
* tr
*******************************************************************************}
procedure THTMLTableView.tr( aValues : array of string );
var
    tr : THTMLTableViewTR;
//    i : integer;

begin
    tr := FtrClass.Create( Fdocument );
    tr.addText( aValues );
{    for i := Low( aValues ) to High( aValues ) do
    begin
        tr.add( td( aValues[i] ) );
    end;}

    addText( tr.html );
    FreeAndNil( tr );
end;

end.
