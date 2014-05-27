--- 
-- 排名单人cell
-- @module view.rank.RankItemCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local os = os

local moduleName = "view.rank.RankItemCell"
module(moduleName)


--- 
-- 类定义
-- @type RankItemCell
-- 
local RankItemCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 排行榜信息
-- @field [parent=#RankItemCell] #table _info
-- 
RankItemCell._info = nil

--- 创建实例
-- @return RankItemCell实例
function new()
	return RankItemCell.new()
end

--- 
-- 构造函数
-- @function [parent=#RankItemCell] ctor
-- @param self
-- 
function RankItemCell:ctor()
	RankItemCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#RankItemCell] _create
-- @param self
-- 
function RankItemCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_userankplece1.ccbi", true)
	self:handleButtonEvent("pkBtn", self._pkClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi("scrollLeftSpr")
	self:addClkUi("scrollRightSpr")
	
--	self["partnersHBox"]:enableScroll(false)
	self["partnersHBox"]:setScrollThreshold(20)
	self["partnersHBox"]:setSnapWhenNoScrollHeight(false)
	local ScrollView = require("ui.ScrollView")
	self["partnersHBox"]:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	self["timeLab"]:setString("")
--	self["partnersHBox"]:setSwallow()
end

--- 
-- 点击了关闭
-- @function [parent=#RankItemCell] _pkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function RankItemCell:_pkClkHandler( sender, event )
	if not self._info then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_ranklist_fight", {uid = self._info.uid})
end

--- 
-- 显示数据
-- @function [parent=#RankItemCell] showItem
-- @param self
-- @param #Randomev_info info
-- 
function RankItemCell:showItem( info )
	local scheduler = require("framework.client.scheduler")
	if( not info ) then
		self:stopAllActions()
		return
	end
	
	self._info = info
	
	self["levelLab"]:setString("lv" .. info.grade)
	self["nameLab"]:setString(info.name)
	self["pointLab"]:setString(info.score)
	self["vipSpr"]:setVisible(info.isvip == 1)
	
	if info.rank < 4 then
		local spriteStr
		if info.rank == 1 then
			spriteStr = "ccb/wulingbang/one.png"
		elseif info.rank == 2 then
			spriteStr = "ccb/wulingbang/two.png"
		else
			spriteStr = "ccb/wulingbang/three.png"
		end
		self:changeFrame("rankSpr", spriteStr)
		self["rankNumLab"]:setVisible(false)
		self["rankSpr"]:setVisible(true)
	else
		self["rankSpr"]:setVisible(false)
		self["rankNumLab"]:setVisible(true)
		self["rankNumLab"]:setBmpPathFormat("ccb/number/%d.png")
		self["rankNumLab"]:setValue(info.rank)
	end
	
	local box = self["partnersHBox"]
	box:setSnapWidth(118)
	box:setSnapHeight(0)
	box:removeAllItems()
	
	
	if #info.partner_list < 6 then
		self["scrollLeftSpr"]:setVisible(false)
		self["scrollRightSpr"]:setVisible(false)
	else
		self["scrollLeftSpr"]:setVisible(false)
		self["scrollRightSpr"]:setVisible(true)
	end
	
	local PartnerCell = require("view.rank.PartnerCell")
	for i = 1, #info.partner_list do
		local partner = PartnerCell.new()
		box:addItem(partner)
		partner:showInfo(info.partner_list[i])
	end
	
	local leftTime = info.fight_time - os.time()
	-- 切磋倒计时
	if leftTime > 0 then
		self["pkSpr"]:setVisible(false)
		self["pkBtn"]:setEnabled(false)
		self["timeLab"]:setVisible(true)
		
		local func = function()
			leftTime = info.fight_time - os.time()
			if leftTime <= 0 then
				self:stopAllActions()
				
				self["pkSpr"]:setVisible(true)
				self["pkBtn"]:setEnabled(true)
				self["timeLab"]:setVisible(false)
			end
			self["timeLab"]:setString(leftTime.."s")
		end
		self:schedule(func, 1)
	else
		self["pkSpr"]:setVisible(true)
		self["pkBtn"]:setEnabled(true)
		self["timeLab"]:setVisible(false)
	end
end

---
-- ui点击处理
-- @function [parent=#RankItemCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function RankItemCell:uiClkHandler( ui, rect )
	local count = #self["partnersHBox"]:getItemArr()
	if count < 6 then return end
	
	if ui == self["scrollRightSpr"] then
		self["partnersHBox"]:scrollToIndex(2, true)
		self["scrollRightSpr"]:setVisible(false)
		self["scrollLeftSpr"]:setVisible(true)
	else
		self["partnersHBox"]:scrollToIndex(1, true)
		self["scrollLeftSpr"]:setVisible(false)
		self["scrollRightSpr"]:setVisible(true)
	end
end

---
-- 拖动
-- @function [parent=#RankItemCell] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function RankItemCell:_scrollChangedHandler( event )
	if event == nil then return end
	
	local count = #self["partnersHBox"]:getItemArr()
	
	if -event.curX < 118 and count == 6 then
		self["scrollLeftSpr"]:setVisible(false)
		self["scrollRightSpr"]:setVisible(true)
	elseif count == 6 then
		self["scrollRightSpr"]:setVisible(false)
		self["scrollLeftSpr"]:setVisible(true)
	end
end
