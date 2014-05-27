--- 
-- 信件与好友界面
-- @module view.mailandfriend.MailAndFriendView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local pairs = pairs
local CCRectMake = CCRectMake
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCSize = CCSize
local ccp = ccp
local display = display
local CCTextureCache = CCTextureCache

local moduleName = "view.mailandfriend.MailAndFriendView"
module(moduleName)


--- 
-- 类定义
-- @type MailAndFriendView
-- 
local MailAndFriendView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 当前显示tab（1，战斗，2，留言, 3.系统， 4.仇人， 5.好友）
-- @field [parent=#MailAndFriendView] #number _selectedIndex
--
MailAndFriendView._selectedIndex = 0

---
-- 右边邮件界面
-- @field [parent=#MailAndFriendView] #CCNode _rightMailView
-- 
MailAndFriendView._rightMailView = nil

---
-- 右边好友界面
-- @field [parent=#MailAndFriendView] #CCNode _rightFriendView
-- 
MailAndFriendView._rightFriendView = nil

---
-- 右边仇人界面
-- @field [parent=#MailAndFriendView] #CCNode _rightEnemyView
-- 
MailAndFriendView._rightEnemyView = nil

---
-- 点击cell弹出来的子面板
-- @field [parent=#MailAndFriendView] #CCSprite _controlSprite
-- 
MailAndFriendView._controlSprite = nil

---
-- 功能按钮表
-- @field [parent=#MailAndFriendView] #table _btnTbl
-- 
MailAndFriendView._btnTbl = nil

---
-- 功能函数表
-- @field [parent=#MailAndFriendView] #table funcTbl
-- 
MailAndFriendView.funcTbl = nil

----- 
---- 操作box
---- @field [parent=#MailAndFriendView] #ui.HBox#HBox _hBox
---- 
MailAndFriendView._hBox = nil

---
-- 选中的cell
-- @field [parent=#MailAndFriendView] #CCNode _selectCell
-- 
MailAndFriendView._selectCell = nil

--- 
-- 构造函数
-- @function [parent=#MailAndFriendView] ctor
-- @param self
-- 
function MailAndFriendView:ctor()
	MailAndFriendView.super.ctor(self)
	
	self:_create()
end

---
-- 创建实例
-- @function [parent=view.mailandfriend.MailAndFriendView] new
-- @return MailAndFriendView实例
-- 
function new()
	return MailAndFriendView.new()
end

--- 
-- 创建
-- @function [parent=#MailAndFriendView] _create
-- @param self
-- 
function MailAndFriendView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_mail.ccbi")
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_init_mail", {index = 1})

	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	
	self["tab1RGrp"].menu:setEnabled(false)
	local box = self["rightHBox"]
	
	--添加邮件界面
	local RightMailView = require("view.mailandfriend.RightMailView")
--	self._rightMailView = RightMailView.createInstance()
	self._rightMailView = RightMailView.new()
	box:addChild(self._rightMailView)
	self._rightMailView.owner = self
	
	--添加好友界面
	local RightFriendView = require("view.mailandfriend.RightFriendView")
--	self._rightFriendView = RightFriendView.createInstance()
	self._rightFriendView = RightFriendView.new()
	box:addChild(self._rightFriendView)
	self._rightFriendView.owner = self
	
	--添加仇人界面
	local RightEnemyView = require("view.mailandfriend.RightEnemyView")
--	self._rightEnemyView = RightEnemyView.createInstance()
	self._rightEnemyView = RightEnemyView.new()
	box:addChild(self._rightEnemyView)
	self._rightEnemyView.owner = self
	
	--创建子操作界面背景
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame("ccb/mark2/floattipbox.png")
	local rect = CCRectMake(51, 23, 190, 78)
	self._controlSprite = CCScale9Sprite:createWithSpriteFrame(frame, rect)
	self._controlSprite:setAnchorPoint(ccp(0,0))
	
	--子操作界面容器
	local HBox = require("ui.HBox")
	local box = HBox.new()
	box:setPosition(45, -10)
	box:setContentSize(CCSize(220, 121))
	box:setAnchorPoint(ccp(0,0))
	box:setHSpace(20)
	box:setClipEnabled(false)
	self._hBox = box
	self._controlSprite:addChild(self._hBox)
	
	--创建子操作按钮
	self._btnTbl = {}
	self:_createFunBtns()
	
	self:addChild(self._controlSprite)
	self._controlSprite:setVisible(false)
	
	--新建一个监听层
	local listenerLayer = display.newLayer(true)
	listenerLayer:setContentSize(self:getContentSize())
	listenerLayer:setAnchorPoint(ccp(0, 0))
	listenerLayer:addTouchEventListener(
		function (event, x, y)
			if self._controlSprite:isVisible() == false then
				return
			end
			
			local size = self._controlSprite:getContentSize()
			local pt = self._controlSprite:convertToNodeSpace(ccp(x, y))
			if (pt.x < 0) or (pt.x >  size.width) 
				or (pt.y < 0) or (pt.y > size.height) then
				self._controlSprite:setVisible(false)
			end
		end
	)	
	listenerLayer:setTouchEnabled(true)	
	self:addChild(listenerLayer)
	listenerLayer:setPosition(0, 0)
	
	local EventCenter = require("utils.EventCenter")
	local MailEvents = require("model.event.MailEvents")
	EventCenter:addEventListener(MailEvents.NEW_MAIL_UPDATED.name, self._newMailHandler, self)
	
	-- "新"标记是否可见
	local MailData = require("model.MailData")
	self["newxtSpr"]:setVisible(MailData.newSystemMail)
	self["newzdSpr"]:setVisible(MailData.newFightMail)
	self["newlySpr"]:setVisible(MailData.newMessageMail)
	self["newhySpr"]:setVisible(MailData.newFriendRequest)
end

---
-- 新邮件或是新好友申请监听
-- @function [parent=#MailAndFriendView] _newMailHandler
-- @param self
-- @param #table event
-- 
function MailAndFriendView:_newMailHandler( event )
	local MailData = require("model.MailData")
	
	if MailData.newFightMail == true then
		self["newzdSpr"]:setVisible(true)
	end
	
	if MailData.newSystemMail == true then
		self["newxtSpr"]:setVisible(true)
	end
	
	if MailData.newMessageMail == true then
		self["newlySpr"]:setVisible(true)
	end
	
	if MailData.newFriendRequest == true then
		self["newhySpr"]:setVisible(true)
	end
	
	self:updateNewSprByTab()
end

---
-- 根据tab更新“新”标记
-- @function [parent=#MailAndFriendView] updateNewSprByTab
-- @param self
-- 
function MailAndFriendView:updateNewSprByTab()
	local MailData = require("model.MailData")
	local type = 0
	if self._selectedIndex <= 1 then
		self["newxtSpr"]:setVisible(false)
		MailData.newSystemMail = false
		type = 1
	elseif self._selectedIndex == 2 then
		self["newzdSpr"]:setVisible(false)
		MailData.newFightMail = false
		type = 3
	elseif self._selectedIndex == 3 then
		self["newlySpr"]:setVisible(false)
		MailData.newMessageMail = false
		type = 2
	elseif self._selectedIndex == 4 then
		self["newhySpr"]:setVisible(false)
	end
	
	if type > 0 then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_mail_new_look", {mail_type = type})
	end
end

---
-- 创建玩法功能图标集
-- @function [parent = #MailAndFriendView] _createFunBtns()
-- 
function MailAndFriendView:_createFunBtns()
	local GameView = require("view.GameView")
	local liuyanbtn = function()
		printf(tr("留言"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		self._controlSprite:setVisible(false)
		
		local SendMailView = require("view.mailandfriend.SendMailView")
		if self._selectedIndex == 4 then		--好友留言
			SendMailView.createInstance():openUi()
			SendMailView.createInstance():showMailInfo(info.user_uid, info.user_name, 1)
		end
	end
	
	local deletebtn = function()
		printf(tr("删除"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self._controlSprite:setVisible(false)
		local GameNet = require("utils.GameNet")
		if self._selectedIndex < 4 then
			GameNet.send("C2s_mail_del", {mail_id = info.mail_id})
		elseif self._selectedIndex == 4 then
			GameNet.send("C2s_friend_del", {user_uid = info.user_uid, del_type = 1})
		elseif self._selectedIndex == 5 then	
			GameNet.send("C2s_friend_del", {user_uid = info.user_uid, del_type = 2})
		end
	end
	
	local kickbtn = function() 
		printf(tr("揍他"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		local HeroAttr = require("model.HeroAttr")
		if HeroAttr.Vigor < 1 then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("精力不足，无法进行此操作！"))
			return
		end
		
		self._controlSprite:setVisible(false)
		
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_friend_pk", {user_uid = info.user_uid})
	end
	
	local checkbtn = function()
		printf(tr("查看"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self._controlSprite:setVisible(false)
		local MailInfoView = require("view.mailandfriend.MailInfoView")
		MailInfoView.createInstance():openUi()
		MailInfoView.createInstance():showMailInfo( info )
	end
	
	local replybtn = function()
		printf(tr("回复"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self._controlSprite:setVisible(false)
		local SendMailView = require("view.mailandfriend.SendMailView")
		if self._selectedIndex == 3 then	--留言回复
			SendMailView.createInstance():openUi()
			SendMailView.createInstance():showMailInfo(info.uid, info.from, 2)
		end
	end
	
	local fujianbtn = function()
		printf(tr("提取附件"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		if info.has_attachment ~= 1 then return end
		
		self._controlSprite:setVisible(false)
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_get_mail_attachment", {mail_id = info.mail_id})
	end
	
	local biwubtn = function()
		printf(tr("比武"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self:_closeClkHandler()
		local BiWuView = require("view.biwu.BiWuView")
		BiWuView.createInstance():openUi()
	end
	
	local wulinbtn = function()
		printf(tr("武林榜"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self:_closeClkHandler()
		local WuLinBangView = require("view.wulinbang.WuLinBangView")
		WuLinBangView.createInstance():openUi()
	end
	
	local robbtn = function()
		printf(tr("夺宝"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		local info = self._selectCell:getInfo()
		
		self:_closeClkHandler()
		local GameView = require("view.GameView")
		local RobMainView = require("view.rob.RobMainView")
		--GameView.replaceMainView(RobMainView.createInstance())
		GameView.addPopUp(RobMainView.createInstance(), true)
	end
	
	local enemybtn = function()
		printf(tr("仇人"))
		if not self._selectCell or not self._selectCell:getInfo() then return end
		
		self._controlSprite:setVisible(false)
		self["tabRGrp"]:setSelectedIndex(5)
		self:_tabClkHandler()
	end
	
	local btnTable = {
		{["message"] = liuyanbtn},		--留言
		{["del"] = deletebtn},			--删除
		{["kick"] = kickbtn},			--揍他
		{["view"] = checkbtn},			--查看
		{["reply"] = replybtn},			--回复
		{["getattachment"] = fujianbtn},--提取附件
		{["rob"] = robbtn},				--夺宝
		{["topofwulin_2"] = wulinbtn},	--武林榜
		{["pk"] = biwubtn},				--比武
		{["enemy"] = enemybtn},		--仇人
	}
	
	self.funcTbl = {
		["message"] = liuyanbtn,
		["del"] = deletebtn,
		["kick"] = kickbtn,
		["view"] = checkbtn,
		["reply"] = replybtn,
		["getattachment"] = fujianbtn,
		["rob"] = robbtn,
		["topofwulin_2"] = wulinbtn,
		["pk"] = biwubtn,
		["enemy"] = enemybtn,
	}
	
	for i = 1, #btnTable do
		for k, v in pairs(btnTable[i]) do
			self:_addFunBtn(k, v)
		end
	end
end

---
-- 添加功能按钮
-- @function [parent=#MailAndFriendView] _addFunBtn
-- @param self
-- @param #string icon 图标编号
-- @param #function func 回调事件
-- 
function MailAndFriendView:_addFunBtn( icon, func )
	local ImageUtil = require("utils.ImageUtil")
	
	local frame = ImageUtil.getFrame("ccb/icon/"..icon..".png")
	
	local s = frame:getOriginalSize()
	local rect = frame:getRect()
	local backImage = CCScale9Sprite:createWithSpriteFrame(frame)
	
	local btn = CCControlButton:create()
	btn:setContentSize(CCSize(s.width, s.height))
	btn:setBackgroundSpriteForState(backImage, 1)
	btn:setPreferredSize(rect.size.width, rect.size.height)
	btn:retain()
	btn:setIsMainBtn(true)
	btn:setAnchorPoint(ccp(0.5,0.5))
	btn:setTouchPriority(-1)
	btn:addHandleOfControlEvent(function( ... )
		if func ~= nil then
			func()
		end
	end, 32)
	
	local spr = display.newSprite()
	spr:setContentSize(CCSize(s.width, s.height))
	spr:retain()
	spr:addChild(btn)
	btn:setPosition(s.width/2, s.height/2)
	
	self._btnTbl[icon] = spr
end


--- 
-- 点击了tab(根据index显示5个子界面之一, MailView为系统、战斗、留言公用，EnemyView、FriendView)
-- @function [parent=#MailAndFriendView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function MailAndFriendView:_tabClkHandler( event )
	printf("tab")
	self._controlSprite:setVisible(false)
	
	local set
	self._selectedIndex = self["tabRGrp"]:getSelectedIndex()
	
	local GameNet = require("utils.GameNet")
	local MailData = require("model.MailData")
	-- 显示系统邮件
	if self._selectedIndex <= 1 then
		MailData.newSystemMail = false
		self["newxtSpr"]:setVisible(false)
		
		self._rightMailView:setVisible(true)
		self._rightFriendView:setVisible(false)
		self._rightEnemyView:setVisible(false)
	
		self._rightMailView:updateShowInfo( self._selectedIndex )
	-- 显示战斗邮件
	elseif self._selectedIndex == 2 then
		MailData.newFightMail = false
		self["newzdSpr"]:setVisible(false)
	
		self._rightMailView:setVisible(true)
		self._rightFriendView:setVisible(false)
		self._rightEnemyView:setVisible(false)
		
		self._rightMailView:updateShowInfo( self._selectedIndex )
	-- 显示留言
	elseif self._selectedIndex == 3 then
		MailData.newMessageMail = false
		self["newlySpr"]:setVisible(false)
	
		self._rightMailView:setVisible(true)
		self._rightFriendView:setVisible(false)
		self._rightEnemyView:setVisible(false)
		
		self._rightMailView:updateShowInfo( self._selectedIndex )
	-- 显示仇人
	elseif self._selectedIndex == 5 then
		self._rightMailView:setVisible(false)
		self._rightFriendView:setVisible(false)
		self._rightEnemyView:setVisible(true)
		
		self._rightEnemyView:getEnemyInfo()
	-- 显示好友
	elseif self._selectedIndex == 4 then
--		MailData.newFriendRequest = false
		self["newhySpr"]:setVisible(false)
	
		self._rightMailView:setVisible(false)
		self._rightFriendView:setVisible(true)
		self._rightEnemyView:setVisible(false)
		
		self._rightFriendView:getFriendInfo()
	end
	
	self:updateNewSprByTab()
end

--- 
-- 点击了关闭
-- @function [parent=#MailAndFriendView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MailAndFriendView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

---
-- 打开界面调用
-- @function [parent=#MailAndFriendView] openUi
-- @param self
-- 
function MailAndFriendView:openUi()
	local GameView = require("view.GameView")
	GameView.replaceMainView(self)

	self:_tabClkHandler()
end

---
-- 显示好友信息
-- @function [parent=#MailAndFriendView] showFriendInfo
-- @param self
-- @param #S2c_friend_info pb
-- 
function MailAndFriendView:showFriendInfo(pb)
	if self._selectedIndex ~= 4 then return end
	
	self._rightFriendView:showFriendInfo(pb)
end

---
-- 显示仇人信息
-- @function [parent=#MailAndFriendView] showEnemyInfo
-- @param self
-- @param #S2c_friend_enemy_info pb
--
function MailAndFriendView:showEnemyInfo(pb)
	if self._selectedIndex ~= 5 then return end
	
	self._rightEnemyView:showEnemyInfo(pb)
end

---
-- 设置选中cell
-- @function [parent=#MailAndFriendView] setSelectCell
-- @param self
-- @param #CCNode cell
-- 
function MailAndFriendView:setSelectCell( cell )
	if not cell or not cell.owner then
		self._selectCell = nil
	end
	
	self._selectCell = cell
end

---
-- 更新选中的cell，根据cell确定子操作界面 
-- @function [parent=#MailAndFriendView] updateSelectCell
-- @param self
-- @param #CCNode cell
-- 
function MailAndFriendView:updateSelectCell( cell )
	if not cell or not cell.owner then
		self._selectCell = nil
		self._controlSprite:setVisible(false)
		return
	end
	
	self._selectCell = cell
	
	local x = cell:getPositionX()
	local y = cell:getPositionY()
	self._hBox:removeAllItems(false)
	
	local showControl = true
	if self._selectedIndex == 2 then
		showControl = false
		self.funcTbl["view"]()
	
--		local info = cell:getInfo()
--		if not info then return end
--		
--		self._hBox:addItem(self._btnTbl["view"])
--		if info.mail_sub_type == 1 then
--			self._hBox:addItem(self._btnTbl["pk"])
--		elseif info.mail_sub_type == 2 then
--			self._hBox:addItem(self._btnTbl["rob"])
--		elseif info.mail_sub_type == 3 then
--			self._hBox:addItem(self._btnTbl["topofwulin_2"])
--		elseif info.mail_sub_type == 4 then
--			self._hBox:addItem(self._btnTbl["enemy"])
--		elseif info.mail_sub_type == 5 then
--			--切磋 只有两项（）
--			
--			self._hBox:addItem(self._btnTbl["del"])
--		
--			self._hBox:setContentSize(CCSize(207, 115))
--			self._controlSprite:setPreferredSize(CCSize(247, 121))
--			self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 9))
--			self._controlSprite:setVisible(true)
--			return
--		end
--		self._hBox:addItem(self._btnTbl["del"])
--		
--		self._hBox:setContentSize(CCSize(319, 115))
--		self._controlSprite:setPreferredSize(CCSize(359, 121))
--		self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 9))
	elseif self._selectedIndex == 3 then
		showControl = false
		self.funcTbl["view"]()
--		self._hBox:addItem(self._btnTbl["view"])
--		self._hBox:addItem(self._btnTbl["reply"])
--		self._hBox:addItem(self._btnTbl["del"])
--		
--		self._hBox:setContentSize(CCSize(309, 115))
--		self._controlSprite:setPreferredSize(CCSize(349, 121))
--		self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 9))
	elseif self._selectedIndex == 1 then
		local info = self._selectCell:getInfo()
		--是否有附件
		if info then
--		if info and info.has_attachment == 1 then
			showControl = false
			self.funcTbl["view"]()
--			self._hBox:addItem(self._btnTbl["view"])
--			self._hBox:addItem(self._btnTbl["getattachment"])
--			
--			self._hBox:setContentSize(CCSize(207, 115))
--			self._controlSprite:setPreferredSize(CCSize(247, 121))
--			self.funcTbl["view"]()
--		else
--			self._hBox:addItem(self._btnTbl["view"])
--			self._hBox:addItem(self._btnTbl["del"])
--			
--			self._hBox:setContentSize(CCSize(207, 115))
--			self._controlSprite:setPreferredSize(CCSize(247, 121))
		end
		
		self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 9))
	elseif self._selectedIndex == 5 then
		self._hBox:addItem(self._btnTbl["kick"])
		self._hBox:addItem(self._btnTbl["del"])
		
		self._hBox:setContentSize(CCSize(207, 115))
		self._controlSprite:setPreferredSize(CCSize(247, 121))
		self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 80))
	elseif self._selectedIndex == 4 then
		self._hBox:addItem(self._btnTbl["message"])
		self._hBox:addItem(self._btnTbl["del"])
		
		self._hBox:setContentSize(CCSize(207, 115))
		self._controlSprite:setPreferredSize(CCSize(247, 121))
		self._controlSprite:setPosition(ccp(x + 490, y + cell.owner._containerEndY + 80))
	end
	
	if showControl then
		self._controlSprite:setVisible(true)
	end
end

---
-- 子界面box滚动时关闭子操作界面
-- @function [parent=#MailAndFriendView] scrollHandler
-- @param self
-- 
function MailAndFriendView:scrollHandler()
	if not self.controlSprite then return end
	self._controlSprite:setVisible(false)
end

---
-- 退出界面时调用
-- @field [parent=#MailAndFriendView] onExit
-- @param self
--
function MailAndFriendView:onExit()
	self._controlSprite = nil
	local EventCenter = require("utils.EventCenter")
	
	local MailEvents = require("model.event.MailEvents")
	EventCenter:removeEventListener(MailEvents.NEW_MAIL_UPDATED.name, self._newMailHandler, self)
	instance = nil
	
	MailAndFriendView.super.onExit(self)
end