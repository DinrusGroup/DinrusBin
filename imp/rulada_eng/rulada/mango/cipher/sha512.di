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

module mango.cipher.sha512;

public import mango.cipher.base;

/*******************************************************************************

*******************************************************************************/

class Sha512Digest : Digest
{
        private ulong[8] digest;

        /***********************************************************************
        
        ***********************************************************************/

        this(ulong[8] context) { digest[] = context[]; }

        /***********************************************************************
        
        ***********************************************************************/

        char[] toString() { return toHexString(digest); }
}


/*******************************************************************************

*******************************************************************************/

class Sha512Cipher : Cipher
{
        private ulong[8]        context;
        private const uint      padChar = 0x80;

        /***********************************************************************
        
        ***********************************************************************/

        override void start()
        {
                super.start();
                context[] = initial[];
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        override Sha512Digest getDigest()
        {
                return new Sha512Digest(context);
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected override uint blockSize() { return 128; }

        /***********************************************************************
        
        ***********************************************************************/

        protected override uint addSize()   { return 16;  }

        /***********************************************************************
        
        ***********************************************************************/

        protected override void padMessage(ubyte[] data)
        {
                data[0] = padChar;
                data[1..$] = 0;
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected override void padLength(ubyte[] data, ulong length)
        {
                length <<= 3;
                for(int j = data.length-1; j >= 0; j--) {
                        data[data.length-j-1] = cast(ubyte) (length >> j*8);
                }
                data[0..8] = 0;
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected override void transform(ubyte[] input)
        {
                ulong[80] W;
                ulong a,b,c,d,e,f,g,h;
                ulong t1,t2;
                uint j;

                a = context[0];
                b = context[1];
                c = context[2];
                d = context[3];
                e = context[4];
                f = context[5];
                g = context[6];
                h = context[7];

                bigEndian64(input,W[0..16]);
                for(j = 16; j < 80; j++) {
                        W[j] = mix1(W[j-2]) + W[j-7] + mix0(W[j-15]) + W[j-16];
                }

                for(j = 0; j < 80; j++) {
                        t1 = h + sum1(e) + Ch(e,f,g) + K[j] + W[j];
                        t2 = sum0(a) + Maj(a,b,c);
                        h = g;
                        g = f;
                        f = e;
                        e = d + t1;
                        d = c;
                        c = b;
                        b = a;
                        a = t1 + t2;
                }

                context[0] += a;
                context[1] += b;
                context[2] += c;
                context[3] += d;
                context[4] += e;
                context[5] += f;
                context[6] += g;
                context[7] += h;
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong Ch(ulong x, ulong y, ulong z)
        {
                return (x&y)^(~x&z);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong Maj(ulong x, ulong y, ulong z)
        {
                return (x&y)^(x&z)^(y&z);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong sum0(ulong x)
        {
                return rotateRight(x,28)^rotateRight(x,34)^rotateRight(x,39);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong sum1(ulong x)
        {
                return rotateRight(x,14)^rotateRight(x,18)^rotateRight(x,41);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong mix0(ulong x)
        {
                return rotateRight(x,1)^rotateRight(x,8)^shiftRight(x,7);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private static ulong mix1(ulong x)
        {
                return rotateRight(x,19)^rotateRight(x,61)^shiftRight(x,6);
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private static ulong rotateRight(ulong x, uint n)
        {
                return (x >> n) | (x << (64-n));
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private static ulong shiftRight(ulong x, uint n)
        {
                return x >> n;
        }

}

/*******************************************************************************

*******************************************************************************/

private static const ulong[] K = [
                0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc,
                0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118,
                0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
                0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694,
                0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
                0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
                0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4,
                0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70,
                0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
                0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
                0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30,
                0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
                0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8,
                0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3,
                0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
                0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b,
                0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178,
                0x06f067aa72176fba, 0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
                0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c,
                0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817
        ];

/*******************************************************************************

*******************************************************************************/

private static const ulong[8] initial = [
                0x6a09e667f3bcc908,
                0xbb67ae8584caa73b,
                0x3c6ef372fe94f82b,
                0xa54ff53a5f1d36f1,
                0x510e527fade682d1,
                0x9b05688c2b3e6c1f,
                0x1f83d9abfb41bd6b,
                0x5be0cd19137e2179
        ];


/*******************************************************************************

*******************************************************************************/

unittest {      
        static char[][] strings = [
                "abc",
                "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
        ];
        static char[][] results = [
                "DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F",
                "8E959B75DAE313DA8CF4F72814FC143F8F7779C6EB9F7FA17299AEADB6889018501D289E4900F7E4331B99DEC4B5433AC7D329EEB6DD26545E96E55B874BE909"
        ];
        
        auto h = new Sha512Cipher();
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
