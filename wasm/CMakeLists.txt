cmake_minimum_required(VERSION 3.22)
project(
  LibXML_WASM
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
include_directories(${LIBXML2_INCLUDE_DIR})
link_libraries(${LIBXML2_LIBRARIES})

add_executable(LibXML_WASM
  "xmlXpath.cc"
)
target_include_directories(LibXML_WASM PUBLIC ${LIBXML2_INCLUDE_DIR})
target_link_libraries(LibXML_WASM ${LIBXML2_LIBRARIES})

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)

if(EMSCRIPTEN)
  # set_property(TARGET LibXML_WASM PROPERTY SUFFIX ".js")
  set_target_properties(
    LibXML_WASM
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
    "
  )
endif()

install(
  TARGETS LibXML_WASM
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
install(
  FILES "${LibXML_WASM_BINARY_DIR}/LibXML_WASM.wasm"
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
