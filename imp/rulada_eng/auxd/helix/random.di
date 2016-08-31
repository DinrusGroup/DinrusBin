// D import file generated from 'random.d'
module auxd.helix.random;
private 
{
    import auxd.helix.basic;
}
struct Rand48Engine
{
    const 
{
    static 
{
    uint min = 0;
}
}
    const 
{
    static 
{
    uint max = (uint).max;
}
}
    uint pop()
{
x = a * x + b & mask;
return x >> 16;
}
    void seed(ulong nx)
{
x = nx & mask;
}
    private 
{
    static const 
{
    ulong a = 25214903917L;
}
    static const 
{
    ulong b = 1L;
}
    static const 
{
    ulong m = 1LU << 48;
}
    static const 
{
    ulong mask = m - 1;
}
    ulong x = 0;
}
}
struct MersenneTwisterEngine
{
    static const 
{
    uint min = 0;
}
    static const 
{
    uint max = (uint).max;
}
    static const 
{
    uint n = 624;
}
    static const 
{
    uint m = 397;
}
    uint pop();
    void seed(uint x);
    private 
{
    uint[n] s = void;
    uint next = 0;
}
}
template UnitUniformEngine(BaseEngine,bool closedLeft,bool closedRight)
{
struct UnitUniformEngine
{
    private 
{
    BaseEngine baseEngine;
}
    const 
{
    static 
{
    real min = (closedLeft ? 0 : increment) * (1 / denominator);
    real max = (range + (closedLeft ? 0 : increment)) * (1 / denominator);
}
}
    private 
{
    const 
{
    static 
{
    real range = cast(real)(baseEngine.max - baseEngine.min);
    real increment = baseEngine.max > (uint).max ? 2L : 0.2L;
    real denominator = range + (closedLeft ? 0 : increment) + (closedRight ? 0 : increment);
}
}
}
    real pop()
{
auto x = baseEngine.pop();
static if(is(typeof(baseEngine.pop) : real) && cast(real)baseEngine.min == this.min && cast(real)baseEngine.max == this.max)
{
return cast(real)x;
}
else
{
return (cast(real)(x - baseEngine.min) + (closedLeft ? 0 : increment)) * (1 / denominator);
}

}
    void seed(uint x)
{
baseEngine.seed = x;
}
}
}
template HighresUnitUniformEngine(BaseEngine,bool closedLeft,bool closedRight)
{
struct HighresUnitUniformEngine
{
    private 
{
    BaseEngine baseEngine;
}
    static const 
{
    real min = (closedLeft ? 0 : increment) * (1 / denominator);
    real max = (rawMax + (closedLeft ? 0 : increment)) * (1 / denominator);
}
    private 
{
    const 
{
    static 
{
    real rawMax = (uint).max * 0x1p+32 + (uint).max;
    real increment = 2L;
    real denominator = rawMax + (closedLeft ? 0 : increment) + (closedRight ? 0 : increment);
}
}
}
    real pop()
{
static if(is(typeof(baseEngine.pop) : real) && cast(real)baseEngine.min == this.min && cast(real)baseEngine.max == this.max)
{
return cast(real)baseEngine.pop();
}
else
{
static assert(baseEngine.min == 0 && baseEngine.max == (uint).max);
uint a = cast(uint)baseEngine.pop();
uint b = cast(uint)baseEngine.pop();
return (a * 0x1p+32 + b + (closedLeft ? 0 : increment)) * (1 / denominator);
}

}
    void seed(uint x)
{
baseEngine.seed = x;
}
}
}
