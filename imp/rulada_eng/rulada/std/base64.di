/**
 * Кодирует/раскодирует данные MIME base64.
 *
 * Макросы:
 *	WIKI=Phobos/StdBase64
 * Ссылки:
 *	<a href="http://en.wikipedia.org/wiki/Base64">Wikipedia Base64</a>$(BR)
 *	<a href="http://en.wikipedia.org/wiki/Base64">Wikipedia Base64</a>$(BR)
 */


/* base64.d
 * Modified from C. Miller's version, his copyright is below.
 */

/*
	Авторское Право (C) 2004 Кристофер Е. Миллер
	
	Данное программное обеспечение предоставляется «как есть», без всякой 
	гарантии.  Ни в коей мере автор не несет никакой ответственности за ущерб,
	возникающий от использования данного программного обеспечения.
	
	Всякому дается разрешение на использование этого ПО в любых целях,
	Включая коммерческие приложения, а также изменять его и перепродавать
	свободно, за исключением лишь следующих ограничений:
	
	1. Нельзя скрывать или неправильно представлять источник данного ПО; не следует
	   утверждать, что вами написаны оригиналы. Если вы пользуетесь данным ПО
	   в каком-то продукте, признательность в его документации будет оценена, но не является обязательной.
	   
	2. Измененые версии исходников должны иметь явное указание на это, и не должны
	   выдаваться за оригинальное программное обеспечение.
	3. Эту заметку не следует удалять или изменять ни в какой поставке ПО.
*/



module std.base64;


/**
 */

class Base64Exception: Exception
{
	this(char[] msg);
}
alias Base64Exception ИсклОснования64;

/**
 */

class Base64CharException: Base64Exception
{
	this(char[] msg);
}
alias Base64CharException ИсклСимОснования64;

const char[] array = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя0123456789+/";


/**
 * Returns the number of bytes needed to encode a string of length slen.
 */

uint encodeLength(uint slen);
бцел кодируйДлину(бцел сдлин);
/**
 * Encodes str[] and places the result in buf[].
 * Params:
 *	str = string to encode
 * 	buf = destination buffer, must be large enough for the result.
 * Returns:
 *	slice into buf[] representing encoded result
 */

char[] encode(char[] str, char[] buf);		
ткст кодируй(ткст стр, ткст буф);

/**
 * Encodes str[] and returns the result.
 */

char[] encode(char[] str);
ткст кодируй (ткст стр);

/**
 * Returns the number of bytes needed to decode an encoded string of this
 * length.
 */
uint decodeLength(uint elen);
бцел раскодируйДлину(бцел кдлин);


/**
 * Decodes str[] and places the result in buf[].
 * Params:
 *	str = string to encode
 * 	buf = destination buffer, must be large enough for the result.
 * Returns:
 *	slice into buf[] representing encoded result
 * Errors:
 *	Throws Base64Exception on invalid base64 encoding in estr[].
 *	Throws Base64CharException on invalid base64 character in estr[].
 */
char[] decode(char[] estr, char[] buf);
ткст раскодируй(ткст кстр, ткст буф);

/**
 * Decodes estr[] and returns the result.
 * Errors:
 *	Throws Base64Exception on invalid base64 encoding in estr[].
 *	Throws Base64CharException on invalid base64 character in estr[].
 */
char[] decode(char[] estr);
ткст раскодируй(ткст кстр);
