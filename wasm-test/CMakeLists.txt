cmake_minimum_required(VERSION 3.22)
project(
  LibXML_EMBIND_TEST
  LANGUAGES CXX
)
set(CMAKE_CXX_STANDARD 17)
enable_testing()

set(
  CMAKE_FIND_ROOT_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/../prefix
  ${CMAKE_FIND_ROOT_PATH}
)

find_package(LibXml2 REQUIRED)

add_executable(LibXML_EMBIND_TEST
  "emBindTest.cc"
)
target_include_directories(LibXML_EMBIND_TEST PUBLIC ${LIBXML2_INCLUDE_DIR})
target_link_libraries(LibXML_EMBIND_TEST
  ${LIBXML2_LIBRARIES}
  ${CMAKE_CURRENT_SOURCE_DIR}/../prefix/lib/libz.a
)

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)

if(EMSCRIPTEN)
  # set_property(TARGET LibXML_EMBIND_TEST PROPERTY SUFFIX ".js")
  set_target_properties(
    LibXML_EMBIND_TEST
    PROPERTIES LINK_FLAGS "\
    -s INITIAL_MEMORY=64MB \
    -s MAXIMUM_MEMORY=4GB \
    -s ALLOW_MEMORY_GROWTH=1 \
    -gsource-map \
    -s MODULARIZE \
    -s EXPORT_ES6 \
    -s EXPORT_ALL \
    --no-entry \
    --bind \
    -O3 \
    -flto \
    --closure 1 \
    "
  )
endif()

install(
  TARGETS LibXML_EMBIND_TEST
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
install(
  FILES "${LibXML_EMBIND_TEST_BINARY_DIR}/LibXML_EMBIND_TEST.wasm"
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
