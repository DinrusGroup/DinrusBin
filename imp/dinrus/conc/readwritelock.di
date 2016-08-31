module conc.readwritelock;

import thread, conc.sync;
private import conc.waitnotify;

interface ЧЗЗамок
 {
  Синх замокЧтения();
  Синх замокЗаписи();
}

class ЧЗЗамокПредпочтенияПисателя : ЧЗЗамок
 {

  protected дол активныеЧитатели_ = 0; 
  protected Нить активныеПисатели_ = пусто;
  protected дол ждущиеЧитатели_ = 0;
  protected дол ждущиеПисатели_ = 0;

  protected ЗамокЧитателя замокЧитателя_;
  protected ЗамокПисателя замокПисателя_;

  this() ;
  ~this() ;
  Синх замокЗаписи();
  Синх замокЧтения();
  protected synchronized проц отменённыйЖдущийЧитатель();
  protected synchronized проц отменённыйЖдущийПисатель();
  protected бул позволитьЧитателю() ;
  protected synchronized бул стартЧтения();
  protected synchronized бул стартЗаписи();
  protected synchronized бул стартЧтенияИзНовогоЧитателя();
  protected synchronized бул стартЗаписиИзНовогоПисателя() ;
  protected synchronized бул стартЧтенияИзЖдущегоЧитателя() ;
  protected synchronized бул стартЗаписиИзЖдущегоПисателя();
  protected synchronized Сигналист конецЧтения();
  protected synchronized Сигналист конецЗаписи() ;
  
			  protected interface Сигналист 
			  { 
				проц ждутСигнала();
			  }

			  protected class ЗамокЧитателя : ОбъектЖдиУведомиВсех, Сигналист, Синх 
			  {
				ЧЗЗамокПредпочтенияПисателя объ;

				this(ЧЗЗамокПредпочтенияПисателя объ) ;
				проц обрети();
				проц отпусти();
				synchronized проц ждутСигнала();
				бул пытайся(дол мсек);

			  }

			  protected class ЗамокПисателя : ОбъектЖдиУведоми, Сигналист, Синх
			  {
				ЧЗЗамокПредпочтенияПисателя объ;

				this(ЧЗЗамокПредпочтенияПисателя объ) ;
				проц обрети() ;
				проц отпусти();
				synchronized проц ждутСигнала();
				бул пытайся(дол мсек);
			  }
}