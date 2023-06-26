//@ts-check
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
/** @type {Array<any>} */
const nodeSet = doc.getNode(xpath)
console.log(nodeSet)
nodeSet.forEach((node, i) => {
  console.log("node :", i, node.getContent())
})
