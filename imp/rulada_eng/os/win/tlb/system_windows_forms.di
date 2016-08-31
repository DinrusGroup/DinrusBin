// Version 2.0

/*[uuid("215d64d2-031c-33c7-96e3-61794cd1ee61")]*/
module os.win.tlb.system_windows_forms;

import os.win.tlb.mscorlib, os.win.tlb.accessibility, os.win.tlb.system;
private import os.win.com.core;

// Enums

enum Appearance {
  Appearance_Button = 0x00000001,
  Appearance_Normal = 0x00000000,
}

enum ArrangeDirection {
  ArrangeDirection_Down = 0x00000004,
  ArrangeDirection_Left = 0x00000000,
  ArrangeDirection_Right = 0x00000000,
  ArrangeDirection_Up = 0x00000004,
}

enum ImeMode {
  ImeMode_Alpha = 0x00000008,
  ImeMode_AlphaFull = 0x00000007,
  ImeMode_Close = 0x0000000B,
  ImeMode_Disable = 0x00000003,
  ImeMode_Hangul = 0x0000000A,
  ImeMode_HangulFull = 0x00000009,
  ImeMode_Hiragana = 0x00000004,
  ImeMode_Inherit = 0xFFFFFFFF,
  ImeMode_Katakana = 0x00000005,
  ImeMode_KatakanaHalf = 0x00000006,
  ImeMode_NoControl = 0x00000000,
  ImeMode_Off = 0x00000002,
  ImeMode_On = 0x00000001,
  ImeMode_OnHalf = 0x0000000C,
}

enum Keys {
  Keys_A = 0x00000041,
  Keys_Add = 0x0000006B,
  Keys_Alt = 0x00040000,
  Keys_Apps = 0x0000005D,
  Keys_Attn = 0x000000F6,
  Keys_B = 0x00000042,
  Keys_Back = 0x00000008,
  Keys_BrowserBack = 0x000000A6,
  Keys_BrowserFavorites = 0x000000AB,
  Keys_BrowserForward = 0x000000A7,
  Keys_BrowserHome = 0x000000AC,
  Keys_BrowserRefresh = 0x000000A8,
  Keys_BrowserSearch = 0x000000AA,
  Keys_BrowserStop = 0x000000A9,
  Keys_C = 0x00000043,
  Keys_Cancel = 0x00000003,
  Keys_Capital = 0x00000014,
  Keys_CapsLock = 0x00000014,
  Keys_Clear = 0x0000000C,
  Keys_Control = 0x00020000,
  Keys_ControlKey = 0x00000011,
  Keys_Crsel = 0x000000F7,
  Keys_D = 0x00000044,
  Keys_D0 = 0x00000030,
  Keys_D1 = 0x00000031,
  Keys_D2 = 0x00000032,
  Keys_D3 = 0x00000033,
  Keys_D4 = 0x00000034,
  Keys_D5 = 0x00000035,
  Keys_D6 = 0x00000036,
  Keys_D7 = 0x00000037,
  Keys_D8 = 0x00000038,
  Keys_D9 = 0x00000039,
  Keys_Decimal = 0x0000006E,
  Keys_Delete = 0x0000002E,
  Keys_Divide = 0x0000006F,
  Keys_Down = 0x00000028,
  Keys_E = 0x00000045,
  Keys_End = 0x00000023,
  Keys_Enter = 0x0000000D,
  Keys_EraseEof = 0x000000F9,
  Keys_Escape = 0x0000001B,
  Keys_Execute = 0x0000002B,
  Keys_Exsel = 0x000000F8,
  Keys_F = 0x00000046,
  Keys_F1 = 0x00000070,
  Keys_F10 = 0x00000079,
  Keys_F11 = 0x0000007A,
  Keys_F12 = 0x0000007B,
  Keys_F13 = 0x0000007C,
  Keys_F14 = 0x0000007D,
  Keys_F15 = 0x0000007E,
  Keys_F16 = 0x0000007F,
  Keys_F17 = 0x00000080,
  Keys_F18 = 0x00000081,
  Keys_F19 = 0x00000082,
  Keys_F2 = 0x00000071,
  Keys_F20 = 0x00000083,
  Keys_F21 = 0x00000084,
  Keys_F22 = 0x00000085,
  Keys_F23 = 0x00000086,
  Keys_F24 = 0x00000087,
  Keys_F3 = 0x00000072,
  Keys_F4 = 0x00000073,
  Keys_F5 = 0x00000074,
  Keys_F6 = 0x00000075,
  Keys_F7 = 0x00000076,
  Keys_F8 = 0x00000077,
  Keys_F9 = 0x00000078,
  Keys_FinalMode = 0x00000018,
  Keys_G = 0x00000047,
  Keys_H = 0x00000048,
  Keys_HanguelMode = 0x00000015,
  Keys_HangulMode = 0x00000015,
  Keys_HanjaMode = 0x00000019,
  Keys_Help = 0x0000002F,
  Keys_Home = 0x00000024,
  Keys_I = 0x00000049,
  Keys_IMEAccept = 0x0000001E,
  Keys_IMEAceept = 0x0000001E,
  Keys_IMEConvert = 0x0000001C,
  Keys_IMEModeChange = 0x0000001F,
  Keys_IMENonconvert = 0x0000001D,
  Keys_Insert = 0x0000002D,
  Keys_J = 0x0000004A,
  Keys_JunjaMode = 0x00000017,
  Keys_K = 0x0000004B,
  Keys_KanaMode = 0x00000015,
  Keys_KanjiMode = 0x00000019,
  Keys_KeyCode = 0x0000FFFF,
  Keys_L = 0x0000004C,
  Keys_LButton = 0x00000001,
  Keys_LControlKey = 0x000000A2,
  Keys_LMenu = 0x000000A4,
  Keys_LShiftKey = 0x000000A0,
  Keys_LWin = 0x0000005B,
  Keys_LaunchApplication1 = 0x000000B6,
  Keys_LaunchApplication2 = 0x000000B7,
  Keys_LaunchMail = 0x000000B4,
  Keys_Left = 0x00000025,
  Keys_LineFeed = 0x0000000A,
  Keys_M = 0x0000004D,
  Keys_MButton = 0x00000004,
  Keys_MediaNextTrack = 0x000000B0,
  Keys_MediaPlayPause = 0x000000B3,
  Keys_MediaPreviousTrack = 0x000000B1,
  Keys_MediaStop = 0x000000B2,
  Keys_Menu = 0x00000012,
  Keys_Modifiers = 0xFFFF0000,
  Keys_Multiply = 0x0000006A,
  Keys_N = 0x0000004E,
  Keys_Next = 0x00000022,
  Keys_NoName = 0x000000FC,
  Keys_None = 0x00000000,
  Keys_NumLock = 0x00000090,
  Keys_NumPad0 = 0x00000060,
  Keys_NumPad1 = 0x00000061,
  Keys_NumPad2 = 0x00000062,
  Keys_NumPad3 = 0x00000063,
  Keys_NumPad4 = 0x00000064,
  Keys_NumPad5 = 0x00000065,
  Keys_NumPad6 = 0x00000066,
  Keys_NumPad7 = 0x00000067,
  Keys_NumPad8 = 0x00000068,
  Keys_NumPad9 = 0x00000069,
  Keys_O = 0x0000004F,
  Keys_Oem1 = 0x000000BA,
  Keys_Oem102 = 0x000000E2,
  Keys_Oem2 = 0x000000BF,
  Keys_Oem3 = 0x000000C0,
  Keys_Oem4 = 0x000000DB,
  Keys_Oem5 = 0x000000DC,
  Keys_Oem6 = 0x000000DD,
  Keys_Oem7 = 0x000000DE,
  Keys_Oem8 = 0x000000DF,
  Keys_OemBackslash = 0x000000E2,
  Keys_OemClear = 0x000000FE,
  Keys_OemCloseBrackets = 0x000000DD,
  Keys_OemMinus = 0x000000BD,
  Keys_OemOpenBrackets = 0x000000DB,
  Keys_OemPeriod = 0x000000BE,
  Keys_OemPipe = 0x000000DC,
  Keys_OemQuestion = 0x000000BF,
  Keys_OemQuotes = 0x000000DE,
  Keys_OemSemicolon = 0x000000BA,
  Keys_Oemcomma = 0x000000BC,
  Keys_Oemplus = 0x000000BB,
  Keys_Oemtilde = 0x000000C0,
  Keys_P = 0x00000050,
  Keys_Pa1 = 0x000000FD,
  Keys_Packet = 0x000000E7,
  Keys_PageDown = 0x00000022,
  Keys_PageUp = 0x00000021,
  Keys_Pause = 0x00000013,
  Keys_Play = 0x000000FA,
  Keys_Print = 0x0000002A,
  Keys_PrintScreen = 0x0000002C,
  Keys_Prior = 0x00000021,
  Keys_ProcessKey = 0x000000E5,
  Keys_Q = 0x00000051,
  Keys_R = 0x00000052,
  Keys_RButton = 0x00000002,
  Keys_RControlKey = 0x000000A3,
  Keys_RMenu = 0x000000A5,
  Keys_RShiftKey = 0x000000A1,
  Keys_RWin = 0x0000005C,
  Keys_Return = 0x0000000D,
  Keys_Right = 0x00000027,
  Keys_S = 0x00000053,
  Keys_Scroll = 0x00000091,
  Keys_Select = 0x00000029,
  Keys_SelectMedia = 0x000000B5,
  Keys_Separator = 0x0000006C,
  Keys_Shift = 0x00010000,
  Keys_ShiftKey = 0x00000010,
  Keys_Sleep = 0x0000005F,
  Keys_Snapshot = 0x0000002C,
  Keys_Space = 0x00000020,
  Keys_Subtract = 0x0000006D,
  Keys_T = 0x00000054,
  Keys_Tab = 0x00000009,
  Keys_U = 0x00000055,
  Keys_Up = 0x00000026,
  Keys_V = 0x00000056,
  Keys_VolumeDown = 0x000000AE,
  Keys_VolumeMute = 0x000000AD,
  Keys_VolumeUp = 0x000000AF,
  Keys_W = 0x00000057,
  Keys_X = 0x00000058,
  Keys_XButton1 = 0x00000005,
  Keys_XButton2 = 0x00000006,
  Keys_Y = 0x00000059,
  Keys_Z = 0x0000005A,
  Keys_Zoom = 0x000000FB,
}

enum Border3DSide {
  Border3DSide_All = 0x0000080F,
  Border3DSide_Bottom = 0x00000008,
  Border3DSide_Left = 0x00000001,
  Border3DSide_Middle = 0x00000800,
  Border3DSide_Right = 0x00000004,
  Border3DSide_Top = 0x00000002,
}

enum Border3DStyle {
  Border3DStyle_Adjust = 0x00002000,
  Border3DStyle_Bump = 0x00000009,
  Border3DStyle_Etched = 0x00000006,
  Border3DStyle_Flat = 0x0000400A,
  Border3DStyle_Raised = 0x00000005,
  Border3DStyle_RaisedInner = 0x00000004,
  Border3DStyle_RaisedOuter = 0x00000001,
  Border3DStyle_Sunken = 0x0000000A,
  Border3DStyle_SunkenInner = 0x00000008,
  Border3DStyle_SunkenOuter = 0x00000002,
}

enum BorderStyle {
  BorderStyle_Fixed3D = 0x00000002,
  BorderStyle_FixedSingle = 0x00000001,
  BorderStyle_None = 0x00000000,
}

enum DialogResult {
  DialogResult_Abort = 0x00000003,
  DialogResult_Cancel = 0x00000002,
  DialogResult_Ignore = 0x00000005,
  DialogResult_No = 0x00000007,
  DialogResult_None = 0x00000000,
  DialogResult_OK = 0x00000001,
  DialogResult_Retry = 0x00000004,
  DialogResult_Yes = 0x00000006,
}

enum SelectionMode {
  SelectionMode_MultiExtended = 0x00000003,
  SelectionMode_MultiSimple = 0x00000002,
  SelectionMode_None = 0x00000000,
  SelectionMode_One = 0x00000001,
}

enum HorizontalAlignment {
  HorizontalAlignment_Center = 0x00000002,
  HorizontalAlignment_Left = 0x00000000,
  HorizontalAlignment_Right = 0x00000001,
}

enum LeftRightAlignment {
  LeftRightAlignment_Left = 0x00000000,
  LeftRightAlignment_Right = 0x00000001,
}

enum MouseButtons {
  MouseButtons_Left = 0x00100000,
  MouseButtons_Middle = 0x00400000,
  MouseButtons_None = 0x00000000,
  MouseButtons_Right = 0x00200000,
  MouseButtons_XButton1 = 0x00800000,
  MouseButtons_XButton2 = 0x01000000,
}

enum DataGridViewElementStates {
  DataGridViewElementStates_Displayed = 0x00000001,
  DataGridViewElementStates_Frozen = 0x00000002,
  DataGridViewElementStates_None = 0x00000000,
  DataGridViewElementStates_ReadOnly = 0x00000004,
  DataGridViewElementStates_Resizable = 0x00000008,
  DataGridViewElementStates_ResizableSet = 0x00000010,
  DataGridViewElementStates_Selected = 0x00000020,
  DataGridViewElementStates_Visible = 0x00000040,
}

enum DragAction {
  DragAction_Cancel = 0x00000002,
  DragAction_Continue = 0x00000000,
  DragAction_Drop = 0x00000001,
}

enum FormBorderStyle {
  FormBorderStyle_Fixed3D = 0x00000002,
  FormBorderStyle_FixedDialog = 0x00000003,
  FormBorderStyle_FixedSingle = 0x00000001,
  FormBorderStyle_FixedToolWindow = 0x00000005,
  FormBorderStyle_None = 0x00000000,
  FormBorderStyle_Sizable = 0x00000004,
  FormBorderStyle_SizableToolWindow = 0x00000006,
}

enum FormStartPosition {
  FormStartPosition_CenterParent = 0x00000004,
  FormStartPosition_CenterScreen = 0x00000001,
  FormStartPosition_Manual = 0x00000000,
  FormStartPosition_WindowsDefaultBounds = 0x00000003,
  FormStartPosition_WindowsDefaultLocation = 0x00000002,
}

enum FormWindowState {
  FormWindowState_Maximized = 0x00000002,
  FormWindowState_Minimized = 0x00000001,
  FormWindowState_Normal = 0x00000000,
}

enum Shortcut {
  Shortcut_Alt0 = 0x00040030,
  Shortcut_Alt1 = 0x00040031,
  Shortcut_Alt2 = 0x00040032,
  Shortcut_Alt3 = 0x00040033,
  Shortcut_Alt4 = 0x00040034,
  Shortcut_Alt5 = 0x00040035,
  Shortcut_Alt6 = 0x00040036,
  Shortcut_Alt7 = 0x00040037,
  Shortcut_Alt8 = 0x00040038,
  Shortcut_Alt9 = 0x00040039,
  Shortcut_AltBksp = 0x00040008,
  Shortcut_AltDownArrow = 0x00040028,
  Shortcut_AltF1 = 0x00040070,
  Shortcut_AltF10 = 0x00040079,
  Shortcut_AltF11 = 0x0004007A,
  Shortcut_AltF12 = 0x0004007B,
  Shortcut_AltF2 = 0x00040071,
  Shortcut_AltF3 = 0x00040072,
  Shortcut_AltF4 = 0x00040073,
  Shortcut_AltF5 = 0x00040074,
  Shortcut_AltF6 = 0x00040075,
  Shortcut_AltF7 = 0x00040076,
  Shortcut_AltF8 = 0x00040077,
  Shortcut_AltF9 = 0x00040078,
  Shortcut_AltLeftArrow = 0x00040025,
  Shortcut_AltRightArrow = 0x00040027,
  Shortcut_AltUpArrow = 0x00040026,
  Shortcut_Ctrl0 = 0x00020030,
  Shortcut_Ctrl1 = 0x00020031,
  Shortcut_Ctrl2 = 0x00020032,
  Shortcut_Ctrl3 = 0x00020033,
  Shortcut_Ctrl4 = 0x00020034,
  Shortcut_Ctrl5 = 0x00020035,
  Shortcut_Ctrl6 = 0x00020036,
  Shortcut_Ctrl7 = 0x00020037,
  Shortcut_Ctrl8 = 0x00020038,
  Shortcut_Ctrl9 = 0x00020039,
  Shortcut_CtrlA = 0x00020041,
  Shortcut_CtrlB = 0x00020042,
  Shortcut_CtrlC = 0x00020043,
  Shortcut_CtrlD = 0x00020044,
  Shortcut_CtrlDel = 0x0002002E,
  Shortcut_CtrlE = 0x00020045,
  Shortcut_CtrlF = 0x00020046,
  Shortcut_CtrlF1 = 0x00020070,
  Shortcut_CtrlF10 = 0x00020079,
  Shortcut_CtrlF11 = 0x0002007A,
  Shortcut_CtrlF12 = 0x0002007B,
  Shortcut_CtrlF2 = 0x00020071,
  Shortcut_CtrlF3 = 0x00020072,
  Shortcut_CtrlF4 = 0x00020073,
  Shortcut_CtrlF5 = 0x00020074,
  Shortcut_CtrlF6 = 0x00020075,
  Shortcut_CtrlF7 = 0x00020076,
  Shortcut_CtrlF8 = 0x00020077,
  Shortcut_CtrlF9 = 0x00020078,
  Shortcut_CtrlG = 0x00020047,
  Shortcut_CtrlH = 0x00020048,
  Shortcut_CtrlI = 0x00020049,
  Shortcut_CtrlIns = 0x0002002D,
  Shortcut_CtrlJ = 0x0002004A,
  Shortcut_CtrlK = 0x0002004B,
  Shortcut_CtrlL = 0x0002004C,
  Shortcut_CtrlM = 0x0002004D,
  Shortcut_CtrlN = 0x0002004E,
  Shortcut_CtrlO = 0x0002004F,
  Shortcut_CtrlP = 0x00020050,
  Shortcut_CtrlQ = 0x00020051,
  Shortcut_CtrlR = 0x00020052,
  Shortcut_CtrlS = 0x00020053,
  Shortcut_CtrlShift0 = 0x00030030,
  Shortcut_CtrlShift1 = 0x00030031,
  Shortcut_CtrlShift2 = 0x00030032,
  Shortcut_CtrlShift3 = 0x00030033,
  Shortcut_CtrlShift4 = 0x00030034,
  Shortcut_CtrlShift5 = 0x00030035,
  Shortcut_CtrlShift6 = 0x00030036,
  Shortcut_CtrlShift7 = 0x00030037,
  Shortcut_CtrlShift8 = 0x00030038,
  Shortcut_CtrlShift9 = 0x00030039,
  Shortcut_CtrlShiftA = 0x00030041,
  Shortcut_CtrlShiftB = 0x00030042,
  Shortcut_CtrlShiftC = 0x00030043,
  Shortcut_CtrlShiftD = 0x00030044,
  Shortcut_CtrlShiftE = 0x00030045,
  Shortcut_CtrlShiftF = 0x00030046,
  Shortcut_CtrlShiftF1 = 0x00030070,
  Shortcut_CtrlShiftF10 = 0x00030079,
  Shortcut_CtrlShiftF11 = 0x0003007A,
  Shortcut_CtrlShiftF12 = 0x0003007B,
  Shortcut_CtrlShiftF2 = 0x00030071,
  Shortcut_CtrlShiftF3 = 0x00030072,
  Shortcut_CtrlShiftF4 = 0x00030073,
  Shortcut_CtrlShiftF5 = 0x00030074,
  Shortcut_CtrlShiftF6 = 0x00030075,
  Shortcut_CtrlShiftF7 = 0x00030076,
  Shortcut_CtrlShiftF8 = 0x00030077,
  Shortcut_CtrlShiftF9 = 0x00030078,
  Shortcut_CtrlShiftG = 0x00030047,
  Shortcut_CtrlShiftH = 0x00030048,
  Shortcut_CtrlShiftI = 0x00030049,
  Shortcut_CtrlShiftJ = 0x0003004A,
  Shortcut_CtrlShiftK = 0x0003004B,
  Shortcut_CtrlShiftL = 0x0003004C,
  Shortcut_CtrlShiftM = 0x0003004D,
  Shortcut_CtrlShiftN = 0x0003004E,
  Shortcut_CtrlShiftO = 0x0003004F,
  Shortcut_CtrlShiftP = 0x00030050,
  Shortcut_CtrlShiftQ = 0x00030051,
  Shortcut_CtrlShiftR = 0x00030052,
  Shortcut_CtrlShiftS = 0x00030053,
  Shortcut_CtrlShiftT = 0x00030054,
  Shortcut_CtrlShiftU = 0x00030055,
  Shortcut_CtrlShiftV = 0x00030056,
  Shortcut_CtrlShiftW = 0x00030057,
  Shortcut_CtrlShiftX = 0x00030058,
  Shortcut_CtrlShiftY = 0x00030059,
  Shortcut_CtrlShiftZ = 0x0003005A,
  Shortcut_CtrlT = 0x00020054,
  Shortcut_CtrlU = 0x00020055,
  Shortcut_CtrlV = 0x00020056,
  Shortcut_CtrlW = 0x00020057,
  Shortcut_CtrlX = 0x00020058,
  Shortcut_CtrlY = 0x00020059,
  Shortcut_CtrlZ = 0x0002005A,
  Shortcut_Del = 0x0000002E,
  Shortcut_F1 = 0x00000070,
  Shortcut_F10 = 0x00000079,
  Shortcut_F11 = 0x0000007A,
  Shortcut_F12 = 0x0000007B,
  Shortcut_F2 = 0x00000071,
  Shortcut_F3 = 0x00000072,
  Shortcut_F4 = 0x00000073,
  Shortcut_F5 = 0x00000074,
  Shortcut_F6 = 0x00000075,
  Shortcut_F7 = 0x00000076,
  Shortcut_F8 = 0x00000077,
  Shortcut_F9 = 0x00000078,
  Shortcut_Ins = 0x0000002D,
  Shortcut_None = 0x00000000,
  Shortcut_ShiftDel = 0x0001002E,
  Shortcut_ShiftF1 = 0x00010070,
  Shortcut_ShiftF10 = 0x00010079,
  Shortcut_ShiftF11 = 0x0001007A,
  Shortcut_ShiftF12 = 0x0001007B,
  Shortcut_ShiftF2 = 0x00010071,
  Shortcut_ShiftF3 = 0x00010072,
  Shortcut_ShiftF4 = 0x00010073,
  Shortcut_ShiftF5 = 0x00010074,
  Shortcut_ShiftF6 = 0x00010075,
  Shortcut_ShiftF7 = 0x00010076,
  Shortcut_ShiftF8 = 0x00010077,
  Shortcut_ShiftF9 = 0x00010078,
  Shortcut_ShiftIns = 0x0001002D,
}

enum SystemParameter {
  SystemParameter_CaretWidthMetric = 0x00000008,
  SystemParameter_DropShadow = 0x00000000,
  SystemParameter_FlatMenu = 0x00000001,
  SystemParameter_FontSmoothingContrastMetric = 0x00000002,
  SystemParameter_FontSmoothingTypeMetric = 0x00000003,
  SystemParameter_HorizontalFocusThicknessMetric = 0x0000000A,
  SystemParameter_MenuFadeEnabled = 0x00000004,
  SystemParameter_SelectionFade = 0x00000005,
  SystemParameter_ToolTipAnimationMetric = 0x00000006,
  SystemParameter_UIEffects = 0x00000007,
  SystemParameter_VerticalFocusThicknessMetric = 0x00000009,
}

enum PropertySort {
  PropertySort_Alphabetical = 0x00000001,
  PropertySort_Categorized = 0x00000002,
  PropertySort_CategorizedAlphabetical = 0x00000003,
  PropertySort_NoSort = 0x00000000,
}

enum ScrollEventType {
  ScrollEventType_EndScroll = 0x00000008,
  ScrollEventType_First = 0x00000006,
  ScrollEventType_LargeDecrement = 0x00000002,
  ScrollEventType_LargeIncrement = 0x00000003,
  ScrollEventType_Last = 0x00000007,
  ScrollEventType_SmallDecrement = 0x00000000,
  ScrollEventType_SmallIncrement = 0x00000001,
  ScrollEventType_ThumbPosition = 0x00000004,
  ScrollEventType_ThumbTrack = 0x00000005,
}

enum ToolStripStatusLabelBorderSides {
  ToolStripStatusLabelBorderSides_All = 0x0000000F,
  ToolStripStatusLabelBorderSides_Bottom = 0x00000008,
  ToolStripStatusLabelBorderSides_Left = 0x00000001,
  ToolStripStatusLabelBorderSides_None = 0x00000000,
  ToolStripStatusLabelBorderSides_Right = 0x00000004,
  ToolStripStatusLabelBorderSides_Top = 0x00000002,
}

enum TreeViewHitTestLocations {
  TreeViewHitTestLocations_AboveClientArea = 0x00000100,
  TreeViewHitTestLocations_BelowClientArea = 0x00000200,
  TreeViewHitTestLocations_Image = 0x00000002,
  TreeViewHitTestLocations_Indent = 0x00000008,
  TreeViewHitTestLocations_Label = 0x00000004,
  TreeViewHitTestLocations_LeftOfClientArea = 0x00000800,
  TreeViewHitTestLocations_None = 0x00000001,
  TreeViewHitTestLocations_PlusMinus = 0x00000010,
  TreeViewHitTestLocations_RightOfClientArea = 0x00000400,
  TreeViewHitTestLocations_RightOfLabel = 0x00000020,
  TreeViewHitTestLocations_StateImage = 0x00000040,
}

// Interfaces

interface IWin32Window : IUnknown {
  mixin(uuid("458ab8a2-a1ea-4d7b-8ebe-dee5d3d9442c"));
  /*[id(0x60010000)]*/ int get_Handle(out int pRetVal);
}

interface IDataObject : IDispatch {
  mixin(uuid("3cee8cc1-1adb-327f-9b97-7a9c8089bfb3"));
  /*[id(0x60020000)]*/ int GetData(wchar* format, short autoConvert, out VARIANT pRetVal);
  /*[id(0x60020001)]*/ int GetData_2(wchar* format, out VARIANT pRetVal);
  /*[id(0x60020002)]*/ int GetData_3(_Type format, out VARIANT pRetVal);
  /*[id(0x60020003)]*/ int SetData(wchar* format, short autoConvert, VARIANT data);
  /*[id(0x60020004)]*/ int SetData_2(wchar* format, VARIANT data);
  /*[id(0x60020005)]*/ int SetData_3(_Type format, VARIANT data);
  /*[id(0x60020006)]*/ int SetData_4(VARIANT data);
  /*[id(0x60020007)]*/ int GetDataPresent(wchar* format, short autoConvert, out short pRetVal);
  /*[id(0x60020008)]*/ int GetDataPresent_2(wchar* format, out short pRetVal);
  /*[id(0x60020009)]*/ int GetDataPresent_3(_Type format, out short pRetVal);
  /*[id(0x6002000A)]*/ int GetFormats(short autoConvert, out  SAFEARRAY pRetVal);
  /*[id(0x6002000B)]*/ int GetFormats_2(out  SAFEARRAY pRetVal);
}

interface _AccessibleObject : IDispatch {
  mixin(uuid("399c0499-29d3-3d95-af77-111dcdb92177"));
}

interface _Form : IDispatch {
  mixin(uuid("ad0c79db-37be-3b61-9c53-2e4857237227"));
}

interface _AxHost : IDispatch {
  mixin(uuid("548054d5-75c5-3a72-a87b-d6f305254065"));
}

interface _Control : IDispatch {
  mixin(uuid("83acbfae-1a16-33eb-aba0-ba8df0b206d7"));
}

interface _ContainerControl : IDispatch {
  mixin(uuid("a5af2165-c1be-39af-ab35-cd950d01a701"));
}

interface _BindingNavigator : IDispatch {
  mixin(uuid("e3ff0d90-9e82-3736-a253-3b2f41ef981a"));
}

interface _ToolStrip : IDispatch {
  mixin(uuid("a81676fd-eaa3-39c3-9354-a58951270eb6"));
}

interface _Button : IDispatch {
  mixin(uuid("9486855d-b3a4-32e8-af74-ec881982e3ff"));
}

interface _ButtonBase : IDispatch {
  mixin(uuid("d14c1282-8647-317e-a549-d2cbcc264c3a"));
}

interface _MouseEventArgs : IDispatch {
  mixin(uuid("276a1a21-aaef-3378-8902-01f695868ff9"));
}

interface _ButtonBaseAccessibleObject : IDispatch {
  mixin(uuid("4343b837-6ec8-3e43-8a59-046c35024677"));
}

interface _ControlAccessibleObject : IDispatch {
  mixin(uuid("7496e5c0-90d3-372e-885f-bdd1a0316856"));
}

interface _KeyEventArgs : IDispatch {
  mixin(uuid("4aaa99aa-77b1-3cf7-85d8-d9cf69271ac6"));
}

interface _CheckBox : IDispatch {
  mixin(uuid("1c7817c6-6a49-301e-b20a-05ff053c3d56"));
}

interface _CheckBoxAccessibleObject : IDispatch {
  mixin(uuid("5d9fce71-04c3-395e-b972-f1205e8de615"));
}

interface _CheckedListBox : IDispatch {
  mixin(uuid("1833c4c9-4e61-3d96-aeb5-65b43de96a01"));
}

interface _ListBox : IDispatch {
  mixin(uuid("e36590e6-cfd5-340e-9650-73500a802c43"));
}

interface _KeyPressEventArgs : IDispatch {
  mixin(uuid("b8755bc8-51fe-3d19-a3ec-5a5a5cf120e0"));
}

interface _ItemCheckEventArgs : IDispatch {
  mixin(uuid("29bdf32d-e055-38e7-8dcb-920a3038fef7"));
}

interface _ListView : IDispatch {
  mixin(uuid("a87aed55-dda4-3668-befa-1a776496dd3e"));
}

interface _ComboBox : IDispatch {
  mixin(uuid("2efec16e-eec9-39a3-9d8a-5e72b5c14f78"));
}

interface _ListControl : IDispatch {
  mixin(uuid("d58dff0c-34c3-3d1e-8251-5f83ee7367c9"));
}

interface _ChildAccessibleObject : IDispatch {
  mixin(uuid("518f00c6-2aab-3b25-a76a-f62883781e18"));
}

interface _ScrollableControl : IDispatch {
  mixin(uuid("812a8b20-cb02-3483-8a29-424c6cdac4b7"));
}

interface _ContextMenuStrip : IDispatch {
  mixin(uuid("4b4939af-61c1-378f-bdf0-68b9b3ee48e3"));
}

interface _ToolStripDropDownMenu : IDispatch {
  mixin(uuid("8e07fa2c-b44b-3818-ba44-d88f2a69e8b6"));
}

interface _DragEventArgs : IDispatch {
  mixin(uuid("aedf37ab-9041-3d55-9aca-bdede24566d2"));
}

interface _GiveFeedbackEventArgs : IDispatch {
  mixin(uuid("77ad1d22-59c4-3634-9d55-50291cda49f6"));
}

interface _HelpEventArgs : IDispatch {
  mixin(uuid("7fa2b402-744d-34f5-ad8b-bd7c018b31f5"));
}

interface _QueryContinueDragEventArgs : IDispatch {
  mixin(uuid("9fd0d341-0808-3a17-a978-adb5ed517f59"));
}

interface _DataGrid : IDispatch {
  mixin(uuid("518a56e2-fbce-3386-bb15-4a0f67872bdc"));
}

interface _ScrollBar : IDispatch {
  mixin(uuid("59c5a9ad-941b-3279-bed8-edcc2951cadc"));
}

interface _NavigateEventArgs : IDispatch {
  mixin(uuid("42959ece-0606-3758-9679-a48e88f9baf8"));
}

interface _ScrollEventArgs : IDispatch {
  mixin(uuid("ccd8c82c-dfbf-3e14-be9b-38555f6221f2"));
}

interface _DataGridTextBox : IDispatch {
  mixin(uuid("2780e0d4-2b06-3e1f-addf-d8dbbb3fb960"));
}

interface _TextBox : IDispatch {
  mixin(uuid("eaef4300-9fb3-306f-8f67-180deb8ddfb7"));
}

interface _DataGridView : IDispatch {
  mixin(uuid("5968374c-8f43-353b-8f0a-780a0a7ddb79"));
}

interface _Panel : IDispatch {
  mixin(uuid("549a3dd8-d85f-3d08-87e2-49b08490008b"));
}

interface _DataGridViewComboBoxEditingControl : IDispatch {
  mixin(uuid("c6615083-0a23-3997-a54b-f618eb824af0"));
}

interface _DataGridViewTextBoxEditingControl : IDispatch {
  mixin(uuid("a7750701-44a2-353a-923a-7ba68a8e22af"));
}

interface _DateTimePicker : IDispatch {
  mixin(uuid("2bad7d35-895f-3d4a-b883-0b3cd324b8bd"));
}

interface _DateTimePickerAccessibleObject : IDispatch {
  mixin(uuid("5bef6f14-89f8-3ad5-be92-0649cfa5abb1"));
}

interface _DomainUpDown : IDispatch {
  mixin(uuid("44792a74-5dd8-3410-a897-f568e4e58161"));
}

interface _UpDownBase : IDispatch {
  mixin(uuid("c26446ac-e09b-3545-b01a-5575923636c3"));
}

interface _DomainItemAccessibleObject : IDispatch {
  mixin(uuid("0d46da02-69fb-3a29-9ac6-395925c38479"));
}

interface _DomainUpDownAccessibleObject : IDispatch {
  mixin(uuid("131b8005-94c2-37d5-b738-cd2337635e73"));
}

interface _FlowLayoutPanel : IDispatch {
  mixin(uuid("b55c4c83-1f69-3d93-9c4e-2aa5619e0c68"));
}

interface _MenuStrip : IDispatch {
  mixin(uuid("eb5a3078-05d9-3f32-9045-89f756938a3d"));
}

interface _GroupBox : IDispatch {
  mixin(uuid("11b0b536-2f72-3a3f-b2a3-0420a9f5041f"));
}

interface _HScrollBar : IDispatch {
  mixin(uuid("7bc4a820-b20f-3ece-bdd6-ee7e14eb7e0d"));
}

interface _ItemDragEventArgs : IDispatch {
  mixin(uuid("7fa2a2c6-276c-3f23-af2a-800ccd05cff2"));
}

interface _Label : IDispatch {
  mixin(uuid("00ae8203-987d-3b7e-9448-5b3393282d7f"));
}

interface _LinkClickedEventArgs : IDispatch {
  mixin(uuid("93194740-9a53-3d3e-902c-240fbe0c90e4"));
}

interface _LinkLabel : IDispatch {
  mixin(uuid("4ee61c0d-d2d5-3a50-972b-c0a957d3a541"));
}

interface _LinkLabelLinkClickedEventArgs : IDispatch {
  mixin(uuid("cb38ae7b-5208-351d-8b84-3eca81de0f34"));
}

interface _ListViewItemMouseHoverEventArgs : IDispatch {
  mixin(uuid("a2f121d8-4775-3fb2-93a3-c5862ae8c359"));
}

interface _MaskedTextBox : IDispatch {
  mixin(uuid("22b0c1a9-e74e-381a-babb-66bef71ff08e"));
}

interface _TextBoxBase : IDispatch {
  mixin(uuid("abc30865-8929-3f02-9d70-6c3d68c83837"));
}

interface _MdiClient : IDispatch {
  mixin(uuid("6ab0bb67-4a4b-32f9-a18a-6481916c946f"));
}

interface _MonthCalendar : IDispatch {
  mixin(uuid("c3fa9ea8-275e-35e9-89da-18b1fca593ee"));
}

interface _NumericUpDown : IDispatch {
  mixin(uuid("2ad9f14a-0097-3c69-9f8e-5ddb52f3878b"));
}

interface _PictureBox : IDispatch {
  mixin(uuid("bb1c5180-87d0-330c-b698-ee2132df362e"));
}

interface _PrintPreviewControl : IDispatch {
  mixin(uuid("fa3b8143-ecb8-3a38-9de5-db0eea708b5f"));
}

interface _PrintPreviewDialog : IDispatch {
  mixin(uuid("57c090d5-80bc-33b8-b782-706a8d833767"));
}

interface _ProgressBar : IDispatch {
  mixin(uuid("8e935bcb-21e1-377c-a59f-89f7ba5a4e0f"));
}

interface _PropertyGrid : IDispatch {
  mixin(uuid("0c831618-60d7-32b2-9790-1ebdc5adefe5"));
}

interface _PropertyTabChangedEventArgs : IDispatch {
  mixin(uuid("db6fe495-8f5b-3c66-9a17-4c40d5593906"));
}

interface _PropertyValueChangedEventArgs : IDispatch {
  mixin(uuid("6d43df59-7ea8-300f-acb2-760a070cfcf2"));
}

interface _QueryAccessibilityHelpEventArgs : IDispatch {
  mixin(uuid("2fe9f084-1511-3052-be7c-9010b522c10e"));
}

interface _RadioButton : IDispatch {
  mixin(uuid("3e431682-bbde-31b1-ae7f-9d8dd582bd0d"));
}

interface _RadioButtonAccessibleObject : IDispatch {
  mixin(uuid("edc3c736-47fd-3f25-90e4-123234d64fd4"));
}

interface _RichTextBox : IDispatch {
  mixin(uuid("1b264763-a1c7-3441-9d61-7edaec2d0c44"));
}

interface _SplitContainer : IDispatch {
  mixin(uuid("c1da069e-4c0b-3664-bba1-f81864825085"));
}

interface _SplitterPanel : IDispatch {
  mixin(uuid("3a4c8b1a-4af9-344a-bc88-dfe863328c86"));
}

interface _SplitterEventArgs : IDispatch {
  mixin(uuid("8e61ad1d-76ae-3501-9b36-481bfebd3e3e"));
}

interface _Splitter : IDispatch {
  mixin(uuid("c318a56d-0b03-3a5a-93f6-7df0b3268237"));
}

interface _StatusBar : IDispatch {
  mixin(uuid("93409da8-fe37-3d4e-9a08-b35b34122c64"));
}

interface _StatusStrip : IDispatch {
  mixin(uuid("71ca209d-40d3-3409-b341-da9b922cca45"));
}

interface _TabControl : IDispatch {
  mixin(uuid("470de738-5261-302a-b205-4744652d2fd3"));
}

interface _TabPage : IDispatch {
  mixin(uuid("59183431-bd56-33d2-a2ed-fa414adf8dcb"));
}

interface _TableLayoutPanel : IDispatch {
  mixin(uuid("05cbe5b2-0292-37de-be51-5b7599ca5a11"));
}

interface _ThreadExceptionDialog : IDispatch {
  mixin(uuid("b00aa2f6-4d83-3937-b4ac-4c2c2c3f6c70"));
}

interface _ToolBar : IDispatch {
  mixin(uuid("f6ab38b6-1c02-3b01-a7f8-510ed1c0b253"));
}

interface _ToolStripAccessibleObject : IDispatch {
  mixin(uuid("6f7a7383-2abe-39d6-85f6-7117ed41979c"));
}

interface _ToolStripContainer : IDispatch {
  mixin(uuid("2a42f137-d50d-3d62-af58-4df7a4f57c9b"));
}

interface _ToolStripPanel : IDispatch {
  mixin(uuid("fb97c26a-fb56-3f71-bbc4-b1377e7b142d"));
}

interface _ToolStripContentPanel : IDispatch {
  mixin(uuid("6ee3853e-ddef-3f29-8f1b-1ed7180d9229"));
}

interface _ToolStripDropDown : IDispatch {
  mixin(uuid("c2322b43-25b3-3b30-b3db-67e4da2e6533"));
}

interface _ToolStripDropDownAccessibleObject : IDispatch {
  mixin(uuid("df0d9304-0e85-3ffc-8283-6f291f32ee61"));
}

interface _ToolStripItemAccessibleObject : IDispatch {
  mixin(uuid("8fd9748a-d04f-3dfb-96a8-5624290f4554"));
}

interface _ToolStripOverflow : IDispatch {
  mixin(uuid("75781ce7-317d-3c54-95d4-3e4dc04b4d3f"));
}

interface _TrackBar : IDispatch {
  mixin(uuid("7a8cc9ad-4e8d-3aaf-941a-1511c9c1372a"));
}

interface _TreeView : IDispatch {
  mixin(uuid("ba97ed62-9ebd-34e8-94ad-f71aef67deff"));
}

interface _TreeNodeMouseHoverEventArgs : IDispatch {
  mixin(uuid("f51edf6c-9e49-334a-8aae-b0c7c631abe4"));
}

interface _UserControl : IDispatch {
  mixin(uuid("6beedf4b-b688-3c0d-8b16-d53290790dfb"));
}

interface _VScrollBar : IDispatch {
  mixin(uuid("469d64ec-eb30-3462-a93b-e01baa5caf83"));
}

interface _WebBrowser : IDispatch {
  mixin(uuid("bb134d18-9643-3862-aa3b-17ebdb1a0def"));
}

interface _WebBrowserBase : IDispatch {
  mixin(uuid("764905a9-b10e-3c61-96dd-fa6f4bf8648d"));
}

interface _ComponentEditorForm : IDispatch {
  mixin(uuid("a7006efc-6e21-3b74-a9d7-9a2f12e46c8e"));
}

interface _ComponentEditorPage : IDispatch {
  mixin(uuid("c858a49a-fdcb-395d-bbb8-9b2b66dc0fb5"));
}

// CoClasses

abstract final class AccessibleObject {
  mixin(uuid("d0cba7af-93f5-378a-bb11-2a5d9aa9c4d7"));
  mixin Interfaces!(_AccessibleObject, _Object, IReflect, IAccessible);
}

abstract final class Form {
  mixin(uuid("c60f986a-d86b-3e50-b959-83f196be2e16"));
  mixin Interfaces!(_Form, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class Control {
  mixin(uuid("d51be7d3-5ea4-3d65-b9c5-b9087e6f974f"));
  mixin Interfaces!(_Control, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ContainerControl {
  mixin(uuid("bd20e131-9782-3651-ae3a-4bbaaddc62d8"));
  mixin Interfaces!(_ContainerControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class BindingNavigator {
  mixin(uuid("8d907746-455e-39a7-bd31-bc9f81468347"));
  mixin Interfaces!(_BindingNavigator, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStrip {
  mixin(uuid("daf7a547-5a5d-3095-9268-1425f428702e"));
  mixin Interfaces!(_ToolStrip, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class Button {
  mixin(uuid("1fcbda5d-6f09-3a66-acb8-1b0d748f5c13"));
  mixin Interfaces!(_Button, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class CheckBox {
  mixin(uuid("c2d6ea6e-e423-3b53-b06b-419f95f34f68"));
  mixin Interfaces!(_CheckBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class CheckedListBox {
  mixin(uuid("d8004aa1-697a-30c4-869e-f8f82595e05a"));
  mixin Interfaces!(_CheckedListBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ListBox {
  mixin(uuid("d7ac7195-477c-3aba-ba10-6cf8be334a86"));
  mixin Interfaces!(_ListBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ListView {
  mixin(uuid("53dcac10-bf48-3670-be8a-7e38ff839c71"));
  mixin Interfaces!(_ListView, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ComboBox {
  mixin(uuid("fe644ca9-e687-308b-af40-1d0cfabd2ad8"));
  mixin Interfaces!(_ComboBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ScrollableControl {
  mixin(uuid("73156525-c0e7-39ef-8c35-1e7c522cb07f"));
  mixin Interfaces!(_ScrollableControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ContextMenuStrip {
  mixin(uuid("d84f5ebd-f1f2-3849-98d7-6fdba13ac6ab"));
  mixin Interfaces!(_ContextMenuStrip, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStripDropDownMenu {
  mixin(uuid("5458c631-6a29-344d-b571-de58784bd9e0"));
  mixin Interfaces!(_ToolStripDropDownMenu, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DataGrid {
  mixin(uuid("1733cd63-db91-3506-b433-4dd3700b596f"));
  mixin Interfaces!(_DataGrid, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DataGridTextBox {
  mixin(uuid("0b420f33-d20b-329d-a609-5783b3e79722"));
  mixin Interfaces!(_DataGridTextBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TextBox {
  mixin(uuid("63c8a502-7863-3f66-998d-79bd0219d2e0"));
  mixin Interfaces!(_TextBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DataGridView {
  mixin(uuid("e21338e1-4794-3125-9211-92a7510202e8"));
  mixin Interfaces!(_DataGridView, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class Panel {
  mixin(uuid("165c9f64-ccb8-3c9b-8aaf-95352f86b99b"));
  mixin Interfaces!(_Panel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DataGridViewComboBoxEditingControl {
  mixin(uuid("82596187-3fa3-3cff-a0cd-151c3598597c"));
  mixin Interfaces!(_DataGridViewComboBoxEditingControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DataGridViewTextBoxEditingControl {
  mixin(uuid("7065c038-ba07-337a-bfed-de2179346428"));
  mixin Interfaces!(_DataGridViewTextBoxEditingControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DateTimePicker {
  mixin(uuid("4d09932a-cc59-3db0-9826-d515941d2d92"));
  mixin Interfaces!(_DateTimePicker, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class DomainUpDown {
  mixin(uuid("d1c50548-6109-3199-9042-ffaf6834aa01"));
  mixin Interfaces!(_DomainUpDown, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class FlowLayoutPanel {
  mixin(uuid("ba92792e-f10d-3efc-a100-52757a4c184c"));
  mixin Interfaces!(_FlowLayoutPanel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class MenuStrip {
  mixin(uuid("c930c2f7-cfda-3940-916c-51bec9c4d316"));
  mixin Interfaces!(_MenuStrip, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class GroupBox {
  mixin(uuid("c5cd51c2-ee05-358a-9b53-07f9060e435f"));
  mixin Interfaces!(_GroupBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class HScrollBar {
  mixin(uuid("f835d22e-51eb-3a49-93a3-34558be9c825"));
  mixin Interfaces!(_HScrollBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class Label {
  mixin(uuid("93d7475b-94a4-3c10-92e6-fd64bbe5745f"));
  mixin Interfaces!(_Label, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class LinkLabel {
  mixin(uuid("c116ee15-015e-3760-92f9-59c2d99236f1"));
  mixin Interfaces!(_LinkLabel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class MaskedTextBox {
  mixin(uuid("9c5e8cfb-cac0-3167-acee-bfdd8b5d2238"));
  mixin Interfaces!(_MaskedTextBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class MdiClient {
  mixin(uuid("ce6e4b0c-1473-3184-b1e3-0027d76e3618"));
  mixin Interfaces!(_MdiClient, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class MonthCalendar {
  mixin(uuid("b6782e31-494f-32eb-8405-6f24ac68bdbd"));
  mixin Interfaces!(_MonthCalendar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class NumericUpDown {
  mixin(uuid("e2035bfe-7a03-3af5-b1fc-4a1f34bfd448"));
  mixin Interfaces!(_NumericUpDown, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class PictureBox {
  mixin(uuid("492b7bba-a930-38ff-b51a-32b81068fa89"));
  mixin Interfaces!(_PictureBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class PrintPreviewControl {
  mixin(uuid("c064eae9-d1dd-32ac-bbfd-8882189841f3"));
  mixin Interfaces!(_PrintPreviewControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class PrintPreviewDialog {
  mixin(uuid("17438d08-1ca5-3c2d-b1e0-bf241ca83e5a"));
  mixin Interfaces!(_PrintPreviewDialog, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ProgressBar {
  mixin(uuid("409f95bb-e848-3a04-8b5a-8f13148651a9"));
  mixin Interfaces!(_ProgressBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class PropertyGrid {
  mixin(uuid("dc0ed10f-fea5-3a43-8ca1-19e036df370f"));
  mixin Interfaces!(_PropertyGrid, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class QueryAccessibilityHelpEventArgs {
  mixin(uuid("25af3ecd-8f91-3cce-9e6f-03d7348d8cba"));
  mixin Interfaces!(_QueryAccessibilityHelpEventArgs, _Object);
}

abstract final class RadioButton {
  mixin(uuid("fc511c4d-49a7-32ab-ab23-0ac220a9cdb7"));
  mixin Interfaces!(_RadioButton, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class RichTextBox {
  mixin(uuid("5fba0ddc-0b9f-3e4f-b99d-b3f297e9820d"));
  mixin Interfaces!(_RichTextBox, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class SplitContainer {
  mixin(uuid("f3f633a7-ca31-3cfc-a958-d8f04b946665"));
  mixin Interfaces!(_SplitContainer, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class Splitter {
  mixin(uuid("4bdf38bf-91e6-33d0-ac66-bf7682617615"));
  mixin Interfaces!(_Splitter, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class StatusBar {
  mixin(uuid("632d5c3d-6594-33e9-b361-9bcf6946b45a"));
  mixin Interfaces!(_StatusBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class StatusStrip {
  mixin(uuid("e6f7736e-221c-377d-8080-eba946d3bfe4"));
  mixin Interfaces!(_StatusStrip, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TabControl {
  mixin(uuid("3863b485-0904-3d25-89d0-190ad0321d29"));
  mixin Interfaces!(_TabControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TabPage {
  mixin(uuid("bbd78147-59d7-34a8-9bd3-62e28e957f28"));
  mixin Interfaces!(_TabPage, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TableLayoutPanel {
  mixin(uuid("abba8e63-b2d0-346c-80ed-9e0c215069cb"));
  mixin Interfaces!(_TableLayoutPanel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolBar {
  mixin(uuid("4e885c2a-c86f-3641-8d7b-9b3501449f45"));
  mixin Interfaces!(_ToolBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStripContainer {
  mixin(uuid("c0ff87fd-7051-300e-acc9-8f1a43fc2969"));
  mixin Interfaces!(_ToolStripContainer, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStripPanel {
  mixin(uuid("935030c0-f6ce-367e-ba86-cbf721d0e3b6"));
  mixin Interfaces!(_ToolStripPanel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStripContentPanel {
  mixin(uuid("d34f0b81-5af3-34b1-8cb8-e2166d5733f9"));
  mixin Interfaces!(_ToolStripContentPanel, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class ToolStripDropDown {
  mixin(uuid("e7fac3be-6aa2-37d6-894f-472d8f064fab"));
  mixin Interfaces!(_ToolStripDropDown, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TrackBar {
  mixin(uuid("606c2474-80a5-3e09-b952-724f97b00c01"));
  mixin Interfaces!(_TrackBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class TreeView {
  mixin(uuid("6fab6f50-dffe-35b5-9a5f-210db36909b7"));
  mixin Interfaces!(_TreeView, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class UserControl {
  mixin(uuid("07427f79-1fc2-3632-b5f4-02b51ba44e18"));
  mixin Interfaces!(_UserControl, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class VScrollBar {
  mixin(uuid("cb040ab2-71cb-3546-9881-53ca472ceb3b"));
  mixin Interfaces!(_VScrollBar, _Object, IComponent, IDisposable, IWin32Window);
}

abstract final class WebBrowser {
  mixin(uuid("322bc601-b652-3088-a0c8-47a7a02e78f4"));
  mixin Interfaces!(_WebBrowser, _Object, IComponent, IDisposable, IWin32Window);
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
