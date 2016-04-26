unit MustacheTemplateEngine;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls
    , HtmlCtrl
    , htmlNode
    , HtmlElement
    , HtmlBehaviorH
    , htmlMustache
    , HtmlTypes
    , synCommons
;

{
    Mustache template engine usage example. More info in Synopse\SynMustache.pdf
}

type
    {***************************************************************************
    * TfmMustache
    ***************************************************************************}
    TfmMustache = class( TForm )
    panList: TPanel;
    panEast: TPanel;
    templateText: TMemo;
    panMemoHeader: TPanel;
    Panel2: TPanel;
    htmlText: TMemo;
    procedure FormCreate( Sender : TObject );
    procedure FormDestroy(Sender: TObject);

private
    FhtmlCtrl                   : THtmlControl;
    FdocTmpl                    : TMustacheDocView;
    FcurDir                     : string;

protected
    function    getDirectoryListing(  const aDirectory : string ) : string;
//    procedure   onDocumentComplete( aSender : THtmlControl );
    function    getHtmlControl() : THtmlControl;
    function    onDirDblClick( aSender : HELEMENT;  aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;

public
    procedure   showDirectory( const aDirectory : string );

    end;

var
  fmMustache: TfmMustache;

implementation

{$R *.dfm}

{*******************************************************************************
* GetDocView
*******************************************************************************}
function GetDocView() : TMustacheDocView;
var
    r : TMustacheNode;
    tab : TMustacheNode;
    tmpl : TMustacheNode;
    //files : TMustacheSection;

begin
    Result := TMustacheDocView.Create();

//    Result.style[ 'html' ] := 'overflow: none;';
    Result.style[ 'body' ] := 'margin: 0px; padding: 0px; background-color: white;';
    Result.style[ 'table' ] := 'background-color: white; margin: 0px; padding: 0px; border: 1px solid black; border-spacing: -1px; width: 100%; height: 100%;';
    Result.style[ 'td' ] := 'white-space: nowrap; padding: 2px; border-left: 1px solid grey;';

    Result.style[ '.dirs' ] := 'font-weight: bold; font-size: 13px;';
    Result.style[ '.curDir' ] := 'background-color: blue;color: yellow;padding: 3px;';    
    Result.style[ '.pas' ] := 'color: blue';
    Result.style[ '.dfm' ] := 'color: green';
    Result.style[ '.dll' ] := 'color: grey';
    Result.style[ '.ddp' ] := 'font-size: 9px';
    Result.style[ '.exe' ] := 'font-size: red';
    Result.style[ 'tr.data:nth-child(2n+1)' ] := 'background-color: rgba( 200, 200, 200, .1 )';
    Result.style[ 'tr.data:hover' ] := 'background-color:rgba( 200, 255, 200, .3 )';
    Result.style[ 'tr.header td' ] := 'border-bottom: 1px solid black; font-weight: bold;';
    
    tmpl := Result._tag( 'div' );
    tmpl.addTag( 'div' ).setClass( 'dir curDir' ).addVar( 'curDir' );

    tab := tmpl.addTag( 'table' );

    r := tab.addTag( 'tr' ).setClass( 'header' );
    r.addTag( 'td' ).addTranslation( 'File name' );
    r.addTag( 'td' ).addTranslation( 'Ext' );
    r.addTag( 'td' ).addTranslation( 'Size' );

    r := tab.addSection( 'dirs' ).addTag( 'tr' ).setClass( 'data dirs' ).setVarAsAttr( 'name', 'name' );
    r.addTag( 'td' ).addVar( 'name' ).setAttr( 'colspan', '3' );

    r := tab.addSection( 'files' ).addTag( 'tr' ).setClass( 'data files' );
    r.addTag( 'td' ).addVar( 'name' );
    r.addTag( 'td' ).setVarAsClass( 'ext' ).addVar( 'ext' );
    r.addTag( 'td' ).addVar( 'size' );

    Result.body.addNode( tmpl );
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
* getHtmlControl
*******************************************************************************}
function TfmMustache.getHtmlControl() : THtmlControl;
begin
    Result := THtmlControl.Create( self );
    Result.Parent := panList;
    Result.Align  := alClient;
    Result.Visible := true;


//    Result.domEvents.onMouseClick[ 'tr' ] := onDirDblClick;
end;

{*******************************************************************************
* FormCreate
*******************************************************************************}
procedure TfmMustache.FormCreate(Sender: TObject);
begin
    FhtmlCtrl := getHtmlControl();
    FdocTmpl := GetDocView();

    templateText.Lines.Text := FdocTmpl.template;
    showDirectory( '.' );
end;

{*******************************************************************************
* FormDestroy
*******************************************************************************}
procedure TfmMustache.FormDestroy(Sender: TObject);
begin
    FreeAndNil( FdocTmpl );
end;

{*******************************************************************************
* onDocumentComplete
*******************************************************************************}
{procedure TfmMustache.onDocumentComplete( aSender : THtmlControl );
begin

end;}

{*******************************************************************************
* onDirDblClick
*******************************************************************************}
function TfmMustache.onDirDblClick( aSender : HELEMENT;  aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
var
    el : THtmlShim;
    dir : string;
begin
    Result := true;

    el := THtmlShim.get( aSender );
    dir := el.attribute[ 'name' ];

    dir := FcurDir + '\' + dir;
    showDirectory( dir );
end;

{*******************************************************************************
* showDirectory
*******************************************************************************}
procedure TfmMustache.showDirectory( const aDirectory : string );
begin
    htmlText.Lines.Text := FdocTmpl.html;

    FcurDir := getDirectoryListing( aDirectory );

    FhtmlCtrl.html := FdocTmpl.html;
    FhtmlCtrl.domEvents.onMouseDblClick[ 'tr[class%="dirs"]' ] := onDirDblClick;
end;

{***************************************************************************
* showFilesList
***************************************************************************}
function TfmMustache.getDirectoryListing( const aDirectory : string ) : string;
var
    f : variant;
    res : integer;
    ext : string;
    fname : string;
    fileInfo : TSearchRec;

begin
    Result := GetFullPathName( aDirectory );

    FdocTmpl.data.curDir := Result;
    FdocTmpl.data.dirs := _Arr([]);  // 'dirs' is name of the section in template
    FdocTmpl.data.files := _Arr([]); // 'files' is name of the section in template

    res := FindFirst( aDirectory + '\*.*', faAnyFile, fileInfo );
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
                    FdocTmpl.data.dirs.add( f );

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
                
                FdocTmpl.data.files.add( f );
            finally
                res := FindNext( fileInfo );
            end;
        end;
    finally
        FindClose( fileInfo );
    end;
end;

end.
