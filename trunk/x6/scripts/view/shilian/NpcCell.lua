--- 
-- npc形象子项
-- @module view.shilian.NpcCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr
local ccp = ccp
local display = display
local ui = ui

local moduleName = "view.shilian.NpcCell"
module(moduleName)


--- 
-- 类定义
-- @type NpcCell
-- 
local NpcCell = class(moduleName, require("ui.CCBView").CCBView)


---
-- 创建实例
-- @return NpcCell实例
function new()
	return NpcCell.new()
end

--- 
-- 构造函数
-- @function [parent=#NpcCell] ctor
-- @param self
-- 
function NpcCell:ctor()
	NpcCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#NpcCell] _create
-- @param self
-- 
function NpcCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhizunshilianpiece.ccbi", true)
	
end

--- 
-- 显示半身像
-- @function [parent=#NpcCell] showIcon
-- @param self
-- @param #number photo
-- @param #boolean isOpen
-- 
function NpcCell:showIcon(photo, isOpen)
	if( not photo ) then
		self:changeItemIcon("headPnrSpr", nil)
		return
	end
	
	self["headPnrSpr"]:showHalf(photo)
	if isOpen then
	 	self:restoreSprite(self["headPnrSpr"])
	 else
		self:setGraySprite(self["headPnrSpr"])
	end
end

