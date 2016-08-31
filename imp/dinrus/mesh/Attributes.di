module mesh.Attributes;
import mesh.Status;


//== CLASS DEFINITION  ========================================================

/** Attribute биты
 * 
 *  Use the биты to define a standard property at compile time using traits.
 *
 *  \include traits5.cc
 *
 *  See_Also: \ref mesh_type
 */
enum АтрибутныеБиты : бцел
{ 
  Нет          = 0,  ///< Clear all attribute биты
  Нормаль        = 1,  ///< Add normals to mesh item (vertices/faces)
  Цвет         = 2,  ///< Add colors to mesh item (vertices/faces)
  ПредшПолукрай  = 4,  ///< Add storage for previous halfedge (halfedges). The bit is установи by default in the ДефолтныеТрэты.
  Статус        = 8,  ///< Add status to mesh item (all items)
  ТексКоорд1Д    = 16, ///< Add 1D texture coordinates (vertices)
  ТексКоорд2Д    = 32, ///< Add 2D texture coordinates (vertices)
  ТексКоорд3Д    = 64  ///< Add 3D texture coordinates (vertices)
}


