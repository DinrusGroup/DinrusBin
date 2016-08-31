module conc.latch;
import conc.sync;
private import conc.waitnotify;

class Щеколда : ОбъектЖдиУведомиВсех, Синх 
{
  protected бул защёлкнут_ = нет;

  synchronized проц обрети() ;
  synchronized бул пытайся(дол мсек) ;
  synchronized проц отпусти();
}

