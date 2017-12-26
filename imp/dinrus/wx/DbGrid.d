module wx.DbGrid;
public import wx.common;
public import wx.Grid;
import dcollections.ArrayList;

	alias Column wxColumn;
	public class Column
	{
		private string dbcolumnname;
		private string newcolumnname;
		private int width;

		//-----------------------------------------------------------------------------

		public this();
		public string dbColumnName() ;
		public void dbColumnName(string value);
		public string newColumnName() ;
		public void newColumnName(string value) ;
		public int Width();
		public void Width(int value) ;
	}
	//-----------------------------------------------------------------------------

	alias ColumnMapping wxColumnMapping;
	public class ColumnMapping
	{
		private Column[] cols;
		private int DEFAULT_COLUMN_WIDTH = 75;

		public this();
		public void Add(string dbcolumnname, string newcolumnname);
		public void Add(string dbcolumnname, string newcolumnname, int width);
		public uint length() ;
		public Column opIndex(int index);
		public Column Search(string dbcolumnname);
		public Column SearchDbColumnName(string newcolumnname);
		public Column[] Cols();
		public int DefaultColumnWidth();
		public void DefaultColumnWidth(int value) ;
	}
	//-----------------------------------------------------------------------------

	public enum DbGridMsg
	{
		OK = 1,
		GRID_CREATION_ERROR,
		NO_TABLE_ERROR,
		NO_COLUMN_ERROR,
		NO_COLUMN_MAPPING_ERROR
	}

	//-----------------------------------------------------------------------------

	alias DbGrid wxDbGrid;
	public class DbGrid : Grid
	{
		//private DataSet myDataSet = null;
		private ColumnMapping colmap = null;

		private string tablename;

		private bool datasetorcolmap = false; // if false, then dataset mapping else column mapping

		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this(Window parent, int id);
		public this(Window parent, int id, Point pos);
		public this(Window parent, int id, Point pos, Size size);
		public this(Window parent, int id, Point pos, Size size, int style);
		public this(Window parent, int id, Point pos, Size size, int style, string name);
		public this(Window parent);
		public this(Window parent, Point pos);
		public this(Window parent, Point pos, Size size);
		public this(Window parent, Point pos, Size size, int style);
		public this(Window parent, Point pos, Size size, int style, string name);

		//public DataSet dataSet() ;
		//public void dataSet(DataSet value) ;

		public ColumnMapping columnMapping() ;
		public void columnMapping(ColumnMapping value) ;
		public int DefaultColumnWidth();
		public void DefaultColumnWidth(int value) ;
		public void AddColumnMapping(string dbcolumnname, string newcolumnname);
		public void AddColumnMapping(string dbcolumnname, string newcolumnname, int width);
		public DbGridMsg CreateGridFromDataSet(string tablename);
		public DbGridMsg CreateGridFromColumnMapping(string tablename);
		public void AddRow();

		//public DataRow GetRow(int num);
		//private void OnGridCellChange(Object sender, Event e);


	}
