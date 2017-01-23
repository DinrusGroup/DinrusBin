/*******************************************************************************

        copyright:      Copyright (c) 2006-2009 Max Samukha, Thomas Kühne,
                                            Grzegorz Adam Hankiewicz

        license:        BSD стиль: $(LICENSE)

        version:        Dec 2006: Initial release
                        Jan 2009: Replaced нормализуй

        author:         Max Samukha, Thomas Kühne,
                        Grzegorz Adam Hankiewicz

*******************************************************************************/

module util.PathUtil;

/*******************************************************************************

    Normalizes a путь component.

    . segments are removed
    <segment>/.. are removed

    On Windows, \ will be преобразованый в_ / prior в_ normalization.

    MultИПle consecutive forward slashes are replaced with a single forward slash.

    Note that any число of .. segments at the front is ignored,
    unless it is an абсолютный путь, in which case they are removed.

    The ввод путь is copied преобр_в either the provопрed буфер, or a куча
    allocated Массив if no буфер was provопрed. Normalization modifies
    this копируй before returning the relevant срез.

    Examples:
    -----
     нормализуй("/home/foo/./bar/../../john/doe"); // => "/home/john/doe"
    -----

*******************************************************************************/
ткст нормализуй(ткст путь, ткст буф = пусто);

debug (UnitTest)
{

    unittest
    {
        assert (нормализуй ("") == "");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/.htaccess") == "/.DinrusTango.lib/.htaccess");
        assert (нормализуй ("/home/../john/../.DinrusTango.lib/foo.conf") == "/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/home/john/.DinrusTango.lib/foo.conf") == "/home/john/.DinrusTango.lib/foo.conf");
        assert (нормализуй ("/foo/bar/.htaccess") == "/foo/bar/.htaccess");
        assert (нормализуй ("foo/bar/././.") == "foo/bar/");
        assert (нормализуй ("././foo/././././bar") == "foo/bar");
        assert (нормализуй ("/foo/../john") == "/john");
        assert (нормализуй ("foo/../john") == "john");
        assert (нормализуй ("foo/bar/..") == "foo/");
        assert (нормализуй ("foo/bar/../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john") == "foo/john");
        assert (нормализуй ("foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/doe") == "foo/bar/doe");
        assert (нормализуй ("./foo/bar/doe/../../john/../bar") == "foo/bar");
        assert (нормализуй ("./foo/bar/../../john/../bar") == "bar");
        assert (нормализуй ("foo/bar/./doe/../../john") == "foo/john");
        assert (нормализуй ("../../foo/bar") == "../../foo/bar");
        assert (нормализуй ("../../../foo/bar") == "../../../foo/bar");
        assert (нормализуй ("d/") == "d/");
        assert (нормализуй ("/home/john/./foo/bar.txt") == "/home/john/foo/bar.txt");
        assert (нормализуй ("/home//john") == "/home/john");

        assert (нормализуй("/../../bar/") == "/bar/");
        assert (нормализуй("/../../bar/../baz/./") == "/baz/");
        assert (нормализуй("/../../bar/boo/../baz/.bar/.") == "/bar/baz/.bar/");
        assert (нормализуй("../..///.///bar/..//..//baz/.//boo/..") == "../../../baz/");
        assert (нормализуй("./bar/./..boo/./..bar././/") == "bar/..boo/..bar./");
        assert (нормализуй("/bar/..") == "/");
        assert (нормализуй("bar/") == "bar/");
        assert (нормализуй(".../") == ".../");
        assert (нормализуй("///../foo") == "/foo");
        auto буф = new сим[100];
        auto возвр = нормализуй("foo/bar/./baz", буф);
        assert (возвр.ptr == буф.ptr);
        assert (возвр == "foo/bar/baz");

version (Windows) {
        assert (нормализуй ("\\foo\\..\\john") == "/john");
        assert (нормализуй ("foo\\..\\john") == "john");
        assert (нормализуй ("foo\\bar\\..") == "foo/");
        assert (нормализуй ("foo\\bar\\..\\john") == "foo/john");
        assert (нормализуй ("foo\\bar\\doe\\..\\..\\john") == "foo/john");
        assert (нормализуй ("foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
        assert (нормализуй (".\\foo\\bar\\doe") == "foo/bar/doe");
        assert (нормализуй (".\\foo\\bar\\doe\\..\\..\\john\\..\\bar") == "foo/bar");
        assert (нормализуй (".\\foo\\bar\\..\\..\\john\\..\\bar") == "bar");
        assert (нормализуй ("foo\\bar\\.\\doe\\..\\..\\john") == "foo/john");
        assert (нормализуй ("..\\..\\foo\\bar") == "../../foo/bar");
        assert (нормализуй ("..\\..\\..\\foo\\bar") == "../../../foo/bar");
        assert (нормализуй(r"C:") == "C:");
        assert (нормализуй(r"C") == "C");
        assert (нормализуй(r"c:\") == "C:/");
        assert (нормализуй(r"C:\..\.\..\..\") == "C:/");
        assert (нормализуй(r"c:..\.\boo\") == "C:../boo/");
        assert (нормализуй(r"C:..\..\boo\foo\..\.\..\..\bar") == "C:../../../bar");
        assert (нормализуй(r"C:boo\..") == "C:");
}
    }
}


/******************************************************************************

    Matches a образец against a имяф.

    Some characters of образец have special a meaning (they are
    <i>meta-characters</i>) and <b>can't</b> be escaped. These are:
    <p><table>
    <tr><td><b>*</b></td>
        <td>Matches 0 or ещё instances of any character.</td></tr>
    <tr><td><b>?</b></td>
        <td>Matches exactly one instances of any character.</td></tr>
    <tr><td><b>[</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that appears
        between the brackets.</td></tr>
    <tr><td><b>[!</b><i>симвы</i><b>]</b></td>
        <td>Matches one экземпляр of any character that does not appear
        between the brackets after the exclamation метка.</td></tr>
    </table><p>
    Internally indivопрual character comparisons are готово calling
    charMatch(), so its rules apply here too. Note that путь
    разделители and dots don't stop a meta-character из_ совпадают
    further portions of the имяф.

    Возвращает: да if образец matches имяф, нет otherwise.

    See_Also: charMatch().

    Throws: Nothing.

    Examples:
    -----
    version(Win32)
    {
        совпадение("foo.bar", "*") // => да
        совпадение(r"foo/foo\bar", "f*b*r") // => да
        совпадение("foo.bar", "f?bar") // => нет
        совпадение("Goo.bar", "[fg]???bar") // => да
        совпадение(r"d:\foo\bar", "d*foo?bar") // => да
    }
    version(Posix)
    {
        совпадение("Go*.bar", "[fg]???bar") // => нет
        совпадение("/foo*home/bar", "?foo*bar") // => да
        совпадение("fСПДar", "foo?bar") // => да
    }
    -----
    
******************************************************************************/

бул совпадение(ткст имяф, ткст образец);


debug (UnitTest)
{
    unittest
    {
    version (Win32)
        assert(совпадение("foo", "Foo"));
    version (Posix)
        assert(!совпадение("foo", "Foo"));
    
    assert(совпадение("foo", "*"));
    assert(совпадение("foo.bar", "*"));
    assert(совпадение("foo.bar", "*.*"));
    assert(совпадение("foo.bar", "foo*"));
    assert(совпадение("foo.bar", "f*bar"));
    assert(совпадение("foo.bar", "f*b*r"));
    assert(совпадение("foo.bar", "f???bar"));
    assert(совпадение("foo.bar", "[fg]???bar"));
    assert(совпадение("foo.bar", "[!gh]*bar"));

    assert(!совпадение("foo", "bar"));
    assert(!совпадение("foo", "*.*"));
    assert(!совпадение("foo.bar", "f*baz"));
    assert(!совпадение("foo.bar", "f*b*x"));
    assert(!совпадение("foo.bar", "[gh]???bar"));
    assert(!совпадение("foo.bar", "[!fg]*bar"));
    assert(!совпадение("foo.bar", "[fg]???baz"));

    }
}


/******************************************************************************

     Matches имяф characters.

     Under Windows, the сравнение is готово ignoring case. Under Linux
     an exact match is performed.

     Возвращает: да if c1 matches c2, нет otherwise.

     Throws: Nothing.

     Examples:
     -----
     version(Win32)
     {
         charMatch('a', 'b') // => нет
         charMatch('A', 'a') // => да
     }
     version(Posix)
     {
         charMatch('a', 'b') // => нет
         charMatch('A', 'a') // => нет
     }
     -----
******************************************************************************/

private бул charMatch(сим c1, сим c2);

