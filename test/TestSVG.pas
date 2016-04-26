unit TestSVG;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls
    , HtmlCtrl
    , htmlNode
    , HtmlElement
    , HtmlBehaviorH
    , htmlMustache
    , HtmlTypes
    , synCommons
    , htmlUtils
;

{
    Mustache template engine usage example. More info in Synopse\SynMustache.pdf
}

type
    {***************************************************************************
    * TfmMustache
    ***************************************************************************}
    TfmTestSVG = class( TForm )
    panList: TPanel;
    panEast: TPanel;
    templateText: TMemo;
    panDemoHeader: TPanel;
    Panel2: TPanel;
    panDemo: TPanel;
    butRefresh: TButton;
    procedure FormCreate( Sender : TObject );
    procedure FormDestroy(Sender: TObject);
    procedure templateTextChange(Sender: TObject);
    procedure butRefreshClick(Sender: TObject);

private
    FlistCtrl                   : THtmlControl;
    FlistTmpl                   : TMustacheDocView;

    FsvgCtrl                    : THtmlControl;
    FsvgTmpl                    : TMustacheDocView;

    FcurDir                     : string;

protected
    function    getDirectoryListing(  const aDirectory, aFileExt : string; aTmpl : TMustacheDocView ) : string;
    function    getListCtrl() : THtmlControl;
    function    getSVGCtrl() : THtmlControl;

    procedure   listSVGFiles();
    procedure   showSVGFile( const aFileName : string );

    function    onDirDblClick( aSender : HELEMENT;  aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
    function    onFileClick( aSender : HELEMENT;  aParams : PHTMLayoutBehaviorEventParams; aTag : Pointer ) : boolean;
public

    end;

var
  fmTestSVG: TfmTestSVG;

implementation

{$R *.dfm}

{*******************************************************************************
* GetListView
*******************************************************************************}
function GetListView() : TMustacheDocView;
var
    r : TMustacheNode;
    tab : TMustacheNode;
    tmpl : TMustacheNode;

begin
    Result := TMustacheDocView.Create();

    Result.style[ 'body' ] := 'margin: 0px; padding: 0px; background-color: white;';
    Result.style[ 'table' ] := 'background-color: white; margin: 0px; padding: 0px; border: 1px solid black; border-spacing: -1px; width: 100%; height: 100%;';
    Result.style[ 'td' ] := 'white-space: nowrap; padding: 2px; border-left: 1px solid grey;';

    Result.style[ 'tr.data:nth-child(2n+1)' ] := 'background-color: rgba( 200, 200, 200, .1 )';
    Result.style[ 'tr.data:hover' ] := 'background-color:rgba( 200, 255, 200, .3 )';

    tmpl := Result._tag( 'div' );

    tab := tmpl.addTag( 'table' );

    r := tab.addSection( 'files' ).addTag( 'tr' ).setClass( 'data files' );
    r.addTag( 'td' ).addTag( 'a' ).setVarAsAttr( 'href', 'name' ).setClass( 'file' ).addVar( 'name' );
    r.addTag( 'td' ).addVar( 'size' ).addText( 'B' );

    Result.body.addNode( tmpl );
end;

{*******************************************************************************
* GetSVGView
*******************************************************************************}
function GetSVGView() : TMustacheDocView;
var
    script : TMustacheNode;

begin
    Result := TMustacheDocView.Create();

    Result.style[ 'body' ] := 'margin: 0px; padding: 0px; background-color: white;';
    // this is the only critical style definition for SVG
    Result.style[ '.svg' ] := 'behavior: svg; display: inline-block; padding: 0px; margin: 0px; width: 300px; height: 300px; border: 1px solid black';

    // Every svg data need a uniq ID. In our case it's "svgData"
    script := Result._tag( 'script' ).setId( 'svgData' ).setAttr( 'type', 'text/xml' ).addVar( 'svgData', false );
    Result.head.addNode( script );

    // Set class to svg (see above in style section) and specify source of SVG data using CSS selector (ID in our case)
    Result.body.addNode( 'div' ).setClass( 'svg' ).setAttr( 'data', 'script#svgData' );
end;

{*******************************************************************************
* GetFullPathName
*******************************************************************************}
function GetFullPathName( const aFileName : string ) : string;
var
    buf : array[0..4095] of Char;
    fullName : PChar;

begin
    Windows.GetFullPathName( PChar( aFileName ), High( buf ) + 1, buf, fullName );
    Result := buf;
end;

{*******************************************************************************
* getListCtrl
*******************************************************************************}
function TfmTestSVG.getListCtrl() : THtmlControl;
begin
    Result := THtmlControl.Create( self );
    Result.Parent := panList;
    Result.Align  := alClient;
    Result.Visible := true;
end;

{*******************************************************************************
* getSVGCtrl
*******************************************************************************}
function TfmTestSVG.getSVGCtrl() : THtmlControl;
begin
    Result := THtmlControl.Create( self );
    Result.Parent := panDemo;
    Result.Align  := alClient;
    Result.Visible := true;
end;

{*******************************************************************************
* FormCreate
*******************************************************************************}
procedure TfmTestSVG.FormCreate(Sender: TObject);
begin
    FlistCtrl := getListCtrl();
    FlistTmpl := getListView();

    FsvgCtrl := getSVGCtrl();
    FsvgTmpl := GetSVGView();

    templateText.Lines.Text := FlistTmpl.template;    
//    templateText.Lines.Text := FsvgTmpl.template;
//    showSVGFile( 'lion' );

    listSVGFiles();
end;

{*******************************************************************************
* FormDestroy
*******************************************************************************}
procedure TfmTestSVG.FormDestroy(Sender: TObject);
begin
    FreeAndNil( FsvgTmpl );
end;

{*******************************************************************************
* onDirDblClick
*******************************************************************************}
function TfmTestSVG.onDirDblClick( aSender : HELEMENT;  aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
var
    el : THtmlShim;
    dir : string;
begin
    Result := true;

    el := THtmlShim.get( aSender );
    dir := el.attribute[ 'name' ];

    dir := FcurDir + '\' + dir;
    showSVGFile( dir );
end;

{*******************************************************************************
* showSVGFile
*******************************************************************************}
procedure TfmTestSVG.showSVGFile( const aFileName : string );
begin
    FsvgTmpl.data.svgData := ReadFileContent( '.\svg\' + aFileName + '.svg' );
    FsvgCtrl.html := FsvgTmpl.html;

    templateText.Lines.Text := FsvgTmpl.html;

    butRefresh.Enabled := false;
end;

{*******************************************************************************
* listSVGFiles
*******************************************************************************}
procedure TfmTestSVG.listSVGFiles();
begin
    getDirectoryListing( '.\svg', 'svg', FlistTmpl );

    FlistCtrl.html := FlistTmpl.html;
    FlistCtrl.domEvents.onHyperLinkClick[ 'a[class="file"]' ] := onFileClick;
end;

{*******************************************************************************
* onFileClick
*******************************************************************************}
function TfmTestSVG.onFileClick( aSender : HELEMENT;  aParams : PHTMLayoutBehaviorEventParams; aTag : Pointer ) : boolean;
var
    el : THtmlShim;
    fname : string;
begin
    Result := true;

    el := THtmlShim.get( aSender );
    fname := el.attribute[ 'href' ];

    showSVGFile( fname );
end;


{***************************************************************************
* showFilesList
***************************************************************************}
function TfmTestSVG.getDirectoryListing( const aDirectory, aFileExt : string; aTmpl : TMustacheDocView ) : string;
var
    f : variant;
    res : integer;
    ext : string;
    fname : string;
    fileInfo : TSearchRec;

begin
    Result := GetFullPathName( aDirectory );

    aTmpl.data.curDir := Result;
    aTmpl.data.dirs := _Arr([]);  // 'dirs' is name of the section in template
    aTmpl.data.files := _Arr([]); // 'files' is name of the section in template

    res := FindFirst( aDirectory + '\*.' + aFileExt, faAnyFile, fileInfo );
    try
        while ( res = 0 ) do
        begin
            fname := fileInfo.Name;

            if ( ( fname[1] = '.' ) and ( Length( fname ) = 1 ) or ( ( fileInfo.Attr and faVolumeID  ) > 0 ) ) then
            begin
                res := FindNext( fileInfo );
                continue;
            end;

            try
                f := _Json( '{}' );

                if ( ( fileInfo.Attr and faDirectory ) > 0 ) then
                begin
                    f.name := fname;
                    aTmpl.data.dirs.add( f );

                    continue;
                end;

                f.type := 'file';

                if ( fname[1] <> '.' ) then
                begin
                    ext := ExtractFileExt( fname );
                    if ( ext <> '' ) then
                    begin
                        fname := Copy( fname, 1, Length( fname ) - Length( ext ) );
                        ext := Copy( ext, 2, Length( ext ) - 1 );
                    end;
                end;

                f.name := fname;
                f.ext := ext;
                f.size := IntToStr( fileInfo.Size );
                
                aTmpl.data.files.add( f );
            finally
                res := FindNext( fileInfo );
            end;
        end;
    finally
        FindClose( fileInfo );
    end;
end;

{*******************************************************************************
* templateTextChange
*******************************************************************************}
procedure TfmTestSVG.templateTextChange(Sender: TObject);
begin
    butRefresh.Enabled := true;
end;

{*******************************************************************************
* butRefreshClick
*******************************************************************************}
procedure TfmTestSVG.butRefreshClick(Sender: TObject);
begin
    FsvgCtrl.html := templateText.Lines.Text;
    butRefresh.Enabled := false;    
end;

end.
