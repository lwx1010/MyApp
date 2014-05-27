--- 
-- 武林榜界面
-- @module view.wulinbang.WuLinBangView
-- 

local class = class
local printf = printf
local dump = dump
local require = require
local ccp = ccp
local tr = tr

local CCTextureCache = CCTextureCache
local CCSpriteFrameCache = CCSpriteFrameCache
local CCRect = CCRect
local CCSize = CCSize
local CCRotateTo = CCRotateTo
local CCRepeatForever = CCRepeatForever
local CCRotateBy = CCRotateBy

local moduleName = "view.wulinbang.WuLinBangView"
module(moduleName)

--- 
-- 类定义
-- @type WuLinBangView
-- 
local WuLinBangView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武林榜领取奖励倒计时
-- @field [parent=#WuLinBangView] #_endTime
-- 
WuLinBangView._endTime = 0

---
-- 武林榜handle
-- @field [parent=#WuLinBangView] #handl _timeHandle
-- 
WuLinBangView._timeHandle = nil

---
-- 购买次数所需元宝数
-- @field [parent=#WuLinBangView] #number _needYB
-- 
WuLinBangView._needYB = 0

---
-- 是否可以购买次数
-- @field [parent=#WuLinBangView] #boolean _canBuyCnt
-- 
WuLinBangView._canBuyCnt = true

---
-- 可挑战次数
-- @field [parent=#WuLinBangView] #number _challengeCnt
-- 
WuLinBangView._challengeCnt = 0 

---
-- 整个可滑动区域
-- @field [parent=#WuLinBangView] #number _maxSlideDistance
-- 
WuLinBangView._maxSlideDistance = require("framework.client.display").width * 2

---
-- 保存树背景句柄
-- @field [parent=#WuLinBangView] #table _treeSpriteTable
--  
WuLinBangView._treeSpriteTable = nil

---
-- 保存塔背景句柄
-- @field [parent=#WuLinBangView] #table _taSpriteTable
--  
WuLinBangView._taSpriteTable = nil

---
-- 人物表
-- @field [parent=#WuLinBangView] #table _heroTable
-- 
WuLinBangView._heroTable = nil

---
-- 人物属性信息表
-- @field [parent=#WuLinBangView] #CCBView _playerMsgView
-- 
WuLinBangView._playerMsgView = nil

---
-- 玩家自己信息表
-- @field [parent=#WuLinBangView] #CCBView _myselfMsgView
-- 
WuLinBangView._myselfMsgView = nil

---
-- 玩家自己的CCSprite
-- @field [parent=#WuLinBangView] #CCSprite _mySprite
-- 
WuLinBangView._mySprite = nil

---
-- 目标CCSprite
-- @field [parent=#WuLinBangView] #CCSprite _targetSprite
-- 
WuLinBangView._targetSprite = nil

---
-- 延迟处理消息保存
-- @field [parent=#WuLinBangView] #table _delayDealMsg
-- 
WuLinBangView._delayDealMsg = nil

---
--  树图层滑动的偏移值
-- @field [parent=#WuLinBangView] #number _treeLayerOffsetX
-- 
WuLinBangView._treeLayerOffsetX = 0

---
-- 自己开始位置
-- @field [parent=#WuLinBangView] #number _myselfBeginX
-- 
WuLinBangView._myselfBeginX = 210

---
-- 敌人开始位置
-- @field [parent=#WuLinBangView] #number _enemyBeginX
-- 
WuLinBangView._enemyBeginX = 400

---
-- 自己的相对于上一次的位移
-- @field [parent=#WuLinBangView] #number _myselfOffsetX
-- 
WuLinBangView._myselfOffsetX = 0

---
-- 累计树的滑动，用来优化背景
-- @field [parent=#WuLinBangView] #number _treeLayerSliderAdd
-- 
WuLinBangView._treeLayerSliderAdd = 0

---
-- 累计塔图层的滑动，优化背景
-- @field [parent=#WuLinBangView] #number _taLayerSliderAdd
-- 
WuLinBangView._taLayerSliderAdd = 0

---
-- 保存全三名人物的表
-- @field [parent=#WuLinBangView] #table _before3RankTable
-- 
WuLinBangView._before3RankTable = nil

---
-- 触摸开始时间
-- @field [parent=#WuLinBangView] #number _touchStartTime
-- 
WuLinBangView._touchStartTime = 0

---
-- 自己所在图层
-- @field [parent=#WuLinBangView] #number _myselfLayerNum
-- 
WuLinBangView._myselfLayerNum = 100

---
-- 延迟调用清除Sprite数据句柄
-- @field [parent=#WuLinBangView] #scheduler _cleanSprSche
-- 
WuLinBangView._cleanSprSche = nil

---
-- 标记是否在动画中
-- @field [parent=WuLinBangView] #bool _isPlayAnim
-- 
WuLinBangView._isPlayAnim = false

--- 
-- 构造函数
-- @function [parent=#WuLinBangView] ctor
-- @param self
-- 
function WuLinBangView:ctor()
	WuLinBangView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#WuLinBangView] _create
-- @param self
-- 
function WuLinBangView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_wulinbang.ccbi")
	
	local display = require("framework.client.display")
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_number.plist", "res/ui/ccb/ccbResources/common/ui_ver2_number.png")
	
	--初始化表
	self._treeSpriteTable = {}
	self._taSpriteTable = {}
	self._heroTable = {}
	self._before3RankTable = {}
	
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("addTimeBtn", self._buyCntClkHandler)

	-- 加载树的背景图
	local treeWidth =0
	local display = require("framework.client.display")
	
	while treeWidth < self._maxSlideDistance/2*3 do
		local spr = display.newSprite("res/ui/ccb/ccbResources/layout/wulinbang/front.png")
		self._treeSpriteTable[#self._treeSpriteTable + 1] = spr
		spr:setContentSize(CCSize(1136, 640))
		spr:setAnchorPoint(ccp(0, 0))
		spr:setPosition(treeWidth - display.designLeft, 0)
		self["treeLayer"]:addChild(spr)
		treeWidth = treeWidth + spr:getContentSize().width
	end
	
	-- 加载塔的背景图
	local taWidth = 0
	while taWidth < self._maxSlideDistance/2*3 do
		local spr = display.newSprite("res/ui/ccb/ccbResources/layout/wulinbang/middle.png")
		self._taSpriteTable[#self._taSpriteTable + 1] = spr
		spr:setContentSize(CCSize(1136, 640))
		spr:setAnchorPoint(ccp(0, 0))
		spr:setPosition(taWidth - display.designLeft, 0)
		self["taLayer"]:addChild(spr)
		taWidth = taWidth + spr:getContentSize().width
	end
	
	-- 加载山
	local moutainSpr = display.newSprite("res/ui/ccb/ccbResources/layout/wulinbang/front2.png")
	moutainSpr:setAnchorPoint(ccp(0, 0))
	moutainSpr:setPosition(self._maxSlideDistance - moutainSpr:getContentSize().width, 0)
	self["circleLayer"]:addChild(moutainSpr)
	moutainSpr:setContentSize(CCSize(1136, 640))
	-- 添加触摸监控
	self["allLayer"]:registerScriptTouchHandler(
		function (...)
			return self:_onBattleTouch(...)
		end,
		false, 
		0,
		false
	)
	self["allLayer"]:setTouchEnabled(true)
	
	-- 创建人物信息表
	self._playerMsgView = require("view.wulinbang.PlayerMsgView").createInstance()
	self._playerMsgView:setVisible(false)
	self._playerMsgView:setAnchorPoint(ccp(0.5, 0))
	self["allLayer"]:addChild(self._playerMsgView)
	
	-- 创建点击自己出现的信息表
	self._myselfMsgView = require("view.wulinbang.MySelfMsgView").createInstance()
	self._myselfMsgView:setVisible(false)
	self._myselfMsgView:setAnchorPoint(ccp(0.5, 0))
	self["allLayer"]:addChild(self._myselfMsgView)
	
	-- 添加监控
	self:createClkHelper()
	self:addClkUi("hitRewardSpr")
	
	self["sunSpr"]:setVisible(false)
	
	--阳光动画
	local transition = require("framework.client.transition")
	local action = transition.sequence({
		CCRotateTo:create(6, 15),  
		CCRotateTo:create(6, 0),
	})
	action = CCRepeatForever:create(action)
	self["sunShineSpr"]:runAction(action)
end

---
-- 触摸事件
-- @function [parent=#WuLinBangView] _onBattleTouch
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_onBattleTouch(event, x, y)
	if event == "began" then
		return self:_onTouchBegan(event, x, y)
	elseif event == "moved" then
		return self:_onTouchMove(event, x, y)
	elseif event == "ended" then
		return self:_onTouchEnded(event, x, y)
	else --canceled
	end
end

---
-- 触摸开始
-- @function [parent=#WuLinBangView] _onTouchBegan
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_onTouchBegan(event, x, y)
	self["allLayer"]._beganX = x
	self["allLayer"]._startPosX = self["allLayer"]:getPositionX() 
	self["allLayer"]:stopAllActions()
	local os = require("os")
	self._touchStartTime = os.clock()
	
	return true
end

---
-- 触摸
-- @function [parent=#WuLinBangView] _onTouchMove
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_onTouchMove(event, x, y)
	if self._mySprite then
		if self._mySprite._playerMsg.rank > 5 then
			local posX = self["allLayer"]._startPosX + (x - self["allLayer"]._beganX)
			
			local display = require("framework.client.display")
			local startX
			local endX
			if display.hasXGaps == true then
				startX = 0
				endX = -self._maxSlideDistance/2 - display.designLeft
			else
				startX = display.designLeft
				endX = -self._maxSlideDistance/2 - display.designLeft * 2
			end
			if posX <= startX and posX >= endX then
				self["allLayer"]:setPositionX(posX)
			end
		end
	end
	
	return true
end

---
-- 触摸结束
-- @function [parent=#WuLinBangView] _onTouchEnded
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_onTouchEnded(event, x, y)
	--平滑移动
	local smoothX = 0
	local os = require("os")
	smoothX = (x - self["allLayer"]._beganX)/(os.clock() - self._touchStartTime)/5
	
	local math = require("math")
	
	local offsetXDis = 20
	local device = require("framework.client.device")
	if device.platform == "ios" then  --IOS特殊处理
		offsetXDis = 80
	end
	
	if math.abs(smoothX) > offsetXDis then 
		if self._mySprite then
			if self._mySprite._playerMsg.rank > 5 then
				local posX = self["allLayer"]:getPositionX() + smoothX
				local display = require("framework.client.display")
				local startX
				local endX
				if display.hasXGaps == true then
					startX = 0
					endX = -self._maxSlideDistance/2 - display.designLeft
				else
					startX = display.designLeft
					endX = -self._maxSlideDistance/2 - display.designLeft * 2
				end
				posX = self:_clamp(posX, endX, startX)
				
				local transition = require("framework.client.transition")
				transition.moveTo(self["allLayer"], 
					{
				        x = posX,
				        y = self["allLayer"]:getPositionY(),
				        time = 0.6,
				        --time = moveTime,
				        easing = "SINEOUT"
				    }
				)
			end
		end
	else --偏差范围内，说明是点击事件
		local hitPlayer = self:_isClickPlayer(x - self["allLayer"]:getPositionX(), y)
		if hitPlayer and hitPlayer ~= self._mySprite then
			self._playerMsgView:setShowMsg(hitPlayer._playerMsg)
			self._playerMsgView:setVisible(true)
			self._myselfMsgView:setVisible(false)
			local x = hitPlayer:getPositionX()
			local y = hitPlayer:getPositionY()
			if hitPlayer._playerMsg.rank > 4 then
				self._playerMsgView:setShowType(1)
				self._playerMsgView:setPosition(x - self._treeLayerOffsetX, y + 100)
			else
				if hitPlayer._playerMsg.rank == 1 or hitPlayer._playerMsg.rank == 2 then
					self._playerMsgView:setShowType(2)
					self._playerMsgView:setPosition(x - 200, y - 150)
				else
					self._playerMsgView:setShowType(1)
					self._playerMsgView:setPosition(x, y + 100)
				end
			end
		elseif hitPlayer ~= nil and hitPlayer == self._mySprite then
			self._playerMsgView:setVisible(false)
			self._myselfMsgView:setVisible(true)
			self._myselfMsgView:setShowMsg(hitPlayer._playerMsg)
			local x = hitPlayer:getPositionX()
			local y = hitPlayer:getPositionY()
			if hitPlayer._playerMsg.rank > 4 then
				self._myselfMsgView:setShowType(1)
				self._myselfMsgView:setPosition(x - self._treeLayerOffsetX, y + 100)
			else
				if hitPlayer._playerMsg.rank == 1 or hitPlayer._playerMsg.rank == 2 then
					self._myselfMsgView:setShowType(2)
					self._myselfMsgView:setPosition(x - 200, y - 80)
				else
					self._myselfMsgView:setShowType(1)
					self._myselfMsgView:setPosition(x, y + 100)
				end
			end
		else
			self._playerMsgView:setVisible(false)
			self._myselfMsgView:setVisible(false)
		end
	end
	
	return true
	
end

--- 
-- 点击了购买挑战次数
-- @function [parent=#WuLinBangView] _buyCntClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function WuLinBangView:_buyCntClkHandler( sender, event )
	local FloatNotify = require("view.notify.FloatNotify")
	if not self._canBuyCnt then
		FloatNotify.show(tr("你当前vip等级所能购买的次数已用完！"))
		return
	end
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.YuanBao < self._needYB then
		FloatNotify.show(tr("元宝不足，无法购买挑战次数！"))
		return
	end
	
	local BuyCntTipView = require("view.wulinbang.BuyCntTipView")
	BuyCntTipView.new():openUi(self._needYB)
end

--- 
-- 点击了关闭
-- @function [parent=#WuLinBangView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function WuLinBangView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    --GameView.replaceMainView(MainView.createInstance(), true)
    GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#WuLinBangView] openUi
-- @param self
-- 
function WuLinBangView:openUi()
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	--每次打开界面都会重新请求协议
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_wulin_info", {index = 1})
	GameNet.send("C2s_wulin_user_info", {index = 1})
end

---
-- 显示基础信息
-- @function [parent=#WuLinBangView] showBaseInfo
-- @param self
-- @param #S2c_wulin_user_info pb
-- 
function WuLinBangView:showBaseInfo( pb )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	if not pb then return end
	
	self._challengeCnt = pb.pk_num
	self._canBuyCnt = pb.can_buy_pk == 1
	self._needYB = pb.buy_pk_yb
	self["leftCntLab"]:setString(pb.pk_num)
	
--	self["rankNumLab"]:setBmpPathFormat("ccb/number/%d.png")
--	self["rankNumLab"]:setValue(pb.user_rank)
	
	local scheduler = require("framework.client.scheduler")
	local NumberUtil = require("utils.NumberUtil")
	if self._timeHandle then
		scheduler.unscheduleGlobal(self._timeHandle)
		self._timeHandle = nil
	end
	
	if pb.over_time > 0 then
		--self["rewardCcb.aBtn"]:setEnabled(false)
		--self["rewardCcbSpr"]:setOpacity(80)
		
		self._endTime = pb.over_time
		local func = function()
			self._endTime = self._endTime - 1
			if self._endTime <= 0 then
				scheduler.unscheduleGlobal(self._timeHandle)
				self._timeHandle = nil
				self["timeLab"]:setString(tr("剩余<c1>") .. NumberUtil.secondToDate(0))
				
				-- 显示特效
				self["sunSpr"]:stopAllActions()
				local transition = require("framework.client.transition")
				local action = transition.sequence({
					CCRotateBy:create(3.0, 360),  
				})
				action = CCRepeatForever:create(action)
				self["sunSpr"]:runAction(action)
				self["sunSpr"]:setVisible(true)
				return
			else
				self["sunSpr"]:setVisible(false)
			end
			
			self["timeLab"]:setString(tr("剩余<c1>") .. NumberUtil.secondToDate(self._endTime))
		end
		
		if self._timeHandle == nil then
			self._timeHandle = scheduler.scheduleGlobal(func, 1)
		end
	else
--		self["rewardCcb.aBtn"]:setEnabled(true)
--		self["rewardCcbSpr"]:setOpacity(255)
		self["timeLab"]:setString(tr("剩余<c1>") .. NumberUtil.secondToDate(0))
		
		-- 显示特效
		self["sunSpr"]:stopAllActions()
		local transition = require("framework.client.transition")
		local action = transition.sequence({
			CCRotateBy:create(3.0, 360),  
		})
		action = CCRepeatForever:create(action)
		self["sunSpr"]:runAction(action)
		self["sunSpr"]:setVisible(true)
	end
	
	if pb.bonus_type == "Cash" then
		self:changeFrame("rewardSpr", "ccb/mark/coin.png")
	elseif pb.bonus_type == "YuanBao" then
		self:changeFrame("rewardSpr", "ccb/mark/gold.png")
	elseif pb.bonus_type == "UserExp" then
		self:changeFrame("rewardSpr", "ccb/mark/Prestige.png")
	elseif pb.bonus_type == "PartnerExp" then
		self:changeFrame("rewardSpr", "ccb/mark/exp.png")
	end
	
	self["rewardLab"]:setString("<c8>".."   "..pb.bonus_value)
end

--- 
-- 显示玩家
-- @function [parent=#WuLinBangView] showPlayers
-- @param self
-- @param #table list
-- @param #number isChange
-- 
function WuLinBangView:showPlayers(list, isChange)
	--printf("set players.....")
	if not list then return end
	if isChange == nil then isChange = 0 end
	
--	dump(self._heroTable)
--	dump(list)
	if (#self._heroTable ~= 0 or #self._before3RankTable ~= 0) and isChange == 0 then
		self:setDelayDealMsg(list)
		--printf("set players.....")
		return
	end
	
	if isChange == 1 then --玩家被人攻击后重新刷新情况
		for i = 1, #self._heroTable do
			self._heroTable[i]:removeFromParentAndCleanup(true)
		end
		for i = 1, #self._before3RankTable do
			self._before3RankTable[i]:removeFromParentAndCleanup(true)
		end
		self._playerMsgView:setVisible(false)
		self._heroTable = {}
		self._before3RankTable = {}
		self._mySprite = nil
	end
	
	function sortbyrank(a, b)  --从小到大
		return a.rank > b.rank
	end
	
--	printf("len:" .. #list)
	local table = require("table")
	table.sort(list, sortbyrank)
	
	local addPos = 0
	local myRank
	local mySelfShow = false --不显示排名比自己后的人
	for i = 1, #list do
		local player = list[i]
		
		if player.can_pk == 3 or player.can_pk == 4 then
			mySelfShow = true
		end
		
		if player.rank < 6 then
			mySelfShow = true
		end
		 
		if mySelfShow == true then
			--加载动画
			local display = require("framework.client.display")
			local texData = CCTextureCache:sharedTextureCache():addImage("body/"..player.photo..".png")
			if texData == nil then
				-- 找不到，采用默认图片
				player.photo = "1010000"
			end
			
			display.addSpriteFramesWithFile("body/"..player.photo..".plist", "body/"..player.photo..".png")
		    local spriteAction = require("utils.SpriteAction")
		    local chatSpr = display.newSprite()
--		    self._heroTable[#self._heroTable + 1] = chatSpr
		    chatSpr._playerMsg = player
		    spriteAction.spriteRunForeverAction(chatSpr, player.photo.."/idle2/7/1000%d.png", 0, 3)
		    
		    --判断图片规格大小
	        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache()
	        local frame = spriteFrame:spriteFrameByName(player.photo.."/idle2/7/10000.png")
			local spriteSize = frame:getOriginalSize()
			
			if player.can_pk == 3 or player.can_pk == 4 then --表示自己
				self._mySprite = chatSpr
				myRank = player.rank	
				if player.rank > 4 then --在地下
		    		if player.rank == 5 then --特殊情况
		    			self:_setMainLayerPos(-display.width - display.designLeft)
		    			chatSpr:setPosition(display.width + self._myselfBeginX + self._treeLayerOffsetX, 120)
		    		else
		    			self:_setMainLayerPos(0 - display.designLeft)
		    			chatSpr:setPosition(self._myselfBeginX + self._treeLayerOffsetX, 120)
		    		end
		    		chatSpr:setZOrder(self._myselfLayerNum)
		    		self._heroTable[#self._heroTable + 1] = chatSpr
		    		
		    		--显示名次
		    		local flagSpr = display.newSprite("#ccb/wulingbang/ranking.png")
		    		flagSpr:setPosition(spriteSize.width/2 - 20, spriteSize.height/2 + 100)
		    		local BmpNumberLabel = require("ui.BmpNumberLabel")
					local lab = BmpNumberLabel.new()
					lab:setPosition(spriteSize.width/2 + 20, spriteSize.height/2 + 100)
					lab:setBmpPathFormat("ccb/number/%d.png")
					lab:setValue(player.rank)
					chatSpr:addChild(lab)
					chatSpr:addChild(flagSpr)
					
		    		self["treeLayer"]:addChild(chatSpr)
		    	else
		    		local rankSpr
		    		if player.rank == 1 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/one.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 160, 460)
		    			chatSpr:setFlipX(true)
		    		elseif player.rank == 2 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/two.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 225, 260)
		    		elseif player.rank == 3 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/three.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 330, 130)
		    		elseif player.rank == 4 then
			    		--显示名次
			    		local flagSpr = display.newSprite("#ccb/wulingbang/ranking.png")
			    		flagSpr:setPosition(spriteSize.width/2 - 20, spriteSize.height/2 + 100)
			    		local BmpNumberLabel = require("ui.BmpNumberLabel")
						local lab = BmpNumberLabel.new()
						lab:setPosition(spriteSize.width/2 + 20, spriteSize.height/2 + 100)
						lab:setBmpPathFormat("ccb/number/%d.png")
						lab:setValue(player.rank)
						chatSpr:addChild(lab)
		    			chatSpr:addChild(flagSpr)
		    			chatSpr:setPosition(display.width * 2 - 525, 90)
		    		end
		    		if rankSpr then
		    			rankSpr:setPosition(spriteSize.width/2, spriteSize.height/2 + 110)
		    		end
		    		self._before3RankTable[#self._before3RankTable + 1] = chatSpr
		    		self["circleLayer"]:addChild(chatSpr)
		    		self:_setMainLayerPos(-display.width - display.designLeft)
		    	end
		    else  --其他人
		    	chatSpr:setFlipX(true)
		    	if player.rank > 4 then --在地下
		    		chatSpr:setPosition(self._enemyBeginX + addPos * 150 + self._treeLayerOffsetX, 120)
		    		self["treeLayer"]:addChild(chatSpr)
		    		if myRank then
			    		if myRank < player.rank then
			    			chatSpr:setVisible(false)
			    		end
			    	end
			    	
			    	--显示名次
		    		local flagSpr = display.newSprite("#ccb/wulingbang/ranking.png")
		    		flagSpr:setPosition(spriteSize.width/2 - 20, spriteSize.height/2 + 100)
		    		local BmpNumberLabel = require("ui.BmpNumberLabel")
					local lab = BmpNumberLabel.new()
					lab:setPosition(spriteSize.width/2 + 20, spriteSize.height/2 + 100)
					lab:setBmpPathFormat("ccb/number/%d.png")
					lab:setValue(player.rank)
					chatSpr:addChild(lab)
					chatSpr:addChild(flagSpr)
					
					addPos = addPos + 1
					self._heroTable[#self._heroTable + 1] = chatSpr
		    	else
		    		local rankSpr
		    		if player.rank == 1 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/one.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 160, 460)
		    		elseif player.rank == 2 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/two.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 225, 260)
		    		elseif player.rank == 3 then
		    			rankSpr = display.newSprite("#ccb/wulingbang/three.png")
			    		chatSpr:addChild(rankSpr)
		    			chatSpr:setPosition(display.width * 2 - 330, 130)
		    		elseif player.rank == 4 then
		    			--显示名次
			    		local flagSpr = display.newSprite("#ccb/wulingbang/ranking.png")
			    		flagSpr:setPosition(spriteSize.width/2 - 20, spriteSize.height/2 + 100)
			    		local BmpNumberLabel = require("ui.BmpNumberLabel")
						local lab = BmpNumberLabel.new()
						lab:setPosition(spriteSize.width/2 + 20, spriteSize.height/2 + 100)
						lab:setBmpPathFormat("ccb/number/%d.png")
						lab:setValue(player.rank)
						chatSpr:addChild(lab)
		    			chatSpr:addChild(flagSpr)
		    			chatSpr:setPosition(display.width * 2 - 525, 90)
		    		end
		    		if rankSpr then
		    			rankSpr:setPosition(spriteSize.width/2, spriteSize.height/2 + 110)
		    		end
		    		self._before3RankTable[#self._before3RankTable + 1] = chatSpr
		    		self["circleLayer"]:addChild(chatSpr)
		    	end
		    end
		    --显示名字
			local ui = require("framework.client.ui")
	        local nameText = ui.newTTFLabelWithShadow(
	            {   
	                text = player.name,
	                size = 14,
	                align = ui.TEXT_ALIGN_CENTER,
	            }
	        )
	        nameText:setPosition(spriteSize.width/2, spriteSize.height/2 + 72)-- - 342 - 20)
			chatSpr.nameText = nameText
	        chatSpr:addChild(nameText)
	    end
	end
	
--	dump(self._heroTable)
end

---
-- 屏幕点击，是否选中玩家
-- @function [parent=#WuLinBangView] _isClickPlayer
-- @param #number x
-- @param #number y
-- @return #table
-- 
function WuLinBangView:_isClickPlayer(x, y)
	if self._isPlayAnim == true then return nil end

	local display = require("framework.client.display")
	local clickPoint = ccp(x, y)
	
	--优先搜索前三名
	for i = 1, #self._before3RankTable do
		local player = self._before3RankTable[i]
		local x = player:getPositionX()
		local y = player:getPositionY()
		x = x - 45 + display.designLeft
		y = y - 70
		local width = 90
		local height = 140
		local clickRect = CCRect(x, y, width, height)
		if clickRect:containsPoint(clickPoint) then
			self:setTarget(player)
			return player
		end
	end
	
	clickPoint.x = x + self._treeLayerOffsetX
	for i = 1, #self._heroTable do
		local player = self._heroTable[i]
		local x = player:getPositionX()
		local y = player:getPositionY()
		x = x - 45 + display.designLeft
		y = y - 70
		local width = 90
		local height = 140
		local clickRect = CCRect(x, y, width, height)
		if clickRect:containsPoint(clickPoint) then
			self:setTarget(player)
			return player
		end
	end
	return nil
end

---
-- 玩家移动到指定位置
-- @function [parent=#WuLinBangView] _playerToPos
-- @param #number x
-- @param #number y
-- @param #function func
-- 
function WuLinBangView:_playerToPos(x, y, func)
	if self._mySprite == nil then return end

	local spriteAction = require("utils.SpriteAction")
	local transition = require("framework.client.transition")
	
	transition.moveTo(self._mySprite,
		{	
			time = 0.2,
			x = x,
			y = y,
			onComplete = function ()
				if func then
					func()
				end
			end		
		}
	)
end

---
-- 玩家胜利动作
-- @function [parent=#WuLinBangView] _playerWinAnim
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_playerWinAnim(x, y)
	local spriteAction = require("utils.SpriteAction")
	
	local func = function ()
		-- 播放攻击动作
		self._mySprite:stopAllActions()
		spriteAction.spriteRunOnceAction(self._mySprite, self._mySprite._playerMsg.photo.."/attack1/7/1000%d.png", 0, 4,
			function ()
				self._mySprite.stopAllActions()
				self:_targetIsHit(self._targetSprite)
				--改变状态为站立态
				spriteAction.spriteRunForeverAction(self._mySprite, self._mySprite._playerMsg.photo.."/idle2/7/1000%d.png", 0, 4)
				
				local scheduler = require("framework.client.scheduler")
				if self._cleanSprSche == nil then
					self._cleanSprSche = scheduler.performWithDelayGlobal(
						function ()
							self._cleanSprSche = nil
							--清除敌人信息
							for i = 1, #self._heroTable do
								self._heroTable[i]:removeFromParentAndCleanup(true)
								self._heroTable[i] = nil
							end
							self._heroTable = {}
								
							for i = 1, #self._before3RankTable do
								self._before3RankTable[i]:removeFromParentAndCleanup(true)
								self._before3RankTable[i] = nil
							end
							self._before3RankTable = {}
							self._mySprite = nil
							--滚树图层
							self:_scrollTreeLayer(self._myselfOffsetX)
							self:_scrollTaLayer(self._myselfOffsetX/2)
							
							--显示敌人
							self:showPlayers(self._delayDealMsg)
							
							self._isPlayAnim = false
						end,
						0.6
					)
				end
			end,
			0.1
		)
	end
	
	self:_playerToPos(x, y, func)
end

---
-- 玩家失败动作
-- @function [parent=#WuLinBangView] _playerFailAnim
-- @param #number x
-- @param #number y
-- 
function WuLinBangView:_playerFailAnim(x, y)
	local spriteAction = require("utils.SpriteAction")
	
	local beforeX = self._mySprite:getPositionX()
	local beforeY = self._mySprite:getPositionY()
	
	local func = function ()
		-- 播放攻击动作
		self._mySprite:stopAllActions()
		spriteAction.spriteRunOnceAction(self._mySprite, self._mySprite._playerMsg.photo.."/attack1/7/1000%d.png", 0, 4,
			function ()
				self._mySprite.stopAllActions()
				self:_targetIsHit(self._targetSprite)
				--改变状态为站立态
				spriteAction.spriteRunForeverAction(self._mySprite, self._mySprite._playerMsg.photo.."/idle2/7/1000%d.png", 0, 4)
				
				local scheduler = require("framework.client.scheduler")
				if self._cleanSprSche == nil then
					self._cleanSprSche = scheduler.performWithDelayGlobal(
						function ()
							self._cleanSprSche = nil
							--回去
							local transition = require("framework.client.transition")
							transition.moveTo(self._mySprite,
								{	
									time = 0.5,
									x = beforeX,
									y = beforeY,
									onComplete = function ()
										self._isPlayAnim = false
									end		
								}
							)
						end,
						0.6
					)
				end
			end,
			0.1
		)
	end
	
	self:_playerToPos(x, y, func)
end

---
-- 更新挑战次数
-- @function [parent=#WuLinBangView] updateChallengeCnt
-- @param self
-- @param #number cnt
-- @param #boolean can
-- @param #number needYB
-- 
function WuLinBangView:updateChallengeCnt( cnt, can, needYB )
	--self["timeLab"]:setString(tr("可挑战次数<c1>") .. cnt .. tr("次"))
	self["leftCntLab"]:setString(cnt)
	self._canBuyCnt = can
	self._needYB = needYB
	self._challengeCnt = cnt
end

---
-- 获取剩余挑战次数
-- @function [parent=#WuLinBangView] getChallengeCnt
-- @return #number
-- 
function WuLinBangView:getChallengeCnt()
	return self._challengeCnt
end

---
-- 显示胜利动作
-- @function [parent=#WuLinBangView] showWinPlayerAnim
-- @param self
-- 
function WuLinBangView:showWinPlayerAnim()
	--dump(self._targetSprite)
	self._isPlayAnim = true
	if  self._mySprite._playerMsg.rank <= 5 then
		if self._delayDealMsg then
			--清除敌人信息
			for i = 1, #self._heroTable do
				self._heroTable[i]:removeFromParentAndCleanup(true)
				self._heroTable[i] = nil
			end
			self._heroTable = {}
				
			for i = 1, #self._before3RankTable do
				self._before3RankTable[i]:removeFromParentAndCleanup(true)
				self._before3RankTable[i] = nil
			end
			self._before3RankTable = {}
			self._mySprite = nil
			
			--显示敌人
			self:showPlayers(self._delayDealMsg)
		end
		self._isPlayAnim = false
		return 
	end
	
	local x 
	local y
	if self._targetSprite._playerMsg.rank > 4 then
		x = self._targetSprite:getPositionX() - 70
		y = self._targetSprite:getPositionY()
	else
		x = self._mySprite:getPositionX()
		y = self._mySprite:getPositionY()
	end	
	
	self._myselfOffsetX = self._mySprite:getPositionX() - x
	self:_playerWinAnim(x, y)
end

---
-- 失败后动作
-- @function [parent=#WuLinBangView] showFailPlayerAnim
-- @param self
-- 
function WuLinBangView:showFailPlayerAnim()
	--dump(self._targetSprite)
	self._isPlayAnim = true
	if  self._mySprite._playerMsg.rank <= 4 then
		self._isPlayAnim = false
		return 
	end
	
	local x 
	local y
	if self._targetSprite._playerMsg.rank > 4 then
		x = self._targetSprite:getPositionX() - 70
		y = self._targetSprite:getPositionY()
	else
		x = self._mySprite:getPositionX()
		y = self._mySprite:getPositionY()
	end
	
	self:_playerFailAnim(x, y)
end

---
-- 设置目标
-- @function [parent=#WuLinBangView] setTarget
-- @param #CCSprite target
-- 
function WuLinBangView:setTarget(target)
	self._targetSprite = target
end

---
-- 延迟信息处理保存
-- @function [parent=#WuLinBangView] setDelayDealMsg
-- @param #table msg
--  
function WuLinBangView:setDelayDealMsg(msg)
	self._delayDealMsg = msg
--	dump(self._delayDealMsg)
end

---
-- 场景退出回调
-- @function [parent=#WuLinBangView] onExit
--
function WuLinBangView:onExit()
	--printf("wulinbang view on exit")
	for i = 1, #self._heroTable do
		self._heroTable[i]:removeFromParentAndCleanup(true)
	end
	
	for i = 1, #self._before3RankTable do
		self._before3RankTable[i]:removeFromParentAndCleanup(true)
	end
	
	self._before3RankTable = nil
	self._heroTable = nil
	self._mySprite = nil
	self._playerMsgView:setVisible(false)
	self._myselfMsgView:setVisible(false)
	
	local scheduler = require("framework.client.scheduler")
	if self._timeHandle then
		scheduler.unscheduleGlobal(self._timeHandle)
		self._timeHandle = nil
	end
	
	if self._cleanSprSche then
		scheduler.unscheduleGlobal(self._cleanSprSche)
		self._cleanSprSche = nil
	end
	
	require("view.wulinbang.WuLinBangView").instance = nil
	WuLinBangView.super.onExit(self)
end

---
-- 滚动树的图层
-- @function [parent=#WuLinBangView] _scrollTreeLayer
-- @param #number x
-- 
function WuLinBangView:_scrollTreeLayer(x)
	self._treeLayerOffsetX = self._treeLayerOffsetX - x
	self._treeLayerSliderAdd = self._treeLayerSliderAdd - x
	
	local toX = self["treeLayer"]:getPositionX() + x
	local toY = self["treeLayer"]:getPositionY()
	
	local transition = require("framework.client.transition")
	transition.moveTo(self["treeLayer"],
		{
			x = toX,
			y = toY,
			time = 0.5,
			onComplete = function ()
				local treeSpriteTb = self._treeSpriteTable
				if treeSpriteTb[1] then
					local treeSpriteWidth = treeSpriteTb[1]:getContentSize().width
					if self._treeLayerSliderAdd > treeSpriteWidth then
						--printf(tr("切换树背景图"))
						self._treeLayerSliderAdd = self._treeLayerSliderAdd - treeSpriteWidth
						if #treeSpriteTb > 1 then
							local first = treeSpriteTb[1]
							for i = 2, #treeSpriteTb do
								treeSpriteTb[i - 1] = treeSpriteTb[i]
							end
							first:setPositionX(first:getPositionX() + #treeSpriteTb*treeSpriteWidth)
							treeSpriteTb[#treeSpriteTb] = first
						end	
					end
				end
			end
		}
	)
	
end

---
-- 塔背景滚动
-- @function [parent=#WuLinBangView] _scrollTaLayer
-- 
function WuLinBangView:_scrollTaLayer(x)
	self._taLayerSliderAdd = self._taLayerSliderAdd - x
	
	local toX = self["taLayer"]:getPositionX() + x
	local toY = self["taLayer"]:getPositionY()
	
	local transition = require("framework.client.transition")
	transition.moveTo(self["taLayer"],
		{
			x = toX,
			y = toY,
			time = 0.5,
			onComplete = function ()
				local taSpriteTb = self._taSpriteTable
				if taSpriteTb[1] then
					local taSpriteWidth = taSpriteTb[1]:getContentSize().width
					if self._taLayerSliderAdd > taSpriteWidth then
						--printf(tr("切换塔背景图"))
						self._taLayerSliderAdd = self._taLayerSliderAdd - taSpriteWidth
						if #taSpriteTb > 1 then
							local first = taSpriteTb[1]
							for i = 2, #taSpriteTb do
								taSpriteTb[i - 1] = taSpriteTb[i]
							end
							first:setPositionX(first:getPositionX() + #taSpriteTb*taSpriteWidth)
							taSpriteTb[#taSpriteTb] = first
						end	
					end
				end
			end
		}
	)
	
end

---
-- 点击了特定监控的UI 
-- @function [parent=#WuLinBangView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function WuLinBangView:uiClkHandler(ui, rect)
	if ui == self["hitRewardSpr"] then
		if self._endTime <= 0 then
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_wulin_bonus", {index = 1})
			self["sunSpr"]:setVisible(false)
		end
	end
end

---
-- 获取区间值
-- @function [parent = #WuLinBangView] _clamp
-- @param #number num 输入数字
-- @param #number min 最小值
-- @param #number max 最大值
-- 
function WuLinBangView:_clamp(num, min, max)
	if num < min then
		return min
	elseif num > max then
		return max
	else
		return num
	end
end

---
-- 主图层滚动
-- @function [parent = #WuLinBangView] _setMainLayerPos
-- @param #number x
--  
function WuLinBangView:_setMainLayerPos(x)
	self["allLayer"]:setPositionX(x)
end

---
-- 目标受击动作
-- @function [parent = #WuLinBangView] _targetIsHit
-- @param #CCSprite target
-- 
function WuLinBangView:_targetIsHit(target)
	local spriteAction = require("utils.SpriteAction")
	spriteAction.shakeSprite(target, 8)
	
	local transition = require("framework.client.transition")
	transition.tintTo(target, 
		{
			r = 255,
			g = 0,
			b = 0,
			time = 0.2,
			onComplete = function()
				transition.tintTo(target,
					{
						time = 0.6,
						r = 255, 
						g = 255, 
						b = 255
					}
				)
			end
		}
	)		
end









