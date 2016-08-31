module conc.fairsemaphore;
import conc.semaphore;

final class ЯсныйСемафор : Семафор 
 {

  this(дол initial);
  protected дол ждут_ = 0; 

  synchronized проц обрети();
  synchronized бул пытайся(дол мсек) ;
  synchronized проц отпусти() ;
  synchronized проц отпусти(дол n) ;

}

