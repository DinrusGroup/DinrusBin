module io.stream.Patterns;

private import text.Regex;
    
private import io.stream.Iterator;

class Образцы : Обходчик!(сим)
{
        private Regex regex;
        private alias сим T;

        this (T[] образец, ИПотокВвода поток = пусто)
        {
                regex = new Regex (образец, "");
                super (поток);
        }

        protected т_мера скан (проц[] данные)
        {
                auto контент = (cast(T*) данные.ptr) [0 .. данные.length / T.sizeof];

                if (regex.тест (контент))
                   {
                   цел старт = regex.registers_[0];
                   цел финиш = regex.registers_[1];
                   установи (контент.ptr, 0, старт);
                   return найдено (финиш-1);        
                   }

                return неНайдено;
        }
}

