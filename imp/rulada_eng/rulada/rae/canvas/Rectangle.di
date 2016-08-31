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

module rae.canvas.Rectangle;

import tango.util.log.Trace;//Thread safe console output.
import Float = tango.text.convert.Float;
import Utf = tango.text.convert.Utf;

import tango.core.Signal;
import tango.util.container.LinkedList;

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;
import rae.gl.util;

import rae.core.globals;
import rae.core.IRaeMain;

import rae.container.Stack;

public import rae.canvas.ICanvasItem;
public import rae.canvas.PlainRectangle;
import rae.canvas.IRootWindow;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.canvas.Bezier;
import rae.canvas.Colour;
import rae.ui.Animator;
import rae.ui.InputState;
import rae.canvas.Point;
import rae.canvas.rtree.RTree;
//import rae.canvas.rtree.Node;
//import rae.canvas.rtree.AbstractNode;
//import rae.canvas.rtree.Index;

import rae.ui.Scrollbar;

/*
	There propably should be two versions of
	Rectangles. PlainRectangle or just Rectangle
	and RRectangle or RTreeRect or RTreeRectangle or
	TreeRectangle. The following is specific to
	RTreeRectangle and should go just there.
	*/

//I've decided that Widget's should be versatile containers
//so that you can use any widget as a vbox or any other layout
//you want and add child widget's to any other widget.

enum DefaultAnimator
{
	RAISE,
	LOWER,
	ROTATE_180,
	ROTATE_180_TO_360,
	ROTATE_360
}

enum ArrangeType
{
	VBOX,
	HBOX,
	GRID,
	FREE,
	LAYER //layer or composite the child widgets on top of each other.
}

public import rae.canvas.AlignType;

//Packing options for adding child widgets to a Widget
enum PackOptions
{
	BYPASS, //Don't arrange this widget in this x or y direction.
	FREE, //The parent doesn't affect this widgets size, only position can be effected.
	SHRINK, //Space is contracted to the child widget size.
	EXPAND_PADDING, //Space is expanded, with extra space filled with padding.
	EXPAND //Space is expanded, with extra space filled by increasing the child widget size.
}

enum ScrollbarSetting
{
	NEVER,
	ALWAYS,
	AUTO //Automatically show scrollbars if the widget can't fit it's children.
}





class Rectangle : public PlainRectangle//, IColour
{
public:

	this()
	{
		debug(Rectangle) Trace.formatln("Rectangle.this() START.");
		debug(Rectangle) scope(exit) Trace.formatln("Rectangle.this() END.");
		
		super();
		debug(Rectangle) Trace.formatln("Rectangle.this() After super().");
		
		type = "Rectangle";
		
		//We now create these on demand:
		//m_itemList = new LinkedList!(Rectangle);
		//m_itemTree = new RTree();
		//animator = new LinkedList!(Animator);

		debug(outline) isOutline = true;
		
		//We'll set a minHeight and minWidth for every
		//widget to be 0.01. The programmer has to explicitly
		//set the minHeight to be 0.0f if it is desired that
		//the widget ever becomes unusably small.
		//On most cases the programmer should define the
		//minimum sizes to be bigger than 0.01, because that
		//already is quite small.
		minWidth = 0.01f;
		minHeight = 0.01f;
	}

	//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, inout LinkedList!(ICanvasItem) hit_items = null )
	ICanvasItem[] enclosureList( double tx, double ty, inout ICanvasItem[] hit_items = null )
	{
		return enclosureList( tx, ty, tx, ty, hit_items );
	}

	/**
	* Returns a list of all the CanvasItems (Scenes, Tracks, Edits, EditHandles...) that the point tx,ty hits.
	* e.g. queryHit(15, 25, someEvent, new LinkedList!(CanvasItem) );
	*/
	//LinkedList!(ICanvasItem) enclosureList( double tx1, double ty1, double tx2, double ty2, inout LinkedList!(ICanvasItem) hit_items = null )//, inout LinkedList!(Node) hit_nodes )
	ICanvasItem[] enclosureList( double tx1, double ty1, double tx2, double ty2, inout ICanvasItem[] hit_items = null )//, inout LinkedList!(Node) hit_nodes )
	{
		debug(hitting) Trace.formatln("CanvasItemAbstract.recursiveGetHitItems() START. name: {}", name);

		//if( hit_items is null )
			//hit_items = new LinkedList!(ICanvasItem);
			//hit_items = new ICanvasItem[];

		//LinkedList!(ICanvasItem) my_hit_items = itemTree.enclosureList( xp2i(tx1), yp2i(ty1), xp2i(tx2), yp2i(ty1) );//, hit_nodes );
		//Deprecated//
		//LinkedList!(ICanvasItem) my_hit_items = itemTree.enclosureList( tx1, ty1, tx2, ty2 );//, hit_nodes );
		ICanvasItem[] my_hit_items = itemTree.enclosureList( tx1, ty1, tx2, ty2 );//, hit_nodes );

		//THIS scope LinkedList!(ICanvasItem) hit_lower = new LinkedList!(ICanvasItem);
		//scope LinkedList!(Node) hit_nodes_lower = new LinkedList!(Node);
		//Trace.formatln( "Hit items List:\n", hit_items.toString() );

		uint i = 0;
		foreach( ICanvasItem h; my_hit_items )
		{
			if(h !is null)
			{
				debug(hitting) Trace.formatln("CanvasItemAbstract.recursiveGetHitItems() myitem.name: {}{}{}", h.name, " i: ", i);
				i++;
				//hit_items.append( h );
				hit_items ~= h;
				//THIS h.enclosureList( xp2i(tx1), yp2i(ty1), xp2i(tx2), yp2i(ty2), hit_lower );
				//Deprecated//h.enclosureList( tx1, ty1, tx2, ty2, hit_lower );
			}
		}

		debug(hitting) Trace.formatln("CanvasItemAbstract.recursiveGetHitItems() name: {}{}{}", name, " has i hit myitems: ", i);

		/*THIS 
		foreach( ICanvasItem h; hit_lower )
		{
			if(h !is null)
			{
				hit_items.append( h );
			}
		}
		*/

		debug(hitting) Trace.formatln("CanvasItemAbstract.recursiveGetHitItems() END. name: {}", name);

		return hit_items;//this is also in inout LinkedList!(ICanvasItem) hit_items...

	}

	protected IRootWindow m_rootWindow;///This is a top level Window.
	public IRootWindow rootWindow(IRootWindow set)///Don't use this yourself.
	{
		m_rootWindow = set;
		//pickingID = m_rootWindow.nextPickingID();
		
		//Fix all the children to have the same rootWindow,
		//if they didn't already have it.
		if( m_itemList !is null )
			foreach(wid; itemList)
			{
				wid.rootWindow = set;
			}
		
		//Fix the scrollbars rootWindows too.
		if( verticalScrollbar !is null )
			verticalScrollbar.rootWindow = set;
		if( horizontalScrollbar !is null )
			horizontalScrollbar.rootWindow = set;
			
		return m_rootWindow;
	}
	public IRootWindow rootWindow() { return m_rootWindow; }///Don't use this yourself.
	
	public Rectangle parent() { return m_parent; }
	public Rectangle parent(Rectangle set) { return m_parent = set; }
	protected Rectangle m_parent;
	
	dchar[] type() { return m_type; }
	void type(dchar[] set) { m_type = set; }
	dchar[] m_type;
	
	///Call without any arguments to get the full name
	///of this widget in the form: parentname.parentname.name
	///This will make it easier to distinguish between similarly
	///named low level widgets.
	public dchar[] fullName(dchar[] recursive = "")
	{
		if( parent !is null )
			return parent.fullName( name ~ "." ~ recursive );
		//else
			return name ~ "." ~ recursive; 
	}
	
	public dchar[] fullType(dchar[] recursive = "")
	{
		if( parent !is null )
			return parent.fullType( type ~ "." ~ recursive );
		//else
			return type ~ "." ~ recursive; 
	}
	
	public dchar[] fullTypeAndName(dchar[] recursive = "")
	{
		if( parent !is null )
			return parent.fullTypeAndName( type ~ ":" ~ name ~ "." ~ recursive );
		//else
			return type ~ ":" ~ name ~ "." ~ recursive; 
	}
	
	//These are the child items (could be child widgets):
	public LinkedList!(Rectangle) itemList()
	{
		if( m_itemList is null )//Create on demand.
			m_itemList = new LinkedList!(Rectangle);
		return m_itemList;
	}
	protected LinkedList!(Rectangle) m_itemList;
	public RTree itemTree()
	{
		if( m_itemTree is null )//Create on demand.
			m_itemTree = new RTree();
		return m_itemTree;
	}
	protected RTree m_itemTree;
	
	//Returns the item which has the given type and name.
	Rectangle getItemByTypeAndName( dchar[] get_type, dchar[] get_name )
	{
		foreach( wid; itemList )
		{
			if( wid.type == get_type && wid.name == get_name )
			{
				return wid;
			}
		}
		return null;//not found
	}
	
	//Returns the first item with the given name.
	Rectangle getItemByName( dchar[] get_name )
	{
		foreach( wid; itemList )
		{
			if( wid.name == get_name )
			{
				return wid;
			}
		}
		return null;//not found
	}
	
	//This returns a list of those items with the desired type.
	LinkedList!(Rectangle) getItemListByType( dchar[] get_type )
	{
		auto result = new LinkedList!(Rectangle);
		foreach( wid; itemList )
		{
			if( wid.type == get_type )
			{
				result.append(wid);
			}
		}
		return result;
	}
	
	bool isEmpty()
	{
		if( m_itemList is null )
			return true;
		if( m_itemList.size == 0 )
			return true;
		return false;
	}
	
	//Animations and timing
	double frameTime()
	{
		if( rootWindow !is null )
			return rootWindow.frameTime();
		return 0.0f;//CHECK no movement will happen without
		//a rootWindow... Is that bad?
	}
	
	//REVIEW: It's propably stupid that idle() is called
	//by render only. So we only get animations updated
	//while rendering.
	//Again, suggestions for a better system would be great.
	void idle()
	{
		//There are animations running so we should
		//redraw to make them run.
		//Should this be moved to Animator? Maybe not.
		/*
		if(animator.size > 0)
		{
			//Trace.formatln("Animations pending.");
			invalidate();
		
		
			//Trace.formatln("Trying to get head().");
			Animator anim = animator.head();
			
			//Trace.formatln("Got anim head.");
			if( anim !is null && anim.animate() == false )
			{
				//Trace.formatln("removing anim.");
				anim.removeFromOwner();
			}
			
		}
		*/
		//Trace.formatln("ok anims.");
	
		
		//This is the version where we have multiple animations
		//running simultaneously.
		//For the time being we'll use the version where
		//only one animation can run at a time. Because it
		//is simpler.
		
		if(animator.size > 0)
		{
			debug(Animator) Trace.formatln("Rectangle.idle() Animations pending {}.", fullName );
			invalidate();
			
			scope LinkedList!(Animator) to_remove = new LinkedList!(Animator);
			
			//Animator removing would segfault, if we are removing the Animations from
			//a their own LinkedLists foreach. So we've settled it with two foreaches. Where
			//the second one will do the removing.
		
			debug(Animator) Trace.formatln("Rectangle.idle() Going to animate loop.");
			
			foreach(Animator anim; animator)
			{
				if( anim.animate() == false )
					to_remove.append(anim);
			}
			
			debug(Animator) Trace.formatln("Rectangle.idle() Going to remove animations loop.");
			
			foreach(Animator anim; to_remove)
			{
				anim.removeFromOwner();
			}
		}
		
		if( m_queueDelegatesVoid !is null && m_queueDelegatesVoid.size > 0 )
		{
			debug(queue) Trace.formatln("Going through queue void.");
			foreach( void delegate() dlg; m_queueDelegatesVoid )
			{
				dlg();
			}
		
			m_queueDelegatesVoid.clear();
		}
		
		if( m_queueDelegatesRectangle !is null && m_queueDelegatesRectangle.size > 0 && m_queueArgumentRectangles !is null && m_queueDelegatesRectangle.size == m_queueArgumentRectangles.size )
		{
			debug(queue) Trace.formatln("Going through queue Rectangle.");
			uint i = 0;
			foreach( void delegate(Rectangle) dlg; m_queueDelegatesRectangle )
			{
				dlg( m_queueArgumentRectangles.get(i) );
				i++;
			}
			
			m_queueDelegatesRectangle.clear();
			m_queueArgumentRectangles.clear();
		}
		
		//Call idles on children:
		if( m_itemList !is null )
			foreach(Rectangle wid; itemList)
			{
				wid.idle();
			}
		
		/*
		scope LinkedList!(Rectangle) to_remove_rect;
		
		if( m_itemList !is null )
			foreach(Rectangle wid; itemList)
			{
				if( wid.isMarkForRemove == true )
				{
					if( to_remove_rect is null )
						to_remove_rect = new LinkedList!(Rectangle);
					to_remove_rect.append(wid);
				}
				wid.idle();
			}
			
		if( to_remove_rect !is null )
		{
			foreach( Rectangle rect; to_remove_rect )
			{
				remove(rect);
			}
		}
		*/
		
	}
	
	public LinkedList!(Animator) animator()
	{
		if( m_animator is null )//Create on demand.
			m_animator = new LinkedList!(Animator);
		return m_animator;
	}
	protected LinkedList!(Animator) m_animator;
	
	void add( Animator set_anim )
	{
		//Trace.formatln("Added animation.");
		
		bool should_we_append = true;
		
		foreach( Animator anim; animator )
		{
			if( anim.combine(set_anim) == false )
			{
				should_we_append = false;
			}
		}
		
		if( should_we_append == true )
		{
			debug(Animator) Trace.formatln("Added animator to {}. {}", name, set_anim.toString() );
			
			animator.append(set_anim);
		}
		else
		{
			debug(Animator) Trace.formatln("Didn't add animator to {}.", name);
		}
		//else delete set_anim;
		
		invalidate();//redraw when a new animation is added
		//to get it started and running.
		
		//Temporary limit of 5 animations:
		/*if( animator.size < 5 )
		{
			animator.append( set_anim );
		}*/
	}
	
	void remove( Animator set_anim )
	{
		animator.remove( set_anim );
		debug(Animator) Trace.formatln("Removed animator. name: {}, animators.size: {}", name, animator.size );
		invalidate();//just in case this does something usefull.
	}
	
	bool hasAnimators()
	{
		if( animator.size > 0 )
			return true;
		//else
		return false;
	}
	
	void addDefaultAnimator( DefaultAnimator def_anim )
	{
		Animator to_add;
		BezierG1 to_path;
	
		switch( def_anim )
		{
			default:
			break;
			case DefaultAnimator.RAISE:
				to_path = new BezierG1();
				to_path.addPoint( 1.01f, 0.0f );//p
				to_path.addPoint( 1.03f, 0.0f );
				to_path.addPoint( 1.04f, 0.0f );
				to_path.addPoint( 1.05f, 0.0f );//p
				to_add = new Animator( this, &scale, null, null );
				to_add.path(to_path);
				add(to_add);
			break;
			case DefaultAnimator.LOWER:
				to_path = new BezierG1();
				to_path.addPoint( 1.04f, 0.0f );//p
				to_path.addPoint( 1.02f, 0.0f );
				to_path.addPoint( 1.01f, 0.0f );
				to_path.addPoint( 1.0f, 0.0f );//p
				/*
				to_path.addPoint( 0.01f, 0.0f );//p
				to_path.addPoint( 0.007f, 0.0f );
				to_path.addPoint( 0.003f, 0.0f );
				to_path.addPoint( 0.0f, 0.0f );//p
				*/
				to_add = new Animator( this, &scale, null, null );
				to_add.path(to_path);
				add(to_add);
			break;
			case DefaultAnimator.ROTATE_180:
				//yRotAnim(180.0f);
				
				to_path = new BezierG1();
				to_path.addPoint( 0.0f, 0.0f );//p
				to_path.addPoint( 20.0f, 0.0f );
				to_path.addPoint( 40.0f, 0.0f );
				to_path.addPoint( 60.0f, 0.0f );//p
				to_path.addPoint( 80.0f, 0.0f );
				to_path.addPoint( 100.0f, 0.0f );
				to_path.addPoint( 120.0f, 0.0f );//p
				to_path.addPoint( 140.0f, 0.0f );
				to_path.addPoint( 160.0f, 0.0f );
				to_path.addPoint( 180.0f, 0.0f );//p
				to_add = new Animator( this, &yRot, null, null );
				to_add.speed = 2.0;
				to_add.path(to_path);
				add(to_add);
				
			break;
			//This is kind of temporary until we get the
			//relative thing working with ROTATE_180.
			case DefaultAnimator.ROTATE_180_TO_360:
				//yRotAnim(360.0f);
			
				to_path = new BezierG1();
				to_path.addPoint( 180.0f, 0.0f );//p
				to_path.addPoint( 200.0f, 0.0f );
				to_path.addPoint( 220.0f, 0.0f );
				to_path.addPoint( 240.0f, 0.0f );//p
				to_path.addPoint( 260.0f, 0.0f );
				to_path.addPoint( 280.0f, 0.0f );
				to_path.addPoint( 300.0f, 0.0f );//p
				to_path.addPoint( 320.0f, 0.0f );
				to_path.addPoint( 340.0f, 0.0f );
				to_path.addPoint( 360.0f, 0.0f );//p
				to_add = new Animator( this, &yRot, null, null );
				to_add.speed = 2.0;
				to_add.path(to_path);
				add(to_add);
			
			break;
			case DefaultAnimator.ROTATE_360:
				to_path = new BezierG1();
				to_path.addPoint( 0.0f, 0.0f );//p
				to_path.addPoint( 30.5f, 0.0f );
				to_path.addPoint( 60.0f, 0.0f );
				to_path.addPoint( 90.0f, 0.0f );//p
				to_path.addPoint( 120.0f, 0.0f );
				to_path.addPoint( 150.0f, 0.0f );
				to_path.addPoint( 180.0f, 0.0f );//p
				to_path.addPoint( 210.0f, 0.0f );
				to_path.addPoint( 240.0f, 0.0f );
				to_path.addPoint( 270.0f, 0.0f );//p
				to_path.addPoint( 300.0f, 0.0f );
				to_path.addPoint( 330.0f, 0.0f );
				to_path.addPoint( 360.0f, 0.0f );//p
				to_add = new Animator( this, &yRot, null, null );
				to_add.path(to_path);
				add(to_add);
			break;
			
		}
	}
	
	char[] toString()
	{
		
		char[] ret = "\nSTART ";
		ret ~= Utf.toString(name);
		ret ~= "\nxPos: ";
		ret ~= Float.toString(xPos);
		ret ~= " yPos: ";
		ret ~= Float.toString(yPos);
		ret ~= " x: ";
		ret ~= Float.toString(x1);
		ret ~= " y: ";
		ret ~= Float.toString(y1);
		ret ~= " w: ";
		ret ~= Float.toString(w);
		ret ~= " h: ";
		ret ~= Float.toString(h);
		
		if( m_itemList !is null && itemList.size > 0 )
		{
			ret ~= "\nSTART CHILDREN\n";
		
			foreach(Rectangle w; itemList)
			{
				ret ~= w.toString();
			}
			
			ret ~= "\nEND CHILDREN\n";
		}
		
		ret ~= "\nEND " ~ Utf.toString(name);
		
		return ret;
	}
	
	void grabInput()
	{
		if( rootWindow !is null )
		{
			rootWindow.grabInputRootWindow( this );
		}
		else Trace.formatln("Can't grabInput because there is no root window.");
	}
	
	//return true if the ungrabbed widget was the same as the caller.
	//Will ungrab even if the widget is different.
	bool ungrabInput()
	{
		if( rootWindow !is null )
		{
			return rootWindow.ungrabInputRootWindow( this );
		}
		else Trace.formatln("Can't ungrabInput because there is no root window.");
		return false;
	}
	
	void grabKeyInput()
	{
		if( rootWindow !is null )
		{
			rootWindow.grabKeyInputRootWindow( this );
		}
		else Trace.formatln("Can't grabKeyInput because there is no root window.");
	}
	
	void ungrabKeyInput()
	{
		if( rootWindow !is null )
		{
			rootWindow.ungrabKeyInputRootWindow( this );
		}
		else Trace.formatln("Can't ungrabKeyInput because there is no root window.");
	}
	
	//NOT TRUE: Colour Memory. Prelight colour uses this to store the actual colour.
	float rMem() { return _colour_mem_data[0]; }
	float gMem() { return _colour_mem_data[1]; }
	float bMem() { return _colour_mem_data[2]; }
	float aMem() { return _colour_mem_data[3]; }
	
	float rMem( float set ) { return _colour_mem_data[0] = set; }
	float gMem( float set ) { return _colour_mem_data[1] = set; }
	float bMem( float set ) { return _colour_mem_data[2] = set; }
	float aMem( float set ) { return _colour_mem_data[3] = set; }
	
	void colourMem( float sr, float sg, float sb, float sa )
	{
		rMem = sr; gMem = sg; bMem = sb; aMem = sa;
	}

	void colourMem( float[] set )
	{
		if( set.length >= 4 )
		{
			rMem = set[0]; gMem = set[1]; bMem = set[2]; aMem = set[3];
		}
	}
	
	protected float[4] _colour_mem_data;
	
	/**
		If prelight is true, the widget will be drawn
		with a lighter colour. Usually used on enter-notify
		situations.
	*/
	bool prelight()
	{
		m_isPrelight = true;
		
		//colourMem( r, g, b, a );
		
		colourAnim( prelightColour.r, prelightColour.g, prelightColour.b, prelightColour.a );
		
		/*if( r > 0.8f )//If whitish...make darker.
		{
			colourAnim( 0.7f*r, 0.7f*g, 0.7f*b, a );
		}
		else //otherwise make lighter.
		{
			colourAnim( 1.3f*r, 1.3f*g, 1.3f*b, a );
		}*/
		
		invalidate();
		return m_isPrelight;
	}
	bool unprelight()
	{
		m_isPrelight = false;
		
		//colourAnim( rMem, gMem, bMem, aMem );
		colourAnim( mainColour.r, mainColour.g, mainColour.b, mainColour.a );
		
		invalidate();
		return m_isPrelight;
	}
	//CHECK rename to isPrelight? Or remove this from the API?
	//This is not really necessary as we have prelight() and
	//unprelight().
	bool prelight(bool set)
	{
		m_isPrelight = set;
		invalidate();
		return m_isPrelight;
	}
	bool m_isPrelight = false;
	
	
	/*protected uint nextPickingID()
	{
		throw new Exception("Called nextPickingID() on a widget that is not a toplevel window.");
		return 0;
	}*/
	
	/*REMOVE
	//internal
	protected void grabInputRootWindow( Rectangle set )
	{
		throw new Exception("Called grabInputRoot(Widget) on a widget that is not a toplevel window.");
	}
	//internal
	protected void ungrabInputRootWindow( Rectangle set )
	{
		throw new Exception("Called ungrabInputRoot(Widget) on a widget that is not a toplevel window.");
	}
	*/
	
	
	
	/*
	//We might need this at some point. I've left it out
	//for the time being. Should use xPos...
	void rectangle2canvas( inout CanvasItem tr )
	{
		//debug(7) Stdout("CanvasItemAbstract.x2c(.) START and END.\n");
		if(parent !is null)
			//return tr;
		//else
		{
			tr.x = tr_x2c( tr.x );
			tr.y = tr_y2c( tr.y );


			//return tr_x - parent.x2c( x );
		}
		//return tr_x - x;
		//return 0.0;
	}
	*/



	protected double xPos2c()//add all parents x:s, upto canvas... what to add to make it full canvas coordinates.
	{
		//debug(7) Stdout("CanvasItemAbstract.x2c(.) START and END.").newline;
		if(parent is null)
			return xPos;
		else return (parent.zoomX * xPos) + parent.moveScreenX + parent.xPos2c();
		//return tr_x - x;
		return 0.0;
	}

	protected double yPos2c()//add all parents x:s, upto canvas... what to add to make it full canvas coordinates.
	{
		//debug(7) Stdout("CanvasItemAbstract.x2c(.) START and END.\n");
		/*
		Trace.formatln("Rectangle.tr_yc2i() START and END.");
		Trace.formatln("fullName: {}", fullName );
		Trace.formatln("zoomX: {}", cast(double)zoomX );
		if( parent !is null )
		{
			Trace.formatln("parent.zoomX: {}", cast(double)parent.zoomX );
			Trace.formatln("parent.xPos2c: {}", cast(double)parent.xPos2c );
			Trace.formatln("parent.yPos2c: {}", cast(double)parent.yPos2c );
		}
		Trace.formatln("xPos: {}", cast(double)xPos );
		Trace.formatln("yPos: {}", cast(double)yPos );
		*/
		
		if(parent is null)
			return yPos;
		else return (parent.zoomY * yPos) + parent.moveScreenY + parent.yPos2c();
		//return tr_x - x;
		return 0.0;
	}
	
/+	

	//transform tr_x to canvas coordinates: use it like: edit0.x2c( edit0.x );
	public double tr_x2c( double tr_x )
	{
		//debug(7) Stdout("CanvasItemAbstract.tr_x2c(.) START and END.\n");
		if(parent is null)
			return tr_x;
		else return (tr_x + parent.xPos2c()) * parent.zoomX;
		//return tr_x - x;
		return 0.0;
	}
	
	

	//y to canvas coordinates: use it like: edit0.x2c( edit0.x );
	public double tr_y2c( double tr_y )
	{
		//debug(7) Stdout("CanvasItemAbstract.tr_y2c(.) START and END.\n");
		if(parent is null)
			return tr_y;
		else return (tr_y + parent.yPos2c()) * parent.zoomY;
		//return tr_y - y;
		return 0.0;
	}
	
	//From canvas to local coordinates...?
	public double tr_xc2i( double tr_x )
	{
		//Trace.formatln("Rectangle.tr_xc2i() START and END.");
		
		if(parent is null)
			return tr_x;
		else return ((tr_x - xPos2c()) * zoomMulX) - moveScreenX;
		//return tr_x - x;
		return 0.0;
	}
	
	public double tr_yc2i( double tr_y )
	{
	/*
		Trace.formatln("Rectangle.tr_yc2i() START and END.");
		Trace.formatln("fullName: {}", fullName );
		Trace.formatln("zoomX: {}", cast(double)zoomX );
		if( parent !is null )
			Trace.formatln("parent.zoomX: {}", cast(double)parent.zoomX );
		Trace.formatln("xPos: {}", cast(double)xPos );
		Trace.formatln("yPos: {}", cast(double)yPos );
		Trace.formatln("xPos2c: {}", cast(double)xPos2c );
		Trace.formatln("yPos2c: {}", cast(double)yPos2c );
	*/
		if(parent is null)
			return tr_y;
		else return ((tr_y - yPos2c()) * zoomMulY) - moveScreenY;
		//return tr_y - y;
		return 0.0;
	}
	
	protected float tr_wc2i(float tr_w)
	{
		if(parent is null)
			return tr_w;
		else return (parent.zoomMulX * tr_w);// + parent.xPos2c();
		return 0.0f;
	}
	
	protected float tr_hc2i(float tr_h)
	{
		if(parent is null)
			return tr_h;
		else return (parent.zoomMulY * tr_h);// + parent.xPos2c();
		return 0.0f;
	}
+/
	
	/*
	float tr_xc2i( float tr_set )
	{
		if( parent is null )
			return ((tr_set - xPos) * zoomMulX) - moveScreenX;
		//else
			return parent.tr_xc2i( ((tr_set - xPos) * zoomMulX) - moveScreenX );
	}
	
	float tr_yc2i( float tr_set )
	{
		if( parent is null )
			return ((tr_set - yPos) * zoomMulY) - moveScreenY;
		//else
			return parent.tr_yc2i( ((tr_set - yPos) * zoomMulY) - moveScreenY );
	}
	*/
	
	/*
	float tr_xc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set - moveScreenX) * zoomMulX;
		//else
			return parent.tr_xc2i( ((tr_set - moveScreenX) * zoomMulX) - parent.xPos );
	}
	
	float tr_yc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set - moveScreenY) * zoomMulY;
		//else
			return parent.tr_yc2i( ((tr_set - moveScreenY) * zoomMulY) - parent.yPos );
	}
	*/
	
	///skipParentZoomAndMoveScreen will tell all relevant methods that
	///this widget doesn't apply it's parent's zoom and moveScreen.
	///e.g. scrollbars skip them.
	public bool skipParentZoomAndMoveScreen() { return m_skipParentZoomAndMoveScreen; }
	public bool skipParentZoomAndMoveScreen(bool set) { return m_skipParentZoomAndMoveScreen = set; }
	protected bool m_skipParentZoomAndMoveScreen = false;
	
	/**
	* Coordinates, units, and explanations:
	*
	* 1. Units used in Rae
	*
	* Pixel-units. In pixels.
	* Height-units. The height of the screen is 1.0f.
	*
	*
	* 2. Coordinate jungle used in Rae
	*
	* 2.1: Canvas-coordinates are the coordinates of a toplevel window in height-units.
	* 2.2: Local-coordinates have all the parents xPosses, transformations (moveScreens) 
	* and zooms applied. This Rectangles xPos and yPos, w and h are on this level.
	* 2.3: (Should this level have some kind of a name.) Add xPos transformation
	* and we can draw this Rectangle. ix1, iy1, ix2, iy2, w and h are on this level.
	* 2.4: Item-coordinates. Apply this.zoom and this.moveScreens and we can start comparing
	* the positions of this.children[]. this.children[].xPos are in this level.
	* From the point of view of a particular child the item coordinates of it's parent,
	* are Local-coordinates of the particular child.
	*
	* How about these names (just a suggestion at the moment):
	* 1. toplevel-coordinates: t
	* 2. local-coordinates: l ; parent.local-coordinates: pl
	* 3. internal-coordinates: i
	* 4. child-coordinates: c
	*
	*/
	
	//Internal-coordinates to child-coordinates:
	//(These are equivalent to the old Pihlaja scx() methods.
	//Although in the current system these aren't used as
	//frequently.)
	float tr_x_i2c( float tr_set )
	{
		return (tr_set * zoomMulX) - moveScreenX;
	}
	
	float tr_y_i2c( float tr_set )
	{
		return (tr_set * zoomMulY) - moveScreenY;
	}
	
	float tr_w_i2c( float tr_set )
	{
		return (tr_set * zoomMulX);
	}
	
	float tr_h_i2c( float tr_set )
	{
		return (tr_set * zoomMulY);
	}
	
	
	//Internal-coordinates to local-coordinates:
	//This might be a bit unclear.
	//We have for example height of this Rectangle.
	//If it's 1.0f, it would be the size of the screen
	//if there was no zoom applied in it's parents.
	//But if there is zoom applied in it's parents,
	//then we must multiply the height with all
	//the parents zooms, starting from top.
	//The height is not however multiplied by this
	//Rectangles zoom, as that zoom is just for the
	//child objects.
	//The result is actually in top-level-coordinates.
	//I think.
	//Because we can draw with that height.
	
	//MAYBE rename to tr_w_i2t()
	
	//Recursive
	float tr_w_i2l( float tr_set )
	{
		if( parent is null )
			return tr_set;
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_w_i2l( tr_set ) * parent.zoomX;
		}
		else
		{
			return parent.tr_w_i2l( tr_set );
		}
	}
	
	//Recursive
	float tr_h_i2l( float tr_set )
	{
		if( parent is null )
			return tr_set;
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_h_i2l( tr_set ) * parent.zoomY;
		}
		else
		{
			return parent.tr_h_i2l( tr_set );
		}
	}
	
	
	
	
	//Toplevel-coordinates to child-coordinates:
	
	/**
	* tr_xc2i, tr_yc2i, tr_wc2i and tr_hc2i
	* Convert a canvas coordinate into this
	* objects item coordinates. The result can be used
	* to check against this items childrens locations: xPos, x1, x2, and w.
	* For example: you could have a mouse hit at mouse.x in the top Window.
	* Then you just call mouse.xLocal = thiswidget.tr_xc2i( mouse.x ) and you can check for
	* thiswidget.itemList[whatever].enclosure( mouse.xLocal, mouse.yLocal );
	*/
	
	//Recursive
	float tr_xc2i( float tr_set )
	{
		if( parent is null )
				return ((tr_set - xPos) * zoomMulX) - moveScreenX;
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return (((parent.tr_xc2i(tr_set) - xPos) * zoomMulX) - moveScreenX );
		}
		else
		{
			return (((parent.tr_xc2iSkipZoom(tr_set) - xPos) * zoomMulX) - moveScreenX );
		}
	}
	
	float tr_xc2iSkipZoom( float tr_set )
	{
		if( parent is null )
				return (tr_set - xPos);
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return (parent.tr_xc2i(tr_set) - xPos);
		}
		else
		{
			return (parent.tr_xc2iSkipZoom(tr_set) - xPos);
		}
	}
	
	//Recursive
	/*float tr_yc2i( float tr_set )
	{
		if( parent is null )
			return ((tr_set - yPos) * zoomMulY) - moveScreenY;
		//else
			return (((parent.tr_yc2i(tr_set) - yPos) * zoomMulY) - moveScreenY );
	}*/
	
	//Recursive
	float tr_yc2i( float tr_set )
	{
		if( parent is null )
				return ((tr_set - yPos) * zoomMulY) - moveScreenY;
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return (((parent.tr_yc2i(tr_set) - yPos) * zoomMulY) - moveScreenY );
		}
		else
		{
			return (((parent.tr_yc2iSkipZoom(tr_set) - yPos) * zoomMulY) - moveScreenY );
		}
	}
	
	float tr_yc2iSkipZoom( float tr_set )
	{
		if( parent is null )
				return (tr_set - yPos);
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return (parent.tr_yc2i(tr_set) - yPos);
		}
		else
		{
			return (parent.tr_yc2iSkipZoom(tr_set) - yPos);
		}
	}
	/*
	//Recursive
	float tr_hc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set * zoomMulX);
		//else
			return parent.tr_hc2i( tr_set ) * zoomMulX;
	}
	
	//Recursive
	float tr_wc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set * zoomMulY);
		//else
			return parent.tr_wc2i( tr_set ) * zoomMulY;
	}
	*/
	
	//Recursive
	float tr_wc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set * zoomMulX);
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_wc2i( tr_set ) * zoomMulX;
		}
		else
		{
			return parent.tr_wc2iSkipZoom( tr_set ) * zoomMulX;
		}
	}
	
	float tr_wc2iSkipZoom( float tr_set )
	{
		if( parent is null )
			return tr_set;
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_wc2i( tr_set );
		}
		else
		{
			return parent.tr_wc2iSkipZoom( tr_set );
		}
	}
	
	//Recursive
	float tr_hc2i( float tr_set )
	{
		if( parent is null )
			return (tr_set * zoomMulY);
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_hc2i( tr_set ) * zoomMulY;
		}
		else
		{
			return parent.tr_hc2iSkipZoom( tr_set ) * zoomMulY;
		}
	}
	
	float tr_hc2iSkipZoom( float tr_set )
	{
		if( parent is null )
			return (tr_set);
		//else
		if( skipParentZoomAndMoveScreen == false )
		{
			return parent.tr_hc2i( tr_set );
		}
		else
		{
			return parent.tr_hc2iSkipZoom( tr_set );
		}
	}
	
	//TODO make into property
	bool sendToTopOnMouseButtonPress = false;
	
	ICanvasItem lastHitWidget = null;//TODO Make this into property.
		
	bool keyEvent( InputState input )
	{
		return false;
	}
		
	//Returns true if the event was handled.
	//synchronized 
	override bool mouseEvent( InputState input, bool dive_lower = true )//THIS , bool bypass_hittest = false )
	{
		debug(mouse) Trace.formatln("Rectangle.mouseEvent() START. {}", fullName );
		debug(mouse) scope(exit) Trace.formatln("Rectangle.mouseEvent() END. {}", fullName );
	
		if( sendToTopOnMouseButtonPress == true )
		{
			switch( input.eventType )
			{
				default:
				break;
				case SEventType.MOUSE_BUTTON_PRESS:
					sendToTop();
				break;
			}
		}
	
		debug(mouse)
		{
			Trace.formatln("mouse x: {}, y: {}", cast(double) input.mouse.x, cast(double) input.mouse.y );
		}
	
		//input.mouse.xLocal = xp2i( input.mouse.xLocal );
		//input.mouse.yLocal = yp2i( input.mouse.yLocal );
		input.mouse.xLocal = tr_xc2i( input.mouse.x );
		input.mouse.yLocal = tr_yc2i( input.mouse.y );
		input.mouse.xRelLocal = tr_wc2i( input.mouse.xRel );
		input.mouse.yRelLocal = tr_hc2i( input.mouse.yRel );
			
		debug(mouseclick)
		{
			if( input.eventType == SEventType.MOUSE_BUTTON_PRESS )
			{
				Trace.formatln("mouseclick {} x: {}, y: {}", fullName, cast(double) input.mouse.x, cast(double) input.mouse.y );
			}
		}	
		
			/*
		Trace.formatln("fullName: {}", fullName );
				Trace.formatln("m.x: {}", cast(double)input.mouse.x );
				Trace.formatln("m.y: {}", cast(double)input.mouse.y );
				Trace.formatln("zoomX: {}", cast(double)zoomX );
				if( parent !is null )
					Trace.formatln("parent.zoomX: {}", cast(double)parent.zoomX );
				Trace.formatln("xPos: {}", cast(double)xPos );
				Trace.formatln("yPos: {}", cast(double)yPos );
				Trace.formatln("xPos2c: {}", cast(double)xPos2c );
				Trace.formatln("yPos2c: {}", cast(double)yPos2c );
				Trace.formatln("x1: {}", cast(double)x1 );
				Trace.formatln("y1: {}", cast(double)y1 );
				Trace.formatln("x2: {}", cast(double)x2 );
				Trace.formatln("y2: {}", cast(double)y2 );
				Trace.formatln("m.xLocal: {}", cast(double)input.mouse.xLocal );
				Trace.formatln("m.yLocal: {}", cast(double)input.mouse.yLocal );
				Trace.formatln("ix1: {}", cast(double)ix1 );
				Trace.formatln("iy1: {}", cast(double)iy1 );
				Trace.formatln("ix2: {}", cast(double)ix2 );
				Trace.formatln("iy2: {}", cast(double)iy2 );
			*/
		
		
		bool was_handled = false;
		
		if( dive_lower == true )
		{
		
				debug(mouse) Trace.formatln("Rectangle.mouseEvent() before enclosureList {}", fullName );
		
				//scope LinkedList!(ICanvasItem) hit_items = new LinkedList!(ICanvasItem);
				scope ICanvasItem[] hit_items;// = new LinkedList!(ICanvasItem);
				//hit_items = 
				enclosureList( input.mouse.xLocal, input.mouse.yLocal, hit_items );
				
				debug(mouse) Trace.formatln("Rectangle.mouseEvent() after enclosureList {}", fullName );
				
				//HACKish: take away the zoom and moveScreen because
				//the scrollbars don't have them applied...
				float xLocalWithoutZoom = 0.0f;
				float yLocalWithoutZoom = 0.0f;
				//if( parent !is null )
				//{
					//xLocalWithoutZoom = parent.tr_xc2i( input.mouse.x );
					//yLocalWithoutZoom = parent.tr_yc2i( input.mouse.y );
					xLocalWithoutZoom = (input.mouse.xLocal + moveScreenX) * zoomX;
					yLocalWithoutZoom = (input.mouse.yLocal + moveScreenY) * zoomY;
				//}
				
				if( hasVerticalScrollbar == true && verticalScrollbar !is null && verticalScrollbar.enclosure(xLocalWithoutZoom, yLocalWithoutZoom) == true )
				{
					debug(mouse) Trace.formatln("Hit verticalScrollbar.");
					//hit_items.append( verticalScrollbar );
					hit_items ~= verticalScrollbar;
				}
				
				if( hasHorizontalScrollbar == true && horizontalScrollbar !is null && horizontalScrollbar.enclosure(xLocalWithoutZoom, yLocalWithoutZoom) == true )
				{
					debug(mouse) Trace.formatln("Hit horizontalScrollbar.");
					//hit_items.append( horizontalScrollbar );
					hit_items ~= horizontalScrollbar;
				}
				
				//if( hit_items !is null && hit_items.size() != 0 )
				if( hit_items !is null && hit_items.length != 0 )
				{
					debug(mouse) Trace.formatln("Rectangle.mouseEvent() we hit something. {}", fullName );
				
					/*
					foreach( ICanvasItem hit; hit_items )
					{
						Trace.formatln("window event hit: {}", hit.name );
					}
					*/
				
					//We want the hit item with the lowest zOrder.
					//0 is the topmost zOrder.
					//ICanvasItem top_hit = hit_items.tail();
					//ICanvasItem top_hit = hit_items[hit_items.length-1];
					ICanvasItem top_hit;
					//if( hit_items !is null && hit_items.length > 0 ) top_hit = hit_items[0];
					if( hit_items !is null && hit_items.length > 0 ) top_hit = hit_items[hit_items.length-1];
					
					debug(mouse) Trace.formatln("top_hit zOrder: {} {}", top_hit.name, top_hit.zOrder );
					foreach( ICanvasItem it; hit_items )
					{
						debug(mouse) Trace.formatln("zOrder: {} {}", it.name, it.zOrder );
						if( it.zOrder < top_hit.zOrder )
						{
							debug(mouse) Trace.formatln("this is topper z {} {} than {} {}.", it.name, it.zOrder, top_hit.name, top_hit.zOrder );
							top_hit = it;
						}
					}
					
					if( lastHitWidget !is top_hit )
					{
						//store the current event.
						SEventType temp_event_type = input.eventType;
						bool temp_is_handled = input.isHandled;
						
						if( lastHitWidget !is null )
						{
							/*
							if( hit_items.contains(lastHitWidget) )
							{
							
							}
							else
							{
							*/
								//notify the lastHitWidget that the pointer has left it.
								input.eventType = SEventType.LEAVE_NOTIFY;
								//lastHitWidget.mouseEvent( input );//THIS , true );
								lastHitWidget.onLeaveNotify( input );
							//}
						}
						//notify the new hit widget that the pointer has entered it.
						input.eventType = SEventType.ENTER_NOTIFY;
						//top_hit.mouseEvent( input );//THIS , true );
						top_hit.onEnterNotify( input );
						//restore the current event.
						input.eventType = temp_event_type;
						input.isHandled = temp_is_handled;
					
					}
					
					//Mark the current top_hit as the lastHitWidget.
					lastHitWidget = top_hit;
					//Send the actual event.
					was_handled = top_hit.mouseEvent( input );//THIS , true );
				}
				else //we didn't hit anything
				{
					if( lastHitWidget !is null )
					{
						//store the current event.
						SEventType temp_event_type = input.eventType;
						bool temp_is_handled = input.isHandled;
						//notify the lastHitWidget that the pointer has left it.
						input.eventType = SEventType.LEAVE_NOTIFY;
						//lastHitWidget.mouseEvent( input );//THIS , true );
						lastHitWidget.onLeaveNotify( input );
						//restore the current event
						input.eventType = temp_event_type;
						input.isHandled = temp_is_handled;
						lastHitWidget = null;
					}
				}
		}//dive_lower
				
		debug(mouse) Trace.formatln("Rectangle.mouseEvent() After all checks. {}", fullName );
	
		//Check if we did hit this widget
		//THIS if( bypass_hittest || enclosure( input.mouse.x, input.mouse.y ) )
		//THIS {
			//Trace.formatln("mouse: {}", name );
		
			//bool did_hit = false;
			/*THIS 
			if( bypass_hittest == false )
			{
			 	//Check if we hit any of the child widgets.
				foreach( Rectangle wid; itemList )
				{
					if( wid.mouseEvent( input ) )
						return true;//If we hit a child return true.
						//did_hit = true;
				}
			}
			*/
			
			
		
			//If we hit a child return true.
			//if( did_hit == true )
			//	return did_hit;
			//else
			//{
				//Trace.formatln("Widget {} {} {}", name, " is hit! ", toString() );
				
			//if any of the child widgets handled the event,
			//then we don't need to handle it anymore.
			if( was_handled == false )
			{
				debug(mouse) Trace.formatln("Rectangle.mouseEvent() The event wasn't handled by the child widgets. Trying this {}", fullName );
			
				switch( input.eventType )
				{
					default:
					break;
					case SEventType.MOUSE_BUTTON_PRESS:
						was_handled = onMouseButtonPress( input );
					break;
					case SEventType.MOUSE_BUTTON_RELEASE:
						was_handled = onMouseButtonRelease( input );
					break;
					case SEventType.MOUSE_MOTION:
						was_handled = onMouseMotion( input );
					break;
					case SEventType.SCROLL_UP:
						was_handled = onScrollUp( input );
					break;
					case SEventType.SCROLL_DOWN:
						was_handled = onScrollDown( input );
					break;
					/*case SEventType.ENTER_NOTIFY:
						was_handled = onEnterNotify( input );
					break;
					case SEventType.LEAVE_NOTIFY:
						was_handled = onLeaveNotify( input );
					break;*/
				}
			}
			//}
		//THIS }
		//else Trace.formatln("Widget {} {} {}", name, " is NOT hit. ", toString());

		debug(mouse)
		{
			if( was_handled == true )
				Trace.formatln("Rectangle.mouseEvent() Event handled by {}", fullName );
		}
		
		return was_handled;
	}
	
	bool onMouseButtonPress( InputState input )
	{
		//Trace.formatln("onMouseButtonPress START. isHandled: {}", input.isHandled );
		signalMouseButtonPress.call(input, this);
		//Trace.formatln("onMouseButtonPress MID. isHandled: {}", input.isHandled );
		/*if( input.isHandled == false && parent !is null )
		{
			parent.onMouseButtonPress( input );
		}*/
		//Trace.formatln("onMouseButtonPress END. isHandled: {}", input.isHandled );
		//return true;
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalMouseButtonPress;
	
	bool onMouseButtonRelease( InputState input )
	{
		signalMouseButtonRelease.call(input, this);
		/*if( input.isHandled == false && parent !is null )
		{
			parent.onMouseButtonRelease( input );
		}*/
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalMouseButtonRelease;
	
	bool onMouseMotion( InputState input )
	{
		signalMouseMotion.call(input, this);
		/*if( input.isHandled == false && parent !is null )
		{
			parent.onMouseMotion( input );
		}*/
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalMouseMotion;
	
	//Signal!(EventType, InputState) signalMouse;//all mouse events
		//Signal!() signalMouseClicked;//also double or triple clicked		
		
		
		
	
	/*Signal!() signalKeyboard;//all keyboard events
		Signal!() signalKeyPress;
		Signal!() signalKeyRelease;*/
		
	bool onEnterNotify( InputState input )
	{
		signalEnterNotify.call(input, this);
		//EnterNotify and LeaveNotify don't bubble up.
		/*
		if( input.isHandled == false && parent !is null )
		{
			parent.onEnterNotify( input );
		}
		*/
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalEnterNotify;
	
	bool onLeaveNotify( InputState input )
	{
		signalLeaveNotify.call(input, this);
		
		//We must sink down inorder to clear the
		//lastHitWidgets and their lastHitWidgets
		//and so on. Otherwise there might be situations
		//where they don't recieve their leave_notifys.
		//e.g. when the mouse is moving really fast.
		if( lastHitWidget !is null )
		{
			lastHitWidget.onLeaveNotify( input );
			lastHitWidget = null;
		}
		
		//EnterNotify and LeaveNotify don't bubble up.
		/*
		if( input.isHandled == false && parent !is null )
		{
			parent.onLeaveNotify( input );
		}
		*/
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalLeaveNotify;
	
	bool onScrollUp( InputState input )
	{
		signalScrollUp.call(input, this);
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalScrollUp;
	
	bool onScrollDown( InputState input )
	{
		signalScrollDown.call(input, this);
		return input.isHandled;
	}
	Signal!(InputState, Rectangle) signalScrollDown;
	
	
	
	void defaultMouseHandler( InputState input, Rectangle wid )
	{
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				input.isHandled = true;
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				input.isHandled = true;
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				if( input.mouse.eventButton == MouseButton.MIDDLE )
				{
					input.isHandled = true;
					wid.grabInput();
				}
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				if( input.mouse.eventButton == MouseButton.MIDDLE )
				{
					input.isHandled = true;
					wid.ungrabInput();
				}
			break;
			case SEventType.MOUSE_MOTION:
				if( input.mouse.button[MouseButton.MIDDLE] == true )
				{
					input.isHandled = true;
					wid.moveScreen( input.mouse.xRelLocal, input.mouse.yRelLocal );
				}
			break;
			case SEventType.SCROLL_UP:
				input.isHandled = true;
				wid.zoomAnim = wid.zoomX + wid.zoomAdder;
			break;
			case SEventType.SCROLL_DOWN:
				input.isHandled = true;
				wid.zoomAnim = wid.zoomX - wid.zoomAdder;
			break;
		}
	}
	
	void defaultScrollMouseHandler( InputState input, Rectangle wid )
	{
		switch( input.eventType )
		{
			default:
			break;
			/*case SEventType.ENTER_NOTIFY:
				input.isHandled = true;
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				input.isHandled = true;
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				if( input.mouse.eventButton == MouseButton.MIDDLE )
				{
					input.isHandled = true;
					wid.grabInput();
				}
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				if( input.mouse.eventButton == MouseButton.MIDDLE )
				{
					input.isHandled = true;
					wid.ungrabInput();
				}
			break;
			case SEventType.MOUSE_MOTION:
				if( input.mouse.button[MouseButton.MIDDLE] == true )
				{
					input.isHandled = true;
					wid.moveScreen( input.mouse.xRelLocal, input.mouse.yRelLocal );
				}
			break;
			*/
			case SEventType.SCROLL_UP:
				//Trace.formatln("FileChooser ScrollUp.");
				input.isHandled = true;
				//wid.yPosAnim = wid.yPos - 0.01f;
				if( verticalScrollbar !is null )
				{
					Animator to_anim = new Animator(this, &verticalScrollbar.slider.value, &verticalScrollbar.slider.value, null, null, null, null, null );
					to_anim.animateRelativeTo( -0.02f * input.mouse.amount, 0.0f, 0.0f );
					add(to_anim);
				}
			break;
			case SEventType.SCROLL_DOWN:
				//Trace.formatln("FileChooser ScrollDown.");
				input.isHandled = true;
				//wid.yPosAnim = wid.yPos + 0.01f;
				if( verticalScrollbar !is null )
				{
					Animator to_anim = new Animator(this, &verticalScrollbar.slider.value, &verticalScrollbar.slider.value, null, null, null, null, null );
					to_anim.animateRelativeTo( -0.02f * input.mouse.amount, 0.0f, 0.0f );
					add(to_anim);
				}
			break;
		}
	}
	
	/+
	void defaultMouseMoveHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		
		/*
		switch( input.eventType )
		{
			default:
			break;
			
			case SEventType.ENTER_NOTIFY:
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				wid.grabInput();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				wid.ungrabInput();
			break;
			case SEventType.SCROLL_UP:
				wid.zoomAnim = wid.zoomX + wid.zoomAdder;
			break;
			case SEventType.SCROLL_DOWN:
				wid.zoomAnim = wid.zoomX - wid.zoomAdder;
			break;
		}
		
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			if( wid.parent !is null )
				wid.move( wid.parent.tr_wc2i( input.mouse.xRel ), wid.parent.tr_hc2i( input.mouse.yRel ) );
		}
		*/
		
		if( input.mouse.button[MouseButton.MIDDLE] == true )
		{
				wid.moveScreen( input.mouse.xRelLocal, input.mouse.yRelLocal );
		}
	}
	+/
	
	
	
	
		
	//TODO Maybe we should make a class WidgetList
	//which has the zOrder checking built in
	//append and prepend, remove etc...!
	//internal
	void checkZOrder()
	{
		if( m_itemList is null )//So we don't crash when there are no items.
			return;
	
		//The last element will have the "highest" zOrder
		//which is 0. That is closest to the camera.
		
		int zassign = itemList.size-1;
		/*
		foreach(Rectangle wid; itemList)
		{
			wid.zOrder = zassign;
			zassign--;
		}*/
		
		//Here we give each element a zOrder based
		//on it's layer and position in the itemList.
		//The last element will have the "highest" zOrder
		//which is 0. That is closest to the camera.
		//Unless it's on higher layer than others.
		
		uint widget_count = 0;
		//We'll start the rendering from the layer 5000.
		int min_layer = 5000;
		int max_layer = int.max;
		int suggested_next_layer = 0;
		
		while( widget_count < itemList.size )
		{
			foreach(Rectangle wid; itemList)
			{
				//if( wid.isFBO == false )
				//if( wid.isClipByParent == true )
				
				if( wid.layer <= max_layer )//ignore those who are already handled. Those are bigger than max_layer.
				{
					if( wid.layer >= min_layer )//this widgets layer falls inbetween min_layer and max_layer, so we render it.
					{
						widget_count++;//add widget count, so we keep track when we have rendered all the layers.
						//wid.render(draw);
						//zordered_items ~= wid;
						wid.zOrder = zassign;
						zassign--;
					}
					else if( suggested_next_layer < wid.layer )//this widget is still unhandled but it's layer is bigger than
					//our suggested_next_layer. So we'll make that our suggested_next_layer instead.
					//suggested_next_layer will thus be the highest number we haven't yet handled.
					{
						suggested_next_layer = wid.layer;
					}
				}
			}
			//Then we move on. This is done with the min_layer and max_layer variables.
			max_layer = min_layer - 1;//The first time around this will be 4999, so that's our upper limit now.
			min_layer = suggested_next_layer;//And this will be the highest num yet to be handled.
			suggested_next_layer = 0;//And then we need to zero this, so that we'll get a valid number next time.
		}
	}
	
	/**
	* Bring this widget to be the topmost widget
	* in it's container. It will then have the
	* zOrder of 0.
	*/
	void sendToTop()
	{
		debug(Widget) Trace.formatln("Widget.sendToTop() START.");
		debug(Widget) scope(exit) Trace.formatln("Widget.sendToTop() STOP.");
		
		if( parent !is null )
		{
			parent.sendToTop(this);
		}
	}
	
	/**
	* Bring this widget to be the lowest widget
	* in it's container.
	*/
	void sendToBottom()
	{
		debug(Widget) Trace.formatln("Widget.sendToBottom() START.");
		debug(Widget) scope(exit) Trace.formatln("Widget.sendToBottom() STOP.");
		
		if( parent !is null )
		{
			parent.sendToBottom(this);
		}
	}
	
	/**
	* Bring a widget to be the topmost widget
	* in this container. It will then have the
	* zOrder of 0.
	*/
	void sendToTop( Rectangle wid )
	{
		debug(Widget) Trace.formatln("Widget.sendToTop(Widget) START.");
		debug(Widget) scope(exit) Trace.formatln("Widget.sendToTop(Widget) STOP.");
		
		if( m_itemList is null )
			return;//We should not have any items.
		
		if( itemList.contains( wid ) == true )
		{
			//add(wid);//Currently this will first remove it
			//and then add it as the topmost widget.
			
			//instead of add() we now remove wid from
			//itemList, and put it back there in the back.
			//everything else stays the same.
			//This way it will also get drawn last
			//and therefore be the topmost drawn
			//object since we're not doing any
			//Z-buffering.
			itemList.remove(wid);
			itemList.append(wid);
			//arrange();
			checkZOrder();
			//wid.zOrder = 0;
			
			//This is just stupid I guess.
			//We'll check for duplicate 0's.
			//And then if those are found then
			//we'll +1 all other zOrders than wid.
			/*
			bool duplicate_zero_found = false;
			foreach( Rectangle r; itemList )
			{
				if( r !is wid && r.zOrder == 0 )
					duplicate_zero_found = true;
			}
			
			if( duplicate_zero_found == true )
			{
				foreach( Rectangle r; itemList )
				{
					if( r !is wid )
						r.zOrder = r.zOrder + 1;
				}
			}
			*/
			
			invalidate();
		}
	}
	
	/**
	* Bring this widget to be the lowest widget
	* in it's container.
	*/
	void sendToBottom( Rectangle wid )
	{
		debug(Widget) Trace.formatln("Widget.sendToBottom(Widget) START.");
		debug(Widget) scope(exit) Trace.formatln("Widget.sendToBottom(Widget) STOP.");
		
		if( m_itemList is null )
			return;//We should not have any items.
		
		if( itemList.contains( wid ) == true )
		{
			itemList.remove(wid);
			itemList.prepend(wid);//Add to beginning.
			//arrange();
			checkZOrder();
			invalidate();
		}
	}
	
	
	
	/**
	* Add a child widget to this widget that will
	* act as a container. A widget can only be inside
	* one widget at a time. If added to another
	* widget it will be removed from the first one.
	*/
	void add( Rectangle a_widget )
	{
		debug(Rectangle) Trace.formatln("Rectangle.add(r) START.");
		debug(Rectangle) scope(exit) Trace.formatln("Rectangle.add(r) END.");
		
		//append(a_widget);
		if( a_widget.parent !is null )
			a_widget.parent.remove( a_widget );
		a_widget.parent = this;
		if( rootWindow !is null )
			a_widget.rootWindow = rootWindow;
			
		debug(Rectangle) Trace.formatln("Rectangle.add(r) itemList.append()");
		itemList.append( a_widget );//Add to the end.
		debug(Rectangle) Trace.formatln("Rectangle.add(r) itemTree.append()");
		itemTree.append( a_widget );
		
		debug(Rectangle) Trace.formatln("Rectangle.add(r) calling arrange()");
		
		if( parent !is null )
			parent.arrange();
		else
			arrange();
		
		debug(Rectangle) Trace.formatln("Rectangle.add(r) setting followAlpha.");
		
		//Copy the followAlpha setting to the new child.
		if( followAlpha !is null )
			a_widget.followAlpha = followAlpha;
			
		debug(Rectangle) Trace.formatln("Rectangle.add(r) calling afterAdd.");
		
		a_widget.afterAdd();
		invalidate();
	}
	
	void append( Rectangle a_widget )
	{
		if( a_widget.parent !is null )
			a_widget.parent.remove( a_widget );
		a_widget.parent = this;
		if( rootWindow !is null )
			a_widget.rootWindow = rootWindow;
		itemList.append( a_widget );//Add to the end.
		itemTree.append( a_widget );
		
		if( parent !is null )
			parent.arrange();
		else
			arrange();
		
		//Copy the followAlpha setting to the new child.
		if( followAlpha !is null )
			a_widget.followAlpha = followAlpha;
		
		a_widget.afterAdd();
		invalidate();
	}
	
	void prepend( Rectangle a_widget )
	{
		if( a_widget.parent !is null )
			a_widget.parent.remove( a_widget );
		a_widget.parent = this;
		if( rootWindow !is null )
			a_widget.rootWindow = rootWindow;
		itemList.prepend( a_widget );//Add to the start.
		itemTree.append( a_widget );
		
		if( parent !is null )
			parent.arrange();
		else
			arrange();
		
		//Copy the followAlpha setting to the new child.
		if( followAlpha !is null )
			a_widget.followAlpha = followAlpha;
		
		a_widget.afterAdd();
		invalidate();
	}
	
	///Override this to do something when this widget is added to another.
	void afterAdd()
	{
	
	}
	
	/**
	* Remove a child widget.
	*/
	void remove( Rectangle a_widget )
	{
		Trace.formatln("Trying to remove {} from {}.", a_widget.name, name() );
	
		if( a_widget.parent !is this )
		{
			Trace.formatln("The Rectangle that we tried to remove isn't in this Container.");
			return;
		}
	
		Trace.formatln("Removing from itemList.");
		itemList.remove( a_widget );
		Trace.formatln("Removing from RTree.");
		itemTree.remove( a_widget );
		
		Trace.formatln("Removing done. Cleaning up.");
		
		a_widget.parent = null;
		a_widget.rootWindow = null;
		
		Trace.formatln("Removing - arrange.");
		if( parent !is null )
			parent.arrange();
		else
			arrange();
		
		Trace.formatln("Removing - invalidate.");
		invalidate();
	}
	
	/**
	* Remove all child Rectangles from this Rectangle.
	*/
	void clear()
	{
		debug(Rectangle) Trace.formatln("Clearing {}.", name );
	
		foreach( Rectangle rect; itemList )
		{
			rect.parent = null;
			rect.rootWindow = null;
		}
		
		if( m_itemList !is null )
			itemList.clear();
		if( m_itemTree !is null )
		{
			//Hmm. This is a bit stupid, but since there isn't
			//any clear method available in RTree class, so
			//we'll just delete it and create a new one.
			//TODO make RTree have a clear method.
			delete m_itemTree;
			//m_itemTree = new RTree();//Created on demand now.
		}
		
		if( parent !is null )
			parent.arrange();
		else
			arrange();
			
		invalidate();
	}
	
	void queue( void delegate() set )
	{
		if( m_queueDelegatesVoid is null ) m_queueDelegatesVoid = new LinkedList!(void delegate());
		m_queueDelegatesVoid.append( set );
	}
	protected LinkedList!(void delegate()) m_queueDelegatesVoid;
	
	void queue( void delegate(Rectangle) set, Rectangle set_argument )
	{
		if( m_queueDelegatesRectangle is null ) m_queueDelegatesRectangle = new LinkedList!(void delegate(Rectangle));
		m_queueDelegatesRectangle.append( set );
		if( m_queueArgumentRectangles is null ) m_queueArgumentRectangles = new LinkedList!(Rectangle);
		m_queueArgumentRectangles.append( set_argument );
	}
	protected LinkedList!(void delegate(Rectangle)) m_queueDelegatesRectangle;
	protected LinkedList!(Rectangle) m_queueArgumentRectangles;
	
	/+
	void queueAdd()
	{
	
	}
	
	/**
	* Use markForRemove() to remove it in the next idle() run.
	*/
	void queueRemoveFromParent() { isQueueRemoveFromParent = true; }
	
	protected bool isQueueRemoveFromParent() { return m_isQueueRemoveFromParent; }
	protected void isQueueRemoveFromParent(bool set) { m_isQueueRemoveFromParent = set; }
	protected bool m_isQueueRemoveFromParent = false;
	
	/**
	* Use markForClear() to clear in the next idle() run.
	*/
	void queueClear()
	{
		foreach( Rectangle rect; itemList )
		{
			rect.queueRemoveFromParent();
		}
	}
	+/
	
	/**
	* Remove this widget from it's parent if it has one.
	*/
	void removeFromParent()
	{
		if( parent !is null )
		{
			parent.remove(this);
		}
	}
	
	
	/**
	* Padding is the area that is left in between widgets.
	* inPadding is the amount that this
	* widget pads it's children.
	* outPadding is the amount which this widget
	* puts in between itself and the parent widget.
	* In other words:
	* inPadding == childPadding
	* outPadding == thisWidgetsOwnPadding
	* This terminology is derived from the fact
	* that the children of this widget are inside -> in.
	* and the parent widget is outside -> out.
	* The padding types are further separated into the
	* X and Y axis.
	*/
	
	public float inPaddingX() { return m_inPaddingX; }
	public void inPaddingX(float set) { m_inPaddingX = set; }
	protected float m_inPaddingX = 0.0f;
	
	public float inPaddingY() { return m_inPaddingY; }
	public void inPaddingY(float set) { m_inPaddingY = set; }
	protected float m_inPaddingY = 0.0f;
	
	public float outPaddingX() { return m_outPaddingX; }
	public void outPaddingX(float set) { m_outPaddingX = set; }
	protected float m_outPaddingX = 0.0f;
	
	public float outPaddingY() { return m_outPaddingY; }
	public void outPaddingY(float set) { m_outPaddingY = set; }
	protected float m_outPaddingY = 0.0f;
	
	
	
	//I believe the Anchor system was superseded
	//by AlignType. So Anchor is propably deprecated...
	//Anchor NOT USED AT THE MOMENT:
	/*
	public void anchor() { return m_anchor; }
	public void anchor(Anchor set) { return m_anchor = set; }
	protected Anchor m_anchor = Anchor.TOP_LEFT;
	*/
	
	/*
	//This is the public API of hiding and showing.
	//NOT TRUE AT THE MOMENT:
	//Toplevel Windows are hidden by default
	//other widgets are shown by default.
	public void show() { isHidden = false; }
	public void hide() { isHidden = true; }
	
	//The programmer can only query isHidden.
	//Direct manipulation of it is protected.
	//Use show() and hide() instead.
	public bool isHidden() { return m_isHidden; }
	protected bool isHidden(bool set) { return m_isHidden = set; }
	protected bool m_isHidden = false;
	*/
	//Internal:
	public override bool isHidden() { return m_isHidden; }
	protected override void isHidden(bool set)
	{
		
		debug(followalpha) 
		{
			if( followAlpha !is null )
			{
				Trace.formatln("followAlpha is {}", followAlpha.fullTypeAndName() );
				Trace.formatln("followalpha is something." );
			}
			else Trace.formatln("no followAlpha. its null." );
		}
		
	
		if( followAlpha !is this )
		{
			isHiddenReal( set );
		}
		else
		{
			if( set == true )
			{
				debug(followalpha) Trace.formatln("add hide anim. {}", fullTypeAndName() );
				setFollowAlpha(true);
				aAnim( 0.0f, &hideReal );
				//aAnim( 0.5f );
			}
			else
			{
				debug(followalpha) Trace.formatln("add show anim. {}", fullTypeAndName() );
				showReal();
				setFollowAlpha(true);
				aAnim( 1.0f );//, &showReal );
			}
			invalidate();
		}
	}
	protected void isHiddenReal(bool set)
	{
		debug(followalpha) Trace.formatln("ishiddenreal. {}", fullTypeAndName() );
		m_isHidden = set;
		invalidate();
		if( parent !is null )
			parent.arrange();
		else
			arrange();
	}
	protected void showReal()
	{
		debug(followalpha) Trace.formatln("showreal.");
		m_isHidden = false;
		invalidate();
		if( parent !is null )
			parent.arrange();
		else
			arrange();
	}
	protected void hideReal()
	{
		debug(followalpha) Trace.formatln("hidereal.");
		m_isHidden = true;
		invalidate();
		if( parent !is null )
			parent.arrange();
		else
			arrange();
	}
	
	public void present()
	{
		show();
		sendToTop();
	}
	
	public AlignType alignType() { return m_alignType; }
	public AlignType alignType(AlignType set) { return m_alignType = set; }
	protected AlignType m_alignType = AlignType.CENTER;
	
	public void packOptions( PackOptions set_x, PackOptions set_y )
	{
		xPackOptions = set_x;
		yPackOptions = set_y;
	}
	
	public PackOptions xPackOptions() { return m_xPackOptions; };
	public void xPackOptions(PackOptions set) { m_xPackOptions = set; };
	protected PackOptions m_xPackOptions = PackOptions.EXPAND;
	
	public PackOptions yPackOptions() { return m_yPackOptions; };
	public void yPackOptions(PackOptions set) { m_yPackOptions = set; };
	protected PackOptions m_yPackOptions = PackOptions.EXPAND;
	
	public ArrangeType arrangeType() { return m_arrangeType; }
	public void arrangeType(ArrangeType set) { m_arrangeType = set; }
	protected ArrangeType m_arrangeType = ArrangeType.VBOX;
	
	//REMOVED: bool followsChildWidth = false;
	//REMOVED: bool followsChildHeight = false;
	
	/*
	REMOVE:
	public bool hasAutoScrollbars() { return m_hasAutoScrollbars; }
	public bool hasAutoScrollbars(bool set) { return m_hasAutoScrollbars = set; }
	protected bool m_hasAutoScrollbars = false;
	*/
	
	public ScrollbarSetting verticalScrollbarSetting() { return m_verticalScrollbarSetting; }
	public ScrollbarSetting verticalScrollbarSetting(ScrollbarSetting set)
	{
		if( set != m_verticalScrollbarSetting )
		{
			if( set == ScrollbarSetting.ALWAYS )
				hasVerticalScrollbar = true;
			else if( set == ScrollbarSetting.NEVER )
				hasVerticalScrollbar = false;
				
			m_verticalScrollbarSetting = set;
		}	
		return m_verticalScrollbarSetting;
	}
	protected ScrollbarSetting m_verticalScrollbarSetting = ScrollbarSetting.NEVER;
	
	public ScrollbarSetting horizontalScrollbarSetting() { return m_horizontalScrollbarSetting; }
	public ScrollbarSetting horizontalScrollbarSetting(ScrollbarSetting set)
	{
		if( set != m_horizontalScrollbarSetting )
		{
			if( set == ScrollbarSetting.ALWAYS )
				hasHorizontalScrollbar = true;
			else if( set == ScrollbarSetting.NEVER )
				hasHorizontalScrollbar = false;
				
			m_horizontalScrollbarSetting = set;
		}	
		return m_horizontalScrollbarSetting;
	}
	protected ScrollbarSetting m_horizontalScrollbarSetting = ScrollbarSetting.NEVER;
	
	public bool hasVerticalScrollbar() { return m_hasVerticalScrollbar; }
	protected bool hasVerticalScrollbar(bool set)
	{
		if( set == true && verticalScrollbar is null )
		{
			verticalScrollbar = new VScrollbar();
			//We must manually set the scrollbar parent
			//because the scrollbars aren't added to the RTree
			//itemTree. Setting the parent will make mouseEvent
			//coordinates work.
			//Setting the rootWindow will make grabInput work.
			verticalScrollbar.parent = this;
			if( rootWindow !is null )
				verticalScrollbar.rootWindow = rootWindow;
			
			//We set up a default behaviour. The scrollbar will
			//move the moveScreenY with an animation.
			verticalScrollbar.attach( &moveScreenY, &moveScreenYAnim, 0.0f, -1.0f );//It must be this way.
			//Because slider 0.0 is up or left, but moveScreen is other way around.
		}
		return m_hasVerticalScrollbar = set;
	}
	protected bool m_hasVerticalScrollbar = false;
	
	public bool hasHorizontalScrollbar() { return m_hasHorizontalScrollbar; }
	protected bool hasHorizontalScrollbar(bool set)
	{
		if( set == true && horizontalScrollbar is null )
		{
			horizontalScrollbar = new HScrollbar();
			//We must manually set the scrollbar parent
			//because the scrollbars aren't added to the RTree
			//itemTree. Setting the parent will make mouseEvent
			//coordinates work.
			//Setting the rootWindow will make grabInput work.
			horizontalScrollbar.parent = this;
			if( rootWindow !is null )
				horizontalScrollbar.rootWindow = rootWindow;
			
			//We set up a default behaviour. The scrollbar will
			//move the moveScreenX with an animation.
			horizontalScrollbar.attach( &moveScreenX, &moveScreenXAnim, 0.0f, -1.0f );//It must be this way.
			//Because slider 0.0 is up or left, but moveScreen is other way around.
		}
		return m_hasHorizontalScrollbar = set;
	}
	protected bool m_hasHorizontalScrollbar = false;
	
	HScrollbar horizontalScrollbar;
	VScrollbar verticalScrollbar;
	
	void maximizeChild(Rectangle tomax)
	{
		tomax.moveToAnim(0.0f, 0.0f, 0.0f);
		tomax.sizeAnim( w, h );
	}
	
	//Background is a way to use a custom
	//Rectangle as the background skin for this
	//Rectangle, without disturbing the arrangeType
	//etc.
	
	public Rectangle background() { return m_background; }
	public void background(Rectangle set)
	{
		m_background = set;
		if( m_background.parent !is null )
			m_background.parent.remove( m_background );
		m_background.parent = this;
		if( rootWindow !is null )
			m_background.rootWindow = rootWindow;
		
		if( followAlpha !is null )
			m_background.followAlpha = followAlpha;
		
		arrange();
		invalidate();
	}
	protected Rectangle m_background;
	
	
	
	
	
	//This is a trick to update the children in the
	//FBO only when the children or this one change.
	//The FBO is used as a cache for the state of this
	//Rectangles children.
	
	//synchronized 
	void invalidate()
	{
		debug(invalidate) Trace.formatln("Rectangle.invalidate() START.");
		debug(invalidate) scope(exit) Trace.formatln("Rectangle.invalidate() END.");
		
		childrenChanged = true;
		
		if( parent !is null )
			parent.invalidate();
		//Ok, this propably never happens. If a widget
		//has got a rootWindow it also has a parent.
		else if( rootWindow !is null )
			rootWindow.invalidate();
	}
	
	protected bool childrenChanged = true;
	
	
	//This is currently just awful design... Or is it?
	float childrenHeight()
	{
		float result = 0.0f;
		
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				
			break;
			case ArrangeType.LAYER:
			case ArrangeType.HBOX:
				//Find the biggest size:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						debug(arrange) Trace.formatln("wid.name: {} height: {}", wid.name, cast(double) wid.h );
						if( result < (wid.h + wid.outPaddingY*2.0f) )
							result = (wid.h + wid.outPaddingY*2.0f);
					}
			break;
			case ArrangeType.VBOX:
				//Add all sizes together:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						result = result + (wid.h + wid.outPaddingY*2.0f);
					}
			break;
		}
		
		if( result == 0.0f )
			return minHeight;//This propably makes no sense, but
			//currently it should work. As minHeight is set for
			//all Widgets.
			
		return result;
	}
	
	float childrenWidth()
	{
		float result = 0.0f;
		
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				
			break;
			case ArrangeType.HBOX:
				//Add all the sizes together:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						result = result + (wid.w + wid.outPaddingX*2.0f);
					}
			break;
			case ArrangeType.LAYER:
			case ArrangeType.VBOX:
				//Find the biggest size:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						//Trace.formatln("wid.name: {} height: {}", wid.name, cast(double) wid.h );
						if( result < (wid.w + wid.outPaddingX*2.0f) )
							result = (wid.w + wid.outPaddingX*2.0f);
					}
			break;
		}
		
		if( result == 0.0f )
			return minWidth;//This propably makes no sense, but
			//currently it should work. As minHeight is set for
			//all Widgets.
			
		return result;
	}
	
	float childrenDefaultHeight()
	{
		debug(arrange) Trace.formatln("Rectangle.childrenDefaultHeight() START." );
		debug(arrange) scope(exit) Trace.formatln("Rectangle.childrenDefaultHeight() END." );
	
		float result = 0.0f;
		
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				debug(arrange) Trace.formatln("Rectangle.childrenDefaultHeight() ArrangeType.FREE." );
			break;
			case ArrangeType.LAYER:
			case ArrangeType.HBOX:
				debug(arrange) Trace.formatln("Rectangle.childrenDefaultHeight() ArrangeType.LAYER or HBOX." );
				//Find the biggest size:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						//debug(arrange) Trace.formatln("wid.name: {} height: {}", wid.name, cast(double) wid.h );
						if( result < (wid.ifDefaultHeight + wid.outPaddingY*2.0f) )
							result = (wid.ifDefaultHeight + wid.outPaddingY*2.0f);
					}
			break;
			case ArrangeType.VBOX:
				debug(arrange) Trace.formatln("Rectangle.childrenDefaultHeight() ArrangeType.VBOX." );
				//Add all the sizes together:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						result = result + (wid.ifDefaultHeight + wid.outPaddingY*2.0f);
					}
			break;
		}
		
		//if( result == 0.0f )
		//	return 0.0f;//ifDefaultHeight;//This propably makes no sense, but
			//currently it should work. As minHeight is set for
			//all Widgets.
			
		return result;
	}
	
	float childrenDefaultWidth()
	{
		float result = 0.0f;
		
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				
			break;
			case ArrangeType.HBOX:
				//Add all the sizes together:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						result = result + (wid.ifDefaultWidth + wid.outPaddingX*2.0f);
					}
			break;
			case ArrangeType.LAYER:
			case ArrangeType.VBOX:
				//Find the biggest size:
				if( m_itemList !is null )
					foreach( Rectangle wid; itemList )
					{
						//Trace.formatln("wid.name: {} height: {}", wid.name, cast(double) wid.h );
						if( result < (wid.ifDefaultWidth + wid.outPaddingX*2.0f) )
							result = (wid.ifDefaultWidth + wid.outPaddingX*2.0f);
					}
			break;
		}
		
		//if( result == 0.0f )
		//	return 0.0f;//ifDefaultWidth;//This propably makes no sense, but
			//currently it should work. As minHeight is set for
			//all Widgets.
			
		return result;
	}
	
	
	protected void arrangeLayer( Rectangle wid, float use_width, float use_height )
		{
			//Trace.formatln("	ch: {}", wid.toString());
					debug(arrange) Trace.formatln("LAYER arrange processing: {}", wid.fullName );
					
					if( wid.yPackOptions == PackOptions.EXPAND )
					{
						//if( wid.hasMaxWidth == true && (use_width - (border*2.0)) > wid.maxWidth )
						if( wid.hasMaxHeight == true && (use_height - (wid.outPaddingY*2.0)) > wid.maxHeight )
							wid.hN = wid.maxHeight;//was wc()
						//else if( wid.hasMinWidth == true && (use_width - (border*2.0)) < wid.minWidth )
						else if( wid.hasMinHeight == true && (use_height - (wid.outPaddingY*2.0)) < wid.minHeight )
							wid.hN = wid.minHeight;//was wc()
						else
							//wid.wc = use_width - (border*2.0);
							wid.hN = use_height - (wid.outPaddingY*2.0);//was wc()
					}
					else if( wid.yPackOptions == PackOptions.SHRINK )
					{
						if( wid.ifDefaultHeight < use_height - (wid.outPaddingY*2.0) )
							wid.hN = wid.ifDefaultHeight;
						else wid.hN = use_height - (wid.outPaddingY*2.0);
					}
					
					if( wid.xPackOptions == PackOptions.EXPAND )
					{
						//if( wid.hasMaxWidth == true && (use_width - (border*2.0)) > wid.maxWidth )
						if( wid.hasMaxWidth == true && (use_width - (wid.outPaddingX*2.0)) > wid.maxWidth )
							wid.wN = wid.maxWidth;//was wc()
						//else if( wid.hasMinWidth == true && (use_width - (border*2.0)) < wid.minWidth )
						else if( wid.hasMinWidth == true && (use_width - (wid.outPaddingX*2.0)) < wid.minWidth )
							wid.wN = wid.minWidth;//was wc()
						else
							//wid.wc = use_width - (border*2.0);
							wid.wN = use_width - (wid.outPaddingX*2.0);//was wc()
					}
					else if( wid.yPackOptions == PackOptions.SHRINK )
					{
						if( wid.ifDefaultWidth < use_width - (wid.outPaddingX*2.0) )
							wid.wN = wid.ifDefaultWidth;
						else wid.wN = use_width - (wid.outPaddingX*2.0);
					}
					
						float centerposx;
						if( hasVerticalScrollbar == false )
							centerposx = 0.0f;
						else if( verticalScrollbar !is null )
							centerposx = -(verticalScrollbar.w*0.5f);
							
						float centerposy;
						if( hasHorizontalScrollbar == false )
							centerposy = 0.0f;
						else if( horizontalScrollbar !is null )
							centerposy = -(horizontalScrollbar.h*0.5f);
						
						switch( wid.alignType )
						{
							default:
							case AlignType.CENTER:
							case AlignType.TOP:
							case AlignType.BOTTOM:
								wid.xPosN = centerposx;
								wid.yPos = centerposy;
							break;
							case AlignType.BEGIN:
								//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO
									wid.moveTo( tr_x_i2c(ix1) - wid.ix1 + wid.outPaddingX, centerposy );//The ix1 transformed into the child-coordinates.
							break;
							case AlignType.END://UNTESTED.
								//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO
									wid.moveTo( tr_x_i2c(ix2) - wid.ix2 - wid.outPaddingX, centerposy );//The ix1 transformed into the child-coordinates.
							break;
						}
					
					wid.arrange();
					
		}
	
	
	
	
	
	void arrangeParent()
	{
	}
	
	//e.g. Scrollbar uses this
	//to store it's value before it's
	//w and h are changed by arrange.
	//Then it will later use those
	//values to get back to the same
	//value.
	//So, this is called on the
	//child by parent,
	//before the parent starts to do
	//any arranging of it's children.
	void beforeArrange()
	{
	}
	
	///This is propably the most important method of Rae.
	///It handles the arrangement of child widgets.
	///Things like VBOX are implemented here.
	///The implementation is quite bad though. It is slow and it doesn't allow for animations.
	void arrange()
	{
		debug(arrange) Trace.formatln("Rectangle.arrange() {} START.", fullTypeAndName() );
		debug(arrange) scope(exit) Trace.formatln("Rectangle.arrange() {} END.", fullTypeAndName() );
	
		if( m_itemList is null || m_itemList.size == 0 ) return;//So we don't crash when there's no items.
	
		foreach( Rectangle wid; itemList )
		{
			wid.beforeArrange();
		}
		
	
		checkZOrder();//This isn't entirely necessary on most		
		//ArrangeTypes. I think this is only needed on
		//ArrangeType.FREE. But I have it here for the time of testing.
		//And it doesn't really do any harm, so maybe it would be better
		//to leave it here for consistency...
		//On second thought, maybe we need it...
	
		debug(arrange) Trace.formatln("arrange() after checkZOrder." );
	
		//Ask parent about my size...
		//wx(defaultWidth);
		//hy(defaultHeight);

		float use_width = w;
		float use_height = h;
	
		debug(arrange) Trace.formatln("arrange() after use_width and use_height init." );
		
		if( verticalScrollbarSetting == ScrollbarSetting.ALWAYS )
		{
			hasVerticalScrollbar = true;//This isn't needed, but I guess it
			//won't do any harm.
			if( verticalScrollbar !is null )
			{
				use_width = use_width - verticalScrollbar.w;
			}
		}
		//If we already have moved the widgets somewhere with the moveScreen or zoom properties,
		//then we'll display scrollbars if they are in AUTO setting.
		else if( verticalScrollbarSetting == ScrollbarSetting.AUTO && (moveScreenY != 0.0f || zoom != 1.0f) )
		{
			hasVerticalScrollbar = true;
			if( verticalScrollbar !is null )
			{
				use_width = use_width - verticalScrollbar.w;
			}
		}
		
		if( horizontalScrollbarSetting == ScrollbarSetting.ALWAYS )
		{
			hasHorizontalScrollbar = true;//This isn't needed, but I guess it
			//won't do any harm.
			if( horizontalScrollbar !is null )
			{
				use_height = use_height - horizontalScrollbar.h;
			}
		}
		//If we already have moved the widgets somewhere with the moveScreen or zoom properties,
		//then we'll display scrollbars if they are in AUTO setting.
		else if( horizontalScrollbarSetting == ScrollbarSetting.AUTO && (moveScreenX != 0.0f || zoom != 1.0f) )
		{
			hasHorizontalScrollbar = true;
			if( horizontalScrollbar !is null )
			{
				use_height = use_height - horizontalScrollbar.h;
			}
		}
		
		/*
		if( followsChildWidth == true )
		{
			defaultWidthN = childrenDefaultWidth() + (inPaddingX*2.0f);
		}
		
		if( followsChildHeight == true )
		{
			defaultHeightN = childrenDefaultHeight() + (inPaddingY*2.0f);
		}
		*/
		
		
	
	
		if( background !is null )
		{
			arrangeLayer(background, use_width, use_height );
		}
		
		
	
	
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				debug(arrange) Trace.formatln("arrange() ArrangeType.FREE" );
				//When using the ArrangeType.FREE we don't do anything.
				//Except call arrange on all children.
				foreach( Rectangle wid; itemList )
				{
					wid.arrange();
				}
			break;
			
			case ArrangeType.LAYER:
				debug(arrange) Trace.formatln("arrange() ArrangeType.LAYER" );
				foreach( Rectangle wid; itemList )
				{
					arrangeLayer(wid, use_width, use_height );
				}
			break;
			
			case ArrangeType.HBOX:
			
				debug(arrange) Trace.formatln("ArrangeType.HBOX START fullName: {}", fullTypeAndName );
			
				float desired_width = 0.0f;
				float shrink_widgets_width = 0.0f;
				float minimal_expanded_width = 0.0f;
				float minimal_width = 0.0f;
				
				uint count_total = 0;
				uint count_expand = 0;
				uint count_shrink = 0;
				
				float width_left_for_expanded = 0.0f;//REMOVE?
				float width_left_for_shrinked = 0.0f;//REMOVE?
				bool enough_space = true;
				float temp_width_shared;
				
				float width_left_for_rest = use_width;
				float width_left_for_one = 0.0f;
				
				//TODO uint count_EXPAND_PADDING = 0;
				
				//void calculateWidthArrangeHelper()
				//{
					desired_width = 0.0f;
					shrink_widgets_width = 0.0f;
					minimal_expanded_width = 0.0f;
					minimal_width = 0.0f;
					
					count_expand = 0;
					count_shrink = 0;
					
					enough_space = true;
					
					
				
					foreach( Rectangle wid; itemList )
					{
						if( wid.isHidden == false )
						{
							count_total++;
							desired_width += wid.ifDefaultWidth + (wid.outPaddingX*2.0);
							
							if( wid.hasMinWidth == true )
							{
								minimal_width += wid.minWidth + (wid.outPaddingX*2.0);
							}
						
							if( wid.xPackOptions == PackOptions.EXPAND )
							{
								count_expand++;
								minimal_expanded_width += wid.ifDefaultWidth + (wid.outPaddingX*2.0);
								
							}
							else if( wid.xPackOptions == PackOptions.SHRINK )
							{
								count_shrink++;
								shrink_widgets_width += wid.ifDefaultWidth + (wid.outPaddingX*2.0);
								
								if( wid.hasMinWidth == true )
								{
									minimal_expanded_width += wid.minWidth + (wid.outPaddingX*2.0);
								}
							}
						}//if wid.isHidden == false
					}
				
					/*
					if( desired_height <= h )
					{
						//Enough space:
						float position_iter = iy1;
						
					}
					else
					{
					*/
						//Too little space:
					
						//float temp_height_shared = ((use_height - (border*(1.0f+child.size))) / child.size);
						//float temp_width_shared = (use_width / itemList.size);
						
						if( itemList !is null )//This could propably be removed.
						{
							temp_width_shared = (use_width / count_total);//itemList.size
						}
						else temp_width_shared = use_width;//And this could propably be removed, too.
						
						/*
						if( count_shrink > 0 && count_expand > 0 )
						{
							//we have both:
								width_left_for_expanded = use_width / 2.0f;
								width_left_for_shrinked = use_width / 2.0f;
						}
						else if( count_shrink > 0 )
						{
							//We only have shrinked:
							width_left_for_shrinked = use_width;
						}
						else if( count_expand > 0 )
						{
							//We only have expanded:
							width_left_for_expanded = use_width;
						}
						*/
						
						
						
						/*
						if( count_shrink > 0 && shrink_widgets_width > width_left_for_shrinked )
						{
							shrink_widgets_width = width_left_for_shrinked;
							enough_space = false;
						}
						*/
					
						width_left_for_rest = use_width - shrink_widgets_width;
						if( count_expand > 0 )
							width_left_for_one = width_left_for_rest / cast(float)count_expand;
						
						debug(arrange)
						{
							Trace.formatln("width_left_for_one {}", cast(double)width_left_for_one );
							Trace.formatln("count_expand: {}", count_expand );
							Trace.formatln("count_shrink: {}", count_shrink );
							Trace.formatln("width_left_for_rest: {}", cast(double)width_left_for_rest );
							Trace.formatln("shrink_widgets_width: {}", cast(double)shrink_widgets_width );
						}
						
						if( width_left_for_one < 0.0f )
						{
							width_left_for_one = 0.0f;
							enough_space = false;
						}
						
						if( shrink_widgets_width > use_width )
						{
							enough_space = false;
						}
					//}//end calculateWidthArrangeHelper()
					
					
					//calculateWidthArrangeHelper();
					
					if( enough_space == false )
					{
						if( horizontalScrollbarSetting == ScrollbarSetting.AUTO )
						{
							bool not_added_yet = false;
							if( hasHorizontalScrollbar == false )
							{
								not_added_yet = true;
							}
						
							hasHorizontalScrollbar = true;
							debug(arrange) Trace.formatln("We should add horizontal scrollbars. {}", name );
							
							if( not_added_yet == true && horizontalScrollbar !is null )
								use_height = use_height - horizontalScrollbar.h;
							
						}
						
						//Currently I'm not sure, under which circumstances this would happen
						//but in the end it might happen sometimes. So let's make the use_height
						//smaller if there is a horizontalScrollbar.
						if( hasVerticalScrollbar == true && verticalScrollbar !is null )
						{
							use_width = use_width - verticalScrollbar.w;
						}
					}
					else
					{
						//This is a bit messy code. Here we hide the scrollbar if on AUTO,
						//and if the moveScreenY or zoom hasn't been touched. This is a bit duplicated
						//from the beginning of arrange(). Where we show the scrollbar if on AUTO,
						//and if moveScreenY or zoom has been touched.
						if( horizontalScrollbarSetting == ScrollbarSetting.AUTO && moveScreenX < 0.0001f && moveScreenX > -0.0001f && zoom > 0.9999f && zoom < 1.0001f )
						{
							if( hasHorizontalScrollbar == true )
							{
								//	Trace.formatln("DANG DANG: moveScreenX: {}", moveScreenX );
								moveScreenX = 0.0f;
								zoom = 1.0f;
								hasHorizontalScrollbar = false;
							}
						}
					}
					
					
					float position_iter = ix1;
					/*WE WANT THIS:
					float position_iter;
					
					if( desired_width < use_width )
					{
						switch( alignType )
						{
							default:
							case AlignType.CENTER:
							case AlignType.TOP:
							case AlignType.BOTTOM:
							break;
							case AlignType.LEFT:
							case AlignType.BEGIN:
								position_iter = ix1;
							break;
							case AlignType.RIGHT:
							case AlignType.END:
								position_iter = ix1 + (use_width - desired_width);
							break;
						}
					}
					else position_iter = ix1;// + border;
					*/
					
					
					debug(arrange) Trace.formatln("w: {} ix1: {}", cast(double)use_width, cast(double)ix1);
				
					foreach( Rectangle wid; itemList )
					{
						if( wid.isHidden == false )
						{
							//Trace.formatln("	ch: {}", wid.toString());
							debug(arrange) Trace.formatln("arrange processing: {}", wid.fullName );
							
							float tentative_expand = width_left_for_one - (wid.outPaddingX*2.0f);
							
							if( wid.yPackOptions == PackOptions.EXPAND )
							{
								//if( wid.hasMaxWidth == true && (use_width - (border*2.0)) > wid.maxWidth )
								if( wid.hasMaxHeight == true && (use_height - (wid.outPaddingY*2.0)) > wid.maxHeight )
									wid.hN = wid.maxHeight;//was wc()
								//else if( wid.hasMinWidth == true && (use_width - (border*2.0)) < wid.minWidth )
								else if( wid.hasMinHeight == true && (use_height - (wid.outPaddingY*2.0)) < wid.minHeight )
									wid.hN = wid.minHeight;//was wc()
								else
									//wid.wc = use_width - (border*2.0);
									wid.hN = use_height - (wid.outPaddingY*2.0);//was wc()
							}
							else if( wid.yPackOptions == PackOptions.SHRINK )
							{
								if( wid.ifDefaultHeight < use_height - (wid.outPaddingY*2.0) )
									wid.hN = wid.ifDefaultHeight;
								else wid.hN = use_height - (wid.outPaddingY*2.0);
							}
							
							if( wid.xPackOptions == PackOptions.EXPAND )
							{
								debug(arrange) Trace.formatln("wid.xPackOptions == EXPAND.");
								
								if( wid.hasMaxWidth == true && tentative_expand > wid.maxWidth )
								{
									wid.wN = wid.maxWidth;//was hc()
									debug(arrange) Trace.formatln("wid.w {} set to w.maxWidth {}", cast(double)wid.w, cast(double)wid.maxWidth );
								}
								else if( wid.hasMinWidth == true && tentative_expand < wid.minWidth )
								{
									wid.wN = wid.minWidth;//was hc()
									debug(arrange) Trace.formatln("wid.w {} set to w.minWidth {}", cast(double)wid.w, cast(double)wid.minWidth );
								}
								else
								{
									//wid.hN = temp_height_shared;//was hc()
									wid.wN = tentative_expand;
									debug(arrange)
									{
										Trace.formatln("wid.w {} set to width_left_for_one {}", cast(double)wid.w, cast(double)width_left_for_one );
										Trace.formatln("count_expand: {}", count_expand );
										Trace.formatln("count_shrink: {}", count_shrink );
										Trace.formatln("width_left_for_rest: {}", cast(double)width_left_for_rest );
										Trace.formatln("shrink_widgets_width: {}", cast(double)shrink_widgets_width );
									}
								}
							}
							else if( wid.xPackOptions == PackOptions.SHRINK )
							{
								debug(arrange) Trace.formatln("wid.xPackOptions == SHRINK.");
								
								if( wid.ifDefaultWidth < use_width - (wid.outPaddingX*2.0) )
									wid.wN = wid.ifDefaultWidth;
								else wid.wN = use_width - (wid.outPaddingX*2.0);
								
							/*
								if( wid.hasMinWidth == true && temp_width_shared > wid.minWidth )
								{
									wid.wN = wid.minWidth;//was hc()
									debug(arrange) Trace.formatln("wid.w {} set to w.minWidth {}", cast(double)wid.w, cast(double)wid.minWidth );
								}	
								else if( wid.defaultWidth < temp_width_shared )
								{
									wid.wN = wid.defaultWidth;
									debug(arrange) Trace.formatln("wid.w {} set to w.defaultWidth {}", cast(double)wid.w, cast(double)wid.defaultWidth );
								}
								else
								{
									wid.wN = temp_width_shared;
									debug(arrange) Trace.formatln("wid.w {} set to temp_width_shared {}", cast(double)wid.w, cast(double)temp_width_shared );
								}
							*/
							}
							
							
								
								
							position_iter += wid.outPaddingX;//top padding. width.
							
							debug(arrange) Trace.formatln("position_iter_w before: {} wid.w: {}", cast(double)position_iter, cast(double)wid.w );
							
							/*
							if( hasHorizontalScrollbar == false )
								wid.yPos = 0.0f;
							else if( horizontalScrollbar !is null )
								wid.yPos = -(horizontalScrollbar.h*0.5f);
							wid.xPos = position_iter + (wid.w*0.5);
							//debug(Widget)
							debug(arrange) Trace.formatln("arrange() wid.x: {} {}", wid.name, cast(double)wid.xPos );
							*/
							
							float centerpos;
							
							if( hasHorizontalScrollbar == false )
								centerpos = 0.0f;
							else if( horizontalScrollbar !is null )
								centerpos = -(horizontalScrollbar.h*0.5f);
							
							switch( wid.alignType )
							{
								default:
								case AlignType.CENTER:
								case AlignType.TOP:
								case AlignType.BOTTOM:
									wid.yPosN = centerpos;
									wid.xPos = position_iter + (wid.w*0.5);
								break;
								case AlignType.LEFT:
								case AlignType.BEGIN:
									//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO
										wid.moveTo( position_iter + (wid.w*0.5), tr_y_i2c(iy1) - wid.iy1 + wid.outPaddingY );//The ix1 transformed into the child-coordinates.
								break;
								case AlignType.RIGHT:
								case AlignType.END://UNTESTED.
									//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO
										wid.moveTo( position_iter + (wid.w*0.5), tr_y_i2c(iy2) - wid.iy2 - wid.outPaddingY );//The ix1 transformed into the child-coordinates.
								break;
							}
							
							//position_iter += wid.h + border;
							position_iter += wid.w + wid.outPaddingX;//widget.h + bottom padding.
							
							debug(arrange) Trace.formatln("position_iter_w after: {}", cast(double)position_iter );
							
							wid.arrange();
							
							//assert(wid.w > 0.0f);
							
						}//if wid.isHidden == false	
					}
				//}
				
				debug(arrange) Trace.formatln("ArrangeType.HBOX END fullName: {}", fullName );
				
				/*if( itemList.size >= 2 )
				{
					
					assert(0);
				}*/
				
			break;
			case ArrangeType.VBOX:
			
				debug(arrange) Trace.formatln("arrange() ArrangeType.VBOX START fullName: {}", fullTypeAndName );
				
				float desired_height = 0.0f;
				float shrink_widgets_height = 0.0f;
				float minimal_expanded_height = 0.0f;
				float minimal_height = 0.0f;
				
				uint count_total = 0;
				uint count_expand = 0;
				uint count_shrink = 0;
				//TODO uint count_EXPAND_PADDING = 0;
				
				bool enough_space = true;
				float height_left_for_rest = use_height;
				float height_left_for_one = 0.0f;
					
				float temp_height_shared;
					
				//void calculateHeightArrangeHelper()
				//{
					debug(arrange) Trace.formatln("arrange() calculateHeightArrangeHelper()" );
					desired_height = 0.0f;
					shrink_widgets_height = 0.0f;
					minimal_expanded_height = 0.0f;
					minimal_height = 0.0f;
					
					count_expand = 0;
					count_shrink = 0;
					
					enough_space = true;
					
					debug(arrange) Trace.formatln("arrange() going to foreach itemList." );
					
					foreach( Rectangle wid; itemList )
					{
						debug(arrange) Trace.formatln("arrange() foreach wid: {}", wid.fullTypeAndName );
						if( wid.isHidden == false )
						{
							debug(arrange) Trace.formatln("arrange() wid is not hidden." );
							count_total++;
							debug(arrange) Trace.formatln("arrange() after count_total++." );
							desired_height += wid.ifDefaultHeight + (wid.outPaddingY*2.0);
							
							debug(arrange) Trace.formatln("arrange() checking hasMinHeight." );
							
							if( wid.hasMinHeight == true )
							{
								minimal_height += wid.minHeight + (wid.outPaddingY*2.0);
							}
							
							debug(arrange) Trace.formatln("arrange() Checking PackOptions." );
							
							if( wid.yPackOptions == PackOptions.EXPAND )
							{
								debug(arrange) Trace.formatln("arrange() PackOptions.EXPAND." );
								count_expand++;
								minimal_expanded_height += wid.ifDefaultHeight + (wid.outPaddingY*2.0);
								
							}
							else if( wid.yPackOptions == PackOptions.SHRINK )
							{
								debug(arrange) Trace.formatln("arrange() PackOptions.SHRINK." );
								count_shrink++;
								shrink_widgets_height += wid.ifDefaultHeight + (wid.outPaddingY*2.0);
								
								if( wid.hasMinHeight == true )
								{
									minimal_expanded_height += wid.minHeight + (wid.outPaddingY*2.0);
								}
							}
						} //if wid.isHidden == false
						else
						{
							debug(arrange) Trace.formatln("arrange() wid is hidden." );
						}
					}
				
					/*
					if( desired_height <= h )
					{
						//Enough space:
						float position_iter = iy1;
						
					}
					else
					{
					*/
						//Too little space:
						
						if( itemList !is null )
						{
							temp_height_shared = (use_height / count_total);//itemList.size);
						}
						else temp_height_shared = use_height;
						
						/*
						float height_left_for_expanded = 0.0f;
						float height_left_for_shrinked = 0.0f;
						
						
						if( count_shrink > 0 && count_expand > 0 )
						{
							//we have both:
								height_left_for_expanded = use_height / 2.0f;
								height_left_for_shrinked = use_height / 2.0f;
						}
						else if( count_shrink > 0 )
						{
							//We only have shrinked:
							height_left_for_shrinked = use_height;
						}
						else if( count_expand > 0 )
						{
							//We only have expanded:
							height_left_for_expanded = use_height;
						}*/
						
						/*if( count_shrink > 0 && shrink_widgets_height > height_left_for_shrinked )
						{
							shrink_widgets_height = height_left_for_shrinked;
							enough_space = false;
						}*/
					
						height_left_for_rest = use_height - shrink_widgets_height;
						if( count_expand > 0 )
							height_left_for_one = height_left_for_rest / cast(float)count_expand;
						
						debug(arrange)
						{
							Trace.formatln("height_left_for_one {}", cast(double)height_left_for_one );
							Trace.formatln("count_expand: {}", count_expand );
							Trace.formatln("count_shrink: {}", count_shrink );
							Trace.formatln("height_left_for_rest: {}", cast(double)height_left_for_rest );
							Trace.formatln("shrink_widgets_height: {}", cast(double)shrink_widgets_height );
						}
						
						if( height_left_for_one < 0.0f )
						{
							height_left_for_one = 0.0f;
							enough_space = false;
						}
						
						if( shrink_widgets_height > use_height )
						{
							enough_space = false;
						}
					//}//end calculateHeightArrangeHelper()
					
					//debug(arrange) Trace.formatln("arrange() Calling calculateHeightArrangeHelper()" );
					//calculateHeightArrangeHelper();
					
					debug(arrange) Trace.formatln("arrange() After calculateHeightArrangeHelper." );
					
					if( enough_space == false )
					{
						if( verticalScrollbarSetting == ScrollbarSetting.AUTO )
						{
							bool not_added_yet = false;
							if( hasVerticalScrollbar == false )
							{
								not_added_yet = true;
							}
							
							hasVerticalScrollbar = true;
							debug(arrange) Trace.formatln("We should add vertical scrollbars. {}", name );
							
							if( not_added_yet == true && verticalScrollbar !is null )
								use_width = use_width - verticalScrollbar.w;
							
						}
						
						//Currently I'm not sure, under which circumstances this would happen
						//but in the end it might happen sometimes. So let's make the use_height
						//smaller if there is a horizontalScrollbar.
						if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
						{
							use_height = use_height - horizontalScrollbar.h;
						}
					}
					else
					{
						//This is a bit messy code. Here we hide the scrollbar if on AUTO,
						//and if the moveScreenY or zoom hasn't been touched. This is a bit duplicated
						//from the beginning of arrange(). Where we show the scrollbar if on AUTO,
						//and if moveScreenY or zoom has been touched.
						if( verticalScrollbarSetting == ScrollbarSetting.AUTO && moveScreenY < 0.0001f && moveScreenY > -0.0001f && zoom > 0.9999f && zoom < 1.0001f )
						{
							if( hasVerticalScrollbar == true )
							{
								//Trace.formatln("Trying to remove verticalScrollbar. moveScreenY: {} fullname: {}", moveScreenY, fullName );
								moveScreenY = 0.0f;
								zoom = 1.0f;
								hasVerticalScrollbar = false;
							}
						}
						//else Trace.formatln("Fit. moveScreenY: {}", moveScreenY );
					}
				
					
					float position_iter = iy1;
					/*///WE WANT THIS:
					float position_iter;
					
					if( desired_height < use_height )
					{
						switch( alignType )
						{
							default:
							case AlignType.LEFT:
							case AlignType.BEGIN:
							case AlignType.RIGHT:
							case AlignType.END:
							case AlignType.CENTER:
							case AlignType.TOP:
								position_iter = iy1;
							break;
							case AlignType.BOTTOM:
								position_iter = iy1 + (use_height - desired_height);
							break;
						}
					}
					else position_iter = iy1;// + border;
					*/
					
					
					//float temp_height_shared = ((use_height - (border*(1.0f+child.size))) / child.size);
					
					/*float temp_height_shared;
					if( itemList !is null )
					{
						temp_height_shared = (use_height / itemList.size);
					}
					else temp_height_shared = use_height;
					*/
				
					foreach( Rectangle wid; itemList )
					{
						if( wid.isHidden == false )
						{
							//Trace.formatln("	ch: {}", wid.toString());
							
							float tentative_expand = height_left_for_one - (wid.outPaddingY*2.0f);
							
							if( wid.xPackOptions == PackOptions.EXPAND )
							{
								//if( wid.hasMaxWidth == true && (use_width - (border*2.0)) > wid.maxWidth )
								if( wid.hasMaxWidth == true && (use_width - (wid.outPaddingX*2.0)) > wid.maxWidth )
									wid.wN = wid.maxWidth;//was wc()
								//else if( wid.hasMinWidth == true && (use_width - (border*2.0)) < wid.minWidth )
								else if( wid.hasMinWidth == true && (use_width - (wid.outPaddingX*2.0)) < wid.minWidth )
									wid.wN = wid.minWidth;//was wc()
								else
									//wid.wc = use_width - (border*2.0);
									wid.wN = use_width - (wid.outPaddingX*2.0f);//was wc()
							}
							else if( wid.xPackOptions == PackOptions.SHRINK )
							{
								if( wid.ifDefaultWidth < use_width - (wid.outPaddingX*2.0) )
									wid.wN = wid.ifDefaultWidth;
								else wid.wN = use_width - (wid.outPaddingX*2.0);
							}
							
							
							if( wid.yPackOptions == PackOptions.EXPAND )
							{
								if( wid.hasMaxHeight == true && tentative_expand > wid.maxHeight )
									wid.hN = wid.maxHeight;//was hc()
								else if( wid.hasMinHeight == true && tentative_expand < wid.minHeight )
									wid.hN = wid.minHeight;//was hc()
								else
									//wid.hN = temp_height_shared;//was hc()
									wid.hN = tentative_expand;
							}
							else if( wid.yPackOptions == PackOptions.SHRINK )
							{
								if( wid.ifDefaultHeight < use_height - (wid.outPaddingY*2.0) )
									wid.hN = wid.ifDefaultHeight;
								else wid.hN = use_height - (wid.outPaddingY*2.0);
							}
							
							
							
							
								
								
							position_iter += wid.outPaddingY;//top padding. height.
							
							float centerpos;
							
							if( hasVerticalScrollbar == false )
								centerpos = 0.0f;
							else if( verticalScrollbar !is null )
								centerpos = -(verticalScrollbar.w*0.5f);
							
							switch( wid.alignType )
							{
								default:
								case AlignType.CENTER:
								case AlignType.TOP:
								case AlignType.BOTTOM:
									wid.xPosN = centerpos;
									wid.yPos = position_iter + (wid.h*0.5);
								break;
								case AlignType.BEGIN:
									//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO // 
										wid.moveTo( tr_x_i2c(ix1) - wid.ix1 + wid.outPaddingX, position_iter + (wid.h*0.5) );//The ix1 transformed into the child-coordinates.
								break;
								case AlignType.END://UNTESTED.
									//if( Rae.readingDirection == SomeEnum.RIGHT ) //TODO
										wid.moveTo( tr_x_i2c(ix2) - wid.ix2 - wid.outPaddingX, position_iter + (wid.h*0.5) );//The ix1 transformed into the child-coordinates.
								break;
							}
							
							
							debug(arrange) debug(Widget)Trace.formatln("arrange() wid.y: {} {}", wid.name, cast(double)wid.yPos );
							
							//position_iter += wid.h + border;
							position_iter += wid.h + wid.outPaddingY;//widget.h + bottom padding.
							
							wid.arrange();
						}//if wid.isHidden == false
					}
				//}
				
				debug(arrange) Trace.formatln("ArrangeType.VBOX END fullName: {}", fullName );
			break;
			
			
		}
		
		//Handle scrollbars for all arrangeTypes:
		
		if( hasVerticalScrollbar == true && verticalScrollbar !is null )
		{
				verticalScrollbar.xPosN = (w*0.5f) - (verticalScrollbar.w*0.5f);
				if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
				{
					verticalScrollbar.yPosN = -(horizontalScrollbar.h*0.5f);
					verticalScrollbar.hN = h - horizontalScrollbar.h;
				}
				else verticalScrollbar.hN = h;
				verticalScrollbar.arrange();
		}
		
		if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
		{
				horizontalScrollbar.yPos = (h*0.5f) - (horizontalScrollbar.h*0.5f);
				if( hasVerticalScrollbar == true && verticalScrollbar !is null )
				{
					horizontalScrollbar.xPosN = -(verticalScrollbar.w*0.5f);
					horizontalScrollbar.wN = w - verticalScrollbar.w;
				}
				else horizontalScrollbar.wN = w;	
				horizontalScrollbar.arrange();
		}
		
		/*foreach( Rectangle wid; itemList )
		{
			wid.arrange();
		}*/
		
		/*if( name == "MyWindow3" && itemList.size > 2 )
		{
			Trace.formatln(toString());
		
			//if( child[0].name == "TopHeader" && child[0].yPos != -0.06f )
			//{
			//	Trace.formatln("arrange() wid.yPos: {} {}", child[0].name, cast(double)child[0].yPos );
				//assert(0);
			//}
		}*/
		
		if( parent !is null )
			parent.arrangeParent();
			
		invalidate();
	}
	
	
	float pixel()
	{
		version(zoomCairo)
		{
			if( parent is null )
				return g_rae.pixel();
			//else
			if( skipParentZoomAndMoveScreen == false )
			{
				return parent.tr_hc2i( g_rae.pixel() );
			}
			//else
			return parent.tr_hc2iSkipZoom( g_rae.pixel() );
		}
		//version(zoomGL)
		else
		{
			return g_rae.pixel();
		}
	}
	
	//This is the width and height of a
	//one pixel. This will only work for
	//a gtk toplevel window, though.
	//TODO... rethink this.k
	//float pixel() { return 1.0f/h; }
	/*float rpixel()
	{
		if( rootWindow !is null )
			return rootWindow.pixel;
		//else
			return 0.00125f;//for h = 800.
	}
	*/
	
	//This returns and accepts Height coordinates
	/*float roundToPixels( float set )
	{
		return cast(float)(cast(int)( set / pixel )) * pixel;
	}*/
	
	public double tempclip = 0.0f;
	public double tempclip2 = 0.0f;
	
	protected void applyClipping()
	{
		if( isClipping == true )
		{
			glEnable(GL_STENCIL_TEST);
			
			glClearStencil(0);
			glClear(GL_STENCIL_BUFFER_BIT);
		
			glStencilFunc(GL_NEVER, 0x1, 0x1);
			glStencilOp(GL_INCR, GL_INCR, GL_INCR);
		
			glColor3f(1.0f, 1.0f, 1.0f);
		
			/*
			//This doesn't work anymore with GL_CCW?...
			glRectf(ix1,
						iy1,
						ix2,
						iy2);
			*/
			glBegin(GL_QUADS);
				glNormal3f(0.0f, 0.0f, 1.0f);
				glVertex3f(ix1, iy1, iz);
				glVertex3f(ix1, iy2, iz);
				glVertex3f(ix2, iy2, iz);
				glVertex3f(ix2, iy1, iz);
			glEnd();
						
		
			glStencilFunc(GL_EQUAL, 0x1, 0x1);
			glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		
			//Trace.formatln("clip: 1:{} 2:{}", cast(double)tempclip, cast(double)tempclip2 );
			//double[4] eq0 = [0.0f, -1.0, tempclip, tempclip2];
			
			//This was the best we got:
			/*
			glTranslatef( 0.0f, iy2, 0.0f );
				double[4] eq0 = [0.0f, -1.0f, 0.0f, y2];
				glClipPlane(GL_CLIP_PLANE0, eq0.ptr);
				glEnable(GL_CLIP_PLANE0);
			glTranslatef( 0.0f, -iy2, 0.0f );
			*/
			
			/*double[4] eq1 = [0.0f, iy2, 0.0f, 0.0f];
			glClipPlane(GL_CLIP_PLANE1, eq1.ptr);
			glEnable(GL_CLIP_PLANE1);
			
			double[4] eq2 = [ix1, 0.0f, 0.0f, 0.0f];
			glClipPlane(GL_CLIP_PLANE2, eq2.ptr);
			glEnable(GL_CLIP_PLANE2);
			
			double[4] eq3 = [ix2, 0.0f, 0.0f, 0.0f];
			glClipPlane(GL_CLIP_PLANE3, eq3.ptr);
			glEnable(GL_CLIP_PLANE3);*/
		}
	}
	
	protected void endClipping()
	{
		if( isClipping == true )
		{
			glDisable(GL_STENCIL_TEST);
			/*
			glDisable(GL_CLIP_PLANE0);
			glDisable(GL_CLIP_PLANE1);
			glDisable(GL_CLIP_PLANE2);
			glDisable(GL_CLIP_PLANE3);
			*/
		}
	}
	
	
	//FOLLOWALPHA
	
	//Here you can setfollowAlpha( true ). This is a mechanism,
	//that will make all child objects of this object
	//follow the alpha of this object.
	//You can turn it off by calling setFollowAlpha( false ) .
	public void setFollowAlpha( bool set )
	{
		if( set == true )
		{
			followAlpha( cast(Rectangle) this );
			//followAlphaChildren( this );
		}
		else
		{
			followAlpha( null );
			//followAlphaChildren( null );
		}
	}
	
	//protected void followAlpha( IColour set )
	//protected 
	void followAlpha( Rectangle set )
	{
		debug(followalpha)
		{
			if(set is null)
			{
				Trace.formatln("even set is null. Aaargh. {}", fullTypeAndName() );
			}
		}
		m_followAlpha = set;
		debug(followalpha)
		{
			if(m_followAlpha is null)
			{
				Trace.formatln("followAlpha doesn't work. {}", fullTypeAndName() );
			}
			else Trace.formatln("followAlpha works. OK. {}", fullTypeAndName() );
		}
		if( background !is null )
			background.followAlpha( set );
		if( hasVerticalScrollbar == true && verticalScrollbar !is null )
			verticalScrollbar.followAlpha( set );
		if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
			horizontalScrollbar.followAlpha( set );
		followAlphaChildren( set );
	}
	//protected IColour followAlpha() { return m_followAlpha; }
	protected Rectangle followAlpha() { return m_followAlpha; }
	//protected IColour m_followAlpha;
	protected Rectangle m_followAlpha;
	//protected void followAlphaChildren( IColour set )
	protected void followAlphaChildren( Rectangle set )
	{
		debug(followalpha) Trace.formatln("Rectangle.followAlphaChildren() START.");
		debug(followalpha) scope(exit) Trace.formatln("Rectangle.followAlphaChildren() END.");
		foreach( Rectangle rc; itemList )
		{
			rc.followAlpha( set );
		}
	}
	/*
	override float a()
	{
		if( followAlpha is null || followAlpha is this )
			return super.a();
		//else
			return followAlpha.a * super.a();
		
	}
	override void a( float set ) { super.a(set); }
	*/
	
	override protected void applyColour()
	{
		//After much hacking, I've come to the following hack:
		//If there is no texture we can just use the alpha value,
		//with the followAlpha, but if there is a texture
		//we must use all the values (rgba) with the followAlpha.
		//This is strange, but maybe it makes sense...
		//Well, it's an awful hack, as I don't seem to understand opengl
		//well enough, but atleast it works somewhat.
		if( texture is null )
		{
			if( followAlpha is null || followAlpha is this )
				glColor4f( r, g, b, a );
			else glColor4f( r, g, b, followAlpha.a * a );
		}
		else
		{
			if( followAlpha is null || followAlpha is this )
			glColor4f( r, g, b, a );
			else glColor4f( followAlpha.a * r, followAlpha.a * g, followAlpha.a * b, followAlpha.a * a );
		}
		/*
		}
		else if( r > 0.8f )//If whitish...make darker.
		{
			glColor4f( 0.7f*r, 0.7f*g, 0.7f*b, a );
		}
		else //otherwise make lighter.
		{
			glColor4f( 1.3f*r, 1.3f*g, 1.3f*b, a );
		}
		*/
	}
	
	override protected void applyOutlineColour()
	{
		if( followAlpha is null || followAlpha is this )
				glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
		else glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, followAlpha.a * outlineColour.a );
	}
	
	//Used in PlainRectangle for the shadow colour.
	override protected void applyShadowColour()
	{
		if( followAlpha is null || followAlpha is this )
			glColor4f(1.0f, 1.0f, 1.0f, a);
		else glColor4f(1.0f, 1.0f, 1.0f, followAlpha.a * a );
	}
	
	
	bool isFBO(bool set)
	{
		m_isFBO = set;
		if( set == true && framebufferObject is null )
		{
			framebufferObject = new Image(Image.FBO);
		}
		else if( framebufferObject !is null )
		{
			delete framebufferObject;
		}
		return m_isFBO;
	}
	bool isFBO() { return m_isFBO; }
	bool m_isFBO = false;
	
	protected Image framebufferObject;
	
	void renderChildrenFBO(Draw draw)
	{
		if( m_itemList is null || m_itemTree is null )
			return;
	
		//We only draw visible children.
		//We get those from the RTree.intersectionList()
		//scope LinkedList!(ICanvasItem) render_items = itemTree.intersectionList( tr_x_i2c(ix1), tr_y_i2c(iy1), tr_w_i2c(w), tr_h_i2c(h) );
		scope ICanvasItem[] render_items = itemTree.intersectionList( tr_x_i2c(ix1), tr_y_i2c(iy1), tr_w_i2c(w), tr_h_i2c(h) );
		
		//We don't need to do translation here in FBO?
		
		//if( render_items.size > 10 )
			//Trace.formatln("renderChildrenFBO. render_items.size: {}", render_items.size );
		
		//foreach(Rectangle wid; itemList)
		foreach(ICanvasItem wid; render_items)
		{
			//if( wid.isFBO == true )
				(cast(Rectangle)wid).renderFBO(draw);
		}
	}
	
	void renderFBO(Draw draw)
	{
		debug(FBO) Trace.formatln("Rectangle.renderFBO() {}", name );
		
		if( isFBO == false )
		{
			renderChildrenFBO(draw);
			return;
		}
		
		if( childrenChanged == true )
		{
			debug(FBO) Trace.formatln("Rectangle.renderFBO() {} childrenChanged == true", name );
			childrenChanged = false;
		
			//framebufferObject.rw = roundToPixels(w) / rpixel;
			//framebufferObject.rh = roundToPixels(h) / rpixel;
			framebufferObject.rw = tr_w_i2l(w) / pixel;
			framebufferObject.rh = tr_h_i2l(h) / pixel;
	
			framebufferObject.bounds(ix1, iy1, ix2, iy2);
			
			debug(FBO) Trace.formatln("Rectangle.renderFBO() {} going to renderChildrenFBO", name );
			renderChildrenFBO(draw);
			
			debug(FBO) Trace.formatln("Rectangle.renderFBO() {} going to push FBO", name );
			draw.pushFramebufferObject( framebufferObject );
			draw.FBONameDebug = Utf.toString(name);
			//framebufferObject.pushFramebufferObject(ix1, iy1, w, h);
			
			//We render this object too into the FBO:
				renderBody(draw);
			//
			
			debug(FBO) Trace.formatln("Rectangle.renderFBO() {} going to renderChildren.", name );
				renderChildren(draw);
			debug(FBO) Trace.formatln("Rectangle.renderFBO() {} going to pop FBO.", name );
			draw.popFramebufferObject();
			
			//renderChildrenNotClipped(draw);
		}
	}
	
	
	//Overridden just to add background.
	/*
	override void renderBody( Draw draw )
	{
		if( background !is null )
		{
			Trace.formatln("Render background. {}", fullName );
			background.render(draw);
		}
	
		super.renderBody(draw);
	}
	*/
	override void renderBypass( Draw draw )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.renderBypass() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.renderBypass() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
			
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//renderShadow(draw);
				
				if( background !is null )
				{
					//Trace.formatln("Render background. {}", fullName );
					background.render(draw);
				}
				
				//renderBody(draw);
					
				pushClipping(draw);
				
					renderChildren(draw);
					
					//renderChildrenNotClipped(draw);
					
				popClipping(draw);
					
		endRender(draw);//TEMP hack...
	}
	
	
	void render(Draw draw)
	{
		debug(FBO) Trace.formatln("PlainWindow.render() {}", name );
	
		if( isHidden == true )
			return;
	
		if( isFBO == false )
		{
			super.render(draw);
			return;
		}
	
		if( childrenChanged == true && draw.isFBOPushed == false )//&& parent.classinfo.name == "rae.ui.Window.Window" )
		{
			debug(FBO) Trace.formatln("PlainWindow.render() {} childrenChanged == true.", name );
			
			childrenChanged = false;
		
			//framebufferObject.rw = roundToPixels(w) / rpixel;
			//framebufferObject.rh = roundToPixels(h) / rpixel;
			//framebufferObject.rw = w / pixel;
			//framebufferObject.rh = h / pixel;
			framebufferObject.rw = tr_w_i2l(w) / pixel;
			framebufferObject.rh = tr_h_i2l(h) / pixel;
	
			framebufferObject.bounds(ix1, iy1, ix2, iy2);
			
			debug(FBO) Trace.formatln("PlainWindow.render() {} going to renderChildrenFBO.", name );
			//This will update childrens FBOs, if they have one.
			renderChildrenFBO(draw);
			debug(FBO) Trace.formatln("PlainWindow.render() {} did renderChildrenFBO.", name );
			
			debug(FBO) Trace.formatln("PlainWindow.render() {} going to push FBO.", name );
			draw.pushFramebufferObject( framebufferObject );
			draw.FBONameDebug = Utf.toString(name);
			
			//We render this object too into the FBO:
				renderBody(draw);
			//
			
			//framebufferObject.pushFramebufferObject(ix1, iy1, w, h);
				debug(FBO) Trace.formatln("PlainWindow.render() {} going to renderChildren.", name );
				//And this will actually draw the children, whether they are FBOs or not.
				renderChildren(draw);
			debug(FBO) Trace.formatln("PlainWindow.render() {} popping FBO.", name );
			draw.popFramebufferObject();
			
			//renderChildrenNotClipped(draw);
		}
	
	
		//And now that we've filled the FBO, either here,
		//or in renderFBO(), we use the FBO as a texture
		//and draw it into a rect in the main scene.
	
		/*glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			//applyColour();
		*/
			
		beginRender( draw );	
			
			renderShadow(draw);
			
			draw.pushTexture( framebufferObject );
				
				//Since this is an FBO, we always
				//render this as white:
				//glColor4f(r, g, b, a);
				glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
				//applyColour();
			
				shape.isTextureCoordsOne( false );
				shape.bounds( draw, ix1, iy1, ix2, iy2, iz);	
				
				shape.fill();
				//draw.fill( shape );
			
			//int maxCoordS = 1;
			//int maxCoordT = 1;
/*
			float maxCoordS = w / rpixel;//framebufferObject.width;
			float maxCoordT = h / rpixel;//framebufferObject.height;

				glColor3f(1.0, 1.0, 1.0);
				glBegin(GL_QUADS);
				{
						glTexCoord2f(0.0f, 0.0f);         glVertex2f(ix1, iy1);
						glTexCoord2f(0.0f, maxCoordT);         glVertex2f( ix1, iy2);
						glTexCoord2f(maxCoordS, maxCoordT); glVertex2f( ix2,  iy2);
						glTexCoord2f( maxCoordS, 0.0f); glVertex2f(ix2,  iy1);
				}
				glEnd();
*/
			draw.popTexture();

			if( isOutline && outlineColour !is null )
			{
				//TODO
				//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				//glColor4f(0.0f, 0.0f, 0.0f, a);
				//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
				applyOutlineColour();
				//draw.stroke( shape );
				shape.stroke();
			}
			
		endRender( draw );

			//Left and right shadow. Yes, I admit this shadow code is
			//really wierd, as it's divided into the header and this
			//window left and right parts. But, hey. It's a hack.
			//TODO think about this in some sane way, that will look
			//better and clearer.
			
			/*
			if( topHeader !is null )
			{
			
				float tophei = topHeader.h;
				float shad_wid = tophei * 0.5f;
				
				glBegin(GL_QUADS);
					//Left
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( ix1, iy1 + tophei , iz );
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( ix1, iy2 - tophei, iz );//Assumptions: topHeader has same height as bottomHeader.
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( ix1 - shad_wid, iy2 - tophei, iz );
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( ix1 - shad_wid, iy1 + tophei, iz );
					//Right
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( ix2 + shad_wid, iy1 + tophei, iz );
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( ix2 + shad_wid, iy2 - tophei, iz );
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( ix2, iy2 - tophei, iz );//Assumptions: topHeader has same height as bottomHeader.
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( ix2, iy1 + tophei , iz );
				glEnd();
			}
			*/
			
			//applyClipping();
				//renderChildren(draw);
			//endClipping();
		
		//glPopMatrix();
	}
	
	override void renderPixelPerPixel( Draw draw, float hard_tex_width, float hard_tex_height )
	{
		debug(PlainRectangle) Trace.formatln("Rectangle.renderPixelPerPixel() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("Rectangle.renderPixelPerPixel() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//TODO
				//glColor4f(r, g, b, a);
				applyColour();
 
 			
			//float hard_tex_width = 128.0f;
			//float hard_tex_height = 64.0f;
				
				//Normally: shape.bounds(ix1, iy1, ix2, iy2, iz);
			
			/+
			//version bounds:
			
				switch( alignType )
				{
					default:
					case AlignType.CENTER:
					case AlignType.TOP:
					case AlignType.BOTTOM:
						shape.bounds(
							draw,
						//draw.bounds( shape,
							//roundToPixels( 
							icx - (pixel*hard_tex_width*0.5f), 
							//roundToPixels( 
							icy - (pixel*hard_tex_height*0.5f),
							//roundToPixels( 
							icx + (pixel*hard_tex_width*0.5f),
							//roundToPixels( 
							icy + (pixel*hard_tex_height*0.5f),
							iz);
						
					break;
					case AlignType.BEGIN:
						shape.bounds(
							draw,
						//draw.bounds( shape,
							//roundToPixels( 
							ix1, 
							//roundToPixels( 
							icy - (pixel*hard_tex_height*0.5f),
							//roundToPixels( 
							ix1 + (pixel*hard_tex_width),
							//roundToPixels( 
							icy + (pixel*hard_tex_height*0.5f),
							iz);
						//draw.bounds( shape, ix1, iy1, ix2, iy2, iz );
					break;
				}
				
				shape.fill();
				//draw.fill( shape );
			+/
			
			//version renderPixels:
			
			shape.renderPixels( draw, renderMethod, icx, icy, ix1, iy1, ix2, iy2, iz );
			
			//This one is overridden in Label, because text textures are a bit messy
			//and they tend to grow big and get aligned funnily otherwise:
			
			/*
			switch( alignType )
				{
					default:
					case AlignType.CENTER:
					case AlignType.TOP:
					case AlignType.BOTTOM:
						shape.renderPixels( draw, renderMethod, icx, icy, ix1, iy1, ix2, iy2, iz );
					break;
					//case AlignType.END:
					case AlignType.BEGIN:
						shape.renderPixels( draw, renderMethod, ix1 + (g_rae.pixel*texture.width*0.5f), icy, ix1, iy1, ix2, iy2, iz );// - (texture.height*0.5f) );
						//shape.renderPixels(draw, icx, icy, iz);	
					break;
					case AlignType.END:
						shape.renderPixels( draw, renderMethod, ix2 - (g_rae.pixel*texture.width*0.5f), icy, ix1, iy1, ix2, iy2, iz );
						//shape.renderPixels(draw, ix2 - (*0.5f), icy);
					break;
				}
			*/	
				
			
			
			
			
			
			
			
			//draw.popTexture();
				
				if( isOutline && outlineColour !is null )
				{
					//TODO outlineColour...
					//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					//glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
					//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					applyOutlineColour();
					shape.stroke();
					//draw.stroke( shape );
				}
			
			//if( isClipping == true )
			//	draw.pushClipping(ix1, iy1, ix2, iy2, iz);
					
					renderChildren(draw);
					
		endRender(draw);//TEMP hack...
					
			//if( isClipping == true )
			//	draw.popClipping();
	}
	
	//Canvas child transformations:
	
	///moveScreenDelta will move the view, or the camera kind of.
	//RENAME to moveScreenDelta to remove confusion:
	void moveScreen( float delta_x, float delta_y )
	{
		m_moveScreenX += delta_x;
		m_moveScreenY += delta_y;
		invalidate();
	}
	void moveScreenN( float delta_x, float delta_y )
	{
		m_moveScreenX += delta_x;
		m_moveScreenY += delta_y;
		//invalidate();
	}
	/* REMOVE MAYBE:
	void moveScreenAnim( float to_x, float to_y )
	{
		Animator to_anim = new Animator(this, &moveScreenX, &moveScreenX, &moveScreenY, &moveScreenY, null, null, null );
		to_anim.animateTo( to_x, to_y, 0.0f );
		add(to_anim);
	}
	*/
	void moveScreenAnim( float to_x, float to_y, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &moveScreenX, &moveScreenX, &moveScreenY, &moveScreenY, null, null, set_when_finished );
		to_anim.animateTo( to_x, to_y, 0.0f );
		add(to_anim);
	}
	
	//moveScreenX
	public float moveScreenX() { return m_moveScreenX; }
	public void moveScreenX(float set)
	{
		m_moveScreenX = set;
		invalidate();
		//return m_moveScreenX;
	}
	public void moveScreenXN(float set)
	{
		m_moveScreenX = set;
		//invalidate();
		//return m_moveScreenX;
	}
	void moveScreenXAnim( float to_set )
	{
		Animator to_anim = new Animator(this, &moveScreenX, &moveScreenX, null, null, null, null, null );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_moveScreenX;
	}
	void moveScreenXAnim( float to_set, void delegate() set_when_finished )
	{
		Animator to_anim = new Animator(this, &moveScreenX, &moveScreenX, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_moveScreenX;
	}
	protected float m_moveScreenX = 0.0f;


	//moveScreenY
	public float moveScreenY() { return m_moveScreenY; }
	public void moveScreenY(float set)
	{
		m_moveScreenY = set;
		invalidate();
		//return m_moveScreenY;
	}
	public void moveScreenYN(float set)
	{
		m_moveScreenY = set;
		//invalidate();
		//return m_moveScreenY;
	}
	void moveScreenYAnim( float to_set )
	{
		Animator to_anim = new Animator(this, &moveScreenY, &moveScreenY, null, null, null, null, null );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_moveScreenY;
	}
	void moveScreenYAnim( float to_set, void delegate() set_when_finished )
	{
		Animator to_anim = new Animator(this, &moveScreenY, &moveScreenY, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_moveScreenY;
	}
	protected float m_moveScreenY = 0.0f;
	
	
	version(zoomCairo)
	{
		//called by parent when it's zoom changes. This is becoming
		//a nasty HACK.
		protected void updateThemeTexture()
		{
			if( shape !is null )
			{
				//WRONG WAY: shape.updateThemeTexture( parent.tr_wc2i(w), parent.tr_hc2i(h) );
				shape.updateThemeTexture( tr_w_i2l(w), tr_h_i2l(h) );
			}
				
			updateShadowTexture();
			
			if( m_itemList !is null )
				foreach(Rectangle rect; itemList)
				{
					rect.updateThemeTexture();
				}
		}
	}
	
	//zoom
	
	public void zoomIn()
	{
		zoomAnim = zoom + zoomAdder;
	}
	
	public void zoomOut()
	{
		zoomAnim = zoom - zoomAdder;
	}
	
	public void zoomReset()
	{
		zoomAnim(1.0f);
	}
	
	//We use m_zoomY for general zoom, because we use height for 1.0f in
	//other places. For consistency.
	//The programmer should basically just use either
	//(zoom) OR (zoomX && zoomY). Not both together. Maybe.
	public float zoom() { return m_zoomY; }
	public float zoomMul() { return m_zoomMulY; }
	public float zoomParent()
	{
		return tr_h_i2l(1.0f);
	}
	
	public void zoom(float set)
	{
		//Stdout("zoom: ")(set).newline;
		
		if( set <= 0.2 )
		{
			zoomAdder = 0.01;
		}
		else if( set > 0.2 )
		{
			zoomAdder = 0.1;
		}
	
		if( set <= 0.01 )
		{
			//This is just a quick fix for a situation when one
			//gets lost.
			set = 0.01;
			moveScreenXAnim = 0.0;//center.
			moveScreenYAnim = 0.0;
		}
		/*
		else if( set > 1.0f )
		{
			//and a new fix to disallow zooming in...
			//until it's fixed and not pixellated.
			set = 1.0f;
		}*/
			
		zoomX = set;
		zoomY = set;//TODO change this relatively, so that the aspect
		//will hold when using e.g. zoomY = 1.4 first.
		
		//Stdout("m_zoom: ")(m_zoom).newline;
		//m_zoomMul = 1.0 / m_zoom;
		//CenterByCursor();
		//reDraw();
		
		version(zoomCairo)
		{
			if( m_itemList !is null )
				foreach(Rectangle rect; itemList)
				{
					rect.updateThemeTexture();
				}
		}
		
		
		//return m_zoomY;
	}
	void zoomAnim( float to_set )
	{
		Animator to_anim = new Animator(this, &zoom, &zoom, null, null, null, null, null );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomY;
	}
	void zoomAnim( float to_set, void delegate() set_when_finished )
	{
		Animator to_anim = new Animator(this, &zoom, &zoom, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomY;
	}
	//NOT SURE ABOUT THE NEED FOR THIS:
	//protected 
	public float zoomAdder = 0.1;
	
	
	
	//zoomX
	public float zoomX() { return m_zoomX; }
	public float zoomMulX() { return m_zoomMulX; }
	public void zoomX(float set)
	{
		m_zoomX = set;
		if( m_zoomX <= 0.0 )
		{
			//This is just a quick fix for a situation when one
			//gets lost.
			m_zoomX = 0.01;
			//moveScreenX = 0.0;//center.
			//moveScreenY = 0.0;
		}
		m_zoomMulX = 1.0 / m_zoomX;
		invalidate();
		//return m_zoomX;
	}
	public void zoomXN(float set)
	{
		m_zoomX = set;
		if( m_zoomX <= 0.0 )
		{
			//This is just a quick fix for a situation when one
			//gets lost.
			m_zoomX = 0.01;
			//moveScreenX = 0.0;//center.
			//moveScreenY = 0.0;
		}
		m_zoomMulX = 1.0 / m_zoomX;
		//invalidate();
		//return m_zoomX;
	}
	void zoomXAnim( float to_set )
	{
		Animator to_anim = new Animator(this, &zoomX, &zoomX, null, null, null, null, null );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomX;
	}
	void zoomXAnim( float to_set, void delegate() set_when_finished )
	{
		Animator to_anim = new Animator(this, &zoomX, &zoomX, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomX;
	}
	/*
	float zoomX2c()//add all parents x:s, upto canvas... what to add to make it full canvas coordinates.
	{
		if(parent is null)
			return zoomX;
		else return zoomX + parent.zoomX2c();
		return 0.0;
	}*/
	protected float m_zoomX = 1.0f;
	protected float m_zoomMulX = 1.0f;
	
	
	//zoomY
	public float zoomY() { return m_zoomY; }
	public float zoomMulY() { return m_zoomMulY; }
	public void zoomY(float set)
	{
		m_zoomY = set;
		if( m_zoomY <= 0.0 )
		{
			//This is just a quick fix for a situation when one
			//gets lost.
			m_zoomY = 0.01;
			//moveScreenX = 0.0;//center.
			//moveScreenY = 0.0;
		}
		m_zoomMulY = 1.0 / m_zoomY;
		invalidate();
		//return m_zoomY;
	}
	public void zoomYN(float set)
	{
		m_zoomY = set;
		if( m_zoomY <= 0.0 )
		{
			//This is just a quick fix for a situation when one
			//gets lost.
			m_zoomY = 0.01;
			//moveScreenX = 0.0;//center.
			//moveScreenY = 0.0;
		}
		m_zoomMulX = 1.0 / m_zoomY;
		//invalidate();
		//return m_zoomY;
	}
	void zoomYAnim( float to_set )
	{
		Animator to_anim = new Animator(this, &zoomY, &zoomY, null, null, null, null, null );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomY;
	}
	void zoomYAnim( float to_set, void delegate() set_when_finished )
	{
		Animator to_anim = new Animator(this, &zoomY, &zoomY, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
		//return m_zoomY;
	}
	/*
	float zoomY2c()//add all parents x:s, upto canvas... what to add to make it full canvas coordinates.
	{
		if(parent is null)
			return zoomY;
		else return zoomY + parent.zoomY2c();
		return 0.0;
	}*/
	protected float m_zoomY = 1.0f;
	protected float m_zoomMulY = 1.0f;
	
	/*
	float zoomX() { if( canvas !is null ) return canvas.zoomX(); return 1.0; }
	float zoomY() { if( canvas !is null ) return canvas.zoomY(); return 1.0; }
	float moveScreenX() { if( canvas !is null ) return canvas.moveScreenX(); return 0.0; }
	float moveScreenY() { if( canvas !is null ) return canvas.moveScreenY(); return 0.0; }

	//Maybe these need shorter names. Like xTr or xT for Transform or Translate...
	//or maybe we need a trx(x) method... translate for rendering tfrx(x)... ??? //no no. just a rename.

	float xRender() { return (x * zoomX); }
	float yRender() { return (y * zoomY); }
	float wRender() { return (w * zoomX); }
	float hRender() { return (h * zoomY); }
	*/
	
	//
	
	
	void renderChildren(Draw draw)
	{
		if( m_itemList is null || m_itemTree is null )
			return;
		
		//We only draw visible children.
		//We get those from the RTree.intersectionList()
		//scope LinkedList!(ICanvasItem) render_items = itemTree.intersectionList( tr_x_i2c(ix1), tr_y_i2c(iy1), tr_w_i2c(w), tr_h_i2c(h) );
		//scope ICanvasItem[] render_items = itemTree.intersectionList( tr_x_i2c(ix1), tr_y_i2c(iy1), tr_w_i2c(w), tr_h_i2c(h) );
		scope ICanvasItem[] render_items = itemTree.intersectionList( tr_x_i2c(ix1), tr_y_i2c(iy1), tr_x_i2c(ix2), tr_y_i2c(iy2) );
	
		int push_counter_debug1 = draw.pushCounter;
		draw.pushMatrix();
			draw.scale( zoomX, zoomY );
			draw.translate( moveScreenX, moveScreenY, 0.0f );
			
			//Trace.formatln("renderChildren. render_items.size: {}", render_items.size );
		
			//foreach(Rectangle wid; itemList)
			
			//ICanvasItem[] zordered_items;
			
			/*
			uint widget_count = 0;
			//We'll start the rendering from the layer 5000.
			int min_layer = 5000;
			int max_layer = int.max;
			int suggested_next_layer = 0;
			
			while( widget_count < render_items.length )
			{
				foreach(ICanvasItem wid; render_items)
				{
					//if( wid.isFBO == false )
					//if( wid.isClipByParent == true )
					
					if( wid.layer <= max_layer )//ignore those who are already handled. Those are bigger than max_layer.
					{
						if( wid.layer >= min_layer )//this widgets layer falls inbetween min_layer and max_layer, so we render it.
						{
							widget_count++;//add widget count, so we keep track when we have rendered all the layers.
							//wid.render(draw);
							zordered_items ~= wid;
						}
						else if( suggested_next_layer < wid.layer )//this widget is still unhandled but it's layer is bigger than
						//our suggested_next_layer. So we'll make that our suggested_next_layer instead.
						//suggested_next_layer will thus be the highest number we haven't yet handled.
						{
							suggested_next_layer = wid.layer;
						}
					}
				}
				//Then we move on. This is done with the min_layer and max_layer variables.
				max_layer = min_layer - 1;//The first time around this will be 4999, so that's our upper limit now.
				min_layer = suggested_next_layer;//And this will be the highest num yet to be handled.
				suggested_next_layer = 0;//And then we need to zero this, so that we'll get a valid number next time.
			}
			*/
			
			//Then the zorder pass, where we render:
			uint widget_count = 0;
			//We'll start the rendering from the zorder itemList.length-1.
			int min_layer = itemList.size-1;
			int max_layer = itemList.size;
			int suggested_next_layer = 0;
		
			while( widget_count < render_items.length )
			{
				foreach(ICanvasItem wid; render_items)
				{
					//if( wid.isFBO == false )
					//if( wid.isClipByParent == true )
					
					if( wid.zOrder <= max_layer )//ignore those who are already handled. Those are bigger than max_layer.
					{
						if( wid.zOrder >= min_layer )//this widgets layer falls inbetween min_layer and max_layer, so we render it.
						{
							widget_count++;//add widget count, so we keep track when we have rendered all the layers.
							wid.render(draw);
						}
						else if( suggested_next_layer < wid.zOrder )//this widget is still unhandled but it's layer is bigger than
						//our suggested_next_layer. So we'll make that our suggested_next_layer instead.
						//suggested_next_layer will thus be the highest number we haven't yet handled.
						{
							suggested_next_layer = wid.zOrder;
						}
					}
				}
				//Then we move on. This is done with the min_layer and max_layer variables.
				max_layer = min_layer - 1;//The first time around this will be 4999, so that's our upper limit now.
				min_layer = suggested_next_layer;//And this will be the highest num yet to be handled.
				suggested_next_layer = 0;//And then we need to zero this, so that we'll get a valid number next time.
			}
		
		draw.popMatrix();
		
		int push_counter_debug2 = draw.pushCounter;
		
		if( push_counter_debug1 != push_counter_debug2 )
		{
			Trace.formatln("push_counter_debug1: {}", push_counter_debug1 );
			Trace.formatln("push_counter_debug2: {}", push_counter_debug2 );
		}
		
		assert( push_counter_debug1 == push_counter_debug2 );
		
		
		if( hasVerticalScrollbar == true && verticalScrollbar !is null )
			verticalScrollbar.render(draw);
			
		if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
			horizontalScrollbar.render(draw);
		
	}
	
	void renderChildrenNotClipped(Draw draw)
	{
		/*
		foreach(Rectangle wid; itemList)
		{
			if( wid.isClipByParent == false )
				wid.render(draw);
		}
		
		if( hasVerticalScrollbar == true && verticalScrollbar !is null )
			verticalScrollbar.render(draw);
			
		if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
			horizontalScrollbar.render(draw);
		*/
	}
	
	void defaultSize(float set_width, float set_height)
	{
		//rectangle.
		//set( x, y, set_width, set_height );
		defaultWidth = set_width;
		defaultHeight = set_height;
	}
	/*
	void defaultSizeP(float set_width, float set_height)
	{
		//rectangle.
		//set( x, y, set_width, set_height );
		defaultWidthP = set_width;
		defaultHeightP = set_height;
	}
	*/
	
	void minSize(float set_width, float set_height)
	{
		minWidth = set_width;
		minHeight = set_height;
	}
	
	void maxSize(float set_width, float set_height)
	{
		maxWidth = set_width;
		maxHeight = set_height;
	}
	
	bool hasDefaultWidth = false;
	/*
	public float defaultWidth() { return m_defaultWidth * g_rae.p2hCoordMul; }
	public void defaultWidth(float set)
	{
		defaultWidthP = set * g_rae.screenHeightP;
	}
	*/
	public float defaultWidth() { return m_defaultWidth; }
	public void defaultWidth(float set)
	{
		hasDefaultWidth = true;
		m_defaultWidth = set;
		if( m_minWidth > m_defaultWidth )
			m_minWidth = m_defaultWidth;
		if( m_maxWidth < m_defaultWidth )
			m_maxWidth = m_defaultWidth;
			
		w(defaultWidth);//was wc()
		
		arrange();
		//return m_defaultWidth;
	}
	public void defaultWidthN(float set)
	{
		hasDefaultWidth = true;
		m_defaultWidth = set;
		if( m_minWidth > m_defaultWidth )
			m_minWidth = m_defaultWidth;
		if( m_maxWidth < m_defaultWidth )
			m_maxWidth = m_defaultWidth;
			
		wN(defaultWidth);//was wc()
		
		//arrange();
		//return m_defaultWidth;
	}
	protected float m_defaultWidth = 1.0f;
	
	
	//TODO RENAME to desiredHeight()
	//That way it makes more sense!
	//Is this helper function really sane.
	//It solves a problem in arrange()...
	//package
	//internal API
	float ifDefaultHeight()
	{
		debug(arrange) Trace.formatln("Rectangle() ifDefaultHeight START." );
		if( hasDefaultHeight == true )
			return defaultHeight;
			
		debug(arrange) Trace.formatln("Rectangle() doesn't have defaultHeight. calling childrenDefaultHeight." );		
		//else
			//return childrenHeight();
			//return childrenDefaultHeight() + (inPadding*2.0f);
			float result = childrenDefaultHeight() + (inPaddingY*2.0f);
			if( hasHorizontalScrollbar == true && horizontalScrollbar !is null )
			{
				//Here we add the scrollbars width or height to the childrens w/h.
				result += horizontalScrollbar.h;
			}
			return result;
	}
	
	//package
	//internal API
	float ifDefaultWidth()
	{
		if( hasDefaultWidth == true )
			return defaultWidth;
		//else
			//return childrenWidth();
			//return childrenDefaultWidth() + (inPaddingX*2.0f);
			float result = childrenDefaultWidth() + (inPaddingX*2.0f);
			if( hasVerticalScrollbar == true && verticalScrollbar !is null )
			{
				//Here we add the scrollbars width or height to the childrens w/h.
				result += verticalScrollbar.w;
			}
			return result;
	}
	
	bool hasDefaultHeight = false;
	public float defaultHeight() { return m_defaultHeight; }
	public float defaultHeight(float set)
	{
		hasDefaultHeight = true;
		m_defaultHeight = set;
		if( m_minHeight > m_defaultHeight )
			m_minHeight = m_defaultHeight;
		if( m_maxHeight < m_defaultHeight )
			m_maxHeight = m_defaultHeight;
			
		h(defaultHeight);//was hc()
		
		arrange();
		return m_defaultHeight;
	}
	public float defaultHeightN(float set)
	{
		hasDefaultHeight = true;
		m_defaultHeight = set;
		if( m_minHeight > m_defaultHeight )
			m_minHeight = m_defaultHeight;
		if( m_maxHeight < m_defaultHeight )
			m_maxHeight = m_defaultHeight;
			
		hN(defaultHeight);//was hc()
		
		//arrange();
		return m_defaultHeight;
	}
	protected float m_defaultHeight = 1.0f;
	
	bool hasMinWidth = false;
	public float minWidth() { return m_minWidth; }
	public float minWidth(float set)
	{
		hasMinWidth = true;
		m_minWidth = set;
		
		if( w < m_minWidth ) w(m_minWidth);//was wc()
		
		arrange();
		return m_minWidth;
	}
	protected float m_minWidth = 0.0f;
	bool hasMinHeight = false;
	public float minHeight() { return m_minHeight; }
	public float minHeight(float set)
	{
		hasMinHeight = true;
		m_minHeight = set;
		if( h < m_minHeight ) h(m_minHeight);//was hc()
		arrange();
		return m_minHeight;
	}
	protected float m_minHeight = 0.0f;
	
	bool hasMaxWidth = false;
	public float maxWidth() { return m_maxWidth; }
	public float maxWidth(float set)
	{
		hasMaxWidth = true;
		m_maxWidth = set;
		
		if( m_defaultWidth > m_maxWidth )
			m_defaultWidth = m_maxWidth;
		if( m_minWidth > m_maxWidth )
			m_minWidth = m_maxWidth;
		
		if( w > m_maxWidth ) w(m_maxWidth);//was wc()
		arrange();
		return m_maxWidth;
	}
	protected float m_maxWidth = 100.0f;
	bool hasMaxHeight = false;
	public float maxHeight() { return m_maxHeight; }
	public float maxHeight(float set)
	{
		hasMaxHeight = true;
		m_maxHeight = set;
		
		if( m_defaultHeight > m_maxHeight )
			m_defaultHeight = m_maxHeight;
		if( m_minHeight > m_maxHeight )
			m_minHeight = m_maxHeight;
		
		if( h > m_maxHeight ) h(m_maxHeight);//was hc()
		arrange();
		return m_maxHeight;
	}
	protected float m_maxHeight = 100.0f;
	
	//Colour animations:
	
	void rAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &r, &r, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void gAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &g, &g, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void bAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &b, &b, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void aAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &a, &a, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void colourAnim( float to_r, float to_g, float to_b, float to_a = 1.0f, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &r, &r, &g, &g, &b, &b, set_when_finished );
		to_anim.animateTo( to_r, to_g, to_b );
		add(to_anim);
		
		Animator to_anim_alpha = new Animator(this, &a, &a, null, null, null, null, set_when_finished );
		to_anim_alpha.animateTo( to_a, 0.0f, 0.0f );
		add(to_anim_alpha);
	}
	
	//Rotation animations:
	void xRotAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xRot, &xRot, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void yRotAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &yRot, &yRot, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void zRotAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &zRot, &zRot, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void rotAnim( float to_x, float to_y, float to_z, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xRot, &xRot, &yRot, &yRot, &zRot, &zRot, set_when_finished );
		to_anim.animateTo( to_x, to_y, to_z );
		add(to_anim);
	}
	
	//Position animations:
	void xPosAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xPos, &xPos, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void yPosAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &yPos, &yPos, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void zPosAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &zPos, &zPos, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	void posAnim( float to_x, float to_y, float to_z, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xPos, &xPos, &yPos, &yPos, &zPos, &zPos, set_when_finished );
		to_anim.animateTo( to_x, to_y, to_z );
		add(to_anim);
	}
	
	//Redefined for adjustTree:
	/*public float xPosP(){ return super.xPosP; }
	public void xPosP(float set)
	{
		super.xPosP(set);
		adjustTree();
		//return _xPos;
	}
	*/
	public float xPos(){ return super.xPos; }
	public void xPos(float set)
	{
		super.xPos(set);
		adjustTree();
		//return _xPos;
	}
	/*public float yPosP(){ return super.yPosP; }
	public void yPosP(float set)
	{
		super.yPosP(set);
		adjustTree();
		//return _yPos;
	}*/
	public float yPos(){ return super.yPos; }
	public void yPos(float set)
	{
		super.yPos(set);
		adjustTree();
		//return _yPos;
	}
	void move( float delta_x, float delta_y )
	{
		super.move(delta_x, delta_y);
		adjustTree();
	}
	/*
	void moveP( float delta_x, float delta_y )
	{
		super.moveP(delta_x, delta_y);
		adjustTree();
	}
	*/

	void moveTo( float to_x, float to_y )
	{
		super.moveTo(to_x, to_y);
		adjustTree();
	}
	/*
	void moveToP( float to_x, float to_y )
	{
		super.moveToP(to_x, to_y);
		adjustTree();
	}
	*/
	
	void moveToAnim( float to_x, float to_y, float to_z = 0.0f, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xPos, &xPos, &yPos, &yPos, &zPos, &zPos, set_when_finished );
		to_anim.animateTo( to_x, to_y, to_z );
		add(to_anim);
	}
	
	void sizeAnim( float to_w, float to_h, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &w, &w, &h, &h, null, null, set_when_finished );
		to_anim.animateTo( to_w, to_h, 0.0f );
		add(to_anim);
	}
	
	public float x1(){ return super.x1; }
	public void x1( float set )
	{
		super.x1(set);
		adjustTree();
		//return x1;
	}
	public float ix1(){ return super.ix1; }
	public void ix1( float set )
	{
		super.ix1(set);
		adjustTree();
		//return _ix1;
	}
	
	public float y1(){ return super.y1; }
	public void y1( float set )
	{
		super.y1(set);
		adjustTree();
		//return y1;
	}
	public float iy1(){ return super.iy1; }
	public void iy1( float set )
	{
		super.iy1(set);
		adjustTree();
		//return _iy1;
	}
	
	public float x2(){ return super.x2; }
	public void x2( float set )
	{
		super.x2(set);
		adjustTree();
		//return x2;
	}
	public float ix2(){ return super.ix2; }
	public void ix2( float set )
	{
		super.ix2(set);
		adjustTree();
		//return _ix2;
	}
	
	public float w(){ return super.w; }
	public void w( float set )
	{
		debug(geometry) Trace.formatln("Rectangle.w(set) START.");
		debug(geometry) scope(exit) Trace.formatln("Rectangle.w(set) END.");
		super.w(set);
		adjustTree();
		//return w;
	}
	
	public float y2(){ return super.y2; }
	public void y2( float set )
	{
		super.y2(set);
		adjustTree();
		//return y2;
	}
	public float iy2(){ return super.iy2; }
	public void iy2( float set )
	{
		super.iy2(set);
		adjustTree();
		//return _iy2;
	}
	
	public float h(){ return super.h; }
	public void h( float set )
	{
		debug(geometry) Trace.formatln("Rectangle.h(set) START.");
		debug(geometry) scope(exit) Trace.formatln("Rectangle.h(set) END.");
		super.h(set);
		adjustTree();
		//return h;
	}
	
	
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
