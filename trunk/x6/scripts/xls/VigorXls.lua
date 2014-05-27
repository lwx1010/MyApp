--- 
-- 购买精力表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.VigorXls
-- 

module("xls.VigorXls")

--- 
-- @type VigorXls
-- @field	#number	Yuanbao	消耗元宝	 
-- @field	#number	BuyNo	第几次购买	 
-- @field	#number	GetVigor	获得精力	 
-- 

--- 
-- VigorXls
-- @field [parent=#xls.VigorXls] #VigorXls VigorXls
-- 

--- 
-- data
-- @field [parent=#xls.VigorXls] #table data BuyNo -> @{VigorXls}表
-- 
data = 
{
	[1] = {
		["Yuanbao"] = 20,
		["BuyNo"] = 1,
		["GetVigor"] = 5,
	},
	[2] = {
		["Yuanbao"] = 30,
		["BuyNo"] = 2,
		["GetVigor"] = 5,
	},
	[3] = {
		["Yuanbao"] = 40,
		["BuyNo"] = 3,
		["GetVigor"] = 5,
	},
	[4] = {
		["Yuanbao"] = 40,
		["BuyNo"] = 4,
		["GetVigor"] = 5,
	},
}