---
-- 九转通玄系统主界面
-- @module view.jiuzhuan.JiuZhuanMainView
-- 

local class = class
local require = require
local printf = printf
local table = table


local moduleName = "view.jiuzhuan.JiuZhuanMainView"
module(moduleName)


---
-- 类定义
-- @type JiuZhuanMainView
-- 
local JiuZhuanMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#JiuZhuanMainView] ctor
-- @param self
-- 
function JiuZhuanMainView:ctor()
	JiuZhuanMainView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#JiuZhuanMainView] _create
-- @param self
-- 
function JiuZhuanMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jiuzhuan/ui_jiuzhuan.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	self["itemHBox"].owner = self
	
	local HeroAttr = require("model.HeroAttr")
	if( HeroAttr.Id ) then
		self:_showHeroAttr(HeroAttr)
	else
		self:_showHeroAttr(nil)
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

--- 
-- 点击了关闭
-- @function [parent=#JiuZhuanMainView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JiuZhuanMainView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
--	local MainView = require("view.main.MainView")
--    GameView.replaceMainView(MainView.createInstance(), true)
	GameView.removePopUp(self, true)
end

--- 
-- 点击了tab
-- @function [parent=#JiuZhuanMainView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function JiuZhuanMainView:_tabClkHandler( event )
	self["itemHBox"]:removeAllItems()
	
	self._selectedIndex = self["tabRGrp"]:getSelectedIndex()
	if(self._selectedIndex==1) then
		local JiuZhuanView = require("view.jiuzhuan.JiuZhuanView")
		if( JiuZhuanView.instance ) then
			self["itemHBox"]:addItem(JiuZhuanView.instance)
		else
			self["itemHBox"]:addItem(JiuZhuanView.createInstance())
		end
		JiuZhuanView.instance:openUi()
	elseif(self._selectedIndex==2) then
		local ZhenQiUpgradeView = require("view.jiuzhuan.ZhenQiUpgradeView")
		if( ZhenQiUpgradeView.instance ) then
			self["itemHBox"]:addItem(ZhenQiUpgradeView.instance)
		else
			self["itemHBox"]:addItem(ZhenQiUpgradeView.createInstance())
		end
		ZhenQiUpgradeView.instance:showAllZhenQi()
	end
end

---
-- 角色属性更新
-- @function [parent=#JiuZhuanMainView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function JiuZhuanMainView:_attrsUpdatedHandler( event )
	self:_showHeroAttr(event.attrs)
end

---
-- 显示角色属性
-- @function [parent=#JiuZhuanMainView] _showHeroAttr
-- @param self
-- @param model#HeroAttr attrTbl key-value的属性对,nil表示显示默认值
-- 
function JiuZhuanMainView:_showHeroAttr( attrTbl )
	-- 没有值
	if( not attrTbl ) then
		self["yuanBaoLab"]:setString("")
		self["cashLab"]:setString("")
		return
	end
	
	local NumberUtil = require("utils.NumberUtil")
	if( attrTbl.YuanBao ) then
		self["yuanBaoLab"]:setString(attrTbl.YuanBao)
		self._yuanBao = attrTbl.YuanBao
	end
	
	if( attrTbl.Cash ) then
		self["cashLab"]:setString(NumberUtil.numberForShort(attrTbl.Cash))
		self._cash = attrTbl.Cash
	end
end
	
---
-- 显示界面信息
-- @function [parent=#JiuZhuanMainView] showInfo
-- @param self
-- 
function JiuZhuanMainView:showInfo()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	local JiuZhuanView = require("view.jiuzhuan.JiuZhuanView")
	if( JiuZhuanView.instance ) then
		self["itemHBox"]:addItem(JiuZhuanView.instance)
	else
		self["itemHBox"]:addItem(JiuZhuanView.createInstance())
	end
	JiuZhuanView.instance:openUi()
	
	-- 第一次打开九转通玄界面时请求真气列表
	local ZhenQiData = require("model.ZhenQiData")
	if( not ZhenQiData.receiveZhenQiList ) then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_zhenqi_list", {place_holder=1})
	end
end

---
-- 设置菜单索引
-- @function [parent=#JiuZhuanMainView] setSelectedIndex
-- @param self
-- @param #number index	
-- 
function JiuZhuanMainView:setSelectedIndex(index)
	self["tabRGrp"]:setSelectedIndex(index)
end

---
-- 退出界面调用
-- @function [parent=#ConfirmView] onExit
-- @param self
-- 
function JiuZhuanMainView:onExit()
	self["itemHBox"]:removeAllItems()
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	JiuZhuanMainView.super.onExit(self)
end
