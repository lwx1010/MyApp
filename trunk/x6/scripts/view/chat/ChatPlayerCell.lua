--- 
-- 聊天室玩家信息
-- @module view.chat.ChatPlayerCell
-- 

local class = class
local printf = printf
local require = require
local ccp = ccp


local moduleName = "view.chat.ChatPlayerCell"
module(moduleName)

--- 
-- 类定义
-- @type ChatPlayerCell
-- 
local ChatPlayerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 玩家
-- @field [parent=#ChatPlayerCell] #table _playerInfo
-- 
ChatPlayerCell._playerInfo = nil

--- 创建实例
-- @return ItemCell实例
function new()
	return ChatPlayerCell.new()
end

--- 
-- 构造函数
-- @function [parent=#ChatPlayerCell] ctor
-- @param self
-- 
function ChatPlayerCell:ctor()
	ChatPlayerCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ChatPlayerCell] _create
-- @param self
-- 
function ChatPlayerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat_userbox.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

--- 
-- 显示数据
-- @function [parent=#ChatPlayerCell] showItem
-- @param self
-- @param #table info 玩家信息
-- 
function ChatPlayerCell:showItem( info )
	self._playerInfo = info
	
	if not info then
		return
	end
	
	self["nameLab"]:setString("" .. info.name)
	self["lvLab"]:setString("Lv " .. info.grade)
end

---
-- ui点击处理
-- @function [parent=#ChatPlayerCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function ChatPlayerCell:uiClkHandler( ui, rect )
	printf("1111")
	if( not self.owner or not self._playerInfo ) then return end
	printf("1112")
	local cellx = self:getPositionX()
	local celly = self:getPositionY()
	local pt = 	self:convertToWorldSpace(ccp(self:getContentSize().width/2, self:getContentSize().height/2))
	
	local x = pt.x
	local y = pt.y 
	
	local info = {}
	info.id = self._playerInfo.user_id
	info.name = self._playerInfo.name
	local ChatCtrlUi = require("view.chat.ChatCtrlUi")
	ChatCtrlUi.createInstance():openUi(x, y, info)
end