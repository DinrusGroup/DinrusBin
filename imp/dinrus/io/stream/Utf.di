module io.stream.Utf;

private import io.device.Conduit;
private import io.stream.Buffered;
private import Utf = text.convert.Utf;


class ЮВвод(T, S) : ФильтрВвода, ФильтрВвода.Переключатель
{       
        static if (!is (S == сим) && !is (S == шим) && !is (S == дим)) 
                    pragma (msg, "Source тип must be сим, шим, or дим");

        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Target тип must be сим, шим, or дим");

        private БуферВвода буфер;


        this (ИПотокВвода поток)
        {
                super (буфер = Бввод.создай (поток));
        }
        
        final т_мера используй (T[] приёмн)
        {
                auto x = читай (приёмн);
                if (x != Кф)
                    x /= T.sizeof;
                return x;
        }


        final override т_мера читай (проц[] приёмн);
}

class ЮВывод (S, T) : ФильтрВывода, ФильтрВывода.Переключатель
{       
        static if (!is (S == сим) && !is (S == шим) && !is (S == дим)) 
                    pragma (msg, "Source тип must be сим, шим, or дим");

        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Target тип must be сим, шим, or дим");


        private БуферВывода буфер;


        this (ИПотокВывода поток)
        {
                super (буфер = Бвыв.создай (поток));
        }

        final т_мера используй (S[] приёмн)
        {
                auto x = пиши (приёмн);
                if (x != Кф)
                    x /= S.sizeof;
                return x;
        }

        final override т_мера пиши (проц[] ист);
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (Utf)
{
        import io.Stdout;
        import io.device.Array;

        проц main()
        {
                auto inp = new ЮВвод!(дим, сим)(new Массив("hello world"));
                auto oot = new ЮВывод!(дим, сим)(new Массив(20));
                oot.копируй(inp);
                assert (oot.буфер.срез == "hello world");
        }
}
