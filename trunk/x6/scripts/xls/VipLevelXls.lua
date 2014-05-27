--- 
-- 升级对应的VIP所需的经验值
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.VipLevelXls
-- 

module("xls.VipLevelXls")

--- 
-- @type VipLevelXls
-- @field	#number	VipProgress	Vip升级进度	 
-- @field	#number	VipLevel	Vip等级	 
-- 

--- 
-- VipLevelXls
-- @field [parent=#xls.VipLevelXls] #VipLevelXls VipLevelXls
-- 

--- 
-- data
-- @field [parent=#xls.VipLevelXls] #table data VipLevel -> @{VipLevelXls}表
-- 
data = 
{
	[1] = {
		["VipProgress"] = 200,
		["VipLevel"] = 1,
	},
	[2] = {
		["VipProgress"] = 1000,
		["VipLevel"] = 2,
	},
	[3] = {
		["VipProgress"] = 5000,
		["VipLevel"] = 3,
	},
	[4] = {
		["VipProgress"] = 20000,
		["VipLevel"] = 4,
	},
	[5] = {
		["VipProgress"] = 50000,
		["VipLevel"] = 5,
	},
	[6] = {
		["VipProgress"] = 100000,
		["VipLevel"] = 6,
	},
}