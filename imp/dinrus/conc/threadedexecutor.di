
module conc.threadedexecutor;

import conc.executor;
import conc.threadfactoryuser;

class ПоточныйИсполнитель : ПользовательФабрикиНитей, Исполнитель
 {
  public synchronized проц выполни(цел delegate() команда);
}
