module conc.cyclicbarrier;
import conc.barrier;
private import conc.waitnotify, conc.sync;
private import cidrus;


class ЦиклическийБарьер : ОбъектЖдиУведомиВсех, Барьер
 {

  alias цел function() Пускаемый;

  protected final цел участники_;
  protected бул сорван_ = нет;
  protected Пускаемый командаБарьер_ = пусто;
  protected цел счёт_; // число of участники still ждущий
  protected цел сбросы_ = 0; // incremented on each отпусти
 
  this(цел участники) ;
  this(цел участники, Пускаемый команда) ;
  synchronized Пускаемый установиКомандуБарьера(Пускаемый команда);
  synchronized бул сломан();
  synchronized проц рестарт() ; 
  цел участники();
  цел барьер() ;
  цел пробуйБарьер(дол мсек);
  protected synchronized цел делайБарьер(бул по_времени, дол мсек);

}
