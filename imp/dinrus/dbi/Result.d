/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.Result;

private import dbi.Row;

/**
 * Manage a результат установи from a бд запрос.
 *
 * This is the class returned by every запрос function, not the DBD specific результат
 * class.
 *
 * See_Also:
 *	The результат class for the DBD you are using.
 */
abstract class Результат {
	/**
	 * A destructor that attempts to force the the release of of all
	 * statements handles and similar things.
	 *
	 * The current D garbage collector doesn't always call destructors,
	 * so it is HIGHLY recommended that you закрой подключисьions manually.
	 */
	~this () ;

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	abstract Ряд получиРяд ();

	/**
	 * Get all of the remaining ряды from a результат установи.
	 *
	 * Returns:
	 *	An array of Ряд objects with the queried information.
	 */
	Ряд[] получиВсе ();

	/**
	 * Free all бд resources used by a результат установи.
	 */
	abstract проц финиш ();
}