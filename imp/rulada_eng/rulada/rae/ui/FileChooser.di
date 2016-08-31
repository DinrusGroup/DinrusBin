/*
* The X11/MIT License
*
* Copyright (c) 2008-2009, Jonas Kivi
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.ui.FileChooser;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.math.Math;
import tango.core.Signal;
import Float = tango.text.convert.Float;
import Integer = tango.text.convert.Integer;

import Unicode = tango.text.Unicode;
import Utf = tango.text.convert.Utf;
import Ascii = tango.text.Ascii;

import Array = tango.core.Array;
public import tango.io.FilePath;
import tango.io.Path;


//Rae imports

import rae.core.globals;
import rae.ui.Box;
import rae.ui.Paned;
import rae.ui.Label;
import rae.ui.Button;
import rae.ui.SubWindow;

import rae.ui.Animator;

import rae.ui.Entry;
import rae.ui.ToggleButton;

import rae.canvas.Draw;

class Folder
{
public:
	public char[] folder(){ return m_folder; }
	public void folder(char[] set){ m_folder = set; }
	protected char[] m_folder;
	
	
}

class FolderButton : Button
{
	this(dchar[] set_name, char[] set_folder, FileChooser set_filechooser)
	{
		super(set_name);
		m_folder = set_folder;
		m_fileChooser = set_filechooser;
		signalActivate.attach( &gotoFolder );
	}
	public char[] folder(){ return m_folder; }
	public void folder(char[] set){ m_folder = set; }
	protected char[] m_folder;
	
	void gotoFolder()
	{
		if( fileChooser !is null )
		{
			fileChooser.currentLocation(folder);
		}
	}
	
	protected FileChooser fileChooser() { return m_fileChooser; }
	protected void fileChooser(FileChooser set) { fileChooser = set; }
	protected FileChooser m_fileChooser;
}

class FilePathWidget : public Rectangle//Button
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;
	/*
	protected this()
	{
		this("")
	}
	*/

	this( dchar[] set_name )
	{
		super();
		//super(set_name);
		name = set_name;
		type = "FilePathWidget";
		
		arrangeType = ArrangeType.HBOX;
		
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.SHRINK;
		alignType = AlignType.BEGIN;
		
		colour = g_rae.getColourArrayFromTheme("Rae.MenuItem");//TODO -> FilePathWidget
		
		isOutline = false;
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.015f;
		inPaddingY = 0.0f;
		
		label = new Label(set_name);
		label.textColour = g_rae.getColourArrayFromTheme("Rae.MenuItem.text");//TODO -> FilePathWidget
		label.xPackOptions = PackOptions.EXPAND;
		label.alignType = alignType;//copy our alignType to that of label's.
		label.outPaddingX = 0.015f;
		add(label);
		
		buttonHandlerInit();
		
		
	}
	
	//This is to override the prelightColour...
	override void updatePrelightColour()
	{	
		prelightColour.set( g_rae.getColourArrayFromTheme("Rae.MenuItem.prelight") );//TODO -> FilePathWidget
	}

	//TODO make a selected mixin.
	void select()
	{
		colour(0.0f, 0.3f, 0.8f, 0.3f);
		m_selected = true;
	}
	void deselect()
	{
		//colour(1.0f, 1.0f, 1.0f, 1.0f);
		colour( mainColour.r, mainColour.g, mainColour.b, mainColour.a );
		m_selected = false;
	}
	protected bool m_selected = false;


	void clear()
	{
		//filePath = cast(FilePath)null;
		filename = "";
		isFolder = false;
	}

	bool isFolder = false;
	char[] filename;
	//FilePath filePath;
}

class FileListVBox : VBox
{
public:

	this(FileChooser set_file_chooser)
	{
		fileChooser = set_file_chooser;
	
		this();
	}

	this()
	{
		super();
		
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.EXPAND;
		//////isOutline = true; //TEMP for visuality
		verticalScrollbarSetting = ScrollbarSetting.ALWAYS;
		horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		
		fileWidgets = new FilePathWidget[20];
		/*
		foreach( Entry ent; fileWidgets )
		{
			ent = new Entry("empty"d);
			add(ent);
		}
		*/
		for( uint i = 0; i < 20; i++ )
		{
			fileWidgets[i] = new FilePathWidget("empty"d);
			fileWidgets[i].colour(0.2f, 0.2f, 0.2f, 0.0f);
			fileWidgets[i].hide();
			fileWidgets[i].signalActivateData.attach(&gotoFolder);
			add(fileWidgets[i]);
		}
			
		//folders = new LinkedList!(FilePath);
		//filePaths = new LinkedList!(FilePath);
		folders = new LinkedList!(char[]);
		files = new LinkedList!(char[]);
		
		
		signalScrollUp.attach(&defaultScrollMouseHandler);
		signalScrollDown.attach(&defaultScrollMouseHandler);
	}
	
	FileChooser fileChooser;

	void gotoFolder(Rectangle widget)
	{
		FilePathWidget pwid = cast(FilePathWidget) widget;
		
		if( fileChooser is null )
			return;
			
		if( pwid.isFolder == true )
		{
			debug(FileChooser) Trace.formatln("gotofolder: {}", pwid.filename);
			fileChooser.currentLocation(pwid.filename);
			fileChooser.selectFilePathWidget(pwid);
			if( verticalScrollbar !is null )
			{
				verticalScrollbar.slider.value = 0.0f;
			}
		}
		else
		{
			debug(FileChooser) Trace.formatln("selected file: {}", pwid.filename);
			fileChooser.currentFilePathString( pwid.filename );
			//fileChooser.currentLocation(pwid.filename);
			fileChooser.selectFilePathWidget(pwid);
		}
		
	}

	void clear()
	{
		clearFolders();
		clearFiles();
	}

	void appendFolder( char[] set )
	{
		folders.append( set );
		debug(FileChooser) Trace.formatln("addFolder: {}", set );
	}
	
	void clearFolders()
	{
		if( folders is null )
			return;
			
		foreach( char[] fp; folders )
		{
			delete fp;
		}
			
		folders.clear();
	}
	
	//void appendFile( FilePath set )
	void appendFile( char[] set )
	{
		//filePaths ~= set;
		files.append( set );
		debug(FileChooser) Trace.formatln("addFile: {}", set);
	}
	
	void prependFile( char[] set )
	{
		//filePaths ~= set;
		files.prepend( set );
		debug(FileChooser) Trace.formatln("addFile: {}", set);
	}
	
	void clearFiles()
	{
		if( files is null )
			return;
			
		foreach( char[] fp; files )
		{
			delete fp;
		}
					
		files.clear();
	}
	
	bool isShowImageSequences() { return m_isShowImageSequences; }
	void isShowImageSequences(bool set) { m_isShowImageSequences = set; }
	protected bool m_isShowImageSequences = false;
			
	void updateFiles()
	{
		//
	
		if( files !is null && fileWidgets !is null )
		{
		
			startIndex = 0;
			endIndex = 19;
			
			int i = startIndex;
			int k = 0;
			
			if( fileWidgets is null ) return;
			if( fileWidgets.length > 0 && currentFilePathString != "" )
			{
				//if( fileWidgets[0] !is null ) delete fileWidgets[0];
				/*
				debug(FileChooser) Trace.formatln("Parent is: {}", currentFilePath.parent );
			
				char[] parentdir = currentFilePath.parent;
				
				if( parentdir == "" )
					parentdir = "/";
				*/
			/*
				//a special case if it's not a folder but a file:
				if( currentFilePath.isFolder == false )
				{
					FilePath temppath = new FilePath( parentdir );
					parentdir = temppath.parent;
				}
			*/
			
			/*
			//There used to be this oldschool parent folder button...
				fileWidgets[0].text = ".. Parent Folder"d;
				fileWidgets[0].filePath = new FilePath( parentdir );
				fileWidgets[0].isFolder = true;
				fileWidgets[0].colour(0.0f, 0.0f, 0.0f, 0.5f);
				fileWidgets[0].show();
			*/
			}
			
			handleImageSequence( "", null, null );//reset.
			
			for( ; k < fileWidgets.length; k++ )
			{
				if( i < folders.size && i < endIndex && fileWidgets[k] !is null && folders.get(i) !is null )
				{
					scope FilePath fptemp = new FilePath( folders.get(i) );
					fileWidgets[k].text = Utf.toString32( fptemp.name );
					fileWidgets[k].filename = folders.get(i);
					fileWidgets[k].isFolder = true;
					fileWidgets[k].colour(0.2f, 0.7f, 0.2f, 0.8f);
					fileWidgets[k].show();
					//debug(FileChooser) Trace.formatln("i: {}, k: {} set name to: {} now it is: {}", i, k, folders.get(i).file, fileWidgets[k].text );
				}
				else //if( fileWidgets[k] !is null && fileWidgets[k].text != "empty"d )
				{
					break;
					//fileWidgets[k].text = "empty"d;
					//fileWidgets[k].colour(0.2f, 0.2f, 0.2f, 0.0f);
				}
				
				i++;
			}
			
			startIndex = 0;
			endIndex = 19;
			i = startIndex;
			
			
			//for( uint i = startIndex; i < endIndex && i < filePaths.length && k < fileWidgets.length; i++ )
			for( ; k < fileWidgets.length; k++ )
			{
				if( fileWidgets[k] is null )
					break;
			
				
				//No more files to handle. Mark it empty for now.
				if( i >= files.size || files.get(i) is null )
				{
					if( fileWidgets[k].text != "empty"d )
					{
						fileWidgets[k].text = "empty"d;
						fileWidgets[k].clear();
						fileWidgets[k].colour(0.2f, 0.2f, 0.2f, 0.0f);
						fileWidgets[k].hide();
					}
					continue;
				}
				
				if( isShowImageSequences == false )
				{
					handleFile( files.get(i), fileWidgets[k] );
				}
				else //Image sequence handling:
				{
					//Trace.formatln("Aaargh file: {} k: {} i: {}", files.get(i), k , i );
					
					FilePathWidget prev_file_widget = null;
					if( (k-1) >= 0 )
					{
						//Trace.formatln("k-1 >= 0 Ok.");
						prev_file_widget = fileWidgets[k-1];
					}
					else
					{
						//Trace.formatln("First file. k-1 < 0.");
					}
					
					if( handleImageSequence( files.get(i), fileWidgets[k], prev_file_widget ) == true )
					{
						k--;//if handleImageSequence return true, then we minus k. Otherwise the k will just go on.
						//Trace.formatln("k-- : {} k: {} i: {}", files.get(i), k , i );
					}
					
				}
				
				i++;
				
				/*
				void normal_handling_func()
				{
					if( fp !is null ) delete fp;
					fp = new FilePath( files.get(i) );
					fileWidgets[k].text = Utf.toString32( fp.file );
					//fileWidgets[k].text = Utf.toString32( new PathParser.parse( files.get(i) ).file );
					//scope FilePath fptemp = new FilePath( files.get(i) );
					fileWidgets[k].filename = files.get(i);
					fileWidgets[k].isFolder = false;
					fileWidgets[k].colour(0.3f, 0.3f, 0.3f, 0.5f);
					fileWidgets[k].show();
					//debug(FileChooser) Trace.formatln("i: {}, k: {} set name to: {} now it is: {}", i, k, filePaths.get(i).file, fileWidgets[k].text );
				}
			
				//There is a file to handle.
				if( isShowImageSequences == false )
				{
					normal_handling_func();
				}
				else //Image sequence handling:
				{
					if( fp !is null ) delete fp;
					fp = new FilePath( files.get(i) );
				
					endDigits = FileChooser.getEndDigits( fp.name );
					baseName = FileChooser.getWithoutEndDigits( fp.name );
					
					if(endDigits == -1 || fp.suffix != suffixLast || baseName != baseNameLast || endDigits != (endDigitsLast+1) )//no digits found.
					{
						debug(FileChooser) Trace.formatln("baseName: {} baseNameLast: {}", baseName, baseNameLast);
						normal_handling_func();
						if( currentSeqStartFp !is null ) delete currentSeqStartFp;
						currentSeqStartFp = new FilePath( fp.toString );//This always zeros the starting point. Makes it the current file (which is fp).
					}
					else
					{
						//if their basenames match and the endDigits are on bigger than last time, then it's an image (or file) sequence.
						k--;
						if( currentSeqStartFp !is null )
							fileWidgets[k].text = Utf.toString32( "seq: " ~ currentSeqStartFp.file ~ " - " ~ fp.file );
						else
						{
							Trace.formatln("FileChooser.updateFiles() Image Sequence handling has failed. Unhandled case. This should never happen.");
						}
					}
					endDigitsLast = endDigits;
					baseNameLast = baseName;
					lastFp = fp;
					suffixLast = fp.suffix;
				}
				
				i++;
				*/
				
				/*
				//The following was commented out:
				else
				{
					Trace.formatln("null i: {}, k: {}", i, k);
					if( fileWidgets[k] is null )
					{
						Trace.formatln("null is fileWidgets.");
						Trace.formatln("fileWidgets.length: {}", fileWidgets.length );
					}
					if( filePaths[i] is null )
					{
						Trace.formatln("null is filePaths.");
						Trace.formatln("filePaths.length: {}", filePaths.length );
						Trace.formatln("filePath[i]: {}", filePaths[i].file );
					}
					break;
				}
				*/
				
			}
			
		}
			
		//
		
		//super.arrange();
	}
	
	void handleFile( char[] set_file, FilePathWidget set_file_widget )
	{
		//Trace.formatln("handleFile.");
	
					scope FilePath fp = new FilePath( set_file );
					set_file_widget.text = Utf.toString32( fp.file );
					//fileWidgets[k].text = Utf.toString32( new PathParser.parse( files.get(i) ).file );
					//scope FilePath fptemp = new FilePath( files.get(i) );
					set_file_widget.filename = set_file;
					set_file_widget.isFolder = false;
					set_file_widget.colour(0.3f, 0.3f, 0.3f, 0.5f);
					set_file_widget.show();
					//debug(FileChooser) Trace.formatln("i: {}, k: {} set name to: {} now it is: {}", i, k, filePaths.get(i).file, fileWidgets[k].text );
	}
			
	//Must return false if set_file wasn't part of the last imageSequence,
	//and return true if set_file was part of the last imageSequence.
	bool handleImageSequence( char[] set_file, FilePathWidget set_file_widget, FilePathWidget prev_file_widget )
	{
		//Trace.formatln("0");
	
		//Image sequence stuff:
			
			static char[] currentSeqStartString = "";
			static long endDigitsSeqStart = -1;
			static long endDigitsLast = -1;
			static char[] baseNameLast = "";
			static char[] suffixLast = "";
			
			bool was_part_of_sequence = false;
			
			//FilePath fp;
			//FilePath lastFp;
			long endDigits = -1;			
			char[] baseName = "";
			
			//A special case for resetting.
			if( set_file_widget is null )
			{
				currentSeqStartString = "";
				endDigitsSeqStart = -1;
				endDigitsLast = -1;
				baseNameLast = "";
				suffixLast = "";
				return false;
			}
			
			//FilePath currentSeqStartFp;
			
			//Trace.formatln("1");
			
					//if( fp !is null ) delete fp;
					scope FilePath fp = new FilePath( set_file );
				
					endDigits = FileChooser.getEndDigits( fp.name );
					baseName = FileChooser.getWithoutEndDigits( fp.name );
					
					//If there are no end digits,
					//Or the suffix has changed, or the basename has changed,
					//or the enddigits are not incremented by 1,
					//then we do normal handleFile
					if( endDigits == -1 || fp.suffix != suffixLast || baseName != baseNameLast || endDigits != (endDigitsLast+1) )
					{
						//Trace.formatln("2");
					
						debug(FileChooser) Trace.formatln("baseName: {} baseNameLast: {}", baseName, baseNameLast);
						handleFile( set_file, set_file_widget );
						
						//Trace.formatln("2.1");
						
						//if( currentSeqStartFp !is null ) delete currentSeqStartFp;
						//currentSeqStartFp = new FilePath( fp.toString );//This always zeros the starting point. Makes it the current file (which is fp).
						currentSeqStartString = set_file;
						endDigitsSeqStart = endDigits;
					}
					else
					{
						//Trace.formatln("3");
						//if their basenames match and the endDigits are on bigger than last time, then it's an image (or file) sequence.
						///////k--;
						//if( currentSeqStartFp !is null )
						if( currentSeqStartString != "" && prev_file_widget !is null )
						{
							//Trace.formatln("3.1");
							scope FilePath currentSeqStartFp = new FilePath( currentSeqStartString );
							prev_file_widget.text = Utf.toString32( getSequenceString( currentSeqStartFp.file, fp.file, endDigitsSeqStart, endDigits ) );
							was_part_of_sequence = true;
						}
						else
						{
							Trace.formatln("FileChooser.updateFiles() Image Sequence handling has failed. Unhandled case. This should never happen.");
						}
					}
					
					//Trace.formatln("4");
					
					endDigitsLast = endDigits;
					baseNameLast = baseName;
					//lastFp = fp;
					suffixLast = fp.suffix;
				
		return was_part_of_sequence;
	}			
				
	char[] getSequenceString( char[] start_file, char[] end_file, long start_frames, long end_frames )
	{
		return "seq: " ~ start_file ~ " - " ~ end_file;
	}

	void sortAlphabetically()
	{
		debug(FileChooser) Trace.formatln("Sorting: file.");
		//scope(exit) Trace.formatln("Sorting: done.");
		
		folders.sort( &compareFilePathStringAlphabetically );
		
		//filePaths.sort( &compareFilePathAlphabetically );
		files.sort( &compareFilePathStringAlphabetically );
	}

	//FilePath currentFilePath;
	char[] currentFilePathString;
	
protected:

	FilePathWidget[] fileWidgets;

	//protected LinkedList!(FilePath) folders;
	protected LinkedList!(char[]) folders;
	//protected FilePath[] filePaths;
	//protected LinkedList!(FilePath) filePaths;
	protected LinkedList!(char[]) files;
	
	protected uint startIndex() { return m_startIndex; }
	protected void startIndex(uint set) { m_startIndex = set; }
	protected uint m_startIndex = 0;
	
	protected uint endIndex() { return m_endIndex; }
	protected void endIndex(uint set) { m_endIndex = set; }
	protected uint m_endIndex = 0;

}

int compareFilePathStringAlphabetically( ref char[] a, ref char[] b )
{
	if( a is null )
	{
		if( b is null )
			return 0;
		//else
			return 1;
	}
	else if( b is null )
		return -1;
	
	//scope FilePath apath = new FilePath(a);
	//scope FilePath bpath = new FilePath(b);
	//return Ascii.compare( apath.file, bpath.file );
	return Ascii.compare( a, b );
}


int compareFilePathAlphabetically( ref FilePath a, ref FilePath b )
{
	if( a is null )
	{
		if( b is null )
			return 0;
		//else
			return 1;
	}
	else if( b is null )
		return -1;
	
	return Ascii.compare( a.file, b.file );
}

class FileChooser : VBox
{
public:
	///Utilitity functions to be used
	///everywhere where information about
	///files is needed:
	
	static bool doesFileExist( char[] set_filename )
	{
		scope FilePath a_path = new FilePath( set_filename );
		return a_path.exists();
	}

	static FilePath[] listFoldersInFolder(FilePath set_path)
	{
		debug(FileChooser) Trace.formatln("listFoldersInFolder() {}", set_path.toString );
	
		bool onlyFolders(FilePath set_path, bool isDir)
		{
			return isDir;
		}

		FilePath[] result;
		if( set_path.isFolder == false )
		{
			char[] folder_name = set_path.parent;
			//set_path = new FilePath(folder_name);
			set_path.set( folder_name );
		}
		
		try
		{
			result = set_path.toList( &onlyFolders );
		}
		catch( Exception ex )
		{
			Trace.formatln("Failed to read the directory contents - folders.");
		}

		return result;
	}

	///This will list all/only the files contained in the
	///folder set_path.
	static FilePath[] listFilesInFolder(FilePath set_path)
	{
		bool onlyFiles(FilePath set_path, bool isDir)
		{
			if( isDir == false )
				return true;
			//else
				return false;
		}

		FilePath[] result;
		if( set_path.isFolder == false )
		{
			char[] folder_name = set_path.folder;
			set_path = new FilePath(folder_name);
		}
		
		try
		{
			result = set_path.toList( &onlyFiles );
		}
		catch( Exception ex )
		{
			Trace.formatln("Failed to read the directory contents - files.");
		}

		return result;
	}
	
	static FilePath[] listFilesInFolderAlphabetically(FilePath set_path)
	{
		FilePath[] all_files = listFilesInFolder(set_path);
		Array.sort( all_files, &isBeforeInAlphabeticalOrder );
		return all_files;

		/*
		//I couldn't do this:

		scope FilePath[] all_files = listFilesInFolder(set_path);
		FilePath[] result_files = new FilePath[all_files.length];

		uint k = 0;

		for( uint i = 0; i < all_files.length-1; i++ )
		{
			if( isBeforeInAlphabeticalOrder( all_files[i].file, all_files[i+1].file ) )
				result_files[]

			k++;
		}
		*/
	}

	static bool isBeforeInAlphabeticalOrder( FilePath pt1, FilePath pt2 )
	{
		return isBeforeInAlphabeticalOrder( pt1.toString, pt2.toString );
	}

	///Parse two strings and return true if the first one is before
	///the other in alphabetical order.
	static bool isBeforeInAlphabeticalOrder( char[] str, char[] str2 )
	{
		for( uint i = 0; (i < str.length && i < str2.length); i++ )
		{
			if( str[i] < str2[i] )
				return true;
			else if( str[i] > str2[i] )
				return false;
		}
		//We should never get here.
		return true;
	}

	///Parse a string and check if it contains only digits (numbers).
	static bool doesContainOnlyDigits( char[] str )
	{
		foreach( char ch; str )
		{
			if( Unicode.isDigit( cast(dchar)ch ) == false )
				return false;
		}
		return true;
	}

	///return -1 if there are no digits.
	static long getEndDigits( char[] str )
	{
		if( FileChooser.doesContainOnlyDigits(str) == true )
		{
			return Integer.toLong(str);
		}
		//else
			char[] digits;
			foreach( char ch; str )
			{
				if( Unicode.isDigit( cast(dchar)ch ) == true )
					digits ~= ch;
				else digits = "";//on each letter we scrap the string, as we only
				//want the digits from the end of the string.
			}
			if(digits == "")
				return -1;//no digits in it.
			return Integer.toLong(digits);
	}

	static int howManyDigits( char[] str )
	{
		int count = 0;
		foreach( char ch; str )
		{
			if( Unicode.isDigit( cast(dchar)ch ) == true )
				count++;
			else count = 0;//on each letter we scrap the count, as we only
			//want the digits from the end of the string.
		}
		return count;
	}

	static char[] getWithoutEndDigits( char[] str )
	{
		if( FileChooser.doesContainOnlyDigits(str) == true )
		{
			return "";
		}
		//else

			uint i = str.length-1;

			//go backwards.
			for( ; i >= 0; i--)
			{
				if( Unicode.isDigit( cast(dchar)str[i] ) == false )
					break;//found first letter from the end. stop loop.
			}

			i++;

			//slice it.
			return str[0..i].dup;
	}








	//The actual FileChooser widget:

	this( FileListVBox set_fileview = null )
	{
		version(linux)
		{
			this( g_rae.homeDir, set_fileview );
		}
		version(darwin)
		{
			this( g_rae.homeDir, set_fileview );
		}
		version(Windows)
		{
			this( g_rae.applicationDir, set_fileview );
		}
	}

	this( char[] set_start_folder, FileListVBox set_fileview = null )
	{
		super();
		name = "FileChooser";

		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.EXPAND;

		//Widget creation:

		folderButtonsHBox = new HBox();
		//folderButtonsHBox.isOutline = true; //TEMP for visuality
		//folderButtonsHBox.gradient = g_rae.getGradientFromTheme("Rae.WindowHeader.continued");
		//folderButtonsHBox.colour = g_rae.getColourArrayFromTheme("Rae.WindowHeader.Top");
		add(folderButtonsHBox);
		
		parentFolderButton = new Button("Up", &gotoParentFolder);
		folderButtonsHBox.add( parentFolderButton );
		
		currentFilePathEntry = new Entry( Utf.toString32(set_start_folder) );
		currentFilePathEntry.signalTextChanged.attach(&currentLocationD);
		folderButtonsHBox.add( currentFilePathEntry );
		/*
		Button fakeButton1 = new Button("home");
		folderButtonsHBox.add(fakeButton1);
		Button fakeButton2 = new Button("joonaz");
		folderButtonsHBox.add(fakeButton2);
		Button fakeButton3 = new Button("muiden");
		folderButtonsHBox.add(fakeButton3);
		Button fakeButton4 = new Button("video");
		folderButtonsHBox.add(fakeButton4);
		Button fakeButton5 = new Button("dpx");
		folderButtonsHBox.add(fakeButton5);
		*/

		bookmarksAndFileViewHBox = new HBox();
		bookmarksAndFileViewHBox.xPackOptions = PackOptions.EXPAND;
		bookmarksAndFileViewHBox.yPackOptions = PackOptions.EXPAND;
		add(bookmarksAndFileViewHBox);

		bookmarks = new VBox();
		//bookmarks.xPackOptions = PackOptions.EXPAND;
		//bookmarks.yPackOptions = PackOptions.EXPAND;
		//////bookmarks.isOutline = true; //TEMP for visuality
		bookmarksAndFileViewHBox.add( bookmarks );

		FolderButton homeButton = new FolderButton("Home", g_rae.homeDir, this );
		homeButton.alignType = AlignType.BEGIN;
		//homeButton.signalActivate.attach( &gotoHomeDir );
		bookmarks.add(homeButton);
		FolderButton desktopButton = new FolderButton("Desktop", g_rae.desktopDir, this );
		desktopButton.alignType = AlignType.BEGIN;
		//desktopButton.signalActivate.attach(  );
		bookmarks.add(desktopButton);
		FolderButton systemButton = new FolderButton("System", g_rae.systemDir, this );
		systemButton.alignType = AlignType.BEGIN;
		//systemButton.signalActivate.attach( &gotoSystemDir );
		bookmarks.add(systemButton);
		
		debug(FileChooser)
		{
			FolderButton toughButton = new FolderButton("Toughtest", "/usr/bin/", this );
			toughButton.alignType = AlignType.BEGIN;
			bookmarks.add(toughButton);
		}
		
		FolderButton volumesButton = new FolderButton("Volumes", "/Volumes/", this );
		volumesButton.alignType = AlignType.BEGIN;
		bookmarks.add(volumesButton);

		scrollbarsForFileViews = new VBox();
		scrollbarsForFileViews.xPackOptions = PackOptions.EXPAND;
		scrollbarsForFileViews.yPackOptions = PackOptions.EXPAND;
		//////scrollbarsForFileViews.isOutline = true; //TEMP for visuality
		scrollbarsForFileViews.verticalScrollbarSetting = ScrollbarSetting.NEVER;
		scrollbarsForFileViews.horizontalScrollbarSetting = ScrollbarSetting.ALWAYS;
		bookmarksAndFileViewHBox.add( scrollbarsForFileViews );

		fileViewPaned = new VPaned();
		scrollbarsForFileViews.add(fileViewPaned);

		if( set_fileview !is null )
		{
			fileView = set_fileview;
			fileView.fileChooser = this;
		}
		else
		{
			fileView = new FileListVBox(this);
		}
		/*
		fileView.xPackOptions = PackOptions.EXPAND;
		fileView.yPackOptions = PackOptions.EXPAND;
		fileView.isOutline = true; //TEMP for visuality
		fileView.verticalScrollbarSetting = ScrollbarSetting.ALWAYS;
		fileView.horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		*/
		fileViewPaned.add(fileView);

		///////fileView2 = new FileListVBox();
		/*
		fileView2.xPackOptions = PackOptions.EXPAND;
		fileView2.yPackOptions = PackOptions.EXPAND;
		fileView2.isOutline = true; //TEMP for visuality
		fileView2.verticalScrollbarSetting = ScrollbarSetting.ALWAYS;
		fileView2.horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		*/
		///////fileViewPaned.add(fileView2);

		///////fileView3 = new FileListVBox();
		/*
		fileView3.xPackOptions = PackOptions.EXPAND;
		fileView3.yPackOptions = PackOptions.EXPAND;
		fileView3.isOutline = true; //TEMP for visuality
		fileView3.verticalScrollbarSetting = ScrollbarSetting.ALWAYS;
		fileView3.horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		*/
		///////fileViewPaned.add(fileView3);

		//Entry tempEntry1 = new Entry("This a temporary entry to test some stuff.");
		//fileView.add(tempEntry1);

		okButtonsHBox = new HBox();
		//////okButtonsHBox.isOutline = true; //TEMP for visuality
		add(okButtonsHBox);

		closeButton = new Button("Close");
		okButtonsHBox.add(closeButton);
		okButton = new Button("OK");
		okButtonsHBox.add(okButton);
		
		okButton.signalActivate.attach(&onFileChosen);

		//FileChooser initialization:

		//m_currentFilePath = new FilePath(set_start_folder);
		m_currentFilePathString = set_start_folder;

		scanCurrentFilePath();

		/*
		Label fakeFile1 = new Label("file1");
		fileView.add(fakeFile1);
		Label fakeFile2 = new Label("file2");
		fileView.add(fakeFile2);
		Label fakeFile3 = new Label("file3");
		fileView.add(fakeFile3);
		Label fakeFile4 = new Label("file4");
		fileView.add(fakeFile4);
		*/
	}

	//Signal!(FilePath) signalFileChosen;
	Signal!(char[]) signalFileChosen;
	void onFileChosen()
	{
		if( selectedFilePathWidget !is null )
			//signalFileChosen.call(selectedFilePathWidget.filePath);//currentFilePath);
		//signalFileChosen.call( currentFilePath );
		signalFileChosen.call( currentFilePathString );
	}
	
	bool isShowImageSequences() { return fileView.isShowImageSequences; }
	void isShowImageSequences(bool set) { fileView.isShowImageSequences = set; }
	//protected bool m_isShowImageSequences = true;
	
	bool isShowHiddenFiles() { return m_isShowHiddenFiles; }
	void isShowHiddenFiles(bool set) { m_isShowHiddenFiles = set; }
	protected bool m_isShowHiddenFiles = false;

protected:

	void gotoSystemDir() { currentLocation(g_rae.systemDir); }
	void gotoHomeDir() { currentLocation(g_rae.homeDir); }
	
	char[] last_scan_location = "";
	
	void scanCurrentFilePath()
	{
		/*
		if( currentFilePath is null )
		{
			Trace.formatln("Error in programming. currentFilePath is null in scanCurrentFilePath." );
			return;
		}
		*/
		if( last_scan_location == currentFilePathString )
		{
			debug(FileChooser) Trace.formatln("last_scan_location == currentFilePath. Skipping scanCurrentFilePath.");
			return;
		}
		
		FilePath currentFilePath = new FilePath( currentFilePathString );
		
		if( currentFilePath.exists() == false )
		{
			Trace.formatln("File or folder {} doesn't exist.", currentLocation );
			return;
		}
		
		if( currentFilePath.isFolder == false )
		{
			Trace.formatln("Can't scan this, it is not a folder but a file: {}", currentLocation );
			return;
		}
	
		debug(FileChooser) Trace.formatln("scanCurrentFilePath START. {}", currentFilePathString );
		debug(FileChooser) scope(exit) Trace.formatln("scanCurrentFilePath END.");
	
		last_scan_location = currentFilePathString;
	
		fileView.clear();
		///////fileView2.clearFiles();
		///////fileView3.clearFiles();

		fileView.currentFilePathString = currentFilePathString;

		scope FilePath[] tfolders = listFoldersInFolder( currentFilePath );
		foreach( FilePath fp; tfolders )
		{
			if( isShowHiddenFiles == false && fp.file.length > 0 && fp.file[0] == '.' )
				continue;
			fileView.appendFolder(fp.toString);
		}

		scope FilePath[] tfiles3 = listFilesInFolder( currentFilePath );
		//addFileToFileView(fileView3, currentFilePath);
		foreach( FilePath fp; tfiles3 )
		{
			//addFileToFileView(fileView3, fp);
			if( isShowHiddenFiles == false && fp.file.length > 0 && fp.file[0] == '.' )
				continue;
			
			fileView.appendFile(fp.toString);			
		}
		
		fileView.sortAlphabetically();
	/*
		if( currentFilePath.isChild == true )
		{

			scope FilePath store_current_location = currentFilePath.dup;

			currentFilePath.pop();

			if( currentFilePath.exists() == true )
			{
				scope FilePath[] tfiles2 = listFilesInFolderAlphabetically( currentFilePath );
				//addFileToFileView(fileView2, currentFilePath);
				foreach( FilePath fp; tfiles2 )
				{
					//addFileToFileView(fileView2, fp);
					if( isShowHiddenFiles == false && fp.file.length > 0 && fp.file[0] == '.' )
						continue;
					fileView2.addFile(fp);
				}

				if( currentFilePath.isChild == true )
				{
					currentFilePath.pop();
					if( currentFilePath.exists() == true )
					{
						scope FilePath[] tfiles = listFilesInFolderAlphabetically( currentFilePath );
						//addFileToFileView(fileView, currentFilePath);
						foreach( FilePath fp; tfiles )
						{
							//addFileToFileView(fileView, fp);
							if( isShowHiddenFiles == false && fp.file.length > 0 && fp.file[0] == '.' )
								continue;
							fileView.addFile(fp);
						}
					}
				}
				
			}

			//go back to where we were.
			currentFilePath.set(store_current_location);

		}
		*/
		fileView.updateFiles();
		///////fileView2.updateFiles();
		///////fileView3.updateFiles();
	}

	//Maybe a class FileListVBox might be a good idea.
	/*
	void addFileToFileView( VBox set_file_view, FilePath set )
	{
		if( isShowHiddenFiles == false && set.file.length > 0 && set.file[0] == '.' )
		{
			return;//ignore hidden files.
		}
		Entry a_file = new Entry( Utf.toString32(set.file) );
		set_file_view.add(a_file);
	}
	*/

	void selectFilePathWidget( FilePathWidget set )
	{
		if( selectedFilePathWidget !is null )
			selectedFilePathWidget.deselect();
		selectedFilePathWidget = set;
		set.select();
		//if( currentFilePathEntry !is null )
		//	currentFilePathEntry.text = Utf.toString32( set.filePath.toString() );
	}
	
	char[] currentLocation() { return currentFilePathString; }//{ return (m_currentFilePath !is null) ? m_currentFilePath.toString() : ""; }
	void currentLocation(char[] set)
	{
		debug(FileChooser) Trace.formatln("currentLocation: {}", set);
		if( currentFilePathString == set )
			return;//the same
		if( currentFilePathEntry !is null )
			currentFilePathEntry.text = Utf.toString32( set );
		m_currentFilePathString = set;//This crashes...
		//else
		//if( m_currentFilePath !is null ) delete m_currentFilePath;
			//m_currentFilePath = new FilePath( set );
		scanCurrentFilePath();
	}
	void currentLocationD(dchar[] set)
	{
		if( currentFilePathString == Utf.toString(set) )
			return;//the same again
		if( currentFilePathEntry !is null )
			currentFilePathEntry.text = set;
		m_currentFilePathString = Utf.toString(set);
		scanCurrentFilePath();
	}
	
	/*
	synchronized public FilePath currentFilePath() { return m_currentFilePath; }
	synchronized protected FilePath currentFilePath(FilePath set)
	{
		if( currentFilePathEntry !is null )
			currentFilePathEntry.text = Utf.toString32( set.toString() );
		return m_currentFilePath = set;
	}
	protected FilePath m_currentFilePath;
	*/
	public char[] currentFilePathString()
	{
		return m_currentFilePathString;
	}
	public void currentFilePathString( char[] set )
	{
		m_currentFilePathString = set;
		if( currentFilePathEntry !is null )
			currentFilePathEntry.text = Utf.toString32( set );
	}
	char[] m_currentFilePathString;

	synchronized void gotoParentFolder()
	{
		if( currentFilePathEntry is null )
			return;
		if( currentFilePathEntry.text == "/"d )//if we're already in the root dir, we do nothing.
			return;
			
		//to go around a tango bug (in my opinion):
		//The bug is that if there's a trailing /, then FilePath.parent won't return the root dir / in anycase.
		//scope 
		char[] currenttext = Utf.toString( currentFilePathEntry.text );
		if( currenttext[length-1] == '/' )
		{
			debug(FileChooser) Trace.formatln("Going to strip trailing / from: {} to: {}", currenttext, currenttext[0..length-1] );
			currenttext = currenttext[0..length-1];
		}
			
		//scope 
		FilePath temppath = new FilePath( currenttext );
		/*
		CRASH:
		if( temppath.exists == true && temppath.isFolder == false )
		{
			//Trace.formatln("not a folder.");
			//temppath.set( temppath.parent );//AAAAAAARGH. This crashes. So that's why we do the following stupidity.
			scope FilePath temppath2 = new FilePath( temppath.parent );
			Trace.formatln("temppath2.parent: {}", temppath2.parent );
			currentLocation( temppath2.parent ~ "/" );
			return;
		}
		*/
		
		char[] tempfolder = temppath.parent;// ~ "/";
		delete temppath;
		
		currentLocation( tempfolder );	
	}

	Button parentFolderButton;
	Entry currentFilePathEntry;
	
	FilePathWidget selectedFilePathWidget;

	HBox folderButtonsHBox;
	HBox bookmarksAndFileViewHBox;
		VBox bookmarks;
		VBox scrollbarsForFileViews;//Rectangle
			Paned fileViewPaned;
				FileListVBox fileView;
				FileListVBox fileView2;
				FileListVBox fileView3;
	HBox okButtonsHBox;
		Button okButton;
		Button closeButton;
}


class FileChooserDialog : SubWindow
{
	this(dchar[] set_name = "File Chooser"d, FileChooser set_filechooser = null )
	{
		super(set_name, WindowButtonType.DEFAULTS2, WindowHeaderType.SMALL, WindowHeaderType.SMALL, false );

		shadowType = ShadowType.ROUND;

		isClosingHides = true;

		//test: sendToTopOnMouseButtonPress = false;

		//With set_filechooser it is possible to e.g. override the class
		//FileChooser, and then pass the your own class object as the argument set_filechooser here.
		if( set_filechooser !is null )
		{
			fileChooser = set_filechooser;
		}
		else
		{
			fileChooser = new FileChooser();
		}
		
		fileChooser.okButton.signalActivate.attach(&okButtonHandler);
		fileChooser.closeButton.signalActivate.attach(&hide);
		add(fileChooser);

		//Make the folderButtonsHBox to be able to
		//drag and move the window. Hack.
		if( fileChooser.folderButtonsHBox !is null )
		{
			fileChooser.folderButtonsHBox.signalMouseButtonPress.attach(&side1.headerHandler);
			fileChooser.folderButtonsHBox.signalMouseButtonRelease.attach(&side1.headerHandler);
			fileChooser.folderButtonsHBox.signalMouseMotion.attach(&side1.headerHandler);
		}

		auto isShowSequencesButton = new ToggleButton("Show file sequences", &fileChooser.isShowImageSequences, &fileChooser.isShowImageSequences );
		add2(isShowSequencesButton);
		
		auto isShowHiddenFilesButton = new ToggleButton("Show hidden files", &fileChooser.isShowHiddenFiles, &fileChooser.isShowHiddenFiles );
		add2(isShowHiddenFilesButton);

		//DONE I think afterAdd down there solves this. NO it doesn't.
		//TODO how to make the initial size to be e.g. 80% of the
		//parent window size. Possibly a signal called onAddFloating
		//which we'll use to set:
		//wh(parent.w*0.8f, parent.h*0.8f);
		//defaultSize( 0.9f, 0.6f );
	}

	void okButtonHandler()
	{
		hide();
	}

	override protected void isHidden(bool set)
	{
		if( parent !is null )
			wh(parent.w*0.8f, parent.h*0.8f);
		xPos = 0.0f;//center
		yPos = 0.0f;
		//return 
		super.isHidden(set);
	}


	override void afterAdd()
	{
		if( parent !is null )
			wh(parent.w*0.8f, parent.h*0.8f);
		xPos = 0.0f;//center
		yPos = 0.0f;
	}

	FileChooser fileChooser;
}

class AboutDialog : SubWindow
{
	this(dchar[] set_name, dchar[] set_text)
	{
		super( set_name, WindowButtonType.DEFAULTS2, WindowHeaderType.SMALL, WindowHeaderType.SMALL, false );

		shadowType = ShadowType.ROUND;

		isClosingHides = true;
		
		//This will make it centered:
		side1.container.arrangeType = ArrangeType.LAYER;

		aboutLabel = new Label(set_text);
		aboutLabel.alignType = AlignType.CENTER;
		add(aboutLabel);
	}


	override protected void isHidden(bool set)
	{
		if( parent !is null )
			wh(parent.w*0.5f, parent.h*0.5f);
		xPos = 0.0f;//center
		yPos = 0.0f;
		//return
		super.isHidden(set);
	}


	override void afterAdd()
	{
		if( parent !is null )
			wh(parent.w*0.5f, parent.h*0.5f);
		xPos = 0.0f;//center
		yPos = 0.0f;
	}

	Label aboutLabel;
}









version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
