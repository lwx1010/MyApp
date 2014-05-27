--- 
-- 引导信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.GuideXls
-- 

module("xls.GuideXls")

--- 
-- @type GuideXls
-- @field	#number	NeedOffset	是否需要适配	notNull
-- @field	#number	HightLY	高亮y	 
-- @field	#number	IsMode	是否模态	 
-- @field	#number	GuideX	引导框x	 
-- @field	#number	GuideNo	引导编号	 
-- @field	#number	DescX	说明区域x	notNull
-- @field	#number	EndGuideNo	结束引导	 
-- @field	#number	NextGuideNo	下一个引导	notNull
-- @field	#number	HightLHeight	高亮高度	 
-- @field	#number	GuideHeight	引导框高	 
-- @field	#number	IsAfterFight	是否跨战斗	notNull
-- @field	#string	GuideInfo	引导内容提示	notNull
-- @field	#number	HightLX	高亮x	 
-- @field	#number	PointDir	箭头方向	notNull
-- @field	#number	GuideY	引导框y	 
-- @field	#number	OutArea	跳出引导区域	notNull
-- @field	#string	PicOutline	描边图标	notNull
-- @field	#number	GuideWidth	引导框宽	 
-- @field	#number	HightLWidth	高亮宽度	 
-- @field	#number	NeedPoint	是否要箭头	 
-- @field	#number	DescY	说明区域y	notNull
-- @field	#number	NextDelay	下一个引导延时	notNull
-- 

--- 
-- GuideXls
-- @field [parent=#xls.GuideXls] #GuideXls GuideXls
-- 

--- 
-- data
-- @field [parent=#xls.GuideXls] #table data GuideNo -> @{GuideXls}表
-- 
data = 
{
	[1013] = {
		["HightLY"] = 323,
		["IsMode"] = 1,
		["GuideX"] = 602,
		["GuideNo"] = 1013,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1014,
		["HightLHeight"] = 154,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 328,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 139,
		["HightLX"] = 599,
		["NeedPoint"] = 1,
		["HightLWidth"] = 146,
		["GuideWidth"] = 139,
	},
	[1015] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1015,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1016,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["GuideInfo"] = "",
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 1,
		["HightLX"] = 875,
		["GuideWidth"] = 80,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
		["NextDelay"] = 0.5,
		["IsAfterFight"] = 1,
	},
	[1017] = {
		["HightLY"] = 135,
		["IsMode"] = 1,
		["GuideX"] = 772,
		["GuideNo"] = 1017,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1018,
		["HightLHeight"] = 353,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 328,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 139,
		["HightLX"] = 559,
		["NeedPoint"] = 1,
		["HightLWidth"] = 385,
		["GuideWidth"] = 139,
	},
	[1019] = {
		["HightLY"] = 135,
		["IsMode"] = 1,
		["GuideX"] = 772,
		["GuideNo"] = 1019,
		["DescX"] = 211,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1020,
		["HightLHeight"] = 353,
		["GuideHeight"] = 139,
		["HightLWidth"] = 385,
		["PointDir"] = 7,
		["GuideY"] = 328,
		["OutArea"] = 1,
		["GuideInfo"] = "<c3>升级武学</c>，<c3>突破武学境界</c>，可大幅度提高武学威力",
		["HightLX"] = 559,
		["GuideWidth"] = 139,
		["NextDelay"] = 0.5,
		["DescY"] = 161,
		["NeedPoint"] = 1,
	},
	[1021] = {
		["HightLY"] = 36,
		["IsMode"] = 1,
		["GuideX"] = 628,
		["IsAfterFight"] = 1,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1022,
		["HightLHeight"] = 495,
		["GuideHeight"] = 62,
		["GuideInfo"] = "",
		["PointDir"] = 8,
		["GuideY"] = 45,
		["OutArea"] = 1,
		["HightLX"] = 517,
		["GuideWidth"] = 212,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 415,
		["NeedPoint"] = 1,
		["GuideNo"] = 1021,
	},
	[1023] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1023,
		["DescX"] = 346,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1024,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["NeedPoint"] = 1,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 1,
		["GuideInfo"] = "<c3>强化装备，升级武学</c>，提高了一定的战斗力，前往江湖挑战试试身手吧！",
		["HightLX"] = 875,
		["GuideWidth"] = 80,
		["HightLWidth"] = 80,
		["DescY"] = 155,
		["NextDelay"] = 0.5,
	},
	[1026] = {
		["HightLY"] = 10,
		["IsMode"] = 1,
		["GuideX"] = 148,
		["GuideNo"] = 1026,
		["EndGuideNo"] = 1028,
		["NextGuideNo"] = 1027,
		["HightLHeight"] = 92,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 10,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 92,
		["HightLX"] = 148,
		["NeedPoint"] = 1,
		["HightLWidth"] = 103,
		["GuideWidth"] = 103,
	},
	[1030] = {
		["HightLY"] = 30,
		["IsMode"] = 1,
		["GuideX"] = 750,
		["GuideNo"] = 1030,
		["DescX"] = 357,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1031,
		["HightLHeight"] = 70,
		["GuideHeight"] = 70,
		["HightLWidth"] = 200,
		["PointDir"] = 8,
		["GuideY"] = 30,
		["OutArea"] = 1,
		["GuideInfo"] = "<c3>使用升星丹或吞噬侠客可提升侠客星级</c>，提高侠客属性",
		["HightLX"] = 750,
		["GuideWidth"] = 200,
		["NextDelay"] = 0.5,
		["DescY"] = 163,
		["NeedPoint"] = 1,
	},
	[1034] = {
		["NeedOffset"] = 1,
		["GuideWidth"] = 80,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1034,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1035,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["HightLX"] = 875,
		["HightLY"] = 560,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
	},
	[1038] = {
		["HightLY"] = 28,
		["IsMode"] = 1,
		["GuideX"] = 320,
		["GuideNo"] = 1038,
		["EndGuideNo"] = 1041,
		["NextGuideNo"] = 1039,
		["HightLHeight"] = 511,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 320,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 200,
		["HightLX"] = 299,
		["NeedPoint"] = 1,
		["HightLWidth"] = 651,
		["GuideWidth"] = 140,
	},
	[1042] = {
		["HightLY"] = 164,
		["IsMode"] = 1,
		["GuideX"] = 412,
		["GuideNo"] = 1042,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1043,
		["HightLHeight"] = 57,
		["NextDelay"] = 0.5,
		["PointDir"] = 6,
		["GuideY"] = 164,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 57,
		["HightLX"] = 412,
		["NeedPoint"] = 1,
		["HightLWidth"] = 150,
		["GuideWidth"] = 150,
	},
	[1046] = {
		["HightLY"] = 272,
		["IsMode"] = 1,
		["GuideX"] = 50,
		["GuideNo"] = 1046,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1047,
		["HightLHeight"] = 200,
		["NextDelay"] = 2,
		["PointDir"] = 3,
		["GuideY"] = 272,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 200,
		["HightLX"] = 50,
		["NeedPoint"] = 1,
		["HightLWidth"] = 138,
		["GuideWidth"] = 138,
	},
	[1050] = {
		["NeedOffset"] = 1,
		["GuideWidth"] = 80,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1050,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1051,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["HightLX"] = 875,
		["HightLY"] = 560,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
	},
	[1054] = {
		["HightLY"] = 7,
		["IsMode"] = 1,
		["GuideX"] = 186,
		["GuideNo"] = 1054,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1055,
		["HightLHeight"] = 539,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 7,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 539,
		["HightLX"] = 186,
		["NeedPoint"] = 1,
		["HightLWidth"] = 374,
		["GuideWidth"] = 374,
	},
	[1058] = {
		["NeedOffset"] = 1,
		["GuideWidth"] = 80,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1058,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1059,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["HightLX"] = 875,
		["HightLY"] = 560,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
	},
	[1041] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1041,
		["EndGuideNo"] = 1041,
		["HightLHeight"] = 76,
		["HightLWidth"] = 80,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 76,
		["HightLX"] = 875,
		["NeedPoint"] = 1,
		["GuideWidth"] = 80,
		["NextDelay"] = 0.5,
	},
	[1055] = {
		["HightLY"] = 18,
		["IsMode"] = 1,
		["GuideX"] = 685,
		["GuideNo"] = 1055,
		["DescX"] = 346,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1056,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["HightLWidth"] = 226,
		["PointDir"] = 7,
		["GuideY"] = 18,
		["OutArea"] = 3,
		["GuideInfo"] = "<c3>你现在可以更换更好的侠客上阵</c>，侠客品质越高战斗力越强哦",
		["HightLX"] = 685,
		["GuideWidth"] = 226,
		["NextDelay"] = 0.5,
		["DescY"] = 115,
		["NeedPoint"] = 1,
	},
	[1027] = {
		["HightLY"] = 174,
		["IsMode"] = 1,
		["GuideX"] = 52,
		["GuideNo"] = 1027,
		["EndGuideNo"] = 1028,
		["NextGuideNo"] = 1028,
		["HightLHeight"] = 110,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 174,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 110,
		["HightLX"] = 52,
		["NeedPoint"] = 1,
		["HightLWidth"] = 110,
		["GuideWidth"] = 110,
	},
	[1031] = {
		["HightLY"] = 36,
		["IsMode"] = 1,
		["GuideX"] = 518,
		["GuideNo"] = 1031,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1032,
		["HightLHeight"] = 493,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 417,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 110,
		["HightLX"] = 511,
		["NeedPoint"] = 1,
		["HightLWidth"] = 412,
		["GuideWidth"] = 116,
	},
	[1035] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1035,
		["EndGuideNo"] = 1035,
		["HightLHeight"] = 76,
		["HightLWidth"] = 80,
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 76,
		["HightLX"] = 875,
		["NeedPoint"] = 1,
		["GuideWidth"] = 80,
		["NextDelay"] = 0.5,
	},
	[1039] = {
		["HightLY"] = 28,
		["IsMode"] = 1,
		["GuideX"] = 46,
		["GuideNo"] = 1039,
		["EndGuideNo"] = 1041,
		["NextGuideNo"] = 1040,
		["HightLHeight"] = 513,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 36,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 63,
		["HightLX"] = 12,
		["NeedPoint"] = 1,
		["HightLWidth"] = 273,
		["GuideWidth"] = 204,
	},
	[1002] = {
		["NeedOffset"] = 2,
		["HightLY"] = 483,
		["IsMode"] = 1,
		["GuideX"] = 117,
		["GuideNo"] = 1002,
		["DescX"] = 556,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1003,
		["HightLHeight"] = 118,
		["GuideHeight"] = 118,
		["NeedPoint"] = 1,
		["PointDir"] = 4,
		["GuideY"] = 483,
		["OutArea"] = 2,
		["GuideInfo"] = "来得还及时，赶紧到府内看看情况",
		["HightLX"] = 117,
		["GuideWidth"] = 200,
		["HightLWidth"] = 200,
		["DescY"] = 178,
		["NextDelay"] = 0.5,
	},
	[1004] = {
		["HightLY"] = 56,
		["IsMode"] = 1,
		["GuideX"] = 236,
		["IsAfterFight"] = 1,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1005,
		["HightLHeight"] = 210,
		["GuideHeight"] = 60,
		["GuideInfo"] = "",
		["PointDir"] = 3,
		["GuideY"] = 56,
		["OutArea"] = 2,
		["HightLX"] = 236,
		["GuideWidth"] = 155,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 155,
		["NeedPoint"] = 1,
		["GuideNo"] = 1004,
	},
	[1006] = {
		["HightLY"] = 93,
		["IsMode"] = 1,
		["GuideX"] = 500,
		["IsAfterFight"] = 1,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1007,
		["HightLHeight"] = 449,
		["GuideHeight"] = 68,
		["GuideInfo"] = "",
		["PointDir"] = 3,
		["GuideY"] = 167,
		["OutArea"] = 2,
		["HightLX"] = 253,
		["GuideWidth"] = 153,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 459,
		["NeedPoint"] = 1,
		["GuideNo"] = 1006,
	},
	[1008] = {
		["NeedOffset"] = 3,
		["GuideWidth"] = 118,
		["IsMode"] = 1,
		["GuideX"] = 840,
		["GuideNo"] = 1008,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1009,
		["HightLHeight"] = 118,
		["GuideHeight"] = 118,
		["PointDir"] = 7,
		["GuideY"] = 0,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["HightLX"] = 840,
		["HightLY"] = 0,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 118,
		["NeedPoint"] = 1,
	},
	[1010] = {
		["HightLY"] = 289,
		["IsMode"] = 1,
		["GuideX"] = 48,
		["GuideNo"] = 1010,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1011,
		["HightLHeight"] = 118,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 289,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 118,
		["HightLX"] = 48,
		["NeedPoint"] = 1,
		["HightLWidth"] = 131,
		["GuideWidth"] = 131,
	},
	[1012] = {
		["HightLY"] = 160,
		["IsMode"] = 1,
		["GuideX"] = 767,
		["GuideNo"] = 1012,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1013,
		["HightLHeight"] = 126,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 160,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 126,
		["HightLX"] = 767,
		["NeedPoint"] = 1,
		["HightLWidth"] = 146,
		["GuideWidth"] = 146,
	},
	[1014] = {
		["HightLY"] = 36,
		["IsMode"] = 1,
		["GuideX"] = 525,
		["GuideNo"] = 1014,
		["DescX"] = 250,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1015,
		["HightLHeight"] = 495,
		["GuideHeight"] = 64,
		["HightLWidth"] = 415,
		["PointDir"] = 8,
		["GuideY"] = 44,
		["OutArea"] = 1,
		["GuideInfo"] = "<c3>强化装备</c>能有效提高侠客攻击力，更好的压制对方",
		["HightLX"] = 517,
		["GuideWidth"] = 196,
		["NextDelay"] = 0.5,
		["DescY"] = 150,
		["NeedPoint"] = 1,
	},
	[1016] = {
		["HightLY"] = 481,
		["IsMode"] = 1,
		["GuideX"] = 742,
		["GuideNo"] = 1016,
		["DescX"] = 211,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1017,
		["HightLHeight"] = 56,
		["GuideHeight"] = 56,
		["HightLWidth"] = 200,
		["PointDir"] = 6,
		["GuideY"] = 481,
		["OutArea"] = 1,
		["GuideInfo"] = "侠客<c3>学习新的武学</c>后会获得新的招式，品质越高的武学威力越高",
		["HightLX"] = 742,
		["GuideWidth"] = 200,
		["NextDelay"] = 0.5,
		["DescY"] = 161,
		["NeedPoint"] = 1,
	},
	[1018] = {
		["HightLY"] = 36,
		["IsMode"] = 1,
		["GuideX"] = 14,
		["GuideNo"] = 1018,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1019,
		["HightLHeight"] = 512,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 55,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 62,
		["HightLX"] = 14,
		["NeedPoint"] = 1,
		["HightLWidth"] = 224,
		["GuideWidth"] = 205,
	},
	[1020] = {
		["HightLY"] = 36,
		["IsMode"] = 1,
		["GuideX"] = 628,
		["GuideNo"] = 1020,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1021,
		["HightLHeight"] = 495,
		["NextDelay"] = 0.5,
		["PointDir"] = 8,
		["GuideY"] = 45,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 62,
		["HightLX"] = 517,
		["NeedPoint"] = 1,
		["HightLWidth"] = 415,
		["GuideWidth"] = 212,
	},
	[1022] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1022,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1023,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["GuideInfo"] = "",
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 1,
		["HightLX"] = 875,
		["GuideWidth"] = 80,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
		["NextDelay"] = 0.5,
		["IsAfterFight"] = 1,
	},
	[1024] = {
		["HightLY"] = 121,
		["IsMode"] = 1,
		["GuideX"] = 481,
		["GuideNo"] = 1024,
		["DescX"] = 601,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1025,
		["HightLHeight"] = 146,
		["GuideHeight"] = 146,
		["HightLWidth"] = 186,
		["PointDir"] = 1,
		["GuideY"] = 121,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["HightLX"] = 481,
		["GuideWidth"] = 186,
		["NextDelay"] = 0.5,
		["DescY"] = 170,
		["NeedPoint"] = 1,
	},
	[1028] = {
		["HightLHeight"] = 60,
		["GuideHeight"] = 60,
		["IsMode"] = 1,
		["GuideInfo"] = "",
		["HightLX"] = 25,
		["GuideWidth"] = 200,
		["GuideY"] = 60,
		["PointDir"] = 3,
		["GuideX"] = 25,
		["OutArea"] = 2,
		["GuideNo"] = 1028,
		["NeedPoint"] = 1,
		["EndGuideNo"] = 1028,
		["NextDelay"] = 0.5,
		["HightLY"] = 60,
		["HightLWidth"] = 200,
	},
	[1032] = {
		["HightLY"] = 172,
		["IsMode"] = 1,
		["GuideX"] = 378,
		["GuideNo"] = 1032,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1033,
		["HightLHeight"] = 296,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 183,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 64,
		["HightLX"] = 261,
		["NeedPoint"] = 1,
		["HightLWidth"] = 436,
		["GuideWidth"] = 204,
	},
	[1036] = {
		["HightLY"] = 10,
		["IsMode"] = 1,
		["GuideX"] = 148,
		["GuideNo"] = 1036,
		["EndGuideNo"] = 1041,
		["NextGuideNo"] = 1037,
		["HightLHeight"] = 92,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 10,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 92,
		["HightLX"] = 148,
		["NeedPoint"] = 1,
		["HightLWidth"] = 103,
		["GuideWidth"] = 103,
	},
	[1040] = {
		["NeedOffset"] = 1,
		["HightLY"] = 560,
		["IsMode"] = 1,
		["GuideX"] = 875,
		["GuideNo"] = 1040,
		["EndGuideNo"] = 1041,
		["NextGuideNo"] = 1041,
		["HightLHeight"] = 76,
		["GuideHeight"] = 76,
		["GuideInfo"] = "",
		["PointDir"] = 6,
		["GuideY"] = 560,
		["OutArea"] = 3,
		["HightLX"] = 875,
		["GuideWidth"] = 80,
		["HightLWidth"] = 80,
		["NeedPoint"] = 1,
		["NextDelay"] = 0.5,
		["IsAfterFight"] = 1,
	},
	[1044] = {
		["HightLY"] = 50,
		["IsMode"] = 1,
		["GuideX"] = 686,
		["GuideNo"] = 1044,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1045,
		["HightLHeight"] = 60,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 50,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 60,
		["HightLX"] = 686,
		["NeedPoint"] = 1,
		["HightLWidth"] = 201,
		["GuideWidth"] = 201,
	},
	[1048] = {
		["HightLY"] = 6,
		["IsMode"] = 1,
		["GuideX"] = 740,
		["GuideNo"] = 1048,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1049,
		["HightLHeight"] = 60,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 6,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 60,
		["HightLX"] = 740,
		["NeedPoint"] = 1,
		["HightLWidth"] = 200,
		["GuideWidth"] = 200,
	},
	[1052] = {
		["NeedOffset"] = 3,
		["GuideWidth"] = 118,
		["IsMode"] = 1,
		["GuideX"] = 840,
		["GuideNo"] = 1052,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1053,
		["HightLHeight"] = 118,
		["GuideHeight"] = 118,
		["PointDir"] = 1,
		["GuideY"] = 0,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["HightLX"] = 840,
		["HightLY"] = 0,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 118,
		["NeedPoint"] = 1,
	},
	[1056] = {
		["HightLY"] = 58,
		["IsMode"] = 1,
		["GuideX"] = 26,
		["GuideNo"] = 1056,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1057,
		["HightLHeight"] = 66,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 58,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 66,
		["HightLX"] = 26,
		["NeedPoint"] = 1,
		["HightLWidth"] = 199,
		["GuideWidth"] = 199,
	},
	[1009] = {
		["HightLY"] = 10,
		["IsMode"] = 1,
		["GuideX"] = 148,
		["GuideNo"] = 1009,
		["DescX"] = 552,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1010,
		["HightLHeight"] = 92,
		["GuideHeight"] = 92,
		["HightLWidth"] = 103,
		["PointDir"] = 3,
		["GuideY"] = 10,
		["OutArea"] = 2,
		["GuideInfo"] = "<c3>携带的侠客越多，战斗力越强！</c>记得及时上阵新获得的侠客哦！",
		["HightLX"] = 148,
		["GuideWidth"] = 103,
		["NextDelay"] = 0.5,
		["DescY"] = 193,
		["NeedPoint"] = 1,
	},
	[1007] = {
		["NeedOffset"] = 1,
		["HightLY"] = 538,
		["IsMode"] = 1,
		["GuideX"] = 873,
		["GuideNo"] = 1007,
		["DescX"] = 351,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1008,
		["HightLHeight"] = 79,
		["GuideHeight"] = 79,
		["NeedPoint"] = 1,
		["PointDir"] = 6,
		["GuideY"] = 538,
		["OutArea"] = 1,
		["GuideInfo"] = "对手越来越强了，还是<c3>带上几个小伙伴</c>再来吧，以免出师未捷身先死",
		["HightLX"] = 873,
		["GuideWidth"] = 79,
		["HightLWidth"] = 79,
		["DescY"] = 133,
		["NextDelay"] = 0.5,
	},
	[1005] = {
		["HightLY"] = 56,
		["IsMode"] = 1,
		["GuideX"] = 389,
		["IsAfterFight"] = 1,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1006,
		["HightLHeight"] = 210,
		["GuideHeight"] = 60,
		["GuideInfo"] = "",
		["PointDir"] = 3,
		["GuideY"] = 56,
		["OutArea"] = 2,
		["HightLX"] = 389,
		["GuideWidth"] = 155,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 155,
		["NeedPoint"] = 1,
		["GuideNo"] = 1005,
	},
	[1003] = {
		["HightLY"] = 56,
		["IsMode"] = 1,
		["GuideX"] = 83,
		["GuideNo"] = 1003,
		["DescX"] = 478,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1004,
		["HightLHeight"] = 210,
		["GuideHeight"] = 60,
		["HightLWidth"] = 155,
		["PointDir"] = 2,
		["GuideY"] = 56,
		["OutArea"] = 2,
		["GuideInfo"] = "请大侠速去阻止，青城四杰已经开始欺负林家丫鬟了",
		["HightLX"] = 83,
		["GuideWidth"] = 155,
		["NextDelay"] = 0.5,
		["DescY"] = 143,
		["NeedPoint"] = 1,
	},
	[1047] = {
		["HightLY"] = 272,
		["IsMode"] = 1,
		["GuideX"] = 193,
		["GuideNo"] = 1047,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1048,
		["HightLHeight"] = 200,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 272,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 200,
		["HightLX"] = 193,
		["NeedPoint"] = 1,
		["HightLWidth"] = 138,
		["GuideWidth"] = 138,
	},
	[1051] = {
		["NeedOffset"] = 1,
		["GuideWidth"] = 79,
		["IsMode"] = 1,
		["GuideX"] = 873,
		["GuideNo"] = 1051,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1052,
		["HightLHeight"] = 79,
		["GuideHeight"] = 79,
		["PointDir"] = 6,
		["GuideY"] = 538,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["HightLX"] = 873,
		["HightLY"] = 538,
		["NextDelay"] = 0.5,
		["HightLWidth"] = 79,
		["NeedPoint"] = 1,
	},
	[1043] = {
		["HightLY"] = 152,
		["IsMode"] = 1,
		["GuideX"] = 621,
		["GuideNo"] = 1043,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1044,
		["HightLHeight"] = 60,
		["NextDelay"] = 0.5,
		["PointDir"] = 6,
		["GuideY"] = 152,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 60,
		["HightLX"] = 621,
		["NeedPoint"] = 1,
		["HightLWidth"] = 142,
		["GuideWidth"] = 142,
	},
	[1025] = {
		["NeedOffset"] = 2,
		["HightLY"] = 483,
		["IsMode"] = 1,
		["GuideX"] = 117,
		["GuideNo"] = 1025,
		["DescX"] = 556,
		["EndGuideNo"] = 1025,
		["HightLHeight"] = 118,
		["GuideHeight"] = 118,
		["GuideWidth"] = 200,
		["PointDir"] = 4,
		["GuideY"] = 483,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["HightLX"] = 117,
		["HightLWidth"] = 200,
		["NextDelay"] = 0.5,
		["DescY"] = 178,
		["NeedPoint"] = 1,
	},
	[1029] = {
		["HightLY"] = 10,
		["IsMode"] = 1,
		["GuideX"] = 148,
		["GuideNo"] = 1029,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1030,
		["HightLHeight"] = 92,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 10,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 92,
		["HightLX"] = 148,
		["NeedPoint"] = 1,
		["HightLWidth"] = 103,
		["GuideWidth"] = 103,
	},
	[1033] = {
		["HightLY"] = 30,
		["IsMode"] = 1,
		["GuideX"] = 279,
		["GuideNo"] = 1033,
		["EndGuideNo"] = 1035,
		["NextGuideNo"] = 1034,
		["HightLHeight"] = 507,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 119,
		["OutArea"] = 1,
		["GuideInfo"] = "",
		["GuideHeight"] = 64,
		["HightLX"] = 28,
		["NeedPoint"] = 1,
		["HightLWidth"] = 484,
		["GuideWidth"] = 204,
	},
	[1037] = {
		["HightLY"] = 34,
		["IsMode"] = 1,
		["GuideX"] = 555,
		["GuideNo"] = 1037,
		["DescX"] = 162,
		["EndGuideNo"] = 1041,
		["NextGuideNo"] = 1038,
		["HightLHeight"] = 64,
		["GuideHeight"] = 64,
		["HightLWidth"] = 198,
		["PointDir"] = 8,
		["GuideY"] = 34,
		["OutArea"] = 1,
		["GuideInfo"] = "<c3>吞噬侠客提高侠客内力</c>，使用侠客内力可升级武学",
		["HightLX"] = 555,
		["GuideWidth"] = 198,
		["NextDelay"] = 0.5,
		["DescY"] = 146,
		["NeedPoint"] = 1,
	},
	[1001] = {
		["HightLY"] = 121,
		["IsMode"] = 1,
		["GuideX"] = 481,
		["GuideNo"] = 1001,
		["DescX"] = 90,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1002,
		["HightLHeight"] = 146,
		["GuideHeight"] = 146,
		["HightLWidth"] = 186,
		["PointDir"] = 1,
		["GuideY"] = 121,
		["OutArea"] = 2,
		["GuideInfo"] = "大侠您好，一大波江湖人士正在向<c3>福州林家</c>逼近，现收到林大少侠飞鸽传书让你前往帮忙！",
		["HightLX"] = 480,
		["GuideWidth"] = 186,
		["NextDelay"] = 0.5,
		["DescY"] = 150,
		["NeedPoint"] = 1,
	},
	[1045] = {
		["HightLY"] = 50,
		["IsMode"] = 1,
		["GuideX"] = 686,
		["GuideNo"] = 1045,
		["DescX"] = 346,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1046,
		["HightLHeight"] = 60,
		["GuideHeight"] = 60,
		["NextDelay"] = 0.5,
		["GuideInfo"] = "<c3>48小时后可以再次免费招募一次，现在你可以用元宝抽卡一次</c>，元宝首刷必出紫卡以上哦",
		["PointDir"] = 7,
		["GuideY"] = 50,
		["OutArea"] = 3,
		["HightLX"] = 686,
		["GuideWidth"] = 201,
		["HightLWidth"] = 201,
		["NeedPoint"] = 1,
		["DescY"] = 115,
		["IsAfterFight"] = 1,
	},
	[1049] = {
		["HightLY"] = 180,
		["IsMode"] = 1,
		["GuideX"] = 405,
		["GuideNo"] = 1049,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1050,
		["HightLHeight"] = 291,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 191,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 55,
		["HightLX"] = 260,
		["NeedPoint"] = 1,
		["HightLWidth"] = 450,
		["GuideWidth"] = 150,
	},
	[1053] = {
		["HightLY"] = 10,
		["IsMode"] = 1,
		["GuideX"] = 148,
		["GuideNo"] = 1053,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1054,
		["HightLHeight"] = 92,
		["NextDelay"] = 0.5,
		["PointDir"] = 3,
		["GuideY"] = 10,
		["OutArea"] = 2,
		["GuideInfo"] = "",
		["GuideHeight"] = 92,
		["HightLX"] = 148,
		["NeedPoint"] = 1,
		["HightLWidth"] = 103,
		["GuideWidth"] = 103,
	},
	[1057] = {
		["HightLY"] = 160,
		["IsMode"] = 1,
		["GuideX"] = 767,
		["GuideNo"] = 1057,
		["EndGuideNo"] = 1059,
		["NextGuideNo"] = 1058,
		["HightLHeight"] = 126,
		["NextDelay"] = 0.5,
		["PointDir"] = 7,
		["GuideY"] = 160,
		["OutArea"] = 3,
		["GuideInfo"] = "",
		["GuideHeight"] = 126,
		["HightLX"] = 767,
		["NeedPoint"] = 1,
		["HightLWidth"] = 146,
		["GuideWidth"] = 146,
	},
	[1011] = {
		["HightLY"] = 60,
		["IsMode"] = 1,
		["GuideX"] = 25,
		["GuideNo"] = 1011,
		["DescX"] = 552,
		["EndGuideNo"] = 1025,
		["NextGuideNo"] = 1012,
		["HightLHeight"] = 60,
		["GuideHeight"] = 60,
		["HightLWidth"] = 200,
		["PointDir"] = 3,
		["GuideY"] = 60,
		["OutArea"] = 3,
		["GuideInfo"] = "在上阵侠客的界面可以给侠客<c3>穿戴装备和学习武功</c>，增强侠客实力",
		["HightLX"] = 25,
		["GuideWidth"] = 200,
		["NextDelay"] = 0.5,
		["DescY"] = 193,
		["NeedPoint"] = 1,
	},
	[1059] = {
		["HightLHeight"] = 146,
		["GuideHeight"] = 146,
		["IsMode"] = 1,
		["GuideInfo"] = "",
		["HightLX"] = 481,
		["GuideWidth"] = 186,
		["GuideY"] = 121,
		["PointDir"] = 1,
		["GuideX"] = 481,
		["OutArea"] = 3,
		["GuideNo"] = 1059,
		["NeedPoint"] = 1,
		["EndGuideNo"] = 1059,
		["NextDelay"] = 0.5,
		["HightLY"] = 121,
		["HightLWidth"] = 186,
	},
}