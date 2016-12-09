module std.boxer;
public import tpl.box;

alias  инфОТипеМассив_ли isArrayTypeInfo;
alias  КлассТипа TypeClass;
alias  КлассТипа.Бул Bool;
alias  КлассТипа.Бит Bit;
alias  КлассТипа.Целое Integer;
alias  КлассТипа.Плав Float;
alias  КлассТипа.Комплекс Complex;
alias  КлассТипа.Мнимое Imaginary;
alias  КлассТипа.Класс  Class;
alias  КлассТипа.Указатель  Pointer;
alias  КлассТипа.Массив  Array;
alias  КлассТипа.Другой  Other;

alias Бокс Box;
alias Бокс.выявиКлассТипа findTypeClass;
//alias Бокс.разбоксОбъ unboxable;
alias Бокс.тип type;
alias Бокс.данные data;

alias вБокс  box;
alias масБокс boxArray;
alias массивБоксВАргументы boxArrayToArguments;
alias разбоксКастРеал unboxCastReal;
alias разбоксКастЦелый unboxCastInteger;
alias  разбоксКастКомплекс unboxCastComplex;
alias разбоксКастМнимое unboxCastImaginary;
alias изБокса unbox;
alias  тестРазбокс unboxTest;
alias разбоксОбъ  unboxable;
alias РазбоксИскл UnboxException;


unittest
{
    class A { }
    class B : A { }
    struct SA { }
    struct SB { }
    
    Box a, b;
    
    /* Call the function, catch UnboxException, return that it threw correctly. */
    bool fails(void delegate()func)
    {
        try func();
        catch (UnboxException error)
            return true;
        return false;
    }
    
    /* Check that equals and comparison work properly. */
    a = box(0);
    b = box(32);
    assert (a != b);
    assert (a == a);
    assert (a < b);
    
    /* Check that toString works properly. */
    assert (b.toString == "32");
    
    /* Assert that unboxable works. */
    assert (unboxable!(char[])(box("foobar")));
    
    /* Assert that we can cast from int to byte. */
    assert (unboxTest!(byte)(b) == 32);
    
    /* Assert that we can cast from int to real. */
    assert (unboxTest!(real)(b) == 32.0L);
    
    /* Check that real works properly. */
    assert (unboxTest!(real)(box(32.45L)) == 32.45L);
    
    /* Assert that we cannot implicitly cast from real to int. */
    assert(fails(delegate void() { unboxTest!(int)(box(1.3)); }));
    
    /* Check that the unspecialized unbox template works. */
    assert(unboxTest!(char[])(box("foobar")) == "foobar");
    
    /* Assert that complex works correctly. */
    assert(unboxTest!(cdouble)(box(1 + 2i)) == 1 + 2i);
    
    /* Assert that imaginary works correctly. */
    assert(unboxTest!(ireal)(box(45i)) == 45i);
    
    /* Create an array of boxes from arguments. */
    Box[] array = boxArray(16, "foobar", new Object);
    
    assert(array.length == 3);
    assert(unboxTest!(int)(array[0]) == 16);
    assert(unboxTest!(char[])(array[1]) == "foobar");
    assert(unboxTest!(Object)(array[2]) !is null);
    
    /* Convert the box array back into arguments. */
    TypeInfo[] array_types;
    void* array_data;
    
    boxArrayToArguments(array, array_types, array_data);
    assert (array_types.length == 3);
    
    /* Confirm the symmetry. */
    assert (boxArray(array_types, array_data) == array);
    
    /* Assert that we can cast from int to creal. */
    assert (unboxTest!(creal)(box(45)) == 45+0i);
    
    /* Assert that we can cast from idouble to creal. */
    assert (unboxTest!(creal)(box(45i)) == 0+45i);
    
    /* Assert that equality testing casts properly. */
    assert (box(1) == box(cast(byte)1));
    assert (box(cast(real)4) == box(4));
    assert (box(5) == box(5+0i));
    assert (box(0+4i) == box(4i));
    assert (box(8i) == box(0+8i));
    
    /* Assert that comparisons cast properly. */
    assert (box(450) < box(451));
    assert (box(4) > box(3.0));
    assert (box(0+3i) < box(0+4i));
    
    /* Assert that casting from bool to int works. */
    assert (1 == unboxTest!(int)(box(true)));
    assert (box(1) == box(true));
 
    /* Assert that unboxing to an object works properly. */
    assert (unboxTest!(B)(box(cast(A)new B)) !is null);
    
    /* Assert that illegal object casting fails properly. */   
    assert (fails(delegate void() { unboxTest!(B)(box(new A)); }));
    
    /* Assert that we can unbox a null. */
    assert (unboxTest!(A)(box(cast(A)null)) is null);
    assert (unboxTest!(A)(box(null)) is null);
    
    /* Unboxing null in various contexts. */
    assert (unboxTest!(char[])(box(null)) is null);
    assert (unboxTest!(int*)(box(null)) is null);
    
    /* Assert that unboxing between pointer types fails. */
    int [1] p;
    assert (fails(delegate void() { unboxTest!(char*)(box(p.ptr)); }));
    
    /* Assert that unboxing various types as void* does work. */
    assert (unboxTest!(void*)(box(p.ptr))); // int*
    assert (unboxTest!(void*)(box(p))); // int[]
    assert (unboxTest!(void*)(box(new A))); // Object
    
    /* Assert that we can't unbox an integer as bool. */
    assert (!unboxable!(bool) (box(4)));
    
    /* Assert that we can't unbox a struct as another struct. */
    SA sa;
    assert (!unboxable!(SB)(box(sa)));
}
