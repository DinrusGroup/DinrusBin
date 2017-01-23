module conc.prioritysemaphore;

import conc.queuedsemaphore;
private import conc.waitnotify;


class СемафорПриоритетов : СемафорОчереди
 {

  this(дол начальныеПрава);
  
			  protected class ЖдущаяПриоритетаОчередь : ЖдущаяОчередь 
			  {

				protected final Семафорѕ¬ѕ¬.ЖдущаяОчередь‘»‘О[] ячейки_ = 
				  new Семафорѕ¬ѕ¬.ЖдущаяОчередь‘»‘О[Нить.ћј —Р»О– -
												 Нить.ћ»НР»О– + 1];

				protected цел максИндекс_ = -1;

				protected ЖдущаяПриоритетаОчередь() ;
				protected проц вставь(ЖдущийУзел w) ;
				protected ЖдущийУзел извлеки() ;
			  }

}
