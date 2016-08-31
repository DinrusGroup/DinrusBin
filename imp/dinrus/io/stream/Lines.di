module io.stream.Lines;

private import io.stream.Iterator;

class Строки(T) : Обходчик!(T)
{
        this (ИПотокВвода поток = пусто)
        {
                super (поток);
        }

        final бул читайнс (ref T[] контент)
        {
                контент = super.следщ;
                return контент.ptr !is пусто;
        }

        protected т_мера скан (проц[] данные)
        {
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                foreach (цел i, T c; контент)
                         if (c is '\n')
                            {
                            цел срез = i;
                            if (i && контент[i-1] is '\r')
                                --срез;
                            установи (контент.ptr, 0, срез, i);
                            return найдено (i);
                            }

                return неНайдено;
        }
}
