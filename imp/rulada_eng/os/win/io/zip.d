module os.win.io.zip;

import os.win.base.core,
  os.win.base.string,
  os.win.base.text,
  os.win.loc.time,
  std.stream,
  auxc.zlib;
//debug import std.io : writeln, writefln;

private enum : uint {
  LOCAL_FILE_HEADER_SIGNATURE             = 0x04034b50,
  CENTRAL_DIRECTORY_FILE_HEADER_SIGNATURE = 0x02014b50,
  END_OF_CENTRAL_DIRECTORY_SIGNATURE      = 0x06054b50
}

private ubyte[] END_OF_CENTRAL_DIRECTORY_SIGNATURE_BYTES = [0x50, 0x4b, 0x05, 0x06];

private DateTime dosDateTimeToDateTime(uint dosDateTime) ;

private uint dateTimeToDosDateTime(DateTime dateTime) ;

class ZipException : Exception {

  this(string message);

  this(int errorCode);

  private static string getErrorMessage(int errorCode) ;

}

/**
 * Indicates the method employed to compress an entry in a zip file.
 */
enum CompressionMethod : ushort {
  Stored   = 0x0, /// Indicates the entry is not compressed.
  Deflated = 0x8  /// Indicates the Deflate method is used to compress the entry.
}

/**
 * Indicates the compression level to be used when compressing an entry in a zip file.
 */
enum CompressionLevel {
  Default = -1, /// The default compression level.
  None    = 0,  /// Indicates the entry is not compressed.
  Fastest = 1,  /// The fastest but least efficient level of compression.
  Best    = 9   /// The most efficient but slowest level of compression.
}

private void copyStream(Stream input, Stream output);

private class SliceStreamWithSize : SliceStream {

  ulong size_;

  this(Stream source, ulong offset, ulong size);
  
  override ulong size() ;

}

private class CopyFilterStream : FilterStream {

  this(Stream source) ;

  override void copyFrom(Stream source) ;

}

private class InflateStream : CopyFilterStream {

  ulong size_;

  ubyte[] buffer_;
  z_stream zs_;

  this(Stream source, ulong size) ;

  override size_t readBlock(void* buffer, size_t size);

  override size_t writeBlock(in void* buffer, size_t size) ;
  
  override void flush() ;

  override ulong size() ;

}

private class DeflateStream : CopyFilterStream {

  ubyte[] buffer_;
  z_stream zs_;
  ulong size_;

  this(Stream source, CompressionLevel level) ;
  
  override void close() ;

  override size_t readBlock(void* buffer, size_t size) ;
  
  override size_t writeBlock(in void* buffer, size_t size);

  override ulong seek(long offset, SeekPos origin) ;

  override void flush() ;
  
  override ulong size() ;
}

private class CrcStream : CopyFilterStream {

  uint value;

  this(Stream source);

  override size_t readBlock(void* buffer, size_t size) ;

  override size_t writeBlock(in void* buffer, size_t size) ;

}

class ZipEntry {

  private Stream input_;
  private Stream data_;
  private Stream output_;

  private ushort extractVersion_;
  private ushort bitFlag_;
  private ushort method_ = cast(ushort)-1;
  private uint lastWriteTime_ = cast(uint)-1;
  private uint crc32_;
  private uint compressedSize_;
  private uint uncompressedSize_;
  private ushort fileNameLength_;
  private ushort extraFieldLength_;

  private string fileName_;
  private ubyte[] extraField_;
  private string comment_;

  this();

  this(string fileName) ;

  /*Stream readStream() {
    data_ = new SliceStreamWithSize(input_, input_.position, uncompressedSize_);
    switch (method_) {
      case CompressionMethod.Stored:
        break;
      case CompressionMethod.Deflated:
        data_ = new InflateStream(data_, uncompressedSize_);
        break;
      default:
    }
    return data_;
  }

  Stream readStream() {
    if (output_ is null)
      output_ = new CopyFilterStream(new MemoryStream);
    return output_;
  }*/

  void method(CompressionMethod value);
  
  CompressionMethod method() ;

  void lastWriteTime(DateTime value);
  
  DateTime lastWriteTime() ;

  void fileName(string value);

  void comment(string value);

  bool isDirectory() ;

}

final class ZipReader {

  private Stream input_;
  private Encoding encoding_;
  private Stream readStream_;

  private ZipEntry entry_;

  private string comment_;

  this(Stream input) ;

  void close() ;

  ZipEntry read();
  
  Stream readStream() ;

  string comment() ;

  private void closeEntry() ;

  private void readEndOfCentralDirectory();

}

/**
 * Примеры:
 * ---
 * // Create a new ZipWriter with the name "backup.zip".
 * auto writer = new ZipWriter("backup.zip");
 *
 * // Create an entry named "research.doc".
 * auto entry = new ZipEntry("research.doc");
 * writer.writeStream.copyFrom(new File("research.doc"));
 *
 * // Add the new entry to the writer.
 * writer.add(entry);
 *
 * // Finalise the writer.
 * writer.close();
 * ---
 */
class ZipWriter {

  private class Entry {

    ZipEntry entry;
    uint offset;

    this(ZipEntry entry, uint offset);

  }

  private Stream output_;
  private Encoding encoding_;
  private Stream writeStream_;

  private CompressionMethod method_ = CompressionMethod.Deflated;
  private CompressionLevel level_ = CompressionLevel.Default;

  private ZipEntry entry_;
  private Entry[] entries_;

  private string comment_;

  this(Stream output);

  void close() ;

  void write(ZipEntry entry);

  Stream writeStream();

  void finish();

  private void writeCentralDirectory() ;

  private void writeCentralDirectoryEntry(Entry e) ;

  private void writeEndOfCentralDirectory(uint start, uint size) ;
  
  void method(CompressionMethod value) ;
  
  CompressionMethod method() ;

  void level(CompressionLevel value) ;
  
  CompressionLevel level() ;

  void comment(string value) ;

}