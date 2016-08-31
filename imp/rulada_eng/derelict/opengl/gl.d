/*
 * Copyright (c) 2004-2009 Derelict Developers
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the names 'Derelict', 'DerelictGL', nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
module derelict.opengl.gl;

public
{
    import derelict.opengl.gltypes;
    import derelict.opengl.glfuncs;
    import derelict.opengl.gl12;
    import derelict.opengl.gl13;
    import derelict.opengl.gl14;
    import derelict.opengl.gl15;
    import derelict.opengl.gl20;
    import derelict.opengl.gl21;
}

private
{
    import derelict.util.loader;
    import derelict.util.exception;
    import derelict.util.wrapper;

    version(Windows)
    {
        import derelict.opengl.wgl;
        import derelict.util.wintypes;
        alias void* DerelictGLContext;
    }
    else version(linux)
    {
        version = UsingGLX;
    }
    else version(darwin)
    {
        import derelict.opengl.cgl;
        alias CGLContextObj DerelictGLContext;
    }

    version(UsingGLX)
    {
        import derelict.opengl.glx;
        alias GLXContext DerelictGLContext;
    }
}

private void loadAll(SharedLib lib) {
    loadPlatformGL(lib);
    loadGL(lib);
}

enum GLVersion
{
    VersionNone,
    Version11 = 11,
    Version12 = 12,
    Version13 = 13,
    Version14 = 14,
    Version15 = 15,
    Version20 = 20,
    Version21 = 21,
    HighestSupported = 21
}

version(darwin)
{
	// this needs to be shared with GLU on Mac
	package GenericLoader GLLoader;
}
else
{
	private GenericLoader GLLoader;
}


private
{
    typedef bool function(char[]) ExtensionLoader;
    ExtensionLoader[] loaders;
    bool versionsOnce           = false;
    bool extensionsOnce         = false;
    int numExtensionsLoaded     = 0;

    version(Windows)
    {
        version(DigitalMars)
        {
           //pragma(lib, "gdi32.lib");
		  // pragma(lib, "OpenGL32.lib");
		  pragma(lib, "rulada.lib");
        }

        extern(Windows) export int GetPixelFormat(void* hdc);
        int currentPixelFormat      = 0;
    }

    bool isLoadRequired();
}

/*
 This is less than ideal, since some of the functionality of GenericLoader has to be replicated here. It would be nicer
 to move to classes for the loaders so that we can use inheritance here. Is that not possible with the templated loader
 setup?
*/
struct DerelictGL
{
    static void setup(char[] winLibs, char[] linLibs, char[] macLibs, void function(SharedLib) userLoad, char[] versionStr = "");
	
    static void load(char[] libNameString = null);
	
    static void load(char[][] libs);

    static char[] versionString();

    static void unload();

    static bool loaded();

    static char[] libName();

    static bool hasValidContext();

    static DerelictGLContext getCurrentContext();
	
    static void loadVersions(GLVersion minVersion);

    static int loadExtensions();
	
    static GLVersion availableVersion();
	
    static char[] versionString(GLVersion glv);

    static void registerExtensionLoader(ExtensionLoader loader);

    private static GLVersion maxVersionAvail    = GLVersion.VersionNone;
    private static GLVersion loadedVersion      = GLVersion.VersionNone;

    private static void setVersion();
    private static void loadVersion(void function(SharedLib) loadFunc, GLVersion glv);
}


static this () {
    DerelictGL.setup (
        "opengl32.dll",
        "libGL.so.2,libGL.so.1,libGL.so",
        "../Frameworks/OpenGL.framework/OpenGL, /Library/Frameworks/OpenGL.framework/OpenGL, /System/Library/Frameworks/OpenGL.framework/OpenGL",
        &loadAll
    );
}

