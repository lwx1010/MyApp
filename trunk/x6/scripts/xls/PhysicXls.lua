--- 
-- 购买体力表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.PhysicXls
-- 

module("xls.PhysicXls")

--- 
-- @type PhysicXls
-- @field	#number	Yuanbao	消耗元宝	 
-- @field	#number	BuyNo	第几次购买	 
-- @field	#number	GetPhy	获得体力	 
-- 

--- 
-- PhysicXls
-- @field [parent=#xls.PhysicXls] #PhysicXls PhysicXls
-- 

--- 
-- data
-- @field [parent=#xls.PhysicXls] #table data BuyNo -> @{PhysicXls}表
-- 
data = 
{
	[1] = {
		["Yuanbao"] = 20,
		["BuyNo"] = 1,
		["GetPhy"] = 8,
	},
	[2] = {
		["Yuanbao"] = 30,
		["BuyNo"] = 2,
		["GetPhy"] = 8,
	},
	[3] = {
		["Yuanbao"] = 40,
		["BuyNo"] = 3,
		["GetPhy"] = 8,
	},
	[4] = {
		["Yuanbao"] = 40,
		["BuyNo"] = 4,
		["GetPhy"] = 8,
	},
}