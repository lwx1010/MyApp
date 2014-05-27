--- 
-- 洗炼消耗表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.XiLianXls
-- 

module("xls.XiLianXls")

--- 
-- @type XiLianXls
-- @field	#number	NeedGold	消耗金矿石	 
-- @field	#number	NeedSilver	消耗银矿石	 
-- @field	#number	NeedIron	消耗铁矿石	 
-- @field	#number	Rare	品质	 
-- 

--- 
-- XiLianXls
-- @field [parent=#xls.XiLianXls] #XiLianXls XiLianXls
-- 

--- 
-- data
-- @field [parent=#xls.XiLianXls] #table data Rare -> @{XiLianXls}表
-- 
data = 
{
	[1] = {
		["NeedGold"] = 1,
		["NeedSilver"] = 1,
		["NeedIron"] = 1,
		["Rare"] = 1,
	},
	[2] = {
		["NeedGold"] = 2,
		["NeedSilver"] = 6,
		["NeedIron"] = 6,
		["Rare"] = 2,
	},
	[3] = {
		["NeedGold"] = 4,
		["NeedSilver"] = 10,
		["NeedIron"] = 10,
		["Rare"] = 3,
	},
	[4] = {
		["NeedGold"] = 10,
		["NeedSilver"] = 20,
		["NeedIron"] = 20,
		["Rare"] = 4,
	},
}