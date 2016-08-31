/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.io.core;

import os.win.base.core,
  os.win.base.string,
  os.win.base.text,
  os.win.base.native,
  std.c,
  std.stdarg,
  std.stream;
debug import std.io : writefln;

enum FileAttributes {
  ReadOnly            = 0x00000001,
  Hidden              = 0x00000002,
  System              = 0x00000004,
  Directory           = 0x00000010,
  Archive             = 0x00000020,
  Device              = 0x00000040,
  Normal              = 0x00000080,
  Temporary           = 0x00000100,
  SparseFile          = 0x00000200,
  ReparsePoint        = 0x00000400,
  Compressed          = 0x00000800,
  Offline             = 0x00001000,
  NotContentIndexed   = 0x00002000,
  Encrypted           = 0x00004000,
  Virtual             = 0x00010000
}

package void ioError(uint errorCode, string path);

class IOException : Exception {

  private static const E_IO = "I/O error occurred.";

  this() {
    super(E_IO);
  }

  this(string message) {
    super(message);
  }

}
alias IOException ВВИскл;

class FileNotFoundException : Exception {

  private static const E_FILENOTFOUND = "Unable to find the specified file.";

  private string fileName_;

  this();
  this(string message);
  this(string message, string fileName) ;

  final string fileName();

}
alias FileNotFoundException ФайлНеНайденИскл;
/**
 * Represents a reade that can read a sequential series of characters.
 */
 alias Reader Читатель;
abstract class Reader {

  protected this() {
  }

  ~this() ;

  /**
   * Closes the Reader and releases any resources associated with the Reader.
   */
  void close() ;
  alias close закрыть;
  /**
   * Reads the next character from the input stream and advances the character position by one character.
   * Возвращает: The next character from the input stream, or char.init if no more characters are available.
   */
  char read() ;
alias read читать;
  /**
   * Reader a maximum of count characters from the input stream and writes the data to buffer, beginning at index.
   * Параметры:
   *   buffer = A character array with the values between index and (index + count - 1) replaces by the characters _read from the input stream.
   *   index = The place in buffer at which to begin writing.
   *   count = The maximum number of character to _read.
   * Возвращает: The number of characters that have been _read.
   */
  int read(char[] buffer, int index, int count);
alias read читать;
  /**
   * Reads all characters from the current position to the end of the Reader and returns them as a string.
   * Возвращает: A string containing all characters.
   */
  string readToEnd() ;

}
alias readToEnd читатьДоКонца;
/**
 * Represents a writer that can write a sequential series of characters.
 */
 alias Writer Писатель;
abstract class Writer {

  protected char[] newLine_ = [ '\r', '\n' ];

  protected this();
  ~this() ;

  /**
   * Closes the current writer and releases any resources associated with the writer.
   */
  void close() ;
  /**
   * Clears all buffers for the current writer causing buffered data to be written to the underlying device.
   */
  void flush();
  /**
   * Writes the text representation of the specified value or values to the stream.
   */
  void write(...) ;

  /**
   * Writes the text representation of the specified value or values, followed by a line terminator, to the stream.
   */
  void writeln(...) ;

  /**
   * Gets or sets the line terminator used by the current writer.
   */
  void newLine(string value) ;

  /// ditto
  string newLine() ;

  /**
   * Gets the _encoding in which the output is written.
   */
  abstract Encoding encoding();

}

private void resolveArgList(ref TypeInfo[] args, ref va_list argptr, out string format) ;
/**
 * Implements a Writer for writing information to a string.
 */
class StringWriter : Writer {

  private string sb_;
  private Encoding encoding_;

  this();
  override void write(...) ;

  /**
   * Returns a string containing the characters written to so far.
   */
  override string toString();

  override Encoding encoding() ;

}

/**
 * Implements a Writer for writing characters to a stream in a particular encoding.
 */
class StreamWriter : Writer {

  private Stream stream_;
  private Encoding encoding_;
  private bool closable_ = true;

  /**
   * Initializes a new instance for the specified _stream, using the specified _encoding.
   * Параметры:
   *   stream = The _stream to write to.
   *   encoding = The character _encoding to use.
   */
  this(Stream stream, Encoding encoding = Encoding.UTF8);

  package this(Stream stream, Encoding encoding, bool closable) ;

  override void close() ;
  
  override void write(...);

  /**
   * Gets the underlying stream.
   */
  Stream baseStream() ;

  override Encoding encoding() ;

}

private class ConsoleStream : Stream {

  private Handle handle_;

  package this(Handle handle) ;

  override void close();
  override void flush() ;

  override ulong seek(long offset, SeekPos origin);

  protected override uint readBlock(void* buffer, uint size) ;

  protected override uint writeBlock(in void* buffer, uint size);

}

/// Specifies constants that define background and foreground colors for the console.
enum ConsoleColor {
  Black,        /// The color black.
  DarkBlue,     /// The color dark blue.
  DarkGreen,    /// The color dark green.
  DarkCyan,     /// The color dark cyan.
  DarkRed,      /// The color dark red.
  DarkMagenta,  /// The color dark magenta.
  DarkYellow,   /// The color dark yellow.
  Gray,         /// The color gray.
  DarkGray,     /// The color dark gray.
  Blue,         /// The color blue.
  Green,        /// The color green.
  Cyan,         /// The color cyan.
  Red,          /// The color red.
  Magenta,      /// The color magenta.
  Yellow,       /// The color yellow.
  White         /// The color white.
}

/**
 * Represents the standard output and error streams for console applications.
 */
struct Console {

  private static Writer out_;
  private static Writer err_;

  private static bool defaultColorsRead_;
  private static ubyte defaultColors_;

  private static Handle outputHandle_;

  static ~this() {
    out_ = null;
    err_ = null;
  }

  /**
   * Writes the text representation of the specified value or values to the standard output stream.
   */
  static void write(...);

  /**
   * Writes the text representation of the specified value or values, followed by the current line terminator, to the standard output stream.
   */
  static void writeln(...) ;

  /**
   * Gets the standard _output stream.
   */
  static Writer output();

  /**
   * Sets the output property to the specified Writer object.
   * Параметры: newOutput = The new standard output.
   */
  static void setOutput(Writer newOutput) ;

  /**
   * Gets or sets the encoding the console uses to write output.
   * Параметры: value = The encoding used to write console output.
   */
  static void outputEncoding(Encoding value);
  /// ditto
  static Encoding outputEncoding() ;
  /**
   * Gets the standard _error output stream.
   */
  static Writer error() ;

  /**
   * Sets the error property to the specified Writer object.
   * Параметры: newError = The new standard error output.
   */
  static void setError(Writer newError);

  /**
   * Clears the console buffer and corresponding console window of display information.
   */
  static void clear() ;

  /**
   * Plays the sound of a _beep of a specified _frequency and _duration through the console speaker.
   * Параметры:
   *   frequency = The _frequency of the _beep, ranging from 37 to 32767 hertz.
   *   duration = The _duration of the _beep measured in milliseconds.
   */
  static void beep(int frequency = 800, int duration = 200);
  /**
   * Gets or sets the _title to display in the console _title bar.
   * Параметры: value = The text to be displayed in the _title bar of the console.
   */
  static void title(string value) ;
  /// ditto
  static string title() ;

  /**
   * Gets or sets the background color of the console.
   * Параметры: value = The color that appears behind each character.
   */
  static void backgroundColor(ConsoleColor value);
  /// ditto
  static ConsoleColor backgroundColor() ;

  /**
   * Gets or sets the foreground color of the console.
   * Параметры: value = The color of each character that is displayed.
   */
  static void foregroundColor(ConsoleColor value);
  /// ditto
  static ConsoleColor foregroundColor() ;

  /**
   * Sets the foreground and background console colors to their defaults.
   */
  static void resetColor() ;

  /**
   * Sets the position of the cursor.
   * Параметры:
   *   left = The column position.
   *   top = The row position.
   */
  static void setCursorPosition(int left, int top) ;

  /**
   * Gets or sets the column position of the cursor.
   */
  static void cursorLeft(int value) ;
  /// ditto
  static int cursorLeft() ;

  /**
   * Gets or sets the row position of the cursor.
   */
  static void cursorTop(int value) ;
  /// ditto
  static int cursorTop() ;

  /**
   * Gets or sets the left position of the console window area relative to the screen buffer.
   * Параметры: value = The left console window position measured in columns.
   */
  static void windowLeft(int value);
  /// ditto
  static int windowLeft() ;

  /**
   * Gets or sets the top position of the console window area relative to the screen buffer.
   * Параметры: value = The top console window position measured in rows.
   */
  static void windowTop(int value) ;
  
  static int windowTop() ;

  /**
   * Sets the position of the console window relative to the screen buffer.
   * Параметры:
   *   left = The column position of the upper-left corner.
   *   top = The row position of the upper-left corner.
   */
  static void setWindowPosition(int left, int top);

  /**
   * Sets the size of the console window.
   * Параметры:
   *   width = The _width of the console window measured in columns.
   *   height = The _height of the console window measured in rows.
   */
  static void setWindowSize(int width, int height) ;

  /**
   * Gets or sets the width of the console window.
   * Параметры: value = The width of the console window measured in columns.
   */
  static void windowWidth(int value) ;
  /// ditto
  static int windowWidth();
  /**
   * Gets or sets the height of the console window.
   * Параметры: value = The height of the console window measured in rows.
   */
  static void windowHeight(int value) ;
  /// ditto
  static int windowHeight() ;

  private static bool getBufferInfo(out CONSOLE_SCREEN_BUFFER_INFO csbi);

  private static Handle outputHandle() ;

}