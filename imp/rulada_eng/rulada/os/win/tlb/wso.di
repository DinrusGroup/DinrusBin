// *Converted to D by Vitaly Kulich */
module os.win.tlb.wso;
//WindowSystemObject (WSO) IDL file
//Copyright (C) Veretennikov A. B. 2004
import os.win.com.core;

alias IUnknown *LPUNKNOWN;
alias wchar *BSTR;
//Standard Windows Constants 

//Form Styles (CreateForm)
const WS_CAPTION = 0x00C00000;
const WS_SYSMENU = 0x00080000;
const WS_THICKFRAME = 0x00040000;
const WS_MINIMIZEBOX = 0x00020000;
const WS_MAXIMIZEBOX = 0x00010000;
alias WS_THICKFRAME WS_SIZEBOX;
alias WS_SYSMENU WS_CONTROLBOX;

//Edit Styles (Frame.CreateEdit)
const ES_UPPERCASE = 0x0008;
const ES_LOWERCASE = 0x0010;
const ES_MULTILINE = 0x0004;
const ES_PASSWORD = 0x0020;
const ES_NOHIDESEL = 0x0100;
const ES_READONLY = 0x0800;

//ListBox Styles (Frame.CreateListBox)
const LBS_SORT = 0x0002;
const LBS_MULTIPLESEL = 0x0008;
const LBS_NOINTEGRALHEIGHT = 0x0100;
const LBS_EXTENDEDSEL = 0x0800;

//ComboBox Styles (Frame.CreateComboBox)
const CBS_SIMPLE = 1;
const CBS_DROPDOWN = 2;
const CBS_DROPDOWNLIST = 3;
const CBS_SORT = 0x0100;
const CBS_NOINTEGRALHEIGHT = 0x0400;
const CBS_UPPERCASE = 0x2000;
const CBS_LOWERCASE = 0x4000;

//Progress Bar Styles (Frame.CreateProgressBar)
const PBS_SMOOTH = 0x01;
const PBS_VERTICAL = 0x04;

//Scroll Bar Styles (Frame.CreateScrollBar)
const SBS_HORZ = 0x0000;
const SBS_VERT = 0x0001;

//TabControl Styles (Frame.CreateTabControl)
const TCS_FLATBUTTONS = 0x0008;
const TCS_HOTTRACK = 0x0040;
const TCS_TABS = 0x0000;
const TCS_BUTTONS = 0x0100;
const TCS_SINGLELINE = 0x0000;
const TCS_MULTILINE = 0x0200;
const TCS_RAGGEDRIGHT = 0x0800;

//Header Styles (Frame.CreateHeader)
const HDS_BUTTONS = 0x0002;

//List View Styles (Frame.CreateListView)
const LVS_ICON = 0x0000;
const LVS_REPORT = 0x0001;
const LVS_SMALLICON = 0x0002;
const LVS_LIST = 0x0003;
const LVS_SINGLESEL = 0x0004;
const LVS_SHOWSELALWAYS = 0x0008;
const LVS_NOLABELWRAP = 0x0080;
const LVS_EDITLABELS = 0x0200;
const LVS_OWNERDATA = 0x1000;

//TreeView Styles (Frame.CreateTreeView)
const TVS_HASBUTTONS = 0x0001;
const TVS_HASLINES = 0x0002;
const TVS_LINESATROOT = 0x0004;
const TVS_EDITLABELS = 0x0008;
const TVS_SHOWSELALWAYS = 0x0020;
const TVS_CHECKBOXES = 0x0100;
const TVS_TRACKSELECT = 0x0200;
const TVS_SINGLEEXPAND = 0x0400;
const TVS_FULLROWSELECT = 0x1000;

//UpDown Styles (Frame.CreateUpDown)
const UDS_HORZ = 0x0040;
const UDS_HOTTRACK = 0x0100;

//TrackBar Styles (Frame.CreateTrackBar)
const TBS_VERT = 0x0002;
const TBS_HORZ = 0x0000;
const TBS_TOP = 0x0004;
const TBS_BOTTOM = 0x0000;
const TBS_LEFT = 0x0004;
const TBS_RIGHT = 0x0000;
const TBS_BOTH = 0x0008;
const TBS_NOTICKS = 0x0010;
const TBS_ENABLESELRANGE = 0x0020;

//Animate Styles (Frame.CreateAnimate)
const ACS_CENTER = 0x0001;
const ACS_TRANSPARENT = 0x0002;

//HotKey Rules Flags
const HKCOMB_NONE = 0x0001;
const HKCOMB_S = 0x0002;
const HKCOMB_C = 0x0004;
const HKCOMB_A = 0x0008;
const HKCOMB_SC = 0x0010;
const HKCOMB_SA = 0x0020;
const HKCOMB_CA = 0x0040;
const HKCOMB_SCA = 0x0080;

//DateTimePicker Styles (Frame.CreateDateTimePicker)
const DTS_UPDOWN = 0x0001;
const DTS_SHOWNONE = 0x0002;
const DTS_RIGHTALIGN = 0x0020;

//DateTimePicker Format Styles (Frame.CreateDateTimePicker and DateTimePicker.Style)
const DTS_shortDATEFORMAT = 0x0000;
const DTS_LONGDATEFORMAT = 0x0004;
const DTS_TIMEFORMAT = 0x0009;

//Calendar Styles (Frame.CreateCalendar)
const MCS_MULTISELECT = 0x0002;
const MCS_WEEKNUMBERS = 0x0004;
const MCS_NOTODAYCIRCLE = 0x0008;
const MCS_NOTODAY = 0x0010;

//ReBar Styles (Frame.CreateReBar)

const RBS_AUTOSIZE = 0x2000;
const RBS_VERTICALGRIPPER = 0x4000;
const RBS_DBLCLKTOGGLE = 0x8000;
const RBS_VARHEIGHT = 0x0200;
const RBS_BANDBORDERS = 0x0400;
const RBS_FIXEDORDER = 0x0800;
const CCS_VERT = 0x00000080;

//Form MessageBox Flags (See also MessageBox function /*in*/ Microsoft Platform SDK)
const MB_OK = 0x00000000;
const MB_OKCANCEL = 0x00000001;
const MB_ABORTRETRYIGNORE = 0x00000002;
const MB_YESNOCANCEL = 0x00000003;
const MB_YESNO = 0x00000004;
const MB_RETRYCANCEL = 0x00000005;

//Windows 2000/XP Only
//C     #define MB_CANCELTRYCONTINUE        0x00000006L
//Windows 2000/XP end
const MB_CANCELTRYCONTINUE = 0x00000006;

const MB_ICONHAND = 0x00000010;
const MB_ICONQUESTION = 0x00000020;
const MB_ICONEXCLAMATION = 0x00000030;
const MB_ICONASTERISK = 0x00000040;
const MB_USERICON = 0x00000080;

alias MB_ICONEXCLAMATION MB_ICONWARNING;
alias MB_ICONHAND MB_ICONERROR;
alias MB_ICONASTERISK MB_ICONINFORMATION;
alias MB_ICONHAND MB_ICONSTOP;

const MB_DEFBUTTON1 = 0x00000000;
const MB_DEFBUTTON2 = 0x00000100;
const MB_DEFBUTTON3 = 0x00000200;
const MB_DEFBUTTON4 = 0x00000300;
const MB_APPLMODAL = 0x00000000;
const MB_SYSTEMMODAL = 0x00001000;
const MB_TASKMODAL = 0x00002000;
//C     #define MB_HELP                     0x00004000L 
//Windows 95/98/Me, Windows NT 4.0 end
const MB_HELP = 0x00004000;

const MB_NOFOCUS = 0x00008000;
const MB_SETFOREGROUND = 0x00010000;
const MB_DEFAULT_DESKTOP_ONLY = 0x00020000;
const MB_TOPMOST = 0x00040000;
const MB_RIGHT = 0x00080000;
const MB_RTLREADING = 0x00100000;

//MessageBox Results
const IDOK = 1;
const IDCANCEL = 2;
const IDABORT = 3;
const IDRETRY = 4;
const IDIGNORE = 5;
const IDYES = 6;
const IDNO = 7;
const IDHELP = 9;
const IDTRYAGAIN = 10;
const IDCONTINUE = 11;

//Pen Styles
const PS_SOLID = 0;
const PS_DASH = 1;
const PS_DOT = 2;
const PS_DASHDOT = 3;
const PS_DASHDOTDOT = 4;
const PS_NULL = 5;
const PS_INSIDEFRAME = 6;

//Open and Save Dialog Flags
const OFN_READONLY = 0x00000001;
const OFN_OVERWRITEPROMPT = 0x00000002;
const OFN_HIDEREADONLY = 0x00000004;
const OFN_NOCHANGEDIR = 0x00000008;
const OFN_SHOWHELP = 0x00000010;
const OFN_NOVALIDATE = 0x00000100;
const OFN_ALLOWMULTISELECT = 0x00000200;
const OFN_EXTENSIONDIFFERENT = 0x00000400;
const OFN_PATHMUSTEXIST = 0x00000800;
const OFN_FILEMUSTEXIST = 0x00001000;
const OFN_CREATEPROMPT = 0x00002000;
const OFN_SHAREAWARE = 0x00004000;
const OFN_NOREADONLYRETURN = 0x00008000;
const OFN_NOTESTFILECREATE = 0x00010000;
const OFN_NONETWORKBUTTON = 0x00020000;
const OFN_NOLONGNAMES = 0x00040000;
const OFN_NODEREFERENCELINKS = 0x00100000;
const OFN_LONGNAMES = 0x00200000;
const OFN_ENABLEINCLUDENOTIFY = 0x00400000;
const OFN_ENABLESIZING = 0x00800000;
const OFN_DONTADDTORECENT = 0x02000000;
const OFN_FORCESHOWHIDDEN = 0x10000000;

//Print and PrinterSetup Dialog Flags
const PD_ALLPAGES = 0x00000000;
const PD_SELECTION = 0x00000001;
const PD_PAGENUMS = 0x00000002;
const PD_NOSELECTION = 0x00000004;
const PD_NOPAGENUMS = 0x00000008;
const PD_COLLATE = 0x00000010;
const PD_PRINTTOFILE = 0x00000020;
const PD_PRINTSETUP = 0x00000040;
const PD_NOWARNING = 0x00000080;
const PD_RETURNDC = 0x00000100;
const PD_RETURNIC = 0x00000200;
const PD_RETURNDEFAULT = 0x00000400;
const PD_SHOWHELP = 0x00000800;
const PD_USEDEVMODECOPIES = 0x00040000;
const PD_USEDEVMODECOPIESANDCOLLATE = 0x00040000;
const PD_DISABLEPRINTTOFILE = 0x00080000;
const PD_HIDEPRINTTOFILE = 0x00100000;
const PD_NONETWORKBUTTON = 0x00200000;

//Windows 2000/XP
const PD_CURRENTPAGE = 0x00400000;
const PD_NOCURRENTPAGE = 0x00800000;
const PD_EXCLUSIONFLAGS = 0x01000000;
const PD_USELARGETEMPLATE = 0x10000000;

//PageSetup Dialog flags
const PSD_DEFAULTMINMARGINS = 0x00000000;
const PSD_INWININIINTLMEASURE = 0x00000000;
const PSD_MINMARGINS = 0x00000001;
const PSD_MARGINS = 0x00000002;
const PSD_INTHOUSANDTHSOFINCHES = 0x00000004;
const PSD_INHUNDREDTHSOFMILLIMETERS = 0x00000008;
const PSD_DISABLEMARGINS = 0x00000010;
const PSD_DISABLEPRINTER = 0x00000020;
const PSD_NOWARNING = 0x00000080;
const PSD_DISABLEORIENTATION = 0x00000100;
const PSD_RETURNDEFAULT = 0x00000400;
const PSD_DISABLEPAPER = 0x00000200;
const PSD_SHOWHELP = 0x00000800;
const PSD_NONETWORKBUTTON = 0x00200000;

//Color Dialog Flags
const CC_FULLOPEN = 0x00000002;
const CC_PREVENTFULLOPEN = 0x00000004;
const CC_SHOWHELP = 0x00000008;
const CC_SOLIDCOLOR = 0x00000080;
const CC_ANYCOLOR = 0x00000100;

//SelectFolder Dialog Flags
const BIF_RETURNONLYFSDIRS = 0x0001;
const BIF_DONTGOBELOWDOMAIN = 0x0002;
const BIF_STATUSTEXT = 0x0004;
const BIF_RETURNFSANCESTORS = 0x0008;
const BIF_EDITBOX = 0x0010;                             
const BIF_VALIDATE = 0x0020;
const BIF_USENEWUI =(BIF_NEWDIALOGSTYLE | BIF_EDITBOX);
const BIF_NEWDIALOGSTYLE = 0x0040;
const BIF_BROWSEINCLUDEURLS = 0x0080;
const BIF_UAHINT = 0x0100;
const BIF_NONEWFOLDERBUTTON = 0x0200;
const BIF_NOTRANSLATETARGETS = 0x0400;
const BIF_BROWSEFORCOMPUTER = 0x1000;
const BIF_BROWSEFORPRINTER = 0x2000;
const BIF_BROWSEINCLUDEFILES = 0x4000;
const BIF_SHAREABLE = 0x8000;

//Font Dialog Flags
const CF_SCREENFONTS = 0x00000001;
const CF_BOTH = (CF_SCREENFONTS | CF_PRINTERFONTS);
const CF_PRINTERFONTS = 0x00000002;
const CF_SHOWHELP = 0x00000004;
const CF_USESTYLE = 0x00000080;
const CF_EFFECTS = 0x00000100;
const CF_APPLY = 0x00000200;
const CF_ANSIONLY = 0x00000400;
alias CF_ANSIONLY CF_SCRIPTSONLY;
const CF_NOVECTORFONTS = 0x00000800;
alias CF_NOVECTORFONTS CF_NOOEMFONTS;
const CF_NOSIMULATIONS = 0x00001000;
const CF_FIXEDPITCHONLY = 0x00004000;
const CF_WYSIWYG = 0x00008000;
const CF_FORCEFONTEXIST = 0x00010000;
const CF_SCALABLEONLY = 0x00020000;
const CF_TTONLY = 0x00040000;
const CF_NOFACESEL = 0x00080000;
const CF_NOSTYLESEL = 0x00100000;
const CF_NOSIZESEL = 0x00200000;
const CF_SELECTSCRIPT = 0x00400000;
const CF_NOSCRIPTSEL = 0x00800000;
const CF_NOVERTFONTS = 0x01000000;

//Raster operation codes (Image.CopyMode)
const SRCCOPY = 0x00CC0020;
const SRCPAINT = 0x00EE0086;
const SRCAND = 0x008800C6;
const SRCINVERT = 0x00660046;
const SRCERASE = 0x00440328;
const NOTSRCCOPY = 0x00330008;
const NOTSRCERASE = 0x001100A6;
const MERGECOPY = 0x00C000CA;
const MERGEPAINT = 0x00BB0226;
const PATCOPY = 0x00F00021;
const PATPAINT = 0x00FB0A09;
const PATINVERT = 0x005A0049;
const DSTINVERT = 0x00550009;
const BLACKNESS = 0x00000042;
const WHITENESS = 0x00FF0062;

//Font Charset
const ANSI_CHARSET = 0;
const DEFAULT_CHARSET = 1;
const SYMBOL_CHARSET = 2;
const SHIFTJIS_CHARSET = 128;
const HANGEUL_CHARSET = 129;
const HANGUL_CHARSET = 129;
const GB2312_CHARSET = 134;
const CHINESEBIG5_CHARSET = 136;
const OEM_CHARSET = 255;
const JOHAB_CHARSET = 130;
const HEBREW_CHARSET = 177;
const ARABIC_CHARSET = 178;
const GREEK_CHARSET = 161;
const TURKISH_CHARSET = 162;
const VIETNAMESE_CHARSET = 163;
const THAI_CHARSET = 222;
const EASTEUROPE_CHARSET = 238;
const RUSSIAN_CHARSET = 204;
const MAC_CHARSET = 77;
const BALTIC_CHARSET = 186;

//Font Weights
const FW_DONTCARE = 0;
const FW_THIN = 100;
const FW_EXTRALIGHT = 200;
const FW_LIGHT = 300;
const FW_NORMAL = 400;
const FW_MEDIUM = 500;
const FW_SEMIBOLD = 600;
const FW_BOLD = 700;
const FW_EXTRABOLD = 800;
const FW_HEAVY = 900;
alias FW_EXTRALIGHT FW_ULTRALIGHT;
alias FW_NORMAL FW_REGULAR;
alias FW_SEMIBOLD FW_DEMIBOLD;
alias FW_EXTRABOLD FW_ULTRABOLD;
alias FW_HEAVY FW_BLACK;

//Standard Virtual Keys
const VK_BACK = 0x08;
const VK_TAB = 0x09;
const VK_CLEAR = 0x0C;
const VK_RETURN = 0x0D;
const VK_SHIFT = 0x10;
const VK_CONTROL = 0x11;
const VK_MENU = 0x12;
const VK_PAUSE = 0x13;
const VK_CAPITAL = 0x14;
const VK_KANA = 0x15;
const VK_HANGEUL = 0x15;
const VK_HANGUL = 0x15;
const VK_JUNJA = 0x17;
const VK_FINAL = 0x18;
const VK_HANJA = 0x19;
const VK_KANJI = 0x19;
const VK_ESCAPE = 0x1B;
const VK_CONVERT = 0x1C;
const VK_NONCONVERT = 0x1D;
const VK_ACCEPT = 0x1E;
const VK_MODECHANGE = 0x1F;
const VK_SPACE = 0x20;
const VK_PRIOR = 0x21;
const VK_NEXT = 0x22;
const VK_END = 0x23;
const VK_HOME = 0x24;
const VK_LEFT = 0x25;
const VK_UP = 0x26;
const VK_RIGHT = 0x27;
const VK_DOWN = 0x28;
const VK_SELECT = 0x29;
const VK_PRINT = 0x2A;
const VK_EXECUTE = 0x2B;
const VK_SNAPSHOT = 0x2C;
const VK_INSERT = 0x2D;
const VK_DELETE = 0x2E;
const VK_HELP = 0x2F;
/*
  *VK_0 - VK_9 are the same as ASCII '0' - '9' (0x30 - 0x39)
  *0x40 : unassigned
  *VK_A - VK_Z are the same as ASCII 'A' - 'Z' (0x41 - 0x5A)
 */

const VK_LWIN = 0x5B;
const VK_RWIN = 0x5C;
const VK_APPS = 0x5D;
const VK_SLEEP = 0x5F;
const VK_NUMPAD0 = 0x60;
const VK_NUMPAD1 = 0x61;
const VK_NUMPAD2 = 0x62;
const VK_NUMPAD3 = 0x63;
const VK_NUMPAD4 = 0x64;
const VK_NUMPAD5 = 0x65;
const VK_NUMPAD6 = 0x66;
const VK_NUMPAD7 = 0x67;
const VK_NUMPAD8 = 0x68;
const VK_NUMPAD9 = 0x69;
const VK_MULTIPLY = 0x6A;
const VK_ADD = 0x6B;
const VK_SEPARATOR = 0x6C;
const VK_SUBTRACT = 0x6D;
const VK_DECIMAL = 0x6E;
const VK_DIVIDE = 0x6F;
const VK_F1 = 0x70;
const VK_F2 = 0x71;
const VK_F3 = 0x72;
const VK_F4 = 0x73;
const VK_F5 = 0x74;
const VK_F6 = 0x75;
const VK_F7 = 0x76;
const VK_F8 = 0x77;
const VK_F9 = 0x78;
const VK_F10 = 0x79;
const VK_F11 = 0x7A;
const VK_F12 = 0x7B;
const VK_F13 = 0x7C;
const VK_F14 = 0x7D;
const VK_F15 = 0x7E;
const VK_F16 = 0x7F;
const VK_F17 = 0x80;
const VK_F18 = 0x81;
const VK_F19 = 0x82;
const VK_F20 = 0x83;
const VK_F21 = 0x84;
const VK_F22 = 0x85;
const VK_F23 = 0x86;
const VK_F24 = 0x87;
const VK_NUMLOCK = 0x90;
/*
const VK_SCROLL = 0x91;
  *NEC PC-9800 kbd definitions
 */
const VK_OEM_NEC_EQUAL = 0x92;
/*
  *Fujitsu/OASYS kbd definitions
 */
const VK_OEM_FJ_JISHO = 0x92;
const VK_OEM_FJ_MASSHOU = 0x93;
const VK_OEM_FJ_TOUROKU = 0x94;
const VK_OEM_FJ_LOYA = 0x95;
const VK_OEM_FJ_ROYA = 0x96;
/*
  *VK_L *& VK_R *- left and right Alt, Ctrl and Shift virtual keys.
  *Used only as parameters to GetAsyncKeyState() and GetKeyState().
  *No other API or message will distinguish left and right keys in this way.
 */
const VK_LSHIFT = 0xA0;
const VK_RSHIFT = 0xA1;
const VK_LCONTROL = 0xA2;
const VK_RCONTROL = 0xA3;
const VK_LMENU = 0xA4;
const VK_RMENU = 0xA5;

//Windows 2000/XP and Later
const VK_BROWSER_BACK = 0xA6;
const VK_BROWSER_FORWARD = 0xA7;
const VK_BROWSER_REFRESH = 0xA8;
const VK_BROWSER_STOP = 0xA9;
const VK_BROWSER_SEARCH = 0xAA;
const VK_BROWSER_FAVORITES = 0xAB;
const VK_BROWSER_HOME = 0xAC;
const VK_VOLUME_MUTE = 0xAD;
const VK_VOLUME_DOWN = 0xAE;
const VK_VOLUME_UP = 0xAF;
const VK_MEDIA_NEXT_TRACK = 0xB0;
const VK_MEDIA_PREV_TRACK = 0xB1;
const VK_MEDIA_STOP = 0xB2;
const VK_MEDIA_PLAY_PAUSE = 0xB3;
const VK_LAUNCH_MAIL = 0xB4;
const VK_LAUNCH_MEDIA_SELECT = 0xB5;
const VK_LAUNCH_APP1 = 0xB6;

//End Windows 2000/XP and Later
const VK_LAUNCH_APP2 = 0xB7;
const VK_OEM_1 = 0xBA;
const VK_OEM_PLUS = 0xBB;
const VK_OEM_COMMA = 0xBC;
const VK_OEM_MINUS = 0xBD;
const VK_OEM_PERIOD = 0xBE;
const VK_OEM_2 = 0xBF;
const VK_OEM_3 = 0xC0;
const VK_OEM_4 = 0xDB;
const VK_OEM_5 = 0xDC;
const VK_OEM_6 = 0xDD;
const VK_OEM_7 = 0xDE;
const VK_OEM_8 = 0xDF;
/*
  *Various extended or enhanced keyboards
 */
const VK_OEM_AX = 0xE1;
const VK_OEM_102 = 0xE2;
const VK_ICO_HELP = 0xE3;
const VK_ICO_00 = 0xE4;
const VK_PROCESSKEY = 0xE5;
const VK_ICO_CLEAR = 0xE6;

// Windows 2000/XP and Later
const VK_PACKET = 0xE7;
/*
  *Nokia/Ericsson definitions
 */
const VK_OEM_RESET = 0xE9;
const VK_OEM_JUMP = 0xEA;
const VK_OEM_PA1 = 0xEB;
const VK_OEM_PA2 = 0xEC;
const VK_OEM_PA3 = 0xED;
const VK_OEM_WSCTRL = 0xEE;
const VK_OEM_CUSEL = 0xEF;
const VK_OEM_ATTN = 0xF0;
const VK_OEM_FINISH = 0xF1;
const VK_OEM_COPY = 0xF2;
const VK_OEM_AUTO = 0xF3;
const VK_OEM_ENLW = 0xF4;
const VK_OEM_BACKTAB = 0xF5;
const VK_ATTN = 0xF6;
const VK_CRSEL = 0xF7;
const VK_EXSEL = 0xF8;
const VK_EREOF = 0xF9;
const VK_PLAY = 0xFA;
const VK_ZOOM = 0xFB;
const VK_NONAME = 0xFC;
const VK_PA1 = 0xFD;
const VK_OEM_CLEAR = 0xFE;

//CheckBox States
const BST_UNCHECKED = 0x0000;
const BST_CHECKED = 0x0001;
const BST_INDETERMINATE = 0x0002;

//Mouse Event Flags
const MK_LBUTTON = 0x0001;
const MK_RBUTTON = 0x0002;
const MK_SHIFT = 0x0004;
const MK_CONTROL = 0x0008;
//Windows 2000/XP
const MK_MBUTTON = 0x0010;
const MK_XBUTTON1 = 0x0020;
const MK_XBUTTON2 = 0x0040;

//System Colors
const COLOR_SCROLLBAR = 0;
const COLOR_BACKGROUND = 1;
const COLOR_ACTIVECAPTION = 2;
const COLOR_INACTIVECAPTION = 3;
const COLOR_MENU = 4;
const COLOR_WINDOW = 5;
const COLOR_WINDOWFRAME = 6;
const COLOR_MENUTEXT = 7;
const COLOR_WINDOWTEXT = 8;
const COLOR_CAPTIONTEXT = 9;
const COLOR_ACTIVEBORDER = 10;
const COLOR_INACTIVEBORDER = 11;
const COLOR_APPWORKSPACE = 12;
const COLOR_HIGHLIGHT = 13;
const COLOR_HIGHLIGHTTEXT = 14;
const COLOR_BTNFACE = 15;
const COLOR_BTNSHADOW = 16;
const COLOR_GRAYTEXT = 17;
const COLOR_BTNTEXT = 18;
const COLOR_INACTIVECAPTIONTEXT = 19;
const COLOR_BTNHIGHLIGHT = 20;
const COLOR_3DDKSHADOW = 21;
const COLOR_3DLIGHT = 22;
const COLOR_INFOTEXT = 23;
const COLOR_INFOBK = 24;

alias COLOR_BACKGROUND COLOR_DESKTOP;
alias COLOR_BTNFACE COLOR_3DFACE;
alias COLOR_BTNSHADOW COLOR_3DSHADOW;
alias COLOR_BTNHIGHLIGHT COLOR_3DHIGHLIGHT;
alias COLOR_BTNHIGHLIGHT COLOR_3DHILIGHT;
alias COLOR_BTNHIGHLIGHT COLOR_BTNHILIGHT;

//Windows 98/Me, Windows 2000/XP
const COLOR_HOTLIGHT = 26;
const COLOR_GRADIENTACTIVECAPTION = 27;
const COLOR_GRADIENTINACTIVECAPTION = 28;
//Windows XP
const COLOR_MENUHILIGHT = 29;
const COLOR_MENUBAR = 30;

//Find and Replace Dialog Flags
const FR_DOWN = 0x00000001;
const FR_WHOLEWORD = 0x00000002;
const FR_MATCHCASE = 0x00000004;
const FR_SHOWHELP = 0x00000080;
const FR_NOUPDOWN = 0x00000400;
const FR_NOMATCHCASE = 0x00000800;
const FR_NOWHOLEWORD = 0x00001000;
const FR_HIDEUPDOWN = 0x00004000;
const FR_HIDEMATCHCASE = 0x00008000;
const FR_HIDEWHOLEWORD = 0x00010000;

//RichEdit Load and Save Flags
const SF_TEXT = 0x0001;
const SF_RTF = 0x0002;
const SF_RTFNOOBJS = 0x0003;
const SF_TEXTIZED = 0x0004;
const SF_UNICODE = 0x0010;
const SF_USECODEPAGE = 0x0020;
const SFF_SELECTION = 0x8000;
const SFF_PLAINRTF = 0x4000;

//Frame.TextRect Flags 
const DT_TOP = 0x00000000;
const DT_LEFT = 0x00000000;
const DT_CENTER = 0x00000001;
const DT_RIGHT = 0x00000002;
const DT_VCENTER = 0x00000004;
const DT_BOTTOM = 0x00000008;
const DT_WORDBREAK = 0x00000010;
const DT_SINGLELINE = 0x00000020;
const DT_EXPANDTABS = 0x00000040;
const DT_TABSTOP = 0x00000080;
const DT_NOCLIP = 0x00000100;
const DT_EXTERNALLEADING = 0x00000200;
const DT_CALCRECT = 0x00000400;
const DT_NOPREFIX = 0x00000800;
const DT_INTERNAL = 0x00001000;
const DT_EDITCONTROL = 0x00002000;
const DT_PATH_ELLIPSIS = 0x00004000;
const DT_END_ELLIPSIS = 0x00008000;
const DT_MODIFYSTRING = 0x00010000;
const DT_RTLREADING = 0x00020000;
const DT_WORD_ELLIPSIS = 0x00040000;
const DT_NOFULLWIDTHCHARBREAK = 0x00080000;
const DT_HIDEPREFIX = 0x00100000;
const DT_PREFIXONLY = 0x00200000;

//Polygon fill mode
const ALTERNATE = 1;
const WINDING = 2;

//Combine Regions Modes
const RGN_AND = 1;
const RGN_OR = 2;
const RGN_XOR = 3;
const RGN_DIFF = 4;
const RGN_COPY = 5;

//OnHitTest codes
const HTERROR = (-2);
const HTTRANSPARENT = (-1);
const HTNOWHERE = 0;
const HTCLIENT = 1;
const HTCAPTION = 2;
const HTSYSMENU = 3;
const HTGROWBOX = 4;
alias HTGROWBOX HTSIZE;
const HTMENU = 5;
const HTHSCROLL = 6;
const HTVSCROLL = 7;
const HTMINBUTTON = 8;
const HTMAXBUTTON = 9;
const HTLEFT = 10;
const HTRIGHT = 11;
const HTTOP = 12;
const HTTOPLEFT = 13;
const HTTOPRIGHT = 14;
const HTBOTTOM = 15;
const HTBOTTOMLEFT = 16;
const HTBOTTOMRIGHT = 17;
const HTBORDER = 18;
alias HTMINBUTTON HTREDUCE;
alias HTMAXBUTTON HTZOOM;
alias HTLEFT HTSIZEFIRST;
alias HTBOTTOMRIGHT HTSIZELAST;
const HTOBJECT = 19;
const HTCLOSE = 20;
const HTHELP = 21;
/*
  *Standard Cursor IDs
 */
const IDC_ARROW = 32512;
const IDC_IBEAM = 32513;
const IDC_WAIT = 32514;
const IDC_CROSS = 32515;
const IDC_UPARROW = 32516;
const IDC_SIZE = 32640;
const IDC_ICON = 32641;
const IDC_SIZENWSE = 32642;
const IDC_SIZENESW = 32643;
const IDC_SIZEWE = 32644;
const IDC_SIZENS = 32645;
const IDC_SIZEALL = 32646;
const IDC_NO = 32648;
//Windows 98/Me, Windows 2000/XP
const IDC_HAND = 32649;
const IDC_APPSTARTING = 32650;
const IDC_HELP = 32651;

//Constants

const COLOR_NONE = 0xFFFFFFFF;
const POSITION_NONE = 0xF000000;

//Keyboard Flags (OnKeyDown, OnKeyUp)
const KB_SHIFT = 0x10000000;
const KB_CTRL = 0x20000000;
const KB_ALT = 0x40000000;
const KB_LSHIFT = 0x01000000;
const KB_LCTRL = 0x02000000;
const KB_LALT = 0x04000000;
const KB_RSHIFT = 0x00100000;
const KB_RCTRL = 0x00200000;
const KB_RALT = 0x00400000;

//Align
const AL_NONE = 0;
const AL_LEFT = 1;
const AL_RIGHT = 2;
const AL_CENTER = 3;
const AL_TOP = 4;
const AL_BOTTOM = 5;
const AL_TOPLEFT = 6;
const AL_TOPRIGHT = 7;
const AL_BOTTOMLEFT = 8;
const AL_BOTTOMRIGHT = 9;
const AL_CLIENT = 10;
const AL_AT_LEFT = 11;
const AL_AT_TOP = 12;
const AL_AT_RIGHT = 13;
const AL_AT_BOTTOM = 14;

//Brush Styles
const B_CLEAR = 0;
const B_SOLID = 1;
const B_DIAGONAL = 2;
const B_CROSS = 3;
const B_DIAGCROSS = 4;
const B_FDIAGONAL = 5;
const B_HORIZONTAL = 6;
const B_VERTICAL = 7;
const B_BITMAP = 8;
const B_GRADIENT = 0x10000000;

//TREEVIEW_THISITEM Constant
const TREEVIEW_THISITEM = -1;
//ScrollBars 
const SS_NONE = 0;
const SS_HORIZONTAL = 1;
const SS_VERTICAL = 2;
const SS_BOTH = 3;
//Bevel Styles  (StatusItem.Border, Frame.BevelInner, Frame.BevelOuter)
const BS_NONE = 0;
const BS_LOWERED = -1;
const BS_RAISED = 1;
//TrackBar tick marks constants
const TM_NONE = 0;
const TM_TOP = 1;
const TM_BOTTOM = -1;
alias TM_TOP TM_LEFT;
alias TM_BOTTOM TM_RIGHT;
const TM_BOTH = 2;
//Animate IDs
const AVI_FINDFOLDER = 0;
const AVI_FINDFILE = 1;
const AVI_FINDCOMPUTER = 2;
const AVI_COPYFILES = 3;
const AVI_COPYFILE = 4;
const AVI_RECYCLEFILE = 5;
const AVI_EMPTYRECYCLE = 6;
const AVI_DELETEFILE = 7;
//DataTypes
const DT_NONE = 0;
const DT_STRING = 1;
const DT_INTEGER = 2;
const DT_float = 3;
const DT_HEXINT = 4;
//SortTypes
const SORT_NONE = 0;
const SORT_NORMAL = 1;
const SORT_REVERSE = -1;
//Draw Types
const DI_DRAW = 0;
const DI_STRETCH = 1;
const DI_CENTER = 2;
const DI_PROPORTIONAL_STRETCH = 5;
//CharCase
const CC_NORMAL = 0;
const CC_LOWERCASE = -1;
const CC_UPPERCASE = 1;
const DIRECTION_TOP_BOTTOM = 2700;
const DIRECTION_LEFT_RIGHT = 0;
const DIRECTION_BOTTOM_TOP = 900;
const DIRECTION_RIGHT_LEFT = 1800;
const DIRECTION_TOP_CENTER_BOTTOM = (DIRECTION_TOP_BOTTOM | DIRECTION_CENTER);
const DIRECTION_CENTER = 0x20000000;
const DIRECTION_LEFT_CENTER_RIGHT = (DIRECTION_LEFT_RIGHT | DIRECTION_CENTER);

const IDC_DEFAULT = -1;
const IDC_NONE = 0;
const IDC_PARENT = -2;

//Other Constants
const WS_DEFAULT = (WS_SIZEGRIP | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU | WS_CAPTION);
alias WS_SIZEBOX WS_SIZEGRIP;
const WS_DIALOGDEFAULT = (WS_SYSMENU | WS_CAPTION);
const OFN_OPENDEFAULT = (OFN_HIDEREADONLY);
const OFN_SAVEDEFAULT = (OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT);
const PD_DEFAULT =(PD_ALLPAGES | PD_USEDEVMODECOPIES | PD_NOPAGENUMS | PD_NOSELECTION);
const PSD_DEFAULT = (PSD_MARGINS | PSD_INWININIINTLMEASURE);
const CC_DEFAULT  = 0;
const BIF_DEFAULT  = (BIF_RETURNONLYFSDIRS);
//const CC_DEFAULT = 0;
const CF_DEFAULT =(CF_EFFECTS | CF_SCREENFONTS);
const TVS_DEFAULT  = (TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT);
const TCS_DEFAULT  =  (TCS_MULTILINE | TCS_TABS | TCS_HOTTRACK);
const RBS_DEFAULT = (RBS_VARHEIGHT | RBS_AUTOSIZE);
//End Constants

//C     interface WindowSystemObject : IDispatch{
extern (C):

interface WindowSystemObject : IDispatch{
	mixin(uuid("40CC9252-A25A-4D28-A906-9BD3F752934A"));
         int CreateForm(int Left, int Top, int Width, int Height,int Style /*= WS_DEFAULT*/, out IDispatch **pControl);
         int CreateDialogForm(int Left, int Top, int Width, int Height,int Style/* = WS_DIALOGDEFAULT*/, out IDispatch **pControl);
         int CreateImageList(out IDispatch **pControl);
         int CreateTimer(out IDispatch **pControl);
         int CreateCOMEvents(IDispatch *COMObject, out IDispatch **pControl);
         int CreateFindDialog(BSTR FindText /*= ""*/, uint Flags/* = FR_DOWN*/, out IDispatch **pResult);
         int CreateReplaceDialog(BSTR FindText /*= ""*/, BSTR ReplaceText /*= ""*/, uint Flags/* = FR_DOWN*/, out IDispatch **pResult);
         int CreateTrayIcon(out IDispatch **pControl);
         int Run();
         int Stop();
        int Controls(out IDispatch **pVal);
         int Translate(BSTR Text, out VARIANT *pResult);
         int LoadImage(BSTR Path, out IDispatch **pResult);
        int Version(out IDispatch **pVal);
        int Debug(out VARIANT_BOOL *pVal);
        int Debug(VARIANT_BOOL newVal);
         int About();
        int Regions(out IDispatch **pVal);
        int PixelsPerInch(out int *pVal);
        int PixelsPerInch(int newVal);
        int Screen(out IDispatch **pVal);

         int CreateEventHandler(out IDispatch **pControl);

        int EnableVisualStyles(out VARIANT_BOOL *pVal);
        int EnableVisualStyles(VARIANT_BOOL newVal);

         int CreatePrintInfo(out IDispatch **pControl);
};
interface Version : IDispatch
{ mixin(uuid("AC444C04-F889-47E1-B56E-9F648D8AB009"));
        int Major(out int *pVal);
        int Minor(out int *pVal);
        int String(out BSTR *pVal);
        int Trial(out VARIANT_BOOL *pVal);
        int Url(out BSTR *pVal);
}
interface IObject: IDispatch
{
	 mixin(uuid("AADDFAA1-E50D-4C66-8955-DFE8CF54FABB"));
        int Type(out BSTR *pVal);
        int UserData(out VARIANT *pVal);
        int UserData(VARIANT newVal);
         int AddEventHandler(BSTR EventName, VARIANT EventHandler);
         int RemoveEventHandler(BSTR EventName, VARIANT EventHandler);
}
interface Control:IObject
{
	mixin(uuid("4397A1F9-F35F-4234-AF6A-F6327B0F784E"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
         int Show();
         int Hide();
        int Visible(out VARIANT_BOOL *pVal);
        int Visible(VARIANT_BOOL newVal);
        int Enabled(out VARIANT_BOOL *pVal);
        int Enabled(VARIANT_BOOL newVal);
         int Destroy();
        int Parent(out IDispatch **pVal);
        int Root(out IDispatch **pVal);
        int Form(out IDispatch **pVal);
        int Left(out int *pVal);
        int Left(int newVal);
        int Top(out int *pVal);
        int Top(int newVal);
        int Width(out int *pVal);
        int Width(int newVal);
        int Height(out int *pVal);
        int Height(int newVal);
        int Right(out int *pVal);
        int Right(int newVal);
        int Bottom(out int *pVal);
        int Bottom(int newVal);
         int SetBounds(int Left, int Top, int Width, int Height);
         int CenterControl();
        int MinWidth(out ushort *pVal);
        int MinWidth(ushort newVal);
        int MinHeight(out ushort *pVal);
        int MinHeight(ushort newVal);
        int MaxWidth(out ushort *pVal);
        int MaxWidth(ushort newVal);
        int MaxHeight(out ushort *pVal);
        int MaxHeight(ushort newVal);
        int Align(out ushort *pVal);
        int Align(ushort newVal);
        int Color(out uint *pVal);
        int Color(uint newVal);
        int ParentColor(out VARIANT_BOOL *pVal);
        int ParentColor(VARIANT_BOOL newVal);
        int Font(out IDispatch **pVal);
        int Font(IDispatch *newVal);
        int Font(IDispatch *newVal);
        int ParentFont(out VARIANT_BOOL *pVal);
        int ParentFont(VARIANT_BOOL newVal);
        int Pen(out IDispatch **pVal);
        int Pen(IDispatch *newVal);
        int Pen(IDispatch *newVal);
        int Brush(out IDispatch **pVal);
        int Brush(IDispatch *newVal);
        int Brush(IDispatch *newVal);
        int PopupMenu(out IDispatch **pVal);
        int PopupMenu(IDispatch *newVal);
        int PopupMenu(IDispatch *newVal);
        int Border(out VARIANT_BOOL *pVal);
        int Border(VARIANT_BOOL newVal);
         int SetFocus();
        int Focused(out VARIANT_BOOL *pVal);
        int TabOrder(out int *pVal);
        int TabOrder(int newVal);
        int TabStop(out VARIANT_BOOL *pVal);
        int TabStop(VARIANT_BOOL newVal);
        int Name(out BSTR *pVal);
        int Name(BSTR newVal);
        int ClientWidth(out int *pVal);
        int ClientWidth(int newVal);
        int ClientHeight(out int *pVal);
        int ClientHeight(int newVal);
        int Cursor(out int *pVal);
        int Cursor(int newVal);
        int Hint(out VARIANT *pVal);
        int Hint(VARIANT newVal);
        int OnClick(VARIANT newVal);
        int OnDblClick(VARIANT newVal);
        int OnChange(VARIANT newVal);
        int OnKeyDown(VARIANT newVal);
        int OnKeyUp(VARIANT newVal);
        int OnMouseEnter(VARIANT newVal);
        int OnMouseLeave(VARIANT newVal);
        int OnMouseUp(VARIANT newVal);
        int OnMouseMove(VARIANT newVal);
        int OnMouseDown(VARIANT newVal);
        int OnResize(VARIANT newVal);
        int OnMove(VARIANT newVal);
        int OnDestroy(VARIANT newVal);
        int OnShow(VARIANT newVal);
        int OnHide(VARIANT newVal);
        int OnEnabledChange(VARIANT newVal);
        int OnSetFocus(VARIANT newVal);
        int OnKillFocus(VARIANT newVal);

         int Repaint();
}
interface Collection: IDispatch
{
	mixin(uuid("92BEFD16-E781-484B-BC2D-F3B5E5DA2CC5"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
         int Remove(VARIANT Index); 
         int Clear(); 
         int ExChange(VARIANT A,VARIANT B); 
};
interface ImageList: IDispatch
{
	mixin(uuid("68343C86-0240-44FD-A24F-5CD611E0A33F"));
         int Load(VARIANT Image);
         int Add(VARIANT Image);
         int Clear();
         int Remove(int Index);
        int Width(out uint *pVal);
        int Width(uint newVal);
        int Height(out uint *pVal);
        int Height(uint newVal);
        int Count(out int *pVal);
        int BitsPerPixel(out int *pVal);
        int BitsPerPixel(int newVal);
};
interface Frame: Control
{
		mixin(uuid("92337C2C-1C7D-4848-8AD2-B9D33E4EB242"));
         int CreateButton(int Left, int Top, int Width, int Height, BSTR Text, out IDispatch **pControl);
         int CreateCheckBox(int Left, int Top, int Width, int Height, BSTR Text, VARIANT_BOOL Checked /*= FALSE*/, out IDispatch **pControl);
         int CreateRadioButton(int Left, int Top, int Width, int Height, BSTR Text, out IDispatch **pControl);
         int CreateEdit(int Left, int Top, int Width, int Height, int Style /*= 0*/, out IDispatch **pControl);
         int CreateListBox(int Left, int Top, int Width, int Height, int Style /*= 0*/, out IDispatch **pControl);
         int CreateComboBox(int Left, int Top, int Width, int Height, int Style /*= CBS_DROPDOWN*/ , out IDispatch **pControl);
         int CreateFrame(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateGroupBox(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateProgressBar(int Left, int Top , int Width, int Height, int Style /*= 0*/, out IDispatch **pControl);
         int CreateTabControl(int Left, int Top, int Width, int Height, int Style/* = TCS_DEFAULT*/, out IDispatch **pControl);
         int CreateToolBar(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateMenuBar(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateReBar(int Left, int Top, int Width, int Height, int Style /*= RBS_DEFAULT*/, out IDispatch **pControl);
         int CreateStatusBar(out IDispatch **pControl);
         int CreateHyperLink(int Left, int Top, int Width, int Height, BSTR URL, BSTR Label /*=""*/, out IDispatch **pControl);
         int CreatePager(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateScrollBar(int Left, int Top, int Width, int Height, int Style/* = SBS_HORZ*/, out IDispatch **pControl);
         int CreateActiveXControl(int Left, int Top, int Width, int Height, BSTR ID, out IDispatch **pControl);
         int CreateActiveXControlLicensed(int Left, int Top, int Width, int Height, BSTR ID,BSTR LicKey, out IDispatch **pControl);
         int CreateHeader(int Left, int Top, int Width, int Height, int Style /*= HDS_BUTTONS*/, out IDispatch **pControl);
         int CreateListView(int Left, int Top, int Width, int Height, int Style /*=0*/, out IDispatch **pControl);
         int CreateTreeView(int Left, int Top, int Width, int Height, int Style /*= TVS_DEFAULT*/, out IDispatch **pControl);
         int CreateRichEdit(int Left, int Top, int Width, int Height, int Style /*= ES_MULTILINE*/, out IDispatch **pControl);
         int CreateAnimate(int Left, int Top, int Width, int Height, int Style /*= ACS_CENTER*/, out IDispatch **pControl);
         int CreateHotKey(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateTrackBar(int Left, int Top, int Width, int Height, int Style /*=0*/, out IDispatch **pControl);
         int CreateUpDown(int Left, int Top, int Width, int Height, int Style /*=0*/, out IDispatch **pControl);
         int CreateDateTimePicker(int Left, int Top, int Width, int Height, int Style /*=0*/, out IDispatch **pControl);
         int CreateCalendar(int Left, int Top, int Width, int Height, int Style /*=0*/, out IDispatch **pControl);
         int CreateIPAddress(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int CreateSplitter(ushort Align, out IDispatch **pControl);
         int Line(int Ax, int Ay, int Bx, int By, out IDispatch * *pControl);
         int Rectangle(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int RoundRect(int Left, int Top, int Width, int Height, int nWidth, int nHeight, out IDispatch **pControl);
         int Circle(int x, int y, int r , out IDispatch **pControl);
         int Ellipse(int Left, int Top, int Width, int Height, out IDispatch **pControl);
         int Arc(int Left, int Top, int Width, int Height, int nXStartArc, int nYStartArc, int nXEndArc, int nYEndArc, out IDispatch **pControl);
         int Chord(int Left, int Top, int Width, int Height, int nXRadial1, int nYRadial1, int nXRadial2, int nYRadial2, out IDispatch **pControl);
         int Pie(int Left, int Top, int Width, int Height, int nXRadial1, int nYRadial1, int nXRadial2, int nYRadial2, out IDispatch **pControl);
      //   int Polygon(SAFEARRAY(VARIANT) Data, out IDispatch **pControl);
         int TextOut(int x, int y, BSTR Text, out IDispatch **pControl);
         int TextRect(int Left, int Top, int Width, int Height, BSTR Text, uint Flags /*= (DT_NOPREFIX | DT_CENTER | DT_VCENTER | DT_WORDBREAK | DT_CALCRECT)*/, out IDispatch **pControl);
         int DrawImage(int Left, int Top, int Width, int Height, VARIANT Image, out IDispatch **pControl);
         int DrawRegion(int Left, int Top, uint Region, out IDispatch **pControl);
         int Bevel(int Left, int Top, int Width, int Height, int BevelOuter /*= 1*/, int BevelInner /*=0*/, uint BorderWidth /*= 1*/, uint BevelWidth /*= 1*/, out IDispatch **pControl);
        int Controls(out IDispatch **pVal);
        int BorderWidth(out uint *pVal);
        int BorderWidth(uint newVal);
        int BevelWidth(out uint *pVal);
        int BevelWidth(uint newVal);
        int BevelOuter(out int *pVal);
        int BevelOuter(int newVal);
        int BevelInner(out int *pVal);
        int BevelInner(int newVal);
        int GraphFont(out IDispatch **pVal);
        int GraphFont(IDispatch *newVal);
        int GraphFont(IDispatch *newVal);
        int AutoScroll(out VARIANT_BOOL *pVal);
        int AutoScroll(VARIANT_BOOL newVal);
        int Tracking(out VARIANT_BOOL *pVal);
        int Tracking(VARIANT_BOOL newVal);
        int CaptureMouse(out ushort *pVal);
        int CaptureMouse(ushort newVal);
        int ParentBackground(out VARIANT_BOOL *pVal);
        int ParentBackground(VARIANT_BOOL newVal);
};
interface Form : Frame
{
	mixin(uuid("044B381D-C581-4B9E-9C95-08B66B38468F"));
        int Icon(BSTR FileName);     
         int Minimize();
         int Restore();
         int Maximize();
         int Close();
         int ShowModal();
         int MessageBox(BSTR Text, BSTR Caption /*=0*/, int Flags /*=0*/, out int *pResult);
         int ColorDialog(uint StartColor /*= 0x00FFFFFF*/, uint Flags /*= CC_DEFAULT*/, out uint *pColor);
         int FontDialog(IDispatch *StartValue, uint Flags /*= CC_DEFAULT*/, out IDispatch **pResult);
         int OpenDialog(BSTR DefaultExt, BSTR Filter, BSTR StartFile /*=0*/, uint Flags/* = OFN_SAVEDEFAULT*/, out BSTR *pFileName);
         int SaveDialog(BSTR DefaultExt, BSTR Filter, BSTR StartFile /*=0*/, uint Flags /*= OFN_SAVEDEFAULT*/, out BSTR *pFileName);
         int SelectFolderDialog(BSTR Title, uint Flags /*= BIF_DEFAULT*/, out BSTR *pFolder);
         int PrintDialog(uint Flags /*=PD_DEFAULT*/, ushort MinPage /*=0*/, ushort MaxPage /*=0*/, out IDispatch **pResult);
         int PrinterSetupDialog(uint Flags /*=PD_DEFAULT*/, out IDispatch **pResult);
         int PageSetupDialog(uint Flags /*= PSD_DEFAULT*/, out IDispatch **pResult);
         int CreateFindDialog(BSTR FindText /*=0*/, uint Flags /*= FR_DOWN*/, out IDispatch **pResult);
         int CreateReplaceDialog(BSTR FindText /*=0*/, BSTR ReplaceText /*=0*/, uint Flags /*= FR_DOWN*/, out IDispatch **pResult);

         int CreateFontDialog(out IDispatch **pResult);

         int CreateColorDialog(out IDispatch **pResult);

         int CreateOpenDialog(out IDispatch **pResult);
         int CreateSaveDialog(out IDispatch **pResult);
         int CreateForm(int Left, int Top, int Width, int Height,int Style /*= WS_DEFAULT*/, out IDispatch **pControl);
         int CreateDialogForm(int Left, int Top, int Width, int Height,int Style /*= WS_DIALOGDEFAULT*/, out IDispatch **pControl);
        int Menu(out IDispatch **pVal);
        int Menu(IDispatch *newVal);
        int Menu(IDispatch *newVal);
        int KeyPreview(out VARIANT_BOOL *pVal);
        int KeyPreview(VARIANT_BOOL newVal);
        int MaximizeBox(out VARIANT_BOOL *pVal);
        int MaximizeBox(VARIANT_BOOL newVal);
        int MinimizeBox(out VARIANT_BOOL *pVal);
        int MinimizeBox(VARIANT_BOOL newVal);
        int ControlBox(out VARIANT_BOOL *pVal);
        int ControlBox(VARIANT_BOOL newVal);
        int SizeGrip(out VARIANT_BOOL *pVal);
        int SizeGrip(VARIANT_BOOL newVal);
        int TopMost(out VARIANT_BOOL *pVal);
        int TopMost(VARIANT_BOOL newVal);
        int ToolWindow(out VARIANT_BOOL *pVal);
        int ToolWindow(VARIANT_BOOL newVal);
        int Caption(out VARIANT_BOOL *pVal);
        int Caption(VARIANT_BOOL newVal);
        int AcceptButton(out IDispatch **pVal);
        int AcceptButton(IDispatch *newVal);
        int AcceptButton(IDispatch *newVal);
        int CancelButton(out IDispatch **pVal);
        int CancelButton(IDispatch *newVal);
        int CancelButton(IDispatch *newVal);
        int HelpButton(out IDispatch **pVal);
        int HelpButton(IDispatch *newVal);
        int HelpButton(IDispatch *newVal);
        int ActiveControl(out IDispatch **pVal);
        int ActiveControl(IDispatch *newVal);
        int ActiveControl(IDispatch *newVal);
        int CanClose(out VARIANT_BOOL *pVal);
        int CanClose(VARIANT_BOOL newVal);
        int Region(uint newVal);
        int OnCloseQuery(VARIANT newVal);
        int OnClose(VARIANT newVal);
        int OnActiveControlChange(VARIANT newVal);
        int OnHitTest(VARIANT newVal);       
        int OnHint(VARIANT newVal);  
};
interface GraphicObject: IDispatch
{
	mixin(uuid("09866D76-9782-4FD2-BA16-C469A06499C1"));
        int Color(out uint *pVal);
        int Color(uint newVal);
         int Default();
};
interface Pen: GraphicObject
{
	mixin(uuid("A6BFFF0E-7526-495A-AEA9-7BE6005184D7"));
        int Width(out int *pVal);
        int Width(int newVal);
        int Style(out int *pVal);
        int Style(int newVal);
};
interface Brush: GraphicObject
{
	mixin(uuid("68FA42FE-34AC-40E9-857D-F94846E91B0A"));
        int Style(out int *pVal);
        int Style(int newVal);
        int Image(VARIANT Image);
        int GradientColor(out uint *pVal);
        int GradientColor(uint newVal);
};
interface FontEx: GraphicObject
{	
	mixin(uuid("FAE1D3D9-57B5-42D7-AF14-AC9ED6B31EA8"));
        int Italic(out VARIANT_BOOL *pVal);
        int Italic(VARIANT_BOOL newVal);
        int Underline(out VARIANT_BOOL *pVal);
        int Underline(VARIANT_BOOL newVal);
        int Strikethrough(out VARIANT_BOOL *pVal);
        int Strikethrough(VARIANT_BOOL newVal);
        int Bold(out VARIANT_BOOL *pVal);
        int Bold(VARIANT_BOOL newVal);
        int Weight(out short *pVal);
        int Weight(short newVal);
        int Name(out BSTR *pVal);
        int Name(BSTR newVal);
        int Size(out long *pVal);
        int Size(long newVal);
        int CharSet(out short *pVal);
        int CharSet(short newVal);
        int Angle(out int *pVal);
        int Angle(int newVal);
};
interface Action : IObject
{
	mixin(uuid("752D00E4-9EBE-4A1A-82D8-5D62F66CB4ED"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Item(long Index,
        VARIANT newVal);
        int Count(out long *pcount);
         int Remove(VARIANT Index); 
         int Clear(); 
         int ExChange(VARIANT A,VARIANT B); 

         int Add(VARIANT Item, /*optional*/ VARIANT Key, out IDispatch **pControl);
         int Insert(int Index, VARIANT Item, /*optional*/ VARIANT Key, out IDispatch **pControl);
         int NewLine(out IDispatch **pControl);
        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int Enabled(out VARIANT_BOOL *pVal);
        int Enabled(VARIANT_BOOL newVal);
        int Checked(out VARIANT_BOOL *pVal);
        int Checked(VARIANT_BOOL newVal);
        int Visible(out VARIANT_BOOL *pVal);
        int Visible(VARIANT_BOOL newVal);
        int CheckBox(out VARIANT_BOOL *pVal);
        int CheckBox(VARIANT_BOOL newVal);
        int RadioCheck(out VARIANT_BOOL *pVal);
        int RadioCheck(VARIANT_BOOL newVal);
        int AllowAllUp(out VARIANT_BOOL *pVal);
        int AllowAllUp(VARIANT_BOOL newVal);
        int Default(out VARIANT_BOOL *pVal);
        int Default(VARIANT_BOOL newVal);
        int Control(out IDispatch **pVal);
        int Form(out IDispatch **pVal);
        int Items(out IDispatch **pVal);
        int Hint(out VARIANT *pVal);
        int Hint(VARIANT newVal);
        int Break(out VARIANT_BOOL *pVal);
        int Break(VARIANT_BOOL newVal);
        int Key(out VARIANT *pVal);
        int Key(VARIANT newVal);
        int OnExecute(VARIANT newVal);
        int OnUpdate(VARIANT newVal);
};
interface ButtonControl: Control
{
	mixin(uuid("CE6D21C9-132F-4990-ACB2-4C68A1D46BA2"));
        int Flat(out VARIANT_BOOL *pVal);
        int Flat(VARIANT_BOOL newVal);
};
interface Button: ButtonControl
{
	mixin(uuid("31DC6745-8E8E-4F4A-9F17-36651B160FE9"));
        int Default(out VARIANT_BOOL *pVal);
        int Default(VARIANT_BOOL newVal);
        int Cancel(out VARIANT_BOOL *pVal);
        int Cancel(VARIANT_BOOL newVal);
};
interface CheckBox: ButtonControl
{
	//mixin(uuid("
        int State(out int *pVal);
        int State(int newVal);
        int AllowGrayed(out VARIANT_BOOL *pVal);
        int AllowGrayed(VARIANT_BOOL newVal);
        int Checked(out VARIANT_BOOL *pVal);
        int Checked(VARIANT_BOOL newVal);
};
interface RadioButton: ButtonControl
{
	mixin(uuid("E4D0E174-9AB6-4BDF-9186-8905F5B54AAA"));
        int Checked(out VARIANT_BOOL *pVal);
        int Checked(VARIANT_BOOL newVal);
        int Group(out int *pVal);
        int Group(int newVal);
};
interface StringsControl: Control
{
	mixin(uuid("A1E967E4-0CEB-436B-91C0-F6A42F8D8733"));
        int TopIndex(out int *pVal);
        int TopIndex(int newVal);
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out BSTR *pvar);
        int Item(long Index,
        BSTR newVal);
        int Count(out long *pcount);
         int Add(BSTR Item, out int *pItemIndex);
         int Remove(int Index);
         int Insert(int Index, BSTR Item, out int *pItemIndex);
         int Clear();
         int BeginUpdate(); 
         int EndUpdate(); 
         int ExChange(int A, int B); 
         int Sort(int DataType /*= DT_STRING*/, VARIANT_BOOL Reverse /*= FALSE*/);
         int Find(BSTR Text, int Start /*=0*/, VARIANT_BOOL IgnoreCase /*= TRUE*/, out int *pItemIndex);
};
interface Edit: StringsControl
{
	mixin(uuid("1D2D9535-7884-49AB-90C2-49955A388137"));
        int ReadOnly(out VARIANT_BOOL *pVal);
        int ReadOnly(VARIANT_BOOL newVal);
        int MaxLength(out int *pVal);
        int MaxLength(int newVal);
        int CharCase(out int *pVal);
        int CharCase(int newVal);
        int PasswordChar(out BSTR *pVal);
        int PasswordChar(BSTR newVal);
        int HideSelection(out VARIANT_BOOL *pVal);
        int HideSelection(VARIANT_BOOL newVal);
        int MultiLine(out VARIANT_BOOL *pVal);
        int MultiLine(VARIANT_BOOL newVal);
        int ScrollBars(out uint *pVal);
        int ScrollBars(uint newVal);
        int AutoSize(out VARIANT_BOOL *pVal);
        int AutoSize(VARIANT_BOOL newVal);
        int Modified(out VARIANT_BOOL *pVal);
        int Modified(VARIANT_BOOL newVal);
        int SelStart(out int *pVal);
        int SelStart(int newVal);
        int SelEnd(out int *pVal);
        int SelEnd(int newVal);
        int SelLength(out int *pVal);
        int SelLength(int newVal);
        int LeftMargin(out ushort *pVal);
        int LeftMargin(ushort newVal);
        int RightMargin(out ushort *pVal);
        int RightMargin(ushort newVal);
        int WordWrap(out VARIANT_BOOL *pVal);
        int WordWrap(VARIANT_BOOL newVal);
        int TextAlign(out ushort *pVal);
        int TextAlign(ushort newVal);
         int SelectAll();
         int ClearSelection();
         int ReplaceSelection(BSTR newText, VARIANT_BOOL CanUndo /*= FALSE*/);
        int CanUndo(out VARIANT_BOOL *pVal);
        int CanUndo(VARIANT_BOOL newVal);
        int CanPaste(out VARIANT_BOOL *pVal);
         int Undo();
         int Cut();
         int Copy();
         int Paste();
        int DataType(out int *pVal);
        int DataType(int newVal);
        int Min(out VARIANT *pVal);
        int Min(VARIANT newVal);
        int Max(out VARIANT *pVal);
        int Max(VARIANT newVal);
        int LineFromChar(int Index /*= -1*/, out int *pVal);
        int AcceptsReturn(out VARIANT_BOOL *pVal);
        int AcceptsReturn(VARIANT_BOOL newVal);
        int AcceptsTab(out VARIANT_BOOL *pVal);
        int AcceptsTab(VARIANT_BOOL newVal);
};
interface Paragraph: IDispatch
{
	mixin(uuid("C15C0ABE-967F-4A17-9EA9-BC68A2855C0D"));
        int Align(out ushort *pVal);
        int Align(ushort newVal);
        int Numbering(out VARIANT_BOOL *pVal);
        int Numbering(VARIANT_BOOL newVal);
        int StartIndent(out int *pVal);
        int StartIndent(int newVal);
        int LeftIndent(out int *pVal);
        int LeftIndent(int newVal);
        int RightIndent(out int *pVal);
        int RightIndent(int newVal);
}
interface RichEdit: Edit
{
	mixin(uuid("C775712D-FA95-49EE-971D-6DD3BE4FE703"));
        int SelFont(out IDispatch **pVal);
        int SelFont(IDispatch *newVal);
        int SelFont(IDispatch *newVal);
        int Paragraph(out IDispatch **pVal);
         int FindText(BSTR Text, uint Flags /*= FR_DOWN*/, int MinPos /*=0*/, int MaxPos /*= -1*/, out int *pResult);
         int Load(VARIANT Stream, uint Flags /*= SF_RTF*/, out VARIANT_BOOL *pResult);
         int Save(VARIANT Stream, uint Flags /*= SF_RTF*/, out VARIANT_BOOL *pResult);
        //RichEdit Version 2
        int AutoURLDetect(out VARIANT_BOOL *pVal);
        int AutoURLDetect(VARIANT_BOOL newVal);
        int CanRedo(out VARIANT_BOOL *pVal);
         int Redo();
        int UndoLimit(out uint *pVal);
        int UndoLimit(uint newVal);
        //Events
        int OnSelChange(VARIANT newVal);

         int Print(BSTR Driver, BSTR Device, IDispatch PrintInfo, VARIANT_BOOL Selection /*= FALSE*/);

};
interface ListControl: StringsControl
{
	mixin(uuid("B61BDF00-553F-401B-948C-2F7A5FDCBBBB"));
        int ItemIndex(out int *pVal);
        int ItemIndex(int newVal);
        int ItemHeight(out int *pVal);
        int ItemHeight(int newVal);
        int ItemData(int Index, out int *pVal);
        int ItemData(int Index, int newVal);
        int Sorted(out VARIANT_BOOL *pVal);
        int Sorted(VARIANT_BOOL newVal);
        int IntegralHeight(out VARIANT_BOOL *pVal);
        int IntegralHeight(VARIANT_BOOL newVal);
        int HorizontalExtent(out int *pVal);
        int HorizontalExtent(int newVal);
};
interface ListBox: ListControl
{
	mixin(uuid("A33F2256-EF4D-409B-B1FD-0BE23F8F8C2D"));
        int Selected(int Index, out VARIANT_BOOL *pVal);
        int Selected(int Index, VARIANT_BOOL newVal);
        int SelCount(out int *pVal);
        int MultiSelect(out VARIANT_BOOL *pVal);
        int MultiSelect(VARIANT_BOOL newVal);
        int ExtendedSelect(out VARIANT_BOOL *pVal);
        int ExtendedSelect(VARIANT_BOOL newVal);
        int ColumnCount(out ushort *pVal);
        int ColumnCount(ushort newVal);
        int ColumnWidth(out ushort *pVal);
        int ColumnWidth(ushort newVal);
        int ScrollBars(out uint *pVal);
        int ScrollBars(uint newVal);
         int ItemFromPoint(ushort x, ushort y, out int *pIndex);
};
interface ComboBox: ListControl
{
	mixin(uuid("AA09373F-278A-49DF-9F40-74C5B92ABB6F"));
        int DropDownCount(out uint *pVal);
        int DropDownCount(uint newVal);
        int Style(out int *pVal);
        int Style(int newVal);
        int CharCase(out int *pVal);
        int CharCase(int newVal);
        int ReadOnly(out VARIANT_BOOL *pVal);
        int ReadOnly(VARIANT_BOOL newVal);
        int DroppedDown(out VARIANT_BOOL *pVal);
        int DroppedDown(VARIANT_BOOL newVal);
};
interface StatusItem: IDispatch
{
	mixin(uuid("80508CDF-06EA-43C5-B41E-F2F97D516151"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int Width(out int *pVal);
        int Width(int newVal);
        int Border(out int *pVal);
        int Border(int newVal);
        int AutoSize(out VARIANT_BOOL *pVal);
        int AutoSize(VARIANT_BOOL newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
};
interface StatusBar: Control
{
	mixin(uuid("F61D55A1-ECC9-484B-A635-F0C5E71A8C29"));
        int Simple(out VARIANT_BOOL *pVal);
        int Simple(VARIANT_BOOL newVal);
        int SizeGrip(out VARIANT_BOOL *pVal);
        int SizeGrip(VARIANT_BOOL newVal);

        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
         int Remove(VARIANT Index); 
         int Clear(); 
         int ExChange(VARIANT A,VARIANT B); 
         int Add(int Width, int Border /*= BS_LOWERED*/, out IDispatch **pItem);

        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
};
interface StatusControl: Control
{
	mixin(uuid("7ADA76A6-13E2-455D-8DF1-E2C980D21BF9"));
        int Min(out int *pVal);
        int Min(int newVal);
        int Max(out int *pVal);
        int Max(int newVal);
        int Position(out int *pVal);
        int Position(int newVal);
        int Step(out int *pVal);
        int Step(int newVal);
         int StepIt();
         int StepBy(int Delta);
}
interface ProgressBar: StatusControl
{
	mixin(uuid("16271F21-45E5-4632-BC36-E3E429B49AD8"));
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int Smooth(out VARIANT_BOOL *pVal);
        int Smooth(VARIANT_BOOL newVal);
};
interface ScrollBar:StatusControl
{
	mixin(uuid("FC140361-F789-48AD-AE2B-A4B5A2643FB0"));
        int Page(out uint *pVal);
        int Page(uint newVal);
        int SmallChange(out uint *pVal);
        int SmallChange(uint newVal);
        int LargeChange(out uint *pVal);
        int LargeChange(uint newVal);
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int Tracking(out VARIANT_BOOL *pVal);
        int Tracking(VARIANT_BOOL newVal);
};
interface Tab: Frame
{
	mixin(uuid("F8019994-24F1-475D-8AC4-5A1BCFF213D0"));
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
};
interface TabControl: Control
{
	mixin(uuid("80249C22-E39E-4BF1-A167-8599130D19BA"));
         int CreateTab(BSTR Text, out IDispatch **pControl);
        int Controls(out IDispatch **pVal);
        int ActiveControl(out IDispatch **pVal);
        int ActiveControl(IDispatch *newVal);
        int ActiveControl(IDispatch *newVal);
        int Buttons(out VARIANT_BOOL *pVal);
        int Buttons(VARIANT_BOOL newVal);
        int MultiLine(out VARIANT_BOOL *pVal);
        int MultiLine(VARIANT_BOOL newVal);
        int HotTrack(out VARIANT_BOOL *pVal);
        int HotTrack(VARIANT_BOOL newVal);
        int FlatButtons(out VARIANT_BOOL *pVal);
        int FlatButtons(VARIANT_BOOL newVal);
        int RaggedRight(out VARIANT_BOOL *pVal);
        int RaggedRight(VARIANT_BOOL newVal);
        int TabWidth(out int *pVal);
        int TabWidth(int newVal);
        int ItemIndex(out int *pVal);
        int ItemIndex(int newVal);
        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int TabsVisible(out VARIANT_BOOL *pVal);
        int TabsVisible(VARIANT_BOOL newVal);
};
interface ToolBar: Control
{
	mixin(uuid("EE439DC1-D255-41A8-94E4-0E2F5518562D"));
        int Buttons(out IDispatch **pVal);
        int Buttons(IDispatch *newVal);
        int Buttons(IDispatch *newVal);
        int Flat(out VARIANT_BOOL *pVal);
        int Flat(VARIANT_BOOL newVal);
        int ShowText(out VARIANT_BOOL *pVal);
        int ShowText(VARIANT_BOOL newVal);
        int ButtonWidth(out uint *pVal);
        int ButtonWidth(uint newVal);
        int ButtonHeight(out uint *pVal);
        int ButtonHeight(uint newVal);
        int AutoSizeButtons(out VARIANT_BOOL *pVal);
        int AutoSizeButtons(VARIANT_BOOL newVal);
        int List(out VARIANT_BOOL *pVal);
        int List(VARIANT_BOOL newVal);
        int Wrapable(out VARIANT_BOOL *pVal);
        int Wrapable(VARIANT_BOOL newVal);
        int AutoSize(out VARIANT_BOOL *pVal);
        int AutoSize(VARIANT_BOOL newVal);
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
};
interface MenuBar: Control
{
	mixin(uuid("CD1140FE-95CD-4690-8DB9-48DF5989E8FA"));
        int Menu(out IDispatch **pVal);
        int Menu(IDispatch *newVal);
        int Menu(IDispatch *newVal);
};
interface ReBarBand: IDispatch
{
	mixin(uuid("5FFD779C-DF3C-4B7C-BA33-53ED4BE00360"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int Color(out int *pVal);
        int Color(int newVal);
        int ParentColor(out VARIANT_BOOL *pVal);
        int ParentColor(VARIANT_BOOL newVal);
        int Image(VARIANT newVal);
        int ParentImage(out VARIANT_BOOL *pVal);
        int ParentImage(VARIANT_BOOL newVal);
        int FixedImage(out VARIANT_BOOL *pVal);
        int FixedImage(VARIANT_BOOL newVal);
        int FixedSize(out VARIANT_BOOL *pVal);
        int FixedSize(VARIANT_BOOL newVal);
        int Break(out VARIANT_BOOL *pVal);
        int Break(VARIANT_BOOL newVal);
        int GripperAlways(out VARIANT_BOOL *pVal);
        int GripperAlways(VARIANT_BOOL newVal);
        int Locked(out VARIANT_BOOL *pVal);
        int Locked(VARIANT_BOOL newVal);
        int Chevron(out VARIANT_BOOL *pVal);
        int Chevron(VARIANT_BOOL newVal);
}
interface ReBar: Frame
{
	mixin(uuid("DBD8984A-5CB5-4B3B-94DE-62AF0C20F75F"));
        int Locked(out VARIANT_BOOL *pVal);
        int Locked(VARIANT_BOOL newVal);
        int InsertNewRow(out VARIANT_BOOL *pVal);
        int InsertNewRow(VARIANT_BOOL newVal);
        int Band(IDispatch *Control, out IDispatch **pVal);
        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int Image(VARIANT newVal);
        int FixedOrder(out VARIANT_BOOL *pVal);
        int FixedOrder(VARIANT_BOOL newVal);
        int VarHeight(out VARIANT_BOOL *pVal);
        int VarHeight(VARIANT_BOOL newVal);
        int BandBorders(out VARIANT_BOOL *pVal);
        int BandBorders(VARIANT_BOOL newVal);
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int DblClkToggle(out VARIANT_BOOL *pVal);
        int DblClkToggle(VARIANT_BOOL newVal);
        int VerticalGripper(out VARIANT_BOOL *pVal);
        int VerticalGripper(VARIANT_BOOL newVal);
        int AutoLayout(out VARIANT_BOOL *pVal);
        int AutoLayout(VARIANT_BOOL newVal);
};
interface HyperLink: Control
{
	mixin(uuid("ED777BB6-9999-4385-8647-8C72156DC3A1"));
        int URL(out BSTR *pVal);
        int URL(BSTR newVal);
};
interface Pager: Frame
{
	mixin(uuid("AD4463D6-4144-4D08-9A41-A296E6264F32"));
        int Control(out IDispatch **pVal);
        int Control(IDispatch *newVal);
        int Control(IDispatch *newVal);
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int ButtonSize(out uint *pVal);
        int ButtonSize(uint newVal);
        int Position(out int *pVal);
        int Position(int newVal);
};
interface COMConnectionPoint: IObject
{
	mixin(uuid("701F8D53-90B9-4D99-96A2-37C8BB960289"));
        int ID(out BSTR *pVal);
        int Name(out BSTR *pVal);
        int Text(out BSTR *pVal);
}
interface COMEvents: IObject
{
	mixin(uuid("DC2EF81F-A8DF-488D-89C9-DCC67D7B0EE8"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(VARIANT Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
};
interface ActiveXControl:Control
{
	mixin(uuid("FF57FCA7-3701-47A2-B309-3C0F5A581CB1"));
        int Control(out IDispatch **pVal);
        int Events(out IDispatch **pVal);
};
interface HeaderItem: IObject
{
	mixin(uuid("76B856CD-223D-4728-BA49-DCB111DAAA9D"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int Width(out int *pVal);
        int Width(int newVal);
        int TextAlign(out int *pVal);
        int TextAlign(int newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int DataType(out int *pVal);
        int DataType(int newVal);
        int SortType(out int *pVal);
        int SortType(int newVal);
        int Index(out int *pVal);
        int Owner(out IDispatch **pVal);
        int OnClick(VARIANT newVal);
        int OnResize(VARIANT newVal);

        int OnBeginTrack(VARIANT newVal);

        int OnTrack(VARIANT newVal);

        int OnDividerDblClick(VARIANT newVal);

};
interface Header:Control
{
	mixin(uuid("F1901A02-8CA0-4446-AC10-D8E9B6A9E573"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
         int Remove(VARIANT Index); 
         int Clear(); 
         int Add(BSTR Text,int Width /*= 100*/, int TextAlign /*= AL_LEFT*/, out IDispatch **pItem);
        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int HotTrack(out VARIANT_BOOL *pVal);
        int HotTrack(VARIANT_BOOL newVal);
        int Flat(out VARIANT_BOOL *pVal);
        int Flat(VARIANT_BOOL newVal);
        int OnColumnClick(VARIANT newVal);
        int OnColumnResize(VARIANT newVal);
};
interface ListItem:IDispatch
{
	mixin(uuid("1FEE927E-CC8A-4DC0-9B40-E4113CDE5DA9"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int Selected(out VARIANT_BOOL *pVal);
        int Selected(VARIANT_BOOL newVal);
        int Checked(out VARIANT_BOOL *pVal);
        int Checked(VARIANT_BOOL newVal);
        int SubItems(int Index, out BSTR *pVal);
        int SubItems(int Index, BSTR newVal);
        int SubItemImage(int Index, out int *pVal);
        int SubItemImage(int Index, int newVal);
        int Index(out int *pVal);
        int UserData(out VARIANT *pVal);
        int UserData(VARIANT newVal);
}
interface ListViewColumns:IDispatch
{
	mixin(uuid("1A015BF1-FDE4-49FF-85AE-A142E1239B16"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
         int Remove(VARIANT Index); 
         int Clear(); 
         int Add(BSTR Text,int Width /*= 100*/, int TextAlign /*= AL_LEFT*/, out IDispatch **pItem);
        int Visible(out VARIANT_BOOL *pVal);
        int Visible(VARIANT_BOOL newVal);
        int Flat(out VARIANT_BOOL *pVal);
        int Flat(VARIANT_BOOL newVal);
}
interface ListView: Control
{
	mixin(uuid("98763204-A34A-4206-9151-8DDF2445F52B"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
        int Count(long newVal);
         int Add(BSTR Text, out IDispatch **pItem);
         int Insert(int Index, BSTR Text, out IDispatch **pItem);
         int Remove(int Index);
         int Clear(); 

         int BeginUpdate(); 
         int EndUpdate(); 
         int SelectAll();
         int ClearSelection();
         int EditItem(int Index);
         int Sort(int DataType /*= DT_STRING*/, VARIANT_BOOL Reverse /*= FALSE*/,  uint Column /*= 0*/);

        int LargeImages(out IDispatch **pVal);
        int LargeImages(IDispatch *newVal);
        int LargeImages(IDispatch *newVal);
        int SmallImages(out IDispatch **pVal);
        int SmallImages(IDispatch *newVal);
        int SmallImages(IDispatch *newVal);
        int StateImages(out IDispatch **pVal);
        int StateImages(IDispatch *newVal);
        int StateImages(IDispatch *newVal);
        int Style(out int *pVal);
        int Style(int newVal);
        int TextBkColor(out uint *pVal);
        int TextBkColor(uint newVal);
        int MultiSelect(out VARIANT_BOOL *pVal);
        int MultiSelect(VARIANT_BOOL newVal);
        int HideSelection(out VARIANT_BOOL *pVal);
        int HideSelection(VARIANT_BOOL newVal);
        int SelCount(out int *pVal);
        int ItemIndex(out int *pVal);
        int ItemIndex(int newVal);
        int Columns(out IDispatch **pVal);
        int CheckBoxes(out VARIANT_BOOL *pVal);
        int CheckBoxes(VARIANT_BOOL newVal);
        int GridLines(out VARIANT_BOOL *pVal);
        int GridLines(VARIANT_BOOL newVal);
        int HotTrack(out VARIANT_BOOL *pVal);
        int HotTrack(VARIANT_BOOL newVal);
        int RowSelect(out VARIANT_BOOL *pVal);
        int RowSelect(VARIANT_BOOL newVal);
        int BorderSelect(out VARIANT_BOOL *pVal);
        int BorderSelect(VARIANT_BOOL newVal);
        int FlatScrollBars(out VARIANT_BOOL *pVal);
        int FlatScrollBars(VARIANT_BOOL newVal);
        int OwnerData(out VARIANT_BOOL *pVal);
        int OwnerData(VARIANT_BOOL newVal);
        int ReadOnly(out VARIANT_BOOL *pVal);
        int ReadOnly(VARIANT_BOOL newVal);
        int WrapText(out VARIANT_BOOL *pVal);
        int WrapText(VARIANT_BOOL newVal);
        int Arrangement(out int *pVal);
        int Arrangement(int newVal);
        int OnColumnClick(VARIANT newVal);
        int OnColumnResize(VARIANT newVal);
        int OnData(VARIANT newVal);
        int OnItemCheck(VARIANT newVal);
        int OnEdited(VARIANT newVal);
};
interface TreeItem:IDispatch
{
	mixin(uuid("FFFF9989-481D-4921-949C-B283BD06CB44"));
        int _NewEnum(out
        LPUNKNOWN *pUnk);
        int Item(long Index,
        out VARIANT *pvar);
        int Count(out long *pcount);
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int SelectedImageIndex(out int *pVal);
        int SelectedImageIndex(int newVal);
        int Selected(out VARIANT_BOOL *pVal);
        int Selected(VARIANT_BOOL newVal);
        int Expanded(out VARIANT_BOOL *pVal);
        int Expanded(VARIANT_BOOL newVal);
        int Bold(out VARIANT_BOOL *pVal);
        int Bold(VARIANT_BOOL newVal);
        int Checked(out VARIANT_BOOL *pVal);
        int Checked(VARIANT_BOOL newVal);
        int HasChildren(out VARIANT_BOOL *pVal);
         int Add(BSTR Text, int ImageIndex /*=-1*/, int SelectedImageIndex /*=-1*/, out IDispatch **pItem);
         int Insert(int Index, BSTR Text, int ImageIndex /*=-1*/, int SelectedImageIndex /*=-1*/, out IDispatch **pItem);
         int Remove(int Index /*= TREEVIEW_THISITEM*/);
         int Clear(); 
         int Expand(VARIANT_BOOL Recurse /*= FALSE*/); 
         int Collapse(); 
         int EditLabel();
         int Sort(VARIANT_BOOL Recurse /*= TRUE*/);
         int MakeVisible();
        int Parent(out IDispatch **pVal);
        int NextSibling(out IDispatch **pVal);
        int PrevSibling(out IDispatch **pVal);
        int FirstChild(out IDispatch **pVal);
        int LastChild(out IDispatch **pVal);
        int UserData(out VARIANT *pVal);
        int UserData(VARIANT newVal);
}
interface TreeView: Control
{
	mixin(uuid("A6034589-820F-4165-9EEE-AE1E97BFB9B1"));
        int Items(out IDispatch **pVal);
        int SelectedItem(out IDispatch **pVal);
        int TopItem(out IDispatch **pVal);
        int Count(out long *pcount);
         int BeginUpdate(); 
         int EndUpdate();

        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int StateImages(out IDispatch **pVal);
        int StateImages(IDispatch *newVal);
        int StateImages(IDispatch *newVal);

        int HasButtons(out VARIANT_BOOL *pVal);
        int HasButtons(VARIANT_BOOL newVal);
        int HasLines(out VARIANT_BOOL *pVal);
        int HasLines(VARIANT_BOOL newVal);
        int LinesAtRoot(out VARIANT_BOOL *pVal);
        int LinesAtRoot(VARIANT_BOOL newVal);
        int ReadOnly(out VARIANT_BOOL *pVal);
        int ReadOnly(VARIANT_BOOL newVal);
        int CheckBoxes(out VARIANT_BOOL *pVal);
        int CheckBoxes(VARIANT_BOOL newVal);
        int HotTrack(out VARIANT_BOOL *pVal);
        int HotTrack(VARIANT_BOOL newVal);
        int RowSelect(out VARIANT_BOOL *pVal);
        int RowSelect(VARIANT_BOOL newVal);
        int HideSelection(out VARIANT_BOOL *pVal);
        int HideSelection(VARIANT_BOOL newVal);
        int AutoExpand(out VARIANT_BOOL *pVal);
        int AutoExpand(VARIANT_BOOL newVal);

        int OnEdited(VARIANT newVal);
        int OnExpanding(VARIANT newVal);
        int OnExpanded(VARIANT newVal);
        int OnCollapsing(VARIANT newVal);
        int OnCollapsed(VARIANT newVal);
}
interface UpDown: StatusControl
{
	mixin(uuid("F09EE7EC-728F-4D8B-AE8E-0F5A113FD36E"));
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int HotTrack(out VARIANT_BOOL *pVal);
        int HotTrack(VARIANT_BOOL newVal);
};
interface TrackBar: StatusControl
{
	mixin(uuid("D47DC012-3D4E-4412-8A06-E747160435E0"));
        int Vertical(out VARIANT_BOOL *pVal);
        int Vertical(VARIANT_BOOL newVal);
        int TickMarks(out int *pVal);
        int TickMarks(in/*range(-1,2)]*/ int newVal);       
        int SmallChange(out uint *pVal);
        int SmallChange(uint newVal);
        int LargeChange(out uint *pVal);
        int LargeChange(uint newVal);
        int ThumbLength(out uint *pVal);
        int ThumbLength(uint newVal);       
        int TickFrequency(out uint *pVal);
        int TickFrequency(uint newVal);     
        int EnableSelRange(out VARIANT_BOOL *pVal);
        int EnableSelRange(VARIANT_BOOL newVal);
        int SelStart(out int *pVal);
        int SelStart(int newVal);
        int SelEnd(out int *pVal);
        int SelEnd(int newVal);
         int SelectAll();
         int ClearSelection();
}
interface Animate: Control
{
	mixin(uuid("CD27766E-91BF-4D27-BA1E-CBFE3CB55BD1"));
         int Open(VARIANT newVal, VARIANT_BOOL StartPlay /*= FALSE*/, out VARIANT_BOOL *pResult);
         int Play();
         int Stop();
         int Close();
         int Seek(int Position);
        int AutoRepeat(out VARIANT_BOOL *pVal);
        int AutoRepeat(VARIANT_BOOL newVal);
        int Transparent(out VARIANT_BOOL *pVal);
        int Transparent(VARIANT_BOOL newVal);
        int Center(out VARIANT_BOOL *pVal);
        int Center(VARIANT_BOOL newVal);
};
interface HotKey: Control
{
	mixin(uuid("E9013635-B5D5-48D7-81A4-41D3AFF5A717"));
        int Key(out VARIANT *pVal);
        int Key(VARIANT newVal);
        int InvalidKeys(out int *pVal);
        int InvalidKeys(int newVal);
        int DefaultKey(out VARIANT *pVal);
        int DefaultKey(VARIANT newVal);
}
interface IPAddress: Control
{
	mixin(uuid("CCC32DB0-A7E0-4947-A757-9534AB58027F"));
        int Value(out uint *pVal);
        int Value(uint newVal);
         int SetRange(/*[in,range(0,3)]*/ int Index, ubyte Min, ubyte Max);    
        int IsBlank(out VARIANT_BOOL *pVal);
}
interface DateTime: IDispatch
{
	mixin(uuid("E5197962-B022-4902-B92C-B46F2CCC8875"));
        int Value(out double *pVal);
        int Value(double newVal);
        int Year(out ushort *pVal);
        int Year(ushort newVal);
        int Month(out ushort *pVal);
        int Month(ushort newVal);
        int Day(out ushort *pVal);
        int Day(ushort newVal);
        int Hour(out ushort *pVal);
        int Hour(ushort newVal);
        int Minute(out ushort *pVal);
        int Minute(ushort newVal);
        int Second(out ushort *pVal);
        int Second(ushort newVal);
        int Milliseconds(out ushort *pVal);
        int Milliseconds(ushort newVal);
}
interface DateTimeControl: Control
{
	mixin(uuid("0E53C57C-CAC1-4290-8C57-559AD095F9F3"));
        int Value(out IDispatch **pVal);
        int Min(out IDispatch **pVal);
        int Max(out IDispatch **pVal);
}
interface DateTimePicker: DateTimeControl
{
	mixin(uuid("7FCABADD-F460-4049-ABBC-79821C613284"));
        int Style(out uint *pVal);
        int Style(uint newVal);
        int ShowCheckBox(out VARIANT_BOOL *pVal);
        int ShowCheckBox(VARIANT_BOOL newVal);
        int ShowUpDown(out VARIANT_BOOL *pVal);
        int ShowUpDown(VARIANT_BOOL newVal);
        int DropDownRightAlign(out VARIANT_BOOL *pVal);
        int DropDownRightAlign(VARIANT_BOOL newVal);
        int CustomFormat(out BSTR *pVal);
        int CustomFormat(BSTR newVal);
}
interface Calendar: DateTimeControl
{
	mixin(uuid("EE27A882-AD8E-4723-AAA9-E10CFD472F75"));
        int MultiSelect(out VARIANT_BOOL *pVal);
        int MultiSelect(VARIANT_BOOL newVal);
        int SelEnd(out IDispatch **pVal);
        int SelStart(out IDispatch **pVal);
        int Today(out IDispatch **pVal);
        int MonthDelta(out uint *pVal);
        int MonthDelta(uint newVal);
        int MaxSelCount(out uint *pVal);
        int MaxSelCount(uint newVal);
        int TodayText(out VARIANT_BOOL *pVal);
        int TodayText(VARIANT_BOOL newVal);
        int TodayCircle(out VARIANT_BOOL *pVal);
        int TodayCircle(VARIANT_BOOL newVal);
        int WeekNumbers(out VARIANT_BOOL *pVal);
        int WeekNumbers(VARIANT_BOOL newVal);
}
interface Splitter: Control
{
	mixin(uuid("76A49C6D-284D-45F0-856E-6E9714281AC5"));
}
interface Polygon: Control
{
	mixin(uuid("01F209D7-27B9-41CD-8DAE-0DAF2875A8FA"));
        int FillAll(out VARIANT_BOOL *pVal);
        int FillAll(VARIANT_BOOL newVal);
}
interface Image: Control
{
	mixin(uuid("DAF6D7B8-1AB3-4DAC-8BDA-4E5234AD8731"));
        int DrawType(out uint *pVal);
        int DrawType(uint newVal);
        int CopyMode(out uint *pVal);
        int CopyMode(uint newVal);
};
interface Line: Control
{
	mixin(uuid("D6D9AAA2-739F-4807-814E-0E7692E18E62"));
        int X(int Index, out int *pVal);
        int X(int Index, int newVal);
        int Y(int Index, out int *pVal);
        int Y(int Index, int newVal);
}
interface PrintDialogBase : IDispatch{
	mixin(uuid("0E609193-AF42-4ECC-9897-4F279B659D1F"));
        int Driver(out BSTR *pVal);
        int Device(out BSTR *pVal);
        int Port(out BSTR *pVal);
}
interface PrintDialog : PrintDialogBase{
	mixin(uuid("A48A739A-BAAF-4693-B8AE-B594065B8D17"));
        int Copies(out int *pVal);
        int Collate(out VARIANT_BOOL *pVal);
        int Selection(out VARIANT_BOOL *pVal);
        int All(out VARIANT_BOOL *pVal);
        int Range(out VARIANT_BOOL *pVal);
        int ToFile(out VARIANT_BOOL *pVal);
        int FromPage(out int *pVal);
        int ToPage(out int *pVal);
}
interface PageSetupDialog : PrintDialogBase{
	mixin(uuid("740AE358-3778-4F25-89E8-CAE218F9F14C"));
        int PaperWidth(out int *pVal);
        int PaperHeight(out int *pVal);
        int LeftMargin(out int *pVal);
        int RightMargin(out int *pVal);
        int TopMargin(out int *pVal);
        int BottomMargin(out int *pVal);
}
interface FindReplaceDialog : IObject{
	mixin(uuid("A156794D-9CF8-4AC9-84B8-D657F8ECCAF1"));
        int FindText(out BSTR *pVal);
        int ReplaceText(out BSTR *pVal);
        int SearchDown(out VARIANT_BOOL *pVal);
        int MatchCase(out VARIANT_BOOL *pVal);
        int WholeWord(out VARIANT_BOOL *pVal);  
         int Close();       
        int OnFind(VARIANT newVal);
        int OnReplace(VARIANT newVal);
        int OnReplaceAll(VARIANT newVal);
        int OnClose(VARIANT newVal);
        int OnHelp(VARIANT newVal);
};

interface FontDialog : IObject{
	mixin(uuid("7C57CB6F-E98B-4E58-9813-DD46E590B79B"));
        int Flags(out uint *pVal);
        int Flags(uint newVal);

        int Font(out IDispatch **pVal);
        int Font(IDispatch *newVal);
        int Font(IDispatch *newVal);

         int Execute(out VARIANT_BOOL *pResult);

        int OnHelp(VARIANT newVal);

        int OnApply(VARIANT newVal);
};

interface ColorDialog : IObject{
	mixin(uuid("5A8CE32D-69D3-45F1-BE74-531AEBA638DB"));
        int Flags(out uint *pVal);
        int Flags(uint newVal);

        int Color(out uint *pVal);
        int Color(uint newVal);

         int Execute(out VARIANT_BOOL *pResult);

        int OnHelp(VARIANT newVal);
};


interface FileOpenSaveDialog: IObject
{
	mixin(uuid("B7ED6BDC-9791-4B8F-979E-990CD76A394A"));
        int DefaultExt(out BSTR *pVal);
        int DefaultExt(BSTR newVal);
        int Filter(out BSTR *pVal);
        int Filter(BSTR newVal);
        int FileName(out BSTR *pVal);
        int FileName(BSTR newVal);
        int Flags(out uint *pVal);
        int Flags(uint newVal);
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int FilterIndex(out uint *pVal);
        int FilterIndex(uint newVal);
        int Directory(out BSTR *pVal);
        int Directory(BSTR newVal);
         int Execute(out VARIANT_BOOL *pResult);
        int OnCloseQuery(VARIANT newVal);
        int OnChange(VARIANT newVal);
        int OnFolderChange(VARIANT newVal);
        int OnTypeChange(VARIANT newVal);
        int OnHelp(VARIANT newVal);
}
interface Timer : IObject{
	mixin(uuid("A70DBA20-F39F-4B55-BC04-7E5FE2C495B7"));
        int Active(out VARIANT_BOOL *pVal);
        int Active(VARIANT_BOOL newVal);
        int Interval(out uint *pVal);
        int Interval(uint newVal);
        int OnExecute(VARIANT newVal);
};
interface TrayIcon : IObject{
	mixin(uuid("4AAC7C83-5BF6-44A6-AD8A-FD431D23DD79"));
        int Active(out VARIANT_BOOL *pVal);
        int Active(VARIANT_BOOL newVal);
        int Images(out IDispatch **pVal);
        int Images(IDispatch *newVal);
        int Images(IDispatch *newVal);
        int ImageIndex(out int *pVal);
        int ImageIndex(int newVal);
        int Hint(out BSTR *pVal);
        int Hint(BSTR newVal);
        int PopupMenu(out IDispatch **pVal);
        int PopupMenu(IDispatch *newVal);
        int PopupMenu(IDispatch *newVal);
        int OnClick(VARIANT newVal);
        int OnDblClick(VARIANT newVal);
        int OnMouseDown(VARIANT newVal);
        int OnMouseUp(VARIANT newVal);
};
interface Result : IDispatch
{
	mixin(uuid("50B60E8E-E889-46DB-88D8-09A416726824"));
         int Put(VARIANT newVal);
        int Value(out VARIANT *pVal);
        int Value(VARIANT newVal);
};

//Events
interface ControlEvents : IDispatch
{
	mixin(uuid("CCF521F3-D5AA-4CE2-BD3D-1B4D05A8BE1A"));
                int OnClick(IDispatch *Sender);
                int OnDblClick(IDispatch *Sender, int x,int y,int Button,int Flags);
                int OnChange(IDispatch *Sender);
                int OnKeyDown(IDispatch *Sender, int Key, int Flags);
                int OnKeyUp(IDispatch *Sender, int Key, int Flags);
                int OnMouseEnter(IDispatch *Sender);
                int OnMouseLeave(IDispatch *Sender);
                int OnMouseDown(IDispatch *Sender, int x,int y,int Button,int Flags);
                int OnMouseMove(IDispatch *Sender, int x,int y,int Flags);
                int OnMouseUp(IDispatch *Sender, int x,int y,int Button,int Flags);
                int OnResize(IDispatch *Sender);
                int OnMove(IDispatch *Sender);
                int OnDestroy(IDispatch *Sender);
                int OnShow(IDispatch *Sender);
                int OnHide(IDispatch *Sender);
                int OnEnabledChange(IDispatch *Sender);
                int OnSetFocus(IDispatch *Sender);
                int OnKillFocus(IDispatch *Sender);
};
interface FormEvents : ControlEvents
{
	mixin(uuid("1198D8CE-DCE6-4C9E-8CFF-CF0E3AB7DE87"));
                int OnCloseQuery(IDispatch *Sender, IDispatch *ResultPtr);
                int OnClose(IDispatch *Sender);
                int OnActiveControlChange(IDispatch *Sender);
                int OnHitTest(IDispatch *Sender, int x, int y, IDispatch *ResultPtr);
                int OnHint(IDispatch *Sender, IDispatch *Object);
};
interface ActionEvents : IDispatch
{
	mixin(uuid("F2C5B01B-E77C-411A-A958-7E77A8DA912F"));
                int OnExecute(IDispatch *Sender);
                int OnUpdate(IDispatch *Sender);
}
interface TimerEvents : IDispatch
{
	mixin(uuid("076A1D13-7601-477A-98BB-45E6328360DE"));
                int OnExecute(IDispatch *Sender);
}
interface HeaderItemEvents : IDispatch
{
	mixin(uuid("AF9F723A-C078-431B-8723-AAB704905048"));
                int OnClick(IDispatch *Sender);
                int OnResize(IDispatch *Sender);

                int OnBeginTrack(IDispatch *Sender, int Button, IDispatch *ResultPtr);

                int OnTrack(IDispatch *Sender, int Width, int Button, IDispatch *ResultPtr);

                int OnDividerDblClick(IDispatch *Sender, IDispatch *ResultPtr);
}
interface HeaderEvents : ControlEvents
{
	mixin(uuid("0CEF5413-315F-4FA8-B961-F7F04F8393A8"));
                int OnColumnClick(IDispatch *Sender, IDispatch *Item);
                int OnColumnResize(IDispatch *Sender, IDispatch *Item);
}
interface ListViewEvents : HeaderEvents
{
	mixin(uuid("F8233D5A-7BE6-48C7-8B44-E61345BBDF5A"));
                int OnData(IDispatch *Sender, IDispatch *Item);
                int OnItemCheck(IDispatch *Sender, IDispatch *Item);
                int OnEdited(IDispatch *Sender, IDispatch *Item, Result *NewText);
}
interface TreeViewEvents : ControlEvents
{
	mixin(uuid("555949AA-0922-4BF3-926A-9DAA912861A2"));
                int OnEdited(IDispatch *Sender, IDispatch *Item, Result *NewText);
                int OnExpanding(IDispatch *Sender, IDispatch *Item);
                int OnExpanded(IDispatch *Sender, IDispatch *Item);
                int OnCollapsing(IDispatch *Sender, IDispatch *Item);
                int OnCollapsed(IDispatch *Sender, IDispatch *Item);
}

interface RichEditEvents : ControlEvents
{
	mixin(uuid("5B691737-293F-421D-87DA-E810555C8459"));
                int OnSelChange(IDispatch *Sender);
}
interface FindReplaceDialogEvents : IDispatch
{
	mixin(uuid("0FBA8E33-6938-4E38-97ED-DD9DF0248306"));
                int OnFind(IDispatch *Sender);
                int OnReplace(IDispatch *Sender);
                int OnReplaceAll(IDispatch *Sender);
                int OnClose(IDispatch *Sender);
                int OnHelp(IDispatch *Sender);
}
interface FileOpenSaveDialogEvents : IDispatch
{
	mixin(uuid("ED303EB3-B7F9-493B-BE0E-265D20F80E38"));
                int OnCloseQuery(IDispatch *Sender, IDispatch *ResultPtr);
                int OnChange(IDispatch *Sender);
                int OnFolderChange(IDispatch *Sender);
                int OnTypeChange(IDispatch *Sender);           
                int OnHelp(IDispatch *Sender);
}
interface TrayIconEvents : IDispatch
{
	mixin(uuid("C191A5DF-072B-4331-9A83-3E985716730A"));
                int OnClick(IDispatch *Sender);
                int OnDblClick(IDispatch *Sender, int x,int y,int Button,int Flags);
                int OnMouseDown(IDispatch *Sender, int x,int y,int Button,int Flags);
                int OnMouseUp(IDispatch *Sender, int x,int y,int Button,int Flags);
};

interface EventHandlerEvents : IDispatch
{
	mixin(uuid("7E144038-C33F-4F65-8CE2-B833F4773101"));
                int OnExecute(IDispatch *Sender);
};

interface FontDialogEvents : IDispatch
{
	mixin(uuid("9C2C742B-33B5-4BCF-AEB9-640DF4D94374"));
                int OnHelp(IDispatch *Sender);

                int OnApply(IDispatch *Sender);
};

interface ColorDialogEvents : IDispatch
{
	mixin(uuid("B7B784F7-A097-4D24-BE47-E9842A532192"));

                int OnHelp(IDispatch *Sender);
};


//Extended Objects
interface Regions : IDispatch{
	mixin(uuid("179741BD-E3DA-4A18-B9C1-039785089B03"));
         int CombineRgn(uint hrgnSrc1, uint hrgnSrc2, int fnCombineMode, out IDispatch **pRegion);
         int CreateEllipticRgn(int Left, int Top, int Width, int Height, out IDispatch **pRegion);
       //  int CreatePolygonRgn(SAFEARRAY(VARIANT) Data, out IDispatch **pRegion);
         int CreateRectRgn(int Left, int Top, int Width, int Height, out IDispatch **pRegion);
         int CreateRoundRectRgn(int Left, int Top, int Width, int Height, int nWidthEllipse, int nHeightEllipse, out IDispatch **pRegion);
         int TransformRgn(uint ARegion, float eM11, float eM12, float eM21, float eM22, float eDx, float eDy, out IDispatch **pRegion);
         int EqualRgn(uint hSrcRgn1, uint hSrcRgn2, out VARIANT_BOOL *pResult);

         int CreateRgnFromImage(VARIANT Image, uint MaskColor, out IDispatch **Region);

};
interface Region : IDispatch{
	mixin(uuid("BB9FCB6F-2C14-4568-BADF-E7C0B022A654"));
        int Value(out uint *pVal);
};
interface Screen : IDispatch{
	mixin(uuid("D0D86627-9E34-438F-92E2-8EC9C1ABE8C5"));
        int Width(out int *pVal);
        int Height(out int *pVal);
        int PixelsPerInchX(out int *pVal);
        int PixelsPerInchY(out int *pVal);
};
interface Hint : IDispatch{
	mixin(uuid("00017030-B197-4EBC-804F-748CF210108E"));
        int Text(out BSTR *pVal);
        int Text(BSTR newVal);
        int Title(out BSTR *pVal);
        int Title(BSTR newVal);
        int Image(out int *pVal);
        int Image(int newVal);
        int Visible(out VARIANT_BOOL *pVal);
        int Visible(VARIANT_BOOL newVal);
        int Balloon(out VARIANT_BOOL *pVal);
        int Balloon(VARIANT_BOOL newVal);
        int AlwaysTip(out VARIANT_BOOL *pVal);
        int AlwaysTip(VARIANT_BOOL newVal);
        int NoPrefix(out VARIANT_BOOL *pVal);
        int NoPrefix(VARIANT_BOOL newVal);
        int MaxWidth(out int *pVal);
        int MaxWidth(int newVal);
        int ParentData(out VARIANT_BOOL *pVal);
        int ParentData(VARIANT_BOOL newVal);
};


interface EventHandler : IObject{
	mixin(uuid("5273BA8F-609D-4959-9A72-92AD3EADA060"));

         int Execute();

        int OnExecute(VARIANT newVal);
}

interface WindowSystemObjectExtensions : IDispatch{
	mixin(uuid("1DD6DE1E-DB95-45FE-B2A8-655177B8E8DB"));
         int SendMessage(VARIANT Control, int Message, int wParam, VARIANT lParam, out VARIANT *pVal);

         int PostMessage(VARIANT Control, int Message, int wParam, VARIANT lParam, out VARIANT *pVal);

         int AddMessageHandler(IDispatch *Control, int Message, VARIANT MessageHandler);
};

interface PrintInfo : IObject{
	mixin(uuid("98C54138-A5B8-41AC-BDA6-D404983C28C6"));

        int DocumentName(out BSTR *pVal);
        int DocumentName(BSTR newVal);

        int LeftMargin(out int *pVal);
        int LeftMargin(int newVal);
        
        int RightMargin(out int *pVal);
        int RightMargin(int newVal);

        int TopMargin(out int *pVal);
        int TopMargin(int newVal);

        int BottomMargin(out int *pVal);
       int BottomMargin(int newVal);

        int MarginMeasurement(out int *pVal);
        int MarginMeasurement(int newVal);
         
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
