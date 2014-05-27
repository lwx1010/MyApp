---
-- 武林榜玩家自己属性界面
-- @module view.wulinbang.MySelfMsgView
--

local require = require
local class = class
local CCMoveTo = CCMoveTo
local ccp = ccp
local CCRepeatForever = CCRepeatForever

local tr = tr

local moduleName = "view.wulinbang.MySelfMsgView"
module(moduleName)

---
-- 类定义
-- @type MySelfMsgView
--
local MySelfMsgView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 原三角形高
-- @field [parent = #MySelfMsgView] #number _initRetangleHeight
-- 
MySelfMsgView._initRetangleHeight = 0

---
-- 构造函数
-- @function [parent = #MySelfMsgView] ctor
--
function MySelfMsgView:ctor()
	MySelfMsgView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #MySelfMsgView] _create
--
function MySelfMsgView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_wulinpiece1.ccbi", true)
	
	
	self._initRetangleHeight = self["retangleSpr"]:getPositionY()
end 

---
-- 设置显示的信息
-- @function [parent = #MySelfMsgView] setShowMsg
-- @param #table msg
-- 
function MySelfMsgView:setShowMsg(msg)
	self["levelLab"]:setString(msg.grade)
	self["attackLab"]:setString(msg.score)
end

---
-- 设置形态
-- @function [parent = #MySelfMsgView] setShowType
-- @param number type
-- 
function MySelfMsgView:setShowType(type)
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
		self["retangleSpr"]:setPosition(239, 70)
		
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
-- @function [parent = #MySelfMsgView] onExit
-- 
function MySelfMsgView:onExit()
	
	require("view.wulinbang.MySelfMsgView").instance = nil
	MySelfMsgView.super.onExit(self)
end








