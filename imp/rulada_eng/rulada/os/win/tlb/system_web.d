// Version 2.0

/*[uuid("2295cfb6-8b0c-307c-a610-96360b10f9b9")]*/
module os.win.tlb.system_web;

/*[importlib("STDOLE2.TLB")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Interfaces

interface IRemoteWebConfigurationHostServer : IDispatch {
  mixin(uuid("a99b591a-23c6-4238-8452-c7b0e895063d"));
  /*[id(0x60020000)]*/ int GetData(wchar* fileName, short getReadTimeOnly, out long readTime, out  pRetVal);
  /*[id(0x60020001)]*/ int WriteData(wchar* fileName, wchar* templateFileName,  data, ref long readTime);
  /*[id(0x60020002)]*/ int GetFilePaths(int webLevel, wchar* path, wchar* site, wchar* locationSubPath, out wchar* pRetVal);
  /*[id(0x60020003)]*/ int DoEncryptOrDecrypt(short doEncrypt, wchar* xmlString, wchar* protectionProviderName, wchar* protectionProviderType,  parameterKeys,  parameterValues, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int GetFileDetails(wchar* name, out short exists, out long size, out long createDate, out long lastWriteDate);
}

interface _RemoteWebConfigurationHostServer : IDispatch {
  mixin(uuid("98347f39-50ec-3894-ac43-e1948377fd43"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT obj, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int GetData(wchar* fileName, short getReadTimeOnly, out long readTime, out  pRetVal);
  /*[id(0x60020005)]*/ int WriteData(wchar* fileName, wchar* templateFileName,  data, ref long readTime);
  /*[id(0x60020006)]*/ int GetFilePaths(int webLevelAsInt, wchar* path, wchar* site, wchar* locationSubPath, out wchar* pRetVal);
  /*[id(0x60020007)]*/ int DoEncryptOrDecrypt(short doEncrypt, wchar* xmlString, wchar* protectionProviderName, wchar* protectionProviderType,  paramKeys,  paramValues, out wchar* pRetVal);
  /*[id(0x60020008)]*/ int GetFileDetails(wchar* name, out short exists, out long size, out long createDate, out long lastWriteDate);
}

// CoClasses

abstract final class RemoteWebConfigurationHostServer {
  mixin(uuid("8dec0fa2-cc19-494f-8613-1f6221c0c5ab"));
  mixin Interfaces!(_RemoteWebConfigurationHostServer, _Object, IRemoteWebConfigurationHostServer);
}
