module std.stream;

/// Класс-основа для поточных исключений.
class StreamException: Exception {
  /// Конструирует StreamException с заданным сообщением об ошибке.
  this(string msg) { super(msg); }
}
//alias StreamException ИсклПотока;
/////////////////////////////////////////////////////////////////////////////////////1
/// Выводится, когда чтение данных из Потока не удается.
class ReadException: StreamException {
  /// Конструирует ReadException с заданным сообщением об ошибке.
  this(string msg) { super(msg); }
}
//alias ReadException ИсклЧтения;
///////////////////////////////////////////////////////////////////////////////////////2
/// Выводится при невозможности записать данные в Поток.
class WriteException: StreamException {
  /// Конструирует WriteException с заданным сообщением об ошибке.
  this(string msg) { super(msg); }
}
//alias WriteException ИсклЗаписи;
////////////////////////////////////////////////////////////////////////////////////////3
/// Выводится при невозможность переместить указатель Потока.
class SeekException: StreamException {
  /// Конструирует SeekException с заданным сообщением об ошибке.
  this(string msg) { super(msg); }
}
//alias SeekException ИсклПозиции;
//////////////////////////////////////////////////////////////////////////////////////////////4
// seek куда...
enum SeekPos {
  Set,
  Current,
  End,
  Уст = Set,
  Тек = Current,
  Кон = End, 
}
//alias SeekPos ПозКурсора; 

private {
  import std.format;
  import std.system;    // for Endian enumeration
  import std.intrinsic; // for bswap
  import std.utf;
  import std.stdarg;
}

version (Windows) {
  private import std.file;
}

/// InputStream - интерфейс для потоков, которые можно считывать.

//alias InputStream ПотокВвода;

interface InputStream {

//alias readExact читайРовно;
//alias read читай;
//alias readLine читайСтроку;
//alias readLineW читайШСтроку;
//alias opApply опПрименить;
//alias readString читайТекст;
//alias readStringW  читайШТекст;
//alias getc берис;
//alias getcw беришс;
//alias ungetc отдайс;
//alias ungetcw отдайшс;
//alias vreadf вчитайф;
//alias readf читайф;
//alias available доступно;
//alias isOpen открыт_ли;
  /***
   * Считать в буфер точно указанный размер байтов.
   *
   * Выводит ReadException, если размер не точен.
   */
  void readExact(void* buffer, size_t size);
////alias readExact читайРовно;
  /***
   * Считать блок данных, которого хватает для заполнения данного буфера массива.
   *
   * Возвращает: число действительно считанных байтов. Незаполненные байты остаются без изменения. 
   */
  size_t read(ubyte[] buffer);
  

  /***
   * Считать основной тип или подсчитанную строку.
   *
   * Выводит ReadException, если чтение невозможно.
   * Вне byte, ubyte и char данный формат зависит от
   * реализации, и не должен использоваться, кроме как 
   * для записи противоположных действий.
   */
  void read(out byte x);
  void read(out ubyte x);	/// ditto
  void read(out short x);	/// ditto
  void read(out ushort x);	/// ditto
  void read(out int x);		/// ditto
  void read(out uint x);	/// ditto
  void read(out long x);	/// ditto
  void read(out ulong x);	/// ditto
  void read(out float x);	/// ditto
  void read(out double x);	/// ditto
  void read(out real x);	/// ditto
  void read(out ifloat x);	/// ditto
  void read(out idouble x);	/// ditto
  void read(out ireal x);	/// ditto
  void read(out cfloat x);	/// ditto
  void read(out cdouble x);	/// ditto
  void read(out creal x);	/// ditto
  void read(out char x);	/// ditto
  void read(out wchar x);	/// ditto
  void read(out dchar x);	/// ditto

  // считывает строку, записаную до этога write()
  void read(out char[] s);	/// ditto

  // считывает строку Unicode, ранее записанную write()
  void read(out wchar[] s);	/// ditto
////alias read читай;
  /***
   * Считывает строку, завершающуюся на сочетание из знаков возврата каретки и
   * запитки строки, или конца файла(end-of-file).
   *
   * Оканчивающие коды не включаются. Версия wchar 
   * аналогична. The optional buffer parameter is filled (reallocating
   * it if necessary) and a slice of the result is returned. 
   */
  char[] readLine();  
  char[] readLine(char[] result);	/// ditto
  wchar[] readLineW();			/// ditto
  wchar[] readLineW(wchar[] result);	/// ditto
  ////alias readLine читайСтр;
  ////alias readLineW читайСтрШ;
  	
  /***
   * Overload foreach statements to read the stream line by line and call the
   * supplied delegate with each line or with each line with line number.
   *
   * The string passed in line may be reused between calls to the delegate.
   * Line numbering starts at 1.
   * Breaking out of the foreach will leave the stream
   * position at the beginning of the next line to be read.
   * For example, to echo a file line-by-line with line numbers run:
   * ------------------------------------
   * Stream file = new BufferedFile("sample.txt");
   * foreach(ulong n, string line; file) {
   *   stdout.writefln("line %d: %s",n,line);
   * }
   * file.close();
   * ------------------------------------
   */

  // iterate through the stream line-by-line
  int opApply(int delegate(inout char[] line) dg);
  int opApply(int delegate(inout ulong n, inout char[] line) dg);  /// ditto
  int opApply(int delegate(inout wchar[] line) dg);		   /// ditto
  int opApply(int delegate(inout ulong n, inout wchar[] line) dg); /// ditto

  /// Read a string of the given length,
  /// throwing ReadException if there was a problem.
  char[] readString(size_t length);

  /***
   * Read a string of the given length, throwing ReadException if there was a
   * problem.
   *
   * The file format is implementation-specific and should not be used
   * except as opposite actions to <b>write</b>.
   */

  wchar[] readStringW(size_t length);

   ////alias readLine читайТкст;
   ////alias readLineW читайТкстШ;
  /***
   * Read and return the next character in the stream.
   *
   * This is the only method that will handle ungetc properly.
   * getcw's format is implementation-specific.
   * If EOF is reached then getc returns char.init and getcw returns wchar.init.
   */

  char getc();
  ////alias getc извлс;
  
  wchar getcw(); /// ditto
  ////alias getcw извлш;

  /***
   * Push a character back onto the stream.
   *
   * They will be returned in first-in last-out order from getc/getcw.
   * Only has effect on further calls to getc() and getcw().
   */
  char ungetc(char c);
  ////alias ungetc отдайс;
  
  wchar ungetcw(wchar c); /// ditto
  ////alias ungetcw отдайш;

  /***
   * Scan a string from the input using a similar form to C's scanf
   * and <a href="std_format.html">std.format</a>.
   *
   * An argument of type string is interpreted as a format string.
   * All other arguments must be pointer types.
   * If a format string is not present a default will be supplied computed from
   * the base type of the pointer type. An argument of type string* is filled
   * (possibly with appending characters) and a slice of the result is assigned
   * back into the argument. For example the following readf statements
   * are equivalent:
   * --------------------------
   * int x;
   * double y;
   * string s;
   * file.readf(&x, " hello ", &y, &s);
   * file.readf("%d hello %f %s", &x, &y, &s);
   * file.readf("%d hello %f", &x, &y, "%s", &s);
   * --------------------------
   */
  int vreadf(TypeInfo[] arguments, void* args);
  ////alias vreadf вчитайф;
  
  int readf(...); /// ditto
  ////alias readf читайф;

  /// Retrieve the number of bytes available for immediate reading.
  size_t available();
  ////alias available сколькоб;

  /***
   * Return whether the current file position то же самое, что the end of the
   * file.
   *
   * This does not require actually reading past the end, as with stdio. For
   * non-seekable streams this might only return true after attempting to read
   * past the end.
   */

  bool eof();
  ////alias eof кф_ли;

  bool isOpen();	/// Return true if the stream is currently open.
  ////alias isOpen открыт_ли;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////5
/// Interface for writable streams.
//alias OutputStream ПотокВывода;

interface OutputStream {

//alias writeExact пишиРовно;
//alias write пиши;
//alias writeLine пишиСтроку;
//alias writeLineW пишиШСтроку;
//alias writeString пишиТекст;
//alias writeStringW пишиШТекст;
//alias vprintf ввыводф;
//alias printf выводф;
//alias writef пишиф;
//alias writefln пишифнс;
//alias writefx пишификс;
//alias flush слей;
//alias close закрой;
//alias isOpen открыт_ли;
  /***
   * Write exactly size bytes from buffer, or throw a WriteException if that
   * could not be done.
   */
  void writeExact(void* buffer, size_t size);
  ////alias writeExact пишиРовно;
  /***
   * Write as much of the buffer as possible,
   * returning the number of bytes written.
   */
  size_t write(ubyte[] buffer);

  /***
   * Write a basic type.
   *
   * Outside of byte, ubyte, and char, the format is implementation-specific
   * and should only be used in conjunction with read.
   * Throw WriteException on error.
   */
  void write(byte x);
  void write(ubyte x);		/// ditto
  void write(short x);		/// ditto
  void write(ushort x);		/// ditto
  void write(int x);		/// ditto
  void write(uint x);		/// ditto
  void write(long x);		/// ditto
  void write(ulong x);		/// ditto
  void write(float x);		/// ditto
  void write(double x);		/// ditto
  void write(real x);		/// ditto
  void write(ifloat x);		/// ditto
  void write(idouble x);	/// ditto
  void write(ireal x);		/// ditto
  void write(cfloat x);		/// ditto
  void write(cdouble x);	/// ditto
  void write(creal x);		/// ditto
  void write(char x);		/// ditto
  void write(wchar x);		/// ditto
  void write(dchar x);		/// ditto  
  /***
   * Writes a string, together with its length.
   *
   * The format is implementation-specific
   * and should only be used in conjunction with read.
   * Throw WriteException on error.
   */
  void write(char[] s);
  void write(wchar[] s);	/// ditto
	////alias write пиши;
  /***
   * Write a line of text,
   * appending the line with an operating-system-specific line ending.
   *
   * Throws WriteException on error.
   */
  void writeLine(char[] s);
	////alias writeLine пишиСтроку;
  /***
   * Write a line of text,
   * appending the line with an operating-system-specific line ending.
   *
   * The format is implementation-specific.
   * Throws WriteException on error.
   */
  void writeLineW(wchar[] s);
 ////alias writeLineW пишиШСтроку;
  /***
   * Write a string of text.
   *
   * Throws WriteException if it could not be fully written.
   */
  void writeString(char[] s);
  ////alias writeString пишиТекст;
  /***
   * Write a string of text.
   *
   * The format is implementation-specific.
   * Throws WriteException if it could not be fully written.
   */
  void writeStringW(wchar[] s);
  ////alias writeStringW пишиШТекст;
  
  /***
   * Print a formatted string into the stream using printf-style syntax,
   * returning the number of bytes written.
   */
  size_t vprintf(char[] format, va_list args);
  ////alias vprintf ввыводф;
  size_t printf(char[] format, ...);	/// ditto
  ////alias printf выводф;

  /***
   * Print a formatted string into the stream using writef-style syntax.
   * Ссылки: <a href="std_format.html">std.format</a>.
   * Возвращает: self to chain with other stream commands like flush.
   */
  OutputStream writef(...);
  ////alias writef пишиф;
  
  OutputStream writefln(...); /// ditto
  ////alias writefln пишифнс;
  
  OutputStream writefx(TypeInfo[] arguments, void* argptr, int newline = false);  /// ditto
  ////alias writefx пишификс;

  void flush();	/// Flush pending output if appropriate.
  ////alias flush слей;
  
  void close(); /// Close the stream, flushing output if appropriate.
  ////alias close закрой;
  
  bool isOpen(); /// Return true if the stream is currently open.
  ////alias isOpen открыт_ли;
}


/***
 * Stream -это абстрактный класс-основа, от которого происходят другие классы-потоки.
 * 
 * Stream's byte order is the format c to the computer.
 *
 * Reading:
 * These methods require that the readable flag be set.
 * Problems with reading result in a ReadException being thrown.
 * Stream implements the InputStream interface in addition to the
 * readBlock method.
 *
 * Writing:
 * These methods require that the writeable flag be set. Problems with writing
 * result in a WriteException being thrown. Stream implements the OutputStream
 * interface in addition to the following methods:
 * writeBlock
 * copyFrom
 * copyFrom
 *
 * Seeking:
 * These methods require that the seekable flag be set.
 * Problems with seeking result in a SeekException being thrown.
 * seek, seekSet, seekCur, seekEnd, position, size, toString, toHash
 */
////////////////////////////////////////////////////////////////////////////////////////6
// not really abstract, but its instances will do nothing useful
//alias Stream Поток;

class Stream : InputStream, OutputStream {
  private import std.string, crc32, std.c;

  // stream abilities
  bool readable = false;	/// Indicates whether this stream can be read from.
  bool writeable = false;	/// Indicates whether this stream can be written to.
  bool seekable = false;	/// Indicates whether this stream can be seeked within.
  protected bool isopen = true;	/// Indicates whether this stream is open.

  protected bool readEOF = false; /** Indicates whether this stream is at eof
				   * after the last read attempt.
				   */

  protected bool prevCr = false; /** For a non-seekable stream indicates that
				  * the last readLine or readLineW ended on a
				  * '\r' character. 
				  */
				  
//alias readable читаемый;
//alias writeable записываемый;
//alias seekable сканируемый;
//alias isopen открытый;
//alias readEOF читайдокф;
//alias prevCr передВкар;
//alias readExact читайРовно;
 //alias read читай;
 //alias readLine читайСтроку;
 //alias readLineW читайШСтроку;
 //alias opApply опПрименить;
 //alias ungetAvailable верниЧтоЕсть;
 //alias getc берис;
 //alias getcw бериш;
 //alias unget отдай;
 //alias ungetc отдайс; 
 //alias ungetcw отдайш;
//alias vreadf вчитайф;
//alias readf читайф;
//alias available доступно;
//alias writeExact пишиРовно;
//alias write пиши;
//alias writeLine пишиСтроку;
//alias writeLineW пишиШСтроку;
//alias writeString пишиТекст;
//alias writeStringW пишиШТекст;
//alias vprintf ввыводф;
//alias printf выводф;
//alias writef пишиф;
//alias writefln пишифнс;
//alias writefx пишификс;
//alias copyFrom копируйИз;
//alias seek сместись;
//alias seekSet измпозУст;
//alias seekCur измпозТек;
//alias seekEnd измпозКон;
//alias position позиция;
//alias eof кф;
//alias isOpen открыт_ли;
//alias close закрой;
//alias flush слей;

  this();

  /***
   * Read up to size bytes into the buffer and return the number of bytes
   * actually read. A return value of 0 indicates end-of-file.
   */
  abstract size_t readBlock(void* buffer, size_t size);
	
  // reads block of data of specified size,
  // throws ReadException on error
  void readExact(void* buffer, size_t size);
	
  // reads block of data big enough to fill the given
  // array, returns actual number of bytes read
  size_t read(ubyte[] buffer);

  // read a single value of desired type,
  // throw ReadException on error
  void read(out byte x);
  void read(out ubyte x);
  void read(out short x) ;
  void read(out ushort x) ;
  void read(out int x) ;
  void read(out uint x) ;
  void read(out long x) ;
  void read(out ulong x) ;
  void read(out float x) ;
  void read(out double x) ;
  void read(out real x) ;
  void read(out ifloat x) ;
  void read(out idouble x) ;
  void read(out ireal x) ;
  void read(out cfloat x) ;
  void read(out cdouble x) ;
  void read(out creal x) ;
  void read(out char x) ;
  void read(out wchar x) ;
  void read(out dchar x) ;

  // reads a string, written earlier by write()
  void read(out char[] s);

  // reads a Unicode string, written earlier by write()
  void read(out wchar[] s);
  
  // reads a line, terminated by either CR, LF, CR/LF, or EOF
  char[] readLine() ;

  // reads a line, terminated by either CR, LF, CR/LF, or EOF
  // reusing the memory in buffer if result will fit and otherwise
  // allocates a new string
  char[] readLine(char[] result);
	
  // reads a Unicode line, terminated by either CR, LF, CR/LF,
  // or EOF; pretty much the same as the above, working with
  // wchars rather than chars
  wchar[] readLineW();
  // reads a Unicode line, terminated by either CR, LF, CR/LF,
  // or EOF;
  // fills supplied buffer if line fits and otherwise allocates a new string.
  wchar[] readLineW(wchar[] result);
    

  // iterate through the stream line-by-line - due to Regan Heath
  int opApply(int delegate(inout char[] line) dg) ;

  // iterate through the stream line-by-line with line count and string
  int opApply(int delegate(inout ulong n, inout char[] line) dg);

  // iterate through the stream line-by-line with wchar[]
  int opApply(int delegate(inout wchar[] line) dg) ;

  // iterate through the stream line-by-line with line count and wchar[]
  int opApply(int delegate(inout ulong n, inout wchar[] line) dg) ;

  // reads a string of given length, throws
  // ReadException on error
  char[] readString(size_t length) ;

  // reads a Unicode string of given length, throws
  // ReadException on error
  wchar[] readStringW(size_t length) ;

  // unget buffer
  private wchar[] unget();
  
  
  final bool ungetAvailable() ;
  
  // reads and returns next character from the stream,
  // handles characters pushed back by ungetc()
  // returns char.init on eof.
  char getc();
  

  // reads and returns next Unicode character from the
  // stream, handles characters pushed back by ungetc()
  // returns wchar.init on eof.
  wchar getcw() ;
  
  // pushes back character c into the stream; only has
  // effect on further calls to getc() and getcw()
  char ungetc(char c) ;
  
  // pushes back Unicode character c into the stream; only
  // has effect on further calls to getc() and getcw()
  wchar ungetcw(wchar c) ;
 
 
  int vreadf(TypeInfo[] arguments, void* args) ;
	
	
  int readf(...) ;
	
	
  // returns estimated number of bytes available for immediate reading
  size_t available() ;
	
  /***
   * Write up to size bytes from buffer in the stream, returning the actual
   * number of bytes that were written.
   */
  abstract size_t writeBlock(void* buffer, size_t size);

  // writes block of data of specified size,
  // throws WriteException on error
  void writeExact(void* buffer, size_t size);
   
  // writes the given array of bytes, returns
  // actual number of bytes written
  size_t write(ubyte[] buffer);

  // write a single value of desired type,
  // throw WriteException on error
  void write(byte x) ;
  void write(ubyte x) ;
  void write(short x) ;
  void write(ushort x) ;
  void write(int x) ;
  void write(uint x) ;
  void write(long x) ;
  void write(ulong x) ;
  void write(float x) ;
  void write(double x) ;
  void write(real x) ;
  void write(ifloat x) ;
  void write(idouble x) ;
  void write(ireal x) ;
  void write(cfloat x) ;
  void write(cdouble x) ;
  void write(creal x) ;
  void write(char x) ;
  void write(wchar x) ;
  void write(dchar x) ;

  // writes a string, together with its length
  void write(char[] s) ;

  // writes a Unicode string, together with its length
  void write(wchar[] s) ;
	
	
  // writes a line, throws WriteException on error
  void writeLine(char[] s) ;
 
 
  // writes a Unicode line, throws WriteException on error
  void writeLineW(wchar[] s) ;

  // writes a string, throws WriteException on error
  void writeString(char[] s) ;
	
	
  // writes a Unicode string, throws WriteException on error
  void writeStringW(wchar[] s);
	
  // writes data to stream using vprintf() syntax,
  // returns number of bytes written
  size_t vprintf(char[] format, va_list args);

  // writes data to stream using printf() syntax,
  // returns number of bytes written
  size_t printf(char[] format, ...);


  private void doFormatCallback(dchar c);

  // writes data to stream using writef() syntax,
  OutputStream writef(...) ;

  // writes data with trailing newline
  OutputStream writefln(...) ;

  // writes data with optional trailing newline
  OutputStream writefx(TypeInfo[] arguments, void* argptr, int newline=false);

  /***
   * Copies all data from s into this stream.
   * This may throw ReadException or WriteException on failure.
   * This restores the file position of s so that it is unchanged.
   */
  void copyFrom(Stream s);

  /***
   * Copy a specified number of bytes from the given stream into this one.
   * This may throw ReadException or WriteException on failure.
   * Unlike the previous form, this doesn't restore the file position of s.
   */
  void copyFrom(Stream s, ulong count);

  /***
   * Change the current position of the stream. куда is either SeekPos.Set, in
   which case the offset is an absolute index from the beginning of the stream,
   SeekPos.Current, in which case the offset is a delta from the current
   position, or SeekPos.End, in which case the offset is a delta from the end of
   the stream (negative or zero offsets only make sense in that case). This
   returns the new file position.
   */
  abstract ulong seek(long offset, SeekPos куда);


  /***
   * Aliases for their normal seek counterparts.
   */
  ulong seekSet(long offset) ;
  
  
  ulong seekCur(long offset) ;
  
  
  ulong seekEnd(long offset) ;
  

  /***
   * Sets file position. Equivalent to calling seek(pos, SeekPos.Set).
   */
  void position(ulong pos) ;

  /***
   * Returns current file position. Equivalent to seek(0, SeekPos.Current).
   */
  ulong position() ;
 
  /***
   * Retrieve the size of the stream in bytes.
   * The stream must be seekable or a SeekException is thrown.
   */
  ulong size() ;


  // returns true if end of stream is reached, false otherwise
  bool eof() ;


  // returns true if the stream is open
  bool isOpen() ;

  // flush the buffer if writeable
  void flush() ;


  // close the stream somehow; the default just flushes the buffer
  void close();

  /***
   * Read the entire stream and return it as a string.
   * If the stream is not seekable the contents from the current position to eof
   * is read and returned.
   */
  override string toString() ;
	
  /***
   * Get a hash of the stream by reading each byte and using it in a CRC-32
   * checksum.
   */
  override size_t toHash();
  // helper for checking that the stream is readable
  final protected void assertReadable() ;
  // helper for checking that the stream is writeable
  final protected void assertWriteable();
  // helper for checking that the stream is seekable
  final protected void assertSeekable() ;
}

/***
 * A base class for streams that wrap a source stream with additional
 * functionality.
 *
 * The method implementations forward read/write/seek calls to the
 * source stream. A FilterStream can change the position of the source stream
 * arbitrarily and may not keep the source stream state in sync with the
 * FilterStream, even upon flushing and closing the FilterStream. It is
 * recommended to not make any assumptions about the state of the source position
 * and read/write state after a FilterStream has acted upon it. Specifc subclasses
 * of FilterStream should document how they modify the source stream and if any
 * invariants hold true between the source and filter.
 */
 //alias FilterStream ПотокФильтр;
 
class FilterStream : Stream {

//alias source исток;
//alias resetSource сбросьИсток;
//alias readBlock читайБлок;
//alias writeBlock пишиБлок;
//alias close закрой;
//alias seek сместись;
//alias available доступно;
//alias flush слей; 

  private Stream s;              // source stream

  /// Property indicating when this stream closes to close the source stream as
  /// well.
  /// Defaults to true.
  bool nestClose = true;

  /// Construct a FilterStream for the given source.
  this(Stream source);

  // source getter/setter

  /***
   * Get the current source stream.
   */
  final Stream source();

  /***
   * Set the current source stream.
   *
   * Setting the source stream closes this stream before attaching the new
   * source. Attaching an open stream reopens this stream and resets the stream
   * state. 
   */
  void source(Stream s) ;

  /***
   * Indicates the source stream changed state and that this stream should reset
   * any readable, writeable, seekable, isopen and buffering flags.
   */
  void resetSource() ;

  // read from source
  size_t readBlock(void* buffer, size_t size);

  // write to source
  size_t writeBlock(void* buffer, size_t size);

  // close stream
  override void close();

  // seek on source
  override ulong seek(long offset, SeekPos куда) ;


  override size_t available () ;
 
  
  override void flush() ;

}

/***
 * This subclass is for buffering a source stream.
 *
 * A buffered stream must be
 * closed explicitly to ensure the final buffer content is written to the source
 * stream. The source stream position is changed according to the block size so
 * reading or writing to the BufferedStream may not change the source stream
 * position by the same amount.
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////
//alias BufferedStream БуферируемыйПоток;

class BufferedStream : FilterStream
{

 //alias buffer буфер;
  //alias bufferLen длинаБуф;
    //alias bufferDirty черновойБуф;
//alias bufferSourcePos позИстокаБуф;
//alias streamPos позПотока;
//alias bufferCurPos текБуфПоз; 
//alias DefaultBufferSize ДефРазмБуфера;
//alias resetSource сбросьИсток;
//alias readBlock читайБлок;
//alias writeBlock пишиБлок;
//alias TreadLine ТчитайСтроку;
//alias readLine читайСтроку;
//alias readLineW читайШСтроку;
//alias flush слей;
//alias eof кф;
//alias size размер;
//alias available доступно;
//alias seek сместись;

  ubyte[] buffer;       // buffer, if any  
  uint bufferCurPos;    // current position in buffer
  uint bufferLen;       // amount of data in buffer
  bool bufferDirty = false;
  uint bufferSourcePos; // position in buffer of source stream position
  ulong streamPos;      // absolute position in source stream
  

  /* Example of relationship between fields:
   *
   *  s             ...01234567890123456789012EOF
   *  buffer                |--                     --|
   *  bufferCurPos                       |
   *  bufferLen             |--            --|
   *  bufferSourcePos                        |
   *
   */

  invariant() {
    assert(bufferSourcePos <= bufferLen);
    assert(bufferCurPos <= bufferLen);
    assert(bufferLen <= buffer.length);
  }

  const uint DefaultBufferSize = 8192;

  /***
   * Create a buffered stream for the stream source with the buffer size
   * bufferSize.
   */
  this(Stream source, uint bufferSize = DefaultBufferSize) ;

  protected void resetSource() ;

  // reads block of data of specified size using any buffered data
  // returns actual number of bytes read
  override size_t readBlock(void* result, size_t len) ;

  // write block of data of specified size
  // returns actual number of bytes written
  override size_t writeBlock(void* result, size_t len) ;
  
  override ulong seek(long offset, SeekPos куда);

  // Buffered readLine - Dave Fladebo
  // reads a line, terminated by either CR, LF, CR/LF, or EOF
  // reusing the memory in buffer if result will fit, otherwise
  // will reallocate (using concatenation)
  template TreadLine(T) {
    T[] readLine(T[] inBuffer)
      {
	size_t    lineSize = 0;
	bool    haveCR = false;
	T       c = '\0';
	size_t    idx = 0;
	ubyte*  pc = cast(ubyte*)&c;

      L0:
	for(;;) {
	  uint start = bufferCurPos;
	L1:
	  foreach(ubyte b; buffer[start .. bufferLen]) {
	    bufferCurPos++;
	    pc[idx] = b;
	    if(idx < T.sizeof - 1) {
	      idx++;
	      continue L1;
	    } else {
	      idx = 0;
	    }
	    if(c == '\n' || haveCR) {
	      if(haveCR && c != '\n') bufferCurPos--;
	      break L0;
	    } else {
	      if(c == '\r') {
		haveCR = true;
	      } else {
		if(lineSize < inBuffer.length) {
		  inBuffer[lineSize] = c;
		} else {
		  inBuffer ~= c;
		}
		lineSize++;
	      }
	    }
	  }
	  flush();
	  size_t res = super.readBlock(buffer.ptr, buffer.length);
	  if(!res) break L0; // EOF
	  bufferSourcePos = bufferLen = res;
	  streamPos += res;
	}

	return inBuffer[0 .. lineSize];
      }
  } // template TreadLine(T)
  
  //alias TreadLine читСтрТ;
  
  override char[] readLine(char[] inBuffer);
  
  //alias Stream.readLine readLine;

  override wchar[] readLineW(wchar[] inBuffer) ;
  
  //alias Stream.readLineW readLineW;

  override void flush();
  
  // returns true if end of stream is reached, false otherwise
  override bool eof();
  // returns size of stream
  ulong size();

  // returns estimated number of bytes available for immediate reading
  size_t available();
}
//////////////////////////////////////////////////////////////////////////////////////////
/// An exception for File errors.
class StreamFileException: StreamException {
  /// Construct a StreamFileException with given error message.
  this(string msg) { super(msg); }
}
//alias StreamFileException ИсклФПотока;
////////////////////////////////////////////////////////////////////////////////////////////
/// An exception for errors during File.open.
class OpenException: StreamFileException {
  /// Construct an OpenFileException with given error message.
  this(string msg) { super(msg); }
}
//alias OpenException ИсклОткрытия;
////////////////////////////////////////////////////////////////////////////////////////////
// access modes; may be or'ed
enum FileMode {
  In = 1,
  Out = 2,
  OutNew = 6, // includes FileMode.Out
  Append = 10, // includes FileMode.Out
   Ввод = In,
  Вывод = Out,
  ВыводНов = OutNew,
  Добавка = Append
}
//alias FileMode ФРежим; 


version (Win32) {
  private import os.windows;
  extern (Windows) {
    void FlushFileBuffers(HANDLE hFile);
	//alias FlushFileBuffers СлитьФБуферы;
	
    DWORD  GetFileType(HANDLE hFile);
	//alias GetFileType ПолФТип;
  }
}
version (Posix) {
  private import os.posix;
  //alias int HANDLE;
}
/////////////////////////////////////////////////////////////////////////////////////////////
/// This subclass is for unbuffered file system streams.
//alias File Файл;

class File: Stream {

//alias open открой;
//alias create создай;
//alias close закрой;
//alias readBlock читайБлок;
//alias writeBlock  пишиБлок;
//alias seek сместись;
//alias available доступно;
//alias handle хэндл;

  
    private HANDLE hFile;
  

  this() ;

  // opens existing handle; use with care!
  this(HANDLE hFile, FileMode mode);
  

  /***
   * Create the stream with no open file, an open file in read mode, or an open
   * file with explicit file mode.
   * mode, if given, is a combination of FileMode.In
   * (indicating a file that can be read) and FileMode.Out (indicating a file
   * that can be written).
   * Opening a file for reading that doesn't exist will error.
   * Opening a file for writing that doesn't exist will create the file.
   * The FileMode.OutNew mode will open the file for writing and reset the
   * length to zero.
   * The FileMode.Append mode will open the file for writing and move the
   * file position to the end of the file.
   */
  this(string filename, FileMode mode = FileMode.In);


  /***
   * Open a file for the stream, in an identical manner to the constructors.
   * If an error occurs an OpenException is thrown.
   */
  void open(string filename, FileMode mode = FileMode.In);


  private void parseMode(int mode,
			 out int access,
			 out int share,
			 out int createMode);			 
	

  /// Create a file for writing.
  void create(string filename);

  /// ditto
  void create(string filename, FileMode mode) ;

  /// Close the current file if it is open; otherwise it does nothing.
  override void close();

  // destructor, closes file if still opened
  ~this();
  
    // returns size of stream
    ulong size() ;

  override size_t readBlock(void* buffer, size_t size) ;
  override size_t writeBlock(void* buffer, size_t size);

  override ulong seek(long offset, SeekPos rel);

  /***
   * For a seekable file returns the difference of the size and position and
   * otherwise returns 0.
   */

  override size_t available();

  // OS-specific property, just in case somebody wants
  // to mess with underlying API
  HANDLE handle() ;
 
  // run a few tests
}


/***
 * This subclass is for buffered file system streams.
 *
 * It is a convenience class for wrapping a File in a BufferedStream.
 * A buffered stream must be closed explicitly to ensure the final buffer
 * content is written to the file.
 */
  //alias BufferedFile БуферируемыйФайл;
  
class BufferedFile: BufferedStream 
{

//alias open открой;
//alias create создай;

  /// opens file for reading
  this();

  /// opens file in requested mode and buffer size
  this(string filename, FileMode mode = FileMode.In,
       uint bufferSize = DefaultBufferSize);
  /// opens file for reading with requested buffer size
  this(File file, uint bufferSize = DefaultBufferSize) ;

  /// opens existing handle; use with care!
  this(HANDLE hFile, FileMode mode, uint buffersize);

  /// opens file in requested mode
  void open(string filename, FileMode mode = FileMode.In);

  /// creates file in requested mode
  void create(string filename, FileMode mode = FileMode.OutNew) ;

}



/// UTF byte-order-mark signatures 
enum BOM {
	UTF8,		/// UTF-8
	UTF16LE,	/// UTF-16 Little Endian
	UTF16BE,	/// UTF-16 Big Endian
	UTF32LE,	/// UTF-32 Little Endian
	UTF32BE,	/// UTF-32 Big Endian
}
//alias BOM МПБ; //МПБ -Метка Порядка Байтов;


private const int NBOMS = 5;
Endian[NBOMS] BOMEndian = 
[ std.system.endian, 
  Endian.LittleEndian, Endian.BigEndian,
  Endian.LittleEndian, Endian.BigEndian
  ];

ubyte[][NBOMS] ByteOrderMarks = 
[ [0xEF, 0xBB, 0xBF],
  [0xFF, 0xFE],
  [0xFE, 0xFF],
  [0xFF, 0xFE, 0x00, 0x00],
  [0x00, 0x00, 0xFE, 0xFF]
  ];


/***
 * This subclass wraps a stream with big-endian or little-endian byte order
 * swapping.
 *
 * UTF Byte-Order-Mark (BOM) signatures can be read and deduced or
 * written.
 * Note that an EndianStream should not be used as the source of another
 * FilterStream since a FilterStream call the source with byte-oriented
 * read/write requests and the EndianStream will not perform any byte swapping.
 * The EndianStream reads and writes binary data (non-getc functions) in a
 * one-to-one
 * manner with the source stream so the source stream's position and state will be
 * kept in sync with the EndianStream if only non-getc functions are called.
 */
//alias EndianStream ПБПоток; //Поток с Порядком Байтов
class EndianStream : FilterStream {

//alias endian байтП;
 //alias readBOM читайМПБ;
  //alias fixBO фиксируйПБ;
 //alias fixBlockBO фиксируйБлокПБ;
 //alias read читай;
 //alias getcw берисш;
 //alias readStringW читайШТекст;
 //alias writeBOM читайМПБ;
 //alias write пиши;
 //alias writeStringW пишиШТекст;
 //alias eof кф;
 //alias size размер;
 
 
  Endian endian;        /// Endianness property of the source stream.

  /***
   * Create the endian stream for the source stream source with endianness end.
   * The default endianness is the c byte order.
   * The Endian type is defined
   * in the std.system module.
   */
  this(Stream source, Endian end = std.system.endian) ;

  /***
   * Return -1 if no BOM and otherwise read the BOM and return it.
   *
   * If there is no BOM or if bytes beyond the BOM are read then the bytes read
   * are pushed back onto the ungetc buffer or ungetcw buffer.
   * Pass ungetCharSize == 2 to use
   * ungetcw instead of ungetc when no BOM is present.
   */
  int readBOM(int ungetCharSize = 1);

  /***
   * Correct the byte order of buffer to match c endianness.
   * size must be even.
   */
  final void fixBO(void* buffer, uint size);
 

  /***
   * Correct the byte order of the given buffer in blocks of the given size and
   * repeated the given number of times.
   * size must be even.
   */
  final void fixBlockBO(void* buffer, uint size, size_t repeat);
  

  override void read(out byte x) ;
  override void read(out ubyte x) ;
  void read(out short x) ;
  void read(out ushort x) ;
  void read(out int x) ;
  void read(out uint x) ;
  void read(out long x) ;
  void read(out ulong x) ;
  void read(out float x) ;
  void read(out double x) ;
  void read(out real x) ;
  void read(out ifloat x) ;
  void read(out idouble x) ;
  void read(out ireal x) ;
  void read(out cfloat x) ;
  void read(out cdouble x) ;
  void read(out creal x) ;
  void read(out wchar x) ;
  void read(out dchar x) ;

  wchar getcw();

  wchar[] readStringW(size_t length);

  /// Write the specified BOM b to the source stream.
  void writeBOM(BOM b);

  override void write(byte x) ;
  override void write(ubyte x) ;
  void write(short x) ;
  void write(ushort x) ;
  void write(int x) ;
  void write(uint x) ;
  void write(long x) ;
  void write(ulong x) ;
  void write(float x) ;
  void write(double x) ;
  void write(real x) ;
  void write(ifloat x) ;
  void write(idouble x) ;
  void write(ireal x) ;
  void write(cfloat x) ;
  void write(cdouble x) ;
  void write(creal x) ;
  void write(wchar x) ;
  void write(dchar x) ;

  void writeStringW(wchar[] str) ;

  override bool eof() ;
  override ulong size() ;
}

/***
 * Parameterized subclass that wraps an array-like buffer with a stream
 * interface.
 *
 * The type Buffer must support the length property, opIndex and opSlice.
 * Compile in release mode when directly instantiating a TArrayStream to avoid
 * link errors.
 */

 //alias TArrayStream ТПотокМассив;
 
class TArrayStream(Buffer): Stream {

//alias buf буф;
//alias len длин;
//alias cur тек;
//alias readBlock читайБлок;
//alias writeBlock пишиБлок;
//alias seek сместись;
//alias available доступно;
//alias toString вТкст;

  Buffer buf; // current data  
  ulong len;  // current data length  
  ulong cur;  // current file position
  

  /// Create the stream for the the buffer buf. Non-copying.
  this(Buffer buf) ;

  // ensure subclasses don't violate this
  invariant() {
    assert(len <= buf.length);
    assert(cur <= len);
  }

  override size_t readBlock(void* buffer, size_t size) ;
  override size_t writeBlock(void* buffer, size_t size);

  override ulong seek(long offset, SeekPos rel) ;


  override size_t available () ;

  /// Get the current memory data in total.
  ubyte[] data() ;
  //alias data данные;

  override string toString() ;
}


/* Test the TArrayStream */
unittest {
  char[100] buf;
  TArrayStream!(char[]) m;

  m = new TArrayStream!(char[]) (buf);
  assert (m.isOpen);
  m.writeString ("Hello, world");
  assert (m.position () == 12);
  assert (m.available == 88);
  assert (m.seekSet (0) == 0);
  assert (m.available == 100);
  assert (m.seekCur (4) == 4);
  assert (m.available == 96);
  assert (m.seekEnd (-8) == 92);
  assert (m.available == 8);
  assert (m.size () == 100);
  assert (m.seekSet (4) == 4);
  assert (m.readString (4) == "o, w");
  m.writeString ("ie");
  assert (buf[0..12] == "Hello, wield");
  assert (m.position == 10);
  assert (m.available == 90);
  assert (m.size () == 100);
}

/// This subclass reads and constructs an array of bytes in memory.
//alias MemoryStream ПотокПамяти;
class MemoryStream: TArrayStream!(ubyte[]) {

//alias reserve резервируй;
//alias writeBlock пишиБлок;

  /// Create the output buffer and setup for reading, writing, and seeking.
  // clear to an empty buffer.
  this();

  /***
   * Create the output buffer and setup for reading, writing, and seeking.
   * Load it with specific input data.
   */
  this(ubyte[] buf);
  this(byte[] buf);
  this(char[] buf);

  /// Ensure the stream can hold count bytes.
  void reserve(size_t count);

  override size_t writeBlock(void* buffer, size_t size) ;
}

import std.mmfile;

/***
 * This subclass wraps a memory-mapped file with the stream API.
 * See std.mmfile module.
 */
 
//alias MmFileStream  РПФПоток; //РПФ -Размещенный в Памяти Файл

class MmFileStream : TArrayStream!(MmFile) {

//alias flush слей;
//alias close закрой;

  /// Create stream wrapper for file.
  this(MmFile file);

  override void flush() ;

  override void close() ;
}

/***
 * This subclass slices off a portion of another stream, making seeking relative
 * to the boundaries of the slice.
 *
 * It could be used to section a large file into a
 * set of smaller files, such as with tar archives. Reading and writing a
 * SliceStream does not modify the position of the source stream if it is
 * seekable.
 */
 //alias SliceStream ПотокСрез;
 
class SliceStream : FilterStream {

//alias readBlock читайБлок;
//alias writeBlock пишиБлок;
//alias seek сместись;
//alias available доступно;

  private {
    ulong pos;  // our position relative to low
    ulong low; // low stream offset.
    ulong high; // high stream offset.
    bool bounded; // upper-bounded by high.
  }

  /***
   * Indicate both the source stream to use for reading from and the low part of
   * the slice.
   *
   * The high part of the slice is dependent upon the end of the source
   * stream, so that if you write beyond the end it resizes the stream normally.
   */
  this (Stream s, ulong low);

  /***
   * Indicate the high index as well.
   *
   * Attempting to read or write past the high
   * index results in the end being clipped off.
   */
  this (Stream s, ulong low, ulong high);

  invariant() {
    if (bounded)
      assert (pos <= high - low);
    else
      assert (pos <= s.size - low);
  }

  override size_t readBlock (void *buffer, size_t size) ;

  override size_t writeBlock (void *buffer, size_t size);

  override ulong seek(long offset, SeekPos rel) ;
   

  override size_t available () ;

  unittest {
    MemoryStream m;
    SliceStream s;

    m = new MemoryStream ((cast(char[])"Hello, world").dup);
    s = new SliceStream (m, 4, 8);
    assert (s.size () == 4);
    assert (m.position () == 0);
    assert (s.position () == 0);
    assert (m.available == 12);
    assert (s.available == 4);

    assert (s.writeBlock (cast(char *) "Vroom", 5) == 4);
    assert (m.position () == 0);
    assert (s.position () == 4);
    assert (m.available == 12);
    assert (s.available == 0);
    assert (s.seekEnd (-2) == 2);
    assert (s.available == 2);
    assert (s.seekEnd (2) == 4);
    assert (s.available == 0);
    assert (m.position () == 0);
    assert (m.available == 12);

    m.seekEnd(0);
    m.writeString("\nBlaho");
    assert (m.position == 18);
    assert (m.available == 0);
    assert (s.position == 4);
    assert (s.available == 0);

    s = new SliceStream (m, 4);
    assert (s.size () == 14);
    assert (s.toString () == "Vrooorld\nBlaho");
    s.seekEnd (0);
    assert (s.available == 0);

    s.writeString (", etcetera.");
    assert (s.position () == 25);
    assert (s.seekSet (0) == 0);
    assert (s.size () == 25);
    assert (m.position () == 18);
    assert (m.size () == 29);
    assert (m.toString() == "HellVrooorld\nBlaho, etcetera.");
  }
}

// helper functions
private bool iswhite(char c);

private bool isdigit(char c) ;

private bool isoctdigit(char c);

private bool ishexdigit(char c);
