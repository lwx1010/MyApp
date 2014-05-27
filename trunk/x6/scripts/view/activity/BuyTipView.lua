--- 
-- 购买提示界面(推送界面)
-- @module view.activity.BuyTipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local string = string
local display = display
local transition = transition

local moduleName = "view.activity.BuyTipView"
module(moduleName)


--- 
-- 类定义
-- @type BuyTipView
-- 
local BuyTipView = class(moduleName, require("ui.CCBView").CCBView)


----- 创建实例
---- @return PlayerCell实例
--function new()
--	return BuyTipView.new()
--end

--- 
-- 构造函数
-- @function [parent=#BuyTipView] ctor
-- @param self
-- 
function BuyTipView:ctor()
	BuyTipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BuyTipView] _create
-- @param self
-- 
function BuyTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_tuisong.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("buyBtn", self._buyClkHandler)
	self["itemCcb.frameSpr"]:setVisible(false)
	self["itemCcb.lvBgSpr"]:setVisible(false)
	self["itemCcb.lvLab"]:setVisible(false)
end

---
-- 点击了关闭
-- @function [parent=#BuyTipView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BuyTipView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

--- 
-- 点击了购买
-- @function [parent=#BuyTipView] _buyClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BuyTipView:_buyClkHandler( sender, event )
	if not self._info then return end
	
	if self._info.ActType == 1 then
		local shopMainView = require("view.shop.ShopMainView").createInstance()
		shopMainView:openUi(4) --充值页面
	else
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_partybase_1014_buy",{gift_id=self._info.Id})
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#BuyTipView] openUi
-- @param self
-- @param #table info 
-- 
function BuyTipView:openUi( info )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self:_showMsg(info)
end

---
-- 显示界面信息
-- @function [parent=#BuyTipView] _showMsg
-- @param self
-- @param #table info 
-- 
function BuyTipView:_showMsg(info)
	self._info = info
	if info.ActType == 1 then
		self:changeFrame("buySpr", "ccb/buttontitle/charge.png")
	else
		self:changeFrame("buySpr", "ccb/buttontitle/buy.png")
	end
	
	if info.PushPicType == 1 then
		self:changeTexture("cardSpr", "card/"..info.PushPicId..".jpg")
		self["cardSpr"]:setVisible(true)
		self["itemCcb"]:setVisible(false)
		self["itemLab"]:setVisible(false)
		
		-- 特效Spr
		local texiaospr = display.newSprite()
		display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
		self:addChild(texiaospr)
		texiaospr:setScale(1.8)
		texiaospr:setPosition(130,185)
		local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
		local animation = display.newAnimation(frames, 1/12)
		transition.playAnimationForever(texiaospr, animation)
	else
		self:changeItemIcon("itemCcb.headPnrSpr", info.PushPicId)
		self["cardSpr"]:setVisible(false)
		self["itemCcb"]:setVisible(true)
		self["itemLab"]:setVisible(true)
		self["itemLab"]:setString(info.Reward)
	end
	
	local des = string.gsub(info.PushInfo, "\\n", "\n")
	self["desLab"]:setString(tr(des))
end

---
-- 设置显示信息
-- @function [parent=#BuyTipView] setShowMsg
-- @param self
-- @param #table info 
-- 
function BuyTipView:setShowMsg(info)
	self:_showMsg(info)
end

---
-- 退出界面调用
-- @function [parent=#BuyTipView] onExit
-- @param self
-- 
function BuyTipView:onExit()
	instance = nil
	
	self.super.onExit(self)
end

