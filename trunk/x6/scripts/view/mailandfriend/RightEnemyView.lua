--- 
-- 仇人界面右边
-- @module view.mailandfriend.RightEnemyView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local display = display
local transition = transition


local moduleName = "view.mailandfriend.RightEnemyView"
module(moduleName)


--- 
-- 类定义
-- @type RightEnemyView
-- 
local RightEnemyView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否好友
-- @field [parent=#RightEnemyView] #boolean isFriend
-- 
RightEnemyView.isFriend = false

--- 
-- 构造函数
-- @function [parent=#RightEnemyView] ctor
-- @param self
-- 
function RightEnemyView:ctor()
	RightEnemyView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#RightEnemyView] _create
-- @param self
-- 
function RightEnemyView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_enemy.ccbi", true)
	
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setHCount(1)
	box:setVSpace(20)
	box.owner = self
	
	local FriendAndEnemyCell = require("view.mailandfriend.FriendAndEnemyCell")
	box:setCellRenderer(FriendAndEnemyCell)
	
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	local HeroAttr = require("model.HeroAttr")
	self["vigorLab"]:setString("" .. (HeroAttr.Vigor or 0) .. "/" .. (HeroAttr.VigorMax or 0) )
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 创建实例
-- @return RightEnemyView实例
-- 
function new()
	return RightEnemyView.new()
end

--- 
-- 数据变化
-- @function [parent=#RightEnemyView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function RightEnemyView:_attrsUpdatedHandler( event )
	if not event.attrs then return end
	
	local tbl = event.attrs 
	local HeroAttr = require("model.HeroAttr")
	if tbl.Vigor or tbl.VigorMax then
		self["vigorLab"]:setString("" .. HeroAttr.Vigor .. "/" .. (HeroAttr.VigorMax or 0) )
	end
end

---
-- 显示仇人信息(每次打开好友界面调用)
-- @function [parent=#RightEnemyView] getEnemyInfo
-- @param self
--
function RightEnemyView:getEnemyInfo()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_info", {get_type = 2})
end

---
-- 显示仇人信息
-- @function [parent=#RightEnemyView] showEnemyInfo
-- @param self
-- @param #S2c_friend_enemy_info pb
--
function RightEnemyView:showEnemyInfo(pb)
	if not pb then return end
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(pb.friend_list)
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setDataSet(set)
	
	if not pb.friend_list or #pb.friend_list == 0 then
		self["noneSpr"]:setVisible(true)
		self["noneLab"]:setVisible(true)
	else
		self["noneSpr"]:setVisible(false)
		self["noneLab"]:setVisible(false)
	end
end

---
-- 拖动
-- @function [parent=#RightEnemyView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function RightEnemyView:_scrollChangedHandler( event )
	if not self.owner then return end
	
	self.owner:scrollHandler()
end

---
-- 退出界面时调用
-- @field [parent=#RightEnemyView] onExit
-- @param self
--
function RightEnemyView:onExit()
	
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setDataSet(nil)
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	if instance then
		instance = nil
	end
	
	RightEnemyView.super.onExit(self)
end
