// Microsoft Data Bound List Controls 6.0
// Version 1.1

/*[uuid("faeee763-117e-101b-8933-08002b2f4f5a")]*/
module os.win.tlb.msdbctls;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Enums

// Constants for the OLEDragMode property (but not the DragMode or OLEDropMode properties).
enum OLEDragConstants {
  dblOLEDragManual = 0x00000000,
  dblOLEDragAutomatic = 0x00000001,
}

// Constants for the OLEDropMode property (but not the DragMode or OLEDragMode properties).
enum OLEDropConstants {
  dblOLEDropNone = 0x00000000,
  dblOLEDropManual = 0x00000001,
}

// State transition constants for the DragOver and OLEDragOver events.
enum DragOverConstants {
  dblEnter = 0x00000000,
  dblLeave = 0x00000001,
  dblOver = 0x00000002,
}

// Clipboard format constants.
enum ClipBoardConstants {
  dblCFText = 0x00000001,
  dblCFBitmap = 0x00000002,
  dblCFMetafile = 0x00000003,
  dblCFDIB = 0x00000008,
  dblCFPalette = 0x00000009,
  dblCFEMetafile = 0x0000000E,
  dblCFFiles = 0x0000000F,
  dblCFRTF = 0xFFFFBF01,
}

// Drop effect constants for OLE drag and drop events.
enum OLEDropEffectConstants {
  dblOLEDropEffectNone = 0x00000000,
  dblOLEDropEffectCopy = 0x00000001,
  dblOLEDropEffectMove = 0x00000002,
  dblOLEDropEffectScroll = 0x80000000,
}

// Appearance Constants
enum AppearanceConstants {
  dblFlat = 0x00000000,
  dbl3D = 0x00000001,
}

// Area Constants (for the control's Click and DblClick Events)
enum AreaConstants {
  dbcAreaButton = 0x00000000,
  dbcAreaEdit = 0x00000001,
  dbcAreaList = 0x00000002,
}

// Run-time error constants
enum ErrorConstants {
  dblOutOfMemory = 0x00000007,
  dblGetNotSupported = 0x0000018A,
  dblSetNotPermitted = 0x00000183,
  dblInvalidPropertyValue = 0x0000017C,
  dblDataObjectLocked = 0x000002A0,
  dblExpectedAnArgument = 0x000002A1,
  dblInvalidProcedureCall = 0x00000005,
  dblInvalidObjectUse = 0x000001A9,
  dblWrongClipboardFormat = 0x000001CD,
  dblRecursiveOleDrag = 0x000002A2,
  dblFormatNotByteArray = 0x000002A3,
  dblDataNotSetForFormat = 0x000002A4,
}

// MousePointer Constants
enum MousePointerConstants {
  dblDefault = 0x00000000,
  dblArrow = 0x00000001,
  dblCross = 0x00000002,
  dblIBeam = 0x00000003,
  dblIcon = 0x00000004,
  dblSize = 0x00000005,
  dblSizeNESW = 0x00000006,
  dblSizeNS = 0x00000007,
  dblSizeNWSE = 0x00000008,
  dblSizeEW = 0x00000009,
  dblUpArrow = 0x0000000A,
  dblHourglass = 0x0000000B,
  dblNoDrop = 0x0000000C,
  dblArrowHourglass = 0x0000000D,
  dblArrowQuestion = 0x0000000E,
  dblSizeAll = 0x0000000F,
  dblCustom = 0x00000063,
}

// MatchEntry Constants
enum MatchEntryConstants {
  dblBasicMatching = 0x00000000,
  dblExtendedMatching = 0x00000001,
}

// Style Constants
enum StyleConstants {
  dbcDropdownCombo = 0x00000000,
  dbcSimpleCombo = 0x00000001,
  dbcDropdownList = 0x00000002,
}

// Interfaces

interface IVBDataObject : IDispatch {
  mixin(uuid("2334d2b1-713e-11cf-8ae5-00aa00c00905"));
  // Clears all data and formats in a DataObject object.
  /*[id(0x00000001)]*/ int Clear();
  // Retrieves data of a specified format from a DataObject object.
  /*[id(0x00000002)]*/ int GetData(short sFormat, out VARIANT pvData);
  // Determines if a specified clipboard format is supported by the DataObject object.
  /*[id(0x00000003)]*/ int GetFormat(short sFormat, out short pbFormatSupported);
  // Adds a supported format and possibly its data to a DataObject object.
  /*[id(0x00000004)]*/ int SetData(VARIANT vValue, VARIANT vFormat);
  // A collection of filenames used by the vbCFFiles format.
  /*[id(0x00000005)]*/ int get_Files(out IVBDataObjectFiles pFiles);
}

interface IVBDataObjectFiles : IDispatch {
  mixin(uuid("2334d2b3-713e-11cf-8ae5-00aa00c00905"));
  // Returns a specific filename by index from the Files collection of a DataObject object (vbCFFiles format only).
  /*[id(0x00000000)]*/ int get_Item(int lIndex, out wchar* bstrItem);
  // Returns the number of filenames in the Files collection of a DataObject object (vbCFFiles format only).
  /*[id(0x00000001)]*/ int get_Count(out int plCount);
  // Adds a filename to the Files collection of a DataObject object (vbCFFiles format only).
  /*[id(0x00000002)]*/ int Add(wchar* bstrFilename, VARIANT vIndex);
  // Clears all filenames stored in the Files collection of a DataObject object (vbCFFiles format only).
  /*[id(0x00000003)]*/ int Clear();
  // Removes a filename from the Files collection of a DataObject object (vbCFFiles format only).
  /*[id(0x00000004)]*/ int Remove(VARIANT vIndex);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown ppUnk);
}

interface IRowCursor : IDispatch {
  mixin(uuid("9f6aa700-d188-11cd-ad48-00aa003c9cb6"));
}

// Fills a list box with a field from one Data control and can pass the field to a second Data control.
interface IDBList : IDispatch {
  mixin(uuid("09194000-df6e-11cf-8e74-00a0c90f26f8"));
  /*[id(0x00000000)]*/ int get_defText(out wchar* pbstrText);
  /*[id(0x00000000)]*/ int put_defText(wchar* pbstrText);
  // Returns/sets a value indicating whether any data in the object can be modified.
  /*[id(0x00000001)]*/ int get_Locked(out short pfLocked);
  // Returns/sets a value indicating whether any data in the object can be modified.
  /*[id(0x00000001)]*/ int put_Locked(short pfLocked);
  // Returns/sets the name of the source field in a Recordset object used to supply a value to another Recordset or the name of the field used to fill a control.
  /*[id(0x00000002)]*/ int get_BoundText(out wchar* pbstrBoundText);
  // Returns/sets the name of the source field in a Recordset object used to supply a value to another Recordset or the name of the field used to fill a control.
  /*[id(0x00000002)]*/ int put_BoundText(wchar* pbstrBoundText);
  // Sets a value that specifies the Data control from which a control's list is filled.
  /*[id(0x00000003)]*/ int get_RowSource(out IRowCursor ppRowSource);
  // Sets a value that specifies the Data control from which a control's list is filled.
  /*[id(0x00000003)]*/ int put_RowSource(IRowCursor ppRowSource);
  // Returns/sets the name of the source field in a Recordset object used to supply a data value to another control.
  /*[id(0x00000004)]*/ int get_BoundColumn(out wchar* pbstrBoundColumn);
  // Returns/sets the name of the source field in a Recordset object used to supply a data value to another control.
  /*[id(0x00000004)]*/ int put_BoundColumn(wchar* pbstrBoundColumn);
  // Returns/sets the type of mouse pointer displayed when over part of an object.
  /*[id(0x00000005)]*/ int get_MousePointer(out MousePointerConstants psMousePointer);
  // Returns/sets the type of mouse pointer displayed when over part of an object.
  /*[id(0x00000005)]*/ int put_MousePointer(MousePointerConstants psMousePointer);
  // Sets a custom mouse icon.
  /*[id(0x00000006)]*/ int get_MouseIcon(out IPictureDisp ppMouseIconDisp);
  // Sets a custom mouse icon.
  /*[id(0x00000006)]*/ int put_MouseIcon(IPictureDisp* ppMouseIconDisp);
  // Sets a custom mouse icon.
  /*[id(0x00000006)]*/ int putref_MouseIcon(IPictureDisp* ppMouseIconDisp);
  // Returns/sets a value that indicates whether a control displays partial items.
  /*[id(0x00000007)]*/ int get_IntegralHeight(out short pfIntegral);
  // Returns/sets a value that indicates whether a control displays partial items.
  /*[id(0x00000007)]*/ int put_IntegralHeight(short pfIntegral);
  // Returns/sets a value indicating how a control performs searches based on user input.
  /*[id(0x00000008)]*/ int get_MatchEntry(out MatchEntryConstants pmec);
  // Returns/sets a value indicating how a control performs searches based on user input.
  /*[id(0x00000008)]*/ int put_MatchEntry(MatchEntryConstants pmec);
  // Returns a value containing a bookmark for the selected record in a control.
  /*[id(0x00000009)]*/ int get_SelectedItem(out VARIANT pvarSelectedItem);
  // Returns a value indicating the number of visible items in a control.
  /*[id(0x0000000A)]*/ int get_VisibleCount(out short psCount);
  // Returns/sets the text contained in the control.
  /*[id(0x0000000B)]*/ int get_Text(out wchar* pbstrText);
  // Returns/sets the text contained in the control.
  /*[id(0x0000000B)]*/ int put_Text(wchar* pbstrText);
  // Returns/sets the name of the field in the Recordset object used to fill a control's list portion.
  /*[id(0x0000000C)]*/ int get_ListField(out wchar* pbstrListField);
  // Returns/sets the name of the field in the Recordset object used to fill a control's list portion.
  /*[id(0x0000000C)]*/ int put_ListField(wchar* pbstrListField);
  // Returns a Font object.
  /*[id(0xFFFFFE00)]*/ int get_Font(out IFontDisp ppFont);
  // Returns a Font object.
  /*[id(0xFFFFFE00)]*/ int putref_Font(IFontDisp* ppFont);
  // Returns/sets a value that determines whether a form or control can respond to user-generated events.
  /*[id(0xFFFFFDFE)]*/ int get_Enabled(out short pfEnable);
  // Returns/sets a value that determines whether a form or control can respond to user-generated events.
  /*[id(0xFFFFFDFE)]*/ int put_Enabled(short pfEnable);
  // Returns/sets the background color used to display text and graphics in an object.
  /*[id(0xFFFFFE0B)]*/ int get_BackColor(out OLE_COLOR pocBackColor);
  // Returns/sets the background color used to display text and graphics in an object.
  /*[id(0xFFFFFE0B)]*/ int put_BackColor(OLE_COLOR pocBackColor);
  // Returns/sets the foreground color used to display text and graphics in an object.
  /*[id(0xFFFFFDFF)]*/ int get_ForeColor(out OLE_COLOR pocForeColor);
  // Returns/sets the foreground color used to display text and graphics in an object.
  /*[id(0xFFFFFDFF)]*/ int put_ForeColor(OLE_COLOR pocForeColor);
  // Returns a value that determines if the contents of the BoundText property matches one of the records in the list portion of the control.
  /*[id(0x0000000F)]*/ int get_MatchedWithList(out short pfMatched);
  // Returns/sets whether or not the control is painted at run time with 3-D effects.
  /*[id(0x00000010)]*/ int get_Appearance(out AppearanceConstants penumAppearances);
  // Returns/sets whether or not the control is painted at run time with 3-D effects.
  /*[id(0x00000010)]*/ int put_Appearance(AppearanceConstants penumAppearances);
  // Determines text display direction and control visual appearance on a bidirectional system.
  /*[id(0xFFFFFD9D)]*/ int get_RightToLeft(out short pfRightToLeft);
  // Determines text display direction and control visual appearance on a bidirectional system.
  /*[id(0xFFFFFD9D)]*/ int put_RightToLeft(short pfRightToLeft);
  // Returns the window handle of a control.
  /*[id(0xFFFFFDFD)]*/ int get_Hwnd(out OLE_HANDLE phWnd);
  // Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.
  /*[id(0x0000060E)]*/ int get_OLEDragMode(out OLEDragConstants psOLEDragMode);
  // Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.
  /*[id(0x0000060E)]*/ int put_OLEDragMode(OLEDragConstants psOLEDragMode);
  // Returns/Sets whether this control can act as an OLE drop target.
  /*[id(0x0000060F)]*/ int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  // Returns/Sets whether this control can act as an OLE drop target.
  /*[id(0x0000060F)]*/ int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  // Repaints a control and calls restart to recreate the list.
  /*[id(0x0000000D)]*/ void ReFill();
  // Returns an array of bookmarks, one for each visible item in a control's list.
  /*[id(0x0000000E)]*/ int get_VisibleItems(short nIndex, out VARIANT pvarItem);
  // Forces a complete repaint of a form or control.
  /*[id(0xFFFFFDDA)]*/ void Refresh();
  /*[id(0xFFFFFDD8)]*/ void AboutBox();
  /*[id(0x00000064)]*/ int get_CacheUp(out short psSize);
  /*[id(0x00000064)]*/ int put_CacheUp(short psSize);
  /*[id(0x00000065)]*/ int get_CacheDown(out short psSize);
  /*[id(0x00000065)]*/ int put_CacheDown(short psSize);
  /*[id(0x00000066)]*/ int get_SmoothScroll(out short pfSmoothScroll);
  /*[id(0x00000066)]*/ int put_SmoothScroll(short pfSmoothScroll);
  // Starts an OLE drag/drop event with the given control as the source.
  /*[id(0x00000610)]*/ int OLEDrag();
}

// Event interface for DBList control
interface DDBListEvents : IDispatch {
  mixin(uuid("02a69b02-081b-101b-8933-08002b2f4f5a"));
  /+// Occurs when the user presses and then releases a mouse button over an object.
  /*[id(0xFFFFFDA8)]*/ void Click();+/
  /+// Occurs when the user presses a key while an object has the focus.
  /*[id(0xFFFFFDA6)]*/ void KeyDown(short* KeyCode, short Shift);+/
  /+// Occurs when you press and release a mouse button and then press and release it again over an object.
  /*[id(0xFFFFFDA7)]*/ void DblClick();+/
  /+// Occurs when the user presses and releases an ANSI key.
  /*[id(0xFFFFFDA5)]*/ void KeyPress(short* KeyAscii);+/
  /+// Occurs when the user releases a key while an object has the focus.
  /*[id(0xFFFFFDA4)]*/ void KeyUp(short* KeyCode, short Shift);+/
  /+// Occurs when the user presses the mouse button while an object has the focus.
  /*[id(0xFFFFFDA3)]*/ void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// Occurs when the user moves the mouse.
  /*[id(0xFFFFFDA2)]*/ void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// Occurs when the user releases the mouse button while an object has the focus.
  /*[id(0xFFFFFDA1)]*/ void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// OLEStartDrag event
  /*[id(0x0000060E)]*/ void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+// OLEGiveFeedback event
  /*[id(0x0000060F)]*/ void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+// OLESetData event
  /*[id(0x00000610)]*/ void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+// OLECompleteDrag event
  /*[id(0x00000611)]*/ void OLECompleteDrag(ref int Effect);+/
  /+// OLEDragOver event
  /*[id(0x00000612)]*/ void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+// OLEDragDrop event
  /*[id(0x00000613)]*/ void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

// Fills a list box with a field from a Data control and can pass this data to a second Data control. The field is copied to a text box, which can be edited.
interface IDBCombo : IDispatch {
  mixin(uuid("09194002-df6e-11cf-8e74-00a0c90f26f8"));
  /*[id(0x00000000)]*/ int get_defText(out wchar* pbstrText);
  /*[id(0x00000000)]*/ int put_defText(wchar* pbstrText);
  // Returns/sets the name of the field in the Recordset object used to fill a control's list portion.
  /*[id(0x00000001)]*/ int get_ListField(out wchar* pbstrListField);
  // Returns/sets the name of the field in the Recordset object used to fill a control's list portion.
  /*[id(0x00000001)]*/ int put_ListField(wchar* pbstrListField);
  // Returns/sets the name of the source field in a Recordset object used to supply a value to another Recordset or the name of the field used to fill a control.
  /*[id(0x00000002)]*/ int get_BoundText(out wchar* pbstrBoundText);
  // Returns/sets the name of the source field in a Recordset object used to supply a value to another Recordset or the name of the field used to fill a control.
  /*[id(0x00000002)]*/ int put_BoundText(wchar* pbstrBoundText);
  // Returns/sets the name of the source field in a Recordset object used to supply a data value to another control.
  /*[id(0x00000003)]*/ int get_BoundColumn(out wchar* pbstrBoundColumn);
  // Returns/sets the name of the source field in a Recordset object used to supply a data value to another control.
  /*[id(0x00000003)]*/ int put_BoundColumn(wchar* pbstrBoundColumn);
  // Returns/sets a value that determines the type of control and the behavior of its list box portion.
  /*[id(0x00000004)]*/ int get_Style(out StyleConstants psc);
  // Returns/sets a value that determines the type of control and the behavior of its list box portion.
  /*[id(0x00000004)]*/ int put_Style(StyleConstants psc);
  // Returns/sets the type of mouse pointer displayed when over part of an object.
  /*[id(0x00000005)]*/ int get_MousePointer(out MousePointerConstants psMousePointer);
  // Returns/sets the type of mouse pointer displayed when over part of an object.
  /*[id(0x00000005)]*/ int put_MousePointer(MousePointerConstants psMousePointer);
  // Returns/sets a value indicating whether any data in the object can be modified.
  /*[id(0x00000006)]*/ int get_Locked(out short pfLocked);
  // Returns/sets a value indicating whether any data in the object can be modified.
  /*[id(0x00000006)]*/ int put_Locked(short pfLocked);
  // Sets a custom mouse icon.
  /*[id(0x00000007)]*/ int get_MouseIcon(out IPictureDisp ppMouseIconDisp);
  // Sets a custom mouse icon.
  /*[id(0x00000007)]*/ int put_MouseIcon(IPictureDisp* ppMouseIconDisp);
  // Sets a custom mouse icon.
  /*[id(0x00000007)]*/ int putref_MouseIcon(IPictureDisp* ppMouseIconDisp);
  // Returns/sets a value that indicates whether a control displays partial items.
  /*[id(0x00000008)]*/ int get_IntegralHeight(out short pfIntegral);
  // Returns/sets a value that indicates whether a control displays partial items.
  /*[id(0x00000008)]*/ int put_IntegralHeight(short pfIntegral);
  // Returns/sets the starting point of text selected.
  /*[id(0x00000009)]*/ int get_SelStart(out int plSelStart);
  // Returns/sets the starting point of text selected.
  /*[id(0x00000009)]*/ int put_SelStart(int plSelStart);
  // Returns/sets the number of characters selected.
  /*[id(0x0000000A)]*/ int get_SelLength(out int plSelLength);
  // Returns/sets the number of characters selected.
  /*[id(0x0000000A)]*/ int put_SelLength(int plSelLength);
  // Returns/sets the string containing the currently selected text.
  /*[id(0x0000000B)]*/ int get_SelText(out wchar* pbstrSelText);
  // Returns/sets the string containing the currently selected text.
  /*[id(0x0000000B)]*/ int put_SelText(wchar* pbstrSelText);
  // Returns/sets a value indicating how a control performs searches based on user input.
  /*[id(0x0000000C)]*/ int get_MatchEntry(out MatchEntryConstants pmec);
  // Returns/sets a value indicating how a control performs searches based on user input.
  /*[id(0x0000000C)]*/ int put_MatchEntry(MatchEntryConstants pmec);
  // Returns a value containing a bookmark for the selected record in a control.
  /*[id(0x0000000D)]*/ int get_SelectedItem(out VARIANT pvarSelectedItem);
  // Returns a value indicating the number of visible items in a control.
  /*[id(0x0000000E)]*/ int get_VisibleCount(out short psCount);
  // Returns/sets the text contained in the control.
  /*[id(0x0000000F)]*/ int get_Text(out wchar* pbstrText);
  // Returns/sets the text contained in the control.
  /*[id(0x0000000F)]*/ int put_Text(wchar* pbstrText);
  // Sets a value that specifies the Data control from which a control's list is filled.
  /*[id(0x00000010)]*/ int get_RowSource(out IRowCursor ppRowSource);
  // Sets a value that specifies the Data control from which a control's list is filled.
  /*[id(0x00000010)]*/ int put_RowSource(IRowCursor ppRowSource);
  // Returns/sets the background color used to display text and graphics in an object.
  /*[id(0xFFFFFE0B)]*/ int get_BackColor(out OLE_COLOR pocBackColor);
  // Returns/sets the background color used to display text and graphics in an object.
  /*[id(0xFFFFFE0B)]*/ int put_BackColor(OLE_COLOR pocBackColor);
  // Returns/sets the foreground color used to display text and graphics in an object.
  /*[id(0xFFFFFDFF)]*/ int get_ForeColor(out OLE_COLOR pocForeColor);
  // Returns/sets the foreground color used to display text and graphics in an object.
  /*[id(0xFFFFFDFF)]*/ int put_ForeColor(OLE_COLOR pocForeColor);
  // Returns a Font object.
  /*[id(0xFFFFFE00)]*/ int get_Font(out IFontDisp ppFont);
  // Returns a Font object.
  /*[id(0xFFFFFE00)]*/ int putref_Font(IFontDisp* ppFont);
  // Returns/sets a value that determines whether a form or control can respond to user-generated events.
  /*[id(0xFFFFFDFE)]*/ int get_Enabled(out short pfEnable);
  // Returns/sets a value that determines whether a form or control can respond to user-generated events.
  /*[id(0xFFFFFDFE)]*/ int put_Enabled(short pfEnable);
  // Returns a value that determines if the contents of the BoundText property matches one of the records in the list portion of the control.
  /*[id(0x00000013)]*/ int get_MatchedWithList(out short pfMatched);
  // Returns/sets whether or not the control is painted at run time with 3-D effects.
  /*[id(0x00000014)]*/ int get_Appearance(out AppearanceConstants penumAppearances);
  // Returns/sets whether or not the control is painted at run time with 3-D effects.
  /*[id(0x00000014)]*/ int put_Appearance(AppearanceConstants penumAppearances);
  // Returns the window handle of a control.
  /*[id(0xFFFFFDFD)]*/ int get_Hwnd(out OLE_HANDLE phWnd);
  // Determines text display direction and control visual appearance on a bidirectional system.
  /*[id(0xFFFFFD9D)]*/ int get_RightToLeft(out short pfRightToLeft);
  // Determines text display direction and control visual appearance on a bidirectional system.
  /*[id(0xFFFFFD9D)]*/ int put_RightToLeft(short pfRightToLeft);
  // Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.
  /*[id(0x0000060E)]*/ int get_OLEDragMode(out OLEDragConstants psOLEDragMode);
  // Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.
  /*[id(0x0000060E)]*/ int put_OLEDragMode(OLEDragConstants psOLEDragMode);
  // Returns/Sets whether this control can act as an OLE drop target.
  /*[id(0x0000060F)]*/ int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  // Returns/Sets whether this control can act as an OLE drop target.
  /*[id(0x0000060F)]*/ int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  // Repaints a control and calls restart to recreate the list.
  /*[id(0x00000011)]*/ void ReFill();
  // Returns an array of bookmarks, one for each visible item in a control's list.
  /*[id(0x00000012)]*/ int get_VisibleItems(short nIndex, out VARIANT pvarItem);
  /*[id(0xFFFFFDD8)]*/ void AboutBox();
  // Forces a complete repaint of a form or control.
  /*[id(0xFFFFFDDA)]*/ void Refresh();
  /*[id(0x00000064)]*/ int get_CacheUp(out short psSize);
  /*[id(0x00000064)]*/ int put_CacheUp(short psSize);
  /*[id(0x00000065)]*/ int get_CacheDown(out short psSize);
  /*[id(0x00000065)]*/ int put_CacheDown(short psSize);
  /*[id(0x00000066)]*/ int get_SmoothScroll(out short pfSmoothScroll);
  /*[id(0x00000066)]*/ int put_SmoothScroll(short pfSmoothScroll);
  // Starts an OLE drag/drop event with the given control as the source.
  /*[id(0x00000610)]*/ int OLEDrag();
}

// Event interface for DBCombo control
interface DDBComboEvents : IDispatch {
  mixin(uuid("faeee762-117e-101b-8933-08002b2f4f5a"));
  /+// Occurs when the user presses and then releases a mouse button over an object.
  /*[id(0xFFFFFDA8)]*/ void Click(short Area);+/
  /+// Occurs when you press and release a mouse button and then press and release it again over an object.
  /*[id(0xFFFFFDA7)]*/ void DblClick(short Area);+/
  /+// Occurs when the user presses a key while an object has the focus.
  /*[id(0xFFFFFDA6)]*/ void KeyDown(short* KeyCode, short Shift);+/
  /+// Occurs when the user presses and releases an ANSI key.
  /*[id(0xFFFFFDA5)]*/ void KeyPress(short* KeyAscii);+/
  /+// Occurs when the user releases a key while an object has the focus.
  /*[id(0xFFFFFDA4)]*/ void KeyUp(short* KeyCode, short Shift);+/
  /+// Occurs when the user presses the mouse button while an object has the focus.
  /*[id(0xFFFFFDA3)]*/ void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// Occurs when the user moves the mouse.
  /*[id(0xFFFFFDA2)]*/ void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// Occurs when the user releases the mouse button while an object has the focus.
  /*[id(0xFFFFFDA1)]*/ void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+// Indicates that the contents of a control have changed.
  /*[id(0x00000001)]*/ void Change();+/
  /+// OLEStartDrag event
  /*[id(0x0000060E)]*/ void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+// OLEGiveFeedback event
  /*[id(0x0000060F)]*/ void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+// OLESetData event
  /*[id(0x00000610)]*/ void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+// OLECompleteDrag event
  /*[id(0x00000611)]*/ void OLECompleteDrag(ref int Effect);+/
  /+// OLEDragOver event
  /*[id(0x00000612)]*/ void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+// OLEDragDrop event
  /*[id(0x00000613)]*/ void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

// CoClasses

// Fills a list box with a field from one Data control and can pass the field to a second Data control.
abstract final class DBList {
  mixin(uuid("02a69b00-081b-101b-8933-08002b2f4f5a"));
  mixin Interfaces!(IDBList);
}

// Fills a list box with a field from a Data control and can pass this data to a second Data control. The field is copied to a text box, which can be edited.
abstract final class DBCombo {
  mixin(uuid("faeee760-117e-101b-8933-08002b2f4f5a"));
  mixin Interfaces!(IDBCombo);
}
