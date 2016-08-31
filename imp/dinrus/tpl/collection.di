
module tpl.collection;

class Коллекция(Ш)
{
	private Ш[] _t;

	public final цел добавь(Ш t)
	{
		this._t ~= t;
		return this._t.length - 1;
	}

	public final проц сотри()
	{
		this._t.length = 0;
	}

	public final цел длина()
	{
		return this._t.length;
	}

	public final проц удали(Ш t)
	{		
		this.удалиПо(this.найди(t));
	}

	public final проц удалиПо(цел idx)
	{
		цел x = 0;
		Ш[] новШ = new Ш[this._t.length - 1];
		
		foreach(цел i, Ш t; this._t)
		{
			if(i != idx)
			{
				новШ[x] = t;
				x++;
			}
		}

		this._t = новШ;
	}

	public final цел найди(Ш t)
	{
		foreach(цел i, Ш ft; this._t)
		{
			if(ft is t)
			{
				return i;
			}
		}

		return -1;
	}

	public Ш opIndex(цел i)
	{
		if(i >= 0 && i < this._t.length)
		{
			return this._t[i];
		}

		return null;
	}

	public цел opApply(цел delegate(ref Ш) dg)
	{
		цел res = 0;

		if(this._t.length)
		{
			for(цел i = 0; i < this._t.length; i++)
			{
				res = dg(this._t[i]);

				if(res)
				{
					break;
				}
			}
		}

		return res;
	}

	public цел opApply(цел delegate(ref цел, ref Ш) dg)
	{
		цел res = 0;

		if(this._t.length)
		{
			for(цел i = 0; i < this._t.length; i++)
			{
				res = dg(i, this._t[i]);

				if(res)
				{
					break;
				}
			}
		}

		return res;
	}	
}