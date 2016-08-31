﻿/**
 * Обеспечивает поддержку COM (Component Object Model).
 *
 * See $(LINK2 http://msdn.microsoft.com/en-us/library/ms690233(VS.85).aspx, MSDN) for a glossary of terms.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.com.core;

public import os.win.base.core: NotImplementedException, InvalidCastException, NullReferenceException, UnauthorizedAccessException, ArgumentException, ArgumentNullException, FormatException, InvalidOperationException;

import os.win.base.native: FACILITY_ITF, MAKE_SCODE,COAUTHINFO, SEVERITY_ERROR, SEVERITY_SUCCESS, FILETIME, Handle, FORMAT_MESSAGE_FROM_SYSTEM, FORMAT_MESSAGE_IGNORE_INSERTS, FormatMessage, SECURITY_DESCRIPTOR, POINT, RECT, GetThreadLocale, toUTF8, toUTF16z, FormatMessageW, InterlockedIncrement, InterlockedDecrement, HeapAlloc, GetProcessHeap, HeapFree,MAX_PATH, GetModuleFileName;

import
  std.string, std.gc,
  std.stream, 
  std.typetuple,
  std.traits,
  std.stdarg;
  import std.exception;
  //static import std.exception;

static import std.c;
debug import std.io : writefln;

//pragma(lib, "ole32.lib");
//pragma(lib, "oleaut32.lib");
pragma(lib, "rulada.lib");

static this() {
  startup();
}

static ~this() {
  shutdown();
}

enum /* HRESULT */ {
  S_OK            = 0x0,
  S_FALSE         = 0x1,

  E_NOTIMPL       = 0x80004001,
  E_NOINTERFACE   = 0x80004002,
  E_POINTER       = 0x80004003,
  E_ABORT         = 0x80004004,
  E_FAIL          = 0x80004005,

  E_ACCESSDENIED  = 0x80070005,
  E_OUTOFMEMORY   = 0x8007000E,
  E_INVALIDARG    = 0x80070057,
  
  У_ОК				= S_OK,
  У_ЛОЖЬ			= S_FALSE,
  
  О_НЕРЕАЛИЗ		= E_NOTIMPL,
  О_НЕИНТЕРФЕЙС		= E_NOINTERFACE,
  О_УКАЗАТЕЛЬ		= E_POINTER,
  О_АБОРТ			= E_ABORT,
  О_НЕУДАЧА			= E_FAIL,
  О_НЕТДОСТУПА		= E_ACCESSDENIED,
  О_ВНЕПАМЯТИ		= E_OUTOFMEMORY,
  О_НЕВЕРНАРГ		= E_INVALIDARG,
}

/**
 * Определяет, прошла ли операция успешно.
 */
bool SUCCEEDED(int hr) {
  return hr >= 0;
}

бул УДАЧНО(цел статус) { return статус >= 0; }

/**
 * Определяет, была ли операция неудачной.
 */
bool FAILED(int hr) {
  return hr < 0;
}

бул НЕУДАЧНО(цел статус) { return статус < 0; }

/**
 * The exception thrown when an unrecognized HRESULT is returned from a COM operation.
 */
 alias COMException КОМИскл;
class COMException : Exception {

  int errorCode_;

  /**
   * Initializes a new instance with a specified error code.
   * Параметры: errorCode = The error code (HRESULT) value associated with this exception.
   */
  this(int errorCode) {
    super(getErrorMessage(errorCode));
    errorCode_ = errorCode;
  }

  /**
   * Initializes a new instance with a specified message and error code.
   * Параметры:
   *   message = The error _message that explains this exception.
   *   errorCode = The error code (HRESULT) value associated with this exception.
   */
  this(string message, int errorCode) {
    super(message);
    errorCode_ = errorCode;
  }

  /**
   * Gets the HRESULT of the error.
   * Возвращает: The HRESULT of the error.
   */
  int errorCode() {
    return errorCode_;
  }

  private static string getErrorMessage(int errorCode) {
    wchar[256] buffer;
    uint result = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, errorCode, 0, buffer.ptr, buffer.length + 1, null);
    if (result != 0) {
      string s = .toUTF8(buffer[0 .. result]);

      // Remove trailing characters
      while (result > 0) {
        char c = s[result - 1];
        if (c > ' ' && c != '.')
          break;
        result--;
      }

      return std.string.format("%s. (Exception from HRESULT: 0x%08X)", s[0 .. result], cast(uint)errorCode);
    }

    return std.string.format("Unspecified error (0x%08X)", cast(uint)errorCode);
  }

}

/// Converts an HRESULT error code to a corresponding Exception object.
Exception exceptionForHR(int errorCode) {
  switch (errorCode) {
    case E_NOTIMPL:
      return new NotImplementedException;
    case E_NOINTERFACE:
      return new InvalidCastException;
    case E_POINTER:
      return new NullReferenceException;
    case E_ACCESSDENIED:
      return new UnauthorizedAccessException;
    case E_OUTOFMEMORY:
      return new OutOfMemoryException;
	  case E_INVALIDARG:
      return new ArgumentException;
    default:
  }
  return new COMException(errorCode);
}

/// Throwns an exception with a specific failure HRESULT value.
void throwExceptionForHR(int errorCode)
in {
  assert(FAILED(errorCode));
}
body {
  if (FAILED(errorCode))
    throw exceptionForHR(errorCode);
}

/**
 * Представляет глобальный уникальный идентификатор.
 */
alias GUID ГУИД;
struct GUID {

  // Slightly different layout from the Windows SDK, but means we can use fewer brackets
  // when defining GUIDs.
  uint a;
  ushort b, c;
  ubyte d, e, f, g, h, i, j, k;

  /**
   * GUID, все значения которого являются нулями.
   */
  static GUID empty = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };

  /**
   * Инициализует _новый экземпляр, используя заданные целые и байты.
   * Параметры:
   *   a = Первые 4 байта.
   *   b = Следующие 2 байта.
   *   c = Следующие 2 байта.
   *   d = Следующий байт.
   *   e = Следующий байт.
   *   f = Следующий байт.
   *   g = Следующий байт.
   *   h = Следующий байт.
   *   i = Следующий байт.
   *   j = Следующий байт.
   *   k = Следующий байт.
   * Возвращает: Результирующий GUID.
   */
  static GUID opCall(uint a, ushort b, ushort c, ubyte d, ubyte e, ubyte f, ubyte g, ubyte h, ubyte i, ubyte j, ubyte k) {
    GUID self;
    self.a = a, self.b = b, self.c = c, self.d = d, self.e = e, self.f = f, self.g = g, self.h = h, self.i = i, self.j = j, self.k = k;
    return self;
  }

  /**
   * Initializes _a new instance using the specified integers and byte array.
   * Параметры:
   *   a = Первые 4 байта.
   *   b = Следующие 2 байта.
   *   c = Следующие 2 байта.
   *   d = The remaining 8 bytes.
   * Возвращает: The resulting GUID.
   * Выводит исключение: IllegalArgumentException if d is not 8 bytes long.
   */
  static GUID opCall(uint a, ushort b, ushort c, ubyte[] d) {
    if (d.length != 8)
      throw new ArgumentException("Byte array for GUID must be 8 bytes long.");

    GUID self;
    self.a = a, self.b = b, self.c = c, self.d = d[0], self.e = d[1], self.f = d[2], self.g = d[3], self.h = d[4], self.i = d[5], self.j = d[6], self.k = d[7];
    return self;
  }

  /**
   * Initializes a new instance using the value represented by the specified string.
   * Параметры: s = A string containing a GUID in groups of 8, 4, 4, 4 and 12 digits with hyphens between the groups. The GUID can optionally be enclosed in braces.
   * Возвращает: The resulting GUID.
   */
  static GUID opCall(string s) {
    
    ulong parse(string s) {

      bool hexToInt(char c, out uint result) {
        if (c >= '0' && c <= '9') result = c - '0';
        else if (c >= 'A' && c <= 'F') result = c - 'A' + 10;
        else if (c >= 'a' && c <= 'f') result = c - 'a' + 10;
        else result = -1;
        return (cast(int)result >= 0);
      }

      ulong result;
      uint value, index;
      while (index < s.length && hexToInt(s[index], value)) {
        result = result * 16 + value;
        index++;
      }
      return result;
    }

    s = s.strip();

    if (s[0] == '{') {
      s = s[1 .. $];
      if (s[$ - 1] == '}')
        s = s[0 .. $ - 1];
    }

    if (s[0] == '[') {
      s = s[1 .. $];
      if (s[$ - 1] == ']')
        s = s[0 .. $ - 1];
    }

    if (s.find('-') == -1)
      throw new FormatException("Unrecognised GUID format.");

    GUID self;
    self.a = cast(uint)parse(s[0 .. 8]);
    self.b = cast(ushort)parse(s[9 .. 13]);
    self.c = cast(ushort)parse(s[14 .. 18]);
    uint m = cast(uint)parse(s[19 .. 23]);
    self.d = cast(ubyte)(m >> 8);
    self.e = cast(ubyte)m;
    ulong n = parse(s[24 .. $]);
    m = cast(uint)(n >> 32);
    self.f = cast(ubyte)(m >> 8);
    self.g = cast(ubyte)m;
    m = cast(uint)n;
    self.h = cast(ubyte)(m >> 24);
    self.i = cast(ubyte)(m >> 16);
    self.j = cast(ubyte)(m >> 8);
    self.k = cast(ubyte)m;
    return self;
  }

  /**
   * Initializes a new instance of the GUID struct.
   */
  static GUID create() {
    GUID self;

    int hr = CoCreateGuid(self);
    if (FAILED(hr))
      throw exceptionForHR(hr);

    return self;
  }

  static ГУИД создай(){ return cast(ГУИД) create(); }
  /**
   * Returns a value indicating whether two instances represent the same value.
   * Параметры: other = A GUID to compare to this instance.
   * Возвращает: true if other is equal to this instance; otherwise, false.
   */
  bool opEquals(GUID other) {
    return a == other.a
      && b == other.b
      && c == other.c
      && d == other.d
      && e == other.e
      && f == other.f
      && g == other.g
      && h == other.h
      && i == other.i
      && j == other.j
      && k == other.k;
  }

  /**
   * Compares this instance to a specified GUID and returns an indication of their relative values.
   * Параметры: other = A GUID to compare to this instance.
   * Возвращает: A number indicating the relative values of this instance and other.
   */
  int opCmp(GUID other) {
    if (a != other.a)
      return (a < other.a) ? -1 : 1;
    if (b != other.b)
      return (b < other.b) ? -1 : 1;
    if (c != other.c)
      return (c < other.c) ? -1 : 1;
    if (d != other.d)
      return (d < other.d) ? -1 : 1;
    if (e != other.e)
      return (e < other.e) ? -1 : 1;
    if (f != other.f)
      return (f < other.f) ? -1 : 1;
    if (g != other.g)
      return (g < other.g) ? -1 : 1;
    if (h != other.h)
      return (h < other.h) ? -1 : 1;
    if (i != other.i)
      return (i < other.i) ? -1 : 1;
    if (j != other.j)
      return (j < other.j) ? -1 : 1;
    if (k != other.k)
      return (k < other.k) ? -1 : 1;
    return 0;
  }

  /**
   * Returns a string representation of the value of this instance in registry format.
   * Возвращает: A string formatted in this pattern: {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx} where the GUID is represented as a series of lowercase hexadecimal digits in groups of 8, 4, 4, 4 and 12 and separated by hyphens.
   */
   alias toString вТкст;
   
  string toString() {
    return toString("D");
  }

  /// ditto
  string toString(string format) {

    void hexToString(ref char[] s, ref uint index, uint a, uint b) {

      char hexToChar(uint a) {
        a = a & 0x0F;
        return cast(char)((a > 9) ? a - 10 + 0x61 : a + 0x30);
      }

      s[index++] = hexToChar(a >> 4);
      s[index++] = hexToChar(a);
      s[index++] = hexToChar(b >> 4);
      s[index++] = hexToChar(b);
    }

    if (format == null)
      format = "D";

    char[] s;
    uint index = 0;
    if (format == "D" || format == "d")
      s = new char[36];
    else if (format == "P" || format == "p") {
      s = new char[38];
      s[index++] = '{';
      s[$ - 1] = '}';
    }

    hexToString(s, index, a >> 24, a >> 16);
    hexToString(s, index, a >> 8, a);
    s[index++] = '-';
    hexToString(s, index, b >> 8, b);
    s[index++] = '-';
    hexToString(s, index, c >> 8, c);
    s[index++] = '-';
    hexToString(s, index, d, e);
    s[index++] = '-';
    hexToString(s, index, f, g);
    hexToString(s, index, h, i);
    hexToString(s, index, j, k);

    return cast(string)s;
  }

  /**
   * Выводит хеш-код для данного экземпляра.
   * Возвращает: The hash code for this instance.
   */
  uint toHash() {
    return a ^ ((b >> 16) | c) ^ ((f << 24) | k);
  }
  
	бцел вХэш(){return cast(бцел) toHash();}

}



alias GUID Guid;
alias Guid Гуид;

/**
 * Выводит ProgID для данного идентификатора класса (CLSID).
 */
string progIdFromClsid(Guid clsid) {
  wchar* str;
  ProgIDFromCLSID(clsid, str);
  return toUTF8(str[0 .. std.c.wcslen(str)]);
}

ткст прогИдИзКлсид(Гуид клсид){return cast(ткст) progIdFromClsid(cast(Guid) клсид);}

/**
 * Retrieves the class identifier (CLSID) for a given ProgID.
 */
Guid clsidFromProgId(string progId) {
  Guid clsid;
  CLSIDFromProgID(progId.toUTF16z(), clsid);
  return clsid;
}

Гуид клсидИзПрогИд(ткст прогИд){return cast(Гуид) clsidFromProgId(cast(ткст) прогИд);}

extern(Windows)
int CoCreateGuid(out GUID pGuid);

цел СоздайГуидКо(out ГУИД уГуид){return cast(цел) CoCreateGuid(cast(GUID) уГуид);}

/**
 * Ассоциирует ГУИД с интерфейсом.
 * Параметры: g = Строка, представляющая ГУИД в нормальном реестровом формате с или без разграничителей { }.
 * Примеры:
 * ---
 * interface IXMLDOMDocument2 : IDispatch {
 *   mixin(uuid("2933bf95-7b36-11d2-b20e-00c04f983e60"));
 * }
 *
 * // Раскрывается в следующий код:
 * //
 * // interface IXMLDOMDocument2 : IDispatch {
 * //   static GUID IID = { 0x2933bf95, 0x7b36, 0x11d2, 0xb2, 0x0e, 0x00, 0xc0, 0x4f, 0x98, 0x3e, 0x60 };
 * // }
 * ---
 */
string uuid(string g) {
  if (g.length == 38) {
    assert(g[0] == '{' && g[$-1] == '}', "Incorrect format for GUID.");
    return uuid(g[1..$-1]);
  }
  else if (g.length == 36) {
    assert(g[8] == '-' && g[13] == '-' && g[18] == '-' && g[23] == '-', "Incorrect format for GUID.");
    return "static const GUID IID = { 0x" ~ g[0..8] ~ ",0x" ~ g[9..13] ~ ",0x" ~ g[14..18] ~ ",0x" ~ g[19..21] ~ ",0x" ~ g[21..23] ~ ",0x" ~ g[24..26] ~ ",0x" ~ g[26..28] ~ ",0x" ~ g[28..30] ~ ",0x" ~ g[30..32] ~ ",0x" ~ g[32..34] ~ ",0x" ~ g[34..36] ~ " };";
  }
  else assert(false, "Incorrect format for GUID.");
}

ткст ууид(ткст г){return cast(ткст) uuid(cast(string) г);}

/**
 * Извлекает ГУИД, связанный с указанной переменной или типом.
 * Примеры:
 * ---
 * import os.win.com.core, 
 *   std.io;
 *
 * void main() {
 *   writefln("ГУИДом IXMLDOMDocument2 является %s", uuidof!(IXMLDOMDocument2));
 * }
 *
 * // Производит:
 * // ГУИДом IXMLDOMDocument2 является {2933bf95-7b36-11d2-b20e-00c04f983e60}
 * ---
 */
 alias uuidof ууид_у;
 
template uuidof(alias T) {
  static if (is(typeof(T)))
    const GUID uuidof = uuidofT!(typeof(T));
  else
    const GUID uuidof = uuidofT!(T);
}

/* Conflicts with the definition above.
template uuidof(T) {
  const GUID uuidof = uuidofT!(T);
}*/
alias uuidofT ууид_у_Т;

template uuidofT(T : T) {
  static if (is(typeof(mixin("IID_" ~ T.stringof))))
    const GUID uuidofT = mixin("IID_" ~ T.stringof); // e.g., IID_IShellFolder
  else static if (is(typeof(mixin("CLSID_" ~ T.stringof))))
    const GUID uuidofT = mixin("CLSID_" ~ T.stringof); // e.g., CLSID_Shell
  else static if (is(typeof(T.IID)))
    const GUID uuidofT = T.IID;
  else
    static assert(false, "No GUID has been associated with '" ~ T.stringof ~ "'.");
}

alias retval возврзнач;

void** retval(T)(out T ppv)
in {
  assert(&ppv != null);
}
body {
  return cast(void**)&ppv;
}
//Флаги, используемые БЕЗОПМАСом (features)
enum : ushort {
  FADF_AUTO = 0x1,
  FADF_STATIC = 0x2,
  FADF_EMBEDDED = 0x4,
  FADF_FIXEDSIZE = 0x10,
  FADF_RECORD = 0x20,
  FADF_HAVEIID = 0x40,
  FADF_HAVEVARTYPE = 0x80,
  FADF_BSTR = 0x100,
  FADF_UNKNOWN = 0x200,
  FADF_DISPATCH = 0x400,
  FADF_VARIANT = 0x800,
  FADF_RESERVED = 0xF008
}

alias SAFEARRAYBOUND ГРАНБЕЗОПМАСА;
struct SAFEARRAYBOUND {

alias cElements члоЭлтов;
alias lLbound нижГраница;

  uint cElements;
  int lLbound;
}

/// Представляет массив элементов.
alias SAFEARRAY БЕЗОПМАС;
struct SAFEARRAY {

alias cDims члоИзм;
alias fFeatures фичи;
alias cbElements размЭлта;
alias cLocks счБлк;
alias pvData укНаДан;
alias rgsabound рбмгран;

  ushort cDims;
  ushort fFeatures;
  /*
  The fFeatures flags describe attributes of an array that can affect how the array is released. The fFeatures field describes what type of data is stored in the SAFEARRAY and how the array is allocated. This allows freeing the array without referencing its containing variant. The bits are accessed using the following constants: see line 713
  */
  uint cbElements;
  uint cLocks;
  void* pvData;
  SAFEARRAYBOUND[1] rgsabound;
  /*
  The array rgsabound is stored with the left-most dimension in rgsabound[0] and the right-most dimension in rgsabound[cDims - 1]. If an array was specified in a C-like syntax as a [2][5], it would have two elements in the rgsabound vector. Element 0 has an lLbound of 0 and a cElements of 2. Element 1 has an lLbound of 0 and a cElements of 5.
  */

  /**
   * Инициализует новый экземпляр, используя заданный массив _array.
   * Параметры: array = Элементы, которыми инициализуется данный экземпляр.
   * Возвращает: Указатель на новый экземпляр.
   */
  static SAFEARRAY* opCall(T)(T[] array) {
    auto bound = SAFEARRAYBOUND(array.length);
    auto sa = SafeArrayCreate(VariantType!(T), 1, &bound);

    static if (is(T : string)) alias wchar* Type;
    else                       alias T Type;

    Type* data;
    SafeArrayAccessData(sa, retval(data));
    for (auto i = 0; i < array.length; i++) {
      static if (is(T : string)) data[i] = array[i].toBstr();
      else                       data[i] = array[i];
    }
    SafeArrayUnaccessData(sa);

    return sa;
  }

  /**
   * Копирует элементы этого БЕЗОПМАСа в новый массив указанного типа.
   * Возвращает: Массив заданного типа с копиями элементов данного БЕЗОПМАСа.
   */
  alias toArray вМассив;
  
  T[] toArray(T)() {
    int upperBound, lowerBound;
    SafeArrayGetUBound(this, 1, upperBound);
    SafeArrayGetLBound(this, 1, lowerBound);
    int count = upperBound - lowerBound + 1;

    if (count == 0) return null;

    T[] result = new T[count];

    static if (is(T : string)) alias wchar* Type;
    else                       alias T Type;

    Type* data;
    SafeArrayAccessData(this, retval(data));
    for (auto i = lowerBound; i < upperBound + 1; i++) {
      static if (is(T : string)) result[i] = fromBstr(data[i]);
      else                       result[i] = data[i];
    }
    SafeArrayUnaccessData(this);

    return result;
  }

  /**
   * Уничтожает БЕЗОПМАС и все его данные.
   * Заметки: Если в массиве есть объекты, то для каждого из них вызывается Release.
   */  
  void destroy() {
    version(D_Version2) {
      SafeArrayDestroy(&this);
    }
    else {
      SafeArrayDestroy(this);
    }
  }

  проц разрушь(){ destroy();}
  
  /**
   * Увеличивает на единицу счётчик массива _lock.
   */
  void lock() {
    version(D_Version2) {
      SafeArrayLock(&this);
    }
    else {
      SafeArrayLock(this);
    }
  }

  проц блокируй(){lock();}
  
  /**
   * Уменьшает счётчик блокировок массива.
   */
  void unlock() {
    version(D_Version2) {
      SafeArrayUnlock(&this);
    }
    else {
      SafeArrayUnlock(this);
    }
  }

  проц разблокируй(){unlock();}
  
  /**
   * Узнает или устанавливает число элементов в массиве.
   * Параметры: value = Число элементов.
   */
  void length(int value) {
    auto bound = SAFEARRAYBOUND(value);
    version(D_Version2) {
      SafeArrayRedim(&this, &bound);
    }
    else {
      SafeArrayRedim(this, &bound);
    }
  }
  
 проц длина(цел знач){length(cast(int) знач);}
 
  /// ditto
  int length() {
    int upperBound, lowerBound;
    version(D_Version2) {
      SafeArrayGetUBound(&this, 1, upperBound);
      SafeArrayGetLBound(&this, 1, lowerBound);
    }
    else {
      SafeArrayGetUBound(this, 1, upperBound);
      SafeArrayGetLBound(this, 1, lowerBound);
    }
    return upperBound - lowerBound + 1;
  }

  цел длина(){return cast(цел) length();}
  
}

extern(Windows):

int SafeArrayAllocDescriptor(uint cDims, out SAFEARRAY* ppsaOut);
int SafeArrayAllocDescriptorEx(ushort vt, uint cDims, out SAFEARRAY* ppsaOut);
int SafeArrayAllocData(SAFEARRAY* psa);
SAFEARRAY* SafeArrayCreate(ushort vt, uint cDims, SAFEARRAYBOUND* rgsabound);
SAFEARRAY* SafeArrayCreateEx(ushort vt, uint cDims, SAFEARRAYBOUND* rgsabound, void* pvExtra);
int SafeArrayCopyData(SAFEARRAY* psaSource, SAFEARRAY* psaTarget);
int SafeArrayDestroyDescriptor(SAFEARRAY* psa);
int SafeArrayDestroyData(SAFEARRAY* psa);
int SafeArrayDestroy(SAFEARRAY* psa);
int SafeArrayRedim(SAFEARRAY* psa, SAFEARRAYBOUND* psaboundNew);
uint SafeArrayGetDim(SAFEARRAY* psa);
uint SafeArrayGetElemsize(SAFEARRAY* psa);
int SafeArrayGetUBound(SAFEARRAY* psa, uint cDim, out int plUbound);
int SafeArrayGetLBound(SAFEARRAY* psa, uint cDim, out int plLbound);
int SafeArrayLock(SAFEARRAY* psa);
int SafeArrayUnlock(SAFEARRAY* psa);
int SafeArrayAccessData(SAFEARRAY* psa, void** ppvData);
int SafeArrayUnaccessData(SAFEARRAY* psa);
int SafeArrayGetElement(SAFEARRAY* psa, int* rgIndices, void* pv);
int SafeArrayPutElement(SAFEARRAY* psa, int* rgIndices, void* pv);
int SafeArrayCopy(SAFEARRAY* psa, out SAFEARRAY* ppsaOut);
int SafeArrayPtrOfIndex(SAFEARRAY* psa, int* rgIndices, void** ppvData);
int SafeArraySetRecordInfo(SAFEARRAY* psa, IRecordInfo prinfo);
int SafeArrayGetRecordInfo(SAFEARRAY* psa, out IRecordInfo prinfo);
int SafeArraySetIID(SAFEARRAY* psa, ref GUID guid);
int SafeArrayGetIID(SAFEARRAY* psa, out GUID pguid);
int SafeArrayGetVartype(SAFEARRAY* psa, out ushort pvt);
SAFEARRAY* SafeArrayCreateVector(ushort vt, int lLbound, uint cElements);
SAFEARRAY* SafeArrayCreateVectorEx(ushort vt, int lLbound, uint cElements, void* pvExtra);
////////////////////////////////////////////////
extern(Windows)//Русская Версия
{
цел РазместиДескрипторБезопмаса(бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptor(cast(uint) члоИзм, cast(SAFEARRAY*) укнаВыв);
	}

цел РазместиДескрипторБезопмасаДоп(бкрат вт, бцел члоИзм, out БЕЗОПМАС* укнаВыв)
	{
	return cast(цел) SafeArrayAllocDescriptorEx(cast(ushort) вт, cast(uint) члоИзм, cast(SAFEARRAY*) укнаВыв);
	}

цел РазместиДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayAllocData(cast(SAFEARRAY*) бм);
	}

БЕЗОПМАС* СоздайБезопмас(бкрат вт, бцел члоИзм, ГРАНБЕЗОПМАСА* бмГран)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreate(cast(ushort) вт, cast(uint) члоИзм, cast(SAFEARRAYBOUND*) бмГран);
	}
	
БЕЗОПМАС* СоздайБезопмасДоп(бкрат вт, бцел члоИзм, ГРАНБЕЗОПМАСА* бмГран, ук вЭкстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateEx(cast(ushort) вт, cast(uint) члоИзм, cast(SAFEARRAYBOUND*) бмГран, cast(void*) вЭкстра);
	}
	
цел КопируйДанныеБезопмаса(БЕЗОПМАС* бмИсх, БЕЗОПМАС* бмПрий)
	{
	return cast(цел) SafeArrayCopyData(cast(SAFEARRAY*) бмИсх, cast(SAFEARRAY*) бмПрий);
	}

цел УничтожьДескрипторБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyDescriptor(cast(SAFEARRAY*) бм);
	}

цел УничтожьДанныеБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroyData(cast(SAFEARRAY*) бм);
	}

цел УничтожьБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayDestroy(cast(SAFEARRAY*) бм);
	}

цел ИзмениГраницуБезопмаса(БЕЗОПМАС* бм, ГРАНБЕЗОПМАСА* бмНовГран)
	{
	return cast(цел) SafeArrayRedim(cast(SAFEARRAY*) бм, cast(SAFEARRAYBOUND*) бмНовГран);
	}

бцел ДайЧлоИзмеренийБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetDim(cast(SAFEARRAY*) бм);
	}

бцел ДайРазмерЭлементовБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(бцел) SafeArrayGetElemsize(cast(SAFEARRAY*) бм);
	}

цел ДайВПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел вПредел)
	{
	return cast(цел) SafeArrayGetUBound(cast(SAFEARRAY*) бм, cast(uint) члоИзм, cast(int) вПредел);
	}

цел ДайНПределБезопмаса(БЕЗОПМАС* бм, бцел члоИзм, out цел нПредел)
	{
	return cast(цел) SafeArrayGetLBound(cast(SAFEARRAY*) бм, cast(uint) члоИзм, cast(int) нПредел);
	}

цел БлокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayLock(cast(SAFEARRAY*) бм);
	}

цел РазблокируйБезопмас(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnlock(cast(SAFEARRAY*) бм);
	}

цел ДоступКДаннымБезопмаса(БЕЗОПМАС* бм, ук* данные)
	{
	return cast(цел) SafeArrayAccessData(cast(SAFEARRAY*) бм, cast(void**) данные);
	}

цел ОтступОтДаныхБезопмаса(БЕЗОПМАС* бм)
	{
	return cast(цел) SafeArrayUnaccessData(cast(SAFEARRAY*) бм);
	}

цел ДайЭлементБезопмаса(БЕЗОПМАС* бм, уцел индексы, ук в)
	{
	return cast(цел) SafeArrayGetElement(cast(SAFEARRAY*) бм, cast(int*) индексы, cast(void*) в);
	}
	
цел ПоместиЭлементВБезопмас(БЕЗОПМАС* бм, уцел индексы, ук в)
	{
	return cast(цел) SafeArrayPutElement(cast(SAFEARRAY*) бм, cast(int*) индексы, cast(void*) в);
	}

цел КопируйБезопмас(БЕЗОПМАС* бм, out БЕЗОПМАС* бмВыв)
	{
	return cast(цел) SafeArrayCopy(cast(SAFEARRAY*) бм, cast(SAFEARRAY*) бмВыв);
	}

цел УкНаИндексБезопмаса(БЕЗОПМАС* бм, уцел индексы, ук* данные)
	{
	return cast(цел) SafeArrayPtrOfIndex(cast(SAFEARRAY*) бм, cast(int*) индексы, cast(void**) данные);
	}

цел УстИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArraySetRecordInfo(cast(SAFEARRAY*) бм, cast(IRecordInfo) инфоз);
	}

цел ДайИнфОЗаписиБезопмаса(БЕЗОПМАС* бм, out ИИнфОЗаписи инфоз)
	{
	return cast(цел) SafeArrayGetRecordInfo(cast(SAFEARRAY*) бм, cast(IRecordInfo) инфоз);
	}

цел УстановиИИДБезопмаса(БЕЗОПМАС* бм, ref ГУИД гуид)
	{
	return cast(цел) SafeArraySetIID(cast(SAFEARRAY*) бм, cast(GUID) гуид);
	}

цел ДайИИДБезопмаса(БЕЗОПМАС* бм, out ГУИД гуид)
	{
	return cast(цел) SafeArrayGetIID(cast(SAFEARRAY*) бм, cast(GUID) гуид);
	}

цел ДайВартипБезопмаса(БЕЗОПМАС* бм, бкрат вт)
	{
	return cast(цел) SafeArrayGetVartype(cast(SAFEARRAY*) бм, cast(ushort) вт);
	}

БЕЗОПМАС* СоздайВекторБезопмаса(бкрат вт, цел нПредел, бцел элементы)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVector(cast(ushort) вт, cast(int) нПредел, cast(uint) элементы);
	}

БЕЗОПМАС* СоздайВекторБезопмасаДоп(бкрат вт, цел нПредел, бцел элементы, ук экстра)
	{
	return cast(БЕЗОПМАС*) SafeArrayCreateVectorEx(cast(ushort) вт, cast(int) нПредел, cast(uint) элементы, cast(void*) экстра);
	}
}
////////////////////////////////////////////////////////////////////////

extern(D):

version(D_Version2) {
  string decimal_operator(string name) {
    return "DECIMAL op" ~ name ~ "(DECIMAL d) { \n"
      "  DECIMAL result; \n"
      "  VarDec" ~ name ~ "(this, d, result); \n"
      "  return result; \n"
      "} \n"
      "void op" ~ name ~ "Assign" ~ "(DECIMAL d) { \n"
      "  VarDec" ~ name ~ "(this, d, this); \n"
      "}";
  }
}
else {
  string decimal_operator(string name) {
    return "DECIMAL op" ~ name ~ "(DECIMAL d) { \n"
      "  DECIMAL result; \n"
      "  VarDec" ~ name ~ "(*this, d, result); \n"
      "  return result; \n"
      "} \n"
      "void op" ~ name ~ "Assign" ~ "(DECIMAL d) { \n"
      "  VarDec" ~ name ~ "(*this, d, *this); \n"
      "}";
  }
}

const ubyte DECIMAL_NEG = 0x80;

DECIMAL dec(string s)() {
  return DECIMAL.parse(s);
}

ДЕСЯТИЧ дес(ткст т)(){return ДЕСЯТИЧ.разбор(т);}

/**
 * Представляет десятичное число в пределах от положительного 79,228,162,514,264,337,593,543,950,335 до отрицательного 79,228,162,514,264,337,593,543,950,335.
 */

alias DECIMAL ДЕСЯТИЧ;
struct DECIMAL {

alias wReserved резерв;
alias scale шкала;
alias sign знак;
alias Hi32 Старш32;
alias Lo32 Младш32;
alias Mid32 Средн32;
alias min мин;
alias max макс;
alias  minusOne минусОдин;
alias zero ноль;
alias one один;
alias parse разбор;
alias abs абс;
alias round округли;
alias floor кОтрБеск;
alias remainder остаток;
alias add сложи;
alias subtract отними;
alias multiply умножь;
alias divide раздели;
alias negate вОтриц;
alias toHash вХэш;
alias toString вТкст;
alias compare сравни;
alias compareTo сравниС;
alias equals равны_ли;
alias truncate отсеки;

  ushort wReserved;
  ubyte scale;
  ubyte sign;
  uint Hi32;
  uint Lo32;
  uint Mid32;

  /// Represents the smallest possible value.
  static DECIMAL min = { 0, 0, DECIMAL_NEG, uint.max, uint.max, uint.max };
  /// Represents the largest possible value.
  static DECIMAL max = { 0, 0, 0, uint.max, uint.max, uint.max };
  /// Represents -1.
  static DECIMAL minusOne = { 0, 0, DECIMAL_NEG, 0, 1, 0 };
  /// Represents 0.
  static DECIMAL zero = { 0, 0, 0, 0, 0, 0 };
  /// Represents 1.
  static DECIMAL one = { 0, 0, 0, 0, 1, 0 };

  /// Инициализует новый экземпляр.
  static DECIMAL opCall(T)(T value) {
    DECIMAL self;

    static if (is(T == uint))
      VarDecFromUI4(value, self);
    else static if (is(T == int))
      VarDecFromI4(value, self);
    else static if (is(T == ulong))
      VarDecFromUI8(value, self);
    else static if (is(T == long))
      VarDecFromI8(value, self);
    else static if (is(T == float))
      VarDecFromR4(value, self);
    else static if (is(T == double))
      VarDecFromR8(value, self);
    else static assert(false);

    return self;
  }

  /// ditto
  static DECIMAL opCall(T = void)(uint lo, uint mid, uint hi, bool isNegative, ubyte scale) {
    DECIMAL self;
    self.Hi32 = hi, self.Mid32 = mid, self.Lo32 = lo, self.scale = scale, self.sign = isNegative ? DECIMAL_NEG : 0;
    return self;
  }

  /// Преобразует строковое представление числа в его ДЕСЯТИЧный эквивалент.
  static DECIMAL parse(string s) {
    DECIMAL d;
    VarDecFromStr(s.toUTF16z(), GetThreadLocale(), 0, d);
    return d;
  }

  static DECIMAL abs(DECIMAL d) {
    DECIMAL result;
    VarDecAbs(d, result);
    return result;
  }

  /// Округляет значение до ближайшего или специфичного числа.
  static DECIMAL round(DECIMAL d, int decimals = 0) {
    DECIMAL result;
    VarDecRound(d, decimals, result);
    return result;
  }

  /// Округляет значение до ближайшего к отрицательной бесконечности целого.
  static DECIMAL floor(DECIMAL d) {
    DECIMAL result;
    VarDecInt(d, result);
    return result;
  }

  /// Возвращает интегральные числа значения.
  static DECIMAL truncate(DECIMAL d) {
    DECIMAL result;
    VarDecFix(d, result);
    return result;
  }

  /// Вычисляет остаток после деления двух значений.
  static DECIMAL remainder(DECIMAL d1, DECIMAL d2) {
    if (abs(d1) < abs(d2))
      return d1;

    d1 -= d2;

    DECIMAL dr = truncate(d1 / d2);
    DECIMAL mr = dr * d2;
    DECIMAL r = d1 - mr;

    if (d1.sign != r.sign && r != cast(DECIMAL)0)
      r += d2;

    return r;
  }

  /// Складывает два значения.
  static DECIMAL add(DECIMAL d1, DECIMAL d2) {
    DECIMAL result;
    VarDecAdd(d1, d2, result);
    return result;
  }

  /// Отнимает одно значение от другого.
  static DECIMAL subtract(DECIMAL d1, DECIMAL d2) {
    DECIMAL result;
    VarDecSub(d1, d2, result);
    return result;
  }

  /// Перемножает два значения.
  static DECIMAL multiply(DECIMAL d1, DECIMAL d2) {
    DECIMAL result;
    VarDecMul(d1, d2, result);
    return result;
  }

  /// Делит два значения.
  static DECIMAL divide(DECIMAL d1, DECIMAL d2) {
    DECIMAL result;
    VarDecDiv(d1, d2, result);
    return result;
  }

  /// Возвращает результат умножения значения на -1.
  static DECIMAL negate(DECIMAL d) {
    DECIMAL result;
    VarDecNeg(d, result);
    return result;
  }

  uint toHash() {
    double d;
    VarR8FromDec(this, d);
    if (d == 0)
      return 0;
    return (cast(int*)&d)[0] ^ (cast(int*)&d)[1];
  }

  /// Converts the numeric value of this instance to its equivalent string representation.
  string toString() {
    wchar* str;
    if (VarBstrFromDec(this, GetThreadLocale(), 0, str) != S_OK)
      return null;
    return fromBstr(str);
  }

  /// Compares two values.
  static int compare(DECIMAL d1, DECIMAL d2) {
    return VarDecCmp(d1, d2) - 1;
  }

  /// Compares this instance to a specified instance.
  int compareTo(DECIMAL value) {
    version(D_Version2) {
      return compare(this, value);
    }
    else {
      return compare(*this, value);
    }
  }

  /// ditto
  int opCmp(DECIMAL d) {
    version(D_Version2) {
      return compare(this, d);
    }
    else {
      return compare(*this, d);
    }
  }

  /// Returns a value indicating whether two instances represent the same value.
  static bool equals(DECIMAL d1, DECIMAL d2) {
    return compare(d1, d2) == 0;
  }

  /// Returns a value indicating whether this instance and a specified instance represent the same _value.
  bool equals(DECIMAL value) {
    version(D_Version2) {
      return compare(this, value) == 0;
    }
    else {
      return compare(*this, value) == 0;
    }
  }

  /// ditto
  bool opEquals(DECIMAL d) {
    version(D_Version2) {
      return compare(this, d) == 0;
    }
    else {
      return compare(*this, d) == 0;
    }
  }

  mixin(decimal_operator("Add"));
  mixin(decimal_operator("Sub"));
  mixin(decimal_operator("Mul"));
  mixin(decimal_operator("Div"));

  DECIMAL opMod(DECIMAL d) {
    version(D_Version2) {
      return remainder(this, d);
    }
    else {
      return remainder(*this, d);
    }
  }

  DECIMAL opNeg() {
    DECIMAL result;
    VarDecNeg(this, result);
    return result;
  }

  DECIMAL opPos() {
    version(D_Version2) {
      return this;
    }
    else {
      return *this;
    }
  }

  DECIMAL opPostInc() {
    version(D_Version2) {
      return this = this + DECIMAL(1);
    }
    else {
      return *this = *this + DECIMAL(1);
    }
  }

  DECIMAL opPostDec() {
    version(D_Version2) {
      return this = this - DECIMAL(1);
    }
    else {
      return *this = *this - DECIMAL(1);
    }
  }

}

alias DECIMAL Decimal;

extern(Windows):

int VarDecFromUI4(uint ulIn, out DECIMAL pdecOut);
int VarDecFromI4(int lIn, out DECIMAL pdecOut);
int VarDecFromUI8(ulong ui64In, out DECIMAL pdecOut);
int VarDecFromI8(long i64In, out DECIMAL pdecOut);
int VarDecFromR4(float dlbIn, out DECIMAL pdecOut);
int VarDecFromR8(double dlbIn, out DECIMAL pdecOut);
int VarDecFromStr(in wchar* StrIn, uint lcid, uint dwFlags, out DECIMAL pdecOut);
int VarBstrFromDec(ref DECIMAL pdecIn, uint lcid, uint dwFlags, out wchar* pbstrOut);
int VarUI4FromDec(ref DECIMAL pdecIn, out uint pulOut);
int VarI4FromDec(ref DECIMAL pdecIn, out int plOut);
int VarUI8FromDec(ref DECIMAL pdecIn, out ulong pui64Out);
int VarI8FromDec(ref DECIMAL pdecIn, out long pi64Out);
int VarR4FromDec(ref DECIMAL pdecIn, out float pfltOut);
int VarR8FromDec(ref DECIMAL pdecIn, out double pdblOut);

int VarDecAdd(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
int VarDecSub(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
int VarDecMul(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
int VarDecDiv(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
int VarDecRound(ref DECIMAL pdecIn, int cDecimals, out DECIMAL pdecResult);
int VarDecAbs(ref DECIMAL pdecIn, out DECIMAL pdecResult);
int VarDecFix(ref DECIMAL pdecIn, out DECIMAL pdecResult);
int VarDecInt(ref DECIMAL pdecIn, out DECIMAL pdecResult);
int VarDecNeg(ref DECIMAL pdecIn, out DECIMAL pdecResult);
int VarDecCmp(ref DECIMAL pdecLeft, out DECIMAL pdecRight);
//////////////////////////////////////

цел ДесВарИзБЦ4(бцел бцВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromUI4(бцВхо, десВых);
	}

цел ДесВарИзЦ4(цел цВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromI4(цВхо, десВых);
	}

цел ДесВарИзБЦ8(бдол бдВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromUI8(бдВхо, десВых);
	}

цел ДесВарИзЦ8(дол дВхо, out ДЕСЯТИЧ десВых)
	{
	return cast(цел) VarDecFromI8(дВхо, десВых);
	}
	

/*


цел VarDecFromR4(float dlbIn, out DECIMAL pdecOut);
цел VarDecFromR8(double dlbIn, out DECIMAL pdecOut);
цел VarDecFromStr(in wchar* StrIn, uint lcid, uint dwFlags, out DECIMAL pdecOut);
цел VarBstrFromDec(ref DECIMAL pdecIn, uint lcid, uint dwFlags, out wchar* pbstrOut);
цел VarUI4FromDec(ref DECIMAL pdecIn, out uint pulOut);
цел VarI4FromDec(ref DECIMAL pdecIn, out int plOut);
цел VarUI8FromDec(ref DECIMAL pdecIn, out ulong pui64Out);
цел VarI8FromDec(ref DECIMAL pdecIn, out long pi64Out);
цел VarR4FromDec(ref DECIMAL pdecIn, out float pfltOut);
цел VarR8FromDec(ref DECIMAL pdecIn, out double pdblOut);

цел VarDecAdd(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecSub(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecMul(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecDiv(ref DECIMAL pdecLeft, ref DECIMAL pdecRight, out DECIMAL pdecResult);
цел VarDecRound(ref DECIMAL pdecIn, int cDecimals, out DECIMAL pdecResult);
цел VarDecAbs(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecFix(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecInt(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecNeg(ref DECIMAL pdecIn, out DECIMAL pdecResult);
цел VarDecCmp(ref DECIMAL pdecLeft, out DECIMAL pdecRight);
*/
//////////////////////////////////////////////////////////////
version(D_Version2) {
}
else {
  int VarBstrFromDec(DECIMAL* pdecIn, uint lcid, uint dwFlags, out wchar* pbstrOut);
  int VarR8FromDec(DECIMAL* pdecIn, out double pdblOut);
  int VarDecNeg(DECIMAL* pdecIn, out DECIMAL pdecResult);
  
  /*
  int VarBstrFromDec(DECIMAL* pdecIn, uint lcid, uint dwFlags, out wchar* pbstrOut);
  int VarR8FromDec(DECIMAL* pdecIn, out double pdblOut);
  int VarDecNeg(DECIMAL* pdecIn, out DECIMAL pdecResult);
  */
}

int VarFormat(ref VARIANT pvarIn, in wchar* pstrFormat, int iFirstDay, int iFirstWeek, uint dwFlags, out wchar* pbstrOut);
int VarFormatFromTokens(ref VARIANT pvarIn, in wchar* pstrFormat, byte* pbTokCur, uint dwFlags, out wchar* pbstrOut, uint lcid);
int VarFormatNumber(ref VARIANT pvarIn, int iNumDig, int ilncLead, int iUseParens, int iGroup, uint dwFlags, out wchar* pbstrOut);

/*
int VarFormat(ref VARIANT pvarIn, in wchar* pstrFormat, int iFirstDay, int iFirstWeek, uint dwFlags, out wchar* pbstrOut);
int VarFormatFromTokens(ref VARIANT pvarIn, in wchar* pstrFormat, byte* pbTokCur, uint dwFlags, out wchar* pbstrOut, uint lcid);
int VarFormatNumber(ref VARIANT pvarIn, int iNumDig, int ilncLead, int iUseParens, int iGroup, uint dwFlags, out wchar* pbstrOut);
*/

extern(D):

enum /*VARENUM*/ : ushort {
  VT_EMPTY            = 0,
  VT_NULL             = 1,
  VT_I2               = 2,
  VT_I4               = 3,
  VT_R4               = 4,
  VT_R8               = 5,
  VT_CY               = 6,
  VT_DATE             = 7,
  VT_BSTR             = 8,
  VT_DISPATCH         = 9,
  VT_ERROR            = 10,
  VT_BOOL             = 11,
  VT_VARIANT          = 12,
  VT_UNKNOWN          = 13,
  VT_DECIMAL          = 14,
  VT_I1               = 16,
  VT_UI1              = 17,
  VT_UI2              = 18,
  VT_UI4              = 19,
  VT_I8               = 20,
  VT_UI8              = 21,
  VT_INT              = 22,
  VT_UINT             = 23,
  VT_VOID             = 24,
  VT_HRESULT          = 25,
  VT_PTR              = 26,
  VT_SAFEARRAY        = 27,
  VT_CARRAY           = 28,
  VT_USERDEFINED      = 29,
  VT_LPSTR            = 30,
  VT_LPWSTR           = 31,
  VT_RECORD           = 36,
  VT_INT_PTR          = 37,
  VT_UINT_PTR         = 38,
  VT_FILETIME         = 64,
  VT_BLOB             = 65,
  VT_STREAM           = 66,
  VT_STORAGE          = 67,
  VT_STREAMED_OBJECT  = 68,
  VT_STORED_OBJECT    = 69,
  VT_BLOB_OBJECT      = 70,
  VT_CF               = 71,
  VT_CLSID            = 72,
  VT_VERSIONED_STREAM = 73,
  VT_BSTR_BLOB        = 0x0fff,
  VT_VECTOR           = 0x1000,
  VT_ARRAY            = 0x2000,
  VT_BYREF            = 0x4000,
  VT_RESERVED         = 0x8000
}
alias ushort VARTYPE;

enum : short {
  VARIANT_TRUE = -1, /// Represents the boolean value _true (-1).
  VARIANT_FALSE = 0  /// Represents the boolean value _false (0).
}
typedef short VARIANT_BOOL;

enum : VARIANT_BOOL {
  com_true = VARIANT_TRUE,
  com_false = VARIANT_FALSE
}
alias VARIANT_BOOL com_bool;

template isStaticArray(T : U[N], U, size_t N) {
  const isStaticArray = true;
}

template isStaticArray(T) {
  const isStaticArray = false;
}

template isDynamicArray(T, U = void) {
  const isDynamicArray = false;
}

template isDynamicArray(T : U[], U) {
  const isDynamicArray = !isStaticArray!(T);
}

template isArray(T) {
  const isArray = isStaticArray!(T) || isDynamicArray!(T);
}

template isPointer(T) {
  const isPointer = is(T : void*);
}

/**
 * Determines the equivalent COM type of a built-in type at compile-time.
 * Примеры:
 * ---
 * auto a = VariantType!(string);          // VT_BSTR
 * auto b = VariantType!(bool);            // VT_BOOL
 * auto c = VariantType!(typeof([1,2,3])); // VT_ARRAY | VT_I4
 * ---
 */
template VariantType(T) {
  static if (is(T == VARIANT_BOOL))
    const VariantType = VT_BOOL;
  else static if (is(T == bool))
    const VariantType = VT_BOOL;
  else static if (is(T == char))
    const VariantType = VT_UI1;
  else static if (is(T == ubyte))
    const VariantType = VT_UI1;
  else static if (is(T == byte))
    const VariantType = VT_I1;
  else static if (is(T == ushort))
    const VariantType = VT_UI2;
  else static if (is(T == short))
    const VariantType = VT_I2;
  else static if (is(T == uint))
    const VariantType = VT_UI4;
  else static if (is(T == int))
    const VariantType = VT_I4;
  else static if (is(T == ulong))
    const VariantType = VT_UI8;
  else static if (is(T == long))
    const VariantType = VT_I8;
  else static if (is(T == float))
    const VariantType = VT_R4;
  else static if (is(T == double))
    const VariantType = VT_R8;
  else static if (is(T == DECIMAL))
    const VariantType = VT_DECIMAL;
  else static if (is(T E == enum))
    const VariantType = VariantType!(E);
  else static if (is(T : string) || is(T : wstring) || is(T : dstring))
    const VariantType = VT_BSTR;
  else static if (is(T == wchar*))
    const VariantType = VT_BSTR;
  else static if (is(T == SAFEARRAY*))
    const VariantType = VT_ARRAY;
  else static if (is(T == VARIANT))
    const VariantType = VT_VARIANT;
  else static if (is(T : IDispatch))
    const VariantType = VT_DISPATCH;
  else static if (is(T : IUnknown))
    const VariantType = VT_UNKNOWN;
  else static if (isArray!(T))
    const VariantType = VariantType!(typeof(*T)) | VT_ARRAY;
  else static if (isPointer!(T)/* && !is(T == void*)*/)
    const VariantType = VariantType!(typeof(*T)) | VT_BYREF;
  else
    const VariantType = VT_VOID;
}

version(D_Version2) {
  string variant_operator(string name) {
    return "VARIANT op" ~ name ~ "(VARIANT that) { \n"
      "  VARIANT result; \n"
      "  Var" ~ name ~ "(this, that, result); \n"
      "  return result; \n"
      "} \n"
      "void op" ~ name ~ "Assign" ~ "(VARIANT that) { \n"
      "  if (!isEmpty) clear(); \n"
      "  Var" ~ name ~ "(this, that, this); \n"
      "}";
  }
}
else {
  string variant_operator(string name) {
    return "VARIANT op" ~ name ~ "(VARIANT that) { \n"
      "  VARIANT result; \n"
      "  Var" ~ name ~ "(*this, that, result); \n"
      "  return result; \n"
      "} \n"
      "void op" ~ name ~ "Assign" ~ "(VARIANT that) { \n"
      "  if (!isEmpty) clear(); \n"
      "  Var" ~ name ~ "(*this, that, *this); \n"
      "}";
  }
}

/**
 * A container for many different types.
 * Примеры:
 * ---
 * VARIANT var = 10;     // Instance contains VT_I4.
 * var = "Hello, World"; // Instance now contains VT_BSTR.
 * var = 234.5;          // Instance now contains VT_R8.
 * ---
 */

alias VARIANT ВАРИАНТ;
struct VARIANT {

  union {
    struct {
      /// Описывает тип данного экземпляра.
      ushort vt;
      ushort wReserved1;
      ushort wReserved2;
      ushort wReserved3;
      union {
        long llVal;
        int lVal;
        ubyte bVal;
        short iVal;
        float fltVal;
        double dblVal;
        VARIANT_BOOL boolVal;
        int scode;
        long cyVal;
        double date;
        wchar* bstrVal;
        IUnknown punkVal;
        IDispatch pdispVal;
        SAFEARRAY* parray;
        ubyte* pbVal;
        short* piVal;
        int* plVal;
        long* pllVal;
        float* pfltVal;
        double* pdblVal;
        VARIANT_BOOL* pboolVal;
        int* pscode;
        long* pcyVal;
        double* pdate;
        wchar** pbstrVal;
        IUnknown* ppunkVal;
        IDispatch* ppdispVal;
        SAFEARRAY** pparray;
        VARIANT* pvarVal;
        void* byref;
        byte cVal;
        ushort uiVal;
        uint ulVal;
        ulong ullVal;
        DECIMAL* pdecVal;
        byte* pcVal;
        short* puiVal;
        uint* pulVal;
        ulong* pullVal;
        struct {
          void* pvRecord;
          IRecordInfo pRecInfo;
        }
      }
    }
    DECIMAL decVal;
  }

  /// Represents the _missing value.
  static VARIANT Missing = { vt: VT_ERROR, scode: DISP_E_PARAMNOTFOUND };

  /// Represents the _nothing value.
  static VARIANT Nothing = { vt: VT_DISPATCH, pdispVal: null };

  /// Represents the _null value.
  static VARIANT Null = { vt: VT_NULL };

  version(D_Version2) {
    /**
     * Инициализует новый экземпляр с помощью указанных _значения и _типа.
     * Параметры:
     *   value = Значение одного из приемлемых типов.
     *   type = бкрат, идентифицирующий тип значения.
     */
    mixin("
    this(T)(T value, ushort type = VariantType!(T)) {
      initialize(this, value, type);
    }
    ");

    static VARIANT opCall(T)(T value, ushort type = VariantType!(T)) {
      return VARIANT(value, type);
    }

    ~this() {
      if (isCOMAlive && !(isNull || isEmpty)) {
        clear();
      }
    }
  }
  else {
    /**
     * Initializes a new instance using the specified _value and _type.
     * Параметры:
     *   value = A _value of one of the acceptable types.
     *   type = The ushort identifying the _type of value.
     * Возвращает: The resulting VARIANT.
     */
    static VARIANT opCall(T)(T value, ushort type = VariantType!(T)) {
      VARIANT self;
      initialize(self, value, type);
      return self;
    }
  }

  private static void initialize(T)(ref VARIANT ret, T value, ushort type = VariantType!(T)) {
    static if (is(T E == enum)) {
      initialize(ret, cast(E)value, type);
    }
    else {
      ret = value;
      if (type != ret.vt)
        VariantChangeTypeEx(ret, ret, GetThreadLocale(), VARIANT_ALPHABOOL, type);
    }
  }

  /*void opAssign(T)(T value) {
    if (!isEmpty)
      clear();

    static if (is(T == long)) llVal = value;
    else static if (is(T == int)) lVal = value;
    else static if (is(T == ubyte)) bVal = value;
    else static if (is(T == short)) iVal = value;
    else static if (is(T == float)) fltVal = value;
    else static if (is(T == double)) dblVal = value;
    else static if (is(T == VARIANT_BOOL)) boolVal = value;
    else static if (is(T == bool)) boolVal = value ? VARIANT_TRUE : VARIANT_FALSE;
    else static if (is(T : string) || is(T : wstring) || is(T : dstring)) bstrVal = toBstr(value);
    else static if (is(T : IDispatch)) pdispVal = value, value.AddRef();
    else static if (is(T : IUnknown)) punkVal = value, value.AddRef();
    else static if (is(T == SAFEARRAY*)) parray = value;
    else static if (isArray!(T)) parray = SAFEARRAY(value);
    else static if (is(T == VARIANT*)) pvarVal = value;
    else static if (is(T : Object)) byref = cast(void*)value;
    else static if (isPointer!(T)) byref = cast(void*)value;
    else static if (is(T == byte)) cVal = value;
    else static if (is(T == ushort)) uiVal = value;
    else static if (is(T == uint)) ulVal = value;
    else static if (is(T == ulong)) ullVal = value;
    else static if (is(T == DECIMAL)) decVal = value;
    else static if (is(T == VARIANT)) {}
    else static assert(false, "'" ~ T.stringof ~ "' is not one of the allowed types.");

    vt = VariantType!(T);

    static if (is(T == SAFEARRAY*)) {
      ushort type;
      SafeArrayGetVartype(value, type);
      vt |= type;
    }
    else static if (is(T == VARIANT)) {
      value.copyTo(*this);
    }
  }*/

  void opAssign(long value) {
    if (!isEmpty) clear();
    llVal = value;
    vt = VT_I8;
  }

  void opAssign(int value) {
    if (!isEmpty) clear();
    lVal = value;
    vt = VT_I4;
  }

  void opAssign(ubyte value) {
    if (!isEmpty) clear();
    bVal = value;
    vt = VT_UI1;
  }

  void opAssign(short value) {
    if (!isEmpty) clear();
    iVal = value;
    vt = VT_I2;
  }

  void opAssign(float value) {
    if (!isEmpty) clear();
    fltVal = value;
    vt = VT_R4;
  }

  void opAssign(double value) {
    if (!isEmpty) clear();
    dblVal = value;
    vt = VT_R8;
  }

  void opAssign(bool value) {
    if (!isEmpty) clear();
    boolVal = value ? VARIANT_TRUE : VARIANT_FALSE;
    vt = VT_BOOL;
  }

  void opAssign(VARIANT_BOOL value) {
    if (!isEmpty) clear();
    boolVal = value;
    vt = VT_BOOL;
  }

  void opAssign(string value) {
    if (!isEmpty) clear();
    bstrVal = toBstr(value);
    vt = VT_BSTR;
  }

  void opAssign(IUnknown value) {
    if (!isEmpty) clear();
    if (auto disp = com_cast!(IDispatch)(value)) {
      pdispVal = disp;
      vt = VT_DISPATCH;
    }
    else {
      value.AddRef();
      punkVal = value;
      vt = VT_UNKNOWN;
    }
  }

  void opAssign(SAFEARRAY* value) {
    if (!isEmpty) clear();
    parray = value;
    ushort type;
    SafeArrayGetVartype(value, type);
    vt = VT_ARRAY | type;
  }

  void opAssign(byte value) {
    if (!isEmpty) clear();
    cVal = value;
    vt = VT_I1;
  }

  void opAssign(ushort value) {
    if (!isEmpty) clear();
    uiVal = value;
    vt = VT_UI2;
  }

  void opAssign(uint value) {
    if (!isEmpty) clear();
    ulVal = value;
    vt = VT_UI4;
  }

  void opAssign(ulong value) {
    if (!isEmpty) clear();
    ullVal = value;
    vt = VT_UI4;
  }

  void opAssign(DECIMAL value) {
    if (!isEmpty) clear();
    decVal = value;
    vt = VT_DECIMAL;
  }

  version(D_Version2) {
    // Illegal in 1.0
    void opAssign(VARIANT value) {
      if (!isEmpty) clear();
      VariantCopy(this, value);
    }

    /*void opAssign(VARIANT* value) {
      if (!isEmpty) clear();
      pvarVal = value;
      vt = VT_BYREF | VT_VARIANT;
    }*/
  }

  void opAssign(ubyte[] value) {
    if (!isEmpty) clear();
    parray = SAFEARRAY(value);
    vt = VT_ARRAY | VT_UI1;
  }

  /**
   * Clears the value of this instance and releases any associated memory.
   * See_Also: $(LINK2 http://msdn2.microsoft.com/en-us/library/ms221165.aspx, VariantClear).
   */
  void clear() {
    if (isCOMAlive && !(isNull || isEmpty)) {
      version(D_Version2) {
        VariantClear(this);
      }
    else {
        VariantClear(*this);
      }
    }
  }

  /**
   * Copies this instance into the destination value.
   * Параметры: dest = The variant to copy into.
   */
  void copyTo(out VARIANT dest) {
    version(D_Version2) {
      VariantCopy(dest, this);
    }
    else {
      VariantCopy(dest, *this);
    }
  }

  /**
   * Convers a variant from one type to another.
   * Параметры: newType = The type to change to.
   */
  VARIANT changeType(ushort newType) {
    VARIANT dest;
    version(D_Version2) {
      VariantChangeTypeEx(dest, this, GetThreadLocale(), VARIANT_ALPHABOOL, newType);
    }
    else {
      VariantChangeTypeEx(dest, *this, GetThreadLocale(), VARIANT_ALPHABOOL, newType);
    }
    return dest;
  }

  /**
   * Converts the value contained in this instance to a string.
   * Возвращает: A string representation of the value contained in this instance.
   */
  string toString() {
    if (isNull || isEmpty)
      return null;

    if (vt == VT_BSTR)
      return fromBstr(bstrVal);

    int hr;
    VARIANT temp;
    version(D_Version2) {
      hr = VariantChangeTypeEx(temp, this, GetThreadLocale(), VARIANT_ALPHABOOL, VT_BSTR);
    }
    else {
      hr = VariantChangeTypeEx(temp, *this, GetThreadLocale(), VARIANT_ALPHABOOL, VT_BSTR);
    }
    if (SUCCEEDED(hr))
      return fromBstr(temp.bstrVal);

    return null;
  }
  
  /**
   * Returns the _value contained in this instance.
   */
  V value(V)() {
    static if (is(V == long)) return llVal;
    else static if (is(V == int)) return lVal;
    else static if (is(V == ubyte)) return bVal;
    else static if (is(V == short)) return iVal;
    else static if (is(V == float)) return fltVal;
    else static if (is(V == double)) return dblVal;
    else static if (is(V == bool)) return (boolVal == VARIANT_TRUE) ? true : false;
    else static if (is(V == VARIANT_BOOL)) return boolVal;
    else static if (is(V : string)) return fromBstr(bstrVal);
    else static if (is(V == wchar*)) return bstrVal;
    else static if (is(V : IDispatch)) return cast(V)pdispVal;
    else static if (is(V : IUnknown)) return cast(V)punkVal;
    else static if (is(V == SAFEARRAY*)) return parray;
    else static if (isArray!(V)) return parray.toArray!(typeof(*V))();
    else static if (is(V == VARIANT*)) return pvarVal;
    else static if (is(V : Object)) return cast(V)byref;
    else static if (isPointer!(V)) return cast(V)byref;
    else static if (is(V == byte)) return cVal;
    else static if (is(V == ushort)) return uiVal;
    else static if (is(V == uint)) return ulVal;
    else static if (is(V == ulong)) return ullVal;
    else static if (is(V == DECIMAL)) return decVal;
    else static assert(false, "'" ~ V.stringof ~ "' is not one of the allowed types.");
  }

  /**
   * Determines whether this instance is empty.
   */
  bool isEmpty() {
    return (vt == VT_EMPTY);
  }

  /**
   * Determines whether this instance is _null.
   */
  bool isNull() {
    return (vt == VT_NULL);
  }

  /**
   * Determines whether this instance is Nothing.
   */
  bool isNothing() {
    return (vt == VT_DISPATCH && pdispVal is null)
      || (vt == VT_UNKNOWN && punkVal is null);
  }

  int opCmp(VARIANT that) {
    version(D_Version2) {
      return VarCmp(this, that, GetThreadLocale(), 0) - 1;
    }
    else {
      return VarCmp(*this, that, GetThreadLocale(), 0) - 1;
    }
  }

  bool opEquals(VARIANT that) {
    return opCmp(that) == 0;
  }

  mixin(variant_operator("Cat"));
  mixin(variant_operator("Add"));
  mixin(variant_operator("Sub"));
  mixin(variant_operator("Div"));
  mixin(variant_operator("Mul"));
  mixin(variant_operator("Mod"));
  mixin(variant_operator("And"));
  mixin(variant_operator("Or"));
  mixin(variant_operator("Xor"));

}

VARIANT toVariant(T)(T value, bool autoFree = false) {
  if (!autoFree) {
    return VARIANT(value);
  }
  else return (new class(value) {
    VARIANT var;
    this(T value) { var = VARIANT(value); }
    ~this() { var.clear(); }
  }).var;
}

extern(Windows):

void VariantInit(ref VARIANT pvarg);
int VariantClear(ref VARIANT pvarg);
int VariantCopy(ref VARIANT pvargDest, ref VARIANT pvargSrc);

int VarAdd(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarAnd(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarCat(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarDiv(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarMod(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarMul(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarOr(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarSub(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarXor(ref VARIANT pvarLeft, ref VARIANT pvarRight, out VARIANT pvarResult);
int VarCmp(ref VARIANT pvarLeft, ref VARIANT pvarRight, uint lcid, uint dwFlags);
////////////////////////////////////////////////////
extern(Windows)
{
проц ИницВариант(ref ВАРИАНТ вар){VariantInit(cast(VARIANT) вар);}
цел СотриВариант(ref ВАРИАНТ вар){return cast(цел) VariantClear(cast(VARIANT) вар);}
цел КопируйВариант(ref ВАРИАНТ варгЦель, ref ВАРИАНТ варгИст)
	{
	return cast(цел) VariantCopy(cast(VARIANT) варгЦель, cast(VARIANT) варгИст);
	}

цел СложиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
    {
	return cast(цел) VarAdd(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarAnd(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел СоединиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarCat(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез); 
	}
	
цел ДелиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarDiv(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел УмножьВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMul(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarOr(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ОтнимиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarSub(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел ИИлиВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarXor(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
	
цел СравниВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, бцел lcid, бцел флаги)
	{
	return cast(цел) VarCmp(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(uint) lcid, cast(uint) флаги);
	}

цел МодВар(ref ВАРИАНТ варЛев, ref ВАРИАНТ варПрав, out ВАРИАНТ варРез)
	{
	return cast(цел) VarMod(cast(VARIANT) варЛев, cast(VARIANT) варПрав, cast(VARIANT) варРез);
	}
}
////////////////////////////////////////////////////////////////////////////

enum : ushort {
  VARIANT_NOVALUEPROP        = 0x1,
  VARIANT_ALPHABOOL          = 0x2,
  VARIANT_NOUSEROVERRIDE     = 0x4,
  VARIANT_CALENDAR_HIJRI     = 0x8,
  VARIANT_LOCALBOOL          = 0x10,
  VARIANT_CALENDAR_THAI      = 0x20,
  VARIANT_CALENDAR_GREGORIAN = 0x40,
  VARIANT_USE_NLS            = 0x80
}

int VariantChangeType(ref VARIANT pvargDest, ref VARIANT pvarSrc, ushort wFlags, ushort vt);
int VariantChangeTypeEx(ref VARIANT pvargDest, ref VARIANT pvarSrc, uint lcid, ushort wFlags, ushort vt);
/////////////////////
/*
цел ИзмениТипВарианта(ref ВАРИАНТ 
цел ИзмениТипВариантаДоп(ref ВАРИАНТ 
int VariantChangeType(ref VARIANT pvargDest, ref VARIANT pvarSrc, ushort wFlags, ushort vt);
int VariantChangeTypeEx(ref VARIANT pvargDest, ref VARIANT pvarSrc, uint lcid, ushort wFlags, ushort vt);
*/
/////////////////////////////////////////////

extern(Windows):

alias IUnknown Инкогнито;
interface IUnknown {
  mixin(uuid("00000000-0000-0000-c000-000000000046"));

  int QueryInterface(ref GUID riid, void** ppvObject);
  uint AddRef();
  uint Release();
}

enum : uint {
  CLSCTX_INPROC_SERVER    = 0x1,
  CLSCTX_INPROC_HANDLER   = 0x2,
  CLSCTX_LOCAL_SERVER     = 0x4,
  CLSCTX_INPROC_SERVER16  = 0x8,
  CLSCTX_REMOTE_SERVER    = 0x10,
  CLSCTX_INPROC_HANDLER16 = 0x20,
  CLSCTX_INPROC           = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER,
  CLSCTX_SERVER           = CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER,
  CLSCTX_ALL              = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER
}

int CoCreateInstance(ref GUID rclsid, IUnknown pUnkOuter, uint dwClsContext, ref GUID riid, void** ppv);

int CoGetClassObject(ref GUID rclsid, uint dwClsContext, void* pvReserved, ref GUID riid, void** ppv);
//////////////////////////////
цел СоздайЭкземплярКо(ref ГУИД рклсид, Инкогнито анонВнешн, бцел контекстКл, ref ГУИД риид, ук* ув)
{
return cast(цел) CoCreateInstance(cast(GUID) рклсид, cast(IUnknown) анонВнешн, cast(uint) контекстКл, cast(GUID) риид, cast(void**) ув);
}

цел ДайОбъектКлассаКо(ref ГУИД рклсид, бцел контекстКл, ук резерв, ref ГУИД риид, ук* ув)
{
return cast(цел) CoGetClassObject(cast(GUID) рклсид, cast(uint) контекстКл, cast(void*) резерв, cast(GUID) риид, cast(void**) ув);
}
////////////////////////////////
alias COSERVERINFO КОСЕРВЕРИНФО;
struct COSERVERINFO {
  uint dwReserved1;
  version(D_Version2) {
    mixin("const(wchar)* pwszName;");
  }
  else {
    wchar* pwszName;
  }
  COAUTHINFO* pAutInfo;
  uint dwReserved2;
}

int CoCreateInstanceEx(ref GUID rclsid, IUnknown pUnkOuter, uint dwClsContext, COSERVERINFO* pServerInfo, uint dwCount, MULTI_QI* pResults);
///////////////
цел СоздайЭкземплярКоДоп(ref ГУИД рклсид, Инкогнито анонВнешн, бцел контекстКл, КОСЕРВЕРИНФО* сервИнф, бцел счёт, МУЛЬТИ_ОИ* результы)
{
return cast(цел) CoCreateInstanceEx(cast(GUID) рклсид, cast(IUnknown) анонВнешн, cast(uint) контекстКл, cast(COSERVERINFO*) сервИнф, cast(uint) счёт, cast(MULTI_QI*) результы);
}
///////////////////////

enum {
  CLASS_E_NOAGGREGATION     = 0x80040110,
  CLASS_E_CLASSNOTAVAILABLE = 0x80040111
}

enum {
  SELFREG_E_FIRST   = MAKE_SCODE!(SEVERITY_ERROR, FACILITY_ITF, 0x0200),
  SELFREG_E_LAST    = MAKE_SCODE!(SEVERITY_ERROR, FACILITY_ITF, 0x020F),
  SELFREG_S_FIRST   = MAKE_SCODE!(SEVERITY_SUCCESS, FACILITY_ITF, 0x0200),
  SELFREG_S_LAST    = MAKE_SCODE!(SEVERITY_SUCCESS, FACILITY_ITF, 0x020F),
  SELFREG_E_TYPELIB = SELFREG_E_FIRST,
  SELFREG_E_CLASS   = SELFREG_E_FIRST + 1
}

interface IClassFactory : IUnknown {
  mixin(uuid("00000001-0000-0000-c000-000000000046"));

  int CreateInstance(IUnknown pUnkOuter, ref GUID riid, void** ppvObject);
  int LockServer(int fLock);
}

interface IMalloc : IUnknown {
  mixin(uuid("00000002-0000-0000-c000-000000000046"));

  void* Alloc(size_t cb);
  void* Realloc(void* pv, size_t cb);
  void Free(void* pv);
  size_t GetSize(void* pv);
  int DidAlloc(void* pv);
  void HeapMinimize();
}

int CoGetMalloc(uint dwMemContext/* = 1*/, out IMalloc ppMalloc);

interface IMarshal : IUnknown {
  mixin(uuid("00000003-0000-0000-c000-000000000046"));

  int GetUnmarshalClass(ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags, out GUID pCid);
  int GetMarshalSizeMax(ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags, out uint pSize);
  int MarshalInterface(IStream pStm, ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags);
  int UnmarshalInterface(IStream pStm, ref GUID riid, void** ppv);
  int ReleaseMarshalData(IStream pStm);
  int DisconnectObject(uint dwReserved);
}

interface ISequentialStream : IUnknown {
  mixin(uuid("0c733a30-2a1c-11ce-ade5-00aa0044773d"));

  int Read(void* pv, uint cb, ref uint pcbRead);
  int Write(in void* pv, uint cb, ref uint pcbWritten);
}

enum : uint {
  STGTY_STORAGE = 1,
  STGTY_STREAM = 2,
  STGTY_LOCKBYTES = 3,
  STGTY_PROPERTY = 4
}

enum : uint {
  STREAM_SEEK_SET,
  STREAM_SEEK_CUR,
  STREAM_SEEK_END
}

enum : uint {
  STATFLAG_DEFAULT,
  STATFLAG_NONAME,
  STATFLAG_NOOPEN
}

struct STATSTG {
  wchar* pwcsName;
  uint type;
  ulong cbSize;
  FILETIME mtime;
  FILETIME ctime;
  FILETIME atime;
  uint grfMode;
  uint grfLocksSupported;
  GUID clsid;
  uint grfStateBits;
  uint reserved;
}

interface ILockBytes : IUnknown {
  mixin(uuid("0000000a-0000-0000-c000-000000000046"));

  int ReadAt(ulong ulOffset, void* pv, uint cb, ref uint pcbRead);
  int WriteAt(ulong ulOffset, in void* pv, uint cb, ref uint pcbWritten);
  int Flush();
  int SetSize(ulong cb);
  int LockRegion(ulong libOffset, ulong cb, uint dwLockType);
  int UnlockRegion(ulong libOffset, ulong cb, uint dwLockType);
  int Stat(out STATSTG pstatstg, uint grfStatFlag);
}

enum : uint {
  STGM_DIRECT           = 0x00000000,
  STGM_TRANSACTED       = 0x00010000,
  STGM_SIMPLE           = 0x08000000,
  STGM_READ             = 0x00000000,
  STGM_WRITE            = 0x00000001,
  STGM_READWRITE        = 0x00000002,
  STGM_SHARE_DENY_NONE  = 0x00000040,
  STGM_SHARE_DENY_READ  = 0x00000030,
  STGM_SHARE_DENY_WRITE = 0x00000020,
  STGM_SHARE_EXCLUSIVE  = 0x00000010,
  STGM_CREATE           = 0x00001000
}

int GetHGlobalFromILockBytes(ILockBytes plkbyt, out Handle phglobal);
int CreateILockBytesOnHGlobal(Handle hGlobal, int fDeleteOnRelease, out ILockBytes pplkbyt);
int StgCreateDocfileOnILockBytes(ILockBytes plkbyt, uint grfMode, uint reserved, out IStorage ppstgOpen);

interface IStorage : IUnknown {
  mixin(uuid("0000000b-0000-0000-c000-000000000046"));

  int CreateStream(wchar* pwcsName, uint grfMode, uint reserved1, uint reserved2, out IStream ppstm);
  int OpenStream(wchar* pwcsName, void* reserved1, uint grfMode, uint reserved2, out IStream ppstm);
  int CreateStorage(wchar* pwcsName, uint grfMode, uint reserved1, uint reserved2, out IStorage ppstg);
  int OpenStorage(wchar* pwcsName, IStorage psrgPriority, uint grfMode, wchar** snbExclude, uint reserved, out IStorage ppstg);
  int CopyTo(uint ciidExclude, GUID* rgiidExclude, wchar** snbExclude, IStorage pstgDest);
  int MoveElementTo(wchar* pwcsName, IStorage pstgDest, wchar* pwcsNewName, uint grfFlags);
  int Commit(uint grfCommitFlags);
  int Revert();
  int EnumElements(uint reserved1, void* reserved2, uint reserved3, out IEnumSTATSTG ppenum);
  int DestroyElement(wchar* pwcsName);
  int RenameElement(wchar* pwcsOldName, wchar* pwcsNewName);
  int SetElementTimes(wchar* pwcsName, ref FILETIME pctime, ref FILETIME patime, ref FILETIME pmtime);
  int SetClass(ref GUID clsid);
  int SetStateBits(uint grfStateBits, uint grfMask);
  int Stat(out STATSTG pstatstg, uint grfStatFlag);
}

int ReadClassStg(IStorage pStg, out GUID pclsid);
int WriteClassStg(IStorage pStg, ref GUID rclsid);
int ReadClassStm(IStream pStm, out GUID pclsid);
int WriteClassStm(IStream pStm, ref GUID rclsid);

struct STGOPTIONS {
  ushort usVersion;
  ushort reserved;
  uint ulSectorSize;
  wchar* pwcsTemplateFile;
}

enum : uint {
  STGFMT_STORAGE = 0,
  STGFMT_FILE = 3,
  STGFMT_ANY = 4,
  STGFMT_DOCFILE = 5
}

int StgOpenStorage(in wchar* pwcsName, IStorage pstgPriority, uint grfMode, wchar** snbExclude, uint reserved, out IStorage ppstgOpen);
int StgOpenStorageEx(in wchar* pwcsName, uint grfMode, uint stgfmt, uint grfAttrs, STGOPTIONS* pStgOptions, SECURITY_DESCRIPTOR* pSecurityDescriptor, ref GUID riid, void** ppObjectOpen);

interface IStream : ISequentialStream {
  mixin(uuid("0000000c-0000-0000-c000-000000000046"));

  int Seek(long dlibMove, uint dwOrigin, ref ulong plibNewPosition);
  int SetSize(ulong libNewSize);
  int CopyTo(IStream stm, ulong cb, ref ulong pcbRead, ref ulong pcbWritten);
  int Commit(uint hrfCommitFlags);
  int Revert();
  int LockRegion(ulong libOffset, ulong cb, uint dwLockType);
  int UnlockRegion(ulong libOffset, ulong cb, uint dwLockType);
  int Stat(out STATSTG pstatstg, uint grfStatFlag);
  int Clone(out IStream ppstm);
}

int GetHGlobalFromStream(IStream pstm, out Handle phglobal);
int CreateStreamOnHGlobal(Handle hGlobal, int fDeleteOnRelease, out IStream ppstm);

interface IEnumSTATSTG : IUnknown {
  mixin(uuid("0000000d-0000-0000-c000-000000000046"));

  int Next(uint celt, STATSTG* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumSTATSTG ppenum);
}

enum : uint {
  BIND_MAYBOTHERUSER = 1,
  BIND_JUSTTESTEXISTENCE = 2
}

struct BIND_OPTS {
  uint cbStruct = BIND_OPTS.sizeof;
  uint grfFlags;
  uint grfMode;
  uint dwTickCountDeadline;
}

struct BIND_OPTS2 {
  uint cbStruct = BIND_OPTS2.sizeof;
  uint grfFlags;
  uint grfMode;
  uint dwTickCountDeadline;
  uint dwTrackFlags;
  uint dwClassContext;
  uint locale;
  COSERVERINFO* pServerInfo;
}

interface IBindCtx : IUnknown {
  mixin(uuid("0000000e-0000-0000-c000-000000000046"));

  int RegisterObjectBound(IUnknown punk);
  int RevokeObjectBound(IUnknown punk);
  int ReleaseBoundObjects();
  int SetBindOptions(BIND_OPTS* pbindopts);
  int GetBindOptions(BIND_OPTS* pbindopts);
  int GetRunningObjectTable(out IRunningObjectTable pprot);
  int RegisterObjectParam(wchar* pszKey, IUnknown punk);
  int GetObjectParam(wchar* pszKey, out IUnknown ppunk);
  int EnumObjectParam(out IEnumString ppenum);
  int RemoveObjectParam(wchar* pszKey);
}

int CreateBindCtx(uint reserved, out IBindCtx ppbc);

interface IMoniker : IPersistStream {
  mixin(uuid("0000000f-0000-0000-c000-000000000046"));

  int BindToObject(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riidResult, void** ppvResult);
  int BindToStorage(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riid, void** ppv);
  int Reduce(IBindCtx pbc, uint dwReduceHowFar, ref IMoniker ppmkToLeft, out IMoniker ppmkReduced);
  int ComposeWith(IMoniker pmkRight, bool fOnlyIfNotGeneric, out IMoniker ppmkComposite);
  int Enum(bool fForward, out IEnumMoniker ppenumMoniker);
  int IsEqual(IMoniker pmkOtherMoniker);
  int Hash(out uint pdwHash);
  int IsRunning(IBindCtx pbc, IMoniker pmkToLeft, IMoniker pmkNewlyRunning);
  int GetTimeOfLastChange(IBindCtx pbc, IMoniker pmkToLeft, out FILETIME pFileTime);
  int Inverse(out IMoniker ppmk);
  int CommonPrefixWith(IMoniker pmkOther, out IMoniker ppmkPrefix);
  int RelativePathTo(IMoniker pmkOther, out IMoniker ppmkRelPath);
  int GetDisplayName(IBindCtx pbc, IMoniker pmkToLeft, out wchar* ppszDisplayName);
  int ParseDisplayName(IBindCtx pbc, IMoniker pmkToLeft, wchar* pszDisplayName, out uint pchEaten, out IMoniker ppmkOut);
  int IsSystemMoniker(out uint pswMkSys);
}

int CreateFileMoniker(in wchar* lpszPathName, out IMoniker ppmk);

interface IRunningObjectTable : IUnknown {
  mixin(uuid("00000010-0000-0000-c000-000000000046"));

  int Register(uint grfFlags, IUnknown punkObject, IMoniker pmkObjectName, out uint pdwRegister);
  int Revoke(uint dwRegister);
  int IsRunning(IMoniker pmkObjectName);
  int GetObject(IMoniker pmkObjectName, out IUnknown ppunkObject);
  int NoteChangeTime(uint dwRegister, ref FILETIME pfiletime);
  int GetTimeOfLastChange(IMoniker pmkObjectName, out FILETIME pfiletime);
  int EnumRunning(out IEnumMoniker ppenumMoniker);
}

alias MULTI_QI МУЛЬТИ_ОИ;
struct MULTI_QI {
  version(D_Version2) {
    mixin("const(GUID)* pIID;");
  }
  else {
    GUID* pIID;
  }
  IUnknown pItf;
  int hr;
}

interface IMultiQI : IUnknown {
  mixin(uuid("00000020-0000-0000-c000-000000000046"));

  int QueryMultipleInterfaces(uint cMQIs, MULTI_QI* pMQIs);
}

alias IRecordInfo ИИнфОЗаписи;
interface IRecordInfo : IUnknown {
  mixin(uuid("0000002f-0000-0000-c000-000000000046"));

  int RecordInit(void* pvNew);
  int RecordClear(void* pvExisting);
  int RecordCopy(void* pvExisting, void* pvNew);
  int GetGuid(out GUID pguid);
  int GetName(out wchar* pbstrName);
  int GetSize(out uint pcbSize);
  int GetTypeInfo(out ITypeInfo ppTypeInfo);
  int GetField(void* pvData, wchar* szFieldName, out VARIANT pvarField);
  int GetFieldNoCopy(void* pvData, wchar* szFieldName, out VARIANT pvarField, void** ppvDataCArray);
  int PutField(uint wFlags, void* pvData, wchar* szFieldName, ref VARIANT pvarField);
  int PutFieldNoCopy(uint wFlags, void* pvData, wchar* szFieldName, ref VARIANT pvarField);
  int GetFieldNames(out uint pcNames, wchar** rgBstrNames);
  bool IsMatchingType(IRecordInfo pRecordInfo);
  void* RecordCreate();
  int RecordCreateCopy(void* pvSource, out void* ppvDest);
  int RecordDestroy(void* pvRecord);
}

interface IEnumUnknown : IUnknown {
  mixin(uuid("00000100-0000-0000-c000-000000000046"));

  int Next(uint celt, IUnknown* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumUnknown ppenum);
}

interface IEnumString : IUnknown {
  mixin(uuid("00000101-0000-0000-c000-000000000046"));

  int Next(uint celt, wchar** rgelt, uint* pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumString ppenum);
}

interface IEnumMoniker : IUnknown {
  mixin(uuid("00000102-0000-0000-c000-000000000046"));

  int Next(uint celt, IMoniker* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumMoniker ppenum);
}

struct DVTARGETDEVICE {
  uint tdSize;
  ushort tdDriverNameOffset;
  ushort tdDeviceNameOffset;
  ushort tdPortNameOffset;
  ushort tdExtDevmodeOffset;
  ubyte* tdData;
}

enum DVASPECT : uint {
  DVASPECT_CONTENT = 1,
  DVASPECT_THUMBNAIL = 2,
  DVASPECT_ICON = 4,
  DVASPECT_DOCPRINT = 8
}

enum : uint {
  TYMED_NULL = 0,
  TYMED_HGLOBAL = 1,
  TYMED_FILE = 2,
  TYMED_ISTREAM = 4,
  TYMED_ISTORAGE = 8,
  TYMED_GDI = 16,
  TYMED_MFPICT = 32,
  TYMED_ENHMF = 64
}

struct FORMATETC {
  ushort cfFormat;
  DVTARGETDEVICE* ptd;
  uint dwAspect;
  int lindex;
  uint tymed;
}

enum TYMED : uint {
  TYMED_NULL = 0,
  TYMED_HGLOBAL = 1,
  TYMED_FILE = 2,
  TYMED_ISTREAM = 4,
  TYMED_ISTORAGE = 8,
  TYMED_GDI = 16,
  TYMED_MFPICT = 32,
  TYMED_ENHMF = 64
}

struct STGMEDIUM {
  uint tymed;
  union {
    Handle hBitmap;
    Handle hMetaFilePict;
    Handle hEnhMetaFile;
    Handle hGlobal;
    wchar* lpszFileName;
    IStream pstm;
    IStorage pstg;
  }
  IUnknown pUnkForRelease;
}

interface IEnumFORMATETC : IUnknown {
  mixin(uuid("00000103-0000-0000-c000-000000000046"));

  int Next(uint celt, FORMATETC* rgelt, ref uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumFORMATETC ppenum);
}

struct OLEVERB {
  int lVerb;
  wchar* lpszVerbName;
  uint fuFlags;
  uint grfAttribs;
}

interface IEnumOLEVERB : IUnknown {
  mixin(uuid("00000104-0000-0000-c000-000000000046"));

  int Next(uint celt, OLEVERB* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumOLEVERB ppenum);
}

struct STATDATA {
  FORMATETC formatetc;
  uint advf;
  IAdviseSink pAdvSink;
  uint dwConnection;
}

interface IEnumSTATDATA : IUnknown {
  mixin(uuid("00000105-0000-0000-c000-000000000046"));

  int Next(uint celt, STATDATA* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumSTATDATA ppenum);
}

interface IPersist : IUnknown {
  mixin(uuid("0000010c-0000-0000-c000-000000000046"));

  int GetClassID(out GUID pClassID);
}

interface IPersistStream : IPersist {
  mixin(uuid("00000109-0000-0000-c000-000000000046"));

  int IsDirty();
  int Load(IStream pStm);
  int Save(IStream pStm, int fClearDirty);
  int GetSizeMax(out ulong pcbSize);
}

interface IPersistStreamInit : IPersist {
  mixin(uuid("7FD52380-4E07-101B-AE2D-08002B2EC713"));

  int IsDirty();
  int Load(IStream pStm);
  int Save(IStream pStm, int fClearDirty);
  int GetSizeMax(out ulong pcbSize);
  int InitNew();
}

enum {
  DV_E_FORMATETC = 0x80040064,
  DV_E_DVTARGETDEVICE = 0x80040065,
  DV_E_STGMEDIUM = 0x80040066,
  DV_E_STATDATA = 0x80040067,
  DV_E_LINDEX = 0x80040068,
  DV_E_TYMED = 0x80040069,
  DV_E_CLIPFORMAT = 0x8004006A,
  DV_E_DVASPECT = 0x8004006B
}

interface IDataObject : IUnknown {
  mixin(uuid("0000010e-0000-0000-c000-000000000046"));

  int GetData(ref FORMATETC pformatetcIn, out STGMEDIUM pmedium);
  int GetDataHere(ref FORMATETC pformatetc, ref STGMEDIUM pmedium);
  int QueryGetData(ref FORMATETC pformatetc);
  int GetCanonicalFormatEtc(ref FORMATETC pformatetcIn, out FORMATETC pformatetcOut);
  int SetData(ref FORMATETC pformatetc, ref STGMEDIUM pmedium, int fRelease);
  int EnumFormatEtc(uint dwDirection, out IEnumFORMATETC ppenumFormatEtc);
  int DAdvise(ref FORMATETC pformatetc, uint advf, IAdviseSink pAdvSink, out uint pdwConnection);
  int DUnadvise(uint dwConnection);
  int EnumDAdvise(out IEnumSTATDATA ppenumAdvise);
}

int OleSetClipboard(IDataObject pDataObj);
int OleGetClipboard(out IDataObject ppDataObj);
int OleFlushClipboard();
int OleIsCurrentClipboard(IDataObject pDataObj);

interface IAdviseSink : IUnknown {
  mixin(uuid("0000010f-0000-0000-c000-000000000046"));

  int OnDataChange(ref FORMATETC pFormatetc, ref STGMEDIUM pStgmed);
  int OnViewChange(uint dwAspect, int lindex);
  int OnRename(IMoniker pmk);
  int OnSave();
  int OnClose();
}

enum {
  DRAGDROP_S_DROP = 0x00040100,
  DRAGDROP_S_CANCEL = 0x00040101,
  DRAGDROP_S_USEDEFAULTCURSORS = 0x00040102
}

interface IDropSource : IUnknown {
  mixin(uuid("00000121-0000-0000-c000-000000000046"));

  int QueryContinueDrag(int fEscapePressed, uint grfKeyState);
  int GiveFeedback(uint dwEffect);
}

enum : uint {
  DROPEFFECT_NONE = 0,
  DROPEFFECT_COPY = 1,
  DROPEFFECT_MOVE = 2,
  DROPEFFECT_LINK = 4,
  DROPEFFECT_SCROLL = 0x80000000
}

interface IDropTarget : IUnknown {
  mixin(uuid("00000122-0000-0000-c000-000000000046"));

  int DragEnter(IDataObject pDataObj, uint grfKeyState, POINT pt, ref uint pdwEffect);
  int DragOver(uint grfKeyState, POINT pt, ref uint pdwEffect);
  int DragLeave();
  int Drop(IDataObject pDataObj, uint grfKeyState, POINT pt, ref uint pdwEffect);
}

enum {
  DRAGDROP_E_NOTREGISTERED = 0x80040100,
  DRAGDROP_E_ALREADYREGISTERED = 0x80040101,
  DRAGDROP_E_INVALIDHWND = 0x80040102
}

int RegisterDragDrop(Handle hwnd, IDropTarget pDropTarget);
int RevokeDragDrop(Handle hwnd);
int DoDragDrop(IDataObject pDataObject, IDropSource pDropSource, uint dwOKEffects, out uint pdwEffect);

struct DISPPARAMS {
  VARIANT* rgvarg;
  int* rgdispidNamedArgs;
  uint cArgs;
  uint cNamedArgs;
}

struct EXCEPINFO {
  ushort wCode;
  ushort wReserved;
  wchar* bstrSource;
  wchar* bstrDescription;
  wchar* bstrHelpFile;
  uint dwHelpContext;
  void* pvReserved;
  int function(EXCEPINFO*) pfnDeferredFillIn;
  int scode;
}

enum : ushort {
  DISPATCH_METHOD         = 0x1,
  DISPATCH_PROPERTYGET    = 0x2,
  DISPATCH_PROPERTYPUT    = 0x4,
  DISPATCH_PROPERTYPUTREF = 0x8
}

enum {
  DISPID_UNKNOWN     = -1,
  DISPID_VALUE       = 0,
  DISPID_PROPERTYPUT = -3,
  DISPID_NEWENUM     = -4,
  DISPID_EVALUATE    = -5,
  DISPID_CONSTRUCTOR = -6,
  DISPID_DESTRUCTOR  = -7,
  DISPID_COLLECT     = -8
}

enum {
  DISP_E_UNKNOWNINTERFACE = 0x80020001,
  DISP_E_MEMBERNOTFOUND   = 0x80020003,
  DISP_E_PARAMNOTFOUND    = 0x80020004,
  DISP_E_TYPEMISMATCH     = 0x80020005,
  DISP_E_UNKNOWNNAME      = 0x80020006,
  DISP_E_NONAMEDARGS      = 0x80020007,
  DISP_E_BADVARTYPE       = 0x80020008,
  DISP_E_EXCEPTION        = 0x80020009,
  DISP_E_BADPARAMCOUNT    = 0x8002000E
}

interface IDispatch : IUnknown {
  mixin(uuid("00020400-0000-0000-c000-000000000046"));

  int GetTypeInfoCount(out uint pctinfo);
  int GetTypeInfo(uint iTInfo, uint lcid, out ITypeInfo ppTInfo);
  int GetIDsOfNames(ref GUID riid, wchar** rgszNames, uint cNames, uint lcid, int* rgDispId);
  int Invoke(int dispIdMember, ref GUID riid, uint lcid, ushort wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, uint* puArgError);
}

enum TYPEKIND {
  TKIND_ENUM,
  TKIND_RECORD,
  TKIND_MODULE,
  TKIND_INTERFACE,
  TKIND_DISPATCH,
  TKIND_COCLASS,
  TKIND_ALIAS,
  TKIND_UNION
}

struct TYPEDESC {
  union {
    TYPEDESC* lptdesc;
    ARRAYDESC* lpadesc;
    uint hreftype;
  }
  ushort vt;
}

struct ARRAYDESC {
  TYPEDESC tdescElem;
  ushort cDims;
  SAFEARRAYBOUND[1] rgbounds;
}

struct PARAMDESCEX {
  uint cBytes;
  VARIANT varDefaultValue;
}

struct PARAMDESC {
  PARAMDESCEX* pparamdescex;
  ushort wParamFlags;
}

enum : ushort {
  PARAMFLAG_NONE = 0x0,
  PARAMFLAG_FIN = 0x1,
  PARAMFLAG_FOUT = 0x2,
  PARAMFLAG_FLCID = 0x4,
  PARAMFLAG_FRETVAL = 0x8,
  PARAMFLAG_FOPT = 0x10,
  PARAMFLAG_FHASDEFAULT = 0x20,
  PARAMFLAG_FHASCUSTDATA = 0x40
}

struct IDLDESC {
  uint dwReserved;
  ushort wIDLFlags;
}

struct ELEMDESC {
  TYPEDESC tdesc;
  union {
    IDLDESC idldesc;
    PARAMDESC paramdesc;
  }
}

struct TYPEATTR {
  GUID guid;
  uint lcid;
  uint dwReserved;
  int memidConstructor;
  int memidDestructor;
  wchar* lpstrSchema;
  uint cbSizeInstance;
  TYPEKIND typekind;
  ushort cFuncs;
  ushort cVars;
  ushort cImplTypes;
  ushort cbSizeVft;
  ushort cbAlignment;
  ushort wTypeFlags;
  ushort wMajorVerNum;
  ushort wMinorVerNum;
  TYPEDESC tdescAlias;
  IDLDESC idldescType;
}

enum CALLCONV {
  CC_FASTCALL,
  CC_CDECL,
  CC_MSPASCAL,
  CC_PASCAL = CC_MSPASCAL,
  CC_MACPASCAL,
  CC_STDCALL,
  CC_FPFASTCALL,
  CC_SYSCALL,
  CC_MPWCDECL,
  CC_MPWPASCAL
}

enum FUNCKIND {
  FUNC_VIRTUAL,
  FUNC_PUREVIRTUAL,
  FUNC_NONVIRTUAL,
  FUNC_STATIC,
  FUNC_DISPATCH
}

enum INVOKEKIND {
  INVOKE_FUNC = 1,
  INVOKE_PROPERTYGET = 2,
  INVOKE_PROPERTYPUT = 4,
  INVOKE_PROPERTYPUTREF = 8
}

struct FUNCDESC {
  int memid;
  int* lprgscode;
  ELEMDESC* lprgelemdescParam;
  FUNCKIND funckind;
  INVOKEKIND invkind;
  CALLCONV callconv;
  short cParams;
  short cParamsOpt;
  short oVft;
  short cScodes;
  ELEMDESC elemdescFunc;
  ushort wFuncFlags;
}

enum VARKIND {
  VAR_PERSISTANCE,
  VAR_STATIC,
  VAR_CONST,
  VAR_DISPATCH
}

enum : ushort {
  IMPLTYPEFLAG_FDEFAULT = 0x1,
  IMPLTYPEFLAG_FSOURCE = 0x2,
  IMPLTYPEFLAG_FRESTRICTED = 0x4,
  IMPLTYPEFLAG_FDEFAULTVTABLE = 0x8
}

struct VARDESC {
  int memid;
  wchar* lpstrSchema;
  union {
    uint oInst;
    VARIANT* lpvarValue;
  }
  ELEMDESC elemdescVar;
  ushort wVarFlags;
  VARKIND varkind;
}

enum TYPEFLAGS : ushort {
  TYPEFLAG_FAPPOBJECT = 0x1,
  TYPEFLAG_FCANCREATE = 0x2,
  TYPEFLAG_FLICENSED = 0x4,
  TYPEFLAG_FPREDECLID = 0x8,
  TYPEFLAG_FHIDDEN = 0x10,
  TYPEFLAG_FCONTROL = 0x20,
  TYPEFLAG_FDUAL = 0x40,
  TYPEFLAG_FNONEXTENSIBLE = 0x80,
  TYPEFLAG_FOLEAUTOMATION = 0x100,
  TYPEFLAG_FRESTRICTED = 0x200,
  TYPEFLAG_FAGGREGATABLE = 0x400,
  TYPEFLAG_FREPLACEABLE = 0x800,
  TYPEFLAG_FDISPATCHABLE = 0x1000,
  TYPEFLAG_FREVERSEBIND = 0x2000,
  TYPEFLAG_FPROXY = 0x4000
}

enum FUNCFLAGS : ushort {
  FUNCFLAG_FRESTRICTED = 0x1,
  FUNCFLAG_FSOURCE = 0x2,
  FUNCFLAG_FBINDABLE = 0x4,
  FUNCFLAG_FREQUESTEDIT = 0x8,
  FUNCFLAG_FDISPLAYBIND = 0x10,
  FUNCFLAG_FDEFAULTBIND = 0x20,
  FUNCFLAG_FHIDDEN = 0x40,
  FUNCFLAG_FUSESGETLASTERROR = 0x80,
  FUNCFLAG_FDEFAULTCOLLELEM = 0x100,
  FUNCFLAG_FUIDEFAULT = 0x200,
  FUNCFLAG_FNONBROWSABLE = 0x400,
  FUNCFLAG_FREPLACEABLE = 0x800,
  FUNCFLAG_FIMMEDIATEBIND = 0x1000
}

enum VARFLAGS : ushort {
  VARFLAG_FREADONLY = 0x1,
  VARFLAG_FSOURCE = 0x2,
  VARFLAG_FBINDABLE = 0x4,
  VARFLAG_FREQUESTEDIT = 0x8,
  VARFLAG_FDISPLAYBIND = 0x10,
  VARFLAG_FDEFAULTBIND = 0x20,
  VARFLAG_FHIDDEN = 0x40,
  VARFLAG_FRESTRICTED = 0x80,
  VARFLAG_FDEFAULTCOLLELEM = 0x100,
  VARFLAG_FUIDEFAULT = 0x200,
  VARFLAG_FNONBROWSABLE = 0x400,
  VARFLAG_FREPLACEABLE = 0x800,
  VARFLAG_FIMMEDIATEBIND = 0x1000
}

enum DESCKIND {
  DESCKIND_NONE,
  DESCKIND_FUNCDESC,
  DESCKIND_VARDESC,
  DESCKIND_TYPECOMP,
  DESCKIND_IMPLICITAPPOBJ
}

struct BINDPTR {
  FUNCDESC* lpfuncdesc;
  VARDESC* lpvardesc;
  ITypeComp lptcomp;
}

enum SYSKIND {
  SYS_WIN16,
  SYS_WIN32,
  SYS_MAC,
  SYS_WIN64
}

enum /* LIBFLAGS */ : ushort {
  LIBFLAG_FRESTRICTED = 0x1,
  LIBFLAG_FCONTROL = 0x2,
  LIBFLAG_FHIDDEN = 0x4,
  LIBFLAG_FHASDISKIMAGE = 0x8
}

struct TLIBATTR {
  GUID guid;
  uint lcid;
  SYSKIND syskind;
  ushort wMajorVerNum;
  ushort wMinorVerNum;
  ushort wLibFlags;
}

enum {
  TYPE_E_ELEMENTNOTFOUND      = 0x8002802B
}

interface ITypeInfo : IUnknown {
  mixin(uuid("00020401-0000-0000-c000-000000000046"));

  int GetTypeAttr(out TYPEATTR* ppTypeAttr);
  int GetTypeComp(out ITypeComp ppTComp);
  int GetFuncDesc(uint index, out FUNCDESC* ppFuncDesc);
  int GetVarDesc(uint index, out VARDESC* ppVarDesc);
  int GetNames(int memid, wchar** rgBstrNames, uint cMaxNames, out uint pcNames);
  int GetRefTypeOfImplType(uint index, out uint pRefType);
  int GetImplTypeFlags(uint index, out int pImplTypeFlags);
  int GetIDsOfNames(wchar** rgszNames, uint cNames, int* pMemId);
  int Invoke(void* pvInstance, int memid, ushort wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, uint* puArgErr);
  int GetDocumentation(int memid, wchar** pBstrName, wchar** pBstrDocString, uint* pdwHelpContext, wchar** pBstrHelpFile);
  int GetDllEntry(int memid, INVOKEKIND invKind, wchar** pBstrDllName, wchar** pBstrName, ushort* pwOrdinal);
  int GetRefTypeInfo(uint hRefType, out ITypeInfo ppTInfo);
  int AddressOfMember(int memid, INVOKEKIND invKind, void** ppv);
  int CreateInstance(IUnknown pUnkOuter, ref GUID riid, void** ppvObj);
  int GetMops(int memid, wchar** pBstrMops);
  int GetContainingTypeLib(out ITypeLib ppTLib, out uint pIndex);
  int ReleaseTypeAttr(TYPEATTR* pTypeAttr);
  int ReleaseFuncDesc(FUNCDESC* pFuncDesc);
  int ReleaseVarDesc(VARDESC* pVarDesc);
}

interface ITypeLib : IUnknown {
  mixin(uuid("00020402-0000-0000-c000-000000000046"));

  uint GetTypeInfoCount();
  int GetTypeInfo(uint index, out ITypeInfo ppTInfo);
  int GetTypeInfoType(uint index, out TYPEKIND pTKind);
  int GetTypeInfoOfGuid(ref GUID guid, out ITypeInfo ppTInfo);
  int GetLibAttr(out TLIBATTR* ppTLibAttr);
  int GetTypeComp(out ITypeComp ppTComp);
  int GetDocumentation(int index, wchar** pBstrName, wchar** pBstrDocString, uint* pBstrHelpContext, wchar** pBstrHelpFile);
  int IsName(wchar* szNameBuf, uint lHashVal, out bool pfName);
  int FindName(wchar* szNameBuf, uint lHashVal, ITypeInfo* ppTInfo, int* rgMemId, ref ushort pcFound);
  int ReleaseTLibAttr(TLIBATTR* pTLibAttr);
}

int LoadTypeLib(in wchar* szFile, out ITypeLib pptlib);

enum REGKIND {
  REGKIND_DEFAULT,
  REGKIND_REGISTER,
  REGKIND_NONE
}

int LoadTypeLibEx(in wchar* szFile, REGKIND regkind, out ITypeLib pptlib);
int LoadRegTypeLib(ref GUID rgiud, ushort wVerMajor, ushort wVerMinor, uint lcid, out ITypeLib pptlib);
int QueryPathOfRegTypeLib(ref GUID guid, ushort wVerMajor, ushort wVerMinor, uint lcid, out wchar* lpbstrPathName);
int RegisterTypeLib(ITypeLib ptlib, in wchar* szFullPath, in wchar* szHelpDir);
int UnRegisterTypeLib(ref GUID libID, ushort wVerMajor, ushort wVerMinor, uint lcid, SYSKIND syskind);
int RegisterTypeLibForUser(ITypeLib ptlib, wchar* szFullPath, wchar* szHelpDir);
int UnRegisterTypeLibForUser(ref GUID libID, ushort wVerMajor, ushort wVerMinor, uint lcid, SYSKIND syskind);

interface ITypeComp : IUnknown {
  mixin(uuid("00020403-0000-0000-c000-000000000046"));

  int Bind(wchar* szName, uint lHashVal, ushort wFlags, out ITypeInfo ppTInfo, out DESCKIND pDescKind, out BINDPTR pBindPtr);
  int BindType(wchar* szName, uint lHashVal, out ITypeInfo ppTInfo, out ITypeComp ppTComp);
}

interface IEnumVARIANT : IUnknown {
  mixin(uuid("00020404-0000-0000-c000-000000000046"));

  int Next(uint celt, VARIANT* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumVARIANT ppenum);
}

interface ICreateTypeInfo : IUnknown {
  mixin(uuid("00020405-0000-0000-c000-000000000046"));

  int SetGuid(ref GUID guid);
  int SetTypeFlags(uint uTypeFlags);
  int SetDocString(wchar* szStrDoc);
  int SetHelpContext(uint dwHelpContext);
  int SetVersion(ushort wMajorVerNum, ushort wMinorVerNum);
  int AddRefTypeInfo(ITypeInfo pTInfo, ref uint phRefType);
  int AddFuncDesc(uint index, FUNCDESC* pFuncDesc);
  int AddImplType(uint index, uint hRefType);
  int SetTypeImplFlags(uint index, int implTypeFlags);
  int SetAlignment(ushort cbAlignment);
  int SetSchema(wchar* pStrSchema);
  int AddVarDesc(uint index, VARDESC* pVarDesc);
  int SetFuncAndParamNames(uint index, wchar** rgszNames, uint cNames);
  int SetVarName(uint index, wchar* szName);
  int SetTypeDescAlias(TYPEDESC* pTDescAlias);
  int DefineFuncAsDllEntry(uint index, wchar* szDllName, wchar* szProcName);
  int SetFuncDocString(uint index, wchar* szDocString);
  int SetVarDocString(uint index, wchar* szDocString);
  int SetFuncHelpContext(uint index, uint dwHelpContext);
  int SetVarHelpContext(uint index, uint dwHelpContext);
  int SetMops(uint index, wchar* bstrMops);
  int SetTypeIdldesc(IDLDESC* pIdlDesc);
  int LayOut();
}

interface ICreateTypeLib : IUnknown {
  mixin(uuid("00020406-0000-0000-c000-000000000046"));

  int CreateTypeInfo(wchar* szName, TYPEKIND tkind, out ICreateTypeInfo ppCTInfo);
  int SetName(wchar* szName);
  int SetVersion(ushort wMajorVerNum, ushort wMinorVerNum);
  int SetGuid(ref GUID guid);
  int SetDocString(wchar* szDoc);
  int SetHelpFileName(wchar* szHelpFileName);
  int SetHelpContext(uint dwHelpContext);
  int SetLcid(uint lcid);
  int SetLibFlags(uint uLibFlags);
  int SaveAllChanges();
}

int CreateTypeLib(SYSKIND syskind, in wchar* szFile, out ICreateTypeLib ppctlib);

interface ICreateTypeInfo2 : ICreateTypeInfo {
  mixin(uuid("0002040e-0000-0000-c000-000000000046"));

  int DeleteFuncDesc(uint index);
  int DeleteFuncDescByMemId(int memid, INVOKEKIND invKind);
  int DeleteVarDesc(uint index);
  int DeleteVarDescByMemId(int memid);
  int DeleteImplType(uint index);
  int SetCustData(ref GUID guid, ref VARIANT pVarVal);
  int SetFuncCustData(uint index, ref GUID guid, ref VARIANT pVarVal);
  int SetParamCustData(uint indexFunc, uint indexParam, ref GUID guid, ref VARIANT pVarVal);
  int SetVarCustData(uint index, ref GUID guid, ref VARIANT pVarVal);
  int SetImplTypeCustData(uint index, ref GUID guid, ref VARIANT pVarVal);
  int SetHelpStringContext(uint dwHelpStringContext);
  int SetFuncHelpStringContext(uint index, uint dwHelpStringContext);
  int SetVarHelpStringContext(uint index, uint dwHelpStringContext);
  int Invalidate();
}

interface ICreateTypeLib2 : ICreateTypeLib {
  mixin(uuid("0002040f-0000-0000-c000-000000000046"));

  int DeleteTypeInfo(wchar* szName);
  int SetCustData(ref GUID guid, ref VARIANT pVarVal);
  int SetHelpStringContext(uint dwHelpStringContext);
  int SetHelpStringDll(wchar* szFileName);
}

int CreateTypeLib2(SYSKIND syskind, in wchar* szFile, out ICreateTypeLib2 ppctlib);

enum CHANGEKIND {
  CHANGEKIND_ADDMEMBER,
  CHANGEKIND_DELETEMEMBER,
  CHANGEKIND_SETNAMES,
  CHANGEKIND_SETDOCUMENTATION,
  CHANGEKIND_GENERAL,
  CHANGEKIND_INVALIDATE,
  CHANGEKIND_CHANGEFAILED,
  CHANGEKIND_MAX
}

interface ITypeChangeEvents : IUnknown {
  mixin(uuid("00020410-0000-0000-c000-000000000046"));

  int RequestTypeChange(CHANGEKIND changeKind, ITypeInfo pTInfoBefore, wchar* pStrName, out int pfCancel);
  int AfterTypeChange(CHANGEKIND changeKind, ITypeInfo pTInfoAfter, wchar* pStrName);
}

struct CUSTDATAITEM {
  GUID guid;
  VARIANT varValue;
}

struct CUSTDATA {
  uint cCustData;
  CUSTDATAITEM* prgCustData;
}

interface ITypeLib2 : ITypeLib {
  mixin(uuid("00020411-0000-0000-c000-000000000046"));

  int GetCustData(ref GUID guid, out VARIANT pVarVal);
  int GetLibStatistics(out uint pcUniqueNames, out uint pcchUniqueNames);
  int GetDocumentation2(int index, uint lcid, wchar** pBstrHelpString, uint* pdwHelpContext, wchar** pBstrHelpStringDll);
  int GetAllCustData(out CUSTDATA pCustData);
}

interface ITypeInfo2 : ITypeInfo {
  mixin(uuid("00020412-0000-0000-c000-000000000046"));

  int GetTypeKind(out TYPEKIND pTypeKind);
  int GetTypeFlags(out uint pTypeFlags);
  int GetFuncIndexOfMemId(int memid, INVOKEKIND invKind, out uint pFuncIndex);
  int GetVarIndexOfMemId(int memid, out uint pVarIndex);
  int GetCustData(ref GUID guid, out VARIANT pVarVal);
  int GetFuncCustData(uint index, ref GUID guid, out VARIANT pVarVal);
  int GetParamCustData(uint indexFunc, uint indexParam, ref GUID guid, out VARIANT pVarVal);
  int GetVarCustData(uint index, ref GUID guid, out VARIANT pVarVal);
  int GetImplTypeCustData(uint index, ref GUID guid, out VARIANT pVarVal);
  int GetDocumentation2(int memid, uint lcid, wchar** pBstrHelpString, uint* pdwHelpContext, wchar** pBstrHelpStringDll);
  int GetAllCustData(out CUSTDATA pCustData);
  int GetAllFuncCustData(uint index, out CUSTDATA pCustData);
  int GetAllParamCustData(uint indexFunc, uint indexParam, out CUSTDATA pCustData);
  int GetAllVarCustData(uint index, out CUSTDATA pCustData);
  int GetAllTypeImplCustData(uint index, out CUSTDATA pCustData);
}

interface IEnumGUID : IUnknown {
  mixin(uuid("0002E000-0000-0000-c000-000000000046"));

  int Next(uint celt, GUID* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumGUID ppenum);
}

struct CATEGORYINFO {
  GUID catid;
  uint lcid;
  wchar[128] szDescription;
}

interface IEnumCATEGORYINFO : IUnknown {
  mixin(uuid("0002E011-0000-0000-c000-000000000046"));

  int Next(uint celt, CATEGORYINFO* rgelt, out uint pceltFetched);
  int Skip(uint celt);
  int Reset();
  int Clone(out IEnumGUID ppenum);
}

interface ICatInformation : IUnknown {
  mixin(uuid("0002E013-0000-0000-c000-000000000046"));

  int EnumCategories(uint lcid, out IEnumCATEGORYINFO ppenumCategoryInfo);
  int GetCategoryDesc(inout GUID rcatid, uint lcid, out wchar* pszDesc);
  int EnumClassesOfCategories(uint cImplemented, GUID* rgcatidImpl, uint cRequired, GUID* rgcatidReq, out IEnumGUID ppenumClsid);
  int IsClassOfCategories(inout GUID rclsid, uint cImplemented, GUID* rgcatidImpl, uint cRequired, GUID* rgcatidReq);
  int EnumImplCategoriesOfClass(inout GUID rclsid, out IEnumGUID ppenumCatid);
  int EnumReqCategoriesOfClass(inout GUID rclsid, out IEnumGUID ppenumCatid);
}

abstract final class StdComponentCategoriesMgr {
  mixin(uuid("0002E005-0000-0000-c000-000000000046"));

  mixin Interfaces!(ICatInformation);
}

interface IConnectionPointContainer : IUnknown {
  mixin(uuid("b196b284-bab4-101a-b69c-00aa00341d07"));

  int EnumConnectionPoints(out IEnumConnectionPoints ppEnum);
  int FindConnectionPoint(ref GUID riid, out IConnectionPoint ppCP);
}

interface IEnumConnectionPoints : IUnknown {
  mixin(uuid("b196b285-bab4-101a-b69c-00aa00341d07"));

  int Next(uint cConnections, IConnectionPoint* ppCP, out uint pcFetched);
  int Skip(uint cConnections);
  int Reset();
  int Clone(out IEnumConnectionPoints ppEnum);
}

interface IConnectionPoint : IUnknown {
  mixin(uuid("b196b286-bab4-101a-b69c-00aa00341d07"));

  int GetConnectionInterface(out GUID pIID);
  int GetConnectionPointContainer(out IConnectionPointContainer ppCPC);
  int Advise(IUnknown pUnkSink, out uint pdwCookie);
  int Unadvise(uint dwCookie);
  int EnumConnections(out IEnumConnections ppEnum);
}

struct CONNECTDATA {
  IUnknown pUnk;
  uint dwCookie;
}

interface IEnumConnections : IUnknown {
  mixin(uuid("b196b287-bab4-101a-b69c-00aa00341d07"));

  int Next(uint cConnections, CONNECTDATA* rgcd, out uint pcFetched);
  int Skip(uint cConnections);
  int Reset();
  int Clone(out IEnumConnections ppEnum);
}

interface IErrorInfo : IUnknown {
  mixin(uuid("1cf2b120-547d-101b-8e65-08002b2bd119"));

  int GetGUID(out GUID pGUID);
  int GetSource(out wchar* pBstrSource);
  int GetDescription(out wchar* pBstrDescription);
  int GetHelpFile(out wchar* pBstrHelpFile);
  int GetHelpContext(out uint pdwHelpContext);
}

int SetErrorInfo(uint dwReserved, IErrorInfo perrinfo);
int GetErrorInfo(uint dwReserved, out IErrorInfo pperrinfo);
int CreateErrorInfo(out IErrorInfo pperrinfo);

interface ISupportErrorInfo : IUnknown {
  mixin(uuid("df0b3d60-548f-101b-8e65-08002b2bd119"));

  int InterfaceSupportsErrorInfo(ref GUID riid);
}

struct LICINFO {
  int cbLicInfo = LICINFO.sizeof;
  int fRuntimeKeyAvail;
  int fLicVerified;
}

interface IClassFactory2 : IClassFactory {
  mixin(uuid("b196b28f-bab4-101a-b69c-00aa00341d07"));

  int GetLicInfo(out LICINFO pLicInfo);
  int RequestLicKey(uint dwReserved, out wchar* pBstrKey);
  int CreateInstanceLic(IUnknown pUnkOuter, IUnknown pUnkReserved, ref GUID riid, wchar* bstrKey, void** ppvObj);
}

struct TEXTMETRICOLE {
  int tmHeight;
  int tmAscent;
  int tmDescent;
  int tmInternalLeading;
  int tmExternalLeading;
  int tmAveCharWidth;
  int tmMaxCharWidth;
  int tmWeight;
  int tmOverhang;
  int tmDigitizedAspectX;
  int tmDigitizedAspectY;
  wchar tmFirstChar;
  wchar tmLastChar;
  wchar tmDefaultChar;
  wchar tmBreakChar;
  ubyte tmItalic;
  ubyte tmUnderlined;
  ubyte tmStruckOut;
  ubyte tmPitchAndFamily;
  ubyte tmCharSet;
}

interface IFont : IUnknown {
  mixin(uuid("BEF6E002-A874-101A-8BBA-00AA00300CAB"));

  int get_Name(out wchar* pName);
  int set_Name(wchar* name);
  int get_Size(out long pSize);
  int set_Size(long size);
  int get_Bold(out int pBold);
  int set_Bold(int bold);
  int get_Italic(out int pItalic);
  int set_Italic(int italic);
  int get_Underline(out int pUnderline);
  int set_Underline(int underline);
  int get_Strikethrough(out int pStrikethrough);
  int set_Strikethrough(int strikethrough);
  int get_Weight(out short pWeight);
  int set_Weight(short weight);
  int get_Charset(out short pCharset);
  int set_Charset(short charset);
  int get_hFont(out Handle phFont);
  int Clone(out IFont ppFont);
  int IsEqual(IFont pFontOther);
  int SetRatio(int cyLogical, int cyHimetric);
  int QueryTextMetrics(out TEXTMETRICOLE pTM);
  int AddRefHfont(Handle hFont);
  int ReleaseHfont(Handle hFont);
  int SetHdc(Handle hDC);
}

interface IPicture : IUnknown {
  mixin(uuid("7BF80980-BF32-101A-8BBB-00AA00300CAB"));

  int get_Handle(out uint pHandle);
  int get_hPal(out uint phPal);
  int get_Type(out short pType);
  int get_Width(out int pWidth);
  int get_Height(out int pHeight);
  int Render(Handle hDC, int x, int y, int cx, int cy, int xSrc, int ySrc, int cxSrc, int cySrc, RECT* pRcBounds);
  int set_hPal(uint hPal);
  int get_CurDC(out Handle phDC);
  int SelectPicture(Handle hDCIn, out Handle phDCOut, out uint phBmpOut);
  int get_KeepOriginalFormat(out int pKeep);
  int put_KeepOriginalFormat(int keep);
  int PictureChanged();
  int SaveAsFile(IStream pStream, int fSaveMemCopy, out int pCbSize);
  int get_Attributes(out uint pDwAttr);
}

interface IFontEventsDisp : IDispatch {
  mixin(uuid("4EF6100A-AF88-11D0-9846-00C04FC29993"));
}

interface IFontDisp : IDispatch {
  mixin(uuid("BEF6E003-A874-101A-8BBA-00AA00300CAB"));
}

interface IPictureDisp : IDispatch {
  mixin(uuid("7BF80981-BF32-101A-8BBB-00AA00300CAB"));
}

int OleSetContainedObject(IUnknown pUnknown, int fContained);

enum {
  PICTYPE_UNINITIALIZED = -1,
  PICTYPE_NONE = 0,
  PICTYPE_BITMAP = 1,
  PICTYPE_METAFILE = 2,
  PICTYPE_ICON = 3,
  PICTYPE_ENHMETAFILE = 4
}

struct PICTDESC {
  uint cbSizeofStruct = PICTDESC.sizeof;
  uint picType;
  Handle handle;
}

int OleCreatePictureIndirect(PICTDESC* lpPictDesc, ref GUID riid, int fOwn, void** lplpvObj);
int OleLoadPicture(IStream lpstream, int lSize, int fRunmode, ref GUID riid, void** lplpvObj);

int OleInitialize(void* pvReserved);
void OleUninitialize();

enum : uint {
  COINIT_MULTITHREADED = 0x0,
  COINIT_APARTMENTTHREADED = 0x2,
  COINIT_DISABLE_OLE1DDE = 0x4,
  COINIT_SPEED_OVER_MEMORY = 0x8
}

int CoInitialize(void*);
void CoUninitialize();
int CoInitializeEx(void*, uint dwCoInit);

void* CoTaskMemAlloc(size_t cb);
void* CoTaskMemRealloc(void* pv, size_t cb);
void CoTaskMemFree(void* pv);

enum : uint {
  ACTIVEOBJECT_STRONG,
  ACTIVEOBJECT_WEAK
}

int RegisterActiveObject(IUnknown punk, ref GUID rclsid, uint dwFlags, out uint pdwRegister);
int RevokeActiveObject(uint dwRegister, void* pvReserved);
int GetActiveObject(ref GUID rclsid, void* pvReserved, out IUnknown ppunk);

enum : uint {
  MSHLFLAGS_NORMAL = 0x0,
  MSHLFLAGS_TABLESTRONG = 0x1,
  MSHLFLAGS_TABLEWEAK = 0x2,
  MSHLFLAGS_NOPING = 0x4
}

enum : uint {
  MSHCTX_LOCAL,
  MSHCTX_NOSHAREDMEM,
  MSHCTX_DIFFERENTMACHINE,
  MSHCTX_INPROC,
  MSHCTX_CROSSCTX
}

int CoMarshalInterface(IStream pStm, ref GUID riid, IUnknown pUnk, uint dwDestContext, void* pvDestContext, uint mshlflags);
int CoUnmarshalInterface(IStream pStm, ref GUID riid, void** ppv);

int ProgIDFromCLSID(ref GUID clsid, out wchar* lplpszProgID);
int CLSIDFromProgID(in wchar* lpszProgID, out GUID lpclsid);
int CLSIDFromProgIDEx(in wchar* lpszProgID, out GUID lpclsid);

/*//////////////////////////////////////////////////////////////////////////////////////////
// Helpers                                                                                //
//////////////////////////////////////////////////////////////////////////////////////////*/

extern(D):

package bool isCOMAlive = false;

private void startup() {
  isCOMAlive = SUCCEEDED(CoInitializeEx(null, COINIT_APARTMENTTHREADED));
}

private void shutdown() {
  // Before we shut down COM, give classes a chance to release any COM resources.
  try {
    version(D_Version2) {
      GC.collect();
    }
    else {
      std.gc.fullCollect();
    }
  }
  finally {
    isCOMAlive = false;
    CoUninitialize();
  }
}

/**
 * Specifies whether to throw exceptions or return null when COM operations fail.
 */
enum ExceptionPolicy {
  NoThrow, /// Returns null on failure.
  Throw    /// Throws an exception on failure.
}

template com_cast_impl(T, ExceptionPolicy policy) {

  T com_cast_impl(U)(U obj) {
    static if (is(U : IUnknown)) {
      static if (is(typeof(obj is null))) {
        if (obj is null) {
          static if (policy == ExceptionPolicy.Throw)
            throw new ArgumentNullException("obj");
          else
            return null;
        }
      }
      else static if (is(typeof(obj.isNull))) {
        // com_ref
        if (obj.isNull) {
          static if (policy == ExceptionPolicy.Throw)
            throw new ArgumentNullException("obj");
          else
            return null;
        }
      }

      T result;
      if (SUCCEEDED(obj.QueryInterface(uuidof!(T), retval(result))))
        return result;

      static if (policy == ExceptionPolicy.Throw)
        throw new InvalidCastException("Invalid cast from '" ~ U.stringof ~ "' to '" ~ T.stringof ~ "'.");
      else
        return null;
    }
    else static if (is(U : Object)) {
      if (auto comObj = cast(COMObject)obj)
        return com_cast!(T)(comObj.obj);

      static if (policy == ExceptionPolicy.Throw)
        throw new InvalidCastException("Invalid cast from '" ~ U.stringof ~ "' to '" ~ T.stringof ~ "'.");
      else
        return null;
    }
    else static if (is(U == VARIANT)) {
      const type = VariantType!(T);

      static if (type != VT_VOID) {
        VARIANT temp;
        if (SUCCEEDED(VariantChangeTypeEx(temp, obj, GetThreadLocale(), VARIANT_ALPHABOOL, type))) {
          scope(exit) temp.clear();

          with (temp) {
            static if (type == VT_BOOL) {
              static if (is(T == bool))
                return (boolVal == VARIANT_TRUE) ? true : false;
              else 
                return boolVal;
            }
            else static if (type == VT_UI1) return bVal;
            else static if (type == VT_I1) return cVal;
            else static if (type == VT_UI2) return uiVal;
            else static if (type == VT_I2) return iVal;
            else static if (type == VT_UI4) return ulVal;
            else static if (type == VT_I4) return lVal;
            else static if (type == VT_UI8) return ullVal;
            else static if (type == VT_I8) return llVal;
            else static if (type == VT_R4) return fltVal;
            else static if (type == VT_R8) return dblVal;
            else static if (type == VT_DECIMAL) return decVal;
            else static if (type == VT_BSTR) {
              static if (is(T : string))
                return fromBstr(bstrVal);
              else 
                return bstrVal;
            }
            else static if (type == VT_UNKNOWN) return com_cast_impl(obj.punkVal);
            else static if (type == VT_DISPATCH) return com_cast_impl(obj.pdispVal);
            else return T.init;
          }
        }
        static if (policy == ExceptionPolicy.Throw)
          throw new InvalidCastException("Invalid cast from '" ~ U.stringof ~ "' to '" ~ T.stringof ~ "'.");
        else
          return T.init;
      }
      else static assert(false, "Cannot cast from '" ~ U.stringof ~ "' to '" ~ T.stringof ~ "'.");
    }
    else static assert(false, "Cannot cast from '" ~ U.stringof ~ "' to '" ~ T.stringof ~ "'.");
  }

}

/**
 * Invokes the conversion operation to convert from one COM type to another.
 *
 * If the operand is a VARIANT, this function converts its value to the type represented by $(I T). If the operand is an IUnknown-derived object, this function 
 * calls the object's QueryInterface method. If the conversion operation fails, the function returns T.init.
 *
 * Примеры:
 * ---
 * // C++
 * bool tryToMeow(Dog* dog) {
 *   Cat* cat = NULL;
 *   HRESULT hr = dog->QueryInterface(IID_Cat, static_cast<void**>(&cat));
 *   if (hr == S_OK) {
 *     hr = cat->meow();
 *     cat->Release();
 *   }
 *   return hr == S_OK;
 * }
 *
 * // C#
 * bool tryToMeow(Dog dog) {
 *   Cat cat = dog as Cat;
 *   if (cat != null)
 *     return cat.meow();
 *   return false;
 * }
 *
 * // D
 * bool tryToMeow(Dog dog) {
 *   if (auto cat = com_cast!(Cat)(dog)) {
 *     scope(exit) cat.Release();
 *     return cat.meow() == S_OK;
 *   }
 *   return false;
 * }
 * ---
 */
template com_cast(T) {
  alias com_cast_impl!(T, ExceptionPolicy.NoThrow) com_cast;
}

/// Invokes the conversion operation to convert from one COM type to another, as above, but throws an exception
/// if the cast fails.
/// Выводит исключение: COMException if the cast failed.
template com_safe_cast(T) {
  alias com_cast_impl!(T, ExceptionPolicy.Throw) com_safe_cast;
}

/// Specifies the context in which the code that manages an object will run.
/// See_Also: $(LINK2 http://msdn.microsoft.com/en-us/library/ms693716.aspx, CLSCTX Enumeration).
enum ExecutionContext : uint {
  InProcessServer  = CLSCTX_INPROC_SERVER,  /// The code that creates and manages objects of this class is a DLL that runs in the same process as the caller of the function specifying the class context.
  InProcessHandler = CLSCTX_INPROC_HANDLER, /// The code that manages objects of this class is an in-process handler. is a DLL that runs in the client process and implements client-side structures of this class when instances of the class are accessed remotely.
  LocalServer      = CLSCTX_LOCAL_SERVER,   /// The code that creates and manages objects of this class runs on same machine but is loaded in a separate process space.
  RemoteServer     = CLSCTX_REMOTE_SERVER,  /// A  remote context. The code that creates and manages objects of this class is run on a different computer.
  All              = CLSCTX_ALL
}

/**
 * Creates an object of the class associated with a specified GUID.
 * Параметры:
 *   clsid = The class associated with the object.
 *   outer = If null, indicates that the object is not being created as part of an aggregate.
 *   context = Context in which the code that manages the object will run.
 *   iid = The identifier of the interface to be used to communicate with the object.
 * Возвращает: The requested object.
 * See_Also: $(LINK2 http://msdn.microsoft.com/en-us/library/ms686615.aspx, CoCreateInstance).
 */
IUnknown coCreateInstance(Guid clsid, IUnknown outer, ExecutionContext context, Guid iid) {
  IUnknown ret;
  if (SUCCEEDED(CoCreateInstance(clsid, outer, cast(uint)context, iid, retval(ret))))
    return ret;
  return null;
}

/**
 * Returns a reference to a running object that has been registered with OLE.
 * See_Also: $(LINK2 http://msdn2.microsoft.com/en-us/library/ms221467.aspx, GetActiveObject).
 */
IUnknown getActiveObject(string progId) {
  GUID clsid = clsidFromProgId(progId);
  IUnknown obj = null;
  if (SUCCEEDED(GetActiveObject(clsid, null, obj)))
    return obj;

  return null;
}

/**
 * Creates a COM object of the class associated with the specified CLSID.
 * Параметры:
 *   clsid = A CLSID associated with the coclass that will be used to create the object.
 *   context = The _context in which to run the code that manages the new object with run.
 * Возвращает: A reference to the interface identified by T.
 * Примеры:
 * ---
 * if (auto doc = coCreate!(IXMLDOMDocument3)(uuidof!(DOMDocument60))) {
 *   scope(exit) doc.Release();
 * }
 * ---
 */
template coCreate(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow) {

  T coCreate(U)(U clsid, ExecutionContext context = ExecutionContext.InProcessServer) {
    GUID guid;
    static if (is(U : GUID)) {
      guid = clsid;
    }
    else static if (is(U : string)) {
      try {
        guid = GUID(clsid);
      }
      catch (FormatException) {
        int hr = CLSIDFromProgID(std.utf.toUTF16z(clsid), guid);
        if (FAILED(hr)) {
          static if (policy == ExceptionPolicy.Throw)
            throw new COMException(hr);
          else
            return null;
        }
      }
    }
    else static assert(false);

    T ret;
    int hr = CoCreateInstance(guid, null, context, uuidof!(T), retval(ret));

    if (FAILED(hr)) {
      static if (policy == ExceptionPolicy.Throw)
        throw new COMException(hr);
      else
        return null;
    }

    return ret;
  }

}

template coCreateEx(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow) {

  T coCreateEx(U)(U clsid, string server, ExecutionContext context = ExecutionContext.InProcessServer) {
    GUID guid;
    static if (is(U : GUID)) {
      guid = clsid;
    }
    else static if (is(U : string)) {
      try {
        guid = GUID(clsid);
      }
      catch (FormatException) {
        int hr = CLSIDFromProgID(std.utf.toUTF16z(clsid), guid);
        if (FAILED(hr)) {
          static if (policy == ExceptionPolicy.Throw)
            throw new COMException(hr);
          else
            return null;
        }
      }
    }

    COSERVERINFO csi;
    csi.pwszName = server.toUTF16z();

    MULTI_QI ret;
    ret.pIID = &uuidof!(T);
    int hr = CoCreateInstanceEx(guid, null, context, &csi, 1, &ret);

    if (FAILED(hr)) {
      static if (policy == ExceptionPolicy.Throw)
        throw new COMException(hr);
      else
        return null;
    }

    return cast(T)ret.pItf;
  }

}

template Interfaces(TList...) {

  static T coCreate(T, ExceptionPolicy policy = ExceptionPolicy.NoThrow)(ExecutionContext context = ExecutionContext.InProcessServer) {
    static if (std.typetuple.IndexOf!(T, TList) == -1)
      static assert(false, "'" ~ typeof(this).stringof ~ "' does not support '" ~ T.stringof ~ "'.");
    else
      return .coCreate!(T, policy)(uuidof!(typeof(this)), context);
  }

}

template QueryInterfaceImpl(TList...) {

  extern(Windows)
  int QueryInterface(ref GUID riid, void** ppvObject) {
    if (ppvObject is null)
      return E_POINTER;

    *ppvObject = null;

    if (riid == uuidof!(IUnknown)) {
      *ppvObject = cast(void*)cast(IUnknown)this;
    }
    else foreach (T; TList) {
      // Search the specified list of types to see if we support the interface we're being asked for.
      if (riid == uuidof!(T)) {
        // This is the one, so we need look no further.
        *ppvObject = cast(void*)cast(T)this;
        break;
      }
    }

    if (*ppvObject is null)
      return E_NOINTERFACE;

    (cast(IUnknown)this).AddRef();
    return S_OK;
  }

}

// Implements AddRef & Release for IUnknown subclasses.
template ReferenceCountImpl() {

  private int refCount_ = 1;
  private bool finalized_;

  extern(Windows):

  uint AddRef() {
    return InterlockedIncrement(refCount_);
  }

  uint Release() {
    if (InterlockedDecrement(refCount_) == 0) {
      if (!finalized_) {
        finalized_ = true;
        runFinalizer(this);
      }

      version(D_Version2) {
        core.memory.GC.removeRange(cast(void*)this);
        core.memory.GC.free(cast(void*)this);
      }
      else {
        std.gc.removeRange(cast(void*)this);
        std.c.free(cast(void*)this);
      }
    }
    return refCount_;
  }

  extern(D):

  // IUnknown subclasses must manage their memory manually.
  new(size_t sz) {
    void* p = std.c.malloc(sz);
    if (p is null)
      throw new OutOfMemoryException;

    version(D_Version2) {
      core.memory.GC.addRange(p, sz);
    }
    else {
      std.gc.addRange(p, p + sz);
    }
    return p;
  }

}

template InterfacesTuple(T) {

  static if (is(T == Object)) {
    alias TypeTuple!() InterfacesTuple;
  }
  static if (is(BaseTypeTuple!(T)[0] == Object)) {
    alias TypeTuple!(BaseTypeTuple!(T)[1 .. $]) InterfacesTuple;
  }
  else {
    alias std.typetuple.NoDuplicates!(
      TypeTuple!(BaseTypeTuple!(T)[1 .. $], 
        InterfacesTuple!(BaseTypeTuple!(T)[0]))) 
      InterfacesTuple;
  }

}

/// Provides an implementation of IUnknown suitable for using as mixin.
template IUnknownImpl(T...) {

  static if (is(T[0] : Object))
    mixin QueryInterfaceImpl!(InterfacesTuple!(T[0]), T[1 .. $]);
  else
    mixin QueryInterfaceImpl!(T);
  mixin ReferenceCountImpl;

}

/// Provides an implementation of IDispatch suitable for using as mixin.
template IDispatchImpl(T...) {

  mixin IUnknownImpl!(T);

  int GetTypeInfoCount(out uint pctinfo) {
    pctinfo = 0;
    return E_NOTIMPL;
  }

  int GetTypeInfo(uint iTInfo, uint lcid, out ITypeInfo ppTInfo) {
    ppTInfo = null;
    return E_NOTIMPL;
  }

  int GetIDsOfNames(ref GUID riid, wchar** rgszNames, uint cNames, uint lcid, int* rgDispId) {
    rgDispId = null;
    return E_NOTIMPL;
  }

  int Invoke(int dispIdMember, ref GUID riid, uint lcid, ushort wFlags, DISPPARAMS* pDispParams, VARIANT* pVarResult, EXCEPINFO* pExcepInfo, uint* puArgError) {
    return DISP_E_UNKNOWNNAME;
  }

}

template AllBaseTypesOfImpl(T...) {

  static if (T.length == 0)
    alias TypeTuple!() AllBaseTypesOfImpl;
  else
    alias TypeTuple!(T[0],
      AllBaseTypesOfImpl!(std.traits.BaseTypeTuple!(T[0])),
        AllBaseTypesOfImpl!(T[1 .. $]))
    AllBaseTypesOfImpl;

}

template AllBaseTypesOf(T...) {

  alias NoDuplicates!(AllBaseTypesOfImpl!(T)) AllBaseTypesOf;

}

/**
 * The abstract base class for COM objects that derive from IUnknown or IDispatch.
 *
 * The Implements class provides default implementations of methods required by those interfaces. Therefore, subclasses need only override them when they 
 * specifically need to provide extra functionality. This class also overrides the new operator so that instances are not garbage collected.
 * Примеры:
 * ---
 * class MyImpl : Implements!(IUnknown) {
 * }
 * ---
 */
abstract class Implements(T...) : T {

  static if (IndexOf!(IDispatch, AllBaseTypesOf!(T)) != -1)
    mixin IDispatchImpl!(T, AllBaseTypesOf!(T));
  else
    mixin IUnknownImpl!(T, AllBaseTypesOf!(T));

}

// DMD prevents destructors from running on COM objects.
void runFinalizer(Object obj) {
  if (obj) {
    ClassInfo** ci = cast(ClassInfo**)cast(void*)obj;
    if (*ci) {
      if (auto c = **ci) {
        do {
          if (c.destructor) {
            auto finalizer = cast(void function(Object))c.destructor;
            finalizer(obj);
          }
          c = c.base;
        } while (c);
      }
    }
  }
}

/**
 * Indicates whether the specified object represents a COM object.
 * Параметры: obj = The object to check.
 * Возвращает: true if obj is a COM type; otherwise, false.
 */
bool isCOMObject(Object obj) {
  ClassInfo** ci = cast(ClassInfo**)cast(void*)obj;
  if (*ci !is null) {
    ClassInfo c = **ci;
    if (c !is null)
      return ((c.flags & 1) != 0);
  }
  return false;
}

/**
 * Wraps a manually reference counted IUnknown-derived object so that its 
 * memory can be managed automatically by the D runtime's garbage collector.
 */
final class COMObject {

  private IUnknown obj_;

  /**
   * Initializes a new instance with the specified IUnknown-derived object.
   * Параметры: obj = The object to wrap.
   */
  this(IUnknown obj) {
    obj_ = obj;
  }

  ~this() {
    if (obj_ !is null) {
      finalRelease(obj_);
      obj_ = null;
    }
  }

  /**
   * Retrieves the original IUnknown-derived object.
   * Возвращает: The wrapped object.
   */
  IUnknown opCast() {
    return obj_;
  }

}

// Deprecate? You should really use the scope(exit) pattern.
/**
 */
void releaseAfter(IUnknown obj, void delegate() block) {
  try {
    block();
  }
  finally {
    if (obj)
      obj.Release();
  }
}

// Deprecate? You should really use the scope(exit) pattern.
/**
 */
void clearAfter(VARIANT var, void delegate() block) {
  try {
    block();
  }
  finally {
    var.clear();
  }
}

/**
 * Decrements the reference count for an object.
 */
void tryRelease(IUnknown obj) {
  if (obj) {
    try {
      obj.Release();
    }
    catch {
    }
  }
}

/**
 * Decrements the reference count for an object until it reaches 0.
 */
void finalRelease(IUnknown obj) {
  if (obj) {
    while (obj.Release() > 0) {
    }
  }
}

/**
 * Allocates a BSTR equivalent to s.
 * Параметры: s = The string with which to initialize the BSTR.
 * Возвращает: The BSTR equivalent to s.
 */
wchar* toBstr(string s) {
  if (s == null)
    return null;

  return SysAllocString(std.utf.toUTF16z(s));
}

/**
 * Converts a BSTR to a string, optionally freeing the original BSTR.
 * Параметры: bstr = The BSTR to convert.
 * Возвращает: A string equivalent to bstr.
 */
string fromBstr(wchar* s, bool free = true) {
  if (s == null)
    return null;

  uint len = SysStringLen(s);
  if (len == 0)
    return null;

  string ret = std.utf.toUTF8(s[0 .. len]);
  /*int cb = WideCharToMultiByte(CP_UTF8, 0, s, len, null, 0, null, null);
  char[] ret = new char[cb];
  WideCharToMultiByte(CP_UTF8, 0, s, len, ret.ptr, cb, null, null);*/

  if (free)
    SysFreeString(s);
  return cast(string)ret;
}


/**
 * Frees the memory occupied by the specified BSTR.
 * Параметры: bstr = The BSTR to free.
 */
void freeBstr(wchar* s) {
  if (s != null)
    SysFreeString(s);
}

uint bstrLength(wchar* s) {
  if (s == null)
    return 0;
  return SysStringLen(s);
}

extern(Windows):

wchar* SysAllocString(in wchar* psz);
int SysReAllocString(wchar*, in wchar* psz);
wchar* SysAllocStringLen(in wchar* psz, uint len);
int SysReAllocStringLen(wchar*, in wchar* psz, uint len);
void SysFreeString(wchar*);
uint SysStringLen(wchar*);
uint SysStringByteLen(wchar*);
wchar* SysAllocStringByteLen(in ubyte* psz, uint len);

extern(D):

/**
 * Provides an implementation of the IStream interface.
 */
class COMStream : Implements!(IStream) {

  private Stream stream_;

  this(Stream stream) {
    if (stream is null)
      throw new ArgumentNullException("stream");
    stream_ = stream;
  }

  Stream baseStream() {
    return stream_;
  }

  int Read(void* pv, uint cb, ref uint pcbRead) {
    uint ret = stream_.readBlock(pv, cb);
    if (&pcbRead)
      pcbRead = ret;
    return S_OK;
  }

  int Write(in void* pv, uint cb, ref uint pcbWritten) {
    uint ret = stream_.writeBlock(pv, cb);
    if (&pcbWritten)
      pcbWritten = ret;
    return S_OK;
  }

  int Seek(long dlibMove, uint dwOrigin, ref ulong plibNewPosition) {
    SeekPos whence;
    if (dwOrigin == STREAM_SEEK_SET)
      whence = SeekPos.Set;
    else if (dwOrigin == STREAM_SEEK_CUR)
      whence = SeekPos.Current;
    else if (dwOrigin == STREAM_SEEK_END)
      whence = SeekPos.End;

    ulong ret = stream_.seek(dlibMove, whence);
    if (&plibNewPosition)
      plibNewPosition = ret;
    return S_OK;
  }

  int SetSize(ulong libNewSize) {
    return E_NOTIMPL;
  }

  int CopyTo(IStream stream, ulong cb, ref ulong pcbRead, ref ulong pcbWritten) {
    if (&pcbRead)
      pcbRead = 0;
    if (&pcbWritten)
      pcbWritten = 0;
    return E_NOTIMPL;
  }

  int Commit(uint hrfCommitFlags) {
    return E_NOTIMPL;
  }

  int Revert() {
    return E_NOTIMPL;
  }

  int LockRegion(ulong libOffset, ulong cb, uint dwLockType) {
    return E_NOTIMPL;
  }

  int UnlockRegion(ulong libOffset, ulong cb, uint dwLockType) {
    return E_NOTIMPL;
  }

  int Stat(out STATSTG pstatstg, uint grfStatFlag) {
    pstatstg.type = STGTY_STREAM;
    pstatstg.cbSize = stream_.size;
    return S_OK;
  }

  int Clone(out IStream ppstm) {
    ppstm = null;
    return E_NOTIMPL;
  }

}

/// Specifies the type of member to that is to be invoked.
enum DispatchFlags : ushort {
  InvokeMethod   = DISPATCH_METHOD,         /// Specifies that a method is to be invoked.
  GetProperty    = DISPATCH_PROPERTYGET,    /// Specifies that the value of a property should be returned.
  PutProperty    = DISPATCH_PROPERTYPUT,    /// Specifies that the value of a property should be set.
  PutRefProperty = DISPATCH_PROPERTYPUTREF  /// Specifies that the value of a property should be set by reference.
}

/// The exception thrown when there is an attempt to dynamically access a member that does not exist.
class MissingMemberException : Exception {

  private const string E_MISSINGMEMBER = "Member not found.";

  this() {
    super(E_MISSINGMEMBER);
  }

  this(string message) {
    super(message);
  }

  this(string className, string memberName) {
    super("Member '" ~ className ~ "." ~ memberName ~ "' not found.");
  }

}

/**
 * Invokes the specified member on the specified object.
 * Параметры:
 *   dispId = The identifier of the method or property member to invoke.
 *   flags = The type of member to invoke.
 *   target = The object on which to invoke the specified member.
 *   args = A list containing the arguments to pass to the member to invoke.
 * Возвращает: The return value of the invoked member.
 * Выводит исключение: COMException if the call failed.
 */
VARIANT invokeMemberById(int dispId, DispatchFlags flags, IDispatch target, VARIANT[] args...) {
  args.reverse;

  DISPPARAMS params;
  if (args.length > 0) {
    params.rgvarg = args.ptr;
    params.cArgs = args.length;

    if (flags & DispatchFlags.PutProperty) {
      int dispIdNamed = DISPID_PROPERTYPUT;
      params.rgdispidNamedArgs = &dispIdNamed;
      params.cNamedArgs = 1;
    }
  }

  VARIANT result;
  EXCEPINFO excep;
  int hr = target.Invoke(dispId, GUID.empty, GetThreadLocale(), cast(ushort)flags, &params, &result, &excep, null);

  for (auto i = 0; i < params.cArgs; i++) {
    params.rgvarg[i].clear();
  }

  string errorMessage;
  if (hr == DISP_E_EXCEPTION && excep.scode != 0) {
    errorMessage = fromBstr(excep.bstrDescription);
    hr = excep.scode;
  }

  switch (hr) {
    case S_OK, S_FALSE, E_ABORT:
      return result;
    default:
      if (auto supportErrorInfo = com_cast!(ISupportErrorInfo)(target)) {
        scope(exit) supportErrorInfo.Release();

        if (SUCCEEDED(supportErrorInfo.InterfaceSupportsErrorInfo(uuidof!(IDispatch)))) {
          IErrorInfo errorInfo;
          GetErrorInfo(0, errorInfo);
          if (errorInfo !is null) {
            scope(exit) errorInfo.Release();

            wchar* bstrDesc;
            if (SUCCEEDED(errorInfo.GetDescription(bstrDesc)))
              errorMessage = fromBstr(bstrDesc);
          }
        }
      }
      else if (errorMessage == null) {
        wchar[256] buffer;
        uint r = FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, null, hr, 0, buffer.ptr, buffer.length + 1, null);
        if (r != 0)
          errorMessage = .toUTF8(buffer[0 .. r]);
        else
          errorMessage = std.string.format("Operation 0x%08X did not succeed (0x%08X)", dispId, hr);
      }

      throw new COMException(errorMessage, hr);
  }

  /*if (FAILED(hr)) {
    throw new COMException(fromBstr(excep.bstrDescription), hr);
  }*/

  //return result;
}

/**
 * Invokes the specified member on the specified object.
 * Параметры:
 *   name = The _name of the method or property member to invoke.
 *   flags = The type of member to invoke.
 *   target = The object on which to invoke the specified member.
 *   args = A list containing the arguments to pass to the member to invoke.
 * Возвращает: The return value of the invoked member.
 * Выводит исключение: MissingMemberException if the member is not found.
 */
VARIANT invokeMember(string name, DispatchFlags flags, IDispatch target, VARIANT[] args...) {
  int dispId = DISPID_UNKNOWN;
  wchar* bstrName = name.toBstr();
  scope(exit) freeBstr(bstrName);

  if (SUCCEEDED(target.GetIDsOfNames(GUID.empty, &bstrName, 1, GetThreadLocale(), &dispId)) && dispId != DISPID_UNKNOWN) {
    return invokeMemberById(dispId, flags, target, args);
  }

  string typeName;
  ITypeInfo typeInfo;
  if (SUCCEEDED(target.GetTypeInfo(0, 0, typeInfo))) {
    scope(exit) tryRelease(typeInfo);

    wchar* bstrTypeName;
    typeInfo.GetDocumentation(-1, &bstrTypeName, null, null, null);
    typeName = fromBstr(bstrTypeName);
  }

  throw new MissingMemberException(typeName, name);
}

private VARIANT[] argsToVariantList(TypeInfo[] types, va_list argptr) {
  VARIANT[] list;

  foreach (type; types) {
    if (type == typeid(bool)) list ~= VARIANT(va_arg!(bool)(argptr));
    else if (type == typeid(ubyte)) list ~= VARIANT(va_arg!(ubyte)(argptr));
    else if (type == typeid(byte)) list ~= VARIANT(va_arg!(byte)(argptr));
    else if (type == typeid(ushort)) list ~= VARIANT(va_arg!(ushort)(argptr));
    else if (type == typeid(short)) list ~= VARIANT(va_arg!(short)(argptr));
    else if (type == typeid(uint)) list ~= VARIANT(va_arg!(uint)(argptr));
    else if (type == typeid(int)) list ~= VARIANT(va_arg!(int)(argptr));
    else if (type == typeid(ulong)) list ~= VARIANT(va_arg!(ulong)(argptr));
    else if (type == typeid(long)) list ~= VARIANT(va_arg!(long)(argptr));
    else if (type == typeid(float)) list ~= VARIANT(va_arg!(float)(argptr));
    else if (type == typeid(double)) list ~= VARIANT(va_arg!(double)(argptr));
    else if (type == typeid(string)) list ~= VARIANT(va_arg!(string)(argptr));
    else if (type == typeid(IDispatch)) list ~= VARIANT(va_arg!(IDispatch)(argptr));
    else if (type == typeid(IUnknown)) list ~= VARIANT(va_arg!(IUnknown)(argptr));
    else if (type == typeid(VARIANT)) list ~= va_arg!(VARIANT)(argptr);
    //else if (type == typeid(VARIANT*)) list ~= VARIANT(va_arg!(VARIANT*)(argptr));
    else if (type == typeid(VARIANT*)) list ~= *va_arg!(VARIANT*)(argptr);
  }

  return list;
}

private void fixArgs(ref TypeInfo[] args, ref va_list argptr) {
  if (args[0] == typeid(TypeInfo[]) && args[1] == typeid(va_list)) {
    args = va_arg!(TypeInfo[])(argptr);
    argptr = *cast(va_list*)(argptr);
  }
}

/**
 * Invokes the specified method on the specified object.
 * Параметры:
 *   target = The object on which to invoke the specified method.
 *   name = The _name of the method to invoke.
 *   _argptr = A list containing the arguments to pass to the method to invoke.
 * Возвращает: The return value of the invoked method.
 * Выводит исключение: MissingMemberException if the method is not found.
 * Примеры:
 * ---
 * import os.win.com.core;
 *
 * void main() {
 *   auto ieApp = coCreate!(IDispatch)("InternetExplorer.Application");
 *   invokeMethod(ieApp, "Navigate", "http://www.amazon.co.uk");
 * }
 * ---
 */
R invokeMethod(R = VARIANT)(IDispatch target, string name, ...) {
  auto args = _arguments;
  auto argptr = _argptr;
  if (args.length == 2) fixArgs(args, argptr);

  VARIANT ret = invokeMember(name, DispatchFlags.InvokeMethod, target, argsToVariantList(args, argptr));
  static if (is(R == VARIANT)) {
    return ret;
  }
  else {
    return com_cast!(R)(ret);
  }
}

/**
 * Gets the value of the specified property on the specified object.
 * Параметры:
 *   target = The object on which to invoke the specified property.
 *   name = The _name of the property to invoke.
 *   _argptr = A list containing the arguments to pass to the property.
 * Возвращает: The return value of the invoked property.
 * Выводит исключение: MissingMemberException if the property is not found.
 * Примеры:
 * ---
 * import os.win.com.core, std.io;
 *
 * void main() {
 *   // Create an instance of the Microsoft Word automation object.
 *   IDispatch wordApp = coCreate!(IDispatch)("Word.Application");
 *
 *   // Invoke the Documents property 
 *   //   wordApp.Documents
 *   IDispatch documents = getProperty!(IDispatch)(target, "Documents");
 *
 *   // Invoke the Count property on the Documents object
 *   //   documents.Count
 *   VARIANT count = getProperty(documents, "Count");
 *
 *   // Display the value of the Count property.
 *   writefln("There are %s documents", count);
 * }
 * ---
 */
R getProperty(R = VARIANT)(IDispatch target, string name, ...) {
  auto args = _arguments;
  auto argptr = _argptr;
  if (args.length == 2) fixArgs(args, argptr);

  VARIANT ret = invokeMember(name, DispatchFlags.GetProperty, target, argsToVariantList(args, argptr));
  static if (is(R == VARIANT))
    return ret;
  else
    return com_cast!(R)(ret);
}

/**
 * Sets the value of a specified property on the specified object.
 * Параметры:
 *   target = The object on which to invoke the specified property.
 *   name = The _name of the property to invoke.
 *   _argptr = A list containing the arguments to pass to the property.
 * Выводит исключение: MissingMemberException if the property is not found.
 * Примеры:
 * ---
 * import os.win.com.core;
 *
 * void main() {
 *   // Create an Excel automation object.
 *   IDispatch excelApp = coCreate!(IDispatch)("Excel.Application");
 *
 *   // Set the Visible property to true
 *   //   excelApp.Visible = true
 *   setProperty(excelApp, "Visible", true);
 *
 *   // Get the Workbooks property
 *   //   workbooks = excelApp.Workbooks
 *   IDispatch workbooks = getProperty!(IDispatch)(excelApp, "Workbooks");
 *
 *   // Invoke the Add method on the Workbooks property
 *   //   newWorkbook = workbooks.Add()
 *   IDispatch newWorkbook = invokeMethod!(IDispatch)(workbooks, "Add");
 *
 *   // Get the Worksheets property and the Worksheet at index 1
 *   //   worksheet = excelApp.Worksheets[1]
 *   IDispatch worksheet = getProperty!(IDispatch)(excelApp, "Worksheets", 1);
 *
 *   // Get the Cells property and set the Cell object at column 5, row 3 to a string
 *   //   worksheet.Cells[5, 3] = "data"
 *   setProperty(worksheet, "Cells", 5, 3, "data");
 * }
 * ---
 */
void setProperty(IDispatch target, string name, ...) {
  auto args = _arguments;
  auto argptr = _argptr;
  if (args.length == 2) fixArgs(args, argptr);

  if (args.length > 1) {
    VARIANT v = invokeMember(name, DispatchFlags.GetProperty, target);
    if (auto indexer = v.pdispVal) {
      scope(exit) indexer.Release();

      v = invokeMemberById(0, DispatchFlags.GetProperty, indexer, argsToVariantList(args[0 .. 1], argptr));
      if (auto value = v.pdispVal) {
        scope(exit) value.Release();

        invokeMemberById(0, DispatchFlags.PutProperty, value, argsToVariantList(args[1 .. $], argptr + args[0].tsize));
        return;
      }
    }
  }
  else {
    invokeMember(name, DispatchFlags.PutProperty, target, argsToVariantList(args, argptr));
  }
}

/// ditto
void setRefProperty(IDispatch target, string name, ...) {
  auto args = _arguments;
  auto argptr = _argptr;
  if (args.length == 2) fixArgs(args, argptr);

  invokeMember(name, DispatchFlags.PutRefProperty, target, argsToVariantList(args, argptr));
}

version(D_Version2)
mixin("
struct com_ref(T) if (is(T : IUnknown)) {

  T obj_;

  alias obj_ this;

  this(U)(U obj) {
    obj_ = cast(T)obj;
  }

  ~this() {
    release();
    obj_ = null;
  }

  void opAssign(IUnknown obj) {
    release();
    obj_ = cast(T)obj;
    addRef();
  }

  static com_ref opCall(U)(U obj) {
    return com_ref(obj);
  }

  void addRef() {
    if (obj_ !is null)
      obj_.AddRef();
  }

  void release() {
    if (obj_ !is null) {
      try {
        if (obj_.Release() == 0)
          obj_ = null;
      }
      catch {
      }
    }
  }

  bool isNull() {
    return (obj_ is null);
  }

}
");