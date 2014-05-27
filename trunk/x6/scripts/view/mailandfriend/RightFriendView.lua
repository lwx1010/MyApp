--- 
-- 好友界面右边
-- @module view.mailandfriend.RightFriendView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local display = display
local transition = transition
local CCRectMake = CCRectMake
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCSize = CCSize
local ccp = ccp

local moduleName = "view.mailandfriend.RightFriendView"
module(moduleName)


--- 
-- 类定义
-- @type RightFriendView
-- 
local RightFriendView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是好友
-- @field [parent=#RightFriendView] #boolean isFriend
-- 
RightFriendView.isFriend = true

--- 
-- 构造函数
-- @function [parent=#RightFriendView] ctor
-- @param self
-- 
function RightFriendView:ctor()
	RightFriendView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#RightFriendView] _create
-- @param self
-- 
function RightFriendView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_friend.ccbi", true)
	
	self:handleButtonEvent("requestCcb.aBtn", self._requestClkHandler)
	self:handleButtonEvent("addCcb.aBtn", self._addClkHandler)
	
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setHCount(1)
	box:setVSpace(20)
	box.owner = self
	
	local FriendAndEnemyCell = require("view.mailandfriend.FriendAndEnemyCell")
	box:setCellRenderer(FriendAndEnemyCell)
	
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	local EventCenter = require("utils.EventCenter")
	local MailEvents = require("model.event.MailEvents")
	EventCenter:addEventListener(MailEvents.NEW_MAIL_UPDATED.name, self._newMailHandler, self)
	
	local MailData = require("model.MailData")
	self["newSpr"]:setVisible(MailData.newFriendRequest)
end

---
-- 创建实例
-- @return RightFriendView实例
-- 
function new()
	return RightFriendView.new()
end

---
-- 新好友申请
-- @function [parent=#RightFriendView] _newMailHandler
-- @param self
-- @param #table event
-- 
function RightFriendView:_newMailHandler( event )
	local MailData = require("model.MailData")
	
	if MailData.newFriendRequest == true then
		self["newSpr"]:setVisible(true)
	end
end

---
-- 点击了请求 
-- @function [parent=#RightFriendView] _requestClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RightFriendView:_requestClkHandler( sender, event )
	local FriendRequestView = require("view.mailandfriend.FriendRequestView")
	FriendRequestView.createInstance():openUi()
	
	local MailData = require("model.MailData")
	if MailData.newFriendRequest then
		MailData.newFriendRequest = false
		self["newSpr"]:setVisible(false)
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_mail_new_look", {mail_type = 4})
	end
end

---
-- 点击了添加
-- @function [parent=#RightFriendView] _addClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RightFriendView:_addClkHandler( sender, event )
	local AddFriendView = require("view.mailandfriend.AddFriendView")
	AddFriendView.createInstance():openUi()
end

---
-- 显示好友信息(每次打开好友界面调用)
-- @function [parent=#RightFriendView] getFriendInfo
-- @param self
--
function RightFriendView:getFriendInfo()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_info", {get_type = 1})
end

---
-- 显示好友信息
-- @function [parent=#RightFriendView] showFriendInfo
-- @param self
-- @param #S2c_friend_info pb
-- 
function RightFriendView:showFriendInfo(pb)
	if not pb then return end
	
	self["curLab"]:setString("当前好友 " .. pb.friend_num .. "/" .. pb.friend_max_num)
	
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
-- @function [parent=#RightFriendView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function RightFriendView:_scrollChangedHandler( event )
	if not self.owner then return end
	
	self.owner:scrollHandler()
end

---
-- 退出界面时调用
-- @field [parent=#RightFriendView] onExit
-- @param self
--
function RightFriendView:onExit()
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setDataSet(nil)
	
	local EventCenter = require("utils.EventCenter")
	local MailEvents = require("model.event.MailEvents")
	EventCenter:removeEventListener(MailEvents.NEW_MAIL_UPDATED.name, self._newMailHandler, self)
	
	instance = nil
	
	self.super.onExit(self)
end
