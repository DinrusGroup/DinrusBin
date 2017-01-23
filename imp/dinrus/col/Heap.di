module col.Heap;
import util = tpl.Std;

/+ ИНТЕРФЕЙС:

struct ИнтерфейсКучиШ(ЗаписьКучи)
{
  бул меньше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);
  бул больше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);
  цел  дай_положение( ref ЗаписьКучи _e);
  проц установи_положение(ref ЗаписьКучи _e, цел _i);
}
 
struct Куча(ЗаписьКучи, ИнтерфейсКучи = ЗаписьКучи)
{
    static Куча opCall();
    static Куча opCall(ref ИнтерфейсКучи _интерфейс);
    проц очисть() ;
    бул пуста();
    бцел размер() ;
    бцел длина();
    проц резервируй(бцел _n) ;
    проц сбрось_положение(ЗаписьКучи _h);
    бул сохранена(ЗаписьКучи _h);
    проц вставь(ЗаписьКучи _h)  ;
    ЗаписьКучи первая();
    проц удали_первую();
    проц удали(ЗаписьКучи _h);
    проц обнови(ЗаписьКучи _h);
    бул проверь();

protected:  
    ИнтерфейсКучи интерфейс_;
    ЗаписьКучи[]            Основа;


}
+/

//== CLASS DEFINITION =========================================================


/** This class demonstrates the ИнтерфейсКучи's interface.  If you
 *  want to build your customized heap you will have to specity a heap
 *  interface class and use this class as a template parameter for the
 *  class Куча. This class defines the interface that this heap
 *  interface has to implement.
 *   
 *  See_Also: Куча
 */
struct ИнтерфейсКучиШ(ЗаписьКучи)
{
  /// Comparison of two ЗаписьКучи's: strict меньше
  бул меньше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);

  /// Comparison of two ЗаписьКучи's: strict больше
  бул больше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);

  /// Get the heap position of ЗаписьКучи _e
  цел  дай_положение( ref ЗаписьКучи _e);

  /// Set the heap position of ЗаписьКучи _e
  проц установи_положение(ref ЗаписьКучи _e, цел _i);
}



/**
 *  An efficient, highly customizable heap.
 *
 *  The main difference (and performace boost) of this heap compared
 *  to e.g. the heap of the STL is that here to positions of the
 *  heap's elements are accessible from the elements themselves.
 *  Therefore if one changes the priority of an element one does not
 *  have to удали and re-вставь this element, but can just call the
 *  обнови(ЗаписьКучи) method.
 *
 *  This heap class is parameterized by two template arguments: 
 *  $(UL
 *    $(LI the class \c ЗаписьКучи, that will be stored in the heap)
 *    $(LI the ИнтерфейсКучи telling the heap how to compare heap entries and
 *        how to store the heap positions in the heap entries.)
 *  )
 *
 *  As an example how to use the class see declaration of class 
 *  Decimater.DecimaterT.
 *
 *  See_Also: ИнтерфейсКучиШ
 */
 
struct Куча(ЗаписьКучи, ИнтерфейсКучи = ЗаписьКучи)
{
public:

    /// Constructor
    static Куча opCall() { Куча M; return M; }
  
    /// Construct with a given \c HeapIterface. 
    static Куча opCall(ref ИнтерфейсКучи _интерфейс) 
    { 
        Куча M; with (M) {
            интерфейс_=(_интерфейс);
        } return M; 
    }

    /// очисть the heap
    проц очисть() { Основа.длина = 0; }

    /// куча пуста?
    бул пуста() { return Основа.длина == 0; }

    /// возвращает размер кучи
    бцел размер() { return Основа.длина; }
    бцел длина() { return Основа.длина; }

    /// резервирует пространство для _n записей
    проц резервируй(бцел _n) { util.резервируй(Основа,_n); }

    /// сбросить положение в куче в -1 (нет в куче)
    проц сбрось_положение(ЗаписьКучи _h)
    { интерфейс_.установи_положение(_h, -1); }
  
    /// запись есть в куче?
    бул сохранена(ЗаписьКучи _h)
    { return интерфейс_.дай_положение(_h) != -1; }
  
    /// вставить запись _h
    проц вставь(ЗаписьКучи _h)  
    { 
        Основа ~= _h; 
        upheap(размер()-1); 
    }

    /// получить первую запись
    ЗаписьКучи первая()
    { 
        assert(!пуста()); 
        return запись(0); 
    }

    /// удалить первую запись
    проц удали_первую()
    {    
        assert(!пуста());
        сбрось_положение(запись(0));
        if (размер() > 1)
        {
            запись(0, запись(размер()-1));
            pop_back();
            downheap(0);
        }
        else
        {
            pop_back();
        }
    }

    /// удалить запись
    проц удали(ЗаписьКучи _h)
    {
        цел поз = интерфейс_.дай_положение(_h);
        сбрось_положение(_h);

        assert(поз != -1);
        assert(cast(бцел) поз < размер());
    
        // last item ?
        if (cast(бцел) поз == размер()-1)
        {
            pop_back();    
        }
        else 
        {
            запись(поз, запись(размер()-1)); // move last elem to поз
            pop_back();
            downheap(поз);
            upheap(поз);
        }
    }

    /** обнови an запись: change the key and обнови the position to
        reestablish the heap property.
    */
    проц обнови(ЗаписьКучи _h)
    {
        цел поз = интерфейс_.дай_положение(_h);
        assert(поз != -1, "ЗаписьКучи не в куче (поз=-1)");
        assert(cast(бцел)поз < размер());
        downheap(поз);
        upheap(поз);
    }
  
    /// проверь heap condition
    бул проверь()
    {
        бул ok = true;
        бцел i, j;
        for (i=0; i<размер(); ++i)
        {
            if (((j=left(i))<размер()) && интерфейс_.больше(запись(i), запись(j))) 
            {
                ошибка("Нарушение условий для Кучи");
                ok=false;
            }
            if (((j=right(i))<размер()) && интерфейс_.больше(запись(i), запись(j)))
            {
                ошибка("Нарушение условий для Кучи");
                ok=false;
            }
        }
        return ok;
    }

protected:  
    /// Instance of ИнтерфейсКучи
    ИнтерфейсКучи интерфейс_;
    ЗаписьКучи[]            Основа;
  

private:
    // typedef
    alias ЗаписьКучи[] ВекторКучи;

  
    проц pop_back() {
        assert(!пуста());
        Основа.длина = Основа.длина-1;
    }

    /// Upheap. Establish heap property.
    проц upheap(бцел _idx)
    {
        ЗаписьКучи     h = запись(_idx);
        бцел  parentIdx;

        while ((_idx>0) &&
               интерфейс_.меньше(h, запись(parentIdx=parent(_idx))))
        {
            запись(_idx, запись(parentIdx));
            _idx = parentIdx;    
        }
  
        запись(_idx, h);
    }

  
    /// Downheap. Establish heap property.
    проц downheap(бцел _idx)
    {
        ЗаписьКучи     h = запись(_idx);
        бцел  childIdx;
        бцел  s = размер();
  
        while(_idx < s)
        {
            childIdx = left(_idx);
            if (childIdx >= s) break;
    
            if ((childIdx+1 < s) &&
                (интерфейс_.меньше(запись(childIdx+1), запись(childIdx))))
                ++childIdx;
    
            if (интерфейс_.меньше(h, запись(childIdx))) break;

            запись(_idx, запись(childIdx));
            _idx = childIdx;
        }  

        запись(_idx, h);

    }

      /// Set запись _h to index _idx and обнови _h's heap position.
    проц запись(бцел _idx, ЗаписьКучи _h) 
    {
        assert(_idx < размер());
        Основа[_idx] = _h;
        интерфейс_.установи_положение(_h, _idx);
    }

  
    /// Get the запись at index _idx
    ЗаписьКучи запись(бцел _idx)
    {
        assert(_idx < размер());
        return (Основа[_idx]);
    }
  
    /// Get parent's index
    бцел parent(бцел _i) { return (_i-1)>>1; }
    /// Get left child's index
    бцел left(бцел _i)   { return (_i<<1)+1; }
    /// Get right child's index
    бцел right(бцел _i)  { return (_i<<1)+2; }

}