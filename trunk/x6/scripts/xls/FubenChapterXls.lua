--- 
-- 章节信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.FubenChapterXls
-- 

module("xls.FubenChapterXls")

--- 
-- @type FubenChapterXls
-- @field	#string	Name	章节名称	 
-- @field	#number	SectionNo	关联篇章	 
-- @field	#number	ChapterNo	章节编号	 
-- @field	#string	RewardDes	通关奖励描述	notNull
-- @field	#number	ChapterIcon	章节图	 
-- @field	#number	Enemy	章节关卡	 
-- 

--- 
-- FubenChapterXls
-- @field [parent=#xls.FubenChapterXls] #FubenChapterXls FubenChapterXls
-- 

--- 
-- data
-- @field [parent=#xls.FubenChapterXls] #table data ChapterNo -> @{FubenChapterXls}表
-- 
data = 
{
	[1013] = {
		["ChapterPos"] = 6,
		["Name"] = "营救狮王",
		["SectionNo"] = 2,
		["ChapterNo"] = 1013,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1004,
		["Enemy"] = { [1] = 10124, [2] = 10125, [3] = 10126, [4] = 10127, [5] = 10128, [6] = 10129, [7] = 10130, [8] = 10131, [9] = 10132, [10] = 10133,		},
	},
	[1015] = {
		["ChapterPos"] = 2,
		["Name"] = "绝情忘忧",
		["SectionNo"] = 3,
		["ChapterNo"] = 1015,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1015,
		["Enemy"] = { [1] = 10145, [2] = 10146, [3] = 10147, [4] = 10148, [5] = 10149, [6] = 10150, [7] = 10151,		},
	},
	[1017] = {
		["ChapterPos"] = 4,
		["Name"] = "断肠崖",
		["SectionNo"] = 3,
		["ChapterNo"] = 1017,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1017,
		["Enemy"] = { [1] = 10162, [2] = 10163, [3] = 10164, [4] = 10165, [5] = 10166, [6] = 10167, [7] = 10168, [8] = 10169,		},
	},
	[1019] = {
		["ChapterPos"] = 1,
		["Name"] = "大漠白骨",
		["SectionNo"] = 4,
		["ChapterNo"] = 1019,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1019,
		["Enemy"] = { [1] = 10177, [2] = 10178, [3] = 10179, [4] = 10180, [5] = 10181, [6] = 10182, [7] = 10183, [8] = 10184,		},
	},
	[1021] = {
		["ChapterPos"] = 3,
		["Name"] = "桃花之岛",
		["SectionNo"] = 4,
		["ChapterNo"] = 1021,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1021,
		["Enemy"] = { [1] = 10196, [2] = 10197, [3] = 10198, [4] = 10199, [5] = 10200, [6] = 10201, [7] = 10202, [8] = 10203, [9] = 10204,		},
	},
	[1023] = {
		["ChapterPos"] = 5,
		["Name"] = "铁掌断魂",
		["SectionNo"] = 4,
		["ChapterNo"] = 1023,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1023,
		["Enemy"] = { [1] = 10214, [2] = 10215, [3] = 10216, [4] = 10217, [5] = 10218, [6] = 10219, [7] = 10220, [8] = 10221, [9] = 10222,		},
	},
	[1026] = {
		["ChapterPos"] = 2,
		["Name"] = "大理王族",
		["SectionNo"] = 5,
		["ChapterNo"] = 1026,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1026,
		["Enemy"] = { [1] = 10241, [2] = 10242, [3] = 10243, [4] = 10244, [5] = 10245, [6] = 10246, [7] = 10247, [8] = 10248,		},
	},
	[1030] = {
		["ChapterPos"] = 6,
		["Name"] = "大战少林",
		["SectionNo"] = 5,
		["ChapterNo"] = 1030,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1004,
		["Enemy"] = { [1] = 10275, [2] = 10276, [3] = 10277, [4] = 10278, [5] = 10279, [6] = 10280, [7] = 10281, [8] = 10282, [9] = 10283,		},
	},
	[1034] = {
		["ChapterPos"] = 3,
		["Name"] = "边城浪子",
		["SectionNo"] = 6,
		["ChapterNo"] = 1034,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1034,
		["Enemy"] = { [1] = 10314, [2] = 10315, [3] = 10316, [4] = 10317, [5] = 10318, [6] = 10319, [7] = 10320, [8] = 10321, [9] = 10322,		},
	},
	[1038] = {
		["ChapterPos"] = 1,
		["Name"] = "金鹏王朝",
		["SectionNo"] = 7,
		["ChapterNo"] = 1038,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1038,
		["Enemy"] = { [1] = 10349, [2] = 10350, [3] = 10351, [4] = 10352, [5] = 10353, [6] = 10354, [7] = 10355, [8] = 10356, [9] = 10357, [10] = 10358,		},
	},
	[1042] = {
		["ChapterPos"] = 5,
		["Name"] = "幽灵山庄",
		["SectionNo"] = 7,
		["ChapterNo"] = 1042,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1042,
		["Enemy"] = { [1] = 10388, [2] = 10389, [3] = 10390, [4] = 10391, [5] = 10392, [6] = 10393, [7] = 10394, [8] = 10395, [9] = 10396,		},
	},
	[1027] = {
		["ChapterPos"] = 3,
		["Name"] = "聚义庄难",
		["SectionNo"] = 5,
		["ChapterNo"] = 1027,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1027,
		["Enemy"] = { [1] = 10249, [2] = 10250, [3] = 10251, [4] = 10252, [5] = 10253, [6] = 10254, [7] = 10255, [8] = 10256, [9] = 10257,		},
	},
	[1031] = {
		["ChapterPos"] = 7,
		["Name"] = "英雄末路",
		["SectionNo"] = 5,
		["ChapterNo"] = 1031,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1031,
		["Enemy"] = { [1] = 10284, [2] = 10285, [3] = 10286, [4] = 10287, [5] = 10288, [6] = 10289, [7] = 10290, [8] = 10291, [9] = 10292,		},
	},
	[1035] = {
		["ChapterPos"] = 4,
		["Name"] = "孔雀山庄",
		["SectionNo"] = 6,
		["ChapterNo"] = 1035,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1035,
		["Enemy"] = { [1] = 10323, [2] = 10324, [3] = 10325, [4] = 10326, [5] = 10327, [6] = 10328, [7] = 10329, [8] = 10330, [9] = 10331,		},
	},
	[1039] = {
		["ChapterPos"] = 2,
		["Name"] = "绣花大盗",
		["SectionNo"] = 7,
		["ChapterNo"] = 1039,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1039,
		["Enemy"] = { [1] = 10359, [2] = 10360, [3] = 10361, [4] = 10362, [5] = 10363, [6] = 10364, [7] = 10365, [8] = 10366, [9] = 10367,		},
	},
	[1002] = {
		["ChapterPos"] = 2,
		["Name"] = "衡阳城",
		["SectionNo"] = 1,
		["ChapterNo"] = 1002,
		["RewardDes"] = "tl_+10;yb_+20",
		["ChapterIcon"] = 1002,
		["Enemy"] = { [1] = 10011, [2] = 10012, [3] = 10013, [4] = 10014, [5] = 10015, [6] = 10016, [7] = 10017, [8] = 10018, [9] = 10019, [10] = 10020,		},
	},
	[1004] = {
		["ChapterPos"] = 4,
		["Name"] = "少林别院",
		["SectionNo"] = 1,
		["ChapterNo"] = 1004,
		["RewardDes"] = "tl_+10;yl_+200000",
		["ChapterIcon"] = 1004,
		["Enemy"] = { [1] = 10033, [2] = 10034, [3] = 10035, [4] = 10036, [5] = 10037, [6] = 10038, [7] = 10039, [8] = 10040, [9] = 10041, [10] = 10042,		},
	},
	[1006] = {
		["ChapterPos"] = 6,
		["Name"] = "并派大会",
		["SectionNo"] = 1,
		["ChapterNo"] = 1006,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1006,
		["Enemy"] = { [1] = 10052, [2] = 10053, [3] = 10054, [4] = 10055, [5] = 10056, [6] = 10057, [7] = 10058, [8] = 10059, [9] = 10060, [10] = 10061,		},
	},
	[1008] = {
		["ChapterPos"] = 1,
		["Name"] = "杨刀大会",
		["SectionNo"] = 2,
		["ChapterNo"] = 1008,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1008,
		["Enemy"] = { [1] = 10071, [2] = 10072, [3] = 10073, [4] = 10074, [5] = 10075, [6] = 10076, [7] = 10077, [8] = 10078, [9] = 10079, [10] = 10080,		},
	},
	[1010] = {
		["ChapterPos"] = 3,
		["Name"] = "决战明教",
		["SectionNo"] = 2,
		["ChapterNo"] = 1010,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1010,
		["Enemy"] = { [1] = 10090, [2] = 10091, [3] = 10092, [4] = 10093, [5] = 10094, [6] = 10095, [7] = 10096, [8] = 10097, [9] = 10098, [10] = 10099, [11] = 10100, [12] = 10101,		},
	},
	[1012] = {
		["ChapterPos"] = 5,
		["Name"] = "冰火之地",
		["SectionNo"] = 2,
		["ChapterNo"] = 1012,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1012,
		["Enemy"] = { [1] = 10114, [2] = 10115, [3] = 10116, [4] = 10117, [5] = 10118, [6] = 10119, [7] = 10120, [8] = 10121, [9] = 10122, [10] = 10123,		},
	},
	[1014] = {
		["ChapterPos"] = 1,
		["Name"] = "终南古墓",
		["SectionNo"] = 3,
		["ChapterNo"] = 1014,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1014,
		["Enemy"] = { [1] = 10134, [2] = 10135, [3] = 10136, [4] = 10137, [5] = 10138, [6] = 10139, [7] = 10140, [8] = 10141, [9] = 10142, [10] = 10143, [11] = 10144,		},
	},
	[1016] = {
		["ChapterPos"] = 3,
		["Name"] = "丐帮大会",
		["SectionNo"] = 3,
		["ChapterNo"] = 1016,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1000,
		["Enemy"] = { [1] = 10152, [2] = 10153, [3] = 10154, [4] = 10155, [5] = 10156, [6] = 10157, [7] = 10158, [8] = 10159, [9] = 10160, [10] = 10161,		},
	},
	[1018] = {
		["ChapterPos"] = 5,
		["Name"] = "死守襄阳",
		["SectionNo"] = 3,
		["ChapterNo"] = 1018,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1018,
		["Enemy"] = { [1] = 10170, [2] = 10171, [3] = 10172, [4] = 10173, [5] = 10174, [6] = 10175, [7] = 10176,		},
	},
	[1020] = {
		["ChapterPos"] = 2,
		["Name"] = "完颜王府",
		["SectionNo"] = 4,
		["ChapterNo"] = 1020,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1020,
		["Enemy"] = { [1] = 10185, [2] = 10186, [3] = 10187, [4] = 10188, [5] = 10189, [6] = 10190, [7] = 10191, [8] = 10192, [9] = 10193, [10] = 10194, [11] = 10195,		},
	},
	[1022] = {
		["ChapterPos"] = 4,
		["Name"] = "将军庙",
		["SectionNo"] = 4,
		["ChapterNo"] = 1022,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1022,
		["Enemy"] = { [1] = 10205, [2] = 10206, [3] = 10207, [4] = 10208, [5] = 10209, [6] = 10210, [7] = 10211, [8] = 10212, [9] = 10213,		},
	},
	[1024] = {
		["ChapterPos"] = 6,
		["Name"] = "华山论剑",
		["SectionNo"] = 4,
		["ChapterNo"] = 1024,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1007,
		["Enemy"] = { [1] = 10223, [2] = 10224, [3] = 10225, [4] = 10226, [5] = 10227, [6] = 10228, [7] = 10229, [8] = 10230,		},
	},
	[1028] = {
		["ChapterPos"] = 4,
		["Name"] = "珍珑棋局",
		["SectionNo"] = 5,
		["ChapterNo"] = 1028,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1028,
		["Enemy"] = { [1] = 10258, [2] = 10259, [3] = 10260, [4] = 10261, [5] = 10262, [6] = 10263, [7] = 10264, [8] = 10265,		},
	},
	[1032] = {
		["ChapterPos"] = 1,
		["Name"] = "多情剑客",
		["SectionNo"] = 6,
		["ChapterNo"] = 1032,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1032,
		["Enemy"] = { [1] = 10293, [2] = 10294, [3] = 10295, [4] = 10296, [5] = 10297, [6] = 10298, [7] = 10299, [8] = 10300, [9] = 10301, [10] = 10302, [11] = 10303,		},
	},
	[1036] = {
		["ChapterPos"] = 5,
		["Name"] = "明月一刀",
		["SectionNo"] = 6,
		["ChapterNo"] = 1036,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1036,
		["Enemy"] = { [1] = 10332, [2] = 10333, [3] = 10334, [4] = 10335, [5] = 10336, [6] = 10337, [7] = 10338, [8] = 10339,		},
	},
	[1040] = {
		["ChapterPos"] = 3,
		["Name"] = "决战前后",
		["SectionNo"] = 7,
		["ChapterNo"] = 1040,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1040,
		["Enemy"] = { [1] = 10368, [2] = 10369, [3] = 10370, [4] = 10371, [5] = 10372, [6] = 10373, [7] = 10374, [8] = 10375, [9] = 10376, [10] = 10377,		},
	},
	[1041] = {
		["ChapterPos"] = 4,
		["Name"] = "剑神一笑",
		["SectionNo"] = 7,
		["ChapterNo"] = 1041,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1041,
		["Enemy"] = { [1] = 10378, [2] = 10379, [3] = 10380, [4] = 10381, [5] = 10382, [6] = 10383, [7] = 10384, [8] = 10385, [9] = 10386, [10] = 10387,		},
	},
	[1025] = {
		["ChapterPos"] = 1,
		["Name"] = "万劫之谷",
		["SectionNo"] = 5,
		["ChapterNo"] = 1025,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1025,
		["Enemy"] = { [1] = 10231, [2] = 10232, [3] = 10233, [4] = 10234, [5] = 10235, [6] = 10236, [7] = 10237, [8] = 10238, [9] = 10239, [10] = 10240,		},
	},
	[1029] = {
		["ChapterPos"] = 5,
		["Name"] = "天山灵鹫",
		["SectionNo"] = 5,
		["ChapterNo"] = 1029,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1029,
		["Enemy"] = { [1] = 10266, [2] = 10267, [3] = 10268, [4] = 10269, [5] = 10270, [6] = 10271, [7] = 10272, [8] = 10273, [9] = 10274,		},
	},
	[1033] = {
		["ChapterPos"] = 2,
		["Name"] = "无情剑",
		["SectionNo"] = 6,
		["ChapterNo"] = 1033,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1033,
		["Enemy"] = { [1] = 10304, [2] = 10305, [3] = 10306, [4] = 10307, [5] = 10308, [6] = 10309, [7] = 10310, [8] = 10311, [9] = 10312, [10] = 10313,		},
	},
	[1037] = {
		["ChapterPos"] = 6,
		["Name"] = "又见飞刀",
		["SectionNo"] = 6,
		["ChapterNo"] = 1037,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1037,
		["Enemy"] = { [1] = 10340, [2] = 10341, [3] = 10342, [4] = 10343, [5] = 10344, [6] = 10345, [7] = 10346, [8] = 10347, [9] = 10348,		},
	},
	[1001] = {
		["ChapterPos"] = 1,
		["Name"] = "福州林家",
		["SectionNo"] = 1,
		["RewardDes"] = "tl_+5;yb_+10",
		["ChapterNo"] = 1001,
		["ChapterIcon"] = 1001,
		["Enemy"] = { [1] = 10001, [2] = 10002, [3] = 10003, [4] = 10004, [5] = 10005, [6] = 10006, [7] = 10007, [8] = 10008, [9] = 10009, [10] = 10010,		},
	},
	[1003] = {
		["ChapterPos"] = 3,
		["Name"] = "西湖梅园",
		["SectionNo"] = 1,
		["ChapterNo"] = 1003,
		["RewardDes"] = "tl_+10;yb_+30",
		["ChapterIcon"] = 1003,
		["Enemy"] = { [1] = 10021, [2] = 10022, [3] = 10023, [4] = 10024, [5] = 10025, [6] = 10026, [7] = 10027, [8] = 10028, [9] = 10029, [10] = 10030, [11] = 10031, [12] = 10032,		},
	},
	[1005] = {
		["ChapterPos"] = 5,
		["Name"] = "神教总坛",
		["SectionNo"] = 1,
		["ChapterNo"] = 1005,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1005,
		["Enemy"] = { [1] = 10043, [2] = 10044, [3] = 10045, [4] = 10046, [5] = 10047, [6] = 10048, [7] = 10049, [8] = 10050, [9] = 10051,		},
	},
	[1007] = {
		["ChapterPos"] = 7,
		["Name"] = "华山密洞",
		["SectionNo"] = 1,
		["ChapterNo"] = 1007,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1007,
		["Enemy"] = { [1] = 10062, [2] = 10063, [3] = 10064, [4] = 10065, [5] = 10066, [6] = 10067, [7] = 10068, [8] = 10069, [9] = 10070,		},
	},
	[1009] = {
		["ChapterPos"] = 2,
		["Name"] = "蝴蝶谷",
		["SectionNo"] = 2,
		["ChapterNo"] = 1009,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1009,
		["Enemy"] = { [1] = 10081, [2] = 10082, [3] = 10083, [4] = 10084, [5] = 10085, [6] = 10086, [7] = 10087, [8] = 10088, [9] = 10089,		},
	},
	[1011] = {
		["ChapterPos"] = 4,
		["Name"] = "古寺万安",
		["SectionNo"] = 2,
		["ChapterNo"] = 1011,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1011,
		["Enemy"] = { [1] = 10102, [2] = 10103, [3] = 10104, [4] = 10105, [5] = 10106, [6] = 10107, [7] = 10108, [8] = 10109, [9] = 10110, [10] = 10111, [11] = 10112, [12] = 10113,		},
	},
	[1043] = {
		["ChapterPos"] = 6,
		["Name"] = "凤舞九天",
		["SectionNo"] = 7,
		["RewardDes"] = "tl_+10;yb_+50",
		["ChapterIcon"] = 1043,
		["ChapterNo"] = 1043,
		["Enemy"] = { [1] = 10397, [2] = 10398, [3] = 10399, [4] = 10400, [5] = 10401, [6] = 10402, [7] = 10403, [8] = 10404, [9] = 10405, [10] = 10406,		},
	},
}