---
-- 比武主界面
-- @module view.biwu.BiWuView
--

local require = require
local class = class
local printf = printf
local display = display 
local table = table


local moduleName = "view.biwu.BiWuView"
module(moduleName)


--- 
-- 类定义
-- @type BiWuView
-- 
local BiWuView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 比武底下信息
-- @field [parent=#BiWuView] #CCNode bottomInfoUi
-- 
BiWuView.bottomInfoUi = nil

---
-- 积分商店底下信息
-- @field [parent=#BiWuView] #CCNode bottomPageUi
-- 
BiWuView.bottomPageUi = nil

---
-- 挑战对手列表
-- @field [parent=#BiWuView] utils.DataSet#DataSet _chlgSet
-- 
BiWuView._chlgSet = nil

---
-- 构造函数
-- @function [parent = #BiWuView] ctor
-- 
function BiWuView:ctor()
	BiWuView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BiWuView] _create
-- 
function BiWuView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pk.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeWindowHandler)
	self:handleRadioGroupEvent("tab1RGrp", self._tabClkHandler)
	
	self["tab2RGrp"].menu:setEnabled(false)
	
	local box = self["infoPCBox"] -- ui.PageCellBox#PageCellBox
	box:setHCount(4)
	box:setVCount(1)
	box:setHSpace(8)
	box.owner = self
	--box:enableScroll(false)
	
	--侦听拖动事件
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	local bottomBox = self["bottomHBox"] -- ui.HBox#HBox
	bottomBox:enableScroll(false)
	local BWBottomInfoUi = require("view.biwu.BWBottomInfoUi")
	self.bottomInfoUi = BWBottomInfoUi.createInstance()
	bottomBox:addItem(self.bottomInfoUi)
	
	local BWBottomPageUi = require("view.biwu.BWBottomPageUi")
	self.bottomPageUi = BWBottomPageUi.createInstance()
	bottomBox:addItem(self.bottomPageUi)
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 角色属性更新
-- @function [parent=#BiWuView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function BiWuView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	
	local tbl = event.attrs
	if tbl.BiWuJiFen then
		self["jiFenLab"]:setString(tbl.BiWuJiFen)
	end
	
	if tbl.Score then
		self.bottomInfoUi["pointLab"]:setString(tbl.Score)
	end
	
	if tbl.Vigor or tbl.VigorMax then
		local HeroAttr = require("model.HeroAttr")
		self["vigourLab"]:setString(HeroAttr.Vigor .. "/" .. HeroAttr.VigorMax)
	end
end

---
-- 点击了tab
-- @function [parent=#BiWuView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function BiWuView:_tabClkHandler( event )
	local box = self["infoPCBox"] -- ui.PageCellBox#PageCellBox
	self._selectedIndex = self["tab1RGrp"]:getSelectedIndex()
	
	-- 显示对手
	if(self._selectedIndex <= 1) then
		local cell = require("view.biwu.BWPlayerCell")
		box:setCellRenderer(cell)
		if not self._chlgSet then
			--- 获取比武界面信息
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_biwu_info", {open_type = 1})
			
			local netLoading = require("view.notify.NetLoading")
			netLoading.show()
		else
			box:setDataSet(self._chlgSet)
		end
		
	-- 显示积分商店
	elseif(self._selectedIndex == 2) then
		local cell = require("view.biwu.BWItemCell")
		box:setCellRenderer(cell)
		box:setDataSet(nil)
		
		-- 每次都要重新获取商品信息
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_biwu_shop_info", {index = 1})
	end
	
	local bottomBox = self["bottomHBox"] -- ui.HBox#HBox
	bottomBox:scrollToIndex(self._selectedIndex)
end

---
-- 关闭窗口 按钮回调事件
-- @function [parent = #BiWuView] _closeWindowHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiWuView:_closeWindowHandler(sender, event)
	local mainView = require("view.main.MainView")
    local GameView = require("view.GameView")
	--GameView.replaceMainView(mainView.createInstance(), true)
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BiWuView] openUi
-- @param self
-- 
function BiWuView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	self:_tabClkHandler()
end

---
-- 拖动
-- @function [parent=#BiWuView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function BiWuView:_scrollChangedHandler( event )
	if(event==nil) then return end
	
	local curPage = self["infoPCBox"]:getCurPage()
	if( curPage < 1 ) then curPage = 1 end
	local numPage = self["infoPCBox"]:getNumPage()
	if( numPage < 1 ) then numPage = 1 end
	self.bottomPageUi["pageCcb.pageLab"]:setString(curPage.."/"..numPage)
end

---
-- 比武对手信息
-- @function [parent=#BiWuView] showBaseInfo
-- @param self
-- @param #S2c_biwu_info pb
-- 
function BiWuView:showListInfo( pb )
	self["jiFenLab"]:setString("" .. pb.user_jifen)
	self.bottomInfoUi["pointLab"]:setString("" .. pb.user_score)
	local HeroAttr = require("model.HeroAttr")
	self["vigourLab"]:setString(HeroAttr.Vigor .. "/" .. HeroAttr.VigorMax)
	
	local len = #pb.biwu_info
	local arr = {}
	for i = 1, 4 do
		local player = pb.biwu_info[i]
		if player then
			player.isFalse = false
		else
			player = {}
			player.isFalse = true
		end
		
		arr[i] = player
	end
	
	if not self._chlgSet then
		local DataSet = require("utils.DataSet")
		self._chlgSet = DataSet.new()
	end
	self._chlgSet:setArray(arr)
	
	if self._selectedIndex <= 1 then
		local box = self["infoPCBox"] -- ui.PageCellBox#PageCellBox
		box:setDataSet(self._chlgSet)
	end
end

---
-- 积分商店信息
-- @function [parent=#BiWuView] showShopInfo
-- @param self
-- @param #S2c_biwu_shop_info pb
-- 
function BiWuView:showShopInfo( pb )
	if self._selectedIndex ~= 2 then return end
	
	local len = #pb.shop_info
	local arr = {}
	for i = 1, len do
		local item = pb.shop_info[i]
		if item then
			item.isFalse = false
		else
			item = {}
			item.isFalse = true
		end
		
		table.insert(arr, item)
	end
	
	local left = #arr%4
	if left ~= 0 or #arr == 0 then
		local item = {}
		item.isFalse = true
		for i = 1, (4-left) do
			table.insert(arr, item)
		end
	end
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(arr)
	local box = self["infoPCBox"] -- ui.PageCellBox#PageCellBox
	box:setDataSet(set)
end

---
-- 场景退出回调
-- @function [parent = #BiWuView] onExit
-- 
function BiWuView:onExit()
	--移除监听
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	require("view.biwu.BiWuView").instance = nil
	BiWuView.super.onExit(self)	
end



