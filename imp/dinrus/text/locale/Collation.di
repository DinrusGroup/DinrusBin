module text.locale.Collation;

private import text.locale.Core;

  /**
  Сравнивает строки, используя указанные регистр и правила сравнения для культуры.
 */
public class СтрокоСопоставитель {

  private static СтрокоСопоставитель invariant_;
  private static СтрокоСопоставитель invariantIgnoreCase_;
  private Культура culture_;
  private бул ignoreCase_;

  static this() {
    invariant_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, нет);
    invariantIgnoreCase_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, да);
  }

  public this(Культура культура, бул ignoreCase) ;
  
  public цел сравни(ткст strA, ткст strB);
  
  public бул равно(ткст strA, ткст strB) ;
  
  public static СтрокоСопоставитель текущаяКультура();
  
  public static СтрокоСопоставитель текущаяКультураИгнорРег() ;
  
  public static СтрокоСопоставитель инвариантнаяКультура() ;
  
  public static СтрокоСопоставитель инвариантнаяКультураИгнорРег() ;
  
}

/**
  $(I Delegate.) Represents the метод that will укз the ткст сравнение.
  Remarks:
    The delegate имеется the сигнатура $(I цел delegate(ткст, ткст)).
 */
alias цел delegate(ткст, ткст) СравнениеСтрок;

/**
  Сортирует строки в соответствии с правилами означенной культуры.
 */
public class СтрокоСортировщик {

  private static СтрокоСортировщик invariant_;
  private static СтрокоСортировщик invariantIgnoreCase_;
  private Культура culture_;
  private СравнениеСтрок comparison_;

  static this() {
    invariant_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультура);
    invariantIgnoreCase_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультураИгнорРег);
  }


  public this(СтрокоСопоставитель comparer = пусто);
  
  public this(СравнениеСтрок сравнение);
  
  public проц сортируй(ref ткст[] массив);
  
  public проц сортируй(ref ткст[] массив, цел индекс, цел счёт) ;
  
  public static СтрокоСортировщик текущаяКультура() ;
  
  public static СтрокоСортировщик текущаяКультураИгнорРег() ;
  
  public static СтрокоСортировщик инвариантнаяКультура() ;
  
  public static СтрокоСортировщик инвариантнаяКультураИгнорРег() ;

}