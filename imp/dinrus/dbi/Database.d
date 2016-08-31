module dbi.DataBase;
private import stdrus;
private import dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;

/**
 * The бд interface that all DBDs must inherit from.
 *
 * БазаДанных only provides a core установи of functionality.  Many DBDs have functions
 * that are specific to themselves, as they wouldn't make sense in any many other
 * databases.  Please reference the documentation for the DBD you will be using to
 * discover these functions.
 *
 * See_Also:
 *	The бд class for the DBD you are using.
 */
abstract class БазаДанных {


	/**
	 * Connect to a бд.
	 *
	 * Note that each DBD treats the parameters a slightly different way, so
	 * this is currently the only core function that cannot have its code
	 * reused for another DBD.
	 *
	 * Params:
	 *	парамы = A текст describing the подключение parameters.
	 *             documentation for the DBD before
	 *	имя_пользователя = The _userимя to _подключись with.  Some DBDs ignore this.
	 *	пароль = The _password to _подключись with.  Some DBDs ignore this.
	 */
	abstract проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто);

	/**
	 * A destructor that attempts to force the the release of of all
	 * бд подключисьions and similar things.
	 *
	 * The current D garbage collector doesn't always call destructors,
	 * so it is HIGHLY recommended that you закрой подключисьions manually.
	 */
	~this ();

	/**
	 * Close the current подключение to the бд.
	 */
	abstract проц закрой ();

	/**
	 * Prepare a SQL statement for execution.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни.
	 *
	 * Returns:
	 *	The подготовьd statement.
	 */
	final Инструкция подготовь (ткст эскюэл) ;

	/**
	 * Escape a _string using the бд's native method, if possible.
	 *
	 * Params:
	 *	текст = The _string to искейп,
	 *
	 * Returns:
	 *	The escaped _string.
	 */
	ткст искейп (ткст текст);

	/**
	 * Execute a SQL statement that returns no результаты.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to _выполни.
	 */
	abstract проц выполни (ткст эскюэл);

	/**
	 * Query the бд.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни.
	 *
	 * Returns:
	 *	A Результат object with the queried information.
	 */
	abstract Результат запрос (ткст эскюэл);

	/**
	 * Query the бд and return only the first ряд.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	final Ряд запросПолучиОдин (ткст эскюэл);

	/**
	 * Query the бд and return an array of all the ряды.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни
	 *
	 * Returns:
	 *	An array of Ряд objects with the queried information.
	 */
	final Ряд[] запросПолучиВсе (ткст эскюэл) ;

	/**
	 * Get the ошибка code.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка code.
	 */
	deprecated abstract цел дайКодОшибки ();

	/**
	 * Get the ошибка message.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка message.
	 */
	deprecated abstract ткст дайСообОшибки ();

	/**
	 * Split a _string into клслова and значения.
	 *
	 * Params:
	 *	текст = A _string in the form keyword1=value1;keyword2=value2;etc.
	 *
	 * Returns:
	 *	An associative array containing клслова and their значения.
	 *
	 * Thряды:
	 *	ИсклДБИ if текст is malformed.
	 */
	final protected ткст[ткст] дайКлслова (ткст текст) ;
}

private class ТестБД : БазаДанных {
	проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) {}
	проц закрой () {}
	проц выполни (ткст эскюэл) {}
	Результат запрос (ткст эскюэл);
	deprecated цел дайКодОшибки ();
	deprecated ткст дайСообОшибки () ;
}

debug(DB)
{
	void main() 
	{

			проц s1 (ткст s) 
			{
				stdrus.скажифнс("%s", s);
			}

			проц s2 (ткст s) 
			{
				stdrus.скажифнс("   ...%s", s);
			}


		s1("dbi.DataBase:");
		ТестБД бд;

		s2("дайКлслова");
		ткст[ткст] клслова = бд.дайКлслова("dbname=hi;host=local;");
		assert (клслова["dbname"] == "hi");
		assert (клслова["host"] == "local");
	}
}