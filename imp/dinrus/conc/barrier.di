module conc.barrier;
import conc.sync;

interface Барьер {

  цел участники();
  бул сломан();
}

class ИсклСломанногоБарьера : Искл 
{
  final цел индекс;
  this(цел инд);
  this(цел инд, ткст сооб) ;
}

class ИсклТаймаута : ИсклОжидания 
{
  public final дол продолжительность;
  this(дол время) ;
  this(дол время, ткст сооб);
}
