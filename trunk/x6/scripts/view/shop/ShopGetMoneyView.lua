---
-- 招财界面
-- @module view.shop.ShopGetMoneyView
--

local require = require
local class = class
local display = display

local moduleName = "view.shop.ShopGetMoneyView"
module(moduleName)

---
-- 类定义
-- @type ShopGetMoneyView
--
local ShopGetMoneyView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 场景进入后自动调用
-- @function [parent = #ShopGetMoneyView] onEnter
-- 
function ShopGetMoneyView:onEnter()
	ShopGetMoneyView.super.onEnter(self)
	
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_treasure_info", {place_holder = 1})
end

---
-- 构造函数
-- @function [parent = #ShopGetMoneyView] ctor
--
function ShopGetMoneyView:ctor()
	ShopGetMoneyView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopGetMoneyView] _create
--
function ShopGetMoneyView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_getmoney.ccbi")
	
	--添加聚宝盆特效
	display.addSpriteFramesWithFile("ui/effect/jubaopeng.plist", "ui/effect/jubaopeng.png")
	self._getMoneyEffectFrameNum = require("utils.SpriteAction").getPlistFrame("ui/effect/jubaopeng.plist")
	
	local spriteAction = require("utils.SpriteAction")
	self.effect = display.newSprite() 
	spriteAction.spriteRunForeverAction(self.effect, "jubaopeng/100%02d.png", 0, self._getMoneyEffectFrameNum, 1/7)
	--self["jubaoSpr"]:setVisible(false)
	--self["jubaoSpr"]:setCascadeOpacityEnabled(false)
	--self["jubaoSpr"]:setOpacity(100)
	local jubao = self["jubaoSpr"]
	jubao:addChild(self.effect)
	self.effect:setPosition(jubao:getContentSize().width/2, jubao:getContentSize().height/2 + 14)
	
	self:handleButtonEvent("zhaoCaiBtn", self._zhaoCaiBtnHandler)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	local heroAttr = require("model.HeroAttr")
	local NumberUtil = require("utils.NumberUtil")
	self["goldCountLab"]:setString(heroAttr.YuanBao)
	self["silverCountLab"]:setString(NumberUtil.numberForShort(heroAttr.Cash))
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:addEventListener(event.name, self._attrsGoldUpdatedHandler, self)
end 

---
-- 设置显示信息
-- @function [parent = #ShopGetMoneyView] setShowMsg
-- 
function ShopGetMoneyView:setShowMsg(msg)
	self["freeTimeLab"]:setString(msg.rest_fcount)
	self["leftZhaoCaiLab"]:setString(msg.rest_count)
	self["desLab"]:setString("使用"..msg.need_yuanbao.."元宝招财， 获得"..msg.get_cash.."银两")
end

---
-- 点击了关闭按钮
-- @function [parent = #ShopGetMoneyView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopGetMoneyView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 点击了招财按钮
-- @function [parent = #ShopGetMoneyView] _zhaoCaiBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopGetMoneyView:_zhaoCaiBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_treasure_get_cash", {place_holder = 1})
end

---
-- 数据更新回调
-- @function [parent = #ShopGetMoneyView] _attrsGoldUpdatedHandler
-- @param #table event
-- 
function ShopGetMoneyView:_attrsGoldUpdatedHandler(event)
	if event.attrs.YuanBao ~= nil then
		self["goldCountLab"]:setString(event.attrs.YuanBao)
	end
	
	if event.attrs.Cash ~= nil then
		local NumberUtil = require("utils.NumberUtil")
		self["silverCountLab"]:setString(NumberUtil.numberForShort(event.attrs.Cash))
	end
end

---
-- 场景退出自动回调
-- @function [parent = #ShopGetMoneyView] onExit
-- 
function ShopGetMoneyView:onExit()
	require("view.shop.ShopGetMoneyView").instance = nil
	ShopGetMoneyView.super.onExit(self)
end





