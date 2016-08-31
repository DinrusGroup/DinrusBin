/**
 * Обеспечивает основанную на стандарте поддержку обработки XML (Расширенного
 * Языка Разметки - РЯР).
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.xml.dom;

import os.win.base.core,
  os.win.base.string,
  os.win.com.core,
  os.win.xml.core,
  os.win.xml.msxml,
  std.stream,
  std.utf;

debug import std.io : writefln;

/**
 * Добавляет пространства имен в коллекции и обеспечивает управление
 масштабами.
 *
 * Примеры:
 * ---
 * scope mgr = new XmlNamespaceManager;
 * mgr.addNamespace("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
 * mgr.addNamespace("dc", "http://purl.org/dc/elements/1.1/");
 * mgr.addNamespace("rss", "http://purl.org/rss/1.0/");
 *
 * scope doc = new XmlDocument;
 * doc.load("http://del.icio.us/rss");
 * foreach (node; doc.documentElement.selectNodes("/rdf:RDF/rss:item", mgr)) {
 *   if (node !is null)
 *     writefln(node.text);
 * }
 * ---
 */
alias XmlNamespaceManager УпрПрострИмРЯР;
class XmlNamespaceManager {

  private IMXNamespaceManager nsmgrImpl_;

  this();
  /**
   * Добавить уканное пространство имен в коллекцию.
   * Параметры:
   *   prefix = _prefix, ассоциируемый с добавляемым пространством имен.
   *   uri = Добавляемое пространство имен.
   */
  void addNamespace(string prefix, string uri);
alias addNamespace добавитьПрострИм;
  /**
   * Получает значение, указывающее на наличие у предложенного _prefix
   пространства имен для текущего масштаба.
   * Параметры: prefix = _prefix искомого пространства имен.
   * Возвращает: true, если пространство определено; и false, если нет.
   */
  bool hasNamespace(string prefix);
  alias hasNamespace имеетПрострИм_ли;

  /**
   * Найти префикс с данным пространством имен.
   * Параметры: uri = Пространство имен для отыскания префикса.
   * Возвращает: Соответствующий префикс.
   */
  string lookupPrefix(string uri);
  alias lookupPrefix искатьПрефикс;

  /**
   * Находит пространство имен для указанного _prefix.
   * Параметры: prefix =  _prefix, пространство имен которого нужно выяснить.
   * Возвращает: Пространство имен префикса.
   */
  string lookupNamespace(string prefix) ;
  alias lookupNamespace искатьПрострИм;

  /**
   * Выталкивает масштаб пространства имен со стека.
   * Возвращает: true, если со стека сошли какие-то масштабы пространства имен; иначе - false.
   */
  bool popScope() ;
  alias popScope вытолкнутьМасштаб;

  /**
   * Вталкивает масштаб пространства имен на стек.
   */
  void pushScope() ;
  alias pushScope втолкнутьМасштаб;
  /**
   * Обеспечивает проходку в стиле foreach по сохраненных префиксам.
   */
  int opApply(int delegate(ref string) action) ;
  alias opApply опПрим;

  ~this() ;

}

package XmlNode getNodeShim(IXMLDOMNode node);

  bool parseXmlDeclaration(IXMLDOMNode node, out string xmlversion, out string encoding, out string standalone) ;

class XPathException : Exception {

  this(string message = null);

}

/**
 * Представляет упорядоченную коллекцию узлов. 
 */
 alias XmlNodeList СписокУзловРЯР;
abstract class XmlNodeList {

  /**
   * Получает узел по заданному _индексу.
   * Параметры: index = _индекс в списке узлов.
   * Возвращает: Узел в данной коллекции под данным индексом.
   */
  abstract XmlNode item(int index);

  /**
   * ditto
   */
  XmlNode opIndex(int i) ;

  /**
   * Gets the number of nodes in the collection.
   * Возвращает: The number of nodes.
   */
  abstract int size();

  /**
   * Provides foreach iteration over the collection of nodes.
   */
  abstract int opApply(int delegate(ref XmlNode) action);

  protected this() ;
}

private class XmlChildNodes : XmlNodeList {

  private IXMLDOMNodeList listImpl_;

  package this(IXMLDOMNodeList listImpl);

  ~this() ;

  override XmlNode item(int index) ;

  override int opApply(int delegate(ref XmlNode) action);
  
  override int size() ;

}

private class XPathNodeList : XmlNodeList {

  private IXMLDOMSelection iterator_;

  this(IXMLDOMSelection iterator);

  ~this() ;

  override XmlNode item(int index) ;
  override int size() ;

  override int opApply(int delegate(ref XmlNode) action);

}

/**
 * Provides a way to navigate XML data.
 */
abstract class XPathNavigator {

  /**
   * Determines whether the current node _matches the specified XPath expression.
   */
  bool matches(string xpath);
  /**
   * Selects a node set using the specified XPath expression.
   */
  XmlNodeList select(string xpath) ;
  /**
   * Selects all the ancestor nodes of the current node.
   */
  XmlNodeList selectAncestors() ;

  /**
   * Selects all the descendant nodes of the current node.
   */
  XmlNodeList selectDescendants() ;
  /**
   * Selects all the child nodes of the current node.
   */
  XmlNodeList selectChildren() ;
}

private class DocumentXPathNavigator : XPathNavigator {

  private XmlDocument document_;
  private XmlNode node_;

  this(XmlDocument document, XmlNode node);

  override bool matches(string xpath);
  
  XmlNodeList select(string xpath);

  private Exception xpathException(int hr);

}

/**
 * Represents a collection of nodes that can be accessed by name or index.
 */
class XmlNamedNodeMap {

  private IXMLDOMNamedNodeMap mapImpl_;

  /**
   * Retrieves the node specified by name.
   * Параметры: name = The qualified _name of the node to retrieve.
   * Возвращает: The node with the specified _name.
   */
  XmlNode getNamedItem(string name);
  /**
   * Retrieves the node with the matching _localName and _namespaceURI.
   * Параметры: 
   *   localName = The local name of the node to retrieve.
   *   namespaceURI = The namespace URI of the node to retrieve.
   * Возвращает: The node with the matching local name and namespace URI.
   */
  XmlNode getNamedItem(string localName, string namespaceURI);
  /**
   * Removes the node with the specified _name.
   * Параметры: name = The qualified _name of the node to remove.
   * Возвращает: The node removed.
   */
  XmlNode removeNamedItem(string name) ;

  /**
   * Removes the node with the matching _localName and _namespaceURI.
   * Параметры: 
   *   localName = The local name of the node to remove.
   *   namespaceURI = The namespace URI of the node to remove.
   * Возвращает: The node removed.
   */
  XmlNode removeNamedItem(string localName, string namespaceURI);
  /**
   * Adds a _node using its _name property.
   * Параметры: node = The _node to store.
   * Возвращает: The old _node.
   */
  XmlNode setNamedItem(XmlNode node) ;
  /**
   * Retrieves the node at the specified _index.
   * Параметры: index = The position of the node to retrieve.
   * Возвращает: The node at the specified _index.
   */
  XmlNode item(int index) ;

  /**
   * Gets the number of nodes.
   * Возвращает: The number of nodes.
   */
  int size() ;
  /**
   * Provides support for foreach iteration over the collection of nodes.
   */
  int opApply(int delegate(ref XmlNode) action);
  
  package this(XmlNode parent);
  
  package this(IXMLDOMNamedNodeMap mapImpl);
  
  ~this() ;

}

/**
 * Represents a collection of attributes that can be accessed by name or index.
 */
final class XmlAttributeCollection : XmlNamedNodeMap {

  /**
   * Gets the attribute at the specified _index.
   * Параметры: index = The _index of the attribute.
   * Возвращает: The attribute at the specified _index.
   */
  final XmlAttribute opIndex(int index);

  /**
   * Gets the attribute with the specified _name.
   * Параметры: name = The qualified _name of the attribute.
   * Возвращает: The attribute with the specified _name.
   */
  final XmlAttribute opIndex(string name) ;

  /**
   * Gets the attribute with the specified local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The attribute with the specified local name and namespace URI.
   */
  final XmlAttribute opIndex(string localName, string namespaceURI) ;
  
  package this(XmlNode parent);

}

string TypedNode(string type, string field = "typedNodeImpl_") {
  return 
    "private " ~ type ~ " " ~ field ~ ";\n"

    "package this(IXMLDOMNode nodeImpl) {\n"
    "  super(nodeImpl);\n"
    "  " ~ field ~ " = com_cast!(" ~ type ~ ")(nodeImpl);\n"
    "}\n"

    "~this() {\n"
    "  if (" ~ field ~ " !is null) {\n"
    "    tryRelease(" ~ field ~ ");\n"
    "    " ~ field ~ " = null;\n"
    "  }\n"
    "}";
}

/**
 * Represents a single node in the XML document.
 */
class XmlNode {

  private IXMLDOMNode nodeImpl_;

  /**
   * Creates a duplicate of this node.
   * Возвращает: The cloned node.
   */
  XmlNode clone() ;

  /**
   * Creates a duplicate of this node.
   * Параметры: deep = true to recursively clone the subtree under this node; false to clone only the node itself.
   * Возвращает: The cloned node.
   */
  XmlNode cloneNode(bool deep) ;

  /**
   * Adds the specified node to the end of the list of child nodes.
   * Параметры: newChild = The node to add.
   * Возвращает: The node added.
   */
  XmlNode appendChild(XmlNode newChild) ;

  /**
   * Inserts the specified node immediately before the specified reference node.
   * Параметры:
   *   newChild = The node to insert.
   *   refChild = The reference node. The newChild is placed before this node.
   * Возвращает: The inserted node.
   */
  XmlNode insertBefore(XmlNode newChild, XmlNode refChild);
  /**
   * Inserts the specified node immediately after the specified reference node.
   * Параметры:
   *   newChild = The node to insert.
   *   refChild = The reference node. The newChild is placed after this node.
   * Возвращает: The inserted node.
   */
  XmlNode insertAfter(XmlNode newChild, XmlNode refChild) ;
  /**
   * Replaces the oldChild node with the newChild node.
   * Параметры:
   *   newChild = The new node to put in the child list.
   *   oldChild = The node being replaced in the child list.
   * Возвращает: The replaced node.
   */
  XmlNode replaceChild(XmlNode newChild, XmlNode oldChild) ;
  /**
   * Removes the specified child node.
   * Параметры: oldChild = The node being removed.
   * Возвращает: The removed node.
   */
  XmlNode removeChild(XmlNode oldChild) ;
  /**
   * Removes all the child nodes.
   */
  void removeAll() ;
  /**
   * Creates an XPathNavigator for navigating this instance.
   */
  XPathNavigator createNavigator() ;

  /**
   * Selects the first node that matches the XPath expression.
   * Параметры: 
   *   xpath = The XPath expression.
   *   nsmgr = The namespace resolver to use.
   * Возвращает: The first XmlNode that matches the XPath query.
   */
  XmlNode selectSingleNode(string xpath, XmlNamespaceManager nsmgr = null) ;

  /**
   * Selects a list of nodes matching the XPath expression.
   * Параметры: 
   *   xpath = The XPath expression.
   *   nsmgr = The namespace resolver to use.
   * Возвращает: An XmlNodeList containing the nodes matching the XPath query.
   */
  XmlNodeList selectNodes(string xpath, XmlNamespaceManager nsmgr = null) ;

  /**
   * Gets the type of the current node.
   * Возвращает: One of the XmlNodeType values.
   */
  abstract XmlNodeType nodeType();

  /**
   * Gets the namespace _prefix of this node.
   * Возвращает: The namespace _prefix for this node. For example, prefix is 'bk' for the element &lt;bk:book&gt;.
   */
  string prefix() ;

  /**
   * Gets the local name of the node.
   * Возвращает: The name of the node with the prefix removed.
   */
  abstract string localName() ;

  /**
   * Gets the qualified _name of the node.
   * Возвращает: The qualified _name of the node.
   */
  abstract string name() ;

  /**
   * Gets the namespace URI of the node.
   * Возвращает: The namespace URI of the node.
   */
  string namespaceURI() ;

  /**
   * Gets or sets the values of the node and its child nodes.
   * Возвращает: The values of the node and its child nodes.
   */
  void text(string value) ;
  /**
   * ditto
   */
  string text() ;

  /**
   * Gets or sets the markup representing the child nodes.
   * Возвращает: The markup of the child nodes.
   */
  void xml(string value) ;
  /**
   * ditto
   */
  string xml() ;
  /**
   * Gets or sets the _value of this node.
   */
  void value(string value) ;

  /**
   * ditto
   */
  string value() ;

  /**
   * Gets a value indicating whether this node has any child nodes.
   * Возвращает: true if the node has child nodes; otherwise, false.
   */
  bool hasChildNodes() ;

  /**
   * Gets all the child nodes of the node.
   * Возвращает: An XmlNodeList containing all the child nodes of the node.
   */
  XmlNodeList childNodes() ;

  /** 
   * Gets the first child of the node.
   * Возвращает: The first child of the node. If there is no such node, null is returned.
   */
  XmlNode firstChild() ;
  /**
   * Gets the last child of the node.
   * Возвращает: The last child of the node. If there is no such node, null is returned.
   */
  XmlNode lastChild() ;

  /**
   * Gets the node immediately preceding this node.
   * Возвращает: The preceding XmlNode. If there is no such node, null is returned.
   */
  XmlNode previousSibling() ;
  /**
   * Gets the node immediately following this node.
   * Возвращает: The following XmlNode. If there is no such node, null is returned.
   */
  XmlNode nextSibling() ;

  /**
   * Gets the parent node of this node.
   * Возвращает: The XmlNode that is the parent of this node.
   */
  XmlNode parentNode() ;

  /**
   * Gets the XmlDocument to which this node belongs.
   * Возвращает: The XmlDocument to which this node belongs.
   */
  XmlDocument ownerDocument();
  /**
   * Gets an XmlAttributeCollection containing the _attributes of this node.
   * Возвращает: An XmlAttributeCollection containing the _attributes of this node.
   */
  XmlAttributeCollection attributes() ;

  /**
   * Provides support for foreach iteration over the nodes.
   */
  final int opApply(int delegate(ref XmlNode) action) ;

  package this(IXMLDOMNode nodeImpl) ;

  ~this() ;

  package IXMLDOMNode impl() ;
  
  private static string constructQName(string prefix, string localName);
  

  private static void splitName(string name, out string prefix, out string localName) ;
}
/**
 * Represents an attribute.
 */
class XmlAttribute : XmlNode {

  mixin(TypedNode("IXMLDOMAttribute", "attributeImpl_"));

  override XmlNodeType nodeType();
  
  override string localName() ;

  override string name() ;

  override string namespaceURI() ;
  
  override void value(string value);

  override string value() ;

  override XmlNode parentNode() ;

  XmlElement ownerElement() ;
  
  /**
   * Gets a value indicating whether the attribute was explicitly set.
   * Возвращает: true if the attribute was explicitly set; otherwise, false.
   */
  bool specified() ;

}

/**
 * Represents a node with child nodes immediately before and after this node.
 */
abstract class XmlLinkedNode : XmlNode {

  override XmlNode previousSibling() ;
  
  override XmlNode nextSibling() ;

  package this(IXMLDOMNode nodeImpl) ;

}

/**
 * Provides text manipulation methods.
 */
abstract class XmlCharacterData : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMCharacterData"));

  /**
   * Appends the specified string to the end of the character data.
   * Параметры: strData = The string to append to the existing string.
   */
  void appendData(string strData) ;
  /**
   * Inserts the specified string at the specified offset.
   * Параметры:
   *   offset = The position within the string to insert the specified string data.
   *   strData = The string data that is to be inserted into the existing string.
   */
  void insertData(int offset, string strData) ;
  
  /**
   * Replaces the specified number of characters starting at the specified offset with the specified string.
   * Параметры:
   *   offset = The position within the string to start replacing.
   *   count = The number of characters to replace.
   *   strData = The new data that replaces the old data.
   */
  void replaceData(int offset, int count, string strData) ;
  /**
   * Removes a range of characters from the string data.
   * Параметры:
   *   offset = The position within the string to start deleting.
   *   count = The number of characters to delete.
   */
  void deleteData(int offset, int count);

  /**
   * Retrieves a _substring of the full string from the specified range.
   * Параметры:
   *   offset = The position within the string to start retrieving.
   *   count = The number of characters to retrieve.
   */
  string substring(int offset, int count) ;

  /**
   * Gets the _length of the data.
   * Возвращает: The _length of the string data.
   */
  int length();

  /**
   * Gets or sets the _data of the node.
   * Возвращает: The _data of the node.
   */
  void data(string value);

  /**
   * ditto
   */
  string data();
  
  override void value(string value);

  override string value() ;

}

/**
 * Represents a CDATA section.
 */
class XmlCDataSection : XmlCharacterData {

  override XmlNodeType nodeType();
  
  override string localName();
  
  override string name() ;
  
  package this(IXMLDOMNode nodeImpl) ;

}

/**
 * Represents the content of an XML comment.
 */
class XmlComment : XmlCharacterData {

  override XmlNodeType nodeType() ;

  override string localName() ;
  override string name() ;
  package this(IXMLDOMNode nodeImpl) ;

}

/**
 * Represents the text content of an element or attribute.
 */
class XmlText : XmlCharacterData {

  mixin(TypedNode("IXMLDOMText"));

  override XmlNodeType nodeType();
  override string localName() ;
  override string name() ;

  /**
   * Splits the node into two nodes at the specified _offset, keeping both in the tree as siblings.
   * Параметры: offset = The position at which to split the node.
   * Возвращает: The new node.
   */
  XmlText splitText(int offset) ;

}

/**
 * Represents an entity declaration, such as &lt;!ENTITY...&gt;.
 */
class XmlEntity : XmlNode {

  mixin(TypedNode("IXMLDOMEntity"));

  override XmlNodeType nodeType() ;

  override string name();

  override string localName() ;
  override void text(string value) ;

  override string text() ;

  override void xml(string value);
  override string xml() ;

  /**
   * Gets the value of the identifier on the entity declaration.
   * Возвращает: The identifier on the entity.
   */
  final string publicId();

  /**
   * Gets the value of the system identifier on the entity declaration.
   * Возвращает: The system identifier on the entity.
   */
  final string systemId();

  /**
   * Gets the name of the NDATA attribute on the entity declaration.
   * Возвращает: The name of the NDATA attribute.
   */
  final string notationName() ;
}

/**
 * Represents an entity reference node.
 */
class XmlEntityReference : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMEntityReference"));

  override XmlNodeType nodeType() ;
  override string name() ;
  override string localName() ;

  override void value(string value) ;

  override string value() ;

}

/**
 * Represents a notation declaration such as &lt;!NOTATION...&gt;.
 */
class XmlNotation : XmlNode {

  mixin(TypedNode("IXMLDOMNotation"));

  override XmlNodeType nodeType();

  override string name() ;

  override string localName();

}

/**
 * Represents the document type declaration.
 */
class XmlDocumentType : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMDocumentType"));

  override XmlNodeType nodeType() ;
  override string name() ;

  override string localName() ;

  /**
   * Gets the collection of XmlEntity nodes declared in the document type declaration.
   * Возвращает: An XmlNamedNodeMap containing the XmlEntity nodes.
   */
  final XmlNamedNodeMap entities() ;

  /**
   * Gets the collection of XmlNotation nodes present in the document type declaration.
   * Возвращает: An XmlNamedNodeMap containing the XmlNotation nodes.
   */
  final XmlNamedNodeMap notations() ;

}

/**
 * Represents a lightweight object useful for tree insert operations.
 */
class XmlDocumentFragment : XmlNode {

  mixin(TypedNode("IXMLDOMDocumentFragment"));

  override XmlNodeType nodeType() ;
  override string name() ;

  override string localName();
  override XmlNode parentNode();
  override XmlDocument ownerDocument();

}

/** 
 * Represents an element.
 */
class XmlElement : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMElement", "elementImpl_"));

  /**
   * Returns the value for the attribute with the specified _name.
   * Параметры: name = The qualified _name of the attribute to retrieve.
   * Возвращает: The value of the specified attribute.
   */
  string getAttribute(string name) ;

  /**
   * Returns the value for the attribute with the specified local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute to retrieve.
   *   namespaceURI = The namespace URI of the attribute to retrieve.
   * Возвращает: The value of the specified attribute.
   */
  string getAttribute(string localName, string namespaceURI) ;

  /**
   * Returns the attribute with the specified _name.
   * Параметры: name = The qualified _name of the attribute to retrieve.
   * Возвращает: The matching XmlAttribute.
   */
  XmlAttribute getAttributeNode(string name);
  /**
   * Returns the attribute with the specified local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute to retrieve.
   *   namespaceURI = The namespace URI of the attribute to retrieve.
   * Возвращает: The matching XmlAttribute.
   */
  XmlAttribute getAttributeNode(string localName, string namespaceURI) ;

  /**
   * Determines whether the node has an attribute with the specified _name.
   * Параметры: name = The qualified _name of the attribute to find.
   * Возвращает: true if the node has the specified attribute; otherwise, false.
   */
  bool hasAttribute(string name) ;

  /**
   * Determines whether the node has an attribute with the specified local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute to find.
   *   namespaceURI = The namespace URI of the attribute to find.
   * Возвращает: true if the node has the specified attribute; otherwise, false.
   */
  bool hasAttribute(string localName, string namespaceURI) ;

  /**
   * Sets the _value of the attribute with the specified _name.
   * Параметры:
   *   name = The qualified _name of the attribute to create or alter.
   *   value = The _value to set for the attribute.
   */
  void setAttribute(string name, string value) ;

  /**
   * Adds the specified attribute.
   * Параметры: newAttr = The attribute to add to the attribute collection for this element.
   * Возвращает: If the attribute replaces an existing attribute with the same name, the old attribute is returned; otherwise, null is returned.
   */
  XmlAttribute setAttributeNode(XmlAttribute newAttr) ;

  /**
   * Removes an attribute by _name.
   * Параметры: name = The qualified _name of the attribute to remove.
   */
  void removeAttribute(string name) ;

  /**
   * Removes an attribute with the specified local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute to remove.
   *   namespaceURI = The namespace URI of the attribute to remove.
   */
  void removeAttribute(string localName, string namespaceURI);

  /**
   * Removes the specified attribute.
   * Параметры: oldAttr = The attribute to remove.
   * Возвращает: The removed attribute or null if oldAttr is not an attribute of the element.
   */
  XmlAttribute removeAttributeNode(XmlAttribute oldAttr);
  /**
   * Removes the attribute specified by the local name and namespace URI.
   * Параметры: 
   *   localName = The local name of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The removed attribute.
   */
  XmlAttribute removeAttributeNode(string localName, string namespaceURI) ;

  /**
   * Collapses all adjacent XmlText nodes in the sub-tree.
   */
  void normalize() ;
  /**
   * Returns an XmlNodeList containing the descendant elements with the specified _name.
   * Параметры: name = The qualified _name tag to match.
   * Возвращает: An XmlNodeList containing a list of matching nodes.
   */
  XmlNodeList getElementsByTagName(string name) ;

  override XmlAttributeCollection attributes() ;
  /**
   * Gets a value indicating whether the node has any attributes.
   * Возвращает: true if the node has attributes; otherwise, false.
   */
  bool hasAttributes();
  override XmlNodeType nodeType();
  override string localName();
  override string name() ;
  override string namespaceURI() ;

}

/**
 * Represents a processing instruction.
 */
class XmlProcessingInstruction : XmlLinkedNode {

  mixin(TypedNode("IXMLDOMProcessingInstruction"));

  override XmlNodeType nodeType();
  override string name() ;
  override string localName() ;

}

/**
 * Represents the XML declaration node.
 */
class XmlDeclaration : XmlLinkedNode {

  private const string VERSION = "1.0";

  mixin(TypedNode("IXMLDOMProcessingInstruction"));
  private string encoding_;
  private string standalone_;

  override XmlNodeType nodeType();
  override string name() ;

  override string localName() ;

  final void value(string value);

  override string value();

  /**
   * Gets or sets the _encoding level of the XML document.
   * Возвращает: The character _encoding name.
   */
  final void encoding(string value) ;

  /**
   * ditto
   */
  final string encoding() ;

  /**
   * Gets or sets the _value of the _standalone attribute.
   * Возвращает: Valid values are "yes" if all entity declarations are contained within the document or "no" if an external DTD is required.
   */
  final void standalone(string value) ;
  /**
   * ditto
   */
  final string standalone() ;

  /**
   * Gets the XML version of the document.
   */
  final string xmlversion();

  package this(string xmlversion, string encoding, string standalone, IXMLDOMNode nodeImpl);

}

/**
 * Provides methods that are independent of a particular instance of the Document Object Model.
 */
class XmlImplementation {

  private IXMLDOMImplementation impl_;

  /**
   * Tests if the specified feature is supported.
   * Параметры: 
   *   strFeature = The package name of the feature to test.
   *   strVersion = The version number of the package name to test.
   * Возвращает: true if the feature is implemented in the specified version; otherwise, false.
   */
  final bool hasFeature(string strFeature, string strVersion) ;

  private this(IXMLDOMImplementation impl) ;

  ~this() ;
}

/**
 * Represents an XML document.
 */
class XmlDocument : XmlNode {

  mixin(TypedNode("IXMLDOMDocument2", "docImpl_"));
  private short msxmlVersion_;

  /**
   * Initializes a new instance.
   */
  this() ;
  /**
   * Creates an XPathNavigator for navigating this instance.
   */
  override XPathNavigator createNavigator() ;

  /**
   * Creates an XmlNode with the specified _type, _name and _namespaceURI.
   * Параметры:
   *   type = The _type of the new node.
   *   name = The qualified _name of the new node.
   *   namespaceURI = The namespace URI of the new node.
   * Возвращает: The new XmlNode.
   */
  XmlNode createNode(XmlNodeType type, string name, string namespaceURI) ;

  /**
   * Creates an XmlNode with the specified _type, _prefix, _name and _namespaceURI.
   * Параметры:
   *   type = The _type of the new node.
   *   prefix = The _prefix of the new node.
   *   name = The local _name of the new node.
   *   namespaceURI = The namespace URI of the new node.
   * Возвращает: The new XmlNode.
   */
  XmlNode createNode(XmlNodeType type, string prefix, string name, string namespaceURI);
  /**
   * Creates an XmlElement with the specified _name.
   * Параметры: name = The qualified _name of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(string name) ;
  /**
   * Creates an XmlElement with the specified name and _namespaceURI.
   * Параметры:
   *   qualifiedName = The qualified name of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(string qualifiedName, string namespaceURI) ;

  /**
   * Creates an XmlElement with the specified _prefix, localName and _namespaceURI.
   * Параметры:
   *   prefix = The _prefix of the element.
   *   localName = The local name of the element.
   *   namespaceURI = The namespace URI of the element.
   * Возвращает: The new XmlElement.
   */
  XmlElement createElement(string prefix, string localName, string namespaceURI) ;
  /**
   * Creates an XmlAttribute with the specified _name.
   * Параметры: name = The qualified _name of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(string name) ;

  /**
   * Creates an XmlAttribute with the specified name and _namespaceURI.
   * Параметры:
   *   qualifiedName = The qualified name of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(string qualifiedName, string namespaceURI) ;

  /**
   * Creates an XmlAttribute with the specified _prefix, localName and _namespaceURI.
   * Параметры:
   *   prefix = The _prefix of the attribute.
   *   localName = The local name of the attribute.
   *   namespaceURI = The namespace URI of the attribute.
   * Возвращает: The new XmlAttribute.
   */
  XmlAttribute createAttribute(string prefix, string localName, string namespaceURI);
  /**
   * Creates an XmlCDataSection node with the specified _data.
   * Параметры: text = The _data for the node.
   * Возвращает: The new XmlCDataSection node.
   */
  XmlCDataSection createCDataSection(string data);

  /**
   * Creates an XmlComment node with the specified _data.
   * Параметры: text = The _data for the node.
   * Возвращает: The new XmlComment node.
   */
  XmlComment createComment(string data) ;
  /**
   * Creates an XmlText node with the specified _text.
   * Параметры: text = The _text for the node.
   * Возвращает: The new XmlText node.
   */
  XmlText createTextNode(string text);

  /**
   * Creates an XmlProcessingInstruction node with the specified name and _data.
   * Параметры:
   *   target = the name of the processing instruction.
   *   data = The _data for the processing instruction.
   * Возвращает: The new XmlProcessingInstruction node.
   */
  XmlProcessingInstruction createProcessingInstruction(string target, string data);
  /**
   * Create an XmlDeclaration node with the specified values.
   * Параметры:
   *   xmlversion = The version must be "1.0".
   *   encoding = The value of the _encoding attribute.
   *   standalone = The value must be either "yes" or "no".
   * Возвращает: The new XmlDeclaration node.
   */
  XmlDeclaration createXmlDeclaration(string xmlversion, string encoding, string standalone);

  /**
   * Creates an XmlEntityReference with the specified _name.
   * Параметры: The _name of the entity reference.
   * Возвращает: The new XmlEntityReference.
   */
  XmlEntityReference createEntityReference(string name) ;

  /**
   * Creates an XmlDocumentFragment.
   * Возвращает: The new XmlDocumentFragment.
   */
  XmlDocumentFragment createDocumentFragment() ;
  /**
   * Loads the XML document from the specified URL.
   * Параметры: fileName = URL for the file containing the XML document to _load. The URL can be either a local file or a web address.
   * Выводит исключение: XmlException if there is a _load or parse error in the XML.
   */
  void load(string fileName);
  /**
   * Loads the XML document from the specified stream.
   * Параметры: input = The stream containing the XML document to _load.
   * Выводит исключение: XmlException if there is a _load or parse error in the XML.
   */
  void load(Stream input);

  /**
   * Loads the XML document from the specified string.
   * Параметры: xml = The string containing the XML document to load.
   * Выводит исключение: XmlException if there is a _load or parse error in the XML.
   */
  void loadXml(string xml);

  /**
   * Saves the XML document to the specified file.
   * Параметры: fileName = The location of the file where you want to _save the document.
   * Выводит исключение: XmlException if there is no document element.
   */
  void save(string fileName);
  /**
   * Saves the XML document to the specified stream.
   * Параметры: output = The stream to which you want to _save.
   */
  void save(Stream output) ;

  /**
   * Gets the XmlElement with the specified ID.
   * Параметры: elementId = The attribute ID to match.
   * Возвращает: The XmlElement with the matching ID.
   */
  XmlElement getElementByTagId(string elementId);

  /** 
   * Gets the root element for the document.
   * Возвращает: The XmlElement representing the root of the XML document tree. If no root exists, null is returned.
   */
  XmlElement documentElement() ;

  /**
   * Gets the type of the current node.
   * Возвращает: For XmlDocument nodes, the value is XmlNodeType.Document.
   */
  override XmlNodeType nodeType();

  /**
   * Gets the locale name of the node.
   * Возвращает: For XmlDocument nodes, the local name is #document.
   */
  override string localName() ;
  /**
   * Gets the qualified _name of the node.
   * Возвращает: For XmlDocument nodes, the _name is #document.
   */
  override string name() ;
  /**
   * Gets the parent node.
   * Возвращает: For XmlDocument nodes, null is returned.
   */
  override XmlNode parentNode();

  /**
   * Gets the XmlDocument to which the current node belongs.
   * Возвращает: For XmlDocument nodes, null is returned.
   */
  override XmlDocument ownerDocument();

  /**
   * Gets or sets the markup representing the children of this node.
   * Возвращает: The markup of the children of this node.
   */
  override void xml(string value);
  /**
   * ditto
   */
  override string xml() ;

  /**
   * Gets or sets a _value indicating whether to preserve white space in element content.
   * Параметры: value = true to preserve white space; otherwise, false.
   */
  final void preserveWhitespace(bool value);
  /**
   * ditto
   */
  final bool preserveWhitespace() ;

  protected XPathNavigator createNavigator(XmlNode node) ;

  private void parsingException() ;
}
