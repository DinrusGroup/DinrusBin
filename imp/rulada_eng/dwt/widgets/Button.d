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
module dwt.widgets.Button;

import dwt.DWT;
import dwt.DWTException;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.internal.ImageList;
import dwt.internal.win32.OS;

import dwt.widgets.Control;
import dwt.widgets.Composite;
import dwt.widgets.TypedListener;

import dwt.dwthelper.utils;

/**
 * Instances of this class represent a selectable user interface object that
 * issues notification when pressed and released.
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>ARROW, CHECK, PUSH, RADIO, TOGGLE, FLAT</dd>
 * <dd>UP, DOWN, LEFT, RIGHT, CENTER</dd>
 * <dt><b>Events:</b></dt>
 * <dd>Selection</dd>
 * </dl>
 * <p>
 * Note: Only one of the styles ARROW, CHECK, PUSH, RADIO, and TOGGLE
 * may be specified.
 * </p><p>
 * Note: Only one of the styles LEFT, RIGHT, and CENTER may be specified.
 * </p><p>
 * Note: Only one of the styles UP, DOWN, LEFT, and RIGHT may be specified
 * when the ARROW style is specified.
 * </p><p>
 * IMPORTANT: This class is intended to be subclassed <em>only</em>
 * within the DWT implementation.
 * </p>
 * 
 * @see <a href="http://www.eclipse.org/swt/snippets/#button">Button snippets</a>
 * @see <a href="http://www.eclipse.org/swt/examples.php">DWT Example: ControlExample</a>
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 */

public class Button : Control {

    alias Control.computeSize computeSize;
    alias Control.windowProc windowProc;

    alias extern(Windows) int function( HWND, uint, uint, int ) TWindowProc;
    String text = "", message = "";
    Image image, image2, disabledImage;
    ImageList imageList;
    bool ignoreMouse, grayed;
    static const int MARGIN = 4;
    private static /+const+/ int CHECK_WIDTH, CHECK_HEIGHT;
    static const int ICON_WIDTH = 128, ICON_HEIGHT = 128;
    static const bool COMMAND_LINK = false;
    private static /+const+/ TWindowProc ButtonProc;
    static const TCHAR[] ButtonClass = "BUTTON\0";

    private static bool static_this_completed = false;
    private static void static_this() {
        if( static_this_completed ){
            return;
        }
        synchronized {
            if( static_this_completed ){
                return;
            }
            auto hBitmap = OS.LoadBitmap (null, OS.OBM_CHECKBOXES);
            if (hBitmap is null) {
                CHECK_WIDTH = OS.GetSystemMetrics (OS.IsWinCE ? OS.SM_CXSMICON : OS.SM_CXVSCROLL);
                CHECK_HEIGHT = OS.GetSystemMetrics (OS.IsWinCE ? OS.SM_CYSMICON : OS.SM_CYVSCROLL);
            } else {
                BITMAP bitmap;
                OS.GetObject (hBitmap, BITMAP.sizeof, &bitmap);
                OS.DeleteObject (hBitmap);
                CHECK_WIDTH = bitmap.bmWidth / 4;
                CHECK_HEIGHT =  bitmap.bmHeight / 3;
            }
            WNDCLASS lpWndClass;
            OS.GetClassInfo (null, ButtonClass.ptr, &lpWndClass);
            ButtonProc = lpWndClass.lpfnWndProc;
            static_this_completed = true;
        }
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
 * @param parent a composite control which will be the parent of the new instance (cannot be null)
 * @param style the style of control to construct
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the parent is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the parent</li>
 *    <li>ERROR_INVALID_SUBCLASS - if this class is not an allowed subclass</li>
 * </ul>
 *
 * @see DWT#ARROW
 * @see DWT#CHECK
 * @see DWT#PUSH
 * @see DWT#RADIO
 * @see DWT#TOGGLE
 * @see DWT#FLAT
 * @see DWT#LEFT
 * @see DWT#RIGHT
 * @see DWT#CENTER
 * @see Widget#checkSubclass
 * @see Widget#getStyle
 */
public this (Composite parent, int style) {
    static_this();
    super (parent, checkStyle (style));
}

void _setImage (Image image) {
    if ((style & DWT.COMMAND) !is 0) return;
    if (OS.COMCTL32_MAJOR >= 6) {
        if (imageList !is null) imageList.dispose ();
        imageList = null;
        if (image !is null) {
            imageList = new ImageList (style & DWT.RIGHT_TO_LEFT);
            if (OS.IsWindowEnabled (handle)) {
                imageList.add (image);
            } else {
                if (disabledImage !is null) disabledImage.dispose ();
                disabledImage = new Image (display, image, DWT.IMAGE_DISABLE);
                imageList.add (disabledImage);
            }
            BUTTON_IMAGELIST buttonImageList;
            buttonImageList.himl = imageList.getHandle ();
            int oldBits = OS.GetWindowLong (handle, OS.GWL_STYLE), newBits = oldBits;
            newBits &= ~(OS.BS_LEFT | OS.BS_CENTER | OS.BS_RIGHT);
            if ((style & DWT.LEFT) !is 0) newBits |= OS.BS_LEFT;
            if ((style & DWT.CENTER) !is 0) newBits |= OS.BS_CENTER;
            if ((style & DWT.RIGHT) !is 0) newBits |= OS.BS_RIGHT;
            if (text.length is 0) {
                if ((style & DWT.LEFT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                if ((style & DWT.CENTER) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_CENTER;
                if ((style & DWT.RIGHT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_RIGHT;
            } else {
                buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                buttonImageList.margin.left = computeLeftMargin ();
                buttonImageList.margin.right = MARGIN;
                newBits &= ~(OS.BS_CENTER | OS.BS_RIGHT);
                newBits |= OS.BS_LEFT;
            }
            if (newBits !is oldBits) {
                OS.SetWindowLong (handle, OS.GWL_STYLE, newBits);
                OS.InvalidateRect (handle, null, true);
            }
            OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, &buttonImageList);
        } else {
            OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, 0);
        }
        /*
        * Bug in Windows.  Under certain cirumstances yet to be
        * isolated, BCM_SETIMAGELIST does not redraw the control
        * when a new image is set.  The fix is to force a redraw.
        */
        OS.InvalidateRect (handle, null, true);
    } else {
        if (image2 !is null) image2.dispose ();
        image2 = null;
        HBITMAP hImage;
        int imageBits = 0, fImageType = 0;
        if (image !is null) {
            switch (image.type) {
                case DWT.BITMAP: {
                    Rectangle rect = image.getBounds ();
                    ImageData data = image.getImageData ();
                    switch (data.getTransparencyType ()) {
                        case DWT.TRANSPARENCY_PIXEL:
                            if (rect.width <= ICON_WIDTH && rect.height <= ICON_HEIGHT) {
                                image2 = new Image (display, data, data.getTransparencyMask ());
                                hImage = image2.handle;
                                imageBits = OS.BS_ICON;
                                fImageType = OS.IMAGE_ICON;
                                break;
                            }
                            //FALL THROUGH
                        case DWT.TRANSPARENCY_ALPHA:
                            image2 = new Image (display, rect.width, rect.height);
                            GC gc = new GC (image2);
                            gc.setBackground (getBackground ());
                            gc.fillRectangle (rect);
                            gc.drawImage (image, 0, 0);
                            gc.dispose ();
                            hImage = image2.handle;
                            imageBits = OS.BS_BITMAP;
                            fImageType = OS.IMAGE_BITMAP;
                            break;
                        case DWT.TRANSPARENCY_NONE:
                            hImage = image.handle;
                            imageBits = OS.BS_BITMAP;
                            fImageType = OS.IMAGE_BITMAP;
                            break;
                        default:
                    }
                    break;
                }
                case DWT.ICON: {
                    hImage = image.handle;
                    imageBits = OS.BS_ICON;
                    fImageType = OS.IMAGE_ICON;
                    break;
                }
                default:
            }
            /*
            * Feature in Windows.  The button control mirrors its image when the
            * flag WS_EX_LAYOUTRTL is set. This behaviour is not desirable in DWT.
            * The fix is to set a mirrored version of real image in the button.
            */
            if ((style & DWT.RIGHT_TO_LEFT) !is 0) {
                if (!OS.IsWinCE && OS.WIN32_VERSION >= OS.VERSION (4, 10)) {
                    Rectangle rect = image.getBounds ();
                    auto hDC = OS.GetDC (handle);
                    auto dstHdc = OS.CreateCompatibleDC (hDC);
                    auto hBitmap = OS.CreateCompatibleBitmap (hDC, rect.width, rect.height);
                    auto oldBitmap = OS.SelectObject (dstHdc, hBitmap);
                    OS.SetLayout (dstHdc, OS.LAYOUT_RTL);
                    if (fImageType is OS.IMAGE_BITMAP) {
                        auto srcHdc = OS.CreateCompatibleDC (hDC);
                        auto oldSrcBitmap = OS.SelectObject (srcHdc, hImage);
                        OS.SetLayout (dstHdc, 0);
                        OS.BitBlt (dstHdc, 0, 0, rect.width, rect.height, srcHdc, 0, 0, OS.SRCCOPY);
                        OS.SelectObject (srcHdc, oldSrcBitmap);
                        OS.DeleteDC (srcHdc);
                    } else {
                        Control control = findBackgroundControl ();
                        if (control is null) control = this;
                        auto newBrush = OS.CreateSolidBrush (control.getBackgroundPixel ());
                        auto oldBrush = OS.SelectObject (dstHdc, newBrush);
                        OS.PatBlt (dstHdc, 0, 0, rect.width, rect.height, OS.PATCOPY);
                        OS.DrawIconEx (dstHdc, 0, 0, hImage, 0, 0, 0, null, OS.DI_NORMAL);
                        OS.SelectObject (dstHdc, oldBrush);
                        OS.DeleteObject (newBrush);
                    }
                    OS.SelectObject (dstHdc, oldBitmap);
                    OS.DeleteDC (dstHdc);
                    OS.ReleaseDC (handle, hDC);
                    if (image2 !is null) image2.dispose ();
                    image2 = Image.win32_new (display, DWT.BITMAP, hBitmap);
                    imageBits = OS.BS_BITMAP;
                    fImageType = OS.IMAGE_BITMAP;
                    hImage = hBitmap;
                }
            }
        }
        int newBits = OS.GetWindowLong (handle, OS.GWL_STYLE), oldBits = newBits;
        newBits &= ~(OS.BS_BITMAP | OS.BS_ICON);
        newBits |= imageBits;
        if (newBits !is oldBits) OS.SetWindowLong (handle, OS.GWL_STYLE, newBits);
        OS.SendMessage (handle, OS.BM_SETIMAGE, fImageType, hImage);
    }
}

void _setText (String text) {
    int oldBits = OS.GetWindowLong (handle, OS.GWL_STYLE), newBits = oldBits;
    if (OS.COMCTL32_MAJOR >= 6) {
        newBits &= ~(OS.BS_LEFT | OS.BS_CENTER | OS.BS_RIGHT);
        if ((style & DWT.LEFT) !is 0) newBits |= OS.BS_LEFT;
        if ((style & DWT.CENTER) !is 0) newBits |= OS.BS_CENTER;
        if ((style & DWT.RIGHT) !is 0) newBits |= OS.BS_RIGHT;
        if (imageList !is null) {
            BUTTON_IMAGELIST buttonImageList;
            buttonImageList.himl = imageList.getHandle ();
            if (text.length is 0) {
                if ((style & DWT.LEFT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                if ((style & DWT.CENTER) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_CENTER;
                if ((style & DWT.RIGHT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_RIGHT;
            } else {
                buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                buttonImageList.margin.left = computeLeftMargin ();
                buttonImageList.margin.right = MARGIN;
                newBits &= ~(OS.BS_CENTER | OS.BS_RIGHT);
                newBits |= OS.BS_LEFT;
            }
            OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, &buttonImageList);
        }
    } else {
        newBits &= ~(OS.BS_BITMAP | OS.BS_ICON);
    }
    if (newBits !is oldBits) {
        OS.SetWindowLong (handle, OS.GWL_STYLE, newBits);
        OS.InvalidateRect (handle, null, true);
    }
    /*
    * Bug in Windows.  When a Button control is right-to-left and
    * is disabled, the first pixel of the text is clipped.  The
    * fix is to add a space to both sides of the text.
    */
    if ((style & DWT.RIGHT_TO_LEFT) !is 0) {
        if (OS.COMCTL32_MAJOR < 6 || !OS.IsAppThemed ()) {
            text = OS.IsWindowEnabled (handle) ? text : " " ~ text ~ " ";
        }
    }
    TCHAR* buffer = StrToTCHARz ( text );
    OS.SetWindowText (handle, buffer);
}

/**
 * Adds the listener to the collection of listeners who will
 * be notified when the control is selected by the user, by sending
 * it one of the messages defined in the <code>SelectionListener</code>
 * interface.
 * <p>
 * <code>widgetSelected</code> is called when the control is selected by the user.
 * <code>widgetDefaultSelected</code> is not called.
 * </p>
 *
 * @param listener the listener which should be notified
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the listener is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see SelectionListener
 * @see #removeSelectionListener
 * @see SelectionEvent
 */
public void addSelectionListener (SelectionListener listener) {
    checkWidget ();
    if (listener is null) error (DWT.ERROR_NULL_ARGUMENT);
    TypedListener typedListener = new TypedListener (listener);
    addListener (DWT.Selection,typedListener);
    addListener (DWT.DefaultSelection,typedListener);
}

override int callWindowProc (HWND hwnd, int msg, int wParam, int lParam) {
    if (handle is null) return 0;
    return OS.CallWindowProc ( ButtonProc, hwnd, msg, wParam, lParam);
}

static int checkStyle (int style) {
    style = checkBits (style, DWT.PUSH, DWT.ARROW, DWT.CHECK, DWT.RADIO, DWT.TOGGLE, COMMAND_LINK ? DWT.COMMAND : 0);
    if ((style & (DWT.PUSH | DWT.TOGGLE)) !is 0) {
        return checkBits (style, DWT.CENTER, DWT.LEFT, DWT.RIGHT, 0, 0, 0);
    }
    if ((style & (DWT.CHECK | DWT.RADIO)) !is 0) {
        return checkBits (style, DWT.LEFT, DWT.RIGHT, DWT.CENTER, 0, 0, 0);
    }
    if ((style & DWT.ARROW) !is 0) {
        style |= DWT.NO_FOCUS;
        return checkBits (style, DWT.UP, DWT.DOWN, DWT.LEFT, DWT.RIGHT, 0, 0);
    }
    return style;
}

void click () {
    /*
    * Feature in Windows.  BM_CLICK sends a fake WM_LBUTTONDOWN and
    * WM_LBUTTONUP in order to click the button.  This causes the
    * application to get unexpected mouse events.  The fix is to
    * ignore mouse events when they are caused by BM_CLICK.
    */
    ignoreMouse = true;
    OS.SendMessage (handle, OS.BM_CLICK, 0, 0);
    ignoreMouse = false;
}

int computeLeftMargin () {
    if (OS.COMCTL32_MAJOR < 6) return MARGIN;
    if ((style & (DWT.PUSH | DWT.TOGGLE)) is 0) return MARGIN;
    int margin = 0;
    if (image !is null && text.length !is 0) {
        Rectangle bounds = image.getBounds ();
        margin += bounds.width + MARGIN * 2;
        HFONT oldFont;
        auto hDC = OS.GetDC (handle);
        HFONT newFont = cast(HFONT) OS.SendMessage (handle, OS.WM_GETFONT, 0, 0);
        if (newFont !is null) oldFont = OS.SelectObject (hDC, newFont);
        TCHAR* buffer = StrToTCHARz( getCodePage (), text);
        RECT rect;
        int flags = OS.DT_CALCRECT | OS.DT_SINGLELINE;
        OS.DrawText (hDC, buffer, -1, &rect, flags);
        margin += rect.right - rect.left;
        if (newFont !is null) OS.SelectObject (hDC, oldFont);
        OS.ReleaseDC (handle, hDC);
        OS.GetClientRect (handle, &rect);
        margin = Math.max (MARGIN, (rect.right - rect.left - margin) / 2);
    }
    return margin;
}

override public Point computeSize (int wHint, int hHint, bool changed) {
    checkWidget ();
    int width = 0, height = 0, border = getBorderWidth ();
    if ((style & DWT.ARROW) !is 0) {
        if ((style & (DWT.UP | DWT.DOWN)) !is 0) {
            width += OS.GetSystemMetrics (OS.SM_CXVSCROLL);
            height += OS.GetSystemMetrics (OS.SM_CYVSCROLL);
        } else {
            width += OS.GetSystemMetrics (OS.SM_CXHSCROLL);
            height += OS.GetSystemMetrics (OS.SM_CYHSCROLL);
        }
    } else {
        if ((style & DWT.COMMAND) !is 0) {
            SIZE size;
            if (wHint !is DWT.DEFAULT) {
                size.cx = wHint;
                OS.SendMessage (handle, OS.BCM_GETIDEALSIZE, 0, &size);
                width = size.cx;
                height = size.cy;
            } else {
                OS.SendMessage (handle, OS.BCM_GETIDEALSIZE, 0, &size);
                width = size.cy;
                height = size.cy;
                size.cy = 0;
                while (size.cy !is height) {
                    size.cx = width++;
                    size.cy = 0;
                    OS.SendMessage (handle, OS.BCM_GETIDEALSIZE, 0, &size);
                }
            }
        } else {
            int extra = 0;
            bool hasImage = image !is null, hasText = true;
            if (OS.COMCTL32_MAJOR < 6) {
                if ((style & DWT.PUSH) is 0) {
                    int bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
                    hasImage = (bits & (OS.BS_BITMAP | OS.BS_ICON)) !is 0;
                    if (hasImage) hasText = false;
                }
            }
            if (hasImage) {
                if (image !is null) {
                    Rectangle rect = image.getBounds ();
                    width = rect.width;
                    if (hasText && text.length !is 0) {
                        width += MARGIN * 2;
                    }
                    height = rect.height;
                    extra = MARGIN * 2;
                }
            }
            if (hasText) {
                HFONT oldFont;
                auto hDC = OS.GetDC (handle);
                auto newFont = cast(HFONT) OS.SendMessage (handle, OS.WM_GETFONT, 0, 0);
                if (newFont !is null) oldFont = OS.SelectObject (hDC, newFont);
                TEXTMETRIC lptm;
                OS.GetTextMetrics (hDC, &lptm);
                int length_ = text.length;
                if (length_ is 0) {
                    height = Math.max (height, lptm.tmHeight);
                } else {
                    extra = Math.max (MARGIN * 2, lptm.tmAveCharWidth);
                    TCHAR* buffer = StrToTCHARz( getCodePage (), text);
                    RECT rect;
                    int flags = OS.DT_CALCRECT | OS.DT_SINGLELINE;
                    OS.DrawText (hDC, buffer, -1, &rect, flags);
                    width += rect.right - rect.left;
                    height = Math.max (height, rect.bottom - rect.top);
                }
                if (newFont !is null) OS.SelectObject (hDC, oldFont);
                OS.ReleaseDC (handle, hDC);
            }
            if ((style & (DWT.CHECK | DWT.RADIO)) !is 0) {
                width += CHECK_WIDTH + extra;
                height = Math.max (height, CHECK_HEIGHT + 3);
            }
            if ((style & (DWT.PUSH | DWT.TOGGLE)) !is 0) {
                width += 12;  height += 10;
            }
        }
    }
    if (wHint !is DWT.DEFAULT) width = wHint;
    if (hHint !is DWT.DEFAULT) height = hHint;
    width += border * 2;
    height += border * 2;
    return new Point (width, height);
}

override void createHandle () {
    /*
    * Feature in Windows.  When a button is created,
    * it clears the UI state for all controls in the
    * shell by sending WM_CHANGEUISTATE with UIS_SET,
    * UISF_HIDEACCEL and UISF_HIDEFOCUS to the parent.
    * This is undocumented and unexpected.  The fix
    * is to ignore the WM_CHANGEUISTATE, when sent
    * from CreateWindowEx().
    */
    parent.state |= IGNORE_WM_CHANGEUISTATE;
    super.createHandle ();
    parent.state &= ~IGNORE_WM_CHANGEUISTATE;

    /* Set the theme background */
    if (OS.COMCTL32_MAJOR >= 6 && OS.IsAppThemed ()) {
        /*
        * NOTE: On Vista this causes problems when the tab
        * key is pressed for push buttons so disable the
        * theme background drawing for these widgets for
        * now.
        */
        if (!OS.IsWinCE && OS.WIN32_VERSION < OS.VERSION (6, 0)) {
            state |= THEME_BACKGROUND;
        } else {
            if ((style & (DWT.PUSH | DWT.TOGGLE)) is 0) {
                state |= THEME_BACKGROUND;
            }
        }
    }

    /*
    * Bug in Windows.  For some reason, the HBRUSH that
    * is returned from WM_CTRLCOLOR is misaligned when
    * the button uses it to draw.  If the brush is a solid
    * color, this does not matter.  However, if the brush
    * contains an image, the image is misaligned.  The
    * fix is to draw the background in WM_CTRLCOLOR.
    *
    * NOTE: For comctl32.dll 6.0 with themes disabled,
    * drawing in WM_ERASEBKGND will draw on top of the
    * text of the control.
    */
    if (OS.COMCTL32_MAJOR >= 6 && OS.IsAppThemed ()) {
        if ((style & DWT.RADIO) !is 0) state |= DRAW_BACKGROUND;
    }

    /*
    * Feature in Windows.  Push buttons draw border around
    * the button using the default background color instead
    * of using the color provided by WM_CTRLCOLOR.  The fix
    * is to draw the background in WM_CTRLCOLOR.
    *
    * NOTE: On Vista this causes problems when the tab key
    * is pressed for push buttons so disable the fix for now.
    */
    if (OS.COMCTL32_MAJOR >= 6 && OS.IsAppThemed ()) {
        if (!OS.IsWinCE && OS.WIN32_VERSION < OS.VERSION (6, 0)) {
            if ((style & (DWT.PUSH | DWT.TOGGLE)) !is 0) {
                state |= DRAW_BACKGROUND;
            }
        }
    }
}

override int defaultBackground () {
    if ((style & (DWT.PUSH | DWT.TOGGLE)) !is 0) {
        return OS.GetSysColor (OS.COLOR_BTNFACE);
    }
    return super.defaultBackground ();
}

override int defaultForeground () {
    return OS.GetSysColor (OS.COLOR_BTNTEXT);
}

override void enableWidget (bool enabled) {
    super.enableWidget (enabled);
    /*
    * Bug in Windows.  When a button control is right-to-left and
    * is disabled, the first pixel of the text is clipped.   The
    * fix is to add a space to both sides of the text.
    */
    if ((style & DWT.RIGHT_TO_LEFT) !is 0) {
        if (OS.COMCTL32_MAJOR < 6 || !OS.IsAppThemed ()) {
            int bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
            bool hasImage = (bits & (OS.BS_BITMAP | OS.BS_ICON)) !is 0;
            if (!hasImage) {
                String string = enabled ? text : " " ~ text ~ " ";
                TCHAR* buffer = StrToTCHARz (getCodePage (), string);
                OS.SetWindowText (handle, buffer);
            }
        }
    }
    /*
    * Bug in Windows.  When a button has the style BS_CHECKBOX
    * or BS_RADIOBUTTON, is checked, and is displaying both an
    * image and some text, when BCM_SETIMAGELIST is used to
    * assign an image list for each of the button states, the
    * button does not draw properly.  When the user drags the
    * mouse in and out of the button, it draws using a blank
    * image.  The fix is to set the complete image list only
    * when the button is disabled.
    */
    if (OS.COMCTL32_MAJOR >= 6) {
        if (imageList !is null) {
            BUTTON_IMAGELIST buttonImageList;
            OS.SendMessage (handle, OS.BCM_GETIMAGELIST, 0, &buttonImageList);
            if (imageList !is null) imageList.dispose ();
            imageList = new ImageList (style & DWT.RIGHT_TO_LEFT);
            if (OS.IsWindowEnabled (handle)) {
                imageList.add (image);
            } else {
                if (disabledImage !is null) disabledImage.dispose ();
                disabledImage = new Image (display, image, DWT.IMAGE_DISABLE);
                imageList.add (disabledImage);
            }
            buttonImageList.himl = imageList.getHandle ();
            OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, &buttonImageList);
            /*
            * Bug in Windows.  Under certain cirumstances yet to be
            * isolated, BCM_SETIMAGELIST does not redraw the control
            * when an image is set.  The fix is to force a redraw.
            */
            OS.InvalidateRect (handle, null, true);
        }
    }
}

/**
 * Returns a value which describes the position of the
 * text or image in the receiver. The value will be one of
 * <code>LEFT</code>, <code>RIGHT</code> or <code>CENTER</code>
 * unless the receiver is an <code>ARROW</code> button, in
 * which case, the alignment will indicate the direction of
 * the arrow (one of <code>LEFT</code>, <code>RIGHT</code>,
 * <code>UP</code> or <code>DOWN</code>).
 *
 * @return the alignment
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getAlignment () {
    checkWidget ();
    if ((style & DWT.ARROW) !is 0) {
        if ((style & DWT.UP) !is 0) return DWT.UP;
        if ((style & DWT.DOWN) !is 0) return DWT.DOWN;
        if ((style & DWT.LEFT) !is 0) return DWT.LEFT;
        if ((style & DWT.RIGHT) !is 0) return DWT.RIGHT;
        return DWT.UP;
    }
    if ((style & DWT.LEFT) !is 0) return DWT.LEFT;
    if ((style & DWT.CENTER) !is 0) return DWT.CENTER;
    if ((style & DWT.RIGHT) !is 0) return DWT.RIGHT;
    return DWT.LEFT;
}

bool getDefault () {
    if ((style & DWT.PUSH) is 0) return false;
    int bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
    return (bits & OS.BS_DEFPUSHBUTTON) !is 0;
}

/**
 * Returns <code>true</code> if the receiver is grayed,
 * and false otherwise. When the widget does not have
 * the <code>CHECK</code> style, return false.
 *
 * @return the grayed state of the checkbox
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 * 
 * @since 3.4
 */
public bool getGrayed () {
    checkWidget();
    if ((style & DWT.CHECK) is 0) return false;
    return grayed;
}

/**
 * Returns the receiver's image if it has one, or null
 * if it does not.
 *
 * @return the receiver's image
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public Image getImage () {
    checkWidget ();
    return image;
}

/**
 * Returns the widget message. When the widget is created
 * with the style <code>DWT.COMMAND</code>, the message text
 * is displayed to provide further information for the user.
 *
 * @return the widget message
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.3
 */
/*public*/ String getMessage () {
    checkWidget ();
    return message;
}

override String getNameText () {
    return getText ();
}

/**
 * Returns <code>true</code> if the receiver is selected,
 * and false otherwise.
 * <p>
 * When the receiver is of type <code>CHECK</code> or <code>RADIO</code>,
 * it is selected when it is checked. When it is of type <code>TOGGLE</code>,
 * it is selected when it is pushed in. If the receiver is of any other type,
 * this method returns false.
 *
 * @return the selection state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public bool getSelection () {
    checkWidget ();
    if ((style & (DWT.CHECK | DWT.RADIO | DWT.TOGGLE)) is 0) return false;
    int /*long*/ flags = OS.SendMessage (handle, OS.BM_GETCHECK, 0, 0);
    return flags !is OS.BST_UNCHECKED;
}

/**
 * Returns the receiver's text, which will be an empty
 * string if it has never been set or if the receiver is
 * an <code>ARROW</code> button.
 *
 * @return the receiver's text
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public String getText () {
    checkWidget ();
    if ((style & DWT.ARROW) !is 0) return "";
    return text;
}

override bool isTabItem () {
    if ((style & DWT.PUSH) !is 0) return isTabGroup ();
    return super.isTabItem ();
}

override bool mnemonicHit (wchar ch) {
    if (!setFocus ()) return false;
    /*
    * Feature in Windows.  When a radio button gets focus,
    * it selects the button in WM_SETFOCUS.  Therefore, it
    * is not necessary to click the button or send events
    * because this has already happened in WM_SETFOCUS.
    */
    if ((style & DWT.RADIO) is 0) click ();
    return true;
}

override bool mnemonicMatch (wchar key) {
    wchar mnemonic = findMnemonic (getText ());
    if (mnemonic is '\0') return false;
    return CharacterToUpper (key) is CharacterToUpper (mnemonic);
}

void printWidget (HWND hwnd, GC gc) {
    /*
    * Bug in Windows.  For some reason, PrintWindow() fails
    * when it is called on a push button.  The fix is to
    * detect the failure and use WM_PRINT instead.  Note
    * that WM_PRINT cannot be used all the time because it
    * fails for browser controls when the browser has focus.
    */
    auto hDC = gc.handle;
    if (!OS.PrintWindow (hwnd, hDC, 0)) {
        int flags = OS.PRF_CLIENT | OS.PRF_NONCLIENT | OS.PRF_ERASEBKGND | OS.PRF_CHILDREN;
        OS.SendMessage (hwnd, OS.WM_PRINT, hDC, flags);
    }
}

override void releaseWidget () {
    super.releaseWidget ();
    if (imageList !is null) imageList.dispose ();
    imageList = null;
    if (disabledImage !is null) disabledImage.dispose ();
    disabledImage = null;
    if (image2 !is null) image2.dispose ();
    image2 = null;
    text = null;
    image = null;
}

/**
 * Removes the listener from the collection of listeners who will
 * be notified when the control is selected by the user.
 *
 * @param listener the listener which should no longer be notified
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the listener is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see SelectionListener
 * @see #addSelectionListener
 */
public void removeSelectionListener (SelectionListener listener) {
    checkWidget ();
    if (listener is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (eventTable is null) return;
    eventTable.unhook (DWT.Selection, listener);
    eventTable.unhook (DWT.DefaultSelection,listener);
}

void selectRadio () {
    /*
    * This code is intentionally commented.  When two groups
    * of radio buttons with the same parent are separated by
    * another control, the correct behavior should be that
    * the two groups act independently.  This is consistent
    * with radio tool and menu items.  The commented code
    * implements this behavior.
    */
//  int index = 0;
//  Control [] children = parent._getChildren ();
//  while (index < children.length && children [index] !is this) index++;
//  int i = index - 1;
//  while (i >= 0 && children [i].setRadioSelection (false)) --i;
//  int j = index + 1;
//  while (j < children.length && children [j].setRadioSelection (false)) j++;
//  setSelection (true);
    Control [] children = parent._getChildren ();
    for (int i=0; i<children.length; i++) {
        Control child = children [i];
        if (this !is child) child.setRadioSelection (false);
    }
    setSelection (true);
}

/**
 * Controls how text, images and arrows will be displayed
 * in the receiver. The argument should be one of
 * <code>LEFT</code>, <code>RIGHT</code> or <code>CENTER</code>
 * unless the receiver is an <code>ARROW</code> button, in
 * which case, the argument indicates the direction of
 * the arrow (one of <code>LEFT</code>, <code>RIGHT</code>,
 * <code>UP</code> or <code>DOWN</code>).
 *
 * @param alignment the new alignment
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setAlignment (int alignment) {
    checkWidget ();
    if ((style & DWT.ARROW) !is 0) {
        if ((style & (DWT.UP | DWT.DOWN | DWT.LEFT | DWT.RIGHT)) is 0) return;
        style &= ~(DWT.UP | DWT.DOWN | DWT.LEFT | DWT.RIGHT);
        style |= alignment & (DWT.UP | DWT.DOWN | DWT.LEFT | DWT.RIGHT);
        OS.InvalidateRect (handle, null, true);
        return;
    }
    if ((alignment & (DWT.LEFT | DWT.RIGHT | DWT.CENTER)) is 0) return;
    style &= ~(DWT.LEFT | DWT.RIGHT | DWT.CENTER);
    style |= alignment & (DWT.LEFT | DWT.RIGHT | DWT.CENTER);
    int oldBits = OS.GetWindowLong (handle, OS.GWL_STYLE), newBits = oldBits;
    newBits &= ~(OS.BS_LEFT | OS.BS_CENTER | OS.BS_RIGHT);
    if ((style & DWT.LEFT) !is 0) newBits |= OS.BS_LEFT;
    if ((style & DWT.CENTER) !is 0) newBits |= OS.BS_CENTER;
    if ((style & DWT.RIGHT) !is 0) newBits |= OS.BS_RIGHT;
    if (OS.COMCTL32_MAJOR >= 6) {
        if (imageList !is null) {
            BUTTON_IMAGELIST buttonImageList;
            buttonImageList.himl = imageList.getHandle ();
            if (text.length is 0) {
                if ((style & DWT.LEFT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                if ((style & DWT.CENTER) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_CENTER;
                if ((style & DWT.RIGHT) !is 0) buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_RIGHT;
            } else {
                buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                buttonImageList.margin.left = computeLeftMargin ();
                buttonImageList.margin.right = MARGIN;
                newBits &= ~(OS.BS_CENTER | OS.BS_RIGHT);
                newBits |= OS.BS_LEFT;
            }
            OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, &buttonImageList);
        }
    }
    if (newBits !is oldBits) {
        OS.SetWindowLong (handle, OS.GWL_STYLE, newBits);
        OS.InvalidateRect (handle, null, true);
    }
}

void setDefault (bool value) {
    if ((style & DWT.PUSH) is 0) return;
    auto hwndShell = menuShell ().handle;
    int bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
    if (value) {
        bits |= OS.BS_DEFPUSHBUTTON;
        OS.SendMessage (hwndShell, OS.DM_SETDEFID, handle, 0);
    } else {
        bits &= ~OS.BS_DEFPUSHBUTTON;
        OS.SendMessage (hwndShell, OS.DM_SETDEFID, 0, 0);
    }
    OS.SendMessage (handle, OS.BM_SETSTYLE, bits, 1);
}

override bool setFixedFocus () {
    /*
    * Feature in Windows.  When a radio button gets focus,
    * it selects the button in WM_SETFOCUS.  The fix is to
    * not assign focus to an unselected radio button.
    */
    if ((style & DWT.RADIO) !is 0 && !getSelection ()) return false;
    return super.setFixedFocus ();
}

/**
 * Sets the receiver's image to the argument, which may be
 * <code>null</code> indicating that no image should be displayed.
 * <p>
 * Note that a Button can display an image and text simultaneously
 * on Windows (starting with XP), GTK+ and OSX.  On other platforms,
 * a Button that has an image and text set into it will display the
 * image or text that was set most recently.
 * </p>
 * @param image the image to display on the receiver (may be <code>null</code>)
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_ARGUMENT - if the image has been disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setImage (Image image) {
    checkWidget ();
    if (image !is null && image.isDisposed()) error(DWT.ERROR_INVALID_ARGUMENT);
    if ((style & DWT.ARROW) !is 0) return;
    this.image = image;
    /* This code is intentionally commented */
//  if (OS.COMCTL32_MAJOR < 6) {
//      if (image is null || text.length !is 0) {
//          _setText (text);
//          return;
//      }
//  }
    _setImage (image);
}

/**
 * Sets the grayed state of the receiver.  This state change
 * only applies if the control was created with the DWT.CHECK
 * style.
 *
 * @param grayed the new grayed state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 * 
 * @since 3.4
 */
public void setGrayed (bool grayed) {
    checkWidget ();
    if ((style & DWT.CHECK) is 0) return;
    this.grayed = grayed;
    int /*long*/ flags = OS.SendMessage (handle, OS.BM_GETCHECK, 0, 0);
    if (grayed) {
        if (flags is OS.BST_CHECKED) updateSelection (OS.BST_INDETERMINATE);
    } else {
        if (flags is OS.BST_INDETERMINATE) updateSelection (OS.BST_CHECKED);
    }
}

/**
 * Sets the widget message. When the widget is created
 * with the style <code>DWT.COMMAND</code>, the message text
 * is displayed to provide further information for the user.
 *
 * @param message the new message
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the string is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.3
 */
/*public*/ void setMessage (String message) {
    checkWidget ();
    // DWT externsion: allow null string
    //if (message is null) error (DWT.ERROR_NULL_ARGUMENT);
    this.message = message;
    if (OS.COMCTL32_VERSION >= OS.VERSION (6, 1)) {
        if ((style & DWT.COMMAND) !is 0) {
            OS.SendMessage (handle, OS.BCM_SETNOTE, 0, StrToTCHARz( message ));
        }
    }
}

override bool setRadioFocus () {
    if ((style & DWT.RADIO) is 0 || !getSelection ()) return false;
    return setFocus ();
}

override bool setRadioSelection (bool value) {
    if ((style & DWT.RADIO) is 0) return false;
    if (getSelection () !is value) {
        setSelection (value);
        postEvent (DWT.Selection);
    }
    return true;
}

override bool setSavedFocus () {
    /*
    * Feature in Windows.  When a radio button gets focus,
    * it selects the button in WM_SETFOCUS.  If the previous
    * saved focus widget was a radio button, allowing the shell
    * to automatically restore the focus to the previous radio
    * button will unexpectedly check that button.  The fix is to
    * not assign focus to an unselected radio button.
    */
    if ((style & DWT.RADIO) !is 0 && !getSelection ()) return false;
    return super.setSavedFocus ();
}

/**
 * Sets the selection state of the receiver, if it is of type <code>CHECK</code>,
 * <code>RADIO</code>, or <code>TOGGLE</code>.
 *
 * <p>
 * When the receiver is of type <code>CHECK</code> or <code>RADIO</code>,
 * it is selected when it is checked. When it is of type <code>TOGGLE</code>,
 * it is selected when it is pushed in.
 *
 * @param selected the new selection state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setSelection (bool selected) {
    checkWidget ();
    if ((style & (DWT.CHECK | DWT.RADIO | DWT.TOGGLE)) is 0) return;
    int flags = selected ? OS.BST_CHECKED : OS.BST_UNCHECKED;
    if ((style & DWT.CHECK) !is 0) {
        if (selected && grayed) flags = OS.BST_INDETERMINATE;
    }
    updateSelection (flags);
}

/**
 * Sets the receiver's text.
 * <p>
 * This method sets the button label.  The label may include
 * the mnemonic character but must not contain line delimiters.
 * </p>
 * <p>
 * Mnemonics are indicated by an '&amp;' that causes the next
 * character to be the mnemonic.  When the user presses a
 * key sequence that matches the mnemonic, a selection
 * event occurs. On most platforms, the mnemonic appears
 * underlined but may be emphasized in a platform specific
 * manner.  The mnemonic indicator character '&amp;' can be
 * escaped by doubling it in the string, causing a single
 * '&amp;' to be displayed.
 * </p><p>
 * Note that a Button can display an image and text simultaneously
 * on Windows (starting with XP), GTK+ and OSX.  On other platforms,
 * a Button that has an image and text set into it will display the
 * image or text that was set most recently.
 * </p>
 * @param string the new text
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setText (String string) {
    checkWidget ();
    // DWT externsion: allow null string
    //if (string is null) error (DWT.ERROR_NULL_ARGUMENT);
    if ((style & DWT.ARROW) !is 0) return;
    text = string;
    /* This code is intentionally commented */
//  if (OS.COMCTL32_MAJOR < 6) {
//      if (text.length is 0 && image !is null) {
//          _setImage (image);
//          return;
//      }
//  }
    _setText (string);
}

void updateSelection (int flags) {
    if (flags !is OS.SendMessage (handle, OS.BM_GETCHECK, 0, 0)) {
        /*
        * Feature in Windows. When BM_SETCHECK is used
        * to set the checked state of a radio or check
        * button, it sets the WM_TABSTOP style.  This
        * is undocumented and unwanted.  The fix is
        * to save and restore the window style bits.
        */
        int bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
        if ((style & DWT.CHECK) !is 0) {
            if (flags is OS.BST_INDETERMINATE) {
                bits &= ~OS.BS_CHECKBOX;
                bits |= OS.BS_3STATE;
            } else {
                bits |= OS.BS_CHECKBOX;
                bits &= ~OS.BS_3STATE;
            }
            if (bits !is OS.GetWindowLong (handle, OS.GWL_STYLE)) {
                OS.SetWindowLong (handle, OS.GWL_STYLE, bits);
            }
        }
        OS.SendMessage (handle, OS.BM_SETCHECK, flags, 0);
        if (bits !is OS.GetWindowLong (handle, OS.GWL_STYLE)) {
            OS.SetWindowLong (handle, OS.GWL_STYLE, bits);
        }
    }
}

override int widgetStyle () {
    int bits = super.widgetStyle ();
    if ((style & DWT.FLAT) !is 0) bits |= OS.BS_FLAT;
    if ((style & DWT.ARROW) !is 0) return bits | OS.BS_OWNERDRAW;
    if ((style & DWT.LEFT) !is 0) bits |= OS.BS_LEFT;
    if ((style & DWT.CENTER) !is 0) bits |= OS.BS_CENTER;
    if ((style & DWT.RIGHT) !is 0) bits |= OS.BS_RIGHT;
    if ((style & DWT.PUSH) !is 0) return bits | OS.BS_PUSHBUTTON | OS.WS_TABSTOP;
    if ((style & DWT.CHECK) !is 0) return bits | OS.BS_CHECKBOX | OS.WS_TABSTOP;
    if ((style & DWT.RADIO) !is 0) return bits | OS.BS_RADIOBUTTON;
    if ((style & DWT.TOGGLE) !is 0) return bits | OS.BS_PUSHLIKE | OS.BS_CHECKBOX | OS.WS_TABSTOP;
    if ((style & DWT.COMMAND) !is 0) return bits | OS.BS_COMMANDLINK | OS.WS_TABSTOP;
    return bits | OS.BS_PUSHBUTTON | OS.WS_TABSTOP;
}

override String windowClass () {
    return TCHARzToStr( ButtonClass.ptr );
}

override int windowProc () {
    return cast(int) ButtonProc;
}


override LRESULT WM_ERASEBKGND (int wParam, int lParam) {
    LRESULT result = super.WM_ERASEBKGND (wParam, lParam);
    if (result !is null) return result;
    /*
    * Bug in Windows.  For some reason, the HBRUSH that
    * is returned from WM_CTRLCOLOR is misaligned when
    * the button uses it to draw.  If the brush is a solid
    * color, this does not matter.  However, if the brush
    * contains an image, the image is misaligned.  The
    * fix is to draw the background in WM_ERASEBKGND.
    */
    if (OS.COMCTL32_MAJOR < 6) {
        if ((style & (DWT.RADIO | DWT.CHECK)) !is 0) {
            if (findImageControl () !is null) {
                drawBackground (cast(HWND)wParam);
                return LRESULT.ONE;
            }
        }
    }
    return result;
}

override LRESULT WM_GETDLGCODE (int wParam, int lParam) {
    LRESULT result = super.WM_GETDLGCODE (wParam, lParam);
    if (result !is null) return result;
    if ((style & DWT.ARROW) !is 0) {
        return new LRESULT (OS.DLGC_STATIC);
    }
    return result;
}

override LRESULT WM_KILLFOCUS (int wParam, int lParam) {
    LRESULT result = super.WM_KILLFOCUS (wParam, lParam);
    if ((style & DWT.PUSH) !is 0 && getDefault ()) {
        menuShell ().setDefaultButton (null, false);
    }
    return result;
}

override LRESULT WM_LBUTTONDOWN (int wParam, int lParam) {
    if (ignoreMouse) return null;
    return super.WM_LBUTTONDOWN (wParam, lParam);
}

override LRESULT WM_LBUTTONUP (int wParam, int lParam) {
    if (ignoreMouse) return null;
    return super.WM_LBUTTONUP (wParam, lParam);
}

override LRESULT WM_SETFOCUS (int wParam, int lParam) {
    /*
    * Feature in Windows. When Windows sets focus to
    * a radio button, it sets the WM_TABSTOP style.
    * This is undocumented and unwanted.  The fix is
    * to save and restore the window style bits.
    */
    int bits = 0;
    if ((style & DWT.RADIO) !is 0) {
        bits = OS.GetWindowLong (handle, OS.GWL_STYLE);
    }
    LRESULT result = super.WM_SETFOCUS (wParam, lParam);
    if ((style & DWT.RADIO) !is 0) {
        OS.SetWindowLong (handle, OS.GWL_STYLE, bits);
    }
    if ((style & DWT.PUSH) !is 0) {
        menuShell ().setDefaultButton (this, false);
    }
    return result;
}

override LRESULT WM_SIZE (int wParam, int lParam) {
    LRESULT result = super.WM_SIZE (wParam, lParam);
    if (result !is null) return result;
    if (OS.COMCTL32_MAJOR >= 6) {
        if ((style & (DWT.PUSH | DWT.TOGGLE)) !is 0) {
            if (imageList !is null && text.length !is 0) {
                BUTTON_IMAGELIST buttonImageList;
                OS.SendMessage (handle, OS.BCM_GETIMAGELIST, 0, &buttonImageList);
                buttonImageList.uAlign = OS.BUTTON_IMAGELIST_ALIGN_LEFT;
                buttonImageList.margin.left = computeLeftMargin ();
                buttonImageList.margin.right = MARGIN;
                OS.SendMessage (handle, OS.BCM_SETIMAGELIST, 0, &buttonImageList);
            }
        }
    }
    return result;
}

override LRESULT WM_SYSCOLORCHANGE (int wParam, int lParam) {
    LRESULT result = super.WM_SYSCOLORCHANGE (wParam, lParam);
    if (result !is null) return result;
    if (image2 !is null) _setImage (image);
    return result;
}

override LRESULT WM_UPDATEUISTATE (int wParam, int lParam) {
    LRESULT result = super.WM_UPDATEUISTATE (wParam, lParam);
    if (result !is null) return result;
    /*
    * Feature in Windows.  When WM_UPDATEUISTATE is sent to
    * a button, it sends WM_CTLCOLORBTN to get the foreground
    * and background.  If drawing happens in WM_CTLCOLORBTN,
    * it will overwrite the contents of the control.  The
    * fix is draw the button without drawing the background
    * and avoid the button window proc.
    *
    * NOTE:  This only happens for radio, check and toggle
    * buttons.
    */
    if (!OS.IsWinCE && OS.WIN32_VERSION >= OS.VERSION (6, 0)) {
        if ((style & (DWT.RADIO | DWT.CHECK | DWT.TOGGLE)) !is 0) {
            bool redraw = findImageControl () !is null;
            if (!redraw) {
                if ((state & THEME_BACKGROUND) !is 0) {
                    if (OS.COMCTL32_MAJOR >= 6 && OS.IsAppThemed ()) {
                        redraw = findThemeControl () !is null;
                    }
                }
                if (!redraw) redraw = findBackgroundControl () !is null;
            }
            if (redraw) {
                OS.InvalidateRect (handle, null, false);
                int /*long*/ code = OS.DefWindowProc (handle, OS.WM_UPDATEUISTATE, wParam, lParam);
                return new LRESULT (code);
            }
        }
    }
    return result;
}

override LRESULT wmCommandChild (int wParam, int lParam) {
    int code = OS.HIWORD (wParam);
    switch (code) {
        case OS.BN_CLICKED:
        case OS.BN_DOUBLECLICKED:
            if ((style & (DWT.CHECK | DWT.TOGGLE)) !is 0) {
                setSelection (!getSelection ());
            } else {
                if ((style & DWT.RADIO) !is 0) {
                    if ((parent.getStyle () & DWT.NO_RADIO_GROUP) !is 0) {
                        setSelection (!getSelection ());
                    } else {
                        selectRadio ();
                    }
                }
            }
            postEvent (DWT.Selection);
        default:
    }
    return super.wmCommandChild (wParam, lParam);
}

override LRESULT wmColorChild (int wParam, int lParam) {
    /*
    * Bug in Windows.  For some reason, the HBRUSH that
    * is returned from WM_CTRLCOLOR is misaligned when
    * the button uses it to draw.  If the brush is a solid
    * color, this does not matter.  However, if the brush
    * contains an image, the image is misaligned.  The
    * fix is to draw the background in WM_ERASEBKGND.
    */
    LRESULT result = super.wmColorChild (wParam, lParam);
    if (OS.COMCTL32_MAJOR < 6) {
        if ((style & (DWT.RADIO | DWT.CHECK)) !is 0) {
            if (findImageControl () !is null) {
                OS.SetBkMode (cast(HANDLE)wParam, OS.TRANSPARENT);
                return new LRESULT ( cast(int) OS.GetStockObject (OS.NULL_BRUSH));
            }
        }
    }
    return result;
}

override LRESULT wmDrawChild (int wParam, int lParam) {
    if ((style & DWT.ARROW) is 0) return super.wmDrawChild (wParam, lParam);
    auto struct_ = cast(DRAWITEMSTRUCT*)lParam;
    //OS.MoveMemory (struct_, lParam, DRAWITEMSTRUCT.sizeof);
    RECT rect;
    OS.SetRect (&rect, struct_.rcItem.left, struct_.rcItem.top, struct_.rcItem.right, struct_.rcItem.bottom);
    if (OS.COMCTL32_MAJOR >= 6 && OS.IsAppThemed ()) {
        int iStateId = OS.ABS_LEFTNORMAL;
        switch (style & (DWT.UP | DWT.DOWN | DWT.LEFT | DWT.RIGHT)) {
            case DWT.UP: iStateId = OS.ABS_UPNORMAL; break;
            case DWT.DOWN: iStateId = OS.ABS_DOWNNORMAL; break;
            case DWT.LEFT: iStateId = OS.ABS_LEFTNORMAL; break;
            case DWT.RIGHT: iStateId = OS.ABS_RIGHTNORMAL; break;
            default:
        }
        /*
        * NOTE: The normal, hot, pressed and disabled state is
        * computed relying on the fact that the increment between
        * the direction states is invariant (always separated by 4).
        */
        if (!getEnabled ()) iStateId += OS.ABS_UPDISABLED - OS.ABS_UPNORMAL;
        if ((struct_.itemState & OS.ODS_SELECTED) !is 0) iStateId += OS.ABS_UPPRESSED - OS.ABS_UPNORMAL;
        OS.DrawThemeBackground (display.hScrollBarTheme (), struct_.hDC, OS.SBP_ARROWBTN, iStateId, &rect, null);
    } else {
        int uState = OS.DFCS_SCROLLLEFT;
        switch (style & (DWT.UP | DWT.DOWN | DWT.LEFT | DWT.RIGHT)) {
            case DWT.UP: uState = OS.DFCS_SCROLLUP; break;
            case DWT.DOWN: uState = OS.DFCS_SCROLLDOWN; break;
            case DWT.LEFT: uState = OS.DFCS_SCROLLLEFT; break;
            case DWT.RIGHT: uState = OS.DFCS_SCROLLRIGHT; break;
            default:
        }
        if (!getEnabled ()) uState |= OS.DFCS_INACTIVE;
        if ((style & DWT.FLAT) is DWT.FLAT) uState |= OS.DFCS_FLAT;
        if ((struct_.itemState & OS.ODS_SELECTED) !is 0) uState |= OS.DFCS_PUSHED;
        OS.DrawFrameControl (struct_.hDC, &rect, OS.DFC_SCROLL, uState);
    }
    return null;
}

}
