--- 
-- Buff特效索引
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.SkillBuffXls
-- 

module("xls.SkillBuffXls")

--- 
-- @type SkillBuffXls
-- @field	#number	FuncType	功能类型	 
-- @field	#string	BuffName	BUFF名称	 
-- @field	#number	IconNo	图标编号	 
-- @field	#string	BuffDesc	功能描述	notNull
-- @field	#number	BuffNo	BUFF编号	 
-- @field	#number	ResNo	资源编号	notNull
-- 

--- 
-- SkillBuffXls
-- @field [parent=#xls.SkillBuffXls] #SkillBuffXls SkillBuffXls
-- 

--- 
-- data
-- @field [parent=#xls.SkillBuffXls] #table data BuffNo -> @{SkillBuffXls}表
-- 
data = 
{
	[1] = {
		["FuncType"] = 2,
		["BuffName"] = "怒气",
		["IconNo"] = 7000001,
		["BuffDesc"] = "攻击提升",
		["BuffNo"] = 1,
		["ResNo"] = 7000001,
	},
	[2] = {
		["FuncType"] = 2,
		["BuffName"] = "疲惫",
		["IconNo"] = 7000002,
		["BuffDesc"] = "攻击下降",
		["BuffNo"] = 2,
		["ResNo"] = 7000002,
	},
	[3] = {
		["FuncType"] = 3,
		["BuffName"] = "坚守",
		["IconNo"] = 7000003,
		["BuffDesc"] = "防御提升",
		["BuffNo"] = 3,
		["ResNo"] = 7000003,
	},
	[4] = {
		["FuncType"] = 3,
		["BuffName"] = "破甲",
		["IconNo"] = 7000004,
		["BuffDesc"] = "防御下降",
		["BuffNo"] = 4,
		["ResNo"] = 7000004,
	},
	[5] = {
		["FuncType"] = 4,
		["BuffName"] = "急速",
		["IconNo"] = 7000005,
		["BuffDesc"] = "速度提升",
		["BuffNo"] = 5,
		["ResNo"] = 7000005,
	},
	[6] = {
		["FuncType"] = 4,
		["BuffName"] = "迟缓",
		["IconNo"] = 7000006,
		["BuffDesc"] = "速度下降",
		["BuffNo"] = 6,
		["ResNo"] = 7000006,
	},
	[7] = {
		["FuncType"] = 5,
		["BuffName"] = "定身",
		["IconNo"] = 7000007,
		["BuffDesc"] = "无法行动",
		["BuffNo"] = 7,
		["ResNo"] = 7000007,
	},
}