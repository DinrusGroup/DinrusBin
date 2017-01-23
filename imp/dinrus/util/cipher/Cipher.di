/**
 * Copyright: Copyright (C) Thomas Dixon 2008. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.Cipher;

private import exception : ИсклНелегальногоАргумента;

//alias ткст ткст;

/** База symmetric cipher class */
abstract class Шифр
{
    interface Параметры {}

    static const бул ENCRYPT = да,
                      DECRYPT = нет;
                      
    protected бул _initialized,
                   _encrypt;
    
    /**
     * Процесс a блок of plaintext данные из_ the ввод Массив
     * и place it in the вывод Массив.
     *
     * Параметры:
     *     input_  = Массив containing ввод данные.
     *     output_  = Массив в_ hold the вывод данные.
     *
     * Возвращает: The amount of encrypted данные processed.
     */
    abstract бцел обнови(проц[] input_, проц[] output_);
    
    /** Возвращает: The имя of the algorithm of this cipher. */
    abstract ткст имя();
    
    /** Reset cipher в_ its состояние immediately subsequent the последний init. */
    abstract проц сбрось();
   
    /**
     * throw an InvalidАргумент исключение
     * 
     * Параметры:
     *     сооб = сообщение в_ associate with the исключение
     */
    static проц не_годится (ткст сооб);
     
    /** Возвращает: Whether or not the cipher имеется been инициализован. */
    final бул инициализован();
}



/** Interface for a стандарт блок cipher. */
abstract class ШифрБлок : Шифр
{
    /** Возвращает: The блок размер in байты that this cipher will operate on. */
    abstract бцел размерБлока();
}


/** Interface for a стандарт поток cipher. */
abstract class ШифрПоток : Шифр
{   
    /**
     * Процесс one байт of ввод.
     *
     * Параметры:
     *     ввод = Byte в_ XOR with keyПоток.
     *
     * Возвращает: One байт of ввод XORed with the keyПоток.
     */
    abstract ббайт returnByte(ббайт ввод);
}

 
 /** База паддинг class for implementing блок паддинг schemes. */
 abstract class ПаддингБлокаШифра
 {
    /** Возвращает: The имя of the паддинг scheme implemented. */
    abstract ткст имя();

    /**
    * Generate паддинг в_ a specific length.
    *
    * Параметры:
    *     длин = Length of паддинг в_ generate
    *
    * Возвращает: The паддинг байты в_ be добавьed.
    */ 
    abstract ббайт[] pad(бцел длин);

    /**
    * Return the число of pad байты in the блок.
    *
    * Параметры:
    *     input_ = Pдобавьed блок of which в_ счёт the pad байты.
    *
    * Возвращает: The число of pad байты in the блок.
    *
    * Throws: dcrypt.crypto.ошибки.InvalКСЕРдобавимError if 
    *         pad length cannot be discerned.
    */
    abstract бцел unpad(проц[] input_);
 }



/** Объект representing и wrapping a symmetric ключ in байты. */
class СимметричныйКлюч : Шифр.Параметры
{
    private ббайт[] _key;
    
    /**
     * Параметры:
     *     ключ = Key в_ be held.
     */
    this(проц[] ключ=пусто);
    
    /** Play nice with D2's опрea of const. */
    version (D_Version2)
    {
        this (ткст ключ);
    }
    
    /** Возвращает: Key in ubytes held by this объект. */
    ббайт[] ключ();
    
    /**
     * Набор the ключ held by this объект.
     *
     * Параметры:
     *     newKey = Нов ключ в_ be held.
     * Возвращает: The new ключ.
     */
    ббайт[] ключ(проц[] newKey);
}


/** Wrap cipher параметры и IV. */
class ParametersWithIV : Шифр.Параметры
{
    private ббайт[] _iv;
    private Шифр.Параметры _params;
    
    /**
     * Параметры:
     *     парамы = Параметры в_ wrap.
     *     iv     = IV в_ be held.
     */
    this (Шифр.Параметры парамы=пусто, проц[] iv=пусто);
    
    /** Возвращает: The IV. */
    ббайт[] iv();
    
    /**
     * Набор the IV held by this объект.
     *
     * Параметры:
     *     newIV = The new IV for this parameter объект.
     * Возвращает: The new IV.
     */
    ббайт[] iv(проц[] newIV);
    
    /** Возвращает: The параметры for this объект. */
    Шифр.Параметры параметры();
    
    /**
     * Набор the параметры held by this объект.
     *
     * Параметры:
     *     newParams = The new параметры в_ be held.
     * Возвращает: The new параметры.
     */
    Шифр.Параметры параметры(Шифр.Параметры newParams);
}


struct Побитно
{
    static бцел вращайВлево(бцел x, бцел y);
    
    static бцел вращайВправо(бцел x, бцел y);
    
    static бдол вращайВлево(бдол x, бцел y);
    
    static бдол вращайВправо(бдол x, бцел y);
}


/** Converts between integral типы и unsigned байт массивы */
struct БайтКонвертер
{
    private static ткст hexits = "0123456789abcdef";
    private static ткст base32digits = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    
    /** Conversions between little эндиан integrals и байты */
    struct ЛитлЭндиан
    {
        /**
         * Converts the supplied Массив в_ integral тип T
         * 
         * Параметры:
         *     x_ = The supplied Массив of байты (ubytes, байты, симвы, whatever)
         * 
         * Возвращает:
         *     A integral of тип T создан with the supplied байты placed
         *     in the specified байт order.
         */
        static T в_(T)(проц[] x_)
        {
            ббайт[] x = cast(ббайт[])x_;
            
            T результат = ((cast(T)x[0])       |
                       ((cast(T)x[1]) << 8));
                       
            static if (T.sizeof >= цел.sizeof)
            {
                результат |= ((cast(T)x[2]) << 16) |
                          ((cast(T)x[3]) << 24);
            }
            
            static if (T.sizeof >= дол.sizeof)
            {
                результат |= ((cast(T)x[4]) << 32) |
                          ((cast(T)x[5]) << 40) |
                          ((cast(T)x[6]) << 48) |
                          ((cast(T)x[7]) << 56);
            }
            
            return результат;
        }
        
        /**
         * Converts the supplied integral в_ an Массив of unsigned байты.
         * 
         * Параметры:
         *     ввод = Integral в_ преобразуй в_ байты
         * 
         * Возвращает:
         *     Integral ввод of тип T разбей преобр_в its respective байты
         *     with the байты placed in the specified байт order.
         */
        static ббайт[] из_(T)(T ввод)
        {
            ббайт[] вывод = new ббайт[T.sizeof];
            
            вывод[0] = cast(ббайт)(ввод);
            вывод[1] = cast(ббайт)(ввод >> 8);
            
            static if (T.sizeof >= цел.sizeof)
            {
                вывод[2] = cast(ббайт)(ввод >> 16);
                вывод[3] = cast(ббайт)(ввод >> 24);
            }
            
            static if (T.sizeof >= дол.sizeof)
            {
                вывод[4] = cast(ббайт)(ввод >> 32);
                вывод[5] = cast(ббайт)(ввод >> 40);
                вывод[6] = cast(ббайт)(ввод >> 48);
                вывод[7] = cast(ббайт)(ввод >> 56);
            }
            
            return вывод;
        }
    }
    
    /** Conversions between big эндиан integrals и байты */
    struct БигЭндиан
    {
        
        static T в_(T)(проц[] x_)
        {
            ббайт[] x = cast(ббайт[])x_;
            
            static if (is(T == бкрат) || is(T == крат))
            {
                return cast(T) (((x[0] & 0xff) << 8) |
                                 (x[1] & 0xff));
            }
            else static if (is(T == бцел) || is(T == цел))
            {
                return cast(T) (((x[0] & 0xff) << 24) |
                                ((x[1] & 0xff) << 16) |
                                ((x[2] & 0xff) << 8)  |
                                 (x[3] & 0xff));
            }
            else static if (is(T == бдол) || is(T == дол))
            {
                return cast(T) ((cast(T)(x[0] & 0xff) << 56) |
                                (cast(T)(x[1] & 0xff) << 48) |
                                (cast(T)(x[2] & 0xff) << 40) |
                                (cast(T)(x[3] & 0xff) << 32) |
                                ((x[4] & 0xff) << 24) |
                                ((x[5] & 0xff) << 16) |
                                ((x[6] & 0xff) << 8)  |
                                 (x[7] & 0xff));
            }
        }
        
        static ббайт[] из_(T)(T ввод)
        {
            ббайт[] вывод = new ббайт[T.sizeof];
            
            static if (T.sizeof == дол.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 56);
                вывод[1] = cast(ббайт)(ввод >> 48);
                вывод[2] = cast(ббайт)(ввод >> 40);
                вывод[3] = cast(ббайт)(ввод >> 32);
                вывод[4] = cast(ббайт)(ввод >> 24);
                вывод[5] = cast(ббайт)(ввод >> 16);
                вывод[6] = cast(ббайт)(ввод >> 8);
                вывод[7] = cast(ббайт)(ввод);
            }
            else static if (T.sizeof == цел.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 24);
                вывод[1] = cast(ббайт)(ввод >> 16);
                вывод[2] = cast(ббайт)(ввод >> 8);
                вывод[3] = cast(ббайт)(ввод);
            }
            else static if (T.sizeof == крат.sizeof)
            {
                вывод[0] = cast(ббайт)(ввод >> 8);
                вывод[1] = cast(ббайт)(ввод);
            }
            
            return вывод;
        }
    }

    static ткст hexEncode(проц[] input_);
    
    static ткст base32Encode(проц[] input_, бул doPad=да);

    static ббайт[] hexDecode(ткст ввод);
    
    static ббайт[] base32Decode(ткст ввод);

    private static ткст stringToLower(ткст ввод);

    private static ткст stringToUpper(ткст ввод);
}
