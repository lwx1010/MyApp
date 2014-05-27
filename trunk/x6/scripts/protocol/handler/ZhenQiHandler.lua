---
-- 真气协议处理
-- @module protocol.handler.ZhenQiHandler
-- 

local require = require
local printf = printf
local pairs = pairs

local moduleName = "protocol.handler.ZhenQiHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 同伴易筋信息
--
GameNet["S2c_zhenqi_partner_info"] = function( pb )
	local PartnerYiJinView = require("view.partner.PartnerYiJinView")
	if( PartnerYiJinView.instance ) then
		PartnerYiJinView.instance:showYiJinInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 真气列表
-- 
GameNet["S2c_zhenqi_list"] = function( pb )
	local ZhenQiData = require("model.ZhenQiData")
	ZhenQiData.updateAllZhenQi(pb.zhenqi_list)
end

---
-- 删除真气
-- 
GameNet["S2c_zhenqi_del"] = function( pb )
	local ZhenQiData = require("model.ZhenQiData")
	ZhenQiData.removeZhenQi(pb.id)
end

---
-- 添加真气
-- 
GameNet["S2c_zhenqi_add"] = function( pb )
	local ZhenQiData = require("model.ZhenQiData")
	ZhenQiData.addZhenQi(pb.info)
end

---
-- 可装备/可替换的真气列表
-- 
GameNet["S2c_zhenqi_partner_equip"] = function( pb )
	local ZhenQiData = require("model.ZhenQiData")
	ZhenQiData.updateCanEquipZhenQi(pb.zhenqi_list)
	
	local ZhenQiSelectView = require("view.partner.ZhenQiSelectView")
	if( ZhenQiSelectView.instance ) then
		ZhenQiSelectView.instance:showZhenQiList()
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 真气属性信息
-- 
GameNet["S2c_zhenqi_baseinfo"] = function( pb )
	local ZhenQiInfoView = require("view.partner.ZhenQiInfoView")
	local Uiid = require("model.Uiid")
	if( pb.ui_id == Uiid.UIID_ZHENQIINFOVIEW ) then
		if( ZhenQiInfoView.instance ) then
			ZhenQiInfoView.instance:showExp(pb.list_info)
			-- 隐藏加载动画
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.hide()
		end
	else
		local pbObj = {}
		pbObj.Id = pb.id
		for k, v in pairs(pb.list_info) do
			if( v.key=="EquipPartnerId" ) then
				pbObj[v.key] = v.value_int
			end
		end
		local ZhenQiData = require("model.ZhenQiData")
		ZhenQiData.updateZhenQi(pbObj)
	end
end

---
-- 修炼结果
-- 
GameNet["S2c_zhenqi_jztx"] = function( pb )
	local JiuZhuanView = require("view.jiuzhuan.JiuZhuanView")
	if( JiuZhuanView.instance ) then
		if( pb.jztx_type == 1 ) then
			JiuZhuanView.instance:showXiuLianResult(pb)
		elseif( pb.jztx_type == 2 ) then
			JiuZhuanView.instance:showTongXuanResult(pb)
		end
	end
end

---
-- 真气升级结果
-- 
GameNet["S2c_zhenqi_upgrade"] = function( pb )
	local ZhenQiUpgradeView = require("view.jiuzhuan.ZhenQiUpgradeView")
	if( ZhenQiUpgradeView.instance ) then
		ZhenQiUpgradeView.instance:updateZqInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 九转通玄消耗信息
-- 
GameNet["S2c_zhenqi_need"] = function( pb )
	local JiuZhuanView = require("view.jiuzhuan.JiuZhuanView")
	if JiuZhuanView.instance then
		JiuZhuanView.instance:setCostInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 九转通玄冷却时间
-- 
GameNet["S2c_zhenqi_jztime"] = function( pb )
	local JiuZhuanView = require("view.jiuzhuan.JiuZhuanView")
	if JiuZhuanView.instance then
		JiuZhuanView.instance:showTime(pb)
	end
end






