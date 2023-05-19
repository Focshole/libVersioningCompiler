/* Copyright 2017 Politecnico di Milano.
 * Developed by : Stefano Cherubin
 *                PhD student, Politecnico di Milano
 *                <first_name>.<family_name>@polimi.it
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
#include <stdio.h>

#ifdef TEST_FUNCTION

float global_var = -1.0f;

/**
 * Test function for the versioning compiler library.
 * In the test, this function is compiled and loaded dynamically.
 */
int test_function(int x) {
  float y = x;
  y = y * y;
  global_var = y;
  printf("I'm a test function printing a number x^2 = %.3f\n", y);
  return 0;
}

/**
 * Test function for the versioning compiler library.
 * In the test, this function is compiled and loaded dynamically.
 */
int test_function2(int x) {
  float y;
  if (!x) {
    y = global_var;
  } else {
    y = x * x * x;
  }
  printf("I'm a test function printing an old number = %.3f\n", y);
  return 0;
}

#endif /* TEST_FUNCTION */
