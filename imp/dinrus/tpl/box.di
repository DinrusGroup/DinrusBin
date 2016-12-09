module tpl.box;
import dinrus;

class РазбоксИскл : Исключение
{

    Бокс объект;	/// Бокс, который пользователь пытается разбоксировать.

    ИнфОТипе типВывода; /// Это тип, в который пользователь разбоксирует значение.

    /**
     * Assign parameters and create the message in the form
     * <tt>"Could not unbox from type ... to ... ."</tt>
     */
    this(Бокс объект, ИнфОТипе типВывода, ткст файл = "Неизвестно", т_мера строка = 0)
    {
        this.объект = объект;
        this.типВывода = типВывода;
        super(форматируй("Не удалось разбоксирование из типа %s в тип %s.", объект.тип, типВывода), файл, строка);
		//шим* soob =cast(шим*)(вЮ16(форматируй("Не удалось разбоксирование из типа %s в %s.", объект.тип, типВывода)));
		//ОкноСооб(пусто, cast(шим*) soob, "Рантайм Динрус: РазбоксИскл", ПСооб.Ок|ПСооб.Ошибка);
    }
}

 бул инфОТипеМассив_ли(ИнфОТипе тип)
{
    char[] имя = тип.classinfo.name;
    return имя.length >= 10 && имя[9] == 'A' && имя != "TypeInfo_AssociativeArray";
}

protected template разбоксКастРеал(T)
{
    T разбоксКастРеал(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (значение.тип is typeid(плав))
            return cast(T) *cast(плав*) значение.данные;
        if (значение.тип is typeid(дво))
            return cast(T) *cast(дво*) значение.данные;
        if (значение.тип is typeid(реал))
            return cast(T) *cast(реал*) значение.данные;
        return разбоксКастЦелый!(T)(значение);
    }
}

protected template разбоксКастЦелый(T)
{
    T разбоксКастЦелый(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (значение.тип is typeid(цел))
            return cast(T) *cast(int*) значение.данные;
        if (значение.тип is typeid(бцел))
            return cast(T) *cast(uint*) значение.данные;
        if (значение.тип is typeid(дол))
            return cast(T) *cast(long*) значение.данные;
        if (значение.тип is typeid(бдол))
            return cast(T) *cast(ulong*) значение.данные;
        if (значение.тип is typeid(бул))
            return cast(T) *cast(bool*) значение.данные;
        if (значение.тип is typeid(байт))
            return cast(T) *cast(byte*) значение.данные;
        if (значение.тип is typeid(ббайт))
            return cast(T) *cast(ubyte*) значение.данные;
        if (значение.тип is typeid(крат))
            return cast(T) *cast(short*) значение.данные;
        if (значение.тип is typeid(бкрат))
            return cast(T) *cast(ushort*) значение.данные;
        throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
    }
}

protected template разбоксКастКомплекс(T)
{
    T разбоксКастКомплекс(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (значение.тип is typeid(кплав))
            return cast(T) *cast(кплав*) значение.данные;
        if (значение.тип is typeid(кдво))
            return cast(T) *cast(кдво*) значение.данные;
        if (значение.тип is typeid(креал))
            return cast(T) *cast(креал*) значение.данные;
        if (значение.тип is typeid(вплав))
            return cast(T) *cast(вплав*) значение.данные;
        if (значение.тип is typeid(вдво))
            return cast(T) *cast(вдво*) значение.данные;
        if (значение.тип is typeid(вреал))
            return cast(T) *cast(вреал*) значение.данные;
        return разбоксКастРеал!(T)(значение);
    }
}

protected template разбоксКастМнимое(T)
{
    T разбоксКастМнимое(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (значение.тип is typeid(вплав))
            return cast(T) *cast(вплав*) значение.данные;
        if (значение.тип is typeid(вдво))
            return cast(T) *cast(вдво*) значение.данные;
        if (значение.тип is typeid(вреал))
            return cast(T) *cast(вреал*) значение.данные;
        throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
    }
}
   
template изБокса(T)
{
    T изБокса(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (typeid(T) is значение.тип)
            return *cast(T*) значение.данные;
        throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
    }
}

template изБокса(T : байт) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : ббайт) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : крат) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : бкрат) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : цел) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : бцел) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : дол) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : бдол) { T изБокса(Бокс значение) { return разбоксКастЦелый!(T) (значение); } }
template изБокса(T : плав) { T изБокса(Бокс значение) { return разбоксКастРеал!(T) (значение); } }
template изБокса(T : дво) { T изБокса(Бокс значение) { return разбоксКастРеал!(T) (значение); } }
template изБокса(T : реал) { T изБокса(Бокс значение) { return разбоксКастРеал!(T) (значение); } }
template изБокса(T : кплав) { T изБокса(Бокс значение) { return разбоксКастКомплекс!(T) (значение); } }
template изБокса(T : кдво) { T изБокса(Бокс значение) { return разбоксКастКомплекс!(T) (значение); } }
template изБокса(T : креал) { T изБокса(Бокс значение) { return разбоксКастКомплекс!(T) (значение); } }
template изБокса(T : вплав) { T изБокса(Бокс значение) { return разбоксКастМнимое!(T) (значение); } }
template изБокса(T : вдво) { T изБокса(Бокс значение) { return разбоксКастМнимое!(T) (значение); } }
template изБокса(T : вреал) { T изБокса(Бокс значение) { return разбоксКастМнимое!(T) (значение); } }

template изБокса(T : Объект)
{
    T изБокса(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (typeid(T) == значение.тип || cast(TypeInfo_Class) значение.тип)
        {
            Объект объект = *cast(Объект*)значение.данные;
            T результат = cast(T)объект;
            
            if (объект is пусто)
                return пусто;
            if (результат is пусто)
                throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
            return результат;
        }
        
        if (typeid(ук) is значение.тип && *cast(ук*) значение.данные is пусто)
            return пусто;
        throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
    }
}

template изБокса(T : T[])
{
    T[] изБокса(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (typeid(T[]) is значение.тип)
            return *cast(T[]*) значение.данные;
        if (typeid(ук) is значение.тип && *cast(ук*) значение.данные is пусто)
            return пусто;
        throw new РазбоксИскл(значение, typeid(T[]),__FILE__, __LINE__);
    }
}

template изБокса(T : T*)
{
    T* изБокса(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (typeid(T*) is значение.тип)
            return *cast(T**) значение.данные;
        if (typeid(ук) is значение.тип && *cast(ук*) значение.данные is пусто)
            return пусто;
        if (typeid(T[]) is значение.тип)
            return (*cast(T[]*) значение.данные).ptr;
        
        throw new РазбоксИскл(значение, typeid(T*),__FILE__, __LINE__);
    }
}

template изБокса(T : ук)
{
    T изБокса(Бокс значение)
    {
        assert (значение.тип !is пусто);
        
        if (cast(TypeInfo_Pointer) значение.тип)
            return *cast(ук*) значение.данные;
        if (инфОТипеМассив_ли(значение.тип))
            return (*cast(проц[]*) значение.данные).ptr;
        if (cast(TypeInfo_Class) значение.тип)
            return cast(T)(*cast(Объект*) значение.данные);
        
        throw new РазбоксИскл(значение, typeid(T),__FILE__, __LINE__);
    }
}

template разбоксОбъ(T)
{
    бул разбоксОбъ(Бокс значение)
    {
        return значение.разбоксОбъ(typeid(T));
    }
}

template тестРазбокс(T)
{
    T тестРазбокс(Бокс значение)
    {
        T результат;
        бул разбоксОбъ = значение.разбоксОбъ(typeid(T));
		debug скажинс("вход в тестРазбокс");
        
        try результат = изБокса!(T) (значение);
        catch (РазбоксИскл ошиб)
        {
            if (разбоксОбъ)
                ошибка ("Не удалось разбоксировать " ~ значение.тип.вТкст ~ " как " ~ typeid(T).вТкст ~ "; однако разбоксОбъ должен бы работать...");
            assert (!разбоксОбъ);
            throw ошиб;
        }
        
        if (!разбоксОбъ)
            ошибка ("Разбоксирован " ~ значение.тип.вТкст ~ " как " ~ typeid(T).вТкст ~ "; однако, он должен был вызвать ошибку.");
		  return результат;
    }
}


protected enum КлассТипа
{
    Бул, /**< бул */
    Бит = Бул,	// for backwards compatibility
    Целое, /**< byte, ббайт, крат, ushort, цел, бцел, long, ulong */
    Плав, /**< плав, double, real */
    Комплекс, /**< cплав, cdouble, creal */
    Мнимое, /**< iплав, idouble, ireal */
    Класс, /**< Inherits from Объект */
    Указатель, /**< Указатель type (T *) */
    Массив, /**< Массив type (T []) */
    Другой, /**< Any второй type, such as delegates, function укзs, struct, проц... */
}


struct Бокс
{
    ИнфОТипе п_тип; /**< The type of the contained объект. */
    
    union
    {
        ук п_долДанные; /**< An массив of the contained объект. */
        проц[8] п_кратДанные; /**< Data used when the объект is small. */
    }
    
    protected static КлассТипа выявиКлассТипа(ИнфОТипе тип)
    {
        if (cast(TypeInfo_Class) тип)
            return КлассТипа.Класс;
        if (cast(TypeInfo_Pointer) тип)
            return КлассТипа.Указатель;
        if (инфОТипеМассив_ли(тип))
            return КлассТипа.Массив;

        version (DigitalMars)
        {
            /* Depend upon the имя of the base тип classes. */
            if (тип.classinfo.name.length != "TypeInfo_?".length)
                return КлассТипа.Другой;
            switch (тип.classinfo.name[9])
            {
                case 'b', 'x': return КлассТипа.Бул;
                case 'g', 'h', 's', 't', 'i', 'k', 'l', 'm': return КлассТипа.Целое;
                case 'f', 'd', 'e': return КлассТипа.Плав;
                case 'q', 'r', 'c': return КлассТипа.Комплекс;
                case 'o', 'p', 'j': return КлассТипа.Мнимое;
                default: return КлассТипа.Другой;
            }
        }
        else
        {
            /* Use the имя returned from toString, which might (but hopefully doesn't) include an allocation. */
            switch (тип.вТкст)
            {
                case "бул", "bool": return КлассТипа.Бул;
                case "byte", "байт", "ubyte", "ббайт", "short","крат", "ushort", "бкрат", "uint","бцел", "long", "дол", "ulong", "бдол": return КлассТипа.Целое;
                case "float", "плав", "real", "реал", "double","дво": return КлассТипа.Плав;
                case "cfloat", "кплав", "cdouble", "кдво", "creal", "креал": return КлассТипа.Комплекс;
                case "ifloat", "вплав","idouble","вдво", "ireal", "вреал": return КлассТипа.Мнимое;
                default: return КлассТипа.Другой;
            }
        }
    }
     static проц opCall(){}
    /** Return whether this value could be unboxed as the given тип without throwing. */
    бул разбоксОбъ(ИнфОТипе тест)
    {
        if (тип is тест)
            return да;
        
        TypeInfo_Class ca = cast(TypeInfo_Class) тип, cb = cast(TypeInfo_Class) тест;
        
        if (ca !is пусто && cb !is пусто)
        {
            ИнфОКлассе ia = (*cast(Объект *) данные).classinfo, ib = cb.info;
            
            for ( ; ia !is пусто; ia = ia.base)
                if (ia is ib)
                    return да;
            return нет;
        }
        
        КлассТипа ta = выявиКлассТипа(тип), tb = выявиКлассТипа(тест);
        
        if (тип is typeid(ук) && *cast(ук*) данные is пусто)
            return (tb == КлассТипа.Класс || tb == КлассТипа.Указатель || tb == КлассТипа.Массив);
        
        if (тест is typeid(ук))
            return (tb == КлассТипа.Класс || tb == КлассТипа.Указатель || tb == КлассТипа.Массив);
        
        if (ta == КлассТипа.Указатель && tb == КлассТипа.Указатель)
            return (cast(TypeInfo_Pointer)тип).следщ is (cast(TypeInfo_Pointer)тест).следщ;
        
        if ((ta == tb && ta != КлассТипа.Другой)
        || (ta == КлассТипа.Бул && tb == КлассТипа.Целое)
        || (ta <= КлассТипа.Целое && tb == КлассТипа.Плав)
        || (ta <= КлассТипа.Мнимое && tb == КлассТипа.Комплекс))
            return да;
        return нет;
    }
    
    /**
     * Property for the тип contained by the box.
     * This is initially пусто and cannot be assigned directly.
     * возвращает: the тип of the contained объект.
     */
     ИнфОТипе тип()
    {
        return п_тип;
    }
    
    /**
     * Property for the data укз to the value of the box.
     * This is initially пусто and cannot be assigned directly.
     * возвращает: the data массив.
     */
     проц[] данные()
    {
        т_мера размер = тип.тразм();
        
        return размер <= п_кратДанные.length ? п_кратДанные[0..размер] : п_долДанные[0..размер];
    }

    /**
     * Attempt to convert the boxed value into a string using std.string.format;
     * this will throw if that function cannot handle it. If the box is
     * uninitialized then this returns "".    
     */
    ткст toString(){return вТкст();}
   
    ткст вТкст()
    {
        if (тип is пусто)
            return "<пустой вБокс>";
        
        ИнфОТипе[2] arguments;
        char[] string;
        проц[] args = new проц[(char[]).sizeof + данные.length];
        char[] format = "%s";
        
        arguments[0] = typeid(char[]);
        arguments[1] = тип;
        
       проц putc(dchar ch)
        {
            кодируйЮ(string, ch);
        }        
        
        args[0..(char[]).sizeof] = (cast(ук) &format)[0..(char[]).sizeof];
        args[(char[]).sizeof..length] = данные;
        форматДелай(&putc, arguments, args.ptr);
        delete args;
        
        return string;
    }
    
    protected бул opEqualsInternal(Бокс второй, бул инвертирован)
    {
        if (тип != второй.тип)
        {
            if (!разбоксОбъ(второй.тип))
            {
                if (инвертирован)
                    return нет;
                return второй.opEqualsInternal(*this, да);
            }
            
            КлассТипа ta = выявиКлассТипа(тип), tb = выявиКлассТипа(второй.тип);
            
            if (ta <= КлассТипа.Целое && tb <= КлассТипа.Целое)
            {
                char[] na = тип.вТкст, nb = второй.тип.вТкст;
                
                if (na == "ulong"||na == "бдол" || nb == "ulong" || nb == "бдол")
                    return изБокса!(бдол)(*this) == изБокса!(бдол)(второй);
                return изБокса!(дол)(*this) == изБокса!(дол)(второй);
            }
            else if (tb == КлассТипа.Плав)
                return изБокса!(реал)(*this) == изБокса!(реал)(второй);
            else if (tb == КлассТипа.Комплекс)
                return изБокса!(креал)(*this) == изБокса!(креал)(второй);
            else if (tb == КлассТипа.Мнимое)
                return изБокса!(вреал)(*this) == изБокса!(вреал)(второй);
            
            assert (0);
        }
        
        return cast(бул)тип.equals(данные.ptr, второй.данные.ptr);
    }

    /**
     * Compare this box's value with another box. This implicitly casts if the
     * types are different, identical to the regular тип system.    
     */
    бул opEquals(Бокс другой)
    {
	//скажинс("пошло сравнение");
        return opEqualsInternal(другой, нет);
    }
    
    protected плав opCmpInternal(Бокс второй, бул инвертирован)
    {
        if (тип != второй.тип)
        {
            if (!разбоксОбъ(второй.тип))
            {
                if (инвертирован)
                    return 0;
                return второй.opCmpInternal(*this, да);
            }
            
            КлассТипа ta = выявиКлассТипа(тип), tb = выявиКлассТипа(второй.тип);
            
            if (ta <= КлассТипа.Целое && tb == КлассТипа.Целое)
            {
                if (тип == typeid(бдол) || второй.тип == typeid(бдол))
                {
                    ulong va = изБокса!(бдол)(*this), vb = изБокса!(бдол)(второй);
                    return va > vb ? 1 : va < vb ? -1 : 0;
                }
                
                long va = изБокса!(дол)(*this), vb = изБокса!(дол)(второй);
                return va > vb ? 1 : va < vb ? -1 : 0;
            }
            else if (tb == КлассТипа.Плав)
            {
                real va = изБокса!(реал)(*this), vb = изБокса!(реал)(второй);
                return va > vb ? 1 : va < vb ? -1 : va == vb ? 0 : плав.nan;
            }
            else if (tb == КлассТипа.Комплекс)
            {
                creal va = изБокса!(креал)(*this), vb = изБокса!(креал)(второй);
                return va == vb ? 0 : плав.nan;
            }
            else if (tb == КлассТипа.Мнимое)
            {
                ireal va = изБокса!(вреал)(*this), vb = изБокса!(вреал)(второй);
                return va > vb ? 1 : va < vb ? -1 : va == vb ? 0 : плав.nan;
            }
            
            assert (0);
        }
        
        return тип.compare(данные.ptr, второй.данные.ptr);
    }

    /**
     * Compare this box's value with another box. This implicitly casts if the
     * types are different, identical to the regular тип system.
     */
    плав opCmp(Бокс другой)
    {
        return opCmpInternal(другой, нет);
    }

    /**
     * Return the value's hash.
     */
    т_хэш вХэш()
    {
        return тип.getHash(данные.ptr);
    }
}

//////////////////////////////

Бокс вБокс(...)
	in
	{
		assert (_arguments.length == 1);
	}
	body
	{
	
		return вБокс(_arguments[0], _argptr);
	}
  

Бокс вБокс(ИнфОТипе тип, ук данные)
in
{
    assert(тип !is пусто);
}
body
{
//скажинс("начинаю работать...");
    Бокс результат;
	//скажинс("вхожу в первое присваивание...");
    т_мера размер = тип.tsize();
    //скажинс("первое присваивание...");
    результат.п_тип = тип;
	//скажинс("второе присваивание...");
    if (размер <= результат.п_кратДанные.length){
        результат.п_кратДанные[0..размер] = данные[0..размер];
		//скажинс("условное присваивание...");
		}
    else
	{
        результат.п_долДанные = данные[0..размер].dup.ptr;
		//скажинс("безусловное присваивание...");
		}
        //скажинс(форматируй("выдаю рез...%s", результат.вТкст));
		//скажинс(форматируй("входный тип...%s", тип.вТкст));
		//скажинс(форматируй("размер входных данных...%s", данные.sizeof));
    return результат;
}


protected т_мера длинаАргумента(т_мера baseLength)
{
    return (baseLength + цел.sizeof - 1) & ~(цел.sizeof - 1);
}
  
 Бокс[] масБокс(ИнфОТипе[] типы, ук данные)
{
//скажинс("вызываю фцию222...");
    Бокс[] массив = new Бокс[типы.length];
    
    foreach(т_мера индекс, ИнфОТипе тип; типы)
    {
        массив[индекс] = вБокс(тип, данные);
        данные += длинаАргумента(тип.tsize());
    }
       return массив;
}

проц массивБоксВАргументы(Бокс[] аргументы, out ИнфОТипе[] типы, out ук данные)
	{
		т_мера длинаДанных;
		ук укз;
	// скажинс("вызываю фцию111...");
		foreach (Бокс элемент; аргументы)
		
			длинаДанных += длинаАргумента(элемент.данные.length);
			
		типы = new ИнфОТипе[аргументы.length];
		укз = данные = (new проц[длинаДанных]).ptr;

		foreach (т_мера индекс, Бокс элемент; аргументы)
		{
			типы[индекс] = элемент.тип;
			укз[0..элемент.данные.length] = элемент.данные;
			укз += длинаАргумента(элемент.данные.length);
		}    
	}
	


   
Бокс[] масБокс(...)
	{
	//скажинс("вызываю фцию222...");
		return масБокс(_arguments, _argptr);
	}