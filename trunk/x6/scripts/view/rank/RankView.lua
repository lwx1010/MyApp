--- 
-- 排行榜界面
-- @module view.rank.RankView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local CCSize = CCSize
local ccp = ccp
local ipairs = ipairs
local CCArray = CCArray
local display = display
local pairs = pairs
local os = os

local moduleName = "view.rank.RankView"
module(moduleName)


--- 
-- 类定义
-- @type RankView
-- 
local RankView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 显示列表
-- @field [parent=#RankView] #table _showList
-- 
RankView._showList = nil

---
-- 上次触摸坐标x
-- @field [parent=#RankView] #number _lastX
-- 
RankView._lastX = nil

---
-- 上次触摸坐标y
-- @field [parent=#RankView] #number _lastY
-- 
RankView._lastY = nil

--- 
-- 构造函数
-- @function [parent=#RankView] ctor
-- @param self
-- 
function RankView:ctor()
	RankView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

--- 
-- 创建
-- @function [parent=#RankView] _create
-- @param self
-- 
function RankView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_userank.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local RankItemCell = require("view.rank.RankItemCell")
	local pbox = self["playersVCBox"] -- ui.CellBox #CellBox
--	pbox:setSnapWidth(0)
--	pbox:setSnapHeight(125)
	pbox:setCellRenderer(RankItemCell)
	pbox:setScrollThreshold(20)
	pbox:setSnapWhenNoScrollWidth(false)
--	local ScrollView = require("ui.ScrollView")
--	pbox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	local HeroAttr = require("model.HeroAttr")
	self["pointLab"]:setString("" .. (HeroAttr.Score or 0))
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	self._lastX, self._lastY = 0, 0
end

--- 
-- 数据变化
-- @function [parent=#RankView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function RankView:_attrsUpdatedHandler( event )
	if not event.attrs then return end
	
	local tbl = event.attrs 
	local HeroAttr = require("model.HeroAttr")
	
	if tbl.Score then
		self["pointLab"]:setString("" .. tbl.Score)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#RankView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RankView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	local MainView = require("view.main.MainView")
	GameView.removePopUp(self)
end

---
-- 打开界面调用
-- @function [parent=#RankView] openUi
-- @param self
-- 
function RankView:openUi()
	-- 加载等待
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	self:showRankList()
	self:showBaseInfo()
	
	--每次打开界面都会重新请求协议
--	local GameNet = require("utils.GameNet")
--	GameNet.send("C2s_ranklist_info", {place_holder = 1})
--	GameNet.send("C2s_ranklist_selfinfo", {place_holder = 1})
end

---
-- 显示基础信息
-- @function [parent=#RankView] showBaseInfo
-- @param self
-- 
function RankView:showBaseInfo( )
	local RankData = require("model.RankData")
	
	self["indexLab"]:setString( "" .. (RankData.getRank() or "") )
	
--	if pb.changerank < 0 then
--		self:changeFrame("changeSpr", "ccb/mark2/mark_up.png")
--		self["changeLab"]:setString("　　" .. math.abs(pb.changerank))
--	elseif pb.changerank > 0 then
--		self:changeFrame("changeSpr", "ccb/mark2/mark_down.png")
--		self["changeLab"]:setString("　　" .. math.abs(pb.changerank))
--	else
--		self:changeFrame("changeSpr", nil)
--		self["changeLab"]:setString("--")
--	end
end

---
-- 显示排名列表
-- @function [parent=#RankView] showRankList
-- @param self
-- 
function RankView:showRankList( )
	local RankData = require("model.RankData")
	local ds = RankData.getData()
	if not ds then return end
	
	self._showList = ds:getArray()
	
	local pBox = self["playersVCBox"]
	pBox:setDataSet(ds)
	
	
--	if not info then return end
--	
--	local list = info.list_info
--	
--	function sortByRank(a, b)
--		return a.rank < b.rank
--	end
--	
--	local table = require("table")
--	table.sort(list, sortByRank)
--	
--	local function sortByPos(a, b)
--		return a.pos < b.pos
--	end
--	
--	local endTime = info.fight_time + os.time()
--	for k, v in pairs(list) do
--		v["fight_time"] = endTime
--	end
--	
--	self._showList = list
--	local pBox = self["playersVCBox"]
--	pBox:setDataSet(nil)
--	
--	local DataSet = require("utils.DataSet")
--	local ds = DataSet.new()
--	ds:setArray(list)
--	pBox:setDataSet(ds)
--	
--	local RankItemCell = require("view.rank.RankItemCell")
--	for i = 1, #list do
--		local cell = RankItemCell.new()
--		local info = list[i]
--		cell:showItem(info)
--		pBox:addItem(cell)
--	end
	
	--local arr = pBox:getItemArr()
	--printf(" the length of pBox1: " .. #arr )
	
--	local len = math.ceil(#list/10)
--	local RankListView = require("view.rank.RankListView")
--	for i = 1, len do
--		local view = RankListView.new()
--		view:showPlayers( list, i )
--		pBox:addItem(view, i)
--	end
	
--	local VBox = require("ui.VBox")
--	for i = 1, len do
--		local view = RankListView.new()
--		view:showPlayers( list, i )
--		
--		local box = VBox.new()
--		box:setContentSize(view:getContentSize())
--		box:setAnchorPoint(ccp(0,0))
----		box:setVSpace(8)
--		box:addItem(view)
--		pBox:addItem(box, i)
--	end
--	
--	pBox:validate()
--	local arr = pBox:getItemArr()
--	printf(" the length of pBox2: " .. #arr )
end

---
-- 拖动
-- @function [parent=#RankView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function RankView:_scrollChangedHandler( event )
	if event == nil then return end
--	
--	if math.abs(event.curY - self._lastY) < 10 then
--		self["playersVCBox"]:scrollToPos(0, self._lastY, false)
--	end
--	
--	self._lastY = event.curY
--	local pBox = self["playersHBox"] -- ui.CellBox#CellBox
--	local width = pBox:getSnapWidth()
--	
--	local len = 1
--	if self._showList then 
--		len = math.ceil(#self._showList/10)
--	end
--	
--	local index = 0
--	if width > 0 then
--		index = math.floor(( 0 - event.curX )/width) + 1
--	end
--	
--	if index < 1 then index = 1 end
--	if index > len then index = len end
--	
--	self["pageCcb.pageLab"]:setString( index .. "/" .. len )
end

---
-- 退出界面时调用
-- @function [parent=#RankView] onExit
-- @param self
-- 
function RankView:onExit()
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	self["playersVCBox"]:setDataSet(nil)
	
	instance = nil
	
	RankView.super.onExit(self)
end

---
-- 切磋冷却时间
-- @function [parent=#RankView] updateFightTime
-- @param self
-- @param #number time 
-- 
function RankView:updateFightTime(time)
	if not self._showList then return end
	
	local endTime = time + os.time()
	for k, v in pairs(self._showList) do
		v["fight_time"] = endTime
	end
	
	local pBox = self["playersVCBox"]
	pBox:setDataSet(nil)
	
	local DataSet = require("utils.DataSet")
	local ds = DataSet.new()
	ds:setArray(self._showList)
	pBox:setDataSet(ds)
end









