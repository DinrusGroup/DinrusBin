module rae.container.Stack;

import tango.util.container.LinkedList;

class Stack(T) : public LinkedList!(T)
{
public:
	this()
	{
		super();
	}

	void push(T t)
	{
		append(t);
	}
	
	T pop()
	{
		T t = tail();
		removeTail();
		return t;
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
