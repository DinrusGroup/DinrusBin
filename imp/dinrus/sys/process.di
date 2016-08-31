/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module sys.Process;

private import io.model;
private import io.Console;
private import sys.Common;
private import sys.Pipe;
private import exception;


enum ПРедирект
{
    Нет = 0,
    Вывод = 1,
    Ошибка = 2,
    Ввод = 4,
    Все = Вывод | Ошибка | Ввод,
    ОшНаВывод = 0x10,
    ВыводНаОш = 0x20,
}



class Процесс
{

    public struct Результат
    {

        public enum
        {
            Выход,
            Сигнал,
            Стоп,
            Продолжение,
            Ошибка
        }

        public цел резон;
        public цел статус;

        public ткст вТкст();
    }

    static const бцел ДефРазмБуфераСтдвхо    = 512;
    static const бцел ДефРазмБуфераСтдвых   = 8192;
    static const бцел ДефРазмБуфераСтдош   = 512;
    static const ПРедирект ДефПеренаправФлаги  = ПРедирект.Все;

    public this(ткст[] арги ...);
    public this(бул копирСред, ткст[] арги ...);
    public this(ткст команда, ткст[ткст] среда);
    public this(ткст[] арги, ткст[ткст] среда);
    public бул выполняется_ли();
    public цел пид();
    public ткст имяПрограммы();
    public ткст имяПрограммы(ткст имя);
    public Процесс установиИмяПрограммы(ткст имя);
    public ткст[] арги();
    public ткст[] арги(ткст имяпроги, ткст[] арги ...);
    public Процесс установиАрги(ткст имяпроги, ткст[] арги ...);
    public бул копирСред();
    public бул копирСред(бул b);
    public Процесс установиКопирСред(бул b);
    public ткст[ткст] среда();
    public ткст[ткст] среда(ткст[ткст] среда);
    public Процесс установиСреду(ткст[ткст] среда);
    public ткст вТкст();
    public ткст рабДир();
    public ткст рабДир(ткст пап);
    public Процесс установиРабДир(ткст пап);
    public ПРедирект перенаправ();
    public ПРедирект перенаправ(ПРедирект флаги);
    public Процесс установиПеренаправ(ПРедирект флаги);
    public бул гип();
    public бул гип(бул значение);
    public Процесс установиГип(бул значение);
    public Трубопровод стдвхо();
    public Трубопровод стдвыв();
    public Трубопровод стдош();
    deprecated public проц выполни(ткст arg1, ткст[] арги ...);
    deprecated public проц выполни(ткст команда, ткст[ткст] среда);
    deprecated public проц выполни(ткст[] арги, ткст[ткст] среда);
    public Процесс выполни();
    public Результат жди();
    public проц затуши();
    protected static ткст[] разделиАрги(ref ткст команда, ткст delims = " \t\r\n");
    protected проц удалиПайпы();
    public проц закрой();

    version (Windows)
    {

        protected static ткст toNullEndedBuffer(ткст[ткст] ист);
    }
    else version (Posix)
    {

        protected static сим*[] toNullEndedArray(ткст[] ист);
        protected static сим*[] toNullEndedArray(ткст[ткст] ист);
        protected static цел execvpe(ткст имяф, сим*[] argv, сим*[] envp);
    }
}


class ИсклСозданияПроцесса: ProcessException
{
    public this(ткст команда, ткст файл, бцел строка);
    public this(ткст команда, ткст сообщение, ткст файл, бцел строка);
}


class ИсклВетвленияПроцесса: ProcessException
{
    public this(цел пид, ткст файл, бцел строка);
}

class ИсклТушенияПроцесса: ProcessException
{
    public this(цел пид, ткст файл, бцел строка);
}

class ИсклОжиданияПроцесса: ProcessException
{
    public this(цел пид, ткст файл, бцел строка);
}


private ткст форматируй (ткст сооб, цел значение);
