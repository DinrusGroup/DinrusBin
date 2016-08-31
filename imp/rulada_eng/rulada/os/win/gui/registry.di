// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


// Not actually part of forms, but is handy.

///
module os.win.gui.registry;

private import os.win.gui.x.dlib;

private import os.win.gui.x.winapi, os.win.gui.base, os.win.gui.x.utf;


class DflRegistryException: DflException // package
{
	this(Dstring msg, int errorCode = 0);
	
	int errorCode;
}


///
class Registry // docmain
{
	private this() {}
	
	
	static:
	
	///
	RegistryKey classesRoot();
	/// ditto
	RegistryKey currentConfig() ;
	/// ditto
	RegistryKey currentUser() ;
	/// ditto
	RegistryKey dynData() ;
	/// ditto
	RegistryKey localMachine();
	/// ditto
	RegistryKey performanceData() ;
	/// ditto
	RegistryKey users() ;
	
	private:
	RegistryKey _classesRoot;
	RegistryKey _currentConfig;
	RegistryKey _currentUser;
	RegistryKey _dynData;
	RegistryKey _localMachine;
	RegistryKey _performanceData;
	RegistryKey _users;
	
	
	/+
	static this();
	+/
}


private const uint MAX_REG_BUFFER = 256;


///
abstract class RegistryValue
{
	DWORD valueType(); // getter
	Dstring toString();
	/+ package +/ protected LONG save(HKEY hkey, Dstring name); // package
	package final RegistryValue _reg() { return this; }
}


///
class RegistryValueSz: RegistryValue
{
	///
	Dstring value;
	
	
	///
	this(Dstring str);
	
	/// ditto
	this();
	
	
	override DWORD valueType() ;
	
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name);
}


/+
// Extra.
///
class RegistryValueSzW: RegistryValue
{
	///
	wDstring value;
	
	
	///
	this(wDstring str);
	
	/// ditto
	this();
	
	
	override DWORD valueType();
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name) ;
}
+/


///
class RegistryValueMultiSz: RegistryValue
{
	///
	Dstring[] value;
	
	
	///
	this(Dstring[] strs);
	
	/// ditto
	this();
	
	override DWORD valueType();
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name);
}


///
class RegistryValueExpandSz: RegistryValue
{
	///
	Dstring value;
	
	
	///
	this(Dstring str);
	
	/// ditto
	this();
	
	override DWORD valueType() ;
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name) ;
}


private Dstring dwordToString(DWORD dw);

unittest
{
	assert(dwordToString(0x8934) == "0x00008934");
	assert(dwordToString(0xF00BA2) == "0x00F00BA2");
	assert(dwordToString(0xBADBEEF0) == "0xBADBEEF0");
	assert(dwordToString(0xCAFEBEEF) == "0xCAFEBEEF");
	assert(dwordToString(0x09090BB) == "0x009090BB");
	assert(dwordToString(0) == "0x00000000");
}


///
class RegistryValueDword: RegistryValue
{
	///
	DWORD value;
	
	
	///
	this(DWORD dw);
	
	/// ditto
	this();
	
	override DWORD valueType() ;
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name);
}

/// ditto
alias RegistryValueDword RegistryValueDwordLittleEndian;

/// ditto
class RegistryValueDwordBigEndian: RegistryValue
{
	///
	DWORD value;
	
	
	///
	this(DWORD dw);
	
	/// ditto
	this();
	
	override DWORD valueType() ;
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name);
}


///
class RegistryValueBinary: RegistryValue
{
	///
	void[] value;
	
	
	///
	this(void[] val);
	/// ditto
	this();
	
	
	override DWORD valueType() ;
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name) ;
}


///
class RegistryValueLink: RegistryValue
{
	///
	void[] value;
	
	
	///
	this(void[] val);
	
	/// ditto
	this();
	
	override DWORD valueType() ;
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name);
}


///
class RegistryValueResourceList: RegistryValue
{
	///
	void[] value;
	
	
	///
	this(void[] val);
	/// ditto
	this();
	
	override DWORD valueType() ;
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name) ;
}


///
class RegistryValueNone: RegistryValue
{
	///
	void[] value;
	
	
	///
	this(void[] val);
	
	/// ditto
	this();
	
	override DWORD valueType();
	
	override Dstring toString();
	
	/+ package +/ protected override LONG save(HKEY hkey, Dstring name) ;
}


///
enum RegistryHive: size_t
{
	/+
	// DMD 0.98:
	// c:\dm\..\src\phobos\std\c\windows\windows.d(493): cast(HKEY)(2147483648) is not an expression
	// ...
	CLASSES_ROOT = cast(size_t)HKEY_CLASSES_ROOT,
	CURRENT_CONFIG = cast(size_t)HKEY_CURRENT_CONFIG,
	CURRENT_USER = cast(size_t)HKEY_CURRENT_USER,
	DYN_DATA = cast(size_t)HKEY_DYN_DATA,
	LOCAL_MACHINE = cast(size_t)HKEY_LOCAL_MACHINE,
	PERFORMANCE_DATA = cast(size_t)HKEY_PERFORMANCE_DATA,
	USERS = cast(size_t)HKEY_USERS,
	+/
	
	CLASSES_ROOT = 0x80000000, ///
	CURRENT_CONFIG = 0x80000005, /// ditto
	CURRENT_USER = 0x80000001, /// ditto
	DYN_DATA = 0x80000006, /// ditto
	LOCAL_MACHINE = 0x80000002, /// ditto
	PERFORMANCE_DATA = 0x80000004, /// ditto
	USERS = 0x80000003, /// ditto
}


///
class RegistryKey // docmain
{
	private:
	HKEY hkey;
	bool owned = true;
	
	
	public:
	final:
	/+
	// An absolute key path.
	// This doesn't work.
	final Dstring name() ;
	+/
	
	
	///
	final int subKeyCount() ;
	
	
	///
	final int valueCount() ;
	
	///
	final void close();
	///
	final RegistryKey createSubKey(Dstring name);
	
	///
	final void deleteSubKey(Dstring name, bool throwIfMissing);
	/// ditto
	final void deleteSubKey(Dstring name);
	
	///
	final void deleteSubKeyTree(Dstring name);
	
	// Note: name is not written to! it's just not "invariant".
	private static void _deleteSubKeyTree(HKEY shkey, Dstring name);
	
	///
	final void deleteValue(Dstring name, bool throwIfMissing);
	
	/// ditto
	final void deleteValue(Dstring name);
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(RegistryKey rk);
	///
	final void flush();
	
	///
	final Dstring[] getSubKeyNames();
	
	///
	final RegistryValue getValue(Dstring name, RegistryValue defaultValue);
	
	/// ditto
	final RegistryValue getValue(Dstring name);
	///
	final Dstring[] getValueNames();
	
	///
	static RegistryKey openRemoteBaseKey(RegistryHive hhive, Dstring machineName);
	
	///
	// Returns null on error.
	final RegistryKey openSubKey(Dstring name, bool writeAccess);
	/// ditto
	final RegistryKey openSubKey(Dstring name);
	
	///
	final void setValue(Dstring name, RegistryValue value);
	/// ditto
	// Shortcut.
	final void setValue(Dstring name, Dstring value);
	/// ditto
	// Shortcut.
	final void setValue(Dstring name, Dstring[] value);
	/// ditto
	// Shortcut.
	final void setValue(Dstring name, DWORD value);
	
	///
	// Used internally.
	final HKEY handle();
	
	// Used internally.
	this(HKEY hkey, bool owned = true);
	
	~this();
	
	private void infoErr(LONG why);
}

