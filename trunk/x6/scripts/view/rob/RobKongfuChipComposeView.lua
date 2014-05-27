--- 
-- 秘籍碎片合成
-- @module view.rob.RobKongfuChipComposeView
--


local require = require
local class = class 
local printf = printf
local display = display
local CCFileUtils = CCFileUtils
local CCDictionary = CCDictionary
local tolua = tolua
local tr = tr

local moduleName = "view.rob.RobKongfuChipComposeView" 
module(moduleName)

---
-- 类定义
-- @type RobKongfuChipComposeView
-- 
local RobKongfuChipComposeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 按钮特效帧数
-- @function [parent = #view.rob.RobKongfuChipComposeView] _buttonEffectFrameNum
-- 
local _buttonEffectFrameNum

---
-- 构造函数
-- @field [parent = #RobKongfuChipComposeView] ctor
-- 
function RobKongfuChipComposeView:ctor()
	RobKongfuChipComposeView.super.ctor(self)
	self:_create()
end

---
-- 加载ccb，创建场景初始化
-- @function [parent = #RobKongfuChipComposeView] _create
-- 
function RobKongfuChipComposeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_kongfuchipcompose.ccbi", true)   
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("heChengCcb.aBtn", self._heChengBtnHandler)
	for i = 1, 6 do
		self["itemCcb"..i]:setVisible(false)
		self["itemCcb"..i..".martialCcb.".."lvBgSpr"]:setVisible(false)
		self["itemCcb"..i..".martialCcb.".."lvLab"]:setVisible(false)
	end
	self["heChengItemCcb"..".martialCcb.".."lvBgSpr"]:setVisible(false)
	self["heChengItemCcb"..".martialCcb.".."lvLab"]:setVisible(false)
	self["heChengItemCcb.numBgSpr"]:setVisible(false)
	self["heChengItemCcb.typeSpr"]:setVisible(false)
	
	--添加按钮特效
	display.addSpriteFramesWithFile("ui/effect/buttoneffect2.plist", "ui/effect/buttoneffect2.png")
	_buttonEffectFrameNum = require("utils.SpriteAction").getPlistFrame("ui/effect/buttoneffect2.plist")
	
	local spriteAction = require("utils.SpriteAction")
	self.effect = display.newSprite() 
	spriteAction.spriteRunForeverAction(self.effect, "buttoneffect2/100%02d.png", 0, _buttonEffectFrameNum, 1/_buttonEffectFrameNum)
	local button = self["heChengCcb.aBtn"]
	button:addChild(self.effect)
	self.effect:setPosition(button:getContentSize().width/2, button:getContentSize().height/2)
end
	

---
-- 点击了关闭按钮
-- @function [parent = #RobKongfuChipComposeView] _closeBtnHandler
-- 
function RobKongfuChipComposeView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end


---
-- 设置合成武学的图片及信息
-- @function [parent = #RobKongfuChipComposeView] setComposeMartial
-- @param #number martialId
-- 
function RobKongfuChipComposeView:setComposeMartial(martialId)
	self.composeMartialId = martialId
	local martial = require("xls.MartialXls").data
	printf(martialId)
	local martialIconId = martial[martialId].IconNo
	local martialName = martial[martialId].Name
	local martialRare = martial[martialId].Rare
	
	local frameSpr, nameColor = require("view.rob.RobCell").getItemRare(martialRare)
	
	self:changeFrame("heChengItemCcb.martialCcb.frameSpr", frameSpr) 
	
	--local martialSpr = self["heChengItemCcb.martialCcb.headPnrSpr"]
	local ImageUtil = require("utils.ImageUtil")
	--martialSpr:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	self:changeItemIcon("heChengItemCcb.martialCcb.headPnrSpr", martialIconId)
	self["heChengItemCcb.nameLab"]:setString(nameColor..martialName)
	self["heChengItemCcb.numLab"]:setVisible(false)
end


---
-- 设置武学碎片的信息
-- @function [RobKongfuChipComposeView] setComposeMartial
-- @param #number martialId
-- @param #number num  第几个武学碎片
-- @param #number hasNum 
-- @param #number maxNum
-- 
function RobKongfuChipComposeView:setChipMartial(martialId, num, hasNum, maxNum)
	local martial = require("xls.MartialChipXls").data
	local martialIconId = martial[martialId].IconNo
	local martialName = martial[martialId].Name 
	local martialRare = martial[martialId].Rare
	
	local frameSpr, nameColor = require("view.rob.RobCell").getItemRare(martialRare)
	
	self:changeFrame("itemCcb"..num..".martialCcb.frameSpr", frameSpr) 
	
	self["itemCcb"..num]:setVisible(true)
	--local martialSpr = self["itemCcb"..num..".martialCcb.headPnrSpr"]
	local ImageUtil = require("utils.ImageUtil")
	--martialSpr:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	self:changeItemIcon("itemCcb"..num..".martialCcb.headPnrSpr", martialIconId)
	--self["itemCcb"..num..".nameLab"]:setString(nameColor..martialName) 改为数字
	self["itemCcb"..num..".nameLab"]:setString(nameColor..tr("碎片")..num)
	self["itemCcb"..num..".numLab"]:setString(hasNum.."/"..maxNum)
end
	

---
-- 点击了合成按钮
-- @function [parent = #RobKongfuChipComposeView] _heChengBtnHandler
-- @param #CCControlButton sender
-- @param #EVENT event
-- 
function RobKongfuChipComposeView:_heChengBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_duobao_merge_martial", {martial_id = self.composeMartialId})
end



---
-- 点击了夺宝按钮
-- @function [parent = #RobKongfuChipComposeView] _duoBaoBtnHandler
-- @param #CCControlButton sender
-- @param #EVENT event
-- 
function RobKongfuChipComposeView:_duoBaoBtnHandler(sender, event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_duobao_user_info", {martial_id = self.composeMartialId})
	local GameView = require("view.GameView")
	local robChip = require("view.rob.RobChipView").createInstance()
	GameView.removePopUp(self, true)
	--GameView.replaceMainView(robChip, true)
	GameView.addPopUp(robChip, true)
	GameView.center(robChip)
end
		
		
---
-- 获取碎片ID
-- @function [parent = #RobKongfuChipComposeView] getMartialId
-- @return #number self.composeMartialId
-- 
function RobKongfuChipComposeView:getMartialId()
	return self.composeMartialId
end


---
-- 场景退出后回调
-- @function [parent = RobKongfuChipComposeView] onExit
-- 
function RobKongfuChipComposeView:onExit()
	local t = 1
	for i = 1, 6 do
		t = t + 1
		self["itemCcb"..i]:setVisible(false)
	end
	
	require("view.rob.RobKongfuChipComposeView").instance = nil
	RobKongfuChipComposeView.super.onExit(self)	
end



