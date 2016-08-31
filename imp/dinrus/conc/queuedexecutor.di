module conc.queuedexecutor;

import conc.boundedlinkedqueue;
import conc.channel;
import conc.executor;
import conc.threadfactoryuser;

public class ОчереднойИсполнитель : ПользовательФабрикиНитей, Исполнитель 
{

	alias оберни!(цел delegate()) тип_значения;
	alias Канал!(тип_значения) ифейс_очереди;
	alias ОграниченнаяЛинкованнаяОчередь!(тип_значения) тип_очереди;

  protected Нить нить_;

				class КлассКонцаЗадания : тип_значения
				{
					this() ;
				}

  protected бул прерывание_;
  
  public synchronized Нить дайНить() ;
  protected synchronized проц сотриНить() ;
  
  protected final ифейс_очереди очередь_;
  protected цел пускЦикла ;
	
  public this(ифейс_очереди очередь) ;
  public this();
  public synchronized проц рестарт() ;
  public проц выполни(цел delegate() команда) ;
  public synchronized проц прерываниеПослеОбработкиТекущихЗадачВОчереди();
  public synchronized проц прерываниеПослеОбработкиТекущихЗадачОчереди() ;
}