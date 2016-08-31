module conc.threadfactory;

import stdrus:Нить;


interface ФабрикаНитей 
{
  public Нить новаяНить(цел delegate() команда);
}
