/*
 * Copyright 2023 Dolphin Design
 * SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// This file contains all the macro defines that used in cv32e40p_float_instr_lib.sv

  // constraint for special pattern operands
  // note: DONOT insert " solve enable_special_operand_patterns before operand_``IDX``_pattern;\" at below code, it will limit the constraints (havent root caused)
  `define C_OPERAND_PATTERN(IDX) \
    constraint c_operand_``IDX``_pattern {\
      soft operand_``IDX``_pattern.size() == num_of_instr_per_stream;\
      foreach (operand_``IDX``_pattern[i]) {\
        if (enable_special_operand_patterns) {\
          soft operand_``IDX``_pattern[i] dist { IS_RAND := 8, IS_Q_NAN  := 4, IS_S_NAN              := 4, \
                                                 IS_POSITIVE_ZERO        := 4, IS_NEGATIVE_ZERO      := 4, \
                                                 IS_POSITIVE_INFINITY    := 4, IS_NEGATIVE_INFINITY  := 4, \
                                                 IS_POSITIVE_MAX         := 2, IS_NEGATIVE_MAX       := 2, \
                                                 IS_POSITIVE_MIN         := 2, IS_NEGATIVE_MIN       := 2, \
                                                 IS_POSITIVE_SUBNORMAL   := 4, IS_NEGATIVE_SUBNORMAL := 4 };\
        } else {\
          soft operand_``IDX``_pattern[i] == IS_RAND;\
        }\
      }\
    } 

  `define C_OPERAND(IDX) \
    constraint c_operand_``IDX {\
      sign_``IDX``.size()     == num_of_instr_per_stream;\
      exp_``IDX``.size()      == num_of_instr_per_stream;\
      mantissa_``IDX``.size() == num_of_instr_per_stream;\
      operand_``IDX``.size()  == num_of_instr_per_stream;\
      foreach (operand_``IDX``[i]) {\
        if (operand_``IDX``_pattern[i] == IS_POSITIVE_ZERO) {\
          sign_``IDX``[i] == 1'b0; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i] == 23'h0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_NEGATIVE_ZERO) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i] == 23'h0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_POSITIVE_INFINITY) {\
          sign_``IDX``[i] == 1'b0; exp_``IDX``[i] == 8'hFF; mantissa_``IDX``[i] == 23'h0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_NEGATIVE_INFINITY) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'hFF; mantissa_``IDX``[i] == 23'h0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_POSITIVE_MAX) {\
          sign_``IDX``[i] == 1'b0; exp_``IDX``[i] == 8'hFE; mantissa_``IDX``[i][22:0] == 23'h7FFFFF;\
        }\
        if (operand_``IDX``_pattern[i] == IS_NEGATIVE_MAX) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'hFE; mantissa_``IDX``[i][22:0] == 23'h7FFFFF;\
        }\
        if (operand_``IDX``_pattern[i] == IS_POSITIVE_MIN) {\
          sign_``IDX``[i] == 1'b0; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i][22:0] == 23'h1;\
        }\
        if (operand_``IDX``_pattern[i] == IS_NEGATIVE_MIN) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i][22:0] == 23'h1;\
        }\
        if (operand_``IDX``_pattern[i] == IS_POSITIVE_SUBNORMAL) {\
          sign_``IDX``[i] == 1'b0; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i][22:12] != 0; mantissa_``IDX``[i][11:0] == 0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_NEGATIVE_SUBNORMAL) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'h00; mantissa_``IDX``[i][22:12] != 0; mantissa_``IDX``[i][11:0] == 0;\
        }\
        if (operand_``IDX``_pattern[i] == IS_Q_NAN) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'hFF; mantissa_``IDX``[i][22] == 1'b1;\
        }\
        if (operand_``IDX``_pattern[i] == IS_S_NAN) {\
          sign_``IDX``[i] == 1'b1; exp_``IDX``[i] == 8'hFF; mantissa_``IDX``[i][22] == 1'b0; mantissa_``IDX``[i][21:12] != 0;\
        }\
        operand_``IDX[i] == {sign_``IDX``[i], exp_``IDX``[i], mantissa_``IDX``[i]};\
        solve operand_``IDX``_pattern[i] before sign_``IDX``[i];\
        solve sign_``IDX``[i] before operand_``IDX[i];\
        solve exp_``IDX``[i] before operand_``IDX[i];\
        solve mantissa_``IDX``[i] before operand_``IDX[i];\
      }\
    }

  // Add overhead instructions to override fp instr operands with specific operand pattern for FP_SPECIAL_OPERANDS_LIST_1
  // LUI->SW->FLW
  `define MANIPULATE_F_INSTR_OPERANDS_UPPER_20BITS_ONLY(FPR,OPERAND) \
    if (instr.has_``FPR && ``OPERAND``_pattern != IS_RAND) begin\
      riscv_instr                 m_instr;\
      riscv_floating_point_instr  f_instr;\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd),\
        .imm    ({12'h0, ``OPERAND``[31:12]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SW}));\
      override_instr(\
        .instr  (m_instr),\
        .rs2    (imm_rd),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][SW] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({FLW}));\
      `DV_CHECK_FATAL($cast(f_instr, m_instr), "Cast to instr_f failed!");\
      override_instr(\
        .f_instr  (f_instr),\
        .fd       (instr.``FPR``),\
        .rs1      (mem_rd),\
        .imm      (32'h0)\
      );\
      instr_list.push_back(f_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][FLW] `", ``OPERAND``_pattern)};\
    end

  // Add overhead instructions to override fp instr operands with specific operand pattern for FP_SPECIAL_OPERANDS_LIST_2
  // LUI->LUI->SRLI->OR->SW->SLW
  `define MANIPULATE_F_INSTR_OPERANDS_WORD(FPR,OPERAND) \
    if (instr.has_``FPR && ``OPERAND``_pattern != IS_RAND) begin\
      riscv_instr                 m_instr;\
      riscv_floating_point_instr  f_instr;\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd),\
        .imm    ({12'h0, ``OPERAND``[31:12]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd2),\
        .imm    ({20'h0, ``OPERAND``[11:0]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SRLI}));\
      override_instr(\
        .instr  (m_instr),\
        .rs1    (imm_rd2),\
        .rd     (imm_rd2),\
        .imm    ({20'h0,7'h0,5'd12})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][SRLI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({OR}));\
      override_instr(\
        .instr  (m_instr),\
        .rs1    (imm_rd),\
        .rs2    (imm_rd2),\
        .rd     (imm_rd)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][OR] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SW}));\
      override_instr(\
        .instr  (m_instr),\
        .rs2    (imm_rd),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][SW] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({FLW}));\
      `DV_CHECK_FATAL($cast(f_instr, m_instr), "Cast to instr_f failed!");\
      override_instr(\
        .f_instr  (f_instr),\
        .fd       (instr.``FPR``),\
        .rs1      (mem_rd),\
        .imm      (32'h0)\
      );\
      instr_list.push_back(f_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_f_instr_``OPERAND`` - %s][FLW] `", ``OPERAND``_pattern)};\
    end

  // Add overhead instructions to override zfinx fp instr operands with specific operand pattern for FP_SPECIAL_OPERANDS_LIST_1
  // LUI->SW->LW
  `define MANIPULATE_ZFINX_INSTR_OPERANDS_UPPER_20BITS_ONLY(GPR,OPERAND) \
    if (instr.has_``GPR && ``OPERAND``_pattern != IS_RAND) begin\
      riscv_instr                 m_instr;\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd),\
        .imm    ({12'h0, ``OPERAND``[31:12]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SW}));\
      override_instr(\
        .instr  (m_instr),\
        .rs2    (imm_rd),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][SW] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LW}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (instr.``GPR``),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][LW] `", ``OPERAND``_pattern)};\
    end

  //fixme
  // Add overhead instructions to override zfinx fp instr operands with specific operand pattern for FP_SPECIAL_OPERANDS_LIST_2
  // LUI->LUI->SRLI->OR->SW->SLW
  `define MANIPULATE_ZFINX_INSTR_OPERANDS_WORD(GPR,OPERAND) \
    if (instr.has_``GPR && ``OPERAND``_pattern != IS_RAND) begin\
      riscv_instr                 m_instr;\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd),\
        .imm    ({12'h0, ``OPERAND``[31:12]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LUI}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (imm_rd2),\
        .imm    ({20'h0, ``OPERAND``[11:0]})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][LUI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SRLI}));\
      override_instr(\
        .instr  (m_instr),\
        .rs1    (imm_rd2),\
        .rd     (imm_rd2),\
        .imm    ({20'h0,7'h0,5'd12})\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][SRLI] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({OR}));\
      override_instr(\
        .instr  (m_instr),\
        .rs1    (imm_rd),\
        .rs2    (imm_rd2),\
        .rd     (imm_rd)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][OR] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({SW}));\
      override_instr(\
        .instr  (m_instr),\
        .rs2    (imm_rd),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][SW] `", ``OPERAND``_pattern)};\
      m_instr = new riscv_instr::get_rand_instr(.include_instr({LW}));\
      override_instr(\
        .instr  (m_instr),\
        .rd     (instr.``GPR``),\
        .rs1    (mem_rd),\
        .imm    (32'h0)\
      );\
      instr_list.push_back(m_instr);\
      instr_list[$].comment = {instr_list[$].comment, $sformatf(`" [manipulate_zfinx_instr_``OPERAND`` - %s][LW] `", ``OPERAND``_pattern)};\
    end


  // 22 always exclude list within fp stream
  `define   FP_STREAM_EXCLUDE_LIST   {JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, ECALL, EBREAK, \
                                     DRET, MRET, URET, SRET, WFI, C_EBREAK, C_BEQZ, C_BNEZ, C_J, C_JAL, \
                                     C_JR, C_JALR}

  // special operands listing
  `define   FP_SPECIAL_OPERANDS_LIST_1  {IS_POSITIVE_ZERO, IS_NEGATIVE_ZERO, IS_POSITIVE_INFINITY, IS_NEGATIVE_INFINITY, IS_POSITIVE_SUBNORMAL, IS_NEGATIVE_SUBNORMAL, IS_Q_NAN, IS_S_NAN}
  `define   FP_SPECIAL_OPERANDS_LIST_2  {IS_POSITIVE_MAX, IS_NEGATIVE_MAX, IS_POSITIVE_MIN, IS_NEGATIVE_MIN}

