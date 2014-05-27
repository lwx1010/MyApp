---
-- 武林榜pk结束失败
-- @module view.wulinbang.PkLoseView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.wulinbang.PkLoseView"
module(moduleName)


--- 
-- 类定义
-- @type PkLoseView
-- 
local PkLoseView = class(moduleName, require("ui.CCBView").CCBView, true)

--- 
-- 保存结算数据
-- @field [parent = #view.wulinbang.PkLoseView] _rewardMsg
--
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #PkLoseView] ctor
-- 
function PkLoseView:ctor()
	PkLoseView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 场景进入回调
-- @function [parent=#PkLoseView] onEnter
-- 
function PkLoseView:onEnter()
	PkLoseView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["loseSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["loseSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #PkLoseView] _create
-- 
function PkLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_roblose.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["starSpr1"]:setVisible(false)
	self["starSpr2"]:setVisible(false)
	self["starSpr3"]:setVisible(false)
	
	self:showInfo(_rewardMsg)
	
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
end

---
-- 显示信息
-- @function [parent=#PkLoseView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function PkLoseView:showInfo( pb )
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
-- ui点击处理
-- @function [parent=#PkLoseView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function PkLoseView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
	
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	if WuLinBangView.instance then
		WuLinBangView.instance:showFailPlayerAnim()
	end
	
	-- 武林榜刷新
--	local GameNet = require("utils.GameNet")
--	GameNet.send("C2s_wulin_info", {index = 1})
--	GameNet.send("C2s_wulin_user_info", {index = 1})
end

---
-- 场景退出后自动调用
-- @function [parent = #PkLoseView] onExit
-- @param #PkLoseView self
-- 
function PkLoseView:onExit()
	require("view.wulinbang.PkLoseView").instance = nil
	
	PkLoseView.super.onExit(self)
end

---
-- 设置结算信息
-- @function [parent = #view.wulinbang.PkLoseView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

