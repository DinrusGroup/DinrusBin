module tpl.alloc;
import cidrus: освободи;

template Аллокатор()
{
    static ук размести(т_мера n)
    {
        return (new проц[n]).ptr;
    }

    static проц удали(ук укз)
    {
        освободи(укз);
    }
}
