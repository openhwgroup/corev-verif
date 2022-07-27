// Copyright 2022 OpenHW Group
// Copyright 2022 Silicon Labs, Inc.
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier:Apache-2.0 WITH SHL-2.0

#include "pmp.h"

int main(int argc, char *argv[])
{
  // out of reset tests
  // reset_registers();
  // default_full();
  // default_none();

  // First time changing CSRs
  // mmode_only();

  // matching tests have sticky bits
  tor_zero();
  // napot_matching();
  // tor_macthing();

  exit(EXIT_SUCCESS);
}
