module sys.win32.Macros;

/*
 	Module:		Windows Utilities
 	Author: 	Trevor Parscal
*/

/+ Imports +/
public
{
	
    import sys.win32.Types;
}
private
{
	import cidrus;
	import sys.win32.UserGdi;
}


/+ Functions +/
бкрат MAKEWORD(ббайт A, ббайт B)
{
	return cast(бкрат)(A | (B << 8));
}
бцел MAKELONG(бкрат A, бкрат B)
{
	return cast(бцел)(A | (B << 16));
}
бкрат HIWORD(бцел L)
{
	return cast(бкрат)(L >> 16);
}
бкрат LOWORD(бцел L)
{
	return cast(бкрат)(L & 0xFFFF);
}
ббайт HIBYTE(бкрат W)
{
	return cast(ббайт)(W >> 8);
}
ббайт LOBYTE(бкрат W)
{
	return cast(ббайт)(W & 0xFF);
}
HANDLE GlobalDiscard(HANDLE h)
{
	return GlobalReAlloc(h, 0, GMEM_MOVEABLE);
}
HANDLE LocalDiscard(HANDLE h)
{
	return LocalReAlloc(h, 0, LMEM_MOVEABLE);
}
BOOL SUCCEEDED(HRESULT Status)
{
	return (cast(цел)Status & 0x80000000) == 0;
}
BOOL FAILED(HRESULT Status)
{
	return (cast(цел)Status & 0x80000000) != 0;
}
BOOL IS_ERROR(HRESULT Status)
{
	return (cast(цел)Status >> 31) == SEVERITY_ERROR;
}
цел HRESULT_CODE(HRESULT hr)
{
	return cast(цел)hr & 0xFFFF;
}
цел HRESULT_FACILITY(HRESULT hr)
{
	return (cast(цел)hr >> 16) & 0x1FFF;
}
цел HRESULT_SEVERITY(HRESULT hr)
{
	return (cast(цел)hr >> 31) & 0x1;
}
HRESULT MAKE_HRESULT(цел sev, цел fac, цел код)
{
	return cast(HRESULT)((sev << 31) | (fac << 16) | код);
}
HRESULT HRESULT_FROM_WIN32(цел x)
{
	return cast(HRESULT) (x ? (x & 0xFFFF) | (FACILITY_WIN32 << 16) | 0x80000000 : 0);
}
//HRESULT HRESULT_FROM_NT(цел x)
//{
//	return x | FACILITY_NT_BIT;
//}
DWORD MAKEROP4(DWORD fore, DWORD back)
{
	return ((back << 8) & 0xFF000000) | fore;
}
ббайт GetKValue(COLORREF cmyk)
{
	return cast(ббайт)(cmyk & 0xFF);
}
ббайт GetYValue(COLORREF cmyk)
{
	return cast(ббайт)((cmyk >> 8) & 0xFF);
}
ббайт GetMValue(COLORREF cmyk)
{
	return cast(ббайт)((cmyk >> 16) & 0xFF);
}
ббайт GetCValue(COLORREF cmyk)
{
	return cast(ббайт)((cmyk >> 24) & 0xFF);
}
COLORREF CMYK(ббайт c, ббайт m, ббайт y, ббайт k)
{
	return k | (y << 8) | (m << 16) | (c << 24);
}
COLORREF RGB(ббайт r, ббайт g, ббайт b)
{
	return r | (g << 8) | (b << 16);
}
COLORREF PALETTERGB(ббайт r, ббайт g, ббайт b)
{
	return 0x02000000 | RGB(r, g, b);
}
COLORREF PALETTEINDEX(бкрат i)
{
	return 0x01000000 | i;
}
ббайт GetRValue(COLORREF rgb)
{
	return cast(ббайт)(rgb & 0xFF);
}
ббайт GetGValue(COLORREF rgb)
{
	return cast(ббайт)((rgb >> 8) & 0xFF);
}
ббайт GetBValue(COLORREF rgb)
{
	return cast(ббайт)((rgb >> 16) & 0xFF);
}
WPARAM MAKEWPARAM(бкрат l, бкрат h)
{
	return MAKELONG(l, h);
}
LPARAM MAKELPARAM(бкрат l, бкрат h)
{
	return MAKELONG(l, h);
}
LRESULT MAKELRESULT(бкрат l, бкрат h)
{
	return MAKELONG(l, h);
}
BOOL ExitWindows(DWORD dwReserved, UINT uReserved)
{
	return ExitWindowsEx(EWX_LOGOFF, 0);
}
HWND CreateWindowA(PCHAR b, PCHAR c, DWORD d, цел e,
	цел f, цел g, цел h, HWND i, HMENU j, HINST k, POINTER l)
{
	return CreateWindowExA(0, b, c, d, e, f, g, h, i, j, k, l);
}
HWND CreateWindowW(PWIDECHAR b, PWIDECHAR c, DWORD d, цел e,
	цел f, цел g, цел h, HWND i, HMENU j, HINST k, POINTER l)
{
	return CreateWindowExW(0, b, c, d, e, f, g, h, i, j, k, l);
}
HWND CreateDialogA(HINST a, PANSICHAR b, HWND c, DLGPROC d)
{
	return CreateDialogParamA(a, b, c, d, 0);
}
HWND CreateDialogW(HINST a, PWIDECHAR b, HWND c, DLGPROC d)
{
	return CreateDialogParamW(a, b, c, d, 0);
}
HWND CreateDialogIndirectA(HINST a, DLGTEMPLATE* b, HWND c, DLGPROC d)
{
	return CreateDialogIndirectParamA(a, b, c, d, 0);
}
HWND CreateDialogIndirectW(HINST a, DLGTEMPLATE* b, HWND c, DLGPROC d)
{
	return CreateDialogIndirectParamW(a, b, c, d, 0);
}
цел DialogBoxA(HINST a, PANSICHAR b, HWND c, DLGPROC d)
{
	return DialogBoxParamA(a, b, c, d, 0);
}
цел DialogBoxW(HINST a, PWIDECHAR b, HWND c, DLGPROC d)
{
	return DialogBoxParamW(a, b, c, d, 0);
}
цел DialogBoxIndirectA(HINST a, DLGTEMPLATE* b, HWND c, DLGPROC d)
{
	return DialogBoxIndirectParamA(a, b, c, d, 0);
}
цел DialogBoxIndirectW(HINST a, DLGTEMPLATE* b, HWND c, DLGPROC d)
{
	return DialogBoxIndirectParamW(a, b, c, d, 0);
}
проц ZeroMemory(ук  приёмник, бцел длин)
{
	memset(приёмник, 0, длин);
}
проц FillMemory(ук  приёмник, бцел длин, ббайт c)
{
	memset(приёмник, c, длин);
}
проц MoveMemory(ук  приёмник, ук  ист, бцел длин)
{
	memmove(приёмник, ист, длин);
}
проц CopyMemory(ук  приёмник, ук  ист, бцел длин)
{
	memcpy(приёмник, ист, длин);
}
