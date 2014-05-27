---
-- 垂直盒子容器
-- @module ui.VBox
-- 

local class = class
local printf = printf
local require = require
local ipairs = ipairs


local moduleName = "ui.VBox"
module(moduleName)


--- 
-- 类定义
-- @type VBox
-- 

---
-- VBox
-- @field [parent=#ui.VBox] #VBox VBox
-- 
VBox = class(moduleName, require("ui.Box").Box)

--- 
-- 创建实例
-- @function [parent=#ui.VBox] new
-- @return #VBox
-- 
function new()
	return VBox.new()
end

--- 
-- 构造函数
-- @function [parent=#VBox] ctor
-- @param self
-- 
function VBox:ctor()
	VBox.super.ctor(self)
	
	local Directions = require("ui.const.Directions")
	self._scrollDir = Directions.VERTICAL
	
	self._hCount = 1
	self._vCount = nil
end
	