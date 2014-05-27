---
-- vip升级界面
-- @module view.levelup.VipLevelUpMsgBoxView
--

local require = require
local class = class

local moduleName = "view.levelup.VipLevelUpMsgBoxView"
module(moduleName)

---
-- 类定义
-- @type VipLevelUpMsgBoxView
--
local VipLevelUpMsgBoxView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #VipLevelUpMsgBoxView] ctor
--
function VipLevelUpMsgBoxView:ctor()
	VipLevelUpMsgBoxView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #VipLevelUpMsgBoxView] _create
--
function VipLevelUpMsgBoxView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_levelup/ui_viptexiao.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	--self:handleButtonEvent("closeBtn2", self._closeBtnHandler)
	self:handleButtonEvent("teQuanBtn", self._vipTeQuanBtnHandler)
end

---
-- 场景进入自动回调
-- @function [parent = #VipLevelUpMsgBoxView] onExit
--  
function VipLevelUpMsgBoxView:onExit()
	instance = nil
	
	VipLevelUpMsgBoxView.super.onExit(self)
end

---
-- 显示多少级VIP
-- @function [parent = #VipLevelUpMsgBoxView] setVipLevel
-- @param #nunmber vipLevel
--  
function VipLevelUpMsgBoxView:setVipLevel(vipLevel)
	self._vipLevel = vipLevel
	--self["congraLab"]:setString("恭喜您成为尊贵的"..vipLevel.."级VIP会员")
	self:changeFrame("vipLevelSpr", "ccb/numeric/"..vipLevel.."_1.png")
end

---
-- 点击了关闭按钮
-- @function [parent = #VipLevelUpMsgBoxView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function VipLevelUpMsgBoxView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了特权按钮
-- @function [parent = #VipLevelUpMsgBoxView] _vipTeQuanBtnHandler
-- @param #CCControlButton sender
-- @param #table event
--
function VipLevelUpMsgBoxView:_vipTeQuanBtnHandler(sender, event)
	-- 弹出VIP特权界面
	local shopMainView =  require("view.shop.ShopMainView").createInstance()
	shopMainView:openUi(4)
	shopMainView:setVipView()
	
	local gameView = require("view.GameView")
	gameView.removePopUp(self, true)
end










