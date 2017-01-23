module io.stream.Typed;

private import io.device.Conduit;
private import io.stream.Buffered;

class ТипированныйВвод(T) : ФильтрВвода
{       

        this (ИПотокВвода поток)
        {
                super (Бввод.создай (поток));
        }
        

        final override ТипированныйВвод слей ()
        {
                super.слей;
                return this;
        }

        final бул читай (ref T x)
        {
                return источник.читай((&x)[0..1]) is T.sizeof;
        }

        final цел opApply (цел delegate(ref T x) дг)
        {
                T x;
                цел возвр;

                while ((источник.читай((&x)[0..1]) is T.sizeof))
                        if ((возвр = дг (x)) != 0)
                             break;
                return возвр;
        }
}


class ТипированныйВывод(T) : ФильтрВывода
{       
        this (ИПотокВывода поток)
        {
                super (Бвыв.создай (поток));
        }

        final проц пиши (ref T x)
        {
                сток.пиши ((&x)[0..1]);
        }
}

