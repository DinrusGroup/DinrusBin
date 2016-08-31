module conc.syncutils;

import conc.sync;


class НуллСинх : Синх 
{

  synchronized проц обрети();
  synchronized бул пытайся(дол мсек);
  synchronized проц отпусти();
}

class ТаймаутСинх : Синх
 {

  protected final Синх синх_;  
  protected final дол таймаут_; 

  this(Синх sync, дол таймаут);
  ~this();
  проц обрети();
  бул пытайся(дол мсек);
  проц отпусти();
}

class СлойныйСинх : Синх 
{

  protected final Синх внешний_;
  protected final Синх внутренний_;


  this(Синх внешний, Синх внутренний);
  ~this();
  проц обрети() ;
  бул пытайся(дол мсек);
  public проц отпусти() ;

}
