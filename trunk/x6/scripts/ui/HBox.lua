---
-- 水平盒子容器
-- @module ui.HBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs


local moduleName = "ui.HBox"
module(moduleName)


--- 
-- 类定义
-- @type HBox
-- 

---
-- HBox
-- @field [parent=#ui.HBox] #HBox HBox
-- 
HBox = class(moduleName, require("ui.Box").Box)

--- 
-- 创建实例
-- @function [parent=#ui.HBox] new
-- @return #HBox
-- 
function new()
	return HBox.new()
end

--- 
-- 构造函数
-- @function [parent=#HBox] ctor
-- @param self
-- 
function HBox:ctor()
	HBox.super.ctor(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.HORIZONTAL
	
	self._hCount = nil
	self._vCount = 1
end