module conc.sync;

public interface Синх
 {
  public проц обрети();
  public бул пытайся(дол мсек);
  public проц отпусти();
  public const дол СЕКУНДА = 1000;
  public const дол МИНУТА = 60 * СЕКУНДА;
  public const дол ЧАС = 60 * МИНУТА;
  public const дол ДЕНЬ = 24 * ЧАС;
  public const дол НЕДЕЛЯ = 7 * ДЕНЬ;
  public const дол ГОД = cast(дол)(365.2425 * ДЕНЬ);
  public const дол ВЕК = 100 * ГОД;


}

class ИсклОжидания : Искл 
{
  public this(ткст ткт);
}

