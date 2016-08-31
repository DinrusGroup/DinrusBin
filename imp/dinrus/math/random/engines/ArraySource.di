/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.ArraySource;

/// very simple Массив based источник (use with care, some methods in non униформа distributions
/// expect a random источник with correct statistics, и could loop forever with such a источник)
struct МассИсток{
    бцел[] a;
    т_мера i;
    const цел canCheckpoint=нет; // implement?
    const цел можноСеять=нет;
    
    static МассИсток opCall(бцел[] a,т_мера i=0);
	
    бцел следщ();
	
    ббайт следщБ();
	
    бдол следщД();
}
