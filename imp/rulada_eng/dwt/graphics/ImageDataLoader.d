/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwt.graphics.ImageDataLoader;

public import dwt.graphics.ImageData;
public import dwt.dwthelper.InputStream;

import dwt.graphics.ImageLoader;
import dwt.dwthelper.utils;

/**
 * Internal class that separates ImageData from ImageLoader
 * to allow removal of ImageLoader from the toolkit.
 */
class ImageDataLoader {

    public static ImageData[] load(InputStream stream) {
        return (new ImageLoader()).load(stream);
    }

    public static ImageData[] load(String filename) {
        return (new ImageLoader()).load(filename);
    }

}
