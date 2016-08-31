
/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.Row;

version(Rulada) {
	debug (UnitTest) private static import std.io;
} else {
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DBIException;

/**
 * Доступ к одиночной строке в наборе результатов запроса.
 *
 * Almost everything in this file is going to be deprecated and replaced soon.  To
 * give your opinions on what should be done with it, go to the D DBI forums at
 * www.dsource.org/forums/viewtopic.php?t=1640.  Whatever is decided will
 * take effect in version 0.3.0.  Anything deprecated will be removed in version
 * 0.4.0.
 *
 * As a результат, this file is no longer being updated with the exception of bug
 * fixes.  It is highly recommended that even if you do not want to contribute
 * to the discussion on what to do to this file, you should follow the link to see
 * what the new version is likely to look like.
 */
final class Ряд {
	/**
	 * Get a field's contents by индекс.
	 *
	 * Params:
	 *	инд = Field индекс.
	 *
	 * Examples:
	 *	---
	 *	Ряд ряд = рез.получиРяд();
	 *	writefln("first=%s, last=%s\n", ряд[0], ряд[1]);
	 *	---
	 *
	 * Returns:
	 *	The field's contents.
	 */
	ткст opIndex (цел инд) ;

	/**
	 * Get a field's contents by field _имя.
	 *
	 * Params:
	 *	имя = Field _имя.
	 *
	 * Examples:
	 *	---
	 *	Ряд ряд = рез.получиРяд();
	 *	wriefln("first=%s, last=%s\n", ряд["first"], ряд["last"]);
	 *	---
	 *
	 * Returns:
	 *	The field's contents.
	 */
	ткст opIndex (ткст имя) ;

	/**
	 * Get a field's contents by индекс.
	 *
	 * Params:
	 *	инд = Field индекс.
	 *
	 * Returns:
	 *	The field's contents.
	 */
	ткст дай (цел инд) ;

	/**
	 * Get a field's contents by field _имя.
	 *
	 * Params:
	 *	имя = Field _имя.
	 *
	 * Returns:
	 *	The field's contents.
	 */
	ткст дай (ткст имя) ;

	/**
	 * Get a field's индекс by field _имя.
	 *
	 * Params:
	 *	имя = Field _имя.
	 *
	 * Thряды:
	 *	ИсклДБИ if имя is not a действителен индекс.
	 *
	 * Returns:
	 *	The field's индекс.
	 */
	цел дайИндексПоля (ткст имя) ;

	/**
	 * Get the field тип.
	 *
	 * Params:
	 *	инд = Field индекс.
	 *
	 * Returns:
	 *	The field's тип.
	 */
	цел дайТипПоля (цел инд);

	/**
	 * Get a field's SQL declaration.
	 *
	 * Params:
	 *	инд = Field индекс.
	 *
	 * Returns:
	 *	The field's SQL declaration.
	 */
	ткст дайОбъявлПоля (цел инд);

	/**
	 * Add a new field to this ряд.
	 *
	 * Params:
	 *	имя = Name.
	 *	значение = Value.
	 *	объявл = SQL declaration, i.e. varchar(20), decimal(12,2), etc...
	 *	тип = SQL _type.
	 *
	 * Todo:
	 *	SQL _type should be defined by the D DBI DBD interface spec, therefore
	 *	each DBD module will act exactly alike.
	 */
	проц добавьПоле (ткст имя, ткст значение, ткст объявл, цел тип) ;

	private:
	ткст[] именаПолей;
	ткст[] значПолей;
	ткст[] объявлПолей;
	цел[] типыПолей;
}

unittest {
	version(Rulada) {
		проц s1 (ткст s) {
			std.io.writefln("%s", s);
		}

		проц s2 (ткст s) {
			std.io.writefln("   ...%s", s);
		}
	} else {
		проц s1 (ткст s) {
			io.Stdout.Стдвыв(s).нс();
		}

		проц s2 (ткст s) {
			io.Stdout.Стдвыв("   ..." ~ s).нс();
		}
	}

	s1("dbi.Row:");
	Ряд r1 = new Ряд();
	r1.добавьПоле("имя", "John Doe", "text", 3);
	r1.добавьПоле("age", "23", "integer", 1);

	s2("дай(цел)");
	assert (r1.дай(0) == "John Doe");

	s2("дай(ткст)");
	assert (r1.дай("имя") == "John Doe");

	s2("[цел]");
	assert (r1[0] == "John Doe");

	s2("[ткст]");
	assert (r1["age"] == "23");

	s2("дайИндексПоля");
	assert (r1.дайИндексПоля("имя") == 0);

	s2("дайТипПоля");
	assert (r1.дайТипПоля(0) == 3);

	s2("дайОбъявлПоля");
	assert (r1.дайОбъявлПоля(1) == "integer");
}