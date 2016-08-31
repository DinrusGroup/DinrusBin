module conc.readwritelockutils;

import thread, conc.readwritelock, conc.sync;

private import conc.waitnotify;
private import conc.fifosemaphore;


class ЧЗЗамокПВПВ : ОбъектЖдиУведоми, ЧЗЗамок 
{

  protected  СемафорПВПВ замокЗап;
  protected цел читатели;
  protected цел эксчитатели;

  this() ;
  ~this() ;
  protected проц обретиЧтение() ;
  protected synchronized проц отпустиЧтение() ;
  protected проц обретиЗапись() ;
  protected проц отпустиЗапись();
  protected бул пытайсяЧитать(дол мсек);
  protected бул пытайсяПисать(дол мсек);
  
			  protected class СинхЧитатель : Синх
			  {
				ЧЗЗамокПВПВ объ;
				this(ЧЗЗамокПВПВ объ);
				проц обрети();
				проц отпусти() ;
				бул пытайся(дол мсек);
			  }

			  protected class СинхПисатель : Синх 
			  {
				ЧЗЗамокПВПВ объ;
				this(ЧЗЗамокПВПВ объ) ;
				проц обрети() ;
				проц отпусти();
				бул пытайся(дол мсек);
			  }

  protected  Синх синхЧитатель;
  protected  Синх синхПисатель;

  Синх замокЗаписи();
  Синх замокЧтения();

}

class ВозобновляемыйЧЗЗамокПредпочтенияПисателя : ЧЗЗамокПредпочтенияПисателя 
{

  protected дол задержкиЗаписи_ = 0;  
  protected цел[Нить] читатели_;

  protected бул позволитьЧитателю();
  protected synchronized бул стартЧтения();
  protected synchronized бул стартЗаписи();
  protected synchronized Сигналист конецЧтения();
  protected synchronized Сигналист конецЗаписи() ;
}


class ЧЗЗамокПредпочтенияЧитателя : ЧЗЗамокПредпочтенияПисателя 
{
  protected бул позволитьЧитателю() ;
}

