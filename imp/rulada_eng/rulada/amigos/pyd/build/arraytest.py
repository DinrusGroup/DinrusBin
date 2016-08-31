import os.path, sys


# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = "."
sys.path.append(os.path.abspath(libDir))
from arraytest import Foo, get, set, test

#set([Foo(1), Foo(2), Foo(3)])
print ">>> get()"
print `get()`
print ">>> set([Foo(10), Foo(20)])"
set([Foo(10), Foo(20)])
print ">>> get()"
print `get()`

