---
-- 物品协议处理
-- @module protocol.handler.ItemHandler
-- 

local require = require
local printf = printf
local tostring = tostring
local pairs = pairs
local tr = tr
local dump = dump

local modalName = "protocol.handler.ItemHandler"
module(modalName)

local GameNet = require("utils.GameNet")

---
-- 道具列表
--
GameNet["S2c_item_list"] = function( pb )
	local ItemData = require("model.ItemData")
	ItemData.updateAllItems( pb.frame, pb.item_list )
end

---
-- 道具信息更新
--
GameNet["S2c_item_baseinfo"] = function( pb )
--dump(pb)
	local ItemData = require("model.ItemData")
--	printf(#pb.list_info)
	ItemData.updateItemInfo( pb.id, pb.list_info )
	
	local Uiid = require("model.Uiid")
	if pb.ui_id == Uiid.UIID_EQUIPSTRENGTHENVIEW then
		local EquipStrengthenView = require("view.equip.EquipStrengthenView")
		if EquipStrengthenView.instance then
			EquipStrengthenView.instance:updateItemStrengInfo( pb.id, pb.list_info)
		end
	end
	
--	local EquipInfoView = require("view.equip.EquipInfoView")
--	if pb.ui_id == Uiid.UIID_EQUIPINFOVIEW and EquipInfoView.instance then
--		EquipInfoView.instance:updateItemStrengInfo(pb.id, pb.list_info)
--	end
	
	local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
	if pb.ui_id == Uiid.UIID_BAGEQUIPINFOUI and BagEquipInfoUi.instance then
		BagEquipInfoUi.instance:updateItemStrengInfo(pb.id, pb.list_info)
	end
	
	local attrs = {}
	attrs["Id"] = pb.id
	for k, v in pairs(pb.list_info) do 
		if v then
			if v.type == "string" then
				attrs[v.key] = v.value_str
			elseif v.type == "number" then
				attrs[v.key] = v.value_int
			elseif v.type == "table" then
				attrs[v.key] = v.value_array
			end 
		end
	end
	
	-- 根据id发送事件
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local ItemEvents = require("model.event.ItemEvents")
	local event = ItemEvents.ITEM_ATTRS_UPDATED
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
	
	-- 根据no发送事件
	local item = ItemData.findItem(pb.id)
	if not item then return end
	local tbl = {}
	tbl["ItemNo"] = item.ItemNo
	local event1 = ItemEvents.ATTRS_UPDATED_ITEMNO
	event1.attrs = tbl
	EventCenter:dispatchEvent(event1)
end

--- 
-- 删除道具
-- 
GameNet["S2c_item_del"] = function( pb )
	local ItemData = require("model.ItemData")
	ItemData.removeItem( pb.item_id )
end

---
-- 添加新道具
-- 
GameNet["S2c_item_add"] = function( pb )
	local ItemData = require("model.ItemData")
	ItemData.addNewItem(pb.info)
	
	-- 根据no发送事件
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local ItemEvents = require("model.event.ItemEvents")
	local tbl = {}
	tbl["ItemNo"] = pb.info.ItemNo
	local event = ItemEvents.ATTRS_UPDATED_ITEMNO
	event.attrs = tbl
	EventCenter:dispatchEvent(event)
end

---
-- 背包格子数
--
GameNet["S2c_item_frame_info"] = function( pb )
	return
end

---
-- 淬炼属性
--
GameNet["S2c_item_xlprop"] = function( pb )
	local EquipStrengthenView = require("view.equip.EquipStrengthenView")
	if EquipStrengthenView.instance then
		EquipStrengthenView.instance:updateItemCuiLianInfo( pb.id, pb.type, pb.info )
	end
	
--	local EquipInfoView = require("view.equip.EquipInfoView")
--	if EquipInfoView.instance then
--		EquipInfoView.instance:updateItemCuiLianInfo( pb.id, pb.type, pb.info )
--	end
	
	local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
	if BagEquipInfoUi.instance and BagEquipInfoUi.instance:getParent() then
		BagEquipInfoUi.instance:updateItemCuiLianInfo( pb.id, pb.type, pb.info )
	end 
end

---
-- 阶位属性
--
GameNet["S2c_item_stepprop"] = function( pb )
	local EquipStrengthenView = require("view.equip.EquipStrengthenView")
	if EquipStrengthenView.instance then
		EquipStrengthenView.instance:updateItemUpgradeInfo( pb.id, pb.step, pb.info, pb.needcash )
	end
	
--	local EquipInfoView = require("view.equip.EquipInfoView")
--	if EquipInfoView.instance then
--		EquipInfoView.instance:updateItemUpgradeInfo( pb.id, pb.step, pb.info, pb.needcash )
--	end
	
	local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
	if BagEquipInfoUi.instance and BagEquipInfoUi.instance:getParent() then
		BagEquipInfoUi.instance:updateItemUpgradeInfo( pb.id, pb.step, pb.info)
	end
end

---
-- 武学详细信息
-- 
GameNet["S2c_item_martial_skill"] = function( pb )
	--武学信息界面
	local MartialInfoView = require("view.martial.MartialInfoView")
	if MartialInfoView.instance and MartialInfoView.instance:isVisible() and MartialInfoView.instance:isParentsVisible() then
		MartialInfoView.instance:showSkillInfo(pb.id, pb.list_info)
	end
	
	--武学强化界面
	local MartialStrengthenView = require("view.martial.MartialStrengthenView")
	if MartialStrengthenView.instance and MartialStrengthenView.instance:isVisible() and MartialStrengthenView.instance:isParentsVisible() then
		MartialStrengthenView.instance:showSkillInfo(pb.id, pb.list_info)
	end
	
	-- 背包中的武学信息界面
	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	if BagMartialInfoUi.instance and BagMartialInfoUi.instance:getParent() then
		BagMartialInfoUi.instance:showSkillInfo(pb.id, pb.list_info)
	end
end

---
-- 武学升级详细信息
-- 
GameNet["S2c_item_martial_upgradeinfo"] = function( pb )
	local MartialUpgradeView = require("view.martial.MartialUpgradeView")
	if MartialUpgradeView.instance and MartialUpgradeView.instance:isVisible() and MartialUpgradeView.instance:isParentsVisible() then
		MartialUpgradeView.instance:showMartialUpgradeInfo( pb )
	end
	
	local MartialBreakForceView = require("view.martial.MartialBreakForceView")
	if MartialBreakForceView.instance then
		MartialBreakForceView.instance:setNeili( pb.sumneili )
	end
end

--- 
-- 武学突破详细信息
-- 
GameNet["S2c_item_martial_realminfo"] = function( pb )
	local MartialBreakView = require("view.martial.MartialBreakView")
	if MartialBreakView.instance and MartialBreakView.instance:isVisible() and MartialBreakView.instance.isParentsVisible then
		MartialBreakView.instance:showMartialBreakInfo( pb )
	end
	
	local MartialBreakForceView = require("view.martial.MartialBreakForceView")
	if MartialBreakForceView.instance and MartialBreakForceView.instance:isVisible() and MartialBreakForceView.instance:isParentsVisible() then
		MartialBreakForceView.instance:showMartialBreakInfo( pb )
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 穿戴装备/武学结果处理
-- 
GameNet["S2c_item_equip_partner_retult"] = function( pb )
	local PartnerView = require("view.partner.PartnerView")
	if( PartnerView.instance ) then
		if( pb.item_type ==1 ) then
			PartnerView.instance:updateEquipInfo(pb.is_ok)
		elseif( pb.item_type ==2 ) then
			PartnerView.instance:updateKongfuInfo(pb.is_ok)
		end
	end
end

---
-- 卸下装备/武学结果处理
-- 
GameNet["S2c_item_unequip_partner_retult"] = function( pb )
	local PartnerView = require("view.partner.PartnerView")
	if( PartnerView.instance ) then
		if( pb.item_type ==1 ) then
			PartnerView.instance:updateEquipInfo(pb.is_ok)
		elseif( pb.item_type ==2 ) then
			PartnerView.instance:updateKongfuInfo(pb.is_ok)
		end
	end
end

--- 
-- 丢弃成功
-- 
GameNet["S2c_item_drop"] = function( pb )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("丢弃成功！"))
end

--- 
-- 出售成功
-- 
GameNet["S2c_item_sell"] = function( pb )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("出售成功！"))
end












