--- 
-- 好友请求界面Cell
-- @module view.mailandfriend.FriendRequestCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.mailandfriend.FriendRequestCell"
module(moduleName)


--- 
-- 类定义
-- @type FriendRequestCell
-- 
local FriendRequestCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 请求信息
-- @field [parent=#FriendRequestCell] #Friend_apply_info _applyInfo
-- 
FriendRequestCell._applyInfo = nil

--- 创建实例
-- @return FriendRequestCell实例
function new()
	return FriendRequestCell.new()
end

--- 
-- 构造函数
-- @function [parent=#FriendRequestCell] ctor
-- @param self
-- 
function FriendRequestCell:ctor()
	FriendRequestCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FriendRequestCell] _create
-- @param self
-- 
function FriendRequestCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_addrequsetpiece.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示请求信息
-- @function [parent=#FriendRequestCell] showItem
-- @param self
-- @param #Friend_apply_info info
-- 
function FriendRequestCell:showItem( info )
	self._applyInfo = info
	
	if not info then
		return
	end
	
	self["nameLab"]:setString( info.user_name )
	self["lvLab"]:setString("等级：" .. info.user_grade .. "级")
end

---
-- ui点击处理
-- @function [parent=#FriendRequestCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function FriendRequestCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._applyInfo ) then return end
	
	local view = self.owner.owner
	view:updateSelectCell(self)
end

---
-- 获取请求信息
-- @function [parent=#FriendRequestCell] getInfo
-- @param self
-- @return #Friend_apply_info
-- 
function FriendRequestCell:getInfo()
	return self._applyInfo
end

