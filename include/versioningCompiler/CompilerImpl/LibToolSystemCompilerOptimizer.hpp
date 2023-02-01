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
#ifndef LIB_VERSIONING_LIBTOOL_COMPILER_SYSTEM_COMPILER_OPTIMIZER_HPP
#define LIB_VERSIONING_LIBTOOL_COMPILER_SYSTEM_COMPILER_OPTIMIZER_HPP

#include "versioningCompiler/CompilerImpl/SystemCompilerOptimizer.hpp"

#include "ltdl.h"

namespace vc {

class LibToolSystemCompilerOptimizer : public SystemCompilerOptimizer {
  using SystemCompilerOptimizer::SystemCompilerOptimizer;
  std::vector<void *> loadSymbols(const std::filesystem::path &bin,
                                  const std::vector<std::string> &func,
                                  void **handler);

  void releaseSymbol(void **handler);
    private:
    bool initialized = !lt_dlinit ();
};
} // namespace vc
#endif