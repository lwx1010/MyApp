--- 
-- 卡牌信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.SetcardXls
-- 

module("xls.SetcardXls")

--- 
-- @type SetcardXls
-- @field	#number	MaxNum	总数量	notNull
-- @field	#number	Type	套卡类型	 
-- @field	#string	Name	名称	 
-- @field	#number	SetCardID	套卡ID	 
-- @field	#string	Icon	图标	notNull
-- @field	#string	Des	描述	 
-- 

--- 
-- SetcardXls
-- @field [parent=#xls.SetcardXls] #SetcardXls SetcardXls
-- 

--- 
-- data
-- @field [parent=#xls.SetcardXls] #table data SetCardID -> @{SetcardXls}表
-- 
data = 
{
	[9001003] = {
		["MaxNum"] = 16,
		["Type"] = 3,
		["Name"] = "纷乱江湖",
		["SetCardID"] = 9001003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9012002] = {
		["SetCardID"] = 9012002,
		["Type"] = 2,
		["Name"] = "特殊篇章",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9011002] = {
		["SetCardID"] = 9011002,
		["Type"] = 2,
		["Name"] = "风云",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9010002] = {
		["SetCardID"] = 9010002,
		["Type"] = 2,
		["Name"] = "大唐双龙传",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9009002] = {
		["SetCardID"] = 9009002,
		["Type"] = 2,
		["Name"] = "覆雨翻云",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9008002] = {
		["SetCardID"] = 9008002,
		["Type"] = 2,
		["Name"] = "楚留香",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9007002] = {
		["SetCardID"] = 9007002,
		["Type"] = 2,
		["Name"] = "陆小凤",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9006002] = {
		["SetCardID"] = 9006002,
		["Type"] = 2,
		["Name"] = "小李飞刀",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9005002] = {
		["SetCardID"] = 9005002,
		["Type"] = 2,
		["Name"] = "血战狂沙",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9004002] = {
		["SetCardID"] = 9004002,
		["Type"] = 2,
		["Name"] = "天下五绝",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9003002] = {
		["SetCardID"] = 9003002,
		["Type"] = 2,
		["Name"] = "古墓绝情",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9002002] = {
		["SetCardID"] = 9002002,
		["Type"] = 2,
		["Name"] = "九阴九阳",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9001002] = {
		["SetCardID"] = 9001002,
		["Type"] = 2,
		["Name"] = "纷乱江湖",
		["Icon"] = "",
		["Des"] = "神兵",
	},
	[9012003] = {
		["SetCardID"] = 9012003,
		["Type"] = 3,
		["Name"] = "特殊篇章",
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9001001] = {
		["MaxNum"] = 39,
		["Type"] = 1,
		["Name"] = "纷乱江湖",
		["SetCardID"] = 9001001,
		["Icon"] = "xiao",
		["Des"] = "侠客",
	},
	[9011003] = {
		["MaxNum"] = 10,
		["Type"] = 3,
		["Name"] = "风云",
		["SetCardID"] = 9011003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9003001] = {
		["MaxNum"] = 37,
		["Type"] = 1,
		["Name"] = "古墓绝情",
		["SetCardID"] = 9003001,
		["Icon"] = "shen",
		["Des"] = "侠客",
	},
	[9004001] = {
		["MaxNum"] = 17,
		["Type"] = 1,
		["Name"] = "天下五绝",
		["SetCardID"] = 9004001,
		["Icon"] = "she",
		["Des"] = "侠客",
	},
	[9003003] = {
		["MaxNum"] = 9,
		["Type"] = 3,
		["Name"] = "古墓绝情",
		["SetCardID"] = 9003003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9006001] = {
		["MaxNum"] = 26,
		["Type"] = 1,
		["Name"] = "小李飞刀",
		["SetCardID"] = 9006001,
		["Icon"] = "li",
		["Des"] = "侠客",
	},
	[9009001] = {
		["MaxNum"] = 28,
		["Type"] = 1,
		["Name"] = "覆雨翻云",
		["SetCardID"] = 9009001,
		["Icon"] = "fu",
		["Des"] = "侠客",
	},
	[9007001] = {
		["MaxNum"] = 24,
		["Type"] = 1,
		["Name"] = "陆小凤",
		["SetCardID"] = 9007001,
		["Icon"] = "lu",
		["Des"] = "侠客",
	},
	[9008001] = {
		["MaxNum"] = 25,
		["Type"] = 1,
		["Name"] = "楚留香",
		["SetCardID"] = 9008001,
		["Icon"] = "chu",
		["Des"] = "侠客",
	},
	[9012001] = {
		["MaxNum"] = 41,
		["Type"] = 1,
		["Name"] = "特殊篇章",
		["SetCardID"] = 9012001,
		["Icon"] = "",
		["Des"] = "侠客",
	},
	[9011001] = {
		["MaxNum"] = 27,
		["Type"] = 1,
		["Name"] = "风云",
		["SetCardID"] = 9011001,
		["Icon"] = "feng",
		["Des"] = "侠客",
	},
	[9010001] = {
		["MaxNum"] = 25,
		["Type"] = 1,
		["Name"] = "大唐双龙传",
		["SetCardID"] = 9010001,
		["Icon"] = "tang",
		["Des"] = "侠客",
	},
	[9010003] = {
		["MaxNum"] = 8,
		["Type"] = 3,
		["Name"] = "大唐双龙传",
		["SetCardID"] = 9010003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9009003] = {
		["MaxNum"] = 9,
		["Type"] = 3,
		["Name"] = "覆雨翻云",
		["SetCardID"] = 9009003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9008003] = {
		["MaxNum"] = 4,
		["Type"] = 3,
		["Name"] = "楚留香",
		["SetCardID"] = 9008003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9007003] = {
		["MaxNum"] = 7,
		["Type"] = 3,
		["Name"] = "陆小凤",
		["SetCardID"] = 9007003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9005001] = {
		["MaxNum"] = 28,
		["Type"] = 1,
		["Name"] = "血战狂沙",
		["SetCardID"] = 9005001,
		["Icon"] = "tian",
		["Des"] = "侠客",
	},
	[9005003] = {
		["MaxNum"] = 8,
		["Type"] = 3,
		["Name"] = "血战狂沙",
		["SetCardID"] = 9005003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9004003] = {
		["MaxNum"] = 5,
		["Type"] = 3,
		["Name"] = "天下五绝",
		["SetCardID"] = 9004003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9002001] = {
		["MaxNum"] = 37,
		["Type"] = 1,
		["Name"] = "九阴九阳",
		["SetCardID"] = 9002001,
		["Icon"] = "yi",
		["Des"] = "侠客",
	},
	[9002003] = {
		["MaxNum"] = 11,
		["Type"] = 3,
		["Name"] = "九阴九阳",
		["SetCardID"] = 9002003,
		["Icon"] = "",
		["Des"] = "武学",
	},
	[9006003] = {
		["MaxNum"] = 7,
		["Type"] = 3,
		["Name"] = "小李飞刀",
		["SetCardID"] = 9006003,
		["Icon"] = "",
		["Des"] = "武学",
	},
}