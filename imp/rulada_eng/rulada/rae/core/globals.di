/*
* The X11/MIT License
* 
* Copyright (c) 2008-2009, Jonas Kivi
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.core.globals;

import tango.util.log.Trace;//Thread safe console output.

public enum OrientationType
{
	HORIZONTAL,
	VERTICAL
}

public enum DirectionType
{
	LEFT,
	RIGHT,
	UP,
	DOWN,
	UP_LEFT,
	UP_RIGHT,
	DOWN_RIGHT,
	DOWN_LEFT
}

//This should go to ShapeRectangle, but it doesn't want to go there.
public enum ShapeType
{
	RECTANGLE,
	ROUND_RECTANGLE,
	SHADOW//or ROUND_CORNERS
}

unittest
{
	debug(Rae) Trace.formatln("unittest: weightedAverage.");
	assert( weightedAverage( 0.0f, 1.0f, 0.5f ) == 0.5f );
	assert( weightedAverage( 0.0f, 1.0f, 0.0f ) == 0.0f );
	assert( weightedAverage( 0.0f, 1.0f, 1.0f ) == 1.0f );
	assert( weightedAverage( 1.0f, 0.0f, 1.0f ) == 0.0f );
	assert( weightedAverage( 1.0f, 0.0f, 0.0f ) == 1.0f );
	assert( weightedAverage( -1.0f, 1.0f, 1.0f ) == 1.0f );
	assert( weightedAverage( -1.0f, 1.0f, 0.0f ) == -1.0f );
	assert( weightedAverage( -1.0f, 0.0f, 0.0f ) == -1.0f );
	assert( weightedAverage( -1.0f, 0.0f, 1.0f ) == 0.0f );
}

//TODO, put this into some better place:
//This will return a kind of a weighted average of two values.
//If your set_position is 0.0 then your result will be val1.
//If your set_position is 1.0 then your result will be val2.
//So it is kind of a line from val1 to val2 where set_position
//defines the percentage where you are.
float weightedAverage( float val1, float val2, float set_position )
{
	//weighted average (so that the sum of the weights becomes 1.0.)
	//return (set_position * val1) + ((1.0f-set_position) * val2);
	return ((1.0f-set_position) * val1) + (set_position * val2);
}

public import rae.core.IRaeMain;

IRaeMain g_rae;






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
