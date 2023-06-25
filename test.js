// const lxml = require('wasm-install');
import libxml_wasm from "./wasm-install/LibXML_WASM.js"

const lxml = await libxml_wasm()

const htmlStr = `
<html>
<head>
  <title>My First HTML</title>
</head>
<body>
  <div class="container">
    <h1>My First Heading</h1>
    <p>My first paragraph.</p>
  </div>
</body>
</html>
`
const xpath = "//body/h1"

lxml.getElementByXpath("<div><h1>Foo</h1></div>", "//h1")

const doc = lxml.parseHTML("<div><h1>Foo</h1></div>")
const nodeSet = doc.getNode("//h1")
console.log("length :", nodeSet.getLength())

