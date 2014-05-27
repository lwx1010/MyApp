---
-- 武功详细信息界面
-- @module view.jianwenlu.MartialInfoView
-- 

local class = class
local require = require
local tr = tr
local table = table
local string = string
local printf = printf
local dump = dump

local moduleName = "view.jianwenlu.MartialInfoView"
module(moduleName)

---
-- 类定义
-- @type MartialInfoView
-- 
local MartialInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#MartialInfoView] ctor
-- @param self
-- 
function MartialInfoView:ctor()
	MartialInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#MartialInfoView] _create
-- @param self
-- 
function MartialInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jwlskillinfo.ccbi", true)

	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("shareBtn", self._shareClkHandler)
end

---
-- 点击了关闭
-- @function [parent=#MartialInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function MartialInfoView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了分享
-- @function [parent=#MartialInfoView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialInfoView:_shareClkHandler(sender,event)
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 显示武功图标
-- @function [parent=#MartialInfoView] showIcon
-- @param self
-- @param #table item
-- 
function MartialInfoView:showIcon(item)
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame("skillCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.rare])
	self["nameLab"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[item.rare]..item.item_name)
	self["skillCcb.headPnrSpr"]:showReward("item", item.item_photo)
end

---
-- 显示武功信息
-- @function [parent=#MartialInfoView] showInfo
-- @param self
-- @param #table info 
-- 
function MartialInfoView:showInfo(info)
	local ItemViewConst = require("view.const.ItemViewConst")
	self["typeLab"]:setString(ItemViewConst.MARTIAL_TYPE[info.type])
	self["apLab"]:setString("+"..info.ap)
	if( info.info1 ) then
		self["desLab"]:setString(info.info1)
	else
		self["desLab"]:setString("")
	end
end

---
-- 退出界面调用
-- @function [parent=#MartialInfoView] onExit
-- @param self
-- 
function MartialInfoView:onExit()
	instance = nil
	MartialInfoView.super.onExit(self)
end





















