---
-- 武林榜pk结束胜利
-- @module view.qiyu.qiecuo.QieCuoWinView
--

local require = require
local class = class
local printf = printf


local moduleName = "view.qiyu.qiecuo.QieCuoWinView"
module(moduleName)


--- 
-- 类定义
-- @type QieCuoWinView
-- 
local QieCuoWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 结算信息
-- @field [parent = #view.qiyu.qiecuo.QieCuoWinView] _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #QieCuoWinView] ctor
-- 
function QieCuoWinView:ctor()
	QieCuoWinView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 场景进入自动回调
-- @function [parent = #QieCuoWinView] onEnter
-- 
function QieCuoWinView:onEnter()
	QieCuoWinView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["bigWinSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["bigWinSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #QieCuoWinView] _create
-- 
function QieCuoWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robwin.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self["notGetItemSpr"]:setVisible(false)
	
--	self["chipCcb"]:setVisible(false)
	self["itemNameLab"]:setString("")
	self["chipCcb.lvBgSpr"]:setVisible(false)
	self["chipCcb.lvLab"]:setVisible(false)
	
	if _rewardMsg then
		self:showInfo(_rewardMsg)
	end
	
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
end

---
-- 设置结算信息
-- @function [parent = #view.qiyu.qiecuo.QieCuoWinView] setRewardMsg
-- @param #table msg
--  
function setRewardMsg(msg)
	_rewardMsg = msg
end

---
-- 显示信息
-- @function [parent=#QieCuoWinView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function QieCuoWinView:showInfo( pb )
	if not pb then return end
	
	--设置经验
	self["expNumLab"]:setBmpPathFormat("ccb/numeric/%d_2.png")
	self["expNumLab"]:setValue(pb.exp)
	
	--碎片
	if not pb.chip_no or pb.chip_no == 0 then 
		self:changeFrame("chipCcb.headPnrSpr", nil)
		self["chipCcb"]:setVisible(false)
		return
	end
	
	self["chipCcb"]:setVisible(true)
	self["itemNameLab"]:setVisible(true)
	local martial = require("xls.MartialChipXls").data
	local martialIconId = martial[pb.chip_no].IconNo
	local martialName = martial[pb.chip_no].NickName
	if martialName == nil then
		martialName = martial[pb.chip_no].Name
	end
	local martialLevel = martial[pb.chip_no].Rare
	
	local frameSpr, nameColor = require("view.rob.RobCell").getItemRare(martialLevel)
	
	self:changeFrame("chipCcb.frameSpr", frameSpr)
	
	local ImageUtil = require("utils.ImageUtil")
	--self["chipCcb.item1Spr"]:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	self:changeItemIcon("chipCcb.headPnrSpr", martialIconId)
	self["itemNameLab"]:setString(nameColor..martialName)
end

---
-- ui点击处理
-- @function [parent=#QieCuoWinView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function QieCuoWinView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, false)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
	
	local QieCuoView = require("view.qiyu.qiecuo.QieCuoView")
	if QieCuoView.instance then
		QieCuoView.instance:qiYuFinish()
	end
end

---
-- 场景退出自动调用，回调函数
-- @function [parent = #QieCuoWinView] onExit
-- 
function QieCuoWinView:onExit()
	_rewardMsg = nil
	self["chipCcb"]:setVisible(false)
	self["itemNameLab"]:setVisible(false)
	
	instance = nil
	QieCuoWinView.super.onExit(self)
end

