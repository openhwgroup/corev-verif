(VRV32M Division Operations
p0
ccopy_reg
_reconstructor
p1
(cvp_pack
Ip
p2
c__builtin__
object
p3
Ntp4
Rp5
(dp6
Vprop_count
p7
I4
sVname
p8
g0
sVprop_list
p9
(dp10
sVip_num
p11
I7
sVwid_order
p12
I7
sVrfu_dict
p13
(dp14
sVrfu_list
p15
(lp16
(V000_DIV
p17
g1
(cvp_pack
Prop
p18
g3
Ntp19
Rp20
(dp21
Vitem_count
p22
I4
sg8
g17
sVtag
p23
VVP_IP007_P000
p24
sVitem_list
p25
(dp26
sg12
I0
sg15
(lp27
(V000
p28
g1
(cvp_pack
Item
p29
g3
Ntp30
Rp31
(dp32
g8
V000
p33
sg23
VVP_IP007_P000_I000
p34
sVdescription
p35
Vdiv rd, rs1, rs2\u000ax[rd] = x[rs1] / x[rs2]\u000ard is calculated using signed arithmetic; rounding towards zero
p36
sVpurpose
p37
VUnprivileged ISA\u000aChapter 7.2
p38
sVverif_goals
p39
VRegister operands:\u000a\u000aAll possible rs1 registers are used.\u000aAll possible rs2 registers are used.\u000aAll possible rd registers are used.\u000aAll possible register combinations where rs1 == rd are used\u000aAll possible register combinations where rs2 == rd are used
p40
sVcoverage_loc
p41
Visacov.rv32m_div_cg.cp_rs1\u000aisacov.rv32m_div_cg.cp_rs2\u000aisacov.rv32m_div_cg.cp_rd\u000aisacov.rv32m_div_cg.cp_rd_rs1_hazard\u000aisacov.rv32m_div_cg.cp_rd_rs2_hazard
p42
sVpfc
p43
I3
sVtest_type
p44
I3
sVcov_method
p45
I1
sVcores
p46
I56
sVcomments
p47
V
p48
sVstatus
p49
g48
sVsimu_target_list
p50
(lp51
sg15
(lp52
sVrfu_list_2
p53
(lp54
sg13
(dp55
Vlock_status
p56
I0
ssbtp57
a(V001
p58
g1
(g29
g3
Ntp59
Rp60
(dp61
g8
V001
p62
sg23
VVP_IP007_P000_I001
p63
sg35
Vdiv rd, rs1, rs2\u000ax[rd] = x[rs1] / x[rs2]\u000ard is calculated using signed arithmetic; rounding towards zero
p64
sg37
VUnprivileged ISA\u000aChapter 7.2
p65
sg39
VInput operands:\u000a\u000ars1 value is +ve, -ve and zero\u000ars2 value is +ve, -ve and zero\u000aAll combinations of rs1 and rs2 +ve, -ve, and zero values are used\u000aAll bits of rs1 are toggled\u000aAll bits of rs2 are toggled
p66
sg41
Visacov.rv32m_div_cg.cp_rs1_value\u000aisacov.rv32m_div_cg.cp_rs2_value\u000aisacov.rv32m_div_cg.cross_rs1_rs2_value\u000aisacov.rv32m_div_cg.cp_rs1_toggle \u000aisacov.rv32m_div_cg.cp_rs2_toggle
p67
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp68
sg15
(lp69
sg53
(lp70
sg13
(dp71
g56
I0
ssbtp72
a(V002
p73
g1
(g29
g3
Ntp74
Rp75
(dp76
g8
V002
p77
sg23
VVP_IP007_P000_I002
p78
sg35
Vdiv rd, rs1, rs2\u000ax[rd] = x[rs1] / x[rs2]\u000ard is calculated using signed arithmetic; rounding towards zero
p79
sg37
VUnprivileged ISA\u000aChapter 7.2
p80
sg39
VOutput result:\u000a\u000ard value is +ve, -ve and zero\u000aAll bits of rd are toggled
p81
sg41
Visacov.rv32m_div_cg.cp_rs1_value\u000aisacov.rv32m_div_cg.cp_rs2_value\u000aisacov.rv32m_div_cg.cross_rs1_rs2_value\u000aisacov.rv32m_div_cg.cp_rs1_toggle \u000aisacov.rv32m_div_cg.cp_rs2_toggle
p82
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp83
sg15
(lp84
sg53
(lp85
sg13
(dp86
g56
I0
ssbtp87
a(V003
p88
g1
(g29
g3
Ntp89
Rp90
(dp91
g8
V003
p92
sg23
VVP_IP007_P000_I003
p93
sg35
Vdiv rd, rs1, rs2\u000ax[rd] = x[rs1] / x[rs2]\u000ard is calculated using signed arithmetic; rounding towards zero
p94
sg37
VUnprivileged ISA\u000aChapter 7.2
p95
sg39
VExercise arithmetic overflow (rs1 = -2^31; rs2 = -1; returns rd = -2^31).\u000aExercise division by zero (returns -1 ; all bits set)
p96
sg41
Visacov.rv32m_div_results_cg.cp_div_special_results\u000aisacov.rv32m_div_results_cg.cp_div_arithmetic_overflow
p97
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp98
sg15
(lp99
sg53
(lp100
sg13
(dp101
g56
I0
ssbtp102
asVrfu_list_1
p103
(lp104
sg53
(lp105
sg13
(dp106
sbtp107
a(V001_REM
p108
g1
(g18
g3
Ntp109
Rp110
(dp111
g22
I4
sg8
g108
sg23
VVP_IP007_P001
p112
sg25
(dp113
sg12
I1
sg15
(lp114
(V000
p115
g1
(g29
g3
Ntp116
Rp117
(dp118
g8
V000
p119
sg23
VVP_IP007_P001_I000
p120
sg35
Vrem rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using signed arithmetic; remainder from the same division than DIV (the sign of rd equals the sign of rs1)
p121
sg37
VUnprivileged ISA\u000aChapter 7.2
p122
sg39
VRegister operands:\u000a\u000aAll possible rs1 registers are used.\u000aAll possible rs2 registers are used.\u000aAll possible rd registers are used.\u000aAll possible register combinations where rs1 == rd are used\u000aAll possible register combinations where rs2 == rd are used
p123
sg41
Visacov.rv32m_rem_cg.cp_rs1\u000aisacov.rv32m_rem_cg.cp_rs2\u000aisacov.rv32m_rem_cg.cp_rd\u000aisacov.rv32m_rem_cg.cp_rd_rs1_hazard\u000aisacov.rv32m_rem_cg.cp_rd_rs2_hazard
p124
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp125
sg15
(lp126
sg53
(lp127
sg13
(dp128
g56
I0
ssbtp129
a(V001
p130
g1
(g29
g3
Ntp131
Rp132
(dp133
g8
V001
p134
sg23
VVP_IP007_P001_I001
p135
sg35
Vrem rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using signed arithmetic; remainder from the same division than DIV (the sign of rd equals the sign of rs1)
p136
sg37
VUnprivileged ISA\u000aChapter 7.2
p137
sg39
VInput operands:\u000a\u000ars1 value is +ve, -ve and zero\u000ars2 value is +ve, -ve and zero\u000aAll combinations of rs1 and rs2 +ve, -ve, and zero values are used\u000aAll bits of rs1 are toggled\u000aAll bits of rs2 are toggled
p138
sg41
Visacov.rv32m_rem_cg.cp_rs1_value\u000aisacov.rv32m_rem_cg.cp_rs2_value\u000aisacov.rv32m_rem_cg.cross_rs1_rs2_value\u000aisacov.rv32m_rem_cg.cp_rs1_toggle \u000aisacov.rv32m_rem_cg.cp_rs2_toggle
p139
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp140
sg15
(lp141
sg53
(lp142
sg13
(dp143
g56
I0
ssbtp144
a(V002
p145
g1
(g29
g3
Ntp146
Rp147
(dp148
g8
V002
p149
sg23
VVP_IP007_P001_I002
p150
sg35
Vrem rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using signed arithmetic; remainder from the same division than DIV (the sign of rd equals the sign of rs1)
p151
sg37
VUnprivileged ISA\u000aChapter 7.2
p152
sg39
VOutput result:\u000a\u000ard value is +ve, -ve and zero\u000aAll bits of rd are toggled
p153
sg41
Visacov.rv32m_rem_cg.cp_rd_value\u000aisacov.rv32m_rem_cg.cp_rd_toggle
p154
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp155
sg15
(lp156
sg53
(lp157
sg13
(dp158
g56
I0
ssbtp159
a(V003
p160
g1
(g29
g3
Ntp161
Rp162
(dp163
g8
V003
p164
sg23
VVP_IP007_P001_I003
p165
sg35
Vrem rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using signed arithmetic; remainder from the same division than DIV (the sign of rd equals the sign of rs1)
p166
sg37
VUnprivileged ISA\u000aChapter 7.2
p167
sg39
VExercise arithmetic overflow (rs1 = -2^31; rs2 = -1; returns rd = 0).\u000aExercise division by zero (returns rs1)
p168
sg41
Visacov.rv32m_rem_results_cg.cp_div_zero\u000aisacov.rv32m_rem_results_cg.cp_div_arithmetic_overflow
p169
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp170
sg15
(lp171
sg53
(lp172
sg13
(dp173
g56
I0
ssbtp174
asg103
(lp175
sg53
(lp176
sg13
(dp177
sbtp178
a(V002_DIVU
p179
g1
(g18
g3
Ntp180
Rp181
(dp182
g22
I4
sg8
g179
sg23
VVP_IP007_P002
p183
sg25
(dp184
sg12
I2
sg15
(lp185
(V000
p186
g1
(g29
g3
Ntp187
Rp188
(dp189
g8
V000
p190
sg23
VVP_IP007_P002_I000
p191
sg35
Vdivu rd, rs1, rs2\u000ax[rd] = x[rs1] u/ x[rs2]\u000ard is calculated using unsigned arithmetic; rounding towards zero
p192
sg37
VUnprivileged ISA\u000aChapter 7.2
p193
sg39
VRegister operands:\u000a\u000aAll possible rs1 registers are used.\u000aAll possible rs2 registers are used.\u000aAll possible rd registers are used.\u000aAll possible register combinations where rs1 == rd are used\u000aAll possible register combinations where rs2 == rd are used
p194
sg41
Visacov.rv32m_divu_cg.cp_rs1\u000aisacov.rv32m_divu_cg.cp_rs2\u000aisacov.rv32m_divu_cg.cp_rd\u000aisacov.rv32m_divu_cg.cp_rd_rs1_hazard\u000aisacov.rv32m_divu_cg.cp_rd_rs2_hazard
p195
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp196
sg15
(lp197
sg53
(lp198
sg13
(dp199
g56
I0
ssbtp200
a(V001
p201
g1
(g29
g3
Ntp202
Rp203
(dp204
g8
V001
p205
sg23
VVP_IP007_P002_I001
p206
sg35
Vdivu rd, rs1, rs2\u000ax[rd] = x[rs1] u/ x[rs2]\u000ard is calculated using unsigned arithmetic; rounding towards zero
p207
sg37
VUnprivileged ISA\u000aChapter 7.2
p208
sg39
VInput operands:\u000a\u000ars1 value is non-zero and zero\u000ars2 value is non-zero and zero\u000aAll combinations of rs1 and rs2 non-zero and zero values are used\u000aAll bits of rs1 are toggled\u000aAll bits of rs2 are toggled
p209
sg41
Visacov.rv32m_divu_cg.cp_rs1_value\u000aisacov.rv32m_divu_cg.cp_rs2_value\u000aisacov.rv32m_divu_cg.cross_rs1_rs2_value\u000aisacov.rv32m_divu_cg.cp_rs1_toggle \u000aisacov.rv32m_divu_cg.cp_rs2_toggle
p210
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp211
sg15
(lp212
sg53
(lp213
sg13
(dp214
g56
I0
ssbtp215
a(V002
p216
g1
(g29
g3
Ntp217
Rp218
(dp219
g8
V002
p220
sg23
VVP_IP007_P002_I002
p221
sg35
Vdivu rd, rs1, rs2\u000ax[rd] = x[rs1] u/ x[rs2]\u000ard is calculated using unsigned arithmetic; rounding towards zero
p222
sg37
VUnprivileged ISA\u000aChapter 7.2
p223
sg39
VOutput result:\u000a\u000ard value is non-zero and zero\u000aAll bits of rd are toggled
p224
sg41
Visacov.rv32m_divu_cg.cp_rd_value\u000aisacov.rv32m_divu_cg.cp_rd_toggle
p225
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp226
sg15
(lp227
sg53
(lp228
sg13
(dp229
g56
I0
ssbtp230
a(V003
p231
g1
(g29
g3
Ntp232
Rp233
(dp234
g8
V003
p235
sg23
VVP_IP007_P002_I003
p236
sg35
Vdivu rd, rs1, rs2\u000ax[rd] = x[rs1] u/ x[rs2]\u000ard is calculated using unsigned arithmetic; rounding towards zero
p237
sg37
VUnprivileged ISA\u000aChapter 7.2
p238
sg39
VExercise division by zero (returns 2^32-1 ; all bits set)
p239
sg41
Visacov.rv32m_divu_results_cg.cp_div_zero
p240
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp241
sg15
(lp242
sg53
(lp243
sg13
(dp244
g56
I0
ssbtp245
asg103
(lp246
sg53
(lp247
sg13
(dp248
sbtp249
a(V003_REMU
p250
g1
(g18
g3
Ntp251
Rp252
(dp253
g22
I4
sg8
g250
sg23
VVP_IP007_P003
p254
sg25
(dp255
sg12
I3
sg15
(lp256
(V000
p257
g1
(g29
g3
Ntp258
Rp259
(dp260
g8
V000
p261
sg23
VVP_IP007_P003_I000
p262
sg35
Vremu rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using unsigned arithmetic; remainder from the same division than DIVU
p263
sg37
VUnprivileged ISA\u000aChapter 7.2
p264
sg39
VRegister operands:\u000a\u000aAll possible rs1 registers are used.\u000aAll possible rs2 registers are used.\u000aAll possible rd registers are used.\u000aAll possible register combinations where rs1 == rd are used\u000aAll possible register combinations where rs2 == rd are used
p265
sg41
Visacov.rv32m_remu_cg.cp_rs1\u000aisacov.rv32m_remu_cg.cp_rs2\u000aisacov.rv32m_remu_cg.cp_rd\u000aisacov.rv32m_remu_cg.cp_rd_rs1_hazard\u000aisacov.rv32m_remu_cg.cp_rd_rs2_hazard
p266
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp267
sg15
(lp268
sg53
(lp269
sg13
(dp270
g56
I0
ssbtp271
a(V001
p272
g1
(g29
g3
Ntp273
Rp274
(dp275
g8
V001
p276
sg23
VVP_IP007_P003_I001
p277
sg35
Vremu rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using unsigned arithmetic; remainder from the same division than DIVU
p278
sg37
VUnprivileged ISA\u000aChapter 7.2
p279
sg39
VInput operands:\u000a\u000ars1 value is non-zero and zero\u000ars2 value is non-zero and zero\u000aAll combinations of rs1 and rs2 non-zero and zero values are used\u000aAll bits of rs1 are toggled\u000aAll bits of rs2 are toggled
p280
sg41
Visacov.rv32m_remu_cg.cp_rs1_value\u000aisacov.rv32m_remu_cg.cp_rs2_value\u000aisacov.rv32m_remu_cg.cross_rs1_rs2_value\u000aisacov.rv32m_remu_cg.cp_rs1_toggle \u000aisacov.rv32m_remu_cg.cp_rs2_toggle
p281
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp282
sg15
(lp283
sg53
(lp284
sg13
(dp285
g56
I0
ssbtp286
a(V002
p287
g1
(g29
g3
Ntp288
Rp289
(dp290
g8
V002
p291
sg23
VVP_IP007_P003_I002
p292
sg35
Vremu rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using unsigned arithmetic; remainder from the same division than DIVU
p293
sg37
VUnprivileged ISA\u000aChapter 7.2
p294
sg39
VOutput result:\u000a\u000ard value is non-zero and zero\u000aAll bits of rd are toggled
p295
sg41
Visacov.rv32m_remu_cg.cp_rd_value\u000aisacov.rv32m_remu_cg.cp_rd_toggle
p296
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp297
sg15
(lp298
sg53
(lp299
sg13
(dp300
g56
I0
ssbtp301
a(V003
p302
g1
(g29
g3
Ntp303
Rp304
(dp305
g8
V003
p306
sg23
VVP_IP007_P003_I003
p307
sg35
Vremu rd, rs1, rs2\u000ax[rd] = x[rs1] % x[rs2]\u000ard is calculated using unsigned arithmetic; remainder from the same division than DIVU
p308
sg37
VUnprivileged ISA\u000aChapter 7.2
p309
sg39
VExercise division by zero (returns rs1)
p310
sg41
Visacov.rv32m_remu_results_cg.cp_div_zero
p311
sg43
I3
sg44
I3
sg45
I1
sg46
I56
sg47
g48
sg49
g48
sg50
(lp312
sg15
(lp313
sg53
(lp314
sg13
(dp315
g56
I0
ssbtp316
asg103
(lp317
sg53
(lp318
sg13
(dp319
sbtp320
asVrfu_list_0
p321
(lp322
sg103
(lp323
sVvptool_gitrev
p324
V$Id$
p325
sbtp326
.