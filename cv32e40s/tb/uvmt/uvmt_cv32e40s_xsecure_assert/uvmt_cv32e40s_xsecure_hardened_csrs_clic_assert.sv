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
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0


module uvmt_cv32e40s_xsecure_hardened_csrs_clic_assert
  import uvm_pkg::*;
  import cv32e40s_pkg::*;
  #(
    parameter int       SECURE   = 1
  )
  (

    input rst_ni,
    input clk_i,

    //Alert:
    input logic alert_major,

    //CSRs:
    input mtvt_t mtvt,
    input mtvec_t mtvec,
    input mintstatus_t mintstatus,
    input logic [31:0] mintthresh,

    //Shadows:
    input logic [$bits(mtvt_t)-1:0] mtvt_shadow,
    input logic [$bits(mtvec_t)-1:0] mtvec_shadow,
    input logic [$bits(mintstatus_t)-1:0] mintstatus_shadow,
    input logic [31:0] mintthresh_shadow

  );

  // Default settings:
  default clocking @(posedge clk_i); endclocking
  default disable iff (!(rst_ni) | !(SECURE));
  string info_tag = "CV32E40S_XSECURE_ASSERT_COVERPOINTS";
  string info_tag_glitch = "CV32E40S_XSECURE_ASSERT_COVERPOINTS (GLITCH BEHAVIOR)";


  //Verify that the following CSRs have bit-wise complemented shadows

  property p_hardened_csr(csr, shadow);
    csr == ~shadow;
  endproperty

    //MTVT
    a_xsecure_hardened_csr_mtvt: assert property (
      p_hardened_csr(
        mtvt,
        mtvt_shadow)
    ) else `uvm_error(info_tag, "The CSR MTVT is not shadowed.\n");

    //MTVEC
    a_xsecure_hardened_csr_mtvec: assert property (
      p_hardened_csr(
        mtvec,
        mtvec_shadow)
    ) else `uvm_error(info_tag, "The CSR MTVEC is not shadowed.\n");

    //MINTSTATUS
    a_xsecure_hardened_csr_mintstatus: assert property (
      p_hardened_csr(
        mintstatus,
        mintstatus_shadow)
    ) else `uvm_error(info_tag, "The CSR MINTSTATUS is not shadowed.\n");

    //MINTTHRESH
    a_xsecure_hardened_csr_mintthresh: assert property (
      p_hardened_csr(
        mintthresh,
        mintthresh_shadow)
    ) else `uvm_error(info_tag, "The CSR MINTTHRESH is not shadowed.\n");


  //Verify that mismatch between the following CSRs and their shadows set alert major

  property p_hardened_csr_mismatch_sets_major_aler(csr, shadow);

    shadow != ~csr
    |=>
    alert_major;

  endproperty


    //MTVT
    a_glitch_xsecure_hardened_csr_mismatch_mtvt: assert property (
      p_hardened_csr_mismatch_sets_major_aler(
        mtvt,
        mtvt_shadow)
    ) else `uvm_error(info_tag_glitch, "A mismatch between the CSR MTVT and its shadow does not set the major alert.\n");

    //MTVEC
    a_glitch_xsecure_hardened_csr_mismatch_mtvec: assert property (
      p_hardened_csr_mismatch_sets_major_aler(
        mtvec,
        mtvec_shadow)
    ) else `uvm_error(info_tag_glitch, "A mismatch between the CSR MTVEC and its shadow does not set the major alert.\n");

    //MINTSTATUS
    a_glitch_xsecure_hardened_csr_mismatch_mintstatus: assert property (
      p_hardened_csr_mismatch_sets_major_aler(
        mintstatus,
        mintstatus_shadow)
    ) else `uvm_error(info_tag_glitch, "A mismatch between the CSR MINTSTATUS and its shadow does not set the major alert.\n");

    //MINTTHRESH
    a_glitch_xsecure_hardened_csr_mismatch_mintthresh: assert property (
      p_hardened_csr_mismatch_sets_major_aler(
        mintthresh,
        mintthresh_shadow)
    ) else `uvm_error(info_tag_glitch, "A mismatch between the CSR MINTTHRESH and its shadow does not set the major alert.\n");


  endmodule : uvmt_cv32e40s_xsecure_hardened_csrs_clic_assert