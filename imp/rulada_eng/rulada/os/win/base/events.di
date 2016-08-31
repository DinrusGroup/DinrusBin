﻿/**
 * Предоставляет механизм для обработки _событий.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.base.events;

debug import std.io : writefln;

extern(C) Object _d_toObject(void*);

alias void delegate(Object) DisposeEvent;
version(D_Version2) {
  extern(C) void rt_attachDisposeEvent(Object, DisposeEvent);
  extern(C) void rt_detachDisposeEvent(Object, DisposeEvent);
}
else {
  void rt_attachDisposeEvent(Object obj, DisposeEvent dispose) {
    obj.notifyRegister(dispose);
  }
  void rt_detachDisposeEvent(Object obj, DisposeEvent dispose) {
    obj.notifyUnRegister(dispose);
  }
}

struct EventInfo(R, T...) {

  alias R delegate(T) TDelegate;
  alias R function(T) TFunction;

  enum Type {
    Delegate,
    Function
  }

  union {
    TDelegate dg;
    TFunction fn;
  }
  Type type;

  static EventInfo opCall(TDelegate dg) {
    EventInfo self;
    self.dg = dg;
    self.type = Type.Delegate;
    return self;
  }

  static EventInfo opCall(TFunction fn) {
    EventInfo self;
    self.fn = fn;
    self.type = Type.Function;
    return self;
  }

  R invoke(T args) {
    if (type == Type.Function && fn !is null)
      return fn(args);
    else if (type == Type.Delegate && dg !is null)
      return dg(args);
    static if (!is(R == void))
      return R.init;
  }

}

struct Event(R, T...) {

  alias EventInfo!(R, T) TEventInfo;
  alias TEventInfo.TDelegate TDelegate;
  alias TEventInfo.TFunction TFunction;

  private TEventInfo[] list_;
  private uint size_;

  alias opAddAssign add;

  void opAddAssign(TDelegate dg) {
    if (dg is null)
      return;

    addToList(TEventInfo(dg));

    if (auto obj = _d_toObject(dg.ptr)) {
      // Tends to crash when delegate bodies attempt to access the parent frame.
      // std.signals exhibits the same problem.
      rt_attachDisposeEvent(obj, &release);
    }
  }

  void opAddAssign(TFunction fn) {
    if (fn is null)
      return;

    addToList(TEventInfo(fn));
  }

  alias opSubAssign remove;

  void opSubAssign(TDelegate dg) {
    if (dg is null)
      return;

    for (uint i = 0; i < size_;) {
      if (list_[i].dg is dg) {
        removeFromList(i);

        if (auto obj = _d_toObject(dg.ptr)) {
          rt_detachDisposeEvent(obj, &release);
        }
      }
      else {
        i++;
      }
    }
  }

  void opSubAssign(TFunction fn) {
    if (fn is null)
      return;

    for (uint i = 0; i < size_;) {
      if (list_[i].fn is fn)
        removeFromList(i);
      else
        i++;
    }
  }

  alias opCall invoke;

  R opCall(T args) {
    if (size_ == 0) {
      static if (!is(R == void))
        return R.init;
    }
    else {
      static if (!is(R == void)) {
        for (int i = 0; i < size_ - 1; i++)
          list_[i].invoke(args);
        return list_[size_ - 1].invoke(args);
      }
      else {
        for (int i = 0; i < size_; i++)
          list_[i].invoke(args);
      }
    }
  }

  void clear() {
    list_ = null;
    size_ = 0;
  }

  bool isEmpty() {
    return (size_ == 0);
  }

  uint count() {
    return size_;
  }

  private void addToList(TEventInfo e) {
    uint n = list_.length;

    if (n == 0)
      list_.length = 4;
    else if (n == size_)
      list_.length = list_.length * 2;

    list_[n .. $] = TEventInfo.init;
    list_[size_++] = e;
  }

  private void removeFromList(uint index) {
    size_--;
    if (index < size_) {
      auto temp = list_.dup;
      list_[index .. size_] = temp[index + 1 .. size_ + 1];
    }
    list_[size_] = TEventInfo.init;
  }

  private void release(Object obj) {
    foreach (i, ref e; list_) {
      if (i < size_ && _d_toObject(e.dg.ptr) is obj) {
        rt_detachDisposeEvent(obj, &release);
        e.dg = null;
      }
    }
  }

}

/**
 * Класс-основа для классов, содержащих данные о событии.
 */
class EventArgs {

  /// Представляет собой собетие без данных.
  static EventArgs empty;

  static this() {
    empty = new EventArgs;
  }

}

/**
 * Предоставляет данные для события, которое может быть отменено (cancellable event).
 */
class CancelEventArgs : EventArgs {

  /// Значение, которое показывает, нужно ли отменять событие.
  bool cancel;

  /**
   * Инициализирует новый экземпляр.
   * Параметры: cancel = true для отмены события; иначе, false.
   */
  this(bool cancel = false) {
    this.cancel = cancel;
  }

}

/**
 * Шаблон, который можно использовать для декларации обработчика события.
 * Примеры:
 * ---
 * alias TEventHandler!(MyEventArgs) MyEventHandler;
 * ---
 */
template TEventHandler(TEventArgs = EventArgs) {
  alias Event!(void, Object, TEventArgs) TEventHandler;
}

alias TEventHandler!() EventHandler; /// Represents the method that handles an event with no event data.
alias TEventHandler!(CancelEventArgs) CancelEventHandler; /// Represents the method that handles a cancellable event.
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
