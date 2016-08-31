// Active DS IIS Namespace Provider
// Version 1.0

/*[uuid("49d704a0-89f7-11d0-8527-00c04fd8d503")]*/
module os.win.tlb.iisole;

/*[importlib("stdole2.tlb")]*/
/*[importlib("activeds.tlb")]*/
private import os.win.com.core;

// Interfaces

interface IISMimeType : IDispatch {
  mixin(uuid("9036b027-a780-11d0-9b3d-0080c710ef95"));
  /*[id(0x00000004)]*/ int get_MimeType(out wchar* retval);
  /*[id(0x00000004)]*/ int put_MimeType(wchar* retval);
  /*[id(0x00000005)]*/ int get_Extension(out wchar* retval);
  /*[id(0x00000005)]*/ int put_Extension(wchar* retval);
}

interface IISIPSecurity : IDispatch {
  mixin(uuid("f3287521-bba3-11d0-9bdc-00a0c922e703"));
  /*[id(0x00000004)]*/ int get_IPDeny(out VARIANT retval);
  /*[id(0x00000004)]*/ int put_IPDeny(VARIANT retval);
  /*[id(0x00000005)]*/ int get_IPGrant(out VARIANT retval);
  /*[id(0x00000005)]*/ int put_IPGrant(VARIANT retval);
  /*[id(0x00000006)]*/ int get_DomainDeny(out VARIANT retval);
  /*[id(0x00000006)]*/ int put_DomainDeny(VARIANT retval);
  /*[id(0x00000007)]*/ int get_DomainGrant(out VARIANT retval);
  /*[id(0x00000007)]*/ int put_DomainGrant(VARIANT retval);
  /*[id(0x00000008)]*/ int get_GrantByDefault(out short retval);
  /*[id(0x00000008)]*/ int put_GrantByDefault(short retval);
}

interface IISBaseObject : IDispatch {
  mixin(uuid("4b42e390-0e96-11d1-9c3f-00a0c922e703"));
  /*[id(0x00000065)]*/ int GetDataPaths(wchar* bstrName, int lnAttribute, out VARIANT pvPaths);
  /*[id(0x00000066)]*/ int GetPropertyAttribObj(wchar* bstrName, out IDispatch ppObject);
}

interface IISSchemaObject : IDispatch {
  mixin(uuid("b6865a9c-3f64-11d2-a600-00a0c922e703"));
  /*[id(0x00000065)]*/ int GetSchemaPropertyAttributes(wchar* bstrName, out IDispatch ppObject);
  /*[id(0x00000066)]*/ int PutSchemaPropertyAttributes(IDispatch pObject);
}

interface IISPropertyAttribute : IDispatch {
  mixin(uuid("50e21930-a247-11d1-b79c-00a0c922e703"));
  /*[id(0x00000004)]*/ int get_PropName(out wchar* retval);
  /*[id(0x00000005)]*/ int get_MetaId(out int retval);
  /*[id(0x00000005)]*/ int put_MetaId(int retval);
  /*[id(0x00000006)]*/ int get_UserType(out int retval);
  /*[id(0x00000006)]*/ int put_UserType(int retval);
  /*[id(0x00000007)]*/ int get_AllAttributes(out int retval);
  /*[id(0x00000008)]*/ int get_Inherit(out short retval);
  /*[id(0x00000008)]*/ int put_Inherit(short retval);
  /*[id(0x00000009)]*/ int get_Secure(out short retval);
  /*[id(0x00000009)]*/ int put_Secure(short retval);
  /*[id(0x0000000A)]*/ int get_Reference(out short retval);
  /*[id(0x0000000A)]*/ int put_Reference(short retval);
  /*[id(0x0000000B)]*/ int get_Volatile(out short retval);
  /*[id(0x0000000B)]*/ int put_Volatile(short retval);
  /*[id(0x0000000C)]*/ int get_Isinherit(out short retval);
  /*[id(0x0000000D)]*/ int get_Default(out VARIANT retval);
  /*[id(0x0000000D)]*/ int put_Default(VARIANT retval);
}

// CoClasses

abstract final class MimeMap {
  mixin(uuid("9036b028-a780-11d0-9b3d-0080c710ef95"));
  mixin Interfaces!(IISMimeType, IDispatch);
}

abstract final class IPSecurity {
  mixin(uuid("f3287520-bba3-11d0-9bdc-00a0c922e703"));
  mixin Interfaces!(IISIPSecurity, IDispatch);
}

abstract final class IISNamespace {
  mixin(uuid("d6bfa35e-89f2-11d0-8527-00c04fd8d503"));
  mixin Interfaces!(IADsContainer, IADs, IDispatch);
}

abstract final class IISProvider {
  mixin(uuid("d88966de-89f2-11d0-8527-00c04fd8d503"));
  mixin Interfaces!(IDispatch, IUnknown);
}

abstract final class PropertyAttribute {
  mixin(uuid("fd2280a8-51a4-11d2-a601-3078302c2030"));
  mixin Interfaces!(IISPropertyAttribute, IDispatch);
}
