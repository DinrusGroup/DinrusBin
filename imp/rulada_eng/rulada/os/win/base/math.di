﻿/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.base.math;

private import std.math : isnan, abs;
private import os.windows : GetTickCount;

version(D_Version2) {
}
else {
/**
 * Returns the smaller of two numbers.
 * Параметры:
 *   val1 = The first number to compare.
 *   val2 = The second number to compare.
 * Возвращает: Parameter val1 or val2, whichever is smaller.
 */
T min(T)(T val1, T val2) {
  static if (is(T == ubyte) ||
    is(T == byte) ||
    is(T == ushort) ||
    is(T == short) ||
    is(T == uint) ||
    is(T == int) ||
    is(T == ulong) ||
    is(T == long)) {
    return (val1 > val2) ? val2 : val1;
  }
  else static if (is(T == float)
    || is(T == double)) {
    return (val1 < val2) ? val1 : isnan(val1) ? val1 : val2;
  }
  else
    static assert(false);
}

/**
 * Returns the larger of two numbers.
 * Параметры:
 *   val1 = The first number to compare.
 *   val2 = The second number to compare.
 * Возвращает: Parameter val1 or val2, whichever is larger.
 */
T max(T)(T val1, T val2) {
  static if (is(T == ubyte) ||
    is(T == byte) ||
    is(T == ushort) ||
    is(T == short) ||
    is(T == uint) ||
    is(T == int)||
    is(T == ulong) ||
    is(T == long)) {
    return (val1 < val2) ? val2 : val1;
  }
  else static if (is(T == float) 
    || is(T == double)) {
    return (val1 > val2) ? val1 : isnan(val1) ? val1 : val2;
  }
  else
    static assert(false);
}
}

double random() {
  synchronized {
    static Random rand;
    if (rand is null)
      rand = new Random;
    return rand.nextDouble();
  }
}

// Based on ran3 algorithm.
class Random {

  private const int SEED = 161803398;
  private const int BITS = 1000000000;

  private int[56] seedList_;
  private int next_, nextp_;

  this() {
    this(GetTickCount());
  }

  this(int seed) {
    int j = SEED - abs(seed);
    seedList_[55] = j;
    int k = 1;
    for (int c = 1; c < 55; c++) {
      int i = (21 * c) % 55;
      seedList_[i] = k;
      k = j - k;
      if (k < 0)
        k += BITS;
      j = seedList_[i];
    }

    for (int c = 1; c <= 4; c++) {
      for (int d = 1; d <= 55; d++) {
        seedList_[d] -= seedList_[1 + (d + 30) % 55];
        if (seedList_[d] < 0)
          seedList_[d] += BITS;
      }
    }

    nextp_ = 21;
  }

  int next() {
    if (++next_ >= 56)
      next_ = 1;
    if (++nextp_ >= 56)
      nextp_ = 1;
    int result = seedList_[next_] - seedList_[nextp_];
    if (result < 0)
      result += BITS;
    seedList_[next_] = result;
    return result;
  }

  int next(int max) {
    return cast(int)(sample() * max);
  }

  int next(int min, int max) {
    int range = max - min;
    if (range < 0) {
      long lrange = cast(long)(max - min);
      return cast(int)(cast(long)(sample() * cast(double)lrange) + min);
    }
    return cast(int)(sample() * range) + min;
  }

  double nextDouble() {
    return sample();
  }

  protected double sample() {
    return next() * (1.0 / BITS);
  }

}
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
