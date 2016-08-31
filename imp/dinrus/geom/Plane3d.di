module geom.Plane3d;
import linalg.Vector;


//== CLASS DEFINITION =========================================================

	      
/** \class Plane3d Plane3d.hh <OpenMesh/Tools/VDPM/Plane3d.hh>

    ax + by + cz + d = 0
*/


struct Плоскость3м
{
public:

    alias Век3п       т_вектор;
    alias т_вектор.тип_значения   т_знач;

public:

    static Плоскость3м opCall();
    static Плоскость3м opCall(ref т_вектор _dir, ref т_вектор _pnt);
    т_знач дистанцияСоЗнаком( ref Век3п _p);

public:

    т_вектор n_;
    т_знач  d_;

}

unittest {
    Плоскость3м p;
    auto q = Плоскость3м( Век3п(0,1,0), Век3п(1,0,1) );

    p.дистанцияСоЗнаком( Век3п(1,1,1) );
	эхо("OK");
	
}