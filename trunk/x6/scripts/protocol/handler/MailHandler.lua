---
-- 信件协议处理
-- @module protocol.handler.MailHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local ipairs = ipairs
local tostring = tostring

local modalName = "protocol.handler.MailHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 邮件基本列表
--  
GameNet["S2c_mail_list"] = function( pb )
	if not pb then return end 
	
	local MailData = require("model.MailData")
	MailData.updateAllMail( pb.mail_head_list )
	
end

---
-- 新邮件
-- 
GameNet["S2c_mail_new"] = function( pb )
	if not pb then return end 
	
	local MailData = require("model.MailData")
	MailData.addMail( pb.new_mail )
end

---
-- 删除邮件
-- 
GameNet["S2c_mail_del_result"] = function( pb )
	if not pb then return end 
	
--	printf("mail_id :" .. pb.mail_id)
	local MailData = require("model.MailData")
	MailData.removeMail( pb.mail_id )
end

---
-- 获取附件
-- 
GameNet["S2c_get_mail_attachment"] = function(pb)
	if not pb then return end 
	
	if pb.success == 1 then
		local info = {}
		info["has_attachment"] = 2
		local MailData = require("model.MailData")
		MailData.updateMailInfo( pb.mail_id, info )
		
		local MailInfoView = require("view.mailandfriend.MailInfoView")
		if MailInfoView.instance and MailInfoView.instance:getParent() then
			local mail = MailData.findMail(pb.mail_id)
			if mail then
				MailInfoView.instance:showMailInfo(mail)
			end
		end
	end
end

---
-- 新标记更新
-- 
GameNet["S2c_mail_new_mail"] = function( pb )
	if not pb then return end
	
	local MailData = require("model.MailData")
	if pb.mail_type == 1 then
		MailData.newSystemMail = true
	elseif pb.mail_type == 2 then
		MailData.newMessageMail = true
	elseif pb.mail_type == 3 then
		MailData.newFightMail = true
	elseif pb.mail_type == 4 then
		MailData.newFriendRequest = true
	end
	
	local MainView = require("view.main.MainView").instance
	if MainView then
		MainView:showNewMailIcon(true)
	end
	
	local MailEvents = require("model.event.MailEvents")
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local event = MailEvents.NEW_MAIL_UPDATED
	EventCenter:dispatchEvent(event)
end
