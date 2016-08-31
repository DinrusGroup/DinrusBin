module rae.ui.Group;

import tango.util.log.Trace;
import tango.util.container.LinkedList;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.canvas.IHidable;
//import rae.canvas.ICanvasItem;
//import rae.canvas.Rectangle;

class Group
{
	this(char[] set_name = "Undefined")
	{
		name(set_name);
		g_rae.registerGroup( this );
	}
	
	char[] name() { return m_name; }
	void name(char[] set) { m_name = set; }
	protected char[] m_name;
	
	void showGroup()
	{
		g_rae.showGroup( this );
	}
	
	void add( IHidable a_widget )
	{
		append( a_widget );
	}
	void append( IHidable a_widget )//Might get removed?
	{
		itemList.append( a_widget );
		isHiddenList.append( a_widget.isHidden );
	}
	void prepend( IHidable a_widget )//Might get removed?
	{
		itemList.prepend( a_widget );
		isHiddenList.prepend( a_widget.isHidden );
	}
	
	public void hide() { isHidden = true; }
	public void show()
	{
		isHidden = false;
	}
	public void present() { show(); }//show + sendToTop on IHidable.
	//Internal:
	public bool isHidden() { return m_isHidden; }
	protected void isHidden(bool set)
	{
		if( set == m_isHidden ) return; //We don't do anything if the state doesn't change.
		m_isHidden = set;
		if( itemList.size == isHiddenList.size )
		{
			if( set == true )//hide
			{
				for( uint i = 0; i < itemList.size; i++ )
				{
					isHiddenList.replaceAt(i, itemList.get(i).isHidden );
					itemList.get(i).hide();
				}
			}
			else//show
			{
				for( uint i = 0; i < itemList.size; i++ )
				{
					if( isHiddenList.get(i) == false )//it was shown earlier
						itemList.get(i).show();
				}
			}
		}
		//invalidate();
		//arrange();
	}
	protected bool m_isHidden = false;
	
	//When signals support return types, then we'll
	//make this return bool isHidden.
	void toggleIsHidden()
	{
		if( isHidden == true )
			isHidden = false;
		else isHidden = true;
	}

protected:
	//data:
	//These are the child items (could be child widgets):
	public LinkedList!(IHidable) itemList()
	{
		if( m_itemList is null )//Create on demand.
			m_itemList = new LinkedList!(IHidable);
		return m_itemList;
	}
	protected LinkedList!(IHidable) m_itemList;
	
	//This is a list of the isHidden values
	//of the widgets in this group.
	//It is updated when this group is hidden.
	LinkedList!(bool) isHiddenList()
	{
		if( m_isHiddenList is null )
			m_isHiddenList = new LinkedList!(bool);
		return m_isHiddenList;
	}
	protected LinkedList!(bool) m_isHiddenList;
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
