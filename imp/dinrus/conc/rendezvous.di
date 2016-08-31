module conc.rendezvous;

import conc.barrier;
private import conc.fairsemaphore, conc.semaphore, conc.sync;
private import conc.waitnotify;

class Рандеву : ОбъектЖдиУведомиВсех, Барьер 
{
  alias проц function(Объект[] объекты) ФункцРандеву;
  static проц функцРандеву(Объект[] объекты);
  
  protected final цел участники_;
  protected бул сорван_ = нет;
  protected цел вхождения_ = 0;
  protected дол отправлены_ = 0;
  protected final Семафор ворота_;
  protected final Объект[] слоты_;
  protected ФункцРандеву функцРандеву_;

  this(цел участники);
  this(цел участники, ФункцРандеву функц_) ;
  synchronized ФункцРандеву установиФункцРандеву(ФункцРандеву функц_) ;
  цел участники() ;
  synchronized бул сломан();
  public проц рестарт();
  Объект рандеву(Объект x);
  Объект пробуйРандеву(Объект x, дол мсек) ;
  protected Объект делайРандеву(Объект x, бул по_времени, дол мсек);

}


