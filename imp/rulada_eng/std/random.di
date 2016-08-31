// Written in the D programming language

/**
 * Macros:
 *	WIKI = Phobos/StdRandom
 */

// random.d
// www.digitalmars.com

module std.random;

/* ===================== Random ========================= */

// BUG: not multithreaded

private uint seed;		// starting seed
private uint index;		// ith random number
alias seed семя;
alias index индекс;
/**
 * При старте программы в генератор случайных чисел заносится случайное значение.
 Это гарантирует, что каждая программа сгененрирует разные последователоьности
 случайных чисел. Чтобы сгенерировать повторяемую последовательность,
нужно использовать rand_seed() в начале последовательности.
 seed и index дают ей старт, а каждое последующее значение наращивает индекс.
 This means that the $(I n)th random number of the sequence can be directly
 generated
 by passing index + $(I n) to rand_seed().

 Note: This is more random, but slower, than C's rand() function.
 To use C's rand() instead, import std.c.stdlib.
 */

void rand_seed(uint seed, uint index);
проц случсей(бцел семя, бцел индекс);
/**
 * Get the next random number in sequence.
 * BUGS: shares a global single state, not multithreaded
 */

uint rand();
бцел случайно();

uint randomGen(uint seed, uint index, real ncycles); 
бцел случген(бцел семя, бцел индекс, реал члоциклов);

static this();


