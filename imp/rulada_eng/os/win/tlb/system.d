// Version 2.4

/*[uuid("bee4bfec-6683-3e67-9167-3c0cbc68f40a")]*/
module system;

/*[importlib("stdole2.tlb")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Enums

enum CodeBinaryOperatorType {
  CodeBinaryOperatorType_Add = 0x00000000,
  CodeBinaryOperatorType_Assign = 0x00000005,
  CodeBinaryOperatorType_BitwiseAnd = 0x0000000A,
  CodeBinaryOperatorType_BitwiseOr = 0x00000009,
  CodeBinaryOperatorType_BooleanAnd = 0x0000000C,
  CodeBinaryOperatorType_BooleanOr = 0x0000000B,
  CodeBinaryOperatorType_Divide = 0x00000003,
  CodeBinaryOperatorType_GreaterThan = 0x0000000F,
  CodeBinaryOperatorType_GreaterThanOrEqual = 0x00000010,
  CodeBinaryOperatorType_IdentityEquality = 0x00000007,
  CodeBinaryOperatorType_IdentityInequality = 0x00000006,
  CodeBinaryOperatorType_LessThan = 0x0000000D,
  CodeBinaryOperatorType_LessThanOrEqual = 0x0000000E,
  CodeBinaryOperatorType_Modulus = 0x00000004,
  CodeBinaryOperatorType_Multiply = 0x00000002,
  CodeBinaryOperatorType_Subtract = 0x00000001,
  CodeBinaryOperatorType_ValueEquality = 0x00000008,
}

enum FieldDirection {
  FieldDirection_In = 0x00000000,
  FieldDirection_Out = 0x00000001,
  FieldDirection_Ref = 0x00000002,
}

enum CodeRegionMode {
  CodeRegionMode_End = 0x00000002,
  CodeRegionMode_None = 0x00000000,
  CodeRegionMode_Start = 0x00000001,
}

enum MemberAttributes {
  MemberAttributes_Abstract = 0x00000001,
  MemberAttributes_AccessMask = 0x0000F000,
  MemberAttributes_Assembly = 0x00001000,
  MemberAttributes_Const = 0x00000005,
  MemberAttributes_Family = 0x00003000,
  MemberAttributes_FamilyAndAssembly = 0x00002000,
  MemberAttributes_FamilyOrAssembly = 0x00004000,
  MemberAttributes_Final = 0x00000002,
  MemberAttributes_New = 0x00000010,
  MemberAttributes_Overloaded = 0x00000100,
  MemberAttributes_Override = 0x00000004,
  MemberAttributes_Private = 0x00005000,
  MemberAttributes_Public = 0x00006000,
  MemberAttributes_ScopeMask = 0x0000000F,
  MemberAttributes_Static = 0x00000003,
  MemberAttributes_VTableMask = 0x000000F0,
}

enum CodeTypeReferenceOptions {
  CodeTypeReferenceOptions_GenericTypeParameter = 0x00000002,
  CodeTypeReferenceOptions_GlobalReference = 0x00000001,
}

enum DesignerSerializationVisibility {
  DesignerSerializationVisibility_Content = 0x00000002,
  DesignerSerializationVisibility_Hidden = 0x00000000,
  DesignerSerializationVisibility_Visible = 0x00000001,
}

enum ViewTechnology {
  ViewTechnology_Default = 0x00000002,
  ViewTechnology_Passthrough = 0x00000000,
  ViewTechnology_WindowsForms = 0x00000001,
}

enum SelectionTypes {
  SelectionTypes_Add = 0x00000040,
  SelectionTypes_Auto = 0x00000001,
  SelectionTypes_Click = 0x00000010,
  SelectionTypes_MouseDown = 0x00000004,
  SelectionTypes_MouseUp = 0x00000008,
  SelectionTypes_Normal = 0x00000001,
  SelectionTypes_Primary = 0x00000010,
  SelectionTypes_Remove = 0x00000080,
  SelectionTypes_Replace = 0x00000002,
  SelectionTypes_Toggle = 0x00000020,
  SelectionTypes_Valid = 0x0000001F,
}

// Interfaces

interface ITypeDescriptorContext : IDispatch {
  mixin(uuid("5cbae170-8759-3b8a-b919-e12fb86ad1f3"));
  /*[id(0x60020000)]*/ int get_Container(out IContainer pRetVal);
  /*[id(0x60020001)]*/ int get_Instance(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int get_PropertyDescriptor(out _PropertyDescriptor pRetVal);
  /*[id(0x60020003)]*/ int OnComponentChanging(out short pRetVal);
  /*[id(0x60020004)]*/ int OnComponentChanged();
}

interface IComponent : IDispatch {
  mixin(uuid("b86e59f2-f1e2-389d-b5f1-c55307c8106e"));
  /*[id(0x60020000)]*/ int get_Site(out ISite pRetVal);
  /*[id(0x60020000)]*/ int putref_Site(ISite pRetVal);
  /*[id(0x60020002)]*/ int add_Disposed(_EventHandler value);
  /*[id(0x60020003)]*/ int remove_Disposed(_EventHandler value);
}

interface ISite : IDispatch {
  mixin(uuid("c4e1006a-9d98-3e96-a07e-921725135c28"));
  /*[id(0x60020000)]*/ int get_component(out IComponent pRetVal);
  /*[id(0x60020001)]*/ int get_Container(out IContainer pRetVal);
  /*[id(0x60020002)]*/ int get_DesignMode(out short pRetVal);
  /*[id(0x60020003)]*/ int get_name(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int put_name(wchar* pRetVal);
}

interface IContainer : IDispatch {
  mixin(uuid("61d9c50c-4aad-3539-af82-4f36c19d77c8"));
  /*[id(0x60020000)]*/ int Add(IComponent component);
  /*[id(0x60020001)]*/ int Add_2(IComponent component, wchar* name);
  /*[id(0x60020002)]*/ int get_Components(out _ComponentCollection pRetVal);
  /*[id(0x60020003)]*/ int Remove(IComponent component);
}

interface IDesigner : IDispatch {
  mixin(uuid("6eef3d0d-305a-3df4-9830-8c2b40e1c4bf"));
  /*[id(0x60020000)]*/ int get_component(out IComponent pRetVal);
  /*[id(0x60020001)]*/ int get_Verbs(out _DesignerVerbCollection pRetVal);
  /*[id(0x60020002)]*/ int DoDefaultAction();
  /*[id(0x60020003)]*/ int Initialize(IComponent component);
}

interface IDesignerHost : IDispatch {
  mixin(uuid("eec98cd8-ef5b-3b60-82c9-86f616f6bb20"));
  /*[id(0x60020000)]*/ int get_Loading(out short pRetVal);
  /*[id(0x60020001)]*/ int get_InTransaction(out short pRetVal);
  /*[id(0x60020002)]*/ int get_Container(out IContainer pRetVal);
  /*[id(0x60020003)]*/ int get_RootComponent(out IComponent pRetVal);
  /*[id(0x60020004)]*/ int get_RootComponentClassName(out wchar* pRetVal);
  /*[id(0x60020005)]*/ int get_TransactionDescription(out wchar* pRetVal);
  /*[id(0x60020006)]*/ int add_Activated(_EventHandler value);
  /*[id(0x60020007)]*/ int remove_Activated(_EventHandler value);
  /*[id(0x60020008)]*/ int add_Deactivated(_EventHandler value);
  /*[id(0x60020009)]*/ int remove_Deactivated(_EventHandler value);
  /*[id(0x6002000A)]*/ int add_LoadComplete(_EventHandler value);
  /*[id(0x6002000B)]*/ int remove_LoadComplete(_EventHandler value);
  /*[id(0x6002000C)]*/ int add_TransactionClosed(_DesignerTransactionCloseEventHandler value);
  /*[id(0x6002000D)]*/ int remove_TransactionClosed(_DesignerTransactionCloseEventHandler value);
  /*[id(0x6002000E)]*/ int add_TransactionClosing(_DesignerTransactionCloseEventHandler value);
  /*[id(0x6002000F)]*/ int remove_TransactionClosing(_DesignerTransactionCloseEventHandler value);
  /*[id(0x60020010)]*/ int add_TransactionOpened(_EventHandler value);
  /*[id(0x60020011)]*/ int remove_TransactionOpened(_EventHandler value);
  /*[id(0x60020012)]*/ int add_TransactionOpening(_EventHandler value);
  /*[id(0x60020013)]*/ int remove_TransactionOpening(_EventHandler value);
  /*[id(0x60020014)]*/ int Activate();
  /*[id(0x60020015)]*/ int CreateComponent(_Type componentClass, out IComponent pRetVal);
  /*[id(0x60020016)]*/ int CreateComponent_2(_Type componentClass, wchar* name, out IComponent pRetVal);
  /*[id(0x60020017)]*/ int CreateTransaction(out IUnknown pRetVal);
  /*[id(0x60020018)]*/ int CreateTransaction_2(wchar* description, out IUnknown pRetVal);
  /*[id(0x60020019)]*/ int DestroyComponent(IComponent component);
  /*[id(0x6002001A)]*/ int GetDesigner(IComponent component, out IDesigner pRetVal);
  /*[id(0x6002001B)]*/ int GetType(wchar* typeName, out _Type pRetVal);
}

interface IComponentChangeService : IDispatch {
  mixin(uuid("2fef0210-9ebd-32c0-9bfd-24841ac0fcf7"));
  /*[id(0x60020000)]*/ int add_ComponentAdded(_ComponentEventHandler value);
  /*[id(0x60020001)]*/ int remove_ComponentAdded(_ComponentEventHandler value);
  /*[id(0x60020002)]*/ int add_ComponentAdding(_ComponentEventHandler value);
  /*[id(0x60020003)]*/ int remove_ComponentAdding(_ComponentEventHandler value);
  /*[id(0x60020004)]*/ int add_ComponentChanged(_ComponentChangedEventHandler value);
  /*[id(0x60020005)]*/ int remove_ComponentChanged(_ComponentChangedEventHandler value);
  /*[id(0x60020006)]*/ int add_ComponentChanging(_ComponentChangingEventHandler value);
  /*[id(0x60020007)]*/ int remove_ComponentChanging(_ComponentChangingEventHandler value);
  /*[id(0x60020008)]*/ int add_ComponentRemoved(_ComponentEventHandler value);
  /*[id(0x60020009)]*/ int remove_ComponentRemoved(_ComponentEventHandler value);
  /*[id(0x6002000A)]*/ int add_ComponentRemoving(_ComponentEventHandler value);
  /*[id(0x6002000B)]*/ int remove_ComponentRemoving(_ComponentEventHandler value);
  /*[id(0x6002000C)]*/ int add_ComponentRename(_ComponentRenameEventHandler value);
  /*[id(0x6002000D)]*/ int remove_ComponentRename(_ComponentRenameEventHandler value);
  /*[id(0x6002000E)]*/ int OnComponentChanged(VARIANT component, _MemberDescriptor member, VARIANT oldValue, VARIANT newValue);
  /*[id(0x6002000F)]*/ int OnComponentChanging(VARIANT component, _MemberDescriptor member);
}

interface IServiceContainer : IDispatch {
  mixin(uuid("6ba96b42-7fdd-3223-bf52-7fe677b92815"));
  /*[id(0x60020000)]*/ int AddService(_Type serviceType, VARIANT serviceInstance);
  /*[id(0x60020001)]*/ int AddService_2(_Type serviceType, VARIANT serviceInstance, short promote);
  /*[id(0x60020002)]*/ int AddService_3(_Type serviceType, _ServiceCreatorCallback callback);
  /*[id(0x60020003)]*/ int AddService_4(_Type serviceType, _ServiceCreatorCallback callback, short promote);
  /*[id(0x60020004)]*/ int RemoveService(_Type serviceType);
  /*[id(0x60020005)]*/ int RemoveService_2(_Type serviceType, short promote);
}

interface IEventBindingService : IDispatch {
  mixin(uuid("1a19d89e-f4fe-3e8e-b7ec-05d4e592f3f6"));
  /*[id(0x60020000)]*/ int CreateUniqueMethodName(IComponent component, _EventDescriptor e, out wchar* pRetVal);
  /*[id(0x60020001)]*/ int GetCompatibleMethods(_EventDescriptor e, out ICollection pRetVal);
  /*[id(0x60020002)]*/ int GetEvent(_PropertyDescriptor property, out _EventDescriptor pRetVal);
  /*[id(0x60020003)]*/ int GetEventProperties(_EventDescriptorCollection events, out IUnknown pRetVal);
  /*[id(0x60020004)]*/ int GetEventProperty(_EventDescriptor e, out _PropertyDescriptor pRetVal);
  /*[id(0x60020005)]*/ int ShowCode(out short pRetVal);
  /*[id(0x60020006)]*/ int ShowCode_2(int lineNumber, out short pRetVal);
  /*[id(0x60020007)]*/ int ShowCode_3(IComponent component, _EventDescriptor e, out short pRetVal);
}

interface IMenuCommandService : IDispatch {
  mixin(uuid("df651c5d-783e-3789-901f-a962b7587e69"));
  /*[id(0x60020000)]*/ int get_Verbs(out _DesignerVerbCollection pRetVal);
  /*[id(0x60020001)]*/ int AddCommand(_MenuCommand command);
  /*[id(0x60020002)]*/ int AddVerb(_DesignerVerb verb);
  /*[id(0x60020003)]*/ int FindCommand(_CommandID CommandID, out _MenuCommand pRetVal);
  /*[id(0x60020004)]*/ int GlobalInvoke(_CommandID CommandID, out short pRetVal);
  /*[id(0x60020005)]*/ int RemoveCommand(_MenuCommand command);
  /*[id(0x60020006)]*/ int RemoveVerb(_DesignerVerb verb);
  /*[id(0x60020007)]*/ int ShowContextMenu(_CommandID menuID, int x, int y);
}

interface IRootDesigner : IDispatch {
  mixin(uuid("2cc5e562-6c14-34a6-9d0b-e6ff949ae8fb"));
  /*[id(0x60020000)]*/ int get_SupportedTechnologies(out  pRetVal);
  /*[id(0x60020001)]*/ int GetView(ViewTechnology technology, out VARIANT pRetVal);
}

interface ISelectionService : IDispatch {
  mixin(uuid("297a65be-5080-3f7f-ad19-b0d05d6f2327"));
  /*[id(0x60020000)]*/ int get_PrimarySelection(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int get_SelectionCount(out int pRetVal);
  /*[id(0x60020002)]*/ int add_SelectionChanged(_EventHandler value);
  /*[id(0x60020003)]*/ int remove_SelectionChanged(_EventHandler value);
  /*[id(0x60020004)]*/ int add_SelectionChanging(_EventHandler value);
  /*[id(0x60020005)]*/ int remove_SelectionChanging(_EventHandler value);
  /*[id(0x60020006)]*/ int GetComponentSelected(VARIANT component, out short pRetVal);
  /*[id(0x60020007)]*/ int GetSelectedComponents(out ICollection pRetVal);
  /*[id(0x60020008)]*/ int SetSelectedComponents(ICollection Components);
  /*[id(0x60020009)]*/ int SetSelectedComponents_2(ICollection Components, SelectionTypes selectionType);
}

interface _CodeDomProvider : IDispatch {
  mixin(uuid("61059e8d-1dd2-3f4b-a4c5-d566b8968ffb"));
}

interface _TypeConverter : IDispatch {
  mixin(uuid("05241989-96c5-3bf9-ab9b-37e261c1b8f8"));
}

interface _CodeTypeMember : IDispatch {
  mixin(uuid("8068ae1d-26cb-3db6-97cd-ed83de116c5a"));
}

interface _CodeArgumentReferenceExpression : IDispatch {
  mixin(uuid("a52b85c6-5370-35c9-a04a-04a92013862c"));
}

interface _CodeExpression : IDispatch {
  mixin(uuid("ad377794-864f-3421-9fb8-c684bbc1bc02"));
}

interface _CodeArrayCreateExpression : IDispatch {
  mixin(uuid("f7955e55-7f3b-3277-aa0c-f62aa615676d"));
}

interface _CodeTypeReference : IDispatch {
  mixin(uuid("b6d972c6-022b-3f91-9655-e288e9d32c55"));
}

interface _CodeExpressionCollection : IDispatch {
  mixin(uuid("af72cc74-2275-362a-9141-a4a79d596f39"));
}

interface _CodeArrayIndexerExpression : IDispatch {
  mixin(uuid("732748f5-5256-327b-a7e5-2000b07f21b3"));
}

interface _CodeAssignStatement : IDispatch {
  mixin(uuid("e2024de0-dc21-305d-8761-6c31f2177fb0"));
}

interface _CodeStatement : IDispatch {
  mixin(uuid("b125774d-ef66-382b-878d-2d916999b0d2"));
}

interface _CodeAttachEventStatement : IDispatch {
  mixin(uuid("f7bc47e9-706c-3aa7-b1ba-8ab95188fa11"));
}

interface _CodeEventReferenceExpression : IDispatch {
  mixin(uuid("35872687-5a11-34d7-85ab-865830a3bdee"));
}

interface _CodeAttributeArgument : IDispatch {
  mixin(uuid("02efd952-ff8c-3b72-8c33-739a506d53d9"));
}

interface _CodeAttributeArgumentCollection : IDispatch {
  mixin(uuid("fe84e484-a7ec-3d15-b5e2-edc2de2db42e"));
}

interface _CodeAttributeDeclaration : IDispatch {
  mixin(uuid("ef72d021-2c6d-3e33-9442-574bfd6e0871"));
}

interface _CodeAttributeDeclarationCollection : IDispatch {
  mixin(uuid("7e9aca22-637c-3f88-a931-aaf36a4f9a6b"));
}

interface _CodeBaseReferenceExpression : IDispatch {
  mixin(uuid("45e29ca6-670a-3b13-9557-4e5903056bf3"));
}

interface _CodeBinaryOperatorExpression : IDispatch {
  mixin(uuid("a22929c9-d301-3f5b-98b7-844fdba1dedf"));
}

interface _CodeCastExpression : IDispatch {
  mixin(uuid("90bed8ed-21e3-31fe-8f02-c929ba4fb0ac"));
}

interface _CodeCatchClause : IDispatch {
  mixin(uuid("609c7788-bdb0-364c-92e3-fc16ac613430"));
}

interface _CodeStatementCollection : IDispatch {
  mixin(uuid("4b9a5032-4b8c-3de6-997c-c38b4b3af26a"));
}

interface _CodeCatchClauseCollection : IDispatch {
  mixin(uuid("ff5e1cd9-0478-34a4-9b9c-7c80bcb1a725"));
}

interface _CodeChecksumPragma : IDispatch {
  mixin(uuid("7eb20114-e822-358c-bdab-dcf9e5090f23"));
}

interface _CodeDirective : IDispatch {
  mixin(uuid("767e752e-2315-35cf-9652-7fc46ae870d3"));
}

interface _CodeComment : IDispatch {
  mixin(uuid("c94f39b3-436f-3711-9cb0-91c6299b62a2"));
}

interface _CodeObject : IDispatch {
  mixin(uuid("ee499efd-22e2-3740-a64a-2ab010099c01"));
}

interface _CodeCommentStatement : IDispatch {
  mixin(uuid("0c13f8b9-f2e0-3918-a33e-3e491bdc529e"));
}

interface _CodeCommentStatementCollection : IDispatch {
  mixin(uuid("e34ceb72-8f86-333d-aeda-069221df6a1a"));
}

interface _CodeCompileUnit : IDispatch {
  mixin(uuid("6f20c263-af67-380f-a482-9a21f7599748"));
}

interface _CodeNamespaceCollection : IDispatch {
  mixin(uuid("f5e54f16-ade3-3b5d-8b05-1f9803557905"));
}

interface _CodeDirectiveCollection : IDispatch {
  mixin(uuid("eefbdd27-4904-3e90-acfc-624164cb45dd"));
}

interface _CodeConditionStatement : IDispatch {
  mixin(uuid("69904b31-5fb5-39bf-83b0-5ddfa1f26d71"));
}

interface _CodeConstructor : IDispatch {
  mixin(uuid("5a33c771-806e-337d-ae1f-66b523fc49bf"));
}

interface _CodeMemberMethod : IDispatch {
  mixin(uuid("95c2ee26-4247-3ddc-8056-97353f10de8f"));
}

interface _CodeDefaultValueExpression : IDispatch {
  mixin(uuid("ea9e1dd2-ef9a-3570-ae1a-2f625f594c3b"));
}

interface _CodeDelegateCreateExpression : IDispatch {
  mixin(uuid("d14e12c1-e1d1-3b74-a3af-021a5a268fbe"));
}

interface _CodeDelegateInvokeExpression : IDispatch {
  mixin(uuid("6f6c3482-8900-36ea-b621-943534e82c73"));
}

interface _CodeDirectionExpression : IDispatch {
  mixin(uuid("11edaf3b-144e-32c8-8be0-81d40a950656"));
}

interface _CodeEntryPointMethod : IDispatch {
  mixin(uuid("7cd4ef19-27eb-399e-8ed2-c6647a99c03e"));
}

interface _CodeExpressionStatement : IDispatch {
  mixin(uuid("cea240af-60c5-3c69-9da1-da3f9a6d7b3c"));
}

interface _CodeFieldReferenceExpression : IDispatch {
  mixin(uuid("82d57b2b-c639-32a0-89b4-62a0c29dd64e"));
}

interface _CodeGotoStatement : IDispatch {
  mixin(uuid("8f1baed9-52ec-3545-9cf0-6ed71a76a5ca"));
}

interface _CodeIndexerExpression : IDispatch {
  mixin(uuid("c92c323f-8601-34d4-a2d6-f5e2653db456"));
}

interface _CodeIterationStatement : IDispatch {
  mixin(uuid("b16f7137-c0e7-3ecf-9652-fb1ea947e44e"));
}

interface _CodeLabeledStatement : IDispatch {
  mixin(uuid("56699cca-fd8d-3ad2-9643-149bad87fd60"));
}

interface _CodeLinePragma : IDispatch {
  mixin(uuid("1b52ded6-92f3-3b4f-851c-ab1f647582a3"));
}

interface _CodeMemberEvent : IDispatch {
  mixin(uuid("e1a7ea9f-5d43-3fa9-afbc-9a2bfda84b65"));
}

interface _CodeTypeReferenceCollection : IDispatch {
  mixin(uuid("68a04561-d0a0-3eeb-b904-462dc4eb5531"));
}

interface _CodeMemberField : IDispatch {
  mixin(uuid("eef50d17-7aa6-3e14-96c6-dd90fe5baa1e"));
}

interface _CodeParameterDeclarationExpressionCollection : IDispatch {
  mixin(uuid("05192769-7d6a-3c8c-94c2-dfa668f61088"));
}

interface _CodeTypeParameterCollection : IDispatch {
  mixin(uuid("6e814f1f-c349-3766-b55d-87c9b0232b20"));
}

interface _CodeMemberProperty : IDispatch {
  mixin(uuid("802e2acc-a7f8-3ca9-9114-f49998bebe6e"));
}

interface _CodeMethodInvokeExpression : IDispatch {
  mixin(uuid("ffe1f142-85cf-3353-8512-ee73775e9c4c"));
}

interface _CodeMethodReferenceExpression : IDispatch {
  mixin(uuid("cbdf02f4-a9f4-33c0-8b24-275008890dcb"));
}

interface _CodeMethodReturnStatement : IDispatch {
  mixin(uuid("851d821b-1e0c-3e91-832d-ba593523f566"));
}

interface _CodeNamespace : IDispatch {
  mixin(uuid("31ed1dcb-c007-3f96-8809-4d5e3540a7c1"));
}

interface _CodeTypeDeclarationCollection : IDispatch {
  mixin(uuid("be0eced3-5f0d-310a-b352-7d1adf28f8ec"));
}

interface _CodeNamespaceImportCollection : IDispatch {
  mixin(uuid("4c545457-76d7-3c56-b277-6a9e86d1046f"));
}

interface _CodeNamespaceImport : IDispatch {
  mixin(uuid("34418787-726b-3e74-aeed-c01397fc707d"));
}

interface _CodeObjectCreateExpression : IDispatch {
  mixin(uuid("cfe5e5e9-745f-348b-a7e6-38a46d1a20e0"));
}

interface _CodeParameterDeclarationExpression : IDispatch {
  mixin(uuid("ee96565b-2b1a-33c6-ba07-b63158f1c8c4"));
}

interface _CodePrimitiveExpression : IDispatch {
  mixin(uuid("175bb49a-4cbe-38b3-8c6c-1b0145edabb7"));
}

interface _CodePropertyReferenceExpression : IDispatch {
  mixin(uuid("f8d64802-f9b7-3095-a641-d31e6e9f87b1"));
}

interface _CodePropertySetValueReferenceExpression : IDispatch {
  mixin(uuid("2ee13fa1-8a02-3573-9ac9-4febd2ceab45"));
}

interface _CodeRegionDirective : IDispatch {
  mixin(uuid("26ae5cc6-ccfd-3906-8b68-16e5eefabb10"));
}

interface _CodeRemoveEventStatement : IDispatch {
  mixin(uuid("853bc437-ca6e-375d-bcbb-818e917d9691"));
}

interface _CodeSnippetCompileUnit : IDispatch {
  mixin(uuid("c7d34cf6-cf82-38b0-bf67-eb36da63ae6e"));
}

interface _CodeSnippetExpression : IDispatch {
  mixin(uuid("9f3e3cd1-8082-31e9-851c-3e177e56a87b"));
}

interface _CodeSnippetStatement : IDispatch {
  mixin(uuid("b4b00613-c48b-3fa9-b8f6-a527ec6f21c3"));
}

interface _CodeSnippetTypeMember : IDispatch {
  mixin(uuid("575bf8d0-7a9d-39eb-81f9-aa2beba890fa"));
}

interface _CodeThisReferenceExpression : IDispatch {
  mixin(uuid("3b4a1a6b-8e65-355d-b93a-e6ab753b2401"));
}

interface _CodeThrowExceptionStatement : IDispatch {
  mixin(uuid("12350e95-6f4e-30f0-9343-72f1c64380a0"));
}

interface _CodeTryCatchFinallyStatement : IDispatch {
  mixin(uuid("8fd0f76a-29bf-3982-8335-c9b44abf31c3"));
}

interface _CodeTypeConstructor : IDispatch {
  mixin(uuid("261ad877-0f22-33de-9a3a-31f5da424b30"));
}

interface _CodeTypeDeclaration : IDispatch {
  mixin(uuid("7aa363e1-fa53-31eb-be4a-1eb4838264f3"));
}

interface _CodeTypeMemberCollection : IDispatch {
  mixin(uuid("f943231e-6192-33a0-9ca3-d6ed0e4f323d"));
}

interface _CodeTypeDelegate : IDispatch {
  mixin(uuid("455090ab-5c44-3f4f-8eed-ccc90a3112b5"));
}

interface _CodeTypeOfExpression : IDispatch {
  mixin(uuid("12cbce8e-75ff-312f-81b9-7fbc6212090b"));
}

interface _CodeTypeParameter : IDispatch {
  mixin(uuid("b6ed2127-296f-3b31-aeb5-e2101e98d746"));
}

interface _CodeTypeReferenceExpression : IDispatch {
  mixin(uuid("726bb04d-2c4c-3e3d-a01a-31448db063dd"));
}

interface _CodeVariableDeclarationStatement : IDispatch {
  mixin(uuid("4192a87c-5c57-3879-8624-af5ca2ed9eb2"));
}

interface _CodeVariableReferenceExpression : IDispatch {
  mixin(uuid("54b54936-a71c-3a45-b982-2c484e7bcf86"));
}

interface _Component : IDispatch {
  mixin(uuid("06565c0f-c465-37de-896f-9864bc0bfc96"));
}

interface _AttributeCollection : IDispatch {
  mixin(uuid("6f971e04-b06a-3dd0-b6f5-622826693454"));
}

interface _PropertyDescriptor : IDispatch {
  mixin(uuid("fe5060f8-212f-3a4f-8fa8-db2e14588c49"));
}

interface _ComponentCollection : IDispatch {
  mixin(uuid("42f00c62-f454-3a38-af9e-35d4e2bdfdac"));
}

interface _EventDescriptor : IDispatch {
  mixin(uuid("95b6a563-4a39-37a2-91d7-04b8ecdd1b66"));
}

interface _EventDescriptorCollection : IDispatch {
  mixin(uuid("4c933253-83f2-35b6-961a-0780ff1baf7c"));
}

interface _MemberDescriptor : IDispatch {
  mixin(uuid("f55efa91-812e-3c6e-998f-3598e93fb8a7"));
}

interface _MarshalByValueComponent : IDispatch {
  mixin(uuid("35f38044-2017-3e05-ba83-1b87cc0d49c7"));
}

interface _CommandID : IDispatch {
  mixin(uuid("fc50598b-2406-33d2-ba9a-cfbea52bc05a"));
}

interface _ComponentChangedEventArgs : IDispatch {
  mixin(uuid("a8fef1c6-d434-3686-a4de-b68e8eabb509"));
}

interface _ComponentChangedEventHandler : IDispatch {
  mixin(uuid("0451c390-1f90-341d-9278-b9ff2636d67d"));
}

interface _ComponentChangingEventArgs : IDispatch {
  mixin(uuid("b78cbaa3-37df-31c9-abd2-cdcb1a7fba9f"));
}

interface _ComponentChangingEventHandler : IDispatch {
  mixin(uuid("7f8c2da3-d337-334f-92e9-87be9bdc6070"));
}

interface _ComponentEventArgs : IDispatch {
  mixin(uuid("438e8dcf-6875-305f-8ca5-40dbb15782a6"));
}

interface _ComponentEventHandler : IDispatch {
  mixin(uuid("290b355d-80d3-3afa-96ab-b4d395729374"));
}

interface _ComponentRenameEventArgs : IDispatch {
  mixin(uuid("da5d7739-9522-3e28-9ab7-7c2d7d27c63a"));
}

interface _ComponentRenameEventHandler : IDispatch {
  mixin(uuid("ba2df049-da87-3bd1-97b0-7904b59adf7e"));
}

interface _DesignerTransactionCloseEventArgs : IDispatch {
  mixin(uuid("3924a637-c2c4-3558-945f-279b5ac39ed9"));
}

interface _DesignerTransactionCloseEventHandler : IDispatch {
  mixin(uuid("4543d155-ee6a-3529-bc8d-cf0e866b6b0b"));
}

interface _DesignerVerb : IDispatch {
  mixin(uuid("7c41b90e-52fb-3e54-8b03-ebe0bf172c84"));
}

interface _MenuCommand : IDispatch {
  mixin(uuid("1ff238ce-6190-3750-a34f-05f02b7315a6"));
}

interface _DesignerVerbCollection : IDispatch {
  mixin(uuid("ac3bdda4-25b8-3321-a1c0-7c37bbf2dded"));
}

interface _ServiceCreatorCallback : IDispatch {
  mixin(uuid("be380bec-79f2-3876-b510-fa2fe43b7eb7"));
}

interface _DesignerLoader : IDispatch {
  mixin(uuid("43be964c-1b4a-3d1f-9d94-8185a1e6cb7b"));
}

interface _PerformanceCounterManager : IDispatch {
  mixin(uuid("a9809e7d-42f8-3284-82cf-ab5f863a29aa"));
}

interface _WebHeaderCollection : IDispatch {
  mixin(uuid("b97e84f2-fab2-340d-8d49-2ac85cf5c0ec"));
}

interface _WebClient : IDispatch {
  mixin(uuid("85b4a627-7552-3aa6-8a1c-a213c5788fec"));
}

interface _StandardOleMarshalObject : IDispatch {
  mixin(uuid("05f3d6c7-d4d1-37eb-ac35-63347b838a23"));
}

// CoClasses

abstract final class TypeConverter {
  mixin(uuid("75992c48-bf7a-3b44-ac68-a946cffdb2bf"));
  mixin Interfaces!(_TypeConverter, _Object);
}

abstract final class CodeTypeMember {
  mixin(uuid("69dce654-e184-38e5-bfd6-e0eb6f592a11"));
  mixin Interfaces!(_CodeTypeMember, _Object);
}

abstract final class CodeArgumentReferenceExpression {
  mixin(uuid("3e3f971a-a80d-3468-a9eb-3113ce46d13a"));
  mixin Interfaces!(_CodeArgumentReferenceExpression, _Object);
}

abstract final class CodeExpression {
  mixin(uuid("f4267fe0-72e6-34e2-9093-17dea43078c1"));
  mixin Interfaces!(_CodeExpression, _Object);
}

abstract final class CodeArrayCreateExpression {
  mixin(uuid("24b3bced-984a-340b-923c-c9b39d94d5a9"));
  mixin Interfaces!(_CodeArrayCreateExpression, _Object);
}

abstract final class CodeTypeReference {
  mixin(uuid("f3de25ac-25ed-374c-8805-4b6456fa0cb2"));
  mixin Interfaces!(_CodeTypeReference, _Object);
}

abstract final class CodeExpressionCollection {
  mixin(uuid("26d06c1f-81ba-33c3-bde2-49747aa83a11"));
  mixin Interfaces!(_CodeExpressionCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeArrayIndexerExpression {
  mixin(uuid("8c0bc333-6f03-3228-8b5c-31c8627daab3"));
  mixin Interfaces!(_CodeArrayIndexerExpression, _Object);
}

abstract final class CodeAssignStatement {
  mixin(uuid("e4350caa-27c9-320e-ac79-71294abda592"));
  mixin Interfaces!(_CodeAssignStatement, _Object);
}

abstract final class CodeStatement {
  mixin(uuid("10a98d9f-994d-3762-89b4-2116a95063ee"));
  mixin Interfaces!(_CodeStatement, _Object);
}

abstract final class CodeAttachEventStatement {
  mixin(uuid("1ab6b26c-a339-3b51-9308-44ca3a05f873"));
  mixin Interfaces!(_CodeAttachEventStatement, _Object);
}

abstract final class CodeEventReferenceExpression {
  mixin(uuid("e396945b-2690-377e-a992-12775d444cd7"));
  mixin Interfaces!(_CodeEventReferenceExpression, _Object);
}

abstract final class CodeAttributeArgument {
  mixin(uuid("06e6faa2-7623-396a-b9f1-75d31a17cf27"));
  mixin Interfaces!(_CodeAttributeArgument, _Object);
}

abstract final class CodeAttributeArgumentCollection {
  mixin(uuid("424720cd-671f-329d-80df-fa8bcd9ea9cd"));
  mixin Interfaces!(_CodeAttributeArgumentCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeAttributeDeclaration {
  mixin(uuid("c0ba0202-2ff3-3e0a-952a-b570b1371db2"));
  mixin Interfaces!(_CodeAttributeDeclaration, _Object);
}

abstract final class CodeAttributeDeclarationCollection {
  mixin(uuid("3a8e937e-c560-3779-a423-b645bad276a1"));
  mixin Interfaces!(_CodeAttributeDeclarationCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeBaseReferenceExpression {
  mixin(uuid("3a9e7044-fbd0-3e23-82ae-f0dfb86c0c4e"));
  mixin Interfaces!(_CodeBaseReferenceExpression, _Object);
}

abstract final class CodeBinaryOperatorExpression {
  mixin(uuid("30776c84-e88e-330d-8ce2-b5bf1e48427d"));
  mixin Interfaces!(_CodeBinaryOperatorExpression, _Object);
}

abstract final class CodeCastExpression {
  mixin(uuid("de2ae793-c1c1-3c33-8b9c-0d8f90301860"));
  mixin Interfaces!(_CodeCastExpression, _Object);
}

abstract final class CodeCatchClause {
  mixin(uuid("548f7954-b3fd-39e0-9a30-9d8fc9443c0e"));
  mixin Interfaces!(_CodeCatchClause, _Object);
}

abstract final class CodeStatementCollection {
  mixin(uuid("a531374e-fa08-36c6-af96-31c684eefc08"));
  mixin Interfaces!(_CodeStatementCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeCatchClauseCollection {
  mixin(uuid("2077ecf3-61c8-3cc5-9e45-721189a88e03"));
  mixin Interfaces!(_CodeCatchClauseCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeChecksumPragma {
  mixin(uuid("e1845f73-c0cc-3b6b-b913-6e43f42d8ba1"));
  mixin Interfaces!(_CodeChecksumPragma, _Object);
}

abstract final class CodeDirective {
  mixin(uuid("6b405f7d-01ca-3595-a65b-34cb0168aca0"));
  mixin Interfaces!(_CodeDirective, _Object);
}

abstract final class CodeComment {
  mixin(uuid("f3e7e9c5-e63a-3f3b-a4f8-096e82664819"));
  mixin Interfaces!(_CodeComment, _Object);
}

abstract final class CodeObject {
  mixin(uuid("88d0c986-398a-3a31-9349-b0736357c40b"));
  mixin Interfaces!(_CodeObject, _Object);
}

abstract final class CodeCommentStatement {
  mixin(uuid("f69f43d6-ef83-3723-8839-519d2421e927"));
  mixin Interfaces!(_CodeCommentStatement, _Object);
}

abstract final class CodeCommentStatementCollection {
  mixin(uuid("c12a8292-f24a-3ba8-94e6-eb3206d225e2"));
  mixin Interfaces!(_CodeCommentStatementCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeCompileUnit {
  mixin(uuid("25a5d609-4d61-3c52-a3e1-49ef93066fd1"));
  mixin Interfaces!(_CodeCompileUnit, _Object);
}

abstract final class CodeNamespaceCollection {
  mixin(uuid("d4985194-80e5-36fe-8b95-8cd2e35e5ff5"));
  mixin Interfaces!(_CodeNamespaceCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeDirectiveCollection {
  mixin(uuid("ed78c3fa-ab56-353c-98bb-9280d3404c81"));
  mixin Interfaces!(_CodeDirectiveCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeConditionStatement {
  mixin(uuid("1ba2de2f-ee39-3628-968f-0e12705013c4"));
  mixin Interfaces!(_CodeConditionStatement, _Object);
}

abstract final class CodeConstructor {
  mixin(uuid("2a7a02a4-408d-32c6-b5e2-bc4b57399b0c"));
  mixin Interfaces!(_CodeConstructor, _Object);
}

abstract final class CodeMemberMethod {
  mixin(uuid("812e9b72-2ccc-364b-9eb8-da8f4eae724f"));
  mixin Interfaces!(_CodeMemberMethod, _Object);
}

abstract final class CodeDefaultValueExpression {
  mixin(uuid("5aecb7a2-5797-3bff-9b86-fc4cb9ae4f41"));
  mixin Interfaces!(_CodeDefaultValueExpression, _Object);
}

abstract final class CodeDelegateCreateExpression {
  mixin(uuid("92fb692e-211c-33da-be48-05b690d3f00b"));
  mixin Interfaces!(_CodeDelegateCreateExpression, _Object);
}

abstract final class CodeDelegateInvokeExpression {
  mixin(uuid("d79b10b1-16a3-3a23-a606-ce1227f3765a"));
  mixin Interfaces!(_CodeDelegateInvokeExpression, _Object);
}

abstract final class CodeDirectionExpression {
  mixin(uuid("5fea4be0-d7fc-3daf-877e-16f181f18bae"));
  mixin Interfaces!(_CodeDirectionExpression, _Object);
}

abstract final class CodeEntryPointMethod {
  mixin(uuid("dff5c8a1-425f-305d-ae85-10c9dd7704c3"));
  mixin Interfaces!(_CodeEntryPointMethod, _Object);
}

abstract final class CodeExpressionStatement {
  mixin(uuid("abc8fc89-d640-32fc-9e9f-04410010e5ec"));
  mixin Interfaces!(_CodeExpressionStatement, _Object);
}

abstract final class CodeFieldReferenceExpression {
  mixin(uuid("e2f01f29-a264-387b-ae29-a273ac89eee7"));
  mixin Interfaces!(_CodeFieldReferenceExpression, _Object);
}

abstract final class CodeGotoStatement {
  mixin(uuid("148e03e0-c74e-3d67-bd3a-b27995f9ac49"));
  mixin Interfaces!(_CodeGotoStatement, _Object);
}

abstract final class CodeIndexerExpression {
  mixin(uuid("4d19b9bb-0979-38be-b438-29997e58c2d1"));
  mixin Interfaces!(_CodeIndexerExpression, _Object);
}

abstract final class CodeIterationStatement {
  mixin(uuid("421c8130-0316-3993-801d-e6be3a159baa"));
  mixin Interfaces!(_CodeIterationStatement, _Object);
}

abstract final class CodeLabeledStatement {
  mixin(uuid("4975b127-5464-3e9e-b4aa-d6df3721189a"));
  mixin Interfaces!(_CodeLabeledStatement, _Object);
}

abstract final class CodeLinePragma {
  mixin(uuid("17575ea6-be56-381e-88e7-74b376743e77"));
  mixin Interfaces!(_CodeLinePragma, _Object);
}

abstract final class CodeMemberEvent {
  mixin(uuid("e401e3c7-2646-37c7-a37a-ba115d000faa"));
  mixin Interfaces!(_CodeMemberEvent, _Object);
}

abstract final class CodeTypeReferenceCollection {
  mixin(uuid("3f2e333c-9a04-33ac-95c7-7b0015beb345"));
  mixin Interfaces!(_CodeTypeReferenceCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeMemberField {
  mixin(uuid("acdcdf3a-21dc-37e3-9253-cd26caec0b58"));
  mixin Interfaces!(_CodeMemberField, _Object);
}

abstract final class CodeParameterDeclarationExpressionCollection {
  mixin(uuid("7fd9e7c0-b133-302f-a3a1-42167780cb62"));
  mixin Interfaces!(_CodeParameterDeclarationExpressionCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeTypeParameterCollection {
  mixin(uuid("6019c9d4-84cb-33bc-9e79-25f21172c33b"));
  mixin Interfaces!(_CodeTypeParameterCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeMemberProperty {
  mixin(uuid("d459c868-9174-353a-bb17-f2166e83fe24"));
  mixin Interfaces!(_CodeMemberProperty, _Object);
}

abstract final class CodeMethodInvokeExpression {
  mixin(uuid("62ac67b4-2088-3db7-9a80-154efe9c6caf"));
  mixin Interfaces!(_CodeMethodInvokeExpression, _Object);
}

abstract final class CodeMethodReferenceExpression {
  mixin(uuid("36ae2637-c0a4-3214-8a93-aee1cabd540e"));
  mixin Interfaces!(_CodeMethodReferenceExpression, _Object);
}

abstract final class CodeMethodReturnStatement {
  mixin(uuid("031a6b24-bfaa-3d76-b6da-59c9c469a0fb"));
  mixin Interfaces!(_CodeMethodReturnStatement, _Object);
}

abstract final class CodeNamespace {
  mixin(uuid("dd1c0c7a-bc95-339a-8321-9dbf4803caf4"));
  mixin Interfaces!(_CodeNamespace, _Object);
}

abstract final class CodeTypeDeclarationCollection {
  mixin(uuid("a0bd9913-b07d-32c3-8df1-aa998b3fb10e"));
  mixin Interfaces!(_CodeTypeDeclarationCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeNamespaceImportCollection {
  mixin(uuid("7a168834-5605-30db-8274-6b21e621a955"));
  mixin Interfaces!(_CodeNamespaceImportCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeNamespaceImport {
  mixin(uuid("b0b32470-44a6-3dbc-bdb2-ce024f966088"));
  mixin Interfaces!(_CodeNamespaceImport, _Object);
}

abstract final class CodeObjectCreateExpression {
  mixin(uuid("f3ba98c3-39cf-3c2d-ada5-75bd63d7af08"));
  mixin Interfaces!(_CodeObjectCreateExpression, _Object);
}

abstract final class CodeParameterDeclarationExpression {
  mixin(uuid("6acd3b02-ef29-31b9-8958-45b47bad4a00"));
  mixin Interfaces!(_CodeParameterDeclarationExpression, _Object);
}

abstract final class CodePrimitiveExpression {
  mixin(uuid("6c1e6791-0558-3cd3-aab8-c90a2b03ef5f"));
  mixin Interfaces!(_CodePrimitiveExpression, _Object);
}

abstract final class CodePropertyReferenceExpression {
  mixin(uuid("9703f066-9c59-32c4-86b2-570e97ab75f2"));
  mixin Interfaces!(_CodePropertyReferenceExpression, _Object);
}

abstract final class CodePropertySetValueReferenceExpression {
  mixin(uuid("395c1a4d-aabb-3415-b527-8cb694777b84"));
  mixin Interfaces!(_CodePropertySetValueReferenceExpression, _Object);
}

abstract final class CodeRegionDirective {
  mixin(uuid("932861ec-65c4-30f0-905d-905b9ce98979"));
  mixin Interfaces!(_CodeRegionDirective, _Object);
}

abstract final class CodeRemoveEventStatement {
  mixin(uuid("f38b3709-9b63-32e6-9cfb-07991c40717f"));
  mixin Interfaces!(_CodeRemoveEventStatement, _Object);
}

abstract final class CodeSnippetCompileUnit {
  mixin(uuid("af2df285-73d3-3623-aeab-1cdbcf75a9d0"));
  mixin Interfaces!(_CodeSnippetCompileUnit, _Object);
}

abstract final class CodeSnippetExpression {
  mixin(uuid("509af058-a0e5-32e6-ae00-15f8209d31f9"));
  mixin Interfaces!(_CodeSnippetExpression, _Object);
}

abstract final class CodeSnippetStatement {
  mixin(uuid("880287bc-d3a4-3113-b8d1-6538b7c19e97"));
  mixin Interfaces!(_CodeSnippetStatement, _Object);
}

abstract final class CodeSnippetTypeMember {
  mixin(uuid("0fac5dab-ad52-38bf-854e-fd3059369c44"));
  mixin Interfaces!(_CodeSnippetTypeMember, _Object);
}

abstract final class CodeThisReferenceExpression {
  mixin(uuid("21206362-562f-3f08-8f06-4bcfd2c95f29"));
  mixin Interfaces!(_CodeThisReferenceExpression, _Object);
}

abstract final class CodeThrowExceptionStatement {
  mixin(uuid("a2f81ded-8536-3c27-9759-ba3eac94d0a2"));
  mixin Interfaces!(_CodeThrowExceptionStatement, _Object);
}

abstract final class CodeTryCatchFinallyStatement {
  mixin(uuid("cb3bf2d6-db22-31df-a6f4-e3707972e10c"));
  mixin Interfaces!(_CodeTryCatchFinallyStatement, _Object);
}

abstract final class CodeTypeConstructor {
  mixin(uuid("7544623f-e6de-3918-9e10-29aaf16e560b"));
  mixin Interfaces!(_CodeTypeConstructor, _Object);
}

abstract final class CodeTypeDeclaration {
  mixin(uuid("2b708a48-52d8-3049-9565-6ba42ee2be17"));
  mixin Interfaces!(_CodeTypeDeclaration, _Object);
}

abstract final class CodeTypeMemberCollection {
  mixin(uuid("85d435c5-7af6-30e9-8a0b-c978737c2849"));
  mixin Interfaces!(_CodeTypeMemberCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class CodeTypeDelegate {
  mixin(uuid("6fbc1e34-565d-3721-b5c0-5c796540481f"));
  mixin Interfaces!(_CodeTypeDelegate, _Object);
}

abstract final class CodeTypeOfExpression {
  mixin(uuid("fb6a595a-b5dd-3361-8842-70e806d73573"));
  mixin Interfaces!(_CodeTypeOfExpression, _Object);
}

abstract final class CodeTypeParameter {
  mixin(uuid("e5e30108-7a5b-398f-b50c-09793c6299e1"));
  mixin Interfaces!(_CodeTypeParameter, _Object);
}

abstract final class CodeTypeReferenceExpression {
  mixin(uuid("8871c106-c8ba-37a0-ade2-e4aebec7e3c9"));
  mixin Interfaces!(_CodeTypeReferenceExpression, _Object);
}

abstract final class CodeVariableDeclarationStatement {
  mixin(uuid("943b4474-d661-344e-ad1b-1a1f3c8ea01a"));
  mixin Interfaces!(_CodeVariableDeclarationStatement, _Object);
}

abstract final class CodeVariableReferenceExpression {
  mixin(uuid("39abd141-93ae-397a-9e98-6f2e50124cec"));
  mixin Interfaces!(_CodeVariableReferenceExpression, _Object);
}

abstract final class component {
  mixin(uuid("b3b21824-d0f3-3815-847f-228660e2a20e"));
  mixin Interfaces!(_Component, _Object, IComponent, IDisposable);
}

abstract final class MarshalByValueComponent {
  mixin(uuid("f3fa95a9-c5f9-3ef9-80c6-91275015c770"));
  mixin Interfaces!(_MarshalByValueComponent, _Object, IComponent, IDisposable);
}

abstract final class DesignerVerbCollection {
  mixin(uuid("67114ed5-9f2a-3a0a-8c7a-746fda064488"));
  mixin Interfaces!(_DesignerVerbCollection, _Object, IList, ICollection, IEnumerable);
}

abstract final class PerformanceCounterManager {
  mixin(uuid("82840be1-d273-11d2-b94a-00600893b17a"));
  mixin Interfaces!(_PerformanceCounterManager, _Object);
}

abstract final class WebHeaderCollection {
  mixin(uuid("430d1273-c3e9-3632-9988-389c81849c00"));
  mixin Interfaces!(_WebHeaderCollection, _Object, ICollection, IEnumerable, ISerializable, IDeserializationCallback);
}

abstract final class WebClient {
  mixin(uuid("7d458845-b4b8-30cb-b2ad-fc4960fcdf81"));
  mixin Interfaces!(_WebClient, _Object, IComponent, IDisposable);
}
