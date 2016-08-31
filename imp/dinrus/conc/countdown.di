module conc.countdown;
import conc.sync;
private import conc.waitnotify;

class ОбратныйОтсчёт : ОбъектЖдиУведомиВсех, Синх {
  protected final цел начальнСчёт_;
  protected цел счёт_;


  this(цел счёт) ;
  synchronized проц обрети() ;
  synchronized бул пытайся(дол мсек) ;
  synchronized проц отпусти();
  цел начальныйСчёт();
  synchronized цел текущийСчёт();

}

