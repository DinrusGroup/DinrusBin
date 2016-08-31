module conc.threadfactoryuser;

import conc.threadfactory, stdrus:Нить;

public class ПользовательФабрикиНитей 
{

	protected:
		ФабрикаНитей фабрикаНитей_;

				class ДефолтнаяФабрикаНитей : ФабрикаНитей 
				{
					public Нить новаяНить(цел delegate() команда);
				}

	public:

		this();
		synchronized ФабрикаНитей установиФабрикуНитей(ФабрикаНитей фабрика) ;
		synchronized ФабрикаНитей дайФабрикуНитей();
}
