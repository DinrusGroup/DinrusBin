module lib.DinrusWinDLL;

pragma(lib, "DinrusWinDLL.lib");

extern(D):

Объект клонируйОбъ(Объект о);
ткст дайКомСтроку();
ткст[] дайАргиКомСтроки();
проц установиИмяМашины(ткст имя);
ткст дайИмяМашины();
ткст дайИмяПользователя() ;
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
  РабочийСтол = 0x0000,                 /// The logical _Desktop rather than the physical file system location.
  Интернет = 0x0001,                /// 
  Программы = 0x0002,                /// The directory that contains the user's program groups.
  ПанельУправления = 0x0003,                /// The Control Panel folder.
  Принтеры = 0x0004,                ///
  Персональная = 0x0005,                /// The directory that serves as a common repository for documents.
  Избранное = 0x0006,               /// The directory that serves as a common repository for the user's favorite items.
  Стартап = 0x0007,                 /// The directory that corresponds to the user's _Startup program group.
  Недавнее = 0x0008,                  /// The directory that contains the user's most recently used documents.
  Отправить = 0x0009,                  /// The directory that contains the Send To menu items.
  Корзина = 0x000a,              /// The Recycle Bin folder.
  СтартМеню = 0x000b,               /// The directory that contains the Start menu items.
  Документы = Персональная,             /// The directory that serves as a common repository for documents.
  Музыка = 0x000d,                   /// The "_Music" folder.
  Видео = 0x000e,                   /// The "_Video" folder.
  ПапкаРабСтола = 0x0010,        /// The directory used to physically store file objects on the desktop.
  Компьютер = 0x0011,                /// The "_Computer" folder.
  Сеть = 0x0012,                 /// The "_Network" folder.
  Шрифты = 0x0014,                   /// The directory that serves as a common repository for fonts.
  Шаблоны = 0x0015,               /// The directory that serves as a common repository for document templates.
  ОбщСтартМеню = 0x0016,         /// 
  ОбщПрограммы = 0x0017,          /// The directory for components that are shared across applications.
  ОбщСтартап = 0x0018,           /// 
  ОбщПапкаРабСтола = 0x0019,  /// 
  ДанныеПриложений = 0x001a,         /// The directory that serves as a common repository for application-specific data for the current roaming user.
  ЛокДанныеПриложений = 0x001c,    /// The directory that serves as a common repository for application-specific data that is used by the current, non-roaming user.
  ИнтернетКэш = 0x0020,           /// The directory that serves as a common repository for temporary Internet files.
  Куки = 0x0021,                 /// The directory that serves as a common repository for Internet cookies.
  История = 0x0022,                 /// The directory that serves as a common repository for Internet history items.
  ОбщДанныеПриложений = 0x0023,   /// The directory that serves as a common repository for application-specific data that is used by all users.
  Виндовс = 0x0024,                 /// The _Windows directory.
  Система = 0x0025,                  /// The _System directory.
  ПрогФайлы = 0x0026,            /// The program files directory.
  Рисунки = 0x0027,                /// The "_Pictures" folder.
  ОбщПрогрФайлы = 0x002b,      /// The directory for components that are shared across applications.
  ОбщШаблоны = 0x002d,         ///
  ОбщДокументы = 0x002e,         /// 
  Подключения = 0x0031,             ///
  ОбщРисунки = 0x0036,          ///
  Ресурсы = 0x0038,               ///
  ЛокРисунки = 0x0039,      /// 
  ЗаписьКД = 0x003b                ///
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

проц удалиПапку(ткст путь, ПОпцияУдаления опция = ПОпцияУдаления.Навсегда) ;
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