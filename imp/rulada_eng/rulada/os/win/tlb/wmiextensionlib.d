// WMI Extension to DS 1.0 Type Library
// Version 1.0

/*[uuid("e503d000-5c7f-11d2-8b74-00104b2afb41")]*/
module os.win.tlb.wmiextensionlib;

/*[importlib("stdole2.tlb")]*/
private import os.win.com.core;

// Enums

// Defines the security impersonation level
enum WbemImpersonationLevelEnum {
  wbemImpersonationLevelAnonymous = 0x00000001,
  wbemImpersonationLevelIdentify = 0x00000002,
  wbemImpersonationLevelImpersonate = 0x00000003,
  wbemImpersonationLevelDelegate = 0x00000004,
}

// Defines the security authentication level
enum WbemAuthenticationLevelEnum {
  wbemAuthenticationLevelDefault = 0x00000000,
  wbemAuthenticationLevelNone = 0x00000001,
  wbemAuthenticationLevelConnect = 0x00000002,
  wbemAuthenticationLevelCall = 0x00000003,
  wbemAuthenticationLevelPkt = 0x00000004,
  wbemAuthenticationLevelPktIntegrity = 0x00000005,
  wbemAuthenticationLevelPktPrivacy = 0x00000006,
}

// Defines a privilege
enum WbemPrivilegeEnum {
  wbemPrivilegeCreateToken = 0x00000001,
  wbemPrivilegePrimaryToken = 0x00000002,
  wbemPrivilegeLockMemory = 0x00000003,
  wbemPrivilegeIncreaseQuota = 0x00000004,
  wbemPrivilegeMachineAccount = 0x00000005,
  wbemPrivilegeTcb = 0x00000006,
  wbemPrivilegeSecurity = 0x00000007,
  wbemPrivilegeTakeOwnership = 0x00000008,
  wbemPrivilegeLoadDriver = 0x00000009,
  wbemPrivilegeSystemProfile = 0x0000000A,
  wbemPrivilegeSystemtime = 0x0000000B,
  wbemPrivilegeProfileSingleProcess = 0x0000000C,
  wbemPrivilegeIncreaseBasePriority = 0x0000000D,
  wbemPrivilegeCreatePagefile = 0x0000000E,
  wbemPrivilegeCreatePermanent = 0x0000000F,
  wbemPrivilegeBackup = 0x00000010,
  wbemPrivilegeRestore = 0x00000011,
  wbemPrivilegeShutdown = 0x00000012,
  wbemPrivilegeDebug = 0x00000013,
  wbemPrivilegeAudit = 0x00000014,
  wbemPrivilegeSystemEnvironment = 0x00000015,
  wbemPrivilegeChangeNotify = 0x00000016,
  wbemPrivilegeRemoteShutdown = 0x00000017,
  wbemPrivilegeUndock = 0x00000018,
  wbemPrivilegeSyncAgent = 0x00000019,
  wbemPrivilegeEnableDelegation = 0x0000001A,
  wbemPrivilegeManageVolume = 0x0000001B,
}

// Defines the valid CIM Types of a Property value
enum WbemCimtypeEnum {
  wbemCimtypeSint8 = 0x00000010,
  wbemCimtypeUint8 = 0x00000011,
  wbemCimtypeSint16 = 0x00000002,
  wbemCimtypeUint16 = 0x00000012,
  wbemCimtypeSint32 = 0x00000003,
  wbemCimtypeUint32 = 0x00000013,
  wbemCimtypeSint64 = 0x00000014,
  wbemCimtypeUint64 = 0x00000015,
  wbemCimtypeReal32 = 0x00000004,
  wbemCimtypeReal64 = 0x00000005,
  wbemCimtypeBoolean = 0x0000000B,
  wbemCimtypeString = 0x00000008,
  wbemCimtypeDatetime = 0x00000065,
  wbemCimtypeReference = 0x00000066,
  wbemCimtypeChar16 = 0x00000067,
  wbemCimtypeObject = 0x0000000D,
}

// Interfaces

// WMI extension to the DS Interface
interface IWMIExtension : IDispatch {
  mixin(uuid("adc1f06e-5c7e-11d2-8b74-00104b2afb41"));
  // Path to matching WMI object
  /*[id(0x00000001)]*/ int get_WMIObjectPath(out wchar* strWMIObjectPath);
  // Retrieves the matching WMI object
  /*[id(0x00000002)]*/ int GetWMIObject(out ISWbemObject objWMIObject);
  // Retrieves the matching WMI services pointer
  /*[id(0x00000003)]*/ int GetWMIServices(out ISWbemServices objWMIServices);
}

// A Class or Instance
interface ISWbemObject : IDispatch {
  mixin(uuid("76a6415a-cb41-11d1-8b02-00600806d9b6"));
  // Save this Object
  /*[id(0x00000001)]*/ int Put_(int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectPath objWbemObjectPath);
  // Save this Object asynchronously
  /*[id(0x00000002)]*/ int PutAsync_(IDispatch objWbemSink, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Delete this Object
  /*[id(0x00000003)]*/ int Delete_(int iFlags, IDispatch objWbemNamedValueSet);
  // Delete this Object asynchronously
  /*[id(0x00000004)]*/ int DeleteAsync_(IDispatch objWbemSink, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Return all instances of this Class
  /*[id(0x00000005)]*/ int Instances_(int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Return all instances of this Class asynchronously
  /*[id(0x00000006)]*/ int InstancesAsync_(IDispatch objWbemSink, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Enumerate subclasses of this Class
  /*[id(0x00000007)]*/ int Subclasses_(int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Enumerate subclasses of this Class asynchronously
  /*[id(0x00000008)]*/ int SubclassesAsync_(IDispatch objWbemSink, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Get the Associators of this Object
  /*[id(0x00000009)]*/ int Associators_(wchar* strAssocClass, wchar* strResultClass, wchar* strResultRole, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredAssocQualifier, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Get the Associators of this Object asynchronously
  /*[id(0x0000000A)]*/ int AssociatorsAsync_(IDispatch objWbemSink, wchar* strAssocClass, wchar* strResultClass, wchar* strResultRole, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredAssocQualifier, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Get the References to this Object
  /*[id(0x0000000B)]*/ int References_(wchar* strResultClass, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Get the References to this Object asynchronously
  /*[id(0x0000000C)]*/ int ReferencesAsync_(IDispatch objWbemSink, wchar* strResultClass, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Execute a Method of this Object
  /*[id(0x0000000D)]*/ int ExecMethod_(wchar* strMethodName, IDispatch objWbemInParameters, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObject objWbemOutParameters);
  // Execute a Method of this Object asynchronously
  /*[id(0x0000000E)]*/ int ExecMethodAsync_(IDispatch objWbemSink, wchar* strMethodName, IDispatch objWbemInParameters, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Clone this Object
  /*[id(0x0000000F)]*/ int Clone_(out ISWbemObject objWbemObject);
  // Get the MOF text of this Object
  /*[id(0x00000010)]*/ int GetObjectText_(int iFlags, out wchar* strObjectText);
  // Create a subclass of this Object
  /*[id(0x00000011)]*/ int SpawnDerivedClass_(int iFlags, out ISWbemObject objWbemObject);
  // Create an Instance of this Object
  /*[id(0x00000012)]*/ int SpawnInstance_(int iFlags, out ISWbemObject objWbemObject);
  // Compare this Object with another
  /*[id(0x00000013)]*/ int CompareTo_(IDispatch objWbemObject, int iFlags, out short bResult);
  // The collection of Qualifiers of this Object
  /*[id(0x00000014)]*/ int get_Qualifiers_(out ISWbemQualifierSet objWbemQualifierSet);
  // The collection of Properties of this Object
  /*[id(0x00000015)]*/ int get_Properties_(out ISWbemPropertySet objWbemPropertySet);
  // The collection of Methods of this Object
  /*[id(0x00000016)]*/ int get_Methods_(out ISWbemMethodSet objWbemMethodSet);
  // An array of strings describing the class derivation heirarchy, in most-derived-from order (the first element in the array defines the superclass and the last element defines the dynasty class).
  /*[id(0x00000017)]*/ int get_Derivation_(out VARIANT strClassNameArray);
  // The path of this Object
  /*[id(0x00000018)]*/ int get_Path_(out ISWbemObjectPath objWbemObjectPath);
  // The Security Configurator for this Object
  /*[id(0x00000019)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// An Object path
interface ISWbemObjectPath : IDispatch {
  mixin(uuid("5791bc27-ce9c-11d1-97bf-0000f81e849c"));
  // The full path
  /*[id(0x00000000)]*/ int get_Path(out wchar* strPath);
  // The full path
  /*[id(0x00000000)]*/ int put_Path(wchar* strPath);
  // The relative path
  /*[id(0x00000001)]*/ int get_RelPath(out wchar* strRelPath);
  // The relative path
  /*[id(0x00000001)]*/ int put_RelPath(wchar* strRelPath);
  // The name of the Server
  /*[id(0x00000002)]*/ int get_Server(out wchar* strServer);
  // The name of the Server
  /*[id(0x00000002)]*/ int put_Server(wchar* strServer);
  // The Namespace path
  /*[id(0x00000003)]*/ int get_Namespace(out wchar* strNamespace);
  // The Namespace path
  /*[id(0x00000003)]*/ int put_Namespace(wchar* strNamespace);
  // The parent Namespace path
  /*[id(0x00000004)]*/ int get_ParentNamespace(out wchar* strParentNamespace);
  // The Display Name for this path
  /*[id(0x00000005)]*/ int get_DisplayName(out wchar* strDisplayName);
  // The Display Name for this path
  /*[id(0x00000005)]*/ int put_DisplayName(wchar* strDisplayName);
  // The Class name
  /*[id(0x00000006)]*/ int get_Class(out wchar* strClass);
  // The Class name
  /*[id(0x00000006)]*/ int put_Class(wchar* strClass);
  // Indicates whether this path addresses a Class
  /*[id(0x00000007)]*/ int get_IsClass(out short bIsClass);
  // Coerce this path to address a Class
  /*[id(0x00000008)]*/ int SetAsClass();
  // Indicates whether this path addresses a Singleton Instance
  /*[id(0x00000009)]*/ int get_IsSingleton(out short bIsSingleton);
  // Coerce this path to address a Singleton Instance
  /*[id(0x0000000A)]*/ int SetAsSingleton();
  // The collection of Key value bindings for this path
  /*[id(0x0000000B)]*/ int get_Keys(out ISWbemNamedValueSet objWbemNamedValueSet);
  // Defines the security components of this path
  /*[id(0x0000000C)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
  // Defines locale component of this path
  /*[id(0x0000000D)]*/ int get_Locale(out wchar* strLocale);
  // Defines locale component of this path
  /*[id(0x0000000D)]*/ int put_Locale(wchar* strLocale);
  // Defines authentication authority component of this path
  /*[id(0x0000000E)]*/ int get_Authority(out wchar* strAuthority);
  // Defines authentication authority component of this path
  /*[id(0x0000000E)]*/ int put_Authority(wchar* strAuthority);
}

// A collection of named values
interface ISWbemNamedValueSet : IDispatch {
  mixin(uuid("cf2376ea-ce8c-11d1-8b05-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get a named value from this Collection
  /*[id(0x00000000)]*/ int Item(wchar* strName, int iFlags, out ISWbemNamedValue objWbemNamedValue);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // Add a named value to this collection
  /*[id(0x00000002)]*/ int Add(wchar* strName, VARIANT* varValue, int iFlags, out ISWbemNamedValue objWbemNamedValue);
  // Remove a named value from this collection
  /*[id(0x00000003)]*/ int Remove(wchar* strName, int iFlags);
  // Make a copy of this collection
  /*[id(0x00000004)]*/ int Clone(out ISWbemNamedValueSet objWbemNamedValueSet);
  // Delete all items in this collection
  /*[id(0x00000005)]*/ int DeleteAll();
}

// A named value
interface ISWbemNamedValue : IDispatch {
  mixin(uuid("76a64164-cb41-11d1-8b02-00600806d9b6"));
  // The Value of this Named element
  /*[id(0x00000000)]*/ int get_Value(out VARIANT varValue);
  // The Value of this Named element
  /*[id(0x00000000)]*/ int put_Value(VARIANT* varValue);
  // The Name of this Value
  /*[id(0x00000002)]*/ int get_Name(out wchar* strName);
}

// A Security Configurator
interface ISWbemSecurity : IDispatch {
  mixin(uuid("b54d66e6-2287-11d2-8b33-00600806d9b6"));
  // The security impersonation level
  /*[id(0x00000001)]*/ int get_ImpersonationLevel(out WbemImpersonationLevelEnum iImpersonationLevel);
  // The security impersonation level
  /*[id(0x00000001)]*/ int put_ImpersonationLevel(WbemImpersonationLevelEnum iImpersonationLevel);
  // The security authentication level
  /*[id(0x00000002)]*/ int get_AuthenticationLevel(out WbemAuthenticationLevelEnum iAuthenticationLevel);
  // The security authentication level
  /*[id(0x00000002)]*/ int put_AuthenticationLevel(WbemAuthenticationLevelEnum iAuthenticationLevel);
  // The collection of privileges for this object
  /*[id(0x00000003)]*/ int get_Privileges(out ISWbemPrivilegeSet objWbemPrivilegeSet);
}

// A collection of Privilege Overrides
interface ISWbemPrivilegeSet : IDispatch {
  mixin(uuid("26ee67bf-5804-11d2-8b4a-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get a named Privilege from this collection
  /*[id(0x00000000)]*/ int Item(WbemPrivilegeEnum iPrivilege, out ISWbemPrivilege objWbemPrivilege);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // Add a Privilege to this collection
  /*[id(0x00000002)]*/ int Add(WbemPrivilegeEnum iPrivilege, short bIsEnabled, out ISWbemPrivilege objWbemPrivilege);
  // Remove a Privilege from this collection
  /*[id(0x00000003)]*/ int Remove(WbemPrivilegeEnum iPrivilege);
  // Delete all items in this collection
  /*[id(0x00000004)]*/ int DeleteAll();
  // Add a named Privilege to this collection
  /*[id(0x00000005)]*/ int AddAsString(wchar* strPrivilege, short bIsEnabled, out ISWbemPrivilege objWbemPrivilege);
}

// A Privilege Override
interface ISWbemPrivilege : IDispatch {
  mixin(uuid("26ee67bd-5804-11d2-8b4a-00600806d9b6"));
  // Whether the Privilege is to be enabled or disabled
  /*[id(0x00000000)]*/ int get_IsEnabled(out short bIsEnabled);
  // Whether the Privilege is to be enabled or disabled
  /*[id(0x00000000)]*/ int put_IsEnabled(short bIsEnabled);
  // The name of the Privilege
  /*[id(0x00000001)]*/ int get_Name(out wchar* strDisplayName);
  // The display name of the Privilege
  /*[id(0x00000002)]*/ int get_DisplayName(out wchar* strDisplayName);
  // The Privilege identifier
  /*[id(0x00000003)]*/ int get_Identifier(out WbemPrivilegeEnum iPrivilege);
}

// A collection of Classes or Instances
interface ISWbemObjectSet : IDispatch {
  mixin(uuid("76a6415f-cb41-11d1-8b02-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get an Object with a specific path from this collection
  /*[id(0x00000000)]*/ int Item(wchar* strObjectPath, int iFlags, out ISWbemObject objWbemObject);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // The Security Configurator for this Object
  /*[id(0x00000004)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// A collection of Qualifiers
interface ISWbemQualifierSet : IDispatch {
  mixin(uuid("9b16ed16-d3df-11d1-8b08-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get a named Qualifier from this collection
  /*[id(0x00000000)]*/ int Item(wchar* Name, int iFlags, out ISWbemQualifier objWbemQualifier);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // Add a Qualifier to this collection
  /*[id(0x00000002)]*/ int Add(wchar* strName, VARIANT* varVal, short bPropagatesToSubclass, short bPropagatesToInstance, short bIsOverridable, int iFlags, out ISWbemQualifier objWbemQualifier);
  // Remove a Qualifier from this collection
  /*[id(0x00000003)]*/ int Remove(wchar* strName, int iFlags);
}

// A Qualifier
interface ISWbemQualifier : IDispatch {
  mixin(uuid("79b05932-d3b7-11d1-8b06-00600806d9b6"));
  // The value of this Qualifier
  /*[id(0x00000000)]*/ int get_Value(out VARIANT varValue);
  // The value of this Qualifier
  /*[id(0x00000000)]*/ int put_Value(VARIANT* varValue);
  // The name of this Qualifier
  /*[id(0x00000001)]*/ int get_Name(out wchar* strName);
  // Indicates whether this Qualifier is local or propagated
  /*[id(0x00000002)]*/ int get_IsLocal(out short bIsLocal);
  // Determines whether this Qualifier can propagate to subclasses
  /*[id(0x00000003)]*/ int get_PropagatesToSubclass(out short bPropagatesToSubclass);
  // Determines whether this Qualifier can propagate to subclasses
  /*[id(0x00000003)]*/ int put_PropagatesToSubclass(short bPropagatesToSubclass);
  // Determines whether this Qualifier can propagate to instances
  /*[id(0x00000004)]*/ int get_PropagatesToInstance(out short bPropagatesToInstance);
  // Determines whether this Qualifier can propagate to instances
  /*[id(0x00000004)]*/ int put_PropagatesToInstance(short bPropagatesToInstance);
  // Determines whether this Qualifier can be overridden where propagated
  /*[id(0x00000005)]*/ int get_IsOverridable(out short bIsOverridable);
  // Determines whether this Qualifier can be overridden where propagated
  /*[id(0x00000005)]*/ int put_IsOverridable(short bIsOverridable);
  // Determines whether the value of this Qualifier has been amended
  /*[id(0x00000006)]*/ int get_IsAmended(out short bIsAmended);
}

// A collection of Properties
interface ISWbemPropertySet : IDispatch {
  mixin(uuid("dea0a7b2-d4ba-11d1-8b09-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get a named Property from this collection
  /*[id(0x00000000)]*/ int Item(wchar* strName, int iFlags, out ISWbemProperty objWbemProperty);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // Add a Property to this collection
  /*[id(0x00000002)]*/ int Add(wchar* strName, WbemCimtypeEnum iCimType, short bIsArray, int iFlags, out ISWbemProperty objWbemProperty);
  // Remove a Property from this collection
  /*[id(0x00000003)]*/ int Remove(wchar* strName, int iFlags);
}

// A Property
interface ISWbemProperty : IDispatch {
  mixin(uuid("1a388f98-d4ba-11d1-8b09-00600806d9b6"));
  // The value of this Property
  /*[id(0x00000000)]*/ int get_Value(out VARIANT varValue);
  // The value of this Property
  /*[id(0x00000000)]*/ int put_Value(VARIANT* varValue);
  // The name of this Property
  /*[id(0x00000001)]*/ int get_Name(out wchar* strName);
  // Indicates whether this Property is local or propagated
  /*[id(0x00000002)]*/ int get_IsLocal(out short bIsLocal);
  // The originating class of this Property
  /*[id(0x00000003)]*/ int get_Origin(out wchar* strOrigin);
  // The CIM Type of this Property
  /*[id(0x00000004)]*/ int get_CIMType(out WbemCimtypeEnum iCimType);
  // The collection of Qualifiers of this Property
  /*[id(0x00000005)]*/ int get_Qualifiers_(out ISWbemQualifierSet objWbemQualifierSet);
  // Indicates whether this Property is an array type
  /*[id(0x00000006)]*/ int get_IsArray(out short bIsArray);
}

// A collection of Methods
interface ISWbemMethodSet : IDispatch {
  mixin(uuid("c93ba292-d955-11d1-8b09-00600806d9b6"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get a named Method from this collection
  /*[id(0x00000000)]*/ int Item(wchar* strName, int iFlags, out ISWbemMethod objWbemMethod);
  // The number of items in this collection
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
}

// A Method
interface ISWbemMethod : IDispatch {
  mixin(uuid("422e8e90-d955-11d1-8b09-00600806d9b6"));
  // The name of this Method
  /*[id(0x00000001)]*/ int get_Name(out wchar* strName);
  // The originating class of this Method
  /*[id(0x00000002)]*/ int get_Origin(out wchar* strOrigin);
  // The in parameters for this Method.
  /*[id(0x00000003)]*/ int get_InParameters(out ISWbemObject objWbemInParameters);
  // The out parameters for this Method.
  /*[id(0x00000004)]*/ int get_OutParameters(out ISWbemObject objWbemOutParameters);
  // The collection of Qualifiers of this Method.
  /*[id(0x00000005)]*/ int get_Qualifiers_(out ISWbemQualifierSet objWbemQualifierSet);
}

// A connection to a Namespace
interface ISWbemServices : IDispatch {
  mixin(uuid("76a6415c-cb41-11d1-8b02-00600806d9b6"));
  // Get a single Class or Instance
  /*[id(0x00000001)]*/ int Get(wchar* strObjectPath, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObject objWbemObject);
  // Get a single Class or Instance asynchronously
  /*[id(0x00000002)]*/ int GetAsync(IDispatch objWbemSink, wchar* strObjectPath, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Delete a Class or Instance
  /*[id(0x00000003)]*/ int Delete(wchar* strObjectPath, int iFlags, IDispatch objWbemNamedValueSet);
  // Delete a Class or Instance asynchronously
  /*[id(0x00000004)]*/ int DeleteAsync(IDispatch objWbemSink, wchar* strObjectPath, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Enumerate the Instances of a Class
  /*[id(0x00000005)]*/ int InstancesOf(wchar* strClass, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Enumerate the Instances of a Class asynchronously
  /*[id(0x00000006)]*/ int InstancesOfAsync(IDispatch objWbemSink, wchar* strClass, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Enumerate the subclasses of a Class
  /*[id(0x00000007)]*/ int SubclassesOf(wchar* strSuperclass, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Enumerate the subclasses of a Class asynchronously 
  /*[id(0x00000008)]*/ int SubclassesOfAsync(IDispatch objWbemSink, wchar* strSuperclass, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Execute a Query
  /*[id(0x00000009)]*/ int ExecQuery(wchar* strQuery, wchar* strQueryLanguage, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Execute an asynchronous Query
  /*[id(0x0000000A)]*/ int ExecQueryAsync(IDispatch objWbemSink, wchar* strQuery, wchar* strQueryLanguage, int lFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Get the Associators of a class or instance
  /*[id(0x0000000B)]*/ int AssociatorsOf(wchar* strObjectPath, wchar* strAssocClass, wchar* strResultClass, wchar* strResultRole, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredAssocQualifier, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Get the Associators of a class or instance asynchronously
  /*[id(0x0000000C)]*/ int AssociatorsOfAsync(IDispatch objWbemSink, wchar* strObjectPath, wchar* strAssocClass, wchar* strResultClass, wchar* strResultRole, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredAssocQualifier, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Get the References to a class or instance
  /*[id(0x0000000D)]*/ int ReferencesTo(wchar* strObjectPath, wchar* strResultClass, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectSet objWbemObjectSet);
  // Get the References to a class or instance asynchronously
  /*[id(0x0000000E)]*/ int ReferencesToAsync(IDispatch objWbemSink, wchar* strObjectPath, wchar* strResultClass, wchar* strRole, short bClassesOnly, short bSchemaOnly, wchar* strRequiredQualifier, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Execute a Query to receive Notifications
  /*[id(0x0000000F)]*/ int ExecNotificationQuery(wchar* strQuery, wchar* strQueryLanguage, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemEventSource objWbemEventSource);
  // Execute an asynchronous Query to receive Notifications
  /*[id(0x00000010)]*/ int ExecNotificationQueryAsync(IDispatch objWbemSink, wchar* strQuery, wchar* strQueryLanguage, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // Execute a Method
  /*[id(0x00000011)]*/ int ExecMethod(wchar* strObjectPath, wchar* strMethodName, IDispatch objWbemInParameters, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObject objWbemOutParameters);
  // Execute a Method asynchronously
  /*[id(0x00000012)]*/ int ExecMethodAsync(IDispatch objWbemSink, wchar* strObjectPath, wchar* strMethodName, IDispatch objWbemInParameters, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
  // The Security Configurator for this Object
  /*[id(0x00000013)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// An Event source
interface ISWbemEventSource : IDispatch {
  mixin(uuid("27d54d92-0ebe-11d2-8b22-00600806d9b6"));
  // Retrieve the next event within a specified time period. The timeout is specified in milliseconds.
  /*[id(0x00000001)]*/ int NextEvent(int iTimeoutMs, out ISWbemObject objWbemObject);
  // The Security Configurator for this Object
  /*[id(0x00000002)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// CoClasses

// WMI DS Extension class
abstract final class WMIExtension {
  mixin(uuid("f0975afe-5c7f-11d2-8b74-00104b2afb41"));
  mixin Interfaces!(IWMIExtension);
}
