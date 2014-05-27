---
-- 同伴升星协议
-- @module protocol.handler.PartnerUpStarHandler
--

local require = require
local printf = printf

local moduleName = "protocol.handler.PartnerUpStarHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 同伴升星信息
--
GameNet["S2c_parupstar_info"] = function( pb )
	local PartnerShengXingView = require("view.partner.PartnerShengXingView")
	if(PartnerShengXingView.instance) then
		PartnerShengXingView.instance:showUpStarInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 同伴升星是否成功
--
GameNet["S2c_parupstar_upstar"] = function( pb )
	local PartnerShengXingView = require("view.partner.PartnerShengXingView")
	if(PartnerShengXingView.instance) then
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
		PartnerShengXingView.instance:UpStarResult(pb.upstar_result)
	end
end