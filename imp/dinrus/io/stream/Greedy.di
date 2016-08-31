module io.stream.Greedy;

private import io.device.Conduit;

class ГридиВвод : ФильтрВвода
{

        this (ИПотокВвода поток);
        final override т_мера читай (проц[] приёмн);
        final ГридиВвод читайРовно (проц[] приёмн);        
}

class ГридиВывод : ФильтрВывода
{

        this (ИПотокВывода поток);
        final override т_мера пиши (проц[] ист);
        final ГридиВывод пишиРовно (проц[] ист);  
}


debug (Greedy)
{
        проц main()
        {       
                auto s = new ГридиВвод (пусто);
        }
}