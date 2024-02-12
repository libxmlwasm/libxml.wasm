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
const xpath = [
  "//div/h1",
  "//div/p",
  "//div/*",
  "//div"
]


test("test libxml", async () => {
  const lxml = await lxmlwasm()
  const doc = lxml.parseHTML(html)

  const node1 = doc.getNode(xpath[0])
  expect(node1).toHaveLength(1)
  expect(node1[0].name).toBe("h1")
  expect(node1[0].content).toBe("Hello world")

  const node2 = doc.getNode(xpath[1])
  expect(node2).toHaveLength(1)
  expect(node2[0].name).toBe("p")
  expect(node2[0].content).toBe("Good")

  const node3 = doc.getNode(xpath[2])
  expect(node3).toHaveLength(2)
  expect(node3[0].name).toBe("h1")
  expect(node3[0].content).toBe("Hello world")
  expect(node3[1].name).toBe("p")
  expect(node3[1].content).toBe("Good")

  const node3parent = node3[0].getParent()
  expect(node3parent.name).toBe("div")
  expect(node3parent.attr).toEqual({ class: "container" })

  const div = doc.getNode(xpath[3])
  expect(div).toHaveLength(1)
  expect(div[0].name).toBe("div")
  expect(div[0].toString()).toBe("<div class=\"container\">\n    <h1>Hello world</h1>\n    <p>Good</p>\n  </div>")
  expect(div[0].attr).toEqual({ class: "container" })
  expect(div[0].content).toBe("\n    Hello world\n    Good\n  ")
})
