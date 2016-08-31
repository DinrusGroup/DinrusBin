module rae.gl.util;

import tango.util.log.Trace;//Thread safe console output.

import stringz = tango.stdc.stringz;

import rae.gl.gl;
import rae.gl.glu;
import rae.gl.glext;

	int checkOpenGLError()
	{
		//
		// Returns 1 if an OpenGL error occurred, 0 otherwise.
		//
		GLenum glErr;
		int retCode = 0;
		
		glErr = glGetError();
		while (glErr != GL_NO_ERROR)
		{
				Trace.formatln("glError: {}, num: {}", stringz.fromStringz(cast(char*)gluErrorString(glErr)), glErr );
				retCode = 1;
				glErr = glGetError();
		}
		return retCode;
	}
	
	

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
