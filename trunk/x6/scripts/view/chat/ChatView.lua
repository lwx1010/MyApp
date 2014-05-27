--- 
-- 聊天界面
-- @module view.chat.ChatView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tonumber = tonumber
local tr = tr
local os = os
local CCMoveTo = CCMoveTo
local transition = transition
local CCCallFunc = CCCallFunc
local ccp = ccp
local dump = dump
local CCSize = CCSize
local CCDelayTime = CCDelayTime
local display = display

local moduleName = "view.chat.ChatView"
module(moduleName)


--- 
-- 类定义
-- @type ChatView
-- 
local ChatView = class(moduleName, require("ui.CCBView").CCBView)


---
-- 当前选中的玩家信息（id，name）
-- @field [parent=#ChatView] #table _curPlayerInfo
-- 
--ChatView._curPlayerInfo = nil

---
-- 当前私聊对象信息
--  @field [parent=#ChatView] #table _chatTargetInfo
--  
ChatView._chatTargetInfo = nil

---
-- 当前聊天频道 :1当前， 2私聊
-- @field [parent=#ChatView] #number _channelType
-- 
ChatView._channelType = 1

---
-- 当前聊天状态 :0正常， 1大喇叭， 2小喇叭
-- @field [parent=#ChatView] #number _chatItemType
-- 
ChatView._chatItemType = 0

---
-- 聊天室列表界面
-- @field [parent=#ChatView] #CCNode _playerListUi
-- 
ChatView._playerListUi = nil

---
-- 聊天室列表是否显示
-- @field [parent=#ChatView] #boolean _isListShow
-- 
ChatView._isListShow = false

--- 
-- 置顶信息
-- @field [parent=#ChatView] #table _topMessage
-- 
ChatView._topMessage = nil

--- 
-- 正在移动
-- @field [parent=#ChatView] #boolean _isMoving
-- 
ChatView._isMoving = false

--- 
-- 聊天栏操作窗口
-- @field [parent=#ChatView] #CCNode _chatCtrlUi
-- 
ChatView._chatCtrlUi = nil

--- 
-- 构造函数
-- @function [parent=#ChatView] ctor
-- @param self
-- 
function ChatView:ctor()
	ChatView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ChatView] _create
-- @param self
-- 
function ChatView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat.ccbi", true)
	
	-- 按钮事件
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("channelBtn", self._channelClkHandler)
	self:handleButtonEvent("enterBtn", self._enterClkHandler)
	self:handleButtonEvent("bigNBBtn", self._dnbClkHandler)
	self:handleButtonEvent("smallNBBtn", self._xnbClkHandler)
	self:handleButtonEvent("pkBtn", self._pkClkHandler)
	
	-- 切磋小提示隐藏
	self["pkBtn"]:setVisible(false)
	self["timeLab"]:setVisible(false)
	
	-- 输入框事件
	self:handleEditEvent("inputEdit", self._editEventHandler)
	self["nameLab"]:setString("")
	--	self["inputEdit"]:setOpacity(1)
	--	self["inputEdit"]:setClipEnabled(true)
	
	-- 添加聊天室列表
	local ChatPlayerUi = require("view.chat.ChatPlayerUi")
	self._playerListUi = ChatPlayerUi.createInstance()
	self["listNode"]:addChild(self._playerListUi)
	self._playerListUi:setVisible(false)
	self._playerListUi:setPositionX(-self._playerListUi:getContentSize().width)
	self._isListShow = false
	self["ctrSpr"]:setScaleX(-1)
	
	-- 添加操作窗口
	local ChatCtrlUi = require("view.chat.ChatCtrlUi")
	self._chatCtrlUi = ChatCtrlUi.createInstance()
	self:addChild(self._chatCtrlUi)
	self._chatCtrlUi:setVisible(false)
	
	-- layer事件
	self:createClkHelper()
--	self:addClkUi("ctrLayer")
	self:addClkUi("ctrSpr")
	self["ctrLayer"]:setTouchEnabled(false)
	
	-- 初始化聊天信息
	self:showMessages()
	self["topLab"]:setString("")
	self["msgsVBox"]:setVSpace( 4 )
	
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	local cntd = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_DALABA, ItemConst.NORMAL_FRAME)
	self["dnbCntLab"]:setString("" .. cntd)
	local cntx = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_XIAOLABA, ItemConst.NORMAL_FRAME)
	self["xnbCntLab"]:setString("" .. cntx)
	
	-- 大小喇叭监控
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ATTRS_UPDATED_ITEMNO.name, self._attrsUpdatedHandler, self)
	
end

--- 
-- 输入框事件
-- @function [parent=#ChatView] _editEventHandler
-- @param self
-- @param #string type
-- 
function ChatView:_editEventHandler( type )
	if self._channelType == 1 then return end
	if not self._chatTargetInfo then return end
	
--	if type == "ended" then
--		local text = self["inputEdit"]:getText()
--		self["inputEdit"]:setText(self._chatTargetInfo.name .. "：" .. text)
--	end
end

---
-- 道具数量变换监听
-- @function [parent=#ChatView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ATTRS_UPDATE event
-- 
function ChatView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	if event.attrs.ItemNo == ItemConst.ITEMNO_DALABA then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_DALABA, ItemConst.NORMAL_FRAME)
		self["dnbCntLab"]:setString("" .. cnt)
		if cnt <= 0 and self._chatItemType == 1 then
			self._chatItemType = 0
			local ImageUtil = require("utils.ImageUtil")
			self["bigNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba_nomal.png"), 1)
		end
		
	elseif event.attrs.ItemNo == ItemConst.ITEMNO_XIAOLABA then
		local cnt = ItemData.getItemCountByNoAndFrame(ItemConst.ITEMNO_XIAOLABA, ItemConst.NORMAL_FRAME)
		self["xnbCntLab"]:setString("" .. cnt)
		
		if cnt <= 0 and self._chatItemType == 2 then
			self._chatItemType = 0
			local ImageUtil = require("utils.ImageUtil")
			self["smallNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba1_normal.png"), 1)
		end
	end
end

---
-- 打开界面调用
-- @function [parent=#ChatView] openUi
-- 
function ChatView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_chat_openorclose", {open_or_close = 1})
	
	-- 显示置顶信息
	if self._topMessage then
		self:showTopMessage(self._topMessage)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#ChatView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    --local MainView = require("view.main.MainView")
    GameView.removePopUp(self, true)
end

---
-- 退出界面调用
-- @function [parent=#ChatView] onExit
-- @param self
-- 
function ChatView:onExit()
	
	-- 恢复喇叭状态
	if self._chatItemType ~= 0 then
		self._chatItemType = 0
		local ImageUtil = require("utils.ImageUtil")
		self["bigNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba_nomal.png"), 1)
		self["smallNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba1_normal.png"), 1)
	end
	
	-- 恢复当前频道
	if self._channelType ~= 1 then
		self:changeChannel(1)
	end
	
	-- 隐藏切磋提示
	self["pkBtn"]:setVisible(false)
	self["pkBtn"].data = nil
	self["timeLab"]:setVisible(false)
	
	-- 聊天室玩家列表隐藏
	self._playerListUi:setVisible(false)
	self._playerListUi:setPositionX(-self._playerListUi:getContentSize().width)
	
	if self._isListShow then
		local x = self["msgsVBox"]:getPositionX()
		local width = self._playerListUi:getContentSize().width
		local ChatCell = require("view.chat.ChatCell")
		self["msgsVBox"]:setPositionX(x - (width + 15))
		ChatCell.setLabDimensions(830)
		
		self["msgsVBox"]:removeAllItems(true)
		self:showMessages()
	end
	
	self._isListShow = false
	self["ctrSpr"]:setScaleX(-1)
	self["ctrSpr"]:stopAllActions()
	self._isMoving = false
	
	-- 清除置顶信息
	self["topLab"]:setString("")
	self["topLab"]:stopAllActions()
	
	-- 发送按钮变亮
	self["enterBtn"]:setEnabled(true)
	self["enterBtn"]:stopAllActions()
	
	-- 通知服务端退出聊天室
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_chat_openorclose", {open_or_close = 0})
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ATTRS_UPDATED_ITEMNO.name, self._attrsUpdatedHandler, self)

	instance = nil
	ChatView.super.onExit(self)
end

--- 
-- 点击了频道按钮
-- @function [parent=#ChatView] _channelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_channelClkHandler( sender, event )
	printf("channelbtn")
--	printf("ChatView:you have clicked the channelBtn!")
	if self._channelType == 2 then 
		self:changeChannel(1)
	end
end

---
-- 改变频道
-- @function [parent=#ChatView] changeChannel
-- @param self
-- @param #number type
-- @param #table playerinfo
-- 
function ChatView:changeChannel( type, playerinfo )
	if type == 1 then
		self._channelType = 1 
		self:changeFrame("channelBtnSpr", "ccb/buttontitle/dangqian.png")
--		self["inputEdit"]:setPlaceHolder("")
		self["nameLab"]:setString("")
	elseif type == 2 then
		if not playerinfo then
			printf("玩家信息不存在") 
			self:changeChannel(1)
			return 
		end
		
		self._channelType = 2 
		self._chatTargetInfo = playerinfo
		self:changeFrame("channelBtnSpr", "ccb/buttontitle/siliao.png")
--		self["inputEdit"]:setPlaceHolder("" .. playerinfo.name .. "：")
		self["nameLab"]:setString("" .. playerinfo.name .. "：")
	end
	
	local x = self["nameLab"]:getPositionX()
	local width = self["nameLab"]:getContentSize().width
	self["inputEdit"]:setPositionX(x + width)
	local size = self["inputEdit"]:getContentSize()
	printf("size:" .. size.width .. ", " .. size.height)
	self["inputEdit"]:setPreferredSize(450 - width, size.height)
	self["inputEdit"]:setContentSize(CCSize(450 - width, size.height))
	
	local size = self["inputEdit"]:getContentSize()
	printf("size:" .. size.width .. ", " .. size.height)
end

--- 
-- 点击了发送
-- @function [parent=#ChatView] _enterClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_enterClkHandler( sender, event )
	local inputEdit = self["inputEdit"]
	local info = inputEdit:getText()
	
	if not info or info == "" then return end
	
	local GameNet = require("utils.GameNet")
	if self._channelType == 1 then
		GameNet.send("C2s_chat_public", {channel = 1, chat_msg = info, send_type = self._chatItemType})
	elseif self._channelType == 2 then
		if self. _chatTargetInfo then
			GameNet.send("C2s_chat_private", {dst_cid = self._chatTargetInfo.id, chat_msg = info})
		end
	end
	
	inputEdit:setText("")
	
	local func = function()
		self["enterBtn"]:setEnabled(true)
	end
	
	self["enterBtn"]:setEnabled(false)
	local action = transition.sequence({
        CCDelayTime:create(3),
        CCCallFunc:create(func),
    })
	self["enterBtn"]:runAction(action)
end

---
-- 点击了大喇叭
-- @function [parent=#ChatView] _dnbClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_dnbClkHandler( sender, event )
	printf("dlbbtn")
	local ImageUtil = require("utils.ImageUtil")
	if self._chatItemType == 1 then
		self._chatItemType = 0
		self["bigNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba_nomal.png"))
		return
	end
	
	if self._chatItemType == 2 then
		self._chatItemType = 0
		self["smallNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba1_normal.png"))
	end
	
	local cnt = tonumber(self["dnbCntLab"]:getString())
	if cnt <= 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("大喇叭数量不足！"))
		return
	end
	
	self._chatItemType = 1
	self["bigNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba_click.png"))
end

---
-- 点击了小喇叭
-- @function [parent=#ChatView] _xnbClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_xnbClkHandler( sender, event )
	printf("xlbbtn")
	local ImageUtil = require("utils.ImageUtil")
	if self._chatItemType == 2 then
		self._chatItemType = 0
		self["smallNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba1_normal.png"), 1)
		return
	end
	
	if self._chatItemType == 1 then
		self._chatItemType = 0
		self["bigNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba_nomal.png"), 1)
	end
	
	local cnt = tonumber(self["xnbCntLab"]:getString())
	if cnt <= 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("小喇叭数量不足！"))
		return
	end
	
	self._chatItemType = 2
	self["smallNBBtn"]:setBackgroundSpriteFrameForState(ImageUtil.getFrame("ccb/chat/laba1_click.png"), 1)
end

--- 
-- 显示聊天信息
-- @function [parent=#ChatView] showMessages
-- @param self
-- 
function ChatView:showMessages()
	local ChatData = require("model.ChatData")
	local msgArr = ChatData.getMessageArr()
	if not msgArr then return end
	
--	dump(msgArr)
	
	for i = 1, #msgArr do
		local msg = msgArr[i]
		if msg then
			self:addChatCell(msg)
		end
	end
	
	self["msgsVBox"]:validate()
	self["msgsVBox"]:scrollToIndex(#msgArr)
end

--- 
-- 添加聊天cell
-- @function [parent=#ChatView] addChatCell
-- @param self
-- @param #table chatMsg
-- 
function ChatView:addChatCell( chatMsg )
	local ChatCell = require("view.chat.ChatCell")
	local cell = ChatCell.createChatCell(chatMsg.channel, chatMsg.type, chatMsg.name, chatMsg.info, chatMsg.id)
	self["msgsVBox"]:addItem(cell.spr)
	cell.spr.owner = self["msgsVBox"]
end

---
-- ui点击处理
-- @function [parent=#ChatView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ChatView:uiClkHandler( ui, rect )	
	printf("uiclick")
	if self._isMoving then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("操作太过频繁，请稍后!"))
		return 
	end
	
	if ui == self["ctrSpr"] then
		self._isMoving = true
		local sprAction = transition.sequence({
		        CCDelayTime:create(1),
		        CCCallFunc:create(function() self._isMoving = false end),
		    })
		self["ctrSpr"]:runAction(sprAction)
	
		local x = self._playerListUi:getPositionX()
		local width = self._playerListUi:getContentSize().width
		local action
		if self._isListShow then
			action = transition.sequence({
				CCMoveTo:create(0.2, ccp(x-width, 0)),
				CCCallFunc:create(function() self._playerListUi:setVisible(false) end), 
			})
		
			self["ctrSpr"]:setScaleX(-1)
			self._isListShow = false
		else
			self._playerListUi:setVisible(true)
			self._playerListUi:openUi()
			action = CCMoveTo:create(0.2, ccp(x+width, 0))
			self["ctrSpr"]:setScaleX(1)
			self._isListShow = true
		end
		
		self._playerListUi:runAction(action)
		
		--右边vbox变化  
		local x = self["msgsVBox"]:getPositionX()
		local ChatCell = require("view.chat.ChatCell")
		if self._isListShow then
			self["msgsVBox"]:setPositionX(x + (width + 15))
			ChatCell.setLabDimensions(613)
		else
			self["msgsVBox"]:setPositionX(x - (width + 15))
			ChatCell.setLabDimensions(830)
		end
		
		self["msgsVBox"]:removeAllItems(true)
		self:showMessages()
		
--		local arr = self["msgsVBox"]:getItemArr()
--		for i = 1, #arr do
--			local spr = arr[i]
--			if spr and spr.infoLab then
--				spr.infoLab:setDimensions(CCSize(ChatCell.labDimensions, 0))
--			end
--		end
--		
--		self["msgsVBox"]:validate()
	end
end

---
-- 邀请切磋成功
-- @function [parent=#ChatView] invitePkSucceed
-- @param self
-- @param #table info
-- 
function ChatView:invitePkSucceed( info )
	if not info then return end
	
	self["pkBtn"]:setVisible(true)
	self["timeLab"]:setVisible(true)
	self["pkBtn"].data = info
	local func = function()
		local cur = os.time()
		if cur < (info.starttime + 10) then
			self["timeLab"]:setString("(" .. (info.starttime + 10 - cur) .. "s)")
		else
			self:stopAllActions()
			
			self["pkBtn"]:setVisible(false)
			self["timeLab"]:setVisible(false)
			self["pkBtn"].data = nil
		end
	end
	
	self:schedule(func, 1)
end

---
-- 邀请切磋被拒绝
-- @function [parent=#ChatView] inviteIsRefused
-- @param self
-- 
function ChatView:inviteIsRefused()
	self:stopAllActions()
	self["pkBtn"]:setVisible(false)
	self["timeLab"]:setVisible(false)
	self["pkBtn"].data = nil
end

---
-- 点击了切磋按钮
-- @function [parent=#ChatView] _pkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChatView:_pkClkHandler( sender, event )
	printf("pkbtn")
	local info = self["pkBtn"].data
	if not info then return end
	
	local ChatInviteFightUi = require("view.chat.ChatInviteFightUi")
	ChatInviteFightUi.createInstance():openUi(info)
end

---
-- 显示置顶信息
-- @function [parent=#ChatView] showTopMessage
-- @param self
-- @param #table msg 
-- 
function ChatView:showTopMessage( msg )
	if not msg then return end
	
	self._topMessage = msg
	if self:getParent() then
		local curtime = os.time()
		if curtime < msg.starttime + 15 then
			self["topLab"]:setString(msg.name .. "：" .. msg.info)
			local func = function()
				self["topLab"]:setString("")
			end
			
			local action = transition.sequence({
			        CCDelayTime:create(msg.starttime + 15 - curtime),
			        CCCallFunc:create(func),
			    })
					
			self["topLab"]:runAction(action)
		else
			self._topMessage = nil
		end
	end
end

---
-- 获取box
-- @function [parent=#ChatView] getVBox
-- @param self
-- @return ui.VBox#VBox 
-- 
function ChatView:getVBox()
	return self["msgsVBox"]
end

---
-- 获取pkBtn
-- @function [parent=#ChatView] getPkBtn
-- @param self
-- @return #btn
-- 
function ChatView:getPkBtn()
	return self["pkBtn"]
end