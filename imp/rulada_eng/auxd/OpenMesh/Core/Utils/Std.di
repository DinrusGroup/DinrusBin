//============================================================================
// Std.d - some standard simple utilties
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 30 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module auxd.OpenMesh.Core.Utils.Std;

import auxd.OpenMesh.Core.System.config;

void swap(T)(ref T a, ref T b) {
    T tmp = a;
    a = b;
    b = tmp;
}

T min(T)(T a, T  b)
{
    return a<b ? a : b;
}

T max(T)(T a, T  b)
{
    return a>b ? a : b;
}

int compare(T)(T a, T b) {
    if (a==b) return 0;
    return a<b ? -1 : 1;
}

bool starts_with(string s, string prefix) 
{
    return (s.length >= prefix.length && s[0..prefix.length]==prefix);
}
bool ends_with(string s, string prefix) 
{
    return (s.length >= prefix.length && s[$-prefix.length..$]==prefix);
}

struct pair(S,T)
{
    S first;
    T second;
    static pair opCall(S _1st, T _2nd) {
        pair R; with (R) {
            first = _1st;
            second = _2nd;
        } return R;
    }
}

/***********************************************************************************
 *  Reserve a given amount of space in an array
 */
void reserve(T)(ref T[] x, size_t n) {
    size_t olen = x.length;
    if (olen<n) { 
        x.length = n;
        x.length = olen;
    }
}

bool empty(T)(ref T[] x) { return x.length == 0; }

void push_back(T)(ref T[] x, ref T el) { x ~= el; }

void pop_back(T)(ref T[] x) { x.length = x.length-1; }

/***********************************************************************************
 *  Remove an item from an array by index.
 */
private extern(C) void* memmove (void*, void*, size_t) ;

static const NOT_FOUND = size_t.max;

size_t find_index(T) (T[] haystack, T item) {
    foreach(i,ref el; haystack) {
        if (item == el) return i;
    }
    return NOT_FOUND;
}

void erase_index(T) (ref T[] haystack, size_t index)
{
    assert(index < haystack.length, ".erase_index() called with index greater than array length");
    if (index != haystack.length - 1) {
        memmove(&(haystack[index]), 
                &(haystack[index + 1]), 
                T.sizeof * (haystack.length - index - 1));
    }
    haystack.length = haystack.length - 1;
}

/***********************************************************************************
 *  Insert item x into an array at (just before) index.
 */
void insert (T) (ref T[] haystack, size_t index, T x)
in {
  assert(index < haystack.length+1, ".insert() called with index greater than array length");
}
body {
    if (index == haystack.length) {
        haystack ~= x;
    }
    else {
        haystack.length = haystack.length+1;
        memmove(&haystack[index+1], &haystack[index],
                T.sizeof * (haystack.length - index - 1));
        haystack[index] = x;
    }
}
unittest {
  int[] foo = [0, 1, 2, 3, 4, 5];
  foo.insert(3_U, 3);
  assert(foo == [0, 1, 2, 3,3, 4, 5]);
  foo.insert(7_U, 7);
  assert(foo == [0, 1, 2, 3,3, 4, 5, 9]);
}


// Iterators for D arrays

struct ArrayIter(T) {
    alias T value_type;
    alias T* pointer;

    static ArrayIter opCall(T* init) {
        ArrayIter M; with(M) {
            ptr_ = init;
        } return M;
    }
    static ArrayIter begin(T[] x)  { return ArrayIter(x.ptr); }
    static ArrayIter end(T[] x)  { return ArrayIter(x.ptr + x.length); }

    T val() { assert(ptr !is null); return *ptr_; }
    T* ptr() { return ptr_; }
    
    int opEquals(ref ArrayIter other) {
        if (ptr_ is null || other.ptr_ is null) return 0;
        return ptr_ == other.ptr_;
    }
    void opPostInc() {
        assert(ptr !is null);
        ptr_++;
    }
    void opPostDec() {
        assert(ptr !is null);
        ptr_--;
    }
    void opAddAssign(int i) {
        assert(ptr !is null);
        ptr_+=i;
    }
    void opSubAssign(int i) {
        assert(ptr !is null);
        ptr_-=i;
    }

private:
    T* ptr_  = null;
}

ArrayIter!(T) array_iter_begin(T)(T[] x) {
    return ArrayIter!(T).begin(x);
}
ArrayIter!(T) array_iter_end(T)(T[] x) {
    return ArrayIter!(T).end(x);
}

template array_iterator(T:T[]) {
    alias ArrayIter!(T) array_iterator;
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
