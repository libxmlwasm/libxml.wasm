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

set(TARGET_SUFFIX)
message(STATUS "TARGET_SUFFIX:${TARGET_SUFFIX}")

if(${TARGET_SUFFIX} STREQUAL ".mjs")
  set(ESM "1")
else()
  set(ESM "0")
endif()

if(EMSCRIPTEN)
  set_property(TARGET libxml PROPERTY SUFFIX "${TARGET_SUFFIX}")

  # set_property(TARGET libxml PROPERTY SUFFIX ".wasm")
  set_target_properties(
    libxml
    PROPERTIES LINK_FLAGS "\
    -s MAXIMUM_MEMORY=4GB \
    -s ALLOW_MEMORY_GROWTH \
    -s NO_POLYFILL \
    -gsource-map \
    -s ENVIRONMENT=web,webview,worker,node \
    -s SINGLE_FILE \
    -s MODULARIZE \
    -s EXPORT_ES6=${ESM} \
    --profile \
    -s STACK_OVERFLOW_CHECK=2 \
    -s WASM_ASYNC_COMPILATION \
    -s EMIT_PRODUCERS_SECTION \
    -s EVAL_CTORS=1 \
    -Oz \
    --no-entry \
    -lembind \
    --emit-tsd libxml.d.ts \
    "
  )
endif()

install(
  TARGETS libxml
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)
install(
  FILES "${CMAKE_BINARY_DIR}/libxml.d.ts"
  DESTINATION "${CMAKE_INSTALL_PREFIX}"
)

# install(
# FILES "${CMAKE_BINARY_DIR}/libxml.wasm"
# DESTINATION "${CMAKE_INSTALL_PREFIX}"
# )
# install(
# FILES "${CMAKE_BINARY_DIR}/libxml.wasm.map"
# DESTINATION "${CMAKE_INSTALL_PREFIX}"
# )
