module conc.fifosemaphore;
import conc.queuedsemaphore;


class СемафорПВПВ : СемафорВОчереди 
{

  this(дол начальныеПрава);

  protected class ЖдущаяОчередьФИФО : ЖдущаяОчередь
  {
    protected ЖдущийУзел голова_ = пусто;
    protected ЖдущийУзел хвост_ = пусто;

    protected проц вставь(ЖдущийУзел w) ;
    protected ЖдущийУзел извлеки() ;
  }
  
} 
 
