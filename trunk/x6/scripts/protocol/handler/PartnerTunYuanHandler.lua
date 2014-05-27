---
-- 同伴吞元协议
-- @module protocol.handler.PartnerTunYuanHandler
-- 

local require = require
local printf = printf
local ipairs = ipairs
local pairs = pairs

local moduleName = "protocol.handler.PartnerTunYuanHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 可被吞元的同伴列表
-- 
GameNet["S2c_partner_tunyuan_list"] = function( pb )
	local PartnerTunYuanView = require("view.partner.PartnerTunYuanView")
	if(PartnerTunYuanView.instance) then
		PartnerTunYuanView.instance:showTunYuanList(pb.partner_list)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 同伴吞元结果
-- 
GameNet["S2c_partner_tunyuan_result"] = function( pb )
	local PartnerTunYuanView = require("view.partner.PartnerTunYuanView")
	if(PartnerTunYuanView.instance) then
		PartnerTunYuanView.instance:tunYuanResultHandler(pb.tunyuan_ok)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end


