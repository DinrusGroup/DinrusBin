/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris, snoyberg

******************************************************************************/

module time.chrono.Hebrew;

private import exception;

private import time.chrono.Calendar;



/**
 * $(ANCHOR _Hebrew)
 * Represents the Hebrew calendar.
 */
public class Hebrew : Календарь {

  private const бцел[14][7] MonthDays = [
    // месяц                                                    // год тип
    [ 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0  ], 
    [ 0, 30, 29, 29, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 1
    [ 0, 30, 29, 30, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 2
    [ 0, 30, 30, 30, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 3
    [ 0, 30, 29, 29, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ],  // 4
    [ 0, 30, 29, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ],  // 5
    [ 0, 30, 30, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ]   // 6
  ];

  private const бцел YearOfOneAD = 3760;
  private const бцел DaysToOneAD = cast(цел)(YearOfOneAD * 365.2735);

  private const бцел PartsPerHour = 1080;
  private const бцел PartsPerDay = 24 * PartsPerHour;
  private const бцел DaysPerMonth = 29;
  private const бцел DaysPerMonthFraction = 12 * PartsPerHour + 793;
  private const бцел PartsPerMonth = DaysPerMonth * PartsPerDay + DaysPerMonthFraction;
  private const бцел FirstNewMoon = 11 * PartsPerHour + 204;

  private бцел minYear_ = YearOfOneAD + 1583;
  private бцел maxYear_ = YearOfOneAD + 2240;

  /**
   * Represents the current эра.
   */
  public const бцел HEBREW_ERA = 1;

  /**
   * Overrопрden. Returns a Время значение установи в_ the specified дата and время in the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   месяц = An целое representing the _month.
   *   день = An целое representing the _day.
   *   час = An целое representing the _hour.
   *   минута = An целое representing the _minute.
   *   сукунда = An целое representing the _second.
   *   миллисек = An целое representing the _millisecond.
   *   эра = An целое representing the _era.
   * Возвращает: A Время установи в_ the specified дата and время.
   */
  public /*override*/ Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел сукунда, бцел миллисек, бцел эра) ;

  /**
   * Overrопрden. Returns the день of the week in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: A ДеньНедели значение representing the день of the week of время.
   */
  public override ДеньНедели дайДеньНедели(Время время) ;

  /**
   * Overrопрden. Returns the день of the месяц in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the месяц of время.
   */
  public override бцел дайДеньМесяца(Время время);

  /**
   * Overrопрden. Returns the день of the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the год of время.
   */
  public override бцел дайДеньГода(Время время) ;

  /**
   * Overrопрden. Returns the месяц in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the месяц in время.
   */
  public override бцел дайМесяц(Время время) ;

  /**
   * Overrопрden. Returns the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the год in время.
   */
  public override бцел дайГод(Время время) ;

  /**
   * Overrопрden. Returns the эра in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the ear in время.
   */
  public override бцел дайЭру(Время время) ;

  /**
   * Overrопрden. Returns the число of дни in the specified _year and _month of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   месяц = An целое representing the _month.
   *   эра = An целое representing the _era.
   * Возвращает: The число of дни in the specified _year and _month of the specified _era.
   */
  public override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра);

  /**
   * Overrопрden. Returns the число of дни in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of дни in the specified _year in the specified _era.
   */
  public override бцел дайДниГода(бцел год, бцел эра) ;

  /**
   * Overrопрden. Returns the число of месяцы in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of месяцы in the specified _year in the specified _era.
   */
  public override бцел дайМесяцыГода(бцел год, бцел эра);

  /**
   * Overrопрden. Indicates whether the specified _year in the specified _era is a leap _year.
   * Параметры: год = An целое representing the _year.
   * Параметры: эра = An целое representing the _era.
   * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
   */
  public override бул високосен_ли(бцел год, бцел эра) ;

  /**
   * $(I Property.) Overrопрden. Retrieves the список of эры in the current calendar.
   * Возвращает: An целое Массив representing the эры in the current calendar.
   */
  public override бцел[] эры();

  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the current calendar.
   * Возвращает: An целое representing the определитель of the current calendar.
   */
  public override бцел опр() ;

  private проц checkYear(бцел год, бцел эра);

  private бцел getYearType(бцел год) ;

  private бцел getStartOfYear(бцел год);

  private Время getGregorianTime(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел сукунда, бцел миллисек) ;

}

