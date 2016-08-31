//============================================================================
// SingletonT.d - 
//
// Description: 
//   <TODO:>
//
// Author:  William V. Baxter III
// Created: 29 Aug 2007
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

module auxd.OpenMesh.Core.Utils.SingletonT;

/*===========================================================================*\
 *                                                                           *
 *                               OpenMesh                                    *
 *        Copyright (C) 2003 by Computer Graphics Group, RWTH Aachen         *
 *                           www.openmesh.org                                *
 *                                                                           *
 *---------------------------------------------------------------------------* 
 *                                                                           *
 *                                License                                    *
 *                                                                           *
 *  This library is free software; you can redistribute it and/or modify it  *
 *  under the terms of the GNU Lesser General Public License as published    *
 *  by the Free Software Foundation, version 2.1.                            *
 *                                                                           *
 *  This library is distributed in the hope that it will be useful, but      *
 *  WITHOUT ANY WARRANTY; without even the implied warranty of               *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        *
 *  Lesser General Public License for more details.                          *
 *                                                                           *
 *  You should have received a copy of the GNU Lesser General Public         *
 *  License along with this library; if not, write to the Free Software      *
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                *
 *                                                                           *
 \*===========================================================================*/


//=============================================================================
//
//  Implements a simple singleton template
//
//=============================================================================


//=== INCLUDES ================================================================

// OpenMesh
import auxd.OpenMesh.Core.System.config;
static import std.io;


//=== IMPLEMENTATION ==========================================================

class runtime_error : Error
{
    this(char[] msg)
    {
        super("[runtime error]" ~ msg);
    }
}

/** A simple singleton template.
    Encapsulates an arbitrary class and enforces its uniqueness.
*/

class SingletonT(T)
{
public:

    /** Singleton access function.
        Use this function to obtain a reference to the instance of the 
        encapsulated class. Note that this instance is unique and created
        on the first call to Instance().
    */

    static T Instance()
    {
        if (!pInstance__)
        {
            // check if singleton alive
            if (destroyed__)
            {
                OnDeadReference();
            }
            // first time request -> initialize
            else
            {
                Create();
            }
        }
        return pInstance__;
    }


private:

    // Create a new singleton and store its pointer
    static void Create()
    {
        pInstance__ = new T;
    }
  
    // Will be called if instance is accessed after its lifetime has expired
    static void OnDeadReference()
    {
        throw new runtime_error("[Singelton error] - Dead reference detected!\n");
    }

    this();
    ~this()
    {
        pInstance__ = null;
        destroyed__ = true;
    }
  
    static T     pInstance__ = null;
    static bool  destroyed__ = false;
}

class Test {
    this() {
        std.io.writefln("Create Test class");
    }
    ~this() {
        std.io.writefln("Destroy Test class");
    }
    char[] foo = "hi";
}

unittest {
    alias SingletonT!(Test)  TestSingleton;
    std.io.writefln(TestSingleton.Instance.foo);
    TestSingleton.Instance.foo = "bar";
    std.io.writefln(TestSingleton.Instance.foo);
}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
