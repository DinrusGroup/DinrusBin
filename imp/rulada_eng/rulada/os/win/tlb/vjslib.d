// vjslib.dll
// Version 2.0

/*[uuid("e710fa11-6607-32ba-8c1a-2015ded1b85b")]*/
module os.win.tlb.vjslib;

/*[importlib("STDOLE2.TLB")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Structs

struct RECTHelper {
  mixin(uuid("2edf4338-a1f2-3799-b65d-8ffc29d3d187"));
  int left;
  int top;
  int right;
  int bottom;
}

struct RemSNBHelper {
  mixin(uuid("7da13863-2c54-3fa6-95bc-9a5ad15638dc"));
}

struct ABCHelper {
  mixin(uuid("6e368dd3-7bb6-3031-ab7f-d81beb5bb19b"));
  int abcA;
  int abcB;
  int abcC;
}

struct ABCFLOATHelper {
  mixin(uuid("ad2a5145-ddcf-35a0-8138-475d44e9d040"));
  float abcfA;
  float abcfB;
  float abcfC;
}

struct ACCELHelper {
  mixin(uuid("60b8d404-b323-3c20-a5d7-4a6487e3687d"));
  byte fVirt;
  short Key;
  short cmd;
}

struct ACCESSTIMEOUTHelper {
  mixin(uuid("109723c7-47cd-3810-a077-aeef23b409a7"));
  int cbSize;
  int dwFlags;
  int iTimeOutMSec;
}

struct ANIMATIONINFOHelper {
  mixin(uuid("c4c8d6bc-8187-3bbc-abbf-d87dcb0709a5"));
  int cbSize;
  int iMinAnimate;
}

struct APPBARDATAHelper {
  mixin(uuid("c1ce2fa8-e7bd-337e-8cd6-3e3b94e91990"));
  int cbSize;
  int hWnd;
  int uCallbackMessage;
  int uEdge;
  int rc_left;
  int rc_top;
  int rc_right;
  int rc_bottom;
  int lParam;
}

struct AUXCAPSHelper {
  mixin(uuid("30fbc8ac-429b-3387-a961-4f391664b9e6"));
  short wMid;
  short wPid;
  int vDriverVersion;
  short wTechnology;
  short wReserved1;
  int dwSupport;
}

struct BITMAPHelper {
  mixin(uuid("4e7934ee-6847-3d64-8533-1e3b42f327d3"));
  int bmType;
  int bmWidth;
  int bmHeight;
  int bmWidthBytes;
  short bmPlanes;
  short bmBitsPixel;
  int bmBits;
}

struct BITMAPCOREHEADERHelper {
  mixin(uuid("f6332d0c-51a2-37b7-92ad-a18b92677ecf"));
  int bcSize;
  short bcWidth;
  short bcHeight;
  short bcPlanes;
  short bcBitCount;
}

struct BITMAPINFOHelper {
  mixin(uuid("0394b7f6-149c-33a2-a4bb-848b72d180ce"));
  int bmiHeader_biSize;
  int bmiHeader_biWidth;
  int bmiHeader_biHeight;
  short bmiHeader_biPlanes;
  short bmiHeader_biBitCount;
  int bmiHeader_biCompression;
  int bmiHeader_biSizeImage;
  int bmiHeader_biXPelsPerMeter;
  int bmiHeader_biYPelsPerMeter;
  int bmiHeader_biClrUsed;
  int bmiHeader_biClrImportant;
  byte bmiColors_rgbBlue;
  byte bmiColors_rgbGreen;
  byte bmiColors_rgbRed;
  byte bmiColors_rgbReserved;
}

struct BITMAPINFO256Helper {
  mixin(uuid("f29f21db-e325-3585-8ab9-26edb7995010"));
  int bmiHeader_biSize;
  int bmiHeader_biWidth;
  int bmiHeader_biHeight;
  short bmiHeader_biPlanes;
  short bmiHeader_biBitCount;
  int bmiHeader_biCompression;
  int bmiHeader_biSizeImage;
  int bmiHeader_biXPelsPerMeter;
  int bmiHeader_biYPelsPerMeter;
  int bmiHeader_biClrUsed;
  int bmiHeader_biClrImportant;
  int[256] bmiColors;
}

struct BITMAPINFOHEADERHelper {
  mixin(uuid("a032be3c-ca52-34c6-857f-e69b0b19d9cf"));
  int biSize;
  int biWidth;
  int biHeight;
  short biPlanes;
  short biBitCount;
  int biCompression;
  int biSizeImage;
  int biXPelsPerMeter;
  int biYPelsPerMeter;
  int biClrUsed;
  int biClrImportant;
}

struct BROADCASTSYSMSGHelper {
  mixin(uuid("45548d57-262d-39bf-ab51-16821d7b89bd"));
  int uiMessage;
  int wParam;
  int lParam;
}

struct BY_HANDLE_FILE_INFORMATIONHelper {
  mixin(uuid("843bedd3-a363-334e-8215-d93aa14473b8"));
  int dwFileAttributes;
  int ftCreationTime_dwLowDateTime;
  int ftCreationTime_dwHighDateTime;
  int ftLastAccessTime_dwLowDateTime;
  int ftLastAccessTime_dwHighDateTime;
  int ftLastWriteTime_dwLowDateTime;
  int ftLastWriteTime_dwHighDateTime;
  int dwVolumeSerialNumber;
  int nFileSizeHigh;
  int nFileSizeLow;
  int nNumberOfLinks;
  int nFileIndexHigh;
  int nFileIndexLow;
}

struct CHARFORMATHelper {
  mixin(uuid("08d9c29f-a9d1-3d2b-9f03-6e1fb40860bf"));
  int cbSize;
  int dwMask;
  int dwEffects;
  int yHeight;
  int yOffset;
  int crTextColor;
  byte bCharSet;
  byte bPitchAndFamily;
  ushort[32] szFaceName;
}

struct CHARFORMATAHelper {
  mixin(uuid("3c89b916-03f5-37ef-855c-62390604cafc"));
  int cbSize;
  int dwMask;
  int dwEffects;
  int yHeight;
  int yOffset;
  int crTextColor;
  byte bCharSet;
  byte bPitchAndFamily;
  ubyte[32] szFaceName;
}

struct CHARRANGEHelper {
  mixin(uuid("9c35c7ab-d27f-33fa-a464-a51939b7f917"));
  int cpMin;
  int cpMax;
}

struct CHARSETINFOHelper {
  mixin(uuid("6826bc73-55b1-3e00-b946-2c11b3390a92"));
  int ciCharset;
  int ciACP;
  int[4] fs_fsUsb;
  int[2] fs_fsCsb;
}

struct CHOOSECOLORHelper {
  mixin(uuid("71db2041-9a1a-3273-8350-a09ac3a967c0"));
  int lStructSize;
  int hwndOwner;
  int hInstance;
  int rgbResult;
  int lpCustColors;
  int Flags;
  int lCustData;
  int lpfnHook;
}

struct CHOOSEFONTHelper {
  mixin(uuid("46490da9-d497-31c0-a68c-db68e379a945"));
  int lStructSize;
  int hwndOwner;
  int hDC;
  int lpLogFont;
  int iPointSize;
  int Flags;
  int rgbColors;
  int lCustData;
  int lpfnHook;
  int hInstance;
  short nFontType;
  short ___MISSING_ALIGNMENT__;
  int nSizeMin;
  int nSizeMax;
}

struct CIEXYZHelper {
  mixin(uuid("029c3904-e2c2-3e00-bbef-0f99495130c5"));
  int ciexyzX;
  int ciexyzY;
  int ciexyzZ;
}

struct CIEXYZTRIPLEHelper {
  mixin(uuid("935f7d15-b1f2-310e-a5f7-fb31ed78afb3"));
  int ciexyzRed_ciexyzX;
  int ciexyzRed_ciexyzY;
  int ciexyzRed_ciexyzZ;
  int ciexyzGreen_ciexyzX;
  int ciexyzGreen_ciexyzY;
  int ciexyzGreen_ciexyzZ;
  int ciexyzBlue_ciexyzX;
  int ciexyzBlue_ciexyzY;
  int ciexyzBlue_ciexyzZ;
}

struct CLIENTCREATESTRUCTHelper {
  mixin(uuid("6b4a6d33-8294-3183-81b6-99e0edef0ec0"));
  int hWindowMenu;
  int idFirstChild;
}

struct COLORADJUSTMENTHelper {
  mixin(uuid("c5cd5d3b-d508-3a93-9f5e-9a9b14e10dde"));
  short caSize;
  short caFlags;
  short caIlluminantIndex;
  short caRedGamma;
  short caGreenGamma;
  short caBlueGamma;
  short caReferenceBlack;
  short caReferenceWhite;
  short caContrast;
  short caBrightness;
  short caColorfulness;
  short caRedGreenTint;
}

struct COLORMAPHelper {
  mixin(uuid("07172280-547c-37e8-83da-06726bcedc85"));
  int from;
  int to;
}

struct COLORSCHEMEHelper {
  mixin(uuid("6e754df6-fad0-3d4a-8aac-87bd960bb5a4"));
  int dwSize;
  int clrBtnHighlight;
  int clrBtnShadow;
}

struct COMBOBOXEXITEMHelper {
  mixin(uuid("495031ae-ad88-34b2-bda8-2b3fa046c318"));
  int mask;
  int iItem;
  int pszText;
  int cchTextMax;
  int iImage;
  int iSelectedImage;
  int iOverlay;
  int iIndent;
  int lParam;
}

struct COMMTIMEOUTSHelper {
  mixin(uuid("e02210e5-a94f-3bb1-8523-e2fab340764f"));
  int ReadIntervalTimeout;
  int ReadTotalTimeoutMultiplier;
  int ReadTotalTimeoutConstant;
  int WriteTotalTimeoutMultiplier;
  int WriteTotalTimeoutConstant;
}

struct COMPAREITEMSTRUCTHelper {
  mixin(uuid("ab92f3e3-1309-3a53-bd44-1fdab46966d1"));
  int CtlType;
  int CtlID;
  int hwndItem;
  int itemID1;
  int itemData1;
  int itemID2;
  int itemData2;
  int dwLocaleId;
}

struct COMPCOLORHelper {
  mixin(uuid("3158a958-ff98-3dcb-8bc0-fa3d21ea1fd4"));
  int crText;
  int crBackground;
  int dwEffects;
}

struct COMSTATHelper {
  mixin(uuid("24e181af-bbd1-3cb1-a42f-6b0e430ef7f4"));
  int fBitFields;
  int cbInQue;
  int cbOutQue;
}

struct CONSOLE_CURSOR_INFOHelper {
  mixin(uuid("b1eb3e5e-9c43-3f79-96f5-d1370518ee80"));
  int dwSize;
  int bVisible;
}

struct CONSOLE_SCREEN_BUFFER_INFOHelper {
  mixin(uuid("1605ed62-a7e7-34ce-ae4e-be399d021d9b"));
  short dwSize_X;
  short dwSize_Y;
  short dwCursorPosition_X;
  short dwCursorPosition_Y;
  short wAttributes;
  short srWindow_Left;
  short srWindow_Top;
  short srWindow_Right;
  short srWindow_Bottom;
  short dwMaximumWindowSize_X;
  short dwMaximumWindowSize_Y;
}

struct COORDHelper {
  mixin(uuid("1b21a4c9-d939-3db1-b014-3a9d2b9ed7b6"));
  short x;
  short y;
}

struct COPYDATASTRUCTHelper {
  mixin(uuid("6fd3ba92-7925-347d-bffd-d62edf7824ad"));
  int dwData;
  int cbData;
  int lpData;
}

struct CPINFOHelper {
  mixin(uuid("3665d415-867e-3a69-8ef5-739847b79fff"));
  int MaxCharSize;
  byte[2] DefaultChar;
  byte[12] LeadByte;
}

struct CREATESTRUCTHelper {
  mixin(uuid("8237cdb4-7dae-308f-a5c7-7a747fd07511"));
  int lpCreateParams;
  int hInstance;
  int hMenu;
  int hwndParent;
  int cy;
  int cx;
  int y;
  int x;
  int style;
  int dwExStyle;
}

struct CREATESTRUCT_IHelper {
  mixin(uuid("1f4b9b99-eabc-3ecf-b981-8f71047b1b29"));
  int lpCreateParams;
  int hInstance;
  int hMenu;
  int hwndParent;
  int cy;
  int cx;
  int y;
  int x;
  int style;
  int lpszName;
  int lpszClass;
  int dwExStyle;
}

struct CRGBHelper {
  mixin(uuid("c06f08a9-b29a-3add-8245-48584b53c0ef"));
  byte bRed;
  byte bGreen;
  byte bBlue;
  byte bExtra;
}

struct CURRENCYFMTHelper {
  mixin(uuid("7a7a421f-e68d-3d18-8c90-3bbda6136a18"));
  int NumDigits;
  int LeadingZero;
  int Grouping;
  int NegativeOrder;
  int PositiveOrder;
}

struct CURSORSHAPEHelper {
  mixin(uuid("88cddaa0-dae5-3848-aaf8-af6d6fd61c4e"));
  int xHotSpot;
  int yHotSpot;
  int cx;
  int cy;
  int cbWidth;
  byte Planes;
  byte BitsPixel;
}

struct CWPRETSTRUCTHelper {
  mixin(uuid("61771799-b5f8-338a-b303-6ce48252c857"));
  int lResult;
  int lParam;
  int wParam;
  int message;
  int hWnd;
}

struct CWPSTRUCTHelper {
  mixin(uuid("8d53ae33-307e-3587-b1b5-b43b6d5106da"));
  int lParam;
  int wParam;
  int message;
  int hWnd;
}

struct DCBHelper {
  mixin(uuid("361404c0-1b37-36e3-850f-47fbf068a7cc"));
  int DCBlength;
  int BaudRate;
  int fBitFields;
  short wReserved;
  short XonLim;
  short XoffLim;
  byte ByteSize;
  byte Parity;
  byte StopBits;
  ubyte XonChar;
  ubyte XoffChar;
  ubyte ErrorChar;
  ubyte EofChar;
  ubyte EvtChar;
  short wReserved1;
}

struct DELETEITEMSTRUCTHelper {
  mixin(uuid("eca227a7-c863-3723-a7b3-1e4594876780"));
  int CtlType;
  int CtlID;
  int itemID;
  int hwndItem;
  int itemData;
}

struct DEVMODEHelper {
  mixin(uuid("43332886-b87c-3ea0-b101-cf42d0bd5c88"));
  short dmSpecVersion;
  short dmDriverVersion;
  short dmSize;
  short dmDriverExtra;
  int dmFields;
  short dmOrientation;
  short dmPaperSize;
  short dmPaperLength;
  short dmPaperWidth;
  short dmScale;
  short dmCopies;
  short dmDefaultSource;
  short dmPrintQuality;
  short dmColor;
  short dmDuplex;
  short dmYResolution;
  short dmTTOption;
  short dmCollate;
  short dmLogPixels;
  int dmBitsPerPel;
  int dmPelsWidth;
  int dmPelsHeight;
  int dmDisplayFlags;
  int dmDisplayFrequency;
  int dmICMMethod;
  int dmICMIntent;
  int dmMediaType;
  int dmDitherType;
  int dmICCManufacturer;
  int dmICCModel;
  int dmPanningWidth;
  int dmPanningHeight;
}

struct DEVNAMESHelper {
  mixin(uuid("46f8cff8-dc14-3c5a-a94d-d264a435f6ec"));
  short wDriverOffset;
  short wDeviceOffset;
  short wOutputOffset;
  short wDefault;
}

struct DLGTEMPLATEHelper {
  mixin(uuid("7ed47b41-dbc3-33b4-9cfb-54379c6a43c3"));
  int style;
  int dwExtendedStyle;
  short cdit;
  short x;
  short y;
  short cx;
  short cy;
}

struct DOCINFOHelper {
  mixin(uuid("8430c019-bf40-3d3b-bffe-d8d49d034e46"));
  int cbSize;
  int fwType;
}

struct DRAWITEMSTRUCTHelper {
  mixin(uuid("15d5241c-2ce7-3a1b-8c70-f9ef6d364fa2"));
  int CtlType;
  int CtlID;
  int itemID;
  int itemAction;
  int itemState;
  int hwndItem;
  int hDC;
  RECTHelper_2 rcItem;
  int itemData;
}

struct DRAWITEMSTRUCT_XHelper {
  mixin(uuid("c39edd59-6bdb-328a-848f-15023cb48123"));
  int CtlType;
  int CtlID;
  int itemID;
  int itemAction;
  int itemState;
  int hwndItem;
  int hDC;
  int rcItem_left;
  int rcItem_top;
  int rcItem_right;
  int rcItem_bottom;
  int itemData;
}

struct DRAWTEXTPARAMSHelper {
  mixin(uuid("e5c3d233-9562-3eeb-bf03-45ab8fb63c23"));
  int cbSize;
  int iTabLength;
  int iLeftMargin;
  int iRightMargin;
  int uiLengthDrawn;
}

struct DROPSTRUCTHelper {
  mixin(uuid("196fce56-4dc1-3134-a74d-4e88df567cc4"));
  int hwndSource;
  int hwndSink;
  int wFmt;
  int dwData;
  POINTHelper ptDrop;
  int dwControlData;
}

struct EDITSTREAMHelper {
  mixin(uuid("a58353a2-3b8a-3c38-9dfb-df184e9df16f"));
  int dwCookie;
  int dwError;
  int pfnCallback;
}

struct ENDROPFILESHelper {
  mixin(uuid("efbd470b-c639-3e9d-8c77-56cfd5551c54"));
  NMHDRHelper NMHDR;
  int hDrop;
  int cp;
  int fProtected;
}

struct ENHMETAHEADERHelper {
  mixin(uuid("0fc937a4-9d28-3314-931a-c0f6818fa4f4"));
  int iType;
  int nSize;
  int rclBounds_left;
  int rclBounds_top;
  int rclBounds_right;
  int rclBounds_bottom;
  int rclFrame_left;
  int rclFrame_top;
  int rclFrame_right;
  int rclFrame_bottom;
  int dSignature;
  int nVersion;
  int nBytes;
  int nRecords;
  short nHandles;
  short sReserved;
  int nDescription;
  int offDescription;
  int nPalEntries;
  int szlDevice_cx;
  int szlDevice_cy;
  int szlMillimeters_cx;
  int szlMillimeters_cy;
  int cbPixelFormat;
  int offPixelFormat;
  int bOpenGL;
}

struct ENPROTECTEDHelper {
  mixin(uuid("4339ffef-3c96-3766-94c9-deb2d0efcfde"));
  NMHDRHelper NMHDR;
  int MSG;
  int wParam;
  int lParam;
  CHARRANGEHelper chrg;
}

struct ENUMLOGFONTHelper {
  mixin(uuid("c6bd20c6-b27a-3145-8fd0-5193c8fec4a8"));
  LOGFONTHelper elfLogFont;
}

struct ENUMLOGFONTEXHelper {
  mixin(uuid("f6adc79c-e24b-30bf-9000-e881814099ee"));
  LOGFONTHelper elfLogFont;
}

struct ENUMLOGFONTEX_XHelper {
  mixin(uuid("abc122b2-5e32-36a2-a9c0-d4d9ff31d849"));
  int elfLogFont_lfHeight;
  int elfLogFont_lfWidth;
  int elfLogFont_lfEscapement;
  int elfLogFont_lfOrientation;
  int elfLogFont_lfWeight;
  byte elfLogFont_lfItalic;
  byte elfLogFont_lfUnderline;
  byte elfLogFont_lfStrikeOut;
  byte elfLogFont_lfCharSet;
  byte elfLogFont_lfOutPrecision;
  byte elfLogFont_lfClipPrecision;
  byte elfLogFont_lfQuality;
  byte elfLogFont_lfPitchAndFamily;
  ubyte[32] elfLogFont_lfFaceName;
  ubyte[64] elfFullName;
  ubyte[32] elfStyle;
  ubyte[32] elfScript;
}

struct EVENTMSGHelper {
  mixin(uuid("613c16f7-c209-3f4e-84e8-77c5e62eaaa4"));
  int message;
  int paramL;
  int paramH;
  int Time;
  int hWnd;
}

struct EXTLOGFONTHelper {
  mixin(uuid("20c7e552-f07b-335a-8f55-c0b0f910decf"));
  LOGFONTHelper elfLogFont;
  int elfVersion;
  int elfStyleSize;
  int elfMatch;
  int elfReserved;
  byte[4] elfVendorId;
  int elfCulture;
  PANOSEHelper elfPanose;
}

struct FILETIMEHelper {
  mixin(uuid("c8bca0f2-a23b-3778-b487-44c4c4d6e7d7"));
  int dwLowDateTime;
  int dwHighDateTime;
}

struct FILTERKEYSHelper {
  mixin(uuid("66f0375d-2934-392b-86d2-8d6d576bdad1"));
  int cbSize;
  int dwFlags;
  int iWaitMSec;
  int iDelayMSec;
  int iRepeatMSec;
  int iBounceMSec;
}

struct FINDREPLACEHelper {
  mixin(uuid("a806d124-0cfa-3fa2-8e3d-1fbd60e57677"));
  int lStructSize;
  int hwndOwner;
  int hInstance;
  int Flags;
  int lpstrFindWhat;
  int lpstrReplaceWith;
  short wFindWhatLen;
  short wReplaceWithLen;
  int lCustData;
  int lpfnHook;
}

struct FINDTEXTHelper {
  mixin(uuid("0ed6a348-7470-34f1-9e32-1d82cb5b5914"));
  CHARRANGEHelper chrg;
}

struct FINDTEXTAHelper {
  mixin(uuid("c8285df0-fcf3-3801-821f-082083cb8ccc"));
  CHARRANGEHelper chrg;
  wchar* lpstrText;
}

struct FINDTEXTA_EXHelper {
  mixin(uuid("e4c510fb-ca54-3453-80e7-edad00e8e3a9"));
  CHARRANGEHelper chrg;
  wchar* lpstrText;
  CHARRANGEHelper chrgText;
}

struct FINDTEXTEXHelper {
  mixin(uuid("7f9df87d-0f93-300e-8f1d-188ba47e2c4c"));
  CHARRANGEHelper chrg;
  CHARRANGEHelper chrgText;
}

struct FINDTEXTEXAHelper {
  mixin(uuid("03c4a93f-9cd6-36e8-bdb7-c8118df257e5"));
  CHARRANGEHelper chrg;
  wchar* lpstrText;
  CHARRANGEHelper chrgText;
}

struct FIXEDHelper {
  mixin(uuid("27c97a15-3c20-35d9-9435-b97b7243e9f6"));
  short fract;
  short value;
}

struct FONTSIGNATUREHelper {
  mixin(uuid("486c28ee-7f48-3351-8133-0000124c2882"));
  int[4] fsUsb;
  int[2] fsCsb;
}

struct FORMATRANGEHelper {
  mixin(uuid("2910077b-f2d9-3c51-8ab3-d1caffae6825"));
  int hDC;
  int hdcTarget;
  int rc_left;
  int rc_top;
  int rc_right;
  int rc_bottom;
  int rcPage_left;
  int rcPage_top;
  int rcPage_right;
  int rcPage_bottom;
  int chrg_cpMin;
  int chrg_cpMax;
}

struct FORM_INFO_1Helper {
  mixin(uuid("54320121-1b20-3ddc-b6a6-f77c76a026ac"));
  int Flags;
  SIZEHelper SIZE;
  RECTLHelper ImageableArea;
}

struct GCP_RESULTSHelper {
  mixin(uuid("848edb29-a456-3a1f-b8dc-5cedc5ffdb12"));
  int lStructSize;
  int lpOrder;
  int lpDx;
  int lpCaretPos;
  int lpClass;
  int lpGlyphs;
  int nGlyphs;
  int nMaxFit;
}

struct GENERIC_MAPPINGHelper {
  mixin(uuid("fbf61f7f-09be-3aed-b8b1-4201648ac9d9"));
  int GenericRead;
  int GenericWrite;
  int GenericExecute;
  int GenericAll;
}

struct GLYPHMETRICSHelper {
  mixin(uuid("c5b2b975-f7a7-31ee-bbff-e1451971b4c6"));
  int gmBlackBoxX;
  int gmBlackBoxY;
  int gmptGlyphOrigin_x;
  int gmptGlyphOrigin_y;
  short gmCellIncX;
  short gmCellIncY;
}

struct HDITEMHelper {
  mixin(uuid("83d51f1f-b229-3940-a3ab-243bdd76ea70"));
  int mask;
  int cxy;
  int pszText;
  int hbm;
  int cchTextMax;
  int fmt;
  int lParam;
  int iImage;
  int iOrder;
}

struct HDLAYOUTHelper {
  mixin(uuid("9435baac-c7b1-3707-98a2-b18f4708de5f"));
  int prc;
  int pwpos;
}

struct HELPINFOHelper {
  mixin(uuid("89702478-72e6-36aa-9357-8475344433d5"));
  int cbSize;
  int iContextType;
  int iCtrlId;
  int hItemHandle;
  int dwContextId;
  POINTHelper MousePos;
}

struct HELPWININFOHelper {
  mixin(uuid("ed8860a8-557a-3914-9b36-99e54fb90cad"));
  int wStructSize;
  int x;
  int y;
  int dx;
  int dy;
  int wMax;
}

struct HIGHCONTRASTHelper {
  mixin(uuid("c5ea5f74-2696-3043-b22f-eac683d7a8fa"));
  int cbSize;
  int dwFlags;
}

struct HW_PROFILE_INFOHelper {
  mixin(uuid("d03c6a7c-3e03-3835-b59a-e1f9930b715f"));
  int dwDockInfo;
}

struct ICONINFOHelper {
  mixin(uuid("77d3c4de-380c-3c98-bd6f-10af2de7da15"));
  int fIcon;
  int xHotSpot;
  int yHotSpot;
  int hbmMask;
  int hbmColor;
}

struct ICONMETRICSHelper {
  mixin(uuid("d60314c1-ee4d-3cbc-bb13-b6e0d6ac7153"));
  int cbSize;
  int iHorzSpacing;
  int iVertSpacing;
  int iTitleWrap;
  LOGFONTHelper lfFont;
}

struct IMAGEINFOHelper {
  mixin(uuid("e5a773ba-87f9-36f8-95fd-76e6c8c07e25"));
  int hbmImage;
  int hbmMask;
  int Unused1;
  int Unused2;
  int rcImage_left;
  int rcImage_top;
  int rcImage_right;
  int rcImage_bottom;
}

struct IMAGELISTDRAWPARAMSHelper {
  mixin(uuid("9c965472-b3f0-3d97-9a95-5121a24b8f1e"));
  int cbSize;
  int himl;
  int i;
  int hdcDst;
  int x;
  int y;
  int cx;
  int cy;
  int xBitmap;
  int yBitmap;
  int rgbBk;
  int rgbFg;
  int fStyle;
  int dwRop;
}

struct INITCOMMONCONTROLSEXHelper {
  mixin(uuid("8a608cfa-8ca5-38b9-831d-342dd69094da"));
  int dwSize;
  int dwICC;
}

struct JOB_INFO_1Helper {
  mixin(uuid("7e74578f-3b44-3992-b530-09b0cc383aff"));
  int JobId;
  int status;
  int Priority;
  int Position;
  int TotalPages;
  int PagesPrinted;
  SYSTEMTIMEHelper Submitted;
}

struct JOB_INFO_2Helper {
  mixin(uuid("7b5f532b-8774-39bf-a98a-41fbfa5a58ef"));
  int JobId;
  int pDevMode;
  int pSecurityDescriptor;
  int status;
  int Priority;
  int Position;
  int StartTime;
  int UntilTime;
  int TotalPages;
  int SIZE;
  SYSTEMTIMEHelper Submitted;
  int Time;
  int PagesPrinted;
}

struct JOB_INFO_3Helper {
  mixin(uuid("3ff2fa60-a3fb-3baa-bb63-48bba20cac97"));
  int JobId;
  int NextJobId;
  int reserved;
}

struct JOYCAPSHelper {
  mixin(uuid("1921c9fa-aed4-3cbf-983f-c052fb8b012e"));
  short wMid;
  short wPid;
  int wXmin;
  int wXmax;
  int wYmin;
  int wYmax;
  int wZmin;
  int wZmax;
  int wNumButtons;
  int wPeriodMin;
  int wPeriodMax;
  int wRmin;
  int wRmax;
  int wUmin;
  int wUmax;
  int wVmin;
  int wVmax;
  int wCaps;
  int wMaxAxes;
  int wNumAxes;
  int wMaxButtons;
}

struct JOYINFOHelper {
  mixin(uuid("03c3d474-f895-3990-b235-344624eaf0e8"));
  int wXpos;
  int wYpos;
  int wZpos;
  int wButtons;
}

struct JOYINFOEXHelper {
  mixin(uuid("e9ec7ab9-e55f-31fc-b5d8-04d029933285"));
  int dwSize;
  int dwFlags;
  int dwXpos;
  int dwYpos;
  int dwZpos;
  int dwRpos;
  int dwUpos;
  int dwVpos;
  int dwButtons;
  int dwButtonNumber;
  int dwPOV;
  int dwReserved1;
  int dwReserved2;
}

struct KERNINGPAIRHelper {
  mixin(uuid("3f0cddb7-9827-342f-a7b1-75a6bdcd26ea"));
  short wFirst;
  short wSecond;
  int iKernAmount;
}

struct LOCALESIGNATUREHelper {
  mixin(uuid("8fba7a3e-39a5-3ef1-bab1-0279dc4e1649"));
  int[4] lsUsb;
  int[2] lsCsbDefault;
  int[2] lsCsbSupported;
}

struct LOGBRUSHHelper {
  mixin(uuid("6a84da3a-7909-345a-8e9e-b6c22669808f"));
  int lbStyle;
  int lbColor;
  int lbHatch;
}

struct LOGCOLORSPACEHelper {
  mixin(uuid("7ba85018-3bdd-335a-9dd7-572ac85fefa5"));
  int lcsSignature;
  int lcsVersion;
  int lcsSize;
  int lcsCSType;
  int lcsIntent;
  int lcsEndpoints_ciexyzRed_ciexyzX;
  int lcsEndpoints_ciexyzRed_ciexyzY;
  int lcsEndpoints_ciexyzRed_ciexyzZ;
  int lcsEndpoints_ciexyzGreen_ciexyzX;
  int lcsEndpoints_ciexyzGreen_ciexyzY;
  int lcsEndpoints_ciexyzGreen_ciexyzZ;
  int lcsEndpoints_ciexyzBlue_ciexyzX;
  int lcsEndpoints_ciexyzBlue_ciexyzY;
  int lcsEndpoints_ciexyzBlue_ciexyzZ;
  int lcsGammaRed;
  int lcsGammaGreen;
  int lcsGammaBlue;
}

struct LOGFONTHelper {
  mixin(uuid("d063fcaf-ad0c-31d5-8f24-1df8e37e470f"));
  int lfHeight;
  int lfWidth;
  int lfEscapement;
  int lfOrientation;
  int lfWeight;
  byte lfItalic;
  byte lfUnderline;
  byte lfStrikeOut;
  byte lfCharSet;
  byte lfOutPrecision;
  byte lfClipPrecision;
  byte lfQuality;
  byte lfPitchAndFamily;
}

struct LOGPALETTEHelper {
  mixin(uuid("b7fd6f98-e879-36e6-a896-ed8542d8b62d"));
  short palVersion;
  short palNumEntries;
  PALETTEENTRYHelper palPalEntry;
}

struct LOGPENHelper {
  mixin(uuid("1fd0485d-5128-39bf-96c0-0f3895b4bfd1"));
  int lopnStyle;
  int lopnWidth_x;
  int lopnWidth_y;
  int lopnColor;
}

struct LUIDHelper {
  mixin(uuid("e18573c5-6500-3df0-b995-92516ed162ad"));
  int LowPart;
  int HighPart;
}

struct LUID_AND_ATTRIBUTESHelper {
  mixin(uuid("8feb92f2-56d5-3dc8-8d56-b534492ead7e"));
  long LUID;
  int Attributes;
}

struct LVCOLUMNHelper {
  mixin(uuid("1da73b0d-252d-3c76-98d6-2d9dab3d945a"));
  int mask;
  int fmt;
  int cx;
  int pszText;
  int cchTextMax;
  int iSubItem;
  int iImage;
  int iOrder;
}

struct LVCOLUMN_THelper {
  mixin(uuid("b9678ce2-0bc4-353f-9001-4fa1bb14bc08"));
  int mask;
  int fmt;
  int cx;
  int cchTextMax;
  int iSubItem;
  int iImage;
  int iOrder;
}

struct LVFINDINFOHelper {
  mixin(uuid("77e038ea-63d2-348b-a8a7-c5fcc698fc66"));
  int Flags;
  int psz;
  int lParam;
  int pt_x;
  int pt_y;
  int vkDirection;
}

struct LVHITTESTINFOHelper {
  mixin(uuid("fc869752-584c-3999-823c-3fa25dfd1f9a"));
  int pt_x;
  int pt_y;
  int Flags;
  int iItem;
  int iSubItem;
}

struct LVITEMHelper {
  mixin(uuid("0824ffb8-e090-3ff3-a002-9179cb6e3435"));
  int mask;
  int iItem;
  int iSubItem;
  int state;
  int stateMask;
  int pszText;
  int cchTextMax;
  int iImage;
  int lParam;
  int iIndent;
}

struct LVITEM_THelper {
  mixin(uuid("851bebad-2fb2-31b4-9256-d5aeb30633e8"));
  int mask;
  int iItem;
  int iSubItem;
  int state;
  int stateMask;
  int cchTextMax;
  int iImage;
  int lParam;
  int iIndent;
}

struct MAT2Helper {
  mixin(uuid("eac16440-cfb7-37c0-a5e7-2996dd0a5b4b"));
  short eM11_fract;
  short eM11_value;
  short eM12_fract;
  short eM12_value;
  short eM21_fract;
  short eM21_value;
  short eM22_fract;
  short eM22_value;
}

struct MCHITTESTINFOHelper {
  mixin(uuid("876cf2bd-7ee8-3dc4-a12b-178626b7c020"));
  int cbSize;
  int pt_x;
  int pt_y;
  int uHit;
  short st_wYear;
  short st_wMonth;
  short st_wDayOfWeek;
  short st_wDay;
  short st_wHour;
  short st_wMinute;
  short st_wSecond;
  short st_wMilliseconds;
}

struct MCI_ANIM_OPEN_PARMSHelper {
  mixin(uuid("d84ab111-18c0-3590-87df-f19f2d9eef64"));
  int dwCallback;
  int wDeviceID;
  int dwStyle;
  int hwndParent;
}

struct MCI_ANIM_PLAY_PARMSHelper {
  mixin(uuid("2159e397-4002-3f8f-9feb-d0b93341e39d"));
  int dwCallback;
  int dwFrom;
  int dwTo;
  int dwSpeed;
}

struct MCI_ANIM_RECT_PARMSHelper {
  mixin(uuid("740c6426-f916-3aa4-b83b-1bb1f7c1a645"));
  int dwCallback;
  RECTHelper_2 rc;
}

struct MCI_ANIM_STEP_PARMSHelper {
  mixin(uuid("83270573-0ebe-38ae-af87-d11bbe001442"));
  int dwCallback;
  int dwFrames;
}

struct MCI_ANIM_UPDATE_PARMSHelper {
  mixin(uuid("92ff47da-7306-362b-acf4-28b3e2d87c42"));
  int dwCallback;
  RECTHelper_2 rc;
  int hDC;
}

struct MCI_ANIM_WINDOW_PARMSHelper {
  mixin(uuid("8edebea5-ce2d-335d-9c7b-50ab84c0a5b1"));
  int dwCallback;
  int hWnd;
  int nCmdShow;
}

struct MCI_BREAK_PARMSHelper {
  mixin(uuid("92d2865b-f430-3c88-bcd1-a87fbb06f0bd"));
  int dwCallback;
  int nVirtKey;
  int hwndBreak;
}

struct MCI_GENERIC_PARMSHelper {
  mixin(uuid("1860cd39-1d5c-3e45-a608-2ed95e4a6683"));
  int dwCallback;
}

struct MCI_GETDEVCAPS_PARMSHelper {
  mixin(uuid("54b49a6b-86ff-3a98-962e-135b6e579744"));
  int dwCallback;
  int dwReturn;
  int dwItem;
}

struct MCI_INFO_PARMSHelper {
  mixin(uuid("b0dcc88c-eba8-38a3-b716-4169dc089945"));
  int dwCallback;
  int dwRetSize;
}

struct MCI_LOAD_PARMSHelper {
  mixin(uuid("13d83920-e1b0-3e67-87d0-079638b73df2"));
  int dwCallback;
}

struct MCI_OPEN_PARMSHelper {
  mixin(uuid("c3e9804f-a3b4-3ea1-9b8b-929eac99cf27"));
  int dwCallback;
  int wDeviceID;
}

struct MCI_OVLY_LOAD_PARMSHelper {
  mixin(uuid("37329b22-59bf-3291-8367-7a989b02213e"));
  int dwCallback;
  RECTHelper_2 rc;
}

struct MCI_OVLY_OPEN_PARMSHelper {
  mixin(uuid("51cda7de-e9ae-3b64-9e6b-0ff21ee5ede7"));
  int dwCallback;
  int wDeviceID;
  int dwStyle;
  int hwndParent;
}

struct MCI_OVLY_RECT_PARMSHelper {
  mixin(uuid("c21890a5-123f-3222-9ca2-d7050fbcff76"));
  int dwCallback;
  RECTHelper_2 rc;
}

struct MCI_OVLY_SAVE_PARMSHelper {
  mixin(uuid("e4453fd3-9b9e-30b2-b660-4bb9e643d506"));
  int dwCallback;
  RECTHelper_2 rc;
}

struct MCI_OVLY_WINDOW_PARMSHelper {
  mixin(uuid("512726af-abdc-34a8-b5b8-09c045752a89"));
  int dwCallback;
  int hWnd;
  int nCmdShow;
}

struct MCI_PLAY_PARMSHelper {
  mixin(uuid("93a738b1-6c40-3dc1-83fe-dba42f8dd638"));
  int dwCallback;
  int dwFrom;
  int dwTo;
}

struct MCI_RECORD_PARMSHelper {
  mixin(uuid("78c4cd92-3bb2-3249-b165-7e9dfe93d642"));
  int dwCallback;
  int dwFrom;
  int dwTo;
}

struct MCI_SAVE_PARMSHelper {
  mixin(uuid("6d0a67e1-c79c-3c4d-ae85-62f532a51e51"));
  int dwCallback;
}

struct MCI_SEEK_PARMSHelper {
  mixin(uuid("a40a6989-95f2-3850-b4a6-4fcca5e3d70f"));
  int dwCallback;
  int dwTo;
}

struct MCI_SEQ_SET_PARMSHelper {
  mixin(uuid("3720c6b5-d5e0-3810-b7b3-477b7c5e01d5"));
  int dwCallback;
  int dwTimeFormat;
  int dwAudio;
  int dwTempo;
  int dwPort;
  int dwSlave;
  int dwMaster;
  int dwOffset;
}

struct MCI_SET_PARMSHelper {
  mixin(uuid("7d883fae-71c2-3f99-8b59-519423ab2781"));
  int dwCallback;
  int dwTimeFormat;
  int dwAudio;
}

struct MCI_STATUS_PARMSHelper {
  mixin(uuid("6dda627d-6bd3-390d-965d-50174d908750"));
  int dwCallback;
  int dwReturn;
  int dwItem;
  int dwTrack;
}

struct MCI_SYSINFO_PARMSHelper {
  mixin(uuid("e2817916-d629-34c3-b224-ff62e0571234"));
  int dwCallback;
  int dwRetSize;
  int dwNumber;
  int wDeviceType;
}

struct MCI_VD_ESCAPE_PARMSHelper {
  mixin(uuid("b102f116-29ef-33dd-b946-e8c6fe6c5d8b"));
  int dwCallback;
}

struct MCI_VD_PLAY_PARMSHelper {
  mixin(uuid("1a215360-bb3c-32a3-8030-fb54abc89b23"));
  int dwCallback;
  int dwFrom;
  int dwTo;
  int dwSpeed;
}

struct MCI_VD_STEP_PARMSHelper {
  mixin(uuid("4a2dc8a5-6071-3d53-9acd-3ba084ae8f66"));
  int dwCallback;
  int dwFrames;
}

struct MCI_WAVE_DELETE_PARMSHelper {
  mixin(uuid("a57dfa36-f335-38d5-9b23-5a2a8ba7456f"));
  int dwCallback;
  int dwFrom;
  int dwTo;
}

struct MCI_WAVE_OPEN_PARMSHelper {
  mixin(uuid("2d1920d0-6cb4-3d88-b794-37aefd0a5e0a"));
  int dwCallback;
  int wDeviceID;
  int dwBufferSeconds;
}

struct MCI_WAVE_SET_PARMSHelper {
  mixin(uuid("fe773632-d1fc-3ca3-a220-ff79d101816b"));
  int dwCallback;
  int dwTimeFormat;
  int dwAudio;
  int wInput;
  int wOutput;
  short wFormatTag;
  short wReserved2;
  short nChannels;
  short wReserved3;
  int nSamplesPerSec;
  int nAvgBytesPerSec;
  short nBlockAlign;
  short wReserved4;
  short wBitsPerSample;
  short wReserved5;
}

struct MDICREATESTRUCTHelper {
  mixin(uuid("73fd56ed-3783-3754-a12b-6326fbb2dfda"));
  int hOwner;
  int x;
  int y;
  int cx;
  int cy;
  int style;
  int lParam;
}

struct MDINEXTMENUHelper {
  mixin(uuid("8ebd073f-a53d-3caf-b1b7-9b7c4c6538c8"));
  int hmenuIn;
  int hmenuNext;
  int hwndNext;
}

struct MEASUREITEMSTRUCTHelper {
  mixin(uuid("eda0e49f-e5cd-3955-87c5-a9e345bf9681"));
  int CtlType;
  int CtlID;
  int itemID;
  int itemWidth;
  int itemHeight;
  int itemData;
}

struct MEMORYSTATUSHelper {
  mixin(uuid("d59dab52-2aae-35ee-b7b4-fce922ed58d2"));
  int dwLength;
  int dwMemoryLoad;
  int dwTotalPhys;
  int dwAvailPhys;
  int dwTotalPageFile;
  int dwAvailPageFile;
  int dwTotalVirtual;
  int dwAvailVirtual;
}

struct MEMORY_BASIC_INFORMATIONHelper {
  mixin(uuid("8fc6000d-16ac-3776-9606-fa10bc3ae99b"));
  int BaseAddress;
  int AllocationBase;
  int AllocationProtect;
  int RegionSize;
  int state;
  int Protect;
  int Type;
}

struct MENUITEMINFOHelper {
  mixin(uuid("d6bfeb55-dfcf-32fe-b273-10f15d53b973"));
  int cbSize;
  int fMask;
  int fType;
  int fState;
  int wID;
  int hSubMenu;
  int hbmpChecked;
  int hbmpUnchecked;
  int dwItemData;
  int dwTypeData;
  int cch;
}

struct MENUITEMINFO_THelper {
  mixin(uuid("cd39c37a-db3d-33d2-bfd6-070d6ff9dca9"));
  int cbSize;
  int fMask;
  int fType;
  int fState;
  int wID;
  int hSubMenu;
  int hbmpChecked;
  int hbmpUnchecked;
  int dwItemData;
  int cch;
}

struct METAFILEPICTHelper {
  mixin(uuid("f25b9da1-8764-3d1c-aee5-53e83361961f"));
  int mm;
  int xExt;
  int yExt;
  int hMF;
}

struct MIDIHDRHelper {
  mixin(uuid("1e9fb8c6-ebb3-36e1-ad34-637fa20f855e"));
  wchar* lpData;
  int dwBufferLength;
  int dwBytesRecorded;
  int dwUser;
  int dwFlags;
  int lpNext;
  int reserved;
  int dwOffset;
  int[8] dwReserved;
}

struct MIDIINCAPSHelper {
  mixin(uuid("6775cde1-c122-32fe-9958-dd64477fa11f"));
  short wMid;
  short wPid;
  int vDriverVersion;
  int dwSupport;
}

struct MIDIOUTCAPSHelper {
  mixin(uuid("e7623300-5fab-3e2b-b3ea-4275118ca3c5"));
  short wMid;
  short wPid;
  int vDriverVersion;
  short wTechnology;
  short wVoices;
  short wNotes;
  short wChannelMask;
  int dwSupport;
}

struct MIDIPROPTEMPOHelper {
  mixin(uuid("10289558-10b9-398f-bd41-b804217e4979"));
  int cbStruct;
  int dwTempo;
}

struct MIDIPROPTIMEDIVHelper {
  mixin(uuid("24ea3448-2e32-3165-9d2f-b7f53f665823"));
  int cbStruct;
  int dwTimeDiv;
}

struct MIDISTRMBUFFVERHelper {
  mixin(uuid("172d53d8-4fa8-381c-b1f9-dba34370a571"));
  int dwVersion;
  int dwMid;
  int dwOEMVersion;
}

struct MINIMIZEDMETRICSHelper {
  mixin(uuid("647f8bcd-0e58-336b-8bb1-909784539c11"));
  int cbSize;
  int iWidth;
  int iHorzGap;
  int iVertGap;
  int iArrange;
}

struct MINMAXINFOHelper {
  mixin(uuid("682cf390-9191-3077-be55-1b31d21c797a"));
  POINTHelper ptReserved;
  POINTHelper ptMaxSize;
  POINTHelper ptMaxPosition;
  POINTHelper ptMinTrackSize;
  POINTHelper ptMaxTrackSize;
}

struct MINMAXINFO_XHelper {
  mixin(uuid("72278f94-5145-356d-a6b3-b52098720af7"));
  int ptReserved_x;
  int ptReserved_y;
  int ptMaxSize_x;
  int ptMaxSize_y;
  int ptMaxPosition_x;
  int ptMaxPosition_y;
  int ptMinTrackSize_x;
  int ptMinTrackSize_y;
  int ptMaxTrackSize_x;
  int ptMaxTrackSize_y;
}

struct MIXERCAPSHelper {
  mixin(uuid("52178848-0de6-3411-94b5-43e5e1c2e295"));
  short wMid;
  short wPid;
  int vDriverVersion;
  int fdwSupport;
  int cDestinations;
}

struct MIXERCONTROLDETAILSHelper {
  mixin(uuid("9de780f2-8ef8-3ada-bc1b-f1b58f8c1f85"));
  int cbStruct;
  int dwControlID;
  int cChannels;
  int hwndOwner;
  int cbDetails;
  int paDetails;
}

struct MIXERCONTROLDETAILS_BOOLEANHelper {
  mixin(uuid("49e4f78b-debd-3426-92b0-c9c799de8adc"));
  int fValue;
}

struct MIXERCONTROLDETAILS_LISTTEXTHelper {
  mixin(uuid("bae9e077-8ad3-37de-9454-73d9ac7eb8ea"));
  int dwParam1;
  int dwParam2;
}

struct MIXERCONTROLDETAILS_SIGNEDHelper {
  mixin(uuid("647c1e71-3094-3df3-be8a-b2b7fdbf18fc"));
  int lValue;
}

struct MIXERCONTROLDETAILS_UNSIGNEDHelper {
  mixin(uuid("c3887935-8b4e-31f1-8e51-cdfaab72f615"));
  int dwValue;
}

struct MIXERLINEHelper {
  mixin(uuid("48a56d78-3556-3473-9339-017b5912eb33"));
  int cbStruct;
  int dwDestination;
  int dwSource;
  int dwLineID;
  int fdwLine;
  int dwUser;
  int dwComponentType;
  int cChannels;
  int cConnections;
  int cControls;
  int Target_dwType;
  int Target_dwDeviceID;
  short Target_wMid;
  short Target_wPid;
  int Target_vDriverVersion;
}

struct MIXERLINECONTROLSHelper {
  mixin(uuid("05932897-183c-3e4f-becb-6031822b497e"));
  int cbStruct;
  int dwLineID;
  int dwControlID;
  int cControls;
  int cbmxctrl;
  int pamxctrl;
}

struct MMCKINFOHelper {
  mixin(uuid("7aa9d857-5e88-3f9e-93a4-f2fd594776af"));
  int ckid;
  int cksize;
  int fccType;
  int dwDataOffset;
  int dwFlags;
}

struct MMIOINFOHelper {
  mixin(uuid("c0c49767-91f0-3e1b-9fb4-71b5df4aea98"));
  int dwFlags;
  int fccIOProc;
  int pIOProc;
  int wErrorRet;
  int htask;
  int cchBuffer;
  int pchBuffer;
  int pchNext;
  int pchEndRead;
  int pchEndWrite;
  int lBufOffset;
  int lDiskOffset;
  int[3] adwInfo;
  int dwReserved1;
  int dwReserved2;
  int hmmio;
}

struct MMTIMEHelper {
  mixin(uuid("39f7a9cf-7917-3c1f-9b94-e01f13e2c4b5"));
  int wTime;
  int ms;
  int hi;
}

struct MOUSEHOOKSTRUCTHelper {
  mixin(uuid("250f51c7-695c-3d39-98ce-e237ab434fb5"));
  POINTHelper pt;
  int hWnd;
  int wHitTestCode;
  int dwExtraInfo;
}

struct MOUSEKEYSHelper {
  mixin(uuid("7c0b95bc-eefe-39a4-bb02-6dff31fa7871"));
  int cbSize;
  int dwFlags;
  int iMaxSpeed;
  int iTimeToMaxSpeed;
  int iCtrlSpeed;
  int dwReserved1;
  int dwReserved2;
}

struct MSGHelper {
  mixin(uuid("4829788f-71a9-36c0-960e-4f700837d1fd"));
  int hWnd;
  int message;
  int wParam;
  int lParam;
  int Time;
  int pt_x;
  int pt_y;
}

struct MSGBOXPARAMSHelper {
  mixin(uuid("b57028bc-e44d-366c-9025-7274acd348bd"));
  int cbSize;
  int hwndOwner;
  int hInstance;
  int dwStyle;
  int dwContextHelpId;
  int lpfnMsgBoxCallback;
  int dwLanguageId;
}

struct NCCALCSIZE_PARAMSHelper {
  mixin(uuid("e92d46e8-676a-3718-8f7b-8c2df99f5df7"));
  RECTHelper_2 rgrc0;
  RECTHelper_2 rgrc1;
  RECTHelper_2 rgrc2;
  int lppos;
}

struct NEWTEXTMETRICHelper {
  mixin(uuid("8848f7de-93fa-3199-b004-613d018f4f7c"));
  int TEXTMETRICHelper_tmHeight;
  int TEXTMETRICHelper_tmAscent;
  int TEXTMETRICHelper_tmDescent;
  int TEXTMETRICHelper_tmInternalLeading;
  int TEXTMETRICHelper_tmExternalLeading;
  int TEXTMETRICHelper_tmAveCharWidth;
  int TEXTMETRICHelper_tmMaxCharWidth;
  int TEXTMETRICHelper_tmWeight;
  int TEXTMETRICHelper_tmOverhang;
  int TEXTMETRICHelper_tmDigitizedAspectX;
  int TEXTMETRICHelper_tmDigitizedAspectY;
  byte TEXTMETRICHelper_tmItalic;
  byte TEXTMETRICHelper_tmUnderlined;
  byte TEXTMETRICHelper_tmStruckOut;
  byte TEXTMETRICHelper_tmPitchAndFamily;
  byte TEXTMETRICHelper_tmCharSet;
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
  byte tmItalic;
  byte tmUnderlined;
  byte tmStruckOut;
  byte tmPitchAndFamily;
  byte tmCharSet;
  int ntmFlags;
  int ntmSizeEM;
  int ntmCellHeight;
  int ntmAvgWidth;
}

struct NEWTEXTMETRICEXHelper {
  mixin(uuid("e2e26966-12a3-394e-979a-f68657f413a8"));
  int TEXTMETRICHelper_tmHeight;
  int TEXTMETRICHelper_tmAscent;
  int TEXTMETRICHelper_tmDescent;
  int TEXTMETRICHelper_tmInternalLeading;
  int TEXTMETRICHelper_tmExternalLeading;
  int TEXTMETRICHelper_tmAveCharWidth;
  int TEXTMETRICHelper_tmMaxCharWidth;
  int TEXTMETRICHelper_tmWeight;
  int TEXTMETRICHelper_tmOverhang;
  int TEXTMETRICHelper_tmDigitizedAspectX;
  int TEXTMETRICHelper_tmDigitizedAspectY;
  byte TEXTMETRICHelper_tmItalic;
  byte TEXTMETRICHelper_tmUnderlined;
  byte TEXTMETRICHelper_tmStruckOut;
  byte TEXTMETRICHelper_tmPitchAndFamily;
  byte TEXTMETRICHelper_tmCharSet;
  int NEWTEXTMETRICHelper_tmHeight;
  int NEWTEXTMETRICHelper_tmAscent;
  int NEWTEXTMETRICHelper_tmDescent;
  int NEWTEXTMETRICHelper_tmInternalLeading;
  int NEWTEXTMETRICHelper_tmExternalLeading;
  int NEWTEXTMETRICHelper_tmAveCharWidth;
  int NEWTEXTMETRICHelper_tmMaxCharWidth;
  int NEWTEXTMETRICHelper_tmWeight;
  int NEWTEXTMETRICHelper_tmOverhang;
  int NEWTEXTMETRICHelper_tmDigitizedAspectX;
  int NEWTEXTMETRICHelper_tmDigitizedAspectY;
  byte NEWTEXTMETRICHelper_tmItalic;
  byte NEWTEXTMETRICHelper_tmUnderlined;
  byte NEWTEXTMETRICHelper_tmStruckOut;
  byte NEWTEXTMETRICHelper_tmPitchAndFamily;
  byte NEWTEXTMETRICHelper_tmCharSet;
  int NEWTEXTMETRICHelper_ntmFlags;
  int NEWTEXTMETRICHelper_ntmSizeEM;
  int NEWTEXTMETRICHelper_ntmCellHeight;
  int NEWTEXTMETRICHelper_ntmAvgWidth;
  FONTSIGNATUREHelper ntmFontSig;
}

struct NMCUSTOMDRAWHelper {
  mixin(uuid("1fdea639-c16e-3f12-83bf-260436df5614"));
  NMHDRHelper hdr;
  int dwDrawStage;
  int hDC;
  RECTHelper_2 rc;
  int dwItemSpec;
  int uItemState;
  int lItemlParam;
}

struct NMDATETIMECHANGEHelper {
  mixin(uuid("10a33eee-bf0a-35af-8abe-3db6d5739454"));
  NMHDRHelper NMHDR;
  int dwFlags;
  SYSTEMTIMEHelper st;
}

struct NMDATETIMEFORMATHelper {
  mixin(uuid("aa09f943-c800-3657-bebe-fd03dd43e29e"));
  NMHDRHelper NMHDR;
  SYSTEMTIMEHelper st;
}

struct NMDATETIMEFORMATQUERYHelper {
  mixin(uuid("8181b08a-da0b-381e-bb9a-3253f2040e68"));
  NMHDRHelper NMHDR;
  SIZEHelper szMax;
}

struct NMDATETIMESTRINGHelper {
  mixin(uuid("7b7691bc-9b85-3f0a-96e1-19d25b302ccd"));
  NMHDRHelper NMHDR;
  SYSTEMTIMEHelper st;
  int dwFlags;
}

struct NMDATETIMEWMKEYDOWNHelper {
  mixin(uuid("f1a8cad4-6f8f-3bd9-8889-2b2a67fee019"));
  NMHDRHelper NMHDR;
  int nVirtKey;
  SYSTEMTIMEHelper st;
}

struct NMDAYSTATEHelper {
  mixin(uuid("0f16158c-b59a-369e-b52d-a76da261fe35"));
  NMHDRHelper NMHDR;
  SYSTEMTIMEHelper stStart;
  int cDayState;
  int prgDayState;
}

struct NMHDRHelper {
  mixin(uuid("0d500575-4ce3-3d24-80e1-a49b00a7d412"));
  int hwndFrom;
  int idFrom;
  int code;
}

struct NMHEADERHelper {
  mixin(uuid("fbfc4c7d-5412-369f-8719-bf1a3c9ef702"));
  NMHDRHelper hdr;
  int iItem;
  int iButton;
  int pitem;
}

struct NMITEMACTIVATEHelper {
  mixin(uuid("7d49c801-681d-3d0b-8ffe-5e0bc2976642"));
  NMHDRHelper hdr;
  int iItem;
  int iSubItem;
  int uNewState;
  int uOldState;
  int uChanged;
  POINTHelper ptAction;
  int lParam;
  int uKeyFlags;
}

struct NMLISTVIEWHelper {
  mixin(uuid("ab14d105-9e5c-310b-a0b6-376aec4427d9"));
  NMHDRHelper hdr;
  int iItem;
  int iSubItem;
  int uNewState;
  int uOldState;
  int uChanged;
  int ptAction_x;
  int ptAction_y;
  int lParam;
}

struct NMLVCACHEHINTHelper {
  mixin(uuid("65688eb1-c182-3a2a-994a-93e5be3f3745"));
  NMHDRHelper hdr;
  int iFrom;
  int iTo;
}

struct NMLVCUSTOMDRAWHelper {
  mixin(uuid("b8af6af7-c117-3578-b78c-00f8e5afdd12"));
  NMCUSTOMDRAWHelper nmcd;
  int clrText;
  int clrTextBk;
}

struct NMLVDISPINFOHelper {
  mixin(uuid("3169aa26-14c3-312c-98a2-47b3a6f52cbe"));
  NMHDRHelper hdr;
  LVITEMHelper item;
}

struct NMLVFINDITEMHelper {
  mixin(uuid("f0b764ae-a582-3708-b490-a90154453826"));
  NMHDRHelper hdr;
  int iStart;
  LVFINDINFOHelper lvfi;
}

struct NMLVKEYDOWNHelper {
  mixin(uuid("e164c621-7b0a-30ea-9dd0-65da644e6702"));
  NMHDRHelper hdr;
  short wVKey;
  int Flags;
}

struct NMLVODSTATECHANGEHelper {
  mixin(uuid("00baa654-1cb3-34ea-9869-16e34b5038d1"));
  NMHDRHelper hdr;
  int iFrom;
  int iTo;
  int uNewState;
  int uOldState;
}

struct NMRBAUTOSIZEHelper {
  mixin(uuid("ea6a3d26-739b-3203-91af-89f596fd4e97"));
  NMHDRHelper hdr;
  int fChanged;
  RECTHelper_2 rcTarget;
  RECTHelper_2 rcActual;
}

struct NMREBARHelper {
  mixin(uuid("b7635fbf-e439-390e-bec4-aff66ccb2d16"));
  NMHDRHelper hdr;
  int dwMask;
  int uBand;
  int fStyle;
  int wID;
  int lParam;
}

struct NMREBARCHILDSIZEHelper {
  mixin(uuid("3d316361-713f-3c90-8174-4499324bf580"));
  NMHDRHelper hdr;
  int uBand;
  int wID;
  RECTHelper_2 rcChild;
  RECTHelper_2 rcBand;
}

struct NMSELCHANGEHelper {
  mixin(uuid("af8b3a27-3756-3c4c-87f1-2f9dec696dfe"));
  NMHDRHelper NMHDR;
  SYSTEMTIMEHelper stSelStart;
  SYSTEMTIMEHelper stSelEnd;
}

struct NMTCKEYDOWNHelper {
  mixin(uuid("9a2e351c-5799-3a85-acba-bf4c5bc95d52"));
  NMHDRHelper hdr;
  short wVKey;
  int Flags;
}

struct NMTOOLBARHelper {
  mixin(uuid("ed359250-4e79-3bfc-b02c-471da302c478"));
  NMHDRHelper hdr;
  int iItem;
  TBBUTTONHelper TBBUTTON;
  int cchText;
  int pszText;
}

struct NMTREEVIEWHelper {
  mixin(uuid("3f98c88b-3a80-36ff-9004-0284c13a8dd8"));
  NMHDRHelper NMHDR;
  int action;
  TV_ITEMHelper itemOld;
  TV_ITEMHelper itemNew;
  POINTHelper ptDrag;
}

struct NMTREEVIEW_THelper {
  mixin(uuid("3ff4d044-b7b7-3320-9eaf-24726e5aaead"));
  NMHDRHelper NMHDR;
  int action;
  TV_ITEM_THelper itemOld;
  TV_ITEM_THelper itemNew;
  POINTHelper ptDrag;
}

struct NMTVCUSTOMDRAWHelper {
  mixin(uuid("b6087e67-7b85-3189-a54e-4dbd69aa7a93"));
  NMCUSTOMDRAWHelper nmcd;
  int clrText;
  int clrTextBk;
}

struct NMTVDISPINFOHelper {
  mixin(uuid("2cc3adf8-76df-32a4-b324-49adfd68f91a"));
  NMHDRHelper hdr;
  TV_ITEMHelper item;
}

struct NMTVDISPINFO_THelper {
  mixin(uuid("db909e91-1fed-3fdd-ae53-c6435204cf3a"));
  NMHDRHelper hdr;
  TV_ITEM_THelper item;
}

struct NMTVKEYDOWNHelper {
  mixin(uuid("10957f2e-8848-3e30-b185-a4a9811f70f3"));
  NMHDRHelper hdr;
  short wVKey;
  int Flags;
}

struct NMUPDOWNHelper {
  mixin(uuid("708cdbbe-4121-3a78-9407-1f77075331c5"));
  NMHDRHelper hdr;
  int iPos;
  int iDelta;
}

struct NONCLIENTMETRICSHelper {
  mixin(uuid("be60d07b-f1b8-3d27-ab6a-298e75305dcc"));
  int cbSize;
  int iBorderWidth;
  int iScrollWidth;
  int iScrollHeight;
  int iCaptionWidth;
  int iCaptionHeight;
  LOGFONTHelper lfCaptionFont;
  int iSmCaptionWidth;
  int iSmCaptionHeight;
  LOGFONTHelper lfSmCaptionFont;
  int iMenuWidth;
  int iMenuHeight;
  LOGFONTHelper lfMenuFont;
  LOGFONTHelper lfStatusFont;
  LOGFONTHelper lfMessageFont;
}

struct NOTIFYICONDATAHelper {
  mixin(uuid("10c5843d-2d61-3098-bca0-625c708f4ed4"));
  int cbSize;
  int hWnd;
  int uID;
  int uFlags;
  int uCallbackMessage;
  int hIcon;
}

struct NUMBERFMTHelper {
  mixin(uuid("bde8c98a-da3a-3034-b575-ffb4f6ff93c8"));
  int NumDigits;
  int LeadingZero;
  int Grouping;
  int NegativeOrder;
}

struct OFNOTIFYHelper {
  mixin(uuid("61bbfd6f-9c98-3981-990b-55d49b82d756"));
  int hdr_hwndFrom;
  int hdr_idFrom;
  int hdr_code;
  int lpOFN;
  int pszFile;
}

struct OFSTRUCTHelper {
  mixin(uuid("d1a2bebf-eb1a-3c29-b932-8d96c4086307"));
  byte cBytes;
  byte fFixedDisk;
  short nErrCode;
  short Reserved1;
  short Reserved2;
  ubyte[128] szPathName;
}

struct OPENFILENAMEHelper {
  mixin(uuid("949c14e1-1d95-3f94-85d8-9787766742cd"));
  int lStructSize;
  int hwndOwner;
  int hInstance;
  int lpstrCustomFilter;
  int nMaxCustFilter;
  int nFilterIndex;
  int nMaxFile;
  int nMaxFileTitle;
  int Flags;
  short nFileOffset;
  short nFileExtension;
  int lCustData;
  int lpfnHook;
}

struct OPENFILENAME_IHelper {
  mixin(uuid("5bea655c-7fd2-3c80-ae97-36d3edd89c7a"));
  int lStructSize;
  int hwndOwner;
  int hInstance;
  int lpstrCustomFilter;
  int nMaxCustFilter;
  int nFilterIndex;
  int lpstrFile;
  int nMaxFile;
  int lpstrFileTitle;
  int nMaxFileTitle;
  int Flags;
  short nFileOffset;
  short nFileExtension;
  int lCustData;
  int lpfnHook;
}

struct OSVERSIONINFOHelper {
  mixin(uuid("67bb3fcb-99fd-3691-a775-d9988024fcd9"));
  int dwOSVersionInfoSize;
  int dwMajorVersion;
  int dwMinorVersion;
  int dwBuildNumber;
  int dwPlatformId;
}

struct OUTLINETEXTMETRICHelper {
  mixin(uuid("44c53c9f-4637-3986-984f-7efe4d9fb215"));
  int otmSize;
  int otmTextMetrics_tmHeight;
  int otmTextMetrics_tmAscent;
  int otmTextMetrics_tmDescent;
  int otmTextMetrics_tmInternalLeading;
  int otmTextMetrics_tmExternalLeading;
  int otmTextMetrics_tmAveCharWidth;
  int otmTextMetrics_tmMaxCharWidth;
  int otmTextMetrics_tmWeight;
  int otmTextMetrics_tmOverhang;
  int otmTextMetrics_tmDigitizedAspectX;
  int otmTextMetrics_tmDigitizedAspectY;
  byte otmTextMetrics_tmItalic;
  byte otmTextMetrics_tmUnderlined;
  byte otmTextMetrics_tmStruckOut;
  byte otmTextMetrics_tmPitchAndFamily;
  byte otmTextMetrics_tmCharSet;
  byte otmFiller1;
  byte otmFiller2;
  byte otmFiller3;
  byte otmPanoseNumber_bFamilyType;
  byte otmPanoseNumber_bSerifStyle;
  byte otmPanoseNumber_bWeight;
  byte otmPanoseNumber_bProportion;
  byte otmPanoseNumber_bContrast;
  byte otmPanoseNumber_bStrokeVariation;
  byte otmPanoseNumber_bArmStyle;
  byte otmPanoseNumber_bLetterform;
  byte otmPanoseNumber_bMidline;
  byte otmPanoseNumber_bXHeight;
  byte otmFiller4;
  byte otmFiller5;
  int otmfsSelection;
  int otmfsType;
  int otmsCharSlopeRise;
  int otmsCharSlopeRun;
  int otmItalicAngle;
  int otmEMSquare;
  int otmAscent;
  int otmDescent;
  int otmLineGap;
  int otmsCapEmHeight;
  int otmsXHeight;
  int otmrcFontBox_left;
  int otmrcFontBox_top;
  int otmrcFontBox_right;
  int otmrcFontBox_bottom;
  int otmMacAscent;
  int otmMacDescent;
  int otmMacLineGap;
  int otmusMinimumPPEM;
  int otmptSubscriptSize_x;
  int otmptSubscriptSize_y;
  int otmptSubscriptOffset_x;
  int otmptSubscriptOffset_y;
  int otmptSuperscriptSize_x;
  int otmptSuperscriptSize_y;
  int otmptSuperscriptOffset_x;
  int otmptSuperscriptOffset_y;
  int otmsStrikeoutSize;
  int otmsStrikeoutPosition;
  int otmsUnderscoreSize;
  int otmsUnderscorePosition;
  int otmpFamilyName;
  int otmpFaceName;
  int otmpStyleName;
  int otmpFullName;
}

struct OVERLAPPEDHelper {
  mixin(uuid("ac5e7513-a18b-3256-8549-993a187b3798"));
  int Internal;
  int InternalHigh;
  int offset;
  int OffsetHigh;
  int hEvent;
}

struct PAGESETUPDLGHelper {
  mixin(uuid("fea49d47-b07e-3cc6-8c17-3a99ad0eff88"));
  int lStructSize;
  int hwndOwner;
  int hDevMode;
  int hDevNames;
  int Flags;
  int ptPaperSize_x;
  int ptPaperSize_y;
  int rtMinMargin_left;
  int rtMinMargin_top;
  int rtMinMargin_right;
  int rtMinMargin_bottom;
  int rtMargin_left;
  int rtMargin_top;
  int rtMargin_right;
  int rtMargin_bottom;
  int hInstance;
  int lCustData;
  int lpfnPageSetupHook;
  int lpfnPagePaintHook;
  int hPageSetupTemplate;
}

struct PAINTSTRUCTHelper {
  mixin(uuid("c0e78818-233f-340b-92ed-bed093fb6e52"));
  int hDC;
  int fErase;
  int rcPaint_left;
  int rcPaint_top;
  int rcPaint_right;
  int rcPaint_bottom;
  int fRestore;
  int fIncUpdate;
  int Reserved1;
  int Reserved2;
  int reserved3;
  int reserved4;
  int reserved5;
  int reserved6;
  int reserved7;
  int reserved8;
}

struct PALETTEENTRYHelper {
  mixin(uuid("8a0ff1b7-9dfa-366b-833b-cf8501ab515a"));
  byte peRed;
  byte peGreen;
  byte peBlue;
  byte peFlags;
}

struct PANOSEHelper {
  mixin(uuid("d52dfa6e-e03a-3382-b1c1-272e2b121059"));
  byte bFamilyType;
  byte bSerifStyle;
  byte bWeight;
  byte bProportion;
  byte bContrast;
  byte bStrokeVariation;
  byte bArmStyle;
  byte bLetterform;
  byte bMidline;
  byte bXHeight;
}

struct PARAFORMATHelper {
  mixin(uuid("917f6432-42a1-3d73-bfaa-eb0668a6f7c8"));
  int cbSize;
  int dwMask;
  short wNumbering;
  short wReserved;
  int dxStartIndent;
  int dxRightIndent;
  int dxOffset;
  short wAlignment;
  short cTabCount;
  int[32] rgxTabs;
}

struct PBRANGEHelper {
  mixin(uuid("96aab5be-4e14-3a48-9dcd-2795dd0bc2ca"));
  int iLow;
  int iHigh;
}

struct PIXELFORMATDESCRIPTORHelper {
  mixin(uuid("4e669544-df96-3c2f-95d3-819a447ff577"));
  short nSize;
  short nVersion;
  int dwFlags;
  byte iPixelType;
  byte cColorBits;
  byte cRedBits;
  byte cRedShift;
  byte cGreenBits;
  byte cGreenShift;
  byte cBlueBits;
  byte cBlueShift;
  byte cAlphaBits;
  byte cAlphaShift;
  byte cAccumBits;
  byte cAccumRedBits;
  byte cAccumGreenBits;
  byte cAccumBlueBits;
  byte cAccumAlphaBits;
  byte cDepthBits;
  byte cStencilBits;
  byte cAuxBuffers;
  byte iLayerType;
  byte bReserved;
  int dwLayerMask;
  int dwVisibleMask;
  int dwDamageMask;
}

struct POINTHelper {
  mixin(uuid("8771e5cb-30fa-380a-aa1a-9e3f1d915022"));
  int x;
  int y;
}

struct POLYTEXTHelper {
  mixin(uuid("138f8c3d-7bef-3667-94b6-eefcfa77abee"));
  int x;
  int y;
  int n;
  int lpstr;
  int uiFlags;
  int rcl_left;
  int rcl_top;
  int rcl_right;
  int rcl_bottom;
  int pdx;
}

struct PRINTDLGHelper {
  mixin(uuid("ce74d68c-0b71-3386-a200-a1c49fd5d2a5"));
  int lStructSize;
  int hwndOwner;
  int hDevMode;
  int hDevNames;
  int hDC;
  int Flags;
  short nFromPage;
  short nToPage;
  short nMinPage;
  short nMaxPage;
  short nCopies;
  int hInstance;
  int lCustData;
  int lpfnPrintHook;
  int lpfnSetupHook;
  int hPrintTemplate;
  int hSetupTemplate;
}

struct PRINTER_DEFAULTSHelper {
  mixin(uuid("a95757c7-6a32-3292-8057-58a510c56909"));
  int pDatatype;
  int pDevMode;
  int DesiredAccess;
}

struct PRIVILEGE_SETHelper {
  mixin(uuid("fae24e81-8b44-3284-aa55-46704f2f5ad9"));
  int PrivilegeCount;
  int Control;
  LUID_AND_ATTRIBUTESHelper Privilege;
}

struct PROCESS_INFORMATIONHelper {
  mixin(uuid("70511cfc-5b56-3120-aff6-69bd2d183bcd"));
  int hProcess;
  int hThread;
  int dwProcessId;
  int dwThreadId;
}

struct PUNCTUATIONHelper {
  mixin(uuid("af6f7097-8962-32d4-8a7d-aa9b00f49ebb"));
  int iSize;
}

struct RASTERIZER_STATUSHelper {
  mixin(uuid("9ff89f5d-87bb-3595-9db2-301b4b07b177"));
  short nSize;
  short wFlags;
  short nLanguageID;
}

struct RBHITTESTINFOHelper {
  mixin(uuid("e2afbc16-86cc-3179-91dd-790f9b9ebd3e"));
  POINTHelper pt;
  int Flags;
  int iBand;
}

struct REBARBANDINFOHelper {
  mixin(uuid("76b4852a-631d-37e9-bb1d-9e9bbb12fc55"));
  int cbSize;
  int fMask;
  int fStyle;
  int clrFore;
  int clrBack;
  int lpText;
  int cch;
  int iImage;
  int hwndChild;
  int cxMinChild;
  int cyMinChild;
  int cx;
  int hbmBack;
  int wID;
}

struct REBARBANDINFO_IE4Helper {
  mixin(uuid("6f350d20-6482-3cc4-9cd5-d83e53968428"));
  int REBARBANDINFOHelper_cbSize;
  int REBARBANDINFOHelper_fMask;
  int REBARBANDINFOHelper_fStyle;
  int REBARBANDINFOHelper_clrFore;
  int REBARBANDINFOHelper_clrBack;
  int REBARBANDINFOHelper_lpText;
  int REBARBANDINFOHelper_cch;
  int REBARBANDINFOHelper_iImage;
  int REBARBANDINFOHelper_hwndChild;
  int REBARBANDINFOHelper_cxMinChild;
  int REBARBANDINFOHelper_cyMinChild;
  int REBARBANDINFOHelper_cx;
  int REBARBANDINFOHelper_hbmBack;
  int REBARBANDINFOHelper_wID;
  int cyChild;
  int cyMaxChild;
  int cyIntegral;
  int cxIdeal;
  int lParam;
  int cxHeader;
}

struct REBARINFOHelper {
  mixin(uuid("10bdbad6-1aa1-3710-a07c-efd73d9fe579"));
  int cbSize;
  int fMask;
  int himl;
}

struct RECTLHelper {
  mixin(uuid("ff204708-dcfa-3104-a98a-837094876995"));
  int left;
  int top;
  int right;
  int bottom;
}

struct REPASTESPECIALHelper {
  mixin(uuid("0ec52f88-07e1-34a3-91a2-3340495d6e9b"));
  int dwAspect;
  int dwParam;
}

struct REQRESIZEHelper {
  mixin(uuid("8bfb819f-d7cf-30c5-b3da-045a22a4415b"));
  NMHDRHelper NMHDR;
  RECTHelper_2 rc;
}

struct RGBQUADHelper {
  mixin(uuid("6d3ec64c-174e-36b4-a327-71b8706f569b"));
  byte rgbBlue;
  byte rgbGreen;
  byte rgbRed;
  byte rgbReserved;
}

struct SCROLLINFOHelper {
  mixin(uuid("a7b27b09-663c-3bd4-9e14-f70d6cf470d3"));
  int cbSize;
  int fMask;
  int nMin;
  int nMax;
  int nPage;
  int nPos;
  int nTrackPos;
}

struct SECURITY_ATTRIBUTESHelper {
  mixin(uuid("132088f7-7760-3e3a-bbec-00cc0566d335"));
  int nLength;
  int lpSecurityDescriptor;
  int bInheritHandle;
}

struct SELCHANGEHelper {
  mixin(uuid("8c8d9f32-e4cb-37dc-ac28-e02923f87d1c"));
  NMHDRHelper NMHDR;
  CHARRANGEHelper chrg;
  short seltyp;
}

struct SERIALKEYSHelper {
  mixin(uuid("95642fa4-5045-3d14-8c74-2dd1d1528f46"));
  int cbSize;
  int dwFlags;
  int iBaudRate;
  int iPortState;
  int iActive;
}

struct SHELLEXECUTEINFOHelper {
  mixin(uuid("efce1a0f-6be3-330d-95d3-db57954aaca8"));
  int cbSize;
  int fMask;
  int hWnd;
  int nShow;
  int hInstApp;
  int lpIDList;
  int hkeyClass;
  int dwHotKey;
  int hIcon;
  int hProcess;
}

struct SHFILEINFOHelper {
  mixin(uuid("0f7e8d66-d5c5-3d79-8b57-1699c013d76a"));
  int hIcon;
  int iIcon;
  int dwAttributes;
}

struct SHFILEOPSTRUCTHelper {
  mixin(uuid("cc469e14-e85f-3b05-b222-847a2334e046"));
  int hWnd;
  int wFunc;
  int pFrom;
  int pTo;
  short fFlags;
  int fAnyOperationsAborted;
  int hNameMappings;
}

struct SIZEHelper {
  mixin(uuid("05427954-26d6-3475-8782-d7cdeb23d14c"));
  int cx;
  int cy;
}

struct SIZELHelper {
  mixin(uuid("a3d6e155-f18d-39be-8984-28ac6f2da3bd"));
  int cx;
  int cy;
}

struct SMALL_RECTHelper {
  mixin(uuid("4c32711d-f417-3339-9d85-ea2c37e0d2cc"));
  short left;
  short top;
  short right;
  short bottom;
}

struct SOUNDSENTRYHelper {
  mixin(uuid("a87dc063-b98e-37ba-b9ac-fbfc0de5d6cf"));
  int cbSize;
  int dwFlags;
  int iFSTextEffect;
  int iFSTextEffectMSec;
  int iFSTextEffectColorBits;
  int iFSGrafEffect;
  int iFSGrafEffectMSec;
  int iFSGrafEffectColor;
  int iWindowsEffect;
  int iWindowsEffectMSec;
  int iWindowsEffectOrdinal;
}

struct STARTUPINFOHelper {
  mixin(uuid("c911411e-e5da-3de7-a5e9-06665f623c2c"));
  int cb;
  int dwX;
  int dwY;
  int dwXSize;
  int dwYSize;
  int dwXCountChars;
  int dwYCountChars;
  int dwFillAttribute;
  int dwFlags;
  short wShowWindow;
  short cbReserved2;
  int lpReserved2;
  int hStdInput;
  int hStdOutput;
  int hStdError;
}

struct STICKYKEYSHelper {
  mixin(uuid("852f032c-f374-3b66-8954-9a891afbd3e9"));
  int cbSize;
  int dwFlags;
}

struct STYLESTRUCTHelper {
  mixin(uuid("8022ac68-673c-3b9c-b189-450fa85c3b74"));
  int styleOld;
  int styleNew;
}

struct SYSTEMTIMEHelper {
  mixin(uuid("31e5c9c1-91b1-30ea-8a77-36ffc85828e6"));
  short wYear;
  short wMonth;
  short wDayOfWeek;
  short wDay;
  short wHour;
  short wMinute;
  short wSecond;
  short wMilliseconds;
}

struct SYSTEMTIMEPAIRHelper {
  mixin(uuid("7e11be10-7ed2-348d-b5e2-41168b13e301"));
  SYSTEMTIMEHelper st0;
  SYSTEMTIMEHelper st1;
}

struct SYSTEM_INFOHelper {
  mixin(uuid("a56c40da-857c-3a4d-a6ff-60b44bb07e46"));
  short wProcessorArchitecture;
  short wReserved;
  int dwPageSize;
  int lpMinimumApplicationAddress;
  int lpMaximumApplicationAddress;
  int dwActiveProcessorMask;
  int dwNumberOfProcessors;
  int dwProcessorType;
  int dwAllocationGranularity;
  short wProcessorLevel;
  short wProcessorRevision;
}

struct SYSTEM_POWER_STATUSHelper {
  mixin(uuid("52042a97-fd78-3616-a892-2e43f9d52974"));
  byte ACLineStatus;
  byte BatteryFlag;
  byte BatteryLifePercent;
  byte Reserved1;
  int BatteryLifeTime;
  int BatteryFullLifeTime;
}

struct TBADDBITMAPHelper {
  mixin(uuid("11b8f8f3-4a22-3d8c-9d1d-494e23666df5"));
  int hInst;
  int nID;
}

struct TBBUTTONHelper {
  mixin(uuid("84384a48-93fc-3819-b15b-e69e087c3989"));
  int iBitmap;
  int idCommand;
  byte fsState;
  byte fsStyle;
  byte bReserved0;
  byte bReserved1;
  int dwData;
  int iString;
}

struct TBBUTTONINFOHelper {
  mixin(uuid("562ef709-2f2f-33c6-a976-d043b794c5bf"));
  int cbSize;
  int dwMask;
  int idCommand;
  int iImage;
  byte fsState;
  byte fsStyle;
  short cx;
  int lParam;
  int pszText;
  int cchTest;
}

struct TBBUTTONINFO_THelper {
  mixin(uuid("a4c167b4-5490-3871-949d-bfaea0f883b4"));
  int cbSize;
  int dwMask;
  int idCommand;
  int iImage;
  byte fsState;
  byte fsStyle;
  short cx;
  int lParam;
  int cchText;
}

struct TBREPLACEBITMAPHelper {
  mixin(uuid("1d6c2386-445a-3afb-8ca9-cd8779fcebb4"));
  int hInstOld;
  int nIDOld;
  int hInstNew;
  int nIDNew;
  int nButtons;
}

struct TBSAVEPARAMSHelper {
  mixin(uuid("35125067-09d9-3a10-ba36-de4a95447408"));
  int hkr;
  int pszSubKey;
  int pszValueName;
}

struct TCHITTESTINFOHelper {
  mixin(uuid("d26e149f-02e6-344c-93e5-2aa1c58dd507"));
  int pt_x;
  int pt_y;
  int Flags;
}

struct TCITEMHelper {
  mixin(uuid("1d44b5ab-f118-3d14-8423-698a0458a4b8"));
  int mask;
  int dwState;
  int dwStateMask;
  int pszText;
  int cchTextMax;
  int iImage;
  int lParam;
}

struct TCITEM_THelper {
  mixin(uuid("fddddb8f-bf99-3ce3-a5aa-776fdf4dbf00"));
  int mask;
  int dwState;
  int dwStateMask;
  int cchTextMax;
  int iImage;
  int lParam;
}

struct TC_ITEMHEADERHelper {
  mixin(uuid("3f4e3ad6-cdbf-3d6f-a01c-ca87656372f0"));
  int mask;
  int lpReserved1;
  int lpReserved2;
  int pszText;
  int cchTextMax;
  int iImage;
}

struct TEXTMETRICHelper {
  mixin(uuid("be3a6fb3-6fc9-38b6-a095-61c7d3f3ce9a"));
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
  byte tmItalic;
  byte tmUnderlined;
  byte tmStruckOut;
  byte tmPitchAndFamily;
  byte tmCharSet;
}

struct TEXTRANGEHelper {
  mixin(uuid("262facb3-d6ac-3b8d-9abd-9d7324885391"));
  CHARRANGEHelper chrg;
  int lpstrText;
}

struct TIMECAPSHelper {
  mixin(uuid("1ca6611f-01e6-3d37-9838-28e148d478ac"));
  int wPeriodMin;
  int wPeriodMax;
}

struct TIME_ZONE_INFORMATIONHelper {
  mixin(uuid("6eba3c04-0ccf-3d43-92f3-7a1050224ea8"));
  int Bias;
  ushort[32] StandardName;
  short StandardDate_wYear;
  short StandardDate_wMonth;
  short StandardDate_wDayOfWeek;
  short StandardDate_wDay;
  short StandardDate_wHour;
  short StandardDate_wMinute;
  short StandardDate_wSecond;
  short StandardDate_wMilliseconds;
  int StandardBias;
  ushort[32] DaylightName;
  short DaylightDate_wYear;
  short DaylightDate_wMonth;
  short DaylightDate_wDayOfWeek;
  short DaylightDate_wDay;
  short DaylightDate_wHour;
  short DaylightDate_wMinute;
  short DaylightDate_wSecond;
  short DaylightDate_wMilliseconds;
  int DaylightBias;
}

struct TOGGLEKEYSHelper {
  mixin(uuid("6bd45891-591c-38ed-bbcd-5da9381f7c0e"));
  int cbSize;
  int dwFlags;
}

struct TOOLINFOHelper {
  mixin(uuid("c1d6ba4d-ebd6-3ef0-b820-ecd05c55c5dd"));
  int cbSize;
  int uFlags;
  int hWnd;
  int uID;
  RECTHelper_2 rect;
  int hInst;
  int lpszText;
}

struct TOOLINFO_THelper {
  mixin(uuid("e0cab386-662b-3122-9f7d-793845ff8a8b"));
  int cbSize;
  int uFlags;
  int hWnd;
  int uID;
  RECTHelper_2 rect;
  int hInst;
  int lParam;
}

struct TOOLTIPTEXTHelper {
  mixin(uuid("31676add-ad13-3914-9fb6-8e5f46ca8077"));
  NMHDRHelper hdr;
  int lpszText;
  int hInst;
  int uFlags;
}

struct TPMPARAMSHelper {
  mixin(uuid("ad4a7205-2590-3ee7-a8f7-cc95834607b7"));
  int cbSize;
  int rcExclude_left;
  int rcExclude_top;
  int rcExclude_right;
  int rcExclude_bottom;
}

struct TRACKMOUSEEVENTHelper {
  mixin(uuid("ab9ee623-cac7-35df-be89-2e15bbdd025a"));
  int cbSize;
  int dwFlags;
  int hwndTrack;
  int dwHoverTime;
}

struct TV_HITTESTINFOHelper {
  mixin(uuid("89b1fa9a-0aaf-32e0-a6db-004aa38d467f"));
  int pt_x;
  int pt_y;
  int Flags;
  int hItem;
}

struct TV_INSERTSTRUCTHelper {
  mixin(uuid("3664b511-a577-334f-91b8-a5f1e02959dd"));
  int hParent;
  int hInsertAfter;
  int item_mask;
  int item_hItem;
  int item_state;
  int item_stateMask;
  int item_pszText;
  int item_cchTextMax;
  int item_iImage;
  int item_iSelectedImage;
  int item_cChildren;
  int item_lParam;
}

struct TV_INSERTSTRUCT_THelper {
  mixin(uuid("c4033f7d-3390-35b8-8cad-139412d820a3"));
  int hParent;
  int hInsertAfter;
  int item_mask;
  int item_hItem;
  int item_state;
  int item_stateMask;
  int item_cchTextMax;
  int item_iImage;
  int item_iSelectedImage;
  int item_cChildren;
  int item_lParam;
}

struct TV_ITEMHelper {
  mixin(uuid("da28dd6b-1b66-3c29-8cf9-4c4aac666abf"));
  int mask;
  int hItem;
  int state;
  int stateMask;
  int pszText;
  int cchTextMax;
  int iImage;
  int iSelectedImage;
  int cChildren;
  int lParam;
}

struct TV_ITEM_THelper {
  mixin(uuid("ba9e05c7-2581-3eb6-b515-0511c3e92729"));
  int mask;
  int hItem;
  int state;
  int stateMask;
  int cchTextMax;
  int iImage;
  int iSelectedImage;
  int cChildren;
  int lParam;
}

struct TV_SORTCBHelper {
  mixin(uuid("76f94a90-b8eb-3e6d-9e7f-982f004338f5"));
  int hParent;
  int lpfnCompare;
  int lParam;
}

struct UDACCELHelper {
  mixin(uuid("24081902-ba40-31b7-9511-887129660f1c"));
  int nSec;
  int nInc;
}

struct WAVEFORMATHelper {
  mixin(uuid("972a73fc-f460-3fdd-b10a-8c8d2f86e7e0"));
  short wFormatTag;
  short nChannels;
  int nSamplesPerSec;
  int nAvgBytesPerSec;
  short nBlockAlign;
}

struct WAVEFORMATEXHelper {
  mixin(uuid("7ca129b5-9623-392c-80bd-20df98760078"));
  short wFormatTag;
  short nChannels;
  int nSamplesPerSec;
  int nAvgBytesPerSec;
  short nBlockAlign;
  short wBitsPerSample;
  short cbSize;
}

struct WAVEHDRHelper {
  mixin(uuid("a2e20333-7c6d-308a-ba8d-2042deb7ed31"));
  int lpData;
  int dwBufferLength;
  int dwBytesRecorded;
  int dwUser;
  int dwFlags;
  int dwLoops;
  int lpNext;
  int reserved;
}

struct WAVEINCAPSHelper {
  mixin(uuid("f072625a-7948-34f5-bb28-729ebdf0e10e"));
  short wMid;
  short wPid;
  int vDriverVersion;
  int dwFormats;
  short wChannels;
  short wReserved1;
}

struct WAVEOUTCAPSHelper {
  mixin(uuid("3dbb8924-c666-321a-bf7a-0a8c3e118092"));
  short wMid;
  short wPid;
  int vDriverVersion;
  int dwFormats;
  short wChannels;
  short wReserved1;
  int dwSupport;
}

struct WIN32_FILE_ATTRIBUTE_DATAHelper {
  mixin(uuid("832a433b-6f4e-3532-b747-9254c3d12abb"));
  int dwFileAttributes;
  FILETIMEHelper ftCreationTime;
  FILETIMEHelper ftLastAccessTime;
  FILETIMEHelper ftLastWriteTime;
  int nFileSizeHigh;
  int nFileSizeLow;
}

struct WIN32_FIND_DATAHelper {
  mixin(uuid("90854420-9a6c-3831-bd33-6d31370a28c7"));
  int dwFileAttributes;
  int ftCreationTime_dwLowDateTime;
  int ftCreationTime_dwHighDateTime;
  int ftLastAccessTime_dwLowDateTime;
  int ftLastAccessTime_dwHighDateTime;
  int ftLastWriteTime_dwLowDateTime;
  int ftLastWriteTime_dwHighDateTime;
  int nFileSizeHigh;
  int nFileSizeLow;
  int dwReserved0;
  int dwReserved1;
}

struct WINDOWPLACEMENTHelper {
  mixin(uuid("1da0c34d-7038-3f1a-b51b-1f2ab13d2c7d"));
  int length;
  int Flags;
  int showCmd;
  int ptMinPosition_x;
  int ptMinPosition_y;
  int ptMaxPosition_x;
  int ptMaxPosition_y;
  int rcNormalPosition_left;
  int rcNormalPosition_top;
  int rcNormalPosition_right;
  int rcNormalPosition_bottom;
}

struct WINDOWPOSHelper {
  mixin(uuid("51b8d1ac-aa73-31bf-9f2d-d775e06ec21c"));
  int hWnd;
  int hwndInsertAfter;
  int x;
  int y;
  int cx;
  int cy;
  int Flags;
}

struct WNDCLASSHelper {
  mixin(uuid("53ffcac4-3463-391e-8020-e75c2af975c3"));
  int style;
  int lpfnWndProc;
  int cbClsExtra;
  int cbWndExtra;
  int hInstance;
  int hIcon;
  int hCursor;
  int hbrBackground;
}

struct WNDCLASSEXHelper {
  mixin(uuid("5097c7a2-faf8-35b1-bcd4-f83d97b11e46"));
  int cbSize;
  int style;
  int lpfnWndProc;
  int cbClsExtra;
  int cbWndExtra;
  int hInstance;
  int hIcon;
  int hCursor;
  int hbrBackground;
  int hIconSm;
}

struct XFORMHelper {
  mixin(uuid("8bb2a16f-d2df-3ce7-9f29-7f8cf48ddfb0"));
  float eM11;
  float eM12;
  float eM21;
  float eM22;
  float eDx;
  float eDy;
}

struct RECTHelper_2 {
  mixin(uuid("973c330d-3da0-3757-b9c9-0c2cb45bad95"));
  int left;
  int top;
  int right;
  int bottom;
}

// Interfaces

interface Comparison : IDispatch {
  mixin(uuid("af3da42f-9424-31db-9a6b-70cb261c0cd7"));
  /*[id(0x60020000)]*/ int compare(VARIANT obj1, VARIANT obj2, out int pRetVal);
}

interface ProvideSetComparisonInfo : IDispatch {
  mixin(uuid("7a9e86fe-61fd-372e-808c-519f721c62b9"));
  /*[id(0x60020000)]*/ int combineSetRules(VARIANT obj1, VARIANT obj2, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int compareSetRules(VARIANT obj1, VARIANT obj2, out int pRetVal);
  /*[id(0x60020002)]*/ int getSetRule(int rule, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int getStringForSetRule(VARIANT obj, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int intersectSetRules(VARIANT obj1, VARIANT obj2, out VARIANT pRetVal);
  /*[id(0x60020005)]*/ int isEmptySetRule(VARIANT obj, out short pRetVal);
}

interface IIntRangeComparator : IDispatch {
  mixin(uuid("cc911e45-9efd-3682-90bf-007567b2ac4a"));
  /*[id(0x60020000)]*/ int compareRanges(_IntRanges ranges1, int int1, _IntRanges ranges2, int int2, out int pRetVal);
  /*[id(0x60020001)]*/ int intersectRanges(_IntRanges ranges1, int int1, _IntRanges ranges2, int int2, int isectexprnum);
  /*[id(0x60020002)]*/ int mergeRanges(_IntRanges ranges, int int1, int int2, out short pRetVal);
  /*[id(0x60020003)]*/ int orderRanges(_IntRanges ranges, int int1, int int2, out int pRetVal);
  /*[id(0x60020004)]*/ int shiftRanges(_IntRanges ranges, int start, int count, int shiftcount);
  /*[id(0x60020005)]*/ int splitRange(_IntRanges ranges, int int1);
  /*[id(0x60020006)]*/ int swapRanges(_IntRanges ranges, int int1, int int2);
}

interface IWildcardExpressionComparator : IDispatch {
  mixin(uuid("8964e3e4-6dba-3d72-8a24-340ec61ff1fb"));
  /*[id(0x60020000)]*/ int compareSubexpressions(_WildcardExpression wexpr1, int num1, _WildcardExpression wexpr2, int num2, int cmpres, out int pRetVal);
  /*[id(0x60020001)]*/ int deleteSubexpression(_WildcardExpression wexpr, int num);
  /*[id(0x60020002)]*/ int intersectSubexpressions(_WildcardExpression wexpr1, int num1, _WildcardExpression wexpr2, int num2, int cmpres);
}

interface SetComparison : IDispatch {
  mixin(uuid("ed26d5a8-4589-3fc0-8fe6-ce1e9317241c"));
  /*[id(0x60020000)]*/ int compareSet(VARIANT obj, out int pRetVal);
}

interface TimerListener : IDispatch {
  mixin(uuid("7bff9407-65b8-3b6c-9a56-4b13a64a7b2b"));
  /*[id(0x60020000)]*/ int timeTriggered(_TimerEvent te);
}

interface IJavaStruct : IDispatch {
  mixin(uuid("2ea85d9b-3e57-343a-8afa-4bdf08fd7eac"));
  /*[id(0x60020000)]*/ int copyToJavaStruct(VARIANT obj);
  /*[id(0x60020001)]*/ int getUrtStruct(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int getAddr(out int pRetVal);
}

interface win : IDispatch {
  mixin(uuid("5f15402f-0bf6-3fc0-91c2-0d67de4396a1"));
}

interface wina : IDispatch {
  mixin(uuid("8cc3b44f-9184-3f62-aa9c-199436c72757"));
}

interface winb : IDispatch {
  mixin(uuid("f64aef80-c643-37d4-8ab3-91ba51e8be37"));
}

interface winc : IDispatch {
  mixin(uuid("5547e4e8-61df-37a2-a5ba-a149e8c667ff"));
}

interface wind : IDispatch {
  mixin(uuid("247098ae-7240-3e06-a089-2b71776145ff"));
}

interface windynamic : IDispatch {
  mixin(uuid("b6acf1c5-18ec-362b-ba01-bee201794758"));
}

interface wine : IDispatch {
  mixin(uuid("8a57c3a6-e49c-38ba-ad1d-5b96b4119830"));
}

interface winf : IDispatch {
  mixin(uuid("04850a75-d606-3417-ace7-36d4ff1726c3"));
}

interface wing : IDispatch {
  mixin(uuid("a77ae1b3-72bf-377c-b5b7-f6b8365fbc73"));
}

interface winh : IDispatch {
  mixin(uuid("37481ac7-a986-3729-8821-c9cab31b52ec"));
}

interface wini : IDispatch {
  mixin(uuid("4aaf2f56-8511-3987-a576-345ce47a4409"));
}

interface winj : IDispatch {
  mixin(uuid("c8ec07db-0a51-34c6-b492-6fc8f9bfb8f0"));
}

interface wink : IDispatch {
  mixin(uuid("7fc6d996-b502-3521-a8b0-311c73e9ff17"));
}

interface winl : IDispatch {
  mixin(uuid("7049fe82-1bde-37e1-81d7-e96fde3ec4b4"));
}

interface winm : IDispatch {
  mixin(uuid("003f88e3-9525-3a72-816b-da2011e530c5"));
}

interface winmisc : IDispatch {
  mixin(uuid("1fc87f87-ae65-3eaa-b5ff-aba59fc281fd"));
}

interface winn : IDispatch {
  mixin(uuid("16dc1b27-cad4-383a-aed0-e9da033672be"));
}

interface wino : IDispatch {
  mixin(uuid("61758b8c-ea53-387b-a1aa-4af459b474c3"));
}

interface winp : IDispatch {
  mixin(uuid("563bfca3-4daf-3954-a242-7967088f4900"));
}

interface winq : IDispatch {
  mixin(uuid("688e8c6e-6b36-3bf5-abc6-b8af0d8eddaf"));
}

interface winr : IDispatch {
  mixin(uuid("3ea48d73-c41e-35c0-9e67-6c06a62da1d1"));
}

interface wins : IDispatch {
  mixin(uuid("d865f775-1dd7-339a-8426-dfae26344935"));
}

interface winstrings : IDispatch {
  mixin(uuid("13de0b0d-e7dd-37a3-971b-6c8bd90fda23"));
}

interface wint : IDispatch {
  mixin(uuid("53c985b0-f770-32a7-976d-19f76d44457c"));
}

interface winu : IDispatch {
  mixin(uuid("fb9625a8-4700-31b2-b0be-fa14101179ea"));
}

interface winv : IDispatch {
  mixin(uuid("3aea8342-b94e-316a-beac-ada7fe9cc435"));
}

interface winw : IDispatch {
  mixin(uuid("f846271d-1eca-3320-9e5b-067e2515be60"));
}

interface winx : IDispatch {
  mixin(uuid("498e9e6f-4fac-3e82-a9a3-c48cfd0fd54e"));
}

interface winy : IDispatch {
  mixin(uuid("f50d484f-a4f8-38f8-a698-60d2c5504768"));
}

interface winz : IDispatch {
  mixin(uuid("28701969-4e38-3b8b-82b9-b22656e1152d"));
}

interface DataInput : IDispatch {
  mixin(uuid("29653cf0-1031-3da3-bfd0-363fdca7a45d"));
  /*[id(0x60020000)]*/ int readBoolean(out short pRetVal);
  /*[id(0x60020001)]*/ int readByte(out byte pRetVal);
  /*[id(0x60020002)]*/ int readChar(out ushort pRetVal);
  /*[id(0x60020003)]*/ int readDouble(out double pRetVal);
  /*[id(0x60020004)]*/ int readFloat(out float pRetVal);
  /*[id(0x60020005)]*/ int readFully( buffer);
  /*[id(0x60020006)]*/ int readFully_2( buffer, int offset, int count);
  /*[id(0x60020007)]*/ int readInt(out int pRetVal);
  /*[id(0x60020008)]*/ int readLine(out wchar* pRetVal);
  /*[id(0x60020009)]*/ int readLong(out long pRetVal);
  /*[id(0x6002000A)]*/ int readShort(out short pRetVal);
  /*[id(0x6002000B)]*/ int readUnsignedByte(out int pRetVal);
  /*[id(0x6002000C)]*/ int readUnsignedShort(out int pRetVal);
  /*[id(0x6002000D)]*/ int readUTF(out wchar* pRetVal);
  /*[id(0x6002000E)]*/ int skipBytes(int count, out int pRetVal);
}

interface DataOutput : IDispatch {
  mixin(uuid("75385bdd-ae06-3331-b04d-6de2d4dd6e5e"));
  /*[id(0x60020000)]*/ int write(int oneByte);
  /*[id(0x60020001)]*/ int write_2( buffer);
  /*[id(0x60020002)]*/ int write_3( buffer, int offset, int count);
  /*[id(0x60020003)]*/ int writeBoolean(short val);
  /*[id(0x60020004)]*/ int writeByte(int val);
  /*[id(0x60020005)]*/ int writeBytes(wchar* str);
  /*[id(0x60020006)]*/ int writeChar(int val);
  /*[id(0x60020007)]*/ int writeChars(wchar* str);
  /*[id(0x60020008)]*/ int writeDouble(double val);
  /*[id(0x60020009)]*/ int writeFloat(float val);
  /*[id(0x6002000A)]*/ int writeInt(int val);
  /*[id(0x6002000B)]*/ int writeLong(long val);
  /*[id(0x6002000C)]*/ int writeShort(int val);
  /*[id(0x6002000D)]*/ int writeUTF(wchar* str);
}

interface Externalizable : IDispatch {
  mixin(uuid("08efeeaf-3693-32b5-9987-f3265ce353c1"));
  /*[id(0x60020000)]*/ int readExternal(ObjectInput inParam);
  /*[id(0x60020001)]*/ int writeExternal(ObjectOutput outParam);
}

interface FileFilter : IDispatch {
  mixin(uuid("b9c2a847-ab1c-3493-b11f-812368e66924"));
  /*[id(0x60020000)]*/ int accept(_File pathname, out short pRetVal);
}

interface FilenameFilter : IDispatch {
  mixin(uuid("6aceeb7a-7624-3fec-ad26-e2e410dcbab3"));
  /*[id(0x60020000)]*/ int accept(_File dir, wchar* name, out short pRetVal);
}

interface ObjectInput : IDispatch {
  mixin(uuid("1a6813ab-6803-34a8-9146-68432e12e92e"));
  /*[id(0x60020000)]*/ int available(out int pRetVal);
  /*[id(0x60020001)]*/ int close();
  /*[id(0x60020002)]*/ int read(out int pRetVal);
  /*[id(0x60020003)]*/ int read_2( buf, out int pRetVal);
  /*[id(0x60020004)]*/ int read_3( buf, int off, int count, out int pRetVal);
  /*[id(0x60020005)]*/ int readObject(out VARIANT pRetVal);
  /*[id(0x60020006)]*/ int skip(long count, out long pRetVal);
}

interface ObjectInputValidation : IDispatch {
  mixin(uuid("70feb408-15ca-33e7-8164-6f271f3ce2d5"));
  /*[id(0x60020000)]*/ int validateObject();
}

interface ObjectOutput : IDispatch {
  mixin(uuid("8b2c770c-f978-3b39-84c0-d9c5e02bfb56"));
  /*[id(0x60020000)]*/ int close();
  /*[id(0x60020001)]*/ int flush();
  /*[id(0x60020002)]*/ int write(int oneByte);
  /*[id(0x60020003)]*/ int write_2( buffer);
  /*[id(0x60020004)]*/ int write_3( buffer, int offset, int count);
  /*[id(0x60020005)]*/ int writeObject(VARIANT obj);
}

interface Serializable : IDispatch {
  mixin(uuid("45b961cc-817e-33d4-8702-158fdb8a0e04"));
}

interface Member : IDispatch {
  mixin(uuid("b82ebf06-c529-3fbe-8ee7-677da46bac36"));
  /*[id(0x60020000)]*/ int getDeclaringClass(out _Class pRetVal);
  /*[id(0x60020001)]*/ int getName(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int getModifiers(out int pRetVal);
}

interface ContentHandlerFactory : IDispatch {
  mixin(uuid("534a7b79-b6ca-3d83-a5f0-f65f3aea00dd"));
  /*[id(0x60020000)]*/ int createContentHandler(wchar* mimetype, out _ContentHandler pRetVal);
}

interface FileNameMap : IDispatch {
  mixin(uuid("994930fa-d4c9-321b-a271-96892822d537"));
  /*[id(0x60020000)]*/ int getContentTypeFor(wchar* fileName, out wchar* pRetVal);
}

interface SocketImplFactory : IDispatch {
  mixin(uuid("d8d37ed9-3c00-3fec-910d-22997c864f79"));
  /*[id(0x60020000)]*/ int createSocketImpl(out _SocketImpl pRetVal);
}

interface URLStreamHandlerFactory : IDispatch {
  mixin(uuid("a100c2e1-492b-391b-a636-2608dcf2ac16"));
  /*[id(0x60020000)]*/ int createURLStreamHandler(wchar* protocol, out _URLStreamHandler pRetVal);
}

interface CharacterIterator : IDispatch {
  mixin(uuid("a5984c88-56b7-3171-b8d0-b85a07d98cb8"));
  /*[id(0x60020000)]*/ int MemberwiseClone(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int current(out ushort pRetVal);
  /*[id(0x60020002)]*/ int first(out ushort pRetVal);
  /*[id(0x60020003)]*/ int getBeginIndex(out int pRetVal);
  /*[id(0x60020004)]*/ int getEndIndex(out int pRetVal);
  /*[id(0x60020005)]*/ int getIndex(out int pRetVal);
  /*[id(0x60020006)]*/ int last(out ushort pRetVal);
  /*[id(0x60020007)]*/ int next(out ushort pRetVal);
  /*[id(0x60020008)]*/ int previous(out ushort pRetVal);
  /*[id(0x60020009)]*/ int setIndex(int idx, out ushort pRetVal);
}

interface Checksum : IDispatch {
  mixin(uuid("78a316ad-3596-3e96-8dbe-3706c53cd143"));
  /*[id(0x60020000)]*/ int getValue(out long pRetVal);
  /*[id(0x60020001)]*/ int reset();
  /*[id(0x60020002)]*/ int update(int bval);
  /*[id(0x60020003)]*/ int update_2( buf, int off, int len);
}

interface Runnable : IDispatch {
  mixin(uuid("946d070f-3473-3fa5-8052-55b5bb51a162"));
  /*[id(0x60020000)]*/ int run();
}

interface Enumeration : IDispatch {
  mixin(uuid("779332d2-0e25-393b-bfef-359fcaf03f0c"));
  /*[id(0x60020000)]*/ int hasMoreElements(out short pRetVal);
  /*[id(0x60020001)]*/ int nextElement(out VARIANT pRetVal);
}

interface Observer : IDispatch {
  mixin(uuid("3dff4329-aa83-398a-8ee3-df58dea8d7b0"));
  /*[id(0x60020000)]*/ int update(_Observable o, VARIANT arg);
}

interface Comparator : IDispatch {
  mixin(uuid("eff04d17-ea8c-3402-92e5-d2c65aa359e7"));
  /*[id(0x60020000)]*/ int compare(VARIANT o1, VARIANT o2, out int pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT obj, out short pRetVal);
}

interface Iterator : IDispatch {
  mixin(uuid("8ac887ab-59db-3425-865c-01a9a8ae01b6"));
  /*[id(0x60020000)]*/ int hasNext(out short pRetVal);
  /*[id(0x60020001)]*/ int next(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int remove();
}

interface ListIterator : IDispatch {
  mixin(uuid("d2c5cc66-114b-3726-a552-1ba544b8f1c6"));
  /*[id(0x60020000)]*/ int next(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int previous(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int hasNext(out short pRetVal);
  /*[id(0x60020003)]*/ int hasPrevious(out short pRetVal);
  /*[id(0x60020004)]*/ int nextIndex(out int pRetVal);
  /*[id(0x60020005)]*/ int previousIndex(out int pRetVal);
  /*[id(0x60020006)]*/ int add(VARIANT e);
  /*[id(0x60020007)]*/ int remove();
  /*[id(0x60020008)]*/ int Set(VARIANT e);
}

interface SortedMap : IDispatch {
  mixin(uuid("354457ee-a0b2-3116-b1d0-de3d65b4f892"));
  /*[id(0x60020000)]*/ int firstKey(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int lastKey(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int headMap(VARIANT toV, out SortedMap pRetVal);
  /*[id(0x60020003)]*/ int tailMap(VARIANT fromV, out SortedMap pRetVal);
  /*[id(0x60020004)]*/ int subMap(VARIANT fromV, VARIANT toV, out SortedMap pRetVal);
  /*[id(0x60020005)]*/ int Comparator(out Comparator pRetVal);
}

interface SortedSet : IDispatch {
  mixin(uuid("65f33b32-6e58-3099-be11-677686447306"));
  /*[id(0x60020000)]*/ int first(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int last(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int headSet(VARIANT toV, out SortedSet pRetVal);
  /*[id(0x60020003)]*/ int tailSet(VARIANT fromV, out SortedSet pRetVal);
  /*[id(0x60020004)]*/ int Subset(VARIANT fronV, VARIANT toV, out SortedSet pRetVal);
  /*[id(0x60020005)]*/ int Comparator(out Comparator pRetVal);
}

interface Collection : IDispatch {
  mixin(uuid("5c90686c-66a6-3048-9e9a-6000a7dd3506"));
  /*[id(0x60020000)]*/ int add(VARIANT e, out short pRetVal);
  /*[id(0x60020001)]*/ int addAll(Collection c, out short pRetVal);
  /*[id(0x60020002)]*/ int clear();
  /*[id(0x60020003)]*/ int remove(VARIANT e, out short pRetVal);
  /*[id(0x60020004)]*/ int removeAll(Collection c, out short pRetVal);
  /*[id(0x60020005)]*/ int retainAll(Collection c, out short pRetVal);
  /*[id(0x60020006)]*/ int Iterator(out Iterator pRetVal);
  /*[id(0x60020007)]*/ int contains(VARIANT e, out short pRetVal);
  /*[id(0x60020008)]*/ int containsAll(Collection c, out short pRetVal);
  /*[id(0x60020009)]*/ int isEmpty(out short pRetVal);
  /*[id(0x6002000A)]*/ int SIZE(out int pRetVal);
  /*[id(0x6002000B)]*/ int toArray(out  pRetVal);
  /*[id(0x6002000C)]*/ int toArray_2( arr, out  pRetVal);
  /*[id(0x6002000D)]*/ int Equals(VARIANT c, out short pRetVal);
  /*[id(0x6002000E)]*/ int GetHashCode(out int pRetVal);
}

interface java_util_List : IDispatch {
  mixin(uuid("79a00afe-ba20-33ed-b506-02558bc6304c"));
  /*[id(0x60020000)]*/ int get(int ix, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int contains(VARIANT e, out short pRetVal);
  /*[id(0x60020002)]*/ int containsAll(Collection c, out short pRetVal);
  /*[id(0x60020003)]*/ int indexOf(VARIANT e, out int pRetVal);
  /*[id(0x60020004)]*/ int isEmpty(out short pRetVal);
  /*[id(0x60020005)]*/ int SIZE(out int pRetVal);
  /*[id(0x60020006)]*/ int lastIndexOf(VARIANT e, out int pRetVal);
  /*[id(0x60020007)]*/ int subList(int fromIx, int toIx, out java_util_List pRetVal);
  /*[id(0x60020008)]*/ int toArray(out  pRetVal);
  /*[id(0x60020009)]*/ int toArray_2( arr, out  pRetVal);
  /*[id(0x6002000A)]*/ int Iterator(out Iterator pRetVal);
  /*[id(0x6002000B)]*/ int ListIterator(out ListIterator pRetVal);
  /*[id(0x6002000C)]*/ int listIterator_2(int ix, out ListIterator pRetVal);
  /*[id(0x6002000D)]*/ int add(VARIANT e, out short pRetVal);
  /*[id(0x6002000E)]*/ int add_2(int ix, VARIANT e);
  /*[id(0x6002000F)]*/ int addAll(Collection c, out short pRetVal);
  /*[id(0x60020010)]*/ int addAll_2(int ix, Collection c, out short pRetVal);
  /*[id(0x60020011)]*/ int clear();
  /*[id(0x60020012)]*/ int remove(VARIANT e, out short pRetVal);
  /*[id(0x60020013)]*/ int remove_2(int ix, out VARIANT pRetVal);
  /*[id(0x60020014)]*/ int removeAll(Collection c, out short pRetVal);
  /*[id(0x60020015)]*/ int retainAll(Collection c, out short pRetVal);
  /*[id(0x60020016)]*/ int Set(int ix, VARIANT e, out VARIANT pRetVal);
  /*[id(0x60020017)]*/ int Equals(VARIANT c, out short pRetVal);
  /*[id(0x60020018)]*/ int GetHashCode(out int pRetVal);
}

interface Map : IDispatch {
  mixin(uuid("f6b0ebd5-bd4d-3d6a-a3ce-13489da6091a"));
  /*[id(0x60020000)]*/ int get(VARIANT k, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int containsKey(VARIANT k, out short pRetVal);
  /*[id(0x60020002)]*/ int containsValue(VARIANT v, out short pRetVal);
  /*[id(0x60020003)]*/ int isEmpty(out short pRetVal);
  /*[id(0x60020004)]*/ int SIZE(out int pRetVal);
  /*[id(0x60020005)]*/ int clear();
  /*[id(0x60020006)]*/ int put(VARIANT k, VARIANT v, out VARIANT pRetVal);
  /*[id(0x60020007)]*/ int putAll(Map m);
  /*[id(0x60020008)]*/ int remove(VARIANT k, out VARIANT pRetVal);
  /*[id(0x60020009)]*/ int entrySet(out Set pRetVal);
  /*[id(0x6002000A)]*/ int keySet(out Set pRetVal);
  /*[id(0x6002000B)]*/ int values(out Collection pRetVal);
  /*[id(0x6002000C)]*/ int Equals(VARIANT c, out short pRetVal);
  /*[id(0x6002000D)]*/ int GetHashCode(out int pRetVal);
}

interface Entry : IDispatch {
  mixin(uuid("63566846-ea3a-328d-bacd-10ca3a098ddb"));
  /*[id(0x60020000)]*/ int getKey(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int getValue(out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int setValue(VARIANT newVal, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int Equals(VARIANT e, out short pRetVal);
  /*[id(0x60020004)]*/ int GetHashCode(out int pRetVal);
}

interface Set : IDispatch {
  mixin(uuid("6cba8f70-83a0-3161-bd74-ad43f6410c13"));
  /*[id(0x60020000)]*/ int contains(VARIANT e, out short pRetVal);
  /*[id(0x60020001)]*/ int containsAll(Collection c, out short pRetVal);
  /*[id(0x60020002)]*/ int isEmpty(out short pRetVal);
  /*[id(0x60020003)]*/ int SIZE(out int pRetVal);
  /*[id(0x60020004)]*/ int add(VARIANT e, out short pRetVal);
  /*[id(0x60020005)]*/ int addAll(Collection c, out short pRetVal);
  /*[id(0x60020006)]*/ int clear();
  /*[id(0x60020007)]*/ int remove(VARIANT e, out short pRetVal);
  /*[id(0x60020008)]*/ int removeAll(Collection c, out short pRetVal);
  /*[id(0x60020009)]*/ int retainAll(Collection c, out short pRetVal);
  /*[id(0x6002000A)]*/ int Iterator(out Iterator pRetVal);
  /*[id(0x6002000B)]*/ int toArray(out  pRetVal);
  /*[id(0x6002000C)]*/ int toArray_2( arr, out  pRetVal);
  /*[id(0x6002000D)]*/ int Equals(VARIANT e, out short pRetVal);
  /*[id(0x6002000E)]*/ int GetHashCode(out int pRetVal);
}

interface Comparable : IDispatch {
  mixin(uuid("402e65f6-2cb1-3593-bc4b-d243a1cca192"));
  /*[id(0x60020000)]*/ int compareTo(VARIANT obj, out int pRetVal);
}

interface EventListener : IDispatch {
  mixin(uuid("39bfeea3-84bd-32f0-9f15-62996a62c264"));
}

interface ActionListener : IDispatch {
  mixin(uuid("9ac51a77-1671-3051-a6b9-6672221a226d"));
  /*[id(0x60020000)]*/ int actionPerformed(_ActionEvent evt);
}

interface ActiveEvent : IDispatch {
  mixin(uuid("2615aa68-d82b-38ba-acf5-5afda1fbb115"));
  /*[id(0x60020000)]*/ int Dispatch();
}

interface Adjustable : IDispatch {
  mixin(uuid("18304527-dc73-31a5-8307-e529352d78f3"));
  /*[id(0x60020000)]*/ int addAdjustmentListener(AdjustmentListener listener);
  /*[id(0x60020001)]*/ int getBlockIncrement(out int pRetVal);
  /*[id(0x60020002)]*/ int getMaximum(out int pRetVal);
  /*[id(0x60020003)]*/ int getMinimum(out int pRetVal);
  /*[id(0x60020004)]*/ int getOrientation(out int pRetVal);
  /*[id(0x60020005)]*/ int getUnitIncrement(out int pRetVal);
  /*[id(0x60020006)]*/ int getValue(out int pRetVal);
  /*[id(0x60020007)]*/ int getVisibleAmount(out int pRetVal);
  /*[id(0x60020008)]*/ int removeAdjustmentListener(AdjustmentListener listener);
  /*[id(0x60020009)]*/ int setBlockIncrement(int increment);
  /*[id(0x6002000A)]*/ int setMaximum(int max);
  /*[id(0x6002000B)]*/ int setMinimum(int min);
  /*[id(0x6002000C)]*/ int setUnitIncrement(int increment);
  /*[id(0x6002000D)]*/ int setValue(int value);
  /*[id(0x6002000E)]*/ int setVisibleAmount(int vis);
}

interface AdjustmentListener : IDispatch {
  mixin(uuid("0b7e7b3a-0cce-3b57-bba1-bd2d9733a779"));
  /*[id(0x60020000)]*/ int adjustmentValueChanged(_AdjustmentEvent evt);
}

interface AppletContext : IDispatch {
  mixin(uuid("bb5d9660-a498-3d47-bd6b-389b9cb12f45"));
  /*[id(0x60020000)]*/ int getApplet(wchar* appletName, out _Applet pRetVal);
  /*[id(0x60020001)]*/ int getApplets(out Enumeration pRetVal);
  /*[id(0x60020002)]*/ int getAudioClip(_URL URL, out AudioClip pRetVal);
  /*[id(0x60020003)]*/ int getImage(_URL URL, out _Image pRetVal);
  /*[id(0x60020004)]*/ int showDocument(_URL URL);
  /*[id(0x60020005)]*/ int showDocument_2(_URL URL, wchar* target);
  /*[id(0x60020006)]*/ int showStatus(wchar* MSG);
}

interface AppletStub : IDispatch {
  mixin(uuid("7590e342-a9cf-36cf-abd5-701bc12432d8"));
  /*[id(0x60020000)]*/ int appletResize(int w, int h);
  /*[id(0x60020001)]*/ int getAppletContext(out AppletContext pRetVal);
  /*[id(0x60020002)]*/ int getCodeBase(out _URL pRetVal);
  /*[id(0x60020003)]*/ int getDocumentBase(out _URL pRetVal);
  /*[id(0x60020004)]*/ int getParameter(wchar* name, out wchar* pRetVal);
  /*[id(0x60020005)]*/ int isActive(out short pRetVal);
}

interface AudioClip : IDispatch {
  mixin(uuid("5ff68093-9979-3382-a944-d47ab3954dff"));
  /*[id(0x60020000)]*/ int loop();
  /*[id(0x60020001)]*/ int play();
  /*[id(0x60020002)]*/ int stop();
}

interface ButtonPeer : IDispatch {
  mixin(uuid("eee5d69d-405a-3e76-a07e-c5f8603c68d1"));
  /*[id(0x60020000)]*/ int setLabel(wchar* Label);
}

interface CanvasPeer : IDispatch {
  mixin(uuid("c349cc3c-34aa-3f5b-9bf6-9a6127a7b30a"));
}

interface CheckboxMenuItemPeer : IDispatch {
  mixin(uuid("053353c2-bb3e-3b08-bca6-8aee2e5833f0"));
  /*[id(0x60020000)]*/ int setState(short state);
}

interface CheckboxPeer : IDispatch {
  mixin(uuid("a42aa962-7eec-3fcc-a38d-15af27ee7f0c"));
  /*[id(0x60020000)]*/ int setVisible(short cond);
  /*[id(0x60020001)]*/ int setLabel(wchar* Label);
  /*[id(0x60020002)]*/ int setState(short state);
  /*[id(0x60020003)]*/ int setCheckboxGroup(_CheckboxGroup g);
}

interface ChoicePeer : IDispatch {
  mixin(uuid("2576af5c-251d-33bb-99e2-f58c15eaaae5"));
  /*[id(0x60020000)]*/ int add(wchar* item, int index);
  /*[id(0x60020001)]*/ int addItem(wchar* item, int index);
  /*[id(0x60020002)]*/ int remove(int index);
  /*[id(0x60020003)]*/ int select(int index);
}

interface ClipboardOwner : IDispatch {
  mixin(uuid("7ba950af-2039-3ff2-a467-2e2c17a9b548"));
  /*[id(0x60020000)]*/ int lostOwnership(_Clipboard Clipboard, Transferable contents);
}

interface ComponentListener : IDispatch {
  mixin(uuid("e035c980-f240-378f-b770-7b3347954f95"));
  /*[id(0x60020000)]*/ int componentHidden(_ComponentEvent evt);
  /*[id(0x60020001)]*/ int componentMoved(_ComponentEvent evt);
  /*[id(0x60020002)]*/ int componentResized(_ComponentEvent evt);
  /*[id(0x60020003)]*/ int componentShown(_ComponentEvent evt);
}

interface ComponentPeer : IDispatch {
  mixin(uuid("e10deede-92f4-35a5-9ee0-34fcfeca4a77"));
  /*[id(0x60020000)]*/ int checkImage(_Image Image, int width, int height, ImageObserver obs, out int pRetVal);
  /*[id(0x60020001)]*/ int createImage(int width, int height, out _Image pRetVal);
  /*[id(0x60020002)]*/ int createImage_2(ImageProducer prod, out _Image pRetVal);
  /*[id(0x60020003)]*/ int dispose();
  /*[id(0x60020004)]*/ int getColorModel(out _ColorModel pRetVal);
  /*[id(0x60020005)]*/ int getFontMetrics(_Font Font, out _FontMetrics pRetVal);
  /*[id(0x60020006)]*/ int getGraphics(out _Graphics pRetVal);
  /*[id(0x60020007)]*/ int getLocationOnScreen(out _java_awt_Point pRetVal);
  /*[id(0x60020008)]*/ int getMinimumSize(out _Dimension pRetVal);
  /*[id(0x60020009)]*/ int getPreferredSize(out _Dimension pRetVal);
  /*[id(0x6002000A)]*/ int getToolkit(out _Toolkit pRetVal);
  /*[id(0x6002000B)]*/ int handleEvent(_AWTEvent evt, out short pRetVal);
  /*[id(0x6002000C)]*/ int isFocusTraversable(out short pRetVal);
  /*[id(0x6002000D)]*/ int paint(_Graphics gc);
  /*[id(0x6002000E)]*/ int prepareImage(_Image img, int w, int h, ImageObserver obs, out short pRetVal);
  /*[id(0x6002000F)]*/ int print(_Graphics gc);
  /*[id(0x60020010)]*/ int repaint(long ms, int x, int y, int w, int h);
  /*[id(0x60020011)]*/ int requestFocus();
  /*[id(0x60020012)]*/ int setBackground(_Color c);
  /*[id(0x60020013)]*/ int setBounds(int x, int y, int w, int h);
  /*[id(0x60020014)]*/ int setCursor(_Cursor Cursor);
  /*[id(0x60020015)]*/ int setEnabled(short cond);
  /*[id(0x60020016)]*/ int setFont(_Font f);
  /*[id(0x60020017)]*/ int setForeground(_Color c);
  /*[id(0x60020018)]*/ int setVisible(short cond);
  /*[id(0x60020019)]*/ int disable();
  /*[id(0x6002001A)]*/ int enable();
  /*[id(0x6002001B)]*/ int hide();
  /*[id(0x6002001C)]*/ int minimumSize(out _Dimension pRetVal);
  /*[id(0x6002001D)]*/ int preferredSize(out _Dimension pRetVal);
  /*[id(0x6002001E)]*/ int reshape(int x, int y, int w, int h);
  /*[id(0x6002001F)]*/ int show();
}

interface ContainerListener : IDispatch {
  mixin(uuid("220b3e34-bcdb-37ea-b310-dffa5c5f112a"));
  /*[id(0x60020000)]*/ int componentAdded(_ContainerEvent evt);
  /*[id(0x60020001)]*/ int componentRemoved(_ContainerEvent evt);
}

interface ContainerPeer : IDispatch {
  mixin(uuid("638096ad-515a-3d2b-be65-0f39e5edfc1a"));
  /*[id(0x60020000)]*/ int Insets(out _Insets pRetVal);
  /*[id(0x60020001)]*/ int getInsets(out _Insets pRetVal);
  /*[id(0x60020002)]*/ int beginValidate();
  /*[id(0x60020003)]*/ int endValidate();
}

interface DialogPeer : IDispatch {
  mixin(uuid("2c89ef77-d778-3033-88ee-fa6da01a6568"));
  /*[id(0x60020000)]*/ int setResizable(short resizable);
  /*[id(0x60020001)]*/ int setTitle(wchar* title);
}

interface FileDialogPeer : IDispatch {
  mixin(uuid("17aa84f1-4c24-307f-8b95-b29c80f53055"));
  /*[id(0x60020000)]*/ int setDirectory(wchar* dir);
  /*[id(0x60020001)]*/ int setFile(wchar* File);
  /*[id(0x60020002)]*/ int setFilenameFilter(FilenameFilter filter);
}

interface FocusListener : IDispatch {
  mixin(uuid("fe5c1985-51e9-3b2f-bfa5-ace1cb986c68"));
  /*[id(0x60020000)]*/ int focusGained(_FocusEvent evt);
  /*[id(0x60020001)]*/ int focusLost(_FocusEvent evt);
}

interface FontPeer : IDispatch {
  mixin(uuid("07b5f678-fb52-3b8a-83d3-8090760a1129"));
}

interface FramePeer : IDispatch {
  mixin(uuid("8e6663d8-3541-3dd9-9b69-3aff23840ab4"));
  /*[id(0x60020000)]*/ int setIconImage(_Image Image);
  /*[id(0x60020001)]*/ int setTitle(wchar* title);
  /*[id(0x60020002)]*/ int setMenuBar(_MenuBar MenuBar);
  /*[id(0x60020003)]*/ int setResizable(short resizable);
}

interface ImageConsumer : IDispatch {
  mixin(uuid("86a2ca5d-3c08-33cf-9a42-9b51e4e8e6fc"));
  /*[id(0x60020000)]*/ int imageComplete(int status);
  /*[id(0x60020001)]*/ int setColorModel(_ColorModel model);
  /*[id(0x60020002)]*/ int setDimensions(int width, int height);
  /*[id(0x60020003)]*/ int setHints(int hintFlags);
  /*[id(0x60020004)]*/ int setPixels(int x, int y, int w, int h, _ColorModel model,  pixel, int offset, int scansize);
  /*[id(0x60020005)]*/ int setPixels_2(int x, int y, int w, int h, _ColorModel model,  pixel, int offset, int scansize);
  /*[id(0x60020006)]*/ int setProperties(_Hashtable props);
}

interface ImageObserver : IDispatch {
  mixin(uuid("182f3b7e-862d-3d0b-85c1-acb645f83337"));
  /*[id(0x60020000)]*/ int imageUpdate(_Image img, int infoFlags, int x, int y, int w, int h, out short pRetVal);
}

interface ImageProducer : IDispatch {
  mixin(uuid("1daa8eff-add4-3484-9437-decd73fdbb30"));
  /*[id(0x60020000)]*/ int addConsumer(ImageConsumer ic);
  /*[id(0x60020001)]*/ int isConsumer(ImageConsumer ic, out short pRetVal);
  /*[id(0x60020002)]*/ int removeConsumer(ImageConsumer ic);
  /*[id(0x60020003)]*/ int requestTopDownLeftRightResend(ImageConsumer ic);
  /*[id(0x60020004)]*/ int startProduction(ImageConsumer ic);
}

interface ItemListener : IDispatch {
  mixin(uuid("fcd69c1b-cc63-390b-86bf-3570b03db4b0"));
  /*[id(0x60020000)]*/ int itemStateChanged(_ItemEvent evt);
}

interface ItemSelectable : IDispatch {
  mixin(uuid("cd5a735c-9781-33f2-8fd5-bb468eeea349"));
  /*[id(0x60020000)]*/ int addItemListener(ItemListener listener);
  /*[id(0x60020001)]*/ int getSelectedObjects(out  pRetVal);
  /*[id(0x60020002)]*/ int removeItemListener(ItemListener listener);
}

interface KeyListener : IDispatch {
  mixin(uuid("bc60ac51-bb0d-3f2a-a9b3-d51cd92f33d5"));
  /*[id(0x60020000)]*/ int keyPressed(_KeyEvent evt);
  /*[id(0x60020001)]*/ int keyReleased(_KeyEvent evt);
  /*[id(0x60020002)]*/ int keyTyped(_KeyEvent evt);
}

interface LabelPeer : IDispatch {
  mixin(uuid("d3329d3e-89f5-3b8c-854f-777310434350"));
  /*[id(0x60020000)]*/ int setAlignment(int alignment);
  /*[id(0x60020001)]*/ int setText(wchar* Label);
}

interface LayoutManager : IDispatch {
  mixin(uuid("31e77083-099b-38e7-8eb8-6e22944e95ac"));
  /*[id(0x60020000)]*/ int addLayoutComponent(wchar* name, _Component comp);
  /*[id(0x60020001)]*/ int layoutContainer(_Container cont);
  /*[id(0x60020002)]*/ int minimumLayoutSize(_Container cont, out _Dimension pRetVal);
  /*[id(0x60020003)]*/ int preferredLayoutSize(_Container cont, out _Dimension pRetVal);
  /*[id(0x60020004)]*/ int removeLayoutComponent(_Component comp);
}

interface LayoutManager2 : IDispatch {
  mixin(uuid("171a4776-72fb-3b06-9231-1e411599a4d0"));
  /*[id(0x60020000)]*/ int addLayoutComponent(_Component comp, VARIANT constraints);
  /*[id(0x60020001)]*/ int getLayoutAlignmentX(_Container cont, out float pRetVal);
  /*[id(0x60020002)]*/ int getLayoutAlignmentY(_Container cont, out float pRetVal);
  /*[id(0x60020003)]*/ int invalidateLayout(_Container cont);
  /*[id(0x60020004)]*/ int maximumLayoutSize(_Container cont, out _Dimension pRetVal);
}

interface LightweightPeer : IDispatch {
  mixin(uuid("89060064-f6c3-3722-84bc-d04556bd3a4f"));
}

interface ListPeer : IDispatch {
  mixin(uuid("e627c228-ad1a-3cd1-8d4c-ca3ce1bc2eeb"));
  /*[id(0x60020000)]*/ int add(wchar* item, int index);
  /*[id(0x60020001)]*/ int addItem(wchar* item, int index);
  /*[id(0x60020002)]*/ int delItems(int start, int end);
  /*[id(0x60020003)]*/ int deselect(int index);
  /*[id(0x60020004)]*/ int getMinimumSize(int rows, out _Dimension pRetVal);
  /*[id(0x60020005)]*/ int minimumSize(int rows, out _Dimension pRetVal);
  /*[id(0x60020006)]*/ int getPreferredSize(int rows, out _Dimension pRetVal);
  /*[id(0x60020007)]*/ int preferredSize(int rows, out _Dimension pRetVal);
  /*[id(0x60020008)]*/ int getSelectedIndexes(out  pRetVal);
  /*[id(0x60020009)]*/ int makeVisible(int index);
  /*[id(0x6002000A)]*/ int removeAll();
  /*[id(0x6002000B)]*/ int select(int index);
  /*[id(0x6002000C)]*/ int setMultipleMode(short on);
  /*[id(0x6002000D)]*/ int setMultipleSelections(short on);
  /*[id(0x6002000E)]*/ int clear();
}

interface MenuBarPeer : IDispatch {
  mixin(uuid("2126ed99-f060-3c22-a45f-35decccd41f3"));
  /*[id(0x60020000)]*/ int addHelpMenu(_Menu Menu);
  /*[id(0x60020001)]*/ int addMenu(_Menu Menu);
  /*[id(0x60020002)]*/ int delMenu(int pos);
}

interface MenuComponentPeer : IDispatch {
  mixin(uuid("b0cb3c22-5385-3b03-8070-9b9b3a9a433c"));
  /*[id(0x60020000)]*/ int dispose();
}

interface MenuContainer : IDispatch {
  mixin(uuid("06633ab3-cb5a-34f3-b3c2-71dda7a36561"));
  /*[id(0x60020000)]*/ int getFont(out _Font pRetVal);
  /*[id(0x60020001)]*/ int postEvent(_Event evt, out short pRetVal);
  /*[id(0x60020002)]*/ int remove(_MenuComponent mcomp);
}

interface MenuItemPeer : IDispatch {
  mixin(uuid("cc403468-6852-3cfe-9de8-e4ece41b3843"));
  /*[id(0x60020000)]*/ int disable();
  /*[id(0x60020001)]*/ int enable();
  /*[id(0x60020002)]*/ int setEnabled(short on);
  /*[id(0x60020003)]*/ int setLabel(wchar* Label);
}

interface MenuPeer : IDispatch {
  mixin(uuid("e59a5079-9045-312e-99ba-002d71233f41"));
  /*[id(0x60020000)]*/ int addItem(_MenuItem MenuItem);
  /*[id(0x60020001)]*/ int addSeparator();
  /*[id(0x60020002)]*/ int delItem(int pos);
}

interface MouseListener : IDispatch {
  mixin(uuid("e304afd2-da61-3de6-85ef-1f5dec0ae093"));
  /*[id(0x60020000)]*/ int mouseClicked(_MouseEvent evt);
  /*[id(0x60020001)]*/ int mouseEntered(_MouseEvent evt);
  /*[id(0x60020002)]*/ int mouseExited(_MouseEvent evt);
  /*[id(0x60020003)]*/ int mousePressed(_MouseEvent evt);
  /*[id(0x60020004)]*/ int mouseReleased(_MouseEvent evt);
}

interface MouseMotionListener : IDispatch {
  mixin(uuid("c6bf4824-cea7-337e-8109-eac48383d950"));
  /*[id(0x60020000)]*/ int mouseDragged(_MouseEvent evt);
  /*[id(0x60020001)]*/ int mouseMoved(_MouseEvent evt);
}

interface PanelPeer : IDispatch {
  mixin(uuid("2e88b0ae-b89e-35bf-a805-3a6b4176d07f"));
}

interface PopupMenuPeer : IDispatch {
  mixin(uuid("ded7a40e-5f09-307d-97aa-c55b248bbc77"));
  /*[id(0x60020000)]*/ int show(_Event evt);
}

interface PrintGraphics : IDispatch {
  mixin(uuid("79c40328-71a7-352c-a4a1-ce541ded40ea"));
  /*[id(0x60020000)]*/ int getPrintJob(out _PrintJob pRetVal);
}

interface ScrollbarPeer : IDispatch {
  mixin(uuid("a93df8d4-cdf0-3bd4-82ae-6c2f45d4192e"));
  /*[id(0x60020000)]*/ int setLineIncrement(int increment);
  /*[id(0x60020001)]*/ int setPageIncrement(int increment);
  /*[id(0x60020002)]*/ int setValues(int value, int visible, int minimum, int maximum);
}

interface ScrollPanePeer : IDispatch {
  mixin(uuid("a9fc1f64-d970-3ee2-8770-adb0698666f4"));
  /*[id(0x60020000)]*/ int childResized(int w, int h);
  /*[id(0x60020001)]*/ int getHScrollbarHeight(out int pRetVal);
  /*[id(0x60020002)]*/ int getVScrollbarWidth(out int pRetVal);
  /*[id(0x60020003)]*/ int setScrollPosition(int x, int y);
  /*[id(0x60020004)]*/ int setUnitIncrement(Adjustable adj, int increment);
  /*[id(0x60020005)]*/ int setValue(Adjustable adj, int value);
}

interface Shape : IDispatch {
  mixin(uuid("03b1a22f-7c09-398f-a087-3b6f79e7749b"));
  /*[id(0x60020000)]*/ int getBounds(out _Rectangle pRetVal);
}

interface TextAreaPeer : IDispatch {
  mixin(uuid("6b4d3a8d-3960-3ed3-aa0e-d18ca4661666"));
  /*[id(0x60020000)]*/ int getMinimumSize(int rows, int cols, out _Dimension pRetVal);
  /*[id(0x60020001)]*/ int getPreferredSize(int rows, int cols, out _Dimension pRetVal);
  /*[id(0x60020002)]*/ int insert(wchar* text, int pos);
  /*[id(0x60020003)]*/ int insertText(wchar* text, int pos);
  /*[id(0x60020004)]*/ int minimumSize(int rows, int cols, out _Dimension pRetVal);
  /*[id(0x60020005)]*/ int preferredSize(int rows, int cols, out _Dimension pRetVal);
  /*[id(0x60020006)]*/ int replaceRange(wchar* str, int start, int end);
  /*[id(0x60020007)]*/ int replaceText(wchar* str, int start, int end);
}

interface TextComponentPeer : IDispatch {
  mixin(uuid("6b502eda-6bf8-345e-b430-be3137eff35e"));
  /*[id(0x60020000)]*/ int getCaretPosition(out int pRetVal);
  /*[id(0x60020001)]*/ int getSelectionEnd(out int pRetVal);
  /*[id(0x60020002)]*/ int getSelectionStart(out int pRetVal);
  /*[id(0x60020003)]*/ int getText(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int select(int selStart, int selEnd);
  /*[id(0x60020005)]*/ int setCaretPosition(int caret);
  /*[id(0x60020006)]*/ int setEditable(short editable);
  /*[id(0x60020007)]*/ int setText(wchar* text);
}

interface TextFieldPeer : IDispatch {
  mixin(uuid("a44ca4da-f4a6-3697-bf39-6c5a873df969"));
  /*[id(0x60020000)]*/ int getMinimumSize(int cols, out _Dimension pRetVal);
  /*[id(0x60020001)]*/ int getPreferredSize(int cols, out _Dimension pRetVal);
  /*[id(0x60020002)]*/ int minimumSize(int cols, out _Dimension pRetVal);
  /*[id(0x60020003)]*/ int preferredSize(int cols, out _Dimension pRetVal);
  /*[id(0x60020004)]*/ int setEchoChar(ushort c);
  /*[id(0x60020005)]*/ int setEchoCharacter(ushort c);
}

interface TextListener : IDispatch {
  mixin(uuid("ed41af71-9b99-3db6-835c-ea8052f7de19"));
  /*[id(0x60020000)]*/ int textValueChanged(_TextEvent evt);
}

interface Transferable : IDispatch {
  mixin(uuid("d5b86b6b-93aa-358d-b949-7784305d213f"));
  /*[id(0x60020000)]*/ int getTransferData(_DataFlavor flavor, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int getTransferDataFlavors(out  pRetVal);
  /*[id(0x60020002)]*/ int isDataFlavorSupported(_DataFlavor flavor, out short pRetVal);
}

interface WindowListener : IDispatch {
  mixin(uuid("625f7c67-1274-3260-90b7-c9439fdf03b6"));
  /*[id(0x60020000)]*/ int windowActivated(_WindowEvent evt);
  /*[id(0x60020001)]*/ int windowClosed(_WindowEvent evt);
  /*[id(0x60020002)]*/ int windowClosing(_WindowEvent evt);
  /*[id(0x60020003)]*/ int windowDeactivated(_WindowEvent evt);
  /*[id(0x60020004)]*/ int windowDeiconified(_WindowEvent evt);
  /*[id(0x60020005)]*/ int windowIconified(_WindowEvent evt);
  /*[id(0x60020006)]*/ int windowOpened(_WindowEvent evt);
}

interface WindowPeer : IDispatch {
  mixin(uuid("133da961-629a-37ca-a155-16cc7c375364"));
  /*[id(0x60020000)]*/ int toBack();
  /*[id(0x60020001)]*/ int toFront();
}

interface InputManagerListener : IDispatch {
  mixin(uuid("59a6f978-60e7-3761-9e75-1268dcd36f5b"));
  /*[id(0x60020000)]*/ int getCurrentInputMethod(out InputMethodListener pRetVal);
  /*[id(0x60020001)]*/ int getInputMethod(int idx, out InputMethodListener pRetVal);
  /*[id(0x60020002)]*/ int getNumberInputMethods(out int pRetVal);
  /*[id(0x60020003)]*/ int handledKey(InputMethodCallback imeCallback, long when, int keyCode, int keyChar, int state, out short pRetVal);
  /*[id(0x60020004)]*/ int removeInputMethod(InputMethodListener ime);
  /*[id(0x60020005)]*/ int setInputMethod(InputMethodListener ime);
}

interface InputMethodCallback : IDispatch {
  mixin(uuid("e35db9ed-b554-35ff-8aca-7d19445c35a7"));
  /*[id(0x60020000)]*/ int handleIMEChar(long when, ushort keyChar, int state);
  /*[id(0x60020001)]*/ int handleIMEMessage(_InputMethodMessage IMEMessage);
}

interface InputMethodListener : IDispatch {
  mixin(uuid("8bd0c9da-32ad-3667-8798-a9c2e2b6fdb2"));
  /*[id(0x60020000)]*/ int activate();
  /*[id(0x60020001)]*/ int deactivate();
  /*[id(0x60020002)]*/ int getName(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int handledKey(InputMethodCallback imeCallback, long when, int keyCode, int keyChar, int state, out short pRetVal);
  /*[id(0x60020004)]*/ int handleIMEMessage(_InputMethodMessage IMEMessage);
  /*[id(0x60020005)]*/ int paint(_Graphics g);
  /*[id(0x60020006)]*/ int setFont(_Font Font);
  /*[id(0x60020007)]*/ int setPos(int x, int y);
  /*[id(0x60020008)]*/ int setVisibleComponent(_Component c);
  /*[id(0x60020009)]*/ int SIZE(_Graphics g, out _Dimension pRetVal);
}

interface InputMethodMessageListener : IDispatch {
  mixin(uuid("75d58bcb-fb43-393d-a317-1f55e935bb77"));
  /*[id(0x60020000)]*/ int handleIMEMessage(_InputMethodMessage IMEMessage, out short pRetVal);
}

interface BeanInfo : IDispatch {
  mixin(uuid("399ed921-46e0-3bd1-a8c6-af82ea38536f"));
  /*[id(0x60020000)]*/ int getAdditionalBeanInfo(out  pRetVal);
  /*[id(0x60020001)]*/ int getBeanDescriptor(out _BeanDescriptor pRetVal);
  /*[id(0x60020002)]*/ int getDefaultEventIndex(out int pRetVal);
  /*[id(0x60020003)]*/ int getDefaultPropertyIndex(out int pRetVal);
  /*[id(0x60020004)]*/ int getEventSetDescriptors(out  pRetVal);
  /*[id(0x60020005)]*/ int getIcon(int iconKind, out _Image pRetVal);
  /*[id(0x60020006)]*/ int getMethodDescriptors(out  pRetVal);
  /*[id(0x60020007)]*/ int getPropertyDescriptors(out  pRetVal);
}

interface Customizer : IDispatch {
  mixin(uuid("664fb579-5d8d-3b71-b050-2840e526ffe9"));
  /*[id(0x60020000)]*/ int addPropertyChangeListener(PropertyChangeListener listener);
  /*[id(0x60020001)]*/ int removePropertyChangeListener(PropertyChangeListener listener);
  /*[id(0x60020002)]*/ int setObject(VARIANT bean);
}

interface PropertyChangeListener : IDispatch {
  mixin(uuid("df49ff2a-c3c6-34e5-ba8b-1f2ec152966d"));
  /*[id(0x60020000)]*/ int propertyChange(_PropertyChangeEvent evt);
}

interface PropertyEditor : IDispatch {
  mixin(uuid("a6ec3bd2-bf9e-3e97-862a-38fc81f62c3e"));
  /*[id(0x60020000)]*/ int addPropertyChangeListener(PropertyChangeListener listener);
  /*[id(0x60020001)]*/ int getAsText(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int getCustomEditor(out _Component pRetVal);
  /*[id(0x60020003)]*/ int getJavaInitializationString(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int getTags(out  pRetVal);
  /*[id(0x60020005)]*/ int getValue(out VARIANT pRetVal);
  /*[id(0x60020006)]*/ int isPaintable(out short pRetVal);
  /*[id(0x60020007)]*/ int paintValue(_Graphics gfx, _Rectangle box);
  /*[id(0x60020008)]*/ int removePropertyChangeListener(PropertyChangeListener listener);
  /*[id(0x60020009)]*/ int setAsText(wchar* text);
  /*[id(0x6002000A)]*/ int setValue(VARIANT value);
  /*[id(0x6002000B)]*/ int supportsCustomEditor(out short pRetVal);
}

interface VetoableChangeListener : IDispatch {
  mixin(uuid("2fd349c3-c79d-3595-8497-79cba8f060ac"));
  /*[id(0x60020000)]*/ int vetoableChange(_PropertyChangeEvent evt);
}

interface Visibility : IDispatch {
  mixin(uuid("eb171dcc-0732-3587-b33b-09fcdc7a8242"));
  /*[id(0x60020000)]*/ int avoidingGui(out short pRetVal);
  /*[id(0x60020001)]*/ int dontUseGui();
  /*[id(0x60020002)]*/ int needsGui(out short pRetVal);
  /*[id(0x60020003)]*/ int okToUseGui();
}

interface ComContext : IDispatch {
  mixin(uuid("ab0fec32-b7fc-3dd3-a0ec-77105782f27c"));
}

interface IAccessibleDefault : IDispatch {
  mixin(uuid("fd42fae0-58ff-3552-a087-953288ff8379"));
  /*[id(0x60020000)]*/ int getAccParent(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int getAccChildCount(out int pRetVal);
  /*[id(0x60020002)]*/ int getAccChild(_Variant varChild, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int getAccName(_Variant varChild, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int getAccValue(_Variant varChild, out wchar* pRetVal);
  /*[id(0x60020005)]*/ int getAccDescription(_Variant varChild, out wchar* pRetVal);
  /*[id(0x60020006)]*/ int getAccRole(_Variant varChild, out _Variant pRetVal);
  /*[id(0x60020007)]*/ int getAccState(_Variant varChild, out _Variant pRetVal);
  /*[id(0x60020008)]*/ int getAccHelp(_Variant varChild, out wchar* pRetVal);
  /*[id(0x60020009)]*/ int getAccHelpTopic( pszHelpFile, _Variant varChild, out int pRetVal);
  /*[id(0x6002000A)]*/ int getAccKeyboardShortcut(_Variant varChild, out wchar* pRetVal);
  /*[id(0x6002000B)]*/ int getAccFocus(out _Variant pRetVal);
  /*[id(0x6002000C)]*/ int getAccSelection(out _Variant pRetVal);
  /*[id(0x6002000D)]*/ int getAccDefaultAction(_Variant varChild, out wchar* pRetVal);
  /*[id(0x6002000E)]*/ int accSelect(int flagsSelect, _Variant varChild);
  /*[id(0x6002000F)]*/ int accLocation( pxLeft,  pyTop,  pcxWidth,  pcyHeight, _Variant varChild);
  /*[id(0x60020010)]*/ int accNavigate(int navDir, _Variant varStart, out _Variant pRetVal);
  /*[id(0x60020011)]*/ int accHitTest(int xLeft, int yTop, out _Variant pRetVal);
  /*[id(0x60020012)]*/ int accDoDefaultAction(_Variant varChild);
  /*[id(0x60020013)]*/ int setAccName(_Variant varChild, wchar* pszName);
  /*[id(0x60020014)]*/ int setAccValue(_Variant varChild, wchar* pszValue);
}

interface ICOMAccessable : IDispatch {
  mixin(uuid("9f63e292-8981-33a1-b813-895b5ef54e76"));
  /*[id(0x60020000)]*/ int getNETCallableWrapper(out VARIANT pRetVal);
}

interface IExternalConnectionSink : IDispatch {
  mixin(uuid("5026997c-a428-3a89-8a6f-50a19fd6322a"));
  /*[id(0x60020000)]*/ int OnAddConnection(int exconn, int reserved, int refcount);
  /*[id(0x60020001)]*/ int OnReleaseConnection(int exconn, int reserved, short fLastReleaseCloses, int refcount);
}

interface IJavaCOMClassWrapper : IDispatch {
  mixin(uuid("c7d462bc-6d00-3b13-9630-f090751d57c6"));
  /*[id(0x60020000)]*/ int getCOMObject(out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int getInterfaceWrapper(wchar* obj, out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int setInterfaceWrapper(wchar* ia, VARIANT iah);
}

interface IJavaCOMInterfaceWrapper : IDispatch {
  mixin(uuid("84f03dea-7f13-304c-bb17-391a2f9fb26e"));
  /*[id(0x60020000)]*/ int getJCCW(out IJavaCOMClassWrapper pRetVal);
}

interface ILicenseMgr : IDispatch {
  mixin(uuid("68145efa-33fb-333c-928c-87e0ab7c1853"));
  /*[id(0x60020000)]*/ int setPackage(wchar* URL);
  /*[id(0x60020001)]*/ int createFromPackage(int index, IUnknown punkOuter, int ctxFlags, out IUnknown pRetVal);
  /*[id(0x60020002)]*/ int createInstance(wchar* CLSID, IUnknown punkOuter, int ctxFlags, out IUnknown pRetVal);
  /*[id(0x60020003)]*/ int createWithLic(wchar* lic, wchar* CLSID, IUnknown punkOuter, int ctxFlags, out IUnknown pRetVal);
}

interface INETCallableWrapper : IDispatch {
  mixin(uuid("2d187d42-45f6-37d4-9192-4fe44b12f606"));
  /*[id(0x60020000)]*/ int getWrappedObject(out VARIANT pRetVal);
}

interface NoAutoMarshaling : IDispatch {
  mixin(uuid("cc6b1ef2-c88b-3d3b-88ed-3b677a92f733"));
}

interface NoAutoScripting : IDispatch {
  mixin(uuid("4b5c6a9e-9997-32f2-83bb-728188634d6e"));
}

interface oleacc : IDispatch {
  mixin(uuid("4b95ac2d-d07d-3ae4-8007-83b9f881ca42"));
}

interface CallableStatement : IDispatch {
  mixin(uuid("7cc285af-c16a-324c-83f8-f168398069ba"));
  /*[id(0x60020000)]*/ int getBigDecimal(int parameterIndex, int scale, out _BigDecimal pRetVal);
  /*[id(0x60020001)]*/ int getBoolean(int parameterIndex, out short pRetVal);
  /*[id(0x60020002)]*/ int getByte(int parameterIndex, out byte pRetVal);
  /*[id(0x60020003)]*/ int getBytes(int parameterIndex, out  pRetVal);
  /*[id(0x60020004)]*/ int getDate(int parameterIndex, out _java_sql_Date pRetVal);
  /*[id(0x60020005)]*/ int getDouble(int parameterIndex, out double pRetVal);
  /*[id(0x60020006)]*/ int getFloat(int parameterIndex, out float pRetVal);
  /*[id(0x60020007)]*/ int getInt(int parameterIndex, out int pRetVal);
  /*[id(0x60020008)]*/ int getLong(int parameterIndex, out long pRetVal);
  /*[id(0x60020009)]*/ int getObject(int parameterIndex, out VARIANT pRetVal);
  /*[id(0x6002000A)]*/ int getShort(int parameterIndex, out short pRetVal);
  /*[id(0x6002000B)]*/ int getString(int parameterIndex, out wchar* pRetVal);
  /*[id(0x6002000C)]*/ int getTime(int parameterIndex, out _Time pRetVal);
  /*[id(0x6002000D)]*/ int getTimestamp(int parameterIndex, out _Timestamp pRetVal);
  /*[id(0x6002000E)]*/ int registerOutParameter(int parameterIndex, int sqlType);
  /*[id(0x6002000F)]*/ int registerOutParameter_2(int parameterIndex, int sqlType, int scale);
  /*[id(0x60020010)]*/ int wasNull(out short pRetVal);
}

interface Connection : IDispatch {
  mixin(uuid("f25f7e68-ebd0-34cb-b8cb-47b4d53a3bf2"));
  /*[id(0x60020000)]*/ int clearWarnings();
  /*[id(0x60020001)]*/ int close();
  /*[id(0x60020002)]*/ int commit();
  /*[id(0x60020003)]*/ int createStatement(out Statement pRetVal);
  /*[id(0x60020004)]*/ int getAutoCommit(out short pRetVal);
  /*[id(0x60020005)]*/ int getCatalog(out wchar* pRetVal);
  /*[id(0x60020006)]*/ int getMetaData(out DatabaseMetaData pRetVal);
  /*[id(0x60020007)]*/ int getTransactionIsolation(out int pRetVal);
  /*[id(0x60020008)]*/ int getWarnings(out _SQLWarning pRetVal);
  /*[id(0x60020009)]*/ int isClosed(out short pRetVal);
  /*[id(0x6002000A)]*/ int isReadOnly(out short pRetVal);
  /*[id(0x6002000B)]*/ int nativeSQL(wchar* sql, out wchar* pRetVal);
  /*[id(0x6002000C)]*/ int prepareCall(wchar* sql, out CallableStatement pRetVal);
  /*[id(0x6002000D)]*/ int prepareStatement(wchar* sql, out PreparedStatement pRetVal);
  /*[id(0x6002000E)]*/ int rollback();
  /*[id(0x6002000F)]*/ int setAutoCommit(short autoCommit);
  /*[id(0x60020010)]*/ int setCatalog(wchar* catalog);
  /*[id(0x60020011)]*/ int setReadOnly(short readOnly);
  /*[id(0x60020012)]*/ int setTransactionIsolation(int transactionIsolation);
}

interface DatabaseMetaData : IDispatch {
  mixin(uuid("87ff575f-66c2-3309-bd71-639f77676973"));
  /*[id(0x60020000)]*/ int allProceduresAreCallable(out short pRetVal);
  /*[id(0x60020001)]*/ int allTablesAreSelectable(out short pRetVal);
  /*[id(0x60020002)]*/ int dataDefinitionCausesTransactionCommit(out short pRetVal);
  /*[id(0x60020003)]*/ int dataDefinitionIgnoredInTransactions(out short pRetVal);
  /*[id(0x60020004)]*/ int doesMaxRowSizeIncludeBlobs(out short pRetVal);
  /*[id(0x60020005)]*/ int getBestRowIdentifier(wchar* catalog, wchar* schema, wchar* table, int scopeParam, short nullable, out ResultSet pRetVal);
  /*[id(0x60020006)]*/ int getCatalogs(out ResultSet pRetVal);
  /*[id(0x60020007)]*/ int getCatalogSeparator(out wchar* pRetVal);
  /*[id(0x60020008)]*/ int getCatalogTerm(out wchar* pRetVal);
  /*[id(0x60020009)]*/ int getColumnPrivileges(wchar* catalog, wchar* schema, wchar* table, wchar* colNamePattern, out ResultSet pRetVal);
  /*[id(0x6002000A)]*/ int getColumns(wchar* catalog, wchar* schemaPattern, wchar* tableNamePattern, wchar* columnNamePattern, out ResultSet pRetVal);
  /*[id(0x6002000B)]*/ int getCrossReference(wchar* primaryCatalog, wchar* primarySchema, wchar* primaryTable, wchar* foreignCatalog, wchar* foreignSchema, wchar* foreignTable, out ResultSet pRetVal);
  /*[id(0x6002000C)]*/ int getDatabaseProductName(out wchar* pRetVal);
  /*[id(0x6002000D)]*/ int getDatabaseProductVersion(out wchar* pRetVal);
  /*[id(0x6002000E)]*/ int getDefaultTransactionIsolation(out int pRetVal);
  /*[id(0x6002000F)]*/ int getDriverMajorVersion(out int pRetVal);
  /*[id(0x60020010)]*/ int getDriverMinorVersion(out int pRetVal);
  /*[id(0x60020011)]*/ int getDriverName(out wchar* pRetVal);
  /*[id(0x60020012)]*/ int getDriverVersion(out wchar* pRetVal);
  /*[id(0x60020013)]*/ int getExportedKeys(wchar* catalog, wchar* schema, wchar* table, out ResultSet pRetVal);
  /*[id(0x60020014)]*/ int getExtraNameCharacters(out wchar* pRetVal);
  /*[id(0x60020015)]*/ int getIdentifierQuoteString(out wchar* pRetVal);
  /*[id(0x60020016)]*/ int getImportedKeys(wchar* catalog, wchar* schema, wchar* table, out ResultSet pRetVal);
  /*[id(0x60020017)]*/ int getIndexInfo(wchar* catalog, wchar* schema, wchar* table, short unique, short approximate, out ResultSet pRetVal);
  /*[id(0x60020018)]*/ int getMaxBinaryLiteralLength(out int pRetVal);
  /*[id(0x60020019)]*/ int getMaxCatalogNameLength(out int pRetVal);
  /*[id(0x6002001A)]*/ int getMaxCharLiteralLength(out int pRetVal);
  /*[id(0x6002001B)]*/ int getMaxColumnNameLength(out int pRetVal);
  /*[id(0x6002001C)]*/ int getMaxColumnsInGroupBy(out int pRetVal);
  /*[id(0x6002001D)]*/ int getMaxColumnsInIndex(out int pRetVal);
  /*[id(0x6002001E)]*/ int getMaxColumnsInOrderBy(out int pRetVal);
  /*[id(0x6002001F)]*/ int getMaxColumnsInSelect(out int pRetVal);
  /*[id(0x60020020)]*/ int getMaxColumnsInTable(out int pRetVal);
  /*[id(0x60020021)]*/ int getMaxConnections(out int pRetVal);
  /*[id(0x60020022)]*/ int getMaxCursorNameLength(out int pRetVal);
  /*[id(0x60020023)]*/ int getMaxIndexLength(out int pRetVal);
  /*[id(0x60020024)]*/ int getMaxProcedureNameLength(out int pRetVal);
  /*[id(0x60020025)]*/ int getMaxRowSize(out int pRetVal);
  /*[id(0x60020026)]*/ int getMaxSchemaNameLength(out int pRetVal);
  /*[id(0x60020027)]*/ int getMaxStatementLength(out int pRetVal);
  /*[id(0x60020028)]*/ int getMaxStatements(out int pRetVal);
  /*[id(0x60020029)]*/ int getMaxTableNameLength(out int pRetVal);
  /*[id(0x6002002A)]*/ int getMaxTablesInSelect(out int pRetVal);
  /*[id(0x6002002B)]*/ int getMaxUserNameLength(out int pRetVal);
  /*[id(0x6002002C)]*/ int getNumericFunctions(out wchar* pRetVal);
  /*[id(0x6002002D)]*/ int getPrimaryKeys(wchar* catalog, wchar* schema, wchar* table, out ResultSet pRetVal);
  /*[id(0x6002002E)]*/ int getProcedureColumns(wchar* catalog, wchar* schemaPattern, wchar* procedureNamePattern, wchar* columnNamePattern, out ResultSet pRetVal);
  /*[id(0x6002002F)]*/ int getProcedures(wchar* catalog, wchar* schemaPattern, wchar* procedureNamePattern, out ResultSet pRetVal);
  /*[id(0x60020030)]*/ int getProcedureTerm(out wchar* pRetVal);
  /*[id(0x60020031)]*/ int getSchemas(out ResultSet pRetVal);
  /*[id(0x60020032)]*/ int getSchemaTerm(out wchar* pRetVal);
  /*[id(0x60020033)]*/ int getSearchStringEscape(out wchar* pRetVal);
  /*[id(0x60020034)]*/ int getSQLKeywords(out wchar* pRetVal);
  /*[id(0x60020035)]*/ int getStringFunctions(out wchar* pRetVal);
  /*[id(0x60020036)]*/ int getSystemFunctions(out wchar* pRetVal);
  /*[id(0x60020037)]*/ int getTablePrivileges(wchar* catalog, wchar* schemaPattern, wchar* tableNamePattern, out ResultSet pRetVal);
  /*[id(0x60020038)]*/ int getTables(wchar* catalog, wchar* schemaPattern, wchar* tableNamePattern,  Types, out ResultSet pRetVal);
  /*[id(0x60020039)]*/ int getTableTypes(out ResultSet pRetVal);
  /*[id(0x6002003A)]*/ int getTimeDateFunctions(out wchar* pRetVal);
  /*[id(0x6002003B)]*/ int getTypeInfo_2(out ResultSet pRetVal);
  /*[id(0x6002003C)]*/ int getURL(out wchar* pRetVal);
  /*[id(0x6002003D)]*/ int getUserName(out wchar* pRetVal);
  /*[id(0x6002003E)]*/ int getVersionColumns(wchar* catalog, wchar* schema, wchar* table, out ResultSet pRetVal);
  /*[id(0x6002003F)]*/ int isCatalogAtStart(out short pRetVal);
  /*[id(0x60020040)]*/ int isReadOnly(out short pRetVal);
  /*[id(0x60020041)]*/ int nullPlusNonNullIsNull(out short pRetVal);
  /*[id(0x60020042)]*/ int nullsAreSortedAtEnd(out short pRetVal);
  /*[id(0x60020043)]*/ int nullsAreSortedAtStart(out short pRetVal);
  /*[id(0x60020044)]*/ int nullsAreSortedHigh(out short pRetVal);
  /*[id(0x60020045)]*/ int nullsAreSortedLow(out short pRetVal);
  /*[id(0x60020046)]*/ int storesLowerCaseIdentifiers(out short pRetVal);
  /*[id(0x60020047)]*/ int storesLowerCaseQuotedIdentifiers(out short pRetVal);
  /*[id(0x60020048)]*/ int storesMixedCaseIdentifiers(out short pRetVal);
  /*[id(0x60020049)]*/ int storesMixedCaseQuotedIdentifiers(out short pRetVal);
  /*[id(0x6002004A)]*/ int storesUpperCaseIdentifiers(out short pRetVal);
  /*[id(0x6002004B)]*/ int storesUpperCaseQuotedIdentifiers(out short pRetVal);
  /*[id(0x6002004C)]*/ int supportsAlterTableWithAddColumn(out short pRetVal);
  /*[id(0x6002004D)]*/ int supportsAlterTableWithDropColumn(out short pRetVal);
  /*[id(0x6002004E)]*/ int supportsANSI92EntryLevelSQL(out short pRetVal);
  /*[id(0x6002004F)]*/ int supportsANSI92FullSQL(out short pRetVal);
  /*[id(0x60020050)]*/ int supportsANSI92IntermediateSQL(out short pRetVal);
  /*[id(0x60020051)]*/ int supportsCatalogsInDataManipulation(out short pRetVal);
  /*[id(0x60020052)]*/ int supportsCatalogsInIndexDefinitions(out short pRetVal);
  /*[id(0x60020053)]*/ int supportsCatalogsInPrivilegeDefinitions(out short pRetVal);
  /*[id(0x60020054)]*/ int supportsCatalogsInProcedureCalls(out short pRetVal);
  /*[id(0x60020055)]*/ int supportsCatalogsInTableDefinitions(out short pRetVal);
  /*[id(0x60020056)]*/ int supportsColumnAliasing(out short pRetVal);
  /*[id(0x60020057)]*/ int supportsConvert(out short pRetVal);
  /*[id(0x60020058)]*/ int supportsConvert_2(int fromType, int toType, out short pRetVal);
  /*[id(0x60020059)]*/ int supportsCoreSQLGrammar(out short pRetVal);
  /*[id(0x6002005A)]*/ int supportsCorrelatedSubqueries(out short pRetVal);
  /*[id(0x6002005B)]*/ int supportsDataDefinitionAndDataManipulationTransactions(out short pRetVal);
  /*[id(0x6002005C)]*/ int supportsDataManipulationTransactionsOnly(out short pRetVal);
  /*[id(0x6002005D)]*/ int supportsDifferentTableCorrelationNames(out short pRetVal);
  /*[id(0x6002005E)]*/ int supportsExpressionsInOrderBy(out short pRetVal);
  /*[id(0x6002005F)]*/ int supportsExtendedSQLGrammar(out short pRetVal);
  /*[id(0x60020060)]*/ int supportsFullOuterJoins(out short pRetVal);
  /*[id(0x60020061)]*/ int supportsGroupBy(out short pRetVal);
  /*[id(0x60020062)]*/ int supportsGroupByBeyondSelect(out short pRetVal);
  /*[id(0x60020063)]*/ int supportsGroupByUnrelated(out short pRetVal);
  /*[id(0x60020064)]*/ int supportsIntegrityEnhancementFacility(out short pRetVal);
  /*[id(0x60020065)]*/ int supportsLikeEscapeClause(out short pRetVal);
  /*[id(0x60020066)]*/ int supportsLimitedOuterJoins(out short pRetVal);
  /*[id(0x60020067)]*/ int supportsMinimumSQLGrammar(out short pRetVal);
  /*[id(0x60020068)]*/ int supportsMixedCaseIdentifiers(out short pRetVal);
  /*[id(0x60020069)]*/ int supportsMixedCaseQuotedIdentifiers(out short pRetVal);
  /*[id(0x6002006A)]*/ int supportsMultipleResultSets(out short pRetVal);
  /*[id(0x6002006B)]*/ int supportsMultipleTransactions(out short pRetVal);
  /*[id(0x6002006C)]*/ int supportsNonNullableColumns(out short pRetVal);
  /*[id(0x6002006D)]*/ int supportsOpenCursorsAcrossCommit(out short pRetVal);
  /*[id(0x6002006E)]*/ int supportsOpenCursorsAcrossRollback(out short pRetVal);
  /*[id(0x6002006F)]*/ int supportsOpenStatementsAcrossCommit(out short pRetVal);
  /*[id(0x60020070)]*/ int supportsOpenStatementsAcrossRollback(out short pRetVal);
  /*[id(0x60020071)]*/ int supportsOrderByUnrelated(out short pRetVal);
  /*[id(0x60020072)]*/ int supportsOuterJoins(out short pRetVal);
  /*[id(0x60020073)]*/ int supportsPositionedDelete(out short pRetVal);
  /*[id(0x60020074)]*/ int supportsPositionedUpdate(out short pRetVal);
  /*[id(0x60020075)]*/ int supportsSchemasInDataManipulation(out short pRetVal);
  /*[id(0x60020076)]*/ int supportsSchemasInIndexDefinitions(out short pRetVal);
  /*[id(0x60020077)]*/ int supportsSchemasInPrivilegeDefinitions(out short pRetVal);
  /*[id(0x60020078)]*/ int supportsSchemasInProcedureCalls(out short pRetVal);
  /*[id(0x60020079)]*/ int supportsSchemasInTableDefinitions(out short pRetVal);
  /*[id(0x6002007A)]*/ int supportsSelectForUpdate(out short pRetVal);
  /*[id(0x6002007B)]*/ int supportsStoredProcedures(out short pRetVal);
  /*[id(0x6002007C)]*/ int supportsSubqueriesInComparisons(out short pRetVal);
  /*[id(0x6002007D)]*/ int supportsSubqueriesInExists(out short pRetVal);
  /*[id(0x6002007E)]*/ int supportsSubqueriesInIns(out short pRetVal);
  /*[id(0x6002007F)]*/ int supportsSubqueriesInQuantifieds(out short pRetVal);
  /*[id(0x60020080)]*/ int supportsTableCorrelationNames(out short pRetVal);
  /*[id(0x60020081)]*/ int supportsTransactionIsolationLevel(int level, out short pRetVal);
  /*[id(0x60020082)]*/ int supportsTransactions(out short pRetVal);
  /*[id(0x60020083)]*/ int supportsUnion(out short pRetVal);
  /*[id(0x60020084)]*/ int supportsUnionAll(out short pRetVal);
  /*[id(0x60020085)]*/ int usesLocalFilePerTable(out short pRetVal);
  /*[id(0x60020086)]*/ int usesLocalFiles(out short pRetVal);
}

interface Driver : IDispatch {
  mixin(uuid("4a120735-3e6a-3f21-850c-d3550d4ffc6e"));
  /*[id(0x60020000)]*/ int acceptsURL(wchar* URL, out short pRetVal);
  /*[id(0x60020001)]*/ int connect(wchar* URL, _Properties info, out Connection pRetVal);
  /*[id(0x60020002)]*/ int getMajorVersion(out int pRetVal);
  /*[id(0x60020003)]*/ int getMinorVersion(out int pRetVal);
  /*[id(0x60020004)]*/ int getPropertyInfo(wchar* URL, _Properties info, out  pRetVal);
  /*[id(0x60020005)]*/ int jdbcCompliant(out short pRetVal);
}

interface PreparedStatement : IDispatch {
  mixin(uuid("5d03644c-427b-3ee2-9b63-8fb1b50e419f"));
  /*[id(0x60020000)]*/ int clearParameters();
  /*[id(0x60020001)]*/ int execute(out short pRetVal);
  /*[id(0x60020002)]*/ int executeQuery(out ResultSet pRetVal);
  /*[id(0x60020003)]*/ int executeUpdate(out int pRetVal);
  /*[id(0x60020004)]*/ int setAsciiStream(int parameterIndex, _InputStream x, int length);
  /*[id(0x60020005)]*/ int setBigDecimal(int parameterIndex, _BigDecimal x);
  /*[id(0x60020006)]*/ int setBinaryStream(int parameterIndex, _InputStream x, int length);
  /*[id(0x60020007)]*/ int setBoolean(int parameterIndex, short x);
  /*[id(0x60020008)]*/ int setByte(int parameterIndex, byte x);
  /*[id(0x60020009)]*/ int setBytes(int parameterIndex,  x);
  /*[id(0x6002000A)]*/ int setDate(int parameterIndex, _java_sql_Date x);
  /*[id(0x6002000B)]*/ int setDouble(int parameterIndex, double x);
  /*[id(0x6002000C)]*/ int setFloat(int parameterIndex, float x);
  /*[id(0x6002000D)]*/ int setInt(int parameterIndex, int x);
  /*[id(0x6002000E)]*/ int setLong(int parameterIndex, long x);
  /*[id(0x6002000F)]*/ int setNull(int parameterIndex, int sqlType);
  /*[id(0x60020010)]*/ int setObject(int parameterIndex, VARIANT x, int targetSqlType, int scale);
  /*[id(0x60020011)]*/ int setObject_2(int parameterIndex, VARIANT x, int targetSqlType);
  /*[id(0x60020012)]*/ int setObject_3(int parameterIndex, VARIANT x);
  /*[id(0x60020013)]*/ int setShort(int parameterIndex, short x);
  /*[id(0x60020014)]*/ int setString(int parameterIndex, wchar* x);
  /*[id(0x60020015)]*/ int setTime(int parameterIndex, _Time x);
  /*[id(0x60020016)]*/ int setTimestamp(int parameterIndex, _Timestamp x);
  /*[id(0x60020017)]*/ int setUnicodeStream(int parameterIndex, _InputStream x, int length);
}

interface ResultSet : IDispatch {
  mixin(uuid("2e8c8f94-ce24-36ab-8d0f-5c293e181eb1"));
  /*[id(0x60020000)]*/ int clearWarnings();
  /*[id(0x60020001)]*/ int close();
  /*[id(0x60020002)]*/ int findColumn(wchar* columnName, out int pRetVal);
  /*[id(0x60020003)]*/ int getAsciiStream(int columnIndex, out _InputStream pRetVal);
  /*[id(0x60020004)]*/ int getAsciiStream_2(wchar* columnName, out _InputStream pRetVal);
  /*[id(0x60020005)]*/ int getBigDecimal(int columnIndex, int scale, out _BigDecimal pRetVal);
  /*[id(0x60020006)]*/ int getBigDecimal_2(wchar* columnName, int scale, out _BigDecimal pRetVal);
  /*[id(0x60020007)]*/ int getBinaryStream(int columnIndex, out _InputStream pRetVal);
  /*[id(0x60020008)]*/ int getBinaryStream_2(wchar* columnName, out _InputStream pRetVal);
  /*[id(0x60020009)]*/ int getBoolean(int columnIndex, out short pRetVal);
  /*[id(0x6002000A)]*/ int getBoolean_2(wchar* columnName, out short pRetVal);
  /*[id(0x6002000B)]*/ int getByte(int columnIndex, out byte pRetVal);
  /*[id(0x6002000C)]*/ int getByte_2(wchar* columnName, out byte pRetVal);
  /*[id(0x6002000D)]*/ int getBytes(int columnIndex, out  pRetVal);
  /*[id(0x6002000E)]*/ int getBytes_2(wchar* columnName, out  pRetVal);
  /*[id(0x6002000F)]*/ int getCursorName(out wchar* pRetVal);
  /*[id(0x60020010)]*/ int getDate(int columnIndex, out _java_sql_Date pRetVal);
  /*[id(0x60020011)]*/ int getDate_2(wchar* columnName, out _java_sql_Date pRetVal);
  /*[id(0x60020012)]*/ int getDouble(int columnIndex, out double pRetVal);
  /*[id(0x60020013)]*/ int getDouble_2(wchar* columnName, out double pRetVal);
  /*[id(0x60020014)]*/ int getFloat(int columnIndex, out float pRetVal);
  /*[id(0x60020015)]*/ int getFloat_2(wchar* columnName, out float pRetVal);
  /*[id(0x60020016)]*/ int getInt(int columnIndex, out int pRetVal);
  /*[id(0x60020017)]*/ int getInt_2(wchar* columnName, out int pRetVal);
  /*[id(0x60020018)]*/ int getLong(int columnIndex, out long pRetVal);
  /*[id(0x60020019)]*/ int getLong_2(wchar* columnName, out long pRetVal);
  /*[id(0x6002001A)]*/ int getMetaData(out ResultSetMetaData pRetVal);
  /*[id(0x6002001B)]*/ int getObject(int columnIndex, out VARIANT pRetVal);
  /*[id(0x6002001C)]*/ int getObject_2(wchar* columnName, out VARIANT pRetVal);
  /*[id(0x6002001D)]*/ int getShort(int columnIndex, out short pRetVal);
  /*[id(0x6002001E)]*/ int getShort_2(wchar* columnName, out short pRetVal);
  /*[id(0x6002001F)]*/ int getString(int columnIndex, out wchar* pRetVal);
  /*[id(0x60020020)]*/ int getString_2(wchar* columnName, out wchar* pRetVal);
  /*[id(0x60020021)]*/ int getTime(int columnIndex, out _Time pRetVal);
  /*[id(0x60020022)]*/ int getTime_2(wchar* columnName, out _Time pRetVal);
  /*[id(0x60020023)]*/ int getTimestamp(int columnIndex, out _Timestamp pRetVal);
  /*[id(0x60020024)]*/ int getTimestamp_2(wchar* columnName, out _Timestamp pRetVal);
  /*[id(0x60020025)]*/ int getUnicodeStream(int columnIndex, out _InputStream pRetVal);
  /*[id(0x60020026)]*/ int getUnicodeStream_2(wchar* columnName, out _InputStream pRetVal);
  /*[id(0x60020027)]*/ int getWarnings(out _SQLWarning pRetVal);
  /*[id(0x60020028)]*/ int next(out short pRetVal);
  /*[id(0x60020029)]*/ int wasNull(out short pRetVal);
}

interface ResultSetMetaData : IDispatch {
  mixin(uuid("16074175-356f-382c-be75-2c7a0ce1b51d"));
  /*[id(0x60020000)]*/ int getCatalogName(int column, out wchar* pRetVal);
  /*[id(0x60020001)]*/ int getColumnCount(out int pRetVal);
  /*[id(0x60020002)]*/ int getColumnDisplaySize(int column, out int pRetVal);
  /*[id(0x60020003)]*/ int getColumnLabel(int column, out wchar* pRetVal);
  /*[id(0x60020004)]*/ int getColumnName(int column, out wchar* pRetVal);
  /*[id(0x60020005)]*/ int getColumnType(int column, out int pRetVal);
  /*[id(0x60020006)]*/ int getColumnTypeName(int column, out wchar* pRetVal);
  /*[id(0x60020007)]*/ int getPrecision(int column, out int pRetVal);
  /*[id(0x60020008)]*/ int getScale(int column, out int pRetVal);
  /*[id(0x60020009)]*/ int getSchemaName(int column, out wchar* pRetVal);
  /*[id(0x6002000A)]*/ int getTableName(int column, out wchar* pRetVal);
  /*[id(0x6002000B)]*/ int isAutoIncrement(int column, out short pRetVal);
  /*[id(0x6002000C)]*/ int isCaseSensitive(int column, out short pRetVal);
  /*[id(0x6002000D)]*/ int isCurrency(int column, out short pRetVal);
  /*[id(0x6002000E)]*/ int isDefinitelyWritable(int column, out short pRetVal);
  /*[id(0x6002000F)]*/ int isNullable(int column, out int pRetVal);
  /*[id(0x60020010)]*/ int isReadOnly(int column, out short pRetVal);
  /*[id(0x60020011)]*/ int isSearchable(int column, out short pRetVal);
  /*[id(0x60020012)]*/ int isSigned(int column, out short pRetVal);
  /*[id(0x60020013)]*/ int isWritable(int column, out short pRetVal);
}

interface Statement : IDispatch {
  mixin(uuid("b13b0825-1c21-3697-8643-66743e976de2"));
  /*[id(0x60020000)]*/ int cancel();
  /*[id(0x60020001)]*/ int clearWarnings();
  /*[id(0x60020002)]*/ int close();
  /*[id(0x60020003)]*/ int execute(wchar* sql, out short pRetVal);
  /*[id(0x60020004)]*/ int executeQuery(wchar* sql, out ResultSet pRetVal);
  /*[id(0x60020005)]*/ int executeUpdate(wchar* sql, out int pRetVal);
  /*[id(0x60020006)]*/ int getMaxFieldSize(out int pRetVal);
  /*[id(0x60020007)]*/ int getMaxRows(out int pRetVal);
  /*[id(0x60020008)]*/ int getMoreResults(out short pRetVal);
  /*[id(0x60020009)]*/ int getQueryTimeout(out int pRetVal);
  /*[id(0x6002000A)]*/ int getResultSet(out ResultSet pRetVal);
  /*[id(0x6002000B)]*/ int getUpdateCount(out int pRetVal);
  /*[id(0x6002000C)]*/ int getWarnings(out _SQLWarning pRetVal);
  /*[id(0x6002000D)]*/ int setCursorName(wchar* name);
  /*[id(0x6002000E)]*/ int setEscapeProcessing(short enable);
  /*[id(0x6002000F)]*/ int setMaxFieldSize(int maxFieldSize);
  /*[id(0x60020010)]*/ int setMaxRows(int maxRows);
  /*[id(0x60020011)]*/ int setQueryTimeout(int queryTimeout);
}

interface Certificate : IDispatch {
  mixin(uuid("b45ae0ea-0333-379d-8fc2-e6385a0ac7ac"));
  /*[id(0x60020000)]*/ int decode(_InputStream stream);
  /*[id(0x60020001)]*/ int encode(_OutputStream stream);
  /*[id(0x60020002)]*/ int getFormat(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int getGuarantor(out Principal pRetVal);
  /*[id(0x60020004)]*/ int getPrincipal(out Principal pRetVal);
  /*[id(0x60020005)]*/ int getPublicKey(out PublicKey pRetVal);
  /*[id(0x60020006)]*/ int get_toString(short detailed, out wchar* pRetVal);
}

interface Key : IDispatch {
  mixin(uuid("0680c2b9-64f6-354d-8634-309f858e53cf"));
  /*[id(0x60020000)]*/ int getAlgorithm(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int getEncoded(out  pRetVal);
  /*[id(0x60020002)]*/ int getFormat(out wchar* pRetVal);
}

interface Principal : IDispatch {
  mixin(uuid("86724f09-2538-34e3-b4d8-35341b1d5649"));
  /*[id(0x60020000)]*/ int Equals(VARIANT another, out short pRetVal);
  /*[id(0x60020001)]*/ int getName(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
}

interface PrivateKey : IDispatch {
  mixin(uuid("779e7c2d-7522-35d2-9719-9f8c989923fa"));
}

interface PublicKey : IDispatch {
  mixin(uuid("412747ec-d030-3bac-a965-cd40f1673e47"));
}

interface Acl : IDispatch {
  mixin(uuid("0ce9838e-96ea-374d-855f-b5f4de329e60"));
  /*[id(0x60020000)]*/ int addEntry(Principal caller, AclEntry Entry, out short pRetVal);
  /*[id(0x60020001)]*/ int checkPermission(Principal Principal, Permission Permission, out short pRetVal);
  /*[id(0x60020002)]*/ int entries(out Enumeration pRetVal);
  /*[id(0x60020003)]*/ int getName(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int getPermissions(Principal user, out Enumeration pRetVal);
  /*[id(0x60020005)]*/ int removeEntry(Principal caller, AclEntry Entry, out short pRetVal);
  /*[id(0x60020006)]*/ int setName(Principal caller, wchar* name);
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
}

interface AclEntry : IDispatch {
  mixin(uuid("47ee42a0-5a0b-34b3-b3db-5fc718066c96"));
  /*[id(0x60020000)]*/ int addPermission(Permission Permission, out short pRetVal);
  /*[id(0x60020001)]*/ int checkPermission(Permission Permission, out short pRetVal);
  /*[id(0x60020002)]*/ int MemberwiseClone(out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int getPrincipal(out Principal pRetVal);
  /*[id(0x60020004)]*/ int isNegative(out short pRetVal);
  /*[id(0x60020005)]*/ int permissions(out Enumeration pRetVal);
  /*[id(0x60020006)]*/ int removePermission(Permission Permission, out short pRetVal);
  /*[id(0x60020007)]*/ int setNegativePermissions();
  /*[id(0x60020008)]*/ int setPrincipal(Principal user, out short pRetVal);
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
}

interface Group : IDispatch {
  mixin(uuid("d4647f5c-42ac-3e4f-9048-dcf55c3df24c"));
  /*[id(0x60020000)]*/ int addMember(Principal user, out short pRetVal);
  /*[id(0x60020001)]*/ int isMember(Principal Member, out short pRetVal);
  /*[id(0x60020002)]*/ int members(out Enumeration pRetVal);
  /*[id(0x60020003)]*/ int removeMember(Principal user, out short pRetVal);
}

interface Owner : IDispatch {
  mixin(uuid("7f18dcbb-e74a-3c7d-8291-df05c64ca5bf"));
  /*[id(0x60020000)]*/ int addOwner(Principal caller, Principal Owner, out short pRetVal);
  /*[id(0x60020001)]*/ int deleteOwner(Principal caller, Principal Owner, out short pRetVal);
  /*[id(0x60020002)]*/ int isOwner(Principal Owner, out short pRetVal);
}

interface Permission : IDispatch {
  mixin(uuid("1c4b2e7a-3dfe-3699-bf07-237f8dcc3f92"));
  /*[id(0x60020000)]*/ int Equals(VARIANT another, out short pRetVal);
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
}

interface DSAKey : IDispatch {
  mixin(uuid("d19f4391-9fcf-30ed-b186-bfc7c1a17c76"));
  /*[id(0x60020000)]*/ int getParams(out DSAParams pRetVal);
}

interface DSAKeyPairGenerator : IDispatch {
  mixin(uuid("1a66a95a-60e7-3379-ac5c-152d703304d6"));
  /*[id(0x60020000)]*/ int initialize(DSAParams params, _SecureRandom Random);
  /*[id(0x60020001)]*/ int initialize_2(int modlen, short genParams, _SecureRandom Random);
}

interface DSAParams : IDispatch {
  mixin(uuid("028adfef-405f-3dca-9c5a-2ea91b7a6339"));
  /*[id(0x60020000)]*/ int getG(out _BigInteger pRetVal);
  /*[id(0x60020001)]*/ int getP(out _BigInteger pRetVal);
  /*[id(0x60020002)]*/ int getQ(out _BigInteger pRetVal);
}

interface DSAPrivateKey : IDispatch {
  mixin(uuid("fbff8246-5650-3584-b941-b48479b33901"));
  /*[id(0x60020000)]*/ int getX(out _BigInteger pRetVal);
}

interface DSAPublicKey : IDispatch {
  mixin(uuid("fbe26f87-57ff-36dd-8345-1b30c57d963e"));
  /*[id(0x60020000)]*/ int getY(out _BigInteger pRetVal);
}

interface _Root : IDispatch {
  mixin(uuid("e540853d-4a9b-3312-bd43-ac84a84d9755"));
}

interface _DllLib : IDispatch {
  mixin(uuid("73e47ecb-9a7e-340f-bcb4-5108017baa39"));
}

interface _Win32Exception : IDispatch {
  mixin(uuid("520938a1-7584-32b2-a872-fb66c8696a2f"));
}

interface _ArraySort : IDispatch {
  mixin(uuid("1ff2d0ee-57f7-3562-a8ee-53bbbf84d342"));
}

interface _MultiComparison : IDispatch {
  mixin(uuid("d6a4db63-66b5-37ac-bf19-17140e2e353a"));
}

interface _SetComparer : IDispatch {
  mixin(uuid("16633fd8-dd68-3ca6-9a9b-31a4aa6fe95e"));
}

interface _StringComparison : IDispatch {
  mixin(uuid("4df9d201-cd35-33ce-961e-373dab556094"));
}

interface _VectorSort : IDispatch {
  mixin(uuid("f2628bc4-bed1-35b2-929f-0bf6866de696"));
}

interface _IncludeExcludeIntRanges : IDispatch {
  mixin(uuid("8ee07a7b-aee7-30db-a6c3-bb878160e534"));
}

interface _UnsignedIntRanges : IDispatch {
  mixin(uuid("d003c5a2-2861-34f3-8d4f-fa005bfc7420"));
}

interface _IntRanges : IDispatch {
  mixin(uuid("b52dc188-26c8-3484-aaf0-dc22a7237ede"));
}

interface _IncludeExcludeWildcards : IDispatch {
  mixin(uuid("8c5616bc-0761-3387-808b-433e3698094b"));
}

interface _WildcardExpression : IDispatch {
  mixin(uuid("2088175c-cc37-3723-899c-49656fef996e"));
}

interface _Queue : IDispatch {
  mixin(uuid("78f8501a-44e1-35c7-96dd-78abcc507406"));
}

interface _Sort : IDispatch {
  mixin(uuid("b409ce5c-8cd5-39f4-be32-2c4352fa628c"));
}

interface _EventLog : IDispatch {
  mixin(uuid("fe08ea26-5ee1-34fa-813c-71c0f9f2aeea"));
}

interface _FileVersionInformation : IDispatch {
  mixin(uuid("39b00c01-fb17-38f3-878b-e752b9f2ec1a"));
}

interface _HTMLTokenizer : IDispatch {
  mixin(uuid("96d669c4-c040-3f77-a26a-5312cb9d39e4"));
}

interface _SystemVersionManager : IDispatch {
  mixin(uuid("72ef9a47-e6c3-30bd-8dd0-3b44f5edcecf"));
}

interface _Task : IDispatch {
  mixin(uuid("b2c794fc-3444-3290-8eb8-a17ab2bf9ecb"));
}

interface _TaskManager : IDispatch {
  mixin(uuid("e13fd07e-b569-3572-86d2-ea10311c8ed7"));
}

interface _ThreadLocalStorage : IDispatch {
  mixin(uuid("072a30cd-4063-3977-a6b6-80dd2912296f"));
}

interface _Timer : IDispatch {
  mixin(uuid("f3f2be0a-20d3-3fcd-8d37-f38ceca2a8e7"));
}

interface _TimerEvent : IDispatch {
  mixin(uuid("fe90f3d3-5a85-3144-a5b7-21317fd6ec48"));
}

interface _Delegate : IDispatch {
  mixin(uuid("7e1f71ad-9027-3836-bb9f-cf785ff3b095"));
}

interface _MulticastDelegate : IDispatch {
  mixin(uuid("070e06f6-e86e-3a61-bd34-c7ea4b7e7a5e"));
}

interface _MulticastNotSupportedException : IDispatch {
  mixin(uuid("b2b60991-019a-3afd-a0ee-f6cd64ffb025"));
}

interface _RegKey : IDispatch {
  mixin(uuid("5a66a8d5-ada6-3cfc-b5a0-3e7bb0c711ff"));
}

interface _RegKeyEnumValue : IDispatch {
  mixin(uuid("1b86c209-06fa-33c1-866f-e278bebf07c1"));
}

interface _RegKeyEnumValueByteArray : IDispatch {
  mixin(uuid("6c22fe02-fd33-3f7d-9ab8-81de7491ccca"));
}

interface _RegKeyEnumValueInt : IDispatch {
  mixin(uuid("10957f95-0b99-3e5c-b014-d4e19984cbb7"));
}

interface _RegKeyEnumValueString : IDispatch {
  mixin(uuid("b76e15ab-5825-388f-9974-b9ba937f86a3"));
}

interface _RegKeyException : IDispatch {
  mixin(uuid("bec10a3b-cd40-3b44-b9d2-43e4fac0f373"));
}

interface _RegKeyValueEnumerator : IDispatch {
  mixin(uuid("0f0667ea-959a-32e3-a05c-b29fb1527656"));
}

interface _RegQueryInfo : IDispatch {
  mixin(uuid("b9b4f59a-3be0-3562-9d13-33e3ab43ffee"));
}

interface _JavaStructMarshalHelper : IDispatch {
  mixin(uuid("4f42a312-5754-35eb-947d-d93be775b522"));
}

interface _SecurityExceptionEx : IDispatch {
  mixin(uuid("26f1a993-c60f-38ad-881a-e1d2b2f70998"));
}

interface _com_ms_vjsharp_win32_RECT : IDispatch {
  mixin(uuid("f5a229ed-b56a-399a-8c5f-a6c0d7117d5f"));
}

interface _Utilities : IDispatch {
  mixin(uuid("07a94bd4-8caf-3470-86aa-01b5a5a3ab36"));
}

interface _MethodNotSupportedException : IDispatch {
  mixin(uuid("e7a72186-3d55-343d-b1b3-81b017f5cd71"));
}

interface _BufferedInputStream : IDispatch {
  mixin(uuid("339c1579-28ad-37d9-a579-3485e32a57b1"));
}

interface _BufferedOutputStream : IDispatch {
  mixin(uuid("4652cad4-c2c1-30b1-9896-17f1a820482b"));
}

interface _BufferedReader : IDispatch {
  mixin(uuid("e54736aa-71bb-365c-8551-638383ebffaa"));
}

interface _BufferedWriter : IDispatch {
  mixin(uuid("e50ac48d-44ae-3b4a-a6b8-5d63a0996735"));
}

interface _ByteArrayInputStream : IDispatch {
  mixin(uuid("32c344a6-9401-3e38-89fe-1be45fe78cca"));
}

interface _ByteArrayOutputStream : IDispatch {
  mixin(uuid("65e96b6e-407a-37f5-bb14-e1f41482290a"));
}

interface _CharArrayReader : IDispatch {
  mixin(uuid("a19ad6a1-db49-3911-ba94-e058bb3bed00"));
}

interface _CharArrayWriter : IDispatch {
  mixin(uuid("56193eb9-6086-34af-bdb4-7faf079ce940"));
}

interface _CharConversionException : IDispatch {
  mixin(uuid("3bd80909-676d-3de1-8d39-c59973ac57f9"));
}

interface _DataInputStream : IDispatch {
  mixin(uuid("b27f3a3f-2b92-3856-bd74-cbb38bf25b01"));
}

interface _DataOutputStream : IDispatch {
  mixin(uuid("d47d80ac-d476-3c75-b2ff-26300e1b9c51"));
}

interface _EOFException : IDispatch {
  mixin(uuid("222a0a9c-814b-31f8-8c49-5f691dcabe72"));
}

interface _File : IDispatch {
  mixin(uuid("b2bffaba-af31-3c6c-8b6f-711a69ba7c83"));
}

interface _FileDescriptor : IDispatch {
  mixin(uuid("05a6ebbe-087b-3fc3-9453-54abd0d8c01e"));
}

interface _FileInputStream : IDispatch {
  mixin(uuid("5da5693e-3901-336c-a80a-287b6b1bb6ee"));
}

interface _FileNotFoundException : IDispatch {
  mixin(uuid("2763e620-75fd-3986-9206-1a38d8cac20c"));
}

interface _FileOutputStream : IDispatch {
  mixin(uuid("324d6634-8b90-3b5a-b9d4-2fc106653415"));
}

interface _FileReader : IDispatch {
  mixin(uuid("ffbeee4c-d072-322b-a834-1bb788633700"));
}

interface _FileWriter : IDispatch {
  mixin(uuid("72eacaa4-2d43-3bbd-96c1-682f09718bf9"));
}

interface _FilterInputStream : IDispatch {
  mixin(uuid("e96d762e-b9b6-3600-8593-580bc59af5d5"));
}

interface _FilterOutputStream : IDispatch {
  mixin(uuid("e59cda65-59a5-3214-9a66-7a794f4d5db4"));
}

interface _FilterReader : IDispatch {
  mixin(uuid("b979a4ce-554d-3306-8d41-e1d5a6f6cc9f"));
}

interface _FilterWriter : IDispatch {
  mixin(uuid("2654e6d3-4312-343d-b9c4-976d02740e74"));
}

interface _InputStream : IDispatch {
  mixin(uuid("83c95a9a-a3a3-325c-ab93-7a9984f49658"));
}

interface _InputStreamReader : IDispatch {
  mixin(uuid("6e5b37f6-e58c-3cc8-b291-159a95da9606"));
}

interface _InterruptedIOException : IDispatch {
  mixin(uuid("b7e70b08-4bcf-3ada-98e8-907670e03cf0"));
}

interface _InvalidClassException : IDispatch {
  mixin(uuid("eaf519a4-a5f7-3ef6-a225-9f5d964abe46"));
}

interface _InvalidObjectException : IDispatch {
  mixin(uuid("d654b97e-9c36-3750-b973-09fbdaf45692"));
}

interface _IOException : IDispatch {
  mixin(uuid("71295627-2a1d-38bf-8e90-ab7c25e7b9d7"));
}

interface _LineNumberInputStream : IDispatch {
  mixin(uuid("7b8b55e1-8c2a-36a3-9654-e66ad17c233b"));
}

interface _LineNumberReader : IDispatch {
  mixin(uuid("a5bc268d-02f0-3d46-beaf-2fe1e3832104"));
}

interface _NotActiveException : IDispatch {
  mixin(uuid("47947c71-25fc-34d1-a92b-fe77baa177a8"));
}

interface _NotSerializableException : IDispatch {
  mixin(uuid("8858ffc3-3ac7-3dda-aec5-e43b3e425a4c"));
}

interface _ObjectInputStream : IDispatch {
  mixin(uuid("7fd42a75-0fa2-325b-8a69-aee53f5fb3df"));
}

interface _ObjectOutputStream : IDispatch {
  mixin(uuid("f35f4e6b-c49b-3856-b1aa-41a9b4bba3e3"));
}

interface _ObjectStreamClass : IDispatch {
  mixin(uuid("59fdcdd7-267f-35ee-a487-ffdd20b0cf9f"));
}

interface _ObjectStreamException : IDispatch {
  mixin(uuid("aff9c3fc-a795-363a-8547-9bb0f8ffc96f"));
}

interface _OptionalDataException : IDispatch {
  mixin(uuid("8b72767d-9779-3a20-80ea-99fc9b4744a7"));
}

interface _OutputStream : IDispatch {
  mixin(uuid("cd3306b5-4255-398a-986a-5d610d8c9b93"));
}

interface _OutputStreamWriter : IDispatch {
  mixin(uuid("1e2644a4-c600-369f-928a-1ceddd49d615"));
}

interface _PipedInputStream : IDispatch {
  mixin(uuid("f9d21910-9098-39ac-870a-05f14c5d41ea"));
}

interface _PipedOutputStream : IDispatch {
  mixin(uuid("ee914d61-2ec8-3e62-9911-7bec74787754"));
}

interface _PipedReader : IDispatch {
  mixin(uuid("f9e5af2f-b63f-3f55-8514-217f68667efc"));
}

interface _PipedWriter : IDispatch {
  mixin(uuid("eaca77ca-5edb-3d51-ad68-328b7f755172"));
}

interface _PrintStream : IDispatch {
  mixin(uuid("dbaf4f1d-c6bb-3bfc-98f3-e5b5dd596c44"));
}

interface _PrintWriter : IDispatch {
  mixin(uuid("a9da708c-281d-378f-887e-89e325c226cb"));
}

interface _PushbackInputStream : IDispatch {
  mixin(uuid("2eab024c-6b27-3932-8837-cadb62a1d7da"));
}

interface _PushbackReader : IDispatch {
  mixin(uuid("b75cf421-01f2-3964-a03c-ae7bccf0b453"));
}

interface _RandomAccessFile : IDispatch {
  mixin(uuid("19aeb19c-525c-3e8b-94fd-1b768c5d9346"));
}

interface _Reader : IDispatch {
  mixin(uuid("2570de83-4d27-3988-befa-1e278abfe24b"));
}

interface _SequenceInputStream : IDispatch {
  mixin(uuid("9d7199bf-192b-3a92-9e36-9cffec7370c6"));
}

interface _StreamCorruptedException : IDispatch {
  mixin(uuid("48ae37be-ce19-3efb-9adc-a68f2a967d1c"));
}

interface _StreamTokenizer : IDispatch {
  mixin(uuid("d8f37774-c3a3-3ddf-8ebf-293c6e2c4cb4"));
}

interface _StringBufferInputStream : IDispatch {
  mixin(uuid("c2199534-75a0-322a-8b0a-4e91b3c3e46c"));
}

interface _StringReader : IDispatch {
  mixin(uuid("89ac211c-6164-3231-b50d-c48494051fbd"));
}

interface _StringWriter : IDispatch {
  mixin(uuid("c2fd7455-1104-3f93-9d94-42b2d3a2343a"));
}

interface _SyncFailedException : IDispatch {
  mixin(uuid("2ff5a30e-0d3f-3513-9918-0f5bcca2755b"));
}

interface _UnsupportedEncodingException : IDispatch {
  mixin(uuid("40972961-1e37-3d15-8037-e45173bcd728"));
}

interface _UTFDataFormatException : IDispatch {
  mixin(uuid("cf0668ec-e623-397d-924c-a204328fde50"));
}

interface _WriteAbortedException : IDispatch {
  mixin(uuid("b37206cf-32bb-3226-859b-80679cffbe87"));
}

interface _Writer : IDispatch {
  mixin(uuid("c539b1da-c191-32e1-8e8f-726f041b4c5f"));
}

interface _Array : IDispatch {
  mixin(uuid("cd7e28f9-a8db-369d-b6e5-9758a7dbe68c"));
}

interface _Constructor : IDispatch {
  mixin(uuid("c447ae6a-df2d-32bf-9384-077a725d68c2"));
}

interface _Field : IDispatch {
  mixin(uuid("711ce393-82c9-3739-9e70-c30c5a107587"));
}

interface _InvocationTargetException : IDispatch {
  mixin(uuid("e51e4f11-f41d-3907-a706-f2a5b6591c8e"));
}

interface _Method : IDispatch {
  mixin(uuid("92eaea9e-abe2-3d31-8fc2-018a879b03f1"));
}

interface _Modifier : IDispatch {
  mixin(uuid("fdc047b3-6878-3ff3-9236-f072b48ea3cc"));
}

interface _<CorArrayWrapper> : IDispatch {
  mixin(uuid("3885e7cc-a404-3ec4-a94e-57d9c4a9a45c"));
}

interface _BindException : IDispatch {
  mixin(uuid("93c40379-0a9d-3236-89d7-0c696a8f86a8"));
}

interface _ConnectException : IDispatch {
  mixin(uuid("31396158-3f36-3c91-9400-918d6426fff2"));
}

interface _ContentHandler : IDispatch {
  mixin(uuid("049b89d1-16f9-3c4a-947c-4e44361038b5"));
}

interface _DatagramPacket : IDispatch {
  mixin(uuid("9672e577-555a-3d09-b6bd-440c893adb06"));
}

interface _DatagramSocket : IDispatch {
  mixin(uuid("16cb2fd1-f3ce-3d10-9b53-6227b8c5e4c7"));
}

interface _DatagramSocketImpl : IDispatch {
  mixin(uuid("d35f280a-2bad-3669-8875-6c4711b708af"));
}

interface _HttpURLConnection : IDispatch {
  mixin(uuid("5df5a0f0-9368-3394-8778-e972e2273da1"));
}

interface _InetAddress : IDispatch {
  mixin(uuid("06e5ae20-4b4f-35eb-a320-1b0206a88957"));
}

interface _MalformedURLException : IDispatch {
  mixin(uuid("598dc749-4656-34e7-85f4-b41d2c12507f"));
}

interface _MulticastSocket : IDispatch {
  mixin(uuid("34b60239-9228-3ffb-b04e-1d9f74037852"));
}

interface _NoRouteToHostException : IDispatch {
  mixin(uuid("a020ada6-2b62-349b-8b76-52e191f5479d"));
}

interface _ProtocolException : IDispatch {
  mixin(uuid("d74cbd83-0a9e-3e6b-b6a1-0ef789cc601a"));
}

interface _ServerSocket : IDispatch {
  mixin(uuid("7c2fd33b-1788-3e6f-9ce7-69e5af55daaf"));
}

interface _Socket : IDispatch {
  mixin(uuid("d0327442-17b0-3110-b1f2-0cb009c99594"));
}

interface _SocketException : IDispatch {
  mixin(uuid("8f734ca1-957e-3d7d-b4ab-10283b96fe79"));
}

interface _SocketImpl : IDispatch {
  mixin(uuid("171d2ebf-1d22-33ca-af85-470f5682eca6"));
}

interface _SocketPermission : IDispatch {
  mixin(uuid("f028e8b5-dd31-37d5-804a-01b806b2e61d"));
}

interface _UnknownHostException : IDispatch {
  mixin(uuid("129925dc-70b9-39ed-98c5-7621d2d69d25"));
}

interface _UnknownServiceException : IDispatch {
  mixin(uuid("38d3e6e5-383b-35a7-9ddd-c467ea87e2fe"));
}

interface _URL : IDispatch {
  mixin(uuid("55d6e4da-bb50-3d1a-9c88-8ddd42bed23f"));
}

interface _URLConnection : IDispatch {
  mixin(uuid("0e288d41-f9e8-3909-8408-f7a294b4533e"));
}

interface _URLEncoder : IDispatch {
  mixin(uuid("edb7102d-c134-33ae-9963-5b4a2214fe76"));
}

interface _URLStreamHandler : IDispatch {
  mixin(uuid("18868f03-7232-31f5-83dd-ec7d240c7931"));
}

interface _URLStreamHandlerFactoryImpl : IDispatch {
  mixin(uuid("c2c9dc5b-f221-31bf-a85c-efd434337b0e"));
}

interface _BreakIterator : IDispatch {
  mixin(uuid("0ee3d37a-32f2-314b-846a-9aeaafabb887"));
}

interface _ChoiceFormat : IDispatch {
  mixin(uuid("3f8dc5c2-d26d-3881-a69b-ea39ae85cc33"));
}

interface _CollationElementIterator : IDispatch {
  mixin(uuid("bec866f4-8973-3360-bada-a40ea60cb282"));
}

interface _CollationKey : IDispatch {
  mixin(uuid("4ad3cfb7-abf9-3042-9de0-ac6d57da018d"));
}

interface _Collator : IDispatch {
  mixin(uuid("bc14b56e-824c-38d9-a750-8ea3990f3fa5"));
}

interface _DateFormat : IDispatch {
  mixin(uuid("0084f07f-5198-3efa-a331-9880caff91b4"));
}

interface _DateFormatSymbols : IDispatch {
  mixin(uuid("6758a6ca-a8d7-3121-8585-b9ef22aca159"));
}

interface _DecimalFormat : IDispatch {
  mixin(uuid("5a126a9d-7b40-38e3-990d-2fcebf1ac18b"));
}

interface _DecimalFormatSymbols : IDispatch {
  mixin(uuid("f0669fd2-0d6c-3623-a1f6-a6f55c02a922"));
}

interface _FieldPosition : IDispatch {
  mixin(uuid("32c6f80b-5c3d-3427-b9ac-db505d5a6200"));
}

interface _Format : IDispatch {
  mixin(uuid("6b38ab96-e571-3784-afc0-4d2b3da7217c"));
}

interface _FormatDefaults : IDispatch {
  mixin(uuid("24bd7b9f-a023-30cb-9400-af52ead65e3d"));
}

interface _MessageFormat : IDispatch {
  mixin(uuid("24f82d99-2d40-34c8-bf5f-ec3f59cfdc70"));
}

interface _NumberFormat : IDispatch {
  mixin(uuid("0d32d49f-16d1-3b55-b382-24dd0a6c4e2d"));
}

interface _ParseException : IDispatch {
  mixin(uuid("81d771b4-e181-33b3-9a75-7c089f8b7030"));
}

interface _ParsePosition : IDispatch {
  mixin(uuid("9132f4ea-1634-38c6-a67f-2cf5fbf71862"));
}

interface _RuleBasedCollator : IDispatch {
  mixin(uuid("28a3a79a-c277-3d4c-a742-b6457b9bf574"));
}

interface _SimpleDateFormat : IDispatch {
  mixin(uuid("27b86949-bf6e-3d49-8d66-c2aaa5028423"));
}

interface _StringCharacterIterator : IDispatch {
  mixin(uuid("a4b04498-c9d6-3926-8d7b-f0062b96a390"));
}

interface _Adler32 : IDispatch {
  mixin(uuid("4d1950f6-5e68-3b6c-8299-865f42771f50"));
}

interface _CheckedInputStream : IDispatch {
  mixin(uuid("f4557472-2326-3115-94f9-7601c67995e2"));
}

interface _CheckedOutputStream : IDispatch {
  mixin(uuid("84c7e158-43ee-39f5-8053-35ec07168567"));
}

interface _CRC32 : IDispatch {
  mixin(uuid("e44ce238-5269-3613-87a4-77ffd16d1850"));
}

interface _DataFormatException : IDispatch {
  mixin(uuid("a42bfb12-9034-3e8b-aeaa-be9d2d9aaed8"));
}

interface _Deflater : IDispatch {
  mixin(uuid("33e55da6-ed94-317c-ae6b-d8c5e25a2351"));
}

interface _DeflaterOutputStream : IDispatch {
  mixin(uuid("ee7db4fa-9f35-30e9-85d2-03b2bb586b5e"));
}

interface _GZIPInputStream : IDispatch {
  mixin(uuid("0649aaf6-24d4-3137-94fd-57076c6a1e72"));
}

interface _GZIPOutputStream : IDispatch {
  mixin(uuid("ae4fa1c0-7985-341f-8947-e8384e1cc8eb"));
}

interface _Inflater : IDispatch {
  mixin(uuid("c593075a-8673-3d4e-8243-8d082e69cd63"));
}

interface _InflaterInputStream : IDispatch {
  mixin(uuid("0f173e46-e0bf-3655-92c7-3206c1bda594"));
}

interface _ZipEntry : IDispatch {
  mixin(uuid("8ae6260a-b177-36bb-8cb3-c7e237a11f74"));
}

interface _ZipException : IDispatch {
  mixin(uuid("21e46610-9321-3da9-9d36-34bddd698bfa"));
}

interface _ZipFile : IDispatch {
  mixin(uuid("75bcb850-b483-395c-9038-52d6f6187354"));
}

interface _ZipEntryEnum : IDispatch {
  mixin(uuid("a4fd7600-a454-30b1-9d93-553054be23ca"));
}

interface _ZipInputStream : IDispatch {
  mixin(uuid("69b934f3-4cab-3c83-90db-d9e966ead2a3"));
}

interface _ZipOutputStream : IDispatch {
  mixin(uuid("cd7ba130-c789-370f-8cdb-b3d02c2dec74"));
}

interface _Wrapper : IDispatch {
  mixin(uuid("2f7b4c2d-e9c8-3ee2-838b-eabea515e4d6"));
}

interface _<VerifierFix> : IDispatch {
  mixin(uuid("afb349ab-c69a-3720-aaad-e4758982dd63"));
}

interface _AbstractMethodError : IDispatch {
  mixin(uuid("08a7bba9-2d8a-38c2-bb9b-5a087d0d02ba"));
}

interface _ArithmeticException : IDispatch {
  mixin(uuid("8631ef2f-bd7a-32af-9ef2-25a24faef357"));
}

interface _ArrayIndexOutOfBoundsException : IDispatch {
  mixin(uuid("405e3a92-62a2-33e8-a288-8bb104dc9e7e"));
}

interface _ArrayStoreException : IDispatch {
  mixin(uuid("7e20dcea-3537-3967-90ba-6fd468dde2b4"));
}

interface _BigDecimal : IDispatch {
  mixin(uuid("49b76d82-8e2c-3d23-9a9d-2ae1771851cf"));
}

interface _BigInteger : IDispatch {
  mixin(uuid("dfbe7e20-5926-3119-8f97-6465f8279ef1"));
}

interface _Boolean : IDispatch {
  mixin(uuid("5e9a1f24-3c0b-3578-964e-c2c86aa06ee0"));
}

interface _Byte : IDispatch {
  mixin(uuid("ff91f7f0-ab44-3c18-b645-83fdb8c90d53"));
}

interface _Character : IDispatch {
  mixin(uuid("f65115b9-a949-3776-af6c-61148b86d78c"));
}

interface _Subset : IDispatch {
  mixin(uuid("04fff1a9-5e27-387b-8174-8636fe5ce13f"));
}

interface _UnicodeBlock : IDispatch {
  mixin(uuid("ed699ac9-e037-316b-90f9-d159ec782415"));
}

interface _Class : IDispatch {
  mixin(uuid("17daf0c4-857b-3309-b347-6669cf31db01"));
}

interface _ClassCastException : IDispatch {
  mixin(uuid("b0ac8230-0125-30f8-b35c-adfd509c2450"));
}

interface _ClassCircularityError : IDispatch {
  mixin(uuid("348aff13-f3e3-31e1-b1f7-f99c86e0b641"));
}

interface _ClassFormatError : IDispatch {
  mixin(uuid("eb5491ef-5a83-3030-9c90-2c89e60cb5ed"));
}

interface _ClassLoader : IDispatch {
  mixin(uuid("35e8b6b4-60d9-3cc8-aa58-47841060da2f"));
}

interface _ClassNotFoundException : IDispatch {
  mixin(uuid("f301fd19-10a0-3ea5-a6cf-31e8ddc15eea"));
}

interface _CloneNotSupportedException : IDispatch {
  mixin(uuid("911ca763-d58d-3e30-8a7f-12e22261ebad"));
}

interface _Compiler : IDispatch {
  mixin(uuid("8ae35fd3-501b-389f-8925-e995c0cc25f9"));
}

interface _Double : IDispatch {
  mixin(uuid("6a5d3fe8-0aab-3de3-86e6-418ea8771813"));
}

interface _Error : IDispatch {
  mixin(uuid("c229dce5-9c19-38b3-923d-368366181739"));
}

interface _Exception : IDispatch {
  mixin(uuid("ff065d0a-8c7a-3711-a479-cf9b37e11564"));
}

interface _ExceptionInInitializerError : IDispatch {
  mixin(uuid("327c37b3-9f49-3df0-b65b-0141ec6a7f3b"));
}

interface _Float : IDispatch {
  mixin(uuid("159a647b-a6f5-3b48-9359-17b4d31ea97d"));
}

interface _IllegalAccessError : IDispatch {
  mixin(uuid("ad9793a9-f48d-35da-989b-0d74b6470689"));
}

interface _IllegalAccessException : IDispatch {
  mixin(uuid("8186f74c-a6b7-3693-8aa7-d6f5f37b4df4"));
}

interface _IllegalArgumentException : IDispatch {
  mixin(uuid("0cc2b36b-f909-3b2a-8468-757f722e2c34"));
}

interface _IllegalMonitorStateException : IDispatch {
  mixin(uuid("5b6a14f4-888a-314b-9059-72287d1b22f0"));
}

interface _IllegalStateException : IDispatch {
  mixin(uuid("224a066c-812a-3e88-8796-18673dfc2b77"));
}

interface _IllegalThreadStateException : IDispatch {
  mixin(uuid("c7e193a3-c5c4-3787-bb6a-358745fbf4b8"));
}

interface _IncompatibleClassChangeError : IDispatch {
  mixin(uuid("a0247dd9-fcf0-30ac-9851-7fdaa183e4aa"));
}

interface _IndexOutOfBoundsException : IDispatch {
  mixin(uuid("3210eda0-7cfe-377f-bafe-e3a83b0d1185"));
}

interface _InstantiationError : IDispatch {
  mixin(uuid("89f870db-94a1-3dd8-8d80-832e80fa7b9b"));
}

interface _InstantiationException : IDispatch {
  mixin(uuid("c15a8d1a-c1cc-3b57-aff6-e4671b2d8d4f"));
}

interface _Integer : IDispatch {
  mixin(uuid("4885d0e0-cb60-3df1-9678-d72ff9012ac2"));
}

interface _InternalError : IDispatch {
  mixin(uuid("49c7c850-1e22-37a3-92c5-dc6988ae5787"));
}

interface _InterruptedException : IDispatch {
  mixin(uuid("fed9a065-307f-3006-b0d2-4b943086327d"));
}

interface _LinkageError : IDispatch {
  mixin(uuid("cc92e202-dd55-38aa-a68a-d0d527a4a7bb"));
}

interface _Long : IDispatch {
  mixin(uuid("330af3a2-35f4-3f25-8cf1-1272c204881e"));
}

interface _Math : IDispatch {
  mixin(uuid("80bd5f13-0003-3c69-a74b-e088d4a14a8b"));
}

interface _NegativeArraySizeException : IDispatch {
  mixin(uuid("29bde39a-d12d-3ca0-bdf2-1e9b47ac0101"));
}

interface _NoClassDefFoundError : IDispatch {
  mixin(uuid("b417b175-3864-30b3-a112-6615b75cdb26"));
}

interface _NoSuchFieldError : IDispatch {
  mixin(uuid("2767f831-f40e-3327-b7b4-018e917f0059"));
}

interface _NoSuchFieldException : IDispatch {
  mixin(uuid("b55323b7-a70c-334f-bb9e-0e2e49c85b7e"));
}

interface _NoSuchMethodError : IDispatch {
  mixin(uuid("bf2dfc7e-fa24-39ec-a999-54a9b78cb28a"));
}

interface _NoSuchMethodException : IDispatch {
  mixin(uuid("699bdf06-d4d4-3e40-bd72-9d35ae0bf892"));
}

interface _NullPointerException : IDispatch {
  mixin(uuid("e6c08d51-d51e-3627-b6ac-a392ef94fa41"));
}

interface _Number : IDispatch {
  mixin(uuid("0528988e-c509-39d2-9db9-637d13ca07a1"));
}

interface _NumberFormatException : IDispatch {
  mixin(uuid("8d614e18-3bbf-3f7c-a95b-28beae0b0ca9"));
}

interface _ObjectImpl : IDispatch {
  mixin(uuid("e37d1d6a-6d88-31ad-ad91-db0c49c1206a"));
}

interface _StringImpl : IDispatch {
  mixin(uuid("8d5de528-9a21-3f1d-9d4c-add572813bc8"));
}

interface _OutOfMemoryError : IDispatch {
  mixin(uuid("d2d1ff2c-fe45-3b43-b278-e8789d1b96a4"));
}

interface _Process : IDispatch {
  mixin(uuid("fdf7dcef-9cfc-3293-8694-be6e430a9e2f"));
}

interface _Runtime : IDispatch {
  mixin(uuid("5b49cbbf-6541-3364-a856-ae2beed86840"));
}

interface _RuntimeException : IDispatch {
  mixin(uuid("0388f6f7-0fac-369c-95e8-9f8bf56d4e7a"));
}

interface _SecurityException : IDispatch {
  mixin(uuid("0d972cc0-f953-3864-bb74-87c3292eb37b"));
}

interface _SecurityManager : IDispatch {
  mixin(uuid("9dcd59ec-23f3-3f18-b514-32d597cc2db6"));
}

interface _Short : IDispatch {
  mixin(uuid("14e40deb-c2ca-35ab-b019-6ce43371466e"));
}

interface _StackOverflowError : IDispatch {
  mixin(uuid("ab331907-b2ad-3066-985b-a81ee81aeb5b"));
}

interface _StringBuffer : IDispatch {
  mixin(uuid("7174ffd4-c959-3d1f-8903-f06165ab5ca7"));
}

interface _StringIndexOutOfBoundsException : IDispatch {
  mixin(uuid("096504c2-75bb-3b1c-b3d8-4cc462d1ecc7"));
}

interface _System : IDispatch {
  mixin(uuid("c43e491f-6b6b-3ccb-b1df-be53b304b624"));
}

interface _Thread : IDispatch {
  mixin(uuid("f1de42bb-af17-35d9-842a-7b4710851c40"));
}

interface _ThreadDeath : IDispatch {
  mixin(uuid("9b0b733b-da0f-326b-8062-3808e2510bce"));
}

interface _ThreadGroup : IDispatch {
  mixin(uuid("1fc6a277-3258-3636-a4ba-3bd486cba156"));
}

interface _Throwable : IDispatch {
  mixin(uuid("4e9d33e2-b3a1-3f6e-877b-2fc47318afef"));
}

interface _UnknownError : IDispatch {
  mixin(uuid("771ef18c-8fa1-3c07-b315-882c06b8574b"));
}

interface _UnsatisfiedLinkError : IDispatch {
  mixin(uuid("958c562f-186a-3c17-b5c7-49ef019140cf"));
}

interface _VerifyError : IDispatch {
  mixin(uuid("7ffb5b88-dba0-3969-bd75-dd6f803c8479"));
}

interface _VirtualMachineError : IDispatch {
  mixin(uuid("a1fc070a-c4e8-30e3-8626-7a55905cf260"));
}

interface _Void : IDispatch {
  mixin(uuid("1c65e967-e940-304e-8e32-138a5260fe4c"));
}

interface _BitSet : IDispatch {
  mixin(uuid("f0ca16c1-0080-386e-b2be-9826e3a74739"));
}

interface _Calendar : IDispatch {
  mixin(uuid("8fc158a7-acfe-33e6-bfb0-7e3404226759"));
}

interface _java_util_Date : IDispatch {
  mixin(uuid("acffb4c0-6086-3b6c-81d1-15fde71628d1"));
}

interface _Dictionary : IDispatch {
  mixin(uuid("5879fff5-688a-3ac9-abf0-90ed5d168776"));
}

interface _EmptyStackException : IDispatch {
  mixin(uuid("08808b2a-bd12-378c-a825-7571c340452b"));
}

interface _EventObject : IDispatch {
  mixin(uuid("e98abe00-3928-3c9f-89a7-a88499cdea64"));
}

interface _GregorianCalendar : IDispatch {
  mixin(uuid("49459ac0-9820-352e-9e7c-1d013473763b"));
}

interface _Hashtable : IDispatch {
  mixin(uuid("fed3c483-3851-3398-993d-4ba06e18ad65"));
}

interface _HashtableEnumerator : IDispatch {
  mixin(uuid("923b4e02-8e4d-31a0-8f2a-8c7c102dec49"));
}

interface _ListResourceBundle : IDispatch {
  mixin(uuid("725a4d99-1d7e-3a51-88bc-61cb191805c0"));
}

interface _Locale : IDispatch {
  mixin(uuid("8f358d8c-e10f-356d-9498-f08695c1fafc"));
}

interface _MissingResourceException : IDispatch {
  mixin(uuid("5ba75eb0-1a47-3ac2-8247-565167f9966e"));
}

interface _NoSuchElementException : IDispatch {
  mixin(uuid("b8959b04-9dfa-3f0b-a484-8dc3f9d58aab"));
}

interface _Observable : IDispatch {
  mixin(uuid("263475b5-99ab-354d-bd39-8634a0cb1897"));
}

interface _Properties : IDispatch {
  mixin(uuid("ca9eed44-a278-380a-96ca-0a39a1805e3a"));
}

interface _PropertyResourceBundle : IDispatch {
  mixin(uuid("c6c77203-c87f-3a28-8876-52cfbfb77fc9"));
}

interface _Random : IDispatch {
  mixin(uuid("2f8fcbe0-9eab-3c52-927f-351d22605a84"));
}

interface _ResourceBundle : IDispatch {
  mixin(uuid("2f860701-7a1c-3a94-80fc-c8cff9ca1fb1"));
}

interface _SimpleTimeZone : IDispatch {
  mixin(uuid("a5b8b9f9-1510-3005-ab97-39a76efca39c"));
}

interface _Stack : IDispatch {
  mixin(uuid("19067046-a9a6-37f0-ab56-64aa7b72f13e"));
}

interface _StringTokenizer : IDispatch {
  mixin(uuid("03547b1d-6f6f-3cf6-b2a8-30e706445dc2"));
}

interface _TimeZone : IDispatch {
  mixin(uuid("b6de2ba3-11eb-347a-9a49-af00c1d75c78"));
}

interface _TooManyListenersException : IDispatch {
  mixin(uuid("97e8c948-34e3-373b-ad60-d8135554d6a8"));
}

interface _Vector : IDispatch {
  mixin(uuid("acf2a6d4-ee57-364d-b623-e33a4c899f0a"));
}

interface _VectorEnumerator : IDispatch {
  mixin(uuid("5d4f49ae-7802-39f9-ad6c-703456835cb5"));
}

interface _AbstractCollection : IDispatch {
  mixin(uuid("240164cc-7871-35be-9082-6ff2e1184f59"));
}

interface _AbstractList : IDispatch {
  mixin(uuid("00075500-0dfb-3c4a-9fba-7ace6adae459"));
}

interface _AbstractSequentialList : IDispatch {
  mixin(uuid("50529e74-7191-3547-af54-16b4e72bf1e1"));
}

interface _LinkedList : IDispatch {
  mixin(uuid("9dfe38f8-a0d1-39c7-a4f1-e493a5df5f4c"));
}

interface _ArrayList : IDispatch {
  mixin(uuid("1b225fc2-cc59-3ef6-b81a-f43dffac49c3"));
}

interface _AbstractSet : IDispatch {
  mixin(uuid("b2df8c24-19f1-3556-9168-f8dd675ce7ea"));
}

interface _HashSet : IDispatch {
  mixin(uuid("674c4040-1403-3eaf-9c49-5b81152bf726"));
}

interface _TreeSet : IDispatch {
  mixin(uuid("ce2add5c-fd4d-31ba-b1b4-d7cc74a75519"));
}

interface _AbstractMap : IDispatch {
  mixin(uuid("7059096b-1df1-3f15-8d43-38934f19cedf"));
}

interface _HashMap : IDispatch {
  mixin(uuid("93815ec0-1d1d-3ec3-9f1c-1aee378d47e8"));
}

interface _WeakHashMap : IDispatch {
  mixin(uuid("cda89275-6890-3268-9390-608d36fc74e0"));
}

interface _TreeMap : IDispatch {
  mixin(uuid("cdc4cf43-f610-3851-83f1-b7b2d14e3baf"));
}

interface _ConcurrentModificationException : IDispatch {
  mixin(uuid("b190c718-a5d4-3f1d-99d2-079ce2c69f31"));
}

interface _UnsupportedOperationException : IDispatch {
  mixin(uuid("3c32357e-a6dc-3199-8d6e-b4676360c225"));
}

interface _Collections : IDispatch {
  mixin(uuid("d98195e8-3f88-342a-8144-64271a77ebd4"));
}

interface _CollectionEnumeration : IDispatch {
  mixin(uuid("51beafb9-2651-30ce-8b03-3a4efbbfb7d4"));
}

interface _Arrays : IDispatch {
  mixin(uuid("dbc0fc94-5111-3cf2-950b-be21ff8a51cc"));
}

interface _ActionEvent : IDispatch {
  mixin(uuid("58d79ce0-18a8-3377-a131-1390b56e39b6"));
}

interface _AdjustmentEvent : IDispatch {
  mixin(uuid("821966ac-f55a-3d1c-a97a-3e5f9bbc78f9"));
}

interface _Applet : IDispatch {
  mixin(uuid("6968d2fa-7bb3-3fde-8f96-6dff898cdf55"));
}

interface _AreaAveragingScaleFilter : IDispatch {
  mixin(uuid("ea7fe70c-b235-3c52-8ef6-d4c4e11f7f5a"));
}

interface _AWTError : IDispatch {
  mixin(uuid("dddd48ba-5d06-3de2-b5ec-d0a10316abcf"));
}

interface _AWTEvent : IDispatch {
  mixin(uuid("80efb131-fc06-3942-9938-cf77e1a4690e"));
}

interface _AWTEventMulticaster : IDispatch {
  mixin(uuid("c4576ec9-5247-3e97-ae91-81aaa7831b95"));
}

interface _AWTException : IDispatch {
  mixin(uuid("ed2eb3cc-2dab-3fef-97d0-316117318f12"));
}

interface _BorderLayout : IDispatch {
  mixin(uuid("ffabc9a3-8c70-3384-aa94-2a7abe673046"));
}

interface _Button : IDispatch {
  mixin(uuid("142d8729-fac0-33e6-97f7-8b184440fc8b"));
}

interface _Canvas : IDispatch {
  mixin(uuid("01560092-b7f5-37fb-bd3f-5e5c564359db"));
}

interface _CardLayout : IDispatch {
  mixin(uuid("5c1c4291-d532-3040-90e3-a08d46856e0b"));
}

interface _Checkbox : IDispatch {
  mixin(uuid("dd760802-395b-3ca0-8efe-f9fc0ea56f65"));
}

interface _CheckboxGroup : IDispatch {
  mixin(uuid("62ca4d93-726a-383b-a7c2-9dc862b06616"));
}

interface _CheckboxMenuItem : IDispatch {
  mixin(uuid("c109653d-8cdf-36fe-8886-0b5761f143c6"));
}

interface _Choice : IDispatch {
  mixin(uuid("6b208e1c-3e95-3468-bcba-cd420b50a401"));
}

interface _Clipboard : IDispatch {
  mixin(uuid("169b4ec8-2e14-3bce-b83d-56ead24dba8a"));
}

interface _Color : IDispatch {
  mixin(uuid("394be36f-ef7a-3faa-bde6-d714ad5a184f"));
}

interface _ColorModel : IDispatch {
  mixin(uuid("5fcae248-4f05-38f3-8110-523d77a6fbbf"));
}

interface _Component : IDispatch {
  mixin(uuid("3bf400b5-6594-33a8-af4c-a8bcd100b329"));
}

interface _ComponentAdapter : IDispatch {
  mixin(uuid("669871e0-ab35-30df-89ad-f27d8cb0c308"));
}

interface _ComponentEvent : IDispatch {
  mixin(uuid("879954aa-58c2-30ef-a9f2-7a4a3f47512c"));
}

interface _Container : IDispatch {
  mixin(uuid("13c17d82-0030-3d46-ac7a-5910ec2069e4"));
}

interface _ContainerAdapter : IDispatch {
  mixin(uuid("96827786-ff9f-399b-919d-88280c8b923b"));
}

interface _ContainerEvent : IDispatch {
  mixin(uuid("4e2257f2-7d71-3a57-8de0-6ffe53587689"));
}

interface _CropImageFilter : IDispatch {
  mixin(uuid("bbbe98c8-c581-3302-ab19-0bd685703d3e"));
}

interface _Cursor : IDispatch {
  mixin(uuid("1d71b2d7-188c-3933-a346-534c43a10c5e"));
}

interface _DataFlavor : IDispatch {
  mixin(uuid("f634c356-32d2-37ca-b69a-6fe1b5c7ac1b"));
}

interface _Dialog : IDispatch {
  mixin(uuid("e216c8a9-0f4f-373e-a118-71d65b78af38"));
}

interface _Dimension : IDispatch {
  mixin(uuid("07b4d69c-015f-3bb2-a614-164eff128277"));
}

interface _DirectColorModel : IDispatch {
  mixin(uuid("68127dde-5ee2-38d8-957f-85c02946d93e"));
}

interface _Event : IDispatch {
  mixin(uuid("5e2f7816-4c39-358c-9ea5-f7e979dde86a"));
}

interface _EventQueue : IDispatch {
  mixin(uuid("6c54d089-6bd6-3309-aea5-e634f0fed5ae"));
}

interface _FileDialog : IDispatch {
  mixin(uuid("a4f945c6-f4ea-3517-87b6-df8d145d9769"));
}

interface _FilteredImageSource : IDispatch {
  mixin(uuid("d2a004bc-7a6d-3597-9334-f95b3766968f"));
}

interface _FlowLayout : IDispatch {
  mixin(uuid("4f4e817b-998e-3139-96b5-9d3ab019a06a"));
}

interface _FocusAdapter : IDispatch {
  mixin(uuid("66dd74d1-c574-37b5-b86c-5f09fd452473"));
}

interface _FocusEvent : IDispatch {
  mixin(uuid("ea78cfc9-79de-357c-b423-3516c392094c"));
}

interface _Font : IDispatch {
  mixin(uuid("89e3458b-742f-39bc-afe0-02e16f253bfd"));
}

interface _FontMetrics : IDispatch {
  mixin(uuid("106a027c-49e9-3b0c-af3e-e5d11f9abe32"));
}

interface _Frame : IDispatch {
  mixin(uuid("76efcadf-11d4-3302-ad6f-194966a01d5b"));
}

interface _Graphics : IDispatch {
  mixin(uuid("0d6552cd-3374-3a7c-af3e-acb9bf06e26c"));
}

interface _GridBagConstraints : IDispatch {
  mixin(uuid("05bc6e40-f613-3f92-b241-1497a1bf1f55"));
}

interface _GridBagLayout : IDispatch {
  mixin(uuid("899d4780-4355-3b20-8ba3-56972747aaf1"));
}

interface _GridLayout : IDispatch {
  mixin(uuid("76f8a2d0-9a39-3f46-af42-b9e2cfb24bba"));
}

interface _IllegalComponentStateException : IDispatch {
  mixin(uuid("7b2b554b-196f-3b04-b683-879bc8c27db7"));
}

interface _Image : IDispatch {
  mixin(uuid("4ea65d16-c41b-3e79-af10-837c8facacb2"));
}

interface _ImageFilter : IDispatch {
  mixin(uuid("9b50c80a-f822-3b8a-b13c-c5b9097e3d6d"));
}

interface _IndexColorModel : IDispatch {
  mixin(uuid("ddd2c747-51ca-360c-a2ec-54400540890e"));
}

interface _InputEvent : IDispatch {
  mixin(uuid("cea43aa4-4b04-3e2e-be21-83925af6f7e5"));
}

interface _Insets : IDispatch {
  mixin(uuid("c8a6ea18-14f9-3111-be45-1a8a9dadc7c5"));
}

interface _ItemEvent : IDispatch {
  mixin(uuid("00fafb66-fe22-3d24-a9e8-9e178ccd0c4b"));
}

interface _KeyAdapter : IDispatch {
  mixin(uuid("36b07f8e-273e-330f-ab2a-a34a584d539c"));
}

interface _KeyEvent : IDispatch {
  mixin(uuid("1047e989-fb6e-36b8-b263-a67273ab6c62"));
}

interface _Label : IDispatch {
  mixin(uuid("fe3f3fd7-1ede-359f-860d-240966588f79"));
}

interface _java_awt_List : IDispatch {
  mixin(uuid("3cc9245b-469c-3218-b4d4-e0eacf5a3e31"));
}

interface _MediaTracker : IDispatch {
  mixin(uuid("457c132b-7a0a-39ee-9422-fe8a863bbd9e"));
}

interface _MemoryImageSource : IDispatch {
  mixin(uuid("bf810e56-79ed-3232-80df-3148e7603af3"));
}

interface _Menu : IDispatch {
  mixin(uuid("7c68642e-e202-3f61-be28-6dec638141a9"));
}

interface _MenuBar : IDispatch {
  mixin(uuid("625e8993-05d0-3050-9c57-39734a117f8e"));
}

interface _MenuComponent : IDispatch {
  mixin(uuid("e5f52712-682e-3dd3-a835-4dd9d2f281de"));
}

interface _MenuItem : IDispatch {
  mixin(uuid("b68cc589-f993-30d8-b547-afe5f8c65cb6"));
}

interface _MenuShortcut : IDispatch {
  mixin(uuid("c744a092-924c-3485-889e-c2618c715e7f"));
}

interface _MouseAdapter : IDispatch {
  mixin(uuid("f7a79cfc-952b-372f-85b7-121be119811e"));
}

interface _MouseEvent : IDispatch {
  mixin(uuid("06d7f0d0-8b69-3302-b2db-7aa4e7d9b1b3"));
}

interface _MouseMotionAdapter : IDispatch {
  mixin(uuid("d43538c9-d7dd-30fc-8eee-c160994fe899"));
}

interface _PaintEvent : IDispatch {
  mixin(uuid("50b248ca-3995-37c0-8306-f6944c6cc3b2"));
}

interface _Panel : IDispatch {
  mixin(uuid("f0b518b4-4730-30db-8ab8-b3382224d498"));
}

interface _PixelGrabber : IDispatch {
  mixin(uuid("083965b1-99fe-3bea-9bd0-45622aef6d28"));
}

interface _java_awt_Point : IDispatch {
  mixin(uuid("9152b51e-b9e8-3496-acde-53cddb393f56"));
}

interface _Polygon : IDispatch {
  mixin(uuid("6a0961fe-cbe9-3852-8437-6382103ab66e"));
}

interface _PopupMenu : IDispatch {
  mixin(uuid("cd346729-8c28-3950-a669-0c8dd46318cf"));
}

interface _PrintJob : IDispatch {
  mixin(uuid("6f507d27-60a1-32b7-9dea-74f335ba82a6"));
}

interface _Rectangle : IDispatch {
  mixin(uuid("0607437f-5635-3df0-acce-2b8611e9e4d5"));
}

interface _ReplicateScaleFilter : IDispatch {
  mixin(uuid("9c8507ee-1f00-355b-9bc2-06eb75866ae6"));
}

interface _RGBImageFilter : IDispatch {
  mixin(uuid("11332813-579b-34f4-873f-17075aec82af"));
}

interface _Scrollbar : IDispatch {
  mixin(uuid("6e658de8-4418-3364-ba8c-38019d374c34"));
}

interface _ScrollPane : IDispatch {
  mixin(uuid("e9828922-d45f-3325-b8ae-9e27e266d659"));
}

interface _StringSelection : IDispatch {
  mixin(uuid("f331143e-4826-3392-a053-76a77281c571"));
}

interface _SystemColor : IDispatch {
  mixin(uuid("316d7951-aa33-3aa7-9c3a-fcc8698b95f6"));
}

interface _TextArea : IDispatch {
  mixin(uuid("c75d673c-2cff-36c3-b8bd-9469c0a2c589"));
}

interface _TextComponent : IDispatch {
  mixin(uuid("94ac8881-7857-3273-a864-a2871d293541"));
}

interface _TextEvent : IDispatch {
  mixin(uuid("0bc6090e-72f1-3a96-a57b-939195a70b45"));
}

interface _TextField : IDispatch {
  mixin(uuid("131d09d7-9342-326e-b7ba-a9295f5eaddd"));
}

interface _Toolkit : IDispatch {
  mixin(uuid("c4cbabe5-b02d-3407-bdaf-ffaf71cd8f70"));
}

interface _UnsupportedFlavorException : IDispatch {
  mixin(uuid("059bd5ac-2e33-3e13-ab0d-18a5aa43ced3"));
}

interface _Window : IDispatch {
  mixin(uuid("d74d2ee0-631d-34f2-b7c2-b695d733f727"));
}

interface _WindowAdapter : IDispatch {
  mixin(uuid("513782bb-f832-3b91-8132-2503a8ff4b52"));
}

interface _WindowEvent : IDispatch {
  mixin(uuid("28517b04-9ea7-3950-9290-3f718fca30bc"));
}

interface _SwingHelper : IDispatch {
  mixin(uuid("25f8790d-4e10-3c37-a32a-686ff4e8405a"));
}

interface _VJSCallbackSwing : IDispatch {
  mixin(uuid("f89f5e07-4153-3928-ab95-e9eea22ab18b"));
}

interface _AppletEventSinkHelper : IDispatch {
  mixin(uuid("cc58b68f-de67-3753-98d0-e807d4c3e6fd"));
}

interface _SystemX : IDispatch {
  mixin(uuid("7c8018ca-4fbe-3304-a09a-486027e4b2b6"));
}

interface _InputMethodMessage : IDispatch {
  mixin(uuid("79dc4898-55b1-3415-a3d9-da4881cd0c9c"));
}

interface _BeanDescriptor : IDispatch {
  mixin(uuid("c78c23e6-ec60-3ff7-89c5-f886c306f966"));
}

interface _Beans : IDispatch {
  mixin(uuid("20647b10-21f0-3599-b4ed-6037da9417f8"));
}

interface _BooleanEditor : IDispatch {
  mixin(uuid("e4993a3a-be22-33ef-ae35-3f5f5f29f900"));
}

interface _ByteEditor : IDispatch {
  mixin(uuid("de0a6d5c-e434-3d0a-8767-e7f810aa4075"));
}

interface _ColorEditor : IDispatch {
  mixin(uuid("223c85bc-9b70-3649-9fe0-f71188c070ab"));
}

interface _DoubleEditor : IDispatch {
  mixin(uuid("1493bd24-cff9-3fe3-99c7-fc9fbe0d12b7"));
}

interface _EventSetDescriptor : IDispatch {
  mixin(uuid("55f2ca6d-211d-37a5-9454-b3232035fd52"));
}

interface _FeatureDescriptor : IDispatch {
  mixin(uuid("5dce4fd9-c9f7-33d9-887b-7988e40573d5"));
}

interface _FloatEditor : IDispatch {
  mixin(uuid("d6bf8ef3-615d-3eaa-a663-d0c03099643e"));
}

interface _FontEditor : IDispatch {
  mixin(uuid("1c3776f6-f820-3496-b808-144a071941e3"));
}

interface _IndexedPropertyDescriptor : IDispatch {
  mixin(uuid("6619c199-5daf-35c5-90dc-5228e587eefa"));
}

interface _IntEditor : IDispatch {
  mixin(uuid("7fd7ccbc-6619-3970-9645-1a87f707661a"));
}

interface _IntrospectionException : IDispatch {
  mixin(uuid("12a9d321-3928-3586-9e3d-40d212d4cf5a"));
}

interface _Introspector : IDispatch {
  mixin(uuid("75589de6-9b5d-3d1a-aac0-2e9b50ac3644"));
}

interface _LongEditor : IDispatch {
  mixin(uuid("8f182a0f-2aab-36f8-be0d-e2f28d1ddac7"));
}

interface _MethodDescriptor : IDispatch {
  mixin(uuid("775ad491-9ea1-3bf0-802a-604e6c2ece20"));
}

interface _ParameterDescriptor : IDispatch {
  mixin(uuid("462472d2-847e-3514-82d4-29544d2b24c9"));
}

interface _PropertyChangeEvent : IDispatch {
  mixin(uuid("b5423189-641b-3ada-887f-53124b0b3923"));
}

interface _PropertyChangeSupport : IDispatch {
  mixin(uuid("e6e7ee29-21c6-3577-bbcf-bf594a0751e4"));
}

interface _PropertyDescriptor : IDispatch {
  mixin(uuid("badd3f64-a8e3-3010-9509-305d4095789c"));
}

interface _PropertyEditorManager : IDispatch {
  mixin(uuid("5c639832-eb27-36b2-8c36-d0d3741653a5"));
}

interface _PropertyEditorSupport : IDispatch {
  mixin(uuid("43a6801e-861a-3ae2-a98d-0473cb7e24db"));
}

interface _PropertyVetoException : IDispatch {
  mixin(uuid("80254b69-5927-36ad-876c-0f226ed73875"));
}

interface _ShortEditor : IDispatch {
  mixin(uuid("a11f0e6c-9bb6-305d-bb07-d290b9d575c3"));
}

interface _SimpleBeanInfo : IDispatch {
  mixin(uuid("75f440d7-ad26-3df0-b6ce-712c912d65d6"));
}

interface _StringEditor : IDispatch {
  mixin(uuid("96e919f0-10d6-3a52-8f45-0cc5da5e9962"));
}

interface _VetoableChangeSupport : IDispatch {
  mixin(uuid("c85b7557-5424-3eaf-9db7-719491bb84f5"));
}

interface _ArrayWithOffset : IDispatch {
  mixin(uuid("33128153-862c-3b5c-a0aa-d7e5f95a0afb"));
}

interface _Callback : IDispatch {
  mixin(uuid("68db639f-076c-3658-aa30-d06834083285"));
}

interface _ParameterCountMismatchError : IDispatch {
  mixin(uuid("ae039fe8-62f0-3105-9cce-f88b038ccd9d"));
}

interface _SystemThread : IDispatch {
  mixin(uuid("e089c743-1227-3298-be6d-1039825d7b38"));
}

interface _BIND_OPTS : IDispatch {
  mixin(uuid("5484436b-9ca9-3c1f-906e-feaa6d5a1f7a"));
}

interface _CLSID : IDispatch {
  mixin(uuid("09377b44-8ba6-39ca-a60b-31f2f1a34e42"));
}

interface _COAUTHIDENTITY : IDispatch {
  mixin(uuid("50e07cab-30c2-387a-8262-ef2e5f95e271"));
}

interface _COAUTHINFO : IDispatch {
  mixin(uuid("11eb2586-85ed-3d6f-817b-7ba6f96654e6"));
}

interface _ComError : IDispatch {
  mixin(uuid("b41bba54-21b4-3ea7-a01e-90b7dd3f79eb"));
}

interface _ComException : IDispatch {
  mixin(uuid("b5a84389-bfd2-3162-8618-4bf02e415058"));
}

interface _ComFailException : IDispatch {
  mixin(uuid("b38b6a6d-e286-3c5e-9bd6-6361d3deeaca"));
}

interface _ComLib : IDispatch {
  mixin(uuid("56859665-d7aa-3637-a011-76db8b80bd1d"));
}

interface _COMMarshaller : IDispatch {
  mixin(uuid("6549e750-3d44-3d55-abca-2aa764789904"));
}

interface _ComSuccessException : IDispatch {
  mixin(uuid("b635fbba-b430-3ebd-9121-def3be6ff845"));
}

interface _CONNECTDATA : IDispatch {
  mixin(uuid("d463ed38-8406-39d9-8f96-31168185dd5d"));
}

interface _ConnectionPointCookie : IDispatch {
  mixin(uuid("0c534fd2-d14d-3500-b84a-a31ef9466e25"));
}

interface _COSERVERINFO : IDispatch {
  mixin(uuid("33f8220d-94ab-3470-b3bf-03a6a7208d51"));
}

interface _CUnknown : IDispatch {
  mixin(uuid("9b35d97a-abeb-3067-a7bf-26ec20bb2eef"));
}

interface _CustomLib : IDispatch {
  mixin(uuid("0cf04a02-156f-3d05-8dac-e3bf22087ca5"));
}

interface _Dispatch : IDispatch {
  mixin(uuid("cdfa7c54-9922-3e45-b402-e52b90d0d07a"));
}

interface _DispatchProxy : IDispatch {
  mixin(uuid("29ec5288-91e9-38ee-8592-d5494a3061ff"));
}

interface _IID : IDispatch {
  mixin(uuid("0c444530-f604-3073-8f83-1d8f9620cacd"));
}

interface _MULTI_QI : IDispatch {
  mixin(uuid("baef350a-9bd3-3b53-b365-b70ea448bd3d"));
}

interface _RemSNB : IDispatch {
  mixin(uuid("bcc73107-0916-3172-9025-bc4d10461f17"));
}

interface _SafeArray : IDispatch {
  mixin(uuid("35aa8501-5a4d-35de-805b-9a04e69ac428"));
}

interface _STATSTG : IDispatch {
  mixin(uuid("6ed5cfb5-7c55-3405-b95b-6782ac3bfa65"));
}

interface _Variant : IDispatch {
  mixin(uuid("1600e5f6-2b41-3d86-9483-8e4178700610"));
}

interface _WrongThreadException : IDispatch {
  mixin(uuid("cdf13af8-2b0d-3c52-96f5-27af853e9ad8"));
}

interface __Guid : IDispatch {
  mixin(uuid("8ea79ccd-7f87-33a4-8ed6-7794d7af88ea"));
}

interface _ABC : IDispatch {
  mixin(uuid("33454be0-04a1-3b5c-a1c2-2d47c7f62b36"));
}

interface _ABCFLOAT : IDispatch {
  mixin(uuid("d0bb7b1e-042c-3b42-b349-aad19a38c472"));
}

interface _ABORTPROC : IDispatch {
  mixin(uuid("84add8e8-6b2b-32c3-a5ac-b51b3ad3b0c0"));
}

interface _ACCEL : IDispatch {
  mixin(uuid("708664d7-27d8-3768-8b72-831a2e9761b4"));
}

interface _ACCESSTIMEOUT : IDispatch {
  mixin(uuid("74d9736c-8f7d-371d-b555-e7a65ff10227"));
}

interface _Advapi32 : IDispatch {
  mixin(uuid("8809a6bc-020e-331b-b795-9b1c0d3be2f4"));
}

interface _ANIMATIONINFO : IDispatch {
  mixin(uuid("970cfb92-cca9-3779-ad54-0791fb89b3d0"));
}

interface _APPBARDATA : IDispatch {
  mixin(uuid("16129bf8-f1cb-3dbd-8e9c-5e21ec658104"));
}

interface _AUXCAPS : IDispatch {
  mixin(uuid("e98735fa-eed6-3302-9cad-25cce6d446b1"));
}

interface _BITMAP : IDispatch {
  mixin(uuid("821d5ff5-eeb5-3b72-888f-370d4a6a339a"));
}

interface _BITMAPCOREHEADER : IDispatch {
  mixin(uuid("c81c4010-37fb-3f7b-b7df-146aa89a9415"));
}

interface _BITMAPINFO : IDispatch {
  mixin(uuid("bf337d38-9640-3ac2-8c14-4ba75e884050"));
}

interface _BITMAPINFO256 : IDispatch {
  mixin(uuid("594afd3b-f046-3401-88bf-290f2542148a"));
}

interface _BITMAPINFOHEADER : IDispatch {
  mixin(uuid("a77e8408-c2a1-31bc-9334-392a18aa9095"));
}

interface _BROADCASTSYSMSG : IDispatch {
  mixin(uuid("53a94ad5-3f09-3669-99f8-bc308f2271a5"));
}

interface _BY_HANDLE_FILE_INFORMATION : IDispatch {
  mixin(uuid("6313e0c1-255c-3c76-83a3-31c44a4f6498"));
}

interface _CALINFO_ENUMPROC : IDispatch {
  mixin(uuid("ebf0acfb-1ff4-3ab1-a9ed-db6fdb610f22"));
}

interface _CHARFORMAT : IDispatch {
  mixin(uuid("6e9fd960-90ca-32df-9be4-add5441946dd"));
}

interface _CHARFORMATA : IDispatch {
  mixin(uuid("767079ca-ef48-3167-bda9-fe16889de935"));
}

interface _CHARRANGE : IDispatch {
  mixin(uuid("08c7a04b-5611-351d-8807-e1d9475f98cb"));
}

interface _CHARSETINFO : IDispatch {
  mixin(uuid("f018c5d7-88bb-3a37-b5fb-8130dcb5ecec"));
}

interface _CHOOSECOLOR : IDispatch {
  mixin(uuid("a1c30f69-4a96-3b1f-991d-e11b4f21bee3"));
}

interface _CHOOSEFONT : IDispatch {
  mixin(uuid("4f5e8106-e709-3fd0-b726-6c227b5b6635"));
}

interface _CIEXYZ : IDispatch {
  mixin(uuid("aa2a5e99-7d9e-3422-b1bc-f60f50da9b03"));
}

interface _CIEXYZTRIPLE : IDispatch {
  mixin(uuid("a5aa2f6b-c8b3-324f-871c-73752ad95f72"));
}

interface _CLIENTCREATESTRUCT : IDispatch {
  mixin(uuid("f331de3f-186e-3e79-afa6-638fea1340b5"));
}

interface _CODEPAGE_ENUMPROC : IDispatch {
  mixin(uuid("8e3c5677-621a-3b15-81f9-963ae1a90ca0"));
}

interface _COLORADJUSTMENT : IDispatch {
  mixin(uuid("142f84b4-d828-3748-b3a7-3cd5ebe82f05"));
}

interface _COLORMAP : IDispatch {
  mixin(uuid("d682d560-0d9d-3c39-934f-3528e1c2a383"));
}

interface _COLORSCHEME : IDispatch {
  mixin(uuid("2064c444-e239-3905-ac6a-cc550e559f10"));
}

interface _COMBOBOXEXITEM : IDispatch {
  mixin(uuid("fdb361c5-63d1-32e0-92d2-bd82f65960c1"));
}

interface _Comctl32 : IDispatch {
  mixin(uuid("f5c896ce-76e5-35d9-a4c1-720d20c12ec5"));
}

interface _Comdlg32 : IDispatch {
  mixin(uuid("bb94c2d8-8ddb-3d5f-a42b-b4b197719a0b"));
}

interface _COMMTIMEOUTS : IDispatch {
  mixin(uuid("f1f40e58-274f-3d1d-8416-b0e9168fc981"));
}

interface _COMPAREITEMSTRUCT : IDispatch {
  mixin(uuid("1354cb09-271d-3211-ba64-cbd08a0925b0"));
}

interface _COMPCOLOR : IDispatch {
  mixin(uuid("ecae9658-4f09-35a4-90bd-948f2464d20a"));
}

interface _COMSTAT : IDispatch {
  mixin(uuid("09a8c647-f94f-3f1c-a2bc-bffbf1ad96a0"));
}

interface _CONSOLE_CURSOR_INFO : IDispatch {
  mixin(uuid("a01f0ff2-5efe-3d9d-9dda-0e7cbee216fc"));
}

interface _CONSOLE_SCREEN_BUFFER_INFO : IDispatch {
  mixin(uuid("af76b17c-460d-3167-9b81-8bfdb56e308f"));
}

interface _COORD : IDispatch {
  mixin(uuid("f66d892e-f342-360c-bdad-fbc3751dfeea"));
}

interface _COPYDATASTRUCT : IDispatch {
  mixin(uuid("109ec38b-58d8-3000-9cc6-6f17613d04ae"));
}

interface _CPINFO : IDispatch {
  mixin(uuid("3a867493-1a29-3bc6-8e20-6f4b34ac328e"));
}

interface _CREATESTRUCT : IDispatch {
  mixin(uuid("f485fa85-fdaf-34cd-9262-89568afa3640"));
}

interface _CREATESTRUCT_I : IDispatch {
  mixin(uuid("9ffdebb6-fd36-3c3c-b487-6c23695ab301"));
}

interface _CRGB : IDispatch {
  mixin(uuid("907f0759-2856-319e-b967-63a0d5a33b12"));
}

interface _CURRENCYFMT : IDispatch {
  mixin(uuid("115e613a-148e-354b-90f2-e245006a5efd"));
}

interface _CURSORSHAPE : IDispatch {
  mixin(uuid("ccdd3d38-77ff-3ac2-bf17-f58671a2952d"));
}

interface _CWPRETSTRUCT : IDispatch {
  mixin(uuid("14809bc6-1cff-3658-8aa4-8695fb249c41"));
}

interface _CWPSTRUCT : IDispatch {
  mixin(uuid("cc525266-d62a-3f18-b435-8fea21c370a5"));
}

interface _DATEFMT_ENUMPROC : IDispatch {
  mixin(uuid("a1cebe60-20f7-361e-b51d-f49ace445ba4"));
}

interface _DCB : IDispatch {
  mixin(uuid("c4cd2ba5-42df-3261-b626-eb5723c04e32"));
}

interface _DELETEITEMSTRUCT : IDispatch {
  mixin(uuid("5adf5ccd-d258-354d-82d3-c5519a43b52a"));
}

interface _DESKTOPENUMPROC : IDispatch {
  mixin(uuid("4188ae3a-faff-3a13-900c-93673d5f5f36"));
}

interface _DEVMODE : IDispatch {
  mixin(uuid("fd13bf81-526b-39d2-ad56-2c138882f89b"));
}

interface _DEVNAMES : IDispatch {
  mixin(uuid("6c7ec81e-0522-3127-8ee4-c243858ef0a6"));
}

interface _DLGPROC : IDispatch {
  mixin(uuid("7941c839-de7c-331d-86f6-8c06b5888bc6"));
}

interface _DLGTEMPLATE : IDispatch {
  mixin(uuid("c6c276b0-2fd3-316b-8756-4f19d383f3d0"));
}

interface _DOCINFO : IDispatch {
  mixin(uuid("28e41752-2839-3039-bb74-f18b26e7846a"));
}

interface _DRAWITEMSTRUCT : IDispatch {
  mixin(uuid("4af108ed-6a9b-3cd5-a366-5e176893f232"));
}

interface _DRAWITEMSTRUCT_X : IDispatch {
  mixin(uuid("0a46b405-5dc2-3e6c-99b6-1dc5fb3fe0e5"));
}

interface _DRAWSTATEPROC : IDispatch {
  mixin(uuid("a23eb79d-576f-3ab4-aeec-afe9f1baed91"));
}

interface _DRAWTEXTPARAMS : IDispatch {
  mixin(uuid("c38e2adb-29c0-30c5-9f65-0abc3f7f1b61"));
}

interface _DROPSTRUCT : IDispatch {
  mixin(uuid("30751731-a692-34a5-8d41-0124f3ad57ab"));
}

interface _EDITSTREAM : IDispatch {
  mixin(uuid("6cdee979-7a8c-3373-9d62-135a74c5c629"));
}

interface _ENDROPFILES : IDispatch {
  mixin(uuid("0d9c0e99-dce4-37f7-bf5d-c361632b3a38"));
}

interface _ENHMETAHEADER : IDispatch {
  mixin(uuid("9471314e-aa99-39f4-8a1f-4a052341cbfd"));
}

interface _ENPROTECTED : IDispatch {
  mixin(uuid("2f6ab880-3022-3fef-858f-718164271b6b"));
}

interface _EnumFontFamExProc : IDispatch {
  mixin(uuid("e445384f-4520-3435-8799-c8d0ff125301"));
}

interface _ENUMLOGFONT : IDispatch {
  mixin(uuid("765537f6-d6d7-3343-bb77-bcc244d12b83"));
}

interface _ENUMLOGFONTEX : IDispatch {
  mixin(uuid("8f17469d-b9e3-3de9-bcce-bbf68382fdbd"));
}

interface _ENUMLOGFONTEX_X : IDispatch {
  mixin(uuid("3bf1226a-85e6-381b-95ba-18633b243e3e"));
}

interface _ENUMRESLANGPROC : IDispatch {
  mixin(uuid("e75656f6-7f3e-336a-ac9f-2dc56943303f"));
}

interface _ENUMRESNAMEPROC : IDispatch {
  mixin(uuid("4506cec0-45cd-3701-a1c1-9c84288715fe"));
}

interface _ENUMRESTYPEPROC : IDispatch {
  mixin(uuid("d4456660-5b5e-3b79-b3df-55051afe660c"));
}

interface _EVENTMSG : IDispatch {
  mixin(uuid("980679ba-9595-325c-b93b-526ed271c0a1"));
}

interface _EXTLOGFONT : IDispatch {
  mixin(uuid("bedc0ff0-2511-3ad7-b6ec-77ba135f7197"));
}

interface _FILETIME : IDispatch {
  mixin(uuid("05c46abb-4045-3808-8448-4bee222324df"));
}

interface _FILTERKEYS : IDispatch {
  mixin(uuid("2dbaa9c7-b9c7-3209-9cdd-00a43df047fb"));
}

interface _FINDREPLACE : IDispatch {
  mixin(uuid("9174102e-09bf-3f90-a926-cf644700e3e0"));
}

interface _FINDTEXT : IDispatch {
  mixin(uuid("3d910845-75f5-3cc6-ab7a-3032934af9b9"));
}

interface _FINDTEXTA : IDispatch {
  mixin(uuid("c941f831-cca4-3cf7-809a-46f46a4a4bd2"));
}

interface _FINDTEXTA_EX : IDispatch {
  mixin(uuid("0cbf430a-4d7a-33ec-b103-e108fdd087be"));
}

interface _FINDTEXTEX : IDispatch {
  mixin(uuid("395e02df-4072-3393-a88f-d7ea0f3cf96f"));
}

interface _FINDTEXTEXA : IDispatch {
  mixin(uuid("0323d864-9f39-3ba2-acc3-c0fb09dd26b4"));
}

interface _FIXED : IDispatch {
  mixin(uuid("8699967d-93e0-3f41-9c90-b621c6825d16"));
}

interface _FONTENUMPROC : IDispatch {
  mixin(uuid("bad21da9-5021-364d-83bc-d1a98dc6ea06"));
}

interface _FONTSIGNATURE : IDispatch {
  mixin(uuid("8e96ebf4-9fc2-34dd-b310-a8ea3b8009a8"));
}

interface _FORMATRANGE : IDispatch {
  mixin(uuid("a2d660bf-248b-30fd-a3ad-542a3975cbbe"));
}

interface _FORM_INFO_1 : IDispatch {
  mixin(uuid("f4812281-d613-3365-b929-ec9499cac19c"));
}

interface _GCP_RESULTS : IDispatch {
  mixin(uuid("5fd8878b-66e0-3c96-8230-d7676cdab535"));
}

interface _Gdi32 : IDispatch {
  mixin(uuid("bd3a3d4b-9e7a-36d5-be7a-3aa79e14c1d5"));
}

interface _GENERIC_MAPPING : IDispatch {
  mixin(uuid("fcb5c6e8-7dfe-3874-b94c-a6486e115a00"));
}

interface _GLYPHMETRICS : IDispatch {
  mixin(uuid("81cf3dc6-522c-31ae-95c8-9c83b96b7830"));
}

interface _GOBJENUMPROCBRUSH : IDispatch {
  mixin(uuid("4de23a5b-9a91-3c0c-b2cd-1a0367326eba"));
}

interface _GOBJENUMPROCPEN : IDispatch {
  mixin(uuid("cf423fbb-0033-362b-84fc-73799852acc6"));
}

interface _GRAYSTRINGPROC : IDispatch {
  mixin(uuid("bc10ddd6-9ca9-375b-888a-d805bc2ee07d"));
}

interface _HDITEM : IDispatch {
  mixin(uuid("20846c26-3bcd-3478-b129-6a0d7d16b6c4"));
}

interface _HDLAYOUT : IDispatch {
  mixin(uuid("ad2dc492-1362-34a8-9d11-376d5eb1f706"));
}

interface _HELPINFO : IDispatch {
  mixin(uuid("266fd0e0-8563-3b35-b90e-83f447c1cba0"));
}

interface _HELPWININFO : IDispatch {
  mixin(uuid("a48c4044-498f-3773-bbbd-96bdfdc2e9f2"));
}

interface _HIGHCONTRAST : IDispatch {
  mixin(uuid("80096c7d-092a-3f01-b367-d27f0f54aaaa"));
}

interface _HW_PROFILE_INFO : IDispatch {
  mixin(uuid("1f7366c0-257d-3c51-ad1b-23ae27ec9b1e"));
}

interface _ICMENUMPROC : IDispatch {
  mixin(uuid("296a3ecb-7607-31d7-8989-204d9227fad7"));
}

interface _ICONINFO : IDispatch {
  mixin(uuid("94d1a9ab-b583-3317-a417-9c7e84514fb4"));
}

interface _ICONMETRICS : IDispatch {
  mixin(uuid("969365eb-af49-36c7-89e1-53c84a0cd856"));
}

interface _IMAGEINFO : IDispatch {
  mixin(uuid("d3a25309-9efc-3783-a6e1-8de0d47880f5"));
}

interface _IMAGELISTDRAWPARAMS : IDispatch {
  mixin(uuid("64be6b44-911e-37f4-a347-11e052f74e27"));
}

interface _INITCOMMONCONTROLSEX : IDispatch {
  mixin(uuid("878803f2-3ba7-3bdb-b9db-dd30fc7d72b0"));
}

interface _JOB_INFO_1 : IDispatch {
  mixin(uuid("6619a429-7f9f-39a6-9447-e84a6a3e1a06"));
}

interface _JOB_INFO_2 : IDispatch {
  mixin(uuid("30626524-e010-3fa2-b9ca-e1d69ccddbdc"));
}

interface _JOB_INFO_3 : IDispatch {
  mixin(uuid("24ddaace-93ba-33d0-af6f-89d8cd2688b8"));
}

interface _JOYCAPS : IDispatch {
  mixin(uuid("77d0730c-4e3f-3072-b42e-e5e9aed7752b"));
}

interface _JOYINFO : IDispatch {
  mixin(uuid("992d39f8-a8e5-3887-84fe-05eb2430bbcc"));
}

interface _JOYINFOEX : IDispatch {
  mixin(uuid("ed2f493e-1651-333c-a704-c99ac1c1ba45"));
}

interface _Kernel32 : IDispatch {
  mixin(uuid("33277348-4845-3e9b-807f-7e2e861c1b93"));
}

interface _KERNINGPAIR : IDispatch {
  mixin(uuid("1341837a-2768-3090-ab3e-f3f198d5420d"));
}

interface _LINEDDAPROC : IDispatch {
  mixin(uuid("d5cc2439-6e9f-367f-9e73-b8ce7ad0b475"));
}

interface _LOCALESIGNATURE : IDispatch {
  mixin(uuid("242e39e5-a061-3c69-9290-ac7292698442"));
}

interface _LOCALE_ENUMPROC : IDispatch {
  mixin(uuid("1be731dc-6169-3350-9324-6df86e2c682b"));
}

interface _LOGBRUSH : IDispatch {
  mixin(uuid("abd56f04-8e9b-31b7-8925-a50143a96b3e"));
}

interface _LOGCOLORSPACE : IDispatch {
  mixin(uuid("0e87a880-1e1e-3344-9508-4d41ecb9120d"));
}

interface _LOGFONT : IDispatch {
  mixin(uuid("232fe719-396c-3fc6-b22b-5d28d0977afb"));
}

interface _LOGPALETTE : IDispatch {
  mixin(uuid("646dd8d1-d2cf-34ad-9e34-80a7212fea7c"));
}

interface _LOGPEN : IDispatch {
  mixin(uuid("ae7ddfb3-cd9e-33c4-864a-82ab15adaea3"));
}

interface _LPFIBER_START_ROUTINE : IDispatch {
  mixin(uuid("b17c0e37-2b37-35db-982f-f1b595ae024a"));
}

interface _LPMMIOPROC : IDispatch {
  mixin(uuid("770c832f-6def-3231-87b7-6a6087f6dbbf"));
}

interface _LPOVERLAPPED_COMPLETION_ROUTINE : IDispatch {
  mixin(uuid("9255710b-096d-3f42-9bb9-1c3e97749c94"));
}

interface _LPPROGRESS_ROUTINE : IDispatch {
  mixin(uuid("464acfae-cbfe-3f7d-9800-19fe92dca230"));
}

interface _LPTHREAD_START_ROUTINE : IDispatch {
  mixin(uuid("734d0f8e-6160-3420-95b5-5863dc7631d8"));
}

interface _LPTIMECALLBACK : IDispatch {
  mixin(uuid("c6b3d8d1-ff1c-39e2-a1ac-23cb55b2c7da"));
}

interface _LUID : IDispatch {
  mixin(uuid("0901a438-b139-387d-b589-23868024a6bf"));
}

interface _LUID_AND_ATTRIBUTES : IDispatch {
  mixin(uuid("51df3166-ef70-3e64-b190-df81aaa96b72"));
}

interface _LVCOLUMN : IDispatch {
  mixin(uuid("462f284e-f1cc-3514-8780-06299000e491"));
}

interface _LVCOLUMN_T : IDispatch {
  mixin(uuid("8f84d572-a12e-3b39-9b6e-7a394d294046"));
}

interface _LVFINDINFO : IDispatch {
  mixin(uuid("1c36da95-2dfe-320c-8760-bc7e3810e317"));
}

interface _LVHITTESTINFO : IDispatch {
  mixin(uuid("8e45e531-dfb1-37b3-9ed2-b36fef34d261"));
}

interface _LVITEM : IDispatch {
  mixin(uuid("78d993ec-78e6-3fe9-8480-22943374c24c"));
}

interface _LVITEM_T : IDispatch {
  mixin(uuid("6bebc5b4-5a91-3319-9a07-de896833a99f"));
}

interface _Lz32 : IDispatch {
  mixin(uuid("f8f42432-32cd-3b14-a2df-99b8f252b3d3"));
}

interface _MAT2 : IDispatch {
  mixin(uuid("a2625121-d326-302b-9f18-1360c6b4d0a5"));
}

interface _MCHITTESTINFO : IDispatch {
  mixin(uuid("4f15b66d-cce8-3611-ae9b-874187dd2eca"));
}

interface _MCI_ANIM_OPEN_PARMS : IDispatch {
  mixin(uuid("2e67e91f-f39c-3e59-b317-d49ef40f2a6c"));
}

interface _MCI_ANIM_PLAY_PARMS : IDispatch {
  mixin(uuid("c490724f-6263-3511-ba2d-946e3b09e0a6"));
}

interface _MCI_ANIM_RECT_PARMS : IDispatch {
  mixin(uuid("dc85c4d5-eb61-3584-9884-e287cfd9fbec"));
}

interface _MCI_ANIM_STEP_PARMS : IDispatch {
  mixin(uuid("d4cd37a4-9aa0-327e-a859-fefcc3fee686"));
}

interface _MCI_ANIM_UPDATE_PARMS : IDispatch {
  mixin(uuid("68062763-d5ec-3621-b349-e124a3304aaa"));
}

interface _MCI_ANIM_WINDOW_PARMS : IDispatch {
  mixin(uuid("bf963504-0e66-305f-bb09-92e1cf975405"));
}

interface _MCI_BREAK_PARMS : IDispatch {
  mixin(uuid("b16d8bb9-625f-3432-899b-ece0e06b3aa8"));
}

interface _MCI_GENERIC_PARMS : IDispatch {
  mixin(uuid("00d09523-0e4f-3455-90f0-da4bc2f364c3"));
}

interface _MCI_GETDEVCAPS_PARMS : IDispatch {
  mixin(uuid("b23b7978-5805-3c5e-9f2a-b9db372ca076"));
}

interface _MCI_INFO_PARMS : IDispatch {
  mixin(uuid("da3a449e-8655-36df-9c50-a82eaf20e507"));
}

interface _MCI_LOAD_PARMS : IDispatch {
  mixin(uuid("723c3f69-95b0-393b-8562-c6a9820f2538"));
}

interface _MCI_OPEN_PARMS : IDispatch {
  mixin(uuid("057f0add-f8cf-34af-b824-b6f2b3d27b62"));
}

interface _MCI_OVLY_LOAD_PARMS : IDispatch {
  mixin(uuid("70dd06be-e56d-34d9-b3b1-7a9b14bad7e9"));
}

interface _MCI_OVLY_OPEN_PARMS : IDispatch {
  mixin(uuid("d95f9f5b-c6d2-3be5-98a2-705a9350e64a"));
}

interface _MCI_OVLY_RECT_PARMS : IDispatch {
  mixin(uuid("eb3edd1d-65d5-3103-8f5f-6ace15284b53"));
}

interface _MCI_OVLY_SAVE_PARMS : IDispatch {
  mixin(uuid("1ca66350-7c16-3617-b66c-1b1e0a491836"));
}

interface _MCI_OVLY_WINDOW_PARMS : IDispatch {
  mixin(uuid("c8b2b309-90fd-39f0-a1ea-179c458f68bd"));
}

interface _MCI_PLAY_PARMS : IDispatch {
  mixin(uuid("d0efadf5-f77d-3049-b083-729612d4071c"));
}

interface _MCI_RECORD_PARMS : IDispatch {
  mixin(uuid("28cee4db-5c99-37d7-9bda-92f74e56fc74"));
}

interface _MCI_SAVE_PARMS : IDispatch {
  mixin(uuid("f1f7934b-a639-320f-9f08-39d809f971e4"));
}

interface _MCI_SEEK_PARMS : IDispatch {
  mixin(uuid("f5d04173-1fa8-3c89-92d5-982e31963c88"));
}

interface _MCI_SEQ_SET_PARMS : IDispatch {
  mixin(uuid("4ee2d271-bddd-3672-bef1-428da04807c0"));
}

interface _MCI_SET_PARMS : IDispatch {
  mixin(uuid("05e67667-f10f-348a-a602-547c78b8213e"));
}

interface _MCI_STATUS_PARMS : IDispatch {
  mixin(uuid("a962e671-5bab-3200-926c-fc6b9b3c9f06"));
}

interface _MCI_SYSINFO_PARMS : IDispatch {
  mixin(uuid("398b34a9-0c3c-38b9-bbbf-eea78cadc05c"));
}

interface _MCI_VD_ESCAPE_PARMS : IDispatch {
  mixin(uuid("14cba5a4-c09b-3879-b840-e4175e21f455"));
}

interface _MCI_VD_PLAY_PARMS : IDispatch {
  mixin(uuid("85c36c2d-3f21-36d5-a4b3-a3135a775899"));
}

interface _MCI_VD_STEP_PARMS : IDispatch {
  mixin(uuid("b1dfb3a9-ccfc-3768-bb03-76c71b4f2abc"));
}

interface _MCI_WAVE_DELETE_PARMS : IDispatch {
  mixin(uuid("98ff1f03-a736-38b5-99b8-feccc75797f1"));
}

interface _MCI_WAVE_OPEN_PARMS : IDispatch {
  mixin(uuid("ebff3058-4a4d-31d8-a6c1-d97453d19b7c"));
}

interface _MCI_WAVE_SET_PARMS : IDispatch {
  mixin(uuid("e6586f41-4f1a-3963-b338-b45828c33743"));
}

interface _MDICREATESTRUCT : IDispatch {
  mixin(uuid("d00c86fd-d789-3763-a345-bea7fc09e158"));
}

interface _MDINEXTMENU : IDispatch {
  mixin(uuid("74c9c149-85ff-3c91-87bb-662eda999928"));
}

interface _MEASUREITEMSTRUCT : IDispatch {
  mixin(uuid("b2e7fa3d-faad-3543-a2e7-8c154235b658"));
}

interface _MEMORYSTATUS : IDispatch {
  mixin(uuid("c4678376-8c77-3fd8-9788-b442fe0eb2ed"));
}

interface _MEMORY_BASIC_INFORMATION : IDispatch {
  mixin(uuid("525e01fb-b513-30a4-8f64-6e82a2b50179"));
}

interface _MENUITEMINFO : IDispatch {
  mixin(uuid("739c27d2-facc-3827-a720-5522d69cef72"));
}

interface _MENUITEMINFO_T : IDispatch {
  mixin(uuid("e1332e22-3998-30ff-964d-0a6856ed7484"));
}

interface _METAFILEPICT : IDispatch {
  mixin(uuid("68b47f14-2785-396a-badb-2a416fb6d340"));
}

interface _MIDIHDR : IDispatch {
  mixin(uuid("8436aa83-0ea8-336c-9608-97a1f1bd0d63"));
}

interface _MIDIINCAPS : IDispatch {
  mixin(uuid("894632dd-8cc1-36cd-9d75-6f7505c6ad08"));
}

interface _MIDIINPROC : IDispatch {
  mixin(uuid("19e77bfe-0010-3028-8631-8186ab8e2bba"));
}

interface _MIDIOUTCAPS : IDispatch {
  mixin(uuid("c6d46941-ba59-32d7-9136-d6c0652b4777"));
}

interface _MIDIOUTPROC : IDispatch {
  mixin(uuid("14290d23-a82f-3382-92c0-361599007ade"));
}

interface _MIDIPROPTEMPO : IDispatch {
  mixin(uuid("e3fa29d3-c88b-38d1-8ce6-ec2d1bac0108"));
}

interface _MIDIPROPTIMEDIV : IDispatch {
  mixin(uuid("b701800d-2544-38ed-98cb-f3bb9ef7365f"));
}

interface _MIDISTRMBUFFVER : IDispatch {
  mixin(uuid("31c0d349-f2c7-3857-af2c-b24ba8bb6318"));
}

interface _MINIMIZEDMETRICS : IDispatch {
  mixin(uuid("cb0e6e88-bf5f-3fe6-ab29-0c232d3aa749"));
}

interface _MINMAXINFO : IDispatch {
  mixin(uuid("fa5125d1-bc4a-3448-9f61-87b90d62f285"));
}

interface _MINMAXINFO_X : IDispatch {
  mixin(uuid("c7af2749-7ae2-3918-9177-3c81a7c72919"));
}

interface _MIXERCAPS : IDispatch {
  mixin(uuid("81c45fa2-d527-3509-bcf8-0ed64dc5cacf"));
}

interface _MIXERCONTROLDETAILS : IDispatch {
  mixin(uuid("738c9eb5-5010-3e81-8241-8f1a59e28ff5"));
}

interface _MIXERCONTROLDETAILS_BOOLEAN : IDispatch {
  mixin(uuid("e4cd4357-9b8f-3b4d-a5ea-d8d9d72c09dc"));
}

interface _MIXERCONTROLDETAILS_LISTTEXT : IDispatch {
  mixin(uuid("eff07014-26f5-3a83-a365-87a98488c30f"));
}

interface _MIXERCONTROLDETAILS_SIGNED : IDispatch {
  mixin(uuid("3537ba70-cbb5-3edf-8b8b-eadd75caec08"));
}

interface _MIXERCONTROLDETAILS_UNSIGNED : IDispatch {
  mixin(uuid("6f684c6e-3576-3f8e-ba17-2ce2b1cd0960"));
}

interface _MIXERLINE : IDispatch {
  mixin(uuid("cbb83dad-3ce3-3d56-a95d-8256581e5c87"));
}

interface _MIXERLINECONTROLS : IDispatch {
  mixin(uuid("430a12b7-a976-3364-b347-6424f77b1242"));
}

interface _MMCKINFO : IDispatch {
  mixin(uuid("b8e7b8cd-bd88-3d14-8964-99853e202df6"));
}

interface _MMIOINFO : IDispatch {
  mixin(uuid("8bfc9b4b-79fc-35ec-892d-67ce9a12389b"));
}

interface _MMTIME : IDispatch {
  mixin(uuid("f91059c4-e3fb-33e0-810a-6bf73b224c1d"));
}

interface _MOUSEHOOKSTRUCT : IDispatch {
  mixin(uuid("cf6b81d3-a920-376e-a542-096d79c2cfcc"));
}

interface _MOUSEKEYS : IDispatch {
  mixin(uuid("835e5509-7706-3db6-a23b-b902cadd2e71"));
}

interface _MSG : IDispatch {
  mixin(uuid("7b685fd9-09fa-3411-9778-0903de4bdf5a"));
}

interface _MSGBOXPARAMS : IDispatch {
  mixin(uuid("895cda6c-4991-3ad8-af0b-ff9e5b5aa686"));
}

interface _NCCALCSIZE_PARAMS : IDispatch {
  mixin(uuid("73484d88-1425-35a3-bc70-6c4aa1005ea8"));
}

interface _NEWTEXTMETRIC : IDispatch {
  mixin(uuid("76875df7-c3b2-32a5-afbf-4d6adf1d7c3a"));
}

interface _NEWTEXTMETRICEX : IDispatch {
  mixin(uuid("6e9340d1-b796-375d-817a-263802d8d4fe"));
}

interface _NMCUSTOMDRAW : IDispatch {
  mixin(uuid("7a60e786-d6e2-367d-b383-097035ada17c"));
}

interface _NMDATETIMECHANGE : IDispatch {
  mixin(uuid("824dd46f-26dc-38e1-9169-59172b63f0ba"));
}

interface _NMDATETIMEFORMAT : IDispatch {
  mixin(uuid("12d54ac6-7503-35f4-ac31-a206e8c9c7ec"));
}

interface _NMDATETIMEFORMATQUERY : IDispatch {
  mixin(uuid("a547d2b9-4176-3dab-8e9c-cd7156c0b9ad"));
}

interface _NMDATETIMESTRING : IDispatch {
  mixin(uuid("4ca23d03-097d-36fa-b9cc-c2949d3190ae"));
}

interface _NMDATETIMEWMKEYDOWN : IDispatch {
  mixin(uuid("be02279e-2b0b-3538-bfb6-095fa95f1435"));
}

interface _NMDAYSTATE : IDispatch {
  mixin(uuid("eb49dca0-dcff-37b0-88ce-42ffa11fda0d"));
}

interface _NMHDR : IDispatch {
  mixin(uuid("17a17e31-fb74-3b9a-ad5d-2e0fedc3ae90"));
}

interface _NMHEADER : IDispatch {
  mixin(uuid("2f26d2c2-c52f-3c94-90c9-6d5862c55eb7"));
}

interface _NMITEMACTIVATE : IDispatch {
  mixin(uuid("05ca2e6c-4f48-3315-83e6-89787d042ec0"));
}

interface _NMLISTVIEW : IDispatch {
  mixin(uuid("41472d14-7bc3-392e-bbb6-3f29f88eaa4f"));
}

interface _NMLVCACHEHINT : IDispatch {
  mixin(uuid("d7bb21e2-c175-38ce-88fb-ab0601779d98"));
}

interface _NMLVCUSTOMDRAW : IDispatch {
  mixin(uuid("2c42a34e-7ed3-37b8-a840-c4e73301c9de"));
}

interface _NMLVDISPINFO : IDispatch {
  mixin(uuid("59f1dc24-83bd-3d75-8aaa-f5754b58cf40"));
}

interface _NMLVFINDITEM : IDispatch {
  mixin(uuid("172b339d-52ea-3a49-9f89-93e1d3666900"));
}

interface _NMLVKEYDOWN : IDispatch {
  mixin(uuid("8c9e3292-7c3c-37f9-bd7d-8443f7c7e858"));
}

interface _NMLVODSTATECHANGE : IDispatch {
  mixin(uuid("0ad4f682-d6f3-3ce7-a832-7366bf17bf33"));
}

interface _NMRBAUTOSIZE : IDispatch {
  mixin(uuid("5600b88b-ac13-30e9-8bfa-046b841af886"));
}

interface _NMREBAR : IDispatch {
  mixin(uuid("b2292120-e896-36f1-b1e0-8109b8bc4b27"));
}

interface _NMREBARCHILDSIZE : IDispatch {
  mixin(uuid("0d357dd2-44b6-3d66-bd5a-dbc9f6a17493"));
}

interface _NMSELCHANGE : IDispatch {
  mixin(uuid("f2fd378b-dd5a-3d0e-843b-4f29f985a88c"));
}

interface _NMTCKEYDOWN : IDispatch {
  mixin(uuid("fe80271e-f23e-31aa-9f69-ed527b12e31a"));
}

interface _NMTOOLBAR : IDispatch {
  mixin(uuid("f918b3bf-1676-3bdb-953b-5dbb6149fbd4"));
}

interface _NMTREEVIEW : IDispatch {
  mixin(uuid("966e590c-8c21-3d51-9d3b-bc27e36f29d6"));
}

interface _NMTREEVIEW_T : IDispatch {
  mixin(uuid("07d66996-a1c1-379f-b1ac-619b41d8d04b"));
}

interface _NMTVCUSTOMDRAW : IDispatch {
  mixin(uuid("02a783bb-be53-3829-875b-8e8469402d21"));
}

interface _NMTVDISPINFO : IDispatch {
  mixin(uuid("a5e64d96-2b5d-3a51-8663-8f12c3c7c663"));
}

interface _NMTVDISPINFO_T : IDispatch {
  mixin(uuid("e954dd0b-e3a2-33ee-8e03-c647062df16c"));
}

interface _NMTVKEYDOWN : IDispatch {
  mixin(uuid("b8e6a50e-2c35-3361-bcd1-4c38c25da922"));
}

interface _NMUPDOWN : IDispatch {
  mixin(uuid("a2e5603e-18af-3efe-8b01-e8810304df3f"));
}

interface _NONCLIENTMETRICS : IDispatch {
  mixin(uuid("6987ca72-fb40-31d3-85a8-163fe73545fe"));
}

interface _NOTIFYICONDATA : IDispatch {
  mixin(uuid("72d79aae-6fd9-3b0e-974d-7818de3ae690"));
}

interface _NUMBERFMT : IDispatch {
  mixin(uuid("d3a64284-6a7a-3e7c-9260-fa4f384fa29e"));
}

interface _OFNOTIFY : IDispatch {
  mixin(uuid("4c482c68-6a92-3a8b-ac8c-91575237a06e"));
}

interface _OFSTRUCT : IDispatch {
  mixin(uuid("1ece137a-e3df-3d18-bd93-a25afcabb03f"));
}

interface _Ole32 : IDispatch {
  mixin(uuid("2f616229-27c3-35aa-92b8-a60d46836c17"));
}

interface _OPENFILENAME : IDispatch {
  mixin(uuid("d71bb9c6-a439-3d48-aded-7cf0ae310f99"));
}

interface _OPENFILENAME_I : IDispatch {
  mixin(uuid("2241cc1c-a97a-3425-adfa-d81a3b681cfc"));
}

interface _OSVERSIONINFO : IDispatch {
  mixin(uuid("c4426e90-cf30-35b9-93b5-0092d04aaa58"));
}

interface _OUTLINETEXTMETRIC : IDispatch {
  mixin(uuid("0a6fb1fb-4e0e-30b7-bcd2-f9932a8d3d52"));
}

interface _OVERLAPPED : IDispatch {
  mixin(uuid("3de9d169-269b-3c0d-b888-ee9c0a25c019"));
}

interface _PAGESETUPDLG : IDispatch {
  mixin(uuid("353f207a-f787-3dff-b4de-e9805c42d8eb"));
}

interface _PAINTSTRUCT : IDispatch {
  mixin(uuid("66449e13-fbe6-3e78-949b-f6b9d68fa3ab"));
}

interface _PALETTEENTRY : IDispatch {
  mixin(uuid("ce332786-9d21-3995-b3ce-02a03224a9f1"));
}

interface _PANOSE : IDispatch {
  mixin(uuid("392c4e72-0012-3c3a-8cfd-d864d88c3320"));
}

interface _PAPCFUNC : IDispatch {
  mixin(uuid("9f095f46-410a-3e35-b103-f7f07ff7b87b"));
}

interface _PARAFORMAT : IDispatch {
  mixin(uuid("5d35a892-c3a4-3d0e-96e1-7f1f92a30131"));
}

interface _PBRANGE : IDispatch {
  mixin(uuid("ee005503-de2c-3e0b-b73b-9da8595e84ec"));
}

interface _PFNLVCOMPARE : IDispatch {
  mixin(uuid("deafe446-f47f-3d54-98e1-b55d80c3de5d"));
}

interface _PFNTVCOMPARE : IDispatch {
  mixin(uuid("4cf61672-d527-3b09-88e2-719628805c84"));
}

interface _PHANDLER_ROUTINE : IDispatch {
  mixin(uuid("4690d807-8f35-38e9-b3bc-1a7dae8bebba"));
}

interface _PIXELFORMATDESCRIPTOR : IDispatch {
  mixin(uuid("26b3daf0-a5a6-3273-a800-373ce382bba6"));
}

interface _com_ms_win32_POINT : IDispatch {
  mixin(uuid("bda79b7b-487b-3537-8a58-a05c83300e1c"));
}

interface _POLYTEXT : IDispatch {
  mixin(uuid("e392fcf9-0710-38bc-bb83-9df3240ac494"));
}

interface _PRINTDLG : IDispatch {
  mixin(uuid("a8f7a16d-b3b6-3deb-898e-fc6b925aaef0"));
}

interface _PRINTER_DEFAULTS : IDispatch {
  mixin(uuid("885d2e90-3cfd-39bb-b5da-f5bbd6584828"));
}

interface _PRINTER_INFO : IDispatch {
  mixin(uuid("c2fbe1be-22e0-3af8-83ad-89abc949b3be"));
}

interface _PRINTER_INFO_1 : IDispatch {
  mixin(uuid("84c5a9e1-02fa-3783-963f-6ac7c5f8a80c"));
}

interface _PRINTER_INFO_2 : IDispatch {
  mixin(uuid("c1822f64-f1d4-388a-97fe-842cd6f047ec"));
}

interface _PRINTER_INFO_4 : IDispatch {
  mixin(uuid("eb55a7d2-064e-33e5-8565-157bd71aeb9b"));
}

interface _PRINTER_INFO_5 : IDispatch {
  mixin(uuid("527e23ab-c731-3225-899e-ce45571b3981"));
}

interface _PRIVILEGE_SET : IDispatch {
  mixin(uuid("7e6fe445-fc7a-3808-b457-29584db28345"));
}

interface _PROCESS_INFORMATION : IDispatch {
  mixin(uuid("614e3a24-3ae9-3d5f-8477-d5eb9c94dac3"));
}

interface _PROPENUMPROC : IDispatch {
  mixin(uuid("b0ac69c7-cdd5-3cb7-b4ff-e73362ad51d7"));
}

interface _PROPENUMPROCEX : IDispatch {
  mixin(uuid("a6181778-b7d8-33fc-b2e4-94a7b6105865"));
}

interface _PTIMERAPCROUTINE : IDispatch {
  mixin(uuid("b56a4662-3917-3ceb-a130-0537d4322533"));
}

interface _PUNCTUATION : IDispatch {
  mixin(uuid("17181c32-cd70-33bb-8ced-55b4b5f6f9a0"));
}

interface _RASTERIZER_STATUS : IDispatch {
  mixin(uuid("f4365d33-0fc2-3d5a-b1ab-2bd1bba94741"));
}

interface _RBHITTESTINFO : IDispatch {
  mixin(uuid("18634882-37d5-358b-bce0-a0ee855a72b7"));
}

interface _REBARBANDINFO : IDispatch {
  mixin(uuid("7a31ff78-5279-3450-9a83-2816482fcc0e"));
}

interface _REBARBANDINFO_IE4 : IDispatch {
  mixin(uuid("a9534e49-4e2c-3601-bd4e-f06744a6b1cd"));
}

interface _REBARINFO : IDispatch {
  mixin(uuid("c0997920-b311-34ee-abb8-f4a49bd9add7"));
}

interface _com_ms_win32_RECT : IDispatch {
  mixin(uuid("3be4806a-8023-34cc-9edc-d91540d08151"));
}

interface _RECTL : IDispatch {
  mixin(uuid("6f2344d0-838a-380c-a7bd-23976f1f3f71"));
}

interface _REPASTESPECIAL : IDispatch {
  mixin(uuid("7802cc5b-8595-342e-8a8d-3f57a8c32786"));
}

interface _REQRESIZE : IDispatch {
  mixin(uuid("02efabaa-d1b4-30d5-a74d-192f55c6c139"));
}

interface _RGBQUAD : IDispatch {
  mixin(uuid("b4bc7c36-d717-3eee-a209-e81b50ec6c72"));
}

interface _SCROLLINFO : IDispatch {
  mixin(uuid("3ac446e6-7e28-3f5d-90e2-52bdffbb9eb2"));
}

interface _SECURITY_ATTRIBUTES : IDispatch {
  mixin(uuid("8dba4d1f-1ab9-3291-a754-fa72b0280dfd"));
}

interface _SELCHANGE : IDispatch {
  mixin(uuid("79c8ba45-22f9-3a84-99a6-967878cc080b"));
}

interface _SENDASYNCPROC : IDispatch {
  mixin(uuid("f375c4c5-f894-36fe-9f92-566e34dc642e"));
}

interface _SERIALKEYS : IDispatch {
  mixin(uuid("f268c58d-b2a7-3c4a-a3c6-0b6f158f1604"));
}

interface _Shell32 : IDispatch {
  mixin(uuid("32d9077b-50f4-3588-b042-8dc414bc911b"));
}

interface _SHELLEXECUTEINFO : IDispatch {
  mixin(uuid("4a65711b-0af4-3087-89a2-5bc030edaca2"));
}

interface _SHFILEINFO : IDispatch {
  mixin(uuid("c72b6b68-9a72-34e9-b5ae-e8bfb926e762"));
}

interface _SHFILEOPSTRUCT : IDispatch {
  mixin(uuid("9fa7c9f5-99f9-314b-b18a-b015d1b18598"));
}

interface _SIZE : IDispatch {
  mixin(uuid("0136423d-ecc6-33ae-976d-f90b4c6a3cc9"));
}

interface _SIZEL : IDispatch {
  mixin(uuid("4677e557-a977-3192-aceb-fc8dd036d02a"));
}

interface _SMALL_RECT : IDispatch {
  mixin(uuid("6f03159f-ae15-3934-a982-cdafd5c70a83"));
}

interface _SOUNDSENTRY : IDispatch {
  mixin(uuid("2eba5f8d-e3e2-386b-a2ab-b3422f13aee0"));
}

interface _Spoolss : IDispatch {
  mixin(uuid("c07e20b0-c273-37f0-8677-0cd73373cbeb"));
}

interface _STARTUPINFO : IDispatch {
  mixin(uuid("c043117b-5dfc-3fca-87ff-05604703476f"));
}

interface _STICKYKEYS : IDispatch {
  mixin(uuid("b3538934-b9cf-3630-ae48-ac9d6bd828b5"));
}

interface _STYLESTRUCT : IDispatch {
  mixin(uuid("e918a56e-f4b9-379c-9884-9bbafaaab4e0"));
}

interface _SYSTEMTIME : IDispatch {
  mixin(uuid("e65da390-7480-38ef-a24b-a0aa63f24f35"));
}

interface _SYSTEMTIMEPAIR : IDispatch {
  mixin(uuid("d9ba7888-41cb-3817-b997-882a4c53dd92"));
}

interface _SYSTEM_INFO : IDispatch {
  mixin(uuid("10207116-707a-3269-a31a-a2906d7f522e"));
}

interface _SYSTEM_POWER_STATUS : IDispatch {
  mixin(uuid("5e95255a-f5ea-3807-beb2-ff455a9106be"));
}

interface _TBADDBITMAP : IDispatch {
  mixin(uuid("94cd5219-d77b-347e-b1ce-841c18e13e4f"));
}

interface _TBBUTTON : IDispatch {
  mixin(uuid("9f6c5597-e7c9-376c-92e3-2c32ab783692"));
}

interface _TBBUTTONINFO : IDispatch {
  mixin(uuid("678c392e-04cd-333c-9d14-5fdb0c1d6c54"));
}

interface _TBBUTTONINFO_T : IDispatch {
  mixin(uuid("4b763854-807a-36eb-a069-28f13f3fa930"));
}

interface _TBREPLACEBITMAP : IDispatch {
  mixin(uuid("bee0639c-62b7-317a-89ca-fd4e81af1353"));
}

interface _TBSAVEPARAMS : IDispatch {
  mixin(uuid("00908321-2ba6-3f39-9947-84dbddf1c9e9"));
}

interface _TCHITTESTINFO : IDispatch {
  mixin(uuid("b7a8a5c4-a59b-3b58-822c-f70085ae3b8c"));
}

interface _TCITEM : IDispatch {
  mixin(uuid("cb5760b2-e7c2-3bdc-aec4-4b2ebf5018e1"));
}

interface _TCITEM_T : IDispatch {
  mixin(uuid("e2706781-5ff4-353e-9461-73d54dfed273"));
}

interface _TC_ITEMHEADER : IDispatch {
  mixin(uuid("40b91764-dfaf-3583-8a60-0d4617191771"));
}

interface _TEXTMETRIC : IDispatch {
  mixin(uuid("90b92c85-f697-364c-a015-f2da5ba83e33"));
}

interface _TEXTRANGE : IDispatch {
  mixin(uuid("f21ec8c5-adf9-3da8-9a92-53760f37e362"));
}

interface _TIMECAPS : IDispatch {
  mixin(uuid("278fb2d3-09a8-3889-88b9-6b51c50c2e84"));
}

interface _TIMEFMT_ENUMPROC : IDispatch {
  mixin(uuid("d788faaa-1628-35a7-a196-91de4bf19a8a"));
}

interface _TIMERPROC : IDispatch {
  mixin(uuid("d4390825-a12a-35f9-84dd-449fc933f7d9"));
}

interface _TIME_ZONE_INFORMATION : IDispatch {
  mixin(uuid("ec8cbb5a-0ac8-39de-805d-85cc9043f429"));
}

interface _TOGGLEKEYS : IDispatch {
  mixin(uuid("da875805-b1a5-3d73-b529-fad0c2592351"));
}

interface _TOOLINFO : IDispatch {
  mixin(uuid("48567a9a-25d3-38c5-93b7-3fc4dada7b66"));
}

interface _TOOLINFO_T : IDispatch {
  mixin(uuid("c82cb542-d04c-349f-aadf-216676b499d9"));
}

interface _TOOLTIPTEXT : IDispatch {
  mixin(uuid("702193da-2460-3d88-9a9b-3f660c571f70"));
}

interface _TPMPARAMS : IDispatch {
  mixin(uuid("54d21684-f012-35e7-a848-314c4f15ca6e"));
}

interface _TRACKMOUSEEVENT : IDispatch {
  mixin(uuid("bd9d4f91-3b05-3e64-8a3c-aedf812ed4d2"));
}

interface _TV_HITTESTINFO : IDispatch {
  mixin(uuid("79109e0c-bc41-35a9-bc8e-01d3bbe2dd04"));
}

interface _TV_INSERTSTRUCT : IDispatch {
  mixin(uuid("152bba6c-dd86-30f6-aaaa-535a511897b6"));
}

interface _TV_INSERTSTRUCT_T : IDispatch {
  mixin(uuid("f2a441a9-63f9-3ab5-a1ed-00e6b1d9843b"));
}

interface _TV_ITEM : IDispatch {
  mixin(uuid("951e28da-36a4-3e77-8f18-5e3ed0d037bf"));
}

interface _TV_ITEM_T : IDispatch {
  mixin(uuid("fd6cd592-7e8e-35cc-b0db-133ccc0ea917"));
}

interface _TV_SORTCB : IDispatch {
  mixin(uuid("d0e2b6ee-c661-312b-af36-5fb90a307989"));
}

interface _UDACCEL : IDispatch {
  mixin(uuid("33c1402d-3578-3358-b4a5-ff52b57f9eea"));
}

interface _User32 : IDispatch {
  mixin(uuid("796a34cd-1e18-30ee-9155-6dc2b5e717fa"));
}

interface _WAVEFORMAT : IDispatch {
  mixin(uuid("c4f770ea-86a1-38b1-a9d5-30243d7fefc5"));
}

interface _WAVEFORMATEX : IDispatch {
  mixin(uuid("06886fbf-80a3-3c9b-af7e-c75e533f50f5"));
}

interface _WAVEHDR : IDispatch {
  mixin(uuid("b0468a47-3f51-3ae4-ac38-f573644590e8"));
}

interface _WAVEINCAPS : IDispatch {
  mixin(uuid("c1467096-6aca-38c1-babf-9c46ee64ba28"));
}

interface _WAVEINPROC : IDispatch {
  mixin(uuid("b7e7727a-4940-39cc-bfd6-afb491bcd37b"));
}

interface _WAVEOUTCAPS : IDispatch {
  mixin(uuid("df06281f-dcb8-3fa8-97d7-2ba9e876560e"));
}

interface _WAVEOUTPROC : IDispatch {
  mixin(uuid("a0fca0c9-2f1e-36b8-8503-3ddb8084b1e2"));
}

interface _Win32Lib : IDispatch {
  mixin(uuid("41f5a8d2-6897-3aba-bf6c-baf9d69dae8b"));
}

interface _WIN32_FILE_ATTRIBUTE_DATA : IDispatch {
  mixin(uuid("13dbf04d-630e-3dbd-958a-fe766d24af72"));
}

interface _WIN32_FIND_DATA : IDispatch {
  mixin(uuid("85263456-88cc-3cbc-b325-29952be6db4a"));
}

interface _WINDOWPLACEMENT : IDispatch {
  mixin(uuid("54faab33-9059-3140-a87b-15d8a919bbaa"));
}

interface _WINDOWPOS : IDispatch {
  mixin(uuid("5e643781-0736-3082-b844-98f70c9d5f71"));
}

interface _Winmm : IDispatch {
  mixin(uuid("5913e554-dddb-3d5a-b606-8464ca3a3432"));
}

interface _WINSTAENUMPROC : IDispatch {
  mixin(uuid("731c3d0d-e6dd-3997-a1ee-9feaf30c5288"));
}

interface _WNDCLASS : IDispatch {
  mixin(uuid("37327b07-31eb-3d87-a8db-9bed1ebc10e8"));
}

interface _WNDCLASSEX : IDispatch {
  mixin(uuid("16fc3e8e-d5fd-377f-acfd-4415da6b31ee"));
}

interface _WNDENUMPROC : IDispatch {
  mixin(uuid("e38de828-9f37-3428-9f9f-2310104fe165"));
}

interface _XFORM : IDispatch {
  mixin(uuid("e30f5aed-7a7b-33f3-88e2-b1a9b0f2d63d"));
}

interface _YIELDPROC : IDispatch {
  mixin(uuid("ad76714e-3217-38a1-acdb-08de07b0c507"));
}

interface _ThrowableWrapper : IDispatch {
  mixin(uuid("2b79572c-b979-3c22-beaf-034eb3423fc5"));
}

interface _ArchiveClassData : IDispatch {
  mixin(uuid("087d08bf-220a-37a5-bf4b-7645ad21ea4d"));
}

interface _Debug : IDispatch {
  mixin(uuid("b377761c-42fb-397a-8160-41d4260728c5"));
}

interface _DataTruncation : IDispatch {
  mixin(uuid("c68ce7d4-6f02-3c90-9b34-276c1eaf2c0c"));
}

interface _java_sql_Date : IDispatch {
  mixin(uuid("c64bedf3-07c9-3a48-bb90-0a4f4d8202ed"));
}

interface _DriverManager : IDispatch {
  mixin(uuid("18a62093-6b3f-39d7-b457-ac4c5fe5790d"));
}

interface _DriverPropertyInfo : IDispatch {
  mixin(uuid("50ebc8dd-d1b8-3eb0-9af7-222568979ae9"));
}

interface _SQLException : IDispatch {
  mixin(uuid("2a5f8fb9-77cc-3690-9e4f-d12bb6724fff"));
}

interface _SQLWarning : IDispatch {
  mixin(uuid("9dae5a64-c4cd-3c44-bcc4-c4f8838b0f37"));
}

interface _Time : IDispatch {
  mixin(uuid("d9921a45-752e-3b11-b9ed-195fb6edf6eb"));
}

interface _Timestamp : IDispatch {
  mixin(uuid("d56aca16-3940-34a9-8a1a-40feac6e8f3c"));
}

interface _Types : IDispatch {
  mixin(uuid("2730637c-4d8a-3528-bcb7-f686d77349c4"));
}

interface _JdbcOdbcCallableStatement : IDispatch {
  mixin(uuid("ca072a77-06d6-3f13-a474-a7a2f736d0d9"));
}

interface _JdbcOdbcConnection : IDispatch {
  mixin(uuid("86e1e826-2bee-3740-b6b7-6b9f28148e05"));
}

interface _JdbcOdbcDatabaseMetaData : IDispatch {
  mixin(uuid("6f8ed984-11a6-3a9b-a53f-b8d1e4f68ddc"));
}

interface _JdbcOdbcDriver : IDispatch {
  mixin(uuid("9f9f6c94-5c6d-3c1b-bd0d-451a6f4cc408"));
}

interface _JdbcOdbcInputStream : IDispatch {
  mixin(uuid("091642f7-fd75-3156-9031-3ddef48f12fc"));
}

interface _JdbcOdbcPreparedStatement : IDispatch {
  mixin(uuid("43ee8683-fa85-32c6-a01c-5ae3f28383dc"));
}

interface _JdbcOdbcResultSet : IDispatch {
  mixin(uuid("a673023b-98ba-3b15-bd90-465dff2fc71a"));
}

interface _JdbcOdbcResultSetMetadata : IDispatch {
  mixin(uuid("320da227-a096-3544-8217-995a1e8cc534"));
}

interface _JdbcOdbcStatement : IDispatch {
  mixin(uuid("f1be3bdf-4bd3-3e83-b026-62b69bc23793"));
}

interface _JdbcOdbcWarningHelper : IDispatch {
  mixin(uuid("3b387639-a26e-3062-a676-28b0cdaf41ca"));
}

interface _DigestException : IDispatch {
  mixin(uuid("de656b7b-d812-38b2-a836-83414bcc2400"));
}

interface _DigestInputStream : IDispatch {
  mixin(uuid("2eb30b14-e31f-3046-b564-a7d3abd154a2"));
}

interface _DigestOutputStream : IDispatch {
  mixin(uuid("ab3c69ac-b3f4-3620-85df-a6703bc402e9"));
}

interface _Identity : IDispatch {
  mixin(uuid("2148ea2b-3db4-3402-acee-3cf295449bc4"));
}

interface _IdentityScope : IDispatch {
  mixin(uuid("5dc7ff21-b5ea-3f5f-9e7c-141c354144a3"));
}

interface _InvalidKeyException : IDispatch {
  mixin(uuid("8c855cfd-3a72-3ad5-be4d-ebed0c5ae7ef"));
}

interface _InvalidParameterException : IDispatch {
  mixin(uuid("f1e3f757-eb67-3c50-b68e-daa5afb62f37"));
}

interface _KeyException : IDispatch {
  mixin(uuid("84a481d0-4968-3b66-82b8-c86febd1546c"));
}

interface _KeyManagementException : IDispatch {
  mixin(uuid("6d51af7a-421c-34fc-8acc-c6b18bf0193d"));
}

interface _KeyPair : IDispatch {
  mixin(uuid("a0c5d59b-df6b-3268-83d4-6d14a86c5044"));
}

interface _KeyPairGenerator : IDispatch {
  mixin(uuid("f4442cd0-acd5-3bfa-a84b-db3ed410eff8"));
}

interface _MessageDigest : IDispatch {
  mixin(uuid("262c434b-41f8-37c7-b1c7-e53ba1a82090"));
}

interface _NoSuchAlgorithmException : IDispatch {
  mixin(uuid("f8e4a9b2-6f81-398f-93e8-45c52315c241"));
}

interface _NoSuchProviderException : IDispatch {
  mixin(uuid("9042fdf8-29bc-3655-9b01-df6482d5f65a"));
}

interface _Provider : IDispatch {
  mixin(uuid("dea6e9ca-12e0-3f4b-8253-c5437b2d9f40"));
}

interface _ProviderException : IDispatch {
  mixin(uuid("19eb717a-6447-3450-bb59-64a8dac4f488"));
}

interface _SecureRandom : IDispatch {
  mixin(uuid("7e4c88c8-f597-3d32-b984-7883bd30c4b4"));
}

interface _Security : IDispatch {
  mixin(uuid("6d124257-7bbd-33fa-af0c-4ef6fe59eb5b"));
}

interface _Signature : IDispatch {
  mixin(uuid("b3156d60-772f-37a7-9b39-9391e89b6d46"));
}

interface _SignatureException : IDispatch {
  mixin(uuid("c6165b87-155c-357d-ab54-397f6946877b"));
}

interface _Signer : IDispatch {
  mixin(uuid("f6e2006f-521d-307b-a26d-4c0ddda6c4ad"));
}

interface _AclNotFoundException : IDispatch {
  mixin(uuid("a54cb154-929b-3e11-997e-87035d09d891"));
}

interface _LastOwnerException : IDispatch {
  mixin(uuid("2b47ee5d-4553-39d8-bf21-c220ea86e23f"));
}

interface _NotOwnerException : IDispatch {
  mixin(uuid("73b697e6-a403-3af5-9657-bc57ad98a17e"));
}

interface _CUnknown_NCW : IDispatch {
  mixin(uuid("0b9f9084-40c9-3945-9a54-bdc0d032bd9c"));
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT obj, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int getWrappedObject(out VARIANT pRetVal);
}

interface _CIEnumVariantWrapper_NCW : IDispatch {
  mixin(uuid("b01adcc7-92c0-3d3f-b896-08489546c107"));
  /*[id(0x00000000)]*/ int get_toString(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Equals(VARIANT obj, out short pRetVal);
  /*[id(0x60020002)]*/ int GetHashCode(out int pRetVal);
  /*[id(0x60020003)]*/ int GetType(out _Type pRetVal);
  /*[id(0x60020004)]*/ int next(uint ARG_0, ref VARIANT ARG_1, ref uint ARG_2);
  /*[id(0x60020005)]*/ int skip(uint ARG_0);
  /*[id(0x60020006)]*/ int reset();
  /*[id(0x60020007)]*/ int Clone(out IEnumVARIANT pRetVal);
  /*[id(0x60020008)]*/ int getWrappedObject(out VARIANT pRetVal);
}

interface _Guid_2 : IDispatch {
  mixin(uuid("3310f9ad-a09b-3af5-8e3c-384bb04a903c"));
}

// CoClasses

abstract final class Root {
  mixin(uuid("aa359fb7-b009-3443-add2-24ac690e20c8"));
  mixin Interfaces!(_Root, _Object);
}

abstract final class DllLib {
  mixin(uuid("6bfcd99b-61a1-3061-b66a-e5268caf98c2"));
  mixin Interfaces!(_DllLib, _Object);
}

abstract final class SetComparer {
  mixin(uuid("3154d5c4-c8d8-390d-a291-6d8b3e3b6bb4"));
  mixin Interfaces!(_SetComparer, _Object);
}

abstract final class IncludeExcludeIntRanges {
  mixin(uuid("a4dfe29b-23b6-3e7c-8b33-89642b1a8216"));
  mixin Interfaces!(_IncludeExcludeIntRanges, _Object, SetComparison, ProvideSetComparisonInfo);
}

abstract final class UnsignedIntRanges {
  mixin(uuid("8d2e2de8-2bb3-30dc-91fa-961180ce5551"));
  mixin Interfaces!(_UnsignedIntRanges, _Object, ICloneable, SetComparison);
}

abstract final class IntRanges {
  mixin(uuid("9b9cdc0d-b674-3d6e-bda0-1eb2b1ef4e94"));
  mixin Interfaces!(_IntRanges, _Object, ICloneable, SetComparison);
}

abstract final class WildcardExpression {
  mixin(uuid("6af8eb26-cfb7-305a-8556-f96df9fb2d5b"));
  mixin Interfaces!(_WildcardExpression, _Object, FilenameFilter, ICloneable, SetComparison);
}

abstract final class Queue {
  mixin(uuid("72a5a0fa-53d9-3070-8ab6-f5c17188e782"));
  mixin Interfaces!(_Queue, _Object, Enumeration, ICloneable);
}

abstract final class SystemVersionManager {
  mixin(uuid("802cdd69-d446-3aff-885e-3b30ed3451aa"));
  mixin Interfaces!(_SystemVersionManager, _Object, Runnable);
}

abstract final class Task {
  mixin(uuid("04151f7b-f50f-3f42-ad47-873913b9a5e8"));
  mixin Interfaces!(_Task, _Object);
}

abstract final class ThreadLocalStorage {
  mixin(uuid("48d849b7-31c1-39c0-9544-b675c9dfd441"));
  mixin Interfaces!(_ThreadLocalStorage, _Object);
}

abstract final class MulticastNotSupportedException {
  mixin(uuid("ff2203f8-34e5-3018-a871-9c19e2ef20eb"));
  mixin Interfaces!(_MulticastNotSupportedException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class RegKeyEnumValueByteArray {
  mixin(uuid("86357d52-3c3b-3f0d-9eb6-83de3aca127b"));
  mixin Interfaces!(_RegKeyEnumValueByteArray, _Object);
}

abstract final class RegKeyEnumValueInt {
  mixin(uuid("3ca548a1-da82-3b82-b328-ff03540f57a7"));
  mixin Interfaces!(_RegKeyEnumValueInt, _Object);
}

abstract final class RegKeyEnumValueString {
  mixin(uuid("84abaf0a-08b9-3373-b767-820f3b1c14cd"));
  mixin Interfaces!(_RegKeyEnumValueString, _Object);
}

abstract final class RegKeyException {
  mixin(uuid("5e5d5f93-4035-3e35-b87f-52ca9c822e70"));
  mixin Interfaces!(_RegKeyException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class RegQueryInfo {
  mixin(uuid("bfecefb5-623d-3500-a0ea-595a0b83a6ce"));
  mixin Interfaces!(_RegQueryInfo, _Object);
}

abstract final class JavaStructMarshalHelper {
  mixin(uuid("15992772-31a7-3e97-9369-ac89927a48f3"));
  mixin Interfaces!(_JavaStructMarshalHelper, _Object);
}

abstract final class SecurityExceptionEx {
  mixin(uuid("661adea4-c39f-36f0-a2ef-5f0ea04ee438"));
  mixin Interfaces!(_SecurityExceptionEx, _Object, ISerializable, _Exception, Serializable);
}

abstract final class com_ms_vjsharp_win32_RECT {
  mixin(uuid("3ef0f983-96c5-3e73-ab50-823fc5170f1a"));
  mixin Interfaces!(_com_ms_vjsharp_win32_RECT, _Object, IJavaStruct);
}

abstract final class Utilities {
  mixin(uuid("ce43515b-24a5-3802-9f34-6427c81bf66a"));
  mixin Interfaces!(_Utilities, _Object);
}

abstract final class MethodNotSupportedException {
  mixin(uuid("92e2a1e6-4085-3f77-845e-a17efc03e20a"));
  mixin Interfaces!(_MethodNotSupportedException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ByteArrayOutputStream {
  mixin(uuid("9a8f79e1-36f2-3c28-a9ce-43acadcdd351"));
  mixin Interfaces!(_ByteArrayOutputStream, _Object);
}

abstract final class CharArrayWriter {
  mixin(uuid("038d46ab-288c-3b43-8a0b-c2a171a4cfe1"));
  mixin Interfaces!(_CharArrayWriter, _Object);
}

abstract final class CharConversionException {
  mixin(uuid("9efb339e-cdb5-3ec3-918f-adde5f071b9a"));
  mixin Interfaces!(_CharConversionException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class EOFException {
  mixin(uuid("4a0d0768-7f74-37f4-bf8a-d2fb5bec55b0"));
  mixin Interfaces!(_EOFException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class FileDescriptor {
  mixin(uuid("332ac105-b152-3f1e-b54c-96b4348bf564"));
  mixin Interfaces!(_FileDescriptor, _Object);
}

abstract final class FileNotFoundException {
  mixin(uuid("735f6832-c3c9-3ca0-ab33-94d24cae6073"));
  mixin Interfaces!(_FileNotFoundException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InterruptedIOException {
  mixin(uuid("fcba27db-818e-3044-823d-21db2ce1642b"));
  mixin Interfaces!(_InterruptedIOException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IOException {
  mixin(uuid("75b4b584-deaf-3b96-a0cf-cd6a405baf40"));
  mixin Interfaces!(_IOException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NotActiveException {
  mixin(uuid("932f6335-6b1e-3a7f-8347-2353badbd519"));
  mixin Interfaces!(_NotActiveException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NotSerializableException {
  mixin(uuid("b6b536fa-0026-3db2-9f7f-40f817715c14"));
  mixin Interfaces!(_NotSerializableException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class PipedInputStream {
  mixin(uuid("04380e1a-d895-393c-ab28-e6330cb39fbb"));
  mixin Interfaces!(_PipedInputStream, _Object);
}

abstract final class PipedOutputStream {
  mixin(uuid("ddf360a6-5c7a-345c-a886-77d7cf53c034"));
  mixin Interfaces!(_PipedOutputStream, _Object);
}

abstract final class PipedReader {
  mixin(uuid("50797b70-4549-3a98-89f5-4b63a9acde7e"));
  mixin Interfaces!(_PipedReader, _Object);
}

abstract final class PipedWriter {
  mixin(uuid("bc2e6ffc-8050-374e-acf1-4ba5a176c429"));
  mixin Interfaces!(_PipedWriter, _Object);
}

abstract final class StreamCorruptedException {
  mixin(uuid("fe3da727-2f75-340a-97e7-04f7892d6cb9"));
  mixin Interfaces!(_StreamCorruptedException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class StringWriter {
  mixin(uuid("af3d52fe-9a0c-3c91-b87e-925156f71ac9"));
  mixin Interfaces!(_StringWriter, _Object);
}

abstract final class UnsupportedEncodingException {
  mixin(uuid("644fb0c1-ec42-36c3-bf59-2902380d509f"));
  mixin Interfaces!(_UnsupportedEncodingException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UTFDataFormatException {
  mixin(uuid("4737ec10-f380-347b-917f-126c5fbdca80"));
  mixin Interfaces!(_UTFDataFormatException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Array {
  mixin(uuid("fbcfe3a5-0109-3416-b7a3-8d30dd286e57"));
  mixin Interfaces!(_Array, _Object);
}

abstract final class InvocationTargetException {
  mixin(uuid("dd009c79-3e19-36f3-9f67-14e3801db457"));
  mixin Interfaces!(_InvocationTargetException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Modifier {
  mixin(uuid("5f288a98-c6aa-3d47-862e-81e0f59710f2"));
  mixin Interfaces!(_Modifier, _Object);
}

abstract final class <CorArrayWrapper> {
  mixin(uuid("4d4f342e-7908-3f02-b5fb-f5a9634e0324"));
  mixin Interfaces!(_<CorArrayWrapper>, _Object);
}

abstract final class BindException {
  mixin(uuid("3a8630cb-2fd7-3864-b188-13e68a767442"));
  mixin Interfaces!(_BindException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ConnectException {
  mixin(uuid("fc2621da-24fc-370b-b274-3fa75e2d1a80"));
  mixin Interfaces!(_ConnectException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class DatagramSocket {
  mixin(uuid("a2d841d5-ddc0-36ae-ad85-ec394fb7b3ea"));
  mixin Interfaces!(_DatagramSocket, _Object);
}

abstract final class MalformedURLException {
  mixin(uuid("431ea379-2453-3271-bcb0-36e083a2becf"));
  mixin Interfaces!(_MalformedURLException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class MulticastSocket {
  mixin(uuid("61a222be-1c12-3ce1-a1ef-1e25e57bbe87"));
  mixin Interfaces!(_MulticastSocket, _Object);
}

abstract final class NoRouteToHostException {
  mixin(uuid("ec9c302e-5472-35a0-9aae-f63b45761a1c"));
  mixin Interfaces!(_NoRouteToHostException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ProtocolException {
  mixin(uuid("65c02c7a-3dd7-3301-a540-8e1d94797150"));
  mixin Interfaces!(_ProtocolException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Socket {
  mixin(uuid("bbddd7b1-3911-3001-8968-a8a457c9ef4a"));
  mixin Interfaces!(_Socket, _Object);
}

abstract final class SocketException {
  mixin(uuid("4a6854e7-df46-3c0f-9d07-9571a4b6001c"));
  mixin Interfaces!(_SocketException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UnknownHostException {
  mixin(uuid("0bd2ea4f-530c-30ef-aa00-da165639d3f4"));
  mixin Interfaces!(_UnknownHostException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UnknownServiceException {
  mixin(uuid("4725b8df-a86a-39b1-a10a-aff9e57e05a7"));
  mixin Interfaces!(_UnknownServiceException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class URLEncoder {
  mixin(uuid("bd876dd4-5d82-3ebe-99be-5a6f7a394539"));
  mixin Interfaces!(_URLEncoder, _Object);
}

abstract final class URLStreamHandlerFactoryImpl {
  mixin(uuid("51811c55-3bb1-3517-849d-c4193a2aa85b"));
  mixin Interfaces!(_URLStreamHandlerFactoryImpl, _Object, URLStreamHandlerFactory);
}

abstract final class CollationElementIterator {
  mixin(uuid("97a94d11-db17-38df-8da9-5184dc1f056d"));
  mixin Interfaces!(_CollationElementIterator, _Object);
}

abstract final class DateFormatSymbols {
  mixin(uuid("a6a8b608-9b9e-3281-ae88-94d835f66a07"));
  mixin Interfaces!(_DateFormatSymbols, _Object, Serializable, ICloneable);
}

abstract final class DecimalFormat {
  mixin(uuid("e24da93e-eb1c-3b83-b3bc-48dae5c4cab8"));
  mixin Interfaces!(_DecimalFormat, _Object, Serializable, ICloneable);
}

abstract final class DecimalFormatSymbols {
  mixin(uuid("7acfbdec-4487-38b0-b65c-6f6febae9dc0"));
  mixin Interfaces!(_DecimalFormatSymbols, _Object, ICloneable, Serializable);
}

abstract final class FormatDefaults {
  mixin(uuid("8aa323ea-d5f1-349d-aa0b-8dbb4361b78a"));
  mixin Interfaces!(_FormatDefaults, _Object);
}

abstract final class SimpleDateFormat {
  mixin(uuid("c1f1b510-3603-3c5c-92d3-1efb186b7084"));
  mixin Interfaces!(_SimpleDateFormat, _Object, Serializable, ICloneable);
}

abstract final class Adler32 {
  mixin(uuid("ff6b0361-40f7-387b-bd18-6d8956b351af"));
  mixin Interfaces!(_Adler32, _Object, Checksum);
}

abstract final class CRC32 {
  mixin(uuid("006d2ad9-43a2-3d11-a161-2199ed5e6a90"));
  mixin Interfaces!(_CRC32, _Object, Checksum);
}

abstract final class DataFormatException {
  mixin(uuid("0ed150f3-69b6-33d7-b576-51e5c5c25d14"));
  mixin Interfaces!(_DataFormatException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Deflater {
  mixin(uuid("ea7bec8b-37ff-3821-880d-ce7370309fa5"));
  mixin Interfaces!(_Deflater, _Object);
}

abstract final class Inflater {
  mixin(uuid("bdf5c1cc-a2d4-31d1-8dd0-c990477d80a0"));
  mixin Interfaces!(_Inflater, _Object);
}

abstract final class ZipException {
  mixin(uuid("f8f91cbf-5838-38bd-bf7f-361fecb9251c"));
  mixin Interfaces!(_ZipException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Wrapper {
  mixin(uuid("4f5a4e7f-ca84-3574-a175-25c24ede8ea2"));
  mixin Interfaces!(_Wrapper, _Object);
}

abstract final class <VerifierFix> {
  mixin(uuid("e2772354-bb8a-3a3d-a8e4-c0a235b93433"));
  mixin Interfaces!(_<VerifierFix>, _Object);
}

abstract final class AbstractMethodError {
  mixin(uuid("f11e851d-f931-3d30-9fe1-651c5280a120"));
  mixin Interfaces!(_AbstractMethodError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ArithmeticException {
  mixin(uuid("8c6cf316-8685-31e3-b3fc-d9fae38fb28b"));
  mixin Interfaces!(_ArithmeticException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ArrayIndexOutOfBoundsException {
  mixin(uuid("fbe6b1ef-8ae7-32bb-a881-fe0ca8c409a3"));
  mixin Interfaces!(_ArrayIndexOutOfBoundsException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ArrayStoreException {
  mixin(uuid("485b5d77-fa45-3177-887f-d4122b2c3256"));
  mixin Interfaces!(_ArrayStoreException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ClassCastException {
  mixin(uuid("95ef2532-8a64-3d4f-b60b-c17bbcf931e2"));
  mixin Interfaces!(_ClassCastException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ClassCircularityError {
  mixin(uuid("0776df2e-506a-3793-ad1a-399a541843b5"));
  mixin Interfaces!(_ClassCircularityError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ClassFormatError {
  mixin(uuid("5a8f4550-c7c0-3f00-b999-bf4f8ecac872"));
  mixin Interfaces!(_ClassFormatError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ClassNotFoundException {
  mixin(uuid("da3982f6-9c20-3a88-827a-8aa2dad7d227"));
  mixin Interfaces!(_ClassNotFoundException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class CloneNotSupportedException {
  mixin(uuid("ad0f2539-d240-36d8-8aaf-0c5185fb5448"));
  mixin Interfaces!(_CloneNotSupportedException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Compiler {
  mixin(uuid("9a84e99e-e8f6-3713-95ae-42217d0de685"));
  mixin Interfaces!(_Compiler, _Object);
}

abstract final class Error {
  mixin(uuid("c5bb40f0-d288-3393-aaa7-24e9cc068157"));
  mixin Interfaces!(_Error, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Exception {
  mixin(uuid("6995f6ca-4920-3a9e-8154-3efa1fa20f72"));
  mixin Interfaces!(_Exception, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ExceptionInInitializerError {
  mixin(uuid("47b21968-a9c3-3446-9cdb-53902adefc10"));
  mixin Interfaces!(_ExceptionInInitializerError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalAccessError {
  mixin(uuid("db2b4a11-ebdf-31fc-81a0-908f4fa48226"));
  mixin Interfaces!(_IllegalAccessError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalAccessException {
  mixin(uuid("96858a84-57b5-3842-a7c4-88220950995a"));
  mixin Interfaces!(_IllegalAccessException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalArgumentException {
  mixin(uuid("3d8d1f8c-17c9-3b7b-91f9-2a49506224c4"));
  mixin Interfaces!(_IllegalArgumentException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalMonitorStateException {
  mixin(uuid("3f33019c-f5be-30ba-9844-439d017015f3"));
  mixin Interfaces!(_IllegalMonitorStateException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalStateException {
  mixin(uuid("a8d67306-2979-380a-a0f6-ef565a95dd86"));
  mixin Interfaces!(_IllegalStateException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IllegalThreadStateException {
  mixin(uuid("0a810df8-ce34-381f-ab5e-3658f9bda303"));
  mixin Interfaces!(_IllegalThreadStateException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IncompatibleClassChangeError {
  mixin(uuid("cee68bc3-fdd6-3a17-a920-b4503432b43b"));
  mixin Interfaces!(_IncompatibleClassChangeError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class IndexOutOfBoundsException {
  mixin(uuid("91a3f327-6545-3ae5-8377-fcc561488085"));
  mixin Interfaces!(_IndexOutOfBoundsException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InstantiationError {
  mixin(uuid("d68cf964-7458-399b-9212-abcb380d7bb5"));
  mixin Interfaces!(_InstantiationError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InstantiationException {
  mixin(uuid("56be5649-460a-3303-8298-b18a13e1d21a"));
  mixin Interfaces!(_InstantiationException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InternalError {
  mixin(uuid("e02cf98f-9c15-3c73-b57d-9bb8e4f207df"));
  mixin Interfaces!(_InternalError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InterruptedException {
  mixin(uuid("1371a53e-4e8a-3c68-af73-17a3ee97d527"));
  mixin Interfaces!(_InterruptedException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class LinkageError {
  mixin(uuid("5720626d-2894-3451-8ace-e7c4f84cd0d5"));
  mixin Interfaces!(_LinkageError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Math {
  mixin(uuid("f812e8a0-7dfe-3bdb-946f-c6d343048231"));
  mixin Interfaces!(_Math, _Object);
}

abstract final class NegativeArraySizeException {
  mixin(uuid("edf62cf8-5eb7-3d8f-b79e-bc40db4ac43b"));
  mixin Interfaces!(_NegativeArraySizeException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoClassDefFoundError {
  mixin(uuid("2c1d707d-4005-3798-8ffe-3f4401d3607e"));
  mixin Interfaces!(_NoClassDefFoundError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchFieldError {
  mixin(uuid("f6667a60-31ee-3f3b-bac5-5262fa152568"));
  mixin Interfaces!(_NoSuchFieldError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchFieldException {
  mixin(uuid("818bb09e-b698-3d2c-b277-830e3d269dd9"));
  mixin Interfaces!(_NoSuchFieldException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchMethodError {
  mixin(uuid("33ac511c-96f3-3274-a5c9-e6a966cc3278"));
  mixin Interfaces!(_NoSuchMethodError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchMethodException {
  mixin(uuid("149f9285-f742-3e1b-a603-42fc9873d6db"));
  mixin Interfaces!(_NoSuchMethodException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NullPointerException {
  mixin(uuid("e5c92498-41a6-31e0-bc70-2a3eb3d51423"));
  mixin Interfaces!(_NullPointerException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NumberFormatException {
  mixin(uuid("8bc5c8ee-761f-374e-b9e1-436189ac79d8"));
  mixin Interfaces!(_NumberFormatException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class StringImpl {
  mixin(uuid("9ad054c7-6c2e-31cc-a297-377f21466263"));
  mixin Interfaces!(_StringImpl, _Object, Serializable);
}

abstract final class OutOfMemoryError {
  mixin(uuid("a0373064-39eb-3118-89cc-0188f9841181"));
  mixin Interfaces!(_OutOfMemoryError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class RuntimeException {
  mixin(uuid("1d7b57b6-161a-3bca-ba18-e470ad64f824"));
  mixin Interfaces!(_RuntimeException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class SecurityException {
  mixin(uuid("21c4959a-d6b9-32c9-aa27-f88c23e9be78"));
  mixin Interfaces!(_SecurityException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class StackOverflowError {
  mixin(uuid("bb784691-bd22-38be-a171-ff33adf9821c"));
  mixin Interfaces!(_StackOverflowError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class StringBuffer {
  mixin(uuid("10e2a591-b2bc-39ff-9c8d-e4c4dc584370"));
  mixin Interfaces!(_StringBuffer, _Object, Serializable);
}

abstract final class StringIndexOutOfBoundsException {
  mixin(uuid("d2368513-0362-3c80-9544-9e2d3d5a718a"));
  mixin Interfaces!(_StringIndexOutOfBoundsException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Thread {
  mixin(uuid("b3a657a5-e4a5-34f9-95e3-301221d67328"));
  mixin Interfaces!(_Thread, _Object, Runnable);
}

abstract final class ThreadDeath {
  mixin(uuid("76c4b1e4-1e0e-384b-bd8a-86d53e88f84e"));
  mixin Interfaces!(_ThreadDeath, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ThreadGroup {
  mixin(uuid("c418b5f1-e85b-35dd-a78d-5577a13b2ee1"));
  mixin Interfaces!(_ThreadGroup, _Object);
}

abstract final class Throwable {
  mixin(uuid("81683224-3197-3fa6-907b-2373fc0a06cd"));
  mixin Interfaces!(_Throwable, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UnknownError {
  mixin(uuid("624e47a3-d604-362e-bd0f-cca5b8cd4fe0"));
  mixin Interfaces!(_UnknownError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UnsatisfiedLinkError {
  mixin(uuid("c0cf90d4-4a35-33d4-85ee-ca5274f89de8"));
  mixin Interfaces!(_UnsatisfiedLinkError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class VerifyError {
  mixin(uuid("4da8a388-a418-3bbf-be56-e772a1134e5f"));
  mixin Interfaces!(_VerifyError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class VirtualMachineError {
  mixin(uuid("3c45ff93-3558-3841-b09c-c11262ff0500"));
  mixin Interfaces!(_VirtualMachineError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class BitSet {
  mixin(uuid("42157f02-360e-3c13-b686-a134a2f377ad"));
  mixin Interfaces!(_BitSet, _Object, ICloneable, Serializable);
}

abstract final class java_util_Date {
  mixin(uuid("00b5c8eb-768b-32a9-9eb6-0615ca922f58"));
  mixin Interfaces!(_java_util_Date, _Object, Serializable, ICloneable, IConvertible, Comparable);
}

abstract final class EmptyStackException {
  mixin(uuid("7c432888-8fc5-31d4-88d2-bf4a8f37502e"));
  mixin Interfaces!(_EmptyStackException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class GregorianCalendar {
  mixin(uuid("a0712b0c-c42d-30c2-871d-0c270c5d773e"));
  mixin Interfaces!(_GregorianCalendar, _Object, Serializable, ICloneable);
}

abstract final class Hashtable {
  mixin(uuid("7bf741ba-adca-3dc6-ab90-b86f6917663a"));
  mixin Interfaces!(_Hashtable, _Object, ICloneable, Map, Serializable);
}

abstract final class NoSuchElementException {
  mixin(uuid("14055d54-ac24-3fa7-acd9-bb552774eb28"));
  mixin Interfaces!(_NoSuchElementException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Observable {
  mixin(uuid("198f24a2-057a-30a0-b1e1-026f834dde18"));
  mixin Interfaces!(_Observable, _Object);
}

abstract final class Properties {
  mixin(uuid("0d70bbf4-82a2-3119-8725-7e2ac7af2f7c"));
  mixin Interfaces!(_Properties, _Object, ICloneable, Map, Serializable);
}

abstract final class Random {
  mixin(uuid("bed7e0cf-be60-3aeb-8ca5-be6f0b4d93d7"));
  mixin Interfaces!(_Random, _Object, Serializable, ISerializable);
}

abstract final class Stack {
  mixin(uuid("7321bdce-2761-3f1b-9144-068deea3b4e2"));
  mixin Interfaces!(_Stack, _Object, Collection, java_util_List, ICloneable, Serializable);
}

abstract final class TooManyListenersException {
  mixin(uuid("31a8fff5-62da-3435-b524-4799a770cdbc"));
  mixin Interfaces!(_TooManyListenersException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Vector {
  mixin(uuid("8d404b35-f016-3d45-a63b-0a24609f885d"));
  mixin Interfaces!(_Vector, _Object, Collection, java_util_List, ICloneable, Serializable);
}

abstract final class LinkedList {
  mixin(uuid("533432eb-1299-3cfe-b02a-87fbf27fb91a"));
  mixin Interfaces!(_LinkedList, _Object, Collection, java_util_List, ICloneable, Serializable);
}

abstract final class ArrayList {
  mixin(uuid("516d8ae0-e17f-3448-a6b0-e59ff9a2fcf3"));
  mixin Interfaces!(_ArrayList, _Object, Collection, java_util_List, ICloneable, Serializable);
}

abstract final class HashSet {
  mixin(uuid("859ef844-1649-3c18-a8bd-25df195b5213"));
  mixin Interfaces!(_HashSet, _Object, Collection, Set, ICloneable, Serializable);
}

abstract final class TreeSet {
  mixin(uuid("53ab5369-c0e0-39a5-bcc6-8b8265ce5cd1"));
  mixin Interfaces!(_TreeSet, _Object, Collection, Set, SortedSet, ICloneable, Serializable);
}

abstract final class HashMap {
  mixin(uuid("7bafc17f-04cc-3969-95f5-2bee64613b34"));
  mixin Interfaces!(_HashMap, _Object, Map, ICloneable, Serializable);
}

abstract final class WeakHashMap {
  mixin(uuid("945b08c6-9481-3ce8-83c8-902a499fe834"));
  mixin Interfaces!(_WeakHashMap, _Object, Map);
}

abstract final class TreeMap {
  mixin(uuid("90fc3b94-8922-34a8-8fea-abf97ad9dff2"));
  mixin Interfaces!(_TreeMap, _Object, Map, SortedMap, ICloneable, Serializable);
}

abstract final class ConcurrentModificationException {
  mixin(uuid("6fed351d-9ac4-3b39-b718-240afa6a73a7"));
  mixin Interfaces!(_ConcurrentModificationException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class UnsupportedOperationException {
  mixin(uuid("5eec7d49-2eaa-3acd-9d80-5dd3d8137151"));
  mixin Interfaces!(_UnsupportedOperationException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Collections {
  mixin(uuid("91e4bb4c-7ee5-3ad8-a504-960734505aff"));
  mixin Interfaces!(_Collections, _Object);
}

abstract final class Arrays {
  mixin(uuid("7b1a48f8-15b8-3120-9660-bb94f27df045"));
  mixin Interfaces!(_Arrays, _Object);
}

abstract final class Applet {
  mixin(uuid("c34c4a5c-95bc-3455-8205-f280a91f791e"));
  mixin Interfaces!(_Applet, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class BorderLayout {
  mixin(uuid("877df44a-5966-33fd-882a-ea2501f2f7a6"));
  mixin Interfaces!(_BorderLayout, _Object, LayoutManager2, LayoutManager, Serializable);
}

abstract final class Button {
  mixin(uuid("07ced96f-141a-3cfb-bbfd-39a8dab02109"));
  mixin Interfaces!(_Button, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class Canvas {
  mixin(uuid("54e349b6-9e8a-3395-90fd-06794e59d1c6"));
  mixin Interfaces!(_Canvas, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class CardLayout {
  mixin(uuid("9313a7de-80d3-3d68-9152-ff6d28de006a"));
  mixin Interfaces!(_CardLayout, _Object, LayoutManager2, LayoutManager, Serializable);
}

abstract final class Checkbox {
  mixin(uuid("69a1ebc1-83d4-305c-b21c-bedcb50ba42d"));
  mixin Interfaces!(_Checkbox, _Object, ImageObserver, MenuContainer, Serializable, ItemSelectable);
}

abstract final class CheckboxGroup {
  mixin(uuid("1259cd53-32ff-36b3-bfd8-269ef1772c31"));
  mixin Interfaces!(_CheckboxGroup, _Object, Serializable);
}

abstract final class CheckboxMenuItem {
  mixin(uuid("62ba2b17-6263-39e8-9fb7-faf46d90dc8c"));
  mixin Interfaces!(_CheckboxMenuItem, _Object, Serializable, ItemSelectable);
}

abstract final class Choice {
  mixin(uuid("86df38f2-dd81-311b-b6b5-ba306d5037e6"));
  mixin Interfaces!(_Choice, _Object, ImageObserver, MenuContainer, Serializable, ItemSelectable);
}

abstract final class Dimension {
  mixin(uuid("335a6b33-23b4-3be7-bb59-4023f69dfd8d"));
  mixin Interfaces!(_Dimension, _Object, Serializable);
}

abstract final class EventQueue {
  mixin(uuid("27c599c3-ecf7-39ec-b973-17e968c00789"));
  mixin Interfaces!(_EventQueue, _Object);
}

abstract final class FlowLayout {
  mixin(uuid("f57d9df2-3470-3fc3-99d0-999897d46dbb"));
  mixin Interfaces!(_FlowLayout, _Object, LayoutManager, Serializable);
}

abstract final class Frame {
  mixin(uuid("31e9a0c7-448f-3b67-a131-ec7f3c9d4cf1"));
  mixin Interfaces!(_Frame, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class GridBagConstraints {
  mixin(uuid("67374f3d-f7b3-386d-958c-b36beb8bc267"));
  mixin Interfaces!(_GridBagConstraints, _Object, ICloneable, Serializable);
}

abstract final class GridBagLayout {
  mixin(uuid("2d4d6ec1-d9f8-3f34-916e-f5fabd56ff63"));
  mixin Interfaces!(_GridBagLayout, _Object, LayoutManager2, LayoutManager, Serializable);
}

abstract final class GridLayout {
  mixin(uuid("eca4d293-1dcb-3da2-a417-c59058bbeda6"));
  mixin Interfaces!(_GridLayout, _Object, LayoutManager, Serializable);
}

abstract final class IllegalComponentStateException {
  mixin(uuid("d95f7f42-bd0c-3d78-9e79-96dfd8e00bfc"));
  mixin Interfaces!(_IllegalComponentStateException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ImageFilter {
  mixin(uuid("1cc1e556-3303-3a37-ba81-72d1b50b0413"));
  mixin Interfaces!(_ImageFilter, _Object, ImageConsumer, ICloneable);
}

abstract final class Label {
  mixin(uuid("be0b9a5e-32fc-331f-b922-e202f853b4f1"));
  mixin Interfaces!(_Label, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class java_awt_List {
  mixin(uuid("d5966792-ed44-36d1-9deb-934e88e13377"));
  mixin Interfaces!(_java_awt_List, _Object, ImageObserver, MenuContainer, Serializable, ItemSelectable);
}

abstract final class Menu {
  mixin(uuid("812c322a-ab92-3637-8110-c21fc26e015c"));
  mixin Interfaces!(_Menu, _Object, Serializable, MenuContainer);
}

abstract final class MenuBar {
  mixin(uuid("d6d1fdf3-4134-3e4c-beb8-87b1acc5f547"));
  mixin Interfaces!(_MenuBar, _Object, Serializable, MenuContainer);
}

abstract final class MenuItem {
  mixin(uuid("2bbd9722-ba95-3bd4-917b-38540adb46c9"));
  mixin Interfaces!(_MenuItem, _Object, Serializable);
}

abstract final class Panel {
  mixin(uuid("12bb6ac0-2442-3309-b11c-6dfa049381cf"));
  mixin Interfaces!(_Panel, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class java_awt_Point {
  mixin(uuid("227d8a68-9780-3211-910d-77d3f44363e1"));
  mixin Interfaces!(_java_awt_Point, _Object, Serializable);
}

abstract final class Polygon {
  mixin(uuid("14242634-24bc-3122-89fd-4f6ce9e9988f"));
  mixin Interfaces!(_Polygon, _Object, Serializable, Shape);
}

abstract final class PopupMenu {
  mixin(uuid("18ebbdcd-d076-3612-a700-97243e580ad8"));
  mixin Interfaces!(_PopupMenu, _Object, Serializable, MenuContainer);
}

abstract final class Rectangle {
  mixin(uuid("4e73a3ba-1ddf-3fe9-b0a8-8b2e096c00ce"));
  mixin Interfaces!(_Rectangle, _Object, Serializable, Shape);
}

abstract final class Scrollbar {
  mixin(uuid("94548e73-faac-3339-8de6-863437279121"));
  mixin Interfaces!(_Scrollbar, _Object, ImageObserver, MenuContainer, Serializable, Adjustable);
}

abstract final class ScrollPane {
  mixin(uuid("6eecefb1-dae4-333b-8680-8aa1d6c9d338"));
  mixin Interfaces!(_ScrollPane, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class TextArea {
  mixin(uuid("a2a86fc1-e8b8-3664-8eb5-e8f2e9cb81ff"));
  mixin Interfaces!(_TextArea, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class TextComponent {
  mixin(uuid("0fc29213-0e05-38e1-87cc-d50c9e618760"));
  mixin Interfaces!(_TextComponent, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class TextField {
  mixin(uuid("ca823e9d-5a1c-32c7-a4df-78d242c089a7"));
  mixin Interfaces!(_TextField, _Object, ImageObserver, MenuContainer, Serializable);
}

abstract final class SwingHelper {
  mixin(uuid("ff3aeee8-361f-3a18-9bbb-f1baf6264cc7"));
  mixin Interfaces!(_SwingHelper, _Object);
}

abstract final class VJSCallbackSwing {
  mixin(uuid("c6bc54aa-4c13-3bba-a3d7-c4b921482e0f"));
  mixin Interfaces!(_VJSCallbackSwing, _Object);
}

abstract final class SystemX {
  mixin(uuid("96c376d5-945a-3fd9-bcd1-ae0cd6425785"));
  mixin Interfaces!(_SystemX, _Object);
}

abstract final class Beans {
  mixin(uuid("5b078a46-fcb5-394a-91e8-bf42e04f1f4b"));
  mixin Interfaces!(_Beans, _Object);
}

abstract final class BooleanEditor {
  mixin(uuid("53bd6858-4233-3721-8f32-7f9b07f1eb94"));
  mixin Interfaces!(_BooleanEditor, _Object, PropertyEditor);
}

abstract final class ByteEditor {
  mixin(uuid("f47feb94-41b7-3f26-9c4a-766a66dab0a6"));
  mixin Interfaces!(_ByteEditor, _Object, PropertyEditor);
}

abstract final class ColorEditor {
  mixin(uuid("7b229ae0-f239-3c53-ae79-30fb15285a04"));
  mixin Interfaces!(_ColorEditor, _Object, ImageObserver, MenuContainer, Serializable, PropertyEditor, TextListener, EventListener, ItemListener);
}

abstract final class DoubleEditor {
  mixin(uuid("bfa6eb82-13fd-3bda-98a0-7dccdb9888e6"));
  mixin Interfaces!(_DoubleEditor, _Object, PropertyEditor);
}

abstract final class FeatureDescriptor {
  mixin(uuid("21888f0a-d27e-33a2-82b8-a3994d98d890"));
  mixin Interfaces!(_FeatureDescriptor, _Object);
}

abstract final class FloatEditor {
  mixin(uuid("fdbaf8d7-cfa4-308b-99a1-a45d265a529c"));
  mixin Interfaces!(_FloatEditor, _Object, PropertyEditor);
}

abstract final class FontEditor {
  mixin(uuid("3c9e051b-ab9e-3f30-9e26-1f57e1852397"));
  mixin Interfaces!(_FontEditor, _Object, ImageObserver, MenuContainer, Serializable, PropertyEditor, ItemListener, EventListener);
}

abstract final class IntEditor {
  mixin(uuid("a117515d-4726-369a-a7ef-518992739c87"));
  mixin Interfaces!(_IntEditor, _Object, PropertyEditor);
}

abstract final class Introspector {
  mixin(uuid("c2312908-80f8-3238-87d9-ba316c4c2069"));
  mixin Interfaces!(_Introspector, _Object);
}

abstract final class LongEditor {
  mixin(uuid("919a8898-146a-320e-93a5-8c91d4e9f338"));
  mixin Interfaces!(_LongEditor, _Object, PropertyEditor);
}

abstract final class ParameterDescriptor {
  mixin(uuid("da926bf3-97da-3aa0-99e7-98f6b00abbf6"));
  mixin Interfaces!(_ParameterDescriptor, _Object);
}

abstract final class PropertyEditorManager {
  mixin(uuid("fc816ecb-990a-32a2-9dc0-6aeb9846855a"));
  mixin Interfaces!(_PropertyEditorManager, _Object);
}

abstract final class PropertyEditorSupport {
  mixin(uuid("e502aff3-da6f-3ba8-b672-81b7eca6a24b"));
  mixin Interfaces!(_PropertyEditorSupport, _Object, PropertyEditor);
}

abstract final class ShortEditor {
  mixin(uuid("4d10bd1a-30f4-346a-835a-dcc5da837c0f"));
  mixin Interfaces!(_ShortEditor, _Object, PropertyEditor);
}

abstract final class SimpleBeanInfo {
  mixin(uuid("3838505a-5462-3828-84cc-9af3cc0c3abf"));
  mixin Interfaces!(_SimpleBeanInfo, _Object, BeanInfo);
}

abstract final class StringEditor {
  mixin(uuid("f1c319a7-616c-3e4b-bce7-acc526920c3a"));
  mixin Interfaces!(_StringEditor, _Object, PropertyEditor);
}

abstract final class Callback {
  mixin(uuid("7ca800da-5289-330a-a611-a9e3cd15ce31"));
  mixin Interfaces!(_Callback, _Object);
}

abstract final class ParameterCountMismatchError {
  mixin(uuid("c28a3243-c379-3c6b-a3c4-07a66aefaa08"));
  mixin Interfaces!(_ParameterCountMismatchError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class SystemThread {
  mixin(uuid("58e66f73-57ef-3a4e-86dc-b207e9697001"));
  mixin Interfaces!(_SystemThread, _Object, Runnable);
}

abstract final class BIND_OPTS {
  mixin(uuid("b28d1a1a-2877-3360-a2a0-5b2bb847c98f"));
  mixin Interfaces!(_BIND_OPTS, _Object, IJavaStruct);
}

abstract final class COAUTHIDENTITY {
  mixin(uuid("9f16f304-b0c6-3785-bccd-e7e97bdbcd42"));
  mixin Interfaces!(_COAUTHIDENTITY, _Object, IJavaStruct);
}

abstract final class COAUTHINFO {
  mixin(uuid("d3fb6521-d62d-3823-9e3b-4653b557cb04"));
  mixin Interfaces!(_COAUTHINFO, _Object, IJavaStruct);
}

abstract final class ComError {
  mixin(uuid("7b595117-2fb9-3c01-9b82-b497f0bf8a92"));
  mixin Interfaces!(_ComError, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ComFailException {
  mixin(uuid("d016f83b-1e5f-35b7-8ab5-403a8d9c187d"));
  mixin Interfaces!(_ComFailException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ComLib {
  mixin(uuid("025b5cb0-e199-3220-ac24-d992a527ad04"));
  mixin Interfaces!(_ComLib, _Object);
}

abstract final class ComSuccessException {
  mixin(uuid("770dfb94-dff4-3ed6-89e8-461170266c2c"));
  mixin Interfaces!(_ComSuccessException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class CONNECTDATA {
  mixin(uuid("02b5e6e7-e1e9-3fee-9233-8d5874f5b17f"));
  mixin Interfaces!(_CONNECTDATA, _Object, IJavaStruct);
}

abstract final class COSERVERINFO {
  mixin(uuid("0417d508-cf81-3ee1-9ffa-2fba006e95d2"));
  mixin Interfaces!(_COSERVERINFO, _Object, IJavaStruct);
}

abstract final class CustomLib {
  mixin(uuid("a5677617-3d83-3c7c-9c8b-ab935404dca5"));
  mixin Interfaces!(_CustomLib, _Object);
}

abstract final class Dispatch {
  mixin(uuid("04e652aa-2a72-34c9-942c-7ea257543f48"));
  mixin Interfaces!(_Dispatch, _Object);
}

abstract final class Guid {
  mixin(uuid("2cd8888a-98ab-387e-ad1f-bffe67931dde"));
  mixin Interfaces!(_Guid_2, _Object);
}

abstract final class MULTI_QI {
  mixin(uuid("2a1e8c44-214d-38bc-8628-691c06544852"));
  mixin Interfaces!(_MULTI_QI, _Object, IJavaStruct);
}

abstract final class RemSNB {
  mixin(uuid("3b4d2f78-c8e5-38b1-be65-226297e9d78a"));
  mixin Interfaces!(_RemSNB, _Object, IJavaStruct);
}

abstract final class STATSTG {
  mixin(uuid("40a000fb-2263-3a5a-88a4-3a6c4607a442"));
  mixin Interfaces!(_STATSTG, _Object, IJavaStruct);
}

abstract final class Variant {
  mixin(uuid("882a585e-e8ad-307a-ae28-446d24fb4a9e"));
  mixin Interfaces!(_Variant, _Object);
}

abstract final class WrongThreadException {
  mixin(uuid("63daba28-d6e2-3cdd-b67f-34b3750daca1"));
  mixin Interfaces!(_WrongThreadException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class _Guid {
  mixin(uuid("5ce73807-039b-3f2d-b88a-e0380124885e"));
  mixin Interfaces!(__Guid, _Object);
}

abstract final class ABC {
  mixin(uuid("0f700ab7-c84a-3e31-bc6d-0bfd7060038b"));
  mixin Interfaces!(_ABC, _Object, IJavaStruct);
}

abstract final class ABCFLOAT {
  mixin(uuid("4ecc8787-926b-3ad3-8903-897e163b5a47"));
  mixin Interfaces!(_ABCFLOAT, _Object, IJavaStruct);
}

abstract final class ACCEL {
  mixin(uuid("6b077746-e415-3c42-9ba1-5eede23ef193"));
  mixin Interfaces!(_ACCEL, _Object, IJavaStruct);
}

abstract final class ACCESSTIMEOUT {
  mixin(uuid("bf857585-864f-3c23-a4cf-f8a774684592"));
  mixin Interfaces!(_ACCESSTIMEOUT, _Object, IJavaStruct);
}

abstract final class Advapi32 {
  mixin(uuid("bf556a31-1fc2-3996-b680-ed65a838750a"));
  mixin Interfaces!(_Advapi32, _Object);
}

abstract final class ANIMATIONINFO {
  mixin(uuid("305fc480-f4ab-3177-b69e-0d698f74a905"));
  mixin Interfaces!(_ANIMATIONINFO, _Object, IJavaStruct);
}

abstract final class APPBARDATA {
  mixin(uuid("cccd7f6d-a44d-30ac-8c1f-01c67d89d08f"));
  mixin Interfaces!(_APPBARDATA, _Object, IJavaStruct);
}

abstract final class AUXCAPS {
  mixin(uuid("a4206ea2-5767-3894-8d31-8e5aa08c49f2"));
  mixin Interfaces!(_AUXCAPS, _Object, IJavaStruct);
}

abstract final class BITMAP {
  mixin(uuid("fa9b0a4c-0bcf-3eb3-ba99-3f1b76f49383"));
  mixin Interfaces!(_BITMAP, _Object, IJavaStruct);
}

abstract final class BITMAPCOREHEADER {
  mixin(uuid("d291162d-177f-3c52-b812-89a16ffc0570"));
  mixin Interfaces!(_BITMAPCOREHEADER, _Object, IJavaStruct);
}

abstract final class BITMAPINFO {
  mixin(uuid("2d54af11-6e91-3f7b-991e-f39df2bda263"));
  mixin Interfaces!(_BITMAPINFO, _Object, IJavaStruct);
}

abstract final class BITMAPINFO256 {
  mixin(uuid("a07f8121-c001-393c-96fa-50fa8db2a1ec"));
  mixin Interfaces!(_BITMAPINFO256, _Object, IJavaStruct);
}

abstract final class BITMAPINFOHEADER {
  mixin(uuid("b2089b89-6c35-35fa-852d-d5ea944111dc"));
  mixin Interfaces!(_BITMAPINFOHEADER, _Object, IJavaStruct);
}

abstract final class BROADCASTSYSMSG {
  mixin(uuid("e4de595a-05d3-3d6a-b852-f721412cdaa2"));
  mixin Interfaces!(_BROADCASTSYSMSG, _Object, IJavaStruct);
}

abstract final class BY_HANDLE_FILE_INFORMATION {
  mixin(uuid("902b6fa6-3d6b-381d-9645-8dc67cdadfe7"));
  mixin Interfaces!(_BY_HANDLE_FILE_INFORMATION, _Object, IJavaStruct);
}

abstract final class CHARFORMAT {
  mixin(uuid("0139cd9e-e471-371a-97ba-bae6ac820b04"));
  mixin Interfaces!(_CHARFORMAT, _Object, IJavaStruct);
}

abstract final class CHARFORMATA {
  mixin(uuid("29164309-629a-3610-b739-281260b207ec"));
  mixin Interfaces!(_CHARFORMATA, _Object, IJavaStruct);
}

abstract final class CHARRANGE {
  mixin(uuid("6251e204-a61b-3c9b-a838-11be63c9be02"));
  mixin Interfaces!(_CHARRANGE, _Object, IJavaStruct);
}

abstract final class CHARSETINFO {
  mixin(uuid("aa99a9da-8a62-37a3-8541-6a49152ca74a"));
  mixin Interfaces!(_CHARSETINFO, _Object, IJavaStruct);
}

abstract final class CHOOSECOLOR {
  mixin(uuid("cfa83175-33f3-327c-a4c0-0981700b5b23"));
  mixin Interfaces!(_CHOOSECOLOR, _Object, IJavaStruct);
}

abstract final class CHOOSEFONT {
  mixin(uuid("6a8fe391-1fc3-3be4-aaf1-a517677d8c03"));
  mixin Interfaces!(_CHOOSEFONT, _Object, IJavaStruct);
}

abstract final class CIEXYZ {
  mixin(uuid("7011d4a5-48f1-3410-bac9-2e7f8e0947d8"));
  mixin Interfaces!(_CIEXYZ, _Object, IJavaStruct);
}

abstract final class CIEXYZTRIPLE {
  mixin(uuid("ac0ba060-6acc-3737-b864-b9f322e9107b"));
  mixin Interfaces!(_CIEXYZTRIPLE, _Object, IJavaStruct);
}

abstract final class CLIENTCREATESTRUCT {
  mixin(uuid("8d5c2e7c-4e62-3463-ae0d-3c12ae5c22f2"));
  mixin Interfaces!(_CLIENTCREATESTRUCT, _Object, IJavaStruct);
}

abstract final class COLORADJUSTMENT {
  mixin(uuid("d7ccdfe7-7540-3818-835a-2fd1ac9623f0"));
  mixin Interfaces!(_COLORADJUSTMENT, _Object, IJavaStruct);
}

abstract final class COLORMAP {
  mixin(uuid("62b41213-9b9c-3161-b777-21d7f0124910"));
  mixin Interfaces!(_COLORMAP, _Object, IJavaStruct);
}

abstract final class COLORSCHEME {
  mixin(uuid("ff3a0280-1128-3fcb-807a-2831dcfd3463"));
  mixin Interfaces!(_COLORSCHEME, _Object, IJavaStruct);
}

abstract final class COMBOBOXEXITEM {
  mixin(uuid("453616df-27f2-3aa3-9bd5-b723ff872209"));
  mixin Interfaces!(_COMBOBOXEXITEM, _Object, IJavaStruct);
}

abstract final class Comctl32 {
  mixin(uuid("3b2f988e-df35-37ed-b3a6-16d805bd5022"));
  mixin Interfaces!(_Comctl32, _Object);
}

abstract final class Comdlg32 {
  mixin(uuid("5fab1218-3949-3241-8b76-1a3b5c6ff36d"));
  mixin Interfaces!(_Comdlg32, _Object);
}

abstract final class COMMTIMEOUTS {
  mixin(uuid("8d3994e3-49d4-3b35-a787-9dab7f951142"));
  mixin Interfaces!(_COMMTIMEOUTS, _Object, IJavaStruct);
}

abstract final class COMPAREITEMSTRUCT {
  mixin(uuid("f6bc435f-6af2-39ab-8b28-702d43625a09"));
  mixin Interfaces!(_COMPAREITEMSTRUCT, _Object, IJavaStruct);
}

abstract final class COMPCOLOR {
  mixin(uuid("3f32d5e5-447f-350a-9bba-df30378a91d9"));
  mixin Interfaces!(_COMPCOLOR, _Object, IJavaStruct);
}

abstract final class COMSTAT {
  mixin(uuid("95067759-34ec-31fd-8f4d-65d1ae92f7bd"));
  mixin Interfaces!(_COMSTAT, _Object, IJavaStruct);
}

abstract final class CONSOLE_CURSOR_INFO {
  mixin(uuid("1541a011-ba87-3fe6-9239-8e0a7dd41a7c"));
  mixin Interfaces!(_CONSOLE_CURSOR_INFO, _Object, IJavaStruct);
}

abstract final class CONSOLE_SCREEN_BUFFER_INFO {
  mixin(uuid("ae9e1368-b6fc-321c-832d-137bccaa9b6a"));
  mixin Interfaces!(_CONSOLE_SCREEN_BUFFER_INFO, _Object, IJavaStruct);
}

abstract final class COORD {
  mixin(uuid("ecf70e23-7066-3168-bc96-be81aa41f12b"));
  mixin Interfaces!(_COORD, _Object, IJavaStruct);
}

abstract final class COPYDATASTRUCT {
  mixin(uuid("ce318641-0d6d-3627-8dc4-4d2c1a682dd7"));
  mixin Interfaces!(_COPYDATASTRUCT, _Object, IJavaStruct);
}

abstract final class CPINFO {
  mixin(uuid("5672f144-3ce0-3667-a7b0-6e5b95544120"));
  mixin Interfaces!(_CPINFO, _Object, IJavaStruct);
}

abstract final class CREATESTRUCT {
  mixin(uuid("7e442a21-c3df-3341-87d0-2a878d27ec36"));
  mixin Interfaces!(_CREATESTRUCT, _Object, IJavaStruct);
}

abstract final class CREATESTRUCT_I {
  mixin(uuid("6e8684cd-738d-3c19-ba78-3674ff201ecd"));
  mixin Interfaces!(_CREATESTRUCT_I, _Object, IJavaStruct);
}

abstract final class CRGB {
  mixin(uuid("a5fc29f1-43df-3502-bbc9-2ccf0ee54952"));
  mixin Interfaces!(_CRGB, _Object, IJavaStruct);
}

abstract final class CURRENCYFMT {
  mixin(uuid("4451270a-fe0d-3ba0-aa55-cfb7ced55fb3"));
  mixin Interfaces!(_CURRENCYFMT, _Object, IJavaStruct);
}

abstract final class CURSORSHAPE {
  mixin(uuid("8bf860bf-6258-300c-8165-cf23c17ebbb2"));
  mixin Interfaces!(_CURSORSHAPE, _Object, IJavaStruct);
}

abstract final class CWPRETSTRUCT {
  mixin(uuid("df5ad7a4-b37f-30d2-8a78-6dcc7a076e1a"));
  mixin Interfaces!(_CWPRETSTRUCT, _Object, IJavaStruct);
}

abstract final class CWPSTRUCT {
  mixin(uuid("f6d35721-9ca4-3682-8e5d-7d7ef5051b68"));
  mixin Interfaces!(_CWPSTRUCT, _Object, IJavaStruct);
}

abstract final class DCB {
  mixin(uuid("7b5fd7df-95cb-385f-9971-13fe59bea15e"));
  mixin Interfaces!(_DCB, _Object, IJavaStruct);
}

abstract final class DELETEITEMSTRUCT {
  mixin(uuid("1c87eac1-6873-3d94-b89c-510fa47f704e"));
  mixin Interfaces!(_DELETEITEMSTRUCT, _Object, IJavaStruct);
}

abstract final class DEVMODE {
  mixin(uuid("92900b91-8570-3416-8354-43282e100518"));
  mixin Interfaces!(_DEVMODE, _Object, IJavaStruct);
}

abstract final class DEVNAMES {
  mixin(uuid("6d0a5682-9317-3a94-9af2-368784bcb3b7"));
  mixin Interfaces!(_DEVNAMES, _Object, IJavaStruct);
}

abstract final class DLGTEMPLATE {
  mixin(uuid("04d1f006-45a0-3dc6-a5b9-7e902e65d7c2"));
  mixin Interfaces!(_DLGTEMPLATE, _Object, IJavaStruct);
}

abstract final class DOCINFO {
  mixin(uuid("06f1b1d0-6226-3630-8f4a-4cda3def5fb0"));
  mixin Interfaces!(_DOCINFO, _Object, IJavaStruct);
}

abstract final class DRAWITEMSTRUCT {
  mixin(uuid("431db551-b714-3390-a0d9-58d0c456aa19"));
  mixin Interfaces!(_DRAWITEMSTRUCT, _Object, IJavaStruct);
}

abstract final class DRAWITEMSTRUCT_X {
  mixin(uuid("83ce78f8-9360-336d-a3ce-c8c63da556fd"));
  mixin Interfaces!(_DRAWITEMSTRUCT_X, _Object, IJavaStruct);
}

abstract final class DRAWTEXTPARAMS {
  mixin(uuid("b2a8e8b5-61c9-35bd-bcde-bc7d31304dc6"));
  mixin Interfaces!(_DRAWTEXTPARAMS, _Object, IJavaStruct);
}

abstract final class DROPSTRUCT {
  mixin(uuid("ed0d8072-dc41-396e-98f8-6f98eded8da6"));
  mixin Interfaces!(_DROPSTRUCT, _Object, IJavaStruct);
}

abstract final class EDITSTREAM {
  mixin(uuid("b7ebd886-d7d2-34a1-a245-cdf3212a1e4b"));
  mixin Interfaces!(_EDITSTREAM, _Object, IJavaStruct);
}

abstract final class ENDROPFILES {
  mixin(uuid("04aa77cd-d52b-38c8-9b8d-25533a2002e1"));
  mixin Interfaces!(_ENDROPFILES, _Object, IJavaStruct);
}

abstract final class ENHMETAHEADER {
  mixin(uuid("72790d70-4c55-3102-852b-662f123936f4"));
  mixin Interfaces!(_ENHMETAHEADER, _Object, IJavaStruct);
}

abstract final class ENPROTECTED {
  mixin(uuid("e63f68fe-f1ce-3548-ba6c-53188768e8e8"));
  mixin Interfaces!(_ENPROTECTED, _Object, IJavaStruct);
}

abstract final class ENUMLOGFONT {
  mixin(uuid("0570f5c0-732a-394f-b556-647cc930d1d1"));
  mixin Interfaces!(_ENUMLOGFONT, _Object, IJavaStruct);
}

abstract final class ENUMLOGFONTEX {
  mixin(uuid("66ddedeb-d662-3569-a445-cee86bcce0a6"));
  mixin Interfaces!(_ENUMLOGFONTEX, _Object, IJavaStruct);
}

abstract final class ENUMLOGFONTEX_X {
  mixin(uuid("65b3ab17-2954-39d9-8e17-24a94115b211"));
  mixin Interfaces!(_ENUMLOGFONTEX_X, _Object, IJavaStruct);
}

abstract final class EVENTMSG {
  mixin(uuid("d01d0a14-bd32-324a-baaa-e8ff852e1dea"));
  mixin Interfaces!(_EVENTMSG, _Object, IJavaStruct);
}

abstract final class EXTLOGFONT {
  mixin(uuid("4ade59f1-bf20-3046-aeec-530ed15dd36d"));
  mixin Interfaces!(_EXTLOGFONT, _Object, IJavaStruct);
}

abstract final class FILETIME {
  mixin(uuid("9971e907-69aa-3464-bd15-59dd22d21a0c"));
  mixin Interfaces!(_FILETIME, _Object, IJavaStruct);
}

abstract final class FILTERKEYS {
  mixin(uuid("3a0608e8-7bbd-3df8-a6a2-4304cb81f2d7"));
  mixin Interfaces!(_FILTERKEYS, _Object, IJavaStruct);
}

abstract final class FINDREPLACE {
  mixin(uuid("7640d601-7667-3804-88e5-59571a363b72"));
  mixin Interfaces!(_FINDREPLACE, _Object, IJavaStruct);
}

abstract final class FINDTEXT {
  mixin(uuid("f6c99ca7-48f1-3706-a92c-a278425c6371"));
  mixin Interfaces!(_FINDTEXT, _Object, IJavaStruct);
}

abstract final class FINDTEXTA {
  mixin(uuid("bdf4870a-fdc2-3537-8116-f134ca937cbc"));
  mixin Interfaces!(_FINDTEXTA, _Object, IJavaStruct);
}

abstract final class FINDTEXTA_EX {
  mixin(uuid("0c1dd67a-e9be-3cb3-9277-c8c912730d99"));
  mixin Interfaces!(_FINDTEXTA_EX, _Object, IJavaStruct);
}

abstract final class FINDTEXTEX {
  mixin(uuid("53958bdd-2672-3ee5-aaaa-5ad29c64d234"));
  mixin Interfaces!(_FINDTEXTEX, _Object, IJavaStruct);
}

abstract final class FINDTEXTEXA {
  mixin(uuid("69f93001-763d-385e-a7c7-b646318d9f58"));
  mixin Interfaces!(_FINDTEXTEXA, _Object, IJavaStruct);
}

abstract final class FIXED {
  mixin(uuid("ccce0bfc-db29-3078-a578-969e1f9d4509"));
  mixin Interfaces!(_FIXED, _Object, IJavaStruct);
}

abstract final class FONTSIGNATURE {
  mixin(uuid("edf8e3ba-468b-3b0d-84bf-f9c83c2b193d"));
  mixin Interfaces!(_FONTSIGNATURE, _Object, IJavaStruct);
}

abstract final class FORMATRANGE {
  mixin(uuid("34c6a55c-2d62-37e4-b01b-ea6c93d42f08"));
  mixin Interfaces!(_FORMATRANGE, _Object, IJavaStruct);
}

abstract final class FORM_INFO_1 {
  mixin(uuid("7f7de4bd-9eeb-3cf6-b12b-c96f7574b029"));
  mixin Interfaces!(_FORM_INFO_1, _Object, IJavaStruct);
}

abstract final class GCP_RESULTS {
  mixin(uuid("7be1650e-a952-3c86-9367-d27b9a9fd390"));
  mixin Interfaces!(_GCP_RESULTS, _Object, IJavaStruct);
}

abstract final class Gdi32 {
  mixin(uuid("ae74b2ac-5a39-3d6e-9a10-3b4eebb1d649"));
  mixin Interfaces!(_Gdi32, _Object);
}

abstract final class GENERIC_MAPPING {
  mixin(uuid("c9afa257-1b4c-3682-9ae2-1e59ac03df4f"));
  mixin Interfaces!(_GENERIC_MAPPING, _Object, IJavaStruct);
}

abstract final class GLYPHMETRICS {
  mixin(uuid("aa019f6d-6fd4-3f66-a92a-e48339e3cdbb"));
  mixin Interfaces!(_GLYPHMETRICS, _Object, IJavaStruct);
}

abstract final class HDITEM {
  mixin(uuid("3dee0045-b378-3a07-b8ee-3b25686f6a89"));
  mixin Interfaces!(_HDITEM, _Object, IJavaStruct);
}

abstract final class HDLAYOUT {
  mixin(uuid("9b58ea22-9dee-3387-9079-b1c922fe77fe"));
  mixin Interfaces!(_HDLAYOUT, _Object, IJavaStruct);
}

abstract final class HELPINFO {
  mixin(uuid("09293cb1-0539-3a62-9a02-3483d18811bc"));
  mixin Interfaces!(_HELPINFO, _Object, IJavaStruct);
}

abstract final class HELPWININFO {
  mixin(uuid("e072c8ef-b76e-335f-8b67-32e48553bc98"));
  mixin Interfaces!(_HELPWININFO, _Object, IJavaStruct);
}

abstract final class HIGHCONTRAST {
  mixin(uuid("2620fcc4-e9fb-3061-8336-3fdd2750278c"));
  mixin Interfaces!(_HIGHCONTRAST, _Object, IJavaStruct);
}

abstract final class HW_PROFILE_INFO {
  mixin(uuid("d1cf5ab8-0860-3048-95d8-70b18d0bd9f9"));
  mixin Interfaces!(_HW_PROFILE_INFO, _Object, IJavaStruct);
}

abstract final class ICONINFO {
  mixin(uuid("1c39f160-ecd3-3f6c-9cd5-20cd78783269"));
  mixin Interfaces!(_ICONINFO, _Object, IJavaStruct);
}

abstract final class ICONMETRICS {
  mixin(uuid("ba09e8b9-62f5-3dab-82d5-9ff9c9845f17"));
  mixin Interfaces!(_ICONMETRICS, _Object, IJavaStruct);
}

abstract final class IMAGEINFO {
  mixin(uuid("1ecc9325-4726-384b-881e-ac2b8f6dab27"));
  mixin Interfaces!(_IMAGEINFO, _Object, IJavaStruct);
}

abstract final class IMAGELISTDRAWPARAMS {
  mixin(uuid("64c27f13-d035-3d57-90ae-75fcc88ce7dd"));
  mixin Interfaces!(_IMAGELISTDRAWPARAMS, _Object, IJavaStruct);
}

abstract final class INITCOMMONCONTROLSEX {
  mixin(uuid("e7470edd-cfb3-3bc5-bcf5-0901868208e6"));
  mixin Interfaces!(_INITCOMMONCONTROLSEX, _Object, IJavaStruct);
}

abstract final class JOB_INFO_1 {
  mixin(uuid("074c589d-b1fd-3a39-8aa0-c4117dbd204f"));
  mixin Interfaces!(_JOB_INFO_1, _Object, IJavaStruct);
}

abstract final class JOB_INFO_2 {
  mixin(uuid("09848d2d-a40f-3ea7-a8e8-03e05cb20639"));
  mixin Interfaces!(_JOB_INFO_2, _Object, IJavaStruct);
}

abstract final class JOB_INFO_3 {
  mixin(uuid("a54b8a88-6d6b-3b43-b95e-9d652aaabfc9"));
  mixin Interfaces!(_JOB_INFO_3, _Object, IJavaStruct);
}

abstract final class JOYCAPS {
  mixin(uuid("61607721-7d36-3b7d-9b81-cdd4a566d5b4"));
  mixin Interfaces!(_JOYCAPS, _Object, IJavaStruct);
}

abstract final class JOYINFO {
  mixin(uuid("284c0a70-39d9-3c9f-9c15-1b4da6209234"));
  mixin Interfaces!(_JOYINFO, _Object, IJavaStruct);
}

abstract final class JOYINFOEX {
  mixin(uuid("bb9749c8-98ab-3ad7-ae7a-b4b3e1ee7660"));
  mixin Interfaces!(_JOYINFOEX, _Object, IJavaStruct);
}

abstract final class Kernel32 {
  mixin(uuid("a53bada6-a50f-37ed-8bc9-d8c90e91829b"));
  mixin Interfaces!(_Kernel32, _Object);
}

abstract final class KERNINGPAIR {
  mixin(uuid("1f8da929-e682-3097-9ae2-170878d4f855"));
  mixin Interfaces!(_KERNINGPAIR, _Object, IJavaStruct);
}

abstract final class LOCALESIGNATURE {
  mixin(uuid("207f15d8-9d76-3136-af6c-dfe37e351c52"));
  mixin Interfaces!(_LOCALESIGNATURE, _Object, IJavaStruct);
}

abstract final class LOGBRUSH {
  mixin(uuid("c0ce3de0-6392-3d75-8512-80f8114d3732"));
  mixin Interfaces!(_LOGBRUSH, _Object, IJavaStruct);
}

abstract final class LOGCOLORSPACE {
  mixin(uuid("493532c5-976c-3b7c-849c-3b9b9a86f752"));
  mixin Interfaces!(_LOGCOLORSPACE, _Object, IJavaStruct);
}

abstract final class LOGFONT {
  mixin(uuid("06bd5bc6-6ced-3946-9295-abe3f7ad3728"));
  mixin Interfaces!(_LOGFONT, _Object, IJavaStruct);
}

abstract final class LOGPALETTE {
  mixin(uuid("bf498be0-26f8-3372-859f-ee60c56be2ec"));
  mixin Interfaces!(_LOGPALETTE, _Object, IJavaStruct);
}

abstract final class LOGPEN {
  mixin(uuid("76d897d0-a1f7-30a4-9caf-d1d1a201495d"));
  mixin Interfaces!(_LOGPEN, _Object, IJavaStruct);
}

abstract final class LUID {
  mixin(uuid("10ef5922-1544-31f9-83b6-ca4c2589a0c1"));
  mixin Interfaces!(_LUID, _Object, IJavaStruct);
}

abstract final class LUID_AND_ATTRIBUTES {
  mixin(uuid("ae1c9520-a58a-39a8-8b3f-7f63615fe568"));
  mixin Interfaces!(_LUID_AND_ATTRIBUTES, _Object, IJavaStruct);
}

abstract final class LVCOLUMN {
  mixin(uuid("aba6f64b-3786-37cb-9f76-010726ccdc76"));
  mixin Interfaces!(_LVCOLUMN, _Object, IJavaStruct);
}

abstract final class LVCOLUMN_T {
  mixin(uuid("7b2fb2b9-3976-366c-a9d0-448d143c7617"));
  mixin Interfaces!(_LVCOLUMN_T, _Object, IJavaStruct);
}

abstract final class LVFINDINFO {
  mixin(uuid("9e814e28-b27a-3b77-b412-d064a7922cf0"));
  mixin Interfaces!(_LVFINDINFO, _Object, IJavaStruct);
}

abstract final class LVHITTESTINFO {
  mixin(uuid("64bfdec6-b43b-30b4-8497-2cad182c8eb5"));
  mixin Interfaces!(_LVHITTESTINFO, _Object, IJavaStruct);
}

abstract final class LVITEM {
  mixin(uuid("fe5a06d0-08f6-37c5-9c21-c24a963d2e23"));
  mixin Interfaces!(_LVITEM, _Object, IJavaStruct);
}

abstract final class LVITEM_T {
  mixin(uuid("bab60143-7675-339c-90d1-ef94458539a0"));
  mixin Interfaces!(_LVITEM_T, _Object, IJavaStruct);
}

abstract final class Lz32 {
  mixin(uuid("6e0634d2-711b-30c2-8b81-dcf3f7fe24f6"));
  mixin Interfaces!(_Lz32, _Object);
}

abstract final class MAT2 {
  mixin(uuid("80b33a3c-9544-3341-bd8c-7fb76e866d35"));
  mixin Interfaces!(_MAT2, _Object, IJavaStruct);
}

abstract final class MCHITTESTINFO {
  mixin(uuid("d9938c0e-857e-3320-8727-d57277729adb"));
  mixin Interfaces!(_MCHITTESTINFO, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_OPEN_PARMS {
  mixin(uuid("49b80e67-f2ff-3234-9f7a-77b70a25796c"));
  mixin Interfaces!(_MCI_ANIM_OPEN_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_PLAY_PARMS {
  mixin(uuid("fa21e149-90b2-3b5f-b19a-d16e1d26d2fe"));
  mixin Interfaces!(_MCI_ANIM_PLAY_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_RECT_PARMS {
  mixin(uuid("cea93478-23e7-3e13-be37-80b2a1b27f08"));
  mixin Interfaces!(_MCI_ANIM_RECT_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_STEP_PARMS {
  mixin(uuid("086c8e27-1fb0-3975-a477-d257011d0ca5"));
  mixin Interfaces!(_MCI_ANIM_STEP_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_UPDATE_PARMS {
  mixin(uuid("8264f36a-0639-3e65-a1e4-bec1d54d57c2"));
  mixin Interfaces!(_MCI_ANIM_UPDATE_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_ANIM_WINDOW_PARMS {
  mixin(uuid("63bd74e5-f780-34d3-97e5-90c864649635"));
  mixin Interfaces!(_MCI_ANIM_WINDOW_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_BREAK_PARMS {
  mixin(uuid("03dd720b-3a2b-3628-8138-39ebbfda50c6"));
  mixin Interfaces!(_MCI_BREAK_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_GENERIC_PARMS {
  mixin(uuid("8214adc1-1670-37ed-ab87-6bfcf8d1ccc6"));
  mixin Interfaces!(_MCI_GENERIC_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_GETDEVCAPS_PARMS {
  mixin(uuid("971994cd-f35c-3937-af7e-5c6859af4f96"));
  mixin Interfaces!(_MCI_GETDEVCAPS_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_INFO_PARMS {
  mixin(uuid("2cff0a2d-356c-351e-bfd6-3e3629398c3b"));
  mixin Interfaces!(_MCI_INFO_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_LOAD_PARMS {
  mixin(uuid("65115593-06f9-3170-938d-8e77794ddb46"));
  mixin Interfaces!(_MCI_LOAD_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OPEN_PARMS {
  mixin(uuid("c1217e33-034d-329c-9b00-2225366e183c"));
  mixin Interfaces!(_MCI_OPEN_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OVLY_LOAD_PARMS {
  mixin(uuid("346435cb-3e9d-38a7-b401-8a0192338298"));
  mixin Interfaces!(_MCI_OVLY_LOAD_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OVLY_OPEN_PARMS {
  mixin(uuid("7b9d08c6-f7ff-3976-b3a1-374f12645c14"));
  mixin Interfaces!(_MCI_OVLY_OPEN_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OVLY_RECT_PARMS {
  mixin(uuid("270886c1-dc65-34c7-9879-d370c818ffa6"));
  mixin Interfaces!(_MCI_OVLY_RECT_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OVLY_SAVE_PARMS {
  mixin(uuid("9623d4e4-6dd7-357c-a778-1d8ca9b973e5"));
  mixin Interfaces!(_MCI_OVLY_SAVE_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_OVLY_WINDOW_PARMS {
  mixin(uuid("0d0324be-2c9e-3d27-8ecf-8ea0f79d0c49"));
  mixin Interfaces!(_MCI_OVLY_WINDOW_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_PLAY_PARMS {
  mixin(uuid("d6103106-93d0-3316-b64c-2f1d197c5612"));
  mixin Interfaces!(_MCI_PLAY_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_RECORD_PARMS {
  mixin(uuid("767953d3-abc8-377a-8ce3-c2f7d55f1985"));
  mixin Interfaces!(_MCI_RECORD_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_SAVE_PARMS {
  mixin(uuid("1942c81a-1d18-399d-a4e7-cd37554a6e85"));
  mixin Interfaces!(_MCI_SAVE_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_SEEK_PARMS {
  mixin(uuid("112291c6-f8ef-378e-b0f0-d4ffd6494397"));
  mixin Interfaces!(_MCI_SEEK_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_SEQ_SET_PARMS {
  mixin(uuid("7c770446-4008-32cb-8b70-99ba25c3dc38"));
  mixin Interfaces!(_MCI_SEQ_SET_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_SET_PARMS {
  mixin(uuid("071e39a5-2891-3fa0-a1c3-f085313f8831"));
  mixin Interfaces!(_MCI_SET_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_STATUS_PARMS {
  mixin(uuid("cf9afaa7-c214-34d8-93ad-90f6060b0f7f"));
  mixin Interfaces!(_MCI_STATUS_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_SYSINFO_PARMS {
  mixin(uuid("f4f85761-1a33-3f30-b91b-fd6cb9881d0a"));
  mixin Interfaces!(_MCI_SYSINFO_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_VD_ESCAPE_PARMS {
  mixin(uuid("1fc490dc-e4f7-3060-b44a-76b000a17e5d"));
  mixin Interfaces!(_MCI_VD_ESCAPE_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_VD_PLAY_PARMS {
  mixin(uuid("4831a843-a7e1-3756-92e5-84841cf1d9bd"));
  mixin Interfaces!(_MCI_VD_PLAY_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_VD_STEP_PARMS {
  mixin(uuid("70c5d54c-eec6-3d0f-948d-3193ccd9fce8"));
  mixin Interfaces!(_MCI_VD_STEP_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_WAVE_DELETE_PARMS {
  mixin(uuid("44ae1b33-4839-3bcd-9155-24787b65fde9"));
  mixin Interfaces!(_MCI_WAVE_DELETE_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_WAVE_OPEN_PARMS {
  mixin(uuid("e2ba275a-d4a6-3941-abec-abd1dc2643f3"));
  mixin Interfaces!(_MCI_WAVE_OPEN_PARMS, _Object, IJavaStruct);
}

abstract final class MCI_WAVE_SET_PARMS {
  mixin(uuid("9188ace9-c680-3ea2-8ec5-8c8e61c7495b"));
  mixin Interfaces!(_MCI_WAVE_SET_PARMS, _Object, IJavaStruct);
}

abstract final class MDICREATESTRUCT {
  mixin(uuid("82bba142-ab3f-3523-bff4-0d1c20263bc1"));
  mixin Interfaces!(_MDICREATESTRUCT, _Object, IJavaStruct);
}

abstract final class MDINEXTMENU {
  mixin(uuid("80001295-04f4-3c48-8bbc-05ebf9f20b07"));
  mixin Interfaces!(_MDINEXTMENU, _Object, IJavaStruct);
}

abstract final class MEASUREITEMSTRUCT {
  mixin(uuid("0b682762-29d4-35a6-902e-8bdcf5db02d1"));
  mixin Interfaces!(_MEASUREITEMSTRUCT, _Object, IJavaStruct);
}

abstract final class MEMORYSTATUS {
  mixin(uuid("91ef9703-0aea-3585-b4ac-1124329fe4e7"));
  mixin Interfaces!(_MEMORYSTATUS, _Object, IJavaStruct);
}

abstract final class MEMORY_BASIC_INFORMATION {
  mixin(uuid("8fcc2ff0-6027-3463-9f1e-b22d52b6a764"));
  mixin Interfaces!(_MEMORY_BASIC_INFORMATION, _Object, IJavaStruct);
}

abstract final class MENUITEMINFO {
  mixin(uuid("b6c67b2c-64f6-3539-a8b3-dfe4904d0b19"));
  mixin Interfaces!(_MENUITEMINFO, _Object, IJavaStruct);
}

abstract final class MENUITEMINFO_T {
  mixin(uuid("ea12d417-103f-338d-86e2-f936c75aefc7"));
  mixin Interfaces!(_MENUITEMINFO_T, _Object, IJavaStruct);
}

abstract final class METAFILEPICT {
  mixin(uuid("110b8269-4801-3bd3-b63c-3d4441cfe09a"));
  mixin Interfaces!(_METAFILEPICT, _Object, IJavaStruct);
}

abstract final class MIDIHDR {
  mixin(uuid("aab9a65d-c604-3a07-bbb6-08789d32b312"));
  mixin Interfaces!(_MIDIHDR, _Object, IJavaStruct);
}

abstract final class MIDIINCAPS {
  mixin(uuid("4feaa89e-0831-32ca-9a11-e23dfde76452"));
  mixin Interfaces!(_MIDIINCAPS, _Object, IJavaStruct);
}

abstract final class MIDIOUTCAPS {
  mixin(uuid("8bff394e-5c0e-3ae8-8903-9c81e05350fd"));
  mixin Interfaces!(_MIDIOUTCAPS, _Object, IJavaStruct);
}

abstract final class MIDIPROPTEMPO {
  mixin(uuid("f43187ec-c2a3-366b-9b35-b7b7e24b1951"));
  mixin Interfaces!(_MIDIPROPTEMPO, _Object, IJavaStruct);
}

abstract final class MIDIPROPTIMEDIV {
  mixin(uuid("9fb392bf-37ac-38bc-8b96-ac2b9d18e731"));
  mixin Interfaces!(_MIDIPROPTIMEDIV, _Object, IJavaStruct);
}

abstract final class MIDISTRMBUFFVER {
  mixin(uuid("3d35c27e-8eb3-32eb-89b9-f8fcfcdba8a6"));
  mixin Interfaces!(_MIDISTRMBUFFVER, _Object, IJavaStruct);
}

abstract final class MINIMIZEDMETRICS {
  mixin(uuid("c0a2611c-6429-31ff-9c7a-1d0f28384c23"));
  mixin Interfaces!(_MINIMIZEDMETRICS, _Object, IJavaStruct);
}

abstract final class MINMAXINFO {
  mixin(uuid("a0c95ecc-5422-34b4-8689-824eda9fce12"));
  mixin Interfaces!(_MINMAXINFO, _Object, IJavaStruct);
}

abstract final class MINMAXINFO_X {
  mixin(uuid("fcc3aba7-8dca-3fc8-a337-067b346aeb66"));
  mixin Interfaces!(_MINMAXINFO_X, _Object, IJavaStruct);
}

abstract final class MIXERCAPS {
  mixin(uuid("31572937-dfa0-32ee-8d8f-749357894bb9"));
  mixin Interfaces!(_MIXERCAPS, _Object, IJavaStruct);
}

abstract final class MIXERCONTROLDETAILS {
  mixin(uuid("c1b52db5-58f2-3399-8f19-6cb0119e5d9a"));
  mixin Interfaces!(_MIXERCONTROLDETAILS, _Object, IJavaStruct);
}

abstract final class MIXERCONTROLDETAILS_BOOLEAN {
  mixin(uuid("671e169e-f994-34cb-bc9a-d4b299f37e99"));
  mixin Interfaces!(_MIXERCONTROLDETAILS_BOOLEAN, _Object, IJavaStruct);
}

abstract final class MIXERCONTROLDETAILS_LISTTEXT {
  mixin(uuid("5e7ef4a7-6772-3bd8-870e-c4f3944ff087"));
  mixin Interfaces!(_MIXERCONTROLDETAILS_LISTTEXT, _Object, IJavaStruct);
}

abstract final class MIXERCONTROLDETAILS_SIGNED {
  mixin(uuid("179d8f7e-c961-35dd-9415-92244b02cecd"));
  mixin Interfaces!(_MIXERCONTROLDETAILS_SIGNED, _Object, IJavaStruct);
}

abstract final class MIXERCONTROLDETAILS_UNSIGNED {
  mixin(uuid("b8f7a968-c49c-34fa-a9bf-c31e2e073144"));
  mixin Interfaces!(_MIXERCONTROLDETAILS_UNSIGNED, _Object, IJavaStruct);
}

abstract final class MIXERLINE {
  mixin(uuid("3edb0dbd-51df-3e66-a108-1c58ce3b14b6"));
  mixin Interfaces!(_MIXERLINE, _Object, IJavaStruct);
}

abstract final class MIXERLINECONTROLS {
  mixin(uuid("dc91bc0d-58d0-3e31-ba09-b3162d41a717"));
  mixin Interfaces!(_MIXERLINECONTROLS, _Object, IJavaStruct);
}

abstract final class MMCKINFO {
  mixin(uuid("a8b39531-95b9-33a2-b177-62888228e0bb"));
  mixin Interfaces!(_MMCKINFO, _Object, IJavaStruct);
}

abstract final class MMIOINFO {
  mixin(uuid("11e5c49f-d73a-31f6-9315-7babfc87d272"));
  mixin Interfaces!(_MMIOINFO, _Object, IJavaStruct);
}

abstract final class MOUSEHOOKSTRUCT {
  mixin(uuid("bdc9af6e-48b3-3411-8a85-b22b66606660"));
  mixin Interfaces!(_MOUSEHOOKSTRUCT, _Object, IJavaStruct);
}

abstract final class MOUSEKEYS {
  mixin(uuid("aea356c0-195b-3529-82d6-5274ae706bdd"));
  mixin Interfaces!(_MOUSEKEYS, _Object, IJavaStruct);
}

abstract final class MSG {
  mixin(uuid("e55ab0b0-60a7-3e72-8ed1-2a4ec93fe1fa"));
  mixin Interfaces!(_MSG, _Object, IJavaStruct);
}

abstract final class MSGBOXPARAMS {
  mixin(uuid("db5b3af8-a119-328d-9b71-99c9b2f54173"));
  mixin Interfaces!(_MSGBOXPARAMS, _Object, IJavaStruct);
}

abstract final class NCCALCSIZE_PARAMS {
  mixin(uuid("d34bef5f-af00-3241-8a50-08845be10d2a"));
  mixin Interfaces!(_NCCALCSIZE_PARAMS, _Object, IJavaStruct);
}

abstract final class NEWTEXTMETRIC {
  mixin(uuid("b75ca500-c4f2-385a-8f7f-70a847ad28d1"));
  mixin Interfaces!(_NEWTEXTMETRIC, _Object, IJavaStruct);
}

abstract final class NEWTEXTMETRICEX {
  mixin(uuid("960d5907-3891-3f5d-bfc4-67380d59eb66"));
  mixin Interfaces!(_NEWTEXTMETRICEX, _Object, IJavaStruct);
}

abstract final class NMCUSTOMDRAW {
  mixin(uuid("7a8da3d7-c569-38ef-8e56-daee43f9b1fc"));
  mixin Interfaces!(_NMCUSTOMDRAW, _Object, IJavaStruct);
}

abstract final class NMDATETIMECHANGE {
  mixin(uuid("a42ea71c-2f39-3f60-ac0d-fa0931fd492b"));
  mixin Interfaces!(_NMDATETIMECHANGE, _Object, IJavaStruct);
}

abstract final class NMDATETIMEFORMAT {
  mixin(uuid("fd3287d2-e7a1-35c2-986c-b1fe9ad45712"));
  mixin Interfaces!(_NMDATETIMEFORMAT, _Object, IJavaStruct);
}

abstract final class NMDATETIMEFORMATQUERY {
  mixin(uuid("f8669080-cbb1-37a8-aa8d-cacdd36a2054"));
  mixin Interfaces!(_NMDATETIMEFORMATQUERY, _Object, IJavaStruct);
}

abstract final class NMDATETIMESTRING {
  mixin(uuid("75377162-1850-303b-9bc1-4f87b7a9fd6e"));
  mixin Interfaces!(_NMDATETIMESTRING, _Object, IJavaStruct);
}

abstract final class NMDATETIMEWMKEYDOWN {
  mixin(uuid("436454ba-4e28-3665-ac8f-e5cc98ce5818"));
  mixin Interfaces!(_NMDATETIMEWMKEYDOWN, _Object, IJavaStruct);
}

abstract final class NMDAYSTATE {
  mixin(uuid("eab4edc5-6a71-377b-9fd6-3ccf9dd297c0"));
  mixin Interfaces!(_NMDAYSTATE, _Object, IJavaStruct);
}

abstract final class NMHDR {
  mixin(uuid("bbb6d958-0240-30e7-a99a-8e588c0fdbb0"));
  mixin Interfaces!(_NMHDR, _Object, IJavaStruct);
}

abstract final class NMHEADER {
  mixin(uuid("801bd55b-c23c-3278-9988-e22b87c19316"));
  mixin Interfaces!(_NMHEADER, _Object, IJavaStruct);
}

abstract final class NMITEMACTIVATE {
  mixin(uuid("2b252d33-e3ec-33c0-8325-34f990d7efd0"));
  mixin Interfaces!(_NMITEMACTIVATE, _Object, IJavaStruct);
}

abstract final class NMLISTVIEW {
  mixin(uuid("7ea60578-4ab1-370d-a97e-b0c6cad7cbe2"));
  mixin Interfaces!(_NMLISTVIEW, _Object, IJavaStruct);
}

abstract final class NMLVCACHEHINT {
  mixin(uuid("1fa4dfe6-edc8-3a3b-8224-7dcc0b0fce9d"));
  mixin Interfaces!(_NMLVCACHEHINT, _Object, IJavaStruct);
}

abstract final class NMLVCUSTOMDRAW {
  mixin(uuid("748a3f51-f756-3bf8-af06-a1be4d6c9bca"));
  mixin Interfaces!(_NMLVCUSTOMDRAW, _Object, IJavaStruct);
}

abstract final class NMLVDISPINFO {
  mixin(uuid("3e5fec1d-f343-3e02-80df-71f16077e9a5"));
  mixin Interfaces!(_NMLVDISPINFO, _Object, IJavaStruct);
}

abstract final class NMLVFINDITEM {
  mixin(uuid("57773ade-0a65-3b89-a8b4-9009c50bdbbe"));
  mixin Interfaces!(_NMLVFINDITEM, _Object, IJavaStruct);
}

abstract final class NMLVKEYDOWN {
  mixin(uuid("81ff1e74-998c-370a-85cd-20ce03d77722"));
  mixin Interfaces!(_NMLVKEYDOWN, _Object, IJavaStruct);
}

abstract final class NMLVODSTATECHANGE {
  mixin(uuid("94ec3d9e-35fd-327f-a6b1-6a452663f4d1"));
  mixin Interfaces!(_NMLVODSTATECHANGE, _Object, IJavaStruct);
}

abstract final class NMRBAUTOSIZE {
  mixin(uuid("ff3631a8-e899-3afa-8f38-8b6a12b6ead8"));
  mixin Interfaces!(_NMRBAUTOSIZE, _Object, IJavaStruct);
}

abstract final class NMREBAR {
  mixin(uuid("17da3907-065c-390c-a603-b9d390a87eb4"));
  mixin Interfaces!(_NMREBAR, _Object, IJavaStruct);
}

abstract final class NMREBARCHILDSIZE {
  mixin(uuid("15a03e0f-700a-3d72-a0fb-11090e2c23dd"));
  mixin Interfaces!(_NMREBARCHILDSIZE, _Object, IJavaStruct);
}

abstract final class NMSELCHANGE {
  mixin(uuid("8fe1b98e-c9db-37b7-8ed9-6299340931ce"));
  mixin Interfaces!(_NMSELCHANGE, _Object, IJavaStruct);
}

abstract final class NMTCKEYDOWN {
  mixin(uuid("a6bd5ee3-47e0-32ac-9b7a-a32d207bec30"));
  mixin Interfaces!(_NMTCKEYDOWN, _Object, IJavaStruct);
}

abstract final class NMTOOLBAR {
  mixin(uuid("ad6b5d28-61f0-3a48-b755-2d79673f9a60"));
  mixin Interfaces!(_NMTOOLBAR, _Object, IJavaStruct);
}

abstract final class NMTREEVIEW {
  mixin(uuid("20e8a1ce-61bd-3481-b6bf-2fd936d57e31"));
  mixin Interfaces!(_NMTREEVIEW, _Object, IJavaStruct);
}

abstract final class NMTREEVIEW_T {
  mixin(uuid("6e3ddc18-8ba0-3013-b9d1-c48aab1f38f8"));
  mixin Interfaces!(_NMTREEVIEW_T, _Object, IJavaStruct);
}

abstract final class NMTVCUSTOMDRAW {
  mixin(uuid("54db2619-e295-3c49-aece-509f58a9f682"));
  mixin Interfaces!(_NMTVCUSTOMDRAW, _Object, IJavaStruct);
}

abstract final class NMTVDISPINFO {
  mixin(uuid("12701fe4-d4c3-3768-aae3-8d3c385eedd3"));
  mixin Interfaces!(_NMTVDISPINFO, _Object, IJavaStruct);
}

abstract final class NMTVDISPINFO_T {
  mixin(uuid("b2750fe7-d110-32b6-a9bd-5b35bac0a3cc"));
  mixin Interfaces!(_NMTVDISPINFO_T, _Object, IJavaStruct);
}

abstract final class NMTVKEYDOWN {
  mixin(uuid("971138d6-3d18-37c4-9af9-95a21704f9e0"));
  mixin Interfaces!(_NMTVKEYDOWN, _Object, IJavaStruct);
}

abstract final class NMUPDOWN {
  mixin(uuid("09257204-f824-39ee-a71f-3767fd26b0a1"));
  mixin Interfaces!(_NMUPDOWN, _Object, IJavaStruct);
}

abstract final class NONCLIENTMETRICS {
  mixin(uuid("10b673b3-7e62-3cc4-8c39-29ff083a643f"));
  mixin Interfaces!(_NONCLIENTMETRICS, _Object, IJavaStruct);
}

abstract final class NOTIFYICONDATA {
  mixin(uuid("fe5639c3-e30c-3751-ad4c-123f240f8698"));
  mixin Interfaces!(_NOTIFYICONDATA, _Object, IJavaStruct);
}

abstract final class NUMBERFMT {
  mixin(uuid("b2b1358d-f306-371b-80f1-7c81add648e5"));
  mixin Interfaces!(_NUMBERFMT, _Object, IJavaStruct);
}

abstract final class OFNOTIFY {
  mixin(uuid("c663f8a7-26c5-381f-94f6-4194e0c47f69"));
  mixin Interfaces!(_OFNOTIFY, _Object, IJavaStruct);
}

abstract final class OFSTRUCT {
  mixin(uuid("fc2ade83-ec9e-3d16-8451-10964a8c2bcf"));
  mixin Interfaces!(_OFSTRUCT, _Object, IJavaStruct);
}

abstract final class Ole32 {
  mixin(uuid("afd3eef1-3134-3aba-a42d-8101df48086f"));
  mixin Interfaces!(_Ole32, _Object);
}

abstract final class OPENFILENAME {
  mixin(uuid("476c1092-3a15-3e03-a4d7-64f2bf2897d2"));
  mixin Interfaces!(_OPENFILENAME, _Object, IJavaStruct);
}

abstract final class OPENFILENAME_I {
  mixin(uuid("7282ae7a-08fd-31ca-93e4-a95163066d3e"));
  mixin Interfaces!(_OPENFILENAME_I, _Object, IJavaStruct);
}

abstract final class OSVERSIONINFO {
  mixin(uuid("cdefba7c-ea62-36a2-ad9b-1c89324804b8"));
  mixin Interfaces!(_OSVERSIONINFO, _Object, IJavaStruct);
}

abstract final class OUTLINETEXTMETRIC {
  mixin(uuid("7d67ab36-ba07-3742-97cf-7d7c84211626"));
  mixin Interfaces!(_OUTLINETEXTMETRIC, _Object, IJavaStruct);
}

abstract final class OVERLAPPED {
  mixin(uuid("980982d3-5e51-3e09-ad26-5f2a8a581c1a"));
  mixin Interfaces!(_OVERLAPPED, _Object, IJavaStruct);
}

abstract final class PAGESETUPDLG {
  mixin(uuid("7fa161f5-ecee-3c0d-944b-248c1d60b77e"));
  mixin Interfaces!(_PAGESETUPDLG, _Object, IJavaStruct);
}

abstract final class PAINTSTRUCT {
  mixin(uuid("35061fda-17a8-32d6-bf1e-2900f80f754e"));
  mixin Interfaces!(_PAINTSTRUCT, _Object, IJavaStruct);
}

abstract final class PALETTEENTRY {
  mixin(uuid("6afffcd4-4141-32b9-a80b-9f5c6f20dec0"));
  mixin Interfaces!(_PALETTEENTRY, _Object, IJavaStruct);
}

abstract final class PANOSE {
  mixin(uuid("8485345d-f610-3cd9-af48-08abf7d953c6"));
  mixin Interfaces!(_PANOSE, _Object, IJavaStruct);
}

abstract final class PARAFORMAT {
  mixin(uuid("b907ebd4-a4cf-33f0-a322-f48269219cc4"));
  mixin Interfaces!(_PARAFORMAT, _Object, IJavaStruct);
}

abstract final class PBRANGE {
  mixin(uuid("d7c85d57-b881-3d96-abd3-9b63b191b7c8"));
  mixin Interfaces!(_PBRANGE, _Object, IJavaStruct);
}

abstract final class PIXELFORMATDESCRIPTOR {
  mixin(uuid("1064eaa3-c192-39cb-9cbc-35fe2367ef8c"));
  mixin Interfaces!(_PIXELFORMATDESCRIPTOR, _Object, IJavaStruct);
}

abstract final class com_ms_win32_POINT {
  mixin(uuid("36fd8644-67bf-3624-9513-a7c82e4ef635"));
  mixin Interfaces!(_com_ms_win32_POINT, _Object, IJavaStruct);
}

abstract final class POLYTEXT {
  mixin(uuid("36600aea-59ee-3378-bb67-c150bfeeea8b"));
  mixin Interfaces!(_POLYTEXT, _Object, IJavaStruct);
}

abstract final class PRINTDLG {
  mixin(uuid("cc06f995-5bec-388a-a3e4-2e48ee915e00"));
  mixin Interfaces!(_PRINTDLG, _Object, IJavaStruct);
}

abstract final class PRINTER_DEFAULTS {
  mixin(uuid("250ed310-2858-360f-babc-fa630408eb47"));
  mixin Interfaces!(_PRINTER_DEFAULTS, _Object, IJavaStruct);
}

abstract final class PRINTER_INFO_1 {
  mixin(uuid("1aa49be5-9c35-3d45-af93-2c627c6701fd"));
  mixin Interfaces!(_PRINTER_INFO_1, _Object);
}

abstract final class PRINTER_INFO_2 {
  mixin(uuid("17717332-676c-3c66-be80-a496228b6264"));
  mixin Interfaces!(_PRINTER_INFO_2, _Object);
}

abstract final class PRINTER_INFO_4 {
  mixin(uuid("d65007a8-1766-3d8e-af65-1915ce775d45"));
  mixin Interfaces!(_PRINTER_INFO_4, _Object);
}

abstract final class PRINTER_INFO_5 {
  mixin(uuid("26037745-ec35-366b-9a47-ba59fa0642d7"));
  mixin Interfaces!(_PRINTER_INFO_5, _Object);
}

abstract final class PRIVILEGE_SET {
  mixin(uuid("ae1e2460-bfca-312a-8115-87e4dae10dac"));
  mixin Interfaces!(_PRIVILEGE_SET, _Object, IJavaStruct);
}

abstract final class PROCESS_INFORMATION {
  mixin(uuid("9389d3d0-09e3-36eb-b99e-c007e2df49b1"));
  mixin Interfaces!(_PROCESS_INFORMATION, _Object, IJavaStruct);
}

abstract final class PUNCTUATION {
  mixin(uuid("5e22545e-c5c9-397c-99b4-40602cefbb00"));
  mixin Interfaces!(_PUNCTUATION, _Object, IJavaStruct);
}

abstract final class RASTERIZER_STATUS {
  mixin(uuid("5ac88060-68bc-353f-93bb-7ea40bfaee42"));
  mixin Interfaces!(_RASTERIZER_STATUS, _Object, IJavaStruct);
}

abstract final class RBHITTESTINFO {
  mixin(uuid("e03901d4-fc25-3bd0-9973-d592f579b2a7"));
  mixin Interfaces!(_RBHITTESTINFO, _Object, IJavaStruct);
}

abstract final class REBARBANDINFO {
  mixin(uuid("cc03bf2e-8611-3f17-abf5-acc4af79619d"));
  mixin Interfaces!(_REBARBANDINFO, _Object, IJavaStruct);
}

abstract final class REBARBANDINFO_IE4 {
  mixin(uuid("a37c15bc-4858-3f85-b460-8e9836e45179"));
  mixin Interfaces!(_REBARBANDINFO_IE4, _Object, IJavaStruct);
}

abstract final class REBARINFO {
  mixin(uuid("378c5730-e4a3-384e-93f9-2cf710795fa1"));
  mixin Interfaces!(_REBARINFO, _Object, IJavaStruct);
}

abstract final class com_ms_win32_RECT {
  mixin(uuid("c8c4ed76-c437-3865-817a-88fb02e82564"));
  mixin Interfaces!(_com_ms_win32_RECT, _Object, IJavaStruct);
}

abstract final class RECTL {
  mixin(uuid("8259fe03-6ebb-316e-a089-fb780e7ee9fd"));
  mixin Interfaces!(_RECTL, _Object, IJavaStruct);
}

abstract final class REPASTESPECIAL {
  mixin(uuid("c47a8124-234a-3b19-9489-bacc2532c689"));
  mixin Interfaces!(_REPASTESPECIAL, _Object, IJavaStruct);
}

abstract final class REQRESIZE {
  mixin(uuid("5bbeb547-de6a-3839-9a12-3b9acf5ba090"));
  mixin Interfaces!(_REQRESIZE, _Object, IJavaStruct);
}

abstract final class RGBQUAD {
  mixin(uuid("9874d2ba-eebf-394d-ab52-211346a489a7"));
  mixin Interfaces!(_RGBQUAD, _Object, IJavaStruct);
}

abstract final class SCROLLINFO {
  mixin(uuid("42d94edd-f0e9-307a-8b7e-7a37222183be"));
  mixin Interfaces!(_SCROLLINFO, _Object, IJavaStruct);
}

abstract final class SECURITY_ATTRIBUTES {
  mixin(uuid("f88aae87-3618-325e-af52-f414cb6e103f"));
  mixin Interfaces!(_SECURITY_ATTRIBUTES, _Object, IJavaStruct);
}

abstract final class SELCHANGE {
  mixin(uuid("d38354a2-34ae-309a-b381-3edd8b6947a1"));
  mixin Interfaces!(_SELCHANGE, _Object, IJavaStruct);
}

abstract final class SERIALKEYS {
  mixin(uuid("2b307e72-d3df-3ae2-8bfe-223ab82eaa23"));
  mixin Interfaces!(_SERIALKEYS, _Object, IJavaStruct);
}

abstract final class Shell32 {
  mixin(uuid("8e3cad5e-0863-3b62-b140-f2921c0ebd2c"));
  mixin Interfaces!(_Shell32, _Object);
}

abstract final class SHELLEXECUTEINFO {
  mixin(uuid("d4b148c9-7037-32c8-90f7-24fb4e9587f3"));
  mixin Interfaces!(_SHELLEXECUTEINFO, _Object, IJavaStruct);
}

abstract final class SHFILEINFO {
  mixin(uuid("7b6a74e5-5cf9-3dc1-9099-f3327c8969ee"));
  mixin Interfaces!(_SHFILEINFO, _Object, IJavaStruct);
}

abstract final class SHFILEOPSTRUCT {
  mixin(uuid("dcd1401d-ad3f-32c6-b4de-232cee8fc7a3"));
  mixin Interfaces!(_SHFILEOPSTRUCT, _Object, IJavaStruct);
}

abstract final class SIZE {
  mixin(uuid("12ea2428-5f86-34be-ac25-7cd44b362043"));
  mixin Interfaces!(_SIZE, _Object, IJavaStruct);
}

abstract final class SIZEL {
  mixin(uuid("a66fd901-425e-322b-806e-c024942a735c"));
  mixin Interfaces!(_SIZEL, _Object, IJavaStruct);
}

abstract final class SMALL_RECT {
  mixin(uuid("2d37fb0d-63e0-3663-9062-c004aad85df8"));
  mixin Interfaces!(_SMALL_RECT, _Object, IJavaStruct);
}

abstract final class SOUNDSENTRY {
  mixin(uuid("ccb8b3ee-5bdc-3bd3-bd3a-75c4bd6d4e4e"));
  mixin Interfaces!(_SOUNDSENTRY, _Object, IJavaStruct);
}

abstract final class Spoolss {
  mixin(uuid("5a7b76f3-9000-392d-a11c-e28fada386f7"));
  mixin Interfaces!(_Spoolss, _Object);
}

abstract final class STARTUPINFO {
  mixin(uuid("40f01abd-9d89-3a2e-ae1a-279cdf1fa675"));
  mixin Interfaces!(_STARTUPINFO, _Object, IJavaStruct);
}

abstract final class STICKYKEYS {
  mixin(uuid("d7a881ca-7815-333c-a813-10026dd05c28"));
  mixin Interfaces!(_STICKYKEYS, _Object, IJavaStruct);
}

abstract final class STYLESTRUCT {
  mixin(uuid("1b0866dc-36ae-3643-9432-547e7416631c"));
  mixin Interfaces!(_STYLESTRUCT, _Object, IJavaStruct);
}

abstract final class SYSTEMTIME {
  mixin(uuid("576bd4f7-cffa-354c-a243-4dacc2a0a25b"));
  mixin Interfaces!(_SYSTEMTIME, _Object, IJavaStruct);
}

abstract final class SYSTEMTIMEPAIR {
  mixin(uuid("926558db-d10d-3ac0-b3b5-2df84705a2ca"));
  mixin Interfaces!(_SYSTEMTIMEPAIR, _Object, IJavaStruct);
}

abstract final class SYSTEM_INFO {
  mixin(uuid("cc1b4135-afa1-3312-9e0c-e7a8f4812ca0"));
  mixin Interfaces!(_SYSTEM_INFO, _Object, IJavaStruct);
}

abstract final class SYSTEM_POWER_STATUS {
  mixin(uuid("69b44e28-babf-3c25-8a8d-7d757f8a2de1"));
  mixin Interfaces!(_SYSTEM_POWER_STATUS, _Object, IJavaStruct);
}

abstract final class TBADDBITMAP {
  mixin(uuid("6bda6b1b-75af-350b-a96a-9e6cac1728d0"));
  mixin Interfaces!(_TBADDBITMAP, _Object, IJavaStruct);
}

abstract final class TBBUTTON {
  mixin(uuid("a9f526f4-645b-32bc-bfcf-f7becaf36ed8"));
  mixin Interfaces!(_TBBUTTON, _Object, IJavaStruct);
}

abstract final class TBBUTTONINFO {
  mixin(uuid("6b0372c8-6bfa-32c0-ae5a-3d7bf4521435"));
  mixin Interfaces!(_TBBUTTONINFO, _Object, IJavaStruct);
}

abstract final class TBBUTTONINFO_T {
  mixin(uuid("5f418df0-e378-328d-a57d-08e919c57843"));
  mixin Interfaces!(_TBBUTTONINFO_T, _Object, IJavaStruct);
}

abstract final class TBREPLACEBITMAP {
  mixin(uuid("c5c550df-94b9-37d5-a4ec-26b904d6a94a"));
  mixin Interfaces!(_TBREPLACEBITMAP, _Object, IJavaStruct);
}

abstract final class TBSAVEPARAMS {
  mixin(uuid("46116086-0705-319f-9950-d627ffd62598"));
  mixin Interfaces!(_TBSAVEPARAMS, _Object, IJavaStruct);
}

abstract final class TCHITTESTINFO {
  mixin(uuid("fc33ab05-1f62-302a-be71-657948ea6b84"));
  mixin Interfaces!(_TCHITTESTINFO, _Object, IJavaStruct);
}

abstract final class TCITEM {
  mixin(uuid("624a1aa2-0724-3de9-8fc9-1248b1551e7c"));
  mixin Interfaces!(_TCITEM, _Object, IJavaStruct);
}

abstract final class TCITEM_T {
  mixin(uuid("7a4fc04f-34fa-3f21-a01d-002a2449ba43"));
  mixin Interfaces!(_TCITEM_T, _Object, IJavaStruct);
}

abstract final class TC_ITEMHEADER {
  mixin(uuid("dd32fdfd-9af1-36bd-81bb-af0f14f4b8af"));
  mixin Interfaces!(_TC_ITEMHEADER, _Object, IJavaStruct);
}

abstract final class TEXTMETRIC {
  mixin(uuid("fbe69825-b9ab-3e21-b5f4-9177efcc011d"));
  mixin Interfaces!(_TEXTMETRIC, _Object, IJavaStruct);
}

abstract final class TEXTRANGE {
  mixin(uuid("466405ed-07e9-3d90-8175-11334030adcb"));
  mixin Interfaces!(_TEXTRANGE, _Object, IJavaStruct);
}

abstract final class TIMECAPS {
  mixin(uuid("84acd21f-3e1e-3bad-a9a4-3853ada82331"));
  mixin Interfaces!(_TIMECAPS, _Object, IJavaStruct);
}

abstract final class TIME_ZONE_INFORMATION {
  mixin(uuid("de2b055e-e463-3a53-b9eb-24ff13966b70"));
  mixin Interfaces!(_TIME_ZONE_INFORMATION, _Object, IJavaStruct);
}

abstract final class TOGGLEKEYS {
  mixin(uuid("e38ab27c-135e-31ff-8dfa-658c2c796ae0"));
  mixin Interfaces!(_TOGGLEKEYS, _Object, IJavaStruct);
}

abstract final class TOOLINFO {
  mixin(uuid("3b79fd80-fee3-3b2d-8c7b-5137e1255d29"));
  mixin Interfaces!(_TOOLINFO, _Object, IJavaStruct);
}

abstract final class TOOLINFO_T {
  mixin(uuid("a8e93355-cfae-39d2-8b36-995064749381"));
  mixin Interfaces!(_TOOLINFO_T, _Object, IJavaStruct);
}

abstract final class TOOLTIPTEXT {
  mixin(uuid("f966f342-9401-342c-a73b-fcc432b49a1e"));
  mixin Interfaces!(_TOOLTIPTEXT, _Object, IJavaStruct);
}

abstract final class TPMPARAMS {
  mixin(uuid("270c32c1-070c-352c-8edb-5c81a41f5581"));
  mixin Interfaces!(_TPMPARAMS, _Object, IJavaStruct);
}

abstract final class TRACKMOUSEEVENT {
  mixin(uuid("caabc975-1089-3790-8b5d-606120776b1b"));
  mixin Interfaces!(_TRACKMOUSEEVENT, _Object, IJavaStruct);
}

abstract final class TV_HITTESTINFO {
  mixin(uuid("96c53407-e9ae-3a47-9607-38886779b49a"));
  mixin Interfaces!(_TV_HITTESTINFO, _Object, IJavaStruct);
}

abstract final class TV_INSERTSTRUCT {
  mixin(uuid("bed4d593-52f9-3ee8-bd2e-673524073231"));
  mixin Interfaces!(_TV_INSERTSTRUCT, _Object, IJavaStruct);
}

abstract final class TV_INSERTSTRUCT_T {
  mixin(uuid("25061180-b220-3a4e-b4ba-45da2ea758f7"));
  mixin Interfaces!(_TV_INSERTSTRUCT_T, _Object, IJavaStruct);
}

abstract final class TV_ITEM {
  mixin(uuid("e6a878b4-e4e3-341b-9b7a-07b5aa37420a"));
  mixin Interfaces!(_TV_ITEM, _Object, IJavaStruct);
}

abstract final class TV_ITEM_T {
  mixin(uuid("8a79d1eb-c032-3e08-9303-f4ee61e7b9c6"));
  mixin Interfaces!(_TV_ITEM_T, _Object, IJavaStruct);
}

abstract final class TV_SORTCB {
  mixin(uuid("3057b243-52fb-3ae9-980c-9a4c4812f5d3"));
  mixin Interfaces!(_TV_SORTCB, _Object, IJavaStruct);
}

abstract final class UDACCEL {
  mixin(uuid("c1225d13-8eab-3f4b-a3c6-a2a5ec27fbe0"));
  mixin Interfaces!(_UDACCEL, _Object, IJavaStruct);
}

abstract final class User32 {
  mixin(uuid("75ce1356-5429-3493-b0b1-48a24238c5da"));
  mixin Interfaces!(_User32, _Object);
}

abstract final class WAVEFORMAT {
  mixin(uuid("64b5ffb0-66fd-363b-9b24-7ef0f12c66d7"));
  mixin Interfaces!(_WAVEFORMAT, _Object, IJavaStruct);
}

abstract final class WAVEFORMATEX {
  mixin(uuid("5bfa258c-ae20-3958-a6e6-6c36905d06a8"));
  mixin Interfaces!(_WAVEFORMATEX, _Object, IJavaStruct);
}

abstract final class WAVEHDR {
  mixin(uuid("fac196c4-ac85-3999-9ccd-1a21e1b00301"));
  mixin Interfaces!(_WAVEHDR, _Object, IJavaStruct);
}

abstract final class WAVEINCAPS {
  mixin(uuid("7b633086-0fcd-3098-9347-62c7449a76b0"));
  mixin Interfaces!(_WAVEINCAPS, _Object, IJavaStruct);
}

abstract final class WAVEOUTCAPS {
  mixin(uuid("2878af91-0ac2-3f3a-81ef-b765e98b938b"));
  mixin Interfaces!(_WAVEOUTCAPS, _Object, IJavaStruct);
}

abstract final class Win32Lib {
  mixin(uuid("131ed0a0-c68b-367d-8fe0-0347bae500bb"));
  mixin Interfaces!(_Win32Lib, _Object);
}

abstract final class WIN32_FILE_ATTRIBUTE_DATA {
  mixin(uuid("7d36e57e-273e-320a-8485-4c0aa396682c"));
  mixin Interfaces!(_WIN32_FILE_ATTRIBUTE_DATA, _Object, IJavaStruct);
}

abstract final class WIN32_FIND_DATA {
  mixin(uuid("d5d0a25b-713f-3889-9bd9-635fa1fa7e97"));
  mixin Interfaces!(_WIN32_FIND_DATA, _Object, IJavaStruct);
}

abstract final class WINDOWPLACEMENT {
  mixin(uuid("b50657df-c443-3109-a8a5-e6202d6022f8"));
  mixin Interfaces!(_WINDOWPLACEMENT, _Object, IJavaStruct);
}

abstract final class WINDOWPOS {
  mixin(uuid("0e1bf886-bbd1-3795-86ff-e5fd6af9fbd7"));
  mixin Interfaces!(_WINDOWPOS, _Object, IJavaStruct);
}

abstract final class Winmm {
  mixin(uuid("9bc0601b-af46-33e5-9926-db8129c57dae"));
  mixin Interfaces!(_Winmm, _Object);
}

abstract final class WNDCLASS {
  mixin(uuid("de4ca077-1de3-3c29-9dc1-5c52452c9582"));
  mixin Interfaces!(_WNDCLASS, _Object, IJavaStruct);
}

abstract final class WNDCLASSEX {
  mixin(uuid("d9b901a3-fb24-3994-a6a0-1abed7867a93"));
  mixin Interfaces!(_WNDCLASSEX, _Object, IJavaStruct);
}

abstract final class XFORM {
  mixin(uuid("49a12a92-7eb3-3fa5-a7fc-6981122123ba"));
  mixin Interfaces!(_XFORM, _Object, IJavaStruct);
}

abstract final class ArchiveClassData {
  mixin(uuid("38d01b2f-a0cb-3190-afd3-aa51897ae9c6"));
  mixin Interfaces!(_ArchiveClassData, _Object);
}

abstract final class Debug {
  mixin(uuid("ee3927bb-6661-3ddd-86ba-25361683a25e"));
  mixin Interfaces!(_Debug, _Object);
}

abstract final class SQLException {
  mixin(uuid("ec628d3a-f722-39fd-8f42-0df630dbc4b4"));
  mixin Interfaces!(_SQLException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class SQLWarning {
  mixin(uuid("17d01229-14e4-3296-8dac-4d59634a3d08"));
  mixin Interfaces!(_SQLWarning, _Object, ISerializable, _Exception, Serializable);
}

abstract final class Types {
  mixin(uuid("e321eb44-8e0b-3497-bc29-188cc978707d"));
  mixin Interfaces!(_Types, _Object);
}

abstract final class JdbcOdbcDriver {
  mixin(uuid("479a4e7d-6b7c-33fd-b9a9-54e9e85b4bb5"));
  mixin Interfaces!(_JdbcOdbcDriver, _Object, Driver);
}

abstract final class DigestException {
  mixin(uuid("d45265e3-ee64-3a59-95b7-5cddafb1af8d"));
  mixin Interfaces!(_DigestException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InvalidKeyException {
  mixin(uuid("ee98d33a-ac87-3677-a07e-9d7f90fb3d8e"));
  mixin Interfaces!(_InvalidKeyException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class InvalidParameterException {
  mixin(uuid("fddeaa8c-199e-3e7c-b736-28fb21f43392"));
  mixin Interfaces!(_InvalidParameterException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class KeyException {
  mixin(uuid("dc6a5076-74b9-3c3b-982a-23151ab70a86"));
  mixin Interfaces!(_KeyException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class KeyManagementException {
  mixin(uuid("0846e31d-5c7f-36e8-b884-98cc935e3afb"));
  mixin Interfaces!(_KeyManagementException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchAlgorithmException {
  mixin(uuid("0f903964-229a-3945-9df9-b9bda1eb16e9"));
  mixin Interfaces!(_NoSuchAlgorithmException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NoSuchProviderException {
  mixin(uuid("7e51da34-705f-3b1a-a2cf-70b923fad73a"));
  mixin Interfaces!(_NoSuchProviderException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class ProviderException {
  mixin(uuid("1babaac3-58c9-3c1d-b2bf-f1d360f00b5f"));
  mixin Interfaces!(_ProviderException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class SecureRandom {
  mixin(uuid("b1fcc672-b7e3-3273-be5f-048cd825771e"));
  mixin Interfaces!(_SecureRandom, _Object, Serializable, ISerializable);
}

abstract final class SignatureException {
  mixin(uuid("5583a128-ea82-35f7-adea-0da6bc7c7f71"));
  mixin Interfaces!(_SignatureException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class AclNotFoundException {
  mixin(uuid("40c000b3-c1d9-303f-8b0a-826e89a72e09"));
  mixin Interfaces!(_AclNotFoundException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class LastOwnerException {
  mixin(uuid("3096d4c2-dcd6-3e82-9dce-c2ab3e6eca42"));
  mixin Interfaces!(_LastOwnerException, _Object, ISerializable, _Exception, Serializable);
}

abstract final class NotOwnerException {
  mixin(uuid("f67f20a8-96c7-37a9-b54e-5f7a15c15f24"));
  mixin Interfaces!(_NotOwnerException, _Object, ISerializable, _Exception, Serializable);
}
