
module conc.synchronizedvariable;

import conc.executor;


public class СинхронизованнаяПеременная : Исполнитель 
{

  protected final Объект замок_;
  public this(Объект замок);
  public this() ;
  public Объект дайЗамок();
  public проц выполни(цел delegate() команда) ;
}
