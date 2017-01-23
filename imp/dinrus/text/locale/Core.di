module text.locale.Core;

private import  text.locale.Data;

private import  time.Time;

private import  time.chrono.Hijri,
                time.chrono.Korean,
                time.chrono.Taiwan,
                time.chrono.Hebrew,
                time.chrono.Calendar,
                time.chrono.Japanese,
                time.chrono.Gregorian,
                time.chrono.ThaiBuddhist;
 
/**
 * Определяет типы культур, к-е м.б. получены от Культура.дайКультуры.
 */
public enum ТипыКультур {
  Нейтральный = 1,      
  Особый = 2,            
  Все = Нейтральный | Особый
}


public interface ИСлужбаФормата 
{

  Объект дайФормат(ИнфОТипе тип);

}

public class Культура : ИСлужбаФормата 
{
/*
  private const цел LCID_INVARIANT = 0x007F;

  private static Культура[ткст] namedCultures;
  private static Культура[цел] idCultures;
  private static Культура[ткст] ietfCultures;

  private static Культура currentCulture_;
  private static Культура userDefaultCulture_; // The пользователь's default культура (GetUserDefaultLCID).
  private static Культура invariantCulture_; // The invariant культура is associated with the English language.
  private Календарь calendar_;
  private Культура parent_;
  private ДанныеОКультуре* cultureData_;
  private бул isReadOnly_;
  private ФорматЧисла numberFormat_;
  private ФорматДатыВремени dateTimeFormat_;

  static this() {
    invariantCulture_ = new Культура(LCID_INVARIANT);
    invariantCulture_.isReadOnly_ = да;

    userDefaultCulture_ = new Культура(nativeMethods.дайКультуруПользователя());
    if (userDefaultCulture_ is пусто)
      // Fallback
      userDefaultCulture_ = инвариантнаяКультура;
    else
      userDefaultCulture_.isReadOnly_ = да;
  }

  static ~this() {
    namedCultures = пусто;
    idCultures = пусто;
    ietfCultures = пусто;
  }
*/
  public this(ткст названиеКультуры) ;
  public this(цел идКультуры) ;
  public Объект дайФормат(ИнфОТипе тип);

version (Clone)
{
  public Объект клонируй() ;
}


  public static Культура дайКультуру(цел идКультуры) ;
  public static Культура дайКультуру(ткст названиеКультуры) ;
  public static Культура дайКультуруПоТегуЯзыкаИЕТФ(ткст имя) ;
 // private static Культура дайКультуруВнутр(цел идКультуры, ткст cname) ;
  public static Культура[] дайКультуры(ТипыКультур типы) ;
  public override ткст вТкст() ;
  public override цел opEquals(Объект об) ;
  public static Культура текущ() ;
  public static проц текущ(Культура значение);
  public static Культура инвариантнаяКультура() ;
  public цел опр() ;
  public ткст имя() ;
  public ткст англИмя() ;
  public ткст исконноеИмя() ;
  public ткст имяЯзыкаИз2Букв() ;
  public ткст имяЯзыкаИз3Букв() ;
  public final ткст тэгЯзыкаИЕТФ() ;
  public Культура предок() ;
  public бул нейтрален_ли() ;
  public final бул толькоЧтен_ли() ;
  public Календарь календарь();
  public Календарь[] опциональныеКалендари();
  public ФорматЧисла форматЧисла() ;
  public проц форматЧисла(ФорматЧисла значение) ;
  public ФорматДатыВремени форматДатыВремени();
  public проц форматДатыВремени(ФорматДатыВремени значение) ;

//  private static проц проверьНейтрал(Культура культура) ;
//  private проц проверьТолькоЧтен();
//  private static Календарь дайЭкземплярКалендаря(цел типКалендаря, бул readOnly=нет);

}


public class Регион 
{
/*
  private ДанныеОКультуре* cultureData_;
  private static Регион currentRegion_;
  private ткст name_;
*/
  public this(цел идКультуры) ;
  public this(ткст имя) ;
 // package this(ДанныеОКультуре* данныеОКультуре) ;
  public static Регион текущ() ;
  public цел геоИД() ;
  public ткст имя();
  public ткст англИмя();
  public ткст исконноеИмя() ;
  public ткст имяРегионаИз2Букв() ;
  public ткст имяРегионаИз3Букв();
  public ткст символВалюты() ;
  public ткст символВалютыИСО() ;
  public ткст англИмяВалюты() ;
  public ткст исконноеИмяВалюты();
  public бул метрическ_ли() ;
  public override ткст вТкст() ;

}


public class ФорматЧисла : ИСлужбаФормата
 {
/*
  package бул isReadOnly_;
  private static ФорматЧисла invariantFormat_;

  private цел numberDecimalDigits_;
  private цел numberNegativePattern_;
  private цел currencyDecimalDigits_;
  private цел currencyNegativePattern_;
  private цел currencyPositivePattern_;
  private цел[] numberGroupSizes_;
  private цел[] currencyGroupSizes_;
  private ткст numberGroupSeparator_;
  private ткст numberDecimalSeparator_;
  private ткст currencyGroupSeparator_;
  private ткст currencyDecimalSeparator_;
  private ткст currencySymbol_;
  private ткст negativeSign_;
  private ткст positiveSign_;
  private ткст nanSymbol_;
  private ткст negativeInfinitySymbol_;
  private ткст positiveInfinitySymbol_;
  private ткст[] nativeDigits_;

*/
  public this() ;
 // package this(ДанныеОКультуре* данныеОКультуре);
  public Объект дайФормат(ИнфОТипе тип);

version (Clone)
{
  public Объект клонируй();
}

  public static ФорматЧисла дайЭкземпляр(ИСлужбаФормата службаФормата);
  public static ФорматЧисла текущ() ;
  public static ФорматЧисла инвариантныйФормат();
  public final бул толькоЧтен_ли();
  public final цел члоДесятичнЦифр() ;
  public final проц члоДесятичнЦифр(цел значение);
  public final цел члоОтрицатОбразцов();
  public final проц члоОтрицатОбразцов(цел значение);
  public final цел валютнДесятичнЦифры();
  public final проц валютнДесятичнЦифры(цел значение);
  public final цел валютнОтрицатОбразец() ;
  public final проц валютнОтрицатОбразец(цел значение) ;
  public final цел валютнПоложитОбразец() ;
  public final проц валютнПоложитОбразец(цел значение);
  public final цел[] размерыЧисловыхГрупп() ;
  public final проц размерыЧисловыхГрупп(цел[] значение);
  public final цел[] размерыВалютныхГрупп();
  public final проц размерыВалютныхГрупп(цел[] значение) ;
  public final ткст разделительЧисловыхГрупп() ;
  public final проц разделительЧисловыхГрупп(ткст значение) ;
  public final ткст разделительЧисловыхДесятков() ;
  public final проц разделительЧисловыхДесятков(ткст значение);
  public final ткст разделительГруппыВалют();
  public final проц разделительГруппыВалют(ткст значение) ;
  public final ткст десятичнРазделительВалюты() ;
  public final проц десятичнРазделительВалюты(ткст значение) ;
  public final ткст символВалюты() ;
  public final проц символВалюты(ткст значение) ;
  public final ткст отрицатЗнак() ;
  public final проц отрицатЗнак(ткст значение);
  public final ткст положитЗнак() ;
  public final проц положитЗнак(ткст значение);
  public final ткст символНЧ() ;
  public final проц символНЧ(ткст значение) ;
  public final ткст отрицатСимволБесконечности() ;
  public final проц отрицатСимволБесконечности(ткст значение) ;
  public final ткст положитСимволБесконечности() ;
  public final проц положитСимволБесконечности(ткст значение);
  public final ткст[] исконныеЦифры() ;
  public final проц исконныеЦифры(ткст[] значение) ;

  //private проц проверьТолькоЧтен() ;

}

public class ФорматДатыВремени : ИСлужбаФормата
 {
/***
  private const ткст rfc1123Pattern_ = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  private const ткст sortableDateTimePattern_ = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  private const ткст universalSortableDateTimePattern_ = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'";
  private const ткст allStandardFormats = [ 'd', 'D', 'f', 'F', 'g', 'G', 'm', 'M', 'r', 'R', 's', 't', 'T', 'u', 'U', 'y', 'Y' ];


  package бул isReadOnly_;
  private static ФорматДатыВремени invariantFormat_;
  private ДанныеОКультуре* cultureData_;

  private Календарь calendar_;
  private цел[] optionalКалендарьs_;
  private цел firstДеньНедели_ = -1;
  private цел КалендарьWeekRule_ = -1;
  private ткст dateSeparator_;
  private ткст timeSeparator_;
  private ткст amDesignator_;
  private ткст pmDesignator_;
  private ткст shortDatePattern_;
  private ткст shortTimePattern_;
  private ткст longDatePattern_;
  private ткст longTimePattern_;
  private ткст monthDayPattern_;
  private ткст yearMonthPattern_;
  private ткст[] abbreviatedDayNames_;
  private ткст[] dayNames_;
  private ткст[] abbreviatedMonthNames_;
  private ткст[] monthNames_;

  private ткст ПолнаяДатаTimePattern_;
  private ткст generalShortTimePattern_;
  private ткст generalLongTimePattern_;

  private ткст[] shortTimePatterns_;
  private ткст[] shortDatePatterns_;
  private ткст[] longTimePatterns_;
  private ткст[] longDatePatterns_;
  private ткст[] yearMonthPatterns_;

   */
  package this() ;
  package this(ДанныеОКультуре* данныеОКультуре, Календарь Календарь) ;
  public Объект дайФормат(ИнфОТипе тип) ;

version(Clone)
{
  public Объект клонируй() ;
}

//  package ткст[] shortTimePatterns() ;
 // package ткст[] shortDatePatterns() ;
 // package ткст[] longTimePatterns() ;
 // package ткст[] longDatePatterns() ;
//  package ткст[] yearMonthPatterns() ;
  public final ткст[] дайВсеОбразцыДатыВремени();
  public final ткст[] дайВсеОбразцыДатыВремени(сим форматируй);
  public final ткст дайСокращённоеИмяДня(Календарь.ДеньНедели деньНедели) ;
  public final ткст дайИмяДня(Календарь.ДеньНедели деньНедели) ;
  public final ткст дайСокращённоеИмяМесяца(цел месяц) ;
  public final ткст дайИмяМесяца(цел месяц) ;
  public static ФорматДатыВремени дайЭкземпляр(ИСлужбаФормата службаФормата) ;
  public static ФорматДатыВремени текущ() ;
  public static ФорматДатыВремени инвариантныйФормат();
  public final бул толькоЧтен_ли() ;
  public final Календарь календарь() ;
  public final проц календарь(Календарь значение);
  public final Календарь.ДеньНедели первыйДеньНед() ;
  public final проц первыйДеньНед(Календарь.ДеньНедели значение) ;
  public final Календарь.ПравилоНедели правилоНеделиКалендаря() ;
  public final проц правилоНеделиКалендаря(Календарь.ПравилоНедели значение) ;
  public final ткст исконноеНазваниеКалендаря() ;
  public final ткст разделительДаты() ;
  public final проц разделительДаты(ткст значение);
  public final ткст разделительВремени() ;
  public final проц разделительВремени(ткст значение) ;
  public final ткст определительДоПолудня() ;
  public final проц определительДоПолудня(ткст значение) ;
  public final ткст определительПослеПолудня() ;
  public final проц определительПослеПолудня(ткст значение);
  public final ткст краткийОбразецДаты() ;
  public final проц краткийОбразецДаты(ткст значение) ;
  public final ткст краткийОбразецВремени() ;
  public final проц краткийОбразецВремени(ткст значение) ;
  public final ткст длинныйОбразецДаты() ;
  public final проц длинныйОбразецДаты(ткст значение) ;
  public final ткст длинныйОбразецВремени() ;
  public final проц длинныйОбразецВремени(ткст значение) ;
  public final ткст образецДняМесяца();
  public final проц образецДняМесяца(ткст значение) ;
  public final ткст образецМесяцаГода();
  public final проц образецМесяцаГода(ткст значение) ;
  public final ткст[] сокращённыеИменаДней() ;
  public final проц сокращённыеИменаДней(ткст[] значение) ;
  public final ткст[] именаДней() ;
  public final проц именаДней(ткст[] значение);
  public final ткст[] сокращённыеИменаМесяцев() ;
  public final проц сокращённыеИменаМесяцев(ткст[] значение);
  public final ткст[] именаМесяцев() ;
  public final проц именаМесяцев(ткст[] значение) ;
  public final ткст полныйОбразецДатыВремени();
  public final проц полныйОбразецДатыВремени(ткст значение) ;
  public final ткст образецРФС1123() ;
  public final ткст сортируемыйОбразецДатыВремени() ;
  public final ткст универсальныйСортируемыйОбразецДатыВремени() ;

  package ткст общКраткийОбразецВремени();
  package ткст общДлинныйОбразецВремени();
 // private проц проверьТолькоЧтен();
 // private проц инициализуй();
 // private цел[] опциональныеКалендари() ;

}


