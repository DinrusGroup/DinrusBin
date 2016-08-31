module io.selector.EpollSelector;


version (linux)
{
    public import io.model;
    public import io.selector.model;

    private import io.selector.AbstractSelector;
   private import sys.linux.linux;



 
public class EpollSelector: АбстрактныйСелектор
    {

        alias АбстрактныйСелектор.выбери выбери;
        public const бцел ДефРазмер = 64;
        public const бцел DefaultMaxEvents = 16;

       ~this();
        public проц открой(бцел размер = ДефРазмер, бцел maxEvents = DefaultMaxEvents);
        public проц закрой();
		public т_мера счёт();
        public проц регистрируй(ИВыбираемый провод, Событие события, Объект атачмент = пусто);
        public проц отмениРег(ИВыбираемый провод);
        public цел выбери(ИнтервалВремени таймаут);
		
        protected class EpollSelectionSet: ИНаборВыделений
        {
            public бцел length();
            public цел opApply(цел delegate(ref КлючВыбора) дг);
        }

        
        public ИНаборВыделений наборВыд();
        public КлючВыбора ключ(ИВыбираемый провод);
        цел opApply(цел delegate(ref КлючВыбора) дг);
    }
}

