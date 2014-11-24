////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: gcd_sys_synthesis.v
// /___/   /\     Timestamp: Tue Sep 30 18:47:11 2014
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -insert_glbl true -w -dir netgen/synthesis -ofmt verilog -sim gcd_sys.ngc gcd_sys_synthesis.v 
// Device	: xc6slx16-3-csg324
// Input file	: gcd_sys.ngc
// Output file	: C:\Users\Anders\Dropbox\DTU\E14\DesignOfDigitalSys\C02203\Lab1\task4\Xilinx\netgen\synthesis\gcd_sys_synthesis.v
// # of Modules	: 1
// Design Name	: GCD_sys
// Xilinx        : C:\Xilinx\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module GCD_sys (
  clk, reset, req, ack, AB, C
);
  input clk;
  input reset;
  input req;
  output ack;
  input [7 : 0] AB;
  output [7 : 0] C;
  wire AB_7_IBUF_0;
  wire AB_6_IBUF_1;
  wire AB_5_IBUF_2;
  wire AB_4_IBUF_3;
  wire AB_3_IBUF_4;
  wire AB_2_IBUF_5;
  wire AB_1_IBUF_6;
  wire AB_0_IBUF_7;
  wire clk_BUFGP_8;
  wire reset_IBUF_9;
  wire req_IBUF_10;
  wire ack_OBUF_19;
  wire \dbreq/state_reg_FSM_FFd1_20 ;
  wire N0;
  wire N1;
  wire \u1/LDA ;
  wire \u1/LDB ;
  wire \u1/state_FSM_FFd2_66 ;
  wire \u1/state_FSM_FFd1_67 ;
  wire \u1/state_FSM_FFd10-In ;
  wire \u1/state_FSM_FFd9-In ;
  wire \u1/state_FSM_FFd8-In ;
  wire \u1/state_FSM_FFd7-In ;
  wire \u1/state_FSM_FFd6-In ;
  wire \u1/state_FSM_FFd5-In ;
  wire \u1/state_FSM_FFd4-In ;
  wire \u1/state_FSM_FFd3-In ;
  wire \u1/state_FSM_FFd2-In ;
  wire \u1/state_FSM_FFd1-In ;
  wire \u1/state_FSM_FFd10_78 ;
  wire \u1/state_FSM_FFd9_79 ;
  wire \u1/state_FSM_FFd8_80 ;
  wire \u1/state_FSM_FFd7_81 ;
  wire \u1/state_FSM_FFd6_82 ;
  wire \u1/state_FSM_FFd4_83 ;
  wire \u1/state_FSM_FFd3_84 ;
  wire \u1/tribuf/en_inv ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<19> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<18>_103 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<18> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<17>_105 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<17> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<16>_107 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<16> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<15>_109 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<15> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<14>_111 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<14> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<13>_113 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<13> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<12>_115 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<12> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<11>_117 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<11> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<10>_119 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<10> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<9>_121 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<9> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<8>_123 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<8> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<7>_125 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<7> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<6>_127 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<6> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<5>_129 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<5> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<4>_131 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<4> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<3>_133 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<3> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<2>_135 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<2> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<1>_137 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<1> ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_139 ;
  wire \dbreq/state_reg_FSM_FFd1-In ;
  wire \dbreq/state_reg_FSM_FFd2_181 ;
  wire \dbreq/sw_reg2_182 ;
  wire \dbreq/sw_reg1_183 ;
  wire \u1/alu1/Z ;
  wire \u1/alu1/Z2 ;
  wire \dbreq/q_zero<19>1_207 ;
  wire \dbreq/q_zero<19>2_208 ;
  wire \dbreq/q_zero<19>3_209 ;
  wire \dbreq/q_zero<19>4_210 ;
  wire \dbreq/q_zero<19>5_211 ;
  wire \dbreq/q_zero<19>6_212 ;
  wire \dbreq/q_zero<19>7_213 ;
  wire \dbreq/q_zero<19>8_214 ;
  wire \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_rt_227 ;
  wire N01;
  wire N11;
  wire N3;
  wire N4;
  wire N6;
  wire N7;
  wire N9;
  wire N111;
  wire N13;
  wire N15;
  wire \dbreq/state_reg_FSM_FFd1_1_238 ;
  wire \dbreq/sw_reg2_1_239 ;
  wire [8 : 1] \u1/reg_b/data_out ;
  wire [8 : 1] \u1/reg_a/data_out ;
  wire [7 : 0] \u1/C_int ;
  wire [9 : 1] \u1/alu1/Mmux_i_C1_split ;
  wire [8 : 1] \u1/alu1/Mmux_i_C1_rs_A ;
  wire [7 : 0] \u1/alu1/Mmux_i_C1_rs_lut ;
  wire [7 : 0] \u1/alu1/Mmux_i_C1_rs_cy ;
  wire [19 : 0] \dbreq/q_next ;
  wire [19 : 0] \dbreq/GND_18_o_GND_18_o_sub_3_OUT ;
  wire [19 : 0] \dbreq/q_reg ;
  wire [19 : 19] \dbreq/q_zero ;
  GND   XST_GND (
    .G(N0)
  );
  VCC   XST_VCC (
    .P(N1)
  );
  FDE   \u1/reg_b/data_out_8  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [7]),
    .Q(\u1/reg_b/data_out [8])
  );
  FDE   \u1/reg_b/data_out_7  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [6]),
    .Q(\u1/reg_b/data_out [7])
  );
  FDE   \u1/reg_b/data_out_6  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [5]),
    .Q(\u1/reg_b/data_out [6])
  );
  FDE   \u1/reg_b/data_out_5  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [4]),
    .Q(\u1/reg_b/data_out [5])
  );
  FDE   \u1/reg_b/data_out_4  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [3]),
    .Q(\u1/reg_b/data_out [4])
  );
  FDE   \u1/reg_b/data_out_3  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [2]),
    .Q(\u1/reg_b/data_out [3])
  );
  FDE   \u1/reg_b/data_out_2  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [1]),
    .Q(\u1/reg_b/data_out [2])
  );
  FDE   \u1/reg_b/data_out_1  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDB ),
    .D(\u1/C_int [0]),
    .Q(\u1/reg_b/data_out [1])
  );
  FDE   \u1/reg_a/data_out_8  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [7]),
    .Q(\u1/reg_a/data_out [8])
  );
  FDE   \u1/reg_a/data_out_7  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [6]),
    .Q(\u1/reg_a/data_out [7])
  );
  FDE   \u1/reg_a/data_out_6  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [5]),
    .Q(\u1/reg_a/data_out [6])
  );
  FDE   \u1/reg_a/data_out_5  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [4]),
    .Q(\u1/reg_a/data_out [5])
  );
  FDE   \u1/reg_a/data_out_4  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [3]),
    .Q(\u1/reg_a/data_out [4])
  );
  FDE   \u1/reg_a/data_out_3  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [2]),
    .Q(\u1/reg_a/data_out [3])
  );
  FDE   \u1/reg_a/data_out_2  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [1]),
    .Q(\u1/reg_a/data_out [2])
  );
  FDE   \u1/reg_a/data_out_1  (
    .C(clk_BUFGP_8),
    .CE(\u1/LDA ),
    .D(\u1/C_int [0]),
    .Q(\u1/reg_a/data_out [1])
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd8  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd8-In ),
    .Q(\u1/state_FSM_FFd8_80 )
  );
  FDP #(
    .INIT ( 1'b1 ))
  \u1/state_FSM_FFd10  (
    .C(clk_BUFGP_8),
    .D(\u1/state_FSM_FFd10-In ),
    .PRE(reset_IBUF_9),
    .Q(\u1/state_FSM_FFd10_78 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd9  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd9-In ),
    .Q(\u1/state_FSM_FFd9_79 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd7  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd7-In ),
    .Q(\u1/state_FSM_FFd7_81 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd6  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd6-In ),
    .Q(\u1/state_FSM_FFd6_82 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd5  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd5-In ),
    .Q(\u1/state_FSM_FFd4-In )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd1-In ),
    .Q(\u1/state_FSM_FFd1_67 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd3  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd3-In ),
    .Q(\u1/state_FSM_FFd3_84 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd2  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd2-In ),
    .Q(\u1/state_FSM_FFd2_66 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \u1/state_FSM_FFd4  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\u1/state_FSM_FFd4-In ),
    .Q(\u1/state_FSM_FFd4_83 )
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<0>  (
    .CI(N1),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [1]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [0]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [0])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<0>  (
    .CI(N1),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [0]),
    .O(\u1/alu1/Mmux_i_C1_split [1])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<1>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [0]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [2]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [1]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [1])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<1>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [0]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [1]),
    .O(\u1/alu1/Mmux_i_C1_split [2])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<2>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [1]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [3]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [2]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [2])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<2>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [1]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [2]),
    .O(\u1/alu1/Mmux_i_C1_split [3])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<3>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [2]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [4]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [3]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [3])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<3>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [2]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [3]),
    .O(\u1/alu1/Mmux_i_C1_split [4])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<4>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [3]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [5]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [4]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [4])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<4>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [3]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [4]),
    .O(\u1/alu1/Mmux_i_C1_split [5])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<5>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [4]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [6]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [5]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [5])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<5>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [4]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [5]),
    .O(\u1/alu1/Mmux_i_C1_split [6])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<6>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [5]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [7]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [6]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [6])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<6>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [5]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [6]),
    .O(\u1/alu1/Mmux_i_C1_split [7])
  );
  MUXCY   \u1/alu1/Mmux_i_C1_rs_cy<7>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [6]),
    .DI(\u1/alu1/Mmux_i_C1_rs_A [8]),
    .S(\u1/alu1/Mmux_i_C1_rs_lut [7]),
    .O(\u1/alu1/Mmux_i_C1_rs_cy [7])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<7>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [6]),
    .LI(\u1/alu1/Mmux_i_C1_rs_lut [7]),
    .O(\u1/alu1/Mmux_i_C1_split [8])
  );
  XORCY   \u1/alu1/Mmux_i_C1_rs_xor<8>  (
    .CI(\u1/alu1/Mmux_i_C1_rs_cy [7]),
    .LI(N1),
    .O(\u1/alu1/Mmux_i_C1_split [9])
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<19>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<18>_103 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<19> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [19])
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<18>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<17>_105 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<18> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [18])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<18>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<17>_105 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<18> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<18>_103 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<17>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<16>_107 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<17> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [17])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<17>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<16>_107 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<17> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<17>_105 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<16>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<15>_109 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<16> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [16])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<16>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<15>_109 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<16> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<16>_107 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<15>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<14>_111 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<15> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [15])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<15>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<14>_111 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<15> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<15>_109 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<14>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<13>_113 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<14> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [14])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<14>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<13>_113 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<14> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<14>_111 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<13>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<12>_115 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<13> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [13])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<13>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<12>_115 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<13> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<13>_113 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<12>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<11>_117 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<12> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [12])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<12>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<11>_117 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<12> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<12>_115 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<11>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<10>_119 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<11> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [11])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<11>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<10>_119 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<11> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<11>_117 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<10>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<9>_121 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<10> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [10])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<10>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<9>_121 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<10> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<10>_119 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<9>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<8>_123 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<9> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [9])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<9>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<8>_123 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<9> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<9>_121 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<8>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<7>_125 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<8> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [8])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<8>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<7>_125 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<8> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<8>_123 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<7>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<6>_127 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<7> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [7])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<7>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<6>_127 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<7> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<7>_125 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<6>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<5>_129 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<6> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [6])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<6>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<5>_129 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<6> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<6>_127 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<5>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<4>_131 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<5> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [5])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<5>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<4>_131 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<5> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<5>_129 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<4>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<3>_133 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<4> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [4])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<4>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<3>_133 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<4> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<4>_131 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<3>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<2>_135 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<3> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [3])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<3>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<2>_135 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<3> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<3>_133 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<2>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<1>_137 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<2> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [2])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<2>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<1>_137 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<2> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<2>_135 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<1>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_139 ),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<1> ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [1])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<1>  (
    .CI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_139 ),
    .DI(N1),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<1> ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<1>_137 )
  );
  XORCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_xor<0>  (
    .CI(N1),
    .LI(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_rt_227 ),
    .O(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [0])
  );
  MUXCY   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>  (
    .CI(N1),
    .DI(N0),
    .S(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_rt_227 ),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_139 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \dbreq/state_reg_FSM_FFd2  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/sw_reg2_182 ),
    .Q(\dbreq/state_reg_FSM_FFd2_181 )
  );
  FDC #(
    .INIT ( 1'b0 ))
  \dbreq/state_reg_FSM_FFd1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/state_reg_FSM_FFd1-In ),
    .Q(\dbreq/state_reg_FSM_FFd1_20 )
  );
  FDC   \dbreq/q_reg_19  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [19]),
    .Q(\dbreq/q_reg [19])
  );
  FDC   \dbreq/q_reg_18  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [18]),
    .Q(\dbreq/q_reg [18])
  );
  FDC   \dbreq/q_reg_17  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [17]),
    .Q(\dbreq/q_reg [17])
  );
  FDC   \dbreq/q_reg_16  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [16]),
    .Q(\dbreq/q_reg [16])
  );
  FDC   \dbreq/q_reg_15  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [15]),
    .Q(\dbreq/q_reg [15])
  );
  FDC   \dbreq/q_reg_14  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [14]),
    .Q(\dbreq/q_reg [14])
  );
  FDC   \dbreq/q_reg_13  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [13]),
    .Q(\dbreq/q_reg [13])
  );
  FDC   \dbreq/q_reg_12  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [12]),
    .Q(\dbreq/q_reg [12])
  );
  FDC   \dbreq/q_reg_11  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [11]),
    .Q(\dbreq/q_reg [11])
  );
  FDC   \dbreq/q_reg_10  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [10]),
    .Q(\dbreq/q_reg [10])
  );
  FDC   \dbreq/q_reg_9  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [9]),
    .Q(\dbreq/q_reg [9])
  );
  FDC   \dbreq/q_reg_8  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [8]),
    .Q(\dbreq/q_reg [8])
  );
  FDC   \dbreq/q_reg_7  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [7]),
    .Q(\dbreq/q_reg [7])
  );
  FDC   \dbreq/q_reg_6  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [6]),
    .Q(\dbreq/q_reg [6])
  );
  FDC   \dbreq/q_reg_5  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [5]),
    .Q(\dbreq/q_reg [5])
  );
  FDC   \dbreq/q_reg_4  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [4]),
    .Q(\dbreq/q_reg [4])
  );
  FDC   \dbreq/q_reg_3  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [3]),
    .Q(\dbreq/q_reg [3])
  );
  FDC   \dbreq/q_reg_2  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [2]),
    .Q(\dbreq/q_reg [2])
  );
  FDC   \dbreq/q_reg_1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [1]),
    .Q(\dbreq/q_reg [1])
  );
  FDC   \dbreq/q_reg_0  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/q_next [0]),
    .Q(\dbreq/q_reg [0])
  );
  FDC   \dbreq/sw_reg2  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/sw_reg1_183 ),
    .Q(\dbreq/sw_reg2_182 )
  );
  FDC   \dbreq/sw_reg1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(req_IBUF_10),
    .Q(\dbreq/sw_reg1_183 )
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<0>1  (
    .I0(\u1/reg_b/data_out [1]),
    .I1(\u1/reg_a/data_out [1]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [1])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<1>1  (
    .I0(\u1/reg_b/data_out [2]),
    .I1(\u1/reg_a/data_out [2]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [2])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<2>1  (
    .I0(\u1/reg_b/data_out [3]),
    .I1(\u1/reg_a/data_out [3]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [3])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<3>1  (
    .I0(\u1/reg_b/data_out [4]),
    .I1(\u1/reg_a/data_out [4]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [4])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<4>1  (
    .I0(\u1/reg_b/data_out [5]),
    .I1(\u1/reg_a/data_out [5]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [5])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \u1/alu1/Mmux_i_C1_A<5>1  (
    .I0(\u1/reg_b/data_out [6]),
    .I1(\u1/reg_a/data_out [6]),
    .I2(\u1/state_FSM_FFd2_66 ),
    .O(\u1/alu1/Mmux_i_C1_rs_A [6])
  );
  LUT3 #(
    .INIT ( 8'hD8 ))
  \u1/alu1/Mmux_i_C1_A<6>1  (
    .I0(\u1/state_FSM_FFd2_66 ),
    .I1(\u1/reg_b/data_out [7]),
    .I2(\u1/reg_a/data_out [7]),
    .O(\u1/alu1/Mmux_i_C1_rs_A [7])
  );
  LUT3 #(
    .INIT ( 8'hD8 ))
  \u1/alu1/Mmux_i_C1_A<7>1  (
    .I0(\u1/state_FSM_FFd2_66 ),
    .I1(\u1/reg_b/data_out [8]),
    .I2(\u1/reg_a/data_out [8]),
    .O(\u1/alu1/Mmux_i_C1_rs_A [8])
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \u1/state__n0055<1>1  (
    .I0(\u1/state_FSM_FFd3_84 ),
    .I1(\u1/state_FSM_FFd9_79 ),
    .O(\u1/LDA )
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \u1/state__n0055<2>1  (
    .I0(\u1/state_FSM_FFd1_67 ),
    .I1(\u1/state_FSM_FFd8_80 ),
    .O(ack_OBUF_19)
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \u1/state__n0055<3>1  (
    .I0(\u1/state_FSM_FFd2_66 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .O(\u1/LDB )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \u1/state_FSM_FFd9-In1  (
    .I0(\dbreq/state_reg_FSM_FFd1_20 ),
    .I1(\u1/state_FSM_FFd10_78 ),
    .O(\u1/state_FSM_FFd9-In )
  );
  LUT3 #(
    .INIT ( 8'hEA ))
  \u1/state_FSM_FFd8-In1  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\dbreq/state_reg_FSM_FFd1_20 ),
    .I2(\u1/state_FSM_FFd8_80 ),
    .O(\u1/state_FSM_FFd8-In )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \u1/state_FSM_FFd6-In1  (
    .I0(\dbreq/state_reg_FSM_FFd1_20 ),
    .I1(\u1/state_FSM_FFd7_81 ),
    .O(\u1/state_FSM_FFd6-In )
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \u1/state_FSM_FFd5-In1  (
    .I0(\u1/state_FSM_FFd3_84 ),
    .I1(\u1/state_FSM_FFd2_66 ),
    .I2(\u1/state_FSM_FFd6_82 ),
    .O(\u1/state_FSM_FFd5-In )
  );
  LUT3 #(
    .INIT ( 8'h08 ))
  \u1/state_FSM_FFd2-In1  (
    .I0(\u1/state_FSM_FFd4_83 ),
    .I1(\u1/alu1/Mmux_i_C1_split [9]),
    .I2(\u1/state_FSM_FFd1_67 ),
    .O(\u1/state_FSM_FFd2-In )
  );
  LUT3 #(
    .INIT ( 8'h54 ))
  \u1/state_FSM_FFd10-In1  (
    .I0(\dbreq/state_reg_FSM_FFd1_20 ),
    .I1(\u1/state_FSM_FFd1_67 ),
    .I2(\u1/state_FSM_FFd10_78 ),
    .O(\u1/state_FSM_FFd10-In )
  );
  LUT3 #(
    .INIT ( 8'h54 ))
  \u1/state_FSM_FFd7-In1  (
    .I0(\dbreq/state_reg_FSM_FFd1_20 ),
    .I1(\u1/state_FSM_FFd7_81 ),
    .I2(\u1/state_FSM_FFd8_80 ),
    .O(\u1/state_FSM_FFd7-In )
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out11  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [1]),
    .I4(\u1/reg_a/data_out [1]),
    .I5(AB_0_IBUF_7),
    .O(\u1/C_int [0])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out21  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [2]),
    .I4(\u1/reg_a/data_out [2]),
    .I5(AB_1_IBUF_6),
    .O(\u1/C_int [1])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out31  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [3]),
    .I4(\u1/reg_a/data_out [3]),
    .I5(AB_2_IBUF_5),
    .O(\u1/C_int [2])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out41  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [4]),
    .I4(\u1/reg_a/data_out [4]),
    .I5(AB_3_IBUF_4),
    .O(\u1/C_int [3])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out51  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [5]),
    .I4(\u1/reg_a/data_out [5]),
    .I5(AB_4_IBUF_3),
    .O(\u1/C_int [4])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out61  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [6]),
    .I4(\u1/reg_a/data_out [6]),
    .I5(AB_5_IBUF_2),
    .O(\u1/C_int [5])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out71  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [7]),
    .I4(\u1/reg_a/data_out [7]),
    .I5(AB_6_IBUF_1),
    .O(\u1/C_int [6])
  );
  LUT6 #(
    .INIT ( 64'hFFFEEFEE11100100 ))
  \u1/mux1/Mmux_data_out81  (
    .I0(\u1/state_FSM_FFd9_79 ),
    .I1(\u1/state_FSM_FFd6_82 ),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\u1/alu1/Mmux_i_C1_split [8]),
    .I4(\u1/reg_a/data_out [8]),
    .I5(AB_7_IBUF_0),
    .O(\u1/C_int [7])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next91  (
    .I0(\dbreq/q_reg [17]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [17]),
    .O(\dbreq/q_next [17])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next81  (
    .I0(\dbreq/q_reg [16]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [16]),
    .O(\dbreq/q_next [16])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next71  (
    .I0(\dbreq/q_reg [15]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [15]),
    .O(\dbreq/q_next [15])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next61  (
    .I0(\dbreq/q_reg [14]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [14]),
    .O(\dbreq/q_next [14])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next51  (
    .I0(\dbreq/q_reg [13]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [13]),
    .O(\dbreq/q_next [13])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next41  (
    .I0(\dbreq/q_reg [12]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [12]),
    .O(\dbreq/q_next [12])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next31  (
    .I0(\dbreq/q_reg [11]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [11]),
    .O(\dbreq/q_next [11])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next201  (
    .I0(\dbreq/q_reg [9]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [9]),
    .O(\dbreq/q_next [9])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next21  (
    .I0(\dbreq/q_reg [10]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [10]),
    .O(\dbreq/q_next [10])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next191  (
    .I0(\dbreq/q_reg [8]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [8]),
    .O(\dbreq/q_next [8])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next181  (
    .I0(\dbreq/q_reg [7]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [7]),
    .O(\dbreq/q_next [7])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next171  (
    .I0(\dbreq/q_reg [6]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [6]),
    .O(\dbreq/q_next [6])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next161  (
    .I0(\dbreq/q_reg [5]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [5]),
    .O(\dbreq/q_next [5])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next151  (
    .I0(\dbreq/q_reg [4]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [4]),
    .O(\dbreq/q_next [4])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next141  (
    .I0(\dbreq/q_reg [3]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [3]),
    .O(\dbreq/q_next [3])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next131  (
    .I0(\dbreq/q_reg [2]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [2]),
    .O(\dbreq/q_next [2])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next121  (
    .I0(\dbreq/q_reg [1]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [1]),
    .O(\dbreq/q_next [1])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next111  (
    .I0(\dbreq/q_reg [19]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [19]),
    .O(\dbreq/q_next [19])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next101  (
    .I0(\dbreq/q_reg [18]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [18]),
    .O(\dbreq/q_next [18])
  );
  LUT5 #(
    .INIT ( 32'hAFFAAC3A ))
  \dbreq/Mmux_q_next11  (
    .I0(\dbreq/q_reg [0]),
    .I1(\dbreq/state_reg_FSM_FFd2_181 ),
    .I2(\dbreq/sw_reg2_182 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [0]),
    .O(\dbreq/q_next [0])
  );
  LUT6 #(
    .INIT ( 64'h0000000100000000 ))
  \u1/alu1/Z1  (
    .I0(\u1/reg_a/data_out [7]),
    .I1(\u1/reg_a/data_out [8]),
    .I2(\u1/reg_a/data_out [6]),
    .I3(\u1/reg_a/data_out [4]),
    .I4(\u1/reg_a/data_out [2]),
    .I5(\u1/state_FSM_FFd1_67 ),
    .O(\u1/alu1/Z )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \u1/alu1/Z3  (
    .I0(\u1/alu1/Mmux_i_C1_split [1]),
    .I1(\u1/state_FSM_FFd1_67 ),
    .I2(\u1/alu1/Mmux_i_C1_split [2]),
    .I3(\u1/alu1/Mmux_i_C1_split [3]),
    .I4(\u1/alu1/Mmux_i_C1_split [4]),
    .I5(\u1/alu1/Mmux_i_C1_split [5]),
    .O(\u1/alu1/Z2 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000009 ))
  \dbreq/q_zero<19>1  (
    .I0(\dbreq/sw_reg2_1_239 ),
    .I1(\dbreq/state_reg_FSM_FFd1_1_238 ),
    .I2(\dbreq/q_reg [6]),
    .I3(\dbreq/q_reg [7]),
    .I4(\dbreq/q_reg [8]),
    .I5(\dbreq/q_reg [9]),
    .O(\dbreq/q_zero [19])
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \dbreq/q_zero<19>2  (
    .I0(\dbreq/q_reg [4]),
    .I1(\dbreq/q_reg [5]),
    .I2(\dbreq/q_reg [3]),
    .I3(\dbreq/q_reg [2]),
    .I4(\dbreq/q_reg [1]),
    .I5(\dbreq/q_reg [19]),
    .O(\dbreq/q_zero<19>1_207 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \dbreq/q_zero<19>3  (
    .I0(\dbreq/q_reg [17]),
    .I1(\dbreq/q_reg [18]),
    .I2(\dbreq/q_reg [16]),
    .I3(\dbreq/q_reg [15]),
    .I4(\dbreq/q_reg [14]),
    .I5(\dbreq/q_reg [13]),
    .O(\dbreq/q_zero<19>2_208 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \dbreq/q_zero<19>4  (
    .I0(\dbreq/q_reg [11]),
    .I1(\dbreq/q_reg [12]),
    .I2(\dbreq/q_reg [10]),
    .I3(\dbreq/q_reg [0]),
    .O(\dbreq/q_zero<19>3_209 )
  );
  LUT4 #(
    .INIT ( 16'h8000 ))
  \dbreq/q_zero<19>5  (
    .I0(\dbreq/q_zero<19>3_209 ),
    .I1(\dbreq/q_zero [19]),
    .I2(\dbreq/q_zero<19>2_208 ),
    .I3(\dbreq/q_zero<19>1_207 ),
    .O(\dbreq/q_zero<19>4_210 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000001 ))
  \dbreq/q_zero<19>6  (
    .I0(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [4]),
    .I1(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [3]),
    .I2(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [5]),
    .I3(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [6]),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [7]),
    .I5(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [8]),
    .O(\dbreq/q_zero<19>5_211 )
  );
  LUT6 #(
    .INIT ( 64'h0000000000000018 ))
  \dbreq/q_zero<19>7  (
    .I0(\dbreq/state_reg_FSM_FFd2_181 ),
    .I1(\dbreq/sw_reg2_182 ),
    .I2(\dbreq/state_reg_FSM_FFd1_20 ),
    .I3(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [0]),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [1]),
    .I5(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [2]),
    .O(\dbreq/q_zero<19>6_212 )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \dbreq/q_zero<19>8  (
    .I0(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [10]),
    .I1(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [9]),
    .I2(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [11]),
    .I3(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [12]),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [13]),
    .O(\dbreq/q_zero<19>7_213 )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \dbreq/q_zero<19>9  (
    .I0(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [15]),
    .I1(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [14]),
    .I2(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [16]),
    .I3(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [17]),
    .I4(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [18]),
    .O(\dbreq/q_zero<19>8_214 )
  );
  IBUF   AB_7_IBUF (
    .I(AB[7]),
    .O(AB_7_IBUF_0)
  );
  IBUF   AB_6_IBUF (
    .I(AB[6]),
    .O(AB_6_IBUF_1)
  );
  IBUF   AB_5_IBUF (
    .I(AB[5]),
    .O(AB_5_IBUF_2)
  );
  IBUF   AB_4_IBUF (
    .I(AB[4]),
    .O(AB_4_IBUF_3)
  );
  IBUF   AB_3_IBUF (
    .I(AB[3]),
    .O(AB_3_IBUF_4)
  );
  IBUF   AB_2_IBUF (
    .I(AB[2]),
    .O(AB_2_IBUF_5)
  );
  IBUF   AB_1_IBUF (
    .I(AB[1]),
    .O(AB_1_IBUF_6)
  );
  IBUF   AB_0_IBUF (
    .I(AB[0]),
    .O(AB_0_IBUF_7)
  );
  IBUF   reset_IBUF (
    .I(reset),
    .O(reset_IBUF_9)
  );
  IBUF   req_IBUF (
    .I(req),
    .O(req_IBUF_10)
  );
  OBUFT   C_7_OBUFT (
    .I(\u1/C_int [7]),
    .T(\u1/tribuf/en_inv ),
    .O(C[7])
  );
  OBUFT   C_6_OBUFT (
    .I(\u1/C_int [6]),
    .T(\u1/tribuf/en_inv ),
    .O(C[6])
  );
  OBUFT   C_5_OBUFT (
    .I(\u1/C_int [5]),
    .T(\u1/tribuf/en_inv ),
    .O(C[5])
  );
  OBUFT   C_4_OBUFT (
    .I(\u1/C_int [4]),
    .T(\u1/tribuf/en_inv ),
    .O(C[4])
  );
  OBUFT   C_3_OBUFT (
    .I(\u1/C_int [3]),
    .T(\u1/tribuf/en_inv ),
    .O(C[3])
  );
  OBUFT   C_2_OBUFT (
    .I(\u1/C_int [2]),
    .T(\u1/tribuf/en_inv ),
    .O(C[2])
  );
  OBUFT   C_1_OBUFT (
    .I(\u1/C_int [1]),
    .T(\u1/tribuf/en_inv ),
    .O(C[1])
  );
  OBUFT   C_0_OBUFT (
    .I(\u1/C_int [0]),
    .T(\u1/tribuf/en_inv ),
    .O(C[0])
  );
  OBUF   ack_OBUF (
    .I(ack_OBUF_19),
    .O(ack)
  );
  LUT1 #(
    .INIT ( 2'h2 ))
  \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_rt  (
    .I0(\dbreq/q_reg [0]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_cy<0>_rt_227 )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<0>  (
    .I0(\u1/reg_b/data_out [1]),
    .I1(\u1/reg_a/data_out [1]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [0])
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<1>  (
    .I0(\u1/reg_b/data_out [2]),
    .I1(\u1/reg_a/data_out [2]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [1])
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<2>  (
    .I0(\u1/reg_b/data_out [3]),
    .I1(\u1/reg_a/data_out [3]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [2])
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<3>  (
    .I0(\u1/reg_b/data_out [4]),
    .I1(\u1/reg_a/data_out [4]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [3])
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<4>  (
    .I0(\u1/reg_b/data_out [5]),
    .I1(\u1/reg_a/data_out [5]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [4])
  );
  LUT6 #(
    .INIT ( 64'hFF01FE00FF00FF00 ))
  \u1/state_FSM_FFd1-In1  (
    .I0(\u1/alu1/Mmux_i_C1_split [7]),
    .I1(\u1/alu1/Mmux_i_C1_split [8]),
    .I2(\u1/alu1/Mmux_i_C1_split [9]),
    .I3(N01),
    .I4(N11),
    .I5(\u1/alu1/Z2 ),
    .O(\u1/state_FSM_FFd1-In )
  );
  LUT6 #(
    .INIT ( 64'h00AC03AF00AF00AF ))
  \u1/state_FSM_FFd3-In1  (
    .I0(\u1/state_FSM_FFd1_67 ),
    .I1(\u1/alu1/Mmux_i_C1_split [8]),
    .I2(\u1/alu1/Mmux_i_C1_split [9]),
    .I3(N3),
    .I4(N4),
    .I5(\u1/alu1/Z2 ),
    .O(\u1/state_FSM_FFd3-In )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<5>  (
    .I0(\u1/reg_b/data_out [6]),
    .I1(\u1/reg_a/data_out [6]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [5])
  );
  LUT5 #(
    .INIT ( 32'hE8E8F0E8 ))
  \dbreq/q_zero<19>10_SW1  (
    .I0(\dbreq/state_reg_FSM_FFd2_181 ),
    .I1(\dbreq/sw_reg2_182 ),
    .I2(\dbreq/state_reg_FSM_FFd1_20 ),
    .I3(\dbreq/GND_18_o_GND_18_o_sub_3_OUT [19]),
    .I4(\dbreq/q_zero<19>4_210 ),
    .O(N7)
  );
  LUT6 #(
    .INIT ( 64'hEAAAAAAA2AAAAAAA ))
  \dbreq/state_reg_FSM_FFd1-In1  (
    .I0(N6),
    .I1(\dbreq/q_zero<19>8_214 ),
    .I2(\dbreq/q_zero<19>7_213 ),
    .I3(\dbreq/q_zero<19>5_211 ),
    .I4(\dbreq/q_zero<19>6_212 ),
    .I5(N7),
    .O(\dbreq/state_reg_FSM_FFd1-In )
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<6>  (
    .I0(\u1/reg_b/data_out [7]),
    .I1(\u1/reg_a/data_out [7]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [6])
  );
  LUT5 #(
    .INIT ( 32'h55575555 ))
  \u1/alu1/Z4_SW2  (
    .I0(\u1/state_FSM_FFd4_83 ),
    .I1(\u1/reg_a/data_out [5]),
    .I2(\u1/reg_a/data_out [3]),
    .I3(\u1/reg_a/data_out [1]),
    .I4(\u1/alu1/Z ),
    .O(N3)
  );
  LUT2 #(
    .INIT ( 4'hD ))
  \u1/alu1/Z2_SW0  (
    .I0(\u1/state_FSM_FFd4_83 ),
    .I1(\u1/reg_a/data_out [5]),
    .O(N9)
  );
  LUT6 #(
    .INIT ( 64'hF000F111F000F000 ))
  \u1/alu1/Z4_SW0  (
    .I0(\u1/reg_a/data_out [3]),
    .I1(\u1/reg_a/data_out [1]),
    .I2(\u1/state_FSM_FFd1_67 ),
    .I3(\dbreq/state_reg_FSM_FFd1_20 ),
    .I4(N9),
    .I5(\u1/alu1/Z ),
    .O(N01)
  );
  LUT3 #(
    .INIT ( 8'hE8 ))
  \dbreq/q_zero<19>5_SW0  (
    .I0(\dbreq/state_reg_FSM_FFd2_181 ),
    .I1(\dbreq/sw_reg2_182 ),
    .I2(\dbreq/state_reg_FSM_FFd1_20 ),
    .O(N111)
  );
  LUT6 #(
    .INIT ( 64'hEAAAAAAA2AAAAAAA ))
  \dbreq/q_zero<19>10_SW0  (
    .I0(\dbreq/state_reg_FSM_FFd1_20 ),
    .I1(\dbreq/q_zero<19>3_209 ),
    .I2(\dbreq/q_zero<19>2_208 ),
    .I3(\dbreq/q_zero<19>1_207 ),
    .I4(\dbreq/q_zero [19]),
    .I5(N111),
    .O(N6)
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \u1/alu1/Z2_SW1  (
    .I0(\u1/reg_a/data_out [1]),
    .I1(\u1/reg_a/data_out [3]),
    .I2(\u1/reg_a/data_out [5]),
    .O(N13)
  );
  LUT6 #(
    .INIT ( 64'hC0EAC0C0EAEAEAEA ))
  \u1/alu1/Z4_SW1  (
    .I0(\u1/state_FSM_FFd4_83 ),
    .I1(\u1/state_FSM_FFd1_67 ),
    .I2(\dbreq/state_reg_FSM_FFd1_20 ),
    .I3(N13),
    .I4(\u1/alu1/Z ),
    .I5(\u1/alu1/Mmux_i_C1_split [6]),
    .O(N11)
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \u1/alu1/Z2_SW2  (
    .I0(\u1/reg_a/data_out [3]),
    .I1(\u1/reg_a/data_out [5]),
    .O(N15)
  );
  LUT6 #(
    .INIT ( 64'h575557555755FFFF ))
  \u1/alu1/Z4_SW3  (
    .I0(\u1/state_FSM_FFd4_83 ),
    .I1(\u1/reg_a/data_out [1]),
    .I2(N15),
    .I3(\u1/alu1/Z ),
    .I4(\u1/alu1/Mmux_i_C1_split [6]),
    .I5(\u1/alu1/Mmux_i_C1_split [7]),
    .O(N4)
  );
  LUT2 #(
    .INIT ( 4'h9 ))
  \u1/alu1/Mmux_i_C1_rs_lut<7>  (
    .I0(\u1/reg_b/data_out [8]),
    .I1(\u1/reg_a/data_out [8]),
    .O(\u1/alu1/Mmux_i_C1_rs_lut [7])
  );
  FDC #(
    .INIT ( 1'b0 ))
  \dbreq/state_reg_FSM_FFd1_1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/state_reg_FSM_FFd1-In ),
    .Q(\dbreq/state_reg_FSM_FFd1_1_238 )
  );
  FDC   \dbreq/sw_reg2_1  (
    .C(clk_BUFGP_8),
    .CLR(reset_IBUF_9),
    .D(\dbreq/sw_reg1_183 ),
    .Q(\dbreq/sw_reg2_1_239 )
  );
  BUFGP   clk_BUFGP (
    .I(clk),
    .O(clk_BUFGP_8)
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<19>_INV_0  (
    .I(\dbreq/q_reg [19]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<19> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<18>_INV_0  (
    .I(\dbreq/q_reg [18]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<18> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<17>_INV_0  (
    .I(\dbreq/q_reg [17]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<17> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<16>_INV_0  (
    .I(\dbreq/q_reg [16]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<16> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<15>_INV_0  (
    .I(\dbreq/q_reg [15]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<15> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<14>_INV_0  (
    .I(\dbreq/q_reg [14]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<14> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<13>_INV_0  (
    .I(\dbreq/q_reg [13]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<13> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<12>_INV_0  (
    .I(\dbreq/q_reg [12]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<12> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<11>_INV_0  (
    .I(\dbreq/q_reg [11]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<11> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<10>_INV_0  (
    .I(\dbreq/q_reg [10]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<10> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<9>_INV_0  (
    .I(\dbreq/q_reg [9]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<9> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<8>_INV_0  (
    .I(\dbreq/q_reg [8]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<8> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<7>_INV_0  (
    .I(\dbreq/q_reg [7]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<7> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<6>_INV_0  (
    .I(\dbreq/q_reg [6]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<6> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<5>_INV_0  (
    .I(\dbreq/q_reg [5]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<5> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<4>_INV_0  (
    .I(\dbreq/q_reg [4]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<4> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<3>_INV_0  (
    .I(\dbreq/q_reg [3]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<3> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<2>_INV_0  (
    .I(\dbreq/q_reg [2]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<2> )
  );
  INV   \dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<1>_INV_0  (
    .I(\dbreq/q_reg [1]),
    .O(\dbreq/Msub_GND_18_o_GND_18_o_sub_3_OUT<19:0>_lut<1> )
  );
  INV   \u1/tribuf/en_inv1_INV_0  (
    .I(\u1/state_FSM_FFd1_67 ),
    .O(\u1/tribuf/en_inv )
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

