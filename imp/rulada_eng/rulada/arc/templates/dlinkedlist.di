/******************************************************************************* 

	A templated doubly linked list container
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		A templated doubly linked list container

	Examples:      
	---------------------
	import arc.templates.dlinkedlist; 

	int main() {

	   // create linked list of integers
	   dlinkedlist!(int) list = new dlinkedlist!(int); 

	   // add 10 numbers to it
	   for (int i = 0; i < 10; i++)
		  list.add(i);

	   // iterate through list and print numbers, plus remove number 5
	   while (!list.last)
	   {
		   writefln(list.data);

		   // remove number 5 when we encounter it in list
		   if (list.data == 5)
			  list.remove;
	   }

	   // clear entire contents of list
	   list.clear(); 

	   // remove it from memory
	   delete list; 

	   return 0;
	}
	---------------------

*******************************************************************************/

module arc.templates.dlinkedlist; 

import std.io; 

/*******************************************************************************

   Hook our serializer up 

*******************************************************************************/
static this()
{
//   new factory.type!(dlinkedlist);
}


/*******************************************************************************

   Templated doubly-linked list class

*******************************************************************************/
class dlinkedlist (T)
{
  public:

   /*******************************************************************************
   
      Constructor and destructor here, right now they do nothing
   
   *******************************************************************************/
   this() {}
   ~this() { clear(); }

   /*
         a) create new node on da heap and implant our data inside it

         b) if this is the first thing to go into the list, add straight in
            b1) only thing in list, so its prev and next must be null
            b2) only thing in list, so head and tail must point to it

         c) if there is already stuff in the list, add it on the end
            c1) make the last item point to this new item, instead of 'null'
            c2) make this new item's previous point to the last item
            c3) make this new items 'next' be null, since it is added on the end
            c4) reset the tail pointer to point to our new last item

         d) increment the size of our list
   
   */

   /// add an item to the list
   void add(T newData)
   {
      // a
      Node item = new Node; 
      item.data = newData; 
      
      // b
      if (head is null) // first item in list
      {
         // b1
         item.next = null;
         item.prev = null;

         // b2 
         head = item;
         tail = item; // update tail
      } 

      // c
      else // add on to the end
      {
         // c1
         tail.next = item; 

         // c2
         item.prev = tail;

         // c3
         item.next = null;

         // c4
         tail = item; 
      }

      // d
      listSize++;
   }

   /*
   
      Remove the current node from the list

      Also, there are 4 cases that need to be handled seperately for a remove, ...
         1) item is the middle (most likely case)
         2) item is the last item
         3) item is the first item (with stuff after it)
         4) item is the only item
      
         a) if we are dealing with a middle remove
            a1) switcheroo the pointers, so that 'item' is not in the list

         b) if we are dealing with an end remove
            b1) have tail point to the previous item
            b2) set the previous's item next to null

         c) if we are dealing with a beginning remove
            c1) set head to the next pointer in list
            c2) set the next pointers prev to null

         d) if we are dealing with removing the last item in the list
            d1) just set head and tail to null

         e) crash horribly if none of these scenarios were executed

         f) remove item from existance and decrement size 
   
   */

   /// remove current node from the list
   void remove() 
   {
      if (curr is null) return;

      // a
      if (curr.prev !is null && curr.next !is null) 
      {
         // a1
         curr.next.prev = curr.prev;
         curr.prev.next = curr.next;
      }
      // b
      else if (curr.prev !is null && curr.next is null) 
      {
         // b1
         tail = curr.prev;

         // b2 
         curr.prev.next = null;
      }
      // c
      else if (curr.prev is null && curr.next !is null)
      {
         // c1
         head = curr.next;
      
         // c2
         curr.next.prev = null; 
      }
      // d
      else if (curr.prev is null && curr.next is null)
      {
         // d1
         head = null; 
         tail = null; 
      }
      // e
      else
         assert(false);
      
      // f
      delete curr; 
      curr = null;
      
      listSize--;
   }


   /*******************************************************************************
   
      Returns the length of the list
   
   *******************************************************************************/
   int length() { return listSize; }
   /// returns the size of the list, same as length
   int size() { return listSize; }
   
   /*******************************************************************************
   
      Simple function to tell if list is empty or not
   
   *******************************************************************************/
   bool empty() 
   {
      if (listSize == 0)
      {
         return true;   
      }
      else
      {
         return false;
      }    
   }

   /*******************************************************************************
   
      Just make curr null again
   
   *******************************************************************************/
   void reset() { curr = null; }

	/// goto the head of the list
   void gotoHead() { curr = head; }

   /// goto the tail of the list
   void gotoTail() { curr = tail; }

   /*
   
      Clear all data from the list
   
      a) reset as a precaution, so we don't accidentily just remove half the list
      b) remove everything
   
   */

   /// clear all data from the list
   void clear()
   {
      // a
      reset(); 

      // b
      while (!last)
         remove(); 
   }

	// in implementation
	bool opIn_r(T data)
	{
		foreach(T d; this)
			if (d == data)
				return true; 
				
		return false; 
	}

	// foreach iterator forwards 
	int opApply(int delegate(inout T) dg)
	{
		T curr; 
		int result = 0; 

		backup();
		reset(); 
		
		while (!last)
		{
			curr = data(); 
			result = dg(curr);
			if(result) return result;
		}

		restore(); 

		return result; 
	}

	// foreach iterator backwards 
	int opApplyReverse(int delegate(inout T) dg)
	{
		T curr; 
		int result = 0; 

		backup();
		reset(); 
		
		while (!first)
		{
			curr = data(); 
			result = dg(curr);
			if(result) return result;
		}

		restore(); 

		return result; 
	}
	

   /*******************************************************************************
   
      Returns the current data from the list
   
   *******************************************************************************/
   T data()
   { 
      return curr.data; 
   }

	/// return the first element in the list
   T getFirst()
   in
   {
      if (empty())
      {
         writefln("getFirst: list is empty!"); 
         assert(0); 
      } 

      if (head is null)
      {
         writefln("getFirst: head pointer is null!");
         assert(0); 
      }

   }
   body
   {
      return head.data;
   }

	/// return the last element in the list 
   T getLast()
   in
   {
      if (empty())
      {
         writefln("getLast: list is empty!"); 
         assert(0); 
      } 

      if (tail is null)
      {
         writefln("getLast: tail pointer is null!");
         assert(0); 
      }
   }
   body
   {
      return tail.data; 
   }

	/// return the counter amount
   int count() { return counter; }
   
   /*
   
      Used for traversing from the beginning to the end of the list
      Returns false when still traversing and true when reached the end of the list

      a) if there is nothing in the list, we are done with it
      b) if curr isn't pointing to anything, make it point to head
      c) otherwise...
         c1) go to the next item
         c2) if we have reached the end, then signal to stop
   
   */

	/// returns true if it is the last item, false if not and then it will jump to next item in list 
   bool last()
   {     
      // a
      if (empty())
         return true; 
      
      // b
      if (curr is null)
      {
         counter = 0;
         curr = head;
      }
      // c 
      else
      {
         // c1
         curr = curr.next;
         counter++; 

         // c2
         if (curr is null) 
            return true;  
      }

      return false; 
   }

   /*
   
      Used for traversing from the end to the beginning of the list
      Returns false when still traversing and true when reached the end of the list

      a) if list is empty, we are done with it
      a) if curr isn't pointing to anything, make it point to tail
      b) otherwise...
         b1) go to the prev item
         b2) if we have reached the end, then signal to stop
   
   */

	/// returns true if it is the first item in the list, false and iterates backwards otherwise
   bit first()
   {     
      // a
      if (empty())
         return true;

      // b
      if (curr is null)
      {
         curr = tail;
         counter = listSize; 
      }

      // c 
      else
      {
         // c1
         curr = curr.prev; 
         counter--;

         // c2
         if (curr is null) 
            return true;  
      }

      return false; 
   }

   
   /*
   
      Keep going forward, if reach the end, go right back to the beginning

      b) if curr isn't pointing to anything, make it point to head
      c) otherwise...
         c1) go to the next item
         c2) if we have reached the end, go back to the beginning
   
   */

	/// go forward through the list, if we reach the end then start at beginning again
   int goForward()
   in
   {
      if (empty())
      {
         writefln("goForward: list is empty!");
         assert(0); 
      }
   }
   body
   {     
      // b
      if (curr is null)
      {
         counter = 0;
         curr = head;
      }
      // c 
      else
      {
         // c1
         curr = curr.next;
         counter++; 

         // c2
         if (curr is null)
         {
            counter = 0;
            curr = head;
         } 
      }

      return counter; 
   }


   /*******************************************************************************
   
      Linked list describtion, possibly the most complicated describtion function      
         ever. I have to specialize on not only read vs. write and on
         real vs (class vs struct), because they are all serialized differently!
   
   *******************************************************************************/   
   void describe(AR)(AR s)
   {
      // prevents stupid seg faults
      assert(s !is null); 

      // read/write size of list first
      s.describe(listSize); 

      if (s.writing)
      {
        backup();
        reset();
        while (!last)
         {
            T dat = data;
            s.describe(dat); 
         }
        restore();
      }
      else if (s.reading)
      {
         int saveSize = listSize; 
         listSize = 0;
         
         for (int i = 0; i < saveSize; i++) 
         {
            T dat;
            s.describe(dat); 
            add(dat); 
         }
      }
   }

	/// backup the position in the linked list
	void backup() {
		counter_backup = counter;
		curr_backup = curr;
	}

	/// restore the position in the linked list
	void restore() {
		curr = curr_backup;
		counter = counter_backup;
	}

	// http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html
	/// perform merge sort on this linked list 
	void sort()
	{
		Node p;
		Node q;
		Node e;
		Node oldhead;
		
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

  private:
   /*******************************************************************************
   
      Simple vars to keep track of our heaping list
   
   *******************************************************************************/
   int counter = 0;
   int listSize = 0;
   Node head = null;
   Node tail = null; 
   Node curr = null; 

   Node curr_backup = null;
   int counter_backup = 0;

   /*******************************************************************************
   
      Templated Node structure, holds pointers to previous and next items in 
         the list
   
   *******************************************************************************/
   class Node 
   {
      Node prev;
      T data;
      Node next;
   }
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
