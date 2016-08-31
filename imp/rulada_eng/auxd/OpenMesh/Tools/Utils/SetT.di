//============================================================================
// SetT.d - Set types
//     Written in the D Programming Language (http://www.digitalmars.com/d)
//     (Tested under D 1.018, Phobos std library)
/*****************************************************************************
    Set types.

    The two main classes provided by this module are:
    o  set!(value_type, comparator)
    o  multiset!(value_type, comparator)

    'set' is a standard ordered set that only allows one copy of each value.
    'multiset' is a set that allows multiple copies of the same value 
        (a.k.a. what is called a "Bag" in some circles)

    The implementation is based on a RedBlack tree, so sorted order is always
    maintained.  That also gives it the following performance characteristics:
    insertions - O(lg N)
    removals   - O(lg N)
    searching  - O(lg N)
    sorting    - O(1)
    sorted traverals - O(N)

    Author:        Bill Baxter  (wbaxter@gmail.com)
    License:       zlib/libpng license: $(LICENSE) 
*/
//============================================================================
module auxd.OpenMesh.Tools.Utils.SetT;

import auxd.OpenMesh.Tools.Utils.redblacktree;
private alias auxd.OpenMesh.Tools.Utils.redblacktree rbtree;
import std.io : writefln;

public import auxd.OpenMesh.Tools.Utils._MapSetCommon;


private enum SetIterTraits : uint {
    Forward = 0x0,
    Reverse = 0x1,
    KeysOnly = 0x2,
}

/// Iterator type for SetT
struct SetIter(_SetT, uint flavor = SetIterTraits.Forward) {
    private static const bool is_reverse = (flavor & SetIterTraits.Reverse)!=0;
    private static const bool keys_only = (flavor & SetIterTraits.KeysOnly)!=0;

    alias _SetT.value_type key_type;
    alias _SetT.value_type value_type;
    alias _SetT.node_type node_type;
    alias _SetT.tree_type tree_type;
    
    private static SetIter opCall(tree_type _tree, node_type _init) {
        SetIter M; with(M) {
            ptr_ = _init;
            tree_ = _tree;
            if (_init is null) {
                // Null means we're creating the "end" iterator here
                end_state_ = is_reverse ? -1 : 1;
            }
        } return M;
    }

    /// Return the key referred to by the iterator
    value_type val() { 
        if (ptr_ is null) { throw new invalid_iterator("iterator out of range"); }
        return ptr_.key; 
    }

    /// Return the value referred to by the iterator
    value_type value() { assert(ptr_ !is null); return ptr_.key; }

    int opEquals(ref SetIter other) {
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


template _set_impl_mixin_types(T, Compare)
{
    static if(is(typeof(this)==class)) {
        private static const bool is_struct = false;
        alias typeof(this) self_type;
    } else {
        private static const bool is_struct = true;
        alias typeof(*this) self_type;
    }

    alias RedBlackTree!(T,void,Compare) tree_type;
    alias T value_type;
    alias T key_type;
    alias Compare value_compare;
    alias Compare key_compare;
    alias tree_type.node_type node_type;

    alias SetIter!(self_type, SetIterTraits.Forward) iterator;
    alias SetIter!(self_type, SetIterTraits.Reverse) reverse_iterator;
}

template _set_impl_mixin_construct(T, Compare)
{
    /// create an empty set
    this(Compare cmp = rbtree._MakeDefaultObject!(Compare)())
    {
        _tree = new tree_type(cmp);
    }

    /// create a set based off of another set
    this(self_type other)
    {
        _tree = new tree_type(other._tree);
    }

    /// make a duplicate of this set, D-style
    self_type dup()
    {
        return new self_type(this);
    }

    /// make this set a duplicate of another  
    self_type copy(self_type other)
    {
        _tree.copy(other._tree);
        return this;
    }

    /// Synonym for insert
    self_type opCatAssign( T value ) { insert(value); return this; }

    /// Synonym for merge
    self_type opCatAssign( self_type other ) { merge(other); return this; }
}

template _set_impl_mixin_struct_construct(T, Compare)
{
    /// create an empty set
    static self_type opCall(Compare cmp = rbtree._MakeDefaultObject!(Compare)())
    {
        self_type S; with (S) {
            _tree = new tree_type(cmp);
        } return S;
    }

    /// create a set based off of another set
    static self_type opCall(self_type other)
    {
        self_type S; with (S) {
            if (!other._tree) return S;
            _tree = new tree_type(other._tree);
        } return S;
    }

    /// make a duplicate of this set, D-style
    self_type dup()
    {
        return self_type(*this);
    }

    /// make this set a deep copy of another
    self_type copy(self_type other)
    {
        _tree.copy(other._tree);
        return *this;
    }

    /// Synonym for insert
    void opCatAssign( T value ) { insert(value); }

    /// Synonym for merge
    void opCatAssign( self_type other ) { merge(other); }


}

template _set_impl_mixin_public(T, Compare)
{
    /// print contents of the set with writefln 
    char[] toString()
    {
        static if (is_struct) { if(!_tree) return "set()"; }
        return "set("~_tree.toString()~")";
    }

    /// removes the given value,
    /// If the element is not present, raises a KeyException
    void remove (T value)
    {
        if (!discard(value)) {
            throw new KeyException("no such element in set");
        }
    }

    /// Discards the given value from the set,
    /// Returns true if the value was removed, false otherwise.
    bool discard (T value)
    {
        static if (is_struct) { if(!_tree) return false; }
        return _tree.remove(value);
    }


    /// removes and returns the given value,
    /// If the element is not present, raises a KeyException
    T pop (T value)
    {
        static if (is_struct) { 
            if(!_tree) throw new KeyException("no such element in set");
        }
        node_type n = _tree.pop(value);
        if (!n) {
            throw new KeyException("no such element in set");
        }
        return n.key;
    }

    /// removes and returns the minimum value,
    /// If the set is empty, raises a KeyException
    T pop_min()
    {
        static if (is_struct) { 
            if(!_tree) throw new KeyException("no such element in set");
        }
        node_type n = _tree.pop_min();
        if (!n) {
            throw new KeyException("no such element in set");
        }
        return n.key;
    }

    /// removes and returns the maximum value,
    /// If the set is empty, raises a KeyException
    T pop_max()
    {
        static if (is_struct) { 
            if(!_tree) throw new KeyException("no such element in set");
        }
        node_type n = _tree.pop_min();
        if (!n) {
            throw new KeyException("no such element in set");
        }
        return n.key;
    }

    /// Search for a value in the set and return pointer to it if found,
    /// Return null otherwise.
    /// You may NOT change the value returned.  Doing so will corrupt the 
    /// set's internal data structure.
    T* find(T value)
    {
        static if (is_struct) { if(!_tree) return null; }
        node_type N = _tree.search(value);
        if (N is null) return null;
        return &N.key;
    }  

    /// Search for a value in the set and return pointer to the value that would
    /// be to its left in sorted order.
    /// Return null if the value given is the value of the minimal element.
    /// You may NOT change the value returned.  Doing so will corrupt the 
    /// set's internal data structure.
    T* find_prev_of(T value)
    {
        static if (is_struct) { if(!_tree) return null; }
        node_type N = _tree.search_prev_of(value);
        if (N is null) return null;
        return &N.key;
    }  

    /// remove all values from the set
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

    /// merge values from other set into this one (union, but that's a keyword)
    void merge(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree = new tree_type; }
        _tree.merge(other._tree);
    }

    /// A = A isect B.  Remove all values present in this set that are
    /// not in the other
    void intersect(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree = new tree_type; }
        _tree.intersect(other._tree);
    }

    /// A-B remove all values present in the other set from one
    void difference(self_type other)
    {
        static if (is_struct) { if(!_tree) _tree = new tree_type; }
        _tree.difference(other._tree);
    }

    /// Foreach iterator forward through the values
    /// This is guaranteed to iterate in sorted order.
    int opApply(int delegate(inout T) dg)
    {
        static if (is_struct) { if(!_tree) return 0; }
        return _tree.opApply(dg);
    }

    /// Return whether value is in the set 
    /// E.g. 'if (4 in int_set) { ... }'
    T* opIn_r(T value)
    {
        static if (is_struct) { if(!_tree) return null; }
        node_type n = _tree.opIn_r(value);
        if (n) { return &n.key; }
        else { return null; }
    }


    iterator begin() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return iterator(_tree,_tree.search_min());
    }
    iterator end() {
        static if (is_struct) { if(!_tree) _tree=new tree_type; }
        return iterator(_tree,null);
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

template _set_impl_mixin_private(T,Compare)
{
    RedBlackTree!(T,void,Compare) _tree;

    /// returns whether the set data structure is valid or not 
    /// (just for internal debugging)
    int is_valid() { return _tree.is_valid(); }
}

//============================================================================
/** The SetT struct is a standard set type
 *
 * The implementation is based on a balanced binary tree, so
 * most operations are O(lg N).
 */
struct SetT(T, Compare=_GenericLess!(T))
{
    mixin _set_impl_mixin_types!(T,Compare);
    mixin _set_impl_mixin_struct_construct!(T,Compare);
    mixin _set_impl_mixin_public!(T,Compare);

    /// insert value into the set
    /// Return true if it was actually added, 
    /// or false if the item was already present.
    bool insert( T value )
    {
        if (!_tree) _tree = new tree_type;
        return _tree.insert(value);
    }

private:
    mixin _set_impl_mixin_private!(T,Compare);
}


//============================================================================
/** The MultiSetT struct is set type that allows duplicates.
 *
 * The implementation is based on a balanced binary tree, so
 * most operations are O(lg N).
 */
struct MultiSetT(T, Compare=_GenericLess!(T))
{
    mixin _set_impl_mixin_types!(T,Compare);
    mixin _set_impl_mixin_struct_construct!(T,Compare);
    mixin _set_impl_mixin_public!(T,Compare);

    /// Insert the value into the set.
    /// Multiset allows for multiple copies of the same value, so
    /// this will always succeed.
    void insert( T value )
    {
        if (!_tree) _tree = new tree_type;
        _tree.insert_unconditional(value);
    }

private:
    mixin _set_impl_mixin_private!(T,Compare);
}



//============================================================================
/** The set class is a standard set type
 *
 * The implementation is based on a balanced binary tree, so
 * most operations are O(lg N).
 */
class set(T, Compare=_GenericLess!(T))
{
    mixin _set_impl_mixin_types!(T,Compare);
    mixin _set_impl_mixin_construct!(T,Compare);
    mixin _set_impl_mixin_public!(T,Compare);

    /// insert value into the set
    /// Return true if it was actually added, 
    /// or false if the item was already present.
    bool insert( T value )
    {
        return _tree.insert(value);
    }

private:
    mixin _set_impl_mixin_private!(T,Compare);
}


//============================================================================
/** The multiset class is set type that allows duplicates.
 *
 * The implementation is based on a balanced binary tree, so
 * most operations are O(lg N).
 */
class multiset(T, Compare=_GenericLess!(T))
{
    mixin _set_impl_mixin_types!(T,Compare);
    mixin _set_impl_mixin_construct!(T,Compare);
    mixin _set_impl_mixin_public!(T,Compare);

    /// Insert the value into the set.
    /// Multiset allows for multiple copies of the same value, so
    /// this will always succeed.
    void insert( T value )
    {
        _tree.insert_unconditional(value);
    }

private:
    mixin _set_impl_mixin_private!(T,Compare);
}


//============================================================================

/++
class hashset(T)
{
    alias bool[T] table_type;

    alias T value_type;
    alias T key_type;
    //alias Compare value_compare;
    //alias Compare key_compare;

    alias typeof(this) self_type;

    /// create an empty set
    this()
    {
        _table = new table_type();
    }

    /// create a set based off of another set
    this(self_type other)
    {
        _table = new tree_type(other._table);
    }

    /// make a duplicate of this set, D-style
    self_type dup()
    {
        return new self_type(this);
    }

    /// print contents of the set with writefln 
    char[] toString()
    {
        return "set("~_table.toString()~")";
    }

    /// Synonym for insert
    self_type opCatAssign( T value ) { insert(value); return this; }

    /// Synonym for merge
    self_type opCatAssign( self_type other ) { merge(other); return this; }

    /// Insert the value into the set
    bool insert( T value )
    {
        return _table[value] = true;
    }

    /// removes the given value,
    /// If the element is not present, raises a KeyException
    void remove (T value)
    {
        try {
            _table.remove(value);
        }
        catch (ArrayBoundsError e) {
            throw new KeyException("no such element in hashset");
        }
    }

    /// removes and returns the given value,
    /// If the element is not present, raises a KeyException
    T pop (T value)
    {
        if (! (T in _table)) {
            throw new KeyException("no such element in set");
        }
        T ret =  _table.pop(value);
        if (!n) {
        }
        return n.key;
    }

    /// removes and returns the minimum value,
    /// If the set is empty, raises a KeyException
    T pop_min()
    {
        node_type n = _table.pop_min();
        if (!n) {
            throw new KeyException("no such element in set");
        }
        return n.key;
    }

    /// removes and returns the maximum value,
    /// If the set is empty, raises a KeyException
    T pop_max()
    {
        node_type n = _table.pop_min();
        if (!n) {
            throw new KeyException("no such element in set");
        }
        return n.key;
    }

    /// Discards the given value from the set,
    /// Returns true if the value was removed, false otherwise.
    bool discard (T value)
    {
        return _table.remove(value);
    }

    /// Search for a value in the set and return pointer to it if found,
    /// Return null otherwise.
    /// You may NOT change the value returned.  Doing so will corrupt the 
    /// set's internal data structure.
    T* find(T value)
    {
        node_type N = _table.search(value);
        if (N is null) return null;
        return &N.key;
    }  

    /// remove all values from the set
    void clear()
    {
        _table.clear();
    }
    
    /// return tree nodes size
    int size()    {  return _table.size();  }

    /// true if empty
    bool empty()    {  return _table.empty(); }

    /// merge values from other set into this one (union, but that's a keyword)
    void merge(self_type other)
    {
        _table.merge(other._table);
    }

    /// remove all values present in the other set from one
    void difference(self_type other)
    {
        _table.difference(other._table);
    }

    /// make this set a duplicate of another  
    void duplicate(self_type other)
    {
        _table.duplicate(other._table);
    }

    /// Foreach iterator forward through the values
    /// This is guaranteed to iterate in sorted order.
    int opApply(int delegate(inout T) dg)
    {
        return _table.opApply(dg);
    }

    /// Return whether value is in the set 
    /// E.g. 'if (4 in int_set) { ... }'
    T* opIn_r(T value)
    {
        node_type n = _table.opIn_r(value);
        if (n) { return &n.key; }
        else { return null; }
    }

private:

    HashTable _table;
}
++/
//============================================================================

unittest{
    // For custom sort order test
    struct Comp {
        static Comp opCall(int d = 1) { Comp c; c.dirn = d; return c; }

        bool opCall(int a, int b) {
            if (dirn>0) return a<b;
            if (dirn<0) return a>b;
            assert(false, "dirn must be -1 or 1");
        }
        int dirn;
    }        
    // For lexicographical ordered pairs with external comparator
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

    // --------------- TEST CLASS VERSION --------------------------
    {
        auto aset = new set!(int);

        static assert( is(int==aset.key_type) );
        static assert( is(int==aset.key_type) );

        alias typeof(aset) Set;

        for (int i = 0; i < 10; i++) {
            bool inserted = aset.insert(i);
            assert(inserted);
        }
        assert(aset.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = aset.insert(i);
            assert(!inserted);
        }
        assert(aset.size==10);

        // Test opIn
        assert(!(99 in aset));
        assert(5 in aset);

        //aset.clear();

        bool[int] aacheck;
        foreach(int v; aset)
            aacheck[v]=true;

        foreach(k,v; aacheck) { assert(k in aset); }
        foreach(int v; aset) { assert(v in aset); }
        foreach(aset.key_type v; aset) { assert(v in aset); }


        Set t2 = new Set(aset); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(int v; t2) { assert(v in t2); }
        foreach(aset.key_type v; t2) { assert(v in t2); }

        assert(aset.toString == "set(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)");

        for (int i=-10; i<20; i++) {
            int* n = aset.find(i);
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
                aset.remove(99);
            } catch (KeyException) {
                caught = true;
            }
            assert(caught);
        }

        // test bogus discard
        {
            bool ret = aset.discard(99);
            assert(ret==false);
        }

        // test remove & discard -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(aset.is_valid);
            removed[r] = true;
            // Use discard on half, remove on other half
            if (r%2) {
                aset.remove(r);
            }
            else {
                bool ret = aset.discard(r);
                assert(ret);
            }
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in aset) );
            }
        }
        assert(aset.is_valid);
    }
    {
        // Test custop comparator with data & static OpCall
        auto aset = new set!(int,Comp);
        for(int i=0; i<10; i++) {
            aset ~= i;
        }
        assert(aset.toString() == "set(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)");

        auto bset = new set!(int,Comp)(Comp(-1));
        for(int i=0; i<10; i++) {
            bset ~= i;
        }
        assert(bset.toString() == "set(9, 8, 7, 6, 5, 4, 3, 2, 1, 0)");
    }
    {
        // Test lexicographical ordered pairs with external comparator
        auto aset = new set!(Pair,PairLess);

        alias typeof(aset) Set;

        static assert( is(Pair==aset.key_type) );
        static assert( is(Pair==aset.key_type) );

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                aset.insert(Pair(i,j));
                aset.insert(Pair(j,i));
            }
        }

        char[] str = aset.toString();
        assert(str=="set((0, 0), (0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3), (2, 0), (2, 1), (2, 2), (2, 3), (3, 0), (3, 1), (3, 2), (3, 3))");

        // Should be 16 distinct values, (though 32 were inserted)
        assert(aset.size==16);

        // Test opIn
        assert(!(Pair(1,9) in aset));
        assert(!(Pair(9,1) in aset));
        assert(Pair(3,2) in aset);

        //aset.clear();

        bool[Pair] aacheck;
        foreach(v; aset) 
            aacheck[v]=true;

        foreach(k,v; aacheck) { assert(k in aset); }
        foreach(v; aset) { assert(v in aset); }
        foreach(aset.key_type v; aset) { assert(v in aset); }

        Set t2 = new Set(aset); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(v; t2) { assert(v in t2); }
        foreach(aset.key_type v; t2) { assert(v in t2); }

        for (int i=-10; i<20; i++) {
            for (int j=-10; j<20; j++) {
                Pair* n = aset.find(Pair(i,j));
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
            assert(aset.is_valid);
            removed[r] = true;
            aset.remove(r);
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    assert( (Pair(i,j) in removed)  ||  (Pair(i,j) in aset) );
                }
            }
        }

        assert(aset.toString() == "set()");

        assert(aset.is_valid);
    }
    {
        // Test merge and difference
        auto t1 = new set!(int);
        auto t2 = new set!(int);

        t1 ~= 1;
        t1 ~= 9;
        t1 ~= 7;

        t2 ~= 2;
        t2 ~= 9;
        t2 ~= 8;

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
        // Test multi-set functionality
        auto intset = new multiset!(int);
        alias typeof(intset) Set;

        for (int i = 0; i < 10; i++) {
            assert(intset.size==i);
            intset.insert(i);
        }
        assert(intset.size==10);
        // Should not ignore repeats
        for (int i = 0; i < 10; i++) {
            intset.insert(i);
        }
        assert(intset.size==20);

        for (int i=0; i<10; i++) {
            intset.remove(i);
        }
        assert(intset.size==10);
        for (int i=0; i<10; i++) {
            intset.remove(i);
        }
        assert(intset.size==0);
    }

    // --------------- TEST STRUCT VERSION --------------------------

    {
        auto aset = SetT!(int)();

        static assert( is(int==aset.key_type) );
        static assert( is(int==aset.key_type) );

        alias typeof(aset) Set;

        for (int i = 0; i < 10; i++) {
            bool inserted = aset.insert(i);
            assert(inserted);
        }
        assert(aset.size==10);
        // Should ignore repeats
        for (int i = 0; i < 10; i++) {
            bool inserted = aset.insert(i);
            assert(!inserted);
        }
        assert(aset.size==10);

        // Test opIn
        assert(!(99 in aset));
        assert(5 in aset);

        //aset.clear();

        bool[int] aacheck;
        foreach(int v; aset)
            aacheck[v]=true;

        foreach(k,v; aacheck) { assert(k in aset); }
        foreach(int v; aset) { assert(v in aset); }
        foreach(aset.key_type v; aset) { assert(v in aset); }


        Set t2 = Set(aset); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(int v; t2) { assert(v in t2); }
        foreach(aset.key_type v; t2) { assert(v in t2); }

        assert(aset.toString == "set(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)");

        for (int i=-10; i<20; i++) {
            int* n = aset.find(i);
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
                aset.remove(99);
            } catch (KeyException) {
                caught = true;
            }
            assert(caught);
        }

        // test bogus discard
        {
            bool ret = aset.discard(99);
            assert(ret==false);
        }

        // test remove & discard -- remove them all 1 by 1
        int[] to_remove = [7,2,3,5,6,9,4,8,0,1];
        bool[int] removed;
        foreach(r; to_remove) {
            assert(aset.is_valid);
            removed[r] = true;
            // Use discard on half, remove on other half
            if (r%2) {
                aset.remove(r);
            }
            else {
                bool ret = aset.discard(r);
                assert(ret);
            }
            for (int i=0; i<10; i++) {
                assert( (i in removed)  ||  (i in aset) );
            }
        }
        assert(aset.is_valid);
    }
    {
        // Test custop comparator with data & static OpCall
        auto aset = SetT!(int,Comp)();
        for(int i=0; i<10; i++) {
            aset ~= i;
        }
        assert(aset.toString() == "set(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)");

        auto bset = SetT!(int,Comp)(Comp(-1));
        for(int i=0; i<10; i++) {
            bset ~= i;
        }
        assert(bset.toString() == "set(9, 8, 7, 6, 5, 4, 3, 2, 1, 0)");
    }
    {
        // Test lexicographical ordered pairs with external comparator
        auto aset = SetT!(Pair,PairLess)();

        alias typeof(aset) Set;

        static assert( is(Pair==aset.key_type) );
        static assert( is(Pair==aset.key_type) );

        for (int i = 3; i >= 0; i--) {
            for (int j = 3; j >= 0; j--) {
                aset.insert(Pair(i,j));
                aset.insert(Pair(j,i));
            }
        }

        char[] str = aset.toString();
        assert(str=="set((0, 0), (0, 1), (0, 2), (0, 3), (1, 0), (1, 1), (1, 2), (1, 3), (2, 0), (2, 1), (2, 2), (2, 3), (3, 0), (3, 1), (3, 2), (3, 3))");

        // Should be 16 distinct values, (though 32 were inserted)
        assert(aset.size==16);

        // Test opIn
        assert(!(Pair(1,9) in aset));
        assert(!(Pair(9,1) in aset));
        assert(Pair(3,2) in aset);

        //aset.clear();

        bool[Pair] aacheck;
        foreach(v; aset) 
            aacheck[v]=true;

        foreach(k,v; aacheck) { assert(k in aset); }
        foreach(v; aset) { assert(v in aset); }
        foreach(aset.key_type v; aset) { assert(v in aset); }

        Set t2 = Set(aset); // creates a copy
        assert(aacheck.length == t2.size);
        // Make sure contents are the same
        foreach(k,v; aacheck) { assert(k in t2); }
        foreach(v; t2) { assert(v in t2); }
        foreach(aset.key_type v; t2) { assert(v in t2); }

        for (int i=-10; i<20; i++) {
            for (int j=-10; j<20; j++) {
                Pair* n = aset.find(Pair(i,j));
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
            assert(aset.is_valid);
            removed[r] = true;
            aset.remove(r);
            for (int i=0; i<4; i++) {
                for (int j=0; j<4; j++) {
                    assert( (Pair(i,j) in removed)  ||  (Pair(i,j) in aset) );
                }
            }
        }

        assert(aset.toString() == "set()");

        assert(aset.is_valid);
    }
    {
        // Test merge and difference
        auto t1 = SetT!(int)();
        SetT!(int) t2;

        t1 ~= 1;
        t1 ~= 9;
        t1 ~= 7;

        t2 ~= 2;
        t2 ~= 9;
        t2 ~= 8;

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
        // Test multi-set functionality
        MultiSetT!(int) intset;
        alias typeof(intset) Set;

        for (int i = 0; i < 10; i++) {
            assert(intset.size==i);
            intset.insert(i);
        }
        assert(intset.size==10);
        // Should not ignore repeats
        for (int i = 0; i < 10; i++) {
            intset.insert(i);
        }
        assert(intset.size==20);

        {
            Set.iterator it = intset.begin();
            Set.iterator it_end = intset.end();
            for(int i; it!=it_end; ++it,++i) {
                assert(it.value == i/2);
                assert(it.val == i/2);
            }
        }
        writefln("backwards!");
        {
            Set.reverse_iterator it = intset.reverse_begin();
            Set.reverse_iterator it_end = intset.reverse_end();
            for(int i=19; it!=it_end; ++it,--i) {
                assert(it.val == i/2);
                assert(it.value == i/2);
            }
        }            


        for (int i=0; i<10; i++) {
            intset.remove(i);
        }
        assert(intset.size==10);
        for (int i=0; i<10; i++) {
            intset.remove(i);
        }
        assert(intset.size==0);
    }

}



version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
