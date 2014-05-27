---
-- 聚贤迭代 元宝抽卡界面
-- @module view.shop.juxian.JuXianYBGetCardView
--

local require = require
local class = class
local tr = tr

local ccp = ccp
local CCRect = CCRect
local CCSize = CCSize
local CCClippingNode = CCClippingNode
local CCOrbitCamera = CCOrbitCamera
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc

local printf = printf
local dump = dump

local moduleName = "view.shop.juxian.JuXianYBGetCardView"
module(moduleName)

---
-- 类定义
-- @type JuXianYBGetCardView
--
local JuXianYBGetCardView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 元宝抽卡的类型
-- @field [parent = #JuXianYBGetCardView] #number _ybGetCardType
-- 
JuXianYBGetCardView._ybGetCardType = 0

---
-- 保存原来6张卡牌的位置
-- @field [parent = #JuXianYBGetCardView] #table _cardPosTl
-- 
JuXianYBGetCardView._cardPosTl = {}

---
-- 保存所选卡
-- @field [parent = #JuXianYBGetCardView] #table _chooseCardTl
-- 
JuXianYBGetCardView._chooseCardTl = {}

---
-- 标记是否半价
-- @field [parent = #JuXianYBGetCardView] #bool _isDiscount
-- 
JuXianYBGetCardView._isDiscount = false

---
-- 标记动画是否结束
-- @field [parent = #JuXianYBGetCardView] #bool _isEnterAnimEnd
-- 
JuXianYBGetCardView._isEnterAnimEnd = false

---
-- 当前最大卡片数
-- @field [parent = #JuXianYBGetCardView] #number _currMaxCardNum
-- 
JuXianYBGetCardView._currMaxCardNum = 0

---
-- 100元宝最大卡片数
-- @field [parent = #JuXianYBGetCardView] #number _100YBCardNum
-- 
JuXianYBGetCardView._100YBCardNum = 3

---
-- 300元宝最大卡片数
-- @field [parent = #JuXianYBGetCardView] #number _300YBCardNum
-- 
JuXianYBGetCardView._300YBCardNum = 6

---
-- 构造函数
-- @function [parent = #JuXianYBGetCardView] ctor
--
function JuXianYBGetCardView:ctor()
	JuXianYBGetCardView.super.ctor(self)
	self:_create()
end

---
-- 场景进入自动回调
-- @function [parent = #JuXianYBGetCardView] onEnter
-- 
function JuXianYBGetCardView:onEnter()
	JuXianYBGetCardView.super.onEnter(self)
	
	self:_enterPlayCardAnim()
	
	local audio = require("framework.client.audio")
	audio.playEffect("sound/get_card.mp3")
end

---
-- 进入发牌动画
-- @function [parent = #JuXianYBGetCardView] _enterPlayCardAnim
-- 
function JuXianYBGetCardView:_enterPlayCardAnim()	
	local transition = require("framework.client.transition")
	for i = 1, self._currMaxCardNum do
		local speadActionFunc = function (cardPos)
			-- 执行散开动作
			local posX = self._cardPosTl[cardPos].x
			local offsetX = 0
			if self._currMaxCardNum == self._100YBCardNum then
				offsetX = self["cardCcb"..cardPos]:getContentSize().width + self["cardCcb"..cardPos]:getContentSize().width/2 * (cardPos - 1)
			else
			end
			local disPosX = posX + offsetX
			local transition = require("framework.client.transition")
			transition.moveTo(self["cardCcb"..cardPos],
				{
					time = 0.3,
					x = disPosX,
					y = self["cardCcb"..cardPos]:getPositionY(),
					easing = "CCEaseOut",
					onComplete = function ()
						self:_enterFlipCardAnim(i)
					end
				}
			)
		end
		
		
		transition.fadeIn(self["cardCcb"..i],
			{
				time = 0.3
			}
		)
		
		transition.moveBy(self["cardCcb"..i],
			{
				time = 0.5,
				x = 0,
				y = 100,
				onComplete = function () 
					speadActionFunc(i)
				end
			}
		)
		
		
	end
end

---
-- 进入聚贤翻牌动画
-- @function [parent = #JuXianYBGetCardView] _enterFlipCardAnim
-- @param #number cardPos
-- 
function JuXianYBGetCardView:_enterFlipCardAnim(cardPos)
--	for i = 1, self._currMaxCardNum do
--		self:_flipCard(self["cardCcb"..i..".backCardSpr"], self["cardCcb"..i..".cardNode"])
--	end
	self:_flipCard(self["cardCcb"..cardPos..".backCardSpr"], self["cardCcb"..cardPos..".cardNode"])
end

---
-- 执行翻牌动作
-- @function [parent = #JuXianYBGetCardView] _flipCard
-- @param #CCNode startNode 翻牌前的Node
-- @param #CCNode endNode 翻牌后的Node
-- 
function JuXianYBGetCardView:_flipCard(startNode, endNode)
	local transition = require("framework.client.transition")
	
	local func = function ()
		--printf("time half")
		endNode:setVisible(true)
	end
	
	local flipCardTime = 0.5
	
	local inActions = transition.sequence(
		{
			CCOrbitCamera:create(flipCardTime, 1, 1, 0, 90, 0, 0),
			CCCallFunc:create(func),
		}
	)
	startNode:runAction(inActions)
	
	local animFinishFunc = function ()
		self._isEnterAnimEnd = true
		self:setAllBtnEnable(true)
	end
	endNode:setScaleX(-1)
	endNode:setVisible(false)
	--endNode:setAnchorPoint(ccp(0.5, 0.5))
	local outActions = transition.sequence(
		{
			--CCOrbitCamera:create(2, 1, 1, 0, 90, 0, 0),  
			CCDelayTime:create(flipCardTime),
			CCOrbitCamera:create(flipCardTime, 1, 0, 90, 90, 0, 0),
			CCCallFunc:create(animFinishFunc)
		}
	)
	endNode:runAction(outActions)
end

---
-- 加载ccbi
-- @function [parent = #JuXianYBGetCardView] _create
--
function JuXianYBGetCardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_getcard_2.ccbi")
	
	-- 裁剪 
	for i = 1, self._300YBCardNum do
		local clipNode = CCClippingNode:create()
		clipNode:setStencil(self["cardCcb"..i..".maskSpr"])
		--clipNode:setInverted(true)
		self["cardCcb"..i..".partnerSpr"]:removeFromParentAndCleanup(false)
		--self["cardCcb"..i..".partnerSpr"]:setPosition(ccp(60, 80))
		clipNode:addChild(self["cardCcb"..i..".partnerSpr"])
		clipNode:setZOrder(-1)
		clipNode:setAlphaThreshold(0)
		clipNode:setAnchorPoint(ccp(0.5, 0.5))
		self["cardCcb"..i..".cardNode"]:addChild(clipNode)
		self["cardCcb"..i..".maskSpr"]:removeFromParentAndCleanup(false)
		
		-- 为显示动画设置的初始值
		self["cardCcb"..i]:setOpacity(0)
		self["cardCcb"..i]:setPositionY(self["cardCcb"..i]:getPositionY() - 100)
		self["cardCcb"..i..".cardNode"]:setVisible(false)
		self["cardCcb"..i..".crashSpr"]:setVisible(false)
	end
	
	-- 添加卡牌触控监听
	self:createClkHelper()
	for i = 1, self._300YBCardNum do
		self["cardCcb"..i..".checkSpr"]:setVisible(false)
		self["cardCcb"..i]._checkSpr = self["cardCcb"..i..".checkSpr"]
		
		self._cardPosTl[#self._cardPosTl + 1] = {} 
		self._cardPosTl[#self._cardPosTl].x = self["cardCcb"..i]:getPositionX() 
	
		self:addClkUi("cardCcb"..i)
	end
	
	local juxianData = require("model.JuXianData")
	self["pointLab"]:setString(tr("共需集卡点数<c1> 0/"..juxianData.MAX_JUXIAN_POINT))
	self["pointYBLab"]:setString(tr("超出部分集卡点数需额外购买，"..juxianData.POINT_YUANBAO.."元宝/点"))
	
	self["getCardDescLab"]:setDimensions(CCSize(220, 0))
	self:setChooseCardDesc("")
	
	self:setAllBtnEnable(false)
	
	self["pointYBLab"]:setVisible(false)
	
	self:handleButtonEvent("yesCcb.aBtn", self._yesBtnHandler)
	self:handleButtonEvent("noCcb.aBtn", self._cancelBtnHandler)
end 

---
-- 点击了确定按钮
-- @function [parent = #JuXianYBGetCardView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function JuXianYBGetCardView:_yesBtnHandler(sender, event)
	--dump(self._chooseCardTl)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_juxian_chooseka", {type = self._ybGetCardType, poslist = self._chooseCardTl})
	
	-- 检测是否有引导
	local GuideUi = require("view.guide.GuideUi")
    if GuideUi.getHasAfterFightGuide() then
    	GuideUi.createAfterFightGuide()
    elseif GuideUi.getHasNewGuide() then
    	GuideUi.createGuideAfterGuide()
    end	
end

---
-- 点击了取消按钮
-- @function [parent = #JuXianYBGetCardView] _cancelBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function JuXianYBGetCardView:_cancelBtnHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_juxian_clearka", {type = self._ybGetCardType})

	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 设置元宝抽卡的类型 100/300
-- @function [parent = #JuXianYBGetCardView] setYBGetCardType
-- @param #number type
-- 
function JuXianYBGetCardView:setYBGetCardType(type)
	self._ybGetCardType = type
end

---
-- 设置抽卡样式 100、300的样式
-- @function [parent = #JuXianYBGetCardView] setJuXianType
-- @param #number type
--  
function JuXianYBGetCardView:setJuXianType(type)
	local math = require("math")
	local display = require("framework.client.display")
	local midPos = self:getContentSize().width/2
		
	if type == 11 then -- 100 元宝抽卡样式
		self._currMaxCardNum = self._100YBCardNum
		
		for i = 1, self._100YBCardNum do
			--local posX = self["cardCcb"..i]:getPositionX()
			
			local minCcb = math.ceil(self._100YBCardNum/2)
			local offsetMidDisX = (i - minCcb) * self["cardCcb"..i]:getContentSize().width/4
			self["cardCcb"..i]:setPositionX(midPos + offsetMidDisX - self["cardCcb"..i]:getContentSize().width/4)
			
			self["cardCcb"..i]:setVisible(true)
			self:addClkUi("cardCcb"..i)
		end
		for i = self._100YBCardNum + 1, self._300YBCardNum do
			self["cardCcb"..i]:setVisible(false)
			self:removeClkUi("cardCcb"..i)
		end
		
		self["100YuanBaoCcb"]:setVisible(true)
		self["300YuanBaoCcb"]:setVisible(false)
		
		self["giveUpYBLab"]:setString(tr("放弃返还"..(80 * 0.3).."元宝"))
	else  -- 300 元宝抽卡样式
		self._currMaxCardNum = self._300YBCardNum
		for i = 1, self._300YBCardNum do
			local minCcb = math.ceil(self._300YBCardNum/2)
			
			local offsetMidDisX = (i - minCcb) * self["cardCcb"..i]:getContentSize().width/4
			self["cardCcb"..i]:setPositionX(midPos + offsetMidDisX - self["cardCcb"..i]:getContentSize().width/4)
		
--			self["cardCcb"..i]:setVisible(true)
--			self["cardCcb"..i]:setPositionX(self._cardPosTl[i].x)
			self:addClkUi("cardCcb"..i)
		end
		
		self["giveUpYBLab"]:setString(tr("放弃返还"..(200 * 0.5).."元宝"))
		self["100YuanBaoCcb"]:setVisible(false)
		self["300YuanBaoCcb"]:setVisible(true)
	end
end

---
-- 显示抽卡信息
-- @function [parent = #JuXianYBGetCardView] showPartnerMsg
-- @param #table msg
--  
function JuXianYBGetCardView:showPartnerMsg(msg)
	--dump(msg)
	self:setJuXianType(msg.type)
	self._isDiscount = msg.isdis
	if msg.isdis == 1 then --半价
		self["noCcb.aBtn"]:setEnabled(false)
	end
	
	local partners = msg.list_info
	for i = 1, #partners do
		self:changeTexture("cardCcb"..i..".partnerSpr", "card/" .. partners[i].icon .. ".jpg")
		self["cardCcb"..i..".partnerSpr"]:setTextureRect(CCRect(0, 0, 236, 352))
		self["cardCcb"..i..".partnerSpr"]:setScale(0.53)
		
		local PartnerShowConst = require("view.const.PartnerShowConst")
		if partners[i].num == 1 then
			self["cardCcb"..i..".nameLab"]:setString(PartnerShowConst.STEP_COLORS[partners[i].step]..partners[i].name)
		else
			self["cardCcb"..i..".nameLab"]:setString(PartnerShowConst.STEP_COLORS[partners[i].step]..partners[i].name.." * "..partners[i].num)
		end
		self["cardCcb"..i].step = partners[i].step
		self["cardCcb"..i].ptype = partners[i].ptype
		
		-- 绿色以上升星过的卡牌
		if partners[i].step > 1 and partners[i].star > 0 and partners[i].ptype == 1 then
			self["cardCcb"..i..".starBgSpr"]:setVisible(true)
			self["cardCcb"..i..".starLab"]:setVisible(true)
			self["cardCcb"..i..".typeBgSpr"]:setVisible(true)
			self["cardCcb"..i..".starLab"]:setString(partners[i].star)
			self:changeFrame("cardCcb"..i..".typeBgSpr", PartnerShowConst.STEP_STARBG[partners[i].star])
--				self["headCcb"..i..".typeSpr"]:setPosition(96,14)
		elseif partners[i].ptype ~= 2 then
			self["cardCcb"..i..".starBgSpr"]:setVisible(false)
			self["cardCcb"..i..".starLab"]:setVisible(false)
			self["cardCcb"..i..".typeBgSpr"]:setVisible(true)
			self:changeFrame("cardCcb"..i..".typeBgSpr", PartnerShowConst.STEP_ICON1[partners[i].step])
--				self["headCcb"..i..".typeSpr"]:setPosition(99,12)
		end
		
		if partners[i].ptype == 2 then -- 碎片
			self["cardCcb"..i..".starBgSpr"]:setVisible(false)
			self["cardCcb"..i..".starLab"]:setVisible(false)
			self["cardCcb"..i..".typeBgSpr"]:setVisible(false)
			
			self["cardCcb"..i..".crashSpr"]:setVisible(true)
		end
		
		self:changeFrame("cardCcb"..i..".typeSpr", PartnerShowConst.STEP_TYPE[partners[i].type])
		self["cardCcb"..i..".typeSpr"]:setVisible(true)
	end
end

---
-- 场景退出自动回调
-- @function [parent = #JuXianYBGetCardView] onExit
-- 
function JuXianYBGetCardView:onExit()
	instance = nil
	JuXianYBGetCardView.super.onExit(self)
end

---
-- 设置选中卡片
-- @function [parent = #JuXianYBGetCardView] setCardCheck
-- @param #string spr
-- 
function JuXianYBGetCardView:setCardCheck(spr)
	if spr.isCheck == nil or spr.isCheck == false then
		spr.isCheck = true
	else
		spr.isCheck = false
	end
	
	if spr.isCheck then
		spr._checkSpr:setVisible(true)
		self:showPartnerEffect(spr)
		
		local audio = require("framework.client.audio")
		audio.playEffect("sound/clickcard.mp3")
	else
		spr._checkSpr:setVisible(false)
		if spr._texiaoSpr then
			spr._texiaoSpr:removeFromParentAndCleanup(true)
			spr._texiaoSpr = nil
		end
	end
	
	local sumPoint = self:_calPoint()
	self:setCurrPoint(sumPoint)
	local chooseDesc = self:_getChooseCardDesc()
	self:setChooseCardDesc(chooseDesc)
end

---
-- 显示卡牌特效
-- @function [parent = #JuXianYBGetCardView] showPartnerEffect
-- @param #CCSprite spr
-- 
function JuXianYBGetCardView:showPartnerEffect(spr)
	-- 特效Spr
	local display = require("framework.client.display")
	local transition = require("framework.client.transition")
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	spr._texiaoSpr = texiaospr
	spr:addChild(texiaospr)
	texiaospr:setPosition(ccp(spr:getContentSize().width/2 - 3, spr:getContentSize().height/2 + 8))
	texiaospr:setScale(1.0)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
end

---
-- 设置当前选中显示的点数
-- @function [parent = #JuXianYBGetCardView] setCurrPoint
-- @param #number num
-- 
function JuXianYBGetCardView:setCurrPoint(num)
	local maxJuxianPoint = require("model.JuXianData").MAX_JUXIAN_POINT
	local ItemViewConst = require("view.const.ItemViewConst")	 
	if num <= maxJuxianPoint then
		self["pointLab"]:setString(tr("共需集卡点数".."<c1>"..num.."/"..maxJuxianPoint))
		self["pointYBLab"]:setVisible(false)
	else
		self["pointLab"]:setString(tr("共需集卡点数".."<c5>"..num.."/"..maxJuxianPoint.."<c0>, 已超出"..ItemViewConst.EQUIP_STEP_COLORS[5]..(num - maxJuxianPoint).."点"))
		self["pointYBLab"]:setVisible(true)
	end
end

---
-- 设置选中卡片描述lab
-- @function [parent = #JuXianYBGetCardView] setChooseCardDesc
-- @param #string desc
--  
function JuXianYBGetCardView:setChooseCardDesc(desc)
	self["getCardDescLab"]:setString(desc)
end

---
-- 获取卡片的描述
-- @function [parent = #JuXianYBGetCardView] _getChooseCardDesc
-- @return #string
-- 
function JuXianYBGetCardView:_getChooseCardDesc()
	local partnerNum = self._currMaxCardNum
	
	local stepTl = {}
	stepTl[1] = {}
	stepTl[2] = {}
	
	for i = 1, partnerNum do
		local cardCcb = self["cardCcb"..i]
		if cardCcb.isCheck then
			local step
			if cardCcb.ptype == 1 then --侠客
				if stepTl[1][cardCcb.step] == nil then
					stepTl[1][cardCcb.step] = 1
				else
					stepTl[1][cardCcb.step] = stepTl[1][cardCcb.step] + 1
				end
			else --道具
				if stepTl[2][cardCcb.step] == nil then
					stepTl[2][cardCcb.step] = 1
				else
					stepTl[2][cardCcb.step] = stepTl[2][cardCcb.step] + 1
				end
			end
		end
	end
	
	local desc = tr("您选中了 ")
	local hasChoose = false --标记是否选中卡片，判断是不是需要加逗号

	local PartnerShowConst = require("view.const.PartnerShowConst")	
	for tlNum = 1, 2 do
		for i = 5, 1, -1 do
			local cardNum = stepTl[tlNum][i]
			if cardNum then
				local cardType = PartnerShowConst.STEP_COLORS[i]
				if i == 5 then
					cardType = cardType..tr("橙卡")
				elseif i == 4 then
					cardType = cardType..tr("紫卡")
				elseif i == 3 then
					cardType = cardType..tr("蓝卡")
				elseif i == 2 then
					cardType = cardType..tr("绿卡")
				else
					cardType = cardType..tr("白卡")
				end
				
				if tlNum == 2 then
					cardType = cardType..tr("碎片")
				end
				local dot = ""
				if hasChoose == true then
					dot = ", "
				end
				desc = desc..dot..cardNum..tr("张")..cardType..PartnerShowConst.STEP_COLORS[1]
				
				if hasChoose == false then
					hasChoose = true
				end
			end
		end
	end
	
	if hasChoose == false then
		desc = ""
	end
	return desc
end

---
-- 计算完点数
-- @function [parent = #JuXianYBGetCardView] _calPoint
-- @return #number 
-- 
function JuXianYBGetCardView:_calPoint()
	local partnerNum = self._currMaxCardNum
	
	local sumPoint = 0
	
	self._chooseCardTl = {}
	for i = 1, partnerNum do
		local cardCcb = self["cardCcb"..i]
		if cardCcb.isCheck then
			printf("self._ybGetCardType = "..self._ybGetCardType)
			local stepTl = require("xls.JuXianStepPointXls").data[self._ybGetCardType].Type[cardCcb.ptype].Step
			sumPoint = sumPoint + stepTl[cardCcb.step]
			
			self._chooseCardTl[#self._chooseCardTl + 1] = i
		end
	end
	
	return sumPoint
end	

---
-- 显示奖励信息
-- @function [parent = #JuXianYBGetCardView] showReward
-- 
function JuXianYBGetCardView:showReward()
	local itemNameStr = ""
	local hasAttach = false
	local dot = ""
	for i = 1, #self._chooseCardTl do
		local pos = self._chooseCardTl[i]
		local itemName = self["cardCcb"..pos..".nameLab"]:getString()
		
		if hasAttach == true then
			dot = ", "
		end
		
		itemNameStr = itemNameStr..dot..itemName
		
		hasAttach = true
	end
	
	local notify = require("view.notify.FloatNotify")
	notify.show(tr("获得了 "..itemNameStr))
		  
end

---
-- 点击处理
-- @function [parent = #JuXianYBGetCardView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function JuXianYBGetCardView:uiClkHandler(ui, rect)
	if self._isEnterAnimEnd == true then
		self:setCardCheck(ui)
	end
end

---
-- 设置按钮是否可用
-- @function [parent = #JuXianYBGetCardView] setAllBtnEnable
-- @param #bool enable
-- 
function JuXianYBGetCardView:setAllBtnEnable(enable)
	self["yesCcb.aBtn"]:setEnabled(enable)
	if self._isDiscount ~= 1 then
		self["noCcb.aBtn"]:setEnabled(enable)
	end
end



