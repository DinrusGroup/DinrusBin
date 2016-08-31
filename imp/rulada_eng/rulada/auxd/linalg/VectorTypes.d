//============================================================================
// VectorTypes.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Описание: 
 *   Этот модуль инстанциирует многие общие типы векторов.  
 * Он добавляет около 25K кода с dmd/win, поэтому по умолчанию не импортируется.
 *
 * Но с его помощью можно легко получить все, что относится к Vector в одном 
 * пространстве имен с переименованым импортом: import vecs = auxd.linalg.VectorTypes;
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 29 Aug 2007
 */
//============================================================================

module auxd.linalg.VectorTypes;

import auxd.linalg.VectorT;

/** 1-байтный вектор со знаком */
alias VectorT!(byte,1) Vec1b;
/** 1-байтный вектор без знака */
alias VectorT!(ubyte,1) Vec1ub;
/** 1-short вектор со знаком */
alias VectorT!(short,1) Vec1s;
/** 1-short вектор без знака */
alias VectorT!(ushort,1) Vec1us;
/** 1-int вектор со знаком */
alias VectorT!(int,1) Vec1i;
/** 1-int вектор без знака */
alias VectorT!(uint,1) Vec1ui;
/** 1-float вектор */
alias VectorT!(float,1) Vec1f;
/** 1-double вектор */
alias VectorT!(double,1) Vec1d;

/** 2-byte вектор со знаком */
alias VectorT!(byte,2) Vec2b;
/** 2-byte вектор без знака */
alias auxd.linalg.VectorT.Vec2ub Vec2ub;
/** 2-short вектор со знаком */
alias VectorT!(short,2) Vec2s;
/** 2-short вектор без знака */
alias VectorT!(ushort,2) Vec2us;
/** 2-int вектор со знаком */
alias VectorT!(int,2) Vec2i;
/** 2-int вектор без знака */
alias VectorT!(uint,2) Vec2ui;
/** 2-float вектор */
alias auxd.linalg.VectorT.Vec2f Vec2f;
/** 2-double вектор */
alias auxd.linalg.VectorT.Vec2d Vec2d;

/** 3-byte вектор со знаком */
alias VectorT!(byte,3) Vec3b;
/** 3-byte вектор без знака */
alias auxd.linalg.VectorT.Vec3ub Vec3ub;
/** 3-short вектор со знаком */
alias VectorT!(short,3) Vec3s;
/** 3-short вектор без знака */
alias VectorT!(ushort,3) Vec3us;
/** 3-int вектор со знаком */
alias VectorT!(int,3) Vec3i;
/** 3-int вектор без знака */
alias VectorT!(uint,3) Vec3ui;
/** 3-float вектор */
alias auxd.linalg.VectorT.Vec3f Vec3f;
/** 3-double вектор */
alias auxd.linalg.VectorT.Vec3d Vec3d;

/** 4-byte вектор со знаком */
alias VectorT!(byte,4) Vec4b;
/** 4-byte вектор без знака */
alias auxd.linalg.VectorT.Vec4ub Vec4ub;
/** 4-short вектор со знаком */
alias VectorT!(short,4) Vec4s;
/** 4-short вектор без знака */
alias VectorT!(ushort,4) Vec4us;
/** 4-int вектор со знаком */
alias VectorT!(int,4) Vec4i;
/** 4-int вектор без знака */
alias VectorT!(uint,4) Vec4ui;
/** 4-float вектор */
alias auxd.linalg.VectorT.Vec4f Vec4f;
/** 4-double вектор */
alias auxd.linalg.VectorT.Vec4d Vec4d;

/** 6-byte вектор со знаком */
alias VectorT!(byte,6) Vec6b;
/** 6-byte вектор без знака */
alias VectorT!(ubyte,6) Vec6ub;
/** 6-short вектор со знаком */
alias VectorT!(short,6) Vec6s;
/** 6-short вектор без знака */
alias VectorT!(ushort,6) Vec6us;
/** 6-int вектор со знаком */
alias VectorT!(int,6) Vec6i;
/** 6-int вектор без знака */
alias VectorT!(uint,6) Vec6ui;
/** 6-float вектор */
alias VectorT!(float,6) Vec6f;
/** 6-double вектор */
alias VectorT!(double,6) Vec6d;


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:

