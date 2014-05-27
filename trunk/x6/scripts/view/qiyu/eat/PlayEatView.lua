--- 
-- 玩法整合界面：吃饭了
-- @module view.qiyu.eat.PlayEatView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local dump = dump


local moduleName = "view.qiyu.eat.PlayEatView"
module(moduleName)

--- 
-- 类定义
-- @type PlayEatView
-- 
local PlayEatView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#PlayEatView] ctor
-- @param self
-- 
function PlayEatView:ctor()
	PlayEatView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#PlayEatView] _create
-- @param self
-- 
function PlayEatView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_kaifanle.ccbi", true)
	
	self["eat1Btn"]:setVisible(false)
	self["eat1BtnSpr"]:setVisible(false)
	self["tipLab1"]:setVisible(false)
	self["eat2Btn"]:setVisible(false)
	self["eat2BtnSpr"]:setVisible(false)
	self["tipLab2"]:setVisible(false)
	
	self:handleButtonEvent("eat1Btn", self._eat1ClkHandler)
	self:handleButtonEvent("eat2Btn", self._eat2ClkHandler)
end

---
-- 点击了吃1
-- @function [parent=#PlayEatView] _eat1ClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PlayEatView:_eat1ClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_physicalbonus_bonus", {index = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 点击了吃2
-- @function [parent=#PlayEatView] _eat2ClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PlayEatView:_eat2ClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_physicalbonus_bonus", {index = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 打开界面调用
-- @function [parent=#PlayEatView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function PlayEatView:openUi( info )
--	if not info then return end
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_physicalbonus_info", {index = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示吃饭信息
--@function [parent=#PlayEatView] showInfo
--@param self
--@param #table rewardInfo 吃饭信息
--
function PlayEatView:showInfo(rewardInfo)
	if( not rewardInfo ) then return end
--	dump(rewardInfo)
	local info
	for i=1, #rewardInfo do
		info = rewardInfo[i]
		-- 午餐信息
		if( info.bonus_type == 1 ) then
			-- 未开启
			if( info.bonus_state == 1 ) then
				self["eat1Btn"]:setVisible(false)
				self["eat1BtnSpr"]:setVisible(false)
				self["tipLab1"]:setVisible(false)
			-- 已开启
			elseif( info.bonus_state == 2 ) then
				-- 可领取
				if( info.bonus_give == 1 ) then
					self["eat1Btn"]:setVisible(true)
					self["eat1BtnSpr"]:setVisible(true)
					self["tipLab1"]:setVisible(false)
				-- 已领取
				elseif( info.bonus_give == 2 ) then
					self["eat1Btn"]:setVisible(false)
					self["eat1BtnSpr"]:setVisible(false)
					self["tipLab1"]:setVisible(true)
					self["tipLab1"]:setString(tr("<c1>您已领取"..info.bonus_num.."点体力"))
				end
			-- 已过期
			elseif( info.bonus_state == 3 ) then
				-- 已领取
				if( info.bonus_give == 2 ) then
					self["eat1Btn"]:setVisible(false)
					self["eat1BtnSpr"]:setVisible(false)
					self["tipLab1"]:setVisible(true)
					self["tipLab1"]:setString(tr("<c1>您已领取"..info.bonus_num.."点体力"))
				-- 不可领取
				elseif( info.bonus_give == 0 ) then
					self["eat1Btn"]:setVisible(false)
					self["eat1BtnSpr"]:setVisible(false)
					self["tipLab1"]:setVisible(true)
					self["tipLab1"]:setString(tr("<c1>已错过饭点"))
				end
			end
		-- 晚餐信息
		elseif( info.bonus_type == 2 ) then
			-- 未开启
			if( info.bonus_state == 1 ) then
				self["eat2Btn"]:setVisible(false)
				self["eat2BtnSpr"]:setVisible(false)
				self["tipLab2"]:setVisible(false)
			-- 已开启
			elseif( info.bonus_state == 2 ) then
				-- 可领取
				if( info.bonus_give == 1 ) then
					self["eat2Btn"]:setVisible(true)
					self["eat2BtnSpr"]:setVisible(true)
					self["tipLab2"]:setVisible(false)
				-- 已领取
				elseif( info.bonus_give == 2 ) then
					self["eat2Btn"]:setVisible(false)
					self["eat2BtnSpr"]:setVisible(false)
					self["tipLab2"]:setVisible(true)
					self["tipLab2"]:setString(tr("<c1>您已领取"..info.bonus_num.."点体力"))
				end
			-- 已过期
			elseif( info.bonus_state == 3 ) then
				-- 已领取
				if( info.bonus_give == 2 ) then
					self["eat2Btn"]:setVisible(false)
					self["eat2BtnSpr"]:setVisible(false)
					self["tipLab2"]:setVisible(true)
					self["tipLab2"]:setString(tr("<c1>您已领取"..info.bonus_num.."点体力"))
				-- 不可领取
				elseif( info.bonus_give == 0 ) then
					self["eat2Btn"]:setVisible(false)
					self["eat2BtnSpr"]:setVisible(false)
					self["tipLab2"]:setVisible(true)
					self["tipLab2"]:setString(tr("<c1>已错过饭点"))
				end
			end
		end
	end
end

---
-- 关闭界面
-- @function [parent=#PlayEatView] closeUi
-- @param self
-- 
function PlayEatView:closeUi()
--	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#PlayEatView] onExit
-- @param self
-- 
function PlayEatView:onExit()
	instance = nil
	
	PlayEatView.super.onExit(self)
end