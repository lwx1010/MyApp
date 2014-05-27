--- 
-- 装备 强化总界面
-- @module view.equip.EquipStrengthenView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccc3 = ccc3
local tr = tr
local display = display
local transition = transition
local math = math
local CCRepeatForever = CCRepeatForever
local CCFadeTo = CCFadeTo
local tolua = tolua
local ccp = ccp
local ui = ui
local CCSize = CCSize
local string = string

local moduleName = "view.equip.EquipStrengthenView"
module(moduleName)

--- 
-- 类定义
-- @type EquipStrengthenView
-- 
local EquipStrengthenView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#EquipStrengthenView] model.Item#Item _item
-- 
EquipStrengthenView._item = nil

---
--用于保存当前淬炼属性信息
--@field [parent=#EquipStrengthenView] #table _cuiLianInfo
--
EquipStrengthenView._cuiLianInfo = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#EquipStrengthenView] #boolean _canCtr
-- 
EquipStrengthenView._canCtr = nil

----- 
---- 分享按钮特效
---- @field [parent=#EquipStrengthenView] #CCSprite _shareSprite
---- 
--EquipStrengthenView._shareSprite = nil

--- 
-- 操作成功图标特效
-- @field [parent=#EquipStrengthenView] #CCSprite _overSprite
-- 
EquipStrengthenView._overSprite = nil

---
-- 是否是手动选择材料淬炼
-- @field [parent=#EquipStrengthenView] #boolean isHandCuiLian
-- 
EquipStrengthenView.isHandCuiLian = false

---
-- 手动淬炼特效
-- @field [parent=#EquipStrengthenView] #CCSprite _handSprite
-- 
EquipStrengthenView._handSprite = nil

---
-- 右边显示第几个
-- @field [parent=#EquipStrengthenView] #number _rightIndex
-- 
EquipStrengthenView._rightIndex = nil

---
-- 装备额外伤害描述
-- @field [parent=#EquipStrengthenView] #string _des
-- 
EquipStrengthenView._des = tr("(对%s类武学有额外伤害加成)")

---
-- 当前显示的装备编号
-- @field [parent=#EquipStrengthenView] #number _index
--
EquipStrengthenView._index = nil

---
-- 装备的最大编号
-- @field [parent=#EquipStrengthenView] #number _MAXINDEX
--
EquipStrengthenView._MAXINDEX = nil

--- 
-- 构造函数
-- @function [parent=#EquipStrengthenView] ctor
-- @param self
-- 
function EquipStrengthenView:ctor()
	EquipStrengthenView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipStrengthenView] _create
-- @param self
-- 
function EquipStrengthenView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_equipstrengthen1.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("infoCcb.shareBtn", self._shareClkHandler)
	self:handleButtonEvent("infoCcb.changeBtn", self._changeClkHandler)
	self:handleButtonEvent("infoCcb.unloadBtn", self._unloadClkHandler)
	
	self:createClkHelper()
	self:addClkUi("infoCcb.leftS9Spr")
	self:addClkUi("infoCcb.rightS9Spr")
	
	self:handleRadioGroupEvent("tab1RGrp", self._tabClkHandler)
	self["tab2RGrp"].menu:setEnabled(false)
	self["infoCcb.desLab"]:setVisible(false)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	local ScrollView = require("ui.ScrollView")
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	for i=1, 6 do
		self["infoCcb.cuiLianAttr"..i.."Lab"]:setVisible(false)
	end
	-- 创建描边文字
	self:_createText(1,118,201)
	self:_createText(2,118,160)
	self:_createText(3,118,119)
	self:_createText(4,288,201)
	self:_createText(5,288,160)
	self:_createText(6,288,119)
	
	local equipHCBox = self["infoCcb.equipHCBox"]
	local EquipStrengthenCell = require("view.equip.EquipStrengthenCell")
	equipHCBox:setCellRenderer(EquipStrengthenCell)
	
	--侦听拖动事件
	local CellBox = require("ui.CellBox")
	equipHCBox:addEventListener(CellBox.ITEM_SELECTED.name, self._itemChangedHandler, self)
end

---
-- 创建描边文字
-- @function [parent=#EquipStrengthenView] _createTxt
-- @param self
-- @param #number i
-- @param #number eX
-- @param #number eY
-- 
function EquipStrengthenView:_createText(i,eX,eY)
	self["cuiLianText"..i] = ui.newTTFLabelWithShadow(
					{
						size = 18,
						align = ui.TEXT_ALIGN_LEFT,
						dimensions = CCSize(145,22),
						x = eX,
						y = eY,
					}
				 )
	self["cuiLianText"..i]:setAnchorPoint(ccp(0,0.5))
	self:addChild(self["cuiLianText"..i])
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#EquipStrengthenView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function EquipStrengthenView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do 
		if k == "StrengGrade" then
			self._item["StrengGrade"] = v
			self._set:itemUpdated(self._item)
			
--			self["infoCcb.iconCcb.lvLab"]:setString("" .. (v or 0))
		end
	end
	
		--[[
		if k == "EquipPartnerId" then
			if v == 0 then 
				self["infoCcb.ownerNameLab"]:setString("")
				self:showBtn("infoCcb.changeBtn", false)
				self:showBtn("infoCcb.unloadBtn", false)
			else
				local PartnerData = require("model.PartnerData")
				local PartnerShowConst = require("view.const.PartnerShowConst")
				local partner = PartnerData.findPartner( self._item.EquipPartnerId )
				if partner then 
					self["infoCcb.ownerNameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step] .. partner.Name )
				else
					self["infoCcb.ownerNameLab"]:setString("")
				end
				
				self:showBtn("infoCcb.changeBtn", true)
				self:showBtn("infoCcb.unloadBtn", true)
			end
			if not self._canCtr then
				self:showBtn("infoCcb.changeBtn", false)
				self:showBtn("infoCcb.unloadBtn", false)
			end
		end
		
		if k == "StrengGrade" then
			self["infoCcb.iconCcb.lvLab"]:setString("" .. (v or 0))
		end
		
		if k == "Step" then
			local ItemViewConst = require("view.const.ItemViewConst")
			self["infoCcb.iconCcb.lvLab"]:setString("  " .. ItemViewConst.SHENBING_STEPS[(v or 0) + 1])
			self["infoCcb.equipNameLab"]:setString("<c5>" .. self._item.Name .. ItemViewConst.SHENBING_STEPS[(v or 0) + 1] .. tr("阶"))
		end
	end 
	--]]
end

---
-- 物品改变处理
-- @function [parent=#EquipStrengthenView] _itemChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function EquipStrengthenView:_itemChangedHandler(event)
	if(event==nil) then return end
--	printf("--------------------- "..event.index)
	if( self._index ) then
		self._index = event.index
		self._item = self._set:getItemAt(event.index)
		self:_showEquipInfo(self._item)
	end
end

--- 
-- 点击了关闭
-- @function [parent=#EquipStrengthenView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipStrengthenView:_closeClkHandler( sender, event )
	self:closeView(true)
end

---
-- 关闭界面
-- @function [parent=#EquipStrengthenView] closeView
-- @param self
-- @param #boolean isSend 是否发送协议
-- 
function EquipStrengthenView:closeView(isSend)
	-- 更新阵容界面属性信息
	if isSend and self._item.EquipPartnerId > 0 then
		local GameNet = require("utils.GameNet")
		local Uiid = require("model.Uiid")
		local pbObj = {}
		pbObj.id = self._item.EquipPartnerId
		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
		local partnerC2sTbl = {
		"Ap",         --攻击	
		"HpMax",      --血量
		"Dp",         --防御
		"Speed",      --行动速度
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
-- 关闭界面时候调用
-- @function [parent=#EquipStrengthenView] onExit
-- @param self
-- 
function EquipStrengthenView:onExit()
	-- 移除侦听事件
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	local ScrollView = require("ui.ScrollView")
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	box:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
--	if self._shareSprite then
--		transition.stopTarget(self._shareSprite)
--	end

	if self._handSprite then
		transition.stopTarget(self._handSprite)
		self._handSprite:setVisible(false)
	end
	
	if self._overSprite then
		transition.stopTarget(self._overSprite)
		self._overSprite:setVisible(false)
	end
	
	instance = nil
	EquipStrengthenView.super.onExit(self)
end

---
-- 点击了分享
-- @function [parent=#EquipStrengthenView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipStrengthenView:_shareClkHandler( sender, event )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 点击了更换
-- @function [parent=#EquipStrengthenView] _changeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipStrengthenView:_changeClkHandler( sender, event )
	if not self._item or self._item.EquipPartnerId == 0 then return end
	 
	local ItemData = require("model.ItemData")
	local items = ItemData.itemAllListTbl[self._item.FrameNo]:getArray()
	local FloatNotify = require("view.notify.FloatNotify")
	if #items == 0 then 
		FloatNotify.show(tr("没有符合要求的装备"))
		--提示没有符合要求的装备
		return
	end
	
	local PartnerData = require("model.PartnerData")
	local partner = PartnerData.findPartner(self._item.EquipPartnerId)
	
	if not partner then return end
	
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	local tbl = {}
	local table = require("table")
	for k, v in pairs(items) do
		if v and v.Id ~= self._item.Id and v.EquipPartnerId == 0 and v.SubKind == self._item.SubKind then  
			table.insert(tbl, v)
		end
	end
	
	if #tbl == 0 then 
		FloatNotify.show(tr("没有符合要求的装备"))
		--提示没有符合要求的装备
		return
	end
	
	function sortByStrengGrade(a, b)
		local aN = a.StrengGrade or 0
		local bN = b.StrengGrade or 0
		return aN < bN
	end
	
	table.sort( tbl, sortByStrengGrade )
	dataset:setArray( tbl )
	
	local tip = ""
	local func = function( Id, view )	
			if not view or not view._item or not Id then return end
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_item_equip_partner", {item_id = Id, target_id = view._item.EquipPartnerId, pos = view._item.EquipPos})
			
			-- 更换装备之后关闭界面
--			local GameView = require("view.GameView")
--			GameView.removePopUp(view)
			view:closeView()
		end
	
	local SelectEquipView = require("view.equip.SelectEquipView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectEquipView, true)
	SelectEquipView:showItem( dataset, func, self, 2, partner.Grade )
end

---
-- 点击了卸下
-- @function [parent=#EquipStrengthenView] _unloadClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipStrengthenView:_unloadClkHandler( sender, event )
	if self._item then 
		local GameNet = require("utils.GameNet")
		printf("EquipPartnerId:".. self._item.EquipPartnerId)
		GameNet.send("C2s_item_unequip_partner", {item_id = self._item.Id, target_id = self._item.EquipPartnerId})
		
		-- 卸下装备之后关闭界面
--		local GameView = require("view.GameView")
--		GameView.removePopUp(self)
		self:closeView()
	end
end

---
-- 显示装备信息
-- @function [parent=#EquipStrengthenView] showEquipInfo
-- @param self
-- @param #table list 装备道具列表
-- @param #number id 装备道具id
-- @param #boolean canCtr 是否可以操作（穿戴，更换，卸下）
-- 
function EquipStrengthenView:showEquipInfo(id, list, canCtr )
	local ItemData = require("model.ItemData")
	local item = ItemData.findItem( id )
	self._item = item
	self._canCtr = canCtr
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	self._set = set
	
	local equip
	if list then
		for i=1, #list do
			equip = ItemData.findItem( list[i].id )
			set:addItem(equip)
		end
	else
		set:addItem(item)
	end
	
	local equipHCBox =self["infoCcb.equipHCBox"]
	equipHCBox:setDataSet(set)
	equipHCBox:validate()
	local index = set:getItemIndex(self._item)
	self._index = index
	equipHCBox:scrollToIndex(index, true)
	self._MAXINDEX = set:getLength()
	
	if not self._canCtr then
		self:showBtn("infoCcb.changeBtn", false)
		self:showBtn("infoCcb.unloadBtn", false)
	end
	
	self:_showEquipInfo(self._item)
end

---
-- 显示装备其他信息
-- @function [parent=#EquipStrengthenView] _showEquipInfo
-- @param self
-- @param #table item 
-- 
function EquipStrengthenView:_showEquipInfo(item)
	local hbox = self["infoCcb.strengthenHBox"]
	hbox:removeAllItems()
	
	local ItemViewConst = require("view.const.ItemViewConst")
	if item.IsShenBing == 1 then 
		self:_setTabDetail(3)
		local EquipUpgradeView = require("view.equip.EquipUpgradeView")
		hbox:addItem(EquipUpgradeView.createInstance())
		EquipUpgradeView.instance:setItem( self._item )
		self:getItemUpgradeInfo( self._item.Id, self._item.Step, self._item.SubKind )
	else
		local EquipStrengView = require("view.equip.EquipStrengView")
		hbox:addItem(EquipStrengView.createInstance())
		self:getItemStrenghtInfo(item.Id, item.SubKind)
		
		hbox:setSnapWidth(EquipStrengView.instance:getContentSize().width)
		hbox:setSnapHeight(0)
		hbox:scrollToPos(0, 0)
		self._rightIndex = 1
		
		if item.CanXl == 1 then 
			self:_setTabDetail(2)
			local EquipCuiLianView = require("view.equip.EquipCuiLianView")
			hbox:addItem(EquipCuiLianView.createInstance())
			EquipCuiLianView.instance:setCuiLianItem(self._item)
			self:getItemCuiLianInfo( item.Id )
		else
			self:_setTabDetail(1)
			for i=1, 6 do
				self:_setText(i, "")
			end
		end
		
		local EquipStrengTransView = require("view.equip.EquipStrengTransView")
		hbox:addItem(EquipStrengTransView.createInstance())
		EquipStrengTransView.instance:setOrgItem(self._item)
		EquipStrengTransView.instance:setStrengTransInfo()
	end
	
	if self._index >= self._MAXINDEX then
		self["infoCcb.leftS9Spr"]:setVisible(false)
	else
		self["infoCcb.leftS9Spr"]:setVisible(true)
	end
	if self._index <= 1 then
		self["infoCcb.rightS9Spr"]:setVisible(false)
	else
		self["infoCcb.rightS9Spr"]:setVisible(true)
	end
end

---
-- 获取强化信息
-- @function [parent=#EquipStrengthenView] getItem
--
function EquipStrengthenView:getItemStrenghtInfo( id, subkind )
	local keys = {"StrengProp", "NextStrengProp", "MartialAdd", "StrengNeedCash", "StrengGrade"}
	local table = require("table")
	local ItemConst = require("model.const.ItemConst")
	if subkind == ItemConst.ITEM_SUBKIND_WEAPON then 
		table.insert(keys, "Ap")
		table.insert(keys, "ApRate")
		table.insert(keys, "WeaponType")
	elseif subkind == ItemConst.ITEM_SUBKIND_CLOTH then
		table.insert(keys, "Dp")
		table.insert(keys, "DpRate")
	else 
		table.insert(keys, "Hp")
		table.insert(keys, "HpRate")
	end
	
	local Uiid = require("model.Uiid")
	local pb = { id = id, key = keys, ui_id = Uiid.UIID_EQUIPSTRENGTHENVIEW, }
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_baseinfo", pb)
end

---
-- 获取装备淬炼属性
-- @function [parent=#EquipStrengthenView] getItemCuiLianInfo
-- @param self
-- @param #number id
-- 
function EquipStrengthenView:getItemCuiLianInfo( id )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xlprop", {id = id, type = 2})
	GameNet.send("C2s_item_xlprop", {id = id, type = 1})
end

---
-- 获取神兵基础属性和附加属性
-- @function [parent=#EquipStrengthenView] getItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- 
function EquipStrengthenView:getItemUpgradeInfo( id, step, subkind )
	local keys = {"MartialAdd"}
	local table = require("table")
	local ItemConst = require("model.const.ItemConst")
	if subkind == ItemConst.ITEM_SUBKIND_WEAPON then 
		table.insert(keys, "Ap")
		table.insert(keys, "ApRate")
	elseif subkind == ItemConst.ITEM_SUBKIND_CLOTH then
		table.insert(keys, "Dp")
		table.insert(keys, "DpRate")
	else 
		table.insert(keys, "Hp")
		table.insert(keys, "HpRate")
	end
	
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_item_baseinfo", {id = id, key = keys, ui_id = Uiid.UIID_EQUIPSTRENGTHENVIEW,})
	
	GameNet.send("C2s_item_stepprop", {id = id, step = step})
	
	if step < 5 then
		GameNet.send("C2s_item_stepprop", {id = id, step = step + 1,})
	end
end

---
-- 显示道具强化信息
-- @function [parent=#EquipStrengthenView] updateItemStrengInfo
-- @param self
-- @param #number id
-- @param #tabel arr
-- 
function EquipStrengthenView:updateItemStrengInfo( id, arr )
	if self._item == nil then return end
	if self._item.Id ~= id then return end
	if arr == nil then return end
	
	local item = {}
	for k, v in pairs( arr ) do
		if v.type == "number" then
			item[v.key] = v.value_int
		elseif v.type == "string" then 
			item[v.key] = v.value_str
		elseif v.type == "table" then
			item[v.key] = v.value_array
		end
	end
	
--	local ItemViewConst = require("view.const.ItemViewConst")
--	if item.MartialAdd and #item.MartialAdd > 0 then 
--		self["infoCcb.equipDescLab"]:setString(tr("对")..ItemViewConst.MARTIAL_ADD_TYPE[item.MartialAdd[1]]..tr("武学加成伤害")..item.MartialAdd[2]/100 .. "%")
--	else
--		self["infoCcb.equipDescLab"]:setString("")
--	end
	
	local ItemConst = require("model.const.ItemConst")
	local str = ""
	local strAdd = ""
	if self._item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then 
		if item.Ap and item.Ap > 0 then
			str = item.Ap
			if  item.StrengProp  then	
				strAdd = strAdd .. "+" .. item.StrengProp
			end
		elseif item.ApRate and item.ApRate > 0 then
			str = str .. item.ApRate /100 .."%"
			if  item.StrengProp  then
				strAdd = strAdd .. "+" .. item.StrengProp /100 .."%" 
			end
		end
		
		self["infoCcb.baseAttrLab"]:setString(tr("攻击  ") .. str)
		self["infoCcb.baseAttrAddLab"]:setString("<c2>" .. strAdd)
	elseif self._item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		if item.Dp and item.Dp > 0 then
			str = item.Dp
			if  item.StrengProp  then
				strAdd = strAdd .. "+<c2>" .. item.StrengProp
			end
		elseif item.DpRate and item.DpRate > 0 then
			str = str .. item.DpRate /100 .."%" 
			if  item.StrengProp  then
				strAdd = strAdd .. "+" .. item.StrengProp /100 .."%" 
			end
		end
		
		self["infoCcb.baseAttrLab"]:setString(tr("防御  ") .. str)
		self["infoCcb.baseAttrAddLab"]:setString("<c2>" ..strAdd)
	else 
		if item.Hp and item.Hp > 0 then
			str = item.Hp
			if  item.StrengProp  then
				strAdd = strAdd .. "+<c2>" .. item.StrengProp
			end
		elseif item.HpRate and item.HpRate > 0 then
			str = str .. item.HpRate /100 .."%" 
			if  item.StrengProp  then
				strAdd = strAdd .. "+" .. item.StrengProp /100 .."%" 
			end 
		end
		self["infoCcb.baseAttrLab"]:setString(tr("生命  ") .. str)
		self["infoCcb.baseAttrAddLab"]:setString("<c2>" ..strAdd)
	end
	
	if self._item.IsShenBing == 0 then
		local EquipStrengView = require("view.equip.EquipStrengView")
		if EquipStrengView.instance then
			EquipStrengView.instance:showEquipInfo( self._item, item)
		end
		self["infoCcb.baseAttrLab"]:setColor(ccc3(255, 255, 255))
	else
		local EquipUpgradeView = require("view.equip.EquipUpgradeView")
		if EquipUpgradeView.instance then
			EquipUpgradeView.instance:showBaseInfo( self._item, item )
		end
		self["infoCcb.baseAttrLab"]:setColor(ccc3(255, 0, 0))
	end
	
	if item.WeaponType then
		local des
		if item.WeaponType == 1 then
			des = "拳脚"
		elseif item.WeaponType == 2 then
			des = "枪棒"
		elseif item.WeaponType == 3 then
			des = "刀剑"
		end
		local str = string.format(self._des, des)
		self["infoCcb.desLab"]:setString(str)
		self["infoCcb.desLab"]:setVisible(true)
	end
end

---
-- 显示装备淬炼信息(1是刷出来的，2是当前的)
-- @function [parent=#EquipStrengthenView] updateItemCuiLianInfo
-- @param self
-- @param #number id
-- @param #number type
-- @param #tabel arr
-- 
function EquipStrengthenView:updateItemCuiLianInfo( id, type, arr )
	if not self._item or self._item.Id ~= id then return end 

	if type == 2 and #arr > 0 then
--		self["infoCcb.cuiLianAttr1Lab"]:setString("")
--		self["infoCcb.cuiLianAttr2Lab"]:setString("")
--		self["infoCcb.cuiLianAttr3Lab"]:setString("")
--		self["infoCcb.cuiLianAttr4Lab"]:setString("")
--		self["infoCcb.cuiLianAttr5Lab"]:setString("")
--		self["infoCcb.cuiLianAttr6Lab"]:setString("")
		for i=1, 6 do
			self:_setText(i, "")
		end
		
		self._cuiLianInfo = arr
		local labName = ""
		local xlProps = {"Ap", "Dp", "Hp", "Speed", "Double", "ReDouble", "HitRate", "Dodge"}
		local Prop = {}
		for k,v in pairs(arr) do
			Prop[arr[k].key] = arr[k].value
			Prop[arr[k].key.."Max"] = arr[k].maxvalue
		end
		local index = 1
		for k, v in pairs( xlProps ) do
			if Prop[v] then
--				labName = "infoCcb.cuiLianAttr" .. index .. "Lab"
				self:showCuiLianAttr(index, v, Prop[v], Prop[v.."Max"])
				index = index + 1
			end
		end
	end

	local func = function()
--			local EquipCuiLianView = require("view.equip.EquipCuiLianView")
--			EquipCuiLianView.createInstance():clearSelectInfo()
			if self._handCuiLian then
				self._handCuiLian:setVisible(false)
			end
			
			local EquipCuiLianSuccView = require("view.equip.EquipCuiLianSuccView")
			local GameView = require("view.GameView")
			GameView.addPopUp(EquipCuiLianSuccView.createInstance(), true)
			GameView.center(EquipCuiLianSuccView.instance)
			EquipCuiLianSuccView.instance:showEquipInfo(self._item, self._cuiLianInfo, arr)
		end

	if type == 1 and #arr > 0 and self._cuiLianInfo then 
		if self.isHandCuiLian then
			self.isHandCuiLian = false
			if not self._handSprite then
				display.addSpriteFramesWithFile("res/ui/effect/cuilian.plist", "res/ui/effect/cuilian.png")
				self._handSprite = display.newSprite()
				self:addChild(self._handSprite)
				self._handSprite:setPositionX(693)
				self._handSprite:setPositionY(368)
			end
			
			local frames = display.newFrames("cuilian/1000%d.png", 0, 4)
			local ImageUtil = require("utils.ImageUtil")
			local frame = ImageUtil.getFrame()
			frames[#frames + 1] = frame
			local animation = display.newAnimation(frames, 1/5)
			self._handSprite:setVisible(true)
			transition.playAnimationOnce(self._handSprite, animation, false, func)
		else
			func()
		end
	end
end

---
-- 显示装备淬炼属性
-- @function [parent=#EquipStrengthenView] showCuiLianAttr
-- @param self
-- @param #number idx
-- @param #string key
-- @param #number value
-- @param #number maxvalue
--
function EquipStrengthenView:showCuiLianAttr(idx, key, value, maxvalue)
	local lab = self["cuiLianText"..idx]
	if not lab then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local color
	local rate = value / maxvalue
	if rate >= 0 and rate <= 0.25 then 
--		color = "<c1>"
		color = ItemViewConst.EQUIP_OUTLINE_COLORS[1]
	elseif rate > 0.25 and rate <= 0.5 then 
--		color = "<c2>"
		color = ItemViewConst.EQUIP_OUTLINE_COLORS[2]
	elseif rate > 0.5 and rate <= 0.75 then 
--		color = "<c3>"
		color = ItemViewConst.EQUIP_OUTLINE_COLORS[3]
	else
--		color = "<c4>"
		color = ItemViewConst.EQUIP_OUTLINE_COLORS[4]
	end
	
	local str = ""
	if key == "Ap" or key == "Dp" or key == "Hp" or key == "Speed" then 
		str = ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +  " ..  value 
	else
		str = ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +  " ..  value/100 .. "%"
	end
	
	if rate == 1 then
		str = str .. tr("(满)")
	end
	
--	lab:setString(str)
	self:_setText(idx, str, color)
end

---
-- 显示神兵属性
-- @function [parent=#EquipStrengthenView] updateItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- @param #table info
-- @param #number cost
-- 
function EquipStrengthenView:updateItemUpgradeInfo( id, step, info, cost )
	if not self._item or not info then return end 
	if self._item.Id ~= id then return end
	
	if self._item.Step == step then
--		self["infoCcb.cuiLianAttr1Lab"]:setString("")
--		self["infoCcb.cuiLianAttr2Lab"]:setString("")
--		self["infoCcb.cuiLianAttr3Lab"]:setString("")
--		self["infoCcb.cuiLianAttr4Lab"]:setString("")
--		self["infoCcb.cuiLianAttr5Lab"]:setString("")
--		self["infoCcb.cuiLianAttr6Lab"]:setString("")
		for i=1, 6 do
			self:_setText(i, "")
		end
		
		local labName = ""
		local Prop = {}
		for k,v in pairs(info) do
			Prop[info[k].key] = info[k].value
		end
		local index = 1
		local ItemViewConst = require("view.const.ItemViewConst")
		local str		
		for k, v in pairs( ItemViewConst.SHENBING_ADD_KEY ) do
			if Prop[v] then
--				labName = "infoCcb.cuiLianAttr" .. index .. "Lab"
--				self[labName]:setString("<c5>" .. ItemViewConst.SHENBING_ADD_INFO[v] .. " + " .. Prop[v]/100 .. "%" )
				str = ItemViewConst.SHENBING_ADD_INFO[v] .. " + " .. Prop[v]/100 .. "%"
				self:_setText(index, str, ItemViewConst.EQUIP_OUTLINE_COLORS[5])
				index = index + 1
			end
		end
	end
	
	if (self._item.Step == ( step - 1 ) or self._item.Step == 5) and info then
		local EquipUpgradeView = require("view.equip.EquipUpgradeView")
		if EquipUpgradeView.instance then
			EquipUpgradeView.instance:showEquipInfo( self._item, step, info, cost )
		end
	end
end

---
-- 强化完成
-- @function [parent=#EquipStrengthenView] strengthenEnd
-- @param self
-- @param #number id 道具id
-- @param #number type 类型(1强化完成 2洗练完成 3洗练保留属性完成 4升阶完成)
-- 
function EquipStrengthenView:strengthenEnd( id, type )
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	if self._item == nil or self._item.Id ~= id then return end
	
	if (type == 1 or type == 3 or type == 4) and self:getParent() ~= nil then
		self:showOverTeXiao()
	end
	
	local GameNet = require("utils.GameNet")
	if type == 1 then
		--获取强化信息
		self:getItemStrenghtInfo( self._item.Id, self._item.SubKind )
		--获取转移信息
		local EquipStrengTransView = require("view.equip.EquipStrengTransView")
		if EquipStrengTransView.instance then
			EquipStrengTransView.instance:setStrengTransInfo()
		end
	elseif type == 2 then
		GameNet.send("C2s_item_xlprop", {id = self._item.Id, type = 1})
	elseif type == 3 then
		GameNet.send("C2s_item_xlprop", {id = self._item.Id, type = 2})
	elseif type == 4 then
		self:getItemUpgradeInfo( self._item.Id, self._item.Step, self._item.SubKind )
	elseif type == 5 then
		--获取强化信息
		self:getItemStrenghtInfo( self._item.Id, self._item.SubKind )
		--获取转移信息(转移完成之后，转移界面保留原来的数据)
--		local EquipStrengTransView = require("view.equip.EquipStrengTransView")
--		EquipStrengTransView.createInstance():setStrengTransInfo()
	end
end
--[[
---
-- 显示分享按钮特效
-- @function [parent=#EquipStrengthenView] showShareTeXiao
-- @param self
-- 
function EquipStrengthenView:showShareTeXiao()
	if not self._shareSprite then
		display.addSpriteFramesWithFile("res/ui/effect/vipandshare.plist", "res/ui/effect/vipandshare.png")
		self._shareSprite = display.newSprite()
		self:addChild(self._shareSprite)
		self._shareSprite:setPositionX(393)
		self._shareSprite:setPositionY(455)
	end
	
	local frames = display.newFrames("vipandshare/100%02d.png", 0, 12)
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(self._shareSprite, animation, 0.6)
end
--]]
---
-- 显示操作成功特效
-- @function [parent=#EquipStrengthenView] showOverTeXiao
-- @param self
-- 
function EquipStrengthenView:showOverTeXiao()
	if not self._overSprite then
		display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
		self._overSprite = display.newSprite()
		self:addChild(self._overSprite)
		self._overSprite:setPositionX(188)
		self._overSprite:setPositionY(461)
	end
	
	transition.stopTarget(self._overSprite)
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	local animation = display.newAnimation(frames, 1/6)
	self._overSprite:setVisible(true)
	transition.playAnimationOnce(self._overSprite, animation)
end

---
-- 显示tab细节
-- @function [parent=#EquipStrengthenView] _setTabDetail
-- @param self
-- @param #number 1强化，转移，2强化，淬炼，转移， 3，进阶 
function EquipStrengthenView:_setTabDetail( type )
	local start = 1
	local arr1 = self["tab1RGrp"].menu:getChildren()
	local arr2 = self["tab2RGrp"].menu:getChildren()
	local itemImage
	local itemToggle
	local ImageUtil = require("utils.ImageUtil")
	if type == 1 then
		start = 3
		
		local frame1 = ImageUtil.getFrame("ccb/buttontitle/strengthen.png")
		
		itemToggle = arr2:objectAtIndex(0)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
		
		local frame2 = ImageUtil.getFrame("ccb/buttontitle/qhzy.png")
		
		arr1:objectAtIndex(1):setVisible(true)
		itemToggle = arr2:objectAtIndex(1)
		itemToggle:setVisible(true)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame2)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame2)
	
	elseif type == 2 then
		start = 4
		
		local frame1 = ImageUtil.getFrame("ccb/buttontitle/strengthen.png")
		
		itemToggle = arr2:objectAtIndex(0)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
		
		local frame2 = ImageUtil.getFrame("ccb/buttontitle/refine.png")
		
		arr1:objectAtIndex(1):setVisible(true)
		itemToggle = arr2:objectAtIndex(1)
		itemToggle:setVisible(true)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame2)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame2)
		
		local frame3 = ImageUtil.getFrame("ccb/buttontitle/qhzy.png")
		
		arr1:objectAtIndex(2):setVisible(true)
		itemToggle = arr2:objectAtIndex(2)
		itemToggle:setVisible(true)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame3)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame3)
	
	elseif type == 3 then
		start = 2
		
		local frame1 = ImageUtil.getFrame("ccb/buttontitle/sbjj.png")
		
		itemToggle = arr2:objectAtIndex(0)
		itemToggle = tolua.cast(itemToggle, "CCMenuItemToggle")
		local arr = itemToggle:getSubItems()
		itemImage = tolua.cast(arr:objectAtIndex(0), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
		itemImage = tolua.cast(arr:objectAtIndex(1), "CCMenuItemImage")
		itemImage:setNormalSpriteFrame(frame1)
	end
	
	for i = start, 4 do
		arr1:objectAtIndex(i-1):setVisible(false)
		arr2:objectAtIndex(i-1):setVisible(false)
	end 
end

--- 
-- 点击了tab
-- @function [parent=#EquipStrengthenView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function EquipStrengthenView:_tabClkHandler( event )
	self._selectedIndex = self["tab1RGrp"]:getSelectedIndex()
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	if(self._selectedIndex <= 1) then
		box:scrollToIndex(1)
	else
		box:scrollToIndex(self._selectedIndex )
	end
end

---
-- 拖动
-- @function [parent=#EquipStrengthenView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function EquipStrengthenView:_scrollChangedHandler( event )
	if event == nil then return end
	
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	local width = box:getSnapWidth()
	local arr = box:getItemArr()
	local len = 0
	if arr then
		len = #arr
	end
	
	local index = 0
	if width > 0 then
		index = math.floor(( 0 - event.curX )/width) + 1
	end
	if index == 0 then index = 1 end
	self._rightIndex = index
	
	self["tab1RGrp"]:setSelectedIndex(self._rightIndex, false)
end

---
-- 设置描边文字
-- @function [parent=#EquipStrengthenView] _setText
-- @param self
-- @param #number i 
-- @param #string str 
-- @param #ccColor3B color
-- 
function EquipStrengthenView:_setText(i,str,color)
	self["cuiLianText"..i]:setString(tr(str))
	if color then
		self["cuiLianText"..i]:setColor(color)
	end
end

---
-- ui点击处理
-- @function [parent=#EquipStrengthenView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function EquipStrengthenView:uiClkHandler( ui, rect )
	if ui == self["infoCcb.leftS9Spr"] then
		if self._index >= self._MAXINDEX then return end
		
		self._index = self._index + 1
		self["infoCcb.equipHCBox"]:scrollToIndex(self._index, true)
		self._item = self._set:getItemAt(self._index)
		self:_showEquipInfo(self._item)
		
	elseif ui == self["infoCcb.rightS9Spr"] then
		if self._index <= 1 then return end
		
		self._index = self._index - 1
		self["infoCcb.equipHCBox"]:scrollToIndex(self._index, true)
		self._item = self._set:getItemAt(self._index)
		self:_showEquipInfo(self._item)
	end
end
