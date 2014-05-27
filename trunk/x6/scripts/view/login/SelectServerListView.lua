---
-- 选择服务器列表界面
-- @module view.login.SelectServerListView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local ccp = ccp
local CCSize = CCSize
local tolua = tolua
local CONFIG = CONFIG

local moduleName = "view.login.SelectServerListView"
module(moduleName)

---
-- 类定义
-- @type SelectServerListView
-- 
local SelectServerListView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 最后点击的ui
-- @field [parent=#SelectServerListView] #CCNode _lastClkUi
-- 
SelectServerListView._lastClkUi = nil

---
-- 构造函数
-- @function [parent=#SelectServerListView] ctor
-- @param self
-- 
function SelectServerListView:ctor()
	SelectServerListView.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#SelectServerListView] _create
-- @param self
-- 
function SelectServerListView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_login/ui_selectserver2.ccbi")
	
	self:createClkHelper()
	self:addClkUi("pageUpSpr")
	self:addClkUi("pageDownSpr")
	
	self:handleMenuItemEvent("lastMItem", self._menuItemClkHandler)
	self:handleButtonEvent("closBtn", self._closeClkHandler)
	
	self["selectVCBox"].owner = self
	self["selectVCBox"]:setHCount(2)
	self["selectVCBox"]:setVCount(3)
	self["selectVCBox"]:setHSpace(13)
	self["selectVCBox"]:setVSpace(0.5)
	
	local SelectServerListCell = require("view.login.SelectServerListCell")
	self["selectVCBox"]:setCellRenderer(SelectServerListCell)
	
	self["selectVCBox"]:setZOrder(2)
	self["lastLab"]:setString(tr("测试区"))
	
	self["pageUpSpr"]:setVisible(false)
	self["pageDownSpr"]:setVisible(false)
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	local device = require("framework.client.device")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then

		if SelectServerLogic.serverList ~= nil then
			self["selectVCBox"]:setDataSet(SelectServerLogic.serverList)
			local arr = SelectServerLogic.serverList:getArray()
			if #arr > 6 then
				self["pageUpSpr"]:setVisible(true)
				self["pageDownSpr"]:setVisible(true)
			end
		else
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.show()
		end
	else
		local DataSet = require("utils.DataSet")
		local ds = DataSet.new()
		local arr = {{server_name = tr("测试区")}}
		ds:setArray(arr)
		self["selectVCBox"]:setDataSet(ds)
	end
end

---
-- 打开界面
-- @function [parent=#SelectServerListView] openUi
-- @param self
-- @param #string lastStr
-- 
function SelectServerListView:openUi(lastStr)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	if SelectServerLogic.defaultServerName then
		self["lastLab"]:setString(SelectServerLogic.defaultServerName)
	else
		self["lastLab"]:setString(lastStr)
	end
end

---
-- 请求服务器列表回调函数
-- @function [parent=#SelectServerListView] serverListCallBack
-- @param self
--
function SelectServerListView:serverListCallBack()
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	self["lastLab"]:setString(SelectServerLogic.defaultServerName)
	local SelectSererData =require("model.SelectServerData")	
	if SelectSererData.serverList ~= nil then
		if SelectSererData.serverList ~= nil then
			self["selectVCBox"]:setDataSet(SelectSererData.serverList)
			local arr = SelectSererData.serverList:getArray()
			if #arr > 6 then
				self["pageUpSpr"]:setVisible(true)
				self["pageDownSpr"]:setVisible(true)
			end
		end
    end
end

---
-- 列表项点击处理函数
-- @function [parent=#SelectServerListView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的ui
-- @param #CCRect rect 点击的区域，默认为contentsize
-- 
function SelectServerListView:uiClkHandler(ui, rect)
	if ui == self["pageUpSpr"] then
		self:_pageUpClkHandler()
	elseif ui == self["pageDownSpr"] then
		self:_pageDownClkHandler()
	end
end

---
-- 上翻页按钮处理函数
-- @function [parent=#SelectServerListView] _pageUpClkHandler
-- @param self
-- @param #CCNode sender 被点击者
-- @param #table event 事件
-- 
function SelectServerListView:_pageUpClkHandler()
	local selectVCBox = self["selectVCBox"]
	local firstVisibleIndex = selectVCBox:getFirstVisibleIndex()
	local len = selectVCBox:getDataSet():getLength()
	local beginIndex
	if firstVisibleIndex + 6 > len then
		beginIndex = len - 5
	else
		beginIndex = firstVisibleIndex + 6
	end
	
	selectVCBox:scrollToIndex(beginIndex, true)
end

---
-- 下翻页按钮处理函数
-- @function [parent=#SelectServerListView] _pageDownClkHandler
-- @param self
-- @param #CCNode sender 被点击者
-- @param #table event 事件
-- 
function SelectServerListView:_pageDownClkHandler() 
	local selectVCBox = self["selectVCBox"]
	local firstVisibleIndex = selectVCBox:getFirstVisibleIndex()
	
	local beginIndex
	if firstVisibleIndex - 6 < 1 then
		beginIndex = 1
	else
		beginIndex = firstVisibleIndex - 6
	end
	
	selectVCBox:scrollToIndex(beginIndex, true)
end

---
-- 最近登录菜单项点击处理函数
-- @function [parent=#SelectServerListView] _menuItemClkHandler
-- @param self
-- 
function SelectServerListView:_menuItemClkHandler()
	local SelectServerView = require("view.login.SelectServerView")
	local SelectServerViewInstance = SelectServerView.instance
	if not SelectServerViewInstance then
		printf(tr("没有SelectServerView实例"))
		return 
	end
	SelectServerViewInstance:setNewLab(self["lastLab"]:getString())
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	SelectServerLogic.newServerName = nil
	SelectServerLogic.newServerIP = nil
	SelectServerLogic.newServerPort = nil
	SelectServerLogic.newServerID = nil
	SelectServerLogic.newServerAreaID = nil
	SelectServerLogic.newServerState = nil
	SelectServerLogic.newServerTip = nil
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 关闭按钮点击处理函数
-- @function [parent=#SelectServerListView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectServerListView:_closeClkHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 退出场景
-- @function [parent=#SelectServerListView] onExit
-- @param self
-- 
function SelectServerListView:onExit()
	instance = nil
	
	local SelectSererData =require("model.SelectServerData")
--	local DataSet = require("utils.DataSet")
--	SelectSererData.serverList:removeEventListener(DataSet.CHANGED.name, self.serverListCallBack, self)
	
	self["selectVCBox"]:setDataSet(nil)
	SelectServerListView.super.onExit(self)
end

