---
-- 运营活动新界面
-- @module view.activity.ActivityNewView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local pairs = pairs
local dump = dump
local transition = transition
local CCRotateTo = CCRotateTo
local CCScaleTo = CCScaleTo
local CCMoveTo = CCMoveTo
local CCCallFunc = CCCallFunc
local ccp = ccp
local display = display
local table = table
local string = string
local math = math
local CCRect = CCRect


local moduleName = "view.activity.ActivityNewView"
module(moduleName)

---
-- 类定义
-- @type ActivityNewView
-- 
local ActivityNewView = class(moduleName, require("ui.CCBView").CCBView)

--- 
--  关闭界面时，是否播放动画
--  @field [parent=#ActivityNewView] #boolean _isPlay 
--  
ActivityNewView._isPlay = false

--- 
--  活动信息表
--  @field [parent=#ActivityNewView] #table _actTbl
--  
ActivityNewView._actTbl = nil

--- 
--  圆点位置信息表
--  @field [parent=#ActivityNewView] #table _dotPosTbl
--  
ActivityNewView._dotPosTbl = nil

--- 
--  当前显示的第几个活动
--  @field [parent=#ActivityNewView] #number _showIndex
--  
ActivityNewView._showIndex = 1

---
-- 保存延迟信息表
-- @field [parent = #view.activity.ActivityNewView] _delayMsg
-- 
local _delayMsg = nil

---
-- 构造函数
-- @function [parent=#ActivityNewView] ctor
-- @param self
-- 
function ActivityNewView:ctor()
	ActivityNewView.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ActivityNewView] _create
-- @param self
-- 
function ActivityNewView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_chongzhihuodong.ccbi", true)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("activityBtn", self._activityClkHandler)
	
	local box = self["activityHCBox"]
	box.owner = self
	local ActivityNewCell = require("view.activity.ActivityNewCell")
	box:setCellRenderer(ActivityNewCell)
	
	self._actTbl = self:_getActivityList()
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(self._actTbl)
	box:setDataSet(set)
	
	-- 创建小圆点
	self._dotPosTbl = {}
	local actNum = #self._actTbl
	local middle = math.floor((actNum+1)/2)
	local spr, posX
	for i=1, actNum do
		spr = display.newSprite("#ccb/yunying/dot2.png")
		self["dotNode"]:addChild(spr)
		spr:setAnchorPoint(ccp(0.5, 0.5))
		posX = (i-middle)*23
		spr:setPositionX(posX)
		self._dotPosTbl[i] = posX
	end
	self["selectSpr"] = display.newSprite("#ccb/yunying/dot.png")
	self["dotNode"]:addChild(self["selectSpr"])
	
	self["desVBox"]:setSnapHeight(100)
	
	--侦听拖动事件
	local CellBox = require("ui.CellBox")
	box:addEventListener(CellBox.ITEM_SELECTED.name, self._chapterChangedHandler, self)
	
	-- 侦听触摸事件
	self["Layer"] = display.newLayer()
	self:addChild(self["Layer"])
	self["Layer"]:setTouchEnabled(true)
	self["Layer"]:addTouchEventListener(function(...) return self:_onTouch(...) end)
	
	-- 自动滚动
	local scheduler = require("framework.client.scheduler")
	if actNum > 0 then
		local func = function()
			if self._showIndex >= actNum then
				self._showIndex = 1
			else
				self._showIndex = self._showIndex + 1
			end
			self["activityHCBox"]:scrollToIndex(self._showIndex, true)
			self:_showActInfo(self._showIndex)
		end
		self._handle = scheduler.scheduleGlobal(func, 3)
	end
end

---
-- 子项改变处理
-- @function [parent=#ActivityNewView] _chapterChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function ActivityNewView:_chapterChangedHandler(event)
	if event==nil then return end
	
	local index = event.index
	self._showIndex = index
	self:_showActInfo(index)
end

---
-- 显示活动信息
-- @function [parent=#ActivityNewView] _showActInfo
-- @param self
-- @param #number index 活动编号
-- 
function ActivityNewView:_showActInfo(index)
	self["selectSpr"]:setPositionX(self._dotPosTbl[index])
	
	self["nameLab"]:setString(tr(self._actTbl[index].Name))
	self["timeLab"]:setString(tr(self._actTbl[index].Time))
	local des = string.gsub(self._actTbl[index].Info, "\\n", "\n")
	self["desLab"]:setString(tr(des))
	
	self["desVBox"]:removeAllItems()
	local labCell = require("view.activity.ActivityLabCell").new()
	labCell:showItem(des)
	self["desVBox"]:addItem(labCell)
	
	local infoLabHeight = self["desLab"]:getContentSize().height
	if infoLabHeight > 125 then
		self["moreLab"]:setVisible(true)
	else
		self["moreLab"]:setVisible(false)
	end
	
	if self._actTbl[index].ActTrueNo == 1014 then
		self["activityBtn"]:setVisible(true)
		self["activitySpr"]:setVisible(true)
		if self._actTbl[index].ActType == 1 then
			self:changeFrame("activitySpr", "ccb/buttontitle/charge.png")
		else
			self:changeFrame("activitySpr", "ccb/buttontitle/buy.png")
		end
	else
		self["activityBtn"]:setVisible(false)
		self["activitySpr"]:setVisible(false)
	end
end

---
-- 点击了购买/充值
-- @function [parent=#ActivityNewView] _activityClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ActivityNewView:_activityClkHandler(sender,event)
	local info = self._actTbl[self._showIndex]
	if not info then return end
	
	if info.ActType == 1 then
		local shopMainView = require("view.shop.ShopMainView").createInstance()
		shopMainView:openUi(4) --充值页面
		
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	else
		local BuyTipView = require("view.activity.BuyTipView")
		BuyTipView.createInstance():openUi(info)
	end
end

---
-- 点击了关闭
-- @function [parent=#ActivityNewView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ActivityNewView:_closeClkHandler(sender,event)
	if self._isPlay then
		local onComplete = function()
			local GameView = require("view.GameView")
			GameView.removePopUp(self, true)
		end
		
		self:setScale(0.5)
		local x = display.hasXGaps and display.designLeft or 0
		local action1 = transition.sequence({
			CCMoveTo:create(1, ccp(805+x, 55)),
			CCCallFunc:create(onComplete),
		})
		
		local action2 = transition.sequence({
			CCScaleTo:create(1, 0.1, 0.1)
		})
		
		self:setAnchorPoint(ccp(0.5, 0.5)) -- 设置锚点
		self:setPosition(display.width/2, display.height/2)
		self:runAction(action1)
		self:runAction(action2)
	else
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
	end
end

---
-- 退出场景后自动调用
-- @function [parent=#ActivityNewView] onExit
-- @param self
-- 
function ActivityNewView:onExit()
	local scheduler = require("framework.client.scheduler")
	if self._handle  then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	instance = nil
	ActivityNewView.super.onExit(self)
end

---
-- 获取活动列表
-- @function [parent=#ActivityNewView] _getActivityList
-- @param self
-- @return #table 活动列表
-- 
function ActivityNewView:_getActivityList()
	local activityList = {}
	local ActivityXls = require("xls.ActivityXls").data
	local YouHuiXls = require("xls.YouHuiXls").data
	local RewardData = require("model.RewardData")
	local actInfo = RewardData.activityInfo
	local pushActInfo = RewardData.pushActInfo
	local HeroAttr = require("model.HeroAttr")
	
	local info
	for i=1, #actInfo do
		info = actInfo[i]
		if info.party_no == 1014 and info.is_act == 1 then
			local youhui
			for j=1, #YouHuiXls do
				youhui = YouHuiXls[j]
				if HeroAttr.Grade >= youhui.GreadRange[1] and HeroAttr.Grade <= youhui.GreadRange[2] then
					if pushActInfo and pushActInfo.gift_id == youhui.Id and pushActInfo.type == 1 then
						table.insert(activityList, youhui)
					end
					break
				end
			end
		else
			for k, v in pairs(ActivityXls) do
				if info.party_no == v.ActTrueNo then
					if info.is_act == 1 then
						table.insert(activityList, v)
						break
					end
				end
			end
		end
	end
	
	-- 按活动编号排序
	local func = function(a,b)
		return a.ActivityNo < b.ActivityNo
	end
	table.sort(activityList, func)
--	dump(activityList)
	
	return activityList
end

---
-- 设置播放动画
-- @function [parent=#ActivityNewView] setPlay
-- @param self
-- 
function ActivityNewView:setPlay()
	self._isPlay = true
end


---
-- 触摸事件处理
-- @function [parent=#ActivityNewView] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function ActivityNewView:_onTouch(event,x,y)
	if event == "began" then
        return self:_onTouchBegan(x, y)
    elseif event == "moved" then
        self:_onTouchMoved(x, y)
    elseif event == "ended" then
        self:_onTouchEnded(x, y)
    end
end

---
-- 触摸开始
-- @function [parent=#ActivityNewView] _onTouchBegan
-- @param self
-- @param #number x 
-- @param #number y 
-- @return #boolean
-- 
function ActivityNewView:_onTouchBegan(x,y)
	local worldPt = ccp(x, y)
	local localPt = self:convertToNodeSpace(worldPt)
	local scheduler = require("framework.client.scheduler")
	local rect = CCRect(0,00,670,480)
	-- 触摸在本界面上
	if rect:containsPoint(localPt) then
		-- 取消自动滚动
		if self._handle then
			scheduler.unscheduleGlobal(self._handle)
			self._handle = nil
		end
		return true
	else
		return false
	end
end

---
-- 触摸移动
-- @function [parent=#ActivityNewView] _onTouchMoved
-- @param self
-- @param #number x 
-- @param #number y 
-- 
function ActivityNewView:_onTouchMoved(x,y)

end

---
-- 触摸结束
-- @function [parent=#ActivityNewView] _onTouchEnded
-- @param self
-- @param #number x 
-- @param #number y
-- 
function ActivityNewView:_onTouchEnded(x,y)
	-- 自动滚动
	local scheduler = require("framework.client.scheduler")
	local actNum = #self._actTbl
	if actNum > 0 then
		local func = function()
			if self._showIndex >= actNum then
				self._showIndex = 1
			else
				self._showIndex = self._showIndex + 1
			end
			self["activityHCBox"]:scrollToIndex(self._showIndex, true)
			self:_showActInfo(self._showIndex)
		end
		self._handle = scheduler.scheduleGlobal(func, 3)
	end
end


---
-- 添加延迟信息
-- @function [parent = #view.activity.ActivityNewView] addDelayMsg
-- @param #table msg
-- 
function addDelayMsg(msg)
	_delayMsg = msg
end

---
-- 处理延迟信息
-- @function [parent = #view.activity.ActivityNewView] dealDelayMsg
-- 
function dealDelayMsg()
 	if _delayMsg then
 		local GameView = require("view.GameView")
		local BuyTipView = require("view.activity.BuyTipView")
		GameView.addPopUp(BuyTipView.createInstance(), true)
		GameView.center(BuyTipView.instance)
		BuyTipView.instance:setShowMsg(_delayMsg)
		_delayMsg = nil
	end
end





