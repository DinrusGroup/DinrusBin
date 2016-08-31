module io.stream.Text;

private import io.stream.Lines;
private import io.stream.Format;
private import io.stream.Buffered;
private import io.model;

class ТекстВвод : Строки!(сим)
{       

        this (ИПотокВвода ввод)
        {
                super (ввод);
        }
}

class ТекстВывод : ФормВывод!(сим)
{       

        this (ИПотокВывода вывод)
        {
                super (Бвыв.создай(вывод));
        }
}
