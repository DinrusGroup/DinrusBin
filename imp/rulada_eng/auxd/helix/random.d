/*
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
module auxd.helix.random;

private import auxd.helix.basic;

struct Rand48Engine
{
	const static uint min = 0;
	const static uint max = uint.max;

	/**
	Generates next pseudo-random number.
	Возвращает:
		Pseudo-random number in closed interval [this.min; this.max]
	*/
	uint pop()
	{
		x = (a * x + b) & mask;
		return x >> 16;
	}

	/**
	Reinitializes engine. Sets new _seed used for pseudo-random number generation.

	If two different linear congruential engines are initialized with the same
	_seed they will generate equivalent pseudo-number sequences.
	Params:
		nx = New _seed used for pseudo-random numbers generation.
	*/
	void seed(ulong nx)
	{
		x = nx & mask;
	}
	
	private:
		static const ulong a = 25214903917;
		static const ulong b = 1L;
		static const ulong m = 1uL << 48;
		static const ulong mask = m - 1;
		ulong x = 0;
}

unittest
{
	Rand48Engine e1;
	e1.seed = 12345;
	for (int i = 0; i < 100; ++i)
		e1.pop();
	
	Rand48Engine e2 = e1;

	// must generate the same sequence
	for (int i = 0; i < 100; ++i)
		assert(e1.pop() == e2.pop());

	e1.seed = 54321;
	e2.seed = 54321;

	// must generate the same sequence
	for (int i = 0; i < 100; ++i)
		assert(e1.pop() == e2.pop());
}

/*********************************************************************/
struct MersenneTwisterEngine
{
	static const uint min = 0;
	static const uint max = uint.max;

	static const uint n = 624;
	static const uint m = 397;

	uint pop()
	{
		if (next >= n) // overflow, engine reload needed
		{
			uint twist(uint m, uint u, uint v)
			{
				return m ^ (((u & 0x8000_0000u) | (v & 0x7fff_ffffu)) >> 1) ^
					(-(u & 0x1u) & 0x9908_b0dfu);
			}

			uint* p = s.ptr;
			
			for (int i = n - m; i--; ++p)
				*p = twist( p[m], p[0], p[1] );

			for (int i = m; --i; ++p)
				*p = twist( p[m - n], p[0], p[1] );

			*p = twist( p[m - n], p[0], s[0] );

			next = 0;
		}

		// use 'state.ptr[next]' instead of 'state[next]' to
		// suppress array bound checks, namely performance penalty
		uint x = s.ptr[next];
		++next;

		x ^= (x >> 11);
		x ^= (x <<  7) & 0x9d2c_5680u;
		x ^= (x << 15) & 0xefc6_0000u;
		return x ^ (x >> 18);
	}

	void seed(uint x)
	{
		s[0] = x;
		for (int i = 1; i < n; ++i)
			s[i] = 1_812_433_253u * (s[i-1] ^ (s[i-1] >> 30)) + i;

		next = 1;
	}

	private:
		uint[n] s = void;
		uint next = 0;		
}

unittest
{
	MersenneTwisterEngine e1;
	e1.seed = 12345;
	for (int i = 0; i < 100; ++i)
		e1.pop();
	
	MersenneTwisterEngine e2 = e1;

	// must generate the same sequence
	for (int i = 0; i < 100; ++i)
		assert(e1.pop() == e2.pop());

	e1.seed = 54321;
	e2.seed = 54321;

	// must generate the same sequence
	for (int i = 0; i < 100; ++i)
		assert(e1.pop() == e2.pop());
}

/********************************************************************/
struct UnitUniformEngine(BaseEngine, bool closedLeft, bool closedRight)
{
	private BaseEngine baseEngine;

	const static
	{
		real min = (closedLeft ? 0 : increment) * (1/denominator);
		real max = (range + (closedLeft ? 0 : increment)) * (1/denominator);
	}

	private const static
	{
		real range = cast(real)(baseEngine.max - baseEngine.min);
		real increment = (baseEngine.max > uint.max) ? 2.L : 0.2L;
		real denominator = range + (closedLeft ? 0 : increment) + (closedRight ? 0 : increment);
	}

	real pop()
	{
		auto x = baseEngine.pop();
		
		static if (
			is (typeof(baseEngine.pop) : real) && // base engine pops float-type values
			cast(real)baseEngine.min == this.min &&
			cast(real)baseEngine.max == this.max)
		{
			// no manipulations required, return value as is.
			return cast(real)x;
		}
		else
		{
			return (cast(real)(x - baseEngine.min) + (closedLeft ? 0 : increment)) * (1/denominator);
		}
	}

	void seed(uint x)
	{
		baseEngine.seed = x;
	}
}

unittest
{
	alias UnitUniformEngine!(Rand48Engine, true, true) fullClosed;
	alias UnitUniformEngine!(Rand48Engine, true, false) closedLeft;
	alias UnitUniformEngine!(Rand48Engine, false, true) closedRight;
	alias UnitUniformEngine!(Rand48Engine, false, false) fullOpened;

	static assert(fullClosed.min == 0.L);
	static assert(fullClosed.max == 1.L);

	static assert(closedLeft.min == 0.L);
	static assert(closedLeft.max < 1.L);
	
	static assert(closedRight.min > 0.L);
	static assert(closedRight.max == 1.L);

	static assert(fullOpened.min > 0.L);
	static assert(fullOpened.max < 1.L);
}

/********************************************************************/
struct HighresUnitUniformEngine(BaseEngine, bool closedLeft, bool closedRight)
{
	private BaseEngine baseEngine;

	static const
	{
		real min = (closedLeft ? 0 : increment) * (1 / denominator);
		real max = (rawMax + (closedLeft ? 0 : increment)) * (1 / denominator);
	}

	private const static
	{
		real rawMax = uint.max * 0x1p32 + uint.max;
		real increment = 2.L;
		real denominator = rawMax + (closedLeft ? 0 : increment) + (closedRight ? 0 : increment);
	}

	real pop()
	{
		static if (
			is (typeof(baseEngine.pop) : real) && // base engine pops float-type values
			cast(real)baseEngine.min == this.min &&
			cast(real)baseEngine.max == this.max)
		{
			// no manipulations required, return value as is.
			return cast(real)baseEngine.pop();
		}
		else
		{
			// this is necessary condition to generate truly uniform
			// result. However it is possible to use base engine with any range,
			// but this feature isn't implemented for now and can be introduced
			// in future.
			static assert( baseEngine.min == 0 && baseEngine.max == uint.max );

			uint a = cast(uint)baseEngine.pop();
			uint b = cast(uint)baseEngine.pop();
			return (a * 0x1p32 + b + (closedLeft ? 0 : increment)) * (1 / denominator);
		}
	}

	void seed(uint x)
	{
		baseEngine.seed = x;
	}
}

unittest
{
	alias HighresUnitUniformEngine!(Rand48Engine, true, true) fullClosed;
	alias HighresUnitUniformEngine!(Rand48Engine, true, false) closedLeft;
	alias HighresUnitUniformEngine!(Rand48Engine, false, true) closedRight;
	alias HighresUnitUniformEngine!(Rand48Engine, false, false) fullOpened;

	static assert(fullClosed.min == 0.L);
	static assert(fullClosed.max == 1.L);

	static assert(closedLeft.min == 0.L);
	static assert(closedLeft.max < 1.L);
	
	static assert(closedRight.min > 0.L);
	static assert(closedRight.max == 1.L);

	static assert(fullOpened.min > 0.L);
	static assert(fullOpened.max < 1.L);
}
