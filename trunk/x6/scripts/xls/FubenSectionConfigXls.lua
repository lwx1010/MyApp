--- 
-- 副本篇章图片位置信息配置表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.FubenSectionConfigXls
-- 

module("xls.FubenSectionConfigXls")

--- 
-- @type FubenSectionConfigXls
-- @field	#number	SectionNameIcon	篇章名称图标	notNull
-- @field	#numbers	SectionIconPos	篇章图标坐标	notNull
-- @field	#number	SectionNo	篇章编号	 
-- 

--- 
-- FubenSectionConfigXls
-- @field [parent=#xls.FubenSectionConfigXls] #FubenSectionConfigXls FubenSectionConfigXls
-- 

--- 
-- data
-- @field [parent=#xls.FubenSectionConfigXls] #table data SectionNo -> @{FubenSectionConfigXls}表
-- 
data = 
{
	[1] = {
		["SectionNameIcon"] = 1,
		["SectionIconPos"] = { [1] = 66, [2] = 247,		},
		["SectionNo"] = 1,
	},
	[2] = {
		["SectionNameIcon"] = 2,
		["SectionIconPos"] = { [1] = 1203, [2] = 280,		},
		["SectionNo"] = 2,
	},
	[3] = {
		["SectionNameIcon"] = 3,
		["SectionIconPos"] = { [1] = 2402, [2] = 267,		},
		["SectionNo"] = 3,
	},
	[4] = {
		["SectionNameIcon"] = 4,
		["SectionIconPos"] = { [1] = 3418, [2] = 247,		},
		["SectionNo"] = 4,
	},
	[5] = {
		["SectionNameIcon"] = 5,
		["SectionIconPos"] = { [1] = 4577, [2] = 284,		},
		["SectionNo"] = 5,
	},
	[6] = {
		["SectionNameIcon"] = 6,
		["SectionIconPos"] = { [1] = 5748, [2] = 280,		},
		["SectionNo"] = 6,
	},
	[7] = {
		["SectionNameIcon"] = 7,
		["SectionIconPos"] = { [1] = 6813, [2] = 153,		},
		["SectionNo"] = 7,
	},
}