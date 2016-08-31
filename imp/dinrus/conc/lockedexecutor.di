module conc.lockedexecutor;

import conc.executor;
import conc.sync;

class БлокированныйИсполнитель : Исполнитель 
{
	protected:
		Синх мютекс_;
	public:	
  this(Синх мютекс) ;
  проц выполни(цел delegate() команда) ;
}
