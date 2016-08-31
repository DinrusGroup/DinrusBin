
module conc.linkednode;

class ЛинкованныйУзел(T) { 
	public:
		T значение;
		.ЛинкованныйУзел!(T) следщ = пусто;

		this() {}

		this(T x)
		{
			значение = x;
		}

		this(T x, .ЛинкованныйУзел!(T) n) 
		{
			значение = x;
			следщ = n;
		}
}
