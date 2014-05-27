--- 
-- 大侠指点道具表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.ZhiDianXls
-- 

module("xls.ZhiDianXls")

--- 
-- @type ZhiDianXls
-- @field	#number	YuanBao	所需元宝	 
-- @field	#string	ItemName	所得道具名称	 
-- @field	#number	Id	序号	 
-- @field	#number	ItemXYD	所得道具稀有度	 
-- @field	#number	ItemIco	所得道具图标编号	 
-- 

--- 
-- ZhiDianXls
-- @field [parent=#xls.ZhiDianXls] #ZhiDianXls ZhiDianXls
-- 

--- 
-- data
-- @field [parent=#xls.ZhiDianXls] #table data Id -> @{ZhiDianXls}表
-- 
data = 
{
	[1] = {
		["YuanBao"] = 69,
		["ItemName"] = "独孤剑法",
		["Id"] = 1,
		["ItemXYD"] = 5,
		["ItemIco"] = 2010001,
	},
	[2] = {
		["YuanBao"] = 20,
		["ItemName"] = "金刚般若掌",
		["Id"] = 2,
		["ItemXYD"] = 3,
		["ItemIco"] = 2010002,
	},
	[3] = {
		["YuanBao"] = 20,
		["ItemName"] = "寒冰掌",
		["Id"] = 3,
		["ItemXYD"] = 3,
		["ItemIco"] = 2010003,
	},
	[4] = {
		["YuanBao"] = 21,
		["ItemName"] = "吸星神功",
		["Id"] = 4,
		["ItemXYD"] = 3,
		["ItemIco"] = 2010004,
	},
	[5] = {
		["YuanBao"] = 20,
		["ItemName"] = "紫霞玄功",
		["Id"] = 5,
		["ItemXYD"] = 3,
		["ItemIco"] = 2010005,
	},
	[6] = {
		["YuanBao"] = 10,
		["ItemName"] = "华山剑法",
		["Id"] = 6,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010006,
	},
	[7] = {
		["YuanBao"] = 10,
		["ItemName"] = "泰山剑法",
		["Id"] = 7,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010007,
	},
	[8] = {
		["YuanBao"] = 11,
		["ItemName"] = "回风剑法",
		["Id"] = 8,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010008,
	},
	[9] = {
		["YuanBao"] = 10,
		["ItemName"] = "万花剑法",
		["Id"] = 9,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010009,
	},
	[10] = {
		["YuanBao"] = 10,
		["ItemName"] = "摧心掌",
		["Id"] = 10,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010010,
	},
	[11] = {
		["YuanBao"] = 39,
		["ItemName"] = "避邪剑法",
		["Id"] = 11,
		["ItemXYD"] = 4,
		["ItemIco"] = 2010012,
	},
	[12] = {
		["YuanBao"] = 80,
		["ItemName"] = "葵花秘典",
		["Id"] = 12,
		["ItemXYD"] = 5,
		["ItemIco"] = 2010013,
	},
	[13] = {
		["YuanBao"] = 21,
		["ItemName"] = "玉女剑法",
		["Id"] = 13,
		["ItemXYD"] = 3,
		["ItemIco"] = 2010014,
	},
	[14] = {
		["YuanBao"] = 9,
		["ItemName"] = "嵩阳功",
		["Id"] = 14,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010015,
	},
	[15] = {
		["YuanBao"] = 10,
		["ItemName"] = "狂风刀法",
		["Id"] = 15,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010016,
	},
	[16] = {
		["YuanBao"] = 10,
		["ItemName"] = "天王掌",
		["Id"] = 16,
		["ItemXYD"] = 2,
		["ItemIco"] = 2010017,
	},
	[17] = {
		["YuanBao"] = 77,
		["ItemName"] = "九阳玄功",
		["Id"] = 17,
		["ItemXYD"] = 5,
		["ItemIco"] = 2020001,
	},
	[18] = {
		["YuanBao"] = 72,
		["ItemName"] = "太极拳",
		["Id"] = 18,
		["ItemXYD"] = 5,
		["ItemIco"] = 2020002,
	},
	[19] = {
		["YuanBao"] = 20,
		["ItemName"] = "太极剑",
		["Id"] = 19,
		["ItemXYD"] = 3,
		["ItemIco"] = 2020003,
	},
	[20] = {
		["YuanBao"] = 19,
		["ItemName"] = "玄冥寒掌",
		["Id"] = 20,
		["ItemXYD"] = 3,
		["ItemIco"] = 2020004,
	},
	[21] = {
		["YuanBao"] = 10,
		["ItemName"] = "五脏七伤拳",
		["Id"] = 21,
		["ItemXYD"] = 2,
		["ItemIco"] = 2020005,
	},
	[22] = {
		["YuanBao"] = 10,
		["ItemName"] = "千蛛手",
		["Id"] = 22,
		["ItemXYD"] = 2,
		["ItemIco"] = 2020006,
	},
	[23] = {
		["YuanBao"] = 45,
		["ItemName"] = "大挪移术",
		["Id"] = 23,
		["ItemXYD"] = 4,
		["ItemIco"] = 2020007,
	},
	[24] = {
		["YuanBao"] = 10,
		["ItemName"] = "峨眉剑法",
		["Id"] = 24,
		["ItemXYD"] = 2,
		["ItemIco"] = 2020008,
	},
	[25] = {
		["YuanBao"] = 10,
		["ItemName"] = "鹰爪功",
		["Id"] = 25,
		["ItemXYD"] = 2,
		["ItemIco"] = 2020009,
	},
	[26] = {
		["YuanBao"] = 11,
		["ItemName"] = "疯魔棍法",
		["Id"] = 26,
		["ItemXYD"] = 2,
		["ItemIco"] = 2020010,
	},
	[27] = {
		["YuanBao"] = 21,
		["ItemName"] = "九阴毒爪",
		["Id"] = 27,
		["ItemXYD"] = 3,
		["ItemIco"] = 2020011,
	},
	[28] = {
		["YuanBao"] = 72,
		["ItemName"] = "降龙掌",
		["Id"] = 28,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030001,
	},
	[29] = {
		["YuanBao"] = 12,
		["ItemName"] = "全真剑法",
		["Id"] = 29,
		["ItemXYD"] = 2,
		["ItemIco"] = 2030002,
	},
	[30] = {
		["YuanBao"] = 49,
		["ItemName"] = "龙象波若功",
		["Id"] = 30,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030003,
	},
	[31] = {
		["YuanBao"] = 47,
		["ItemName"] = "一阳剑气",
		["Id"] = 31,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030004,
	},
	[32] = {
		["YuanBao"] = 77,
		["ItemName"] = "蟾蜍功",
		["Id"] = 32,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030005,
	},
	[33] = {
		["YuanBao"] = 21,
		["ItemName"] = "空冥拳",
		["Id"] = 33,
		["ItemXYD"] = 3,
		["ItemIco"] = 2030006,
	},
	[34] = {
		["YuanBao"] = 45,
		["ItemName"] = "落影神剑掌",
		["Id"] = 34,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030007,
	},
	[35] = {
		["YuanBao"] = 44,
		["ItemName"] = "真.打狗棍法",
		["Id"] = 35,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030008,
	},
	[36] = {
		["YuanBao"] = 76,
		["ItemName"] = "销魂黯然掌",
		["Id"] = 36,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030009,
	},
	[37] = {
		["YuanBao"] = 10,
		["ItemName"] = "杨家枪法",
		["Id"] = 37,
		["ItemXYD"] = 2,
		["ItemIco"] = 2040001,
	},
	[38] = {
		["YuanBao"] = 11,
		["ItemName"] = "灵蛇拳",
		["Id"] = 38,
		["ItemXYD"] = 2,
		["ItemIco"] = 2040002,
	},
	[39] = {
		["YuanBao"] = 24,
		["ItemName"] = "同归剑法",
		["Id"] = 39,
		["ItemXYD"] = 3,
		["ItemIco"] = 2040003,
	},
	[40] = {
		["YuanBao"] = 51,
		["ItemName"] = "一气化三清",
		["Id"] = 40,
		["ItemXYD"] = 4,
		["ItemIco"] = 2040004,
	},
	[41] = {
		["YuanBao"] = 87,
		["ItemName"] = "九阴秘术",
		["Id"] = 41,
		["ItemXYD"] = 5,
		["ItemIco"] = 2040005,
	},
	[42] = {
		["YuanBao"] = 44,
		["ItemName"] = "落影神剑掌",
		["Id"] = 42,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030007,
	},
	[43] = {
		["YuanBao"] = 46,
		["ItemName"] = "真.打狗棍法",
		["Id"] = 43,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030008,
	},
	[44] = {
		["YuanBao"] = 86,
		["ItemName"] = "销魂黯然掌",
		["Id"] = 44,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030009,
	},
	[45] = {
		["YuanBao"] = 49,
		["ItemName"] = "龙象波若功",
		["Id"] = 45,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030003,
	},
	[46] = {
		["YuanBao"] = 46,
		["ItemName"] = "一阳剑气",
		["Id"] = 46,
		["ItemXYD"] = 4,
		["ItemIco"] = 2030004,
	},
	[47] = {
		["YuanBao"] = 88,
		["ItemName"] = "蟾蜍功",
		["Id"] = 47,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030005,
	},
	[48] = {
		["YuanBao"] = 84,
		["ItemName"] = "降龙掌",
		["Id"] = 48,
		["ItemXYD"] = 5,
		["ItemIco"] = 2030001,
	},
	[49] = {
		["YuanBao"] = 45,
		["ItemName"] = "大挪移术",
		["Id"] = 49,
		["ItemXYD"] = 4,
		["ItemIco"] = 2020007,
	},
	[50] = {
		["YuanBao"] = 75,
		["ItemName"] = "九阳玄功",
		["Id"] = 50,
		["ItemXYD"] = 5,
		["ItemIco"] = 2020001,
	},
	[51] = {
		["YuanBao"] = 72,
		["ItemName"] = "太极拳",
		["Id"] = 51,
		["ItemXYD"] = 5,
		["ItemIco"] = 2020002,
	},
	[52] = {
		["YuanBao"] = 45,
		["ItemName"] = "避邪剑法",
		["Id"] = 52,
		["ItemXYD"] = 4,
		["ItemIco"] = 2010012,
	},
	[53] = {
		["YuanBao"] = 69,
		["ItemName"] = "葵花秘典",
		["Id"] = 53,
		["ItemXYD"] = 5,
		["ItemIco"] = 2010013,
	},
	[54] = {
		["YuanBao"] = 72,
		["ItemName"] = "独孤剑法",
		["Id"] = 54,
		["ItemXYD"] = 5,
		["ItemIco"] = 2010001,
	},
	[55] = {
		["YuanBao"] = 26,
		["ItemName"] = "炙焰刀",
		["Id"] = 55,
		["ItemXYD"] = 3,
		["ItemIco"] = 2050001,
	},
	[56] = {
		["YuanBao"] = 26,
		["ItemName"] = "星移斗转",
		["Id"] = 56,
		["ItemXYD"] = 3,
		["ItemIco"] = 2050002,
	},
	[57] = {
		["YuanBao"] = 26,
		["ItemName"] = "化功劲",
		["Id"] = 57,
		["ItemXYD"] = 3,
		["ItemIco"] = 2050003,
	},
	[58] = {
		["YuanBao"] = 47,
		["ItemName"] = "北冥玄功",
		["Id"] = 58,
		["ItemXYD"] = 4,
		["ItemIco"] = 2050004,
	},
	[59] = {
		["YuanBao"] = 46,
		["ItemName"] = "天山神掌",
		["Id"] = 59,
		["ItemXYD"] = 4,
		["ItemIco"] = 2050005,
	},
	[60] = {
		["YuanBao"] = 25,
		["ItemName"] = "冰蚕掌",
		["Id"] = 60,
		["ItemXYD"] = 3,
		["ItemIco"] = 2050006,
	},
	[61] = {
		["YuanBao"] = 22,
		["ItemName"] = "无相指",
		["Id"] = 61,
		["ItemXYD"] = 3,
		["ItemIco"] = 2050007,
	},
	[62] = {
		["YuanBao"] = 83,
		["ItemName"] = "六脉剑气",
		["Id"] = 62,
		["ItemXYD"] = 5,
		["ItemIco"] = 2050008,
	},
	[63] = {
		["YuanBao"] = 27,
		["ItemName"] = "夺命十三式",
		["Id"] = 63,
		["ItemXYD"] = 3,
		["ItemIco"] = 2060001,
	},
	[64] = {
		["YuanBao"] = 13,
		["ItemName"] = "流云剑法",
		["Id"] = 64,
		["ItemXYD"] = 2,
		["ItemIco"] = 2060002,
	},
	[65] = {
		["YuanBao"] = 27,
		["ItemName"] = "双凤手",
		["Id"] = 65,
		["ItemXYD"] = 3,
		["ItemIco"] = 2060003,
	},
	[66] = {
		["YuanBao"] = 84,
		["ItemName"] = "小李飞刀",
		["Id"] = 66,
		["ItemXYD"] = 5,
		["ItemIco"] = 2060004,
	},
	[67] = {
		["YuanBao"] = 23,
		["ItemName"] = "玉连环",
		["Id"] = 67,
		["ItemXYD"] = 3,
		["ItemIco"] = 2060005,
	},
	[68] = {
		["YuanBao"] = 12,
		["ItemName"] = "九宫连环剑",
		["Id"] = 68,
		["ItemXYD"] = 2,
		["ItemIco"] = 2060006,
	},
	[69] = {
		["YuanBao"] = 25,
		["ItemName"] = "晓月寒心掌",
		["Id"] = 69,
		["ItemXYD"] = 3,
		["ItemIco"] = 2060007,
	},
	[70] = {
		["YuanBao"] = 51,
		["ItemName"] = "北冥玄功",
		["Id"] = 70,
		["ItemXYD"] = 4,
		["ItemIco"] = 2050004,
	},
	[71] = {
		["YuanBao"] = 52,
		["ItemName"] = "天山神掌",
		["Id"] = 71,
		["ItemXYD"] = 4,
		["ItemIco"] = 2050005,
	},
	[72] = {
		["YuanBao"] = 90,
		["ItemName"] = "六脉剑气",
		["Id"] = 72,
		["ItemXYD"] = 5,
		["ItemIco"] = 2050008,
	},
	[73] = {
		["YuanBao"] = 56,
		["ItemName"] = "飞雪一剑",
		["Id"] = 73,
		["ItemXYD"] = 4,
		["ItemIco"] = 2070001,
	},
	[74] = {
		["YuanBao"] = 13,
		["ItemName"] = "妙手空空",
		["Id"] = 74,
		["ItemXYD"] = 2,
		["ItemIco"] = 2070002,
	},
	[75] = {
		["YuanBao"] = 27,
		["ItemName"] = "流云飞袖",
		["Id"] = 75,
		["ItemXYD"] = 3,
		["ItemIco"] = 2070003,
	},
	[76] = {
		["YuanBao"] = 13,
		["ItemName"] = "刀剑双杀",
		["Id"] = 76,
		["ItemXYD"] = 2,
		["ItemIco"] = 2070004,
	},
	[77] = {
		["YuanBao"] = 25,
		["ItemName"] = "大衍神剑",
		["Id"] = 77,
		["ItemXYD"] = 3,
		["ItemIco"] = 2070005,
	},
	[78] = {
		["YuanBao"] = 89,
		["ItemName"] = "天外飞仙",
		["Id"] = 78,
		["ItemXYD"] = 5,
		["ItemIco"] = 2070006,
	},
	[79] = {
		["YuanBao"] = 58,
		["ItemName"] = "灵犀一指",
		["Id"] = 79,
		["ItemXYD"] = 4,
		["ItemIco"] = 2070007,
	},
	[80] = {
		["YuanBao"] = 15,
		["ItemName"] = "蝶双飞",
		["Id"] = 80,
		["ItemXYD"] = 2,
		["ItemIco"] = 2080001,
	},
	[81] = {
		["YuanBao"] = 13,
		["ItemName"] = "迎风一刀斩",
		["Id"] = 81,
		["ItemXYD"] = 2,
		["ItemIco"] = 2080002,
	},
	[82] = {
		["YuanBao"] = 57,
		["ItemName"] = "男人见不得",
		["Id"] = 82,
		["ItemXYD"] = 4,
		["ItemIco"] = 2080003,
	},
	[83] = {
		["YuanBao"] = 57,
		["ItemName"] = "弹指神功",
		["Id"] = 83,
		["ItemXYD"] = 4,
		["ItemIco"] = 2080004,
	},
	[84] = {
		["YuanBao"] = 102,
		["ItemName"] = "天外飞仙",
		["Id"] = 84,
		["ItemXYD"] = 5,
		["ItemIco"] = 2070006,
	},
	[85] = {
		["YuanBao"] = 53,
		["ItemName"] = "灵犀一指",
		["Id"] = 85,
		["ItemXYD"] = 4,
		["ItemIco"] = 2070007,
	},
	[86] = {
		["YuanBao"] = 53,
		["ItemName"] = "飞雪一剑",
		["Id"] = 86,
		["ItemXYD"] = 4,
		["ItemIco"] = 2070001,
	},
	[87] = {
		["YuanBao"] = 29,
		["ItemName"] = "流云飞袖",
		["Id"] = 87,
		["ItemXYD"] = 3,
		["ItemIco"] = 2070003,
	},
	[88] = {
		["YuanBao"] = 26,
		["ItemName"] = "大衍神剑",
		["Id"] = 88,
		["ItemXYD"] = 3,
		["ItemIco"] = 2070005,
	},
	[89] = {
		["YuanBao"] = 55,
		["ItemName"] = "覆雨剑法",
		["Id"] = 89,
		["ItemXYD"] = 4,
		["ItemIco"] = 2090001,
	},
	[90] = {
		["YuanBao"] = 101,
		["ItemName"] = "种魔大法",
		["Id"] = 90,
		["ItemXYD"] = 5,
		["ItemIco"] = 2090002,
	},
	[91] = {
		["YuanBao"] = 13,
		["ItemName"] = "左手刀法",
		["Id"] = 91,
		["ItemXYD"] = 2,
		["ItemIco"] = 2090003,
	},
	[92] = {
		["YuanBao"] = 15,
		["ItemName"] = "烈焰毒手",
		["Id"] = 92,
		["ItemXYD"] = 2,
		["ItemIco"] = 2090004,
	},
	[93] = {
		["YuanBao"] = 53,
		["ItemName"] = "燎原百击",
		["Id"] = 93,
		["ItemXYD"] = 4,
		["ItemIco"] = 2090005,
	},
	[94] = {
		["YuanBao"] = 28,
		["ItemName"] = "花间仙气",
		["Id"] = 94,
		["ItemXYD"] = 3,
		["ItemIco"] = 2090006,
	},
	[95] = {
		["YuanBao"] = 58,
		["ItemName"] = "慈航剑典",
		["Id"] = 95,
		["ItemXYD"] = 4,
		["ItemIco"] = 2090007,
	},
	[96] = {
		["YuanBao"] = 29,
		["ItemName"] = "鬼火十三拍",
		["Id"] = 96,
		["ItemXYD"] = 3,
		["ItemIco"] = 2090008,
	},
	[97] = {
		["YuanBao"] = 60,
		["ItemName"] = "无念禅功",
		["Id"] = 97,
		["ItemXYD"] = 4,
		["ItemIco"] = 2090009,
	},
	[98] = {
		["YuanBao"] = 115,
		["ItemName"] = "不死印法",
		["Id"] = 98,
		["ItemXYD"] = 5,
		["ItemIco"] = 2100001,
	},
	[99] = {
		["YuanBao"] = 62,
		["ItemName"] = "九玄大法",
		["Id"] = 99,
		["ItemXYD"] = 4,
		["ItemIco"] = 2100002,
	},
	[100] = {
		["YuanBao"] = 30,
		["ItemName"] = "奕剑术",
		["Id"] = 100,
		["ItemXYD"] = 3,
		["ItemIco"] = 2100003,
	},
	[101] = {
		["YuanBao"] = 15,
		["ItemName"] = "炎阳奇功",
		["Id"] = 101,
		["ItemXYD"] = 2,
		["ItemIco"] = 2100004,
	},
	[102] = {
		["YuanBao"] = 31,
		["ItemName"] = "天刀八诀",
		["Id"] = 102,
		["ItemXYD"] = 3,
		["ItemIco"] = 2100005,
	},
	[103] = {
		["YuanBao"] = 54,
		["ItemName"] = "散手八扑",
		["Id"] = 103,
		["ItemXYD"] = 4,
		["ItemIco"] = 2100006,
	},
	[104] = {
		["YuanBao"] = 29,
		["ItemName"] = "天魔大法",
		["Id"] = 104,
		["ItemXYD"] = 3,
		["ItemIco"] = 2100007,
	},
	[105] = {
		["YuanBao"] = 54,
		["ItemName"] = "井中八法",
		["Id"] = 105,
		["ItemXYD"] = 4,
		["ItemIco"] = 2100008,
	},
	[106] = {
		["YuanBao"] = 31,
		["ItemName"] = "风神腿",
		["Id"] = 106,
		["ItemXYD"] = 3,
		["ItemIco"] = 2110001,
	},
	[107] = {
		["YuanBao"] = 15,
		["ItemName"] = "冰心诀",
		["Id"] = 107,
		["ItemXYD"] = 2,
		["ItemIco"] = 2110002,
	},
	[108] = {
		["YuanBao"] = 29,
		["ItemName"] = "排云掌",
		["Id"] = 108,
		["ItemXYD"] = 3,
		["ItemIco"] = 2110003,
	},
	[109] = {
		["YuanBao"] = 16,
		["ItemName"] = "霍家剑法",
		["Id"] = 109,
		["ItemXYD"] = 2,
		["ItemIco"] = 2110004,
	},
	[110] = {
		["YuanBao"] = 62,
		["ItemName"] = "三分归元",
		["Id"] = 110,
		["ItemXYD"] = 4,
		["ItemIco"] = 2110005,
	},
	[111] = {
		["YuanBao"] = 14,
		["ItemName"] = "天霜拳",
		["Id"] = 111,
		["ItemXYD"] = 2,
		["ItemIco"] = 2110006,
	},
	[112] = {
		["YuanBao"] = 64,
		["ItemName"] = "万剑归宗",
		["Id"] = 112,
		["ItemXYD"] = 4,
		["ItemIco"] = 2110007,
	},
	[113] = {
		["YuanBao"] = 32,
		["ItemName"] = "如来神掌",
		["Id"] = 113,
		["ItemXYD"] = 3,
		["ItemIco"] = 2110008,
	},
	[114] = {
		["YuanBao"] = 66,
		["ItemName"] = "莫名剑法",
		["Id"] = 114,
		["ItemXYD"] = 4,
		["ItemIco"] = 2110009,
	},
	[115] = {
		["YuanBao"] = 107,
		["ItemName"] = "圣心诀",
		["Id"] = 115,
		["ItemXYD"] = 5,
		["ItemIco"] = 2110010,
	},
}