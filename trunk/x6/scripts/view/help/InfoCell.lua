--- 
-- 帮助信息条目
-- @module view.help.InfoCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local CCSize = CCSize
local pairs = pairs
local ccp = ccp

local moduleName = "view.help.InfoCell"
module(moduleName)

--- 
-- name的上位移
-- @type number 
-- 
CellTopOffSet1 = 15

--- 
-- desc的下位移
-- @type number 
-- 
CellTopOffSet2 = 20

---
-- 左位移
-- @type number
-- 
CellLeftOffSet = 20

--- 
-- 类定义
-- @type InfoCell
-- 
local InfoCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 帮助信息
-- @field [parent=#InfoCell] #table _helpItem
-- 
InfoCell._helpItem = nil


--- 创建实例
-- @return InfoCell实例
function new()
	return InfoCell.new()
end

--- 
-- 构造函数
-- @function [parent=#InfoCell] ctor
-- @param self
-- 
function InfoCell:ctor()
	InfoCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#InfoCell] _create
-- @param self
-- 
function InfoCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_help_content.ccbi", true)
	
	self:setAnchorPoint(ccp(0,0))
	self["nameLab"]:setAnchorPoint(ccp(0,0))
	self["descLab"]:setAnchorPoint(ccp(0,0))
end

--- 
-- 显示数据
-- @function [parent=#InfoCell] showItem
-- @param self
-- @param #table info
-- 
function InfoCell:showItem( info )
	self._helpItem = info
	
	
	if( not info ) then
		return
	end
	
	self["nameLab"]:setString( info.Name )
	self["descLab"]:setString( info.Desc )
	
	local width = 700
	local height = 46 + self["descLab"]:getContentSize().height + self["nameLab"]:getContentSize().height
	
	self:setContentSize(CCSize(width, height))
	self["nameLab"]:setPosition(CellLeftOffSet, height - CellTopOffSet1 - self["nameLab"]:getContentSize().height)
	self["descLab"]:setPosition(CellLeftOffSet, CellTopOffSet2)
	
	self["bgS9Spr"]:setPreferredSize(CCSize(width, height))
end

---
-- ui点击处理
-- @function [parent=#InfoCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function InfoCell:uiClkHandler( ui, rect )
	
end

---
-- 获取帮助信息
-- @function [parent=#InfoCell] getItem
-- @param self
-- @return #table
-- 
function InfoCell:getItem()
	return self._helpItem
end
