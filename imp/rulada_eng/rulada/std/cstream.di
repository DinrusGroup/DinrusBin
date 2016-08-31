// Written in the D programming language

/**
 * Модуль cstream - это мост между си (или std.io) и std.stream.
 * Как си, так и std.stream публично импортируются cstream-ом.
 * Authors: Ben Hinkle
 * License: Public Domain
 * Macros:
 *	WIKI=Phobos/StdCstream
 */

module std.cstream;

import std.stream;
import std.c;

/**
 * Поточная обертка для файла Си типа FILE*.
 */
alias CFile ФайлСи;
class CFile : Stream {

  FILE* cfile;
 alias cfile файлси;
  /**
   * Создает поточную обертку для данного файла C.
   * Параметры:
   *   mode = a bitwise combination of $(B FileMode.In) for a readable file
   *          and $(B FileMode.Out) for a writeable file.
   *   seekable = indicates if the stream should be _seekable.
   */
  this(FILE* cfile, FileMode mode, bool seekable = false) ;

  /**
   * Closes the stream.
   */
  ~this();

  /**
   * Property to get or set the underlying file for this stream.
   * Setting the file marks the stream as open.
   */
  FILE* file();
 alias file файл;
  /**
   * Ditto
   */
  void file(FILE* cfile) ;

  /**
   * Overrides of the $(B Stream) methods to call the underlying $(B FILE*)
   * C functions.
   */
  override void flush();
	alias flush слей;
  /**
   * Ditto
   */
  override void close() ;
	alias close закрой;
  /**
   * Ditto
   */
  override bool eof() ;
	alias eof кф;
  /**
   * Ditto
   */
  override char getc();
	alias getc берис;
  /**
   * Ditto
   */
  override char ungetc(char c) ;
	alias ungetc отдайс;
  /**
   * Ditto
   */
  override size_t readBlock(void* buffer, size_t size);
	alias readBlock читайБлок;
  /**
   * Ditto
   */
  override size_t writeBlock(void* buffer, size_t size) ;
	alias writeBlock пишиБлок;
  /**
   * Ditto
   */
  override ulong seek(long offset, SeekPos rel);
  alias seek сместись;

  /**
   * Ditto
   */
  override void writeLine(char[] s) ;
  alias writeLine пишиСтроку;

  /**
   * Ditto
   */
  override void writeLineW(wchar[] s) ;
  alias writeLineW пишиШСтроку;
  
 } 

/**
 * CFile wrapper of std.c.stdin (not seekable).
 */
CFile din;
alias din двход;
/**
 * CFile wrapper of std.c.stdout (not seekable).
 */
CFile dout;
alias dout двых;
/**
 * CFile wrapper of std.c.stderr (not seekable).
 */
CFile derr;
alias derr дош;

static this() {
  // open standard I/O devices
  din = new CFile(std.c.stdin,FileMode.In);
  dout = new CFile(std.c.stdout,FileMode.Out);
  derr = new CFile(std.c.stderr,FileMode.Out);
}

