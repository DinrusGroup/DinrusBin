module io.selector.SelectSelector;

public import io.model;
public import io.selector.model;
private import io.selector.AbstractSelector;
private import io.selector.SelectorException;

version (Windows)
{
    private
    {
        struct набор_уд
        {
        }
    }
}

  
public class СелекторВыбора: АбстрактныйСелектор
{
    alias АбстрактныйСелектор.выбери выбери;

   version (Posix)
    {
        public const бцел ДефРазмер = 1024;
    }
    else
    {
        public const бцел ДефРазмер = 63;
    }

   public проц открой(бцел размер = ДефРазмер, бцел maxEvents = ДефРазмер);
    public проц закрой();
    private НаборДескр *разместиНабор(ref НаборДескр набор, ref НаборДескр наборВыд);
    public проц регистрируй(ИВыбираемый провод, Событие события, Объект атачмент = пусто);
    public проц отмениРег(ИВыбираемый провод);
    public цел выбери(ИнтервалВремени таймаут);
    public ИНаборВыделений наборВыд();
    public КлючВыбора ключ(ИВыбираемый провод);
    public т_мера счёт();
    цел opApply(цел delegate(ref КлючВыбора) дг);
}


private class SelectSelectionSet: ИНаборВыделений
{
    this(КлючВыбора[ИВыбираемый.Дескр] ключи, бцел eventCount,
                   НаборДескр readSet, НаборДескр writeSet, НаборДескр exceptionSet);

    бцел length();
	alias length длина;

    цел opApply(цел delegate(ref КлючВыбора) дг);
}


version (Windows)
{

    private struct НаборДескр
    {
        /** Default число of handles that will be held in the НаборДескр. */
        const бцел ДефРазмер = 63;

        бцел[] _buffer;

        проц установи(бцел размер = ДефРазмер);
        бул инициализован();
        бцел length();
        проц установи(ИВыбираемый.Дескр укз);
        проц очисть(ИВыбираемый.Дескр укз);
        НаборДескр копируй(НаборДескр handleSet);
        public бул набор_ли(ИВыбираемый.Дескр укз);
        public набор_уд* opCast();
	}
}
else version (Posix)
{
    private struct НаборДескр
    {
        const бцел ДефРазмер     = 1024;

        МассивБит _buffer;

        проц установи(бцел размер = ДефРазмер);
        бул инициализован();
        public проц установи(ИВыбираемый.Дескр укз);
        public проц очисть(ИВыбираемый.Дескр укз);
        НаборДескр копируй(НаборДескр handleSet);
        бул набор_ли(ИВыбираемый.Дескр укз);
        набор_уд* opCast();
	}
}
