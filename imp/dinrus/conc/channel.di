module conc.channel;
import conc.puttable;
import conc.takable;


interface Канал(T) : Помещаемое!(T), Извлекаемое!(T) 
{
  public проц помести(T элт);
  public бул предложи(T элт, дол мсек);
  public T возьми();
  public T запроси(дол мсек);
  public T подбери();
}


class оберни(T)
{
	public:
					T значение;

		this() { }
		this(T t) { значение = t; }
}
