---
-- 聊天协议处理
-- @module protocol.handler.ChatHandler
-- 

local require = require
local printf = printf
local tr = tr
local os = os
local CONFIG = CONFIG

local modalName = "protocol.handler.ChatHandler"
module(modalName)

local GameNet = require("utils.GameNet")

---
-- 服务器弹框
-- 
GameNet["S2c_question_ask"] = function( pb )
	local Alert = require("view.notify.Alert")

	local item1 = {text=pb.yes_label}
	item1.listener = function( ... )
		local pbObj = {question_id=pb.question_id,answer=1}
		GameNet.send("C2s_question_answer", pbObj)
	end
	
	local item2 = {text=pb.no_label}
	item2.listener = function( ... )
		local pbObj = {question_id=pb.question_id,answer=2}
		GameNet.send("C2s_question_answer", pbObj)
	end
	
	local alert = Alert.show({text=pb.title}, {item1,item2})
	
	if( pb.timeout<=0 ) then return end
	
	local scheduler = require("framework.client.scheduler")
	scheduler.performWithDelayGlobal(function(...)
		alert:removeSelf(true)
		
		local pbObj = {question_id=pb.question_id,answer=3}
		GameNet.send("C2s_question_answer", pbObj)
	end, pb.timeout)
end

---
-- 聊天公告
-- 
GameNet["S2c_chat_info"] = function( pb )

end

---
-- 系统提示
-- 
GameNet["S2c_chat_system"] = function( pb )
	if pb. type == 1 then
	
	elseif pb. type == 2 then
		if pb.isshow == 0 then --表示不用立即显示
			local isInBattle = require("view.fight.FightCCBView").isInBattle()
			if isInBattle == true then
				local ChatData = require("model.ChatData")
				ChatData.addDelayMsg(pb.msg)
			else
				local FloatNotify = require("view.notify.FloatNotify") 
				FloatNotify.show( pb.msg )
			end
		elseif pb.isshow == 1 then --表示立即显示
			local FloatNotify = require("view.notify.FloatNotify") 
			FloatNotify.show( pb.msg )
		end
	elseif pb. type == 3 then
		
	elseif pb. type == 4 then
		local msg = {}
		msg.channel = 1
		msg.info = tr("系统") .. pb.msg
		local ChatData = require("model.ChatData")
		ChatData.addChatItem( msg )
	elseif pb. type == 5 then
		local msg = {}
		msg.channel = 1
		msg.info = tr("公告") .. pb.msg
		local ChatData = require("model.ChatData")
		ChatData.addChatItem( msg )
	end
	
--	if pb.isshow == 0 then --表示不用立即显示
--	elseif pb.isshow == 1 then --表示立即显示
--	end
end

---
-- 公共聊天
-- 
GameNet["S2c_chat_public"] = function( pb )
	if not pb then return end
	local chatMsg = {}
	chatMsg.channel = 1
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Id == pb.chat_id then
		chatMsg.type = 1
	else
		chatMsg.type = 2
	end
	
	chatMsg.name = pb.chat_name
	
	local SensitiveWord = require("utils.SensitiveWord")
	local str = SensitiveWord.filter(pb.chat_msg)
	chatMsg.info = str
	chatMsg.id = pb.chat_id
	
	local ChatData = require("model.ChatData")
	ChatData.addChatItem( chatMsg )
	
	if pb.send_type > 0 then
		-- 大喇叭
		if pb.send_type == 1 then
			local msg = {}
			msg.info = pb.chat_name .. "：" .. str
			msg.times = 1
			local SysInfoLogic = require("logic.SysInfoLogic")
			SysInfoLogic.showInfo(msg)
		end
		
		local ChatView = require("view.chat.ChatView")
		if ChatView.instance then
			chatMsg.starttime = os.time()
			ChatView.instance:showTopMessage(chatMsg)
		end
	end
	
	local MainView = require("view.main.MainView")
	if MainView.instance then
		MainView.instance:showChatMsg( str )
	end
end

---
-- 私聊
-- 
GameNet["S2c_chat_private"] = function( pb )
	if not pb then return end
	
	local chatMsg = {}
	chatMsg.channel = 2
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Id == pb.src_cid then
		chatMsg.type = 1
		chatMsg.name = pb.dst_name
		chatMsg.id = pb.dst_cid
	else
		chatMsg.type = 2
		chatMsg.name = pb.src_name
		chatMsg.id = pb.src_cid
	end
	
	local SensitiveWord = require("utils.SensitiveWord")
	local str = SensitiveWord.filter(pb.chat_msg)
	chatMsg.info = str
	
	local ChatData = require("model.ChatData")
	ChatData.addChatItem( chatMsg )
end

---
-- 提示
-- 
GameNet["S2c_chat_notify"] = function( pb )

end

---
-- 弹窗提示
-- 
GameNet["S2c_chat_confirm"] = function( pb )

end

---
-- 弹出充值框
-- 
GameNet["S2c_chat_chongzhi"] = function( pb )

end

---
-- pvp消息推送
-- 
GameNet["S2c_chat_pvpinfo"] = function( pb )
	if not pb then return end
	
	local PvpMessage = require("view.notify.PvpMessage")
	PvpMessage.show(pb.info)
end

---
-- 系统公告
-- 
GameNet["S2c_chat_sysinfo"] = function( pb )
	local SysInfoLogic = require("logic.SysInfoLogic")
	SysInfoLogic.showInfo(pb)
	
	local chatMsg = {}
	chatMsg.channel = 3
	local SensitiveWord = require("utils.SensitiveWord")
	local str = SensitiveWord.filter(pb.info)
	chatMsg.info = tr("<c5>系统：</c>"..str)
	
	local ChatData = require("model.ChatData")
	ChatData.addChatItem( chatMsg )
end

---
-- 应用信息
-- 
GameNet["S2c_chat_appinfo"] = function( pb )
	local device = require("framework.client.device")
	if device.platform=="android" then
		local className = "org/cocos2dx/lib/Cocos2dxHelper"
		local methodName = "pushNotify"
		local args = {0, pb.info, "", pb.info, true, 0}
		local sig  = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZI)V"
		
		local luaj = require("framework.client.luaj")
		luaj.callStaticMethod(className, methodName, args, sig)
	elseif device.platform=="ios" then
		local className = "CCLocalNotify"
		local methodName = "pushNotifyToIos"
		local args = {
			body = pb.info,
			--action = tr("查看"),
			delay = 0
		}
		local luaoc = require("framework.client.luaoc")
		luaoc.callStaticMethod(className, methodName, args)
	end
end

---
-- 聊天室玩家列表
-- 
GameNet["S2c_chat_onlines"] = function( pb )
	--dump(pb)
	local ChatPlayerUi = require("view.chat.ChatPlayerUi")
	if ChatPlayerUi.instance and ChatPlayerUi.instance:isVisible() then
		ChatPlayerUi.instance:showPlayerList( pb.online_list )
	end
end

---
-- 收到切磋邀请
-- 
GameNet["S2c_chat_pk"] = function( pb )
	local ChatReceiveFightUi = require("view.chat.ChatReceiveFightUi")
	ChatReceiveFightUi.createInstance():openUi( pb )
end

---
-- 邀请被拒绝
-- 
GameNet["S2c_chat_pk_reject"] = function( pb )
	--目前不判断id
	if pb.is_ok == 1 then return end -- 对方接受邀请
	
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("对方不愿与你交手！"))
	
	local ChatView = require("view.chat.ChatView")
	if ChatView.instance and ChatView.instance:getParent() then
		ChatView.instance:inviteIsRefused()
	end
	
	local ChatInviteFightUi = require("view.chat.ChatInviteFightUi")
	if ChatInviteFightUi.instance and ChatInviteFightUi.instance:getParent() then
		ChatInviteFightUi.instance:closeUi()
	end
end


---
-- pk结果
-- 
GameNet["S2c_chat_pk_result"] = function( pb )
	if not pb then return end 
	
	pb.structType = {}
	pb.structType.name = "S2c_chat_pk_result"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 邀请切磋成功
-- 
GameNet["S2c_chat_pk_tome"] = function( pb )
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	if pb.is_ok == 0 then
		return 
	end
	
	local ChatCtrlUi = require("view.chat.ChatCtrlUi")
	local info = ChatCtrlUi.createInstance():getPlayerInfo()
	if not info then return end
	
	local ChatView = require("view.chat.ChatView")
	if ChatView.instance and ChatView.instance:getParent() then
		info.starttime = os.time()
		ChatView.instance:invitePkSucceed(info)
	end
	
	local ChatInviteFightUi = require("view.chat.ChatInviteFightUi")
	ChatInviteFightUi.createInstance():openUi(info)
end

---
-- 防沉迷信息
-- 
GameNet["S2c_chat_chenmi"] = function( pb )
	-- 防沉迷
	local ConfigParams = require("model.const.ConfigParams")
	if CONFIG[ConfigParams.IS_FCM] and CONFIG[ConfigParams.IS_FCM]>0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show( pb.info )
		
		-- 聊天界面显示此系统公告
		local chatMsg = {}
		chatMsg.channel = 3
		local SensitiveWord = require("utils.SensitiveWord")
		local str = SensitiveWord.filter(pb.info)
		chatMsg.info = tr("<c5>系统：</c>"..str)
		
		local ChatData = require("model.ChatData")
		ChatData.addChatItem( chatMsg )
	end
end