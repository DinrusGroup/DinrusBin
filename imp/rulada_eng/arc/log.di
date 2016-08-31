/******************************************************************************* 

    Logger allows user to log data into a stdout, a text file, or an XML file.  

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
        The logger is a class that can store and then re-direct logging 
	output to the desired file format. 

    Examples:
    --------------------
    import arc.log; 

    int main() 
    {
        arc.log.open("stdout/file.txt/file.xml"); 

        arc.log.write("filename", "functionName", "errorLevel (info, warn, error), "message"); 

        arc.log.close(); 
        
        return 0;
    }
    --------------------

*******************************************************************************/

module arc.log; 

import 	
	arc.text.format, 
	arc.input,
	arc.xml.xml,
	arc.types; 

import 
	std.utf, 
	std.string, 
	std.stream; 

// this will be removed when full writef-->log transition is complete
public import std.io; 

// Log will have 4 levels: Info, Warning, Error, or Fault 
// Log will also need to know the filename and function name that the error came from
// Log will be stored as an array of LogMessage's, these lines will be sorted and outputed to 
// 	whichever location at program exit 
public
{
	/// initialization stub
	void open() {}
	/// deinitialization stub 
	void close() {}
	
	/// save log contents into a text file 
	void toTXT(char[] fileName)
	{
		// open file for writing
		scope File s = new File(fileName, FileMode.Out); 

		// stream it to the file
		foreach(LogMessage m; lines)
			m.stream(s); 
	}

	/// save log contents to XML file 
	void toXML(char[] fileName)
	{
		// Create XML structure with file to write to 
		scope XmlNode xml = new XmlNode("log"); 
		scope File s = new File(fileName, FileMode.Out); 

		// fill the XML structure with the log data 
		foreach(LogMessage m; lines)
			m.xml(xml); 

		// write XML data to stream 
		xml.write(s);
	}

	/// Write a message to the log 
	void write(char[] filename, char[] functionName, char[] errorLevel, ...)
	in 
	{
		// force program to quit if 
		if (errorLevel != "info" && 
			errorLevel != "warn" && 
			errorLevel != "error")
		{
			// print to log the reason to quit
			lines.length = lines.length+1; 
			lines[lines.length-1] = LogMessage("log", "write", "error", "Error Level " ~ errorLevel ~ " is invalid"); 

			// force quit 
			arc.input.quit(); 
		}
	}
	body 
	{
		// write the line into our logging system 
		lines.length = lines.length+1; 
		lines[lines.length-1] = LogMessage(filename, functionName, errorLevel, toUTF8(formatString(_arguments, _argptr))); 

		// force program to quit on errors 
		if (errorLevel == "error")
			arc.input.quit(); 
	}

	/// print last message to the console 
	void print()
	{
		writefln(lines[lines.length-1].toString);
	}
}

private 
{
	struct LogMessage
	{
		static LogMessage opCall(char[] file, char[] func, char[] err, char[] msg)
		{
			LogMessage m;
			m.filename = file;
			m.functionName = func; 
			m.errorLevel = err; 
			m.message = msg; 
			return m;
		}

		// convert log message into a string 
		char[] toString()
		{
			char[] retStr = "(" ~ errorLevel ~ ") | in file " ~ filename ~ ".d, function" ~ functionName ~ " - " ~ message ~ "\n";
			return retStr; 
		}

		// write log message to filestream 
		void stream(Stream s)
		{
			char[] streamedText = toString(); 

			s.writeLine(streamedText); 
		}

		// write log to XML file 
		void xml(XmlNode xml)
		{
			// Create new XML child node with given log data 
			XmlNode child = new XmlNode("message"); 
			child.setAttribute("errorLevel", errorLevel);
			child.setAttribute("fileName", filename ~ ".d");
			child.setAttribute("functionName", functionName ~ "()");
			child.addCdata(message);

			// add it to the XML node 
			xml.addChild(child); 
		}
			
		char[] filename; 
		char[] functionName;
		char[] errorLevel; 
		char[] message;
	}

	LogMessage[] lines; 
	char[] outputType;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
