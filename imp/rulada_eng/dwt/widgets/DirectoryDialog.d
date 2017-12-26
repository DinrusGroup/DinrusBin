/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwt.widgets.DirectoryDialog;

import dwt.widgets.Display;
import dwt.widgets.Dialog;
import dwt.widgets.Shell;

import dwt.DWT;
import dwt.DWTException;
import dwt.internal.win32.OS;
import dwt.internal.C;

import dwt.dwthelper.utils;
static import tango.text.Text;

/**
 * Instances of this class allow the user to navigate
 * the file system and select a directory.
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>(none)</dd>
 * <dt><b>Events:</b></dt>
 * <dd>(none)</dd>
 * </dl>
 * <p>
 * IMPORTANT: This class is intended to be subclassed <em>only</em>
 * within the DWT implementation.
 * </p>
 * 
 * @see <a href="http://www.eclipse.org/swt/snippets/#directorydialog">DirectoryDialog snippets</a>
 * @see <a href="http://www.eclipse.org/swt/examples.php">DWT Example: ControlExample, Dialog tab</a>
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 */

public class DirectoryDialog : Dialog {
    static String message = "";
    static String filterPath = "";  //$NON-NLS-1$//$NON-NLS-2$
    static String directoryPath;

/**
 * Constructs a new instance of this class given only its parent.
 *
 * @param parent a shell which will be the parent of the new instance
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the parent is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the parent</li>
 *    <li>ERROR_INVALID_SUBCLASS - if this class is not an allowed subclass</li>
 * </ul>
 */
public this (Shell parent) {
    this (parent, DWT.APPLICATION_MODAL);
}

/**
 * Constructs a new instance of this class given its parent
 * and a style value describing its behavior and appearance.
 * <p>
 * The style value is either one of the style constants defined in
 * class <code>DWT</code> which is applicable to instances of this
 * class, or must be built by <em>bitwise OR</em>'ing together
 * (that is, using the <code>int</code> "|" operator) two or more
 * of those <code>DWT</code> style constants. The class description
 * lists the style constants that are applicable to the class.
 * Style bits are also inherited from superclasses.
 * </p>
 *
 * @param parent a shell which will be the parent of the new instance
 * @param style the style of dialog to construct
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the parent is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the parent</li>
 *    <li>ERROR_INVALID_SUBCLASS - if this class is not an allowed subclass</li>
 * </ul>
 */
public this (Shell parent, int style) {
    super (parent, checkStyle (parent, style));
    checkSubclass ();
}

extern(Windows)static int BrowseCallbackProc (HWND hwnd, uint uMsg, int lParam, int lpData) {
    DirectoryDialog pThis = cast(DirectoryDialog)cast(void*)lpData;
    switch (uMsg) {
        case OS.BFFM_INITIALIZED:
            if (pThis.filterPath !is null && pThis.filterPath.length !is 0) {
                /* Use the character encoding for the default locale */
                TCHAR[] buffer = StrToTCHARs (0, pThis.filterPath.replace ('/', '\\'), true);
                OS.SendMessage (hwnd, OS.BFFM_SETSELECTION, 1, buffer.ptr);
            }
            if (pThis.title !is null && pThis.title.length !is 0) {
                /* Use the character encoding for the default locale */
                TCHAR[] buffer = StrToTCHARs (0, pThis.title, true);
                OS.SetWindowText (hwnd, buffer.ptr);
            }
            break;
        case OS.BFFM_VALIDATEFAILEDA:
        case OS.BFFM_VALIDATEFAILEDW:
            /* Use the character encoding for the default locale */
//            int length = OS.IsUnicode ? OS.wcslen (lParam) : OS.strlen (lParam);
//            TCHAR buffer = new TCHAR (0, length);
//            int byteCount = buffer.length * TCHAR.sizeof;
//            OS.MoveMemory (buffer, lParam, byteCount);
//            directoryPath = buffer.toString (0, length);
            pThis.directoryPath = TCHARzToStr( cast(TCHAR*)lParam );
            break;
        default:
    }
    return 0;
}

/**
 * Returns the path which the dialog will use to filter
 * the directories it shows.
 *
 * @return the filter path
 *
 * @see #setFilterPath
 */
public String getFilterPath () {
    return filterPath;
}

/**
 * Returns the dialog's message, which is a description of
 * the purpose for which it was opened. This message will be
 * visible on the dialog while it is open.
 *
 * @return the message
 */
public String getMessage () {
    return message;
}

/**
 * Makes the dialog visible and brings it to the front
 * of the display.
 *
 * @return a string describing the absolute path of the selected directory,
 *         or null if the dialog was cancelled or an error occurred
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the dialog has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the dialog</li>
 * </ul>
 */
public String open () {
    if (OS.IsWinCE) DWT.error (DWT.ERROR_NOT_IMPLEMENTED);

    auto hHeap = OS.GetProcessHeap ();

    /* Get the owner HWND for the dialog */
    HWND hwndOwner;
    if (parent !is null) hwndOwner = parent.handle;

    /* Copy the message to OS memory */
    TCHAR* lpszTitle;
    if (message.length !is 0) {
        String string = message;
        if (string.indexOf ('&') !is -1) {
            int length = string.length;
            char [] buffer = new char [length * 2];
            int index = 0;
            for (int i=0; i<length; i++) {
                char ch = string.charAt (i);
                if (ch is '&') buffer [index++] = '&';
                buffer [index++] = ch;
            }
//            string = new String (buffer, 0, index);
        }
        /* Use the character encoding for the default locale */
        TCHAR[] buffer = StrToTCHARs (0, string, true);
        int byteCount = buffer.length * TCHAR.sizeof;
        lpszTitle = cast(TCHAR*)OS.HeapAlloc (hHeap, OS.HEAP_ZERO_MEMORY, byteCount);
        OS.MoveMemory (lpszTitle, buffer.ptr, byteCount);
    }

    /* Create the BrowseCallbackProc */
/+    Callback callback = new Callback (this, "BrowseCallbackProc", 4); //$NON-NLS-1$
    int lpfn = callback.getAddress ();+/
    BFFCALLBACK lpfn = &BrowseCallbackProc;
    if (lpfn is null) DWT.error (DWT.ERROR_NO_MORE_CALLBACKS);

    /* Make the parent shell be temporary modal */
    Dialog oldModal = null;
    Display display = parent.getDisplay ();
    if ((style & (DWT.APPLICATION_MODAL | DWT.SYSTEM_MODAL)) !is 0) {
        oldModal = display.getModalDialog ();
        display.setModalDialog (this);
    }

    directoryPath = null;
    BROWSEINFO lpbi;
    lpbi.hwndOwner = hwndOwner;
    lpbi.lpszTitle = lpszTitle;
    lpbi.ulFlags = OS.BIF_NEWDIALOGSTYLE | OS.BIF_RETURNONLYFSDIRS | OS.BIF_EDITBOX | OS.BIF_VALIDATE;
    lpbi.lpfn = lpfn;
    lpbi.lParam = cast(int)cast(void*)this;
    /*
    * Bug in Windows.  On some hardware configurations, SHBrowseForFolder()
    * causes warning dialogs with the message "There is no disk in the drive
    * Please insert a disk into \Device\Harddisk0\DR0".  This is possibly
    * caused by SHBrowseForFolder() calling internally GetVolumeInformation().
    * MSDN for GetVolumeInformation() says:
    *
    * "If you are attempting to obtain information about a floppy drive
    * that does not have a floppy disk or a CD-ROM drive that does not
    * have a compact disc, the system displays a message box asking the
    * user to insert a floppy disk or a compact disc, respectively.
    * To prevent the system from displaying this message box, call the
    * SetErrorMode function with SEM_FAILCRITICALERRORS."
    *
    * The fix is to save and restore the error mode using SetErrorMode()
    * with the SEM_FAILCRITICALERRORS flag around SHBrowseForFolder().
    */
    int oldErrorMode = OS.SetErrorMode (OS.SEM_FAILCRITICALERRORS);

    /*
    * Bug in Windows.  When a WH_MSGFILTER hook is used to run code
    * during the message loop for SHBrowseForFolder(), running code
    * in the hook can cause a GP.  Specifically, SetWindowText()
    * for static controls seemed to make the problem happen.
    * The fix is to disable async messages while the directory
    * dialog is open.
    *
    * NOTE:  This only happens in versions of the comctl32.dll
    * earlier than 6.0.
    */
    bool oldRunMessages = display.runMessages;
    if (OS.COMCTL32_MAJOR < 6) display.runMessages = false;
    ITEMIDLIST* lpItemIdList = OS.SHBrowseForFolder (&lpbi);
    if (OS.COMCTL32_MAJOR < 6) display.runMessages = oldRunMessages;
    OS.SetErrorMode (oldErrorMode);

    /* Clear the temporary dialog modal parent */
    if ((style & (DWT.APPLICATION_MODAL | DWT.SYSTEM_MODAL)) !is 0) {
        display.setModalDialog (oldModal);
    }

    bool success = lpItemIdList !is null;
    if (success) {
        /* Use the character encoding for the default locale */
        TCHAR[OS.MAX_PATH] buffer;
        if (OS.SHGetPathFromIDList (lpItemIdList, buffer.ptr)) {
            directoryPath = TCHARzToStr (buffer.ptr);
            filterPath = directoryPath;
        }
    }

    /* Free the BrowseCallbackProc */
//    callback.dispose ();

    /* Free the OS memory */
    if (lpszTitle !is null) OS.HeapFree (hHeap, 0, lpszTitle);

    /* Free the pointer to the ITEMIDLIST */
    LPVOID ppMalloc;
    if (OS.SHGetMalloc (&ppMalloc) is OS.S_OK) {
        /* void Free (struct IMalloc *this, void *pv); */
        OS.VtblCall (5, ppMalloc , cast(int)lpItemIdList);
    }

    /*
    * This code is intentionally commented.  On some
    * platforms, the owner window is repainted right
    * away when a dialog window exits.  This behavior
    * is currently unspecified.
    */
//  if (hwndOwner !is 0) OS.UpdateWindow (hwndOwner);

    /* Return the directory path */
    if (!success) return null;
    return directoryPath;
}

/**
 * Sets the path that the dialog will use to filter
 * the directories it shows to the argument, which may
 * be null. If the string is null, then the operating
 * system's default filter path will be used.
 * <p>
 * Note that the path string is platform dependent.
 * For convenience, either '/' or '\' can be used
 * as a path separator.
 * </p>
 *
 * @param string the filter path
 */
public void setFilterPath (String string) {
    filterPath = string;
}

/**
 * Sets the dialog's message, which is a description of
 * the purpose for which it was opened. This message will be
 * visible on the dialog while it is open.
 *
 * @param string the message
 *
 */
public void setMessage (String string) {
    // DWT extension: allow null string
    //if (string is null) error (DWT.ERROR_NULL_ARGUMENT);
    message = string;
}

}
