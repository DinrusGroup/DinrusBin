/******************************************************************************* 

	A Red Black Tree container
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	A Red Black Tree container based on the work found 
	<a href="http://eternallyconfuzzled.com/tuts/datastructures/jsw_tut_rbtree.aspx">here.</a>

	Examples:      
	---------------------
	import arc.templates.redblacktree; 

	int main() {

		auto RedBlackTree!(int) tree = new RedBlackTree!(int); 

		for (int i = 0; i < 10; i++)
			tree.add(i); 

		//tree.destroy(); 
		//tree.destroy(); 

		auto RedBlackTree!(int) t2 = new RedBlackTree!(int)(tree); 

		foreach(RedBlackTree!(int).Node n; t2)
			writefln(n.data); 

	//	tree.print(); 

		RedBlackTree!(int).Node n = tree.search(8); 
		if (n !is null)
			writefln("found value ", n.data); 
		if (n is null)
			writefln("null"); 

		if (99 in tree)
		{
			writefln("99 is in tree"); 
		}

		writefln("hi");

		if (tree.isValid)
			writefln("Tree is valid"); 

	   return 0;
	}

	---------------------

*******************************************************************************/

module arc.templates.redblacktree;

import std.io; 

/// Templated Red Black Tree container class 
class RedBlackTree(T)
{
  public:
	/// create blank tree
	this()
	{
		root = null;
		size = 0; 
	}

	/// create a tree based off of another tree 
	this(inout RedBlackTree tree)
	{
		duplicate(tree); 
	}

	/// destroy all contents in tree 
	~this()
	{
		// remove all elements from tree and set root null and size to 0 
		destroy(); 
	}

	/// print contents of the tree with writefln 
	void print ()
	{
	  print_r( root );
	}

	/// add data to the tree 
	bool add( T data )
	{
		root = add_r(root, data);
		root.red = 0;
		size++; 
		return true;
	}

	/// search for a key in the tree and return it if found
	Node search(T data, Node node = null) 
	{
		if(node is null)
			node = root;
			
		int nResult;
		
		while(node !is null && (nResult = (data == node.data ? 0 : (data >= node.data ? -1 : 1))) != 0)
			node = node.link[nResult < 0];
			
		return node is null ? null : node;
	}  

	/// remove all data from the tree  
	void destroy()
	{
		destroy_r(root); 

		size = 0;
		root = null;
	}
	
	/// returns whether the binary tree is valid or not
	int isValid() { return assertNode(root); } 

	/// return tree nodes size
	int getSize()    {  return size;  }

	/// true if empty
	bool isEmpty()    {  return size == 0; }

	/// merge data from tree into this one
	void merge(inout RedBlackTree tree)
	{
		createCopy(tree.root);
	}

	/// make this tree a duplicate of another  
	void duplicate(inout RedBlackTree tree)
	{
		destroy();
		createCopy(tree.root); 
		size = tree.size; 
	}

	// foreach iterator forwards 
	int opApply(int delegate(inout Node) dg)
	{
		return applyForward(root, dg); 
	}

	// simply return whether value is in tree 'if (4 in tree)'
	bool opIn_r(T data)
	{
		if (search(data) is null)
			return false;
			
		return true;
	}

	// removes the given node
	int remove (T data)
	{
 		if ( root !is null ) {
 			Node head = new Node(data); /* False tree root */
 			Node q, p, g; /* Helpers */
 			Node f = null;  /* Found item */
 			int dir = RIGHT;
 
			/* Set up helpers */
			q = head;
			g = p = null;
			q.link[RIGHT] = root;

			/* Search and push a red down */
			while ( q.link[dir] !is null ) {
				int last = dir;

				/* Update helpers */
				g = p, p = q;
				q = q.link[dir];
				dir = q.data < data;

				/* Save found node */
				if ( q.data == data )
					f = q;

				/* Push the red node down */
				if ( !isRed(q) && !isRed(q.link[dir]) ) {
					if ( isRed(q.link[!dir]) )
						p = p.link[last] = singleRotation ( q, dir );
					else if ( !isRed ( q.link[!dir] ) ) {
						Node s = p.link[!last];

						if ( s !is null ) {
							if ( !isRed ( s.link[!last] ) && !isRed ( s.link[last] ) ) {
								/* Color flip */
								p.red = 0;
								s.red = 1;
								q.red = 1;
							}
							else {
								int dir2 = g.link[RIGHT] is p;

								if ( isRed ( s.link[last] ) )
									g.link[dir2] = doubleRotation ( p, last );
								else if ( isRed ( s.link[!last] ) )
									g.link[dir2] = singleRotation ( p, last );

								/* Ensure correct coloring */
								q.red = g.link[dir2].red = 1;
								g.link[dir2].link[0].red = 0;
								g.link[dir2].link[1].red = 0;
							}
						}
					}
				}
			}

			/* Replace and remove if found */
			if ( f !is null ) {
				f.data = q.data;
				p.link[p.link[1] is q] = q.link[q.link[0] is null];
				delete q;
			}

			/* Update root and make it black */
			root = head.link[1];
			if ( root !is null )
				root.red = 0;
				
			delete head;
		
			size--;
		}
		
		return 1;
	}

private: 
	// copy from leafSrc into leafDst in order
	void createCopy(Node leafSrc)
	{
		if (leafSrc !is null)
		{
			createCopy(leafSrc.link[LEFT]);

			add(leafSrc.data); 
	   
			createCopy(leafSrc.link[RIGHT]);
		}
	}
  
	// iterate tree forwards 
	int applyForward(Node node, int delegate(inout Node) dg)
	{
      int result = 0;
	  
      while(node !is null) 
      {
        result = applyForward(node.link[LEFT], dg);
        if (result) return result;

        result = dg(node);
        if (result) return result;
        
        node = node.link[RIGHT];
      }

      return result;		
	}

	// add recursive
	Node add_r (Node node, T data )
	{
	  if ( node is null )
		node = new Node( data );
	  else if ( data != node.data ) {
		int dir = node.data < data;

		node.link[dir] =
		  add_r ( node.link[dir], data );

		if ( isRed ( node.link[dir] ) ) {
		  if ( isRed ( node.link[!dir] ) ) {
			/* Case 1 */
			node.red = 1;
			node.link[LEFT].red = 0;
			node.link[RIGHT].red = 0;
		  }
		  else {
			/* Cases 2 & 3 */
			if ( isRed ( node.link[dir].link[dir] ) )
			  node = singleRotation ( node, !dir );
			else if ( isRed ( node.link[dir].link[!dir] ) )
			  node = doubleRotation ( node, !dir );
		  }
		}
	  }

	  return node;
	}
  
	// recursive print routine
	void print_r ( Node node )
	{
	  if ( node !is null ) {
		print_r ( node.link[LEFT] );
		writefln (node.data);
		print_r ( node.link[RIGHT] );
	  }
	}

	// recursive destruction of all tree elements 
	void destroy_r(Node node)
	{
		if (node !is null)
		{
			destroy_r(node.link[LEFT]);
			destroy_r(node.link[RIGHT]);
			delete node; node = null;  
		}
	}

	// assert node 
	int assertNode ( Node node )
	{
	  int lh, rh;

	  if ( node is null )
			return 1;
	  else {
			Node ln = node.link[LEFT];
			Node rn = node.link[RIGHT];
	
			/* Consecutive red links */
			if ( isRed ( node ) ) {
				if ( isRed ( ln ) || isRed ( rn ) ) {
					writefln ( "Red violation" );
					return 0;
				}
			}
	
			lh = assertNode ( ln );
			rh = assertNode ( rn );
	
			/* Invalid binary search tree */
			if ( ( ln !is null && ln.data >= node.data )
				|| ( rn !is null && rn.data <= node.data ) )
			{
				writefln ( "Binary tree violation" );
				return 0;
			}
	
			/* Black height mismatch */
			if ( lh != 0 && rh != 0 && lh != rh ) {
				writefln ( "Black violation" );
				return 0;
			}
	
			/* Only count black links */
			if ( lh != 0 && rh != 0 )
				return isRed ( node ) ? lh : lh + 1;
			else
				return 0;
	  }
	}

	// single rotation 
	Node singleRotation (Node node, int dir )
	{
	  Node save = node.link[!dir];

	  node.link[!dir] = save.link[dir];
	  save.link[dir] = node;

	  node.red = 1;
	  save.red = 0;

	  return save;
	}

	// double rotation 
	Node doubleRotation (Node node, int dir )
	{
	  node.link[!dir] =	singleRotation ( node.link[!dir], !dir );
	  return singleRotation ( node, dir );
	}
  
	// node is red? or not
	int isRed ( Node node )
	{
	  return node !is null && node.red == 1;
	}

	enum { LEFT=0, RIGHT=1 }

	// a tree node 
	static class Node 
	{
		this(T data)
		{
			this.data = data; 
			red = 1; // 1 is red, 0 is black 
			link[LEFT] = null; 
			link[RIGHT] = null; 
		}
		
		T data;
	private:
		int red;
		Node link[2];
	}

	// root node of our tree 
	Node root;
	// number of items in the tree 
	int size; 
} 

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
