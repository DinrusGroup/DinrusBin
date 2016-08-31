module mango.locale.all;

// Issues: does not compile with "-cov" because of a circular dependency.
// mango.locale.core and mango.locale.format need to import each other.

import mango.locale.constants,
  mango.locale.core,
  mango.locale.collation,
  mango.locale.format,
  mango.locale.parse;
version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
