//============================================================================
// HeapT.d - A generic heap class
//     Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III, OLM Digital, Inc.
 * Created: 31 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//===========================================================================

module auxd.OpenMesh.Tools.Utils.HeapT;

/** Martin, 26.12.2004: 
    1) replaced resize(size()-1) with pop_back(), since the later is more efficient
    2) replaced interface_.set_heap_position(entry(0), -1); with reset_heap_position()
    3) added const modifier to various functions
    TODO: in the moment the heap does not conform to the HeapInterface specification, 
          i.e., copies are passed instead of references. This is especially important 
          for set_heap_position(), where the reference argument is non-const. The 
          specification should be changed to reflect that the heap actually (only?)
          works when the heap entry is nothing more but a handle.
    TODO: change the specification of HeapInterface to make less(), greater() and
          get_heap_position() const. Needs changing DecimaterT. Might break 
          someone's code.
*/
    

//=============================================================================
//
//  CLASS HeapT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Streams;
import util = auxd.OpenMesh.Core.Utils.Std;

//== CLASS DEFINITION =========================================================


/** This class demonstrates the HeapInterface's interface.  If you
 *  want to build your customized heap you will have to specity a heap
 *  interface class and use this class as a template parameter for the
 *  class HeapT. This class defines the interface that this heap
 *  interface has to implement.
 *   
 *  See_Also: HeapT
 */
struct HeapInterfaceT(HeapEntry)
{
  /// Comparison of two HeapEntry's: strict less
  bool less(/*const*/ ref HeapEntry _e1, /*const*/ ref HeapEntry _e2);

  /// Comparison of two HeapEntry's: strict greater
  bool greater(/*const*/ ref HeapEntry _e1, /*const*/ ref HeapEntry _e2);

  /// Get the heap position of HeapEntry _e
  int  get_heap_position(/*const*/ ref HeapEntry _e);

  /// Set the heap position of HeapEntry _e
  void set_heap_position(ref HeapEntry _e, int _i);
}



/**
 *  An efficient, highly customizable heap.
 *
 *  The main difference (and performace boost) of this heap compared
 *  to e.g. the heap of the STL is that here to positions of the
 *  heap's elements are accessible from the elements themselves.
 *  Therefore if one changes the priority of an element one does not
 *  have to remove and re-insert this element, but can just call the
 *  update(HeapEntry) method.
 *
 *  This heap class is parameterized by two template arguments: 
 *  $(UL
 *    $(LI the class \c HeapEntry, that will be stored in the heap)
 *    $(LI the HeapInterface telling the heap how to compare heap entries and
 *        how to store the heap positions in the heap entries.)
 *  )
 *
 *  As an example how to use the class see declaration of class 
 *  Decimater.DecimaterT.
 *
 *  See_Also: HeapInterfaceT
 */
 
struct HeapT(HeapEntry, HeapInterface = HeapEntry)
{
public:

    /// Constructor
    static HeapT opCall() { HeapT M; return M; }
  
    /// Construct with a given \c HeapIterface. 
    static HeapT opCall(/*const*/ ref HeapInterface _interface) 
    { 
        HeapT M; with (M) {
            interface_=(_interface);
        } return M; 
    }

    /// clear the heap
    void clear() { Base.length = 0; }

    /// is heap empty?
    bool empty() /*const*/ { return Base.length == 0; }

    /// returns the size of heap
    uint size() /*const*/ { return Base.length; }
    uint length() /*const*/ { return Base.length; }

    /// reserve space for _n entries
    void reserve(uint _n) { util.reserve(Base,_n); }

    /// reset heap position to -1 (not in heap)
    void reset_heap_position(HeapEntry _h)
    { interface_.set_heap_position(_h, -1); }
  
    /// is an entry in the heap?
    bool is_stored(HeapEntry _h)
    { return interface_.get_heap_position(_h) != -1; }
  
    /// insert the entry _h
    void insert(HeapEntry _h)  
    { 
        Base ~= _h; 
        upheap(size()-1); 
    }

    /// get the first entry
    HeapEntry front() /*const*/
    { 
        assert(!empty()); 
        return entry(0); 
    }

    /// delete the first entry
    void pop_front()
    {    
        assert(!empty());
        reset_heap_position(entry(0));
        if (size() > 1)
        {
            entry(0, entry(size()-1));
            pop_back();
            downheap(0);
        }
        else
        {
            pop_back();
        }
    }

    /// remove an entry
    void remove(HeapEntry _h)
    {
        int pos = interface_.get_heap_position(_h);
        reset_heap_position(_h);

        assert(pos != -1);
        assert(cast(uint) pos < size());
    
        // last item ?
        if (cast(uint) pos == size()-1)
        {
            pop_back();    
        }
        else 
        {
            entry(pos, entry(size()-1)); // move last elem to pos
            pop_back();
            downheap(pos);
            upheap(pos);
        }
    }

    /** update an entry: change the key and update the position to
        reestablish the heap property.
    */
    void update(HeapEntry _h)
    {
        int pos = interface_.get_heap_position(_h);
        assert(pos != -1, "HeapEntry is not in heap (pos=-1)");
        assert(cast(uint)pos < size());
        downheap(pos);
        upheap(pos);
    }
  
    /// check heap condition
    bool check()
    {
        bool ok = true;
        uint i, j;
        for (i=0; i<size(); ++i)
        {
            if (((j=left(i))<size()) && interface_.greater(entry(i), entry(j))) 
            {
                derr.writefln("Heap condition violated");
                ok=false;
            }
            if (((j=right(i))<size()) && interface_.greater(entry(i), entry(j)))
            {
                derr.writefln("Heap condition violated");
                ok=false;
            }
        }
        return ok;
    }

protected:  
    /// Instance of HeapInterface
    HeapInterface interface_;
    HeapEntry[]            Base;
  

private:
    // typedef
    alias HeapEntry[] HeapVector;

  
    void pop_back() {
        assert(!empty());
        Base.length = Base.length-1;
    }

    /// Upheap. Establish heap property.
    void upheap(uint _idx)
    {
        HeapEntry     h = entry(_idx);
        uint  parentIdx;

        while ((_idx>0) &&
               interface_.less(h, entry(parentIdx=parent(_idx))))
        {
            entry(_idx, entry(parentIdx));
            _idx = parentIdx;    
        }
  
        entry(_idx, h);
    }

  
    /// Downheap. Establish heap property.
    void downheap(uint _idx)
    {
        HeapEntry     h = entry(_idx);
        uint  childIdx;
        uint  s = size();
  
        while(_idx < s)
        {
            childIdx = left(_idx);
            if (childIdx >= s) break;
    
            if ((childIdx+1 < s) &&
                (interface_.less(entry(childIdx+1), entry(childIdx))))
                ++childIdx;
    
            if (interface_.less(h, entry(childIdx))) break;

            entry(_idx, entry(childIdx));
            _idx = childIdx;
        }  

        entry(_idx, h);

    }

  
    /// Set entry _h to index _idx and update _h's heap position.
    void entry(uint _idx, HeapEntry _h) 
    {
        assert(_idx < size());
        Base[_idx] = _h;
        interface_.set_heap_position(_h, _idx);
    }

  
    /// Get the entry at index _idx
    HeapEntry entry(uint _idx) /*const*/
    {
        assert(_idx < size());
        return (Base[_idx]);
    }

  
    /// Get parent's index
    uint parent(uint _i) { return (_i-1)>>1; }
    /// Get left child's index
    uint left(uint _i)   { return (_i<<1)+1; }
    /// Get right child's index
    uint right(uint _i)  { return (_i<<1)+2; }

}







unittest {

}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
