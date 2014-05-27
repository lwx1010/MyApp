---
-- 真气相关显示常量
-- @module view.const.ZhenQiShowConst
-- 

local tr = tr
local ccc3 = ccc3

module("view.const.ZhenQiShowConst")

---
-- 品阶颜色表
-- @field [parent=#view.const.ZhenQiShowConst] #table STEP_COLORS 
-- 
STEP_COLORS = {"<c1>", "<c2>", "<c3>", "<c4>"}

---
-- 真气品阶框
-- @field [parent=#view.const.ZhenQiShowConst] #table STEP_FRAME
-- 
STEP_FRAME = { 
		"ccb/mark/boxborder_green.png",
		"ccb/mark/boxborder_blue.png",
		"ccb/mark/boxborder_purple.png",
		"ccb/mark/boxborder_orange.png",
	}

---
-- 真气品阶图标
-- @field [parent=#view.const.ZhenQiShowConst] #table STEP_ICON
-- 
STEP_ICON = {
		"ccb/mark/green.png",
		"ccb/mark/blue.png",
		"ccb/mark/zi.png",
		"ccb/mark/cheng.png",
	}
	
---
-- 真气等级背景
-- @field [parent=#view.const.ZhenQiShowConst] #table STEP_LVBG
-- 
STEP_LVBG = { 
		"ccb/mark/grademark_green.png",
		"ccb/mark/grademark_blue.png",
		"ccb/mark/grademark_purple.png",
		"ccb/mark/grademark_orange.png",
	}
	
---
-- 真气类型表
-- @field [parent=#view.const.ZhenQiShowConst] #table ZHENQI_TYPE 
-- 
ZHENQI_TYPE = {
	["Ap"] = tr("攻击"),
	["Dp"] = tr("防御"),
	["Hp"] = tr("生命"),
	["Speed"] = tr("速度"),
	["Double"] = tr("暴击几率"),
	["ReDizzy"] = tr("眩晕抗性"),
	["ReDouble"] = tr("暴击抗性"),	
	["HitRate"] = tr("命中"),
	["Dodge"] = tr("躲避"),
	["ReHurt"] = tr("物理免伤"),
	["Fist"] = tr("拳脚武学精通"),	
	["Sword"] = tr("刀剑武学精通"),
	["Qiangbang"] = tr("枪棒武学精通"),
	["ReFist"] = tr("拳脚武学免伤"),
	["ReSword"] = tr("刀剑武学免伤"),
	["ReQiangbang"] = tr("枪棒武学免伤"),
	}
	
---
-- 真气特效帧数
-- @field [parent=#view.const.ZhenQiShowConst] #table ZHENQI_FRAMENUM 
-- 
ZHENQI_FRAMENUM = {
	[8001001] = 8,
	[8002001] = 11,
	[8003001] = 10,
	[8004001] = 6,
	[8005001] = 10,
	[8006001] = 10,
	[8007001] = 12,
	[8008001] = 11,
	[8009001] = 11,
	[8010001] = 10,
	[8011001] = 9,
	[8012001] = 10,
	[8013001] = 10,
	[8014001] = 7,
	[8015001] = 10,
	[8016001] = 10,
}

---
-- 同伴品阶描边色
-- @field [parent=#view.const.ZhenQiShowConst] #table ZHENQI_OUTLINE_COLORS
-- 
ZHENQI_OUTLINE_COLORS = {
		ccc3(40, 245, 0),
		ccc3(0, 191, 255),
		ccc3(239, 0, 254),
		ccc3(255, 143, 0),
	}
	
