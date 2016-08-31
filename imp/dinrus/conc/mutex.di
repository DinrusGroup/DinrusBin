module conc.mutex;
import conc.sync;
private import conc.waitnotify;

class Мютекс : ОбъектЖдиУведоми,Синх  {

  protected бул inuse_ = нет; ///< Статус замка

  synchronized проц обрети() ;
  synchronized проц отпусти();
  synchronized бул пытайся(дол мсек);
  }
