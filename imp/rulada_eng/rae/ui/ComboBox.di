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

module rae.ui.ComboBox;
 
import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.math.Math;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;

import rae.ui.Menu;
import rae.canvas.Rectangle;
import rae.ui.Label;
import rae.ui.Button;


class ComboBox : public Rectangle, IMenu
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	this()
	{
		debug(ComboBox) Trace.formatln("ComboBox.this() START.");
		debug(ComboBox) scope(exit) Trace.formatln("ComboBox.this() END.");
		
		dchar[] set_name = "ComboBox"d;
		
		super();
		name = set_name;
		type = "ComboBox";
		
		isOutline = false;
		
		//arrangeType = ArrangeType.HBOX;
		xPackOptions = PackOptions.SHRINK;
		//xPackOptions = PackOptions.EXPAND;
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
		
		signalActivate.attach(&showMenuWindow);
		
		menuWindow = new MenuWindow();
	}

	void addOption( dchar[] set, bool is_default = false )
	{
		if( menuWindow !is null )
		{
			if( (menuWindow.container.isEmpty == true || is_default == true) && label !is null )
				label.text = set;
				
			auto option = new MenuItem(set, &onActivateMenuItemHandler );
			option.menu = this;
			
			menuWindow.add( option );
		}
	}
	
	MenuItem selectOption( dchar[] set )
	{
		MenuItem mi;
		foreach( wid; optionList )
		{
			//Trace.formatln("wid.type: {} wid.name: {}", wid.type, wid.name );
			if( wid.type == "MenuItem"d && wid.name == set )
			{
				mi = cast(MenuItem) wid;
				mi.signalActivate.call();
				return mi;
			}
		}
		//Trace.formatln("Not found. {}", get);
		return null;//not found
	}
	
	dchar[] currentOption()
	{
		if( label !is null )
			return label.text;
	
		//if( optionList !is null && optionList.size > 0 )
		//	return optionList.get(0).name;
		//else 
			return ""d; 
	}
	
	public LinkedList!(Rectangle) optionList()
	{
		if( menuWindow !is null )
			return menuWindow.container.itemList;
		//
			return new LinkedList!(Rectangle);//return an empty list, this should not happen anyway.
	}

	void onActivateMenuItemHandler()
	{
		close();
		if( activatedMenuItem !is null && label !is null )
		{
			//activatedMenuItem.isSelected = true; //TODO create a selectedColour in plainrect, and use it here.
			label.text = activatedMenuItem.name;
			
			onMenuItemSelected();
		}
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
				/*if( isOpened == true && currentOpenMenuItem !is a_item )
				{
					debug(Menu) Trace.formatln("Enter_notify menuitem: {}", a_item.name );
					
					if( currentOpenMenuItem !is null )
						currentOpenMenuItem.hideMenuWindow();
					currentOpenMenuItem = a_item;
					a_item.showMenuWindow();
					
				}
				*/
				//wid.prelight();
				//wid.sendToTop();
			break;
			case SEventType.LEAVE_NOTIFY:
				debug(Menu) Trace.formatln("Leave_notify menuitem: {}", a_item.name );
				//wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				debug(Menu) Trace.formatln("Press menuitem: {}", a_item.name );
				/*if( isOpened == false )
				{
					isOpened = true;
					currentOpenMenuItem = a_item;
					a_item.showMenuWindow();
				}
				else
				{
					close();
				}
				*/
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
	
	void arrange()
	{
		super.arrange();
		
		if( menuWindow !is null )
		{
			//Position menuWindow under this.
			
			menuWindow.yPos = yPos2c + ((h*0.5f) + (menuWindow.h*0.5f));
			//A version for top: menuWindow.yPos = yPos2c - ((h*0.5f) + (menuWindow.h*0.5f));
			menuWindow.xPos = xPos2c + (menuWindow.w*0.5f) - (w*0.5f);
			
			//Then we'll check how it's positioned. Does it show. etc.
			if( menuWindow.parent !is null )
			{
				float meny1 = menuWindow.tr_h_i2l( menuWindow.y1 );
				float meny2 = menuWindow.tr_h_i2l( menuWindow.y2 );
				float menx1 = menuWindow.tr_w_i2l( menuWindow.x1 );
				float menx2 = menuWindow.tr_w_i2l( menuWindow.x2 );
				
				//Trace.formatln("meny2: {} y2: {}", cast(double)meny2, cast(double)menuWindow.y2 );
				
				float parup = -0.5f;
				float pardown = 0.5f;
				float parleft = -1.0f;
				float parright = 2.0f;
				
				float menu_def_height = g_rae.getValueFromTheme( "Rae.Button.defaultHeight" );
				
				parup = menuWindow.parent.y1 + menu_def_height;//Add the main menu height here. This is a bit of a hack. That barely works.
				pardown = menuWindow.parent.y2;
				parleft = menuWindow.parent.x1;
				parright = menuWindow.parent.x2;
				
				menuWindow.maxHeight = (pardown-parup) - (4.0f * menu_def_height );
				menuWindow.container.maxHeight = (pardown-parup) - (4.0f * menu_def_height );
				
				//Trace.formatln("parup: {} pardown: {}", cast(double)parup, cast(double)pardown );
				
				//We'll check if it fits the toplevel window. Presuming that top level is y: -0.5f to 0.5f.
				//If it doesn't fit it, we'll move it down or up so that it will just fit it.
				
				if( meny1 < parup )
				{
					//Trace.formatln("got meny1.");
					menuWindow.yPos = menuWindow.yPos - (meny1-parup);
				}
				
				if( meny2 > pardown )
				{
					//Trace.formatln("got meny2.");
					menuWindow.yPos = menuWindow.yPos - (meny2-pardown);
				}
				
				if( menx1 < parleft )
				{
					menuWindow.xPos = menuWindow.xPos - (menx1-parleft);
				}
				
				if( menx2 > parright )
				{
					menuWindow.xPos = menuWindow.xPos - (menx2-parright);
				}
			}
		}
	}
	
	//To get the width right. (as big as the biggest in the menuWindow)
	//We must count the children of menuWindow to the childrenDefaultWidth.
	float childrenDefaultWidth()
	{
		float result = 0.0f;//super.childrenDefaultWidth();
		
		switch( arrangeType )
		{
			default:
			case ArrangeType.FREE:
				
			break;
			case ArrangeType.HBOX:
				//Add all the sizes together:
				if( menuWindow !is null && menuWindow.container.isEmpty == false )
					foreach( Rectangle wid; menuWindow.container.itemList )
					{
						result = result + (wid.ifDefaultWidth + wid.outPaddingX*2.0f);
					}
			break;
			case ArrangeType.LAYER:
			case ArrangeType.VBOX:
				//Find the biggest size:
				if( menuWindow !is null && menuWindow.container.isEmpty == false )
					foreach( Rectangle wid; menuWindow.container.itemList )
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

	
	void close()
	{
		debug(Menu) Trace.formatln("Menu.close() START.");
		debug(Menu) scope(exit) Trace.formatln("Menu.close() END.");
		
		/*if( m_itemList !is null )
			foreach(Rectangle item; itemList)
			{
				(cast(MenuItem)item).hideMenuWindow();
			}
		*/
		hideMenuWindow();
		isOpened = false;
	}
	
	void activatedMenuItem( MenuItem set ) { m_activatedMenuItem = set; }
	MenuItem activatedMenuItem() { return m_activatedMenuItem; }
	protected MenuItem m_activatedMenuItem;
	
	bool isOpened = false;//TODO make into protected property.
	//MenuItem currentOpenMenuItem;
	
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
			
			if( isOpened == false )
			{
				menuWindow.show();
				menuWindow.sendToTop();
				isOpened = true;
			}
			else
			{
				close();
			}
			//if( menuWindow.a != 1.0f )
				//ANIMATION NOT WORKING ATM: menuWindow.aAnim(1.0f );
				
			//parent.arrange();//Doesn't work: Add another arrange because of a bug in Rectangle.arrange()
				//which doesn't handle followsChildWidth correctly without a second
				//arrange().
		}
		
		arrange();
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

	Signal!(ComboBox, MenuItem) signalMenuItemSelected;
	Signal!(ComboBox, dchar[]) signalMenuItemSelectedString;
	void onMenuItemSelected()
	{
		//signalMenuItemSelected.call( activatedMenuItem );
		signalMenuItemSelected.call( this, activatedMenuItem );
		signalMenuItemSelectedString.call( this, activatedMenuItem.text );
	}
	
	MenuWindow menuWindow;
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
