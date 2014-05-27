--- 
-- 玩法整合信息表格
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.PlayMergeXls
-- 

module("xls.PlayMergeXls")

--- 
-- @type PlayMergeXls
-- @field	#string	Uiid	玩法uiid	 
-- @field	#string	lvUiid	对应开放等级uiid	notNull
-- @field	#string	Icon	玩法图标	 
-- @field	#number	Order	玩法顺序	 
-- 

--- 
-- PlayMergeXls
-- @field [parent=#xls.PlayMergeXls] #PlayMergeXls PlayMergeXls
-- 

--- 
-- data
-- @field [parent=#xls.PlayMergeXls] #table data Order -> @{PlayMergeXls}表
-- 
data = 
{
	[1] = {
		["Uiid"] = "vipreward",
		["lvUiid"] = "",
		["Icon"] = "vip",
		["Order"] = 1,
	},
	[2] = {
		["Uiid"] = "tililingqu",
		["lvUiid"] = "tililingqu",
		["Icon"] = "kfl",
		["Order"] = 2,
	},
	[3] = {
		["Uiid"] = "migong",
		["lvUiid"] = "migong",
		["Icon"] = "mg",
		["Order"] = 3,
	},
	[4] = {
		["Uiid"] = "zhaocai",
		["lvUiid"] = "zhaocai",
		["Icon"] = "zc",
		["Order"] = 4,
	},
	[5] = {
		["Uiid"] = "jiejiaoenter",
		["lvUiid"] = "jiejiao",
		["Icon"] = "jiejiao",
		["Order"] = 5,
	},
	[6] = {
		["Uiid"] = "bossenter",
		["lvUiid"] = "boss",
		["Icon"] = "boss",
		["Order"] = 6,
	},
}