//============================================================================
// ListT.d -  Linked list data structure 
//
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * A Linked List data structure.
 * 
 *  A doubly linked list data structure based originally on the one in 
 *  ArcLib.  The interface has been modified to mimic the STL std.list
 *  type more closely, and a few new members have been added.
 *
 *  Author:  William V. Baxter III, OLM Digital, Inc.
 *  Date: 04 Sep 2007
 *  License:       zlib/libpng
 */
//============================================================================
module auxd.OpenMesh.Tools.Utils.ListT;

import auxd.OpenMesh.Core.System.config;

class invalid_iterator : Exception
{
    this(string msg) { super(msg); }
}


/// Iterator type for ListT
struct ListIter(T, bool is_reverse=false) {
    alias T value_type;
    alias T* pointer;
    alias ListT!(T).Node node_type;
    alias ListT!(T).Node* node_pointer;

    private static ListIter opCall(node_pointer init) {
        ListIter M; with(M) {
            ptr_ = init;
        } return M;
    }

    /// Return the value referred to by the iterator
    T val() { assert(ptr_ !is null); return ptr_.data; }

    /// Return a pointer to the value referred to by the iterator
    T* ptr() { assert(ptr_ !is null); return &ptr_.data; }
    
    int opEquals(ref ListIter other) {
        return ptr_ is other.ptr_;
    }

    /// iter++
    void opPostInc() {
        _advance(); 
    }
    /// ++iter
    void opAddAssign(int i) {
        assert(i==1, "invalid operation");
        _advance(); 
    }
    /// iter--
    void opPostDec() {
        _retreat(); 
    }
    /// --iter
    void opSubAssign(int i) {
        assert(i==1, "invalid operation");
        _retreat(); 
    }
private:
    void _advance() {
        assert(ptr_ !is null);
        static if(is_reverse) {
            ptr_=ptr_.prev;
        } else {
            ptr_=ptr_.next;
        }
    }
    void _retreat() {
        assert(ptr_ !is null);
        static if(is_reverse) {
            ptr_=ptr_.next;
        }
        else {
            ptr_=ptr_.prev;
        }
    }
private:
    node_pointer ptr_  = null;
}

ListIter!(T) list_iter_begin(T)(T[] x) {
    return x.begin();
}
ListIter!(T) list_iter_end(T)(T[] x) {
    return x.end();
}
ListIter!(T,true) list_iter_rbegin(T)(T[] x) {
    return ListIter!(T).begin(x);
}
ListIter!(T,true) list_iter_rend(T)(T[] x) {
    return ListIter!(T).end(x);
}

template list_iterator(T) {
    alias ListIter!(T,false) list_iterator;
}

template list_reverse_iterator(T) {
    alias ListIter!(T,true) list_reverse_iterator;
}


/**  Linked-list data structure
 *
 *   Uses a doubly-linked list structure internally.
 */
struct ListT(T)
{
public:
    alias T value_type;
    alias T* pointer;
    alias Node node_type;
    alias Node* node_pointer;
    alias list_iterator!(T) iterator;
    alias list_reverse_iterator!(T) reverse_iterator;

public:

    /// append an item to the list
    iterator append(/*const*/ ref T newData)
    {
        return insert_node_before(&anchor_, newData);
    }

    /// Also append an item to the list using L ~= item syntax.
    void opCatAssign(/*const*/ ref T newData) { append(newData); }

    /// prepend an item onto the head of list
    iterator prepend(/*const*/ ref T newData)
    {
        if (empty() && head is null) {
            // Really we'd like all lists to be initialized this way,
            // but without forcing the use of a static opCall constructor
            // it's not currently possible.
            anchor_.next = &anchor_;
            anchor_.prev = &anchor_;
        }
        return insert_node_before(head, newData);
    }


    /// Insert an element before iter
    iterator insert(iterator iter, /*const*/ ref T newData)
    {
        return insert_node_before(iter.ptr_, newData);
    }

    // Does all insertions
    private iterator insert_node_before(Node* before, /*const*/ ref T newData)
    {
        Node* item = new Node;
        item.data = newData;
      
        if (empty()) // first item in list
        {
            assert (before is &anchor_);
            item.next = &anchor_;
            item.prev = &anchor_;
            anchor_.next = item;
            anchor_.prev = item;
        } 

        else // add before 'before'
        {
            Node* prev = before.prev;
            assert(prev !is null);

            item.prev   = prev;
            item.next   = before;
            prev.next   = item;
            before.prev = item;
        }

        listSize_++;

        return ListIter!(T)(item);
    }

    /// remove node pointed to by iter from the list
    /// returns the iterator to the node following the removed node.
    iterator erase(iterator iter)
    {
        Node* curr = iter.ptr_;
        bool bad_iter = (curr is null) || (curr is &anchor_);
        if (bad_iter) {
            throw new invalid_iterator("List.erase: invalid iterator");
        }
        debug {
            // make sure this node is actually in our list??
        }
        iterator next_iter = iter; ++next_iter;

        curr.next.prev = curr.prev;
        curr.prev.next = curr.next;
      
        delete curr;
      
        listSize_--;

        return next_iter;
    }


    /// Returns the length of the list
    int length() { return listSize_; }

    /// Returns the size of the list, same as length()
    int size() { return listSize_; }
   
    /// Simple function to tell if list is empty or not
    bool empty() 
    {
        return (listSize_ == 0);
    }

    /// Clear all data from the list
    void clear()
    {
        auto it = begin();
        auto end = end();

        for (; it != end; ++it)
            erase(it);
    }

	/// 'item in list' implementation.  O(N) performance.
	bool opIn_r(T data)
	{
		foreach(T d; *this)
			if (d == data)
				return true; 
				
		return false; 
	}

	/// Find item list, return an iterator.  O(N) performance.
    /// If not found returns this.end()
	iterator find(T data)
	{
        iterator it = begin(), _end=end();
        
        for(; it!=_end; ++it) {
			if (*it.ptr == data)
				return it; 
		}		
		return it; 
    }

	// foreach iterator forwards 
	int opApply(int delegate(ref T) dg)
	{
		Node* curr=head;
        if (curr is null) return 0; // special case for unitialized list
		while (curr !is &anchor_)
		{
            Node* next = curr.next;
			int result = dg(curr.data);
			if(result) return result;
            curr = next;
		}
		return 0; 
	}

	// foreach iterator backwards 
	int opApplyReverse(int delegate(ref T) dg)
	{
		Node* curr = tail;
        if (curr is null) return 0; // special case for unitialized list
		while (curr !is &anchor_)
		{
            Node* prev = curr.prev;
			int result = dg(curr.data);
			if(result) return result;
            curr = prev;
		}
		return 0; 
	}
	

    /*******************************************************************************
   
      Returns the current data from the list
   
    *******************************************************************************/

    iterator begin() {
        return ListIter!(T)(head);
    }
    iterator end() {
        return ListIter!(T)(&anchor_);
    }
    reverse_iterator rbegin() {
        return ListIter!(T,true)(tail);
    }
    reverse_iterator rend() {
        return ListIter!(T,true)(&anchor_);
    }

	/// return the first element in the list
    T front()
    {
        assert(!empty(), "getFirst: list is empty!"); 
        return head.data;
    }

	/// return the last element in the list 
    T back()
    {
        assert(!empty(), "back: list is empty!"); 
        return tail.data;
    }

/+
	// http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html
	/// perform merge sort on this linked list 
	void sort()
	{
		Node* p;
		Node* q;
		Node* e;
		Node* oldhead;
		
		int insize, nmerges, psize, qsize, i;

		/*
		 * Silly special case: if `list' was passed in as null, return
		 * null immediately.
		 */
		if (head is null)
			return;

		insize = 1;

		while (1) 
		{
			p = head;
			oldhead = head;		       /* only used for circular linkage */
			head = null;
			tail = null;

			nmerges = 0;  /* count number of merges we do in this pass */

			while (p !is null) 
			{
				nmerges++;  /* there exists a merge to be done */
				/* step `insize' places along from p */
				q = p;
				psize = 0;
				
				for (i = 0; i < insize; i++) 
				{
					psize++;

					q = q.next;

					if (q is null) break;
				}

				/* if q hasn't fallen off end, we have two lists to merge */
				qsize = insize;

				/* now we have two lists; merge them */
				while (psize > 0 || (qsize > 0 && q !is null)) 
				{

					/* decide whether next element of merge comes from p or q */
					if (psize == 0) 
					{
						/* p is empty; e must come from q. */
						e = q; q = q.next; qsize--;
					} else if (qsize == 0 || q is null) 
					{
						/* q is empty; e must come from p. */
						e = p; p = p.next; psize--;
					} else if (p <= q) {
						/* First element of p is lower (or same);
						 * e must come from p. */
						e = p; p = p.next; psize--;
					} else {
						/* First element of q is lower; e must come from q. */
						e = q; q = q.next; qsize--;
					}

                    /* add the next element to the merged list */
					if (tail !is null) 
					{
						tail.next = e;
					} 
					else 
					{
						head = e;
					}
                    e.prev = tail;

					tail = e;
				}

				/* now p has stepped `insize' places along, and q has too */
				p = q;
			}
		
			tail.next = null;

			/* If we have done only one merge, we're finished. */
			if (nmerges <= 1)   /* allow for nmerges==0, the empty list case */
				return;

			/* Otherwise repeat, merging lists twice the size */
			insize *= 2;
		}
	}
+/

protected:
    Node* head() { return anchor_.next; }
    Node* tail() { return anchor_.prev; }
    void head(Node* h) { anchor_.next = h; }
    void tail(Node* t) { anchor_.prev = t; }

private:

    // Note there's always an "anchor" node, and nodes are stored in circular manner.
    // This makes it work well with STL style iterators that need a distinct begin and
    // end nodes for forward and reverse iteration.
    // Unfortunately it wastes T.sizeof bytes on useless payload data.
    // We could make Node a class and then use inheritance to create AnchorNode and PayloadNode
    // subclasses, but then we have overhead of N*reference.sizeof (i.e. O(N) overhead).
    Node anchor_;

    // Keep track of size so that 'length' checks are O(1) 
    int listSize_ = 0;

    /// The internal node structure with prev/next pointers and the user data payload
    struct Node
    {
        T data;
        Node* prev = null;
        Node* next = null;
    }
}

version(Unittest) {
    import std.io;
    import std.string;
}
unittest {
    version(Unittest){
    writefln("----list tests----");

    bool checkeq(ref list!(int) l, string val)
    {
        char[] o;
        foreach(i; l) {
            o ~= format(i);
        }
        return val==o;
    }


    list!(int) ilist;
    assert(ilist.empty());

    ilist ~= 1;
    assert(! ilist.empty());
    ilist.append(2);
    ilist ~= 3;
    ilist.append(4);
    ilist ~= 5;

    assert(! ilist.empty());

    char[] o;
    foreach(i; ilist) {
        o ~= format(i);
    }
    assert(o == "12345");
    o = null;
    foreach_reverse(i; ilist) {
        o ~= format(i);
    }
    assert(o == "54321");

    // Iterator tests //

    {
        o=null;
        auto it=ilist.begin(),end=ilist.end();
        for(; it != end; ++it) {
            o ~= format(it.val);
        }
        assert(o == "12345");
    }
    {
        o = null;
        auto it=ilist.rbegin(),end=ilist.rend();
        for(; it != end; ++it) {
            o ~= format(it.val);
        }
        assert(o == "54321");
    }    

    // opIn_r tests //

    for (int i=1; i<=5; i++) {
        assert(i in ilist);
    }
    assert(!(99 in ilist));
    assert(!(0 in ilist));

    assert(ilist.back == 5);
    assert(ilist.front == 1);

    // Find test //
    {
        auto it = ilist.find(99);
        assert(it==ilist.end());
        for (int i=1; i<=5; i++) {
            it = ilist.find(i);
            assert(it!=ilist.end());
            assert(it.val == i);
            assert(*it.ptr == i);
        }
    }
    // insert tests //
    {
        auto it = ilist.find(3);
        ilist.insert(it, 9);
        assert( checkeq(ilist, "129345") );
        ilist.insert(ilist.begin(), 8);
        assert( checkeq(ilist, "8129345") );
        ilist.insert(ilist.end(), 7);
        assert( checkeq(ilist, "81293457") );
    }

    // erase tests //
    {
        auto it = ilist.find(3);
        ilist.erase(it);
        assert( checkeq(ilist, "8129457") );
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "129457") );
        auto last = ilist.end; last--;
        ilist.erase(last);
        assert( checkeq(ilist, "12945") );
        
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "2945") );
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "945") );
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "45") );
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "5") );
        ilist.erase(ilist.begin);
        assert( checkeq(ilist, "") );

        assert(ilist.find(1) == ilist.end());
        
        // Try inserting into a previously non-empty list
        assert(ilist.empty());
        ilist ~= 9;
        assert(!ilist.empty());
        assert( checkeq(ilist, "9") );
        assert( ilist.find(9).val == 9 );

        *ilist.find(9).ptr = 8;
        assert( ilist.find(8).val == 8 );
        assert(ilist.length == 1);
    }

    writefln("----list tests complete ----");
    }
    else {
        assert(false, "list.d module unittest requires -version=Unittest");
    }
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
