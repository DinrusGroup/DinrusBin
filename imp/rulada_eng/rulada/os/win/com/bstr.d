﻿// This module is deprecated and will be removed in 0.4.2.
module os.win.com.bstr;

import os.win.com.core;

deprecated wchar* fromString(string s) {
  return toBstr(s);
}

deprecated string toString(wchar* s) {
  return fromBstr(s);
}

deprecated uint getLength(wchar* s) {
  return bstrLength(s);
}

deprecated void free(wchar* s) {
  freeBstr(s);
}