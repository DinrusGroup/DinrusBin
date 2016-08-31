module conc.queuedsemaphore;

import conc.semaphore;

private import conc.waitnotify, conc.sync;
private import cidrus;


class СемафорВОчереди : Семафор
 {
  
  protected final ЖдущаяОчередь wq_;

  this(ЖдущаяОчередь q, дол начальныеПрава) ;
  проц обрети();
  бул пытайся(дол мсек);
  protected synchronized бул предпроверь();
  protected synchronized бул перепроверь(ЖдущийУзел w);
  protected synchronized ЖдущийУзел дайСигнализатора();
  проц отпусти() ;
  проц отпусти(дол n) ;
			  interface ЖдущаяОчередь
			  {
				проц вставь(ЖдущийУзел w);
				ЖдущийУзел извлеки(); 
			  }
}

class ЖдущийУзел : ОбъектЖдиУведоми
 {
  бул ждущий = да;
  ЖдущийУзел следщ = пусто;
  protected synchronized бул сигнал();
  protected synchronized бул жди_каПоВремени(СемафорВОчереди sem, 
					  дол мсек);
  protected synchronized проц жди_ка(СемафорВОчереди sem);
}
