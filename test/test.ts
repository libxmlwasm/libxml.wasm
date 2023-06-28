import lxmlwasm from ".."

const html = `
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Document</title>
</head>
<body>
  <div class="container">
    <h1>Hello world</h1>
    <p>Good</p>
  </div>
</body>
</html>
`.trim()
const xpath = "//div/h1"

test("test", async () => {
  const lxml = await lxmlwasm()
  const doc = lxml.parseHTML(html)
  const node = doc.getNode(xpath)
  expect(node[0].content).toBe("Hello world")
})
