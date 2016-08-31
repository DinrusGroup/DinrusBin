// Microsoft WMI Scripting V1.2 Library
// Version 1.2

/*[uuid("565783c6-cb41-11d1-8b02-00600806d9b6")]*/
module os.win.tlb.wbemscripting;

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

// Defines the errors that may be returned by the WBEM Scripting library
enum WbemErrorEnum {
  wbemNoErr = 0x00000000,
  wbemErrFailed = 0x80041001,
  wbemErrNotFound = 0x80041002,
  wbemErrAccessDenied = 0x80041003,
  wbemErrProviderFailure = 0x80041004,
  wbemErrTypeMismatch = 0x80041005,
  wbemErrOutOfMemory = 0x80041006,
  wbemErrInvalidContext = 0x80041007,
  wbemErrInvalidParameter = 0x80041008,
  wbemErrNotAvailable = 0x80041009,
  wbemErrCriticalError = 0x8004100A,
  wbemErrInvalidStream = 0x8004100B,
  wbemErrNotSupported = 0x8004100C,
  wbemErrInvalidSuperclass = 0x8004100D,
  wbemErrInvalidNamespace = 0x8004100E,
  wbemErrInvalidObject = 0x8004100F,
  wbemErrInvalidClass = 0x80041010,
  wbemErrProviderNotFound = 0x80041011,
  wbemErrInvalidProviderRegistration = 0x80041012,
  wbemErrProviderLoadFailure = 0x80041013,
  wbemErrInitializationFailure = 0x80041014,
  wbemErrTransportFailure = 0x80041015,
  wbemErrInvalidOperation = 0x80041016,
  wbemErrInvalidQuery = 0x80041017,
  wbemErrInvalidQueryType = 0x80041018,
  wbemErrAlreadyExists = 0x80041019,
  wbemErrOverrideNotAllowed = 0x8004101A,
  wbemErrPropagatedQualifier = 0x8004101B,
  wbemErrPropagatedProperty = 0x8004101C,
  wbemErrUnexpected = 0x8004101D,
  wbemErrIllegalOperation = 0x8004101E,
  wbemErrCannotBeKey = 0x8004101F,
  wbemErrIncompleteClass = 0x80041020,
  wbemErrInvalidSyntax = 0x80041021,
  wbemErrNondecoratedObject = 0x80041022,
  wbemErrReadOnly = 0x80041023,
  wbemErrProviderNotCapable = 0x80041024,
  wbemErrClassHasChildren = 0x80041025,
  wbemErrClassHasInstances = 0x80041026,
  wbemErrQueryNotImplemented = 0x80041027,
  wbemErrIllegalNull = 0x80041028,
  wbemErrInvalidQualifierType = 0x80041029,
  wbemErrInvalidPropertyType = 0x8004102A,
  wbemErrValueOutOfRange = 0x8004102B,
  wbemErrCannotBeSingleton = 0x8004102C,
  wbemErrInvalidCimType = 0x8004102D,
  wbemErrInvalidMethod = 0x8004102E,
  wbemErrInvalidMethodParameters = 0x8004102F,
  wbemErrSystemProperty = 0x80041030,
  wbemErrInvalidProperty = 0x80041031,
  wbemErrCallCancelled = 0x80041032,
  wbemErrShuttingDown = 0x80041033,
  wbemErrPropagatedMethod = 0x80041034,
  wbemErrUnsupportedParameter = 0x80041035,
  wbemErrMissingParameter = 0x80041036,
  wbemErrInvalidParameterId = 0x80041037,
  wbemErrNonConsecutiveParameterIds = 0x80041038,
  wbemErrParameterIdOnRetval = 0x80041039,
  wbemErrInvalidObjectPath = 0x8004103A,
  wbemErrOutOfDiskSpace = 0x8004103B,
  wbemErrBufferTooSmall = 0x8004103C,
  wbemErrUnsupportedPutExtension = 0x8004103D,
  wbemErrUnknownObjectType = 0x8004103E,
  wbemErrUnknownPacketType = 0x8004103F,
  wbemErrMarshalVersionMismatch = 0x80041040,
  wbemErrMarshalInvalidSignature = 0x80041041,
  wbemErrInvalidQualifier = 0x80041042,
  wbemErrInvalidDuplicateParameter = 0x80041043,
  wbemErrTooMuchData = 0x80041044,
  wbemErrServerTooBusy = 0x80041045,
  wbemErrInvalidFlavor = 0x80041046,
  wbemErrCircularReference = 0x80041047,
  wbemErrUnsupportedClassUpdate = 0x80041048,
  wbemErrCannotChangeKeyInheritance = 0x80041049,
  wbemErrCannotChangeIndexInheritance = 0x80041050,
  wbemErrTooManyProperties = 0x80041051,
  wbemErrUpdateTypeMismatch = 0x80041052,
  wbemErrUpdateOverrideNotAllowed = 0x80041053,
  wbemErrUpdatePropagatedMethod = 0x80041054,
  wbemErrMethodNotImplemented = 0x80041055,
  wbemErrMethodDisabled = 0x80041056,
  wbemErrRefresherBusy = 0x80041057,
  wbemErrUnparsableQuery = 0x80041058,
  wbemErrNotEventClass = 0x80041059,
  wbemErrMissingGroupWithin = 0x8004105A,
  wbemErrMissingAggregationList = 0x8004105B,
  wbemErrPropertyNotAnObject = 0x8004105C,
  wbemErrAggregatingByObject = 0x8004105D,
  wbemErrUninterpretableProviderQuery = 0x8004105F,
  wbemErrBackupRestoreWinmgmtRunning = 0x80041060,
  wbemErrQueueOverflow = 0x80041061,
  wbemErrPrivilegeNotHeld = 0x80041062,
  wbemErrInvalidOperator = 0x80041063,
  wbemErrLocalCredentials = 0x80041064,
  wbemErrCannotBeAbstract = 0x80041065,
  wbemErrAmendedObject = 0x80041066,
  wbemErrClientTooSlow = 0x80041067,
  wbemErrNullSecurityDescriptor = 0x80041068,
  wbemErrTimeout = 0x80041069,
  wbemErrInvalidAssociation = 0x8004106A,
  wbemErrAmbiguousOperation = 0x8004106B,
  wbemErrQuotaViolation = 0x8004106C,
  wbemErrTransactionConflict = 0x8004106D,
  wbemErrForcedRollback = 0x8004106E,
  wbemErrUnsupportedLocale = 0x8004106F,
  wbemErrHandleOutOfDate = 0x80041070,
  wbemErrConnectionFailed = 0x80041071,
  wbemErrInvalidHandleRequest = 0x80041072,
  wbemErrPropertyNameTooWide = 0x80041073,
  wbemErrClassNameTooWide = 0x80041074,
  wbemErrMethodNameTooWide = 0x80041075,
  wbemErrQualifierNameTooWide = 0x80041076,
  wbemErrRerunCommand = 0x80041077,
  wbemErrDatabaseVerMismatch = 0x80041078,
  wbemErrVetoPut = 0x80041079,
  wbemErrVetoDelete = 0x8004107A,
  wbemErrInvalidLocale = 0x80041080,
  wbemErrProviderSuspended = 0x80041081,
  wbemErrSynchronizationRequired = 0x80041082,
  wbemErrNoSchema = 0x80041083,
  wbemErrProviderAlreadyRegistered = 0x80041084,
  wbemErrProviderNotRegistered = 0x80041085,
  wbemErrFatalTransportError = 0x80041086,
  wbemErrEncryptedConnectionRequired = 0x80041087,
  wbemErrRegistrationTooBroad = 0x80042001,
  wbemErrRegistrationTooPrecise = 0x80042002,
  wbemErrTimedout = 0x80043001,
  wbemErrResetToDefault = 0x80043002,
}

// Defines object text formats
enum WbemObjectTextFormatEnum {
  wbemObjectTextFormatCIMDTD20 = 0x00000001,
  wbemObjectTextFormatWMIDTD20 = 0x00000002,
}

// Defines semantics of putting a Class or Instance
enum WbemChangeFlagEnum {
  wbemChangeFlagCreateOrUpdate = 0x00000000,
  wbemChangeFlagUpdateOnly = 0x00000001,
  wbemChangeFlagCreateOnly = 0x00000002,
  wbemChangeFlagUpdateCompatible = 0x00000000,
  wbemChangeFlagUpdateSafeMode = 0x00000020,
  wbemChangeFlagUpdateForceMode = 0x00000040,
  wbemChangeFlagStrongValidation = 0x00000080,
  wbemChangeFlagAdvisory = 0x00010000,
}

// Defines behavior of various interface calls
enum WbemFlagEnum {
  wbemFlagReturnImmediately = 0x00000010,
  wbemFlagReturnWhenComplete = 0x00000000,
  wbemFlagBidirectional = 0x00000000,
  wbemFlagForwardOnly = 0x00000020,
  wbemFlagNoErrorObject = 0x00000040,
  wbemFlagReturnErrorObject = 0x00000000,
  wbemFlagSendStatus = 0x00000080,
  wbemFlagDontSendStatus = 0x00000000,
  wbemFlagEnsureLocatable = 0x00000100,
  wbemFlagDirectRead = 0x00000200,
  wbemFlagSendOnlySelected = 0x00000000,
  wbemFlagUseAmendedQualifiers = 0x00020000,
  wbemFlagGetDefault = 0x00000000,
  wbemFlagSpawnInstance = 0x00000001,
  wbemFlagUseCurrentTime = 0x00000001,
}

// Defines depth of enumeration or query
enum WbemQueryFlagEnum {
  wbemQueryFlagDeep = 0x00000000,
  wbemQueryFlagShallow = 0x00000001,
  wbemQueryFlagPrototype = 0x00000002,
}

// Defines content of generated object text
enum WbemTextFlagEnum {
  wbemTextFlagNoFlavors = 0x00000001,
}

// Defines timeout constants
enum WbemTimeout {
  wbemTimeoutInfinite = 0xFFFFFFFF,
}

// Defines settings for object comparison
enum WbemComparisonFlagEnum {
  wbemComparisonFlagIncludeAll = 0x00000000,
  wbemComparisonFlagIgnoreQualifiers = 0x00000001,
  wbemComparisonFlagIgnoreObjectSource = 0x00000002,
  wbemComparisonFlagIgnoreDefaultValues = 0x00000004,
  wbemComparisonFlagIgnoreClass = 0x00000008,
  wbemComparisonFlagIgnoreCase = 0x00000010,
  wbemComparisonFlagIgnoreFlavor = 0x00000020,
}

// Used to define connection behavior
enum WbemConnectOptionsEnum {
  wbemConnectFlagUseMaxWait = 0x00000080,
}

// Interfaces

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

// An Event source
interface ISWbemEventSource : IDispatch {
  mixin(uuid("27d54d92-0ebe-11d2-8b22-00600806d9b6"));
  // Retrieve the next event within a specified time period. The timeout is specified in milliseconds.
  /*[id(0x00000001)]*/ int NextEvent(int iTimeoutMs, out ISWbemObject objWbemObject);
  // The Security Configurator for this Object
  /*[id(0x00000002)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// Used to obtain Namespace connections
interface ISWbemLocator : IDispatch {
  mixin(uuid("76a6415b-cb41-11d1-8b02-00600806d9b6"));
  // Connect to a Namespace
  /*[id(0x00000001)]*/ int ConnectServer(wchar* strServer, wchar* strNamespace, wchar* strUser, wchar* strPassword, wchar* strLocale, wchar* strAuthority, int iSecurityFlags, IDispatch objWbemNamedValueSet, out ISWbemServices objWbemServices);
  // The Security Configurator for this Object
  /*[id(0x00000002)]*/ int get_Security_(out ISWbemSecurity objWbemSecurity);
}

// The last error on the current thread
interface ISWbemLastError : ISWbemObject {
  mixin(uuid("d962db84-d4bb-11d1-8b09-00600806d9b6"));
}

// A sink for events arising from asynchronous operations
interface ISWbemSinkEvents : IDispatch {
  mixin(uuid("75718ca0-f029-11d1-a1ac-00c04fb6c223"));
  /+// Event triggered when an Object is available
  /*[id(0x00000001)]*/ void OnObjectReady(ISWbemObject objWbemObject, ISWbemNamedValueSet objWbemAsyncContext);+/
  /+// Event triggered when an asynchronous operation is completed
  /*[id(0x00000002)]*/ void OnCompleted(WbemErrorEnum iHResult, ISWbemObject objWbemErrorObject, ISWbemNamedValueSet objWbemAsyncContext);+/
  /+// Event triggered to report the progress of an asynchronous operation
  /*[id(0x00000003)]*/ void OnProgress(int iUpperBound, int iCurrent, wchar* strMessage, ISWbemNamedValueSet objWbemAsyncContext);+/
  /+// Event triggered when an object path is available following a Put operation
  /*[id(0x00000004)]*/ void OnObjectPut(ISWbemObjectPath objWbemObjectPath, ISWbemNamedValueSet objWbemAsyncContext);+/
}

// Asynchronous operation control
interface ISWbemSink : IDispatch {
  mixin(uuid("75718c9f-f029-11d1-a1ac-00c04fb6c223"));
  // Cancel an asynchronous operation
  /*[id(0x00000001)]*/ int Cancel();
}

// A connection to a Namespace
interface ISWbemServicesEx : ISWbemServices {
  mixin(uuid("d2f68443-85dc-427e-91d8-366554cc754c"));
  // Save the Object to this Namespace
  /*[id(0x00000014)]*/ int Put(ISWbemObjectEx objWbemObject, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemObjectPath objWbemObjectPath);
  // Save the Object to this Namespace asynchronously
  /*[id(0x00000015)]*/ int PutAsync(ISWbemSink objWbemSink, ISWbemObjectEx objWbemObject, int iFlags, IDispatch objWbemNamedValueSet, IDispatch objWbemAsyncContext);
}

// A Class or Instance
interface ISWbemObjectEx : ISWbemObject {
  mixin(uuid("269ad56a-8a67-4129-bc8c-0506dcfe9880"));
  // Refresh this Object
  /*[id(0x0000001A)]*/ int Refresh_(int iFlags, IDispatch objWbemNamedValueSet);
  // The collection of System Properties of this Object
  /*[id(0x0000001B)]*/ int get_SystemProperties_(out ISWbemPropertySet objWbemPropertySet);
  // Retrieve a textual representation of this Object
  /*[id(0x0000001C)]*/ int GetText_(WbemObjectTextFormatEnum iObjectTextFormat, int iFlags, IDispatch objWbemNamedValueSet, out wchar* bsText);
  // Set this Object using the supplied textual representation
  /*[id(0x0000001D)]*/ int SetFromText_(wchar* bsText, WbemObjectTextFormatEnum iObjectTextFormat, int iFlags, IDispatch objWbemNamedValueSet);
}

// A Datetime
interface ISWbemDateTime : IDispatch {
  mixin(uuid("5e97458a-cf77-11d3-b38f-00105a1f473a"));
  // The DMTF datetime
  /*[id(0x00000000)]*/ int get_Value(out wchar* strValue);
  // The DMTF datetime
  /*[id(0x00000000)]*/ int put_Value(wchar* strValue);
  // The Year component of the value (must be in the range 0-9999)
  /*[id(0x00000001)]*/ int get_Year(out int iYear);
  // The Year component of the value (must be in the range 0-9999)
  /*[id(0x00000001)]*/ int put_Year(int iYear);
  // Whether the Year component is specified
  /*[id(0x00000002)]*/ int get_YearSpecified(out short bYearSpecified);
  // Whether the Year component is specified
  /*[id(0x00000002)]*/ int put_YearSpecified(short bYearSpecified);
  // The Month component of the value (must be in the range 1-12)
  /*[id(0x00000003)]*/ int get_Month(out int iMonth);
  // The Month component of the value (must be in the range 1-12)
  /*[id(0x00000003)]*/ int put_Month(int iMonth);
  // Whether the Month component is specified
  /*[id(0x00000004)]*/ int get_MonthSpecified(out short bMonthSpecified);
  // Whether the Month component is specified
  /*[id(0x00000004)]*/ int put_MonthSpecified(short bMonthSpecified);
  // The Day component of the value (must be in the range 1-31, or 0-999999 for interval values)
  /*[id(0x00000005)]*/ int get_Day(out int iDay);
  // The Day component of the value (must be in the range 1-31, or 0-999999 for interval values)
  /*[id(0x00000005)]*/ int put_Day(int iDay);
  // Whether the Day component is specified
  /*[id(0x00000006)]*/ int get_DaySpecified(out short bDaySpecified);
  // Whether the Day component is specified
  /*[id(0x00000006)]*/ int put_DaySpecified(short bDaySpecified);
  // The Hours component of the value (must be in the range 0-23)
  /*[id(0x00000007)]*/ int get_Hours(out int iHours);
  // The Hours component of the value (must be in the range 0-23)
  /*[id(0x00000007)]*/ int put_Hours(int iHours);
  // Whether the Hours component is specified
  /*[id(0x00000008)]*/ int get_HoursSpecified(out short bHoursSpecified);
  // Whether the Hours component is specified
  /*[id(0x00000008)]*/ int put_HoursSpecified(short bHoursSpecified);
  // The Minutes component of the value (must be in the range 0-59)
  /*[id(0x00000009)]*/ int get_Minutes(out int iMinutes);
  // The Minutes component of the value (must be in the range 0-59)
  /*[id(0x00000009)]*/ int put_Minutes(int iMinutes);
  // Whether the Minutes component is specified
  /*[id(0x0000000A)]*/ int get_MinutesSpecified(out short bMinutesSpecified);
  // Whether the Minutes component is specified
  /*[id(0x0000000A)]*/ int put_MinutesSpecified(short bMinutesSpecified);
  // The Seconds component of the value (must be in the range 0-59)
  /*[id(0x0000000B)]*/ int get_Seconds(out int iSeconds);
  // The Seconds component of the value (must be in the range 0-59)
  /*[id(0x0000000B)]*/ int put_Seconds(int iSeconds);
  // Whether the Seconds component is specified
  /*[id(0x0000000C)]*/ int get_SecondsSpecified(out short bSecondsSpecified);
  // Whether the Seconds component is specified
  /*[id(0x0000000C)]*/ int put_SecondsSpecified(short bSecondsSpecified);
  // The Microseconds component of the value (must be in the range 0-999999)
  /*[id(0x0000000D)]*/ int get_Microseconds(out int iMicroseconds);
  // The Microseconds component of the value (must be in the range 0-999999)
  /*[id(0x0000000D)]*/ int put_Microseconds(int iMicroseconds);
  // Whether the Microseconds component is specified
  /*[id(0x0000000E)]*/ int get_MicrosecondsSpecified(out short bMicrosecondsSpecified);
  // Whether the Microseconds component is specified
  /*[id(0x0000000E)]*/ int put_MicrosecondsSpecified(short bMicrosecondsSpecified);
  // The UTC component of the value (must be in the range -720 to 720)
  /*[id(0x0000000F)]*/ int get_UTC(out int iUTC);
  // The UTC component of the value (must be in the range -720 to 720)
  /*[id(0x0000000F)]*/ int put_UTC(int iUTC);
  // Whether the UTC component is specified
  /*[id(0x00000010)]*/ int get_UTCSpecified(out short bUTCSpecified);
  // Whether the UTC component is specified
  /*[id(0x00000010)]*/ int put_UTCSpecified(short bUTCSpecified);
  // Indicates whether this value describes an absolute date and time or is an interval
  /*[id(0x00000011)]*/ int get_IsInterval(out short bIsInterval);
  // Indicates whether this value describes an absolute date and time or is an interval
  /*[id(0x00000011)]*/ int put_IsInterval(short bIsInterval);
  // Retrieve value in Variant compatible (VT_DATE) format
  /*[id(0x00000012)]*/ int GetVarDate(short bIsLocal, out double dVarDate);
  // Set the value using Variant compatible (VT_DATE) format
  /*[id(0x00000013)]*/ int SetVarDate(double dVarDate, short bIsLocal);
  // Retrieve value in FILETIME compatible string representation
  /*[id(0x00000014)]*/ int GetFileTime(short bIsLocal, out wchar* strFileTime);
  // Set the value using FILETIME compatible string representation
  /*[id(0x00000015)]*/ int SetFileTime(wchar* strFileTime, short bIsLocal);
}

// A Collection of Refreshable Objects
interface ISWbemRefresher : IDispatch {
  mixin(uuid("14d8250e-d9c2-11d3-b38f-00105a1f473a"));
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown pUnk);
  // Get an item from this refresher
  /*[id(0x00000000)]*/ int Item(int iIndex, out ISWbemRefreshableItem objWbemRefreshableItem);
  // The number of items in this refresher
  /*[id(0x00000001)]*/ int get_Count(out int iCount);
  // Add a refreshable instance to this refresher
  /*[id(0x00000002)]*/ int Add(ISWbemServicesEx objWbemServices, wchar* bsInstancePath, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemRefreshableItem objWbemRefreshableItem);
  // Add a refreshable enumerator to this refresher
  /*[id(0x00000003)]*/ int AddEnum(ISWbemServicesEx objWbemServices, wchar* bsClassName, int iFlags, IDispatch objWbemNamedValueSet, out ISWbemRefreshableItem objWbemRefreshableItem);
  // Remove an item from this refresher
  /*[id(0x00000004)]*/ int Remove(int iIndex, int iFlags);
  // Refresh all items in this collection
  /*[id(0x00000005)]*/ int Refresh(int iFlags);
  // Whether to attempt auto-reconnection to a remote provider
  /*[id(0x00000006)]*/ int get_AutoReconnect(out short bCount);
  // Whether to attempt auto-reconnection to a remote provider
  /*[id(0x00000006)]*/ int put_AutoReconnect(short bCount);
  // Delete all items in this collection
  /*[id(0x00000007)]*/ int DeleteAll();
}

// A single item in a Refresher
interface ISWbemRefreshableItem : IDispatch {
  mixin(uuid("5ad4bf92-daab-11d3-b38f-00105a1f473a"));
  // The index of this item in the parent refresher
  /*[id(0x00000001)]*/ int get_Index(out int iIndex);
  // The parent refresher
  /*[id(0x00000002)]*/ int get_Refresher(out ISWbemRefresher objWbemRefresher);
  // Whether this item represents a single object or an object set
  /*[id(0x00000003)]*/ int get_IsSet(out short bIsSet);
  // The object
  /*[id(0x00000004)]*/ int get_Object(out ISWbemObjectEx objWbemObject);
  // The object set
  /*[id(0x00000005)]*/ int get_ObjectSet(out ISWbemObjectSet objWbemObjectSet);
  // Remove this item from the parent refresher
  /*[id(0x00000006)]*/ int Remove(int iFlags);
}

// CoClasses

// Used to obtain Namespace connections
abstract final class SWbemLocator {
  mixin(uuid("76a64158-cb41-11d1-8b02-00600806d9b6"));
  mixin Interfaces!(ISWbemLocator);
}

// A collection of Named Values
abstract final class SWbemNamedValueSet {
  mixin(uuid("9aed384e-ce8b-11d1-8b05-00600806d9b6"));
  mixin Interfaces!(ISWbemNamedValueSet);
}

// Object Path
abstract final class SWbemObjectPath {
  mixin(uuid("5791bc26-ce9c-11d1-97bf-0000f81e849c"));
  mixin Interfaces!(ISWbemObjectPath);
}

// The last error on the current thread
abstract final class SWbemLastError {
  mixin(uuid("c2feeeac-cfcd-11d1-8b05-00600806d9b6"));
  mixin Interfaces!(ISWbemLastError);
}

// A sink for events arising from asynchronous operations
abstract final class SWbemSink {
  mixin(uuid("75718c9a-f029-11d1-a1ac-00c04fb6c223"));
  mixin Interfaces!(ISWbemSink);
}

// Date & Time
abstract final class SWbemDateTime {
  mixin(uuid("47dfbe54-cf76-11d3-b38f-00105a1f473a"));
  mixin Interfaces!(ISWbemDateTime);
}

// Refresher
abstract final class SWbemRefresher {
  mixin(uuid("d269bf5c-d9c1-11d3-b38f-00105a1f473a"));
  mixin Interfaces!(ISWbemRefresher);
}
