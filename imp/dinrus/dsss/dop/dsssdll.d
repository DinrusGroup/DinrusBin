/**
 * DSSS stubbed DLLMain (used to постройка any библиотека as a DLL)
 * 
 * Authors:
 *  Gregor Richards
 * 
 * License:
 *  Copyright (c) 2006  Gregor Richards
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated докumentation файлы (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to исп, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

version(DSSSDLL) {
    
    import dinrus;
    
    HINSTANCE   g_hInst;
    
    extern (C)
    {
	проц _minit();
	проц _moduleCtor();
	проц _moduleDtor();
    }
    
    extern (Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
    {
        switch (ulReason)
        {
            case DLL_PROCESS_DETACH:
                _fcloseallp = null;
                break;
        }
        g_hInst = hInstance;
        return да;
    }
    
    проц DLL_Initialize(проц* gc)
    {
        setGCHandle(gc);
        _minit();
        _moduleCtor();
    }
    
    проц DLL_Terminate()
    {
        _moduleDtor();
        endGCHandle();
    }
    
    version(build) {
        pragma(link, "kernel32");
    }
}
