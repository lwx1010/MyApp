---
-- 加载Fight的CCB文件
-- @module view.fight.FightCCBView
--

local class = class
local display = display
local ui = ui
local require = require
local transition = transition
local ccp = ccp
local math = math
local tr = tr

local CCProgressTimer = CCProgressTimer  
local kCCProgressTimerTypeBar = kCCProgressTimerTypeBar
local CCGLProgram = CCGLProgram
local CCControlStateDisabled = CCControlStateDisabled
local CCControlStateNormal = CCControlStateNormal

local assert = assert
local printf = printf
local dump = dump
local CCLuaLog = CCLuaLog

local ccc3 = ccc3
local CCSize = CCSize
local CCRect = CCRect
local tolua = tolua

local moduleName = "view.fight.FightCCBView"
module(moduleName)

---
-- 类定义
-- @type FightCCBView
-- 
local FightCCBView = class(moduleName, require("ui.CCBView").CCBView)

---
-- player UI  减血减到的值
-- @field [parent = #view.fight.FightCCBView] #number _playerUIEndValue
-- 
local _playerUIEndValue

---
-- player UI 动态减血回调句柄
-- @field [parent = #view.fight.FightCCBView] #scheduler _schePlayerUI 
-- 
local _schePlayerUI

---
-- enemy UI 减血减到的值
-- @field [parent = #view.fight.FightCCBView] #number _scheEnemyUI
-- 
local _enemyUIEndValue

---
-- enmey UI 动态减血回调句柄
-- @field [parent = #view.fight.FightCCBView] #scheduler _scheEnemyUI
-- 
local _scheEnemyUI

---
-- 保存玩家人物触控区域以及信息
-- @field [parent = #view.fight.FightCCBView] #table _playerTouchTable
-- 
local _playerTouchTable = {}

---
-- 保存敌人触控区域以及信息
-- @field [parent = #view.fight.FightCCBView] #table _enemyTouchTable
-- 
local _enemyTouchTable = {}

---
-- 判断协议是否接收完
-- @field [parent = #view.fight.FightCCBView] #bool _isFinishProto
-- 
local _isFinishProto = false

--- 
-- 保存当前回合数
-- @field [parent = #view.fight.FightCCBView] #number _currBoutNum
-- 
local _currBoutNum = 1

---
-- 判断是否在战斗中
-- @field [parent = #view.fight.FightCCBView] #bool _isInBattale
-- 
local _isInBattale = false

---
-- 是否是第一次战斗
-- @field [parent = #view.fight.FightCCBView] #bool _isFirstBattle
-- 
local _isFirstBattle = false

---
-- 血条渐变到的透明度
-- @field [parent = #view.fight.FightCCBView] #number _opacity
-- 
local _opacity = 130

---
-- 血条渐变的时间
-- @field [parent = #view.fight.FightCCBView] #number _fadeTime
-- 
local _fadeTime = 1

---
-- 血条减少的速率 一个scheduler interval 时段 减少 1
-- @field [parent = #view.fight.FightCCBView] #number _subRate
-- 
local _subRate = 1

---
-- 血条减一次血的时间段
-- @field [parent = #view.fight.FightCCBView] #number _scheInterval
-- 
local _scheInterval = 0

---
-- 一次攻击减血的百分比 玩家血条
-- @field [parent = #view.fight.FightCCBView] #number _lastPlayerHpOffset
-- 
local _lastPlayerHpOffset = 0

---
-- 一次攻击减血的百分比 敌方血条
-- @field [parent = #view.fight.FightCCBView] #number _lastEnemyHpOffset
-- 
local _lastEnemyHpOffset = 0

---
-- 速战速决的Z Order
-- @field [parent = #view.fight.FightCCBView] #number _endFightBtnZOrder
-- 
local _endFightBtnZOrder = 500

---
-- 是否播放过进场动画
-- @field [parent = #FightCCBView] #bool _isPlayEnterAnim
-- 
FightCCBView._isPlayEnterAnim = false

---
-- 上次触摸CPU时间
-- @field [parent = #FightCCBView] #number _lastCPUTime
-- 
FightCCBView._lastCPUTime = nil

---
-- 速战速决按钮可用时间
-- @field [parent = #FightCCBView] #number _endFightBtnEnableTime
-- 
FightCCBView._endFightBtnEnableTime = 5

---
-- 速战速决按钮回调句柄
-- @field [parent = #FightCCBView] #scheduler _endFightBtnSche
-- 
FightCCBView._endFightBtnSche = nil

---
-- 战斗玩家初始化血量
-- @field [parent = #FightCCBView] #number _initPlayerBlood
-- 
FightCCBView._initPlayerBlood = nil

---
-- 战斗敌人初始化血量
-- @field [parent = #FightCCBView] #number _initEnemyBlood
-- 
FightCCBView._initEnemyBlood = nil

---
-- 标记是否重播战斗
-- @field [parent = #FightCCBView] #bool _isReplay
-- 
FightCCBView._isReplay = false

---
-- 标记有没有点击速战速决 
-- @field [parent = #FightCCBView] #bool _isClickFightEndBtn
-- 
FightCCBView._isClickFightEndBtn = false

---
-- 字体描边保存
-- @field [parent = #FightCCBView] #CCLabelTTF _newOutLineLab
-- 
FightCCBView._newOutLineLab = nil

---
-- 速战速决偏移的Y坐标
-- @field [parent = #FightCCBView] #number _QUICK_FIGHT_NODE_OFFSETY
-- 
FightCCBView._QUICK_FIGHT_NODE_OFFSETY = 150

---
-- 标记速战速决按钮的状态 在上面
-- @field [parent = #FightCCBView] #number _END_FIGHT_BTN_UP
-- 
FightCCBView._END_FIGHT_BTN_UP = 1

---
-- 标记速战速决按钮的状态 在下面
-- @field [parent = #FightCCBView] #number _END_FIGHT_BTN_DOWN
--  
FightCCBView._END_FIGHT_BTN_DOWN = 2

---
-- 速战速决按钮当前状态
-- @field [parent = #FightCCBView] #number _endFightBtnCurrState
-- 
FightCCBView._endFightBtnCurrState = FightCCBView._END_FIGHT_BTN_DOWN

---
-- 保存播放的战斗背景音乐
-- @field [parent = #FightCCBView] #number _bgNumMusic
-- 
FightCCBView._bgNumMusic = 1

--- 
-- 构造函数
-- @function [parent = #FightCCBView] ctor
-- @param self
-- 
function FightCCBView:ctor()
	FightCCBView.super.ctor(self)
	self:_create()
end

---
-- 场景进入的时候自动调用，回调
-- @function [parent = #FightCCBView] onEnter
-- @param self
-- 
function FightCCBView:onEnter()
	FightCCBView.super.onEnter(self)
	
	
	-- 隐藏sdk工具栏
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openSdkBar(0)

--	local backSprite = self[""]:getBackgroundSprite()
--	backSprite:setColor(ccc3(100, 100, 100))
	self:setCurrBout(1)
	
	--self:playerBloodAnim()
	self:setEndTheFightBtnEnable(false)
	-- 播放战斗音乐
	self:playBattleMusic()
	
	-- 进入战斗
	_isInBattale = true
	
	-- fightid为负数的不计入神行
	local fightData = require("model.FightData")
	if fightData.FightId < 0 then
		self["shenXingLab"]:setVisible(false)
		self._newOutLineLab:setVisible(false)
		self["endFightBtn"]:setPositionY(self["endFightBtn"]:getPositionY() - 50)
	end
end

---
-- 播放背景音乐
-- @function [parent = #FightCCBView] playBattleMusic
-- 
function FightCCBView:playBattleMusic()
	local audio = require("framework.client.audio")
	if self._isReplay == false then
		local bgNum = math.random(1, 4)
		self._bgNumMusic = bgNum
	end
	
	if self._bgNumMusic > 1 then
		audio.playBackgroundMusic("sound/sound_battle"..self._bgNumMusic..".mp3")
	else
		audio.playBackgroundMusic("sound/sound_battle.mp3")
	end
end

---
-- 创建
-- @function [parent = #FightCCBView] _create
-- @param self
-- 
function FightCCBView:_create()
	--加载ccb
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_battle.ccbi")
	
	self:handleButtonEvent("endFightBtn", self._endFightHandler)
	
	--加载数字纹理
	display.addSpriteFramesWithFile("ui/ccb/ccbResources/common/numeric.plist", "ui/ccb/ccbResources/common/numeric.png")
	
	self["huiheNode"]:setVisible(false)
	self["vsSpr"]:setVisible(false)
	self["endFightBtn"]:setVisible(false)
	self["endFightBtn"]:setZOrder(_endFightBtnZOrder)
	
	self:getNode("playerBloodNode"):setVisible(false)
	self:getNode("enemyBloodNode"):setVisible(false)
		
	self["sayS9Spr"]:setVisible(false)
	self["playerPBar"]:setMidpoint(ccp(1,0))
	self["playerAlphaPBar"]:setMidpoint(ccp(1, 0))
	--self["playerAlphaPBar"]:getSprite():setOpacity(110)
	--self["playerAlphaPBar"]:setPosition(self["playerAlphaPBar"]:getPositionX(), self["playerAlphaPBar"]:getPositionY() - 50)
	
	local sprite = self["enemyPBar"]:getSprite()
	sprite:setFlipX(true)
	sprite = self["enemyAlphaPBar"]:getSprite()
	sprite:setFlipX(true)
	--sprite:setOpacity(110)
	
	--self["bgSpr"]:setContentSize()
	--self["bgSpr"]:setTextureRect(CCRect(0, 0, 960, 640))
	--self["bgSpr"]:setPosition(ccp(display.designCx, display.designCy))
	
	--角色信息
	local heroAttr = require("model.HeroAttr")
	self["playerLab"]:setString(heroAttr.Name)
	
	self:setEndTheFightBtnEnable(false)
	
	--self:playerBloodAnim()
	
	--新建一个触摸层
	self._touchLayer = display.newLayer(true)
	self._touchLayer:addTouchEventListener(
		function (...)
			return self:_onBattleTouch(...)
		end
	)
	self._touchLayer:setTouchEnabled(true)
	self:addChild(self._touchLayer)
	
	--添加人物信息
	local charInfo = require("view.fight.FightCharInfo").instance
	self._charInfo = charInfo
	
	local device = require("framework.client.device")
	if device.platform == "windows" then
		self._endFightBtnEnableTime = 1
	else
		self._endFightBtnEnableTime = 5
	end
	
	-- 添加神行信息
	local heroAttr = require("model.HeroAttr")
	self["shenXingLab"]:setString(tr("<c0>消耗<c1>1<c0>点神行可跳过战斗(共<c1>"..heroAttr.ShenXing.."<c0>点)"))
	-- 新建描边字体
	local ui = require("framework.client.ui")
	local newOutLineLab = ui.newTTFLabelWithShadow(
		{
			text = self["shenXingLab"]:getString(),
			size = self["shenXingLab"]:getFontSize(),
			ajustPos = true,
		}
	)
	self["quickFightNode"]:addChild(newOutLineLab)
	newOutLineLab:setPosition(self["shenXingLab"]:getPositionX() - newOutLineLab:getContentSize().width/2,
	self["shenXingLab"]:getPositionY() - 7)
	self._newOutLineLab = newOutLineLab
	self["shenXingLab"]:setVisible(false)
	
	--self["quickFightNode"].sy = self["quickFightNode"]:getPositionY()
	--self["quickFightNode"]:setPositionY(self["quickFightNode"].sy - self._QUICK_FIGHT_NODE_OFFSETY)
end

---
-- 触摸事件
-- @function [parent = #FightCCBView] _onBattleTouch
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function FightCCBView:_onBattleTouch(event, x, y)
	local addNodeTable = {}
	local charTable
--	printf(event)
	if event == "began" or event == "moved" then
--		printf("touch".." x = "..x.." y = "..y)
		if not self._charInfo then
			local charInfo = require("view.fight.FightCharInfo").instance
			self._charInfo = charInfo
			--return false
			if self._charInfo == nil then
				return false
			end
		end
		
		-- 检测CPU时间
		local os = require("os")
		--printf("os.clock() - self._lastCPUTime = "..os.clock() - (self._lastCPUTime or 0))
		if self._lastCPUTime and os.clock() - self._lastCPUTime < 0.3 then
			return false
		else
			self._lastCPUTime = os.clock()
		end
		
		if x <= display.cx then --表示触控在玩家阵营
			charTable = _playerTouchTable
		else
			charTable = _enemyTouchTable
		end
		
		if #charTable <= 0 then
			return true
		end
		
		local worldPt = ccp(x, y)
		for i = 1, #charTable do
			local node = charTable[i].node
			if node then
				local localPt = node:convertToNodeSpace(worldPt)
				local size = node:getContentSize()
				if localPt.x >= 0 and localPt.x < size.width and localPt.y >= 0 and localPt.y < size.height then 
					addNodeTable[#addNodeTable + 1] = {node = node, sprite = charTable[i].sprite}
				end
			end
		end
		
		if #addNodeTable == 0 then  --并无人物触摸
--			printf("no charater")
			self._charInfo:setShow(false)
			return true
		end
		
		--取离人物中点最近的点
		local chooseNode
		local chooseSprite
		if #addNodeTable >= 2 then
			local distance 
			for i = 1, #addNodeTable do
				local node = addNodeTable[i].node
				
				if node == nil then
					return true
				end
				
				local sprite = addNodeTable[i].sprite
				local nx = node:getPositionX()
				local ny = node:getPositionY()
				
				local newDis = (nx - x)*(nx - x) + (ny - y)*(ny - y)
				if distance == nil then
					distance = newDis
					chooseNode = node
					chooseSprite = sprite
				else
					if distance > newDis then
						distance = newDis
						chooseNode = node
						chooseSprite = sprite
					end
				end
			end
		else
			chooseNode = addNodeTable[1].node
			chooseSprite = addNodeTable[1].sprite
		end
		 
		if chooseSprite and chooseSprite.x ~= chooseSprite:getPositionX() and chooseSprite.y ~= chooseSprite:getPositionY() and self._charInfo:isShow() == false then
			return true
		end
		
		--显示node信息
		local msg = {}
		msg.name = chooseSprite.name
		msg.hp = chooseSprite.hp
		msg.hpMax = chooseSprite.hpMax
		msg.attackCount = chooseSprite.attackCount
		msg.defCount = chooseSprite.defCount
		msg.speed = chooseSprite.speed
		msg.wuGong = chooseSprite.wuGong
		msg.grade = chooseSprite.grade
		self._charInfo:setShowMsg(msg)
		self._charInfo:setShow(true)
		
		return true
		
	elseif event == "ended" then
		self._charInfo:setShow(false)
		
		-- 触摸屏幕 速战速决按钮弹起 或者 落下
--		if self._endFightBtnCurrState == self._END_FIGHT_BTN_DOWN then
--			self:endFightBtnAnim(self._END_FIGHT_BTN_UP)
--		else		
--			self:endFightBtnAnim(self._END_FIGHT_BTN_DOWN)
--		end
		
		return false
	end
end

---
-- 设置协议是否接收完毕
-- @function [parent = #FightCCBView] setProtoIsFinish
-- @param #bool finish
-- 
function FightCCBView:setProtoIsFinish(finish)
	_isFinishProto = finish
	--if _currBoutNum > 1 then -- 判断是否是第一回合之后
	if finish == true then
		self:setEndTheFightBtnEnable(true)
	end
	--end
end

---
-- 速战速决 按钮回调事件
-- @function [parent = #FightCCBView] _endFightHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FightCCBView:_endFightHandler(sender, event)
	CCLuaLog("end Fight")
	--dump(self["boutNumLab"])
	
	-- 标记点击了速战速决按钮
	self._isClickFightEndBtn = true
	
	local fightScene = require("view.fight.FightScene")
	self["endFightBtn"]:setEnabled(false)
	fightScene.getFightScene():endTheFight()
end

---
-- 设置显示第几回合
-- @function [parent = #FightCCBView] setCurrBout
-- @param #number boutNum
-- 
function FightCCBView:setCurrBout(boutNum)
	self["boutNumLab"]:setBmpPathFormat("ccb/numeric/%d.png")
	self["boutNumLab"]:setValue(boutNum)
	_currBoutNum = boutNum
	
--	if _currBoutNum > 1 and _isFinishProto == true then
--		self:setEndTheFightBtnEnable(true)
--	end
end

---
-- 清理
-- @function [parent = #FightCCBView] onExit
-- @param self
--
function FightCCBView:onExit()
	local scheduler = require("framework.client.scheduler")
	if _schePlayerUI ~= nil then
		scheduler.unscheduleGlobal(_schePlayerUI)
		_schePlayerUI = nil
	end
	if _scheEnemyUI ~= nil then
		scheduler.unscheduleGlobal(_scheEnemyUI)
		_scheEnemyUI = nil 
	end
	if self._endFightBtnSche then
		scheduler.unscheduleGlobal(self._endFightBtnSche)
		self._endFightBtnSche = nil
	end
		
	self:setEndTheFightBtnEnable(false)
	self:setCurrBout(1)
	
	--self._charInfo:setShow(false)
	self:clearFighterTable()
	
	_isFinishProto = false
	
	_currBoutNum = 1
	
	_isInBattale = false
	
	_isFirstBattle = false
	
	-- 播放正常音乐
	local audio = require("framework.client.audio")
	audio.playBackgroundMusic("sound/bgm.mp3")
	
	--require("view.fight.FightCCBView").instance = nil
	instance = nil
	FightCCBView.super.onExit(self)
end


---
-- 开启或关闭速战速决按钮
-- @function [parent = #FightCCBView] setEndTheFightBtnEnable
-- @param #bool enable
-- @param #number time 延迟时间
-- 
function FightCCBView:setEndTheFightBtnEnable(enable, time)
	
	--fix need del 方便调试
--	_isFirstBattle = false
	
	--判断是否第一次战斗
--	if _isFirstBattle == false then
--		self["endFightBtn"]:setEnabled(enable)
--	else
--		self["endFightBtn"]:setEnabled(false)
--	end

	--神行判断
	local shenXing = require("model.HeroAttr").ShenXing
	if shenXing == nil then
		return
	end
	
	if self._isReplay == false and shenXing < 1 then
		self["endFightBtn"]:setEnabled(false)
		
		if self._endFightBtnSche then
			local scheduler = require("framework.client.scheduler")
			scheduler.unscheduleGlobal(self._endFightBtnSche)
			self._endFightBtnSche = nil
		end
		return
	end
	
	if enable == true and _isFinishProto == true then
		local delayTime = time or self._endFightBtnEnableTime
		printf("delayTime = "..delayTime)
		if self._endFightBtnSche == nil then
			local scheduler = require("framework.client.scheduler")
			self._endFightBtnSche = scheduler.performWithDelayGlobal(
				function ()
					self["endFightBtn"]:setEnabled(true)
					self._endFightBtnSche = nil
				end,
				delayTime
			)
		end
	else
		self["endFightBtn"]:setEnabled(false)
		if self._endFightBtnSche then
			local scheduler = require("framework.client.scheduler")
			scheduler.unscheduleGlobal(self._endFightBtnSche)
			self._endFightBtnSche = nil
		end
	end
end

---
-- 设置UI player血量值
-- @function [parent = #FightCCBView] setPlayersBlood
-- @param #number value  0~100
--  
function FightCCBView:setPlayersBlood(value)
	if value then
		if self._initPlayerBlood == nil then
			self._initPlayerBlood = value
		end
	else
		-- 战斗重播情况
		value = self._initPlayerBlood 
	end
	
	local scheduler = require("framework.client.scheduler")
	
	value = math.floor(value)
	--self["playerHpLab"]:setString(value.."%")
	
	self["playerPBar"]:setPercentage(value)
	_playerUIEndValue = value
	local transition = require("framework.client.transition")
	local sprite = self["playerAlphaPBar"]:getSprite()
	transition.fadeTo(sprite,
		{
			time = _fadeTime,
			opacity = _opacity
		}
	)
	--sprite:setOpacity(110)
	self["playerAlphaPBar"]:setCascadeOpacityEnabled(false)
	local offset = self["playerAlphaPBar"]:getPercentage() - value
	if offset > _lastPlayerHpOffset then
		_lastPlayerHpOffset = offset
	end
	
	if _schePlayerUI == nil then
		 _schePlayerUI = scheduler.scheduleGlobal(
			function ()
				if self["playerAlphaPBar"]:getPercentage() > _playerUIEndValue then
					self["playerAlphaPBar"]:setPercentage(self["playerAlphaPBar"]:getPercentage() - _subRate * _lastPlayerHpOffset/15)
				else
					if _schePlayerUI ~= nil then
						scheduler.unscheduleGlobal(_schePlayerUI)
						self["playerAlphaPBar"]:setPercentage(_playerUIEndValue)
						self["playerAlphaPBar"]:getSprite():setOpacity(255)
						_schePlayerUI = nil
						_lastPlayerHpOffset = 0
					end
				end
			end, 
			_scheInterval
		)
	end
end

---
-- 设置UI enemy血量值
-- @function [parent = #FightCCBView] setEnemysBlood
-- @param #number value  0~100
--  
function FightCCBView:setEnemysBlood(value)
	if value then
		if self._initEnemyBlood == nil then
			self._initEnemyBlood = value
		end
	else
		-- 战斗重播情况
		value = self._initEnemyBlood
	end
	
	local scheduler = require("framework.client.scheduler")

	value = math.floor(value)
	--self["enemyHpLab"]:setString(value.."%")
	self["enemyPBar"]:setPercentage(value)
	
	_enemyUIEndValue = value
	local transition = require("framework.client.transition")
	transition.fadeTo(self["enemyAlphaPBar"]:getSprite(),
		{
			time = _fadeTime,
			opacity = _opacity
		}
	)
	
	local offset = self["enemyAlphaPBar"]:getPercentage() - value
	if offset > _lastEnemyHpOffset then
		_lastEnemyHpOffset = offset
	end
	
	if _scheEnemyUI == nil then
		 _scheEnemyUI = scheduler.scheduleGlobal(
			function ()
				if self["enemyAlphaPBar"]:getPercentage() > _enemyUIEndValue then
					self["enemyAlphaPBar"]:setPercentage(self["enemyAlphaPBar"]:getPercentage() - _subRate * _lastEnemyHpOffset/15)
				else
					if _schePlayerUI ~= nil then
						scheduler.unscheduleGlobal(_scheEnemyUI)
						self["enemyAlphaPBar"]:setPercentage(_enemyUIEndValue)
						self["enemyAlphaPBar"]:getSprite():setOpacity(255)
						_scheEnemyUI = nil
						_lastEnemyHpOffset = 0
					end
				end
			end, 
			_scheInterval
		)
	end
end

---
-- 播放血条动画
-- @function [parent = #FightCCBView] playerBloodAnim
-- 
function FightCCBView:playerBloodAnim()
	self.playerBloodNode = self:getNode("playerBloodNode")
	self.enemyBloodNode = self:getNode("enemyBloodNode")
	self.playerBloodNode:setVisible(true)
	self.enemyBloodNode:setVisible(true)
	
	local effect = "CCEaseElasticInOut"
	transition.moveTo(self.playerBloodNode,
		{
			time = 0.8,
			x = 219 + 15,
			y = 612,
			easing = effect,
		}
	)
	
	transition.moveTo(self.enemyBloodNode,
		{
			time = 0.8,
			x = 732 - 15,
			y = 619,
			easing = effect,
		}
	)
end

---
-- 播放开场动画
-- @function [parent = #FightCCBView] playEnterAnim
-- 
function FightCCBView:playEnterAnim()
	if self._isPlayEnterAnim == false then
		self._isPlayEnterAnim = true
		self["huiheNode"]:setVisible(true)
		self["vsSpr"]:setVisible(true)
		self["endFightBtn"]:setVisible(true)
		
		self:playerBloodAnim()
	end
end

---
-- 获取节点
-- @function [parent = #FightCCBView] getNode
-- @param #string nodeName
-- 
function FightCCBView:getNode(nodeName)
	local proxy = self:getProxy()
	local node = proxy:getNode(nodeName)
	node = tolua.cast(node, "CCNode")
	--dump(playerBloodNode)
	return node
end
	
---
-- 新建一个玩家阵营触摸检测体
-- function [parent = #FightCCBView] createTouchRect 
-- @param #number pos 站位
-- 
function FightCCBView:createPlayerTouchRect(sprite, pos)
	 --站位
    local OffsetX = 95
    local OffsetY = 90
    local RowOffsetX = 50
    local anchorPointOffset = 75   --锚点偏移

    local pos1X = 352
    local pos1Y = 275
    
    local col = math.ceil(pos/3)
    local row = math.fmod(pos, 3)
    if row == 0 then
        row = 3
    end
    assert(col > 0)
    assert(row > 0)
	
    local x = pos1X - (col - 1) * OffsetX - (row - 1) * RowOffsetX
    local y = pos1Y - (row - 1) * OffsetY + anchorPointOffset
    
    local node = display.newNode()
    _playerTouchTable[#_playerTouchTable + 1] = {}
    _playerTouchTable[#_playerTouchTable].node = node 
    node:setContentSize(CCSize(76, 161))
    node:setPosition(x, y)
    node:setAnchorPoint(ccp(0, 0.5))
    
    self:addChild(node)
    _playerTouchTable[#_playerTouchTable].sprite = sprite
end

---
-- 新建一个敌人阵营触摸检测体
-- function [parent = #FightCCBView] createTouchRect 
-- @param #number pos 站位
-- 
function FightCCBView:createEnemyTouchRect(sprite, pos)
	 --站位
    local OffsetX = 95
    local OffsetY = 90
    local RowOffsetX = 50
    local anchorPointOffset = 75   --锚点偏移

    local enemyPos1X = 535
    local enemyPos1Y = 275
    
    local col = math.ceil(pos/3)
    local row = math.fmod(pos, 3)
    if row == 0 then
        row = 3
    end
    assert(col > 0)
    assert(row > 0)
    
    local x = enemyPos1X + (col - 1) * OffsetX + (row - 1) * RowOffsetX
    local y = enemyPos1Y - (row - 1) * OffsetY + anchorPointOffset
    
    local node = display.newNode()
    _enemyTouchTable[#_enemyTouchTable + 1] = {}
    _enemyTouchTable[#_enemyTouchTable].node = node 
    node:setContentSize(CCSize(76, 161))
    node:setPosition(x, y)
    node:setAnchorPoint(ccp(0, 0.5))
    
    self:addChild(node)
    _enemyTouchTable[#_enemyTouchTable].sprite = sprite
end
	
---
-- 设置敌方名字
-- @function [parent = #FightCCBView] setEnemyName
-- @param #string name
-- 
function FightCCBView:setEnemyName(name)
	self["enemyLab"]:setString(name)
end
	
---
-- 判断是否在战斗场景中
-- @function [parent = #view.fight.FightCCBView] isInBattle
-- @return #bool
-- 
function isInBattle()
	return _isInBattale
end

---
-- 设置是否是第一次战斗
-- @function [parent = #view.fight.FightCCBView] setFirstBattle
-- @param #bool b
-- 
function setFirstBattle(b)
	_isFirstBattle = b
end

---
-- 清空战斗人物属性表
-- @function [parent = #FightCCBView] clearFighterTable
--  
function FightCCBView:clearFighterTable()
	_playerTouchTable = {}
	_enemyTouchTable = {}
end

---
-- 设置不可触摸
-- @function [parent = #view.fight.FightCCBView] setLayerTouch
-- @param #bool isTouch
--
function FightCCBView:setLayerTouch(isTouch)
	self._touchLayer:setTouchEnabled(isTouch)
end

---
-- 获取是否是重播
-- @function [parent = #view.fight.FightCCBView] isReplay
-- @return #bool
-- 
function FightCCBView:isReplay()
	return self._isReplay
end

---
-- 设置是否重播
-- @function [parent = #FightCCBView] setIsReplay
-- @param #bool replay
function FightCCBView:setIsReplay(replay)
	self._isReplay = replay
end

---
-- 是否按了速战速决
-- @function [parent = #FightCCBView] isClickEndFightBtn
-- @return #bool
-- 
function FightCCBView:isClickEndFightBtn()
	return self._isClickFightEndBtn
end

---
-- 速战速决动画
-- @function [parent = #FightCCBView] endFightBtnAnim
-- @param #number type
--
function FightCCBView:endFightBtnAnim(type)
	local time = 0.5
	
	if type == self._endFightBtnCurrState then
			return
	end
	
	self._endFightBtnCurrState = type 
	
	local transition = require("framework.client.transition")
	if type == self._END_FIGHT_BTN_DOWN then
		self["quickFightNode"]:stopAllActions()
		transition.moveTo(self["quickFightNode"],
			{
				time = time,
				easing = "SINEOUT",
				x = self["quickFightNode"]:getPositionX(),
				y = self["quickFightNode"].sy - self._QUICK_FIGHT_NODE_OFFSETY,
			}
		)
	else
		self["quickFightNode"]:stopAllActions()
		transition.moveTo(self["quickFightNode"],
			{
				time = time,
				easing = "SINEOUT",
				x = self["quickFightNode"]:getPositionX(),
				y = self["quickFightNode"].sy,
			}
		)
	end	
end
