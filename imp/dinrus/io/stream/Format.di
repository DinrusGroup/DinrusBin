module io.stream.Format;

private import io.device.Conduit;
private import text.convert.Layout;

class ФормВывод(T) : ФильтрВывода
{       
        public  alias ФильтрВывода.слей слей;

        private T[]             кс;
        private Выкладка!(T)      преобразуй;
        private бул            слитьСтроки;

        public alias выведи      opCall;         /// opCall -> выведи
                   

        version (Win32)
                 private const T[] Кс = "\r\n";
             else
                private const T[] Кс = "\n";


        this (ИПотокВывода вывод, T[] кс = Кс)
        {
                this (Выкладка!(T).экземпляр, вывод, кс);
        }

        this (Выкладка!(T) преобразуй, ИПотокВывода вывод, T[] кс = Кс)
        {
                assert (преобразуй);
                assert (вывод);

                this.преобразуй = преобразуй;
                this.кс = кс;
                super (вывод);
        }


        final ФормВывод форматируй (T[] фмт, ...)
        {
                преобразуй (&излей, _arguments, _argptr, фмт);
                return this;
        }


        final ФормВывод форматнс (T[] фмт, ...)
        {
                преобразуй (&излей, _arguments, _argptr, фмт);
                return нс;
        }

        final ФормВывод выведи (...)
        {
                static  T[] срез =  "{}, {}, {}, {}, {}, {}, {}, {}, "
                                     "{}, {}, {}, {}, {}, {}, {}, {}, "
                                     "{}, {}, {}, {}, {}, {}, {}, {}, ";

                assert (_arguments.length <= срез.length/4, "io.stream.Format.ФормВывод :: слишком много аргументов");

                if (_arguments.length is 0)
                    сток.слей;
                else
                   преобразуй (&излей, _arguments, _argptr, срез[0 .. _arguments.length * 4 - 2]);
                         
                return this;
        }


        final ФормВывод нс ()
        {
                сток.пиши (кс);
                if (слитьСтроки)
                    сток.слей;
                return this;
        }

        final ФормВывод слей (бул да)
        {
                слитьСтроки = да;
                return this;
        }

        final ИПотокВывода поток ()
        {
                return сток;
        }

        final ФормВывод поток (ИПотокВывода вывод)
        {
                сток = вывод;
                return this;
        }

        final Выкладка!(T) выкладка ()
        {
                return преобразуй;
        }

        final ФормВывод выкладка (Выкладка!(T) выкладка)
        {
                преобразуй = выкладка;
                return this;
        }

        private final бцел излей (T[] s)
        {
                auto счёт = сток.пиши (s);
                if (счёт is Кф)
                    провод.ошибка ("io.stream.Format.ФормВывод :: неожиданный Кф");
                return счёт;
        }
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (Формат)
{
        import io.device.Array;

        проц main()
        {
                auto выведи = new ФормВывод!(сим) (new Массив(1024, 1024));

                for (цел i=0;i < 1000; i++)
                     выведи(i).нс;
        }
}
