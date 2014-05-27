--- 
-- 签到界面
-- @module view.task.SignInView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local pairs = pairs
local string = string
local table = table

local moduleName = "view.task.SignInView"
module(moduleName)

---
-- 是否可以领取奖励
-- @field [parent=#view.task.SignInView] #boolean isGetSignInReward
-- 
isGetSignInReward = false

---
-- 请求奖励信息
-- @function [parent=#view.task.SignInView] requestRewardInfo
-- @param self
-- 
function requestRewardInfo()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_signin_info", {placeholder = 1})
end

---
-- 设置是否可以领取奖励，可以就显示主界面的"新"字，此接口用做协议返回时更新界面状态
-- @function [parent=#view.task.SignInView] setGetSignInReward
-- @param #boolean isGet
-- 
function setGetSignInReward(isGet)
	isGetSignInReward = isGet
	
	if isGet then
		local MainView = require("view.main.MainView").instance
		if MainView then
			MainView:taskNewHandler()
		end
	end
end

--- 
-- 类定义
-- @type SignInView
-- 
local SignInView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 是否已移动位置
-- @field [parent=#SignInView] #boolean _isMove
-- 
SignInView._isMove = false

--- 
-- 双倍元宝数
-- @field [parent=#SignInView] #number _doubleYuanBao
-- 
SignInView._doubleYuanBao = nil

--- 
-- 构造函数
-- @function [parent=#SignInView] ctor
-- @param self
-- 
function SignInView:ctor()
	SignInView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

---
-- 创建实例
-- @function [parent=#view.task.SignInView] new
-- @return SiganInView实例
-- 
function new()
	return SignInView.new()
end

--- 
-- 创建
-- @function [parent=#SignInView] _create
-- @param self
-- 
function SignInView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_qiandao.ccbi")
	
	-- 按钮处理
	for i = 1, 6 do
		local pb = "pickBtn" .. i
		local db = "doubleBtn" .. i
		self:handleButtonEvent(pb, self._pickBtnHandler)
		self:handleButtonEvent(db, self._doubleBtnHandler)
		
		self["pickSpr" .. i]:setVisible(false)
		self:showBtn("doubleBtn" .. i, false)
		self:showBtn("pickBtn" .. i, false)
	end
	
	local point = self["rewardLab1"]:getAnchorPoint()
	printf("signINView: %f", point.x)
end

---
-- 界面初始化
-- @function [parent=#SignInView] initByPb
-- @param self
-- @param #table pb
-- 
function SignInView:initByPb(pb)
	if not pb then return end
	
	-- 设置奖励信息
	local arr = pb.list_info
	local cur = pb.curindex
	
	if cur == 7 then cur = 6 end
	
	-- 排序
	table.sort(arr, function(a, b)
		return a.index < b.index
	end)
	
	for i = 1, 6 do
		self["rewardLab" .. i]:setString(arr[i].reward_des)
		
		if self["valueLab" .. i] then
			self["valueLab" .. i]:setString(arr[i].reward_value)
		end
		
		if not self._isMove then
			if arr[i].reward_value == "" then
				local oy = self["rewardLab" .. i]:getPositionY()
				self["rewardLab" .. i]:setPositionY(oy - 15)
			end
		end
	end
	
	self._isMove = true
	
	-- 当前签到天数
	local key = string.format("ccb/qiandao/num_%d.png", pb.curindex)
	self:changeFrame("daySpr", key)
	
	self["pickSpr" .. cur]:setVisible(pb.canget == 0)
	self:showBtn("pickBtn" .. cur, (pb.canget == 1))
--	self:showBtn("double" .. cur, arr[cur].isdouble == 1)
	self:showBtn("doubleBtn" .. cur, (arr[cur].isdouble == 1) and (pb.canget == 1))
	self["greenSpr" .. cur]:setVisible(false)
	self["backSpr" .. cur]:setVisible(pb.canget == 0)
	
	if (self["pickBtn" .. cur]:isVisible()) and (not self["doubleBtn" .. cur]:isVisible()) then
		local odx = self["pickBtn" .. cur]:getPositionX()
		local off = self["doubleBtn" .. cur]:getPositionX() - odx
		self["pickBtn" .. cur]:setPositionX(odx + off)
		self["pickBtn" .. cur .. "Spr"]:setPositionX(self["pickBtn" .. cur .. "Spr"]:getPositionX() + off)
--		self[""]
	end
	
	self._doubleYuanBao = pb.double_yuanbao
	
	isGetSignInReward = (pb.canget == 1)
	printf(isGetSignInReward)
end

---
-- 领取按钮点击处理
-- @function [parent=#SignInView] _pickBtnHandler
-- @param self
-- @param #CCNode sender 发送者
-- @param #table event 事件
-- 
function SignInView:_pickBtnHandler(sender, event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_signin_getreward", {type = 1})
end

---
-- 双倍按钮点击处理
-- @function [parent=#SignInView] _doubleBtnHandler
-- @param self
-- @param #CCNode sender 发送者
-- @param #table event 事件
-- 
function SignInView:_doubleBtnHandler(sender, event)
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.YuanBao < self._doubleYuanBao then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("元宝不足"))
		return 
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_signin_getreward", {type = 2})
end