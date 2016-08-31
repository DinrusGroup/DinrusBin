module os.win.io.fs;

import os.win.base.core,
  os.win.base.string,
  os.win.base.events,
  os.win.base.native,
  os.win.loc.time,
  os.win.io.core,
  os.win.io.path,
  std.c;
  
version(D_Version2) {
  import core.thread;
}
else {
  import std.thread;
}
static import std.path,
  std.regexp;

/// Возвращает массив строк, содержащий названия логических дисков локального компьютера.
string[] logicalDrives();
alias logicalDrives логическиеДиски;
/// Возвращает информацию о корневой папке и/или томе заданного пути.
string getDirectoryRoot(string path);
alias getDirectoryRoot корневаяПапка;
private string getDirectoryRootImpl(string path) ;

/// Определяет, соответствует ли заданный путь _path существующей на диске папке.
bool directoryExists(string path);
alias directoryExists естьПапка_ли;

private bool directoryExistsImpl(string path);

/// Создает все папки в указанном _path.
void createDirectory(string path) ;
alias createDirectory создатьПапку;

/// Указывает, следует ли удалить файл или папку навсегда или же поместить их в корзину.
enum DeleteOption {
  DeletePermanently, /// Удалить файл или папку навсегда. Дефолт.
  AllowUndo          /// Позволяет отменить операцию удаления.
}

/// Удаляет папку по заданному пути _path.
void deleteDirectory(string path, DeleteOption option = DeleteOption.DeletePermanently);
alias deleteDirectory удалитьПапку;

/// Перемещает файл или папку с ее содержимым в новое место.
void moveDirectory(string sourceDirName, string destDirName);
alias moveDirectory переместитьПапку;

/// Возвращает дату и время создания папки или файла.
DateTime getCreationTime(string path);
alias getCreationTime времяСоздания;

/// Возвращает дату и время последнего доступа к папке или файлу.
DateTime getLastAccessTime(string path);
alias getLastAccessTime времяПоследнегоДоступа;

/// Возвращает дату и время последней записи в файл.
DateTime getLastWriteTime(string path) ;
alias getLastWriteTime времяПоследнейЗаписи;

/// Возвращает атрибуты файла, находящегося по заданному пути _path.
FileAttributes getFileAttributes(string path);
alias getFileAttributes атрибутыФайла;
/// Определяет, существует ли указанный файл.
bool fileExists(string path);
alias fileExists естьФайл_ли;
private bool fileExistsImpl(string path);

/// Удалет указанный файл.
void deleteFile(string path, DeleteOption option = DeleteOption.DeletePermanently) ;
alias deleteFile удалитьФайл;

/// Перемещает указанный файл в новое место.
void moveFile(string sourceFileName, string destFileName);
alias moveFile переместитьФайл;

/// Копирует существующий файл в новый файл, с опцией переписать файл _overwrite с одноименным названием.
void copyFile(string sourceFileName, string destFileName, bool overwrite = false);
alias copyFile копироватьФайл;

/// Replaces the contents of the specified file with the contents of another, deleting the original, and creating a backup of the replaced file and optionally ignores merge errors.
void replaceFile(string sourceFileName, string destFileName, string backupFileName, bool ignoreMergeErrors = false);
alias replaceFile заменитьФайл;

/// Encrypts a file so that only the user account used to encrypt the file can decrypt it.
void encryptFile(string path);
alias encryptFile  зашифроватьФайл;

/// Decrypts a file that was encrypted by the current user account using the encryptFile method.
void decryptFile(string path);
alias decryptFile расшифроватьФайл;

/**
 * Примеры:
 * Converts a numeric value into a human-readable string representing the number expressed in bytes, kilobytes, megabytes or gigabytes.
 * ---
 * string[] orders = [ "GB", "MB", "KB", " bytes" ];
 * const real scale = 1024;
 * auto max = std.math.pow(scale, orders.length - 1);
 *
 * string drive = r"C:\";
 * auto freeSpace = getAvailableFreeSpace(drive);
 * string s = "0 bytes";
 *
 * foreach (order; orders) {
 *   if (freeSpace > max) {
 *     s = std.string.format("%.2f%s", cast(real)freeSpace / max, order);
 *     break;
 *   }
 *   max /= scale;
 * }
 *
 * std.io.writefln("Available free space on drive %s: %s", drive, s);
 * ---
 */
ulong getAvailableFreeSpace(string driveName);
alias getAvailableFreeSpace доступногоМестаНаДиске;

/**
 */
ulong getTotalSize(string driveName);
alias getTotalSize полныйРазмерДиска;

/**
 */
ulong getTotalFreeSpace(string driveName) ;
alias getTotalFreeSpace свободногоМестаНаДиске;
/**
 */
string getVolumeLabel(string driveName) ;
alias getVolumeLabel меткаТома;

/**
 */
void setVolumeLabel(string driveName, string volumeLabel) ;
alias setVolumeLabel установитьМеткуТома;

/**
 */
enum NotifyFilters {
  FileName      = FILE_NOTIFY_CHANGE_FILE_NAME,
  DirectoryName = FILE_NOTIFY_CHANGE_DIR_NAME,
  Attributes    = FILE_NOTIFY_CHANGE_ATTRIBUTES,
  Size          = FILE_NOTIFY_CHANGE_SIZE,
  LastWrite     = FILE_NOTIFY_CHANGE_LAST_WRITE,
  LastAccess    = FILE_NOTIFY_CHANGE_LAST_ACCESS,
  CreationTime  = FILE_NOTIFY_CHANGE_CREATION,
  Security      = FILE_NOTIFY_CHANGE_SECURITY
}

/**
 */
enum WatcherChange {
  Created = 0x1,
  Deleted = 0x2,
  Changed = 0x4,
  Renamed = 0x8,
  All     = Created | Deleted | Changed | Renamed
}

/**
 */
class FileSystemEventArgs : EventArgs {

  private WatcherChange change_;
  private string name_;
  private string fullPath_;

  this(WatcherChange change, string directory, string name) ;
  WatcherChange change() ;

  string name();
  string fullPath();
}

/**
 */
alias TEventHandler!(FileSystemEventArgs) FileSystemEventHandler;

/**
 */
class RenamedEventArgs : FileSystemEventArgs {

  private string oldName_;
  private string oldFullPath_;

  this(WatcherChange change, string directory, string name, string oldName);

  string oldName();

  string oldFullPath();

}

/**
 */
alias TEventHandler!(RenamedEventArgs) RenamedEventHandler;

/**
 */
class ErrorEventArgs : EventArgs {

  private Exception exception_;

  this(Exception exception);

  Exception getException() ;

}

/**
 */
alias TEventHandler!(ErrorEventArgs) ErrorEventHandler;

alias void delegate(uint errorCode, uint numBytes, OVERLAPPED* overlapped) IOCompletionCallback;

// Wraps a native OVERLAPPED and associates a callback with each object.
private class Overlapped {

  static Overlapped[OVERLAPPED*] overlappedCache;

  IOCompletionCallback callback;
  OVERLAPPED* overlapped;

  static ~this() ;

  OVERLAPPED* pack(IOCompletionCallback iocb);

  static Overlapped unpack(OVERLAPPED* lpOverlapped);

  static void free(OVERLAPPED* lpOverlapped) ;

  static Overlapped getOverlapped(OVERLAPPED* lpOverlapped);

}

extern(Windows)
private void bindCompletionCallback(uint errorCode, uint numBytes, OVERLAPPED* lpOverlapped) ;

/**
 * Listens to file system change notifications and raises events when a directory, or file in a directory, changes.
 * Примеры:
 * ---
 * import os.win.io.fs, std.io;
 *
 * void main() {
 *   // Create a Watcher object and set its properties.
 *   scope watcher = new Watcher;
 *   watcher.path = r"C:\";
 *
 *   // Add event handlers.
 *   watcher.created += (Object, FileSystemEventArgs e) {
 *     writefln("File %s changed", e.fullPath);
 *   };
 *   watcher.deleted += (Object, FileSystemEventArgs e) {
 *     writefln("File %s deleted", e.fullPath);
 *   };
 *   watcher.changed += (Object, FileSystemEventArgs e) {
 *     writefln("File %s changed", e.fullPath);
 *   };
 *   watcher.renamed += (Object, RenamedEventArgs e) {
 *     writefln("File %s renamed to %s", e.oldFullPath, e.fullPath);
 *   };
 *
 *   // Start listening.
 *   watcher.enableEvents = true;
 *
 *   writefln("Press 'q' to quit.");
 *   while (std.c.getch() != 'q') {
 *   }
 * }
 * ---
 */
class Watcher {

  private string directory_;
  private string filter_ = "*";
  private bool includeSubDirs_;
  private NotifyFilters notifyFilters_ = NotifyFilters.FileName | NotifyFilters.DirectoryName | NotifyFilters.LastWrite;
  private Handle directoryHandle_;
  private uint bufferSize_ = 8192;
  private bool enabled_;
  private bool stopWatching_;
  private static Handle completionPort_;
  private static int completionPortThreadCount_;

  ///
  FileSystemEventHandler created;
  ///
  FileSystemEventHandler deleted;
  ///
  FileSystemEventHandler changed;
  ///
  RenamedEventHandler renamed;
  ///
  ErrorEventHandler error;

  static ~this();

  /**
   */
  this(string path = null, string filter = "*") ;

  ~this() ;

  /**
   */
  final void bufferSize(uint value) ;
  /// ditto
  final uint bufferSize();

  /**
   */
  final void path(string value) ;
  /// ditto
  final string path();

  /**
   */
  final void filter(string value) ;
  /// ditto
  final string filter() ;

  /**
   */
  final void notifyFilters(NotifyFilters value);
  /// ditto
  final NotifyFilters notifyFilters() ;

  /**
   */
  final void enableEvents(bool value) ;
  final bool enableEvents() {
    return enabled_;
  }

  /**
   */
  protected void onCreated(FileSystemEventArgs e) ;

  /**
   */
  protected void onDeleted(FileSystemEventArgs e) ;

  /**
   */
  protected void onChanged(FileSystemEventArgs e) ;

  /**
   */
  protected void onRenamed(RenamedEventArgs e) ;

  /**
   */
  protected void onError(ErrorEventArgs e);

  private void startEvents();

  private void stopEvents() ;

  private void restart() ;
  
  private void watch(void* buffer) ;

  private bool isMatch(string path);
  
  private void notifyRename(WatcherChange action, string name, string oldName);

  private void notifyFileSystem(uint action, string name);

  private void completionCallback(uint errorCode, uint numBytes, OVERLAPPED* lpOverlapped);

  private bool isHandleInvalid();
}

///
interface Iterator(T) {

  ///
  int opApply(int delegate(ref T) action);

}

class FileSystemIterator : Iterator!(string) {

  private string path_;
  private string searchPattern_;
  private bool includeFiles_;
  private bool includeDirs_;

  this(string path, string searchPattern, bool includeFiles, bool includeDirs) {
    path_ = path;
    searchPattern_ = searchPattern;
    includeFiles_ = includeFiles;
    includeDirs_ = includeDirs;
  }

  int opApply(int delegate(ref string) action) {

    bool isDir(WIN32_FIND_DATA findData) {
      return ((findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0);
    }

    bool isFile(WIN32_FIND_DATA findData) {
      return ((findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0);
    }

    string getSearchResult(string path, WIN32_FIND_DATA findData) {
      return combine(path, toUtf8(findData.cFileName[0 .. std.string.wcslen(findData.cFileName.ptr)]));
    }

    int ret = 0;

    string fullPath = getFullPath(path_);

    string searchPattern = searchPattern_.trimEnd('\t', '\n', '\v', '\f', '\r', '\u0085', '\u00a0');
    if (searchPattern == ".")
      searchPattern = "*";
    if (searchPattern.length == 0)
      return ret;

    string searchPath = combine(fullPath, searchPattern);
    if (searchPath[$ - 1] == std.path.sep[0] 
      || searchPath[$ - 1] == std.path.altsep[0] 
      || searchPath[$ - 1] == ':')
      searchPath ~= '*';

    string userPath = path_;
    string tempPath = getDirectoryName(searchPattern);
    if (tempPath.length != 0)
      userPath = combine(userPath, tempPath);

    WIN32_FIND_DATA findData;
    uint lastError;

    Handle hFind = FindFirstFile(searchPath.toUtf16z(), findData);
    if (hFind != INVALID_HANDLE_VALUE) {
      scope(exit) FindClose(hFind);

      do {
        if (std.string.wcscmp(findData.cFileName.ptr, ".") == 0
          || std.string.wcscmp(findData.cFileName.ptr, "..") == 0)
          continue;

        string result = getSearchResult(userPath, findData);

        if ((includeDirs_ && isDir(findData)) 
          || (includeFiles_ && isFile(findData))) {
          if ((ret = action(result)) != 0)
            break;
        }
      } while (FindNextFile(hFind, findData));

      lastError = GetLastError();
    }

    if (lastError != ERROR_SUCCESS 
      && lastError != ERROR_NO_MORE_FILES 
      && lastError != ERROR_FILE_NOT_FOUND)
      ioError(lastError, userPath);

    return ret;
  }

}

/**
 * Returns an iterable collection of directory names in the specified _path.
 */
Iterator!(string) enumDirectories(string path, string searchPattern = "*") {
  return enumFileSystemNames(path, searchPattern, false, true);
}

/**
 * Returns an iterable collection of file names in the specified _path.
 */
Iterator!(string) enumFiles(string path, string searchPattern = "*") {
  return enumFileSystemNames(path, searchPattern, true, false);
}

/**
 * Returns an iterable collection of file-system entries in the specified _path.
 */
Iterator!(string) enumFileSystemEntries(string path, string searchPattern = "*") {
  return enumFileSystemNames(path, searchPattern, true, true);
}

private Iterator!(string) enumFileSystemNames(string path, string searchPattern, bool includeFiles, bool includeDirs) {
  return new FileSystemIterator(path, searchPattern, includeFiles, includeDirs);
}