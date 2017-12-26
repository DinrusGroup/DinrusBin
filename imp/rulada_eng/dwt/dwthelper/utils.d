/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.utils;

public import dwt.dwthelper.System;
public import dwt.dwthelper.Runnable;
public import Math = tango.math.Math;

public import tango.core.Exception : IllegalArgumentException, IOException;

import tango.io.Stdout;
import tango.io.stream.Format;
static import tango.stdc.stringz;
static import tango.text.Util;
static import tango.text.Text;
static import tango.text.Ascii;
import tango.text.Unicode;
import tango.text.convert.Utf;
import tango.core.Exception;
import std.c : exit;

import tango.util.log.Trace;
import tango.util.log.Log;
import tango.text.UnicodeData;

Logger getDwtLogger(){
    return Log.lookup( "dwt" );
}

alias char[] String;
alias tango.text.Text.Text!(char) StringBuffer;

alias ArrayBoundsException ArrayIndexOutOfBoundsException;

void implMissing( String file, uint line ){
    Stderr.formatln( "implementation missing in file {} line {}", file, line );
    Stderr.formatln( "exiting ..." );
    exit(1);
}

abstract class ArrayWrapper{
}
abstract class ValueWrapper{
}

class ArrayWrapperT(T) : ArrayWrapper {
    public T[] array;
    public this( T[] data ){
        array = data;
    }
    public override int opEquals( Object o ){
        if( auto other = cast(ArrayWrapperT!(T))o){
            return array == other.array;
        }
        return false;
    }
    public override hash_t toHash(){
        return (typeid(T[])).getHash(&array);
    }
    static if( is( T == char )){
        public override char[] toString(){
            return array;
        }
    }
}

class ValueWrapperT(T) : ValueWrapper {
    public T value;
    public this( T data ){
        value = data;
    }
    static if( is(T==class) || is(T==interface)){
        public int opEquals( Object other ){
            if( auto o = cast(ValueWrapperT!(T))other ){
                return value == o.value;
            }
            if( auto o = cast(T)other ){
                if( value is o ){
                    return true;
                }
                if( value is null || o is null ){
                    return false;
                }
                return value == o;
            }
            return false;
        }
    }
    else{
        public int opEquals( Object other ){
            if( auto o = cast(ValueWrapperT!(T))other ){
                return value == o.value;
            }
            return false;
        }
        public int opEquals( T other ){
            return value == other;
        }
    }
    public override hash_t toHash(){
        return (typeid(T)).getHash(&value);
    }
}

class Boolean : ValueWrapperT!(bool) {
    public static Boolean TRUE;
    public static Boolean FALSE;

    static this(){
        TRUE  = new Boolean(true);
        FALSE = new Boolean(false);
    }
    public this( bool v ){
        super(v);
    }

    alias ValueWrapperT!(bool).opEquals opEquals;
    public int opEquals( int other ){
        return value == ( other !is 0 );
    }
    public int opEquals( Object other ){
        if( auto o = cast(Boolean)other ){
            return value == o.value;
        }
        return false;
    }
    public bool booleanValue(){
        return value;
    }
    public static Boolean valueOf( String s ){
        if( s == "yes" || s == "true" ){
            return TRUE;
        }
        return FALSE;
    }
    public static Boolean valueOf( bool b ){
        return b ? TRUE : FALSE;
    }
    public static bool getBoolean(String name){
        return tango.text.Ascii.icompare(System.getProperty(name, "false"), "true" ) is 0;
    }
}

alias Boolean    ValueWrapperBool;


class Byte : ValueWrapperT!(byte) {
    public static byte parseByte( String s ){
        try{
            int res = tango.text.convert.Integer.parse( s );
            if( res < byte.min || res > byte.max ){
                throw new NumberFormatException( "out of range" );
            }
            return res;
        }
        catch( IllegalArgumentException e ){
            throw new NumberFormatException( e );
        }
    }
    this( byte value ){
        super( value );
    }

    public static String toString( byte i ){
        return tango.text.convert.Integer.toString(i);
    }

}
alias Byte ValueWrapperByte;


class Integer : ValueWrapperT!(int) {

    public static const int MIN_VALUE = 0x80000000;
    public static const int MAX_VALUE = 0x7fffffff;
    public static const int SIZE = 32;

    public this ( int value ){
        super( value );
    }

    public this ( String s ){
        super(parseInt(s));
    }

    public static String toString( int i, int radix ){
        switch( radix ){
        case 2:
            return toBinaryString(i);
        case 8:
            return toOctalString(i);
        case 10:
            return toString(i);
        case 16:
            return toHexString(i);
        default:
            implMissing( __FILE__, __LINE__ );
            return null;
        }
    }

    public static String toHexString( int i ){
        return tango.text.convert.Integer.toString(i, "x" );
    }

    public static String toOctalString( int i ){
        return tango.text.convert.Integer.toString(i, "o" );
    }

    public static String toBinaryString( int i ){
        return tango.text.convert.Integer.toString(i, "b" );
    }

    public static String toString( int i ){
        return tango.text.convert.Integer.toString(i);
    }

    public static int parseInt( String s, int radix ){
        try{
            return tango.text.convert.Integer.toLong( s, radix );
        }
        catch( IllegalArgumentException e ){
            throw new NumberFormatException( e );
        }
    }

    public static int parseInt( String s ){
        try{
            return tango.text.convert.Integer.toLong( s );
        }
        catch( IllegalArgumentException e ){
            throw new NumberFormatException( e );
        }
    }

    public static Integer valueOf( String s, int radix ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    public static Integer valueOf( String s ){
        return valueOf( parseInt(s));
    }

    public static Integer valueOf( int i ){
        return new Integer(i);
    }

    public byte byteValue(){
        return cast(byte)value;
    }

    public short shortValue(){
        return cast(short)value;
    }

    public int intValue(){
        return value;
    }

    public long longValue(){
        return cast(long)value;
    }

    public float floatValue(){
        return cast(float)value;
    }

    public double doubleValue(){
        return cast(double)value;
    }

    public override  hash_t toHash(){
        return intValue();
    }

    public override String toString(){
        return tango.text.convert.Integer.toString( value );
    }
}
alias Integer ValueWrapperInt;

class Double : ValueWrapperT!(double) {
    public static double MAX_VALUE = double.max;
    public static double MIN_VALUE = double.min;
    this( double value ){
        super(value);
    }
    this( String str ){
        implMissing( __FILE__, __LINE__ );
        super(0.0);
    }
    public double doubleValue(){
        return value;
    }
    public static String toString( double value ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static double parseDouble(String s){
        implMissing( __FILE__, __LINE__ );
        return 0.0;
    }
}

class Float : ValueWrapperT!(float) {

    public static float POSITIVE_INFINITY = (1.0f / 0.0f);
    public static float NEGATIVE_INFINITY = ((-1.0f) / 0.0f);
    public static float NaN = (0.0f / 0.0f);
    public static float MAX_VALUE = 3.4028235e+38f;
    public static float MIN_VALUE = 1.4e-45f;
    public static int SIZE = 32;

    this( float value ){
        super(value);
    }
    this( String str ){
        implMissing( __FILE__, __LINE__ );
        super(0.0);
    }
    public float floatValue(){
        return value;
    }
    public static String toString( float value ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static float parseFloat( String s ){
        try{
            return tango.text.convert.Float.toFloat( s );
        }
        catch( IllegalArgumentException e ){
            throw new NumberFormatException( e );
        }
    }

}
class Long : ValueWrapperT!(long) {
    public static const long MIN_VALUE = long.min;
    public static const long MAX_VALUE = long.max;
    this( long value ){
        super(value);
    }
    this( String str ){
        implMissing( __FILE__, __LINE__ );
        super(0);
    }
    public long longValue(){
        return value;
    }
    public static long parseLong(String s){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public static String toString( double value ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
}
alias Long ValueWrapperLong;


// alias ValueWrapperT!(int)     ValueWrapperInt;

alias ArrayWrapperT!(byte)    ArrayWrapperByte;
alias ArrayWrapperT!(int)     ArrayWrapperInt;
alias ArrayWrapperT!(Object)  ArrayWrapperObject;
alias ArrayWrapperT!(char)    ArrayWrapperString;
alias ArrayWrapperT!(String)  ArrayWrapperString2;

Object[] StringArrayToObjectArray( String[] strs ){
    Object[] res = new Object[strs.length];
    foreach( idx, str; strs ){
        res[idx] = new ArrayWrapperString(str);
    }
    return res;
}
int codepointIndexToIndex( String str, int cpIndex ){
    int cps = cpIndex;
    int res = 0;
    while( cps > 0 ){
        cps--;
        if( str[res] < 0x80 ){
            res+=1;
        }
        else if( str[res] < 0xE0 ){
            res+=2;
        }
        else if( str[res] & 0xF0 ){
            res+=3;
        }
        else{
            res+=4;
        }
    }
    return res;
}

/++
 +
 +/
int indexToCodepointIndex( String str, int index ){
    if( index < 0 ) return index;
    int i = 0;
    int res = 0;
    while( i < index ){
        if( i >= str.length ){
            break;
        }
        if( str[i] < 0x80 ){
            i+=1;
        }
        else if( str[i] < 0xE0 ){
            i+=2;
        }
        else if( str[i] & 0xF0 ){
            i+=3;
        }
        else{
            i+=4;
        }
        res++;
    }
    return res;
}

/++
 + Get that String, that contains the next codepoint of a String.
 +/
String firstCodePointStr( String str, out int consumed ){
    dchar[1] buf;
    uint ate;
    dchar[] res = str.toString32( buf, &ate );
    consumed = ate;
    return str[ 0 .. ate ];
}

/++
 + Get first codepoint of a String. If an offset is needed, simply use a slice:
 + ---
 + dchar res = str[ offset .. $ ].firstCodePoint();
 + ---
 +/
dchar firstCodePoint( String str ){
    int dummy;
    return firstCodePoint( str, dummy );
}
dchar firstCodePoint( String str, out int consumed ){
    dchar[1] buf;
    uint ate;
    dchar[] res = str.toString32( buf, &ate );
    consumed = ate;
    if( ate is 0 || res.length is 0 ){
        Trace.formatln( "dwthelper.utils {}: str.length={} str={:X2}", __LINE__, str.length, cast(ubyte[])str );
    }
    assert( ate > 0 );
    assert( res.length is 1 );
    return res[0];
}
dchar firstCodePoint( wchar[] str, out int consumed ){
    dchar[1] buf;
    uint ate;
    dchar[] res = str.toString32( buf, &ate );
    consumed = ate;
    if( ate is 0 || res.length is 0 ){
        Trace.formatln( "dwthelper.utils {}: str.length={} str={:X2}", __LINE__, str.length, cast(ubyte[])str );
    }
    assert( ate > 0 );
    assert( res.length is 1 );
    return res[0];
}

String dcharToString( dchar key ){
    dchar[1] buf;
    buf[0] = key;
    return tango.text.convert.Utf.toString( buf );
}

int codepointCount( String str ){
    scope dchar[] buf = new dchar[]( str.length );
    uint ate;
    dchar[] res = tango.text.convert.Utf.toString32( str, buf, &ate );
    assert( ate is str.length );
    return res.length;
}

//alias tango.text.convert.Utf.toString16 toString16;
//alias tango.text.convert.Utf.toString toString;

int toAbsoluteCodePointStartOffset( String str, int index ){
    //Trace.formatln( "str={}, str.length={}, index={}", str, str.length, index );
    //Trace.memory( str );
    if( str.length is index ){
        return index;
    }
    if( ( str[index] & 0x80 ) is 0x00 ) {
        return index;
    }
    else{
        int steps = 0;
        while(( str[index] & 0xC0 ) is 0x80 ){
            index--;
            steps++;
            if( steps > 3 || index < 0 ){
                break;
            }
        }
        if((( str[index] & 0xE0 ) is 0xC0) && ( steps <= 1 )){
            // ok
        }
        else if((( str[index] & 0xF0 ) is 0xE0) && ( steps <= 2 )){
            // ok
        }
        else if((( str[index] & 0xF8 ) is 0xF0) && ( steps <= 3 )){
            // ok
        }
        else{
            tango.text.convert.Utf.onUnicodeError( "invalid utf8 input to toAbsoluteCodePointStartOffset" );
        }
        return index;
    }
}
int getRelativeCodePointOffset( String str, int startIndex, int searchRelCp ){
    return getAbsoluteCodePointOffset( str, startIndex, searchRelCp ) - startIndex;
}
int getAbsoluteCodePointOffset( String str, int startIndex, int searchRelCp ){

    //Trace.formatln( "str={}, str.length={}, startIndex={}, searchRelCp={}", str, str.length, startIndex, searchRelCp );
    //Trace.memory( str );

    int ignore;
    int i = startIndex;
    if( searchRelCp > 0 ){
        while( searchRelCp !is 0 ){

            if( ( i < str.length )
            && (( str[i] & 0x80 ) is 0x00 ))
            {
                i+=1;
            }
            else if( ( i+1 < str.length )
                && (( str[i+1] & 0xC0 ) is 0x80 )
                && (( str[i  ] & 0xE0 ) is 0xC0 ))
            {
                i+=2;
            }
            else if( ( i+2 < str.length )
                && (( str[i+2] & 0xC0 ) is 0x80 )
                && (( str[i+1] & 0xC0 ) is 0x80 )
                && (( str[i  ] & 0xF0 ) is 0xE0 ))
            {
                i+=3;
            }
            else if(( i+3 < str.length )
                && (( str[i+3] & 0xC0 ) is 0x80 )
                && (( str[i+2] & 0xC0 ) is 0x80 )
                && (( str[i+1] & 0xC0 ) is 0x80 )
                && (( str[i  ] & 0xF8 ) is 0xF0 ))
            {
                i+=4;
            }
            else{
                Trace.formatln( "getAbsoluteCodePointOffset invalid utf8 characters:  {:X2}", cast(ubyte[]) str );
                tango.text.convert.Utf.onUnicodeError( "invalid utf8 input", i );
            }
            searchRelCp--;
        }
    }
    else if( searchRelCp < 0 ){
        while( searchRelCp !is 0 ){
            do{
                i--;
                if( i < 0 ){
                    return startIndex-1;
                }
            } while(( str[i] & 0xC0 ) is 0x80 );
            searchRelCp++;
        }
    }
    return i;
}
int getAbsoluteCodePointOffset( wchar[] str, int startIndex, int searchRelCp ){
    int ignore;
    int i = startIndex;
    if( searchRelCp > 0 ){
        while( searchRelCp !is 0 ){

            if( ( i < str.length )
                && ( str[i] & 0xD800 ) !is 0xD800 )
            {
                i+=1;
            }
            else if( ( i+1 < str.length )
                && (( str[i+1] & 0xDC00 ) is 0xDC00 )
                && (( str[i  ] & 0xDC00 ) is 0xD800 ))
            {
                i+=2;
            }
            else{
                Trace.formatln( "invalid utf16 characters:  {:X2}", cast(ubyte[]) str );
                tango.text.convert.Utf.onUnicodeError( "invalid utf16 input", i );
            }
            searchRelCp--;
        }
    }
    else if( searchRelCp < 0 ){
        while( searchRelCp !is 0 ){
            do{
                i--;
                if( i < 0 ){
                    return startIndex-1;
                    //Trace.formatln( "dwthelper.utils getRelativeCodePointOffset {}: str={}, startIndex={}, searchRelCp={}", __LINE__, str, startIndex, searchRelCp );
                    //tango.text.convert.Utf.onUnicodeError( "invalid utf16 input", i );
                }
            } while(( str[i] & 0xDC00 ) is 0xDC00 );
            searchRelCp++;
        }
    }
    return i;
}
dchar getRelativeCodePoint( String str, int startIndex, int searchRelCp ){
    int dummy;
    return getRelativeCodePoint( str, startIndex, dummy );
}
dchar getRelativeCodePoint( String str, int startIndex, int searchRelCp, out int relIndex ){
    relIndex = getRelativeCodePointOffset( str, startIndex, searchRelCp );
    int ignore;
    return firstCodePoint( str[ startIndex+relIndex .. $ ], ignore );
}

int utf8AdjustOffset( String str, int offset ){
    if( str.length <= offset || offset <= 0 ){
        return offset;
    }
    while(( str[offset] & 0xC0 ) is 0x80 ){
        offset--;
    }
    return offset;
}
int utf8OffsetIncr( String str, int offset ){
    int res = offset +1;
    if( str.length <= res || res <= 0 ){
        return res;
    }
    int tries = 4;
    while(( str[res] & 0xC0 ) is 0x80 ){
        res++;
        assert( tries-- > 0 );
    }
    return res;
}
int utf8OffsetDecr( String str, int offset ){
    int res = offset-1;
    if( str.length <= res || res <= 0 ){
        return res;
    }
    int tries = 4;
    while(( str[res] & 0xC0 ) is 0x80 ){
        res--;
        assert( tries-- > 0 );
    }
    Trace.formatln( "utf8OffsetDecr {}->{}", offset, res );
    Trace.memory( str );
    return res;
}

class Character {
    public static bool isUpperCase( dchar c ){
        implMissing( __FILE__, __LINE__);
        return false;
    }
    public static dchar toUpperCase( dchar c ){
        dchar[] r = tango.text.Unicode.toUpper( [c] );
        return r[0];
    }
    public static dchar toLowerCase( dchar c ){
        dchar[] r = tango.text.Unicode.toLower( [c] );
        return r[0];
    }
    public static bool isWhitespace( dchar c ){
        return tango.text.Unicode.isWhitespace( c );
    }
    public static bool isDigit( dchar c ){
        return tango.text.Unicode.isDigit( c );
    }
    public static bool isLetterOrDigit( dchar c ){
        return isDigit(c) || isLetter(c);
    }
    public static bool isUnicodeIdentifierPart(char ch){
        implMissing( __FILE__, __LINE__);
        return false;
    }
    public static bool isUnicodeIdentifierStart(char ch){
        implMissing( __FILE__, __LINE__);
        return false;
    }
    public static bool isIdentifierIgnorable(char ch){
        implMissing( __FILE__, __LINE__);
        return false;
    }
    public static bool isJavaIdentifierPart(char ch){
        implMissing( __FILE__, __LINE__);
        return false;
    }

    this( char c ){
        // must be correct for container storage
        implMissing( __FILE__, __LINE__);
    }
}

String new_String( String cont, int offset, int len ){
    return cont[ offset .. offset+len ].dup;
}
String new_String( String cont ){
    return cont.dup;
}
String String_valueOf( bool v ){
    return v ? "true" : "false";
}
String String_valueOf( int v ){
    return tango.text.convert.Integer.toString(v);
}
String String_valueOf( long v ){
    return tango.text.convert.Integer.toString(v);
}
String String_valueOf( float v ){
    return tango.text.convert.Float.toString(v);
}
String String_valueOf( double v ){
    return tango.text.convert.Float.toString(v);
}
String String_valueOf( dchar v ){
    return dcharToString(v);
}
String String_valueOf( char[] v ){
    return v.dup;
}
String String_valueOf( char[] v, int offset, int len ){
    return v[ offset .. offset+len ].dup;
}
String String_valueOf( Object v ){
    return v is null ? "null" : v.toString();
}
bool CharacterIsDefined( dchar ch ){
    return (ch in tango.text.UnicodeData.unicodeData) !is null;
}
dchar CharacterFirstToLower( String str ){
    int consumed;
    return CharacterFirstToLower( str, consumed );
}
dchar CharacterFirstToLower( String str, out int consumed ){
    dchar[1] buf;
    buf[0] = firstCodePoint( str, consumed );
    dchar[] r = tango.text.Unicode.toLower( buf );
    return r[0];
}
int length( String str ){
    return str.length;
}
dchar CharacterToLower( dchar c ){
    dchar[] r = tango.text.Unicode.toLower( [c] );
    return r[0];
}
dchar CharacterToUpper( dchar c ){
    dchar[] r = tango.text.Unicode.toUpper( [c] );
    return r[0];
}
bool CharacterIsWhitespace( dchar c ){
    return tango.text.Unicode.isWhitespace( c );
}
bool CharacterIsDigit( dchar c ){
    return tango.text.Unicode.isDigit( c );
}
bool CharacterIsLetter( dchar c ){
    return tango.text.Unicode.isLetter( c );
}
public String toUpperCase( String str ){
    return tango.text.Unicode.toUpper( str );
}

public String replaceFirst( String str, String regex, String replacement ){
    implMissing(__FILE__,__LINE__);
    return str;
}

public int indexOf( String str, char searched ){
    int res = tango.text.Util.locate( str, searched );
    if( res is str.length ) res = -1;
    return res;
}

public int indexOf( String str, char searched, int startpos ){
    int res = tango.text.Util.locate( str, searched, startpos );
    if( res is str.length ) res = -1;
    return res;
}

public int indexOf(String str, String ch){
    return indexOf( str, ch, 0 );
}

public int indexOf(String str, String ch, int start){
    int res = tango.text.Util.locatePattern( str, ch, start );
    if( res is str.length ) res = -1;
    return res;
}

public int lastIndexOf(String str, char ch){
    return lastIndexOf( str, ch, str.length );
}
public int lastIndexOf(String str, char ch, int formIndex){
    int res = tango.text.Util.locatePrior( str, ch, formIndex );
    if( res is str.length ) res = -1;
    return res;
}
public int lastIndexOf(String str, String ch ){
    return lastIndexOf( str, ch, str.length );
}
public int lastIndexOf(String str, String ch, int start ){
    int res = tango.text.Util.locatePatternPrior( str, ch, start );
    if( res is str.length ) res = -1;
    return res;
}

public String replaceAll( String str, String regex, String replacement ){
    implMissing(__FILE__,__LINE__);
    return null;
}
public String replace( String str, char from, char to ){
    return tango.text.Util.replace( str.dup, from, to );
}

public String substring( String str, int start ){
    return str[ start .. $ ].dup;
}

public String substring( String str, int start, int end ){
    return str[ start .. end ].dup;
}

public wchar[] substring( wchar[] str, int start ){
    return str[ start .. $ ].dup;
}

public wchar[] substring( wchar[] str, int start, int end ){
    return str[ start .. end ].dup;
}

public char charAt( String str, int pos ){
    return str[ pos ];
}

public void getChars( String src, int srcBegin, int srcEnd, String dst, int dstBegin){
    dst[ dstBegin .. dstBegin + srcEnd - srcBegin ] = src[ srcBegin .. srcEnd ];
}

public wchar[] toWCharArray( String str ){
    return toString16(str);
}

public char[] toCharArray( String str ){
    return str;
}

public bool endsWith( String src, String pattern ){
    if( src.length < pattern.length ){
        return false;
    }
    return src[ $-pattern.length .. $ ] == pattern;
}

public bool equals( String src, String other ){
    return src == other;
}

public bool equalsIgnoreCase( String src, String other ){
    return tango.text.Unicode.toFold(src) == tango.text.Unicode.toFold(other);
}

public int compareToIgnoreCase( String src, String other ){
    return compareTo( tango.text.Unicode.toFold(src), tango.text.Unicode.toFold(other));
}
public int compareTo( String src, String other ){
    return typeid(String).compare( cast(void*)&src, cast(void*)&other );
}

public bool startsWith( String src, String pattern ){
    if( src.length < pattern.length ){
        return false;
    }
    return src[ 0 .. pattern.length ] == pattern;
}

public String toLowerCase( String src ){
    return tango.text.Unicode.toLower( src );
}

public hash_t toHash( String src ){
    return typeid(String).getHash(&src);
}

public String trim( String str ){
    return tango.text.Util.trim( str ).dup;
}
public String intern( String str ){
    return str;
}

/++
 + This is like tango.stdc.stringz.toStringz, but in case of an empty input string,
 + this function returns a pointer to a null value instead of a null ptr.
 +/
public char* toStringzValidPtr( String src ){
    if( src ){
        return src.toStringz();
    }
    else{
        static const String nullPtr = "\0";
        return nullPtr.ptr;
    }
}

public alias tango.stdc.stringz.toStringz toStringz;
public alias tango.stdc.stringz.toString16z toString16z;
public alias tango.stdc.stringz.fromStringz fromStringz;
public alias tango.stdc.stringz.fromString16z fromString16z;

static String toHex(uint value, bool prefix = true, int radix = 8){
    return tango.text.convert.Integer.toString(
            value,
            radix is 10 ? "d" :
            radix is  8 ? "o" :
            radix is 16 ? "x" :
                          "d" );
}

class RuntimeException : Exception {
    this( String e = null){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
        next = e;
    }
    public Exception getCause() {
        return next;
    }

}
class IndexOutOfBoundsException : Exception {
    this( String e = null){
        super(e);
    }
}

class UnsupportedOperationException : RuntimeException {
    this( String e = null){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
    }
}
class NumberFormatException : IllegalArgumentException {
    this( String e ){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
    }
}
class NullPointerException : Exception {
    this( String e = null ){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
    }
}
class IllegalStateException : Exception {
    this( String e = null ){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
    }
}
class InterruptedException : Exception {
    this( String e = null ){
        super(e);
    }
    this( Exception e ){
        super(e.toString);
    }
}
class InvocationTargetException : Exception {
    Exception cause;
    this( Exception e = null, String msg = null ){
        super(msg);
        cause = e;
    }

    alias getCause getTargetException;
    Exception getCause(){
        return cause;
    }
}
class MissingResourceException : Exception {
    String classname;
    String key;
    this( String msg, String classname, String key ){
        super(msg);
        this.classname = classname;
        this.key = key;
    }
}
class ParseException : Exception {
    this( String e = null ){
        super(e);
    }
}
class ClassCastException : Exception {
    this( String e = null ){
        super(e);
    }
}

interface Cloneable{
}

interface Comparable {
    int compareTo(Object o);
}
interface Comparator {
    int compare(Object o1, Object o2);
}
interface EventListener{
}

class EventObject {
    protected Object source;

    public this(Object source) {
        if (source is null)
        throw new IllegalArgumentException( "null arg" );
        this.source = source;
    }

    public Object getSource() {
        return source;
    }

    public override String toString() {
        return this.classinfo.name ~ "[source=" ~ source.toString() ~ "]";
    }
}

private struct GCStats {
    size_t poolsize;        // total size of pool
    size_t usedsize;        // bytes allocated
    size_t freeblocks;      // number of blocks marked FREE
    size_t freelistsize;    // total of memory on free lists
    size_t pageblocks;      // number of blocks marked PAGE
}
private extern(C) GCStats gc_stats();

size_t RuntimeTotalMemory(){
    GCStats s = gc_stats();
    return s.poolsize;
}

String ExceptionGetLocalizedMessage( Exception e ){
    return e.msg;
}

void ExceptionPrintStackTrace( Exception e ){
    ExceptionPrintStackTrace( e, Stderr );
}
void ExceptionPrintStackTrace( Exception e, FormatOutput!(char) print ){
    Exception exception = e;
    while( exception !is null ){
        print.formatln( "Exception in {}({}): {}", exception.file, exception.line, exception.msg );
        if( exception.info !is null ){
            foreach( msg; exception.info ){
                print.formatln( "trc {}", msg );
            }
        }
        exception = exception.next;
    }
}

class Reader{
    protected Object   lock;
    protected this(){
        implMissing(__FILE__,__LINE__);
    }
    protected this(Object lock){
        implMissing(__FILE__,__LINE__);
    }
    abstract  void  close();
    void mark(int readAheadLimit){
        implMissing(__FILE__,__LINE__);
    }
    bool markSupported(){
        implMissing(__FILE__,__LINE__);
        return false;
    }
    int read(){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
    int read(char[] cbuf){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
    abstract int read(char[] cbuf, int off, int len);
    bool ready(){
        implMissing(__FILE__,__LINE__);
        return false;
    }
    void reset(){
        implMissing(__FILE__,__LINE__);
    }
    long skip(long n){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
}
interface Writer{
}


class Collator : Comparator {
    public static Collator getInstance(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    private this(){
    }
    int compare(Object o1, Object o2){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
}

template arraycast(T) {
    T[] arraycast(U) (U[] u) {
        static if (
            (is (T == interface ) && is (U == interface )) ||
            (is (T == class ) && is (U == class ))) {
            return(cast(T[])u);
        }
        else {
            int l = u.length;
            T[] res;
            res.length = l;
            for (int i = 0; i < l; i++) {
                res[i] = cast(T)u[i];
            }
            return(res);
        }
    }
}

String stringcast( Object o ){
    if( auto str = cast(ArrayWrapperString) o ){
        return str.array;
    }
    return null;
}
String[] stringcast( Object[] objs ){
    String[] res = new String[](objs.length);
    foreach( idx, obj; objs ){
        res[idx] = stringcast(obj);
    }
    return res;
}
ArrayWrapperString stringcast( String str ){
    return new ArrayWrapperString( str );
}
ArrayWrapperString[] stringcast( String[] strs ){
    ArrayWrapperString[] res = new ArrayWrapperString[ strs.length ];
    foreach( idx, str; strs ){
        res[idx] = stringcast(str);
    }
    return res;
}

String[] stringArrayFromObject( Object obj ){
    if( auto wrapper = cast(ArrayWrapperString2)obj ){
        return wrapper.array;
    }
    if( auto wrapper = cast(ArrayWrapperObject)obj ){
        String[] res = new String[ wrapper.array.length ];
        foreach( idx, o; wrapper.array ){
            if( auto swrapper = cast(ArrayWrapperString) o ){
                res[idx] = swrapper.array;
            }
        }
        return res;
    }
    assert( obj is null ); // if not null, it was the wrong type
    return null;
}

T[] arrayFromObject(T)( Object obj ){
    if( auto wrapper = cast(ArrayWrapperObject)obj ){
        T[] res = new T[ wrapper.array.length ];
        foreach( idx, o; wrapper.array ){
            res[idx] = cast(T)o;
        }
        return res;
    }
    assert( obj is null ); // if not null, it was the wrong type
    return null;
}


bool ArrayEquals(T)( T[] a, T[] b ){
    if( a.length !is b.length ){
        return false;
    }
    for( int i = 0; i < a.length; i++ ){
        static if( is( T==class) || is(T==interface)){
            if( a[i] !is null && b[i] !is null ){
                if( a[i] != b[i] ){
                    return false;
                }
            }
            else if( a[i] is null && b[i] is null ){
            }
            else{
                return false;
            }
        }
        else{
            if( a[i] != b[i] ){
                return false;
            }
        }
    }
    return true;
}

/+int SeqIndexOf(T)( tango.util.collection.model.Seq.Seq!(T) s, T src ){
    int idx;
    foreach( e; s ){
        if( e == src ){
            return idx;
        }
        idx++;
    }
    return -1;
}+/

int arrayIndexOf(T)( T[] arr, T v ){
    int res = -1;
    int idx = 0;
    foreach( p; arr ){
        if( p == v){
            res = idx;
            break;
        }
        idx++;
    }
    return res;
}

// int seqIndexOf( tango.util.collection.model.Seq.Seq!(Object) seq, Object v ){
//     int res = -1;
//     int idx = 0;
//     foreach( p; seq ){
//         if( p == v){
//             res = idx;
//             break;
//         }
//         idx++;
//     }
//     return res;
// }

void PrintStackTrace( int deepth = 100, String prefix = "trc" ){
    auto e = new Exception( null );
    int idx = 0;
    const start = 3;
    foreach( msg; e.info ){
        if( idx >= start && idx < start+deepth ) {
            Trace.formatln( "{}: {}", prefix, msg );
        }
        idx++;
    }
}

struct ImportData{
    void[] data;
    String name;

    public static ImportData opCall( void[] data, String name ){
        ImportData res;
        res.data = data;
        res.name = name;
        return res;
    }
}

template getImportData(String name ){
    const ImportData getImportData = ImportData( cast(void[])name, name );
}

interface CharSequence {
    char           charAt(int index);
    int             length();
    CharSequence    subSequence(int start, int end);
    String          toString();
}

class StringCharSequence : CharSequence {
    private String str;
    this( String str ){
        this.str = str;
    }
    char           charAt(int index){
        return str[index];
    }
    int             length(){
        return str.length;
    }
    CharSequence    subSequence(int start, int end){
        return new StringCharSequence( str[ start .. end ]);
    }
    String          toString(){
        return str;
    }
}


