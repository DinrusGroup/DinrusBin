// *Converted to D by Vitaly Kulich */
module os.win.tlb.wso;
//WindowSystemObject (WSO) IDL file
//Copyright (C) Veretennikov A. B. 2004
import os.win.com.core;

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
const DTS_SHORTDATEFORMAT = 0x0000;
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
const DT_FLOAT = 3;
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
const CC_DEFAULT = 0;
const CF_DEFAULT =(CF_EFFECTS | CF_SCREENFONTS);
const TVS_DEFAULT  = (TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT);
const TCS_DEFAULT  =  (TCS_MULTILINE | TCS_TABS | TCS_HOTTRACK);
const RBS_DEFAULT = (RBS_VARHEIGHT | RBS_AUTOSIZE);
//End Constants

//C     interface WindowSystemObject : IDispatch{
extern (C):

interface WindowSystemObject : IDispatch{
	mixin(uuid("40CC9252-A25A-4D28-A906-9BD3F752934A"));
         HRESULT CreateForm(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height,/*in*/ LONG Style = WS_DEFAULT, out IDispatch **pControl);
         HRESULT CreateDialogForm(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height,/*in*/ LONG Style = WS_DIALOGDEFAULT, out IDispatch **pControl);
         HRESULT CreateImageList(out IDispatch **pControl);
         HRESULT CreateTimer(out IDispatch **pControl);
         HRESULT CreateCOMEvents(/*in*/ IDispatch *COMObject, out IDispatch **pControl);
         HRESULT CreateFindDialog(/*in*/ BSTR FindText = "", /*in*/ ULONG Flags = FR_DOWN, out IDispatch **pResult);
         HRESULT CreateReplaceDialog(/*in*/ BSTR FindText = "", BSTR ReplaceText = "", /*in*/ ULONG Flags = FR_DOWN, out IDispatch **pResult);
         HRESULT CreateTrayIcon(out IDispatch **pControl);
         HRESULT Run(void);
         HRESULT Stop(void);
        /*[propget]*/ HRESULT Controls(out IDispatch **pVal);
         HRESULT Translate(/*in*/ BSTR Text, out VARIANT *pResult);
         HRESULT LoadImage(/*in*/ BSTR Path, out IDispatch **pResult);
        /*[propget]*/ HRESULT Version(out IDispatch **pVal);
        /*[propget]*/ HRESULT Debug(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Debug(/*in*/ VARIANT_BOOL newVal);
         HRESULT About(void);
        /*[propget]*/ HRESULT Regions(out IDispatch **pVal);
        /*[propget]*/ HRESULT PixelsPerInch(out LONG *pVal);
        /*[propput]*/ HRESULT PixelsPerInch(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Screen(out IDispatch **pVal);

         HRESULT CreateEventHandler(out IDispatch **pControl);

        /*[propget]*/ HRESULT EnableVisualStyles(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT EnableVisualStyles(/*in*/ VARIANT_BOOL newVal);

         HRESULT CreatePrintInfo(out IDispatch **pControl);
};
interface Version : IDispatch
{ mixin(uuid("AC444C04-F889-47E1-B56E-9F648D8AB009"));
        /*[propget]*/ HRESULT Major(out LONG *pVal);
        /*[propget]*/ HRESULT Minor(out LONG *pVal);
        /*[propget]*/ HRESULT String(out BSTR *pVal);
        /*[propget]*/ HRESULT Trial(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT Url(out BSTR *pVal);
}
interface Object: IDispatch
{
	 mixin(uuid("AADDFAA1-E50D-4C66-8955-DFE8CF54FABB"));
        /*[propget]*/ HRESULT Type(out BSTR *pVal);
        /*[propget]*/ HRESULT UserData(out VARIANT *pVal);
        /*[propput]*/ HRESULT UserData(/*in*/ VARIANT newVal);
         HRESULT AddEventHandler(BSTR EventName, /*in*/ VARIANT EventHandler);
         HRESULT RemoveEventHandler(BSTR EventName, /*in*/ VARIANT EventHandler);
}
interface Control/*: Object*/
{
	mixin(uuid("4397A1F9-F35F-4234-AF6A-F6327B0F784E"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
         HRESULT Show(void);
         HRESULT Hide(void);
        /*[propget]*/ HRESULT Visible(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Visible(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Enabled(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Enabled(/*in*/ VARIANT_BOOL newVal);
         HRESULT Destroy(void);
        /*[propget]*/ HRESULT Parent(out IDispatch **pVal);
        /*[propget]*/ HRESULT Root(out IDispatch **pVal);
        /*[propget]*/ HRESULT Form(out IDispatch **pVal);
        /*[propget]*/ HRESULT Left(out LONG *pVal);
        /*[propput]*/ HRESULT Left(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Top(out LONG *pVal);
        /*[propput]*/ HRESULT Top(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Width(out LONG *pVal);
        /*[propput]*/ HRESULT Width(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Height(out LONG *pVal);
        /*[propput]*/ HRESULT Height(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Right(out LONG *pVal);
        /*[propput]*/ HRESULT Right(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Bottom(out LONG *pVal);
        /*[propput]*/ HRESULT Bottom(/*in*/ LONG newVal);
         HRESULT SetBounds(LONG Left, LONG Top, LONG Width, LONG Height);
         HRESULT CenterControl(void);
        /*[propget]*/ HRESULT MinWidth(out USHORT *pVal);
        /*[propput]*/ HRESULT MinWidth(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT MinHeight(out USHORT *pVal);
        /*[propput]*/ HRESULT MinHeight(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT MaxWidth(out USHORT *pVal);
        /*[propput]*/ HRESULT MaxWidth(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT MaxHeight(out USHORT *pVal);
        /*[propput]*/ HRESULT MaxHeight(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Align(out USHORT *pVal);
        /*[propput]*/ HRESULT Align(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Color(out ULONG *pVal);
        /*[propput]*/ HRESULT Color(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT ParentColor(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentColor(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Font(out IDispatch **pVal);
        /*[propput]*/ HRESULT Font(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Font(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT ParentFont(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentFont(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Pen(out IDispatch **pVal);
        /*[propput]*/ HRESULT Pen(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Pen(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Brush(out IDispatch **pVal);
        /*[propput]*/ HRESULT Brush(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Brush(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT PopupMenu(out IDispatch **pVal);
        /*[propput]*/ HRESULT PopupMenu(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT PopupMenu(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Border(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Border(/*in*/ VARIANT_BOOL newVal);
         HRESULT SetFocus();
        /*[propget]*/ HRESULT Focused(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT TabOrder(out LONG *pVal);
        /*[propput]*/ HRESULT TabOrder(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT TabStop(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT TabStop(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Name(out BSTR *pVal);
        /*[propput]*/ HRESULT Name(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT ClientWidth(out LONG *pVal);
        /*[propput]*/ HRESULT ClientWidth(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ClientHeight(out LONG *pVal);
        /*[propput]*/ HRESULT ClientHeight(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Cursor(out LONG *pVal);
        /*[propput]*/ HRESULT Cursor(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Hint(out VARIANT *pVal);
        /*[propput]*/ HRESULT Hint(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnDblClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnKeyDown(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnKeyUp(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseEnter(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseLeave(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseUp(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseMove(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseDown(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnResize(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMove(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnDestroy(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnShow(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnHide(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnEnabledChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnSetFocus(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnKillFocus(/*in*/ VARIANT newVal);

         HRESULT Repaint();
}
interface Collection: IDispatch
{
	mixin(uuid("92BEFD16-E781-484B-BC2D-F3B5E5DA2CC5"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Remove(/*in*/ VARIANT Index); 
         HRESULT Clear(); 
         HRESULT ExChange(/*in*/ VARIANT A,/*in*/ VARIANT B); 
};
interface ImageList: IDispatch
{
	mixin(uuid("68343C86-0240-44FD-A24F-5CD611E0A33F"));
         HRESULT Load(/*in*/ VARIANT Image);
         HRESULT Add(/*in*/ VARIANT Image);
         HRESULT Clear(void);
         HRESULT Remove(/*in*/ LONG Index);
        /*[propget]*/ HRESULT Width(out ULONG *pVal);
        /*[propput]*/ HRESULT Width(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Height(out ULONG *pVal);
        /*[propput]*/ HRESULT Height(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Count(out LONG *pVal);
        /*[propget]*/ HRESULT BitsPerPixel(out LONG *pVal);
        /*[propput]*/ HRESULT BitsPerPixel(/*in*/ LONG newVal);
};
interface Frame: Control
{
		mixin(uuid("92337C2C-1C7D-4848-8AD2-B9D33E4EB242"));
         HRESULT CreateButton(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR Text, out IDispatch **pControl);
         HRESULT CreateCheckBox(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR Text, /*in*/ VARIANT_BOOL Checked = FALSE, out IDispatch **pControl);
         HRESULT CreateRadioButton(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR Text, out IDispatch **pControl);
         HRESULT CreateEdit(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateListBox(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateComboBox(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = CBS_DROPDOWN , out IDispatch **pControl);
         HRESULT CreateFrame(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateGroupBox(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateProgressBar(/*in*/ LONG Left, /*in*/ LONG Top , /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateTabControl(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = TCS_DEFAULT, out IDispatch **pControl);
         HRESULT CreateToolBar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateMenuBar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateReBar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = RBS_DEFAULT, out IDispatch **pControl);
         HRESULT CreateStatusBar(out IDispatch **pControl);
         HRESULT CreateHyperLink(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR URL, /*in*/ BSTR Label ="", out IDispatch **pControl);
         HRESULT CreatePager(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateScrollBar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = SBS_HORZ, out IDispatch **pControl);
         HRESULT CreateActiveXControl(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR ID, out IDispatch **pControl);
         HRESULT CreateActiveXControlLicensed(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR ID,/*in*/ BSTR LicKey, out IDispatch **pControl);
         HRESULT CreateHeader(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = HDS_BUTTONS, out IDispatch **pControl);
         HRESULT CreateListView(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateTreeView(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = TVS_DEFAULT, out IDispatch **pControl);
         HRESULT CreateRichEdit(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = ES_MULTILINE, out IDispatch **pControl);
         HRESULT CreateAnimate(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = ACS_CENTER, out IDispatch **pControl);
         HRESULT CreateHotKey(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateTrackBar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateUpDown(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateDateTimePicker(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style = 0, out IDispatch **pControl);
         HRESULT CreateCalendar(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG Style =0, out IDispatch **pControl);
         HRESULT CreateIPAddress(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT CreateSplitter(/*in*/ USHORT Align, out IDispatch **pControl);
         HRESULT Line(/*in*/ LONG Ax, /*in*/ LONG Ay, /*in*/ LONG Bx, /*in*/ LONG By, out IDispatch * *pControl);
         HRESULT Rectangle(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT RoundRect(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG nWidth, /*in*/ LONG nHeight, out IDispatch **pControl);
         HRESULT Circle(/*in*/ LONG x, /*in*/ LONG y, /*in*/ LONG r , out IDispatch **pControl);
         HRESULT Ellipse(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pControl);
         HRESULT Arc(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG nXStartArc, /*in*/ LONG nYStartArc, /*in*/ LONG nXEndArc, /*in*/ LONG nYEndArc, out IDispatch **pControl);
         HRESULT Chord(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG nXRadial1, /*in*/ LONG nYRadial1, /*in*/ LONG nXRadial2, /*in*/ LONG nYRadial2, out IDispatch **pControl);
         HRESULT Pie(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG nXRadial1, /*in*/ LONG nYRadial1, /*in*/ LONG nXRadial2, /*in*/ LONG nYRadial2, out IDispatch **pControl);
         HRESULT Polygon(/*in*/ SAFEARRAY(VARIANT) Data, out IDispatch **pControl);
         HRESULT TextOut(/*in*/ LONG x, /*in*/ LONG y, /*in*/ BSTR Text, out IDispatch **pControl);
         HRESULT TextRect(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ BSTR Text, /*in*/ ULONG Flags = (DT_NOPREFIX | DT_CENTER | DT_VCENTER | DT_WORDBREAK | DT_CALCRECT), out IDispatch **pControl);
         HRESULT DrawImage(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ VARIANT Image, out IDispatch **pControl);
         HRESULT DrawRegion(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ ULONG Region, out IDispatch **pControl);
         HRESULT Bevel(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG BevelOuter = 1, /*in*/ LONG BevelInner = 0, /*in*/ ULONG BorderWidth = 1, /*in*/ ULONG BevelWidth = 1, out IDispatch **pControl);
        /*[propget]*/ HRESULT Controls(out IDispatch **pVal);
        /*[propget]*/ HRESULT BorderWidth(out ULONG *pVal);
        /*[propput]*/ HRESULT BorderWidth(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT BevelWidth(out ULONG *pVal);
        /*[propput]*/ HRESULT BevelWidth(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT BevelOuter(out LONG *pVal);
        /*[propput]*/ HRESULT BevelOuter(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT BevelInner(out LONG *pVal);
        /*[propput]*/ HRESULT BevelInner(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT GraphFont(out IDispatch **pVal);
        /*[propput]*/ HRESULT GraphFont(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT GraphFont(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT AutoScroll(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoScroll(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Tracking(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Tracking(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CaptureMouse(out USHORT *pVal);
        /*[propput]*/ HRESULT CaptureMouse(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT ParentBackground(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentBackground(/*in*/ VARIANT_BOOL newVal);
};
interface Form : Frame
{
	mixin(uuid("044B381D-C581-4B9E-9C95-08B66B38468F"));
        /*[propput]*/ HRESULT Icon(/*in*/ BSTR FileName);     
         HRESULT Minimize(void);
         HRESULT Restore(void);
         HRESULT Maximize(void);
         HRESULT Close(void);
         HRESULT ShowModal(void);
         HRESULT MessageBox(/*in*/ BSTR Text, /*in*/ BSTR Caption = "", /*in*/ LONG Flags = 0, out LONG *pResult);
         HRESULT ColorDialog(/*in*/ ULONG StartColor = 0x00FFFFFF, /*in*/ ULONG Flags = CC_DEFAULT, out ULONG *pColor);
         HRESULT FontDialog(/*in*/ IDispatch *StartValue, /*in*/ ULONG Flags = CC_DEFAULT, out IDispatch **pResult);
         HRESULT OpenDialog(/*in*/ BSTR DefaultExt, /*in*/ BSTR Filter, /*in*/ BSTR StartFile = "", /*in*/ ULONG Flags = OFN_SAVEDEFAULT, out BSTR *pFileName);
         HRESULT SaveDialog(/*in*/ BSTR DefaultExt, /*in*/ BSTR Filter, /*in*/ BSTR StartFile = "", /*in*/ ULONG Flags = OFN_SAVEDEFAULT, out BSTR *pFileName);
         HRESULT SelectFolderDialog(/*in*/ BSTR Title, /*in*/ ULONG Flags = BIF_DEFAULT, out BSTR *pFolder);
         HRESULT PrintDialog(/*in*/ ULONG Flags =PD_DEFAULT, /*in*/ USHORT MinPage = 0, /*in*/ USHORT MaxPage = 0, out IDispatch **pResult);
         HRESULT PrinterSetupDialog(/*in*/ ULONG Flags =PD_DEFAULT, out IDispatch **pResult);
         HRESULT PageSetupDialog(/*in*/ ULONG Flags = PSD_DEFAULT, out IDispatch **pResult);
         HRESULT CreateFindDialog(/*in*/ BSTR FindText = "", /*in*/ ULONG Flags = FR_DOWN, out IDispatch **pResult);
         HRESULT CreateReplaceDialog(BSTR FindText = "", /*in*/ BSTR ReplaceText = "", /*in*/ ULONG Flags = FR_DOWN, out IDispatch **pResult);

         HRESULT CreateFontDialog(out IDispatch **pResult);

         HRESULT CreateColorDialog(out IDispatch **pResult);

         HRESULT CreateOpenDialog(out IDispatch **pResult);
         HRESULT CreateSaveDialog(out IDispatch **pResult);
         HRESULT CreateForm(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height,/*in*/ LONG Style = WS_DEFAULT, out IDispatch **pControl);
         HRESULT CreateDialogForm(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height,/*in*/ LONG Style = WS_DIALOGDEFAULT, out IDispatch **pControl);
        /*[propget]*/ HRESULT Menu(out IDispatch **pVal);
        /*[propput]*/ HRESULT Menu(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Menu(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT KeyPreview(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT KeyPreview(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MaximizeBox(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MaximizeBox(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MinimizeBox(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MinimizeBox(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ControlBox(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ControlBox(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SizeGrip(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT SizeGrip(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT TopMost(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT TopMost(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ToolWindow(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ToolWindow(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Caption(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Caption(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AcceptButton(out IDispatch **pVal);
        /*[propput]*/ HRESULT AcceptButton(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT AcceptButton(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT CancelButton(out IDispatch **pVal);
        /*[propput]*/ HRESULT CancelButton(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT CancelButton(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT HelpButton(out IDispatch **pVal);
        /*[propput]*/ HRESULT HelpButton(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT HelpButton(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT ActiveControl(out IDispatch **pVal);
        /*[propput]*/ HRESULT ActiveControl(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT ActiveControl(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT CanClose(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT CanClose(/*in*/ VARIANT_BOOL newVal);
        /*[propput]*/ HRESULT Region(/*in*/ ULONG newVal);
        /*[propput]*/ HRESULT OnCloseQuery(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnClose(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnActiveControlChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnHitTest(/*in*/ VARIANT newVal);       
        /*[propput]*/ HRESULT OnHint(/*in*/ VARIANT newVal);  
};
interface GraphicObject: IDispatch
{
	mixin(uuid("09866D76-9782-4FD2-BA16-C469A06499C1"));
        /*[propget]*/ HRESULT Color(out ULONG *pVal);
        /*[propput]*/ HRESULT Color(/*in*/ ULONG newVal);
         HRESULT Default(void);
};
interface Pen: GraphicObject
{
	mixin(uuid("A6BFFF0E-7526-495A-AEA9-7BE6005184D7"));
        /*[propget]*/ HRESULT Width(out LONG *pVal);
        /*[propput]*/ HRESULT Width(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Style(out LONG *pVal);
        /*[propput]*/ HRESULT Style(/*in*/ LONG newVal);
};
interface Brush: GraphicObject
{
	mixin(uuid("68FA42FE-34AC-40E9-857D-F94846E91B0A"));
        /*[propget]*/ HRESULT Style(out LONG *pVal);
        /*[propput]*/ HRESULT Style(/*in*/ LONG newVal);
        /*[propput]*/ HRESULT Image(/*in*/ VARIANT Image);
        /*[propget]*/ HRESULT GradientColor(out ULONG *pVal);
        /*[propput]*/ HRESULT GradientColor(/*in*/ ULONG newVal);
};
interface FontEx: GraphicObject
{	
	mixin(uuid("FAE1D3D9-57B5-42D7-AF14-AC9ED6B31EA8"));
        /*[propget]*/ HRESULT Italic(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Italic(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Underline(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Underline(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Strikethrough(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Strikethrough(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Bold(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Bold(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Weight(out SHORT *pVal);
        /*[propput]*/ HRESULT Weight(/*in*/ SHORT newVal);
        /*[propget]*/ HRESULT Name(out BSTR *pVal);
        /*[propput]*/ HRESULT Name(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Size(out CY *pVal);
        /*[propput]*/ HRESULT Size(/*in*/ CY newVal);
        /*[propget]*/ HRESULT CharSet(out SHORT *pVal);
        /*[propput]*/ HRESULT CharSet(/*in*/ SHORT newVal);
        /*[propget]*/ HRESULT Angle(out LONG *pVal);
        /*[propput]*/ HRESULT Angle(/*in*/ LONG newVal);
};
interface Action /*: Object*/
{
	mixin(uuid("752D00E4-9EBE-4A1A-82D8-5D62F66CB4ED"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propput]*/ HRESULT Item(/*in*/ long Index,
        /*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Remove(/*in*/ VARIANT Index); 
         HRESULT Clear(); 
         HRESULT ExChange(/*in*/ VARIANT A,/*in*/ VARIANT B); 

         HRESULT Add(/*in*/ VARIANT Item, /*in*/ /*optional*/ VARIANT Key, out IDispatch **pControl);
         HRESULT Insert(/*in*/ LONG Index, /*in*/ VARIANT Item, /*in*/ /*optional*/ VARIANT Key, out IDispatch **pControl);
         HRESULT NewLine(out IDispatch **pControl);
        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Enabled(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Enabled(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Checked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Checked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Visible(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Visible(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CheckBox(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT CheckBox(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT RadioCheck(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT RadioCheck(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AllowAllUp(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AllowAllUp(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Default(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Default(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Control(out IDispatch **pVal);
        /*[propget]*/ HRESULT Form(out IDispatch **pVal);
        /*[propget]*/ HRESULT Items(out IDispatch **pVal);
        /*[propget]*/ HRESULT Hint(out VARIANT *pVal);
        /*[propput]*/ HRESULT Hint(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT Break(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Break(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Key(out VARIANT *pVal);
        /*[propput]*/ HRESULT Key(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnExecute(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnUpdate(/*in*/ VARIANT newVal);
};
interface ButtonControl: Control
{
	mixin(uuid("CE6D21C9-132F-4990-ACB2-4C68A1D46BA2"));
        /*[propget]*/ HRESULT Flat(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Flat(/*in*/ VARIANT_BOOL newVal);
};
interface Button: ButtonControl
{
	mixin(uuid("31DC6745-8E8E-4F4A-9F17-36651B160FE9"));
        /*[propget]*/ HRESULT Default(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Default(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Cancel(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Cancel(/*in*/ VARIANT_BOOL newVal);
};
interface CheckBox: ButtonControl
{
	mixin(uuid("
        /*[propget]*/ HRESULT State(out LONG *pVal);
        /*[propput]*/ HRESULT State(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT AllowGrayed(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AllowGrayed(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Checked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Checked(/*in*/ VARIANT_BOOL newVal);
};
interface RadioButton: ButtonControl
{
	mixin(uuid("E4D0E174-9AB6-4BDF-9186-8905F5B54AAA"));
        /*[propget]*/ HRESULT Checked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Checked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Group(out LONG *pVal);
        /*[propput]*/ HRESULT Group(/*in*/ LONG newVal);
};
interface StringsControl: Control
{
	mixin(uuid("A1E967E4-0CEB-436B-91C0-F6A42F8D8733"));
        /*[propget]*/ HRESULT TopIndex(out LONG *pVal);
        /*[propput]*/ HRESULT TopIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out BSTR *pvar);
        /*[propput]*/ HRESULT Item(/*in*/ long Index,
        /*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Add(/*in*/ BSTR Item, out LONG *pItemIndex);
         HRESULT Remove(/*in*/ LONG Index);
         HRESULT Insert(/*in*/ LONG Index, /*in*/ BSTR Item, out LONG *pItemIndex);
         HRESULT Clear(void);
         HRESULT BeginUpdate(); 
         HRESULT EndUpdate(); 
         HRESULT ExChange(/*in*/ LONG A, /*in*/ LONG B); 
         HRESULT Sort(/*in*/ LONG DataType = DT_STRING, /*in*/ VARIANT_BOOL Reverse = FALSE);
         HRESULT Find(/*in*/ BSTR Text, /*in*/ LONG Start = 0, /*in*/ VARIANT_BOOL IgnoreCase = TRUE, out LONG *pItemIndex);
};
interface Edit: StringsControl
{
	mixin(uuid("1D2D9535-7884-49AB-90C2-49955A388137"));
        /*[propget]*/ HRESULT ReadOnly(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ReadOnly(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MaxLength(out LONG *pVal);
        /*[propput]*/ HRESULT MaxLength(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT CharCase(out LONG *pVal);
        /*[propput]*/ HRESULT CharCase(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT PasswordChar(out BSTR *pVal);
        /*[propput]*/ HRESULT PasswordChar(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT HideSelection(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HideSelection(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MultiLine(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MultiLine(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ScrollBars(out ULONG *pVal);
        /*[propput]*/ HRESULT ScrollBars(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT AutoSize(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoSize(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Modified(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Modified(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SelStart(out LONG *pVal);
        /*[propput]*/ HRESULT SelStart(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT SelEnd(out LONG *pVal);
        /*[propput]*/ HRESULT SelEnd(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT SelLength(out LONG *pVal);
        /*[propput]*/ HRESULT SelLength(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT LeftMargin(out USHORT *pVal);
        /*[propput]*/ HRESULT LeftMargin(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT RightMargin(out USHORT *pVal);
        /*[propput]*/ HRESULT RightMargin(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT WordWrap(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT WordWrap(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT TextAlign(out USHORT *pVal);
        /*[propput]*/ HRESULT TextAlign(/*in*/ USHORT newVal);
         HRESULT SelectAll(void);
         HRESULT ClearSelection(void);
         HRESULT ReplaceSelection(/*in*/ BSTR newText, /*in*/ VARIANT_BOOL CanUndo = FALSE);
        /*[propget]*/ HRESULT CanUndo(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT CanUndo(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CanPaste(out VARIANT_BOOL *pVal);
         HRESULT Undo(void);
         HRESULT Cut(void);
         HRESULT Copy(void);
         HRESULT Paste(void);
        /*[propget]*/ HRESULT DataType(out LONG *pVal);
        /*[propput]*/ HRESULT DataType(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Min(out VARIANT *pVal);
        /*[propput]*/ HRESULT Min(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT Max(out VARIANT *pVal);
        /*[propput]*/ HRESULT Max(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT LineFromChar(/*in*/ LONG Index = -1, out LONG *pVal);
        /*[propget]*/ HRESULT AcceptsReturn(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AcceptsReturn(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AcceptsTab(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AcceptsTab(/*in*/ VARIANT_BOOL newVal);
};
interface Paragraph: IDispatch
{
	mixin(uuid("C15C0ABE-967F-4A17-9EA9-BC68A2855C0D"));
        /*[propget]*/ HRESULT Align(out USHORT *pVal);
        /*[propput]*/ HRESULT Align(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Numbering(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Numbering(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT StartIndent(out LONG *pVal);
        /*[propput]*/ HRESULT StartIndent(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT LeftIndent(out LONG *pVal);
        /*[propput]*/ HRESULT LeftIndent(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT RightIndent(out LONG *pVal);
        /*[propput]*/ HRESULT RightIndent(/*in*/ LONG newVal);
}
interface RichEdit: Edit
{
	mixin(uuid("C775712D-FA95-49EE-971D-6DD3BE4FE703"));
        /*[propget]*/ HRESULT SelFont(out IDispatch **pVal);
        /*[propput]*/ HRESULT SelFont(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT SelFont(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Paragraph(out IDispatch **pVal);
         HRESULT FindText(/*in*/ BSTR Text, [/*in*/ ULONG Flags = FR_DOWN, /*in*/ LONG MinPos = 0, /*in*/ LONG MaxPos = -1, out LONG *pResult);
         HRESULT Load(/*in*/ VARIANT Stream, /*in*/ ULONG Flags = SF_RTF, out VARIANT_BOOL *pResult);
         HRESULT Save(/*in*/ VARIANT Stream, /*in*/ ULONG Flags = SF_RTF, out VARIANT_BOOL *pResult);
        //RichEdit Version 2
        /*[propget]*/ HRESULT AutoURLDetect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoURLDetect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CanRedo(out VARIANT_BOOL *pVal);
         HRESULT Redo(void);
        /*[propget]*/ HRESULT UndoLimit(out ULONG *pVal);
        /*[propput]*/ HRESULT UndoLimit(/*in*/ ULONG newVal);
        //Events
        /*[propput]*/ HRESULT OnSelChange(/*in*/ VARIANT newVal);

         HRESULT Print(/*in*/ BSTR Driver, /*in*/ BSTR Device, /*in*/ IDispatch PrintInfo, /*in*/ VARIANT_BOOL Selection = FALSE);

};
interface ListControl: StringsControl
{
	mixin(uuid("B61BDF00-553F-401B-948C-2F7A5FDCBBBB"));
        /*[propget]*/ HRESULT ItemIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ItemIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ItemHeight(out LONG *pVal);
        /*[propput]*/ HRESULT ItemHeight(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ItemData(/*in*/ LONG Index, out LONG *pVal);
        /*[propput]*/ HRESULT ItemData(/*in*/ LONG Index, /*in*/ LONG newVal);
        /*[propget]*/ HRESULT Sorted(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Sorted(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT IntegralHeight(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT IntegralHeight(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HorizontalExtent(out LONG *pVal);
        /*[propput]*/ HRESULT HorizontalExtent(/*in*/ LONG newVal);
};
interface ListBox: ListControl
{
	mixin(uuid("A33F2256-EF4D-409B-B1FD-0BE23F8F8C2D"));
        /*[propget]*/ HRESULT Selected(/*in*/ LONG Index, out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Selected(/*in*/ LONG Index, /*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SelCount(out LONG *pVal);
        /*[propget]*/ HRESULT MultiSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MultiSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ExtendedSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ExtendedSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ColumnCount(out USHORT *pVal);
        /*[propput]*/ HRESULT ColumnCount(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT ColumnWidth(out USHORT *pVal);
        /*[propput]*/ HRESULT ColumnWidth(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT ScrollBars(out ULONG *pVal);
        /*[propput]*/ HRESULT ScrollBars(/*in*/ ULONG newVal);
         HRESULT ItemFromPoint(/*in*/ USHORT x, /*in*/ USHORT y, out LONG *pIndex);
};
interface ComboBox: ListControl
{
	mixin(uuid("AA09373F-278A-49DF-9F40-74C5B92ABB6F"));
        /*[propget]*/ HRESULT DropDownCount(out ULONG *pVal);
        /*[propput]*/ HRESULT DropDownCount(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Style(out LONG *pVal);
        /*[propput]*/ HRESULT Style(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT CharCase(out LONG *pVal);
        /*[propput]*/ HRESULT CharCase(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ReadOnly(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ReadOnly(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT DroppedDown(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT DroppedDown(/*in*/ VARIANT_BOOL newVal);
};
interface StatusItem: IDispatch
{
	mixin(uuid("80508CDF-06EA-43C5-B41E-F2F97D516151"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Width(out LONG *pVal);
        /*[propput]*/ HRESULT Width(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Border(out LONG *pVal);
        /*[propput]*/ HRESULT Border(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT AutoSize(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoSize(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
};
interface StatusBar: Control
{
	mixin(uuid("F61D55A1-ECC9-484B-A635-F0C5E71A8C29"));
        /*[propget]*/ HRESULT Simple(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Simple(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SizeGrip(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT SizeGrip(/*in*/ VARIANT_BOOL newVal);

        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Remove(/*in*/ VARIANT Index); 
         HRESULT Clear(); 
         HRESULT ExChange(/*in*/ VARIANT A,/*in*/ VARIANT B); 
         HRESULT Add(/*in*/ LONG Width, /*in*/ LONG Border = BS_LOWERED, out IDispatch **pItem);

        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
};
interface StatusControl: Control
{
	mixin(uuid("7ADA76A6-13E2-455D-8DF1-E2C980D21BF9"));
        /*[propget]*/ HRESULT Min(out LONG *pVal);
        /*[propput]*/ HRESULT Min(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Max(out LONG *pVal);
        /*[propput]*/ HRESULT Max(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Position(out LONG *pVal);
        /*[propput]*/ HRESULT Position(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Step(out LONG *pVal);
        /*[propput]*/ HRESULT Step(/*in*/ LONG newVal);
         HRESULT StepIt(void);
         HRESULT StepBy(/*in*/ LONG Delta);
}
interface ProgressBar: StatusControl
{
	mixin(uuid("16271F21-45E5-4632-BC36-E3E429B49AD8"));
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Smooth(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Smooth(/*in*/ VARIANT_BOOL newVal);
};
interface ScrollBar:StatusControl
{
	mixin(uuid("FC140361-F789-48AD-AE2B-A4B5A2643FB0"));
        /*[propget]*/ HRESULT Page(out ULONG *pVal);
        /*[propput]*/ HRESULT Page(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT SmallChange(out ULONG *pVal);
        /*[propput]*/ HRESULT SmallChange(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT LargeChange(out ULONG *pVal);
        /*[propput]*/ HRESULT LargeChange(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Tracking(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Tracking(/*in*/ VARIANT_BOOL newVal);
};
interface Tab: Frame
{
	mixin(uuid("F8019994-24F1-475D-8AC4-5A1BCFF213D0"));
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
};
interface TabControl: Control
{
	mixin(uuid("80249C22-E39E-4BF1-A167-8599130D19BA"));
         HRESULT CreateTab(/*in*/ BSTR Text, out IDispatch **pControl);
        /*[propget]*/ HRESULT Controls(out IDispatch **pVal);
        /*[propget]*/ HRESULT ActiveControl(out IDispatch **pVal);
        /*[propput]*/ HRESULT ActiveControl(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT ActiveControl(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Buttons(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Buttons(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MultiLine(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MultiLine(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HotTrack(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HotTrack(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT FlatButtons(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FlatButtons(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT RaggedRight(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT RaggedRight(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT TabWidth(out LONG *pVal);
        /*[propput]*/ HRESULT TabWidth(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ItemIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ItemIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT TabsVisible(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT TabsVisible(/*in*/ VARIANT_BOOL newVal);
};
interface ToolBar: Control
{
	mixin(uuid("EE439DC1-D255-41A8-94E4-0E2F5518562D"));
        /*[propget]*/ HRESULT Buttons(out IDispatch **pVal);
        /*[propput]*/ HRESULT Buttons(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Buttons(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Flat(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Flat(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ShowText(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ShowText(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ButtonWidth(out ULONG *pVal);
        /*[propput]*/ HRESULT ButtonWidth(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT ButtonHeight(out ULONG *pVal);
        /*[propput]*/ HRESULT ButtonHeight(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT AutoSizeButtons(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoSizeButtons(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT List(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT List(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Wrapable(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Wrapable(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AutoSize(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoSize(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
};
interface MenuBar: Control
{
	mixin(uuid("CD1140FE-95CD-4690-8DB9-48DF5989E8FA"));
        /*[propget]*/ HRESULT Menu(out IDispatch **pVal);
        /*[propput]*/ HRESULT Menu(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Menu(/*in*/ IDispatch *newVal);
};
interface ReBarBand: IDispatch
{
	mixin(uuid("5FFD779C-DF3C-4B7C-BA33-53ED4BE00360"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Color(out LONG *pVal);
        /*[propput]*/ HRESULT Color(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ParentColor(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentColor(/*in*/ VARIANT_BOOL newVal);
        /*[propput]*/ HRESULT Image(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT ParentImage(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentImage(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT FixedImage(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FixedImage(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT FixedSize(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FixedSize(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Break(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Break(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT GripperAlways(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT GripperAlways(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Locked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Locked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Chevron(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Chevron(/*in*/ VARIANT_BOOL newVal);
}
interface ReBar: Frame
{
	mixin(uuid("DBD8984A-5CB5-4B3B-94DE-62AF0C20F75F"));
        /*[propget]*/ HRESULT Locked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Locked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT InsertNewRow(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT InsertNewRow(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Band(/*in*/ IDispatch *Control, out IDispatch **pVal);
        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propput]*/ HRESULT Image(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT FixedOrder(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FixedOrder(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT VarHeight(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT VarHeight(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT BandBorders(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT BandBorders(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT DblClkToggle(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT DblClkToggle(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT VerticalGripper(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT VerticalGripper(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AutoLayout(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoLayout(/*in*/ VARIANT_BOOL newVal);
};
interface HyperLink: Control
{
	mixin(uuid("ED777BB6-9999-4385-8647-8C72156DC3A1"));
        /*[propget]*/ HRESULT URL(out BSTR *pVal);
        /*[propput]*/ HRESULT URL(/*in*/ BSTR newVal);
};
interface Pager: Frame
{
	mixin(uuid("AD4463D6-4144-4D08-9A41-A296E6264F32"));
        /*[propget]*/ HRESULT Control(out IDispatch **pVal);
        /*[propput]*/ HRESULT Control(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Control(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ButtonSize(out ULONG *pVal);
        /*[propput]*/ HRESULT ButtonSize(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Position(out LONG *pVal);
        /*[propput]*/ HRESULT Position(/*in*/ LONG newVal);
};
interface COMConnectionPoint/*/*:Object*/*/
{
	mixin(uuid("701F8D53-90B9-4D99-96A2-37C8BB960289"));
        /*[propget]*/ HRESULT ID(out BSTR *pVal);
        /*[propget]*/ HRESULT Name(out BSTR *pVal);
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
}
interface COMEvents/*/*:Object*/*/
{
	mixin(uuid("DC2EF81F-A8DF-488D-89C9-DCC67D7B0EE8"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ VARIANT Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
};
interface ActiveXControl:Control
{
	mixin(uuid("FF57FCA7-3701-47A2-B309-3C0F5A581CB1"));
        /*[propget]*/ HRESULT Control(out IDispatch **pVal);
        /*[propget]*/ HRESULT Events(out IDispatch **pVal);
};
interface HeaderItem/*/*:Object*/*/
{
	mixin(uuid("76B856CD-223D-4728-BA49-DCB111DAAA9D"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Width(out LONG *pVal);
        /*[propput]*/ HRESULT Width(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT TextAlign(out LONG *pVal);
        /*[propput]*/ HRESULT TextAlign(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT DataType(out LONG *pVal);
        /*[propput]*/ HRESULT DataType(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT SortType(out LONG *pVal);
        /*[propput]*/ HRESULT SortType(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Index(out LONG *pVal);
        /*[propget]*/ HRESULT Owner(out IDispatch **pVal);
        /*[propput]*/ HRESULT OnClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnResize(/*in*/ VARIANT newVal);

        /*[propput]*/ HRESULT OnBeginTrack(/*in*/ VARIANT newVal);

        /*[propput]*/ HRESULT OnTrack(/*in*/ VARIANT newVal);

        /*[propput]*/ HRESULT OnDividerDblClick(/*in*/ VARIANT newVal);

};
interface Header:Control
{
	mixin(uuid("F1901A02-8CA0-4446-AC10-D8E9B6A9E573"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Remove(/*in*/ VARIANT Index); 
         HRESULT Clear(); 
         HRESULT Add(/*in*/ BSTR Text,/*in*/ LONG Width = 100, /*in*/ LONG TextAlign = AL_LEFT, out IDispatch **pItem);
        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT HotTrack(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HotTrack(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Flat(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Flat(/*in*/ VARIANT_BOOL newVal);
        /*[propput]*/ HRESULT OnColumnClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnColumnResize(/*in*/ VARIANT newVal);
};
interface ListItem:IDispatch
{
	mixin(uuid("1FEE927E-CC8A-4DC0-9B40-E4113CDE5DA9"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Selected(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Selected(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Checked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Checked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SubItems(/*in*/ LONG Index, out BSTR *pVal);
        /*[propput]*/ HRESULT SubItems(/*in*/ LONG Index, /*in*/ BSTR newVal);
        /*[propget]*/ HRESULT SubItemImage(/*in*/ LONG Index, out LONG *pVal);
        /*[propput]*/ HRESULT SubItemImage(/*in*/ LONG Index, /*in*/ LONG newVal);
        /*[propget]*/ HRESULT Index(out LONG *pVal);
        /*[propget]*/ HRESULT UserData(out VARIANT *pVal);
        /*[propput]*/ HRESULT UserData(/*in*/ VARIANT newVal);
}
interface ListViewColumns:IDispatch
{
	mixin(uuid("1A015BF1-FDE4-49FF-85AE-A142E1239B16"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT Remove(/*in*/ VARIANT Index); 
         HRESULT Clear(); 
         HRESULT Add(/*in*/ BSTR Text,/*in*/ LONG Width = 100, /*in*/ LONG TextAlign = AL_LEFT, out IDispatch **pItem);
        /*[propget]*/ HRESULT Visible(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Visible(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Flat(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Flat(/*in*/ VARIANT_BOOL newVal);
}
interface ListView: Control
{
	mixin(uuid("98763204-A34A-4206-9151-8DDF2445F52B"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
        /*[propput]*/ HRESULT Count(/*in*/ long newVal);
         HRESULT Add(/*in*/ BSTR Text, out IDispatch **pItem);
         HRESULT Insert(/*in*/ LONG Index, /*in*/ BSTR Text, out IDispatch **pItem);
         HRESULT Remove(/*in*/ LONG Index);
         HRESULT Clear(); 

         HRESULT BeginUpdate(); 
         HRESULT EndUpdate(); 
         HRESULT SelectAll();
         HRESULT ClearSelection();
         HRESULT EditItem(/*in*/ LONG Index);
         HRESULT Sort(/*in*/ LONG DataType = DT_STRING, /*in*/ VARIANT_BOOL Reverse = FALSE, /*in*/  ULONG Column = 0);

        /*[propget]*/ HRESULT LargeImages(out IDispatch **pVal);
        /*[propput]*/ HRESULT LargeImages(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT LargeImages(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT SmallImages(out IDispatch **pVal);
        /*[propput]*/ HRESULT SmallImages(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT SmallImages(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT StateImages(out IDispatch **pVal);
        /*[propput]*/ HRESULT StateImages(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT StateImages(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT Style(out LONG *pVal);
        /*[propput]*/ HRESULT Style(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT TextBkColor(out ULONG *pVal);
        /*[propput]*/ HRESULT TextBkColor(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT MultiSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MultiSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HideSelection(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HideSelection(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SelCount(out LONG *pVal);
        /*[propget]*/ HRESULT ItemIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ItemIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Columns(out IDispatch **pVal);
        /*[propget]*/ HRESULT CheckBoxes(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT CheckBoxes(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT GridLines(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT GridLines(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HotTrack(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HotTrack(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT RowSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT RowSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT BorderSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT BorderSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT FlatScrollBars(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FlatScrollBars(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT OwnerData(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT OwnerData(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ReadOnly(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ReadOnly(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT WrapText(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT WrapText(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Arrangement(out LONG *pVal);
        /*[propput]*/ HRESULT Arrangement(/*in*/ LONG newVal);
        /*[propput]*/ HRESULT OnColumnClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnColumnResize(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnData(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnItemCheck(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnEdited(/*in*/ VARIANT newVal);
};
interface TreeItem:IDispatch
{
	mixin(uuid("FFFF9989-481D-4921-949C-B283BD06CB44"));
        /*[propget]*/ HRESULT _NewEnum(out
        LPUNKNOWN *pUnk);
        /*[propget]*/ HRESULT Item(/*in*/ long Index,
        out VARIANT *pvar);
        /*[propget]*/ HRESULT Count(out long *pcount);
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT SelectedImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT SelectedImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Selected(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Selected(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Expanded(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Expanded(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Bold(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Bold(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Checked(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Checked(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HasChildren(out VARIANT_BOOL *pVal);
         HRESULT Add(/*in*/ BSTR Text, /*in*/ LONG ImageIndex = -1, /*in*/ LONG SelectedImageIndex = -1, out IDispatch **pItem);
         HRESULT Insert(/*in*/ LONG Index, /*in*/ BSTR Text, /*in*/ LONG ImageIndex = -1, /*in*/ LONG SelectedImageIndex = -1, out IDispatch **pItem);
         HRESULT Remove(/*in*/ LONG Index = TREEVIEW_THISITEM);
         HRESULT Clear(); 
         HRESULT Expand(/*in*/ VARIANT_BOOL Recurse = FALSE); 
         HRESULT Collapse(); 
         HRESULT EditLabel();
         HRESULT Sort(/*in*/ VARIANT_BOOL Recurse = TRUE);
         HRESULT MakeVisible();
        /*[propget]*/ HRESULT Parent(out IDispatch **pVal);
        /*[propget]*/ HRESULT NextSibling(out IDispatch **pVal);
        /*[propget]*/ HRESULT PrevSibling(out IDispatch **pVal);
        /*[propget]*/ HRESULT FirstChild(out IDispatch **pVal);
        /*[propget]*/ HRESULT LastChild(out IDispatch **pVal);
        /*[propget]*/ HRESULT UserData(out VARIANT *pVal);
        /*[propput]*/ HRESULT UserData(/*in*/ VARIANT newVal);
}
interface TreeView: Control
{
	mixin(uuid("A6034589-820F-4165-9EEE-AE1E97BFB9B1"));
        /*[propget]*/ HRESULT Items(out IDispatch **pVal);
        /*[propget]*/ HRESULT SelectedItem(out IDispatch **pVal);
        /*[propget]*/ HRESULT TopItem(out IDispatch **pVal);
        /*[propget]*/ HRESULT Count(out long *pcount);
         HRESULT BeginUpdate(); 
         HRESULT EndUpdate();

        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT StateImages(out IDispatch **pVal);
        /*[propput]*/ HRESULT StateImages(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT StateImages(/*in*/ IDispatch *newVal);

        /*[propget]*/ HRESULT HasButtons(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HasButtons(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HasLines(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HasLines(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT LinesAtRoot(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT LinesAtRoot(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ReadOnly(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ReadOnly(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CheckBoxes(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT CheckBoxes(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HotTrack(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HotTrack(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT RowSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT RowSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HideSelection(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HideSelection(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AutoExpand(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoExpand(/*in*/ VARIANT_BOOL newVal);

        /*[propput]*/ HRESULT OnEdited(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnExpanding(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnExpanded(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnCollapsing(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnCollapsed(/*in*/ VARIANT newVal);
}
interface UpDown: StatusControl
{
	mixin(uuid("F09EE7EC-728F-4D8B-AE8E-0F5A113FD36E"));
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT HotTrack(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT HotTrack(/*in*/ VARIANT_BOOL newVal);
};
interface TrackBar: StatusControl
{
	mixin(uuid("D47DC012-3D4E-4412-8A06-E747160435E0"));
        /*[propget]*/ HRESULT Vertical(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Vertical(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT TickMarks(out LONG *pVal);
        /*[propput]*/ HRESULT TickMarks(in/*range(-1,2)]*/ LONG newVal = [-1, 2]);       
        /*[propget]*/ HRESULT SmallChange(out ULONG *pVal);
        /*[propput]*/ HRESULT SmallChange(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT LargeChange(out ULONG *pVal);
        /*[propput]*/ HRESULT LargeChange(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT ThumbLength(out ULONG *pVal);
        /*[propput]*/ HRESULT ThumbLength(/*in*/ ULONG newVal);       
        /*[propget]*/ HRESULT TickFrequency(out ULONG *pVal);
        /*[propput]*/ HRESULT TickFrequency(/*in*/ ULONG newVal);     
        /*[propget]*/ HRESULT EnableSelRange(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT EnableSelRange(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SelStart(out LONG *pVal);
        /*[propput]*/ HRESULT SelStart(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT SelEnd(out LONG *pVal);
        /*[propput]*/ HRESULT SelEnd(/*in*/ LONG newVal);
         HRESULT SelectAll(void);
         HRESULT ClearSelection(void);
}
interface Animate: Control
{
	mixin(uuid("CD27766E-91BF-4D27-BA1E-CBFE3CB55BD1"));
         HRESULT Open(/*in*/ VARIANT newVal, /*in*/ VARIANT_BOOL StartPlay = FALSE, out VARIANT_BOOL *pResult);
         HRESULT Play(void);
         HRESULT Stop(void);
         HRESULT Close(void);
         HRESULT Seek(/*in*/ LONG Position);
        /*[propget]*/ HRESULT AutoRepeat(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AutoRepeat(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Transparent(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Transparent(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Center(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Center(/*in*/ VARIANT_BOOL newVal);
};
interface HotKey: Control
{
	mixin(uuid("E9013635-B5D5-48D7-81A4-41D3AFF5A717"));
        /*[propget]*/ HRESULT Key(out VARIANT *pVal);
        /*[propput]*/ HRESULT Key(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT InvalidKeys(out LONG *pVal);
        /*[propput]*/ HRESULT InvalidKeys(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT DefaultKey(out VARIANT *pVal);
        /*[propput]*/ HRESULT DefaultKey(/*in*/ VARIANT newVal);
}
interface IPAddress: Control
{
	mixin(uuid("CCC32DB0-A7E0-4947-A757-9534AB58027F"));
        /*[propget]*/ HRESULT Value(out ULONG *pVal);
        /*[propput]*/ HRESULT Value(/*in*/ ULONG newVal);
         HRESULT SetRange([in,range(0,3)] LONG Index, /*in*/ BYTE Min, /*in*/ BYTE Max);    
        /*[propget]*/ HRESULT IsBlank(out VARIANT_BOOL *pVal);
}
interface DateTime: IDispatch
{
	mixin(uuid("E5197962-B022-4902-B92C-B46F2CCC8875"));
        /*[propget]*/ HRESULT Value(out DATE *pVal);
        /*[propput]*/ HRESULT Value(/*in*/ DATE newVal);
        /*[propget]*/ HRESULT Year(out USHORT *pVal);
        /*[propput]*/ HRESULT Year(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Month(out USHORT *pVal);
        /*[propput]*/ HRESULT Month(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Day(out USHORT *pVal);
        /*[propput]*/ HRESULT Day(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Hour(out USHORT *pVal);
        /*[propput]*/ HRESULT Hour(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Minute(out USHORT *pVal);
        /*[propput]*/ HRESULT Minute(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Second(out USHORT *pVal);
        /*[propput]*/ HRESULT Second(/*in*/ USHORT newVal);
        /*[propget]*/ HRESULT Milliseconds(out USHORT *pVal);
        /*[propput]*/ HRESULT Milliseconds(/*in*/ USHORT newVal);
}
interface DateTimeControl: Control
{
	mixin(uuid("0E53C57C-CAC1-4290-8C57-559AD095F9F3"));
        /*[propget]*/ HRESULT Value(out IDispatch **pVal);
        /*[propget]*/ HRESULT Min(out IDispatch **pVal);
        /*[propget]*/ HRESULT Max(out IDispatch **pVal);
}
interface DateTimePicker: DateTimeControl
{
	mixin(uuid("7FCABADD-F460-4049-ABBC-79821C613284"));
        /*[propget]*/ HRESULT Style(out ULONG *pVal);
        /*[propput]*/ HRESULT Style(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT ShowCheckBox(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ShowCheckBox(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT ShowUpDown(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ShowUpDown(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT DropDownRightAlign(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT DropDownRightAlign(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT CustomFormat(out BSTR *pVal);
        /*[propput]*/ HRESULT CustomFormat(/*in*/ BSTR newVal);
}
interface Calendar: DateTimeControl
{
	mixin(uuid("EE27A882-AD8E-4723-AAA9-E10CFD472F75"));
        /*[propget]*/ HRESULT MultiSelect(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT MultiSelect(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT SelEnd(out IDispatch **pVal);
        /*[propget]*/ HRESULT SelStart(out IDispatch **pVal);
        /*[propget]*/ HRESULT Today(out IDispatch **pVal);
        /*[propget]*/ HRESULT MonthDelta(out ULONG *pVal);
        /*[propput]*/ HRESULT MonthDelta(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT MaxSelCount(out ULONG *pVal);
        /*[propput]*/ HRESULT MaxSelCount(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT TodayText(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT TodayText(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT TodayCircle(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT TodayCircle(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT WeekNumbers(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT WeekNumbers(/*in*/ VARIANT_BOOL newVal);
}
interface Splitter: Control
{
	mixin(uuid("76A49C6D-284D-45F0-856E-6E9714281AC5"));
}
interface Polygon: Control
{
	mixin(uuid("01F209D7-27B9-41CD-8DAE-0DAF2875A8FA"));
        /*[propget]*/ HRESULT FillAll(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT FillAll(/*in*/ VARIANT_BOOL newVal);
}
interface Image: Control
{
	mixin(uuid("DAF6D7B8-1AB3-4DAC-8BDA-4E5234AD8731"));
        /*[propget]*/ HRESULT DrawType(out ULONG *pVal);
        /*[propput]*/ HRESULT DrawType(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT CopyMode(out ULONG *pVal);
        /*[propput]*/ HRESULT CopyMode(/*in*/ ULONG newVal);
};
interface Line: Control
{
	mixin(uuid("D6D9AAA2-739F-4807-814E-0E7692E18E62"));
        /*[propget]*/ HRESULT X(/*in*/ LONG Index, out LONG *pVal);
        /*[propput]*/ HRESULT X(/*in*/ LONG Index, /*in*/ LONG newVal);
        /*[propget]*/ HRESULT Y(/*in*/ LONG Index, out LONG *pVal);
        /*[propput]*/ HRESULT Y(/*in*/ LONG Index, /*in*/ LONG newVal);
}
interface PrintDialogBase : IDispatch{
	mixin(uuid("0E609193-AF42-4ECC-9897-4F279B659D1F"));
        /*[propget]*/ HRESULT Driver(out BSTR *pVal);
        /*[propget]*/ HRESULT Device(out BSTR *pVal);
        /*[propget]*/ HRESULT Port(out BSTR *pVal);
}
interface PrintDialog : PrintDialogBase{
	mixin(uuid("A48A739A-BAAF-4693-B8AE-B594065B8D17"));
        /*[propget]*/ HRESULT Copies(out LONG *pVal);
        /*[propget]*/ HRESULT Collate(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT Selection(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT All(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT Range(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT ToFile(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT FromPage(out LONG *pVal);
        /*[propget]*/ HRESULT ToPage(out LONG *pVal);
}
interface PageSetupDialog : PrintDialogBase{
	mixin(uuid("740AE358-3778-4F25-89E8-CAE218F9F14C"));
        /*[propget]*/ HRESULT PaperWidth(out LONG *pVal);
        /*[propget]*/ HRESULT PaperHeight(out LONG *pVal);
        /*[propget]*/ HRESULT LeftMargin(out LONG *pVal);
        /*[propget]*/ HRESULT RightMargin(out LONG *pVal);
        /*[propget]*/ HRESULT TopMargin(out LONG *pVal);
        /*[propget]*/ HRESULT BottomMargin(out LONG *pVal);
}
interface FindReplaceDialog /*: Object*/{
	mixin(uuid("A156794D-9CF8-4AC9-84B8-D657F8ECCAF1"));
        /*[propget]*/ HRESULT FindText(out BSTR *pVal);
        /*[propget]*/ HRESULT ReplaceText(out BSTR *pVal);
        /*[propget]*/ HRESULT SearchDown(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT MatchCase(out VARIANT_BOOL *pVal);
        /*[propget]*/ HRESULT WholeWord(out VARIANT_BOOL *pVal);  
         HRESULT Close();       
        /*[propput]*/ HRESULT OnFind(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnReplace(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnReplaceAll(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnClose(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnHelp(/*in*/ VARIANT newVal);
};

interface FontDialog /*: Object*/{
	mixin(uuid("7C57CB6F-E98B-4E58-9813-DD46E590B79B"));
        /*[propget]*/ HRESULT Flags(out ULONG *pVal);
        /*[propput]*/ HRESULT Flags(/*in*/ ULONG newVal);

        /*[propget]*/ HRESULT Font(out IDispatch **pVal);
        /*[propput]*/ HRESULT Font(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Font(/*in*/ IDispatch *newVal);

         HRESULT Execute(out VARIANT_BOOL *pResult);

        /*[propput]*/ HRESULT OnHelp(/*in*/ VARIANT newVal);

        /*[propput]*/ HRESULT OnApply(/*in*/ VARIANT newVal);
};

interface ColorDialog /*: Object*/{
	mixin(uuid("5A8CE32D-69D3-45F1-BE74-531AEBA638DB"));
        /*[propget]*/ HRESULT Flags(out ULONG *pVal);
        /*[propput]*/ HRESULT Flags(/*in*/ ULONG newVal);

        /*[propget]*/ HRESULT Color(out ULONG *pVal);
        /*[propput]*/ HRESULT Color(/*in*/ ULONG newVal);

         HRESULT Execute(out VARIANT_BOOL *pResult);

        /*[propput]*/ HRESULT OnHelp(/*in*/ VARIANT newVal);
};


interface FileOpenSaveDialog /*: Object*/
{
	mixin(uuid("B7ED6BDC-9791-4B8F-979E-990CD76A394A"));
        /*[propget]*/ HRESULT DefaultExt(out BSTR *pVal);
        /*[propput]*/ HRESULT DefaultExt(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Filter(out BSTR *pVal);
        /*[propput]*/ HRESULT Filter(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT FileName(out BSTR *pVal);
        /*[propput]*/ HRESULT FileName(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Flags(out ULONG *pVal);
        /*[propput]*/ HRESULT Flags(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT FilterIndex(out ULONG *pVal);
        /*[propput]*/ HRESULT FilterIndex(/*in*/ ULONG newVal);
        /*[propget]*/ HRESULT Directory(out BSTR *pVal);
        /*[propput]*/ HRESULT Directory(/*in*/ BSTR newVal);
         HRESULT Execute(out VARIANT_BOOL *pResult);
        /*[propput]*/ HRESULT OnCloseQuery(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnFolderChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnTypeChange(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnHelp(/*in*/ VARIANT newVal);
}
interface Timer /*: Object*/{
	mixin(uuid("A70DBA20-F39F-4B55-BC04-7E5FE2C495B7"));
        /*[propget]*/ HRESULT Active(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Active(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Interval(out ULONG *pVal);
        /*[propput]*/ HRESULT Interval(/*in*/ ULONG newVal);
        /*[propput]*/ HRESULT OnExecute(/*in*/ VARIANT newVal);
};
interface TrayIcon /*: Object*/{
	mixin(uuid("4AAC7C83-5BF6-44A6-AD8A-FD431D23DD79"));
        /*[propget]*/ HRESULT Active(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Active(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Images(out IDispatch **pVal);
        /*[propput]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT Images(/*in*/ IDispatch *newVal);
        /*[propget]*/ HRESULT ImageIndex(out LONG *pVal);
        /*[propput]*/ HRESULT ImageIndex(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Hint(out BSTR *pVal);
        /*[propput]*/ HRESULT Hint(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT PopupMenu(out IDispatch **pVal);
        /*[propput]*/ HRESULT PopupMenu(/*in*/ IDispatch *newVal);
        /*[propputref]*/ HRESULT PopupMenu(/*in*/ IDispatch *newVal);
        /*[propput]*/ HRESULT OnClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnDblClick(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseDown(/*in*/ VARIANT newVal);
        /*[propput]*/ HRESULT OnMouseUp(/*in*/ VARIANT newVal);
};
interface Result : IDispatch
{
	mixin(uuid("50B60E8E-E889-46DB-88D8-09A416726824"));
         HRESULT Put(/*in*/ VARIANT newVal);
        /*[propget]*/ HRESULT Value(out VARIANT *pVal);
        /*[propput]*/ HRESULT Value(/*in*/ VARIANT newVal);
};

//Events
interface ControlEvents : IDispatch
{
	mixin(uuid("CCF521F3-D5AA-4CE2-BD3D-1B4D05A8BE1A"));
                HRESULT OnClick(/*in*/ IDispatch *Sender);
                HRESULT OnDblClick(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
                HRESULT OnChange(/*in*/ IDispatch *Sender);
                HRESULT OnKeyDown(/*in*/ IDispatch *Sender, /*in*/ LONG Key, /*in*/ LONG Flags);
                HRESULT OnKeyUp(/*in*/ IDispatch *Sender, /*in*/ LONG Key, /*in*/ LONG Flags);
                HRESULT OnMouseEnter(/*in*/ IDispatch *Sender);
                HRESULT OnMouseLeave(/*in*/ IDispatch *Sender);
                HRESULT OnMouseDown(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
                HRESULT OnMouseMove(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Flags);
                HRESULT OnMouseUp(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
                HRESULT OnResize(/*in*/ IDispatch *Sender);
                HRESULT OnMove(/*in*/ IDispatch *Sender);
                HRESULT OnDestroy(/*in*/ IDispatch *Sender);
                HRESULT OnShow(/*in*/ IDispatch *Sender);
                HRESULT OnHide(/*in*/ IDispatch *Sender);
                HRESULT OnEnabledChange(/*in*/ IDispatch *Sender);
                HRESULT OnSetFocus(/*in*/ IDispatch *Sender);
                HRESULT OnKillFocus(/*in*/ IDispatch *Sender);
};
interface FormEvents : ControlEvents
{
	mixin(uuid("1198D8CE-DCE6-4C9E-8CFF-CF0E3AB7DE87"));
                HRESULT OnCloseQuery(/*in*/ IDispatch *Sender, /*in*/ IDispatch *ResultPtr);
                HRESULT OnClose(/*in*/ IDispatch *Sender);
                HRESULT OnActiveControlChange(/*in*/ IDispatch *Sender);
                HRESULT OnHitTest(/*in*/ IDispatch *Sender, /*in*/ LONG x, /*in*/ LONG y, /*in*/ IDispatch *ResultPtr);
                HRESULT OnHint(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Object);
};
interface ActionEvents : IDispatch
{
	mixin(uuid("F2C5B01B-E77C-411A-A958-7E77A8DA912F"));
                HRESULT OnExecute(/*in*/ IDispatch *Sender);
                HRESULT OnUpdate(/*in*/ IDispatch *Sender);
}
interface TimerEvents : IDispatch
{
	mixin(uuid("076A1D13-7601-477A-98BB-45E6328360DE"));
                HRESULT OnExecute(/*in*/ IDispatch *Sender);
}
interface HeaderItemEvents : IDispatch
{
	mixin(uuid("AF9F723A-C078-431B-8723-AAB704905048"));
                HRESULT OnClick(/*in*/ IDispatch *Sender);
                HRESULT OnResize(/*in*/ IDispatch *Sender);

                HRESULT OnBeginTrack(/*in*/ IDispatch *Sender, /*in*/ LONG Button, /*in*/ IDispatch *ResultPtr);

                HRESULT OnTrack(/*in*/ IDispatch *Sender, /*in*/ LONG Width, /*in*/ LONG Button, /*in*/ IDispatch *ResultPtr);

                HRESULT OnDividerDblClick(/*in*/ IDispatch *Sender, /*in*/ IDispatch *ResultPtr);
}
interface HeaderEvents : ControlEvents
{
	mixin(uuid("0CEF5413-315F-4FA8-B961-F7F04F8393A8"));
                HRESULT OnColumnClick(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnColumnResize(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
}
interface ListViewEvents : HeaderEvents
{
	mixin(uuid("F8233D5A-7BE6-48C7-8B44-E61345BBDF5A"));
                HRESULT OnData(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnItemCheck(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnEdited(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item, /*in*/ Result *NewText);
}
interface TreeViewEvents : ControlEvents
{
	mixin(uuid("555949AA-0922-4BF3-926A-9DAA912861A2"));
                HRESULT OnEdited(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item, /*in*/ Result *NewText);
                HRESULT OnExpanding(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnExpanded(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnCollapsing(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
                HRESULT OnCollapsed(/*in*/ IDispatch *Sender, /*in*/ IDispatch *Item);
}

interface RichEditEvents : ControlEvents
{
	mixin(uuid("5B691737-293F-421D-87DA-E810555C8459"));
                HRESULT OnSelChange(/*in*/ IDispatch *Sender);
}
interface FindReplaceDialogEvents : IDispatch
{
	mixin(uuid("0FBA8E33-6938-4E38-97ED-DD9DF0248306"));
                HRESULT OnFind(/*in*/ IDispatch *Sender);
                HRESULT OnReplace(/*in*/ IDispatch *Sender);
                HRESULT OnReplaceAll(/*in*/ IDispatch *Sender);
                HRESULT OnClose(/*in*/ IDispatch *Sender);
                HRESULT OnHelp(/*in*/ IDispatch *Sender);
}
interface FileOpenSaveDialogEvents : IDispatch
{
	mixin(uuid("ED303EB3-B7F9-493B-BE0E-265D20F80E38"));
                HRESULT OnCloseQuery(/*in*/ IDispatch *Sender, /*in*/ IDispatch *ResultPtr);
                HRESULT OnChange(/*in*/ IDispatch *Sender);
                HRESULT OnFolderChange(/*in*/ IDispatch *Sender);
                HRESULT OnTypeChange(/*in*/ IDispatch *Sender);           
                HRESULT OnHelp(/*in*/ IDispatch *Sender);
}
interface TrayIconEvents : IDispatch
{
	mixin(uuid("C191A5DF-072B-4331-9A83-3E985716730A"));
                HRESULT OnClick(/*in*/ IDispatch *Sender);
                HRESULT OnDblClick(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
                HRESULT OnMouseDown(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
                HRESULT OnMouseUp(/*in*/ IDispatch *Sender, /*in*/ LONG x,/*in*/ LONG y,/*in*/ LONG Button,/*in*/ LONG Flags);
};

interface EventHandlerEvents : IDispatch
{
	mixin(uuid("7E144038-C33F-4F65-8CE2-B833F4773101"));
                HRESULT OnExecute(/*in*/ IDispatch *Sender);
};

interface FontDialogEvents : IDispatch
{
	mixin(uuid("9C2C742B-33B5-4BCF-AEB9-640DF4D94374"));
                HRESULT OnHelp(/*in*/ IDispatch *Sender);

                HRESULT OnApply(/*in*/ IDispatch *Sender);
};

interface ColorDialogEvents : IDispatch
{
	mixin(uuid("B7B784F7-A097-4D24-BE47-E9842A532192"));

                HRESULT OnHelp(/*in*/ IDispatch *Sender);
};


//Extended Objects
interface Regions : IDispatch{
	mixin(uuid("179741BD-E3DA-4A18-B9C1-039785089B03"));
         HRESULT CombineRgn(/*in*/ ULONG hrgnSrc1, /*in*/ ULONG hrgnSrc2, /*in*/ LONG fnCombineMode, out IDispatch **pRegion);
         HRESULT CreateEllipticRgn(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pRegion);
         HRESULT CreatePolygonRgn(/*in*/ SAFEARRAY(VARIANT) Data, out IDispatch **pRegion);
         HRESULT CreateRectRgn(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, out IDispatch **pRegion);
         HRESULT CreateRoundRectRgn(/*in*/ LONG Left, /*in*/ LONG Top, /*in*/ LONG Width, /*in*/ LONG Height, /*in*/ LONG nWidthEllipse, /*in*/ LONG nHeightEllipse, out IDispatch **pRegion);
         HRESULT TransformRgn(/*in*/ ULONG ARegion, /*in*/ FLOAT eM11, /*in*/ FLOAT eM12, /*in*/ FLOAT eM21, /*in*/ FLOAT eM22, /*in*/ FLOAT eDx, /*in*/ FLOAT eDy, out IDispatch **pRegion);
         HRESULT EqualRgn(/*in*/ ULONG hSrcRgn1, /*in*/ ULONG hSrcRgn2, out VARIANT_BOOL *pResult);

         HRESULT CreateRgnFromImage(/*in*/ VARIANT Image, /*in*/ ULONG MaskColor, out IDispatch **Region);

};
interface Region : IDispatch{
	mixin(uuid("BB9FCB6F-2C14-4568-BADF-E7C0B022A654"));
        /*[propget]*/ HRESULT Value(out ULONG *pVal);
};
interface Screen : IDispatch{
	mixin(uuid("D0D86627-9E34-438F-92E2-8EC9C1ABE8C5"));
        /*[propget]*/ HRESULT Width(out LONG *pVal);
        /*[propget]*/ HRESULT Height(out LONG *pVal);
        /*[propget]*/ HRESULT PixelsPerInchX(out LONG *pVal);
        /*[propget]*/ HRESULT PixelsPerInchY(out LONG *pVal);
};
interface Hint : IDispatch{
	mixin(uuid("00017030-B197-4EBC-804F-748CF210108E"));
        /*[propget]*/ HRESULT Text(out BSTR *pVal);
        /*[propput]*/ HRESULT Text(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Title(out BSTR *pVal);
        /*[propput]*/ HRESULT Title(/*in*/ BSTR newVal);
        /*[propget]*/ HRESULT Image(out LONG *pVal);
        /*[propput]*/ HRESULT Image(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT Visible(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Visible(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT Balloon(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT Balloon(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT AlwaysTip(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT AlwaysTip(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT NoPrefix(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT NoPrefix(/*in*/ VARIANT_BOOL newVal);
        /*[propget]*/ HRESULT MaxWidth(out LONG *pVal);
        /*[propput]*/ HRESULT MaxWidth(/*in*/ LONG newVal);
        /*[propget]*/ HRESULT ParentData(out VARIANT_BOOL *pVal);
        /*[propput]*/ HRESULT ParentData(/*in*/ VARIANT_BOOL newVal);
};


interface EventHandler /*: Object*/{
	mixin(uuid("5273BA8F-609D-4959-9A72-92AD3EADA060"));

         HRESULT Execute();

        /*[propput]*/ HRESULT OnExecute(/*in*/ VARIANT newVal);
}

interface WindowSystemObjectExtensions : IDispatch{
	mixin(uuid("1DD6DE1E-DB95-45FE-B2A8-655177B8E8DB"));
         HRESULT SendMessage(/*in*/ VARIANT Control, LONG Message, LONG wParam, VARIANT lParam, out VARIANT *pVal);

         HRESULT PostMessage(/*in*/ VARIANT Control, LONG Message, LONG wParam, VARIANT lParam, out VARIANT *pVal);

         HRESULT AddMessageHandler(/*in*/ IDispatch *Control, LONG Message, VARIANT MessageHandler);
};

interface PrintInfo /*: Object*/{
	mixin(uuid("98C54138-A5B8-41AC-BDA6-D404983C28C6"));

        /*[propget]*/ HRESULT DocumentName(out BSTR *pVal);
        /*[propput]*/ HRESULT DocumentName(/*in*/ BSTR newVal);

        /*[propget]*/ HRESULT LeftMargin(out LONG *pVal);
        /*[propput]*/ HRESULT LeftMargin(/*in*/ LONG newVal);
        
        /*[propget]*/ HRESULT RightMargin(out LONG *pVal);
        /*[propput]*/ HRESULT RightMargin(/*in*/ LONG newVal);

        /*[propget]*/ HRESULT TopMargin(out LONG *pVal);
        /*[propput]*/ HRESULT TopMargin(/*in*/ LONG newVal);

        /*[propget]*/ HRESULT BottomMargin(out LONG *pVal);
       /*[propput]*/ HRESULT BottomMargin(/*in*/ LONG newVal);

        /*[propget]*/ HRESULT MarginMeasurement(out LONG *pVal);
        /*[propput]*/ HRESULT MarginMeasurement(/*in*/ LONG newVal);
         
}

