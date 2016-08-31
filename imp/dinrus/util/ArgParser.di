module util.ArgParser;

private import exception;

alias проц delegate (ткст значение) ОбрвызПарсераАргов;

alias проц delegate (ткст значение,бцел порядковый) ДефолтнОбрвызПарсераАргов;

alias проц delegate () ПростойОбрвызПарсераАргов;

struct Аргумент {
    ткст префикс;
    ткст определитель;

    static Аргумент opCall ( ткст префикс, ткст определитель ) ;
}

alias Аргумент Арг;


/**

*/
class АргПарсер{

    /**

    */
    protected struct ОбрвызПрефикса {
        ткст опр;
        ОбрвызПарсераАргов ов;
    }   

    protected ОбрвызПрефикса[][ткст] привязки;
    protected ДефолтнОбрвызПарсераАргов[ткст] дефолтнПривязки;
    protected бцел[ткст] порядковыеПрефикса;
    protected ткст[] порядокПоискаПрефикса;
    protected ДефолтнОбрвызПарсераАргов дефолтнпривяз;
    private бцел дефолтныйПорядковый = 0;

    protected проц добавьПривязки(ОбрвызПрефикса овп, ткст аргПрефикс);
    public проц свяжи(ткст аргПрефикс, ткст аргОпр, ОбрвызПарсераАргов ов);
    public this();   
    public this(ДефолтнОбрвызПарсераАргов обрвызов);
	
    protected class ПростойАдаптерОбрвызова
	{
        ПростойОбрвызПарсераАргов обрвызов;
		
        public this(ПростойОбрвызПарсераАргов обрвызов);        
        public проц обрвызАдаптера(ткст значение);
    public проц свяжи(ткст аргПрефикс, ткст аргОпр, ПростойОбрвызПарсераАргов ов);
    public проц свяжиДефолт(ткст аргПрефикс, ДефолтнОбрвызПарсераАргов обрвызов);
    public проц свяжиДефолт(ДефолтнОбрвызПарсераАргов обрвызов);
    public проц свяжи (Аргумент аргумент, ОбрвызПарсераАргов обрвызов);
    public проц свяжи ( Аргумент[] аргументы, проц delegate(ткст) обрвызов );
    public проц свяжиПосикс ( ткст определитель, ОбрвызПарсераАргов обрвызов ) ;
    public проц свяжиПосикс ( ткст[] определители, ОбрвызПарсераАргов обрвызов );
    public проц разбор(ткст[] аргументы, бул сбросьПорядковые = нет)
}
}
debug (UnitTest) {
    import Целое = text.convert.Integer;

    //проц main() {}

unittest {

    АргПарсер парсер = new АргПарсер();
    бул h = нет;
    бул h2 = нет;
    бул b = нет;
    бул bb = нет;
    бул булево = нет;
    цел n = -1;
    цел dashOrdinalCount = -1;
    цел ordinalCount = -1;

    парсер.свяжи("--", "h2", delegate проц(){
        h2 = да;
    });

    парсер.свяжи("-", "h", delegate проц(){
        h = да;
    });

    парсер.свяжи("-", "bb", delegate проц(){
        bb = да;
    });

    парсер.свяжи("-", "бул", delegate проц(ткст значение){
        assert(значение.length == 5);
        assert(значение[0] == '=');
        if (значение[1..5] == "да") {
            булево = да;
        }
        else {
            assert(нет);
        }
    });

    парсер.свяжи("-", "b", delegate проц(){
        b = да;
    });

    парсер.свяжи("-", "n", delegate проц(ткст значение){
        assert(значение[0] == '=');
        n = cast(цел) Целое.разбор(значение[1..5]);
        assert(n == 4349);
    });

    парсер.свяжиДефолт(delegate проц(ткст значение, бцел порядковый){
        ordinalCount = порядковый;
        if (порядковый == 0) {
            assert(значение == "ordinalTest1");
        }
        else if (порядковый == 1) {
            assert(значение == "ordinalTest2");
        }
    });

    парсер.свяжиДефолт("-", delegate проц(ткст значение, бцел порядковый){
        dashOrdinalCount = порядковый;
        if (порядковый == 0) {
            assert(значение == "dashTest1");
        }
        else if (порядковый == 1) {
            assert(значение == "dashTest2");
        }
    });

    парсер.свяжиДефолт("@", delegate проц(ткст значение, бцел порядковый){
        assert (значение == "atTest");
    });

    static ткст[] test1 = ["--h2", "-h", "-bb", "-b", "-n=4349", "-бул=да", "ordinalTest1", "ordinalTest2", "-dashTest1", "-dashTest2", "@atTest"];

    парсер.разбор(test1);
    assert(h2);
    assert(h);
    assert(b);
    assert(bb);
    assert(n == 4349);
    assert(ordinalCount == 1);
    assert(dashOrdinalCount == 1);
    
    h = h2 = b = bb = нет;
    булево = нет;
    n = ordinalCount = dashOrdinalCount = -1;

    static ткст[] test2 = ["-n=4349", "ordinalTest1", "@atTest", "--h2", "-b", "-bb", "-h", "-dashTest1", "-dashTest2", "ordinalTest2", "-бул=да"];

    парсер.разбор(test2, да);
    assert(h2 && h && b && bb && булево && (n ==4349));
    assert(ordinalCount == 1);
    assert(dashOrdinalCount == 1);
 
    h = h2 = b = bb = нет;
    булево = нет;
    n = ordinalCount = dashOrdinalCount = -1;

    static ткст[] test3 = ["-n=4349", "ordinalTest1", "@atTest", "--h2", "-b", "-bb", "-h", "-dashTest1", "-dashTest2", "ordinalTest2", "-бул=да"];

    парсер.разбор(test3, да);
    assert(h2 && h && b && bb && булево && (n ==4349));
    assert((ordinalCount == 1) && (dashOrdinalCount == 1));
 
    ordinalCount = dashOrdinalCount = -1;

    static ткст[] test4 = ["ordinalTest1", "ordinalTest2", "ordinalTest3", "ordinalTest4"];
    static ткст[] test5 = ["-dashTest1", "-dashTest2", "-dashTest3"];

    парсер.разбор(test4, да);
    assert(ordinalCount == 3);

    парсер.разбор(test5, да);
    assert(dashOrdinalCount == 2);
}
}
