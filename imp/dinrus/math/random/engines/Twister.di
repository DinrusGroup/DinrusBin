/*******************************************************************************

        copyright:      Copyright (C) 1997--2004, Makoto Matsumoto,
                        Takuji Nishimura, и Eric Landry; все rights reserved
        

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2008: Initial release

        author:         KeYeR (D interface) keyer@team0xf.com
                        fawzi (преобразованый в_ движок)
      
*******************************************************************************/

module math.random.engines.Twister;
private import Целое = text.convert.Integer;

/*******************************************************************************

        Wrapper for the Mersenne twister.
        
        The Mersenne twister is a pseudorandom число generator linked в_
        CR developed in 1997 by Makoto Matsumoto и Takuji Nishimura that
        is based on a matrix linear recurrence over a finite binary field
        F2. It provопрes for fast generation of very high quality pseudorandom
        numbers, having been designed specifically в_ rectify many of the 
        flaws найдено in older algorithms.
        
        Mersenne Твистер имеется the following desirable свойства:
        ---
        1. It was designed в_ have a период of 2^19937 - 1 (the creators
           of the algorithm proved this property).
           
        2. It имеется a very high order of dimensional equопрistribution.
           This implies that there is negligible serial correlation between
           successive значения in the вывод sequence.
           
        3. It проходки numerous tests for statistical randomness, включая
           the stringent Diehard tests.
           
        4. It is fast.
        ---

*******************************************************************************/

struct Твистер
{
    private enum : бцел {
        // Period параметры
        N          = 624,
        M          = 397,
        MATRIX_A   = 0x9908b0df,        // constant вектор a 
        UPPER_MASK = 0x80000000,        //  most significant w-r биты 
        LOWER_MASK = 0x7fffffff,        // least significant r биты
    }
    const цел canCheckpoint=да;
    const цел можноСеять=да;

    private бцел[N] mt;                     // the Массив for the состояние вектор  
    private бцел mti=mt.length+1;           // mti==mt.length+1 means mt[] is not инициализован 
    
    /// returns a random бцел
    бцел следщ ();
    /// returns a random байт
    ббайт следщБ();
    /// returns a random дол
    бдол следщД();
    
    /// initializes the generator with a бцел as сей
    проц сей (бцел s);
	
    /// добавьs entropy в_ the generator
    проц добавьЭнтропию(бцел delegate() r);
    /// seeds the generator
    проц сей(бцел delegate() r);
    /// записывает текущ статус в ткст
    ткст вТкст();
    /// считывает текущ статус в ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера изТкст(ткст s);
    
}

