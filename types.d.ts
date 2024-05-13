/* eslint-disable @typescript-eslint/naming-convention */
async function LibXML_WASM(): Promise<LibXML>;

/**
 * Parse XML string to Document
 * @param xml XML string
 */
class Document {
  constructor(xml: string);

  /**
   * Get Node by XPath
   * @param xpath XPath string
   */
  getNode(xpath: string): Node[];

  /**
   * Stringify Document
   * - Known issue: returns only first node
   * @returns XML string
   */
  toString(): string;

  /**
   * Get Document's children nodes
   */
  getChildNodes(): Node[];
}

export type NodeType =
  "XML_ELEMENT_NODE"
  | "XML_ATTRIBUTE_NODE"
  | "XML_TEXT_NODE"
  | "XML_CDATA_SECTION_NODE"
  | "XML_ENTITY_REF_NODE"
  | "XML_ENTITY_NODE"
  | "XML_PI_NODE"
  | "XML_COMMENT_NODE"
  | "XML_DOCUMENT_NODE"
  | "XML_DOCUMENT_TYPE_NODE"
  | "XML_DOCUMENT_FRAG_NODE"
  | "XML_NOTATION_NODE"
  | "XML_HTML_DOCUMENT_NODE"
  | "XML_DTD_NODE"
  | "XML_ELEMENT_DECL"
  | "XML_ATTRIBUTE_DECL"
  | "XML_ENTITY_DECL"
  | "XML_NAMESPACE_DECL"
  | "XML_XINCLUDE_START"
  | "XML_XINCLUDE_END"

/**
 * Node
 */
abstract class Node {
  /** Node's innerText */
  content: string;

  /** Node's tag name */
  name: string;

  /** Node's attrs */
  attr: Record<string, string>;

  /** Get node's children nodes */
  children: Node[];

  /**
   * Node's type
   * - `XML_ELEMENT_NODE`
   * - `XML_ATTRIBUTE_NODE`
   * - `XML_TEXT_NODE`
   * - `XML_CDATA_SECTION_NODE`
   * - `XML_ENTITY_REF_NODE`
   * - `XML_ENTITY_NODE`
   * - `XML_PI_NODE`
   * - `XML_COMMENT_NODE`
   * - `XML_DOCUMENT_NODE`
   * - `XML_DOCUMENT_TYPE_NODE`
   * - `XML_DOCUMENT_FRAG_NODE`
   * - `XML_NOTATION_NODE`
   * - `XML_HTML_DOCUMENT_NODE`
   * - `XML_DTD_NODE`
   * - `XML_ELEMENT_DECL`
   * - `XML_ATTRIBUTE_DECL`
   * - `XML_ENTITY_DECL`
   * - `XML_NAMESPACE_DECL`
   * - `XML_XINCLUDE_START`
   * - `XML_XINCLUDE_END`
   */
  type: NodeType;

  /** Get node's parent node */
  getParent(): Node;

  /** Stringify Node like `<div>text</div>` */
  toString(): string;

  /** Get Node by XPath */
  getNode(xpath: string): Node[];
}

/**
 * LibXML
 */
interface LibXML {
  Document: typeof Document;
  Node: typeof Node;

  /**
   * Parse XML string to Document
   * @param html HTML string
   */
  parseHTML: (html: string) => Document;
}

// export = LibXML_WASM;
export default LibXML_WASM;
