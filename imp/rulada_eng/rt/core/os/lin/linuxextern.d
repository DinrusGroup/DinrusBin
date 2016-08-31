
/* Written by Walter Bright.
 * www.digitalmars.com
 * Placed into public domain.
 * Linux(R) is the registered trademark of Linus Torvalds in the U.S. and other
 * countries.
 */

/* These are all the globals defined by the linux C runtime library.
 * Put them separate so they'll be extern ed - do not link in rt.core.os.lin.linuxextern .o
 */

module rt.core.os.lin.linuxextern ;

extern  (C)
{
    void* __libc_stack_end;
    int __data_start;
    int _end;
    int timezone;

    void *_deh_beg;
    void *_deh_end;
}

