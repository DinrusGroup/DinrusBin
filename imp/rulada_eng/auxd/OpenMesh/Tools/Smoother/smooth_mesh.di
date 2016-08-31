//============================================================================
// smooth_mesh.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 03 Sep 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//============================================================================

module auxd.OpenMesh.Tools.Smoother.smooth_mesh;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Utils.Property;


//== FUNCTIONS ================================================================

void smooth_mesh_property(_Mesh,_PropertyHandle)(uint _n_iters, _Mesh _m, _PropertyHandle _pph)
{
    alias _PropertyHandle.Value   Value;

    Value[] temp_values = new Value[_m.n_vertices()];

    for (uint i=0; i < _n_iters; ++i)
    {
        for ( _Mesh.ConstVertexIter cv_it = _m.vertices_begin();
              cv_it != _m.vertices_end(); ++cv_it)
        {
            uint valence = 0;

            Value* temp_value = &temp_values[cv_it.handle().idx()];

            temp_value.vectorize(0);

            for ( _Mesh.ConstVertexVertexIter cvv_it = _m.cvv_iter(cv_it);
                  cvv_it; ++cvv_it)
            {
                *temp_value += *_m.property_ptr(_pph,cvv_it);
                ++valence;
            }
            if (valence > 0)
            {//guard against isolated vertices
                *temp_value *= cast(Value.value_type)(1.0 / valence);
            }
            else
            {
                temp_value = _m.property_ptr(_pph, cv_it);
            }
        }

        for ( _Mesh.ConstVertexIter cv_it = _m.vertices_begin();
              cv_it != _m.vertices_end(); ++cv_it)
        {
            *_m.property_ptr(_pph,cv_it) = temp_values[cv_it.handle().idx()];
        }
    }
}

void smooth_mesh(_Mesh)(_Mesh _m, uint _n_iters)
{
    smooth_mesh_property(_n_iters, _m, _m.points_pph());
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
