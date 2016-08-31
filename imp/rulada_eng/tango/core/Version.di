﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. All rights reserved

        license:        BSD style: $(LICENSE)

        version:        Jan 2007: Initial release

        author:         Kris

        Exposes the library version number

*******************************************************************************/

module tango.core.Version;

public enum Tango {
    Major = 1,
    Minor = 0
}

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
