module conc.reentrantlock;

import thread, conc.sync;
private import conc.waitnotify;

class ВозобновляемыйЗамок : ОбъектЖдиУведоми, Синх
  {
  protected Нить владелец_ = пусто;
  protected дол содержит_ = 0;

  проц обрети();
  бул пытайся(дол мсек);
  synchronized проц отпусти()  ;
  synchronized проц отпусти(дол n) ;
  synchronized дол содержит() ;
}

