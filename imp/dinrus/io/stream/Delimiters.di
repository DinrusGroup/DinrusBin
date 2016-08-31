module io.stream.Delimiters;

private import io.stream.Iterator;

class Разграничители(T) : Обходчик!(T)
{
        private T[] разделитель;

        this (T[] разделитель, ИПотокВвода поток = пусто)
        {
                this.разделитель = разделитель;
                super (поток);
        }

        protected т_мера скан (проц[] данные);
}


debug(UnitTest)
{
        private import io.device.Array;

        unittest 
        {
                auto p = new Разграничители!(сим) (", ", new Массив("blah"));
        }
}
