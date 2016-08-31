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
/// Возвращает информацию о корневой папке и/или томе заданного пути.
string getDirectoryRoot(string path);
private string getDirectoryRootImpl(string path);
/// Определяет, соответствует ли заданный путь _path существующей на диске папке.
bool directoryExists(string path);
private bool directoryExistsImpl(string path) ;
/// Создает все папки в указанном _path.
void createDirectory(string path);

/// Указывает, следует ли удалить файл или папку навсегда или же поместить их в корзину.
enum DeleteOption {
  DeletePermanently, /// Удалить файл или папку навсегда. Дефолт.
  AllowUndo          /// Позволяет отменить операцию удаления.
}

/// Удаляет папку по заданному пути _path.
void deleteDirectory(string path, DeleteOption option = DeleteOption.DeletePermanently);
/// Перемещает файл или папку с ее содержимым в новое место.
void moveDirectory(string sourceDirName, string destDirName) ;
/// Возвращает дату и время создания папки или файла.
DateTime getCreationTime(string path);
/// Возвращает дату и время последнего доступа к папке или файлу.
DateTime getLastAccessTime(string path);
/// Возвращает дату и время последней записи в файл.
DateTime getLastWriteTime(string path);
/// Возвращает атрибуты файла, находящегося по заданному пути _path.
FileAttributes getFileAttributes(string path) ;
/// Определяет, существует ли указанный файл.
bool fileExists(string path) ;
private bool fileExistsImpl(string path) ;
/// Удалет указанный файл.
void deleteFile(string path, DeleteOption option = DeleteOption.DeletePermanently);
/// Перемещает указанный файл в новое место.
void moveFile(string sourceFileName, string destFileName);
/// Копирует существующий файл в новый файл, с опцией переписать файл _overwrite с одноименным названием.
void copyFile(string sourceFileName, string destFileName, bool overwrite = false);
/// Replaces the contents of the specified file with the contents of another, deleting the original, and creating a backup of the replaced file and optionally ignores merge errors.
void replaceFile(string sourceFileName, string destFileName, string backupFileName, bool ignoreMergeErrors = false) ;
/// Encrypts a file so that only the user account used to encrypt the file can decrypt it.
void encryptFile(string path) ;
/// Decrypts a file that was encrypted by the current user account using the encryptFile method.
void decryptFile(string path);

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

/**
 */
ulong getTotalSize(string driveName);

/**
 */
ulong getTotalFreeSpace(string driveName) ;

/**
 */
string getVolumeLabel(string driveName) ;

/**
 */
void setVolumeLabel(string driveName, string volumeLabel) ;

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

  this(WatcherChange change, string directory, string name) {
    change_ = change;
    name_ = name;
    if (directory[$ - 1] != '\\')
      directory ~= '\\';
    fullPath_ = directory ~ name;
  }

  WatcherChange change() {
    return change_;
  }

  string name() {
    return name_;
  }

  string fullPath() {
    return fullPath_;
  }

}

/**
 */
alias TEventHandler!(FileSystemEventArgs) FileSystemEventHandler;

/**
 */
class RenamedEventArgs : FileSystemEventArgs {

  private string oldName_;
  private string oldFullPath_;

  this(WatcherChange change, string directory, string name, string oldName) {
    super(change, directory, name);

    if (directory[$ - 1] != '\\')
      directory ~= '\\';
    oldName_ = oldName;
    oldFullPath_ = directory ~ oldName;
  }

  string oldName() {
    return oldName_;
  }

  string oldFullPath() {
    return oldFullPath_;
  }

}

/**
 */
alias TEventHandler!(RenamedEventArgs) RenamedEventHandler;

/**
 */
class ErrorEventArgs : EventArgs {

  private Exception exception_;

  this(Exception exception) {
    exception_ = exception;
  }

  Exception getException() {
    return exception_;
  }

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

  static ~this() {
    overlappedCache = null;
  }

  OVERLAPPED* pack(IOCompletionCallback iocb) {
    callback = iocb;

    overlapped = new OVERLAPPED;
    overlappedCache[overlapped] = this;
    return overlapped;
  }

  static Overlapped unpack(OVERLAPPED* lpOverlapped) {
    return getOverlapped(lpOverlapped);
  }

  static void free(OVERLAPPED* lpOverlapped) {
    auto overlapped = getOverlapped(lpOverlapped);
    overlappedCache.remove(lpOverlapped);
    delete lpOverlapped;
    overlapped.overlapped = null;
  }

  static Overlapped getOverlapped(OVERLAPPED* lpOverlapped) {
    if (auto overlapped = lpOverlapped in overlappedCache)
      return *overlapped;
    return null;
  }

}

extern(Windows)
private void bindCompletionCallback(uint errorCode, uint numBytes, OVERLAPPED* lpOverlapped) {
  //debug writefln("bindCompletionCallback");
  auto overlapped = Overlapped.getOverlapped(lpOverlapped);
  overlapped.callback(errorCode, numBytes, overlapped.overlapped);
}

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

  static ~this() {
    if (completionPort_ != Handle.init)
      CloseHandle(completionPort_);
  }

  /**
   */
  this(string path = null, string filter = "*") {
    directory_ = path;
    filter_ = filter;
  }

  ~this() {
    stopEvents();
    created.clear();
    deleted.clear();
    changed.clear();
    renamed.clear();
    error.clear();
  }

  /**
   */
  final void bufferSize(uint value) {
    if (bufferSize_ != value) {
      if (value < 4096)
        value = 4096;

      bufferSize_ = value;
      restart();
    }
  }
  /// ditto
  final uint bufferSize() {
    return bufferSize_;
  }

  /**
   */
  final void path(string value) {
    if (std.string.icmp(directory_, value) != 0) {
      directory_ = value;
      restart();
    }
  }
  /// ditto
  final string path() {
    return directory_;
  }

  /**
   */
  final void filter(string value) {
    if (std.string.icmp(filter_, value) != 0)
      filter_ = value;
  }
  /// ditto
  final string filter() {
    return filter_;
  }

  /**
   */
  final void notifyFilters(NotifyFilters value) {
    if (notifyFilters_ != value) {
      notifyFilters_ = value;
      restart();
    }
  }
  /// ditto
  final NotifyFilters notifyFilters() {
    return notifyFilters_;
  }

  /**
   */
  final void enableEvents(bool value) {
    if (enabled_ != value) {
      enabled_ = value;

      if (enabled_)
        startEvents();
      else
        stopEvents();
    }
  }
  final bool enableEvents() {
    return enabled_;
  }

  /**
   */
  protected void onCreated(FileSystemEventArgs e) {
    if (!created.isEmpty)
      created(this, e);
  }

  /**
   */
  protected void onDeleted(FileSystemEventArgs e) {
    if (!deleted.isEmpty)
      deleted(this, e);
  }

  /**
   */
  protected void onChanged(FileSystemEventArgs e) {
    if (!changed.isEmpty)
      changed(this, e);
  }

  /**
   */
  protected void onRenamed(RenamedEventArgs e) {
    if (!renamed.isEmpty)
      renamed(this, e);
  }

  /**
   */
  protected void onError(ErrorEventArgs e) {
    if (!error.isEmpty)
      error(this, e);
  }

  private void startEvents() {
    if (!isHandleInvalid)
      return;

    stopWatching_ = false;

    directoryHandle_ = CreateFile(
      directory_.toUtf16z(), 
      FILE_LIST_DIRECTORY, 
      FILE_SHARE_READ | FILE_SHARE_DELETE | FILE_SHARE_WRITE, 
      null, 
      OPEN_EXISTING,
      FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OVERLAPPED/**/,
      Handle.init);
    if (isHandleInvalid)
      throw new FileNotFoundException("Unable to find the specified file.", directory_);

    auto completionPortThread = new Thread({
      uint errorCode;
      uint numBytes;
      uint key;
      OVERLAPPED* overlapped;

      while (true) {
        errorCode = 0;
        if (!GetQueuedCompletionStatus(completionPort_, numBytes, key, overlapped, 15000))
          errorCode = GetLastError();

        if (errorCode == os.win.base.native.WAIT_TIMEOUT) {
          BOOL isIOPending;
          /*if (!GetThreadIOPendingFlag(GetCurrentThread(), &isIOPending))
            isIOPending = FALSE;*/
          if (!isIOPending)
            break;
        }

        if (overlapped != null && key != 0) {
          (cast(LPOVERLAPPED_COMPLETION_ROUTINE)key)(errorCode, numBytes, overlapped);
        }
      }
      InterlockedDecrement(completionPortThreadCount_);
      version(D_Version2) {}
      else {
        return 0;
      }
    });
    InterlockedIncrement(completionPortThreadCount_);
    completionPortThread.start();

    if (completionPort_ == Handle.init)
      completionPort_ = CreateIoCompletionPort(INVALID_HANDLE_VALUE, Handle.init, 0, 0);

    if (CreateIoCompletionPort(directoryHandle_, completionPort_, cast(uint)&bindCompletionCallback, 0) == Handle.init)
      throw new Win32Exception;

    enabled_ = true;
    watch(null);
  }

  private void stopEvents() {
    if (isHandleInvalid)
      return;

    stopWatching_ = true;

    CloseHandle(directoryHandle_);
    directoryHandle_ = Handle.init;

    enabled_ = false;
  }

  private void restart() {
    if (enabled_) {
      stopEvents();
      startEvents();
    }
  }

  private void watch(void* buffer) {
    if (!enabled_ || isHandleInvalid)
      return;

    if (buffer == null)
      buffer = malloc(bufferSize_);

    auto overlapped = new Overlapped;
    auto lpOverlapped = overlapped.pack(&completionCallback);
    lpOverlapped.Pointer = buffer;

    BOOL result = ReadDirectoryChangesW(directoryHandle_, 
      buffer, 
      bufferSize_, 
      includeSubDirs_ ? TRUE : FALSE, 
      cast(uint)notifyFilters_, 
      null, 
      lpOverlapped, 
      null);

    if (!result) {
      Overlapped.free(lpOverlapped);
      free(buffer);

      if (!isHandleInvalid)
        onError(new ErrorEventArgs(new Win32Exception));
    }
  }

  private bool isMatch(string path) {

    /*string escape(string str) {
      string ret;
      foreach (i, ch; str) {
        switch (ch) {
          case '\\', '*', '+', '?', '|', '{', '[', '(', ')', '^', '$', '.', '#', ' ':
            ret ~= "\\" ~ ch;
            break;
          case '\n':
            ret ~= "\\n";
            break;
          case '\r':
            ret ~= "\\r";
            break;
          case '\t':
            ret ~= "\\t";
            break;
          case '\f':
            ret ~= "\\f";
            break;
          default:
            ret ~= ch;
            break;
        }
      }
      return ret;
    }*/

    string name = std.path.getBaseName(path);

    if (name == null || filter_ == null)
      return false;

    if (filter_ == "*")
      return true;

    /*if (filter_[0] == '*' && filter_.indexOf('*', 1) == -1) {
      uint n = filter_.length - 1;
      if (name.length >= n && os.win.base.string.compare(filter_, 1, name, name.length - n, n, true) == 0)
        return true;
    }

    // Should probably use a custom pattern matcher, but this is adequate for most cases.
    string pattern = "^" ~ escape(filter_.toUpper()).replace(r"\*", ".*").replace(r"\?", ".") ~ "$";
    return std.regexp.find(name.toUpper(), pattern) != -1;*/
    // Actually, fnmatch appears to do what we want.
    return std.path.fnmatch(name, filter_) != 0;
  }

  private void notifyRename(WatcherChange action, string name, string oldName) {
    if (isMatch(name) || isMatch(oldName))
      onRenamed(new RenamedEventArgs(action, directory_, name, oldName));
  }

  private void notifyFileSystem(uint action, string name) {
    if (isMatch(name)) {
      switch (action) {
        case FILE_ACTION_ADDED:
          onCreated(new FileSystemEventArgs(WatcherChange.Created, directory_, name));
          break;
        case FILE_ACTION_REMOVED:
          onDeleted(new FileSystemEventArgs(WatcherChange.Deleted, directory_, name));
          break;
        case FILE_ACTION_MODIFIED:
          onChanged(new FileSystemEventArgs(WatcherChange.Changed, directory_, name));
          break;
        default:
      }
    }
  }

  private void completionCallback(uint errorCode, uint numBytes, OVERLAPPED* lpOverlapped) {
    //debug writefln("completionCallback");
    auto overlapped = Overlapped.unpack(lpOverlapped);
    void* buffer = overlapped.overlapped.Pointer;
    try {
      if (stopWatching_)
        return;

      if (errorCode != 0) {
        onError(new ErrorEventArgs(new Win32Exception(errorCode)));
        enableEvents = false;
        return;
      }

      if (numBytes > 0) {
        uint offset;
        string oldName;
        FILE_NOTIFY_INFORMATION* notify;
        do {
          notify = cast(FILE_NOTIFY_INFORMATION*)(buffer + offset);
          offset += notify.NextEntryOffset;

          string name = toUtf8(notify.FileName.ptr, 0, notify.FileNameLength / 2);

          // Like System.IO.FileSystemWatcher, we just want one rename notification.
          if (notify.Action == FILE_ACTION_RENAMED_OLD_NAME) {
            oldName = name;
          }
          else if (notify.Action == FILE_ACTION_RENAMED_NEW_NAME) {
            if (oldName != null) {
              notifyRename(WatcherChange.Renamed, name, oldName);
              oldName = null;
            }
            else {
              notifyRename(WatcherChange.Renamed, name, oldName);
            }
          }
          else {
            if (oldName != null) {
              notifyRename(WatcherChange.Renamed, null, oldName);
              oldName = null;
            }
            notifyFileSystem(notify.Action, name);
          }
        } while (notify.NextEntryOffset != 0);

        if (oldName != null) {
          notifyRename(WatcherChange.Renamed, null, oldName);
          oldName = null;
        }
      }
    }
    finally {
      Overlapped.free(lpOverlapped);

      if (stopWatching_) {
        if (buffer != null)
          free(buffer);
      }
      else {
        watch(buffer);
        //restart();
      }
    }
  }

  private bool isHandleInvalid() {
    return (directoryHandle_ == Handle.init 
      || directoryHandle_ == INVALID_HANDLE_VALUE);
  }

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
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
