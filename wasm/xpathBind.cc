// #include <cstring>
#include <fstream>
#include <iostream>
#include <libxml/HTMLparser.h>
#include <libxml/xmlreader.h>
#include <libxml/xpath.h>
#include <emscripten/bind.h>

using namespace std;
using namespace emscripten;

class Node {
public:
  Node(xmlNodePtr node) : node(node) {}
  ~Node() {
  }
  string getContent() {
    xmlChar *content = xmlNodeGetContent(node);
    string contentStr((char *)content);
    xmlFree(content);
    return contentStr;
  }

  string toString()
  {
    // show node as html string
    xmlBufferPtr buf = xmlBufferCreate();
    xmlNodeDump(buf, node->doc, node, 0, 1);
    string nodeStr((char *)buf->content);
    xmlBufferFree(buf);
    return nodeStr;
  }

private:
  xmlNodePtr node;
};

class NodeSet
{
public:
  NodeSet(xmlNodeSetPtr nodes) : nodes(nodes) {}
  ~NodeSet() {
  }
  int getLength() const { return nodes->nodeNr; }

  Node* get(int i)
  {
    return new Node(nodes->nodeTab[i]);
  }

  void forEach(emscripten::val callback)
  {
    for (int i = 0; i < nodes->nodeNr; i++)
    {
      xmlNodePtr node = nodes->nodeTab[i];
      xmlChar *content = xmlNodeGetContent(node);
      string contentStr((char *)content);
      xmlFree(content);
      callback(contentStr, i);
    }
  }

  emscripten::val map(emscripten::val callback)
  {
    emscripten::val result = emscripten::val::array();
    for (int i = 0; i < nodes->nodeNr; i++)
    {
      xmlNodePtr node = nodes->nodeTab[i];
      xmlChar *content = xmlNodeGetContent(node);
      string contentStr((char *)content);
      xmlFree(content);
      result.call<void>("push", callback(contentStr, i));
    }
    return result;
  }

private:
  xmlNodeSetPtr nodes;
};

class Document
{
public:
  Document(string htmlChar) : htmlChar(htmlChar)
  {
    doc =
        htmlReadMemory(htmlChar.c_str(), strlen(htmlChar.c_str()), "index.html", NULL, 0);
    if (doc == NULL)
    {
      throw "error: could not parse file";
    }
  }
  ~Document() {
    xmlFreeDoc(doc);
  }

  NodeSet* getNode(string xpathChar)
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
    return new NodeSet(nodes);
  }

private:
  htmlDocPtr doc;
  string htmlChar;
};

Document* parseHTML(string docStr) {
  return new Document(docStr);
}

EMSCRIPTEN_BINDINGS(LibXMLWasm)
{
  class_<Node>("Node")
      .function("getContent", &Node::getContent, emscripten::allow_raw_pointers())
      .function("toString", &Node::toString, emscripten::allow_raw_pointers());
  class_<NodeSet>("NodeSet")
      .property("length", &NodeSet::getLength)
      // .function("getLength", &NodeSet::getLength, emscripten::allow_raw_pointers())
      .function("get", &NodeSet::get, emscripten::allow_raw_pointers())
      .function("forEach", &NodeSet::forEach, emscripten::allow_raw_pointers())
      .function("map", &NodeSet::map, emscripten::allow_raw_pointers());
  class_<Document>("Document")
      .constructor<std::string>()
      .function("getNode", &Document::getNode, emscripten::allow_raw_pointers());
  emscripten::function("parseHTML", &parseHTML, emscripten::allow_raw_pointers());
}
