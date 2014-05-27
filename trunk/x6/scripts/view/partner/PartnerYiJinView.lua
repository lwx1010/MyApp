---
-- 同伴易筋界面
-- @module view.partner.PartnerYiJinView
-- 

local class = class
local require = require
local printf = printf
local tostring = tostring
local math = math
local tr = tr
local pairs = pairs
local transition = transition
local display = display

local moduleName = "view.partner.PartnerYiJinView"
module(moduleName)

---
-- 类定义
-- @type PartnerYiJinView
-- 
local PartnerYiJinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前显示的同伴
-- @field [parent=#PartnerYiJinView] #Partner _partner 
-- 
PartnerYiJinView._partner = nil

---
-- 从阵容界面点进来的同伴,用于更新阵容界面的属性信息
-- @field [parent=#PartnerYiJinView] #Partner _initialPartner 
-- 
PartnerYiJinView._initialPartner = nil

---
-- 开启的筋脉数
-- @field [parent=#PartnerYiJinView] #number _openNum 
-- 
PartnerYiJinView._openNum = nil

---
-- 当前显示的筋脉界面(1-任督二脉  2-三花聚顶  3-五气朝元)
-- @field [parent=#PartnerYiJinView] #number _index 
-- 
PartnerYiJinView._index = nil

---
-- 当前显示的同伴索引
-- @field [parent=#PartnerYiJinView] #number _partnerIndex 
-- 
PartnerYiJinView._partnerIndex = nil

---
-- 出战同伴id列表
-- @field [parent=#PartnerYiJinView] #table _partnerIdTbl 
-- 
PartnerYiJinView._partnerIdTbl = nil

---
-- 构造函数
-- @function [parent=#PartnerYiJinView] ctor
-- @param self
-- 
function PartnerYiJinView:ctor()
	PartnerYiJinView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerYiJinView] _create
-- @param self
-- 
function PartnerYiJinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridian.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("leftBtn", self._leftClkHandler)
	self:handleButtonEvent("rightBtn", self._rightClkHandler)
	local hBox = self["jmHBox"]
	self["jmNameLab"]:setString(tr("任督二脉"))
	
	local partnerHCBox = self["partnerHCBox"]
	local YiJinPartnerCell = require("view.partner.sub.YiJinPartnerCell")
	partnerHCBox:setCellRenderer(YiJinPartnerCell)
	
	--侦听拖动事件
	local ScrollView = require("ui.ScrollView")
	hBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	local CellBox = require("ui.CellBox")
	partnerHCBox:addEventListener(CellBox.ITEM_SELECTED.name, self._partnerChangedHandler, self)
	self._partnerIdTbl = {}
end

---
-- 点击了关闭
-- @function [parent=#PartnerYiJinView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event
-- 
function PartnerYiJinView:_closeClkHandler(sender,event)
	-- 更新阵容界面侠客属性
	if( self._initialPartner ) then
		local GameNet = require("utils.GameNet")
		local Uiid = require("model.Uiid")
		local pbObj = {}
		pbObj.id = self._initialPartner.Id
		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
		local partnerC2sTbl = {
		"Ap",         --攻击	
		"HpMax",         --血量
		"Dp",         --防御
		"Speed",      --行动速度
		"Score",      --战斗力
		}
		pbObj.key = partnerC2sTbl
		GameNet.send("C2s_partner_baseinfo", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了左键头
-- @function [parent=#PartnerYiJinView] _leftClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function PartnerYiJinView:_leftClkHandler(sender,event)
	if(self._index == 2 or self._index == 3) then
		self._index = self._index - 1
		self["jmHBox"]:scrollToIndex(self._index, true)
		if(self._index == 1) then
			self["jmNameLab"]:setString(tr("任督二脉"))
			self["leftBtn"]:setVisible(false)
			self["rightBtn"]:setVisible(true)
		elseif(self._index == 2) then
			self["jmNameLab"]:setString(tr("三花聚顶"))
			--开启了两个经脉
			if(self._openNum == 2) then
				self["leftBtn"]:setVisible(true)
				self["rightBtn"]:setVisible(false)
			--开启了三个经脉
			elseif(self._openNum == 3) then
				self["leftBtn"]:setVisible(true)
				self["rightBtn"]:setVisible(true)
			end
		end
	end
end

---
-- 点击了右键头
-- @function [parent=#PartnerYiJinView] _rightClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function PartnerYiJinView:_rightClkHandler(sender,event)
	if(self._index == 1) then
		self._index = self._index + 1
		self["jmHBox"]:scrollToIndex(self._index, true)
		self["jmNameLab"]:setString(tr("三花聚顶"))
	elseif(self._index == 2) then
		self._index = self._index + 1
		self["jmHBox"]:scrollToIndex(self._index, true)
		self["jmNameLab"]:setString(tr("五气朝元"))
	end
	
	if(self._index == 2) then
		if(self._openNum == 2) then
			self["leftBtn"]:setVisible(true)
			self["rightBtn"]:setVisible(false)
		elseif(self._openNum == 3) then
			self["leftBtn"]:setVisible(true)
			self["rightBtn"]:setVisible(true)
		end
	elseif(self._index == 3) then
		self["leftBtn"]:setVisible(true)
		self["rightBtn"]:setVisible(false)
	end
end

---
-- 显示同伴信息
-- @function [parent=#PartnerYiJinView] showPartner
-- @param self
-- @param #Partner partner 当前同伴
-- 
function PartnerYiJinView:showPartner(partner)
	self._partner = partner
	self._initialPartner = partner
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	self._partnerIdTbl = {}
	
	local PartnerData = require("model.PartnerData")
	local warPartnerSet = PartnerData.warPartnerSet
	local warPartnerArr = warPartnerSet:getArray()
	local warPartner
	for i=1, #warPartnerArr do
		warPartner = warPartnerArr[i]
		if( warPartner ) then
			set:addItem(warPartner)
			self._partnerIdTbl[i] = warPartner.Id -- 保存出战同伴运行id
		end
	end
	
	self["partnerHCBox"]:setDataSet(set)
	self["partnerHCBox"]:validate()
	local index = set:getItemIndex(partner)
	self._partnerIndex = index
	self["partnerHCBox"]:scrollToIndex(index, true)
end

---
-- 显示同伴易筋信息
-- @function [parent=#PartnerYiJinView] showYiJinInfo
-- @param self
-- @param #table info 同伴易筋信息
-- 
function PartnerYiJinView:showYiJinInfo(info)
	local zhenQiArr  --真气数组
	local data  --真气信息
	local find = false
	local RenDuUi = require("view.partner.sub.RenDuUi")
	local SanHuaUi = require("view.partner.sub.SanHuaUi")
	local WuQiUi = require("view.partner.sub.WuQiUi")
	local hBox = self["jmHBox"]
	hBox:removeAllItems()  --移除所有子项
	
	if(info.open_zhenqi==0) then
		self["openLab1"]:setString( tr("<c0>任督二脉未开启(0星40级)") )
		self["openLab2"]:setString( tr("<c0>三花聚顶未开启(3星50级)") )
		self["openLab3"]:setString( tr("<c0>五气朝元未开启(5星70级)") )
		self["leftBtn"]:setVisible(false)
		self["rightBtn"]:setVisible(false)
		self._openNum = 0
		
		hBox:addItem( RenDuUi.createInstance() )
		for i=1, 2 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				RenDuUi.instance:showZhenQi(false, data, i, self._partner)
				find = false
			else
				RenDuUi.instance:showZhenQi(false, nil, i, self._partner)
			end
		end
		
	elseif(info.open_zhenqi==1) then
		self["openLab1"]:setString( tr("<c4>任督二脉已开启(0星40级)") )
		self["openLab2"]:setString( tr("<c0>三花聚顶未开启(3星50级)") )
		self["openLab3"]:setString( tr("<c0>五气朝元未开启(5星70级)") )
		self["leftBtn"]:setVisible(false)
		self["rightBtn"]:setVisible(false)
		self._openNum = 1
		
		hBox:addItem( RenDuUi.createInstance() )
		for i=1, 2 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				RenDuUi.instance:showZhenQi(true, data, i, self._partner)
				find = false
			else
				RenDuUi.instance:showZhenQi(true, nil, i, self._partner)
			end
		end
		
	elseif(info.open_zhenqi==2) then
		self["openLab1"]:setString( tr("<c4>任督二脉已开启(0星40级)") )
		self["openLab2"]:setString( tr("<c4>三花聚顶已开启(3星50级)") )
		self["openLab3"]:setString( tr("<c0>五气朝元未开启(5星70级)") )
		self["leftBtn"]:setVisible(false)
		self["rightBtn"]:setVisible(true)
		self._openNum = 2
		
		hBox:addItem( RenDuUi.createInstance() )
		for i=1, 2 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				RenDuUi.instance:showZhenQi(true, data, i, self._partner)
				find = false
			else
				RenDuUi.instance:showZhenQi(true, nil, i, self._partner)
			end
		end
		
		hBox:addItem( SanHuaUi.createInstance() )
		for i=3, 5 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				SanHuaUi.instance:showZhenQi(data, i, self._partner)
				find = false
			else
				SanHuaUi.instance:showZhenQi(nil, i, self._partner)
			end
		end
		
		hBox:setSnapWidth(RenDuUi.instance:getContentSize().width)
		hBox:setSnapHeight(0)
		
	elseif(info.open_zhenqi==3) then
		self["openLab1"]:setString( tr("<c4>任督二脉已开启(0星40级)") )
		self["openLab2"]:setString( tr("<c4>三花聚顶已开启(3星50级)") )
		self["openLab3"]:setString( tr("<c4>五气朝元已开启(5星70级)") )
		self["leftBtn"]:setVisible(false)
		self["rightBtn"]:setVisible(true)
		self._openNum = 3
		
		hBox:addItem( RenDuUi.createInstance() )
		for i=1, 2 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				RenDuUi.instance:showZhenQi(true, data, i, self._partner)
				find = false
			else
				RenDuUi.instance:showZhenQi(true, nil, i, self._partner)
			end
		end
		
		hBox:addItem( SanHuaUi.createInstance() )
		for i=3, 5 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				SanHuaUi.instance:showZhenQi(data, i, self._partner)
				find = false
			else
				SanHuaUi.instance:showZhenQi(nil, i, self._partner)
			end
		end
		
		hBox:addItem( WuQiUi.createInstance() )
		for i=6, 10 do
			zhenQiArr = info.zhenqi_info
			for j=1, #zhenQiArr do
				--判断真气数组中是否存在装备在i位置的真气
				if(i==zhenQiArr[j].EquipPos) then
					data = zhenQiArr[j]
					find = true  --在真气数组中找到了装备在i位置的真气
					break
				end
				find = false  --在真气数组中没有找到装备在i位置的真气
			end
			
			if(find) then
				WuQiUi.instance:showZhenQi(data, i, self._partner)
				find = false
			else
				WuQiUi.instance:showZhenQi(nil, i, self._partner)
			end
		end
		
		hBox:setSnapWidth(RenDuUi.instance:getContentSize().width)
		hBox:setSnapHeight(0)
	end
end

---
-- 拖动处理
-- @function [parent=#PartnerYiJinView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function PartnerYiJinView:_scrollChangedHandler(event)
	if(event==nil) then return end
	
	local hBox = self["jmHBox"]
	local width = hBox:getSnapWidth()
	local index = math.floor( (0-event.curX)/width ) + 1
	if(index==1) then
		self["jmNameLab"]:setString(tr("任督二脉"))
		self._index = 1
		if(self._openNum == 1 or self._openNum == 0) then
			self["leftBtn"]:setVisible(false)
			self["rightBtn"]:setVisible(false)
		elseif(self._openNum == 2 or self._openNum == 3) then
			self["leftBtn"]:setVisible(false)
			self["rightBtn"]:setVisible(true)
		end
		
	elseif(index==2) then
		self["jmNameLab"]:setString(tr("三花聚顶"))
		self._index = 2
		if(self._openNum == 2) then
			self["leftBtn"]:setVisible(true)
			self["rightBtn"]:setVisible(false)
		elseif(self._openNum == 3) then
			self["leftBtn"]:setVisible(true)
			self["rightBtn"]:setVisible(true)
		end
		
	elseif(index==3) then
		self["jmNameLab"]:setString(tr("五气朝元"))
		self._index = 3
		self["leftBtn"]:setVisible(true)
		self["rightBtn"]:setVisible(false)
	end
end

---
-- 退出时释放资源
-- @function [parent=#PartnerYiJinView] onExit
-- @param self
-- 
function PartnerYiJinView:onExit()
	local ZhenQiData = require("model.ZhenQiData")
	-- 清除动画
	for k, v in pairs(ZhenQiData.stopActionList) do
		if( v.action ) then
			v:stopAllActions()
			transition:removeAction(v.action)
			v.action = nil
		end
	end
	-- 释放不需要的资源
	for k, v in pairs(ZhenQiData.removeFileList) do
		display.removeSpriteFramesWithFile(v)
	end
	
	ZhenQiData.stopActionList = {}
	ZhenQiData.removeFileList = {}
	-- 移除侦听事件
	local ScrollView = require("ui.ScrollView")
	self["jmHBox"]:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	local CellBox = require("ui.CellBox")
	self["partnerHCBox"]:addEventListener(CellBox.ITEM_SELECTED.name, self._partnerChangedHandler, self)
	
	instance = nil
	PartnerYiJinView.super.onExit(self)
end

---
-- 同伴改变处理
-- @function [parent=#PartnerYiJinView] _partnerChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function PartnerYiJinView:_partnerChangedHandler(event)
	if(event==nil) then return end
	
	local partnerArr = self["partnerHCBox"]:getItemArr()
--	if( self._partnerIndex and math.abs(self._partnerIndex - event.index) == 1 ) then
	if( self._partnerIndex ) then
		self._partnerIndex = event.index
		
		local PartnerData = require("model.PartnerData")
		local warPartnerSet = PartnerData.warPartnerSet
		self._partner = warPartnerSet:getItemAt(event.index)
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_zhenqi_partner_info", {partner_id=self._partnerIdTbl[event.index]})
		-- 加载等待动画
--		local NetLoading = require("view.notify.NetLoading")
--		NetLoading.show()
	end
end

