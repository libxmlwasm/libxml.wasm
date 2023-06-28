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
  getNode(xpath: string): Array<Node>;
}

/**
 * Node
 */
abstract class Node {
  /** Node's innerText */
  content: string;

  /** Node's tag name */
  name: string;

  /** Node's parent node */
  parent: Node;

  /** Node's attrs */
  attr: {
    [key: string]: string;
  };

  /** Stringify Node like `<div>text</div>` */
  toString(): string;
}

/**
 * LibXML
 */
interface LibXML {
  Document: typeof Document;
  Document: typeof Node;

  /**
   * Parse XML string to Document
   * @param html HTML string
   */
  parseHTML: (html: string) => Document;
}

export = LibXML_WASM;
