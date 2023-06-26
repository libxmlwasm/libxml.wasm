//@ts-check
import libxml_wasm from "./wasm-install/LibXML_WASM.js"
import css2xpath from "css2xpath"

const lxml = await libxml_wasm()

const htmlStr = `
<html>
<head>
  <title>My First HTML</title>
</head>
<body>
  <div class="container" id="foo">
    plain text
    <h1>My First Heading</h1>
    <p>My first paragraph.</p>
  </div>
</body>
</html>
`
const selector = "div"
const xpath = css2xpath("//" + selector.trim())

const doc = lxml.parseHTML(htmlStr)
/** @type {Array<any>} */
const nodeSet = doc.getNode(xpath)
nodeSet.forEach((node, i) => {
  console.log("node :", i, ", name :", node.name)
})
