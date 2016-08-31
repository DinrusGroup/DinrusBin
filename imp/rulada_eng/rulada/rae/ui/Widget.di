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

module rae.ui.Widget;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.EventType;
import rae.canvas.Draw;
public import rae.canvas.Rectangle;
import rae.ui.Animator;
import rae.canvas.Bezier;
import rae.canvas.rtree.RTree;


version(sdl)
{
	import derelict.opengl.gl;
	import derelict.opengl.glu;
	//import derelict.sdl.sdl;
}//end version(sdl)
version(gtk)
{
	import gtkD.gtkglc.gl;
	import gtkD.gtkglc.glu;
}


alias Rectangle Widget;


/+

class Widget : public Rectangle
{
public:

	//internal
	//public uint pickingID;//OpenGL picking didn't quite work as it was
	//really slow.

	

	/*
	protected Widget m_rootWindow;///This is a top level Window.
	public Widget rootWindow(Widget set)///Don't use this yourself.
	{
		m_rootWindow = set;
		//pickingID = m_rootWindow.nextPickingID();
		foreach(wid; itemList)
		{
			wid.rootWindow = set;
		}
		return m_rootWindow;
	}
	public Widget rootWindow() { return m_rootWindow; }///Don't use this yourself.
	
	
	Widget parent;
	LinkedList!(Widget) itemList() { return m_itemList; };
	LinkedList!(Widget) m_itemList;
	RTree itemTree() { return m_itemTree; }
	RTree m_itemTree;
	*/
	
	
	
/*	
	//The caller is responsible for the destruction of
	//the returned LinkedList.
	//If the ignore_z_order is true, then no zOrder checking
	//will be performed and all the hits will be returned.
	//Otherwise (the default behaviour) the zOrder is checked
	//and only those new hits that have a better zOrder than the
	//previous hits will get added to the list. So the best
	//zOrder widget will be in .tail of the list.
	//internal
	LinkedList!(Widget) enclosureList( InputState input, bool ignore_z_order = false )
	{
		debug(Widget) Trace.formatln("Widget.enclosureList(...) START.");
		debug(Widget) scope(exit) Trace.formatln("Widget.enclosureList(...) END.");
	
//ONGELMA: testaa tämänkin widgetin enclosure. Ja mieti miten
//se vaikuttaa Windowhin...
	
		LinkedList!(Widget) hitlist = new LinkedList!(Widget);
		uint bestzorder = uint.max;
		foreach( Widget wid; child )
		{
			debug(Widget) Trace.formatln("Widget.enclosureList(...) in foreach.");
			if( wid.enclosure( input.mouse.x, input.mouse.y ) == true )
			{
				debug(Widget) Trace.formatln("Widget.enclosureList(...) .");
				bool doit = false;
				
				if( ignore_z_order == false && wid.zOrder < bestzorder )
				{
					doit = true;
				}
				else doit = true;
				
				if(doit == true )
				{
					bestzorder = wid.zOrder;
					hitlist.append( wid );
					//Umm. Check it's child widgets...
					debug(Widget) Trace.formatln("Widget.enclosureList(...) Going to get child enclosureList.");
					scope LinkedList!(Widget) childlist = wid.enclosureList(input);
					
					foreach(Widget cw; childlist)
					{
						if( cw.zOrder < bestzorder )
						{
							bestzorder = cw.zOrder;
							hitlist.append( cw );
						}
					}
				}
			}
		}
		return hitlist;
	}
*/	
	
	
	
	this()
	{
		super();
		//rectangle = new Rectangle(0.0, 0.0, 1.0, 1.0);
	}
	
	
	//float yRot = 0.0f;
	//bool isRotate = false;
	
	//float x = 0.0;
	//float y = 0.0;
	
	/*
	void render(Draw draw)
	{
		//glPushName( pickingID );
			super.render(draw);
		//glPopName();
	}
	*/
	
/*	
	void render()
	{
		//glLoadIdentity();
		
		//glTranslatef( 0.0f, 0.0f, -5.0f );
		
		glDisable(GL_TEXTURE_2D);
	
		glPushMatrix();
			//glTranslatef( cx, cy, 0.0f );//cx,cy is the new center!
			//Oh yeah.. but translating is futile, as
			//the drawing coordinates x and w etc. already
			//are in canvas coordinates.
			//glRotatef( rotate_y, 0.0f, 1.0f, 0.0f );
			
			//applyRotation();
			Rectangle.render();
			
			renderChildren();
			
			//glTranslatef( cx, cy, 0.0f );
			
			
			
			
			
			//if( isRotate == true )
			//{
			//	rotate_y += 0.3f;
				//Trace.formatln("rotate_y: ")(rotate_y);
			//}
			//if( rotate_y >= 180.0f )
			//{
			//	isRotate = false;
			//	rotate_y = 0.0f;
			//}
		glPopMatrix();
	}
*/
	

	/*
	//I bet this can be removed:
	void render()
	{
		//Trace.formatln("Widget.render() START.");
		glPushMatrix();
			glTranslatef( x, y, 0.0f );
			glRotatef( rotate_y, 0.0f, 1.0f, 0.0f );
			//rectangle.render();
			super.render();
			if( isRotate == true )
			{
				rotate_y += 0.3f;
				Trace.formatln("rotate_y: ")(rotate_y);
			}
			if( rotate_y >= 180.0f )
			{
				isRotate = false;
				rotate_y = 0.0f;
			}
		glPopMatrix();
	}*/
	
	
	
protected:
	//Rectangle rectangle;
}

+/



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
