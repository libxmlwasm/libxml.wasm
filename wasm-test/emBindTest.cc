#include <iostream>
#include <emscripten/bind.h>

using namespace emscripten;

class MyClass
{
public:
  MyClass(int x, std::string y)
      : x(x), y(y)
  {
    std::cout << "MyClass" << std::endl;
  }

  void incrementX()
  {
    std::cout << "incrementX" << std::endl;
    ++x;
  }

  int getX() const {
    std::cout << "getX" << std::endl;
    return x;
  }
  void setX(int x_) {
    std::cout << "setX" << std::endl;
    x = x_;
  }

  static std::string getStringFromInstance(const MyClass &instance)
  {
    std::cout << "getStringFromInstance" << std::endl;
    return instance.y;
  }

private:
  int x;
  std::string y;
};

// Binding code
EMSCRIPTEN_BINDINGS(my_class_example)
{
  class_<MyClass>("MyClass")
      .constructor<int, std::string>()
      .function("incrementX", &MyClass::incrementX)
      .property("x", &MyClass::getX, &MyClass::setX)
      .class_function("getStringFromInstance", &MyClass::getStringFromInstance);
}
