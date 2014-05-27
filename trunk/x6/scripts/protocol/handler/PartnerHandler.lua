---
-- 同伴协议处理
-- @module protocol.handler.PartnerHandler
-- 

local require = require
local printf = printf
local tostring = tostring
local ipairs = ipairs
local pairs = pairs
local tr = tr
local dump = dump

local modalName = "protocol.handler.PartnerHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 同伴列表
-- 
GameNet["S2c_partner_list"] = function( pb )
	local PartnerData = require("model.PartnerData")
	PartnerData.updateAllPartner(pb.partner_list)
end

---
-- 出战同伴列表
-- 
GameNet["S2c_partner_warlist"] = function( pb )
	local PartnerData = require("model.PartnerData")
	PartnerData.updateAllWarPartner(pb.partner_list)
end

---
-- 同伴属性信息
-- 
GameNet["S2c_partner_baseinfo"] = function( pb )
	local Uiid = require("model.Uiid")
	if(pb.ui_id=="") then
		local pbObj = {}
		pbObj["Id"] = pb.id
		for k, v in pairs(pb.list_info) do
			if v then
				if v.type == "string" then
					pbObj[v.key] = v.value_str
				elseif v.type == "number" then
					pbObj[v.key] = v.value_int
				elseif v.type == "table" then
					pbObj[v.key] = v.value_array
				end 
			end
		end
		local PartnerData = require("model.PartnerData")
		PartnerData.updatePartner(pbObj)
		
	elseif(pb.ui_id==Uiid.UIID_PARTNERVIEW) then
		local PartnerView = require("view.partner.PartnerView")
		if(PartnerView.instance) then
			PartnerView.instance:showPartnerInfo(pb.list_info)
		end
	elseif(pb.ui_id==Uiid.UIID_PARTNERINFOVIEW) then
		local PartnerInfoView = require("view.partner.PartnerInfoView")
		if(PartnerInfoView.instance) then
			PartnerInfoView.instance:showCardOtherInfo(pb.list_info)
		end
	
	elseif(pb.ui_id==Uiid.UIID_PARTNERMINUTEINFOVIEW) then
		local PartnerMinuteInfoView = require("view.partner.sub.PartnerMinuteInfoView")
		if(PartnerMinuteInfoView.instance) then
			PartnerMinuteInfoView.instance:showCardOtherInfo(pb.list_info)
		end
	elseif(pb.ui_id==Uiid.UIID_ITEMBATCHUSEVIEW) then
		local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
		if(ItemBatchUseView.instance) then
			ItemBatchUseView.instance:showNeiliInfo(pb.list_info)
		end
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
	
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local PartnerEvents = require("model.event.PartnerEvents")
	local event = PartnerEvents.PARTNER_ATTRS_UPDATED
	event.attrs = attrs
	EventCenter:dispatchEvent(event)
	
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 同伴装备、武学信息
-- 
GameNet["S2c_partner_equip_list"] = function( pb )
	if(pb.equip_type==1) then
		local PartnerEquipUi = require("view.partner.PartnerEquipUi")
		if(PartnerEquipUi.instance) then
			PartnerEquipUi.instance:showItem(pb.equip_list)
		end
	elseif(pb.equip_type==2) then
		local PartnerKongfuUi = require("view.partner.PartnerKongfuUi")
		if(PartnerKongfuUi.instance) then
			PartnerKongfuUi.instance:showItem(pb.equip_list)
		end
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 删除同伴
-- 
GameNet["S2c_partner_del"] = function( pb )
	local PartnerData = require("model.PartnerData")
	PartnerData.removePartner(pb.id)
end

---
-- 添加同伴
-- 
GameNet["S2c_partner_add"] = function( pb )
	local PartnerData = require("model.PartnerData")
	PartnerData.addPartner(pb.info)
end

---
-- 同伴详细信息
-- 
GameNet["S2c_partner_minute_info"] = function( pb )
	local Uiid = require("model.Uiid")
	if(pb.ui_id==Uiid.UIID_PARTNERINFOVIEW) then
		local PartnerInfoView = require("view.partner.PartnerInfoView")
		if(PartnerInfoView.instance) then
			PartnerInfoView.instance:showMinuteInfo(pb)
		end
	elseif(pb.ui_id==Uiid.UIID_PARTNERMINUTEINFOVIEW) then
		local PartnerMinuteInfoView = require("view.partner.sub.PartnerMinuteInfoView")
		if(PartnerMinuteInfoView.instance) then
			PartnerMinuteInfoView.instance:showMinuteInfo(pb)
		end
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

--- 
-- 出售侠客成功
-- 
GameNet["S2c_partner_sell"] = function( pb )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("出售成功！"))
end

--- 
-- 设置上/下阵成功
-- 
GameNet["S2c_partner_set_fight"] = function( pb )
	local PartnerData = require("model.PartnerData")
	local partner = PartnerData.findPartner( pb.id )
	if not partner then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if partner.War and partner.War > 0 then
		FloatNotify.show(tr("成功上阵！"))
	else
		FloatNotify.show(tr("已下阵"))
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 遗忘武学
--
GameNet["S2c_partner_deltalent"] = function( pb )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("操作成功！"))
	
	local PartnerView = require("view.partner.PartnerView")
	PartnerView.instance:updateKongfuInfo(1)
end

---
-- 布阵界面信息
-- 
GameNet["S2c_partner_lineup_info"] = function( pb )
	local BattleFormationView = require("view.formation.BattleFormationView")
	if( BattleFormationView.instance ) then
		BattleFormationView.instance:showPartner(pb.war_info)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 布阵战力结算
--
GameNet["S2c_partner_set_lineup"] = function( pb )
	--pb.score
	local scoreUpMsg = require("view.notify.ScoreUpMsg")
	--local heroAttr = require("model.HeroAttr")
	--heroAttr.BeforeScore = heroAttr.BeforeScore or 0
	if pb.score ~= 0 then
		scoreUpMsg.show(pb.score)
		--heroAttr.Score = pb.score 
	end
end 

