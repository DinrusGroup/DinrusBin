/*
Copyright 2006, 2007 Kirk McDonald

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
 * Этот модуль просто публично импортирует все другие компоненты пакета Pyd,
 * что делает их доступными из единой точки.
 */
module amigos.pyd.pyd;

public {
    import amigos.pyd.class_wrap;
    import amigos.pyd.def;
    import amigos.pyd.exception;
    import amigos.pyd.func_wrap;
    import amigos.pyd.make_object;
    import amigos.pyd.pydobject;
    import amigos.pyd.struct_wrap;

    // Importing these is only needed as a workaround to bug #311
    import amigos.pyd.ctor_wrap;
    import amigos.pyd.dg_convert;
    import amigos.pyd.exception;
    import amigos.pyd.func_wrap;
    version(Pyd_with_StackThreads) {
        import amigos.pyd.iteration;
    }
    import amigos.pyd.make_wrapper;
}


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
