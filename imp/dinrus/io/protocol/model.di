
module io.protocol.model;

private import io.model;

abstract class ИПротокол
{
        enum Тип
        {
                Void = 0,
                Utf8, 
                Bool,
                Byte,
                UByte,
                Utf16,
                Short,
                UShort,
                Utf32,
                Int,
                UInt,
                Float,
                Long,
                ULong,
                Double,
                Real,
                Obj,
                Pointer,
        }
        
        alias проц   delegate (ук ист, бцел байты, Тип тип) Писатель;
        alias проц   delegate (ук ист, бцел байты, Тип тип) ПисательМассива;

        alias проц[] delegate (ук приёмн, бцел байты, Тип тип) Читатель;
        alias проц[] delegate (Читатель читатель, бцел байты, Тип тип) Разместитель;

        alias проц[] delegate (ук приёмн, бцел байты, Тип тип, Разместитель) ЧитательМассива;
        

        abstract ИБуфер буфер ();
        abstract проц[] читай (ук приёмн, бцел байты, Тип тип);
        abstract проц пиши (ук ист, бцел байты, Тип тип);
        abstract проц[] читайМассив (ук приёмн, бцел байты, Тип тип, Разместитель размести);
        abstract проц пишиМассив (ук ист, бцел байты, Тип тип);
}

abstract class ИРазместитель
{

        abstract проц сбрось ();
        abstract ИПротокол протокол ();
        abstract проц[] размести (ИПротокол.Читатель, бцел байты, ИПротокол.Тип);
}

abstract class ИЧитатель   
{
        alias получи opCall;

        abstract ИЧитатель получи (inout бул x);
        abstract ИЧитатель получи (inout байт x);            
        abstract ИЧитатель получи (inout ббайт x);           
        abstract ИЧитатель получи (inout крат x);           
        abstract ИЧитатель получи (inout бкрат x);          
        abstract ИЧитатель получи (inout цел x);             
        abstract ИЧитатель получи (inout бцел x);            
        abstract ИЧитатель получи (inout дол x);            
        abstract ИЧитатель получи (inout бдол x);           
        abstract ИЧитатель получи (inout плав x);           
        abstract ИЧитатель получи (inout дво x);          
        abstract ИЧитатель получи (inout реал x);            
        abstract ИЧитатель получи (inout сим x);            
        abstract ИЧитатель получи (inout шим x);           
        abstract ИЧитатель получи (inout дим x);           

        abstract ИЧитатель получи (inout бул[] x);          
        abstract ИЧитатель получи (inout байт[] x);          
        abstract ИЧитатель получи (inout крат[] x);         
        abstract ИЧитатель получи (inout цел[] x);           
        abstract ИЧитатель получи (inout дол[] x);          
        abstract ИЧитатель получи (inout ббайт[] x);         
        abstract ИЧитатель получи (inout бкрат[] x);        
        abstract ИЧитатель получи (inout бцел[] x);          
        abstract ИЧитатель получи (inout бдол[] x);         
        abstract ИЧитатель получи (inout плав[] x);         
        abstract ИЧитатель получи (inout дво[] x);        
        abstract ИЧитатель получи (inout реал[] x);          
        abstract ИЧитатель получи (inout ткст x);          
        abstract ИЧитатель получи (inout шим[] x);         
        abstract ИЧитатель получи (inout дим[] x);         

         abstract ИЧитатель получи (ИЧитаемое);

        alias проц delegate (ИЧитатель) Клозура;

        abstract ИЧитатель получи (Клозура);
        abstract ИБуфер буфер ();
        abstract ИРазместитель разместитель (); 
}


interface ИЧитаемое
{
        проц читай (ИЧитатель ввод);
}

abstract class ИПисатель  
{
        alias помести opCall;

        abstract ИПисатель помести (бул x);
        abstract ИПисатель помести (ббайт x);         
        abstract ИПисатель помести (байт x);          
        abstract ИПисатель помести (бкрат x);        
        abstract ИПисатель помести (крат x);         
        abstract ИПисатель помести (бцел x);          
        abstract ИПисатель помести (цел x);           
        abstract ИПисатель помести (бдол x);         
        abstract ИПисатель помести (дол x);          
        abstract ИПисатель помести (плав x);         
        abstract ИПисатель помести (дво x);        
        abstract ИПисатель помести (реал x);          
        abstract ИПисатель помести (сим x);          
        abstract ИПисатель помести (шим x);         
        abstract ИПисатель помести (дим x);         

        abstract ИПисатель помести (бул[] x);
        abstract ИПисатель помести (байт[] x);        
        abstract ИПисатель помести (крат[] x);       
        abstract ИПисатель помести (цел[] x);         
        abstract ИПисатель помести (дол[] x);        
        abstract ИПисатель помести (ббайт[] x);       
        abstract ИПисатель помести (бкрат[] x);      
        abstract ИПисатель помести (бцел[] x);        
        abstract ИПисатель помести (бдол[] x);       
        abstract ИПисатель помести (плав[] x);       
        abstract ИПисатель помести (дво[] x);      
        abstract ИПисатель помести (реал[] x);        
        abstract ИПисатель помести (ткст x);        
        abstract ИПисатель помести (шим[] x);       
        abstract ИПисатель помести (дим[] x);       

        abstract ИПисатель помести (ИЗаписываемое);
        alias проц delegate (ИПисатель) Клозура;
        abstract ИПисатель помести (Клозура);
        abstract ИПисатель нс ();
        abstract ИПисатель слей ();
        abstract ИПисатель помести ();   
        abstract ИБуфер буфер ();
}


interface ИЗаписываемое
{
        abstract проц пиши (ИПисатель ввод);
}


