
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:18.1.2015                                           Время: 19 ч. 38 мин.

	*******************************************************************************/


	module lib.DinrusGluDLL;
	import stdrus;
	
alias extern (/**/C) проц function(сим, цел, цел) сифунк_СЦЦ;
alias extern (/**/C) проц function() сифунк;
alias extern (/**/C) проц function(ббайт, цел, цел) сифунк_бБЦЦ;
alias extern (/**/C) проц function(цел) сифунк_Ц;
alias extern (/**/C) проц function(цел, цел) сифунк_ЦЦ;
alias extern (/**/C) проц function(цел, цел, цел) сифунк_ЦЦЦ;
alias extern (/**/C) проц function(цел, цел, цел, цел) сифунк_ЦЦЦЦ;
alias extern (/**/C) проц function(бцел, цел, цел, цел) сифунк_бЦЦЦЦ;
	
alias uint      GLenum, Гперечень;
alias ubyte     GLboolean, Гбул;
alias uint      GLbitfield, Гбитполе;
alias void      GLvoid;
alias byte      GLbyte;
alias short     GLshort;
alias int       GLint;
alias ubyte     GLubyte;
alias ushort    GLushort;
alias uint      GLuint;
alias int       GLsizei, Гцразм;
alias float     GLfloat;
alias float     GLclampf, Гклампп;
alias double    GLdouble;
alias double    GLclampd, Гклампд;
alias char      GLchar;
alias ptrdiff_t GLintptr, Гцелук;
alias ptrdiff_t GLsizeiptr, Гцразмук;

enum: Гперечень
{
 GLU_VERSION			= 100800,
 GLU_EXTENSIONS			= 100801,
 GLU_EXT_object_space_tess   =       1,
 GLU_EXT_nurbs_tessellator    =      1,
// ErrorCode
 GLU_INVALID_ENUM			= 100900,
 GLU_INVALID_VALUE			= 100901,
 GLU_OUT_OF_MEMORY			= 100902,
 GLU_INVALID_OPERATION		= 100904,
 GLU_INCOMPATIBLE_GL_VERSION     =   100903,
// NurbsDisplay
 GLU_OUTLINE_POLYGON		= 100240,
 GLU_OUTLINE_PATCH			= 100241,
// NurbsCallback
 GLU_NURBS_ERROR			= 100103,
 GLU_ERROR				= 100103,
 GLU_NURBS_BEGIN			= 100164,
 GLU_NURBS_BEGIN_EXT		= 100164,
 GLU_NURBS_VERTEX			= 100165,
 GLU_NURBS_VERTEX_EXT		= 100165,
 GLU_NURBS_NORMAL			= 100166,
 GLU_NURBS_NORMAL_EXT		= 100166,
 GLU_NURBS_COLOR			= 100167,
 GLU_NURBS_COLOR_EXT		= 100167,
 GLU_NURBS_TEXTURE_COORD		= 100168,
 GLU_NURBS_TEX_COORD_EXT		= 100168,
 GLU_NURBS_END			= 100169,
 GLU_NURBS_END_EXT			= 100169,
 GLU_NURBS_BEGIN_DATA		= 100170,
 GLU_NURBS_BEGIN_DATA_EXT		= 100170,
 GLU_NURBS_VERTEX_DATA		= 100171,
 GLU_NURBS_VERTEX_DATA_EXT		= 100171,
 GLU_NURBS_NORMAL_DATA		= 100172,
 GLU_NURBS_NORMAL_DATA_EXT		= 100172,
 GLU_NURBS_COLOR_DATA		= 100173,
 GLU_NURBS_COLOR_DATA_EXT		= 100173,
 GLU_NURBS_TEXTURE_COORD_DATA	= 100174,
 GLU_NURBS_TEX_COORD_DATA_EXT 	= 100174,
 GLU_NURBS_END_DATA			= 100175,
 GLU_NURBS_END_DATA_EXT		= 100175,
// NurbsError
 GLU_NURBS_ERROR1			= 100251,
 GLU_NURBS_ERROR2			= 100252,
 GLU_NURBS_ERROR3			= 100253,
 GLU_NURBS_ERROR4			= 100254,
 GLU_NURBS_ERROR5			= 100255,
 GLU_NURBS_ERROR6			= 100256,
 GLU_NURBS_ERROR7			= 100257,
 GLU_NURBS_ERROR8			= 100258,
 GLU_NURBS_ERROR9			= 100259,
 GLU_NURBS_ERROR10			= 100260,
 GLU_NURBS_ERROR11			= 100261,
 GLU_NURBS_ERROR12			= 100262,
 GLU_NURBS_ERROR13			= 100263,
 GLU_NURBS_ERROR14			= 100264,
 GLU_NURBS_ERROR15			= 100265,
 GLU_NURBS_ERROR16			= 100266,
 GLU_NURBS_ERROR17			= 100267,
 GLU_NURBS_ERROR18			= 100268,
 GLU_NURBS_ERROR19			= 100269,
 GLU_NURBS_ERROR20			= 100270,
 GLU_NURBS_ERROR21			= 100271,
 GLU_NURBS_ERROR22			= 100272,
 GLU_NURBS_ERROR23			= 100273,
 GLU_NURBS_ERROR24			= 100274,
 GLU_NURBS_ERROR25			= 100275,
 GLU_NURBS_ERROR26			= 100276,
 GLU_NURBS_ERROR27			= 100277,
 GLU_NURBS_ERROR28			= 100278,
 GLU_NURBS_ERROR29			= 100279,
 GLU_NURBS_ERROR30			= 100280,
 GLU_NURBS_ERROR31			= 100281,
 GLU_NURBS_ERROR32			= 100282,
 GLU_NURBS_ERROR33			= 100283,
 GLU_NURBS_ERROR34			= 100284,
 GLU_NURBS_ERROR35			= 100285,
 GLU_NURBS_ERROR36			= 100286,
 GLU_NURBS_ERROR37			= 100287,
// NurbsProperty
 GLU_AUTO_LOAD_MATRIX		= 100200,
 GLU_CULLING			= 100201,
 GLU_SAMPLING_TOLERANCE		= 100203,
 GLU_DISPLAY_MODE			= 100204,
 GLU_PARAMETRIC_TOLERANCE		= 100202,
 GLU_SAMPLING_METHOD		= 100205,
 GLU_U_STEP				= 100206,
 GLU_V_STEP				= 100207,
 GLU_NURBS_MODE			= 100160,
 GLU_NURBS_MODE_EXT			= 100160,
 GLU_NURBS_TESSELLATOR		= 100161,
 GLU_NURBS_TESSELLATOR_EXT		= 100161,
 GLU_NURBS_RENDERER			= 100162,
 GLU_NURBS_RENDERER_EXT		= 100162,
// NurbsSampling
 GLU_OBJECT_PARAMETRIC_ERROR	= 100208,
 GLU_OBJECT_PARAMETRIC_ERROR_EXT	= 100208,
 GLU_OBJECT_PATH_LENGTH		= 100209,
 GLU_OBJECT_PATH_LENGTH_EXT		= 100209,
 GLU_PATH_LENGTH			= 100215,
 GLU_PARAMETRIC_ERROR		= 100216,
 GLU_DOMAIN_DISTANCE		= 100217,
// NurbsTrim
 GLU_MAP1_TRIM_2			= 100210,
 GLU_MAP2_TRIM_3			= 100211,
// QuadricDrawStyle
 GLU_POINT				= 100010,
 GLU_LINE				= 100011,
 GLU_FILL				= 100012,
 GLU_SILHOUETTE			= 100013,
 
 /* QuadricNormal */
GLU_SMOOTH   =                      100000,
GLU_FLAT         =                  100001,
GLU_NONE        =                   100002,

/* QuadricOrientation */
GLU_OUTSIDE        =                100020,
GLU_INSIDE         =                100021,

// QuadricNormal
 GLU_TESS_BEGIN			= 100100,
 GLU_BEGIN				= 100100,
 GLU_TESS_VERTEX			= 100101,
 GLU_VERTEX				= 100101,
 GLU_TESS_END			= 100102,
 GLU_END				= 100102,
 GLU_TESS_ERROR			= 100103,
 GLU_TESS_EDGE_FLAG			= 100104,
 GLU_EDGE_FLAG			= 100104,
 GLU_TESS_COMBINE			= 100105,
 GLU_TESS_BEGIN_DATA		= 100106,
 GLU_TESS_VERTEX_DATA		= 100107,
 GLU_TESS_END_DATA			= 100108,
 GLU_TESS_ERROR_DATA		= 100109,
 GLU_TESS_EDGE_FLAG_DATA		= 100110,
 GLU_TESS_COMBINE_DATA		= 100111,
// TessContour
 GLU_CW				= 100120,
 GLU_CCW				= 100121,
 GLU_INTERIOR			= 100122,
 GLU_EXTERIOR			= 100123,
 GLU_UNKNOWN			= 100124,
// TessProperty
 GLU_TESS_WINDING_RULE		= 100140,
 GLU_TESS_BOUNDARY_ONLY		= 100141,
 GLU_TESS_TOLERANCE			= 100142,
// TessError
 GLU_TESS_ERROR1			= 100151,
 GLU_TESS_ERROR2			= 100152,
 GLU_TESS_ERROR3			= 100153,
 GLU_TESS_ERROR4			= 100154,
 GLU_TESS_ERROR5			= 100155,
 GLU_TESS_ERROR6			= 100156,
 GLU_TESS_ERROR7			= 100157,
 GLU_TESS_ERROR8			= 100158,
 GLU_TESS_MISSING_BEGIN_POLYGON	= 100151,
 GLU_TESS_MISSING_BEGIN_COUNTER	= 100152,
 GLU_TESS_MISSING_END_POLYGON	= 100153,
 GLU_TESS_MISSING_END_COUNTER	= 100154,
 GLU_TESS_COORD_TOO_LARGE		= 100155,
 GLU_TESS_NEED_COMBINE_CALLBACK	= 100156,
// TessWinding
 GLU_TESS_WINDING_ODD		= 100130,
 GLU_TESS_WINDING_NONZERO		= 100131,
 GLU_TESS_WINDING_POSITIVE		= 100132,
 GLU_TESS_WINDING_NEGATIVE		= 100133,
 GLU_TESS_WINDING_ABS_GEQ_TWO	= 100134,
 
}
const дво GLU_TESS_MAX_COORD		= 1.0e150;

//==============================================================================
// TYPES
//==============================================================================

struct GLUnurbs { } alias GLUnurbs Нурб, GLUnurbsObj;
struct GLUquadric { } alias GLUquadric Квадр, GLUquadricObj;
struct GLUtesselator { } alias GLUtesselator Тесс, GLUtesselatorObj, GLUtriangulatorObj; 


	проц грузи(Биб биб)
	{	
		вяжи(глуНачниКривую)("gluBeginCurve", биб);
		вяжи(глуНачниМногоуг)("gluBeginPolygon", биб);
		вяжи(глуНачниПоверхность)("gluBeginSurface", биб);
		вяжи(глуНачниОбрез)("gluBeginTrim", биб);
		вяжи(глуПострой1МУровниМипмап)("gluBuild1DMipmapLevels", биб);
		вяжи(глуПострой1ММипмапы)("gluBuild1DMipmaps", биб);
		вяжи(глуПострой2МУровниМипмап)("gluBuild2DMipmapLevels", биб);
		вяжи(глуПострой2ММипмапы)("gluBuild2DMipmaps", биб);
		вяжи(глуПострой3МУровниМипмап)("gluBuild3DMipmapLevels", биб);
		вяжи(глуПострой3ММипмапы)("gluBuild3DMipmaps", биб);
		вяжи(глуПроверьРасширение)("gluCheckExtension", биб);
		вяжи(глуЦилиндр)("gluCylinder", биб);
		вяжи(глуУдалиОтобразительНурб)("gluDeleteNurbsRenderer", биб);
		вяжи(глуУдалиКвадр)("gluDeleteQuadric", биб);
		вяжи(глуУдалиТесс)("gluDeleteTess", биб);
		вяжи(глуДиск)("gluDisk", биб);
		вяжи(глуКонКрив)("gluEndCurve", биб);
		вяжи(глуКонМногоуг)("gluEndPolygon", биб);
		вяжи(глуКонПоверхн)("gluEndSurface", биб);
		вяжи(глуКонОбрез)("gluEndTrim", биб);
		вяжи(глуТкстОш)("gluErrorString", биб);
		вяжи(глуДайСвойствоНурб)("gluGetNurbsProperty", биб);
		вяжи(глуДайТкст)("gluGetString", биб);
		вяжи(глуДайСвойствоТесс)("gluGetTessProperty", биб);
		вяжи(глуЗагрузиМатрицыСемплинга)("gluLoadSamplingMatrices", биб);
		вяжи(глуВидНа)("gluLookAt", биб);
		вяжи(глуНовыйОтобразительНурб)("gluNewNurbsRenderer", биб);
		вяжи(глуНовыйКвадрик)("gluNewQuadric", биб);
		вяжи(глуНовыйТесс)("gluNewTess", биб);
		вяжи(глуСледщКонтур)("gluNextContour", биб);
		вяжи(глуОбрвызовНурбс)("gluNurbsCallback", биб);
		вяжи(глуДанныеОбрвызоваНурб)("gluNurbsCallbackData", биб);
		вяжи(глуДанныеОбрвызоваНурбДОП)("gluNurbsCallbackDataEXT", биб);
		вяжи(глуКриваяНурб)("gluNurbsCurve", биб);
		вяжи(глуСвойствоНурб)("gluNurbsProperty", биб);
		вяжи(глуПоверхностьНурб)("gluNurbsSurface", биб);		
		вяжи(глуОрто2М)("gluOrtho2D", биб);
		вяжи(глуПолуДиск)("gluPartialDisk", биб);
		вяжи(глуПерспектива)("gluPerspective", биб);
		вяжи(глуПодбериМатрицу)("gluPickMatrix", биб);
		вяжи(глуПроекция)("gluProject", биб);

		//вяжи(функция_42)("gluPwlCurve", биб);

		вяжи(глуОбрвызовКвадра)("gluQuadricCallback", биб);
		вяжи(глуКвадрСтильРисования)("gluQuadricDrawStyle", биб);
		вяжи(глуКвадрНормали)("gluQuadricNormals", биб);
		вяжи(глуКвадрОриентация)("gluQuadricOrientation", биб);
		вяжи(глуКвадрТекстура)("gluQuadricTexture", биб);

		//вяжи(функция_48)("gluScaleImage", биб);

		вяжи(глуШар)("gluSphere", биб);
		вяжи(глуТессНачниКонтур)("gluTessBeginContour", биб);
		вяжи(глуТессНачниМногогран)("gluTessBeginPolygon", биб);
		вяжи(глуОбрвызовТесс)("gluTessCallback", биб);
		вяжи(глуТессЗавершиКонтур)("gluTessEndContour", биб);
		вяжи(глуТессЗавершиМногогран)("gluTessEndPolygon", биб);
		вяжи(глуТессНормаль)("gluTessNormal", биб);
		вяжи(глуТессСвойство)("gluTessProperty", биб);
		вяжи(глуТессВершина)("gluTessVertex", биб);

		//вяжи(функция_58)("gluUnProject", биб);

		//вяжи(функция_59)("gluUnProject4", биб);
	}

ЖанБибгр DINRUS_GLU;

		static this()
		{
			DINRUS_GLU.заряжай("Dinrus.Glu.dll", &грузи );
			DINRUS_GLU.загружай();
		}

	extern(C)
	{


		проц function(GLUnurbs* nurb) глуНачниКривую; 
		
		проц function(GLUtesselator* tess) глуНачниМногоуг;
		
		проц function(GLUnurbs* nurb) глуНачниПоверхность; 
		
		проц function(GLUnurbs* nurb) глуНачниОбрез; 
		
		цел function(Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс, ук данные) глуПострой1МУровниМипмап; 
		
		цел function(Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип,  ук данные) глуПострой1ММипмапы;
		
		цел function(цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные   ) глуПострой2МУровниМипмап;
		
		цел function(цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип,  ук данные) глуПострой2ММипмапы; 

		проц function(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные) глуПострой3МУровниМипмап; 

		проц function(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип,  ук данные) глуПострой3ММипмапы; 

		Гбул function(ткст0 имяРасш, ткст0 ткстРасш) глуПроверьРасширение; 

		проц function(Квадр* квад, дво ова, дво верх, дво высота, цел доли, цел пачки) глуЦилиндр; 

		проц function( Нурб* nurb) глуУдалиОтобразительНурб; 

		проц function(Квадр *квад) глуУдалиКвадр; 

		проц function(Тесс *тесс) глуУдалиТесс; 

		проц function(Квадр* квад, дво inner, дво внешний, цел доли, цел циклы) глуДиск; 

		проц function( Нурб* нурб) глуКонКрив; 

		проц function(Тесс *тесс) глуКонМногоуг; 

		проц function(Нурб* нурб) глуКонПоверхн; 

		проц function(Нурб* нурб) глуКонОбрез; 

		ткст0 function(Гперечень ош) глуТкстОш; 

		проц function(Нурб* nurb, Гперечень property, плав* данные) глуДайСвойствоНурб; 

		ткст0 function(Гперечень имя) глуДайТкст; 

		проц function(Тесс* тесс, Гперечень какой, дво* данные) глуДайСвойствоТесс; 

		проц function(Нурб* нурб, плав* модель, плав* перспектива, цел *вид) глуЗагрузиМатрицыСемплинга; 

		проц function(дво глазШ, дво глазВ, дво глазД, дво центрШ, дво центрВ, дво центрД, дво верхШ, дво верхВ, дво верхД) глуВидНа; 

		Нурб* function() глуНовыйОтобразительНурб; 

		Квадр* function() глуНовыйКвадрик; 

		Тесс* function() глуНовыйТесс; 

		проц function(Тесс* тесс, Гперечень тип) глуСледщКонтур; 

		проц function(Нурб* нурб, Гперечень какой, сифунк фов) глуОбрвызовНурбс; 

		проц function(Нурб* нурб, ук пользДанн) глуДанныеОбрвызоваНурб; 

		проц function(Нурб* нурб, ук пользДанн) глуДанныеОбрвызоваНурбДОП; 

		проц function(Нурб* нурб, цел члоуз, плав* узлы, цел страйд, плав* упрэлт, цел порядок, Гперечень тип) глуКриваяНурб; 

		проц function(Нурб* нурб, Гперечень свойство, плав знач) глуСвойствоНурб; 

		проц function(Нурб* нурб, цел члоузс, плав* узлыс, цел члоузт, плав* узлыт, цел пролётс, цел пролётт, плав* упрэлт, цел спорядок, цел тпорядок, Гперечень тип) глуПоверхностьНурб; 

		проц function(дво лев, дво прав, дво низ, дво верх) глуОрто2М; 

		проц function(Квадр* квад, дво внутр, дво наруж, цел доли, цел петли, дво старт, дво метла) глуПолуДиск; 

		проц function(дво fovy, дво aspect, дво zNear, дво zFar) глуПерспектива; 

		проц function(дво ш, дво в, дво делШ, дво делВ, цел *вьюпорт) глуПодбериМатрицу; 

		проц function(дво обШ, дво обВ, дво обД, дво* модель, дво* проекц, цел *вид, дво *окШ, дво *окВ, дво *окД) глуПроекция; 

		//проц function(   ) функция_42; 

		проц function(Квадр* квад, Гперечень который, сифунк фов) глуОбрвызовКвадра; 

		проц function(Квадр* квад, Гперечень рис) глуКвадрСтильРисования; 

		проц function(Квадр* квад, Гперечень нормаль) глуКвадрНормали; 

		проц function(Квадр* квад, Гперечень ориент) глуКвадрОриентация; 

		проц function(Квадр* квад, бул текстура) глуКвадрТекстура; 

		//проц function(   ) функция_48; 

		проц function(Квадр* квад, дво радиус, цел доли, цел пачки) глуШар; 

		проц function(Тесс* тесс) глуТессНачниКонтур; 

		проц function(Тесс* тесс, ук данные) глуТессНачниМногогран; 

		проц function(Тесс* тесс, Гперечень который, сифунк ов) глуОбрвызовТесс; 

		проц function(Тесс* тесс) глуТессЗавершиКонтур; 

		проц function(Тесс* тесс) глуТессЗавершиМногогран; 

		проц function(Тесс* тесс, дво значШ, дво значВ, дво значД) глуТессНормаль; 

		проц function(Тесс* тесс, Гперечень который, дво данные) глуТессСвойство; 

		проц function(Тесс* тесс, дво *положен, ук данные) глуТессВершина; 

		//проц function(   ) функция_58; 

		//проц function(   ) функция_59; 

	}
/+
void main()
{
Тесс* тес = глуНовыйТесс();
}
+/