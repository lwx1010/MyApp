--- 
-- 好友请求界面
-- @module view.mailandfriend.FriendRequestView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local CCRectMake = CCRectMake
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCSize = CCSize
local ccp = ccp
local display = display


local moduleName = "view.mailandfriend.FriendRequestView"
module(moduleName)


--- 
-- 类定义
-- @type FriendRequestView
-- 
local FriendRequestView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 点击cell弹出来的子面板
-- @field [parent=#FriendRequestView] #CCSprite _controlSprite
-- 
FriendRequestView._controlSprite = nil

---
-- 功能按钮表
-- @field [parent=#FriendRequestView] #table _btnTbl
-- 
FriendRequestView._btnTbl = nil

----- 
---- 操作box
---- @field [parent=#FriendRequestView] #ui.HBox#HBox _hBox
---- 
FriendRequestView._hBox = nil

---
-- 选中的cell
-- @field [parent=#FriendRequestView] #CCNode _selectCell
-- 
FriendRequestView._selectCell = nil

--- 
-- 构造函数
-- @function [parent=#FriendRequestView] ctor
-- @param self
-- 
function FriendRequestView:ctor()
	FriendRequestView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#FriendRequestView] _create
-- @param self
-- 
function FriendRequestView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_addrequset.ccbi", true)
	
	self:handleButtonEvent("allAddCcb.aBtn", self._addClkHandler)
	self:handleButtonEvent("allDelCcb.aBtn", self._delClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	box:setHCount(1)
	box:setVSpace(8)
	box.owner = self
	
	local FriendRequestCell = require("view.mailandfriend.FriendRequestCell")
	box:setCellRenderer(FriendRequestCell)
	
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	--创建子操作界面背景
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame("ccb/mark2/floattipbox.png")
	local rect = CCRectMake(51, 23, 190, 78)
	self._controlSprite = CCScale9Sprite:createWithSpriteFrame(frame, rect)
	self._controlSprite:setAnchorPoint(ccp(0,0))
	self._controlSprite:setPreferredSize(CCSize(247, 121))
	
	--子操作界面容器
	local HBox = require("ui.HBox")
	local box = HBox.new()
	box:setPosition(45, -10)
	box:setContentSize(CCSize(220, 115))
	box:setAnchorPoint(ccp(0,0))
	box:setClipEnabled(false)
	box:setHSpace(20)
	self._hBox = box
	self._controlSprite:addChild(self._hBox)
	
	--创建子操作按钮
	self._btnTbl = {}
	self:_createFunBtns()
	
	self._hBox:addItem(self._btnTbl["add"])
	self._hBox:addItem(self._btnTbl["del"])
	
	self:addChild(self._controlSprite)
	self._controlSprite:setVisible(false)
	
	--新建一个监听层
	local listenerLayer = display.newLayer(true)
	listenerLayer:setContentSize(node:getContentSize())
	listenerLayer:setAnchorPoint(ccp(0.5, 0.5))
	listenerLayer:addTouchEventListener(
		function (event, x, y)
			if self._controlSprite:isVisible() == false then
				return
			end
			
			local size = self._controlSprite:getContentSize()
			local pt = self._controlSprite:convertToNodeSpace(ccp(x, y))
			if (pt.x < 0) or (pt.x >  size.width) 
				or (pt.y < 0) or (pt.y > size.height) then
				self._controlSprite:setVisible(false)
			end
		end
	)	
	listenerLayer:setTouchEnabled(true)	
	self:addChild(listenerLayer)
	listenerLayer:setPosition(listenerLayer:getContentSize().width/2, listenerLayer:getContentSize().height/2)
end

---
-- 创建玩法功能图标集
-- @function [parent = #FriendRequestView] _createFunBtns()
-- 
function FriendRequestView:_createFunBtns()
	local GameView = require("view.GameView")
	
	local deletebtn = function()
		printf(tr("删除"))
		if not self._selectCell then return end
		if not self._selectCell:getInfo() then return end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_friend_del", {user_uid = self._selectCell:getInfo().user_uid, del_type = 3})
		
		self:deleteCellByUid(self._selectCell:getInfo().user_uid)
	end
	
	local addbtn = function()
		printf(tr("添加"))
		if not self._selectCell then return end
		if not self._selectCell:getInfo() then return end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_friend_add", {user_uid = self._selectCell:getInfo().user_uid})
	end
	
	local btnTable = {
		{["del"] = deletebtn},			--删除
		{["add"] = addbtn},				--添加
	}
	
	for i = 1, #btnTable do
		for k, v in pairs(btnTable[i]) do
			self:_addFunBtn(k, v)
		end
	end
end

---
-- 添加功能按钮
-- @function [parent=#FriendRequestView] _addFunBtn
-- @param self
-- @param #string icon 图标编号
-- @param #function func 回调事件
-- 
function FriendRequestView:_addFunBtn( icon, func )
	local ImageUtil = require("utils.ImageUtil")
	
	local frame = ImageUtil.getFrame("ccb/icon/"..icon..".png")
	
	local s = frame:getOriginalSize()
	local rect = frame:getRect()
	local backImage = CCScale9Sprite:createWithSpriteFrame(frame)
	
	local btn = CCControlButton:create()
	btn:setContentSize(CCSize(s.width, s.height))
	btn:setBackgroundSpriteForState(backImage, 1)
	btn:setPreferredSize(rect.size.width, rect.size.height)
	btn:retain()
	btn:setIsMainBtn(true)
	btn:setAnchorPoint(ccp(0.5,0.5))
	btn:setTouchPriority(-1)
	btn:addHandleOfControlEvent(function(...)
		if func ~= nil then
			func()
		end
	end, 32)
--	self._proxy:handleButtonEvent(btn, function( ... )
--		if func ~= nil then
--			func()
--		end
--	end, 0)
	
	local spr = display.newSprite()
	spr:setContentSize(CCSize(s.width, s.height))
	spr:retain()
	spr:addChild(btn)
	btn:setPosition(s.width/2, s.height/2)
	
	self._btnTbl[icon] = spr
end


---
-- 点击了全部添加
-- @function [parent=#FriendRequestView] _addClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FriendRequestView:_addClkHandler( sender, event )
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	local set = box:getDataSet()
	if not set then return end
	
	local arr = set:getArray()
	local GameNet = require("utils.GameNet")
	local info
	for i = 1, #arr do
		info = arr[i]
		if info then
			GameNet.send("C2s_friend_add", {user_uid = info.user_uid})
		end
	end
end

---
-- 点击了全部删除
-- @function [parent=#FriendRequestView] _delClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function FriendRequestView:_delClkHandler( sender, event )
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	local set = box:getDataSet()
	if not set then return end
	
	local arr = set:getArray()
	local GameNet = require("utils.GameNet")
	local info
	for i = 1, #arr do
		info = arr[i]
		if info then
			GameNet.send("C2s_friend_del", {user_uid = info.user_uid ,del_type = 3})
		end
	end
	
	set:removeAll()
end

---
-- 点击了关闭
-- @function [parent=#FriendRequestView] _closeClkHandler
-- @param self
-- @param #CCNode = sender
-- @param #table event
-- 
function FriendRequestView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#FriendRequestView] openUi
-- @param self
-- 
function FriendRequestView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_info", {get_type = 3})
end

---
-- 更新显示信息
-- @function [parent=#FriendRequestView] updateShowInfo
-- @param self
-- @param #table list
-- 
function FriendRequestView:updateShowInfo( list )
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	local dataset = box:getDataSet()
	if not list or #list == 0 then 
		box:setDataSet(nil)
		self["noInfoLab"]:setVisible(true)
		return 
	end
	
	local DataSet = require("utils.DataSet")
	if dataset then
		dataset:removeEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
	end
	
	function sortByTime(a, b)
		return a.add_time > b.add_time
	end
	
	local table = require("table")
	table.sort(list, sortByTime)
	
	self["noInfoLab"]:setVisible(false)
	local set = DataSet.new()
	set:setArray(list)
	box:setDataSet(set)
	
	set:addEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
end

--- 
-- 数据变化
-- @function [parent=#FriendRequestView] _dataChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event 数据集改变事件
-- 
function FriendRequestView:_dataChangedHandler( event )
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	local dataset = box:getDataSet()
	
	if not dataset or dataset:getLength() == 0  then 
		self["noInfoLab"]:setVisible(true)
		return 
	end
end

---
-- 更新选中的cell，根据cell确定子操作界面 位置
-- @function [parent=#FriendRequestView] updateSelectCell
-- @param self
-- @param #CCNode cell
-- 
function FriendRequestView:updateSelectCell( cell )
	if not cell.owner then return end
	self._selectCell = cell
	
	local x = cell:getPositionX()
	local y = cell:getPositionY()
	self._controlSprite:setPosition(ccp(x + 290, y + cell.owner._containerEndY + 54))
	self._controlSprite:setVisible(true)
end

---
-- 拖动
-- @function [parent=#FriendRequestView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function FriendRequestView:_scrollChangedHandler( event )
	self._controlSprite:setVisible(false)
end

---
-- 加了好友之后
-- @function [parent=#FriendRequestView] deleteCellByUid
-- @param self
-- @param #string uid
-- 
function FriendRequestView:deleteCellByUid( uid )
	if not uid or uid == "" then return end
	
	local box = self["friendsVCBox"] -- ui.CellBox#CellBox
	local set = box:getDataSet()
	if not set then return end
	
	local len = set:getLength()
	local item
	local index = 0
	for i = 1, len do
		item = set:getItemAt(i)
		if item and item.user_uid == uid then 
			index = i
		end
	end
	
	set:removeItemAt(index)
end

---
-- 退出界面时调用
-- @field [parent=#FriendRequestView] onExit
-- @param self
--
function FriendRequestView:onExit()
	instance = nil
	

	local box = self["friendsVCBox"]
 	box:setDataSet(nil)
	
	self.super.onExit(self)
end
