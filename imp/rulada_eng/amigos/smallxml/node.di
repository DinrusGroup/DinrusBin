/+
	SmallXML
	Copyright (C) 2008, 2009  Moritz Maxeiner
	Email: <moritzmaxeiner@gmail.com>

	This file (node.d) is part of the SmallXML package.

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

module amigos.smallxml.node;

private import std.string;

const uint SXML_VERSION = 2;

alias ubyte SXML_Type;
enum : SXML_Type
{
	SXML_PROCINST,
	SXML_ELEMENT,
	SXML_COMMENT
}

private
{
	char[] FailedACreate = "Failed to create new attribute";
	char[] FailedAdd = "Failed to add new attribute to node";
	char[] FailedRem = "Failed to remove attribute from node";
	char[] FailedSet = "Failed to set attribute";
	char[] FailedCAdd = "Failed to add new child to node";
	char[] FailedCRem = "Failed to remove child from node";
}

abstract class SXML_Node
{
	package
	{
		SXML_Node Parent;
		SXML_Type Type;
		SXML_Node[] Children;

		SXML_Attribute[] Attributes;
	}
	
	public
	{
		char[] Name;
	}

	this(SXML_Node p = null, char[] n = null)
	{
		Parent = p;
		Name = n;
	}
	
	void add(SXML_Attribute a)
	{
		assert(a !is null, format(FailedAdd, "  \"", Name, "\"; attribute not instantiated"));
		assert(hasAttribute(a.Type) == -1, format(FailedAdd, " \"", Name, "\"; attribute \"", a.Type, "\" is used already"));	
		
		Attributes ~= a;
	}
	
	SXML_Attribute addAttribute(char[] t = null, char[] v = null)
	{
		assert(t !is null, format(FailedAdd, "  \"", Name, "\"; no type specified"));
		assert(hasAttribute(t) == -1, format(FailedAdd, "  \"", Name, "\"; attribute \"", t, "\" is used already"));
		
		return (Attributes ~= new SXML_Attribute(t, v))[$-1];
	}
	
	void removeAttb(uint a)
	{
		assert(a < Attributes.length, format(FailedRem, "  \"", Name, "\"; index out of bound: ", a));
		Attributes = Attributes[0..a] ~ Attributes[a+1..$];
	}
	
	void removeAttb(char[] t)
	{
		int idx = hasAttribute(t);
		assert(idx, format(FailedRem, "  \"", Name, "\"; attribute  \"", t, "\" not found"));
		
		removeAttb(idx);
	}
	
	int hasAttribute(char[] t)
	{
		for(uint i = 0; i < Attributes.length; i++)
			if(Attributes[i].Type == t)
				return i;
		return -1;
	}
	
	char[] getAttribute(char[] t)
	{
		for(uint i = 0; i < Attributes.length; i++)
			if(Attributes[i].Type == t)
				return Attributes[i].Value;
		return null;
	}
	
	void setAttribute(char[] t = null, char[] v = null)
	{
		int h = hasAttribute(t);

		assert(h != -1, format(FailedSet, " \"", t, "\" for node \"", Name, "\"; no such attribute value specified"));
		assert(v !is null, format(FailedSet, " \"", t, "\" for node \"", Name, "\"; no value specified"));
		
		Attributes[h].Value = v;
	}
	
	void add(SXML_Node n = null)
	{
		assert(n !is null, format(FailedCAdd, "\"", Name, "\"; child not instantiated"));
		
		n.Parent = this;
		Children ~= n;
	}
	
	/+It's only meant for elemenents and not for processing intructions, though+/
	SXML_Element addChild(char[] n)
	{
		assert(n !is null, format(FailedCAdd, "  \"", Name, "\"; no name specified"));
		
		return cast(SXML_Element) (Children ~= new SXML_Element(this, n))[$-1];
	}
	
	void removeChild(uint c)
	{
		assert(c < Children.length, format(FailedCRem, "  \"", Name, "\"; index out of bound: ", c));
		Children = Children[0..c] ~ Children[c+1..$];
	}
}

final class SXML_ProcInst : SXML_Node
{
	this(SXML_Node p = null, char[] n = null)
	{
		super(p, n);
		Type = SXML_PROCINST;
	}
	
	void parse(char[] string)
	{
		int AttStart = find(string, " ");
		char[][] content;
		
		int i;
		if(AttStart != -1)
		{
			Name = string[0..AttStart];
			string = replace(string, "\" ", "\"\" ");
			content = split(string[AttStart+1..$], "\" ");
			i = 0;
		}
		else
		{
			content = split(string);
			Name = content[0];
			i = 1;
		}
		
		for(uint k = i; k < content.length; k++)
			if(find(content[k], "=") != -1)
			{
				char[] Border = "\"";
				if(find(content[k], "=\'") > 0)
					Border = "\'";
				addAttribute( content[k][0..find(content[k], "=")].dup, content[k][find(content[k], Border)+1..rfind(content[k], Border)].dup );
			}
	}
	
	char[] toString(uint Depth)
	{
		char[] String;
		
		for(uint i = 0; i < Depth; i++)
			String ~= "\t";
		
		String ~= "<?" ~ Name;
		
		for(uint i = 0; i < Attributes.length; i++)
			String ~= " " ~ Attributes[i].Type ~ "=\"" ~ Attributes[i].Value ~ "\"";
		
		String ~= "?>\n";
		
		return String;
	}
}

final class SXML_Element : SXML_Node
{
	private bool Empty;
	char[] Text;
	
	this(SXML_Node p = null, char[] n = null)
	{
		super(p, n);
		Type = SXML_ELEMENT;
	}
	
	int parse(char[] string)
	{
		int EndCipher = find(string, ">");
		
		if(EndCipher != -1)
		{	
			char[] Delimiter;
			int ret;
			
			if(string[EndCipher-1..EndCipher+1] != "/>")
			{
				Delimiter = ">";
				ret = -1;
			}
			else
			{
				Empty = true;
				Delimiter = "/>";
				ret = EndCipher+1;
			}
			
			char[][] content = split(string, Delimiter);
			int AttStart = find(content[0], " ");
	
			if(content.length > 1)
				Text = content[1];
	
			uint i;
			if(AttStart != -1)
			{
				Name = content[0][0..AttStart];
				content[0] = replace(content[0][AttStart+1..$], "\" ", "\"\" ");
				content = split(content[0], "\" ");
				i = 0;
			}
			else
			{
				content = split(content[0]);
				Name = content[0];
				i = 1;
			}
	
			for(uint k = i; k < content.length; k++)
			{
				if(find(content[k], "=") != -1)
				{
					char[] Border = "\"";
					if(find(content[k], "=\'") > 0)
						Border = "\'";
					addAttribute( content[k][0..find(content[k], "=")].dup, content[k][find(content[k], Border)+1..rfind(content[k], Border)].dup );
				}
			}
			
			return ret;
		}
		else
			throw new Exception("Failed to parse element string <\"" ~ string ~ "\" into a SXML_Element; element tag not closed");		
	}
	
	void cleanText()
	{
		char[] check = replace(this.Text, "\t", "");
		check = replace(check, " ", "");
		check = replace(check, "\n", "");

		if(check.length == 0)
			this.Text = null;
	}
	
	void cleanTexts()
	{
		this.cleanText();
		
		foreach(SXML_Node Child; Children)
			if(Child.Type == SXML_ELEMENT)
				(cast(SXML_Element) Child).cleanTexts();
		/+for(uint  i = 0; i < this.Children.length; i++)
			if(this.Children[i].Type == SXML_NodeTypes.Element)
				(cast(SXML_Element) this.Children[i]).cleanTexts();+/
	}
	
	char[] toString(uint Depth)
	{
		char[] String;
		
		for(uint i = 0; i < Depth; i++)
			String ~= "\t";
		
		String ~= "<" ~ Name;
			
		for(uint i = 0; i < Attributes.length; i++)
			String ~= " " ~ Attributes[i].Type ~ "=\"" ~ Attributes[i].Value ~ "\"";
		
		if(Empty)
		{
			String ~= "/>\n";
			return String;
		}
		else
		{
			String ~= ">" ~ Text;
			
			if(0 < Children.length)
			{
				String ~= "\n";
				
				foreach(SXML_Node Child; Children)
					switch(Child.Type)
					{
						case SXML_PROCINST:
							String ~= (cast(SXML_ProcInst) Child).toString(Depth+1);
							break;
						case SXML_ELEMENT:
							String ~= (cast(SXML_Element) Child).toString(Depth+1);
							break;
						case SXML_COMMENT:
							String ~= (cast(SXML_Comment) Child).toString(Depth+1);
							break;
					}
				for(uint i = 0; i < Depth; i++)
					String ~= "\t";
			}
			
			String ~= "</" ~ Name ~ ">\n";
		}
		
		return String;
	}
	
	SXML_Element getElement(char[] Name)
	{
		SXML_Element Element;
		
		for(size_t i = 0; i < this.Children.length; i++)
		{
			if(this.Children[i].Type == SXML_ELEMENT)
			{
				Element = cast(SXML_Element) this.Children[i];
				if(Element.Name == Name)
					return Element;
				
				Element = (cast (SXML_Element) this.Children[i]).getElement(Name);
				if(Element !is null)
					return Element;
			}
		}
		
		return null;
	}
	
	void getElements(char[] Name, ref SXML_Element[] List)
	{
		SXML_Element Element;
		
		for(size_t i = 0; i < this.Children.length; i++)
		{
			if(this.Children[i].Type == SXML_ELEMENT)
			{
				Element = cast(SXML_Element) this.Children[i];
				if(Element.Name == Name)
				{
					List ~= Element;
				}
				Element.getElements(Name, List);
			}
		}
	}
	
	SXML_Element getChild(char[] Name)
	{
		for(size_t i = 0; i < this.Children.length; i++)
		{
			if(this.Children[i].Type == SXML_ELEMENT)
				if((cast(SXML_Element) Children[i]).Name == Name)
					return cast(SXML_Element) Children[i];
		}
		return null;
	}
	
	SXML_Element[] getChildren(char[] Name)
	{
		SXML_Element[] List;
		for(size_t i = 0; i < this.Children.length; i++)
		{
			if(this.Children[i].Type == SXML_ELEMENT)
				if((cast(SXML_Element) Children[i]).Name == Name)
					List ~= cast(SXML_Element) Children[i];
		}
		return List;
	}
	
	bool isBool()
	{ return Text == "true" || Text == "false" || Text == "yes" || Text == "no"; }
	
	bool isInt()
	{ return isNumeric(Text) && find(Text, ".") == -1; }
	
	bool isFloat()
	{
		return isNumeric(Text) && find(Text, ".") != -1; }
	
	bool toBool()
	{ return Text == "true" || Text == "yes"; }
	
	int toInt()
	{ return cast(int) atoi(Text); }
	
	float toFloat()
	{ return cast(float) atof(Text); }
}

final class SXML_Comment : SXML_Node
{
	char[] Text;
	
	this(SXML_Element p = null, char[] t = null)
	{
		super(p, null);
		Type = SXML_COMMENT;
		Text = t;
	}
	
	char[] toString(uint Depth)
	{
		char[] String;
		
		for(uint i = 0; i < Depth; i++)
			String ~= "\t";
		
		String ~= "<!--" ~ Text ~ "-->\n";
		
		return String;
	}
}


final class SXML_Attribute
{
	char[] Type;
	char[] Value;
	
	union /+ Value +/
	{
		bool Bool;
		int Int;
		float Float;
	}
	
	this(char[] t = null, char[] v = null)
	{
		assert(t !is null, format(FailedACreate,  "; no type specified"));
		
		Type = t;
		Value = v;
		
		if(v !is null)
		{
			if (isBool())
				Bool = toBool();
			else if (isInt())
				Int = toInt();
			else if (isFloat())
				Float = toFloat();
		}
	}
	
	bool isBool()
	{ return Value == "true" || Value == "false" || Value == "yes" || Value == "no"; }
	
	bool isInt()
	{ return isNumeric(Value) && find(Value, ".") == -1; }
	
	bool isFloat()
	{ return isNumeric(Value) && find(Value, ".") != -1; }
	
	private:
		bool toBool()
		{ return Value == "true" || Value == "yes"; }
	
		int toInt()
		{ return cast(int) atoi(Value); }
	
		float toFloat()
		{ return cast(float) atof(Value); }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
