module std.string;
private import stdrus;

const char[16] hexdigits = "0123456789ABCDEF";			/// 0..9A..F
const char[10] digits    = "0123456789";			/// 0..9
const char[8]  octdigits = "01234567";				/// 0..7
const char[92] lowercase = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// a..z а..я
const char[92] uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";	/// A..Z А..Я
const char[184] letters   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			   "abcdefghijklmnopqrstuvwxyz" "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// A..Za..z

const char[6] whitespace = " \t\v\r\n\f";			/// ASCII whitespace

const dchar LS = '\u2028';	/// UTF line separator
const dchar PS = '\u2029';	/// UTF paragraph separator

/// Newline sequence for this system
version (Windows)
    const char[2] newline = "\r\n";
else version (Posix)
    const char[1] newline = "\n";

	alias stdrus.пробел_ли iswhite;
	alias stdrus.ткствцел atoi;
	alias stdrus.ткствдробь atof;
	alias stdrus.сравни cmp;
	alias stdrus.сравнлюб icmp;
	alias stdrus.вТкст0 toStringz;
	alias stdrus.найди find;
	alias stdrus.найдлюб ifind;
	alias stdrus.найдрек rfind;
	alias stdrus.найдлюбрек irfind;
	alias stdrus.впроп tolower;
	alias stdrus.взаг toupper;
	alias stdrus.озаг capitalize;
	alias stdrus.озагслова capwords;	
	alias stdrus.повтори repeat;
	alias stdrus.объедини join;
	alias stdrus.разбей split;
	alias stdrus.разбейдоп split;
	alias stdrus.разбейнастр splitlines;
	alias stdrus.уберислева stripl;
	alias stdrus.уберисправа stripr;
	alias stdrus.убери strip;
	alias stdrus.убериразгр chomp;
	alias stdrus.уберигран chop;
	alias stdrus.полев ljustify;
	alias stdrus.поправ rjustify;
	alias stdrus.вцентр center;
	alias stdrus.занули zfill;
	alias stdrus.замени replace;
	alias stdrus.заменисрез replaceSlice;
	alias stdrus.вставь insert;
	alias stdrus.счесть count;
	alias stdrus.заменитабнапбел expandtabs;
	alias stdrus.заменипбелнатаб entab;
	alias stdrus.постройтранстаб maketrans;
	alias stdrus.транслируй translate;		
	alias stdrus.посчитайсимв countchars;
	alias stdrus.удалисимв removechars;
	alias stdrus.сквиз squeeze;
	alias stdrus.следщ succ;	
	alias stdrus.тз tr;
	alias stdrus.чис_ли isNumeric;
	alias stdrus.колном column;
	alias stdrus.параграф wrap;
	alias stdrus.эладр_ли isEmail;
	alias stdrus.урл_ли isURL;
	alias stdrus.целВЮ8 intToUtf8;
	alias stdrus.бдолВЮ8 ulongToUtf8;
	alias stdrus.фм format;
	
/+
	
	struct Ткст
	{
	
	
	
	}
	
+/