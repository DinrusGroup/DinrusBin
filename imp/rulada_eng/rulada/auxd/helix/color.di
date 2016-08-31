// D import file generated from 'color.d'
module auxd.helix.color;
private 
{
    import auxd.helix.basic;
    import auxd.helix.config;
}
enum ByteOrder 
{
XRGB,
XBGR,
RGBX,
BGRX,
ARGB = XRGB,
ABGR = XBGR,
RGBA = RGBX,
BGRA = BGRX,
}
private 
{
    template Color(float_t)
{
private 
{
    alias auxd.helix.basic.clampBelow clampBelow;
}
private 
{
    alias auxd.helix.basic.clampAbove clampAbove;
}
private 
{
    alias auxd.helix.basic.clamp clamp;
}
private 
{
    alias auxd.helix.basic.equal equal;
}
private 
{
    alias .Color!(float).HSL HSLf;
}
private 
{
    alias .Color!(float).Color3 Color3f;
}
private 
{
    alias .Color!(float).Color4 Color4f;
}
private 
{
    alias .Color!(double).HSL HSLd;
}
private 
{
    alias .Color!(double).Color3 Color3d;
}
private 
{
    alias .Color!(double).Color4 Color4d;
}
private 
{
    alias .Color!(real).HSL HSLr;
}
private 
{
    alias .Color!(real).Color3 Color3r;
}
private 
{
    alias .Color!(real).Color4 Color4r;
}
private 
{
    static const 
{
    float_t rgbK = 255;
}
}
private 
{
    static const 
{
    float_t hslK = 240;
}
}
struct HSL
{
    float_t h;
    float_t s;
    float_t l;
    static 
{
    HSL opCall(float_t h, float_t s, float_t l)
{
HSL hsl;
hsl.set(h,s,l);
return hsl;
}
}
    void set(float_t h, float_t s, float_t l)
{
this.h = h;
this.s = s;
this.l = l;
}
    uint hi()
{
return cast(uint)(h * hslK);
}
    uint si()
{
return cast(uint)(s * hslK);
}
    uint li()
{
return cast(uint)(l * hslK);
}
    void hi(uint h)
{
this.h = cast(float_t)h / hslK;
}
    void si(uint s)
{
this.s = cast(float_t)s / hslK;
}
    void li(uint l)
{
this.l = cast(float_t)l / hslK;
}
    bool opEquals(HSL hsl)
{
return h == hsl.h && s == hsl.s && l == hsl.l;
}
    Color3 toColor3()
{
const short rgbMax = cast(short)rgbK;
const short hslMax = cast(short)hslK;
short HueToRGB(short n1, short n2, short hue)
{
if (hue < 0)
hue += hslMax;
if (hue > hslMax)
hue -= hslMax;
if (hue < hslMax / 6)
return n1 + ((n2 - n1) * hue + hslMax / 12) / (hslMax / 6);
if (hue < hslMax / 2)
return n2;
if (hue < hslMax * 2 / 3)
return n1 + ((n2 - n1) * (hslMax * 2 / 3 - hue) + hslMax / 12) / (hslMax / 6);
else
return n1;
}
short hue = cast(short)hi;
short lum = cast(short)li;
short sat = cast(short)si;
short magic1,magic2;
Color3 ret;
if (sat == 0)
{
ret.set(l,l,l);
}
else
{
if (lum <= hslMax / 2)
magic2 = (lum * (hslMax + sat) + hslMax / 2) / hslMax;
else
magic2 = lum + sat - (lum * sat + hslMax / 2) / hslMax;
magic1 = 2 * lum - magic2;
ret.r = cast(float_t)(HueToRGB(magic1,magic2,hue + hslMax / 3) * rgbMax + hslMax / 2) / hslK / rgbK;
ret.g = cast(float_t)(HueToRGB(magic1,magic2,hue) * rgbMax + hslMax / 2) / hslK / rgbK;
ret.b = cast(float_t)(HueToRGB(magic1,magic2,hue - hslMax / 3) * rgbMax + hslMax / 2) / hslK / rgbK;
}
return ret;
}
}
bool equal(HSL a, HSL b, int relprec = defrelprec, int absprec = defabsprec)
{
HSL c;
c.set(a.h - b.h,a.s - b.s,a.l - b.l);
return .equal(c.h * c.h + c.s * c.s + c.l * c.l,0,relprec,absprec);
}
struct Color3
{
    align (1)
{
    float_t r;
    float_t g;
    float_t b;
}
    static 
{
    Color3 nan = {float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Color3 opCall(float_t r, float_t g, float_t b)
{
Color3 v;
v.set(r,g,b);
return v;
}
}
    static 
{
    Color3 opCall(uint src, ByteOrder order)
{
Color3 v;
v.set(src,order);
return v;
}
}
    void set(float_t r, float_t g, float_t b)
{
this.r = r;
this.g = g;
this.b = b;
}
    void set(uint src, ByteOrder order = ByteOrder.XRGB)
{
switch (order)
{
case ByteOrder.XRGB:
{
ri = (src & 16711680) >> 16;
gi = (src & 65280) >> 8;
bi = (src & 255) >> 0;
break;
}
case ByteOrder.XBGR:
{
bi = (src & 16711680) >> 16;
gi = (src & 65280) >> 8;
ri = (src & 255) >> 0;
break;
}
case ByteOrder.RGBX:
{
ri = (src & -16777216u) >>> 24;
gi = (src & 16711680) >>> 16;
bi = (src & 65280) >>> 8;
break;
}
case ByteOrder.BGRX:
{
bi = (src & -16777216u) >>> 24;
gi = (src & 16711680) >>> 16;
ri = (src & 65280) >>> 8;
break;
}
}
}
    bool isnormal()
{
return std.math.isnormal(r) && std.math.isnormal(g) && std.math.isnormal(b);
}
    int ri()
{
return cast(int)(r * rgbK);
}
    int gi()
{
return cast(int)(g * rgbK);
}
    int bi()
{
return cast(int)(b * rgbK);
}
    void ri(int r)
{
this.r = cast(float_t)r / rgbK;
}
    void gi(int g)
{
this.g = cast(float_t)g / rgbK;
}
    void bi(int b)
{
this.b = cast(float_t)b / rgbK;
}
    uint toUint(ByteOrder order)
{
assert(ri >= 0 && ri < 256);
assert(gi >= 0 && gi < 256);
assert(bi >= 0 && bi < 256);
switch (order)
{
case ByteOrder.XRGB:
{
return ri << 16 | gi << 8 | bi << 0;
}
case ByteOrder.XBGR:
{
return bi << 16 | gi << 8 | ri << 0;
}
case ByteOrder.RGBX:
{
return ri << 24 | gi << 16 | bi << 8;
}
case ByteOrder.BGRX:
{
return bi << 24 | gi << 16 | ri << 8;
}
}
return 0;
}
    HSL toHSL()
{
const short hslMax = cast(short)hslK;
const short rgbMax = cast(short)rgbK;
ubyte h,s,l;
ubyte cMax,cMin;
short rDelta,gDelta,bDelta;
short r = ri;
short g = gi;
short b = bi;
cMax = max(max(r,g),b);
cMin = min(min(r,g),b);
l = ((cMax + cMin) * hslMax + rgbMax) / (2 * rgbMax);
if (cMax == cMin)
{
h = (s = 0);
}
else
{
if (l <= hslMax / 2)
s = ((cMax - cMin) * hslMax + (cMax + cMin) / 2) / (cMax + cMin);
else
s = ((cMax - cMin) * hslMax + (2 * rgbMax - cMax - cMin) / 2) / (2 * rgbMax - cMax - cMin);
rDelta = ((cMax - r) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
gDelta = ((cMax - g) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
bDelta = ((cMax - b) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
if (r == cMax)
h = bDelta - gDelta;
else
if (g == cMax)
h = hslMax / 3 + rDelta - bDelta;
else
h = 2 * hslMax / 3 + gDelta - rDelta;
if (h < 0)
h += hslMax;
if (h > hslMax)
h -= hslMax;
}
HSL ret;
ret.hi = h;
ret.si = s;
ret.li = l;
return ret;
}
    float_t* ptr()
{
return cast(float_t*)this;
}
    bool opEquals(Color3 v)
{
return r == v.r && g == v.g && b == v.b;
}
    Color3 opNeg()
{
return Color3(-r,-g,-b);
}
    Color3 opAdd(Color3 v)
{
return Color3(r + v.r,g + v.g,b + v.b);
}
    void opAddAssign(Color3 v)
{
r += v.r;
g += v.g;
b += v.b;
}
    Color3 opSub(Color3 v)
{
return Color3(r - v.r,g - v.g,b - v.b);
}
    void opSubAssign(Color3 v)
{
r -= v.r;
g -= v.g;
b -= v.b;
}
    Color3 opMul(real k)
{
return Color3(r * k,g * k,b * k);
}
    void opMulAssign(real k)
{
r *= k;
g *= k;
b *= k;
}
    Color3 opMulr(real k)
{
return Color3(r * k,g * k,b * k);
}
    Color3 opDiv(real k)
{
return Color3(r / k,g / k,b / k);
}
    void opDivAssign(real k)
{
r /= k;
g /= k;
b /= k;
}
    void clampBelow(float_t inf = 0)
{
.clampBelow(r,inf);
.clampBelow(g,inf);
.clampBelow(b,inf);
}
    Color3 clampedBelow(float_t inf = 0)
{
Color3 ret = *this;
ret.clampBelow(inf);
return ret;
}
    void clampAbove(float_t sup = 1)
{
.clampAbove(r,sup);
.clampAbove(g,sup);
.clampAbove(b,sup);
}
    Color3 clampedAbove(float_t sup = 1)
{
Color3 ret = *this;
ret.clampBelow(sup);
return ret;
}
    void clamp(float_t inf = 0, float_t sup = 1)
{
clampBelow(inf);
clampAbove(sup);
}
    Color3 clamped(float_t inf = 0, float_t sup = 1)
{
Color3 ret = *this;
ret.clamp(inf,sup);
return ret;
}
    Color3f toColor3f()
{
return Color3f(cast(float)r,cast(float)g,cast(float)b);
}
    Color3d toColor3d()
{
return Color3d(cast(double)r,cast(double)g,cast(double)b);
}
    Color3r toColor3r()
{
return Color3r(cast(real)r,cast(real)g,cast(real)b);
}
    Color4 rgb0()
{
return Color4(r,g,b,0);
}
    Color4 rgb1()
{
return Color4(r,g,b,1);
}
}
bool equal(Color3 a, Color3 b, int relprec = defrelprec, int absprec = defabsprec)
{
Color3 c = a - b;
return .equal(c.r * c.r + c.g * c.g + c.b * c.b,0,relprec,absprec);
}
alias Lerp!(Color3).lerp lerp;
struct Color4
{
    align (1)
{
    float_t r;
    float_t g;
    float_t b;
    float_t a;
}
    static 
{
    Color4 nan = {float_t.nan,float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Color4 opCall(float_t r, float_t g, float_t b, float_t a)
{
Color4 v;
v.set(r,g,b,a);
return v;
}
}
    static 
{
    Color4 opCall(Color3 rgb, float_t a = 1)
{
Color4 v;
v.set(rgb,a);
return v;
}
}
    static 
{
    Color4 opCall(uint src, ByteOrder order)
{
Color4 v;
v.set(src,order);
return v;
}
}
    void set(float_t r, float_t g, float_t b, float_t a)
{
this.r = r;
this.g = g;
this.b = b;
this.a = a;
}
    void set(Color3 rgb, float_t a)
{
this.rgb = rgb;
this.a = a;
}
    void set(uint src, ByteOrder order = ByteOrder.ARGB)
{
switch (order)
{
case ByteOrder.ARGB:
{
ai = (src & -16777216u) >>> 24;
ri = (src & 16711680) >>> 16;
gi = (src & 65280) >>> 8;
bi = (src & 255) >>> 0;
break;
}
case ByteOrder.ABGR:
{
ai = (src & -16777216u) >>> 24;
bi = (src & 16711680) >>> 16;
gi = (src & 65280) >>> 8;
ri = (src & 255) >>> 0;
break;
}
case ByteOrder.RGBA:
{
ri = (src & -16777216u) >>> 24;
gi = (src & 16711680) >>> 16;
bi = (src & 65280) >>> 8;
ai = (src & 255) >>> 0;
break;
}
case ByteOrder.BGRA:
{
bi = (src & -16777216u) >>> 24;
gi = (src & 16711680) >>> 16;
ri = (src & 65280) >>> 8;
ai = (src & 255) >>> 0;
break;
}
}
}
    bool isnormal()
{
return std.math.isnormal(r) && std.math.isnormal(g) && std.math.isnormal(b) && std.math.isnormal(a);
}
    int ri()
{
return cast(int)(r * rgbK);
}
    int gi()
{
return cast(int)(g * rgbK);
}
    int bi()
{
return cast(int)(b * rgbK);
}
    int ai()
{
return cast(int)(a * rgbK);
}
    void ri(int r)
{
this.r = cast(float_t)r / rgbK;
}
    void gi(int g)
{
this.g = cast(float_t)g / rgbK;
}
    void bi(int b)
{
this.b = cast(float_t)b / rgbK;
}
    void ai(int a)
{
this.a = cast(float_t)a / rgbK;
}
    uint toUint(ByteOrder order)
{
assert(ri >= 0 && ri < 256);
assert(gi >= 0 && gi < 256);
assert(bi >= 0 && bi < 256);
assert(ai >= 0 && ai < 256);
switch (order)
{
case ByteOrder.ARGB:
{
return ai << 24 | ri << 16 | gi << 8 | bi << 0;
}
case ByteOrder.ABGR:
{
return ai << 24 | bi << 16 | gi << 8 | ri << 0;
}
case ByteOrder.RGBA:
{
return ri << 24 | gi << 16 | bi << 8 | ai << 0;
}
case ByteOrder.BGRA:
{
return bi << 24 | gi << 16 | ri << 8 | ai << 0;
}
}
return 0;
}
    HSL toHSL()
{
return rgb.toHSL();
}
    float_t* ptr()
{
return cast(float_t*)this;
}
    bool opEquals(Color4 v)
{
return r == v.r && g == v.g && b == v.b && a == v.a;
}
    Color4 opNeg()
{
return Color4(-r,-g,-b,-a);
}
    Color4 opAdd(Color4 v)
{
return Color4(r + v.r,g + v.g,b + v.b,a + v.a);
}
    void opAddAssign(Color4 v)
{
r += v.r;
g += v.g;
b += v.b;
a += v.a;
}
    Color4 opSub(Color4 v)
{
return Color4(r - v.r,g - v.g,b - v.b,a - v.a);
}
    void opSubAssign(Color4 v)
{
r -= v.r;
g -= v.g;
b -= v.b;
a -= v.a;
}
    Color4 opMul(real k)
{
return Color4(r * k,g * k,b * k,a * k);
}
    void opMulAssign(real k)
{
r *= k;
g *= k;
b *= k;
a *= k;
}
    Color4 opMulr(real k)
{
return Color4(r * k,g * k,b * k,a * k);
}
    Color4 opDiv(real k)
{
return Color4(r / k,g / k,b / k,a / k);
}
    void opDivAssign(real k)
{
r /= k;
g /= k;
b /= k;
a /= k;
}
    void clampBelow(float_t inf = 0)
{
.clampBelow(r,inf);
.clampBelow(g,inf);
.clampBelow(b,inf);
.clampBelow(a,inf);
}
    Color4 clampedBelow(float_t inf = 0)
{
Color4 ret = *this;
ret.clampBelow(inf);
return ret;
}
    void clampAbove(float_t sup = 1)
{
.clampAbove(r,sup);
.clampAbove(g,sup);
.clampAbove(b,sup);
.clampAbove(a,sup);
}
    Color4 clampedAbove(float_t sup = 1)
{
Color4 ret = *this;
ret.clampBelow(sup);
return ret;
}
    void clamp(float_t inf = 0, float_t sup = 1)
{
clampBelow(inf);
clampAbove(sup);
}
    Color4 clamped(float_t inf = 0, float_t sup = 1)
{
Color4 ret = *this;
ret.clamp(inf,sup);
return ret;
}
    Color4f toColor4f()
{
return Color4f(cast(float)r,cast(float)g,cast(float)b,cast(float)a);
}
    Color4d toColor4d()
{
return Color4d(cast(double)r,cast(double)g,cast(double)b,cast(double)a);
}
    Color4r toColor4r()
{
return Color4r(cast(real)r,cast(real)g,cast(real)b,cast(real)a);
}
    Color3 rgb()
{
return Color3(r,g,b);
}
    void rgb(Color3 rgb)
{
r = rgb.r;
g = rgb.g;
b = rgb.b;
}
}
bool equal(Color4 a, Color4 b, int relprec = defrelprec, int absprec = defabsprec)
{
Color4 c = a - b;
return .equal(c.r * c.r + c.g * c.g + c.b * c.b + c.a * c.a,0,relprec,absprec);
}
alias Lerp!(Color4).lerp lerp;
}
}
alias Color!(float).HSL HSLf;
alias Color!(float).Color3 Color3f;
alias Color!(float).Color4 Color4f;
alias Color!(float).equal equal;
alias Color!(float).lerp lerp;
alias Color!(double).HSL HSLd;
alias Color!(double).Color3 Color3d;
alias Color!(double).Color4 Color4d;
alias Color!(double).equal equal;
alias Color!(double).lerp lerp;
alias Color!(real).HSL HSLr;
alias Color!(real).Color3 Color3r;
alias Color!(real).Color4 Color4r;
alias Color!(real).equal equal;
alias Color!(real).lerp lerp;
alias Color!(auxd.helix.config.float_t).HSL HSL;
alias Color!(auxd.helix.config.float_t).Color3 Color3;
alias Color!(auxd.helix.config.float_t).Color4 Color4;
