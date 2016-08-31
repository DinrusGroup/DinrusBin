/*==========================================================================
 * MapT.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * Map struct types for the D Programming Language
 * (Tested under D 1.018, Phobos std library)
 *
 * The two main structs provided by this module are:
 * o  MapT!(key_type, value_type, comparator)
 * o  MultiMapT!(key_type, value_type, comparator)
 * The two main classes provided by this module are:
 * o  map!(key_type, value_type, comparator)
 * o  multimap!(key_type, value_type, comparator)
 *
 * 'MapT' and 'map' are standard ordered maps that only allow one
 * copy of each key.
 *
 * 'MultiMapT' and 'multimap' are maps that allow multiple copies of
 *     the same key (a.k.a. a "Bag")
 *
 * The only difference between the struct types and class types is 
 * just that.  Whether the functionality is provided as a struct or class.
 * 
 * The implementation is based on a RedBlack tree, so sorted key order
 * is always maintained.  That also gives it the following performance
 * characteristics:
 *   insertions - O(lg N)
 *   removals   - O(lg N)
 *   searching  - O(lg N)
 *   sorting    - O(1)
 *   sorted traverals - O(N)
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc., ArcLib team
 * Date: 14 Oct 2007
 * Copyright: (C) 2007  William Baxter
 * License: zlib/libpng
 */
//===========================================================================
module auxd.OpenMesh.Tools.Utils.MapT;

import auxd.OpenMesh.Tools.Utils.redblacktree;
private alias auxd.OpenMesh.Tools.Utils.redblacktree rbtree;
import std.io : writefln;

public import auxd.OpenMesh.Tools.Utils._MapSetCommon;

private enum MapIterTraits : uint {
    Forward = 0x0,
    Reverse = 0x1,
    KeysOnly = 0x2,
}

/// Iterator type for MapT
struct MapIter(_MapT, uint flavor = MapIterTraits.Forward) {
    private static const bool is_reverse = (flavor & MapIterTraits.Reverse)!=0;
    private static const bool keys_only = (flavor & MapIterTraits.KeysOnly)!=0;

    alias _MapT.key_type key_type;
    alias _MapT.value_type value_type;
    alias _MapT.node_type node_type;
    alias _MapT.tree_type tree_type;
    
    private static MapIter opCall(tree_type _tree, node_type _init) {
        MapIter M; with(M) {
            ptr_ = _init;
            tree_ = _tree;
            if (_init is null) {
                // Null means we're creating the "end" iterator here
                end_state_ = is_reverse ? -1 : 1;
            }
        } return M;
    }

    static if (keys_only) {
        /// Return the key referred to by the iterator
        key_type val() { 
            if (ptr_ is null) { throw new invalid_iterator("iterator out of range"); }
            return ptr_.key; 
        }
    }
    else {
        /// Return the value referred to by the iterator
        value_type val() { 
            if (ptr_ is null) { throw new invalid_iterator("iterator out of range"); }
            return ptr_.value; }

        /// Set the value referred to by the iterator
        void val(value_type v) { 
            if (ptr_ is null) { throw new invalid_iterator("iterator out of range"); }
            return ptr_.value = v;
        }

        /// Return a pointer to the value referred to by the iterator
        value_type* val_ptr() { 
            if (ptr_ is null) { throw new invalid_iterator("iterator out of range"); }
            return &ptr_.value; }
    }

    /// Return the key referred to by the iterator
    key_type key() { assert(ptr_ !is null); return ptr_.key; }

    /// Return the value referred to by the iterator
    value_type value() { assert(ptr_ !is null); return ptr_.value; }

    int opEquals(ref MapIter other) {
        return ptr_ is other.ptr_ && end_state_ == other.end_state_;
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
        static if(is_reverse) {
            if (ptr_ is null && end_state_!=1) {
                throw new invalid_iterator("iterator out of range");
            }
            ptr_=tree_.prev_node(ptr_);
            end_state_ = ptr_ is null ? -1 : 0;
        } else {
            if (ptr_ is null && end_state_!=-1) {
                throw new invalid_iterator("iterator out of range");
            }
            ptr_=tree_.next_node(ptr_);
            end_state_ = ptr_ is null ? 1 : 0;
        }
    }
    void _retreat() {
        assert(ptr_ !is null);
        static if(is_reverse) {
            if (ptr_ is null && end_state_!=-1) {
                throw new invalid_iterator("iterator out of range");
            }
            ptr_=tree_.next_node(ptr_);
            end_state_ = ptr_ is null ? 1 : 0;
        }
        else {
            if (ptr_ is null && end_state_!=1) {
                throw new invalid_iterator("iterator out of range");
            }
            ptr_=tree_.prev_node(ptr_);
            end_state_ = ptr_ is null ? -1 : 0;
        }
    }
private:
    node_type ptr_  = null;
    tree_type tree_  = null;
    byte end_state_ = 0; // -1 for pre-begin, 1 for post-end, 0 for valid
}


template _map_impl_mixin_types(KeyT, ValueT, Compare)
{
    static if(is(typeof(this)==class)) {
        private static const bool is_struct = false;
        alias typeof(this) self_type;
    } else {
        private static const bool is_struct = true;
        alias typeof(*this) self_type;
    }

    alias RedBlackTree!(KeyT,ValueT,Compare) tree_type;
    alias ValueT value_type;
    alias KeyT key_type;
    alias Compare key_compare;
    alias tree_type.node_type node_type;

    alias MapIter!(self_type, MapIterTraits.Forward) iterator;
    alias MapIter!(self_type, MapIterTraits.Reverse) reverse_iterator;
    alias MapIter!(self_type, MapIterTraits.KeysOnly) key_iterator;
    alias MapIter!(self_type, MapIterTraits.KeysOnly|MapIterTraits.Reverse) 
        reverse_key_iterator;

}

template _map_impl_mixin_construct(KeyT, ValueT, Compare)
{
    /// create an empty map
    this(Compare cmp = rbtree._MakeDefaultObject!(Compare)())
    {
        _tree = new tree_type(cmp);
    }

    /// create a map based off of another map
    this(self_type other)
    {
        _tree = new tree_type(other._tree);
    }

    /// make a duplicate of this map, D-style
    self_type dup()
    {
        return new self_type(this);
    }

    /// make this map a duplicate of another
    self_type copy(self_type other)
    {
        _tree.copy(other._tree);
        return this;
    }

    /// Synonym for merge
    self_type opCatAssign( self_type other ) { merge(other); return this; }

}

template _map_impl_mixin_struct_construct(KeyT, ValueT, Compare)
{
    /// create an empty map
    static self_type opCall(Compare cmp = rbtree._MakeDefaultObject!(Compare)())
    {
        self_type S; with (S) {
            _tree = new tree_type(cmp);
        } return S;
    }

    /// create a map based off of another map
    static self_type opCall(self_type other)
    {
        self_type S; with (S) {
            if (!other._tree) return S;
            _tree = new tree_type(other._tree);
        } return S;
    }

    /// make a duplicate of this map, D-style
    self_type dup()
    {
        return self_type(*this);
    }

    /// make this map a deep copy of another
    self_type copy(self_type other)
    {
        _tree.copy(other._tree);
        return *this;
    }

    /// Synonym for merge
    void opCatAssign( self_type other ) { merge(other); }


}

template _map_impl_mixin_public(KeyT, ValueT, Compare)
{
    /// print contents of the map with writefln
    char[] toString()
    {
        static if (is_struct) { if(!_tree) return "map()"; }
        return "map("~_tree.toString()~")";
    }

    /// Synonym for insert
    void opIndexAssign( ValueT value, KeyT key ) { insert(key,value); }

    /// removes the given key,
    /// If the element is not present, raises a KeyException
    void remove (KeyT key)
    {
        if (!discard(key)) {
            throw new KeyException("no such element in map");
        }
    }

    /// Discards the given key from the map,
    /// Returns true if the key was removed, false otherwise.
    bool discard (KeyT key)
    {
        static if (is_struct) { if(!_tree) return false; }
        return _tree.remove(key);
    }

    /// Search for a key in the map and return pointer to it if found,
    /// Return null otherwise.
    ValueT* find_value(KeyT key)
    {
        static if (is_struct) { if(!_tree) return null; }
        
        node_type N = _tree.search(key);
        if (N is null) return null;
        return &N.value;
    }

    /// Search for a key in the map and return an iterator to it if found,
    /// Return the end() iterator otherwise.
    iterator find(KeyT key)
    {
        static if (is_struct) { if(!_tree) return end(); }
        node_type N = _tree.search(key);
        if (N is null) return end();
        return iterator(_tree,N);
    }

    /// Return whether key is in the map
    ///
    /// E.g. 'if (4 in int_map) { ... }'
    /// Returns a pointer to the associated value if present.
    /// Otherwise returns null.  Synonym for find(key).
    ValueT* opIn_r(KeyT key)
    {
        return find_value(key);
    }

    /// Return value associated with a key
    /// Like find() but returns the value itself rather than a pointer to it.
    /// Throws a KeyException if the key is not found.
    ValueT opIndex( KeyT key ) { 
        static if (is_struct) { 
            if(!_tree) throw new KeyException("no such element in map");
        }
        node_type N = _tree.search(key);
        if (N is null) {
            throw new KeyException("no such element in map");
        }
        return N.value;
    }

    /// Search for a key in the map and return pointer to the key that would
    /// be to its left in sorted order.
    /// Return null if the key given is the key of the minimal element.
    ValueT* find_prev_of(KeyT key)
    {
        static if (is_struct) { if(!_tree) return null; }
        node_type N = _tree.search_prev_of(key);
        if (N is null) return null;
        return &N.value;
    }

    /// remove all keys from the map
    void clear()
    {
        static if (is_struct) { if(!_tree) return; }

        _tree.clear();
    }

    /// return tree nodes size
    size_t size()    {  
        return length();
    }
    
    /// return tree nodes size (for compatibility with D's Array concept)
    size_t length()    {  
        static if (is_struct) { if(!_tree) return 0; }
        return _tree.size();  
    }

    /// true if empty
    bool empty()    {  
        static if (is_struct) { if(!_tree) return true; }
        return _tree.empty(); 
    }

    /// merge keys from other map into this one (union, but that's a keyword)
    void merge(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        _tree.merge(other._tree);
    }

    /// A = A isect B. Remove all keys present in this map that are
    /// not in the other.
    void difference(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        _tree.intersect(other._tree);
    }

    /// remove all keys present in the other map from this one
    void difference(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        _tree.difference(other._tree);
    }


    /// remove all keys present in the other map from this one
    void difference(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        _tree.difference(other._tree);
    }

    /// Foreach iterator forward through the values
    /// This is guaranteed to iterate in sorted order.
    int opApply(int delegate(inout ValueT) dg)
    {
        static if (is_struct) { if(!_tree) return 0; }
        return _tree.opApply(dg);
    }

    /// Foreach iterator forward through the keys and values
    /// This is guaranteed to iterate in sorted order.
    int opApply(int delegate(ref KeyT, ref ValueT) dg)
    {
        static if (is_struct) { if(!_tree) return 0; }
        return _tree.opApply(dg);
    }


    iterator begin() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return iterator(_tree,_tree.search_min());
    }
    iterator end() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return iterator(_tree,null);
    }
    key_iterator keys_begin() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return key_iterator(_tree,_tree.search_min());
    }
    key_iterator keys_end() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return key_iterator(_tree,null);
    }
    reverse_iterator reverse_begin() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return reverse_iterator(_tree,_tree.search_max());
    }
    reverse_iterator reverse_end() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return reverse_iterator(_tree,null);
    }

}

template _map_impl_mixin_private(KeyT,ValueT,Compare)
{
    // The red black tree is the only data.
    RedBlackTree!(KeyT,ValueT,Compare) _tree = null;

    /// returns whether the map data structure is valid or not
    /// (just for internal debugging)
    int is_valid() { return _tree.is_valid(); }
}

//============================================================================
/** The MapT struct is a standard tree based map type.
 * 
 *  Unlike D's built-in associative arrays, MapT uses a balanced binary tree
 *  data structure. This means most operations are O(lg N) rather than O(1),
 *  however, it also means that the list is always maintained in sorted order,
 *  so sorted traversals can be done at any time with no overhead.
 */
struct MapT(KeyT, ValueT, Compare=_GenericLess!(KeyT))
{
    mixin _map_impl_mixin_types!(KeyT, ValueT, Compare);
    mixin _map_impl_mixin_struct_construct!(KeyT,ValueT,Compare);
    mixin _map_impl_mixin_public!(KeyT,ValueT,Compare);

    /// insert value into the set
    /// Return true if it was actually added,
    /// or false if the item was already present.
    bool insert( KeyT key, ValueT value )
    {
        if(!_tree) _tree=new tree_type;
        return _tree.insert(key,value);
    }

private:
    mixin _map_impl_mixin_private!(KeyT,ValueT,Compare);
}


//============================================================================
/** The MultiMapT struct is a map type that allows duplicates.
 * 
 *  Unlike D's built-in associative arrays, map uses a balanced binary tree
 *  data structure. This means most operations are O(lg N) rather than O(1),
 *  however, it also means that the list is always maintained in sorted order,
 *  so sorted traversals can be done at any time with no overhead.
 */
struct MultiMapT(KeyT, ValueT, Compare=_GenericLess!(KeyT))
{
    mixin _map_impl_mixin_types!(KeyT, ValueT, Compare);
    mixin _map_impl_mixin_struct_construct!(KeyT,ValueT,Compare);
    mixin _map_impl_mixin_public!(KeyT,ValueT,Compare);

    /// Insert the value into the set.
    /// Multiset allows for multiple copies of the same value, so
    /// this will always succeed.
    void insert( KeyT key, ValueT value )
    {
        if (!_tree) _tree = new tree_type;
        _tree.insert_unconditional(key,value);
    }

private:
    mixin _map_impl_mixin_private!(KeyT,ValueT,Compare);
}


//============================================================================
/** The map class is a map standard map tree based type.
 * 
 *  Unlike D's built-in associative arrays, map uses a balanced binary tree
 *  data structure. This means most operations are O(lg N) rather than O(1),
 *  however, it also means that the list is always maintained in sorted order,
 *  so sorted traversals can be done at any time with no overhead.
 */
class map(KeyT, ValueT, Compare=_GenericLess!(KeyT))
{
    mixin _map_impl_mixin_types!(KeyT, ValueT, Compare);
    mixin _map_impl_mixin_construct!(KeyT,ValueT,Compare);
    mixin _map_impl_mixin_public!(KeyT,ValueT,Compare);

    /// insert value into the set
    /// Return true if it was actually added,
    /// or false if the item was already present.
    bool insert( KeyT key, ValueT value )
    {
        return _tree.insert(key,value);
    }

private:
    mixin _map_impl_mixin_private!(KeyT,ValueT,Compare);
}


//============================================================================
/** The multimap class is a map type that allows duplicates.
 * 
 *  Unlike D's built-in associative arrays, multimap uses a balanced
 *  binary tree data structure. This means most operations are O(lg N)
 *  rather than O(1), however, it also means that the list is always
 *  maintained in sorted order, so sorted traversals can be done at
 *  any time with no overhead.
 */
class multimap(KeyT, ValueT, Compare=_GenericLess!(KeyT))
{
    mixin _map_impl_mixin_types!(KeyT, ValueT, Compare);
    mixin _map_impl_mixin_construct!(KeyT,ValueT,Compare);
    mixin _map_impl_mixin_public!(KeyT,ValueT,Compare);

    /// Insert the value into the set.
    /// Multiset allows for multiple copies of the same value, so
    /// this will always succeed.
    void insert( KeyT key, ValueT value )
    {
        _tree.insert_unconditional(key,value);
    }

private:
    mixin _map_impl_mixin_private!(KeyT,ValueT,Compare);
}

//============================================================================

unittest{
    string[] words = ["zero","one","two","three","four",
                      "five","six","seven","eight","nine"];
    // Test custop comparator with data & static OpCall
    struct Comp {
        static Comp opCall(int d = 1) { Comp c; c.dirn = d; return c; }

        bool opCall(int a, int b) {
            if (dirn>0) return a<b;
            if (dirn<0) return a>b;
            assert(false, "dirn must be -1 or 1");
        }
        int dirn;
    }
    // For lexicographical ordering test
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

    {
        auto amap = new map!(int,string);

        static assert( is(string==amap.value_type) );
        static assert( is(int==amap.key_type) );

        alias typeof(amap) Map;

        for (int i = 0; i < 10; i++) {
            bool inserted = amap.insert(i,words[i].dup);
            assert(inserted);
        }
        assert(amap.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = amap.insert(i,words[i].dup);
            assert(!inserted);
        }
        assert(amap.size==10);

        // Test opIn
        assert(!(99 in amap));
        assert(5 in amap);

        // Test find
        assert(amap.find(99) == amap.end);
        assert(amap.find(5)  != amap.end  && amap.find(5).value == "five");

        //amap.clear();

        string[int] aacheck;
        foreach(k,v; amap) {
            aacheck[k] = words[k];
            assert(v==words[k]);
        }

        foreach(k,v; aacheck) { assert(k in amap); }
        foreach(k,v; amap) { assert(k in amap); }
        foreach(amap.key_type k,amap.value_type v; amap) { assert(k in amap); }


        Map t2 = new Map(amap); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(int k,string v; t2) { assert(k in t2); }
        foreach(amap.key_type k,amap.value_type v; t2) { assert(k in t2); }

        assert(amap.toString ==
               "map(0:zero, 1:one, 2:two, 3:three, 4:four, "
               "5:five, 6:six, 7:seven, 8:eight, 9:nine)");

        for (int i=-10; i<20; i++) {
            string* n = i in amap;
            if (i>=0 && i<10) {
                assert (n !is null);
            }
            else {
                assert (n is null);
            }
        }

        // test bogus remove
        {
            bool caught = false;
            try {
                amap.remove(99);
            } catch (KeyException) {
                caught = true;
            }
            assert(caught);
        }

        // test bogus discard
        {
            bool ret = amap.discard(99);
            assert(ret==false);
        }

        // test remove & discard -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(amap.is_valid);
            removed[r] = true;
            // Use discard on half, remove on other half
            if (r%2) {
                amap.remove(r);
            }
            else {
                bool ret = amap.discard(r);
                assert(ret);
            }
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in amap) );
            }
        }
        assert(amap.is_valid);
    }
    {
        auto amap = new map!(int,string,Comp);
        for(int i=0; i<10; i++) {
            amap[i] = words[i].dup;
        }
        assert(amap.toString() == 
               "map(0:zero, 1:one, 2:two, 3:three, 4:four, "
               "5:five, 6:six, 7:seven, 8:eight, 9:nine)");

        auto bmap = new map!(int,string,Comp)(Comp(-1));
        for(int i=0; i<10; i++) {
            bmap[i] = words[i].dup;
        }
        assert(bmap.toString() == 
               "map(9:nine, 8:eight, 7:seven, 6:six, 5:five, "
               "4:four, 3:three, 2:two, 1:one, 0:zero)");
    }
    {
        // Test lexicographical ordered pairs with external comparator
        auto amap = new map!(Pair,int,PairLess);

        alias typeof(amap) Map;

        static assert( is(Pair==amap.key_type) );
        static assert( is(Pair==amap.key_type) );

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                amap.insert(Pair(i,j), i+j);
                amap.insert(Pair(j,i), i+j);
            }
        }

        char[] str = amap.toString();
        assert(str=="map((0, 0):0, (0, 1):1, (0, 2):2, (0, 3):3, (1, 0):1, (1, 1):2, (1, 2):3, (1, 3):4, (2, 0):2, (2, 1):3, (2, 2):4, (2, 3):5, (3, 0):3, (3, 1):4, (3, 2):5, (3, 3):6)");

        // Should be 16 distinct values, (though 32 were inserted)
        assert(amap.size==16);

        // Test opIn
        assert(!(Pair(1,9) in amap));
        assert(!(Pair(9,1) in amap));
        assert(Pair(3,2) in amap);

        //amap.clear();

        int[Pair] aacheck;
        foreach(k,v; amap)
            aacheck[k]=k.L+k.R;

        foreach(k,v; aacheck) { assert(k in amap); assert(amap[k]==v); }

        Map t2 = new Map(amap); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(k,v; t2) { assert(k in t2); }
        foreach(amap.key_type k,amap.value_type v; t2) { assert(k in t2); }

        for (int i=-10; i<20; i++) {
            for (int j=-10; j<20; j++) {
                int* n = Pair(i,j) in amap;
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
            assert(amap.is_valid);
            removed[r] = true;
            amap.remove(r);
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    assert( (Pair(i,j) in removed)  ||  (Pair(i,j) in amap) );
                }
            }
        }

        assert(amap.toString() == "map()");

        assert(amap.is_valid);
    }
    {
        // Test merge and difference
        auto t1 = new map!(int,string);
        auto t2 = new map!(int,string);

        t1[1] = words[1].dup;
        t1[9] = words[9].dup;
        t1[7] = words[7].dup;

        t2[2] = words[2].dup;
        t2[9] = words[9].dup;
        t2[8] = words[8].dup;

        t1 ~= t2;

        assert(t1.size == 5);
        assert(1 in t1);
        assert(9 in t1);
        assert(7 in t1);
        assert(2 in t1);
        assert(8 in t1);
        // T2 shouldn't be changed
        assert(t2.size == 3);
        assert(2 in t2);
        assert(9 in t2);
        assert(8 in t2);

        t1.difference(t2);
        assert(t1.size == 2);
        assert(1 in t1);
        assert(7 in t1);

        // T2 still shouldn't be changed
        assert(t2.size == 3);
        assert(2 in t2);
        assert(9 in t2);
        assert(8 in t2);

        // make sure 'merge' ok too
        t1.merge(t2);
        assert(t1.size==5);

        t1.is_valid();
        t2.is_valid();
    }
    {
        // Test multi-map functionality
        auto intmap = new multimap!(int, string);
        alias typeof(intmap) Map;

        for (int i = 0; i < 10; i++) {
            assert(intmap.size==i);
            intmap.insert(i, words[i].dup);
        }
        assert(intmap.size==10);
        // Should not ignore repeats
        for (int i = 0; i < 10; i++) {
            intmap.insert(i, words[i].dup);
        }
        assert(intmap.size==20);

        {
            Map.iterator it = intmap.begin();
            Map.iterator it_end = intmap.end();
            for(int i; it!=it_end; ++it,++i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == words[i/2]);
            }
        }
        {
            Map.reverse_iterator it = intmap.reverse_begin();
            Map.reverse_iterator it_end = intmap.reverse_end();
            for(int i=19; it!=it_end; ++it,--i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == words[i/2]);
            }
        }            
        {
            Map.key_iterator it = intmap.keys_begin();
            Map.key_iterator it_end = intmap.keys_end();
            for(int i; it!=it_end; ++it,++i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == i/2); // val is the key for key iterator
            }
        }

        for (int i=0; i<10; i++) {
            intmap.remove(i);
        }
        assert(intmap.size==10);
        for (int i=0; i<10; i++) {
            intmap.remove(i);
        }
        assert(intmap.size==0);
    }

    ////////////////// MapT struct tests ////////////////////////////

    {
        MapT!(int,string) amap;

        static assert( is(string==amap.value_type) );
        static assert( is(int==amap.key_type) );

        alias typeof(amap) Map;

        for (int i = 0; i < 10; i++) {
            bool inserted = amap.insert(i,words[i].dup);
            assert(inserted);
        }
        assert(amap.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = amap.insert(i,words[i].dup);
            assert(!inserted);
        }
        assert(amap.size==10);

        // Test opIn
        assert(!(99 in amap));
        assert(5 in amap);

        // Test find
        assert(amap.find(99) == amap.end);
        assert(amap.find(5)  != amap.end  && amap.find(5).value == "five");

        //amap.clear();

        string[int] aacheck;
        foreach(k,v; amap) {
            aacheck[k] = words[k];
            assert(v==words[k]);
        }

        foreach(k,v; aacheck) { assert(k in amap); }
        foreach(k,v; amap) { assert(k in amap); }
        foreach(amap.key_type k,amap.value_type v; amap) { assert(k in amap); }


        Map t2 = Map(amap); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(int k,string v; t2) { assert(k in t2); }
        foreach(amap.key_type k,amap.value_type v; t2) { assert(k in t2); }

        assert(amap.toString ==
               "map(0:zero, 1:one, 2:two, 3:three, 4:four, "
               "5:five, 6:six, 7:seven, 8:eight, 9:nine)");

        for (int i=-10; i<20; i++) {
            string* n = i in amap;
            if (i>=0 && i<10) {
                assert (n !is null);
            }
            else {
                assert (n is null);
            }
        }

        // test bogus remove
        {
            bool caught = false;
            try {
                amap.remove(99);
            } catch (KeyException) {
                caught = true;
            }
            assert(caught);
        }

        // test bogus discard
        {
            bool ret = amap.discard(99);
            assert(ret==false);
        }

        // test remove & discard -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(amap.is_valid);
            removed[r] = true;
            // Use discard on half, remove on other half
            if (r%2) {
                amap.remove(r);
            }
            else {
                bool ret = amap.discard(r);
                assert(ret);
            }
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in amap) );
            }
        }
        assert(amap.is_valid);
    }
    {
        auto amap = MapT!(int,string,Comp)();
        for(int i=0; i<10; i++) {
            amap[i] = words[i].dup;
        }
        assert(amap.toString() == 
               "map(0:zero, 1:one, 2:two, 3:three, 4:four, "
               "5:five, 6:six, 7:seven, 8:eight, 9:nine)");

        auto bmap = MapT!(int,string,Comp)(Comp(-1));
        for(int i=0; i<10; i++) {
            bmap[i] = words[i].dup;
        }
        assert(bmap.toString() == 
               "map(9:nine, 8:eight, 7:seven, 6:six, 5:five, "
               "4:four, 3:three, 2:two, 1:one, 0:zero)");
    }
    {
        auto amap = MapT!(Pair,int,PairLess)();

        alias typeof(amap) Map;

        static assert( is(Pair==amap.key_type) );
        static assert( is(Pair==amap.key_type) );

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                amap.insert(Pair(i,j), i+j);
                amap.insert(Pair(j,i), i+j);
            }
        }

        char[] str = amap.toString();
        assert(str=="map((0, 0):0, (0, 1):1, (0, 2):2, (0, 3):3, (1, 0):1, (1, 1):2, (1, 2):3, (1, 3):4, (2, 0):2, (2, 1):3, (2, 2):4, (2, 3):5, (3, 0):3, (3, 1):4, (3, 2):5, (3, 3):6)");

        // Should be 16 distinct values, (though 32 were inserted)
        assert(amap.size==16);

        // Test opIn
        assert(!(Pair(1,9) in amap));
        assert(!(Pair(9,1) in amap));
        assert(Pair(3,2) in amap);

        //amap.clear();

        int[Pair] aacheck;
        foreach(k,v; amap)
            aacheck[k]=k.L+k.R;

        foreach(k,v; aacheck) { assert(k in amap); assert(amap[k]==v); }

        Map t2 = Map(amap); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(k,v; t2) { assert(k in t2); }
        foreach(amap.key_type k,amap.value_type v; t2) { assert(k in t2); }

        for (int i=-10; i<20; i++) {
            for (int j=-10; j<20; j++) {
                int* n = Pair(i,j) in amap;
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
            assert(amap.is_valid);
            removed[r] = true;
            amap.remove(r);
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    assert( (Pair(i,j) in removed)  ||  (Pair(i,j) in amap) );
                }
            }
        }

        assert(amap.toString() == "map()");

        assert(amap.is_valid);
    }
    {
        // Test merge and difference
        auto t1 = MapT!(int,string)();
        auto t2 = MapT!(int,string)();

        t1[1] = words[1].dup;
        t1[9] = words[9].dup;
        t1[7] = words[7].dup;

        t2[2] = words[2].dup;
        t2[9] = words[9].dup;
        t2[8] = words[8].dup;

        t1 ~= t2;

        assert(t1.size == 5);
        assert(1 in t1);
        assert(9 in t1);
        assert(7 in t1);
        assert(2 in t1);
        assert(8 in t1);
        // T2 shouldn't be changed
        assert(t2.size == 3);
        assert(2 in t2);
        assert(9 in t2);
        assert(8 in t2);

        t1.difference(t2);
        assert(t1.size == 2);
        assert(1 in t1);
        assert(7 in t1);

        // T2 still shouldn't be changed
        assert(t2.size == 3);
        assert(2 in t2);
        assert(9 in t2);
        assert(8 in t2);

        // make sure 'merge' ok too
        t1.merge(t2);
        assert(t1.size==5);

        t1.is_valid();
        t2.is_valid();
    }
    {
        // Test multi-map functionality
        auto intmap = MultiMapT!(int, string)();
        alias typeof(intmap) Map;

        for (int i = 0; i < 10; i++) {
            assert(intmap.size==i);
            intmap.insert(i, words[i].dup);
        }
        assert(intmap.size==10);
        // Should not ignore repeats
        for (int i = 0; i < 10; i++) {
            intmap.insert(i, words[i].dup);
        }
        assert(intmap.size==20);

        {
            Map.iterator it = intmap.begin();
            Map.iterator it_end = intmap.end();
            for(int i; it!=it_end; ++it,++i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == words[i/2]);
            }
        }
        {
            Map.reverse_iterator it = intmap.reverse_begin();
            Map.reverse_iterator it_end = intmap.reverse_end();
            for(int i=19; it!=it_end; ++it,--i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == words[i/2]);
            }
        }            
        {
            Map.key_iterator it = intmap.keys_begin();
            Map.key_iterator it_end = intmap.keys_end();
            for(int i; it!=it_end; ++it,++i) {
                assert(it.key == i/2);
                assert(it.value == words[i/2]);
                assert(it.val == i/2); // val is the key for key iterator
            }
        }

        for (int i=0; i<10; i++) {
            intmap.remove(i);
        }
        assert(intmap.size==10);
        for (int i=0; i<10; i++) {
            intmap.remove(i);
        }
        assert(intmap.size==0);
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
