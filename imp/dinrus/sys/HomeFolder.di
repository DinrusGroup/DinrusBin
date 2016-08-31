module sys.HomeFolder;

pagma(lib, "DinrusWinDLL.lib");

extern(C):
 
Объект клонируйОбъ(Объект о);
ткст дайКомСтроку();
ткст[] дайАргиКомСтроки();
проц установиИмяМашины(ткст имя);
ткст дайИмяМашины();
ткст дайИмяПользователя();
цел дайЧлоТиков();
ткст дайЗначениеПеременнойСреды(ткст имя);
ткст текущаяПапка();
ткст системнаяПапка();
ткст времПапка();
ткст создайВремфлДайИмя();
цел дайДлинуКорня(ткст путь);
ткст дайКорень(ткст путь);
бул указанКорень(ткст путь);
ткст комбинируй(ткст путь1, ткст путь2);
ткст дайИмяПапки(ткст путь);
ткст отделиИмяфСРасш(ткст путь);
ткст дайПолныйПуть(ткст путь);

/// Specifies constants used to retrieve directory paths to system special folders.
enum ПОсобаяПапка {
  Desktop = 0x0000,                 /// The logical _Desktop rather than the physical file system location.
  Internet = 0x0001,                /// 
  Programs = 0x0002,                /// The directory that contains the user's program groups.
  Controls = 0x0003,                /// The Control Panel folder.
  Printers = 0x0004,                ///
  Personal = 0x0005,                /// The directory that serves as a common repository for documents.
  Favorites = 0x0006,               /// The directory that serves as a common repository for the user's favorite items.
  Startup = 0x0007,                 /// The directory that corresponds to the user's _Startup program group.
  Recent = 0x0008,                  /// The directory that contains the user's most recently used documents.
  SendTo = 0x0009,                  /// The directory that contains the Send To menu items.
  RecycleBin = 0x000a,              /// The Recycle Bin folder.
  StartMenu = 0x000b,               /// The directory that contains the Start menu items.
  Documents = Personal,             /// The directory that serves as a common repository for documents.
  Music = 0x000d,                   /// The "_Music" folder.
  Video = 0x000e,                   /// The "_Video" folder.
  DesktopDirectory = 0x0010,        /// The directory used to physically store file objects on the desktop.
  Computer = 0x0011,                /// The "_Computer" folder.
  Сеть = 0x0012,                 /// The "_Network" folder.
  Fonts = 0x0014,                   /// The directory that serves as a common repository for fonts.
  Templates = 0x0015,               /// The directory that serves as a common repository for document templates.
  CommonStartMenu = 0x0016,         /// 
  CommonPrograms = 0x0017,          /// The directory for components that are shared across applications.
  CommonStartup = 0x0018,           /// 
  CommonDesktopDirectory = 0x0019,  /// 
  ApplicationData = 0x001a,         /// The directory that serves as a common repository for application-specific data for the current roaming user.
  LocalApplicationData = 0x001c,    /// The directory that serves as a common repository for application-specific data that is used by the current, non-roaming user.
  InternetCache = 0x0020,           /// The directory that serves as a common repository for temporary Internet files.
  Cookies = 0x0021,                 /// The directory that serves as a common repository for Internet cookies.
  History = 0x0022,                 /// The directory that serves as a common repository for Internet history items.
  CommonApplicationData = 0x0023,   /// The directory that serves as a common repository for application-specific data that is used by all users.
  Windows = 0x0024,                 /// The _Windows directory.
  System = 0x0025,                  /// The _System directory.
  ProgramFiles = 0x0026,            /// The program files directory.
  Pictures = 0x0027,                /// The "_Pictures" folder.
  CommonProgramFiles = 0x002b,      /// The directory for components that are shared across applications.
  CommonTemplates = 0x002d,         ///
  CommonDocuments = 0x002e,         /// 
  Connections = 0x0031,             ///
  CommonPictures = 0x0036,          ///
  Resources = 0x0038,               ///
  LocalizedResources = 0x0039,      /// 
  CDBurning = 0x003b                ///
}

ткст дайПутьПапки(ПОсобаяПапка папка);
ткст[] логическиеДиски();
ткст дайКорневуюПапку(ткст путь);
бул папкаЕсть(ткст путь);
проц создайПапку(ткст путь);

/// Указывает, следует ли удалить файл или папку навсегда или же поместить их в корзину.
enum ПОпцияУдаления {
  Навсегда, /// Удалить файл или папку навсегда. Дефолт.
  ВКорзину          /// Позволяет отменить операцию удаления.
}

проц удалиПапку(ткст путь, ПОпцияУдаления опция = ПОпцияУдаления.Навсегда);
проц переместиПапку(ткст откуда, ткст куда);

/+
/// Возвращает дату и время создания папки или файла.
DateTime getCreationTime(string path) {
  string fullPath = getFullPath(path);

  WIN32_FILE_ATTRIBUTE_DATA data;
  if (!GetFileAttributesEx(fullPath.toUtf16z(), 0, data)) {
    uint errorCode = GetLastError();
    if (errorCode != ERROR_FILE_NOT_FOUND)
      ioError(errorCode, fullPath);
  }

  return DateTime.fromFileTime((cast(long)data.ftCreationTime.dwHighDateTime << 32) | data.ftCreationTime.dwLowDateTime);
}

/// Возвращает дату и время последнего доступа к папке или файлу.
DateTime getLastAccessTime(string path) {
  string fullPath = getFullPath(path);

  WIN32_FILE_ATTRIBUTE_DATA data;
  if (!GetFileAttributesEx(fullPath.toUtf16z(), 0, data)) {
    uint errorCode = GetLastError();
    if (errorCode != ERROR_FILE_NOT_FOUND)
      ioError(errorCode, fullPath);
  }

  return DateTime.fromFileTime((cast(long)data.ftLastAccessTime.dwHighDateTime << 32) | data.ftLastAccessTime.dwLowDateTime);
}

/// Возвращает дату и время последней записи в файл.
DateTime getLastWriteTime(string path) {
  string fullPath = getFullPath(path);

  WIN32_FILE_ATTRIBUTE_DATA data;
  if (!GetFileAttributesEx(fullPath.toUtf16z(), 0, data)) {
    uint errorCode = GetLastError();
    if (errorCode != ERROR_FILE_NOT_FOUND)
      ioError(errorCode, fullPath);
  }

  return DateTime.fromFileTime((cast(long)data.ftLastWriteTime.dwHighDateTime << 32) | data.ftLastWriteTime.dwLowDateTime);
}

/// Возвращает атрибуты файла, находящегося по заданному пути _path.
FileAttributes getFileAttributes(string path) {
  string fullPath = getFullPath(path);

  WIN32_FILE_ATTRIBUTE_DATA data;
  if (!GetFileAttributesEx(fullPath.toUtf16z(), 0, data))
    ioError(GetLastError(), fullPath);
  return cast(FileAttributes)data.dwFileAttributes;
}
+/

бул естьФл(ткст путь);
проц удалиФл(ткст путь, ПОпцияУдаления опция = ПОпцияУдаления.Навсегда);
проц переместиФл(ткст ист, ткст нов);
проц копируйФл(ткст откуда, ткст куда, бул переписать = false);
проц замениФл(ткст откуда, ткст куда, ткст бэкапИмя, бул игнорОш =false) ;
проц зашифруйФл(ткст путь);
проц расшифруйФл(ткст путь);
бдол дайДоступноСвободногоМеста(ткст диск);
бдол дайОбщийРазмер(ткст диск);
бдол дайВсегоСвободно(ткст диск);
ткст дайМеткуТома(ткст диск);
проц установиМеткуТома(ткст диск, ткст метка);
ткст домашняяПапка();
ткст разверниТильду(ткст путь);
