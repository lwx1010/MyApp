--- 
-- 发送信件
-- @module view.mailandfriend.SendMailView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local display = display
local transition = transition
local CCSize = CCSize


local moduleName = "view.mailandfriend.SendMailView"
module(moduleName)


--- 
-- 类定义
-- @type SendMailView
-- 
local SendMailView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 邮件对象uid
-- @field [parent=#SendMailView] #string _targetUid
-- 
SendMailView._targetUid = ""

--- 
-- 构造函数
-- @function [parent=#SendMailView] ctor
-- @param self
-- 
function SendMailView:ctor()
	SendMailView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SendMailView] _create
-- @param self
-- 
function SendMailView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_sendmail.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("clearCcb.aBtn", self._clearClkHandler)
	self:handleButtonEvent("sendCcb.aBtn", self._sendClkHandler)
	
	local size = self["inputEdit"]:getContentSize()
--	printf("size:" .. size.width .. ", " .. size.height)
	
	self["inputEdit"]:setScaleX(1)
	self["inputEdit"]:setScaleY(1)
	self["inputEdit"]:setFont("Helvetica", 18)
	local editLabel = self["inputEdit"]:getEditLabel()
	local placeHolderLabel = self["inputEdit"]:getPlaceHolderLabel()
	editLabel:setHorizontalAlignment(0)
	editLabel:setVerticalAlignment(0)
	placeHolderLabel:setHorizontalAlignment(0)
	placeHolderLabel:setVerticalAlignment(0)
	editLabel:setContentSize(CCSize(410,200))
	placeHolderLabel:setContentSize(CCSize(410,200))
	editLabel:setDimensions(CCSize(410,200))
	placeHolderLabel:setDimensions(CCSize(410,200))
	
--	printf("labelsize: " .. editLabel:getContentSize().width .. ", " .. editLabel:getContentSize().height)
--	printf("holdersize: " .. placeHolderLabel:getContentSize().width .. ", " .. placeHolderLabel:getContentSize().height)
--	
--	printf("labelpos: " .. editLabel:getPositionX() .. ", " .. editLabel:getPositionY())
--	printf("holderpos: " .. placeHolderLabel:getPositionX() .. ", " .. placeHolderLabel:getPositionY())
	
	self["inputEdit"]:setPlaceHolder(tr("请输入信件内容..."))
end

---
-- 点击了关闭
-- @function [parent=#SendMailView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SendMailView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#SendMailView] openUi
-- @param self
-- 
function SendMailView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["inputEdit"]:setText("")
end

---
-- 点击了清空
-- @function [parent=#SendMailView] _clearClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SendMailView:_clearClkHandler( sender, event )
	self["inputEdit"]:setText("")
end

---
-- 点击了发送
-- @function [parent=#SendMailView] 
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SendMailView:_sendClkHandler( sender, event )
	if self._targetUid == "" then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("邮件目标错误！"))
		return
	end
	
	local text = self["inputEdit"]:getText()
	
	-- 敏感字符过滤
	local SensitiveWord = require("utils.SensitiveWord")
	text = SensitiveWord.filter(text) 
	
	local titleInfo = self["nameLab"]:getString()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_friend_send_msg", {rev_uid = self._targetUid, title = titleInfo, content = text})
end

---
-- 显示邮件信息
-- @function [parent=#SendMailView] showMailInfo
-- @param self
-- @param #string uid
-- @param #string name
-- @param #number type 类型：1留言，2回复
-- 
function SendMailView:showMailInfo( uid, name, type )
	if not uid then return end
	
	self._targetUid = uid
	
	if type == 1 then
		self["nameLab"]:setString("<c1>留言：" .. name )
	elseif type == 2 then
		self["nameLab"]:setString("<c1>回复：" .. name )
	end
end

---
-- 退出界面时调用
-- @field [parent=#SendMailView] onExit
-- @param self
--
function SendMailView:onExit()
	instance = nil
	
	SendMailView.super.onExit(self)
end
