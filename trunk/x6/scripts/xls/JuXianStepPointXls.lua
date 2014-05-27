--- 
-- 聚贤抽卡点数
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.JuXianStepPointXls
-- 

module("xls.JuXianStepPointXls")

--- 
-- @type JuXianStepPointXls
-- @field	#number	cType	抽卡类型	 
-- @field	#number	Type	类型	 
-- @field	#number	Step	品阶	 
-- @field	#number	Point	集卡点数	 
-- 

--- 
-- JuXianStepPointXls
-- @field [parent=#xls.JuXianStepPointXls] #JuXianStepPointXls JuXianStepPointXls
-- 

--- 
-- data
-- @field [parent=#xls.JuXianStepPointXls] #table data cType -> @{JuXianStepPointXls}表
-- 
data = 
{
	[12] = {
		["cType"] = 12,
		["Type"] = { [1] = { ["Step"] = { [1] = 0, [2] = 8, [3] = 12, [4] = 36, [5] = 48, }, }, [2] = { ["Step"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 12, [5] = 16, }, },		},
	},
	[11] = {
		["cType"] = 11,
		["Type"] = { [1] = { ["Step"] = { [1] = 0, [2] = 16, [3] = 20, [4] = 36, [5] = 48, }, }, [2] = { ["Step"] = { [1] = 0, [2] = 0, [3] = 10, [4] = 18, [5] = 24, }, },		},
	},
}