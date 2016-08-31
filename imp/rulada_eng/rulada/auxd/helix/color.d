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

    Neither name of Victor Nakoryakov nor the names of
    its contributors may be used to endorse or promote products
    derived from this software without specific prior written
    permission.

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
/**
Module with classes and functions for working with _color values.

There are structs for representation Red Green Blue _color (Color3),
RGB+Alpha _color (Color4) and Hue Saturation Luminance triple (HSL).

All components of those structs are float values, not integers.
Rationale is that under different circumstances it is necessary to
work with different standards of integer representation. Frequently
one byte-wise integer layout needed for one API and another for second.
One can require XRGB order, another BGRA. So it's better to operate with
floats and to convert them to integer just when it is necessary.

Normal range for float components' values is [0; 1]. Normal range for integer
values is [0; 255] for Color3 and Color4, and [0; 240] for HSL. Each struct
has several methods to convert native float representation to integer and
back.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/

module auxd.helix.color;

private import auxd.helix.basic,
               auxd.helix.config;

/** Defines bytes orders for float to uint conversions. */
enum ByteOrder
{
    XRGB,        ///
    XBGR,        /// ditto
    RGBX,        /// ditto
    BGRX,        /// ditto
    ARGB = XRGB, /// ditto
    ABGR = XBGR, /// ditto
    RGBA = RGBX, /// ditto
    BGRA = BGRX  /// ditto
}

/**
Wrapper template to provide possibility to use different float types
in implemented structs and routines.
*/
private template Color(float_t)
{
    private alias auxd.helix.basic.clampBelow  clampBelow;
    private alias auxd.helix.basic.clampAbove  clampAbove;
    private alias auxd.helix.basic.clamp       clamp;
    private alias auxd.helix.basic.equal       equal;

    private alias .Color!(float).HSL      HSLf;
    private alias .Color!(float).Color3   Color3f;
    private alias .Color!(float).Color4   Color4f;

    private alias .Color!(double).HSL     HSLd;
    private alias .Color!(double).Color3  Color3d;
    private alias .Color!(double).Color4  Color4d;

    private alias .Color!(real).HSL       HSLr;
    private alias .Color!(real).Color3    Color3r;
    private alias .Color!(real).Color4    Color4r;

    private static const float_t rgbK = 255;
    private static const float_t hslK = 240;

    /************************************************************************************
    Hue, Saturation, Luminance triple.
    *************************************************************************************/
    struct HSL
    {
        float_t h; /// Hue.
        float_t s; /// Saturation.
        float_t l; /// Luminance.

        /**
        Method to construct struct in C-like syntax.

        Примеры:
        ------------
        HSL hsl = HSL(0.1, 0.2, 0.3);
        ------------
        */
        static HSL opCall(float_t h, float_t s, float_t l)
        {
            HSL hsl;
            hsl.set(h, s, l);
            return hsl;
        }

        /** Sets components to values of passed arguments. */
        void set(float_t h, float_t s, float_t l)
        {
            this.h = h;
            this.s = s;
            this.l = l;
        }

        /** Возвращает: Integer value of corresponding component in range [0; 240]. */
        uint hi()
        {
            return cast(uint)(h * hslK);
        }

        /** ditto */
        uint si()
        {
            return cast(uint)(s * hslK);
        }

        /** ditto */
        uint li()
        {
            return cast(uint)(l * hslK);
        }

        /**
        Set components to values of passed arguments. It is assumed that values of
        arguments are in range [0; 240].
        */
        void hi(uint h)
        {
            this.h = cast(float_t)h / hslK;
        }

        /** ditto */
        void si(uint s)
        {
            this.s = cast(float_t)s / hslK;
        }

        /** ditto */
        void li(uint l)
        {
            this.l = cast(float_t)l / hslK;
        }

        /** Component-wise equality operator. */
        bool opEquals(HSL hsl)
        {
            return h == hsl.h && s == hsl.s && l == hsl.l;
        }

        /** Возвращает: Color3 representing the same color as this triple. */
        Color3 toColor3()
        {
            const short rgbMax = cast(short)rgbK;
            const short hslMax = cast(short)hslK;
            short HueToRGB(short n1, short n2, short hue)
            {
                // range check: note values passed add/subtract thirds of range
                if (hue < 0)
                    hue += hslMax;

                if (hue > hslMax)
                    hue -= hslMax;

                // return r,g, or b value from this tridrant
                if (hue < hslMax / 6)
                    return n1 + ((n2 - n1) * hue + hslMax / 12) / (hslMax / 6);
                if (hue < hslMax / 2)
                    return n2;
                if (hue < hslMax * 2 / 3)
                    return n1 + ((n2 - n1) * ((hslMax * 2/3) - hue) + (hslMax / 12)) / (hslMax / 6);
                else
                    return n1;
            }

            short hue = cast(short)hi;
            short lum = cast(short)li;
            short sat = cast(short)si;
            short magic1, magic2; // calculated magic numbers

            Color3 ret;

            if (sat == 0) // achromatic case
            {
                ret.set(l, l, l);
            }
            else // chromatic case
            {
                // set up magic numbers
                if (lum <= hslMax / 2)
                    magic2 = (lum * (hslMax + sat) + hslMax / 2) / hslMax;
                else
                    magic2 = lum + sat - (lum * sat + hslMax / 2) / hslMax;

                magic1 = 2 * lum - magic2;

                // get RGB, change units from hslMax to [0; 1] range
                ret.r = cast(float_t)(HueToRGB(magic1, magic2, hue + (hslMax / 3)) * rgbMax + hslMax / 2) / hslK / rgbK;
                ret.g = cast(float_t)(HueToRGB(magic1, magic2, hue) * rgbMax + hslMax / 2) / hslK / rgbK;
                ret.b = cast(float_t)(HueToRGB(magic1, magic2, hue - (hslMax / 3)) * rgbMax + hslMax / 2) / hslK / rgbK;
            }

            return ret;
        }
    }

    /**
    Approximate equality function.
    Params:
        relprec, absprec = Parameters passed to equal function while calculations.
                           Have the same meaning as in equal function.
    */
    bool equal(HSL a, HSL b, int relprec = defrelprec, int absprec = defabsprec)
    {
        HSL c;
        c.set(a.h - b.h, a.s - b.s, a.l - b.l);
        return .equal(c.h * c.h + c.s * c.s + c.l * c.l, 0, relprec, absprec);
    }

    /************************************************************************************
    Red, Green, Blue triple.
    *************************************************************************************/
    struct Color3
    {
        align(1)
        {
            float_t r; /// Red.
            float_t g; /// Green.
            float_t b; /// Blue.
        }

        /// Color3 with all components seted to NaN.
        static Color3 nan = { float_t.nan, float_t.nan, float_t.nan };

        /**
        Method to construct color in C-like syntax.

        Примеры:
        ------------
        Color3 c = Color3(0.1, 0.2, 0.3);
        ------------
        */
        static Color3 opCall(float_t r, float_t g, float_t b)
        {
            Color3 v;
            v.set(r, g, b);
            return v;
        }

        /**
        Method to construct color in C-like syntax from value specified
        in uint parameter.

        Params:
            src     = uint to extract value from.
            order   = specifies byte-wise _order in src.

        Примеры:
        ------------
        Color3 c = Color3(0x00FFEEDD, ByteOrder.XRGB);
        ------------
        */
        static Color3 opCall(uint src, ByteOrder order)
        {
            Color3 v;
            v.set(src, order);
            return v;
        }

        /** Sets components to values of passed arguments. */
        void set(float_t r, float_t g, float_t b)
        {
            this.r = r;
            this.g = g;
            this.b = b;
        }

        /**
        Sets components according to color packed in src uint argument.

        Params:
            src     = uint to extract value from.
            order   = specifies byte-wise component layout in src.
        */
        void set(uint src, ByteOrder order = ByteOrder.XRGB)
        {
            switch (order)
            {
                case ByteOrder.XRGB:
                    ri = (src & 0x00FF0000) >> 16;
                    gi = (src & 0x0000FF00) >> 8;
                    bi = (src & 0x000000FF) >> 0;
                    break;

                case ByteOrder.XBGR:
                    bi = (src & 0x00FF0000) >> 16;
                    gi = (src & 0x0000FF00) >> 8;
                    ri = (src & 0x000000FF) >> 0;
                    break;

                case ByteOrder.RGBX:
                    ri = (src & 0xFF000000) >>> 24;
                    gi = (src & 0x00FF0000) >>> 16;
                    bi = (src & 0x0000FF00) >>> 8;
                    break;

                case ByteOrder.BGRX:
                    bi = (src & 0xFF000000) >>> 24;
                    gi = (src & 0x00FF0000) >>> 16;
                    ri = (src & 0x0000FF00) >>> 8;
                    break;
            }
        }

        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return std.math.isnormal(r) && std.math.isnormal(g) && std.math.isnormal(b);
        }

        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        int ri()
        {
            return cast(int)(r * rgbK);
        }

        /** ditto */
        int gi()
        {
            return cast(int)(g * rgbK);
        }

        /** ditto */
        int bi()
        {
            return cast(int)(b * rgbK);
        }

        /**
        Sets corresponding component value to mapped value of passed argument.

        Integer value 0 is mapped to float 0. Integer value 255 is mapped to
        float 1.
        */
        void ri(int r)
        {
            this.r = cast(float_t)r / rgbK;
        }

        /** ditto */
        void gi(int g)
        {
            this.g = cast(float_t)g / rgbK;
        }

        /** ditto */
        void bi(int b)
        {
            this.b = cast(float_t)b / rgbK;
        }

        /**
        Возвращает:
            This color packed to uint.
        Params:
            order = specifies byte-wise component layout in src.
        Throws:
            AssertError if any component is out of range [0; 1] and module was
            compiled with asserts.
        */
        uint toUint(ByteOrder order)
        {
            assert(ri >= 0 && ri < 256);
            assert(gi >= 0 && gi < 256);
            assert(bi >= 0 && bi < 256);

            switch (order)
            {
                case ByteOrder.XRGB: return (ri << 16) | (gi <<  8) | (bi << 0);
                case ByteOrder.XBGR: return (bi << 16) | (gi <<  8) | (ri << 0);
                case ByteOrder.RGBX: return (ri << 24) | (gi << 16) | (bi << 8);
                case ByteOrder.BGRX: return (bi << 24) | (gi << 16) | (ri << 8);
            }

            return 0;
        }

        /**
        Возвращает:
            HSL triple representing same color as this.
        */
        HSL toHSL()
        {
            const short hslMax = cast(short)hslK;
            const short rgbMax = cast(short)rgbK;

            ubyte h, s, l;
            ubyte cMax, cMin;                // max and min RGB values
            short rDelta, gDelta, bDelta;    // intermediate value: % of spread from max

            // get R, G, and B out of DWORD
            short r = ri;
            short g = gi;
            short b = bi;

            // calculate lightness
            cMax = max(max(r, g), b);
            cMin = min(min(r, g), b);
            l = ((cMax + cMin) * hslMax + rgbMax) / (2 * rgbMax);

            if (cMax == cMin)                // r = g = b --> achromatic case
            {
                h = s = 0;
            }
            else
            {                                // chromatic case
                // saturation
                if (l <= hslMax / 2)
                    s = ((cMax - cMin) * hslMax + (cMax + cMin) / 2) / (cMax + cMin);
                else
                    s = ((cMax - cMin) * hslMax + (2 * rgbMax - cMax - cMin) / 2) / (2 * rgbMax - cMax - cMin);

                // hue
                rDelta = ((cMax - r) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
                gDelta = ((cMax - g) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
                bDelta = ((cMax - b) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);

                if (r == cMax)
                    h = bDelta - gDelta;
                else if (g == cMax)
                    h = (hslMax / 3) + rDelta - bDelta;
                else // B == cMax
                    h = (2 * hslMax) / 3 + gDelta - rDelta;

                if(h < 0)
                    h += hslMax;

                if(h > hslMax)
                    h -= hslMax;
            }

            HSL ret;
            ret.hi = h;
            ret.si = s;
            ret.li = l;
            return ret;
        }

        /** Возвращает: float_t pointer to r component of this color. It's like a _ptr method for arrays. */
        float_t* ptr()
        {
            return cast(float_t*)this;
        }

        /**
        Standard operators that have meaning exactly the same as for Vector3, i.e. do
        component-wise operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result vector will have infinity components. You can check this with isnormal()
        method.
        */
        bool opEquals(Color3 v)
        {
            return r == v.r && g == v.g && b == v.b;
        }

        /** ditto */
        Color3 opNeg()
        {
            return Color3(-r, -g, -b);
        }

        /** ditto */
        Color3 opAdd(Color3 v)
        {
            return Color3(r + v.r, g + v.g, b + v.b);
        }

        /** ditto */
        void opAddAssign(Color3 v)
        {
            r += v.r;
            g += v.g;
            b += v.b;
        }

        /** ditto */
        Color3 opSub(Color3 v)
        {
            return Color3(r - v.r, g - v.g, b - v.b);
        }

        /** ditto */
        void opSubAssign(Color3 v)
        {
            r -= v.r;
            g -= v.g;
            b -= v.b;
        }

        /** ditto */
        Color3 opMul(real k)
        {
            return Color3(r * k, g * k, b * k);
        }

        /** ditto */
        void opMulAssign(real k)
        {
            r *= k;
            g *= k;
            b *= k;
        }

        /** ditto */
        Color3 opMulr(real k)
        {
            return Color3(r * k, g * k, b * k);
        }

        /** ditto */
        Color3 opDiv(real k)
        {
            return Color3(r / k, g / k, b / k);
        }

        /** ditto */
        void opDivAssign(real k)
        {
            r /= k;
            g /= k;
            b /= k;
        }

        /** Sets all components less than inf to inf. */
        void clampBelow(float_t inf = 0)
        {
            .clampBelow(r, inf);
            .clampBelow(g, inf);
            .clampBelow(b, inf);
        }

        /** Возвращает: Copy of this color with all components less than inf seted to inf. */
        Color3 clampedBelow(float_t inf = 0)
        {
            Color3 ret = *this;
            ret.clampBelow(inf);
            return ret;
        }

        /** Sets all components greater than sup to sup. */
        void clampAbove(float_t sup = 1)
        {
            .clampAbove(r, sup);
            .clampAbove(g, sup);
            .clampAbove(b, sup);
        }

        /** Возвращает: Copy of this color with all components greater than sup seted to sup. */
        Color3 clampedAbove(float_t sup = 1)
        {
            Color3 ret = *this;
            ret.clampBelow(sup);
            return ret;
        }

        /**
        Sets all components less than inf to inf and
        all components greater than sup to sup.
        */
        void clamp(float_t inf = 0, float_t sup = 1)
        {
            clampBelow(inf);
            clampAbove(sup);
        }

        /**
        Возвращает:
            Copy of this color with all components less than inf seted to inf
            and all components greater than sup seted to sup.
        */
        Color3 clamped(float_t inf = 0, float_t sup = 1)
        {
            Color3 ret = *this;
            ret.clamp(inf, sup);
            return ret;
        }

        /** Возвращает: Copy of this color with float type components. */
        Color3f toColor3f()
        {
            return Color3f(cast(float)r, cast(float)g, cast(float)b);
        }

        /** Возвращает: Copy of this color with double type components. */
        Color3d toColor3d()
        {
            return Color3d(cast(double)r, cast(double)g, cast(double)b);
        }

        /** Возвращает: Copy of this color with real type components. */
        Color3r toColor3r()
        {
            return Color3r(cast(real)r, cast(real)g, cast(real)b);
        }

        /**
        Routines known as swizzling.
        Возвращает:
            New color constructed from this one and having component values
            that correspond to method name.
        */
        Color4 rgb0()    { return Color4(r, g, b, 0); }
        Color4 rgb1()    { return Color4(r, g, b, 1); } /// ditto
    }

    /**
    Approximate equality function.
    Params:
        relprec, absprec = Parameters passed to equal function while calculations.
                           Have the same meaning as in equal function.
    */
    bool equal(Color3 a, Color3 b, int relprec = defrelprec, int absprec = defabsprec)
    {
        Color3 c = a - b;
        return .equal(c.r * c.r + c.g * c.g + c.b * c.b, 0, relprec, absprec);
    }

    alias Lerp!(Color3).lerp lerp; /// Introduces linear interpolation function for Color3.


    /************************************************************************************
    Red, Green, Blue triple with additional Alpha component.
    *************************************************************************************/
    struct Color4
    {
        align(1)
        {
            float_t r; /// Red.
            float_t g; /// Green.
            float_t b; /// Blue.
            float_t a; /// Alpha.
        }

        /// Color4 with all components seted to NaN.
        static Color4 nan = { float_t.nan, float_t.nan, float_t.nan, float_t.nan };

        /**
        Methods to construct color in C-like syntax.

        Примеры:
        ------------
        Color4 c1 = Color4(0.1, 0.2, 0.3, 1);
        Color3 rgb = Color3(0, 0, 0.5);
        Color4 c2 = Color4(rgb, 1);
        ------------
        */
        static Color4 opCall(float_t r, float_t g, float_t b, float_t a)
        {
            Color4 v;
            v.set(r, g, b, a);
            return v;
        }

        /** ditto */
        static Color4 opCall(Color3 rgb, float_t a = 1)
        {
            Color4 v;
            v.set(rgb, a);
            return v;
        }


        /**
        Method to construct color in C-like syntax from value specified
        in uint parameter.

        Params:
            src     = uint to extract value from.
            order   = specifies byte-wise _order in src.

        Примеры:
        ------------
        Color4 c = Color4(0x99FFEEDD, ByteOrder.ARGB);
        ------------
        */
        static Color4 opCall(uint src, ByteOrder order)
        {
            Color4 v;
            v.set(src, order);
            return v;
        }


        /** Set components to values of passed arguments. */
        void set(float_t r, float_t g, float_t b, float_t a)
        {
            this.r = r;
            this.g = g;
            this.b = b;
            this.a = a;
        }

        /** ditto */
        void set(Color3 rgb, float_t a)
        {
            this.rgb = rgb;
            this.a = a;
        }


        /**
        Sets components according to color packed in src uint argument.

        Params:
            src     = uint to extract value from.
            order   = specifies byte-wise layout in src.
        */
        void set(uint src, ByteOrder order = ByteOrder.ARGB)
        {
            switch (order)
            {
                case ByteOrder.ARGB:
                    ai = (src & 0xFF000000) >>> 24;
                    ri = (src & 0x00FF0000) >>> 16;
                    gi = (src & 0x0000FF00) >>> 8;
                    bi = (src & 0x000000FF) >>> 0;
                    break;

                case ByteOrder.ABGR:
                    ai = (src & 0xFF000000) >>> 24;
                    bi = (src & 0x00FF0000) >>> 16;
                    gi = (src & 0x0000FF00) >>> 8;
                    ri = (src & 0x000000FF) >>> 0;
                    break;

                case ByteOrder.RGBA:
                    ri = (src & 0xFF000000) >>> 24;
                    gi = (src & 0x00FF0000) >>> 16;
                    bi = (src & 0x0000FF00) >>> 8;
                    ai = (src & 0x000000FF) >>> 0;
                    break;

                case ByteOrder.BGRA:
                    bi = (src & 0xFF000000) >>> 24;
                    gi = (src & 0x00FF0000) >>> 16;
                    ri = (src & 0x0000FF00) >>> 8;
                    ai = (src & 0x000000FF) >>> 0;
                    break;
            }
        }

        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return std.math.isnormal(r) && std.math.isnormal(g) && std.math.isnormal(b) && std.math.isnormal(a);
        }

        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        int ri()
        {
            return cast(int)(r * rgbK);
        }

        /** ditto */
        int gi()
        {
            return cast(int)(g * rgbK);
        }

        /** ditto */
        int bi()
        {
            return cast(int)(b * rgbK);
        }

        /** ditto */
        int ai()
        {
            return cast(int)(a * rgbK);
        }

        /**
        Sets corresponding component value to mapped value of passed argument.

        Integer value 0 is mapped to float 0. Integer value 255 is mapped to
        float 1.
        */
        void ri(int r)
        {
            this.r = cast(float_t)r / rgbK;
        }

        /** ditto */
        void gi(int g)
        {
            this.g = cast(float_t)g / rgbK;
        }

        /** ditto */
        void bi(int b)
        {
            this.b = cast(float_t)b / rgbK;
        }

        /** ditto */
        void ai(int a)
        {
            this.a = cast(float_t)a / rgbK;
        }

        /**
        Возвращает:
            This color packed to uint.
        Params:
            order = specifies byte-wise component layout in src.
        Throws:
            AssertError if any component is out of range [0; 1] and
            module was compiled with asserts.
        */
        uint toUint(ByteOrder order)
        {
            assert(ri >= 0 && ri < 256);
            assert(gi >= 0 && gi < 256);
            assert(bi >= 0 && bi < 256);
            assert(ai >= 0 && ai < 256);

            switch (order)
            {
                case ByteOrder.ARGB: return (ai << 24) | (ri << 16) | (gi <<  8) | (bi << 0);
                case ByteOrder.ABGR: return (ai << 24) | (bi << 16) | (gi <<  8) | (ri << 0);
                case ByteOrder.RGBA: return (ri << 24) | (gi << 16) | (bi <<  8) | (ai << 0);
                case ByteOrder.BGRA: return (bi << 24) | (gi << 16) | (ri <<  8) | (ai << 0);
            }

            return 0;
        }

        /**
        Возвращает:
            HSL triple representing same color as this.

        Alpha value is ignored.
        */
        HSL toHSL()
        {
            return rgb.toHSL();
        }

        /** Возвращает: float_t pointer to r component of this color. It's like a _ptr method for arrays. */
        float_t* ptr()
        {
            return cast(float_t*)this;
        }


        /**
        Standard operators that have meaning exactly the same as for Vector4, i.e. do
        component-wise operations. So alpha component equaly in rights takes place in all
        operations, to affect just RGB part use swizzling operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result vector will have infinity components. You can check this with isnormal()
        method.
        */
        bool opEquals(Color4 v)
        {
            return r == v.r && g == v.g && b == v.b && a == v.a;
        }

        /** ditto */
        Color4 opNeg()
        {
            return Color4(-r, -g, -b, -a);
        }

        /** ditto */
        Color4 opAdd(Color4 v)
        {
            return Color4(r + v.r, g + v.g, b + v.b, a + v.a);
        }

        /** ditto */
        void opAddAssign(Color4 v)
        {
            r += v.r;
            g += v.g;
            b += v.b;
            a += v.a;
        }

        /** ditto */
        Color4 opSub(Color4 v)
        {
            return Color4(r - v.r, g - v.g, b - v.b, a - v.a);
        }

        /** ditto */
        void opSubAssign(Color4 v)
        {
            r -= v.r;
            g -= v.g;
            b -= v.b;
            a -= v.a;
        }

        /** ditto */
        Color4 opMul(real k)
        {
            return Color4(r * k, g * k, b * k, a * k);
        }

        /** ditto */
        void opMulAssign(real k)
        {
            r *= k;
            g *= k;
            b *= k;
            a *= k;
        }

        /** ditto */
        Color4 opMulr(real k)
        {
            return Color4(r * k, g * k, b * k, a * k);
        }

        /** ditto */
        Color4 opDiv(real k)
        {
            return Color4(r / k, g / k, b / k, a / k);
        }

        /** ditto */
        void opDivAssign(real k)
        {
            r /= k;
            g /= k;
            b /= k;
            a /= k;
        }

        /** Sets all components less than inf to inf. */
        void clampBelow(float_t inf = 0)
        {
            .clampBelow(r, inf);
            .clampBelow(g, inf);
            .clampBelow(b, inf);
            .clampBelow(a, inf);
        }

        /** Возвращает: Copy of this color with all components less than inf seted to inf. */
        Color4 clampedBelow(float_t inf = 0)
        {
            Color4 ret = *this;
            ret.clampBelow(inf);
            return ret;
        }

        /** Sets all components greater than sup to sup. */
        void clampAbove(float_t sup = 1)
        {
            .clampAbove(r, sup);
            .clampAbove(g, sup);
            .clampAbove(b, sup);
            .clampAbove(a, sup);
        }

        /** Возвращает: Copy of this color with all components greater than sup seted to sup. */
        Color4 clampedAbove(float_t sup = 1)
        {
            Color4 ret = *this;
            ret.clampBelow(sup);
            return ret;
        }

        /**
        Sets all components less than inf to inf and
        all components greater than sup to sup.
        */
        void clamp(float_t inf = 0, float_t sup = 1)
        {
            clampBelow(inf);
            clampAbove(sup);
        }

        /**
        Возвращает:
            Copy of this color with all components less than inf seted to inf
            and all components greater than sup seted to sup.
        */
        Color4 clamped(float_t inf = 0, float_t sup = 1)
        {
            Color4 ret = *this;
            ret.clamp(inf, sup);
            return ret;
        }

        /** Возвращает: Copy of this color with float type components. */
        Color4f toColor4f()
        {
            return Color4f(cast(float)r, cast(float)g, cast(float)b, cast(float)a);
        }

        /** Возвращает: Copy of this color with double type components. */
        Color4d toColor4d()
        {
            return Color4d(cast(double)r, cast(double)g, cast(double)b, cast(double)a);
        }

        /** Возвращает: Copy of this color with real type components. */
        Color4r toColor4r()
        {
            return Color4r(cast(real)r, cast(real)g, cast(real)b, cast(real)a);
        }

        /**
        Routine known as swizzling.
        Возвращает:
            Color3 representing RGB part of this color.
        */
        Color3 rgb()
        {
            return Color3(r, g, b);
        }

        /**
        Routine known as swizzling.
        Sets RGB part components to values of passed _rgb argument's components.
        */
        void rgb(Color3 rgb)
        {
            r = rgb.r;
            g = rgb.g;
            b = rgb.b;
        }
    }

    /**
    Approximate equality function.
    Params:
        relprec, absprec = Parameters passed to equal function while calculations.
                           Have the same meaning as in equal function.
    */
    bool equal(Color4 a, Color4 b, int relprec = defrelprec, int absprec = defabsprec)
    {
        Color4 c = a - b;
        return .equal(c.r * c.r + c.g * c.g + c.b * c.b + c.a * c.a, 0, relprec, absprec);
    }

    alias Lerp!(Color4).lerp lerp; /// Introduces linear interpolation function for Color4.
}

alias Color!(float).HSL         HSLf;
alias Color!(float).Color3      Color3f;
alias Color!(float).Color4      Color4f;
alias Color!(float).equal       equal;
alias Color!(float).lerp        lerp;

alias Color!(double).HSL        HSLd;
alias Color!(double).Color3     Color3d;
alias Color!(double).Color4     Color4d;
alias Color!(double).equal      equal;
alias Color!(double).lerp       lerp;

alias Color!(real).HSL          HSLr;
alias Color!(real).Color3       Color3r;
alias Color!(real).Color4       Color4r;
alias Color!(real).equal        equal;
alias Color!(real).lerp         lerp;

alias Color!(auxd.helix.config.float_t).HSL     HSL;
alias Color!(auxd.helix.config.float_t).Color3  Color3;
alias Color!(auxd.helix.config.float_t).Color4  Color4;

unittest
{
    Color4 a;
    a.set(0.1, 0.3, 0.9, 0.6);
    Color3 b = a.rgb;
    uint au = a.toUint(ByteOrder.RGBA);
    assert( equal( Color3(au, ByteOrder.RGBA), b ) );
    assert(0);
}

unittest
{
    Color3 c = Color3( 0.2, 0.5, 1.0 );
    assert( equal(c.toHSL.toColor3(), c) );
}
