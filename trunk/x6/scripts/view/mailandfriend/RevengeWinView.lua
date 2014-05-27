---
-- 复仇pk结束胜利
-- @module view.mailandfriend.RevengeWinView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.mailandfriend.RevengeWinView"
module(moduleName)


--- 
-- 类定义
-- @type RevengeWinView
-- 
local RevengeWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存结算信息
-- @field [parent = #view.mailandfriend.RevengeWinView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #RevengeWinView] ctor
-- 
function RevengeWinView:ctor()
	RevengeWinView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #RevengeWinView] _create
-- 
function RevengeWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robwin.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self:changeFrame("typeSpr", "ccb/zhandoujiesuan/coin_3.png")
	self["notGetItemSpr"]:setVisible(false)
	
	if _rewardMsg then
		self:showInfo(_rewardMsg)
	end
end

---
-- 设置结算信息
-- @function [parent = view.mailandfriend.RevengeWinView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 显示信息
-- @function [parent=#RevengeWinView] showInfo
-- @param self
-- @param #S2c_friend_pk_result pb
-- 
function RevengeWinView:showInfo( pb )
	if not pb then return end
	
	if pb.is_win == 1 then
		self["starSpr3"]:setVisible(true)
		self["littleWinSpr"]:setVisible(false)
		self["bigWinSpr"]:setVisible(true)
	else
		self["starSpr3"]:setVisible(false)
		self["bigWinSpr"]:setVisible(false)
		self["littleWinSpr"]:setVisible(true)
	end
	
	self["expNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["expNumLab"]:setValue( pb.give_cash or 0 )
	
	if pb.item_type > 0 then
		self["chipCcb"]:setVisible(true)
		if pb.item_type == 1 or pb.item_type == 2 then
			self["chipCcb.headPnrSpr"]:showReward("partner", pb.item_icon)
			local PartnerShowConst = require("view.const.PartnerShowConst")
			self["itemNameLab"]:setString(PartnerShowConst.STEP_COLORS[pb.item_step] .. pb.item_name)
			self:changeFrame("chipCcb.frameSpr", PartnerShowConst.STEP_FRAME[pb.item_step])
		else
			self["chipCcb.headPnrSpr"]:showReward("item", pb.item_icon)
			local ItemViewConst = require("view.const.ItemViewConst")
			self["itemNameLab"]:setString(ItemViewConst.EQUIP_STEP_COLORS[pb.item_step] .. pb.item_name)
			self:changeFrame("chipCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[pb.item_step])
		end
	else
		self["chipCcb"]:setVisible(false)
		self["itemNameLab"]:setString("")
	end
end

---
-- ui点击处理
-- @function [parent=#RevengeWinView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function RevengeWinView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self)
end

---
-- 退出界面时调用
-- @field [parent=#RevengeWinView] onExit
-- @param self
--
function RevengeWinView:onExit()
	_rewardMsg = nil
	instance = nil
	
	RevengeWinView.super.onExit(self)
end

