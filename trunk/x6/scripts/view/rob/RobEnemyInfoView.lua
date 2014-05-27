---
-- 敌人阵容信息
-- @module view.rob.RobEnemyInfoView
--

local require = require
local class = class

local dump = dump

local moduleName = "view.rob.RobEnemyInfoView"
module(moduleName)

---
-- 类定义
-- @type RobEnemyInfoView
--
local RobEnemyInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #RobEnemyInfoView] ctor
--
function RobEnemyInfoView:ctor()
	RobEnemyInfoView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #RobEnemyInfoView] _create
--
function RobEnemyInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_rob_enemyinfo.ccbi", true)
	
	self:resetPlayerInfo()
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
end 

---
-- 点击了关闭按钮
-- @function [parent = #RobEnemyInfoView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function RobEnemyInfoView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 设置敌人阵容信息
-- @function [parent = #RobEnemyInfoView] setHeroInfo
-- @param #table msg
-- 
function RobEnemyInfoView:setHeroInfo(msg)
	for i = 1, #msg do
--		dump(msg)
		self["heroCcb"..i]:setVisible(true)
		self["heroCcb"..i..".headPnrSpr"]:showIcon(msg[i].photo)
		local ItemViewConst = require("view.const.ItemViewConst")
		self:changeFrame("heroCcb"..i..".frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[msg[i].step])
		self:changeFrame("heroCcb"..i..".lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[msg[i].step])
		self["heroCcb"..i..".lvLab"]:setString(msg[i].lv)
		self["heroCcb"..i..".nameLab"]:setString(msg[i].name)
		
		local PartnerShowConst = require("view.const.PartnerShowConst")
		-- 绿色以上升星过的卡牌
		if msg[i].step > 1 and msg[i].star > 0 then
			self["heroCcb"..i..".starBgSpr"]:setVisible(true)
			self["heroCcb"..i..".starLab"]:setVisible(true)
			self["heroCcb"..i..".typeBgSpr"]:setVisible(true)
			self["heroCcb"..i..".starLab"]:setString(msg[i].star)
			self:changeFrame("heroCcb"..i..".typeBgSpr", PartnerShowConst.STEP_STARBG[msg[i].star])
--			self["heroCcb"..i..".typeSpr"]:setPosition(109,59)
		else
			self["heroCcb"..i..".starBgSpr"]:setVisible(false)
			self["heroCcb"..i..".starLab"]:setVisible(false)
			self["heroCcb"..i..".typeBgSpr"]:setVisible(true)
			self:changeFrame("heroCcb"..i..".typeBgSpr", PartnerShowConst.STEP_ICON1[msg[i].step])
--			self["heroCcb"..i..".typeSpr"]:setPosition(112,56)
		end
		self:changeFrame("heroCcb"..i..".starBgSpr", "ccb/mark3/zuoshang.png")
		self:changeFrame("heroCcb"..i..".typeSpr", PartnerShowConst.STEP_TYPE[msg[i].partner_type])
		self["heroCcb"..i..".typeSpr"]:setVisible(true)
	end
end

---
-- 设置玩家名字
-- @function [parent = #RobEnemyInfoView] setPlayerName
-- @param #string name
-- 
function RobEnemyInfoView:setPlayerName(name)
	self["playerNameLab"]:setString(name)
end

---
-- 设置战斗力
-- @function [parent = #RobEnemyInfoView] setPlayerScore
-- @param #number score
-- 
function RobEnemyInfoView:setPlayerScore(score)
	self["scoreLab"]:setString(score)
end

---
-- 隐藏所有阵容信息
-- @function [parent = #RobEnemyInfoView] resetPlayerInfo
-- 
function RobEnemyInfoView:resetPlayerInfo()
	for i = 1, 6 do
		self["heroCcb"..i]:setVisible(false)
	end
end

---
-- 场景退出自动回调
-- @function [parent = #RobEnemyInfoView] onExit
-- 
function RobEnemyInfoView:onExit()
	self:resetPlayerInfo()
	
	require("view.rob.RobEnemyInfoView").instance = nil
	RobEnemyInfoView.super.onExit(self)
end







