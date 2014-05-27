--- 
-- 添加好友界面
-- @module view.mailandfriend.AddFriendView
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
local print = print


local moduleName = "view.mailandfriend.AddFriendView"
module(moduleName)


--- 
-- 类定义
-- @type AddFriendView
-- 
local AddFriendView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 点击cell弹出来的子面板
-- @field [parent=#AddFriendView] #CCSprite _controlSprite
-- 
AddFriendView._controlSprite = nil

---
-- 功能按钮表
-- @field [parent=#AddFriendView] #table _btnTbl
-- 
AddFriendView._btnTbl = nil

----- 
---- 操作box
---- @field [parent=#AddFriendView] #ui.HBox#HBox _hBox
---- 
AddFriendView._hBox = nil

---
-- 选中的cell
-- @field [parent=#AddFriendView] #CCNode _selectCell
-- 
AddFriendView._selectCell = nil

--- 
-- 构造函数
-- @function [parent=#AddFriendView] ctor
-- @param self
-- 
function AddFriendView:ctor()
	AddFriendView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#AddFriendView] _create
-- @param self
-- 
function AddFriendView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_addfriend.ccbi", true)
	
	self:handleButtonEvent("addCcb.aBtn", self._addClkHandler)
	self:handleButtonEvent("moreBtn", self._moreClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	self["nameEdit"]:setFont("Helvetica", 20)
	self["nameEdit"]:setPlaceHolder(tr("请输入昵称"))
	
	local box = self["infosVCBox"] -- ui.CellBox#CellBox
	box:setHCount(1)
	box:setVSpace(8)
	box.owner = self
	
	local AddFriendCell = require("view.mailandfriend.AddFriendCell")
	box:setCellRenderer(AddFriendCell)
	
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	--创建子操作界面背景
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame("ccb/mark2/floattipbox.png")
	local rect = CCRectMake(51, 23, 190, 78)
	self._controlSprite = CCScale9Sprite:createWithSpriteFrame(frame, rect)
	self._controlSprite:setAnchorPoint(ccp(0,0))
	self._controlSprite:setPreferredSize(CCSize(145, 121))
	
	--子操作界面容器
	local HBox = require("ui.HBox")
	local box = HBox.new()
	box:setPosition(45, -10)
	box:setHSpace(20)
	box:setContentSize(CCSize(105, 115))
	box:setAnchorPoint(ccp(0,0))
	box:setClipEnabled(false)
	self._hBox = box
	self._controlSprite:addChild(self._hBox)
	
	--创建子操作按钮
	self._btnTbl = {}
	self:_createFunBtns()
	
	self._hBox:addItem(self._btnTbl["add"])
	
	self:addChild(self._controlSprite)
	self._controlSprite:setVisible(false)
	
	--新建一个监听层
	local listenerLayer = display.newLayer(true)
	listenerLayer:setContentSize(self:getContentSize())
	listenerLayer:setAnchorPoint(ccp(0, 0))
	listenerLayer:addTouchEventListener(
		function (event, x, y)
--			printf("=================================")
--			printf("x = " .. x .. ", y = " .. y)
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
	listenerLayer:setPosition(0, 0)
	
end

---
-- 创建玩法功能图标集
-- @function [parent = #AddFriendView] _createFunBtns()
-- 
function AddFriendView:_createFunBtns()
	local GameView = require("view.GameView")
	
	local addbtn = function()
		printf(tr("添加"))
		if not self._selectCell then return end
		if not self._selectCell:getInfo() then return end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_friend_add", {user_uid = self._selectCell:getInfo().user_uid})
		
	end
	
	local btnTable = {
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
-- @function [parent=#AddFriendView] _addFunBtn
-- @param self
-- @param #string icon 图标编号
-- @param #function func 回调事件
-- 
function AddFriendView:_addFunBtn( icon, func )
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
-- 点击了添加
-- @function [parent=#AddFriendView] _addClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function AddFriendView:_addClkHandler( sender, event ) 
	local text = self["nameEdit"]:getText()
	if not text or text == "" then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("请先输入你要加为好友的昵称！"))
		return
	end 
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_add_toname", {user_name = text})
end

---
-- 点击了更多推荐
-- @function [parent=#AddFriendView] _moreClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function AddFriendView:_moreClkHandler( sender, event )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_info", {get_type = 4})
end

---
-- 点击了关闭
-- @function [parent=#AddFriendView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function AddFriendView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#AddFriendView] openUi
-- @param self
-- 
function AddFriendView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	self:_moreClkHandler()
	
	self["nameEdit"]:setText("")
end

---
-- 显示推荐列表
-- @function [parent=#AddFriendView] updateShowInfo
-- @param self
-- @param #table list
-- 
function AddFriendView:updateShowInfo( list )
	local box = self["infosVCBox"] -- ui.CellBox#CellBox
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
	
	self["noInfoLab"]:setVisible(false)
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(list)
	box:setDataSet(set)
	
	set:addEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
end

--- 
-- 数据变化
-- @function [parent=#AddFriendView] _dataChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event 数据集改变事件
-- 
function AddFriendView:_dataChangedHandler( event )
	local box = self["infosVCBox"] -- ui.CellBox#CellBox
	local dataset = box:getDataSet()
	
	if not dataset or dataset:getLength() == 0  then 
		self["noInfoLab"]:setVisible(true)
		return 
	end
end

---
-- 更新选中的cell，根据cell确定子操作界面 位置
-- @function [parent=#AddFriendView] updateSelectCell
-- @param self
-- @param #CCNode cell
-- 
function AddFriendView:updateSelectCell( cell )
	printf("clk the cell")
	if not cell.owner then return end
	self._selectCell = cell
	
	local x = cell:getPositionX()
	local y = cell:getPositionY()
	self._controlSprite:setPosition(ccp(x + 290, y + cell.owner._containerEndY + 54))
	self._controlSprite:setVisible(true)
end

---
-- 拖动
-- @function [parent=#AddFriendView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function AddFriendView:_scrollChangedHandler( event )
	self._controlSprite:setVisible(false)
end

---
-- 加了好友之后
-- @function [parent=#AddFriendView] deleteCellByUid
-- @param self
-- @param #string uid
-- 
function AddFriendView:deleteCellByUid( uid )
	if not uid or uid == "" then return end
	
	local box = self["infosVCBox"] -- ui.CellBox#CellBox
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
-- @field [parent=#AddFriendView] onExit
-- @param self
--
function AddFriendView:onExit()
	instance = nil
	
	self["infosVCBox"]:setDataSet(nil)
	AddFriendView.super.onExit(self)
end
