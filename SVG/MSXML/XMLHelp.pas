unit XMLHelp;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  MSXML2_TLB_Light;

function HasAttribute(const Node: IXMLDOMNode; const Name: WideString): Boolean;

procedure SetAttribute(const Node: IXMLDOMNode; const Name: WideString;
  const Value: OleVariant);

function GetAttribute(const Node: IXMLDOMNode;
  const Name: WideString): OleVariant;

procedure CopyAttribute(const Source, Dest: IXMLDOMNode;
  const Name: WideString);

procedure RemoveAttribute(const Node: IXMLDOMNode; const Name: WideString);

function CreateXML(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument;

function CreateXML3(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument3;

function CreateXML2(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument2;

function AddChildNode(const Parent: IXMLDOMNode;
  const NodeName: WideString): IXMLDOMNode;

procedure CopyChildren(const SourceParent, DestParent: IXMLDOMNode);

function ExtractAttrValue(const AttrName, AttrLine: WideString): WideString;

function IsValidXML(const S: WideString; const Root: WideString = ''): Boolean;

function CreateFromString(const S: WideString): IXMLDOMDocument;

function CreateFromFile(const FileName: WideString): IXMLDOMDocument;

function IsValidType(const XML: IXMLDOMDocument;
  const Root: WideString): Boolean;

function GetXmlText(const Node: IXMLDOMNode;
  const PreserveWhiteSpace: Boolean): WideString;

function IsMSXML6Installed: Boolean;

implementation

uses
  MSXML2_TLB;

function HasAttribute(const Node: IXMLDOMNode; const Name: WideString): Boolean;
begin
  Result := Assigned(Node.attributes) and
    Assigned(Node.attributes.getNamedItem(Name));
end;

procedure SetAttribute(const Node: IXMlDOMNode; const Name: WideString;
  const Value: OleVariant);
var
  Attribute: IXMLDOMAttribute;
begin
  if not Assigned(Node.attributes) then
    Exit;
    
  if HasAttribute(Node, Name) then
    Node.attributes.getNamedItem(Name).nodeValue := Value
  else
  begin
    Attribute := Node.ownerDocument.createAttribute(Name);
    Attribute.nodeValue := Value;
    Node.attributes.setNamedItem(Attribute);
  end;
end;

function GetAttribute(const Node: IXMLDOMNode;
  const Name: WideString): OleVariant;
begin
  if HasAttribute(Node, Name) then
    Result := Node.attributes.getNamedItem(Name).nodeValue
  else
    Result := varEmpty;
end;

procedure CopyAttribute(const Source, Dest: IXMLDOMNode;
  const Name: WideString);
begin
  if HasAttribute(Source, Name) then
    SetAttribute(Dest, Name, Source.attributes.getNamedItem(Name).nodeValue);
end;

procedure RemoveAttribute(const Node: IXMLDOMNode; const Name: WideString);
begin
  Node.attributes.removeNamedItem(Name);
end;

function CreateXML(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument;
begin
  if IsMSXML6Installed then
    Result := CreateXML3(WithHeader, Root)
  else
    Result := CreateXML2(WithHeader, Root);
end;

function CreateXML3(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument3;
var
  Node: IXMLDOMNode;
begin
  try
    Result := CoDOMDocument60.Create;
    Result.setProperty('NewParser', True);
    Result.setProperty('ProhibitDTD', False);
    Result.validateOnParse := False;
    Result.resolveExternals := False;

    if WithHeader then
    begin
      Node := Result.createProcessingInstruction('xml',
        'version="1.0" encoding="UTF-8"');
      Result.appendChild(Node);
    end;

    if Root <> '' then
    begin
      Node := Result.createElement(Root);
      Result.appendChild(Node);
    end;
  except
    Result := nil;
  end;
end;

function CreateXML2(WithHeader: Boolean;
  const Root: WideString = ''): IXMLDOMDocument2;
var
  Node: IXMLDOMNode;
begin
  try
    Result := CoDOMDocument40.Create;
    Result.setProperty('NewParser', True);
    Result.validateOnParse := False;
    Result.resolveExternals := False;

    if WithHeader then
    begin
      Node := Result.createProcessingInstruction('xml',
        'version="1.0" encoding="UTF-8"');
      Result.appendChild(Node);
    end;

    if Root <> '' then
    begin
      Node := Result.createElement(Root);
      Result.appendChild(Node);
    end;
  except
    Result := nil;
  end;
end;

function AddChildNode(const Parent: IXMLDOMNode;
  const NodeName: WideString): IXMLDOMNode;
var
  XML: IXMLDOMDocument;
begin
  if Assigned(Parent) then
  begin
    XML := Parent.ownerDocument;
    if Assigned(XML) then
    begin
      Result := XML.createElement(NodeName);
      Parent.appendChild(Result);
    end else
      Result := nil;
  end else
    Result := nil;
end;

procedure CopyChildren(const SourceParent, DestParent: IXMLDOMNode);
var
  Node: IXMLDOMNode;
  C: Integer;
begin
  if Assigned(SourceParent) and Assigned(DestParent) then
  begin
    for C := 0 to SourceParent.childNodes.length - 1 do
    begin
      Node := SourceParent.childNodes[C].cloneNode(True);
      DestParent.appendChild(Node);
    end;
  end;
end;

function ExtractAttrValue(const AttrName, AttrLine: WideString): WideString;
var
  LineLen, ItemPos, ItemEnd: Integer;
begin
  ItemPos := Pos(AttrName, AttrLine);
  LineLen := Length(AttrLine);
  if ItemPos > 0 then
  begin
    Inc(ItemPos, Length(AttrName));
    while (ItemPos < LineLen) and
          not ((AttrLine[ItemPos] = '''') or (AttrLine[ItemPos] = '"')) do
      Inc(ItemPos);
    if ItemPos < LineLen then
    begin
      ItemEnd := ItemPos + 1;
      while (ItemEnd < LineLen) and
            not ((AttrLine[ItemEnd] = '''') or (AttrLine[ItemEnd] = '"')) do
        Inc(ItemEnd);
      Result := Copy(AttrLine, ItemPos + 1, ItemEnd - ItemPos - 1);
    end;
  end else
    Result := '';
end;

function IsValidXML(const S: WideString; const Root: WideString = ''): Boolean;
var
  XML: IXMLDOMDocument;
begin
  XML := CreateFromString(S);
  Result := IsValidType(XML, Root);
end;

function CreateFromString(const S: WideString): IXMLDOMDocument;
var
  XML: IXMLDOMDocument;
begin
  XML := CreateXML(True);
  if Assigned(XML) and XML.loadXML(S) then
    Result := XML
  else
    Result := nil;
end;

function CreateFromFile(const FileName: WideString): IXMLDOMDocument;
var
  XML: IXMLDOMDocument;
begin
  XML := CreateXML(False);
  if XML.load(FileName) then
    Result := XML
  else
    Result := nil;
end;

function IsValidType(const XML: IXMLDOMDocument;
  const Root: WideString): Boolean;
begin
  Result := Assigned(XML);
  if Result and (Root <> '') then
    Result := Assigned(XML.documentElement) and
      (XML.documentElement.nodeName = Root);
end;

function IsMSXML6Installed: Boolean;
var
  XML: IXMLDOMDocument3;
begin
  try
    XML := CoDOMDocument60.Create;
    Result := Assigned(XML);
  except
    Result := False;
  end;
end;

function PrepareStr(S: WideString): WideString;
const
  TAB = #9;
var
  C, L, I: Integer;
  SPos, DL: Integer;
  PS, PD: PWideChar;
  D: WideString;
begin
  L := Length(S);
  SetLength(D, L);

  PS := PWideChar(S);
  PD := PWideChar(D);

  SPos := 1;
  DL := 0;

  C := 1;
  while C <= L do
  begin
    if (S[C] = TAB) or (S[C] = ' ' ) or (S[C] = #10) or (S[C] = #13) then
    begin
      I := C - SPos;
      Move(PS^, PD^, I * SizeOf(WideChar));
      Inc(PD, I);
      Inc(DL, I);
      Inc(PS, I);
      if (DL > 0) and (D[DL] <> ' ') then
      begin
        PD^ := ' ';
        Inc(PD);
        Inc(DL);
      end;

      while (S[C] = TAB) or (S[C] = ' ' ) or (S[C] = #10) or (S[C] = #13) do
      begin
        if (S[C] = #13) and (C < L) and (S[C + 1] = #10) then
        begin
          Inc(C);
          Inc(PS);
        end;
        Inc(C);
        Inc(PS);
      end;
      SPos := C;
      Dec(C);
    end;
    Inc(C);
  end;

  I := C - SPos;
  if I > 0 then
  begin
    Move(PS^, PD^, I * SizeOf(WideChar));
    Inc(DL, I);
  end;

  SetLength(D, DL);
  Result := D;
end;

function PrepareStrPreserveWS(S: WideString): WideString;
const
  TAB = #9;
var
  C, L, I: Integer;
  SPos, DL: Integer;
  PS, PD: PWideChar;
  D: WideString;
begin
  L := Length(S);
  SetLength(D, L);

  PS := PWideChar(S);
  PD := PWideChar(D);

  SPos := 1;
  DL := 0;

  C := 1;
  while C <= L do
  begin
    if (S[C] = TAB) or (S[C] = #10) or (S[C] = #13) then
    begin
      I := C - SPos;
      Move(PS^, PD^, I * SizeOf(WideChar));
      Inc(PD, I);
      Inc(DL, I);
      Inc(PS, I);
      PD^ := ' ';
      Inc(PD);
      Inc(DL);

      if (S[C] = #13) and (C < L) and (S[C + 1] = #10) then
      begin
        Inc(C);
        Inc(PS);
      end;
      Inc(PS);
      SPos := C + 1;
    end;
    Inc(C);
  end;

  I := C - SPos;
  if I > 0 then
  begin
    Move(PS^, PD^, I * SizeOf(WideChar));
    Inc(DL, I);
  end;

  SetLength(D, DL);
  Result := D;
end;

function GetXmlText(const Node: IXMLDOMNode;
  const PreserveWhiteSpace: Boolean): WideString;
begin
  if (Node.nodeType <> NODE_TEXT) and (Node.nodeName <> '#text') then
    Result := ''
  else
    if PreserveWhiteSpace then
      Result := PrepareStrPreserveWS(Node.xml)
    else
      Result := PrepareStr(Node.xml);
end;

end.
