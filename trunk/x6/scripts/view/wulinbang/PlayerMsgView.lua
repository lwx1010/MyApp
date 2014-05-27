---
-- 武林榜人物属性界面
-- @module view.wulinbang.PlayerMsgView
--

local require = require
local class = class
local CCMoveTo = CCMoveTo
local ccp = ccp
local CCRepeatForever = CCRepeatForever

local tr = tr

local moduleName = "view.wulinbang.PlayerMsgView"
module(moduleName)

---
-- 类定义
-- @type PlayerMsgView
--
local PlayerMsgView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 挑战人物ID
-- @field [parent = #PlayerMsgView] #number _battleId
-- 
PlayerMsgView._battleId = nil

---
-- 能否挑战
-- @field [parent = #PlayerMsgView] #number _canPk
-- 
PlayerMsgView._canPk = 0

---
-- 时间回调句柄
-- @field [parent = #PlayerMsgView] #CCScheduler _scheHandle
-- 
PlayerMsgView._scheHandle = nil

---
-- 结束时间
-- @field [parent = #PlayerMsgView] #number _endTime
-- 
PlayerMsgView._endTime = 0

---
-- 原三角形高
-- @field [parent = #PlayerMsgView] #number _initRetangleHeight
-- 
PlayerMsgView._initRetangleHeight = 0

---
-- 当前人物的排位
-- @field [parent = #PlayerMsgView] #number _wuLinPos
-- 
PlayerMsgView._wuLinPos = 0

---
-- 构造函数
-- @function [parent = #PlayerMsgView] ctor
--
function PlayerMsgView:ctor()
	PlayerMsgView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #PlayerMsgView] _create
--
function PlayerMsgView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_wulinpiece.ccbi", true)
	
	self._initRetangleHeight = self["retangleSpr"]:getPositionY()
	
	self:handleButtonEvent("attackBtn", self._attackBtnHandler)
end 

---
-- 设置显示的信息
-- @function [parent = #PlayerMsgView] setShowMsg
-- @param #table msg
-- 
function PlayerMsgView:setShowMsg(msg)
	self["levelLab"]:setString(msg.grade)
	self["attackLab"]:setString(msg.score)
	self["rewardLab"]:setString(msg.bonus_value)
	
	self._wuLinPos = msg.rank
	
	if msg.bonus_type == "Cash" then
		self:changeFrame("rewardSpr", "ccb/mark/coin.png")
	elseif msg.bonus_type == "YuanBao" then
		self:changeFrame("rewardSpr", "ccb/mark/gold.png")
	elseif msg.bonus_type == "UserExp" then
		self:changeFrame("rewardSpr", "ccb/mark/Prestige.png")
	elseif msg.bonus_type == "PartnerExp" then
		self:changeFrame("rewardSpr", "ccb/mark/exp.png")
	end
	
	local scheduler = require("framework.client.scheduler")
	if self._scheHandle then
		scheduler.unscheduleGlobal(self._scheHandle)
		self._scheHandle = nil
	end
	
	if  msg.over_time > 0 then
		local NumberUtil = require("utils.NumberUtil")
		self._endTime = msg.over_time
		local func = function()
			self._endTime = self._endTime - 1
			if self._endTime <= 0 then
				scheduler.unscheduleGlobal(self._scheHandle)
				self._scheHandle = nil
				self["timeLab"]:setString("")
				return
			end
			
			self["timeLab"]:setString(NumberUtil.secondToDate(self._endTime))
		end
			
		self._scheHandle = scheduler.scheduleGlobal(func, 1)
	else
		self["timeLab"]:setString("00:00:00")
	end
	
	self._battleId = msg.uid
	self._canPk = msg.can_pk
end

---
-- 点击了挑战按钮
-- @function [parent = #PlayerMsgView] _attackBtnHandler
-- 
function PlayerMsgView:_attackBtnHandler(sender, event)
	if self._canPk == 2 then 
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("对方不想和你交手！！"))
		return
	end
	
	local view = require("view.wulinbang.WuLinBangView").instance
	if view == nil then
		view = require("view.wulinbang.WuLinBangView").createInstance()
	end
	
	if view:getChallengeCnt() <= 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("今日挑战次数已经用完！！"))
		return
	end
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	if self._battleId then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_wulin_pk", {tar_uid = self._battleId, pos = self._wuLinPos})
	end
	
	self:setVisible(false)
end

---
-- 设置形态
-- @function [parent = #PlayerMsgView] setShowType
-- @param number type
-- 
function PlayerMsgView:setShowType(type)
	if not type then type = 1 end
	if type == 1 then
		self["retangleSpr"]:setRotation(0)
		self["retangleSpr"]:setPosition(110, 14)
		
		-- 三角形动画
		self["retangleSpr"]:stopAllActions()
		local transition = require("framework.client.transition")
		local x = self["retangleSpr"]:getPositionX()
		--self["retangleSpr"]:setPositionY(self._initRetangleHeight)
		local y = self["retangleSpr"]:getPositionY()
		local action = transition.sequence({
			CCMoveTo:create(0.35, ccp(x, y - 20)),   
			CCMoveTo:create(0.25, ccp(x, y)),   
		})
		action = CCRepeatForever:create(action)
		self["retangleSpr"]:runAction(action)
	else
		self["retangleSpr"]:setRotation(270)
		self["retangleSpr"]:setPosition(239, 139)
		
		-- 三角形动画
		self["retangleSpr"]:stopAllActions()
		local transition = require("framework.client.transition")
		local x = self["retangleSpr"]:getPositionX()
		--self["retangleSpr"]:setPositionY(self._initRetangleHeight)
		local y = self["retangleSpr"]:getPositionY()
		local action = transition.sequence({
			CCMoveTo:create(0.35, ccp(x + 20, y)),  
			CCMoveTo:create(0.25, ccp(x, y)),  
		})
		action = CCRepeatForever:create(action)
		self["retangleSpr"]:runAction(action)
	end
end

---
-- 场景退出自动回调
-- @function [parent = #PlayerMsgView] onExit
-- 
function PlayerMsgView:onExit()
	if self._scheHandle then 
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._scheHandle)
		self._scheHandle = nil
	end
	
	require("view.wulinbang.PlayerMsgView").instance = nil
	PlayerMsgView.super.onExit(self)
end








