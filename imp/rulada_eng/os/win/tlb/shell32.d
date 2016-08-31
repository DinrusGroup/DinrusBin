// Microsoft Shell Controls And Automation
// Version 1.0

/*[uuid("50a7e9b0-70ef-11d1-b75a-00a0c90564fe")]*/
module os.win.tlb.shell32;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Enums

// Search Command Execute Errors
enum SearchCommandExecuteErrors {
  SCEE_PATHNOTFOUND = 0x00000001,
  SCEE_MAXFILESFOUND = 0x00000002,
  SCEE_INDEXSEARCH = 0x00000003,
  SCEE_CONSTRAINT = 0x00000004,
  SCEE_SCOPEMISMATCH = 0x00000005,
  SCEE_CASESENINDEX = 0x00000006,
  SCEE_INDEXNOTCOMPLETE = 0x00000007,
}

// Constants for Folder2.OfflineStatus
enum OfflineFolderStatus {
  OFS_INACTIVE = 0xFFFFFFFF,
  OFS_ONLINE = 0x00000000,
  OFS_OFFLINE = 0x00000001,
  OFS_SERVERBACK = 0x00000002,
  OFS_DIRTYCACHE = 0x00000003,
}

// Constants for ViewOptions
enum ShellFolderViewOptions {
  SFVVO_SHOWALLOBJECTS = 0x00000001,
  SFVVO_SHOWEXTENSIONS = 0x00000002,
  SFVVO_SHOWCOMPCOLOR = 0x00000008,
  SFVVO_SHOWSYSFILES = 0x00000020,
  SFVVO_WIN95CLASSIC = 0x00000040,
  SFVVO_DOUBLECLICKINWEBVIEW = 0x00000080,
  SFVVO_DESKTOPHTML = 0x00000200,
}

// Constants for Special Folders for open/Explore
enum ShellSpecialFolderConstants {
  ssfDESKTOP = 0x00000000,
  ssfPROGRAMS = 0x00000002,
  ssfCONTROLS = 0x00000003,
  ssfPRINTERS = 0x00000004,
  ssfPERSONAL = 0x00000005,
  ssfFAVORITES = 0x00000006,
  ssfSTARTUP = 0x00000007,
  ssfRECENT = 0x00000008,
  ssfSENDTO = 0x00000009,
  ssfBITBUCKET = 0x0000000A,
  ssfSTARTMENU = 0x0000000B,
  ssfDESKTOPDIRECTORY = 0x00000010,
  ssfDRIVES = 0x00000011,
  ssfNETWORK = 0x00000012,
  ssfNETHOOD = 0x00000013,
  ssfFONTS = 0x00000014,
  ssfTEMPLATES = 0x00000015,
  ssfCOMMONSTARTMENU = 0x00000016,
  ssfCOMMONPROGRAMS = 0x00000017,
  ssfCOMMONSTARTUP = 0x00000018,
  ssfCOMMONDESKTOPDIR = 0x00000019,
  ssfAPPDATA = 0x0000001A,
  ssfPRINTHOOD = 0x0000001B,
  ssfLOCALAPPDATA = 0x0000001C,
  ssfALTSTARTUP = 0x0000001D,
  ssfCOMMONALTSTARTUP = 0x0000001E,
  ssfCOMMONFAVORITES = 0x0000001F,
  ssfINTERNETCACHE = 0x00000020,
  ssfCOOKIES = 0x00000021,
  ssfHISTORY = 0x00000022,
  ssfCOMMONAPPDATA = 0x00000023,
  ssfWINDOWS = 0x00000024,
  ssfSYSTEM = 0x00000025,
  ssfPROGRAMFILES = 0x00000026,
  ssfMYPICTURES = 0x00000027,
  ssfPROFILE = 0x00000028,
  ssfSYSTEMx86 = 0x00000029,
  ssfPROGRAMFILESx86 = 0x00000030,
}

// Interfaces

// Folder View Events Forwarder Object
interface IFolderViewOC : IDispatch {
  mixin(uuid("9ba05970-f6a8-11cf-a442-00a0c90a8f39"));
  // Set the ShellFolderView object to monitor events of.
  /*[id(0x60020000)]*/ int SetFolderView(IDispatch pdisp);
}

// Event interface for ShellFolderView
interface DShellFolderViewEvents : IDispatch {
  mixin(uuid("62112aa2-ebe4-11cf-a5fb-0020afe7292d"));
  /+// The Selection in the view changed.
  /*[id(0x000000C8)]*/ void SelectionChanged();+/
  /+// The folder has finished enumerating (flashlight is gone).
  /*[id(0x000000C9)]*/ void EnumDone();+/
  /+// A verb was invoked on an items in the view (return false to cancel).
  /*[id(0x000000CA)]*/ short VerbInvoked();+/
  /+// the default verb (double click) was invoked on an items in the view (return false to cancel).
  /*[id(0x000000CB)]*/ short DefaultVerbInvoked();+/
  /+// user started to drag an item (return false to cancel).
  /*[id(0x000000CC)]*/ short BeginDrag();+/
}

// Constraint used in search command
interface DFConstraint : IDispatch {
  mixin(uuid("4a3df050-23bd-11d2-939f-00a0c91eedba"));
  // Get the constraint name
  /*[id(0x60020000)]*/ int get_Name(out wchar* pbs);
  // Get the constraint Value
  /*[id(0x60020001)]*/ int get_Value(out VARIANT pv);
}

// DocFind automation interface
interface ISearchCommandExt : IDispatch {
  mixin(uuid("1d2efd50-75ce-11d1-b75a-00a0c90564fe"));
  // Clear out the results
  /*[id(0x00000001)]*/ int ClearResults();
  // Navigate to Search Results
  /*[id(0x00000002)]*/ int NavigateToSearchResults();
  // Get the progress text
  /*[id(0x00000003)]*/ int get_ProgressText(out wchar* pbs);
  // Save Search
  /*[id(0x00000004)]*/ int SaveSearch();
  // Get the last error information
  /*[id(0x00000005)]*/ int GetErrorInfo(out wchar* pbs, out int phr);
  // Search For Files/Folders(0) or Computers(1)
  /*[id(0x00000006)]*/ int SearchFor(int iFor);
  // Get Scope information - Indexed/NonIndexed/Mixed
  /*[id(0x00000007)]*/ int GetScopeInfo(wchar* bsScope, out int pdwScopeInfo);
  // Restore the specified search file.
  /*[id(0x00000008)]*/ int RestoreSavedSearch(VARIANT* pvarFile);
  // Start the search
  /*[id(0x00000064)]*/ int Execute(VARIANT* RecordsAffected, VARIANT* Parameters, int Options);
  // Create a parameter
  /*[id(0x00000065)]*/ int AddConstraint(wchar* Name, VARIANT Value);
  // Enum through the constraints...
  /*[id(0x00000066)]*/ int GetNextConstraint(short fReset, out DFConstraint ppdfc);
}

// Definition of interface FolderItem
interface FolderItem : IDispatch {
  mixin(uuid("fac32c80-cbe4-11ce-8350-444553540000"));
  // Get Application object
  /*[id(0x60020000)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ int get_Parent(out IDispatch ppid);
  // Get display name for item
  /*[id(0x00000000)]*/ int get_Name(out wchar* pbs);
  // Get display name for item
  /*[id(0x00000000)]*/ int put_Name(wchar* pbs);
  // Get the pathname to the item
  /*[id(0x60020004)]*/ int get_Path(out wchar* pbs);
  // If item is link return link object
  /*[id(0x60020005)]*/ int get_GetLink(out IDispatch ppid);
  // If item is a folder return folder object
  /*[id(0x60020006)]*/ int get_GetFolder(out IDispatch ppid);
  // Is the item a link?
  /*[id(0x60020007)]*/ int get_IsLink(out short pb);
  // Is the item a Folder?
  /*[id(0x60020008)]*/ int get_IsFolder(out short pb);
  // Is the item a file system object?
  /*[id(0x60020009)]*/ int get_IsFileSystem(out short pb);
  // Is the item browsable?
  /*[id(0x6002000A)]*/ int get_IsBrowsable(out short pb);
  // Modification Date?
  /*[id(0x6002000B)]*/ int get_ModifyDate(out double pdt);
  // Modification Date?
  /*[id(0x6002000B)]*/ int put_ModifyDate(double pdt);
  // Size
  /*[id(0x6002000D)]*/ int get_Size(out int pul);
  // Type
  /*[id(0x6002000E)]*/ int get_Type(out wchar* pbs);
  // Get the list of verbs for the object
  /*[id(0x6002000F)]*/ int Verbs(out FolderItemVerbs ppfic);
  // Execute a command on the item
  /*[id(0x60020010)]*/ int InvokeVerb(VARIANT vVerb);
}

// Definition of interface FolderItemVerbs
interface FolderItemVerbs : IDispatch {
  mixin(uuid("1f8352c0-50b0-11cf-960c-0080c7f4ee85"));
  // Get count of open folder windows
  /*[id(0x60020000)]*/ int get_Count(out int plCount);
  // Get Application object
  /*[id(0x60020001)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ int get_Parent(out IDispatch ppid);
  // Return the specified verb
  /*[id(0x60020003)]*/ int Item(VARIANT index, out FolderItemVerb ppid);
  // Enumerates the figures
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown ppunk);
}

// Definition of interface FolderItemVerb
interface FolderItemVerb : IDispatch {
  mixin(uuid("08ec3e00-50b0-11cf-960c-0080c7f4ee85"));
  // Get Application object
  /*[id(0x60020000)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ int get_Parent(out IDispatch ppid);
  // Get display name for item
  /*[id(0x00000000)]*/ int get_Name(out wchar* pbs);
  // Execute the verb
  /*[id(0x60020003)]*/ int DoIt();
}

// Definition of interface FolderItems
interface FolderItems : IDispatch {
  mixin(uuid("744129e0-cbe5-11ce-8350-444553540000"));
  // Get count of items in the folder
  /*[id(0x60020000)]*/ int get_Count(out int plCount);
  // Get Application object
  /*[id(0x60020001)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ int get_Parent(out IDispatch ppid);
  // Return the figure for the given index
  /*[id(0x60020003)]*/ int Item(VARIANT index, out FolderItem ppid);
  // Enumerates the figures
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown ppunk);
}

// Definition of interface Folder
interface Folder : IDispatch {
  mixin(uuid("bbcbde60-c3ff-11ce-8350-444553540000"));
  // Get the display name for the window
  /*[id(0x00000000)]*/ int get_Title(out wchar* pbs);
  // Get Application object
  /*[id(0x60020001)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ int get_Parent(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020003)]*/ int get_ParentFolder(out Folder ppsf);
  // The collection of Items in folder
  /*[id(0x60020004)]*/ int Items(out FolderItems ppid);
  // Parse the name to get an item.
  /*[id(0x60020005)]*/ int ParseName(wchar* bName, out FolderItem ppid);
  // Create a new sub folder in this folder.
  /*[id(0x60020006)]*/ int NewFolder(wchar* bName, VARIANT vOptions);
  // Move Items to this folder.
  /*[id(0x60020007)]*/ int MoveHere(VARIANT vItem, VARIANT vOptions);
  // Copy Items to this folder.
  /*[id(0x60020008)]*/ int CopyHere(VARIANT vItem, VARIANT vOptions);
  // Get the details about an item.
  /*[id(0x60020009)]*/ int GetDetailsOf(VARIANT vItem, int iColumn, out wchar* pbs);
}

// Definition of interface Folder2
interface Folder2 : Folder {
  mixin(uuid("f0d2d8ef-3890-11d2-bf8b-00c04fb93661"));
  // Folder's FolderItem interface
  /*[id(0x60030000)]*/ int get_Self(out FolderItem ppfi);
  // Offline status of the server?
  /*[id(0x60030001)]*/ int get_OfflineStatus(out int pul);
  // Synchronize all offline files
  /*[id(0x60030002)]*/ int Synchronize();
  // Should the WebView barricade be shown?
  /*[id(0x00000001)]*/ int get_HaveToShowWebViewBarricade(out short pbHaveToShowWebViewBarricade);
  // Call this after the WebView barricade is dismissed by the user
  /*[id(0x60030004)]*/ int DismissedWebViewBarricade();
}

// Definition of interface Folder version 3
interface Folder3 : Folder2 {
  mixin(uuid("a7ae5f64-c4d7-4d7f-9307-4d24ee54b841"));
  // Ask if the WebView barricade should be shown or not
  /*[id(0x00000002)]*/ int get_ShowWebViewBarricade(out short pbShowWebViewBarricade);
  // Ask if the WebView barricade should be shown or not
  /*[id(0x00000002)]*/ int put_ShowWebViewBarricade(short pbShowWebViewBarricade);
}

// Definition of interface FolderItem Version 2
interface FolderItem2 : FolderItem {
  mixin(uuid("edc817aa-92b8-11d1-b075-00c04fc33aa5"));
  // Extended version of InvokeVerb
  /*[id(0x60030000)]*/ int InvokeVerbEx(VARIANT vVerb, VARIANT vArgs);
  // Access an extended property
  /*[id(0x60030001)]*/ int ExtendedProperty(wchar* bstrPropName, out VARIANT pvRet);
}

// Definition of interface FolderItems Version 2
interface FolderItems2 : FolderItems {
  mixin(uuid("c94f0ad0-f363-11d2-a327-00c04f8eec7f"));
  // Extended version of InvokeVerb for a collection of Folder Items
  /*[id(0x60030000)]*/ int InvokeVerbEx(VARIANT vVerb, VARIANT vArgs);
}

// Definition of interface FolderItems Version 3
interface FolderItems3 : FolderItems2 {
  mixin(uuid("eaa7c309-bbec-49d5-821d-64d966cb667f"));
  // Set a wildcard filter to apply to the items returned
  /*[id(0x60040000)]*/ int Filter(int grfFlags, wchar* bstrFileSpec);
  // Get the list of verbs common to all the items
  /*[id(0x00000000)]*/ int get_Verbs(out FolderItemVerbs ppfic);
}

// Definition of Shell Link IDispatch interface
interface IShellLinkDual : IDispatch {
  mixin(uuid("88a05c00-f000-11ce-8350-444553540000"));
  // Get the path of the link
  /*[id(0x60020000)]*/ int get_Path(out wchar* pbs);
  // Get the path of the link
  /*[id(0x60020000)]*/ int put_Path(wchar* pbs);
  // Get the description for the link
  /*[id(0x60020002)]*/ int get_Description(out wchar* pbs);
  // Get the description for the link
  /*[id(0x60020002)]*/ int put_Description(wchar* pbs);
  // Get the working directory for the link
  /*[id(0x60020004)]*/ int get_WorkingDirectory(out wchar* pbs);
  // Get the working directory for the link
  /*[id(0x60020004)]*/ int put_WorkingDirectory(wchar* pbs);
  // Get the arguments for the link
  /*[id(0x60020006)]*/ int get_Arguments(out wchar* pbs);
  // Get the arguments for the link
  /*[id(0x60020006)]*/ int put_Arguments(wchar* pbs);
  // Get the Hotkey for the link
  /*[id(0x60020008)]*/ int get_Hotkey(out int piHK);
  // Get the Hotkey for the link
  /*[id(0x60020008)]*/ int put_Hotkey(int piHK);
  // Get the Show Command for the link
  /*[id(0x6002000A)]*/ int get_ShowCommand(out int piShowCommand);
  // Get the Show Command for the link
  /*[id(0x6002000A)]*/ int put_ShowCommand(int piShowCommand);
  // Tell the link to resolve itself
  /*[id(0x6002000C)]*/ int Resolve(int fFlags);
  // Get the IconLocation for the link
  /*[id(0x6002000D)]*/ int GetIconLocation(out wchar* pbs, out int piIcon);
  // Set the IconLocation for the link
  /*[id(0x6002000E)]*/ int SetIconLocation(wchar* bs, int iIcon);
  // Tell the link to save the changes
  /*[id(0x6002000F)]*/ int Save(VARIANT vWhere);
}

// Shell Link2 IDispatch interface
interface IShellLinkDual2 : IShellLinkDual {
  mixin(uuid("317ee249-f12e-11d2-b1e4-00c04f8eeb3e"));
  // Get the target of a link object
  /*[id(0x60030000)]*/ int get_Target(out FolderItem ppfi);
}

// definition of interface IShellFolderViewDual
interface IShellFolderViewDual : IDispatch {
  mixin(uuid("e7a1af80-4d96-11cf-960c-0080c7f4ee85"));
  // Get Application object
  /*[id(0x60020000)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ int get_Parent(out IDispatch ppid);
  // Get the folder being viewed
  /*[id(0x60020002)]*/ int get_Folder(out Folder ppid);
  // The collection of Selected Items in folder
  /*[id(0x60020003)]*/ int SelectedItems(out FolderItems ppid);
  // The currently focused item in the folder
  /*[id(0x60020004)]*/ int get_FocusedItem(out FolderItem ppid);
  // Select the item
  /*[id(0x60020005)]*/ int SelectItem(VARIANT* pvfi, int dwFlags);
  // Show items menu and return command selected
  /*[id(0x60020006)]*/ int PopupItemMenu(FolderItem pfi, VARIANT vx, VARIANT vy, out wchar* pbs);
  // Returns the scripting automation model.
  /*[id(0x60020007)]*/ int get_Script(out IDispatch ppDisp);
  // Returns the view options for showing a folder.
  /*[id(0x60020008)]*/ int get_ViewOptions(out int plViewOptions);
}

// definition of interface IShellFolderViewDual2
interface IShellFolderViewDual2 : IShellFolderViewDual {
  mixin(uuid("31c147b6-0ade-4a3c-b514-ddf932ef6d17"));
  // Get Current View Mode
  /*[id(0x60030000)]*/ int get_CurrentViewMode(out uint pViewMode);
  // Get Current View Mode
  /*[id(0x60030000)]*/ int put_CurrentViewMode(uint pViewMode);
  // Select Item relative to the Current Item
  /*[id(0x60030002)]*/ int SelectItemRelative(int iRelative);
}

// Definition of interface IShellDispatch
interface IShellDispatch : IDispatch {
  mixin(uuid("d8f015c0-c278-11ce-a49e-444553540000"));
  // Get Application object
  /*[id(0x60020000)]*/ int get_Application(out IDispatch ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ int get_Parent(out IDispatch ppid);
  // Get special folder from ShellSpecialFolderConstants
  /*[id(0x60020002)]*/ int NameSpace(VARIANT vDir, out Folder ppsdf);
  // Browse the name space for a Folder
  /*[id(0x60020003)]*/ int BrowseForFolder(int Hwnd, wchar* Title, int Options, VARIANT RootFolder, out Folder ppsdf);
  // The collection of open folder windows
  /*[id(0x60020004)]*/ int Windows(out IDispatch ppid);
  // Open a folder
  /*[id(0x60020005)]*/ int Open(VARIANT vDir);
  // Explore a folder
  /*[id(0x60020006)]*/ int Explore(VARIANT vDir);
  // Minimize all windows
  /*[id(0x60020007)]*/ int MinimizeAll();
  // Undo Minimize All
  /*[id(0x60020008)]*/ int UndoMinimizeALL();
  // Bring up the file run
  /*[id(0x60020009)]*/ int FileRun();
  // Cascade Windows
  /*[id(0x6002000A)]*/ int CascadeWindows();
  // Tile windows vertically
  /*[id(0x6002000B)]*/ int TileVertically();
  // Tile windows horizontally
  /*[id(0x6002000C)]*/ int TileHorizontally();
  // Exit Windows
  /*[id(0x6002000D)]*/ int ShutdownWindows();
  // Suspend the pc
  /*[id(0x6002000E)]*/ int Suspend();
  // Eject the pc
  /*[id(0x6002000F)]*/ int EjectPC();
  // Bring up the Set time dialog
  /*[id(0x60020010)]*/ int SetTime();
  // Handle Tray properties
  /*[id(0x60020011)]*/ int TrayProperties();
  // Display shell help
  /*[id(0x60020012)]*/ int Help();
  // Find Files
  /*[id(0x60020013)]*/ int FindFiles();
  // Find a computer
  /*[id(0x60020014)]*/ int FindComputer();
  // Refresh the menu
  /*[id(0x60020015)]*/ int RefreshMenu();
  // Run a Control Panel Item
  /*[id(0x60020016)]*/ int ControlPanelItem(wchar* szDir);
}

// Updated IShellDispatch
interface IShellDispatch2 : IShellDispatch {
  mixin(uuid("a4c6892c-3ba9-11d2-9dea-00c04fb16162"));
  // get restriction settings
  /*[id(0x60030000)]*/ int IsRestricted(wchar* Group, wchar* Restriction, out int plRestrictValue);
  // Execute generic command
  /*[id(0x60030001)]*/ int ShellExecute(wchar* File, VARIANT vArgs, VARIANT vDir, VARIANT vOperation, VARIANT vShow);
  // Find a Printer in the Directory Service
  /*[id(0x60030002)]*/ int FindPrinter(wchar* Name, wchar* location, wchar* model);
  // Retrieve info about the user's system
  /*[id(0x60030003)]*/ int GetSystemInformation(wchar* Name, out VARIANT pv);
  // Start a service by name, and optionally set it to autostart.
  /*[id(0x60030004)]*/ int ServiceStart(wchar* ServiceName, VARIANT Persistent, out VARIANT pSuccess);
  // Stop a service by name, and optionally disable autostart.
  /*[id(0x60030005)]*/ int ServiceStop(wchar* ServiceName, VARIANT Persistent, out VARIANT pSuccess);
  // Determine if a service is running by name.
  /*[id(0x60030006)]*/ int IsServiceRunning(wchar* ServiceName, out VARIANT pRunning);
  // Determine if the current user can start/stop the named service.
  /*[id(0x60030007)]*/ int CanStartStopService(wchar* ServiceName, out VARIANT pCanStartStop);
  // Show/Hide browser bar.
  /*[id(0x60030008)]*/ int ShowBrowserBar(wchar* bstrClsid, VARIANT bShow, out VARIANT pSuccess);
}

// Updated IShellDispatch
interface IShellDispatch3 : IShellDispatch2 {
  mixin(uuid("177160ca-bb5a-411c-841d-bd38facdeaa0"));
  // Add an object to the Recent Docuements
  /*[id(0x60040000)]*/ int AddToRecent(VARIANT varFile, wchar* bstrCategory);
}

// Updated IShellDispatch
interface IShellDispatch4 : IShellDispatch3 {
  mixin(uuid("efd84b2d-4bcf-4298-be25-eb542a59fbda"));
  // Windows Security
  /*[id(0x60050000)]*/ int WindowsSecurity();
  // Raise/lower the desktop
  /*[id(0x60050001)]*/ int ToggleDesktop();
  // Return explorer policy value
  /*[id(0x60050002)]*/ int ExplorerPolicy(wchar* bstrPolicyName, out VARIANT pValue);
  // Return shell global setting
  /*[id(0x60050003)]*/ int GetSetting(int lSetting, out short pResult);
}

// Event interface for command events
interface DSearchCommandEvents : IDispatch {
  mixin(uuid("60890160-69f0-11d1-b758-00a0c90564fe"));
  /+// Search started.
  /*[id(0x00000001)]*/ int SearchStart();+/
  /+// Search completed normally.
  /*[id(0x00000002)]*/ int SearchComplete();+/
  /+// Search cancelled.
  /*[id(0x00000003)]*/ int SearchAbort();+/
  /+// Recordset changed.
  /*[id(0x00000004)]*/ int RecordsetUpdate();+/
  /+// The Progress text changed
  /*[id(0x00000005)]*/ int ProgressTextChanged();+/
  /+// An error has happened.
  /*[id(0x00000006)]*/ int SearchError();+/
  /+// Criteria and resultes restored from file.
  /*[id(0x00000007)]*/ int SearchRestored();+/
}

// IFileSearchBand Interface
interface IFileSearchBand : IDispatch {
  mixin(uuid("2d91eea1-9932-11d2-be86-00a0c9a83da1"));
  // method SetFocus
  /*[id(0x00000001)]*/ int SetFocus();
  // method SetSearchParameters
  /*[id(0x00000002)]*/ int SetSearchParameters(wchar** pbstrSearchID, short bNavToResults, VARIANT* pvarScope, VARIANT* pvarQueryFile);
  // Retrieve the guid of the currently active search.
  /*[id(0x00000003)]*/ int get_SearchID(out wchar* pbstrSearchID);
  // Get the search scope
  /*[id(0x00000004)]*/ int get_Scope(out VARIANT pvarScope);
  // Retrieve the file from which the search was restored.
  /*[id(0x00000005)]*/ int get_QueryFile(out VARIANT pvarFile);
}

// IWebWizardHost interface
interface IWebWizardHost : IDispatch {
  mixin(uuid("18bcc359-4990-4bfb-b951-3c83702be5f9"));
  /*[id(0x00000000)]*/ int FinalBack();
  /*[id(0x00000001)]*/ int FinalNext();
  /*[id(0x00000002)]*/ int Cancel();
  /*[id(0x00000003)]*/ int put_Caption(wchar* pbstrCaption);
  /*[id(0x00000003)]*/ int get_Caption(out wchar* pbstrCaption);
  /*[id(0x00000004)]*/ int put_Property(wchar* bstrPropertyName, VARIANT* pvProperty);
  /*[id(0x00000004)]*/ int get_Property(wchar* bstrPropertyName, out VARIANT pvProperty);
  /*[id(0x00000005)]*/ int SetWizardButtons(short vfEnableBack, short vfEnableNext, short vfLastPage);
  /*[id(0x00000006)]*/ int SetHeaderText(wchar* bstrHeaderTitle, wchar* bstrHeaderSubtitle);
}

// INewWDEvents interface
interface INewWDEvents : IWebWizardHost {
  mixin(uuid("0751c551-7568-41c9-8e5b-e22e38919236"));
  /*[id(0x00000007)]*/ int PassportAuthenticate(wchar* bstrSignInUrl, out short pvfAuthenitcated);
}

// IPassportClientServices
interface IPassportClientServices : IDispatch {
  mixin(uuid("b30f7305-5967-45d1-b7bc-d6eb7163d770"));
  /*[id(0x00000000)]*/ int MemberExists(wchar* bstrUser, wchar* bstrPassword, out short pvfExists);
}

// CoClasses

// Shell Folder View Events Router.
abstract final class ShellFolderViewOC {
  mixin(uuid("9ba05971-f6a8-11cf-a442-00a0c90a8f39"));
  mixin Interfaces!(IFolderViewOC);
}

// Shell Folder Item
abstract final class ShellFolderItem {
  mixin(uuid("2fe352ea-fd1f-11d2-b1f4-00c04f8eeb3e"));
  mixin Interfaces!(FolderItem2);
}

// Shell Link object
abstract final class ShellLinkObject {
  mixin(uuid("11219420-1768-11d1-95be-00609797ea4f"));
  mixin Interfaces!(IShellLinkDual);
}

// Shell Folder View Object
abstract final class ShellFolderView {
  mixin(uuid("62112aa1-ebe4-11cf-a5fb-0020afe7292d"));
  mixin Interfaces!(IShellFolderViewDual2);
}

// Shell Object Type Information
abstract final class Shell {
  mixin(uuid("13709620-c279-11ce-a49e-444553540000"));
  mixin Interfaces!(IShellDispatch);
}

// ShellDispatch Load in Shell Context
abstract final class ShellDispatchInproc {
  mixin(uuid("0a89a860-d7b1-11ce-8350-444553540000"));
  mixin Interfaces!(IUnknown);
}

abstract final class WebViewFolderContents {
  mixin(uuid("1820fed0-473e-11d0-a96c-00c04fd705a2"));
  mixin Interfaces!(IShellFolderViewDual);
}

// Search command object.
abstract final class SearchCommand {
  mixin(uuid("b005e690-678d-11d1-b758-00a0c90564fe"));
  mixin Interfaces!(IDispatch);
}

// FileSearchBand Class
abstract final class FileSearchBand {
  mixin(uuid("c4ee31f3-4768-11d2-be5c-00a0c9a83da1"));
  mixin Interfaces!(IFileSearchBand);
}

// PassportClientServices Class
abstract final class PassportClientServices {
  mixin(uuid("2d2307c8-7db4-40d6-9100-d52af4f97a5b"));
  mixin Interfaces!(IPassportClientServices);
}
