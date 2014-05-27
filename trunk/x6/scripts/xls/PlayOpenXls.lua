--- 
-- 玩法开放等级表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.PlayOpenXls
-- 

module("xls.PlayOpenXls")

--- 
-- @type PlayOpenXls
-- @field	#number	OpenIcon	玩法图片	notNull
-- @field	#string	Name	玩法名称	 
-- @field	#number	StartLevel	开放等级	 
-- @field	#string	OpenDesc	玩法说明	notNull
-- @field	#string	Remark	备注	 
-- @field	#number	HasOpenTip	是否有开放提示	notNull
-- 

--- 
-- PlayOpenXls
-- @field [parent=#xls.PlayOpenXls] #PlayOpenXls PlayOpenXls
-- 

--- 
-- data
-- @field [parent=#xls.PlayOpenXls] #table data Name -> @{PlayOpenXls}表
-- 
data = 
{
	["biguanxiulian"] = {
		["OpenDesc"] = "",
		["Remark"] = "闭关修炼",
		["Name"] = "biguanxiulian",
		["StartLevel"] = 15,
	},
	["migong"] = {
		["OpenDesc"] = "",
		["Remark"] = "迷宫",
		["Name"] = "migong",
		["StartLevel"] = 5,
	},
	["xitongshezhi"] = {
		["OpenDesc"] = "",
		["Remark"] = "系统设置",
		["Name"] = "xitongshezhi",
		["StartLevel"] = 1,
	},
	["buff"] = {
		["OpenIcon"] = 12,
		["Name"] = "buff",
		["StartLevel"] = 13,
		["OpenDesc"] = "<c9>参悟武学<c6>玩法开启了，参悟可在短时间内增加侠客属性，提高战斗效率！但只在<c9>一定时间内<c6>有效哦，抓紧机会！",
		["Remark"] = "参悟武学",
		["HasOpenTip"] = 1,
	},
	["buzhen"] = {
		["OpenDesc"] = "",
		["Remark"] = "布阵",
		["Name"] = "buzhen",
		["StartLevel"] = 1,
	},
	["jianghu"] = {
		["OpenDesc"] = "",
		["Remark"] = "江湖",
		["Name"] = "jianghu",
		["StartLevel"] = 1,
	},
	["shilian"] = {
		["OpenIcon"] = 13,
		["Name"] = "shilian",
		["StartLevel"] = 14,
		["OpenDesc"] = "<c6>大侠，<c9>至尊试炼玩法<c6>开启了！您可以挑战高难度的精英组合，每个精英组合拥有3种难度，难度越高奖励越好！",
		["Remark"] = "至尊试炼",
		["HasOpenTip"] = 1,
	},
	["boss"] = {
		["OpenIcon"] = 10,
		["Name"] = "boss",
		["StartLevel"] = 15,
		["OpenDesc"] = "<c6>大侠，<c9>火麒麟BOSS玩法<c6>开启了，每天12:30~13:00和21:30~22:00火麒麟将降临，和小伙伴们一起围攻它可以获得丰厚的奖励。",
		["Remark"] = "世界BOSS",
	},
	["biwu"] = {
		["OpenIcon"] = 1,
		["Name"] = "biwu",
		["StartLevel"] = 4,
		["OpenDesc"] = "<c6>大侠，<c9>比武玩法<c6>开启了！在比武中可以抢夺其他玩家的装备、侠客以及银两，还能获得积分奖励。",
		["Remark"] = "比武",
		["HasOpenTip"] = 1,
	},
	["zhaocai"] = {
		["OpenIcon"] = 8,
		["Name"] = "zhaocai",
		["StartLevel"] = 10,
		["OpenDesc"] = "<c6>大侠，<c9>招财玩法<c6>开启了，您可以通过招财，快速的获取大量银两，vip等级越高招财次数越多。",
		["Remark"] = "招财",
	},
	["zhenrong"] = {
		["OpenDesc"] = "",
		["Remark"] = "阵容",
		["Name"] = "zhenrong",
		["StartLevel"] = 1,
	},
	["shangcheng"] = {
		["OpenDesc"] = "",
		["Remark"] = "商城",
		["Name"] = "shangcheng",
		["StartLevel"] = 1,
	},
	["jianwenlu"] = {
		["OpenDesc"] = "",
		["Remark"] = "见闻录",
		["Name"] = "jianwenlu",
		["StartLevel"] = 1,
	},
	["tililingqu"] = {
		["OpenIcon"] = 7,
		["Name"] = "tililingqu",
		["StartLevel"] = 7,
		["OpenDesc"] = "<c6>大侠，<c9>体力领取玩法<c6>开启了，每天在饭点的时候都可以领取体力哦！",
		["Remark"] = "体力领取",
	},
	["duobao"] = {
		["OpenIcon"] = 2,
		["Name"] = "duobao",
		["StartLevel"] = 6,
		["OpenDesc"] = "<c6>大侠，<c9>夺宝玩法<c6>开启了！在夺宝中可以抢夺其他玩家的武功秘籍，还能使得大侠您的等级迅速提升哦!",
		["Remark"] = "夺宝",
		["HasOpenTip"] = 1,
	},
	["jiuzhuantongxuan"] = {
		["OpenIcon"] = 6,
		["Name"] = "jiuzhuantongxuan",
		["StartLevel"] = 18,
		["OpenDesc"] = "<c6>大侠，<c9>九转通玄玩法<c6>开启了！您可以通过此玩法修炼出各种真气，注入经脉后可以大大提升您的实力。",
		["Remark"] = "九转通玄",
		["HasOpenTip"] = 1,
	},
	["chuangong"] = {
		["OpenIcon"] = 5,
		["Name"] = "chuangong",
		["StartLevel"] = 11,
		["OpenDesc"] = "<c6>大侠，<c9>传功玩法<c6>开启了！您可以将需要替换下来的侠客将其经验传递给新侠客。快速提高新侠客等级。",
		["Remark"] = "传功",
		["HasOpenTip"] = 1,
	},
	["wulinbang"] = {
		["OpenIcon"] = 4,
		["Name"] = "wulinbang",
		["StartLevel"] = 12,
		["OpenDesc"] = "<c6>大侠，<c9>武林榜玩法<c6>开启了！在武林榜中每个玩家都可以在一段时间后领取自己的奖励，小心不要被人抢到你的奖励哦!",
		["Remark"] = "武林榜",
		["HasOpenTip"] = 1,
	},
	["liaotian"] = {
		["OpenDesc"] = "",
		["Remark"] = "聊天窗口",
		["Name"] = "liaotian",
		["StartLevel"] = 1,
	},
	["juxian"] = {
		["OpenIcon"] = 3,
		["Name"] = "juxian",
		["StartLevel"] = 3,
		["OpenDesc"] = "<c6>大侠，<c9>招贤玩法<c6>开启了，您可以在<c9>招贤玩法<c6>中招募武林中的知名侠客，元宝抽卡获得极品的几率很高！",
		["Remark"] = "聚贤庄",
		["HasOpenTip"] = 1,
	},
	["onlinebonus"] = {
		["OpenDesc"] = "",
		["Remark"] = "在线奖励",
		["Name"] = "onlinebonus",
		["StartLevel"] = 4,
	},
	["hongmengjue"] = {
		["OpenDesc"] = "",
		["Remark"] = "鸿蒙诀",
		["Name"] = "hongmengjue",
		["StartLevel"] = 15,
	},
	["liandeng"] = {
		["OpenDesc"] = "",
		["Remark"] = "连续登陆奖励",
		["Name"] = "liandeng",
		["StartLevel"] = 3,
	},
	["jiangli"] = {
		["OpenDesc"] = "",
		["Remark"] = "奖励",
		["Name"] = "jiangli",
		["StartLevel"] = 1,
	},
	["jiejiao"] = {
		["OpenIcon"] = 9,
		["Name"] = "jiejiao",
		["StartLevel"] = 9,
		["OpenDesc"] = "<c6>大侠，<c9>结交玩法<c6>开启了。武林中的传奇高手不一定要通过抽卡获得，您也可以在结交玩法中通过交付喜好品获得这些传奇高手的好感，以此来招募。",
		["Remark"] = "结交",
	},
}