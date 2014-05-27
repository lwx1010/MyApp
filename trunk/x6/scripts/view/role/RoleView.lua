--- 
-- 角色信息界面
-- @module view.role.RoleView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local display = display
local transition = transition
local ccc4 = ccc4
local CCSize = CCSize
local CCLayerColor = CCLayerColor
local ccp = ccp
local PLATFORM_NAME = PLATFORM_NAME
local CONFIG = CONFIG
local CCCallFunc = CCCallFunc
local CCDelayTime = CCDelayTime
local ipairs = ipairs
local table = table
local CCLayer = CCLayer
local tonumber = tonumber

local moduleName = "view.role.RoleView"
module(moduleName)

--- 
-- 类定义
-- @type RoleView
-- 
local RoleView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 精力恢复倒计时结束时间
-- @field [parent=#RoleView] #number _endVigorTime
-- 
RoleView._endVigorTime = 0

---
-- 精力倒计时handle
-- @field [parent=#RoleView] #handle _vigorHandle
-- 
RoleView._vigorHandle = nil

---
-- 体力恢复倒计时结束时间
-- @field [parent=#RoleView] #number _endPhysicalTime
-- 
RoleView._endPhysicalTime = 0

---
-- 体力倒计时handle
-- @field [parent=#RoleView] #handle _physicalHandle
-- 
RoleView._physicalHandle = nil

--- 
-- vip特效
-- @field [parent=#RoleView] #CCSprite _vipSprite
-- 
RoleView._vipSprite = nil

---
-- buff提示框
-- @field [parent=#RoleView] #CCLayer _buffTipView
-- 
RoleView._buffTipView = nil

---
-- buff子提示框
-- @field [parent=#RoleView] #CCLayer _buffSubTipView
-- 
RoleView._buffSubTipView = nil

---
-- buff信息
-- @field [parent=#RoleView] #table _buffInfo
-- 
RoleView._buffInfo = nil

---
-- buff计时器
-- @field [parent=#RoleView] #table _buffHandler
-- 
RoleView._buffHandler = nil

---
-- buff子界面
-- @field [parent=#RoleView] #CCLayer _buffSubView
-- 
RoleView._buffSubTipView = nil

---
-- buff数据表
-- @field [parent=#RoleView] #table _buffTable
-- 
RoleView._buffTable = nil

---
-- buff位置表
-- @field [parent=#RoleView] #table _buffPosTable
-- 
RoleView._buffPosTable = nil

--- 
-- 构造函数
-- @function [parent=#RoleView] ctor
-- @param self
-- 
function RoleView:ctor()
	RoleView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#RoleView] _create
-- @param self
-- 
function RoleView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_userinfo.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
--	self:handleButtonEvent("growUpBtn", self._growUpClkHandler)
--	self:handleButtonEvent("rankBtn", self._rankClkHandler)
--	self:handleButtonEvent("chargeBtn", self._chargeClkHandler)
	self:handleButtonEvent("understandBtn", self._understandBtnHandler)

	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	local HeroAttr = require("model.HeroAttr")
	self["nameLab"]:setString(HeroAttr.Name)
	self["pointLab"]:setString("" .. (HeroAttr.Score or 0))
	self["lvLab"]:setString("" .. HeroAttr.Grade)
--	self["uidLab"]:setString("ID:" .. (HeroAttr.Uid or ""))
	self["uidLab"]:setVisible(false)
	
	self["expLab"]:setString((HeroAttr.ShowExp or 0).."/"..HeroAttr.MaxExp)
	local per = 100 * (HeroAttr.ShowExp or 0) / HeroAttr.MaxExp
	self["ExpPBar"]:setPercentage(per)
	
	self["vigorLab"]:setString("" .. HeroAttr.Vigor .. "/" .. HeroAttr.VigorMax)
	self["physicalLab"]:setString("" .. HeroAttr.Physical .. "/" .. HeroAttr.PhysicalMax)
	
	self["yuanBaoLab"]:setString("" .. HeroAttr.YuanBao)
	self["cashLab"]:setString("" .. HeroAttr.Cash)
	
	local str = "ccb/number/" .. (HeroAttr.Vip or 0) .. ".png"
	self:changeFrame("vipSpr", str)
	
	local layer = display.newLayer(true)
	layer:setContentSize(self:getContentSize())
	layer:setAnchorPoint(ccp(0, 0))
	layer:addTouchEventListener(
		function (event, x, y)
			if event =="ended" or event =="cancelled" then
				if self._buffTipView then
					self._buffTipView:setVisible(false)
				end
				
				return true
			end
			local ps = self:convertToNodeSpace(ccp(x, y))
			x, y = ps.x, ps.y
			local index = self:_getIndexByPos(x, y)
			
			if index == 0 then
				if self._buffTipView then
					self._buffTipView:setVisible(false)
				end
			else
				self:_uiClkHandler(self["backSpr" .. index])
			end
			return true
		end)
	layer:setTouchEnabled(true)
	self:addChild(layer)
	
	

--	self:_addBuffClkUi()
	for i = 1, 8 do
		self:setGraySprite(self["backSpr" .. i])
		self:setGraySprite(self["iconSpr" .. i])
	end
	local HeroAttr = require("model.HeroAttr")
	
	self._buffTable = {}
	
	if tonumber(HeroAttr.Grade) >= 13 then
		self:_sendBuffRequest()
	end
	
	self:createClkHelper()
	self:addClkUi("vipBgSpr")
	self:addClkUi("yuanBaoAddSpr")
	self:addClkUi("silverAddSpr")
	
	-- 判断是否开充值
--	local ConfigParams = require("model.const.ConfigParams")
--	if CONFIG[ConfigParams.OPEN_PAY] and CONFIG[ConfigParams.OPEN_PAY] > 0 then
--		self["chargeBtn"]:setVisible(true)
--	else
--		self["chargeBtn"]:setVisible(false)
--	end
end

--- 
-- 数据变化
-- @function [parent=#RoleView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function RoleView:_attrsUpdatedHandler( event )
	if not event.attrs then return end
	
	local tbl = event.attrs 
	local HeroAttr = require("model.HeroAttr")
	if tbl.YuanBao then
		self["yuanBaoLab"]:setString("" .. HeroAttr.YuanBao)
	end
	
	if tbl.Cash then 
		self["cashLab"]:setString("" .. HeroAttr.Cash)
	end
	
	if tbl.Grade then
		self["lvLab"]:setString("" .. HeroAttr.Grade)
	end
	
	if tbl.ShowExp or tbl.MaxExp then
		local per = 100 * (HeroAttr.ShowExp or 0) / HeroAttr.MaxExp
		self["ExpPBar"]:setPercentage(per)
		self["expLab"]:setString((HeroAttr.ShowExp or 0).."/"..HeroAttr.MaxExp)
	end
	
	if tbl.Vip then
		local str = "ccb/number/" .. (HeroAttr.Vip or 0) .. ".png"
		self:changeFrame("vipSpr", str)
	end
	
	if tbl.Score then
		self["pointLab"]:setString("" .. tbl.Score)
	end
	
	if tbl.Vigor or tbl.VigorMax then
		self["vigorLab"]:setString("" .. HeroAttr.Vigor .. "/" .. HeroAttr.VigorMax)
	end
	
	if tbl.Physical or tbl.PhysicalMax then
		self["physicalLab"]:setString("" .. HeroAttr.Physical .. "/" .. HeroAttr.PhysicalMax)
	end
	
	if tbl.ShenXing or tbl.ShenXingMax then
		self["shenXingLab"]:setString("" .. HeroAttr.ShenXing .. "/" .. HeroAttr.ShenXingMax)
	end
end

--- 
-- 点击了成长
-- @function [parent=#RoleView] _growUpClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RoleView:_growUpClkHandler( sender, event )
	--printf("you have clicked the growup!")
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开放！"))
end

--- 
-- 点击了排行榜
-- @function [parent=#RoleView] _rankClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RoleView:_rankClkHandler( sender, event )
	--printf("you have clicked the rank!")
	--local FloatNotify = require("view.notify.FloatNotify")
--	FloatNotify.show(tr("该功能尚未开放！"))
	
	--self:_closeClkHandler()
	
	local RankView = require("view.rank.RankView")
	RankView.createInstance():openUi()
end

--- 
-- 点击了充值 
-- @function [parent=#RoleView] _chargeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RoleView:_chargeClkHandler( sender, event )
	--printf("you have clicked the charge!")
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开放！"))
end

--- 
-- 点击了关闭
-- @function [parent=#RoleView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RoleView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

---
-- 退出界面时调用
-- @function [parent=#RoleView] onExit
-- @param self
-- 
function RoleView:onExit()
	local scheduler = require("framework.client.scheduler")
	if self._vigorHandle then
		scheduler.unscheduleGlobal(self._vigorHandle)
		self._vigorHandle = nil
	end
	
	if self._physicalHandle then
		scheduler.unscheduleGlobal(self._physicalHandle)
		self._physicalHandle = nil
	end
	
	if self._buffHandler then
		scheduler.unscheduleGlobal(self._buffHandler)
		self._buffHandler = nil
	end
	
	if self._vipSprite then
		transition.stopTarget(self._vipSprite)
	end
	
	self._buffSubView = nil
	self._buffTable = nil
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	
	RoleView.super.onExit(self)
end

---
-- 显示信息
-- @function [parent=#RoleView] showInfo
-- @param self
-- @param #S2c_hero_baginfo info
-- 
function RoleView:showInfo( info )
	-- 加载等待关闭
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()

	if not info then return end
	
	self["partnerLab"]:setString("" .. info.partner_num .. "/" .. info.partner_max)
	self["equipLab"]:setString("" .. info.equip_num .. "/" .. info.equip_max)
	self["martialLab"]:setString("" .. info.martial_num .. "/" .. info.martial_max)
	self["treatureLab"]:setString("" .. info.item_num .. "/" .. info.item_max)
	
	local scheduler = require("framework.client.scheduler")
	local NumberUtil = require("utils.NumberUtil")
	local HeroAttr = require("model.HeroAttr")
	
	-- 精力设置
	if self._vigorHandle then
		scheduler.unscheduleGlobal(self._vigorHandle)
		self._vigorHandle = nil
	end
	
	if HeroAttr.Vigor < HeroAttr.VigorMax and info.vigor_time > 0 then
		self._endVigorTime = info.vigor_time
		local func = function()
			self._endVigorTime = self._endVigorTime - 1
			if self._endVigorTime <= 0 then
				scheduler.unscheduleGlobal(self._vigorHandle)
				self._vigorHandle = nil
--				local GameNet = require("utils.GameNet")
--				GameNet.send("C2s_hero_baginfo", {place_holder = 1})
				self:_delay()
				return
			end
			self["vigorTimeLab"]:setString(NumberUtil.secondToDate(self._endVigorTime))
		end
		
		self._vigorHandle = scheduler.scheduleGlobal(func, 1)
	else
		self["vigorTimeLab"]:setString("")
	end
	
	-- 体力设置
	if self._physicalHandle then
		scheduler.unscheduleGlobal(self._physicalHandle)
		self._physicalHandle = nil
	end
	
	if HeroAttr.Physical < HeroAttr.PhysicalMax and info.physical_time > 0 then
		self._endPhysicalTime = info.physical_time
		local func = function()
			self._endPhysicalTime = self._endPhysicalTime - 1
			if self._endPhysicalTime <= 0 then
				scheduler.unscheduleGlobal(self._physicalHandle)
				self._physicalHandle = nil
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_hero_maininfo", {place_holder = 1})
				self:_delay()
				return
			end
			self["physicalTimeLab"]:setString(NumberUtil.secondToDate(self._endPhysicalTime))
		end
		
		self._physicalHandle = scheduler.scheduleGlobal(func, 1)
	else
		self["physicalTimeLab"]:setString("")
	end
	
end

---
-- 打开界面调用
-- @function [parent=#RoleView] openUi
-- @param self
-- 
function RoleView:openUi()
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameView = require("view.GameView")
	GameView.replaceMainView(self, true)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_hero_maininfo", {place_holder = 1})
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Vip > 0 then
		if not self._vipSprite then
			display.addSpriteFramesWithFile("res/ui/effect/vipandshare.plist", "res/ui/effect/vipandshare.png")
			self._vipSprite = display.newSprite()
			self:addChild(self._vipSprite)
			self._vipSprite:setPositionX(145)
			self._vipSprite:setPositionY(452)
		end
		
		local frames = display.newFrames("vipandshare/100%02d.png", 0, 12)
		local ImageUtil = require("utils.ImageUtil")
		local frame = ImageUtil.getFrame()
		frames[#frames + 1] = frame
		local animation = display.newAnimation(frames, 1/12)
		transition.playAnimationForever(self._vipSprite, animation, 0.6)
	end
	
	self["shenXingLab"]:setString("" .. HeroAttr.ShenXing .. "/" .. HeroAttr.ShenXingMax)
end

-----
---- ui点击处理
---- @function [parent=#RoleView] uiClkHandler
---- @param self
---- @param #CCNode 点击的UI
---- @param #CCRect 点击的区域,nil代表点击了contentSize
---- 
--function RoleView:uiClkHandler( ui, rect )
--	--printf("uiuiuuiuiuiuuuuuuu")
--	if ui == self["vipBgSpr"] then
--		--local gameView = require("view.GameView")
--		--local shopVip = require("view.shop.ShopVipView")
--		--gameView.addPopUp(shopVip.createInstance(), true)
--	end
--end

---
-- 延时请求协议
-- @function [parent=#RoleView] _delay
-- @param self
-- 
function RoleView:_delay()
	local GameNet = require("utils.GameNet")
	local func = function()
		GameNet.send("C2s_hero_maininfo", {place_holder = 1})
	end
	
	local action = transition.sequence({
			CCDelayTime:create(5),
			CCCallFunc:create(func),
		})
	self:runAction(action)
end

function RoleView:_understandBtnHandler(sender, event)
	local HeroAttr = require("model.HeroAttr")
	
	if tonumber(HeroAttr.Grade) >= 13 then
		local UnderstandMartialView = require("view.role.UnderstandMartialView").createInstance()
		UnderstandMartialView:openUi(self._buffInfo)
	else
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("参悟武学需13级开启"))
	end
	
	if self._buffTipView and self._buffTipView:isVisible() then
		self._buffTipView:setVisible(false)
	end	
end

---
-- 发送buff请求
-- @function [parent=#RoleView] _sendBuffRequest
-- @param self
--
function RoleView:_sendBuffRequest()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_buff_msg", {place_holder = 1})
end

---
-- 添加点击控件
-- @function [parent=#RoleView] _addBuffClkUi
-- @param
--
function RoleView:_addBuffClkUi()
	for i = 1, 8 do
		self:addClkUi("backSpr" .. i)
	end
end

---
-- ui点击处理
-- @function [parent=#RoleView] _uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- 
function RoleView:_uiClkHandler(ui)
	if not self._buffTipView then
		self._buffTipView = require("view.role.TipView").new()
		self:addChild(self._buffTipView)
	else
		self._buffTipView:setVisible(true)
	end
		
	local index = self:_getIndexByUi(ui)
	
	if self._buffTable[index] then
		self._buffTipView:setTipPositionAndContent(self:_getClkUiInfo(ui, index))
	else
		self._buffTipView:setVisible(false)
	end
end

---
-- 点击处理
-- @function [parent=#RoleView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function RoleView:uiClkHandler(ui, rect)
	if ui == self["vipBgSpr"] then
		-- 判断有没有开充值
		local ConfigParams = require("model.const.ConfigParams")
		if CONFIG[ConfigParams.OPEN_PAY] and CONFIG[ConfigParams.OPEN_PAY] > 0 then
			-- 弹出VIP特权界面
			local shopMainView =  require("view.shop.ShopMainView").createInstance()
			shopMainView:openUi(4)
			shopMainView:setVipView()
		end
	elseif ui == self["yuanBaoAddSpr"] then
		-- 判断有没有开充值
		local ConfigParams = require("model.const.ConfigParams")
		if CONFIG[ConfigParams.OPEN_PAY] and CONFIG[ConfigParams.OPEN_PAY] > 0 then
			-- 弹出VIP特权界面
			local shopMainView =  require("view.shop.ShopMainView").createInstance()
			shopMainView:openUi(4)
		end
	elseif ui == self["silverAddSpr"] then
		local playOpenData = require("xls.PlayOpenXls").data
		local heroGrade = require("model.HeroAttr").Grade
		if heroGrade >= playOpenData["zhaocai"].StartLevel then 
			local PlayView = require("view.qiyu.PlayView").createInstance()
			local uiId = require("model.Uiid")
			PlayView:openUi(1, uiId.UIID_ZHAOCAI)
		else
			local notify = require("view.notify.FloatNotify")
			notify.show(tr("等级不足"..playOpenData["zhaocai"].StartLevel..",不能开始招财"))
		end
	end
end

---
-- 根据点击ui获取提示框需要的信息
-- @function [parent=#RoleView] _getClkUiInfo
-- @param self
-- @param #CCNode ui 点击的ui
-- @param #number index
-- @return x, y, attrDes, count, time
--
function RoleView:_getClkUiInfo(ui, index)
	local px, py = ui:getPosition()
	
	local x, y = px - 52, py + 52
	
	if index == 7 then
		x = px - 82
	elseif index == 8 then
		x = px + 52 - 270
	end
	
	return x, y, self._buffTable[index]
end

---
-- 处理buff信息
-- @function [parent=#RoleView] handleBuffInfo
-- @param self
-- @param #talbe pb
--
function RoleView:handleBuffInfo(pb)
	self._buffInfo = pb
	
	if not pb.has_prop then return end
	
	if self._buffTipView then
		self._buffTipView:setVisible(false)
	end
	
	printf("prop_length: %d", #pb.has_prop)
	
	self._buffTable = nil
	self._buffTable = {}
	
	for i = 1, 8 do
		self["backSpr" .. i].info = nil
	end
	
	local index
	for _, v in ipairs(pb.has_prop) do
		if v.prop_name == "Hp" then
			index = 1
		elseif v.prop_name == "Ap" then
			index = 2
		elseif v.prop_name == "Speed" then
			index = 3
		elseif v.prop_name == "Dp" then
			index = 4
		elseif v.prop_name == "Double" then
			index = 5
		elseif v.prop_name == "HitRate" then
			index = 6
		elseif v.prop_name == "Dodge" then
			index = 7
		elseif v.prop_name == "ReDouble" then
			index = 8
		end
		self._buffTable[index] = v
	end
	
	for i = 1, 8 do
		if self._buffTable[i] then
			self:restoreSprite(self["backSpr" .. i])
			self:restoreSprite(self["iconSpr" .. i])
		else
			self:setGraySprite(self["backSpr" .. i])
			self:setGraySprite(self["iconSpr" .. i])
		end
	end
	
	if self._buffSubView then
		self._buffSubView:init(pb)
	end
	
	-- 倒数
	local scheduler = require("framework.client.scheduler")
	if self._buffHandler then
		scheduler.unscheduleGlobal(self._buffHandler)
		self._buffHandler = nil
	end
	
	self._buffHandler = scheduler.scheduleGlobal(function(...)
		for _, v in ipairs(pb.has_prop) do
			v.rest_time = v.rest_time - 1
			
			if v.rest_time <= 0 then
				v.rest_time = 0
				scheduler.performWithDelayGlobal(function(...)
					self:_sendBuffRequest()
				end, 1)
			end
		end
		
		if self._buffTipView and self._buffTipView:isVisible() then
			self._buffTipView:flashTime()
		end
		
		if self._buffSubTipView and self._buffSubTipView:isVisible() then
				self._buffSubTipView:flashTime()
			end
	end, 1)
end

---
-- 设置buff子提示框
-- @function [parent=#RoleView] setBuffSubTipView
-- @param self
-- @param #CCLayer subView
-- 
function RoleView:setBuffSubTipView(subView)
	self._buffSubTipView = subView
end

---
-- 设置buff子提示框
-- @function [parent=#RoleView] setBuffSubView
-- @param self
-- @param #CCLayer subView
-- 
function RoleView:setBuffSubView(subView)
	self._buffSubView = subView
end

---
-- 根据ui得到对应index
-- @function [parent=#RoleView] _getIndexByUi
-- @param self
-- @param #CCNode ui
-- @return #number
--
function RoleView:_getIndexByUi(ui)
	for i = 1, 8 do
		if ui == self["backSpr" .. i] then
			return i
		end
	end
end

---
-- 根据ui得到对应index
-- @function [parent=#RoleView] _createBuffPosTable
-- @param self
--
function RoleView:_createBuffPosTable()
	self._buffPosTable = {}

	local l, r, t, b
	local x, y, pos, size
	for i = 1, 8 do
		x, y = self["backSpr" .. i]:getPosition()
		size = self["backSpr" .. i]:getContentSize()
		l, r = x - size.width / 2, x + size.width / 2
		t, b = y + size.height / 2, y - size.height / 2
		table.insert(self._buffPosTable, {l = l, r = r, t = t, b = b}) 
	end
end

---
-- 根据ui得到对应index
-- @function [parent=#RoleView] _getIndexByPos
-- @param self
-- @param #number x
-- @param #number y
-- @return #number
--
function RoleView:_getIndexByPos(x, y)
	if not self._buffPosTable then
		self:_createBuffPosTable()
	end
	
	for k, v in ipairs(self._buffPosTable) do
		if (x >= v.l and x <= v.r and y >= v.b and y <= v.t) then
			return k
		end
	end
	
	return 0
end