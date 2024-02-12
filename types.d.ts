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
}

/**
 * Node
 */
abstract class Node {
  /** Node's innerText */
  content: string;

  /** Node's tag name */
  name: string;

  /** Get node's parent node */
  getParent(): Node;

  /** Node's attrs */
  attr: Record<string, string>;

  /** Stringify Node like `<div>text</div>` */
  toString(): string;
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

export = LibXML_WASM;
