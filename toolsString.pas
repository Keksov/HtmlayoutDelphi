unit toolsString;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

{$IFNDEF FPC}
    {$I Compilers.inc}
    {$IFDEF DELPHI_NET}
    {$UNSAFECODE ON}
    {$ENDIF}
{$ENDIF}

uses sysutils, windows, classes, math
    {$IFDEF DELPHI_NET}, System.Text, Variants {$ENDIF};

 const
  INTEGER_CHARS_SET = ['0'..'9'];
  FLOAT_CHARS_SET = ['0'..'9','.','+','-','e','E'];
  HEX_CHARS_SET = ['0'..'9','a'..'f','A'..'F'];
  ASCII_CHARS_SET = ['0'..'9','a'..'z','A'..'Z','_'];
type
{ TStringBuilder Class }
     TStringBuilder = class(TObject)
     private
       FBuffMax,
       FBuffSize,FIndex : integer;
       FBuffer : PChar;
       procedure _ExpandBuffer;
       function GetFString : string;
       procedure SetFString(const AString : string);
     public
       constructor Create(ABufferSize : integer = 4096);
       destructor Destroy; override;
       procedure Append(const AString : string);
       procedure Clear;      
       property AsString : string read GetFString write SetFString;
     end;

    TArrayByte = array of Byte;

    TUniReplaceFlag = ( urfIgnoreCase, urfReplaceAll, urfWholeWordsOnly );
    TUniReplaceFlags = set of TUniReplaceFlag;

function  win2dos( const aText : AnsiString ) : AnsiString;
function  dos2win( const aText : AnsiString ) : AnsiString;

//Replaces all "Search" string values found within "Value" string, with the "Replace" string value.
function  ReplaceString( Value : string; const Search, Replace: string ): string;

// если строка пустая, то возвращает указанное значение; иначе - саму строку
// удобно когда строку нужно подставить в sql-запрос, и она не должна быть пустой
function  EmptyToValue( const aStr, aValue : string ) : string;

{$IFNDEF FPC}
function  AlignText( src : TStringList; width : integer ) : TStringList;
{$ENDIF}

{
function  max( a : integer; b : integer ) : integer;
function  min( a : integer; b : integer ) : integer;
}

// перетянуто из synapse synautil
{:Fetch string from left of Value string. This function ignore delimitesr inside quotations.}
function  FetchEx(var Value: string; const Delimiter, Quotation: string ): string;
{:parse value string with elements differed by Delimiter into stringlist.}
function  ClearQuotation(s: string): string;
procedure ParseParametersEx( aValue, aDelimiter : string; const aParameters : TStrings; flClearQuotation: boolean = false; aLimit : integer = 0 );
// Упрощенная версия ParseParametersEx, программист должен позаботиться об освобождении памяти результата этой функции
function  Explode( const aDelimiter, aValue : string; aLimit : integer = 0 ) : TStringList; overload;
function  Explode( const aDelimiter, aValue : string; aList : TStringList; aLimit : integer = 0 ) : integer; overload;
function  Implode( aList : TStringList; const aDelimiter : string ) : string;

{:parse value string with elements differed by Delimiter into stringlist with AnsiUpperCase.}
procedure ParseParametersExUpper( aValue, aDelimiter : string; const aParameters : TStrings );
{:parse value string with elements differed by ';' into stringlist.}
procedure ParseParameters( aValue: string; const aParameters: TStrings );

procedure ArrayOfStringsToTStrings(const aStrings: array of string; res: TStrings);

function  RPos( aSubstr: string; aStr: string; flCaseSensitive : boolean = true ) : Integer;
function  RPosEx( const Sub, Value : string; From : integer) : Integer;

// работает как Format, только в качестве параметра вместо <array of const> принимает TStringlist
// (динамически создает open array и вызывает функцию format)
function  UniFormat( aFormatStr : string; aParams : TStringList ) : string;
// ищет в указанном тексте подстроку с максимальной длинной, подразумевая, что подстроки разделены разделителем
function  GetTextMaxLine( aText : string; aDelim : string = #13#10 ) : string;
// возвращает сообщение о последней системной ошибке
function  GetLastOSErrorText() : string;
// применяется для выделения составных частей в строках вида <aFirtsPart><aDelim><aSecondPart>
// например dbMain.dbTable -  aFirstPart станет dbMain, а aSecondPart - dbTable
// aDelim - разделитель, который может состоять из нескольких символов
function  SeparateObjectName( aValue : string; var aFirstPart : string; var aSecondPart : string; const aDelim : string = '.' ) : boolean; overload;
// применяетс для выделения составных частей в строках вида <aFirtsPart><aDelim><aSecondPart><aDelim><aThirdPart>
// например dbMain.dbTable.fieldName -  aFirstPart станет dbMain, aSecondPart - dbTable, а aThirdPart - fieldName
// aDelim - разделитель, который может состоять из нескольких символов
function  SeparateObjectName( aValue : string; var aFirstPart : string; var aSecondPart : string;
                                              var aThirdPart : string; var aNumParts : integer; const aDelim : string = '.' ) : boolean; overload;
// приводит строку к т.н. Camel Case- удаляет все не цифры и не буквы, заменяя на заглавные следующие за ними буквы
// работает только для латинского и кирилического алфавитов. Обычно применяется при формировании имен из названий полей
function  CamelCase( aValue : string; flKeepAll : boolean = false ) : string;

procedure SetDecimalSeparator(aDecimalSeparator: char);
procedure RestoreDecimalSeparator();

function  UniStrToFloat( const S : string ) : Extended; overload;
function  UniStrToFloat( const S: string; var aValue : Extended ) : boolean; overload;
function  UnisStrToFloat( const S: string ): Extended;
function  UnisStrToFloatDef(const S: string; ADefault: Extended): Extended;
{$IFNDEF FPC}
function  UniStrToFloat( const S: string; var aValue : double ) : boolean;  overload;
{$ENDIF}

function  UniValFloat(S: string; var Err: Integer): Extended;
function  UniFloatToStr( aValue : Extended ): string;
function  UniFloatToStrF( aValue : Extended; aFormat : TFloatFormat; aPrecision, aDigits : Integer ) : string;
function  UniFormatFloat(const aFormat: string; aValue: Extended): string;
procedure UniFloatFmtStr( var aStrResult : string; const aFormat : string; const aArgs : array of const );
function  UniStrToFloatDef( const S : string; aDefault : Extended ) : Extended;
function  UniStrToFloatDefSilent( const S : string; ADefault : Extended) : Extended;
function FloatToStrPrec(Value: Extended; Prec: integer; flDel_0: boolean = false): string;


{$IFDEF COMPILER_9_UP}
//-- adt баг в компиляторе http://qc.embarcadero.com/wc/qcmain.aspx?d=9411
function  UniStrToUInt64(const S: String): UInt64;
function  UniStrToUInt64Def(S: String; ADefault: UInt64): UInt64;
{$ENDIF}
// поиск и замена слов в строке:
// Source - строка, в которой необходимо заменить слова
// FindStr - строка поиска
// ReplaceStr - строка на которую нужно заменить FindStr
// flUseCase - учитывать регистр
// flAll - заменять все вхождения
// flWholeWordsOnly - заменять только слова
function  UniReplaceStr(Source: string; SearchStr, ReplaceStr: string; ReplaceFlags: TUniReplaceFlags): string;

// замена выражению a := ( < логическое выражение > ? < значение для true > : < значение для false > ); которое есть
// в других языках программирования
function  IfThen( aCondition : boolean; const aTrueExpr, aFalseExpr : string ) : string; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : string; aFalseExpr : integer ) : integer; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : integer; aFalseExpr : integer ) : integer; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : integer ) : double; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : double; aFalseExpr : double ) : double; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : int64; aFalseExpr : int64 ) : int64; overload;
function  IfThen( aCondition : boolean; const aTrueExpr : boolean; aFalseExpr : boolean ) : boolean; overload;

// ставит обратный слеш \ перед символами ", ', \ (см. EscapeString)
function  EscapeString( const str : string ) : string;
// убирает обратный слеш \ перед символами ", ', \ (см. EscapeString)
function  UnescapeString( const str : string ) : string;
{#@abstract Позволяет использовать строки в операторе CASE... удобно!
  @bold(Использование:)
  @longcode(
  case StringToCaseSelect('ДВА',
      ['РАЗ','ДВА','ТРИ']) of
   0:ShowMessage('ЭТО''РАЗ') ;
   1:ShowMessage('ЭТО''ДВА') ;
   2:ShowMessage('ЭТО''ТРИ') ;
end;
}
function StringToCaseSelect (Selector : string; CaseList: array of string): Integer;

{#@abstract декодирует строку семантики Автокад в читабельный формат
}
function DecodeAutoCadSingleByteString(aStr : string) : string;

{#@abstract преобразует произвольнуй строку в строку, которую можно использовать в качестве названия контролов и компонентов
}
function String2Name( const aString : string ) : string;

{#@abstract заменяет все не Ascii символы в строке на _}
function StringToAsciiCharactersString(const S: string): string;
{#@abstract заменяет все нечисловые символы в строке на 0}
function StringIntegerCharactersString(const S: string): string;

//function StringToByteArray(const AValue: String; var VOut: array of byte): Integer;
//function ByteArrayToString(const Value: array of byte): String;

//#@abstract преобразует tvarrec к строке, поддерживает не все. - если нужно - добавляете свое))
function VarRecToStr(VarRec: TVarRec): string;
// Получить подстроку, состоящую из цифр в начале строки
function GetLeftDigits( const aValue : string ) : string;
// Получить подстроку, состоящую из цифр в конце строки
function GetRightDigits( const aValue : string ) : string;

function StrToHexStr(const ASource: string): string;
function HexStrToStr(const ASource: string): string;

// проверить является ли строка числом
function IsInteger(const ABuffer: String): Boolean;
// проверить является ли строка вещественным числом
function IsFloat(const ABuffer: String): Boolean; overload;
function IsFloat(const ABuffer: String; const ADecimalSeparator: Char): Boolean; overload;
// проверить является ли строка шестнадцатеричным числом
function IsHexadecimal(const ABuffer: String): Boolean;
// удалить дубдикаты из строки
function RemoveCharDuplicates(const AChr: Char; const AText: String): string;
{--------------------------------------
implementation
--------------------------------------}
implementation

//uses
//   math;

const
  DecimalSeparatorSavedBound  = 10;

var
  DecimalSeparatorSaved       : array[ 0..DecimalSeparatorSavedBound ] of char;
  DecimalSeparatorSavedCount  : integer;
  LastGoodDecimalSeparator    : char;
  UnisDefaultDecimalSeparator : char;


procedure TStringBuilder._ExpandBuffer;
begin
  FBuffSize := FBuffSize shl 1;
  FBuffMax := FBuffSize - 1;
  ReallocMem(FBuffer,FBuffSize);
end;


constructor TStringBuilder.Create(ABufferSize : integer = 4096);
begin
  inherited Create;

  if ABufferSize <= 0 then
  FBuffSize := 1024
  else
    FBuffSize := ABufferSize;
  GetMem(FBuffer,FBuffSize);
  FBuffMax := FBuffSize - 1;
  FIndex := 0;
end;


destructor TStringBuilder.Destroy;
begin
  FreeMem(FBuffer);

  inherited Destroy;
end;


procedure TStringBuilder.Append(const AString : string);
var iLen : integer;
begin
  iLen := length(AString);
  while iLen + FIndex > FBuffMax do
  _ExpandBuffer;
  move(AString[1],FBuffer[FIndex],iLen);
  inc(FIndex,iLen);
end;


function TStringBuilder.GetFString : string;
begin
  FBuffer[FIndex] := #0;

  Result := FBuffer;
end;


procedure TStringBuilder.SetFString(const AString : string);
begin
  self.Clear;
  self.Append(AString);
end;


procedure TStringBuilder.Clear;
begin
  FIndex := 0;
end;


{******************************************************************************
* win2dos
*******************************************************************************}
{$IFNDEF DELPHI_NET}
function win2dos( const aText : AnsiString ) : AnsiString;
var
    a : TArrayByte;
    l : integer;

begin
    if ( aText = '' ) then
    begin
        Result := '';
        exit;
    end;
    
    l := length( aText );
    SetLength( a, l + 1 );

    CharToOemBuff( PChar(aText), PAnsiChar(a), l );
    SetString( Result, PChar(a), l );

    a := nil;
end;
{$ELSE}
function win2dos( const aText : String ) : String;
var
    l   : integer;
    dst : StringBuilder;
begin
    l   := length(aText);
    dst := StringBuilder.Create( l + 1 );

    CharToOemBuff( aText, dst, l );
    Result := dst.ToString();

    FreeAndNil( dst );
end;
{$ENDIF}

{******************************************************************************
* dos2win
*******************************************************************************}
{$IFNDEF DELPHI_NET}
function dos2win( const aText : AnsiString ) : AnsiString;
var
    s : TArrayByte;
    len : integer;

begin
    len := Length( aText );
    SetLength( s, len + 1 );

    //OemToCharBuff( PAnsiChar(aText), PAnsiChar(a), l );
    {$IFDEF DELPHI_XE_UP}
    OemToCharBuff( PAnsiChar(aText), PWideChar(s), len );
    {$ELSE}
    OemToCharBuff( PChar( aText ), PChar( s ), len );
    {$ENDIF}

    SetString( Result, PChar(s), len );

    s := nil;
end;
{$ELSE}
function dos2win( const aText : string ) : String;
var
    dst : StringBuilder;
    l   : integer;

begin
    l   := Length( aText );
    dst := StringBuilder.Create( l + 1 );

    OemToCharBuff( aText, dst, l );
    Result := dst.ToString();

    FreeAndNil( dst );
end;
{$ENDIF}

{******************************************************************************
* ReplaceString
* Replaces all "Search" string values found within "Value" string, with the "Replace" string value.
*******************************************************************************}
function ReplaceString( Value : string; const Search, Replace : string ) : string;
var
    x, l, ls, lr: integer;
begin
    if ( ( Value = '' ) or ( Search = '' ) ) then
    begin
        Result := Value;
        exit;
    end;
  
    ls := Length( Search );
    lr := Length( Replace );
    x  := Pos( Search, Value );
  
    Result := '';
  
    while x > 0 do
    begin
      {$IFNDEF CIL}
      l := Length( Result );
      SetLength( Result, l + x - 1 );
      if x > 1 then
        Move( Pointer( Value )^, Pointer( @Result[ l + 1 ] )^, x - 1 );
      {$ELSE}
      Result := Result + Copy( Value, 1, x - 1 );
      {$ENDIF}
      {$IFNDEF CIL}
      l := Length( Result );

      if ( lr > 0 ) then
      begin
          SetLength( Result, l + lr );
          Move( Pointer( Replace )^, Pointer( @Result[ l + 1 ] )^, lr );
      end;
      
      {$ELSE}
      Result := Result + Replace;
      {$ENDIF}
      Delete( Value, 1, x - 1 + ls );
      x := Pos( Search, Value );
    end;
  
    Result := Result + Value;
end;

{******************************************************************************
* EmptyToValue
* если строка пустая, то возвращает указанное значение; иначе - саму строку
* удобно когда строку нужно подставить в sql-запрос, и она не должна быть пустой
*******************************************************************************}
function EmptyToValue( const aStr, aValue : string ) : string;
begin
    Result := aStr;

    if ( aStr = '' ) then
    begin
        Result := aValue;
    end;
end;

{**********************************************************************************************
* alignText
***********************************************************************************************}
{$IFNDEF FPC}
function AlignText( src : TStringList; width : integer ) : TStringList;
const
    marker = #1;
    returnCarriageSymbols = ['.', '=', '-'];
    {***************************************************************************
    * strWidth
    ***************************************************************************}
    function strWidth( aStr: string; aTab : string ): integer;
    var
        len : integer;
        i   : integer;

    begin
        Result  := 0;
        if ( aStr = '' ) then
        begin
            exit;
        end;

        len := Length( aStr );

        for i := 1 to len do
        begin
            if ( ( aStr[i] = #9 ) or ( aStr[i] = marker ) ) then
            begin
                inc( Result, 8 );
            end
            else
            begin
                inc( Result );
            end;
        end;           
    end;

    {***************************************************************************
    * getDocTabWidth
    ***************************************************************************}
    function getDocTabWidth(  ): integer;
    var
        i : integer;
        n : integer;
        
    begin
        Result  := 0;
        i       := 0;
        
        while ( i < src.Count - 1 ) do
        begin
            if ( ( src[i] <> '' ) and ( src[i][1] = ' ' ) ) then
            begin
                n := 2;
                while ( ( n < Length( src[i] ) ) and ( src[i][n] = ' ' ) ) do
                begin
                    inc( n );
                end;

                Result := math.max( Result, n - 1 );
            end;
            inc( i );
        end;
    end;

    {***************************************************************************
    * getStrTabWidth
    ***************************************************************************}
    function getStrTabWidth( aStr : string ): integer;
    var
        n : integer;

    begin
        n := 1;
        while ( aStr[n] = ' ' ) do
        begin
            inc( n );
        end;

        Result := n - 1;
    end;

    {***************************************************************************
    * getDocMaxWidth
    ***************************************************************************}
    {
    function getDocMaxWidth( ): integer;
    var
        i : integer;
        n : integer;

    begin
        Result  := 0;

        for i := 0 to src.Count - 1 do
        begin
            n := strWidth( src[i] );
            Result := max( Result, n );
        end;
    end;
    }
var
    paragraphs  : TStringList; //сюда складываются абзацы, потом внутри них производится выравнивание
    word        : TStringList; //сюда складываются слова из текущего абзаца
    i           : integer;
    j           : integer;
    k           : integer;
    n           : integer;
    str         : string;
    tabWidth    : integer;
    tab         : string;
    w           : integer;

    flRedword   : boolean;
    //redword     : string;
    len         : integer;
    firstWord   : integer;
   space       : string;
    spaces      : string;
    spaceNum    : integer;    

begin
    Result := TStringList.Create();
    
    //выясняем, какой ширины должен быть отступ для красных строк.
    //если строка начинается с пробела, то подсчитываем, сколько
    //пробелов в этой красной строке. берем максимальный из отступов.
    //берем минимум от этого числа и 8
    tabWidth    := min( getDocTabWidth(), 8 );
    tab         := '';

    for i := 1 to tabWidth do
    begin
        // формируем красную строку
        tab := tab + ' ';
    end;

    //формируем параграфы                
    paragraphs  := TStringList.Create;
    paragraphs.Clear();         

    i := 0;

    {
    if ( i > src.Count - 1 ) then
    begin
        exit;
    end;
    }

    while ( i <= src.Count - 1 ) do
    begin
        str := TrimRight( src[i] );
        
        if ( strWidth( str, tab ) < width ) then
        //если ширина строки меньше width, считаем ее отдельным параграфом
        begin
            if ( ( str <> '' ) and ( str[1] = ' ' ) ) then
            begin
                n := getStrTabWidth( str );
                if ( n <= tabWidth ) then
                begin
                    str := marker + TrimLeft( str );//по символу marker мы потом узнаем, что тут было начало параграфа
                end
                else
                begin
                    //оставим все, как есть. текущая строка - то что-то вроде
                    //'                         СООБЩЕНИЕ'
                end;
            end;
            
            paragraphs.Append( str );

            inc( i );
            continue;
        end;

        //ширина строки больше width символов, значит, текущий параграф
        //содержит больше одной строки. нужно найти его конец

        //если строка начинается с пробела, то это - красная строка.
        if ( str[1] = ' ' ) then
        begin
            n := getStrTabWidth( str );
            if ( n <= tabWidth ) then
            begin
                str := marker + TrimLeft( str );//по пробелу мы потом узнаем, что тут было начало параграфа
            end
            else
            begin
                //оставим все, как есть. текущая строка - то что-то вроде
                //'                         СООБЩЕНИЕ'
            end;
        end;

        //если текущая строка заканчивается на '-', то это,
        //возможно, перенос. средств выяснить это - нет.
        //поэтому, просто не будем ставить в конце строки пробел 
        if ( str[ Length(str) ] <> '-' ) then
        begin
            str := str + ' ';
        end;
        j := paragraphs.Add( str );

        inc( i );
        if ( i > src.Count - 1 ) then
        begin
            break;
        end;

        while ( ( str <> '' ) and ( str[1] <> ' ' ) )  do
        //while ( i < src.Count - 1 )  do
        begin
            str := TrimRight( src[i] );

            if ( ( str = '' ) or ( str[1] = ' ' ) ) then
            begin
                break;
            end;

            len := Length( str );
            
            if ( str[ len ] <> '-' ) then
            begin
                str := str + ' ';
            end;

            paragraphs[j] := paragraphs[j] + str;

            // если в конце строки есть что-то, свидетельствующее о том,
            // что надо перенести строку, а сама строка "неочень длинная",
            // предполагаем, что это конец параграфа
            if (       ( str[ len ] in returnCarriageSymbols )
                   and ( strWidth( str, tab ) < 4 * trunc( width / 5 ) )
               ) then
            begin
                break;
            end;

            // сдвигаемся на следующую строку
            inc( i );
            if ( i > src.Count - 1 ) then
            begin
                break;
            end;
            str := TrimRight( src[i] );
        end;
    end;
    
    //удаляем из всех параграфов лишние пробелы
    for i := 0 to paragraphs.Count - 1 do
    begin
        str := paragraphs[i];
        if ( str = '' ) then
        begin
            continue;
        end;

        if ( Pos( marker, str ) <= 0 ) then
        begin
            w := width;
        end
        else
        begin
            w := width - tabWidth;
        end;

        if ( strWidth( str, tab ) > w ) then
        begin
            j := 1;     
            if ( str <> '' ) then
            begin                                   //  Ищем места, где несколько пробелов идут подряд
                while ( j < Length( str ) ) do      //  И заменяем их на один пробел
                begin
                    if ( str[j] = ' ' ) then
                    begin
                        while ( str[j + 1] = ' ' ) do
                        begin
                            Delete( str, j + 1, 1 );
                        end;
                    end;
                    Inc( j );
                end;
                paragraphs[i] := str;
            end;
        end;
    end;

    //проставляем красные строки
    {
    for i := 0 to paragraphs.Count - 1 do
    begin
        paragraphs[i] := StringReplace( paragraphs[i], marker, tab, [rfReplaceAll] );
    end;
    }
    word   := TStringList.Create();
    word.Clear();
    
    //вписываем параграфы в строки шириной ровно width символов
    for i := 0 to paragraphs.Count - 1 do
    begin
        if ( strWidth( paragraphs[i], tab ) <= width ) then
        begin
            paragraphs[i] := StringReplace( paragraphs[i], marker, tab, [rfReplaceAll] );
            Result.Append( paragraphs[i] );
            continue;
        end;

        k := 0;
        j := 1;

        // проставляем красную строку, если надо
        flRedword := false;
        if ( Pos( marker, paragraphs[i] ) > 0 ) then
        begin
            k := Length( marker ) + 1;
            j := k + 1;
            flRedword := true;
        end;

        // разбиваем параграфы на слова
        while( j <= Length( paragraphs[i] ) ) do
        begin
            while ( ( j <= Length( paragraphs[i] ) ) and ( paragraphs[i][j] <> ' ' ) ) do
            begin
                inc( j );
            end;

            if ( j - k > width ) then // попалось слово, которое шире предоставленной ширины
            begin
                // разбиваем его на подслова
                // k - начало слова, j - окончание слова
                repeat
                    word.AddObject( Copy( paragraphs[i], k, width ), TObject( width ) );
                    inc( k, width );
                until ( j - k <= width );
            end;

            word.AddObject( Copy( paragraphs[i], k, j - k ), TObject( j - k ) );
            
            k := j + 1;
            inc( j, 2 );              
        end;

        str := '';
        len := 0;
        if ( flRedword ) then
        begin
            str := tab;
            len := tabWidth;
        end;

        k           := 0;//количество пробелов
        firstWord   := 0;
        //redword     := '';
        for j := 0 to word.Count - 1 do
        begin
            if ( len + integer( word.Objects[j] ) > width ) then
            begin
                n := 0;
                if ( k > 1 ) then
                begin
                    dec( k );
                    n           := width - ( len - 1 );//количество пробелов, которые надо разбросать
                    spaceNum    := n div k;//минимум пробелов, который понадобится вставить между словами
                    spaces      := ' ';//между двумя словами уже должно быть по одному пробелу
                    for w := 0 to spaceNum - 1 do
                    begin
                        spaces := spaces + ' ';
                    end;

                    n           := n mod k;//избыток пробелов, которые надо разбросать уже особым образом
                end;

                space := '';
                for w := firstWord to j - 1 do
                begin
                    str   := str + space + word[w];
                    space := spaces;
                    if ( n > 0 ) then
                    begin
                        space := space + ' ';
                        dec( n );
                    end;
                end;

                firstWord   := j;
                //str         := redword + str;
                //redword     := #13#10;
                Result.Append( str );
                str         := '';
                k           := 1;
                len         := integer( word.Objects[j] ) + 1;
            end
            else if ( len + integer( word.Objects[j] ) = width ) then
            begin
                space := '';
                for n := firstWord to j do
                begin
                    str   := str + space + word[n];
                    space := ' ';
                end;

                Result.Append( str );

                if ( j < word.Count - 1 ) then
                begin
                    firstWord   := j + 1;
                    len         := 0;
                end
                else
                begin
                    firstWord   := -1;//так мы узнаем, что последняя строка пуста
                end;
                //str         := redword + str;
                //redword     := #13#10;

                str         := '';
                k           := 0;

            end
            else
            begin
                inc( len, integer( word.Objects[j] ) + 1 );
                inc( k );
            end;
            //str := str + word[j] + ' ';
        end;

        if ( firstWord > 0 ) then
        begin
            space := '';
            for n := firstWord to word.Count - 1 do
            begin
                str   := str + space + word[n];
                space := ' ';
            end;

            if ( length(str) > width ) then
            begin
                if ( length(str) > width ) then;
            end;

            Result.Append( str );
        end;

        word.Clear();



    end;

    {
   I:=1;
   repeat
    J:=I+1;
    while (J<=Length(Text)) and (Text[J]<>' ') do                       //  Идём до первого пробела или до конца текста
     Inc(J);
    if PBox.Canvas.TextWidth(Copy(Text,I,J-I))<=PBox.Width then         //  Добавляем слово к имеющейся строке
     S:=Copy(Text,I,J-I)                                                //  Если ширина строки не превышает ширину
    else                                                                //  PBox'а - добавляем слово.
     begin
      S:=GetWordPart(Copy(Text,I,J-I),PBox.Width,False,K);              //  А если превышает - пытаемся разбить
      Inc(J,K)                                                          //  слово на части переносами
     end;
    I:=J+1;
    while I<=Length(Text) do                                            //  А теперь то же самое для остальных слов
     begin
      J:=I+1;
      while (J<=Length(Text)) and (Text[J]<>' ') do
       Inc(J);
      if PBox.Canvas.TextWidth(S+' '+Copy(Text,I,J-I))<PBox.Width then
       S:=S+' '+Copy(Text,I,J-I)
      else
       begin
        S:=S+GetWordPart(Copy(Text,I,J-I),PBox.Width-PBox.Canvas.TextWidth(S),True,K);
        I:=I+K;                                                         //  Если слово не помещается целиком, разбиваем
        Break                                                           //  его на части и снова
       end;
      I:=J+1
     end;
    List.Add(S)                                                         //  Добавляем строку
   until I>Length(Text)                                                 //  Если текст не кончился, переходим к
                                                                        //  формированию следующей строки.
    }

    {
    Result := TStringList.Create();
    Result.Assign( paragraphs );
    }
    paragraphs.Free();
    word.Free();
end;
{$ENDIF}

(*
{**********************************************************************************************
* max
***********************************************************************************************}
function max( a : integer; b : integer ) : integer;
begin
    if ( a > b ) then
    begin
        Result := a;
    end
    else
    begin
        Result := b;
    end;
end;

{**********************************************************************************************
* min
***********************************************************************************************}
function min( a : integer; b : integer ) : integer;
begin
    if ( a < b ) then
    begin
        Result := a;
    end else
    begin
        Result := b;
    end;
end;
*)
{******************************************************************************
* FetchEx
******************************************************************************}
function FetchEx( var Value : string; const Delimiter, Quotation: string ) : string;
var
    n : integer;
    b : boolean;
begin
    Result := '';
    b := False;
    n := 1;

    while ( n <= Length( Value ) ) do
    begin
        if ( b ) then
        begin
            if Pos( Quotation, Value ) = 1 then
                b := False;

             Result := Result + Value[1];
             Delete(Value, 1, 1);
        end else
        begin
             if Pos(Delimiter, Value) = 1 then
             begin
                Delete( Value, 1, Length(delimiter) );
                break;
             end;
             b := Pos(Quotation, Value) = 1;
             Result := Result + Value[1];
             Delete(Value, 1, 1);
        end;
    end;
end;

{******************************************************************************
* ParseParametersEx
******************************************************************************}
procedure ParseParametersEx( aValue, aDelimiter : string; const aParameters : TStrings; flClearQuotation : boolean = false; aLimit : integer = 0 );
var
    s : string;
    i : integer;
begin
    i := 0;
    aParameters.Clear();
    while ( aValue <> '' ) do
    begin
        s := Trim( FetchEx( aValue, aDelimiter, '"' ) );
        if flClearQuotation then
        begin
            s := ClearQuotation(s);
        end;

        aParameters.Add(s);

        inc(i);
        if ( i = aLimit ) then
            break;
    end;
end;

{*******************************************************************************
* Explode
*******************************************************************************}
function Explode( const aDelimiter, aValue : string; aLimit : integer = 0 ) : TStringList;
begin
    Result := TStringList.Create();
    ParseParametersEx( aValue, aDelimiter, Result, false, aLimit );
end;

{*******************************************************************************
* Explode
*******************************************************************************}
function Explode( const aDelimiter, aValue : string; aList : TStringList; aLimit : integer = 0 ) : integer;
begin
    assert( aList <> nil );
    ParseParametersEx( aValue, aDelimiter, aList, false, aLimit );
    Result := aList.Count;
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

{******************************************************************************
* ParseParametersEx
******************************************************************************}
function ClearQuotation(s: string): string;
begin
  if s <> '' then
  begin
    if s[1]='"' then
      delete(s,1,1);
    if s[Length(s)]='"' then
      delete(s,Length(s),1);
  end;
  Result:=s;
end;


{******************************************************************************
* ParseParametersExUpper
******************************************************************************}
procedure ParseParametersExUpper( aValue, aDelimiter : string; const aParameters : TStrings );
var
    s: string;
begin
    aParameters.Clear();
    while aValue <> '' do
    begin
        s := AnsiUpperCase(Trim( FetchEx( aValue, aDelimiter, '"' ) ) );
        aParameters.Add(s);
    end;
end;

{******************************************************************************
* ParseParameters
******************************************************************************}
procedure ParseParameters( aValue : string; const aParameters: TStrings );
begin
    ParseParametersEx( aValue, ';', aParameters );
end;

{**********************************************************************************************
* ArrayOfStringsToTStrings
***********************************************************************************************}
procedure ArrayOfStringsToTStrings(const aStrings: array of string; res: TStrings);
var
  i: Integer;
begin
  res.Clear();

  for i := low(aStrings) to high(aStrings) do
    res.Add(aStrings[i]);
end;


{**********************************************************************************************
* RPos
***********************************************************************************************}
function RPos( aSubstr: string; aStr: string; flCaseSensitive : boolean  = true ): Integer;
begin
    if ( flCaseSensitive ) then
    begin
        Result := rPosEx( aSubstr, aStr, Length(aStr) );
    end else
    begin
        Result := rPosEx( LowerCase( aSubstr ), LowerCase( aStr ), Length(aStr) );
    end;
end;

{******************************************************************************
* RPosEx
******************************************************************************}
function RPosEx( const Sub, Value : string; From : integer ) : Integer;
var
  n: Integer;
  l: Integer;
begin
  result := 0;
  l := Length(Sub);
  for n := From - l + 1 downto 1 do
  begin
    if Copy(Value, n, l) = Sub then
    begin
      result := n;
      break;
    end;
  end;
end;

{*******************************************************************************
* uniFormat
* работает как Format, только в качестве параметра вместо <array of const> принимает TStringlist
* (динамически создает open array и вызывает функцию format)
*******************************************************************************}
function UniFormat( aFormatStr : string; aParams : TStringList ) : string;
var
{$IFNDEF DELPHI_NET}
    params : array of TVarRec;
{$ELSE}
    params : array of System.Object;
{$ENDIF}
    i      : integer;
begin
    assert( aParams <> nil );

    SetLength( params, aParams.Count );
    for i := 0 to aParams.Count - 1 do
    begin
        {$IFNDEF DELPHI_NET}
        params[i].VType  := vtAnsiString;
        params[i].VPChar := @(aParams.Strings[i])[1];
        {$ELSE}
        params[i] := aParams.Strings[i];
        {$ENDIF}
    end;

    Result := Format( aFormatStr, params );
end;

{*******************************************************************************
* getTextMaxLine
*******************************************************************************}
function GetTextMaxLine( aText : string; aDelim : string = #13#10 ) : string;
var
    lnStart  : integer;
    maxStart : integer;
    maxEnd   : integer;
    maxLen   : integer;
    l        : integer;
    i        : integer;
    lenDelim : integer;
    lenText  : integer;

    function isDelimiter() : boolean;
    var
        j  : integer;
        jj : integer;
        n  : integer;
    begin
        Result := false;

        n := i - 1;

        for j := 1 to lenDelim do
        begin
            jj := n + j;
            if ( jj > lenText ) then
            begin
                break;
            end;

            if ( aText[jj] <> aDelim[j] ) then
            begin
                exit;
            end;
        end;
        Result := true;
    end;

begin
    Result := '';

    if ( aText = '' ) then
    begin
        exit;
    end;

    lenDelim := Length( aDelim );
    lenText  := Length( aText );
    lnStart  := 1;

    maxLen   := 0;
    maxStart := 0;
    maxEnd   := 0;
    
    i := 1;
    while ( i <= lenText ) do
    begin
        if ( not isDelimiter() ) then
        begin
            inc(i);
            continue;
        end;

        l := i - lnStart;
        if ( l > maxLen ) then
        begin
            maxLen   := l;
            maxStart := lnStart;
            maxEnd   := i;
        end;

        lnStart := i + lenDelim;
        inc( i, lenDelim );
    end;

    if ( ( lnStart < lenText + 1 ) and ( ( lenText - lnStart + 1 ) > maxLen ) ) then
    begin
        maxStart := lnStart;
        maxEnd   := lenText + 1;
    end;

    Result := Copy( aText, maxStart, maxEnd - maxStart );

    {if ( maxLen > 0 ) then
    begin
        Result := Copy( aText, maxStart, maxEnd - maxStart );
    end
    else
    begin
        Result := aText;
    end;}
end;

{*******************************************************************************
* GetLastErrorText
*******************************************************************************}
{$IFNDEF DELPHI_NET}
function GetLastOSErrorText() : string;
var
    dwSize   : DWORD;
    lpszTemp : PAnsiChar;

begin
    dwSize   := 512;
    lpszTemp := nil;
    try
        GetMem( lpszTemp, dwSize );
        FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ARGUMENT_ARRAY
                       , nil
                       , GetLastError()
                       , LANG_NEUTRAL
                       , lpszTemp
                       , dwSize
                       , nil
                      );
    finally
        Result := Trim( lpszTemp );
        FreeMem( lpszTemp )
    end;
end;
{$ELSE}
function GetLastOSErrorText() : string;
var
    dwSize   : DWORD;
    lpszTemp : StringBuilder;
begin
    dwSize   := 512;
    lpszTemp := StringBuilder.Create( dwSize );
    try
        FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ARGUMENT_ARRAY
                       , nil
                       , GetLastError()
                       , LANG_NEUTRAL
                       , lpszTemp
                       , dwSize
                       , nil
                      );
    finally
        Result := Trim( lpszTemp.ToString() );
    end;
end;
{$ENDIF}

{*******************************************************************************
* SeparateObjectName
*******************************************************************************}
function SeparateObjectName( aValue : string; var aFirstPart : string; var aSecondPart : string; const aDelim : string = '.' ) : boolean;
var
    i : integer;
    s : Pchar;
begin
    //aFirstPart  := '';
    aSecondPart := '';

    i := Pos( aDelim, aValue );
    Result := ( i <> 0 );
    if ( not Result ) then
    begin
        aSecondPart := aValue;
        exit;
    end;

    aValue[i]   := #0;
    s := @aValue[1];
    aFirstPart  := s;

    s := @aValue[ i + Length( aDelim ) ];
    aSecondPart := s;

    Result := ( aSecondPart <> '' );
end;

{*******************************************************************************
* SeparateObjectName
*******************************************************************************}
function SeparateObjectName( aValue : string; var aFirstPart : string; var aSecondPart : string;
                                              var aThirdPart : string; var aNumParts : integer; const aDelim : string = '.' ) : boolean; overload;
var
    i      : integer;
    s      : Pchar;
    first  : string;
    second : string;

begin
    aNumParts := 0;

    i := Pos( aDelim, aValue );
    Result := ( i <> 0 );
    if ( not Result ) then
    begin // вообще нет точек
        aThirdPart := aValue;
        exit;
    end;

    aValue[i] := #0;
    s := @aValue[1];
    first := s;

    s := @aValue[ i + Length( aDelim ) ];
    second := s;

    Result := ( second <> '' );
    if ( not Result ) then
    begin // строка имела вид aValue. (точка на конце)
        aSecondPart := first;
        exit;
    end;

    aNumParts := 2;
    i := Pos( aDelim, second );
    if ( i = 0 ) then
    begin // была только одна точка
        aSecondPart := first;
        aThirdPart  := second;
        exit;
    end;

    aNumParts := 3;
    // в строке две точки
    aFirstPart := first;

    second[i] := #0;
    s := @second[1];
    aSecondPart := s;

    s := @second[ i + Length( aDelim ) ];
    aThirdPart := s;

    Result := ( aThirdPart <> '' );
end;

{*******************************************************************************
* CamelCase
*******************************************************************************}
function CamelCase( aValue : string; flKeepAll : boolean  = false ) : string;
var
    i       : integer;
    flFirst : boolean;
    ch      : char;

begin
     aValue  := AnsiLowerCase( aValue );
     flFirst := true;
     Result  := '';

     for i := 1 to Length( aValue ) do
     begin
         ch := aValue[i];
         if ( not ( ch in [ 'a'..'z', 'а'..'я', '0'..'9' ] ) ) then
         begin
             if ( flKeepAll ) then
             begin
                 Result := Result + ch;
             end;
                 
             flFirst := true;
             continue;
         end;

         if ( flFirst ) then
         begin
             ch := AnsiUpperCase( ch )[1];
             flFirst := false;
         end;

         Result := Result + ch;
     end;
end;

{*******************************************************************************
* SetDecimalSeparator
*******************************************************************************}
procedure SetDecimalSeparator(aDecimalSeparator: char);
begin
  if ( DecimalSeparatorSavedCount < DecimalSeparatorSavedBound ) then
  begin
      DecimalSeparatorSaved[DecimalSeparatorSavedCount] := DecimalSeparator;
  end;

  inc( DecimalSeparatorSavedCount );
  DecimalSeparator         := aDecimalSeparator;
  LastGoodDecimalSeparator := aDecimalSeparator;
end;

{*******************************************************************************
* RestoreDecimalSeparator
*******************************************************************************}
procedure RestoreDecimalSeparator();
begin
  dec(DecimalSeparatorSavedCount);
  if ( DecimalSeparatorSavedCount >= 0 ) and ( DecimalSeparatorSavedCount <= DecimalSeparatorSavedBound ) then
  begin
    DecimalSeparator := DecimalSeparatorSaved[DecimalSeparatorSavedCount];
  end;

  LastGoodDecimalSeparator := DecimalSeparator;
end;
{*******************************************************************************
* ValFloat
*******************************************************************************}
function UniValFloat(S: string; var Err: Integer): Extended;
var
  I: integer;
  Res: Extended;
begin
  for I:= 1 to Length(s) do
    if S[i]=',' then S[i]:='.';

  Val(S,Res,Err);

  Result:=Res;
end;
{*******************************************************************************
* UniStrToFloat
*******************************************************************************}
function UniStrToFloat(const S: string; var aValue : Extended ) : boolean;
begin
  Result:= False;
  try
      aValue := UniStrToFloat(S);
      Result := true;
  except
  end;
end;

{*******************************************************************************
* UniStrToFloatDef
*******************************************************************************}
function UniStrToFloatDef( const S : string; aDefault : Extended ) : Extended;
begin
    if ( not UniStrToFloat( S, Result ) ) then
    begin
        Result := aDefault;
    end;
end;

{*******************************************************************************
* UniStrToFloatDefSilent
*******************************************************************************}
function UniStrToFloatDefSilent( const S : string; ADefault : Extended) : Extended;
var
  ConvertResult: Integer;
begin
  Result:= UniValFloat(S,ConvertResult);

  if ConvertResult <> 0 then
    Result:= aDefault;
end;
{*******************************************************************************
* UniStrToFloat
*******************************************************************************}
{$IFNDEF FPC}
function UniStrToFloat(const S: string; var aValue : double ) : boolean;
begin
    Result := false;
    try
        aValue := UniStrToFloat(S);
        Result := true;
    except
    end;
end;
{$ENDIF}

{*******************************************************************************
* StringToFloat
*******************************************************************************}
function UniStrToFloat(const S: string): Extended;
var
    decimalSeparatorBak : char;
begin
    decimalSeparatorBak := DecimalSeparator;
    try
         if Pos(',', S) = 0 then
            DecimalSeparator := '.'
         else
            DecimalSeparator := ',';

         LastGoodDecimalSeparator := DecimalSeparator;

         Result := StrToFloat(S);
    finally
         DecimalSeparator := decimalSeparatorBak;
    end;
end;

{**********************************************************************************************
* StringToFloat
***********************************************************************************************}
function UnisStrToFloat(const S: string): Extended;
var
  SaveDecimalSep: AnsiChar;
begin
  try
    SaveDecimalSep := DecimalSeparator;
    try
      DecimalSeparator := '.';
      Result := StrToFloat(S);
    finally
      DecimalSeparator := SaveDecimalSep;
    end;
  except
    if DecimalSeparator = '.' then
      raise;

    Result := StrToFloat(S); // try using native format
  end;
end;

{**********************************************************************************************
* StringToFloatDef
***********************************************************************************************}
function UnisStrToFloatDef(const S: string; ADefault: Extended): Extended;
begin
  try
    Result := UnisStrToFloat(S);
  except
    Result := ADefault;
  end;
end;

{*******************************************************************************
* FloatToString
*******************************************************************************}
function UniFloatToStr( aValue : Extended ): string;
var
  decimalSeparatorBak : char;
begin
  decimalSeparatorBak := DecimalSeparator;
  DecimalSeparator    := UnisDefaultDecimalSeparator;
  Result              := FloatToStr( aValue );
  DecimalSeparator    := decimalSeparatorBak;
end;

{*******************************************************************************
* UniFloatToStrF
*******************************************************************************}
function UniFloatToStrF( aValue : Extended; aFormat : TFloatFormat; aPrecision, aDigits : Integer): string;
var
    decimalSeparatorBak : char;
begin
  decimalSeparatorBak := DecimalSeparator;
  DecimalSeparator    := UnisDefaultDecimalSeparator;
  // по умолчанию Дельфи округляет вещественные числа по мудренным законам (как RoundTo так и SimpleRoundTo - см Help),
  // из-за этого числа с цифрой 5 конце округляются то в большую, то в меньшую сторону
  // чтобы округление было всегда в большую сторону насильно вставили добавление 0.000...01
  Result              := FloatToStrF( aValue + Power(10, -aDigits-1), aFormat, aPrecision, aDigits);
  DecimalSeparator    := decimalSeparatorBak;
end;

{**********************************************************************************************
* UniFormatFloat
***********************************************************************************************}
function UniFormatFloat(const aFormat: string; aValue: Extended): string;
var
  decimalSeparatorBak : char;
begin
  decimalSeparatorBak := DecimalSeparator;
  DecimalSeparator    := UnisDefaultDecimalSeparator;
  Result              := FormatFloat(aFormat, aValue);
  DecimalSeparator    := decimalSeparatorBak;
end;

{**********************************************************************************************
* FloatToStrPrec
***********************************************************************************************}
function FloatToStrPrec(Value: Extended; Prec: integer; flDel_0: boolean = false): string;
var
  len: integer;
  ch: char;
begin
  DecimalSeparator := '.';

  UniFloatFmtStr(Result, '%.' + IntToStr(Prec) + 'f', [Value]);

  if flDel_0 then
  begin
    if Pos('.', Result) > 0 then
    begin
      while true do
      begin
        len := Length(Result);

        if len = 0 then
          break;

        ch := Result[len];

        if (ch <> '0') and (ch <> '.') then
          break;

        delete(Result, len, 1);

        if ch = '.' then
          break;
      end;
    end;
  end;
end;


{*******************************************************************************
* UniFloatFmtStr
*******************************************************************************}
procedure UniFloatFmtStr( var aStrResult: string; const aFormat: string; const aArgs: array of const );
var
  decimalSeparatorBak : char;
begin
  decimalSeparatorBak := DecimalSeparator;
  DecimalSeparator    := UnisDefaultDecimalSeparator;
  FmtStr( aStrResult, aFormat, aArgs );
  DecimalSeparator    := decimalSeparatorBak;
end;

{$IFDEF COMPILER_9_UP}
{*******************************************************************************
* UniStrToUInt64
*******************************************************************************}
function UniStrToUInt64(const S: String): UInt64;
begin
  Result := UniStrToUInt64Def(S,UInt64(0));
end;
{*******************************************************************************
* UniStrToUInt64Def
*******************************************************************************}
function UniStrToUInt64Def(S: String; ADefault: UInt64): UInt64;
var
  C: Cardinal;
  P: PChar;
begin

  Result:= ADefault;
  P := Pointer(S);

  if P=nil then
    Exit;

  if Ord(P^) in [1..32] then
  repeat
    Inc(P)
  until ( not (Ord(P^) in [1..32]) );

  C := ord(P^)-48;
  if C > 9 then
    Exit
  else
  begin
    Result := C;
    Inc(P);
    repeat
      C := Ord(P^) -48;
      if C > 9 then
        break
      else
      Result := Result * 10 +C;
      Inc(P);
    until False;
  end;
end;
{$ENDIF}
{--------------------------------------------------------
  Замена слов в строке ...
--------------------------------------------------------}
function UniReplaceStr(Source: string; SearchStr, ReplaceStr: string;
  ReplaceFlags: TUniReplaceFlags): string;
var
  i,j,str_length,substr_length: integer;
  flRepeat,flFound: boolean;
  flCan: boolean;
  str: string;
const
  Separators = [',','.',';',':',' ','=','+','-','(',')','?','!','<','>','[',']',
    '{','}','''','"','/','`',#13,#10];
begin
  result := '';

  if (SearchStr <> '') then
  begin
    if urfIgnoreCase in ReplaceFlags then
    begin
      str := LowerCase(Source);
      SearchStr := LowerCase(SearchStr);
    end
    else str := Source;

    str_length := Length(str);
    substr_length := Length(SearchStr);

    i := 0;
    j := 0;
    flFound := false;
    flRepeat := true;

    while (i < str_length) and flRepeat do
    begin
      if (str[i + 1] = SearchStr[j + 1]) then
      begin
        flCan := (j = 0) and ((i > 0) and (str[i] in Separators) or (i = 0));

        flFound := (j = substr_length - 1) and ((j > 0) or flCan);
        if flCan or (j > 0) and (j < substr_length - 1) then
          inc(j);
      end
      else begin
        if (j > 0) then
          result := result + Copy(Source,i + 1 - j,j);
        j := 0;
      end;

      if flFound then
      begin
        if not (urfWholeWordsOnly in ReplaceFlags) then
          result := result + ReplaceStr
        else if (i < str_length - 1) and (str[i + 2] in Separators) or (i = str_length - 1) then
          result := result + ReplaceStr
        else result := result + Copy(Source,i + 2 - substr_length,substr_length);

        j := 0;
        flFound := false;
        flRepeat := (urfReplaceAll in ReplaceFlags);
      end
      else if (j = 0) then result := result + Source[i + 1];

      inc(i);
    end;
  end
  else result := str;
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

{*******************************************************************************
* EscapeString
*******************************************************************************}
function EscapeString( const str : string ) : string;
var
  i  : integer;
  ch : char;
begin
  Result := '';

  for i := 1 to Length(str) do
  begin
    ch := str[i];

    if ( '"' = ch ) then
      Result := Result + '\"'
    else if ( '''' = ch ) then
      Result := Result + '\'''
    else if ( '\' = ch ) then
      Result := Result + '\\'
    else
      Result := Result + ch;
  end;

end;

{*******************************************************************************
* UnescapeString
*******************************************************************************}
function UnescapeString( const str : string ) : string;
var
  i   : integer;
  n   : integer;
  ch  : char;
  ch1 : char;

begin
    Result := '';

    i   := 1;
    n   := Length( str );
    ch1 := #0;

    while i < n do
    begin
        ch  := str[i];
        ch1 := str[i + 1];

        if not ( ( '\' = ch ) and ( ( '\' = ch1 ) or ( '''' = ch1 ) or ( '"' = ch1 ) ) ) then
            Result := Result + ch
        else begin
            Result := Result + ch1;
            inc(i);
        end;

        inc(i);
    end;

    if ( i = n ) then
        Result := Result + ch1;
end;

{*******************************************************************************
* StringToCaseSelect
*******************************************************************************}
function StringToCaseSelect( Selector : string; CaseList: array of string ): Integer;
var cnt: integer;
begin
  Result:=-1;
  for cnt:=0 to Length(CaseList)-1 do
  begin
    if CompareText(Selector, CaseList[cnt]) = 0 then
    begin
      Result:=cnt;
      Break;
    end;
  end;
end;

{**********************************************************************************************
* DecodeAutoCadSingleByteString
***********************************************************************************************}
function DecodeAutoCadSingleByteString(aStr : string) : string;
var
  lexems : TStringlist;
  lexem : string;
  i, p: integer;
  CharCode : Byte;
begin
  Result := '';
  lexems := TStringList.Create();

  // разбиваем на лексемы
  while Length(aStr) > 0 do
  begin
    p := Pos('%%', aStr);

    if p <= 0 then
    begin // больше '%%xxx' в строке нет
      lexem := aStr;
      lexems.Add(lexem);
      break;
    end
    else
    begin
      // выделяем в лексему все что до %%
      lexem := Copy(aStr, 1, p - 1);
      aStr := Copy(aStr, p, Length(aStr) - p + 1);

      if lexem <> '' then
        lexems.Add(lexem);

      // получаем символ из конструкции %%ххх  (х - цифра), ххх - код символа
      lexem := Copy(aStr, 3, 3);
      CharCode := StrToIntDef(lexem, 0);
      if CharCode > 0 then
      begin
        lexem := Chr(CharCode);
        lexems.Add(lexem);
      end;

      // отрезаем от исходной строки полученную лексему
      aStr := Copy(aStr, 6, Length(aStr) - 5);
    end;
  end;

  // собираем строку результата из декодированных лексем
  for i := 0 to lexems.Count - 1 do
  begin
    Result := Result + lexems[i];
  end;

  lexems.Free();
end;

{*******************************************************************************
* String2Name
*******************************************************************************}
function String2Name( const aString : string ) : string;
var
    i  : integer;
    ch : char;

begin
    Result := '';

    for i := 1 to Length( aString ) do
    begin
        ch := aString[i];
        if ( ch = '\\' ) or ( ch = '`' ) or ( ch = '''' ) or ( ch = '-' ) then
            continue;

        if ( ch = '.' ) then
            ch := '_';

        Result := Result + ch;
    end;
end;
//------------------------------------------------------------------------------

function StringToAsciiCharactersString(const S: string): string;
var
  I: Integer;
begin
 Result:= S;
 for I:= 1 to Length(Result) do
 begin
   if not (Result[I] in ASCII_CHARS_SET) then
      Result[I] := '_';
 end;
end;

function StringIntegerCharactersString(const S: string): string;
var
  I: Integer;
begin
 Result:= S;
 for I:= 1 to Length(Result) do
 begin
   if not (Result[I] in INTEGER_CHARS_SET) then
      Result[I] := '0';
 end;
end;  

//function StringToByteArray(const AValue: String; var VOut: array of Byte): Integer;
//var
//  I: Integer;
//begin
//  Result:= Length(AValue);
//
//  SetLength(VOut,Result);
//  for I := 0 to Result - 1 do
//    Move(AValue[I],VOut,Result * SizeOf(Char));
//end;
//
//function ByteArrayToString(const Value: array of byte): String;
//var
//    I: integer;
//    S : String;
//    Letra: char;
//begin
//    S := '';
//    for I := Length(Value)-1 Downto 0 do
//    begin
//        letra := Chr(Value[I] + 48);
//        S := letra + S;
//    end;
//    Result := S;
//end;


function VarRecToStr(VarRec: TVarRec): string;
begin
  case VarRec.VType of
    vtInteger: Result := IntToStr(VarRec.VInteger);
    vtInt64: Result := IntToStr(VarRec.VInt64^);
    vtBoolean: Result := BoolToStr(VarRec.VBoolean);
    vtChar: Result := VarRec.VChar;
    vtExtended: Result := FloatToStr(VarRec.VExtended^);
    vtString: Result := VarRec.VString^;
    vtPChar: Result := VarRec.VPChar;
    vtObject: Result := VarRec.VObject.ClassName;
    vtClass: Result := VarRec.VClass.ClassName;
    vtAnsiString: Result := string(VarRec.VAnsiString);
    vtCurrency: Result := CurrToStr(VarRec.VCurrency^);
    vtVariant: Result := string(VarRec.VVariant^);
  else
    result := '';
  end;
end;



{*******************************************************************************
* GetLeftDigits
*******************************************************************************}
function GetLeftDigits( const aValue : string ) : string;
var
    i  : integer;
    ch : integer;

begin
    Result := aValue;

    // filtering out non digits at the end of string value
    for i := 1 to Length( aValue ) do
    begin
        ch := Ord( aValue[i] );
        if ( not( ch in [ 48..57 ] ) ) then
        begin
            SetLength( Result, i - 1 );
            break;
        end;
    end;
end;

{*******************************************************************************
* GetRightDigits
*******************************************************************************}
function GetRightDigits( const aValue : string ) : string;
var
    i  : integer;
    ch : integer;

begin
    Result := '';

    for i := Length( aValue ) downto 1 do
    begin
        ch := Ord( aValue[i] );
        if ( not( ch in [ 48..57 ] ) ) then
            break;

        Result := aValue[i] + Result;
    end;
end;

{*******************************************************************************
* StrToHexStr
*******************************************************************************}
function StrToHexStr(const ASource: string): string;
{$IFDEF FPC}
{$if Defined(CompilerVersion) and (CompilerVersion <= 15) }
type
TBytes = array of Byte;
{$ifend}
{$ELSE}
{$if CompilerVersion <= 15 }
type
TBytes = array of Byte;
{$ifend}
{$ENDIF}
var
  I: integer;
begin
  for I := 0 to (Length(ASource) * SizeOf(Char)) -1 do
    Result := Result + IntToHex(TBytes(Pointer(ASource))[I], 2);
end;

{*******************************************************************************
* StrToHexStr
*******************************************************************************}
function HexStrToStr(const ASource: string): string;
{$IFDEF FPC}
{$if Defined(CompilerVersion) and (CompilerVersion <= 15) }
type
TBytes = array of Byte;
{$ifend}
{$ELSE}
{$if CompilerVersion <= 15 }
type
TBytes = array of Byte;
{$ifend}
{$ENDIF}
var I: integer;
begin
    SetLength(Result, Length(ASource) div (SizeOf(Char)*2));
    for I := 0 to Length(ASource) div 2 - 1 do
      TBytes(Pointer(Result))[I]:= StrToIntDef('$'+Copy(ASource, I * 2+1, 2), 0);
end;
//------------------------------------------------------------------------------

//function HexStrToInt(const AStr: string; const ADefault: Integer = -1): Int64;
//var
//  Code: Integer;
//begin
//  Val('$' + AStr, Result, Code);
//  if Code <> 0 then
//    Result := ADefault;
//end;

{*******************************************************************************
* IsInteger
*******************************************************************************}

function IsInteger(const ABuffer: String) : Boolean;
var
  I: Integer;
begin
  Result := False;
  if ABuffer = '' then
    Exit;
  for I:= 1 to Length(ABuffer) do
  begin
    if not (ABuffer[I] in INTEGER_CHARS_SET) then
      Exit;
  end;
  Result:= True;
end;  

{*******************************************************************************
* IsFloat
*******************************************************************************}

function IsFloat(const ABuffer: String; const ADecimalSeparator: Char) : Boolean;
var
I: Integer;
begin
  Result := False;
  if ABuffer = '' then
    Exit;
  for I:= 1 to Length(ABuffer) do
  begin
    if not (ABuffer[I] in FLOAT_CHARS_SET) then
      Exit;
  end;
  Result:= True;
end;

{*******************************************************************************
* IsFloat
*******************************************************************************}

function IsFloat(const ABuffer: String) : Boolean;
begin
  Result:= IsFloat(ABuffer,UnisDefaultDecimalSeparator);
end;

{*******************************************************************************
* IsHexadecimal
*******************************************************************************}
function IsHexadecimal(const ABuffer: String): Boolean;
var
I: Integer;
begin
  Result := False;
  if ABuffer = '' then
    Exit;
  for I:= 1 to Length(ABuffer) do
  begin
    if not (ABuffer[I] in HEX_CHARS_SET) then
      Exit;
  end;
  Result:= True;
end;
//------------------------------------------------------------------------------

function RemoveCharDuplicates(const AChr: Char; const AText: String): string;
var
  TextLength,CharIndex: Integer;
  Chr: Char;
begin
  Result:= '';
  TextLength:= Length(AText);

  for CharIndex:=2 to TextLength do
  begin
    Chr:= AText[CharIndex];
    if (Chr = AChr) and ((AText[CharIndex-1] = AChr)) then
      Continue;

    Result:= Result + Chr;
  end;
  
end;

initialization
  DecimalSeparatorSavedCount  := 0;
  LastGoodDecimalSeparator    := DecimalSeparator;
  UnisDefaultDecimalSeparator := '.';
end.
