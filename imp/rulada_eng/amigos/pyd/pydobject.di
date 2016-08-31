/*
Copyright (c) 2006 Kirk McDonald

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
module amigos.pyd.pydobject;

//private import std.c.stdio;
import amigos.pyd.python;
import amigos.pyd.exception;
import amigos.pyd.make_object;
//import std.string;

/**
 * Класс-обёртка для Python/C API PyObject.
 *
 * Почти все его функции-члены могут выдавать PythonException, если
 * лежащий под ними Python API вызывает исключение Python.
 *
 * Авторы: $(LINK2 mailto:kirklin.mcdonald@gmail.com, Kirk McDonald)
 * Дата: Июнь 18, 2006
 * Смотри_Также:
 *     $(LINK2 http://docs.amigos.pyd.python.org/api/api.html, The Python/C API)
 */
class PydObject {
protected:
    PyObject* m_ptr;
public:
    /**
     * Обертка вокруг переданного PyObject*.
     * Параметры:
     *      o = PyObject для оборачивания.
     *      borrowed = Является ли o заимствованной ссылкой _borrowed. Экземпляры
     *                 PydObject всегда имеют собственные ссылки.
     *                 Следовательно, Py_INCREF будет вызван в случае, если borrowed есть
     *                 $(D_KEYWORD true).
     */
    this(PyObject* o, bool borrowed=false) {
        if (o is null) handle_exception();
        // PydObject всегда имеет свои собственные ссылки
        if (borrowed) Py_INCREF(o);
        m_ptr = o;
    }

    /// Дефолтный конструктор строит экземпляр Py_None PydObject.
    this() { this(Py_None, true); }

    /// Деструктор. Вызывает Py_DECREF над "подвладной" ссылкой PyObject.
    ~this() {
        Py_DECREF(m_ptr);
    }

    /**
     * Возвращает заимствованную ссылку на данный PyObject.
     */
    PyObject* ptr() { return m_ptr; }
    
    /*
     * Prints PyObject to a C FILE* object.
     * Параметры:
     *      fp = The file object to _print to. std.c.stdio.stdout by default.
     *      raw = If $(D_KEYWORD true), prints the "str" representation of the
     *            PydObject, and uses the "repr" otherwise. Defaults to
     *            $(D_KEYWORD false).
     * Bugs: This does not seem to work, raising an AccessViolation. Meh.
     *       Use toString.
     */
    /+
    void print(FILE* fp=stdout, bool raw=false) {
        if (PyObject_Print(m_ptr, fp, raw ? Py_PRINT_RAW : 0) == -1)
            handle_exception();
    }
    +/

    /// То же, что и _hasattr(this, attr_name) в Питоне.
    bool hasattr(char[] attr_name) {
        return PyObject_HasAttrString(m_ptr, (attr_name ~ \0).ptr) == 1;
    }

    /// То же, что и _hasattr(this, attr_name) в Питоне.
    bool hasattr(PydObject attr_name) {
        return PyObject_HasAttr(m_ptr, attr_name.m_ptr) == 1;
    }

    /// То же, что и _getattr(this, attr_name) в Питоне.
    PydObject getattr(char[] attr_name) {
        return new PydObject(PyObject_GetAttrString(m_ptr, (attr_name ~ \0).ptr));
    }

    /// То же, что и _getattr(this, attr_name) в Питоне.
    PydObject getattr(PydObject attr_name) {
        return new PydObject(PyObject_GetAttr(m_ptr, attr_name.m_ptr));
    }

    /**
     * То же, что и _setattr(this, attr_name, v) в Питоне.
     */
    void setattr(char[] attr_name, PydObject v) {
        if (PyObject_SetAttrString(m_ptr, (attr_name ~ \0).ptr, v.m_ptr) == -1)
            handle_exception();
    }

    /**
     * То же, что и _setattr(this, attr_name, v) в Питоне.
     */
    void setattr(PydObject attr_name, PydObject v) {
        if (PyObject_SetAttr(m_ptr, attr_name.m_ptr, v.m_ptr) == -1)
            handle_exception();
    }

    /**
     * То же, что и del this.attr_name в Питоне.
     */
    void delattr(char[] attr_name) {
        if (PyObject_DelAttrString(m_ptr, (attr_name ~ \0).ptr) == -1)
            handle_exception();
    }

    /**
     * То же, что и del this.attr_name в Питоне.
     */
    void delattr(PydObject attr_name) {
        if (PyObject_DelAttr(m_ptr, attr_name.m_ptr) == -1)
            handle_exception();
    }

    /**
     * Представляет сравнение объекта Python в D. То же, что и cmp(this, rhs) в Питоне.
     */
    int opCmp(PydObject rhs) {
        // Эта функция удачно картографируется прямо в opCmp
        int res = PyObject_Compare(m_ptr, rhs.m_ptr);
        // Проверка на возможную ошибку
        handle_exception();
        return res;
    }

    /**
     * Представляет проверку равенства объекта Python в D.
     */
    bool opEquals(PydObject rhs) {
        int res = PyObject_Compare(m_ptr, rhs.m_ptr);
        handle_exception();
        return res == 0;
    }
    
    /// То же, что и _repr(this) в Питоне.
    PydObject repr() {
        return new PydObject(PyObject_Repr(m_ptr));
    }

    /// То же, что и _str(this) в Питоне.
    PydObject str() {
        return new PydObject(PyObject_Str(m_ptr));
    }
    version (Tango) {
        /// Позволяет отформатировать PydObject.
        char[] toUtf8() {
            return d_type!(char[])(m_ptr);
        }
    } else {
        /// Позволяет использовать PydObject в writef через %s
        char[] toString() {
            return d_type!(char[])(m_ptr);
        }
    }
    
    /// То же, что и _unicode(this) в Питоне.
    PydObject unicode() {
        return new PydObject(PyObject_Unicode(m_ptr));
    }

    /// То же, что и isinstance(this, cls) в Питоне.
    bool isInstance(PydObject cls) {
        int res = PyObject_IsInstance(m_ptr, cls.m_ptr);
        if (res == -1) handle_exception();
        return res == 1;
    }

    /// То же, что и issubclass(this, cls) в Питоне. Only works if this is a class.
    bool isSubclass(PydObject cls) {
        int res = PyObject_IsSubclass(m_ptr, cls.m_ptr);
        if (res == -1) handle_exception();
        return res == 1;
    }

    /// То же, что и _callable(this) в Питоне.
    bool callable() {
        return PyCallable_Check(m_ptr) == 1;
    }
    
    /**
     * Вызывает PydObject с аргументами PyTuple.
     * Параметры:
     *      args = Должно быть PydTuple из аргументов для передачи. Старайтесь не
     *             вызывать без аргументов.
     * Возвращает: То, что ни возващала бы функция PydObject.
     */
    PydObject unpackCall(PydObject args=null) {
        return new PydObject(PyObject_CallObject(m_ptr, args is null ? null : args.m_ptr));
    }
    
    /**
     * Вызывает PydObject с позиционными и ключевыми аргументами.
     * Параметры:
     *      args = Позиционные аргументы. Должны быть в виде PydTuple. Пустой
     *             PydTuple передают для непозиционных аргументов.
     *      kw = Аргументы ключевых слов. Должны быть в форме PydDict.
     * Возвращает: То, что ни возващала бы функция PydObject.
     */
    PydObject unpackCall(PydObject args, PydObject kw) {
        return new PydObject(PyObject_Call(m_ptr, args.m_ptr, kw.m_ptr));
    }

    /**
     * Вызывает PydObject с любыми преобразуемыми элементами D.
     */
    PydObject opCall(T ...) (T t) {
        PyObject* tuple = PyTuple_FromItems(t);
        if (tuple is null) handle_exception();
        PyObject* result = PyObject_CallObject(m_ptr, tuple);
        Py_DECREF(tuple);
        if (result is null) handle_exception();
        return new PydObject(result);
    }

    /**
     *
     */
    PydObject methodUnpack(char[] name, PydObject args=null) {
        // Получить метод PydObject
        PyObject* m = PyObject_GetAttrString(m_ptr, (name ~ \0).ptr);
        PyObject* result;
        // Если этого метода не существуеь (или иная ошибка), выдать исключение
        if (m is null) handle_exception();
        // Вызвать метод, и уменьшить счет ссылок у временных.
        result = PyObject_CallObject(m, args is null ? null : args.m_ptr);
        Py_DECREF(m);
        // Вернуть результат.
        return new PydObject(result);
    }

    PydObject methodUnpack(char[] name, PydObject args, PydObject kw) {
        // Get the method PydObject
        PyObject* m = PyObject_GetAttrString(m_ptr, (name ~ \0).ptr);
        PyObject* result;
        // If this method doesn't exist (or other error), throw exception.
        if (m is null) handle_exception();
        // Call the method, and decrement the refcounts on the temporaries.
        result = PyObject_Call(m, args.m_ptr, kw.m_ptr);
        Py_DECREF(m);
        // Return the result.
        return new PydObject(result);
    }

    /**
     * Вызывает метод объекта с любыми преобразуемыми элементами D.
     */
    PydObject method(T ...) (char[] name, T t) {
        PyObject* mthd = PyObject_GetAttrString(m_ptr, (name ~ \0).ptr);
        if (mthd is null) handle_exception();
        PyObject* tuple = PyTuple_FromItems(t);
        if (tuple is null) {
            Py_DECREF(mthd);
            handle_exception();
        }
        PyObject* result = PyObject_CallObject(mthd, tuple);
        Py_DECREF(mthd);
        Py_DECREF(tuple);
        if (result is null) handle_exception();
        return new PydObject(result);
    }

    /// То же, что и _hash(this) в Питоне.
    int hash() {
        int res = PyObject_Hash(m_ptr);
        if (res == -1) handle_exception();
        return res;
    }

    T toDItem(T)() {
        return d_type!(T)(m_ptr);
    }

    /// То же, что и "not not this" в Питоне.
    bool toBool() {
        return d_type!(bool)(m_ptr);
    }

    /// То же, что и "_not this" в Питоне.
    bool not() {
        int res = PyObject_Not(m_ptr);
        if (res == -1) handle_exception();
        return res == 1;
    }

    /**
     * Получает тип _type данного PydObject. То же, что и _type(this) в Питоне.
     * Возвращает: Тип _type PydObject данного PydObject.
     */
    PydObject type() {
        return new PydObject(PyObject_Type(m_ptr));
    }

    /**
     * Длина _length данного PydObject. То же, что и _len(this) в Питоне.
     */
    int length() {
        int res = PyObject_Length(m_ptr);
        if (res == -1) handle_exception();
        return res;
    }
    /// То же, что и length()
    int size() { return length(); }

    /// То же, что и _dir(this) в Питоне.
    PydObject dir() {
        return new PydObject(PyObject_Dir(m_ptr));
    }

    //----------
    // Индексирование
    //----------
    /// Равнозначно o[_key] в Питоне.
    PydObject opIndex(PydObject key) {
        return new PydObject(PyObject_GetItem(m_ptr, key.m_ptr));
    }
    /**
     * Равнозначно o['_key'] в Питоне; обычно целесообразен только по отношению к
     * mappings.
     */
    PydObject opIndex(char[] key) {
        return new PydObject(PyMapping_GetItemString(m_ptr, (key ~ \0).ptr));
    }
    /// Равнозначно o[_i] в Питоне; usually only makes sense for sequences.
    PydObject opIndex(int i) {
        return new PydObject(PySequence_GetItem(m_ptr, i));
    }

    /// Равнозначно o[_key] = _value в Питоне.
    void opIndexAssign(PydObject value, PydObject key) {
        if (PyObject_SetItem(m_ptr, key.m_ptr, value.m_ptr) == -1)
            handle_exception();
    }
    /**
     * Равнозначно o['_key'] = _value в Питоне. Обычно целесообразно только в отношении
     * mappings.
     */
    void opIndexAssign(PydObject value, char[] key) {
        if (PyMapping_SetItemString(m_ptr, (key ~ \0).ptr, value.m_ptr) == -1)
            handle_exception();
    }
    /**
     * Равнозначно o[_i] = _value в Питоне. Обычно целесообразно только в отношении
     * sequences (последовательностей).
     */
    void opIndexAssign(PydObject value, int i) {
        if (PySequence_SetItem(m_ptr, i, value.m_ptr) == -1)
            handle_exception();
    }

    /// Равнозначно del o[_key] в Питоне.
    void delItem(PydObject key) {
        if (PyObject_DelItem(m_ptr, key.m_ptr) == -1)
            handle_exception();
    }
    /**
     * Равнозначно del o['_key'] в Питоне. Обычно целесообразно только в отношении
     * mappings.
     */
    void delItem(char[] key) {
        if (PyMapping_DelItemString(m_ptr, (key ~ \0).ptr) == -1)
            handle_exception();
    }
    /**
     * Равнозначно del o[_i] в Питоне. Обычно целесообразно только в отношении
     * sequences (последовательностей).
     */
    void delItem(int i) {
        if (PySequence_DelItem(m_ptr, i) == -1)
            handle_exception();
    }

    //---------
    // Срезание
    //---------
    /// Равнозначно o[_i1:_i2] в Питоне.
    PydObject opSlice(int i1, int i2) {
        return new PydObject(PySequence_GetSlice(m_ptr, i1, i2));
    }
    /// Равнозначно o[:] в Питоне.
    PydObject opSlice() {
        return this.opSlice(0, this.length());
    }
    /// Равнозначно o[_i1:_i2] = _v в Питоне.
    void opSliceAssign(PydObject v, int i1, int i2) {
        if (PySequence_SetSlice(m_ptr, i1, i1, v.m_ptr) == -1)
            handle_exception();
    }
    /// Равнозначно o[:] = _v в Питоне.
    void opSliceAssign(PydObject v) {
        this.opSliceAssign(v, 0, this.length());
    }
    /// Равнозначно del o[_i1:_i2] в Питоне.
    void delSlice(int i1, int i2) {
        if (PySequence_DelSlice(m_ptr, i1, i2) == -1)
            handle_exception();
    }
    /// Равнозначно del o[:] в Питоне.
    void delSlice() {
        this.delSlice(0, this.length());
    }

    //-----------
    // Итерация (Обход)
    //-----------

    /**
     * Обходчик элементов коллекции, будь они элементами в
     * последовательности, ключами в словаре, или же  какой-либо иной итерацией,
     * указанной для типа PydObject.
     */
    int opApply(int delegate(inout PydObject) dg) {
        PyObject* iterator = PyObject_GetIter(m_ptr);
        PyObject* item;
        int result = 0;
        PydObject o;

        if (iterator == null) {
            handle_exception();
        }

        item = PyIter_Next(iterator);
        while (item) {
            o = new PydObject(item);
            result = dg(o);
            Py_DECREF(item);
            if (result) break;
            item = PyIter_Next(iterator);
        }
        Py_DECREF(iterator);

        // Только на случай исключения
        handle_exception();

        return result;
    }

    /**
     * Обходчик пар (ключ, значение) в словаре. Если PydObject не является
     * словарем, то просто ничего не делается. (Никакие элементы не обходятся.)
     * Не следует пытаться изменить словарь, пока он обходится,
     * за исключением изменения значений. Добавка или удаление элементов при
     * их обходе является не вполне здравой идеей.
     */
    int opApply(int delegate(inout PydObject, inout PydObject) dg) {
        PyObject* key, value;
        version(Python_2_5_Or_Later) {
            Py_ssize_t pos = 0;
        } else {
            int pos = 0;
        }
        int result = 0;
        PydObject k, v;

        while (PyDict_Next(m_ptr, &pos, &key, &value)) {
            k = new PydObject(key, true);
            v = new PydObject(value, true);
            result = dg(k, v);
            if (result) break;
        }

        return result;
    }

    //------------
    // Арифметика
    //------------
    ///
    PydObject opAdd(PydObject o) {
        return new PydObject(PyNumber_Add(m_ptr, o.m_ptr));
    }
    ///
    PydObject opSub(PydObject o) {
        return new PydObject(PyNumber_Subtract(m_ptr, o.m_ptr));
    }
    ///
    PydObject opMul(PydObject o) {
        return new PydObject(PyNumber_Multiply(m_ptr, o.m_ptr));
    }
    /// Повторение последовательности
    PydObject opMul(int count) {
        return new PydObject(PySequence_Repeat(m_ptr, count));
    }
    ///
    PydObject opDiv(PydObject o) {
        return new PydObject(PyNumber_Divide(m_ptr, o.m_ptr));
    }
    ///
    PydObject floorDiv(PydObject o) {
        return new PydObject(PyNumber_FloorDivide(m_ptr, o.m_ptr));
    }
    ///
    PydObject opMod(PydObject o) {
        return new PydObject(PyNumber_Remainder(m_ptr, o.m_ptr));
    }
    ///
    PydObject divmod(PydObject o) {
        return new PydObject(PyNumber_Divmod(m_ptr, o.m_ptr));
    }
    ///
    PydObject pow(PydObject o1, PydObject o2=null) {
        return new PydObject(PyNumber_Power(m_ptr, o1.m_ptr, (o2 is null) ? Py_None : o2.m_ptr));
    }
    ///
    PydObject opPos() {
        return new PydObject(PyNumber_Positive(m_ptr));
    }
    ///
    PydObject opNeg() {
        return new PydObject(PyNumber_Negative(m_ptr));
    }
    ///
    PydObject abs() {
        return new PydObject(PyNumber_Absolute(m_ptr));
    }
    ///
    PydObject opCom() {
        return new PydObject(PyNumber_Invert(m_ptr));
    }
    ///
    PydObject opShl(PydObject o) {
        return new PydObject(PyNumber_Lshift(m_ptr, o.m_ptr));
    }
    ///
    PydObject opShr(PydObject o) {
        return new PydObject(PyNumber_Rshift(m_ptr, o.m_ptr));
    }
    ///
    PydObject opAnd(PydObject o) {
        return new PydObject(PyNumber_And(m_ptr, o.m_ptr));
    }
    ///
    PydObject opXor(PydObject o) {
        return new PydObject(PyNumber_Xor(m_ptr, o.m_ptr));
    }
    ///
    PydObject opOr(PydObject o) {
        return new PydObject(PyNumber_Or(m_ptr, o.m_ptr));
    }

    //---------------------
    // Арифметика In-place
    //---------------------
    private extern(C)
    alias PyObject* function(PyObject*, PyObject*) op_t;

    // Полезный оберточник для большинства операторов in-place
    private PydObject
    inplace(op_t op, PydObject rhs) {
        if (PyType_HasFeature(m_ptr.ob_type, Py_TPFLAGS_HAVE_INPLACEOPS)) {
            op(m_ptr, rhs.m_ptr);
            handle_exception();
        } else {
            PyObject* result = op(m_ptr, rhs.m_ptr);
            if (result is null) handle_exception();
            Py_DECREF(m_ptr);
            m_ptr = result;
        }
        return this;
    }
    ///
    PydObject opAddAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceAdd, o);
    }
    ///
    PydObject opSubAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceSubtract, o);
    }
    ///
    PydObject opMulAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceMultiply, o);
    }
    /// Повторение последовательности In-place
    PydObject opMulAssign(int count) {
        if (PyType_HasFeature(m_ptr.ob_type, Py_TPFLAGS_HAVE_INPLACEOPS)) {
            PySequence_InPlaceRepeat(m_ptr, count);
            handle_exception();
        } else {
            PyObject* result = PySequence_InPlaceRepeat(m_ptr, count);
            if (result is null) handle_exception();
            Py_DECREF(m_ptr);
            m_ptr = result;
        }
        return this;
    }
    ///
    PydObject opDivAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceDivide, o);
    }
    ///
    PydObject floorDivAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceFloorDivide, o);
    }
    ///
    PydObject opModAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceRemainder, o);
    }
    ///
    PydObject powAssign(PydObject o1, PydObject o2=null) {
        if (PyType_HasFeature(m_ptr.ob_type, Py_TPFLAGS_HAVE_INPLACEOPS)) {
            PyNumber_InPlacePower(m_ptr, o1.m_ptr, (o2 is null) ? Py_None : o2.m_ptr);
            handle_exception();
        } else {
            PyObject* result = PyNumber_InPlacePower(m_ptr, o1.m_ptr, (o2 is null) ? Py_None : o2.m_ptr);
            if (result is null) handle_exception();
            Py_DECREF(m_ptr);
            m_ptr = result;
        }
        return this;
    }
    ///
    PydObject opShlAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceLshift, o);
    }
    ///
    PydObject opShrAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceRshift, o);
    }
    ///
    PydObject opAndAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceAnd, o);
    }
    ///
    PydObject opXorAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceXor, o);
    }
    ///
    PydObject opOrAssign(PydObject o) {
        return inplace(&PyNumber_InPlaceOr, o);
    }

    //-----------------
    // Преобразование типа
    //-----------------
    ///
    PydObject asInt() {
        return new PydObject(PyNumber_Int(m_ptr));
    }
    ///
    PydObject asLong() {
        return new PydObject(PyNumber_Long(m_ptr));
    }
    ///
    PydObject asFloat() {
        return new PydObject(PyNumber_Float(m_ptr));
    }
    ///
    C_long toLong() {
        return d_type!(C_long)(m_ptr);
    }
    ///
    C_longlong toLongLong() {
        return d_type!(C_longlong)(m_ptr);
    }
    ///
    double toDouble() {
        return d_type!(double)(m_ptr);
    }
    ///
    cdouble toComplex() {
        return d_type!(cdouble)(m_ptr);
    }
    
    //------------------
    // Методы последовательностей
    //------------------

    /// Конкатенация последовательностей
    PydObject opCat(PydObject o) {
        return new PydObject(PySequence_Concat(m_ptr, o.m_ptr));
    }
    /// Конкатенация последовательностей In-place
    PydObject opCatAssign(PydObject o) {
        return inplace(&PySequence_InPlaceConcat, o);
    }
    ///
    int count(PydObject v) {
        int result = PySequence_Count(m_ptr, v.m_ptr);
        if (result == -1) handle_exception();
        return result;
    }
    ///
    int index(PydObject v) {
        int result = PySequence_Index(m_ptr, v.m_ptr);
        if (result == -1) handle_exception();
        return result;
    }
    /// Преобразует любой обходимый PydObject в список
    PydObject asList() {
        return new PydObject(PySequence_List(m_ptr));
    }
    /// Преобразует любой обходимый PydObject в кортеж
    PydObject asTuple() {
        return new PydObject(PySequence_Tuple(m_ptr));
    }
    /+
    wchar[] toWString() {
        wchar[] temp;
        if (PyUnicode_Check(m_ptr)) {
            temp.length = PyUnicode_GetSize(m_ptr);
            if (PyUnicode_AsWideChar(cast(PyUnicodeObject*)m_ptr, temp, temp.length) == -1)
                handle_exception();
            return temp;
        } else {
            PyErr_SetString(PyExc_RuntimeError, "Cannot convert non-PyUnicode PydObject to wchar[].");
            handle_exception();
        }
    }
    // Added by list:
    void insert(int i, PydObject item) { assert(false); }
    void append(PydObject item) { assert(false); }
    void sort() { assert(false); }
    void reverse() { assert(false); }
    +/

    //-----------------
    // Mapping methods
    //-----------------
    /// То же, что и "v in this" в Питоне.
    bool opIn_r(PydObject v) {
        int result = PySequence_Contains(m_ptr, v.m_ptr);
        if (result == -1) handle_exception();
        return result == 1;
    }
    /// То же, что и opIn_r
    bool hasKey(PydObject key) { return this.opIn_r(key); }
    /// То же, что и "'v' in this" в Питоне.
    bool opIn_r(char[] key) {
        return this.hasKey(key);
    }
    /// То же, что и opIn_r
    bool hasKey(char[] key) {
        int result = PyMapping_HasKeyString(m_ptr, (key ~ \0).ptr);
        if (result == -1) handle_exception();
        return result == 1;
    }
    ///
    PydObject keys() {
        return new PydObject(PyMapping_Keys(m_ptr));
    }
    ///
    PydObject values() {
        return new PydObject(PyMapping_Values(m_ptr));
    }
    ///
    PydObject items() {
        return new PydObject(PyMapping_Items(m_ptr));
    }
    /+
    // Added by dict
    void clear() { assert(false); }
    PydObject copy() { assert(false); }
    void update(PydObject o, bool over_ride=true) { assert(false); }
    +/
}


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
