--- 
-- 道具显示常量
-- @module view.const.ItemViewConst
-- 
local tr = tr
local ccc3 = ccc3

module("view.const.ItemViewConst")

---
-- 装备类型
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_TYPE
-- 
EQUIP_TYPE = {tr("武器"), tr("衣服"), tr("饰品")}

---
-- 装备品阶颜色表
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_STEP_COLORS
--
EQUIP_STEP_COLORS = {"<c1>", "<c2>", "<c3>", "<c4>", "<c5>"}

---
-- 装备品阶框
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_RARE_COLORS1
-- 
EQUIP_RARE_COLORS1 = { 
		"ccb/mark/boxborder_green.png",
		"ccb/mark/boxborder_blue.png",
		"ccb/mark/boxborder_purple.png",
		"ccb/mark/boxborder_orange.png",
		"ccb/mark/boxborder_red.png"
	}
	
---
-- 装备品阶图标
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_RARE_ICON
-- 
EQUIP_RARE_ICON = {
		"ccb/mark/green.png",
		"ccb/mark/blue.png",
		"ccb/mark/zi.png",
		"ccb/mark/cheng.png",
		"ccb/mark/shen.png"
	}
	
---
-- 装备品阶框(左下角背景)
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_RARE_COLORS2
-- 
EQUIP_RARE_COLORS2 = { 
		"ccb/mark/grademark_green.png",
		"ccb/mark/grademark_blue.png",
		"ccb/mark/grademark_purple.png",
		"ccb/mark/grademark_orange.png",
		"ccb/mark/grademark_red.png",
	}
	
---
-- 罗马数字1-5(用于神兵阶位显示)
-- @field [parent=#ItemViewConst] #table LMNums
-- 
LMNums = {"I", "II", "III", "IV", "V"}

---
-- 装备品阶描边色
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_OUTLINE_COLORS
-- 
EQUIP_OUTLINE_COLORS = {
		ccc3(40, 245, 0),
		ccc3(0, 191, 255),
		ccc3(239, 0, 254),
		ccc3(255, 143, 0),
		ccc3(255, 0, 0),
	}
	
---------------------------------------------------------	
---
-- 武学品阶颜色表
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_STEP_COLORS
--
MARTIAL_STEP_COLORS = {"<c0>", "<c1>", "<c2>", "<c3>", "<c4>"}

---
-- 武学品阶描边色
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_OUTLINE_COLORS
-- 
MARTIAL_OUTLINE_COLORS = {
		ccc3(245, 244, 216),
		ccc3(40, 245, 0),
		ccc3(0, 191, 255),
		ccc3(239, 0, 254),
		ccc3(255, 143, 0),
	}

---
-- 武学品阶框
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_RARE_COLORS1
-- 
MARTIAL_RARE_COLORS1 = { 
		"ccb/mark/boxborder_white.png",
		"ccb/mark/boxborder_green.png",
		"ccb/mark/boxborder_blue.png",
		"ccb/mark/boxborder_purple.png",
		"ccb/mark/boxborder_orange.png",
	}

---
-- 武学品阶图标
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_RARE_ICON
-- 
MARTIAL_RARE_ICON = {
		"ccb/mark/bai.png",
		"ccb/mark/green.png",
		"ccb/mark/blue.png",
		"ccb/mark/zi.png",
		"ccb/mark/cheng.png",
	}

---
-- 武学品阶框(左下角背景)
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_RARE_COLORS2
-- 
MARTIAL_RARE_COLORS2 = { 
		"ccb/mark/grademark_white.png",
		"ccb/mark/grademark_green.png",
		"ccb/mark/grademark_blue.png",
		"ccb/mark/grademark_purple.png",
		"ccb/mark/grademark_orange.png",
	}

---
-- 武学类型
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_TYPE
-- 
MARTIAL_TYPE = {tr("拳脚"), tr("枪棒"), tr("刀剑")}

--- 
-- 武学招式图标（攻 ，杀，守， 奇）
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_SKILL_TYPE
-- 
MARTIAL_SKILL_TYPE = {
		"ccb/mark/atkskillmark.png",
		"ccb/mark/killskillmark.png",
		"ccb/mark/defskillmark.png",
		"ccb/mark/specialskillmark.png",
	}
	
---------------------------------------------------------	
--- 强化界面相关

---
-- 武学类型
-- @field [parent=#view.const.ItemViewConst] #table MARTIAL_ADD_TYPE
-- 
MARTIAL_ADD_TYPE = {tr("拳脚"), tr("枪棒"), tr("刀剑")}

---
-- 神兵阶位
-- @field [parent=#view.const.ItemViewConst] #table SHENBING_STEPS
--  
SHENBING_STEPS = {"0","I", "II", "III", "IV", "V"}

---
-- 神兵附加属性变量对应中文
-- @field [parent=#view.const.ItemViewConst] #table SHENBING_ADD_INFO
-- 
SHENBING_ADD_INFO = {
		ApRate = tr("攻击"),
		DpRate = tr("防御"),
		HpRate = tr("生命"),
		Speed = tr("速度"),
		Double = tr("暴击"),
		ReDouble = tr("抗暴"),
		HitRate = tr("命中"),
		Dodge = tr("闪避"),
		ReDpRate = tr("破防"),
		Fist = tr("拳脚武学精通"),
		Sword = tr("刀剑武学精通"),
		Qiangbang = tr("枪棒武学精通"),
		ReFist = tr("拳脚武学免伤"),
		ReSword = tr("刀剑武学免伤"),
		ReQiangbang = tr("枪棒武学免伤"),
		PvpApRate = tr("pvp强度"),
		PvpDpRate = tr("pvp韧性"),
	}

---
-- 神兵附加属性变量表
-- @field [parent=#view.const.ItemViewConst] #table SHENBING_ADD_KEY
-- 
SHENBING_ADD_KEY = {"ApRate", "DpRate", "HpRate", "Speed", "Double", "ReDouble", "HitRate", "Dodge", "ReDpRate", "Fist", "Sword", "Qiangbang", "ReFist", "ReSword", "ReQiangbang", "PvpApRate", "PvpDpRate",}

---
-- 淬炼属性
-- @field [parent=#view.const.ItemViewConst] #table EQUIP_CUILIAN_INFO
-- 
EQUIP_CUILIAN_INFO = {
		Ap = tr("攻击"),
	 	Dp = tr("防御"), 
	 	Hp = tr("生命"), 
	 	Speed = tr("速度"), 
	 	Double = tr("暴击"), 
	 	ReDouble = tr("抗暴"), 
	 	HitRate = tr("命中"), 
	 	Dodge = tr("闪避"),
	 }

---
-- BUFF颜色表
-- @field [parent=#view.const.ItemViewConst] #table BUFF_COLOR_TABLE
-- 
BUFF_COLOR_TABLE = {
	[3] = "<c0>",
	[5] = "<c1>",
	[10] = "<c2>",
	[15] = "<c3>",
	[20] = "<c4>",
}