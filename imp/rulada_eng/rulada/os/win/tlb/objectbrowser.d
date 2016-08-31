// Desert Hill ObjectBrowser Control
// Version 1.0

/*[uuid("cc50f36d-291d-4605-917c-26ea457cbd99")]*/
module os.win.tlb.objectbrowser;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Enums

// Constants that define a data type.
enum DataType {
  obEmpty = 0x00000000,
  obNull = 0x00000001,
  obInteger = 0x00000002,
  obLong = 0x00000003,
  obFloat = 0x00000004,
  obDouble = 0x00000005,
  obCurrency = 0x00000006,
  obDate = 0x00000007,
  obString = 0x00000008,
  obObject = 0x00000009,
  obError = 0x0000000A,
  obBoolean = 0x0000000B,
  obVariant = 0x0000000C,
  obDataObject = 0x0000000D,
  obDecimal = 0x0000000E,
  obUnspecified = 0x0000000F,
  obSignedChar = 0x00000010,
  obUnsignedChar = 0x00000011,
  obUnsignedShort = 0x00000012,
  obUnsignedLong = 0x00000013,
  obSignedDoubleLong = 0x00000014,
  obUnsignedDoubleLong = 0x00000015,
  obInt = 0x00000016,
  obUnsignedInt = 0x00000017,
  obVoid = 0x00000018,
  obHResult = 0x00000019,
  obPointer = 0x0000001A,
  obSafeArray = 0x0000001B,
  obCArray = 0x0000001C,
  obUserDefined = 0x0000001D,
  obCString = 0x0000001E,
  obWideCString = 0x0000001F,
}

// Constants that define the type of a function.
enum FunctionType {
  obFT_NotFunction = 0xFFFFFFFF,
  obFT_Method = 0x00000001,
  obFT_PropertyGet = 0x00000002,
  obFT_PropertyPut = 0x00000004,
  obFT_PropertyPutByRef = 0x00000008,
}

// Constants that define the type of function access.
enum FunctionAccess {
  obNoAccess = 0xFFFFFFFF,
  obVirtual = 0x00000000,
  obPureVirtual = 0x00000001,
  obNonVirtual = 0x00000002,
  obStatic = 0x00000003,
  obDispatchOnly = 0x00000004,
}

// Constants that define the type of a variable.
enum VariableType {
  obVT_NotVariable = 0xFFFFFFFF,
  obVT_Instance = 0x00000000,
  obVT_Static = 0x00000001,
  obVT_Constant = 0x00000002,
  obVT_Dispatch = 0x00000003,
}

// Constants that define the type of member item.
enum MemberItemType {
  obVariable = 0x00000000,
  obStaticVar = 0x00000001,
  obProperty = 0x00000002,
  obMethod = 0x00000003,
  obEvent = 0x00000004,
  obConstant = 0x00000005,
}

// Constants that define the type of a member.
enum MemberType {
  obEnumeration = 0x00000000,
  obDefinedType = 0x00000001,
  obModule = 0x00000002,
  obCustomInterface = 0x00000003,
  obDispatchInterface = 0x00000004,
  obClass = 0x00000005,
  obAlias = 0x00000006,
  obUnion = 0x00000007,
}

// Constants that define the different panes.
enum ViewPane {
  obLibaryPane = 0x00000000,
  obMemberPane = 0x00000001,
  obDetailsPane = 0x00000002,
  obFindResultsPane = 0x00000003,
}

// Constants that define the toolbar elements.
enum ToolbarElement {
  obLibaryList = 0x00000001,
  obBack = 0x00000002,
  obForward = 0x00000004,
  obFindList = 0x00000008,
  obGoFind = 0x00000010,
  obShowHidden = 0x00000020,
  obGroupMembers = 0x00000040,
  obCopy = 0x00000080,
  obUse = 0x00000100,
}

// Structs

// Data describing the type of a variable.
struct DataTypeInfo {
  mixin(uuid("2f53c1ba-602e-45c0-9c99-6271df46fd2b"));
  DataType Type;
  DataType ResolvedType;
  wchar* Name;
  int PointerLevels;
}

struct _GUID {
  uint Data1;
  ushort Data2;
  ushort Data3;
  ubyte[8] Data4;
}

// Interfaces

// Event interface for the ObjectBrowser object.
interface IObjectBrowserEvents : IDispatch {
  mixin(uuid("a842a0b9-e9b9-491f-afa5-dcd78f7a9fd6"));
  /+// Occurs when an item in the ObjectBrowser is selected.
  /*[id(0x00000001)]*/ void LibrarySelected(ILibrary objLibrary);+/
  /+// Occurs when an item in the ObjectBrowser is selected.
  /*[id(0x00000002)]*/ void MemberSelected(IMember objMember);+/
  /+// Occurs when an item in the ObjectBrowser is selected.
  /*[id(0x00000003)]*/ void MemberItemSelected(IMemberItem objMemberItem);+/
  /+// Occurs when All Libraries is selected from the library list.
  /*[id(0x00000004)]*/ void AllLibrariesSelected();+/
  /+// Occurs when a Globals is selected from the classes list.
  /*[id(0x00000005)]*/ void GlobalsSelected();+/
  /+// Occurs when a Globals is selected from the classes list when All Libraries is selected.
  /*[id(0x00000006)]*/ void AllGlobalsSelected();+/
  /+// Occurs when a search begins.
  /*[id(0x00000007)]*/ void SearchBegin();+/
  /+// Occurs when a search ends.
  /*[id(0x00000008)]*/ void SearchEnd();+/
  /+// Occurs when a match is found as a result of a search.
  /*[id(0x00000009)]*/ void SearchResultLibrary(ILibrary objLibrary);+/
  /+// Occurs when a match is found as a result of a search.
  /*[id(0x0000000A)]*/ void SearchResultMember(IMember objMember);+/
  /+// Occurs when a match is found as a result of a search.
  /*[id(0x0000000B)]*/ void SearchResultMemberItem(IMemberItem objMemberItem);+/
  /+// Occurs when the use button pressed from the toolbar.
  /*[id(0x0000000C)]*/ void UseLibrary(ILibrary objLibrary);+/
  /+// Occurs when the use button pressed from the toolbar.
  /*[id(0x0000000D)]*/ void UseMember(IMember objMember);+/
  /+// Occurs when the use button pressed from the toolbar.
  /*[id(0x0000000E)]*/ void UseMemberItem(IMemberItem objMemberItem);+/
  /+// Occurs when a mouse event takes place on the control.
  /*[id(0xFFFFFDA3)]*/ void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+// Occurs when a mouse event takes place on the control.
  /*[id(0xFFFFFDA1)]*/ void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+// Occurs when a mouse event takes place on the control.
  /*[id(0xFFFFFDA2)]*/ void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+// Occurs when a keyboard event takes place on the control.
  /*[id(0xFFFFFDA6)]*/ void KeyDown(short KeyCode, short Shift);+/
  /+// Occurs when a keyboard event takes place on the control.
  /*[id(0xFFFFFDA4)]*/ void KeyUp(short KeyCode, short Shift);+/
  /+// Occurs when a keyboard event takes place on the control.
  /*[id(0xFFFFFDA5)]*/ void KeyPress(short KeyAscii);+/
  /+// Occurs when a library has been added to the control.
  /*[id(0x00000013)]*/ void LibraryAdded(ILibrary objLibrary);+/
  /+// Occurs when a library has been removed from the control.
  /*[id(0x00000014)]*/ void LibraryRemoved(ILibrary objLibrary);+/
  /+// Occurs when all libraries has been cleared.
  /*[id(0x00000015)]*/ void LibrariesCleared();+/
}

// Default interface for the ObjectBrowser Library object.
interface ILibrary : IDispatch {
  mixin(uuid("610d8959-18fd-4eb0-af4d-6b6f7b806cd1"));
  // Returns the name used in code to identify an object.
  /*[id(0x00000001)]*/ int get_Name(out wchar* pVal);
  // Returns the help string for the member.
  /*[id(0x00000002)]*/ int get_HelpString(out wchar* pVal);
  // Returns the help context Id for the member.
  /*[id(0x00000003)]*/ int get_HelpContext(out int pVal);
  // Returns the help file for the member.
  /*[id(0x00000004)]*/ int get_HelpFile(out wchar* pVal);
  // Returns the major version of the member.
  /*[id(0x00000005)]*/ int get_MajorVersion(out int pVal);
  // Returns the minor version of the member.
  /*[id(0x00000006)]*/ int get_MinorVersion(out int pVal);
  // Returns/Sets the library associated with the Library object.
  /*[id(0x00000007)]*/ int put_TypeLib(VARIANT newVal);
  // Returns a reference to a collection of Class objects.
  /*[id(0x00000008)]*/ int get_Classes(out IMembers ppVal);
  // Returns a reference to a collection of enumeration Member objects.
  /*[id(0x00000009)]*/ int get_Enumerations(out IMembers ppVal);
  // Returns a reference to a collection of user defined type Member objects.
  /*[id(0x0000000A)]*/ int get_DefinedTypes(out IMembers ppVal);
  // Returns a reference to a collection of custom Interface objects.
  /*[id(0x0000000B)]*/ int get_CustomInterfaces(out IMembers ppVal);
  // Returns a reference to a collection of dispatch Interface objects.
  /*[id(0x0000000C)]*/ int get_DispatchInterfaces(out IMembers ppVal);
  // Returns a reference to a collection of module Member objects.
  /*[id(0x0000000D)]*/ int get_Modules(out IMembers ppVal);
  // Returns a reference to a collection of alias Member objects.
  /*[id(0x0000000E)]*/ int get_Aliases(out IMembers ppVal);
  // Returns a reference to a collection of union Member objects.
  /*[id(0x0000000F)]*/ int get_Unions(out IMembers ppVal);
  // Returns a reference to a collection of Member objects.
  /*[id(0x00000010)]*/ int get_Members(out IMembers ppVal);
  // Returns a reference to a collection of Member objects of the specified type.
  /*[id(0x00000011)]*/ int get_TypedMembers(MemberType Type, out IMembers ppVal);
  // Returns LocaleID of the member.
  /*[id(0x00000012)]*/ int get_LocaleID(out int pVal);
  // Returns the GUID of the member.
  /*[id(0x00000013)]*/ int get_GUID(out wchar* pVal);
  // Returns the path of the registered type library associated with the Library object.
  /*[id(0x00000014)]*/ int get_Path(out wchar* pVal);
  // Returns whether the member is restricted, and should not be displayed to users.
  /*[id(0x00000015)]*/ int get_Restricted(out short pVal);
  // Returns whether the member describes a control.
  /*[id(0x00000016)]*/ int get_Control(out short pVal);
  // Returns whether the member is hidden, and should not be displayed to users, although its use is not restricted.
  /*[id(0x00000017)]*/ int get_Hidden(out short pVal);
  // Attribute of a type library.
  /*[id(0x00000018)]*/ int get_HasDiskImage(out short pVal);
  // Returns the GUID of the member.
  /*[id(0x00000019)]*/ int get__GUID(out _GUID pVal);
  // Returns the version of the member.
  /*[id(0x0000001A)]*/ int get_Version(out wchar* pVal);
  // Returns a reference to a collection of Interface objects.
  /*[id(0x0000001B)]*/ int get_Interfaces(out IMembers ppVal);
  // Returns a reference to a collection of dispatch Interface objects that are not dual.
  /*[id(0x0000001C)]*/ int get_DispatchOnlyInterfaces(out IMembers ppVal);
  // Returns a reference to a collection of dispatch Interface objects that are dual.
  /*[id(0x0000001D)]*/ int get_DualInterfaces(out IMembers ppVal);
  // Returns/Sets the library associated with the Library object.
  /*[id(0x00000007)]*/ int get_TypeLib(out VARIANT newVal);
  // Returns the name used in code to identify an object.
  /*[id(0x00000001)]*/ int put_Name(wchar* pVal);
}

// Default interface for the ObjectBrowser Members collection.
interface IMembers : IDispatch {
  mixin(uuid("7792aedd-3f58-4747-bc66-47c39ddbbb56"));
  // Returns a specific item of a Collection object either by position or by key.
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out IMember ppVal);
  // Used for internal support of For Each syntax.
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown ppVal);
  // Returns the number of objects in the collection.
  /*[id(0x00000001)]*/ int get_Count(out int pVal);
}

// Default interface for the ObjectBrowser Member object.
interface IMember : IDispatch {
  mixin(uuid("4e6f6560-bb9d-4b40-b2e4-60e70a9893cc"));
  // Returns the name used in code to identify an object.
  /*[id(0x00000001)]*/ int get_Name(out wchar* pVal);
  // Returns the help string for the member.
  /*[id(0x00000002)]*/ int get_HelpString(out wchar* pVal);
  // Returns the help context Id for the member.
  /*[id(0x00000003)]*/ int get_HelpContext(out int pVal);
  // Returns the help file for the member.
  /*[id(0x00000004)]*/ int get_HelpFile(out wchar* pVal);
  // Returns a reference to a collection of MemberItem objects that are functions.
  /*[id(0x00000005)]*/ int get_Functions(out IMemberItems ppVal);
  // Returns a reference to a collection of MemberItem objects that are variables.
  /*[id(0x00000006)]*/ int get_Variables(out IMemberItems ppVal);
  // Returns a value indicating the type of the member.
  /*[id(0x00000007)]*/ int get_Type(out MemberType pVal);
  // Returns a reference to the object's parent.
  /*[id(0xFFFFFCDD)]*/ int get_Parent(out ILibrary ppVal);
  // Returns LocaleID of the member.
  /*[id(0x00000009)]*/ int get_LocaleID(out int pVal);
  // Returns the GUID of the member.
  /*[id(0x0000000A)]*/ int get_GUID(out wchar* pVal);
  // Returns the id of the member's constructor.
  /*[id(0x0000000B)]*/ int get_ConstructorMemberID(out int pVal);
  // Returns the id of the member's destructor.
  /*[id(0x0000000C)]*/ int get_DestructorMemberID(out int pVal);
  // Returns the schema of the member.
  /*[id(0x0000000D)]*/ int get_Schema(out wchar* pVal);
  // Returns the size of and instance of the member.
  /*[id(0x0000000E)]*/ int get_InstanceSize(out int pVal);
  // Returns the size of the member's vector table.
  /*[id(0x0000000F)]*/ int get_VTableSize(out int pVal);
  // Returns the byte alignment of the member.
  /*[id(0x00000010)]*/ int get_ByteAlignment(out int pVal);
  // Returns the major version of the member.
  /*[id(0x00000011)]*/ int get_MajorVersion(out int pVal);
  // Returns the minor version of the member.
  /*[id(0x00000012)]*/ int get_MinorVersion(out int pVal);
  // Returns whether the member is licensed.
  /*[id(0x00000013)]*/ int get_Licensed(out short pVal);
  // Returns whether the member is hidden, and should not be displayed to users, although its use is not restricted.
  /*[id(0x00000014)]*/ int get_Hidden(out short pVal);
  // Returns whether the member is restricted, and should not be displayed to users.
  /*[id(0x00000015)]*/ int get_Restricted(out short pVal);
  // Returns whether the member describes a control.
  /*[id(0x00000016)]*/ int get_Control(out short pVal);
  // Returns whether the Member is the application object.
  /*[id(0x00000017)]*/ int get_ApplicationObject(out short pVal);
  // Returns whether the member can be created.
  /*[id(0x00000018)]*/ int get_Creatable(out short pVal);
  // Returns whether the member is predefined.
  /*[id(0x00000019)]*/ int get_Predefined(out short pVal);
  // Returns whether the member is dual interface.
  /*[id(0x0000001A)]*/ int get_Dual(out short pVal);
  // Returns whether the member can be extended.
  /*[id(0x0000001B)]*/ int get_Extensible(out short pVal);
  // Returns whether the member is an automation interface.
  /*[id(0x0000001C)]*/ int get_Automation(out short pVal);
  // Returns whether the member supports aggregation.
  /*[id(0x0000001D)]*/ int get_Aggregatable(out short pVal);
  // Returns whether the member has default behavior.
  /*[id(0x0000001E)]*/ int get_Replaceable(out short pVal);
  // Returns whether the member is an interface derived from IDispatch.
  /*[id(0x0000001F)]*/ int get_Dispatchable(out short pVal);
  // Returns whether the member supports reverse binding.
  /*[id(0x00000020)]*/ int get_ReverseBind(out short pVal);
  // Returns information about the type of the alias.
  /*[id(0x00000021)]*/ int get_AliasType(out DataTypeInfo pVal);
  // Returns the GUID of the member.
  /*[id(0x00000022)]*/ int get__GUID(out _GUID pVal);
  // Returns a reference to a collection of Interface objects.
  /*[id(0x00000024)]*/ int get_Interfaces(out IMembers ppVal);
  // Returns a reference to a collection of MemberItem objects.
  /*[id(0x00000025)]*/ int get_MemberItems(out IMemberItems ppVal);
  // Returns the version of the member.
  /*[id(0x00000026)]*/ int get_Version(out wchar* pVal);
  // Returns a reference to a collection of MemberItem objects that are properties.
  /*[id(0x00000027)]*/ int get_Properties(out IMemberItems ppVal);
  // Returns a reference to a collection of MemberItem objects that are methods.
  /*[id(0x00000028)]*/ int get_Methods(out IMemberItems ppVal);
  // Returns a reference to a collection of MemberItem objects that are events.
  /*[id(0x00000029)]*/ int get_Events(out IMemberItems ppVal);
  // Returns a reference to the default Interface object.
  /*[id(0x0000002A)]*/ int get_DefaultInterface(out IMember ppVal);
  // Returns a reference to the default event Interface object.
  /*[id(0x0000002B)]*/ int get_DefaultEventInterface(out IMember ppVal);
  // Returns a reference to a collection of MemberItem objects that are constants.
  /*[id(0x0000002C)]*/ int get_Constants(out IMemberItems ppVal);
  // Returns a reference to a collection of MemberItem objects that are per instance variables.
  /*[id(0x0000002D)]*/ int get_PerInstanceVariables(out IMemberItems ppVal);
  // Returns a reference to a collection of MemberItem objects that are static variables.
  /*[id(0x0000002E)]*/ int get_StaticVariables(out IMemberItems ppVal);
  // Prevents the member from showing up in the UI.
  /*[id(0x0000002F)]*/ int get_Block(out short pVal);
  // Prevents the member from showing up in the UI.
  /*[id(0x0000002F)]*/ int put_Block(short pVal);
  // Returns the ProgId of the control if available.
  /*[id(0x00000030)]*/ int get_ProgId(out wchar* pVal);
}

// Default interface for the ObjectBrowser MemberItem collection.
interface IMemberItems : IDispatch {
  mixin(uuid("da818207-9dc6-453d-887a-3da5170a0eba"));
  // Returns a specific item of a Collection object either by position or by key.
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out IMemberItem ppVal);
  // Used for internal support of For Each syntax.
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown ppVal);
  // Returns the number of objects in the collection.
  /*[id(0x00000001)]*/ int get_Count(out int pVal);
}

// Default interface for the ObjectBrowser MemberItem object.
interface IMemberItem : IDispatch {
  mixin(uuid("da818206-9dc6-453d-887a-3da5170a0eba"));
  // Returns the value of the object.
  /*[id(0x00000000)]*/ int get_Value(out VARIANT pVal);
  // Returns the name used in code to identify an object.
  /*[id(0x00000001)]*/ int get_Name(out wchar* pVal);
  // Returns the help string for the member.
  /*[id(0x00000002)]*/ int get_HelpString(out wchar* pVal);
  // Returns the help context Id for the member.
  /*[id(0x00000003)]*/ int get_HelpContext(out int pVal);
  // Returns the help file for the member.
  /*[id(0x00000004)]*/ int get_HelpFile(out wchar* pVal);
  // Returns whether the member is hidden, and should not be displayed to users, although its use is not restricted.
  /*[id(0x00000005)]*/ int get_Hidden(out short pVal);
  // Returns whether the member is restricted, and should not be displayed to users.
  /*[id(0x00000006)]*/ int get_Restricted(out short pVal);
  // Returns the id of the member.
  /*[id(0x00000007)]*/ int get_MemberId(out int pVal);
  // Returns information about a data type.
  /*[id(0x00000008)]*/ int get_DataType(out DataTypeInfo pVal);
  // Returns a reference to a collection of Parameter objects.
  /*[id(0x00000009)]*/ int get_Parameters(out IParameters ppVal);
  // Returns the VB declaration of the member.
  /*[id(0x0000000A)]*/ int get_VBDeclaration(out wchar* pVal);
  // Returns a value indicating the Function type.
  /*[id(0x0000000B)]*/ int get_FunctionType(out FunctionType pVal);
  // Returns a reference to the object's parent.
  /*[id(0xFFFFFCDD)]*/ int get_Parent(out IMember ppVal);
  // Returns a value indicating how a function should be accessed.
  /*[id(0x0000000D)]*/ int get_Access(out FunctionAccess pVal);
  // Returns whether the member allows assignment.
  /*[id(0x0000000E)]*/ int get_ReadOnly(out short pVal);
  // Returns whether the member returns and object that is a source of events.
  /*[id(0x0000000F)]*/ int get_ReturnsObjectSource(out short pVal);
  // Returns whether the member supports data binding.
  /*[id(0x00000010)]*/ int get_Bindable(out short pVal);
  // Returns whether the member calls OnRequest edit when it's value is change.
  /*[id(0x00000011)]*/ int get_RequestsEdit(out short pVal);
  // Returns whether the member should be displayed as bindable.
  /*[id(0x00000012)]*/ int get_DisplayAsBindable(out short pVal);
  // Returns whether the member is the default bindable property.
  /*[id(0x00000013)]*/ int get_DefaultBind(out short pVal);
  // Returns whether the member is the default collection element.
  /*[id(0x00000014)]*/ int get_DefaultCollectionElement(out short pVal);
  // Returns whether the member is the default display property.
  /*[id(0x00000015)]*/ int get_UIDefault(out short pVal);
  // Returns whether the member should appear in a property browser.
  /*[id(0x00000016)]*/ int get_Browseable(out short pVal);
  // Returns whether the member has default behavior.
  /*[id(0x00000017)]*/ int get_Replaceable(out short pVal);
  // Returns whether the member is mapped as individual bindable properties.
  /*[id(0x00000018)]*/ int get_ImmediateBind(out short pVal);
  // Returns whether the function supports GetLastError.
  /*[id(0x00000019)]*/ int get_UsesGetLastError(out short pVal);
  // Returns the schema of the member.
  /*[id(0x0000001A)]*/ int get_Schema(out wchar* pVal);
  // Returns a value indicating the Function type.
  /*[id(0x0000001B)]*/ int get_VariableType(out VariableType pVal);
  // Returns whether the underlining data structure of the member item is a VARDESC.
  /*[id(0x0000001C)]*/ int get_IsVariable(out short pVal);
  // Returns whether the underlining data structure of the member item is a FUNCESC.
  /*[id(0x0000001D)]*/ int get_IsFunction(out short pVal);
  // Returns a value indicating the MemberItem type.
  /*[id(0x0000001E)]*/ int get_Type(out MemberItemType pVal);
  // Returns information about the data type the method returns.
  /*[id(0x0000001F)]*/ int get_ReturnType(out DataTypeInfo pVal);
}

// Default interface for the ObjectBrowser Parameters collection.
interface IParameters : IDispatch {
  mixin(uuid("cff2d18d-8988-42b5-90b6-4c83afc74179"));
  // Returns a specific item of a Collection object either by position or by key.
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out IParameter ppVal);
  // Used for internal support of For Each syntax.
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown ppVal);
  // Returns the number of objects in the collection.
  /*[id(0x00000001)]*/ int get_Count(out int pVal);
}

// Default interface for the ObjectBrowser Parameter object.
interface IParameter : IDispatch {
  mixin(uuid("74dde1c9-5693-4343-b0d4-609cde94c03b"));
  // Returns the name used in code to identify an object.
  /*[id(0x00000001)]*/ int get_Name(out wchar* pVal);
  // Returns information about a data type.
  /*[id(0x00000002)]*/ int get_DataType(out DataTypeInfo pVal);
  // Returns a value indicating if the Parameter is an input to the function or method.
  /*[id(0x00000003)]*/ int get_IsInput(out short pVal);
  // Returns a value indicating if the Parameter is an output from the function or method.
  /*[id(0x00000004)]*/ int get_IsOutput(out short pVal);
  // Returns a value indicating if the Parameter is the return value of the function or method.
  /*[id(0x00000005)]*/ int get_IsReturnValue(out short pVal);
  // Returns a value indicating if the Parameter has a default value.
  /*[id(0x00000006)]*/ int get_HasDefaultValue(out short pVal);
  // Returns the default value of the Parameter object.
  /*[id(0x00000007)]*/ int get_DefaultValue(out VARIANT pVal);
  // Returns a value indicating if the Parameter is an option parameter.
  /*[id(0x00000008)]*/ int get_IsOptional(out short pVal);
  // Returns a value indicating if the Parameter is locale id.
  /*[id(0x00000009)]*/ int get_IsLCID(out short pVal);
  // Returns a value indicating if the Parameter has custom data.
  /*[id(0x0000000A)]*/ int get_HasCustomData(out short pVal);
}

// Default interface for the ObjectBrowser object.
interface IObjectBrowser : IDispatch {
  mixin(uuid("5d2c7928-55ca-4dc9-9c8b-90b001ae8390"));
  // Displays the About dialog box.
  /*[id(0xFFFFFDD8)]*/ int AboutBox();
  // Returns a reference to a collection of Library objects.
  /*[id(0x00000001)]*/ int get_Libraries(out ILibraries ppVal);
  // Gets/Sets the selected Library in the ObjectBrowser.
  /*[id(0x00000002)]*/ int get_SelectedLibrary(out ILibrary ppVal);
  // Gets/Sets the selected Library in the ObjectBrowser.
  /*[id(0x00000002)]*/ int put_SelectedLibrary(ILibrary ppVal);
  // Gets/Sets the selected Member in the ObjectBrowser.
  /*[id(0x00000003)]*/ int get_SelectedMember(out IMember ppVal);
  // Gets/Sets the selected Member in the ObjectBrowser.
  /*[id(0x00000003)]*/ int put_SelectedMember(IMember ppVal);
  // Gets/Sets the selected MemberItem in the ObjectBrowser.
  /*[id(0x00000004)]*/ int get_SelectedMemberItem(out IMemberItem ppVal);
  // Gets/Sets the selected MemberItem in the ObjectBrowser.
  /*[id(0x00000004)]*/ int put_SelectedMemberItem(IMemberItem ppVal);
  // Sets the ObjectBrowser to display the Members of all the Libraries.
  /*[id(0x00000005)]*/ int SelectAllLibraries();
  // Sets the ObjectBrowser to display the global MemberItems of the selected Library.
  /*[id(0x00000006)]*/ int SelectGlobals(wchar* Library);
  // Moves the selection to the next item.
  /*[id(0x00000007)]*/ int BrowseForward();
  // Moves the selection to the previous item.
  /*[id(0x00000008)]*/ int BrowseBack();
  // Returns whether or not there is another item in the selection history.
  /*[id(0x00000009)]*/ int get_CanBrowseForward(out short pVal);
  // Returns whether or not there is another item in the selection history.
  /*[id(0x0000000A)]*/ int get_CanBrowseBack(out short pVal);
  // Returns/sets whether or not the Members and MemberItems are grouped by type.
  /*[id(0x0000000B)]*/ int get_GroupByType(out short pVal);
  // Returns/sets whether or not the Members and MemberItems are grouped by type.
  /*[id(0x0000000B)]*/ int put_GroupByType(short pVal);
  // Returns/sets whether or not the hidden members should be displayed.
  /*[id(0x0000000C)]*/ int get_HiddenMembersVisible(out short pVal);
  // Returns/sets whether or not the hidden members should be displayed.
  /*[id(0x0000000C)]*/ int put_HiddenMembersVisible(short pVal);
  // Searches for the libraries for the specified string.
  /*[id(0x0000000D)]*/ int Find(wchar* Text, int Reserved);
  // Returns/sets whether or not the pane is visible.
  /*[id(0x0000000E)]*/ int get_PaneVisible(ViewPane Pane, out short pVal);
  // Returns/sets whether or not the pane is visible.
  /*[id(0x0000000E)]*/ int put_PaneVisible(ViewPane Pane, short pVal);
  // Displays the specified pane.
  /*[id(0x0000000F)]*/ int ShowPane(ViewPane Pane);
  // Hides the specific pane.
  /*[id(0x00000010)]*/ int HidePane(ViewPane Pane);
  // Returns/sets whether or not the toolbar is visible.
  /*[id(0x00000011)]*/ int get_ToolbarVisible(out short pVal);
  // Returns/sets whether or not the toolbar is visible.
  /*[id(0x00000011)]*/ int put_ToolbarVisible(short pVal);
  // Displays the ObjectBrowser toolbar.
  /*[id(0x00000012)]*/ int ShowToolbar();
  // Hides the ObjectBrowser toolbar.
  /*[id(0x00000013)]*/ int HideToolbar();
  // Returns/sets the elements visible on the ObjectBrowser toolbar.
  /*[id(0x00000014)]*/ int get_ToolbarElementVisible(ToolbarElement Element, out short pVal);
  // Returns/sets the elements visible on the ObjectBrowser toolbar.
  /*[id(0x00000014)]*/ int put_ToolbarElementVisible(ToolbarElement Element, short pVal);
  // Displays the elements on the ObjectBrowser toolbar.
  /*[id(0x00000015)]*/ int ShowToolbarElement(ToolbarElement Element);
  // Hides the elements on the ObjectBrowser toolbar.
  /*[id(0x00000016)]*/ int HideToolbarElement(ToolbarElement Element);
  // Adds a Library to the ObjectBrowser.
  /*[id(0x00000017)]*/ int AddLibrary(VARIANT Library, out ILibrary ppVal);
  // Copies the selected item into the clipboard.
  /*[id(0x00000018)]*/ int Copy();
  // Regenerates a Use event with the selected item.
  /*[id(0x00000019)]*/ int Use();
  // Provides access to customer specific features.
  /*[id(0x0000001A)]*/ int Customize(int Id, VARIANT Value, out VARIANT pValue);
  // Displays help for the selected item.
  /*[id(0x0000001B)]*/ int Help();
  // Gets/Sets the selected item in the ObjectBrowser.
  /*[id(0x0000001C)]*/ int get_SelectedItem(out wchar* pVal);
  // Gets/Sets the selected item in the ObjectBrowser.
  /*[id(0x0000001C)]*/ int put_SelectedItem(wchar* pVal);
  // Returns whether all library members are being displayed.
  /*[id(0x0000001D)]*/ int get_AllLibrariesSelected(out short pVal);
  // Returns whether the global member items are being displayed.
  /*[id(0x0000001E)]*/ int get_GlobalsSelected(out short pVal);
  // Sets the currently selected Library.
  /*[id(0x0000001F)]*/ int SelectLibrary(ILibrary objLibrary);
  // Sets the currently selected Member.
  /*[id(0x00000020)]*/ int SelectMember(IMember objMember);
  // Sets the currently selected MemberItem.
  /*[id(0x00000021)]*/ int SelectMemberItem(IMemberItem objMemberItem);
  // Sets the currently selected Library, Member and MemberItem.
  /*[id(0x00000022)]*/ int SelectItem(wchar* Item);
}

// Default interface for the ObjectBrowser Library collection.
interface ILibraries : IDispatch {
  mixin(uuid("30a32508-e3cc-4c28-b5dc-b8dbd7aa2037"));
  // Returns a specific item of a Collection object either by position or by key.
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out ILibrary ppVal);
  // Used for internal support of For Each syntax.
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown ppVal);
  // Returns the number of objects in the collection.
  /*[id(0x00000001)]*/ int get_Count(out int pVal);
  // Adds an object to the collection and returns a reference to the created object.
  /*[id(0xFFFFFDD7)]*/ int Add(VARIANT Library, out ILibrary pVal);
  // Removes a specific member from a collection.
  /*[id(0xFFFFFDD5)]*/ int Remove(VARIANT Index);
  // Removes all the objects in a collection.
  /*[id(0xFFFFFDD6)]*/ int Clear();
  // Adds a registered type library.
  /*[id(0x00000002)]*/ int AddRegisteredLib(wchar* GUID, int MajorVersion, int MinorVersion, int LCID, out ILibrary pVal);
}

// ISplitterProxy Interface
interface ISplitterProxy : IDispatch {
  mixin(uuid("2f93a224-afac-41a8-ad84-a3a4a093761a"));
}

// CoClasses

// The DesertHill ObjectBrowser Control.
abstract final class ObjectBrowser {
  mixin(uuid("c397b98a-85ef-4990-8188-9a77e62a81dd"));
  mixin Interfaces!(IObjectBrowser);
}

// An ObjectBrowser Library object.
abstract final class Library {
  mixin(uuid("de20fbaf-1a7e-42f3-a5cd-5427c2556711"));
  mixin Interfaces!(ILibrary);
}

// A collection of ObjectBrowser Library objects.
abstract final class Libraries {
  mixin(uuid("328f6a66-96fe-4f08-bb6f-1721eb79ed3d"));
  mixin Interfaces!(ILibraries);
}

// An ObjectBrowser Member object.
abstract final class Member {
  mixin(uuid("733464de-3202-469b-a756-536961eb86a3"));
  mixin Interfaces!(IMember);
}

// A collection of ObjectBrowser Member objects.
abstract final class Members {
  mixin(uuid("72a04749-c001-4e21-8e9c-c19b9ba6b967"));
  mixin Interfaces!(IMembers);
}

// An ObjectBrowser MemberItem object.
abstract final class MemberItem {
  mixin(uuid("cd9d56a9-9515-46f9-8628-edeb98991065"));
  mixin Interfaces!(IMemberItem);
}

// A collection of ObjectBrowser MemberItem objects.
abstract final class MemberItems {
  mixin(uuid("da818208-9dc6-453d-887a-3da5170a0eba"));
  mixin Interfaces!(IMemberItems);
}

// An ObjectBrowser Parameter object.
abstract final class Parameter {
  mixin(uuid("131beeee-9252-40b8-9c8f-735a398df005"));
  mixin Interfaces!(IParameter);
}

// A collection of ObjectBrowser Parameter objects.
abstract final class Parameters {
  mixin(uuid("b2aa5468-8160-4094-b2d6-6d5a5ff2e807"));
  mixin Interfaces!(IParameters);
}

// SplitterProxy Class
abstract final class SplitterProxy {
  mixin(uuid("9f47f2a1-c6d3-49fb-be2f-362f6fb89aaf"));
  mixin Interfaces!(ISplitterProxy);
}
