---
-- 好友协议处理
-- @module protocol.handler.FriendHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local ipairs = ipairs
local tr = tr

local modalName = "protocol.handler.FriendHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 好友信息列表
--  
GameNet["S2c_friend_info"] = function( pb )
	if not pb then return end 
	-- 界面显示
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView")
	if MailAndFriendView.instance and MailAndFriendView.instance:getParent() then
		MailAndFriendView.instance:showFriendInfo( pb )
		return
	end
	
	-- 非界面显示
--	MailAndFriendView.new():showFriendInfo( pb )
	
end

---
-- 仇人信息列表
-- 
GameNet["S2c_friend_enemy_info"] = function( pb )
	if not pb then return end 
	
	-- 界面显示
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView")
	if MailAndFriendView.instance and MailAndFriendView.instance:getParent() then
		MailAndFriendView.instance:showEnemyInfo(pb)
		return
	end
	-- 非界面显示
--	MailAndFriendView.new():showEnemyInfo( pb )
end

---
-- 好友申请列表
-- 
GameNet["S2c_friend_apply_info"] = function(pb)
	if not pb then return end 
	
	local FriendRequestView = require("view.mailandfriend.FriendRequestView")
	if FriendRequestView.instance and FriendRequestView.instance:getParent() then
		FriendRequestView.instance:updateShowInfo( pb.apply_list )
	end
end

---
-- 好友推荐列表
-- 
GameNet["S2c_friend_tuijian_info"] = function(pb)
	if not pb then return end
	
	local AddFriendView = require("view.mailandfriend.AddFriendView")
	if AddFriendView.instance and AddFriendView.instance:getParent() then
		AddFriendView.instance:updateShowInfo( pb.tuijian_list )
	end
end

---
-- 添加好友返回
-- 
GameNet["S2c_friend_add_result"] = function( pb )
	if not pb then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("好友添加成功！"))
	
	-- 删除好友推荐里面cell
	local AddFriendView = require("view.mailandfriend.AddFriendView")
	if AddFriendView.instance and  AddFriendView.instance:getParent() then
		AddFriendView.instance:deleteCellByUid(pb.user_uid)
	end
	
	-- 删除好友申请里面的cell
	local FriendRequestView = require("view.mailandfriend.FriendRequestView")
	if FriendRequestView.instance and FriendRequestView.instance:getParent() then
		FriendRequestView.instance:deleteCellByUid(pb.user_uid)
	end
end

---
-- 战斗结果
-- 
GameNet["S2c_friend_pk_result"] = function(pb)
	if not pb then return end 
	
	local GameView = require("view.GameView")
	if pb.is_win == 0 then
		local RevengeLoseView = require("view.mailandfriend.RevengeLoseView")
		RevengeLoseView.setRewardMsg(pb)
	else
		local RevengeWinView = require("view.mailandfriend.RevengeWinView")
		RevengeWinView.setRewardMsg(pb)
	end
	
	pb.structType = {}
	pb.structType.name = "S2c_friend_pk_result"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 发送邮件成功
-- 
GameNet["S2c_friend_send_msg"] = function( pb )
	if not pb then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if pb.send_ok == 1 then
		FloatNotify.show(tr("操作成功！"))
		local SendMailView = require("view.mailandfriend.SendMailView").instance
		if SendMailView then
			local GameView = require("view.GameView")
			GameView.removePopUp(SendMailView)
		end
	else
		FloatNotify.show(tr("操作失败！"))
	end
end
