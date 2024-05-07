cmake_minimum_required(VERSION 3.22)
project(
  libxml
  LANGUAGES CXX
)
set(CMAKE_CXX_STANDARD 17)
enable_testing()

set(
  CMAKE_FIND_ROOT_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/../prefix
  ${CMAKE_FIND_ROOT_PATH}
)

include(cmake/get_cpm.cmake)
CPMAddPackage(
  NAME magic_enum
  GITHUB_REPOSITORY Neargye/magic_enum
  GIT_TAG "v0.9.5"
)

set(Iconv_IS_BUILT_IN OFF)
find_package(Iconv REQUIRED)
find_package(ZLIB REQUIRED)
find_package(LibXml2 REQUIRED)

add_executable(libxml
  "libxmlBind.cc"
)
target_include_directories(libxml PUBLIC ${LIBXML2_INCLUDE_DIR})
target_link_libraries(libxml
  LibXml2::LibXml2
  Iconv::Iconv
  magic_enum::magic_enum
  ${CMAKE_CURRENT_SOURCE_DIR}/../prefix/lib/libz.a
)

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)

if(EMSCRIPTEN)
  # set_property(TARGET libxml PROPERTY SUFFIX ".js")
  set_target_properties(
    libxml
    PROPERTIES LINK_FLAGS "\
    -s INITIAL_MEMORY=64MB \
    -s MAXIMUM_MEMORY=4GB \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s ENVIRONMENT=web,node \
    -s NO_DISABLE_EXCEPTION_CATCHING \
    -gsource-map \
    -s MODULARIZE \
    -s EXPORT_ALL \
    --no-entry \
    --bind \
    -O2 \
    "
  )
endif()

install(
  TARGETS libxml
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
install(
  FILES "${CMAKE_BINARY_DIR}/libxml.wasm"
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
install(
  FILES "${CMAKE_BINARY_DIR}/libxml.wasm.map"
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
