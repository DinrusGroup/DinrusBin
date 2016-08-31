
module tpl.singleton;
import win, stdrus;

/**
  * ДержательСинглтона реализует образец синглтона
  */
final static class ДержательСинглтона(T)
{
	public alias ДержательСинглтона!(T) ТипСам;
   	private static T с_экземпляр;

   	private synchronized static this()
   	{
        static assert(is(T == class) || is(T == struct) || is(T == union), 
                "ДержательСинглтона: только класс, союз или структура");

		static if(is(T == class))
   			с_экземпляр = new T();
	}

    public static T экземпляр()
    {
		static if(is(T == class))
            assert(с_экземпляр !is пусто);
           
        return с_экземпляр;
    }

    public static T opCall()
    {
        return экземпляр;
    }
}

////////////////////////////////////////////////
//module auxd.OpenMesh.Core.Utils.SingletonT;

class ОшибкаРантайма : Искл
{
    this(ткст сооб)
    {
        super("[ошибка рантайма]" ~ сооб);
    }
}

/** Простой шаблон синглтона.
    Инкапсулирует произвольный класс и обеспечивает его уникальность.
*/

class Синглтон(T)
{
public:

    /** Функция доступа к синглтону.
        Use this function to obtain a reference to the instance of the 
        encapsulated class. Note that this instance is unique and created
        on the first call to Экземпляр().
    */

    static T Экземпляр()
    {
        if (!укнаэкз__)
        {
            // check if singleton жив
            if (разрушен__)
            {
                приМёртвойССылке();
            }
            // first time request -> initialize
            else
            {
                создай();
            }
        }
        return укнаэкз__;
    }


private:

    // создай a new singleton and store its pointer
    static проц создай()
    {
        укнаэкз__ = new T;
    }
  
    // Will be called if instance is accessed after its lifetime has expired
    static проц приМёртвойССылке()
    {
        throw new ОшибкаРантайма("[Ошибка синглтона] - Обнаружена мёртвая ссылка!\n");
    }

    this();
    ~this()
    {
        укнаэкз__ = пусто;
        разрушен__ = да;
    }
  
    static T     укнаэкз__ = пусто;
    static бул  разрушен__ = нет;
}

class Тест {
    this() {
        скажинс("Создание класса Тест");
    }
    ~this() {
        скажинс("Уничтожение класса Тест");
    }
    ткст фуу = "hi";
}

unittest {
    alias Синглтон!(Тест)  СинглтонТест;
    скажинс(СинглтонТест.Экземпляр.фуу);
    СинглтонТест.Экземпляр.фуу = "bar";
    скажинс(СинглтонТест.Экземпляр.фуу);
}