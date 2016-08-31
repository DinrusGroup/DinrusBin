
	/*******************************************************************************
	*  Файл генерирован автоматически с помощью либпроцессора Динрус               *
	*  Дата:18.1.2015                                           Время: 19 ч. 38 мин.

	*******************************************************************************/
module lib.Mesa;
	import stdrus, cidrus: выход;

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


alias extern (/**/C) проц function(сим, цел, цел) сифунк_СЦЦ;
alias extern (/**/C) проц function() сифунк;
alias extern (/**/C) проц function(ббайт, цел, цел) сифунк_бБЦЦ;
alias extern (/**/C) проц function(цел) сифунк_Ц;
alias extern (/**/C) проц function(цел, цел) сифунк_ЦЦ;
alias extern (/**/C) проц function(цел, цел, цел) сифунк_ЦЦЦ;
alias extern (/**/C) проц function(цел, цел, цел, цел) сифунк_ЦЦЦЦ;
alias extern (/**/C) проц function(бцел, цел, цел, цел) сифунк_бЦЦЦЦ;

// Булевы значения
enum : Гбул
{
    г_нет    = 0x0,
    г_да    = 0x1,
	GL_FALSE = 0x0,
	GL_TRUE = 0x1,
}



enum : Гперечень
{
	
    // Типы данных
	
    БАЙТ                                = 0x1400,
    ББАЙТ                       = 0x1401,
    КРАТ                               = 0x1402,
    БКРАТ                      = 0x1403,
    ЦЕЛ                                 = 0x1404,
    БЦЕЛ                        = 0x1405,
    ПЛАВ                               = 0x1406,
    ДВО                              = 0x140A,
    ДВА_БАЙТА                             = 0x1407,
    ТРИ_БАЙТА                             = 0x1408,
    ЧЕТЫРЕ_БАЙТА                             = 0x1409,
	//English
	GL_BYTE				= 0x1400,
	GL_UNSIGNED_BYTE			= 0x1401,
	GL_SHORT				= 0x1402,
	GL_UNSIGNED_SHORT			= 0x1403,
	GL_INT				= 0x1404,
	GL_UNSIGNED_INT			= 0x1405,
	GL_FLOAT				= 0x1406,
	GL_DOUBLE				= 0x140A,
	GL_2_BYTES				= 0x1407,
	GL_3_BYTES				= 0x1408,
	GL_4_BYTES         = 0x1409,

    // Простые фигуры
    ТОЧКИ                              = 0x0000,
    ЛИНИИ                               = 0x0001,
    ПЕТЛЯ                           = 0x0002,
    СВЯЗКА_ЛИНИЙ                          = 0x0003,
    ТРЕУГОЛЬНИКИ                           = 0x0004,
    СВЯЗКА_ТРЕУГОЛЬНИКОВ                      = 0x0005,
    ВЕЕР_ТРЕУГОЛЬНИКОВ                        = 0x0006,
    КВАДРАТЫ                               = 0x0007,
    СВЯЗКА_КВАДРАТОВ                          = 0x0008,
    МНОГОУГОЛЬНИК                             = 0x0009,
	//English
	GL_POINTS				= 0x0000,
	GL_LINES				= 0x0001,
	GL_LINE_LOOP			= 0x0002,
	GL_LINE_STRIP			= 0x0003,
	GL_TRIANGLES			= 0x0004,
	GL_TRIANGLE_STRIP			= 0x0005,
	GL_TRIANGLE_FAN			= 0x0006,
	GL_QUADS				= 0x0007,
	GL_QUAD_STRIP			= 0x0008,
	GL_POLYGON				= 0x0009,

    // Массивы вершин
    МАССИВ_ВЕРШИН                        = 0x8074,
    МАССИВ_НОРМАЛЕЙ                        = 0x8075,
    МАССИВ_ЦВЕТОВ                         = 0x8076,
    МАССИВ_ИНДЕКСОВ                         = 0x8077,
    МАССИВ_ККОРДИНАТ_ТЕКСТУР                 = 0x8078,
    МАССИВ_ФЛАГОВ_КРАЯ                     = 0x8079,
    РАЗМЕР_МАССИВА_ВЕРШИН                   = 0x807A,
    ТИП_МАССИВА_ВЕРШИН                   = 0x807B,
    ШАГ_МАССИВА_ВЕРШИН                 = 0x807C,
    ТИП_МАССИВА_НОРМАЛЕЙ                   = 0x807E,
    ШАГ_МАССИВА_НОРМАЛЕЙ                 = 0x807F,
    РАЗМЕР_МАССИВА_ЦВЕТА                    = 0x8081,
    ТИП_МАССИВА_ЦВЕТА                    = 0x8082,
    ШАГ_МАССИВА_ЦВЕТОВ                  = 0x8083,
    ТИП_МАССИВА_ИНДЕКСОВ                    = 0x8085,
    ШАГ_МАССИВА_ИНДЕКСОВ                  = 0x8086,
    РАЗМЕР_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8088,
    ТИП_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8089,
    ШАГ_МАССИВА_КООРД_ТЕКСТУР          = 0x808A,
    ШАГ_МАССИВА_ФЛАГОВ_КРАЯ              = 0x808C,
    УК_НА_МАССИВ_ВЕРШИН                = 0x808E,
    УК_НА_МАССИВ_НОРМАЛЕЙ                = 0x808F,
   УК_НА_МАССИВ_ЦВЕТА                 = 0x8090,
    УК_НА_МАССИВ_ИНДЕКСОВ                 = 0x8091,
    УК_НА_МАССИВ_КООРД_ТЕКСТУРЫ         = 0x8092,
    УК_НА_МАССИВ_ФЛАГОВ_КРАЯ             = 0x8093,
    V2F                                 = 0x2A20,
    V3F                                 = 0x2A21,
    C4UB_V2F                            = 0x2A22,
    C4UB_V3F                            = 0x2A23,
    C3F_V3F                             = 0x2A24,
    N3F_V3F                             = 0x2A25,
    C4F_N3F_V3F                         = 0x2A26,
    T2F_V3F                             = 0x2A27,
    T4F_V4F                             = 0x2A28,
    T2F_C4UB_V3F                        = 0x2A29,
    T2F_C3F_V3F                         = 0x2A2A,
    T2F_N3F_V3F                         = 0x2A2B,
    T2F_C4F_N3F_V3F                     = 0x2A2C,
    T4F_C4F_N3F_V4F                     = 0x2A2D,
	//English
	GL_VERTEX_ARRAY			= 0x8074,
	GL_NORMAL_ARRAY			= 0x8075,
	GL_COLOR_ARRAY			= 0x8076,
	GL_INDEX_ARRAY			= 0x8077,
	GL_TEXTURE_COORD_ARRAY		= 0x8078,
	GL_EDGE_FLAG_ARRAY			= 0x8079,
	GL_VERTEX_ARRAY_SIZE		= 0x807A,
	GL_VERTEX_ARRAY_TYPE		= 0x807B,
	GL_VERTEX_ARRAY_STRIDE		= 0x807C,
	GL_NORMAL_ARRAY_TYPE		= 0x807E,
	GL_NORMAL_ARRAY_STRIDE		= 0x807F,
	GL_COLOR_ARRAY_SIZE		= 0x8081,
	GL_COLOR_ARRAY_TYPE		= 0x8082,
	GL_COLOR_ARRAY_STRIDE		= 0x8083,
	GL_INDEX_ARRAY_TYPE		= 0x8085,
	GL_INDEX_ARRAY_STRIDE		= 0x8086,
	GL_TEXTURE_COORD_ARRAY_SIZE	= 0x8088,
	GL_TEXTURE_COORD_ARRAY_TYPE	= 0x8089,
	GL_TEXTURE_COORD_ARRAY_STRIDE	= 0x808A,
	GL_EDGE_FLAG_ARRAY_STRIDE		= 0x808C,
	GL_VERTEX_ARRAY_POINTER		= 0x808E,
	GL_NORMAL_ARRAY_POINTER		= 0x808F,
	GL_COLOR_ARRAY_POINTER		= 0x8090,
	GL_INDEX_ARRAY_POINTER		= 0x8091,
	GL_TEXTURE_COORD_ARRAY_POINTER	= 0x8092,
	GL_EDGE_FLAG_ARRAY_POINTER		= 0x8093,
	GL_V2F				= 0x2A20,
	GL_V3F				= 0x2A21,
	GL_C4UB_V2F			= 0x2A22,
	GL_C4UB_V3F			= 0x2A23,
	GL_C3F_V3F				= 0x2A24,
	GL_N3F_V3F				= 0x2A25,
	GL_C4F_N3F_V3F			= 0x2A26,
	GL_T2F_V3F				= 0x2A27,
	GL_T4F_V4F				= 0x2A28,
	GL_T2F_C4UB_V3F			= 0x2A29,
	GL_T2F_C3F_V3F			= 0x2A2A,
	GL_T2F_N3F_V3F			= 0x2A2B,
	GL_T2F_C4F_N3F_V3F			= 0x2A2C,
	GL_T4F_C4F_N3F_V4F			= 0x2A2D,

    // Матричный режим
    РЕЖИМ_МАТРИЦЫ                         = 0x0BA0,
    ОБЗОР_МОДЕЛИ                           = 0x1700,
    ПРОЕКЦИЯ                          = 0x1701,
    ТЕКСТУРА                             = 0x1702,
	//English
	GL_MATRIX_MODE			= 0x0BA0,
	GL_MODELVIEW			= 0x1700,
	GL_PROJECTION			= 0x1701,
	GL_TEXTURE				= 0x1702,

    // Точки
    СМЯГЧЕНИЕ_ТОЧКИ                        = 0x0B10,
    РАЗМЕР_ТОЧКИ                          = 0x0B11,
    ГРАНУЛЯРНОСТЬ_РАЗМЕРА_ТОЧКИ              = 0x0B13,
    ДИАПАЗОН_РАЗМЕРА_ТОЧКИ                    = 0x0B12,
	//English
	GL_POINT_SMOOTH			= 0x0B10,
	GL_POINT_SIZE			= 0x0B11,
	GL_POINT_SIZE_GRANULARITY		= 0x0B13,
	GL_POINT_SIZE_RANGE		= 0x0B12,

    // Линии
    СМЯГЧЕНИЕ_ЛИНИИ                         = 0x0B20,
    УЗОР_ЛИНИЙ                        = 0x0B24,
    ОБРАЗЕЦ_УЗОРА_ЛИНИЙ                = 0x0B25,
    ПОВТОР_УЗОРА_ЛИНИЙ                 = 0x0B26,
    ШИРИНА_ЛИНИИ                          = 0x0B21,
    ГРАНУЛЯРНОСТЬ_ШИРИНЫ_ЛИНИИ              = 0x0B23,
    ДИАПАЗОН_ШИРИНЫ_ЛИНИИ                    = 0x0B22,
	//English
	GL_LINE_SMOOTH			= 0x0B20,
	GL_LINE_STIPPLE			= 0x0B24,
	GL_LINE_STIPPLE_PATTERN		= 0x0B25,
	GL_LINE_STIPPLE_REPEAT		= 0x0B26,
	GL_LINE_WIDTH			= 0x0B21,
	GL_LINE_WIDTH_GRANULARITY		= 0x0B23,
	GL_LINE_WIDTH_RANGE		= 0x0B22,

    // Многоугольники
    ТОЧКА                               = 0x1B00,
    ЛИНИЯ                                = 0x1B01,
    ЗАЛИВКА                                = 0x1B02,
    CW                                  = 0x0900,
    CCW                                 = 0x0901,
    ФРОНТ                               = 0x0404,
    ТЫЛ                                = 0x0405,
    РЕЖИМ_МНОГОУГ                        = 0x0B40,
    СМЯГЧЕНИЕ_МНОГОУГ                      = 0x0B41,
    УЗОР_МНОГОУГ                     = 0x0B42,
    ФЛАГ_КРАЯ                           = 0x0B43,
    ПРОФИЛЬ                           = 0x0B44,
    РЕЖИМ_ПРОФИЛЬ                      = 0x0B45,
    ФАС                          = 0x0B46,
    ФАКТОР_СМЕЩЕНИЯ_МНОГОУГ               = 0x8038,
    ЕДИНИЦЫ_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A00,
    ТОЧКА_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A01,
    ЛИНИЯ_СМЕЩЕНИЯ_МНОГОУГ                 = 0x2A02,
    ЗАЛИВКА_СМЕЩЕНИЯ_МНОГОУГ                 = 0x8037,
	//English
	GL_POINT				= 0x1B00,
	GL_LINE				= 0x1B01,
	GL_FILL				= 0x1B02,
	GL_CW				= 0x0900,
	GL_CCW				= 0x0901,
	GL_FRONT				= 0x0404,
	GL_BACK				= 0x0405,
	GL_POLYGON_MODE			= 0x0B40,
	GL_POLYGON_SMOOTH			= 0x0B41,
	GL_POLYGON_STIPPLE			= 0x0B42,
	GL_EDGE_FLAG			= 0x0B43,
	GL_CULL_FACE			= 0x0B44,
	GL_CULL_FACE_MODE			= 0x0B45,
	GL_FRONT_FACE			= 0x0B46,
	GL_POLYGON_OFFSET_FACTOR		= 0x8038,
	GL_POLYGON_OFFSET_UNITS		= 0x2A00,
	GL_POLYGON_OFFSET_POINT		= 0x2A01,
	GL_POLYGON_OFFSET_LINE		= 0x2A02,
	GL_POLYGON_OFFSET_FILL		= 0x8037,

    // Списки отображения
    КОМПИЛИРУЙ                             = 0x1300,
    КОМПИЛИРУЙ_И_ВЫПОЛНИ                 = 0x1301,
    БАЗА_СПИСКА                           = 0x0B32,
    ИНДЕКС_СПИСКА                         = 0x0B33,
    РЕЖИМ_СПИСКА                           = 0x0B30,
	//English
	GL_COMPILE				= 0x1300,
	GL_COMPILE_AND_EXECUTE		= 0x1301,
	GL_LIST_BASE			= 0x0B32,
	GL_LIST_INDEX			= 0x0B33,
	GL_LIST_MODE			= 0x0B30,

    // Буфер глубины
    НИКОГДА                               = 0x0200,
    МЕНЬШЕ                                = 0x0201,
    РАВНЫЙ                               = 0x0202,
    МИЛИР                              = 0x0203,
    БОЛЬШЕ                             = 0x0204,
    НЕРАВН                            = 0x0205,
    БИЛИР                              = 0x0206,
    ВСЕГДА                              = 0x0207,
    ТЕСТ_ДАЛИ                          = 0x0B71,
    БИТЫ_ДАЛИ                          = 0x0D56,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ДАЛИ                   = 0x0B73,
    ФУНКЦ_ДАЛИ                          = 0x0B74,
    ДИАПАЗОН_ДАЛИ                         = 0x0B70,
    МАСКА_ЗАПИСИ_ДАЛИ                     = 0x0B72,
    КОМПОНЕНТА_ДАЛИ                     = 0x1902,
	//English
	GL_NEVER				= 0x0200,
	GL_LESS				= 0x0201,
	GL_EQUAL				= 0x0202,
	GL_LEQUAL				= 0x0203,
	GL_GREATER				= 0x0204,
	GL_NOTEQUAL			= 0x0205,
	GL_GEQUAL				= 0x0206,
	GL_ALWAYS				= 0x0207,
	GL_DEPTH_TEST			= 0x0B71,
	GL_DEPTH_BITS			= 0x0D56,
	GL_DEPTH_CLEAR_VALUE		= 0x0B73,
	GL_DEPTH_FUNC			= 0x0B74,
	GL_DEPTH_RANGE			= 0x0B70,
	GL_DEPTH_WRITEMASK			= 0x0B72,
	GL_DEPTH_COMPONENT			= 0x1902,

    // Освещение
    ОСВЕЩЕНИЕ                            = 0x0B50,
    СВЕТ0                              = 0x4000,
    СВЕТ1                              = 0x4001,
    СВЕТ2                              = 0x4002,
    СВЕТ3                              = 0x4003,
    СВЕТ4                              = 0x4004,
    СВЕТ5                              = 0x4005,
    СВЕТ6                              = 0x4006,
    СВЕТ7                              = 0x4007,
    ЭКСПОНЕНТА_ПРОЖЕКТОРА                       = 0x1205,
    ОБРЕЗКА_ПРОЖЕКТОРА                         = 0x1206,
    ПОСТОЯННОЕ_ЗАТЕНЕНИЕ                = 0x1207,
    ЛИНЕЙНОЕ_ЗАТЕНЕНИЕ                  = 0x1208,
    КВАДРАТИЧНОЕ_ЗАТЕНЕНИЕ               = 0x1209,
    АМБЬЕНТНЫЙ                             = 0x1200,
    ДИФФУЗНЫЙ                             = 0x1201,
    СПЕКУЛЯРНЫЙ                            = 0x1202,
    БЛЕСК                           = 0x1601,
    ЭМИССИЯ                            = 0x1600,
    ПОЗИЦИЯ                            = 0x1203,
    НАПРАВЛЕНИЕ_ПРОЖЕКТОРА                      = 0x1204,
    АМБЬЕНТНО_ДИФФУЗНЫЙ                 = 0x1602,
    ИНДЕКСЫ_ЦВЕТА                       = 0x1603,
    ДВУСТОРОННЯЯ_СВЕТОМОДЕЛЬ                = 0x0B52,
    ЛОКАЛЬНЫЙ_ОБОЗРЕВАТЕЛЬ_СВЕТОМОДЕЛИ            = 0x0B51,
    АМБЬЕНТНАЯ_СВЕТОМОДЕЛЬ                 = 0x0B53,
    ФРОНТ_И_ТЫЛ                      = 0x0408,
    МОДЕЛЬ_ТЕНИ                         = 0x0B54,
    ПЛОСКИЙ                                = 0x1D00,
    ГЛАДКИЙ                              = 0x1D01,
    ЦВЕТОМАТЕРИАЛ                      = 0x0B57,
    ФАС_ЦВЕТОМАТЕРИАЛА                 = 0x0B55,
    ПАРАМЕТР_ЦВЕТОМАТЕРИАЛА            = 0x0B56,
    НОРМАЛИЗУЙ                           = 0x0BA1,
	//English
	GL_LIGHTING			= 0x0B50,
	GL_LIGHT0				= 0x4000,
	GL_LIGHT1				= 0x4001,
	GL_LIGHT2				= 0x4002,
	GL_LIGHT3				= 0x4003,
	GL_LIGHT4				= 0x4004,
	GL_LIGHT5				= 0x4005,
	GL_LIGHT6				= 0x4006,
	GL_LIGHT7				= 0x4007,
	GL_SPOT_EXPONENT			= 0x1205,
	GL_SPOT_CUTOFF			= 0x1206,
	GL_CONSTANT_ATTENUATION		= 0x1207,
	GL_LINEAR_ATTENUATION		= 0x1208,
	GL_QUADRATIC_ATTENUATION		= 0x1209,
	GL_AMBIENT				= 0x1200,
	GL_DIFFUSE				= 0x1201,
	GL_SPECULAR			= 0x1202,
	GL_SHININESS			= 0x1601,
	GL_EMISSION			= 0x1600,
	GL_POSITION			= 0x1203,
	GL_SPOT_DIRECTION			= 0x1204,
	GL_AMBIENT_AND_DIFFUSE		= 0x1602,
	GL_COLOR_INDEXES			= 0x1603,
	GL_LIGHT_MODEL_TWO_SIDE		= 0x0B52,
	GL_LIGHT_MODEL_LOCAL_VIEWER	= 0x0B51,
	GL_LIGHT_MODEL_AMBIENT		= 0x0B53,
	GL_FRONT_AND_BACK			= 0x0408,
	GL_SHADE_MODEL			= 0x0B54,
	GL_FLAT				= 0x1D00,
	GL_SMOOTH				= 0x1D01,
	GL_COLOR_MATERIAL			= 0x0B57,
	GL_COLOR_MATERIAL_FACE		= 0x0B55,
	GL_COLOR_MATERIAL_PARAMETER	= 0x0B56,
	GL_NORMALIZE			= 0x0BA1,

    // Плоскости обрезки пользователя
    ПЛОСКОСТЬ_ОБРЕЗКИ0                         = 0x3000,
    ПЛОСКОСТЬ_ОБРЕЗКИ1                         = 0x3001,
    ПЛОСКОСТЬ_ОБРЕЗКИ2                         = 0x3002,
    ПЛОСКОСТЬ_ОБРЕЗКИ3                         = 0x3003,
    ПЛОСКОСТЬ_ОБРЕЗКИ4                         = 0x3004,
    ПЛОСКОСТЬ_ОБРЕЗКИ5                         = 0x3005,
	//English
	GL_CLIP_PLANE0			= 0x3000,
	GL_CLIP_PLANE1			= 0x3001,
	GL_CLIP_PLANE2			= 0x3002,
	GL_CLIP_PLANE3			= 0x3003,
	GL_CLIP_PLANE4			= 0x3004,
	GL_CLIP_PLANE5			= 0x3005,

    // Буфер накопления
    АККУМ_КРАСНЫЕ_БИТЫ                      = 0x0D58,
    АККУМ_ЗЕЛЁНЫЕ_БИТЫ                    = 0x0D59,
    АККУМ_СИНИЕ_БИТЫ                     = 0x0D5A,
    АККУМ_АЛЬФА_БИТЫ                    = 0x0D5B,
    АККУМ_ЗНАЧЕНИЕ_ОЧИСТКИ                   = 0x0B80,
    АККУМ                               = 0x0100,
    ДОБАВЬ                                 = 0x0104,
    ЗАГРУЗИ                                = 0x0101,
    МУЛЬТ                                = 0x0103,
    ВЕРНИ                              = 0x0102,
	//English
	GL_ACCUM_RED_BITS			= 0x0D58,
	GL_ACCUM_GREEN_BITS		= 0x0D59,
	GL_ACCUM_BLUE_BITS			= 0x0D5A,
	GL_ACCUM_ALPHA_BITS		= 0x0D5B,
	GL_ACCUM_CLEAR_VALUE		= 0x0B80,
	GL_ACCUM				= 0x0100,
	GL_ADD				= 0x0104,
	GL_LOAD				= 0x0101,
	GL_MULT				= 0x0103,
	GL_RETURN				= 0x0102,

    // Тестирование прозрачности
    АЛЬФАТЕСТ                          = 0x0BC0,
    АЛЬФАТЕСТРЕФ                      = 0x0BC2,
    АЛЬФАТЕСТФУНКЦ                     = 0x0BC1,
	//English
	GL_ALPHA_TEST			= 0x0BC0,
	GL_ALPHA_TEST_REF			= 0x0BC2,
	GL_ALPHA_TEST_FUNC			= 0x0BC1,

    // Смешивание
    СМЕСЬ                               = 0x0BE2,
    ИСТОЧНИК_СМЕШИВАНИЯ                           = 0x0BE1,
    ПРИЁМНИК_СМЕШИВАНИЯ                           = 0x0BE0,
    НОЛЬ                                = 0x0,
    ОДИН                                 = 0x1,
    ЦВЕТ_ИСТОЧНИКА                           = 0x0300,
    ОДИН_МИНУС_ЦВЕТ_ИСТОЧНИКА                 = 0x0301,
    АЛЬФА_ИСТОЧНИКА                           = 0x0302,
    ОДИН_МИНУС_АЛЬФА_ИСТОЧНИКА                 = 0x0303,
    АЛЬФА_ПРЁМНИКА                           = 0x0304,
    ОДИН_МИНУС_АЛЬФА_ПРИЁМНИКА                 = 0x0305,
    ЦВЕТ_ПРИЁМНИКА                           = 0x0306,
    ОДИН_МИНУС_ЦВЕТ_ПРИЁМНИКА                 = 0x0307,
    НАСЫТЬ_АЛЬФУ_ИСТОЧНИКА                  = 0x0308,
	//English
	GL_BLEND				= 0x0BE2,
	GL_BLEND_SRC			= 0x0BE1,
	GL_BLEND_DST			= 0x0BE0,
	GL_ZERO				= 0x0,
	GL_ONE				= 0x1,
	GL_SRC_COLOR			= 0x0300,
	GL_ONE_MINUS_SRC_COLOR		= 0x0301,
	GL_SRC_ALPHA			= 0x0302,
	GL_ONE_MINUS_SRC_ALPHA		= 0x0303,
	GL_DST_ALPHA			= 0x0304,
	GL_ONE_MINUS_DST_ALPHA		= 0x0305,
	GL_DST_COLOR			= 0x0306,
	GL_ONE_MINUS_DST_COLOR		= 0x0307,
	GL_SRC_ALPHA_SATURATE		= 0x0308,
    
    // Режим показа
    ФИДБЭК                            = 0x1C01,
    ОТОБРАЗИ                              = 0x1C00,
    ВЫДЕЛИ                              = 0x1C02,
	//English
	GL_FEEDBACK			= 0x1C01,
	GL_RENDER				= 0x1C00,
	GL_SELECT				= 0x1C02,

    // Фидбэк
    М2                                  = 0x0600,
    М3                                  = 0x0601,
    М3_ЦВЕТ                            = 0x0602,
    М3_ТЕКСТУРА_ЦВЕТА                    = 0x0603,
    М4_ТЕКСТУРА_ЦВЕТА                    = 0x0604,
    ЗНАК_ТОЧКИ                         = 0x0701,
    ЗНАК_ЛИНИИ                          = 0x0702,
    ЗНАК_ВОССТАНОВЛЕНИЯ_ЛИНИИ                    = 0x0707,
    ЗНАК_МНОГОУГ                       = 0x0703,
    ЗНАК_БИТМАПА                        = 0x0704,
    ЗНАК_РИСОВАНИЯ_ПИКСЕЛЯ                    = 0x0705,
    ЗНАК_КОПИРОВАНИЯ_ПИКСЕЛЯ                    = 0x0706,
    ЗНАК_ПРОПУСКА                  = 0x0700,
    УК_НА_БУФЕР_ФИДБЭКА             = 0x0DF0,
    РАЗМЕР_БУФЕРА_ФИДБЭКА                = 0x0DF1,
    ТИП_БУФЕРА_ФИДБЭКА                = 0x0DF2,
	//English
	GL_2D				= 0x0600,
	GL_3D				= 0x0601,
	GL_3D_COLOR			= 0x0602,
	GL_3D_COLOR_TEXTURE		= 0x0603,
	GL_4D_COLOR_TEXTURE		= 0x0604,
	GL_POINT_TOKEN			= 0x0701,
	GL_LINE_TOKEN			= 0x0702,
	GL_LINE_RESET_TOKEN		= 0x0707,
	GL_POLYGON_TOKEN			= 0x0703,
	GL_BITMAP_TOKEN			= 0x0704,
	GL_DRAW_PIXEL_TOKEN		= 0x0705,
	GL_COPY_PIXEL_TOKEN		= 0x0706,
	GL_PASS_THROUGH_TOKEN		= 0x0700,
	GL_FEEDBACK_BUFFER_POINTER		= 0x0DF0,
	GL_FEEDBACK_BUFFER_SIZE		= 0x0DF1,
	GL_FEEDBACK_BUFFER_TYPE		= 0x0DF2,

    // Выделение
    УК_НА_БУФЕР_ВЫБОРА            = 0x0DF3,
    РАЗМЕР_БУФЕРА_ВЫБОРА               = 0x0DF4,
	//English
	GL_SELECTION_BUFFER_POINTER	= 0x0DF3,
	GL_SELECTION_BUFFER_SIZE		= 0x0DF4,

    // Туман
    ТУМАН                                 = 0x0B60,
    РЕЖИМ_ТУМАНА                            = 0x0B65,
    ПЛОТНОСТЬ_ТУМАНА                         = 0x0B62,
    ЦВЕТ_ТУМАНА                           = 0x0B66,
    ИНДЕКС_ТУМАНА                           = 0x0B61,
    СТАРТ_ТУМАНА                           = 0x0B63,
    КОНЕЦ_ТУМАНА                             = 0x0B64,
    ЛИНЕЙНЫЙ                              = 0x2601,
    ЭКСП                                 = 0x0800,
    ЭКСП2                                = 0x0801,
	//English
	GL_FOG				= 0x0B60,
	GL_FOG_MODE			= 0x0B65,
	GL_FOG_DENSITY			= 0x0B62,
	GL_FOG_COLOR			= 0x0B66,
	GL_FOG_INDEX			= 0x0B61,
	GL_FOG_START			= 0x0B63,
	GL_FOG_END				= 0x0B64,
	GL_LINEAR				= 0x2601,
	GL_EXP				= 0x0800,
	GL_EXP2				= 0x0801,

    // Логические операции
    ЛОГОП                            = 0x0BF1,
    ИНДЕКСНАЯ_ЛОГОП                      = 0x0BF1,
    ЦВЕТОВАЯ_ЛОГОП                      = 0x0BF2,
    РЕЖИМ_ЛОГОП                       = 0x0BF0,
    ОЧИСТИ                               = 0x1500,
    УСТАНОВИ                                 = 0x150F,
    КОПИРУЙ                                = 0x1503,
    КОПИРУЙ_ИНВ                       = 0x150C,
    НЕТОП                                = 0x1505,
    ИНВЕРТИРУЙ                              = 0x150A,
    И                                 = 0x1501,
    НИ                                = 0x150E,
    ИЛИ                                  = 0x1507,
    НИЛИ                                 = 0x1508,
    ИИЛИ                                 = 0x1506,
    ЭКВИВ                               = 0x1509,
    И_РЕВ                         = 0x1502,
    И_ИНВ                        = 0x1504,
    ИЛИ_РЕВ                         = 0x150B,
    ИЛИ_ИНВ                         = 0x150D,
	//English
	GL_LOGIC_OP			= 0x0BF1,
	GL_INDEX_LOGIC_OP			= 0x0BF1,
	GL_COLOR_LOGIC_OP			= 0x0BF2,
	GL_LOGIC_OP_MODE			= 0x0BF0,
	GL_CLEAR				= 0x1500,
	GL_SET				= 0x150F,
	GL_COPY				= 0x1503,
	GL_COPY_INVERTED			= 0x150C,
	GL_NOOP				= 0x1505,
	GL_INVERT				= 0x150A,
	GL_AND				= 0x1501,
	GL_NAND				= 0x150E,
	GL_OR				= 0x1507,
	GL_NOR				= 0x1508,
	GL_XOR				= 0x1506,
	GL_EQUIV				= 0x1509,
	GL_AND_REVERSE			= 0x1502,
	GL_AND_INVERTED			= 0x1504,
	GL_OR_REVERSE			= 0x150B,
	GL_OR_INVERTED			= 0x150D,

    // Шаблон
    ТЕСТ_ШАБЛОНА                        = 0x0B90,
    МАСКА_ЗАПИСИ_ШАБЛОНА                   = 0x0B98,
    БИТЫ_ШАБЛОНА                        = 0x0D57,
    ФУНКЦ_ШАБЛОНА                        = 0x0B92,
    МАСКА_ЗНАЧЕНИЯ_ШАБЛОНА                  = 0x0B93,
    РЕФ_НА_ШАБЛОН                         = 0x0B97,
    СБОЙ_ШАБЛОНА                        = 0x0B94,
    ПРОХОД_ШАБЛОНА_ПРОХОД_ДАЛИ             = 0x0B96,
    ПРОХОД_ШАБЛОНА_СБОЙ_ДАЛИ             = 0x0B95,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ШАБЛОНА                 = 0x0B91,
    ИНДЕКС_ШАБЛОНА                       = 0x1901,
    СОХРАНИ                                = 0x1E00,
    ЗАМЕНИ                             = 0x1E01,
    УВЕЛИЧЬ                                = 0x1E02,
    УМЕНЬШИ                                = 0x1E03,
	//English
	GL_STENCIL_TEST			= 0x0B90,
	GL_STENCIL_WRITEMASK		= 0x0B98,
	GL_STENCIL_BITS			= 0x0D57,
	GL_STENCIL_FUNC			= 0x0B92,
	GL_STENCIL_VALUE_MASK		= 0x0B93,
	GL_STENCIL_REF			= 0x0B97,
	GL_STENCIL_FAIL			= 0x0B94,
	GL_STENCIL_PASS_DEPTH_PASS		= 0x0B96,
	GL_STENCIL_PASS_DEPTH_FAIL		= 0x0B95,
	GL_STENCIL_CLEAR_VALUE		= 0x0B91,
	GL_STENCIL_INDEX			= 0x1901,
	GL_KEEP				= 0x1E00,
	GL_REPLACE				= 0x1E01,
	GL_INCR				= 0x1E02,
	GL_DECR				= 0x1E03,

    // Буферы, рисование/чтение пикселей
    ПУСТО                                = 0x0,
    ЛЕВЫЙ                                = 0x0406,
    ПРАВЫЙ                               = 0x0407,
    ПЕРЕДНИЙ_ЛЕВЫЙ                          = 0x0400,
    ПЕРЕДНИЙ_ПРАВЫЙ                         = 0x0401,
    ЗАДНИЙ_ЛЕВЫЙ                           = 0x0402,
    ЗАДНИЙ_ПРАВЫЙ                          = 0x0403,
    ДОП0                                = 0x0409,
    ДОП1                                = 0x040A,
    ДОП2                                = 0x040B,
    ДОП3                                = 0x040C,
    ЦВЕТОИНДЕКС                         = 0x1900,
    КРАСНЫЙ                                 = 0x1903,
    ЗЕЛЁНЫЙ                               = 0x1904,
    СИНИЙ                                = 0x1905,
    АЛЬФА                               = 0x1906,
    СВЕЧЕНИЕ                           = 0x1909,
    АЛЬФА_СВЕЧЕНИЯ                     = 0x190A,
    АЛЬФАБИТЫ                          = 0x0D55,
    КРАСНЫЕ_БИТЫ                            = 0x0D52,
    ЗЕЛЁНЫЕ_БИТЫ                          = 0x0D53,
    СИНИЕ_БИТЫ                           = 0x0D54,
    ИНДЕКСБИТЫ                          = 0x0D51,
    БИТЫ_СУБПИКСЕЛЕЙ                       = 0x0D50,
    ДОП_БУФЕРЫ                         = 0x0C00,
    БУФЕР_ЧТЕНИЯ                         = 0x0C02,
    БУФЕР_РИСОВАНИЯ                         = 0x0C01,
    ДВОЙНОЙ_БУФЕР                        = 0x0C32,
    СТЕРЕО                              = 0x0C33,
    БИТМАП                              = 0x1A00,
    ЦВЕТ                               = 0x1800,
    ДАЛЬ                               = 0x1801,
    ШАБЛОН                             = 0x1802,
    ПСЕВДО_СЛУЧАЙНЫЙ                              = 0x0BD0,
    КЗС                                 = 0x1907,
    КЗСА                                = 0x1908,
	//English
	GL_NONE				= 0x0,
	GL_LEFT				= 0x0406, 
	GL_RIGHT				= 0x0407,
	GL_FRONT_LEFT			= 0x0400,
	GL_FRONT_RIGHT			= 0x0401,
	GL_BACK_LEFT			= 0x0402,
	GL_BACK_RIGHT			= 0x0403,
	GL_AUX0				= 0x0409,
	GL_AUX1				= 0x040A,
	GL_AUX2				= 0x040B,
	GL_AUX3				= 0x040C,
	GL_COLOR_INDEX			= 0x1900,
	GL_RED				= 0x1903,
	GL_GREEN				= 0x1904,
	GL_BLUE				= 0x1905,
	GL_ALPHA				= 0x1906,
	GL_LUMINANCE			= 0x1909,
	GL_LUMINANCE_ALPHA			= 0x190A,
	GL_ALPHA_BITS			= 0x0D55,
	GL_RED_BITS			= 0x0D52,
	GL_GREEN_BITS			= 0x0D53,
	GL_BLUE_BITS			= 0x0D54,
	GL_INDEX_BITS			= 0x0D51,
	GL_SUBPIXEL_BITS			= 0x0D50,
	GL_AUX_BUFFERS			= 0x0C00,
	GL_READ_BUFFER			= 0x0C02,
	GL_DRAW_BUFFER			= 0x0C01,
	GL_DOUBLEBUFFER			= 0x0C32,
	GL_STEREO				= 0x0C33,
	GL_BITMAP				= 0x1A00,
	GL_COLOR				= 0x1800,
	GL_DEPTH				= 0x1801,
	GL_STENCIL				= 0x1802,
	GL_DITHER				= 0x0BD0,
	GL_RGB				= 0x1907,
	GL_RGBA				= 0x1908,

    // Реализационные границы
    МАКС_ВНЕДРЕНИЕ_СПИСКА                    = 0x0B31,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ              = 0x0D35,
    МАКС_ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ           = 0x0D36,
    МАКС_ГЛУБИНА_СТЕКА_ИМЁН                = 0x0D37,
    МАКС_ГЛУБИНА_СТЕКА_ПРОЕКЦИЙ          = 0x0D38,
    МАКС_ГЛУБИНА_СТЕКА_ТЕКСТУР             = 0x0D39,
    МАКС_ПОРЯДОК_ОЦЕНКИ                      = 0x0D30,
    МАКС_ОГНЕЙ                          = 0x0D31,
    МАКС_ПЛОСКОСТЕЙ_ОБРЕЗКИ                     = 0x0D32,
    МАКС_РАЗМЕР_ТЕКСТУРЫ                    = 0x0D33,
    МАКС_ТАБЛИЦА_КАРТЫ_ПИКСЕЛЕЙ                 = 0x0D34,
    МАКС_РАЗМЕРЫ_ВЬЮПОРТА                   = 0x0D3A,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ_КЛИЕНТА       = 0x0D3B,
	//English
	GL_MAX_LIST_NESTING		= 0x0B31,
	GL_MAX_ATTRIB_STACK_DEPTH		= 0x0D35,
	GL_MAX_MODELVIEW_STACK_DEPTH	= 0x0D36,
	GL_MAX_NAME_STACK_DEPTH		= 0x0D37,
	GL_MAX_PROJECTION_STACK_DEPTH	= 0x0D38,
	GL_MAX_TEXTURE_STACK_DEPTH		= 0x0D39,
	GL_MAX_EVAL_ORDER			= 0x0D30,
	GL_MAX_LIGHTS			= 0x0D31,
	GL_MAX_CLIP_PLANES			= 0x0D32,
	GL_MAX_TEXTURE_SIZE		= 0x0D33,
	GL_MAX_PIXEL_MAP_TABLE		= 0x0D34,
	GL_MAX_VIEWPORT_DIMS		= 0x0D3A,
	GL_MAX_CLIENT_ATTRIB_STACK_DEPTH	= 0x0D3B,

    // Получатели
    ГЛУБИНА_СТЕКА_АТРИБУТОВ                  = 0x0BB0,
    ГЛУБИНА_СТЕКА_АТРИБ_КЛИЕНТА           = 0x0BB1,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ЦВЕТА                   = 0x0C22,
    МАСКА_ЗАПИСИ_ЦВЕТА                     = 0x0C23,
    ТЕКУЩИЙ_ИНДЕКС                       = 0x0B01,
    ТЕКУЩИЙ_ЦВЕТ                       = 0x0B00,
    ТЕКУЩАЯ_НОРМАЛЬ                      = 0x0B02,
    ТЕКУЩИЙ_ЦВЕТ_РАСТРА                = 0x0B04,
    ТЕКУЩЕЕ_УДАЛЕНИЕ_РАСТРА             = 0x0B09,
    ТЕКУЩИЙ_ИНДЕКС_РАСТРА                = 0x0B05,
    ТЕКУЩАЯ_ПОЗИЦИЯ_РАСТРА             = 0x0B07,
    ТЕКУЩИЕ_КООРД_ТЕКСТУРЫ_РАСТРА       = 0x0B06,
    ТЕКУЩЕЕ_ПОЛОЖЕНИЕ_РАСТРА_НОРМ       = 0x0B08,
    ТЕКУЩИЕ_КООРИНАТЫ_ТЕКСТУРЫ              = 0x0B03,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ИНДЕКСА                   = 0x0C20,
    РЕЖИМ_ИНДЕКСА                          = 0x0C30,
    МАСКА_ЗАПИСИ_ИНДЕКСА                     = 0x0C21,
    МАТРИЦА_ОБЗОРА_МОДЕЛИ                    = 0x0BA6,
    ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ               = 0x0BA3,
    ГЛУБИНА_СТЕКА_ИМЁН                    = 0x0D70,
    МАТРИЦА_ПРОЕКЦИИ                   = 0x0BA7,
    ГЛУБИНА_СТЕКА_ПРОЕКЦИИ              = 0x0BA4,
    РЕЖИМ_ОТОБРАЖЕНИЯ                         = 0x0C40,
    РЕЖИМ_КЗСА                           = 0x0C31,
    МАТРИЦА_ТЕКСТУРЫ                      = 0x0BA8,
    ГЛУБИНА_СТЕКА_ТЕКСТУР                 = 0x0BA5,
    ВЬЮПОРТ                            = 0x0BA2,
	//English
	GL_ATTRIB_STACK_DEPTH		= 0x0BB0,
	GL_CLIENT_ATTRIB_STACK_DEPTH	= 0x0BB1,
	GL_COLOR_CLEAR_VALUE		= 0x0C22,
	GL_COLOR_WRITEMASK			= 0x0C23,
	GL_CURRENT_INDEX			= 0x0B01,
	GL_CURRENT_COLOR			= 0x0B00,
	GL_CURRENT_NORMAL			= 0x0B02,
	GL_CURRENT_RASTER_COLOR		= 0x0B04,
	GL_CURRENT_RASTER_DISTANCE		= 0x0B09,
	GL_CURRENT_RASTER_INDEX		= 0x0B05,
	GL_CURRENT_RASTER_POSITION		= 0x0B07,
	GL_CURRENT_RASTER_TEXTURE_COORDS	= 0x0B06,
	GL_CURRENT_RASTER_POSITION_VALID	= 0x0B08,
	GL_CURRENT_TEXTURE_COORDS		= 0x0B03,
	GL_INDEX_CLEAR_VALUE		= 0x0C20,
	GL_INDEX_MODE			= 0x0C30,
	GL_INDEX_WRITEMASK			= 0x0C21,
	GL_MODELVIEW_MATRIX		= 0x0BA6,
	GL_MODELVIEW_STACK_DEPTH		= 0x0BA3,
	GL_NAME_STACK_DEPTH		= 0x0D70,
	GL_PROJECTION_MATRIX		= 0x0BA7,
	GL_PROJECTION_STACK_DEPTH		= 0x0BA4,
	GL_RENDER_MODE			= 0x0C40,
	GL_RGBA_MODE			= 0x0C31,
	GL_TEXTURE_MATRIX			= 0x0BA8,
	GL_TEXTURE_STACK_DEPTH		= 0x0BA5,
	GL_VIEWPORT			= 0x0BA2,

    // Оцениватели
    АВТО_НОРМАЛЬ                         = 0x0D80,
    КАРТА1_ЦВЕТ_4                        = 0x0D90,
    КАРТА1_ДОМЕН_СЕТКИ                    = 0x0DD0,
    КАРТА1_ОТРЕЗКИ_СЕТКИ                  = 0x0DD1,
    КАРТА1_ИНДЕКС                          = 0x0D91,
    КАРТА1_НОРМАЛЬ                         = 0x0D92,
    КАРТА1_КООРД_ТЕКСТУРЫ_1                = 0x0D93,
    КАРТА1_КООРД_ТЕКСТУРЫ_2                = 0x0D94,
    КАРТА1_КООРД_ТЕКСТУРЫ_3                = 0x0D95,
    КАРТА1_КООРД_ТЕКСТУРЫ_4                = 0x0D96,
    КАРТА1_ВЕРШИНА_3                       = 0x0D97,
    КАРТА1_ВЕРШИНА_4                       = 0x0D98,
    КАРТА2_ЦВЕТ_4                        = 0x0DB0,
    КАРТА2_ДОМЕН_СЕТКИ                    = 0x0DD2,
    КАРТА2_ОТРЕЗКИ_СЕТКИ                  = 0x0DD3,
    КАРТА2_ИНДЕКС                          = 0x0DB1,
    КАРТА2_НОРМАЛЬ                         = 0x0DB2,
    КАРТА2_КООРД_ТЕКСТУРЫ_1                = 0x0DB3,
    КАРТА2_КООРД_ТЕКСТУРЫ_2                = 0x0DB4,
    КАРТА2_КООРД_ТЕКСТУРЫ_3                = 0x0DB5,
    КАРТА2_КООРД_ТЕКСТУРЫ_4                = 0x0DB6,
    КАРТА2_ВЕРШИНА_3                       = 0x0DB7,
    КАРТА2_ВЕРШИНА_4                       = 0x0DB8,
    КОЭФФ                               = 0x0A00,
    ДОМЕН                              = 0x0A02,
    ПОРЯДОК                               = 0x0A01,
	//English
	GL_AUTO_NORMAL			= 0x0D80,
	GL_MAP1_COLOR_4			= 0x0D90,
	GL_MAP1_GRID_DOMAIN		= 0x0DD0,
	GL_MAP1_GRID_SEGMENTS		= 0x0DD1,
	GL_MAP1_INDEX			= 0x0D91,
	GL_MAP1_NORMAL			= 0x0D92,
	GL_MAP1_TEXTURE_COORD_1		= 0x0D93,
	GL_MAP1_TEXTURE_COORD_2		= 0x0D94,
	GL_MAP1_TEXTURE_COORD_3		= 0x0D95,
	GL_MAP1_TEXTURE_COORD_4		= 0x0D96,
	GL_MAP1_VERTEX_3			= 0x0D97,
	GL_MAP1_VERTEX_4			= 0x0D98,
	GL_MAP2_COLOR_4			= 0x0DB0,
	GL_MAP2_GRID_DOMAIN		= 0x0DD2,
	GL_MAP2_GRID_SEGMENTS		= 0x0DD3,
	GL_MAP2_INDEX			= 0x0DB1,
	GL_MAP2_NORMAL			= 0x0DB2,
	GL_MAP2_TEXTURE_COORD_1		= 0x0DB3,
	GL_MAP2_TEXTURE_COORD_2		= 0x0DB4,
	GL_MAP2_TEXTURE_COORD_3		= 0x0DB5,
	GL_MAP2_TEXTURE_COORD_4		= 0x0DB6,
	GL_MAP2_VERTEX_3			= 0x0DB7,
	GL_MAP2_VERTEX_4			= 0x0DB8,
	GL_COEFF				= 0x0A00,
	GL_DOMAIN				= 0x0A02,
	GL_ORDER				= 0x0A01,

    // Подсказки
    ТУМАН_ПОДСКАЗКА                            = 0x0C54,
    СМЯГЧЕНИЕ_ЛИНИИ_ПОДСКАЗКА                    = 0x0C52,
    КОРРЕКЦИЯ_ПЕРСПЕКТИВЫ_ПОДСКАЗКА         = 0x0C50,
    СМЯГЧЕНИЕ_ТОЧКИ_ПОДСКАЗКА                   = 0x0C51,
    СМЯГЧЕНИЕ_МНОГОУГ_ПОДСКАЗКА                 = 0x0C53,
    НЕ_ВАЖНО                           = 0x1100,
    НАИБЫСТРО                             = 0x1101,
    НАИЛУЧШЕ                              = 0x1102,
	//English
	GL_FOG_HINT			= 0x0C54,
	GL_LINE_SMOOTH_HINT		= 0x0C52,
	GL_PERSPECTIVE_CORRECTION_HINT	= 0x0C50,
	GL_POINT_SMOOTH_HINT		= 0x0C51,
	GL_POLYGON_SMOOTH_HINT		= 0x0C53,
	GL_DONT_CARE			= 0x1100,
	GL_FASTEST				= 0x1101,
	GL_NICEST				= 0x1102,

    // Захват ножницами
    ТЕСТ_НОЖНИЦ                        = 0x0C11,
    ЗАХВАТ_НОЖНИЦ                         = 0x0C10,
	//English
	GL_SCISSOR_TEST			= 0x0C11,
	GL_SCISSOR_BOX			= 0x0C10,

    // Пиксельный режим/перенос
    ЦВЕТ_КАРТЫ                           = 0x0D10,
    ШАБЛОН_КАРТЫ                         = 0x0D11,
    СДВИГ_ИНДЕКСА                         = 0x0D12,
    СМЕЩЕНИЕ_ИНДЕКСА                        = 0x0D13,
    ШКАЛА_КРАСНОГО                           = 0x0D14,
    УКЛОН_КРАСНОГО                            = 0x0D15,
    ШКАЛА_ЗЕЛЁНОГО                         = 0x0D18,
    УКЛОН_ЗЕЛЁНОГО                          = 0x0D19,
    ШКАЛА_СИНЕГО                          = 0x0D1A,
    УКЛОН_СИНЕГО                           = 0x0D1B,
    ШКАЛА_АЛЬФЫ                         = 0x0D1C,
    УКЛОН_АЛЬФЫ                          = 0x0D1D,
    ШКАЛА_ДАЛИ                         = 0x0D1E,
    УКЛОН_ДАЛИ                          = 0x0D1F,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Т_В_Т               = 0x0CB1,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_Ц               = 0x0CB0,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_К               = 0x0CB2,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_G               = 0x0CB3,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_С              = 0x0CB4,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_А              = 0x0CB5,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_К_В_К               = 0x0CB6,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_З_В_З               = 0x0CB7,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_С_В_С               = 0x0CB8,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_А_В_А               = 0x0CB9,
    КАРТА_ПИКСЕЛЯ_Т_В_Т                    = 0x0C71,
    КАРТА_ПИКСЕЛЯ_Ц_В_Ц                    = 0x0C70,
    КАРТА_ПИКСЕЛЯ_Ц_В_К                    = 0x0C72,
    КАРТА_ПИКСЕЛЯ_Ц_В_З                    = 0x0C73,
    КАРТА_ПИКСЕЛЯ_Ц_В_С                    = 0x0C74,
    КАРТА_ПИКСЕЛЯ_Ц_В_А                    = 0x0C75,
    КАРТА_ПИКСЕЛЯ_К_В_К                    = 0x0C76,
    КАРТА_ПИКСЕЛЯ_З_В_З                    = 0x0C77,
    КАРТА_ПИКСЕЛЯ_С_В_С                    = 0x0C78,
    КАРТА_ПИКСЕЛЯ_А_В_А                    = 0x0C79,
    ПАК_РАСКЛАДКА                      = 0x0D05,
    ПАК_ВНАЧАЛЕ_МЛБ                      = 0x0D01,
    ПАК_ДЛИНА_РЯДА                     = 0x0D02,
    ПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                    = 0x0D04,
    ПАК_ПРОПУСТИТЬ_РЯДЫ                     = 0x0D03,
    ПАК_ОБМЕНЯТЬ_БУФЕРЫ                     = 0x0D00,
    РАСПАК_РАСКЛАДКА                    = 0x0CF5,
    РАСПАК_ВНАЧАЛЕ_МЛБ                    = 0x0CF1,
    РАСПАК_ДЛИНА_РЯДА                   = 0x0CF2,
    РАСПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                  = 0x0CF4,
    РАСПАК_ПРОПУСТИТЬ_РЯДЫ                    = 0x0CF3,
    РАСПАК_ОБМЕНЯТЬ_БУФЕРЫ                   = 0x0CF0,
    ЗУМ_КШ                              = 0x0D16,
    ЗУМ_КВ                              = 0x0D17,
	//English
    GL_MAP_COLOR			= 0x0D10,
	GL_MAP_STENCIL			= 0x0D11,
	GL_INDEX_ШИФТ			= 0x0D12,
	GL_INDEX_OFFSET			= 0x0D13,
	GL_RED_SCALE			= 0x0D14,
	GL_RED_BIAS			= 0x0D15,
	GL_GREEN_SCALE			= 0x0D18,
	GL_GREEN_BIAS			= 0x0D19,
	GL_BLUE_SCALE			= 0x0D1A,
	GL_BLUE_BIAS			= 0x0D1B,
	GL_ALPHA_SCALE			= 0x0D1C,
	GL_ALPHA_BIAS			= 0x0D1D,
	GL_DEPTH_SCALE			= 0x0D1E,
	GL_DEPTH_BIAS			= 0x0D1F,
	GL_PIXEL_MAP_S_TO_S_SIZE		= 0x0CB1,
	GL_PIXEL_MAP_I_TO_I_SIZE		= 0x0CB0,
	GL_PIXEL_MAP_I_TO_R_SIZE		= 0x0CB2,
	GL_PIXEL_MAP_I_TO_G_SIZE		= 0x0CB3,
	GL_PIXEL_MAP_I_TO_B_SIZE		= 0x0CB4,
	GL_PIXEL_MAP_I_TO_A_SIZE		= 0x0CB5,
	GL_PIXEL_MAP_R_TO_R_SIZE		= 0x0CB6,
	GL_PIXEL_MAP_G_TO_G_SIZE		= 0x0CB7,
	GL_PIXEL_MAP_B_TO_B_SIZE		= 0x0CB8,
	GL_PIXEL_MAP_A_TO_A_SIZE		= 0x0CB9,
	GL_PIXEL_MAP_S_TO_S		= 0x0C71,
	GL_PIXEL_MAP_I_TO_I		= 0x0C70,
	GL_PIXEL_MAP_I_TO_R		= 0x0C72,
	GL_PIXEL_MAP_I_TO_G		= 0x0C73,
	GL_PIXEL_MAP_I_TO_B		= 0x0C74,
	GL_PIXEL_MAP_I_TO_A		= 0x0C75,
	GL_PIXEL_MAP_R_TO_R		= 0x0C76,
	GL_PIXEL_MAP_G_TO_G		= 0x0C77,
	GL_PIXEL_MAP_B_TO_B		= 0x0C78,
	GL_PIXEL_MAP_A_TO_A		= 0x0C79,
	GL_PACK_ALIGNMENT			= 0x0D05,
	GL_PACK_LSB_FIRST			= 0x0D01,
	GL_PACK_ROW_LENGTH			= 0x0D02,
	GL_PACK_SKIP_PIXELS		= 0x0D04,
	GL_PACK_SKIP_ROWS			= 0x0D03,
	GL_PACK_SWAP_BYTES			= 0x0D00,
	GL_UNPACK_ALIGNMENT		= 0x0CF5,
	GL_UNPACK_LSB_FIRST		= 0x0CF1,
	GL_UNPACK_ROW_LENGTH		= 0x0CF2,
	GL_UNPACK_SKIP_PIXELS		= 0x0CF4,
	GL_UNPACK_SKIP_ROWS		= 0x0CF3,
	GL_UNPACK_SWAP_BYTES		= 0x0CF0,
	GL_ZOOM_X				= 0x0D16,
	GL_ZOOM_Y				= 0x0D17,

    // Картирование текстуры
    СРЕДА_ТЕКС                         = 0x2300,
    РЕЖИМ_СРЕДЫ_ТЕКС                    = 0x2200,
    ТЕКСТУРА_М1                          = 0x0DE0,
    ТЕКСТУРА_М2                          = 0x0DE1,
    TEXTURE_WRAP_S                      = 0x2802,
    TEXTURE_WRAP_T                      = 0x2803,
    TEXTURE_MAG_FILTER                  = 0x2800,
    TEXTURE_MIN_FILTER                  = 0x2801,
    СРЕДА_ТЕКС_ЦВЕТ                   = 0x2201,
    ГЕН_ТЕКС_S                       = 0x0C60,
    ГЕН_ТЕКС_T                       = 0x0C61,
    РЕЖИМ_ГЕН_ТЕКСТУРЫ                    = 0x2500,
    ЦВЕТ_КАЙМЫ_ТЕКСТУРЫ                = 0x1004,
    ШИРИНА_ТЕКСТУРЫ                       = 0x1000,
    ВЫСОТА_ТЕКСТУРЫ                      = 0x1001,
    КАЙМА_ТЕКСТУРЫ                      = 0x1005,
    КОМПОНЕНТЫ_ТЕКСТУРЫ                  = 0x1003,
    РАЗМЕР_КРАСНОГО_ТЕКСТУРЫ                    = 0x805C,
    РАЗМЕР_ЗЕЛЁНОГО_ТЕКСТУРЫ                  = 0x805D,
    РАЗМЕР_СИНЕГО_ТЕКСТУРЫ                   = 0x805E,
    РАЗМЕР_АЛЬФЫ_ТЕКСТУРЫ                  = 0x805F,
    РАЗМЕР_ОСВЕЩЕННОСТИ_ТЕКСТУРЫ              = 0x8060,
    РАЗМЕР_ИНТЕНСИВНОСТИ_ТЕКСТУРЫ              = 0x8061,
	 NEAREST_MIPКАРТА_NEAREST              = 0x2700,
    NEAREST_MIPКАРТА_LINEAR               = 0x2702,
    LINEAR_MIPКАРТА_NEAREST               = 0x2701,
    LINEAR_MIPКАРТА_LINEAR                = 0x2703,
    ЛИНЕЙНЫЙ_ОБЪЕКТ                       = 0x2401,
    ПЛОСКИЙ_ОБЪЕКТ                        = 0x2501,
    EYE_LINEAR                          = 0x2400,
    EYE_PLANE                           = 0x2502,
    КАРТА_ШАРА                          = 0x2402,
    DECAL                               = 0x2101,
    МОДУЛИРУЙ                            = 0x2100,
    БЛИЖАЙШАЯ                             = 0x2600,
    ПОВТОРИ                              = 0x2901,
    CLAMP                               = 0x2900,
    S                                   = 0x2000,
    T                                   = 0x2001,
    R                                   = 0x2002,
    Q                                   = 0x2003,
    ГЕН_ТЕКС_R                       = 0x0C62,
    ГЕН_ТЕКС_Q                       = 0x0C63,
	//English
	GL_TEXTURE_ENV			= 0x2300,
	GL_TEXTURE_ENV_MODE		= 0x2200,
	GL_TEXTURE_1D			= 0x0DE0,
	GL_TEXTURE_2D			= 0x0DE1,
	GL_TEXTURE_WRAP_S			= 0x2802,
	GL_TEXTURE_WRAP_T			= 0x2803,
	GL_TEXTURE_MAG_FILTER		= 0x2800,
	GL_TEXTURE_MIN_FILTER		= 0x2801,
	GL_TEXTURE_ENV_COLOR		= 0x2201,
	GL_TEXTURE_GEN_S			= 0x0C60,
	GL_TEXTURE_GEN_T			= 0x0C61,
	GL_TEXTURE_GEN_MODE		= 0x2500,
	GL_TEXTURE_BORDER_COLOR		= 0x1004,
	GL_TEXTURE_WIDTH			= 0x1000,
	GL_TEXTURE_HEIGHT			= 0x1001,
	GL_TEXTURE_BORDER			= 0x1005,
	GL_TEXTURE_COMPONENTS		= 0x1003,
	GL_TEXTURE_RED_SIZE		= 0x805C,
	GL_TEXTURE_GREEN_SIZE		= 0x805D,
	GL_TEXTURE_BLUE_SIZE		= 0x805E,
	GL_TEXTURE_ALPHA_SIZE		= 0x805F,
	GL_TEXTURE_LUMINANCE_SIZE		= 0x8060,
	GL_TEXTURE_INTENSITY_SIZE		= 0x8061,
	GL_NEAREST_MIPMAP_NEAREST		= 0x2700,
	GL_NEAREST_MIPMAP_LINEAR		= 0x2702,
	GL_LINEAR_MIPMAP_NEAREST		= 0x2701,
	GL_LINEAR_MIPMAP_LINEAR		= 0x2703,
	GL_OBJECT_LINEAR			= 0x2401,
	GL_OBJECT_PLANE			= 0x2501,
	GL_EYE_LINEAR			= 0x2400,
	GL_EYE_PLANE			= 0x2502,
	GL_SPHERE_MAP			= 0x2402,
	GL_DECAL				= 0x2101,
	GL_MODULATE			= 0x2100,
	GL_NEAREST				= 0x2600,
	GL_REPEAT				= 0x2901,
	GL_CLAMP				= 0x2900,
	GL_S				= 0x2000,
	GL_T				= 0x2001,
	GL_R				= 0x2002,
	GL_Q				= 0x2003,
	GL_TEXTURE_GEN_R			= 0x0C62,
	GL_TEXTURE_GEN_Q			= 0x0C63,

    // Утилиты
    ПРОИЗВОДИТЕЛЬ                              = 0x1F00,
    ОТОБРАЗИТЕЛЬ                            = 0x1F01,
    ВЕРСИЯ                             = 0x1F02,
    РАСШИРЕНИЯ                          = 0x1F03,
	//English
	GL_VENDOR				= 0x1F00,
	GL_RENDERER			= 0x1F01,
	GL_VERSION				= 0x1F02,
	GL_EXTENSIONS			= 0x1F03,

    // Ошибки
    ОШИБОК_НЕТ                            = 0x0,
    НЕВЕРНОЕ_ЗНАЧЕНИЕ                       = 0x0501,
    НЕПРАВИЛЬНЫЙ_ПЕРЕЧЕНЬ                        = 0x0500,
    НЕВЕРНАЯ_ОПЕРАЦИЯ                   = 0x0502,
    ПЕРЕПОЛНЕНИЕ_СТЕКА                      = 0x0503,
    НЕДОБОР_СТЕКА                    = 0x0504,
    НЕХВАТКА_ПАМЯТИ                       = 0x0505,
	//English
	GL_NO_ERROR			= 0x0,
	GL_INVALID_VALUE			= 0x0501,
	GL_INVALID_ENUM			= 0x0500,
	GL_INVALID_OPERATION		= 0x0502,
	GL_STACK_OVERFLOW			= 0x0503,
	GL_STACK_UNDERFLOW			= 0x0504,
	GL_OUT_OF_MEMORY			= 0x0505,
}

// glPush/PopAttrib bits
enum : бцел
{
    ТЕКУЩИЙ_БИТ                         = 0x00000001,
    БИТ_ТОЧКИ                           = 0x00000002,
    БИТ_ЛИНИИ                            = 0x00000004,
    БИТ_МНОГОУГ                         = 0x00000008,
    БИТ_УЗОРА_МНОГОУГ                 = 0x00000010,
    БИТ__РЕЖИМА_ПИКСЕЛЯ                      = 0x00000020,
    БИТ_ОСВЕЩЕНИЯ                        = 0x00000040,
    БИТ_ТУМАНА                             = 0x00000080,
    БИТ_БУФЕРА_ДАЛИ                    = 0x00000100,
    БИТ_БУФЕРА_АККУМ                    = 0x00000200,
    БИТ_БУФЕРА_ШАБЛОНА                  = 0x00000400,
    БИТ_ВЬЮПОРТА                        = 0x00000800,
    БИТ_ТРАНСФОРМА                       = 0x00001000,
    БИТ_ВКЛЮЧИТЬ                          = 0x00002000,
    БИТ_БУФЕРА_ЦВЕТА                    = 0x00004000,
    БИТ_ПОДСКАЗКИ                            = 0x00008000,
    БИТ_ОЦЕНКИ                            = 0x00010000,
    БИТ_СПИСКА                            = 0x00020000,
    БИТ_ТЕКСТУРЫ                         = 0x00040000,
    БИТ_НОЖНИЦ                         = 0x00080000,
    БИТЫ_ВСЕХ_АТРИБУТОВ                     = 0x000FFFFF,
	//English
	GL_CURRENT_BIT			= 0x00000001,
	GL_POINT_BIT			= 0x00000002,
	GL_LINE_BIT			= 0x00000004,
	GL_POLYGON_BIT			= 0x00000008,
	GL_POLYGON_STIPPLE_BIT		= 0x00000010,
	GL_PIXEL_MODE_BIT			= 0x00000020,
	GL_LIGHTING_BIT			= 0x00000040,
	GL_FOG_BIT				= 0x00000080,
	GL_DEPTH_BUFFER_BIT		= 0x00000100,
	GL_ACCUM_BUFFER_BIT		= 0x00000200,
	GL_STENCIL_BUFFER_BIT		= 0x00000400,
	GL_VIEWPORT_BIT			= 0x00000800,
	GL_TRANSFORM_BIT			= 0x00001000,
	GL_ENABLE_BIT			= 0x00002000,
	GL_COLOR_BUFFER_BIT		= 0x00004000,
	GL_HINT_BIT			= 0x00008000,
	GL_EVAL_BIT			= 0x00010000,
	GL_LIST_BIT			= 0x00020000,
	GL_TEXTURE_BIT			= 0x00040000,
	GL_SCISSOR_BIT			= 0x00080000,
	GL_ALL_ATTRIB_BITS			= 0x000FFFFF,
	}

// gl 1.1
enum : Гперечень
{
ПРОКСИТЕКСТУРА_1М                    = 0x8063,
ПРОКСИТЕКСТУРА_2М                    = 0x8064,
ПРИОРИТЕТ_ТЕКСТУРЫ                    = 0x8066,
РЕЗИДЕНТНАЯ_ТЕКСТУРА                    = 0x8067,
ПРИВЯЗКА_ТЕКСТУРЫ_1М                  = 0x8068,
ПРИВЯЗКА_ТЕКСТУРЫ_2М                  = 0x8069,
ВНУТРЕННИЙ_ФОРМАТ_ТЕКСТУРЫ             = 0x1003,
АЛЬФА4                              = 0x803B,
АЛЬФА8                              = 0x803C,
АЛЬФА12                             = 0x803D,
АЛЬФА16                             = 0x803E,
СВЕТИМОСТЬ4                          = 0x803F,
СВЕТИМОСТЬ8                          = 0x8040,
СВЕТИМОСТЬ12                         = 0x8041,
СВЕТИМОСТЬ16                         = 0x8042,
СВЕТИМОСТЬ4_АЛЬФА4                   = 0x8043,
СВЕТИМОСТЬ6_АЛЬФА2                   = 0x8044,
СВЕТИМОСТЬ8_АЛЬФА8                   = 0x8045,
СВЕТИМОСТЬ12_АЛЬФА4                  = 0x8046,
СВЕТИМОСТЬ12_АЛЬФА12                 = 0x8047,
СВЕТИМОСТЬ16_АЛЬФА16                 = 0x8048,
ИНТЕНСИВНОСТЬ                           = 0x8049,
ИНТЕНСИВНОСТЬ4                          = 0x804A,
ИНТЕНСИВНОСТЬ8                          = 0x804B,
ИНТЕНСИВНОСТЬ12                         = 0x804C,
ИНТЕНСИВНОСТЬ16                         = 0x804D,
К3_З3_С2                            = 0x2A10,
КЗС4                                = 0x804F,
КЗС5                                = 0x8050,
КЗС8                                = 0x8051,
КЗС10                               = 0x8052,
КЗС12                               = 0x8053,
КЗС16                               = 0x8054,
КЗСА2                               = 0x8055,
КЗСА4                               = 0x8056,
КЗС5_А1                             = 0x8057,
КЗСА8                               = 0x8058,
КЗС10_А2                            = 0x8059,
КЗСА12                              = 0x805A,
КЗСА16                              = 0x805B,
//English
GL_PROXY_TEXTURE_1D		= 0x8063,
GL_PROXY_TEXTURE_2D		= 0x8064,
GL_TEXTURE_PRIORITY		= 0x8066,
GL_TEXTURE_RESIDENT		= 0x8067,
GL_TEXTURE_BINDING_1D		= 0x8068,
GL_TEXTURE_BINDING_2D		= 0x8069,
GL_TEXTURE_INTERNAL_FORMAT		= 0x1003,
GL_ALPHA4				= 0x803B,
GL_ALPHA8				= 0x803C,
GL_ALPHA12				= 0x803D,
GL_ALPHA16				= 0x803E,
GL_LUMINANCE4			= 0x803F,
GL_LUMINANCE8			= 0x8040,
GL_LUMINANCE12			= 0x8041,
GL_LUMINANCE16			= 0x8042,
GL_LUMINANCE4_ALPHA4		= 0x8043,
GL_LUMINANCE6_ALPHA2		= 0x8044,
GL_LUMINANCE8_ALPHA8		= 0x8045,
GL_LUMINANCE12_ALPHA4		= 0x8046,
GL_LUMINANCE12_ALPHA12		= 0x8047,
GL_LUMINANCE16_ALPHA16		= 0x8048,
GL_INTENSITY			= 0x8049,
GL_INTENSITY4			= 0x804A,
GL_INTENSITY8			= 0x804B,
GL_INTENSITY12			= 0x804C,
GL_INTENSITY16			= 0x804D,
GL_R3_G3_B2			= 0x2A10,
GL_RGB4				= 0x804F,
GL_RGB5				= 0x8050,
GL_RGB8				= 0x8051,
GL_RGB10				= 0x8052,
GL_RGB12				= 0x8053,
GL_RGB16				= 0x8054,
GL_RGBA2				= 0x8055,
GL_RGBA4				= 0x8056,
GL_RGB5_A1				= 0x8057,
GL_RGBA8				= 0x8058,
GL_RGB10_A2			= 0x8059,
GL_RGBA12				= 0x805A,
GL_RGBA16				= 0x805B,
}

enum : бцел
{
    БИТ_ХРАНЕНИЯ_ПИКСЕЛЯ_КЛИЕНТА              = 0x00000001,
    БИТ_МАССИВА_КВЕРШИН_КЛИЕНТА             = 0x00000002,
    ВСЕ_БИТЫ_АТРБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
    БИТЫ_ВСЕХ_АТРИБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
	//English
	GL_CLIENT_PIXEL_STORE_BIT		= 0x00000001,
    GL_CLIENT_VERTEX_ARRAY_BIT		= 0x00000002,
	GL_ALL_CLIENT_ATTRIB_BITS		= 0xFFFFFFFF,
	GL_CLIENT_ALL_ATTRIB_BITS		= 0xFFFFFFFF,
}

enum: Гперечень
{
// OpenGL 1.2
 GL_RESCALE_NORMAL			= 0x803A,
 GL_CLAMP_TO_EDGE			= 0x812F,
 GL_MAX_ELEMENTS_VERTICES		= 0x80E8,
 GL_MAX_ELEMENTS_INDICES		= 0x80E9,
 GL_BGR				= 0x80E0,
 GL_BGRA				= 0x80E1,
 GL_UNSIGNED_BYTE_3_3_2		= 0x8032,
 GL_UNSIGNED_BYTE_2_3_3_REV		= 0x8362,
 GL_UNSIGNED_SHORT_5_6_5		= 0x8363,
 GL_UNSIGNED_SHORT_5_6_5_REV	= 0x8364,
 GL_UNSIGNED_SHORT_4_4_4_4		= 0x8033,
 GL_UNSIGNED_SHORT_4_4_4_4_REV	= 0x8365,
 GL_UNSIGNED_SHORT_5_5_5_1		= 0x8034,
 GL_UNSIGNED_SHORT_1_5_5_5_REV	= 0x8366,
 GL_UNSIGNED_INT_8_8_8_8		= 0x8035,
 GL_UNSIGNED_INT_8_8_8_8_REV	= 0x8367,
 GL_UNSIGNED_INT_10_10_10_2		= 0x8036,
 GL_UNSIGNED_INT_2_10_10_10_REV	= 0x8368,
 GL_LIGHT_MODEL_COLOR_CONTROL	= 0x81F8,
 GL_SINGLE_COLOR			= 0x81F9,
 GL_SEPARATE_SPECULAR_COLOR		= 0x81FA,
 GL_TEXTURE_MIN_LOD			= 0x813A,
 GL_TEXTURE_MAX_LOD			= 0x813B,
 GL_TEXTURE_BASE_LEVEL		= 0x813C,
 GL_TEXTURE_MAX_LEVEL		= 0x813D,
 GL_SMOOTH_POINT_SIZE_RANGE		= 0x0B12,
 GL_SMOOTH_POINT_SIZE_GRANULARITY	= 0x0B13,
 GL_SMOOTH_LINE_WIDTH_RANGE		= 0x0B22,
 GL_SMOOTH_LINE_WIDTH_GRANULARITY	= 0x0B23,
 GL_ALIASED_POINT_SIZE_RANGE	= 0x846D,
 GL_ALIASED_LINE_WIDTH_RANGE	= 0x846E,
 GL_PACK_SKIP_IMAGES		= 0x806B,
 GL_PACK_IMAGE_HEIGHT		= 0x806C,
 GL_UNPACK_SKIP_IMAGES		= 0x806D,
 GL_UNPACK_IMAGE_HEIGHT		= 0x806E,
 GL_TEXTURE_3D			= 0x806F,
 GL_PROXY_TEXTURE_3D		= 0x8070,
 GL_TEXTURE_DEPTH			= 0x8071,
 GL_TEXTURE_WRAP_R			= 0x8072,
 GL_MAX_3D_TEXTURE_SIZE		= 0x8073,
 GL_TEXTURE_BINDING_3D		= 0x806A,

// OpenGL 1.3
 GL_TEXTURE0			= 0x84C0,
 GL_TEXTURE1			= 0x84C1,
 GL_TEXTURE2			= 0x84C2,
 GL_TEXTURE3			= 0x84C3,
 GL_TEXTURE4			= 0x84C4,
 GL_TEXTURE5			= 0x84C5,
 GL_TEXTURE6			= 0x84C6,
 GL_TEXTURE7			= 0x84C7,
 GL_TEXTURE8			= 0x84C8,
 GL_TEXTURE9			= 0x84C9,
 GL_TEXTURE10			= 0x84CA,
 GL_TEXTURE11			= 0x84CB,
 GL_TEXTURE12			= 0x84CC,
 GL_TEXTURE13			= 0x84CD,
 GL_TEXTURE14			= 0x84CE,
 GL_TEXTURE15			= 0x84CF,
 GL_TEXTURE16			= 0x84D0,
 GL_TEXTURE17			= 0x84D1,
 GL_TEXTURE18			= 0x84D2,
 GL_TEXTURE19			= 0x84D3,
 GL_TEXTURE20			= 0x84D4,
 GL_TEXTURE21			= 0x84D5,
 GL_TEXTURE22			= 0x84D6,
 GL_TEXTURE23			= 0x84D7,
 GL_TEXTURE24			= 0x84D8,
 GL_TEXTURE25			= 0x84D9,
 GL_TEXTURE26			= 0x84DA,
 GL_TEXTURE27			= 0x84DB,
 GL_TEXTURE28			= 0x84DC,
 GL_TEXTURE29			= 0x84DD,
 GL_TEXTURE30			= 0x84DE,
 GL_TEXTURE31			= 0x84DF,
 GL_ACTIVE_TEXTURE			= 0x84E0,
 GL_CLIENT_ACTIVE_TEXTURE		= 0x84E1,
 GL_MAX_TEXTURE_UNITS		= 0x84E2,
 GL_NORMAL_MAP			= 0x8511,
 GL_REFLECTION_MAP			= 0x8512,
 GL_TEXTURE_CUBE_MAP		= 0x8513,
 GL_TEXTURE_BINDING_CUBE_MAP	= 0x8514,
 GL_TEXTURE_CUBE_MAP_POSITIVE_X	= 0x8515,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_X	= 0x8516,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Y	= 0x8517,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Y	= 0x8518,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Z	= 0x8519,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Z	= 0x851A,
 GL_PROXY_TEXTURE_CUBE_MAP		= 0x851B,
 GL_MAX_CUBE_MAP_TEXTURE_SIZE	= 0x851C,
 GL_COMPRESSED_ALPHA		= 0x84E9,
 GL_COMPRESSED_LUMINANCE		= 0x84EA,
 GL_COMPRESSED_LUMINANCE_ALPHA	= 0x84EB,
 GL_COMPRESSED_INTENSITY		= 0x84EC,
 GL_COMPRESSED_RGB			= 0x84ED,
 GL_COMPRESSED_RGBA			= 0x84EE,
 GL_TEXTURE_COMPRESSION_HINT	= 0x84EF,
 GL_TEXTURE_COMPRESSED_IMAGE_SIZE	= 0x86A0,
 GL_TEXTURE_COMPRESSED		= 0x86A1,
 GL_NUM_COMPRESSED_TEXTURE_FORMATS	= 0x86A2,
 GL_COMPRESSED_TEXTURE_FORMATS	= 0x86A3,
 GL_MULTISAMPLE			= 0x809D,
 GL_SAMPLE_ALPHA_TO_COVERAGE	= 0x809E,
 GL_SAMPLE_ALPHA_TO_ONE		= 0x809F,
 GL_SAMPLE_COVERAGE			= 0x80A0,
 GL_SAMPLE_BUFFERS			= 0x80A8,
 GL_SAMPLES				= 0x80A9,
 GL_SAMPLE_COVERAGE_VALUE		= 0x80AA,
 GL_SAMPLE_COVERAGE_INVERT		= 0x80AB,
 GL_MULTISAMPLE_BIT			= 0x20000000,
 GL_TRANSPOSE_MODELVIEW_MATRIX	= 0x84E3,
 GL_TRANSPOSE_PROJECTION_MATRIX	= 0x84E4,
 GL_TRANSPOSE_TEXTURE_MATRIX	= 0x84E5,
 GL_TRANSPOSE_COLOR_MATRIX		= 0x84E6,
 GL_COMBINE				= 0x8570,
 GL_COMBINE_RGB			= 0x8571,
 GL_COMBINE_ALPHA			= 0x8572,
 GL_SOURCE0_RGB			= 0x8580,
 GL_SOURCE1_RGB			= 0x8581,
 GL_SOURCE2_RGB			= 0x8582,
 GL_SOURCE0_ALPHA			= 0x8588,
 GL_SOURCE1_ALPHA			= 0x8589,
 GL_SOURCE2_ALPHA			= 0x858A,
 GL_OPERAND0_RGB			= 0x8590,
 GL_OPERAND1_RGB			= 0x8591,
 GL_OPERAND2_RGB			= 0x8592,
 GL_OPERAND0_ALPHA			= 0x8598,
 GL_OPERAND1_ALPHA			= 0x8599,
 GL_OPERAND2_ALPHA			= 0x859A,
 GL_RGB_SCALE			= 0x8573,
 GL_ADD_SIGNED			= 0x8574,
 GL_INTERPOLATE			= 0x8575,
 GL_SUBTRACT			= 0x84E7,
 GL_CONSTANT			= 0x8576,
 GL_PRIMARY_COLOR			= 0x8577,
 GL_PREVIOUS			= 0x8578,
 GL_DOT3_RGB			= 0x86AE,
 GL_DOT3_RGBA			= 0x86AF,
 GL_CLAMP_TO_BORDER			= 0x812D,

// OpenGL 1.4
 GL_BLEND_DST_RGB			= 0x80C8,
 GL_BLEND_SRC_RGB			= 0x80C9,
 GL_BLEND_DST_ALPHA			= 0x80CA,
 GL_BLEND_SRC_ALPHA			= 0x80CB,
 GL_POINT_SIZE_MIN			= 0x8126,
 GL_POINT_SIZE_MAX			= 0x8127,
 GL_POINT_FADE_THRESHOLD_SIZE	= 0x8128,
 GL_POINT_DISTANCE_ATTENUATION	= 0x8129,
 GL_GENERATE_MIPMAP			= 0x8191,
 GL_GENERATE_MIPMAP_HINT		= 0x8192,
 GL_DEPTH_COMPONENT16		= 0x81A5,
 GL_DEPTH_COMPONENT24		= 0x81A6,
 GL_DEPTH_COMPONENT32		= 0x81A7,
 GL_MIRRORED_REPEAT			= 0x8370,
 GL_FOG_COORDINATE_SOURCE		= 0x8450,
 GL_FOG_COORDINATE			= 0x8451,
 GL_FRAGMENT_DEPTH			= 0x8452,
 GL_CURRENT_FOG_COORDINATE		= 0x8453,
 GL_FOG_COORDINATE_ARRAY_TYPE	= 0x8454,
 GL_FOG_COORDINATE_ARRAY_STRIDE	= 0x8455,
 GL_FOG_COORDINATE_ARRAY_POINTER	= 0x8456,
 GL_FOG_COORDINATE_ARRAY		= 0x8457,
 GL_COLOR_SUM			= 0x8458,
 GL_CURRENT_SECONDARY_COLOR		= 0x8459,
 GL_SECONDARY_COLOR_ARRAY_SIZE	= 0x845A,
 GL_SECONDARY_COLOR_ARRAY_TYPE	= 0x845B,
 GL_SECONDARY_COLOR_ARRAY_STRIDE	= 0x845C,
 GL_SECONDARY_COLOR_ARRAY_POINTER	= 0x845D,
 GL_SECONDARY_COLOR_ARRAY		= 0x845E,
 GL_MAX_TEXTURE_LOD_BIAS		= 0x84FD,
 GL_TEXTURE_FILTER_CONTROL		= 0x8500,
 GL_TEXTURE_LOD_BIAS		= 0x8501,
 GL_INCR_WRAP			= 0x8507,
 GL_DECR_WRAP			= 0x8508,
 GL_TEXTURE_DEPTH_SIZE		= 0x884A,
 GL_DEPTH_TEXTURE_MODE		= 0x884B,
 GL_TEXTURE_COMPARE_MODE		= 0x884C,
 GL_TEXTURE_COMPARE_FUNC		= 0x884D,
 GL_COMPARE_R_TO_TEXTURE		= 0x884E,

// OpenGL 1.5
 GL_BUFFER_SIZE			= 0x8764,
 GL_BUFFER_USAGE			= 0x8765,
 GL_QUERY_COUNTER_BITS		= 0x8864,
 GL_CURRENT_QUERY			= 0x8865,
 GL_QUERY_RESULT			= 0x8866,
 GL_QUERY_RESULT_AVAILABLE		= 0x8867,
 GL_ARRAY_BUFFER			= 0x8892,
 GL_ELEMENT_ARRAY_BUFFER		= 0x8893,
 GL_ARRAY_BUFFER_BINDING		= 0x8894,
 GL_ELEMENT_ARRAY_BUFFER_BINDING	= 0x8895,
 GL_VERTEX_ARRAY_BUFFER_BINDING	= 0x8896,
 GL_NORMAL_ARRAY_BUFFER_BINDING	= 0x8897,
 GL_COLOR_ARRAY_BUFFER_BINDING	= 0x8898,
 GL_INDEX_ARRAY_BUFFER_BINDING	= 0x8899,
 GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING= 0x889A,
 GL_EDGE_FLAG_ARRAY_BUFFER_BINDING	= 0x889B,
 GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING= 0x889C,
 GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING= 0x889D,
 GL_WEIGHT_ARRAY_BUFFER_BINDING	= 0x889E,
 GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= 0x889F,
 GL_READ_ONLY			= 0x88B8,
 GL_WRITE_ONLY			= 0x88B9,
 GL_READ_WRITE			= 0x88BA,
 GL_BUFFER_ACCESS			= 0x88BB,
 GL_BUFFER_MAPPED			= 0x88BC,
 GL_BUFFER_MAP_POINTER		= 0x88BD,
 GL_STREAM_DRAW			= 0x88E0,
 GL_STREAM_READ			= 0x88E1,
 GL_STREAM_COPY			= 0x88E2,
 GL_STATIC_DRAW			= 0x88E4,
 GL_STATIC_READ			= 0x88E5,
 GL_STATIC_COPY			= 0x88E6,
 GL_DYNAMIC_DRAW			= 0x88E8,
 GL_DYNAMIC_READ			= 0x88E9,
 GL_DYNAMIC_COPY			= 0x88EA,
 GL_SAMPLES_PASSED			= 0x8914,
 GL_FOG_COORD_SRC			= GL_FOG_COORDINATE_SOURCE,
 GL_FOG_COORD			= GL_FOG_COORDINATE,
 GL_CURRENT_FOG_COORD		= GL_CURRENT_FOG_COORDINATE,
 GL_FOG_COORD_ARRAY_TYPE		= GL_FOG_COORDINATE_ARRAY_TYPE,
 GL_FOG_COORD_ARRAY_STRIDE		= GL_FOG_COORDINATE_ARRAY_STRIDE,
 GL_FOG_COORD_ARRAY_POINTER		= GL_FOG_COORDINATE_ARRAY_POINTER,
 GL_FOG_COORD_ARRAY			= GL_FOG_COORDINATE_ARRAY,
 GL_FOG_COORD_ARRAY_BUFFER_BINDING	= GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING,
 GL_SRC0_RGB			= GL_SOURCE0_RGB,
 GL_SRC1_RGB			= GL_SOURCE1_RGB,
 GL_SRC2_RGB			= GL_SOURCE2_RGB,
 GL_SRC0_ALPHA			= GL_SOURCE0_ALPHA,
 GL_SRC1_ALPHA			= GL_SOURCE1_ALPHA,
 GL_SRC2_ALPHA			= GL_SOURCE2_ALPHA,

// OpenGL 2.0
 GL_BLEND_EQUATION_RGB		= 0x8009,
 GL_VERTEX_ATTRIB_ARRAY_ENABLED	= 0x8622,
 GL_VERTEX_ATTRIB_ARRAY_SIZE	= 0x8623,
 GL_VERTEX_ATTRIB_ARRAY_STRIDE	= 0x8624,
 GL_VERTEX_ATTRIB_ARRAY_TYPE	= 0x8625,
 GL_CURRENT_VERTEX_ATTRIB		= 0x8626,
 GL_VERTEX_PROGRAM_POINT_SIZE	= 0x8642,
 GL_VERTEX_PROGRAM_TWO_SIDE		= 0x8643,
 GL_VERTEX_ATTRIB_ARRAY_POINTER	= 0x8645,
 GL_STENCIL_BACK_FUNC		= 0x8800,
 GL_STENCIL_BACK_FAIL		= 0x8801,
 GL_STENCIL_BACK_PASS_DEPTH_FAIL	= 0x8802,
 GL_STENCIL_BACK_PASS_DEPTH_PASS	= 0x8803,
 GL_MAX_DRAW_BUFFERS		= 0x8824,
 GL_DRAW_BUFFER0			= 0x8825,
 GL_DRAW_BUFFER1			= 0x8826,
 GL_DRAW_BUFFER2			= 0x8827,
 GL_DRAW_BUFFER3			= 0x8828,
 GL_DRAW_BUFFER4			= 0x8829,
 GL_DRAW_BUFFER5			= 0x882A,
 GL_DRAW_BUFFER6			= 0x882B,
 GL_DRAW_BUFFER7			= 0x882C,
 GL_DRAW_BUFFER8			= 0x882D,
 GL_DRAW_BUFFER9			= 0x882E,
 GL_DRAW_BUFFER10			= 0x882F,
 GL_DRAW_BUFFER11			= 0x8830,
 GL_DRAW_BUFFER12			= 0x8831,
 GL_DRAW_BUFFER13			= 0x8832,
 GL_DRAW_BUFFER14			= 0x8833,
 GL_DRAW_BUFFER15			= 0x8834,
 GL_BLEND_EQUATION_ALPHA		= 0x883D,
 GL_POINT_SPRITE			= 0x8861,
 GL_COORD_REPLACE			= 0x8862,
 GL_MAX_VERTEX_ATTRIBS		= 0x8869,
 GL_VERTEX_ATTRIB_ARRAY_NORMALIZED	= 0x886A,
 GL_MAX_TEXTURE_COORDS		= 0x8871,
 GL_MAX_TEXTURE_IMAGE_UNITS		= 0x8872,
 GL_FRAGMENT_SHADER			= 0x8B30,
 GL_VERTEX_SHADER			= 0x8B31,
 GL_MAX_FRAGMENT_UNIFORM_COMPONENTS	= 0x8B49,
 GL_MAX_VERTEX_UNIFORM_COMPONENTS	= 0x8B4A,
 GL_MAX_VARYING_FLOATS		= 0x8B4B,
 GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS	= 0x8B4C,
 GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D,
 GL_SHADER_TYPE			= 0x8B4F,
 GL_FLOAT_VEC2			= 0x8B50,
 GL_FLOAT_VEC3			= 0x8B51,
 GL_FLOAT_VEC4			= 0x8B52,
 GL_INT_VEC2			= 0x8B53,
 GL_INT_VEC3			= 0x8B54,
 GL_INT_VEC4			= 0x8B55,
 GL_BOOL				= 0x8B56,
 GL_BOOL_VEC2			= 0x8B57,
 GL_BOOL_VEC3			= 0x8B58,
 GL_BOOL_VEC4			= 0x8B59,
 GL_FLOAT_MAT2			= 0x8B5A,
 GL_FLOAT_MAT3			= 0x8B5B,
 GL_FLOAT_MAT4			= 0x8B5C,
 GL_SAMPLER_1D			= 0x8B5D,
 GL_SAMPLER_2D			= 0x8B5E,
 GL_SAMPLER_3D			= 0x8B5F,
 GL_SAMPLER_CUBE			= 0x8B60,
 GL_SAMPLER_1D_SHADOW		= 0x8B61,
 GL_SAMPLER_2D_SHADOW		= 0x8B62,
 GL_DELETE_STATUS			= 0x8B80,
 GL_COMPILE_STATUS			= 0x8B81,
 GL_LINK_STATUS			= 0x8B82,
 GL_VALIDATE_STATUS			= 0x8B83,
 GL_INFO_LOG_LENGTH			= 0x8B84,
 GL_ATTACHED_SHADERS		= 0x8B85,
 GL_ACTIVE_UNIFORMS			= 0x8B86,
 GL_ACTIVE_UNIFORM_MAX_LENGTH	= 0x8B87,
 GL_SHADER_SOURCE_LENGTH		= 0x8B88,
 GL_ACTIVE_ATTRIBUTES		= 0x8B89,
 GL_ACTIVE_ATTRIBUTE_MAX_LENGTH	= 0x8B8A,
 GL_FRAGMENT_SHADER_DERIVATIVE_HINT	= 0x8B8B,
 GL_SHADING_LANGUAGE_VERSION	= 0x8B8C,
 GL_CURRENT_PROGRAM			= 0x8B8D,
 GL_POINT_SPRITE_COORD_ORIGIN	= 0x8CA0,
 GL_LOWER_LEFT			= 0x8CA1,
 GL_UPPER_LEFT			= 0x8CA2,
 GL_STENCIL_BACK_REF		= 0x8CA3,
 GL_STENCIL_BACK_VALUE_MASK		= 0x8CA4,
 GL_STENCIL_BACK_WRITEMASK		= 0x8CA5,

// ARB_Imaging
 GL_CONSTANT_COLOR			= 0x8001,
 GL_ONE_MINUS_CONSTANT_COLOR	= 0x8002,
 GL_CONSTANT_ALPHA			= 0x8003,
 GL_ONE_MINUS_CONSTANT_ALPHA	= 0x8004,
 GL_BLEND_COLOR			= 0x8005,
 GL_FUNC_ADD			= 0x8006,
 GL_MIN				= 0x8007,
 GL_MAX				= 0x8008,
 GL_BLEND_EQUATION			= 0x8009,
 GL_FUNC_SUBTRACT			= 0x800A,
 GL_FUNC_REVERSE_SUBTRACT		= 0x800B,
 GL_CONVOLUTION_1D			= 0x8010,
 GL_CONVOLUTION_2D			= 0x8011,
 GL_SEPARABLE_2D			= 0x8012,
 GL_CONVOLUTION_BORDER_MODE		= 0x8013,
 GL_CONVOLUTION_FILTER_SCALE	= 0x8014,
 GL_CONVOLUTION_FILTER_BIAS		= 0x8015,
 GL_REDUCE				= 0x8016,
 GL_CONVOLUTION_FORMAT		= 0x8017,
 GL_CONVOLUTION_WIDTH		= 0x8018,
 GL_CONVOLUTION_HEIGHT		= 0x8019,
 GL_MAX_CONVOLUTION_WIDTH		= 0x801A,
 GL_MAX_CONVOLUTION_HEIGHT		= 0x801B,
 GL_POST_CONVOLUTION_RED_SCALE	= 0x801C,
 GL_POST_CONVOLUTION_GREEN_SCALE	= 0x801D,
 GL_POST_CONVOLUTION_BLUE_SCALE	= 0x801E,
 GL_POST_CONVOLUTION_ALPHA_SCALE	= 0x801F,
 GL_POST_CONVOLUTION_RED_BIAS	= 0x8020,
 GL_POST_CONVOLUTION_GREEN_BIAS	= 0x8021,
 GL_POST_CONVOLUTION_BLUE_BIAS	= 0x8022,
 GL_POST_CONVOLUTION_ALPHA_BIAS	= 0x8023,
 GL_HISTOGRAM			= 0x8024,
 GL_PROXY_HISTOGRAM			= 0x8025,
 GL_HISTOGRAM_WIDTH			= 0x8026,
 GL_HISTOGRAM_FORMAT		= 0x8027,
 GL_HISTOGRAM_RED_SIZE		= 0x8028,
 GL_HISTOGRAM_GREEN_SIZE		= 0x8029,
 GL_HISTOGRAM_BLUE_SIZE		= 0x802A,
 GL_HISTOGRAM_ALPHA_SIZE		= 0x802B,
 GL_HISTOGRAM_LUMINANCE_SIZE	= 0x802C,
 GL_HISTOGRAM_SINK			= 0x802D,
 GL_MINMAX				= 0x802E,
 GL_MINMAX_FORMAT			= 0x802F,
 GL_MINMAX_SINK			= 0x8030,
 GL_TABLE_TOO_LARGE			= 0x8031,
 GL_COLOR_MATRIX			= 0x80B1,
 GL_COLOR_MATRIX_STACK_DEPTH	= 0x80B2,
 GL_MAX_COLOR_MATRIX_STACK_DEPTH	= 0x80B3,
 GL_POST_COLOR_MATRIX_RED_SCALE	= 0x80B4,
 GL_POST_COLOR_MATRIX_GREEN_SCALE	= 0x80B5,
 GL_POST_COLOR_MATRIX_BLUE_SCALE	= 0x80B6,
 GL_POST_COLOR_MATRIX_ALPHA_SCALE	= 0x80B7,
 GL_POST_COLOR_MATRIX_RED_BIAS	= 0x80B8,
 GL_POST_COLOR_MATRIX_GREEN_BIAS	= 0x80B9,
 GL_POST_COLOR_MATRIX_BLUE_BIAS	= 0x80BA,
 GL_POST_COLOR_MATRIX_ALPHA_BIAS	= 0x80BB,
 GL_COLOR_TABLE			= 0x80D0,
 GL_POST_CONVOLUTION_COLOR_TABLE	= 0x80D1,
 GL_POST_COLOR_MATRIX_COLOR_TABLE	= 0x80D2,
 GL_PROXY_COLOR_TABLE		= 0x80D3,
 GL_PROXY_POST_CONVOLUTION_COLOR_TABLE= 0x80D4,
 GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE= 0x80D5,
 GL_COLOR_TABLE_SCALE		= 0x80D6,
 GL_COLOR_TABLE_BIAS		= 0x80D7,
 GL_COLOR_TABLE_FORMAT		= 0x80D8,
 GL_COLOR_TABLE_WIDTH		= 0x80D9,
 GL_COLOR_TABLE_RED_SIZE		= 0x80DA,
 GL_COLOR_TABLE_GREEN_SIZE		= 0x80DB,
 GL_COLOR_TABLE_BLUE_SIZE		= 0x80DC,
 GL_COLOR_TABLE_ALPHA_SIZE		= 0x80DD,
 GL_COLOR_TABLE_LUMINANCE_SIZE	= 0x80DE,
 GL_COLOR_TABLE_INTENSITY_SIZE	= 0x80DF,
 GL_CONSTANT_BORDER			= 0x8151,
 GL_REPLICATE_BORDER		= 0x8153,
 GL_CONVOLUTION_BORDER_COLOR	= 0x8154,

//glu

//==============================================================================
// CONSTANTS
//==============================================================================
// StringName
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

struct GLUnurbs { }
alias GLUnurbs Нурб;
struct GLUquadric { }
alias GLUquadric Квадр;
struct GLUtesselator { }
alias GLUtesselator Тесс;

alias GLUnurbs GLUnurbsObj;
alias GLUquadric GLUquadricObj;
alias GLUtesselator GLUtesselatorObj;
alias GLUtesselator GLUtriangulatorObj;

//==============================================================================
//==============================================================================
	/////glut

enum: бцел
{
/*
 * The freeglut and GLUT API versions
 */
FREEGLUT				= 1,
GLUT_API_VERSION			= 4,
FREEGLUT_VERSION_2_0		= 1,
GLUT_XLIB_IMPLEMENTATION		= 13,

/*
 * GLUT API: коды специальных клавиш
 */
КЛ_Ф1			= 0x0001,
КЛ_Ф2			= 0x0002,
КЛ_Ф3			= 0x0003,
КЛ_Ф4			= 0x0004,
КЛ_Ф5			= 0x0005,
КЛ_Ф6			= 0x0006,
КЛ_Ф7			= 0x0007,
КЛ_Ф8			= 0x0008,
КЛ_Ф9			= 0x0009,
КЛ_Ф10			= 0x000A,
КЛ_Ф11			= 0x000B,
КЛ_Ф12			= 0x000C,
КЛ_ЛЕВАЯ			= 0x0064,
КЛ_ВВЕРХУ			= 0x0065,
КЛ_ПРАВАЯ			= 0x0066,
КЛ_ВНИЗУ			= 0x0067,
КЛ_СТР_ВВЕРХ			= 0x0068,
КЛ_СТР_ВНИЗ			= 0x0069,
КЛ_ДОМ			= 0x006A,
КЛ_КОНЕЦ			= 0x006B,
КЛ_ВСТАВИТЬ		= 0x006C,

/*
 * GLUT API: определения состояний мыши
 */

МЫШЬ_ЛЕВАЯ			= 0x0000,
МЫШЬ_СРЕДНЯЯ			= 0x0001,
МЫШЬ_ПРАВАЯ			= 0x0002,
МЫШЬ_ВНИЗУ				= 0x0000,
МЫШЬ_ВВЕРХУ				= 0x0001,
МЫШЬ_ВЫШЛА				= 0x0000,
МЫШЬ_ВОШЛА			= 0x0001,

/*
 * GLUT API macro definitions -- the display mode definitions
 */
GLUT_RGB				= 0x0000,
GLUT_RGBA				= 0x0000,
GLUT_INDEX				= 0x0001,
GLUT_SINGLE			= 0x0000,
GLUT_DOUBLE			= 0x0002,
GLUT_ACCUM				= 0x0004,
GLUT_ALPHA				= 0x0008,
GLUT_DEPTH				= 0x0010,
GLUT_STENCIL			= 0x0020,
GLUT_MULTISAMPLE			= 0x0080,
GLUT_STEREO			= 0x0100,
GLUT_LUMINANCE			= 0x0200,

/*
 * GLUT API macro definitions -- windows and menu related definitions
 */
GLUT_MENU_NOT_IN_USE		= 0x0000,
GLUT_MENU_IN_USE			= 0x0001,
GLUT_NOT_VISIBLE			= 0x0000,
GLUT_VISIBLE			= 0x0001,
GLUT_HIDDEN			= 0x0000,
GLUT_FULLY_RETAINED		= 0x0001,
GLUT_PARTIALLY_RETAINED		= 0x0002,
GLUT_FULLY_COVERED			= 0x0003,
}
/*
 * GLUT API macro definitions
 * Steve Baker suggested to make it binary compatible with GLUT:
 */
version (Windows) {
	const ук GLUT_STROKE_ROMAN		= cast(ук)0x0000;
	const ук GLUT_STROKE_MONO_ROMAN	= cast(ук)0x0001;
	const ук GLUT_BITMAP_9_BY_15	= cast(ук)0x0002;
	const ук GLUT_BITMAP_8_BY_13	= cast(ук)0x0003;
	const ук GLUT_BITMAP_TIMES_ROMAN_10= cast(ук)0x0004;
	const ук GLUT_BITMAP_TIMES_ROMAN_24= cast(ук)0x0005;
	const ук GLUT_BITMAP_HELVETICA_10	= cast(ук)0x0006;
	const ук GLUT_BITMAP_HELVETICA_12	= cast(ук)0x0007;
	const ук GLUT_BITMAP_HELVETICA_18	= cast(ук)0x0008;

}

enum: бцел
{
// GLUT API macro definitions -- the glutGet parameters
GLUT_WINDOW_X			= 0x0064,
GLUT_WINDOW_Y			= 0x0065,
GLUT_WINDOW_WIDTH			= 0x0066,
GLUT_WINDOW_HEIGHT			= 0x0067,
GLUT_WINDOW_BUFFER_SIZE		= 0x0068,
GLUT_WINDOW_STENCIL_SIZE		= 0x0069,
GLUT_WINDOW_DEPTH_SIZE		= 0x006A,
GLUT_WINDOW_RED_SIZE		= 0x006B,
GLUT_WINDOW_GREEN_SIZE		= 0x006C,
GLUT_WINDOW_BLUE_SIZE		= 0x006D,
GLUT_WINDOW_ALPHA_SIZE		= 0x006E,
GLUT_WINDOW_ACCUM_RED_SIZE		= 0x006F,
GLUT_WINDOW_ACCUM_GREEN_SIZE	= 0x0070,
GLUT_WINDOW_ACCUM_BLUE_SIZE	= 0x0071,
GLUT_WINDOW_ACCUM_ALPHA_SIZE	= 0x0072,
GLUT_WINDOW_DOUBLEBUFFER		= 0x0073,
GLUT_WINDOW_RGBA			= 0x0074,
GLUT_WINDOW_PARENT			= 0x0075,
GLUT_WINDOW_NUM_CHILDREN		= 0x0076,
GLUT_WINDOW_COLORMAP_SIZE		= 0x0077,
GLUT_WINDOW_NUM_SAMPLES		= 0x0078,
GLUT_WINDOW_STEREO			= 0x0079,
GLUT_WINDOW_CURSOR			= 0x007A,

GLUT_SCREEN_WIDTH			= 0x00C8,
GLUT_SCREEN_HEIGHT			= 0x00C9,
GLUT_SCREEN_WIDTH_MM		= 0x00CA,
GLUT_SCREEN_HEIGHT_MM		= 0x00CB,
GLUT_MENU_NUM_ITEMS		= 0x012C,
GLUT_DISPLAY_MODE_POSSIBLE		= 0x0190,
GLUT_INIT_WINDOW_X			= 0x01F4,
GLUT_INIT_WINDOW_Y			= 0x01F5,
GLUT_INIT_WINDOW_WIDTH		= 0x01F6,
GLUT_INIT_WINDOW_HEIGHT		= 0x01F7,
GLUT_INIT_DISPLAY_MODE		= 0x01F8,
GLUT_ELAPSED_TIME			= 0x02BC,
GLUT_WINDOW_FORMAT_ID		= 0x007B,
GLUT_INIT_STATE			= 0x007C,

// GLUT API macro definitions -- the glutDeviceGet parameters
GLUT_HAS_KEYBOARD			= 0x0258,
GLUT_HAS_MOUSE			= 0x0259,
GLUT_HAS_SPACEBALL			= 0x025A,
GLUT_HAS_DIAL_AND_BUTTON_BOX	= 0x025B,
GLUT_HAS_TABLET			= 0x025C,
GLUT_NUM_MOUSE_BUTTONS		= 0x025D,
GLUT_NUM_SPACEBALL_BUTTONS		= 0x025E,
GLUT_NUM_BUTTON_BOX_BUTTONS	= 0x025F,
GLUT_NUM_DIALS			= 0x0260,
GLUT_NUM_TABLET_BUTTONS		= 0x0261,
GLUT_DEVICE_IGNORE_KEY_REPEAT	= 0x0262,
GLUT_DEVICE_KEY_REPEAT		= 0x0263,
GLUT_HAS_JOYSTICK			= 0x0264,
GLUT_OWNS_JOYSTICK			= 0x0265,
GLUT_JOYSTICK_BUTTONS		= 0x0266,
GLUT_JOYSTICK_AXES			= 0x0267,
GLUT_JOYSTICK_POLL_RATE		= 0x0268,

// GLUT API macro definitions -- the glutLayerGet parameters
GLUT_OVERLAY_POSSIBLE		= 0x0320,
GLUT_LAYER_IN_USE			= 0x0321,
GLUT_HAS_OVERLAY			= 0x0322,
GLUT_TRANSPARENT_INDEX		= 0x0323,
GLUT_NORMAL_DAMAGED		= 0x0324,
GLUT_OVERLAY_DAMAGED		= 0x0325,

// GLUT API macro definitions -- the glutVideoResizeGet parameters
GLUT_VIDEO_RESIZE_POSSIBLE		= 0x0384,
GLUT_VIDEO_RESIZE_IN_USE		= 0x0385,
GLUT_VIDEO_RESIZE_X_DELTA		= 0x0386,
GLUT_VIDEO_RESIZE_Y_DELTA		= 0x0387,
GLUT_VIDEO_RESIZE_WIDTH_DELTA	= 0x0388,
GLUT_VIDEO_RESIZE_HEIGHT_DELTA	= 0x0389,
GLUT_VIDEO_RESIZE_X		= 0x038A,
GLUT_VIDEO_RESIZE_Y		= 0x038B,
GLUT_VIDEO_RESIZE_WIDTH		= 0x038C,
GLUT_VIDEO_RESIZE_HEIGHT		= 0x038D,

// GLUT API macro definitions -- the glutUseLayer parameters
GLUT_NORMAL			= 0x0000,
GLUT_OVERLAY			= 0x0001,

// GLUT API macro definitions -- the glutGetModifiers parameters
GLUT_ACTIVE_ШИФТ			= 0x0001,
GLUT_ACTIVE_CTRL			= 0x0002,
GLUT_ACTIVE_ALT			= 0x0004,

// GLUT API macro definitions -- the glutSetCursor parameters
GLUT_CURSOR_RIGHT_ARROW		= 0x0000,
GLUT_CURSOR_LEFT_ARROW		= 0x0001,
GLUT_CURSOR_INFO			= 0x0002,
GLUT_CURSOR_DESTROY		= 0x0003,
GLUT_CURSOR_HELP			= 0x0004,
GLUT_CURSOR_CYCLE			= 0x0005,
GLUT_CURSOR_SPRAY			= 0x0006,
GLUT_CURSOR_WAIT			= 0x0007,
GLUT_CURSOR_TEXT			= 0x0008,
GLUT_CURSOR_CROSSHAIR		= 0x0009,
GLUT_CURSOR_UP_DOWN		= 0x000A,
GLUT_CURSOR_LEFT_RIGHT		= 0x000B,
GLUT_CURSOR_TOP_SIDE		= 0x000C,
GLUT_CURSOR_BOTTOM_SIDE		= 0x000D,
GLUT_CURSOR_LEFT_SIDE		= 0x000E,
GLUT_CURSOR_RIGHT_SIDE		= 0x000F,
GLUT_CURSOR_TOP_LEFT_CORNER	= 0x0010,
GLUT_CURSOR_TOP_RIGHT_CORNER	= 0x0011,
GLUT_CURSOR_BOTTOM_RIGHT_CORNER	= 0x0012,
GLUT_CURSOR_BOTTOM_LEFT_CORNER	= 0x0013,
GLUT_CURSOR_INHERIT		= 0x0064,
GLUT_CURSOR_NONE			= 0x0065,
GLUT_CURSOR_FULL_CROSSHAIR		= 0x0066,

// GLUT API macro definitions -- RGB color component specification definitions
GLUT_RED				= 0x0000,
GLUT_GREEN				= 0x0001,
GLUT_BLUE				= 0x0002,

// GLUT API macro definitions -- additional keyboard and joystick definitions
КЛ_REPEAT_OFF		= 0x0000,
КЛ_REPEAT_ON			= 0x0001,
КЛ_REPEAT_DEFAULT		= 0x0002,

GLUT_JOYSTICK_BUTTON_A		= 0x0001,
GLUT_JOYSTICK_BUTTON_B		= 0x0002,
GLUT_JOYSTICK_BUTTON_C		= 0x0004,
GLUT_JOYSTICK_BUTTON_D		= 0x0008,

// GLUT API macro definitions -- game mode definitions
GLUT_GAME_MODE_ACTIVE		= 0x0000,
GLUT_GAME_MODE_POSSIBLE		= 0x0001,
GLUT_GAME_MODE_WIDTH		= 0x0002,
GLUT_GAME_MODE_HEIGHT		= 0x0003,
GLUT_GAME_MODE_PIXEL_DEPTH		= 0x0004,
GLUT_GAME_MODE_REFRESH_RATE	= 0x0005,
GLUT_GAME_MODE_DISPLAY_CHANGED	= 0x0006,

// FreeGlut extra definitions

}
version(FREEGLUT_EXTRAS)
 {
 
 enum: бцел
	{
	/*
	 * GLUT API Extension macro definitions -- behaviour when the user clicks on an "x" to close a window
	 */
	GLUT_ACTION_EXIT		= 0,
	GLUT_ACTION_GLUTMAINLOOP_RETURNS= 1,
	GLUT_ACTION_CONTINUE_EXECUTION= 2,

	/*
	 * Create a new rendering context when the user opens a new window?
	 */
	GLUT_CREATE_NEW_CONTEXT	= 0,
	GLUT_USE_CURRENT_CONTEXT	= 1,

	/*
	 * Direct/Indirect rendering context options (has meaning only in Unix/X11)
	 */
	GLUT_FORCE_INDIRECT_CONTEXT= 0,
	GLUT_ALLOW_DIRECT_CONTEXT	= 1,
	GLUT_TRY_DIRECT_CONTEXT	= 2,
	GLUT_FORCE_DIRECT_CONTEXT	= 3,

	/*
	 * GLUT API Extension macro definitions -- the glutGet parameters
	 */
	GLUT_ACTION_ON_WINDOW_CLOSE= 0x01F9,
	GLUT_WINDOW_BORDER_WIDTH	= 0x01FA,
	GLUT_WINDOW_HEADER_HEIGHT	= 0x01FB,
	GLUT_VERSION		= 0x01FC,
	GLUT_RENDERING_CONTEXT	= 0x01FD,
	GLUT_DIRECT_RENDERING	= 0x01FE,

	/*
	 * New tokens for glutInitDisplayMode.
	 * Only one GLUT_AUXn bit may be used at a time.
	 * Value 0x0400 is defined in OpenGLUT.
	 */
	GLUT_AUX1			= 0x1000,
	GLUT_AUX2			= 0x2000,
	GLUT_AUX3			= 0x4000,
	GLUT_AUX4			= 0x8000,
	}


}

	проц грузиГлут(Биб биб)
	{

	
		//вяжи(функция_1)("____glutGetFCB@4", биб);

		//вяжи(функция_2)("____glutSetFCB@8", биб);

		//вяжи(функция_3)("___glutCreateMenuWithExit", биб);

		//вяжи(функция_4)("___glutCreateWindowWithExit", биб);

		//вяжи(функция_5)("___glutInitWithExit", биб);

		//вяжи(функция_6)("__glutGetProcAddress@4", биб);

		//вяжи(функция_7)("_glutAddMenuEntry", биб);

		//вяжи(функция_8)("_glutAddSubMenu", биб);

		//вяжи(функция_9)("_glutAttachMenu", биб);

		//вяжи(функция_10)("_glutBitmap9By15", биб);

		//вяжи(функция_11)("_glutBitmapCharacter", биб);

		//вяжи(функция_12)("_glutBitmapHelvetica10", биб);

		//вяжи(функция_13)("_glutBitmapHelvetica18", биб);

		//вяжи(функция_14)("_glutBitmapLength", биб);

		//вяжи(функция_15)("_glutBitmapTimesRoman24", биб);

		//вяжи(функция_16)("_glutBitmapWidth", биб);

		//вяжи(функция_17)("_glutButtonBoxFunc", биб);

		//вяжи(функция_18)("_glutChangeToMenuEntry", биб);

		//вяжи(функция_19)("_glutChangeToSubMenu", биб);

		//вяжи(функция_20)("_glutCopyColormap", биб);

		//вяжи(функция_21)("_glutCreateMenu", биб);

		вяжи(глутСоздайПодокно)("glutCreateSubWindow", биб);
		вяжи(глутСоздайОкно)("glutCreateWindow", биб);
		вяжи(глутРазрушьМеню)("glutDestroyMenu", биб);
		вяжи(глутРазрушьОкно)("glutDestroyWindow", биб);

		//вяжи(функция_26)("_glutDetachMenu", биб);

		//вяжи(функция_27)("_glutDeviceGet", биб);

		//вяжи(функция_28)("_glutDialsFunc", биб);

		вяжи(глутФункцПоказа)("glutDisplayFunc", биб);

		//вяжи(функция_30)("_glutEnterGameMode", биб);

		//вяжи(функция_31)("_glutEntryFunc", биб);

		//вяжи(функция_32)("_glutEstablishOverlay", биб);

		//вяжи(функция_33)("_glutExtensionSupported", биб);

		//вяжи(функция_34)("_glutForceJoystickFunc", биб);

		//вяжи(функция_35)("_glutFullScreen", биб);

		//вяжи(функция_36)("_glutGameModeGet", биб);

		//вяжи(функция_37)("_glutGameModeString", биб);

		//вяжи(функция_38)("_glutGet", биб);

		//вяжи(функция_39)("_glutGetColor", биб);

		//вяжи(функция_40)("_glutGetMenu", биб);

		//вяжи(функция_41)("_glutGetModifiers", биб);

		//вяжи(функция_42)("_glutGetWindow", биб);

		//вяжи(функция_43)("_glutHideOverlay", биб);

		//вяжи(функция_44)("_glutHideWindow", биб);

		//вяжи(функция_45)("_glutIconifyWindow", биб);

		//вяжи(функция_46)("_glutIdleFunc", биб);

		//вяжи(функция_47)("_glutIgnoreKeyRepeat", биб);

		вяжи(глутИниц)("glutInit", биб);
		вяжи(глутИницРежимПоказа)("glutInitDisplayMode", биб);
		вяжи(глутИницТекстОкна)("glutInitDisplayString", биб);
		вяжи(глутИницПозОкна)("glutInitWindowPosition", биб);
		вяжи(глутИницРазмерОкна)("glutInitWindowSize", биб);

		//вяжи(функция_53)("_glutJoystickFunc", биб);

		вяжи(глутФункцКлавиатуры)("glutKeyboardFunc", биб);

		//вяжи(функция_55)("_glutKeyboardUpFunc", биб);

		//вяжи(функция_56)("_glutLayerGet", биб);

		//вяжи(функция_57)("_glutLeaveGameMode", биб);

		вяжи(глутГлавныйЦикл)("glutMainLoop", биб);

		//вяжи(функция_59)("_glutMenuStateFunc", биб);

		//вяжи(функция_60)("_glutMenuStatusFunc", биб);

		//вяжи(функция_61)("_glutMotionFunc", биб);

		//вяжи(функция_62)("_glutMouseFunc", биб);

		//вяжи(функция_63)("_glutOverlayDisplayFunc", биб);

		//вяжи(функция_64)("_glutPassiveMotionFunc", биб);

		//вяжи(функция_65)("_glutPopWindow", биб);

		//вяжи(функция_66)("_glutPositionWindow", биб);

		//вяжи(функция_67)("_glutPostOverlayRedisplay", биб);

		вяжи(глутПерепоказ)("glutPostRedisplay", биб);

		//вяжи(функция_69)("_glutPostWindowOverlayRedisplay", биб);

		//вяжи(функция_70)("_glutPostWindowRedisplay", биб);

		//вяжи(функция_71)("_glutPushWindow", биб);

		//вяжи(функция_72)("_glutRemoveMenuItem", биб);

		//вяжи(функция_73)("_glutRemoveOverlay", биб);

		//вяжи(функция_74)("_glutReportErrors", биб);

		вяжи(глутФункцПерерисовки)("glutReshapeFunc", биб);

		//вяжи(функция_76)("_glutReshapeWindow", биб);

		вяжи(глутУстановиЦвет)("glutSetColor", биб);

		//вяжи(функция_78)("_glutSetCursor", биб);

		//вяжи(функция_79)("_glutSetIconTitle", биб);

		//вяжи(функция_80)("_glutSetKeyRepeat", биб);

		//вяжи(функция_81)("_glutSetMenu", биб);

		//вяжи(функция_82)("_glutSetupVideoResizing", биб);

		//вяжи(функция_83)("_glutSetWindow", биб);

		//вяжи(функция_84)("_glutSetWindowTitle", биб);

		//вяжи(функция_85)("_glutShowOverlay", биб);

		//вяжи(функция_86)("_glutShowWindow", биб);

		//вяжи(функция_87)("_glutSolidCone", биб);

		//вяжи(функция_88)("_glutSolidCube", биб);

		//вяжи(функция_89)("_glutSolidDodecahedron", биб);

		//вяжи(функция_90)("_glutSolidIcosahedron", биб);

		//вяжи(функция_91)("_glutSolidOctahedron", биб);

		//вяжи(функция_92)("_glutSolidSphere", биб);

		//вяжи(функция_93)("_glutSolidTeapot", биб);

		//вяжи(функция_94)("_glutSolidTetrahedron", биб);

		//вяжи(функция_95)("_glutSolidTorus", биб);

		//вяжи(функция_96)("_glutSpaceballButtonFunc", биб);

		//вяжи(функция_97)("_glutSpaceballMotionFunc", биб);

		//вяжи(функция_98)("_glutSpaceballRotateFunc", биб);

		//вяжи(функция_99)("_glutSpecialFunc", биб);

		//вяжи(функция_100)("_glutSpecialUpFunc", биб);

		//вяжи(функция_101)("_glutStopVideoResizing", биб);

		//вяжи(функция_102)("_glutStrokeCharacter", биб);

		//вяжи(функция_103)("_glutStrokeLength", биб);

		//вяжи(функция_104)("_glutStrokeRoman", биб);

		//вяжи(функция_105)("_glutStrokeWidth", биб);

		//вяжи(функция_106)("_glutSwapBuffers", биб);

		//вяжи(функция_107)("_glutTabletButtonFunc", биб);

		//вяжи(функция_108)("_glutTabletMotionFunc", биб);

		//вяжи(функция_109)("_glutTimerFunc", биб);

		//вяжи(функция_110)("_glutUseLayer", биб);

		//вяжи(функция_111)("_glutVideoPan", биб);

		//вяжи(функция_112)("_glutVideoResize", биб);

		//вяжи(функция_113)("_glutVideoResizeGet", биб);

		//вяжи(функция_114)("_glutVisibilityFunc", биб);

		//вяжи(функция_115)("_glutWarpPointer", биб);

		//вяжи(функция_116)("_glutWindowStatusFunc", биб);

		//вяжи(функция_117)("_glutWireCone", биб);

		//вяжи(функция_118)("_glutWireCube", биб);

		//вяжи(функция_119)("_glutWireDodecahedron", биб);

		//вяжи(функция_120)("_glutWireIcosahedron", биб);

		//вяжи(функция_121)("_glutWireOctahedron", биб);

		//вяжи(функция_122)("_glutWireSphere", биб);

		//вяжи(функция_123)("_glutWireTeapot", биб);

		//вяжи(функция_124)("_glutWireTetrahedron", биб);

		//вяжи(функция_125)("_glutWireTorus", биб);

		//вяжи(функция_126)("____glutSetFCB@8", биб);

		//вяжи(функция_127)("___glutCreateMenuWithExit", биб);

		//вяжи(функция_128)("___glutCreateWindowWithExit", биб);

		//вяжи(функция_129)("___glutInitWithExit", биб);

		//вяжи(функция_130)("__glutGetProcAddress@4", биб);

		//вяжи(функция_131)("_glutAddMenuEntry", биб);

		//вяжи(функция_132)("_glutAddSubMenu", биб);

		//вяжи(функция_133)("_glutAttachMenu", биб);

		//вяжи(функция_134)("_glutBitmap9By15", биб);

		//вяжи(функция_135)("_glutBitmapCharacter", биб);

		//вяжи(функция_136)("_glutBitmapHelvetica10", биб);

		//вяжи(функция_137)("_glutBitmapHelvetica18", биб);

		//вяжи(функция_138)("_glutBitmapLength", биб);

		//вяжи(функция_139)("_glutBitmapTimesRoman24", биб);

		//вяжи(функция_140)("_glutBitmapWidth", биб);

		//вяжи(функция_141)("_glutButtonBoxFunc", биб);

		//вяжи(функция_142)("_glutChangeToMenuEntry", биб);

		//вяжи(функция_143)("_glutChangeToSubMenu", биб);

		//вяжи(функция_144)("_glutCopyColormap", биб);

		//вяжи(функция_145)("_glutCreateMenu", биб);

		//вяжи(функция_146)("_glutCreateSubWindow", биб);

		//вяжи(глутСоздайОкно)("glutCreateWindow", биб);

		//вяжи(функция_148)("_glutDestroyMenu", биб);

		//вяжи(функция_149)("_glutDestroyWindow", биб);

		//вяжи(функция_150)("_glutDetachMenu", биб);

		//вяжи(функция_151)("_glutDeviceGet", биб);

		//вяжи(функция_152)("_glutDialsFunc", биб);

		//вяжи(функция_153)("_glutDisplayFunc", биб);

		//вяжи(функция_154)("_glutEnterGameMode", биб);

		//вяжи(функция_155)("_glutEntryFunc", биб);

		//вяжи(функция_156)("_glutEstablishOverlay", биб);

		//вяжи(функция_157)("_glutExtensionSupported", биб);

		//вяжи(функция_158)("_glutForceJoystickFunc", биб);

		//вяжи(функция_159)("_glutFullScreen", биб);

		//вяжи(функция_160)("_glutGameModeGet", биб);

		//вяжи(функция_161)("_glutGameModeString", биб);

		//вяжи(функция_162)("_glutGet", биб);

		//вяжи(функция_163)("_glutGetColor", биб);

		//вяжи(функция_164)("_glutGetMenu", биб);

		//вяжи(функция_165)("_glutGetModifiers", биб);

		//вяжи(функция_166)("_glutGetWindow", биб);

		//вяжи(функция_167)("_glutHideOverlay", биб);

		//вяжи(функция_168)("_glutHideWindow", биб);

		//вяжи(функция_169)("_glutIconifyWindow", биб);

		//вяжи(функция_170)("_glutIdleFunc", биб);

		//вяжи(функция_171)("_glutIgnoreKeyRepeat", биб);

		//вяжи(функция_172)("_glutInit", биб);

		//вяжи(функция_173)("_glutInitDisplayMode", биб);

		//вяжи(функция_174)("_glutInitDisplayString", биб);

		//вяжи(функция_175)("_glutInitWindowPosition", биб);

		//вяжи(функция_176)("_glutInitWindowSize", биб);

		//вяжи(функция_177)("_glutJoystickFunc", биб);

		//вяжи(функция_178)("_glutKeyboardFunc", биб);

		//вяжи(функция_179)("_glutKeyboardUpFunc", биб);

		//вяжи(функция_180)("_glutLayerGet", биб);

		//вяжи(функция_181)("_glutLeaveGameMode", биб);

		//вяжи(функция_182)("_glutMainLoop", биб);

		//вяжи(функция_183)("_glutMenuStateFunc", биб);

		//вяжи(функция_184)("_glutMenuStatusFunc", биб);

		//вяжи(функция_185)("_glutMotionFunc", биб);

		//вяжи(функция_186)("_glutMouseFunc", биб);

		//вяжи(функция_187)("_glutOverlayDisplayFunc", биб);

		//вяжи(функция_188)("_glutPassiveMotionFunc", биб);

		//вяжи(функция_189)("_glutPopWindow", биб);

		//вяжи(функция_190)("_glutPositionWindow", биб);

		//вяжи(функция_191)("_glutPostOverlayRedisplay", биб);

		//вяжи(функция_192)("_glutPostRedisplay", биб);

		//вяжи(функция_193)("_glutPostWindowOverlayRedisplay", биб);

		//вяжи(функция_194)("_glutPostWindowRedisplay", биб);

		//вяжи(функция_195)("_glutPushWindow", биб);

		//вяжи(функция_196)("_glutRemoveMenuItem", биб);

		//вяжи(функция_197)("_glutRemoveOverlay", биб);

		//вяжи(функция_198)("_glutReportErrors", биб);

		//вяжи(функция_199)("_glutReshapeFunc", биб);

		//вяжи(функция_200)("_glutReshapeWindow", биб);

		//вяжи(функция_201)("_glutSetColor", биб);

		//вяжи(функция_202)("_glutSetCursor", биб);

		//вяжи(функция_203)("_glutSetIconTitle", биб);

		//вяжи(функция_204)("_glutSetKeyRepeat", биб);

		//вяжи(функция_205)("_glutSetMenu", биб);

		//вяжи(функция_206)("_glutSetupVideoResizing", биб);

		//вяжи(функция_207)("_glutSetWindow", биб);

		//вяжи(функция_208)("_glutSetWindowTitle", биб);

		//вяжи(функция_209)("_glutShowOverlay", биб);

		//вяжи(функция_210)("_glutShowWindow", биб);

		//вяжи(функция_211)("_glutSolidCone", биб);

		//вяжи(функция_212)("_glutSolidCube", биб);

		//вяжи(функция_213)("_glutSolidDodecahedron", биб);

		//вяжи(функция_214)("_glutSolidIcosahedron", биб);

		//вяжи(функция_215)("_glutSolidOctahedron", биб);

		//вяжи(функция_216)("_glutSolidSphere", биб);

		//вяжи(функция_217)("_glutSolidTeapot", биб);

		//вяжи(функция_218)("_glutSolidTetrahedron", биб);

		//вяжи(функция_219)("_glutSolidTorus", биб);

		//вяжи(функция_220)("_glutSpaceballButtonFunc", биб);

		//вяжи(функция_221)("_glutSpaceballMotionFunc", биб);

		//вяжи(функция_222)("_glutSpaceballRotateFunc", биб);

		//вяжи(функция_223)("_glutSpecialFunc", биб);

		//вяжи(функция_224)("_glutSpecialUpFunc", биб);

		//вяжи(функция_225)("_glutStopVideoResizing", биб);

		//вяжи(функция_226)("_glutStrokeCharacter", биб);

		//вяжи(функция_227)("_glutStrokeLength", биб);

		//вяжи(функция_228)("_glutStrokeRoman", биб);

		//вяжи(функция_229)("_glutStrokeWidth", биб);

		//вяжи(функция_230)("_glutSwapBuffers", биб);

		//вяжи(функция_231)("_glutTabletButtonFunc", биб);

		//вяжи(функция_232)("_glutTabletMotionFunc", биб);

		//вяжи(функция_233)("_glutTimerFunc", биб);

		//вяжи(функция_234)("_glutUseLayer", биб);

		//вяжи(функция_235)("_glutVideoPan", биб);

		//вяжи(функция_236)("_glutVideoResize", биб);

		//вяжи(функция_237)("_glutVideoResizeGet", биб);

		//вяжи(функция_238)("_glutVisibilityFunc", биб);

		//вяжи(функция_239)("_glutWarpPointer", биб);

		//вяжи(функция_240)("_glutWindowStatusFunc", биб);

		//вяжи(функция_241)("_glutWireCone", биб);

		//вяжи(функция_242)("_glutWireCube", биб);

		//вяжи(функция_243)("_glutWireDodecahedron", биб);

		//вяжи(функция_244)("_glutWireIcosahedron", биб);

		//вяжи(функция_245)("_glutWireOctahedron", биб);

		//вяжи(функция_246)("_glutWireSphere", биб);

		//вяжи(функция_247)("_glutWireTeapot", биб);

	}
//=================================================================
ЖанБибгр DINRUS_GLUT;
ЖанБибгр DINRUS_GLU;
ЖанБибгр DINRUS_GL;

		static this()
		{
			DINRUS_GLUT.заряжай("Dinrus.Glut.dll", &грузиГлут );
			DINRUS_GLU.заряжай("Dinrus.Glu.dll", &грузиГлу );
			DINRUS_GL.заряжай("Dinrus.Opengl.dll", &грузиГл );
			DINRUS_GLUT.загружай();
			DINRUS_GLU.загружай();
			DINRUS_GL.загружай();
		}
		
		static ~this()
		{
			DINRUS_GLUT.выгружай();
			DINRUS_GLU.выгружай();
			DINRUS_GL.выгружай();
		}

	
//==================================================================
	extern(C)
	{


		//проц function(   ) функция_1; 

		//проц function(   ) функция_2; 

		//проц function(   ) функция_3; 

		//проц function(   ) функция_4; 

		//проц function(   ) функция_5; 

		//проц function(   ) функция_6; 

		//проц function(   ) функция_7; 

		//проц function(   ) функция_8; 

		//проц function(   ) функция_9; 

		//проц function(   ) функция_10; 

		//проц function(   ) функция_11; 

		//проц function(   ) функция_12; 

		//проц function(   ) функция_13; 

		//проц function(   ) функция_14; 

		//проц function(   ) функция_15; 

		//проц function(   ) функция_16; 

		//проц function(   ) функция_17; 

		//проц function(   ) функция_18; 

		//проц function(   ) функция_19; 

		//проц function(   ) функция_20; 

		//проц function(   ) функция_21; 

		цел function(цел а, цел б, цел в, цел г, цел д) глутСоздайПодокно; 
		цел function(сим* а) глутСоздайОкно; 
		проц function(цел а) глутРазрушьМеню; 
		проц function(цел а) глутРазрушьОкно; 

		//проц function(   ) функция_26; 

		//проц function(   ) функция_27; 

		//проц function(   ) функция_28; 

		проц function( сифунк ф ) глутФункцПоказа; 

		//проц function(   ) функция_30; 

		//проц function(   ) функция_31; 

		//проц function(   ) функция_32; 

		//проц function(   ) функция_33; 

		//проц function(   ) функция_34; 

		//проц function(   ) функция_35; 

		//проц function(   ) функция_36; 

		//проц function(   ) функция_37; 

		//проц function(   ) функция_38; 

		//проц function(   ) функция_39; 

		//проц function(   ) функция_40; 

		//проц function(   ) функция_41; 

		//проц function(   ) функция_42; 

		//проц function(   ) функция_43; 

		//проц function(   ) функция_44; 

		//проц function(   ) функция_45; 

		//проц function(   ) функция_46; 

		//проц function(   ) функция_47; 

		проц function( цел* а= пусто, сим** б = пусто ) глутИниц; 
		проц function( бцел режим ) глутИницРежимПоказа; 
		проц function( сим* а ) глутИницТекстОкна; 
		проц function( цел а, цел б ) глутИницПозОкна; 
		проц function( цел а, цел б  ) глутИницРазмерОкна; 

		//проц function(   ) функция_53; 

		проц function(сифунк_СЦЦ а) глутФункцКлавиатуры; 

		//проц function(   ) функция_55; 

		//проц function(   ) функция_56; 

		//проц function(   ) функция_57; 

		проц function() глутГлавныйЦикл; 

		//проц function(   ) функция_59; 

		//проц function(   ) функция_60; 

		//проц function(   ) функция_61; 

		//проц function(   ) функция_62; 

		//проц function(   ) функция_63; 

		//проц function(   ) функция_64; 

		//проц function(   ) функция_65; 

		//проц function(   ) функция_66; 

		//проц function(   ) функция_67; 

		проц function() глутПерепоказ; 

		//проц function(   ) функция_69; 

		//проц function(   ) функция_70; 

		//проц function(   ) функция_71; 

		//проц function(   ) функция_72; 

		//проц function(   ) функция_73; 

		//проц function(   ) функция_74; 

		проц function(сифунк_ЦЦ а) глутФункцПерерисовки; 

		//проц function(   ) функция_76; 

		проц function(цел а, плав б, плав в, плав г) глутУстановиЦвет; 

		//проц function(   ) функция_78; 

		//проц function(   ) функция_79; 

		//проц function(   ) функция_80; 

		//проц function(   ) функция_81; 

		//проц function(   ) функция_82; 

		//проц function(   ) функция_83; 

		//проц function(   ) функция_84; 

		//проц function(   ) функция_85; 

		//проц function(   ) функция_86; 

		//проц function(   ) функция_87; 

		//проц function(   ) функция_88; 

		//проц function(   ) функция_89; 

		//проц function(   ) функция_90; 

		//проц function(   ) функция_91; 

		//проц function(   ) функция_92; 

		//проц function(   ) функция_93; 

		//проц function(   ) функция_94; 

		//проц function(   ) функция_95; 

		//проц function(   ) функция_96; 

		//проц function(   ) функция_97; 

		//проц function(   ) функция_98; 

		//проц function(   ) функция_99; 

		//проц function(   ) функция_100; 

		//проц function(   ) функция_101; 

		//проц function(   ) функция_102; 

		//проц function(   ) функция_103; 

		//проц function(   ) функция_104; 

		//проц function(   ) функция_105; 

		//проц function(   ) функция_106; 

		//проц function(   ) функция_107; 

		//проц function(   ) функция_108; 

		//проц function(   ) функция_109; 

		//проц function(   ) функция_110; 

		//проц function(   ) функция_111; 

		//проц function(   ) функция_112; 

		//проц function(   ) функция_113; 

		//проц function(   ) функция_114; 

		//проц function(   ) функция_115; 

		//проц function(   ) функция_116; 

		//проц function(   ) функция_117; 

		//проц function(   ) функция_118; 

		//проц function(   ) функция_119; 

		//проц function(   ) функция_120; 

		//проц function(   ) функция_121; 

		//проц function(   ) функция_122; 

		//проц function(   ) функция_123; 

		//проц function(   ) функция_124; 

		//проц function(   ) функция_125; 

		//проц function(   ) функция_126; 

		//проц function(   ) функция_127; 

		//проц function(   ) функция_128; 

		//проц function(   ) функция_129; 

		//проц function(   ) функция_130; 

		//проц function(   ) функция_131; 

		//проц function(   ) функция_132; 

		//проц function(   ) функция_133; 

		//проц function(   ) функция_134; 

		//проц function(   ) функция_135; 

		//проц function(   ) функция_136; 

		//проц function(   ) функция_137; 

		//проц function(   ) функция_138; 

		//проц function(   ) функция_139; 

		//проц function(   ) функция_140; 

		//проц function(   ) функция_141; 

		//проц function(   ) функция_142; 

		//проц function(   ) функция_143; 

		//проц function(   ) функция_144; 

		//проц function(   ) функция_145; 

		//проц function(   ) функция_146; 

		//цел function(  сим* а ) глутСоздайОкно; 

		//проц function(   ) функция_148; 

		//проц function(   ) функция_149; 

		//проц function(   ) функция_150; 

		//проц function(   ) функция_151; 

		//проц function(   ) функция_152; 

		//проц function(   ) функция_153; 

		//проц function(   ) функция_154; 

		//проц function(   ) функция_155; 

		//проц function(   ) функция_156; 

		//проц function(   ) функция_157; 

		//проц function(   ) функция_158; 

		//проц function(   ) функция_159; 

		//проц function(   ) функция_160; 

		//проц function(   ) функция_161; 

		//проц function(   ) функция_162; 

		//проц function(   ) функция_163; 

		//проц function(   ) функция_164; 

		//проц function(   ) функция_165; 

		//проц function(   ) функция_166; 

		//проц function(   ) функция_167; 

		//проц function(   ) функция_168; 

		//проц function(   ) функция_169; 

		//проц function(   ) функция_170; 

		//проц function(   ) функция_171; 

		//проц function(   ) функция_172; 

		//проц function(   ) функция_173; 

		//проц function(   ) функция_174; 

		//проц function(   ) функция_175; 

		//проц function(   ) функция_176; 

		//проц function(   ) функция_177; 

		//проц function(   ) функция_178; 

		//проц function(   ) функция_179; 

		//проц function(   ) функция_180; 

		//проц function(   ) функция_181; 

		//проц function(   ) функция_182; 

		//проц function(   ) функция_183; 

		//проц function(   ) функция_184; 

		//проц function(   ) функция_185; 

		//проц function(   ) функция_186; 

		//проц function(   ) функция_187; 

		//проц function(   ) функция_188; 

		//проц function(   ) функция_189; 

		//проц function(   ) функция_190; 

		//проц function(   ) функция_191; 

		//проц function(   ) функция_192; 

		//проц function(   ) функция_193; 

		//проц function(   ) функция_194; 

		//проц function(   ) функция_195; 

		//проц function(   ) функция_196; 

		//проц function(   ) функция_197; 

		//проц function(   ) функция_198; 

		//проц function(   ) функция_199; 

		//проц function(   ) функция_200; 

		//проц function(   ) функция_201; 

		//проц function(   ) функция_202; 

		//проц function(   ) функция_203; 

		//проц function(   ) функция_204; 

		//проц function(   ) функция_205; 

		//проц function(   ) функция_206; 

		//проц function(   ) функция_207; 

		//проц function(   ) функция_208; 

		//проц function(   ) функция_209; 

		//проц function(   ) функция_210; 

		//проц function(   ) функция_211; 

		//проц function(   ) функция_212; 

		//проц function(   ) функция_213; 

		//проц function(   ) функция_214; 

		//проц function(   ) функция_215; 

		//проц function(   ) функция_216; 

		//проц function(   ) функция_217; 

		//проц function(   ) функция_218; 

		//проц function(   ) функция_219; 

		//проц function(   ) функция_220; 

		//проц function(   ) функция_221; 

		//проц function(   ) функция_222; 

		//проц function(   ) функция_223; 

		//проц function(   ) функция_224; 

		//проц function(   ) функция_225; 

		//проц function(   ) функция_226; 

		//проц function(   ) функция_227; 

		//проц function(   ) функция_228; 

		//проц function(   ) функция_229; 

		//проц function(   ) функция_230; 

		//проц function(   ) функция_231; 

		//проц function(   ) функция_232; 

		//проц function(   ) функция_233; 

		//проц function(   ) функция_234; 

		//проц function(   ) функция_235; 

		//проц function(   ) функция_236; 

		//проц function(   ) функция_237; 

		//проц function(   ) функция_238; 

		//проц function(   ) функция_239; 

		//проц function(   ) функция_240; 

		//проц function(   ) функция_241; 

		//проц function(   ) функция_242; 

		//проц function(   ) функция_243; 

		//проц function(   ) функция_244; 

		//проц function(   ) функция_245; 

		//проц function(   ) функция_246; 

		//проц function(   ) функция_247; 

	}
	
проц грузиГлу(Биб биб)
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

		//вяжи(функция_48)("_gluScaleImage", биб);

		вяжи(глуШар)("gluSphere", биб);
		вяжи(глуТессНачниКонтур)("gluTessBeginContour", биб);
		вяжи(глуТессНачниМногогран)("gluTessBeginPolygon", биб);
		вяжи(глуОбрвызовТесс)("gluTessCallback", биб);
		вяжи(глуТессЗавершиКонтур)("gluTessEndContour", биб);
		вяжи(глуТессЗавершиМногогран)("gluTessEndPolygon", биб);
		вяжи(глуТессНормаль)("gluTessNormal", биб);
		вяжи(глуТессСвойство)("gluTessProperty", биб);
		вяжи(глуТессВершина)("gluTessVertex", биб);

		//вяжи(функция_58)("_gluUnProject", биб);

		//вяжи(функция_59)("_gluUnProject4", биб);

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
	
	//==========================================================
проц грузиГл(Биб биб)
	{

	
		//вяжи(функция_1)("__glAlphaFragmentOp1ATI@24", биб);

		//вяжи(функция_2)("__glAlphaFragmentOp2ATI@36", биб);

		//вяжи(функция_3)("__glAlphaFragmentOp3ATI@48", биб);

		//вяжи(функция_4)("__glapi_check_multithread", биб);

		//вяжи(функция_5)("__glapi_get_context", биб);

		//вяжи(функция_6)("__glapi_get_proc_address", биб);

		//вяжи(функция_7)("__glAttachObjectARB@8", биб);

		//вяжи(функция_8)("__glAttachShader@8", биб);

		//вяжи(функция_9)("__glBeginFragmentShaderATI@0", биб);

		//вяжи(функция_10)("__glBindAttribLocation@12", биб);

		//вяжи(функция_11)("__glBindAttribLocationARB@12", биб);

		//вяжи(функция_12)("__glBindFragmentShaderATI@4", биб);

		//вяжи(функция_13)("__glBindFramebufferEXT@8", биб);

		//вяжи(функция_14)("__glBindRenderbufferEXT@8", биб);

		//вяжи(функция_15)("__glBlendEquationSeparate@8", биб);

		//вяжи(функция_16)("__glBlendFuncSeparate@16", биб);

		//вяжи(функция_17)("__glCheckFramebufferStatusEXT@4", биб);

		//вяжи(функция_18)("__glColorFragmentOp1ATI@28", биб);

		//вяжи(функция_19)("__glColorFragmentOp2ATI@40", биб);

		//вяжи(функция_20)("__glColorFragmentOp3ATI@52", биб);

		//вяжи(функция_21)("__glCompileShader@4", биб);

		//вяжи(функция_22)("__glCompileShaderARB@4", биб);

		//вяжи(функция_23)("__glCreateProgram@0", биб);

		//вяжи(функция_24)("__glCreateProgramObjectARB@0", биб);

		//вяжи(функция_25)("__glCreateShader@4", биб);

		//вяжи(функция_26)("__glCreateShaderObjectARB@4", биб);

		//вяжи(функция_27)("__glDeleteFragmentShaderATI@4", биб);

		//вяжи(функция_28)("__glDeleteFramebuffersEXT@8", биб);

		//вяжи(функция_29)("__glDeleteObjectARB@4", биб);

		//вяжи(функция_30)("__glDeleteProgram@4", биб);

		//вяжи(функция_31)("__glDeleteRenderbuffersEXT@8", биб);

		//вяжи(функция_32)("__glDeleteShader@4", биб);

		//вяжи(функция_33)("__glDetachObjectARB@8", биб);

		//вяжи(функция_34)("__glDetachShader@8", биб);

		//вяжи(функция_35)("__glDisableVertexAttribArray@4", биб);

		//вяжи(функция_36)("__glDrawBuffers@8", биб);

		//вяжи(функция_37)("__glDrawBuffersARB@8", биб);

		//вяжи(функция_38)("__glDrawBuffersATI@8", биб);

		//вяжи(функция_39)("__glEnableVertexAttribArray@4", биб);

		//вяжи(функция_40)("__glEndFragmentShaderATI@0", биб);

		//вяжи(функция_41)("__glFramebufferRenderbufferEXT@16", биб);

		//вяжи(функция_42)("__glFramebufferTexture1DEXT@20", биб);

		//вяжи(функция_43)("__glFramebufferTexture2DEXT@20", биб);

		//вяжи(функция_44)("__glFramebufferTexture3DEXT@24", биб);

		//вяжи(функция_45)("__glFramebufferTextureLayerEXT@20", биб);

		//вяжи(функция_46)("__glGenerateMipmapEXT@4", биб);

		//вяжи(функция_47)("__glGenFragmentShadersATI@4", биб);

		//вяжи(функция_48)("__glGenFramebuffersEXT@8", биб);

		//вяжи(функция_49)("__glGenRenderbuffersEXT@8", биб);

		//вяжи(функция_50)("__glGetActiveAttrib@28", биб);

		//вяжи(функция_51)("__glGetActiveAttribARB@28", биб);

		//вяжи(функция_52)("__glGetActiveUniform@28", биб);

		//вяжи(функция_53)("__glGetActiveUniformARB@28", биб);

		//вяжи(функция_54)("__glGetAttachedObjectsARB@16", биб);

		//вяжи(функция_55)("__glGetAttachedShaders@16", биб);

		//вяжи(функция_56)("__glGetAttribLocation@8", биб);

		//вяжи(функция_57)("__glGetAttribLocationARB@8", биб);

		//вяжи(функция_58)("__glGetFramebufferAttachmentParameterivEXT@16", биб);

		//вяжи(функция_59)("__glGetHandleARB@4", биб);

		//вяжи(функция_60)("__glGetInfoLogARB@16", биб);

		//вяжи(функция_61)("__glGetObjectParameterfvARB@12", биб);

		//вяжи(функция_62)("__glGetObjectParameterivARB@12", биб);

		//вяжи(функция_63)("__glGetProgramInfoLog@16", биб);

		//вяжи(функция_64)("__glGetProgramiv@12", биб);

		//вяжи(функция_65)("__glGetRenderbufferParameterivEXT@12", биб);

		//вяжи(функция_66)("__glGetShaderInfoLog@16", биб);

		//вяжи(функция_67)("__glGetShaderiv@12", биб);

		//вяжи(функция_68)("__glGetShaderSource@16", биб);

		//вяжи(функция_69)("__glGetShaderSourceARB@16", биб);

		//вяжи(функция_70)("__glGetUniformfv@12", биб);

		//вяжи(функция_71)("__glGetUniformfvARB@12", биб);

		//вяжи(функция_72)("__glGetUniformiv@12", биб);

		//вяжи(функция_73)("__glGetUniformivARB@12", биб);

		//вяжи(функция_74)("__glGetUniformLocation@8", биб);

		//вяжи(функция_75)("__glGetUniformLocationARB@8", биб);

		//вяжи(функция_76)("__glGetVertexAttribdv@12", биб);

		//вяжи(функция_77)("__glGetVertexAttribfv@12", биб);

		//вяжи(функция_78)("__glGetVertexAttribiv@12", биб);

		//вяжи(функция_79)("__glGetVertexAttribPointerv@12", биб);

		//вяжи(функция_80)("__glIsFramebufferEXT@4", биб);

		//вяжи(функция_81)("__glIsProgram@4", биб);

		//вяжи(функция_82)("__glIsRenderbufferEXT@4", биб);

		//вяжи(функция_83)("__glIsShader@4", биб);

		//вяжи(функция_84)("__glLinkProgram@4", биб);

		//вяжи(функция_85)("__glLinkProgramARB@4", биб);

		//вяжи(функция_86)("__glPassTexCoordATI@12", биб);

		//вяжи(функция_87)("__glRenderbufferStorageEXT@16", биб);

		//вяжи(функция_88)("__glSampleMapATI@12", биб);

		//вяжи(функция_89)("__glSetFragmentShaderConstantATI@8", биб);

		//вяжи(функция_90)("__glShaderSource@16", биб);

		//вяжи(функция_91)("__glShaderSourceARB@16", биб);

		//вяжи(функция_92)("__glStencilFuncSeparate@16", биб);

		//вяжи(функция_93)("__glStencilMaskSeparate@8", биб);

		//вяжи(функция_94)("__glStencilOpSeparate@16", биб);

		//вяжи(функция_95)("__glUniform1f@8", биб);

		//вяжи(функция_96)("__glUniform1fARB@8", биб);

		//вяжи(функция_97)("__glUniform1fv@12", биб);

		//вяжи(функция_98)("__glUniform1fvARB@12", биб);

		//вяжи(функция_99)("__glUniform1i@8", биб);

		//вяжи(функция_100)("__glUniform1iARB@8", биб);

		//вяжи(функция_101)("__glUniform1iv@12", биб);

		//вяжи(функция_102)("__glUniform1ivARB@12", биб);

		//вяжи(функция_103)("__glUniform2f@12", биб);

		//вяжи(функция_104)("__glUniform2fARB@12", биб);

		//вяжи(функция_105)("__glUniform2fv@12", биб);

		//вяжи(функция_106)("__glUniform2fvARB@12", биб);

		//вяжи(функция_107)("__glUniform2i@12", биб);

		//вяжи(функция_108)("__glUniform2iARB@12", биб);

		//вяжи(функция_109)("__glUniform2iv@12", биб);

		//вяжи(функция_110)("__glUniform2ivARB@12", биб);

		//вяжи(функция_111)("__glUniform3f@16", биб);

		//вяжи(функция_112)("__glUniform3fARB@16", биб);

		//вяжи(функция_113)("__glUniform3fv@12", биб);

		//вяжи(функция_114)("__glUniform3fvARB@12", биб);

		//вяжи(функция_115)("__glUniform3i@16", биб);

		//вяжи(функция_116)("__glUniform3iARB@16", биб);

		//вяжи(функция_117)("__glUniform3iv@12", биб);

		//вяжи(функция_118)("__glUniform3ivARB@12", биб);

		//вяжи(функция_119)("__glUniform4f@20", биб);

		//вяжи(функция_120)("__glUniform4fARB@20", биб);

		//вяжи(функция_121)("__glUniform4fv@12", биб);

		//вяжи(функция_122)("__glUniform4fvARB@12", биб);

		//вяжи(функция_123)("__glUniform4i@20", биб);

		//вяжи(функция_124)("__glUniform4iARB@20", биб);

		//вяжи(функция_125)("__glUniform4iv@12", биб);

		//вяжи(функция_126)("__glUniform4ivARB@12", биб);

		//вяжи(функция_127)("__glUniformMatrix2fv@16", биб);

		//вяжи(функция_128)("__glUniformMatrix2fvARB@16", биб);

		//вяжи(функция_129)("__glUniformMatrix2x3fv@16", биб);

		//вяжи(функция_130)("__glUniformMatrix2x4fv@16", биб);

		//вяжи(функция_131)("__glUniformMatrix3fv@16", биб);

		//вяжи(функция_132)("__glUniformMatrix3fvARB@16", биб);

		//вяжи(функция_133)("__glUniformMatrix3x2fv@16", биб);

		//вяжи(функция_134)("__glUniformMatrix3x4fv@16", биб);

		//вяжи(функция_135)("__glUniformMatrix4fv@16", биб);

		//вяжи(функция_136)("__glUniformMatrix4fvARB@16", биб);

		//вяжи(функция_137)("__glUniformMatrix4x2fv@16", биб);

		//вяжи(функция_138)("__glUniformMatrix4x3fv@16", биб);

		//вяжи(функция_139)("__glUseProgram@4", биб);

		//вяжи(функция_140)("__glUseProgramObjectARB@4", биб);

		//вяжи(функция_141)("__glValidateProgram@4", биб);

		//вяжи(функция_142)("__glValidateProgramARB@4", биб);

		//вяжи(функция_143)("__glVertexAttrib1d@12", биб);

		//вяжи(функция_144)("__glVertexAttrib1dv@8", биб);

		//вяжи(функция_145)("__glVertexAttrib1f@8", биб);

		//вяжи(функция_146)("__glVertexAttrib1fv@8", биб);

		//вяжи(функция_147)("__glVertexAttrib1s@8", биб);

		//вяжи(функция_148)("__glVertexAttrib1sv@8", биб);

		//вяжи(функция_149)("__glVertexAttrib2d@20", биб);

		//вяжи(функция_150)("__glVertexAttrib2dv@8", биб);

		//вяжи(функция_151)("__glVertexAttrib2f@12", биб);

		//вяжи(функция_152)("__glVertexAttrib2fv@8", биб);

		//вяжи(функция_153)("__glVertexAttrib2s@12", биб);

		//вяжи(функция_154)("__glVertexAttrib2sv@8", биб);

		//вяжи(функция_155)("__glVertexAttrib3d@28", биб);

		//вяжи(функция_156)("__glVertexAttrib3dv@8", биб);

		//вяжи(функция_157)("__glVertexAttrib3f@16", биб);

		//вяжи(функция_158)("__glVertexAttrib3fv@8", биб);

		//вяжи(функция_159)("__glVertexAttrib3s@16", биб);

		//вяжи(функция_160)("__glVertexAttrib3sv@8", биб);

		//вяжи(функция_161)("__glVertexAttrib4bv@8", биб);

		//вяжи(функция_162)("__glVertexAttrib4d@36", биб);

		//вяжи(функция_163)("__glVertexAttrib4dv@8", биб);

		//вяжи(функция_164)("__glVertexAttrib4f@20", биб);

		//вяжи(функция_165)("__glVertexAttrib4fv@8", биб);

		//вяжи(функция_166)("__glVertexAttrib4iv@8", биб);

		//вяжи(функция_167)("__glVertexAttrib4Nbv@8", биб);

		//вяжи(функция_168)("__glVertexAttrib4Niv@8", биб);

		//вяжи(функция_169)("__glVertexAttrib4Nsv@8", биб);

		//вяжи(функция_170)("__glVertexAttrib4Nub@20", биб);

		//вяжи(функция_171)("__glVertexAttrib4Nubv@8", биб);

		//вяжи(функция_172)("__glVertexAttrib4Nuiv@8", биб);

		//вяжи(функция_173)("__glVertexAttrib4Nusv@8", биб);

		//вяжи(функция_174)("__glVertexAttrib4s@20", биб);

		//вяжи(функция_175)("__glVertexAttrib4sv@8", биб);

		//вяжи(функция_176)("__glVertexAttrib4ubv@8", биб);

		//вяжи(функция_177)("__glVertexAttrib4uiv@8", биб);

		//вяжи(функция_178)("__glVertexAttrib4usv@8", биб);

		//вяжи(функция_179)("__glVertexAttribPointer@24", биб);

		//вяжи(функция_180)("__mesa_add_renderbuffer", биб);

		//вяжи(функция_181)("__mesa_add_soft_renderbuffers", биб);

		//вяжи(функция_182)("__mesa_begin_query", биб);

		//вяжи(функция_183)("__mesa_buffer_data", биб);

		//вяжи(функция_184)("__mesa_buffer_get_subdata", биб);

		//вяжи(функция_185)("__mesa_buffer_map", биб);

		//вяжи(функция_186)("__mesa_buffer_subdata", биб);

		//вяжи(функция_187)("__mesa_buffer_unmap", биб);

		//вяжи(функция_188)("__mesa_bzero", биб);

		//вяжи(функция_189)("__mesa_calloc", биб);

		//вяжи(функция_190)("__mesa_choose_tex_format", биб);

		//вяжи(функция_191)("__mesa_compressed_texture_size", биб);

		//вяжи(функция_192)("__mesa_create_framebuffer", биб);

		//вяжи(функция_193)("__mesa_create_visual", биб);

		//вяжи(функция_194)("__mesa_delete_array_object", биб);

		//вяжи(функция_195)("__mesa_delete_buffer_object", биб);

		//вяжи(функция_196)("__mesa_delete_program", биб);

		//вяжи(функция_197)("__mesa_delete_query", биб);

		//вяжи(функция_198)("__mesa_delete_texture_object", биб);

		//вяжи(функция_199)("__mesa_destroy_framebuffer", биб);

		//вяжи(функция_200)("__mesa_destroy_visual", биб);

		//вяжи(функция_201)("__mesa_enable_1_3_extensions", биб);

		//вяжи(функция_202)("__mesa_enable_1_4_extensions", биб);

		//вяжи(функция_203)("__mesa_enable_1_5_extensions", биб);

		//вяжи(функция_204)("__mesa_enable_2_0_extensions", биб);

		//вяжи(функция_205)("__mesa_enable_2_1_extensions", биб);

		//вяжи(функция_206)("__mesa_enable_sw_extensions", биб);

		//вяжи(функция_207)("__mesa_end_query", биб);

		//вяжи(функция_208)("__mesa_error", биб);

		//вяжи(функция_209)("__mesa_finish_render_texture", биб);

		//вяжи(функция_210)("__mesa_framebuffer_renderbuffer", биб);

		//вяжи(функция_211)("__mesa_free", биб);

		//вяжи(функция_212)("__mesa_free_context_data", биб);

		//вяжи(функция_213)("__mesa_free_texture_image_data", биб);

		//вяжи(функция_214)("__mesa_generate_mipmap", биб);

		//вяжи(функция_215)("__mesa_get_compressed_teximage", биб);

		//вяжи(функция_216)("__mesa_get_current_context", биб);

		//вяжи(функция_217)("__mesa_get_program_register", биб);

		//вяжи(функция_218)("__mesa_get_teximage", биб);

		//вяжи(функция_219)("__mesa_init_driver_functions", биб);

		//вяжи(функция_220)("__mesa_init_glsl_driver_functions", биб);

		//вяжи(функция_221)("__mesa_init_renderbuffer", биб);

		//вяжи(функция_222)("__mesa_initialize_context", биб);

		//вяжи(функция_223)("__mesa_make_current", биб);

		//вяжи(функция_224)("__mesa_memcpy", биб);

		//вяжи(функция_225)("__mesa_memset", биб);

		//вяжи(функция_226)("__mesa_new_array_object", биб);

		//вяжи(функция_227)("__mesa_new_buffer_object", биб);

		//вяжи(функция_228)("__mesa_new_framebuffer", биб);

		//вяжи(функция_229)("__mesa_new_program", биб);

		//вяжи(функция_230)("__mesa_new_query_object", биб);

		//вяжи(функция_231)("__mesa_new_renderbuffer", биб);

		//вяжи(функция_232)("__mesa_new_soft_renderbuffer", биб);

		//вяжи(функция_233)("__mesa_new_texture_image", биб);

		//вяжи(функция_234)("__mesa_new_texture_object", биб);

		//вяжи(функция_235)("__mesa_problem", биб);

		//вяжи(функция_236)("__mesa_reference_renderbuffer", биб);

		//вяжи(функция_237)("__mesa_remove_renderbuffer", биб);

		//вяжи(функция_238)("__mesa_render_texture", биб);

		//вяжи(функция_239)("__mesa_resize_framebuffer", биб);

		//вяжи(функция_240)("__mesa_ResizeBuffersMESA", биб);

		//вяжи(функция_241)("__mesa_store_compressed_teximage1d", биб);

		//вяжи(функция_242)("__mesa_store_compressed_teximage2d", биб);

		//вяжи(функция_243)("__mesa_store_compressed_teximage3d", биб);

		//вяжи(функция_244)("__mesa_store_compressed_texsubimage1d", биб);

		//вяжи(функция_245)("__mesa_store_compressed_texsubimage2d", биб);

		//вяжи(функция_246)("__mesa_store_compressed_texsubimage3d", биб);

		//вяжи(функция_247)("__mesa_store_teximage1d", биб);

		//вяжи(функция_248)("__mesa_store_teximage2d", биб);

		//вяжи(функция_249)("__mesa_store_teximage3d", биб);

		//вяжи(функция_250)("__mesa_store_texsubimage1d", биб);

		//вяжи(функция_251)("__mesa_store_texsubimage2d", биб);

		//вяжи(функция_252)("__mesa_store_texsubimage3d", биб);

		//вяжи(функция_253)("__mesa_strcmp", биб);

		//вяжи(функция_254)("__mesa_test_proxy_teximage", биб);

		//вяжи(функция_255)("__mesa_unreference_framebuffer", биб);

		//вяжи(функция_256)("__mesa_update_framebuffer_visual", биб);

		//вяжи(функция_257)("__mesa_use_program", биб);

		//вяжи(функция_258)("__mesa_Viewport", биб);

		//вяжи(функция_259)("__mesa_wait_query", биб);

		//вяжи(функция_260)("__swrast_Accum", биб);

		//вяжи(функция_261)("__swrast_Bitmap", биб);

		//вяжи(функция_262)("__swrast_BlitFramebuffer", биб);

		//вяжи(функция_263)("__swrast_choose_line", биб);

		//вяжи(функция_264)("__swrast_choose_triangle", биб);

		//вяжи(функция_265)("__swrast_Clear", биб);

		//вяжи(функция_266)("__swrast_copy_teximage1d", биб);

		//вяжи(функция_267)("__swrast_copy_teximage2d", биб);

		//вяжи(функция_268)("__swrast_copy_texsubimage1d", биб);

		//вяжи(функция_269)("__swrast_copy_texsubimage2d", биб);

		//вяжи(функция_270)("__swrast_copy_texsubimage3d", биб);

		//вяжи(функция_271)("__swrast_CopyColorSubTable", биб);

		//вяжи(функция_272)("__swrast_CopyColorTable", биб);

		//вяжи(функция_273)("__swrast_CopyConvolutionFilter1D", биб);

		//вяжи(функция_274)("__swrast_CopyConvolutionFilter2D", биб);

		//вяжи(функция_275)("__swrast_CopyPixels", биб);

		//вяжи(функция_276)("__swrast_CreateContext", биб);

		//вяжи(функция_277)("__swrast_DestroyContext", биб);

		//вяжи(функция_278)("__swrast_DrawPixels", биб);

		//вяжи(функция_279)("__swrast_exec_fragment_program", биб);

		//вяжи(функция_280)("__swrast_GetDeviceDriverReference", биб);

		//вяжи(функция_281)("__swrast_InvalidateState", биб);

		//вяжи(функция_282)("__swrast_ReadPixels", биб);

		//вяжи(функция_283)("__swsetup_CreateContext", биб);

		//вяжи(функция_284)("__swsetup_DestroyContext", биб);

		//вяжи(функция_285)("__swsetup_InvalidateState", биб);

		//вяжи(функция_286)("__swsetup_Wakeup", биб);

		//вяжи(функция_287)("__tnl_CreateContext", биб);

		//вяжи(функция_288)("__tnl_DestroyContext", биб);

		//вяжи(функция_289)("__tnl_InvalidateState", биб);

		//вяжи(функция_290)("__tnl_program_string", биб);

		//вяжи(функция_291)("__tnl_RasterPos", биб);

		//вяжи(функция_292)("__tnl_run_pipeline", биб);

		//вяжи(функция_293)("__vbo_CreateContext", биб);

		//вяжи(функция_294)("__vbo_DestroyContext", биб);

		//вяжи(функция_295)("__vbo_InvalidateState", биб);

		//вяжи(функция_296)("_glAccum", биб);

		//вяжи(функция_297)("_glActiveTexture", биб);

		//вяжи(функция_298)("_glActiveTextureARB", биб);

		//вяжи(функция_299)("_glAlphaFunc", биб);

		//вяжи(функция_300)("_glAreProgramsResidentNV", биб);

		//вяжи(функция_301)("_glAreTexturesResident", биб);

		//вяжи(функция_302)("_glAreTexturesResidentEXT", биб);

		//вяжи(функция_303)("_glArrayElement", биб);

		//вяжи(функция_304)("_glArrayElementEXT", биб);

		вяжи(глНачни)("glBegin", биб);

		//вяжи(функция_306)("_glBeginQuery", биб);

		//вяжи(функция_307)("_glBeginQueryARB", биб);

		//вяжи(функция_308)("_glBindBuffer", биб);

		//вяжи(функция_309)("_glBindBufferARB", биб);

		//вяжи(функция_310)("_glBindProgramARB", биб);

		//вяжи(функция_311)("_glBindProgramNV", биб);

		//вяжи(функция_312)("_glBindTexture", биб);

		//вяжи(функция_313)("_glBindTextureEXT", биб);

		//вяжи(функция_314)("_glBitmap", биб);

		//вяжи(функция_315)("_glBlendColor", биб);

		//вяжи(функция_316)("_glBlendColorEXT", биб);

		//вяжи(функция_317)("_glBlendEquation", биб);

		//вяжи(функция_318)("_glBlendEquationEXT", биб);

		//вяжи(функция_319)("_glBlendFunc", биб);

		//вяжи(функция_320)("_glBlendFuncSeparateEXT", биб);

		//вяжи(функция_321)("_glBufferData", биб);

		//вяжи(функция_322)("_glBufferDataARB", биб);

		//вяжи(функция_323)("_glBufferSubData", биб);

		//вяжи(функция_324)("_glBufferSubDataARB", биб);

		//вяжи(функция_325)("_glCallList", биб);

		//вяжи(функция_326)("_glCallLists", биб);

		вяжи(глОчисти)("glClear", биб);

		//вяжи(функция_328)("_glClearAccum", биб);

		//вяжи(функция_329)("_glClearColor", биб);

		//вяжи(функция_330)("_glClearDepth", биб);

		вяжи(глОчистиИндекс)("glClearIndex", биб);

		//вяжи(функция_332)("_glClearStencil", биб);

		//вяжи(функция_333)("_glClientActiveTexture", биб);

		//вяжи(функция_334)("_glClientActiveTextureARB", биб);

		//вяжи(функция_335)("_glClipPlane", биб);

		//вяжи(функция_336)("_glColor3b", биб);

		//вяжи(функция_337)("_glColor3bv", биб);

		//вяжи(функция_338)("_glColor3d", биб);

		//вяжи(функция_339)("_glColor3dv", биб);

		//вяжи(функция_340)("_glColor3f", биб);

		//вяжи(функция_341)("_glColor3fv", биб);

		//вяжи(функция_342)("_glColor3i", биб);

		//вяжи(функция_343)("_glColor3iv", биб);

		//вяжи(функция_344)("_glColor3s", биб);

		//вяжи(функция_345)("_glColor3sv", биб);

		//вяжи(функция_346)("_glColor3ub", биб);

		//вяжи(функция_347)("_glColor3ubv", биб);

		//вяжи(функция_348)("_glColor3ui", биб);

		//вяжи(функция_349)("_glColor3uiv", биб);

		//вяжи(функция_350)("_glColor3us", биб);

		//вяжи(функция_351)("_glColor3usv", биб);

		//вяжи(функция_352)("_glColor4b", биб);

		//вяжи(функция_353)("_glColor4bv", биб);

		//вяжи(функция_354)("_glColor4d", биб);

		//вяжи(функция_355)("_glColor4dv", биб);

		//вяжи(функция_356)("_glColor4f", биб);

		//вяжи(функция_357)("_glColor4fv", биб);

		//вяжи(функция_358)("_glColor4i", биб);

		//вяжи(функция_359)("_glColor4iv", биб);

		//вяжи(функция_360)("_glColor4s", биб);

		//вяжи(функция_361)("_glColor4sv", биб);

		//вяжи(функция_362)("_glColor4ub", биб);

		//вяжи(функция_363)("_glColor4ubv", биб);

		//вяжи(функция_364)("_glColor4ui", биб);

		//вяжи(функция_365)("_glColor4uiv", биб);

		//вяжи(функция_366)("_glColor4us", биб);

		//вяжи(функция_367)("_glColor4usv", биб);

		//вяжи(функция_368)("_glColorMask", биб);

		//вяжи(функция_369)("_glColorMaterial", биб);

		//вяжи(функция_370)("_glColorPointer", биб);

		//вяжи(функция_371)("_glColorPointerEXT", биб);

		//вяжи(функция_372)("_glColorSubTable", биб);

		//вяжи(функция_373)("_glColorTable", биб);

		//вяжи(функция_374)("_glColorTableEXT", биб);

		//вяжи(функция_375)("_glColorTableParameterfv", биб);

		//вяжи(функция_376)("_glColorTableParameteriv", биб);

		//вяжи(функция_377)("_glCombinerInputNV", биб);

		//вяжи(функция_378)("_glCombinerOutputNV", биб);

		//вяжи(функция_379)("_glCombinerParameterfNV", биб);

		//вяжи(функция_380)("_glCombinerParameterfvNV", биб);

		//вяжи(функция_381)("_glCombinerParameteriNV", биб);

		//вяжи(функция_382)("_glCombinerParameterivNV", биб);

		//вяжи(функция_383)("_glCompressedTexImage1D", биб);

		//вяжи(функция_384)("_glCompressedTexImage1DARB", биб);

		//вяжи(функция_385)("_glCompressedTexImage2D", биб);

		//вяжи(функция_386)("_glCompressedTexImage2DARB", биб);

		//вяжи(функция_387)("_glCompressedTexImage3D", биб);

		//вяжи(функция_388)("_glCompressedTexImage3DARB", биб);

		//вяжи(функция_389)("_glCompressedTexSubImage1D", биб);

		//вяжи(функция_390)("_glCompressedTexSubImage1DARB", биб);

		//вяжи(функция_391)("_glCompressedTexSubImage2D", биб);

		//вяжи(функция_392)("_glCompressedTexSubImage2DARB", биб);

		//вяжи(функция_393)("_glCompressedTexSubImage3D", биб);

		//вяжи(функция_394)("_glCompressedTexSubImage3DARB", биб);

		//вяжи(функция_395)("_glConvolutionFilter1D", биб);

		//вяжи(функция_396)("_glConvolutionFilter2D", биб);

		//вяжи(функция_397)("_glConvolutionParameterf", биб);

		//вяжи(функция_398)("_glConvolutionParameterfv", биб);

		//вяжи(функция_399)("_glConvolutionParameteri", биб);

		//вяжи(функция_400)("_glConvolutionParameteriv", биб);

		//вяжи(функция_401)("_glCopyColorSubTable", биб);

		//вяжи(функция_402)("_glCopyColorTable", биб);

		//вяжи(функция_403)("_glCopyConvolutionFilter1D", биб);

		//вяжи(функция_404)("_glCopyConvolutionFilter2D", биб);

		//вяжи(функция_405)("_glCopyPixels", биб);

		//вяжи(функция_406)("_glCopyTexImage1D", биб);

		//вяжи(функция_407)("_glCopyTexImage1DEXT", биб);

		//вяжи(функция_408)("_glCopyTexImage2D", биб);

		//вяжи(функция_409)("_glCopyTexImage2DEXT", биб);

		//вяжи(функция_410)("_glCopyTexSubImage1D", биб);

		//вяжи(функция_411)("_glCopyTexSubImage1DEXT", биб);

		//вяжи(функция_412)("_glCopyTexSubImage2D", биб);

		//вяжи(функция_413)("_glCopyTexSubImage2DEXT", биб);

		//вяжи(функция_414)("_glCopyTexSubImage3D", биб);

		//вяжи(функция_415)("_glCopyTexSubImage3DEXT", биб);

		//вяжи(функция_416)("_glCullFace", биб);

		//вяжи(функция_417)("_glDeleteBuffers", биб);

		//вяжи(функция_418)("_glDeleteBuffersARB", биб);

		//вяжи(функция_419)("_glDeleteLists", биб);

		//вяжи(функция_420)("_glDeleteProgramsARB", биб);

		//вяжи(функция_421)("_glDeleteProgramsNV", биб);

		//вяжи(функция_422)("_glDeleteQueries", биб);

		//вяжи(функция_423)("_glDeleteQueriesARB", биб);

		//вяжи(функция_424)("_glDeleteTextures", биб);

		//вяжи(функция_425)("_glDeleteTexturesEXT", биб);

		//вяжи(функция_426)("_glDepthFunc", биб);

		//вяжи(функция_427)("_glDepthMask", биб);

		//вяжи(функция_428)("_glDepthRange", биб);

		//вяжи(функция_429)("_glDisable", биб);

		//вяжи(функция_430)("_glDisableClientState", биб);

		//вяжи(функция_431)("_glDisableVertexAttribArrayARB", биб);

		//вяжи(функция_432)("_glDrawArrays", биб);

		//вяжи(функция_433)("_glDrawArraysEXT", биб);

		//вяжи(функция_434)("_glDrawBuffer", биб);

		//вяжи(функция_435)("_glDrawElements", биб);

		//вяжи(функция_436)("_glDrawPixels", биб);

		//вяжи(функция_437)("_glDrawRangeElements", биб);

		//вяжи(функция_438)("_glDrawRangeElementsEXT", биб);

		//вяжи(функция_439)("_glEdgeFlag", биб);

		//вяжи(функция_440)("_glEdgeFlagPointer", биб);

		//вяжи(функция_441)("_glEdgeFlagPointerEXT", биб);

		//вяжи(функция_442)("_glEdgeFlagv", биб);

		вяжи(глВключи)("glEnable", биб);

		//вяжи(функция_444)("_glEnableClientState", биб);

		//вяжи(функция_445)("_glEnableVertexAttribArrayARB", биб);

		вяжи(глСтоп)("glEnd", биб);

		//вяжи(функция_447)("_glEndList", биб);

		//вяжи(функция_448)("_glEndQuery", биб);

		//вяжи(функция_449)("_glEndQueryARB", биб);

		//вяжи(функция_450)("_glEvalCoord1d", биб);

		//вяжи(функция_451)("_glEvalCoord1dv", биб);

		//вяжи(функция_452)("_glEvalCoord1f", биб);

		//вяжи(функция_453)("_glEvalCoord1fv", биб);

		//вяжи(функция_454)("_glEvalCoord2d", биб);

		//вяжи(функция_455)("_glEvalCoord2dv", биб);

		//вяжи(функция_456)("_glEvalCoord2f", биб);

		//вяжи(функция_457)("_glEvalCoord2fv", биб);

		//вяжи(функция_458)("_glEvalMesh1", биб);

		//вяжи(функция_459)("_glEvalMesh2", биб);

		//вяжи(функция_460)("_glEvalPoint1", биб);

		//вяжи(функция_461)("_glEvalPoint2", биб);

		//вяжи(функция_462)("_glExecuteProgramNV", биб);

		//вяжи(функция_463)("_glFeedbackBuffer", биб);

		//вяжи(функция_464)("_glFinalCombinerInputNV", биб);

		//вяжи(функция_465)("_glFinish", биб);

		вяжи(глСлей)("glFlush", биб);

		//вяжи(функция_467)("_glFlushVertexArrayRangeNV", биб);

		//вяжи(функция_468)("_glFogCoordd", биб);

		//вяжи(функция_469)("_glFogCoorddEXT", биб);

		//вяжи(функция_470)("_glFogCoorddv", биб);

		//вяжи(функция_471)("_glFogCoorddvEXT", биб);

		//вяжи(функция_472)("_glFogCoordf", биб);

		//вяжи(функция_473)("_glFogCoordfEXT", биб);

		//вяжи(функция_474)("_glFogCoordfv", биб);

		//вяжи(функция_475)("_glFogCoordfvEXT", биб);

		//вяжи(функция_476)("_glFogCoordPointer", биб);

		//вяжи(функция_477)("_glFogCoordPointerEXT", биб);

		//вяжи(функция_478)("_glFogf", биб);

		//вяжи(функция_479)("_glFogfv", биб);

		//вяжи(функция_480)("_glFogi", биб);

		//вяжи(функция_481)("_glFogiv", биб);

		//вяжи(функция_482)("_glFrontFace", биб);

		//вяжи(функция_483)("_glFrustum", биб);

		//вяжи(функция_484)("_glGenBuffers", биб);

		//вяжи(функция_485)("_glGenBuffersARB", биб);

		//вяжи(функция_486)("_glGenLists", биб);

		//вяжи(функция_487)("_glGenProgramsARB", биб);

		//вяжи(функция_488)("_glGenProgramsNV", биб);

		//вяжи(функция_489)("_glGenQueries", биб);

		//вяжи(функция_490)("_glGenQueriesARB", биб);

		//вяжи(функция_491)("_glGenTextures", биб);

		//вяжи(функция_492)("_glGenTexturesEXT", биб);

		//вяжи(функция_493)("_glGetBooleanv", биб);

		//вяжи(функция_494)("_glGetBufferParameteriv", биб);

		//вяжи(функция_495)("_glGetBufferParameterivARB", биб);

		//вяжи(функция_496)("_glGetBufferPointerv", биб);

		//вяжи(функция_497)("_glGetBufferPointervARB", биб);

		//вяжи(функция_498)("_glGetBufferSubData", биб);

		//вяжи(функция_499)("_glGetBufferSubDataARB", биб);

		//вяжи(функция_500)("_glGetClipPlane", биб);

		//вяжи(функция_501)("_glGetColorTable", биб);

		//вяжи(функция_502)("_glGetColorTableEXT", биб);

		//вяжи(функция_503)("_glGetColorTableParameterfv", биб);

		//вяжи(функция_504)("_glGetColorTableParameterfvEXT", биб);

		//вяжи(функция_505)("_glGetColorTableParameteriv", биб);

		//вяжи(функция_506)("_glGetColorTableParameterivEXT", биб);

		//вяжи(функция_507)("_glGetCombinerInputParameterfvNV", биб);

		//вяжи(функция_508)("_glGetCombinerInputParameterivNV", биб);

		//вяжи(функция_509)("_glGetCombinerOutputParameterfvNV", биб);

		//вяжи(функция_510)("_glGetCombinerOutputParameterivNV", биб);

		//вяжи(функция_511)("_glGetCompressedTexImage", биб);

		//вяжи(функция_512)("_glGetCompressedTexImageARB", биб);

		//вяжи(функция_513)("_glGetConvolutionFilter", биб);

		//вяжи(функция_514)("_glGetConvolutionParameterfv", биб);

		//вяжи(функция_515)("_glGetConvolutionParameteriv", биб);

		//вяжи(функция_516)("_glGetDoublev", биб);

		//вяжи(функция_517)("_glGetError", биб);

		//вяжи(функция_518)("_glGetFinalCombinerInputParameterfvNV", биб);

		//вяжи(функция_519)("_glGetFinalCombinerInputParameterivNV", биб);

		//вяжи(функция_520)("_glGetFloatv", биб);

		//вяжи(функция_521)("_glGetHistogram", биб);

		//вяжи(функция_522)("_glGetHistogramParameterfv", биб);

		//вяжи(функция_523)("_glGetHistogramParameteriv", биб);

		//вяжи(функция_524)("_glGetIntegerv", биб);

		//вяжи(функция_525)("_glGetLightfv", биб);

		//вяжи(функция_526)("_glGetLightiv", биб);

		//вяжи(функция_527)("_glGetMapdv", биб);

		//вяжи(функция_528)("_glGetMapfv", биб);

		//вяжи(функция_529)("_glGetMapiv", биб);

		//вяжи(функция_530)("_glGetMaterialfv", биб);

		//вяжи(функция_531)("_glGetMaterialiv", биб);

		//вяжи(функция_532)("_glGetMinmax", биб);

		//вяжи(функция_533)("_glGetMinmaxParameterfv", биб);

		//вяжи(функция_534)("_glGetMinmaxParameteriv", биб);

		//вяжи(функция_535)("_glGetPixelMapfv", биб);

		//вяжи(функция_536)("_glGetPixelMapuiv", биб);

		//вяжи(функция_537)("_glGetPixelMapusv", биб);

		//вяжи(функция_538)("_glGetPointerv", биб);

		//вяжи(функция_539)("_glGetPointervEXT", биб);

		//вяжи(функция_540)("_glGetPolygonStipple", биб);

		//вяжи(функция_541)("_glGetProgramEnvParameterdvARB", биб);

		//вяжи(функция_542)("_glGetProgramEnvParameterfvARB", биб);

		//вяжи(функция_543)("_glGetProgramivARB", биб);

		//вяжи(функция_544)("_glGetProgramivNV", биб);

		//вяжи(функция_545)("_glGetProgramLocalParameterdvARB", биб);

		//вяжи(функция_546)("_glGetProgramLocalParameterfvARB", биб);

		//вяжи(функция_547)("_glGetProgramNamedParameterdvNV", биб);

		//вяжи(функция_548)("_glGetProgramNamedParameterfvNV", биб);

		//вяжи(функция_549)("_glGetProgramParameterdvNV", биб);

		//вяжи(функция_550)("_glGetProgramParameterfvNV", биб);

		//вяжи(функция_551)("_glGetProgramStringARB", биб);

		//вяжи(функция_552)("_glGetProgramStringNV", биб);

		//вяжи(функция_553)("_glGetQueryiv", биб);

		//вяжи(функция_554)("_glGetQueryivARB", биб);

		//вяжи(функция_555)("_glGetQueryObjectiv", биб);

		//вяжи(функция_556)("_glGetQueryObjectivARB", биб);

		//вяжи(функция_557)("_glGetQueryObjectuiv", биб);

		//вяжи(функция_558)("_glGetQueryObjectuivARB", биб);

		//вяжи(функция_559)("_glGetSeparableFilter", биб);

		//вяжи(функция_560)("_glGetString", биб);

		//вяжи(функция_561)("_glGetTexEnvfv", биб);

		//вяжи(функция_562)("_glGetTexEnviv", биб);

		//вяжи(функция_563)("_glGetTexGendv", биб);

		//вяжи(функция_564)("_glGetTexGenfv", биб);

		//вяжи(функция_565)("_glGetTexGeniv", биб);

		//вяжи(функция_566)("_glGetTexImage", биб);

		//вяжи(функция_567)("_glGetTexLevelParameterfv", биб);

		//вяжи(функция_568)("_glGetTexLevelParameteriv", биб);

		//вяжи(функция_569)("_glGetTexParameterfv", биб);

		//вяжи(функция_570)("_glGetTexParameteriv", биб);

		//вяжи(функция_571)("_glGetTrackMatrixivNV", биб);

		//вяжи(функция_572)("_glGetVertexAttribdvARB", биб);

		//вяжи(функция_573)("_glGetVertexAttribdvNV", биб);

		//вяжи(функция_574)("_glGetVertexAttribfvARB", биб);

		//вяжи(функция_575)("_glGetVertexAttribfvNV", биб);

		//вяжи(функция_576)("_glGetVertexAttribivARB", биб);

		//вяжи(функция_577)("_glGetVertexAttribivNV", биб);

		//вяжи(функция_578)("_glGetVertexAttribPointervARB", биб);

		//вяжи(функция_579)("_glGetVertexAttribPointervNV", биб);

		//вяжи(функция_580)("_glHint", биб);

		//вяжи(функция_581)("_glHistogram", биб);

		вяжи(glIndexd)("glIndexd", биб);
		вяжи(glIndexdv)("glIndexdv", биб);
		вяжи(glIndexf)("glIndexf", биб);
		вяжи(glIndexfv)("glIndexfv", биб);
		вяжи(glIndexi)("glIndexi", биб);
		вяжи(glIndexiv)("glIndexiv", биб);

		//вяжи(функция_588)("_glIndexMask", биб);

		//вяжи(функция_589)("_glIndexPointer", биб);

		//вяжи(функция_590)("_glIndexPointerEXT", биб);

		вяжи(glIndexs)("glIndexs", биб);
		вяжи(glIndexsv)("glIndexsv", биб);
		вяжи(glIndexub)("glIndexub", биб);
		вяжи(glIndexubv)("glIndexubv", биб);

		//вяжи(функция_595)("_glInitNames", биб);

		//вяжи(функция_596)("_glInterleavedArrays", биб);

		//вяжи(функция_597)("_glIsBuffer", биб);

		//вяжи(функция_598)("_glIsBufferARB", биб);

		//вяжи(функция_599)("_glIsEnabled", биб);

		//вяжи(функция_600)("_glIsList", биб);

		//вяжи(функция_601)("_glIsProgramARB", биб);

		//вяжи(функция_602)("_glIsProgramNV", биб);

		//вяжи(функция_603)("_glIsQuery", биб);

		//вяжи(функция_604)("_glIsQueryARB", биб);

		//вяжи(функция_605)("_glIsTexture", биб);

		//вяжи(функция_606)("_glIsTextureEXT", биб);

		//вяжи(функция_607)("_glLightf", биб);

		//вяжи(функция_608)("_glLightfv", биб);

		//вяжи(функция_609)("_glLighti", биб);

		//вяжи(функция_610)("_glLightiv", биб);

		//вяжи(функция_611)("_glLightModelf", биб);

		//вяжи(функция_612)("_glLightModelfv", биб);

		//вяжи(функция_613)("_glLightModeli", биб);

		//вяжи(функция_614)("_glLightModeliv", биб);

		//вяжи(функция_615)("_glLineStipple", биб);

		вяжи(глШиринаЛинии)("glLineWidth", биб);

		//вяжи(функция_617)("_glListBase", биб);

		вяжи(глЗагрузиИдент)("glLoadIdentity", биб);

		//вяжи(функция_619)("_glLoadMatrixd", биб);

		//вяжи(функция_620)("_glLoadMatrixf", биб);

		//вяжи(функция_621)("_glLoadName", биб);

		//вяжи(функция_622)("_glLoadProgramNV", биб);

		//вяжи(функция_623)("_glLoadTransposeMatrixd", биб);

		//вяжи(функция_624)("_glLoadTransposeMatrixdARB", биб);

		//вяжи(функция_625)("_glLoadTransposeMatrixf", биб);

		//вяжи(функция_626)("_glLoadTransposeMatrixfARB", биб);

		//вяжи(функция_627)("_glLockArraysEXT", биб);

		//вяжи(функция_628)("_glLogicOp", биб);

		//вяжи(функция_629)("_glMap1d", биб);

		//вяжи(функция_630)("_glMap1f", биб);

		//вяжи(функция_631)("_glMap2d", биб);

		//вяжи(функция_632)("_glMap2f", биб);

		//вяжи(функция_633)("_glMapBuffer", биб);

		//вяжи(функция_634)("_glMapBufferARB", биб);

		//вяжи(функция_635)("_glMapGrid1d", биб);

		//вяжи(функция_636)("_glMapGrid1f", биб);

		//вяжи(функция_637)("_glMapGrid2d", биб);

		//вяжи(функция_638)("_glMapGrid2f", биб);

		//вяжи(функция_639)("_glMaterialf", биб);

		//вяжи(функция_640)("_glMaterialfv", биб);

		//вяжи(функция_641)("_glMateriali", биб);

		//вяжи(функция_642)("_glMaterialiv", биб);

		вяжи(глРежимМатр)("glMatrixMode", биб);

		//вяжи(функция_644)("_glMinmax", биб);

		//вяжи(функция_645)("_glMultiDrawArrays", биб);

		//вяжи(функция_646)("_glMultiDrawArraysEXT", биб);

		//вяжи(функция_647)("_glMultiDrawElements", биб);

		//вяжи(функция_648)("_glMultiDrawElementsEXT", биб);

		//вяжи(функция_649)("_glMultiTexCoord1d", биб);

		//вяжи(функция_650)("_glMultiTexCoord1dARB", биб);

		//вяжи(функция_651)("_glMultiTexCoord1dv", биб);

		//вяжи(функция_652)("_glMultiTexCoord1dvARB", биб);

		//вяжи(функция_653)("_glMultiTexCoord1f", биб);

		//вяжи(функция_654)("_glMultiTexCoord1fARB", биб);

		//вяжи(функция_655)("_glMultiTexCoord1fv", биб);

		//вяжи(функция_656)("_glMultiTexCoord1fvARB", биб);

		//вяжи(функция_657)("_glMultiTexCoord1i", биб);

		//вяжи(функция_658)("_glMultiTexCoord1iARB", биб);

		//вяжи(функция_659)("_glMultiTexCoord1iv", биб);

		//вяжи(функция_660)("_glMultiTexCoord1ivARB", биб);

		//вяжи(функция_661)("_glMultiTexCoord1s", биб);

		//вяжи(функция_662)("_glMultiTexCoord1sARB", биб);

		//вяжи(функция_663)("_glMultiTexCoord1sv", биб);

		//вяжи(функция_664)("_glMultiTexCoord1svARB", биб);

		//вяжи(функция_665)("_glMultiTexCoord2d", биб);

		//вяжи(функция_666)("_glMultiTexCoord2dARB", биб);

		//вяжи(функция_667)("_glMultiTexCoord2dv", биб);

		//вяжи(функция_668)("_glMultiTexCoord2dvARB", биб);

		//вяжи(функция_669)("_glMultiTexCoord2f", биб);

		//вяжи(функция_670)("_glMultiTexCoord2fARB", биб);

		//вяжи(функция_671)("_glMultiTexCoord2fv", биб);

		//вяжи(функция_672)("_glMultiTexCoord2fvARB", биб);

		//вяжи(функция_673)("_glMultiTexCoord2i", биб);

		//вяжи(функция_674)("_glMultiTexCoord2iARB", биб);

		//вяжи(функция_675)("_glMultiTexCoord2iv", биб);

		//вяжи(функция_676)("_glMultiTexCoord2ivARB", биб);

		//вяжи(функция_677)("_glMultiTexCoord2s", биб);

		//вяжи(функция_678)("_glMultiTexCoord2sARB", биб);

		//вяжи(функция_679)("_glMultiTexCoord2sv", биб);

		//вяжи(функция_680)("_glMultiTexCoord2svARB", биб);

		//вяжи(функция_681)("_glMultiTexCoord3d", биб);

		//вяжи(функция_682)("_glMultiTexCoord3dARB", биб);

		//вяжи(функция_683)("_glMultiTexCoord3dv", биб);

		//вяжи(функция_684)("_glMultiTexCoord3dvARB", биб);

		//вяжи(функция_685)("_glMultiTexCoord3f", биб);

		//вяжи(функция_686)("_glMultiTexCoord3fARB", биб);

		//вяжи(функция_687)("_glMultiTexCoord3fv", биб);

		//вяжи(функция_688)("_glMultiTexCoord3fvARB", биб);

		//вяжи(функция_689)("_glMultiTexCoord3i", биб);

		//вяжи(функция_690)("_glMultiTexCoord3iARB", биб);

		//вяжи(функция_691)("_glMultiTexCoord3iv", биб);

		//вяжи(функция_692)("_glMultiTexCoord3ivARB", биб);

		//вяжи(функция_693)("_glMultiTexCoord3s", биб);

		//вяжи(функция_694)("_glMultiTexCoord3sARB", биб);

		//вяжи(функция_695)("_glMultiTexCoord3sv", биб);

		//вяжи(функция_696)("_glMultiTexCoord3svARB", биб);

		//вяжи(функция_697)("_glMultiTexCoord4d", биб);

		//вяжи(функция_698)("_glMultiTexCoord4dARB", биб);

		//вяжи(функция_699)("_glMultiTexCoord4dv", биб);

		//вяжи(функция_700)("_glMultiTexCoord4dvARB", биб);

		//вяжи(функция_701)("_glMultiTexCoord4f", биб);

		//вяжи(функция_702)("_glMultiTexCoord4fARB", биб);

		//вяжи(функция_703)("_glMultiTexCoord4fv", биб);

		//вяжи(функция_704)("_glMultiTexCoord4fvARB", биб);

		//вяжи(функция_705)("_glMultiTexCoord4i", биб);

		//вяжи(функция_706)("_glMultiTexCoord4iARB", биб);

		//вяжи(функция_707)("_glMultiTexCoord4iv", биб);

		//вяжи(функция_708)("_glMultiTexCoord4ivARB", биб);

		//вяжи(функция_709)("_glMultiTexCoord4s", биб);

		//вяжи(функция_710)("_glMultiTexCoord4sARB", биб);

		//вяжи(функция_711)("_glMultiTexCoord4sv", биб);

		//вяжи(функция_712)("_glMultiTexCoord4svARB", биб);

		//вяжи(функция_713)("_glMultMatrixd", биб);

		//вяжи(функция_714)("_glMultMatrixf", биб);

		//вяжи(функция_715)("_glMultTransposeMatrixd", биб);

		//вяжи(функция_716)("_glMultTransposeMatrixdARB", биб);

		//вяжи(функция_717)("_glMultTransposeMatrixf", биб);

		//вяжи(функция_718)("_glMultTransposeMatrixfARB", биб);

		//вяжи(функция_719)("_glNewList", биб);

		//вяжи(функция_720)("_glNormal3b", биб);

		//вяжи(функция_721)("_glNormal3bv", биб);

		//вяжи(функция_722)("_glNormal3d", биб);

		//вяжи(функция_723)("_glNormal3dv", биб);

		//вяжи(функция_724)("_glNormal3f", биб);

		//вяжи(функция_725)("_glNormal3fv", биб);

		//вяжи(функция_726)("_glNormal3i", биб);

		//вяжи(функция_727)("_glNormal3iv", биб);

		//вяжи(функция_728)("_glNormal3s", биб);

		//вяжи(функция_729)("_glNormal3sv", биб);

		//вяжи(функция_730)("_glNormalPointer", биб);

		//вяжи(функция_731)("_glNormalPointerEXT", биб);

		//вяжи(функция_732)("_glOrtho", биб);

		//вяжи(функция_733)("_glPassThrough", биб);

		//вяжи(функция_734)("_glPixelMapfv", биб);

		//вяжи(функция_735)("_glPixelMapuiv", биб);

		//вяжи(функция_736)("_glPixelMapusv", биб);

		//вяжи(функция_737)("_glPixelStoref", биб);

		//вяжи(функция_738)("_glPixelStorei", биб);

		//вяжи(функция_739)("_glPixelTransferf", биб);

		//вяжи(функция_740)("_glPixelTransferi", биб);

		//вяжи(функция_741)("_glPixelZoom", биб);

		//вяжи(функция_742)("_glPointParameterf", биб);

		//вяжи(функция_743)("_glPointParameterfARB", биб);

		//вяжи(функция_744)("_glPointParameterfEXT", биб);

		//вяжи(функция_745)("_glPointParameterfv", биб);

		//вяжи(функция_746)("_glPointParameterfvARB", биб);

		//вяжи(функция_747)("_glPointParameterfvEXT", биб);

		//вяжи(функция_748)("_glPointParameteri", биб);

		//вяжи(функция_749)("_glPointParameteriNV", биб);

		//вяжи(функция_750)("_glPointParameteriv", биб);

		//вяжи(функция_751)("_glPointParameterivNV", биб);

		//вяжи(функция_752)("_glPointSize", биб);

		//вяжи(функция_753)("_glPolygonMode", биб);

		//вяжи(функция_754)("_glPolygonOffset", биб);

		//вяжи(функция_755)("_glPolygonOffsetEXT", биб);

		//вяжи(функция_756)("_glPolygonStipple", биб);

		//вяжи(функция_757)("_glPopAttrib", биб);

		//вяжи(функция_758)("_glPopClientAttrib", биб);

		вяжи(глВыньМатр)("glPopMatrix", биб);

		//вяжи(функция_760)("_glPopName", биб);

		//вяжи(функция_761)("_glPrioritizeTextures", биб);

		//вяжи(функция_762)("_glPrioritizeTexturesEXT", биб);

		//вяжи(функция_763)("_glProgramEnvParameter4dARB", биб);

		//вяжи(функция_764)("_glProgramEnvParameter4dvARB", биб);

		//вяжи(функция_765)("_glProgramEnvParameter4fARB", биб);

		//вяжи(функция_766)("_glProgramEnvParameter4fvARB", биб);

		//вяжи(функция_767)("_glProgramLocalParameter4dARB", биб);

		//вяжи(функция_768)("_glProgramLocalParameter4dvARB", биб);

		//вяжи(функция_769)("_glProgramLocalParameter4fARB", биб);

		//вяжи(функция_770)("_glProgramLocalParameter4fvARB", биб);

		//вяжи(функция_771)("_glProgramNamedParameter4dNV", биб);

		//вяжи(функция_772)("_glProgramNamedParameter4dvNV", биб);

		//вяжи(функция_773)("_glProgramNamedParameter4fNV", биб);

		//вяжи(функция_774)("_glProgramNamedParameter4fvNV", биб);

		//вяжи(функция_775)("_glProgramParameter4dNV", биб);

		//вяжи(функция_776)("_glProgramParameter4dvNV", биб);

		//вяжи(функция_777)("_glProgramParameter4fNV", биб);

		//вяжи(функция_778)("_glProgramParameter4fvNV", биб);

		//вяжи(функция_779)("_glProgramParameters4dvNV", биб);

		//вяжи(функция_780)("_glProgramParameters4fvNV", биб);

		//вяжи(функция_781)("_glProgramStringARB", биб);

		//вяжи(функция_782)("_glPushAttrib", биб);

		//вяжи(функция_783)("_glPushClientAttrib", биб);

		вяжи(глСуньМатр)("glPushMatrix", биб);

		//вяжи(функция_785)("_glPushName", биб);

		//вяжи(функция_786)("_glRasterPos2d", биб);

		//вяжи(функция_787)("_glRasterPos2dv", биб);

		//вяжи(функция_788)("_glRasterPos2f", биб);

		//вяжи(функция_789)("_glRasterPos2fv", биб);

		//вяжи(функция_790)("_glRasterPos2i", биб);

		//вяжи(функция_791)("_glRasterPos2iv", биб);

		//вяжи(функция_792)("_glRasterPos2s", биб);

		//вяжи(функция_793)("_glRasterPos2sv", биб);

		//вяжи(функция_794)("_glRasterPos3d", биб);

		//вяжи(функция_795)("_glRasterPos3dv", биб);

		//вяжи(функция_796)("_glRasterPos3f", биб);

		//вяжи(функция_797)("_glRasterPos3fv", биб);

		//вяжи(функция_798)("_glRasterPos3i", биб);

		//вяжи(функция_799)("_glRasterPos3iv", биб);

		//вяжи(функция_800)("_glRasterPos3s", биб);

		//вяжи(функция_801)("_glRasterPos3sv", биб);

		//вяжи(функция_802)("_glRasterPos4d", биб);

		//вяжи(функция_803)("_glRasterPos4dv", биб);

		//вяжи(функция_804)("_glRasterPos4f", биб);

		//вяжи(функция_805)("_glRasterPos4fv", биб);

		//вяжи(функция_806)("_glRasterPos4i", биб);

		//вяжи(функция_807)("_glRasterPos4iv", биб);

		//вяжи(функция_808)("_glRasterPos4s", биб);

		//вяжи(функция_809)("_glRasterPos4sv", биб);

		//вяжи(функция_810)("_glReadBuffer", биб);

		//вяжи(функция_811)("_glReadPixels", биб);

		//вяжи(функция_812)("_glRectd", биб);

		//вяжи(функция_813)("_glRectdv", биб);

		//вяжи(функция_814)("_glRectf", биб);

		//вяжи(функция_815)("_glRectfv", биб);

		//вяжи(функция_816)("_glRecti", биб);

		//вяжи(функция_817)("_glRectiv", биб);

		//вяжи(функция_818)("_glRects", биб);

		//вяжи(функция_819)("_glRectsv", биб);

		//вяжи(функция_820)("_glRenderMode", биб);

		//вяжи(функция_821)("_glRequestResidentProgramsNV", биб);

		//вяжи(функция_822)("_glResetHistogram", биб);

		//вяжи(функция_823)("_glResetMinmax", биб);

		//вяжи(функция_824)("_glResizeBuffersMESA", биб);

		вяжи(глВращайд)("glRotated", биб);
		вяжи(глВращай)("glRotatef", биб);

		//вяжи(функция_827)("_glSampleCoverage", биб);

		//вяжи(функция_828)("_glSampleCoverageARB", биб);

		//вяжи(функция_829)("_glScaled", биб);

		//вяжи(функция_830)("_glScalef", биб);

		//вяжи(функция_831)("_glScissor", биб);

		//вяжи(функция_832)("_glSecondaryColor3b", биб);

		//вяжи(функция_833)("_glSecondaryColor3bEXT", биб);

		//вяжи(функция_834)("_glSecondaryColor3bv", биб);

		//вяжи(функция_835)("_glSecondaryColor3bvEXT", биб);

		//вяжи(функция_836)("_glSecondaryColor3d", биб);

		//вяжи(функция_837)("_glSecondaryColor3dEXT", биб);

		//вяжи(функция_838)("_glSecondaryColor3dv", биб);

		//вяжи(функция_839)("_glSecondaryColor3dvEXT", биб);

		//вяжи(функция_840)("_glSecondaryColor3f", биб);

		//вяжи(функция_841)("_glSecondaryColor3fEXT", биб);

		//вяжи(функция_842)("_glSecondaryColor3fv", биб);

		//вяжи(функция_843)("_glSecondaryColor3fvEXT", биб);

		//вяжи(функция_844)("_glSecondaryColor3i", биб);

		//вяжи(функция_845)("_glSecondaryColor3iEXT", биб);

		//вяжи(функция_846)("_glSecondaryColor3iv", биб);

		//вяжи(функция_847)("_glSecondaryColor3ivEXT", биб);

		//вяжи(функция_848)("_glSecondaryColor3s", биб);

		//вяжи(функция_849)("_glSecondaryColor3sEXT", биб);

		//вяжи(функция_850)("_glSecondaryColor3sv", биб);

		//вяжи(функция_851)("_glSecondaryColor3svEXT", биб);

		//вяжи(функция_852)("_glSecondaryColor3ub", биб);

		//вяжи(функция_853)("_glSecondaryColor3ubEXT", биб);

		//вяжи(функция_854)("_glSecondaryColor3ubv", биб);

		//вяжи(функция_855)("_glSecondaryColor3ubvEXT", биб);

		//вяжи(функция_856)("_glSecondaryColor3ui", биб);

		//вяжи(функция_857)("_glSecondaryColor3uiEXT", биб);

		//вяжи(функция_858)("_glSecondaryColor3uiv", биб);

		//вяжи(функция_859)("_glSecondaryColor3uivEXT", биб);

		//вяжи(функция_860)("_glSecondaryColor3us", биб);

		//вяжи(функция_861)("_glSecondaryColor3usEXT", биб);

		//вяжи(функция_862)("_glSecondaryColor3usv", биб);

		//вяжи(функция_863)("_glSecondaryColor3usvEXT", биб);

		//вяжи(функция_864)("_glSecondaryColorPointer", биб);

		//вяжи(функция_865)("_glSecondaryColorPointerEXT", биб);

		//вяжи(функция_866)("_glSelectBuffer", биб);

		//вяжи(функция_867)("_glSeparableFilter2D", биб);

		//вяжи(функция_868)("_glShadeModel", биб);

		//вяжи(функция_869)("_glStencilFunc", биб);

		//вяжи(функция_870)("_glStencilMask", биб);

		//вяжи(функция_871)("_glStencilOp", биб);

		//вяжи(функция_872)("_glTexCoord1d", биб);

		//вяжи(функция_873)("_glTexCoord1dv", биб);

		//вяжи(функция_874)("_glTexCoord1f", биб);

		//вяжи(функция_875)("_glTexCoord1fv", биб);

		//вяжи(функция_876)("_glTexCoord1i", биб);

		//вяжи(функция_877)("_glTexCoord1iv", биб);

		//вяжи(функция_878)("_glTexCoord1s", биб);

		//вяжи(функция_879)("_glTexCoord1sv", биб);

		//вяжи(функция_880)("_glTexCoord2d", биб);

		//вяжи(функция_881)("_glTexCoord2dv", биб);

		//вяжи(функция_882)("_glTexCoord2f", биб);

		//вяжи(функция_883)("_glTexCoord2fv", биб);

		//вяжи(функция_884)("_glTexCoord2i", биб);

		//вяжи(функция_885)("_glTexCoord2iv", биб);

		//вяжи(функция_886)("_glTexCoord2s", биб);

		//вяжи(функция_887)("_glTexCoord2sv", биб);

		//вяжи(функция_888)("_glTexCoord3d", биб);

		//вяжи(функция_889)("_glTexCoord3dv", биб);

		//вяжи(функция_890)("_glTexCoord3f", биб);

		//вяжи(функция_891)("_glTexCoord3fv", биб);

		//вяжи(функция_892)("_glTexCoord3i", биб);

		//вяжи(функция_893)("_glTexCoord3iv", биб);

		//вяжи(функция_894)("_glTexCoord3s", биб);

		//вяжи(функция_895)("_glTexCoord3sv", биб);

		//вяжи(функция_896)("_glTexCoord4d", биб);

		//вяжи(функция_897)("_glTexCoord4dv", биб);

		//вяжи(функция_898)("_glTexCoord4f", биб);

		//вяжи(функция_899)("_glTexCoord4fv", биб);

		//вяжи(функция_900)("_glTexCoord4i", биб);

		//вяжи(функция_901)("_glTexCoord4iv", биб);

		//вяжи(функция_902)("_glTexCoord4s", биб);

		//вяжи(функция_903)("_glTexCoord4sv", биб);

		//вяжи(функция_904)("_glTexCoordPointer", биб);

		//вяжи(функция_905)("_glTexCoordPointerEXT", биб);

		//вяжи(функция_906)("_glTexEnvf", биб);

		//вяжи(функция_907)("_glTexEnvfv", биб);

		//вяжи(функция_908)("_glTexEnvi", биб);

		//вяжи(функция_909)("_glTexEnviv", биб);

		//вяжи(функция_910)("_glTexGend", биб);

		//вяжи(функция_911)("_glTexGendv", биб);

		//вяжи(функция_912)("_glTexGenf", биб);

		//вяжи(функция_913)("_glTexGenfv", биб);

		//вяжи(функция_914)("_glTexGeni", биб);

		//вяжи(функция_915)("_glTexGeniv", биб);

		//вяжи(функция_916)("_glTexImage1D", биб);

		//вяжи(функция_917)("_glTexImage2D", биб);

		//вяжи(функция_918)("_glTexImage3D", биб);

		//вяжи(функция_919)("_glTexImage3DEXT", биб);

		//вяжи(функция_920)("_glTexParameterf", биб);

		//вяжи(функция_921)("_glTexParameterfv", биб);

		//вяжи(функция_922)("_glTexParameteri", биб);

		//вяжи(функция_923)("_glTexParameteriv", биб);

		//вяжи(функция_924)("_glTexSubImage1D", биб);

		//вяжи(функция_925)("_glTexSubImage1DEXT", биб);

		//вяжи(функция_926)("_glTexSubImage2D", биб);

		//вяжи(функция_927)("_glTexSubImage2DEXT", биб);

		//вяжи(функция_928)("_glTexSubImage3D", биб);

		//вяжи(функция_929)("_glTexSubImage3DEXT", биб);

		//вяжи(функция_930)("_glTrackMatrixNV", биб);

		//вяжи(функция_931)("_glTranslated", биб);

		//вяжи(функция_932)("_glTranslatef", биб);

		//вяжи(функция_933)("_glUnlockArraysEXT", биб);

		//вяжи(функция_934)("_glUnmapBuffer", биб);

		//вяжи(функция_935)("_glUnmapBufferARB", биб);

		вяжи(glVertex2d)("glVertex2d", биб);
		вяжи(glVertex2dv)("glVertex2dv", биб);
		вяжи(glVertex2f)("glVertex2f", биб);
		вяжи(glVertex2fv)("glVertex2fv", биб);
		вяжи(glVertex2i)("glVertex2i", биб);
		вяжи(glVertex2iv)("glVertex2iv", биб);
		вяжи(glVertex2s)("glVertex2s", биб);
		вяжи(glVertex2sv)("glVertex2sv", биб);
		вяжи(glVertex3d)("glVertex3d", биб);
		вяжи(glVertex3dv)("glVertex3dv", биб);
		вяжи(glVertex3f)("glVertex3f", биб);
		вяжи(glVertex3fv)("glVertex3fv", биб);
		вяжи(glVertex3i)("glVertex3i", биб);
		вяжи(glVertex3iv)("glVertex3iv", биб);
		вяжи(glVertex3s)("glVertex3s", биб);
		вяжи(glVertex3sv)("glVertex3sv", биб);
		вяжи(glVertex4d)("glVertex4d", биб);
		вяжи(glVertex4dv)("glVertex4dv", биб);
		вяжи(glVertex4f)("glVertex4f", биб);
		вяжи(glVertex4fv)("glVertex4fv", биб);
		вяжи(glVertex4i)("glVertex4i", биб);
		вяжи(glVertex4iv)("glVertex4iv", биб);
		вяжи(glVertex4s)("glVertex4s", биб);
		вяжи(glVertex4sv)("glVertex4sv", биб);

		//вяжи(функция_960)("_glVertexArrayRangeNV", биб);

		//вяжи(функция_961)("_glVertexAttrib1dARB", биб);

		//вяжи(функция_962)("_glVertexAttrib1dNV", биб);

		//вяжи(функция_963)("_glVertexAttrib1dvARB", биб);

		//вяжи(функция_964)("_glVertexAttrib1dvNV", биб);

		//вяжи(функция_965)("_glVertexAttrib1fARB", биб);

		//вяжи(функция_966)("_glVertexAttrib1fNV", биб);

		//вяжи(функция_967)("_glVertexAttrib1fvARB", биб);

		//вяжи(функция_968)("_glVertexAttrib1fvNV", биб);

		//вяжи(функция_969)("_glVertexAttrib1sARB", биб);

		//вяжи(функция_970)("_glVertexAttrib1sNV", биб);

		//вяжи(функция_971)("_glVertexAttrib1svARB", биб);

		//вяжи(функция_972)("_glVertexAttrib1svNV", биб);

		//вяжи(функция_973)("_glVertexAttrib2dARB", биб);

		//вяжи(функция_974)("_glVertexAttrib2dNV", биб);

		//вяжи(функция_975)("_glVertexAttrib2dvARB", биб);

		//вяжи(функция_976)("_glVertexAttrib2dvNV", биб);

		//вяжи(функция_977)("_glVertexAttrib2fARB", биб);

		//вяжи(функция_978)("_glVertexAttrib2fNV", биб);

		//вяжи(функция_979)("_glVertexAttrib2fvARB", биб);

		//вяжи(функция_980)("_glVertexAttrib2fvNV", биб);

		//вяжи(функция_981)("_glVertexAttrib2sARB", биб);

		//вяжи(функция_982)("_glVertexAttrib2sNV", биб);

		//вяжи(функция_983)("_glVertexAttrib2svARB", биб);

		//вяжи(функция_984)("_glVertexAttrib2svNV", биб);

		//вяжи(функция_985)("_glVertexAttrib3dARB", биб);

		//вяжи(функция_986)("_glVertexAttrib3dNV", биб);

		//вяжи(функция_987)("_glVertexAttrib3dvARB", биб);

		//вяжи(функция_988)("_glVertexAttrib3dvNV", биб);

		//вяжи(функция_989)("_glVertexAttrib3fARB", биб);

		//вяжи(функция_990)("_glVertexAttrib3fNV", биб);

		//вяжи(функция_991)("_glVertexAttrib3fvARB", биб);

		//вяжи(функция_992)("_glVertexAttrib3fvNV", биб);

		//вяжи(функция_993)("_glVertexAttrib3sARB", биб);

		//вяжи(функция_994)("_glVertexAttrib3sNV", биб);

		//вяжи(функция_995)("_glVertexAttrib3svARB", биб);

		//вяжи(функция_996)("_glVertexAttrib3svNV", биб);

		//вяжи(функция_997)("_glVertexAttrib4bvARB", биб);

		//вяжи(функция_998)("_glVertexAttrib4dARB", биб);

		//вяжи(функция_999)("_glVertexAttrib4dNV", биб);

		//вяжи(функция_1000)("_glVertexAttrib4dvARB", биб);

		//вяжи(функция_1001)("_glVertexAttrib4dvNV", биб);

		//вяжи(функция_1002)("_glVertexAttrib4fARB", биб);

		//вяжи(функция_1003)("_glVertexAttrib4fNV", биб);

		//вяжи(функция_1004)("_glVertexAttrib4fvARB", биб);

		//вяжи(функция_1005)("_glVertexAttrib4fvNV", биб);

		//вяжи(функция_1006)("_glVertexAttrib4ivARB", биб);

		//вяжи(функция_1007)("_glVertexAttrib4NbvARB", биб);

		//вяжи(функция_1008)("_glVertexAttrib4NivARB", биб);

		//вяжи(функция_1009)("_glVertexAttrib4NsvARB", биб);

		//вяжи(функция_1010)("_glVertexAttrib4NubARB", биб);

		//вяжи(функция_1011)("_glVertexAttrib4NubvARB", биб);

		//вяжи(функция_1012)("_glVertexAttrib4NuivARB", биб);

		//вяжи(функция_1013)("_glVertexAttrib4NusvARB", биб);

		//вяжи(функция_1014)("_glVertexAttrib4sARB", биб);

		//вяжи(функция_1015)("_glVertexAttrib4sNV", биб);

		//вяжи(функция_1016)("_glVertexAttrib4svARB", биб);

		//вяжи(функция_1017)("_glVertexAttrib4svNV", биб);

		//вяжи(функция_1018)("_glVertexAttrib4ubNV", биб);

		//вяжи(функция_1019)("_glVertexAttrib4ubvARB", биб);

		//вяжи(функция_1020)("_glVertexAttrib4ubvNV", биб);

		//вяжи(функция_1021)("_glVertexAttrib4uivARB", биб);

		//вяжи(функция_1022)("_glVertexAttrib4usvARB", биб);

		//вяжи(функция_1023)("_glVertexAttribPointerARB", биб);

		//вяжи(функция_1024)("_glVertexAttribPointerNV", биб);

		//вяжи(функция_1025)("_glVertexAttribs1dvNV", биб);

		//вяжи(функция_1026)("_glVertexAttribs1fvNV", биб);

		//вяжи(функция_1027)("_glVertexAttribs1svNV", биб);

		//вяжи(функция_1028)("_glVertexAttribs2dvNV", биб);

		//вяжи(функция_1029)("_glVertexAttribs2fvNV", биб);

		//вяжи(функция_1030)("_glVertexAttribs2svNV", биб);

		//вяжи(функция_1031)("_glVertexAttribs3dvNV", биб);

		//вяжи(функция_1032)("_glVertexAttribs3fvNV", биб);

		//вяжи(функция_1033)("_glVertexAttribs3svNV", биб);

		//вяжи(функция_1034)("_glVertexAttribs4dvNV", биб);

		//вяжи(функция_1035)("_glVertexAttribs4fvNV", биб);

		//вяжи(функция_1036)("_glVertexAttribs4svNV", биб);

		//вяжи(функция_1037)("_glVertexAttribs4ubvNV", биб);

		//вяжи(функция_1038)("_glVertexPointer", биб);

		//вяжи(функция_1039)("_glVertexPointerEXT", биб);

		вяжи(глВьюпорт)("glViewport", биб);

		//вяжи(функция_1041)("_glWindowPos2d", биб);

		//вяжи(функция_1042)("_glWindowPos2dARB", биб);

		//вяжи(функция_1043)("_glWindowPos2dMESA", биб);

		//вяжи(функция_1044)("_glWindowPos2dv", биб);

		//вяжи(функция_1045)("_glWindowPos2dvARB", биб);

		//вяжи(функция_1046)("_glWindowPos2dvMESA", биб);

		//вяжи(функция_1047)("_glWindowPos2f", биб);

		//вяжи(функция_1048)("_glWindowPos2fARB", биб);

		//вяжи(функция_1049)("_glWindowPos2fMESA", биб);

		//вяжи(функция_1050)("_glWindowPos2fv", биб);

		//вяжи(функция_1051)("_glWindowPos2fvARB", биб);

		//вяжи(функция_1052)("_glWindowPos2fvMESA", биб);

		//вяжи(функция_1053)("_glWindowPos2i", биб);

		//вяжи(функция_1054)("_glWindowPos2iARB", биб);

		//вяжи(функция_1055)("_glWindowPos2iMESA", биб);

		//вяжи(функция_1056)("_glWindowPos2iv", биб);

		//вяжи(функция_1057)("_glWindowPos2ivARB", биб);

		//вяжи(функция_1058)("_glWindowPos2ivMESA", биб);

		//вяжи(функция_1059)("_glWindowPos2s", биб);

		//вяжи(функция_1060)("_glWindowPos2sARB", биб);

		//вяжи(функция_1061)("_glWindowPos2sMESA", биб);

		//вяжи(функция_1062)("_glWindowPos2sv", биб);

		//вяжи(функция_1063)("_glWindowPos2svARB", биб);

		//вяжи(функция_1064)("_glWindowPos2svMESA", биб);

		//вяжи(функция_1065)("_glWindowPos3d", биб);

		//вяжи(функция_1066)("_glWindowPos3dARB", биб);

		//вяжи(функция_1067)("_glWindowPos3dMESA", биб);

		//вяжи(функция_1068)("_glWindowPos3dv", биб);

		//вяжи(функция_1069)("_glWindowPos3dvARB", биб);

		//вяжи(функция_1070)("_glWindowPos3dvMESA", биб);

		//вяжи(функция_1071)("_glWindowPos3f", биб);

		//вяжи(функция_1072)("_glWindowPos3fARB", биб);

		//вяжи(функция_1073)("_glWindowPos3fMESA", биб);

		//вяжи(функция_1074)("_glWindowPos3fv", биб);

		//вяжи(функция_1075)("_glWindowPos3fvARB", биб);

		//вяжи(функция_1076)("_glWindowPos3fvMESA", биб);

		//вяжи(функция_1077)("_glWindowPos3i", биб);

		//вяжи(функция_1078)("_glWindowPos3iARB", биб);

		//вяжи(функция_1079)("_glWindowPos3iMESA", биб);

		//вяжи(функция_1080)("_glWindowPos3iv", биб);

		//вяжи(функция_1081)("_glWindowPos3ivARB", биб);

		//вяжи(функция_1082)("_glWindowPos3ivMESA", биб);

		//вяжи(функция_1083)("_glWindowPos3s", биб);

		//вяжи(функция_1084)("_glWindowPos3sARB", биб);

		//вяжи(функция_1085)("_glWindowPos3sMESA", биб);

		//вяжи(функция_1086)("_glWindowPos3sv", биб);

		//вяжи(функция_1087)("_glWindowPos3svARB", биб);

		//вяжи(функция_1088)("_glWindowPos3svMESA", биб);

		//вяжи(функция_1089)("_glWindowPos4dMESA", биб);

		//вяжи(функция_1090)("_glWindowPos4dvMESA", биб);

		//вяжи(функция_1091)("_glWindowPos4fMESA", биб);

		//вяжи(функция_1092)("_glWindowPos4fvMESA", биб);

		//вяжи(функция_1093)("_glWindowPos4iMESA", биб);

		//вяжи(функция_1094)("_glWindowPos4ivMESA", биб);

		//вяжи(функция_1095)("_glWindowPos4sMESA", биб);

		//вяжи(функция_1096)("_glWindowPos4svMESA", биб);

		//вяжи(функция_1097)("_wglChoosePixelFormat", биб);

		//вяжи(функция_1098)("_wglCopyContext", биб);

		//вяжи(функция_1099)("_wglCreateContext", биб);

		//вяжи(функция_1100)("_wglCreateLayerContext", биб);

		//вяжи(функция_1101)("_wglDeleteContext", биб);

		//вяжи(функция_1102)("_wglDescribeLayerPlane", биб);

		//вяжи(функция_1103)("_wglDescribePixelFormat", биб);

		//вяжи(функция_1104)("_wglGetCurrentContext", биб);

		//вяжи(функция_1105)("_wglGetCurrentDC", биб);

		//вяжи(функция_1106)("_wglGetExtensionsStringARB", биб);

		//вяжи(функция_1107)("_wglGetLayerPaletteEntries", биб);

		//вяжи(функция_1108)("_wglGetPixelFormat", биб);

		//вяжи(функция_1109)("_wglGetProcAddress", биб);

		//вяжи(функция_1110)("_wglMakeCurrent", биб);

		//вяжи(функция_1111)("_wglRealizeLayerPalette", биб);

		//вяжи(функция_1112)("_wglSetLayerPaletteEntries", биб);

		//вяжи(функция_1113)("_wglSetPixelFormat", биб);

		//вяжи(функция_1114)("_wglShareLists", биб);

		//вяжи(функция_1115)("_wglSwapBuffers", биб);

		//вяжи(функция_1116)("_wglSwapLayerBuffers", биб);

		//вяжи(функция_1117)("_wglUseFontBitmapsA", биб);

		//вяжи(функция_1118)("_wglUseFontBitmapsW", биб);

		//вяжи(функция_1119)("_wglUseFontOutlinesA", биб);

		//вяжи(функция_1120)("_wglUseFontOutlinesW", биб);

		//вяжи(функция_1121)("__glAlphaFragmentOp2ATI@36", биб);

		//вяжи(функция_1122)("__glAlphaFragmentOp3ATI@48", биб);

		//вяжи(функция_1123)("__glapi_check_multithread", биб);

		//вяжи(функция_1124)("__glapi_get_context", биб);

		//вяжи(функция_1125)("__glapi_get_proc_address", биб);

		//вяжи(функция_1126)("__glAttachObjectARB@8", биб);

		//вяжи(функция_1127)("__glAttachShader@8", биб);

		//вяжи(функция_1128)("__glBeginFragmentShaderATI@0", биб);

		//вяжи(функция_1129)("__glBindAttribLocation@12", биб);

		//вяжи(функция_1130)("__glBindAttribLocationARB@12", биб);

		//вяжи(функция_1131)("__glBindFragmentShaderATI@4", биб);

		//вяжи(функция_1132)("__glBindFramebufferEXT@8", биб);

		//вяжи(функция_1133)("__glBindRenderbufferEXT@8", биб);

		//вяжи(функция_1134)("__glBlendEquationSeparate@8", биб);

		//вяжи(функция_1135)("__glBlendFuncSeparate@16", биб);

		//вяжи(функция_1136)("__glCheckFramebufferStatusEXT@4", биб);

		//вяжи(функция_1137)("__glColorFragmentOp1ATI@28", биб);

		//вяжи(функция_1138)("__glColorFragmentOp2ATI@40", биб);

		//вяжи(функция_1139)("__glColorFragmentOp3ATI@52", биб);

		//вяжи(функция_1140)("__glCompileShader@4", биб);

		//вяжи(функция_1141)("__glCompileShaderARB@4", биб);

		//вяжи(функция_1142)("__glCreateProgram@0", биб);

		//вяжи(функция_1143)("__glCreateProgramObjectARB@0", биб);

		//вяжи(функция_1144)("__glCreateShader@4", биб);

		//вяжи(функция_1145)("__glCreateShaderObjectARB@4", биб);

		//вяжи(функция_1146)("__glDeleteFragmentShaderATI@4", биб);

		//вяжи(функция_1147)("__glDeleteFramebuffersEXT@8", биб);

		//вяжи(функция_1148)("__glDeleteObjectARB@4", биб);

		//вяжи(функция_1149)("__glDeleteProgram@4", биб);

		//вяжи(функция_1150)("__glDeleteRenderbuffersEXT@8", биб);

		//вяжи(функция_1151)("__glDeleteShader@4", биб);

		//вяжи(функция_1152)("__glDetachObjectARB@8", биб);

		//вяжи(функция_1153)("__glDetachShader@8", биб);

		//вяжи(функция_1154)("__glDisableVertexAttribArray@4", биб);

		//вяжи(функция_1155)("__glDrawBuffers@8", биб);

		//вяжи(функция_1156)("__glDrawBuffersARB@8", биб);

		//вяжи(функция_1157)("__glDrawBuffersATI@8", биб);

		//вяжи(функция_1158)("__glEnableVertexAttribArray@4", биб);

		//вяжи(функция_1159)("__glEndFragmentShaderATI@0", биб);

		//вяжи(функция_1160)("__glFramebufferRenderbufferEXT@16", биб);

		//вяжи(функция_1161)("__glFramebufferTexture1DEXT@20", биб);

		//вяжи(функция_1162)("__glFramebufferTexture2DEXT@20", биб);

		//вяжи(функция_1163)("__glFramebufferTexture3DEXT@24", биб);

		//вяжи(функция_1164)("__glFramebufferTextureLayerEXT@20", биб);

		//вяжи(функция_1165)("__glGenerateMipmapEXT@4", биб);

		//вяжи(функция_1166)("__glGenFragmentShadersATI@4", биб);

		//вяжи(функция_1167)("__glGenFramebuffersEXT@8", биб);

		//вяжи(функция_1168)("__glGenRenderbuffersEXT@8", биб);

		//вяжи(функция_1169)("__glGetActiveAttrib@28", биб);

		//вяжи(функция_1170)("__glGetActiveAttribARB@28", биб);

		//вяжи(функция_1171)("__glGetActiveUniform@28", биб);

		//вяжи(функция_1172)("__glGetActiveUniformARB@28", биб);

		//вяжи(функция_1173)("__glGetAttachedObjectsARB@16", биб);

		//вяжи(функция_1174)("__glGetAttachedShaders@16", биб);

		//вяжи(функция_1175)("__glGetAttribLocation@8", биб);

		//вяжи(функция_1176)("__glGetAttribLocationARB@8", биб);

		//вяжи(функция_1177)("__glGetFramebufferAttachmentParameterivEXT@16", биб);

		//вяжи(функция_1178)("__glGetHandleARB@4", биб);

		//вяжи(функция_1179)("__glGetInfoLogARB@16", биб);

		//вяжи(функция_1180)("__glGetObjectParameterfvARB@12", биб);

		//вяжи(функция_1181)("__glGetObjectParameterivARB@12", биб);

		//вяжи(функция_1182)("__glGetProgramInfoLog@16", биб);

		//вяжи(функция_1183)("__glGetProgramiv@12", биб);

		//вяжи(функция_1184)("__glGetRenderbufferParameterivEXT@12", биб);

		//вяжи(функция_1185)("__glGetShaderInfoLog@16", биб);

		//вяжи(функция_1186)("__glGetShaderiv@12", биб);

		//вяжи(функция_1187)("__glGetShaderSource@16", биб);

		//вяжи(функция_1188)("__glGetShaderSourceARB@16", биб);

		//вяжи(функция_1189)("__glGetUniformfv@12", биб);

		//вяжи(функция_1190)("__glGetUniformfvARB@12", биб);

		//вяжи(функция_1191)("__glGetUniformiv@12", биб);

		//вяжи(функция_1192)("__glGetUniformivARB@12", биб);

		//вяжи(функция_1193)("__glGetUniformLocation@8", биб);

		//вяжи(функция_1194)("__glGetUniformLocationARB@8", биб);

		//вяжи(функция_1195)("__glGetVertexAttribdv@12", биб);

		//вяжи(функция_1196)("__glGetVertexAttribfv@12", биб);

		//вяжи(функция_1197)("__glGetVertexAttribiv@12", биб);

		//вяжи(функция_1198)("__glGetVertexAttribPointerv@12", биб);

		//вяжи(функция_1199)("__glIsFramebufferEXT@4", биб);

		//вяжи(функция_1200)("__glIsProgram@4", биб);

		//вяжи(функция_1201)("__glIsRenderbufferEXT@4", биб);

		//вяжи(функция_1202)("__glIsShader@4", биб);

		//вяжи(функция_1203)("__glLinkProgram@4", биб);

		//вяжи(функция_1204)("__glLinkProgramARB@4", биб);

		//вяжи(функция_1205)("__glPassTexCoordATI@12", биб);

		//вяжи(функция_1206)("__glRenderbufferStorageEXT@16", биб);

		//вяжи(функция_1207)("__glSampleMapATI@12", биб);

		//вяжи(функция_1208)("__glSetFragmentShaderConstantATI@8", биб);

		//вяжи(функция_1209)("__glShaderSource@16", биб);

		//вяжи(функция_1210)("__glShaderSourceARB@16", биб);

		//вяжи(функция_1211)("__glStencilFuncSeparate@16", биб);

		//вяжи(функция_1212)("__glStencilMaskSeparate@8", биб);

		//вяжи(функция_1213)("__glStencilOpSeparate@16", биб);

		//вяжи(функция_1214)("__glUniform1f@8", биб);

		//вяжи(функция_1215)("__glUniform1fARB@8", биб);

		//вяжи(функция_1216)("__glUniform1fv@12", биб);

		//вяжи(функция_1217)("__glUniform1fvARB@12", биб);

		//вяжи(функция_1218)("__glUniform1i@8", биб);

		//вяжи(функция_1219)("__glUniform1iARB@8", биб);

		//вяжи(функция_1220)("__glUniform1iv@12", биб);

		//вяжи(функция_1221)("__glUniform1ivARB@12", биб);

		//вяжи(функция_1222)("__glUniform2f@12", биб);

		//вяжи(функция_1223)("__glUniform2fARB@12", биб);

		//вяжи(функция_1224)("__glUniform2fv@12", биб);

		//вяжи(функция_1225)("__glUniform2fvARB@12", биб);

		//вяжи(функция_1226)("__glUniform2i@12", биб);

		//вяжи(функция_1227)("__glUniform2iARB@12", биб);

		//вяжи(функция_1228)("__glUniform2iv@12", биб);

		//вяжи(функция_1229)("__glUniform2ivARB@12", биб);

		//вяжи(функция_1230)("__glUniform3f@16", биб);

		//вяжи(функция_1231)("__glUniform3fARB@16", биб);

		//вяжи(функция_1232)("__glUniform3fv@12", биб);

		//вяжи(функция_1233)("__glUniform3fvARB@12", биб);

		//вяжи(функция_1234)("__glUniform3i@16", биб);

		//вяжи(функция_1235)("__glUniform3iARB@16", биб);

		//вяжи(функция_1236)("__glUniform3iv@12", биб);

		//вяжи(функция_1237)("__glUniform3ivARB@12", биб);

		//вяжи(функция_1238)("__glUniform4f@20", биб);

		//вяжи(функция_1239)("__glUniform4fARB@20", биб);

		//вяжи(функция_1240)("__glUniform4fv@12", биб);

		//вяжи(функция_1241)("__glUniform4fvARB@12", биб);

		//вяжи(функция_1242)("__glUniform4i@20", биб);

		//вяжи(функция_1243)("__glUniform4iARB@20", биб);

		//вяжи(функция_1244)("__glUniform4iv@12", биб);

		//вяжи(функция_1245)("__glUniform4ivARB@12", биб);

		//вяжи(функция_1246)("__glUniformMatrix2fv@16", биб);

		//вяжи(функция_1247)("__glUniformMatrix2fvARB@16", биб);

		//вяжи(функция_1248)("__glUniformMatrix2x3fv@16", биб);

		//вяжи(функция_1249)("__glUniformMatrix2x4fv@16", биб);

		//вяжи(функция_1250)("__glUniformMatrix3fv@16", биб);

		//вяжи(функция_1251)("__glUniformMatrix3fvARB@16", биб);

		//вяжи(функция_1252)("__glUniformMatrix3x2fv@16", биб);

		//вяжи(функция_1253)("__glUniformMatrix3x4fv@16", биб);

		//вяжи(функция_1254)("__glUniformMatrix4fv@16", биб);

		//вяжи(функция_1255)("__glUniformMatrix4fvARB@16", биб);

		//вяжи(функция_1256)("__glUniformMatrix4x2fv@16", биб);

		//вяжи(функция_1257)("__glUniformMatrix4x3fv@16", биб);

		//вяжи(функция_1258)("__glUseProgram@4", биб);

		//вяжи(функция_1259)("__glUseProgramObjectARB@4", биб);

		//вяжи(функция_1260)("__glValidateProgram@4", биб);

		//вяжи(функция_1261)("__glValidateProgramARB@4", биб);

		//вяжи(функция_1262)("__glVertexAttrib1d@12", биб);

		//вяжи(функция_1263)("__glVertexAttrib1dv@8", биб);

		//вяжи(функция_1264)("__glVertexAttrib1f@8", биб);

		//вяжи(функция_1265)("__glVertexAttrib1fv@8", биб);

		//вяжи(функция_1266)("__glVertexAttrib1s@8", биб);

		//вяжи(функция_1267)("__glVertexAttrib1sv@8", биб);

		//вяжи(функция_1268)("__glVertexAttrib2d@20", биб);

		//вяжи(функция_1269)("__glVertexAttrib2dv@8", биб);

		//вяжи(функция_1270)("__glVertexAttrib2f@12", биб);

		//вяжи(функция_1271)("__glVertexAttrib2fv@8", биб);

		//вяжи(функция_1272)("__glVertexAttrib2s@12", биб);

		//вяжи(функция_1273)("__glVertexAttrib2sv@8", биб);

		//вяжи(функция_1274)("__glVertexAttrib3d@28", биб);

		//вяжи(функция_1275)("__glVertexAttrib3dv@8", биб);

		//вяжи(функция_1276)("__glVertexAttrib3f@16", биб);

		//вяжи(функция_1277)("__glVertexAttrib3fv@8", биб);

		//вяжи(функция_1278)("__glVertexAttrib3s@16", биб);

		//вяжи(функция_1279)("__glVertexAttrib3sv@8", биб);

		//вяжи(функция_1280)("__glVertexAttrib4bv@8", биб);

		//вяжи(функция_1281)("__glVertexAttrib4d@36", биб);

		//вяжи(функция_1282)("__glVertexAttrib4dv@8", биб);

		//вяжи(функция_1283)("__glVertexAttrib4f@20", биб);

		//вяжи(функция_1284)("__glVertexAttrib4fv@8", биб);

		//вяжи(функция_1285)("__glVertexAttrib4iv@8", биб);

		//вяжи(функция_1286)("__glVertexAttrib4Nbv@8", биб);

		//вяжи(функция_1287)("__glVertexAttrib4Niv@8", биб);

		//вяжи(функция_1288)("__glVertexAttrib4Nsv@8", биб);

		//вяжи(функция_1289)("__glVertexAttrib4Nub@20", биб);

		//вяжи(функция_1290)("__glVertexAttrib4Nubv@8", биб);

		//вяжи(функция_1291)("__glVertexAttrib4Nuiv@8", биб);

		//вяжи(функция_1292)("__glVertexAttrib4Nusv@8", биб);

		//вяжи(функция_1293)("__glVertexAttrib4s@20", биб);

		//вяжи(функция_1294)("__glVertexAttrib4sv@8", биб);

		//вяжи(функция_1295)("__glVertexAttrib4ubv@8", биб);

		//вяжи(функция_1296)("__glVertexAttrib4uiv@8", биб);

		//вяжи(функция_1297)("__glVertexAttrib4usv@8", биб);

		//вяжи(функция_1298)("__glVertexAttribPointer@24", биб);

		//вяжи(функция_1299)("__mesa_add_renderbuffer", биб);

		//вяжи(функция_1300)("__mesa_add_soft_renderbuffers", биб);

		//вяжи(функция_1301)("__mesa_begin_query", биб);

		//вяжи(функция_1302)("__mesa_buffer_data", биб);

		//вяжи(функция_1303)("__mesa_buffer_get_subdata", биб);

		//вяжи(функция_1304)("__mesa_buffer_map", биб);

		//вяжи(функция_1305)("__mesa_buffer_subdata", биб);

		//вяжи(функция_1306)("__mesa_buffer_unmap", биб);

		//вяжи(функция_1307)("__mesa_bzero", биб);

		//вяжи(функция_1308)("__mesa_calloc", биб);

		//вяжи(функция_1309)("__mesa_choose_tex_format", биб);

		//вяжи(функция_1310)("__mesa_compressed_texture_size", биб);

		//вяжи(функция_1311)("__mesa_create_framebuffer", биб);

		//вяжи(функция_1312)("__mesa_create_visual", биб);

		//вяжи(функция_1313)("__mesa_delete_array_object", биб);

		//вяжи(функция_1314)("__mesa_delete_buffer_object", биб);

		//вяжи(функция_1315)("__mesa_delete_program", биб);

		//вяжи(функция_1316)("__mesa_delete_query", биб);

		//вяжи(функция_1317)("__mesa_delete_texture_object", биб);

		//вяжи(функция_1318)("__mesa_destroy_framebuffer", биб);

		//вяжи(функция_1319)("__mesa_destroy_visual", биб);

		//вяжи(функция_1320)("__mesa_enable_1_3_extensions", биб);

		//вяжи(функция_1321)("__mesa_enable_1_4_extensions", биб);

		//вяжи(функция_1322)("__mesa_enable_1_5_extensions", биб);

		//вяжи(функция_1323)("__mesa_enable_2_0_extensions", биб);

		//вяжи(функция_1324)("__mesa_enable_2_1_extensions", биб);

		//вяжи(функция_1325)("__mesa_enable_sw_extensions", биб);

		//вяжи(функция_1326)("__mesa_end_query", биб);

		//вяжи(функция_1327)("__mesa_error", биб);

		//вяжи(функция_1328)("__mesa_finish_render_texture", биб);

		//вяжи(функция_1329)("__mesa_framebuffer_renderbuffer", биб);

		//вяжи(функция_1330)("__mesa_free", биб);

		//вяжи(функция_1331)("__mesa_free_context_data", биб);

		//вяжи(функция_1332)("__mesa_free_texture_image_data", биб);

		//вяжи(функция_1333)("__mesa_generate_mipmap", биб);

		//вяжи(функция_1334)("__mesa_get_compressed_teximage", биб);

		//вяжи(функция_1335)("__mesa_get_current_context", биб);

		//вяжи(функция_1336)("__mesa_get_program_register", биб);

		//вяжи(функция_1337)("__mesa_get_teximage", биб);

		//вяжи(функция_1338)("__mesa_init_driver_functions", биб);

		//вяжи(функция_1339)("__mesa_init_glsl_driver_functions", биб);

		//вяжи(функция_1340)("__mesa_init_renderbuffer", биб);

		//вяжи(функция_1341)("__mesa_initialize_context", биб);

		//вяжи(функция_1342)("__mesa_make_current", биб);

		//вяжи(функция_1343)("__mesa_memcpy", биб);

		//вяжи(функция_1344)("__mesa_memset", биб);

		//вяжи(функция_1345)("__mesa_new_array_object", биб);

		//вяжи(функция_1346)("__mesa_new_buffer_object", биб);

		//вяжи(функция_1347)("__mesa_new_framebuffer", биб);

		//вяжи(функция_1348)("__mesa_new_program", биб);

		//вяжи(функция_1349)("__mesa_new_query_object", биб);

		//вяжи(функция_1350)("__mesa_new_renderbuffer", биб);

		//вяжи(функция_1351)("__mesa_new_soft_renderbuffer", биб);

		//вяжи(функция_1352)("__mesa_new_texture_image", биб);

		//вяжи(функция_1353)("__mesa_new_texture_object", биб);

		//вяжи(функция_1354)("__mesa_problem", биб);

		//вяжи(функция_1355)("__mesa_reference_renderbuffer", биб);

		//вяжи(функция_1356)("__mesa_remove_renderbuffer", биб);

		//вяжи(функция_1357)("__mesa_render_texture", биб);

		//вяжи(функция_1358)("__mesa_resize_framebuffer", биб);

		//вяжи(функция_1359)("__mesa_ResizeBuffersMESA", биб);

		//вяжи(функция_1360)("__mesa_store_compressed_teximage1d", биб);

		//вяжи(функция_1361)("__mesa_store_compressed_teximage2d", биб);

		//вяжи(функция_1362)("__mesa_store_compressed_teximage3d", биб);

		//вяжи(функция_1363)("__mesa_store_compressed_texsubimage1d", биб);

		//вяжи(функция_1364)("__mesa_store_compressed_texsubimage2d", биб);

		//вяжи(функция_1365)("__mesa_store_compressed_texsubimage3d", биб);

		//вяжи(функция_1366)("__mesa_store_teximage1d", биб);

		//вяжи(функция_1367)("__mesa_store_teximage2d", биб);

		//вяжи(функция_1368)("__mesa_store_teximage3d", биб);

		//вяжи(функция_1369)("__mesa_store_texsubimage1d", биб);

		//вяжи(функция_1370)("__mesa_store_texsubimage2d", биб);

		//вяжи(функция_1371)("__mesa_store_texsubimage3d", биб);

		//вяжи(функция_1372)("__mesa_strcmp", биб);

		//вяжи(функция_1373)("__mesa_test_proxy_teximage", биб);

		//вяжи(функция_1374)("__mesa_unreference_framebuffer", биб);

		//вяжи(функция_1375)("__mesa_update_framebuffer_visual", биб);

		//вяжи(функция_1376)("__mesa_use_program", биб);

		//вяжи(функция_1377)("__mesa_Viewport", биб);

		//вяжи(функция_1378)("__mesa_wait_query", биб);

		//вяжи(функция_1379)("__swrast_Accum", биб);

		//вяжи(функция_1380)("__swrast_Bitmap", биб);

		//вяжи(функция_1381)("__swrast_BlitFramebuffer", биб);

		//вяжи(функция_1382)("__swrast_choose_line", биб);

		//вяжи(функция_1383)("__swrast_choose_triangle", биб);

		//вяжи(функция_1384)("__swrast_Clear", биб);

		//вяжи(функция_1385)("__swrast_copy_teximage1d", биб);

		//вяжи(функция_1386)("__swrast_copy_teximage2d", биб);

		//вяжи(функция_1387)("__swrast_copy_texsubimage1d", биб);

		//вяжи(функция_1388)("__swrast_copy_texsubimage2d", биб);

		//вяжи(функция_1389)("__swrast_copy_texsubimage3d", биб);

		//вяжи(функция_1390)("__swrast_CopyColorSubTable", биб);

		//вяжи(функция_1391)("__swrast_CopyColorTable", биб);

		//вяжи(функция_1392)("__swrast_CopyConvolutionFilter1D", биб);

		//вяжи(функция_1393)("__swrast_CopyConvolutionFilter2D", биб);

		//вяжи(функция_1394)("__swrast_CopyPixels", биб);

		//вяжи(функция_1395)("__swrast_CreateContext", биб);

		//вяжи(функция_1396)("__swrast_DestroyContext", биб);

		//вяжи(функция_1397)("__swrast_DrawPixels", биб);

		//вяжи(функция_1398)("__swrast_exec_fragment_program", биб);

		//вяжи(функция_1399)("__swrast_GetDeviceDriverReference", биб);

		//вяжи(функция_1400)("__swrast_InvalidateState", биб);

		//вяжи(функция_1401)("__swrast_ReadPixels", биб);

		//вяжи(функция_1402)("__swsetup_CreateContext", биб);

		//вяжи(функция_1403)("__swsetup_DestroyContext", биб);

		//вяжи(функция_1404)("__swsetup_InvalidateState", биб);

		//вяжи(функция_1405)("__swsetup_Wakeup", биб);

		//вяжи(функция_1406)("__tnl_CreateContext", биб);

		//вяжи(функция_1407)("__tnl_DestroyContext", биб);

		//вяжи(функция_1408)("__tnl_InvalidateState", биб);

		//вяжи(функция_1409)("__tnl_program_string", биб);

		//вяжи(функция_1410)("__tnl_RasterPos", биб);

		//вяжи(функция_1411)("__tnl_run_pipeline", биб);

		//вяжи(функция_1412)("__vbo_CreateContext", биб);

		//вяжи(функция_1413)("__vbo_DestroyContext", биб);

		//вяжи(функция_1414)("__vbo_InvalidateState", биб);

		//вяжи(функция_1415)("_glAccum", биб);

		//вяжи(функция_1416)("_glActiveTexture", биб);

		//вяжи(функция_1417)("_glActiveTextureARB", биб);

		//вяжи(функция_1418)("_glAlphaFunc", биб);

		//вяжи(функция_1419)("_glAreProgramsResidentNV", биб);

		//вяжи(функция_1420)("_glAreTexturesResident", биб);

		//вяжи(функция_1421)("_glAreTexturesResidentEXT", биб);

		//вяжи(функция_1422)("_glArrayElement", биб);

		//вяжи(функция_1423)("_glArrayElementEXT", биб);

		//вяжи(функция_1424)("_glBegin", биб);

		//вяжи(функция_1425)("_glBeginQuery", биб);

		//вяжи(функция_1426)("_glBeginQueryARB", биб);

		//вяжи(функция_1427)("_glBindBuffer", биб);

		//вяжи(функция_1428)("_glBindBufferARB", биб);

		//вяжи(функция_1429)("_glBindProgramARB", биб);

		//вяжи(функция_1430)("_glBindProgramNV", биб);

		//вяжи(функция_1431)("_glBindTexture", биб);

		//вяжи(функция_1432)("_glBindTextureEXT", биб);

		//вяжи(функция_1433)("_glBitmap", биб);

		//вяжи(функция_1434)("_glBlendColor", биб);

		//вяжи(функция_1435)("_glBlendColorEXT", биб);

		//вяжи(функция_1436)("_glBlendEquation", биб);

		//вяжи(функция_1437)("_glBlendEquationEXT", биб);

		//вяжи(функция_1438)("_glBlendFunc", биб);

		//вяжи(функция_1439)("_glBlendFuncSeparateEXT", биб);

		//вяжи(функция_1440)("_glBufferData", биб);

		//вяжи(функция_1441)("_glBufferDataARB", биб);

		//вяжи(функция_1442)("_glBufferSubData", биб);

		//вяжи(функция_1443)("_glBufferSubDataARB", биб);

		//вяжи(функция_1444)("_glCallList", биб);

		//вяжи(функция_1445)("_glCallLists", биб);

		//вяжи(функция_1446)("_glClear", биб);

		//вяжи(функция_1447)("_glClearAccum", биб);

		//вяжи(функция_1448)("_glClearColor", биб);

		//вяжи(функция_1449)("_glClearDepth", биб);

		//вяжи(функция_1450)("_glClearIndex", биб);

		//вяжи(функция_1451)("_glClearStencil", биб);

		//вяжи(функция_1452)("_glClientActiveTexture", биб);

		//вяжи(функция_1453)("_glClientActiveTextureARB", биб);

		//вяжи(функция_1454)("_glClipPlane", биб);

		//вяжи(функция_1455)("_glColor3b", биб);

		//вяжи(функция_1456)("_glColor3bv", биб);

		//вяжи(функция_1457)("_glColor3d", биб);

		//вяжи(функция_1458)("_glColor3dv", биб);

		//вяжи(функция_1459)("_glColor3f", биб);

		//вяжи(функция_1460)("_glColor3fv", биб);

		//вяжи(функция_1461)("_glColor3i", биб);

		//вяжи(функция_1462)("_glColor3iv", биб);

		//вяжи(функция_1463)("_glColor3s", биб);

		//вяжи(функция_1464)("_glColor3sv", биб);

		//вяжи(функция_1465)("_glColor3ub", биб);

		//вяжи(функция_1466)("_glColor3ubv", биб);

		//вяжи(функция_1467)("_glColor3ui", биб);

		//вяжи(функция_1468)("_glColor3uiv", биб);

		//вяжи(функция_1469)("_glColor3us", биб);

		//вяжи(функция_1470)("_glColor3usv", биб);

		//вяжи(функция_1471)("_glColor4b", биб);

		//вяжи(функция_1472)("_glColor4bv", биб);

		//вяжи(функция_1473)("_glColor4d", биб);

		//вяжи(функция_1474)("_glColor4dv", биб);

		//вяжи(функция_1475)("_glColor4f", биб);

		//вяжи(функция_1476)("_glColor4fv", биб);

		//вяжи(функция_1477)("_glColor4i", биб);

		//вяжи(функция_1478)("_glColor4iv", биб);

		//вяжи(функция_1479)("_glColor4s", биб);

		//вяжи(функция_1480)("_glColor4sv", биб);

		//вяжи(функция_1481)("_glColor4ub", биб);

		//вяжи(функция_1482)("_glColor4ubv", биб);

		//вяжи(функция_1483)("_glColor4ui", биб);

		//вяжи(функция_1484)("_glColor4uiv", биб);

		//вяжи(функция_1485)("_glColor4us", биб);

		//вяжи(функция_1486)("_glColor4usv", биб);

		//вяжи(функция_1487)("_glColorMask", биб);

		//вяжи(функция_1488)("_glColorMaterial", биб);

		//вяжи(функция_1489)("_glColorPointer", биб);

		//вяжи(функция_1490)("_glColorPointerEXT", биб);

		//вяжи(функция_1491)("_glColorSubTable", биб);

		//вяжи(функция_1492)("_glColorTable", биб);

		//вяжи(функция_1493)("_glColorTableEXT", биб);

		//вяжи(функция_1494)("_glColorTableParameterfv", биб);

		//вяжи(функция_1495)("_glColorTableParameteriv", биб);

		//вяжи(функция_1496)("_glCombinerInputNV", биб);

		//вяжи(функция_1497)("_glCombinerOutputNV", биб);

		//вяжи(функция_1498)("_glCombinerParameterfNV", биб);

		//вяжи(функция_1499)("_glCombinerParameterfvNV", биб);

		//вяжи(функция_1500)("_glCombinerParameteriNV", биб);

		//вяжи(функция_1501)("_glCombinerParameterivNV", биб);

		//вяжи(функция_1502)("_glCompressedTexImage1D", биб);

		//вяжи(функция_1503)("_glCompressedTexImage1DARB", биб);

		//вяжи(функция_1504)("_glCompressedTexImage2D", биб);

		//вяжи(функция_1505)("_glCompressedTexImage2DARB", биб);

		//вяжи(функция_1506)("_glCompressedTexImage3D", биб);

		//вяжи(функция_1507)("_glCompressedTexImage3DARB", биб);

		//вяжи(функция_1508)("_glCompressedTexSubImage1D", биб);

		//вяжи(функция_1509)("_glCompressedTexSubImage1DARB", биб);

		//вяжи(функция_1510)("_glCompressedTexSubImage2D", биб);

		//вяжи(функция_1511)("_glCompressedTexSubImage2DARB", биб);

		//вяжи(функция_1512)("_glCompressedTexSubImage3D", биб);

		//вяжи(функция_1513)("_glCompressedTexSubImage3DARB", биб);

		//вяжи(функция_1514)("_glConvolutionFilter1D", биб);

		//вяжи(функция_1515)("_glConvolutionFilter2D", биб);

		//вяжи(функция_1516)("_glConvolutionParameterf", биб);

		//вяжи(функция_1517)("_glConvolutionParameterfv", биб);

		//вяжи(функция_1518)("_glConvolutionParameteri", биб);

		//вяжи(функция_1519)("_glConvolutionParameteriv", биб);

		//вяжи(функция_1520)("_glCopyColorSubTable", биб);

		//вяжи(функция_1521)("_glCopyColorTable", биб);

		//вяжи(функция_1522)("_glCopyConvolutionFilter1D", биб);

		//вяжи(функция_1523)("_glCopyConvolutionFilter2D", биб);

		//вяжи(функция_1524)("_glCopyPixels", биб);

		//вяжи(функция_1525)("_glCopyTexImage1D", биб);

		//вяжи(функция_1526)("_glCopyTexImage1DEXT", биб);

		//вяжи(функция_1527)("_glCopyTexImage2D", биб);

		//вяжи(функция_1528)("_glCopyTexImage2DEXT", биб);

		//вяжи(функция_1529)("_glCopyTexSubImage1D", биб);

		//вяжи(функция_1530)("_glCopyTexSubImage1DEXT", биб);

		//вяжи(функция_1531)("_glCopyTexSubImage2D", биб);

		//вяжи(функция_1532)("_glCopyTexSubImage2DEXT", биб);

		//вяжи(функция_1533)("_glCopyTexSubImage3D", биб);

		//вяжи(функция_1534)("_glCopyTexSubImage3DEXT", биб);

		//вяжи(функция_1535)("_glCullFace", биб);

		//вяжи(функция_1536)("_glDeleteBuffers", биб);

		//вяжи(функция_1537)("_glDeleteBuffersARB", биб);

		//вяжи(функция_1538)("_glDeleteLists", биб);

		//вяжи(функция_1539)("_glDeleteProgramsARB", биб);

		//вяжи(функция_1540)("_glDeleteProgramsNV", биб);

		//вяжи(функция_1541)("_glDeleteQueries", биб);

		//вяжи(функция_1542)("_glDeleteQueriesARB", биб);

		//вяжи(функция_1543)("_glDeleteTextures", биб);

		//вяжи(функция_1544)("_glDeleteTexturesEXT", биб);

		//вяжи(функция_1545)("_glDepthFunc", биб);

		//вяжи(функция_1546)("_glDepthMask", биб);

		//вяжи(функция_1547)("_glDepthRange", биб);

		//вяжи(функция_1548)("_glDisable", биб);

		//вяжи(функция_1549)("_glDisableClientState", биб);

		//вяжи(функция_1550)("_glDisableVertexAttribArrayARB", биб);

		//вяжи(функция_1551)("_glDrawArrays", биб);

		//вяжи(функция_1552)("_glDrawArraysEXT", биб);

		//вяжи(функция_1553)("_glDrawBuffer", биб);

		//вяжи(функция_1554)("_glDrawElements", биб);

		//вяжи(функция_1555)("_glDrawPixels", биб);

		//вяжи(функция_1556)("_glDrawRangeElements", биб);

		//вяжи(функция_1557)("_glDrawRangeElementsEXT", биб);

		//вяжи(функция_1558)("_glEdgeFlag", биб);

		//вяжи(функция_1559)("_glEdgeFlagPointer", биб);

		//вяжи(функция_1560)("_glEdgeFlagPointerEXT", биб);

		//вяжи(функция_1561)("_glEdgeFlagv", биб);

		//вяжи(функция_1562)("_glEnable", биб);

		//вяжи(функция_1563)("_glEnableClientState", биб);

		//вяжи(функция_1564)("_glEnableVertexAttribArrayARB", биб);

		//вяжи(функция_1565)("_glEnd", биб);

		//вяжи(функция_1566)("_glEndList", биб);

		//вяжи(функция_1567)("_glEndQuery", биб);

		//вяжи(функция_1568)("_glEndQueryARB", биб);

		//вяжи(функция_1569)("_glEvalCoord1d", биб);

		//вяжи(функция_1570)("_glEvalCoord1dv", биб);

		//вяжи(функция_1571)("_glEvalCoord1f", биб);

		//вяжи(функция_1572)("_glEvalCoord1fv", биб);

		//вяжи(функция_1573)("_glEvalCoord2d", биб);

		//вяжи(функция_1574)("_glEvalCoord2dv", биб);

		//вяжи(функция_1575)("_glEvalCoord2f", биб);

		//вяжи(функция_1576)("_glEvalCoord2fv", биб);

		//вяжи(функция_1577)("_glEvalMesh1", биб);

		//вяжи(функция_1578)("_glEvalMesh2", биб);

		//вяжи(функция_1579)("_glEvalPoint1", биб);

		//вяжи(функция_1580)("_glEvalPoint2", биб);

		//вяжи(функция_1581)("_glExecuteProgramNV", биб);

		//вяжи(функция_1582)("_glFeedbackBuffer", биб);

		//вяжи(функция_1583)("_glFinalCombinerInputNV", биб);

		//вяжи(функция_1584)("_glFinish", биб);

		//вяжи(функция_1585)("_glFlush", биб);

		//вяжи(функция_1586)("_glFlushVertexArrayRangeNV", биб);

		//вяжи(функция_1587)("_glFogCoordd", биб);

		//вяжи(функция_1588)("_glFogCoorddEXT", биб);

		//вяжи(функция_1589)("_glFogCoorddv", биб);

		//вяжи(функция_1590)("_glFogCoorddvEXT", биб);

		//вяжи(функция_1591)("_glFogCoordf", биб);

		//вяжи(функция_1592)("_glFogCoordfEXT", биб);

		//вяжи(функция_1593)("_glFogCoordfv", биб);

		//вяжи(функция_1594)("_glFogCoordfvEXT", биб);

		//вяжи(функция_1595)("_glFogCoordPointer", биб);

		//вяжи(функция_1596)("_glFogCoordPointerEXT", биб);

		//вяжи(функция_1597)("_glFogf", биб);

		//вяжи(функция_1598)("_glFogfv", биб);

		//вяжи(функция_1599)("_glFogi", биб);

		//вяжи(функция_1600)("_glFogiv", биб);

		//вяжи(функция_1601)("_glFrontFace", биб);

		//вяжи(функция_1602)("_glFrustum", биб);

		//вяжи(функция_1603)("_glGenBuffers", биб);

		//вяжи(функция_1604)("_glGenBuffersARB", биб);

		//вяжи(функция_1605)("_glGenLists", биб);

		//вяжи(функция_1606)("_glGenProgramsARB", биб);

		//вяжи(функция_1607)("_glGenProgramsNV", биб);

		//вяжи(функция_1608)("_glGenQueries", биб);

		//вяжи(функция_1609)("_glGenQueriesARB", биб);

		//вяжи(функция_1610)("_glGenTextures", биб);

		//вяжи(функция_1611)("_glGenTexturesEXT", биб);

		//вяжи(функция_1612)("_glGetBooleanv", биб);

		//вяжи(функция_1613)("_glGetBufferParameteriv", биб);

		//вяжи(функция_1614)("_glGetBufferParameterivARB", биб);

		//вяжи(функция_1615)("_glGetBufferPointerv", биб);

		//вяжи(функция_1616)("_glGetBufferPointervARB", биб);

		//вяжи(функция_1617)("_glGetBufferSubData", биб);

		//вяжи(функция_1618)("_glGetBufferSubDataARB", биб);

		//вяжи(функция_1619)("_glGetClipPlane", биб);

		//вяжи(функция_1620)("_glGetColorTable", биб);

		//вяжи(функция_1621)("_glGetColorTableEXT", биб);

		//вяжи(функция_1622)("_glGetColorTableParameterfv", биб);

		//вяжи(функция_1623)("_glGetColorTableParameterfvEXT", биб);

		//вяжи(функция_1624)("_glGetColorTableParameteriv", биб);

		//вяжи(функция_1625)("_glGetColorTableParameterivEXT", биб);

		//вяжи(функция_1626)("_glGetCombinerInputParameterfvNV", биб);

		//вяжи(функция_1627)("_glGetCombinerInputParameterivNV", биб);

		//вяжи(функция_1628)("_glGetCombinerOutputParameterfvNV", биб);

		//вяжи(функция_1629)("_glGetCombinerOutputParameterivNV", биб);

		//вяжи(функция_1630)("_glGetCompressedTexImage", биб);

		//вяжи(функция_1631)("_glGetCompressedTexImageARB", биб);

		//вяжи(функция_1632)("_glGetConvolutionFilter", биб);

		//вяжи(функция_1633)("_glGetConvolutionParameterfv", биб);

		//вяжи(функция_1634)("_glGetConvolutionParameteriv", биб);

		//вяжи(функция_1635)("_glGetDoublev", биб);

		//вяжи(функция_1636)("_glGetError", биб);

		//вяжи(функция_1637)("_glGetFinalCombinerInputParameterfvNV", биб);

		//вяжи(функция_1638)("_glGetFinalCombinerInputParameterivNV", биб);

		//вяжи(функция_1639)("_glGetFloatv", биб);

		//вяжи(функция_1640)("_glGetHistogram", биб);

		//вяжи(функция_1641)("_glGetHistogramParameterfv", биб);

		//вяжи(функция_1642)("_glGetHistogramParameteriv", биб);

		//вяжи(функция_1643)("_glGetIntegerv", биб);

		//вяжи(функция_1644)("_glGetLightfv", биб);

		//вяжи(функция_1645)("_glGetLightiv", биб);

		//вяжи(функция_1646)("_glGetMapdv", биб);

		//вяжи(функция_1647)("_glGetMapfv", биб);

		//вяжи(функция_1648)("_glGetMapiv", биб);

		//вяжи(функция_1649)("_glGetMaterialfv", биб);

		//вяжи(функция_1650)("_glGetMaterialiv", биб);

		//вяжи(функция_1651)("_glGetMinmax", биб);

		//вяжи(функция_1652)("_glGetMinmaxParameterfv", биб);

		//вяжи(функция_1653)("_glGetMinmaxParameteriv", биб);

		//вяжи(функция_1654)("_glGetPixelMapfv", биб);

		//вяжи(функция_1655)("_glGetPixelMapuiv", биб);

		//вяжи(функция_1656)("_glGetPixelMapusv", биб);

		//вяжи(функция_1657)("_glGetPointerv", биб);

		//вяжи(функция_1658)("_glGetPointervEXT", биб);

		//вяжи(функция_1659)("_glGetPolygonStipple", биб);

		//вяжи(функция_1660)("_glGetProgramEnvParameterdvARB", биб);

		//вяжи(функция_1661)("_glGetProgramEnvParameterfvARB", биб);

		//вяжи(функция_1662)("_glGetProgramivARB", биб);

		//вяжи(функция_1663)("_glGetProgramivNV", биб);

		//вяжи(функция_1664)("_glGetProgramLocalParameterdvARB", биб);

		//вяжи(функция_1665)("_glGetProgramLocalParameterfvARB", биб);

		//вяжи(функция_1666)("_glGetProgramNamedParameterdvNV", биб);

		//вяжи(функция_1667)("_glGetProgramNamedParameterfvNV", биб);

		//вяжи(функция_1668)("_glGetProgramParameterdvNV", биб);

		//вяжи(функция_1669)("_glGetProgramParameterfvNV", биб);

		//вяжи(функция_1670)("_glGetProgramStringARB", биб);

		//вяжи(функция_1671)("_glGetProgramStringNV", биб);

		//вяжи(функция_1672)("_glGetQueryiv", биб);

		//вяжи(функция_1673)("_glGetQueryivARB", биб);

		//вяжи(функция_1674)("_glGetQueryObjectiv", биб);

		//вяжи(функция_1675)("_glGetQueryObjectivARB", биб);

		//вяжи(функция_1676)("_glGetQueryObjectuiv", биб);

		//вяжи(функция_1677)("_glGetQueryObjectuivARB", биб);

		//вяжи(функция_1678)("_glGetSeparableFilter", биб);

		//вяжи(функция_1679)("_glGetString", биб);

		//вяжи(функция_1680)("_glGetTexEnvfv", биб);

		//вяжи(функция_1681)("_glGetTexEnviv", биб);

		//вяжи(функция_1682)("_glGetTexGendv", биб);

		//вяжи(функция_1683)("_glGetTexGenfv", биб);

		//вяжи(функция_1684)("_glGetTexGeniv", биб);

		//вяжи(функция_1685)("_glGetTexImage", биб);

		//вяжи(функция_1686)("_glGetTexLevelParameterfv", биб);

		//вяжи(функция_1687)("_glGetTexLevelParameteriv", биб);

		//вяжи(функция_1688)("_glGetTexParameterfv", биб);

		//вяжи(функция_1689)("_glGetTexParameteriv", биб);

		//вяжи(функция_1690)("_glGetTrackMatrixivNV", биб);

		//вяжи(функция_1691)("_glGetVertexAttribdvARB", биб);

		//вяжи(функция_1692)("_glGetVertexAttribdvNV", биб);

		//вяжи(функция_1693)("_glGetVertexAttribfvARB", биб);

		//вяжи(функция_1694)("_glGetVertexAttribfvNV", биб);

		//вяжи(функция_1695)("_glGetVertexAttribivARB", биб);

		//вяжи(функция_1696)("_glGetVertexAttribivNV", биб);

		//вяжи(функция_1697)("_glGetVertexAttribPointervARB", биб);

		//вяжи(функция_1698)("_glGetVertexAttribPointervNV", биб);

		//вяжи(функция_1699)("_glHint", биб);

		//вяжи(функция_1700)("_glHistogram", биб);

		//вяжи(функция_1701)("_glIndexd", биб);

		//вяжи(функция_1702)("_glIndexdv", биб);

		//вяжи(функция_1703)("_glIndexf", биб);

		//вяжи(функция_1704)("_glIndexfv", биб);

		//вяжи(функция_1705)("_glIndexi", биб);

		//вяжи(функция_1706)("_glIndexiv", биб);

		//вяжи(функция_1707)("_glIndexMask", биб);

		//вяжи(функция_1708)("_glIndexPointer", биб);

		//вяжи(функция_1709)("_glIndexPointerEXT", биб);

		//вяжи(функция_1710)("_glIndexs", биб);

		//вяжи(функция_1711)("_glIndexsv", биб);

		//вяжи(функция_1712)("_glIndexub", биб);

		//вяжи(функция_1713)("_glIndexubv", биб);

		//вяжи(функция_1714)("_glInitNames", биб);

		//вяжи(функция_1715)("_glInterleavedArrays", биб);

		//вяжи(функция_1716)("_glIsBuffer", биб);

		//вяжи(функция_1717)("_glIsBufferARB", биб);

		//вяжи(функция_1718)("_glIsEnabled", биб);

		//вяжи(функция_1719)("_glIsList", биб);

		//вяжи(функция_1720)("_glIsProgramARB", биб);

		//вяжи(функция_1721)("_glIsProgramNV", биб);

		//вяжи(функция_1722)("_glIsQuery", биб);

		//вяжи(функция_1723)("_glIsQueryARB", биб);

		//вяжи(функция_1724)("_glIsTexture", биб);

		//вяжи(функция_1725)("_glIsTextureEXT", биб);

		//вяжи(функция_1726)("_glLightf", биб);

		//вяжи(функция_1727)("_glLightfv", биб);

		//вяжи(функция_1728)("_glLighti", биб);

		//вяжи(функция_1729)("_glLightiv", биб);

		//вяжи(функция_1730)("_glLightModelf", биб);

		//вяжи(функция_1731)("_glLightModelfv", биб);

		//вяжи(функция_1732)("_glLightModeli", биб);

		//вяжи(функция_1733)("_glLightModeliv", биб);

		//вяжи(функция_1734)("_glLineStipple", биб);

		//вяжи(функция_1735)("_glLineWidth", биб);

		//вяжи(функция_1736)("_glListBase", биб);

		//вяжи(функция_1737)("_glLoadIdentity", биб);

		//вяжи(функция_1738)("_glLoadMatrixd", биб);

		//вяжи(функция_1739)("_glLoadMatrixf", биб);

		//вяжи(функция_1740)("_glLoadName", биб);

		//вяжи(функция_1741)("_glLoadProgramNV", биб);

		//вяжи(функция_1742)("_glLoadTransposeMatrixd", биб);

		//вяжи(функция_1743)("_glLoadTransposeMatrixdARB", биб);

		//вяжи(функция_1744)("_glLoadTransposeMatrixf", биб);

		//вяжи(функция_1745)("_glLoadTransposeMatrixfARB", биб);

		//вяжи(функция_1746)("_glLockArraysEXT", биб);

		//вяжи(функция_1747)("_glLogicOp", биб);

		//вяжи(функция_1748)("_glMap1d", биб);

		//вяжи(функция_1749)("_glMap1f", биб);

		//вяжи(функция_1750)("_glMap2d", биб);

		//вяжи(функция_1751)("_glMap2f", биб);

		//вяжи(функция_1752)("_glMapBuffer", биб);

		//вяжи(функция_1753)("_glMapBufferARB", биб);

		//вяжи(функция_1754)("_glMapGrid1d", биб);

		//вяжи(функция_1755)("_glMapGrid1f", биб);

		//вяжи(функция_1756)("_glMapGrid2d", биб);

		//вяжи(функция_1757)("_glMapGrid2f", биб);

		//вяжи(функция_1758)("_glMaterialf", биб);

		//вяжи(функция_1759)("_glMaterialfv", биб);

		//вяжи(функция_1760)("_glMateriali", биб);

		//вяжи(функция_1761)("_glMaterialiv", биб);

		//вяжи(функция_1762)("_glMatrixMode", биб);

		//вяжи(функция_1763)("_glMinmax", биб);

		//вяжи(функция_1764)("_glMultiDrawArrays", биб);

		//вяжи(функция_1765)("_glMultiDrawArraysEXT", биб);

		//вяжи(функция_1766)("_glMultiDrawElements", биб);

		//вяжи(функция_1767)("_glMultiDrawElementsEXT", биб);

		//вяжи(функция_1768)("_glMultiTexCoord1d", биб);

		//вяжи(функция_1769)("_glMultiTexCoord1dARB", биб);

		//вяжи(функция_1770)("_glMultiTexCoord1dv", биб);

		//вяжи(функция_1771)("_glMultiTexCoord1dvARB", биб);

		//вяжи(функция_1772)("_glMultiTexCoord1f", биб);

		//вяжи(функция_1773)("_glMultiTexCoord1fARB", биб);

		//вяжи(функция_1774)("_glMultiTexCoord1fv", биб);

		//вяжи(функция_1775)("_glMultiTexCoord1fvARB", биб);

		//вяжи(функция_1776)("_glMultiTexCoord1i", биб);

		//вяжи(функция_1777)("_glMultiTexCoord1iARB", биб);

		//вяжи(функция_1778)("_glMultiTexCoord1iv", биб);

		//вяжи(функция_1779)("_glMultiTexCoord1ivARB", биб);

		//вяжи(функция_1780)("_glMultiTexCoord1s", биб);

		//вяжи(функция_1781)("_glMultiTexCoord1sARB", биб);

		//вяжи(функция_1782)("_glMultiTexCoord1sv", биб);

		//вяжи(функция_1783)("_glMultiTexCoord1svARB", биб);

		//вяжи(функция_1784)("_glMultiTexCoord2d", биб);

		//вяжи(функция_1785)("_glMultiTexCoord2dARB", биб);

		//вяжи(функция_1786)("_glMultiTexCoord2dv", биб);

		//вяжи(функция_1787)("_glMultiTexCoord2dvARB", биб);

		//вяжи(функция_1788)("_glMultiTexCoord2f", биб);

		//вяжи(функция_1789)("_glMultiTexCoord2fARB", биб);

		//вяжи(функция_1790)("_glMultiTexCoord2fv", биб);

		//вяжи(функция_1791)("_glMultiTexCoord2fvARB", биб);

		//вяжи(функция_1792)("_glMultiTexCoord2i", биб);

		//вяжи(функция_1793)("_glMultiTexCoord2iARB", биб);

		//вяжи(функция_1794)("_glMultiTexCoord2iv", биб);

		//вяжи(функция_1795)("_glMultiTexCoord2ivARB", биб);

		//вяжи(функция_1796)("_glMultiTexCoord2s", биб);

		//вяжи(функция_1797)("_glMultiTexCoord2sARB", биб);

		//вяжи(функция_1798)("_glMultiTexCoord2sv", биб);

		//вяжи(функция_1799)("_glMultiTexCoord2svARB", биб);

		//вяжи(функция_1800)("_glMultiTexCoord3d", биб);

		//вяжи(функция_1801)("_glMultiTexCoord3dARB", биб);

		//вяжи(функция_1802)("_glMultiTexCoord3dv", биб);

		//вяжи(функция_1803)("_glMultiTexCoord3dvARB", биб);

		//вяжи(функция_1804)("_glMultiTexCoord3f", биб);

		//вяжи(функция_1805)("_glMultiTexCoord3fARB", биб);

		//вяжи(функция_1806)("_glMultiTexCoord3fv", биб);

		//вяжи(функция_1807)("_glMultiTexCoord3fvARB", биб);

		//вяжи(функция_1808)("_glMultiTexCoord3i", биб);

		//вяжи(функция_1809)("_glMultiTexCoord3iARB", биб);

		//вяжи(функция_1810)("_glMultiTexCoord3iv", биб);

		//вяжи(функция_1811)("_glMultiTexCoord3ivARB", биб);

		//вяжи(функция_1812)("_glMultiTexCoord3s", биб);

		//вяжи(функция_1813)("_glMultiTexCoord3sARB", биб);

		//вяжи(функция_1814)("_glMultiTexCoord3sv", биб);

		//вяжи(функция_1815)("_glMultiTexCoord3svARB", биб);

		//вяжи(функция_1816)("_glMultiTexCoord4d", биб);

		//вяжи(функция_1817)("_glMultiTexCoord4dARB", биб);

		//вяжи(функция_1818)("_glMultiTexCoord4dv", биб);

		//вяжи(функция_1819)("_glMultiTexCoord4dvARB", биб);

		//вяжи(функция_1820)("_glMultiTexCoord4f", биб);

		//вяжи(функция_1821)("_glMultiTexCoord4fARB", биб);

		//вяжи(функция_1822)("_glMultiTexCoord4fv", биб);

		//вяжи(функция_1823)("_glMultiTexCoord4fvARB", биб);

		//вяжи(функция_1824)("_glMultiTexCoord4i", биб);

		//вяжи(функция_1825)("_glMultiTexCoord4iARB", биб);

		//вяжи(функция_1826)("_glMultiTexCoord4iv", биб);

		//вяжи(функция_1827)("_glMultiTexCoord4ivARB", биб);

		//вяжи(функция_1828)("_glMultiTexCoord4s", биб);

		//вяжи(функция_1829)("_glMultiTexCoord4sARB", биб);

		//вяжи(функция_1830)("_glMultiTexCoord4sv", биб);

		//вяжи(функция_1831)("_glMultiTexCoord4svARB", биб);

		//вяжи(функция_1832)("_glMultMatrixd", биб);

		//вяжи(функция_1833)("_glMultMatrixf", биб);

		//вяжи(функция_1834)("_glMultTransposeMatrixd", биб);

		//вяжи(функция_1835)("_glMultTransposeMatrixdARB", биб);

		//вяжи(функция_1836)("_glMultTransposeMatrixf", биб);

		//вяжи(функция_1837)("_glMultTransposeMatrixfARB", биб);

		//вяжи(функция_1838)("_glNewList", биб);

		//вяжи(функция_1839)("_glNormal3b", биб);

		//вяжи(функция_1840)("_glNormal3bv", биб);

		//вяжи(функция_1841)("_glNormal3d", биб);

		//вяжи(функция_1842)("_glNormal3dv", биб);

		//вяжи(функция_1843)("_glNormal3f", биб);

		//вяжи(функция_1844)("_glNormal3fv", биб);

		//вяжи(функция_1845)("_glNormal3i", биб);

		//вяжи(функция_1846)("_glNormal3iv", биб);

		//вяжи(функция_1847)("_glNormal3s", биб);

		//вяжи(функция_1848)("_glNormal3sv", биб);

		//вяжи(функция_1849)("_glNormalPointer", биб);

		//вяжи(функция_1850)("_glNormalPointerEXT", биб);

		//вяжи(функция_1851)("_glOrtho", биб);

		//вяжи(функция_1852)("_glPassThrough", биб);

		//вяжи(функция_1853)("_glPixelMapfv", биб);

		//вяжи(функция_1854)("_glPixelMapuiv", биб);

		//вяжи(функция_1855)("_glPixelMapusv", биб);

		//вяжи(функция_1856)("_glPixelStoref", биб);

		//вяжи(функция_1857)("_glPixelStorei", биб);

		//вяжи(функция_1858)("_glPixelTransferf", биб);

		//вяжи(функция_1859)("_glPixelTransferi", биб);

		//вяжи(функция_1860)("_glPixelZoom", биб);

		//вяжи(функция_1861)("_glPointParameterf", биб);

		//вяжи(функция_1862)("_glPointParameterfARB", биб);

		//вяжи(функция_1863)("_glPointParameterfEXT", биб);

		//вяжи(функция_1864)("_glPointParameterfv", биб);

		//вяжи(функция_1865)("_glPointParameterfvARB", биб);

		//вяжи(функция_1866)("_glPointParameterfvEXT", биб);

		//вяжи(функция_1867)("_glPointParameteri", биб);

		//вяжи(функция_1868)("_glPointParameteriNV", биб);

		//вяжи(функция_1869)("_glPointParameteriv", биб);

		//вяжи(функция_1870)("_glPointParameterivNV", биб);

		//вяжи(функция_1871)("_glPointSize", биб);

		//вяжи(функция_1872)("_glPolygonMode", биб);

		//вяжи(функция_1873)("_glPolygonOffset", биб);

		//вяжи(функция_1874)("_glPolygonOffsetEXT", биб);

		//вяжи(функция_1875)("_glPolygonStipple", биб);

		//вяжи(функция_1876)("_glPopAttrib", биб);

		//вяжи(функция_1877)("_glPopClientAttrib", биб);

		//вяжи(функция_1878)("_glPopMatrix", биб);

		//вяжи(функция_1879)("_glPopName", биб);

		//вяжи(функция_1880)("_glPrioritizeTextures", биб);

		//вяжи(функция_1881)("_glPrioritizeTexturesEXT", биб);

		//вяжи(функция_1882)("_glProgramEnvParameter4dARB", биб);

		//вяжи(функция_1883)("_glProgramEnvParameter4dvARB", биб);

		//вяжи(функция_1884)("_glProgramEnvParameter4fARB", биб);

		//вяжи(функция_1885)("_glProgramEnvParameter4fvARB", биб);

		//вяжи(функция_1886)("_glProgramLocalParameter4dARB", биб);

		//вяжи(функция_1887)("_glProgramLocalParameter4dvARB", биб);

		//вяжи(функция_1888)("_glProgramLocalParameter4fARB", биб);

		//вяжи(функция_1889)("_glProgramLocalParameter4fvARB", биб);

		//вяжи(функция_1890)("_glProgramNamedParameter4dNV", биб);

		//вяжи(функция_1891)("_glProgramNamedParameter4dvNV", биб);

		//вяжи(функция_1892)("_glProgramNamedParameter4fNV", биб);

		//вяжи(функция_1893)("_glProgramNamedParameter4fvNV", биб);

		//вяжи(функция_1894)("_glProgramParameter4dNV", биб);

		//вяжи(функция_1895)("_glProgramParameter4dvNV", биб);

		//вяжи(функция_1896)("_glProgramParameter4fNV", биб);

		//вяжи(функция_1897)("_glProgramParameter4fvNV", биб);

		//вяжи(функция_1898)("_glProgramParameters4dvNV", биб);

		//вяжи(функция_1899)("_glProgramParameters4fvNV", биб);

		//вяжи(функция_1900)("_glProgramStringARB", биб);

		//вяжи(функция_1901)("_glPushAttrib", биб);

		//вяжи(функция_1902)("_glPushClientAttrib", биб);

		//вяжи(функция_1903)("_glPushMatrix", биб);

		//вяжи(функция_1904)("_glPushName", биб);

		//вяжи(функция_1905)("_glRasterPos2d", биб);

		//вяжи(функция_1906)("_glRasterPos2dv", биб);

		//вяжи(функция_1907)("_glRasterPos2f", биб);

		//вяжи(функция_1908)("_glRasterPos2fv", биб);

		//вяжи(функция_1909)("_glRasterPos2i", биб);

		//вяжи(функция_1910)("_glRasterPos2iv", биб);

		//вяжи(функция_1911)("_glRasterPos2s", биб);

		//вяжи(функция_1912)("_glRasterPos2sv", биб);

		//вяжи(функция_1913)("_glRasterPos3d", биб);

		//вяжи(функция_1914)("_glRasterPos3dv", биб);

		//вяжи(функция_1915)("_glRasterPos3f", биб);

		//вяжи(функция_1916)("_glRasterPos3fv", биб);

		//вяжи(функция_1917)("_glRasterPos3i", биб);

		//вяжи(функция_1918)("_glRasterPos3iv", биб);

		//вяжи(функция_1919)("_glRasterPos3s", биб);

		//вяжи(функция_1920)("_glRasterPos3sv", биб);

		//вяжи(функция_1921)("_glRasterPos4d", биб);

		//вяжи(функция_1922)("_glRasterPos4dv", биб);

		//вяжи(функция_1923)("_glRasterPos4f", биб);

		//вяжи(функция_1924)("_glRasterPos4fv", биб);

		//вяжи(функция_1925)("_glRasterPos4i", биб);

		//вяжи(функция_1926)("_glRasterPos4iv", биб);

		//вяжи(функция_1927)("_glRasterPos4s", биб);

		//вяжи(функция_1928)("_glRasterPos4sv", биб);

		//вяжи(функция_1929)("_glReadBuffer", биб);

		//вяжи(функция_1930)("_glReadPixels", биб);

		//вяжи(функция_1931)("_glRectd", биб);

		//вяжи(функция_1932)("_glRectdv", биб);

		//вяжи(функция_1933)("_glRectf", биб);

		//вяжи(функция_1934)("_glRectfv", биб);

		//вяжи(функция_1935)("_glRecti", биб);

		//вяжи(функция_1936)("_glRectiv", биб);

		//вяжи(функция_1937)("_glRects", биб);

		//вяжи(функция_1938)("_glRectsv", биб);

		//вяжи(функция_1939)("_glRenderMode", биб);

		//вяжи(функция_1940)("_glRequestResidentProgramsNV", биб);

		//вяжи(функция_1941)("_glResetHistogram", биб);

		//вяжи(функция_1942)("_glResetMinmax", биб);

		//вяжи(функция_1943)("_glResizeBuffersMESA", биб);

		//вяжи(функция_1944)("_glRotated", биб);

		//вяжи(функция_1945)("_glRotatef", биб);

		//вяжи(функция_1946)("_glSampleCoverage", биб);

		//вяжи(функция_1947)("_glSampleCoverageARB", биб);

		//вяжи(функция_1948)("_glScaled", биб);

		//вяжи(функция_1949)("_glScalef", биб);

		//вяжи(функция_1950)("_glScissor", биб);

		//вяжи(функция_1951)("_glSecondaryColor3b", биб);

		//вяжи(функция_1952)("_glSecondaryColor3bEXT", биб);

		//вяжи(функция_1953)("_glSecondaryColor3bv", биб);

		//вяжи(функция_1954)("_glSecondaryColor3bvEXT", биб);

		//вяжи(функция_1955)("_glSecondaryColor3d", биб);

		//вяжи(функция_1956)("_glSecondaryColor3dEXT", биб);

		//вяжи(функция_1957)("_glSecondaryColor3dv", биб);

		//вяжи(функция_1958)("_glSecondaryColor3dvEXT", биб);

		//вяжи(функция_1959)("_glSecondaryColor3f", биб);

		//вяжи(функция_1960)("_glSecondaryColor3fEXT", биб);

		//вяжи(функция_1961)("_glSecondaryColor3fv", биб);

		//вяжи(функция_1962)("_glSecondaryColor3fvEXT", биб);

		//вяжи(функция_1963)("_glSecondaryColor3i", биб);

		//вяжи(функция_1964)("_glSecondaryColor3iEXT", биб);

		//вяжи(функция_1965)("_glSecondaryColor3iv", биб);

		//вяжи(функция_1966)("_glSecondaryColor3ivEXT", биб);

		//вяжи(функция_1967)("_glSecondaryColor3s", биб);

		//вяжи(функция_1968)("_glSecondaryColor3sEXT", биб);

		//вяжи(функция_1969)("_glSecondaryColor3sv", биб);

		//вяжи(функция_1970)("_glSecondaryColor3svEXT", биб);

		//вяжи(функция_1971)("_glSecondaryColor3ub", биб);

		//вяжи(функция_1972)("_glSecondaryColor3ubEXT", биб);

		//вяжи(функция_1973)("_glSecondaryColor3ubv", биб);

		//вяжи(функция_1974)("_glSecondaryColor3ubvEXT", биб);

		//вяжи(функция_1975)("_glSecondaryColor3ui", биб);

		//вяжи(функция_1976)("_glSecondaryColor3uiEXT", биб);

		//вяжи(функция_1977)("_glSecondaryColor3uiv", биб);

		//вяжи(функция_1978)("_glSecondaryColor3uivEXT", биб);

		//вяжи(функция_1979)("_glSecondaryColor3us", биб);

		//вяжи(функция_1980)("_glSecondaryColor3usEXT", биб);

		//вяжи(функция_1981)("_glSecondaryColor3usv", биб);

		//вяжи(функция_1982)("_glSecondaryColor3usvEXT", биб);

		//вяжи(функция_1983)("_glSecondaryColorPointer", биб);

		//вяжи(функция_1984)("_glSecondaryColorPointerEXT", биб);

		//вяжи(функция_1985)("_glSelectBuffer", биб);

		//вяжи(функция_1986)("_glSeparableFilter2D", биб);

		//вяжи(функция_1987)("_glShadeModel", биб);

		//вяжи(функция_1988)("_glStencilFunc", биб);

		//вяжи(функция_1989)("_glStencilMask", биб);

		//вяжи(функция_1990)("_glStencilOp", биб);

		//вяжи(функция_1991)("_glTexCoord1d", биб);

		//вяжи(функция_1992)("_glTexCoord1dv", биб);

		//вяжи(функция_1993)("_glTexCoord1f", биб);

		//вяжи(функция_1994)("_glTexCoord1fv", биб);

		//вяжи(функция_1995)("_glTexCoord1i", биб);

		//вяжи(функция_1996)("_glTexCoord1iv", биб);

		//вяжи(функция_1997)("_glTexCoord1s", биб);

		//вяжи(функция_1998)("_glTexCoord1sv", биб);

		//вяжи(функция_1999)("_glTexCoord2d", биб);

		//вяжи(функция_2000)("_glTexCoord2dv", биб);

		//вяжи(функция_2001)("_glTexCoord2f", биб);

		//вяжи(функция_2002)("_glTexCoord2fv", биб);

		//вяжи(функция_2003)("_glTexCoord2i", биб);

		//вяжи(функция_2004)("_glTexCoord2iv", биб);

		//вяжи(функция_2005)("_glTexCoord2s", биб);

		//вяжи(функция_2006)("_glTexCoord2sv", биб);

		//вяжи(функция_2007)("_glTexCoord3d", биб);

		//вяжи(функция_2008)("_glTexCoord3dv", биб);

		//вяжи(функция_2009)("_glTexCoord3f", биб);

		//вяжи(функция_2010)("_glTexCoord3fv", биб);

		//вяжи(функция_2011)("_glTexCoord3i", биб);

		//вяжи(функция_2012)("_glTexCoord3iv", биб);

		//вяжи(функция_2013)("_glTexCoord3s", биб);

		//вяжи(функция_2014)("_glTexCoord3sv", биб);

		//вяжи(функция_2015)("_glTexCoord4d", биб);

		//вяжи(функция_2016)("_glTexCoord4dv", биб);

		//вяжи(функция_2017)("_glTexCoord4f", биб);

		//вяжи(функция_2018)("_glTexCoord4fv", биб);

		//вяжи(функция_2019)("_glTexCoord4i", биб);

		//вяжи(функция_2020)("_glTexCoord4iv", биб);

		//вяжи(функция_2021)("_glTexCoord4s", биб);

		//вяжи(функция_2022)("_glTexCoord4sv", биб);

		//вяжи(функция_2023)("_glTexCoordPointer", биб);

		//вяжи(функция_2024)("_glTexCoordPointerEXT", биб);

		//вяжи(функция_2025)("_glTexEnvf", биб);

		//вяжи(функция_2026)("_glTexEnvfv", биб);

		//вяжи(функция_2027)("_glTexEnvi", биб);

		//вяжи(функция_2028)("_glTexEnviv", биб);

		//вяжи(функция_2029)("_glTexGend", биб);

		//вяжи(функция_2030)("_glTexGendv", биб);

		//вяжи(функция_2031)("_glTexGenf", биб);

		//вяжи(функция_2032)("_glTexGenfv", биб);

		//вяжи(функция_2033)("_glTexGeni", биб);

		//вяжи(функция_2034)("_glTexGeniv", биб);

		//вяжи(функция_2035)("_glTexImage1D", биб);

		//вяжи(функция_2036)("_glTexImage2D", биб);

		//вяжи(функция_2037)("_glTexImage3D", биб);

		//вяжи(функция_2038)("_glTexImage3DEXT", биб);

		//вяжи(функция_2039)("_glTexParameterf", биб);

		//вяжи(функция_2040)("_glTexParameterfv", биб);

		//вяжи(функция_2041)("_glTexParameteri", биб);

		//вяжи(функция_2042)("_glTexParameteriv", биб);

		//вяжи(функция_2043)("_glTexSubImage1D", биб);

		//вяжи(функция_2044)("_glTexSubImage1DEXT", биб);

		//вяжи(функция_2045)("_glTexSubImage2D", биб);

		//вяжи(функция_2046)("_glTexSubImage2DEXT", биб);

		//вяжи(функция_2047)("_glTexSubImage3D", биб);

		//вяжи(функция_2048)("_glTexSubImage3DEXT", биб);

		//вяжи(функция_2049)("_glTrackMatrixNV", биб);

		//вяжи(функция_2050)("_glTranslated", биб);

		//вяжи(функция_2051)("_glTranslatef", биб);

		//вяжи(функция_2052)("_glUnlockArraysEXT", биб);

		//вяжи(функция_2053)("_glUnmapBuffer", биб);

		//вяжи(функция_2054)("_glUnmapBufferARB", биб);

		//вяжи(функция_2055)("_glVertex2d", биб);

		//вяжи(функция_2056)("_glVertex2dv", биб);

		//вяжи(функция_2057)("_glVertex2f", биб);

		//вяжи(функция_2058)("_glVertex2fv", биб);

		//вяжи(функция_2059)("_glVertex2i", биб);

		//вяжи(функция_2060)("_glVertex2iv", биб);

		//вяжи(функция_2061)("_glVertex2s", биб);

		//вяжи(функция_2062)("_glVertex2sv", биб);

		//вяжи(функция_2063)("_glVertex3d", биб);

		//вяжи(функция_2064)("_glVertex3dv", биб);

		//вяжи(функция_2065)("_glVertex3f", биб);

		//вяжи(функция_2066)("_glVertex3fv", биб);

		//вяжи(функция_2067)("_glVertex3i", биб);

		//вяжи(функция_2068)("_glVertex3iv", биб);

		//вяжи(функция_2069)("_glVertex3s", биб);

		//вяжи(функция_2070)("_glVertex3sv", биб);

		//вяжи(функция_2071)("_glVertex4d", биб);

		//вяжи(функция_2072)("_glVertex4dv", биб);

		//вяжи(функция_2073)("_glVertex4f", биб);

		//вяжи(функция_2074)("_glVertex4fv", биб);

		//вяжи(функция_2075)("_glVertex4i", биб);

		//вяжи(функция_2076)("_glVertex4iv", биб);

		//вяжи(функция_2077)("_glVertex4s", биб);

		//вяжи(функция_2078)("_glVertex4sv", биб);

		//вяжи(функция_2079)("_glVertexArrayRangeNV", биб);

		//вяжи(функция_2080)("_glVertexAttrib1dARB", биб);

		//вяжи(функция_2081)("_glVertexAttrib1dNV", биб);

		//вяжи(функция_2082)("_glVertexAttrib1dvARB", биб);

		//вяжи(функция_2083)("_glVertexAttrib1dvNV", биб);

		//вяжи(функция_2084)("_glVertexAttrib1fARB", биб);

		//вяжи(функция_2085)("_glVertexAttrib1fNV", биб);

		//вяжи(функция_2086)("_glVertexAttrib1fvARB", биб);

		//вяжи(функция_2087)("_glVertexAttrib1fvNV", биб);

		//вяжи(функция_2088)("_glVertexAttrib1sARB", биб);

		//вяжи(функция_2089)("_glVertexAttrib1sNV", биб);

		//вяжи(функция_2090)("_glVertexAttrib1svARB", биб);

		//вяжи(функция_2091)("_glVertexAttrib1svNV", биб);

		//вяжи(функция_2092)("_glVertexAttrib2dARB", биб);

		//вяжи(функция_2093)("_glVertexAttrib2dNV", биб);

		//вяжи(функция_2094)("_glVertexAttrib2dvARB", биб);

		//вяжи(функция_2095)("_glVertexAttrib2dvNV", биб);

		//вяжи(функция_2096)("_glVertexAttrib2fARB", биб);

		//вяжи(функция_2097)("_glVertexAttrib2fNV", биб);

		//вяжи(функция_2098)("_glVertexAttrib2fvARB", биб);

		//вяжи(функция_2099)("_glVertexAttrib2fvNV", биб);

		//вяжи(функция_2100)("_glVertexAttrib2sARB", биб);

		//вяжи(функция_2101)("_glVertexAttrib2sNV", биб);

		//вяжи(функция_2102)("_glVertexAttrib2svARB", биб);

		//вяжи(функция_2103)("_glVertexAttrib2svNV", биб);

		//вяжи(функция_2104)("_glVertexAttrib3dARB", биб);

		//вяжи(функция_2105)("_glVertexAttrib3dNV", биб);

		//вяжи(функция_2106)("_glVertexAttrib3dvARB", биб);

		//вяжи(функция_2107)("_glVertexAttrib3dvNV", биб);

		//вяжи(функция_2108)("_glVertexAttrib3fARB", биб);

		//вяжи(функция_2109)("_glVertexAttrib3fNV", биб);

		//вяжи(функция_2110)("_glVertexAttrib3fvARB", биб);

		//вяжи(функция_2111)("_glVertexAttrib3fvNV", биб);

		//вяжи(функция_2112)("_glVertexAttrib3sARB", биб);

		//вяжи(функция_2113)("_glVertexAttrib3sNV", биб);

		//вяжи(функция_2114)("_glVertexAttrib3svARB", биб);

		//вяжи(функция_2115)("_glVertexAttrib3svNV", биб);

		//вяжи(функция_2116)("_glVertexAttrib4bvARB", биб);

		//вяжи(функция_2117)("_glVertexAttrib4dARB", биб);

		//вяжи(функция_2118)("_glVertexAttrib4dNV", биб);

		//вяжи(функция_2119)("_glVertexAttrib4dvARB", биб);

		//вяжи(функция_2120)("_glVertexAttrib4dvNV", биб);

		//вяжи(функция_2121)("_glVertexAttrib4fARB", биб);

		//вяжи(функция_2122)("_glVertexAttrib4fNV", биб);

		//вяжи(функция_2123)("_glVertexAttrib4fvARB", биб);

		//вяжи(функция_2124)("_glVertexAttrib4fvNV", биб);

		//вяжи(функция_2125)("_glVertexAttrib4ivARB", биб);

		//вяжи(функция_2126)("_glVertexAttrib4NbvARB", биб);

		//вяжи(функция_2127)("_glVertexAttrib4NivARB", биб);

		//вяжи(функция_2128)("_glVertexAttrib4NsvARB", биб);

		//вяжи(функция_2129)("_glVertexAttrib4NubARB", биб);

		//вяжи(функция_2130)("_glVertexAttrib4NubvARB", биб);

		//вяжи(функция_2131)("_glVertexAttrib4NuivARB", биб);

		//вяжи(функция_2132)("_glVertexAttrib4NusvARB", биб);

		//вяжи(функция_2133)("_glVertexAttrib4sARB", биб);

		//вяжи(функция_2134)("_glVertexAttrib4sNV", биб);

		//вяжи(функция_2135)("_glVertexAttrib4svARB", биб);

		//вяжи(функция_2136)("_glVertexAttrib4svNV", биб);

		//вяжи(функция_2137)("_glVertexAttrib4ubNV", биб);

		//вяжи(функция_2138)("_glVertexAttrib4ubvARB", биб);

		//вяжи(функция_2139)("_glVertexAttrib4ubvNV", биб);

		//вяжи(функция_2140)("_glVertexAttrib4uivARB", биб);

		//вяжи(функция_2141)("_glVertexAttrib4usvARB", биб);

		//вяжи(функция_2142)("_glVertexAttribPointerARB", биб);

		//вяжи(функция_2143)("_glVertexAttribPointerNV", биб);

		//вяжи(функция_2144)("_glVertexAttribs1dvNV", биб);

		//вяжи(функция_2145)("_glVertexAttribs1fvNV", биб);

		//вяжи(функция_2146)("_glVertexAttribs1svNV", биб);

		//вяжи(функция_2147)("_glVertexAttribs2dvNV", биб);

		//вяжи(функция_2148)("_glVertexAttribs2fvNV", биб);

		//вяжи(функция_2149)("_glVertexAttribs2svNV", биб);

		//вяжи(функция_2150)("_glVertexAttribs3dvNV", биб);

		//вяжи(функция_2151)("_glVertexAttribs3fvNV", биб);

		//вяжи(функция_2152)("_glVertexAttribs3svNV", биб);

		//вяжи(функция_2153)("_glVertexAttribs4dvNV", биб);

		//вяжи(функция_2154)("_glVertexAttribs4fvNV", биб);

		//вяжи(функция_2155)("_glVertexAttribs4svNV", биб);

		//вяжи(функция_2156)("_glVertexAttribs4ubvNV", биб);

		//вяжи(функция_2157)("_glVertexPointer", биб);

		//вяжи(функция_2158)("_glVertexPointerEXT", биб);

		//вяжи(функция_2159)("_glViewport", биб);

		//вяжи(функция_2160)("_glWindowPos2d", биб);

		//вяжи(функция_2161)("_glWindowPos2dARB", биб);

		//вяжи(функция_2162)("_glWindowPos2dMESA", биб);

		//вяжи(функция_2163)("_glWindowPos2dv", биб);

		//вяжи(функция_2164)("_glWindowPos2dvARB", биб);

		//вяжи(функция_2165)("_glWindowPos2dvMESA", биб);

		//вяжи(функция_2166)("_glWindowPos2f", биб);

		//вяжи(функция_2167)("_glWindowPos2fARB", биб);

		//вяжи(функция_2168)("_glWindowPos2fMESA", биб);

		//вяжи(функция_2169)("_glWindowPos2fv", биб);

		//вяжи(функция_2170)("_glWindowPos2fvARB", биб);

		//вяжи(функция_2171)("_glWindowPos2fvMESA", биб);

		//вяжи(функция_2172)("_glWindowPos2i", биб);

		//вяжи(функция_2173)("_glWindowPos2iARB", биб);

		//вяжи(функция_2174)("_glWindowPos2iMESA", биб);

		//вяжи(функция_2175)("_glWindowPos2iv", биб);

		//вяжи(функция_2176)("_glWindowPos2ivARB", биб);

		//вяжи(функция_2177)("_glWindowPos2ivMESA", биб);

		//вяжи(функция_2178)("_glWindowPos2s", биб);

		//вяжи(функция_2179)("_glWindowPos2sARB", биб);

		//вяжи(функция_2180)("_glWindowPos2sMESA", биб);

		//вяжи(функция_2181)("_glWindowPos2sv", биб);

		//вяжи(функция_2182)("_glWindowPos2svARB", биб);

		//вяжи(функция_2183)("_glWindowPos2svMESA", биб);

		//вяжи(функция_2184)("_glWindowPos3d", биб);

		//вяжи(функция_2185)("_glWindowPos3dARB", биб);

		//вяжи(функция_2186)("_glWindowPos3dMESA", биб);

		//вяжи(функция_2187)("_glWindowPos3dv", биб);

		//вяжи(функция_2188)("_glWindowPos3dvARB", биб);

		//вяжи(функция_2189)("_glWindowPos3dvMESA", биб);

		//вяжи(функция_2190)("_glWindowPos3f", биб);

		//вяжи(функция_2191)("_glWindowPos3fARB", биб);

		//вяжи(функция_2192)("_glWindowPos3fMESA", биб);

		//вяжи(функция_2193)("_glWindowPos3fv", биб);

		//вяжи(функция_2194)("_glWindowPos3fvARB", биб);

		//вяжи(функция_2195)("_glWindowPos3fvMESA", биб);

		//вяжи(функция_2196)("_glWindowPos3i", биб);

		//вяжи(функция_2197)("_glWindowPos3iARB", биб);

		//вяжи(функция_2198)("_glWindowPos3iMESA", биб);

		//вяжи(функция_2199)("_glWindowPos3iv", биб);

		//вяжи(функция_2200)("_glWindowPos3ivARB", биб);

		//вяжи(функция_2201)("_glWindowPos3ivMESA", биб);

		//вяжи(функция_2202)("_glWindowPos3s", биб);

		//вяжи(функция_2203)("_glWindowPos3sARB", биб);

		//вяжи(функция_2204)("_glWindowPos3sMESA", биб);

		//вяжи(функция_2205)("_glWindowPos3sv", биб);

		//вяжи(функция_2206)("_glWindowPos3svARB", биб);

		//вяжи(функция_2207)("_glWindowPos3svMESA", биб);

		//вяжи(функция_2208)("_glWindowPos4dMESA", биб);

		//вяжи(функция_2209)("_glWindowPos4dvMESA", биб);

		//вяжи(функция_2210)("_glWindowPos4fMESA", биб);

		//вяжи(функция_2211)("_glWindowPos4fvMESA", биб);

		//вяжи(функция_2212)("_glWindowPos4iMESA", биб);

		//вяжи(функция_2213)("_glWindowPos4ivMESA", биб);

		//вяжи(функция_2214)("_glWindowPos4sMESA", биб);

		//вяжи(функция_2215)("_glWindowPos4svMESA", биб);

		//вяжи(функция_2216)("_wglChoosePixelFormat", биб);

		//вяжи(функция_2217)("_wglCopyContext", биб);

		//вяжи(функция_2218)("_wglCreateContext", биб);

		//вяжи(функция_2219)("_wglCreateLayerContext", биб);

		//вяжи(функция_2220)("_wglDeleteContext", биб);

		//вяжи(функция_2221)("_wglDescribeLayerPlane", биб);

		//вяжи(функция_2222)("_wglDescribePixelFormat", биб);

		//вяжи(функция_2223)("_wglGetCurrentContext", биб);

		//вяжи(функция_2224)("_wglGetCurrentDC", биб);

		//вяжи(функция_2225)("_wglGetExtensionsStringARB", биб);

		//вяжи(функция_2226)("_wglGetLayerPaletteEntries", биб);

		//вяжи(функция_2227)("_wglGetPixelFormat", биб);

		//вяжи(функция_2228)("_wglGetProcAddress", биб);

		//вяжи(функция_2229)("_wglMakeCurrent", биб);

		//вяжи(функция_2230)("_wglRealizeLayerPalette", биб);

		//вяжи(функция_2231)("_wglSetLayerPaletteEntries", биб);

		//вяжи(функция_2232)("_wglSetPixelFormat", биб);

		//вяжи(функция_2233)("_wglShareLists", биб);

		//вяжи(функция_2234)("_wglSwapBuffers", биб);

		//вяжи(функция_2235)("_wglSwapLayerBuffers", биб);

		//вяжи(функция_2236)("_wglUseFontBitmapsA", биб);

		//вяжи(функция_2237)("_wglUseFontBitmapsW", биб);

		//вяжи(функция_2238)("_wglUseFontOutlinesA", биб);

		//вяжи(функция_2239)("_wglUseFontOutlinesW", биб);

	}

	extern(C)
	{
		//проц function(   ) функция_1; 

		//проц function(   ) функция_2; 

		//проц function(   ) функция_3; 

		//проц function(   ) функция_4; 

		//проц function(   ) функция_5; 

		//проц function(   ) функция_6; 

		//проц function(   ) функция_7; 

		//проц function(   ) функция_8; 

		//проц function(   ) функция_9; 

		//проц function(   ) функция_10; 

		//проц function(   ) функция_11; 

		//проц function(   ) функция_12; 

		//проц function(   ) функция_13; 

		//проц function(   ) функция_14; 

		//проц function(   ) функция_15; 

		//проц function(   ) функция_16; 

		//проц function(   ) функция_17; 

		//проц function(   ) функция_18; 

		//проц function(   ) функция_19; 

		//проц function(   ) функция_20; 

		//проц function(   ) функция_21; 

		//проц function(   ) функция_22; 

		//проц function(   ) функция_23; 

		//проц function(   ) функция_24; 

		//проц function(   ) функция_25; 

		//проц function(   ) функция_26; 

		//проц function(   ) функция_27; 

		//проц function(   ) функция_28; 

		//проц function(   ) функция_29; 

		//проц function(   ) функция_30; 

		//проц function(   ) функция_31; 

		//проц function(   ) функция_32; 

		//проц function(   ) функция_33; 

		//проц function(   ) функция_34; 

		//проц function(   ) функция_35; 

		//проц function(   ) функция_36; 

		//проц function(   ) функция_37; 

		//проц function(   ) функция_38; 

		//проц function(   ) функция_39; 

		//проц function(   ) функция_40; 

		//проц function(   ) функция_41; 

		//проц function(   ) функция_42; 

		//проц function(   ) функция_43; 

		//проц function(   ) функция_44; 

		//проц function(   ) функция_45; 

		//проц function(   ) функция_46; 

		//проц function(   ) функция_47; 

		//проц function(   ) функция_48; 

		//проц function(   ) функция_49; 

		//проц function(   ) функция_50; 

		//проц function(   ) функция_51; 

		//проц function(   ) функция_52; 

		//проц function(   ) функция_53; 

		//проц function(   ) функция_54; 

		//проц function(   ) функция_55; 

		//проц function(   ) функция_56; 

		//проц function(   ) функция_57; 

		//проц function(   ) функция_58; 

		//проц function(   ) функция_59; 

		//проц function(   ) функция_60; 

		//проц function(   ) функция_61; 

		//проц function(   ) функция_62; 

		//проц function(   ) функция_63; 

		//проц function(   ) функция_64; 

		//проц function(   ) функция_65; 

		//проц function(   ) функция_66; 

		//проц function(   ) функция_67; 

		//проц function(   ) функция_68; 

		//проц function(   ) функция_69; 

		//проц function(   ) функция_70; 

		//проц function(   ) функция_71; 

		//проц function(   ) функция_72; 

		//проц function(   ) функция_73; 

		//проц function(   ) функция_74; 

		//проц function(   ) функция_75; 

		//проц function(   ) функция_76; 

		//проц function(   ) функция_77; 

		//проц function(   ) функция_78; 

		//проц function(   ) функция_79; 

		//проц function(   ) функция_80; 

		//проц function(   ) функция_81; 

		//проц function(   ) функция_82; 

		//проц function(   ) функция_83; 

		//проц function(   ) функция_84; 

		//проц function(   ) функция_85; 

		//проц function(   ) функция_86; 

		//проц function(   ) функция_87; 

		//проц function(   ) функция_88; 

		//проц function(   ) функция_89; 

		//проц function(   ) функция_90; 

		//проц function(   ) функция_91; 

		//проц function(   ) функция_92; 

		//проц function(   ) функция_93; 

		//проц function(   ) функция_94; 

		//проц function(   ) функция_95; 

		//проц function(   ) функция_96; 

		//проц function(   ) функция_97; 

		//проц function(   ) функция_98; 

		//проц function(   ) функция_99; 

		//проц function(   ) функция_100; 

		//проц function(   ) функция_101; 

		//проц function(   ) функция_102; 

		//проц function(   ) функция_103; 

		//проц function(   ) функция_104; 

		//проц function(   ) функция_105; 

		//проц function(   ) функция_106; 

		//проц function(   ) функция_107; 

		//проц function(   ) функция_108; 

		//проц function(   ) функция_109; 

		//проц function(   ) функция_110; 

		//проц function(   ) функция_111; 

		//проц function(   ) функция_112; 

		//проц function(   ) функция_113; 

		//проц function(   ) функция_114; 

		//проц function(   ) функция_115; 

		//проц function(   ) функция_116; 

		//проц function(   ) функция_117; 

		//проц function(   ) функция_118; 

		//проц function(   ) функция_119; 

		//проц function(   ) функция_120; 

		//проц function(   ) функция_121; 

		//проц function(   ) функция_122; 

		//проц function(   ) функция_123; 

		//проц function(   ) функция_124; 

		//проц function(   ) функция_125; 

		//проц function(   ) функция_126; 

		//проц function(   ) функция_127; 

		//проц function(   ) функция_128; 

		//проц function(   ) функция_129; 

		//проц function(   ) функция_130; 

		//проц function(   ) функция_131; 

		//проц function(   ) функция_132; 

		//проц function(   ) функция_133; 

		//проц function(   ) функция_134; 

		//проц function(   ) функция_135; 

		//проц function(   ) функция_136; 

		//проц function(   ) функция_137; 

		//проц function(   ) функция_138; 

		//проц function(   ) функция_139; 

		//проц function(   ) функция_140; 

		//проц function(   ) функция_141; 

		//проц function(   ) функция_142; 

		//проц function(   ) функция_143; 

		//проц function(   ) функция_144; 

		//проц function(   ) функция_145; 

		//проц function(   ) функция_146; 

		//проц function(   ) функция_147; 

		//проц function(   ) функция_148; 

		//проц function(   ) функция_149; 

		//проц function(   ) функция_150; 

		//проц function(   ) функция_151; 

		//проц function(   ) функция_152; 

		//проц function(   ) функция_153; 

		//проц function(   ) функция_154; 

		//проц function(   ) функция_155; 

		//проц function(   ) функция_156; 

		//проц function(   ) функция_157; 

		//проц function(   ) функция_158; 

		//проц function(   ) функция_159; 

		//проц function(   ) функция_160; 

		//проц function(   ) функция_161; 

		//проц function(   ) функция_162; 

		//проц function(   ) функция_163; 

		//проц function(   ) функция_164; 

		//проц function(   ) функция_165; 

		//проц function(   ) функция_166; 

		//проц function(   ) функция_167; 

		//проц function(   ) функция_168; 

		//проц function(   ) функция_169; 

		//проц function(   ) функция_170; 

		//проц function(   ) функция_171; 

		//проц function(   ) функция_172; 

		//проц function(   ) функция_173; 

		//проц function(   ) функция_174; 

		//проц function(   ) функция_175; 

		//проц function(   ) функция_176; 

		//проц function(   ) функция_177; 

		//проц function(   ) функция_178; 

		//проц function(   ) функция_179; 

		//проц function(   ) функция_180; 

		//проц function(   ) функция_181; 

		//проц function(   ) функция_182; 

		//проц function(   ) функция_183; 

		//проц function(   ) функция_184; 

		//проц function(   ) функция_185; 

		//проц function(   ) функция_186; 

		//проц function(   ) функция_187; 

		//проц function(   ) функция_188; 

		//проц function(   ) функция_189; 

		//проц function(   ) функция_190; 

		//проц function(   ) функция_191; 

		//проц function(   ) функция_192; 

		//проц function(   ) функция_193; 

		//проц function(   ) функция_194; 

		//проц function(   ) функция_195; 

		//проц function(   ) функция_196; 

		//проц function(   ) функция_197; 

		//проц function(   ) функция_198; 

		//проц function(   ) функция_199; 

		//проц function(   ) функция_200; 

		//проц function(   ) функция_201; 

		//проц function(   ) функция_202; 

		//проц function(   ) функция_203; 

		//проц function(   ) функция_204; 

		//проц function(   ) функция_205; 

		//проц function(   ) функция_206; 

		//проц function(   ) функция_207; 

		//проц function(   ) функция_208; 

		//проц function(   ) функция_209; 

		//проц function(   ) функция_210; 

		//проц function(   ) функция_211; 

		//проц function(   ) функция_212; 

		//проц function(   ) функция_213; 

		//проц function(   ) функция_214; 

		//проц function(   ) функция_215; 

		//проц function(   ) функция_216; 

		//проц function(   ) функция_217; 

		//проц function(   ) функция_218; 

		//проц function(   ) функция_219; 

		//проц function(   ) функция_220; 

		//проц function(   ) функция_221; 

		//проц function(   ) функция_222; 

		//проц function(   ) функция_223; 

		//проц function(   ) функция_224; 

		//проц function(   ) функция_225; 

		//проц function(   ) функция_226; 

		//проц function(   ) функция_227; 

		//проц function(   ) функция_228; 

		//проц function(   ) функция_229; 

		//проц function(   ) функция_230; 

		//проц function(   ) функция_231; 

		//проц function(   ) функция_232; 

		//проц function(   ) функция_233; 

		//проц function(   ) функция_234; 

		//проц function(   ) функция_235; 

		//проц function(   ) функция_236; 

		//проц function(   ) функция_237; 

		//проц function(   ) функция_238; 

		//проц function(   ) функция_239; 

		//проц function(   ) функция_240; 

		//проц function(   ) функция_241; 

		//проц function(   ) функция_242; 

		//проц function(   ) функция_243; 

		//проц function(   ) функция_244; 

		//проц function(   ) функция_245; 

		//проц function(   ) функция_246; 

		//проц function(   ) функция_247; 

		//проц function(   ) функция_248; 

		//проц function(   ) функция_249; 

		//проц function(   ) функция_250; 

		//проц function(   ) функция_251; 

		//проц function(   ) функция_252; 

		//проц function(   ) функция_253; 

		//проц function(   ) функция_254; 

		//проц function(   ) функция_255; 

		//проц function(   ) функция_256; 

		//проц function(   ) функция_257; 

		//проц function(   ) функция_258; 

		//проц function(   ) функция_259; 

		//проц function(   ) функция_260; 

		//проц function(   ) функция_261; 

		//проц function(   ) функция_262; 

		//проц function(   ) функция_263; 

		//проц function(   ) функция_264; 

		//проц function(   ) функция_265; 

		//проц function(   ) функция_266; 

		//проц function(   ) функция_267; 

		//проц function(   ) функция_268; 

		//проц function(   ) функция_269; 

		//проц function(   ) функция_270; 

		//проц function(   ) функция_271; 

		//проц function(   ) функция_272; 

		//проц function(   ) функция_273; 

		//проц function(   ) функция_274; 

		//проц function(   ) функция_275; 

		//проц function(   ) функция_276; 

		//проц function(   ) функция_277; 

		//проц function(   ) функция_278; 

		//проц function(   ) функция_279; 

		//проц function(   ) функция_280; 

		//проц function(   ) функция_281; 

		//проц function(   ) функция_282; 

		//проц function(   ) функция_283; 

		//проц function(   ) функция_284; 

		//проц function(   ) функция_285; 

		//проц function(   ) функция_286; 

		//проц function(   ) функция_287; 

		//проц function(   ) функция_288; 

		//проц function(   ) функция_289; 

		//проц function(   ) функция_290; 

		//проц function(   ) функция_291; 

		//проц function(   ) функция_292; 

		//проц function(   ) функция_293; 

		//проц function(   ) функция_294; 

		//проц function(   ) функция_295; 

		//проц function(   ) функция_296; 

		//проц function(   ) функция_297; 

		//проц function(   ) функция_298; 

		//проц function(   ) функция_299; 

		//проц function(   ) функция_300; 

		//проц function(   ) функция_301; 

		//проц function(   ) функция_302; 

		//проц function(   ) функция_303; 

		//проц function(   ) функция_304; 

		проц function(Гперечень а) глНачни; 

		//проц function(   ) функция_306; 

		//проц function(   ) функция_307; 

		//проц function(   ) функция_308; 

		//проц function(   ) функция_309; 

		//проц function(   ) функция_310; 

		//проц function(   ) функция_311; 

		//проц function(   ) функция_312; 

		//проц function(   ) функция_313; 

		//проц function(   ) функция_314; 

		//проц function(   ) функция_315; 

		//проц function(   ) функция_316; 

		//проц function(   ) функция_317; 

		//проц function(   ) функция_318; 

		//проц function(   ) функция_319; 

		//проц function(   ) функция_320; 

		//проц function(   ) функция_321; 

		//проц function(   ) функция_322; 

		//проц function(   ) функция_323; 

		//проц function(   ) функция_324; 

		//проц function(   ) функция_325; 

		//проц function(   ) функция_326; 

		проц function(Гбитполе а) глОчисти; 

		//проц function(   ) функция_328; 

		//проц function(   ) функция_329; 

		//проц function(   ) функция_330; 

		проц function(плав а) глОчистиИндекс; 

		//проц function(   ) функция_332; 

		//проц function(   ) функция_333; 

		//проц function(   ) функция_334; 

		//проц function(   ) функция_335; 

		//проц function(   ) функция_336; 

		//проц function(   ) функция_337; 

		//проц function(   ) функция_338; 

		//проц function(   ) функция_339; 

		//проц function(   ) функция_340; 

		//проц function(   ) функция_341; 

		//проц function(   ) функция_342; 

		//проц function(   ) функция_343; 

		//проц function(   ) функция_344; 

		//проц function(   ) функция_345; 

		//проц function(   ) функция_346; 

		//проц function(   ) функция_347; 

		//проц function(   ) функция_348; 

		//проц function(   ) функция_349; 

		//проц function(   ) функция_350; 

		//проц function(   ) функция_351; 

		//проц function(   ) функция_352; 

		//проц function(   ) функция_353; 

		//проц function(   ) функция_354; 

		//проц function(   ) функция_355; 

		//проц function(   ) функция_356; 

		//проц function(   ) функция_357; 

		//проц function(   ) функция_358; 

		//проц function(   ) функция_359; 

		//проц function(   ) функция_360; 

		//проц function(   ) функция_361; 

		//проц function(   ) функция_362; 

		//проц function(   ) функция_363; 

		//проц function(   ) функция_364; 

		//проц function(   ) функция_365; 

		//проц function(   ) функция_366; 

		//проц function(   ) функция_367; 

		//проц function(   ) функция_368; 

		//проц function(   ) функция_369; 

		//проц function(   ) функция_370; 

		//проц function(   ) функция_371; 

		//проц function(   ) функция_372; 

		//проц function(   ) функция_373; 

		//проц function(   ) функция_374; 

		//проц function(   ) функция_375; 

		//проц function(   ) функция_376; 

		//проц function(   ) функция_377; 

		//проц function(   ) функция_378; 

		//проц function(   ) функция_379; 

		//проц function(   ) функция_380; 

		//проц function(   ) функция_381; 

		//проц function(   ) функция_382; 

		//проц function(   ) функция_383; 

		//проц function(   ) функция_384; 

		//проц function(   ) функция_385; 

		//проц function(   ) функция_386; 

		//проц function(   ) функция_387; 

		//проц function(   ) функция_388; 

		//проц function(   ) функция_389; 

		//проц function(   ) функция_390; 

		//проц function(   ) функция_391; 

		//проц function(   ) функция_392; 

		//проц function(   ) функция_393; 

		//проц function(   ) функция_394; 

		//проц function(   ) функция_395; 

		//проц function(   ) функция_396; 

		//проц function(   ) функция_397; 

		//проц function(   ) функция_398; 

		//проц function(   ) функция_399; 

		//проц function(   ) функция_400; 

		//проц function(   ) функция_401; 

		//проц function(   ) функция_402; 

		//проц function(   ) функция_403; 

		//проц function(   ) функция_404; 

		//проц function(   ) функция_405; 

		//проц function(   ) функция_406; 

		//проц function(   ) функция_407; 

		//проц function(   ) функция_408; 

		//проц function(   ) функция_409; 

		//проц function(   ) функция_410; 

		//проц function(   ) функция_411; 

		//проц function(   ) функция_412; 

		//проц function(   ) функция_413; 

		//проц function(   ) функция_414; 

		//проц function(   ) функция_415; 

		//проц function(   ) функция_416; 

		//проц function(   ) функция_417; 

		//проц function(   ) функция_418; 

		//проц function(   ) функция_419; 

		//проц function(   ) функция_420; 

		//проц function(   ) функция_421; 

		//проц function(   ) функция_422; 

		//проц function(   ) функция_423; 

		//проц function(   ) функция_424; 

		//проц function(   ) функция_425; 

		//проц function(   ) функция_426; 

		//проц function(   ) функция_427; 

		//проц function(   ) функция_428; 

		//проц function(   ) функция_429; 

		//проц function(   ) функция_430; 

		//проц function(   ) функция_431; 

		//проц function(   ) функция_432; 

		//проц function(   ) функция_433; 

		//проц function(   ) функция_434; 

		//проц function(   ) функция_435; 

		//проц function(   ) функция_436; 

		//проц function(   ) функция_437; 

		//проц function(   ) функция_438; 

		//проц function(   ) функция_439; 

		//проц function(   ) функция_440; 

		//проц function(   ) функция_441; 

		//проц function(   ) функция_442; 

		проц function(Гперечень а) глВключи; 

		//проц function(   ) функция_444; 

		//проц function(   ) функция_445; 

		проц function() глСтоп; 

		//проц function(   ) функция_447; 

		//проц function(   ) функция_448; 

		//проц function(   ) функция_449; 

		//проц function(   ) функция_450; 

		//проц function(   ) функция_451; 

		//проц function(   ) функция_452; 

		//проц function(   ) функция_453; 

		//проц function(   ) функция_454; 

		//проц function(   ) функция_455; 

		//проц function(   ) функция_456; 

		//проц function(   ) функция_457; 

		//проц function(   ) функция_458; 

		//проц function(   ) функция_459; 

		//проц function(   ) функция_460; 

		//проц function(   ) функция_461; 

		//проц function(   ) функция_462; 

		//проц function(   ) функция_463; 

		//проц function(   ) функция_464; 

		//проц function(   ) функция_465; 

		проц function() глСлей; 

		//проц function(   ) функция_467; 

		//проц function(   ) функция_468; 

		//проц function(   ) функция_469; 

		//проц function(   ) функция_470; 

		//проц function(   ) функция_471; 

		//проц function(   ) функция_472; 

		//проц function(   ) функция_473; 

		//проц function(   ) функция_474; 

		//проц function(   ) функция_475; 

		//проц function(   ) функция_476; 

		//проц function(   ) функция_477; 

		//проц function(   ) функция_478; 

		//проц function(   ) функция_479; 

		//проц function(   ) функция_480; 

		//проц function(   ) функция_481; 

		//проц function(   ) функция_482; 

		//проц function(   ) функция_483; 

		//проц function(   ) функция_484; 

		//проц function(   ) функция_485; 

		//проц function(   ) функция_486; 

		//проц function(   ) функция_487; 

		//проц function(   ) функция_488; 

		//проц function(   ) функция_489; 

		//проц function(   ) функция_490; 

		//проц function(   ) функция_491; 

		//проц function(   ) функция_492; 

		//проц function(   ) функция_493; 

		//проц function(   ) функция_494; 

		//проц function(   ) функция_495; 

		//проц function(   ) функция_496; 

		//проц function(   ) функция_497; 

		//проц function(   ) функция_498; 

		//проц function(   ) функция_499; 

		//проц function(   ) функция_500; 

		//проц function(   ) функция_501; 

		//проц function(   ) функция_502; 

		//проц function(   ) функция_503; 

		//проц function(   ) функция_504; 

		//проц function(   ) функция_505; 

		//проц function(   ) функция_506; 

		//проц function(   ) функция_507; 

		//проц function(   ) функция_508; 

		//проц function(   ) функция_509; 

		//проц function(   ) функция_510; 

		//проц function(   ) функция_511; 

		//проц function(   ) функция_512; 

		//проц function(   ) функция_513; 

		//проц function(   ) функция_514; 

		//проц function(   ) функция_515; 

		//проц function(   ) функция_516; 

		//проц function(   ) функция_517; 

		//проц function(   ) функция_518; 

		//проц function(   ) функция_519; 

		//проц function(   ) функция_520; 

		//проц function(   ) функция_521; 

		//проц function(   ) функция_522; 

		//проц function(   ) функция_523; 

		//проц function(   ) функция_524; 

		//проц function(   ) функция_525; 

		//проц function(   ) функция_526; 

		//проц function(   ) функция_527; 

		//проц function(   ) функция_528; 

		//проц function(   ) функция_529; 

		//проц function(   ) функция_530; 

		//проц function(   ) функция_531; 

		//проц function(   ) функция_532; 

		//проц function(   ) функция_533; 

		//проц function(   ) функция_534; 

		//проц function(   ) функция_535; 

		//проц function(   ) функция_536; 

		//проц function(   ) функция_537; 

		//проц function(   ) функция_538; 

		//проц function(   ) функция_539; 

		//проц function(   ) функция_540; 

		//проц function(   ) функция_541; 

		//проц function(   ) функция_542; 

		//проц function(   ) функция_543; 

		//проц function(   ) функция_544; 

		//проц function(   ) функция_545; 

		//проц function(   ) функция_546; 

		//проц function(   ) функция_547; 

		//проц function(   ) функция_548; 

		//проц function(   ) функция_549; 

		//проц function(   ) функция_550; 

		//проц function(   ) функция_551; 

		//проц function(   ) функция_552; 

		//проц function(   ) функция_553; 

		//проц function(   ) функция_554; 

		//проц function(   ) функция_555; 

		//проц function(   ) функция_556; 

		//проц function(   ) функция_557; 

		//проц function(   ) функция_558; 

		//проц function(   ) функция_559; 

		//проц function(   ) функция_560; 

		//проц function(   ) функция_561; 

		//проц function(   ) функция_562; 

		//проц function(   ) функция_563; 

		//проц function(   ) функция_564; 

		//проц function(   ) функция_565; 

		//проц function(   ) функция_566; 

		//проц function(   ) функция_567; 

		//проц function(   ) функция_568; 

		//проц function(   ) функция_569; 

		//проц function(   ) функция_570; 

		//проц function(   ) функция_571; 

		//проц function(   ) функция_572; 

		//проц function(   ) функция_573; 

		//проц function(   ) функция_574; 

		//проц function(   ) функция_575; 

		//проц function(   ) функция_576; 

		//проц function(   ) функция_577; 

		//проц function(   ) функция_578; 

		//проц function(   ) функция_579; 

		//проц function(   ) функция_580; 

		//проц function(   ) функция_581; 

		проц function(GLdouble к) glIndexd; 
		проц function(GLdouble *к) glIndexdv;
		проц function(GLfloat к ) glIndexf; 
		проц function(GLfloat *к ) glIndexfv;
		проц function(GLint к) glIndexi; 
		проц function(GLint *к) glIndexiv; 

		//проц function(   ) функция_588; 

		//проц function(   ) функция_589; 

		//проц function(   ) функция_590; 

		проц function(GLshort к) glIndexs;
		проц function(GLshort *к) glIndexsv;
		проц function(GLubyte к) glIndexub; 
		проц function(GLubyte *к) glIndexubv; 

		//проц function(   ) функция_595; 

		//проц function(   ) функция_596; 

		//проц function(   ) функция_597; 

		//проц function(   ) функция_598; 

		//проц function(   ) функция_599; 

		//проц function(   ) функция_600; 

		//проц function(   ) функция_601; 

		//проц function(   ) функция_602; 

		//проц function(   ) функция_603; 

		//проц function(   ) функция_604; 

		//проц function(   ) функция_605; 

		//проц function(   ) функция_606; 

		//проц function(   ) функция_607; 

		//проц function(   ) функция_608; 

		//проц function(   ) функция_609; 

		//проц function(   ) функция_610; 

		//проц function(   ) функция_611; 

		//проц function(   ) функция_612; 

		//проц function(   ) функция_613; 

		//проц function(   ) функция_614; 

		//проц function(   ) функция_615; 

		проц function(плав а) глШиринаЛинии; 

		//проц function(   ) функция_617; 

		проц function() глЗагрузиИдент; 

		//проц function(   ) функция_619; 

		//проц function(   ) функция_620; 

		//проц function(   ) функция_621; 

		//проц function(   ) функция_622; 

		//проц function(   ) функция_623; 

		//проц function(   ) функция_624; 

		//проц function(   ) функция_625; 

		//проц function(   ) функция_626; 

		//проц function(   ) функция_627; 

		//проц function(   ) функция_628; 

		//проц function(   ) функция_629; 

		//проц function(   ) функция_630; 

		//проц function(   ) функция_631; 

		//проц function(   ) функция_632; 

		//проц function(   ) функция_633; 

		//проц function(   ) функция_634; 

		//проц function(   ) функция_635; 

		//проц function(   ) функция_636; 

		//проц function(   ) функция_637; 

		//проц function(   ) функция_638; 

		//проц function(   ) функция_639; 

		//проц function(   ) функция_640; 

		//проц function(   ) функция_641; 

		//проц function(   ) функция_642; 

		проц function(Гперечень а) глРежимМатр; 

		//проц function(   ) функция_644; 

		//проц function(   ) функция_645; 

		//проц function(   ) функция_646; 

		//проц function(   ) функция_647; 

		//проц function(   ) функция_648; 

		//проц function(   ) функция_649; 

		//проц function(   ) функция_650; 

		//проц function(   ) функция_651; 

		//проц function(   ) функция_652; 

		//проц function(   ) функция_653; 

		//проц function(   ) функция_654; 

		//проц function(   ) функция_655; 

		//проц function(   ) функция_656; 

		//проц function(   ) функция_657; 

		//проц function(   ) функция_658; 

		//проц function(   ) функция_659; 

		//проц function(   ) функция_660; 

		//проц function(   ) функция_661; 

		//проц function(   ) функция_662; 

		//проц function(   ) функция_663; 

		//проц function(   ) функция_664; 

		//проц function(   ) функция_665; 

		//проц function(   ) функция_666; 

		//проц function(   ) функция_667; 

		//проц function(   ) функция_668; 

		//проц function(   ) функция_669; 

		//проц function(   ) функция_670; 

		//проц function(   ) функция_671; 

		//проц function(   ) функция_672; 

		//проц function(   ) функция_673; 

		//проц function(   ) функция_674; 

		//проц function(   ) функция_675; 

		//проц function(   ) функция_676; 

		//проц function(   ) функция_677; 

		//проц function(   ) функция_678; 

		//проц function(   ) функция_679; 

		//проц function(   ) функция_680; 

		//проц function(   ) функция_681; 

		//проц function(   ) функция_682; 

		//проц function(   ) функция_683; 

		//проц function(   ) функция_684; 

		//проц function(   ) функция_685; 

		//проц function(   ) функция_686; 

		//проц function(   ) функция_687; 

		//проц function(   ) функция_688; 

		//проц function(   ) функция_689; 

		//проц function(   ) функция_690; 

		//проц function(   ) функция_691; 

		//проц function(   ) функция_692; 

		//проц function(   ) функция_693; 

		//проц function(   ) функция_694; 

		//проц function(   ) функция_695; 

		//проц function(   ) функция_696; 

		//проц function(   ) функция_697; 

		//проц function(   ) функция_698; 

		//проц function(   ) функция_699; 

		//проц function(   ) функция_700; 

		//проц function(   ) функция_701; 

		//проц function(   ) функция_702; 

		//проц function(   ) функция_703; 

		//проц function(   ) функция_704; 

		//проц function(   ) функция_705; 

		//проц function(   ) функция_706; 

		//проц function(   ) функция_707; 

		//проц function(   ) функция_708; 

		//проц function(   ) функция_709; 

		//проц function(   ) функция_710; 

		//проц function(   ) функция_711; 

		//проц function(   ) функция_712; 

		//проц function(   ) функция_713; 

		//проц function(   ) функция_714; 

		//проц function(   ) функция_715; 

		//проц function(   ) функция_716; 

		//проц function(   ) функция_717; 

		//проц function(   ) функция_718; 

		//проц function(   ) функция_719; 

		//проц function(   ) функция_720; 

		//проц function(   ) функция_721; 

		//проц function(   ) функция_722; 

		//проц function(   ) функция_723; 

		//проц function(   ) функция_724; 

		//проц function(   ) функция_725; 

		//проц function(   ) функция_726; 

		//проц function(   ) функция_727; 

		//проц function(   ) функция_728; 

		//проц function(   ) функция_729; 

		//проц function(   ) функция_730; 

		//проц function(   ) функция_731; 

		//проц function(   ) функция_732; 

		//проц function(   ) функция_733; 

		//проц function(   ) функция_734; 

		//проц function(   ) функция_735; 

		//проц function(   ) функция_736; 

		//проц function(   ) функция_737; 

		//проц function(   ) функция_738; 

		//проц function(   ) функция_739; 

		//проц function(   ) функция_740; 

		//проц function(   ) функция_741; 

		//проц function(   ) функция_742; 

		//проц function(   ) функция_743; 

		//проц function(   ) функция_744; 

		//проц function(   ) функция_745; 

		//проц function(   ) функция_746; 

		//проц function(   ) функция_747; 

		//проц function(   ) функция_748; 

		//проц function(   ) функция_749; 

		//проц function(   ) функция_750; 

		//проц function(   ) функция_751; 

		//проц function(   ) функция_752; 

		//проц function(   ) функция_753; 

		//проц function(   ) функция_754; 

		//проц function(   ) функция_755; 

		//проц function(   ) функция_756; 

		//проц function(   ) функция_757; 

		//проц function(   ) функция_758; 

		проц function() глВыньМатр; 

		//проц function(   ) функция_760; 

		//проц function(   ) функция_761; 

		//проц function(   ) функция_762; 

		//проц function(   ) функция_763; 

		//проц function(   ) функция_764; 

		//проц function(   ) функция_765; 

		//проц function(   ) функция_766; 

		//проц function(   ) функция_767; 

		//проц function(   ) функция_768; 

		//проц function(   ) функция_769; 

		//проц function(   ) функция_770; 

		//проц function(   ) функция_771; 

		//проц function(   ) функция_772; 

		//проц function(   ) функция_773; 

		//проц function(   ) функция_774; 

		//проц function(   ) функция_775; 

		//проц function(   ) функция_776; 

		//проц function(   ) функция_777; 

		//проц function(   ) функция_778; 

		//проц function(   ) функция_779; 

		//проц function(   ) функция_780; 

		//проц function(   ) функция_781; 

		//проц function(   ) функция_782; 

		//проц function(   ) функция_783; 

		проц function() глСуньМатр; 

		//проц function(   ) функция_785; 

		//проц function(   ) функция_786; 

		//проц function(   ) функция_787; 

		//проц function(   ) функция_788; 

		//проц function(   ) функция_789; 

		//проц function(   ) функция_790; 

		//проц function(   ) функция_791; 

		//проц function(   ) функция_792; 

		//проц function(   ) функция_793; 

		//проц function(   ) функция_794; 

		//проц function(   ) функция_795; 

		//проц function(   ) функция_796; 

		//проц function(   ) функция_797; 

		//проц function(   ) функция_798; 

		//проц function(   ) функция_799; 

		//проц function(   ) функция_800; 

		//проц function(   ) функция_801; 

		//проц function(   ) функция_802; 

		//проц function(   ) функция_803; 

		//проц function(   ) функция_804; 

		//проц function(   ) функция_805; 

		//проц function(   ) функция_806; 

		//проц function(   ) функция_807; 

		//проц function(   ) функция_808; 

		//проц function(   ) функция_809; 

		//проц function(   ) функция_810; 

		//проц function(   ) функция_811; 

		//проц function(   ) функция_812; 

		//проц function(   ) функция_813; 

		//проц function(   ) функция_814; 

		//проц function(   ) функция_815; 

		//проц function(   ) функция_816; 

		//проц function(   ) функция_817; 

		//проц function(   ) функция_818; 

		//проц function(   ) функция_819; 

		//проц function(   ) функция_820; 

		//проц function(   ) функция_821; 

		//проц function(   ) функция_822; 

		//проц function(   ) функция_823; 

		//проц function(   ) функция_824; 

		проц function(дво а,дво б,дво в,дво г) глВращайд;
		проц function(плав а, плав б, плав в, плав г) глВращай; 

		//проц function(   ) функция_827; 

		//проц function(   ) функция_828; 

		//проц function(   ) функция_829; 

		//проц function(   ) функция_830; 

		//проц function(   ) функция_831; 

		//проц function(   ) функция_832; 

		//проц function(   ) функция_833; 

		//проц function(   ) функция_834; 

		//проц function(   ) функция_835; 

		//проц function(   ) функция_836; 

		//проц function(   ) функция_837; 

		//проц function(   ) функция_838; 

		//проц function(   ) функция_839; 

		//проц function(   ) функция_840; 

		//проц function(   ) функция_841; 

		//проц function(   ) функция_842; 

		//проц function(   ) функция_843; 

		//проц function(   ) функция_844; 

		//проц function(   ) функция_845; 

		//проц function(   ) функция_846; 

		//проц function(   ) функция_847; 

		//проц function(   ) функция_848; 

		//проц function(   ) функция_849; 

		//проц function(   ) функция_850; 

		//проц function(   ) функция_851; 

		//проц function(   ) функция_852; 

		//проц function(   ) функция_853; 

		//проц function(   ) функция_854; 

		//проц function(   ) функция_855; 

		//проц function(   ) функция_856; 

		//проц function(   ) функция_857; 

		//проц function(   ) функция_858; 

		//проц function(   ) функция_859; 

		//проц function(   ) функция_860; 

		//проц function(   ) функция_861; 

		//проц function(   ) функция_862; 

		//проц function(   ) функция_863; 

		//проц function(   ) функция_864; 

		//проц function(   ) функция_865; 

		//проц function(   ) функция_866; 

		//проц function(   ) функция_867; 

		//проц function(   ) функция_868; 

		//проц function(   ) функция_869; 

		//проц function(   ) функция_870; 

		//проц function(   ) функция_871; 

		//проц function(   ) функция_872; 

		//проц function(   ) функция_873; 

		//проц function(   ) функция_874; 

		//проц function(   ) функция_875; 

		//проц function(   ) функция_876; 

		//проц function(   ) функция_877; 

		//проц function(   ) функция_878; 

		//проц function(   ) функция_879; 

		//проц function(   ) функция_880; 

		//проц function(   ) функция_881; 

		//проц function(   ) функция_882; 

		//проц function(   ) функция_883; 

		//проц function(   ) функция_884; 

		//проц function(   ) функция_885; 

		//проц function(   ) функция_886; 

		//проц function(   ) функция_887; 

		//проц function(   ) функция_888; 

		//проц function(   ) функция_889; 

		//проц function(   ) функция_890; 

		//проц function(   ) функция_891; 

		//проц function(   ) функция_892; 

		//проц function(   ) функция_893; 

		//проц function(   ) функция_894; 

		//проц function(   ) функция_895; 

		//проц function(   ) функция_896; 

		//проц function(   ) функция_897; 

		//проц function(   ) функция_898; 

		//проц function(   ) функция_899; 

		//проц function(   ) функция_900; 

		//проц function(   ) функция_901; 

		//проц function(   ) функция_902; 

		//проц function(   ) функция_903; 

		//проц function(   ) функция_904; 

		//проц function(   ) функция_905; 

		//проц function(   ) функция_906; 

		//проц function(   ) функция_907; 

		//проц function(   ) функция_908; 

		//проц function(   ) функция_909; 

		//проц function(   ) функция_910; 

		//проц function(   ) функция_911; 

		//проц function(   ) функция_912; 

		//проц function(   ) функция_913; 

		//проц function(   ) функция_914; 

		//проц function(   ) функция_915; 

		//проц function(   ) функция_916; 

		//проц function(   ) функция_917; 

		//проц function(   ) функция_918; 

		//проц function(   ) функция_919; 

		//проц function(   ) функция_920; 

		//проц function(   ) функция_921; 

		//проц function(   ) функция_922; 

		//проц function(   ) функция_923; 

		//проц function(   ) функция_924; 

		//проц function(   ) функция_925; 

		//проц function(   ) функция_926; 

		//проц function(   ) функция_927; 

		//проц function(   ) функция_928; 

		//проц function(   ) функция_929; 

		//проц function(   ) функция_930; 

		//проц function(   ) функция_931; 

		//проц function(   ) функция_932; 

		//проц function(   ) функция_933; 

		//проц function(   ) функция_934; 

		//проц function(   ) функция_935; 

		проц function(GLdouble x, GLdouble y) glVertex2d; 
		проц function(GLdouble *v) glVertex2dv;
		проц function(GLfloat x, GLfloat y) glVertex2f; 
		проц function(GLfloat *v) glVertex2fv; 
		проц function(GLint x, GLint y) glVertex2i; 
		проц function(GLint *v) glVertex2iv; 
		проц function(GLshort x, GLshort y) glVertex2s; 
		проц function(GLshort *v) glVertex2sv; 
		проц function(GLdouble x, GLdouble y, GLdouble z) glVertex3d; 
		проц function(GLdouble *v) glVertex3dv; 
		проц function(GLfloat x, GLfloat y, GLfloat z) glVertex3f; 
		проц function(GLfloat *v) glVertex3fv; 
		проц function(GLint x, GLint y, GLint z) glVertex3i;
		проц function(GLint *v) glVertex3iv; 
		проц function(GLshort x, GLshort y, GLshort z) glVertex3s; 
		проц function(GLshort *v) glVertex3sv; 
		проц function(GLdouble x, GLdouble y, GLdouble z, GLdouble w) glVertex4d; 
		проц function(GLdouble *v) glVertex4dv; 
		проц function( GLfloat x, GLfloat y, GLfloat z, GLfloat w) glVertex4f; 
		проц function(GLfloat *v) glVertex4fv; 
		проц function(GLint x, GLint y, GLint z, GLint w) glVertex4i; 
		проц function( GLint *v  ) glVertex4iv; 
		проц function(GLshort x, GLshort y, GLshort z, GLshort w) glVertex4s; 
		проц function(GLshort *v) glVertex4sv; 

		//проц function(   ) функция_960; 

		//проц function(   ) функция_961; 

		//проц function(   ) функция_962; 

		//проц function(   ) функция_963; 

		//проц function(   ) функция_964; 

		//проц function(   ) функция_965; 

		//проц function(   ) функция_966; 

		//проц function(   ) функция_967; 

		//проц function(   ) функция_968; 

		//проц function(   ) функция_969; 

		//проц function(   ) функция_970; 

		//проц function(   ) функция_971; 

		//проц function(   ) функция_972; 

		//проц function(   ) функция_973; 

		//проц function(   ) функция_974; 

		//проц function(   ) функция_975; 

		//проц function(   ) функция_976; 

		//проц function(   ) функция_977; 

		//проц function(   ) функция_978; 

		//проц function(   ) функция_979; 

		//проц function(   ) функция_980; 

		//проц function(   ) функция_981; 

		//проц function(   ) функция_982; 

		//проц function(   ) функция_983; 

		//проц function(   ) функция_984; 

		//проц function(   ) функция_985; 

		//проц function(   ) функция_986; 

		//проц function(   ) функция_987; 

		//проц function(   ) функция_988; 

		//проц function(   ) функция_989; 

		//проц function(   ) функция_990; 

		//проц function(   ) функция_991; 

		//проц function(   ) функция_992; 

		//проц function(   ) функция_993; 

		//проц function(   ) функция_994; 

		//проц function(   ) функция_995; 

		//проц function(   ) функция_996; 

		//проц function(   ) функция_997; 

		//проц function(   ) функция_998; 

		//проц function(   ) функция_999; 

		//проц function(   ) функция_1000; 

		//проц function(   ) функция_1001; 

		//проц function(   ) функция_1002; 

		//проц function(   ) функция_1003; 

		//проц function(   ) функция_1004; 

		//проц function(   ) функция_1005; 

		//проц function(   ) функция_1006; 

		//проц function(   ) функция_1007; 

		//проц function(   ) функция_1008; 

		//проц function(   ) функция_1009; 

		//проц function(   ) функция_1010; 

		//проц function(   ) функция_1011; 

		//проц function(   ) функция_1012; 

		//проц function(   ) функция_1013; 

		//проц function(   ) функция_1014; 

		//проц function(   ) функция_1015; 

		//проц function(   ) функция_1016; 

		//проц function(   ) функция_1017; 

		//проц function(   ) функция_1018; 

		//проц function(   ) функция_1019; 

		//проц function(   ) функция_1020; 

		//проц function(   ) функция_1021; 

		//проц function(   ) функция_1022; 

		//проц function(   ) функция_1023; 

		//проц function(   ) функция_1024; 

		//проц function(   ) функция_1025; 

		//проц function(   ) функция_1026; 

		//проц function(   ) функция_1027; 

		//проц function(   ) функция_1028; 

		//проц function(   ) функция_1029; 

		//проц function(   ) функция_1030; 

		//проц function(   ) функция_1031; 

		//проц function(   ) функция_1032; 

		//проц function(   ) функция_1033; 

		//проц function(   ) функция_1034; 

		//проц function(   ) функция_1035; 

		//проц function(   ) функция_1036; 

		//проц function(   ) функция_1037; 

		//проц function(   ) функция_1038; 

		//проц function(   ) функция_1039; 

		проц function(цел а,цел б,Гцразм в,Гцразм г) глВьюпорт; 

		//проц function(   ) функция_1041; 

		//проц function(   ) функция_1042; 

		//проц function(   ) функция_1043; 

		//проц function(   ) функция_1044; 

		//проц function(   ) функция_1045; 

		//проц function(   ) функция_1046; 

		//проц function(   ) функция_1047; 

		//проц function(   ) функция_1048; 

		//проц function(   ) функция_1049; 

		//проц function(   ) функция_1050; 

		//проц function(   ) функция_1051; 

		//проц function(   ) функция_1052; 

		//проц function(   ) функция_1053; 

		//проц function(   ) функция_1054; 

		//проц function(   ) функция_1055; 

		//проц function(   ) функция_1056; 

		//проц function(   ) функция_1057; 

		//проц function(   ) функция_1058; 

		//проц function(   ) функция_1059; 

		//проц function(   ) функция_1060; 

		//проц function(   ) функция_1061; 

		//проц function(   ) функция_1062; 

		//проц function(   ) функция_1063; 

		//проц function(   ) функция_1064; 

		//проц function(   ) функция_1065; 

		//проц function(   ) функция_1066; 

		//проц function(   ) функция_1067; 

		//проц function(   ) функция_1068; 

		//проц function(   ) функция_1069; 

		//проц function(   ) функция_1070; 

		//проц function(   ) функция_1071; 

		//проц function(   ) функция_1072; 

		//проц function(   ) функция_1073; 

		//проц function(   ) функция_1074; 

		//проц function(   ) функция_1075; 

		//проц function(   ) функция_1076; 

		//проц function(   ) функция_1077; 

		//проц function(   ) функция_1078; 

		//проц function(   ) функция_1079; 

		//проц function(   ) функция_1080; 

		//проц function(   ) функция_1081; 

		//проц function(   ) функция_1082; 

		//проц function(   ) функция_1083; 

		//проц function(   ) функция_1084; 

		//проц function(   ) функция_1085; 

		//проц function(   ) функция_1086; 

		//проц function(   ) функция_1087; 

		//проц function(   ) функция_1088; 

		//проц function(   ) функция_1089; 

		//проц function(   ) функция_1090; 

		//проц function(   ) функция_1091; 

		//проц function(   ) функция_1092; 

		//проц function(   ) функция_1093; 

		//проц function(   ) функция_1094; 

		//проц function(   ) функция_1095; 

		//проц function(   ) функция_1096; 

		//проц function(   ) функция_1097; 

		//проц function(   ) функция_1098; 

		//проц function(   ) функция_1099; 

		//проц function(   ) функция_1100; 

		//проц function(   ) функция_1101; 

		//проц function(   ) функция_1102; 

		//проц function(   ) функция_1103; 

		//проц function(   ) функция_1104; 

		//проц function(   ) функция_1105; 

		//проц function(   ) функция_1106; 

		//проц function(   ) функция_1107; 

		//проц function(   ) функция_1108; 

		//проц function(   ) функция_1109; 

		//проц function(   ) функция_1110; 

		//проц function(   ) функция_1111; 

		//проц function(   ) функция_1112; 

		//проц function(   ) функция_1113; 

		//проц function(   ) функция_1114; 

		//проц function(   ) функция_1115; 

		//проц function(   ) функция_1116; 

		//проц function(   ) функция_1117; 

		//проц function(   ) функция_1118; 

		//проц function(   ) функция_1119; 

		//проц function(   ) функция_1120; 

		//проц function(   ) функция_1121; 

		//проц function(   ) функция_1122; 

		//проц function(   ) функция_1123; 

		//проц function(   ) функция_1124; 

		//проц function(   ) функция_1125; 

		//проц function(   ) функция_1126; 

		//проц function(   ) функция_1127; 

		//проц function(   ) функция_1128; 

		//проц function(   ) функция_1129; 

		//проц function(   ) функция_1130; 

		//проц function(   ) функция_1131; 

		//проц function(   ) функция_1132; 

		//проц function(   ) функция_1133; 

		//проц function(   ) функция_1134; 

		//проц function(   ) функция_1135; 

		//проц function(   ) функция_1136; 

		//проц function(   ) функция_1137; 

		//проц function(   ) функция_1138; 

		//проц function(   ) функция_1139; 

		//проц function(   ) функция_1140; 

		//проц function(   ) функция_1141; 

		//проц function(   ) функция_1142; 

		//проц function(   ) функция_1143; 

		//проц function(   ) функция_1144; 

		//проц function(   ) функция_1145; 

		//проц function(   ) функция_1146; 

		//проц function(   ) функция_1147; 

		//проц function(   ) функция_1148; 

		//проц function(   ) функция_1149; 

		//проц function(   ) функция_1150; 

		//проц function(   ) функция_1151; 

		//проц function(   ) функция_1152; 

		//проц function(   ) функция_1153; 

		//проц function(   ) функция_1154; 

		//проц function(   ) функция_1155; 

		//проц function(   ) функция_1156; 

		//проц function(   ) функция_1157; 

		//проц function(   ) функция_1158; 

		//проц function(   ) функция_1159; 

		//проц function(   ) функция_1160; 

		//проц function(   ) функция_1161; 

		//проц function(   ) функция_1162; 

		//проц function(   ) функция_1163; 

		//проц function(   ) функция_1164; 

		//проц function(   ) функция_1165; 

		//проц function(   ) функция_1166; 

		//проц function(   ) функция_1167; 

		//проц function(   ) функция_1168; 

		//проц function(   ) функция_1169; 

		//проц function(   ) функция_1170; 

		//проц function(   ) функция_1171; 

		//проц function(   ) функция_1172; 

		//проц function(   ) функция_1173; 

		//проц function(   ) функция_1174; 

		//проц function(   ) функция_1175; 

		//проц function(   ) функция_1176; 

		//проц function(   ) функция_1177; 

		//проц function(   ) функция_1178; 

		//проц function(   ) функция_1179; 

		//проц function(   ) функция_1180; 

		//проц function(   ) функция_1181; 

		//проц function(   ) функция_1182; 

		//проц function(   ) функция_1183; 

		//проц function(   ) функция_1184; 

		//проц function(   ) функция_1185; 

		//проц function(   ) функция_1186; 

		//проц function(   ) функция_1187; 

		//проц function(   ) функция_1188; 

		//проц function(   ) функция_1189; 

		//проц function(   ) функция_1190; 

		//проц function(   ) функция_1191; 

		//проц function(   ) функция_1192; 

		//проц function(   ) функция_1193; 

		//проц function(   ) функция_1194; 

		//проц function(   ) функция_1195; 

		//проц function(   ) функция_1196; 

		//проц function(   ) функция_1197; 

		//проц function(   ) функция_1198; 

		//проц function(   ) функция_1199; 

		//проц function(   ) функция_1200; 

		//проц function(   ) функция_1201; 

		//проц function(   ) функция_1202; 

		//проц function(   ) функция_1203; 

		//проц function(   ) функция_1204; 

		//проц function(   ) функция_1205; 

		//проц function(   ) функция_1206; 

		//проц function(   ) функция_1207; 

		//проц function(   ) функция_1208; 

		//проц function(   ) функция_1209; 

		//проц function(   ) функция_1210; 

		//проц function(   ) функция_1211; 

		//проц function(   ) функция_1212; 

		//проц function(   ) функция_1213; 

		//проц function(   ) функция_1214; 

		//проц function(   ) функция_1215; 

		//проц function(   ) функция_1216; 

		//проц function(   ) функция_1217; 

		//проц function(   ) функция_1218; 

		//проц function(   ) функция_1219; 

		//проц function(   ) функция_1220; 

		//проц function(   ) функция_1221; 

		//проц function(   ) функция_1222; 

		//проц function(   ) функция_1223; 

		//проц function(   ) функция_1224; 

		//проц function(   ) функция_1225; 

		//проц function(   ) функция_1226; 

		//проц function(   ) функция_1227; 

		//проц function(   ) функция_1228; 

		//проц function(   ) функция_1229; 

		//проц function(   ) функция_1230; 

		//проц function(   ) функция_1231; 

		//проц function(   ) функция_1232; 

		//проц function(   ) функция_1233; 

		//проц function(   ) функция_1234; 

		//проц function(   ) функция_1235; 

		//проц function(   ) функция_1236; 

		//проц function(   ) функция_1237; 

		//проц function(   ) функция_1238; 

		//проц function(   ) функция_1239; 

		//проц function(   ) функция_1240; 

		//проц function(   ) функция_1241; 

		//проц function(   ) функция_1242; 

		//проц function(   ) функция_1243; 

		//проц function(   ) функция_1244; 

		//проц function(   ) функция_1245; 

		//проц function(   ) функция_1246; 

		//проц function(   ) функция_1247; 

		//проц function(   ) функция_1248; 

		//проц function(   ) функция_1249; 

		//проц function(   ) функция_1250; 

		//проц function(   ) функция_1251; 

		//проц function(   ) функция_1252; 

		//проц function(   ) функция_1253; 

		//проц function(   ) функция_1254; 

		//проц function(   ) функция_1255; 

		//проц function(   ) функция_1256; 

		//проц function(   ) функция_1257; 

		//проц function(   ) функция_1258; 

		//проц function(   ) функция_1259; 

		//проц function(   ) функция_1260; 

		//проц function(   ) функция_1261; 

		//проц function(   ) функция_1262; 

		//проц function(   ) функция_1263; 

		//проц function(   ) функция_1264; 

		//проц function(   ) функция_1265; 

		//проц function(   ) функция_1266; 

		//проц function(   ) функция_1267; 

		//проц function(   ) функция_1268; 

		//проц function(   ) функция_1269; 

		//проц function(   ) функция_1270; 

		//проц function(   ) функция_1271; 

		//проц function(   ) функция_1272; 

		//проц function(   ) функция_1273; 

		//проц function(   ) функция_1274; 

		//проц function(   ) функция_1275; 

		//проц function(   ) функция_1276; 

		//проц function(   ) функция_1277; 

		//проц function(   ) функция_1278; 

		//проц function(   ) функция_1279; 

		//проц function(   ) функция_1280; 

		//проц function(   ) функция_1281; 

		//проц function(   ) функция_1282; 

		//проц function(   ) функция_1283; 

		//проц function(   ) функция_1284; 

		//проц function(   ) функция_1285; 

		//проц function(   ) функция_1286; 

		//проц function(   ) функция_1287; 

		//проц function(   ) функция_1288; 

		//проц function(   ) функция_1289; 

		//проц function(   ) функция_1290; 

		//проц function(   ) функция_1291; 

		//проц function(   ) функция_1292; 

		//проц function(   ) функция_1293; 

		//проц function(   ) функция_1294; 

		//проц function(   ) функция_1295; 

		//проц function(   ) функция_1296; 

		//проц function(   ) функция_1297; 

		//проц function(   ) функция_1298; 

		//проц function(   ) функция_1299; 

		//проц function(   ) функция_1300; 

		//проц function(   ) функция_1301; 

		//проц function(   ) функция_1302; 

		//проц function(   ) функция_1303; 

		//проц function(   ) функция_1304; 

		//проц function(   ) функция_1305; 

		//проц function(   ) функция_1306; 

		//проц function(   ) функция_1307; 

		//проц function(   ) функция_1308; 

		//проц function(   ) функция_1309; 

		//проц function(   ) функция_1310; 

		//проц function(   ) функция_1311; 

		//проц function(   ) функция_1312; 

		//проц function(   ) функция_1313; 

		//проц function(   ) функция_1314; 

		//проц function(   ) функция_1315; 

		//проц function(   ) функция_1316; 

		//проц function(   ) функция_1317; 

		//проц function(   ) функция_1318; 

		//проц function(   ) функция_1319; 

		//проц function(   ) функция_1320; 

		//проц function(   ) функция_1321; 

		//проц function(   ) функция_1322; 

		//проц function(   ) функция_1323; 

		//проц function(   ) функция_1324; 

		//проц function(   ) функция_1325; 

		//проц function(   ) функция_1326; 

		//проц function(   ) функция_1327; 

		//проц function(   ) функция_1328; 

		//проц function(   ) функция_1329; 

		//проц function(   ) функция_1330; 

		//проц function(   ) функция_1331; 

		//проц function(   ) функция_1332; 

		//проц function(   ) функция_1333; 

		//проц function(   ) функция_1334; 

		//проц function(   ) функция_1335; 

		//проц function(   ) функция_1336; 

		//проц function(   ) функция_1337; 

		//проц function(   ) функция_1338; 

		//проц function(   ) функция_1339; 

		//проц function(   ) функция_1340; 

		//проц function(   ) функция_1341; 

		//проц function(   ) функция_1342; 

		//проц function(   ) функция_1343; 

		//проц function(   ) функция_1344; 

		//проц function(   ) функция_1345; 

		//проц function(   ) функция_1346; 

		//проц function(   ) функция_1347; 

		//проц function(   ) функция_1348; 

		//проц function(   ) функция_1349; 

		//проц function(   ) функция_1350; 

		//проц function(   ) функция_1351; 

		//проц function(   ) функция_1352; 

		//проц function(   ) функция_1353; 

		//проц function(   ) функция_1354; 

		//проц function(   ) функция_1355; 

		//проц function(   ) функция_1356; 

		//проц function(   ) функция_1357; 

		//проц function(   ) функция_1358; 

		//проц function(   ) функция_1359; 

		//проц function(   ) функция_1360; 

		//проц function(   ) функция_1361; 

		//проц function(   ) функция_1362; 

		//проц function(   ) функция_1363; 

		//проц function(   ) функция_1364; 

		//проц function(   ) функция_1365; 

		//проц function(   ) функция_1366; 

		//проц function(   ) функция_1367; 

		//проц function(   ) функция_1368; 

		//проц function(   ) функция_1369; 

		//проц function(   ) функция_1370; 

		//проц function(   ) функция_1371; 

		//проц function(   ) функция_1372; 

		//проц function(   ) функция_1373; 

		//проц function(   ) функция_1374; 

		//проц function(   ) функция_1375; 

		//проц function(   ) функция_1376; 

		//проц function(   ) функция_1377; 

		//проц function(   ) функция_1378; 

		//проц function(   ) функция_1379; 

		//проц function(   ) функция_1380; 

		//проц function(   ) функция_1381; 

		//проц function(   ) функция_1382; 

		//проц function(   ) функция_1383; 

		//проц function(   ) функция_1384; 

		//проц function(   ) функция_1385; 

		//проц function(   ) функция_1386; 

		//проц function(   ) функция_1387; 

		//проц function(   ) функция_1388; 

		//проц function(   ) функция_1389; 

		//проц function(   ) функция_1390; 

		//проц function(   ) функция_1391; 

		//проц function(   ) функция_1392; 

		//проц function(   ) функция_1393; 

		//проц function(   ) функция_1394; 

		//проц function(   ) функция_1395; 

		//проц function(   ) функция_1396; 

		//проц function(   ) функция_1397; 

		//проц function(   ) функция_1398; 

		//проц function(   ) функция_1399; 

		//проц function(   ) функция_1400; 

		//проц function(   ) функция_1401; 

		//проц function(   ) функция_1402; 

		//проц function(   ) функция_1403; 

		//проц function(   ) функция_1404; 

		//проц function(   ) функция_1405; 

		//проц function(   ) функция_1406; 

		//проц function(   ) функция_1407; 

		//проц function(   ) функция_1408; 

		//проц function(   ) функция_1409; 

		//проц function(   ) функция_1410; 

		//проц function(   ) функция_1411; 

		//проц function(   ) функция_1412; 

		//проц function(   ) функция_1413; 

		//проц function(   ) функция_1414; 

		//проц function(   ) функция_1415; 

		//проц function(   ) функция_1416; 

		//проц function(   ) функция_1417; 

		//проц function(   ) функция_1418; 

		//проц function(   ) функция_1419; 

		//проц function(   ) функция_1420; 

		//проц function(   ) функция_1421; 

		//проц function(   ) функция_1422; 

		//проц function(   ) функция_1423; 

		//проц function(   ) функция_1424; 

		//проц function(   ) функция_1425; 

		//проц function(   ) функция_1426; 

		//проц function(   ) функция_1427; 

		//проц function(   ) функция_1428; 

		//проц function(   ) функция_1429; 

		//проц function(   ) функция_1430; 

		//проц function(   ) функция_1431; 

		//проц function(   ) функция_1432; 

		//проц function(   ) функция_1433; 

		//проц function(   ) функция_1434; 

		//проц function(   ) функция_1435; 

		//проц function(   ) функция_1436; 

		//проц function(   ) функция_1437; 

		//проц function(   ) функция_1438; 

		//проц function(   ) функция_1439; 

		//проц function(   ) функция_1440; 

		//проц function(   ) функция_1441; 

		//проц function(   ) функция_1442; 

		//проц function(   ) функция_1443; 

		//проц function(   ) функция_1444; 

		//проц function(   ) функция_1445; 

		//проц function(   ) функция_1446; 

		//проц function(   ) функция_1447; 

		//проц function(   ) функция_1448; 

		//проц function(   ) функция_1449; 

		//проц function(   ) функция_1450; 

		//проц function(   ) функция_1451; 

		//проц function(   ) функция_1452; 

		//проц function(   ) функция_1453; 

		//проц function(   ) функция_1454; 

		//проц function(   ) функция_1455; 

		//проц function(   ) функция_1456; 

		//проц function(   ) функция_1457; 

		//проц function(   ) функция_1458; 

		//проц function(   ) функция_1459; 

		//проц function(   ) функция_1460; 

		//проц function(   ) функция_1461; 

		//проц function(   ) функция_1462; 

		//проц function(   ) функция_1463; 

		//проц function(   ) функция_1464; 

		//проц function(   ) функция_1465; 

		//проц function(   ) функция_1466; 

		//проц function(   ) функция_1467; 

		//проц function(   ) функция_1468; 

		//проц function(   ) функция_1469; 

		//проц function(   ) функция_1470; 

		//проц function(   ) функция_1471; 

		//проц function(   ) функция_1472; 

		//проц function(   ) функция_1473; 

		//проц function(   ) функция_1474; 

		//проц function(   ) функция_1475; 

		//проц function(   ) функция_1476; 

		//проц function(   ) функция_1477; 

		//проц function(   ) функция_1478; 

		//проц function(   ) функция_1479; 

		//проц function(   ) функция_1480; 

		//проц function(   ) функция_1481; 

		//проц function(   ) функция_1482; 

		//проц function(   ) функция_1483; 

		//проц function(   ) функция_1484; 

		//проц function(   ) функция_1485; 

		//проц function(   ) функция_1486; 

		//проц function(   ) функция_1487; 

		//проц function(   ) функция_1488; 

		//проц function(   ) функция_1489; 

		//проц function(   ) функция_1490; 

		//проц function(   ) функция_1491; 

		//проц function(   ) функция_1492; 

		//проц function(   ) функция_1493; 

		//проц function(   ) функция_1494; 

		//проц function(   ) функция_1495; 

		//проц function(   ) функция_1496; 

		//проц function(   ) функция_1497; 

		//проц function(   ) функция_1498; 

		//проц function(   ) функция_1499; 

		//проц function(   ) функция_1500; 

		//проц function(   ) функция_1501; 

		//проц function(   ) функция_1502; 

		//проц function(   ) функция_1503; 

		//проц function(   ) функция_1504; 

		//проц function(   ) функция_1505; 

		//проц function(   ) функция_1506; 

		//проц function(   ) функция_1507; 

		//проц function(   ) функция_1508; 

		//проц function(   ) функция_1509; 

		//проц function(   ) функция_1510; 

		//проц function(   ) функция_1511; 

		//проц function(   ) функция_1512; 

		//проц function(   ) функция_1513; 

		//проц function(   ) функция_1514; 

		//проц function(   ) функция_1515; 

		//проц function(   ) функция_1516; 

		//проц function(   ) функция_1517; 

		//проц function(   ) функция_1518; 

		//проц function(   ) функция_1519; 

		//проц function(   ) функция_1520; 

		//проц function(   ) функция_1521; 

		//проц function(   ) функция_1522; 

		//проц function(   ) функция_1523; 

		//проц function(   ) функция_1524; 

		//проц function(   ) функция_1525; 

		//проц function(   ) функция_1526; 

		//проц function(   ) функция_1527; 

		//проц function(   ) функция_1528; 

		//проц function(   ) функция_1529; 

		//проц function(   ) функция_1530; 

		//проц function(   ) функция_1531; 

		//проц function(   ) функция_1532; 

		//проц function(   ) функция_1533; 

		//проц function(   ) функция_1534; 

		//проц function(   ) функция_1535; 

		//проц function(   ) функция_1536; 

		//проц function(   ) функция_1537; 

		//проц function(   ) функция_1538; 

		//проц function(   ) функция_1539; 

		//проц function(   ) функция_1540; 

		//проц function(   ) функция_1541; 

		//проц function(   ) функция_1542; 

		//проц function(   ) функция_1543; 

		//проц function(   ) функция_1544; 

		//проц function(   ) функция_1545; 

		//проц function(   ) функция_1546; 

		//проц function(   ) функция_1547; 

		//проц function(   ) функция_1548; 

		//проц function(   ) функция_1549; 

		//проц function(   ) функция_1550; 

		//проц function(   ) функция_1551; 

		//проц function(   ) функция_1552; 

		//проц function(   ) функция_1553; 

		//проц function(   ) функция_1554; 

		//проц function(   ) функция_1555; 

		//проц function(   ) функция_1556; 

		//проц function(   ) функция_1557; 

		//проц function(   ) функция_1558; 

		//проц function(   ) функция_1559; 

		//проц function(   ) функция_1560; 

		//проц function(   ) функция_1561; 

		//проц function(   ) функция_1562; 

		//проц function(   ) функция_1563; 

		//проц function(   ) функция_1564; 

		//проц function(   ) функция_1565; 

		//проц function(   ) функция_1566; 

		//проц function(   ) функция_1567; 

		//проц function(   ) функция_1568; 

		//проц function(   ) функция_1569; 

		//проц function(   ) функция_1570; 

		//проц function(   ) функция_1571; 

		//проц function(   ) функция_1572; 

		//проц function(   ) функция_1573; 

		//проц function(   ) функция_1574; 

		//проц function(   ) функция_1575; 

		//проц function(   ) функция_1576; 

		//проц function(   ) функция_1577; 

		//проц function(   ) функция_1578; 

		//проц function(   ) функция_1579; 

		//проц function(   ) функция_1580; 

		//проц function(   ) функция_1581; 

		//проц function(   ) функция_1582; 

		//проц function(   ) функция_1583; 

		//проц function(   ) функция_1584; 

		//проц function(   ) функция_1585; 

		//проц function(   ) функция_1586; 

		//проц function(   ) функция_1587; 

		//проц function(   ) функция_1588; 

		//проц function(   ) функция_1589; 

		//проц function(   ) функция_1590; 

		//проц function(   ) функция_1591; 

		//проц function(   ) функция_1592; 

		//проц function(   ) функция_1593; 

		//проц function(   ) функция_1594; 

		//проц function(   ) функция_1595; 

		//проц function(   ) функция_1596; 

		//проц function(   ) функция_1597; 

		//проц function(   ) функция_1598; 

		//проц function(   ) функция_1599; 

		//проц function(   ) функция_1600; 

		//проц function(   ) функция_1601; 

		//проц function(   ) функция_1602; 

		//проц function(   ) функция_1603; 

		//проц function(   ) функция_1604; 

		//проц function(   ) функция_1605; 

		//проц function(   ) функция_1606; 

		//проц function(   ) функция_1607; 

		//проц function(   ) функция_1608; 

		//проц function(   ) функция_1609; 

		//проц function(   ) функция_1610; 

		//проц function(   ) функция_1611; 

		//проц function(   ) функция_1612; 

		//проц function(   ) функция_1613; 

		//проц function(   ) функция_1614; 

		//проц function(   ) функция_1615; 

		//проц function(   ) функция_1616; 

		//проц function(   ) функция_1617; 

		//проц function(   ) функция_1618; 

		//проц function(   ) функция_1619; 

		//проц function(   ) функция_1620; 

		//проц function(   ) функция_1621; 

		//проц function(   ) функция_1622; 

		//проц function(   ) функция_1623; 

		//проц function(   ) функция_1624; 

		//проц function(   ) функция_1625; 

		//проц function(   ) функция_1626; 

		//проц function(   ) функция_1627; 

		//проц function(   ) функция_1628; 

		//проц function(   ) функция_1629; 

		//проц function(   ) функция_1630; 

		//проц function(   ) функция_1631; 

		//проц function(   ) функция_1632; 

		//проц function(   ) функция_1633; 

		//проц function(   ) функция_1634; 

		//проц function(   ) функция_1635; 

		//проц function(   ) функция_1636; 

		//проц function(   ) функция_1637; 

		//проц function(   ) функция_1638; 

		//проц function(   ) функция_1639; 

		//проц function(   ) функция_1640; 

		//проц function(   ) функция_1641; 

		//проц function(   ) функция_1642; 

		//проц function(   ) функция_1643; 

		//проц function(   ) функция_1644; 

		//проц function(   ) функция_1645; 

		//проц function(   ) функция_1646; 

		//проц function(   ) функция_1647; 

		//проц function(   ) функция_1648; 

		//проц function(   ) функция_1649; 

		//проц function(   ) функция_1650; 

		//проц function(   ) функция_1651; 

		//проц function(   ) функция_1652; 

		//проц function(   ) функция_1653; 

		//проц function(   ) функция_1654; 

		//проц function(   ) функция_1655; 

		//проц function(   ) функция_1656; 

		//проц function(   ) функция_1657; 

		//проц function(   ) функция_1658; 

		//проц function(   ) функция_1659; 

		//проц function(   ) функция_1660; 

		//проц function(   ) функция_1661; 

		//проц function(   ) функция_1662; 

		//проц function(   ) функция_1663; 

		//проц function(   ) функция_1664; 

		//проц function(   ) функция_1665; 

		//проц function(   ) функция_1666; 

		//проц function(   ) функция_1667; 

		//проц function(   ) функция_1668; 

		//проц function(   ) функция_1669; 

		//проц function(   ) функция_1670; 

		//проц function(   ) функция_1671; 

		//проц function(   ) функция_1672; 

		//проц function(   ) функция_1673; 

		//проц function(   ) функция_1674; 

		//проц function(   ) функция_1675; 

		//проц function(   ) функция_1676; 

		//проц function(   ) функция_1677; 

		//проц function(   ) функция_1678; 

		//проц function(   ) функция_1679; 

		//проц function(   ) функция_1680; 

		//проц function(   ) функция_1681; 

		//проц function(   ) функция_1682; 

		//проц function(   ) функция_1683; 

		//проц function(   ) функция_1684; 

		//проц function(   ) функция_1685; 

		//проц function(   ) функция_1686; 

		//проц function(   ) функция_1687; 

		//проц function(   ) функция_1688; 

		//проц function(   ) функция_1689; 

		//проц function(   ) функция_1690; 

		//проц function(   ) функция_1691; 

		//проц function(   ) функция_1692; 

		//проц function(   ) функция_1693; 

		//проц function(   ) функция_1694; 

		//проц function(   ) функция_1695; 

		//проц function(   ) функция_1696; 

		//проц function(   ) функция_1697; 

		//проц function(   ) функция_1698; 

		//проц function(   ) функция_1699; 

		//проц function(   ) функция_1700; 

		//проц function(   ) функция_1701; 

		//проц function(   ) функция_1702; 

		//проц function(   ) функция_1703; 

		//проц function(   ) функция_1704; 

		//проц function(   ) функция_1705; 

		//проц function(   ) функция_1706; 

		//проц function(   ) функция_1707; 

		//проц function(   ) функция_1708; 

		//проц function(   ) функция_1709; 

		//проц function(   ) функция_1710; 

		//проц function(   ) функция_1711; 

		//проц function(   ) функция_1712; 

		//проц function(   ) функция_1713; 

		//проц function(   ) функция_1714; 

		//проц function(   ) функция_1715; 

		//проц function(   ) функция_1716; 

		//проц function(   ) функция_1717; 

		//проц function(   ) функция_1718; 

		//проц function(   ) функция_1719; 

		//проц function(   ) функция_1720; 

		//проц function(   ) функция_1721; 

		//проц function(   ) функция_1722; 

		//проц function(   ) функция_1723; 

		//проц function(   ) функция_1724; 

		//проц function(   ) функция_1725; 

		//проц function(   ) функция_1726; 

		//проц function(   ) функция_1727; 

		//проц function(   ) функция_1728; 

		//проц function(   ) функция_1729; 

		//проц function(   ) функция_1730; 

		//проц function(   ) функция_1731; 

		//проц function(   ) функция_1732; 

		//проц function(   ) функция_1733; 

		//проц function(   ) функция_1734; 

		//проц function(   ) функция_1735; 

		//проц function(   ) функция_1736; 

		//проц function(   ) функция_1737; 

		//проц function(   ) функция_1738; 

		//проц function(   ) функция_1739; 

		//проц function(   ) функция_1740; 

		//проц function(   ) функция_1741; 

		//проц function(   ) функция_1742; 

		//проц function(   ) функция_1743; 

		//проц function(   ) функция_1744; 

		//проц function(   ) функция_1745; 

		//проц function(   ) функция_1746; 

		//проц function(   ) функция_1747; 

		//проц function(   ) функция_1748; 

		//проц function(   ) функция_1749; 

		//проц function(   ) функция_1750; 

		//проц function(   ) функция_1751; 

		//проц function(   ) функция_1752; 

		//проц function(   ) функция_1753; 

		//проц function(   ) функция_1754; 

		//проц function(   ) функция_1755; 

		//проц function(   ) функция_1756; 

		//проц function(   ) функция_1757; 

		//проц function(   ) функция_1758; 

		//проц function(   ) функция_1759; 

		//проц function(   ) функция_1760; 

		//проц function(   ) функция_1761; 

		//проц function(   ) функция_1762; 

		//проц function(   ) функция_1763; 

		//проц function(   ) функция_1764; 

		//проц function(   ) функция_1765; 

		//проц function(   ) функция_1766; 

		//проц function(   ) функция_1767; 

		//проц function(   ) функция_1768; 

		//проц function(   ) функция_1769; 

		//проц function(   ) функция_1770; 

		//проц function(   ) функция_1771; 

		//проц function(   ) функция_1772; 

		//проц function(   ) функция_1773; 

		//проц function(   ) функция_1774; 

		//проц function(   ) функция_1775; 

		//проц function(   ) функция_1776; 

		//проц function(   ) функция_1777; 

		//проц function(   ) функция_1778; 

		//проц function(   ) функция_1779; 

		//проц function(   ) функция_1780; 

		//проц function(   ) функция_1781; 

		//проц function(   ) функция_1782; 

		//проц function(   ) функция_1783; 

		//проц function(   ) функция_1784; 

		//проц function(   ) функция_1785; 

		//проц function(   ) функция_1786; 

		//проц function(   ) функция_1787; 

		//проц function(   ) функция_1788; 

		//проц function(   ) функция_1789; 

		//проц function(   ) функция_1790; 

		//проц function(   ) функция_1791; 

		//проц function(   ) функция_1792; 

		//проц function(   ) функция_1793; 

		//проц function(   ) функция_1794; 

		//проц function(   ) функция_1795; 

		//проц function(   ) функция_1796; 

		//проц function(   ) функция_1797; 

		//проц function(   ) функция_1798; 

		//проц function(   ) функция_1799; 

		//проц function(   ) функция_1800; 

		//проц function(   ) функция_1801; 

		//проц function(   ) функция_1802; 

		//проц function(   ) функция_1803; 

		//проц function(   ) функция_1804; 

		//проц function(   ) функция_1805; 

		//проц function(   ) функция_1806; 

		//проц function(   ) функция_1807; 

		//проц function(   ) функция_1808; 

		//проц function(   ) функция_1809; 

		//проц function(   ) функция_1810; 

		//проц function(   ) функция_1811; 

		//проц function(   ) функция_1812; 

		//проц function(   ) функция_1813; 

		//проц function(   ) функция_1814; 

		//проц function(   ) функция_1815; 

		//проц function(   ) функция_1816; 

		//проц function(   ) функция_1817; 

		//проц function(   ) функция_1818; 

		//проц function(   ) функция_1819; 

		//проц function(   ) функция_1820; 

		//проц function(   ) функция_1821; 

		//проц function(   ) функция_1822; 

		//проц function(   ) функция_1823; 

		//проц function(   ) функция_1824; 

		//проц function(   ) функция_1825; 

		//проц function(   ) функция_1826; 

		//проц function(   ) функция_1827; 

		//проц function(   ) функция_1828; 

		//проц function(   ) функция_1829; 

		//проц function(   ) функция_1830; 

		//проц function(   ) функция_1831; 

		//проц function(   ) функция_1832; 

		//проц function(   ) функция_1833; 

		//проц function(   ) функция_1834; 

		//проц function(   ) функция_1835; 

		//проц function(   ) функция_1836; 

		//проц function(   ) функция_1837; 

		//проц function(   ) функция_1838; 

		//проц function(   ) функция_1839; 

		//проц function(   ) функция_1840; 

		//проц function(   ) функция_1841; 

		//проц function(   ) функция_1842; 

		//проц function(   ) функция_1843; 

		//проц function(   ) функция_1844; 

		//проц function(   ) функция_1845; 

		//проц function(   ) функция_1846; 

		//проц function(   ) функция_1847; 

		//проц function(   ) функция_1848; 

		//проц function(   ) функция_1849; 

		//проц function(   ) функция_1850; 

		//проц function(   ) функция_1851; 

		//проц function(   ) функция_1852; 

		//проц function(   ) функция_1853; 

		//проц function(   ) функция_1854; 

		//проц function(   ) функция_1855; 

		//проц function(   ) функция_1856; 

		//проц function(   ) функция_1857; 

		//проц function(   ) функция_1858; 

		//проц function(   ) функция_1859; 

		//проц function(   ) функция_1860; 

		//проц function(   ) функция_1861; 

		//проц function(   ) функция_1862; 

		//проц function(   ) функция_1863; 

		//проц function(   ) функция_1864; 

		//проц function(   ) функция_1865; 

		//проц function(   ) функция_1866; 

		//проц function(   ) функция_1867; 

		//проц function(   ) функция_1868; 

		//проц function(   ) функция_1869; 

		//проц function(   ) функция_1870; 

		//проц function(   ) функция_1871; 

		//проц function(   ) функция_1872; 

		//проц function(   ) функция_1873; 

		//проц function(   ) функция_1874; 

		//проц function(   ) функция_1875; 

		//проц function(   ) функция_1876; 

		//проц function(   ) функция_1877; 

		//проц function(   ) функция_1878; 

		//проц function(   ) функция_1879; 

		//проц function(   ) функция_1880; 

		//проц function(   ) функция_1881; 

		//проц function(   ) функция_1882; 

		//проц function(   ) функция_1883; 

		//проц function(   ) функция_1884; 

		//проц function(   ) функция_1885; 

		//проц function(   ) функция_1886; 

		//проц function(   ) функция_1887; 

		//проц function(   ) функция_1888; 

		//проц function(   ) функция_1889; 

		//проц function(   ) функция_1890; 

		//проц function(   ) функция_1891; 

		//проц function(   ) функция_1892; 

		//проц function(   ) функция_1893; 

		//проц function(   ) функция_1894; 

		//проц function(   ) функция_1895; 

		//проц function(   ) функция_1896; 

		//проц function(   ) функция_1897; 

		//проц function(   ) функция_1898; 

		//проц function(   ) функция_1899; 

		//проц function(   ) функция_1900; 

		//проц function(   ) функция_1901; 

		//проц function(   ) функция_1902; 

		//проц function(   ) функция_1903; 

		//проц function(   ) функция_1904; 

		//проц function(   ) функция_1905; 

		//проц function(   ) функция_1906; 

		//проц function(   ) функция_1907; 

		//проц function(   ) функция_1908; 

		//проц function(   ) функция_1909; 

		//проц function(   ) функция_1910; 

		//проц function(   ) функция_1911; 

		//проц function(   ) функция_1912; 

		//проц function(   ) функция_1913; 

		//проц function(   ) функция_1914; 

		//проц function(   ) функция_1915; 

		//проц function(   ) функция_1916; 

		//проц function(   ) функция_1917; 

		//проц function(   ) функция_1918; 

		//проц function(   ) функция_1919; 

		//проц function(   ) функция_1920; 

		//проц function(   ) функция_1921; 

		//проц function(   ) функция_1922; 

		//проц function(   ) функция_1923; 

		//проц function(   ) функция_1924; 

		//проц function(   ) функция_1925; 

		//проц function(   ) функция_1926; 

		//проц function(   ) функция_1927; 

		//проц function(   ) функция_1928; 

		//проц function(   ) функция_1929; 

		//проц function(   ) функция_1930; 

		//проц function(   ) функция_1931; 

		//проц function(   ) функция_1932; 

		//проц function(   ) функция_1933; 

		//проц function(   ) функция_1934; 

		//проц function(   ) функция_1935; 

		//проц function(   ) функция_1936; 

		//проц function(   ) функция_1937; 

		//проц function(   ) функция_1938; 

		//проц function(   ) функция_1939; 

		//проц function(   ) функция_1940; 

		//проц function(   ) функция_1941; 

		//проц function(   ) функция_1942; 

		//проц function(   ) функция_1943; 

		//проц function(   ) функция_1944; 

		//проц function(   ) функция_1945; 

		//проц function(   ) функция_1946; 

		//проц function(   ) функция_1947; 

		//проц function(   ) функция_1948; 

		//проц function(   ) функция_1949; 

		//проц function(   ) функция_1950; 

		//проц function(   ) функция_1951; 

		//проц function(   ) функция_1952; 

		//проц function(   ) функция_1953; 

		//проц function(   ) функция_1954; 

		//проц function(   ) функция_1955; 

		//проц function(   ) функция_1956; 

		//проц function(   ) функция_1957; 

		//проц function(   ) функция_1958; 

		//проц function(   ) функция_1959; 

		//проц function(   ) функция_1960; 

		//проц function(   ) функция_1961; 

		//проц function(   ) функция_1962; 

		//проц function(   ) функция_1963; 

		//проц function(   ) функция_1964; 

		//проц function(   ) функция_1965; 

		//проц function(   ) функция_1966; 

		//проц function(   ) функция_1967; 

		//проц function(   ) функция_1968; 

		//проц function(   ) функция_1969; 

		//проц function(   ) функция_1970; 

		//проц function(   ) функция_1971; 

		//проц function(   ) функция_1972; 

		//проц function(   ) функция_1973; 

		//проц function(   ) функция_1974; 

		//проц function(   ) функция_1975; 

		//проц function(   ) функция_1976; 

		//проц function(   ) функция_1977; 

		//проц function(   ) функция_1978; 

		//проц function(   ) функция_1979; 

		//проц function(   ) функция_1980; 

		//проц function(   ) функция_1981; 

		//проц function(   ) функция_1982; 

		//проц function(   ) функция_1983; 

		//проц function(   ) функция_1984; 

		//проц function(   ) функция_1985; 

		//проц function(   ) функция_1986; 

		//проц function(   ) функция_1987; 

		//проц function(   ) функция_1988; 

		//проц function(   ) функция_1989; 

		//проц function(   ) функция_1990; 

		//проц function(   ) функция_1991; 

		//проц function(   ) функция_1992; 

		//проц function(   ) функция_1993; 

		//проц function(   ) функция_1994; 

		//проц function(   ) функция_1995; 

		//проц function(   ) функция_1996; 

		//проц function(   ) функция_1997; 

		//проц function(   ) функция_1998; 

		//проц function(   ) функция_1999; 

		//проц function(   ) функция_2000; 

		//проц function(   ) функция_2001; 

		//проц function(   ) функция_2002; 

		//проц function(   ) функция_2003; 

		//проц function(   ) функция_2004; 

		//проц function(   ) функция_2005; 

		//проц function(   ) функция_2006; 

		//проц function(   ) функция_2007; 

		//проц function(   ) функция_2008; 

		//проц function(   ) функция_2009; 

		//проц function(   ) функция_2010; 

		//проц function(   ) функция_2011; 

		//проц function(   ) функция_2012; 

		//проц function(   ) функция_2013; 

		//проц function(   ) функция_2014; 

		//проц function(   ) функция_2015; 

		//проц function(   ) функция_2016; 

		//проц function(   ) функция_2017; 

		//проц function(   ) функция_2018; 

		//проц function(   ) функция_2019; 

		//проц function(   ) функция_2020; 

		//проц function(   ) функция_2021; 

		//проц function(   ) функция_2022; 

		//проц function(   ) функция_2023; 

		//проц function(   ) функция_2024; 

		//проц function(   ) функция_2025; 

		//проц function(   ) функция_2026; 

		//проц function(   ) функция_2027; 

		//проц function(   ) функция_2028; 

		//проц function(   ) функция_2029; 

		//проц function(   ) функция_2030; 

		//проц function(   ) функция_2031; 

		//проц function(   ) функция_2032; 

		//проц function(   ) функция_2033; 

		//проц function(   ) функция_2034; 

		//проц function(   ) функция_2035; 

		//проц function(   ) функция_2036; 

		//проц function(   ) функция_2037; 

		//проц function(   ) функция_2038; 

		//проц function(   ) функция_2039; 

		//проц function(   ) функция_2040; 

		//проц function(   ) функция_2041; 

		//проц function(   ) функция_2042; 

		//проц function(   ) функция_2043; 

		//проц function(   ) функция_2044; 

		//проц function(   ) функция_2045; 

		//проц function(   ) функция_2046; 

		//проц function(   ) функция_2047; 

		//проц function(   ) функция_2048; 

		//проц function(   ) функция_2049; 

		//проц function(   ) функция_2050; 

		//проц function(   ) функция_2051; 

		//проц function(   ) функция_2052; 

		//проц function(   ) функция_2053; 

		//проц function(   ) функция_2054; 

		//проц function(   ) функция_2055; 

		//проц function(   ) функция_2056; 

		//проц function(   ) функция_2057; 

		//проц function(   ) функция_2058; 

		//проц function(   ) функция_2059; 

		//проц function(   ) функция_2060; 

		//проц function(   ) функция_2061; 

		//проц function(   ) функция_2062; 

		//проц function(   ) функция_2063; 

		//проц function(   ) функция_2064; 

		//проц function(   ) функция_2065; 

		//проц function(   ) функция_2066; 

		//проц function(   ) функция_2067; 

		//проц function(   ) функция_2068; 

		//проц function(   ) функция_2069; 

		//проц function(   ) функция_2070; 

		//проц function(   ) функция_2071; 

		//проц function(   ) функция_2072; 

		//проц function(   ) функция_2073; 

		//проц function(   ) функция_2074; 

		//проц function(   ) функция_2075; 

		//проц function(   ) функция_2076; 

		//проц function(   ) функция_2077; 

		//проц function(   ) функция_2078; 

		//проц function(   ) функция_2079; 

		//проц function(   ) функция_2080; 

		//проц function(   ) функция_2081; 

		//проц function(   ) функция_2082; 

		//проц function(   ) функция_2083; 

		//проц function(   ) функция_2084; 

		//проц function(   ) функция_2085; 

		//проц function(   ) функция_2086; 

		//проц function(   ) функция_2087; 

		//проц function(   ) функция_2088; 

		//проц function(   ) функция_2089; 

		//проц function(   ) функция_2090; 

		//проц function(   ) функция_2091; 

		//проц function(   ) функция_2092; 

		//проц function(   ) функция_2093; 

		//проц function(   ) функция_2094; 

		//проц function(   ) функция_2095; 

		//проц function(   ) функция_2096; 

		//проц function(   ) функция_2097; 

		//проц function(   ) функция_2098; 

		//проц function(   ) функция_2099; 

		//проц function(   ) функция_2100; 

		//проц function(   ) функция_2101; 

		//проц function(   ) функция_2102; 

		//проц function(   ) функция_2103; 

		//проц function(   ) функция_2104; 

		//проц function(   ) функция_2105; 

		//проц function(   ) функция_2106; 

		//проц function(   ) функция_2107; 

		//проц function(   ) функция_2108; 

		//проц function(   ) функция_2109; 

		//проц function(   ) функция_2110; 

		//проц function(   ) функция_2111; 

		//проц function(   ) функция_2112; 

		//проц function(   ) функция_2113; 

		//проц function(   ) функция_2114; 

		//проц function(   ) функция_2115; 

		//проц function(   ) функция_2116; 

		//проц function(   ) функция_2117; 

		//проц function(   ) функция_2118; 

		//проц function(   ) функция_2119; 

		//проц function(   ) функция_2120; 

		//проц function(   ) функция_2121; 

		//проц function(   ) функция_2122; 

		//проц function(   ) функция_2123; 

		//проц function(   ) функция_2124; 

		//проц function(   ) функция_2125; 

		//проц function(   ) функция_2126; 

		//проц function(   ) функция_2127; 

		//проц function(   ) функция_2128; 

		//проц function(   ) функция_2129; 

		//проц function(   ) функция_2130; 

		//проц function(   ) функция_2131; 

		//проц function(   ) функция_2132; 

		//проц function(   ) функция_2133; 

		//проц function(   ) функция_2134; 

		//проц function(   ) функция_2135; 

		//проц function(   ) функция_2136; 

		//проц function(   ) функция_2137; 

		//проц function(   ) функция_2138; 

		//проц function(   ) функция_2139; 

		//проц function(   ) функция_2140; 

		//проц function(   ) функция_2141; 

		//проц function(   ) функция_2142; 

		//проц function(   ) функция_2143; 

		//проц function(   ) функция_2144; 

		//проц function(   ) функция_2145; 

		//проц function(   ) функция_2146; 

		//проц function(   ) функция_2147; 

		//проц function(   ) функция_2148; 

		//проц function(   ) функция_2149; 

		//проц function(   ) функция_2150; 

		//проц function(   ) функция_2151; 

		//проц function(   ) функция_2152; 

		//проц function(   ) функция_2153; 

		//проц function(   ) функция_2154; 

		//проц function(   ) функция_2155; 

		//проц function(   ) функция_2156; 

		//проц function(   ) функция_2157; 

		//проц function(   ) функция_2158; 

		//проц function(   ) функция_2159; 

		//проц function(   ) функция_2160; 

		//проц function(   ) функция_2161; 

		//проц function(   ) функция_2162; 

		//проц function(   ) функция_2163; 

		//проц function(   ) функция_2164; 

		//проц function(   ) функция_2165; 

		//проц function(   ) функция_2166; 

		//проц function(   ) функция_2167; 

		//проц function(   ) функция_2168; 

		//проц function(   ) функция_2169; 

		//проц function(   ) функция_2170; 

		//проц function(   ) функция_2171; 

		//проц function(   ) функция_2172; 

		//проц function(   ) функция_2173; 

		//проц function(   ) функция_2174; 

		//проц function(   ) функция_2175; 

		//проц function(   ) функция_2176; 

		//проц function(   ) функция_2177; 

		//проц function(   ) функция_2178; 

		//проц function(   ) функция_2179; 

		//проц function(   ) функция_2180; 

		//проц function(   ) функция_2181; 

		//проц function(   ) функция_2182; 

		//проц function(   ) функция_2183; 

		//проц function(   ) функция_2184; 

		//проц function(   ) функция_2185; 

		//проц function(   ) функция_2186; 

		//проц function(   ) функция_2187; 

		//проц function(   ) функция_2188; 

		//проц function(   ) функция_2189; 

		//проц function(   ) функция_2190; 

		//проц function(   ) функция_2191; 

		//проц function(   ) функция_2192; 

		//проц function(   ) функция_2193; 

		//проц function(   ) функция_2194; 

		//проц function(   ) функция_2195; 

		//проц function(   ) функция_2196; 

		//проц function(   ) функция_2197; 

		//проц function(   ) функция_2198; 

		//проц function(   ) функция_2199; 

		//проц function(   ) функция_2200; 

		//проц function(   ) функция_2201; 

		//проц function(   ) функция_2202; 

		//проц function(   ) функция_2203; 

		//проц function(   ) функция_2204; 

		//проц function(   ) функция_2205; 

		//проц function(   ) функция_2206; 

		//проц function(   ) функция_2207; 

		//проц function(   ) функция_2208; 

		//проц function(   ) функция_2209; 

		//проц function(   ) функция_2210; 

		//проц function(   ) функция_2211; 

		//проц function(   ) функция_2212; 

		//проц function(   ) функция_2213; 

		//проц function(   ) функция_2214; 

		//проц function(   ) функция_2215; 

		//проц function(   ) функция_2216; 

		//проц function(   ) функция_2217; 

		//проц function(   ) функция_2218; 

		//проц function(   ) функция_2219; 

		//проц function(   ) функция_2220; 

		//проц function(   ) функция_2221; 

		//проц function(   ) функция_2222; 

		//проц function(   ) функция_2223; 

		//проц function(   ) функция_2224; 

		//проц function(   ) функция_2225; 

		//проц function(   ) функция_2226; 

		//проц function(   ) функция_2227; 

		//проц function(   ) функция_2228; 

		//проц function(   ) функция_2229; 

		//проц function(   ) функция_2230; 

		//проц function(   ) функция_2231; 

		//проц function(   ) функция_2232; 

		//проц function(   ) функция_2233; 

		//проц function(   ) функция_2234; 

		//проц function(   ) функция_2235; 

		//проц function(   ) функция_2236; 

		//проц function(   ) функция_2237; 

		//проц function(   ) функция_2238; 

		//проц function(   ) функция_2239; 

	}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
//Индекс

	проц глИндексд(дво а){ glIndexd(cast(GLdouble) а);}
    проц глИндекс(плав а){ glIndexf(cast(GLfloat) а);}
    проц глИндекс(цел а){ glIndexi(а);}
    проц глИндекс(крат а){ glIndexs(а);}
    проц глИндекс(ббайт а){ glIndexub(а);}
    проц глИндекс(дво* а){ glIndexdv(cast(GLdouble*) а);}
    проц глИндекс(плав* а){ glIndexfv(cast(GLfloat*) а);}
    проц глИндекс(цел* а){ glIndexiv(а);}
    проц глИндекс(крат* а){ glIndexsv(а);}
    проц глИндекс(ббайт* а) {glIndexubv(а);}
	
	
//Вершина	

	проц глВершина2д(дво а,дво б){ glVertex2d(cast(GLdouble) а,cast(GLdouble)  б);}
    проц глВершина2(плав а,плав б){ glVertex2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глВершина2(цел а,цел б){ glVertex2i(а, б);}
    проц глВершина2(крат а,крат б){ glVertex2s(а, б);}
    проц глВершина3д(дво а,дво б,дво в){ glVertex3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глВершина3(плав а,плав б,плав в){ glVertex3f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    проц глВершина3(цел а,цел б,цел в){ glVertex3i(а, б, в);}
    проц глВершина3(крат а,крат б,крат в){ glVertex3s(а, б, в);}
    проц глВершина4д(дво а,дво б,дво в,дво г){ glVertex4d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в,cast(GLdouble)  г);}
    проц глВершина4(плав а,плав б,плав в,плав г){ glVertex4f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в, cast(GLfloat) г);}
    проц глВершина4(цел а,цел б,цел в,цел г){ glVertex4i(а, б, в, г);}
    проц глВершина4(крат а,крат б,крат в,крат г){ glVertex4s(а, б, в, г);}
    проц глВершина2д(дво* а) {glVertex2dv(cast(GLdouble*) а);}
    проц глВершина2(плав* а){ glVertex2fv(cast(GLfloat*) а);}
    проц глВершина2(цел* а){ glVertex2iv(а);}
    проц глВершина2(крат* а) {glVertex2sv(а);}
    проц глВершина3д(дво* а) {glVertex3dv(cast(GLdouble*) а);}
    проц глВершина3(плав* а){ glVertex3fv(cast(GLfloat*) а);}
    проц глВершина3(цел* а){ glVertex3iv(а);}
    проц глВершина3(крат* а){ glVertex3sv(а);}
    проц глВершина4д(дво* а){ glVertex4dv(cast(GLdouble*) а);}
    проц глВершина4(плав* а){ glVertex4fv(cast(GLfloat*) а);}
    проц глВершина4(цел* а){ glVertex4iv(а);}
    проц глВершина4(крат* а) {glVertex4sv(а);}



enum
{
РАЗМРАМПЫ  = 16,
РАЗМП1СТАРТ = 32,
РАЗМП2СТАРТ = 48
}

static плав уголВращения = 0.;

проц иниц()
{
   цел и;

   for (и = 0; и < РАЗМРАМПЫ; и++) {
      плав тень;
      тень = cast(плав) и/cast(плав) РАЗМРАМПЫ;
      глутУстановиЦвет(РАЗМП1СТАРТ+cast(цел)и, 0., тень, 0.);
      глутУстановиЦвет(РАЗМП2СТАРТ+cast(цел)и, 0., 0., тень);
   }

   глВключи (СМЯГЧЕНИЕ_ЛИНИИ);
   //глПодсказка (СМЯГЧЕНИЕ_ЛИНИИ_ПОДСКАЗКА, НЕ_ВАЖНО);
   глШиринаЛинии (1.5);

   глОчистиИндекс (cast(плав) РАЗМП1СТАРТ);
}

extern (C) проц покажи()
{
   глОчисти(БИТ_БУФЕРА_ЦВЕТА);

   глИндекс(РАЗМП1СТАРТ);
   глСуньМатр();
   глВращай(-уголВращения, cast(плав) 0.0, cast(плав) 0.0, cast(плав) 0.1);
   глНачни (ЛИНИИ);
      глВершина2 (-0.5, 0.5);
      глВершина2 (0.5, -0.5);
   глСтоп ();
   глВыньМатр();

   глИндекс(РАЗМП2СТАРТ);
   глСуньМатр();
   глВращай(уголВращения, cast(плав) 0.0, cast(плав) 0.0, cast(плав) 0.1);
   глНачни (ЛИНИИ);
      глВершина2 (0.5, 0.5);
      глВершина2 (-0.5, -0.5);
   глСтоп ();
   глВыньМатр();

   глСлей();
}

extern (C) проц  перерисуй(цел w, цел h)
{
   глВьюпорт(0, 0, cast(Гцразм) w, cast(Гцразм) h);
   глРежимМатр(ПРОЕКЦИЯ);
   глЗагрузиИдент();
   if (w <= h) 
      глуОрто2М (-1.0, 1.0, 
         -1.0*cast(плав)h/cast(плав)w, 1.0*cast(плав)h/cast(плав)w);
   else 
      глуОрто2М (-1.0*cast(плав)w/cast(плав)h, 
         1.0*cast(плав)w/cast(плав)h, -1.0, 1.0);
   глРежимМатр(ОБЗОР_МОДЕЛИ);
   глЗагрузиИдент();
}

/* ARGSUSED1 */
extern (C) проц клавиатура(сим клава, цел x, цел y)
{
   switch (клава) {
      case 'r':
      case 'R':
         уголВращения += 20.;
         if (уголВращения >= 360.) уголВращения = 0.;
         глутПерепоказ();	
         break;
      case 27:  /*  Escape Key */
         выход(0);
         break;
      default:
         break;
    }
}
цел main()
	{
   глутИницРежимПоказа (GLUT_SINGLE | GLUT_INDEX);
   глутИницРазмерОкна (200, 200);
   глутСоздайОкно ("aaindex");
   иниц();
   глутФункцПерерисовки (&перерисуй);
   глутФункцКлавиатуры (&клавиатура);
   глутФункцПоказа (&покажи);
   глутГлавныйЦикл();
   return 0;
	}

	
	
