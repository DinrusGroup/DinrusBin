module sys.geometry;

public import sys.DStructs;

struct Прямоугольник
{	
	public union
	{
		struct
		{
			бцел лево = 0;
			бцел верх = 0;
			бцел право = 0;
			бцел низ = 0;
		}

		ПРЯМ прям;
	}

	public static Прямоугольник opCall(Точка pt, Размер sz);
	public static Прямоугольник opCall(бцел l, бцел t, бцел w, бцел h);
	public бул opEquals(Прямоугольник r);
	public цел x();
	public проц x(цел newX);
	public цел y();
	public проц y(цел newY);
	public цел ширина();
	public проц ширина(цел w);
	public цел высота();
	public проц высота(цел h);
	public Точка положение();
	public проц положение(Точка pt);
	public Размер размер();
	public проц размер(Размер sz);
	public бул пустой();
	public static Прямоугольник изПРЯМа(ПРЯМ* pWinRect);
}

struct Точка
{	
	public union
	{
		struct
		{
			бцел x = 0;
			бцел y = 0;
		}

		ТОЧКА точка;
	}

	public бул opEquals(Точка pt);
	public static Точка opCall(цел x, цел y);
}

struct Размер
{	
	public union
	{
		struct
		{
			бцел ширина = 0;
			бцел высота = 0;
		}

		РАЗМЕР размер;
	}

	public бул opEquals(Размер sz);
	public static Размер opCall(цел w, цел h);
}

public const Прямоугольник НульПрям = Прямоугольник.init;
public const Точка НульТчк = Точка.init;
public const Размер НульРазм = Размер.init;