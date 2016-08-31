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

module rae.ui.Menu;
 
import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.math.Math;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.canvas.IRootWindow;
public import rae.ui.InputState;
import rae.canvas.Rectangle;
import rae.ui.Label;
import rae.ui.Button;
import rae.ui.Box;//Just for class Menu
import rae.ui.SubWindow;//for PlainWindow.
import rae.canvas.Draw;
import rae.ui.Widget;

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


interface IMenu
{

	void close();
	void mouseHandler( InputState input, Rectangle wid );
	void activatedMenuItem( MenuItem set );
}

class Menu : public HBox, IMenu
{
public:
	this()
	{
		debug(Menu) Trace.formatln("Menu.this() START.");
		debug(Menu) scope(exit) Trace.formatln("Menu.this() END.");
	
		super();
		name = "Menu";
		type = "Menu";
		
		layer = 0;
		
		colour = g_rae.getColourArrayFromTheme("Rae.Menu");
		texture = g_rae.getTextureFromTheme("Rae.Menu");
		
		renderMethod = RenderMethod.NORMAL;
		
		shadowType = ShadowType.NONE;
		//shadowType = ShadowType.SQUARE;
		
		//signalMouseButtonPress.attach(&mouseHandler);
		
		//menuWindows = new LinkedList!(MenuWindow);
	}
	
	protected override void add(Rectangle item)
	{
		super.add(item);
	}
	
	void addMenuItem(MenuItem add_item)
	{
		debug(Menu) Trace.formatln("Menu.addMenuItem() START.");
		debug(Menu) scope(exit) Trace.formatln("Menu.addMenuItem() END.");
		
		add_item.menu = this;
		add_item.createMenuWindow(this);
		super.add(add_item);
	}
	
	void mouseHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
	
		MenuItem a_item = cast(MenuItem)wid;
	
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				if( isOpened == true && currentOpenMenuItem !is a_item )
				{
					debug(Menu) Trace.formatln("Enter_notify menuitem: {}", a_item.name );
					if( currentOpenMenuItem !is null )
						currentOpenMenuItem.hideMenuWindow();
					currentOpenMenuItem = a_item;
					a_item.showMenuWindow();
				}
				//wid.prelight();
				//wid.sendToTop();
			break;
			case SEventType.LEAVE_NOTIFY:
				debug(Menu) Trace.formatln("Leave_notify menuitem: {}", a_item.name );
				//wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				debug(Menu) Trace.formatln("Press menuitem: {}", a_item.name );
				if( isOpened == false )
				{
					isOpened = true;
					currentOpenMenuItem = a_item;
					a_item.showMenuWindow();
				}
				else
				{
					close();
				}
				//wid.grabInput();
				//wid.sendToTop();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				debug(Menu) Trace.formatln("Release menuitem: {}", a_item.name );
				//a_item.hideMenuWindow();
				//wid.ungrabInput();
			break;
		}
	
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			//wid.move( input.mouse.xRel, input.mouse.yRel );
			//Trace.formatln( "xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
		}
	}
	
	void close()
	{
		debug(Menu) Trace.formatln("Menu.close() START.");
		debug(Menu) scope(exit) Trace.formatln("Menu.close() END.");
		
		if( m_itemList !is null )
			foreach(Rectangle item; itemList)
			{
				(cast(MenuItem)item).hideMenuWindow();
			}
		
		isOpened = false;
	}
	
	void activatedMenuItem( MenuItem set ) { m_activatedMenuItem = set; }
	protected MenuItem m_activatedMenuItem;
	
	bool isOpened = false;//TODO make into protected property.
	MenuItem currentOpenMenuItem;
	
	//LinkedList!(MenuWindow) menuWindows;
}




class MenuItem : public Rectangle//Button
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	this( dchar[] set_name, void delegate() set_on_activate = null, dchar[] set_key_shortcut = null )
	{
		debug(Menu) Trace.formatln("MenuItem.this() START.");
		debug(Menu) scope(exit) Trace.formatln("MenuItem.this() END.");
	
		//super(set_name);
		super();
		name = set_name;
		type = "MenuItem";
		
		isOutline = false;
		
		arrangeType = ArrangeType.HBOX;
		
		//xPackOptions = PackOptions.SHRINK;
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.SHRINK;
		
		//alignType = AlignType.BEGIN;
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.015f;
		inPaddingY = 0.0f;
		
		//texture = null;
		
		colour = g_rae.getColourArrayFromTheme("Rae.MenuItem");
		
		label = new Label(set_name);
		label.textColour = g_rae.getColourArrayFromTheme("Rae.MenuItem.text");
		label.alignType = AlignType.BEGIN;
		label.xPackOptions = PackOptions.EXPAND;
		label.yPackOptions = PackOptions.SHRINK;
		label.outPaddingX = 0.015f;
		add(label);
		
		buttonHandlerInit();
		
		signalActivate.attach(&onActivateMenuItem);
		
		if( set_on_activate !is null )
			signalActivate.attach(set_on_activate);
		
		/*
		menuButton = new Button(set_name);
		menuButton.texture = null;
		menuButton.padding = 0.0f;
		add(menuButton);
		*/
		
		keyShortCut(set_key_shortcut);//if null it won't be set.
	}
	
	//This is to override the prelightColour...
	override void updatePrelightColour()
	{	
		prelightColour.set( g_rae.getColourArrayFromTheme("Rae.MenuItem.prelight") );
	
		/*if( mainColour.r > 0.8f )//If whitish...make darker.
		{
			prelightColour.set( 0.7f*mainColour.r, 0.7f*mainColour.g, 0.7f*mainColour.b, mainColour.a );
		}
		else //otherwise make lighter.
		{
			prelightColour.set( 1.3f*mainColour.r, 1.3f*mainColour.g, 1.3f*mainColour.b, mainColour.a );
		}*/
		//prelightColour.set(0.1f, 0.8f, 0.2f, 0.8f );
	}
	
	void keyShortCut( dchar[] set )
	{
		if( set is null ) return;
		if( keyShortCutLabel is null )
		{
			keyShortCutLabel = new Label(set);
			keyShortCutLabel.alignType = AlignType.END;
			//keyShortCutLabel.isOutline = true;
			keyShortCutLabel.xPackOptions = PackOptions.EXPAND;
			keyShortCutLabel.yPackOptions = PackOptions.SHRINK;
			keyShortCutLabel.outPaddingX = 0.015f;
			//debug:
			//keyShortCutLabel.renderMethod = RenderMethod.NORMAL;
			add(keyShortCutLabel);
		}
		else keyShortCutLabel.name = set;
	}
	
	//TEMP override of button override.
	/*
	override void renderNormal(Draw draw)
	{
		Widget.renderNormal( draw );
	}
	*/
	
	void addMenuItem(MenuItem add_item)
	{
		debug(Menu) Trace.formatln("MenuItem.addMenuItem() START.");
		debug(Menu) scope(exit) Trace.formatln("MenuItem.addMenuItem() END.");
		
		if( menu is null )
		{
			//debug(Menu) 
			Trace.formatln("MenuItem.addMenuItem() ERROR: You have to add the MenuItem to a Menu before adding MenuItems to it.");
			return;
		}
		add_item.menu = menu;
		if( menuWindow is null )
			createMenuWindow(menu);
			//There should be some more handling of menuitems inside menuitems * 3.
		
		if( menuWindow !is null )
			menuWindow.add(add_item);
			
		arrange();
		invalidate();
		menuWindow.arrange();
		menuWindow.invalidate();
	}
	
	protected bool isMainMenu() { return m_isMainMenu; }
	protected void isMainMenu(bool set)
	{
		if( set == true )
			xPackOptions = PackOptions.SHRINK;
		else xPackOptions = PackOptions.EXPAND;
		m_isMainMenu = set;
	}
	protected bool m_isMainMenu = false;
	
	
	
	IMenu menu;
	
	void onActivateMenuItem()
	{
		debug(Menu) Trace.formatln("MenuItem.onActivateMenuItem() START {}.", name);
		debug(Menu) scope(exit) Trace.formatln("MenuItem.onActivateMenuItem() END {}.", name);
		
		if( isMainMenu == false && menu !is null )
		{
			menu.activatedMenuItem( this );
			menu.close();
		}
		//super.onActivate();
		
		
		//in super.onActivate(): signalActivate.call();
	}
	
	//internal:
	//RENAME to initForMenu(Menu set_menu)
	public void createMenuWindow(IMenu set_menu)
	{
		debug(Menu) Trace.formatln("MenuItem.createMenuWindow() START.");
		debug(Menu) scope(exit) Trace.formatln("MenuItem.createMenuWindow() END.");
		
		isMainMenu = true;
		texture = g_rae.getTextureFromTheme("Rae.Menu");
		colour = g_rae.getColourArrayFromTheme("Rae.Menu");
	
		menu = set_menu;
	
		menuWindow = new MenuWindow();
		//menuWindow.defaultSize( 0.25f, 0.35f );
		
		signalMouseButtonPress.attach(&menu.mouseHandler);
		signalMouseButtonRelease.attach(&menu.mouseHandler);
		signalEnterNotify.attach(&menu.mouseHandler);
		signalLeaveNotify.attach(&menu.mouseHandler);
		
		arrange();
		invalidate();
			//signalActivate.attach(&showMenuWindow);
		//signalMouseButtonPress.attach(&showMenuWindow);
		//signalMouseButtonRelease.attach(&hideMenuWindow);
	}
	
	public IRootWindow rootWindow(IRootWindow set)///Don't use this yourself.
	{
		super.rootWindow(set);
		
		//This is here because we wan't the menuWindow to load up fast.
		//And this was the earliest point (or the only point) where we're
		//quaranteed to have a rootWindow and we're not iterating through
		//all our children (like in arrange).
		//So, this adds the menuWindow to the rootWindow, so that it opens
		//fast when the user clicks it for the first time.
		if( menuWindow !is null && menuWindow.parent is null && m_rootWindow !is null )
		{
			debug(Menu) Trace.formatln("Adding menuWindow into rootWindow for the first time.");
			m_rootWindow.addFloating( menuWindow );
			menuWindow.sendToTop();
			menuWindow.hide();
		}
		
		return m_rootWindow;
	}
	public IRootWindow rootWindow() { return m_rootWindow; }///Don't use this yourself.
			
	
	/*
	void renderChildren(Draw draw)
	{
		super.renderChildren(draw);
		
		if( menuWindow !is null )
			menuWindow.render(draw);
	}
	*/
	
	void arrange()
	{
		super.arrange();
		
		if( menuWindow !is null )
		{
			menuWindow.yPos = yPos2c + ((h*0.5f) + (menuWindow.h*0.5f));
			menuWindow.xPos = xPos2c + (menuWindow.w*0.5f) - (w*0.5f);
		}
	}
	
	void showMenuWindowHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		showMenuWindow();
	}
	
	void showMenuWindow()
	{
		debug(Menu) Trace.formatln("MenuItem.showMenuWindow() START {}.", name);
		debug(Menu) scope(exit) Trace.formatln("MenuItem.showMenuWindow() END {}.", name);
		
		if( menuWindow !is null )
		{
			//if( menuWindow.a != 1.0f )
			//	menuWindow.a = 0.0f;
			if( menuWindow.parent is null && rootWindow !is null )
			{
				debug(Menu) Trace.formatln("Adding menuWindow into rootWindow for the first time.");
				rootWindow.addFloating( menuWindow );
			}
			menuWindow.show();
			menuWindow.sendToTop();
			//if( menuWindow.a != 1.0f )
				//ANIMATION NOT WORKING ATM: menuWindow.aAnim(1.0f );
				
			//parent.arrange();//Doesn't work: Add another arrange because of a bug in Rectangle.arrange()
				//which doesn't handle followsChildWidth correctly without a second
				//arrange().
		}
	}
	
	void hideMenuWindowHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		hideMenuWindow();
	}
	
	void hideMenuWindow()
	{
		debug(Menu) Trace.formatln("MenuItem.hideMenuWindow() START {}.", name);
		debug(Menu) scope(exit) Trace.formatln("MenuItem.hideMenuWindow() END {}.", name);
		
		if( menuWindow !is null )
		{
			//if( menuWindow.a != 0.0f )
			//{
				//menuWindow.aAnim(0.0f, &menuWindow.removeFromParent );
				//WITH ANIMATION, NOT WORKING ATM: menuWindow.aAnim(0.0f, &menuWindow.hide );
				//No animation here, because it will feel slow
				//and there will be many MenuWindows open at the same time.
				//menuWindow.a = 0.0f;
				menuWindow.hide();
			//}
			//else if( menuWindow.isHidden == false )
			//	menuWindow.hide();
		}	
	}
	
	//Button menuButton;
	Label keyShortCutLabel;
	MenuWindow menuWindow;
}

class MenuWindow : public PlainWindow
{
public:
	this()
	{
		debug(Menu) Trace.formatln("MenuWindow.this() START.");
		debug(Menu) scope(exit) Trace.formatln("MenuWindow.this() END.");
	
		super("MenuWindow", WindowButtonType.NONE, WindowHeaderType.NONE, WindowHeaderType.NONE, /*isFBO:*/false );
		//super("MenuWindow", WindowHeaderType.NORMAL, WindowHeaderType.NONE );
		
		type = "MenuWindow";
		
		//followsChildWidth = true;
		//followsChildHeight = true;
		
		maxHeight = 1.0f - (4.0f * g_rae.getValueFromTheme( "Rae.Button.defaultHeight" ) );
		container.maxHeight = 1.0f - (4.0f * g_rae.getValueFromTheme( "Rae.Button.defaultHeight" ) );
		
		//container.followsChildWidth = true;
		//container.followsChildHeight = true;
		
		//xPackOptions = PackOptions.BYPASS;
		//yPackOptions = PackOptions.BYPASS;
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		arrangeType = ArrangeType.VBOX;
		container.arrangeType = ArrangeType.VBOX;
		
		isOutline = true;
		setOutlineColour( 0.1f, 0.1f, 0.1f, 1.0f );
		
		//A test to see if this helps with the arrange problems
		//with followsChildWidth:
		//verticalScrollbarSetting = ScrollbarSetting.NEVER;
		//horizontalScrollbarSetting = ScrollbarSetting.NEVER;
		
		//container.verticalScrollbarSetting = ScrollbarSetting.NEVER;
		//container.horizontalScrollbarSetting = ScrollbarSetting.NEVER;
		
		/*
		auto emptyButton31 = new MenuItem("Menuitem 1");
		emptyButton31.signalActivate.attach(&tempMenuHandler);
		add( emptyButton31 );
		
		auto emptyButton32 = new MenuItem("Menuitem 2");
		//emptyButton32.signalActivate.attach(&tempMenuHandler);
		add( emptyButton32 );
		
		auto emptyButton33 = new MenuItem("Menuitem 3");
		emptyButton33.signalActivate.attach(&tempMenuHandler);
		add( emptyButton33 );
		*/
		
	}

	/*
	public bool hasVerticalScrollbar() { return m_hasVerticalScrollbar; }
	protected bool hasVerticalScrollbar(bool set)
	{
		Trace.formatln("MenuWindow.hasVerticalScrollbar() CALLED.");
		assert(0);
		return super.hasVerticalScrollbar(set);
	}
	*/

	/*
	void arrange()
	{
		//Trace.formatln("MenuWindow.arrange() START.");
		super.arrange();
	}
	*/

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
