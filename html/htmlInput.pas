unit htmlInput;

interface

uses classes, sysutils
    , htmlNode
    , htmlUtils
    , htmlConst
;

type

{-- THTMLLable ----------------------------------------------------------------}

    {***************************************************************************
    * THTMLLableView
    ***************************************************************************}
    THTMLLableView = class( THTMLTagNode)
public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;

public //property

    end;

{-- THTMLInput ----------------------------------------------------------------}

    {***************************************************************************
    * THTMLInput
    ***************************************************************************}
    THTMLInput = class( THTMLTagNode )
private
    Flabel                      : THTMLLableView;

private
    function    getLabel() : THTMLLableView;

protected
    function    getHtml() : string; override;

public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;
    destructor  Destroy(); override;

public // property
    property lable : THTMLLableView read getLabel; // labEl is a keyword in Pascal
    property value : string index HTML_ATTR_VALUE read getAttr write setAttr;

    end;

{-- THTMLEditBoxView ----------------------------------------------------------}

    {***************************************************************************
    * THTMLEditBoxView
    ***************************************************************************}
    THTMLEditBoxView = class( THTMLInput )
protected

public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;

public // property
    property size : integer index HTML_ATTR_SIZE read getIntAttr write setIntAttr;

    end;

{-- THTMLCheckboxView ---------------------------------------------------------}

    {***************************************************************************
    * THTMLCheckboxView
    ***************************************************************************}
    THTMLCheckboxView = class( THTMLInput )
private
    function    getChecked() : boolean;
    procedure   setChecked( aState : boolean );

public
    constructor Create( aDocument : THTMLDocView; aInitialContent : string = '' ); override;

public //property
    property checked : boolean read getChecked write setChecked;

    end;

implementation

{-- THTMLLableView ------------------------------------------------------------}

{***************************************************************************
* Create
***************************************************************************}
constructor THTMLLableView.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'span';
end;

{-- THTMLInput ----------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLInput.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;

    Ftag   := 'input';
    Flabel := nil;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLInput.Destroy();
begin
    FreeAndNil( Flabel );
    inherited;
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function THTMLInput.getHtml() : string;

    procedure addLabel();
    begin
        if ( Flabel = nil ) then
            exit;

        Result := Flabel.html + Result;
    end;

begin
    Result := inherited getHtml();
    addLabel();
end;

{*******************************************************************************
* getLabel
*******************************************************************************}
function THTMLInput.getLabel() : THTMLLableView;
begin
    if ( Flabel = nil ) then
    begin
        Flabel := THTMLLableView.Create( Fdocument );
    end;

    Result := Flabel;
end;

{-- THTMLEditBoxView ----------------------------------------------------------}

{*******************************************************************************
* THTMLEditBoxView
*******************************************************************************}
constructor THTMLEditBoxView.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    attrs[ 'type' ] := 'text';
end;

{-- THTMLCheckboxView ---------------------------------------------------------}

{*******************************************************************************
* THTMLCheckboxView
*******************************************************************************}
constructor THTMLCheckboxView.Create( aDocument : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    attrs[ 'type' ] := 'checkbox';
end;

{*******************************************************************************
* getChecked
*******************************************************************************}
function THTMLCheckboxView.getChecked() : boolean;
begin
    Result := attrs.hasAttr( 'checked' );
end;

{*******************************************************************************
* setChecked
*******************************************************************************}
procedure THTMLCheckboxView.setChecked( aState : boolean );
begin
    if ( aState ) then
        attrs[ 'checked' ] := ''
    else
        attrs.remove( 'checked' );
end;


end.
