/+
	SmallXML
	Copyright (C) 2008, 2009  Moritz Maxeiner
	Email: <moritzmaxeiner@gmail.com>

	This file (buffer.d) is part of the SmallXML package.

	SmallXML is distributed as free software: you can redistribute it
	and/or modify it under the terms of the GNU General Public License
	version 3, as published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public License
	version 3 along with this program. If not, see
	http://www.gnu.org/licenses/ .
+/

module amigos.smallxml.buffer;

private
{
	import std.string;
	import std.stdio;
	
	import amigos.smallxml.node;
}

class SXML_Buffer
{
	package
	{
		SXML_ProcInst StartInst;
		SXML_Element RootElement;
	
		SXML_Element CurrentElement;
	
		this() {}
	}
	
	this(char[] buf)
	{
		if(buf !is null)
		{
			try
				parse(buf.dup);
			catch(Exception e)
				throw new Exception("Failed to parse new SXML_Buffer: \n" ~ e.msg);
			RootElement.cleanTexts();
		}
		else
			throw new Exception("Failed to create SXML_Buffer: no input string");
	}
  
	void parse(char[] buf)
	{
		uint i = 1;
		bool Finished;
	
		/+ Split the buffer into chunks beginning with "<" +/
		char[][] chunks = split(buf, "<");
		
		/+ Try to get a start processing instruction +/
		if(1 < chunks.length && chunks[i][0..4] == "?xml")
		{
			StartInst = new SXML_ProcInst;
			
			int EndCipher = find(chunks[i], ">");
			if(EndCipher != -1)
				StartInst.parse(chunks[i][1..EndCipher-1]);
			else
				throw new Exception("Failed to parse the current buffer; start processing instruction not closed");
			i++;
		}
		
		/+ Get the root element +/
		if(0 < chunks.length-i)
		{
			RootElement = new SXML_Element;
			RootElement.parse(chunks[i]);
			CurrentElement = RootElement;
			i++;
		}
		else
			throw new Exception("Failed to parse the current buffer; no root element found");
			
		/+ Get all other nodes +/
		while(!Finished && i < chunks.length)
		{
			switch(chunks[i][0])
			{
				case '!':
					SXML_Comment newComment = new SXML_Comment(CurrentElement);
					CurrentElement.add(newComment);
					
					int EndCipher = find(chunks[i], ">");
					if(EndCipher != -1)
					{
						if(chunks[i][1..3] == "--")
							if(chunks[i][EndCipher-2..EndCipher] == "--")
								newComment.Text = chunks[i][3..EndCipher-2].dup;
							else
								throw new Exception("Failed to parse the current buffer; comment in element string <" ~ chunks[i] ~ " is not declared right");
						else
							throw new Exception("Failed to parse the current buffer; comment in element string <" ~ chunks[i] ~ " is not declared right");
					}
					else
						throw new Exception("Failed to parse the current buffer; comment in element string <" ~ chunks[i] ~ " was not closed");
					break;
				case '?':
					SXML_ProcInst newInst = new SXML_ProcInst(CurrentElement);
					
					int EndCipher = find(chunks[i], ">");
					if(EndCipher != -1)
					{
						newInst.parse(chunks[i][1..EndCipher-1]);
						CurrentElement.add(newInst);
					}
					else
						throw new Exception("Failed to parse the current buffer; processing instruction in element string <" ~ chunks[i] ~ " was not closed");
					break;
				case '/':
					char[] CloseName = chunks[i][1..find(chunks[i], ">")].dup;
					char[] ExtraText = chunks[i][find(chunks[i], ">")+1..$].dup;
					
					if(CloseName == CurrentElement.Name)
					{
						if(CurrentElement !is RootElement)
						{
							CurrentElement = cast(SXML_Element) CurrentElement.Parent;
							CurrentElement.Text ~= ExtraText;
						}
						else
							Finished = true;
					}
					else
						throw new Exception("Failed to close element " ~ CloseName ~ "; element " ~ CurrentElement.Name ~ " has to be closed first");
					break;
				default:
					SXML_Element newElement = new SXML_Element(CurrentElement);
					CurrentElement.add(newElement);
					
					int empty = newElement.parse(chunks[i]);
					if(empty == -1)
						CurrentElement = newElement;
					else
						CurrentElement.Text ~= chunks[i][empty..$].dup;
					break;
			}
			i++;
		}
		
		if(!Finished || CurrentElement !is RootElement)
		{
			StartInst = null;
			RootElement = null;
			CurrentElement = null;
			
			throw new Exception("Failed to parse the current buffer; root element was not closed");
		}
		
		//XMLFile.close();
	}
	
	char[] toString()
	{
		if(StartInst !is null && RootElement !is null)
			return StartInst.toString(0) ~ RootElement.toString(0);
		else if(RootElement !is null)
			return RootElement.toString(0);
		else
			throw new Exception("Failed to convert the current buffer into string; root element does not exist");
	}
	
	SXML_Element getRoot()
	{ return RootElement; }
	
	SXML_Element getElement(char[] Name)
	{
		CurrentElement = RootElement;
		
		char[][] tree = split(Name, "/");
		
		if(tree.length == 1)
		{
			if(CurrentElement.Name == Name)
				return CurrentElement;
			else
				return CurrentElement.getElement(Name);
		}
		else
		{
			SXML_Element[] List;
			tree = tree.reverse;
			
			CurrentElement.getElements(tree[0], List);
			
			for(uint i = 0; i < List.length; i++)
			{
				CurrentElement = List[i];
				uint k = 1;
				
				while(k < tree.length)
				{
					
					if( (!(CurrentElement.Parent is null)) && ( (CurrentElement.Parent.Name == tree[k]) || ("*" == tree[k]) ) )
					{
						CurrentElement = cast(SXML_Element) CurrentElement.Parent;
						k++;
					}
					else
					{
						CurrentElement = null;
						break;
					}
				}
				
				if(CurrentElement !is null)
					return List[i];
			}
			
			return null;
		}
	}
	
	SXML_Element[] getElements(char[] Name)
	{
		CurrentElement = RootElement;
		SXML_Element[] List;
		SXML_Element[] TreeList;
		
		char[][] tree = split(Name, "/");
		
		if(tree.length == 1)
		{
			if(CurrentElement.Name == Name)
				List ~= CurrentElement;
		
			CurrentElement.getElements(Name, List);
			
			return List;
		}
		else
		{
			tree = tree.reverse;
			
			CurrentElement.getElements(tree[0], List);
			
			for(size_t i = 0; i < List.length; i++)
			{
				CurrentElement = List[i];
				size_t k = 1;
				
				while(k < tree.length)
					if(CurrentElement.Parent !is null && (CurrentElement.Parent.Name == tree[k] || "*" == tree[k]) )
					{
						CurrentElement = cast(SXML_Element) CurrentElement.Parent;
						k++;
					}
					else
					{
						CurrentElement = null;
						break;
					}
				
				if(CurrentElement !is null)
					TreeList ~= List[i];
			}
			
			if(TreeList.length > 0)
				return TreeList;
			else
				return null;
		}
	}
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
