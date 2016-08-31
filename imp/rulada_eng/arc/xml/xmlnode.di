/******************************************************************************* 

	XML node class.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	
	XML node class. Basis of all XML loading and saving.


	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.xml.xmlnode;

import 	
	std.stream,
	std.regexp;

import 	
	arc.xml.error,
	arc.xml.xmlstream,
	arc.xml.misc;

/// XML Node Class 
class XmlNode
{
    char[] _name;
    char[][char[]] _attributes;
    XmlNode[]      _children;
    static RegExp  _attribRe;
    static RegExp  _attribSplitRe;

public:

    static this()
    {	// attributes regexp modified by Eric Poggel on 12-05-05 to allow for
		// dots, underscores, and other characters in attribute values
		// disallowed values are "<>%
        _attribRe = new RegExp("([a-z0-9]+)\\s*=\\s*\"([^\"^<^>^%]+)\"\\s*", "gim");
        _attribSplitRe = new RegExp("\"|=\"", "");
    }

	/// Allocate XML Node 
    this()
    {}

	/// Allocate XML Node and set name of XML node 
    this(char[] name)
    {
        _name = name;
    }

	/// Get name of XML node 
    char[] getName()
    {
        return _name;
    }

	/// Set name of XML node 
    void setName(char[] newName)
    {
        _name = newName;
    }

	/// return true if has attribute in XML node 
    bool hasAttribute(char[] name)
    {
        return (name in _attributes) !is null;
    }

	/// Get an attribute from XML node 
    char[] getAttribute(char[] name)
    {
        if (name in _attributes)
            return _attributes[name];
        else
            return null;
    }

	/// Get all attributes from XML node 
    char[][char[]] getAttributes()
    {	return _attributes;
    }

    /**
     * setAttribute, addChild, and addCdata all return a self reference.  This makes it
     * much easier to quickly dump a node to a document without having to assign a local
     * variable.
     *
     * This means you can do weird stuff like this:
     *
     * node.addChild(new XmlNode("mynode")
     *                   .setAttribute("x", "50")
     *                   .setAttribute("y", 42)
     *                   .setAttribute("label", "bob")
     *                   .addChild(
     *                       new XmlNode("blah")
     *                           .setAttribute("thingie", "weefun")
     *                           .addCdata("This is character data!")
     *                       )
     *                   );
     *
     * and get:
     *
     * <mynode x="50" y="42" label="bob">
     *     <blah thingie="weefun">
     *         This is character data!
     *     </blah>
     * </mynode>
     */
    XmlNode setAttribute(char[] name, char[] value)
    {
        _attributes[name] = value;
        return this;
    }

	/// Set attribute of XML node with int value which will convert to a string 
    XmlNode setAttribute(char[] name, int value)
    {
        return setAttribute(name, std.string.toString(value));
    }

	/// Get XML node children
    XmlNode[] getChildren()
    {
        return _children; // return a copy instead?
    }

	/// Add child to XML node 
    XmlNode addChild(XmlNode newNode)
    {
        _children ~= newNode;
        return this;
    }

    /// Add C-data, Also returns a self reference.
    XmlNode addCdata(char[] cdata)
    {
        addChild(new Cdata(cdata));
        return this;
    }

	/// Placeholder 
    bool    isCdata() { return false; }

	/// Placeholder 
	char[] getCdata() { return ""; }

	/// return true if it is a leaf node (has no children)
    bool    isLeaf()  { return _children.length == 0; }

	/// Write XML node to stream 
    void write(Stream dest)
    {
        write(dest, 0);
    }

	/// Read XML node from stream 
    void read(Stream src)
    {
        XmlStream xmlstream = new XmlStream(src);
        read(xmlstream);
        delete xmlstream;
    }

private:
    char[] asOpenTag()
    {
        char[] s = "<" ~ _name;

        if (_attributes.length > 0)
        {
            char[][] k = _attributes.keys;
            char[][] v = _attributes.values;

            for (int i = 0; i < _attributes.length; i++)
            {
                s ~= " " ~ k[i] ~ "=\"" ~ v[i] ~ "\"";
            }
        }

        if (_children.length == 0)
            s ~= " /"; // We want <blah /> if the node has no children.
        s ~= ">";

        return s;
    }

    char[] asCloseTag()
    {
        if (_children.length != 0)
            return "</" ~ _name ~ ">";
        else
            return ""; // don't need it.  Leaves close themselves via the <blah /> syntax.
    }

protected:
	/// write
    void write(Stream dest, int indentLevel)
    {
        char[] pad = new char[indentLevel];
        pad[] = ' ';
        dest.writeString(pad);
        dest.writeLine(asOpenTag());

        if (_children.length)
        {
            for (int i = 0; i < _children.length; i++)
            {
                _children[i].write(dest, indentLevel + 4); // TODO: make the indentation level configurable.
            }
            dest.writeString(pad);
            dest.writeLine(asCloseTag());
        }
    }

	/// parse node
    static XmlNode parseNode(XmlNode parent, char[] tok, XmlStream src)
    {
        char[][] parseAttributes(char[] tag)
        {
            char[][] result;

            int pos = std.string.find(tag, cast(char)' ');
            if (pos == -1) return result;

            char[][] matches = _attribRe.match(tag[pos..tag.length]);
            for (int i = 0; i < matches.length; i++)
            {
                // cheap hack.
                char[][] blah = _attribSplitRe.split(matches[i]);
                result ~= blah[0];
                result ~= blah[1];
            }

            return result;
        }

        XmlNode newNode = null;

        int pos = 2;
        while (pos < tok.length && tok[pos] != ' ' && tok[pos] != '/' && tok[pos] != '>')
            pos++;   // stop at a space, a slash, or the end bracket.

        if (isLetter(tok[1]))
        {
            newNode = new XmlNode(tok[1 .. pos]); // new node
            if (parent !is null)
                parent.addChild(newNode);

            // parse attributes
            char[][] attribs = parseAttributes(tok);

            for (int i = 0; i < attribs.length; i += 2)
                newNode.setAttribute(attribs[i], attribs[i + 1]);

            if (tok[tok.length - 2] != '/')     // matched tag
                newNode.read(src);
        }
        else
            // Invalid tag name
            throw new XmlError(src.lineNumber(), "Tags cannot start with " ~ tok);

        return newNode;
    }

	/// read 
    void read(XmlStream src)
    {
        while (true)
        {
            char[] tok = src.readNode();

            if (tok[0] == '<')
            {
                if (tok[1] != '/')
                    parseNode(this, tok, src);
                else
                {
                    if (tok[2 .. _name.length + 2] != _name)
                        throw new XmlError(src.lineNumber(), "</" ~ _name ~ "> or opening tag expected.  Got " ~ tok);
                    else
                    {
                        break;
                    }
                }

            }
            else
            {
                addCdata(std.string.strip(tok));
            }
        }
    }
}

/*** 
	Hack: DMD doesn't really like mutually interdependant classes
	split across multiple modules.  Cdata must be here.
*/
class Cdata : XmlNode
{
    char[] _cdata;
public:
	this(char[] cdata)
	{
		_cdata = decodeSpecialChars(cdata);
	}

	bit isCdata() { return true; }
	char[] getCdata() { return _cdata; }

	protected override void write(Stream dest, int indentLevel)
	{
		char[] pad = new char[indentLevel];
		pad[] = ' ';
		dest.writeString(pad);
		dest.writeLine(encodeSpecialChars(_cdata));
	}
}

/// Another hack: D doesn't seem to like monads used in conjunction with new.  This helps to remedy the problem.
final XmlNode newNode(char[] name)
{	return new XmlNode(name);
}

/// read document 
XmlNode readDocument(Stream src)
{
	XmlStream stream = new XmlStream(src);


	char[] tok = stream.readNode();
	if (tok.length >= 9 && tok[0 .. 9] == "<!DOCTYPE")
	{
		// TODO: actually do something with the DOCTYPE
		tok = stream.readNode();
	}

	XmlNode node = XmlNode.parseNode(null, tok, stream);

	delete stream;
	return node;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
