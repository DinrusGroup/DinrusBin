// Version 8.0

/*[uuid("d3295d87-d604-11d4-a704-00c04fa137e4")]*/
module os.win.tlb.microsoft_jscript;

/*[importlib("STDOLE2.TLB")]*/
/*[importlib("Microsoft.Vsa.tlb")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Enums

enum SourceState {
  SourceState_STATE_COLOR_COMMENT = 0x00000001,
  SourceState_STATE_COLOR_NORMAL = 0x00000000,
  SourceState_STATE_COLOR_STRING = 0x00000002,
}

enum TokenColor {
  TokenColor_COLOR_COMMENT = 0x00000003,
  TokenColor_COLOR_CONDITIONAL_COMP = 0x00000007,
  TokenColor_COLOR_IDENTIFIER = 0x00000001,
  TokenColor_COLOR_KEYWORD = 0x00000002,
  TokenColor_COLOR_NUMBER = 0x00000005,
  TokenColor_COLOR_OPERATOR = 0x00000004,
  TokenColor_COLOR_STRING = 0x00000006,
  TokenColor_COLOR_TEXT = 0x00000000,
}

enum JSError {
  JSError_AbstractCannotBePrivate = 0x00000485,
  JSError_AbstractCannotBeStatic = 0x000004C0,
  JSError_AbstractWithBody = 0x000004A8,
  JSError_ActionNotSupported = 0x000001BD,
  JSError_AmbiguousBindingBecauseOfEval = 0x0000047E,
  JSError_AmbiguousBindingBecauseOfWith = 0x0000047D,
  JSError_AmbiguousConstructorCall = 0x000004A0,
  JSError_AmbiguousMatch = 0x0000049F,
  JSError_ArrayLengthAssignIncorrect = 0x000013A6,
  JSError_ArrayLengthConstructIncorrect = 0x000013A5,
  JSError_ArrayMayBeCopied = 0x000004BF,
  JSError_AssemblyAttributesMustBeGlobal = 0x000004E1,
  JSError_AssignmentToReadOnly = 0x000013B0,
  JSError_BadBreak = 0x000003FB,
  JSError_BadContinue = 0x000003FC,
  JSError_BadFunctionDeclaration = 0x000004AF,
  JSError_BadHexDigit = 0x000003FF,
  JSError_BadLabel = 0x00000401,
  JSError_BadModifierInInterface = 0x000004C8,
  JSError_BadOctalLiteral = 0x000004DA,
  JSError_BadPropertyDeclaration = 0x000004B0,
  JSError_BadReturn = 0x000003FA,
  JSError_BadSwitch = 0x0000044F,
  JSError_BadThrow = 0x000004D7,
  JSError_BadVariableDeclaration = 0x000004AE,
  JSError_BadWayToLeaveFinally = 0x000004A6,
  JSError_BaseClassIsExpandoAlready = 0x00000484,
  JSError_BooleanExpected = 0x00001392,
  JSError_CannotAssignToFunctionResult = 0x0000138B,
  JSError_CannotBeAbstract = 0x000004BC,
  JSError_CannotCallSecurityMethodLateBound = 0x000013B4,
  JSError_CannotChangeVisibility = 0x00000493,
  JSError_CannotInstantiateAbstractClass = 0x000004BE,
  JSError_CannotNestPositionDirective = 0x0000045F,
  JSError_CannotReturnValueFromVoidFunction = 0x0000049E,
  JSError_CannotUseNameOfClass = 0x00000464,
  JSError_CannotUseStaticSecurityAttribute = 0x000013B5,
  JSError_CantAssignThis = 0x00001388,
  JSError_CantCreateObject = 0x000001AD,
  JSError_CcInvalidElif = 0x00000452,
  JSError_CcInvalidElse = 0x00000451,
  JSError_CcInvalidEnd = 0x00000450,
  JSError_CcInvalidInDebugger = 0x000004E8,
  JSError_CcOff = 0x00000406,
  JSError_CircularDefinition = 0x00000460,
  JSError_ClashWithProperty = 0x00000499,
  JSError_ClassNotAllowed = 0x00000455,
  JSError_ConstructorMayNotHaveReturnType = 0x000004D1,
  JSError_CustomAttributeUsedMoreThanOnce = 0x000004D4,
  JSError_DateExpected = 0x0000138E,
  JSError_DelegatesShouldNotBeExplicitlyConstructed = 0x000004EA,
  JSError_Deprecated = 0x00000461,
  JSError_DifferentReturnTypeFromBase = 0x00000498,
  JSError_DoesNotHaveAnAddress = 0x000004B3,
  JSError_DupDefault = 0x00000403,
  JSError_DupVisibility = 0x0000044D,
  JSError_DuplicateMethod = 0x000004E3,
  JSError_DuplicateName = 0x00000457,
  JSError_DuplicateNamedParameter = 0x000013AC,
  JSError_EnumNotAllowed = 0x000004CE,
  JSError_EnumeratorExpected = 0x00001397,
  JSError_ErrEOF = 0x00000453,
  JSError_ExceptionFromHResult = 0x0000177B,
  JSError_ExecutablesCannotBeLocalized = 0x000004E6,
  JSError_ExpandoClassShouldNotImpleEnumerable = 0x0000048A,
  JSError_ExpandoMustBePublic = 0x000004E9,
  JSError_ExpandoPrecludesAbstract = 0x000004C6,
  JSError_ExpandoPrecludesOverride = 0x000004C4,
  JSError_ExpandoPrecludesStatic = 0x000004E2,
  JSError_ExpectedAssembly = 0x000004E0,
  JSError_ExpressionExpected = 0x000004AB,
  JSError_FileNotFound = 0x00000035,
  JSError_FinalPrecludesAbstract = 0x000004B9,
  JSError_FractionOutOfRange = 0x000013A2,
  JSError_FuncEvalAborted = 0x00001770,
  JSError_FuncEvalBadLocation = 0x00001777,
  JSError_FuncEvalBadThreadNotStarted = 0x00001775,
  JSError_FuncEvalBadThreadState = 0x00001774,
  JSError_FuncEvalThreadSleepWaitJoin = 0x00001773,
  JSError_FuncEvalThreadSuspended = 0x00001772,
  JSError_FuncEvalTimedout = 0x00001771,
  JSError_FuncEvalWebMethod = 0x00001778,
  JSError_FunctionExpected = 0x0000138A,
  JSError_GetAndSetAreInconsistent = 0x00000476,
  JSError_HidesAbstractInBase = 0x00000494,
  JSError_HidesParentMember = 0x00000492,
  JSError_IllegalAssignment = 0x00001390,
  JSError_IllegalChar = 0x000003F6,
  JSError_IllegalEval = 0x000013A9,
  JSError_IllegalParamArrayAttribute = 0x000004C5,
  JSError_IllegalUseOfSuper = 0x000004A5,
  JSError_IllegalUseOfThis = 0x00000462,
  JSError_IllegalVisibility = 0x0000044E,
  JSError_ImplicitlyReferencedAssemblyNotFound = 0x000004EB,
  JSError_ImpossibleConversion = 0x000004B8,
  JSError_IncompatibleAssemblyReference = 0x000004F3,
  JSError_IncompatibleVisibility = 0x00000454,
  JSError_IncorrectNumberOfIndices = 0x000013B2,
  JSError_InstanceNotAccessibleFromStatic = 0x000004DB,
  JSError_InterfaceIllegalInInterface = 0x000004CB,
  JSError_InternalError = 0x00000033,
  JSError_InvalidAssemblyKeyFile = 0x000004F4,
  JSError_InvalidBaseTypeForEnum = 0x000004BD,
  JSError_InvalidCall = 0x00000005,
  JSError_InvalidCustomAttribute = 0x00000477,
  JSError_InvalidCustomAttributeArgument = 0x00000478,
  JSError_InvalidCustomAttributeClassOrCtor = 0x0000047A,
  JSError_InvalidCustomAttributeTarget = 0x000004CF,
  JSError_InvalidDebugDirective = 0x000004D3,
  JSError_InvalidElse = 0x0000040A,
  JSError_InvalidImport = 0x000004CD,
  JSError_InvalidLanguageOption = 0x0000049B,
  JSError_InvalidPositionDirective = 0x0000045A,
  JSError_InvalidPrototype = 0x0000139F,
  JSError_InvalidResource = 0x000004EE,
  JSError_ItemNotAllowedOnExpandoClass = 0x00000480,
  JSError_KeywordUsedAsIdentifier = 0x00000471,
  JSError_MemberInitializerCannotContainFuncExpr = 0x000004F6,
  JSError_MemberTypeCLSCompliantMismatch = 0x000004F1,
  JSError_MethodClashOnExpandoSuperClass = 0x00000483,
  JSError_MethodInBaseIsNotVirtual = 0x00000496,
  JSError_MethodNotAllowedOnExpandoClass = 0x00000481,
  JSError_MissingConstructForAttributes = 0x00000488,
  JSError_MissingNameParameter = 0x000013AD,
  JSError_MoreNamedParametersThanArguments = 0x000013AE,
  JSError_MustBeEOL = 0x0000045B,
  JSError_MustImplementMethod = 0x00000468,
  JSError_MustProvideNameForNamedParameter = 0x000013AB,
  JSError_NeedArrayObject = 0x000013A7,
  JSError_NeedCompileTimeConstant = 0x00000456,
  JSError_NeedInstance = 0x000004BA,
  JSError_NeedInterface = 0x00000469,
  JSError_NeedObject = 0x000001A8,
  JSError_NeedType = 0x00000458,
  JSError_NestedInstanceTypeCannotBeExtendedByStatic = 0x000004D5,
  JSError_NewNotSpecifiedInMethodDeclaration = 0x00000495,
  JSError_NoAt = 0x00000408,
  JSError_NoCatch = 0x00000409,
  JSError_NoCcEnd = 0x00000405,
  JSError_NoColon = 0x000003EB,
  JSError_NoComma = 0x0000044C,
  JSError_NoCommaOrTypeDefinitionError = 0x000004A7,
  JSError_NoCommentEnd = 0x000003F8,
  JSError_NoConstructor = 0x000013A8,
  JSError_NoEqual = 0x000003F3,
  JSError_NoError = 0x00000000,
  JSError_NoFuncEvalAllowed = 0x00001776,
  JSError_NoIdentifier = 0x000003F2,
  JSError_NoLabel = 0x00000402,
  JSError_NoLeftCurly = 0x000003F0,
  JSError_NoLeftParen = 0x000003ED,
  JSError_NoMemberIdentifier = 0x00000404,
  JSError_NoMethodInBaseToNew = 0x00000497,
  JSError_NoMethodInBaseToOverride = 0x0000049C,
  JSError_NoRightBracket = 0x000003EF,
  JSError_NoRightBracketOrComma = 0x000004AA,
  JSError_NoRightCurly = 0x000003F1,
  JSError_NoRightParen = 0x000003EE,
  JSError_NoRightParenOrComma = 0x000004A9,
  JSError_NoSemicolon = 0x000003EC,
  JSError_NoSuchMember = 0x0000047F,
  JSError_NoSuchStaticMember = 0x000004DE,
  JSError_NoSuchType = 0x000004D9,
  JSError_NoVarInEnum = 0x000004CC,
  JSError_NoWhile = 0x00000400,
  JSError_NonCLSCompliantMember = 0x0000048B,
  JSError_NonCLSCompliantType = 0x000004F0,
  JSError_NonClsException = 0x000013B6,
  JSError_NonStaticWithTypeName = 0x000004DD,
  JSError_NonSupportedInDebugger = 0x000013AF,
  JSError_NotAccessible = 0x00000463,
  JSError_NotAllowedInSuperConstructorCall = 0x00000474,
  JSError_NotAnExpandoFunction = 0x000004E4,
  JSError_NotCollection = 0x000001C3,
  JSError_NotConst = 0x00000407,
  JSError_NotDeletable = 0x0000048C,
  JSError_NotIndexable = 0x00000486,
  JSError_NotInsideClass = 0x00000459,
  JSError_NotMeantToBeCalledDirectly = 0x00000475,
  JSError_NotOKToCallSuper = 0x000004A4,
  JSError_NotValidForConstructor = 0x0000049D,
  JSError_NotValidVersionString = 0x000004E5,
  JSError_NotYetImplemented = 0x000013AA,
  JSError_NumberExpected = 0x00001389,
  JSError_OLENoPropOrMethod = 0x000001B6,
  JSError_ObjectExpected = 0x0000138F,
  JSError_OctalLiteralsAreDeprecated = 0x000004A2,
  JSError_OnlyClassesAllowed = 0x00000489,
  JSError_OnlyClassesAndPackagesAllowed = 0x000004D2,
  JSError_OutOfMemory = 0x00000007,
  JSError_OutOfStack = 0x0000001C,
  JSError_OverrideAndHideUsedTogether = 0x0000049A,
  JSError_PackageExpected = 0x0000048D,
  JSError_PackageInWrongContext = 0x000004D0,
  JSError_ParamListNotLast = 0x000004D8,
  JSError_PossibleBadConversion = 0x000004EC,
  JSError_PossibleBadConversionFromString = 0x000004ED,
  JSError_PrecisionOutOfRange = 0x000013A3,
  JSError_PropertyLevelAttributesMustBeOnGetter = 0x000004D6,
  JSError_RefParamsNonSupportedInDebugger = 0x000013B3,
  JSError_RegExpExpected = 0x00001398,
  JSError_RegExpSyntax = 0x00001399,
  JSError_ShouldBeAbstract = 0x000004C7,
  JSError_SideEffectsDisallowed = 0x0000177C,
  JSError_StaticIsAlreadyFinal = 0x000004C1,
  JSError_StaticMethodsCannotHide = 0x000004C3,
  JSError_StaticMethodsCannotOverride = 0x000004C2,
  JSError_StaticMissingInStaticInit = 0x00000487,
  JSError_StaticRequiresTypeName = 0x000004DC,
  JSError_StaticVarNotAvailable = 0x00001779,
  JSError_StringConcatIsSlow = 0x000004E7,
  JSError_StringExpected = 0x0000138D,
  JSError_SuperClassConstructorNotAccessible = 0x000004A1,
  JSError_SuspectAssignment = 0x000004B6,
  JSError_SuspectLoopCondition = 0x000004DF,
  JSError_SuspectSemicolon = 0x000004B7,
  JSError_SyntaxError = 0x000003EA,
  JSError_TooFewParameters = 0x000004B4,
  JSError_TooManyParameters = 0x0000047C,
  JSError_TooManyTokensSkipped = 0x000004AD,
  JSError_TypeAssemblyCLSCompliantMismatch = 0x000004F2,
  JSError_TypeCannotBeExtended = 0x0000046E,
  JSError_TypeMismatch = 0x0000000D,
  JSError_TypeNameTooLong = 0x000004F5,
  JSError_TypeObjectNotAvailable = 0x0000177A,
  JSError_URIDecodeError = 0x000013A1,
  JSError_URIEncodeError = 0x000013A0,
  JSError_UncaughtException = 0x0000139E,
  JSError_UndeclaredVariable = 0x0000046F,
  JSError_UndefinedIdentifier = 0x00001391,
  JSError_UnexpectedSemicolon = 0x000004AC,
  JSError_UnreachableCatch = 0x0000046D,
  JSError_UnterminatedString = 0x000003F7,
  JSError_UselessAssignment = 0x000004B5,
  JSError_UselessExpression = 0x00000491,
  JSError_VBArrayExpected = 0x00001395,
  JSError_VarIllegalInInterface = 0x000004CA,
  JSError_VariableLeftUninitialized = 0x00000470,
  JSError_VariableMightBeUnitialized = 0x000004A3,
  JSError_WriteOnlyProperty = 0x000013B1,
  JSError_WrongDirective = 0x0000045E,
  JSError_WrongUseOfAddressOf = 0x000004EF,
}

enum JSFunctionAttributeEnum {
  JSFunctionAttributeEnum_ClassicFunction = 0x00000023,
  JSFunctionAttributeEnum_ClassicNestedFunction = 0x0000002F,
  JSFunctionAttributeEnum_HasArguments = 0x00000001,
  JSFunctionAttributeEnum_HasEngine = 0x00000020,
  JSFunctionAttributeEnum_HasStackFrame = 0x00000008,
  JSFunctionAttributeEnum_HasThisObject = 0x00000002,
  JSFunctionAttributeEnum_HasVarArgs = 0x00000010,
  JSFunctionAttributeEnum_IsExpandoMethod = 0x00000040,
  JSFunctionAttributeEnum_IsInstanceNestedClassConstructor = 0x00000080,
  JSFunctionAttributeEnum_IsNested = 0x00000004,
  JSFunctionAttributeEnum_NestedFunction = 0x0000002C,
  JSFunctionAttributeEnum_None = 0x00000000,
}

enum VSAITEMTYPE2 {
  VSAITEMTYPE2_EXPRESSION = 0x00000016,
  VSAITEMTYPE2_HOSTOBJECT = 0x00000010,
  VSAITEMTYPE2_HOSTSCOPE = 0x00000011,
  VSAITEMTYPE2_HOSTSCOPEANDOBJECT = 0x00000012,
  VSAITEMTYPE2_None = 0x00000000,
  VSAITEMTYPE2_SCRIPTBLOCK = 0x00000014,
  VSAITEMTYPE2_SCRIPTSCOPE = 0x00000013,
  VSAITEMTYPE2_STATEMENT = 0x00000015,
}

// Interfaces

interface IMessageReceiver : IDispatch {
  mixin(uuid("f062c7fb-53bf-4f0d-b0f6-d66c5948e63f"));
  /*[id(0x60020000)]*/ int Message(wchar* strValue);
}

interface MemberInfoInitializer : IDispatch {
  mixin(uuid("98a3bf0a-1b56-4f32-ace0-594feb27ec48"));
  /*[id(0x60020000)]*/ int Initialize(wchar* name, COMMemberInfo dispatch);
  /*[id(0x60020001)]*/ int GetCOMMemberInfo(out COMMemberInfo pRetVal);
}

interface COMMemberInfo : IDispatch {
  mixin(uuid("84bceb62-16eb-4e1c-975c-fcb40d331043"));
  /*[id(0x60020000)]*/ int Call(BindingFlags invokeAttr, _Binder binder,  arguments, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int GetValue(BindingFlags invokeAttr, _Binder binder,  index, _CultureInfo culture, out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int SetValue(VARIANT value, BindingFlags invokeAttr, _Binder binder,  index, _CultureInfo culture);
}

interface IDebugConvert : IDispatch {
  mixin(uuid("aa51516d-c0f2-49fe-9d38-61d20456904c"));
  /*[id(0x60020000)]*/ int ToPrimitive(VARIANT value, TypeCode typeCode, short truncationPermitted, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int ByteToString(ubyte value, int radix, out wchar* pRetVal);
  /*[id(0x60020002)]*/ int SByteToString(byte value, int radix, out wchar* pRetVal);
  /*[id(0x60020003)]*/ int Int16ToString(short value, int radix, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int UInt16ToString(ushort value, int radix, out wchar* pRetVal);
  /*[id(0x60020005)]*/ int Int32ToString(int value, int radix, out wchar* pRetVal);
  /*[id(0x60020006)]*/ int UInt32ToString(uint value, int radix, out wchar* pRetVal);
  /*[id(0x60020007)]*/ int Int64ToString(long value, int radix, out wchar* pRetVal);
  /*[id(0x60020008)]*/ int UInt64ToString(ulong value, int radix, out wchar* pRetVal);
  /*[id(0x60020009)]*/ int SingleToString(float value, out wchar* pRetVal);
  /*[id(0x6002000A)]*/ int DoubleToString(double value, out wchar* pRetVal);
  /*[id(0x6002000B)]*/ int BooleanToString(short value, out wchar* pRetVal);
  /*[id(0x6002000C)]*/ int DoubleToDateString(double value, out wchar* pRetVal);
  /*[id(0x6002000D)]*/ int RegexpToString(wchar* source, short ignoreCase, short global, short multiline, out wchar* pRetVal);
  /*[id(0x6002000E)]*/ int StringToPrintable(wchar* source, out wchar* pRetVal);
  /*[id(0x6002000F)]*/ int GetManagedObject(VARIANT value, out IUnknown pRetVal);
  /*[id(0x60020010)]*/ int GetManagedInt64Object(long i, out IUnknown pRetVal);
  /*[id(0x60020011)]*/ int GetManagedUInt64Object(ulong i, out IUnknown pRetVal);
  /*[id(0x60020012)]*/ int GetManagedCharObject(ushort i, out IUnknown pRetVal);
  /*[id(0x60020013)]*/ int GetErrorMessageForHR(int hr, IVsaEngine engine, out wchar* pRetVal);
}

interface IDebugConvert2 : IDispatch {
  mixin(uuid("b370d709-72bd-4696-9825-c4ebadbf98cb"));
  /*[id(0x60020000)]*/ int DecimalToString(DECIMAL value, out wchar* pRetVal);
}

interface IAuthorServices : IDispatch {
  mixin(uuid("9e2b453c-6eaa-4329-a619-62e4889c8c8a"));
  /*[id(0x60020000)]*/ int GetColorizer(out IColorizeText pRetVal);
  /*[id(0x60020001)]*/ int GetCodeSense(out IParseText pRetVal);
}

interface IColorizeText : IDispatch {
  mixin(uuid("db283e60-7adb-4cf6-9758-2931893a12fc"));
  /*[id(0x60020000)]*/ int Colorize(wchar* sourceCode, SourceState state, out ITokenEnumerator pRetVal);
  /*[id(0x60020001)]*/ int GetStateForText(wchar* sourceCode, SourceState currentState, out SourceState pRetVal);
}

interface IParseText : IDispatch {
  mixin(uuid("c1468187-3da1-49df-adf8-5f8600e59ea8"));
  /*[id(0x60020000)]*/ int Parse(wchar* code, IErrorHandler error);
}

interface ITokenEnumerator : IDispatch {
  mixin(uuid("556ba9e0-bd6a-4837-89f0-c79b14759181"));
  /*[id(0x60020000)]*/ int GetNext(out ITokenColorInfo pRetVal);
  /*[id(0x60020001)]*/ int Reset();
}

interface IDebugScriptScope : IDispatch {
  mixin(uuid("59447635-3e26-4873-bf26-05f173b80f5e"));
  /*[id(0x60020000)]*/ int SetThisValue(IUnknown thisValue);
}

interface IDebugType : IDispatch {
  mixin(uuid("613cc05d-05f4-4969-b369-5aeef56e32d0"));
  /*[id(0x60020000)]*/ int HasInstance(IUnknown o, out short pRetVal);
}

interface IDebugVsaScriptCodeItem : IDispatch {
  mixin(uuid("6dfe759a-cb8b-4ca0-a973-1d04e0bf0b53"));
  /*[id(0x60020000)]*/ int Evaluate(out IUnknown pRetVal);
  /*[id(0x60020001)]*/ int ParseNamedBreakPoint(wchar* input, out wchar* functionName, out int nargs, out wchar* arguments, out wchar* returnType, out ulong offset, out short pRetVal);
}

interface IDebuggerObject : IDispatch {
  mixin(uuid("8e93d770-6168-4b68-b896-a71b74c7076a"));
  /*[id(0x60020000)]*/ int IsCOMObject(out short pRetVal);
  /*[id(0x60020001)]*/ int IsEqual(IDebuggerObject o, out short pRetVal);
  /*[id(0x60020002)]*/ int HasEnumerableMember(wchar* name, out short pRetVal);
  /*[id(0x60020003)]*/ int IsScriptFunction(out short pRetVal);
  /*[id(0x60020004)]*/ int IsScriptObject(out short pRetVal);
}

interface IDefineEvent : IDispatch {
  mixin(uuid("d1a19408-bb6b-43eb-bb6f-e7cf6af047d7"));
  /*[id(0x60020000)]*/ int AddEvent(wchar* code, int startLine, out IUnknown pRetVal);
}

interface IEngine2 : IDispatch {
  mixin(uuid("bff6c97f-0705-4394-88b8-a03a4b8b4cd7"));
  /*[id(0x60020000)]*/ int GetAssembly(out _Assembly pRetVal);
  /*[id(0x60020001)]*/ int Run(_AppDomain domain);
  /*[id(0x60020002)]*/ int CompileEmpty(out short pRetVal);
  /*[id(0x60020003)]*/ int RunEmpty();
  /*[id(0x60020004)]*/ int DisconnectEvents();
  /*[id(0x60020005)]*/ int ConnectEvents();
  /*[id(0x60020006)]*/ int RegisterEventSource(wchar* name);
  /*[id(0x60020007)]*/ int Interrupt();
  /*[id(0x60020008)]*/ int InitVsaEngine(wchar* rootMoniker, IVsaSite site);
  /*[id(0x60020009)]*/ int GetGlobalScope(out IVsaScriptScope pRetVal);
  /*[id(0x6002000A)]*/ int GetModule(out _Module pRetVal);
  /*[id(0x6002000B)]*/ int Clone(_AppDomain domain, out IVsaEngine pRetVal);
  /*[id(0x6002000C)]*/ int Restart();
}

interface IVsaScriptScope : IDispatch {
  mixin(uuid("ed4bae22-2f3c-419a-b487-cf869e716b95"));
  /*[id(0x60020000)]*/ int get_Parent(out IVsaScriptScope pRetVal);
  /*[id(0x60020001)]*/ int AddItem(wchar* itemName, VsaItemType type, out IVsaItem pRetVal);
  /*[id(0x60020002)]*/ int GetItem(wchar* itemName, out IVsaItem pRetVal);
  /*[id(0x60020003)]*/ int RemoveItem(wchar* itemName);
  /*[id(0x60020004)]*/ int RemoveItem_2(IVsaItem item);
  /*[id(0x60020005)]*/ int GetItemCount(out int pRetVal);
  /*[id(0x60020006)]*/ int GetItemAtIndex(int index, out IVsaItem pRetVal);
  /*[id(0x60020007)]*/ int RemoveItemAtIndex(int index);
  /*[id(0x60020008)]*/ int GetObject(out VARIANT pRetVal);
  /*[id(0x60020009)]*/ int CreateDynamicItem(wchar* itemName, VsaItemType type, out IVsaItem pRetVal);
}

interface IErrorHandler : IDispatch {
  mixin(uuid("e93d012c-56bb-4f32-864f-7c75eda17b14"));
  /*[id(0x60020000)]*/ int OnCompilerError(IVsaFullErrorInfo error, out short pRetVal);
}

interface IVsaFullErrorInfo : IDispatch {
  mixin(uuid("dc3691bc-f188-4b67-8338-326671e0f3f6"));
  /*[id(0x60020000)]*/ int get_EndLine(out int pRetVal);
}

interface IMethodsCompletionInfo : IDispatch {
  mixin(uuid("e0bcf37b-1c24-451c-ac43-40ff86839117"));
}

interface IObjectCompletionInfo : IDispatch {
  mixin(uuid("052019b5-704b-4b99-aef8-25a11a922b2e"));
}

interface IRedirectOutput : IDispatch {
  mixin(uuid("5b807fa1-00cd-46ee-a493-fd80ac944715"));
  /*[id(0x60020000)]*/ int SetOutputStream(IMessageReceiver output);
}

interface ISite2 : IUnknown {
  mixin(uuid("bff6c980-0705-4394-88b8-a03a4b8b4cd7"));
  /*[id(0x60010000)]*/ int GetParentChain(VARIANT obj, out  pRetVal);
}

interface ITokenColorInfo : IDispatch {
  mixin(uuid("0f20d5c8-cbdb-4b64-ab7f-10b158407323"));
  /*[id(0x60020000)]*/ int get_StartPosition(out int pRetVal);
  /*[id(0x60020001)]*/ int get_EndPosition(out int pRetVal);
  /*[id(0x60020002)]*/ int get_Color(out TokenColor pRetVal);
}

interface IVsaScriptCodeItem : IUnknown {
  mixin(uuid("e0c0ffe8-7eea-4ee5-b7e4-0080c7eb0b74"));
  /*[id(0x60010000)]*/ int get_startLine(out int pRetVal);
  /*[id(0x60010000)]*/ int put_startLine(int pRetVal);
  /*[id(0x60010002)]*/ int get_StartColumn(out int pRetVal);
  /*[id(0x60010002)]*/ int put_StartColumn(int pRetVal);
  /*[id(0x60010004)]*/ int Execute(out VARIANT pRetVal);
}

interface _ActivationObject : IDispatch {
  mixin(uuid("cce639ab-0f0f-32e7-a336-706e96680a4d"));
}

interface _ScriptObject : IDispatch {
  mixin(uuid("5dc9e030-3b2e-3fb8-9691-76d1960d3e16"));
}

interface _GlobalScope : IDispatch {
  mixin(uuid("5a19ae3a-9c96-3d7d-ada7-d76a07404cd0"));
}

interface _VsaEngine : IDispatch {
  mixin(uuid("3c07b8bc-504b-3c65-8bab-5cd562c42269"));
}

interface _COMFieldInfo : IDispatch {
  mixin(uuid("f6b79e22-7a26-3e7b-96c5-5051c7efed6f"));
}

interface _COMMethodInfo : IDispatch {
  mixin(uuid("bb257349-a330-3fd4-a5f0-ab755e05c672"));
}

interface _JSMethod : IDispatch {
  mixin(uuid("bf009b63-a61c-3898-8dbe-a92e1a80b7e0"));
}

interface _COMPropertyInfo : IDispatch {
  mixin(uuid("32a09d98-e870-3ace-9ea4-7443b78f0b71"));
}

interface _DebugConvert : IDispatch {
  mixin(uuid("48c6eca0-1e5e-37dd-8ffc-467113d7a868"));
}

interface _JSAuthor : IDispatch {
  mixin(uuid("eb1fad24-248f-3cec-a2e3-d409de1d6505"));
}

interface _BaseVsaEngine : IDispatch {
  mixin(uuid("7a81699b-1853-36f2-8cb0-40a2c3649864"));
}

// CoClasses

abstract final class VsaEngine {
  mixin(uuid("b71e484d-93ed-4b56-bfb9-ceed5134822b"));
  mixin Interfaces!(_VsaEngine, _Object, IVsaEngine, IEngine2, IRedirectOutput);
}

abstract final class COMFieldInfo {
  mixin(uuid("ca0f511a-faf2-4942-b9a8-17d5e46514e8"));
  mixin Interfaces!(_COMFieldInfo, _Object, ICustomAttributeProvider, _MemberInfo, _FieldInfo, MemberInfoInitializer);
}

abstract final class COMMethodInfo {
  mixin(uuid("c7b9c313-2fd4-4384-8571-7abc08bd17e5"));
  mixin Interfaces!(_COMMethodInfo, _Object, ICustomAttributeProvider, _MemberInfo, _MethodBase, _MethodInfo, MemberInfoInitializer);
}

abstract final class COMPropertyInfo {
  mixin(uuid("6a02951c-b129-4d26-ab92-b9ca19bdca26"));
  mixin Interfaces!(_COMPropertyInfo, _Object, ICustomAttributeProvider, _MemberInfo, _PropertyInfo, MemberInfoInitializer);
}

abstract final class DebugConvert {
  mixin(uuid("432d76ce-8c9e-4eed-addd-91737f27a8cb"));
  mixin Interfaces!(_DebugConvert, _Object, IDebugConvert, IDebugConvert2);
}

abstract final class JSAuthor {
  mixin(uuid("0e4effc0-2387-11d3-b372-00105a98b7ce"));
  mixin Interfaces!(_JSAuthor, _Object, IAuthorServices);
}
