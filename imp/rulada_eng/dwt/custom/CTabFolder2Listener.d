﻿/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
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
module dwt.custom.CTabFolder2Listener;

import dwt.internal.DWTEventListener;
import dwt.custom.CTabFolderEvent;

import tango.core.Traits;
import tango.core.Tuple;

/**
 * Classes which implement this interface provide methods
 * that deal with the events that are generated by the CTabFolder
 * control.
 * <p>
 * After creating an instance of a class that :
 * this interface it can be added to a CTabFolder using the
 * <code>addCTabFolder2Listener</code> method and removed using
 * the <code>removeCTabFolder2Listener</code> method. When
 * events occurs in a CTabFolder the appropriate method
 * will be invoked.
 * </p>
 *
 * @see CTabFolder2Adapter
 * @see CTabFolderEvent
 *
 * @since 3.0
 */
public interface CTabFolder2Listener : DWTEventListener {
    public enum {
        MINIMIZE,
        MAXIMIZE,
        SHOWLIST,
        RESTORE,
        CLOSE
    }

/**
 * Sent when the user clicks on the close button of an item in the CTabFolder.
 * The item being closed is specified in the event.item field.
 * Setting the event.doit field to false will stop the CTabItem from closing.
 * When the CTabItem is closed, it is disposed.  The contents of the
 * CTabItem (see CTabItem.setControl) will be made not visible when
 * the CTabItem is closed.
 *
 * @param event an event indicating the item being closed
 */
public void close(CTabFolderEvent event);

/**
 * Sent when the user clicks on the minimize button of a CTabFolder.
 * The state of the CTabFolder does not change automatically - it
 * is up to the application to change the state of the CTabFolder
 * in response to this event using CTabFolder.setMinimized(true).
 *
 * @param event an event containing information about the minimize
 *
 * @see CTabFolder#getMinimized()
 * @see CTabFolder#setMinimized(bool)
 * @see CTabFolder#setMinimizeVisible(bool)
 */
public void minimize(CTabFolderEvent event);

/**
 * Sent when the user clicks on the maximize button of a CTabFolder.
 * The state of the CTabFolder does not change automatically - it
 * is up to the application to change the state of the CTabFolder
 * in response to this event using CTabFolder.setMaximized(true).
 *
 * @param event an event containing information about the maximize
 *
 * @see CTabFolder#getMaximized()
 * @see CTabFolder#setMaximized(bool)
 * @see CTabFolder#setMaximizeVisible(bool)
 */
public void maximize(CTabFolderEvent event);

/**
 * Sent when the user clicks on the restore button of a CTabFolder.
 * This event is sent either to restore the CTabFolder from the
 * minimized state or from the maximized state.  To determine
 * which restore is requested, use CTabFolder.getMinimized() or
 * CTabFolder.getMaximized() to determine the current state.
 * The state of the CTabFolder does not change automatically - it
 * is up to the application to change the state of the CTabFolder
 * in response to this event using CTabFolder.setMaximized(false)
 * or CTabFolder.setMinimized(false).
 *
 * @param event an event containing information about the restore
 *
 * @see CTabFolder#getMinimized()
 * @see CTabFolder#getMaximized()
 * @see CTabFolder#setMinimized(bool)
 * @see CTabFolder#setMinimizeVisible(bool)
 * @see CTabFolder#setMaximized(bool)
 * @see CTabFolder#setMaximizeVisible(bool)
 */
public void restore(CTabFolderEvent event);

/**
 * Sent when the user clicks on the chevron button of the CTabFolder.
 * A chevron appears in the CTabFolder when there are more tabs
 * than can be displayed at the current widget size.  To select a
 * tab that is not currently visible, the user clicks on the
 * chevron and selects a tab item from a list.  By default, the
 * CTabFolder provides a list of all the items that are not currently
 * visible, however, the application can provide its own list by setting
 * the event.doit field to <code>false</code> and displaying a selection list.
 *
 * @param event an event containing information about the show list
 *
 * @see CTabFolder#setSelection(CTabItem)
 */
public void showList(CTabFolderEvent event);
}



/// Helper class for the dgListener template function
private class _DgCTabFolder2ListenerT(Dg,T...) : CTabFolder2Listener {

    alias ParameterTupleOf!(Dg) DgArgs;
    static assert( is(DgArgs == Tuple!(CTabFolderEvent,T)),
                "Delegate args not correct: "~DgArgs.stringof~" vs. (Event,"~T.stringof~")" );

    Dg dg;
    T  t;
    int type;

    private this( int type, Dg dg, T t ){
        this.type = type;
        this.dg = dg;
        static if( T.length > 0 ){
            this.t = t;
        }
    }

    void itemClosed( CTabFolderEvent e ){
        dg(e,t);
    }
    public void close(CTabFolderEvent e){
        if( type is CTabFolder2Listener.CLOSE ){
            dg(e,t);
        }
    }
    public void minimize(CTabFolderEvent e){
        if( type is CTabFolder2Listener.MINIMIZE ){
            dg(e,t);
        }
    }
    public void maximize(CTabFolderEvent e){
        if( type is CTabFolder2Listener.MAXIMIZE ){
            dg(e,t);
        }
    }
    public void restore(CTabFolderEvent e){
        if( type is CTabFolder2Listener.RESTORE ){
            dg(e,t);
        }
    }
    public void showList(CTabFolderEvent e){
        if( type is CTabFolder2Listener.SHOWLIST ){
            dg(e,t);
        }
    }
}

/++
 + dgListener creates a class implementing the Listener interface and delegating the call to
 + handleEvent to the users delegate. This template function will store also additional parameters.
 +
 + Examle of usage:
 + ---
 + void handleTextEvent ( Event e, int inset ) {
 +     // ...
 + }
 + text.addListener (DWT.FocusOut, dgListener( &handleTextEvent, inset ));
 + ---
 +/
CTabFolder2Listener dgCTabFolder2Listener( Dg, T... )( int type, Dg dg, T args ){
    return new _DgCTabFolder2ListenerT!( Dg, T )( type, dg, args );
}



