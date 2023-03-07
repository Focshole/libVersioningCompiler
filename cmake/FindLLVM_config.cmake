# Copyright 2022 Politecnico di Milano.
# Developed by : Stefano Cherubin
#                PhD student, Politecnico di Milano
#                <first_name>.<family_name>@polimi.it
#                Moreno Giussani
#                Ms student, Politecnico di Milano
#                <first_name>.<family_name>@mail.polimi.it
#
# This file is part of libVersioningCompiler
#
# libVersioningCompiler is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation, either version 3
# of the License, or (at your option) any later version.
#
# libVersioningCompiler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with libVersioningCompiler. If not, see <http://www.gnu.org/licenses/>
#
#                       FindLLVM_config.cmake
#
# Find the native LLVM includes and library and get the configuration parameters
#
#  LLVM_FOUND               - system has LLVM installed
#  LLVM_PACKAGE_VERSION     - LLVM version
#  LLVM_VERSION_MAJOR       - LLVM major release number
#  LLVM_INCLUDE_DIR         - where to find llvm include files
#  LLVM_LIBRARY_DIR         - where to find llvm libs
#  LLVM_CFLAGS              - llvm compiler flags
#  LLVM_LFLAGS              - llvm linker flags
#  LLVM_MODULE_LIBS         - list of llvm libs for working with modules.
#  LLVM_PACKAGE_VERSION     - Installed version.
#  LLVM_TOOLS_BINARY_DIR    - Where to find llvm-* programs

if(NOT LLVM_FOUND)
  set(LLVM_KNOWN_MAJOR_VERSIONS
      15
      14
      13
      12
      11
      10
      9
      8
      7
      6.0
      5.0
      4.0
      3.9
      3.8)
  foreach(ver ${LLVM_KNOWN_MAJOR_VERSIONS})
    find_package(LLVM ${ver} QUIET)
    if(LLVM_FOUND)
      # Call the main findLLVM.cmake to check LLVM setup and set some flags such as:
      #   LLVM_LIBRARY_DIR, LLVM_INCLUDE_DIR, LLVM_TOOLS_BINARY_DIR, LLVM_VERSION_MAJOR, LLVM_PACKAGE_VERSION
      if(LLVM_FIND_VERBOSE)
        find_package(LLVM ${ver} CONFIG)
      else(LLVM_FIND_VERBOSE)
        find_package(LLVM ${ver} CONFIG QUIET)
      endif(LLVM_FIND_VERBOSE)
      set(LLVM_config_FOUND TRUE)
      break()
    endif(LLVM_FOUND)
  endforeach(ver ${LLVM_KNOWN_VERSIONS})
endif(NOT LLVM_FOUND)

if(NOT LLVM_CONFIG_EXECUTABLE)
  find_program(
    LLVM_CONFIG_EXECUTABLE
    NAMES "llvm-config-${LLVM_VERSION_MAJOR}" "llvm-config"
    DOC "llvm-config executable"
    PATHS ${LLVM_TOOLS_BINARY_DIR})
endif(NOT LLVM_CONFIG_EXECUTABLE)

if(LLVM_CONFIG_EXECUTABLE)
  message(STATUS "Found components for LLVM")
  message(STATUS "llvm-config ........ = ${LLVM_CONFIG_EXECUTABLE}")
else(LLVM_CONFIG_EXECUTABLE)
  message(STATUS "llvm-config ........ = NOT FOUND")
  message(WARNING "Could NOT find LLVM config executable")
endif(LLVM_CONFIG_EXECUTABLE)

execute_process(
  COMMAND ${LLVM_CONFIG_EXECUTABLE} --cxxflags
  OUTPUT_VARIABLE LLVM_CFLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND ${LLVM_CONFIG_EXECUTABLE} --ldflags
  OUTPUT_VARIABLE LLVM_LFLAGS
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND ${LLVM_CONFIG_EXECUTABLE} --libs
  OUTPUT_VARIABLE LLVM_MODULE_LIBS
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND ${LLVM_CONFIG_EXECUTABLE} --libfiles
  OUTPUT_VARIABLE LLVM_MODULE_LIBFILES
  OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(LLVM_MODULE_LIBFILES)

# This should never happen
if(NOT LLVM_TOOLS_BINARY_DIR)
  execute_process(
    COMMAND ${LLVM_CONFIG_EXECUTABLE} --bindir
    OUTPUT_VARIABLE LLVM_TOOLS_BINARY_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif(NOT LLVM_TOOLS_BINARY_DIR)

if(NOT CLANG_EXE_NAME)
  find_program(
    CLANG_EXE_FULLPATH
    NAMES "clang-${LLVM_VERSION_MAJOR}" "clang"
    DOC "clang executable"
    PATHS ${LLVM_TOOLS_BINARY_DIR})
  get_filename_component(CLANG_EXE_NAME ${CLANG_EXE_FULLPATH} NAME)
endif(NOT CLANG_EXE_NAME)
if(NOT OPT_EXE_NAME)
  find_program(
    OPT_EXE_FULLPATH
    NAMES "opt-${LLVM_VERSION_MAJOR}" "opt"
    DOC "opt executable"
    PATHS ${LLVM_TOOLS_BINARY_DIR})
  get_filename_component(OPT_EXE_NAME ${OPT_EXE_FULLPATH} NAME)
endif(NOT OPT_EXE_NAME)

set(LLVM_SYSTEM pthread z tinfo)

if(LLVM_FIND_VERBOSE)
  if(LLVM_PACKAGE_VERSION)
    message(STATUS "LLVM_PACKAGE_VERSION = ${LLVM_PACKAGE_VERSION}")
    message(STATUS "LLVM_VERSION_MAJOR . = ${LLVM_VERSION_MAJOR}")
  else(LLVM_PACKAGE_VERSION)
    message(STATUS "LLVM_PACKAGE_VERSION = NOT FOUND")
    message(STATUS "LLVM_VERSION_MAJOR . = NOT FOUND")
  endif(LLVM_PACKAGE_VERSION)
  if(LLVM_INCLUDE_DIR)
    message(STATUS "LLVM_INCLUDE_DIR ... = ${LLVM_INCLUDE_DIR}")
  else(LLVM_INCLUDE_DIR)
    message(STATUS "LLVM_INCLUDE_DIR ... = NOT FOUND")
  endif(LLVM_INCLUDE_DIR)
  if(LLVM_LIBRARY_DIR)
    message(STATUS "LLVM_LIBRARY_DIR ... = ${LLVM_LIBRARY_DIR}")
  else(LLVM_LIBRARY_DIR)
    message(STATUS "LLVM_LIBRARY_DIR ... = NOT FOUND")
  endif(LLVM_LIBRARY_DIR)
  if(LLVM_FIND_VERBOSE)
    if(LLVM_CFLAGS)
      message(STATUS "LLVM_CFLAGS ........ = ${LLVM_CFLAGS}")
    else(LLVM_CFLAGS)
      message(STATUS "LLVM_CFLAGS ........ = NOT AVAILABLE")
    endif(LLVM_CFLAGS)
    if(LLVM_LFLAGS)
      message(STATUS "LLVM_LFLAGS ........ = ${LLVM_LFLAGS}")
    else(LLVM_LFLAGS)
      message(STATUS "LLVM_LFLAGS ........ = NOT AVAILABLE")
    endif(LLVM_LFLAGS)
    if(LLVM_MODULE_LIBS)
      message(STATUS "LLVM_MODULE_LIBS ... = ${LLVM_MODULE_LIBS}")
    else(LLVM_MODULE_LIBS)
      message(STATUS "LLVM_MODULE_LIBS ... = NOT FOUND")
    endif(LLVM_MODULE_LIBS)
    if(LLVM_SYSTEM)
      message(STATUS "LLVM_SYSTEM_LIBS ... = ${LLVM_SYSTEM}")
    else(LLVM_SYSTEM)
      message(STATUS "LLVM_SYSTEM_LIBS ... = NOT FOUND")
    endif(LLVM_SYSTEM)
    if(LLVM_TOOLS_BINARY_DIR)
      message(STATUS "LLVM_TOOLS_BINARY_DIR= ${LLVM_TOOLS_BINARY_DIR}")
    else(LLVM_TOOLS_BINARY_DIR)
      message(STATUS "LLVM_TOOLS_BINARY_DIR= NOT FOUND")
    endif(LLVM_TOOLS_BINARY_DIR)
  endif(LLVM_FIND_VERBOSE)
endif(LLVM_FIND_VERBOSE)

# Required to adjust imports based on the llvm major version
add_definitions(-DLLVM_VERSION_MAJOR=${LLVM_VERSION_MAJOR})
# Required to adjust paths without having runtime penalties
add_definitions(-DCLANG_EXE_FULLPATH="${CLANG_EXE_FULLPATH}")
add_definitions(-DOPT_EXE_FULLPATH="${OPT_EXE_FULLPATH}")
add_definitions(-DCLANG_EXE_NAME="${CLANG_EXE_NAME}")
add_definitions(-DOPT_EXE_NAME="${OPT_EXE_NAME}")

mark_as_advanced(
  LLVM_FOUND
  LLVM_INCLUDE_DIR
  LLVM_LIBRARY_DIR
  LLVM_CFLAGS
  LLVM_LFLAGS
  LLVM_MODULE_LIBS
  LLVM_SYSTEM
  LLVM_VERSION
  LLVM_TOOLS_BINARY_DIR)
