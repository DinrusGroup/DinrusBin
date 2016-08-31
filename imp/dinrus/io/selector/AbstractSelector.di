module io.selector.AbstractSelector;

public import io.model, time.Time;
private import io.selector.model;


version (Windows)
{
    public struct значврем
    {
        цел сек;     // сек
        цел микросек;    // микросекунды
    }
}



abstract class АбстрактныйСелектор: ИСелектор
{

    public бул перезапускПрерванногоСистВызова();
    public проц перезапускПрерванногоСистВызова(бул значение);
    public abstract проц открой(бцел размер, бцел maxEvents);
    public abstract проц закрой();
    public abstract проц регистрируй(ИВыбираемый провод, Событие события,
                                  Объект атачмент);
    deprecated public final проц повториРег(ИВыбираемый провод, Событие события,
            Объект атачмент = пусто);
    public abstract проц отмениРег(ИВыбираемый провод);
    public цел выбери();
    public цел выбери(дво таймаут);
    public abstract цел выбери(ИнтервалВремени таймаут);
    public abstract ИНаборВыделений наборВыд();
    public abstract КлючВыбора ключ(ИВыбираемый провод);
    public abstract т_мера счёт();
    public значврем* вЗначВрем(значврем* tv, ИнтервалВремени интервал);
    protected проц проверьНомОш(ткст файл, т_мера строка);
    
}
