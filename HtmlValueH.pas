unit HtmlValueH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for function from include\value.h of
  Most accurate documentation could be found in include\value.h itself
*)

interface

uses Windows, sysutils
    , HtmlDll
;

type

    //enum VALUE_RESULT
    VALUE_RESULT = (
        HV_OK_TRUE              = -1,
        HV_OK                   = 0,
        HV_BAD_PARAMETER        = 1,
        HV_INCOMPATIBLE_TYPE    = 2
    );

    HtmlVALUE = record
        t                       : UINT;
        u                       : UINT;
        d                       : UINT64;
    end;
    PHtmlVALUE = ^HtmlVALUE; 

    LPCBYTES = PChar;
    FLOAT_VALUE = double;

    //enum VALUE_TYPE
    VALUE_TYPE = (
        T_UNDEFINED             = 0,
        T_NULL                  = 1,
        T_BOOL                  = 2,
        T_INT                   = 3,
        T_FLOAT                 = 4,
        T_STRING                = 5,
        T_DATE                  = 6, // INT64 - contains a 64-bit value representing the number of 100-nanosecond intervals since January 1, 1601 (UTC), a.k.a. FILETIME on Windows
        T_CURRENCY              = 7, // INT64 - 14.4 fixed number. E.g. dollars = int64 / 10000;
        T_LENGTH                = 8, // length units, value is int or float, units are VALUE_UNIT_TYPE
        T_ARRAY                 = 9,
        T_MAP                   = 10,
        T_FUNCTION              = 11,
        T_BYTES                 = 12, // sequence of bytes - e.g. image data
        T_OBJECT                = 13, // scripting object proxy (TISCRIPT/SCITER)
        T_DOM_OBJECT            = 14 // DOM object (CSSS!), use get_object_data to get HELEMENT
    );

    //enum VALUE_UNIT_TYPE
    VALUE_UNIT_TYPE = (
        UT_EM                   = 1, //height of the element's font.
        UT_EX                   = 2, //height of letter 'x'
        UT_PR                   = 3, //%
        UT_SP                   = 4, //%% "springs", a.k.a. flex units
        reserved1               = 5,
        reserved2               = 6,
        UT_PX                   = 7, //pixels
        UT_IN                   = 8, //inches (1 inch = 2.54 centimeters).
        UT_CM                   = 9, //centimeters.
        UT_MM                   = 10, //millimeters.
        UT_PT                   = 11, //points (1 point = 1/72 inches).
        UT_PC                   = 12, //picas (1 pica = 12 points).
        UT_DIP                  = 13,
        reserved3               = 14,
        UT_COLOR                = 15, // color in int
        UT_URL                  = 16,  // url in string
        UT_SYMBOL               = $FFFF // for T_STRINGs designates symbol string ( so called NAME_TOKEN - CSS or JS identifier )
    );

    //enum VALUE_UNIT_TYPE_DATE
    VALUE_UNIT_TYPE_DATE = (
        DT_HAS_DATE             = $01, // date contains date portion
        DT_HAS_TIME             = $02, // date contains time portion HH:MM
        DT_HAS_SECONDS          = $04, // date contains time and seconds HH:MM:SS
        DT_UTC                  = $10 // T_DATE is known to be UTC. Otherwise it is local date/time
    );

implementation

end.