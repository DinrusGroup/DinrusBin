module util.booltype;

class Бул
{
    цел м_Знач;

    this(цел x) ;
    this(Бул x) ;
    this(ткст x) ;

    version(БулНеизвестно)
    {

        this() ;
    }
    else
    {
        this() ;
    }

    цел opEquals(Бул pOther);
    цел opCmp(Бул pOther);
    Бул opCom();
    Бул opAnd(Бул pOther);
    Бул opOr(Бул pOther);
    Бул opXor(Бул pOther);


    version(DDOC)
    {
        version(БулНеизвестно)
        {       
            ткст вТкст();
        }
        else
        {
            ткст вТкст();
        }
    }
    else
    {
        ткст вТкст();
    }

    цел вЦел();
    Бул dup();
    version(БулНеизвестно){ Бул установлен(); }
}

static Бул Да; 
static Бул Нет;
version(БулНеизвестно){static Бул Неизвестно;}

private static this()
{
    Да = new Бул(1);
    Нет = new Бул(0);
	
version(БулНеизвестно)
	{
		Неизвестно = new Бул();
	}
}

version(БулНеизвестно)
{

	class БулИскл : Исключение
	{

	   this(ткст pMsg);
	}
}
