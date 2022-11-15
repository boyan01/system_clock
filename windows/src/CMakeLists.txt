# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(system_clock_library VERSION 0.0.1 LANGUAGES C)

add_library(system_clock SHARED
  "system_clock.c"
)

set_target_properties(system_clock PROPERTIES
  PUBLIC_HEADER system_clock.h
  OUTPUT_NAME "system_clock"
)

target_compile_definitions(system_clock PUBLIC DART_SHARED_LIB)
