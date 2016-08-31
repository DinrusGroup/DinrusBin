//============================================================================
// redblacktree.d
//    Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
    A Red Black Tree container
    
    Authors:       Bill Baxter (OLM Digital, Inc), ArcLib team, see AUTHORS file 
    Maintainer:    Bill Baxter
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     Bill Baxter (OLM Digital), ArcLib team

    Description:    
    A Red Black Tree container based on the work found 
    <a href="http://eternallyconfuzzled.com/tuts/datastructures/jsw_tut_rbtree.aspx">here.</a>

    Примеры:      
    ---------------------
    import arc.templates.redblacktree; 

    int main() {

        auto RedBlackTree!(int) tree = new RedBlackTree!(int); 

        for (int i = 0; i < 10; i++)
            tree.insert(i); 

            //tree.clear(); 

        auto RedBlackTree!(int) t2 = new RedBlackTree!(int)(tree); 

        foreach(RedBlackTree!(int).node_type n; t2)
            writefln(n.value); 

            writefln(tree);

        RedBlackTree!(int).node_type n = tree.search(8); 
        if (n !is null)
            writefln("found value ", n.value); 
        if (n is null)
            writefln("null"); 

        if (99 in tree)
        {
            writefln("99 is in tree"); 
        }

        writefln("hi");

        if (tree.is_valid)
            writefln("Tree is valid"); 

       return 0;
    }

    ---------------------
*/
//============================================================================
module auxd.OpenMesh.Tools.Utils.redblacktree;

version(Tango) import std.compat;
import std.io; 
import std.string : format;
alias format string_format;

class IndexException : Exception
{
    this() { super(""); }
    this(char[] descrip) {
        super(descrip);
    }
}

/// Makes a comparator in different ways depending on the type
ObjT _MakeDefaultObject(ObjT)() {
    static if(is(ObjT == struct)) {
        static if (is(typeof(ObjT())==ObjT)) {
            // has no-arg static op call "constructor" -- use it
            return ObjT(); 
        }
        else {
            // just a default instance
            ObjT ret; 
            return ret;
        }
    }
    else static if( is(ObjT == class)) {
        static if (is(typeof(new ObjT()))) {
            return new ObjT;
        }
        else {
            // Runtime error!
            assert(false, "Class lacks a default constructor");
        }
    }
    else { static assert(false, "Not a proper functor type"); }
}



struct _GenericLess(T)
{
    static if( is(T==class)) {
        // Pass normally (by reference) for class types
        static bool opCall(T a, T b) {
            return a<b;
        }
    }
    else static if (T.sizeof < 8) {
        // Pass by value for small non-class types
        static bool opCall(T a, T b) {
            return a<b;
        }
    }
    else {
        // Pass by reference for larger non-class types
        static bool opCall(ref T a, ref T b) {
            return a<b;
        }
    }
}

/** Templated Red Black Tree container class 
 *
 *  K is the Key type If V is void then 
 */
class RedBlackTree(KeyT,ValueT=void,CompareT=_GenericLess!(KeyT))
{
public:
    alias KeyT key_type;
    alias ValueT value_type;
    alias CompareT key_compare;
    alias Node node_type;

    static if(is(ValueT==void)) {
        private alias int MaybeValueT;
    } else {
        private alias ValueT MaybeValueT;
    }

    /// create blank tree
    this(CompareT cmp=_MakeDefaultObject!(CompareT)())
    {
        root = null;
        _size = 0; 
        _cmp = cmp;
    }

    /// create a tree based off of another tree 
    this(RedBlackTree tree)
    {
        copy(tree); 
    }


    /// print contents of the tree with writefln 
    void print ()
    {
        print_r( root );
    }
    char[] toString() {
        char[] middle = to_string_r( root );
        if (middle.length>=2) {
            // Chop off the last ', '
            middle = middle[0..$-2]; 
        }
        return middle;
    }

    static if(is(ValueT==void)) {
        /// insert key into the tree without duplication.  
        /// Return true if it was actually added, 
        /// or false if the item was already present.
        bool insert( KeyT key )
        {
            bool is_dupe = false;
            MaybeValueT value;
            root = insert_r(root, key, value, is_dupe);
            root.red = 0;
            if (!is_dupe)
                _size++;
            return !is_dupe;
        }

        /// insert key into the tree without duplication.  
        /// Return true if it was actually added, 
        /// or false if the item was already present.
        void insert_unconditional( KeyT key )
        {
            bool is_dupe = false;
            MaybeValueT value;
            root = insert_r(root, key, value, is_dupe, false);
            root.red = 0;
            assert(!is_dupe);
            _size++;
        }
    } 
    else { // else non-void value type
        /// insert key into the tree without duplication.  
        /// Return true if it was actually added, 
        /// or false if the item was already present.
        bool insert( KeyT key, ValueT value )
        {
            bool is_dupe = false;
            root = insert_r(root, key, value, is_dupe);
            root.red = 0;
            if (!is_dupe)
                _size++;
            return !is_dupe;
        }

        /// insert key into the tree without duplication.  
        /// Return true if it was actually added, 
        /// or false if the item was already present.
        void insert_unconditional( KeyT key, ValueT value )
        {
            bool is_dupe = false;
            root = insert_r(root, key, value, is_dupe, false);
            root.red = 0;
            assert(!is_dupe);
            _size++;
        }
    }


    /// search for a key in the tree and return it if found, null otherwise
    Node search(KeyT key, Node node = null) 
    {
        if(node is null)
            node = root;
            
        while(node !is null) {
            if (_key_eq(key,node.key)) { break; }
            int nResult = (_key_less(key, node.key) ? 0 : 1);
            node = node.link[nResult];
        }
        return node;
    } 

    /// Search for the key in the tree whose key is the greatest less than 'key'.
    /// Return it if found, return null otherwise.
    Node search_prev_of(KeyT key, Node node = null) 
    {
        if (!root)
            return null;

        int _compare(ref KeyT a, ref KeyT b) {
            return  _key_less(a,b) ? 0 : 1;
        }

        // find a first lesser node
        Node p = root;
        while (p) {
            int cmp = _compare(p.key, key);
            if (cmp==0) 
                break;
            p = p.link[LEFT];
        }
        // if we haven't found a first good (lesser than item) candidate, 
        // it means that a "prev" does not exist
        if (!p)
            return null;

        Node candidate = p;
        int cmp = 1; // key is more than p.key
        while (p !is null) {
            int cmpNew;

            // Exactly equal
            if (_key_eq(key,p.key)) {
                return prev_node(p);
            }

            // p.key too high, search left direction
            if (cmp == 0) {
                p = p.link[LEFT];
                if (p) {
                    cmpNew = _compare(key, p.key);
                    if (cmpNew > 0) {
                        int cmpTmp = _compare(p.key, candidate.key);
                        if (cmpTmp > 0)
                            candidate = p;
                    }
                }
            }
            else {
                // p.key too low, search right direction
                if (cmp > 0) {
                    p = p.link[RIGHT];
                    if (p) {
                        cmpNew = _compare(key, p.key);
                        if (cmpNew > 0)
                            candidate = p;
                    }
                }
            }
            // next step
            cmp = cmpNew;
        }
        return candidate;
    }

    // Find the node that preceeds the given node in the tree
    Node prev_node(Node node) {
        if (!node) return search_max();

        if (node.link[LEFT]) {
            // easy case 
            // visit node's left subtree, this gives a curNode with val < node.
            Node curNode = node.link[LEFT];
            // Every node in right subtree of curNode has key > curNode but < node
            while (curNode.link[RIGHT])
                curNode = curNode.link[RIGHT];
            return curNode;
        }
        else 
        {
            // harder case, no left subtree.  Have to look up the tree some.
            // we don't maintain parent links so to find prev node we have to
            // first search for the node and build its parent list (still just O(lg2(N)) though);
            Node[] parents; parents.length = 16; parents.length = 0;// todo: prealloc lg2(N) of storage
            Node p = root;
            while (p && p !is node) {
                parents ~= p;
                int nResult = (!_key_less(p.key, node.key) ? 0 : 1);
                p = p.link[nResult];
            }
            // helper routine
            Node parent_pop() {
                if (!parents.length) return null;
                Node ret = parents[$-1];
                parents.length = parents.length-1;
                return ret;
            }
            // current node and its parent
            Node parent=parent_pop();
            while(parent && node !is parent.link[RIGHT]) {
                node = parent;
                parent = parent_pop();
            }
            return parent;
        }
    }

    // Find the node that follows the given node in the tree
    Node next_node(Node node) {
        if (!node) return search_min();

        if (node.link[RIGHT]) {
            // easy case 
            // visit node's right subtree, this gives a curNode with val >= node.key.
            Node curNode = node.link[RIGHT];
            // Every node in left subtree of curNode has key <= curNode but >= node.key
            while (curNode.link[LEFT])
                curNode = curNode.link[LEFT];
            return curNode;
        }
        else
        {
            // harder case, no right subtree.  Have to look up the tree some.
            // we don't maintain parent links so to find next node we have to
            // first search for the node and build its parent list (still just O(lg2(N)) though);
            Node[] parents; parents.length = 16; parents.length = 0;// todo: prealloc lg2(N) of storage
            Node p = root;
            while (p && p !is node) {
                parents ~= p;
                int nResult = (!_key_less(p.key,node.key) ? 0 : 1);
                p = p.link[nResult];
            }
            // helper routine
            Node parent_pop() {
                if (!parents.length) return null;
                Node ret = parents[$-1];
                parents.length = parents.length-1;
                return ret;
            }
            // current node and its parent
            Node parent=parent_pop();
            while(parent && node !is parent.link[LEFT]) {
                node = parent;
                parent = parent_pop();
            }
            return parent;
        }
    }

    /// search for the minimal element in the tree, return it if found, 
    /// or null if the tree is empty
    Node search_min(Node node = null)
    {
        if (node is null)
            node = root;
        
        while(node !is null) {
            if (node.link[0] is null) {  break; }
            node = node.link[0];
        }            
        return node;
    }

    /// search for the maximal element in the tree, return it if found, 
    /// or null if the tree is empty
    Node search_max(Node node = null)
    {
        if (node is null)
            node = root;
        
        while(node !is null) {
            if (node.link[1] is null) {  break; }
            node = node.link[1];
        }            
        return node;
    }

    /// remove all elements from the tree
    void clear()
    {
        destroy_r(root); 

        _size = 0;
        root = null;
    }
    
    /// returns whether the binary tree is valid or not
    int is_valid() { return assertNode(root); } 

    /// return tree nodes size
    int size()    {  return _size;  }

    /// true if empty
    bool empty()    {  return _size == 0; }

    /// merge elements from tree into this one (union, but that's a keyword)
    void merge(RedBlackTree tree)
    {
        insertContents(tree.root);
    }

    /// remove elements from this tree that aren't in other tree
    void intersect(RedBlackTree tree)
    {
        intersectContents(this.root, tree);
    }

    /// remove another tree's elements from this tree
    void difference(RedBlackTree tree)
    {
        removeContents(tree.root);
    }

    /// make this tree a copy of another  
    void copy(RedBlackTree tree)
    {
        // TODO: we can create a copy faster by skipping the inserts and just 
        //  copying the structure node-by-node.
        clear();
        _cmp  = tree._cmp;
        insertContents(tree.root);
        _size = tree._size;
    }

    /// make a duplicate of this tree, D-style
    RedBlackTree dup()
    {
        return new RedBlackTree(this);
    }

    // foreach iterator forwards on Nodes
    int opApply(int delegate(ref Node) dg)
    {
        return _applyNode!(LEFT,RIGHT)(root, dg);
    }

    // foreach iterator reverse on Nodes
    int opApplyReverse(int delegate(ref Node) dg)
    {
        return _applyNode!(RIGHT,LEFT)(root, dg);
    }

    // foreach iterator forwards on Nodes, plus counter
    int opApply(int delegate(ref uint i, ref Node) dg)
    {
        uint idx=0;
        return _applyNodeCounted!(LEFT,RIGHT)(root, dg, idx);
    }

    static if(is(ValueT==void)) {
        // foreach iterator forwards on keys
        int opApply(int delegate(ref KeyT) dg)
        {
            return _applyKey!(LEFT,RIGHT)(root, dg);
        }
        // foreach iterator iterator reverse on keys
        int opApplyReverse(int delegate(ref KeyT) dg)
        {
            return _applyKey!(RIGHT,LEFT)(root, dg);
        }
    }
    else {
        // foreach iterator forwards on values
        int opApply(int delegate(ref ValueT) dg)
        {
            return _applyValue!(LEFT,RIGHT)(root, dg);
        }
        // reverse iterator on values
        int opApplyReverse(int delegate(ref ValueT) dg)
        {
            return _applyValue!(RIGHT,LEFT)(root, dg);
        }
        // foreach iterator forwards on keys and values
        int opApply(int delegate(ref KeyT, ref ValueT) dg)
        {
            return _applyKeyValue!(LEFT,RIGHT)(root, dg);
        }
        // foreach iterator reverse on keys and values
        int opApplyReverse(int delegate(ref KeyT, ref ValueT) dg)
        {
            return _applyKeyValue!(RIGHT,LEFT)(root, dg);
        }
    }


    // Return whether key is in tree 'if (4 in tree)'
    /// Return its node if found or null otherwise.
    Node opIn_r(KeyT key)
    {
        Node n = search(key);
        return n;
    }

    /// removes the given node
    /// Returns true if a node was removed, false otherwise (node wasn't present)
    bool remove(KeyT key)
    {
        return _pop!(_pop_get_dir_less, _pop_is_found_eq)(key);
    }

    /// Removes the given node and returns it.
    /// If the key was not in the tree, returns null.
    Node pop(KeyT key)
    {
        Node ret;
        _pop!(_pop_get_dir_less, _pop_is_found_eq)(key, &ret);
        return ret;
    }

    /// Removes minimum node and returns it.
    /// If the tree was empty, returns null.
    /// (synonymous with pop_min)
    Node pop()
    {
        return pop_min();
    }


    /// Removes the minimal node and returns it.
    /// If the tree was empty, returns null.
    Node pop_min()
    {
        Node ret;
        _pop!(_pop_get_dir_min,_pop_is_found_min)(KeyT.init, &ret);
        return ret;
    }

    /// Removes the maximum node and returns it.
    /// If the tree was empty, returns null.
    Node pop_max()
    {
        Node ret;
        _pop!(_pop_get_dir_max,_pop_is_found_max)(KeyT.init, &ret);
        return ret;
    }

private: 
    bool _pop_get_dir_less(Node q, KeyT key) {
        return _key_less(q.key, key);
    }
    bool _pop_is_found_eq(Node q, KeyT key) {
        return _key_eq(q.key, key);
    }
    bool _pop_get_dir_min(Node q, KeyT key) {
        return 0;
    }
    bool _pop_is_found_min(Node q, KeyT key) {
        return q.link[0] is null;
    }
    bool _pop_get_dir_max(Node q, KeyT key) {
        return 1;
    }
    bool _pop_is_found_max(Node q, KeyT key) {
        return q.link[1] is null;
    }

    /// Removes the given node.
    /// If the key was in the tree, returns true and sets '*removed' to point to it.
    /// If the key was not in the tree, returns false and sets '*removed' to null.
    bool _pop(alias get_dir, alias is_found)(KeyT key, Node* removed = null)
    {
        if (removed !is null) 
            *removed = null;

        if (root is null) { return false; }

        Node head = new Node(key); /* False tree root */
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
            //dir = _key_less(q.key, key);
            dir = get_dir(q, key);

            /* Save found node */
            //if ( _key_eq(q.key, key) ) {
            if ( is_found(q, key) ) {
                f = q;
            }

            /* Push the red node down */
            if ( !isRed(q) && !isRed(q.link[dir]) ) {
                if ( isRed(q.link[!dir]) ) {
                    p = p.link[last] = singleRotation ( q, dir );
                }
                else if ( !isRed ( q.link[!dir] ) ) 
                {
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

                            if ( isRed ( s.link[last] ) ) {
                                g.link[dir2] = doubleRotation ( p, last );
                            }
                            else if ( isRed ( s.link[!last] ) ) {
                                g.link[dir2] = singleRotation ( p, last );
                            }
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
            if (removed is null) {
                f.key = q.key;
                p.link[p.link[1] is q] = q.link[q.link[0] is null];
                delete q;
            }
            else {
                KeyT tmp = f.key;
                f.key = q.key;
                q.key = tmp;
                p.link[p.link[1] is q] = q.link[q.link[0] is null];
                *removed = q;
            }
            _size--;
        }

        /* Update root and make it black */
        root = head.link[1];
        if ( root !is null )
            root.red = 0;
                
        delete head;
        
        return f !is null;
    }

    bool _key_less(KeyT a, KeyT b) { return _cmp(a,b); }
    bool _key_eq(KeyT a, KeyT b) { return !_cmp(a,b) && !_cmp(b,a);  }

    // copy from leafSrc into leafDst in order inserting one-by-one
    void insertContents(Node leafSrc)
    {
        if (leafSrc !is null)
        {
            insertContents(leafSrc.link[LEFT]);

            static if(is(ValueT==void)) {
                insert(leafSrc.key); 
            } else {
                insert(leafSrc.key, leafSrc.value); 
            }
            
            insertContents(leafSrc.link[RIGHT]);
        }
    }
  
    // Remove all the keys in leafSrc  one-by-one
    void removeContents(Node leafSrc)
    {
        if (leafSrc !is null)
        {
            removeContents(leafSrc.link[LEFT]);

            remove(leafSrc.key);
            
            removeContents(leafSrc.link[RIGHT]);
        }
    }


    // Remove all the keys in leafSrc not in treeCompare one-by-one
    void intersectContents(Node leafSrc, RedBlackTree treeCompare)
    {
        if (leafSrc !is null)
        {
            intersectContents(leafSrc.link[LEFT], treeCompare);

            if (!treeCompare.search(leafSrc.key)) remove(leafSrc.key);
            
            intersectContents(leafSrc.link[RIGHT], treeCompare);
        }
    }


    // iterate tree forwards or backwards
    int _applyNode(int pre=LEFT,int post=RIGHT)(Node node, int delegate(inout Node) dg)
    {
        int result = 0;
      
        while(node !is null) 
        {
            result = _applyNode!(pre,post)(node.link[pre], dg);
            if (result) return result;

            result = dg(node);
            if (result) return result;
        
            node = node.link[post];
        }

        return result;        
    }

    // iterate tree forwards or backwards w/counter w/counter
    int _applyNodeCounted(int pre=LEFT,int post=RIGHT)(Node node, int delegate(ref uint i, ref Node) dg, ref uint idx)
    {
        int result = 0;
      
        while(node !is null) 
        {
            result = _applyNodeCounted!(pre,post)(node.link[pre], dg,idx);
            if (result) return result;

            result = dg(idx,node); idx++;
            if (result) return result;
        
            node = node.link[post];
        }

        return result;        
    }

    // iterate tree forwards or backwards -- keys
    int _applyKey(int pre=LEFT, int post=RIGHT)(Node node, int delegate(ref KeyT) dg)
    {
        int result = 0;
      
        while(node !is null) 
        {
            result = _applyKey!(pre,post)(node.link[pre], dg);
            if (result) return result;

            result = dg(node.key);
            if (result) return result;
        
            node = node.link[post];
        }

        return result;        
    }

    // iterate tree forwards or backwards -- values
    int _applyValue(int pre=LEFT, int post=RIGHT)(Node node, int delegate(ref ValueT) dg)
    {
        int result = 0;
      
        while(node !is null) 
        {
            result = _applyValue!(pre,post)(node.link[pre], dg);
            if (result) return result;

            result = dg(node.value);
            if (result) return result;
        
            node = node.link[post];
        }

        return result;        
    }


    // iterate tree forwards or backwards -- values
    int _applyKeyValue(int pre=LEFT, int post=RIGHT)(Node node, int delegate(ref KeyT, ref ValueT) dg)
    {
        int result = 0;
      
        while(node !is null) 
        {
            result = _applyKeyValue!(pre,post)(node.link[pre], dg);
            if (result) return result;

            result = dg(node.key, node.value);
            if (result) return result;
        
            node = node.link[post];
        }

        return result;        
    }


    // insert recursive
    Node insert_r (Node node, KeyT key, ref MaybeValueT value, ref bool is_dupe, bool unique=true )
    {
        if ( node is null ) {
            static if(is(ValueT==void)) {
                node = new Node( key );
            } else {
                node = new Node( key, value );
            }
        }
        else if ( !unique || !_key_eq(key, node.key) ) 
        {
            int dir = _key_less(node.key, key);

            node.link[dir] = insert_r ( node.link[dir], key, value, is_dupe, unique );

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
        else {
            is_dupe = true;
            static if(!is(ValueT==void)) {
                // Overwrite previous value with new one
                node.value = value;
            }
        }

        return node;
    }


    // recursive print routine
    void print_r ( Node node )
    {
        if ( node !is null ) {
            print_r ( node.link[LEFT] );
            writefln (node.key);
            print_r ( node.link[RIGHT] );
        }
    }

    // recursive to_string routine
    char[] to_string_r ( Node node )
    {
        char[] ret;
        if ( node !is null ) {
            ret ~= to_string_r ( node.link[LEFT] );
            ret ~= string_format(node.key);
            static if (!is(ValueT==void)) {
                ret ~= string_format(":",node.value);
            }
            ret ~= ", ";
            ret ~= to_string_r ( node.link[RIGHT] );
        }
        return ret;
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

    // assert node -- check that node is valid in the tree
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
            if ( ( ln !is null && !_key_less(ln.key,node.key))
                 || ( rn !is null && !_key_less(node.key, rn.key)))
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
        node.link[!dir] = singleRotation ( node.link[!dir], !dir );
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
        this(KeyT key)
        {
            this.key = key; 
            red = 1; // 1 is red, 0 is black 
            link[LEFT] = null; 
            link[RIGHT] = null; 
        }
        KeyT key;
        static if (!is(ValueT==void)) {
            this(KeyT key, ValueT value)
            {
                this.key = key; 
                this.value = value;
                red = 1; // 1 is red, 0 is black 
                link[LEFT] = null; 
                link[RIGHT] = null; 
            }
            ValueT value;
            string toString() { return std.string.format("%s:%s", key, value); }
        } else {
            string toString() { return std.string.format("%s", key); }
        }
    private:
        int red;
        Node link[2];
    }

    // root node of our tree 
    Node root;
    // number of items in the tree 
    int _size; 
    // the comparision functor
    CompareT _cmp; 
} 

//============================================================================
unittest{
    {
        auto tree = new RedBlackTree!(int);

        static assert( is(void==tree.value_type) );
        static assert( is(int==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        assert(tree.empty);
        assert(tree.search_min() is null);
        assert(tree.search_max() is null);

        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i);
            assert(inserted == true);
            assert(!tree.empty);
        }
        assert(tree.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i);
            assert(inserted == false);
            assert(!tree.empty);
        }
        assert(tree.size==10);

        // Test opIn
        assert(!(99 in tree));
        assert(5 in tree);

        //tree.clear();

        { 
            int i=0;
            foreach(Node n; tree) {
                assert(n.key == i);
                i++;
            }
            foreach_reverse(Node n; tree) {
                i--;
                assert(n.key == i);
            }
        }

        bool[int] aacheck;
        foreach(Node n; tree) 
            aacheck[n.key]=true;

        foreach(k,v; aacheck) { assert(k in tree); }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(int v; tree) { assert(v in tree); }
        foreach(tree.key_type v; tree) { assert(v in tree); }

        foreach_reverse(int v; tree) { assert(v in tree); }
        foreach_reverse(Node n; tree) { assert(n.key in tree); }

        Tree t2 = new Tree(tree); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(Node n; t2) { assert(n.key in t2); }
        foreach(int v; t2) { assert(v in t2); }
        foreach(tree.key_type v; t2) { assert(v in t2); }

        char[] str = tree.toString();
        assert(str=="0, 1, 2, 3, 4, 5, 6, 7, 8, 9");

        for (int i=-10; i<20; i++) {
            Node n = tree.search(i);
            if (i>=0 && i<10) {
                assert (n !is null);
            }
            else {
                assert (n is null);
            }
        }

        {
            Node n;
            n = tree.search_min();
            assert(n.key == 0);
            n = tree.search_max();
            assert(n.key == 9);
        }

        // test bogus removes
        {
            bool ret = tree.remove(99);
            assert(!ret);
            assert(tree.size == 10);
            Node n = tree.pop(99);
            assert(!ret);
            assert(n is null);
        }

        // test remove -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(tree.is_valid);
            removed[r] = true;
            tree.remove(r);
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in tree) );
            }
        }
        assert(tree.empty);
        assert(tree.search_min() is null);
        assert(tree.search_max() is null);
        assert(tree.is_valid);

        // Put some more back in
        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i);
            assert(inserted == true);
            assert(!tree.empty);
        }
        t2 = tree.dup;
        // Pop them out one by one
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop(i);
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
        }
        assert( tree.pop(0) is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one by one with pop() (== pop_min)
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
        }
        assert( tree.pop_min() is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one by one with pop_min
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop_min();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
        }
        assert( tree.pop_min() is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one-by-one in reverse with pop_max
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop_max();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == 9-i);
        }
        assert( tree.pop_max() is null );
        assert(tree.empty);
        

    }

    {
        // Test lexicographical ordered pairs with external comparator
        struct Pair {
            int L,R;
            static Pair opCall(int L, int R) {
                Pair ret; ret.L=L; ret.R=R; return ret;
            }
            char[] toString() {
                return string_format("(%d, %d)", L,R);
            }
        }
        struct PairLess {
            static bool opCall(ref Pair a, ref Pair b) {
                if (a.L<b.L) { return true; }
                if (a.L>b.L) { return false; }
                if (a.R<b.R) { return true; }
                return false;
            }
        }
        auto tree = new RedBlackTree!(Pair,void,PairLess);

        static assert( is(Pair==tree.key_type) );
        static assert( is(Pair==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                tree.insert(Pair(i,j));
                tree.insert(Pair(j,i));
            }
        }

        char[] str = tree.toString();
        assert(str=="(0, 0), (0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3), (2, 0), (2, 1), (2, 2), (2, 3), (3, 0), (3, 1), (3, 2), (3, 3)");


        // Should be 16 distinct values, (though 32 were inserted)
        assert(tree.size==16);

        // Test opIn
        assert(!(Pair(1,9) in tree));
        assert(!(Pair(9,1) in tree));
        assert(Pair(3,2) in tree);

        //tree.clear();

        bool[Pair] aacheck;
        foreach(Node n; tree) 
            aacheck[n.key]=true;

        foreach(k,v; aacheck) { assert(k in tree); }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(Pair v; tree) { assert(v in tree); }
        foreach(tree.key_type v; tree) { assert(v in tree); }

        Tree t2 = new Tree(tree); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(Node n; t2) { assert(n.key in t2); }
        foreach(Pair v; t2) { assert(v in t2); }
        foreach(tree.key_type v; t2) { assert(v in t2); }

        for (int i=-10; i<20; i++) {
            for (int j=-10; j<20; j++) {
                Node n = tree.search(Pair(i,j));
                if (i>=0 && i<4 && j>=0 && j<4) {
                    assert (n !is null);
                }
                else {
                    assert (n is null);
                }
            }
        }

        // test remove -- remove them all 1 by 1
        Pair[] to_remove = [
            Pair(0, 0),
            Pair(0, 1),
            Pair(0, 2),
            Pair(0, 3),
            Pair(1, 0),
            Pair(1, 1),
            Pair(1, 2),
            Pair(1, 3),
            Pair(2, 0),
            Pair(2, 1),
            Pair(2, 2),
            Pair(2, 3),
            Pair(3, 0),
            Pair(3, 1),
            Pair(3, 2),
            Pair(3, 3), ];
        bool[Pair] removed;
        foreach(r; to_remove) {
            assert(tree.is_valid);
            removed[r] = true;
            tree.remove(r);
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    assert( (Pair(i,j) in removed)  ||  (Pair(i,j) in tree) );
                }
            }
        }

        assert(tree.toString()=="");

        assert(tree.is_valid);
    }
    {
        // Test lexicographical ordered pairs with an opCmp defined
        struct CPair {
            int L,R;
            int opCmp(CPair that) {
                if (L < that.L) { return -1; }
                if (L > that.L) { return  1; }
                if (R < that.R) { return -1; }
                if (R > that.R) { return  1; }
                return 0;
            }
            char[] toString() {
                return string_format("(%d, %d)", L,R);
            }
        }
        auto tree = new RedBlackTree!(CPair);

        static assert( is(CPair==tree.key_type) );
        static assert( is(CPair==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                tree.insert(CPair(i,j));
                tree.insert(CPair(j,i));
            }
        }

        // Should be 16 distinct values, (though 32 were inserted)
        assert(tree.size==16);

        // Test opIn
        assert(!(CPair(1,9) in tree));
        assert(!(CPair(9,1) in tree));
        assert(CPair(3,2) in tree);

        //tree.clear();

        bool[CPair] aacheck;
        foreach(Node n; tree) 
            aacheck[n.key]=true;

        foreach(k,v; aacheck) { assert(k in tree); }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(CPair v; tree) { assert(v in tree); }
        foreach(tree.key_type v; tree) { assert(v in tree); }

        assert(tree.is_valid());

    }
    {
        // Test lexicographical ordered pairs on CLASS with an opCmp defined
        class KPair {
            this(int i, int j) { L=i; R=j; }
            int L,R;
            int opCmp(KPair that) {
                if (L < that.L) { return -1; }
                if (L > that.L) { return  1; }
                if (R < that.R) { return -1; }
                if (R > that.R) { return  1; }
                return 0;
            }
            char[] toString() {
                return string_format("(%d, %d)", L,R);
            }
        }
        auto tree = new RedBlackTree!(KPair);

        static assert( is(KPair==tree.key_type) );
        static assert( is(KPair==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                tree.insert(new KPair(i,j));
                tree.insert(new KPair(j,i));
            }
        }

        // Should be 16 distinct values, (though 32 were inserted)
        assert(tree.size==16);

        // Test opIn
        assert(!(new KPair(1,9) in tree));
        assert(!(new KPair(9,1) in tree));
        assert(new KPair(3,2) in tree);

        //tree.clear();

        bool[KPair] aacheck;
        foreach(Node n; tree) 
            aacheck[n.key]=true;

        foreach(k,v; aacheck) { assert(k in tree); }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(KPair v; tree) { assert(v in tree); }
        foreach(tree.key_type v; tree) { assert(v in tree); }

        assert(tree.is_valid());

    }
    {
        // Test lexicographical ordered pairs on CLASS with external comparator defined
        class CKPair {
            this(int i, int j) { L=i; R=j; }
            int L,R;
            char[] toString() {
                return string_format("(%d, %d)", L,R);
            }
        }
        struct CKPairLess {
            static bool opCall(ref CKPair a, ref CKPair b) {
                if (a.L<b.L) { return true; }
                if (a.L>b.L) { return false; }
                if (a.R<b.R) { return true; }
                return false;
            }
        }
        auto tree = new RedBlackTree!(CKPair,void,CKPairLess);

        static assert( is(CKPair==tree.key_type) );
        static assert( is(CKPair==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                tree.insert(new CKPair(i,j));
                tree.insert(new CKPair(j,i));
            }
        }

        // Should be 16 distinct values, (though 32 were inserted)
        assert(tree.size==16);

        // Test opIn
        assert(!(new CKPair(1,9) in tree));
        assert(!(new CKPair(9,1) in tree));
        assert(new CKPair(3,2) in tree);

        //tree.clear();

        bool[CKPair] aacheck;
        foreach(Node n; tree) 
            aacheck[n.key]=true;

        foreach(k,v; aacheck) { assert(k in tree); }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(CKPair v; tree) { assert(v in tree); }
        foreach(tree.key_type v; tree) { assert(v in tree); }

        assert(tree.is_valid());

    }
    {
        // Test multi-set functionality
        auto tree = new RedBlackTree!(int);
        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        for (int i = 0; i < 10; i++) {
            assert(tree.size==i);
            tree.insert_unconditional(i);
        }
        assert(tree.size==10);
        // Should not ignore repeats
        for (int i = 0; i < 10; i++) {
            tree.insert_unconditional(i);
        }
        assert(tree.size==20);

        for (int i=0; i<10; i++) {
            tree.remove(i);
        }
        assert(tree.size==10);
        for (int i=0; i<10; i++) {
            tree.remove(i);
        }
        assert(tree.size==0);
    }

    // Test usage as a map
    {
        auto tree = new RedBlackTree!(int, string);

        static assert( is(string==tree.value_type) );
        static assert( is(int==tree.key_type) );

        alias typeof(tree) Tree;
        alias Tree.node_type Node;

        assert(tree.empty);
        assert(tree.search_min() is null);
        assert(tree.search_max() is null);

        string[] words =["zero","one","two","three","four",
                         "five","six","seven","eight","nine","ten"];

        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i,words[i].dup);
            assert(inserted == true);
            assert(!tree.empty);
        }
        assert(tree.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i,words[i].dup);
            assert(inserted == false);
            assert(!tree.empty);
        }
        assert(tree.size==10);

        // Test opIn
        assert(!(99 in tree));
        assert(5 in tree);
        assert((5 in tree).value == "five");

        //tree.clear();

        { 
            int i=0;
            foreach(Node n; tree) {
                assert(n.key == i);
                assert(n.value == words[i]);
                i++;
            }
            foreach_reverse(Node n; tree) {
                i--;
                assert(n.key == i);
                assert(n.value == words[i]);
            }
        }

        string[int] aacheck;
        foreach(uint x,Node n; tree) 
            aacheck[n.key]=words[x].dup;

        foreach(k,v; aacheck) { 
            assert(k in tree); 
            assert((k in tree).value == v);
        }
        foreach(Node n; tree) { assert(n.key in tree); }
        foreach(int k, string v; tree) { assert(k in tree); assert(v == words[k]); }
        foreach(tree.key_type k,string v; tree) { assert(k in tree); assert(v == words[k]); }

        foreach_reverse(int k, string v; tree) { assert(k in tree); assert(v==words[k]); }
        foreach_reverse(Node n; tree) { assert(n.key in tree); }

        Tree t2 = new Tree(tree); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(Node n; t2) { assert(n.key in t2); }
        foreach(int k,string v; t2) { assert(k in t2); }
        foreach(tree.key_type k,tree.value_type v; t2) { assert(k in t2); }

        char[] str = tree.toString();
        assert(str=="0:zero, 1:one, 2:two, 3:three, 4:four, 5:five, 6:six, 7:seven, 8:eight, 9:nine");

        for (int i=-10; i<20; i++) {
            Node n = tree.search(i);
            if (i>=0 && i<10) {
                assert (n !is null);
            }
            else {
                assert (n is null);
            }
        }

        {
            Node n;
            n = tree.search_min();
            assert(n.key == 0);
            assert(n.value == "zero");
            n = tree.search_max();
            assert(n.key == 9);
            assert(n.value == "nine");
        }

        // test bogus removes
        {
            bool ret = tree.remove(99);
            assert(!ret);
            assert(tree.size == 10);
            Node n = tree.pop(99);
            assert(!ret);
            assert(n is null);
        }

        // test remove -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(tree.is_valid);
            removed[r] = true;
            tree.remove(r);
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in tree) );
            }
        }
        assert(tree.empty);
        assert(tree.search_min() is null);
        assert(tree.search_max() is null);
        assert(tree.is_valid);

        // Put some more back in
        for (int i = 0; i < 10; i++) {
            bool inserted = tree.insert(i,words[i].dup);
            assert(inserted == true);
            assert(!tree.empty);
        }
        t2 = tree.dup;
        // Pop them out one by one
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop(i);
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
            assert(popped.value == words[i]);
        }
        assert( tree.pop(0) is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one by one with pop() (== pop_min)
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
            assert(popped.value == words[i]);
        }
        assert( tree.pop_min() is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one by one with pop_min
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop_min();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == i);
            assert(popped.value == words[i]);
        }
        assert( tree.pop_min() is null );
        assert(tree.empty);

        tree = t2.dup;
        // Pop them out one-by-one in reverse with pop_max
        for (int i = 0; i < 10; i++) {
            Node popped = tree.pop_max();
            assert(tree.size == 10-i-1);
            assert(popped !is null);
            assert(popped.key == 9-i);
            assert(popped.value == words[9-i]);
        }
        assert( tree.pop_max() is null );
        assert(tree.empty);
    }

}


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
