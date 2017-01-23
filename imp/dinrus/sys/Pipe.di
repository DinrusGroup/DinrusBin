module sys.Pipe;

private import sys.Common, io.device.Device, sys.WinStructs;

private enum {ДефРазмерБуфера = 8 * 1024}



class Трубопровод : Устройство
{
    version (OLD)
    {
        alias Устройство.фукз  фукз;
        alias Устройство.копируй        копируй;
        alias Устройство.читай        читай;
        alias Устройство.пиши       пиши;
        alias Устройство.закрой       закрой;
        alias Устройство.ошибка       ошибка;
    }
    private this(Дескр укз, бцел размерБуфера = ДефРазмерБуфера);
    public ~this();
    public override т_мера размерБуфера();
    public override ткст вТкст();
    version (OLD)
    {
        protected override бцел читай (проц[] приёмн);
        protected override бцел пиши (проц[] ист);
    }
}

class Пайп
{
    private Трубопровод _source;
    private Трубопровод _сток;

    /**
     * Create a Пайп.
     */
    public this(бцел размерБуфера = ДефРазмерБуфера);
    version (Windows)
    {
    package this(бцел размерБуфера, SECURITY_ATTRIBUTES *ба);
	}
    public Трубопровод сток();
    public Трубопровод источник();
    private final проц ошибка ();
}

