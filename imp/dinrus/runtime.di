module runtime;
pragma(lib,"dinrus.lib");
private import  gc, global, win;

/////////////////////////////
//Структура для инициализации рантайма Динрус
//extern(C) ИнфОМодуле[] _moduleinfo_array;
extern(C)
{
 Рантайм рантайм();
 ук консБуфЭкрана();
 бцел идБазовогоПроцесса();
 //ИНФОСТАРТА дайСтартИнфо();
бцел идПроцесса();
}

extern(C) struct Рантайм
{
alias старт opCall;
бул старт();
проц стоп();
бул интегрируй(ИнфОМодуле[] масмод);
т_см дайСборщикМусора();
ИнфОМодуле[] дайКонструкторы();
ИнфОМодуле[] дайДеструкторы();
}


///////////////////////////////////////////////////
 extern (D)
 {
	 void setFinalizer(void *p, GC_FINALIZER pFn);
	 void addRoot(void *p);
	 void removeRoot(void *p);
	 void addRange(void *pbot, void *ptop);
	 void removeRange(void *pbot);
	 void fullCollect();
	 void fullCollectNoStack();
	 void genCollect();
	 void minimize();
	 void disable();
	 void enable();
	 void getStats(out GCStats stats);
	 void hasPointers(void* p);
	 void hasNoPointers(void* p);
	 void setV1_0();
	 void printStats(gc_t gc);
	 //void[] malloc(size_t разм, uint ba = 0);
	//void[] realloc(void* p, size_t разм, uint ba = 0);
	 size_t capacity(void* p);
	 size_t capacity(void[] p);
	 void[] malloc(size_t nbytes);
	 void[] realloc(void* p, size_t nbytes);
	 size_t extend(void* p, size_t minbytes, size_t maxbytes);
	//size_t capacity(void* p);
	 void new_finalizer(void *p, bool dummy);
}
////////////////////////////////////////////////////////////////////

extern(C) struct ДанныеОДлл
{
ткст имя;
экз указатель;
ткст путь;
}

/*Получить данные от базовой библиотеки (Dinrus.Base.dll)
*/
extern (C)	ДанныеОДлл данныеБазовойДлл();


		
unittest
{
ДанныеОДлл д;

д = данныеБазовойДлл();
скажифнс ( "Имя: %s, Handle: %s, Путь: %s", д.имя, д.указатель, д.путь);
for (бцел i = 0; i < _модули.length; i++)
{
			ИнфОМодуле m = _модули[i];

			if (!m)
				continue;

			//эхо("\tmodule[%d] = '%.*s'\n", i, m.name);
			эхо("Module[%d] = '%.*s', m = x%x, m.flags = x%x\n", i, m.name, m, m.flags);
}
}