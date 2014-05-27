--- 
-- 装备简略信息界面
-- @module view.equip.EquipInfoView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccc3 = ccc3
local tr = tr

local moduleName = "view.equip.EquipInfoView"
module(moduleName)

--- 
-- 类定义
-- @type EquipInfoView
-- 
local EquipInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#EquipInfoView] model.Item#Item _item
-- 
EquipInfoView._item = nil

--- 
-- 构造函数
-- @function [parent=#EquipInfoView] ctor
-- @param self
-- 
function EquipInfoView:ctor()
	EquipInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipInfoView] _create
-- @param self
-- 
function EquipInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_equipinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
--	local EventCenter = require("utils.EventCenter")
--	local ItemEvents = require("model.event.ItemEvents")
--	EventCenter:addEventListener(ItemEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#EquipInfoView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ATTRS_UPDATE event
-- 
function EquipInfoView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._martial  then return end
	if self._martial.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
--		if k == "EquipPartnerId" then
--			if v == 0 then 
--				
--			else
--				local PartnerData = require("model.PartnerData")
--				local PartnerShowConst = require("view.const.PartnerShowConst")
--				local partner = PartnerData.findPartner( self._item.EquipPartnerId )
--				if partner then 
--					self["ownerNameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step] .. partner.Name )
--				else
--					self["ownerNameLab"]:setString("")
--				end
--			end
--		end
		
		if k == "StrengGrade" then
			self["equipIconCcb.lvLab"]:setString("" .. (v or 0) .. "\n")
		end
		
		if k == "Step" then
			local ItemViewConst = require("view.const.ItemViewConst")
			self["equipIconCcb.lvLab"]:setString("  " .. ItemViewConst.SHENBING_STEPS[(v or 0) + 1].. "\n")
			self["equipNameLab"]:setString("<c5>" .. self._item.Name .. ItemViewConst.SHENBING_STEPS[(v or 0) + 1] .. tr("阶"))
		end
	end
end

--- 
-- 点击了关闭
-- @function [parent=#EquipInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function EquipInfoView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 显示装备信息
-- @function [parent=#EquipInfoView] showEquipInfo
-- @param self
-- @param model.Item#Item equip
-- 
function EquipInfoView:showEquipInfo( equip )
	self._item = equip
	
	if not self._item then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local ImageUtil = require("utils.ImageUtil")
	self:changeItemIcon("iconCcb.headPnrSpr", equip.IconNo)
	self:changeFrame("iconCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[equip.Rare])
	self:changeFrame("iconCcb.lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[equip.Rare])
	
	self["equipDescLab"]:setString("")
	
	local str = ""
	local ItemConst = require("model.const.ItemConst")
	if equip.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then 
		str = tr("武器")
	elseif equip.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		str = tr("衣服")
	else 
		str = tr("饰品")
	end
	self["useLvLab"]:setString( tr("使用等级 ").. equip.NeedGrade )
	self["equipTypeLab"]:setString(str)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	if equip.IsShenBing == 1 then 
		self["equipNameLab"]:setString("<c5>" .. equip.Name .. ItemViewConst.SHENBING_STEPS[(equip.Step or 0) + 1] .. tr("阶"))
		self["shenBingSpr"]:setVisible(true)
		self["iconCcb.lvLab"]:setString("  " .. ItemViewConst.SHENBING_STEPS[(equip.Step or 0) + 1].. "\n")
		
		self:getItemUpgradeInfo( self._item.Id, self._item.Step, self._item.SubKind )
	else
		self["equipNameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[equip.Rare] ..  equip.Name)
		self["iconCcb.lvLab"]:setString("" .. (equip.StrengGrade or 0) .. "\n")
		self["shenBingSpr"]:setVisible(false)
		
		self:getItemStrenghtInfo(equip.Id, equip.SubKind)
		
		if equip.CanXl == 1 then 
			self:getItemCuiLianInfo( equip.Id )
		else
			self["cuiLianAttr1Lab"]:setString("")
			self["cuiLianAttr2Lab"]:setString("")
			self["cuiLianAttr3Lab"]:setString("")
			self["cuiLianAttr4Lab"]:setString("")
			self["cuiLianAttr5Lab"]:setString("")
			self["cuiLianAttr6Lab"]:setString("")
		end
	end
end


---
-- 获取强化信息
-- @function [parent=#EquipInfoView] getItem
--
function EquipInfoView:getItemStrenghtInfo( id, subkind )
	local keys = {"StrengProp", "MartialAdd", "StrengGrade"}
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
	local pb = { id = id, key = keys, ui_id = Uiid.UIID_EQUIPINFOVIEW, }
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_baseinfo", pb)
end

---
-- 获取装备淬炼属性
-- @function [parent=#EquipInfoView] getItemCuiLianInfo
-- @param self
-- @param #number id
-- 
function EquipInfoView:getItemCuiLianInfo( id )
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xlprop", {id = id, type = 2})
end

---
-- 获取神兵基础属性和附加属性
-- @function [parent=#EquipInfoView] getItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- 
function EquipInfoView:getItemUpgradeInfo( id, step, subkind )
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
	GameNet.send("C2s_item_baseinfo", {id = id, key = keys, ui_id = Uiid.UIID_EQUIPINFOVIEW,})
	GameNet.send("C2s_item_stepprop", {id = id, step = step})
end

---
-- 显示道具强化信息
-- @function [parent=#EquipInfoView] updateItemStrengInfo
-- @param self
-- @param #number id
-- @param #tabel arr
-- 
function EquipInfoView:updateItemStrengInfo( id, arr )
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
	
	local ItemViewConst = require("view.const.ItemViewConst")
	if item.MartialAdd and #item.MartialAdd > 0 then 
		self["equipDescLab"]:setString(tr("对")..ItemViewConst.MARTIAL_ADD_TYPE[item.MartialAdd[1]]..tr("武学加成伤害")..item.MartialAdd[2]/100 .. "%")
	else
		self["equipDescLab"]:setString("")
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
		
		self["baseAttrLab"]:setString(tr("攻击  ") .. str)
		self["baseAttrAddLab"]:setString("<c2>" .. strAdd)
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
		
		self["baseAttrLab"]:setString(tr("防御  ") .. str)
		self["baseAttrAddLab"]:setString("<c2>" ..strAdd)
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
		self["baseAttrLab"]:setString(tr("生命  ") .. str)
		self["baseAttrAddLab"]:setString("<c2>" ..strAdd)
	end
end

---
-- 显示装备淬炼信息(2是当前的)
-- @function [parent=#EquipInfoView] updateItemCuiLianInfo
-- @param self
-- @param #number id
-- @param #number type
-- @param #tabel arr
-- 
function EquipInfoView:updateItemCuiLianInfo( id, type, arr )
	if not self._item or self._item.Id ~= id then return end 
	
	if type == 2 and #arr > 0 then
		self["cuiLianAttr1Lab"]:setString("")
		self["cuiLianAttr2Lab"]:setString("")
		self["cuiLianAttr3Lab"]:setString("")
		self["cuiLianAttr4Lab"]:setString("")
		self["cuiLianAttr5Lab"]:setString("")
		self["cuiLianAttr6Lab"]:setString("")
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
				labName = "cuiLianAttr" .. index .. "Lab"
				self:showCuiLianAttr(labName, v, Prop[v], Prop[v.."Max"])
				index = index + 1
			end
		end
	end
end

---
-- 显示装备淬炼属性
-- @function [parent=#EquipInfoView] showCuiLianAttr
-- @param self
-- @param #string labName
-- @param #string key
-- @param #number value
-- @param #number maxvalue
--
function EquipInfoView:showCuiLianAttr(labName, key, value, maxvalue)
	local lab = self[labName]
	if not lab then return end
	
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
		lab:setString(color .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +  " ..  value )
	else
		lab:setString(color .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +  " ..  value/100 .. "%" )
	end
	
end
---
-- 显示神兵属性
-- @function [parent=#EquipInfoView] updateItemUpgradeInfo
-- @param self
-- @param #number id
-- @param #number step
-- @param #table info
-- @param #number cost
-- 
function EquipInfoView:updateItemUpgradeInfo( id, step, info, cost )
	if not self._item or not info then return end 
	if self._item.Id ~= id then return end
	
	if self._item.Step == step then
		self["cuiLianAttr1Lab"]:setString("")
		self["cuiLianAttr2Lab"]:setString("")
		self["cuiLianAttr3Lab"]:setString("")
		self["cuiLianAttr4Lab"]:setString("")
		self["cuiLianAttr5Lab"]:setString("")
		self["cuiLianAttr6Lab"]:setString("")
		local labName = ""
		local Prop = {}
		for k,v in pairs(info) do
			Prop[info[k].key] = info[k].value
		end
		local index = 1
		local ItemViewConst = require("view.const.ItemViewConst")		
		for k, v in pairs( ItemViewConst.SHENBING_ADD_KEY ) do
			if Prop[v] then
				labName = "cuiLianAttr" .. index .. "Lab"
				self[labName]:setString("<c5>" .. ItemViewConst.SHENBING_ADD_INFO[v] .. " + " .. Prop[v]/100 .. "%" )
				index = index + 1
			end
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#EquipInfoView] onExit
-- @param self
-- 
function EquipInfoView:onExit()
--	local EventCenter = require("utils.EventCenter")
--	local ItemEvents = require("model.event.ItemEvents")
--	EventCenter:removeEventListener(ItemEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	EquipInfoView.super.onExit(self)
end

