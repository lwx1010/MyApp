--- 
-- 提示框
-- @module view.role.TipView
-- 

local class = class
local require = require
local tr = tr
local printf = printf

local moduleName = "view.role.TipView"
module(moduleName)

--- 
-- 类定义
-- @type TipView
-- 
local TipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- tip info
-- @field [parent=#TipView] #table _info
-- 
TipView._info = nil

--- 
-- 构造函数
-- @function [parent=#TipView] ctor
-- @param self
-- 
function TipView:ctor()
	TipView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

---
-- 创建实例
-- @function [parent=#view.role.TipView] new
-- @return #TipView 实例
-- 
function new()
	return TipView.new()
end

--- 
-- 创建
-- @function [parent=#TipView] _create
-- @param self
-- 
function TipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_canwupiuece.ccbi", true)
end

---
-- 设置提示框位置及内容
-- @function [parent=#TipView] setTipPositionAndContent
-- @param self
-- @param #number x 坐标
-- @param #number y 坐标
-- @param #table info
-- 
function TipView:setTipPositionAndContent(x, y, info)
	self:setPosition(x, y)
	
	if not info then return end
	
	self._info = info
	local v = info
	
	local attr
	if v.prop_name == "Hp" then
		attr = "生命"
	elseif v.prop_name == "Ap" then
		attr = "攻击"
	elseif v.prop_name == "Speed" then
		attr = "速度"
	elseif v.prop_name == "Dp" then
		attr = "防御"
	elseif v.prop_name == "Double" then
		attr = "暴击"
	elseif v.prop_name == "HitRate" then
		attr = "命中"
	elseif v.prop_name == "Dodge" then
		attr = "闪避"
	elseif v.prop_name == "ReDouble" then
		attr = "抗暴"
	end
	local ItemViewConst = require("view.const.ItemViewConst")
	local cor
--	if info.prop_name == "Hp" or info.prop_name == "Ap" or info.prop_name == "Dp" or info.prop_name == "Speed" then
--		cor = ItemViewConst.BUFF_COLOR_TABLE[info.rate / 100 - 15]
--	else
--		cor = ItemViewConst.BUFF_COLOR_TABLE[info.rate / 100 - 10]
--	end
	cor = "<c1>"
	self["attrDesLab"]:setString(tr(attr) .. cor .. " +" .. info.rate / 100 .. "%" .. "</c>")
	self["countLab"]:setString(tr("剩余战斗次数: ") .. cor .. info.count)
	local NumberUtil = require("utils.NumberUtil")
	self["timeDesLab"]:setString(tr("剩余激活时间: ") .. NumberUtil.secondToDate(info.rest_time))
end

---
-- 刷新倒计时
-- @function [parent=#TipView] flashTime
-- @param self
-- 
function TipView:flashTime()
	local NumberUtil = require("utils.NumberUtil")
	self["timeDesLab"]:setString(tr("剩余激活时间: ") .. NumberUtil.secondToDate(self._info.rest_time))	
end