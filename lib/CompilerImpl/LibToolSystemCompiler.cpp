/* Copyright 2023 Politecnico di Milano.
 * Developed by : Moreno Giussani
 *                PhD student, Politecnico di Milano
 *                <first_name>.<family_name>@mail.polimi.it
 *
 * This file is part of libVersioningCompiler
 *
 * libVersioningCompiler is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation, either version 3
 * of the License, or (at your option) any later version.
 *
 * libVersioningCompiler is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with libVersioningCompiler. If not, see <http://www.gnu.org/licenses/>
 */
#ifndef LIB_VERSIONING_LIBTOOL_COMPILER_SYSTEM_COMPILER_CPP
#define LIB_VERSIONING_LIBTOOL_COMPILER_SYSTEM_COMPILER_CPP

#include "versioningCompiler/CompilerImpl/LibToolSystemCompiler.hpp"

namespace vc {

std::vector<void *>
LibToolSystemCompiler::loadSymbols(const std::filesystem::path &bin,
                                   const std::vector<std::string> &func,
                                   void **handler) {

  std::vector<void *> symbols = {};
  if (initialized) {
    if (exists(bin)) {
      *handler = (lt_dlhandle)lt_dlopen(bin.c_str());
    } else {
      std::string error_str =
          "cannot load symbol from " + bin.string() + " : file not found";
      log_string(error_str);
      return symbols;
    }
    if (*handler) {
      for (const std::string &f : func) {
        void *symbol = lt_dlsym((lt_dlhandle)*handler, f.c_str());
        if (!symbol) {
          std::string error_str = "cannot load symbol " + f + " from " +
                                  bin.string() + " : symbol not found";
          log_string(error_str);
        }
        symbols.push_back(symbol);
      } // end for
    } else {
      const char *error = lt_dlerror();
      std::string error_str(error);
      log_string(error_str);
    }
  } else {
    log_string("Call to lt_dlinit failed! Cannot load symbols");
  }

  return symbols;
}

void LibToolSystemCompiler::releaseSymbol(void **handler) {
  if (lt_dlclose((lt_dlhandle)*handler)) {
    const char *error = lt_dlerror();
    std::string error_str(error);
    log_string(error_str);
  }
  *handler = nullptr;
  return;
}
} // namespace vc

#endif