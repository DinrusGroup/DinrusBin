/******************************************************************************* 

    Color type

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Color type, simplifies color for parameter passing. Note that
		the color values are stored as floats in the 0.0 .. 1.0 range.
		

	Examples:
	--------------------
	import arc.types;

	int main() 
	{
		Color c = Color(255,255,255);
		Color c = Color(255,255,255,255);
		Color c = Color(1.0, 0.5, 0.1);
		Color c = Color.Yellow;

		c.setGlColor(); // equivalent to glColor4f(c.r,c.g,c.b,c.a);

		return 0;
	}
	--------------------

*******************************************************************************/

module arc.draw.color; 

import arc.types;
import derelict.opengl.gl; 
import std.string;

/// holds red, green, blue and alpha values in floating point representation
struct Color
{
	/**
		Constructs a color.
	
		If the type of the arguments is implicitly convertible to ubyte,
		the arguments should be in the 0..255 range and the alpha value
		defaults to 255.
		If it is implicitly convertible to float, the colors range from
		0.0 to 1.0 and the default alpha value is 1.0.
	**/
	static Color opCall(T)(T r, T g, T b, T a = DefaultColorValue!(T));
	/// predefined white color
	/// predefined white color
	const static Color White = {1.,1.,1.};
	/// predefined black color
	const static Color Black = {0.,0.,0.};
	/// predefined red color
	const static Color Red = {1.,0.,0.};
	/// predefined green color
	const static Color Green = {0.,1.,0.};
	/// predefined blue color
	const static Color Blue = {0.,0.,1.};
	/// predefined yellow color
	const static Color Yellow = {1.,1.,0.};

	/// get Red value
	float getR();
	
	/// get Green value
	float getG();
	
	/// get Blue value 
	float getB();
	
	/// set Alpha value
	float getA();

	/// set Red value
	void setR(float argV);
	
	/// set Green value
	void setG(float argV);
	
	/// set Blue value 
	void setB(float argV);
	
	/// set Alpha value
	void setA(float argV);
	
	/// performs the OpenGL call required to set a color
	void setGLColor();
	
	float cell(int index);
	
	float r=1.0, g=1.0, b=1.0, a=1.0;
	
private:
	// see the constructor for details
	template DefaultColorValue(T)
	{
		static if(is(T : ubyte))
			const T DefaultColorValue = 255;
		else static if(is(T : float))
			const T DefaultColorValue = 1.;
		else
			const T DefaultColorValue = T.init;
	}	
}
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
