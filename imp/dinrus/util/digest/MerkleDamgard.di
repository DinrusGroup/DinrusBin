/*******************************************************************************
        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует a генерный Merkle-Damgard хэш function

*******************************************************************************/

module util.digest.MerkleDamgard;

public  import stdrus;

public  import util.digest.Digest;

/*******************************************************************************

        Extending MerkleDamgard в_ создай a custom хэш function требует 
        the implementation of a число of abstract methods. These include:
        ---
        public бцел размерДайджеста();
        protected проц сбрось();
        protected проц создайДайджест(ббайт[] буф);
        protected бцел размерБлока();
        protected бцел добавьРазмер();
        protected проц padMessage(ббайт[] данные);
        protected проц трансформируй(ббайт[] данные);
        ---

        In добавьition there exist two further abstract methods; these methods
        have пустой default implementations since in some cases they are not 
        требуется$(CLN)
        ---
        protected abstract проц padLength(ббайт[] данные, бдол length);
        protected abstract проц extend();
        ---

        The метод padLength() is требуется в_ implement the SHA series of
        Хэш functions и also the Tiger algorithm. Метод extend() is 
        требуется only в_ implement the MD2 дайджест.

        The basic sequence of internal события is as follows:
        $(UL
        $(LI трансформируй(), 0 or ещё times)
        $(LI padMessage())
        $(LI padLength())
        $(LI трансформируй())
        $(LI extend())
        $(LI создайДайджест())
        $(LI сбрось())
        )
 
*******************************************************************************/

package class MerkleDamgard : Дайджест
{
        private бцел    байты;
        private ббайт[] буфер;

        /***********************************************************************

                Constructs the дайджест

                Параметры:
                буф = a буфер with enough пространство в_ hold the дайджест

                Remarks:
                Constructs the дайджест.

        ***********************************************************************/

        protected abstract проц создайДайджест(ббайт[] буф);

        /***********************************************************************

                Дайджест блок размер

                Возвращает:
                the блок размер

                Remarks:
                Specifies the размер (in байты) of the блок of данные в_ пароль в_
                each вызов в_ трансформируй().

        ***********************************************************************/

        protected abstract бцел размерБлока();

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Remarks:
                Specifies the размер (in байты) of the паддинг which
                uses the length of the данные which имеется been fed в_ the
                algorithm, this паддинг is carried out by the
                padLength метод.

        ***********************************************************************/

        protected abstract бцел добавьРазмер();

        /***********************************************************************

                Pads the дайджест данные

                Параметры:
                данные = a срез of the дайджест буфер в_ заполни with паддинг

                Remarks:
                Fills the passed буфер срез with the appropriate
                паддинг for the final вызов в_ трансформируй(). This
                паддинг will заполни the сообщение данные буфер up в_
                размерБлока()-добавьРазмер().

        ***********************************************************************/

        protected abstract проц padMessage(ббайт[] данные);

        /***********************************************************************

                Performs the length паддинг

                Параметры:
                данные   = the срез of the дайджест буфер в_ заполни with паддинг
                length = the length of the данные which имеется been processed

                Remarks:
                Fills the passed буфер срез with добавьРазмер() байты of паддинг
                based on the length in байты of the ввод данные which имеется been
                processed.

        ***********************************************************************/

        protected проц padLength(ббайт[] данные, бдол length) ;

        /***********************************************************************

                Performs the дайджест on a блок of данные

                Параметры:
                данные = the блок of данные в_ дайджест

                Remarks:
                The actual дайджест algorithm is carried out by this метод on
                the passed блок of данные. This метод is called for every
                размерБлока() байты of ввод данные и once ещё with the остаток
                данные псеп_в_конце в_ размерБлока().

        ***********************************************************************/

        protected abstract проц трансформируй(ббайт[] данные);

        /***********************************************************************

                Final processing of дайджест.

                Remarks:
                This метод is called after the final трансформируй just приор в_
                the creation of the final дайджест. The MD2 algorithm требует
                an добавьitional step at this stage. Future digests may or may not
                require this метод.

        ***********************************************************************/

        protected проц extend() ;

        /***********************************************************************

                Construct a дайджест

                Remarks:
                Constructs the internal буфер for use by the дайджест, the буфер
                размер (in байты) is defined by the abstract метод размерБлока().

        ***********************************************************************/

        this();

        /***********************************************************************

                Initialize the дайджест

                Remarks:
                Returns the дайджест состояние в_ its начальное значение

        ***********************************************************************/

        protected проц сбрось();

        /***********************************************************************

                Дайджест добавьitional данные

                Параметры:
                ввод = the данные в_ дайджест

                Remarks:
                Continues the дайджест operation on the добавьitional данные.

        ***********************************************************************/

        MerkleDamgard обнови (проц[] ввод);

        /***********************************************************************

                Complete the дайджест

                Возвращает:
                the completed дайджест

                Remarks:
                Concludes the algorithm producing the final дайджест.

        ***********************************************************************/

        ббайт[] двоичныйДайджест (ббайт[] буф = пусто);

        /***********************************************************************

                Converts 8 bit в_ 32 bit Литл Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the приёмник Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бцел[] in Литл Endian байт order.

        ***********************************************************************/

        static protected final проц littleEndian32(ббайт[] ввод, бцел[] вывод);

        /***********************************************************************

                Converts 8 bit в_ 32 bit Биг Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the приёмник Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бцел[] in Биг Endian байт order.

        ***********************************************************************/

        static protected final проц bigEndian32(ббайт[] ввод, бцел[] вывод);

        /***********************************************************************

                Converts 8 bit в_ 64 bit Литл Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the приёмник Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бдол[] in Литл Endian байт order.

        ***********************************************************************/

        static protected final проц littleEndian64(ббайт[] ввод, бдол[] вывод);

        /***********************************************************************

                Converts 8 bit в_ 64 bit Биг Endian

                Параметры: ввод  = the источник Массив
                вывод = the приёмник Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бдол[] in Биг Endian байт order.

        ***********************************************************************/

        static protected final проц bigEndian64(ббайт[] ввод, бдол[] вывод);

        /***********************************************************************

                Rotate left by n

                Параметры:
                x = the значение в_ rotate
                n = the amount в_ rotate by

                Remarks:
                Rotates a 32 bit значение by the specified amount.

        ***********************************************************************/

        static protected final бцел вращайВлево(бцел x, бцел n);
}


