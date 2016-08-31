module conc.directexecutor;
import conc.executor;

class ПрямойИсполнитель : Исполнитель
 {
	public  проц выполни(цел delegate() команда) ;
}
