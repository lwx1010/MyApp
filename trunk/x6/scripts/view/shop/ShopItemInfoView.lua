---
-- 物品信息界面
-- @module view.shop.ShopItemInfoView
--

local require = require
local class = class
local CCSize = CCSize
local display = display

local moduleName = "view.shop.ShopItemInfoView"
module(moduleName)

---
-- 类定义
-- @type ShopItemInfoView
--
local ShopItemInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 按钮特效帧数
-- @field [parent = #view.shop.shopItemInfo] _buttonEffectFrameNum
-- 
local _buttonEffectFrameNum

---
-- 构造函数
-- @function [parent = #ShopItemInfoView] ctor
--
function ShopItemInfoView:ctor()
	ShopItemInfoView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopItemInfoView] _create
--
function ShopItemInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_iteminfo.ccbi", true)
	
	self["desLab"]:setDimensions(CCSize(330, 130))
	self["iconCcb.lvLab"]:setVisible(false)
	self["iconCcb.lvBgSpr"]:setVisible(false)
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	--添加按钮特效
--	display.addSpriteFramesWithFile("ui/effect/buttoneffect2.plist", "ui/effect/buttoneffect2.png")
--	_buttonEffectFrameNum = require("utils.SpriteAction").getPlistFrame("ui/effect/buttoneffect2.plist")
--	
--	local spriteAction = require("utils.SpriteAction")
--	self.effect = display.newSprite() 
--	spriteAction.spriteRunForeverAction(self.effect, "buttoneffect2/100%02d.png", 0, _buttonEffectFrameNum, 1/_buttonEffectFrameNum)
--	local button = self["useCcb.aBtn"]
--	button:addChild(self.effect)
--	self.effect:setPosition(button:getContentSize().width/2, button:getContentSize().height/2)
end 

---
-- 设置物品名字
-- @function [parent = #ShopItemInfoView] setItemName
-- @param #string name
-- 
function ShopItemInfoView:setItemName(name)
	self["nameLab"]:setString(name)
end

---
-- 设置显示图片
-- @function [parent = #ShopItemInfoView] setItemImage
-- @param #string imageName
-- 
function ShopItemInfoView:setItemImage(imageName)
	self:changeFrame("iconCcb.headPnrSpr", imageName)
end

---
-- 设置物品描述
-- @function [parent = #ShopItemInfoView] setItemRemark
-- @param #string remark
-- 
function ShopItemInfoView:setItemRemark(remark)
	self["desLab"]:setString(remark)
end

---
-- 设置物品品阶
-- @function [parent = #ShopItemInfoView] setItemLevel
-- @param #number level
-- 
function ShopItemInfoView:setItemLevel(level)
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame("iconCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[level])
end

---
-- 点击了关闭按钮
-- @function [parent = #ShopItemInfoView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ShopItemInfoView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #ShopItemInfoView] onExit
-- 
function ShopItemInfoView:onExit()
	require("view.shop.ShopItemInfoView").instance = nil
	ShopItemInfoView.super.onExit(self)
end









