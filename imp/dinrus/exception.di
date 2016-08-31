module exception;
pragma(lib,"dinrus.lib");

типПроверОбр   проверОбр   = пусто;
типСледОбр    трОбр    = пусто;


extern(C) struct СисОш
{  
        static бцел последнКод ();
        static ткст последнСооб ();
        static ткст найди (бцел кодош);
}

 extern (D):
 
class ИсклВнешнМодуля:Исключение
{
	this(ткст сооб);
    this(бцел кодош);
}
 
 class ФайлИскл : Исключение
{
    бцел номош;	
	
    this(ткст имя);
    this(ткст имя, ткст сооб);
    this(ткст имя, бцел номош);
}
 
class ИсклНедостающЧлена : Исключение 
{
  this() ;
  this(ткст сообщение) ;
  this(ткст имяКласса, ткст имяЧлена);
}

class ИсклКОМ : Исключение 
{
  this(цел кодОшибки) ;
  this(ткст сообщение, цел кодОшибки) ;
  цел кодОшибки();
 }

class ВнеПамИскл : Исключение
	{		
		this( ткст файл =__FILE__, т_мера строка =__LINE__ );
		override ткст toString();
	}
alias ВнеПамИскл OutOfMemoryException;


class ОтслежИскл : Исключение
	{
		this( ткст сооб );
		this( ткст сооб, Исключение e );
		this( ткст сооб, ткст файл, т_мера строка );
		 ткст toString();
		 ткст вТкст();
		цел opApply( цел delegate( inout ткст буф ) дг );
	}
alias ОтслежИскл TracedException;


class ПлатформИскл : ОтслежИскл
{
    this( ткст сооб );
}
alias ПлатформИскл PlatformException;


class ПроверИскл : ОтслежИскл
{
    this( ткст файл =__FILE__, т_мера строка = __LINE__);
    this( ткст сооб, ткст файл = __FILE__, т_мера строка =__LINE__ );
}
alias ПроверИскл AssertException;


class ПроверОшиб : Искл
	{
		this(ткст имяф =__FILE__, бцел номстроки =__LINE__);
		this(ткст сооб, ткст имяф = __FILE__, бцел номстроки = __LINE__);
		~this();
	}
alias ПроверОшиб AssertError;


class ГранМасИскл : ОтслежИскл
	{
		this( ткст файл = __FILE__, т_мера строка = __LINE__ );
	}
alias ГранМасИскл ArrayBoundsException;


class ГранМасОшиб : Искл
	{  
		this(ткст имяф =__FILE__, т_мера номстроки = __LINE__);
	}
alias ГранМасОшиб ArrayBoundsError;


class ФинализИскл : ОтслежИскл
	{
		this( ИнфОКлассе c, Исключение e = пусто );
		override ткст toString();
	}
alias ФинализИскл FinalizeException;


class ЩитИскл : ОтслежИскл
	{
		this( ткст файл =__FILE__, т_мера строка =__LINE__ );
	}
alias ЩитИскл SwitchException;


class ЩитОшиб : Искл
	{
	   this(ткст имяф = __FILE__, бцел номстроки =__LINE__);
		override void print();
	}
alias ЩитОшиб SwitchError;


class ТекстИскл : ОтслежИскл
	{
		this( ткст сооб );
	}
alias ТекстИскл TextException;


class ЮникодИскл : ТекстИскл
	{
		this( ткст сооб, т_мера idx );
	}
alias ЮникодИскл UnicodeException;


class НитьИскл : ПлатформИскл
	{
		this( ткст сооб );
	}
alias НитьИскл ThreadException;


class ФибраИскл : ThreadException
	{
		this( ткст сооб );
	}
alias ФибраИскл FiberException;


class СинхИскл : ПлатформИскл
	{
		this( ткст сооб );
	}
alias СинхИскл SyncException;


class ВВИскл : ПлатформИскл
	{
		this( ткст сооб );
	}
alias ВВИскл IOException;


class ВфсИскл : IOException
	{
		this( ткст сооб );
	}
alias ВфсИскл VfsException;


class КластерИскл : IOException
	{
		this( ткст сооб );
	}
alias КластерИскл ClusterException;


class СокетИскл : IOException
	{
		this( ткст сооб, цел ош = 0 );
	}
alias СокетИскл SocketException;


class ХостИскл : IOException
	{
		this( ткст сооб, цел ош = 0 );
	}
alias ХостИскл HostException;


class АдрИскл : IOException
	{
		this( ткст сооб, цел ош = 0 );
	}
alias АдрИскл AddressException;


class СокетПриёмИскл : СокетИскл
	{
		this( ткст сооб );
	}
alias СокетПриёмИскл SocketAcceptException;


class ПроцессИскл : ПлатформИскл
	{
		this( ткст сооб );
	}
alias ПроцессИскл ProcessException;


class РегВырИскл : TextException
	{
		this( ткст сооб );
	}
alias РегВырИскл RegexException;


class ИсклЛокали : TextException
	{
		this( ткст сооб );
	}
alias ИсклЛокали LocaleException;


class ИсклРеестра : ОтслежИскл
	{
		this( ткст сооб );
	}
alias ИсклРеестра RegistryException;


class НевернАргИскл : ОтслежИскл
	{
		this( ткст сооб );
	}
alias НевернАргИскл IllegalArgumentException, ИсклНелегальногоАргумента;


class НевернЭлемИскл : НевернАргИскл
	{
		this( ткст сооб );
	}
alias НевернЭлемИскл IllegalElementException;


class НетЭлементаИскл : ОтслежИскл
{
    this( ткст сооб );
}
alias НетЭлементаИскл NoSuchElementException;


class  ИсклПовреждённыйИтератор: NoSuchElementException
{
    this( ткст сооб );
}
alias ИсклПовреждённыйИтератор CorruptedIteratorException;

class ФинализОшиб : Исключение
	{
		 this( ИнфОКлассе c, Исключение e = пусто );
		override string toString();
	}
alias ФинализОшиб  FinalizeError;


  class ДиапазонИскл : Исключение
{
    this( string файл, т_мера строка );
}


  class СкрытФункцИскл : Исключение
{
    this( ИнфОКлассе ci );
}

 class ИсклРЯР : TextException
{
    this(ткст сооб);
}

////////////////////////
class АргИскл : Исключение 
{
  this();
  this(ткст сооб);
  this(ткст сооб, ткст парамИмя) ;
  final ткст парамИмя() ;
}

 class ПустойАргИскл : АргИскл
 {
  this() ;
  this(ткст парамИмя);
  this(ткст парамИмя, ткст сооб) ;
}

class АргВнеИскл : АргИскл
 {
  this();
  this(ткст парамИмя) ;
  this(ткст парамИмя, ткст сооб);
}

class ФорматИскл : Исключение
 {
  this() ;
  this(ткст сооб);
}

class КастИскл : Исключение
 {
  this() ;
  this(ткст сооб);
}

 class ОпИскл : Исключение
 {
  this();
  this(ткст сооб) ;
}

class НереализИскл : Исключение 
{
  this();
  this(ткст сооб) ;
}

 class НеПоддерживаетсяИскл : Исключение 
 {
  this() ;
  this(ткст сооб);
}

class НулСсылкаИскл : Исключение
 {
  this() ;
  this(ткст сооб);
}

class ВзломИскл : Исключение
 {
  this() ;
  this(ткст сооб) ;
}

class БезопИскл : Исключение 
{
  this() ;
  this(ткст сооб);
}

class МатИскл : Исключение 
{
  this() ;
  this(ткст сооб) ;
}

class ПереполнИскл : МатИскл 
{
  this() ;
  this(ткст сооб) ;
}

 



