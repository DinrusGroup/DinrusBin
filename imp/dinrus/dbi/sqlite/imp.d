/**
 * SQLite import library.
 *
 * Part of the D DBI project.
 *
 * Version:
 *	SQLite version 3.3.11
 *
 *	Import library version 0.05
 *
 * Authors: The D DBI project
 *
 * Copyright: BSD license
 */

module dbi.sqlite.imp;

version (Windows) {
	pragma (lib, "sqlite3.lib");
} else version (linux) {
	pragma (lib, "libsqlite.so");
} else version (Posix) {
	pragma (lib, "libsqlite.so");
} else version (darwin) {
	pragma (lib, "libsqlite.so");
} else {
	pragma (сооб, "You will need to manually link in the SQLite library.");
}

version (Rulada) {
	private import std.c;
} else {
	private import cidrus;
}

/**
 *
 */
struct sqlite3 {
}

/**
 *
 */
struct sqlite3_context {
}

/**
 *
 */
struct sqlite3_index_info {
	цел nConstraint;			/// Number of entries in aConstraint.
	struct sqlite3_index_constraint {
		цел iColumn;			/// Column on left-hand side of constraint.
		ббайт op;			/// Constraint operator.
		ббайт usable;			/// да if this constraint is usable.
		цел iTermOffустанови;		/// Used internally - xBestIndex should ignore.
	}
	sqlite3_index_constraint* aConstraint;	/// Таблица of WHERE clause constraints.

	цел nOrderBy;				/// Number of terms in the ORDER BY clause.
	struct sqlite3_index_orderby {
		цел iColumn;			/// Column number.
		ббайт desc;			/// да for DESC and false for ASC.
	}
	sqlite3_index_orderby* aOrderBy;	/// The ORDER BY clause.

	struct sqlite3_index_constraint_usage {
		цел argvIndex;			/// if >0, constraint is part of argv to xFilter.
		ббайт omit;			/// Do not code a test for this constraint.
	}
	sqlite3_index_constraint_usage* aConstraintUsage; ///
	цел idxNum;				/// Number used to identify the индекс.
	char* idxStr;				/// Ткст, possibly obtained from sqlite3_malloc.
	цел needToFreeIdxStr;			/// Free idxStr using sqlite3_free() if да.
	цел orderByConsumed;			/// да if output is already ordered.
	дво estimatedCost;			/// Estimated cost of using this индекс.
}

/**
 *
 */
struct sqlite3_module {
	цел iVersion;
	extern (C) цел function(sqlite3* бд, ук pAux, цел argc, char** argv, sqlite3_vtab** ppVTab, char**) xCreate;
	extern (C) цел function(sqlite3* бд, ук pAux, цел argc, char** argv, sqlite3_vtab** ppVTab, char**) xConnect;
	extern (C) цел function(sqlite3_vtab* pVTab, sqlite3_index_info* pInfo) xBestIndex;
	extern (C) цел function(sqlite3_vtab* pVTab) xDisподключись;
	extern (C) цел function(sqlite3_vtab* pVTab) xDestroy;
	extern (C) цел function(sqlite3_vtab* pVTab, sqlite3_vtab_cursor** ppCursor) xOpen;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor) xClose;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor, цел idxNum, char* idxStr, цел argc, sqlite3_value** argv) xFilter;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor) xNext;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor) xEof;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor, sqlite3_context*, цел) xColumn;
	extern (C) цел function(sqlite3_vtab_cursor* pVTabCursor, дол* pRowid) xRowid;
	extern (C) цел function(sqlite3_vtab* pVTab, цел, sqlite3_value**, дол*) xUpdate;
	extern (C) цел function(sqlite3_vtab* pVTab) xBegin;
	extern (C) цел function(sqlite3_vtab* pVTab) xSync;
	extern (C) цел function(sqlite3_vtab* pVTab) xCommit;
	extern (C) цел function(sqlite3_vtab* pVTab) xRollback;
	extern (C) цел function(sqlite3_vtab* pVtab, цел nArg, char* zName, проц function(sqlite3_context*, цел, sqlite3_value**)pxFunc, ук* ppArg) xFindFunction;
}

/**
 *
 */
struct sqlite3_stmt {
}

/**
 *
 */
struct sqlite3_value {
}

/**
 *
 */
struct sqlite3_vtab {
	sqlite3_module* pModule;	/// The module for this virtual таблица.
	цел nRef;			/// Used internally.
	char* zErrMsg;			/// Error message from sqlite3_mprintf().
}

/**
 *
 */
struct sqlite3_vtab_cursor {
	sqlite3_vtab* pVtab;		/// Virtual таблица of this cursor.
}

/**
 *
 */
alias цел function(ук, цел, char**, char**) sqlite_callback;

const цел SQLITE_OK			= 0;	/// Successful результат.
const цел SQLITE_ERROR			= 1;	/// SQL ошибка or missing бд.
const цел SQLITE_INTERNAL		= 2;	/// An internal logic ошибка in SQLite.
const цел SQLITE_PERM			= 3;	/// Access permission denied.
const цел SQLITE_ABORT			= 4;	/// Callback routine requested an abort.
const цел SQLITE_BUSY			= 5;	/// The бд file is locked.
const цел SQLITE_LOCKED			= 6;	/// A таблица in the бд is locked.
const цел SQLITE_NOMEM			= 7;	/// A malloc() failed.
const цел SQLITE_READONLY		= 8;	/// Attempt to write a readonly бд.
const цел SQLITE_INTERRUPT		= 9;	/// Operation terminated by sqlite_interrupt().
const цел SQLITE_IOERR			= 10;	/// Some kind of disk I/O ошибка occurred.
const цел SQLITE_CORRUPT		= 11;	/// The бд disk image is malformed.
const цел SQLITE_NOTFOUND		= 12;	/// (Internal Only) Таблица or record not found.
const цел SQLITE_FULL			= 13;	/// Insertion failed because бд is full.
const цел SQLITE_CANTOPEN		= 14;	/// Unable to open the бд file.
const цел SQLITE_PROTOCOL		= 15;	/// БазаДанных lock protocol ошибка.
const цел SQLITE_EMPTY			= 16;	/// (Internal Only) БазаДанных таблица is empty.
const цел SQLITE_SCHEMA			= 17;	/// The бд schema changed.
const цел SQLITE_TOOBIG			= 18;	/// Too much data for one ряд of a таблица.
const цел SQLITE_CONSTRAINT		= 19;	/// Abort due to constraint violation.
const цел SQLITE_MISMATCH		= 20;	/// Data тип mismatch.
const цел SQLITE_MISUSE			= 21;	/// Library used incorrectly.
const цел SQLITE_NOLFS			= 22;	/// Uses OS возможности not supported on host.
const цел SQLITE_AUTH			= 23;	/// Authorization denied.
const цел SQLITE_ROW			= 100;	/// sqlite_step() has another ряд ready.
const цел SQLITE_DONE			= 101;	/// sqlite_step() has финишed executing.
const цел SQLITE_UTF8			= 1;	/// The text is in UTF8 format.
const цел SQLITE_UTF16BE		= 2;	/// The text is in UTF16 big endian format.
const цел SQLITE_UTF16LE		= 3;	/// The text is in UTF16 little endian format.
const цел SQLITE_UTF16			= 4;	/// The text is in UTF16 format.
const цел SQLITE_ANY			= 5;	/// The text is in some format or another.

const цел SQLITE_INTEGER		= 1;	/// The data значение is an integer.
const цел SQLITE_FLOAT			= 2;	/// The data значение is a плав.
const цел SQLITE_TEXT			= 3;	/// The data значение is text.
const цел SQLITE_BLOB			= 4;	/// The data значение is a блоб.
const цел SQLITE_NULL			= 5;	/// The data значение is _null.

const цел SQLITE_DENY			= 1;	/// Abort the SQL statement with an ошибка.
const цел SQLITE_IGNORE			= 2;	/// Don't allow access, but don't generate an ошибка.

const проц function(ук) SQLITE_STATIC = cast(проц function(ук))0; /// The data doesn't need to be freed by SQLite.
const проц function(ук) SQLITE_TRANSIENT = cast(проц function(ук))-1; /// SQLite should make a private copy of the data.

const цел SQLITE_CREATE_INDEX		= 1;	/// Index Name		Таблица Name
const цел SQLITE_CREATE_TABLE		= 2;	/// Таблица Name		NULL
const цел SQLITE_CREATE_TEMP_INDEX	= 3;	/// Index Name		Таблица Name
const цел SQLITE_CREATE_TEMP_TABLE	= 4;	/// Таблица Name		NULL
const цел SQLITE_CREATE_TEMP_TRIGGER	= 5;	/// Trigger Name	Таблица Name
const цел SQLITE_CREATE_TEMP_VIEW	= 6;	/// View Name		NULL
const цел SQLITE_CREATE_TRIGGER		= 7;	/// Trigger Name	Таблица Name
const цел SQLITE_CREATE_VIEW		= 8;	/// View Name		NULL
const цел SQLITE_DELETE			= 9;	/// Таблица Name		NULL
const цел SQLITE_DROP_INDEX		= 10;	/// Index Name		Таблица Name
const цел SQLITE_DROP_TABLE		= 11;	/// Таблица Name		NULL
const цел SQLITE_DROP_TEMP_INDEX	= 12;	/// Index Name		Таблица Name
const цел SQLITE_DROP_TEMP_TABLE	= 13;	/// Таблица Name		NULL
const цел SQLITE_DROP_TEMP_TRIGGER	= 14;	/// Trigger Name	Таблица Name
const цел SQLITE_DROP_TEMP_VIEW		= 15;	/// View Name		NULL
const цел SQLITE_DROP_TRIGGER		= 16;	/// Trigger Name	Таблица Name
const цел SQLITE_DROP_VIEW		= 17;	/// View Name		NULL
const цел SQLITE_INSERT			= 18;	/// Таблица Name		NULL
const цел SQLITE_PRAGMA			= 19;	/// Pragma Name		1st arg or NULL
const цел SQLITE_READ			= 20;	/// Таблица Name		Column Name
const цел SQLITE_SELECT			= 21;	/// NULL		NULL
const цел SQLITE_TRANSACTION		= 22;	/// NULL		NULL
const цел SQLITE_UPDATE			= 23;	/// Таблица Name		Column Name
const цел SQLITE_ATTACH			= 24;	/// Fileимя		NULL
const цел SQLITE_DETACH			= 25;	/// БазаДанных Name	NULL
const цел SQLITE_ALTER_TABLE		= 26;	/// БазаДанных Name	Таблица Name
const цел SQLITE_REINDEX		= 27;	/// Index Name		NULL
const цел SQLITE_ANALYZE		= 28;	/// Таблица Name		NULL
const цел SQLITE_CREATE_VTABLE		= 29;	/// Таблица Name		Module Name
const цел SQLITE_DROP_VTABLE		= 30;	/// Таблица Name		Module Name
const цел SQLITE_FUNCTION		= 31;	/// Function Name	NULL

const цел SQLITE_INDEX_CONSTRAINT_EQ	= 2;	///
const цел SQLITE_INDEX_CONSTRAINT_GT	= 4;	///
const цел SQLITE_INDEX_CONSTRAINT_LE	= 8;	///
const цел SQLITE_INDEX_CONSTRAINT_LT	= 16;	///
const цел SQLITE_INDEX_CONSTRAINT_GE	= 32;	///
const цел SQLITE_INDEX_CONSTRAINT_MATCH = 64;	///

const цел SQLITE_IOERR_READ		= SQLITE_IOERR | (1<<8); ///
const цел SQLITE_IOERR_SHORT_READ	= SQLITE_IOERR | (2<<8); ///
const цел SQLITE_IOERR_WRITE		= SQLITE_IOERR | (3<<8); ///
const цел SQLITE_IOERR_FSYNC		= SQLITE_IOERR | (4<<8); ///
const цел SQLITE_IOERR_DIR_FSYNC	= SQLITE_IOERR | (5<<8); ///
const цел SQLITE_IOERR_TRUNCATE		= SQLITE_IOERR | (6<<8); ///
const цел SQLITE_IOERR_FSTAT		= SQLITE_IOERR | (7<<8); ///
const цел SQLITE_IOERR_UNLOCK		= SQLITE_IOERR | (8<<8); ///
const цел SQLITE_IOERR_RDLOCK		= SQLITE_IOERR | (9<<8); ///

extern (C):

/**
 *
 */
ук sqlite3_aggregate_context (sqlite3_context* ctx, цел nBytes);

/**
 *
 */
deprecated цел sqlite3_aggregate_count (sqlite3_context* ctx);

/**
 *
 */
цел sqlite3_auto_extension (ук xEntryPoint);

/**
 *
 */
цел sqlite3_bind_blob (sqlite3_stmt* инстр, цел индекс, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
цел sqlite3_bind_double (sqlite3_stmt* инстр, цел индекс, дво значение);

/**
 *
 */
цел sqlite3_bind_int (sqlite3_stmt* инстр, цел индекс, цел значение);

/**
 *
 */
цел sqlite3_bind_int64 (sqlite3_stmt* инстр, цел индекс, дол значение);

/**
 *
 */
цел sqlite3_bind_null (sqlite3_stmt* инстр, цел индекс);

/**
 *
 */
цел sqlite3_bind_text (sqlite3_stmt* инстр, цел индекс, char* значение, цел n, проц function(ук) destructor);

/**
 *
 */
цел sqlite3_bind_text16 (sqlite3_stmt* инстр, цел индекс, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
цел sqlite3_bind_parameter_count (sqlite3_stmt* инстр);

/**
 *
 */
цел sqlite3_bind_parameter_index (sqlite3_stmt* инстр, char* zName);

/**
 *
 */
char* sqlite3_bind_parameter_имя (sqlite3_stmt* инстр, цел n);

/**
 *
 */
цел sqlite3_busy_handler (sqlite3* бд, цел function(ук, цел) handler, ук n);

/**
 *
 */
цел sqlite3_busy_timeout (sqlite3* бд, цел ms);

/**
 *
 */
цел sqlite3_changes (sqlite3* бд);

/**
 *
 */
цел sqlite3_clear_bindings(sqlite3_stmt* statement);

/**
 *
 */
цел sqlite3_close(sqlite3* бд);

/**
 *
 */
цел sqlite3_collation_needed (sqlite3* бд, ук имяs, проц function(ук имяs, sqlite3* бд, цел eTextRep, char* sequence));

/**
 *
 */
цел sqlite3_collation_needed (sqlite3* бд, ук имяs, проц function(ук имяs, sqlite3* бд, цел eTextRep, ук sequence));

/**
 *
 */
ук sqlite3_column_blob (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
цел sqlite3_column_bytes (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
цел sqlite3_column_bytes16 (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
дво sqlite3_column_double (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
цел sqlite3_column_int (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
дол sqlite3_column_int64 (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
char* sqlite3_column_text (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
ук sqlite3_column_text16 (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
цел sqlite3_column_type (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
цел sqlite3_column_count (sqlite3_stmt* инстр);

/**
 *
 */
char* sqlite3_column_database_name (sqlite3_stmt* инстр, цел n);

/**
 *
 */
ук sqlite3_column_database_name16 (sqlite3_stmt* инстр, цел n);

/**
 *
 */
char* sqlite3_column_decltype (sqlite3_stmt* инстр, цел i);

/**
 *
 */
ук sqlite3_column_decltype16 (sqlite3_stmt* инстр, цел i);

/**
 *
 */
char* sqlite3_column_name (sqlite3_stmt* инстр, цел n);

/**
 *
 */
ук sqlite3_column_name16 (sqlite3_stmt* инстр, цел n);

/**
 *
 */
char* sqlite3_column_origin_name (sqlite3_stmt* инстр, цел n);

/**
 *
 */
ук sqlite3_column_origin_name16 (sqlite3_stmt* sStmt, цел n);

/**
 *
 */
char* sqlite3_column_table_name (sqlite3_stmt* инстр, цел n);

/**
 *
 */
ук sqlite3_column_table_name16 (sqlite3_stmt* инстр, цел n);

/**
 *
 */
sqlite3_value* sqlite3_column_value (sqlite3_stmt* инстр, цел iCol);

/**
 *
 */
ук sqlite3_commit_hook (sqlite3* бд, цел function(ук args) xCallback, ук args);

/**
 *
 */
цел sqlite3_complete (char* эскюэл);

/**
 *
 */
цел sqlite3_complete16 (ук эскюэл);

/**
 *
 */
цел sqlite3_create_collation (sqlite3* бд, char* zName, цел pref16, ук routine, цел function(ук, цел, ук, цел, ук) xCompare);

/**
 *
 */
цел sqlite3_create_collation16 (sqlite3* бд, char* zName, цел pref16, ук routine, цел function(ук, цел, ук, цел, ук) xCompare);

/**
 *
 */
цел sqlite3_create_function (sqlite3* бд, char* zFunctionName, цел nArg, цел eTextRep, ук pUserData, проц function(sqlite3_context*, цел, sqlite3_value**) xFunc, проц function(sqlite3_context*, цел, sqlite3_value**) xStep, проц function(sqlite3_context*) xFinal);

/**
 *
 */
цел sqlite3_create_function (sqlite3* бд, ук zFunctionName, цел nArg, цел eTextRep, ук pUserData, проц function(sqlite3_context*, цел, sqlite3_value**) xFunc, проц function(sqlite3_context*, цел, sqlite3_value**) xStep, проц function(sqlite3_context*) xFinal);

/**
 *
 */
цел sqlite3_create_module (sqlite3* бд,	char* zName, sqlite3_module* methods, ук data);

/**
 *
 */
цел sqlite3_data_count (sqlite3_stmt* инстр);

/**
 *
 */
sqlite3* sqlite3_db_handle (sqlite3_stmt* инстр);

/**
 *
 */
цел sqlite3_declare_vtab (sqlite3* бд, char* zCreateТаблица);

/**
 *
 */
цел sqlite3_включи_load_extension (sqlite3* бд, цел onoff);

/**
 *
 */
цел sqlite3_включи_shared_cache (цел включи);

/**
 *
 */
цел sqlite3_errcode (sqlite3* бд);

/**
 *
 */
char* sqlite3_errmsg (sqlite3* бд);

/**
 *
 */
ук sqlite3_errmsg16 (sqlite3* бд);

/**
 *
 */
цел sqlite3_exec (sqlite3* бд, char* эскюэл, sqlite_callback routine, ук arg, char** errmsg);

/**
 *
 */
цел sqlite3_expired (sqlite3_stmt* инстр);

/**
 *
 */
цел sqlite3_extended_result_codes (sqlite3* бд, цел onoff);

/**
 *
 */
цел sqlite3_finalize (sqlite3_stmt* инстр);

/**
 *
 */
проц sqlite3_free (char* ptr);

/**
 *
 */
цел sqlite3_get_table (sqlite3* бд, char* эскюэл, char*** resultp, цел* nrow, цел* ncolumn, char** errmsg);

/**
 *
 */
проц sqlite3_free_table (char** результат);

/**
 *
 */
цел sqlite3_get_autocommit (sqlite3* бд);

/**
 *
 */
цел sqlite3_global_recover ();

/**
 *
 */
проц sqlite3_interrupt (sqlite3* бд);

/**
 *
 */
дол sqlite3_last_insert_rowid (sqlite3* бд);

/**
 *
 */
char* sqlite3_libversion ();

/**
 *
 */
цел sqlite3_load_extension (sqlite3* бд, char* zFile, char* zProc, char** ppErrMsg);

/**
 *
 */
ук sqlite3_malloc (цел size);

/**
 *
 */
char* sqlite3_mprintf (char* текст, ...);

/**
 *
 */
char* sqlite3_vmprintf (char* текст, va_list args);

/**
 *
 */
цел sqlite3_open (char* fileимя, sqlite3** бд);

/**
 *
 */
цел sqlite3_open16 (ук fileимя, sqlite3** бд);

/**
 *
 */
цел sqlite3_overload_function (sqlite3* бд, char* zFuncName, цел nArg);

/**
 *
 */
цел sqlite3_prepare (sqlite3* бд, char* zSql, цел nBytes, sqlite3_stmt** инстр, char** zTail);

/**
 *
 */
цел sqlite3_prepare16 (sqlite3* бд, ук zSql, цел nBytes, sqlite3_stmt** инстр, ук* zTail);

/**
 *
 */
цел sqlite3_prepare_v2 (sqlite3* бд, char* zSql, цел nBytes, sqlite3_stmt** инстр, char** zTail);

/**
 *
 */
цел sqlite3_prepare16_v2 (sqlite3* бд, ук zSql, цел nBytes, sqlite3_stmt** инстр, ук* zTail);

/**
 *
 */
проц sqlite3_progress_handler (sqlite3* бд, цел n, цел function(ук) callback, ук arg);

/**
 *
 */
ук sqlite3_realloc (ук ptr, цел size);

/**
 *
 */
цел sqlite3_release_memory (цел n);

/**
 *
 */
цел sqlite3_reset (sqlite3_stmt* инстр);

/**
 *
 */
проц sqlite3_reset_auto_extension ();

/**
 *
 */
проц sqlite3_result_blob (sqlite3_context* context, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
проц sqlite3_result_double (sqlite3_context* context, дво значение);

/**
 *
 */
проц sqlite3_result_error (sqlite3_context* context, char* значение, цел n);

/**
 *
 */
проц sqlite3_result_error16 (sqlite3_context* context, ук значение, цел n);

/**
 *
 */
проц sqlite3_result_int (sqlite3_context* context, цел значение);

/**
 *
 */
проц sqlite3_result_int64 (sqlite3_context* context, дол значение);

/**
 *
 */
проц sqlite3_result_null (sqlite3_context* context);

/**
 *
 */
проц sqlite3_result_text (sqlite3_context* context, char* значение, цел n, проц function(ук) destructor);

/**
 *
 */
проц sqlite3_result_text16 (sqlite3_context* context, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
проц sqlite3_result_text16be (sqlite3_context* context, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
проц sqlite3_result_text16le (sqlite3_context* context, ук значение, цел n, проц function(ук) destructor);

/**
 *
 */
проц sqlite3_result_value (sqlite3_context* context, sqlite3_value* значение);

/**
 *
 */
ук sqlite3_rollback_hook (sqlite3* бд, проц function(ук) callback, ук args);

/**
 *
 */
цел sqlite3_set_authorizer (sqlite3* бд, цел function(ук, цел, char*, char*, char*, char*) xAuth, ук UserData);

/**
 *
 */
цел sqlite3_sleep (цел ms);

/**
 *
 */
проц sqlite3_soft_heap_limit (цел n);

/**
 *
 */
цел sqlite3_step (sqlite3_stmt* инстр);

/**
 *
 */
цел sqlite3_table_column_metadata (sqlite3* бд, char* zDbName, char* zТаблицаName, char* zColumnName, char** zDataType, char** zCollSeq, цел* неПусто, цел* первичныйКлюч, цел* autoInc);

/**
 *
 */
проц sqlite3_thread_cleanup ();

/**
 *
 */
цел sqlite3_total_changes (sqlite3* бд);

/**
 *
 */
ук sqlite3_trace (sqlite3* бд, проц function(ук, char*) xTrace, ук args);

/**
 *
 */
цел sqlite3_transfer_bindings (sqlite3_stmt* инстр, sqlite3_stmt* инстр);

/**
 *
 */
ук sqlite3_update_hook (sqlite3* бд, проц function(ук, цел, char*, char*, дол) callback, ук args);

/**
 *
 */
ук sqlite3_user_data (sqlite3_context* context);

/**
 *
 */
ук sqlite3_value_blob (sqlite3_value* значение);

/**
 *
 */
цел sqlite3_value_bytes (sqlite3_value* значение);

/**
 *
 */
цел sqlite3_value_bytes16 (sqlite3_value* значение);

/**
 *
 */
дво sqlite3_value_double (sqlite3_value* значение);

/**
 *
 */
цел sqlite3_value_int (sqlite3_value* значение);

/**
 *
 */
дол sqlite3_value_int64 (sqlite3_value* значение);

/**
 *
 */
char* sqlite3_value_text (sqlite3_value* значение);

/**
 *
 */
ук sqlite3_value_text16 (sqlite3_value* значение);

/**
 *
 */
ук sqlite3_value_text16be (sqlite3_value* значение);

/**
 *
 */
ук sqlite3_value_text16le (sqlite3_value* значение);

/**
 *
 */
цел sqlite3_value_type (sqlite3_value* значение);