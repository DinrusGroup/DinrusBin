module conc.boundedchannel;
import conc.channel;

interface ОграниченныйКанал(T) : Канал!(T)
 {
  public цел ёмкость();
}
