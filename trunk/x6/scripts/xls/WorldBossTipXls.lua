--- 
-- 世界BOSS提示信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.WorldBossTipXls
-- 

module("xls.WorldBossTipXls")

--- 
-- @type WorldBossTipXls
-- @field	#number	TipNo	提示编号	 
-- @field	#string	TipMsg	提示内容	 
-- 

--- 
-- WorldBossTipXls
-- @field [parent=#xls.WorldBossTipXls] #WorldBossTipXls WorldBossTipXls
-- 

--- 
-- data
-- @field [parent=#xls.WorldBossTipXls] #table data TipNo -> @{WorldBossTipXls}表
-- 
data = 
{
	[1] = {
		["TipNo"] = 1,
		["TipMsg"] = "对Boss伤害超过10%以后，战斗伤害奖励将减半。",
	},
	[2] = {
		["TipNo"] = 2,
		["TipMsg"] = "击杀Boss排名前10的玩家，将在BOSS活动结束后获得额外奖励。",
	},
	[3] = {
		["TipNo"] = 3,
		["TipMsg"] = "Boss每3回合会释放必杀技，请在3回合内猛力攻击Boss",
	},
}