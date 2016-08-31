/******************************************************************************* 

    A 2x2 Matrix 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Christian Kamm (kamm incasoftware de)
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		A 2x2 matrix with standard matrix functionality.

	Examples:
	--------------------
		None provided 
	--------------------

*******************************************************************************/

module arc.math.matrix; 

import
	arc.math.point,
	arc.math.angle,
	arc.math.routines,
	arc.types;
	
import std.math; 

/// Matrix structure 
struct Matrix
{
	/*** constructs a rotation matrix
	   (i.e. p = A*p will be rotated by angle counterclockwise)
	*/
	static Matrix opCall(Radians angle)
	{
		Matrix m; 
		
		arcfl c = cos(angle), s = sin(angle);
		m.col1.x = c; m.col2.x = -s;
		m.col1.y = s; m.col2.y = c;

		return m; 
	}

	/// construct matrix from column vectors
	static Matrix opCall(Point col1, Point col2)
	{
		Matrix m; 
		
		m.col1 = col1; 
		m.col2 = col2; 

		return m; 
	}
	
	/// convert matrix to a string
	char[] toString()
	{
		return "(" ~ std.string.toString(col1.x) ~ ", " ~ std.string.toString(col2.x)
				~ "\n" ~ std.string.toString(col1.y) ~ ", " ~ std.string.toString(col2.y) ~ ")";
	}
	
	/// compute determinant
	arcfl determinant()
	{
		return col1.x * col2.y - col1.y * col2.x;
	}

	/// matrix transpose in-place
	Matrix transpose()
	{
		swap(col1.y, col2.x);
		
		return *this;
	}
	
	/// matrix transpose copy
	Matrix transposeCopy()
	{
		return Matrix(Point(col1.x, col2.x), Point(col1.y, col2.y));
	}

	/// matrix invert in-place
	Matrix invert()
	{
		arcfl det = determinant();
		assert(det != 0.0f, "Can not invert matrix with det = 0");		
		det = 1.0f / det;
		
		swap(col1.x, col2.y);
		col1.x *= det;
		col2.y *= det;
		col2.x *= -det;
		col1.y *= -det;
		
		return *this;
	}
	
	/// matrix invert copy
	Matrix invertCopy()
	{
		Matrix B = *this;
		return B.invert();
	}
	
	/// make abs component wise
	Matrix abs()
	{
		col1.abs();
		col2.abs();
		return *this;
	}

	/// abs copy
	Matrix absCopy()
	{
		Matrix ret = *this;
		ret.abs();
		return ret;
	}
	
	/// matrix-matrix addition
	Matrix opAdd(inout Matrix B)
	{
		return Matrix(col1 + B.col1, col2 + B.col2);
	}

	/// matrix-matrix product
	Matrix opMul(inout Matrix M)
	{
		Matrix T;

		T.col1.x = col1.x * M.col1.x + col2.x * M.col1.y;
		T.col1.y = col1.y * M.col1.x + col2.y * M.col1.y;

		T.col2.x = col1.x * M.col2.x + col2.x * M.col2.y;
		T.col2.y = col1.y * M.col2.x + col2.y * M.col2.y;
		
		return T;
	}
	
	/// matrix-vector product
	Point opMul(inout Point p)
	{
		Point result = Point(col1.x * p.x + col2.x * p.y, col1.y * p.x + col2.y * p.y);
		return result;
	}

	Point col1, col2;
}

deprecated // use in-struct method
{
	/// returns componentwise abs
	Matrix Abs(inout Matrix A)
	{
		return Matrix(A.col1.abs, A.col2.abs);
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
