// Digital Mars DotNet Bridge for COM invoke
// Version 1.0

/*[uuid("96ebb029-0e6a-416e-a8bc-332b4ba8df71")]*/
module os.win.tlb.dmnetbridge;

/*[importlib("stdole2.tlb")]*/
import os.win.tlb.mscorlib;
private import os.win.com.core;

// Interfaces

interface _DotnetInvokeBridge : IDispatch {
  mixin(uuid("e94d19ee-fa60-344e-912c-a62f8d9b8fed"));
  /*[id(0x00000000)]*/ int get_ToString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT obj, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  
   // Метод: GetType(String* typeName);
        // 
        // Назначение: Assembly-savvy version of Type.GetType()
        //
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  //
        // Метод: CreateObject(String* assemName, String* objSpec, Object* args[])
        //
        // Назначение: Полностью указав название класса/типа, можно попытаться создать
        //          его экземпляр. Make sure the fresh instance
        //         isn't unboxed or otherwise transformed by fixing its PInvoke type
        //          to an interface pointer.
  /*[id(0x60020004)]*/ int CreateObject(wchar* assemName, wchar* objSpec, SAFEARRAY args, out IUnknown pRetVal);
  
   //
        // Метод:  InvokeMethod
        // 
        // Назначение: Given a pointer to an already created object, look up
        //          one of its method. If found, invoke the method passing it
        //          'args' as arguments.
        //
        // Comments: the format of the method-spec is "methodName(type1,..,typeN)" [N>=0]
        //
  /*[id(0x60020005)]*/ int InvokeMethod(VARIANT obj, wchar* methName, wchar* genericTypeArgs,  SAFEARRAY args, int arg_len, int* arg_tys, int res_ty, out VARIANT pRetVal);
  /*[id(0x60020006)]*/ int InvokeMethodBoxed(VARIANT obj, wchar* methName, wchar* genericTypeArgs,  SAFEARRAY args, int arg_len, int* arg_tys, int res_ty, out IUnknown pRetVal);
  
  //
        // Метод:  InvokeStaticMethod
        // 
        // Назначение: Invoke a static method, given the fully qualified name
        //          of the method (and its arguments). If found, invoke the
        //          method passing it 'args' as arguments.
        //
        // Comments: the format of the method-spec is 
        //              "T1.T2.<..>.Tn.methodName(type1,..,typeN)" [N>=0]
        //
  /*[id(0x60020007)]*/ int InvokeStaticMethod(wchar* assemName, wchar* typeAndMethName, wchar* genericTypeArgs,  SAFEARRAY args, int arg_len, int* arg_tys, int res_ty, out VARIANT pRetVal);
  /*[id(0x60020008)]*/ int InvokeStaticMethodBoxed(wchar* assemName, wchar* typeAndMethName, wchar* genericTypeArgs,  SAFEARRAY args, int arg_len, int* arg_tys, int res_ty, out IUnknown pRetVal);
  
  //
        // Метод:  GetField
        //
        // Назначение: Fetch the (boxed) value of named field of a given object.
        //
  /*[id(0x60020009)]*/ int GetField(VARIANT obj,  SAFEARRAY args, wchar* fieldName, int arg_len, int* arg_tys, int res_ty, out VARIANT pRetVal);
  /*[id(0x6002000A)]*/ int GetFieldBoxed(VARIANT obj,  SAFEARRAY args, wchar* fieldName, int arg_len, int* arg_tys, int res_ty, out IUnknown pRetVal);
  
  //
        // Метод:  GetStaticField
        //
        // Назначение: Fetch the (boxed) value of named static field.
        //
  /*[id(0x6002000B)]*/ int GetStaticField(wchar* clsName, wchar* fieldName, out VARIANT pRetVal);
  /*[id(0x6002000C)]*/ int GetStaticFieldBoxed(wchar* clsName, wchar* fieldName, out IUnknown pRetVal);
  
  //
        // Метод:  SetField
        //
        // Назначение: Replace the (boxed) value of named field of a given object.
        //
  /*[id(0x6002000D)]*/ int SetField(VARIANT obj, wchar* fieldName, VARIANT val);
  
  //
        // Метод:  SetStaticField
        //
        // Назначение: Replace the (boxed) value of named field of a given object.
        //
  /*[id(0x6002000E)]*/ int SetStaticField(wchar* clsName, wchar* fieldName, VARIANT val);
  
   // 
        // Метод:  NewString
        // 
        // Назначение: construct a System.String object copy in a manner that avoids
        //          COM Interop from deconstructing it to a BSTR.
        //
  /*[id(0x6002000F)]*/ int NewString(wchar* s, out IUnknown pRetVal);
  
   //
        // Метод:  NewVector
        //
        // Назначение: create a new vector of value types.
        //
  /*[id(0x60020010)]*/ int NewVector(int ty, int sz, out _Array pRetVal);
  
  //
        // Метод:  NewArgArray
        //
        // Назначение: create a new array for holding (boxed) arguments to constructors/
        //          methods.
        //
  /*[id(0x60020011)]*/ int NewArgArray(int sz, out _Array pRetVal);
  
   //
        // Метод: SetArg
        //
        // Назначение: set an entry in the argument vector.
        //
  /*[id(0x60020012)]*/ int SetArg( SAFEARRAY arr, VARIANT val, int idx);
  
  //
        // Метод: GetArg
        //
        // Назначение: get an entry in the argument vector.
        //
  /*[id(0x60020013)]*/ int GetArg( SAFEARRAY arr, int idx, out VARIANT pRetVal);
  /*[id(0x60020014)]*/ int GetType_2(wchar* typeName, out _Type pRetVal);
  /*[id(0x60020015)]*/ int DefineDelegator(wchar* tyStr, int funPtr, out VARIANT pRetVal);
  /*[id(0x60020016)]*/ int SetDumpExceptionsFlag(short flg);
}

// CoClasses

abstract final class DotnetInvokeBridge {
  mixin(uuid("39d497d9-60e0-3525-b7f2-7bc096d3a2a3"));
  mixin Interfaces!(_DotnetInvokeBridge, _Object);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
