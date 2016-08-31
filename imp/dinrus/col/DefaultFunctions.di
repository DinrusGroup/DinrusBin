/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.DefaultFunctions;

/**
 * Define the default compare
 */
цел ДефСравнить(V)(ref V v1, ref V v2)
{
    return typeid(V).compare(&v1, &v2);
}

/**
 * Define the default hash function
 */
бцел ДефХэш(V)(ref V v)
{
    return typeid(V).getHash(&v);
}
