---
-- 九转通玄界面
-- @module view.jiuzhuan.JiuZhuanView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local transition = transition
local display = display
local ccc3 = ccc3
local CCDelayTime = CCDelayTime
local CCRotateTo = CCRotateTo
local CCScaleTo = CCScaleTo
local CCMoveTo = CCMoveTo
local CCCallFunc = CCCallFunc
local ccp = ccp
local table = table
local pairs = pairs
local ui = ui
local dump = dump


local moduleName = "view.jiuzhuan.JiuZhuanView"
module(moduleName)

---
-- 类定义
-- @type JiuZhuanView
-- 
local JiuZhuanView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 玩家的拥有的银两数量
-- @field [parent=#JiuZhuanView] #number _cash
-- 
JiuZhuanView._cash = nil

---
-- 玩家的拥有的元宝数量
-- @field [parent=#JiuZhuanView] #number _yuanBao
-- 
JiuZhuanView._yuanBao = nil

---
-- 玩家的拥有的元宝数量
-- @field [parent=#JiuZhuanView] #number _grade
-- 
JiuZhuanView._grade = nil

---
-- 玩家修炼进度
-- @field [parent=#JiuZhuanView] #number _progress
-- 
JiuZhuanView._progress = nil

---
-- 通玄结果动画handle
-- @field [parent=#JiuZhuanView] #handle _handle
-- 
JiuZhuanView._handle = nil

---
-- 倒计时handle
-- @field [parent=#JiuZhuanView] #handle _timeHandler
-- 
JiuZhuanView._timeHandler = nil

---
-- 真气升级按钮扫光特效
-- @field [parent=#JiuZhuanView] #CCSprite _streamer
-- 
JiuZhuanView._streamer = nil

---
-- 能否进行修炼/九转
-- @field [parent=#JiuZhuanView] #boolean _canXiuLian
-- 
JiuZhuanView._canXiuLian = true

---
-- 消耗信息
-- @field [parent=#JiuZhuanView] #table _costInfo
-- 
JiuZhuanView._costInfo = nil


---
-- 构造函数
-- @function [parent=#JiuZhuanView] ctor
-- @param self
-- 
function JiuZhuanView:ctor()
	JiuZhuanView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#JiuZhuanView] _create
-- @param self
-- 
function JiuZhuanView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jiuzhuan/ui_jiuzhuan_1.ccbi", true)
	
	self:handleButtonEvent("upgradeBtn", self._upgradeClkHandler)
	self:handleButtonEvent("xiulianBtn", self._xiulianClkHandler)
	self:handleButtonEvent("jiuzhuanBtn", self._jiuzhuanClkHandler)
	self:handleButtonEvent("tongxuanBtn", self._tongxuanClkHandler)
	
	local HeroAttr = require("model.HeroAttr")
	if( HeroAttr.Id ) then
		self:_showHeroAttr(HeroAttr)
	else
		self:_showHeroAttr(nil)
	end
	
	self["timeLab"]:setVisible(false)
	self["timeText"] = ui.newTTFLabelWithShadow(
					{
						size = 22,
						align = ui.TEXT_ALIGN_CENTER,
						x = 477,
						y = 223,
					}
				 )
	self["timeText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["timeText"])
	self["timeText"]:setVisible(false)
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	self._handlerTbl = {}
	self._resultTbl = {}
	self:_playEffect()
end

---
-- 设置描边文字
-- @function [parent=#JiuZhuanView] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function JiuZhuanView:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 点击了真气升级
-- @function [parent=#JiuZhuanView] _upgradeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function JiuZhuanView:_upgradeClkHandler(sender,event)
	if( not self.owner or not self.owner.owner ) then return end
	
	local view = self.owner.owner
	view:setSelectedIndex(2)
end

---
-- 点击了修炼
-- @function [parent=#JiuZhuanView] _xiulianClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function JiuZhuanView:_xiulianClkHandler(sender,event)
	if not self._costInfo then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local ZhenQiData = require("model.ZhenQiData")
	local zhenQiNum = ZhenQiData.getZhenQiNum()
	if self._grade*5 - zhenQiNum < 1 then
		FloatNotify.show(tr("真气背包空余位置不足"))
		return
	end
	
	if self._cash < self._costInfo.jz_cash then
		FloatNotify.show(tr("剩余银两不足"))
		return
	end
	
	if not self._canXiuLian then
		FloatNotify.show(tr("修炼太频繁容易伤及本元，请先休息一会"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_jiuzhuan", {place_holder=1})
end

---
-- 点击了九转
-- @function [parent=#JiuZhuanView] _jiuzhuanClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function JiuZhuanView:_jiuzhuanClkHandler(sender,event)
	if not self._costInfo then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local ZhenQiData = require("model.ZhenQiData")
	local zhenQiNum = ZhenQiData.getZhenQiNum()
	if self._grade*5 - zhenQiNum < 10 then
		FloatNotify.show(tr("真气背包空余位置不足"))
		return
	end
	
	if self._cash < self._costInfo.jz_cash*10 then
		FloatNotify.show(tr("剩余银两不足"))
		return
	end
	
	if not self._canXiuLian then
		FloatNotify.show(tr("修炼太频繁容易伤及本元，请先休息一会"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_jiuzhuan", {place_holder=2})
end

---
-- 点击了通玄
-- @function [parent=#JiuZhuanView] _tongxuanClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function JiuZhuanView:_tongxuanClkHandler(sender,event)
	if not self._costInfo then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local ZhenQiData = require("model.ZhenQiData")
	local zhenQiNum = ZhenQiData.getZhenQiNum()
	if( self._grade*5 - zhenQiNum >= 1 ) then
		if( self._yuanBao >= self._costInfo.tx_yuanbao ) then
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_zhenqi_tongxuan", {place_holder=1})
		else
			FloatNotify.show(tr("剩余元宝不足"))
		end
	else
		FloatNotify.show(tr("真气背包空余位置不足"))
	end
end

---
-- 角色属性更新
-- @function [parent=#JiuZhuanView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function JiuZhuanView:_attrsUpdatedHandler( event )
	self:_showHeroAttr(event.attrs)
end

---
-- 显示角色属性
-- @function [parent=#JiuZhuanView] _showHeroAttr
-- @param self
-- @param model#HeroAttr attrTbl key-value的属性对,nil表示显示默认值
-- 
function JiuZhuanView:_showHeroAttr( attrTbl )
	-- 没有值
	if( not attrTbl ) then
		for i=2, 9 do
			self["statusSpr"..i]:setVisible(false)
		end
		return
	end
	
	local NumberUtil = require("utils.NumberUtil")
	if( attrTbl.YuanBao ) then
		self._yuanBao = attrTbl.YuanBao
	end
	
	if( attrTbl.Cash ) then
		self._cash = attrTbl.Cash
	end
	
	if( attrTbl.Grade ) then
		self._grade = attrTbl.Grade
	end
	
	if( attrTbl.ZhenqiProgress ) then
		self._progress = attrTbl.ZhenqiProgress
		for i=1, 9 do
			if( i<=attrTbl.ZhenqiProgress ) then
				self["statusSpr"..i]:setVisible(true)
			else
				self["statusSpr"..i]:setVisible(false)
			end
		end
	end
end

---
-- 显示修炼结果
-- @function [parent=#JiuZhuanView] showXiuLianResult
-- @param self
-- @param #table info 修炼结果信息
-- 
function JiuZhuanView:showXiuLianResult(info)
	if not self._costInfo then return end
	
	self._resultTbl[#self._resultTbl+1] = info
	self:_showResult()
	--[[
	if( info.jztx_result == 1 ) then
--		self:_playFly(info)
		self._resultTbl[#self._resultTbl+1] = info
		self:_showResult()
	else
		if not self._costInfo then return end
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("糟糕，走火入魔！返还您"..self._costInfo.jz_cash/2 .."银两！"))
	end
	--]]
end

---
-- 显示修炼结果
-- @function [parent=#JiuZhuanView] _showResult
-- @param self
-- 
function JiuZhuanView:_showResult()
	if #self._resultTbl < 1 then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local scheduler = require("framework.client.scheduler")
	if( self._delayHandler ) then
		scheduler.unscheduleGlobal(self._delayHandler)
		self._delayHandler = nil
	end
	-- 处理函数
	local func = function()
		if( self._flyHandler ) then
			scheduler.unscheduleGlobal(self._flyHandler)
			self._flyHandler = nil
		end
		
		local i = 1 --播放动画次数
		local info
		local playEffect = function()
			info = self._resultTbl[i]
			if not info then return end
			
			if( info.jztx_result == 1 ) then
				self:_playFly(info)
			else
				FloatNotify.show(tr("糟糕，走火入魔！返还您"..self._costInfo.jz_cash/2 .."银两！"))
			end
			
			i = i + 1
			if( i > #self._resultTbl ) then
				scheduler.unscheduleGlobal(self._flyHandler)
				self._flyHandler = nil
				self._resultTbl = {}
				return
			end
		end
		self._flyHandler = scheduler.scheduleGlobal(playEffect, 0.05)
		
		if( self._delayHandler ) then
			scheduler.unscheduleGlobal(self._delayHandler)
			self._delayHandler = nil
		end
	end
	self._delayHandler = scheduler.scheduleGlobal(func, 0.2)
end

---
-- 显示通玄结果
-- @function [parent=#JiuZhuanView] showTongXuanResult
-- @param self
-- @param #table info 通玄结果信息
-- 
function JiuZhuanView:showTongXuanResult(info)
	local p = self._progress
	local num = 0 --播放动画次数
	local scheduler = require("framework.client.scheduler")
	if( self._handle ) then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	-- 处理函数
	local func = function()
		for i=1, 9 do
			if( i<=p ) then
				self["statusSpr"..i]:setVisible(true)
			else
				self["statusSpr"..i]:setVisible(false)
			end
		end
			
		if( p==9 ) then
			p = 1
		else
			p = p + 1
		end
		
		num = num + 1
		if( num == 10) then
			scheduler.unscheduleGlobal(self._handle)
			self._handle = nil
			return
		end
	end
	
	self._handle = scheduler.scheduleGlobal(func, 0.2)	
	-- 播放真气飞行动画
	self:_playFly(info)
end

---
-- 播放特效动画
-- @function [parent=#JiuZhuanView] _playEffect
-- @param self
-- 
function JiuZhuanView:_playEffect()
	local frames
	local animation
	-- 火焰特效
	display.addSpriteFramesWithFile("res/ui/effect/jiuzhuan_flame.plist", "res/ui/effect/jiuzhuan_flame.png")
	frames = display.newFrames("jiuzhuan_flame/100%02d.png", 0, 12)
	animation = display.newAnimation(frames, 1/4)
	self["flameSpr"]:setFlipX(true)
	self["flameSpr"]:setOpacity(204)
	self["flameSpr"]:setScaleX(2)
	self["flameSpr"]:setScaleY(2)
	transition.playAnimationForever(self["flameSpr"], animation)
	
	-- 颗粒特效
	display.addSpriteFramesWithFile("res/ui/effect/jiuzhuan_particle.plist", "res/ui/effect/jiuzhuan_particle.png")
	frames = display.newFrames("jiuzhuan_particle/100%02d.png", 0, 12)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self["xiulianSpr"], animation)
	
	display.addSpriteFramesWithFile("res/ui/effect/jiuzhuan_particle3.plist", "res/ui/effect/jiuzhuan_particle3.png")
	frames = display.newFrames("jiuzhuan_particle3/100%02d.png", 0, 12)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self["jiuzhuanSpr"], animation)
	
	display.addSpriteFramesWithFile("res/ui/effect/jiuzhuan_particle2.plist", "res/ui/effect/jiuzhuan_particle2.png")
	frames = display.newFrames("jiuzhuan_particle2/100%02d.png", 0, 12)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self["tongxuanSpr"], animation)
	
	-- 升级真气扫光特效
	self._streamer = display.newSprite()
	self:addChild(self._streamer) 
	self._streamer:setPositionX(453)
	self._streamer:setPositionY(316)
	display.addSpriteFramesWithFile("res/ui/effect/jiuzhuan_streamer.plist", "res/ui/effect/jiuzhuan_streamer.png")
	frames = display.newFrames("jiuzhuan_streamer/1000%0d.png", 0, 8)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._streamer, animation)
	
	-- 创建三个按钮上的星星
	for i=1, 4 do
		for j=1, 3 do
			self:_makeStar(i, j)
		end
	end
end

---
-- 退出场景后自动调用
-- @function [parent=#JiuZhuanView] onExit
-- @param self
-- 
function JiuZhuanView:onExit()
	self["flameSpr"]:stopAllActions()
	self["xiulianSpr"]:stopAllActions()
	self["jiuzhuanSpr"]:stopAllActions()
	self["tongxuanSpr"]:stopAllActions()
	self._streamer:stopAllActions()
	
	local scheduler = require("framework.client.scheduler")
	for i = 1, #self._handlerTbl do
		scheduler.unscheduleGlobal(self._handlerTbl[i])
	end
	
	if( self._handle ) then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	if( self._timeHandler ) then
		scheduler.unscheduleGlobal(self._timeHandler)
		self._timeHandler = nil
	end
	
	if( self._flyHandler ) then
		scheduler.unscheduleGlobal(self._flyHandler)
		self._flyHandler = nil
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	JiuZhuanView.super.onExit(self)
end

---
-- 创建星星
-- @function [parent=#JiuZhuanView] _makeStar
-- @param #number m 第几个星星
-- @param #number m 第几个按钮
-- 
function JiuZhuanView:_makeStar(m, n)
	local starSpr = display.newSprite("res/ui/effect/jiuzhuan_star.png")
	if( m == 1 ) then
		starSpr:setPositionX(240 + (n-1)*195)
		starSpr:setPositionY(130)
	elseif( m == 2 ) then
		starSpr:setPositionX(275 + (n-1)*195)
		starSpr:setPositionY(160)
	elseif( m == 3 ) then
		starSpr:setPositionX(275 + (n-1)*195)
		starSpr:setPositionY(110)
	elseif( m == 4 ) then
		starSpr:setPositionX(315 + (n-1)*195)
		starSpr:setPositionY(135)
	end
	self:addChild(starSpr)
	self:_playStarEffect(starSpr)
end

---
-- 播放星星特效
-- @function [parent=#JiuZhuanView] _playStarEffect
-- @param #CCSprite spr 
-- 
function JiuZhuanView:_playStarEffect(spr)
	spr:setScaleX(0.01)
	spr:setScaleY(0.01)
	local action1 = transition.sequence({CCDelayTime:create(1.0),CCRotateTo:create(1, 180),})
	local action2 = transition.sequence({CCDelayTime:create(1.0),CCScaleTo:create(1, 1, 1),})
	local args2 = {}
	args2.onComplete = function()
		spr:setScaleX(0.01)
		spr:setScaleY(0.01)
	end
	
	local args1 = {}
	args1.onComplete = function() 
		spr:setVisible(false)
		spr:setRotation(0)
		local scheduler = require("framework.client.scheduler")
		local endFunc = function()
					if( not self:getProxy() ) then return end
					if( not self or not spr ) then return end
					local action3 = transition.sequence({CCRotateTo:create(1, 180),})
					local action4 = transition.sequence({CCScaleTo:create(1, 1, 1),})
					spr:setVisible(true)
					transition.execute(spr, action3, args1)
					transition.execute(spr, action4, args2)
				end
		
		local handle = scheduler.performWithDelayGlobal(endFunc, 1)
		self._handlerTbl[#self._handlerTbl+1] = handle
	end
	
	spr:setVisible(true)
	transition.execute(spr, action1, args1)
	transition.execute(spr, action2, args2)
end

---
-- 播放获得真气后，真气飞行特效
-- @function [parent=#JiuZhuanView] _playFly
-- @param self
-- @param #table info 真气信息
-- 
function JiuZhuanView:_playFly(info)
	display.addSpriteFramesWithFile("res/ui/effect/"..info.zhenqi_icon..".plist", "res/ui/effect/"..info.zhenqi_icon..".png")
	local newZhenQi = display.newSprite()
	local ImageUtil = require("utils.ImageUtil")
	newZhenQi:setDisplayFrame(ImageUtil.getFrame(info.zhenqi_icon.."/10000.png"))
	newZhenQi:setPosition(480, 300)
	self:changeSpriteHsb(newZhenQi, info.Effect_H, info.Effect_S, info.Effect_B)
	self:addChild(newZhenQi)
	
	local onComplete = function()
		self:removeChild(newZhenQi, true)
		newZhenQi = nil
	end
	
	local action1 = transition.sequence({
		CCMoveTo:create(1, ccp(828, 474)),
		CCCallFunc:create(onComplete),
	})
	
	local action2 = transition.sequence({
		CCScaleTo:create(1, 0.5, 0.5)
	})
	
	newZhenQi:setAnchorPoint(ccp(0.5, 0.5)) -- 设置锚点
	newZhenQi:runAction(action1)
	newZhenQi:runAction(action2)
end

---
-- 打开界面，请求冷却时间信息
-- @function [parent=#JiuZhuanView] openUi
-- @param self
-- 
function JiuZhuanView:openUi()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_jztime", {place_holder = 1})
	GameNet.send("C2s_zhenqi_need", {place_holder = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示冷却时间信息
-- @function [parent=#JiuZhuanView] showTime
-- @param self
-- @param #table info 
-- 
function JiuZhuanView:showTime(info)
	if info.isok == 1 then
		self._canXiuLian = true
	else
		self._canXiuLian = false
	end
	
	local scheduler = require("framework.client.scheduler")
	local NumberUtil = require("utils.NumberUtil")
	if( self._timeHandler ) then
		scheduler.unscheduleGlobal(self._timeHandler)
		self._timeHandler = nil
	end
	
	if( info.time > 0 ) then
		self._overTime = info.time
		local func = function()
			if not self._overTime then return end
			
			self._overTime = self._overTime - 1
			if(self._overTime <= 0 ) then
				scheduler.unscheduleGlobal(self._timeHandler)
				self._timeHandler = nil
				
				self._canXiuLian = true
				self["timeText"]:setVisible(false)
				return
			end
			local overTime = NumberUtil.secondToDate(self._overTime)
			self["timeText"]:setString(tr("回气 "..overTime))
			self["timeText"]:setVisible(true)
		end
		
		self._timeHandler = scheduler.scheduleGlobal(func, 1)
	else
		self["timeText"]:setVisible(false)
	end
end

---
-- 设置基本消耗信息
-- @function [parent=#JiuZhuanView] setCostInfo
-- @param self
-- @param #table info 
-- 
function JiuZhuanView:setCostInfo(info)
	self._costInfo = info
--	dump(info)
end

