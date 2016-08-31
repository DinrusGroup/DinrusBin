module io.stream.Zlib;

private import lib.zlib;
private import exception : ВВИскл;
private import io.device.Conduit : ФильтрВвода, ФильтрВывода;
private import io.model : ИПотокВвода, ИПотокВывода, ИПровод;


private enum { CHUNKSIZE = 256 * 1024 };

private enum { WINDOWBITS_DEFAULT = 15 };


class ВводЗлиб : ФильтрВвода
{

    enum Кодировка : цел
    {
        Guess,
        Zlib,
        Gzip,
        Нет
    }

    private
    {
        бул zs_valid = нет;

        z_stream zs;
        ббайт[] in_chunk;
    }
    
    this(ИПотокВвода поток, Кодировка кодировка, цел windowBits = WINDOWBITS_DEFAULT);
    this(ИПотокВвода поток);
    private проц init(ИПотокВвода поток, Кодировка кодировка, цел windowBits);    
    ~this();
    проц сбрось(ИПотокВвода поток, Кодировка кодировка, цел windowBits = WINDOWBITS_DEFAULT);
    проц сбрось(ИПотокВвода поток);
    override т_мера читай(проц[] приёмн);
    override проц закрой();
    override дол сместись(дол смещение, Якорь якорь = Якорь.Нач);
    private проц kill_zs();
    private проц check_valid();
}

class ВыводЗлиб : ФильтрВывода
{

    enum Уровень : цел
    {
        Нормальный = -1,
        Нет = 0,
        Быстрый = 1,
        Наилучший = 9
    }

    enum Кодировка : цел
    {
        Zlib,
        Gzip,
        Нет
    }

    private
    {
        бул zs_valid = нет;
        z_stream zs;
        ббайт[] out_chunk;
        т_мера _written = 0;
    }

    this(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
            цел windowBits = WINDOWBITS_DEFAULT);
    this(ИПотокВывода поток, Уровень уровень = Уровень.Нормальный);
    private проц init(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
            цел windowBits);
    ~this();
    проц сбрось(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
            цел windowBits = WINDOWBITS_DEFAULT);
    проц сбрось(ИПотокВывода поток, Уровень уровень = Уровень.Нормальный);
    override т_мера пиши(проц[] ист);
    т_мера записано();
    override проц закрой();
    проц подай();
    override дол сместись(дол смещение, Якорь якорь = Якорь.Нач);
    private проц kill_zs();
    private проц check_valid();
}

class ИсклЗлибЗакрыт : ВВИскл
{
    this();
}


class ИсклЗлибЕщёНеЗакрыт : ВВИскл
{
    this();
}

class ИсклЗлиб : ВВИскл
{
    this(ткст сооб);
    this(цел код);
    this(цел код, сим* сооб);
    protected ткст имяКода(цел код);
}