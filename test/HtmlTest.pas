unit HtmlTest;

interface

uses classes, sysutils, forms, Controls, types, windows
    , HtmlCtrl
    , HtmlElement
    , HtmlTypes
    , HtmlLayoutDomH
    , HtmlBehaviour
    , HtmlTestEvents0
    , HtmlTestEvents1
    , HtmlTestEvents2
    , HtmlTestEvents3
    , HtmlTestEvents4
    , HtmlTestMove
;

implementation



var
    frm      : TForm;
    html     : THtmlControl;
    s        : string;
    //s1     : string;
    //i        : cardinal;
    head     : string;
    body     : string;
    rect     : TRect;
    pt       : TPoint;
    wnd      : HWND;

    elRoot   : THtmlElement;
    elBody   : THtmlElement;
    elOK     : THtmlElement;
    elText   : THtmlElement;
    elTest   : THtmlElement;
    elTest0  : THtmlElement;
    elTest1  : THtmlElement;
    elTest2  : THtmlElement;
    elBorder : THtmlElement;
    elScroll : THtmlElement;

    elShim   : THtmlShim;
    elTmp    : THtmlElement;

function selectUpdate( aElement : HELEMENT; aParams : POINTER ) : LongBool; stdcall;
var
    e : THtmlElement;
    s : string;

begin
    e := THtmlElement.Create( aElement );
    s := e.innerText + ', ' + IntToStr( e.index );
    e.innerText := s;

    assert( e.innerText = s );
    e.unuse();

    Result := false;
end;


INITIALIZATION
    frm := TForm.Create( nil );
    frm.Width    := 640;
    frm.Height   := 480;
    frm.Visible  := true;
    //frm.Position := poScreenCenter;

//    elTmp := nil;

    html := THtmlControl.Create( frm );
    html.Parent := frm;
    html.Align  := alClient;
    html.Visible := true;

    head := '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
    body := '<div id="ok">OK</div>';
    body := body + '<div id="test">test<p id="test0">test0</p><p id="test1">test1</p><p id="test2">test2</p></div>';
    body := body + '<div id="text">Мама мыла раму<b>Mama mila ramu</b></div>';
    body := body + '<div id="border">Border</div>';
    body := body + '<div id="scroll" style="height:50px;width:100px;border: 1px dotted green;">Scroll me</div>';
    body := body + '<div id="innerMe">Inner me</div>';
    body := body + '<div id="iOuterMe"><i>Outer me</i></div>';
    body := body + '<div id="footer">Footer: <a href="http://foo.com">Visited</a> <a href="http://foo.com">Hover</a> <a href="http://foo.com">Normal</a></div>';
    s := '<html><head id="head">' + head + '</head><body id="body">' + body + '</body></html>';

    html.html := s;

    elRoot := THtmlElement.Create( html.root );
    assert( elRoot.index = 0 );
    assert( elRoot.innerHtml <> '' );
    assert( elRoot.childrenCount = 2 );
    assert( elRoot.tag = 'html' );

    elBody := elRoot.child[1].use();
    assert( elBody <> nil );
    assert( elBody.tag = 'body' );
    assert( elBody.index = 1 );
    assert( elBody.innerHtml <> '' );
    assert( elBody.parent.handler = elRoot.handler );
    assert( elBody.childrenCount = 8 );
    elBody.style[ 'border' ] := '1px dashed green';
    elBody.redraw();
    
    elOK := elBody.child[0].use();
    assert( elOK <> nil );
    assert( elOK.tag = 'div' );
    assert( elOK.index = 0 );
    assert( elOK.innerHtml = 'OK' );
    assert( elOK.parent.handler = elBody.handler );
    assert( elOK.attributeCount = 1 );
    assert( elOK.attributeName[0] = 'id' );
    assert( elOK.attributeByIndex[0] = 'ok' );
    assert( elOK.id = 'ok' );
    elOK.attribute[ 'myAttr' ] := 'myAttrValue';
    assert( elOK.attributeCount = 2 );
    assert( elOK.attribute[ 'myAttr' ] = 'myAttrValue' );
    elOK.attrAsInt[ 'myAttr' ] := 1000;
    assert( elOK.attrExists[ 'myAttr' ] );
    assert( elOK.attrAsInt[ 'myAttr' ] = 1000 );
    elOK.remove_attribute( 'myAttr' );
    assert( not elOK.attrExists[ 'myAttr' ] );
    elOK.style[ 'color' ] := 'red';
    elOK.redraw();

    elTest := elBody.child[1].use();
    assert( elTest <> nil );
    assert( elTest.tag = 'div' );
    assert( elTest.index = 1 );
    assert( elTest.innerHtml <> '' );
    assert( elTest.parent.handler = elBody.handler );
    assert( elTest.attributeCount = 1 );
    assert( elTest.attributeName[0] = 'id' );
    assert( elTest.attributeByIndex[0] = 'test' );
    assert( elTest.id = 'test' );
    elTest.attribute[ 'myAttr' ] := 'myAttrValue';
    assert( elTest.attributeCount = 2 );
    assert( elTest.attribute[ 'myAttr' ] = 'myAttrValue' );
    elTest.attrAsInt[ 'myAttr' ] := 1001;
    assert( elTest.attrAsInt[ 'myAttr' ] = 1001 );
    elTest.remove_attribute( 'myAttr' );
    assert( not elTest.attrExists[ 'myAttr' ] );
    elTest.style[ 'color' ] := 'green';
    elTest.redraw();

    elText := elBody.child[2].use();
    assert( elText <> nil );
    assert( elText.tag = 'div' );
    assert( elText.index = 2 );
    assert( elText.innerHtml = 'Мама мыла раму<b>Mama mila ramu</b>' );
    assert( elText.parent.handler = elBody.handler );
    assert( elText.attributeCount = 1 );
    assert( elText.attributeName[0] = 'id' );
    assert( elText.attributeByIndex[0] = 'text' );
    assert( elText.id = 'text' );
    elText.attribute[ 'myAttr' ] := 'myAttrValue';
    assert( elText.attributeCount = 2 );
    assert( elText.attribute[ 'myAttr' ] = 'myAttrValue' );
    elText.attrAsInt[ 'myAttr' ] := 1002;
    assert( elText.attrAsInt[ 'myAttr' ] = 1002 );
    elText.remove_attribute( 'myAttr' );
    assert( not elText.attrExists[ 'myAttr' ] );
    elText.style[ 'color' ] := 'blue';
    elText.redraw();

    elTest0 := elTest.get_element_by_id( 'test0' ).use();
    assert( elTest0 <> nil );
    assert( elTest0.tag = 'p' );
    assert( elTest0.id = 'test0' );
    
    elRoot.select( selectUpdate, nil, 'p' );

    elTest1 := elTest0.nextSibling;
    assert( elTest1 <> nil );
    assert( elTest1.tag = 'p' );
    elTest1.style[ 'color' ] := 'magenta';
    elTest1.redraw();

    elTest2 := elTest0.lastSibling.use();

    assert( elTest2 <> nil );
    assert( elTest2.tag = 'p' );
    elTest2.style[ 'color' ] := 'navy';
    elTest2.redraw();

    elTest0.unuse();
    elTest0 := elTest2.firstSibling.use();
    assert( elTest0 <> nil );
    assert( elTest0.get_element_type() = 'text' );
    elTest0.style[ 'color' ] := 'cyan';
    elTest0.redraw();

    elTest1.unuse();
    elTest1 := elTest2.prevSibling.use();
    assert( elTest1 <> nil );
    assert( elTest1.tag = 'p' );
    elTest1.style[ 'color' ] := 'brown';
    elTest1.redraw();

    elRoot.unuse();
    elRoot := elTest1.root;
    assert( elRoot <> nil );

    elBorder := elBody.get_element_by_id( 'border' ).use();
    assert( elBorder <> nil );
    assert( elBorder.tag = 'div' );
    assert( elBorder.id = 'border' );
    elBorder.innerText := elBorder.innerText + ', tested';

    rect := elBorder.location;
    elBorder.style[ 'position' ] := 'absolute';
    elBorder.width  := 100;
    assert( elBorder.width = 100 );
    elBorder.height := 30;
    assert( elBorder.height = 30 );
    elBorder.left := rect.left + 30;
    elBorder.top := rect.top - 5;
    elBorder.style[ 'border-width' ] := '1px';
    elBorder.style[ 'border-style' ] := 'solid';
    elBorder.style[ 'border-color' ] := 'red';
    elBorder.style[ 'background-color' ] := 'yellow';
    elBorder.update( REDRAW_NOW );

    pt.x := elBorder.left + 1;
    pt.y := elBorder.top + 1;
    assert( elBorder.is_inside( pt ) );

    pt.x := elBorder.left + elBorder.width + 2;
    assert( not elBorder.is_inside( pt ) );
    //html.LoadFile( 'c:\projects\traffic_build\1.txt' );

    elScroll := elBody.get_element_by_id( 'scroll' ).use();
    assert( elScroll <> nil );
    assert( elScroll.tag = 'div' );
    elScroll.id := 'scroll';
    elScroll.scroll_to_view();
    assert( elScroll.lastError = HLDOM_OK );

    elOK.scroll_to_view();
    assert( elScroll.lastError = HLDOM_OK );

    elScroll.scroll_to_view();
    assert( elScroll.lastError = HLDOM_OK );

    wnd := elScroll.get_element_hwnd( true );
    assert( elScroll.lastError = HLDOM_OK );
    assert( wnd = html.Handle );

    elShim := THtmlShim.get( elRoot.get_element_by_id( 'innerMe' ) );
    assert( elShim <> nil );
    assert( elShim.innerHtml <> '' );
    assert( elShim.id = 'innerMe' );
    elShim.innerHtml := elShim.innerHtml + ' <b>' + elShim.innerHtml + '</b>';

    elShim.nextSibling;
    assert( elShim.is_valid() );
    elShim.set_html( elShim.innerHtml + ' <b>Outer me</b>', SOH_REPLACE );

    frm.Height := 400;

    elShim := THtmlShim.get( elBody.get_element_by_id( 'footer' ) );
    assert( elShim.id = 'footer' );
    elShim := elShim.child[0].child[0];
    assert( elShim <> nil );
    elShim.state[ STATE_VISITED ] := true;
    elShim.nextSibling.state[ STATE_HOVER ] := true;
    assert( elShim.state[ STATE_HOVER ] = true );
    elShim.state[ STATE_FOCUS ] := true;

    elShim := THtmlShim.get( elBody.get_element_by_id( 'footer' ) );
    elShim := elShim.clone();
    elShim.id := 'footerClone';
    elBody.insert( elShim, elShim.index );

    elTmp := elBody.get_element_by_id( 'footerClone' );
    assert( elTmp <> nil );
    elTmp.innerHtml := '... sheep say? Clo-oneed... ' + elTmp.innerHtml;
    elTmp.unuse();

    elTmp := THtmlElement.Create( 'div', 'Hi! I''m appendix' );
    assert( elTmp <> nil );
    assert( elTmp.is_valid() );
    elTmp.id := 'appendix';
    elBody.append( elTmp );
    elTmp.unuse();
    elTmp := elBody.get_element_by_id( 'appendix' );
    assert( elTmp <> nil );


FINALIZATION
    elRoot.unuse();
    elOK.unuse();
    elTest.unuse();
    elTest0.unuse();
    elTest1.unuse();
    elTest2.unuse();
    elText.unuse();
    elBorder.unuse();
    elScroll.unuse();
    //FreeAndNil( elBatch );
    //FreeAndNil( elTmp );

    FreeAndNil( frm );

end.
