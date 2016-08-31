/* \file boundedlinkedqueue
 * \brief Size-bounded inter-нить очередь
 */

/*
	 Originally written by Doug Lea and released into the public domain.
	 This may be used for any purposes whatsoever without acknowledgment.
	 Thanks for the assistance and support of Sun Microsystems Labs,
	 and everyone contributing, testing, and using this code.

History:
Date       Who                What
11Jun1998  dl               Create public version
17Jul1998  dl               Simplified by eliminating жди counts
25aug1998  dl               added подбери
10oct1999  dl               замок on node object to ensure visibility
27jan2000  dl               установиЁмкость forces immediate permit reconcile
07May2004  Mike Swieton     Translated to D
 */

module conc.boundedlinkedqueue;

import cidrus, conc.channel;

import conc.boundedchannel;
import conc.defaultchannelcapacity;
import conc.linkednode;
import conc.sync;
import conc.waitnotify;

/**
 * A bounded variant of ЛинкованнаяОчередь class. This class may be preferable to
 * BoundedBuffer because it allows a bit more concurency among puts and takes,
 * because it does not pre-allocate fixed storage for elements, and allows
 * ёмкость to be dynamically reset.  On the другое hand, since it allocates a
 * node object on each помести, it can be slow on systems with slow allocation and
 * GC.  Also, it may be preferable to ЛинкованнаяОчередь when you need to limit the
 * ёмкость to prevent resource exhaustion. This protection normally does not
 * hurt much performance-wise: When the очередь is not empty or full, most puts
 * and takes are still usually able to выполни concurrently.
 * @see ЛинкованнаяОчередь 
 * @see BoundedBuffer 
 **/

class ОграниченнаяЛинкованнаяОчередь(T) : ОбъектЖдиУведомиВсех, ОграниченныйКанал!(T), Канал!(T) {

	/*
	 * It might be a bit nicer if this were declared as
	 * a subclass of ЛинкованнаяОчередь, or a sibling class of
	 * a common abstract class. It shares much of the
	 * basic design and bookkeeping fields. But too 
	 * many details differ to make this worth doing.
	 */

	protected alias ЛинкованныйУзел!(T) тип_узла;

	/** 
	 * Dummy header node of list. The первое actual node, if it exists, is always 
	 * at голова_.следщ. After each возьми, the старый первое node becomes the head.
	 **/
	protected тип_узла голова_;

	/** 
	 * The last node of list. Put() appends to list, so modifies последний_
	 **/
	protected тип_узла последний_;

	/**
	 * Helper monitor. Ensures that only one помести at a время executes.
	 **/
	protected final Объект стражПомещения_;

	/**
	 * Helper monitor. Protects and provides жди очередь for takes
	 **/
	protected final ОбъектЖдиУведомиВсех стражВзятия_;


	/** Number of elements allowed **/
	protected цел ёмкость_;


	/**
	 * One side of a split permit счёт. 
	 * The counts represent права to do a помести. (The очередь is full when zero).
	 * Invariant: putSidePutPermits_ + takeSidePutPermits_ = ёмкость_ - length.
	 * (The length is never separately recorded, so this cannot be
	 * checked explicitly.)
	 * To minimize contention between puts and takes, the
	 * помести side uses up all of its права before transfering them from
	 * the возьми side. The возьми side just increments the счёт upon each возьми.
	 * Thus, most puts and возьми can пуск independently of each другое unless
	 * the очередь is empty or full. 
	 * Initial значение is очередь ёмкость.
	 **/

	protected цел putSidePutPermits_; 

	/** Number of takes since last reconcile **/
	protected цел takeSidePutPermits_ = 0;


	/**
	 * Create a очередь with the given ёмкость
	 * @exception IllegalArgumentException if ёмкость less or equal to zero
	 **/
	public this(цел ёмкость)
		in {
			assert(ёмкость > 0);
		} body {
			ёмкость_ = ёмкость;
			putSidePutPermits_ = ёмкость;
			голова_ =  new тип_узла(пусто); 
			последний_ = голова_;

			стражПомещения_ = new Объект();
			стражВзятия_ = new ОбъектЖдиУведомиВсех();
		}

	/**
	 * Create a очередь with the current default ёмкость
	 **/

	public this() { 
		this(ДефолтнаяЁмкостьКанала.дай()); 
	}

	/**
	 * Move помести права from возьми side to помести side; 
	 * return the число of помести side права that are available.
	 * Call only under synch on puGuard_ AND this.
	 **/
	protected final цел reconcilePutPermits() {
		putSidePutPermits_ += takeSidePutPermits_;
		takeSidePutPermits_ = 0;
		return putSidePutPermits_;
	}


	/** Return the current ёмкость of this очередь **/
	public synchronized цел ёмкость() { return ёмкость_; }


	/** 
	 * Return the число of elements in the очередь.
	 * This is only a snapshot значение, that may be in the midst 
	 * of changing. The returned значение will be unreliable in the presence of
	 * active puts and takes, and should only be used as a heuristic
	 * estimate, for example for resource monitoring purposes.
	 **/
	public synchronized цел размер() {
		/*
			 This should ideally synch on стражПомещения_, but
			 doing so would cause it to block ждущий for an in-progress
			 помести, which might be stuck. So we instead use whatever
			 значение of putSidePutPermits_ that we happen to read.
		 */
		return ёмкость_ - (takeSidePutPermits_ + putSidePutPermits_);
	}


	/**
	 * Reset the ёмкость of this очередь.
	 * If the new ёмкость is less than the старый ёмкость,
	 * existing elements are NOT removed, but
	 * incoming puts will not proceed until the число of elements
	 * is less than the new ёмкость.
	 * @exception IllegalArgumentException if ёмкость less or equal to zero
	 **/

	public проц установиЁмкость(цел новаяЁмкость)
		in {
			assert(новаяЁмкость > 0);
		} body {
			synchronized (стражПомещения_) {
				synchronized(this) {
					takeSidePutPermits_ += (новаяЁмкость - ёмкость_);
					ёмкость_ = новаяЁмкость;

					// Force immediate reconcilation.
					reconcilePutPermits();
					уведомиВсех();
				}
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
				++takeSidePutPermits_;
				// TODO: this should be a уведоми() but a dual уведоми/уведомиВсех
				// needs to be implemented on win32 первое
				уведомиВсех();
			}
			return x;
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

	public T возьми() {
		T x = извлеки();
		if (x !is пусто) 
			return x;
		else {
			synchronized(стражВзятия_) {
				for (;;) {
					x = извлеки();
					if (x !is пусто) {
						return x;
					}
					else {
						стражВзятия_.жди(); 
					}
				}
			}
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
				synchronized(стражВзятия_) {
					дол времяОжидания = мсек;
					дол старт = (мсек <= 0)? 0: clock();
					for (;;) {
						x = извлеки();
						if (x !is пусто || времяОжидания <= 0) {
							return x;
						}
						else {
							стражВзятия_.жди(времяОжидания); 
							времяОжидания = мсек - (clock() - старт);
						}
					}
				}
			}
		}

	/** Notify a ждущий возьми if needed **/
	protected final проц разрешиВзять() {
		synchronized(стражВзятия_) {
			стражВзятия_.уведомиВсех();
		}
	}


	/**
	 * Create and вставь a node.
	 * Call only under synch on стражПомещения_
	 **/
	protected проц вставь(T x)
		in {
			assert(x !is пусто);
		} body { 
			--putSidePutPermits_;
			тип_узла p = new тип_узла(x);
			synchronized(последний_) {
				последний_.следщ = p;
				последний_ = p;
			}
		}


	/* 
		 помести and предложи(ms) differ only in policy before вставь/разрешиВзять
	 */
	public проц помести(T x)
		in {
			assert(x !is пусто);
		} body {
			synchronized(стражПомещения_) {
				if (putSidePutPermits_ <= 0) { // жди for permit. 
					synchronized(this) {
						if (reconcilePutPermits() <= 0) {
							try
							{
								for(;;) {
									жди();
									if (reconcilePutPermits() > 0) {
										break;
									}
								}
							} catch (ИсклОжидания искл) {
								уведомиВсех();
								throw искл;
							}
						}
					}
				}
				вставь(x);
			}
			// call outside of замок to loosen помести/возьми coupling
			разрешиВзять();
		}

	public бул предложи(T x, дол мсек) 
		in
		{
			assert(x !is пусто);
			assert(мсек >= 0);
		} body {
			synchronized(стражПомещения_) {

				if (putSidePutPermits_ <= 0) {
					synchronized(this) {
						if (reconcilePutPermits() <= 0) {
							if (мсек <= 0)
								return нет;
							else {
								try
								{
									дол времяОжидания = мсек;
									дол старт = clock();

									for(;;) {
										жди(времяОжидания);
										if (reconcilePutPermits() > 0) {
											break;
										}
										else {
											времяОжидания = мсек - (clock() - старт);
											if (времяОжидания <= 0) {
												return нет;
											}
										}
									}
								} catch (ИсклОжидания искл) {
								  уведомиВсех();
									throw искл;
								}
							}
						}
					}
				}

				вставь(x);
			}

			разрешиВзять();
			return да;
		}

	public бул пуст_ли() {
		synchronized(голова_) {
			return голова_.следщ is пусто;
		}
	}    
}
