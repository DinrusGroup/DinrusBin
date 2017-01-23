module std.cpuid;

private import stdrus: Процессор;



/*
extern (D) struct Процессор
{
	ткст производитель();
	ткст название()		;
	бул поддержкаММЭкс()	;
	бул поддержкаФЭксСР()	;
	бул поддержкаССЕ()		;
	бул поддержкаССЕ2()		;
	бул поддержкаССЕ3()		;
	бул поддержкаСССЕ3()	;
	бул поддержкаАМД3ДНау()	;
	бул поддержкаАМД3ДНауЭкст();
	бул поддержкаАМДММЭкс()	;
	бул являетсяИА64()		;
	бул являетсяАМД64()		;
	бул поддержкаГиперПоточности();
	бцел потоковНаЦПБ()		;
	бцел ядерНаЦПБ()		;
	бул являетсяИнтел()		;
	бул являетсяАМД()		;
	бцел поколение()		;
	бцел модель()			;
	бцел семейство()		;
	ткст вТкст()			;
}
*/

public static Процессор* ЦПБ;

static this()
	{
	ЦПБ = new Процессор;
	}

public:

    char[] toString()
    {
	return ЦПБ.вТкст();
    }
	
    /// Returns vendor string
    char[] vendor()             {return ЦПБ.производитель();}
    /// Returns processor string
    char[] processor()          {return ЦПБ.название();}

    /// Is MMX supported?
    bool mmx()                  {return ЦПБ.поддержкаММЭкс();}
    /// Is FXSR supported?
    bool fxsr()                 {return ЦПБ.поддержкаФЭксСР();}
    /// Is SSE supported?
    bool sse()                  {return ЦПБ.поддержкаССЕ();}
    /// Is SSE2 supported?
    bool sse2()                 {return ЦПБ.поддержкаССЕ2();}
    /// Is SSE3 supported?
    bool sse3()                 {return ЦПБ.поддержкаССЕ3();}
    /// Is SSSE3 supported?
    bool ssse3()                {return ЦПБ.поддержкаСССЕ3();}

    /// Is AMD 3DNOW supported?
    bool amd3dnow()             {return ЦПБ.поддержкаАМД3ДНау();}
    /// Is AMD 3DNOW Ext supported?
    bool amd3dnowExt()          {return ЦПБ.поддержкаАМД3ДНауЭкст();}
    /// Is AMD MMX supported?
    bool amdMmx()               {return ЦПБ.поддержкаАМДММЭкс();}

    /// Is this an Intel Architecture IA64?
    bool ia64()                 {return ЦПБ.являетсяИА64();}
    /// Is this an AMD 64?
    bool amd64()                {return ЦПБ.являетсяАМД64();}

    /// Is hyperthreading supported?
    bool hyperThreading()       {return ЦПБ.поддержкаГиперПоточности();}
    /// Returns number of threads per CPU
    uint threadsPerCPU()        {return ЦПБ.потоковНаЦПБ();}
    /// Returns number of cores in CPU
    uint coresPerCPU()          {return ЦПБ.ядерНаЦПБ();}

    /// Is this an Intel processor?
    bool intel()                {return ЦПБ.являетсяИнтел();}
    /// Is this an AMD processor?
    bool amd()                  {return ЦПБ.являетсяАМД();}

    /// Returns stepping
    uint stepping()             {return ЦПБ.поколение();}
    /// Returns model
    uint model()                {return ЦПБ.модель();}
    /// Returns family
    uint family()               {return ЦПБ.семейство();}

unittest
{
//import win;
  void main()
  {
  скажинс(toString());
  }
}
   