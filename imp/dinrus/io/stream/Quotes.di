module io.stream.Quotes;

private import io.stream.Iterator;


class Кавычки(T) : Обходчик!(T)
{
        private T[] разделитель; 
      
        this (T[] разделитель, ИПотокВвода поток = пусто)
        {
                super (поток);
                this.разделитель = разделитель;
        }
        
        protected т_мера скан (проц[] данные)
        {
                T    quote = 0;
                цел  escape = 0;
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                foreach (i, c; контент)
                         // within a quote block?
                         if (quote)
                            {   
                            if (c is '\\')
                                ++escape;
                            else
                               {
                               // matched the начальное quote сим?
                               if (c is quote && escape % 2 is 0)
                                   quote = 0;
                               escape = 0;
                               }
                            }
                         else
                            // begin a quote block?
                            if (c is '"' || c is '\'')
                                quote = c;
                            else 
                               if (есть (разделитель, c))
                                   return найдено (установи (контент.ptr, 0, i));
                return неНайдено;
        }
}

