
/*************************
 * Encode and decode Uniform Resource Identifiers (URIs).
 * URIs are used in internet transfer protocols.
 * Valid URI characters consist of letters, digits,
 * and the characters $(B ;/?:@&amp;=+$,-_.!~*'())
 * Reserved URI characters are $(B ;/?:@&amp;=+$,)
 * Escape sequences consist of $(B %) followed by two hex digits.
 *
 * See_Also:
 *	$(LINK2 http://www.ietf.org/rfc/rfc3986.txt, RFC 3986)<br>
 *	$(LINK2 http://en.wikipedia.org/wiki/Uniform_resource_identifier, Wikipedia)
 * Macros:
 *	WIKI = Phobos/StdUri
 */

module std.uri;

//debug=uri;		// uncomment to turn on debugging printf's

/* ====================== URI Functions ================ */

private import std.ctype;
private import std.c: alloca;
private import std.utf;
private import std.io;

class URIerror : Error
{
    this()
    {
	super("URI error");
    }
}
alias URIerror ОшУИР;

enum
{
    URI_Alpha = 1,
    URI_Reserved = 2,
    URI_Mark = 4,
    URI_Digit = 8,
    URI_Hash = 0x10,		// '#'
}

enum
{
    УИР_Альфа = 1,
    УИР_Резервн = 2,
    УИР_Метка = 4,
    УИР_Цифра = 8,
    УИР_Хэш = 0x10,		// '#'
}

char[16] hex2ascii = "0123456789ABCDEF";

ubyte[128] uri_flags;		// indexed by character

static this()
{
    // Initialize uri_flags[]

    static void helper(char[] p, uint flags)
    {	int i;

	for (i = 0; i < p.length; i++)
	    uri_flags[p[i]] |= flags;
    }

    uri_flags['#'] |= URI_Hash;

    for (int i = 'A'; i <= 'Z'; i++)
    {	uri_flags[i] |= URI_Alpha;
	uri_flags[i + 0x20] |= URI_Alpha;	// lowercase letters
    }
    helper("0123456789", URI_Digit);
    helper(";/?:@&=+$,", URI_Reserved);
    helper("-_.!~*'()",  URI_Mark);
}


private char[] URI_Encode(dchar[] string, uint unescapedSet);

uint ascii2hex(dchar c);
alias ascii2hex аски8гекс;

private dchar[] URI_Decode(char[] string, uint reservedSet);

/*************************************
 * Decodes the URI string encodedURI into a UTF-8 string and returns it.
 * Escape sequences that resolve to reserved URI characters are not replaced.
 * Escape sequences that resolve to the '#' character are not replaced.
 */

char[] decode(char[] encodedURI);
alias decode раскодируй;

/*******************************
 * Decodes the URI string encodedURI into a UTF-8 string and returns it. All
 * escape sequences are decoded.
 */

char[] decodeComponent(char[] encodedURIComponent);
alias decodeComponent раскодируйКомпонент;

/*****************************
 * Encodes the UTF-8 string uri into a URI and returns that URI. Any character
 * not a valid URI character is escaped. The '#' character is not escaped.
 */

char[] encode(char[] uri);
alias encode кодируй;
/********************************
 * Encodes the UTF-8 string uriComponent into a URI and returns that URI.
 * Any character not a letter, digit, or one of -_.!~*'() is escaped.
 */

char[] encodeComponent(char[] uriComponent);
alias encodeComponent кодируйКомпонент;

//проц main()
unittest
{
    выводф("uri.encodeURI.unittest\n");

    сим[] s = "http://www.digitalmars.com/~fred/fred's RX.html#foo";
    сим[] t = "http://www.digitalmars.com/~fred/fred's%20RX.html#foo";
    сим[] r;

    r = кодируй(s);
    выводф("r = '%.*s'\n", r);
    assert(r == t);
    r = раскодируй(t);
    выводф("r = '%.*s'\n", r);
    assert(r == s);

    r = кодируй( раскодируй("%E3%81%82%E3%81%82") );
    assert(r == "%E3%81%82%E3%81%82");

    r = кодируйКомпонент("c++");
    //выводф("r = '%.*s'\n", r);
    assert(r == "c%2B%2B");

    сим[] str = new сим[10_000_000];
    str[] = 'A';
    r = кодируйКомпонент(str);
    foreach (сим c; r)
	assert(c == 'A');

    r = раскодируй("%41%42%43");
    writefln(r);
}
