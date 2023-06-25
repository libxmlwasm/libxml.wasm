// const lxml = require('wasm-install');
import libxml_wasm from "./wasm-install/LibXML_WASM.js"

const lxml = await libxml_wasm()

const htmlStr = `
<html>
<head>
  <title>My First HTML</title>
</head>
<body>
  <h1>My First Heading</h1>
  <p>My first paragraph.</p>
</body>
</html>
`

const doc = lxml.parseHTML(htmlStr)
console.log(doc)
const nodeSet = doc.getNode(".//body/p")
console.log(nodeSet)
console.log(nodeSet.getLength())
