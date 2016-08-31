module conc.defaultchannelcapacity;
import conc.synchronizedint;

class ДефолтнаяЁмкостьКанала 
{

  public static final цел НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ = 1024;
  private static СинхронЦел дефолтнаяЁмкость_;

	static this() {
	 дефолтнаяЁмкость_ = new СинхронЦел(НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ);
	}
	
  public static проц установи(цел ёмкость);
  public static цел дай();
}
