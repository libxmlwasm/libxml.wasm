// #include <cstring>
#include <fstream>
#include <iostream>
#include <vector>
#include <libxml/HTMLparser.h>
#include <libxml/xmlreader.h>
#include <libxml/xpath.h>
#include <emscripten/bind.h>

using namespace emscripten;
using namespace std;

class Node
{
public:
  Node(xmlNodePtr node) : node(node)
  {
  }
  ~Node()
  {
  }
  string getContent() const
  {
    xmlChar *content = xmlNodeGetContent(node);
    string contentStr((char *)content);
    xmlFree(content);
    return contentStr;
  }

  string getName() const
  {
    return string((char *)node->name);
  }

  string toString() const
  {
    xmlBufferPtr buf = xmlBufferCreate();
    xmlNodeDump(buf, node->doc, node, 0, 1);
    string nodeStr((char *)buf->content);
    xmlBufferFree(buf);
    return nodeStr;
  }

  emscripten::val getAttr() const
  {
    xmlAttr *attr = node->properties;
    emscripten::val result = emscripten::val::object();
    while (attr)
    {
      string key((char *)attr->name);
      string value((char *)attr->children->content);
      result.set(key, value);
      attr = attr->next;
    }
    return result;
  }

  Node *getParent() const
  {
    return new Node(node->parent);
  }

private:
  xmlNodePtr node;
};

class Document
{
public:
  Document(string htmlChar) : htmlChar(htmlChar)
  {
    doc = htmlReadMemory(htmlChar.c_str(), strlen(htmlChar.c_str()), "index.html", NULL, 0);
    if (doc == NULL)
    {
      throw "error: could not parse file";
    }
  }
  ~Document()
  {
    xmlFreeDoc(doc);
  }

  emscripten::val getNode(string xpathChar)
  {
    xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
    if (xpathCtx == NULL)
    {
      xmlFreeDoc(doc);
      throw "error: unable to create new XPath context";
    }

    xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression((xmlChar *)xpathChar.c_str(), xpathCtx);
    if (xpathObj == NULL)
    {
      xmlXPathFreeContext(xpathCtx);
      xmlFreeDoc(doc);
      throw "error: unable to evaluate xpath expression";
    }

    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (nodes == NULL)
    {
      xmlXPathFreeObject(xpathObj);
      xmlXPathFreeContext(xpathCtx);
      xmlFreeDoc(doc);
      throw "error: nodes was NULL";
    }

    if (nodes->nodeMax == 0)
    {
      std::cerr << "error: no nodes found" << std::endl;
    }

    emscripten::val result = emscripten::val::array();
    xmlNodePtr nodePtr;
    Node *nodeC;

    for (int i = 0; i < nodes->nodeNr; i++)
    {
      nodePtr = nodes->nodeTab[i];
      nodeC = new Node(nodePtr);
      result.call<void>("push", emscripten::val(nodeC));
    }
    return result;
  }

private:
  htmlDocPtr doc;
  string htmlChar;
};

Document *parseHTML(string docStr)
{
  return new Document(docStr);
}

EMSCRIPTEN_BINDINGS(LibXMLWasm)
{
  class_<Node>("Node")
      // .function("getContent", &Node::getContent, emscripten::allow_raw_pointers())
      .property("content", &Node::getContent)
      .property("name", &Node::getName)
      .property("attr", &Node::getAttr)
      .function("getParent", &Node::getParent, emscripten::allow_raw_pointers())
      .function("toString", &Node::toString, emscripten::allow_raw_pointers());
  class_<Document>("Document")
      .constructor<std::string>()
      .function("getNode", &Document::getNode, emscripten::allow_raw_pointers());
  emscripten::function("parseHTML", &parseHTML, emscripten::allow_raw_pointers());
}
