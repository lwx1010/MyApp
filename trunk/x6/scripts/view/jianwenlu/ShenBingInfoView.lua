---
-- 神兵详细信息界面
-- @module view.jianwenlu.ShenBingInfoView
-- 

local class = class
local require = require
local tr = tr
local table = table
local string = string
local printf = printf
local dump = dump

local moduleName = "view.jianwenlu.ShenBingInfoView"
module(moduleName)

---
-- 类定义
-- @type ShenBingInfoView
-- 
local ShenBingInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#ShenBingInfoView] ctor
-- @param self
-- 
function ShenBingInfoView:ctor()
	ShenBingInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ShenBingInfoView] _create
-- @param self
-- 
function ShenBingInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jwlequipinfo.ccbi", true)

	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("shareBtn", self._shareClkHandler)
end

---
-- 点击了关闭
-- @function [parent=#ShenBingInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShenBingInfoView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了分享
-- @function [parent=#ShenBingInfoView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ShenBingInfoView:_shareClkHandler(sender,event)
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 显示神兵图标
-- @function [parent=#ShenBingInfoView] showIcon
-- @param self
-- @param #table item
-- 
function ShenBingInfoView:showIcon(item)
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame("equipCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.rare])
	self["nameLab"]:setString(ItemViewConst.EQUIP_STEP_COLORS[item.rare]..item.item_name)
	self["equipCcb.headPnrSpr"]:showReward("item", item.item_photo)
end

---
-- 显示神兵信息
-- @function [parent=#ShenBingInfoView] showInfo
-- @param self
-- @param #table info 
-- 
function ShenBingInfoView:showInfo(info)
	local type
	if( info.type == 1 ) then
		type = tr("武器")
	elseif( info.type == 2 ) then
		type = tr("衣服")
	elseif( info.type == 3 ) then
		type = tr("饰品")
	end
	self["typeLab"]:setString(type)
	
	local prop
	for i=1, #info.prop_info do
		prop = info.prop_info[i]
		local des = self:_getTypeDes(prop.type, prop.value)
		if( des ) then
			self["propLab"]:setString(des)
		end
	end
	
	if( info.is_sb == 1 ) then
		self["kindLab"]:setString("神兵")
	else
		self["kindLab"]:setString("普通")
	end
	if( info.info1 ) then
		self["desLab"]:setString(info.info1)
	else
		self["desLab"]:setString("")
	end
end

---
-- 获取属性描述
-- @function [parent=#ShenBingInfoView] _getTypeDes
-- @param self
-- @param #string type 
-- @param #number value 
-- @return #string
-- 
function ShenBingInfoView:_getTypeDes(type, value)
	if( value == 0 ) then
		return false
	end
	
	local des
	if(type == "Ap") then
		des = tr("攻击+"..value)
	elseif(type == "Dp") then
		des = tr("防御+"..value)
	elseif(type == "Hp") then
		des = tr("生命+"..value)
	elseif(type == "HpRate") then
		des = tr("生命+"..(value/100).."%")
	elseif(type == "DpRate") then
		des = tr("防御+"..(value/100).."%")
	elseif(type == "ApRate") then
		des = tr("攻击+"..(value/100).."%")
	end
	return des
end

---
-- 退出界面调用
-- @function [parent=#ShenBingInfoView] onExit
-- @param self
-- 
function ShenBingInfoView:onExit()
	instance = nil
	ShenBingInfoView.super.onExit(self)
end










































