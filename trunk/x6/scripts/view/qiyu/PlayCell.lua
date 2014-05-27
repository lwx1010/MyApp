--- 
-- 奇遇cell
-- @module view.qiyu.PlayCell
-- 

local class = class
local clone = clone
local printf = printf
local require = require
local tr = tr
local os = os
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCSize = CCSize
local ccp = ccp
local CCScaleTo = CCScaleTo
local CCEaseBounceOut = CCEaseBounceOut
local ccc3 = ccc3

local rawget = rawget

local moduleName = "view.qiyu.PlayCell"
module(moduleName)


--- 
-- 类定义
-- @type PlayCell
-- 
local PlayCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 奇遇信息
-- @field [parent=#PlayCell] #table _playInfo
-- 
PlayCell._playInfo = nil

---
-- 按钮 
-- @field [parent=#PlayCell] #CCControlButton _s9Btn
-- 
PlayCell._s9Btn = nil

---
-- 精灵图片
-- @fielf [parent=#PlayCell] #CCScale9Sprite _backImage
-- 
PlayCell._backImage = nil

--- 创建实例
-- @return PlayCell实例
function new()
	return PlayCell.new()
end

--- 
-- 构造函数
-- @function [parent=#PlayCell] ctor
-- @param self
-- 
function PlayCell:ctor()
	PlayCell.super.ctor(self)

	self:_create()
end

--- 
-- 创建
-- @function [parent=#PlayCell] _create
-- @param self
-- 
function PlayCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_adventure_1.ccbi", true)
	
	self:createClkHelper(true)
	
	self:addBtn()
	self["typeSpr"]:setVisible(false)
end

---
-- 增加一键装备按钮
-- @function [parent=#PartnerEquipUi] addOneKeyBtn
-- @param self
-- 
function PlayCell:addBtn()
	local func = function()
			printf("clk s9Btn")
			if( not self.owner or not self.owner.owner or not self._playInfo ) then return end
			if self._playInfo.isSelected then return end
			
			local view = self.owner.owner  -- view.qiyu.PlayView#PlayView
			view:setSelected( self._playInfo )
		end
	
	
	local ImageUtil = require("utils.ImageUtil")
	
	local frame = ImageUtil.getFrame("ccb/adventure/boss.png")
	
	local s = frame:getOriginalSize()
	local rect = frame:getRect()
	local backImage = CCScale9Sprite:createWithSpriteFrame(frame)
	
	self._backImage = backImage
	self:addClkUi(self._backImage)
	self._backImage:setPosition(95, 75)
	self["btnNode"]:addChild(self._backImage)
--	self._s9Btn = CCControlButton:create()
--	self._s9Btn:setContentSize(CCSize(s.width, s.height))
--	self._s9Btn:setBackgroundSpriteForState(backImage, 1)
--	self._s9Btn:setPreferredSize(rect.size.width, rect.size.height)
--	self._s9Btn:setPreferredSize(s.width, s.height)
--	self._s9Btn:setIsMainBtn(true)
--	self._s9Btn:setAnchorPoint(ccp(0.5,0.5))
--	self._s9Btn:addHandleOfControlEvent(function( ... )
--		if func ~= nil then
--			func()
--		end
--	end, 32)
	
--	self["btnNode"]:addChild(self._s9Btn, 1)
--	self._s9Btn:setPosition(95,75)
end

--- 
-- 显示数据
-- @function [parent=#PlayCell] showItem
-- @param self
-- @param #Randomev_info info
-- 
function PlayCell:showItem( info )
	self._playInfo = info
	
	local scheduler = require("framework.client.scheduler")
	if( not self._playInfo ) then
		self:stopAllActions()
		
		self:changeFrame("typeSpr", nil)
		return
	end
	
	--self._playInfo = clone(info)
	
	local ImageUtil = require("utils.ImageUtil")
	if self._playInfo.isQiYu then
		self["timeSpr"]:setVisible(true)
		local QiYuShowConst = require("view.const.QiYuShowConst")
		self:changeFrame("typeSpr", QiYuShowConst.TYPE_TEXTURE[self._playInfo.type])
--		local backImage = CCScale9Sprite:createWithSpriteFrame(ImageUtil.getFrame(QiYuShowConst.TYPE_TEXTURE[self._playInfo.type]))
--		self._s9Btn:setBackgroundSpriteForState(backImage, 1)
		self._backImage:setSpriteFrame(ImageUtil.getFrame(QiYuShowConst.TYPE_TEXTURE[self._playInfo.type]))
		self:stopAllActions()
		
		local leftTime = self._playInfo.time - os.time()
		if leftTime > 0 then
			local NumberUtil = require("utils.NumberUtil")
			self._endTime = self._playInfo.time
			local func = function()
					leftTime = self._playInfo.time - os.time()
					if leftTime <= 0 then
						self:stopAllActions()
						self["timeLab"]:setString("")
						
						if( not self.owner or not self.owner.owner or not self._playInfo ) then return end
						local view = self.owner.owner
	--					view:updateList()
						view:timeIsOver(self._playInfo)
						return
					end
					
					self["timeLab"]:setString(NumberUtil.secondToDate2(leftTime))
				end
				
			self:schedule(func, 1)
		else
			self["timeLab"]:setString("")
		end
	else
		self:stopAllActions()
		self["timeLab"]:setString("")
		self["timeSpr"]:setVisible(false)
		self:changeFrame("typeSpr", "ccb/adventure/" .. self._playInfo.Icon .. ".png")
--		local backImage = CCScale9Sprite:createWithSpriteFrame(ImageUtil.getFrame("ccb/adventure/" .. info.Icon .. ".png"))
--		self._s9Btn:setBackgroundSpriteForState(backImage, 1)
		self._backImage:setSpriteFrame(ImageUtil.getFrame("ccb/adventure/" .. self._playInfo.Icon .. ".png"))
	end
	
	if self._playInfo.isSelected then
		self["selectSpr"]:setVisible(true)
	else
		self["selectSpr"]:setVisible(false)
	end
	
	local hasOpen = rawget(self._playInfo, "hasOpen")
	if hasOpen then
		self._playInfo.openLevel = nil
	end
	
	local openLevel = rawget(self._playInfo, "openLevel")
	if openLevel then --等级不够，灰化处理
		self:setColor(ccc3(127, 127, 127))
		local ui = require("framework.client.ui")
		local text = ui.newTTFLabelWithShadow(
			{
				text = tr("等级达到"..self._playInfo.openLevel.."开放"),
				size = 18,
				align = ui.TEXT_ALIGN_CENTER,
			}
		)
		self._openLevelTipText = text
		self:addChild(text)
		text:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	else
		if self._openLevelTipText then
			self:setColor(ccc3(255, 255, 255))
			self._openLevelTipText:removeFromParentAndCleanup(true)
		end
	end
	
end

function PlayCell:uiClkHandler(ui, rect)
	local openLevel = rawget(self._playInfo, "openLevel")
	if openLevel then --等级不够
		return
	end
	printf("clk s9Btn")
	
	if( not self.owner or not self.owner.owner or not self._playInfo ) then return end
	if self._playInfo.isSelected then return end
	
--	local action1 = CCScaleTo:create(0.05, 1.1)
	local action2 = CCScaleTo:create(0.05, 1.5)
	local action3 = CCEaseBounceOut:create(CCScaleTo:create(0.2, 1.0))
	
	local transition = require("framework.client.transition")
	local sequence = transition.sequence({action2, action3})
	ui:runAction(sequence)
	
			
	local view = self.owner.owner  -- view.qiyu.PlayView#PlayView
	view:setSelected( self._playInfo )
end

