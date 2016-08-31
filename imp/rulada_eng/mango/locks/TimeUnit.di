/** \file TimeUnit.d
 * \brief A <tt>TimeUnit</tt> represents time durations at a given unit of
 * granularity and provides utility methods to convert across units,
 * and to perform timing and delay operations in these units.  A
 * <tt>TimeUnit</tt> does not maintain time information, but only
 * helps organize and use time representations that may be maintained
 * separately across various contexts.
 *
 * Written by Doug Lea with assistance from members of JCP JSR-166
 * Expert Group and released to the public domain, as explained at
 * http://creativecommons.org/licenses/publicdomain
 * Ported to D by Ben Hinkle.
 * Email comments and bug reports to ben.hinkle@gmail.com
 *
 * revision 2.0
 */

module mango.locks.TimeUnit;

/** \enum TimeOut
 * A <tt>TimeUnit</tt> represents time durations at a given unit of
 * granularity and provides utility methods to convert across units,
 * and to perform timing and delay operations in these units.  A
 * <tt>TimeUnit</tt> does not maintain time information, but only
 * helps organize and use time representations that may be maintained
 * separately across various contexts.
 *
 * <p>A <tt>TimeUnit</tt> is mainly used to inform time-based methods
 * how a given timing parameter should be interpreted. For example,
 *
 * <pre>  Lock lock = ...;
 *  if ( lock.tryLock(50L, MilliSeconds) ) ...
 * </pre>
 * while this code will timeout in 50 seconds:
 * <pre>
 *  Lock lock = ...;
 *  if ( lock.tryLock(50L, Seconds) ) ...
 * </pre>
 *
 * Note however, that there is no guarantee that a particular timeout
 * implementation will be able to notice the passage of time at the
 * same granularity as the given <tt>TimeUnit</tt>.
 */
enum TimeUnit {
  NanoSeconds = 0,
  MicroSeconds, 
  MilliSeconds,
  Seconds
}

/** Lookup table for conversion factors */
private const int[TimeUnit.max+1] multipliers = [ 
  1, 
  1000, 
  1000_000, 
  1000_000_000 
];
    
/** 
 * Lookup table to check saturation.  Note that because we are
 * dividing these down, we don't have to deal with asymmetry of
 * MIN/MAX values.
 */
private const long[TimeUnit.max+1] overflows = [ 
  0, // unused
  long.max / 1000,
  long.max / 1000_000,
  long.max / 1000_000_000 
];

/**
 * Perform conversion based on given delta representing the
 * difference between units
 * \param delta the difference in index values of source and target units
 * \param duration the duration
 * \return converted duration or saturated value
 */
private static long doConvert(int delta, long duration) {
  if (delta == 0)
    return duration;
  if (delta < 0) 
    return duration / multipliers[-delta];
  if (duration > overflows[delta])
    return long.max;
  if (duration < -overflows[delta])
    return long.min;
  return duration * multipliers[delta];
}

/**
 * Convert the given time duration in the given unit to this
 * unit.  Conversions from finer to coarser granularities
 * truncate, so lose precision. For example converting
 * <tt>999</tt> milliseconds to seconds results in
 * <tt>0</tt>. Conversions from coarser to finer granularities
 * with arguments that would numerically overflow saturate to
 * <tt>long.min</tt> if negative or <tt>long.max</tt>
 * if positive.
 *
 * \param duration the time duration in the given <tt>unit</tt>
 * \param fromUnit the unit of the <tt>duration</tt> argument
 * \param toUnit the unit of the result
 * \return the converted duration
 * or <tt>long.min</tt> if conversion would negatively
 * overflow, or <tt>long.max</tt> if it would positively overflow.
 */
long convert(long duration, TimeUnit fromUnit, TimeUnit toUnit) {
  return doConvert(fromUnit - toUnit, duration);
}

/**
 * Convert to nanoseconds.
 * \param duration the duration
 * \param fromUnit the unit of the <tt>duration</tt> argument
 * \return the converted duration,
 * or <tt>long.min</tt> if conversion would negatively
 * overflow, or <tt>long.max</tt> if it would positively overflow.
 */
long toNanos(long duration, TimeUnit fromUnit) {
  return doConvert(fromUnit, duration);
}

/**
 * Convert to microseconds.
 * \param duration the duration
 * \param fromUnit the unit of the <tt>duration</tt> argument
 * \return the converted duration,
 * or <tt>long.min</tt> if conversion would negatively
 * overflow, or <tt>long.max</tt> if it would positively overflow.
 */
long toMicros(long duration, TimeUnit fromUnit) {
  return doConvert(fromUnit - TimeUnit.MicroSeconds, duration);
}

/**
 * Convert to milliseconds.
 * \param duration the duration
 * \param fromUnit the unit of the <tt>duration</tt> argument
 * \return the converted duration,
 * or <tt>long.min</tt> if conversion would negatively
 * overflow, or <tt>long.max</tt> if it would positively overflow.
 */
long toMillis(long duration, TimeUnit fromUnit) {
  return doConvert(fromUnit - TimeUnit.MilliSeconds, duration);
}

/**
 * Convert to seconds.
 * \param duration the duration
 * \param fromUnit the unit of the <tt>duration</tt> argument
 * \return the converted duration.
 */
long toSeconds(long duration, TimeUnit fromUnit) {
  return doConvert(fromUnit - TimeUnit.Seconds, duration);
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
