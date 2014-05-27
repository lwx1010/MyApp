---
-- 布阵界面显示常量
-- @module view.const.FormationShowConst
-- 

local require = require
local ccc3 = ccc3
local tr = tr


module("view.const.FormationShowConst")

---
-- 人物精灵站位表
-- @field [parent=#view.const.FormationShowConst] #table sprPosTbl 
-- 
sprPosTbl = {
	[1] = {["x"] = 610, ["y"] = 420},
	[2] = {["x"] = 555, ["y"] = 294},
	[3] = {["x"] = 504, ["y"] = 159},
	[4] = {["x"] = 414, ["y"] = 420},
	[5] = {["x"] = 359, ["y"] = 294},
	[6] = {["x"] = 302, ["y"] = 159},
	[7] = {["x"] = 217, ["y"] = 420},
	[8] = {["x"] = 163, ["y"] = 294},
	[9] = {["x"] = 108, ["y"] = 159},
}

---
-- 位置矩形区域表
-- @field [parent=#view.const.FormationShowConst] #table rectPosTbl 
-- 
rectPosTbl = {
	[1] = {["x"] = 520, ["y"] = 310, ["width"] = 180, ["height"] = 110},
	[2] = {["x"] = 465, ["y"] = 184, ["width"] = 180, ["height"] = 110},
	[3] = {["x"] = 414, ["y"] = 49, ["width"] = 180, ["height"] = 110},
	[4] = {["x"] = 324, ["y"] = 310, ["width"] = 180, ["height"] = 110},
	[5] = {["x"] = 269, ["y"] = 184, ["width"] = 180, ["height"] = 110},
	[6] = {["x"] = 212, ["y"] = 49, ["width"] = 180, ["height"] = 110},
	[7] = {["x"] = 127, ["y"] = 310, ["width"] = 180, ["height"] = 110},
	[8] = {["x"] = 73, ["y"] = 184, ["width"] = 180, ["height"] = 110},
	[9] = {["x"] = 18, ["y"] = 49, ["width"] = 180, ["height"] = 110},
}

---
-- 位置是否可以放置人物精灵表
-- @field [parent=#view.const.FormationShowConst] #table canPutTbl 
-- 
canPutTbl = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true,
	[8] = true,
	[9] = true,
}

---
-- 表示该位置可放置人物精灵的绿色底纹的位置坐标表
-- @field [parent=#view.const.FormationShowConst] #table putPosTbl 
-- 
putPosTbl = {
	[1] = {["x"] = 607, ["y"] = 321},
	[2] = {["x"] = 552, ["y"] = 195},
	[3] = {["x"] = 501, ["y"] = 60},
	[4] = {["x"] = 411, ["y"] = 321},
	[5] = {["x"] = 356, ["y"] = 195},
	[6] = {["x"] = 299, ["y"] = 60},
	[7] = {["x"] = 214, ["y"] = 321},
	[8] = {["x"] = 160, ["y"] = 195},
	[9] = {["x"] = 105, ["y"] = 60},
}

---
-- 人物名字对应颜色表
-- @field [parent=#view.const.FormationShowConst] #table colorTbl 
-- 
colorTbl = {
	[1] = {["R"] = 245, ["G"] = 244, ["B"] = 216},
	[2] = {["R"] = 40, ["G"] = 245, ["B"] = 0},
	[3] = {["R"] = 0, ["G"] = 191, ["B"] = 255},
	[4] = {["R"] = 239, ["G"] = 0, ["B"] = 254},
	[5] = {["R"] = 255, ["G"] = 143, ["B"] = 0},
}

---
-- 前中后对应位置表
-- @field [parent=#view.const.FormationShowConst] #table posTbl 
-- 
posTbl = {
	[1] = tr("前"),
	[2] = tr("前"),
	[3] = tr("前"),
	[4] = tr("中"),
	[5] = tr("中"),
	[6] = tr("中"),
	[7] = tr("后"),
	[8] = tr("后"),
	[9] = tr("后"),
}



