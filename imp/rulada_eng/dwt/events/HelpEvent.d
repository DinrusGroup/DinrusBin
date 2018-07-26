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
module dwt.events.HelpEvent;


import dwt.widgets.Event;
import dwt.events.TypedEvent;

/**
 * Instances of this class are sent as a result of
 * help being requested for a widget.
 *
 * @see HelpListener
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 */

public final class HelpEvent : TypedEvent {

    //static final long serialVersionUID = 3257001038606251315L;

/**
 * Constructs a new instance of this class based on the
 * information in the given untyped event.
 *
 * @param e the untyped event containing the information
 */
public this(Event e) {
    super(e);
}

}
