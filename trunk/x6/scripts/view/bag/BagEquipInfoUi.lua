--- 
-- 装备信息界面
-- @module view.bag.BagEquipInfoUi
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local math = math
local string = string
local dump = dump

local moduleName = "view.bag.BagEquipInfoUi"
module(moduleName)

--- 
-- 类定义
-- @type BagEquipInfoUi
-- 
local BagEquipInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 装备道具
-- @field [parent=#BagEquipInfoUi] model.Item#Item _item
-- 
BagEquipInfoUi._item = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#BagEquipInfoUi] #boolean _canCtr
-- 
BagEquipInfoUi._canCtr = nil

--- 
-- 构造函数
-- @function [parent=#BagEquipInfoUi] ctor
-- @param self
-- 
function BagEquipInfoUi:ctor()
	BagEquipInfoUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagEquipInfoUi] _create
-- @param self
-- 
function BagEquipInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_equipinfobox.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("strengCcb.aBtn", self._strengClkHandler)
	self:handleButtonEvent("sellCcb.aBtn", self._sellClkHandler)
	self:handleButtonEvent("resolveCcb.aBtn", self._resolveClkHandler)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化
-- @function [parent=#BagEquipInfoUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagEquipInfoUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	local attrs = event.attrs
	local ItemViewConst = require("view.const.ItemViewConst")
	if attrs.StrengGrade then
		self["lvLab"]:setString("" .. (attrs.StrengGrade or 0) )
	end
	
	if attrs.Step then
		self["lvLab"]:setString("" .. ItemViewConst.SHENBING_STEPS[(attrs.Step or 0) + 1])
	end
	
	if attrs.Info then
		self["descLab"]:setString(attrs.Info or "")
	end
end

---
-- 点击了强化
-- @function [parent=#BagEquipInfoUi] _strengClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagEquipInfoUi:_strengClkHandler( sender, event )
	local GameView = require("view.GameView")
	local EquipStrengthenView = require("view.equip.EquipStrengthenView")
	GameView.addPopUp(EquipStrengthenView.createInstance(), true)
	EquipStrengthenView.instance:showEquipInfo(self._item.Id)
	
	GameView.removePopUp(self, true)
end

---
-- 点击了出售
-- @function [parent=#BagEquipInfoUi] _sellClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagEquipInfoUi:_sellClkHandler( sender, event )
	printf("clk sell")
	if not self._item then return end
	
	if self._item.EquipPartnerId > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("正在使用的装备不能出售！！！"))
		return
	end
	
	local func = function()
			if self._item then
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_item_sell", {item_id = self._item.Id})
				local GameView = require("view.GameView")
				GameView.removePopUp(self, true)
			end
		end
	
	local tip = string.format(tr("是否确定出后%s可获得银两%s？"), self._item.Name, self._item.ShowPrice)
	local BagItemSellTipUi = require("view.bag.BagItemSellTipUi")
	BagItemSellTipUi.new():openUi(func, tip)
end

---
-- 点击了分解
-- @function [parent=#BagEquipInfoUi] _resolveClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagEquipInfoUi:_resolveClkHandler( sender, event )
--	local FloatNotify = require("view.notify.FloatNotify")
--	FloatNotify.show(tr("该功能尚未开放!"))
	
	if not self._item then return end
	
	if self._item.EquipPartnerId > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("正在使用的装备不能分解！！！"))
		return
	end
	
	if self._item.IsShenBing > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("神兵无法分解！！！"))
		return
	end
	
	local func = function()
			if self._item then
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_item_fenjie", {equip_id = self._item.Id})
				local GameView = require("view.GameView")
				GameView.removePopUp(self, true)
			end
		end
	
	local colors = {tr("绿色"),tr("蓝色"),tr("紫色"),tr("橙色")}
	local str = colors[self._item.Rare]
	local ItemViewConst = require("view.const.ItemViewConst")
	local name = ItemViewConst.EQUIP_STEP_COLORS[self._item.Rare] .. self._item.Name
	local tip = string.format(tr("是否确定将%s品质的%s<c0>分解为矿石？"), str, name)
	local title = tr("装备分解")
	local BagItemSellTipUi = require("view.bag.BagItemSellTipUi")
	BagItemSellTipUi.new():openUi(func, tip, title)
end

--- 
-- 点击了关闭
-- @function [parent=#BagEquipInfoUi] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagEquipInfoUi:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BagEquipInfoUi] openUi
-- @param self
-- @param model.Item#Item item
-- @param #boolean canCtr
-- 
function BagEquipInfoUi:openUi( item, canCtr )
	if not item then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self:showItemInfo(item)
	
	if canCtr == nil or canCtr == true then 
		self._canCtr = true
	else
		self._canCtr = false 
	end
	
	self["strengCcb"]:setVisible(self._canCtr)
	self["sellCcb"]:setVisible(self._canCtr)
	self["resolveCcb"]:setVisible(self._canCtr)
	self["strengCcbSpr"]:setVisible(self._canCtr)
	self["sellCcbSpr"]:setVisible(self._canCtr)
	self["resolveCcbSpr"]:setVisible(self._canCtr)
end

---
-- 显示装备信息
-- @function [parent=#BagEquipInfoUi] showMartialInfo
-- @param self
-- @param model.Item#Item martial
-- @param #boolean canCtr 
-- 
function BagEquipInfoUi:showItemInfo( item )
	self._item = item
	
	if not self._item then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name)
	self:changeFrame("rareSpr", ItemViewConst.EQUIP_RARE_ICON[item.Rare])
	if item.IsShenBing and item.IsShenBing == 1 then
		self["lvTipLab"]:setString(tr("神兵阶位："))
		self["lvLab"]:setString("" .. ItemViewConst.SHENBING_STEPS[(item.Step or 0) + 1])
		
		self["otherLab"]:setVisible(true)
		-- 获取神兵信息
		self:getItemUpgradeInfo(item.Id, item.Step, item.SubKind)
	else
		self["lvTipLab"]:setString(tr("强化等级："))
		self["lvLab"]:setString("" .. (item.StrengGrade or 0))
		
		if item.CanXl == 1 then
			self["otherLab"]:setVisible(true)
			-- 获取淬炼信息
			self:getItemCuiLianInfo(self._item.Id)
		else
			self["otherLab"]:setVisible(false)
			self["attrLab"]:setString("")
		end
	end
	
	self["needGradeLab"]:setString("" .. item.NeedGrade )
	
	self["addLab"]:setString("")
	
	local ItemConst = require("model.const.ItemConst")
	if item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then
		if item.SumAp and item.SumAp > 0 then
			self["baseLab"]:setString("攻击 <c1>+" .. item.SumAp)
		elseif item.SumApRate and item.SumApRate > 0 then
			self["baseLab"]:setString("攻击 <c1>+" .. math.floor(item.SumApRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		if item.SumDp and item.SumDp > 0 then
			self["baseLab"]:setString("防御 <c1>+" .. item.SumDp)
		elseif item.SumDpRate and item.SumDpRate > 0 then
			self["baseLab"]:setString("防御 <c1>+" .. math.floor(item.SumDpRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
		if item.SumHp and item.SumHp > 0 then
			self["baseLab"]:setString("生命 <c1>+" .. item.SumHp)
		elseif item.SumHpRate and item.SumHpRate > 0 then
			self["baseLab"]:setString("生命 <c1>+" .. math.floor(item.SumHpRate/100) .. "%")
		end
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_baseinfo", {id = item.Id, key = {"Info"}})
	
	self:getItemStrenghtInfo(item.Id, item.SubKind)
end

---
-- 获取强化信息
-- @function [parent=#BagEquipInfoUi] getItemStrenghtInfo
--
function BagEquipInfoUi:getItemStrenghtInfo( id, subkind )
	local keys = {"StrengProp"}
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
	
	local Uiid = require("model.Uiid")
	local pb = { id = id, key = keys, ui_id = Uiid.UIID_BAGEQUIPINFOUI, }
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_baseinfo", pb)
end

---
-- 获取神兵基础属性和附加属性
-- @function [parent=#BagEquipInfoUi] getItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- 
function BagEquipInfoUi:getItemUpgradeInfo( id, step, subkind )
	local keys = {}
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
	GameNet.send("C2s_item_baseinfo", {id = id, key = keys})
	
	GameNet.send("C2s_item_stepprop", {id = id, step = step})
end

---
-- 获取装备淬炼属性
-- @function [parent=#BagEquipInfoUi] getItemCuiLianInfo
-- @param self
-- @param #number id
-- 
function BagEquipInfoUi:getItemCuiLianInfo( id )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xlprop", {id = id, type = 2})
end

---
-- 显示道具强化信息
-- @function [parent=#BagEquipInfoUi] updateItemStrengInfo
-- @param self
-- @param #number id
-- @param #tabel arr
-- 
function BagEquipInfoUi:updateItemStrengInfo( id, arr )
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
		
		self["baseLab"]:setString(tr("攻击  ") .. str)
		self["addLab"]:setString("<c2>" .. strAdd)
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
		
		self["baseLab"]:setString(tr("防御  ") .. str)
		self["addLab"]:setString("<c2>" ..strAdd)
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
		self["baseLab"]:setString(tr("生命  ") .. str)
		self["addLab"]:setString("<c2>" ..strAdd)
	end
end

---
-- 显示神兵属性
-- @function [parent=#BagEquipInfoUi] updateItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- @param #table info
-- 
function BagEquipInfoUi:updateItemUpgradeInfo( id, step, info )
	if not self._item or not info then return end 
	if self._item.Id ~= id then return end
	
	if self._item.Step == step then
		self["attrLab"]:setString("")
		local labName = ""
		local Prop = {}
		for k,v in pairs(info) do
			Prop[info[k].key] = info[k].value
		end
		local ItemViewConst = require("view.const.ItemViewConst")		
		local str = ""
		for k, v in pairs( ItemViewConst.SHENBING_ADD_KEY ) do
			if Prop[v] then
				str = str .. "<c5>" .. ItemViewConst.SHENBING_ADD_INFO[v] .. "+" .. Prop[v]/100 .. "%  " 
			end
		end
		
		self["attrLab"]:setString(str)
	end
end


---
-- 显示装备淬炼信息(2是当前的)
-- @function [parent=#BagEquipInfoUi] updateItemCuiLianInfo
-- @param self
-- @param #number id
-- @param #number type
-- @param #tabel arr
-- 
function BagEquipInfoUi:updateItemCuiLianInfo( id, type, arr )
	if not self._item or self._item.Id ~= id then return end 

	if type == 2 and #arr > 0 then
		self["attrLab"]:setString("")
		local labName = ""
		local xlProps = {"Ap", "Dp", "Hp", "Speed", "Double", "ReDouble", "HitRate", "Dodge"}
		local Prop = {}
		for k,v in pairs(arr) do
			Prop[arr[k].key] = arr[k].value
			Prop[arr[k].key.."Max"] = arr[k].maxvalue
		end
		local str = ""
		for k, v in pairs( xlProps ) do
			if Prop[v] then
				str = str .. self:showCuiLianAttr(v, Prop[v], Prop[v.."Max"])
			end
		end
		
		self["attrLab"]:setString(str)
	end
end

---
-- 显示装备淬炼属性
-- @function [parent=#BagEquipInfoUi] showCuiLianAttr
-- @param self
-- @param #string key
-- @param #number value
-- @param #number maxvalue
--
function BagEquipInfoUi:showCuiLianAttr(key, value, maxvalue)
	local str = ""
	local color = ""
	local rate = value / maxvalue
	if rate >= 0 and rate <= 0.25 then 
		color = "<c1>"
	elseif rate > 0.25 and rate <= 0.5 then 
		color = "<c2>"
	elseif rate > 0.5 and rate <= 0.75 then 
		color = "<c3>"
	else
		color = "<c4>"
	end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	if key == "Ap" or key == "Dp" or key == "Hp" or key == "Speed" then 
		str = color .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "+" ..  value .. "  "
	else
		str = color .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "+" ..  value/100 .. "%  " 
	end
	
	return str
end

---
-- 退出界面调用
-- @function [parent=#BagEquipInfoUi] onExit
-- @param self
-- 
function BagEquipInfoUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	BagEquipInfoUi.super.onExit(self)
end
