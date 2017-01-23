module io.stream.Map;

private import io.stream.Lines,
               io.stream.Buffered;

private import Текст = text.Util;

private import io.device.Conduit;


class КартВвод(T) : Строки!(T)
{

        this (ИПотокВвода поток)
        {
                super (поток);
        }


        final цел opApply (цел delegate(ref T[] имя, ref T[] значение) дг)
        {
                цел возвр;

                foreach (строка; super)
                        {
                        auto текст = Текст.убери (строка);

                        // comments require '#' as the first non-пробел сим
                        if (текст.length && (текст[0] != '#'))
                           {
                           // найди the '=' сим
                           auto i = Текст.местоположение (текст, cast(T) '=');

                           // ignore if не найден ...
                           if (i < текст.length)
                              {
                              auto имя = Текст.убери (текст[0 .. i]);
                              auto значение = Текст.убери (текст[i+1 .. $]);
                              if ((возвр = дг (имя, значение)) != 0)
                                   break;
                              }
                           }
                        }
                return возвр;
        }

        final КартВвод загрузи (ref T[][T[]] свойства)
        {
                foreach (имя, значение; this)
                         свойства[имя.dup] = значение.dup;  
                return this;
        }
}

class КартВывод(T) : ФильтрВывода
{
        private T[] кс;

        private const T[] префикс = "# ";
        private const T[] равно = " = ";
        version (Win32)
                 private const T[] NL = "\r\n";
        version (Posix)
                 private const T[] NL = "\n";

        this (ИПотокВывода поток, T[] нс = NL)
        {
                super (Бвыв.создай (поток));
                кс = нс;
        }


        final КартВывод нс ()
        {
                сток.пиши (кс);
                return this;
        }

        final КартВывод коммент (T[] текст)
        {
                сток.пиши (префикс);
                сток.пиши (текст);
                сток.пиши (кс);
                return this;
        }

        final КартВывод добавь (T[] имя, T[] значение)
        {
                сток.пиши (имя);
                сток.пиши (равно);
                сток.пиши (значение);
                сток.пиши (кс);
                return this;
        }


        final КартВывод добавь (T[][T[]] свойства)
        {
                foreach (ключ, значение; свойства)
                         добавь (ключ, значение);
                return this;
        }
}



/*******************************************************************************
        
*******************************************************************************/
        
debug (UnitTest)
{
        import io.Stdout;
        import io.device.Array;
        
        unittest
        {
                auto буф = new Массив(200);
                auto ввод = new КартВвод!(сим)(буф);
                auto вывод = new КартВывод!(сим)(буф);

                ткст[ткст] карта;
                карта["foo"] = "bar";
                карта["foo2"] = "bar2";
                вывод.добавь(карта).слей;

                карта = карта.init;
                ввод.загрузи (карта);
                assert (карта["foo"] == "bar");
                assert (карта["foo2"] == "bar2");
        }
}
