module io.stream.Endian;

private import io.device.Conduit;
private import io.stream.Buffered;


class ЭндианВвод(T) : ФильтрВвода, ФильтрВвода.Переключатель
{       
        static if ((T.sizeof != 2) && (T.sizeof != 4) && (T.sizeof != 8)) 
                    pragma (msg, "EndianInput :: type should be of length 2, 4, or 8 bytes");


        this (ИПотокВвода поток);
        final override т_мера читай (проц[] приёмн);
}


class ЭндианВывод (T) : ФильтрВывода, ФильтрВывода.Переключатель
{       
        static if ((T.sizeof != 2) && (T.sizeof != 4) && (T.sizeof != 8)) 
                    pragma (msg, "EndianOutput :: type should be of length 2, 4, or 8 bytes");

        private БуферВывода вывод;

        this (ИПотокВывода поток);
        final override т_мера пиши (проц[] ист);
}
  
debug (UnitTest)
{
        import io.device.Array;
        
        unittest
        {
                auto inp = new ЭндианВвод!(дим)(new Массив("hello world"d));
                auto oot = new ЭндианВывод!(дим)(new Массив(64));
                oot.копируй (inp);
                assert (oot.вывод.срез == "hello world"d);
        }
}
