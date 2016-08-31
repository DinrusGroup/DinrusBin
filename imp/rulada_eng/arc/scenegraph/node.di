/******************************************************************************* 

	Base classes for all scene graph nodes.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Hierarchy at a glance:
		Node, abstract base - don't use
		  <- SingleParentNode, node with only a single parent
		    <- GroupNode, node that can have children
		      <- CompositeGroupNode, node with an internal hierarchy of nodes and children
		    <- CompositeNode, node with an internal hierarchy of nodes
		  <- MultiParentNode, node that may have multiple parents but must be a leaf

*******************************************************************************/

module arc.scenegraph.node;

import 
	arc.types,
	arc.templates.array; 

static import std.io;

/** 
	Abstract base class for all scene graph nodes. Mainly provides traveral methods.
**/
class Node
{
	/// derived nodes will override these to deal with having parents
	abstract void addParent(Node n);
	abstract void removeParent(Node n);	/// ditto

	/// iterates over all direct children
	int iterateChildren(int delegate(inout Node) dg) { return 0; }
	/// iterates over all direct parents
	int iterateParents(int delegate(inout Node) dg) { return 0; }
	
	/// performs depth first traversal up the tree, starting at this
	int traverseUp(int delegate(inout Node) dg)
	{
		int result = 0;
		if(0 != (result = dg(this)))
			return result;	
		foreach(p; &iterateParents)
			if(0 != (result = p.traverseUp(dg)))
				return result;
		return result;
	}
	
	/// performs a reverse depth first traversal up the tree, ending at this
	int traverseUpReverse(int delegate(inout Node) dg)
	{
		int result = 0;
		foreach(p; &iterateParents)
			if(0 != (result = p.traverseUpReverse(dg)))
				return result;
		if(0 != (result = dg(this)))
			return result;			
		return result;
	}
	
	/// performs depth first traversal down the tree, starting at this
	int traverseDown(int delegate(inout Node) dg)
	{
		int result = 0;
		if(0 != (result = dg(this)))
			return result;		
		foreach(p; &iterateChildren)
			if(0 != (result = p.traverseDown(dg)))
				return result;
		return result;
	}

	/// performs a reverse depth first traversal down the tree, ending at this
	int traverseDownReverse(int delegate(inout Node) dg)
	{
		int result = 0;
		foreach(p; &iterateChildren)
			if(0 != (result = p.traverseDownReverse(dg)))
				return result;
		if(0 != (result = dg(this)))
			return result;		
		return result;
	}
}

/**
	Node that may only have a single parent node
**/
class SingleParentNode : Node
{
	/// add parent
	override void addParent(Node n)
	{
		assert(parent is null, "Node already has a parent.");
		parent = n;
	}
	
	/// remove parent
	override void removeParent(Node n)
	{
		assert(parent is n, "The given node is not this node's parent.");
		parent = null;
	}
	
	/// get parent
	Node getParent()
	{
		return parent;
	}
	
	/// iterate over parents
	override int iterateParents(int delegate(inout Node) dg)
	{
		if(parent !is null)
		{
			Node n = parent;
			return dg(n);
		}
		else
			return 0;
	}

protected:
	Node parent = null;
}

/**
	Node that may have multiple parent nodes.	Must be a leaf node.
**/
class MultiParentNode : Node
{
	/// add parent 
	override void addParent(Node n)
	{
		parents ~= n;
	}
	
	/// remove parent
	override void removeParent(Node n)
	{
		parents.remove(n);
	}
	
	/// iterate over parents 
	override int iterateParents(int delegate(inout Node) dg)
	{
		int result = 0;
		Node n;
		for(size_t i = 0; i < parents.length; ++i)
		{
			n = parents[i];
			if(0 != (result = dg(n)))
				break;
		}
		return result;
	}

	/// make sure MultiParentNode subclasses never have children
	final override int iterateChildren(int delegate(inout Node) dg) { return 0; }
protected:
	Node[] parents;
}

/**
	Interface for nodes that want to be notified when children are
	added or removed somewhere below them in the tree.
**/
interface INotifyOnChildrenAddRemove
{
	void childAdded(Node n);
	void childRemoved(Node n);
}

/**
	Node that can have children
**/
class GroupNode : SingleParentNode
{
	/// adds a child node, returning the added node
	Node addChild(Node node)
	{
		children ~= node;
		node.addParent(this);
		
		// call notify for all child nodes of node
		foreach(addedNode; &node.traverseDown)
		{
			foreach(parentNode; &this.traverseUp)
			{
				INotifyOnChildrenAddRemove notifyNode = cast(INotifyOnChildrenAddRemove) parentNode;
				if(notifyNode)
					notifyNode.childAdded(addedNode);
			}
		}
		
		return node;
	}
	
	/// removes a child node, returning the removed node
	Node removeChild(Node node)
	{
		children.remove(node);
		node.removeParent(this);
		
		// call notify for all child nodes of node
		foreach(removedNode; &node.traverseDown)
		{
			foreach(parentNode; &this.traverseUp)
			{
				INotifyOnChildrenAddRemove notifyNode = cast(INotifyOnChildrenAddRemove) parentNode;
				if(notifyNode)
					notifyNode.childRemoved(removedNode);
			}
		}
		
		return node;
	}
	
	/// deletes a child and all its children
	void deleteChildTree(Node node)
	{
		removeChild(node);
		foreach(n; &node.traverseDownReverse)
		{
			// multi parent nodes are tricky: better not delete them, 
			// but make sure to remove them from their parents
			foreach(c; &n.iterateChildren)
			{					
				if(cast(MultiParentNode)c !is null)
					c.removeParent(n);
				else
					delete c;
			}
		}
		if(!cast(MultiParentNode)node)
			delete node;
	}
	
	/// deletes all children and all their children etc.
	void deleteAllChildTrees()
	{
		while(children.length != 0)
			deleteChildTree(children[0]);
	}
	
	/// returns the number of children this group has
	uint nChildren()
	{
		return children.length;
	}
	
	/// returns the number of children that are exactly of type T
	uint nChildrenOfType(T)()
	{
		uint c = 0;
		
		foreach(n; &iterateChildren)
			if(n.classinfo is T.classinfo)
				++c;
		
		return c;
	}
	
	/// iterate over children
	override int iterateChildren(int delegate(inout Node) dg)
	{
		int result = 0;
		for(size_t i = 0; i < children.length; ++i)
			if(0 != (result = dg(children[i])))
				break;
		return result;
	}
	
	/// iterates only over children that are exactly of type T
	int iterateChildrenOfType(T)(int delegate(inout T) dg)
	{
		int result = 0;
		T tmp;
		for(size_t i = 0; i < children.length; ++i)
			if(children[i].classinfo is T.classinfo)
			{
				tmp = cast(T) children[i];
				if(0 != (result = dg(tmp)))
					break;
			}
		return result;
	}
	
protected:
	Node[] children;	
}

/**
	Node that is made up of many nodes internally and cannot have children
**/
class CompositeNode : SingleParentNode
{
	/** 
		The node given to this constructor becomes the root of this node's 
		internal hierarchy.
	**/
	this(Node composite)
	{
		compositeStart = composite;
		composite.addParent(this);
	}
	
	/// iterate over children
	override int iterateChildren(int delegate(inout Node) dg)
	{
		return dg(compositeStart);
	}	

protected:
	Node compositeStart;
}

/**
	Node that is made up of many nodes internally and can have children
**/
class CompositeGroupNode : SingleParentNode
{
	/**
		Params:
			compositeStart = Becomes the root of the internal hierarchy
			compositeLeaf  = Children added to the CompositeGroupNode will
				actually be added to this node
	**/
	this(Node compositeStart_, GroupNode compositeLeaf_)
	in
	{
		// compositeLeaf must be located below compositeStart
		bool traverseCheck(Node n)
		{
			if(n is compositeLeaf_)
				return true;
			
			foreach(c; &n.iterateChildren)
				if(traverseCheck(c))
					return true;
			
			return false;	
		}
		
		assert(traverseCheck(compositeStart_), "compositeLeaf must be located below compositeStart");
	}
	body
	{
		compositeStart = compositeStart_;
		compositeStart_.addParent(this);
		
		compositeLeaf = compositeLeaf_;
	}
	
	/// add child
	Node addChild(Node node)
	{
		return compositeLeaf.addChild(node);
	}
	
	/// remove child
	Node removeChild(Node node)
	{
		return compositeLeaf.removeChild(node);
	}
	
	/// iterate over children
	override int iterateChildren(int delegate(inout Node) dg)
	{
		return dg(compositeStart);
	}	
	
protected:
	Node compositeStart;
	GroupNode compositeLeaf;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
