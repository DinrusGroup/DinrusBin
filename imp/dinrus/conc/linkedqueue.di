
module conc.linkedqueue;

import cidrus, stdrus:Нить;

import conc.channel;
import conc.linkednode;
import conc.sync;
import conc.waitnotify;

extern (C) цел sleep(бцел seconds);
alias sleep спи;


class ЛинкованнаяОчередь(T) : Канал!(T) {

	protected alias ЛинкованныйУзел!(T) тип_узла;
  protected тип_узла голова_;         
  protected final ОбъектЖдиУведоми поместитьЗамок_;
  protected тип_узла последний_;         
  protected цел ожиданиеЗабора_ = 0;  

  public this() {
    поместитьЗамок_ = new ОбъектЖдиУведоми(); 
    голова_ = new тип_узла; 
    последний_ = голова_;
  }

  /** Main mechanics for помести/предложи **/
  protected проц вставь(T x)
	in {
		assert(x !is пусто);
	} body { 
    synchronized(поместитьЗамок_) {
      тип_узла p = new тип_узла(x);
      synchronized(последний_) {
        последний_.следщ = p;
        последний_ = p;
      }
      if (ожиданиеЗабора_ > 0)
        поместитьЗамок_.уведоми();
    }
  }

  /** Main mechanics for возьми/запроси **/
  protected synchronized T извлеки() {
    synchronized(голова_) {
      T x = пусто;
      тип_узла первое = голова_.следщ;
      if (первое !is пусто) {
        x = первое.значение;
        первое.значение = пусто;
        голова_ = первое; 
      }
      return x;
    }
  }


  public проц помести(T x)
	in {
		assert(x !is пусто); 
	} body {
    вставь(x); 
  }

  public бул предложи(T x, дол мсек)
	in {
		assert(x !is пусто);
		assert(мсек >= 0);
	} body { 
    вставь(x); 
    return да;
  }

	public T возьми() {
		// try to извлеки. If fail, then enter жди-based retry loop
		T x = извлеки();
		if (x !is пусто)
			return x;
		else { 
			synchronized(поместитьЗамок_) {
				++ожиданиеЗабора_;
				for (;;) {
					x = извлеки();
					if (x !is пусто) {
						--ожиданиеЗабора_;
						return x;
					}
					else {
						try {
							поместитьЗамок_.жди(); 
						} catch (ИсклОжидания искл)
						{
							поместитьЗамок_.уведоми();
							throw искл;
						}
					}
				}
			}
		}
	}

  public T подбери() {
    synchronized(голова_) {
      тип_узла первое = голова_.следщ;
      if (первое !is пусто) 
        return первое.значение;
      else 
        return пусто;
    }
  }    


  public бул пуст_ли() {
    synchronized(голова_) {
			return голова_.следщ is пусто;
		}
	}    

	public T запроси(дол мсек)
	in {
		assert(мсек >= 0);
	} body {
		T x = извлеки();
		if (x !is пусто) 
			return x;
		else {
			synchronized(поместитьЗамок_) {
				дол времяОжидания = мсек;
				дол старт = (мсек <= 0)? 0 : clock();
				++ожиданиеЗабора_;
				for (;;) {
					x = извлеки();
					if (x !is пусто || времяОжидания <= 0) {
						--ожиданиеЗабора_;
						return x;
					}
					else {
						try
						{
							поместитьЗамок_.жди(времяОжидания); 
							времяОжидания = мсек - (clock() - старт);
						} catch (ИсклОжидания искл) {
							поместитьЗамок_.уведоми();
							throw искл;
						}
					}
				}
			}
		}
	}
}
