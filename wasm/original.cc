// #include <cstring>
#include <fstream>
#include <iostream>
#include <libxml/HTMLparser.h>
#include <libxml/xmlreader.h>
#include <libxml/xpath.h>

// #ifdef __EMSCRIPTEN__
#include "emscripten.h"
#include <emscripten/bind.h>
#include <emscripten/emscripten.h>
// #else
// #define EMSCRIPTEN_KEEPALIVE
// #endif

using namespace std;

htmlDocPtr createHTMLDoc(const char *htmlChar) {
  htmlDocPtr doc =
      htmlReadMemory(htmlChar, strlen(htmlChar), "index.html", NULL, 0);
  if (doc == NULL) {
    printf("error: could not parse file\n");
    throw "error: could not parse file";
  }
  return doc;
}

xmlNodeSetPtr getNode(htmlDocPtr doc, const xmlChar *xpathChar) {
  xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
  if (xpathCtx == NULL) {
    printf("error: unable to create new XPath context\n");
    xmlFreeDoc(doc);
    throw "error: unable to create new XPath context";
  }

  xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression(xpathChar, xpathCtx);
  if (xpathObj == NULL) {
    printf("error: unable to evaluate xpath expression \"%s\"\n", xpathChar);
    xmlXPathFreeContext(xpathCtx);
    xmlFreeDoc(doc);
    throw "error: unable to evaluate xpath expression";
  }

  xmlNodeSetPtr nodes = xpathObj->nodesetval;
  if (nodes == NULL) {
    printf("error: nodes was NULL\n");
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    xmlFreeDoc(doc);
    throw "error: nodes was NULL";
  }
  return nodes;
}

int getElementByXpath(const char *xmlstr, const char* xpathStr) {
  htmlDocPtr doc = createHTMLDoc(xmlstr);
  if (doc == NULL) {
    printf("error: could not parse file\n");
    return 1;
  }

  xmlNodeSetPtr nodes = getNode(doc, (xmlChar*)xpathStr);

  if (nodes->nodeMax == 0) {
    printf("error: no nodes found\n");
    xmlFreeDoc(doc);
    return 1;
  }

  // show nodes
  for (int i = 0; i < nodes->nodeNr; i++) {
    xmlNodePtr node = nodes->nodeTab[i];
    xmlChar *content = xmlNodeGetContent(node);
    printf("content: %s\n", content);
    xmlFree(content);
  }
  return 0;
}

int main(int argc, char *argv[]) {
  char* xmlstr = "<div><h1>Foo</h1></div>";
  char* xpathStr = "//h1";

  getElementByXpath(xmlstr, xpathStr);

  return 0;
}

EMSCRIPTEN_BINDINGS(LibXMLWasm) {
  emscripten::function(
      "getElementByXpath",
      emscripten::optional_override(
          [](const std::string xmlstr, const std::string xpathStr) {
            return getElementByXpath(xmlstr.c_str(), xpathStr.c_str());
          }));
}
