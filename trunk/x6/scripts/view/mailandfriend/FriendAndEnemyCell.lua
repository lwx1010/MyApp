--- 
-- 好友仇人界面Cell
-- @module view.mailandfriend.FriendAndEnemyCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local ccc3 = ccc3


local moduleName = "view.mailandfriend.FriendAndEnemyCell"
module(moduleName)


--- 
-- 类定义
-- @type FriendAndEnemyCell
-- 
local FriendAndEnemyCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#FriendAndEnemyCell] #Friend_info _info
-- 
FriendAndEnemyCell._info = nil

---  
-- 是否选中
-- @field [parent=#FriendAndEnemyCell] #boolean _selected
-- 
FriendAndEnemyCell._selected = false

---
-- 是否好友
-- @field [parent=#FriendAndEnemyCell] #boolean _isFriend
-- 
FriendAndEnemyCell._isFriend = false

--- 创建实例
-- @return FriendAndEnemyCell实例
function new()
	return FriendAndEnemyCell.new()
end

--- 
-- 构造函数
-- @function [parent=#FriendAndEnemyCell] ctor
-- @param self
-- 
function FriendAndEnemyCell:ctor()
	FriendAndEnemyCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#FriendAndEnemyCell] _create
-- @param self
-- 
function FriendAndEnemyCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_friendandenemylist.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示信息
-- @function [parent=#FriendAndEnemyCell] name
-- @param self
-- @param #Friend_info info
-- 
function FriendAndEnemyCell:showItem( info )
	self._info = info
	
	if not self._info then
		
		return
	end
	
	if not self.owner or not self.owner.owner then return end
	local view = self.owner.owner
	self._isFriend = view.isFriend
	
	self["nameLab"]:setString(info.user_name)
	
	if self._isFriend then
		self["lvLab"]:setString("等级：" .. info.user_grade .. "级")
		
		--这个lab在好友这边显示是否在线，敌人显示战力
		if info.user_online == 1 then
			self["scoreLab"]:setString("<c1>(当前在线)")
		elseif info.user_online == 2 then
			self["scoreLab"]:setString("<c5>(活跃的)")
		else
			self["scoreLab"]:setString("<c0>(离线)")
		end
		
		self["enemySpr"]:setVisible(false)
		if info.is_mutual > 0 then
			self["friendSpr"]:setVisible(true)
		else
			self["friendSpr"]:setVisible(false)
		end
	else
		local HeroAttr = require("model.HeroAttr")

		if info.user_grade > (HeroAttr.Grade or 0) then
			self["lvLab"]:setString("<c5>等级：" .. info.user_grade .. "级")
		else
			self["lvLab"]:setString("<c1>等级：" .. info.user_grade .. "级")
		end
		
		if info.user_score > (HeroAttr.Score or 0) then
			self["scoreLab"]:setString("<c5>战力：" .. info.user_score)
		else
			self["scoreLab"]:setString("<c1>战力：" .. info.user_score)
		end
		
		self["friendSpr"]:setVisible(false)
		if info.is_mutual > 0 then
			self["enemySpr"]:setVisible(true)
		else
			self["enemySpr"]:setVisible(false)
		end
	end
end


---
-- ui点击处理
-- @function [parent=#FriendAndEnemyCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function FriendAndEnemyCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._info ) then return end
	
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView")
	if MailAndFriendView.instance then
		MailAndFriendView.instance:updateSelectCell(self)
	end
end

---
-- 获取cell信息
-- @function [parent=#FriendAndEnemyCell] getInfo
-- @param self
-- @return #Friend_info
-- 
function FriendAndEnemyCell:getInfo()
	return self._info
end

