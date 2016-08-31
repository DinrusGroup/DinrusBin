﻿module text.Arguments;

private import text.Util;
private import util.container.more.Stack;

version=dashdash;       // -- everything назначено в_ the пусто аргумент

class Аргументы
{
        public alias получи                opCall;         // арги("имя")
        public alias получи                opIndex;        // арги["имя"]

        private Стэк!(Аргумент)        стэк;          // арги with парамы
        private Аргумент[ткст]        арги;           // the установи of арги
        private Аргумент[ткст]        алиасы;        // установи of алиасы
        private сим                    eq;             // '=' or ':'
        private ткст                  sp,             // крат префикс
                                        lp;             // дол префикс
        private ткст[]                сообы = ошсооб;  // ошибка messages
        private const ткст[]          ошсооб =        // default ошибки
                [
                "аргумент '{0}' ожидает {2} параметр(s) но имеется {1}\n", 
                "аргумент '{0}' ожидает {3} параметр(s) но имеется {1}\n", 
                "аргумент '{0}' отсутствует\n", 
                "аргумент '{0}' требует '{4}'\n", 
                "аргумент '{0}' конфликтует с '{4}'\n", 
                "неожиданный аргумент '{0}'\n", 
                "аргумент '{0}' ожидает один из {5}\n", 
                "параметр не подходит для аргумента '{0}': {4}\n", 
                ];

        this (ткст sp="-", ткст lp="--", сим eq='=');
        final бул разбор (ткст ввод, бул sloppy=нет);
        final бул разбор (ткст[] ввод, бул sloppy=нет);
        final Аргументы очисть ();
        final Аргумент получи (сим имя);
        final Аргумент получи (ткст имя);
        final цел opApply (цел delegate(ref Аргумент) дг);
        final ткст ошибки (ткст delegate(ткст буф, ткст фмт, ...) дг);
        final Аргументы ошибки (ткст[] ошибки);
        final Аргументы помощь (проц delegate(ткст арг, ткст помощь) дг);
        private бул аргумент (ткст s, ткст p, бул sloppy, бул флаг);
        private Аргумент активируй (ткст элем, бул sloppy, бул флаг=нет);  
		
        class Аргумент
        {       
                /***************************************************************
                
                        Ошибка определители:
                        ---
                        Нет:           ok
                        ParamLo:        too few парамы for an аргумент
                        ParamHi:        too many парамы for an аргумент
                        Required:       missing аргумент is требуется 
                        Requires:       depends on a missing аргумент
                        Конфликт:       conflicting аргумент is present
                        Extra:          неожиданный аргумент (see sloppy)
                        Option:         parameter does not match опции
                        ---

                ***************************************************************/
        
                enum {Нет, ParamLo, ParamHi, Required, Requires, Конфликт, Extra, Option, Invalid};

                alias проц   delegate() Вызывало;
                alias ткст delegate(ткст значение) Инспектор;

                public цел              min,            /// minimum парамы
                                        max,            /// maximum парамы
                                        ошибка;          /// ошибка condition
                public  бул            установи;            /// арг is present
                private бул            req,            // арг is требуется
                                        склей,            // арг is smushable
                                        эксп,            // implicit парамы
                                        краш;           // краш the разбор
                private ткст          имя,           // арг имя
                                        текст,           // помощь текст
                                        bogus;          // имя of conflict
                private ткст[]        значения,         // назначено значения
                                        опции,        // validation опции
                                        дефолты;       // configured дефолты
                private Вызывало         вызывало;        // invocation обрвызов
                private Инспектор       инспектор;      // inspection обрвызов
                private Аргумент[]      dependees,      // who we require
                                        conflictees;    // who we conflict with
                
        
                this (ткст имя);
                override ткст вТкст();
                final ткст[] назначено ();
                final Аргумент есть_алиас (сим имя);
                final Аргумент требуется ();
                final Аргумент требует (Аргумент арг);
                final Аргумент требует (ткст другой);
                final Аргумент требует (сим другой);
                final Аргумент конфликтует (Аргумент арг);
                final Аргумент конфликтует (ткст другой);
                final Аргумент конфликтует (сим другой);
                final Аргумент парамы ();
                final Аргумент парамы (цел счёт);
                final Аргумент парамы (цел min, цел max);
                final Аргумент установиДефолты (ткст значения);
                final Аргумент вяжи (Инспектор инспектор);
                final Аргумент вяжи (Вызывало вызывало);
                final Аргумент smush (бул да=да);
                final Аргумент явный ();
                final Аргумент титул (ткст имя);
                final Аргумент помощь (ткст текст);
                final Аргумент остановись ();
                final Аргумент ограничь (ткст[] опции ...);
                private Аргумент активируй (бул неожиданный=нет);
                private проц добавь (ткст значение, бул явный=нет);
                private цел действителен ();
        }
}
