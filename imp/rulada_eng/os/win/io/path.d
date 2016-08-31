/**
 * Performs operations on strings that contain file or directory _path information.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.io.path;

import os.win.base.core,
  os.win.base.string,
  os.win.base.native;
static import std.path;

/// The maximum character length of a path.
const int MaxPath = 260;

/// Returns the current working directory for the current process.
string currentDirectory() ;
alias currentDirectory текПапка;

/// Returns the path of the system directory.
string systemDirectory() ;
alias systemDirectory сисПапка;

/// Returns the path of the system's temporary folder.
string tempPath();
alias tempPath времПапка;

/// Creates a uniquely named temporary file on disk and returns the path of that file.
string tempFileName();
alias tempFileName создВремФайл;

package int getRootLength(string path);

string getPathRoot(string path);

/// Indicates whether the specified _path string contains absolute or relative _path information.
bool isPathRooted(string path) ;
/// Combines two path strings.
string combine(string path1, string path2) ;

string getDirectoryName(string path) ;

/// Returns the file name and extension of the specified _path string.
string getFileName(string path) ;

/// Returns the absolute _path for the specified _path string.
string getFullPath(string path) ;

/// Specifies constants used to retrieve directory paths to system special folders.
enum SpecialFolder {
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
  Network = 0x0012,                 /// The "_Network" folder.
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

/**
 * Gets the path to the specified system special _folder.
 * Параметры: folder = A constant that identifies a system special _folder.
 * Возвращает: The path to the specified system special _folder, if that _folder exists on your computer; otherwise, an empty string.
 */
string getFolderPath(SpecialFolder folder);