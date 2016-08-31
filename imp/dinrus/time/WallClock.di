module time.WallClock;

public  import  time.Time, time.Clock, sys.Common;

struct Куранты
{

                static Время сейчас ();
                static ИнтервалВремени зона ();
                static ДатаВремя вДату ();
                static ДатаВремя вДату (Время utc);
                static Время изДаты (ref ДатаВремя дата);               
				static Время вМестное (Время utc);
				static Время toUtc (Время wall);
}
