--- 
-- 玩家等级提升奖励表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.LevelUpXls
-- 

module("xls.LevelUpXls")

--- 
-- @type LevelUpXls
-- @field	#number	YuanBao	元宝	notNull
-- @field	#number	Physical	体力	notNull
-- @field	#number	Vigor	精力	notNull
-- @field	#number	Grade	人物等级	 
-- @field	#number	Cash	银两	notNull
-- 

--- 
-- LevelUpXls
-- @field [parent=#xls.LevelUpXls] #LevelUpXls LevelUpXls
-- 

--- 
-- data
-- @field [parent=#xls.LevelUpXls] #table data Grade -> @{LevelUpXls}表
-- 
data = 
{
	[1] = {
		["YuanBao"] = 0,
		["Grade"] = 1,
		["Cash"] = 1000,
	},
	[2] = {
		["YuanBao"] = 0,
		["Grade"] = 2,
		["Cash"] = 2462,
	},
	[3] = {
		["YuanBao"] = 0,
		["Grade"] = 3,
		["Cash"] = 4171,
	},
	[4] = {
		["YuanBao"] = 0,
		["Grade"] = 4,
		["Cash"] = 6062,
	},
	[5] = {
		["YuanBao"] = 0,
		["Grade"] = 5,
		["Cash"] = 8103,
	},
	[6] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 6,
		["Cash"] = 10270,
	},
	[7] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 7,
		["Cash"] = 12549,
	},
	[8] = {
		["YuanBao"] = 0,
		["Physical"] = 2,
		["Vigor"] = 2,
		["Grade"] = 8,
		["Cash"] = 14928,
	},
	[9] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 9,
		["Cash"] = 17398,
	},
	[10] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 10,
		["Cash"] = 19952,
	},
	[11] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 11,
		["Cash"] = 22584,
	},
	[12] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 12,
		["Cash"] = 25289,
	},
	[13] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 13,
		["Cash"] = 28062,
	},
	[14] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 14,
		["Cash"] = 30900,
	},
	[15] = {
		["Vigor"] = 2,
		["Physical"] = 2,
		["YuanBao"] = 0,
		["Grade"] = 15,
		["Cash"] = 33800,
	},
	[16] = {
		["YuanBao"] = 0,
		["Physical"] = 3,
		["Vigor"] = 3,
		["Grade"] = 16,
		["Cash"] = 36758,
	},
	[17] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 17,
		["Cash"] = 39772,
	},
	[18] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 18,
		["Cash"] = 42840,
	},
	[19] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 19,
		["Cash"] = 45959,
	},
	[20] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 20,
		["Cash"] = 49129,
	},
	[21] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 21,
		["Cash"] = 52346,
	},
	[22] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 22,
		["Cash"] = 55609,
	},
	[23] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 23,
		["Cash"] = 58917,
	},
	[24] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 24,
		["Cash"] = 62269,
	},
	[25] = {
		["Vigor"] = 3,
		["Physical"] = 3,
		["YuanBao"] = 0,
		["Grade"] = 25,
		["Cash"] = 65663,
	},
	[26] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 26,
		["Cash"] = 69097,
	},
	[27] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 27,
		["Cash"] = 72572,
	},
	[28] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 28,
		["Cash"] = 76086,
	},
	[29] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 29,
		["Cash"] = 79637,
	},
	[30] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 30,
		["Cash"] = 83225,
	},
	[31] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 31,
		["Cash"] = 86850,
	},
	[32] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 32,
		["Cash"] = 90509,
	},
	[33] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 33,
		["Cash"] = 94203,
	},
	[34] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 34,
		["Cash"] = 97931,
	},
	[35] = {
		["Vigor"] = 4,
		["Physical"] = 4,
		["YuanBao"] = 0,
		["Grade"] = 35,
		["Cash"] = 101692,
	},
	[36] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 36,
		["Cash"] = 105485,
	},
	[37] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 37,
		["Cash"] = 109310,
	},
	[38] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 38,
		["Cash"] = 113166,
	},
	[39] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 39,
		["Cash"] = 117053,
	},
	[40] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 40,
		["Cash"] = 120970,
	},
	[41] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 41,
		["Cash"] = 124916,
	},
	[42] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 42,
		["Cash"] = 128891,
	},
	[43] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 43,
		["Cash"] = 132895,
	},
	[44] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 44,
		["Cash"] = 136926,
	},
	[45] = {
		["Vigor"] = 5,
		["Physical"] = 5,
		["YuanBao"] = 0,
		["Grade"] = 45,
		["Cash"] = 140986,
	},
	[46] = {
		["Vigor"] = 8,
		["Physical"] = 8,
		["YuanBao"] = 0,
		["Grade"] = 46,
		["Cash"] = 145072,
	},
	[47] = {
		["Vigor"] = 8,
		["Physical"] = 8,
		["YuanBao"] = 0,
		["Grade"] = 47,
		["Cash"] = 149185,
	},
	[48] = {
		["Vigor"] = 8,
		["Physical"] = 8,
		["YuanBao"] = 0,
		["Grade"] = 48,
		["Cash"] = 153325,
	},
	[49] = {
		["Vigor"] = 8,
		["Physical"] = 8,
		["YuanBao"] = 0,
		["Grade"] = 49,
		["Cash"] = 157490,
	},
	[50] = {
		["Vigor"] = 8,
		["Physical"] = 8,
		["YuanBao"] = 0,
		["Grade"] = 50,
		["Cash"] = 161681,
	},
	[51] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 51,
		["Cash"] = 165898,
	},
	[52] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 52,
		["Cash"] = 170139,
	},
	[53] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 53,
		["Cash"] = 174404,
	},
	[54] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 54,
		["Cash"] = 178694,
	},
	[55] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 55,
		["Cash"] = 183008,
	},
	[56] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 56,
		["Cash"] = 187346,
	},
	[57] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 57,
		["Cash"] = 191706,
	},
	[58] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 58,
		["Cash"] = 196090,
	},
	[59] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 59,
		["Cash"] = 200496,
	},
	[60] = {
		["Vigor"] = 10,
		["Physical"] = 10,
		["YuanBao"] = 0,
		["Grade"] = 60,
		["Cash"] = 204925,
	},
}