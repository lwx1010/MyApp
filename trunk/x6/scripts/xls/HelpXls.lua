--- 
-- 帮助信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.HelpXls
-- 

module("xls.HelpXls")

--- 
-- @type HelpXls
-- @field	#number	IndexNo	编号	 
-- @field	#string	Name	名字	 
-- @field	#string	Desc	说明	 
-- 

--- 
-- HelpXls
-- @field [parent=#xls.HelpXls] #HelpXls HelpXls
-- 

--- 
-- data
-- @field [parent=#xls.HelpXls] #table data IndexNo -> @{HelpXls}表
-- 
data = 
{
	[1] = {
		["IndexNo"] = 1,
		["Name"] = "角色等级",
		["Desc"] = "影响侠客、装备、武学的等级上限。",
	},
	[2] = {
		["IndexNo"] = 2,
		["Name"] = "声望",
		["Desc"] = "提升角色等级，主要通过江湖挑战获得。",
	},
	[3] = {
		["IndexNo"] = 3,
		["Name"] = "银两",
		["Desc"] = "游戏中的基础流通虚拟货币单位，主要用于聚贤庄获得侠客卡，强化装备，修炼真气，神兵进阶。",
	},
	[4] = {
		["IndexNo"] = 4,
		["Name"] = "元宝",
		["Desc"] = "游戏中的特殊虚拟货币单位，主要通过充值获得，用于获取更高品质的侠客卡、购买特殊物品，更好的进行游戏。",
	},
	[5] = {
		["IndexNo"] = 5,
		["Name"] = "精力",
		["Desc"] = "主要在比武、夺宝挑战中消耗，可通过等待时间或者购买恢复。",
	},
	[6] = {
		["IndexNo"] = 6,
		["Name"] = "体力",
		["Desc"] = "主要在江湖挑战中消耗，可通过等待时间或者购买恢复。",
	},
	[7] = {
		["IndexNo"] = 7,
		["Name"] = "VIP",
		["Desc"] = "尊贵的VIP称号，分为6个等级，可通过充值元宝获得及提升其等级，等级越高，获得的特权和奖励越丰富，同时拥有购买并使用对应VIP特权礼包的权限。",
	},
	[8] = {
		["IndexNo"] = 8,
		["Name"] = "侠客等级",
		["Desc"] = "侠客等级是侠客强弱的标识之一，等级越高，侠客属性越高，战斗力越强，品质越高的侠客等级越高，提升的属性越高。",
	},
	[9] = {
		["IndexNo"] = 9,
		["Name"] = "经验",
		["Desc"] = "主要通过江湖挑战获得，用于提升侠客等级。",
	},
	[10] = {
		["IndexNo"] = 10,
		["Name"] = "侠客特征",
		["Desc"] = "分为进攻型，防御型，均衡型。进攻型攻击偏高，防御型防御偏高，均衡型属性较为平均。",
	},
	[11] = {
		["IndexNo"] = 11,
		["Name"] = "天赋武学",
		["Desc"] = "侠客天生自带的武学，在背包中不存在该武学秘籍，侠客可遗忘天赋武学，遗忘后可在原天赋武学的空位槽上重新学习新的武学。",
	},
	[12] = {
		["IndexNo"] = 12,
		["Name"] = "内力",
		["Desc"] = "主要用于升级武学与突破武学境界，可通过吞元消耗侠客卡获得。",
	},
	[13] = {
		["IndexNo"] = 13,
		["Name"] = "战斗力",
		["Desc"] = "侠客的综合实力表现，战斗力越高，侠客越强。可通过侠客升级、升星，经脉注入真气，穿戴高级装备，学习高级武学，达到提升战斗力的效果。",
	},
	[14] = {
		["IndexNo"] = 14,
		["Name"] = "吞元",
		["Desc"] = "侠客可吞噬其他侠客卡，获取其他侠客卡身上的所有内力，主要用于升级武学与突破武学境界。",
	},
	[15] = {
		["IndexNo"] = 15,
		["Name"] = "升星",
		["Desc"] = "侠客的星级越高，属性越高，通过消耗同品质侠客卡可提升侠客的星级，不同品质的侠客可提升的星级上限不同，橙色品质侠客可最高提升至7星级。",
	},
	[16] = {
		["IndexNo"] = 16,
		["Name"] = "易筋",
		["Desc"] = "侠客拥有任督二脉，三花聚顶，五气朝元，在各经脉中注入不同的真气，可提升侠客的各种属性，同一个侠客身上不可注入同种类的真气。",
	},
	[17] = {
		["IndexNo"] = 17,
		["Name"] = "命数",
		["Desc"] = "不同名侠客之间存在一定的身世或相似关系称之为命数，与有对应关系的侠客上阵会获得额外的战斗属性加成，当上阵的侠客拥有一套首尾相接的相互关系时，阵容属性发挥至极致。",
	},
	[18] = {
		["IndexNo"] = 18,
		["Name"] = "侠客",
		["Desc"] = "分5种品质级别，白、绿、蓝、紫、橙，从左至右由低至高品质排列，橙色品质最高，品质越高，基础属性越好，侠客升级后的基础属性提升越高。",
	},
	[19] = {
		["IndexNo"] = 19,
		["Name"] = "侠客碎片",
		["Desc"] = "分3种品质级别，蓝、紫、橙，橙色品质最高，拥有相应数量的同种碎片可合成对应的侠客卡，品质越高，需要的碎片数量越多。",
	},
	[20] = {
		["IndexNo"] = 20,
		["Name"] = "装备",
		["Desc"] = "分为3类，武器、衣服和饰品，共分4种品质级别，绿、蓝、紫、橙，橙色品质最高，品质越高，装备的属性越好。武器影响侠客的攻击，衣服影响侠客的防御，饰品影响侠客的生命。",
	},
	[21] = {
		["IndexNo"] = 21,
		["Name"] = "装备碎片",
		["Desc"] = "分为2种品质级别，紫、橙，橙色品质最高，拥有相同数量的同种碎片可合成对应的装备，品质越高，需要的碎片数量越多。",
	},
	[22] = {
		["IndexNo"] = 22,
		["Name"] = "神兵",
		["Desc"] = "属于特殊的装备，属性比普通装备强，不可淬炼，不限使用等级，可进阶，阶级越高，属性越好。",
	},
	[23] = {
		["IndexNo"] = 23,
		["Name"] = "武学",
		["Desc"] = "分5种品质级别，白、绿、蓝、紫、橙，从左至右由低至高品质排列，橙色品质最高，品质越高，武学威力越高，升级所需的侠客内力越多，升级后的属性提升越高。",
	},
	[24] = {
		["IndexNo"] = 24,
		["Name"] = "武学碎片",
		["Desc"] = "分4种品质级别，绿、蓝、紫、橙，橙色品质最高，每种武学对应存在多种不同的武学碎片，凑齐一套武学碎片后可合成对应的武学秘籍，品质越高，需要的碎片种类越多。",
	},
	[25] = {
		["IndexNo"] = 25,
		["Name"] = "真气",
		["Desc"] = "分4种品质级别，绿、蓝、紫、橙，橙色品质最高，品质越高，属性越好，可通过修炼获得，注入侠客经脉内提升侠客属性。",
	},
	[26] = {
		["IndexNo"] = 26,
		["Name"] = "江湖",
		["Desc"] = "大侠在江湖中行走，总会遇到些纷争，行侠仗义，清除敌人，可获得一定的声望、经验、银两及贵重物品。每次江湖挑战会消耗1点体力。",
	},
	[27] = {
		["IndexNo"] = 27,
		["Name"] = "奇遇",
		["Desc"] = "江湖挑战中的各种偶发事件，难得一遇，有机会获得额外的经验、银两、珍贵物品。",
	},
	[28] = {
		["IndexNo"] = 28,
		["Name"] = "集市招贤",
		["Desc"] = "角色等级3级时开启。使用银两或元宝抽取侠客卡可获得不同品质的侠客，使用银两抽卡时每次获得更高品质的侠客则可提升好感度，好感度越高，更容易获得更高品质的侠客卡。",
	},
	[29] = {
		["IndexNo"] = 29,
		["Name"] = "比武",
		["Desc"] = "角色等级4级时开启。PVP模式之一，每次挑战消耗1点精力，挑战胜利可获得一定经验、银两、侠客卡碎片、装备碎片。",
	},
	[30] = {
		["IndexNo"] = 30,
		["Name"] = "夺宝",
		["Desc"] = "角色等级6级时开启。PVP模式之一，每次挑战消耗1点精力，挑战胜利可获得一定经验，武学秘籍碎片。",
	},
	[31] = {
		["IndexNo"] = 31,
		["Name"] = "武林榜",
		["Desc"] = "角色等级12级时开启。PVP模式之一，排名越前，获得的收益越好，挑战获胜者可获得对手身上即将可领取的奖励。",
	},
	[32] = {
		["IndexNo"] = 32,
		["Name"] = "BOSS",
		["Desc"] = "角色等级15级时开启。每天定时出现，击杀BOSS后可获得一定的银两奖励，个人对BOSS输出的伤害越高，获得的奖励越高。",
	},
	[33] = {
		["IndexNo"] = 33,
		["Name"] = "闭关修炼",
		["Desc"] = "角色等级15级时开启。侠客可在非上阵状态下获得经验提升等级。",
	},
	[34] = {
		["IndexNo"] = 34,
		["Name"] = "九转通玄",
		["Desc"] = "角色等级18级时开启。在这里可修炼真气，升级真气，修炼成功可递进修炼进度，真气修炼进度越高，更容易获得更高品质的真气。",
	},
	[35] = {
		["IndexNo"] = 35,
		["Name"] = "战斗回合",
		["Desc"] = "双方进入战斗时，10回合内一方全倒生命为零则判定另一方获胜，在战斗中10回合内未能击败对手，判定为失败。",
	},
	[36] = {
		["IndexNo"] = 36,
		["Name"] = "结交",
		["Desc"] = "角色等级9级时开启。在这里可以通过赠送喜好品增加友好度从而招募到高品质的侠客，友好度越高，招募的成功率越高。",
	},
	[37] = {
		["IndexNo"] = 37,
		["Name"] = "鸿蒙诀",
		["Desc"] = "角色等级15级时开启。在这里可以选择您喜欢的偏好神兽，不同神兽附加的属性不同，分均衡型、攻击型、防御型、生命型。",
	},
	[38] = {
		["IndexNo"] = 38,
		["Name"] = "退隐",
		["Desc"] = "退隐可以使侠客卡再次利用，退隐可以得到喜好品、升星丹和银两。",
	},
	[39] = {
		["IndexNo"] = 39,
		["Name"] = "装备分解",
		["Desc"] = "在这里你可以将多余的装备分解，分解的产物是矿石，矿石是装备淬炼所需的材料",
	},
}