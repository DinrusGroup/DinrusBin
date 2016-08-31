/***********************************************************************\
*                               basetsd.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*             Translated from MinGW API for MS-Windows 3.12             *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.basetsd;

template CPtr(T) {
	version (D_Version2) {
		// must use mixin so that it doesn't cause a syntax error under D1
		mixin("alias const(T)* CPtr;");
	} else {
		alias T* CPtr;
	}
}

//alias CPtr!(TCHAR) LPCTSTR;
//alias CPtr!(char)  LPCCH, PCSTR, LPCSTR;
//alias CPtr!(wchar) LPCWCH, PCWCH, LPCWSTR, PCWSTR;
version (Win64) {
} else {

	uint HandleToUlong(HANDLE h)      { return cast(uint) h; }
	int HandleToLong(HANDLE h)        { return cast(int) h; }
	HANDLE LongToHandle(LONG_PTR h)   { return cast(HANDLE) h; }
	uint PtrToUlong(CPtr!(void) p)    { return cast(uint) p; }
	uint PtrToUint(CPtr!(void) p)     { return cast(uint) p; }
	int PtrToInt(CPtr!(void) p)       { return cast(int) p; }
	ushort PtrToUshort(CPtr!(void) p) { return cast(ushort) p; }
	short PtrToShort(CPtr!(void) p)   { return cast(short) p; }
	void* IntToPtr(int i)             { return cast(void*) i; }
	void* UIntToPtr(uint ui)          { return cast(void*) ui; }
	alias IntToPtr LongToPtr;
	alias UIntToPtr ULongToPtr;
}

alias UIntToPtr UintToPtr, UlongToPtr;

enum : UINT_PTR {
	MAXUINT_PTR = UINT_PTR.max
}

enum : INT_PTR {
	MAXINT_PTR = INT_PTR.max,
	MININT_PTR = INT_PTR.min
}

enum : ULONG_PTR {
	MAXULONG_PTR = ULONG_PTR.max
}

enum : LONG_PTR {
	MAXLONG_PTR = LONG_PTR.max,
	MINLONG_PTR = LONG_PTR.min
}

enum : UHALF_PTR {
	MAXUHALF_PTR = UHALF_PTR.max
}

enum : HALF_PTR {
	MAXHALF_PTR = HALF_PTR.max,
	MINHALF_PTR = HALF_PTR.min
}

