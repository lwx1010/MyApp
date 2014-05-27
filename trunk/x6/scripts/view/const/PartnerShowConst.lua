---
-- 同伴相关显示常量
-- 
local tr = tr
local ccc3 = ccc3

module("view.const.PartnerShowConst")

---
-- 品阶颜色表
-- @field [parent=#view.const.PartnerShowConst] #table STEP_COLORS
--
STEP_COLORS = {"<c0>", "<c1>", "<c2>", "<c3>", "<c4>"}

--- 
-- 品阶对应颜色中文
-- @field [parent=#view.const.PartnerShowConst] #table STEP_CHINESE
-- 
STEP_CHINESE= {tr("白色"), tr("绿色"), tr("蓝色"), tr("紫色"), tr("橙色")}

---
-- 同伴品阶框
-- @field [parent=#view.const.PartnerShowConst] #table STEP_FRAME
-- 
STEP_FRAME = { 
		"ccb/mark/boxborder_white.png",
		"ccb/mark/boxborder_green.png",
		"ccb/mark/boxborder_blue.png",
		"ccb/mark/boxborder_purple.png",
		"ccb/mark/boxborder_orange.png",
	}

---
-- 侠客品阶图标
-- @field [parent=#view.const.PartnerShowConst] #table STEP_ICON
-- 
STEP_ICON = {
		"ccb/mark/bai.png",
		"ccb/mark/green.png",
		"ccb/mark/blue.png",
		"ccb/mark/zi.png",
		"ccb/mark/cheng.png",
	}
	
---
-- 侠客右下角品阶图标
-- @field [parent=#view.const.PartnerShowConst] #table STEP_ICON1
-- 
STEP_ICON1 = { 
		"ccb/mark3/white.png",
		"ccb/mark3/green.png",
		"ccb/mark3/bule.png",
		"ccb/mark3/purple.png",
		"ccb/mark3/orange.png",
	}

---
-- 同伴等级背景
-- @field [parent=#view.const.PartnerShowConst] #table STEP_LVBG
-- 
STEP_LVBG = { 
		"ccb/mark/grademark_white.png",
		"ccb/mark/grademark_green.png",
		"ccb/mark/grademark_blue.png",
		"ccb/mark/grademark_purple.png",
		"ccb/mark/grademark_orange.png",
	}

---
-- 侠客右下角星级背景
-- @field [parent=#view.const.PartnerShowConst] #table STEP_STARBG
-- 
STEP_STARBG = { 
		"ccb/mark3/level1.png",
		"ccb/mark3/level2.png",
		"ccb/mark3/level3.png",
		"ccb/mark3/level4.png",
		"ccb/mark3/level5.png",
		"ccb/mark3/level6.png",
		"ccb/mark3/level7.png",
	}

---
-- 侠客类型图标
-- @field [parent=#view.const.PartnerShowConst] #table STEP_TYPE
-- 
STEP_TYPE = { 
		"ccb/mark3/jg.png",
		"ccb/mark3/fy.png",
		"ccb/mark3/jh.png",
	}
	

---
-- 同伴品阶描边色
-- @field [parent=#view.const.PartnerShowConst] #table MARTIAL_OUTLINE_COLORS
-- 
PARTNER_OUTLINE_COLORS = {
		ccc3(245, 244, 216),
		ccc3(40, 245, 0),
		ccc3(0, 191, 255),
		ccc3(239, 0, 254),
		ccc3(255, 143, 0),
	}
	
	