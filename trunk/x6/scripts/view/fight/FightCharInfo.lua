---
-- 战斗人物属性界面
-- @module view.fight.FightCharInfo
--

local require = require
local class = class
local ccp = ccp
local CCSize = CCSize

local dump = dump

local moduleName = "view.fight.FightCharInfo"
module(moduleName)

---
-- 类定义
-- @type FightCharInfo
--
local FightCharInfo = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #FightCharInfo] ctor
--
function FightCharInfo:ctor()
	FightCharInfo.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FightCharInfo] _create
--
function FightCharInfo:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_battle/ui_battlecharinfo.ccbi", true)
	self:setAnchorPoint(ccp(0.5, 0.5))
	self:setShow(false)
end 

---
-- 设置显示信息
-- @function [parent = #FightCharInfo] setShowMsg
-- @param #table msg
-- 
function FightCharInfo:setShowMsg(msg)
--	dump(msg)
	if msg.grade then
		self["nameLab"]:setString(msg.name.."  Lv."..msg.grade)
	else
		self["nameLab"]:setString(msg.name)
	end
	
	self["attackLab"]:setString(msg.attackCount)
	self["defLab"]:setString(msg.defCount)
	if msg.hp < 0 then
		msg.hp = 0 
	end
	self["lifeLab"]:setString(msg.hp.."/"..msg.hpMax)
	self["speedLab"]:setString(msg.speed)
	for i = 1, #msg.wuGong do
		self["wuGongLab"..i]:setVisible(true)
		self["wuGongLab"..i]:setString(msg.wuGong[i].name.." 等级："..msg.wuGong[i].lv)
	end
end

---
-- 设置显示/隐藏
-- @function [parent = #FightCharInfo] setVisible
-- @param #bool enable
-- 
function FightCharInfo:setShow(enable)
	self:setVisible(enable)
	if enable == false then
		for i = 1, 3 do
			self["wuGongLab"..i]:setVisible(false)
		end
	end
end

---
-- 是否已显示
-- @function [parent = #FightCharInfo] isShow
-- @return #bool 
-- 
function FightCharInfo:isShow()
	return self:isVisible()
end

---
-- 场景退出自动回调
-- @function [parent = #FightCharInfo] onExit
-- 
function FightCharInfo:onExit()
	require("view.fight.FightCharInfo").instance = nil
	FightCharInfo.super.onExit(self)
end








