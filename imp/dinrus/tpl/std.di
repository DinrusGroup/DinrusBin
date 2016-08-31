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

module tpl.std;

проц поменяй(T)(ref T a, ref T b) {
    T tmp = a;
    a = b;
    b = tmp;
}

T мин(T)(T a, T  b)
{
    return a<b ? a : b;
}

T макс(T)(T a, T  b)
{
    return a>b ? a : b;
}

цел сравни(T)(T a, T b) {
    if (a==b) return 0;
    return a<b ? -1 : 1;
}

бул нач_с(ткст s, ткст префикс) 
{
    return (s.length >= префикс.length && s[0..префикс.length]==префикс);
}
бул кон_на(ткст s, ткст префикс) 
{
    return (s.length >= префикс.length && s[$-префикс.length..$]==префикс);
}

struct пара(S,T)
{
    S первый;
    T второй;
    static пара opCall(S _1й, T _2й) {
        пара R; with (R) {
            первый = _1й;
            второй = _2й;
        } return R;
    }
}

/***********************************************************************************
 *  Reserve a given amount of space in an array
 */
проц займи(T)(ref T[] x, т_мера n) {
    т_мера olen = x.length;
    if (olen<n) { 
        x.length = n;
        x.length = olen;
    }
}

бул пустой(T)(ref T[] x) { return x.length == 0; }

проц пуш_бэк(T)(ref T[] x, ref T el) { x ~= el; }

проц поп_бэк(T)(ref T[] x) { x.length = x.length-1; }

/***********************************************************************************
 *  Remove an item from an array by индекс.
 */
private extern(C) проц* memmove (проц*, проц*, т_мера) ;

static const НЕ_НАЙДЕН = т_мера.max;

т_мера найди_следщ(T) (T[] стог, T item) {
    foreach(i,ref el; стог) {
        if (item == el) return i;
    }
    return НЕ_НАЙДЕН;
}

проц сотри_индекс(T) (ref T[] стог, т_мера индекс)
{
    assert(индекс < стог.length, ".erase_index() вызван с указанием индекса, к-ый больше длины массива");
    if (индекс != стог.length - 1) {
        memmove(&(стог[индекс]), 
                &(стог[индекс + 1]), 
                T.sizeof * (стог.length - индекс - 1));
    }
    стог.length = стог.length - 1;
}

/***********************************************************************************
 *  Insert item x into an array at (just before) индекс.
 */
проц вставь (T) (ref T[] стог, т_мера индекс, T x)
in {
  assert(индекс < стог.length+1, ".insert()вызван с указанием индекса, к-ый больше длины массива");
}
body {
    if (индекс == стог.length) {
        стог ~= x;
    }
    else {
        стог.length = стог.length+1;
        memmove(&стог[индекс+1], &стог[индекс],
                T.sizeof * (стог.length - индекс - 1));
        стог[индекс] = x;
    }
}
unittest {
  цел[] foo = [0, 1, 2, 3, 4, 5];
  foo.вставь(3_U, 3);
  assert(foo == [0, 1, 2, 3,3, 4, 5]);
  foo.вставь(7_U, 7);
  assert(foo == [0, 1, 2, 3,3, 4, 5, 9]);
}


// Iterators for D arrays

struct ОбходчикМассива(T) {
    alias T т_знач;
    alias T* указатель;

    static ОбходчикМассива opCall(T* иниц) {
        ОбходчикМассива M; with(M) {
            ptr_ = иниц;
        } return M;
    }
    static ОбходчикМассива начало(T[] x)  { return ОбходчикМассива(x.укз); }
    static ОбходчикМассива конец(T[] x)  { return ОбходчикМассива(x.укз + x.length); }

    T знач() { assert(укз !is null); return *ptr_; }
    T* укз() { return ptr_; }
    
    цел opEquals(ref ОбходчикМассива другой) {
        if (ptr_ is null || другой.ptr_ is null) return 0;
        return ptr_ == другой.ptr_;
    }
    проц opPostInc() {
        assert(укз !is null);
        ptr_++;
    }
    проц opPostDec() {
        assert(укз !is null);
        ptr_--;
    }
    проц opAddAssign(цел i) {
        assert(укз !is null);
        ptr_+=i;
    }
    проц opSubAssign(цел i) {
        assert(укз !is null);
        ptr_-=i;
    }

private:
    T* ptr_  = null;
}

ОбходчикМассива!(T) начни_обход_массива(T)(T[] x) {
    return ОбходчикМассива!(T).начало(x);
}
ОбходчикМассива!(T) заверши_обход_массива(T)(T[] x) {
    return ОбходчикМассива!(T).конец(x);
}

template обходчик_массива(T:T[]) {
    alias ОбходчикМассива!(T) обходчик_массива;
}