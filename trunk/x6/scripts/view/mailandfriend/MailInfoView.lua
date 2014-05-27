--- 
-- 信件信息界面
-- @module view.mailandfriend.MailInfoView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local os = os
local string = string


local moduleName = "view.mailandfriend.MailInfoView"
module(moduleName)


--- 
-- 类定义
-- @type MailInfoView
-- 
local MailInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 信件信息
-- @field [parent=#MailInfoView] #Mail_head_info _mailInfo
-- 
MailInfoView._mailInfo = nil

--- 
-- 构造函数
-- @function [parent=#MailInfoView] ctor
-- @param self
-- 
function MailInfoView:ctor()
	MailInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#MailInfoView] _create
-- @param self
-- 
function MailInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_mailinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("replyCcb.aBtn", self._replyClkHandler)
	self:handleButtonEvent("deleteCcb.aBtn", self._delClkHandler)
	self:handleButtonEvent("getCcb.aBtn", self._replyClkHandler)
end

---
-- 点击了关闭
-- @function [parent=#MailInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MailInfoView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#MailInfoView] openUi
-- @param self
-- 
function MailInfoView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 点击了提取附件， 回复
-- @function [parent=#MailInfoView] _replyClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MailInfoView:_replyClkHandler( sender, event )
	if not self._mailInfo then return end
	
	if self._mailInfo.mail_type == 1 then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_get_mail_attachment", {mail_id = self._mailInfo.mail_id})
	elseif self._mailInfo.mail_type == 2 then
		local SendMailView = require("view.mailandfriend.SendMailView")
		SendMailView.createInstance():openUi()
		SendMailView.createInstance():showMailInfo(self._mailInfo.uid, self._mailInfo.from, 2)
	end
end

---
-- 点击了删除
-- @function [parent=#MailInfoView] _delClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MailInfoView:_delClkHandler( sender, event )
	if not self._mailInfo then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_mail_del", {mail_id = self._mailInfo.mail_id})
	self:_closeClkHandler()
end

---
-- 显示邮件信息
-- @function [parent=#MailInfoView] showMailInfo
-- @param self
-- @param #Mail_head_info mail
-- 
function MailInfoView:showMailInfo( mail )
	if not mail then return end
	
	-- 敏感字符过滤
	local SensitiveWord = require("utils.SensitiveWord")
	local fliterStr = SensitiveWord.filter(mail.content) 
	mail.content = fliterStr
	
	self._mailInfo = mail
	local str = os.date("%c", mail.rev_time)
	str = string.gsub(str, "/", "-")
	self["timeLab"]:setString(str)
	
	--系统
	if mail.mail_type == 1 then
		self["nameLab"]:setString("<c1>来自：系统")
		self["typeLab"]:setString("<c5>(系统信件)")
		
		if mail.has_attachment == 1 then
			self["contentLab"]:setString(mail.content .. "\n<c1>奖励 \n" .. (mail.attachment_msg or ""))
		elseif mail.has_attachment == 0 then
			self["contentLab"]:setString(mail.content)
		elseif mail.has_attachment == 2 then
			self["contentLab"]:setString(mail.content .. "\n \n<c5>【已领取】")
		end
		
		if mail.has_attachment == 1 then
			self:showBtn("replyCcb", false)
			self["replyCcb.aBtn"]:setVisible(false)
			self:showBtn("getCcb", true)
			self["getCcb.aBtn"]:setVisible(true)
		else
			self:showBtn("replyCcb", false)
			self["replyCcb.aBtn"]:setVisible(false)
			self:showBtn("getCcb", false)
			self["getCcb.aBtn"]:setVisible(false)
		end
		
	--留言
	elseif mail.mail_type == 2 then
		self["nameLab"]:setString("<c1>来自：" .. mail.from)
		self["typeLab"]:setString("<c5>(玩家留言)")
		
		self["contentLab"]:setString(mail.content)
		
		self:showBtn("replyCcb", true)
		self["replyCcb.aBtn"]:setVisible(true)
		self:showBtn("getCcb", false)
		self["getCcb.aBtn"]:setVisible(false)
	--战斗
	elseif mail.mail_type == 3 then
		self["nameLab"]:setString("<c1>来自：系统")
		self["typeLab"]:setString("<c5>(战斗信件)")
		
		self["contentLab"]:setString(mail.content)
		
		self:showBtn("replyCcb", false)
		self["replyCcb.aBtn"]:setVisible(false)
		self:showBtn("getCcb", false)
		self["getCcb.aBtn"]:setVisible(false)
	end
	
end

---
-- 退出界面时调用
-- @field [parent=#MailInfoView] onExit
-- @param self
--
function MailInfoView:onExit()
	instance = nil
	
	MailInfoView.super.onExit(self)
end
