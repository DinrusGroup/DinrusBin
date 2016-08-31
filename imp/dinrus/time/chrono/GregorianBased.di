/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.GregorianBased;

private import exception;

private import time.Time;

private import time.chrono.Gregorian;



class ГрегорианВОснове : Грегориан {

  private ДиапазонЭр[] eraRanges_;
  private цел maxYear_, minYear_;
  private цел currentEra_ = -1;

  this() 
  {
    eraRanges_ = ДиапазонЭр.дайДиапазоныЭр(опр);
    maxYear_ = eraRanges_[0].годМаксЭры;
    minYear_ = eraRanges_[0].годМинЭры;
  }

  public /*override*/ Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел сукунда, бцел миллисек, бцел эра);

  public override бцел дайЭру(Время время);

  public override бцел[] эры() ;

  private бцел дайГрегорианскийГод(бцел год, бцел эра) ;

  protected бцел текущаяЭра() ;
}



package struct ДиапазонЭр {


  package бцел эра;
  package дол тики;
  package бцел смещениеГода;
  package бцел годМинЭры;
  package бцел годМаксЭры;

  private static проц инициализуй() ;

  package static ДиапазонЭр[] дайДиапазоныЭр(бцел calID) ;

  package static бцел дайТекущуюЭру(бцел calID) ;

  private static ДиапазонЭр opCall(бцел эра, дол тики, бцел смещениеГода, бцел годМинЭры, бцел годПредыдущЭры);

}

