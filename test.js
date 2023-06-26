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
const xpath = "//body/div/*"

const doc = lxml.parseHTML(htmlStr)
const nodeSet = doc.getNode(xpath)
console.log("length :", nodeSet.getLength())
nodeSet.forEach((node, i) => {
  console.log("node :", i, node.toString())
})
// const node = nodeSet.get(0)
// console.log(node, node.toString())
