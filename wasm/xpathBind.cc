// #include <cstring>
#include <fstream>
#include <iostream>
#include <libxml/HTMLparser.h>
#include <libxml/xmlreader.h>
#include <libxml/xpath.h>

// #ifdef __EMSCRIPTEN__
// #include "emscripten.h"
// #include <emscripten/emscripten.h>
#include <emscripten/bind.h>
// #else
// #endif

using namespace std;
using namespace emscripten;

// htmlDocPtr create_HTMLDoc(const char *htmlChar)
// {
//   htmlDocPtr doc =
//       htmlReadMemory(htmlChar, strlen(htmlChar), "index.html", NULL, 0);
//   if (doc == NULL)
//   {
//     printf("error: could not parse file\n");
//     throw "error: could not parse file";
//   }
//   return doc;
// }

// xmlNodeSetPtr getNodeByXPath(htmlDocPtr doc, const xmlChar *xpathChar)
// {
//   xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
//   if (xpathCtx == NULL)
//   {
//     printf("error: unable to create new XPath context\n");
//     xmlFreeDoc(doc);
//     throw "error: unable to create new XPath context";
//   }

//   xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression(xpathChar, xpathCtx);
//   if (xpathObj == NULL)
//   {
//     printf("error: unable to evaluate xpath expression \"%s\"\n", xpathChar);
//     xmlXPathFreeContext(xpathCtx);
//     xmlFreeDoc(doc);
//     throw "error: unable to evaluate xpath expression";
//   }

//   xmlNodeSetPtr nodes = xpathObj->nodesetval;
//   if (nodes == NULL)
//   {
//     printf("error: nodes was NULL\n");
//     xmlXPathFreeObject(xpathObj);
//     xmlXPathFreeContext(xpathCtx);
//     xmlFreeDoc(doc);
//     throw "error: nodes was NULL";
//   }
//   return nodes;
// }

int getElementByXpath(const char *xmlstr, const char *xpathStr)
{
  std::cout << "xmlstr : " << xmlstr << std::endl;
  std::cout << "xpathStr : " << xpathStr << std::endl;

  htmlDocPtr doc =
      htmlReadMemory(xmlstr, strlen(xmlstr), "index.html", NULL, 0);
  if (doc == NULL)
  {
    printf("error: could not parse file\n");
    throw "error: could not parse file";
  }

  xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
  if (xpathCtx == NULL)
  {
    printf("error: unable to create new XPath context\n");
    xmlFreeDoc(doc);
    throw "error: unable to create new XPath context";
  }

  xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression((xmlChar *)xpathStr, xpathCtx);
  if (xpathObj == NULL)
  {
    printf("error: unable to evaluate xpath expression \"%s\"\n", (xmlChar *)xpathStr);
    xmlXPathFreeContext(xpathCtx);
    xmlFreeDoc(doc);
    throw "error: unable to evaluate xpath expression";
  }

  xmlNodeSetPtr nodes = xpathObj->nodesetval;
  if (nodes == NULL)
  {
    printf("error: nodes was NULL\n");
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    xmlFreeDoc(doc);
    throw "error: nodes was NULL";
  }

  if (nodes->nodeMax == 0)
  {
    printf("error: no nodes found\n");
    xmlFreeDoc(doc);
    return 1;
  }

  // show nodes
  for (int i = 0; i < nodes->nodeNr; i++)
  {
    xmlNodePtr node = nodes->nodeTab[i];
    xmlChar *content = xmlNodeGetContent(node);
    printf("content: %s\n", content);
    xmlFree(content);
  }
  return 0;
}



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
private:
  xmlNodePtr node;
};

class NodeSet
{
public:
  NodeSet(xmlNodeSetPtr nodes) : nodes(nodes) {}
  ~NodeSet() {
  }
  int getLength() {
    return nodes->nodeMax;
  }
  Node getFirst()
  {
    return Node(nodes->nodeTab[0]);
  }
  Node* get(int i)
  {
    return new Node(nodes->nodeTab[i]);
  }

private:
  xmlNodeSetPtr nodes;
};

class Document
{
public:
  Document(string htmlChar) : htmlChar(htmlChar)
  {
    htmlDocPtr doc =
        htmlReadMemory(htmlChar.c_str(), strlen(htmlChar.c_str()), "index.html", NULL, 0);
    if (doc == NULL)
    {
      printf("error: could not parse file\n");
      throw "error: could not parse file";
    }
  }
  ~Document() {
    xmlFreeDoc(doc);
  }
  NodeSet* getNode(string xpathChar)
  {
    std::cout << "getNode " << xpathChar << std::endl;
    // xmlNodeSetPtr nodes = getNodeByXPath(doc, (xmlChar*)xpathChar.c_str());
    xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
    if (xpathCtx == NULL)
    {
      printf("error: unable to create new XPath context\n");
      xmlFreeDoc(doc);
      throw "error: unable to create new XPath context";
    }

    xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression((xmlChar *)xpathChar.c_str(), xpathCtx);
    if (xpathObj == NULL)
    {
      printf("error: unable to evaluate xpath expression \"%s\"\n", xpathChar);
      xmlXPathFreeContext(xpathCtx);
      xmlFreeDoc(doc);
      throw "error: unable to evaluate xpath expression";
    }

    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (nodes == NULL)
    {
      printf("error: nodes was NULL\n");
      xmlXPathFreeObject(xpathObj);
      xmlXPathFreeContext(xpathCtx);
      xmlFreeDoc(doc);
      throw "error: nodes was NULL";
    }

    if (nodes->nodeMax == 0)
    {
      std::cout << "error: no nodes found" << std::endl;
      // xmlFreeDoc(doc);
      // throw "error: no nodes found";
    }
    return new NodeSet(nodes);
  }

private:
  htmlDocPtr doc;
  string htmlChar;
};

Document parseHTML(string docStr) {
  return Document(docStr);
}

EMSCRIPTEN_BINDINGS(LibXMLWasm)
{
  emscripten::function(
      "getElementByXpath",
      emscripten::optional_override(
          [](const std::string xmlstr, const std::string xpathStr)
          {
            return getElementByXpath(xmlstr.c_str(), xpathStr.c_str());
          }));
  class_<Document>("Document")
      .constructor<std::string>()
      .function("getNode", &Document::getNode);
  class_<NodeSet>("NodeSet")
      .function("getLength", &NodeSet::getLength)
      .function("getNode", &NodeSet::get);
  class_<Node>("Node")
      .function("getContent", &Node::getContent);
  emscripten::function("parseHTML", &parseHTML);
}
