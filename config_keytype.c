/* 
   Copyright 2009-2010 Jure Varlec
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   A copy of the GNU General Public License is provided in COPYING.
   If not, see <http://www.gnu.org/licenses/>.
*/

#define _SVID_SOURCE
#include <stdio.h>
#include <inttypes.h>
#include <sys/ipc.h>

int main() {
  if (sizeof(uintmax_t) < sizeof(key_t)) {
    printf("#error uintmax smaller than key_t. "
	   "Sizes: %u and %u\n", sizeof(uintmax_t), sizeof(key_t));
  }
  return 0;
}
