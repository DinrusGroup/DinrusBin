/**
Руссифицированная версия библиотеки D Helix.
Модуль содержит основные математические объекты, нацеленные для работы с 3D
графикой.

Это 2,3,4-D векторы, кватернион, матрицы 3x3 и 4x4. На случай специализации
под 3D-графику, имеются всегда некоторые средства и производные
из классической математики. Вот сводка по подобным средствам линейной алгебры helix:
$(UL
    $(LI В helix используется парадигма колончатого вектора (column-вектор). Умножение матрицы на
         вектор имеет смысл, а умножение вектора на матрицу не имеет.
         Этот подход придерживается правил, принятых в классической математике, и совпадает 
         с правилами OpenGL. Но противоречит парадигме Direct3D, где вектор является
         рядом (ряд). Так, в helix, для комбинирования последовательности переносов, заданных
		матрицами A, B, C в порядке A, затем B, затем C, нужно умножить их в обратном порядке
         (сзади к переду): M=C*B*A. )

    $(LI При работе с углами euler приняты следующие определения.
         Yaw представляет вращение вокруг Y, Pitch - вращение вокруг X, Roll - вращение вокруг Z.
         Вращения всегда применяются в порядке: Roll, затем Pitch, затем Yaw. )

    $(LI Под матрицы Helix используется column-major memory layout. Т.е. матрица
        $(MAT33
            $(MAT33_ROW a, b, c)
            $(MAT33_ROW d, e, f)
            $(MAT33_ROW g, h, i)
        )
        в памяти выглядит как: a, d, g, b, e, h, c, f, i. Порядок этот аналогичен порядку в
        OpenGL API, но притивоположен Direct3D API. Но, как уже упоминалось, Direct3D
        использует векторно-рядовую парадигму, противоречащую классической математике, 
		поэтому D3D требуется транспонированная матрица, в отличие от классики, чтобы
		получить необходимую трансформацию (перенос). В итоге не требуется транспонировать
		матрицу helix при передаче в API, даже в случае с Direct3D.
		Как правило, помнить о разметке памяти необязательно, просто ею пользуются как в
		классической математике, это имеет значение только в процедурах, оперирующих над
		указателями на данные и над плоскими представлениями массивов.
		В документации на такие методы есть напоминания. )
)

Авторы:
    Виктор Накоряков, nail-mail[at]mail.ru
    
Macros:
    MAT33     = <table style="border-left: дво 3px #666666; border-right: дво 3px #666666;
                 margin-left: 3em;">$0</table>
    MAT33_ROW = <tr><td>$1</td><td>$2</td><td>$3</td></tr>
*/
module math.Linalgebra;

//import stdrus;
import linalg.basic,
       linalg.config;

/** Определяет названия ортов, обычно применяемых в качестве индексов. */
enum Орт
{
    X, ///
    Y, /// описано
    Z, /// описано
    W  /// описано
}

/**
Шаблон-обмотчик, предоставляющий возможность использования
в реализуемых структурах и процедурах разных типов с
плавающей запятой.
*/
private template ЛинейнаяАлгебра(т_плав)
{
    private alias linalg.basic.равны          равны;
    
    alias .ЛинейнаяАлгебра!(плав).Вектор2     Вектор2п;
    alias .ЛинейнаяАлгебра!(плав).Вектор3     Вектор3п;
    alias .ЛинейнаяАлгебра!(плав).Вектор4     Вектор4п;
    alias .ЛинейнаяАлгебра!(плав).Кватернион  Кватернионп;
    alias .ЛинейнаяАлгебра!(плав).Матрица22    Матрица22п;
    alias .ЛинейнаяАлгебра!(плав).Матрица33    Матрица33п;
    alias .ЛинейнаяАлгебра!(плав).Матрица44    Матрица44п;
    
    alias .ЛинейнаяАлгебра!(дво).Вектор2    Вектор2д;
    alias .ЛинейнаяАлгебра!(дво).Вектор3    Вектор3д;
    alias .ЛинейнаяАлгебра!(дво).Вектор4    Вектор4д;
    alias .ЛинейнаяАлгебра!(дво).Кватернион Кватернионд;
    alias .ЛинейнаяАлгебра!(дво).Матрица22   Матрица22д;
    alias .ЛинейнаяАлгебра!(дво).Матрица33   Матрица33д;
    alias .ЛинейнаяАлгебра!(дво).Матрица44   Матрица44д;
    
    alias .ЛинейнаяАлгебра!(реал).Вектор2      Вектор2р;
    alias .ЛинейнаяАлгебра!(реал).Вектор3      Вектор3р;
    alias .ЛинейнаяАлгебра!(реал).Вектор4      Вектор4р;
    alias .ЛинейнаяАлгебра!(реал).Кватернион   Кватернионр;
    alias .ЛинейнаяАлгебра!(реал).Матрица22     Матрица22р;
    alias .ЛинейнаяАлгебра!(реал).Матрица33     Матрица33р;
    alias .ЛинейнаяАлгебра!(реал).Матрица44     Матрица44р;

    /************************************************************************************
    Двухмерный вектор.

    Формальное определение вектора, значение возможных операций и связанная с этим
    информация приведена на стр. $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Вектор2
    {
        enum { длина = 2u }

        align(1)
        {
            т_плав x; /// Компоненты вектора.
            т_плав y; /// описано
        }
        
        static Вектор2 нч = { т_плав.nan, т_плав.nan }; /// Вектор, у которого обе компоненты установлены в NaN.
        static Вектор2 ноль = { 0, 0 };                    /// Нулевой вектор 

        static Вектор2 едИкс = { 1, 0 };                   /// Unit вектор codirectional with corresponding ось.
        static Вектор2 едИгрек = { 0, 1 };                   /// описано
        
        
        /**
        Метод для построения вектора в стиле синтаксиса Си.

        Пример:
        ------------
        Вектор2 myVector = Вектор2(1, 2);
        ------------
        */
        static Вектор2 opCall(т_плав x, т_плав y);
        
        /** Метод для построения из массива. */
        static Вектор2 opCall(т_плав[2] p);
		
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав x, т_плав y);
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав[2] p);
        
        /** Возвращает: Нормаль (также известную как длину, величину) вектора. */
        реал нормаль();
    
        /**
        Возвращает: Квадрат нормали вектора.
        
        Поскольку данный метод не требует вычисления квадратного корня, лучше
        использовать его, а не нормаль(). Например, если нужно просто узнать,
        который из 2-х векторов длинее, то лучше всего сравнить квадраты их нормалей,
        а не сами нормали.
        */
        реал квадратНорм();
    
        /** Нормализует данный вектор. Возвращает: исходную длину. */
        реал нормализуй();
    
        /** Возвращает: Нормализованную копию данного вектора. */
        Вектор2 нормализованный();
    
        /**
        Возвращает: Является ли данный вектор единицей (unit).
        Параметры:
            отнпрец, абспрец = Параметры, передаваемые функции равны при сравнении
                               квадрата нормали и 1. Имеет то же значение, что и в функции равны.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /** Возвращает: Ось, для которой проекция данного вектора будет самой длинной. */
        Орт доминирующаяОсь();
		
        /** Возвращает: Являются ли все компоненты нормализованными числами. */
        бул нормален_ли();
    
        /** Возвращает: т_плав указатель на компоненту x данного вектора. Подобен методу _ptr для массивов. */
        т_плав* укз();
    
        /** Возвращает: Компоненту, соответствующую переданному индексу. */
        т_плав opIndex(т_мера орт);
    
        /** Присваивает компоненте новое значение (_value), соответствующее переданному индексу. */
        проц opIndexAssign(т_плав значение, т_мера орт);
		
        /**
        Стандартные операторы, значения которых понятны интуитивно. Аналогичны классической математике.
        
        Внимание: операторы деления не выполняют проверок значения k, поэтому в случае деления на
        0 результирующий вектор будет иметь компоненты с бесконечностью. Это можно проверить с помощью
	    метода нормален_ли().
        */
        бул opEquals(Вектор2 v);
		
        /** описано */
        Вектор2 opNeg();
    
        /** описано */
        Вектор2 opAdd(Вектор2 v);
    
        /** описано */
        проц opAddAssign(Вектор2 v);
		
        /** описано */
        Вектор2 opSub(Вектор2 v);
    
        /** описано */
        проц opSubAssign(Вектор2 v);
		
        /** описано */
        Вектор2 opMul(реал k);
		
        /** описано */
        проц opMulAssign(реал k);
    
        /** описано */
        Вектор2 opMul_r(реал k);
    
        /** описано */
        Вектор2 opDiv(реал k);
    
        /** описано */
        проц opDivAssign(реал k);
    
        /** Возвращает: Вектор, перепендикулярный к данному */
        Вектор2 перпендикуляр() ;

        /** Возвращает: Копию данного вектора с компонентами типа плав */
        Вектор2п вВектор2п();
        
        /** Возвращает: Копию данного вектора с компонентами типа дво */
        Вектор2д вВектор2д();
        
        /** Возвращает: Копию данного вектора с компонентами типа реал */
        Вектор2р вВектор2р();
		
        /**
        Процедуры, известные как swizzling.
        Возвращает:
            Новый вектор, построенный из данного. Значения его компонент
            соответствуют названию метода.
        */
        Вектор3 xy0() ;
        Вектор3 x0y() ;/// описано

        ткст вТкст() ;
    }
    
    public {
    /** Возвращает: Производную точки между переданными векторами. */
    реал точка(Вектор2 a, Вектор2 b);
	
    /** Возвращает: Внешнюю производную между переданными векторами. */
    Матрица22 внешн(Вектор2 a, Вектор2 b);
        
    /**
    Возвращает: Производную пересечения между заданными векторами. Результатом является скаляр c,
    при этом [a.x a.y 0], [b.x b.y 0], [0,0,c] образуют правую тройку (right-hand tripple).
    */
    реал кросс(Вектор2 a, Вектор2 b);


    alias РавенствоПоНорм!(Вектор2).равны равны; /// Представляет функцию приближенного равенства для Вектор2.
    alias Лининтерп!(Вектор2).лининтерп лининтерп;             /// Представляет функцию линейной интерполяции для Вектор2.
    } // end public
    
    /************************************************************************************
    Трёхмерный вектор.

    Формальное определение вектора, значение возможных операций и связанную с этим
    информацию можно найти на странице $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Вектор3
    {
        enum { длина = 3u }

        align(1)
        {
            т_плав x; /// Компоненты вектора.
            т_плав y; /// описано
            т_плав z; /// описано
        }
        
        static Вектор3 нч = { т_плав.nan, т_плав.nan, т_плав.nan }; /// Вектор, у которого все компоненты установлены в NaN.
        static Вектор3 ноль = {0,0,0};    // The ноль вектор
        static Вектор3 едИкс = { 1, 0, 0 };  /// Unit вектор, сонаправленный с определенной осью.
        static Вектор3 едИгрек = { 0, 1, 0 };  /// описано
        static Вектор3 едД = { 0, 0, 1 };  /// описано
        
        /**
        Метод для построения вектора в стиле Си.

        Примеры:
        ------------
        Вектор3 myVector = Вектор3(1, 2, 3);
        ------------
        */
        static Вектор3 opCall(т_плав x, т_плав y, т_плав z);
        
        /** Метод для построения из массива */
        static Вектор3 opCall(т_плав[3] p);
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав x, т_плав y, т_плав z);
    
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав[3] p);
    
        
        /** Возвращает: Norm (also known as длина, magnitude) of вектор. */
        реал нормаль();
    
        /**
        Возвращает: Квадрат нормали вектора.
        
        Поскольку этот метод не нуждается в вычислениии квадратного корня, то по возможности
        лучше использовать его вместо нормаль(). Например, если нужно просто узнать
        который из 2-х веторов длиннее - сравнить вместо их нормалей квадраты этих нормалей.
        */
        реал квадратНорм();
    
        /** Normalizes this вектор. Возвращает: the original длина */
        реал нормализуй();
    
        /** Возвращает: Normalized copy of this вектор. */
        Вектор3 нормализованный();
    
        /**
        Возвращает: Whether this вектор is unit.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while сравнение of
                               нормаль square and 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /** Возвращает: Axis for which projection of this вектор on it will be longest. */
        Орт доминирующаяОсь();
    
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз();
    
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт);
    
        /** Assigns new _value to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт);
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can check this with нормален_ли()
        method.
        */
        бул opEquals(Вектор3 v);
    
        /** описано */
        Вектор3 opNeg();
    
        /** описано */
        Вектор3 opAdd(Вектор3 v);
    
        /** описано */
        проц opAddAssign(Вектор3 v);
		
        /** описано */
        Вектор3 opSub(Вектор3 v);
    
        /** описано */
        проц opSubAssign(Вектор3 v);
        
    
        /** описано */
        Вектор3 opMul(реал k);
    
        /** описано */
        проц opMulAssign(реал k);
    
        /** описано */
        Вектор3 opMul_r(реал k);
    
        /** описано */
        Вектор3 opDiv(реал k);
    
        /** описано */
        проц opDivAssign(реал k);
        
        /** Возвращает: Copy of this вектор with плав type components */
        Вектор3п вВектор3п();
        
        /** Возвращает: Copy of this вектор with дво type components */
        Вектор3д вВектор3д();

        /** Возвращает: Copy of this вектор with реал type components */
        Вектор3р вВектор3р();

    
        /**
        Routines known as swizzling.
        Возвращает:
            New вектор constructed from this one and having component values
            that correspond to method name.
        */
        Вектор4 xyz0() ;
        Вектор4 xyz1() ; /// описано
        Вектор2 xy()  ;    /// описано
        Вектор2 xz()  ;    /// описано
        
        /**
        Routines known as swizzling.
        Assigns new values to some components corresponding to method name.
        */
        проц xy(Вектор2 v) ;
        проц xz(Вектор2 v) ;       /// описано

        ткст вТкст() ;
    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    реал точка(Вектор3 a, Вектор3 b);
    
    /** Возвращает: Outer product between passed vectors. */
    Матрица33 внешн(Вектор3 a, Вектор3 b);
        

    /**
    Возвращает: Cross product between passed vectors. Result is вектор c
    so that a, b, c forms right-hand tripple.
    */
    Вектор3 кросс(Вектор3 a, Вектор3 b);
    
    /**
    Возвращает: Является ли переданное основание ортогональным.
    Парамы:
        r, s, t =          Векторы, образующие основание.
        отнпрец, абспрец = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции равны.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthogonal_basis)
    */
    бул ортогонально_лиОснование(Вектор3 r, Вектор3 s, Вектор3 t, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
    /**
    Возвращает: Является ли переданное основание ортонормальным.
    Парамы:
        r, s, t =   Векторы, образующие основание.
        отнпрец, абспрец = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции равны.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthonormal_basis)
    */
    бул ортонормально_лиОснование(Вектор3 r, Вектор3 s, Вектор3 t, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
    alias РавенствоПоНорм!(Вектор3).равны равны; /// Introduces approximate equality function for Вектор3.
    alias Лининтерп!(Вектор3).лининтерп лининтерп;             /// Introduces linear interpolation function for Вектор3.
    
    } // end public
    
    /************************************************************************************
    4D вектор.

    For formal definition of вектор, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)),
    $(LINK http://en.wikipedia.org/wiki/Homogeneous_coordinates).
    *************************************************************************************/
    struct Вектор4
    {
        enum { длина = 4u }

        align(1)
        {
            т_плав x; /// Components of вектор.
            т_плав y; /// описано
            т_плав z; /// описано
            т_плав w; /// описано
        }
        
        /// Vector with all components установи to NaN.
        static Вектор4 нч = { т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };
        static Вектор4 ноль = { 0,0,0,0 };
        static Вектор4 едИкс = { 1, 0, 0, 0 }; /// Unit вектор codirectional with corresponding ось.
        static Вектор4 едИгрек = { 0, 1, 0, 0 }; /// описано
        static Вектор4 едД = { 0, 0, 1, 0 }; /// описано
        static Вектор4 едШ = { 0, 0, 0, 1 }; /// описано
        
        /**
        Methods to construct вектор in C-like syntax.

        Примеры:
        ------------
        Вектор4 myVector = Вектор4(1, 2, 3, 1);
        Вектор4 myVector = Вектор4(Вектор3(1, 2, 3), 0);
        Вектор4 myVector = Вектор4([1,2,3,1]);
        ------------
        */
        static Вектор4 opCall(т_плав x, т_плав y, т_плав z, т_плав w);
        
        /** описано */
        static Вектор4 opCall(Вектор3 xyz, т_плав w);
    
        /** описано */
        static Вектор4 opCall(т_плав[4] p);
    
        /** Sets values of components to passed values. */
        проц установи(т_плав x, т_плав y, т_плав z, т_плав w);
    
        /** описано */
        проц установи(Вектор3 xyz, т_плав w);
    
        /** описано */
        проц установи(т_плав[4] p);
        

        /**
        Возвращает: Norm (also known as длина, magnitude) of вектор.
        
        W-component is taken into account.
        */
        реал нормаль();
    
        /**
        Возвращает: Square of вектор's нормаль.

        W-component is taken into account.
        
        Since this method doesn't need calculation of square корень it is better
        to use it instead of нормаль() when you can. For example, if you want just
        to know which of 2 vectors is longer it's better to сравни their нормаль
        squares instead of their нормаль.
        */
        реал квадратНорм();
    
        /** Normalizes this вектор. Возвращает: the original длина. */
        реал нормализуй();
    
        /** Возвращает: Normalized copy of this вектор. */
        Вектор4 нормализованный();
    
        /**
        Возвращает: Whether this вектор is unit.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while сравнение of
                               нормаль square and 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /**
        Возвращает: Axis for which projection of this вектор on it will be longest.
        
        W-component is taken into account.
        */
        Орт доминирующаяОсь();
    
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз();
        
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт);
    
        /** Assigns new значение to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт);
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can check this with нормален_ли()
        method.
        */
        бул opEquals(Вектор4 v);
		
        /** описано */
        Вектор4 opNeg();
    
        /** описано */
        Вектор4 opAdd(Вектор4 v);
    
        /** описано */
        проц opAddAssign(Вектор4 v);
    
        /** описано */
        Вектор4 opSub(Вектор4 v);
    
        /** описано */
        проц opSubAssign(Вектор4 v);
		
        /** описано */
        Вектор4 opMul(реал k);
    
        /** описано */
        проц opMulAssign(реал k);
    
        /** описано */
        Вектор4 opMul_r(реал k);
		
        /** описано */
        Вектор4 opDiv(реал k);
    
        /** описано */
        проц opDivAssign(реал k);
		
        /** Возвращает: Copy of this вектор with плав type components */
        Вектор4п вВектор4п();
		
        /** Возвращает: Copy of this вектор with дво type components */
        Вектор4д вВектор4д();
        
        /** Возвращает: Copy of this вектор with реал type components */
        Вектор4р вВектор4р();
    
        /**
        Routine known as swizzling.
        Возвращает:
            Вектор3 that has the same x, y, z components values.
        */
        Вектор3 xyz() ; 
        
        /**
        Routine known as swizzling.
        Assigns new values to x, y, z components corresponding to argument's components values.
        */
        проц xyz(Вектор3 v)  ;      

        ткст вТкст() ;

    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    реал точка(Вектор4 a, Вектор4 b);
	
    /** Возвращает: Outer product between passed vectors. */
    Матрица44 внешн(Вектор4 a, Вектор4 b);

    alias РавенствоПоНорм!(Вектор4).равны равны; /// Introduces approximate equality function for Вектор4.
    alias Лининтерп!(Вектор4).лининтерп лининтерп;             /// Introduces linear interpolation function for Вектор4.
    
    } // end public
    
    /************************************************************************************
    _Quaternion.

    For formal definition of quaternion, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/_Quaternion),
    $(LINK http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation).
    *************************************************************************************/
    struct Кватернион
    {
        align(1)
        {
            union
            {
                struct
                {
                    т_плав x; /// Components of quaternion.
                    т_плав y; /// описано
                    т_плав z; /// описано
                }
                
                Вектор3 вектор; /// Vector part. Can be used instead of explicit members x, y and z.
            }
    
            union
            {
                т_плав w;      /// Скаляр part.
                т_плав скаляр; /// Another name for _scalar part.
            }
        }
        
        /// Identity quaternion.
        static Кватернион подобие;
        /// Кватернион with all components установи to NaN.
        static Кватернион нч = { x: т_плав.nan, y: т_плав.nan, z: т_плав.nan, w: т_плав.nan };
    
        /**
        Methods to construct quaternion in C-like syntax.

        Примеры:
        ------------
        Кватернион q1 = Кватернион(0, 0, 0, 1);
        Кватернион q2 = Кватернион(Вектор3(0, 0, 0), 1);
        Кватернион q3 = Кватернион(Матрица33.вращИгрек(ПИ / 6), 1);
        ------------
        */
        static Кватернион opCall(т_плав x, т_плав y, т_плав z, т_плав w);
    
        /** описано */
        static Кватернион opCall(Вектор3 вектор, т_плав скаляр);
        
        /** описано */
        static Кватернион opCall(Матрица33 мат);
        
        /** Sets values of components according to passed values. */
        проц установи(т_плав x, т_плав y, т_плав z, т_плав w);
		
        /** описано */
        проц установи(Вектор3 вектор, т_плав скаляр);
        
        /**
        Sets quaternion, so that, it will represent same вращение as in мат matrix argument.
        Парамы:
            мат = Matrix to extract вращение from. Should be pure вращение matrix.
        Throws:
            AssertError if мат is not pure вращение matrix and module was compiled with
            contract checkings are enabled.
        */
        // NOTE: refactor to use мат.ptr instead of [] operator if
        // perforance will be unsatisfactory.
        проц установи(Матрица33 мат);
        
        /** Construct quaternion that represents вращение around corresponding ось. */
        static Кватернион вращИкс(т_плав радианы);
    
        /** описано */
        static Кватернион вращИгрек(т_плав радианы);
    
        /** описано */
        static Кватернион вращЗэт(т_плав радианы);
    
        /**
        Constructs quaternion that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Кватернион вращение(т_плав yaw, т_плав pitch, т_плав roll);
		
        /**
        Constructs quaternion that represents _rotation around 'ось' _axis by 'радианы' angle.
        */
        static Кватернион вращение(Вектор3 ось, т_плав радианы);
		
        /** Возвращает: Norm (also known as длина, magnitude) of quaternion. */
        реал нормаль();
		
        /**
        Возвращает: Square of вектор's нормаль.
        
        Method doesn't need calculation of square корень.
        */
        реал квадратНорм();
		
        /** Normalizes this quaternion. Возвращает: the original длина. */
        реал нормализуй();
    
        /** Возвращает: Normalized copy of this quaternion. */
        Кватернион нормализованный();
    
        /**
        Возвращает: Whether this quaternion is unit.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while сравнение of
                               нормаль square and 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /** Возвращает: Conjugate quaternion. */
        Кватернион конъюнк();
    
        /** Invert this quaternion. */
        проц инвертируй();
    
        /** Возвращает: Inverse copy of this quaternion. */
        Кватернион инверсия();
        
        /**
        Возвращает: Extracted euler angle with the assumption that вращение is applied in order:
        _roll (Z ось), _pitch (X ось), _yaw (Y ось).
        */
        реал yaw();
    
        /** описано */
        реал pitch();
        
        /** описано */
        реал roll();
        
        /** Возвращает: Whether all components are нормализованный. */
        бул нормален_ли();
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз();
    
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт);
    
        /** Assigns new _value to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт);
    
        /**
        Standard operators that have meaning exactly the same as for Вектор4.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can check this with нормален_ли()
        method.
        */
        бул opEquals(Кватернион q);
    
        /** описано */
        Кватернион opNeg();
    
        /** описано */
        Кватернион opAdd(Кватернион q);
    
        /** описано */
        проц opAddAssign(Кватернион q);
    
        /** описано */
        Кватернион opSub(Кватернион q);
    
        /** описано */
        проц opSubAssign(Кватернион q);
    
        /** описано */
        Кватернион opMul(т_плав k);

        /** описано */
        Кватернион opMul_r(т_плав k);
    
        /** описано */
        Кватернион opDiv(т_плав k);
    
        /** описано */
        проц opDivAssign(т_плав k);
    
        /**
        Кватернион multiplication operators. Result of Q1*Q2 is quaternion that represents
        вращение which has meaning of application Q2's вращение and the Q1's вращение.
        */
        Кватернион opMul(Кватернион q);
		
        /** описано */
        проц opMulAssign(Кватернион q);
		
		  /** Возвращает: Copy of this quaternion with плав type components. */
        Кватернионп вКватернионп();
		
        /** Возвращает: Copy of this вектор with дво type components. */
        Кватернионд вКватернионд();
        
        /** Возвращает: Copy of this вектор with реал type components. */
        Кватернионр вКватернионр();

        ткст вТкст() ;
    }    
    
    alias РавенствоПоНорм!(Кватернион).равны равны;  /// Introduces approximate equality function for Кватернион.
    alias Лининтерп!(Кватернион).лининтерп лининтерп;              /// Introduces linear interpolation function for Кватернион.
    
    /**
    Возвращает:
        Product of spherical linear interpolation between q0 and q1 with parameter t.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Slerp).
    */
    Кватернион сфлининтерп(Кватернион q0, Кватернион q1, реал t);
    
    /************************************************************************************
    2x2 Matrix.

    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Матрица22
    {
        align(1) union
        {
            struct
            {
                т_плав m00, m10;
                т_плав m01, m11;
            }
    
            т_плав[2][2] m;
            Вектор2[2]    v;
            т_плав[4]    a;
        }
    
        /// Identity matrix.
        static Матрица22 подобие = {
            1, 0,
            0, 1 };
        /// Matrix with all elements установи to NaN.
        static Матрица22 нч = {
            т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, };
        /// Matrix with all elements установи to 0.
        static Матрица22 ноль = {
            0, 0,
            0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example.

        Примеры:
        ------------
        Матрица22 mat1 = Матрица22(1,2,3,4);
        static плав[9] a = [1,2,3,4];
        Матрица22 mat2 = Матрица22(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица22 opCall(т_плав m00, т_плав m01,
                               т_плав m10, т_плав m11);
        
        /** описано */
        static Матрица22 opCall(т_плав[4] a);
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        arguments.
        */
        static Матрица22 opCall(Вектор2 basisX, Вектор2 basisY);
    
        /** Sets elements to passed values. */
        проц установи(т_плав m00, т_плав m01,
                 т_плав m10, т_плав m11);
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[4] a);
        
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор2 basisX, Вектор2 basisY);
        
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();
        
        /**
        Возвращает: Whether this matrix is подобие.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix is ноль.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        бул ортогонален_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix represents pure вращение. I.e. hasn't масштабируй admixture.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул вращение_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Матрица22 масштабируй(т_плав x, т_плав y);
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица22 масштабируй(Вектор2 v);
    
        /** Construct matrix that represents вращение. */
        static Матрица22 вращение(т_плав радианы);
    
        /**
        Constructs matrix that represents _rotation same as in passed in complex number q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract checks enabled.
        */
/*
        static Матрица22 вращение(complex q)
        in { assert( q.единица_ли() ); }
        body
        {
            т_плав tx  = 2.f * q.x;
            т_плав ty  = 2.f * q.y;
            т_плав tz  = 2.f * q.z;
            т_плав twx = tx * q.w;
            т_плав twy = ty * q.w;
            т_плав twz = tz * q.w;
            т_плав txx = tx * q.x;
            т_плав txy = ty * q.x;
            т_плав txz = tz * q.x;
            т_плав tyy = ty * q.y;
            т_плав tyz = tz * q.y;
            т_плав tzz = tz * q.z;
            
            Матрица22 мат;
            with (мат)
            {
                m00 = 1.f - (tyy + tzz);    m01 = txy + twz;            m02 = txz - twy;        
                m10 = txy - twz;            m11 = 1.f - (txx + tzz);    m12 = tyz + twx;        
                m20 = txz + twy;            m21 = tyz - twx;            m22 = 1.f - (txx + tyy);
            }
            
            return мат;
        }
*/        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        Матрица22 инверсия();
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        проц инвертируй();
        
        /** Возвращает: Determinant */
        реал детерминанта();
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square корень from sum of all elements' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал нормаль();
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all elements' squares.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм();
        
        /** Transposes this matrix. */
        проц транспонируй();
		
        /** Возвращает: Transposed copy of this matrix. */
        Матрица22 транспонированный();
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into вращение 'Q' and масштабируй+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent масштабируй. This can
        have many applications, particulary you can use method for suppressing errors in pure
        вращение matrices after дол multiplication chain.
        
        Парамы:
            Q = Output matrix, will be orthogonal after decomposition.
                Argument shouldn't be null.
            S = Output matrix, will be symmetric non-негатив definite after
                decomposition. Argument shouldn't be null.

        Примеры:
        --------
        Матрица22 Q, S;
        Матрица22 rot = Матрица22.вращЗэт(ПИ / 7);
        Матрица22 масштабируй = Матрица22.масштабируй(-1, 2, 3);
        Матрица22 composition = rot * масштабируй;
        composition.polarDecomposition(Q, S);    
        assert( равны(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        проц polarDecomposition(out Матрица22 Q, out Матрица22 S);
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with нормален_ли()
        method.
        */
        Матрица22 opNeg();
    
        /** описано */
        Матрица22 opAdd(Матрица22 мат);
        /** описано */
        проц opAddAssign(Матрица22 мат);
        /** описано */
        Матрица22 opSub(Матрица22 мат);
        /** описано */
        проц opSubAssign(Матрица22 мат);
    
        /** описано */
        Матрица22 opMul(т_плав k);
    
        /** описано */
        проц opMulAssign(т_плав k);
    
        /** описано */
        Матрица22 opMul_r(т_плав k);
    
        /** описано */
        Матрица22 opDiv(т_плав k);
    
        /** описано */
        проц opDivAssign(т_плав k);
    
        /** описано */
        бул opEquals(Матрица22 мат);

        /** описано */
        Матрица22 opMul(Матрица22 мат);
    
        /** описано */
        проц opMulAssign(Матрица22 мат);
    
        /** описано */
        Вектор2 opMul(Вектор2 v);
    
        /** Возвращает: Element at ряд'th _row and столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб);
    
        /** Assigns значение f to element at ряд'th _row and столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб);
        
        /** Возвращает: Vector representing столб'th column. */
        Вектор2 opIndex(бцел столб);
		
        /** Replaces elements in столб'th column with v's values. */
        проц opIndexAssign(Вектор2 v, бцел столб);
    
        /**
        Возвращает: т_плав pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз();
        
        /** Возвращает: Copy of this matrix with плав type elements. */
        Матрица22п вМатрицу22п();
        
        /** Возвращает: Copy of this matrix with дво type elements. */
        Матрица22д вМатрицу22д();
        
        /** Возвращает: Copy of this matrix with реал type elements. */
        Матрица22р вМатрицу22р();

       ткст вТкст() ;
    }
    
    
    alias РавенствоПоНорм!(Матрица22).равны равны; /// Introduces approximate equality function for Матрица22.
    alias Лининтерп!(Матрица22).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица22.

    /************************************************************************************
    3x3 Matrix.

    For formal definition of quaternion, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/Matrix(mathematics)),
    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Матрица33
    {
        align(1) union
        {
            struct
            {
                т_плав m00, m10, m20;
                т_плав m01, m11, m21;
                т_плав m02, m12, m22;
            }
    
            т_плав[3][3] m;
            Вектор3[3]    v;
            т_плав[9]    a;
        }
    
        /// Identity matrix.
        static Матрица33 подобие = {
            1, 0, 0,
            0, 1, 0,
            0, 0, 1 };
        /// Matrix with all elements установи to NaN.
        static Матрица33 нч = {
            т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan };
        /// Matrix with all elements установи to 0.
        static Матрица33 ноль = {
            0, 0, 0,
            0, 0, 0,
            0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example.

        Примеры:
        ------------
        Матрица33 mat1 = Матрица33(1,2,3,4,5,6,7,8,9);
        static плав[9] a = [1,2,3,4,5,6,7,8,9];
        Матрица33 mat2 = Матрица33(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица33 opCall(т_плав m00, т_плав m01, т_плав m02,
                               т_плав m10, т_плав m11, т_плав m12,
                               т_плав m20, т_плав m21, т_плав m22);
        
        /** описано */
        static Матрица33 opCall(т_плав[9] a);
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        arguments.
        */
        static Матрица33 opCall(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ);
    
        /** Sets elements to passed values. */
        проц установи(т_плав m00, т_плав m01, т_плав m02,
                 т_плав m10, т_плав m11, т_плав m12,
                 т_плав m20, т_плав m21, т_плав m22);
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[9] a);
        
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ);
        
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();
        
        /**
        Возвращает: Whether this matrix is подобие.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix is ноль.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        бул ортогонален_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix represents pure вращение. I.e. hasn't масштабируй admixture.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул вращение_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Матрица33 масштабируй(т_плав x, т_плав y, т_плав z);
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица33 масштабируй(Вектор3 v);
		
        /** Construct matrix that represents вращение around corresponding ось. */
        static Матрица33 вращИкс(т_плав радианы);
    
        /** описано */
        static Матрица33 вращИгрек(т_плав радианы);
    
        /** описано */
        static Матрица33 вращЗэт(т_плав радианы);
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Матрица33 вращение(т_плав yaw, т_плав pitch, т_плав roll);
		
        /**
        Constructs matrix that represents _rotation specified by ось and angle.
        Method works with assumption that ось is unit вектор.        
        Throws:
            AssertError on non-unit ось call attempt if module was compiled with
            contract checks enabled.
        */
        static Матрица33 вращение(Вектор3 ось, т_плав радианы);
        
        /**
        Constructs matrix that represents _rotation same as in passed quaternion q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract checks enabled.
        */
        static Матрица33 вращение(Кватернион q);
        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        Матрица33 инверсия();
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        проц инвертируй();
		
        /** Возвращает: Determinant */
        реал детерминанта();
        
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square корень from sum of all elements' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал нормаль();
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all elements' squares.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм();
        
        /** Transposes this matrix. */
        проц транспонируй();
        
        /** Возвращает: Transposed copy of this matrix. */
        Матрица33 транспонированный();
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into вращение 'Q' and масштабируй+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent масштабируй. This can
        have many applications, particulary you can use method for suppressing errors in pure
        вращение matrices after дол multiplication chain.
        
        Парамы:
            Q = Output matrix, will be orthogonal after decomposition.
                Argument shouldn't be null.
            S = Output matrix, will be symmetric non-негатив definite after
                decomposition. Argument shouldn't be null.

        Примеры:
        --------
        Матрица33 Q, S;
        Матрица33 rot = Матрица33.вращЗэт(ПИ / 7);
        Матрица33 масштабируй = Матрица33.масштабируй(-1, 2, 3);
        Матрица33 composition = rot * масштабируй;
        composition.polarDecomposition(Q, S);    
        assert( равны(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        проц polarDecomposition(out Матрица33 Q, out Матрица33 S);
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with нормален_ли()
        method.
        */
        Матрица33 opNeg();
    
        /** описано */
        Матрица33 opAdd(Матрица33 мат);
    
        /** описано */
        проц opAddAssign(Матрица33 мат);
    
        /** описано */
        Матрица33 opSub(Матрица33 мат);
		
        /** описано */
        проц opSubAssign(Матрица33 мат);
    
        /** описано */
        Матрица33 opMul(т_плав k);
    
        /** описано */
        проц opMulAssign(т_плав k);
    
        /** описано */
        Матрица33 opMul_r(т_плав k);
    
        /** описано */
        Матрица33 opDiv(т_плав k);
    
        /** описано */
        проц opDivAssign(т_плав k);
		
        /** описано */
        бул opEquals(Матрица33 мат);
		
        /** описано */
        Матрица33 opMul(Матрица33 мат);
    
        /** описано */
        проц opMulAssign(Матрица33 мат);
		
        /** описано */
        Вектор3 opMul(Вектор3 v);
    
        /** Возвращает: Element at ряд'th _row and столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб);
    
        /** Assigns значение f to element at ряд'th _row and столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб);
		
        /** Возвращает: Vector representing столб'th column. */
        Вектор3 opIndex(бцел столб);
		
        /** Replaces elements in столб'th column with v's values. */
        проц opIndexAssign(Вектор3 v, бцел столб);
		
        /**
        Возвращает: т_плав pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз();
        
        /** Возвращает: Copy of this matrix with плав type elements. */
        Матрица33п вМатрицу33п();
        
        /** Возвращает: Copy of this matrix with дво type elements. */
        Матрица33д вМатрицу33д();
        
        /** Возвращает: Copy of this matrix with реал type elements. */
        Матрица33р вМатрицу33р();

        ткст вТкст();
    }
    
    
    alias РавенствоПоНорм!(Матрица33).равны равны; /// Introduces approximate equality function for Матрица33.
    alias Лининтерп!(Матрица33).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица33.
    
    /************************************************************************************
    4x4 Matrix.

    Helix matrices uses column-major memory layout.
    *************************************************************************************/
    struct Матрица44
    {
        align (1) union
        {
            struct
            {
                т_плав m00, m10, m20, m30;
                т_плав m01, m11, m21, m31;
                т_плав m02, m12, m22, m32;
                т_плав m03, m13, m23, m33;
            }
    
            т_плав[4][4] m;
            т_плав[16]   a;
            Вектор4[4]    v;
        }
    
        /// Identity matrix.
        static Матрица44 подобие = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1 };
        /// Matrix with all elements установи to NaN.
        static Матрица44 нч = {
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };
        /// Matrix with all elements установи to 0.
        static Матрица44 ноль = {
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example - it'll be passed.

        Примеры:
        ------------
        Матрица33 mat1 = Матрица33(
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 );
            
        static плав[16] a = [
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 ];
        Матрица33 mat2 = Матрица33(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица44 opCall(т_плав m00, т_плав m01, т_плав m02, т_плав m03,
                               т_плав m10, т_плав m11, т_плав m12, т_плав m13,
                               т_плав m20, т_плав m21, т_плав m22, т_плав m23,
                               т_плав m30, т_плав m31, т_плав m32, т_плав m33);
        
        /** описано */
        static Матрица44 opCall(т_плав[16] a);
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        arguments.
        */
        static Матрица44 opCall(Вектор4 basisX, Вектор4 basisY, Вектор4 basisZ,
                               Вектор4 basisW = Вектор4(0, 0, 0, 1));
        
        /**
        Method to construct matrix in C-like syntax. Constructs affine transform
        matrix based on passed вектор arguments.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        static Матрица44 opCall(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ,
                               Вектор3 перенос = Вектор3(0, 0, 0));
							   
        /** Sets elements to passed values. */
        проц установи(т_плав m00, т_плав m01, т_плав m02, т_плав m03,
                 т_плав m10, т_плав m11, т_плав m12, т_плав m13,
                 т_плав m20, т_плав m21, т_плав m22, т_плав m23,
                 т_плав m30, т_плав m31, т_плав m32, т_плав m33);
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[16] a);
		
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор4 basisX, Вектор4 basisY, Вектор4 basisZ,
                 Вектор4 basisW = Вектор4(0, 0, 0, 1));

        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();

        /**
        Возвращает: Whether this matrix is подобие.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Возвращает: Whether this matrix is ноль.
        Парамы:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                        Has the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);
        
        /**
        Resets this matrix to affine transform matrix based on passed
        вектор arguments.
        */
        проц установи(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ,
                 Вектор3 перенос = Вектор3(0, 0, 0));
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Матрица44 масштабируй(т_плав x, т_плав y, т_плав z);
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица44 масштабируй(Вектор3 v);
		
        /** Construct matrix that represents вращение around corresponding ось. */
        static Матрица44 вращИкс(т_плав радианы);
    
        /** описано */
        static Матрица44 вращИгрек(т_плав радианы);
    
        /** описано */
        static Матрица44 вращЗэт(т_плав радианы);
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Матрица44 вращение(т_плав yaw, т_плав pitch, т_плав roll);
    
        /**
        Constructs matrix that represents _rotation specified by ось and angle.
        Method works with assumption that ось is unit вектор.        
        Throws:
            AssertError on non-unit ось call attempt if module was compiled with
            contract checks enabled.
        */
        static Матрица44 вращение(Вектор3 ось, т_плав радианы);
        
        /**
        Constructs matrix that represents _rotation specified by quaternion.
        Method works with assumption that quaternion is unit.        
        Throws:
            AssertError on non-unit quaternion call attempt if module was compiled with
            contract checks enabled.
        */
        static Матрица44 вращение(Кватернион q);
    
        /** Constructs _translation matrix with offset values specified as arguments. */
        static Матрица44 перенос(т_плав x, т_плав y, т_плав z);
    
        /** Constructs _translation matrix with offset values specified as v's components. */
        static Матрица44 перенос(Вектор3 v);
        /**
        Constructs one-точка perspecive projection matrix.
        Парамы:
            fov =       Field of view in vertical plane in радианы.
            aspect =    Frustum's width / height coefficient. It shouldn't be 0.
            near =      Distance to near plane.
            near =      Distance to far plane.
        */
        static Матрица44 перспектива(т_плав fov, т_плав aspect, т_плав near, т_плав far);
        
        /**
        Constructs view matrix.
        Парамы:
            eye =       Viewer's eye position.
            target =    View target.
            up =        View up вектор.
        
        Arguments should not be complanar, elsewise matrix will contain infinity
        elements. You can check this with нормален_ли() method.
        */
        static Матрица44 видНа(Вектор3 eye, Вектор3 target, Вектор3 up);
        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        Матрица44 инверсия();
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will has
        infinity elements. You can check this with нормален_ли() method.
        */
        проц инвертируй();
        
        /** Возвращает: Determinant */
        реал детерминанта();
        
        /**
        Возвращает: Frobenius _norm of matrix.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).        
        */
        реал нормаль();
		
        /**
        Возвращает: Square of Frobenius нормаль of matrix.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм();
		
        /** 
        Возвращает: Whether this matrix represents affine transformation.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        бул isAffine();
		        
        /** Transposes this matrix. */
        проц транспонируй();
        
        /** Возвращает: Transposed copy of this matrix. */
        Матрица44 транспонированный();
        
        /** R/W property. Corner 3x3 minor. */
        Матрица33 углМинор();
        
        /** описано */
        проц углМинор(Матрица33 мат);
        
        /**
        Standard operators that have intuitive meaning, same as in classical math. Exception
        is multiplication with Vecto3 that doesn't make sense for classical math, in that case
        Вектор3 is implicitl expanded to Вектор4 with w=1.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with нормален_ли()
        method.
        */
        Матрица44 opNeg();
    
        /** описано */
        Матрица44 opAdd(Матрица44 мат);
    
        /** описано */
        проц opAddAssign(Матрица44 мат);
		
        /** описано */
        Матрица44 opSub(Матрица44 мат);
    
        /** описано */
        проц opSubAssign(Матрица44 мат);
    
        /** описано */
        Матрица44 opMul(т_плав k);
    
        /** описано */
        проц opMulAssign(т_плав k);
    
        /** описано */
        Матрица44 opMul_r(т_плав k);
    
        /** описано */
        Матрица44 opDiv(т_плав k);
    
        /** описано */
        проц opDivAssign(т_плав k);
    
        /** описано */
        бул opEquals(Матрица44 мат);

        /** описано */
        Матрица44 opMul(Матрица44 мат);
    
        /** описано */
        проц opMulAssign(Матрица44 мат);
    
        /** описано */
        Вектор3 opMul(Вектор3 v);
    
        /** описано */
        Вектор4 opMul(Вектор4 v);
    
        /** Возвращает: Element at ряд'th _row and столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб);
    
        /** Assigns значение f to element at ряд'th _row and столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб);
        
        /** Возвращает: Vector representing столб'th column. */
        Вектор4 opIndex(бцел столб);
    
        /** Replaces elements in столб'th column with v's values. */
        проц opIndexAssign(Вектор4 v, бцел столб);
    
        /**
        Возвращает: т_плав pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз();
		
        /** Возвращает: Copy of this matrix with плав type elements. */
        Матрица44п вМатрицу44п();
        
        /** Возвращает: Copy of this matrix with дво type elements. */
        Матрица44д вМатрицу44д();
        
        /** Возвращает: Copy of this matrix with реал type elements. */
        Матрица44р вМатрицу44р();

        ткст вТкст() ;

    }
    
    alias РавенствоПоНорм!(Матрица44).равны равны; /// Introduces approximate equality function for Матрица44.
    alias Лининтерп!(Матрица44).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица44.    
}

alias ЛинейнаяАлгебра!(плав).Вектор2             Вектор2п;
alias ЛинейнаяАлгебра!(плав).Вектор3             Вектор3п;
alias ЛинейнаяАлгебра!(плав).Вектор4             Вектор4п;
alias ЛинейнаяАлгебра!(плав).Кватернион          Кватернионп;
alias ЛинейнаяАлгебра!(плав).Матрица22            Матрица22п;
alias ЛинейнаяАлгебра!(плав).Матрица33            Матрица33п;
alias ЛинейнаяАлгебра!(плав).Матрица44            Матрица44п;
alias ЛинейнаяАлгебра!(плав).равны               равны;
alias ЛинейнаяАлгебра!(плав).точка                 точка;
public alias ЛинейнаяАлгебра!(плав).внешн        внешн;
alias ЛинейнаяАлгебра!(плав).кросс               кросс;
alias ЛинейнаяАлгебра!(плав).ортогонально_лиОснование   ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(плав).ортонормально_лиОснование  ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(плав).лининтерп                лининтерп;
alias ЛинейнаяАлгебра!(плав).сфлининтерп               сфлининтерп;

alias ЛинейнаяАлгебра!(дво).Вектор2            Вектор2д;
alias ЛинейнаяАлгебра!(дво).Вектор3            Вектор3д;
alias ЛинейнаяАлгебра!(дво).Вектор4            Вектор4д;
alias ЛинейнаяАлгебра!(дво).Кватернион         Кватернионд;
alias ЛинейнаяАлгебра!(дво).Матрица22           Матрица22д;
alias ЛинейнаяАлгебра!(дво).Матрица33           Матрица33д;
alias ЛинейнаяАлгебра!(дво).Матрица44           Матрица44д;
alias ЛинейнаяАлгебра!(дво).равны              равны;
alias ЛинейнаяАлгебра!(дво).точка                точка;
//alias ЛинейнаяАлгебра!(дво).внешн              внешн;
alias ЛинейнаяАлгебра!(дво).кросс              кросс;
alias ЛинейнаяАлгебра!(дво).ортогонально_лиОснование  ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(дво).ортонормально_лиОснование ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(дво).лининтерп               лининтерп;
alias ЛинейнаяАлгебра!(дво).сфлининтерп              сфлининтерп;

alias ЛинейнаяАлгебра!(реал).Вектор2              Вектор2р;
alias ЛинейнаяАлгебра!(реал).Вектор3              Вектор3р;
alias ЛинейнаяАлгебра!(реал).Вектор4              Вектор4р;
alias ЛинейнаяАлгебра!(реал).Кватернион           Кватернионр;
alias ЛинейнаяАлгебра!(реал).Матрица22             Матрица22р;
alias ЛинейнаяАлгебра!(реал).Матрица33             Матрица33р;
alias ЛинейнаяАлгебра!(реал).Матрица44             Матрица44р;
alias ЛинейнаяАлгебра!(реал).равны                равны;
alias ЛинейнаяАлгебра!(реал).точка                  точка;
//alias ЛинейнаяАлгебра!(реал).внешн                внешн;
alias ЛинейнаяАлгебра!(реал).кросс                кросс;
alias ЛинейнаяАлгебра!(реал).ортогонально_лиОснование    ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(реал).ортонормально_лиОснование   ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(реал).лининтерп                 лининтерп;
alias ЛинейнаяАлгебра!(реал).сфлининтерп                сфлининтерп;

alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор2     Вектор2;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор3     Вектор3;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор4     Вектор4;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Кватернион  Кватернион;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица22    Матрица22;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица33    Матрица33;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица44    Матрица44;

unittest
{
    assert( Вектор2(1, 2).нормализованный().единица_ли() );
    assert( Вектор3(1, 2, 3).нормализованный().единица_ли() );
    assert( Вектор4(1, 2, 3, 4).нормализованный().единица_ли() );

    assert( Вектор2(1, 2).доминирующаяОсь() == Орт.Y );
    assert( Вектор3(1, 2, 3).доминирующаяОсь() == Орт.Z );
    assert( Вектор4(1, 2, 3, 4).доминирующаяОсь() == Орт.W );

    Вектор4 v;
    v.установи(1, 2, 3, 4);
    assert( v.нормален_ли() );
    v /= 0;
    assert( !v.нормален_ли() );

    v.установи(1, 2, 3, 4);
    v[Орт.Y] = v[Орт.X];
    assert( v == Вектор4(1, 1, 3, 4) );

    Вектор4 t = Вектор4(100, 200, 300, 400);
    Вектор4 s;
    v.установи(1, 2, 3, 4);
    s = v;
    v += t;
    v -= t;
    v = (v + t) - t;
    v *= 100;
    v /= 100;
    v = (10 * v * 10) / 100;
    assert( равны(v, s) );

    assert( точка( кросс( Вектор3(1, 0, 2), Вектор3(4, 0, 5) ), Вектор3(3, 0, -2) )  == 0 );
}

unittest
{
    реал yaw = ПИ / 8;
    реал pitch = ПИ / 3;
    реал roll = ПИ / 4;
    
    Кватернион q = Кватернион( Матрица33.вращение(yaw, pitch, roll) );
    assert( равны(q.yaw, yaw) );
    assert( равны(q.pitch, pitch) );
    assert( равны(q.roll, roll) );
}

unittest
{
    Матрица33 mat1 = Матрица33(1,2,3,4,5,6,7,8,9);
    static плав[9] a = [1,2,3,4,5,6,7,8,9];
    Матрица33 mat2 = Матрица33(a);

    assert(mat1 == mat2.транспонированный);
}

/*
unittest
{
    Матрица33 a;
    
    a.m01 = 2;
    a.a[1] = 3;
    a.v[0].z = 4;
    assert(a[0, 1] == 2);
    assert(a[1, 0] == 3);
    assert(a[2, 0] == 4);
}
*/
unittest
{
    Матрица33 a = Матрица33.вращение( Вектор3(1, 2, 3).нормализованный, ПИ / 7.f );
    Матрица33 b = a.инверсия;
    b.инвертируй();
    assert( равны(a, b) );
    assert( равны(a.транспонированный.инверсия, a.инверсия.транспонированный) );
}

unittest
{
    Матрица33 Q, S;
    Матрица33 rot = Матрица33.вращЗэт(ПИ / 7);
    Матрица33 масштабируй = Матрица33.масштабируй(-1, 2, 3);
    Матрица33 composition = rot * масштабируй;
    composition.polarDecomposition(Q, S);    
    assert( равны(Q * S, composition) );
}
