module conc.synchronizedint;

import conc.synchronizedvariable;


public class СинхронЦел : СинхронизованнаяПеременная 
{

  protected цел значение_;

  public this(цел начальноеЗначение);
  public this(цел начальноеЗначение, Объект замок) ;
  public final цел дай() ;
  public цел установи(цел новоеЗначение) ;
  public бул commit(цел предполагаемоеЗначение, цел новоеЗначение);
  public цел opPostInc() ;
  public цел opPostDec() ;
  public цел opAddAssign(цел количество);
  public цел opSubAssign(цел количество);
  public цел opMulAssign(цел фактор) ;
  public цел opDivAssign(цел фактор) ;
  public цел отрицательное() ;
  public цел комплемент();
  public цел opAndAssign(цел b) ;
  public  цел opOrAssign(цел b) ;
  public  цел opXorAssign(цел b) ;
  public цел opCmp(цел другое) ;
  public цел opCmp(СинхронЦел другое) ;
  public бул opEquals(СинхронЦел другое) ;
}

