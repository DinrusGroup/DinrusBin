// CodeGear RAD Studio CPP Structure Parser
// Version 12.0

/*[uuid("8442267a-36c6-4623-b7e8-dc8fbd99b9fa")]*/
module borland_studio_cpp_structure;

/*[importlib("stdole2.tlb")]*/
/*[importlib("vjslib.tlb")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Interfaces

interface IBaseDecl : IDispatch {
  mixin(uuid("0638cd10-fb65-4d89-a568-58c9b22836bb"));
  /*[id(0x60020000)]*/ int getName(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int getDisplayName(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int getFullScopeName(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int getScope(out IScope pRetVal);
  /*[id(0x60020004)]*/ int getFlags(out int pRetVal);
  /*[id(0x60020005)]*/ int getFile(out ICPPFile pRetVal);
  /*[id(0x60020006)]*/ int setFlags(int flags);
  /*[id(0x60020007)]*/ int setEnd(IUnknown end);
  /*[id(0x60020008)]*/ int hasFlag(int flag, out short pRetVal);
  /*[id(0x60020009)]*/ int getStartLine(out int pRetVal);
  /*[id(0x6002000A)]*/ int getStartCol(out int pRetVal);
  /*[id(0x6002000B)]*/ int getEndLine(out int pRetVal);
  /*[id(0x6002000C)]*/ int getEndCol(out int pRetVal);
  /*[id(0x6002000D)]*/ int getStartPos(out int pRetVal);
  /*[id(0x6002000E)]*/ int getEndPos(out int pRetVal);
  /*[id(0x6002000F)]*/ int setPositions(int startPos, int endPos);
  /*[id(0x60020010)]*/ int getPos(out wchar* pRetVal);
  /*[id(0x60020011)]*/ int getFlagStrings(out wchar* pRetVal);
  /*[id(0x60020012)]*/ int getData(int index, out wchar* pRetVal);
  /*[id(0x60020013)]*/ int getDeclId(int index, out int pRetVal);
}

interface IBlockManager : IDispatch {
  mixin(uuid("18a0589b-8f5c-4087-a5de-099172dadc9d"));
  /*[id(0x60020000)]*/ int getLastBlockCol(out int pRetVal);
  /*[id(0x60020001)]*/ int getLastBlockLine(out int pRetVal);
  /*[id(0x60020002)]*/ int setCursor(int line, int col);
  /*[id(0x60020003)]*/ int isIncomplete(out short pRetVal);
  /*[id(0x60020004)]*/ int isSemiColonNeeded(out short pRetVal);
}

interface ICPPBlockParser : IDispatch {
  mixin(uuid("dd2f1f8d-b570-475a-a66a-879f02e2be40"));
  /*[id(0x60020000)]*/ int getBlockManager(out IBlockManager pRetVal);
}

interface ICPPBlockParserFactory : IDispatch {
  mixin(uuid("da9ca576-9d81-46c2-a747-864d7439a538"));
  /*[id(0x60020000)]*/ int getCPPBlockParser(wchar* fileName, out ICPPBlockParser pRetVal);
}

interface ICPPFile : IDispatch {
  mixin(uuid("755a8c12-66f6-4cbf-bf94-bc705abff910"));
  /*[id(0x60020000)]*/ int getPath(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int getFile(out _File pRetVal);
}

interface ICPPStructureParser : IDispatch {
  mixin(uuid("652c84a8-3baf-4c7d-9754-4556ca60f058"));
  /*[id(0x60020000)]*/ int getParserFlags(out int pRetVal);
  /*[id(0x60020001)]*/ int setParserFlags(int flags);
  /*[id(0x60020002)]*/ int parsePreInclude(out int pRetVal);
  /*[id(0x60020003)]*/ int parse();
  /*[id(0x60020004)]*/ int getSymbolManager(out ISymbolManager pRetVal);
}

interface ICPPStructureParserFactory : IDispatch {
  mixin(uuid("d32ee57b-e643-4a86-9a16-6199e14e38cc"));
  /*[id(0x60020000)]*/ int getCPPStructureParser(wchar* fileName, out ICPPStructureParser pRetVal);
}

interface IDefaultFactory : IDispatch {
  mixin(uuid("824a1420-8bb6-4f48-9d76-81b128314140"));
  /*[id(0x60020000)]*/ int getDefaultParserSettings(out IDefaultSettings pRetVal);
  /*[id(0x60020001)]*/ int getCPPStructureParser(wchar* fileName, out ICPPStructureParser pRetVal);
  /*[id(0x60020002)]*/ int getCPPStructureParserForString(wchar* content, out ICPPStructureParser pRetVal);
}

interface IDefaultSettings : IDispatch {
  mixin(uuid("18ddc4f2-7077-4e47-ae44-2f193565e83a"));
  /*[id(0x60020000)]*/ int getPreIncludeContent(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int setPreIncludeContent(wchar* content);
  /*[id(0x60020002)]*/ int isDebugRun(out short pRetVal);
  /*[id(0x60020003)]*/ int setDebugRun(short flag);
  /*[id(0x60020004)]*/ int getDebugFlags(out int pRetVal);
  /*[id(0x60020005)]*/ int setDebugFlags(int flags);
}

interface IFunctionDecl : IDispatch {
  mixin(uuid("a8ab2b65-af83-4d36-928e-b0596de4bf64"));
  /*[id(0x60020000)]*/ int getSignature(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int getReturnType(out wchar* pRetVal);
}

interface IMemberDecl : IDispatch {
  mixin(uuid("a400591c-5af9-43ab-9a31-5d2381a2d6fd"));
  /*[id(0x60020000)]*/ int getType(out ITypeDecl pRetVal);
  /*[id(0x60020001)]*/ int getDefOrDecl(out IBaseDecl pRetVal);
  /*[id(0x60020002)]*/ int getTypeAsString(out wchar* pRetVal);
}

interface IScope : IDispatch {
  mixin(uuid("01d92abb-c68b-45aa-965b-bad139e29909"));
  /*[id(0x60020000)]*/ int getScopeType(out int pRetVal);
  /*[id(0x60020001)]*/ int isClassScope(out short pRetVal);
  /*[id(0x60020002)]*/ int isGlobalScope(out short pRetVal);
  /*[id(0x60020003)]*/ int putTypeName(wchar* name, ITypeDecl decl);
  /*[id(0x60020004)]*/ int isTypeNameInThisScope(wchar* name, out short pRetVal);
  /*[id(0x60020005)]*/ int putMemberName(wchar* name, IMemberDecl decl);
  /*[id(0x60020006)]*/ int isMemberNameInThisScope(wchar* name, out short pRetVal);
  /*[id(0x60020007)]*/ int getMemberNamed(wchar* name, out IMemberDecl pRetVal);
  /*[id(0x60020008)]*/ int getInnerScopeNamed(wchar* name, int scopeType, out IScope pRetVal);
  /*[id(0x60020009)]*/ int updateName(wchar* name);
  /*[id(0x6002000A)]*/ int getParentScope(out IScope pRetVal);
  /*[id(0x6002000B)]*/ int addDeclaration(IBaseDecl decl);
  /*[id(0x6002000C)]*/ int getDeclarationCount(out int pRetVal);
  /*[id(0x6002000D)]*/ int getDeclaration(int index, out IBaseDecl pRetVal);
  /*[id(0x6002000E)]*/ int getDeclarationCount_2(int kind, out int pRetVal);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020010)]*/ int getAccessFlags(out int pRetVal);
}

interface ISymbolManager : IDispatch {
  mixin(uuid("af72b65f-b549-4570-a9d9-517b7eb874ea"));
  /*[id(0x60020000)]*/ int IsFullyScopedTypeName(wchar* name, out short pRetVal);
  /*[id(0x60020001)]*/ int closeScope();
  /*[id(0x60020002)]*/ int findScopeOfName(wchar* name, out IScope pRetVal);
  /*[id(0x60020003)]*/ int getCurScope(out IScope pRetVal);
  /*[id(0x60020004)]*/ int getGlobalScope(out IScope pRetVal);
  /*[id(0x60020005)]*/ int getScope(wchar* name, out IScope pRetVal);
  /*[id(0x60020006)]*/ int getScopeOfFullyScopedName(wchar* name, out IScope pRetVal);
  /*[id(0x60020007)]*/ int getTODOScope(out IScope pRetVal);
  /*[id(0x60020008)]*/ int isCtor(wchar* name, out short pRetVal);
  /*[id(0x60020009)]*/ int isGlobalScope(out short pRetVal);
  /*[id(0x6002000A)]*/ int isTypeName(wchar* name, out short pRetVal);
  /*[id(0x6002000B)]*/ int openBlockScope(IScope parent, wchar* name, IUnknown start, int flags, ICPPFile file, out IScope pRetVal);
  /*[id(0x6002000C)]*/ int openClassScope(IScope parent, wchar* name, IUnknown start, int flags, ICPPFile file, out IScope pRetVal);
  /*[id(0x6002000D)]*/ int openNamespaceScope(IScope parent, wchar* name, IUnknown start, ICPPFile file, out IScope pRetVal);
  /*[id(0x6002000E)]*/ int putTypeName(wchar* name, ITypeDecl decl);
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
}

interface ITypeDecl : IDispatch {
  mixin(uuid("82f40c2e-a354-4bf7-a345-447e9aab1a7a"));
}

interface ICPPMethodNavigate : IDispatch {
  mixin(uuid("f1d0a90b-c0dc-4a9b-9c63-cfe504edcef2"));
  /*[id(0x60020000)]*/ int Navigate(IOTAEditView editView, wchar* fileName, int navType, short classLock, out short pRetVal);
}

interface ICPPMethodNavigateFactory : IDispatch {
  mixin(uuid("e8d5a13d-076a-4a7e-b89c-f74299e3e001"));
  /*[id(0x60020000)]*/ int getCPPMethodNavigate(out ICPPMethodNavigate pRetVal);
}

// CoClasses

abstract final class CPPFile {
  mixin(uuid("c1b0d08a-6cbc-400f-bcd6-a34a7431c79d"));
  mixin Interfaces!(_Object, ICPPFile);
}

abstract final class DefaultFactory {
  mixin(uuid("3f3b441c-8c96-453f-aeb4-25cfed615ccb"));
  mixin Interfaces!(_Object, IDefaultFactory);
}

abstract final class SymbolManager {
  mixin(uuid("c0534899-ea50-45c6-a6cc-b93c241672bc"));
  mixin Interfaces!(_Object, ISymbolManager);
}

abstract final class CPPBlockParserFactory {
  mixin(uuid("43e4aa33-f1f0-4f60-9452-02583aa0075b"));
  mixin Interfaces!(_Object, ICPPBlockParserFactory);
}

abstract final class CPPMethodNavigateFactory {
  mixin(uuid("9ed0ddfe-da89-4981-9824-96465e49c5a1"));
  mixin Interfaces!(_Object, ICPPMethodNavigateFactory);
}

abstract final class CPPStructureParserFactory {
  mixin(uuid("7a1274ee-5e21-4224-9d3f-b0b14797f83c"));
  mixin Interfaces!(_Object, IDefaultFactory, ICPPStructureParserFactory);
}
