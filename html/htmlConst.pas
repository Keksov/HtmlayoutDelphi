unit htmlConst;

interface

type
    EHTMLAttributes = ( HTML_ATTR_SIZE, HTML_ATTR_VALUE, HTML_ATTR_HREF );

    // just a list of most friquently used attributes, fill free to extend it. see THtmlHElement CSS shorcuts below
    EHTMLStyleAttributes = (
        STYLE_ATTR_WIDTH, STYLE_ATTR_HEIGHT, STYLE_ATTR_TOP, STYLE_ATTR_LEFT, STYLE_ATTR_BACKGROUND_COLOR, STYLE_ATTR_COLOR, STYLE_ATTR_VISIBILITY
    );

const
    HTMLAttributes : array[ EHTMLAttributes ] of string = (
          'size', 'value', 'href'
    );

    HTMLStyleAttributes : array[ EHTMLStyleAttributes ] of string = (
        'width', 'height', 'top', 'left', 'background-color', 'color', 'visibility'
    );

implementation

end.
