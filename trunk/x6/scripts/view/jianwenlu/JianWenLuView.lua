---
-- 见闻录界面
-- @module view.jianwenlu.JianWenLuView
-- 

local class = class
local require = require
local printf = printf

local moduleName = "view.jianwenlu.JianWenLuView"
module(moduleName)

---
-- 类定义
-- @type JianWenLuView
-- 
local JianWenLuView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前查看的物品基本信息
-- @field [parent=#JianWenLuView] #table _item 
-- 
JianWenLuView._item = nil

-----
---- 创建实例
---- @return #type description
---- 
--function new()
--	return JianWenLuView.new()
--end

---
-- 构造函数
-- @function [parent=#JianWenLuView] ctor
-- @param self
-- 
function JianWenLuView:ctor()
	JianWenLuView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#JianWenLuView] _create
-- @param self
-- 
function JianWenLuView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jianwenlu2.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	
	local itemsVCBox = self["itemsVCBox"]
	itemsVCBox.owner = self
	
	itemsVCBox:setHCount(7)
	itemsVCBox:setVCount(3)
	itemsVCBox:setHSpace(8)
	itemsVCBox:setVSpace(28)
	local ItemCell = require("view.jianwenlu.ItemCell")
	itemsVCBox:setCellRenderer(ItemCell)
end

---
-- 点击了关闭
-- @function [parent=#JianWenLuView] _closeClkHandler
-- @param self
-- 
function JianWenLuView:_closeClkHandler()
	local GameView = require("view.GameView")
	local MainView = require("view.main.MainView")
    GameView.replaceMainView(MainView.createInstance(), true)
end

--- 
-- 点击了tab
-- @function [parent=#JianWenLuView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function JianWenLuView:_tabClkHandler(event)
	-- 请求列表
	local GameNet = require("utils.GameNet")
	local index = self["tabRGrp"]:getSelectedIndex()
	GameNet.send("C2s_jianwen_base_info", {jianwen_no = index})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local itemsVCBox = self["itemsVCBox"]
	local JianWenLuData = require("model.JianWenLuData")
	local set
	if( index == 1 ) then
		set = JianWenLuData.partnerSet
		itemsVCBox:setDataSet(set)
	elseif( index == 2 ) then
		set = JianWenLuData.MartialSet
		itemsVCBox:setDataSet(set)
	elseif( index == 3 ) then
		set = JianWenLuData.EquipSet
		itemsVCBox:setDataSet(set)
	end
end

---
-- 显示侠客列表信息
-- @function [parent=#JianWenLuView] showChapter
-- @param self
-- 
function JianWenLuView:showPartnerList()
	-- 请求同伴篇章信息
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_jianwen_base_info", {jianwen_no = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	self["tabRGrp"]:setSelectedIndex(1, false)
	local itemsVCBox = self["itemsVCBox"]
	local JianWenLuData = require("model.JianWenLuData")
	local set = JianWenLuData.partnerSet
	itemsVCBox:setDataSet(set)
end

---
-- 请求物品(侠客/武功/神兵)详细信息
-- @function [parent=#JianWenLuView] requireItemInfo
-- @param self
-- @param #table item 物品信息
-- 
function JianWenLuView:requireItemInfo(item)
	self._item = item
	
	local index = self["tabRGrp"]:getSelectedIndex()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2c_jianwen_get_one_info", {item_no=item.item_no, jianwen_no=index})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	if( index == 1 ) then  -- 显示侠客详细信息
		self:_showPartnerInfo(item)
	elseif( index == 2 ) then  -- 显示武功详细信息
		self:_showMartialInfo(item)
	elseif( index == 3 ) then  -- 显示神兵详细信息
		self:_showShenBingInfo(item)
	end
end

---
-- 显示侠客详细信息
-- @function [parent=#JianWenLuView] showPartnerInfo
-- @param self
-- @param #table item 
-- 
function JianWenLuView:_showPartnerInfo(item)
	local PartnerInfoView = require("view.jianwenlu.PartnerInfoView")
	local GameView = require("view.GameView")
	GameView.addPopUp(PartnerInfoView.createInstance(), true)
	GameView.center(PartnerInfoView.instance)
	PartnerInfoView.instance:showIcon(item)
end

---
-- 显示武功详细信息
-- @function [parent=#JianWenLuView] showMartialInfo
-- @param self
-- @param #table item 
-- 
function JianWenLuView:_showMartialInfo(item)
	local MartialInfoView = require("view.jianwenlu.MartialInfoView")
	local GameView = require("view.GameView")
	GameView.addPopUp(MartialInfoView.createInstance(), true)
	GameView.center(MartialInfoView.instance)
	MartialInfoView.instance:showIcon(item)
end

---
-- 显示神兵详细信息
-- @function [parent=#JianWenLuView] showShenBingInfo
-- @param self
-- @param #table item 
-- 
function JianWenLuView:_showShenBingInfo(item)
	local ShenBingInfoView = require("view.jianwenlu.ShenBingInfoView")
	local GameView = require("view.GameView")
	GameView.addPopUp(ShenBingInfoView.createInstance(), true)
	GameView.center(ShenBingInfoView.instance)
	ShenBingInfoView.instance:showIcon(item)
end

---
-- 取当前tab选中的索引
-- @function [parent=#JianWenLuView] getIndex
-- @param self
-- @return #number 
-- 
function JianWenLuView:getIndex()
	return self["tabRGrp"]:getSelectedIndex()
end

---
-- 退出界面调用
-- @function [parent=#JianWenLuView] onExit
-- @param self
-- 
function JianWenLuView:onExit()
	instance = nil
	JianWenLuView.super.onExit(self)
end














