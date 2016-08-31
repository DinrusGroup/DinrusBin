/**
 * Модуль memory предоставляет интерфейс к мусоросборщику, а так же
 * к прочим средствам управления памятью на уровне OS или API.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Sean Kelly
 */
module tango.core.Memory;
pragma(lib, "rulada.lib");
public import std.memory;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
