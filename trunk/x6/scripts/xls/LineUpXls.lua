--- 
-- 阵位加成表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.LineUpXls
-- 

module("xls.LineUpXls")

--- 
-- @type LineUpXls
-- @field	#number	Dp	防御(万分比)	 
-- @field	#number	Speed	速度(万分比)	 
-- @field	#number	Pos	位置	 
-- @field	#number	Hp	生命(万分比)	 
-- @field	#number	Ap	攻击(万分比)	 
-- 

--- 
-- LineUpXls
-- @field [parent=#xls.LineUpXls] #LineUpXls LineUpXls
-- 

--- 
-- data
-- @field [parent=#xls.LineUpXls] #table data Pos -> @{LineUpXls}表
-- 
data = 
{
	[1] = {
		["Dp"] = 1000,
		["Speed"] = 0,
		["Pos"] = 1,
		["Hp"] = 2000,
		["Ap"] = -1000,
	},
	[2] = {
		["Dp"] = 1000,
		["Speed"] = 0,
		["Pos"] = 2,
		["Hp"] = 2000,
		["Ap"] = -1000,
	},
	[3] = {
		["Dp"] = 1000,
		["Speed"] = 0,
		["Pos"] = 3,
		["Hp"] = 2000,
		["Ap"] = -1000,
	},
	[4] = {
		["Dp"] = -1500,
		["Speed"] = 0,
		["Pos"] = 4,
		["Hp"] = -1500,
		["Ap"] = 1500,
	},
	[5] = {
		["Dp"] = -1500,
		["Speed"] = 0,
		["Pos"] = 5,
		["Hp"] = -1500,
		["Ap"] = 1500,
	},
	[6] = {
		["Dp"] = -1500,
		["Speed"] = 0,
		["Pos"] = 6,
		["Hp"] = -1500,
		["Ap"] = 1500,
	},
	[7] = {
		["Dp"] = -500,
		["Speed"] = 2000,
		["Pos"] = 7,
		["Hp"] = -500,
		["Ap"] = 0,
	},
	[8] = {
		["Dp"] = -500,
		["Speed"] = 2000,
		["Pos"] = 8,
		["Hp"] = -500,
		["Ap"] = 0,
	},
	[9] = {
		["Dp"] = -500,
		["Speed"] = 2000,
		["Pos"] = 9,
		["Hp"] = -500,
		["Ap"] = 0,
	},
}