cmake_minimum_required(VERSION 3.18)

option(BUILD_TESTS "Build tests" OFF)
option(BUILD_PROJECT_IN_PARALLEL "Build project with multiple worker" ON)

# vcpkg features
if(BUILD_TESTS)
  list(APPEND VCPKG_MANIFEST_FEATURES "test")
endif()

project(EasyNt)

enable_language(CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TARGET_ARCHITECTURE x64 CACHE STRING "Target architecture")
set_property(CACHE TARGET_ARCHITECTURE PROPERTY STRINGS x64 x86)

if(DEFINED VCPKG_TARGET_TRIPLET)
  if(VCPKG_TARGET_TRIPLET MATCHES "^x64-.*")
    set(TARGET_ARCHITECTURE "x64")
  elseif(VCPKG_TARGET_TRIPLET MATCHES "^x86-.*")
    set(TARGET_ARCHITECTURE "x86")
  endif()
endif()
message(STATUS "Target architecture is ${TARGET_ARCHITECTURE}")

if(BUILD_PROJECT_IN_PARALLEL)
  if(MSVC)
    message(STATUS "Project will build with multiple worker.")
    add_compile_options(/MP)
  endif()
endif()

# Add more warnings
if(MSVC)
  add_compile_options(/W4)
else()
  add_compile_options(-Wall -Wextra -pedantic)
endif()

if(MSVC)
  # Generate pdb files for release build
  ADD_COMPILE_OPTIONS("$<$<NOT:$<CONFIG:Debug>>:/Z7>")
  ADD_LINK_OPTIONS("$<$<NOT:$<CONFIG:Debug>>:/DEBUG>")
endif()

# Common include directories
include_directories(include)

if(BUILD_TESTS)
  add_subdirectory(test)
endif()
add_subdirectory(src)
add_subdirectory(lib)