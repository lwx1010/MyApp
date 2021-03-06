--- 
-- 运营活动表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.ActivityXls
-- 

module("xls.ActivityXls")

--- 
-- @type ActivityXls
-- @field	#string	ToUrl	活动链接	notNull
-- @field	#string	Reward	活动奖励	notNull
-- @field	#string	Time	活动时间	 
-- @field	#string	Info	活动内容	 
-- @field	#string	Name	活动名称	 
-- @field	#number	ActivityNo	活动编号	 
-- @field	#number	ActTrueNo	活动真实编号	notNull
-- @field	#number	Pic	图片	notNull
-- 

--- 
-- ActivityXls
-- @field [parent=#xls.ActivityXls] #ActivityXls ActivityXls
-- 

--- 
-- data
-- @field [parent=#xls.ActivityXls] #table data ActivityNo -> @{ActivityXls}表
-- 
data = 
{
	[880] = {
		["ToUrl"] = "",
		["Reward"] = "竭尽心力礼包",
		["Time"] = "开服日起-永久",
		["Info"] = "每天玩家首次体力值或精力值达到0，均可获得1个竭尽心力礼包。",
		["Name"] = "竭尽心力有惊喜",
		["ActivityNo"] = 880,
		["ActTrueNo"] = 1002,
		["Pic"] = 1002,
	},
	[950] = {
		["ToUrl"] = "",
		["Time"] = "2014年2月13日-2014年2月15日",
		["Name"] = "元宵节累积消费送神兵",
		["Info"] = "元宵节活动期间，累积消费达到指定元宝数额，可获得以下奖励：\\n累积消费满500元宝送橙装宝箱*1；\\n累积消费1000元宝送橙装宝箱*2；\\n累积消费1500元宝送橙装宝箱*3，大还丹*1；\\n累积消费2000元宝送橙装宝箱*4，大还丹*1，升星丹*5，尚品汤圆*1；\\n累积消费3000元宝送橙装宝箱*5，大还丹*2，升星丹*8，尚品汤圆*2；\\n累积消费5000元宝送神兵宝匣*1，大还丹*2，升星丹*10，尚品汤圆*3；\\n累积消费8000元宝送神兵宝匣*1，大还丹*4，升星丹*16，尚品汤圆*4；\\n累积消费10000元宝送神兵宝匣*1，大还丹*5，升星丹*20，尚品汤圆*4；\\n累积消费20000元宝送神兵宝匣*2，大还丹*10，升星丹*40，尚品汤圆*4。",
		["ActivityNo"] = 950,
		["ActTrueNo"] = 1013,
		["Reward"] = "神兵、升星丹、大还丹、尚品汤圆",
	},
	[940] = {
		["ToUrl"] = "",
		["Time"] = "2014年2月13日-2014年2月15日",
		["Name"] = "元宵节吃汤圆",
		["Info"] = "元宵节活动期间，挑战副本、比武、夺宝均能获得制作汤圆的材料，获得材料后在奇遇——元宵节活动界面进行制作汤圆。\\n 汤圆可增加上阵侠客经验。\\n 尚品汤圆可永久增加侠客的三围基础属性（最多只能食用3个）。",
		["ActivityNo"] = 940,
		["ActTrueNo"] = 1012,
		["Reward"] = "汤圆",
	},
	[860] = {
		["ToUrl"] = "",
		["Reward"] = "大侠礼包",
		["Time"] = "开服日起-永久",
		["Info"] = "玩家首次登录游戏，即可获得一个1级大侠礼包，每提升5级即可获得对应的等级礼包。礼包包含游戏所需的各种物资，后期还有橙色侠客卡哦！",
		["Name"] = "争做冲级达人，奖励送不停",
		["ActivityNo"] = 860,
		["ActTrueNo"] = 1003,
		["Pic"] = 1003,
	},
	[930] = {
		["ToUrl"] = "",
		["Time"] = "2014年1月29日-2014年2月10日",
		["Name"] = "爆竹声声辞旧岁",
		["Info"] = "在春节期间，挑战副本可掉落烟花爆竹，燃放烟花爆竹可获得新年好礼：银两、元宝、升星丹、体力精力、喜好品等。",
		["ActivityNo"] = 930,
		["ActTrueNo"] = 1011,
		["Reward"] = "各种宝物",
	},
	[120] = {
		["ToUrl"] = "",
		["Reward"] = "元宝、令狐大侠",
		["Time"] = "开服日起-永久",
		["Info"] = "玩家首次充值，可获双倍元宝的奖励，并赠送一张最强橙色“令少侠”卡牌。奖励元宝即时到账，卡牌请在任务奖励中领取。",
		["Name"] = "首充获双倍元宝",
		["ActivityNo"] = 120,
		["ActTrueNo"] = 1006,
		["Pic"] = 1006,
	},
	[920] = {
		["ToUrl"] = "",
		["Time"] = "2014年1月29日-2014年2月10日",
		["Name"] = "新春送红包，签到有惊喜",
		["Info"] = "在春节期间，持续登录游戏，可在签到系统中领取额外惊喜奖励，每次签到均能获得红包。红包中包含银两、橙色装备、升星丹、矿石、兽魂等意外收获。",
		["ActivityNo"] = 920,
		["ActTrueNo"] = 1010,
		["Reward"] = "新年红包",
	},
	[910] = {
		["ToUrl"] = "",
		["Time"] = "2014年1月29日-2014年2月10日",
		["Name"] = "新春有好礼，充值送神兵",
		["Info"] = "累计充值180元宝，获赠橙色装备箱*1。\\n累计充值280元宝，获赠橙色装备箱*2。\\n累计充值580元宝，获赠橙色装备箱*4。\\n累计充值880元宝，获赠橙色装备箱*6。\\n累计充值1880元宝，获赠橙色装备箱*12。\\n累计充值2880元宝，获赠神兵“养吾剑”。\\n累计充值5880元宝，获赠神兵“软猬甲”。\\n累计充值8880元宝，获赠神兵“倚天剑”。\\n累计充值18880元宝，获赠神兵“屠龙刀”，大还丹*10\\n累计充值28880元宝，获赠神兵宝匣*3，大还丹*10。\\n累计充值58880元宝，获赠神兵宝匣*5，大还丹*10。\\n累计充值满88880元宝，获赠神兵宝匣*5，大还丹*20，升星丹*40。",
		["ActivityNo"] = 910,
		["ActTrueNo"] = 1008,
		["Reward"] = "橙装、神兵、大还丹等",
	},
	[960] = {
		["ToUrl"] = "",
		["Time"] = "2014年1月29日-2014年2月10日",
		["Name"] = "抽卡连连，1+N",
		["Info"] = "在集市抽卡中每抽到一次紫色及紫色品质以上的侠客卡，将有机会额外获得该侠客对应的天赋武学秘籍，或该侠客相应的缘分侠客碎片。",
		["ActivityNo"] = 960,
		["ActTrueNo"] = 1004,
		["Reward"] = "武学秘籍、侠客碎片",
	},
	[840] = {
		["ToUrl"] = "",
		["Reward"] = "奇珍袋",
		["Time"] = "开服日起-永久",
		["Info"] = "每天在11:00:00-14:00:00、18:00:00-21:00:00时在线，均可分别获得1个奇珍袋，可开出各种珍贵宝物。",
		["Name"] = "每天登录送奇珍袋",
		["ActivityNo"] = 840,
		["ActTrueNo"] = 1001,
		["Pic"] = 1001,
	},
	[870] = {
		["ToUrl"] = "",
		["Reward"] = "英雄礼包、名榜礼包",
		["Time"] = "开服日起-永久",
		["Info"] = "每周日0时刷新的排行榜单中前十名玩家将获得丰厚奖励。\\n第1名玩家，可获得一份英雄礼包（大）。\\n第2名玩家，可获得一份英雄礼包（中）。\\n第3名玩家，可获得一份英雄礼包（小）。\\n4-10名玩家，可获得一份名人礼包。\\n此活动每周为1个奖励循环。",
		["Name"] = "榜上有名",
		["ActivityNo"] = 870,
		["ActTrueNo"] = 1005,
		["Pic"] = 1005,
	},
	[130] = {
		["ToUrl"] = "",
		["Reward"] = "元宝",
		["Time"] = "开服日起-永久",
		["Info"] = "单笔充值200元宝，额外返还20元宝。\\n单笔充值400元宝，额外返还40元宝。\\n单笔充值680元宝，额外返还68元宝。\\n单笔充值980元宝，额外返还98元宝。\\n单笔充值1980元宝，额外返还208元宝。\\n单笔充值3280元宝，额外返还408元宝。\\n单笔充值6480元宝，额外返还808元宝。",
		["Name"] = "单笔充值，送礼无上限",
		["ActivityNo"] = 130,
		["ActTrueNo"] = 1007,
		["Pic"] = 1007,
	},
	[900] = {
		["ToUrl"] = "",
		["Reward"] = "元宝",
		["Time"] = "开服日起-永久",
		["Info"] = "在《大豪侠》的游戏世界里，创建角色即可获得元宝200、银两8万，初入江湖，这些盘缠能帮您打开您的豪侠之路。",
		["Name"] = "初入江湖赠盘缠",
		["ActivityNo"] = 900,
		["ActTrueNo"] = 1009,
		["Pic"] = 1009,
	},
}