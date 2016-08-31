/**
 * PostgreSQL import library.
 *
 * Part of the D DBI project.
 *
 * Version:
 *	PostgreSQL version 8.2.1
 *
 *	Import library version 1.04
 *
 * Authors: The D DBI project
 *
 * Copyright: BSD license
 */
module dbi.pg.imp;

private import cidrus;

version (Windows) {
	pragma (lib, "libpq.lib");
} else version (linux) {
	pragma (lib, "libpq.a");
} else version (Posix) {
	pragma (lib, "libpq.a");
} else version (darwin) {
	pragma (lib, "libpq.a");
} else {
	pragma (msg, "You will need to manually link in the PostgreSQL library.");
}

/**
 * This тип is used with PQprint because C doesn't have a _true булean тип.
 */
alias байт pqбул;

/**
 * Объект ID is a fundamental тип in PostgreSQL.
 */
typedef бцел Oid;

/**
 * InvalidOid indicates that something went wrong.  Try checking for errors.
 */
const Oid InvalidOid			= 0;

/**
 * Deprecated:
 *	Use Oid.max directly.
 */
deprecated const Oid OID_MAX		= Oid.max;

/**
 * This is the max length for system identifiers.  It must be a multiple of цел.sizeof.
 *
 * Databases with different NAMEDATALEN значения cannot interoperate!
 */
const бцел NAMEDATALEN			= 64;

/**
 * Identifiers of ошибка message поля.
 */
const char PG_DIAG_SEVERITY		= 'S';
const char PG_DIAG_SQLSTATE		= 'C';
const char PG_DIAG_MESSAGE_PRIMARY	= 'M';
const char PG_DIAG_MESSAGE_DETAIL	= 'D';
const char PG_DIAG_MESSAGE_HINT		= 'H';
const char PG_DIAG_STATEMENT_POSITION	= 'P';
const char PG_DIAG_INTERNAL_POSITION	= 'p';
const char PG_DIAG_INTERNAL_QUERY	= 'q';
const char PG_DIAG_CONTEXT		= 'W';
const char PG_DIAG_SOURCE_FILE		= 'F';
const char PG_DIAG_SOURCE_LINE		= 'L';
const char PG_DIAG_SOURCE_FUNCTION	= 'R';

/**
 * Read/write mode флаги for inversion (large object) calls.
 */
const бцел INV_WRITE			= 0x20000;
const бцел INV_READ			= 0x40000;


/**
 * Define the текст so all uses are consistent.
 */
const ткст PQnoPasswordSupplied	= "fe_sendauth: no пароль supplied\n";


/**
 * This is actually from std.c.stdio, but it is used with the large objects.
 */
enum {
	SEEK_SET,	/// Start seeking from the start.
	SEEK_CUR,	/// Start seeking from the current position.
	SEEK_END	/// Start seeking from the end.
}

/**
 * ConnStatusType is the structure that describes the current status of the
 * подключение to the server.
 */
enum ConnStatusType {
	/*
	 * Although it is okay to add to this list, значения which become unused
	 * should never be removed, nor should constants be redefined - that would
	 * break compatibility with existing code.
	 */
	CONNECTION_OK,			/// Everything is working.
	CONNECTION_BAD,			/// Error in the подключение.
	/* Non-blocking mode only below here. */

	/*
	 * The existence of these should never be relied upon - they should only
	 * be used for пользователь feedback or similar purposes.
	 */
	CONNECTION_STARTED,		/// Waiting for подключение to be made.
	CONNECTION_MADE,		/// Connection OK; waiting to send.
	CONNECTION_AWAITING_RESPONSE,	/// Waiting for a response from the postmaster.
	CONNECTION_AUTH_OK,		/// Received authentication; waiting for backend startup.
	CONNECTION_SETENV,		/// Negotiating environment.
	CONNECTION_SSL_STARTUP,		/// Negotiating SSL.
	CONNECTION_NEEDED		/// Internal state: подключись() needed.
}

/**
 * PostgresPollingStatusType is the structure that describes the current status of a non-blocking command.
 */
enum PostgresPollingStatusType {
	PGRES_POLLING_FAILED = 0,	/// Something went wrong.
	PGRES_POLLING_READING,		/// You may use select before polling again.
	PGRES_POLLING_WRITING,		/// You may use select before polling again.
	PGRES_POLLING_OK,		/// The work has been completed.
	PGRES_POLLING_ACTIVE		/// Unused; keep for awhile for backwards compatibility.
}

/**
 * ExecStatusType is the structure that describes the результаты.
 */
enum ExecStatusType {
	PGRES_EMPTY_QUERY = 0,		/// Empty запрос текст was выполниd.
	PGRES_COMMAND_OK,		/// A запрос command that doesn't return anything was выполниd properly by the backend.
	PGRES_TUPLES_OK,		/// A запрос command that returns tuples was выполниd properly by the backend, PGresult contains the результат tuples.
	PGRES_COPY_OUT,			/// Copy Out data transfer in progress.
	PGRES_COPY_IN,			/// Copy In data transfer in progress.
	PGRES_BAD_RESPONSE,		/// An unexpected response was received from the backend.
	PGRES_NONFATAL_ERROR,		/// Notice or warning message.
	PGRES_FATAL_ERROR		/// Query failed.
}

/**
 * PGTransactionStatusType is the structure that describes the current status of the transaction.
 */
enum PGTransactionStatusType {
	PQTRANS_IDLE,			/// Connection idle.
	PQTRANS_ACTIVE,			/// Command in progress.
	PQTRANS_INTRANS,		/// Idle, within transaction block.
	PQTRANS_INERROR,		/// Idle, within failed transaction.
	PQTRANS_UNKNOWN			/// Cannot determine status.
}

/**
 * PGVerbosity is the structure that describes how verbose ошибка message should be.
 */
enum PGVerbosity {
	PQERRORS_TERSE,			/// Single-line ошибка messages.
	PQERRORS_DEFAULT,		/// Recommended style.
	PQERRORS_VERBOSE		/// All the facts.
}

/**
 * PGconn encapsulates a подключение to the backend.
 *
 * The contents of this struct are not supposed to be known to applications.
 */
struct PGconn {
}

/**
 * PGresult encapsulates the результат of a запрос (or ещё precisely, of a single
 * SQL command --- a запрос текст given to PQsendQuery can contain multiple
 * commands and thus return multiple PGresult objects).
 *
 * The contents of this struct are not supposed to be known to applications.
 */
struct PGresult {
}

/**
 * PGcancel encapsulates the information needed to cancel a running
 * запрос on an existing подключение.
 *
 * The contents of this struct are not supposed to be known to applications.
 */
struct PGcancel {
}

/**
 * PGnotify represents the occurrence of a NOTIFY message.
 *
 * Ideally this would be an opaque typedef, but it's so simple that it's
 * unlikely to change.
 *
 * Note:
 *	In Postgres 6.4 and later, the be_pid is the notifying backend's,
 * whereas in earlier versions it was always your own backend's PID.
 */
struct pgNotify {
	char* relимя;			/// Notification condition имя.
	цел be_pid;			/// Process ID of notifying server process.
	char* extra;			/// Notification parameter.
	/* Fields below here are private to libpq; apps should not use 'em */
	pgNotify* следщ;			/// List link.
}
alias pgNotify PGnotify;

/**
 * Function types for notice-handling callbacks.
 */
alias проц function(ук arg, PGresult* рез) PQnoticeReceiver;
alias проц function(ук arg, char* message) PQnoticeProcessor;

/**
 * Print options for PQprint().
 */
struct _PQprintOpt {
	pqбул header;			/// Print output field headings and ряд счёт.
	pqбул alignment;		/// Fill align the поля.
	pqбул standard;		/// Old brain dead format.
	pqбул html3;			/// Output html таблицы.
	pqбул expanded;		/// Expand таблицы.
	pqбул pager;			/// Use pager for output if needed.
	char* fieldSep;			/// Field separator.
	char* tableOpt;			/// Insert a таблица in HTML.
	char* caption;			/// Insert a caption in HTML.
	char** fieldName;		/// Пусто terminated array of replacement field имяs.
}
alias _PQprintOpt PQprintOpt;

/**
 * Structure for the conninfo parameter definitions returned by PQconndefaults
 *
 * All поля except "val" point at static strings which must not be altered.
 * "val" is either NULL or a malloc'd current-значение текст.  PQconninfoFree()
 * will release both the val strings and the PQconninfoOption array itself.
 */
struct _PQconninfoOption {
	char* keyword;			/// The keyword of the option.
	char* envvar;			/// Fallback environment variable имя.
	char* compiled;			/// Fallback compiled in default значение.
	char* val;			/// Option's current значение, or пусто.
	char* label;			/// Label for field in подключись dialog.
	char* dispchar;			/// Character to display for this field in a подключись dialog. Values are: "" Display entered значение as is "*" Password field - hide значение "D"  Debug option - don't show by default.
	цел dispsize;			/// Field size in characters for dialog.
}
alias _PQconninfoOption PQconninfoOption;

/**
 * PQArgBlock is the structure used for PQfn arguments.
 *
 * Deprecated:
 *	This is only used for PQfn and that is deprecated.
 */
deprecated struct PQArgBlock {
	цел len;
	цел isint;
	union u {
		ук ptr;
		цел integer;
	}
}

extern (C):

/**
 * Make a new подключение to the бд server in a nonblocking manner.
 *
 * Params:
 *	conninfo = Parameters to use when подключисьing.
 *
 * Returns:
 *	A PostgreSQL подключение that is inactive.
 *
 * See_Also:
 *	The online PostgreSQL documentation describes what you can use in conninfo.
 */
PGconn* PQподключисьStart (char* conninfo);

/**
 * Get the current status of the nonblocking PostgreSQL подключение.
 *
 * Params:
 *	conn = The nonblocking PostgreSQL подключение.
 *
 * Returns:
 *	A PostgrePollingStatusType describing the current condition of the подключение.
 */
PostgresPollingStatusType PQподключисьPoll (PGconn* conn);

/**
 * Make a new подключение to the бд server in a blocking manner.
 *
 * Params:
 *	conninfo = Parameters to use when подключисьing.
 *
 * Returns:
 *	The PostgreSQL подключение.
 *
 * See_Also:
 *	The online PostgreSQL documentation describes what you can use in conninfo.
 */
PGconn* PQподключисьdb (char* conninfo);

/**
 * Make a new подключение to the бд server in a blocking manner.
 *
 * Deprecated:
 *	Although this isn't actually deprecated, it is preferred that you use PQподключисьdb.
 *
 * Params:
 *	pghost = Name of the host to подключись to.  Defaults to either a Unix socket or localhost.
 *	pgport = Port number to подключись to the server with.  Defaults to nothing.
 *	pgoptions = Command line options to send to the server.  Defaults to nothing.
 *	pgtty = Currently ignored.
 *	dbName = The имя of the бд to use.  Defaults to login.
 *	login = Userимя to authenticate with.  Defaults to the current OS имя_пользователя.
 *	pwd = Password to authenticate with.
 *
 * Returns:
 *	The PostgreSQL подключение.
 */
PGconn* PQустановиdbLogin (char* pghost, char* pgport, char* pgoptions, char* pgtty, char* dbName, char* login, char* pwd);

/**
 * Make a new подключение to the бд server in a blocking manner.
 *
 * Deprecated:
 *	This is deprecated in favor of PQустановиdbLogin, but PQподключисьdb is an even better choice.
 *
 * Params:
 *	pghost = Name of the host to подключись to.  Defaults to either a Unix socket or localhost.
 *	pgport = Port number to подключись to the server with.  Defaults to nothing.
 *	pgoptions = Command line options to send to the server.  Defaults to nothing.
 *	pgtty = Currently ignored.
 *	dbName = The имя of the бд to use.  Defaults to the login имя_пользователя.
 *
 * Returns:
 *	The PostgreSQL подключение.
 */
deprecated проц PQустановиdb (char* M_PGHOST, char* M_PGPORT, char* M_PGOPT, char* M_PGTTY, char* M_DBNAME) {
	PQустановиdbLogin(M_PGHOST, M_PGPORT, M_PGOPT, M_PGTTY, M_DBNAME, пусто, пусто);
}

/**
 * Close the PostgreSQL подключение and free the memory it used.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 */
проц PQфиниш (PGconn* conn);

/**
 * Get the default подключение options.
 *
 * Returns:
 *	A PQconninfoOption structure with all of the default значения filled in.
 */
PQconninfoOption* PQconndefaults ();

/**
 * Free the memory used by a PQconninfoOption structure.
 *
 * Params:
 *	connOptions = The PQconnifoOption structure to erase.
 */
проц PQconninfoFree (PQconninfoOption* connOptions);

/**
 * Reустанови the подключение to PostgreSQL in a nonblocking manner.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	1 on success and 0 on failure.
 */
цел PQresetStart (PGconn* conn);

/**
 * Get the current status of the nonblocking сбрось of the PostgreSQL подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	A PostgrePollingStatusType describing the current condition of the подключение.
 */
PostgresPollingStatusType PQresetPoll (PGconn* conn);

/**
 * Reустанови the подключение to PostgreSQL in a blocking manner.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 */
проц PQreset (PGconn* conn);

/**
 * Create the structure used to cancel commands.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The PGcancel structure on success or пусто on failure.
 */
PGcancel* PQgetCancel (PGconn* conn);

/**
 * Free the memory used by a PGcancel structure.
 *
 * Params:
 *	cancel = The PGcancel structure to erase.
 */
проц PQfreeCancel (PGcancel* cancel);

/**
 * Request that the server stops processing the current command.
 *
 * Params:
 *	cancel = The PGcancel structure returned by PQgetCancel.
 *	errbuf = A буфер to place the reason PQcancel failed in.
 *	errbufsize = The size of errbuf.  The recommended size is 256.
 *
 * Returns:
 *	1 on success and 0 on failure.
 */
цел PQcancel (PGcancel* cancel, char* errbuf, цел errbufsize);

/**
 * Request that the server stops processing the current command.
 *
 * Deprecated:
 *	PQcancel should be used instead because it is thread-safe.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 */
deprecated цел PQrequestCancel (PGconn* conn);

/**
 * Get the имя of the бд used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The бд имя.
 */
char* PQdb (PGconn* conn);

/**
 * Get the имя_пользователя used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The имя_пользователя.
 */
char* PQuser (PGconn* conn);

/**
 * Get the пароль used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The пароль.
 */
char* PQpass (PGconn* conn);

/**
 * Get the server host имя used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The server host имя.
 */
char* PQhost (PGconn* conn);

/**
 * Get the порт used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The порт.
 */
char* PQport (PGconn* conn);

/**
 * Deprecated:
 *	This no longer has any effect.  Don't use it.
 */
deprecated char* PQtty (PGconn* conn);

/**
 * Get the command line options used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The command line options.
 */
char* PQoptions (PGconn* conn);

/**
 * Get the status of the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	A ConnStatusType значение describing the current подключение.
 */
ConnStatusType PQstatus (PGconn* conn);

/**
 * Get the current in-transaction status of the server.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	A PGTransactionStatusType значение describing the status of the transaction.
 */
PGTransactionStatusType PQtransactionStatus (PGconn* conn);

/**
 * Get the current parameter установиtings of the server.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	A текст containing various parameter установиtings of the server.
 *
 * See_Also:
 *	The online PostgreSQL documentation describes what is in the returned текст.
 */
char* PQparameterStatus (PGconn* conn, char* paramName);

/**
 * Get the version of the protocol used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The protocol version.
 */
цел PQprotocolVersion (PGconn* conn);

/**
 * Get the version of PostgreSQL used by the server..
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The version of PostgreSQL.
 */
цел PQserverVersion (PGconn* conn);

/**
 * Get the most recent ошибка message from the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The most recent ошибка message.
 */
char* PQerrorMessage (PGconn* conn);

/**
 * Get the socket used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The number that represents the socket.  A negative number is returned if no подключение is open.
 */
цел PQsocket (PGconn* conn);

/**
 * Get the PID of PostgreSQL on the server..
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The PID.
 */
цел PQbackendPID (PGconn* conn);

/**
 * Get the character encoding currently being used.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The integer representation of the character encoding.
 */
цел PQclientEncoding (PGconn* conn);

/**
 * Change the character encoding used in the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	encoding = The текст representation of the desired character _encoding.
 *
 * Returns:
 *	0 on success and -1 on failure.
 */
цел PQустановиClientEncoding (PGconn* conn, char* encoding);

/**
 * Get the OpenSSL structure associated with a подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The SSL structure used in the подключение or пусто if SSL is not in use.
 */
ук PQgetssl (PGconn* conn);

/**
 * Tell the interface that SSL has already been initialized within your application.
 *
 * Params:
 *	do_init = Set to 1 if you use SSL within your application and 0 otherwise.
 */
проц PQinitSSL (цел do_init);

/**
 * Set how verbose the ошибка messages should be.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	verbosity = A PGVerbosity значение of the desired установиting.
 *
 * Returns:
 *	A PGVerbosity значение with the previous установиting.
 */
PGVerbosity PQустановиErrorVerbosity (PGconn* conn, PGVerbosity verbosity);

/**
 * Start copying all of the communications with the server to a stream.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	debug_port = The CStream to send the data to.
 */
проц PQtrace (PGconn* conn, FILE* debug_port);

/**
 * Stop copying all of the communications with the server to a stream.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 */
проц PQuntrace (PGconn* conn);

/**
 * Change the function that formats the notices.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	proc = The new function.
 *	arg = Arguments to pass to the function whenever it is called.
 *
 * Returns:
 *	The previous function.
 */
PQnoticeReceiver PQустановиNoticeReceiver (PGconn* conn, PQnoticeReceiver proc, ук arg);

/**
 * Change the function that handles the notices.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	proc = The new function.
 *	arg = Arguments to pass to the function whenever it is called.
 *
 * Returns:
 *	The previous function.
 */
PQnoticeProcessor PQустановиNoticeProcessor (PGconn* conn, PQnoticeProcessor proc, ук arg);

/**
 * Used to установи callback that prevents concurrent access to
 * non-thread safe functions that libpq needs.
 * The default implementation uses a libpq internal mutex.
 * Only required for multithreaded apps that use kerberos
 * both within their app and for postgresql подключисьions.
 */
alias проц function(цел acquire) pgthreadlock_t;

/**
 *
 */
pgthreadlock_t PQregisterThreadLock (pgthreadlock_t newhandler);

/**
 * Submit a command to the server and wait for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	запрос = The SQL command(s) to выполни.
 *
 * Результатs:
 *	A PGresult structure containing the результаты or пусто on a serious ошибка.
 */
PGresult* PQexec (PGconn* conn, char* запрос);

/**
 * Submit a command to the server and wait for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	command = The SQL _command to выполни.
 *	nParams = The number of parameters.
 *	типыПарамов = An array of types specified using Oid.  Use пусто or 0 to have the server guess.
 *	paramValues = The parameters themselves in the expected format.
 *	paramLengths = An array of lengths of the parameters.  This is ignored for non-бинар data.
 *	paramFormats = An array of formats of the parameters.  Use 0 for text and 1 for бинар.
 *	resultFormat = Use 0 to obtain the результаты in text format and 1 for бинар.
 *
 * Returns:
 *	A PGresult structure containing the результаты or пусто on a serious ошибка.
 */
PGresult* PQexecParams (PGconn* conn, char* command, цел nParams, Oid* типыПарамов, char** paramValues, цел* paramLengths, цел* paramFormats, цел resultFormat);

/**
 * Create a подготовьd statement and wait for completion.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	stmtName = The имя to assign to the подготовьd statement.
 *	запрос = The SQL command to подготовь.
 *	nParams = The number of parameters.
 *	типыПарамов = An array of types specified using Oid.  Use пусто or 0 to have the server guess.
 *
 * Результатs:
 *	A PGresult structure containing the результаты or пусто on a serious ошибка.
 */
PGresult* PQподготовь (PGconn* conn, char* stmtName, char* запрос, цел nParams, Oid* типыПарамов);

/**
 * Execute a подготовьd statement and wait for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	stmtName = The имя of the подготовьd statement to выполни.
 *	nParams = The number of parameters.
 *	paramValues = The parameters themselves in the expected format.
 *	paramLengths = An array of lengths of the parameters.  This is ignored for non-бинар data.
 *	paramFormats = An array of formats of the parameters.  Use 0 for text and 1 for бинар.
 *	resultFormat = Use 0 to obtain the результаты in text format and 1 for бинар.
 *
 * Результатs:
 *	A PGresult structure containing the результаты or пусто on a serious ошибка.
 */
PGresult* PQexecPrepared (PGconn* conn, char* stmtName, цел nParams, char** paramValues, цел* paramLengths, цел* paramFormats, цел resultFormat);

/**
 * Submit a command to the server without waiting for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	запрос = The SQL command(s) to выполни.
 *
 * Returns:
 *	1 on success or 0 on failure.
 */
цел PQsendQuery (PGconn* conn, char* запрос);

/**
 * Submit a _command to the server without waiting for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	command = The SQL _command to выполни.
 *	nParams = The number of parameters.
 *	типыПарамов = An array of types specified using Oid.  Use пусто or 0 to have the server guess.
 *	paramValues = The parameters themselves in the expected format.
 *	paramLengths = An array of lengths of the parameters.  This is ignored for non-бинар data.
 *	paramFormats = An array of formats of the parameters.  Use 0 for text and 1 for бинар.
 *	resultFormat = Use 0 to obtain the результаты in text format and 1 for бинар.
 *
 * Returns:
 *	1 on success or 0 on failure.
 */
цел PQsendQueryParams (PGconn* conn, char* command, цел nParams, Oid* типыПарамов, char** paramValues, цел* paramLengths, цел* paramFormats, цел resultFormat);

/**
 * Create a подготовьd statement without waiting for completion.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	stmtName = The имя to assign to the подготовьd statement.
 *	запрос = The SQL command to подготовь.
 *	nParams = The number of parameters.
 *	типыПарамов = An array of types specified using Oid.  Use пусто or 0 to have the server guess.
 *
 * Returns:
 *	1 on success or 0 on failure.
 */
цел PQsendPrepare (PGconn* conn, char* stmtName, char* запрос, цел nParams, Oid* типыПарамов);

/**
 * Execute a подготовьd statement without waiting for the результаты.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	stmtName = The имя of the подготовьd statement to выполни.
 *	nParams = The number of parameters.
 *	paramValues = The parameters themselves in the expected format.
 *	paramLengths = An array of lengths of the parameters.  This is ignored for non-бинар data.
 *	paramFormats = An array of formats of the parameters.  Use 0 for text and 1 for бинар.
 *	resultFormat = Use 0 to obtain the результаты in text format and 1 for бинар.
 *
 * Returns:
 *	1 on success or 0 on failure.
 */
цел PQsendQueryPrepared (PGconn* conn, char* stmtName, цел nParams, char** paramValues, цел* paramLengths, цел* paramFormats, цел resultFormat);

/**
 * Get the current результат установи.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	A PGresult structure describing the current status or пусто if no command is being processed.
 */
PGresult* PQgetРезультат (PGconn* conn);

/**
 * Determine if the server is currently busy with a command.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	1 if a command is busy and 0 if it is safe to call PQgetРезультат.
 */
цел PQisBusy (PGconn* conn);

/**
 * Get any input from the server.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	1 on success and 0 on failure.
 */
цел PQconsumeInput (PGconn* conn);

/**
 * Get the следщ unhandled notification event.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	The PGnotify structure representing the notification event.
 */
PGnotify* PQnotifies (PGconn* conn);

/**
 * Send data to the server after a copy command.
 *
 * This function will only be unable to send the data if nonblocking is установи.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	буфер = The data to send to the server.
 *	nbytes = The length of буфер.
 *
 * Returns:
 *	1 on success, -1 on failure, or 0 if the data wasn't sent.
 */
цел PQputCopyData (PGconn* conn, char* буфер, цел nbytes);

/**
 * Tell the server that no ещё data needs to be copied.
 *
 * This function will only be unable to send the data if nonblocking is установи.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	errormsg = пусто on success and the ошибка message on failure.
 *
 * Returns:
 *	1 on success, -1 on failure, or 0 if the data wasn't sent.
 */
цел PQputCopyEnd (PGconn* conn, char* errormsg);

/**
 * Get the data from the server after a copy command.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	буфер = A pointer to the _buffer.  The memory will be allocated by PostgreSQL.
 *	async = Use 0 for nonblocking and any other number for blocking.
 *
 * Returns:
 *	-1 on success, -2 on failure, or 0 if the command is still in progress.
 */
цел PQgetCopyData (PGconn* conn, char** буфер, цел async);

/**
 * Deprecated:
 *	These functions have poor ошибка handling, nonblocking transfers, бинар data,
 *	or easy end of data detection.  Use PQputCopyData, PQputCopyEnd, and PQgetCopyData instead.
 */
deprecated цел PQgetline (PGconn* conn, char* текст, цел length);
deprecated цел PQputline (PGconn* conn, char* текст); /// ditto
deprecated цел PQgetlineAsync (PGconn* conn, char* буфер, цел bufsize); /// ditto
deprecated цел PQputnbytes (PGconn* conn, char* буфер, цел nbytes); /// ditto
deprecated цел PQendcopy (PGconn* conn); /// ditto

/**
 * Set the nonblocking status of the подключение.
 *
 * PQexec will ignore this установиting.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	arg = 1 for nonblocking and 0 for blocking.
 *
 * Returns:
 *	0 on success and -1 on failure.
 */
цел PQустановиnonblocking (PGconn* conn, цел arg);

/**
 * Get the current nonblocking status of the подключение.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	1 if the подключение is nonblocking and 0 if it is blocking.
 */
цел PQisnonblocking (PGconn* conn);

/**
 * todo
 */
цел PQisthreadsafe ();

/**
 * Attempt to send all queries to the server immediately.
 *
 * This function will only be unable to send the data if nonblocking is установи.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *
 * Returns:
 *	0 on success, -1 on failure, or 1 if not all of the data was sent.
 */
цел PQflush (PGconn* conn);

/**
 * Send a simple command to the запрос very quickly.
 *
 * Deprecated:
 *	Prepared functions are just as fast and ещё powerful.  Use them instead.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fnid = The Oid of the function to выполни.
 *	result_buf = The буфер the return значение will be placed in.
 *	result_len = The length of result_buf.
 *	result_is_int = This is 1 if an integer of 4 bytes or less is to be returned.  Use 0 otherwise.
 *	args = An array of PQArgBlock structures.
 *	nargs = The length of args.
 *
 * Returns:
 *	A PGresult structure describing the current status.
 */
deprecated PGresult* PQfn (PGconn* conn, цел fnid, цел* result_buf, цел* result_len, цел result_is_int, PQArgBlock* args, цел nargs) ;

/**
 * Get the результат status of a command.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	An ExecStatusType значение describing the результат status.
 */
ExecStatusType PQresultStatus (PGresult* рез);

/**
 * Get the текст representing an ExecStatusType значение.
 *
 * Params:
 *	status = The ExecStatusType значение.
 *
 * Returns:
 *	The representative текст.
 */
char* PQresStatus (ExecStatusType status);

/**
 * Get the ошибка message associated with a command.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The текст form of the ошибка if there is one or an empty текст otherwise.
 */
char* PQresultErrorMessage (PGresult* рез);

/**
 * Get an individual field of an ошибка report.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	fieldcode = The ошибка filed to return.  Accepted значения start with PG_DIAG_
 *
 * Returns:
 *	The текст form of the ошибка if there is one or пусто otherwise.
 *
 * See_Also:
 *	The online PostgreSQL documentation describes what you can use in fieldcode.
 */
char* PQresultErrorField (PGresult* рез, char fieldcode);

/**
 * Get the number of tuples in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The number of tuples.
 */
цел PQntuples (PGresult* рез);

/**
 * Get the number of поля in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The number of поля.
 */
цел PQnfields (PGresult* рез);

/**
 * Get whether a запрос результат contains бинар data or not.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	1 if the результат установи contains бинар data and 0 otherwise.
 */
цел PQbinaryTuples (PGresult* рез);

/**
 * Get the column имя associated with a column number in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The имя of the column if it есть or пусто otherwise.
 */
char* PQfимя (PGresult* рез, цел field_num);

/**
 * Get the column number associated with a column имя in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_имя = The имя of the column.
 *
 * Returns:
 *	The number of the column if it есть or -1 otherwise.
 */
цел PQfnumber (PGresult* рез, char* field_имя);

/**
 * Get the Oid of the таблица from which a column in a запрос результат was fetched.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The Oid of the таблица if it есть or InvalidOid otherwise.
 */
Oid PQftable (PGresult* рез, цел field_num);

/**
 * Get the number of a column in its таблица from its number in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column within the запрос результат.
 *
 * Returns:
 *	The column number if it есть or 0 otherwise.
 */
цел PQftablecol (PGresult* рез, цел field_num);

/**
 * Get the format code of a column in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	0 if the format is text and 1 if it is бинар.
 */
цел PQfformat (PGresult* рез, цел field_num);

/**
 * Get the data тип of a column in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The Oid representing the data тип.
 */
Oid PQftype (PGresult* рез, цел field_num);

/**
 * Get the number of bytes4/17/2006 in a column in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The number of bytes.
 */
цел PQfsize (PGresult* рез, цел field_num);

/**
 * Get the тип modifier of a column in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The тип modifier if it есть or -1 otherwise.
 */
цел PQfmod (PGresult* рез, цел field_num);

/**
 * Get the command status tag from a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The command status tag.
 */
char* PQcmdStatus (PGresult* рез);

/**
 * Get the Oid in текст format of a действителен insert in a запрос результат.
 *
 * Deprecated:
 *	Use PQoidValue instead.  It is thread-safe.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The Oid if it есть and is действителен. "0" or "" is returned otherwise.
 */
deprecated char* PQoidStatus (PGresult* рез);

/**
 * Get the Oid of a действителен insert in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The Oid if it есть and is действителен or InvalidOid if it isn't.
 */
Oid PQoidValue (PGresult* рез);

/**
 * Get the number of tuples affected by a запрос.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *
 * Returns:
 *	The number of affected tuples.
 */
char* PQcmdTuples (PGresult* рез);

/**
 * Get the значение of a single field in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	tup_num = The number of the ряд.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The значение of the field.
 */
char* PQgetvalue (PGresult* рез, цел tup_num, цел field_num);

/**
 * Get the number of bytes in the length of a single field in a запрос результат.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	tup_num = The number of the ряд.
 *	field_num = The number of the column.
 *
 * Returns:
 *	The number of bytes in the length of the field.
 */
цел PQgetlength (PGresult* рез, цел tup_num, цел field_num);

/**
 * Get whether or not a single field in a запрос результат is пусто.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	tup_num = The number of the ряд.
 *	field_num = The number of the column.
 *
 * Returns:
 *	1 if it is пусто or 0 otherwise.
 */
цел PQgetisпусто (PGresult* рез, цел tup_num, цел field_num);

/**
 * todo
 */
цел PQnпарамы (PGresult* рез);

/**
 * todo
 */
Oid PQparamtype (PGresult* рез, цел param_num);

/**
 * todo
 */
PGresult* PQdescribePrepared (PGconn* conn, char* инстр);

/**
 * todo
 */
PGresult* PQdescribePortal (PGconn* conn, char* portal);

/**
 * todo
 */
цел PQsendDescribePrepared (PGconn* conn, char* инстр);

/**
 * todo
 */
цел PQsendDescribePortal (PGconn* conn, char* portal);

/**
 * Free all memory associated with a результат.  This includes all returned strings.
 *
 * Params:
 *	рез = The PGresult structure to erase.
 */
проц PQclear (PGresult* рез);

/**
 * Free memory allocated by the the interface library.
 *
 * This is necessary only on Windows.  Users of other operating systems can simply use free.
 *
 * Params:
 *	ptr = A pointer to the memory to free.
 */
проц PQfreemem (ук ptr);

/**
 * Deprecated:
 *	Use PQfreemem or free directly.
 */
deprecated alias PQfreemem PQfreeNotify;

/**
 * Make an empty PGresult structure with a given _status.
 *
 * Note that anything from the PostgreSQL подключение will be added in.
 *
 * Params:
 *	conn = The PostgreSQL подключение.  This can be пусто.
 *	status = The ошибка message to add to the PGresult structure.
 *
 * Returns:
 *	The created PGresult structure.
 */
PGresult* PQmakeEmptyPGresult (PGconn* conn, ExecStatusType status);

/**
 * Escape a текст for use within a SQL command.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	to = The буфер the результаты will be put in.  Must be at least 2 * length + 1 chars дол.
 *	from = The текст _to convert.
 *	length = The number of chars _to искейп.  The terminating 0 should not be included.
 *	ошибка = 0 on success and nonzero on failure.  Can be пусто.
 *
 * Returns:
 *	The number of characters in to.  This doesn't include the terminating 0.
 */
т_мера PQescapeStringConn (PGconn* conn, char* to, char* from, т_мера length, цел* ошибка);

/**
 * Escape бинар data for use within a SQL command.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	from = A pointer to the first байт to искейп.
 *	from_length = The number of bytes to искейп.  The terminating 0 should not be included.
 *	to_length = A pointer to a variable that will hold the length of the escaped текст.
 *
 * Returns:
 *	The escaped version of bintext on success and пусто on failure.
 */
char* PQescapeByteaConn (PGconn* conn, ббайт* from, т_мера from_length, т_мера* to_length);

/**
 * Escape a текст for use within a SQL command.
 *
 * Deprecated:
 *	Replaced by PQescapeStringConn in PostgreSQL 8.1.4.
 *
 * Params:
 *	to = The буфер the результаты will be put in.  Must be at least 2 * length + 1 chars дол.
 *	from = The текст _to convert.
 *	length = The number of chars _to искейп.  The terminating 0 should not be included.
 *
 * Returns:
 *	The number of characters in to.
 */
deprecated т_мера PQescapeString (char* to, char* from, т_мера length);

/**
 * Escape бинар data for use within a SQL command.
 *
 * Deprecated:
 *	Replaced by PQescapeByteaConn in PostgreSQL 8.1.4.
 *
 * Params:
 *	bintext = A pointer to the first байт to искейп.
 *	binlen = The number of bytes to искейп.  The terminating 0 should not be included.
 *	bytealen = A pointer to a variable that will hold the length of the escaped текст.
 *
 * Returns:
 *	The escaped version of bintext.
 */
deprecated char* PQescapeBytea (ббайт* bintext, т_мера binlen, т_мера* bytealen);

/**
 * Unescape бинар data.
 *
 * Params:
 *	strtext = The escaped бинар data.
 *	retbuflen = A pointer to a variable that will hold the length of the escaped текст.
 *
 * Returns:
 *	The unescaped version of strtext.
 */
ббайт* PQunescapeBytea (char* strtext, т_мера* retbuflen);

/**
 * Print all of the ряды to a stream.
 *
 * Params:
 *	fout = The CStream to output the information to.
 *	рез = The PGresult structure returned by the server.
 *	ps = A PQprintOpt structure containing your printing options.
 */
проц PQprint (FILE* fout, PGresult* рез, PQprintOpt* ps);

/**
 * Print all of the ряды to a stream.
 *
 * Deprecated:
 *	Use PQprint instead.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	fp = The CStream to output the information to.
 *	fillAlign = Space fill to align columns.
 *	fieldSep = The character to use as a field seperator.
 *	printHeader = Use 1 to display headers and 0 not to.
 *	quiet = Use 0 to show ряд счёт at the end and 1 not to.
 */
deprecated проц PQdisplayTuples (PGresult* рез, FILE* fp, цел fillAlign, char* fieldSep, цел printHeader, цел quiet);

/**
 * Print all of the ряды to a stream.
 *
 * Deprecated:
 *	Use PQprint instead.
 *
 * Params:
 *	рез = The PGresult structure returned by the server.
 *	fout = The CStream to output the information to.
 *	printAttName = Use 1 to print attribute имяs and 0 not to.
 *	terseOutput = Use 1 to show delimiter bars and 0 not to.
 *	width = The _width of the columns.  Use 0 for variable _width.
 */
deprecated проц PQprintTuples (PGresult* рез, FILE* fout, цел printAttName, цел terseOutput, цел width);

/**
 * Open an existing large object.
 *
 * Params:
 *	conn = PostgreSQL подключение.
 *	lobjId = Oid of the large object to open.
 *	mode = Whether to make it readonly or not.  Uses INV_READ and INV_WRITE.
 *
 * Returns:
 *	An integer for use with other large object functions on success or -1 on failure.
 */
цел lo_open (PGconn* conn, Oid lobjId, цел mode);

/**
 * Close an opened large object.
 *
 * This is done automatically to any large objects that are open at the end of a transaction.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fd = The integer returned when the large object was opened.
 *
 * Returns:
 *	0 on success or -1 on failure.
 */
цел lo_закрой (PGconn* conn, цел fd);

/**
 * Read from an open large object.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fd = The integer returned when the large object was opened;
 *	buf = The буфер that that data will be written to.
 *	len = The number of bytes to copy to buf.
 *
 * Returns:
 *	The number of bytes read on success or a negative number on failure.
 */
цел lo_read (PGconn* conn, цел fd, байт* buf, т_мера len);

/**
 * Writes to an open large object.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fd = The integer returned when the large object was opened.
 *	buf = The буфер that the data will be read from.
 *	len = The number of bytes to copy from buf.
 *
 * Returns:
 *	The number of bytes read on success or a negative number on failure.
 */
цел lo_write (PGconn* conn, цел fd, байт* buf, т_мера len);

/**
 * Change the location of reading and writing in an open large object.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fd = The integer returned when the large object was opened.
 *	offустанови = How far to move.
 *	whence = Where to start counting.  Uses SEEK_SET, SEEK_CUR, and SEEK_END.
 *
 * Returns:
 *	The new location pointer on success or -1 on failure.
 */
цел lo_lseek (PGconn* conn, цел fd, цел offустанови, цел whence);

/**
 * Create a new large object.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	mode = Ignored as of PostgreSQL version 8.1.
 *
 * Returns:
 *	The Oid of the large object on success or InvalidOid on failure.
 */
Oid lo_creat (PGconn* conn, цел mode);

/**
 * Create a new large object.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	lobjId = Requested Oid to assign the large object to.
 *
 * Returns:
 *	The Oid of the large object or InvalidOid on failure.
 */
Oid lo_create (PGconn* conn, Oid lobjId);

/**
 * Get the location pointer of an open large object.
 *
 * Params:
 *	conn =  The PostgreSQL подключение.
 *	fd = The integer returned when the large object was opened.
 *
 * Returns:
 *	The location pointer or a negative number on failure.
 */
цел lo_tell (PGconn* conn, цел fd);

/**
 * Remove a large object from the бд.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	lobjOid = the Oid of the large object to remove.
 *
 * Returns:
 *	1 on success or -1 on failure.
 */
цел lo_unlink (PGconn* conn, Oid lobjId);

/**
 * Load a large object from a file.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	fileимя = Name of the file to load.
 *
 * Returns:
 *	The Oid of the large object or InvalidOid on failure.
 */
Oid lo_import (PGconn* conn, char* fileимя);

/**
 * Save a large object to a file.
 *
 * Params:
 *	conn = The PostgreSQL подключение.
 *	lobjOid = Oid of the large object to save.
 *	fileимя = Name of the file to save to.
 *
 * Returns:
 *	1 on success or -1 on failure.
 */
цел lo_export (PGconn* conn, Oid lobjId, char* fileимя);

/**
 * todo
 */
цел PQmblen (char* s, цел encoding);

/**
 * todo
 */
цел PQdsplen (char* s, цел encoding);

/**
 * todo
 */
цел PQenv2encoding ();

/**
 * todo
 */
char* PQencryptPassword (char* passwd, char* пользователь);