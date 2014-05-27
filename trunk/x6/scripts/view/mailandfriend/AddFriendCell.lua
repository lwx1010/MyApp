--- 
-- 添加好友界面推荐Cell
-- @module view.mailandfriend.AddFriendCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.mailandfriend.AddFriendCell"
module(moduleName)


--- 
-- 类定义
-- @type AddFriendCell
-- 
local AddFriendCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 推荐信息
-- @field [parent=#AddFriendCell] #Friend_tuijian_info _tuiJianInfo
-- 
AddFriendCell._tuiJianInfo = nil

--- 创建实例
-- @return AddFriendCell实例
function new()
	return AddFriendCell.new()
end

--- 
-- 构造函数
-- @function [parent=#AddFriendCell] ctor
-- @param self
-- 
function AddFriendCell:ctor()
	AddFriendCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#AddFriendCell] _create
-- @param self
-- 
function AddFriendCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_addfriendpiece.ccbi", true)
	
--	self["onlineLab"]:setHorizontalAlignment(2)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示 推荐信息
-- @function [parent=#AddFriendCell] showItem
-- @param self
-- @param #Friend_tuijian_info info
-- 
function AddFriendCell:showItem( info )
	self._tuiJianInfo = info
	
	if not info then
		return
	end
	
	self["nameLab"]:setString( info.user_name )
	self["lvLab"]:setString("等级：" .. info.user_grade .. "级")
	if info.user_online == 1 then
		self["onlineLab"]:setString("<c1>(当前在线)")
	else
		self["onlineLab"]:setString("(离线)")
	end
end

---
-- ui点击处理
-- @function [parent=#AddFriendCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function AddFriendCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._tuiJianInfo ) then return end
	
	local view = self.owner.owner
	view:updateSelectCell(self)
end

---
-- 获取推荐信息
-- @function [parent=#AddFriendCell] getInfo
-- @param self
-- @return #Friend_tuijian_info
-- 
function AddFriendCell:getInfo()
	return self._tuiJianInfo
end

