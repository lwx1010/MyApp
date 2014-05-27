---
-- 武林榜pk结束胜利
-- @module view.wulinbang.PkWinView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.wulinbang.PkWinView"
module(moduleName)


--- 
-- 类定义
-- @type PkWinView
-- 
local PkWinView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 保存结算数据
-- @field [parent = #view.wulinbang.PkWinView] _rewardMsg
--
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #PkWinView] ctor
-- 
function PkWinView:ctor()
	PkWinView.super.ctor(self)
	self:_create()
	--self:retain()
	
end

---
-- 场景进入自动回调
-- @function [parent = #PkWinView] onEnter
-- 
function PkWinView:onEnter()
	PkWinView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["bigWinSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["bigWinSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #PkWinView] _create
-- 
function PkWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robwin.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["chipCcb"]:setVisible(false)
	self["itemNameLab"]:setString("")
	
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
	
	self["notGetItemSpr"]:setVisible(false)
	
	self:showInfo(_rewardMsg)
end

---
-- 显示信息
-- @function [parent=#PkWinView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function PkWinView:showInfo( pb )
	if not pb then
		self["expNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
		self["expNumLab"]:setValue(0)
		return 
	end
	
	if pb.bonus_type == "Cash" then
		self:changeFrame("typeSpr", "ccb/zhandoujiesuan/coin_3.png")
	elseif pb.bonus_type == "YuanBao" then
		self:changeFrame("typeSpr", "ccb/zhandoujiesuan/gold_2.png")
	elseif pb.bonus_type == "UserExp" then
		self:changeFrame("typeSpr", "ccb/zhandoujiesuan/Prestige_2.png")
	elseif pb.bonus_type == "PartnerExp" then
		self:changeFrame("typeSpr", "ccb/zhandoujiesuan/exp_3.png")
	end
	
	self["expNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self["expNumLab"]:setValue( pb.bonus_value or 0 )
end

---
-- 设置结算信息
-- @function [parent = #view.wulinbang.PkWinView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- ui点击处理
-- @function [parent=#PkWinView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function PkWinView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
	
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	if WuLinBangView.instance then
		WuLinBangView.instance:showWinPlayerAnim()
	end
	
	-- 武林榜刷新
--	local GameNet = require("utils.GameNet")
--	GameNet.send("C2s_wulin_info", {index = 1})
--	GameNet.send("C2s_wulin_user_info", {index = 1})
end

---
-- 场景退出后自动调用
-- @function [parent = #PkWinView] onExit
-- @param #PkWinView self
-- 
function PkWinView:onExit()
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
	
	require("view.wulinbang.PkWinView").instance = nil
	
	PkWinView.super.onExit(self)
end
