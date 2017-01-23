// Microsoft Shell Controls And Automation
// Version 1.0

/*[uuid("50a7e9b0-70ef-11d1-b75a-00a0c90564fe")]*/
module sys.COM.shell32;

/*[importlib("STDOLE2.TLB")]*/
package import 	sys.WinStructs, sys.WinConsts, sys.WinFuncs, sys.WinIfaces, sys.uuid, tpl.com;


extern (C) extern КЛСИД CLSID_Shell;

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
interface IFolderViewOC : ИДиспетчер {
  mixin(ууид("9ba05970-f6a8-11cf-a442-00a0c90a8f39"));
  // Set the ShellFolderView object to monitor events of.
  /*[id(0x60020000)]*/ цел SetFolderView(ИДиспетчер pdisp);
}

// Event interface for ShellFolderView
interface DShellFolderViewEvents : ИДиспетчер {
  mixin(ууид("62112aa2-ebe4-11cf-a5fb-0020afe7292d"));
  /+// The Selection in the view changed.
  /*[id(0x000000C8)]*/ проц SelectionChanged();+/
  /+// The folder has finished enumerating (flashlight is gone).
  /*[id(0x000000C9)]*/ проц EnumDone();+/
  /+// A verb was invoked on an items in the view (return нет to cancel).
  /*[id(0x000000CA)]*/ крат VerbInvoked();+/
  /+// the default verb (double click) was invoked on an items in the view (return нет to cancel).
  /*[id(0x000000CB)]*/ крат DefaultVerbInvoked();+/
  /+// user started to drag an item (return нет to cancel).
  /*[id(0x000000CC)]*/ крат BeginDrag();+/
}

// Constraint used in search command
interface DFConstraint : ИДиспетчер {
  mixin(ууид("4a3df050-23bd-11d2-939f-00a0c91eedba"));
  // Get the constraint name
  /*[id(0x60020000)]*/ цел get_Name(out шим* pbs);
  // Get the constraint Value
  /*[id(0x60020001)]*/ цел get_Value(out ВАРИАНТ pv);
}

// DocFind automation interface
interface ISearchCommandExt : ИДиспетчер {
  mixin(ууид("1d2efd50-75ce-11d1-b75a-00a0c90564fe"));
  // Clear out the results
  /*[id(0x00000001)]*/ цел ClearResults();
  // Navigate to Search Results
  /*[id(0x00000002)]*/ цел NavigateToSearchResults();
  // Get the progress text
  /*[id(0x00000003)]*/ цел get_ProgressText(out шим* pbs);
  // Save Search
  /*[id(0x00000004)]*/ цел SaveSearch();
  // Get the last error information
  /*[id(0x00000005)]*/ цел GetErrorInfo(out шим* pbs, out цел phr);
  // Search For Files/Folders(0) or Computers(1)
  /*[id(0x00000006)]*/ цел SearchFor(цел iFor);
  // Get Scope information - Indexed/NonIndexed/Mixed
  /*[id(0x00000007)]*/ цел GetScopeInfo(шим* bsScope, out цел pdwScopeInfo);
  // Restore the specified search file.
  /*[id(0x00000008)]*/ цел RestoreSavedSearch(ВАРИАНТ* pvarFile);
  // Start the search
  /*[id(0x00000064)]*/ цел Execute(ВАРИАНТ* RecordsAffected, ВАРИАНТ* Parameters, цел Options);
  // Create a parameter
  /*[id(0x00000065)]*/ цел AddConstraint(шим* Name, ВАРИАНТ Value);
  // Enum through the constraints...
  /*[id(0x00000066)]*/ цел GetNextConstraint(крат fReset, out DFConstraint ppdfc);
}

// Definition of interface FolderItem
interface FolderItem : ИДиспетчер {
  mixin(ууид("fac32c80-cbe4-11ce-8350-444553540000"));
  // Get Application object
  /*[id(0x60020000)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Get display name for item
  /*[id(0x00000000)]*/ цел get_Name(out шим* pbs);
  // Get display name for item
  /*[id(0x00000000)]*/ цел put_Name(шим* pbs);
  // Get the pathname to the item
  /*[id(0x60020004)]*/ цел get_Path(out шим* pbs);
  // If item is link return link object
  /*[id(0x60020005)]*/ цел get_GetLink(out ИДиспетчер ppid);
  // If item is a folder return folder object
  /*[id(0x60020006)]*/ цел get_GetFolder(out ИДиспетчер ppid);
  // Is the item a link?
  /*[id(0x60020007)]*/ цел get_IsLink(out крат pb);
  // Is the item a Folder?
  /*[id(0x60020008)]*/ цел get_IsFolder(out крат pb);
  // Is the item a file system object?
  /*[id(0x60020009)]*/ цел get_IsFileSystem(out крат pb);
  // Is the item browsable?
  /*[id(0x6002000A)]*/ цел get_IsBrowsable(out крат pb);
  // Modification Date?
  /*[id(0x6002000B)]*/ цел get_ModifyDate(out double pdt);
  // Modification Date?
  /*[id(0x6002000B)]*/ цел put_ModifyDate(double pdt);
  // Размер
  /*[id(0x6002000D)]*/ цел get_Size(out цел pul);
  // Type
  /*[id(0x6002000E)]*/ цел get_Type(out шим* pbs);
  // Get the list of verbs for the object
  /*[id(0x6002000F)]*/ цел Verbs(out FolderItemVerbs ppfic);
  // Execute a command on the item
  /*[id(0x60020010)]*/ цел InvokeVerb(ВАРИАНТ vVerb);
}

// Definition of interface FolderItemVerbs
interface FolderItemVerbs : ИДиспетчер {
  mixin(ууид("1f8352c0-50b0-11cf-960c-0080c7f4ee85"));
  // Get count of open folder windows
  /*[id(0x60020000)]*/ цел get_Count(out цел plCount);
  // Get Application object
  /*[id(0x60020001)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Return the specified verb
  /*[id(0x60020003)]*/ цел Item(ВАРИАНТ index, out FolderItemVerb ppid);
  // Enumerates the figures
  /*[id(0xFFFFFFFC)]*/ цел _NewEnum(out Инкогнито ppunk);
}

// Definition of interface FolderItemVerb
interface FolderItemVerb : ИДиспетчер {
  mixin(ууид("08ec3e00-50b0-11cf-960c-0080c7f4ee85"));
  // Get Application object
  /*[id(0x60020000)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Get display name for item
  /*[id(0x00000000)]*/ цел get_Name(out шим* pbs);
  // Execute the verb
  /*[id(0x60020003)]*/ цел DoIt();
}

// Definition of interface FolderItems
interface FolderItems : ИДиспетчер {
  mixin(ууид("744129e0-cbe5-11ce-8350-444553540000"));
  // Get count of items in the folder
  /*[id(0x60020000)]*/ цел get_Count(out цел plCount);
  // Get Application object
  /*[id(0x60020001)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Return the figure for the given index
  /*[id(0x60020003)]*/ цел Item(ВАРИАНТ index, out FolderItem ppid);
  // Enumerates the figures
  /*[id(0xFFFFFFFC)]*/ цел _NewEnum(out Инкогнито ppunk);
}

// Definition of interface Folder
interface Folder : ИДиспетчер {
  mixin(ууид("bbcbde60-c3ff-11ce-8350-444553540000"));
  // Get the display name for the window
  /*[id(0x00000000)]*/ цел get_Title(out шим* pbs);
  // Get Application object
  /*[id(0x60020001)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020002)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020003)]*/ цел get_ParentFolder(out Folder ppsf);
  // The collection of Items in folder
  /*[id(0x60020004)]*/ цел Items(out FolderItems ppid);
  // Parse the name to дай an item.
  /*[id(0x60020005)]*/ цел ParseName(шим* bName, out FolderItem ppid);
  // Create a new sub folder in this folder.
  /*[id(0x60020006)]*/ цел NewFolder(шим* bName, ВАРИАНТ vOptions);
  // Move Items to this folder.
  /*[id(0x60020007)]*/ цел MoveHere(ВАРИАНТ vItem, ВАРИАНТ vOptions);
  // Copy Items to this folder.
  /*[id(0x60020008)]*/ цел CopyHere(ВАРИАНТ vItem, ВАРИАНТ vOptions);
  // Get the details about an item.
  /*[id(0x60020009)]*/ цел GetDetailsOf(ВАРИАНТ vItem, цел iColumn, out шим* pbs);
}

// Definition of interface Folder2
interface Folder2 : Folder {
  mixin(ууид("f0d2d8ef-3890-11d2-bf8b-00c04fb93661"));
  // Folder's FolderItem interface
  /*[id(0x60030000)]*/ цел get_Self(out FolderItem ppfi);
  // Offline status of the server?
  /*[id(0x60030001)]*/ цел get_OfflineStatus(out цел pul);
  // Synchronize all offline files
  /*[id(0x60030002)]*/ цел Synchronize();
  // Should the WebView barricade be shown?
  /*[id(0x00000001)]*/ цел get_HaveToShowWebViewBarricade(out крат pbHaveToShowWebViewBarricade);
  // Call this after the WebView barricade is dismissed by the user
  /*[id(0x60030004)]*/ цел DismissedWebViewBarricade();
}

// Definition of interface Folder version 3
interface Folder3 : Folder2 {
  mixin(ууид("a7ae5f64-c4d7-4d7f-9307-4d24ee54b841"));
  // Ask if the WebView barricade should be shown or not
  /*[id(0x00000002)]*/ цел get_ShowWebViewBarricade(out крат pbShowWebViewBarricade);
  // Ask if the WebView barricade should be shown or not
  /*[id(0x00000002)]*/ цел put_ShowWebViewBarricade(крат pbShowWebViewBarricade);
}

// Definition of interface FolderItem Version 2
interface FolderItem2 : FolderItem {
  mixin(ууид("edc817aa-92b8-11d1-b075-00c04fc33aa5"));
  // Extended version of InvokeVerb
  /*[id(0x60030000)]*/ цел InvokeVerbEx(ВАРИАНТ vVerb, ВАРИАНТ vArgs);
  // Access an extended property
  /*[id(0x60030001)]*/ цел ExtendedProperty(шим* bstrPropName, out ВАРИАНТ pvRet);
}

// Definition of interface FolderItems Version 2
interface FolderItems2 : FolderItems {
  mixin(ууид("c94f0ad0-f363-11d2-a327-00c04f8eec7f"));
  // Extended version of InvokeVerb for a collection of Folder Items
  /*[id(0x60030000)]*/ цел InvokeVerbEx(ВАРИАНТ vVerb, ВАРИАНТ vArgs);
}

// Definition of interface FolderItems Version 3
interface FolderItems3 : FolderItems2 {
  mixin(ууид("eaa7c309-bbec-49d5-821d-64d966cb667f"));
  // Set a wildcard filter to apply to the items returned
  /*[id(0x60040000)]*/ цел Filter(цел grfFlags, шим* bstrFileSpec);
  // Get the list of verbs common to all the items
  /*[id(0x00000000)]*/ цел get_Verbs(out FolderItemVerbs ppfic);
}

// Definition of Shell Link ИДиспетчер interface
interface IShellLinkDual : ИДиспетчер {
  mixin(ууид("88a05c00-f000-11ce-8350-444553540000"));
  // Get the path of the link
  /*[id(0x60020000)]*/ цел get_Path(out шим* pbs);
  // Get the path of the link
  /*[id(0x60020000)]*/ цел put_Path(шим* pbs);
  // Get the description for the link
  /*[id(0x60020002)]*/ цел get_Description(out шим* pbs);
  // Get the description for the link
  /*[id(0x60020002)]*/ цел put_Description(шим* pbs);
  // Get the working directory for the link
  /*[id(0x60020004)]*/ цел get_WorkingDirectory(out шим* pbs);
  // Get the working directory for the link
  /*[id(0x60020004)]*/ цел put_WorkingDirectory(шим* pbs);
  // Get the arguments for the link
  /*[id(0x60020006)]*/ цел get_Arguments(out шим* pbs);
  // Get the arguments for the link
  /*[id(0x60020006)]*/ цел put_Arguments(шим* pbs);
  // Get the Hotkey for the link
  /*[id(0x60020008)]*/ цел get_Hotkey(out цел piHK);
  // Get the Hotkey for the link
  /*[id(0x60020008)]*/ цел put_Hotkey(цел piHK);
  // Get the Show Command for the link
  /*[id(0x6002000A)]*/ цел get_ShowCommand(out цел piShowCommand);
  // Get the Show Command for the link
  /*[id(0x6002000A)]*/ цел put_ShowCommand(цел piShowCommand);
  // Tell the link to resolve itself
  /*[id(0x6002000C)]*/ цел Resolve(цел fFlags);
  // Get the IconLocation for the link
  /*[id(0x6002000D)]*/ цел GetIconLocation(out шим* pbs, out цел piIcon);
  // Set the IconLocation for the link
  /*[id(0x6002000E)]*/ цел SetIconLocation(шим* bs, цел iIcon);
  // Tell the link to save the changes
  /*[id(0x6002000F)]*/ цел Save(ВАРИАНТ vWhere);
}

// Shell Link2 ИДиспетчер interface
interface IShellLinkDual2 : IShellLinkDual {
  mixin(ууид("317ee249-f12e-11d2-b1e4-00c04f8eeb3e"));
  // Get the target of a link object
  /*[id(0x60030000)]*/ цел get_Target(out FolderItem ppfi);
}

// definition of interface IShellFolderViewDual
interface IShellFolderViewDual : ИДиспетчер {
  mixin(ууид("e7a1af80-4d96-11cf-960c-0080c7f4ee85"));
  // Get Application object
  /*[id(0x60020000)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Get the folder being viewed
  /*[id(0x60020002)]*/ цел get_Folder(out Folder ppid);
  // The collection of Selected Items in folder
  /*[id(0x60020003)]*/ цел SelectedItems(out FolderItems ppid);
  // The currently focused item in the folder
  /*[id(0x60020004)]*/ цел get_FocusedItem(out FolderItem ppid);
  // Select the item
  /*[id(0x60020005)]*/ цел SelectItem(ВАРИАНТ* pvfi, цел dwFlags);
  // Show items menu and return command selected
  /*[id(0x60020006)]*/ цел PopupItemMenu(FolderItem pfi, ВАРИАНТ vx, ВАРИАНТ vy, out шим* pbs);
  // Returns the scripting automation model.
  /*[id(0x60020007)]*/ цел get_Script(out ИДиспетчер ppDisp);
  // Returns the view options for showing a folder.
  /*[id(0x60020008)]*/ цел get_ViewOptions(out цел plViewOptions);
}

// definition of interface IShellFolderViewDual2
interface IShellFolderViewDual2 : IShellFolderViewDual {
  mixin(ууид("31c147b6-0ade-4a3c-b514-ddf932ef6d17"));
  // Get Current View Mode
  /*[id(0x60030000)]*/ цел get_CurrentViewMode(out бцел pViewMode);
  // Get Current View Mode
  /*[id(0x60030000)]*/ цел put_CurrentViewMode(бцел pViewMode);
  // Select Item относительный to the Current Item
  /*[id(0x60030002)]*/ цел SelectItemRelative(цел iRelative);
}

// Definition of interface IShellDispatch
interface IShellDispatch : ИДиспетчер {
  mixin(ууид("d8f015c0-c278-11ce-a49e-444553540000"));
  // Get Application object
  /*[id(0x60020000)]*/ цел get_Application(out ИДиспетчер ppid);
  // Get Parent object
  /*[id(0x60020001)]*/ цел get_Parent(out ИДиспетчер ppid);
  // Get special folder from ShellSpecialFolderConstants
  /*[id(0x60020002)]*/ цел NameSpace(ВАРИАНТ vDir, out Folder ppsdf);
  // Browse the name space for a Folder
  /*[id(0x60020003)]*/ цел BrowseForFolder(цел Hwnd, шим* Title, цел Options, ВАРИАНТ RootFolder, out Folder ppsdf);
  // The collection of open folder windows
  /*[id(0x60020004)]*/ цел Windows(out ИДиспетчер ppid);
  // Open a folder
  /*[id(0x60020005)]*/ цел Open(ВАРИАНТ vDir);
  // Explore a folder
  /*[id(0x60020006)]*/ цел Explore(ВАРИАНТ vDir);
  // Minimize all windows
  /*[id(0x60020007)]*/ цел MinimizeAll();
  // Undo Minimize All
  /*[id(0x60020008)]*/ цел UndoMinimizeALL();
  // Bring up the file run
  /*[id(0x60020009)]*/ цел FileRun();
  // Cascade Windows
  /*[id(0x6002000A)]*/ цел CascadeWindows();
  // Tile windows vertically
  /*[id(0x6002000B)]*/ цел TileVertically();
  // Tile windows horizontally
  /*[id(0x6002000C)]*/ цел TileHorizontally();
  // Exit Windows
  /*[id(0x6002000D)]*/ цел ShutdownWindows();
  // Suspend the pc
  /*[id(0x6002000E)]*/ цел Suspend();
  // Eject the pc
  /*[id(0x6002000F)]*/ цел EjectPC();
  // Bring up the Set time dialog
  /*[id(0x60020010)]*/ цел SetTime();
  // Дескр Tray properties
  /*[id(0x60020011)]*/ цел TrayProperties();
  // Display shell help
  /*[id(0x60020012)]*/ цел Help();
  // Find Files
  /*[id(0x60020013)]*/ цел FindFiles();
  // Find a computer
  /*[id(0x60020014)]*/ цел FindComputer();
  // Refresh the menu
  /*[id(0x60020015)]*/ цел RefreshMenu();
  // Run a Control Panel Item
  /*[id(0x60020016)]*/ цел ControlPanelItem(шим* szDir);
}

// Updated IShellDispatch
interface IShellDispatch2 : IShellDispatch {
  mixin(ууид("a4c6892c-3ba9-11d2-9dea-00c04fb16162"));
  // дай restriction settings
  /*[id(0x60030000)]*/ цел IsRestricted(шим* Group, шим* Restriction, out цел plRestrictValue);
  // Execute generic command
  /*[id(0x60030001)]*/ цел ShellExecute(шим* File, ВАРИАНТ vArgs, ВАРИАНТ vDir, ВАРИАНТ vOperation, ВАРИАНТ vShow);
  // Find a Printer in the Directory Service
  /*[id(0x60030002)]*/ цел FindPrinter(шим* Name, шим* location, шим* model);
  // Retrieve info about the user's system
  /*[id(0x60030003)]*/ цел GetSystemInformation(шим* Name, out ВАРИАНТ pv);
  // Start a service by name, and optionally установи it to autostart.
  /*[id(0x60030004)]*/ цел ServiceStart(шим* ServiceName, ВАРИАНТ Persistent, out ВАРИАНТ pSuccess);
  // Stop a service by name, and optionally disable autostart.
  /*[id(0x60030005)]*/ цел ServiceStop(шим* ServiceName, ВАРИАНТ Persistent, out ВАРИАНТ pSuccess);
  // Determine if a service is выполняется by name.
  /*[id(0x60030006)]*/ цел IsServiceRunning(шим* ServiceName, out ВАРИАНТ pRunning);
  // Determine if the current user can start/stop the named service.
  /*[id(0x60030007)]*/ цел CanStartStopService(шим* ServiceName, out ВАРИАНТ pCanStartStop);
  // Show/Hide browser bar.
  /*[id(0x60030008)]*/ цел ShowBrowserBar(шим* bstrClsid, ВАРИАНТ bShow, out ВАРИАНТ pSuccess);
}

// Updated IShellDispatch
interface IShellDispatch3 : IShellDispatch2 {
  mixin(ууид("177160ca-bb5a-411c-841d-bd38facdeaa0"));
  // Add an object to the Recent Docuements
  /*[id(0x60040000)]*/ цел AddToRecent(ВАРИАНТ varFile, шим* bstrCategory);
}

// Updated IShellDispatch
interface IShellDispatch4 : IShellDispatch3 {
  mixin(ууид("efd84b2d-4bcf-4298-be25-eb542a59fbda"));
  // Windows Security
  /*[id(0x60050000)]*/ цел WindowsSecurity();
  // Raise/lower the desktop
  /*[id(0x60050001)]*/ цел ToggleDesktop();
  // Return explorer policy value
  /*[id(0x60050002)]*/ цел ExplorerPolicy(шим* bstrPolicyName, out ВАРИАНТ pValue);
  // Return shell global setting
  /*[id(0x60050003)]*/ цел GetSetting(цел lSetting, out крат pResult);
}

// Event interface for command events
interface DSearchCommandEvents : ИДиспетчер {
  mixin(ууид("60890160-69f0-11d1-b758-00a0c90564fe"));
  /+// Search started.
  /*[id(0x00000001)]*/ цел SearchStart();+/
  /+// Search completed normally.
  /*[id(0x00000002)]*/ цел SearchComplete();+/
  /+// Search cancelled.
  /*[id(0x00000003)]*/ цел SearchAbort();+/
  /+// Recordset changed.
  /*[id(0x00000004)]*/ цел RecordsetUpdate();+/
  /+// The Progress text changed
  /*[id(0x00000005)]*/ цел ProgressTextChanged();+/
  /+// An error has happened.
  /*[id(0x00000006)]*/ цел SearchError();+/
  /+// Criteria and resultes restored from file.
  /*[id(0x00000007)]*/ цел SearchRestored();+/
}

// IFileSearchBand Interface
interface IFileSearchBand : ИДиспетчер {
  mixin(ууид("2d91eea1-9932-11d2-be86-00a0c9a83da1"));
  // method SetFocus
  /*[id(0x00000001)]*/ цел SetFocus();
  // method SetSearchParameters
  /*[id(0x00000002)]*/ цел SetSearchParameters(шим** pbstrSearchID, крат bNavToResults, ВАРИАНТ* pvarScope, ВАРИАНТ* pvarQueryFile);
  // Retrieve the guid of the currently active search.
  /*[id(0x00000003)]*/ цел get_SearchID(out шим* pbstrSearchID);
  // Get the search scope
  /*[id(0x00000004)]*/ цел get_Scope(out ВАРИАНТ pvarScope);
  // Retrieve the file from which the search was restored.
  /*[id(0x00000005)]*/ цел get_QueryFile(out ВАРИАНТ pvarFile);
}

// IWebWizardHost interface
interface IWebWizardHost : ИДиспетчер {
  mixin(ууид("18bcc359-4990-4bfb-b951-3c83702be5f9"));
  /*[id(0x00000000)]*/ цел FinalBack();
  /*[id(0x00000001)]*/ цел FinalNext();
  /*[id(0x00000002)]*/ цел Cancel();
  /*[id(0x00000003)]*/ цел put_Caption(шим* pbstrCaption);
  /*[id(0x00000003)]*/ цел get_Caption(out шим* pbstrCaption);
  /*[id(0x00000004)]*/ цел put_Property(шим* bstrPropertyName, ВАРИАНТ* pvProperty);
  /*[id(0x00000004)]*/ цел get_Property(шим* bstrPropertyName, out ВАРИАНТ pvProperty);
  /*[id(0x00000005)]*/ цел SetWizardButtons(крат vfEnableBack, крат vfEnableNext, крат vfLastPage);
  /*[id(0x00000006)]*/ цел SetHeaderText(шим* bstrHeaderTitle, шим* bstrHeaderSubtitle);
}

// INewWДСобытs interface
interface INewWДСобытs : IWebWizardHost {
  mixin(ууид("0751c551-7568-41c9-8e5b-e22e38919236"));
  /*[id(0x00000007)]*/ цел PassportAuthenticate(шим* bstrSignInUrl, out крат pvfAuthenitcated);
}

// IPassportClientServices
interface IPassportClientServices : ИДиспетчер {
  mixin(ууид("b30f7305-5967-45d1-b7bc-d6eb7163d770"));
  /*[id(0x00000000)]*/ цел MemberExists(шим* bstrUser, шим* bstrPassword, out крат pvfExists);
}

// CoClasses

// Shell Folder View Events Router.
abstract final class ShellFolderViewOC {
  mixin(ууид("9ba05971-f6a8-11cf-a442-00a0c90a8f39"));
  mixin Интерфейсы!(IFolderViewOC);
}

// Shell Folder Item
abstract final class ShellFolderItem {
  mixin(ууид("2fe352ea-fd1f-11d2-b1f4-00c04f8eeb3e"));
  mixin Интерфейсы!(FolderItem2);
}

// Shell Link object
abstract final class ShellLinkObject {
  mixin(ууид("11219420-1768-11d1-95be-00609797ea4f"));
  mixin Интерфейсы!(IShellLinkDual);
}

// Shell Folder View Object
abstract final class ShellFolderView {
  mixin(ууид("62112aa1-ebe4-11cf-a5fb-0020afe7292d"));
  mixin Интерфейсы!(IShellFolderViewDual2);
}

// Shell Object Type Information
abstract final class Shell {
  mixin(ууид("13709620-c279-11ce-a49e-444553540000"));
  mixin Интерфейсы!(IShellDispatch);
}

// ShellDispatch Load in Shell Context
abstract final class ShellDispatchInproc {
  mixin(ууид("0a89a860-d7b1-11ce-8350-444553540000"));
  mixin Интерфейсы!(Инкогнито);
}

abstract final class WebViewFolderContents {
  mixin(ууид("1820fed0-473e-11d0-a96c-00c04fd705a2"));
  mixin Интерфейсы!(IShellFolderViewDual);
}

// Search command object.
abstract final class SearchCommand {
  mixin(ууид("b005e690-678d-11d1-b758-00a0c90564fe"));
  mixin Интерфейсы!(ИДиспетчер);
}

// FileSearchBand Class
abstract final class FileSearchBand {
  mixin(ууид("c4ee31f3-4768-11d2-be5c-00a0c9a83da1"));
  mixin Интерфейсы!(IFileSearchBand);
}

// PassportClientServices Class
abstract final class PassportClientServices {
  mixin(ууид("2d2307c8-7db4-40d6-9100-d52af4f97a5b"));
  mixin Интерфейсы!(IPassportClientServices);
}
