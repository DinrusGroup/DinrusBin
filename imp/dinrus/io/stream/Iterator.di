module io.stream.Iterator;

private import io.stream.Buffered;
protected import io.device.Conduit : ФильтрВвода, БуферВвода, ИПотокВвода;


class Обходчик(T) : ФильтрВвода 
{
        private БуферВвода     источник;
        protected T[]           срез,
                                разделитель;

        abstract protected т_мера скан (проц[] данные);

        this (ИПотокВвода поток = пусто)
        {       
                super (поток);
                if (поток)
                    установи (поток);
        }

        Обходчик установи (ИПотокВвода поток)
        {
                assert (поток);
                источник = Бввод.создай (поток);
                super.источник = источник;
                return this;
        }

        final T[] получи ()
        {
                return срез;
        }


        цел opApply (цел delegate(ref T[]) дг)
        {
                бул ещё;
                цел  результат;

                do {
                   ещё = используй;
                   результат = дг (срез);
                   } while (ещё && !результат);
                return результат;
        }

        цел opApply (цел delegate(ref цел, ref T[]) дг)
        {
                бул ещё;
                цел  результат,
                     семы;

                do {
                   ещё = используй;
                   результат = дг (семы, срез);
                   ++семы;
                   } while (ещё && !результат);
                return результат;
        }

        цел opApply (цел delegate(ref цел, ref T[], ref T[]) дг)
        {
                бул ещё;
                цел  результат,
                     семы;

                do {
                   разделитель = пусто;
                   ещё = используй;
                   результат = дг (семы, срез, разделитель);
                   ++семы;
                   } while (ещё && !результат);
                return результат;
        }

        final T[] следщ ()
        {
                if (используй() || срез.length)
                    return срез;
                return пусто;
        }

        protected final т_мера установи (T* контент, т_мера старт, т_мера конец)
        {
                срез = контент [старт .. конец];
                return конец;
        }

        protected final т_мера установи (T* контент, т_мера старт, т_мера конец, т_мера следщ)
        {
                срез = контент [старт .. конец];
                разделитель = контент [конец .. следщ+1];
                return конец;
        }

        protected final т_мера неНайдено ()
        {
                return Кф;
        }

        protected final т_мера найдено (т_мера i)
        {
                return (i + 1) * T.sizeof;
        }

        protected final бул есть (T[] установи, T match)
        {
                foreach (T c; установи)
                         if (match is c)
                             return да;
                return нет;
        }

        private бул используй ()
        {
                if (источник.следщ (&скан))
                    return да;

                // используй trailing сема
                источник.читатель ((проц[] масс) 
                              { 
                              срез = (cast(T*) масс.ptr) [0 .. масс.length/T.sizeof];
                              return cast(т_мера)масс.length; 
                              });
                return нет;
        }
}


