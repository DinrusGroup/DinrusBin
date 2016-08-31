module lib.ode;
import stdrus, cidrus: фук;

// odeconfig.h
alias цел int32;
alias бцел uint32;
alias крат int16;
alias бкрат uint16;
alias байт int8;
alias ббайт uint8;

// common.h
version(ДвойнаяТочность)
{
    alias дво dReal;
}
else
{
    alias плав dReal;
}
alias dReal дРеал;
alias ПИ M_PI;
alias КВКОР1_2 M_SQRT1_2;

version(DerelictOde_TriMesh_16Bit_Indices)
{
    alias uint16 dTriIndex;
}
else
{
    alias uint32 dTriIndex;
}

цел dPAD(цел a)
{
    return (a > 1) ? (((a - 1)|3)+1) : a;
}

typedef dReal dVector3[4]; alias dVector3 дВектор3;
typedef dReal dVector4[4]; alias dVector4 дВектор4;
typedef dReal dMatrix3[4*3]; alias dMatrix3 дМатрица3;
typedef dReal dMatrix4[4*4]; alias dMatrix4 дМатрица4;
typedef dReal dMatrix6[8*6]; alias dMatrix6 дМатрица6;
typedef dReal dQuaternion[4]; alias dQuaternion дКватернион;

дРеал dRecip(дРеал x)
{
    return 1.0/x;
}

дРеал dRecipSqrt(дРеал x)
{
    return 1.0/квкор(x);
}

дРеал dFMod(дРеал a, дРеал b)
{
    version(Tango)
    {
        return modff(a, &b);
    }
    else
    {
        real c;
        return модф(a, c);
    }
}

alias квкор dSqrt;
alias син dSin;
alias кос dCos;
alias фабс dFabs;
alias атан2 dAtan2;
alias нч_ли dIsNan;
alias копируйзнак dCopySign;

struct dxWorld {};
struct dxSpace {};
struct dxBody {};
struct dxGeom {};
struct dxJoint {};
struct dxJointNode {};
struct dxJointGroup {};

alias dxWorld* дИДМира;
alias dxSpace* дИДПространства;
alias dxBody* дИДТела;
alias dxGeom* дГеомИД;
alias dxJoint* дИДСоединения;
alias dxJointGroup* дИДГруппыСоединений;

enum
{
    d_ERR_UNKNOWN,
    d_ERR_IASSERT,
    d_ERR_UASSERT,
    d_ERR_LCP
}

alias цел dJointType;
enum
{
    dJointTypeNone,
    dJointTypeBall,
    dJointTypeHinge,
    dJointTypeSlider,
    dJointTypeContact,
    dJointTypeUniversal,
    dJointTypeHinge2,
    dJointTypeFixed,
    dJointTypeNull,
    dJointTypeAMotor,
    dJointTypeLMotor,
    dJointTypePlane2D,
    dJointTypePR,
    dJointTypePU,
    dJointTypePiston,
}

enum
{
    dParamLoStop = 0,
    dParamHiStop,
    dParamVel,
    dParamFMax,
    dParamFudgeFactor,
    dParamBounce,
    dParamCFM,
    dParamStopERP,
    dParamStopCFM,
    dParamSuspensionERP,
    dParamSuspensionCFM,
    dParamERP,
    dParamsInGroup,
    dParamLoStop1 = 0x000,
    dParamHiStop1,
    dParamVel1,
    dParamFMax1,
    dParamFudgeFactor1,
    dParamBounce1,
    dParamCFM1,
    dParamStopERP1,
    dParamStopCFM1,
    dParamSuspensionERP1,
    dParamSuspensionCFM1,
    dParamERP1,
    dParamLoStop2 = 0x100,
    dParamHiStop2,
    dParamVel2,
    dParamFMax2,
    dParamFudgeFactor2,
    dParamBounce2,
    dParamCFM2,
    dParamStopERP2,
    dParamStopCFM2,
    dParamSuspensionERP2,
    dParamSuspensionCFM2,
    dParamERP2,
    dParamLoStop3 = 0x200,
    dParamHiStop3,
    dParamVel3,
    dParamFMax3,
    dParamFudgeFactor3,
    dParamBounce3,
    dParamCFM3,
    dParamStopERP3,
    dParamStopCFM3,
    dParamSuspensionERP3,
    dParamSuspensionCFM3,
    dParamERP3,
    dParamGroup = 0x100
}

enum
{
    dAMotorUser,
    dAMotorEuler,
}

struct dJointFeedback
{
    дВектор3 f1;
    дВектор3 t1;
    дВектор3 f2;
    дВектор3 t2;
}

// collision.h
enum
{
    CONTACTS_UNIMPORTANT = 0x80000000
}

enum
{
    dMaxUserClasses = 4
}

enum
{
    dSphereClass = 0,
    dBoxClass,
    dCapsuleClass,
    dCylinderClass,
    dPlaneClass,
    dRayClass,
    dConvexClass,
    dGeomTransformClass,
    dTriMeshClass,
    dHeightFieldClass,
    dFirstSpaceClass,
    dSimpleSpaceClass = dFirstSpaceClass,
    dHashSpaceClass,
    dSweepAndPruneClass,
    dQuadTreeClass,
    dLastSpaceClass = dQuadTreeClass,
    dFirstUserClass,
    dLastUserClass = dFirstUserClass + dMaxUserClasses - 1,
    dGeomNumClasses
}

alias dCapsuleClass dCCapsuleClass;

struct dxHeightfieldData;
alias dxHeightfieldData* dHeightfieldDataID;

extern(C)
{
    alias дРеал function(ук, цел, цел) dHeightfieldGetHeight;
    alias проц function(дГеомИД, дРеал[6]) dGetAABBFn;
    alias цел function(дГеомИД, дГеомИД, цел, dContactGeom*, цел) dColliderFn;
    alias dColliderFn function(цел) dGetColliderFnFn;
    alias проц function(дГеомИД) dGeomDtorFn;
    alias цел function(дГеомИД, дГеомИД, дРеал[6]) dAABBTestFn;
}


struct dGeomClass
{
    цел bytes;
    dGetColliderFnFn collider;
    dGetAABBFn aabb;
    dAABBTestFn aabb_test;
    dGeomDtorFn dtor;
}

// collision_space.h
alias extern(C) проц function(ук, дГеомИД, дГеомИД) dNearCallback;

enum
{
    dSAP_AXES_XYZ = ((0)|(1<<2)|(2<<4)),
    dSAP_AXES_XZY = ((0)|(2<<2)|(1<<4)),
    dSAP_AXES_YXZ = ((1)|(0<<2)|(2<<4)),
    dSAP_AXES_YZX = ((1)|(2<<2)|(0<<4)),
    dSAP_AXES_ZXY = ((2)|(0<<2)|(1<<4)),
    dSAP_AXES_ZYX = ((2)|(1<<2)|(0<<4))
}

// collision_trimesh.h
struct dxTriMeshData {}
alias dxTriMeshData* dTriMeshDataID;

enum { TRIMESH_FACE_NORMALS }

extern(C)
{
    alias цел function(дГеомИД, дГеомИД, цел) dTriCallback;
    alias проц function(дГеомИД, дГеомИД, in цел*, цел) dTriArrayCallback;
    alias цел function(дГеомИД, дГеомИД, цел, дРеал, дРеал) dTriRayCallback;
    alias цел function(дГеомИД, цел, цел) dTriTriMergeCallback;
}

// contact.h
enum
{
    dContactMu2 = 0x001,
    dContactFDir1 = 0x002,
    dContactBounce = 0x004,
    dContactSoftERP = 0x008,
    dContactSoftCFM = 0x010,
    dContactMotion1 = 0x020,
    dContactMotion2 = 0x040,
    dContactMotionN = 0x080,
    dContactSlip1 = 0x100,
    dContactSlip2 = 0x200,

    dContactApprox0 = 0x0000,
    dContactApprox1_1 = 0x1000,
    dContactApprox1_2 = 0x2000,
    dContactApprox1 = 0x3000
}

struct dSurfaceParameters
{
    цел mode;
    дРеал mu;
    дРеал mu2;
    дРеал bounce;
    дРеал bounce_vel;
    дРеал soft_erp;
    дРеал soft_cfm;
    дРеал motion1, motion2, motionN;
    дРеал slip1, slip2;
}

struct dContactGeom
{
    дВектор3 pos;
    дВектор3 normal;
    дРеал depth;
    дГеомИД g1, g2;
    цел side1, side2;
}

struct dContact
{
    dSurfaceParameters surface;
    dContactGeom geom;
    дВектор3 fdir1;
}

// error.h
extern(C) alias проц function(цел, ткст0, va_list ap) dMessageFunction;

// mass.h
struct dMass
{
    дРеал mass;
    дВектор3 C;
    дМатрица3 I;
}

// memory.h
extern(C)
{
    alias ук function(size_t) dAllocFunction;
    alias ук function(ук, size_t, size_t) dReallocFunction;
    alias проц function(ук, size_t) dFreeFunction;
}

// odeinit.h
enum : бцел
{
    dInitFlagManualThreadCleanup = 0x00000001
}

enum : бцел
{
    dAllocateFlagsBasicData = 0,
    dAllocateFlagsCollisionData = 0x00000001,
    dAllocateMaskAll = ~0U,
}

// timer.h
struct dStopwatch
{
    дво time;
    бцел cc[2];
}

private проц грузи(Биб биб)
{
    вяжи(дайКонфигурацию)("dGetConfiguration", биб);
    вяжи(проверьКонфигурацию)("dCheckConfiguration", биб);
    вяжи(dGeomDestroy)("dGeomDestroy", биб);
    вяжи(dGeomSetData)("dGeomSetData", биб);
    вяжи(dGeomGetData)("dGeomGetData", биб);
    вяжи(dGeomSetBody)("dGeomSetBody", биб);
    вяжи(dGeomGetBody)("dGeomGetBody", биб);
    вяжи(dGeomSetPosition)("dGeomSetPosition", биб);
    вяжи(dGeomSetRotation)("dGeomSetRotation", биб);
    вяжи(dGeomSetQuaternion)("dGeomSetQuaternion", биб);
    вяжи(dGeomGetPosition)("dGeomGetPosition", биб);
    вяжи(dGeomCopyPosition)("dGeomCopyPosition", биб);
    вяжи(dGeomGetRotation)("dGeomGetRotation", биб);
    вяжи(dGeomCopyRotation)("dGeomCopyRotation", биб);
    вяжи(dGeomGetQuaternion)("dGeomGetQuaternion", биб);
    вяжи(dGeomGetAABB)("dGeomGetAABB", биб);
    вяжи(dGeomIsSpace)("dGeomIsSpace", биб);
    вяжи(dGeomGetSpace)("dGeomGetSpace", биб);
    вяжи(dGeomGetClass)("dGeomGetClass", биб);
    вяжи(dGeomSetCategoryBits)("dGeomSetCategoryBits", биб);
    вяжи(dGeomSetCollideBits)("dGeomSetCollideBits", биб);
    вяжи(dGeomGetCategoryBits)("dGeomGetCategoryBits", биб);
    вяжи(dGeomGetCollideBits)("dGeomGetCollideBits", биб);
    вяжи(dGeomEnable)("dGeomEnable", биб);
    вяжи(dGeomDisable)("dGeomDisable", биб);
    вяжи(dGeomIsEnabled)("dGeomIsEnabled", биб);
    вяжи(dGeomSetOffsetPosition)("dGeomSetOffsetPosition", биб);
    вяжи(dGeomSetOffsetRotation)("dGeomSetOffsetRotation", биб);
    вяжи(dGeomSetOffsetQuaternion)("dGeomSetOffsetQuaternion", биб);
    вяжи(dGeomSetOffsetWorldPosition)("dGeomSetOffsetWorldPosition", биб);
    вяжи(dGeomSetOffsetWorldRotation)("dGeomSetOffsetWorldRotation", биб);
    вяжи(dGeomSetOffsetWorldQuaternion)("dGeomSetOffsetWorldQuaternion", биб);
    вяжи(dGeomClearOffset)("dGeomClearOffset", биб);
    вяжи(dGeomIsOffset)("dGeomIsOffset", биб);
    вяжи(dGeomGetOffsetPosition)("dGeomGetOffsetPosition", биб);
    вяжи(dGeomCopyOffsetPosition)("dGeomCopyOffsetPosition", биб);
    вяжи(dGeomGetOffsetRotation)("dGeomGetOffsetRotation", биб);
    вяжи(dGeomGetOffsetQuaternion)("dGeomGetOffsetQuaternion", биб);
    вяжи(dCollide)("dCollide", биб);
    вяжи(dSpaceCollide)("dSpaceCollide", биб);
    вяжи(dSpaceCollide2)("dSpaceCollide2", биб);
    вяжи(dCreateSphere)("dCreateSphere", биб);
    вяжи(dGeomSphereSetRadius)("dGeomSphereSetRadius", биб);
    вяжи(dGeomSphereGetRadius)("dGeomSphereGetRadius", биб);
    вяжи(dGeomSpherePointDepth)("dGeomSpherePointDepth", биб);
    вяжи(dCreateConvex)("dCreateConvex", биб);
    вяжи(dGeomSetConvex)("dGeomSetConvex", биб);
    вяжи(dCreateBox)("dCreateBox", биб);
    вяжи(dGeomBoxSetLengths)("dGeomBoxSetLengths", биб);
    вяжи(dGeomBoxGetLengths)("dGeomBoxGetLengths", биб);
    вяжи(dGeomBoxPointDepth)("dGeomBoxPointDepth", биб);
    вяжи(dCreatePlane)("dCreatePlane", биб);
    вяжи(dGeomPlaneSetParams)("dGeomPlaneSetParams", биб);
    вяжи(dGeomPlaneGetParams)("dGeomPlaneGetParams", биб);
    вяжи(dGeomPlanePointDepth)("dGeomPlanePointDepth", биб);
    вяжи(dCreateCapsule)("dCreateCapsule", биб);
    вяжи(dGeomCapsuleSetParams)("dGeomCapsuleSetParams", биб);
    вяжи(dGeomCapsuleGetParams)("dGeomCapsuleGetParams", биб);
    вяжи(dGeomCapsulePointDepth)("dGeomCapsulePointDepth", биб);
    вяжи(dCreateCylinder)("dCreateCylinder", биб);
    вяжи(dGeomCylinderSetParams)("dGeomCylinderSetParams", биб);
    вяжи(dGeomCylinderGetParams)("dGeomCylinderGetParams", биб);
    вяжи(dCreateRay)("dCreateRay", биб);
    вяжи(dGeomRaySetLength)("dGeomRaySetLength", биб);
    вяжи(dGeomRayGetLength)("dGeomRayGetLength", биб);
    вяжи(dGeomRaySet)("dGeomRaySet", биб);
    вяжи(dGeomRayGet)("dGeomRayGet", биб);
    вяжи(dGeomRaySetParams)("dGeomRaySetParams", биб);
    вяжи(dGeomRayGetParams)("dGeomRayGetParams", биб);
    вяжи(dGeomRaySetClosestHit)("dGeomRaySetClosestHit", биб);
    вяжи(dGeomRayGetClosestHit)("dGeomRayGetClosestHit", биб);
    вяжи(dCreateGeomTransform)("dCreateGeomTransform", биб);
    вяжи(dGeomTransformSetGeom)("dGeomTransformSetGeom", биб);
    вяжи(dGeomTransformGetGeom)("dGeomTransformGetGeom", биб);
    вяжи(dGeomTransformSetCleanup)("dGeomTransformSetCleanup", биб);
    вяжи(dGeomTransformGetCleanup)("dGeomTransformGetCleanup", биб);
    вяжи(dGeomTransformSetInfo)("dGeomTransformSetInfo", биб);
    вяжи(dGeomTransformGetInfo)("dGeomTransformGetInfo", биб);
    вяжи(dCreateHeightfield)("dCreateHeightfield", биб);
    вяжи(dGeomHeightfieldDataCreate)("dGeomHeightfieldDataCreate", биб);
    вяжи(dGeomHeightfieldDataDestroy)("dGeomHeightfieldDataDestroy", биб);
    вяжи(dGeomHeightfieldDataBuildCallback)("dGeomHeightfieldDataBuildCallback", биб);
    вяжи(dGeomHeightfieldDataBuildByte)("dGeomHeightfieldDataBuildByte", биб);
    вяжи(dGeomHeightfieldDataBuildShort)("dGeomHeightfieldDataBuildShort", биб);
    вяжи(dGeomHeightfieldDataBuildSingle)("dGeomHeightfieldDataBuildSingle", биб);
    вяжи(dGeomHeightfieldDataBuildDouble)("dGeomHeightfieldDataBuildDouble", биб);
    вяжи(dGeomHeightfieldDataSetBounds)("dGeomHeightfieldDataSetBounds", биб);
    вяжи(dGeomHeightfieldSetHeightfieldData)("dGeomHeightfieldSetHeightfieldData", биб);
    вяжи(dGeomHeightfieldGetHeightfieldData)("dGeomHeightfieldGetHeightfieldData", биб);
    вяжи(dClosestLineSegmentPoints)("dClosestLineSegmentPoints", биб);
    вяжи(dBoxTouchesBox)("dBoxTouchesBox", биб);
    вяжи(dBoxBox)("dBoxBox", биб);
    вяжи(dInfiniteAABB)("dInfiniteAABB", биб);
    вяжи(dCreateGeomClass)("dCreateGeomClass", биб);
    вяжи(dGeomGetClassData)("dGeomGetClassData", биб);
    вяжи(dCreateGeom)("dCreateGeom", биб);
    вяжи(dSetColliderOverride)("dSetColliderOverride", биб);

    // collision_space.h
    вяжи(dSimpleSpaceCreate)("dSimpleSpaceCreate", биб);
    вяжи(dHashSpaceCreate)("dHashSpaceCreate", биб);
    вяжи(dQuadTreeSpaceCreate)("dQuadTreeSpaceCreate", биб);
    вяжи(dSweepAndPruneSpaceCreate)("dSweepAndPruneSpaceCreate", биб);
    вяжи(dSpaceDestroy)("dSpaceDestroy", биб);
    вяжи(dHashSpaceSetLevels)("dHashSpaceSetLevels", биб);
    вяжи(dHashSpaceGetLevels)("dHashSpaceGetLevels", биб);
    вяжи(dSpaceSetCleanup)("dSpaceSetCleanup", биб);
    вяжи(dSpaceGetCleanup)("dSpaceGetCleanup", биб);
    вяжи(dSpaceSetSublevel)("dSpaceSetSublevel", биб);
    вяжи(dSpaceGetSublevel)("dSpaceGetSublevel", биб);
    вяжи(dSpaceAdd)("dSpaceAdd", биб);
    вяжи(dSpaceRemove)("dSpaceRemove", биб);
    вяжи(dSpaceQuery)("dSpaceQuery", биб);
    вяжи(dSpaceClean)("dSpaceClean", биб);
    вяжи(dSpaceGetNumGeoms)("dSpaceGetNumGeoms", биб);
    вяжи(dSpaceGetGeom)("dSpaceGetGeom", биб);
    вяжи(dSpaceGetClass)("dSpaceGetClass", биб);

    // collision_trimesh.h
    вяжи(dGeomTriMeshDataCreate)("dGeomTriMeshDataCreate", биб);
    вяжи(dGeomTriMeshDataDestroy)("dGeomTriMeshDataDestroy", биб);
    вяжи(dGeomTriMeshDataSet)("dGeomTriMeshDataSet", биб);
    вяжи(dGeomTriMeshDataGet)("dGeomTriMeshDataGet", биб);
    вяжи(dGeomTriMeshSetLastTransform)("dGeomTriMeshSetLastTransform", биб);
    вяжи(dGeomTriMeshGetLastTransform)("dGeomTriMeshGetLastTransform", биб);
    вяжи(dGeomTriMeshDataBuildSingle)("dGeomTriMeshDataBuildSingle", биб);
    вяжи(dGeomTriMeshDataBuildSingle1)("dGeomTriMeshDataBuildSingle1", биб);
    вяжи(dGeomTriMeshDataBuildDouble)("dGeomTriMeshDataBuildDouble", биб);
    вяжи(dGeomTriMeshDataBuildDouble1)("dGeomTriMeshDataBuildDouble1", биб);
    вяжи(dGeomTriMeshDataBuildSimple)("dGeomTriMeshDataBuildSimple", биб);
    вяжи(dGeomTriMeshDataBuildSimple1)("dGeomTriMeshDataBuildSimple1", биб);
    вяжи(dGeomTriMeshDataPreprocess)("dGeomTriMeshDataPreprocess", биб);
    вяжи(dGeomTriMeshDataGetBuffer)("dGeomTriMeshDataGetBuffer", биб);
    вяжи(dGeomTriMeshDataSetBuffer)("dGeomTriMeshDataSetBuffer", биб);
    вяжи(dGeomTriMeshSetCallback)("dGeomTriMeshSetCallback", биб);
    вяжи(dGeomTriMeshGetCallback)("dGeomTriMeshGetCallback", биб);
    вяжи(dGeomTriMeshSetArrayCallback)("dGeomTriMeshSetArrayCallback", биб);
    вяжи(dGeomTriMeshGetArrayCallback)("dGeomTriMeshGetArrayCallback", биб);
    вяжи(dGeomTriMeshSetRayCallback)("dGeomTriMeshSetRayCallback", биб);
    вяжи(dGeomTriMeshGetRayCallback)("dGeomTriMeshGetRayCallback", биб);
    вяжи(dGeomTriMeshSetTriMergeCallback)("dGeomTriMeshSetTriMergeCallback", биб);
    вяжи(dGeomTriMeshGetTriMergeCallback)("dGeomTriMeshGetTriMergeCallback", биб);
    вяжи(dCreateTriMesh)("dCreateTriMesh", биб);
    вяжи(dGeomTriMeshSetData)("dGeomTriMeshSetData", биб);
    вяжи(dGeomTriMeshGetData)("dGeomTriMeshGetData", биб);
    вяжи(dGeomTriMeshEnableTC)("dGeomTriMeshEnableTC", биб);
    вяжи(dGeomTriMeshIsTCEnabled)("dGeomTriMeshIsTCEnabled", биб);
    вяжи(dGeomTriMeshClearTCCache)("dGeomTriMeshClearTCCache", биб);
    вяжи(dGeomTriMeshGetTriMeshDataID)("dGeomTriMeshGetTriMeshDataID", биб);
    вяжи(dGeomTriMeshGetTriangle)("dGeomTriMeshGetTriangle", биб);
    вяжи(dGeomTriMeshGetPoint)("dGeomTriMeshGetPoint", биб);
    вяжи(dGeomTriMeshGetTriangleCount)("dGeomTriMeshGetTriangleCount", биб);
    вяжи(dGeomTriMeshDataUpdate)("dGeomTriMeshDataUpdate", биб);

    // error.h
    вяжи(dSetErrorHandler)("dSetErrorHandler", биб);
    вяжи(dSetDebugHandler)("dSetDebugHandler", биб);
    вяжи(dSetMessageHandler)("dSetMessageHandler", биб);
    вяжи(dGetErrorHandler)("dGetErrorHandler", биб);
    вяжи(dGetDebugHandler)("dGetDebugHandler", биб);
    вяжи(dGetMessageHandler)("dGetMessageHandler", биб);
    вяжи(dError)("dError", биб);
    вяжи(dDebug)("dDebug", биб);
    вяжи(dMessage)("dMessage", биб);

    // mass.h
    вяжи(dMassCheck)("dMassCheck", биб);
    вяжи(dMassSetZero)("dMassSetZero", биб);
    вяжи(dMassSetParameters)("dMassSetParameters", биб);
    вяжи(dMassSetSphere)("dMassSetSphere", биб);
    вяжи(dMassSetSphereTotal)("dMassSetSphereTotal", биб);
    вяжи(dMassSetCapsule)("dMassSetCapsule", биб);
    вяжи(dMassSetCapsuleTotal)("dMassSetCapsuleTotal", биб);
    вяжи(dMassSetCylinder)("dMassSetCylinder", биб);
    вяжи(dMassSetCylinderTotal)("dMassSetCylinderTotal", биб);
    вяжи(dMassSetBox)("dMassSetBox", биб);
    вяжи(dMassSetBoxTotal)("dMassSetBoxTotal", биб);
    вяжи(dMassSetTrimesh)("dMassSetTrimesh", биб);
    вяжи(dMassSetTrimeshTotal)("dMassSetTrimeshTotal", биб);
    вяжи(dMassAdjust)("dMassAdjust", биб);
    вяжи(dMassTranslate)("dMassTranslate", биб);
    вяжи(dMassRotate)("dMassRotate", биб);
    вяжи(dMassAdd)("dMassAdd", биб);

    // matrix.h
    вяжи(dSetZero)("dSetZero", биб);
    вяжи(dSetValue)("dSetValue", биб);
    вяжи(dDot)("dDot", биб);
    вяжи(dMultiply0)("dMultiply0", биб);
    вяжи(dMultiply1)("dMultiply1", биб);
    вяжи(dMultiply2)("dMultiply2", биб);
    вяжи(dFactorCholesky)("dFactorCholesky", биб);
    вяжи(dSolveCholesky)("dSolveCholesky", биб);
    вяжи(dInvertPDMatrix)("dInvertPDMatrix", биб);
    вяжи(dIsPositiveDefinite)("dIsPositiveDefinite", биб);
    вяжи(dFactorLDLT)("dFactorLDLT", биб);
    вяжи(dSolveL1)("dSolveL1", биб);
    вяжи(dSolveL1T)("dSolveL1T", биб);
    вяжи(dVectorScale)("dVectorScale", биб);
    вяжи(dSolveLDLT)("dSolveLDLT", биб);
    вяжи(dLDLTAddTL)("dLDLTAddTL", биб);
    вяжи(dLDLTRemove)("dLDLTRemove", биб);
    вяжи(dRemoveRowCol)("dRemoveRowCol", биб);

    // memory.h
    вяжи(dSetAllocHandler)("dSetAllocHandler", биб);
    вяжи(dSetReallocHandler)("dSetReallocHandler", биб);
    вяжи(dSetFreeHandler)("dSetFreeHandler", биб);
    вяжи(dGetAllocHandler)("dGetAllocHandler", биб);
    вяжи(dGetReallocHandler)("dGetReallocHandler", биб);
    вяжи(dGetFreeHandler)("dGetFreeHandler", биб);
    вяжи(dAlloc)("dAlloc", биб);
    вяжи(dRealloc)("dRealloc", биб);
    вяжи(dFree)("dFree", биб);

    // misc.h
    вяжи(dTestRand)("dTestRand", биб);
    вяжи(dRand)("dRand", биб);
    вяжи(dRandGetSeed)("dRandGetSeed", биб);
    вяжи(dRandSetSeed)("dRandSetSeed", биб);
    вяжи(dRandInt)("dRandInt", биб);
    вяжи(dRandReal)("dRandReal", биб);
    вяжи(dPrintMatrix)("dPrintMatrix", биб);
    вяжи(dMakeRandomVector)("dMakeRandomVector", биб);
    вяжи(dMakeRandomMatrix)("dMakeRandomMatrix", биб);
    вяжи(dClearUpperTriangle)("dClearUpperTriangle", биб);
    вяжи(dMaxDifference)("dMaxDifference", биб);
    вяжи(dMaxDifferenceLowerTriangle)("dMaxDifferenceLowerTriangle", биб);

    // objects.h
    вяжи(dWorldCreate)("dWorldCreate", биб);
    вяжи(dWorldDestroy)("dWorldDestroy", биб);
    вяжи(dWorldSetGravity)("dWorldSetGravity", биб);
    вяжи(dWorldGetGravity)("dWorldGetGravity", биб);
    вяжи(dWorldSetERP)("dWorldSetERP", биб);
    вяжи(dWorldGetERP)("dWorldGetERP", биб);
    вяжи(dWorldSetCFM)("dWorldSetCFM", биб);
    вяжи(dWorldGetCFM)("dWorldGetCFM", биб);
    вяжи(dWorldStep)("dWorldStep", биб);
    вяжи(dWorldImpulseToForce)("dWorldImpulseToForce", биб);
    вяжи(dWorldQuickStep)("dWorldQuickStep", биб);
    вяжи(dWorldSetQuickStepNumIterations)("dWorldSetQuickStepNumIterations", биб);
    вяжи(dWorldGetQuickStepNumIterations)("dWorldGetQuickStepNumIterations", биб);
    вяжи(dWorldSetQuickStepW)("dWorldSetQuickStepW", биб);
    вяжи(dWorldGetQuickStepW)("dWorldGetQuickStepW", биб);
    вяжи(dWorldSetContactMaxCorrectingVel)("dWorldSetContactMaxCorrectingVel", биб);
    вяжи(dWorldGetContactMaxCorrectingVel)("dWorldGetContactMaxCorrectingVel", биб);
    вяжи(dWorldSetContactSurfaceLayer)("dWorldSetContactSurfaceLayer", биб);
    вяжи(dWorldGetContactSurfaceLayer)("dWorldGetContactSurfaceLayer", биб);
    вяжи(dWorldStepFast1)("dWorldStepFast1", биб);
    вяжи(dWorldSetAutoEnableDepthSF1)("dWorldSetAutoEnableDepthSF1", биб);
    вяжи(dWorldGetAutoEnableDepthSF1)("dWorldGetAutoEnableDepthSF1", биб);
    вяжи(dWorldGetAutoDisableLinearThreshold)("dWorldGetAutoDisableLinearThreshold", биб);
    вяжи(dWorldSetAutoDisableLinearThreshold)("dWorldSetAutoDisableLinearThreshold", биб);
    вяжи(dWorldGetAutoDisableAngularThreshold)("dWorldGetAutoDisableAngularThreshold", биб);
    вяжи(dWorldSetAutoDisableAngularThreshold)("dWorldSetAutoDisableAngularThreshold", биб);
    вяжи(dWorldGetAutoDisableAverageSamplesCount)("dWorldGetAutoDisableAverageSamplesCount", биб);
    вяжи(dWorldSetAutoDisableAverageSamplesCount)("dWorldSetAutoDisableAverageSamplesCount", биб);
    вяжи(dWorldGetAutoDisableSteps)("dWorldGetAutoDisableSteps", биб);
    вяжи(dWorldSetAutoDisableSteps)("dWorldSetAutoDisableSteps", биб);
    вяжи(dWorldGetAutoDisableTime)("dWorldGetAutoDisableTime", биб);
    вяжи(dWorldSetAutoDisableTime)("dWorldSetAutoDisableTime", биб);
    вяжи(dWorldGetAutoDisableFlag)("dWorldGetAutoDisableFlag", биб);
    вяжи(dWorldSetAutoDisableFlag)("dWorldSetAutoDisableFlag", биб);
    вяжи(dWorldGetLinearDampingThreshold)("dWorldGetLinearDampingThreshold", биб);
    вяжи(dWorldSetLinearDampingThreshold)("dWorldSetLinearDampingThreshold", биб);
    вяжи(dWorldGetAngularDampingThreshold)("dWorldGetAngularDampingThreshold", биб);
    вяжи(dWorldSetAngularDampingThreshold)("dWorldSetAngularDampingThreshold", биб);
    вяжи(dWorldGetLinearDamping)("dWorldGetLinearDamping", биб);
    вяжи(dWorldSetLinearDamping)("dWorldSetLinearDamping", биб);
    вяжи(dWorldGetAngularDamping)("dWorldGetAngularDamping", биб);
    вяжи(dWorldSetAngularDamping)("dWorldSetAngularDamping", биб);
    вяжи(dWorldSetDamping)("dWorldSetDamping", биб);
    вяжи(dWorldGetMaxAngularSpeed)("dWorldGetMaxAngularSpeed", биб);
    вяжи(dWorldSetMaxAngularSpeed)("dWorldSetMaxAngularSpeed", биб);
    вяжи(dBodyGetAutoDisableLinearThreshold)("dBodyGetAutoDisableLinearThreshold", биб);
    вяжи(dBodySetAutoDisableLinearThreshold)("dBodySetAutoDisableLinearThreshold", биб);
    вяжи(dBodyGetAutoDisableAngularThreshold)("dBodyGetAutoDisableAngularThreshold", биб);
    вяжи(dBodySetAutoDisableAngularThreshold)("dBodySetAutoDisableAngularThreshold", биб);
    вяжи(dBodyGetAutoDisableAverageSamplesCount)("dBodyGetAutoDisableAverageSamplesCount", биб);
    вяжи(dBodySetAutoDisableAverageSamplesCount)("dBodySetAutoDisableAverageSamplesCount", биб);
    вяжи(dBodyGetAutoDisableSteps)("dBodyGetAutoDisableSteps", биб);
    вяжи(dBodySetAutoDisableSteps)("dBodySetAutoDisableSteps", биб);
    вяжи(dBodyGetAutoDisableTime)("dBodyGetAutoDisableTime", биб);
    вяжи(dBodySetAutoDisableTime)("dBodySetAutoDisableTime", биб);
    вяжи(dBodyGetAutoDisableFlag)("dBodyGetAutoDisableFlag", биб);
    вяжи(dBodySetAutoDisableFlag)("dBodySetAutoDisableFlag", биб);
    вяжи(dBodySetAutoDisableDefaults)("dBodySetAutoDisableDefaults", биб);
    вяжи(dBodyGetWorld)("dBodyGetWorld", биб);
    вяжи(dBodyCreate)("dBodyCreate", биб);
    вяжи(dBodyDestroy)("dBodyDestroy", биб);
    вяжи(dBodySetData)("dBodySetData", биб);
    вяжи(dBodyGetData)("dBodyGetData", биб);
    вяжи(dBodySetPosition)("dBodySetPosition", биб);
    вяжи(dBodySetRotation)("dBodySetRotation", биб);
    вяжи(dBodySetQuaternion)("dBodySetQuaternion", биб);
    вяжи(dBodySetLinearVel)("dBodySetLinearVel", биб);
    вяжи(dBodySetAngularVel)("dBodySetAngularVel", биб);
    вяжи(dBodyGetPosition)("dBodyGetPosition", биб);
    вяжи(dBodyCopyPosition)("dBodyCopyPosition", биб);
    вяжи(dBodyGetRotation)("dBodyGetRotation", биб);
    вяжи(dBodyCopyRotation)("dBodyCopyRotation", биб);
    вяжи(dBodyGetQuaternion)("dBodyGetQuaternion", биб);
    вяжи(dBodyCopyQuaternion)("dBodyCopyQuaternion", биб);
    вяжи(dBodyGetLinearVel)("dBodyGetLinearVel", биб);
    вяжи(dBodyGetAngularVel)("dBodyGetAngularVel", биб);
    вяжи(dBodySetMass)("dBodySetMass", биб);
    вяжи(dBodyGetMass)("dBodyGetMass", биб);
    вяжи(dBodyAddForce)("dBodyAddForce", биб);
    вяжи(dBodyAddTorque)("dBodyAddTorque", биб);
    вяжи(dBodyAddRelForce)("dBodyAddRelForce", биб);
    вяжи(dBodyAddRelTorque)("dBodyAddRelTorque", биб);
    вяжи(dBodyAddForceAtPos)("dBodyAddForceAtPos", биб);
    вяжи(dBodyAddForceAtRelPos)("dBodyAddForceAtRelPos", биб);
    вяжи(dBodyAddRelForceAtPos)("dBodyAddRelForceAtPos", биб);
    вяжи(dBodyAddRelForceAtRelPos)("dBodyAddRelForceAtRelPos", биб);
    вяжи(dBodyGetForce)("dBodyGetForce", биб);
    вяжи(dBodyGetTorque)("dBodyGetTorque", биб);
    вяжи(dBodySetForce)("dBodySetForce", биб);
    вяжи(dBodySetTorque)("dBodySetTorque", биб);
    вяжи(dBodyGetRelPointPos)("dBodyGetRelPointPos", биб);
    вяжи(dBodyGetRelPointVel)("dBodyGetRelPointVel", биб);
    вяжи(dBodyGetPointVel)("dBodyGetPointVel", биб);
    вяжи(dBodyGetPosRelPoint)("dBodyGetPosRelPoint", биб);
    вяжи(dBodyVectorToWorld)("dBodyVectorToWorld", биб);
    вяжи(dBodyVectorFromWorld)("dBodyVectorFromWorld", биб);
    вяжи(dBodySetFiniteRotationMode)("dBodySetFiniteRotationMode", биб);
    вяжи(dBodySetFiniteRotationAxis)("dBodySetFiniteRotationAxis", биб);
    вяжи(dBodyGetFiniteRotationMode)("dBodyGetFiniteRotationMode", биб);
    вяжи(dBodyGetFiniteRotationAxis)("dBodyGetFiniteRotationAxis", биб);
    вяжи(dBodyGetNumJoints)("dBodyGetNumJoints", биб);
    вяжи(dBodyGetJoint)("dBodyGetJoint", биб);
    вяжи(dBodySetDynamic)("dBodySetDynamic", биб);
    вяжи( dBodySetKinematic)("dBodySetKinematic", биб);
    вяжи(dBodyIsKinematic)("dBodyIsKinematic", биб);
    вяжи(dBodyEnable)("dBodyEnable", биб);
    вяжи(dBodyDisable)("dBodyDisable", биб);
    вяжи(dBodyIsEnabled)("dBodyIsEnabled", биб);
    вяжи(dBodySetGravityMode)("dBodySetGravityMode", биб);
    вяжи(dBodyGetGravityMode)("dBodyGetGravityMode", биб);
    вяжи(dBodySetMovedCallback)("dBodySetMovedCallback", биб);
    вяжи(dBodyGetFirstGeom)("dBodyGetFirstGeom", биб);
    вяжи(dBodyGetNextGeom)("dBodyGetNextGeom", биб);
    вяжи(dBodySetDampingDefaults)("dBodySetDampingDefaults", биб);
    вяжи(dBodyGetLinearDamping)("dBodyGetLinearDamping", биб);
    вяжи(dBodySetLinearDamping)("dBodySetLinearDamping", биб);
    вяжи(dBodyGetAngularDamping)("dBodyGetAngularDamping", биб);
    вяжи(dBodySetAngularDamping)("dBodySetAngularDamping", биб);
    вяжи(dBodySetDamping)("dBodySetDamping", биб);
    вяжи(dBodyGetLinearDampingThreshold)("dBodyGetLinearDampingThreshold", биб);
    вяжи(dBodySetLinearDampingThreshold)("dBodySetLinearDampingThreshold", биб);
    вяжи(dBodyGetAngularDampingThreshold)("dBodyGetAngularDampingThreshold", биб);
    вяжи(dBodySetAngularDampingThreshold)("dBodySetAngularDampingThreshold", биб);
    вяжи(dBodyGetMaxAngularSpeed)("dBodyGetMaxAngularSpeed", биб);
    вяжи(dBodySetMaxAngularSpeed)("dBodySetMaxAngularSpeed", биб);
    вяжи(dBodyGetGyroscopicMode)("dBodyGetGyroscopicMode", биб);
    вяжи(dBodySetGyroscopicMode)("dBodySetGyroscopicMode", биб);
    вяжи(dJointCreateBall)("dJointCreateBall", биб);
    вяжи(dJointCreateHinge)("dJointCreateHinge", биб);
    вяжи(dJointCreateSlider)("dJointCreateSlider", биб);
    вяжи(dJointCreateContact)("dJointCreateContact", биб);
    вяжи(dJointCreateHinge2)("dJointCreateHinge2", биб);
    вяжи(dJointCreateUniversal)("dJointCreateUniversal", биб);
    вяжи(dJointCreatePR)("dJointCreatePR", биб);
    вяжи(dJointCreatePU)("dJointCreatePU", биб);
    вяжи(dJointCreatePiston)("dJointCreatePiston", биб);
    вяжи(dJointCreateFixed)("dJointCreateFixed", биб);
    вяжи(dJointCreateNull)("dJointCreateNull", биб);
    вяжи(dJointCreateAMotor)("dJointCreateAMotor", биб);
    вяжи(dJointCreateLMotor)("dJointCreateLMotor", биб);
    вяжи(dJointCreatePlane2D)("dJointCreatePlane2D", биб);
    вяжи(dJointDestroy)("dJointDestroy", биб);
    вяжи(dJointGroupCreate)("dJointGroupCreate", биб);
    вяжи(dJointGroupDestroy)("dJointGroupDestroy", биб);
    вяжи(dJointGroupEmpty)("dJointGroupEmpty", биб);
    вяжи(dJointGetNumBodies)("dJointGetNumBodies", биб);
    вяжи(dJointAttach)("dJointAttach", биб);
    вяжи(dJointEnable)("dJointEnable", биб);
    вяжи(dJointDisable)("dJointDisable", биб);
    вяжи(dJointIsEnabled)("dJointIsEnabled", биб);
    вяжи(dJointSetData)("dJointSetData", биб);
    вяжи(dJointGetData)("dJointGetData", биб);
    вяжи(dJointGetType)("dJointGetType", биб);
    вяжи(dJointGetBody)("dJointGetBody", биб);
    вяжи(dJointSetFeedback)("dJointSetFeedback", биб);
    вяжи(dJointGetFeedback)("dJointGetFeedback", биб);
    вяжи(dJointSetBallAnchor)("dJointSetBallAnchor", биб);
    вяжи(dJointSetBallAnchor2)("dJointSetBallAnchor2", биб);
    вяжи(dJointSetBallParam)("dJointSetBallParam", биб);
    вяжи(dJointSetHingeAnchor)("dJointSetHingeAnchor", биб);
    вяжи(dJointSetHingeAnchorDelta)("dJointSetHingeAnchorDelta", биб);
    вяжи(dJointSetHingeAxis)("dJointSetHingeAxis", биб);
    вяжи(dJointSetHingeAxisOffset)("dJointSetHingeAxisOffset", биб);
    вяжи(dJointSetHingeParam)("dJointSetHingeParam", биб);
    вяжи(dJointAddHingeTorque)("dJointAddHingeTorque", биб);
    вяжи(dJointSetSliderAxis)("dJointSetSliderAxis", биб);
    вяжи(dJointSetSliderAxisDelta)("dJointSetSliderAxisDelta", биб);
    вяжи(dJointSetSliderParam)("dJointSetSliderParam", биб);
    вяжи(dJointAddSliderForce)("dJointAddSliderForce", биб);
    вяжи(dJointSetHinge2Anchor)("dJointSetHinge2Anchor", биб);
    вяжи(dJointSetHinge2Axis1)("dJointSetHinge2Axis1", биб);
    вяжи(dJointSetHinge2Axis2)("dJointSetHinge2Axis2", биб);
    вяжи(dJointSetHinge2Param)("dJointSetHinge2Param", биб);
    вяжи(dJointAddHinge2Torques)("dJointAddHinge2Torques", биб);
    вяжи(dJointSetUniversalAnchor)("dJointSetUniversalAnchor", биб);
    вяжи(dJointSetUniversalAxis1)("dJointSetUniversalAxis1", биб);
    вяжи(dJointSetUniversalAxis1Offset)("dJointSetUniversalAxis1Offset", биб);
    вяжи(dJointSetUniversalAxis2)("dJointSetUniversalAxis2", биб);
    вяжи(dJointSetUniversalAxis2Offset)("dJointSetUniversalAxis2Offset", биб);
    вяжи(dJointSetUniversalParam)("dJointSetUniversalParam", биб);
    вяжи(dJointAddUniversalTorques)("dJointAddUniversalTorques", биб);
    вяжи(dJointSetPRAnchor)("dJointSetPRAnchor", биб);
    вяжи(dJointSetPRAxis1)("dJointSetPRAxis1", биб);
    вяжи(dJointSetPRAxis2)("dJointSetPRAxis2", биб);
    вяжи(dJointSetPRParam)("dJointSetPRParam", биб);
    вяжи(dJointAddPRTorque)("dJointAddPRTorque", биб);
    вяжи(dJointSetPUAnchor)("dJointSetPUAnchor", биб);
    вяжи(dJointSetPUAnchorOffset)("dJointSetPUAnchorOffset", биб);
    вяжи(dJointSetPUAxis1)("dJointSetPUAxis1", биб);
    вяжи(dJointSetPUAxis2)("dJointSetPUAxis2", биб);
    вяжи(dJointSetPUAxis3)("dJointSetPUAxis3", биб);
    вяжи(dJointSetPUAxisP)("dJointSetPUAxisP", биб);
    вяжи(dJointSetPUParam)("dJointSetPUParam", биб);
    вяжи(dJointSetPistonAnchor)("dJointSetPistonAnchor", биб);
    вяжи(dJointSetPistonAnchorOffset)("dJointSetPistonAnchorOffset", биб);
    вяжи(dJointSetPistonAxis)("dJointSetPistonAxis", биб);
    вяжи(dJointSetPistonParam)("dJointSetPistonParam", биб);
    вяжи(dJointAddPistonForce)("dJointAddPistonForce", биб);
    вяжи(dJointSetFixed)("dJointSetFixed", биб);
    вяжи(dJointSetFixedParam)("dJointSetFixedParam", биб);
    вяжи(dJointSetAMotorNumAxes)("dJointSetAMotorNumAxes", биб);
    вяжи(dJointSetAMotorAxis)("dJointSetAMotorAxis", биб);
    вяжи(dJointSetAMotorAngle)("dJointSetAMotorAngle", биб);
    вяжи(dJointSetAMotorParam)("dJointSetAMotorParam", биб);
    вяжи(dJointSetAMotorMode)("dJointSetAMotorMode", биб);
    вяжи(dJointAddAMotorTorques)("dJointAddAMotorTorques", биб);
    вяжи(dJointSetLMotorNumAxes)("dJointSetLMotorNumAxes", биб);
    вяжи(dJointSetLMotorAxis)("dJointSetLMotorAxis", биб);
    вяжи(dJointSetLMotorParam)("dJointSetLMotorParam", биб);
    вяжи(dJointSetPlane2DXParam)("dJointSetPlane2DXParam", биб);
    вяжи(dJointSetPlane2DYParam)("dJointSetPlane2DYParam", биб);
    вяжи(dJointSetPlane2DAngleParam)("dJointSetPlane2DAngleParam", биб);
    вяжи(dJointGetBallAnchor)("dJointGetBallAnchor", биб);
    вяжи(dJointGetBallAnchor2)("dJointGetBallAnchor2", биб);
    вяжи(dJointGetBallParam)("dJointGetBallParam", биб);
    вяжи(dJointGetHingeAnchor)("dJointGetHingeAnchor", биб);
    вяжи(dJointGetHingeAnchor2)("dJointGetHingeAnchor2", биб);
    вяжи(dJointGetHingeAxis)("dJointGetHingeAxis", биб);
    вяжи(dJointGetHingeParam)("dJointGetHingeParam", биб);
    вяжи(dJointGetHingeAngle)("dJointGetHingeAngle", биб);
    вяжи(dJointGetHingeAngleRate)("dJointGetHingeAngleRate", биб);
    вяжи(dJointGetSliderPosition)("dJointGetSliderPosition", биб);
    вяжи(dJointGetSliderPositionRate)("dJointGetSliderPositionRate", биб);
    вяжи(dJointGetSliderAxis)("dJointGetSliderAxis", биб);
    вяжи(dJointGetSliderParam)("dJointGetSliderParam", биб);
    вяжи(dJointGetHinge2Anchor)("dJointGetHinge2Anchor", биб);
    вяжи(dJointGetHinge2Anchor2)("dJointGetHinge2Anchor2", биб);
    вяжи(dJointGetHinge2Axis1)("dJointGetHinge2Axis1", биб);
    вяжи(dJointGetHinge2Axis2)("dJointGetHinge2Axis2", биб);
    вяжи(dJointGetHinge2Param)("dJointGetHinge2Param", биб);
    вяжи(dJointGetHinge2Angle1)("dJointGetHinge2Angle1", биб);
    вяжи(dJointGetHinge2Angle1Rate)("dJointGetHinge2Angle1Rate", биб);
    вяжи(dJointGetHinge2Angle2Rate)("dJointGetHinge2Angle2Rate", биб);
    вяжи(dJointGetUniversalAnchor)("dJointGetUniversalAnchor", биб);
    вяжи(dJointGetUniversalAnchor2)("dJointGetUniversalAnchor2", биб);
    вяжи(dJointGetUniversalAxis1)("dJointGetUniversalAxis1", биб);
    вяжи(dJointGetUniversalAxis2)("dJointGetUniversalAxis2", биб);
    вяжи(dJointGetUniversalParam)("dJointGetUniversalParam", биб);
    вяжи(dJointGetUniversalAngles)("dJointGetUniversalAngles", биб);
    вяжи(dJointGetUniversalAngle1)("dJointGetUniversalAngle1", биб);
    вяжи(dJointGetUniversalAngle2)("dJointGetUniversalAngle2", биб);
    вяжи(dJointGetUniversalAngle1Rate)("dJointGetUniversalAngle1Rate", биб);
    вяжи(dJointGetUniversalAngle2Rate)("dJointGetUniversalAngle2Rate", биб);
    вяжи(dJointGetPRAnchor)("dJointGetPRAnchor", биб);
    вяжи(dJointGetPRPosition)("dJointGetPRPosition", биб);
    вяжи(dJointGetPRPositionRate)("dJointGetPRPositionRate", биб);
    вяжи(dJointGetPRAngle)("dJointGetPRAngle", биб);
    вяжи(dJointGetPRAngleRate)("dJointGetPRAngleRate", биб);
    вяжи(dJointGetPRAxis1)("dJointGetPRAxis1", биб);
    вяжи(dJointGetPRAxis2)("dJointGetPRAxis2", биб);
    вяжи(dJointGetPRParam)("dJointGetPRParam", биб);
    вяжи(dJointGetPUAnchor)("dJointGetPUAnchor", биб);
    вяжи(dJointGetPUPosition)("dJointGetPUPosition", биб);
    вяжи(dJointGetPUPositionRate)("dJointGetPUPositionRate", биб);
    вяжи(dJointGetPUAxis1)("dJointGetPUAxis1", биб);
    вяжи(dJointGetPUAxis2)("dJointGetPUAxis2", биб);
    вяжи(dJointGetPUAxis3)("dJointGetPUAxis3", биб);
    вяжи(dJointGetPUAxisP)("dJointGetPUAxisP", биб);
    вяжи(dJointGetPUAngles)("dJointGetPUAngles", биб);
    вяжи(dJointGetPUAngle1)("dJointGetPUAngle1", биб);
    вяжи(dJointGetPUAngle1Rate)("dJointGetPUAngle1Rate", биб);
    вяжи(dJointGetPUAngle2)("dJointGetPUAngle2", биб);
    вяжи(dJointGetPUAngle2Rate)("dJointGetPUAngle2Rate", биб);
    вяжи(dJointGetPUParam)("dJointGetPUParam", биб);
    вяжи(dJointGetPistonPosition)("dJointGetPistonPosition", биб);
    вяжи(dJointGetPistonPositionRate)("dJointGetPistonPositionRate", биб);
    вяжи(dJointGetPistonAngle)("dJointGetPistonAngle", биб);
    вяжи(dJointGetPistonAngleRate)("dJointGetPistonAngleRate", биб);
    вяжи(dJointGetPistonAnchor)("dJointGetPistonAnchor", биб);
    вяжи(dJointGetPistonAnchor2)("dJointGetPistonAnchor2", биб);
    вяжи(dJointGetPistonAxis)("dJointGetPistonAxis", биб);
    вяжи(dJointGetPistonParam)("dJointGetPistonParam", биб);
    вяжи(dJointGetAMotorNumAxes)("dJointGetAMotorNumAxes", биб);
    вяжи(dJointGetAMotorAxis)("dJointGetAMotorAxis", биб);
    вяжи(dJointGetAMotorAxisRel)("dJointGetAMotorAxisRel", биб);
    вяжи(dJointGetAMotorAngle)("dJointGetAMotorAngle", биб);
    вяжи(dJointGetAMotorAngleRate)("dJointGetAMotorAngleRate", биб);
    вяжи(dJointGetAMotorParam)("dJointGetAMotorParam", биб);
    вяжи(dJointGetAMotorMode)("dJointGetAMotorMode", биб);
    вяжи(dJointGetLMotorNumAxes)("dJointGetLMotorNumAxes", биб);
    вяжи(dJointGetLMotorAxis)("dJointGetLMotorAxis", биб);
    вяжи(dJointGetLMotorParam)("dJointGetLMotorParam", биб);
    вяжи(dJointGetFixedParam)("dJointGetFixedParam", биб);
    вяжи(dConnectingJoint)("dConnectingJoint", биб);
    вяжи(dConnectingJointList)("dConnectingJointList", биб);
    вяжи(dAreConnected)("dAreConnected", биб);
    вяжи(dAreConnectedExcluding)("dAreConnectedExcluding", биб);

    // odeinit.h
    вяжи(dInitODE)("dInitODE", биб);
    вяжи(dInitODE2)("dInitODE2", биб);
    вяжи(dAllocateODEDataForThread)("dAllocateODEDataForThread", биб);
    вяжи(dCleanupODEAllDataForThread)("dCleanupODEAllDataForThread", биб);
    вяжи(dCloseODE)("dCloseODE", биб);

    // rotation.h
    вяжи(dRSetIdentity)("dRSetIdentity", биб);
    вяжи(dRFromAxisAndAngle)("dRFromAxisAndAngle", биб);
    вяжи(dRFromEulerAngles)("dRFromEulerAngles", биб);
    вяжи(dRFrom2Axes)("dRFrom2Axes", биб);
    вяжи(dRFromZAxis)("dRFromZAxis", биб);
    вяжи(dQSetIdentity)("dQSetIdentity", биб);
    вяжи(dQFromAxisAndAngle)("dQFromAxisAndAngle", биб);
    вяжи(dQMultiply0)("dQMultiply0", биб);
    вяжи(dQMultiply1)("dQMultiply1", биб);
    вяжи(dQMultiply2)("dQMultiply2", биб);
    вяжи(dQMultiply3)("dQMultiply3", биб);
    вяжи(dRfromQ)("dRfromQ", биб);
    вяжи(dQfromR)("dQfromR", биб);
    вяжи(dDQfromW)("dDQfromW", биб);

    // timer.h
    вяжи(dStopwatchReset)("dStopwatchReset", биб);
    вяжи(dStopwatchStart)("dStopwatchStart", биб);
    вяжи(dStopwatchStop)("dStopwatchStop", биб);
    вяжи(dStopwatchTime)("dStopwatchTime", биб);
    вяжи(dTimerStart)("dTimerStart", биб);
    вяжи(dTimerNow)("dTimerNow", биб);
    вяжи(dTimerEnd)("dTimerEnd", биб);
    вяжи(dTimerReport)("dTimerReport", биб);
    вяжи(dTimerTicksPerSecond)("dTimerTicksPerSecond", биб);
    вяжи(dTimerResolution)("dTimerResolution", биб);

    // defined in interface, present in ODE source, but consistently fails to грузи
    // вяжи(dWorldExportDIF)("dWorldExportDIF", биб);
}

ЖанБибгр ОДЕ;
static this() {
    version(ДвойнаяТочность)
    {
        char[] winlib = "ode_double.dll";
        char[] linlib = "libode_double.so";
    }
    else
    {
        char[] winlib = "ode_single.dll";
        char[] linlib = "ode_double.dll";
    }
    ОДЕ.заряжай( winlib,  &грузи );
	ОДЕ.загружай();
}

extern(C)
{
    // common.h
    ткст0 function() дайКонфигурацию;
    цел function(in ткст0) проверьКонфигурацию;

    // collision.h
    проц function(дГеомИД) dGeomDestroy;
    проц function(дГеомИД, ук) dGeomSetData;
    ук function(дГеомИД) dGeomGetData;
    проц function(дГеомИД, дИДТела) dGeomSetBody;
    дИДТела function(дГеомИД) dGeomGetBody;
    проц function(дГеомИД, дРеал, дРеал, дРеал) dGeomSetPosition;
    проц function(дГеомИД, in дМатрица3) dGeomSetRotation;
    проц function(дГеомИД, in дКватернион) dGeomSetQuaternion;
    дРеал* function(дГеомИД) dGeomGetPosition;
    проц function(дГеомИД, дВектор3) dGeomCopyPosition;
    дРеал* function(дГеомИД)  dGeomGetRotation;
    проц function(дГеомИД, дМатрица3) dGeomCopyRotation;
    проц function(дГеомИД, дКватернион) dGeomGetQuaternion;
    проц function(дГеомИД, дРеал[6]) dGeomGetAABB;
    цел function(дГеомИД) dGeomIsSpace;
    дИДПространства function(дГеомИД) dGeomGetSpace;
    цел function(дГеомИД) dGeomGetClass;
    проц function(дГеомИД, бцел) dGeomSetCategoryBits;
    проц function(дГеомИД, бцел) dGeomSetCollideBits;
    бцел function(дГеомИД) dGeomGetCategoryBits;
    бцел function(дГеомИД) dGeomGetCollideBits;
    проц function(дГеомИД) dGeomEnable;
    проц function(дГеомИД) dGeomDisable;
    цел function(дГеомИД) dGeomIsEnabled;
    проц function(дГеомИД, дРеал, дРеал, дРеал) dGeomSetOffsetPosition;
    проц function(дГеомИД, in дМатрица3) dGeomSetOffsetRotation;
    проц function(дГеомИД, in дКватернион) dGeomSetOffsetQuaternion;
    проц function(дГеомИД, дРеал, дРеал, дРеал) dGeomSetOffsetWorldPosition;
    проц function(дГеомИД, in дМатрица3) dGeomSetOffsetWorldRotation;
    проц function(дГеомИД, цел дКватернион) dGeomSetOffsetWorldQuaternion;
    проц function(дГеомИД) dGeomClearOffset;
    цел function(дГеомИД) dGeomIsOffset;
    дРеал* function(дГеомИД) dGeomGetOffsetPosition;
    проц function(дГеомИД, дВектор3) dGeomCopyOffsetPosition;
    дРеал* function(дГеомИД) dGeomGetOffsetRotation;
    проц function(дГеомИД, дКватернион) dGeomGetOffsetQuaternion;
    цел function(дГеомИД, дГеомИД, цел, dContactGeom*) dCollide;
    проц function(дИДПространства, ук, dNearCallback) dSpaceCollide;
    проц function(дГеомИД, дГеомИД, ук, dNearCallback) dSpaceCollide2;
    дГеомИД function(дИДПространства, дРеал) dCreateSphere;
    проц function(дГеомИД, дРеал) dGeomSphereSetRadius;
    дРеал function(дГеомИД) dGeomSphereGetRadius;
    дРеал function(дГеомИД, дРеал, дРеал, дРеал) dGeomSpherePointDepth;
    дГеомИД function(дИДПространства, дРеал*, бцел, дРеал*, бцел, бцел*) dCreateConvex;
    проц function(дГеомИД, дРеал*, бцел, дРеал*, бцел, бцел*) dGeomSetConvex;
    дГеомИД function(дИДПространства, дРеал, дРеал, дРеал) dCreateBox;
    проц function(дГеомИД, дРеал, дРеал, дРеал) dGeomBoxSetLengths;
    проц function(дГеомИД, дВектор3) dGeomBoxGetLengths;
    дРеал function(дГеомИД, дРеал, дРеал, дРеал) dGeomBoxPointDepth;
    дГеомИД function(дИДПространства, дРеал, дРеал, дРеал, дРеал) dCreatePlane;
    проц function(дГеомИД, дРеал, дРеал, дРеал, дРеал) dGeomPlaneSetParams;
    проц function(дГеомИД, дВектор4) dGeomPlaneGetParams;
    дРеал function(дГеомИД, дРеал, дРеал, дРеал) dGeomPlanePointDepth;
    дГеомИД function(дИДПространства, дРеал, дРеал) dCreateCapsule;
    проц function(дГеомИД, дРеал, дРеал) dGeomCapsuleSetParams;
    проц function(дГеомИД, дРеал*, дРеал*) dGeomCapsuleGetParams;
    дРеал function(дГеомИД, дРеал, дРеал, дРеал) dGeomCapsulePointDepth;
    дГеомИД function(дИДПространства, дРеал, дРеал) dCreateCylinder;
    проц function(дГеомИД, дРеал, дРеал) dGeomCylinderSetParams;
    проц function(дГеомИД, дРеал*, дРеал*) dGeomCylinderGetParams;
    дГеомИД function(дИДПространства, дРеал) dCreateRay;
    проц function(дГеомИД, дРеал) dGeomRaySetLength;
    дРеал function(дГеомИД) dGeomRayGetLength;
    проц function(дГеомИД, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dGeomRaySet;
    проц function(дГеомИД, дВектор3, дВектор3) dGeomRayGet;
    проц function(дГеомИД, цел, цел) dGeomRaySetParams;
    проц function(дГеомИД, цел*, цел*) dGeomRayGetParams;
    проц function(дГеомИД, цел) dGeomRaySetClosestHit;
    цел function(дГеомИД) dGeomRayGetClosestHit;
    дГеомИД function(дИДПространства) dCreateGeomTransform;
    проц function(дГеомИД, дГеомИД) dGeomTransformSetGeom;
    дГеомИД function(дГеомИД) dGeomTransformGetGeom;
    проц function(дГеомИД, цел) dGeomTransformSetCleanup;
    цел function(дГеомИД) dGeomTransformGetCleanup;
    проц function(дГеомИД, цел) dGeomTransformSetInfo;
    цел function(дГеомИД) dGeomTransformGetInfo;
    дГеомИД function(дИДПространства, dHeightfieldDataID, цел) dCreateHeightfield;
    dHeightfieldDataID function() dGeomHeightfieldDataCreate;
    проц function(dHeightfieldDataID) dGeomHeightfieldDataDestroy;
    проц function(dHeightfieldDataID, ук, dHeightfieldGetHeight, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildCallback;
    проц function(dHeightfieldDataID, in ббайт*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildByte;
    проц function(dHeightfieldDataID, in крат*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildShort;
    проц function(dHeightfieldDataID, in плав*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildSingle;
    проц function(dHeightfieldDataID, in дво*, цел, дРеал, дРеал, цел, цел, дРеал, дРеал, дРеал, цел) dGeomHeightfieldDataBuildDouble;
    проц function(dHeightfieldDataID, дРеал, дРеал) dGeomHeightfieldDataSetBounds;
    проц function(дГеомИД, dHeightfieldDataID) dGeomHeightfieldSetHeightfieldData;
    dHeightfieldDataID function(дГеомИД) dGeomHeightfieldGetHeightfieldData;
    проц function(in дВектор3, in дВектор3, in дВектор3, in дВектор3, дВектор3, дВектор3) dClosestLineSegmentPoints;
    цел function(in дВектор3, in дМатрица3, in дВектор3, in дВектор3, in дМатрица3, in дВектор3) dBoxTouchesBox;
    цел function(in дВектор3, in дМатрица3, in дВектор3, in дВектор3, in дМатрица3, in дВектор3, дВектор3, дРеал*, цел*, цел, dContactGeom*, цел) dBoxBox;
    проц function(дГеомИД, дРеал[6]) dInfiniteAABB;
    цел function(in dGeomClass*) dCreateGeomClass;
    ук function(дГеомИД) dGeomGetClassData;
    дГеомИД function(цел) dCreateGeom;
    проц function(цел, цел, dColliderFn) dSetColliderOverride;

    alias dCreateCapsule dCreateCCylinder;
    alias dGeomCapsuleSetParams dGeomCCylinderSetParams;
    alias dGeomCapsuleGetParams dGeomCCylinderGetParams;
    alias dGeomCapsulePointDepth dGeomCCylinderPointDepth;

    // collision_space.h
    дИДПространства function(дИДПространства) dSimpleSpaceCreate;
    дИДПространства function(дИДПространства) dHashSpaceCreate;
    дИДПространства function(дИДПространства, in дВектор3, in дВектор3, цел) dQuadTreeSpaceCreate;
    дИДПространства function(дИДПространства, цел) dSweepAndPruneSpaceCreate;
    проц function(дИДПространства) dSpaceDestroy;
    проц function(дИДПространства, цел, цел) dHashSpaceSetLevels;
    проц function(дИДПространства, цел*, цел*) dHashSpaceGetLevels;
    проц function(дИДПространства, цел) dSpaceSetCleanup;
    цел function(дИДПространства) dSpaceGetCleanup;
    проц function(дИДПространства, цел) dSpaceSetSublevel;
    цел function(дИДПространства) dSpaceGetSublevel;
    проц function(дИДПространства, дГеомИД) dSpaceAdd;
    проц function(дИДПространства, дГеомИД) dSpaceRemove;
    цел function(дИДПространства, дГеомИД) dSpaceQuery;
    проц function(дИДПространства) dSpaceClean;
    цел function(дИДПространства) dSpaceGetNumGeoms;
    дГеомИД function(дИДПространства, цел) dSpaceGetGeom;
    цел function(дИДПространства) dSpaceGetClass;

    // collision_trimesh.h
    dTriMeshDataID function() dGeomTriMeshDataCreate;
    проц function(dTriMeshDataID) dGeomTriMeshDataDestroy;
    проц function(dTriMeshDataID, цел, ук) dGeomTriMeshDataSet;
    ук function(dTriMeshDataID, цел) dGeomTriMeshDataGet;
    проц function(дГеомИД, дМатрица4) dGeomTriMeshSetLastTransform;
    дРеал* function(дГеомИД) dGeomTriMeshGetLastTransform;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел) dGeomTriMeshDataBuildSingle;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел, in ук) dGeomTriMeshDataBuildSingle1;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел) dGeomTriMeshDataBuildDouble;
    проц function(dTriMeshDataID, in ук, цел, цел, in ук, цел, цел, in ук) dGeomTriMeshDataBuildDouble1;
    проц function(dTriMeshDataID, in дРеал*, цел, in dTriIndex*, цел) dGeomTriMeshDataBuildSimple;
    проц function(dTriMeshDataID, in дРеал*, цел, in dTriIndex*, цел, in цел*) dGeomTriMeshDataBuildSimple1;
    проц function(dTriMeshDataID) dGeomTriMeshDataPreprocess;
    проц function(dTriMeshDataID, ббайт**, цел*) dGeomTriMeshDataGetBuffer;
    проц function(dTriMeshDataID, ббайт*) dGeomTriMeshDataSetBuffer;
    проц function(дГеомИД, dTriCallback) dGeomTriMeshSetCallback;
    dTriCallback function(дГеомИД) dGeomTriMeshGetCallback;
    проц function(дГеомИД, dTriArrayCallback) dGeomTriMeshSetArrayCallback;
    dTriArrayCallback function(дГеомИД) dGeomTriMeshGetArrayCallback;
    проц function(дГеомИД, dTriRayCallback) dGeomTriMeshSetRayCallback;
    dTriRayCallback function(дГеомИД) dGeomTriMeshGetRayCallback;
    проц function(дГеомИД, dTriTriMergeCallback) dGeomTriMeshSetTriMergeCallback;
    dTriTriMergeCallback function(дГеомИД) dGeomTriMeshGetTriMergeCallback;
    дГеомИД function(дИДПространства, dTriMeshDataID, dTriCallback, dTriArrayCallback, dTriRayCallback) dCreateTriMesh;
    проц function(дГеомИД, dTriMeshDataID) dGeomTriMeshSetData;
    dTriMeshDataID function(дГеомИД) dGeomTriMeshGetData;
    проц function(дГеомИД, цел, цел) dGeomTriMeshEnableTC;
    цел function(дГеомИД, цел) dGeomTriMeshIsTCEnabled;
    проц function(дГеомИД) dGeomTriMeshClearTCCache;
    dTriMeshDataID function(дГеомИД) dGeomTriMeshGetTriMeshDataID;
    проц function(дГеомИД, цел, дВектор3*, дВектор3*, дВектор3*) dGeomTriMeshGetTriangle;
    проц function(дГеомИД, цел, дРеал, дРеал, дВектор3) dGeomTriMeshGetPoint;
    цел function(дГеомИД) dGeomTriMeshGetTriangleCount;
    проц function(dTriMeshDataID) dGeomTriMeshDataUpdate;

    // error.h
    проц function(dMessageFunction) dSetErrorHandler;
    проц function(dMessageFunction) dSetDebugHandler;
    проц function(dMessageFunction) dSetMessageHandler;
    dMessageFunction function() dGetErrorHandler;
    dMessageFunction function() dGetDebugHandler;
    dMessageFunction function() dGetMessageHandler;
    проц function(цел, in ткст0, ...) dError;
    проц function(цел, in ткст0, ...) dDebug;
    проц function(цел, in ткст0, ...) dMessage;

    // mass.h
    цел function(in dMass*) dMassCheck;
    проц function(dMass*) dMassSetZero;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dMassSetParameters;
    проц function(dMass*, дРеал, дРеал) dMassSetSphere;
    проц function(dMass*, дРеал, дРеал) dMassSetSphereTotal;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCapsule;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCapsuleTotal;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCylinder;
    проц function(dMass*, дРеал, цел, дРеал, дРеал) dMassSetCylinderTotal;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал) dMassSetBox;
    проц function(dMass*, дРеал, дРеал, дРеал, дРеал) dMassSetBoxTotal;
    проц function(dMass*, дРеал, дГеомИД) dMassSetTrimesh;
    проц function(dMass*, дРеал, дГеомИД) dMassSetTrimeshTotal;
    проц function(dMass*, дРеал) dMassAdjust;
    проц function(dMass*, дРеал, дРеал, дРеал) dMassTranslate;
    проц function(dMass*, in дМатрица3) dMassRotate;
    проц function(dMass*, in dMass*) dMassAdd;

    // matrix.h
    проц function(дРеал*, цел) dSetZero;
    проц function(дРеал*, цел, дРеал) dSetValue;
    дРеал function(in дРеал*, in дРеал*, цел) dDot;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply0;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply1;
    проц function(дРеал*, in дРеал*, in дРеал*, цел, цел, цел) dMultiply2;
    цел function(дРеал*, цел) dFactorCholesky;
    проц function(in дРеал*, дРеал*, цел) dSolveCholesky;
    цел function(in дРеал*, дРеал*, цел) dInvertPDMatrix;
    цел function(in дРеал*, цел) dIsPositiveDefinite;
    проц function(дРеал*, дРеал*, цел, цел) dFactorLDLT;
    проц function(in дРеал*, дРеал*, цел, цел) dSolveL1;
    проц function(in дРеал*, дРеал*, цел, цел) dSolveL1T;
    проц function(дРеал*, in дРеал*, цел) dVectorScale;
    проц function(in дРеал*, in дРеал*, дРеал*, цел, цел) dSolveLDLT;
    проц function(дРеал*, дРеал*, in дРеал*, цел, цел) dLDLTAddTL;
    проц function(дРеал**, in цел*, дРеал*, дРеал*, цел, цел, цел, цел) dLDLTRemove;
    проц function(дРеал*, цел, цел, цел) dRemoveRowCol;

    // memory.h
    проц function(dAllocFunction) dSetAllocHandler;
    проц function(dReallocFunction) dSetReallocHandler;
    проц function(dFreeFunction) dSetFreeHandler;
    dAllocFunction function() dGetAllocHandler;
    dReallocFunction function() dGetReallocHandler;
    dFreeFunction function() dGetFreeHandler;
    ук function(size_t) dAlloc;
    ук function(ук, size_t, size_t) dRealloc;
    проц function(ук, size_t) dFree;

    // misc.h
    цел function() dTestRand;
    бцел function() dRand;
    бцел function() dRandGetSeed;
    проц function(бцел) dRandSetSeed;
    цел function(цел) dRandInt;
    дРеал function() dRandReal;
    проц function(in дРеал*, цел, цел, ткст0, фук) dPrintMatrix;
    проц function(дРеал, цел, дРеал) dMakeRandomVector;
    проц function(дРеал*, цел, цел, дРеал) dMakeRandomMatrix;
    проц function(дРеал*, цел) dClearUpperTriangle;
    дРеал function(in дРеал*, in дРеал*, цел, цел) dMaxDifference;
    дРеал function(in дРеал*, in дРеал*, цел) dMaxDifferenceLowerTriangle;

    // objects.h
    дИДМира function() dWorldCreate;
    проц function(дИДМира) dWorldDestroy;
    проц function(дИДМира, дРеал, дРеал, дРеал) dWorldSetGravity;
    проц function(дИДМира, дВектор3) dWorldGetGravity;
    проц function(дИДМира, дРеал) dWorldSetERP;
    дРеал function(дИДМира) dWorldGetERP;
    проц function(дИДМира, дРеал) dWorldSetCFM;
    дРеал function(дИДМира) dWorldGetCFM;
    проц function(дИДМира, дРеал) dWorldStep;
    проц function(дИДМира, дРеал, дРеал, дРеал, дРеал, дВектор3) dWorldImpulseToForce;
    проц function(дИДМира, дРеал) dWorldQuickStep;
    проц function(дИДМира, цел) dWorldSetQuickStepNumIterations;
    цел function(дИДМира) dWorldGetQuickStepNumIterations;
    проц function(дИДМира, дРеал) dWorldSetQuickStepW;
    дРеал function(дИДМира) dWorldGetQuickStepW;
    проц function(дИДМира, дРеал) dWorldSetContactMaxCorrectingVel;
    дРеал function(дИДМира) dWorldGetContactMaxCorrectingVel;
    проц function(дИДМира, дРеал) dWorldSetContactSurfaceLayer;
    дРеал function(дИДМира) dWorldGetContactSurfaceLayer;
    проц function(дИДМира, дРеал, цел) dWorldStepFast1;
    проц function(дИДМира, цел) dWorldSetAutoEnableDepthSF1;
    цел function(дИДМира) dWorldGetAutoEnableDepthSF1;
    дРеал function(дИДМира) dWorldGetAutoDisableLinearThreshold;
    проц function(дИДМира, дРеал) dWorldSetAutoDisableLinearThreshold;
    дРеал function(дИДМира) dWorldGetAutoDisableAngularThreshold;
    проц function(дИДМира, дРеал) dWorldSetAutoDisableAngularThreshold;
    цел function(дИДМира) dWorldGetAutoDisableAverageSamplesCount;
    проц function(дИДМира, бцел) dWorldSetAutoDisableAverageSamplesCount;
    цел function(дИДМира) dWorldGetAutoDisableSteps;
    проц function(дИДМира, цел) dWorldSetAutoDisableSteps;
    дРеал function(дИДМира) dWorldGetAutoDisableTime;
    проц function(дИДМира, дРеал) dWorldSetAutoDisableTime;
    цел function(дИДМира) dWorldGetAutoDisableFlag;
    проц function(дИДМира, цел) dWorldSetAutoDisableFlag;
    дРеал function(дИДМира) dWorldGetLinearDampingThreshold;
    проц function(дИДМира, дРеал) dWorldSetLinearDampingThreshold;
    дРеал function(дИДМира) dWorldGetAngularDampingThreshold;
    проц function(дИДМира, дРеал) dWorldSetAngularDampingThreshold;
    дРеал function(дИДМира) dWorldGetLinearDamping;
    проц function(дИДМира, дРеал) dWorldSetLinearDamping;
    дРеал function(дИДМира) dWorldGetAngularDamping;
    проц function(дИДМира, дРеал) dWorldSetAngularDamping;
    проц function(дИДМира, дРеал, дРеал) dWorldSetDamping;
    дРеал function(дИДМира) dWorldGetMaxAngularSpeed;
    проц function(дИДМира, дРеал) dWorldSetMaxAngularSpeed;
    дРеал function(дИДТела) dBodyGetAutoDisableLinearThreshold;
    проц function(дИДТела, дРеал) dBodySetAutoDisableLinearThreshold;
    дРеал function(дИДТела) dBodyGetAutoDisableAngularThreshold;
    проц function(дИДТела, дРеал) dBodySetAutoDisableAngularThreshold;
    цел function(дИДТела) dBodyGetAutoDisableAverageSamplesCount;
    проц function(дИДТела, бцел) dBodySetAutoDisableAverageSamplesCount;
    цел function(дИДТела) dBodyGetAutoDisableSteps;
    проц function(дИДТела, цел) dBodySetAutoDisableSteps;
    дРеал function(дИДТела) dBodyGetAutoDisableTime;
    проц function(дИДТела, дРеал) dBodySetAutoDisableTime;
    цел function(дИДТела) dBodyGetAutoDisableFlag;
    проц function(дИДТела, цел) dBodySetAutoDisableFlag;
    проц function(дИДТела) dBodySetAutoDisableDefaults;
    дИДМира function(дИДТела) dBodyGetWorld;
    дИДТела function(дИДМира) dBodyCreate;
    проц function(дИДТела) dBodyDestroy;
    проц function(дИДТела, ук) dBodySetData;
    ук function(дИДТела) dBodyGetData;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetPosition;
    проц function(дИДТела, in дМатрица3) dBodySetRotation;
    проц function(дИДТела, in дКватернион) dBodySetQuaternion;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetLinearVel;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetAngularVel;
    дРеал* function(дИДТела) dBodyGetPosition;
    проц function(дИДТела, дВектор3) dBodyCopyPosition;
    дРеал* function(дИДТела) dBodyGetRotation;
    проц function(дИДТела, дМатрица3) dBodyCopyRotation;
    дРеал* function(дИДТела) dBodyGetQuaternion;
    проц function(дИДТела, дКватернион) dBodyCopyQuaternion;
    дРеал* function(дИДТела) dBodyGetLinearVel;
    дРеал* function(дИДТела) dBodyGetAngularVel;
    проц function(дИДТела, in dMass*) dBodySetMass;
    проц function(дИДТела, dMass*) dBodyGetMass;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodyAddForce;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodyAddTorque;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodyAddRelForce;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodyAddRelTorque;
    проц function(дИДТела, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddForceAtPos;
    проц function(дИДТела, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddForceAtRelPos;
    проц function(дИДТела, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddRelForceAtPos;
    проц function(дИДТела, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dBodyAddRelForceAtRelPos;
    дРеал* function(дИДТела) dBodyGetForce;
    дРеал* function(дИДТела) dBodyGetTorque;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetForce;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetTorque;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyGetRelPointPos;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyGetRelPointVel;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyGetPointVel;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyGetPosRelPoint;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyVectorToWorld;
    проц function(дИДТела, дРеал, дРеал, дРеал, дВектор3) dBodyVectorFromWorld;
    проц function(дИДТела, цел) dBodySetFiniteRotationMode;
    проц function(дИДТела, дРеал, дРеал, дРеал) dBodySetFiniteRotationAxis;
    цел function(дИДТела) dBodyGetFiniteRotationMode;
    проц function(дИДТела, дВектор3) dBodyGetFiniteRotationAxis;
    цел function(дИДТела) dBodyGetNumJoints;
    дИДСоединения function(дИДТела) dBodyGetJoint;
    проц function(дИДТела) dBodySetDynamic;
    проц function(дИДТела) dBodySetKinematic;
    цел function(дИДТела) dBodyIsKinematic;
    проц function(дИДТела) dBodyEnable;
    проц function(дИДТела) dBodyDisable;
    цел function(дИДТела) dBodyIsEnabled;
    проц function(дИДТела, цел) dBodySetGravityMode;
    цел function(дИДТела) dBodyGetGravityMode;
    проц function(дИДТела, проц (*callback)(дИДТела)) dBodySetMovedCallback;
    дГеомИД function(дИДТела) dBodyGetFirstGeom;
    дГеомИД function(дГеомИД) dBodyGetNextGeom;
    проц function(дИДТела) dBodySetDampingDefaults;
    дРеал function(дИДТела) dBodyGetLinearDamping;
    проц function(дИДТела, дРеал) dBodySetLinearDamping;
    дРеал function(дИДТела) dBodyGetAngularDamping;
    проц function(дИДТела, дРеал) dBodySetAngularDamping;
    проц function(дИДТела, дРеал, дРеал) dBodySetDamping;
    дРеал function(дИДТела) dBodyGetLinearDampingThreshold;
    проц function(дИДТела, дРеал) dBodySetLinearDampingThreshold;
    дРеал function(дИДТела) dBodyGetAngularDampingThreshold;
    проц function(дИДТела, дРеал) dBodySetAngularDampingThreshold;
    дРеал function(дИДТела) dBodyGetMaxAngularSpeed;
    проц function(дИДТела, дРеал) dBodySetMaxAngularSpeed;
    цел function(дИДТела) dBodyGetGyroscopicMode;
    проц function(дИДТела, цел) dBodySetGyroscopicMode;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateBall;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateHinge;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateSlider;
    дИДСоединения function(дИДМира, дИДГруппыСоединений, in dContact*) dJointCreateContact;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateHinge2;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateUniversal;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreatePR;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreatePU;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreatePiston;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateFixed;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateNull;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateAMotor;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreateLMotor;
    дИДСоединения function(дИДМира, дИДГруппыСоединений) dJointCreatePlane2D;
    проц function(дИДСоединения) dJointDestroy;
    дИДГруппыСоединений function(цел) dJointGroupCreate;
    проц function(дИДГруппыСоединений) dJointGroupDestroy;
    проц function(дИДГруппыСоединений) dJointGroupEmpty;
    цел function(дИДСоединения) dJointGetNumBodies;
    проц function(дИДСоединения, дИДТела, дИДТела) dJointAttach;
    проц function(дИДСоединения) dJointEnable;
    проц function(дИДСоединения) dJointDisable;
    цел function(дИДСоединения) dJointIsEnabled;
    проц function(дИДСоединения, ук) dJointSetData;
    ук function(дИДСоединения) dJointGetData;
    dJointType function(дИДСоединения) dJointGetType;
    дИДТела function(дИДСоединения, цел) dJointGetBody;
    проц function(дИДСоединения, dJointFeedback*) dJointSetFeedback;
    dJointFeedback* function(дИДСоединения) dJointGetFeedback;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetBallAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetBallAnchor2;
    проц function(дИДСоединения, цел, дРеал) dJointSetBallParam;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetHingeAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetHingeAnchorDelta;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetHingeAxis;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал) dJointSetHingeAxisOffset;
    проц function(дИДСоединения, цел, дРеал) dJointSetHingeParam;
    проц function(дИДСоединения, дРеал) dJointAddHingeTorque;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetSliderAxis;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetSliderAxisDelta;
    проц function(дИДСоединения, цел, дРеал) dJointSetSliderParam;
    проц function(дИДСоединения, дРеал) dJointAddSliderForce;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetHinge2Anchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetHinge2Axis1;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetHinge2Axis2;
    проц function(дИДСоединения, цел, дРеал) dJointSetHinge2Param;
    проц function(дИДСоединения, дРеал, дРеал) dJointAddHinge2Torques;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetUniversalAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetUniversalAxis1;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetUniversalAxis1Offset;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetUniversalAxis2;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetUniversalAxis2Offset;
    проц function(дИДСоединения, цел, дРеал) dJointSetUniversalParam;
    проц function(дИДСоединения, дРеал, дРеал) dJointAddUniversalTorques;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPRAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPRAxis1;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPRAxis2;
    проц function(дИДСоединения, цел, дРеал) dJointSetPRParam;
    проц function(дИДСоединения, дРеал) dJointAddPRTorque;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPUAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetPUAnchorOffset;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPUAxis1;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPUAxis2;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPUAxis3;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPUAxisP;
    проц function(дИДСоединения, цел, дРеал) dJointSetPUParam;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPistonAnchor;
    проц function(дИДСоединения, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dJointSetPistonAnchorOffset;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointSetPistonAxis;
    проц function(дИДСоединения, цел, дРеал) dJointSetPistonParam;
    проц function(дИДСоединения, дРеал) dJointAddPistonForce;
    проц function(дИДСоединения) dJointSetFixed;
    проц function(дИДСоединения, цел, дРеал) dJointSetFixedParam;
    проц function(дИДСоединения, цел) dJointSetAMotorNumAxes;
    проц function(дИДСоединения, цел, цел, дРеал, дРеал, дРеал) dJointSetAMotorAxis;
    проц function(дИДСоединения, цел, дРеал) dJointSetAMotorAngle;
    проц function(дИДСоединения, цел, дРеал) dJointSetAMotorParam;
    проц function(дИДСоединения, цел) dJointSetAMotorMode;
    проц function(дИДСоединения, дРеал, дРеал, дРеал) dJointAddAMotorTorques;
    проц function(дИДСоединения, цел) dJointSetLMotorNumAxes;
    проц function(дИДСоединения, цел, цел, дРеал, дРеал, дРеал) dJointSetLMotorAxis;
    проц function(дИДСоединения, цел, дРеал) dJointSetLMotorParam;
    проц function(дИДСоединения, цел, дРеал) dJointSetPlane2DXParam;
    проц function(дИДСоединения, цел, дРеал) dJointSetPlane2DYParam;
    проц function(дИДСоединения, цел, дРеал) dJointSetPlane2DAngleParam;
    проц function(дИДСоединения, дВектор3) dJointGetBallAnchor;
    проц function(дИДСоединения, дВектор3) dJointGetBallAnchor2;
    дРеал function(дИДСоединения, цел) dJointGetBallParam;
    проц function(дИДСоединения, дВектор3) dJointGetHingeAnchor;
    проц function(дИДСоединения, дВектор3) dJointGetHingeAnchor2;
    проц function(дИДСоединения, дВектор3) dJointGetHingeAxis;
    дРеал function(дИДСоединения, цел) dJointGetHingeParam;
    дРеал function(дИДСоединения) dJointGetHingeAngle;
    дРеал function(дИДСоединения) dJointGetHingeAngleRate;
    дРеал function(дИДСоединения) dJointGetSliderPosition;
    дРеал function(дИДСоединения) dJointGetSliderPositionRate;
    проц function(дИДСоединения, дВектор3) dJointGetSliderAxis;
    дРеал function(дИДСоединения, цел) dJointGetSliderParam;
    проц function(дИДСоединения, дВектор3) dJointGetHinge2Anchor;
    проц function(дИДСоединения, дВектор3) dJointGetHinge2Anchor2;
    проц function(дИДСоединения, дВектор3) dJointGetHinge2Axis1;
    проц function(дИДСоединения, дВектор3) dJointGetHinge2Axis2;
    дРеал function(дИДСоединения, цел) dJointGetHinge2Param;
    дРеал function(дИДСоединения) dJointGetHinge2Angle1;
    дРеал function(дИДСоединения) dJointGetHinge2Angle1Rate;
    дРеал function(дИДСоединения) dJointGetHinge2Angle2Rate;
    проц function(дИДСоединения, дВектор3) dJointGetUniversalAnchor;
    проц function(дИДСоединения, дВектор3) dJointGetUniversalAnchor2;
    проц function(дИДСоединения, дВектор3) dJointGetUniversalAxis1;
    проц function(дИДСоединения, дВектор3) dJointGetUniversalAxis2;
    дРеал function(дИДСоединения, цел) dJointGetUniversalParam;
    проц function(дИДСоединения, дРеал*, дРеал*) dJointGetUniversalAngles;
    дРеал function(дИДСоединения) dJointGetUniversalAngle1;
    дРеал function(дИДСоединения) dJointGetUniversalAngle2;
    дРеал function(дИДСоединения) dJointGetUniversalAngle1Rate;
    дРеал function(дИДСоединения) dJointGetUniversalAngle2Rate;
    проц function(дИДСоединения, дВектор3) dJointGetPRAnchor;
    дРеал function(дИДСоединения) dJointGetPRPosition;
    дРеал function(дИДСоединения) dJointGetPRPositionRate;
    дРеал function(дИДСоединения) dJointGetPRAngle;
    дРеал function(дИДСоединения) dJointGetPRAngleRate;
    проц function(дИДСоединения, дВектор3) dJointGetPRAxis1;
    проц function(дИДСоединения, дВектор3) dJointGetPRAxis2;
    дРеал function(дИДСоединения, цел) dJointGetPRParam;
    проц function(дИДСоединения, дВектор3) dJointGetPUAnchor;
    дРеал function(дИДСоединения) dJointGetPUPosition;
    дРеал function(дИДСоединения) dJointGetPUPositionRate;
    проц function(дИДСоединения, дВектор3) dJointGetPUAxis1;
    проц function(дИДСоединения, дВектор3) dJointGetPUAxis2;
    проц function(дИДСоединения, дВектор3) dJointGetPUAxis3;
    проц function(дИДСоединения, дВектор3) dJointGetPUAxisP;
    проц function(дИДСоединения, дРеал*, дРеал*) dJointGetPUAngles;
    дРеал function(дИДСоединения) dJointGetPUAngle1;
    дРеал function(дИДСоединения) dJointGetPUAngle1Rate;
    дРеал function(дИДСоединения) dJointGetPUAngle2;
    дРеал function(дИДСоединения) dJointGetPUAngle2Rate;
    дРеал function(дИДСоединения, цел) dJointGetPUParam;
    дРеал function(дИДСоединения) dJointGetPistonPosition;
    дРеал function(дИДСоединения) dJointGetPistonPositionRate;
    дРеал function(дИДСоединения) dJointGetPistonAngle;
    дРеал function(дИДСоединения) dJointGetPistonAngleRate;
    проц function(дИДСоединения, дВектор3) dJointGetPistonAnchor;
    проц function(дИДСоединения, дВектор3) dJointGetPistonAnchor2;
    проц function(дИДСоединения, дВектор3) dJointGetPistonAxis;
    дРеал function(дИДСоединения, цел) dJointGetPistonParam;
    цел function(дИДСоединения) dJointGetAMotorNumAxes;
    проц function(дИДСоединения, цел, дВектор3) dJointGetAMotorAxis;
    цел function(дИДСоединения, цел) dJointGetAMotorAxisRel;
    дРеал function(дИДСоединения, цел) dJointGetAMotorAngle;
    дРеал function(дИДСоединения, цел) dJointGetAMotorAngleRate;
    дРеал function(дИДСоединения, цел) dJointGetAMotorParam;
    цел function(дИДСоединения) dJointGetAMotorMode;
    цел function(дИДСоединения) dJointGetLMotorNumAxes;
    проц function(дИДСоединения, цел, дВектор3) dJointGetLMotorAxis;
    дРеал function(дИДСоединения, цел) dJointGetLMotorParam;
    дРеал function(дИДСоединения, цел) dJointGetFixedParam;
    дИДСоединения function(дИДТела, дИДТела) dConnectingJoint;
    цел function(дИДТела, дИДТела, дИДСоединения*) dConnectingJointList;
    цел function(дИДТела, дИДТела) dAreConnected;
    цел function(дИДТела, дИДТела, цел) dAreConnectedExcluding;

    // odeinit.h
    проц function() dInitODE;
    цел function(бцел) dInitODE2;
    цел function(бцел) dAllocateODEDataForThread;
    проц function() dCleanupODEAllDataForThread;
    проц function() dCloseODE;

    // rotation.h
    проц function(дМатрица3) dRSetIdentity;
    проц function(дМатрица3, дРеал, дРеал, дРеал, дРеал) dRFromAxisAndAngle;
    проц function(дМатрица3, дРеал, дРеал, дРеал) dRFromEulerAngles;
    проц function(дМатрица3, дРеал, дРеал, дРеал, дРеал, дРеал, дРеал) dRFrom2Axes;
    проц function(дМатрица3, дРеал, дРеал, дРеал) dRFromZAxis;
    проц function(дКватернион) dQSetIdentity;
    проц function(дКватернион, дРеал, дРеал, дРеал, дРеал) dQFromAxisAndAngle;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply0;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply1;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply2;
    проц function(дКватернион, in дКватернион, in дКватернион) dQMultiply3;
    проц function(дМатрица3, in дКватернион) dRfromQ;
    проц function(дКватернион, in дМатрица3) dQfromR;
    проц function(дРеал[4], in дВектор3, in дКватернион) dDQfromW;

    // timer.h
    проц function(dStopwatch*) dStopwatchReset;
    проц function(dStopwatch*) dStopwatchStart;
    проц function(dStopwatch*) dStopwatchStop;
    дво function(dStopwatch*) dStopwatchTime;
    проц function(in ткст0) dTimerStart;
    проц function(in ткст0) dTimerNow;
    проц function() dTimerEnd;
    проц function(фук, цел) dTimerReport;
    дво function() dTimerTicksPerSecond;
    дво function() dTimerResolution;
}