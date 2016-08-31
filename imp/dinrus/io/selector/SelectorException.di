module io.selector.SelectorException;


 
public class ИсклСелектора: Исключение
{
    public this(ткст сооб, ткст файл, бцел строка);
}

public class ИсклОтменённогоПровода: ИсклСелектора
{
    public this(ткст файл, бцел строка);
}


public class ИсклРегистрируемогоПровода: ИсклСелектора
{
    public this(ткст файл, бцел строка);
}

public class ИсклПрерванногоСистВызова: ИсклСелектора
{
    public this(ткст файл, бцел строка);
}

public class ВнеПамИскл: ИсклСелектора
{
    public this(ткст файл, бцел строка);
}

