import embindTest from "./wasm-test-install/LibXML_EMBIND_TEST.js"

const em = await embindTest()

const instance = new em.MyClass(10, "Hello")
instance.incrementX();
instance.x; // 11
instance.x = 20; // 20
em.MyClass.getStringFromInstance(instance); // "hello"
instance.delete();
console.log("OK")
