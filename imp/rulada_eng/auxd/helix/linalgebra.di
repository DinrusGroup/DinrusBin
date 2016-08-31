// D import file generated from 'linalgebra.d'
module auxd.helix.linalgebra;
import std.math;
import std.string;
import auxd.helix.basic;
import auxd.helix.config;
enum Ort 
{
X,
Y,
Z,
W,
}
private 
{
    template LinearAlgebra(float_t)
{
private 
{
    alias auxd.helix.basic.equal equal;
}
alias .LinearAlgebra!(float).Vector2 Vector2f;
alias .LinearAlgebra!(float).Vector3 Vector3f;
alias .LinearAlgebra!(float).Vector4 Vector4f;
alias .LinearAlgebra!(float).Quaternion Quaternionf;
alias .LinearAlgebra!(float).Matrix22 Matrix22f;
alias .LinearAlgebra!(float).Matrix33 Matrix33f;
alias .LinearAlgebra!(float).Matrix44 Matrix44f;
alias .LinearAlgebra!(double).Vector2 Vector2d;
alias .LinearAlgebra!(double).Vector3 Vector3d;
alias .LinearAlgebra!(double).Vector4 Vector4d;
alias .LinearAlgebra!(double).Quaternion Quaterniond;
alias .LinearAlgebra!(double).Matrix22 Matrix22d;
alias .LinearAlgebra!(double).Matrix33 Matrix33d;
alias .LinearAlgebra!(double).Matrix44 Matrix44d;
alias .LinearAlgebra!(real).Vector2 Vector2r;
alias .LinearAlgebra!(real).Vector3 Vector3r;
alias .LinearAlgebra!(real).Vector4 Vector4r;
alias .LinearAlgebra!(real).Quaternion Quaternionr;
alias .LinearAlgebra!(real).Matrix22 Matrix22r;
alias .LinearAlgebra!(real).Matrix33 Matrix33r;
alias .LinearAlgebra!(real).Matrix44 Matrix44r;
struct Vector2
{
    enum 
{
length = 2u,
}
    align (1)
{
    float_t x;
    float_t y;
}
    static 
{
    Vector2 nan = {float_t.nan,float_t.nan};
}
    static 
{
    Vector2 zero = {0,0};
}
    static 
{
    Vector2 unitX = {1,0};
}
    static 
{
    Vector2 unitY = {0,1};
}
    static 
{
    Vector2 opCall(float_t x, float_t y)
{
Vector2 v;
v.set(x,y);
return v;
}
}
    static 
{
    Vector2 opCall(float_t[2] p)
{
Vector2 v;
v.set(p);
return v;
}
}
    void set(float_t x, float_t y)
{
this.x = x;
this.y = y;
}
    void set(float_t[2] p)
{
this.x = p[0];
this.y = p[1];
}
    real norm()
{
return hypot(x,y);
}
    real normSquare()
{
return x * x + y * y;
}
    real normalize()
{
real len = norm();
*this /= len;
return len;
}
    Vector2 normalized()
{
real n = norm;
return Vector2(x / n,y / n);
}
    bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),1,relprec,absprec);
}
    Ort dominatingAxis()
{
return x > y ? Ort.X : Ort.Y;
}
    bool isnormal()
{
return std.math.isnormal(x) && std.math.isnormal(y);
}
    float_t* ptr()
{
return cast(float_t*)this;
}
    float_t opIndex(size_t ort)
in
{
assert(ort <= Ort.Y);
}
body
{
return ptr[cast(int)ort];
}
    void opIndexAssign(float_t value, size_t ort)
in
{
assert(ort <= Ort.Y);
}
body
{
ptr[cast(int)ort] = value;
}
    bool opEquals(Vector2 v)
{
return x == v.x && y == v.y;
}
    Vector2 opNeg()
{
return Vector2(-x,-y);
}
    Vector2 opAdd(Vector2 v)
{
return Vector2(x + v.x,y + v.y);
}
    void opAddAssign(Vector2 v)
{
x += v.x;
y += v.y;
}
    Vector2 opSub(Vector2 v)
{
return Vector2(x - v.x,y - v.y);
}
    void opSubAssign(Vector2 v)
{
x -= v.x;
y -= v.y;
}
    Vector2 opMul(real k)
{
return Vector2(x * k,y * k);
}
    void opMulAssign(real k)
{
x *= k;
y *= k;
}
    Vector2 opMul_r(real k)
{
return Vector2(x * k,y * k);
}
    Vector2 opDiv(real k)
{
return Vector2(x / k,y / k);
}
    void opDivAssign(real k)
{
x /= k;
y /= k;
}
    Vector2 perp()
{
return Vector2(-y,x);
}
    Vector2f toVector2f()
{
return Vector2f(cast(float)x,cast(float)y);
}
    Vector2d toVector2d()
{
return Vector2d(cast(double)x,cast(double)y);
}
    Vector2r toVector2r()
{
return Vector2r(cast(real)x,cast(real)y);
}
    Vector3 xy0()
{
return Vector3(x,y,0);
}
    Vector3 x0y()
{
return Vector3(x,0,y);
}
    char[] toString()
{
return format("[",x,", ",y,"]");
}
}
public 
{
    real dot(Vector2 a, Vector2 b)
{
return a.x * b.x + a.y * b.y;
}
    Matrix22 outer(Vector2 a, Vector2 b)
{
return Matrix22(a.x * b.x,a.x * b.y,a.y * b.x,a.y * b.y);
}
    real cross(Vector2 a, Vector2 b)
{
return a.x * b.y - b.x * a.y;
}
    alias EqualityByNorm!(Vector2).equal equal;
    alias Lerp!(Vector2).lerp lerp;
}
struct Vector3
{
    enum 
{
length = 3u,
}
    align (1)
{
    float_t x;
    float_t y;
    float_t z;
}
    static 
{
    Vector3 nan = {float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Vector3 zero = {0,0,0};
}
    static 
{
    Vector3 unitX = {1,0,0};
}
    static 
{
    Vector3 unitY = {0,1,0};
}
    static 
{
    Vector3 unitZ = {0,0,1};
}
    static 
{
    Vector3 opCall(float_t x, float_t y, float_t z)
{
Vector3 v;
v.set(x,y,z);
return v;
}
}
    static 
{
    Vector3 opCall(float_t[3] p)
{
Vector3 v;
v.set(p);
return v;
}
}
    void set(float_t x, float_t y, float_t z)
{
this.x = x;
this.y = y;
this.z = z;
}
    void set(float_t[3] p)
{
this.x = p[0];
this.y = p[1];
this.z = p[2];
}
    real norm()
{
return sqrt(x * x + y * y + z * z);
}
    real normSquare()
{
return x * x + y * y + z * z;
}
    real normalize()
{
real len = norm();
*this /= len;
return len;
}
    Vector3 normalized()
{
real n = norm;
return Vector3(x / n,y / n,z / n);
}
    bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),1,relprec,absprec);
}
    Ort dominatingAxis()
{
if (x > y)
return x > z ? Ort.X : Ort.Z;
else
return y > z ? Ort.Y : Ort.Z;
}
    bool isnormal()
{
return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z);
}
    float_t* ptr()
{
return cast(float_t*)&x;
}
    float_t opIndex(size_t ort)
in
{
assert(ort <= Ort.Z);
}
body
{
return ptr[cast(int)ort];
}
    void opIndexAssign(float_t value, size_t ort)
in
{
assert(ort <= Ort.Z);
}
body
{
ptr[cast(int)ort] = value;
}
    bool opEquals(Vector3 v)
{
return x == v.x && y == v.y && z == v.z;
}
    Vector3 opNeg()
{
return Vector3(-x,-y,-z);
}
    Vector3 opAdd(Vector3 v)
{
return Vector3(x + v.x,y + v.y,z + v.z);
}
    void opAddAssign(Vector3 v)
{
x += v.x;
y += v.y;
z += v.z;
}
    Vector3 opSub(Vector3 v)
{
return Vector3(x - v.x,y - v.y,z - v.z);
}
    void opSubAssign(Vector3 v)
{
x -= v.x;
y -= v.y;
z -= v.z;
}
    Vector3 opMul(real k)
{
return Vector3(x * k,y * k,z * k);
}
    void opMulAssign(real k)
{
x *= k;
y *= k;
z *= k;
}
    Vector3 opMul_r(real k)
{
return Vector3(x * k,y * k,z * k);
}
    Vector3 opDiv(real k)
{
return Vector3(x / k,y / k,z / k);
}
    void opDivAssign(real k)
{
x /= k;
y /= k;
z /= k;
}
    Vector3f toVector3f()
{
return Vector3f(cast(float)x,cast(float)y,cast(float)z);
}
    Vector3d toVector3d()
{
return Vector3d(cast(double)x,cast(double)y,cast(double)z);
}
    Vector3r toVector3r()
{
return Vector3r(cast(real)x,cast(real)y,cast(real)z);
}
    Vector4 xyz0()
{
return Vector4(x,y,z,0);
}
    Vector4 xyz1()
{
return Vector4(x,y,z,1);
}
    Vector2 xy()
{
return Vector2(x,y);
}
    Vector2 xz()
{
return Vector2(x,z);
}
    void xy(Vector2 v)
{
x = v.x;
y = v.y;
}
    void xz(Vector2 v)
{
x = v.x;
z = v.y;
}
    char[] toString()
{
return format("[",x,", ",y,", ",z,"]");
}
}
public 
{
    real dot(Vector3 a, Vector3 b)
{
return a.x * b.x + a.y * b.y + a.z * b.z;
}
    Matrix33 outer(Vector3 a, Vector3 b)
{
return Matrix33(a.x * b.x,a.x * b.y,a.x * b.z,a.y * b.x,a.y * b.y,a.y * b.z,a.z * b.x,a.z * b.y,a.z * b.z);
}
    Vector3 cross(Vector3 a, Vector3 b)
{
return Vector3(a.y * b.z - b.y * a.z,a.z * b.x - b.z * a.x,a.x * b.y - b.x * a.y);
}
    bool isBasisOrthogonal(Vector3 r, Vector3 s, Vector3 t, int relprec = defrelprec, int absprec = defabsprec)
{
return equal(cross(r,cross(s,t)).normSquare,0,relprec,absprec);
}
    bool isBasisOrthonormal(Vector3 r, Vector3 s, Vector3 t, int relprec = defrelprec, int absprec = defabsprec)
{
return isBasisOrthogonal(r,s,t,relprec,absprec) && r.isUnit(relprec,absprec) && s.isUnit(relprec,absprec) && t.isUnit(relprec,absprec);
}
    alias EqualityByNorm!(Vector3).equal equal;
    alias Lerp!(Vector3).lerp lerp;
}
struct Vector4
{
    enum 
{
length = 4u,
}
    align (1)
{
    float_t x;
    float_t y;
    float_t z;
    float_t w;
}
    static 
{
    Vector4 nan = {float_t.nan,float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Vector4 zero = {0,0,0,0};
}
    static 
{
    Vector4 unitX = {1,0,0,0};
}
    static 
{
    Vector4 unitY = {0,1,0,0};
}
    static 
{
    Vector4 unitZ = {0,0,1,0};
}
    static 
{
    Vector4 unitW = {0,0,0,1};
}
    static 
{
    Vector4 opCall(float_t x, float_t y, float_t z, float_t w)
{
Vector4 v;
v.set(x,y,z,w);
return v;
}
}
    static 
{
    Vector4 opCall(Vector3 xyz, float_t w)
{
Vector4 v;
v.set(xyz,w);
return v;
}
}
    static 
{
    Vector4 opCall(float_t[4] p)
{
Vector4 v;
v.set(p);
return v;
}
}
    void set(float_t x, float_t y, float_t z, float_t w)
{
this.x = x;
this.y = y;
this.z = z;
this.w = w;
}
    void set(Vector3 xyz, float_t w)
{
this.x = xyz.x;
this.y = xyz.y;
this.z = xyz.z;
this.w = w;
}
    void set(float_t[4] p)
{
this.x = p[0];
this.y = p[1];
this.z = p[2];
this.w = p[3];
}
    real norm()
{
return sqrt(x * x + y * y + z * z + w * w);
}
    real normSquare()
{
return x * x + y * y + z * z + w * w;
}
    real normalize()
{
real len = norm();
*this /= len;
return len;
}
    Vector4 normalized()
{
real n = norm;
return Vector4(x / n,y / n,z / n,w / n);
}
    bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare,1,relprec,absprec);
}
    Ort dominatingAxis()
{
if (x > y)
{
if (x > z)
return x > w ? Ort.X : Ort.W;
else
return z > w ? Ort.Z : Ort.W;
}
else
{
if (y > z)
return y > w ? Ort.Y : Ort.W;
else
return z > w ? Ort.Z : Ort.W;
}
}
    bool isnormal()
{
return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z) && std.math.isnormal(w);
}
    float_t* ptr()
{
return cast(float_t*)&x;
}
    float_t opIndex(size_t ort)
in
{
assert(ort <= Ort.W);
}
body
{
return ptr[cast(int)ort];
}
    void opIndexAssign(float_t value, size_t ort)
in
{
assert(ort <= Ort.W);
}
body
{
ptr[cast(int)ort] = value;
}
    bool opEquals(Vector4 v)
{
return x == v.x && y == v.y && z == v.z && w == v.w;
}
    Vector4 opNeg()
{
return Vector4(-x,-y,-z,-w);
}
    Vector4 opAdd(Vector4 v)
{
return Vector4(x + v.x,y + v.y,z + v.z,w + v.w);
}
    void opAddAssign(Vector4 v)
{
x += v.x;
y += v.y;
z += v.z;
w += v.w;
}
    Vector4 opSub(Vector4 v)
{
return Vector4(x - v.x,y - v.y,z - v.z,w - v.w);
}
    void opSubAssign(Vector4 v)
{
x -= v.x;
y -= v.y;
z -= v.z;
w -= v.w;
}
    Vector4 opMul(real k)
{
return Vector4(x * k,y * k,z * k,w * k);
}
    void opMulAssign(real k)
{
x *= k;
y *= k;
z *= k;
w *= k;
}
    Vector4 opMul_r(real k)
{
return Vector4(x * k,y * k,z * k,w * k);
}
    Vector4 opDiv(real k)
{
return Vector4(x / k,y / k,z / k,w / k);
}
    void opDivAssign(real k)
{
x /= k;
y /= k;
z /= k;
w /= k;
}
    Vector4f toVector4f()
{
return Vector4f(cast(float)x,cast(float)y,cast(float)z,cast(float)w);
}
    Vector4d toVector4d()
{
return Vector4d(cast(double)x,cast(double)y,cast(double)z,cast(double)w);
}
    Vector4r toVector4r()
{
return Vector4r(cast(real)x,cast(real)y,cast(real)z,cast(real)w);
}
    Vector3 xyz()
{
return Vector3(x,y,z);
}
    void xyz(Vector3 v)
{
x = v.x;
y = v.y;
z = v.z;
}
    char[] toString()
{
return format("[",x,", ",y,", ",z,", ",w,"]");
}
}
public 
{
    real dot(Vector4 a, Vector4 b)
{
return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
}
    Matrix44 outer(Vector4 a, Vector4 b)
{
return Matrix44(a.x * b.x,a.x * b.y,a.x * b.z,a.x * b.w,a.y * b.x,a.y * b.y,a.y * b.z,a.y * b.w,a.z * b.x,a.z * b.y,a.z * b.z,a.z * b.w,a.w * b.x,a.w * b.y,a.w * b.z,a.w * b.w);
}
    alias EqualityByNorm!(Vector4).equal equal;
    alias Lerp!(Vector4).lerp lerp;
}
struct Quaternion
{
    align (1)
{
    union
{
struct
{
float_t x;
float_t y;
float_t z;
}
Vector3 vector;
}
    union
{
float_t w;
float_t scalar;
}
}
    static 
{
    Quaternion identity;
}
    static 
{
    Quaternion nan = {x:float_t.nan,y:float_t.nan,z:float_t.nan,w:float_t.nan};
}
    static 
{
    Quaternion opCall(float_t x, float_t y, float_t z, float_t w)
{
Quaternion q;
q.set(x,y,z,w);
return q;
}
}
    static 
{
    Quaternion opCall(Vector3 vector, float_t scalar)
{
Quaternion q;
q.set(vector,scalar);
return q;
}
}
    static 
{
    Quaternion opCall(Matrix33 mat)
{
Quaternion q;
q.set(mat);
return q;
}
}
    void set(float_t x, float_t y, float_t z, float_t w)
{
this.x = x;
this.y = y;
this.z = z;
this.w = w;
}
    void set(Vector3 vector, float_t scalar)
{
this.vector = vector;
this.scalar = scalar;
}
    void set(Matrix33 mat)
in
{
assert(mat.isRotation());
}
body
{
real trace = mat[0,0] + mat[1,1] + mat[2,2];
real root;
if (trace > 0)
{
root = sqrt(trace + 1);
w = 0.5 * root;
root = 0.5 / root;
x = (mat[2,1] - mat[1,2]) * root;
y = (mat[0,2] - mat[2,0]) * root;
z = (mat[1,0] - mat[0,1]) * root;
}
else
{
static int[3] next = [1,2,0];
int i = 0;
if (mat[1,1] > mat[0,0])
i = 1;
if (mat[2,2] > mat[i,i])
i = 2;
int j = next[i];
int k = next[j];
root = sqrt(mat[i,i] - mat[j,j] - mat[k,k] + 1);
*(&x + i) = 0.5 * root;
root = 0.5 / root;
w = (mat[k,j] - mat[j,k]) * root;
*(&x + j) = (mat[j,i] + mat[i,j]) * root;
*(&x + k) = (mat[k,i] + mat[i,k]) * root;
}
}
    static 
{
    Quaternion rotationX(float_t radians)
{
Quaternion q;
float_t s = sin(radians * 0.5F);
float_t c = cos(radians * 0.5F);
q.x = s;
q.y = 0;
q.z = 0;
q.w = c;
return q;
}
}
    static 
{
    Quaternion rotationY(float_t radians)
{
Quaternion q;
float_t s = sin(radians * 0.5F);
float_t c = cos(radians * 0.5F);
q.x = 0;
q.y = s;
q.z = 0;
q.w = c;
return q;
}
}
    static 
{
    Quaternion rotationZ(float_t radians)
{
Quaternion q;
float_t s = sin(radians * 0.5F);
float_t c = cos(radians * 0.5F);
q.x = 0;
q.y = 0;
q.z = s;
q.w = c;
return q;
}
}
    static 
{
    Quaternion rotation(float_t yaw, float_t pitch, float_t roll)
{
return Quaternion.rotationY(yaw) * Quaternion.rotationX(pitch) * Quaternion.rotationZ(roll);
}
}
    static 
{
    Quaternion rotation(Vector3 axis, float_t radians)
{
Quaternion q;
float_t s = sin(radians * 0.5F);
float_t c = cos(radians * 0.5F);
q.x = axis.x * s;
q.y = axis.y * s;
q.z = axis.z * s;
q.w = c;
return q;
}
}
    real norm()
{
return sqrt(x * x + y * y + z * z + w * w);
}
    real normSquare()
{
return x * x + y * y + z * z + w * w;
}
    real normalize()
{
float_t n = norm();
assert(greater(n,0));
*this /= n;
return n;
}
    Quaternion normalized()
{
float_t n = norm();
assert(greater(n,0));
return Quaternion(x / n,y / n,z / n,w / n);
}
    bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),1,relprec,absprec);
}
    Quaternion conj()
{
return Quaternion(-vector,scalar);
}
    void invert()
{
float_t n = norm();
assert(greater(n,0));
vector = -vector / n;
scalar = scalar / n;
}
    Quaternion inverse()
{
float_t n = norm();
assert(greater(n,0));
return conj / n;
}
    real yaw()
{
return atan2(2 * (w * y + x * z),w * w - x * x - y * y + z * z);
}
    real pitch()
{
return asin(2 * (w * x - y * z));
}
    real roll()
{
return atan2(2 * (w * z + x * y),w * w - x * x + y * y - z * z);
}
    bool isnormal()
{
return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z) && std.math.isnormal(w);
}
    float_t* ptr()
{
return cast(float_t*)&x;
}
    float_t opIndex(size_t ort)
in
{
assert(ort <= Ort.W);
}
body
{
return (cast(float_t*)this)[cast(int)ort];
}
    void opIndexAssign(float_t value, size_t ort)
in
{
assert(ort <= Ort.W);
}
body
{
(cast(float_t*)this)[cast(int)ort] = value;
}
    bool opEquals(Quaternion q)
{
return x == q.x && y == q.y && z == q.z && w == q.w;
}
    Quaternion opNeg()
{
return Quaternion(-x,-y,-z,-w);
}
    Quaternion opAdd(Quaternion q)
{
return Quaternion(x + q.x,y + q.y,z + q.z,w + q.w);
}
    void opAddAssign(Quaternion q)
{
x += q.x;
y += q.y;
z += q.z;
w += q.w;
}
    Quaternion opSub(Quaternion q)
{
return Quaternion(x - q.x,y - q.y,z - q.z,w - q.w);
}
    void opSubAssign(Quaternion q)
{
x -= q.x;
y -= q.y;
z -= q.z;
w -= q.w;
}
    Quaternion opMul(float_t k)
{
return Quaternion(x * k,y * k,z * k,w * k);
}
    Quaternion opMul_r(float_t k)
{
return Quaternion(x * k,y * k,z * k,w * k);
}
    Quaternion opDiv(float_t k)
{
return Quaternion(x / k,y / k,z / k,w / k);
}
    void opDivAssign(float_t k)
{
x /= k;
y /= k;
z /= k;
w /= k;
}
    Quaternion opMul(Quaternion q)
{
return Quaternion(w * q.x + x * q.w + y * q.z - z * q.y,w * q.y + y * q.w + z * q.x - x * q.z,w * q.z + z * q.w + x * q.y - y * q.x,w * q.w - x * q.x - y * q.y - z * q.z);
}
    void opMulAssign(Quaternion q)
{
set(w * q.x + x * q.w + y * q.z - z * q.y,w * q.y + y * q.w + z * q.x - x * q.z,w * q.z + z * q.w + x * q.y - y * q.x,w * q.w - x * q.x - y * q.y - z * q.z);
}
    Quaternionf toQuaternionf()
{
return Quaternionf(cast(float)x,cast(float)y,cast(float)z,cast(float)w);
}
    Quaterniond toQuaterniond()
{
return Quaterniond(cast(double)x,cast(double)y,cast(double)z,cast(double)w);
}
    Quaternionr toQuaternionr()
{
return Quaternionr(cast(real)x,cast(real)y,cast(real)z,cast(real)w);
}
    char[] toString()
{
return format("[",x,", ",y,", ",z,", ",w,"]");
}
}
alias EqualityByNorm!(Quaternion).equal equal;
alias Lerp!(Quaternion).lerp lerp;
Quaternion slerp(Quaternion q0, Quaternion q1, real t)
{
real cosTheta = q0.x * q1.x + q0.y * q1.y + q0.z * q1.z + q0.w * q1.w;
real theta = acos(cosTheta);
if (equal(fabs(theta),0))
return lerp(q0,q1,t);
real sinTheta = sin(theta);
real coeff0 = sin((1 - t) * theta) / sinTheta;
real coeff1 = sin(t * theta) / sinTheta;
if (cosTheta < 0F)
{
coeff0 = -coeff0;
Quaternion ret = coeff0 * q0 + coeff1 * q1;
return ret.normalized();
}
return coeff0 * q0 + coeff1 * q1;
}
struct Matrix22
{
    align (1)
{
    union
{
struct
{
float_t m00;
float_t m10;
float_t m01;
float_t m11;
}
float_t[2][2] m;
Vector2[2] v;
float_t[4] a;
}
}
    static 
{
    Matrix22 identity = {1,0,0,1};
}
    static 
{
    Matrix22 nan = {float_t.nan,float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Matrix22 zero = {0,0,0,0};
}
    static 
{
    Matrix22 opCall(float_t m00, float_t m01, float_t m10, float_t m11)
{
Matrix22 mat;
mat.m00 = m00;
mat.m01 = m01;
mat.m10 = m10;
mat.m11 = m11;
return mat;
}
}
    static 
{
    Matrix22 opCall(float_t[4] a)
{
Matrix22 mat;
mat.a[0..4] = a[0..4].dup;
return mat;
}
}
    static 
{
    Matrix22 opCall(Vector2 basisX, Vector2 basisY)
{
Matrix22 mat;
mat.v[0] = basisX;
mat.v[1] = basisY;
return mat;
}
}
    void set(float_t m00, float_t m01, float_t m10, float_t m11)
{
this.m00 = m00;
this.m01 = m01;
this.m10 = m10;
this.m11 = m11;
}
    void set(float_t[4] a)
{
this.a[0..4] = a[0..4].dup;
}
    void set(Vector2 basisX, Vector2 basisY)
{
v[0] = basisX;
v[1] = basisY;
}
    bool isnormal()
{
return std.math.isnormal(m00) && std.math.isnormal(m01) && std.math.isnormal(m10) && std.math.isnormal(m11);
}
    bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(*this,identity,relprec,absprec);
}
    bool isZero(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),0,relprec,absprec);
}
    bool isOrthogonal(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(abs(cross(v[0],v[1])),1,relprec,absprec);
}
    bool isRotation(int relprec = defrelprec, int absprec = defabsprec)
{
return isOrthogonal(relprec,absprec);
}
    static 
{
    Matrix22 scale(float_t x, float_t y)
{
Matrix22 mat = identity;
with (mat)
{
m00 = x;
m11 = y;
}
return mat;
}
}
    static 
{
    Matrix22 scale(Vector2 v)
{
return scale(v.x,v.y);
}
}
    static 
{
    Matrix22 rotation(float_t radians)
{
Matrix22 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m00 = (m11 = c);
m10 = s;
m01 = -s;
}
return mat;
}
}
    Matrix22 inverse()
{
Matrix22 mat;
mat.m00 = m11;
mat.m01 = -m01;
mat.m10 = -m10;
mat.m11 = m00;
real det = m00 * m11 - m01 * m10;
{
for (int i = 4;
 i--;)
{
mat.a[i] /= det;
}
}
return mat;
}
    void invert()
{
real idet = 1 / (m00 * m11 - m01 * m10);
swap(m00,m11);
m10 = -m10;
m01 = -m01;
*this *= idet;
}
    real determinant()
{
return m00 * m11 - m10 * m01;
}
    real norm()
{
return sqrt(normSquare);
}
    real normSquare()
{
real ret = 0;
{
for (int i = 4;
 i--;)
{
{
real x = a[i];
ret += x * x;
}
}
}
return ret;
}
    void transpose()
{
swap(m01,m10);
}
    Matrix22 transposed()
{
return Matrix22(m00,m10,m01,m11);
}
    void polarDecomposition(out Matrix22 Q, out Matrix22 S)
out
{
assert(Q.isRotation(),"(postcondition) Q not a rotation:\x0a" ~ Q.toString);
}
body
{
if (determinant < 0)
Q = *this * -identity;
else
Q = *this;
int maxIterations = 100;
Matrix22 Qp = Q;
Q = 0.5F * (Q + Q.transposed.inverse);
while (!(Q - Qp).isZero && maxIterations--)
{
Matrix22 Qinv = Q.inverse;
real gamma = sqrt(Qinv.norm / Q.norm);
Qp = Q;
Q = 0.5F * (gamma * Q + 1 / gamma * Qinv.transposed);
}
assert(maxIterations != -1);
S = Q.transposed * *this;
}
    Matrix22 opNeg()
{
return Matrix22(-m00,-m01,-m10,-m11);
}
    Matrix22 opAdd(Matrix22 mat)
{
return Matrix22(m00 + mat.m00,m01 + mat.m01,m10 + mat.m10,m11 + mat.m11);
}
    void opAddAssign(Matrix22 mat)
{
m00 += mat.m00;
m01 += mat.m01;
m10 += mat.m10;
m11 += mat.m11;
}
    Matrix22 opSub(Matrix22 mat)
{
return Matrix22(m00 - mat.m00,m01 - mat.m01,m10 - mat.m10,m11 - mat.m11);
}
    void opSubAssign(Matrix22 mat)
{
m00 -= mat.m00;
m01 -= mat.m01;
m10 -= mat.m10;
m11 -= mat.m11;
}
    Matrix22 opMul(float_t k)
{
return Matrix22(m00 * k,m01 * k,m10 * k,m11 * k);
}
    void opMulAssign(float_t k)
{
m00 *= k;
m01 *= k;
m10 *= k;
m11 *= k;
}
    Matrix22 opMul_r(float_t k)
{
return Matrix22(m00 * k,m01 * k,m10 * k,m11 * k);
}
    Matrix22 opDiv(float_t k)
{
return Matrix22(m00 / k,m01 / k,m10 / k,m11 / k);
}
    void opDivAssign(float_t k)
{
m00 /= k;
m01 /= k;
m10 /= k;
m11 /= k;
}
    bool opEquals(Matrix22 mat)
{
return m00 == mat.m00 && m01 == mat.m01 && m10 == mat.m10 && m11 == mat.m11;
}
    Matrix22 opMul(Matrix22 mat)
{
return Matrix22(m00 * mat.m00 + m01 * mat.m10,m00 * mat.m01 + m01 * mat.m11,m10 * mat.m00 + m11 * mat.m10,m10 * mat.m01 + m11 * mat.m11);
}
    void opMulAssign(Matrix22 mat)
{
*this = *this * mat;
}
    Vector2 opMul(Vector2 v)
{
return Vector2(v.x * m00 + v.y * m01,v.x * m10 + v.y * m11);
}
    float_t opIndex(uint row, uint col)
in
{
assert(row < 2 && col < 2);
}
body
{
return m[col][row];
}
    void opIndexAssign(float_t f, uint row, uint col)
in
{
assert(row < 2 && col < 2);
}
body
{
m[col][row] = f;
}
    Vector2 opIndex(uint col)
in
{
assert(col < 2);
}
body
{
return v[col];
}
    void opIndexAssign(Vector2 v, uint col)
in
{
assert(col < 2);
}
body
{
return this.v[col] = v;
}
    float_t* ptr()
{
return a.ptr;
}
    Matrix22f toMatrix22f()
{
return Matrix22f(cast(float)m00,cast(float)m01,cast(float)m10,cast(float)m11);
}
    Matrix22d toMatrix22d()
{
return Matrix22d(cast(double)m00,cast(double)m01,cast(double)m10,cast(double)m11);
}
    Matrix22r toMatrix22r()
{
return Matrix22r(cast(real)m00,cast(real)m01,cast(real)m10,cast(real)m11);
}
    char[] toString()
{
return format("[",m00,", ",m01,",\x0a"," ",m10,", ",m11,"]");
}
}
alias EqualityByNorm!(Matrix22).equal equal;
alias Lerp!(Matrix22).lerp lerp;
struct Matrix33
{
    align (1)
{
    union
{
struct
{
float_t m00;
float_t m10;
float_t m20;
float_t m01;
float_t m11;
float_t m21;
float_t m02;
float_t m12;
float_t m22;
}
float_t[3][3] m;
Vector3[3] v;
float_t[9] a;
}
}
    static 
{
    Matrix33 identity = {1,0,0,0,1,0,0,0,1};
}
    static 
{
    Matrix33 nan = {float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Matrix33 zero = {0,0,0,0,0,0,0,0,0};
}
    static 
{
    Matrix33 opCall(float_t m00, float_t m01, float_t m02, float_t m10, float_t m11, float_t m12, float_t m20, float_t m21, float_t m22)
{
Matrix33 mat;
mat.m00 = m00;
mat.m01 = m01;
mat.m02 = m02;
mat.m10 = m10;
mat.m11 = m11;
mat.m12 = m12;
mat.m20 = m20;
mat.m21 = m21;
mat.m22 = m22;
return mat;
}
}
    static 
{
    Matrix33 opCall(float_t[9] a)
{
Matrix33 mat;
mat.a[0..9] = a[0..9].dup;
return mat;
}
}
    static 
{
    Matrix33 opCall(Vector3 basisX, Vector3 basisY, Vector3 basisZ)
{
Matrix33 mat;
mat.v[0] = basisX;
mat.v[1] = basisY;
mat.v[2] = basisZ;
return mat;
}
}
    void set(float_t m00, float_t m01, float_t m02, float_t m10, float_t m11, float_t m12, float_t m20, float_t m21, float_t m22)
{
this.m00 = m00;
this.m01 = m01;
this.m02 = m02;
this.m10 = m10;
this.m11 = m11;
this.m12 = m12;
this.m20 = m20;
this.m21 = m21;
this.m22 = m22;
}
    void set(float_t[9] a)
{
this.a[0..9] = a[0..9].dup;
}
    void set(Vector3 basisX, Vector3 basisY, Vector3 basisZ)
{
v[0] = basisX;
v[1] = basisY;
v[2] = basisZ;
}
    bool isnormal()
{
return std.math.isnormal(m00) && std.math.isnormal(m01) && std.math.isnormal(m02) && std.math.isnormal(m10) && std.math.isnormal(m11) && std.math.isnormal(m12) && std.math.isnormal(m20) && std.math.isnormal(m21) && std.math.isnormal(m22);
}
    bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(*this,identity,relprec,absprec);
}
    bool isZero(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),0,relprec,absprec);
}
    bool isOrthogonal(int relprec = defrelprec, int absprec = defabsprec)
{
return isBasisOrthonormal(v[0],v[1],v[2],relprec,absprec);
}
    bool isRotation(int relprec = defrelprec, int absprec = defabsprec)
{
return isOrthogonal(relprec,absprec) && equal(v[2],cross(v[0],v[1]),relprec,absprec);
}
    static 
{
    Matrix33 scale(float_t x, float_t y, float_t z)
{
Matrix33 mat = identity;
with (mat)
{
m00 = x;
m11 = y;
m22 = z;
}
return mat;
}
}
    static 
{
    Matrix33 scale(Vector3 v)
{
return scale(v.x,v.y,v.z);
}
}
    static 
{
    Matrix33 rotationX(float_t radians)
{
Matrix33 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m11 = (m22 = c);
m21 = s;
m12 = -s;
}
return mat;
}
}
    static 
{
    Matrix33 rotationY(float_t radians)
{
Matrix33 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m00 = (m22 = c);
m20 = -s;
m02 = s;
}
return mat;
}
}
    static 
{
    Matrix33 rotationZ(float_t radians)
{
Matrix33 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m00 = (m11 = c);
m10 = s;
m01 = -s;
}
return mat;
}
}
    static 
{
    Matrix33 rotation(float_t yaw, float_t pitch, float_t roll)
{
return Matrix33.rotationY(yaw) * Matrix33.rotationX(pitch) * Matrix33.rotationZ(roll);
}
}
    static 
{
    Matrix33 rotation(Vector3 axis, float_t radians)
in
{
assert(axis.isUnit());
}
body
{
real c = cos(radians);
real s = sin(radians);
real cc = 1 - c;
real x2 = axis.x * axis.x;
real y2 = axis.y * axis.y;
real z2 = axis.z * axis.z;
real xycc = axis.x * axis.y * cc;
real xzcc = axis.x * axis.z * cc;
real yzcc = axis.y * axis.z * cc;
real xs = axis.x * s;
real ys = axis.y * s;
real zs = axis.z * s;
Matrix33 mat;
with (mat)
{
m00 = x2 * cc + c;
m01 = xycc - zs;
m02 = xzcc + ys;
m10 = xycc + zs;
m11 = y2 * cc + c;
m12 = yzcc - xs;
m20 = xzcc - ys;
m21 = yzcc + xs;
m22 = z2 * cc + c;
}
return mat;
}
}
    static 
{
    Matrix33 rotation(Quaternion q)
in
{
assert(q.isUnit());
}
body
{
float_t tx = 2F * q.x;
float_t ty = 2F * q.y;
float_t tz = 2F * q.z;
float_t twx = tx * q.w;
float_t twy = ty * q.w;
float_t twz = tz * q.w;
float_t txx = tx * q.x;
float_t txy = ty * q.x;
float_t txz = tz * q.x;
float_t tyy = ty * q.y;
float_t tyz = tz * q.y;
float_t tzz = tz * q.z;
Matrix33 mat;
with (mat)
{
m00 = 1F - (tyy + tzz);
m01 = txy - twz;
m02 = txz + twy;
m10 = txy + twz;
m11 = 1F - (txx + tzz);
m12 = tyz - twx;
m20 = txz - twy;
m21 = tyz + twx;
m22 = 1F - (txx + tyy);
}
return mat;
}
}
    Matrix33 inverse()
{
Matrix33 mat;
mat.m00 = m11 * m22 - m12 * m21;
mat.m01 = m02 * m21 - m01 * m22;
mat.m02 = m01 * m12 - m02 * m11;
mat.m10 = m12 * m20 - m10 * m22;
mat.m11 = m00 * m22 - m02 * m20;
mat.m12 = m02 * m10 - m00 * m12;
mat.m20 = m10 * m21 - m11 * m20;
mat.m21 = m01 * m20 - m00 * m21;
mat.m22 = m00 * m11 - m01 * m10;
real det = m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20;
{
for (int i = 9;
 i--;)
{
mat.a[i] /= det;
}
}
return mat;
}
    void invert()
{
*this = inverse();
}
    real determinant()
{
real cofactor00 = m11 * m22 - m12 * m21;
real cofactor10 = m12 * m20 - m10 * m22;
real cofactor20 = m10 * m21 - m11 * m20;
return m00 * cofactor00 + m01 * cofactor10 + m02 * cofactor20;
;
}
    real norm()
{
return sqrt(normSquare);
}
    real normSquare()
{
real ret = 0;
{
for (int i = 9;
 i--;)
{
{
real x = a[i];
ret += x * x;
}
}
}
return ret;
}
    void transpose()
{
swap(m01,m10);
swap(m02,m20);
swap(m12,m21);
}
    Matrix33 transposed()
{
return Matrix33(m00,m10,m20,m01,m11,m21,m02,m12,m22);
}
    void polarDecomposition(out Matrix33 Q, out Matrix33 S)
out
{
assert(Q.isRotation());
}
body
{
if (determinant < 0)
Q = *this * -identity;
else
Q = *this;
int maxIterations = 100;
Matrix33 Qp = Q;
Q = 0.5F * (Q + Q.transposed.inverse);
while (!(Q - Qp).isZero && maxIterations--)
{
Matrix33 Qinv = Q.inverse;
real gamma = sqrt(Qinv.norm / Q.norm);
Qp = Q;
Q = 0.5F * (gamma * Q + 1 / gamma * Qinv.transposed);
}
assert(maxIterations != -1);
S = Q.transposed * *this;
}
    Matrix33 opNeg()
{
return Matrix33(-m00,-m01,-m02,-m10,-m11,-m12,-m20,-m21,-m22);
}
    Matrix33 opAdd(Matrix33 mat)
{
return Matrix33(m00 + mat.m00,m01 + mat.m01,m02 + mat.m02,m10 + mat.m10,m11 + mat.m11,m12 + mat.m12,m20 + mat.m20,m21 + mat.m21,m22 + mat.m22);
}
    void opAddAssign(Matrix33 mat)
{
m00 += mat.m00;
m01 += mat.m01;
m02 += mat.m02;
m10 += mat.m10;
m11 += mat.m11;
m12 += mat.m12;
m20 += mat.m20;
m21 += mat.m21;
m22 += mat.m22;
}
    Matrix33 opSub(Matrix33 mat)
{
return Matrix33(m00 - mat.m00,m01 - mat.m01,m02 - mat.m02,m10 - mat.m10,m11 - mat.m11,m12 - mat.m12,m20 - mat.m20,m21 - mat.m21,m22 - mat.m22);
}
    void opSubAssign(Matrix33 mat)
{
m00 -= mat.m00;
m01 -= mat.m01;
m02 -= mat.m02;
m10 -= mat.m10;
m11 -= mat.m11;
m12 -= mat.m12;
m20 -= mat.m20;
m21 -= mat.m21;
m22 -= mat.m22;
}
    Matrix33 opMul(float_t k)
{
return Matrix33(m00 * k,m01 * k,m02 * k,m10 * k,m11 * k,m12 * k,m20 * k,m21 * k,m22 * k);
}
    void opMulAssign(float_t k)
{
m00 *= k;
m01 *= k;
m02 *= k;
m10 *= k;
m11 *= k;
m12 *= k;
m20 *= k;
m21 *= k;
m22 *= k;
}
    Matrix33 opMul_r(float_t k)
{
return Matrix33(m00 * k,m01 * k,m02 * k,m10 * k,m11 * k,m12 * k,m20 * k,m21 * k,m22 * k);
}
    Matrix33 opDiv(float_t k)
{
return Matrix33(m00 / k,m01 / k,m02 / k,m10 / k,m11 / k,m12 / k,m20 / k,m21 / k,m22 / k);
}
    void opDivAssign(float_t k)
{
m00 /= k;
m01 /= k;
m02 /= k;
m10 /= k;
m11 /= k;
m12 /= k;
m20 /= k;
m21 /= k;
m22 /= k;
}
    bool opEquals(Matrix33 mat)
{
return m00 == mat.m00 && m01 == mat.m01 && m02 == mat.m02 && m10 == mat.m10 && m11 == mat.m11 && m12 == mat.m12 && m20 == mat.m20 && m21 == mat.m21 && m22 == mat.m22;
}
    Matrix33 opMul(Matrix33 mat)
{
return Matrix33(m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20,m00 * mat.m01 + m01 * mat.m11 + m02 * mat.m21,m00 * mat.m02 + m01 * mat.m12 + m02 * mat.m22,m10 * mat.m00 + m11 * mat.m10 + m12 * mat.m20,m10 * mat.m01 + m11 * mat.m11 + m12 * mat.m21,m10 * mat.m02 + m11 * mat.m12 + m12 * mat.m22,m20 * mat.m00 + m21 * mat.m10 + m22 * mat.m20,m20 * mat.m01 + m21 * mat.m11 + m22 * mat.m21,m20 * mat.m02 + m21 * mat.m12 + m22 * mat.m22);
}
    void opMulAssign(Matrix33 mat)
{
*this = *this * mat;
}
    Vector3 opMul(Vector3 v)
{
return Vector3(v.x * m00 + v.y * m01 + v.z * m02,v.x * m10 + v.y * m11 + v.z * m12,v.x * m20 + v.y * m21 + v.z * m22);
}
    float_t opIndex(uint row, uint col)
in
{
assert(row < 3 && col < 3);
}
body
{
return m[col][row];
}
    void opIndexAssign(float_t f, uint row, uint col)
in
{
assert(row < 3 && col < 3);
}
body
{
m[col][row] = f;
}
    Vector3 opIndex(uint col)
in
{
assert(col < 3);
}
body
{
return v[col];
}
    void opIndexAssign(Vector3 v, uint col)
in
{
assert(col < 3);
}
body
{
return this.v[col] = v;
}
    float_t* ptr()
{
return a.ptr;
}
    Matrix33f toMatrix33f()
{
return Matrix33f(cast(float)m00,cast(float)m01,cast(float)m02,cast(float)m10,cast(float)m11,cast(float)m12,cast(float)m20,cast(float)m21,cast(float)m22);
}
    Matrix33d toMatrix33d()
{
return Matrix33d(cast(double)m00,cast(double)m01,cast(double)m02,cast(double)m10,cast(double)m11,cast(double)m12,cast(double)m20,cast(double)m21,cast(double)m22);
}
    Matrix33r toMatrix33r()
{
return Matrix33r(cast(real)m00,cast(real)m01,cast(real)m02,cast(real)m10,cast(real)m11,cast(real)m12,cast(real)m20,cast(real)m21,cast(real)m22);
}
    char[] toString()
{
return format("[",m00,", ",m01,", ",m02,",\x0a"," ",m10,", ",m11,", ",m12,",\x0a"," ",m20,", ",m21,", ",m22,"]");
}
}
alias EqualityByNorm!(Matrix33).equal equal;
alias Lerp!(Matrix33).lerp lerp;
struct Matrix44
{
    align (1)
{
    union
{
struct
{
float_t m00;
float_t m10;
float_t m20;
float_t m30;
float_t m01;
float_t m11;
float_t m21;
float_t m31;
float_t m02;
float_t m12;
float_t m22;
float_t m32;
float_t m03;
float_t m13;
float_t m23;
float_t m33;
}
float_t[4][4] m;
float_t[16] a;
Vector4[4] v;
}
}
    static 
{
    Matrix44 identity = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1};
}
    static 
{
    Matrix44 nan = {float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan,float_t.nan};
}
    static 
{
    Matrix44 zero = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
}
    static 
{
    Matrix44 opCall(float_t m00, float_t m01, float_t m02, float_t m03, float_t m10, float_t m11, float_t m12, float_t m13, float_t m20, float_t m21, float_t m22, float_t m23, float_t m30, float_t m31, float_t m32, float_t m33)
{
Matrix44 mat;
mat.m00 = m00;
mat.m01 = m01;
mat.m02 = m02;
mat.m03 = m03;
mat.m10 = m10;
mat.m11 = m11;
mat.m12 = m12;
mat.m13 = m13;
mat.m20 = m20;
mat.m21 = m21;
mat.m22 = m22;
mat.m23 = m23;
mat.m30 = m30;
mat.m31 = m31;
mat.m32 = m32;
mat.m33 = m33;
return mat;
}
}
    static 
{
    Matrix44 opCall(float_t[16] a)
{
Matrix44 mat;
mat.a[0..16] = a[0..16].dup;
return mat;
}
}
    static 
{
    Matrix44 opCall(Vector4 basisX, Vector4 basisY, Vector4 basisZ, Vector4 basisW = Vector4(0,0,0,1))
{
Matrix44 mat;
mat.v[0] = basisX;
mat.v[1] = basisY;
mat.v[2] = basisZ;
mat.v[3] = basisW;
return mat;
}
}
    static 
{
    Matrix44 opCall(Vector3 basisX, Vector3 basisY, Vector3 basisZ, Vector3 translation = Vector3(0,0,0))
{
return opCall(Vector4(basisX,0),Vector4(basisX,0),Vector4(basisX,0),Vector4(translation,1));
}
}
    void set(float_t m00, float_t m01, float_t m02, float_t m03, float_t m10, float_t m11, float_t m12, float_t m13, float_t m20, float_t m21, float_t m22, float_t m23, float_t m30, float_t m31, float_t m32, float_t m33)
{
this.m00 = m00;
this.m01 = m01;
this.m02 = m02;
this.m03 = m03;
this.m10 = m10;
this.m11 = m11;
this.m12 = m12;
this.m13 = m13;
this.m20 = m20;
this.m21 = m21;
this.m22 = m22;
this.m23 = m23;
this.m30 = m30;
this.m31 = m31;
this.m32 = m32;
this.m33 = m33;
}
    void set(float_t[16] a)
{
this.a[0..16] = a[0..16].dup;
}
    void set(Vector4 basisX, Vector4 basisY, Vector4 basisZ, Vector4 basisW = Vector4(0,0,0,1))
{
v[0] = basisX;
v[1] = basisY;
v[2] = basisZ;
v[3] = basisW;
}
    bool isnormal()
{
return std.math.isnormal(m00) && std.math.isnormal(m01) && std.math.isnormal(m02) && std.math.isnormal(m03) && std.math.isnormal(m10) && std.math.isnormal(m11) && std.math.isnormal(m12) && std.math.isnormal(m13) && std.math.isnormal(m20) && std.math.isnormal(m21) && std.math.isnormal(m22) && std.math.isnormal(m23) && std.math.isnormal(m30) && std.math.isnormal(m31) && std.math.isnormal(m32) && std.math.isnormal(m33);
}
    bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(*this,identity,relprec,absprec);
}
    bool isZero(int relprec = defrelprec, int absprec = defabsprec)
{
return equal(normSquare(),0,relprec,absprec);
}
    void set(Vector3 basisX, Vector3 basisY, Vector3 basisZ, Vector3 translation = Vector3(0,0,0))
{
v[0] = Vector4(basisX,0);
v[1] = Vector4(basisY,0);
v[2] = Vector4(basisZ,0);
v[3] = Vector4(translation,1);
}
    static 
{
    Matrix44 scale(float_t x, float_t y, float_t z)
{
Matrix44 mat = identity;
with (mat)
{
m00 = x;
m11 = y;
m22 = z;
}
return mat;
}
}
    static 
{
    Matrix44 scale(Vector3 v)
{
return scale(v.x,v.y,v.z);
}
}
    static 
{
    Matrix44 rotationX(float_t radians)
{
Matrix44 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m11 = (m22 = c);
m21 = s;
m12 = -s;
}
return mat;
}
}
    static 
{
    Matrix44 rotationY(float_t radians)
{
Matrix44 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m00 = (m22 = c);
m20 = -s;
m02 = s;
}
return mat;
}
}
    static 
{
    Matrix44 rotationZ(float_t radians)
{
Matrix44 mat = identity;
float_t c = cos(radians);
float_t s = sin(radians);
with (mat)
{
m00 = (m11 = c);
m10 = s;
m01 = -s;
}
return mat;
}
}
    static 
{
    Matrix44 rotation(float_t yaw, float_t pitch, float_t roll)
{
return Matrix44.rotationY(yaw) * Matrix44.rotationX(pitch) * Matrix44.rotationZ(roll);
}
}
    static 
{
    Matrix44 rotation(Vector3 axis, float_t radians)
in
{
assert(axis.isUnit());
}
body
{
real c = cos(radians);
real s = sin(radians);
real cc = 1 - c;
real x2 = axis.x * axis.x;
real y2 = axis.y * axis.y;
real z2 = axis.z * axis.z;
real xycc = axis.x * axis.y * cc;
real xzcc = axis.x * axis.z * cc;
real yzcc = axis.y * axis.z * cc;
real xs = axis.x * s;
real ys = axis.y * s;
real zs = axis.z * s;
Matrix44 mat = identity;
with (mat)
{
m00 = x2 * cc + c;
m01 = xycc - zs;
m02 = xzcc + ys;
m10 = xycc + zs;
m11 = y2 * cc + c;
m12 = yzcc - xs;
m20 = xzcc - ys;
m21 = yzcc + xs;
m22 = z2 * cc + c;
}
return mat;
}
}
    static 
{
    Matrix44 rotation(Quaternion q)
in
{
assert(q.isUnit());
}
body
{
float_t tx = 2F * q.x;
float_t ty = 2F * q.y;
float_t tz = 2F * q.z;
float_t twx = tx * q.w;
float_t twy = ty * q.w;
float_t twz = tz * q.w;
float_t txx = tx * q.x;
float_t txy = ty * q.x;
float_t txz = tz * q.x;
float_t tyy = ty * q.y;
float_t tyz = tz * q.y;
float_t tzz = tz * q.z;
Matrix44 mat = identity;
with (mat)
{
m00 = 1F - (tyy + tzz);
m01 = txy - twz;
m02 = txz + twy;
m10 = txy + twz;
m11 = 1F - (txx + tzz);
m12 = tyz - twx;
m20 = txz - twy;
m21 = tyz + twx;
m22 = 1F - (txx + tyy);
}
return mat;
}
}
    static 
{
    Matrix44 translation(float_t x, float_t y, float_t z)
{
return Matrix44(1,0,0,x,0,1,0,y,0,0,1,z,0,0,0,1);
}
}
    static 
{
    Matrix44 translation(Vector3 v)
{
return translation(v.x,v.y,v.z);
}
}
    static 
{
    Matrix44 perspective(float_t fov, float_t aspect, float_t near, float_t far)
in
{
assert(fov < 2 * PI);
assert(!equal(aspect,0));
assert(near > 0);
assert(far > near);
}
body
{
real cot = 1 / tan(fov / 2);
return Matrix44(cot / aspect,0,0,0,0,cot,0,0,0,0,(near + far) / (near - far),2F * (near * far) / (near - far),0,0,-1,0);
}
}
    static 
{
    Matrix44 lookAt(Vector3 eye, Vector3 target, Vector3 up)
{
Vector3 z = (eye - target).normalized();
alias up y;
Vector3 x = cross(y,z);
y = cross(z,x);
x.normalize();
y.normalize();
Matrix44 mat = identity;
mat.v[0].xyz = Vector3(x.x,y.x,z.x);
mat.v[1].xyz = Vector3(x.y,y.y,z.y);
mat.v[2].xyz = Vector3(x.z,y.z,z.z);
mat.m03 = -dot(eye,x);
mat.m13 = -dot(eye,y);
mat.m23 = -dot(eye,z);
return mat;
}
}
    Matrix44 inverse()
{
real det = determinant();
real rdet = 1 / det;
return Matrix44(rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
}
    void invert()
{
real det = determinant();
real rdet = 1 / det;
set(rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
}
    real determinant()
{
return +(m00 * m11 - m01 * m10) * (m22 * m33 - m23 * m32) - (m00 * m12 - m02 * m10) * (m21 * m33 - m23 * m31) + (m00 * m13 - m03 * m10) * (m21 * m32 - m22 * m31) + (m01 * m12 - m02 * m11) * (m20 * m33 - m23 * m30) - (m01 * m13 - m03 * m11) * (m20 * m32 - m22 * m30) + (m02 * m13 - m03 * m12) * (m20 * m31 - m21 * m30);
}
    real norm()
{
return sqrt(normSquare);
}
    real normSquare()
{
real ret = 0;
{
for (int i = 16;
 i--;)
{
{
real x = a[i];
ret += x * x;
}
}
}
return ret;
}
    bool isAffine()
{
return equal(m30,0) && equal(m31,0) && equal(m32,0) && equal(m33,1);
}
    void transpose()
{
swap(m01,m10);
swap(m02,m20);
swap(m03,m30);
swap(m12,m21);
swap(m13,m31);
swap(m23,m32);
}
    Matrix44 transposed()
{
return Matrix44(m00,m10,m20,m30,m01,m11,m21,m31,m02,m12,m22,m32,m03,m13,m23,m33);
}
    Matrix33 cornerMinor()
{
return Matrix33(m00,m01,m02,m10,m11,m12,m20,m21,m22);
}
    void cornerMinor(Matrix33 mat)
{
m00 = mat.m00;
m01 = mat.m01;
m02 = mat.m02;
m10 = mat.m10;
m11 = mat.m11;
m12 = mat.m12;
m20 = mat.m20;
m21 = mat.m21;
m22 = mat.m22;
}
    Matrix44 opNeg()
{
return Matrix44(-m00,-m01,-m02,-m03,-m10,-m11,-m12,-m13,-m20,-m21,-m22,-m23,-m30,-m31,-m32,-m33);
}
    Matrix44 opAdd(Matrix44 mat)
{
return Matrix44(m00 + mat.m00,m01 + mat.m01,m02 + mat.m02,m03 + mat.m03,m10 + mat.m10,m11 + mat.m11,m12 + mat.m12,m13 + mat.m13,m20 + mat.m20,m21 + mat.m21,m22 + mat.m22,m23 + mat.m23,m30 + mat.m30,m31 + mat.m31,m32 + mat.m32,m33 + mat.m33);
}
    void opAddAssign(Matrix44 mat)
{
m00 += mat.m00;
m01 += mat.m01;
m02 += mat.m02;
m03 += mat.m03;
m10 += mat.m10;
m11 += mat.m11;
m12 += mat.m12;
m13 += mat.m13;
m20 += mat.m20;
m21 += mat.m21;
m22 += mat.m22;
m23 += mat.m23;
m30 += mat.m30;
m31 += mat.m31;
m32 += mat.m32;
m33 += mat.m33;
}
    Matrix44 opSub(Matrix44 mat)
{
return Matrix44(m00 - mat.m00,m01 - mat.m01,m02 - mat.m02,m03 - mat.m03,m10 - mat.m10,m11 - mat.m11,m12 - mat.m12,m13 - mat.m13,m20 - mat.m20,m21 - mat.m21,m22 - mat.m22,m23 - mat.m23,m30 - mat.m30,m31 - mat.m31,m32 - mat.m32,m33 - mat.m33);
}
    void opSubAssign(Matrix44 mat)
{
m00 -= mat.m00;
m01 -= mat.m01;
m02 -= mat.m02;
m03 -= mat.m03;
m10 -= mat.m10;
m11 -= mat.m11;
m12 -= mat.m12;
m13 -= mat.m13;
m20 -= mat.m20;
m21 -= mat.m21;
m22 -= mat.m22;
m23 -= mat.m23;
m30 -= mat.m30;
m31 -= mat.m31;
m32 -= mat.m32;
m33 -= mat.m33;
}
    Matrix44 opMul(float_t k)
{
return Matrix44(m00 * k,m01 * k,m02 * k,m03 * k,m10 * k,m11 * k,m12 * k,m13 * k,m20 * k,m21 * k,m22 * k,m23 * k,m30 * k,m31 * k,m32 * k,m33 * k);
}
    void opMulAssign(float_t k)
{
m00 *= k;
m01 *= k;
m02 *= k;
m03 *= k;
m10 *= k;
m11 *= k;
m12 *= k;
m13 *= k;
m20 *= k;
m21 *= k;
m22 *= k;
m23 *= k;
m30 *= k;
m31 *= k;
m32 *= k;
m33 *= k;
}
    Matrix44 opMul_r(float_t k)
{
return Matrix44(m00 * k,m01 * k,m02 * k,m03 * k,m10 * k,m11 * k,m12 * k,m13 * k,m20 * k,m21 * k,m22 * k,m23 * k,m30 * k,m31 * k,m32 * k,m33 * k);
}
    Matrix44 opDiv(float_t k)
{
return Matrix44(m00 / k,m01 / k,m02 / k,m03 / k,m10 / k,m11 / k,m12 / k,m13 / k,m20 / k,m21 / k,m22 / k,m23 / k,m30 / k,m31 / k,m32 / k,m33 / k);
}
    void opDivAssign(float_t k)
{
m00 /= k;
m01 /= k;
m02 /= k;
m03 /= k;
m10 /= k;
m11 /= k;
m12 /= k;
m13 /= k;
m20 /= k;
m21 /= k;
m22 /= k;
m23 /= k;
m30 /= k;
m31 /= k;
m32 /= k;
m33 /= k;
}
    bool opEquals(Matrix44 mat)
{
return m00 == mat.m00 && m01 == mat.m01 && m02 == mat.m02 && m03 == mat.m03 && m10 == mat.m10 && m11 == mat.m11 && m12 == mat.m12 && m13 == mat.m13 && m20 == mat.m20 && m21 == mat.m21 && m22 == mat.m22 && m23 == mat.m23 && m30 == mat.m30 && m31 == mat.m31 && m32 == mat.m32 && m33 == mat.m33;
}
    Matrix44 opMul(Matrix44 mat)
{
return Matrix44(m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20 + m03 * mat.m30,m00 * mat.m01 + m01 * mat.m11 + m02 * mat.m21 + m03 * mat.m31,m00 * mat.m02 + m01 * mat.m12 + m02 * mat.m22 + m03 * mat.m32,m00 * mat.m03 + m01 * mat.m13 + m02 * mat.m23 + m03 * mat.m33,m10 * mat.m00 + m11 * mat.m10 + m12 * mat.m20 + m13 * mat.m30,m10 * mat.m01 + m11 * mat.m11 + m12 * mat.m21 + m13 * mat.m31,m10 * mat.m02 + m11 * mat.m12 + m12 * mat.m22 + m13 * mat.m32,m10 * mat.m03 + m11 * mat.m13 + m12 * mat.m23 + m13 * mat.m33,m20 * mat.m00 + m21 * mat.m10 + m22 * mat.m20 + m23 * mat.m30,m20 * mat.m01 + m21 * mat.m11 + m22 * mat.m21 + m23 * mat.m31,m20 * mat.m02 + m21 * mat.m12 + m22 * mat.m22 + m23 * mat.m32,m20 * mat.m03 + m21 * mat.m13 + m22 * mat.m23 + m23 * mat.m33,m30 * mat.m00 + m31 * mat.m10 + m32 * mat.m20 + m33 * mat.m30,m30 * mat.m01 + m31 * mat.m11 + m32 * mat.m21 + m33 * mat.m31,m30 * mat.m02 + m31 * mat.m12 + m32 * mat.m22 + m33 * mat.m32,m30 * mat.m03 + m31 * mat.m13 + m32 * mat.m23 + m33 * mat.m33);
}
    void opMulAssign(Matrix44 mat)
{
*this = *this * mat;
}
    Vector3 opMul(Vector3 v)
{
return Vector3(v.x * m00 + v.y * m01 + v.z * m02 + m03,v.x * m10 + v.y * m11 + v.z * m12 + m13,v.x * m20 + v.y * m21 + v.z * m22 + m23);
}
    Vector4 opMul(Vector4 v)
{
return Vector4(v.x * m00 + v.y * m01 + v.z * m02 + v.w * m03,v.x * m10 + v.y * m11 + v.z * m12 + v.w * m13,v.x * m20 + v.y * m21 + v.z * m22 + v.w * m23,v.x * m30 + v.y * m31 + v.z * m32 + v.w * m33);
}
    float_t opIndex(uint row, uint col)
in
{
assert(col < 4 && row < 4);
}
body
{
return m[col][row];
}
    void opIndexAssign(float_t f, uint row, uint col)
in
{
assert(col < 4 && row < 4);
}
body
{
m[col][row] = f;
}
    Vector4 opIndex(uint col)
in
{
assert(col < 4);
}
body
{
return v[col];
}
    void opIndexAssign(Vector4 v, uint col)
in
{
assert(col < 4);
}
body
{
this.v[col] = v;
}
    float_t* ptr()
{
return a.ptr;
}
    Matrix44f toMatrix44f()
{
return Matrix44f(cast(float)m00,cast(float)m01,cast(float)m02,cast(float)m03,cast(float)m10,cast(float)m11,cast(float)m12,cast(float)m13,cast(float)m20,cast(float)m21,cast(float)m22,cast(float)m23,cast(float)m30,cast(float)m31,cast(float)m32,cast(float)m33);
}
    Matrix44d toMatrix44d()
{
return Matrix44d(cast(double)m00,cast(double)m01,cast(double)m02,cast(double)m03,cast(double)m10,cast(double)m11,cast(double)m12,cast(double)m13,cast(double)m20,cast(double)m21,cast(double)m22,cast(double)m23,cast(double)m30,cast(double)m31,cast(double)m32,cast(double)m33);
}
    Matrix44r toMatrix44r()
{
return Matrix44r(cast(real)m00,cast(real)m01,cast(real)m02,cast(real)m03,cast(real)m10,cast(real)m11,cast(real)m12,cast(real)m13,cast(real)m20,cast(real)m21,cast(real)m22,cast(real)m23,cast(real)m30,cast(real)m31,cast(real)m32,cast(real)m33);
}
    char[] toString()
{
return format("[",m00,", ",m01,", ",m02,", ",m03,",\x0a"," ",m10,", ",m11,", ",m12,", ",m13,",\x0a"," ",m20,", ",m21,", ",m22,", ",m23,",\x0a"," ",m30,", ",m31,", ",m32,", ",m33,"]");
}
}
alias EqualityByNorm!(Matrix44).equal equal;
alias Lerp!(Matrix44).lerp lerp;
}
}
alias LinearAlgebra!(float).Vector2 Vector2f;
alias LinearAlgebra!(float).Vector3 Vector3f;
alias LinearAlgebra!(float).Vector4 Vector4f;
alias LinearAlgebra!(float).Quaternion Quaternionf;
alias LinearAlgebra!(float).Matrix22 Matrix22f;
alias LinearAlgebra!(float).Matrix33 Matrix33f;
alias LinearAlgebra!(float).Matrix44 Matrix44f;
alias LinearAlgebra!(float).equal equal;
alias LinearAlgebra!(float).dot dot;
public 
{
    alias LinearAlgebra!(float).outer outer;
}
alias LinearAlgebra!(float).cross cross;
alias LinearAlgebra!(float).isBasisOrthogonal isBasisOrthogonal;
alias LinearAlgebra!(float).isBasisOrthonormal isBasisOrthonormal;
alias LinearAlgebra!(float).lerp lerp;
alias LinearAlgebra!(float).slerp slerp;
alias LinearAlgebra!(double).Vector2 Vector2d;
alias LinearAlgebra!(double).Vector3 Vector3d;
alias LinearAlgebra!(double).Vector4 Vector4d;
alias LinearAlgebra!(double).Quaternion Quaterniond;
alias LinearAlgebra!(double).Matrix22 Matrix22d;
alias LinearAlgebra!(double).Matrix33 Matrix33d;
alias LinearAlgebra!(double).Matrix44 Matrix44d;
alias LinearAlgebra!(double).equal equal;
alias LinearAlgebra!(double).dot dot;
alias LinearAlgebra!(double).cross cross;
alias LinearAlgebra!(double).isBasisOrthogonal isBasisOrthogonal;
alias LinearAlgebra!(double).isBasisOrthonormal isBasisOrthonormal;
alias LinearAlgebra!(double).lerp lerp;
alias LinearAlgebra!(double).slerp slerp;
alias LinearAlgebra!(real).Vector2 Vector2r;
alias LinearAlgebra!(real).Vector3 Vector3r;
alias LinearAlgebra!(real).Vector4 Vector4r;
alias LinearAlgebra!(real).Quaternion Quaternionr;
alias LinearAlgebra!(real).Matrix22 Matrix22r;
alias LinearAlgebra!(real).Matrix33 Matrix33r;
alias LinearAlgebra!(real).Matrix44 Matrix44r;
alias LinearAlgebra!(real).equal equal;
alias LinearAlgebra!(real).dot dot;
alias LinearAlgebra!(real).cross cross;
alias LinearAlgebra!(real).isBasisOrthogonal isBasisOrthogonal;
alias LinearAlgebra!(real).isBasisOrthonormal isBasisOrthonormal;
alias LinearAlgebra!(real).lerp lerp;
alias LinearAlgebra!(real).slerp slerp;
alias LinearAlgebra!(auxd.helix.config.float_t).Vector2 Vector2;
alias LinearAlgebra!(auxd.helix.config.float_t).Vector3 Vector3;
alias LinearAlgebra!(auxd.helix.config.float_t).Vector4 Vector4;
alias LinearAlgebra!(auxd.helix.config.float_t).Quaternion Quaternion;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix22 Matrix22;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix33 Matrix33;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix44 Matrix44;
