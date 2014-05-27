--- 
-- 珍珑迷宫表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.MazeXls
-- 

module("xls.MazeXls")

--- 
-- @type MazeXls
-- @field	#number	Yuanbao	消耗元宝	 
-- @field	#number	EnterType	进入迷宫类型	 
-- @field	#number	Cash	消耗库银	 
-- 

--- 
-- MazeXls
-- @field [parent=#xls.MazeXls] #MazeXls MazeXls
-- 

--- 
-- data
-- @field [parent=#xls.MazeXls] #table data EnterType -> @{MazeXls}表
-- 
data = 
{
	[1] = {
		["Yuanbao"] = 5,
		["EnterType"] = 1,
		["Cash"] = 10000,
	},
	[2] = {
		["Yuanbao"] = 10,
		["EnterType"] = 2,
		["Cash"] = 20000,
	},
	[3] = {
		["Yuanbao"] = 30,
		["EnterType"] = 3,
		["Cash"] = 30000,
	},
	[4] = {
		["Yuanbao"] = 50,
		["EnterType"] = 4,
		["Cash"] = 50000,
	},
}