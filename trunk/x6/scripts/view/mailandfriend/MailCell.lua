--- 
-- 邮件界面Cell
-- @module view.mailandfriend.MailCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local os = os
local string = string
local ccc3 = ccc3


local moduleName = "view.mailandfriend.MailCell"
module(moduleName)


--- 
-- 类定义
-- @type MailCell
-- 
local MailCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 邮件信息
-- @field [parent=#MailCell] #Mail_head_info _mailInfo
-- 
MailCell._mailInfo = nil

---
-- 按钮处理函数
-- @field [parent=#MailCell] #string _handleFunc
-- 
MailCell._handleFunc = nil

--- 创建实例
-- @return MailCell实例
function new()
	return MailCell.new()
end

--- 
-- 构造函数
-- @function [parent=#MailCell] ctor
-- @param self
-- 
function MailCell:ctor()
	MailCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#MailCell] _create
-- @param self
-- 
function MailCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_mailpiece.ccbi", true)
	
	self["contentLab"]:setColor(ccc3(0, 0, 0))
	self:createClkHelper(true)
	self:addClkUi(node)
	
	self:handleButtonEvent("aBtn", self._btnClkHandler)
end

---
-- 显示邮件基本信息
-- @function [parent=#MailCell] showItem
-- @param self
-- @param #Mail_head_info info
-- 
function MailCell:showItem( info )
	self._mailInfo = info
	
	if not info then
		return
	end
	
	self["pickSpr"]:setVisible(false)
	self["biWuSpr"]:setVisible(false)
	self["wuLinBangSpr"]:setVisible(false)
	self["duoBaoSpr"]:setVisible(false)
	self["enemySpr"]:setVisible(false)
	self["fuJianLab"]:setString("")
	
	local math = require("math")
	local days = math.floor((os.time() - info.rev_time) / (24 * 3600))
	
	local str
	-- 系统
	if info.mail_type == 1 then
		str = info.title .. "  " .. info.content
		if info.has_attachment == 1 then
			self["fuJianLab"]:setString("<c1>【附件：未提取】")
			self["aBtn"]:setVisible(true)
			self["pickSpr"]:setVisible(true)
			self._handleFunc = "getattachment"
		elseif info.has_attachment == 2 then
			self["fuJianLab"]:setString("<c5>【附件：已提取】")
			self["aBtn"]:setVisible(false)
		end
	-- 战斗
	elseif info.mail_type == 3 then
		self["aBtn"]:setVisible(true)
		str = info.title .. "  " .. info.content
		
		if info.mail_sub_type == 1 then
			self._handleFunc = "pk"
			self["biWuSpr"]:setVisible(true)
		elseif info.mail_sub_type == 2 then
			self._handleFunc = "rob"
			self["duoBaoSpr"]:setVisible(true)
		elseif info.mail_sub_type == 3 then
			self._handleFunc = "topofwulin_2"
			self["wuLinBangSpr"]:setVisible(true)
		elseif info.mail_sub_type == 4 then
			self._handleFunc = "enemy"
			self["enemySpr"]:setVisible(true)
		elseif info.mail_sub_type == 5 then
			-- 删除
			self["aBtn"]:setVisible(false)
		end
		
	-- 留言
	elseif info.mail_type == 2 then
		str = info.title .. "  " .. info.content
		self["aBtn"]:setVisible(false)
	else
		self["contentLab"]:setString("")
		self["aBtn"]:setVisible(false)
		return
	end
	
	local StringUtil = require("utils.StringUtil")
	local chars = StringUtil.utf8Chars(str)
	local len = 0
	local newstr = ""
	local first = true
	for i = 1, #chars do
		local char = chars[i]
		if string.len(char) > 1 then
			len = len + 2
		else
			len = len + 1
		end
		
		if len <= 100 then
			newstr = newstr .. char
		elseif first then
			first = false
			newstr = newstr .. "<c0> ..."
		end
	end
	
	if days > 0 then
		newstr = newstr .. "<c0>(" .. days .. "天前)"
	end
	
	self["contentLab"]:setString(newstr)
end

---
-- ui点击处理
-- @function [parent=#MailCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function MailCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._mailInfo ) then return end
	
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView")
	if MailAndFriendView.instance then
		MailAndFriendView.instance:updateSelectCell(self)
	end
end

---
-- 获取邮件信息
-- @function [parent=#MailCell] getInfo
-- @param self
-- @return #Mail_head_info
-- 
function MailCell:getInfo()
	return self._mailInfo
end

---
-- 按钮点击处理函数
-- @function [parent=#MailCell] _btnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MailCell:_btnClkHandler(sender, event)
	if not self._handleFunc then return end
	
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView").instance
	if not MailAndFriendView then return end
	
	MailAndFriendView:setSelectCell(self)
	MailAndFriendView.funcTbl[self._handleFunc]()
end
