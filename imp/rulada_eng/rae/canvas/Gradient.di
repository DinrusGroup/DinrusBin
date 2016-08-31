module rae.canvas.Gradient;

import tango.util.log.Trace;//Thread safe console output.
import tango.util.container.LinkedList;

public import rae.canvas.Colour;

class ColourStop
{
public:
	this(float set_position, float sr, float sg, float sb, float sa = 1.0f)
	{
		position = set_position;
		colour = new Colour(sr, sg, sb, sa);
	}
	
	this(float set_position, Colour set_colour)
	{
		position = set_position;
		colour = set_colour;
	}
	
	float position = 0.0f;
	Colour colour;
}

//TODO keep the ColourStops
//ordered by stop position...
//-> replace all appends and prepends
//with just add().

//TODO make a check for the first stop
//position to always be == 0.0f and  the last
//== 1.0f;
class Gradient
{
public:
	this()
	{
		m_colourStops = new LinkedList!(ColourStop);
	}
	
	//You can create a gradient from a Colour. This is of course
	//not a gradient until you add some other ColourStops into it with
	//the add methods.
	this( Colour set_colour )
	{
		this();
		add( 0.0f, set_colour );
	}
	
	void add(float set_position, float sr, float sg, float sb, float sa = 1.0f)
	{
		ColourStop empty = new ColourStop(set_position, sr, sg, sb, sa);
		m_colourStops.append(empty);
	}
	
	void add(ColourStop set_stop)
	{
		m_colourStops.append(set_stop);
	}
	
	void add(float set_position, Colour set_colour)
	{
		ColourStop empty = new ColourStop(set_position, set_colour);
		m_colourStops.append(empty);
	}
	
	float[] get(float percent)
	{
		//Trace.formatln("Gradient.get() START. percent: {}", cast(double)percent );
	
		//float[] result = [1.0f, 1.0f, 1.0f, 1.0f];
		float[] result = new float[4];
	
		for( uint i = 0; i < m_colourStops.size(); i++ )
		{
			//Trace.formatln("colourStops i: {}", i );
			if( percent >= m_colourStops.get(i).position )
			{
				//Trace.formatln("FOUND STOP i: {} position: {}", i, m_colourStops[i].position );
				//Trace.formatln("stop i colour: {}", m_colourStops[i].colour.toString() );
			
				if( i+1 < m_colourStops.size() )//This is not the last one
				{
					if( percent <= m_colourStops.get(i+1).position )
					{
						//Trace.formatln("stop i+1 colour: {}", m_colourStops[i+1].colour.toString() );
						
						float delt = m_colourStops.get(i+1).position - m_colourStops.get(i).position;
						float loc_pos = (percent - m_colourStops.get(i).position);
						float pos_factor = loc_pos / delt;
						
						result[0] = (pos_factor * (m_colourStops.get(i+1).colour.r - m_colourStops.get(i).colour.r)) + m_colourStops.get(i).colour.r;
						result[1] = (pos_factor * (m_colourStops.get(i+1).colour.g - m_colourStops.get(i).colour.g)) + m_colourStops.get(i).colour.g;
						result[2] = (pos_factor * (m_colourStops.get(i+1).colour.b - m_colourStops.get(i).colour.b)) + m_colourStops.get(i).colour.b;
						result[3] = (pos_factor * (m_colourStops.get(i+1).colour.a - m_colourStops.get(i).colour.a)) + m_colourStops.get(i).colour.a;
						//Trace.format("r: {}", cast(double)result[0] );
						//Trace.format(" g: {}", cast(double)result[1] );
						//Trace.format(" b: {}", cast(double)result[2] );
						//Trace.formatln(" a: {}", cast(double)result[3] );
						return result;
					}
				}
				else //this is the last one. Shouldn't happen. Except 1.0f ofcourse.
				{
					result[0] = m_colourStops.get(i).colour.r;
					result[1] = m_colourStops.get(i).colour.g;
					result[2] = m_colourStops.get(i).colour.b;
					result[3] = m_colourStops.get(i).colour.a;
					
					//Trace.format("ELSE r: {}", cast(double)result[0] );
					//Trace.format(" g: {}", cast(double)result[1] );
					//Trace.format(" b: {}", cast(double)result[2] );
					//Trace.formatln(" a: {}", cast(double)result[3] );
					return result;
				}
				
			}
		}
	}
	
	/*
	void prepend(float set_position, float sr, float sg, float sb, float sa = 1.0f)
	{
		ColourStop empty = new ColourStop(set_position, sr, sg, sb, sa);
		m_colourStops.prepend(empty);
	}
	
	void prepend(ColourStop set_stop)
	{
		m_colourStops.prepend(set_stop);
	}
	
	void prepend(float position, Colour set_colour)
	{
		ColourStop empty = new ColourStop(set_position, set_colour);
		m_colourStops.prepend(empty);
	}
	*/

	int opApply(int delegate(inout ColourStop) dg)//foreach
	{
		int result = 0;
		foreach( ColourStop col; m_colourStops )
		{
			result = dg( col );
		}
		return result;
	}

	uint size()
	{
		return m_colourStops.size();
	}
	
	//TODO I think all LinkedLists names should actually
	//be plural: so m_colourStops instead of m_colourStop.
	//Even it's nice to have stuff like m_colourStop[52]
	//it's even nicer to see from the name of an object
	//that it contains many items like in m_colourStops[52].
	public LinkedList!(ColourStop) colourStops() { return m_colourStops; }
	protected LinkedList!(ColourStop) m_colourStops;
	
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
