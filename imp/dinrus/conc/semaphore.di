module conc.semaphore;

import conc.sync;
private import conc.waitnotify;

class Семафор : ОбъектЖдиУведоми, Синх 
 {
  protected дол права_; 
  
  this(дол начальныеПрава);
  synchronized проц обрети() ;
  synchronized бул пытайся(дол мсек) ;
  проц отпусти(дол n) ;
  synchronized проц отпусти() ;
  synchronized дол права() ;
  }

