/*******************************************************************************

        Copyright (c) 2006 Regan Heath
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, February 2006      
                        Modified for Mango, April 2006

        @author         Regan Heath
                        Kris

*******************************************************************************/

module mango.cipher.md2;

public import mango.cipher.base;

/*******************************************************************************

*******************************************************************************/

class Md2Digest : Digest
{
        private ubyte[16] digest;

        /***********************************************************************
        
        ***********************************************************************/

        this() { digest[] = 0; }

        /***********************************************************************
        
        ***********************************************************************/

        this(ubyte[16] raw) { digest[] = raw[]; }

        /***********************************************************************
        
        ***********************************************************************/

        this(Md2Digest rhs) { digest[] = rhs.digest[]; }        

        /***********************************************************************
        
        ***********************************************************************/

        char[] toString() { return toHexString(digest); }
}


/*******************************************************************************

*******************************************************************************/

class Md2Cipher : Cipher
{
        private ubyte[16] C,
                          state;
        
        /***********************************************************************
        
        ***********************************************************************/

        override void start()
        {
                super.start();
                state[] = 0;
                C[] = 0;
        }

        /***********************************************************************
        
        ***********************************************************************/

        override Md2Digest getDigest()
        {
                return new Md2Digest (state);
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        protected override uint blockSize() 
        { 
                return 16; 
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected override uint addSize() 
        { 
                return 0;  
        }       
        
        /***********************************************************************
        
        ***********************************************************************/

        protected override void padMessage (ubyte[] data)
        {
                data[0..$] = cast(ubyte) data.length;  // bug?
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        protected override void transform (ubyte[] input)
        {
                ubyte[48] X;
                uint t,i,j;

                X[0..16] = state[];
                X[16..32] = input[];
                for (i = 0; i < 16; i++)
                        X[i+32] = cast(ubyte) (state[i] ^ input[i]);

                t = 0;
                for (i = 0; i < 18; i++) {
                        for (j = 0; j < 48; j++)
                                t = X[j] ^= PI[t];
                        t = (t + i) & 0xff;
                }

                state[] = X[0..16];

                t = C[15];
                for (i = 0; i < 16; i++)
                        t = C[i] ^= PI[input[i] ^ t];
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        protected override void extend()
        {
                transform(C);
        }
}


/*******************************************************************************

*******************************************************************************/

private const ubyte[256] PI = 
[
         41,  46,  67, 201, 162, 216, 124,   1,  61,  54,  84, 161, 236, 240,   6,
         19,  98, 167,   5, 243, 192, 199, 115, 140, 152, 147,  43, 217, 188,
         76, 130, 202,  30, 155,  87,  60, 253, 212, 224,  22, 103,  66, 111,  24,
        138,  23, 229,  18, 190,  78, 196, 214, 218, 158, 222,  73, 160, 251,
        245, 142, 187,  47, 238, 122, 169, 104, 121, 145,  21, 178,   7,  63,
        148, 194,  16, 137,  11,  34,  95,  33, 128, 127,  93, 154,  90, 144,  50,
         39,  53,  62, 204, 231, 191, 247, 151,  3,  255,  25,  48, 179,  72, 165,
        181, 209, 215,  94, 146,  42, 172,  86, 170, 198,  79, 184,  56, 210,
        150, 164, 125, 182, 118, 252, 107, 226, 156, 116,   4, 241,  69, 157,
        112,  89, 100, 113, 135,  32, 134,  91, 207, 101, 230,  45, 168,   2,  27,
         96,  37, 173, 174, 176, 185, 246,  28,  70,  97, 105,  52,  64, 126,  15,
         85,  71, 163,  35, 221,  81, 175,  58, 195,  92, 249, 206, 186, 197,
        234,  38,  44,  83,  13, 110, 133,  40, 132,   9, 211, 223, 205, 244,  65,
        129,  77,  82, 106, 220,  55, 200, 108, 193, 171, 250,  36, 225, 123,
          8,  12, 189, 177,  74, 120, 136, 149, 139, 227,  99, 232, 109, 233,
        203, 213, 254,  59,   0,  29,  57, 242, 239, 183,  14, 102,  88, 208, 228,
        166, 119, 114, 248, 235, 117,  75,  10,  49,  68,  80, 180, 143, 237,
         31,  26, 219, 153, 141,  51, 159,  17, 131,  20
];


/*******************************************************************************

*******************************************************************************/

unittest {
        static char[][] strings = [
                "",
                "a",
                "abc",
                "message digest",
                "abcdefghijklmnopqrstuvwxyz",
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
                "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
        ];
        static char[][] results = [
                "8350E5A3E24C153DF2275C9F80692773",
                "32EC01EC4A6DAC72C0AB96FB34C0B5D1",
                "DA853B0D3F88D99B30283A69E6DED6BB",
                "AB4F496BFB2A530B219FF33031FE06B0",
                "4E8DDFF3650292AB5A4108C3AA47940B",
                "DA33DEF2A42DF13975352846C30338CD",
                "D5976F79D83D3A0DC9806C3C66F3EFD8"
        ];
        
        Md2Cipher h = new Md2Cipher();
        char[] res;

        foreach(int i, char[] s; strings) {
                res = h.sum(s).toString();
                assert(res == results[i]);
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
