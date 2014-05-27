---
-- 见闻录协议
-- @module protocol.handler.JianWenLuHandler
--  

local require = require

local moduleName = "protocol.handler.JianWenLuHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 见闻录信息
-- 
GameNet["S2c_jianwen_base_info"] = function( pb )
	local JianWenLuData = require("model.JianWenLuData")
	JianWenLuData.type = pb.jianwen_no
	if( pb.jianwen_no == 1 ) then
		JianWenLuData.updatePartner(pb.infos, pb.max_count)
	elseif( pb.jianwen_no == 2 ) then
		JianWenLuData.updateMartial(pb.infos, pb.max_count)
	elseif( pb.jianwen_no == 3 ) then
		JianWenLuData.updateEquip(pb.infos, pb.max_count)
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 侠客详细信息
-- 
GameNet["S2c_jianwen_one_xk_info"] = function( pb )
	local PartnerInfoView = require("view.jianwenlu.PartnerInfoView")
	if( PartnerInfoView.instance ) then
		PartnerInfoView.instance:showInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 武功详细信息
-- 
GameNet["S2c_jianwen_one_wg_info"] = function( pb )
	local MartialInfoView = require("view.jianwenlu.MartialInfoView")
	if( MartialInfoView.instance ) then
		MartialInfoView.instance:showInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 神兵详细信息
-- 
GameNet["S2c_jianwen_one_sb_info"] = function( pb )
	local ShenBingInfoView = require("view.jianwenlu.ShenBingInfoView")
	if( ShenBingInfoView.instance ) then
		ShenBingInfoView.instance:showInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end










